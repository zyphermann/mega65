#include <conio.h>
#include <string.h>

#include "time_pilot_colors.h"
#include "sprite_multiplexer/sprite_multiplexer.h"
#include "../../shared/generated/time-pilot-clouds.h"

#define REG8(address) (*(volatile unsigned char *)(address))
#define VIC_KEY           REG8(0xD02F)
#define VIC_RASTER        REG8(0xD012)
#define SPRITE_X_MSB      REG8(0xD010)
#define SPRITE_ENABLE     REG8(0xD015)
#define SPRITE_Y_EXPAND   REG8(0xD017)
#define SPRITE_MULTICOLOR REG8(0xD01C)
#define SPRITE_X_EXPAND   REG8(0xD01D)
#define BORDER_COLOR      REG8(0xD020)
#define BACKGROUND_COLOR  REG8(0xD021)
#define SPRITE_HEIGHTEN   REG8(0xD055)
#define SPRITE_HEIGHT     REG8(0xD056)
#define SPRITE_X64EN      REG8(0xD057)
#define SPRITE_16EN       REG8(0xD06B)
#define SPRITE_PTR_LOW    REG8(0xD06C)
#define SPRITE_PTR_HIGH   REG8(0xD06D)
#define SPRITE_PTR_BANK   REG8(0xD06E)
#define VIC_HOTREG        REG8(0xD05D)
#define PALETTE_CONTROL   REG8(0xD070)
#define PALETTE_RED       ((volatile unsigned char *)0xD100)
#define PALETTE_GREEN     ((volatile unsigned char *)0xD200)
#define PALETTE_BLUE      ((volatile unsigned char *)0xD300)
#define SPRITE_COLOR      ((volatile unsigned char *)0xD027)

#define POINTER_TABLE_ADDRESS 0x1FF0
#define CLOUD_DATA_ADDRESS    0x1800
#define FORMATIONS_PER_LAYER  12
#define LAYER_COUNT           3
#define FORMATION_COUNT       (FORMATIONS_PER_LAYER * LAYER_COUNT)
#define FIXED_SHIFT           4
#define SCREEN_RIGHT          344
#define SCREEN_LEFT           16

struct Formation {
    long x;
    unsigned char y;
    unsigned char layer;
};

static struct Formation formations[FORMATION_COUNT];
static unsigned int random_state = 0x4D65;

static unsigned char next_random(void)
{
    random_state = random_state * 109U + 89U;
    return (unsigned char)(random_state >> 8);
}

static void enable_vic4(void)
{
    VIC_KEY = 0x47;
    VIC_KEY = 0x53;
}

static void install_palette(void)
{
    unsigned char slot;
    unsigned char color;

    PALETTE_CONTROL &= 0x03;
    for (slot = 0; slot < 8; ++slot) {
        for (color = 0; color < CLOUD_PALETTE_SIZE; ++color) {
            PALETTE_RED[slot * 16 + color] = cloud_palette[color][0] >> 4;
            PALETTE_GREEN[slot * 16 + color] = cloud_palette[color][1] >> 4;
            PALETTE_BLUE[slot * 16 + color] = cloud_palette[color][2] >> 4;
        }
        SPRITE_COLOR[slot] = 0;
    }
    PALETTE_RED[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_RED;
    PALETTE_GREEN[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_GREEN;
    PALETTE_BLUE[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_BLUE;
}

static void initialise_sprite_images(void)
{
    unsigned char frame;

    /* Eight-bit pointers in VIC bank 0 are the stable path used by the other
       demos. Seven immutable Time Pilot components occupy $1800-$1b7f. */
    VIC_HOTREG &= 0x7F;
    SPRITE_PTR_LOW = (unsigned char)POINTER_TABLE_ADDRESS;
    SPRITE_PTR_HIGH = POINTER_TABLE_ADDRESS >> 8;
    SPRITE_PTR_BANK &= 0x7F;
    for (frame = 0; frame < CLOUD_FRAME_COUNT; ++frame) {
        memcpy((unsigned char *)(CLOUD_DATA_ADDRESS +
               (unsigned int)frame * CLOUD_FRAME_SIZE),
               cloud_frames[frame], CLOUD_FRAME_SIZE);
    }

    SPRITE_HEIGHT = 16;
    SPRITE_HEIGHTEN = 0xFF;
    SPRITE_X64EN = 0xFF;
    SPRITE_16EN = 0xFF;
    SPRITE_MULTICOLOR = 0;
    SPRITE_X_EXPAND = 0;
    SPRITE_Y_EXPAND = 0;
    SPRITE_X_MSB = 0;
    SPRITE_ENABLE = 0;
}

static unsigned char image_pointer(unsigned char frame)
{
    return (CLOUD_DATA_ADDRESS + (unsigned int)frame * CLOUD_FRAME_SIZE) / 64;
}

static void initialise_formations(void)
{
    unsigned char layer;
    unsigned char i;
    unsigned char index = 0;

    for (layer = 0; layer < LAYER_COUNT; ++layer) {
        for (i = 0; i < FORMATIONS_PER_LAYER; ++i) {
            formations[index].x =
                (long)(SCREEN_LEFT + (unsigned int)i * 29 +
                       (next_random() & 15)) << FIXED_SHIFT;
            formations[index].y = 30 + (next_random() % 190);
            formations[index].layer = layer;
            ++index;
        }
    }
}

static void submit_component(unsigned int x, unsigned char y,
                             unsigned char frame, unsigned char priority)
{
    if (x < 360)
        smux_add(x, y, image_pointer(frame), priority);
}

static void submit_formations(void)
{
    unsigned char i;
    unsigned int x;
    unsigned char y;
    unsigned char layer;

    smux_begin_frame();
    for (i = 0; i < FORMATION_COUNT; ++i) {
        x = (unsigned int)(formations[i].x >> FIXED_SHIFT);
        y = formations[i].y;
        layer = formations[i].layer;
        if (layer == 0) {
            submit_component(x, y, 5, 1);                  /* distant */
        } else if (layer == 1) {
            submit_component(x, y, 5, 2);                  /* left */
            submit_component(x + 16, y, 6, 2);             /* right */
        } else {
            submit_component(x, y, 0, 3);                  /* left */
            submit_component(x + 16, y, 1, 3);             /* centre */
            submit_component(x + 32, y, 2, 3);             /* right */
        }
    }
}

static void move_formations(void)
{
    static const unsigned char speed[LAYER_COUNT] = { 5, 11, 19 };
    unsigned char i;
    unsigned char width;

    for (i = 0; i < FORMATION_COUNT; ++i) {
        formations[i].x -= speed[formations[i].layer];
        width = 16 + formations[i].layer * 16;
        if ((formations[i].x >> FIXED_SHIFT) < -(signed int)width) {
            formations[i].x =
                (long)(SCREEN_RIGHT + (next_random() & 63)) << FIXED_SHIFT;
            formations[i].y = 30 + (next_random() % 190);
        }
    }
}

static void wait_frame(void)
{
    while (VIC_RASTER != 0) {}
    while (VIC_RASTER == 0) {}
}

int main(void)
{
    unsigned char key;
    unsigned char debug = 0;

    clrscr();
    enable_vic4();
    install_palette();
    initialise_sprite_images();
    initialise_formations();
    BORDER_COLOR = TIME_PILOT_BACKGROUND_INDEX;
    BACKGROUND_COLOR = TIME_PILOT_BACKGROUND_INDEX;

    submit_formations();
    smux_start();

    textcolor(1);
    gotoxy(1, 1);
    cprintf("GENERIC SPRITE MULTIPLEXER");
    gotoxy(1, 2);
    cprintf("D DEBUG  Q ENDET");

    while (1) {
        if (kbhit()) {
            key = cgetc();
            if (key == 'q' || key == 'Q') break;
            if (key == 'd' || key == 'D') {
                debug ^= 1;
                smux_set_debug(debug);
                if (!debug) BORDER_COLOR = TIME_PILOT_BACKGROUND_INDEX;
            }
        }

        move_formations();
        submit_formations();
        smux_build_and_publish();
        gotoxy(1, 3);
        cprintf("IN:%03u DRAW:%03u DROP:%03u ",
                smux_submitted_count(), smux_scheduled_count(),
                smux_dropped_count());
        wait_frame();
    }

    smux_stop();
    return 0;
}
