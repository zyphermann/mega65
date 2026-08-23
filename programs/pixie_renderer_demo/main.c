#include <conio.h>
#include <string.h>

#include "generated/time-pilot-parachutists.h"
#define TIME_PILOT_FONT_INCLUDE_DEMO
#include "generated/time-pilot-font.h"
#include "pixie_renderer/pixie_renderer.h"
#include "time_pilot_colors.h"

#define REG8(address) (*(volatile unsigned char *)(address))

#define VIC_RASTER        REG8(0xD012)
#define VIC_CTRL1         REG8(0xD011)
#define BORDER_COLOR      REG8(0xD020)
#define BACKGROUND_COLOR  REG8(0xD021)
#define VIC_KEY           REG8(0xD02F)
#define VIC_CTRL2         REG8(0xD030)
#define VIC_CTRL3         REG8(0xD031)
#define VIC_XPOS          REG8(0xD051)
#define VIC_MODE          REG8(0xD054)
#define VIC_LINESTEP      REG8(0xD058)
#define VIC_LINESTEP_HI   REG8(0xD059)
#define VIC_CHRCOUNT      REG8(0xD05E)
#define VIC_SCREEN_LO     REG8(0xD060)
#define VIC_SCREEN_HI     REG8(0xD061)
#define VIC_SCREEN_BANK   REG8(0xD062)
#define VIC_SCREEN_MB     REG8(0xD063)
#define VIC_COLOR_LO      REG8(0xD064)
#define VIC_COLOR_HI      REG8(0xD065)
#define CPU_MEMORY_CONFIG REG8(0x0001)
#define PALETTE_CONTROL   REG8(0xD070)
#define PALETTE_RED       ((volatile unsigned char *)0xD100)
#define PALETTE_GREEN     ((volatile unsigned char *)0xD200)
#define PALETTE_BLUE      ((volatile unsigned char *)0xD300)
#define IMMEDIATE_KEYS    REG8(0xD60F)
#define MODIFIER_KEYS     REG8(0xD611)
#define CIA1_PORT_A       REG8(0xDC00)
#define CIA1_PORT_B       REG8(0xDC01)
#define CIA1_DDR_A        REG8(0xDC02)
#define CIA1_DDR_B        REG8(0xDC03)

#define BACKGROUND_CHAR_DATA ((unsigned char *)0x1800)
#define PIXIE_CHAR_DATA   ((unsigned char *)0xA000)
#define FRAME0_SCREEN     ((unsigned char *)0x6000)
#define FRAME0_COLOR      ((unsigned char *)0x7000)
#define FRAME1_SCREEN     ((unsigned char *)0x8000)
#define FRAME1_COLOR      ((unsigned char *)0x9000)
#define INFO_FONT_DATA    ((unsigned char *)0xC000)
#define PIXIE_OBJECT_DATA ((PixieObject *)0x0400)
#define PIXIE_Y2_DATA     ((int *)0x0B00)
#define PIXIE_SPEED_DATA  ((unsigned char *)0x0C00)
#define COLOR_RAM_LINEAR  0x0FF80000L

/* Eighty SEAM entries give the RRB useful stress-test headroom. Screen
   lists and colour shadows live in ordinary 4 KiB areas; colour data is DMA'd
   into two independent pages of the VIC-IV's 64 KiB colour RAM. */
#define ROW_COUNT         PIXIE_RENDER_ROWS
#define ENTRIES_PER_ROW   PIXIE_RENDER_ENTRIES
#define ROW_BYTES         PIXIE_RENDER_ROW_BYTES
#define INITIAL_JUMPER_COUNT 24
#define MAX_JUMPER_COUNT  128
#define COUNT_STEP        4
#define CROSSHATCH_CHAR_BASE (0x1800 / 64)
#define JUMPER_CHAR_BASE  (0xA000 / 64)
#define JUMPER_PHASES     8
#define JUMPER_SLICES     3
#define CROSSHATCH_BLANK_CHAR (JUMPER_CHAR_BASE + 2)
#define INFO_FONT_BASE    (0xC000 / 64)
#define INFO_RESERVED_ENTRIES 24
#define KEY_UP_HELD       0x01
#define KEY_DOWN_HELD     0x02
#define KEY_SPACE_HELD    0x04
#define MOTION_FALL       0
#define MOTION_LISSAJOUS  1
#define PROFILE_INPUT_COLOR  4
#define PROFILE_MOTION_COLOR 5
#define PROFILE_BEGIN_COLOR  6
#define PROFILE_PIXIES_COLOR 7
#define PROFILE_HUD_COLOR    8
#define PROFILE_FINISH_COLOR 9

#define pixies PIXIE_OBJECT_DATA
#define pixie_y2 PIXIE_Y2_DATA
#define pixie_speed2 PIXIE_SPEED_DATA
static unsigned char dropped_last_frame;
static unsigned int list_entries_last_frame;
static unsigned char background_scroll;
static unsigned char background_scroll_y;
static unsigned char background_far_scroll;
static unsigned char background_far_scroll_y;
static unsigned char animation_clock;
static unsigned char active_jumper_count = INITIAL_JUMPER_COUNT;
static unsigned char motion_mode;
static unsigned char previous_keys;
static unsigned int orbit_phase16;
static unsigned char *build_screen;
static unsigned char *build_color;

/* A frame is built entirely in ordinary RAM. Only its colour half must be
   copied into the VIC-IV's separate 64 KiB colour RAM before the atomic
   screen/colour pointer flip. */
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

static const unsigned char wave64[64] = {
    128,140,153,165,176,188,198,208,218,226,234,240,246,250,253,255,
    255,255,253,250,246,240,234,226,218,208,198,188,176,165,153,140,
    128,115,102, 90, 79, 67, 57, 47, 37, 29, 21, 15,  9,  5,  2,  0,
      0,  0,  2,  5,  9, 15, 21, 29, 37, 47, 57, 67, 79, 90,102,115
};

static unsigned char interpolated_wave(unsigned int phase16)
{
    unsigned char index = (phase16 >> 4) & 63;
    unsigned char fraction = phase16 & 15;
    int first = wave64[index];
    int difference = (int)wave64[(index + 1) & 63] - first;

    return (unsigned char)(first + difference * fraction / 16);
}

static void enable_vic4(void)
{
    VIC_KEY = 0x47;
    VIC_KEY = 0x53;
}

static unsigned char read_control_keys(void)
{
    unsigned char keys = 0;
    unsigned char port_a;
    unsigned char ddr_a;
    unsigned char ddr_b;
    unsigned char cursor_down;
    unsigned char space;
    unsigned char control = VIC_CTRL2;

    /* CRAM2K overlays CIA 1. Temporarily expose the keyboard matrix. */
    __asm__("sei");
    VIC_CTRL2 = control & 0xFE;
    port_a = CIA1_PORT_A;
    ddr_a = CIA1_DDR_A;
    ddr_b = CIA1_DDR_B;
    CIA1_DDR_A = 0xFF;
    CIA1_DDR_B = 0;
    CIA1_PORT_A = 0xFE;
    cursor_down = !(CIA1_PORT_B & 0x80);
    CIA1_PORT_A = 0x7F;
    space = !(CIA1_PORT_B & 0x10);
    CIA1_PORT_A = port_a;
    CIA1_DDR_A = ddr_a;
    CIA1_DDR_B = ddr_b;
    VIC_CTRL2 = control;
    /* The demo owns VIC-IV, colour RAM and DMAgic. IRQs remain disabled;
       enabling the KERNAL IRQ here would let it run screen/colour DMA jobs
       with our custom pointers and corrupt the double-buffered RRB state. */

    if ((IMMEDIATE_KEYS & 0x02) ||
        (cursor_down && (MODIFIER_KEYS & 0x03))) keys |= KEY_UP_HELD;
    else if (cursor_down) keys |= KEY_DOWN_HELD;
    if (space) keys |= KEY_SPACE_HELD;
    return keys;
}

static void update_controls(void)
{
    unsigned char keys = read_control_keys();
    unsigned char pressed = keys & (unsigned char)~previous_keys;

    if (pressed & KEY_SPACE_HELD) motion_mode ^= 1;
    if (pressed & KEY_UP_HELD) {
        if (active_jumper_count <= MAX_JUMPER_COUNT - COUNT_STEP)
            active_jumper_count += COUNT_STEP;
        else active_jumper_count = MAX_JUMPER_COUNT;
    }
    if (pressed & KEY_DOWN_HELD) {
        if (active_jumper_count > COUNT_STEP)
            active_jumper_count -= COUNT_STEP;
        else active_jumper_count = 1;
    }
    previous_keys = keys;
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
    dma_list.command = 0;       /* Copy, F018B request format. */
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
    REG8(0xD705) = (unsigned int)&dma_list; /* Trigger and wait for DMA. */
}

static void install_palette(void)
{
    PALETTE_CONTROL &= 0x03;
    /* Deliberately direct fallback colours for the 2-bpp original sprites. */
    PALETTE_RED[0] = PALETTE_GREEN[0] = PALETTE_BLUE[0] = 0;
    PALETTE_RED[1] = 14; PALETTE_GREEN[1] = 14; PALETTE_BLUE[1] = 14;
    PALETTE_RED[2] = 12; PALETTE_GREEN[2] = 0;  PALETTE_BLUE[2] = 12;
    PALETTE_RED[3] = 0;  PALETTE_GREEN[3] = 4;  PALETTE_BLUE[3] = 15;
    /* Border profiler: red, yellow, green, cyan, magenta and orange. */
    PALETTE_RED[4] = 15; PALETTE_GREEN[4] = 0;  PALETTE_BLUE[4] = 0;
    PALETTE_RED[5] = 15; PALETTE_GREEN[5] = 15; PALETTE_BLUE[5] = 0;
    PALETTE_RED[6] = 0;  PALETTE_GREEN[6] = 15; PALETTE_BLUE[6] = 0;
    PALETTE_RED[7] = 0;  PALETTE_GREEN[7] = 15; PALETTE_BLUE[7] = 15;
    PALETTE_RED[8] = 15; PALETTE_GREEN[8] = 0;  PALETTE_BLUE[8] = 15;
    PALETTE_RED[9] = 15; PALETTE_GREEN[9] = 7;  PALETTE_BLUE[9] = 0;
    /* Palette bank $10 is reserved for the dim, distant crosshatch layer. */
    PALETTE_RED[0x13] = 0; PALETTE_GREEN[0x13] = 7; PALETTE_BLUE[0x13] = 8;
    /* Text pixel 1 in palette bank $10 identifies the distant layer. */
    PALETTE_RED[0x11] = 0; PALETTE_GREEN[0x11] = 10; PALETTE_BLUE[0x11] = 12;
    PALETTE_RED[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_RED;
    PALETTE_GREEN[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_GREEN;
    PALETTE_BLUE[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_BLUE;
}

static unsigned char source_pixel(unsigned char frame, int x, int y)
{
    unsigned char value = parachutist_frames[frame][(unsigned int)y * 8 + (x >> 1)];
    return (x & 1) ? (value & 0x0F) : (value >> 4);
}

static void load_jumper_chars(void)
{
    unsigned char frame;
    unsigned char phase;
    unsigned char slice;
    unsigned char row;
    unsigned char byte;

    /* Each animation frame gets eight sub-tile Y phases. A shifted 16x16
       image can touch three 8-pixel screen rows, so every phase owns three
       NCM characters. This keeps the per-frame renderer extremely small. */
    for (frame = 0; frame < PARACHUTIST_FRAME_COUNT; ++frame) {
        for (phase = 0; phase < JUMPER_PHASES; ++phase) {
            for (slice = 0; slice < JUMPER_SLICES; ++slice) {
                unsigned int character =
                    ((unsigned int)frame * JUMPER_PHASES + phase) * JUMPER_SLICES + slice;
                for (row = 0; row < 8; ++row) {
                    int source_y = (int)slice * 8 + row - phase;
                    for (byte = 0; byte < 8; ++byte) {
                        unsigned char left = 0;
                        unsigned char right = 0;
                        if (source_y >= 0 && source_y < 16) {
                            left = source_pixel(frame, byte * 2, source_y);
                            right = source_pixel(frame, byte * 2 + 1, source_y);
                        }
                        /* NCM consumes the low nibble (left pixel) first. */
                        PIXIE_CHAR_DATA[character * 64 + (unsigned int)row * 8 + byte] =
                            left | (right << 4);
                    }
                }
            }
        }
    }
}

static void load_crosshatch_chars(void)
{
    unsigned char row;
    unsigned char byte;
    unsigned char phase;

    /* Sixteen character variants represent every vertical phase of the
       seamless original 16x16 crosshatch cell. */
    for (phase = 0; phase < 16; ++phase) {
        for (row = 0; row < 8; ++row) {
            unsigned char world_y = (phase + row) & 15;
            for (byte = 0; byte < 8; ++byte) {
                BACKGROUND_CHAR_DATA[(unsigned int)phase * 64 +
                    (unsigned int)row * 8 + byte] =
                    (world_y == 0 || world_y == 15) ? 0x33 :
                    (byte == 0 ? 0x03 : (byte == 7 ? 0x30 : 0));
            }
        }
    }
}

static void load_info_font(void)
{
    unsigned char glyph;
    unsigned char y;
    unsigned char x;

    for (glyph = 0; glyph < TIME_PILOT_DEMO_GLYPH_COUNT; ++glyph) {
        for (y = 0; y < 8; ++y) {
            for (x = 0; x < 8; ++x) {
                unsigned char packed = time_pilot_demo_glyphs[glyph]
                    [(unsigned int)y * 4 + (x >> 1)];
                unsigned char pixel = (x & 1) ? packed & 0x0F : packed >> 4;
                INFO_FONT_DATA[(unsigned int)glyph * 64 +
                    (unsigned int)y * 8 + x] = pixel ? 1 : 0;
            }
        }
    }
}

static unsigned char info_glyph(char character)
{
    if (character >= '0' && character <= '9')
        return character - '0';
    switch (character) {
        case 'A': return 10; case 'D': return 11; case 'E': return 12;
        case 'F': return 13; case 'I': return 14; case 'L': return 15;
        case 'M': return 16; case 'O': return 17; case 'P': return 18;
        case 'R': return 19; case 'S': return 20; case 'X': return 21;
        case 'T': return 23; case 'Y': return 24;
        default: return 22; /* slash */
    }
}

static void decimal3(char *target, unsigned int value)
{
    if (value > 999) value = 999;
    target[0] = '0' + value / 100;
    target[1] = '0' + (value / 10) % 10;
    target[2] = '0' + value % 10;
}

static void decimal4(char *target, unsigned int value)
{
    if (value > 9999) value = 9999;
    target[0] = '0' + value / 1000;
    target[1] = '0' + (value / 100) % 10;
    target[2] = '0' + (value / 10) % 10;
    target[3] = '0' + value % 10;
}

static void put_info_line(unsigned char row, const char *text)
{
    unsigned char column = 0;

    pixie_renderer_append_gotox(row, 4);
    while (*text) {
        if (*text == ' ') {
            pixie_renderer_append_gotox(row, 4 + (column + 1) * 8);
        } else {
            pixie_renderer_append_fcm(row,
                INFO_FONT_BASE + info_glyph(*text));
        }
        ++text;
        ++column;
    }
}

static void render_info(void)
{
    char line0[] = "PIXIES 000/128 LIST 0000";
    char line1[20];

    decimal3(line0 + 7, active_jumper_count);
    decimal4(line0 + 20, list_entries_last_frame);
    if (motion_mode == MOTION_LISSAJOUS) {
        strcpy(line1, "MODE LISSA DROP 000");
        decimal3(line1 + 16, dropped_last_frame);
    } else {
        strcpy(line1, "MODE FALL DROP 000");
        decimal3(line1 + 15, dropped_last_frame);
    }
    put_info_line(0, line0);
    put_info_line(1, line1);
}

static void build_display_lists(void)
{
    PixieBackground layers[2];

    layers[0].character_base = CROSSHATCH_CHAR_BASE;
    layers[0].alternate_character_offset = 0;
    layers[0].palette_bank = 0x10;
    layers[0].scroll_x = background_far_scroll;
    layers[0].scroll_y = background_far_scroll_y;
    layers[1].character_base = CROSSHATCH_CHAR_BASE;
    layers[1].alternate_character_offset = 0;
    layers[1].palette_bank = 0;
    layers[1].scroll_x = background_scroll;
    layers[1].scroll_y = background_scroll_y;

    BORDER_COLOR = PROFILE_BEGIN_COLOR;
    pixie_renderer_begin(build_screen, build_color, layers, 2);
    /* Layer labels stay disabled until they are sourced from the persistent
       A/B/C/D tile buffers. Patching generated character codes into the DMA
       background list caused invalid glyphs and intermittently replaced grid
       cells during double-buffered updates. */
    BORDER_COLOR = PROFILE_PIXIES_COLOR;
    dropped_last_frame = pixie_renderer_draw(
        pixies, active_jumper_count, 2, INFO_RESERVED_ENTRIES);
    list_entries_last_frame = pixie_renderer_total_entries();

    BORDER_COLOR = PROFILE_HUD_COLOR;
    render_info();
    BORDER_COLOR = PROFILE_FINISH_COLOR;
    pixie_renderer_finish(CROSSHATCH_BLANK_CHAR);
}

static void initialise_jumpers(void)
{
    unsigned char index;

    for (index = 0; index < MAX_JUMPER_COUNT; ++index) {
        pixies[index].x = (int)((index * 73U + index / 3U * 19U) % 304U);
        pixie_y2[index] = (int)((index * 97U) % 432U) - 32;
        pixies[index].y = pixie_y2[index] >> 1;
        pixie_speed2[index] = 1 + index % 3;
        pixies[index].character_base = JUMPER_CHAR_BASE;
        pixies[index].frame = (index >> 2) & 3;
        pixies[index].frame_stride = JUMPER_PHASES * JUMPER_SLICES;
        pixies[index].phase_stride = JUMPER_SLICES;
        pixies[index].width_chars = 1;
        pixies[index].height_slices = JUMPER_SLICES;
        pixies[index].row_stride = 1;
        pixies[index].palette_bank = 0;
        pixies[index].visible = 1;
    }
}

static void move_jumpers(void)
{
    unsigned char index;

    ++animation_clock;
    /* One sixteenth of a lookup-table interval per frame. Interpolation
       removes the old stop-and-jump movement between whole samples. */
    orbit_phase16 = (orbit_phase16 + 1) & 0x03FF;
    for (index = 0; index < active_jumper_count; ++index) {
        if (motion_mode == MOTION_LISSAJOUS) {
            unsigned int phase16 =
                (orbit_phase16 + (unsigned int)index * 7U * 16U) & 0x03FF;
            unsigned char wave_x = interpolated_wave(phase16);
            unsigned char wave_y = interpolated_wave((phase16 * 2U) & 0x03FF);
            unsigned char inner = index >> 6;
            /* Frequencies 1:2 form a closed Lissajous orbit. */
            pixies[index].x = (inner ? 16 : 8) +
                ((unsigned int)wave_x * (inner ? 8U : 9U) >> 3);
            pixie_y2[index] = ((inner ? 12 : 4) +
                ((unsigned int)wave_y * (inner ? 5U : 6U) >> 3)) * 2;
        } else {
            pixie_y2[index] += pixie_speed2[index];
            if (pixie_y2[index] >= 400) {
                pixie_y2[index] -= 432;
                pixies[index].x =
                    (int)((pixies[index].x * 5U + index * 17U + 31U) % 304U);
                pixies[index].frame = (pixies[index].frame + 1) & 3;
            }
        }
        pixies[index].y = pixie_y2[index] >> 1;
        if ((animation_clock & 7) == 0)
            pixies[index].frame = (pixies[index].frame + 1) & 3;
    }
    ++background_scroll;
    ++background_scroll_y;
    if (animation_clock & 1) {
        ++background_far_scroll;
        ++background_far_scroll_y;
    }
}

static void wait_for_frame(void)
{
    /* $D012 alone wraps at physical line 256. Require the ninth raster bit
       to be clear so buffer flips happen only at the real frame origin.
       First leave a possibly current line zero, then stop at the beginning
       of the next one -- do not wait until line one as the old code did. */
    while (VIC_RASTER == 0 && !(VIC_CTRL1 & 0x80)) {}
    while (VIC_RASTER != 0 || (VIC_CTRL1 & 0x80)) {}
}

static void show_frame(unsigned char frame)
{
    unsigned int screen = frame ? 0x8000 : 0x6000;
    unsigned int color = frame ? 0x1000 : 0x0000;

    /* Colour DMA has already completed while this frame was still hidden. */
    VIC_SCREEN_LO = (unsigned char)screen;
    VIC_SCREEN_HI = (unsigned char)(screen >> 8);
    VIC_COLOR_LO = (unsigned char)color;
    VIC_COLOR_HI = (unsigned char)(color >> 8);
}

static void select_build_frame(unsigned char frame)
{
    build_screen = frame ? FRAME1_SCREEN : FRAME0_SCREEN;
    build_color = frame ? FRAME1_COLOR : FRAME0_COLOR;
}

int main(void)
{
    unsigned char visible_frame = 0;
    unsigned char next_frame = 1;

    clrscr();
    __asm__("sei");
    enable_vic4();
    /* Expose RAM under BASIC/KERNAL before installing runtime Pixie chars at
       $a000. No KERNAL calls are used after this point. */
    CPU_MEMORY_CONFIG = 0x35;
    install_palette();
    load_jumper_chars();
    load_crosshatch_chars();
    load_info_font();
    initialise_jumpers();

    BORDER_COLOR = TIME_PILOT_BACKGROUND_INDEX;
    BACKGROUND_COLOR = TIME_PILOT_BACKGROUND_INDEX;

    /* 40 MHz, 40-column H320, 16-bit screen cells and full 2 KiB colour RAM. */
    VIC_CTRL3 = (VIC_CTRL3 & 0x7F) | 0x60;
    VIC_CTRL2 |= 0x01;
    VIC_SCREEN_BANK = 0;
    VIC_SCREEN_MB = 0;
    VIC_LINESTEP = ROW_BYTES;
    VIC_LINESTEP_HI = 0;
    VIC_CHRCOUNT = ENTRIES_PER_ROW;
    VIC_XPOS &= 0x3F; /* DBLRR off, normal delayed RRB pipeline. */
    VIC_MODE = (VIC_MODE & 0xF8) | 0x07; /* CHR16 + FCLRLO + FCLRHI. */

    select_build_frame(visible_frame);
    BORDER_COLOR = PROFILE_BEGIN_COLOR;
    build_display_lists();
    BORDER_COLOR = TIME_PILOT_BACKGROUND_INDEX;
    dma_copy_to_color(FRAME0_COLOR, 0x0000);
    wait_for_frame();
    show_frame(visible_frame);
    while (1) {
        /* A displayed buffer has just been published at raster zero. Start
           preparing the next one immediately and always at the same place.
           The red profile now includes input and object projection as well
           as the actual sequential VIC-IV display-list generation. */
        BORDER_COLOR = PROFILE_INPUT_COLOR;
        update_controls();
        BORDER_COLOR = PROFILE_MOTION_COLOR;
        move_jumpers();
        select_build_frame(next_frame);
        build_display_lists();
        BORDER_COLOR = TIME_PILOT_BACKGROUND_INDEX;
        /* Copy into the still-inactive colour page before raster zero. */
        dma_copy_to_color(next_frame ? FRAME1_COLOR : FRAME0_COLOR,
                          next_frame ? 0x1000 : 0x0000);
        wait_for_frame();
        show_frame(next_frame);
        visible_frame = next_frame;
        next_frame ^= 1;
    }
}
