#include <conio.h>
#include <stdio.h>
#include <string.h>

#include "time_pilot_colors.h"
#include "../../shared/generated/time-pilot-clouds.h"

#define REG8(address) (*(volatile unsigned char *)(address))

#define VIC_KEY          REG8(0xD02F)
#define SPRITE_X         REG8(0xD000)
#define SPRITE_Y         REG8(0xD001)
#define SPRITE_REGISTERS ((volatile unsigned char *)0xD000)
#define SPRITE_X_MSB     REG8(0xD010)
#define SPRITE_ENABLE    REG8(0xD015)
#define VIC_CTRL1        REG8(0xD011)
#define VIC_RASTER       REG8(0xD012)
#define VIC_IRQ_STATUS   REG8(0xD019)
#define VIC_IRQ_MASK     REG8(0xD01A)
#define BORDER_COLOR     REG8(0xD020)
#define BACKGROUND_COLOR REG8(0xD021)
#define SPRITE_COLORS    ((volatile unsigned char *)0xD027)
#define SPRITE_HEIGHTEN  REG8(0xD055)
#define SPRITE_HEIGHT    REG8(0xD056)
#define SPRITE_X64EN     REG8(0xD057)
#define SPRITE_16EN      REG8(0xD06B)
#define SPRITE_PTR_LOW   REG8(0xD06C)
#define SPRITE_PTR_HIGH  REG8(0xD06D)
#define PALETTE_CONTROL  REG8(0xD070)
#define PALETTE_RED      ((volatile unsigned char *)0xD100)
#define PALETTE_GREEN    ((volatile unsigned char *)0xD200)
#define PALETTE_BLUE     ((volatile unsigned char *)0xD300)

#define SPRITE_DATA_ADDRESS 0x3000
#define SPRITE_DATA(slot) \
    ((unsigned char *)(SPRITE_DATA_ADDRESS + (unsigned int)(slot) * 128))
#define SPRITE_COUNT 8
#define MAX_EVENTS 16
#define BUFFER_COUNT 2
#define SECOND_CLOUD_RASTER 120
#define RESTORE_RASTER 260

/* ABI shared with raster_irq.s. Each buffer has MAX_EVENTS entries. This
   first multiplex proof uses only buffer 0 and therefore never requests a
   swap. Keeping the full ABI lets us add motion/double buffering next. */
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

static const unsigned int sprite_x[SPRITE_COUNT] = {
    48, 128, 208, 288, 80, 160, 240, 320
};

static const unsigned char sprite_y[SPRITE_COUNT] = {
    54, 58, 62, 66, 76, 80, 84, 88
};

static void enable_vic4_registers(void)
{
    VIC_KEY = 0x47;
    VIC_KEY = 0x53;
}

static void install_palette(void)
{
    unsigned char index;
    unsigned char sprite;

    PALETTE_CONTROL &= 0x03;
    for (sprite = 0; sprite < SPRITE_COUNT; ++sprite) {
        for (index = 0; index < CLOUD_PALETTE_SIZE; ++index) {
            PALETTE_RED[sprite * 16 + index] = cloud_palette[index][0] >> 4;
            PALETTE_GREEN[sprite * 16 + index] = cloud_palette[index][1] >> 4;
            PALETTE_BLUE[sprite * 16 + index] = cloud_palette[index][2] >> 4;
        }
    }
    PALETTE_RED[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_RED;
    PALETTE_GREEN[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_GREEN;
    PALETTE_BLUE[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_BLUE;
}

static void show_clouds(void)
{
    unsigned int pointer_table;
    unsigned int x;
    unsigned char sprite;
    unsigned char x_msb = 0;

    /* IMPORTANT: This is the known-good sprite-fetch path.

       We deliberately use the VIC's current classic 8-byte pointer table and
       8-bit pointers into VIC bank 0. Sprite data occupies $3000-$33ff, so
       every pointer is simply address / 64.

       An earlier version relocated the table to $3e00, enabled SPRPTR16 in
       $D06E and placed images at $4000. Although the bytes were present in the
       PRG and copied correctly, that configuration produced missing sprites or
       colourful pixel fragments in xemu. Do not restore that 16-bit path until
       it has its own minimal hardware test. Multiplexing changes only X/Y and
       does not require changing sprite pointers at all. */
    pointer_table = SPRITE_PTR_LOW | ((unsigned int)SPRITE_PTR_HIGH << 8);
    for (sprite = 0; sprite < SPRITE_COUNT; ++sprite) {
        memcpy(SPRITE_DATA(sprite),
               cloud_frames[sprite & 3], CLOUD_FRAME_SIZE);
        ((unsigned char *)pointer_table)[sprite] =
            (SPRITE_DATA_ADDRESS + (unsigned int)sprite * 128) / 64;
        SPRITE_COLORS[sprite] = 0;

        x = sprite_x[sprite];
        SPRITE_REGISTERS[sprite * 2] = (unsigned char)x;
        SPRITE_REGISTERS[sprite * 2 + 1] = sprite_y[sprite];
        if (x & 0x100) x_msb |= 1 << sprite;
    }
    SPRITE_X_MSB = x_msb;
    SPRITE_HEIGHT = 16;
    SPRITE_HEIGHTEN = 0xFF;
    SPRITE_X64EN = 0xFF;
    SPRITE_16EN = 0xFF;
    SPRITE_ENABLE = 0xFF;
}

static void add_event(unsigned char event, unsigned int raster,
                      unsigned char slot, unsigned int x, unsigned char y)
{
    rewrite_raster[event] = (unsigned char)raster;
    rewrite_raster_msb[event] = raster >> 8;
    rewrite_slot[event] = slot;
    rewrite_x[event] = (unsigned char)x;
    rewrite_x_msb[event] = (x & 0x100) != 0;
    rewrite_y[event] = y;
}

static void build_static_multiplex_queue(void)
{
    unsigned char slot;

    /* All eight rewrites share one IRQ after the upper sprites have finished.
       The 9-bit raster event at line 260 restores their upper positions for
       the following frame. Thus eight physical slots draw sixteen clouds. */
    for (slot = 0; slot < SPRITE_COUNT; ++slot) {
        add_event(slot, SECOND_CLOUD_RASTER, slot,
                  (sprite_x[slot] + 44) & 0x01FF,
                  sprite_y[slot] + 112);
        add_event(SPRITE_COUNT + slot, RESTORE_RASTER, slot,
                  sprite_x[slot], sprite_y[slot]);
    }
    rewrite_count[0] = MAX_EVENTS;
    rewrite_count[1] = MAX_EVENTS;
}

static void start_multiplex(void)
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

static void stop_multiplex(void)
{
    __asm__("sei");
    VIC_IRQ_MASK &= 0xFE;
    VIC_IRQ_STATUS = 0x01;
    __asm__("cli");
}

int main(void)
{
    unsigned char key;

    puts("16 CLOUDS - STATIC RASTER REWRITE");
    enable_vic4_registers();
    install_palette();
    BORDER_COLOR = TIME_PILOT_BACKGROUND_INDEX;
    BACKGROUND_COLOR = TIME_PILOT_BACKGROUND_INDEX;
    show_clouds();
    build_static_multiplex_queue();
    start_multiplex();
    puts("8 SLOTS, 16 CLOUDS - Q ENDET");

    while (1) {
        if (kbhit()) {
            key = cgetc();
            if (key == 'q' || key == 'Q') break;
        }
    }

    stop_multiplex();
    SPRITE_ENABLE = 0;
    return 0;
}
