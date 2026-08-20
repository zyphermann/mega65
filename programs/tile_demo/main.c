#include <stdio.h>
#include <string.h>

#include "time_pilot_colors.h"
#include "generated/time_pilot_tile0.h"

#define REG8(address) (*(volatile unsigned char *)(address))

#define VIC_KEY         REG8(0xD02F)
#define SPRITE_X        REG8(0xD000)
#define SPRITE_Y        REG8(0xD001)
#define SPRITE_X_MSB    REG8(0xD010)
#define SPRITE_ENABLE   REG8(0xD015)
#define BORDER_COLOR    REG8(0xD020)
#define BACKGROUND_COLOR REG8(0xD021)
#define SPRITE0_COLOR   REG8(0xD027)
#define SPRITE_HEIGHTEN REG8(0xD055)
#define SPRITE_HEIGHT   REG8(0xD056)
#define SPRITE_X64EN    REG8(0xD057)
#define SPRITE_16EN     REG8(0xD06B)
#define SPRITE_PTR_LOW  REG8(0xD06C)
#define SPRITE_PTR_HIGH REG8(0xD06D)
#define PALETTE_CONTROL REG8(0xD070)
#define PALETTE_RED     ((volatile unsigned char *)0xD100)
#define PALETTE_GREEN   ((volatile unsigned char *)0xD200)
#define PALETTE_BLUE    ((volatile unsigned char *)0xD300)

#define SPRITE_DATA_ADDRESS 0x3000
#define SPRITE_DATA ((unsigned char *)SPRITE_DATA_ADDRESS)

static void enable_vic4_registers(void)
{
    VIC_KEY = 0x47;
    VIC_KEY = 0x53;
}

static void install_palette(void)
{
    unsigned char index;

    /* Map palette bank 0 at $D100-$D3FF and select it for sprites. */
    /* Use palette bank 0 for mapped registers, sprites and text/background. */
    PALETTE_CONTROL &= 0x03;
    for (index = 0; index < TILE_PALETTE_SIZE; ++index) {
        PALETTE_RED[index] = tile_palette[index][0] >> 4;
        PALETTE_GREEN[index] = tile_palette[index][1] >> 4;
        PALETTE_BLUE[index] = tile_palette[index][2] >> 4;
    }
    PALETTE_RED[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_RED;
    PALETTE_GREEN[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_GREEN;
    PALETTE_BLUE[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_BLUE;
}

static void show_tile_as_sprite(void)
{
    unsigned int pointer_table;

    memcpy(SPRITE_DATA, tile_pixels, sizeof(tile_pixels));
    pointer_table = SPRITE_PTR_LOW | ((unsigned int)SPRITE_PTR_HIGH << 8);
    *(unsigned char *)pointer_table = SPRITE_DATA_ADDRESS / 64;

    SPRITE0_COLOR = 0;
    SPRITE_X = 160;
    SPRITE_Y = 100;
    SPRITE_X_MSB &= 0xFE;
    SPRITE_HEIGHT = 16;
    SPRITE_HEIGHTEN |= 0x01;
    SPRITE_X64EN |= 0x01;
    SPRITE_16EN |= 0x01;
    SPRITE_ENABLE |= 0x01;
}

int main(void)
{
    puts("TIME PILOT TILE 0:");
    enable_vic4_registers();
    install_palette();
    BORDER_COLOR = TIME_PILOT_BACKGROUND_INDEX;
    BACKGROUND_COLOR = TIME_PILOT_BACKGROUND_INDEX;
    show_tile_as_sprite();
    puts("SPRITE 0 AT POSITION 160,100");
    return 0;
}
