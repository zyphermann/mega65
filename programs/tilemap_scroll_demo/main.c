#include <conio.h>
#include <string.h>

#define TIME_PILOT_FONT_INCLUDE_DEMO
#include "generated/time-pilot-font.h"
#include "tilebuffer/tilebuffer.h"

#define REG8(address) (*(volatile unsigned char *)(address))

#define VIC_RASTER        REG8(0xD012)
#define VIC_CTRL1         REG8(0xD011)
#define BORDER_COLOR      REG8(0xD020)
#define BACKGROUND_COLOR  REG8(0xD021)
#define VIC_KEY           REG8(0xD02F)
#define VIC_CRAME         REG8(0xD030)
#define VIC_CTRL3         REG8(0xD031)
#define VIC_TEXT_X_LO     REG8(0xD04C)
#define VIC_TEXT_X_HI     REG8(0xD04D)
#define VIC_TEXT_Y_LO     REG8(0xD04E)
#define VIC_TEXT_Y_HI     REG8(0xD04F)
#define VIC_MODE          REG8(0xD054)
#define VIC_LINESTEP      REG8(0xD058)
#define VIC_LINESTEP_HI   REG8(0xD059)
#define VIC_HOTREG        REG8(0xD05D)
#define VIC_CHRCOUNT      REG8(0xD05E)
#define VIC_SCREEN_LO     REG8(0xD060)
#define VIC_SCREEN_HI     REG8(0xD061)
#define VIC_SCREEN_BANK   REG8(0xD062)
#define VIC_SCREEN_MB     REG8(0xD063)
#define VIC_COLOR_LO      REG8(0xD064)
#define VIC_COLOR_HI      REG8(0xD065)
#define VIC_ROWS          REG8(0xD07B)
#define CPU_MEMORY_CONFIG REG8(0x0001)
#define PALETTE_CONTROL   REG8(0xD070)
#define PALETTE_RED       ((volatile unsigned char *)0xD100)
#define PALETTE_GREEN     ((volatile unsigned char *)0xD200)
#define PALETTE_BLUE      ((volatile unsigned char *)0xD300)
#define CIA1_PORT_A       REG8(0xDC00)
#define CIA1_PORT_B       REG8(0xDC01)
#define CIA1_DDR_A        REG8(0xDC02)
#define CIA1_DDR_B        REG8(0xDC03)
#define IMMEDIATE_KEYS    REG8(0xD60F)
#define MODIFIER_KEYS     REG8(0xD611)

/* The logical map is exactly 2 x 2 screens. The physical VIC map adds one
   visible screen on the right and bottom. Those margins mirror the opposite
   map edges, so every wrapped 40 x 25 view is contiguous in memory.
   One additional column/row supplies the partially visible fine-scroll tile. */
#define MAP_WIDTH          80
#define MAP_HEIGHT         50
#define VIEW_WIDTH         40
#define VIEW_HEIGHT        25
#define FETCH_WIDTH        (VIEW_WIDTH + 1)
#define FETCH_HEIGHT       (VIEW_HEIGHT + 1)
#define PHYSICAL_WIDTH     (MAP_WIDTH + FETCH_WIDTH)
#define PHYSICAL_HEIGHT    (MAP_HEIGHT + FETCH_HEIGHT)
#define PHYSICAL_BYTES     (PHYSICAL_WIDTH * PHYSICAL_HEIGHT * 2)

#define MAP_DATA           ((unsigned char *)0x1000)
#define SCREEN_DATA        ((unsigned char *)0x6000)
#define SCREEN_ADDRESS     0x6000U
#define TILE_DATA          ((unsigned char *)0xB000)
#define COLOR_RAM_LINEAR   0x0FF80000L

#define TILE_HATCH_A       0
#define TILE_TEXT_BASE     4
#define TILE_BLANK         11
#define TILE_ANIMATION     12
#define TILE_DIGIT_BASE    13
#define TILE_COUNT         (TILE_DIGIT_BASE + 10)
#define TILE_CHAR_BASE     (0xB000 / 64)

#define PROFILE_REGISTERS_COLOR 2
#define PROFILE_LOGIC_COLOR     6

#define CONTROL_LEFT       0x01
#define CONTROL_RIGHT      0x02
#define CONTROL_UP         0x04
#define CONTROL_DOWN       0x08
#define CONTROL_SPACE      0x10

struct DmaList {
    unsigned char option_0b;
    unsigned char option_80;
    unsigned char source_mb;
    unsigned char option_81;
    unsigned char destination_mb;
    unsigned char end_options;
    unsigned char command;
    unsigned int count;
    unsigned int source;
    unsigned char source_bank;
    unsigned int destination;
    unsigned char destination_bank;
    unsigned char subcommand;
    unsigned int modulo;
};

static struct DmaList dma_list;
static TileBuffer tilemap;
static unsigned char previous_space;
static unsigned char animation_clock;
static unsigned int text_x_origin;
static unsigned int text_y_origin;

static void enable_vic4(void)
{
    VIC_KEY = 0x47;
    VIC_KEY = 0x53;
}

static unsigned char info_glyph(char character)
{
    if (character >= '0' && character <= '9') return character - '0';
    switch (character) {
        case 'A': return 10; case 'D': return 11; case 'E': return 12;
        case 'F': return 13; case 'I': return 14; case 'L': return 15;
        case 'M': return 16; case 'O': return 17; case 'P': return 18;
        case 'R': return 19; case 'S': return 20; case 'X': return 21;
        case 'T': return 23; case 'Y': return 24;
        default: return 22;
    }
}

static unsigned char glyph_pixel(char character, unsigned char x,
                                 unsigned char y)
{
    unsigned char glyph = info_glyph(character);
    unsigned char packed = time_pilot_demo_glyphs[glyph]
        [(unsigned int)y * 4 + (x >> 1)];
    return ((x & 1) ? packed & 0x0F : packed >> 4) ? 1 : 0;
}

static void build_tileset(void)
{
    static const char label[] = "LAYER 1";
    unsigned char tile;
    unsigned char y;
    unsigned char x;

    memset(TILE_DATA, 0, TILE_COUNT * 64);
    for (tile = 0; tile < 4; ++tile) {
        for (y = 0; y < 8; ++y) {
            unsigned char world_y = ((tile >> 1) * 8 + y) & 15;
            for (x = 0; x < 8; ++x) {
                unsigned char world_x = ((tile & 1) * 8 + x) & 15;
                TILE_DATA[(unsigned int)tile * 64 + (unsigned int)y * 8 + x] =
                    (world_x == 0 || world_x == 15 ||
                     world_y == 0 || world_y == 15) ? 3 : 0;
            }
        }
    }
    for (tile = 0; tile < 7; ++tile) {
        char character = label[tile];
        for (y = 0; y < 8; ++y)
            for (x = 0; x < 8; ++x)
                TILE_DATA[(unsigned int)(TILE_TEXT_BASE + tile) * 64 +
                    (unsigned int)y * 8 + x] = character == ' ' ? 0 :
                        glyph_pixel(character, x, y);
    }
    for (y = 0; y < 8; ++y)
        for (x = 0; x < 8; ++x)
            TILE_DATA[(unsigned int)TILE_ANIMATION * 64 +
                (unsigned int)y * 8 + x] =
                    (x == y || x + y == 7) ? 2 : 0;
    for (tile = 0; tile < 10; ++tile)
        for (y = 0; y < 8; ++y)
            for (x = 0; x < 8; ++x)
                TILE_DATA[(unsigned int)(TILE_DIGIT_BASE + tile) * 64 +
                    (unsigned int)y * 8 + x] = glyph_pixel('0' + tile, x, y);
}

static void put_map_label(unsigned char map_x, unsigned char map_y)
{
    unsigned char x;
    for (x = 0; x < 7; ++x)
        tilebuffer_set(&tilemap, map_x + x, map_y, TILE_TEXT_BASE + x);
}

static void put_map_number(unsigned char map_x, unsigned char map_y,
                           unsigned char value)
{
    tilebuffer_set(&tilemap, map_x, map_y, TILE_DIGIT_BASE + value / 10);
    tilebuffer_set(&tilemap, map_x + 1, map_y,
                   TILE_DIGIT_BASE + value % 10);
}

static void build_map(void)
{
    unsigned char x;
    unsigned char y;
    unsigned int offset = 0;

    tilebuffer_init_sized(&tilemap, MAP_DATA, MAP_WIDTH, MAP_HEIGHT, 8, 8);
    tilebuffer_set_mode(&tilemap, TILEBUFFER_WRAP);
    tilebuffer_set_blank(&tilemap, TILE_BLANK);
    for (y = 0; y < MAP_HEIGHT; ++y)
        for (x = 0; x < MAP_WIDTH; ++x)
            MAP_DATA[offset++] = (y & 1) * 2 + (x & 1);

    put_map_label(10, 8);
    put_map_label(52, 12);
    put_map_label(28, 22);
    put_map_label(64, 30);
    put_map_label(8, 40);
    put_map_label(44, 46);

    /* Horizontal and vertical rulers make map wrapping easy to verify. */
    for (x = 0; x + 1 < MAP_WIDTH; x += 3) {
        unsigned char value = x / 3 + 1;
        put_map_number(x, 0, value);
        if (x + 2 < MAP_WIDTH)
            tilebuffer_set(&tilemap, x + 2, 0, TILE_BLANK);
    }
    for (y = 0; y < MAP_HEIGHT; ++y)
        put_map_number(0, y, y + 1);
}

static void build_physical_map(void)
{
    unsigned char *destination = SCREEN_DATA;
    unsigned int physical_y;
    unsigned int logical_y = 0;

    for (physical_y = 0; physical_y < PHYSICAL_HEIGHT; ++physical_y) {
        unsigned int physical_x;
        unsigned int logical_x = 0;
        unsigned char *source = MAP_DATA + logical_y * MAP_WIDTH;
        for (physical_x = 0; physical_x < PHYSICAL_WIDTH; ++physical_x) {
            unsigned int character = TILE_CHAR_BASE + source[logical_x];
            *destination++ = (unsigned char)character;
            *destination++ = (unsigned char)(character >> 8);
            if (++logical_x == MAP_WIDTH) logical_x = 0;
        }
        if (++logical_y == MAP_HEIGHT) logical_y = 0;
    }
}

static void update_physical_tile(unsigned int logical_x,
                                 unsigned int logical_y,
                                 unsigned char tile)
{
    unsigned int physical_y;
    unsigned int character = TILE_CHAR_BASE + tile;

    for (physical_y = logical_y;
         physical_y < PHYSICAL_HEIGHT; physical_y += MAP_HEIGHT) {
        unsigned int physical_x;
        for (physical_x = logical_x;
             physical_x < PHYSICAL_WIDTH; physical_x += MAP_WIDTH) {
            unsigned int offset =
                (physical_y * PHYSICAL_WIDTH + physical_x) * 2;
            SCREEN_DATA[offset] = (unsigned char)character;
            SCREEN_DATA[offset + 1] = (unsigned char)(character >> 8);
        }
    }
}

static void install_palette(void)
{
    PALETTE_CONTROL &= 0x03;
    PALETTE_RED[0] = PALETTE_GREEN[0] = PALETTE_BLUE[0] = 0;
    PALETTE_RED[1] = PALETTE_GREEN[1] = PALETTE_BLUE[1] = 15;
    PALETTE_RED[2] = 15; PALETTE_GREEN[2] = 0; PALETTE_BLUE[2] = 0;
    PALETTE_RED[3] = 0; PALETTE_GREEN[3] = 5; PALETTE_BLUE[3] = 15;
    PALETTE_RED[4] = 0; PALETTE_GREEN[4] = 15; PALETTE_BLUE[4] = 0;
    PALETTE_RED[5] = 0; PALETTE_GREEN[5] = 15; PALETTE_BLUE[5] = 15;
    PALETTE_RED[6] = 15; PALETTE_GREEN[6] = 7; PALETTE_BLUE[6] = 0;
}

static void clear_color_ram(void)
{
    long destination = COLOR_RAM_LINEAR;
    dma_list.option_0b = 0x0B;
    dma_list.option_80 = 0x80;
    dma_list.source_mb = 0;
    dma_list.option_81 = 0x81;
    dma_list.destination_mb = (unsigned char)(destination >> 20);
    dma_list.end_options = 0;
    dma_list.command = 3;
    dma_list.count = PHYSICAL_BYTES;
    dma_list.source = 0;
    dma_list.source_bank = 0;
    dma_list.destination = (unsigned int)destination;
    dma_list.destination_bank = (unsigned char)((destination >> 16) & 0x0F);
    dma_list.subcommand = 0;
    dma_list.modulo = 0;
    REG8(0xD702) = 0;
    REG8(0xD704) = 0;
    REG8(0xD701) = (unsigned int)&dma_list >> 8;
    REG8(0xD705) = (unsigned int)&dma_list;
}

static void write_text_x(unsigned int value)
{
    VIC_TEXT_X_LO = (unsigned char)value;
    VIC_TEXT_X_HI = (VIC_TEXT_X_HI & 0xF0) |
        (unsigned char)((value >> 8) & 0x0F);
}

static void write_text_y(unsigned int value)
{
    VIC_TEXT_Y_LO = (unsigned char)value;
    VIC_TEXT_Y_HI = (VIC_TEXT_Y_HI & 0xF0) |
        (unsigned char)((value >> 8) & 0x0F);
}

static void apply_scroll_registers(void)
{
    unsigned int offset =
        (tilemap.origin_y * PHYSICAL_WIDTH + tilemap.origin_x) * 2;
    unsigned int screen = SCREEN_ADDRESS + offset;

    VIC_SCREEN_LO = (unsigned char)screen;
    VIC_SCREEN_HI = (unsigned char)(screen >> 8);
    VIC_SCREEN_BANK = 0;
    VIC_SCREEN_MB &= 0xF0;
    VIC_COLOR_LO = (unsigned char)offset;
    VIC_COLOR_HI = (unsigned char)(offset >> 8);
    write_text_x(text_x_origin - ((unsigned int)tilemap.fine_x << 1));
    write_text_y(text_y_origin - ((unsigned int)tilemap.fine_y << 1));
}

static void clamp_scroll_to_view(void)
{
    unsigned int max_x = (MAP_WIDTH - VIEW_WIDTH) * 8;
    unsigned int max_y = (MAP_HEIGHT - VIEW_HEIGHT) * 8;

    if (tilemap.mode != TILEBUFFER_CLAMP) return;
    if (tilemap.scroll_x > max_x) tilemap.scroll_x = max_x;
    if (tilemap.scroll_y > max_y) tilemap.scroll_y = max_y;
    tilemap.origin_x = tilemap.scroll_x >> 3;
    tilemap.origin_y = tilemap.scroll_y >> 3;
    tilemap.fine_x = tilemap.scroll_x & 7;
    tilemap.fine_y = tilemap.scroll_y & 7;
}

static void wait_frame(void)
{
    while (VIC_RASTER == 0 && !(VIC_CTRL1 & 0x80)) {}
    while (VIC_RASTER != 0 || (VIC_CTRL1 & 0x80)) {}
}

static unsigned char read_controls(void)
{
    unsigned char port_a = CIA1_PORT_A;
    unsigned char ddr_a = CIA1_DDR_A;
    unsigned char ddr_b = CIA1_DDR_B;
    unsigned char control = VIC_CRAME;
    unsigned char cursor_right;
    unsigned char cursor_down;
    unsigned char space;
    unsigned char result = 0;

    VIC_CRAME = control & 0xFE;
    CIA1_DDR_A = 0xFF;
    CIA1_DDR_B = 0;
    CIA1_PORT_A = 0xFE;
    cursor_right = !(CIA1_PORT_B & 0x04);
    cursor_down = !(CIA1_PORT_B & 0x80);
    CIA1_PORT_A = 0x7F;
    space = !(CIA1_PORT_B & 0x10);
    CIA1_PORT_A = port_a;
    CIA1_DDR_A = ddr_a;
    CIA1_DDR_B = ddr_b;
    VIC_CRAME = control;

    if ((IMMEDIATE_KEYS & 0x01) ||
        (cursor_right && (MODIFIER_KEYS & 0x03))) result |= CONTROL_LEFT;
    else if (cursor_right) result |= CONTROL_RIGHT;
    if ((IMMEDIATE_KEYS & 0x02) ||
        (cursor_down && (MODIFIER_KEYS & 0x03))) result |= CONTROL_UP;
    else if (cursor_down) result |= CONTROL_DOWN;
    if (space) result |= CONTROL_SPACE;
    return result;
}

int main(void)
{
    clrscr();
    __asm__("sei");
    enable_vic4();
    CPU_MEMORY_CONFIG = 0x35;
    install_palette();
    build_tileset();
    build_map();
    build_physical_map();
    clear_color_ram();

    BORDER_COLOR = 0;
    BACKGROUND_COLOR = 0;
    VIC_CTRL3 = (VIC_CTRL3 & 0x7F) | 0x60;
    VIC_CRAME |= 0x01;
    VIC_SCREEN_BANK = 0;
    VIC_SCREEN_MB = 0;
    VIC_LINESTEP = (unsigned char)(PHYSICAL_WIDTH * 2);
    VIC_LINESTEP_HI = (PHYSICAL_WIDTH * 2) >> 8;
    VIC_CHRCOUNT = FETCH_WIDTH;
    VIC_ROWS = FETCH_HEIGHT - 1;
    VIC_MODE = (VIC_MODE & 0xF8) | 0x07;

    VIC_HOTREG &= 0x7F;
    text_x_origin = VIC_TEXT_X_LO |
        ((unsigned int)(VIC_TEXT_X_HI & 0x0F) << 8);
    text_y_origin = VIC_TEXT_Y_LO |
        ((unsigned int)(VIC_TEXT_Y_HI & 0x0F) << 8);
    apply_scroll_registers();

    while (1) {
        unsigned char controls;
        unsigned char space;
        int scroll_dx = 0;
        int scroll_dy = 0;

        wait_frame();
        BORDER_COLOR = PROFILE_REGISTERS_COLOR;
        apply_scroll_registers();

        BORDER_COLOR = PROFILE_LOGIC_COLOR;
        controls = read_controls();
        space = controls & CONTROL_SPACE;
        if (space && !previous_space) {
            tilebuffer_set_mode(&tilemap,
                tilemap.mode == TILEBUFFER_WRAP ?
                TILEBUFFER_CLAMP : TILEBUFFER_WRAP);
            clamp_scroll_to_view();
        }
        previous_space = space;

        ++animation_clock;
        if (!(animation_clock & 31)) {
            unsigned char tile =
                MAP_DATA[(unsigned int)20 * MAP_WIDTH + 30] == TILE_ANIMATION ?
                TILE_HATCH_A : TILE_ANIMATION;
            tilebuffer_set(&tilemap, 30, 20, tile);
            update_physical_tile(30, 20, tile);
        }

        if (controls & CONTROL_LEFT) --scroll_dx;
        if (controls & CONTROL_RIGHT) ++scroll_dx;
        if (controls & CONTROL_UP) --scroll_dy;
        if (controls & CONTROL_DOWN) ++scroll_dy;
        tilebuffer_scroll(&tilemap, scroll_dx, scroll_dy);
        clamp_scroll_to_view();
        BORDER_COLOR = 0;
    }
}
