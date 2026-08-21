#include "hud.h"
#include "generated/score_data.h"
#include "time_pilot_colors.h"

#define REG8(address) (*(volatile unsigned char *)(address))

#define VIC_CTRL2        REG8(0xD030)
#define VIC_CTRL3        REG8(0xD031)
#define VIC_MODE         REG8(0xD054)
#define VIC_LINESTEP     REG8(0xD058)
#define VIC_LINESTEP_HI  REG8(0xD059)
#define VIC_SCREEN_LO    REG8(0xD060)
#define VIC_SCREEN_HI    REG8(0xD061)
#define VIC_SCREEN_BANK  REG8(0xD062)
#define VIC_COLOR_LO     REG8(0xD064)
#define VIC_COLOR_HI     REG8(0xD065)
#define VIC_CHAR_LO      REG8(0xD068)
#define VIC_CHAR_HI      REG8(0xD069)
#define VIC_CHAR_BANK    REG8(0xD06A)
#define PALETTE_CONTROL  REG8(0xD070)
#define PALETTE_RED      ((volatile unsigned char *)0xD100)
#define PALETTE_GREEN    ((volatile unsigned char *)0xD200)
#define PALETTE_BLUE     ((volatile unsigned char *)0xD300)
#define BORDER_COLOR     REG8(0xD020)
#define SCREEN_RAM       ((volatile unsigned char *)0x0800)
#define COLOR_RAM        ((volatile unsigned char *)0xD800)

#define SCREEN_WIDTH 40
#define SCREEN_HEIGHT 25
#define PLAYFIELD_COLUMNS 28
#define HUD_COLUMN 28
#define SCORE_PALETTE_BASE 0xE0

static void put_tile(unsigned char x, unsigned char y, unsigned int tile)
{
    unsigned int offset = ((unsigned int)y * SCREEN_WIDTH + x) * 2;
    SCREEN_RAM[offset] = (unsigned char)tile;
    SCREEN_RAM[offset + 1] = tile >> 8;
    COLOR_RAM[offset] = 0;
    COLOR_RAM[offset + 1] = 0;
}

static void put_tiles(unsigned char x, unsigned char y,
                      const unsigned int *tiles, unsigned char count)
{
    while (count--) put_tile(x++, y, *tiles++);
}

static void put_decimal(unsigned char x, unsigned char y,
                        unsigned long value, unsigned char digits)
{
    unsigned long divisor = 1;
    unsigned char index;
    for (index = 1; index < digits; ++index) divisor *= 10;
    while (digits--) {
        put_tile(x++, y, tp_score_digits[(value / divisor) % 10]);
        divisor /= 10;
    }
}

void tp_hud_set_scores(unsigned long score, unsigned long high_score)
{
    put_decimal(HUD_COLUMN + 3, 3, score, 5);
    put_decimal(HUD_COLUMN + 3, 6, high_score, 5);
}

void tp_hud_initialise(void)
{
    unsigned int cell;
    unsigned char index;
    unsigned char life;

    /* The seven cloud slots occupy palette indices $10-$7f. Keep text and
       sprites in bank 0 and place the 16 HUD colours at the unused $e0-$ef.
       This is simpler and more robust than changing palette banks mid-demo. */
    PALETTE_CONTROL = 0x00;
    PALETTE_RED[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_RED;
    PALETTE_GREEN[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_GREEN;
    PALETTE_BLUE[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_BLUE;
    for (index = 0; index < 16; ++index) {
        PALETTE_RED[SCORE_PALETTE_BASE + index] = tp_score_palette[index][0];
        PALETTE_GREEN[SCORE_PALETTE_BASE + index] = tp_score_palette[index][1];
        PALETTE_BLUE[SCORE_PALETTE_BASE + index] = tp_score_palette[index][2];
    }
    BORDER_COLOR = SCORE_PALETTE_BASE; /* Same opaque black as the HUD. */

    /* 16-bit screen cells and full-colour 8x8 character pixels. */
    VIC_CTRL3 = (VIC_CTRL3 & 0x7F) | 0x20;
    VIC_CTRL2 |= 0x01;
    VIC_SCREEN_LO = 0x00;
    VIC_SCREEN_HI = 0x08;
    VIC_SCREEN_BANK = 0;
    VIC_COLOR_LO = 0;
    VIC_COLOR_HI = 0;
    /* FCM character N begins at CHARPTR + N*64. The generated HUD starts at
       character 384 ($6000 / 64), so the base must be exactly zero instead
       of whichever legacy charset pointer the KERNAL left behind. */
    VIC_CHAR_LO = 0;
    VIC_CHAR_HI = 0;
    VIC_CHAR_BANK = 0;
    VIC_LINESTEP = 80;
    VIC_LINESTEP_HI = 0;
    VIC_MODE = (VIC_MODE & 0xF8) | 0x07;

    for (cell = 0; cell < SCREEN_WIDTH * SCREEN_HEIGHT; ++cell) {
        put_tile((unsigned char)(cell % SCREEN_WIDTH),
                 (unsigned char)(cell / SCREEN_WIDTH),
                 (cell % SCREEN_WIDTH) >= PLAYFIELD_COLUMNS
                     ? TP_SCORE_BLACK_CHAR : TP_SCORE_BLUE_CHAR);
    }
    put_tiles(HUD_COLUMN + 3, 2, tp_score_1up, 4);
    put_tiles(HUD_COLUMN + 1, 5, tp_score_hi_score, 8);
    tp_hud_set_scores(18000, 18000);

    /* Three reserve ships, each assembled from the original 2x2 tm6 tile
       group. They occupy the two rows directly below the left score. */
    for (life = 0; life < 3; ++life) {
        unsigned char x = HUD_COLUMN + 1 + life * 2;
        put_tile(x, 8, tp_score_life[0]);
        put_tile(x + 1, 8, tp_score_life[1]);
        put_tile(x, 9, tp_score_life[2]);
        put_tile(x + 1, 9, tp_score_life[3]);
    }

    put_tiles(HUD_COLUMN + 1, SCREEN_HEIGHT - 1, tp_score_credit, 6);
    put_tile(HUD_COLUMN + 8, SCREEN_HEIGHT - 1, tp_score_digits[0]);
    put_tile(HUD_COLUMN + 9, SCREEN_HEIGHT - 1, tp_score_digits[2]);

    /* Keep CRAM2K active for the complete two-byte colour/attribute map.
       read_cursor_keys() briefly removes this mapping whenever it needs CPU
       access to CIA 1 at $DC00. */
}
