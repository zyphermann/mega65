#include <conio.h>
#include <string.h>

#include "time_pilot_colors.h"
#include "generated/directions.h"

#define REG8(address) (*(volatile unsigned char *)(address))

#define VIC_KEY          REG8(0xD02F)
#define VIC_CTRL1        REG8(0xD011)
#define VIC_RASTER       REG8(0xD012)
#define SPRITE_X_MSB     REG8(0xD010)
#define SPRITE_ENABLE    REG8(0xD015)
#define SPRITE_Y_EXPAND  REG8(0xD017)
#define SPRITE_X_EXPAND  REG8(0xD01D)
#define VIC_IRQ_STATUS   REG8(0xD019)
#define VIC_IRQ_MASK     REG8(0xD01A)
#define BORDER_COLOR     REG8(0xD020)
#define BACKGROUND_COLOR REG8(0xD021)
#define SPRITE_HEIGHTEN  REG8(0xD055)
#define SPRITE_HEIGHT    REG8(0xD056)
#define SPRITE_X64EN     REG8(0xD057)
#define SPRITE_16EN      REG8(0xD06B)
#define SPRITE_PTR_LOW   REG8(0xD06C)
#define SPRITE_PTR_HIGH  REG8(0xD06D)
#define SPRITE_PTR_BANK  REG8(0xD06E)
#define PALETTE_CONTROL  REG8(0xD070)
#define PALETTE_RED      ((volatile unsigned char *)0xD100)
#define PALETTE_GREEN    ((volatile unsigned char *)0xD200)
#define PALETTE_BLUE     ((volatile unsigned char *)0xD300)
#define SPRITE_REGISTER  ((volatile unsigned char *)0xD000)
#define SPRITE_COLOR     ((volatile unsigned char *)0xD027)

#define SPRITE_POINTER_TABLE_ADDRESS 0x3E00
#define SPRITE_DATA_ADDRESS          0x4400
#define SPRITE_DATA(index) ((unsigned char *)(SPRITE_DATA_ADDRESS + (index) * 128))

#define MAX_EVENTS 16
#define BUFFER_COUNT 2
#define VISIBLE_SLOTS 2
#define FIRST_REWRITE_LINE  100
#define SECOND_REWRITE_LINE 190
#define RESTORE_RASTER_LINE 20

/* Read directly by raster_irq.s. Each buffer occupies MAX_EVENTS entries. */
volatile unsigned char rewrite_event;
volatile unsigned char rewrite_front;
volatile unsigned char rewrite_swap_pending;
volatile unsigned char rewrite_debug_enabled;
volatile unsigned char rewrite_count[BUFFER_COUNT];
volatile unsigned char rewrite_raster[MAX_EVENTS * BUFFER_COUNT];
volatile unsigned char rewrite_raster_msb[MAX_EVENTS * BUFFER_COUNT];
volatile unsigned char rewrite_slot[MAX_EVENTS * BUFFER_COUNT];
volatile unsigned char rewrite_x[MAX_EVENTS * BUFFER_COUNT];
volatile unsigned char rewrite_x_msb[MAX_EVENTS * BUFFER_COUNT];
volatile unsigned char rewrite_y[MAX_EVENTS * BUFFER_COUNT];

static const unsigned int base_x[VISIBLE_SLOTS] = { 70, 230 };
static const unsigned char base_y[VISIBLE_SLOTS] = { 68, 68 };

static void enable_vic4_registers(void)
{
    VIC_KEY = 0x47;
    VIC_KEY = 0x53;
}

static void install_palette(void)
{
    unsigned char index;
    unsigned char slot;

    PALETTE_CONTROL &= 0x03;
    for (slot = 0; slot < VISIBLE_SLOTS; ++slot) {
        for (index = 0; index < FLIGHT_PALETTE_SIZE; ++index) {
            PALETTE_RED[slot * 16 + index] = flight_palette[index][0] >> 4;
            PALETTE_GREEN[slot * 16 + index] = flight_palette[index][1] >> 4;
            PALETTE_BLUE[slot * 16 + index] = flight_palette[index][2] >> 4;
        }
    }
    PALETTE_RED[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_RED;
    PALETTE_GREEN[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_GREEN;
    PALETTE_BLUE[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_BLUE;
}

static void set_sprite_position(unsigned char slot, unsigned int x, unsigned char y)
{
    unsigned char mask = 1 << slot;

    SPRITE_REGISTER[slot * 2] = (unsigned char)x;
    SPRITE_REGISTER[slot * 2 + 1] = y;
    if (x & 0x100) SPRITE_X_MSB |= mask;
    else SPRITE_X_MSB &= ~mask;
}

static void initialise_sprites(void)
{
    unsigned int *pointer_table;
    unsigned char slot;

    pointer_table = (unsigned int *)SPRITE_POINTER_TABLE_ADDRESS;
    SPRITE_PTR_LOW = (unsigned char)SPRITE_POINTER_TABLE_ADDRESS;
    SPRITE_PTR_HIGH = SPRITE_POINTER_TABLE_ADDRESS >> 8;
    SPRITE_PTR_BANK = 0x80;

    for (slot = 0; slot < VISIBLE_SLOTS; ++slot) {
        pointer_table[slot] = (SPRITE_DATA_ADDRESS + (unsigned int)slot * 128) / 64;
        memcpy(SPRITE_DATA(slot), flight_frames[slot * 8], FLIGHT_FRAME_SIZE);
        SPRITE_COLOR[slot] = 0;
        set_sprite_position(slot, base_x[slot], base_y[slot]);
    }

    SPRITE_HEIGHT = 16;
    SPRITE_HEIGHTEN |= 0x03;
    SPRITE_X64EN |= 0x03;
    SPRITE_16EN |= 0x03;
    SPRITE_X_EXPAND &= 0xFC;
    SPRITE_Y_EXPAND &= 0xFC;
    SPRITE_ENABLE |= 0x03;
}

static void add_event(
    unsigned char *event,
    unsigned char base,
    unsigned char raster,
    unsigned char slot,
    unsigned int x,
    unsigned char y)
{
    unsigned char index = base + *event;

    rewrite_raster[index] = raster;
    rewrite_raster_msb[index] = 0;
    rewrite_slot[index] = slot;
    rewrite_x[index] = (unsigned char)x;
    rewrite_x_msb[index] = (x & 0x100) != 0;
    rewrite_y[index] = y;
    ++*event;
}

static void build_buffer(unsigned char buffer, unsigned int movement)
{
    unsigned char base = buffer * MAX_EVENTS;
    unsigned char event = 0;

    /* Cyclic raster order: 100, 190, then 20 in the following frame. */
    add_event(&event, base, FIRST_REWRITE_LINE, 0, 180, 150);
    add_event(&event, base, FIRST_REWRITE_LINE, 1, 290, 150);
    add_event(&event, base, SECOND_REWRITE_LINE, 0, movement, 220);
    add_event(&event, base, SECOND_REWRITE_LINE, 1, 340 - movement, 220);
    add_event(&event, base, RESTORE_RASTER_LINE, 0, base_x[0], base_y[0]);
    add_event(&event, base, RESTORE_RASTER_LINE, 1, base_x[1], base_y[1]);
    rewrite_count[buffer] = event;
}

static void publish_next_frame(unsigned int movement)
{
    unsigned char back;

    __asm__("sei");
    if (rewrite_swap_pending) {
        __asm__("cli");
        return;
    }
    back = rewrite_front ^ 1;
    __asm__("cli");

    /* With pending clear the IRQ cannot swap front while C fills back. */
    build_buffer(back, movement);

    __asm__("sei");
    rewrite_swap_pending = 1;
    __asm__("cli");
}

static void start_raster_rewrites(void)
{
    __asm__("sei");
    rewrite_event = 0;
    rewrite_front = 0;
    rewrite_swap_pending = 0;
    rewrite_debug_enabled = 0;
    VIC_CTRL1 &= 0x7F;
    VIC_RASTER = rewrite_raster[0];
    VIC_IRQ_STATUS = 0x01;
    VIC_IRQ_MASK |= 0x01;
    __asm__("cli");
}

static void stop_raster_rewrites(void)
{
    __asm__("sei");
    VIC_IRQ_MASK &= 0xFE;
    VIC_IRQ_STATUS = 0x01;
    __asm__("cli");
}

static void wait_for_next_frame(void)
{
    while (VIC_RASTER != 0) {
    }
    while (VIC_RASTER == 0) {
    }
}

int main(void)
{
    unsigned int movement = 100;
    signed char velocity = 1;
    unsigned char key;

    clrscr();
    enable_vic4_registers();
    install_palette();
    BORDER_COLOR = TIME_PILOT_BACKGROUND_INDEX;
    BACKGROUND_COLOR = TIME_PILOT_BACKGROUND_INDEX;
    initialise_sprites();

    build_buffer(0, movement);
    build_buffer(1, movement);
    start_raster_rewrites();

    gotoxy(1, 1);
    cprintf("CYCLIC RASTER REWRITE BUFFER");
    gotoxy(1, 2);
    cprintf("2 SLOTS, 6 SPRITES - Q ENDET");

    while (1) {
        if (kbhit()) {
            key = cgetc();
            if (key == 'q' || key == 'Q') break;
        }

        movement += velocity;
        if (movement >= 150) velocity = -1;
        if (movement <= 70) velocity = 1;
        publish_next_frame(movement);
        wait_for_next_frame();
    }

    stop_raster_rewrites();
    SPRITE_ENABLE &= 0xFC;
    return 0;
}
