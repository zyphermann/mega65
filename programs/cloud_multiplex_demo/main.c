#include <conio.h>
#include <string.h>

#include "time_pilot_colors.h"
#include "../../shared/generated/time-pilot-clouds.h"
#ifndef FLIGHT_DIRECTIONS_HEADER
#define FLIGHT_DIRECTIONS_HEADER "generated/directions.h"
#endif
#include FLIGHT_DIRECTIONS_HEADER
#ifdef TIMEPILOT_OBJECT_MODEL
#include "../timepilot/object_model.h"
#include "../timepilot/hud.h"
#endif

#define REG8(address) (*(volatile unsigned char *)(address))

#define VIC_KEY          REG8(0xD02F)
#define VIC_CTRL2        REG8(0xD030)
#define VIC_CTRL1        REG8(0xD011)
#define VIC_RASTER       REG8(0xD012)
#define SPRITE_X_MSB     REG8(0xD010)
#define SPRITE_ENABLE    REG8(0xD015)
#define SPRITE_Y_EXPAND  REG8(0xD017)
#define SPRITE_MULTICOLOR REG8(0xD01C)
#define SPRITE_X_EXPAND  REG8(0xD01D)
#define SPRITE_PRIORITY  REG8(0xD01B)
#define VIC_IRQ_STATUS   REG8(0xD019)
#define VIC_IRQ_MASK     REG8(0xD01A)
#define BORDER_COLOR     REG8(0xD020)
#define BACKGROUND_COLOR REG8(0xD021)
#define SPRITE_HEIGHTEN  REG8(0xD055)
#define SPRITE_HEIGHT    REG8(0xD056)
#define SPRITE_X64EN     REG8(0xD057)
#define SPRITE_16EN      REG8(0xD06B)
#define SPRITE_PTR_LOW   REG8(0xD06C)
#define SPRITE_PTR_HIGH  REG8(0xD06D)
#define SPRITE_PTR_BANK  REG8(0xD06E)
#define VIC_HOTREG       REG8(0xD05D)
#define PALETTE_CONTROL  REG8(0xD070)
#define PALETTE_RED      ((volatile unsigned char *)0xD100)
#define PALETTE_GREEN    ((volatile unsigned char *)0xD200)
#define PALETTE_BLUE     ((volatile unsigned char *)0xD300)
#define SPRITE_REGISTER  ((volatile unsigned char *)0xD000)
#define SPRITE_COLOR     ((volatile unsigned char *)0xD027)
#define IMMEDIATE_KEYS   REG8(0xD60F)
#define MODIFIER_KEYS    REG8(0xD611)
#define CIA1_PORT_A      REG8(0xDC00)
#define CIA1_PORT_B      REG8(0xDC01)
#define CIA1_DDR_A       REG8(0xDC02)
#define CIA1_DDR_B       REG8(0xDC03)

#define PLANE_DATA_ADDRESS           0x3F00
#define CLOUD_DATA_ADDRESS           0x3F80
#define CLOUD_DATA(frame) ((unsigned char *)(CLOUD_DATA_ADDRESS + (unsigned int)(frame) * 128))
#define PLANE_DATA ((unsigned char *)PLANE_DATA_ADDRESS)
#define RESIDENT_CLOUD_FRAMES 1

#define SLOT_COUNT 8
#define FIRST_CLOUD_SLOT 1
#define CLOUD_SLOT_COUNT 7
#define MAX_EVENTS 16
#define BUFFER_COUNT 2
#define EVENTS_PER_BUFFER 16
#define RESTORE_RASTER_LINE 260
#define LARGE_CLOUD_MASK 0x0E
#define RASTER_SAFETY_LINES 12
#define DEBUG_COLOR_BASE 0xF0
#define CLOUD_FIXED_SHIFT 8
#define TURN_FRAME_INTERVAL 2
#define KEY_HELD_LEFT  0x01
#define KEY_HELD_RIGHT 0x02
#define DIRECTION_COUNT 32
#define SOUTH 8
#define NORTH 24
#define SINGLE_CLOUD_DIAGNOSTIC 0

volatile unsigned char rewrite_event;
volatile unsigned char rewrite_front;
volatile unsigned char rewrite_swap_pending;
volatile unsigned char rewrite_debug_enabled;
volatile unsigned char rewrite_count[BUFFER_COUNT];
volatile unsigned char rewrite_raster[MAX_EVENTS * BUFFER_COUNT];
volatile unsigned char rewrite_raster_msb[MAX_EVENTS * BUFFER_COUNT];
volatile unsigned char rewrite_slot[MAX_EVENTS * BUFFER_COUNT];
volatile unsigned char rewrite_x[MAX_EVENTS * BUFFER_COUNT];
volatile unsigned char rewrite_x_msb[MAX_EVENTS * BUFFER_COUNT];
volatile unsigned char rewrite_y[MAX_EVENTS * BUFFER_COUNT];

#ifndef TIMEPILOT_OBJECT_MODEL
struct Cloud {
    long x;
    long y;
    unsigned char speed;
};
#endif

struct CloudPair {
    unsigned int first_x;
    unsigned int second_x;
    unsigned char first_y;
    unsigned char second_y;
    unsigned char rewrite_line;
};

#ifndef TIMEPILOT_OBJECT_MODEL
static struct Cloud clouds[SLOT_COUNT];
#else
#define clouds tp_objects
#endif
static struct CloudPair cloud_pairs[SLOT_COUNT];

static const unsigned int initial_x[SLOT_COUNT] = {
    20, 92, 174, 250, 45, 130, 214, 300
};

static const unsigned char initial_y[SLOT_COUNT] = {
    24, 58, 88, 34, 72, 18, 102, 50
};

/* Clockwise, beginning at east. Values use three fractional bits. */
static const signed char vectors[DIRECTION_COUNT][2] = {
    { 8, 0}, { 8, 2}, { 7, 3}, { 7, 4}, { 6, 6}, { 4, 7}, { 3, 7}, { 2, 8},
    { 0, 8}, {-2, 8}, {-3, 7}, {-4, 7}, {-6, 6}, {-7, 4}, {-7, 3}, {-8, 2},
    {-8, 0}, {-8,-2}, {-7,-3}, {-7,-4}, {-6,-6}, {-4,-7}, {-3,-7}, {-2,-8},
    { 0,-8}, { 2,-8}, { 3,-7}, { 4,-7}, { 6,-6}, { 7,-4}, { 7,-3}, { 8,-2}
};

static unsigned char read_cursor_keys(void)
{
    unsigned char keys = 0;
    unsigned char cursor_right;
    unsigned char port_a;
    unsigned char ddr_a;
    unsigned char ddr_b;
#ifdef TIMEPILOT_OBJECT_MODEL
    unsigned char vic_ctrl2;
#endif

    __asm__("sei");
#ifdef TIMEPILOT_OBJECT_MODEL
    /* CRAM2K maps the upper SEAM colour RAM over $DC00. Temporarily expose
       CIA 1 while sampling the held cursor key, then restore the FCM HUD. */
    vic_ctrl2 = VIC_CTRL2;
    VIC_CTRL2 = vic_ctrl2 & 0xFE;
#endif
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
#ifdef TIMEPILOT_OBJECT_MODEL
    VIC_CTRL2 = vic_ctrl2;
#endif
    __asm__("cli");

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
    unsigned char color;
    unsigned char slot;

    PALETTE_CONTROL &= 0x03;
    /* Slot 0 is permanently owned by the player plane. */
    for (color = 0; color < FLIGHT_PALETTE_SIZE; ++color) {
        PALETTE_RED[color] = flight_palette[color][0] >> 4;
        PALETTE_GREEN[color] = flight_palette[color][1] >> 4;
        PALETTE_BLUE[color] = flight_palette[color][2] >> 4;
    }
    for (slot = FIRST_CLOUD_SLOT; slot < SLOT_COUNT; ++slot) {
        for (color = 0; color < CLOUD_PALETTE_SIZE; ++color) {
            PALETTE_RED[slot * 16 + color] = cloud_palette[color][0] >> 4;
            PALETTE_GREEN[slot * 16 + color] = cloud_palette[color][1] >> 4;
            PALETTE_BLUE[slot * 16 + color] = cloud_palette[color][2] >> 4;
        }
    }
    PALETTE_RED[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_RED;
    PALETTE_GREEN[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_GREEN;
    PALETTE_BLUE[TIME_PILOT_BACKGROUND_INDEX] = TIME_PILOT_BACKGROUND_BLUE;

    /* Independent diagnostic hues selected by the raster IRQ. */
    PALETTE_RED[DEBUG_COLOR_BASE + 0] = 2;
    PALETTE_GREEN[DEBUG_COLOR_BASE + 0] = 0;
    PALETTE_BLUE[DEBUG_COLOR_BASE + 0] = 7;
    PALETTE_RED[DEBUG_COLOR_BASE + 1] = 0;
    PALETTE_GREEN[DEBUG_COLOR_BASE + 1] = 5;
    PALETTE_BLUE[DEBUG_COLOR_BASE + 1] = 3;
    PALETTE_RED[DEBUG_COLOR_BASE + 2] = 7;
    PALETTE_GREEN[DEBUG_COLOR_BASE + 2] = 2;
    PALETTE_BLUE[DEBUG_COLOR_BASE + 2] = 0;
    PALETTE_RED[DEBUG_COLOR_BASE + 3] = 5;
    PALETTE_GREEN[DEBUG_COLOR_BASE + 3] = 0;
    PALETTE_BLUE[DEBUG_COLOR_BASE + 3] = 4;
}

static void set_sprite_position(unsigned char slot, unsigned int x, unsigned char y)
{
    unsigned char mask = 1 << slot;

    SPRITE_REGISTER[slot * 2] = (unsigned char)x;
    SPRITE_REGISTER[slot * 2 + 1] = y;
    if (x & 0x100) SPRITE_X_MSB |= mask;
    else SPRITE_X_MSB &= ~mask;
}

static void initialise_cloud_sprites(void)
{
    unsigned char *pointer_table;
    unsigned int pointer_table_address;
    unsigned int address;
    unsigned char slot;

    /* KNOWN-GOOD POINTER PATH

       Keep the VIC's classic eight-byte sprite pointer table and use 8-bit
       pointers within VIC bank 0. The earlier relocated SPRPTR16 setup caused
       missing sprites and colourful pixel fragments although the source bytes
       were linked and copied correctly. Multiplexing only rewrites X/Y and
       never needs to change these graphic pointers.

       The runtime plane occupies $3f00-$3f7f and one shared cloud image uses
       $3f80-$3fff. The 17 immutable direction sources are linked separately
       at $5000 in FLIGHTDATA; changing direction copies one source frame into
       $3f00. The VIC itself remains on the proven bank-0 pointer path. */
    VIC_HOTREG &= 0x7F;
#ifdef TIMEPILOT_OBJECT_MODEL
    /* FCM uses all $0800-$0fff as two-byte screen RAM, including the classic
       pointer-table location. Keep the eight sprite pointers in free RAM. */
    SPRITE_PTR_LOW = 0x00;
    SPRITE_PTR_HIGH = 0x3E;
    SPRITE_PTR_BANK &= 0x7F;
#endif
    pointer_table_address =
        SPRITE_PTR_LOW | ((unsigned int)SPRITE_PTR_HIGH << 8);
    pointer_table = (unsigned char *)pointer_table_address;
    SPRITE_PTR_BANK &= 0x7F;

    /* The original arcade board has 24 physical sprite slots: its player is a
       normal sprite, while eight other slots are reserved for multiplexed
       clouds. The MEGA65 has only eight slots, so slot 0 is the fixed player
       and slots 1..7 produce fourteen cloud instances. */
    pointer_table[0] = PLANE_DATA_ADDRESS / 64;
    memcpy(PLANE_DATA, flight_frames[8], FLIGHT_FRAME_SIZE);
    SPRITE_COLOR[0] = 0;
#ifdef TIMEPILOT_OBJECT_MODEL
    set_sprite_position(0, 128, 120);
#else
    set_sprite_position(0, 176, 120);
#endif

    for (slot = FIRST_CLOUD_SLOT; slot < SLOT_COUNT; ++slot) {
        address = CLOUD_DATA_ADDRESS +
                  (unsigned int)(slot & (RESIDENT_CLOUD_FRAMES - 1)) * 128;
        pointer_table[slot] = address / 64;
        memcpy(CLOUD_DATA(slot & (RESIDENT_CLOUD_FRAMES - 1)),
               cloud_frames[slot & (RESIDENT_CLOUD_FRAMES - 1)],
               CLOUD_FRAME_SIZE);
        SPRITE_COLOR[slot] = 0;
        clouds[slot].x = (long)initial_x[slot] << CLOUD_FIXED_SHIFT;
        clouds[slot].y = (long)initial_y[slot] << CLOUD_FIXED_SHIFT;
        clouds[slot].speed = slot <= 3 ? 24 : 8;
    }

    SPRITE_HEIGHT = 16;
    SPRITE_HEIGHTEN = 0xFF;
    SPRITE_X64EN = 0xFF;
    SPRITE_16EN = 0xFF;
    SPRITE_MULTICOLOR = 0x00;
    /* The Time Pilot HUD is opaque character foreground; the blue playfield
       uses background pixels. Put sprites behind foreground so clouds and the
       player pass naturally underneath the black score panel. */
#ifdef TIMEPILOT_OBJECT_MODEL
    SPRITE_PRIORITY = 0xFF;
#else
    SPRITE_PRIORITY = 0x00;
#endif
    SPRITE_X_EXPAND = (SPRITE_X_EXPAND & 0x00) | LARGE_CLOUD_MASK;
    SPRITE_Y_EXPAND = (SPRITE_Y_EXPAND & 0x00) | LARGE_CLOUD_MASK;
    SPRITE_ENABLE = 0xFF;
}

static void add_event(
    unsigned char *event,
    unsigned char base,
    unsigned int raster,
    unsigned char slot,
    unsigned int x,
    unsigned char y)
{
    unsigned char index = base + *event;

    rewrite_raster[index] = (unsigned char)raster;
    rewrite_raster_msb[index] = raster >> 8;
    rewrite_slot[index] = slot;
    rewrite_x[index] = (unsigned char)x;
    rewrite_x_msb[index] = (x & 0x100) != 0;
    rewrite_y[index] = y;
    ++*event;
}

static void calculate_cloud_pair(unsigned char slot)
{
    struct CloudPair *pair = &cloud_pairs[slot];
#ifdef TIMEPILOT_OBJECT_MODEL
    struct TpCloudRender render;
    unsigned char height = slot <= 3 ? 32 : 16;

    tp_project_cloud(slot, height, RASTER_SAFETY_LINES, &render);
    pair->first_x = render.first_x;
    pair->second_x = render.second_x;
    pair->first_y = render.first_y;
    pair->second_y = render.second_y;
    pair->rewrite_line = render.rewrite_line;
#else
    unsigned int first_x = (unsigned int)(clouds[slot].x >> CLOUD_FIXED_SHIFT) & 0x01FF;
    unsigned int second_x = (first_x + 128) & 0x01FF;
    unsigned char first_y = (unsigned char)(clouds[slot].y >> CLOUD_FIXED_SHIFT);
    unsigned char second_y = first_y + 128;
    unsigned char height = slot <= 3 ? 32 : 16;

    /* Whichever member of the diagonal pair is currently higher is drawn
       first. Crossing a 128-pixel band only swaps these two roles. */
    if (second_y < first_y) {
        unsigned int swap_x = first_x;
        unsigned char swap_y = first_y;
        first_x = second_x;
        first_y = second_y;
        second_x = swap_x;
        second_y = swap_y;
    }

    pair->first_x = first_x;
    pair->second_x = second_x;
    pair->first_y = first_y;
    pair->second_y = second_y;
    pair->rewrite_line = first_y + height + RASTER_SAFETY_LINES;
#endif
}

static void build_buffer(unsigned char buffer)
{
    unsigned char base = buffer * MAX_EVENTS;
    unsigned char event = 0;
    unsigned char order[CLOUD_SLOT_COUNT];
    unsigned char slot;
    unsigned char index;
    unsigned char previous;
    unsigned char candidate;

    /* Normalize both copies, then sort their individual safe rewrite lines. */
    for (slot = FIRST_CLOUD_SLOT; slot < SLOT_COUNT; ++slot) {
        calculate_cloud_pair(slot);
        order[slot - FIRST_CLOUD_SLOT] = slot;
    }
    for (index = 1; index < CLOUD_SLOT_COUNT; ++index) {
        candidate = order[index];
        previous = index;
        while (previous > 0 &&
               cloud_pairs[order[previous - 1]].rewrite_line >
               cloud_pairs[candidate].rewrite_line) {
            order[previous] = order[previous - 1];
            --previous;
        }
        order[previous] = candidate;
    }

    for (index = 0; index < CLOUD_SLOT_COUNT; ++index) {
        slot = order[index];
        add_event(
            &event,
            base,
            cloud_pairs[slot].rewrite_line,
            slot,
            cloud_pairs[slot].second_x,
            cloud_pairs[slot].second_y);
    }
    for (slot = FIRST_CLOUD_SLOT; slot < SLOT_COUNT; ++slot) {
        add_event(
            &event,
            base,
            RESTORE_RASTER_LINE,
            slot,
            cloud_pairs[slot].first_x,
            cloud_pairs[slot].first_y);
    }
    rewrite_count[buffer] = event;
}

static void copy_restore_group(unsigned char from_buffer, unsigned char to_buffer)
{
    unsigned char source = from_buffer * MAX_EVENTS + CLOUD_SLOT_COUNT;
    unsigned char target = to_buffer * MAX_EVENTS + CLOUD_SLOT_COUNT;
    unsigned char event;

    /* Called with IRQs disabled. Only the restore half of the active queue is
       replaced; its rewrite half has already been consumed in this frame. */
    for (event = 0; event < CLOUD_SLOT_COUNT; ++event) {
        rewrite_raster[target] = rewrite_raster[source];
        rewrite_raster_msb[target] = rewrite_raster_msb[source];
        rewrite_slot[target] = rewrite_slot[source];
        rewrite_x[target] = rewrite_x[source];
        rewrite_x_msb[target] = rewrite_x_msb[source];
        rewrite_y[target] = rewrite_y[source];
        ++source;
        ++target;
    }
}

static void install_first_cloud_copies(void)
{
    unsigned char slot;

    for (slot = FIRST_CLOUD_SLOT; slot < SLOT_COUNT; ++slot) {
        calculate_cloud_pair(slot);
        set_sprite_position(
            slot,
            cloud_pairs[slot].first_x,
            cloud_pairs[slot].first_y);
    }
}

static void update_clouds(unsigned char direction)
{
#ifdef TIMEPILOT_OBJECT_MODEL
    tp_update_objects(direction, vectors);
#else
    unsigned char slot;
    const long x_range = (long)512 << CLOUD_FIXED_SHIFT;
    const long y_range = (long)256 << CLOUD_FIXED_SHIFT;

    for (slot = FIRST_CLOUD_SLOT; slot < SLOT_COUNT; ++slot) {
        clouds[slot].x -= (long)vectors[direction][0] * clouds[slot].speed;
        clouds[slot].y -= (long)vectors[direction][1] * clouds[slot].speed;

        while (clouds[slot].x < 0) clouds[slot].x += x_range;
        while (clouds[slot].x >= x_range) clouds[slot].x -= x_range;
        while (clouds[slot].y < 0) clouds[slot].y += y_range;
        while (clouds[slot].y >= y_range) clouds[slot].y -= y_range;
    }
#endif
}

static void publish_next_frame(void)
{
    unsigned char back;

    __asm__("sei");
    if (rewrite_swap_pending) {
        __asm__("cli");
        return;
    }
    back = rewrite_front ^ 1;
    __asm__("cli");

    build_buffer(back);

    __asm__("sei");
    /* Atomically install the bases belonging to the prepared rewrite queue.
       The IRQ then swaps to that complete queue after performing the restore. */
    copy_restore_group(back, rewrite_front);
    rewrite_swap_pending = 1;
    __asm__("cli");
}

static void start_raster_rewrites(void)
{
    __asm__("sei");
    rewrite_event = 0;
    rewrite_front = 0;
    rewrite_swap_pending = 0;
    rewrite_debug_enabled = 0;
    VIC_CTRL1 &= 0x7F;
    if (rewrite_raster_msb[0]) VIC_CTRL1 |= 0x80;
    VIC_RASTER = rewrite_raster[0];
    VIC_IRQ_STATUS = 0x01;
    BACKGROUND_COLOR = TIME_PILOT_BACKGROUND_INDEX;
    VIC_IRQ_MASK |= 0x01;
    __asm__("cli");
}

static void stop_raster_rewrites(void)
{
    __asm__("sei");
    VIC_IRQ_MASK &= 0xFE;
    VIC_IRQ_STATUS = 0x01;
    __asm__("cli");
}

static void wait_for_next_frame(void)
{
    while (VIC_RASTER != 0) {
    }
    while (VIC_RASTER == 0) {
    }
}

static void select_plane_direction(unsigned char direction)
{
    const unsigned char *source;
    unsigned char source_index;
    unsigned char row;
    unsigned char column;
    unsigned char value;

    if (direction >= SOUTH && direction <= NORTH) {
        source_index = NORTH - direction;
        memcpy(PLANE_DATA, flight_frames[source_index], FLIGHT_FRAME_SIZE);
        return;
    }

    /* The source sheet contains one half-turn plus both endpoints. Mirror the
       artist-drawn opposite-side frame nibble by nibble for the other half. */
    source_index = (direction + SOUTH) & 31;
    source = flight_frames[source_index];
    for (row = 0; row < 16; ++row) {
        for (column = 0; column < 8; ++column) {
            value = source[row * 8 + (7 - column)];
            PLANE_DATA[row * 8 + column] =
                (value << 4) | (value >> 4);
        }
    }
}

int main(void)
{
    unsigned char direction = 0;
    unsigned char key;
    unsigned char held_keys;
    unsigned char turn_frames = 0;

    clrscr();
    enable_vic4_registers();
    install_palette();
    BORDER_COLOR = TIME_PILOT_BACKGROUND_INDEX;
    BACKGROUND_COLOR = TIME_PILOT_BACKGROUND_INDEX;
#ifdef TIMEPILOT_OBJECT_MODEL
    /* Configure the 16-bit FCM screen before fixing the sprite-pointer table.
       Changing the VIC screen layout can also change the classic pointer-table
       path. initialise_cloud_sprites() must therefore be the final owner of
       $D06C-$D06E. */
    tp_hud_initialise();
#endif
    initialise_cloud_sprites();
#ifdef TIMEPILOT_OBJECT_MODEL
    tp_initialise_objects(initial_x, initial_y);
#endif
    select_plane_direction(direction);

#if SINGLE_CLOUD_DIAGNOSTIC
    /* Isolate sprite data, pointer and colour mode from all raster rewriting.
       Slot 0 uses cloud_frames[0] copied to $4000. */
    gotoxy(1, 1);
    cprintf("SINGLE CLOUD DIAGNOSTIC");
    gotoxy(1, 2);
    cprintf("SLOT 0, LEGACY POINTER, Q ENDET");

    /* Follow the known-good tile_demo path exactly: use the VIC's existing
       pointer table, an 8-bit pointer and sprite data in VIC bank 0. */
    enable_vic4_registers();
    VIC_HOTREG &= 0x7F;
    install_palette();
    memcpy((unsigned char *)DIAGNOSTIC_SPRITE_ADDRESS,
           cloud_frames[0], CLOUD_FRAME_SIZE);
    {
        unsigned int pointer_table =
            SPRITE_PTR_LOW | ((unsigned int)SPRITE_PTR_HIGH << 8);
        SPRITE_PTR_BANK &= 0x7F;
        *(unsigned char *)pointer_table = DIAGNOSTIC_SPRITE_ADDRESS / 64;
    }
    SPRITE_COLOR[0] = 0;
    SPRITE_ENABLE = 0x01;
    SPRITE_X_EXPAND = 0x00;
    SPRITE_Y_EXPAND = 0x00;
    SPRITE_HEIGHTEN = 0x01;
    SPRITE_X64EN = 0x01;
    SPRITE_16EN = 0x01;
    SPRITE_MULTICOLOR = 0x00;
    set_sprite_position(0, 180, 120);

    while (1) {
        /* Reassert only slot 0 so a changed mode register is immediately
           visible independently of the multiplex IRQ code. */
        SPRITE_X64EN = 0x01;
        SPRITE_16EN = 0x01;
        SPRITE_MULTICOLOR = 0x00;
        if (kbhit()) {
            key = cgetc();
            if (key == 'q' || key == 'Q') break;
        }
        wait_for_next_frame();
    }

    SPRITE_ENABLE = 0;
    return 0;
#else
    install_first_cloud_copies();
    build_buffer(0);
    build_buffer(1);
    start_raster_rewrites();

    /* Keep the VIC-IV full-colour interpretation explicit after installing
       the KERNAL-compatible raster IRQ chain. */
    SPRITE_X64EN = 0xFF;
    SPRITE_16EN = 0xFF;
    SPRITE_MULTICOLOR = 0x00;

#ifndef TIMEPILOT_OBJECT_MODEL
    gotoxy(1, 1);
    cprintf("TIME PILOT CLOUD MULTIPLEX");
    gotoxy(1, 2);
    cprintf("LINKS/RECHTS, D DEBUG, Q ENDET");
#endif

    while (1) {
        SPRITE_X64EN = 0xFF;
        SPRITE_16EN = 0xFF;
        SPRITE_MULTICOLOR = 0x00;
        held_keys = read_cursor_keys();
        if (held_keys == KEY_HELD_LEFT || held_keys == KEY_HELD_RIGHT) {
            if (turn_frames == 0) {
                if (held_keys == KEY_HELD_LEFT) direction = (direction - 1) & 31;
                else direction = (direction + 1) & 31;
#ifdef TIMEPILOT_OBJECT_MODEL
                tp_set_player_direction(direction);
#endif
                select_plane_direction(direction);
                turn_frames = TURN_FRAME_INTERVAL - 1;
            } else {
                --turn_frames;
            }
        } else {
            turn_frames = 0;
        }

        if (kbhit()) {
            key = cgetc();
            if (key == 'q' || key == 'Q') break;
            if (key == 'd' || key == 'D') {
                __asm__("sei");
                rewrite_debug_enabled ^= 1;
                if (!rewrite_debug_enabled) {
                    BACKGROUND_COLOR = TIME_PILOT_BACKGROUND_INDEX;
                }
                __asm__("cli");
            }
        }

        update_clouds(direction);
        publish_next_frame();
        wait_for_next_frame();
    }

    stop_raster_rewrites();
    SPRITE_ENABLE = 0;
    return 0;
#endif
}
