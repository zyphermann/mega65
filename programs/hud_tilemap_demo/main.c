#include <conio.h>

#include "generated/tilemap_data.h"

#define REG8(address) (*(volatile unsigned char *)(address))

#define VIC_KEY          REG8(0xD02F)
#define VIC_CTRL3        REG8(0xD031)
#define VIC_CTRL2        REG8(0xD030)
#define VIC_MODE         REG8(0xD054)
#define VIC_LINESTEP     REG8(0xD058)
#define VIC_LINESTEP_HI  REG8(0xD059)
#define VIC_SCREEN_LO    REG8(0xD060)
#define VIC_SCREEN_HI    REG8(0xD061)
#define VIC_SCREEN_BANK  REG8(0xD062)
#define VIC_COLOR_LO     REG8(0xD064)
#define VIC_COLOR_HI     REG8(0xD065)
#define BORDER_COLOR     REG8(0xD020)
#define BACKGROUND_COLOR REG8(0xD021)
#define PALETTE_CONTROL  REG8(0xD070)
#define PALETTE_RED      ((volatile unsigned char *)0xD100)
#define PALETTE_GREEN    ((volatile unsigned char *)0xD200)
#define PALETTE_BLUE     ((volatile unsigned char *)0xD300)

#define SCREEN_RAM ((volatile unsigned char *)0x0800)
#define TP_COLOR_RAM ((volatile unsigned char *)0xD800)
#define SCREEN_WIDTH 40
#define SCREEN_HEIGHT 25
#define FCM_DIAGNOSTIC 0
#define DIAGNOSTIC_CHAR 384
#define DIAGNOSTIC_DATA ((volatile unsigned char *)0x6000)
#define KEY_DOWN  0x11
#define KEY_RIGHT 0x1D
#define KEY_UP    0x91
#define KEY_LEFT  0x9D

static void put_tile(unsigned char x, unsigned char y, unsigned int tile)
{
    unsigned int offset = ((unsigned int)y * SCREEN_WIDTH + x) * 2;
    SCREEN_RAM[offset] = (unsigned char)tile;
    SCREEN_RAM[offset + 1] = tile >> 8;
    TP_COLOR_RAM[offset] = 0;
    TP_COLOR_RAM[offset + 1] = 0;
}

static void put_tiles(unsigned char x, unsigned char y,
                      const unsigned int *tiles, unsigned char count)
{
    while (count--) put_tile(x++, y, *tiles++);
}

static void put_decimal(unsigned char x, unsigned char y,
                        unsigned int value, unsigned char digits)
{
    unsigned int divisor = 1;
    unsigned char index;
    for (index = 1; index < digits; ++index) divisor *= 10;
    while (digits--) {
        put_tile(x++, y, tp_white_digits[(value / divisor) % 10]);
        divisor /= 10;
    }
}

static void show_selection(unsigned char column, unsigned char row)
{
    unsigned int code = (unsigned int)row * 32 + column;

    /* Left score is the exact tile code. Right score is row then column. */
    put_decimal(3, 1, code, 6);
    put_decimal(21, 1, row, 2);
    put_decimal(23, 1, column, 2);
    put_tile(18, 2, TP_GALLERY_CHAR_BASE + code);
    put_tile(4 + column, 4 + row, TP_BLACK_CHAR);
}

static void install_original_palette(void)
{
    unsigned char index;
    /* Map palette 0 at $D100-$D3ff and select it for bitmap/text output. */
    PALETTE_CONTROL &= 0x03;
    for (index = 0; index < 16; ++index) {
        PALETTE_RED[16 + index] = tp_character_palette[index][0];
        PALETTE_GREEN[16 + index] = tp_character_palette[index][1];
        PALETTE_BLUE[16 + index] = tp_character_palette[index][2];
    }
}

int main(void)
{
    unsigned int cell;
    unsigned int code;
    unsigned char selected_column = 0;
    unsigned char selected_row = 0;
    unsigned char key;

    clrscr();
    VIC_KEY = 0x47;
    VIC_KEY = 0x53;
    BORDER_COLOR = 0;
    BACKGROUND_COLOR = 0;
    install_original_palette();

    /* 40 columns plus VIC-III attributes, required for two-byte SEAM colour
       cells. FCM is then enabled for both low and high character numbers. */
    VIC_CTRL3 = (VIC_CTRL3 & 0x7F) | 0x20;
    VIC_CTRL2 |= 0x01; /* Expose all 2 KiB of SEAM colour RAM. */
    VIC_SCREEN_LO = 0x00;
    VIC_SCREEN_HI = 0x08;
    VIC_SCREEN_BANK = 0;
    VIC_COLOR_LO = 0;
    VIC_COLOR_HI = 0;
    VIC_LINESTEP = 80;
    VIC_LINESTEP_HI = 0;
    VIC_MODE = (VIC_MODE & 0xF8) | 0x07; /* CHR16 + FCLRLO/HI: 8x8 FCM. */

#if FCM_DIAGNOSTIC
    unsigned char pixel;
    /* No generated assets are involved in this test. Character 384 starts at
       384*64=$6000 and contains a red X on an explicitly black background. */
    for (pixel = 0; pixel < 64; ++pixel) {
        unsigned char x = pixel & 7;
        unsigned char y = pixel >> 3;
        DIAGNOSTIC_DATA[pixel] = (x == y || x == 7 - y) ? 0x18 : 0x10;
    }
    for (cell = 0; cell < SCREEN_WIDTH * 12; ++cell) {
        SCREEN_RAM[cell * 2] = (unsigned char)DIAGNOSTIC_CHAR;
        SCREEN_RAM[cell * 2 + 1] = DIAGNOSTIC_CHAR >> 8;
        TP_COLOR_RAM[cell * 2] = 0;
        TP_COLOR_RAM[cell * 2 + 1] = 0;
    }
    while (1) {
    }
#endif

    for (cell = 0; cell < SCREEN_WIDTH * SCREEN_HEIGHT; ++cell) {
        SCREEN_RAM[cell * 2] = (unsigned char)TP_BLACK_CHAR;
        SCREEN_RAM[cell * 2 + 1] = TP_BLACK_CHAR >> 8;
        TP_COLOR_RAM[cell * 2] = 0;
        TP_COLOR_RAM[cell * 2 + 1] = 0;
    }

    put_tiles(4, 0, tp_red_1up, 4);
    put_tiles(20, 0, tp_red_hi_score, 8);
    for (cell = 0; cell < 6; ++cell) {
        put_tile(3 + cell, 1, tp_white_digits[0]);
        put_tile(21 + cell, 1, tp_white_digits[0]);
    }

    /* Show the complete rotated ROM atlas in its native 32x16 arrangement. */
    code = 0;
    for (cell = 0; cell < 512; ++cell) {
        put_tile(4 + (unsigned char)(cell & 31),
                 4 + (unsigned char)(cell >> 5),
                 TP_GALLERY_CHAR_BASE + code++);
    }

    show_selection(selected_column, selected_row);
    while (1) {
        if (!kbhit()) continue;
        key = cgetc();
        if (key == 'q' || key == 'Q') break;

        put_tile(4 + selected_column, 4 + selected_row,
                 TP_GALLERY_CHAR_BASE +
                 (unsigned int)selected_row * 32 + selected_column);
        if (key == KEY_LEFT) selected_column = (selected_column - 1) & 31;
        else if (key == KEY_RIGHT) selected_column = (selected_column + 1) & 31;
        else if (key == KEY_UP) selected_row = (selected_row - 1) & 15;
        else if (key == KEY_DOWN) selected_row = (selected_row + 1) & 15;
        show_selection(selected_column, selected_row);
    }
    return 0;
}
