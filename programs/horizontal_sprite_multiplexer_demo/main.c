#include <conio.h>
#include <string.h>

#include "time_pilot_colors.h"
#include "../../shared/generated/time-pilot-clouds.h"

#define REG8(address) (*(volatile unsigned char *)(address))
#define VIC_KEY           REG8(0xD02F)
#define VIC_CTRL_C        REG8(0xD054)
#define VIC_RASTER        REG8(0xD012)
#define VIC_IRQ_STATUS    REG8(0xD019)
#define VIC_IRQ_MASK      REG8(0xD01A)
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
#define SPRITE_TILE_LOW   REG8(0xD04D)
#define PALETTE_CONTROL   REG8(0xD070)
#define PALETTE_RED       ((volatile unsigned char *)0xD100)
#define PALETTE_GREEN     ((volatile unsigned char *)0xD200)
#define PALETTE_BLUE      ((volatile unsigned char *)0xD300)
#define SPRITE_REGISTER   ((volatile unsigned char *)0xD000)
#define SPRITE_COLOR      ((volatile unsigned char *)0xD027)

#define POINTER_TABLE_ADDRESS 0x1FF0
#define SPRITE_DATA_ADDRESS   0x1800
#define SPRITE_Y               100
#define FIRST_X                 20
#define X_SPACING               36
static unsigned int sprite_x = FIRST_X;
static unsigned char tiled = 1;

static void enable_vic4(void)
{
    VIC_KEY = 0x47;
    VIC_KEY = 0x53;
    VIC_CTRL_C |= 0x40; /* Full 40.5 MHz is essential for racing the beam. */
}

static void install_palette(void)
{
    unsigned char color;

    PALETTE_CONTROL &= 0x03;
    for (color = 0; color < CLOUD_PALETTE_SIZE; ++color) {
        PALETTE_RED[color] = cloud_palette[color][0] >> 4;
        PALETTE_GREEN[color] = cloud_palette[color][1] >> 4;
        PALETTE_BLUE[color] = cloud_palette[color][2] >> 4;
    }
    PALETTE_RED[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_RED;
    PALETTE_GREEN[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_GREEN;
    PALETTE_BLUE[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_BLUE;
}

static void initialise_sprite(void)
{
    unsigned char *pointer_table = (unsigned char *)POINTER_TABLE_ADDRESS;

    VIC_HOTREG &= 0x7F;
    SPRITE_PTR_LOW = (unsigned char)POINTER_TABLE_ADDRESS;
    SPRITE_PTR_HIGH = POINTER_TABLE_ADDRESS >> 8;
    SPRITE_PTR_BANK &= 0x7F;
    memcpy((unsigned char *)SPRITE_DATA_ADDRESS,
           cloud_frames[5], CLOUD_FRAME_SIZE);
    pointer_table[0] = SPRITE_DATA_ADDRESS / 64;

    SPRITE_REGISTER[0] = FIRST_X;
    SPRITE_REGISTER[1] = SPRITE_Y;
    SPRITE_X_MSB &= 0xFE;
    SPRITE_COLOR[0] = 0;
    SPRITE_HEIGHT = 16;
    SPRITE_HEIGHTEN = 0x01;
    SPRITE_X64EN = 0x01;
    SPRITE_16EN = 0x01;
    SPRITE_MULTICOLOR &= 0xFE;
    SPRITE_X_EXPAND &= 0xFE;
    SPRITE_Y_EXPAND &= 0xFE;
    SPRITE_ENABLE = 0x01;
    /* VIC-IV hardware repeats the sprite's ringbuffer to the right edge. */
    SPRITE_TILE_LOW |= 0x10;
}

static void set_sprite_x(unsigned int x)
{
    SPRITE_REGISTER[0] = (unsigned char)x;
    if (x & 0x100) SPRITE_X_MSB |= 0x01;
    else SPRITE_X_MSB &= 0xFE;
}

static void wait_frame(void)
{
    while (VIC_RASTER != 0) {}
    while (VIC_RASTER == 0) {}
}

int main(void)
{
    unsigned char key;

    clrscr();
    enable_vic4();
    install_palette();
    initialise_sprite();
    BORDER_COLOR = TIME_PILOT_BACKGROUND_INDEX;
    BACKGROUND_COLOR = TIME_PILOT_BACKGROUND_INDEX;

    gotoxy(1, 1);
    cprintf("HORIZONTAL TILE TEST V2");
    gotoxy(1, 2);
    cprintf("LINKS/RECHTS: START  D: TILE EIN/AUS");

    while (1) {
        gotoxy(1, 3);
        cprintf("1 HW-SPRITE  X:%03u  TILE:%s ",
                sprite_x, tiled ? "AN " : "AUS");
        if (kbhit()) {
            key = cgetc();
            if (key == 'q' || key == 'Q') break;
            if ((key == CH_CURS_LEFT || key == '-') && sprite_x >= 8)
                sprite_x -= 8;
            if ((key == CH_CURS_RIGHT || key == '+') && sprite_x <= 312)
                sprite_x += 8;
            set_sprite_x(sprite_x);
            if (key == 'd' || key == 'D') {
                tiled ^= 1;
                if (tiled) SPRITE_TILE_LOW |= 0x10;
                else SPRITE_TILE_LOW &= 0x0F;
            }
        }
        wait_frame();
    }

    SPRITE_TILE_LOW &= 0x0F;
    SPRITE_ENABLE = 0;
    return 0;
}
