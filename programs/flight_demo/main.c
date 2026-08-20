#include <cbm.h>
#include <conio.h>
#include <string.h>

#include "time_pilot_colors.h"
#include "../../shared/generated/time-pilot-clouds.h"
#ifndef FLIGHT_DIRECTIONS_HEADER
#define FLIGHT_DIRECTIONS_HEADER "generated/directions.h"
#endif
#include FLIGHT_DIRECTIONS_HEADER

#define REG8(address) (*(volatile unsigned char *)(address))

#define VIC_KEY         REG8(0xD02F)
#define SPRITE_X        REG8(0xD000)
#define SPRITE_Y        REG8(0xD001)
#define SPRITE_X_MSB    REG8(0xD010)
#define SPRITE_ENABLE   REG8(0xD015)
#define SPRITE_Y_EXPAND REG8(0xD017)
#define SPRITE_X_EXPAND REG8(0xD01D)
#define BORDER_COLOR    REG8(0xD020)
#define BACKGROUND_COLOR REG8(0xD021)
#define SPRITE0_COLOR   REG8(0xD027)
#define SPRITE_HEIGHTEN REG8(0xD055)
#define SPRITE_HEIGHT   REG8(0xD056)
#define SPRITE_X64EN    REG8(0xD057)
#define SPRITE_16EN     REG8(0xD06B)
#define SPRITE_PTR_LOW  REG8(0xD06C)
#define SPRITE_PTR_HIGH REG8(0xD06D)
#define SPRITE_PTR_BANK REG8(0xD06E)
#define PALETTE_CONTROL REG8(0xD070)
#define PALETTE_RED     ((volatile unsigned char *)0xD100)
#define PALETTE_GREEN   ((volatile unsigned char *)0xD200)
#define PALETTE_BLUE    ((volatile unsigned char *)0xD300)
#define RASTER_LINE     REG8(0xD012)
#define IMMEDIATE_KEYS  REG8(0xD60F)
#define MODIFIER_KEYS   REG8(0xD611)
#define CIA1_PORT_A     REG8(0xDC00)
#define CIA1_PORT_B     REG8(0xDC01)
#define CIA1_DDR_A      REG8(0xDC02)
#define CIA1_DDR_B      REG8(0xDC03)

#define SPRITE_POINTER_TABLE_ADDRESS 0x3E00
#define SPRITE_DATA_ADDRESS 0x4400
#define SPRITE_DATA ((unsigned char *)SPRITE_DATA_ADDRESS)
#define CLOUD_DATA_ADDRESS 0x4000
#define CLOUD_DATA(index) ((unsigned char *)(CLOUD_DATA_ADDRESS + ((unsigned int)(index) * 128)))

#define SCREEN_LEFT 24
#define SCREEN_RIGHT 344
#define SPRITE_SIZE 16
#define WRAP_LEFT (SCREEN_LEFT - SPRITE_SIZE)
#define WRAP_RIGHT SCREEN_RIGHT
#define Y_COORDINATE_RANGE (256 << 3)
#define CLOUD_COUNT 7
#define CLOUD_FIXED_SHIFT 8
#define TURN_FRAME_INTERVAL 2
#define KEY_HELD_LEFT  0x01
#define KEY_HELD_RIGHT 0x02
#ifndef FOREGROUND_CLOUD_COUNT
#define FOREGROUND_CLOUD_COUNT 3
#endif
#define FOREGROUND_CLOUD_MASK ((1 << (FOREGROUND_CLOUD_COUNT + 1)) - 2)

/* Clockwise, beginning at east. Values use 3 fractional bits. */
#define DIRECTION_COUNT 32
#define SOUTH 8
#define WEST 16
#define NORTH 24

static const signed char vectors[DIRECTION_COUNT][2] = {
    { 8, 0}, { 8, 2}, { 7, 3}, { 7, 4}, { 6, 6}, { 4, 7}, { 3, 7}, { 2, 8},
    { 0, 8}, {-2, 8}, {-3, 7}, {-4, 7}, {-6, 6}, {-7, 4}, {-7, 3}, {-8, 2},
    {-8, 0}, {-8,-2}, {-7,-3}, {-7,-4}, {-6,-6}, {-4,-7}, {-3,-7}, {-2,-8},
    { 0,-8}, { 2,-8}, { 3,-7}, { 4,-7}, { 6,-6}, { 7,-4}, { 7,-3}, { 8,-2}
};

struct Cloud {
    long x;
    long y;
    unsigned char speed;
    unsigned char size;
};

static struct Cloud clouds[CLOUD_COUNT];
static unsigned int random_state = 0xACE1;

static unsigned char random_byte(void)
{
    unsigned char bit;

    bit = random_state & 1;
    random_state >>= 1;
    if (bit) random_state ^= 0xB400;
    return (unsigned char)random_state;
}

static unsigned char read_cursor_keys(void)
{
    unsigned char keys = 0;
    unsigned char cursor_right;
    unsigned char port_a;
    unsigned char ddr_a;
    unsigned char ddr_b;

    /* C64/C65 matrix row 0, column 2 is Cursor Right. */
    __asm__("sei");
    port_a = CIA1_PORT_A;
    ddr_a = CIA1_DDR_A;
    ddr_b = CIA1_DDR_B;
    CIA1_DDR_A = 0xFF;
    CIA1_DDR_B = 0x00;
    CIA1_PORT_A = 0xFE;
    cursor_right = !(CIA1_PORT_B & 0x04);
    CIA1_PORT_A = port_a;
    CIA1_DDR_A = ddr_a;
    CIA1_DDR_B = ddr_b;
    __asm__("cli");

    /* Xemu/C64 encodes Cursor Left as Shift + Cursor Right. */
    if ((IMMEDIATE_KEYS & 0x01) || (cursor_right && (MODIFIER_KEYS & 0x03))) {
        keys |= KEY_HELD_LEFT;
    } else if (cursor_right) {
        keys |= KEY_HELD_RIGHT;
    }
    return keys;
}

static void enable_vic4_registers(void)
{
    VIC_KEY = 0x47;
    VIC_KEY = 0x53;
}

static void install_palette(void)
{
    unsigned char index;
    unsigned char sprite;

    /* Use palette bank 0 for mapped registers, sprites and text/background. */
    PALETTE_CONTROL &= 0x03;
    for (index = 0; index < FLIGHT_PALETTE_SIZE; ++index) {
        PALETTE_RED[index] = flight_palette[index][0] >> 4;
        PALETTE_GREEN[index] = flight_palette[index][1] >> 4;
        PALETTE_BLUE[index] = flight_palette[index][2] >> 4;
    }
    PALETTE_RED[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_RED;
    PALETTE_GREEN[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_GREEN;
    PALETTE_BLUE[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_BLUE;

    for (sprite = 1; sprite <= CLOUD_COUNT; ++sprite) {
        for (index = 0; index < CLOUD_PALETTE_SIZE; ++index) {
            PALETTE_RED[sprite * 16 + index] = cloud_palette[index][0] >> 4;
            PALETTE_GREEN[sprite * 16 + index] = cloud_palette[index][1] >> 4;
            PALETTE_BLUE[sprite * 16 + index] = cloud_palette[index][2] >> 4;
        }
    }
}

static void initialise_sprite(void)
{
    unsigned int *pointer_table;
    unsigned char index;
    unsigned int address;

    SPRITE_PTR_LOW = (unsigned char)SPRITE_POINTER_TABLE_ADDRESS;
    SPRITE_PTR_HIGH = SPRITE_POINTER_TABLE_ADDRESS >> 8;
    SPRITE_PTR_BANK = 0x80; /* 16-bit pointers, pointer table in bank 0. */
    pointer_table = (unsigned int *)SPRITE_POINTER_TABLE_ADDRESS;
    pointer_table[0] = SPRITE_DATA_ADDRESS / 64;
    for (index = 0; index <= CLOUD_COUNT; ++index) {
        ((volatile unsigned char *)0xD027)[index] = 0;
    }
    for (index = 0; index < CLOUD_COUNT; ++index) {
        address = CLOUD_DATA_ADDRESS + (unsigned int)index * 128;
        pointer_table[index + 1] = address / 64;
        memcpy(CLOUD_DATA(index), cloud_frames[index & 3], CLOUD_FRAME_SIZE);
    }
    SPRITE_HEIGHT = 16;
    SPRITE_HEIGHTEN = 0xFF;
    SPRITE_X64EN = 0xFF;
    SPRITE_16EN = 0xFF;
    SPRITE_X_EXPAND = (SPRITE_X_EXPAND & 0x01) | FOREGROUND_CLOUD_MASK;
    SPRITE_Y_EXPAND = (SPRITE_Y_EXPAND & 0x01) | FOREGROUND_CLOUD_MASK;
    SPRITE_ENABLE = 0xFF;
}

static void set_sprite_position(unsigned int x, unsigned char y)
{
    SPRITE_X = (unsigned char)x;
    if (x & 0x100) {
        SPRITE_X_MSB |= 0x01;
    } else {
        SPRITE_X_MSB &= 0xFE;
    }
    SPRITE_Y = y;
}

static void set_cloud_position(unsigned char index, long x, long y)
{
    unsigned char sprite;
    unsigned int screen_x;

    sprite = index + 1;
    screen_x = (unsigned int)(x >> CLOUD_FIXED_SHIFT) & 0x01FF;
    ((volatile unsigned char *)0xD000)[sprite * 2] = (unsigned char)screen_x;
    ((volatile unsigned char *)0xD001)[sprite * 2] = (unsigned char)(y >> CLOUD_FIXED_SHIFT);
    if (screen_x & 0x100) {
        SPRITE_X_MSB |= 1 << sprite;
    } else {
        SPRITE_X_MSB &= ~(1 << sprite);
    }
}

static void randomise_cloud_y(struct Cloud *cloud)
{
    cloud->y = (long)(32 + (random_byte() % 192)) << CLOUD_FIXED_SHIFT;
}

static void initialise_clouds(void)
{
    unsigned char index;

    for (index = 0; index < CLOUD_COUNT; ++index) {
        clouds[index].size = index < FOREGROUND_CLOUD_COUNT ? 32 : 16;
        clouds[index].speed = index < FOREGROUND_CLOUD_COUNT ? 24 : 8;
        clouds[index].x = (long)(40 + index * 47) << CLOUD_FIXED_SHIFT;
        randomise_cloud_y(&clouds[index]);
        set_cloud_position(index, clouds[index].x, clouds[index].y);
    }
}

static void update_clouds(unsigned char direction)
{
    unsigned char index;
    struct Cloud *cloud;
    long left_limit;
    long right_limit;

    for (index = 0; index < CLOUD_COUNT; ++index) {
        cloud = &clouds[index];
        cloud->x -= (long)vectors[direction][0] * cloud->speed;
        cloud->y -= (long)vectors[direction][1] * cloud->speed;

        left_limit = (long)(SCREEN_LEFT - cloud->size) << CLOUD_FIXED_SHIFT;
        right_limit = (long)SCREEN_RIGHT << CLOUD_FIXED_SHIFT;
        if (vectors[direction][0] > 0 && cloud->x < left_limit) {
            cloud->x = (long)(SCREEN_RIGHT + (random_byte() & 63)) << CLOUD_FIXED_SHIFT;
            randomise_cloud_y(cloud);
        } else if (vectors[direction][0] < 0 && cloud->x > right_limit) {
            cloud->x = (long)(SCREEN_LEFT - cloud->size - (random_byte() & 63)) << CLOUD_FIXED_SHIFT;
            randomise_cloud_y(cloud);
        }

        while (cloud->y < 0) cloud->y += (long)256 << CLOUD_FIXED_SHIFT;
        while (cloud->y >= ((long)256 << CLOUD_FIXED_SHIFT)) {
            cloud->y -= (long)256 << CLOUD_FIXED_SHIFT;
        }
        set_cloud_position(index, cloud->x, cloud->y);
    }
}

static void select_direction(unsigned char direction)
{
    const unsigned char *source;
    unsigned char source_index;
    unsigned char row;
    unsigned char column;
    unsigned char value;

    if (direction >= SOUTH && direction <= NORTH) {
        source_index = NORTH - direction;
        memcpy(SPRITE_DATA, flight_frames[source_index], FLIGHT_FRAME_SIZE);
        return;
    }

    /* Mirror the left half of the rotation to produce the right half. */
    source_index = (direction + SOUTH) & 31;
    source = flight_frames[source_index];
    for (row = 0; row < 16; ++row) {
        for (column = 0; column < 8; ++column) {
            value = source[row * 8 + (7 - column)];
            SPRITE_DATA[row * 8 + column] = (value << 4) | (value >> 4);
        }
    }
}

static void wait_for_next_frame(void)
{
    while (RASTER_LINE != 0) {
    }
    while (RASTER_LINE == 0) {
    }
}

int main(void)
{
    unsigned char direction = 0;
#ifdef TIMEPILOT_CENTERED
    int x = 176 << 3;
    int y = 128 << 3;
#else
    int x = SCREEN_LEFT << 3;
    int y = 120 << 3;
#endif
    unsigned char key;
    unsigned char held_keys;
    unsigned char turn_frames = 0;

    clrscr();
    enable_vic4_registers();
    install_palette();
    BORDER_COLOR = TIME_PILOT_BACKGROUND_INDEX;
    BACKGROUND_COLOR = TIME_PILOT_BACKGROUND_INDEX;
    initialise_sprite();
    initialise_clouds();
    select_direction(direction);

    while (1) {
        held_keys = read_cursor_keys();
        if (held_keys == KEY_HELD_LEFT || held_keys == KEY_HELD_RIGHT) {
            if (turn_frames == 0) {
                if (held_keys == KEY_HELD_LEFT) {
                    direction = (direction - 1) & 31;
                } else {
                    direction = (direction + 1) & 31;
                }
                select_direction(direction);
                turn_frames = TURN_FRAME_INTERVAL - 1;
            } else {
                --turn_frames;
            }
        } else {
            turn_frames = 0;
        }

        if (kbhit()) {
            key = cgetc();
            if (key == 'q' || key == 'Q') {
                break;
            }
        }

        update_clouds(direction);

#ifndef TIMEPILOT_CENTERED
        x += vectors[direction][0];
        y += vectors[direction][1];
        if (x > (WRAP_RIGHT << 3) && vectors[direction][0] > 0) x = WRAP_LEFT << 3;
        if (x < (WRAP_LEFT << 3) && vectors[direction][0] < 0) x = WRAP_RIGHT << 3;
        /* The VIC sprite Y coordinate is 8-bit. Preserve its natural 255/0 wrap. */
        if (y >= Y_COORDINATE_RANGE) y -= Y_COORDINATE_RANGE;
        if (y < 0) y += Y_COORDINATE_RANGE;
#endif

        set_sprite_position((unsigned int)(x >> 3), (unsigned char)(y >> 3));
        wait_for_next_frame();
    }

    SPRITE_ENABLE &= 0xFE;
    return 0;
}
