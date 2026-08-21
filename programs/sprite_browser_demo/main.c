#include <conio.h>
#include <string.h>

#include "generated/browser_data.h"

#define REG8(address) (*(volatile unsigned char *)(address))
#define VIC_KEY REG8(0xD02F)
#define VIC_CTRL3 REG8(0xD031)
#define VIC_CTRL2 REG8(0xD030)
#define VIC_MODE REG8(0xD054)
#define VIC_LINESTEP REG8(0xD058)
#define VIC_LINESTEP_HI REG8(0xD059)
#define VIC_SCREEN_LO REG8(0xD060)
#define VIC_SCREEN_HI REG8(0xD061)
#define VIC_SCREEN_BANK REG8(0xD062)
#define VIC_COLOR_LO REG8(0xD064)
#define VIC_COLOR_HI REG8(0xD065)
#define BORDER_COLOR REG8(0xD020)
#define BACKGROUND_COLOR REG8(0xD021)
#define PALETTE_CONTROL REG8(0xD070)
#define PALETTE_RED ((volatile unsigned char *)0xD100)
#define PALETTE_GREEN ((volatile unsigned char *)0xD200)
#define PALETTE_BLUE ((volatile unsigned char *)0xD300)
#define SPRITE_ENABLE REG8(0xD015)
#define SPRITE_X_MSB REG8(0xD010)
#define SPRITE_Y_EXPAND REG8(0xD017)
#define SPRITE_MULTICOLOR REG8(0xD01C)
#define SPRITE_X_EXPAND REG8(0xD01D)
#define SPRITE_HEIGHTEN REG8(0xD055)
#define SPRITE_HEIGHT REG8(0xD056)
#define SPRITE_X64EN REG8(0xD057)
#define SPRITE_16EN REG8(0xD06B)
#define SPRITE_PTR_LOW REG8(0xD06C)
#define SPRITE_PTR_HIGH REG8(0xD06D)
#define SPRITE_PTR_BANK REG8(0xD06E)
#define VIC_HOTREG REG8(0xD05D)
#define SPRITE_COLOR REG8(0xD027)
#define SPRITE_X REG8(0xD000)
#define SPRITE_Y REG8(0xD001)
#define CPU_MEMORY_CONFIG REG8(0x0001)

#define SCREEN_RAM ((volatile unsigned char *)0x0800)
#define TP_COLOR_RAM ((volatile unsigned char *)0xD800)
#define SCREEN_WIDTH 40
#define SCREEN_HEIGHT 25
#define SPRITE_ROM_FIRST ((const unsigned char *)0x8000)
#define SPRITE_ROM_SECOND ((const unsigned char *)0x4000)
#define SPRITE_POINTER_TABLE_ADDRESS 0x3E00
#define SPRITE_DATA_ADDRESS 0x3F00
#define SPRITE_DATA ((unsigned char *)SPRITE_DATA_ADDRESS)
#define SPRITE_BYTES 128
#define PALETTE_COUNT 8
#define KEY_DOWN 0x11
#define KEY_RIGHT 0x1D
#define KEY_UP 0x91
#define KEY_LEFT 0x9D

static const unsigned char fallback_palettes[PALETTE_COUNT][3][3] = {
    {{14,14,14}, {12,0,12}, {0,5,15}},
    {{15,15,15}, {15,2,2}, {15,12,0}},
    {{15,15,15}, {0,15,4}, {0,8,15}},
    {{15,15,15}, {15,7,0}, {15,0,12}},
    {{12,15,15}, {2,9,15}, {0,3,10}},
    {{15,15,10}, {8,15,0}, {0,9,5}},
    {{15,13,10}, {10,5,2}, {15,8,0}},
    {{15,15,15}, {9,9,9}, {3,3,3}}
};

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

static void install_text_palette(void)
{
    unsigned char i;
    for (i = 0; i < 16; ++i) {
        PALETTE_RED[16 + i] = tp_character_palette[i][0];
        PALETTE_GREEN[16 + i] = tp_character_palette[i][1];
        PALETTE_BLUE[16 + i] = tp_character_palette[i][2];
    }
}

static void select_palette(unsigned char palette)
{
    unsigned char pixel;
    PALETTE_RED[0] = PALETTE_GREEN[0] = PALETTE_BLUE[0] = 0;
    for (pixel = 1; pixel < 4; ++pixel) {
        PALETTE_RED[pixel] = fallback_palettes[palette][pixel - 1][0];
        PALETTE_GREEN[pixel] = fallback_palettes[palette][pixel - 1][1];
        PALETTE_BLUE[pixel] = fallback_palettes[palette][pixel - 1][2];
    }
    put_decimal(23, 5, palette, 3);
}

static void select_sprite(unsigned char code)
{
    unsigned char memory_config = CPU_MEMORY_CONFIG;
    const unsigned char *source;

    if (code < 128) {
        /* Codes 0..127 live under BASIC ROM at $8000-$bfff. */
        source = SPRITE_ROM_FIRST + (unsigned int)code * SPRITE_BYTES;
        CPU_MEMORY_CONFIG = 0x35;
    } else {
        /* Codes 128..255 are deliberately linked at plain RAM $4000-$7fff. */
        source = SPRITE_ROM_SECOND + (unsigned int)(code - 128) * SPRITE_BYTES;
    }
    memcpy(SPRITE_DATA, source, SPRITE_BYTES);
    CPU_MEMORY_CONFIG = memory_config;
    put_decimal(22, 4, code, 3);
}

static void initialise_video(void)
{
    unsigned int cell;
    unsigned char *pointer_table;
    unsigned char slot;

    VIC_KEY = 0x47;
    VIC_KEY = 0x53;
    BORDER_COLOR = 0;
    BACKGROUND_COLOR = 0;
    PALETTE_CONTROL &= 0x03;
    install_text_palette();

    VIC_CTRL3 = (VIC_CTRL3 & 0x7F) | 0x20;
    VIC_CTRL2 |= 0x01;
    VIC_SCREEN_LO = 0x00;
    VIC_SCREEN_HI = 0x08;
    VIC_SCREEN_BANK = 0;
    VIC_COLOR_LO = VIC_COLOR_HI = 0;
    VIC_LINESTEP = 80;
    VIC_LINESTEP_HI = 0;
    VIC_MODE = (VIC_MODE & 0xF8) | 0x07;

    for (cell = 0; cell < SCREEN_WIDTH * SCREEN_HEIGHT; ++cell)
        put_tile(cell % SCREEN_WIDTH, cell / SCREEN_WIDTH, TP_BLACK_CHAR);
    put_tiles(4, 0, tp_red_1up, 4);
    put_tiles(20, 0, tp_red_hi_score, 8);
    for (cell = 0; cell < 6; ++cell) {
        put_tile(3 + cell, 1, tp_white_digits[0]);
        put_tile(21 + cell, 1, tp_white_digits[0]);
    }
    put_tiles(15, 4, tp_white_sprite, 6);
    put_tiles(14, 5, tp_white_palette, 7);

    /* Start from a fully known sprite state. Xemu can otherwise retain old
       slot positions and expansion bits while loading a new PRG. */
    SPRITE_ENABLE = 0;
    SPRITE_HEIGHTEN = 0;
    SPRITE_X64EN = 0;
    SPRITE_16EN = 0;
    SPRITE_MULTICOLOR = 0;
    SPRITE_X_EXPAND = 0;
    SPRITE_Y_EXPAND = 0;
    SPRITE_X_MSB = 0;
    VIC_HOTREG &= 0x7F;
    /* The default pointer table sits at the end of screen memory. In CHR16
       mode that is four two-byte FCM cells, so writing eight pointers visibly
       corrupts four tiles. Keep the table in its own safe RAM page. */
    SPRITE_PTR_LOW = (unsigned char)SPRITE_POINTER_TABLE_ADDRESS;
    SPRITE_PTR_HIGH = SPRITE_POINTER_TABLE_ADDRESS >> 8;
    SPRITE_PTR_BANK &= 0x7F;
    pointer_table = (unsigned char *)SPRITE_POINTER_TABLE_ADDRESS;
    for (slot = 0; slot < 8; ++slot) {
        pointer_table[slot] = 0;
        ((volatile unsigned char *)0xD000)[slot * 2] = 0;
        ((volatile unsigned char *)0xD001)[slot * 2] = 0;
        ((volatile unsigned char *)0xD027)[slot] = 0;
    }
    /* Classic sprite pointers are only eight bits wide. $3f00 is the final
       128-byte-aligned image inside VIC bank 0; $4000 would wrap to $0000. */
    pointer_table[0] = SPRITE_DATA_ADDRESS / 64;
    SPRITE_COLOR = 0;
    SPRITE_X = 176;
    SPRITE_Y = 112;
    SPRITE_X_MSB &= 0xFE;
    SPRITE_HEIGHT = 16;
    SPRITE_HEIGHTEN = 0x01;
    SPRITE_X64EN = 0x01;
    SPRITE_16EN = 0x01;
    SPRITE_MULTICOLOR &= 0xFE;
    SPRITE_X_EXPAND |= 0x01;
    SPRITE_Y_EXPAND |= 0x01;
    SPRITE_ENABLE = 0x01;
}

int main(void)
{
    unsigned char sprite = 0;
    unsigned char palette = 0;
    unsigned char key;

    clrscr();
    initialise_video();
    select_palette(palette);
    select_sprite(sprite);
    while (1) {
        if (!kbhit()) continue;
        key = cgetc();
        if (key == 'q' || key == 'Q') break;
        if (key == KEY_LEFT) select_sprite(--sprite);
        else if (key == KEY_RIGHT) select_sprite(++sprite);
        else if (key == KEY_UP) {
            palette = (palette - 1) & (PALETTE_COUNT - 1);
            select_palette(palette);
        } else if (key == KEY_DOWN) {
            palette = (palette + 1) & (PALETTE_COUNT - 1);
            select_palette(palette);
        }
    }
    SPRITE_ENABLE = 0;
    return 0;
}
