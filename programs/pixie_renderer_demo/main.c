#include <conio.h>
#include <string.h>

#define TIME_PILOT_FONT_INCLUDE_DEMO
#include "generated/time-pilot-font.h"
#include "generated/time-pilot-parachutists.h"
#include "pixie_renderer/pixie_renderer.h"
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
#define VIC_XPOS          REG8(0xD051)
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
#define KEYBOARD_MATRIX   REG8(0xD613)
#define KEYBOARD_ROW      REG8(0xD614)
#define SPRITE_ENABLE     REG8(0xD015)

/* Same logical world as tilemap_scroll_demo. This program keeps its own RRB
   buffers and never changes the native tilemap demo. */
#define MAP_WIDTH          80
#define MAP_HEIGHT         50
#define VIEW_WIDTH         40
#define VIEW_HEIGHT        25
#define FETCH_WIDTH        (VIEW_WIDTH + 1)
#define FETCH_HEIGHT       (VIEW_HEIGHT + 1)
#define MAP_DATA           ((unsigned char *)0x1000)
#define TILE_CHAR_ADDRESS  0xE800U
#define PIXIE_CHAR_DATA    ((unsigned char *)0xB000)
#define FRAME0_SCREEN      ((unsigned char *)0x6800)
#define FRAME0_COLOR       ((unsigned char *)0x7A00)
#define FRAME1_SCREEN      ((unsigned char *)0x8C00)
#define FRAME1_COLOR       ((unsigned char *)0x9E00)
/* Build the tiles in the not-yet-used framebuffer.  A DMA copy below places
   them into chip RAM even when ROM is still mapped over $E800 for the CPU. */
#define TILE_DATA          FRAME0_SCREEN
#define ENCODED_MAP_ADDRESS 0xC800U
#define ENCODED_MAP_ROW_BYTES (MAP_WIDTH * 2)
#define ENCODED_MAP_BYTES  (MAP_HEIGHT * ENCODED_MAP_ROW_BYTES)
#define ENCODED_BLANK_ROW_ADDRESS (ENCODED_MAP_ADDRESS + ENCODED_MAP_BYTES)
#define ENCODED_ROW_STAGING FRAME0_SCREEN
#define COLOR_RAM_LINEAR   0x0FF80000L
#define PIXIE_OBJECT_DATA  ((PixieObject *)0x0400)
#define PIXIE_Y2_DATA      ((int *)0x0B00)
#define PIXIE_SPEED_DATA   ((unsigned char *)0x0C00)

#define TILE_HATCH_A       0
#define TILE_TEXT_BASE     4
#define TILE_BLANK         11
#define TILE_ANIMATION     12
#define TILE_DIGIT_BASE    13
#define TILE_COUNT         (TILE_DIGIT_BASE + 10)
#define TILE_DATA_BYTES    ((TILE_COUNT + TIME_PILOT_DEMO_GLYPH_COUNT) * 64)
#define TILE_CHAR_BASE     (TILE_CHAR_ADDRESS / 64)
#define JUMPER_CHAR_BASE   (0xB000 / 64)
#define JUMPER_PHASES      8
#define JUMPER_SLICES      3

#define ROW_COUNT          PIXIE_RENDER_ROWS
#define ROW_BYTES          PIXIE_RENDER_ROW_BYTES
#define ENTRIES_PER_ROW    PIXIE_RENDER_ENTRIES
#define TILEMAP_PREFIX_ENTRIES (FETCH_WIDTH + 1)
#define INITIAL_PIXIES     24
#define MAX_PIXIES         128
#define PIXIE_COUNT_STEP   4
#define MAX_DIRTY_TILES    16
#define BOTH_FRAME_BUFFERS 0x03

#define PROFILE_INPUT_COLOR 4
#define PROFILE_MOTION_COLOR 5
#define PROFILE_BUILD_COLOR 6
#define PROFILE_PIXIE_COLOR 7
#define PROFILE_DMA_COLOR   8

#define CONTROL_LEFT       0x01
#define CONTROL_RIGHT      0x02
#define CONTROL_UP         0x04
#define CONTROL_DOWN       0x08
#define CONTROL_SPACE      0x10
#define CONTROL_PLUS       0x20
#define CONTROL_MINUS      0x40

#define pixies PIXIE_OBJECT_DATA
#define pixie_y2 PIXIE_Y2_DATA
#define pixie_speed PIXIE_SPEED_DATA

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

struct DirtyTile {
    unsigned char x;
    unsigned char y;
    unsigned char pending_buffers;
};

static struct DmaList dma_list;
static TileBuffer tilemap;
static unsigned char active_pixie_count = INITIAL_PIXIES;
static unsigned char previous_controls;
static unsigned char animation_clock;
static unsigned char dropped_last_frame;
static unsigned char displayed_pixie_count = INITIAL_PIXIES;
static unsigned char displayed_drop_count;
static unsigned int text_y_origin;
static unsigned int random_state = 0xACE1;
static unsigned char *build_screen;
static unsigned char *build_color;
static unsigned char build_frame_index;
static unsigned char cache_valid[2];
static unsigned char cache_revision[2];
static unsigned char cache_mode[2];
static unsigned int cache_origin_x[2];
static unsigned int cache_origin_y[2];
static struct DirtyTile dirty_tiles[MAX_DIRTY_TILES];
static unsigned char dirty_tile_count;
static unsigned char encoded_tile_staging[2];

static void enable_vic4(void)
{
    VIC_KEY = 0x47;
    VIC_KEY = 0x53;
}

static unsigned char random_byte(void)
{
    unsigned char bit = random_state & 1;
    random_state >>= 1;
    if (bit) random_state ^= 0xB400;
    return (unsigned char)random_state;
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

    memset(TILE_DATA, 0,
        (TILE_COUNT + TIME_PILOT_DEMO_GLYPH_COUNT) * 64);
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

    /* Full font directly after the native map tiles. Statistics can therefore
       live inside the world map instead of in a fixed RRB overlay. */
    for (tile = 0; tile < TIME_PILOT_DEMO_GLYPH_COUNT; ++tile)
        for (y = 0; y < 8; ++y)
            for (x = 0; x < 8; ++x) {
                unsigned char packed = time_pilot_demo_glyphs[tile]
                    [(unsigned int)y * 4 + (x >> 1)];
                TILE_DATA[(unsigned int)(TILE_COUNT + tile) * 64 +
                    (unsigned int)y * 8 + x] =
                        ((x & 1) ? packed & 0x0F : packed >> 4) ? 1 : 0;
            }
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

static void put_map_info(unsigned char map_x, unsigned char map_y,
                         const char *text)
{
    while (*text) {
        tilebuffer_set(&tilemap, map_x++, map_y,
            *text == ' ' ? TILE_BLANK : TILE_COUNT + info_glyph(*text));
        ++text;
    }
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

    /* Keep both rulers intact:
         01 02 03 ...
         02 PIXIES 024 DROP 000
         03 */
    put_map_info(3, 1, "PIXIES 024 DROP 000");
}

static unsigned char source_pixel(unsigned char frame, int x, int y)
{
    unsigned char value = parachutist_frames[frame]
        [(unsigned int)y * 8 + (x >> 1)];
    return (x & 1) ? value & 0x0F : value >> 4;
}

static void load_pixie_chars(void)
{
    unsigned char frame;
    unsigned char phase;
    unsigned char slice;
    unsigned char row;
    unsigned char byte;

    /* Eight vertical pixel phases make every 16x16 Pixie move smoothly.
       A shifted image can touch three 8-pixel RRB rows. */
    for (frame = 0; frame < PARACHUTIST_FRAME_COUNT; ++frame)
        for (phase = 0; phase < JUMPER_PHASES; ++phase)
            for (slice = 0; slice < JUMPER_SLICES; ++slice) {
                unsigned int character =
                    ((unsigned int)frame * JUMPER_PHASES + phase) *
                    JUMPER_SLICES + slice;
                for (row = 0; row < 8; ++row) {
                    int source_y = (int)slice * 8 + row - phase;
                    for (byte = 0; byte < 8; ++byte) {
                        unsigned char left = 0;
                        unsigned char right = 0;
                        if (source_y >= 0 && source_y < 16) {
                            left = source_pixel(frame, byte * 2, source_y);
                            right = source_pixel(frame, byte * 2 + 1, source_y);
                        }
                        PIXIE_CHAR_DATA[character * 64 +
                            (unsigned int)row * 8 + byte] =
                                left | (right << 4);
                    }
                }
            }
}

static void initialise_pixies(void)
{
    unsigned char index;

    for (index = 0; index < MAX_PIXIES; ++index) {
        pixies[index].x = random_byte() + (random_byte() & 31);
        pixie_y2[index] = ((int)(random_byte() % 216) - 16) * 2;
        pixie_speed[index] = 1 + index % 3;
        pixies[index].character_base = JUMPER_CHAR_BASE;
        pixies[index].frame = index & 3;
        pixies[index].frame_stride = JUMPER_PHASES * JUMPER_SLICES;
        pixies[index].phase_stride = JUMPER_SLICES;
        pixies[index].width_chars = 1;
        pixies[index].height_slices = JUMPER_SLICES;
        pixies[index].row_stride = 1;
        pixies[index].palette_bank = 0x10;
        pixies[index].visible = 1;
    }
}

static void move_pixies(void)
{
    unsigned char index;

    ++animation_clock;
    for (index = 0; index < active_pixie_count; ++index) {
        pixie_y2[index] += pixie_speed[index];
        if (pixie_y2[index] >= 416) {
            pixie_y2[index] = -32;
            pixies[index].x = random_byte() + (random_byte() & 31);
            pixies[index].frame = (pixies[index].frame + 1) & 3;
        }
        pixies[index].y = pixie_y2[index] >> 1;
        if (!(animation_clock & 7))
            pixies[index].frame = (pixies[index].frame + 1) & 3;
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
    /* Pixies use palette bank 1 so the map's red animation pen does not
       replace the parachutists' original magenta fallback colour. */
    PALETTE_RED[0x10] = PALETTE_GREEN[0x10] = PALETTE_BLUE[0x10] = 0;
    PALETTE_RED[0x11] = PALETTE_GREEN[0x11] = PALETTE_BLUE[0x11] = 15;
    PALETTE_RED[0x12] = 12; PALETTE_GREEN[0x12] = 0; PALETTE_BLUE[0x12] = 12;
    PALETTE_RED[0x13] = 0; PALETTE_GREEN[0x13] = 4; PALETTE_BLUE[0x13] = 15;
}

static void dma_copy_to_color(const unsigned char *source,
                              unsigned int color_offset)
{
    long destination = COLOR_RAM_LINEAR + color_offset;
    dma_list.option_0b = 0x0B;
    dma_list.option_80 = 0x80;
    dma_list.source_mb = 0;
    dma_list.option_81 = 0x81;
    dma_list.destination_mb = (unsigned char)(destination >> 20);
    dma_list.end_options = 0;
    dma_list.command = 0;
    dma_list.count = ROW_COUNT * ROW_BYTES;
    dma_list.source = (unsigned int)source;
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

static void dma_copy_to_chip_ram(const unsigned char *source,
                                 unsigned int destination,
                                 unsigned int count)
{
    dma_list.option_0b = 0x0B;
    dma_list.option_80 = 0x80;
    dma_list.source_mb = 0;
    dma_list.option_81 = 0x81;
    dma_list.destination_mb = 0;
    dma_list.end_options = 0;
    dma_list.command = 0;
    dma_list.count = count;
    dma_list.source = (unsigned int)source;
    dma_list.source_bank = 0;
    dma_list.destination = destination;
    dma_list.destination_bank = 0;
    dma_list.subcommand = 0;
    dma_list.modulo = 0;
    REG8(0xD702) = 0;
    REG8(0xD704) = 0;
    REG8(0xD701) = (unsigned int)&dma_list >> 8;
    REG8(0xD705) = (unsigned int)&dma_list;
}

static void build_encoded_map(void)
{
    const unsigned char *source = MAP_DATA;
    unsigned int destination = ENCODED_MAP_ADDRESS;
    unsigned char row;

    for (row = 0; row < MAP_HEIGHT; ++row) {
        unsigned char *output = ENCODED_ROW_STAGING;
        unsigned char column;
        for (column = 0; column < MAP_WIDTH; ++column) {
            unsigned int character = TILE_CHAR_BASE + *source++;
            *output++ = (unsigned char)character;
            *output++ = (unsigned char)(character >> 8);
        }
        dma_copy_to_chip_ram(ENCODED_ROW_STAGING, destination,
                             ENCODED_MAP_ROW_BYTES);
        destination += ENCODED_MAP_ROW_BYTES;
    }

    {
        unsigned char *output = ENCODED_ROW_STAGING;
        unsigned int character = TILE_CHAR_BASE + TILE_BLANK;
        unsigned char column;
        for (column = 0; column < MAP_WIDTH; ++column) {
            *output++ = (unsigned char)character;
            *output++ = (unsigned char)(character >> 8);
        }
    }
    dma_copy_to_chip_ram(ENCODED_ROW_STAGING, ENCODED_BLANK_ROW_ADDRESS,
                         ENCODED_MAP_ROW_BYTES);
}

static void update_encoded_map_tile(unsigned int map_offset,
                                    unsigned char tile)
{
    unsigned int character = TILE_CHAR_BASE + tile;
    encoded_tile_staging[0] = (unsigned char)character;
    encoded_tile_staging[1] = (unsigned char)(character >> 8);
    dma_copy_to_chip_ram(encoded_tile_staging,
                         ENCODED_MAP_ADDRESS + map_offset * 2, 2);
}

static void dma_copy_encoded_view(void)
{
    unsigned int source_row = ENCODED_MAP_ADDRESS +
        tilemap.origin_y * ENCODED_MAP_ROW_BYTES;
    unsigned int destination_row = (unsigned int)build_screen + 2;
    unsigned int map_y = tilemap.origin_y;
    unsigned int source_x_offset = tilemap.origin_x << 1;
    unsigned char first_columns = MAP_WIDTH - tilemap.origin_x;
    unsigned char second_columns;
    unsigned char row;

    if (first_columns > FETCH_WIDTH) first_columns = FETCH_WIDTH;
    second_columns = FETCH_WIDTH - first_columns;
    for (row = 0; row < ROW_COUNT; ++row) {
        unsigned int first_source = source_row + source_x_offset;
        unsigned int second_source = tilemap.mode == TILEBUFFER_WRAP ?
            source_row : ENCODED_BLANK_ROW_ADDRESS;

        if (tilemap.mode == TILEBUFFER_CLAMP && map_y >= MAP_HEIGHT) {
            first_source = ENCODED_BLANK_ROW_ADDRESS;
            second_source = ENCODED_BLANK_ROW_ADDRESS;
        }
        if (first_columns)
            dma_copy_to_chip_ram((const unsigned char *)first_source,
                                 destination_row, first_columns * 2);
        if (second_columns)
            dma_copy_to_chip_ram((const unsigned char *)second_source,
                                 destination_row + first_columns * 2,
                                 second_columns * 2);

        destination_row += ROW_BYTES;
        ++map_y;
        if (tilemap.mode == TILEBUFFER_WRAP && map_y == MAP_HEIGHT) {
            map_y = 0;
            source_row = ENCODED_MAP_ADDRESS;
        } else {
            source_row += ENCODED_MAP_ROW_BYTES;
        }
    }
}

static void write_text_y(unsigned int value)
{
    VIC_TEXT_Y_LO = (unsigned char)value;
    VIC_TEXT_Y_HI = (VIC_TEXT_Y_HI & 0xF0) |
        (unsigned char)((value >> 8) & 0x0F);
}

static void decimal3(char *target, unsigned int value)
{
    if (value > 999) value = 999;
    target[0] = '0' + value / 100;
    target[1] = '0' + (value / 10) % 10;
    target[2] = '0' + value % 10;
}

static unsigned char set_map_tile_dirty(unsigned char x, unsigned char y,
                                        unsigned char tile)
{
    unsigned int offset = (unsigned int)y * MAP_WIDTH + x;
    unsigned char index;

    if (MAP_DATA[offset] == tile) return 0;
    MAP_DATA[offset] = tile;
    update_encoded_map_tile(offset, tile);
    for (index = 0; index < dirty_tile_count; ++index) {
        if (dirty_tiles[index].x == x && dirty_tiles[index].y == y) {
            dirty_tiles[index].pending_buffers |= BOTH_FRAME_BUFFERS;
            return 1;
        }
    }
    if (dirty_tile_count < MAX_DIRTY_TILES) {
        dirty_tiles[dirty_tile_count].x = x;
        dirty_tiles[dirty_tile_count].y = y;
        dirty_tiles[dirty_tile_count].pending_buffers = BOTH_FRAME_BUFFERS;
        ++dirty_tile_count;
    } else {
        /* Rare overflow fallback: the next build of each frame buffer reads
           the complete current map. Normal animation never takes this path. */
        ++tilemap.revision;
        dirty_tile_count = 0;
    }
    return 1;
}

static unsigned char set_map_digit(unsigned char x, unsigned char digit)
{
    return set_map_tile_dirty(x, 1, TILE_COUNT + digit);
}

static void update_map_statistics(void)
{
    char digits[3];
    unsigned char index;

    if (active_pixie_count != displayed_pixie_count) {
        decimal3(digits, active_pixie_count);
        for (index = 0; index < 3; ++index)
            set_map_digit(10 + index, digits[index] - '0');
        displayed_pixie_count = active_pixie_count;
    }
    if (!(animation_clock & 15) &&
        dropped_last_frame != displayed_drop_count) {
        decimal3(digits, dropped_last_frame);
        for (index = 0; index < 3; ++index)
            set_map_digit(19 + index, digits[index] - '0');
        displayed_drop_count = dropped_last_frame;
    }
}

static unsigned char map_coordinate_in_view(unsigned int coordinate,
                                            unsigned int origin,
                                            unsigned int map_size,
                                            unsigned char view_size,
                                            unsigned char *view_coordinate)
{
    unsigned int distance;

    if (tilemap.mode == TILEBUFFER_WRAP) {
        distance = coordinate >= origin ? coordinate - origin :
                   coordinate + map_size - origin;
    } else {
        if (coordinate < origin) return 0;
        distance = coordinate - origin;
    }
    if (distance >= view_size) return 0;
    *view_coordinate = (unsigned char)distance;
    return 1;
}

static void apply_dirty_tiles(unsigned char full_rebuild)
{
    unsigned char buffer_mask = 1 << build_frame_index;
    unsigned char index = 0;

    while (index < dirty_tile_count) {
        struct DirtyTile *dirty = &dirty_tiles[index];
        if (dirty->pending_buffers & buffer_mask) {
            if (!full_rebuild) {
                unsigned char column;
                unsigned char row;
                if (map_coordinate_in_view(dirty->x, tilemap.origin_x,
                                           MAP_WIDTH, FETCH_WIDTH, &column) &&
                    map_coordinate_in_view(dirty->y, tilemap.origin_y,
                                           MAP_HEIGHT, ROW_COUNT, &row)) {
                    unsigned char tile =
                        MAP_DATA[(unsigned int)dirty->y * MAP_WIDTH + dirty->x];
                    pixie_renderer_patch_cached_tile(
                        column, row, TILE_CHAR_BASE + tile);
                }
            }
            dirty->pending_buffers &= (unsigned char)~buffer_mask;
        }
        if (!dirty->pending_buffers) {
            --dirty_tile_count;
            dirty_tiles[index] = dirty_tiles[dirty_tile_count];
        } else {
            ++index;
        }
    }
}

static void build_display_lists(void)
{
    unsigned char index;
    unsigned char initialize = !cache_valid[build_frame_index];
    unsigned char rebuild = initialize ||
        cache_origin_x[build_frame_index] != tilemap.origin_x ||
        cache_origin_y[build_frame_index] != tilemap.origin_y ||
        cache_revision[build_frame_index] != tilemap.revision ||
        cache_mode[build_frame_index] != tilemap.mode;

    pixie_renderer_begin_cached(build_screen, build_color,
        TILEMAP_PREFIX_ENTRIES);
    pixie_renderer_prepare_cached_tilemap(
        FETCH_WIDTH, 0, tilemap.fine_x, initialize);
    if (rebuild)
        dma_copy_encoded_view();
    if (rebuild) {
        cache_valid[build_frame_index] = 1;
        cache_origin_x[build_frame_index] = tilemap.origin_x;
        cache_origin_y[build_frame_index] = tilemap.origin_y;
        cache_revision[build_frame_index] = tilemap.revision;
        cache_mode[build_frame_index] = tilemap.mode;
    }
    apply_dirty_tiles(rebuild);

    /* TEXTYPOS shifts the whole character canvas. Offset Pixie Y by the same
       fine amount so the falling objects keep screen coordinates. */
    for (index = 0; index < active_pixie_count; ++index)
        pixies[index].y += tilemap.fine_y;
    BORDER_COLOR = PROFILE_PIXIE_COLOR;
    dropped_last_frame = pixie_renderer_draw(
        pixies, active_pixie_count, 0, 0);
    for (index = 0; index < active_pixie_count; ++index)
        pixies[index].y -= tilemap.fine_y;
    pixie_renderer_finish(TILE_CHAR_BASE + TILE_BLANK);
}

static void select_build_frame(unsigned char frame)
{
    build_frame_index = frame;
    build_screen = frame ? FRAME1_SCREEN : FRAME0_SCREEN;
    build_color = frame ? FRAME1_COLOR : FRAME0_COLOR;
}

static void show_frame(unsigned char frame)
{
    unsigned int screen = frame ? 0x8C00 : 0x6800;
    unsigned int color = frame ? 0x1200 : 0x0000;

    VIC_SCREEN_LO = (unsigned char)screen;
    VIC_SCREEN_HI = (unsigned char)(screen >> 8);
    VIC_COLOR_LO = (unsigned char)color;
    VIC_COLOR_HI = (unsigned char)(color >> 8);
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
    unsigned char plus;
    unsigned char minus;
    unsigned char equals;
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

    /* The direct matrix is active-low.  It avoids cursor/joystick crosstalk. */
    KEYBOARD_ROW = 5;
    plus = !(KEYBOARD_MATRIX & 0x01);
    minus = !(KEYBOARD_MATRIX & 0x08);
    KEYBOARD_ROW = 6;
    /* US Shift-'=' and the physical German Mac '+' position. */
    equals = !(KEYBOARD_MATRIX & 0x20) ||
             !(KEYBOARD_MATRIX & 0x02);
    /* The physical German Mac '-' position has the US '/' scancode. */
    minus |= !(KEYBOARD_MATRIX & 0x80);

    if ((IMMEDIATE_KEYS & 0x01) ||
        (cursor_right && (MODIFIER_KEYS & 0x03))) result |= CONTROL_LEFT;
    else if (cursor_right) result |= CONTROL_RIGHT;
    if ((IMMEDIATE_KEYS & 0x02) ||
        (cursor_down && (MODIFIER_KEYS & 0x03))) result |= CONTROL_UP;
    else if (cursor_down) result |= CONTROL_DOWN;
    if (space) result |= CONTROL_SPACE;
    if (plus || equals) result |= CONTROL_PLUS;
    if (minus) result |= CONTROL_MINUS;
    return result;
}

static void update_controls(void)
{
    unsigned char controls = read_controls();
    unsigned char pressed = controls & (unsigned char)~previous_controls;
    int dx = 0;
    int dy = 0;

    if (controls & CONTROL_LEFT) --dx;
    if (controls & CONTROL_RIGHT) ++dx;
    if (controls & CONTROL_UP) --dy;
    if (controls & CONTROL_DOWN) ++dy;
#ifdef PIXIE_RENDERER_AUTOSCROLL_TEST
    /* Build-time regression mode used to exercise DMA row changes and wrap. */
    ++dx;
    ++dy;
#endif
    tilebuffer_scroll(&tilemap, dx, dy);

    if (pressed & CONTROL_SPACE) {
        tilebuffer_set_mode(&tilemap,
            tilemap.mode == TILEBUFFER_WRAP ?
            TILEBUFFER_CLAMP : TILEBUFFER_WRAP);
        clamp_scroll_to_view();
    }
    if (pressed & CONTROL_PLUS) {
        if (active_pixie_count <= MAX_PIXIES - PIXIE_COUNT_STEP)
            active_pixie_count += PIXIE_COUNT_STEP;
        else active_pixie_count = MAX_PIXIES;
    }
    if (pressed & CONTROL_MINUS) {
        if (active_pixie_count > PIXIE_COUNT_STEP)
            active_pixie_count -= PIXIE_COUNT_STEP;
        else active_pixie_count = 1;
    }
    previous_controls = controls;
}

int main(void)
{
    unsigned char visible_frame = 0;
    unsigned char next_frame = 1;

    clrscr();
    __asm__("sei");
    enable_vic4();
    CPU_MEMORY_CONFIG = 0x35;
    install_palette();
    build_tileset();
    dma_copy_to_chip_ram(TILE_DATA, TILE_CHAR_ADDRESS, TILE_DATA_BYTES);
    build_map();
    build_encoded_map();
    load_pixie_chars();
    initialise_pixies();

    BORDER_COLOR = 0;
    BACKGROUND_COLOR = 0;
    SPRITE_ENABLE = 0; /* These objects are RRB Pixies, never VIC sprites. */
    VIC_CTRL3 = (VIC_CTRL3 & 0x7F) | 0x60;
    VIC_CRAME |= 0x01;
    VIC_SCREEN_BANK = 0;
    VIC_SCREEN_MB = 0;
    VIC_LINESTEP = ROW_BYTES;
    VIC_LINESTEP_HI = ROW_BYTES >> 8;
    VIC_CHRCOUNT = ENTRIES_PER_ROW;
    VIC_ROWS = ROW_COUNT - 1;
    VIC_XPOS &= 0x3F;
    VIC_MODE = (VIC_MODE & 0xF8) | 0x07;

    VIC_HOTREG &= 0x7F;
    text_y_origin = VIC_TEXT_Y_LO |
        ((unsigned int)(VIC_TEXT_Y_HI & 0x0F) << 8);

    select_build_frame(visible_frame);
    build_display_lists();
    dma_copy_to_color(FRAME0_COLOR, 0);
    wait_frame();
    show_frame(visible_frame);

    while (1) {
        BORDER_COLOR = PROFILE_INPUT_COLOR;
        update_controls();
        BORDER_COLOR = PROFILE_MOTION_COLOR;
        move_pixies();
        update_map_statistics();
        if (!(animation_clock & 31)) {
            unsigned char tile =
                MAP_DATA[(unsigned int)20 * MAP_WIDTH + 30] == TILE_ANIMATION ?
                TILE_HATCH_A : TILE_ANIMATION;
            set_map_tile_dirty(30, 20, tile);
        }

        BORDER_COLOR = PROFILE_BUILD_COLOR;
        select_build_frame(next_frame);
        build_display_lists();
        BORDER_COLOR = PROFILE_DMA_COLOR;
        dma_copy_to_color(next_frame ? FRAME1_COLOR : FRAME0_COLOR,
                          next_frame ? 0x1200 : 0x0000);
        BORDER_COLOR = 0;
        wait_frame();
        show_frame(next_frame);
        visible_frame = next_frame;
        next_frame ^= 1;
    }
}
