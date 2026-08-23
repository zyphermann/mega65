#include "pixie_renderer.h"

#define COLOR_GOTOX       0x10
#define COLOR_TRANSPARENT 0x80
#define COLOR_NCM         0x08
#define END_GOTO_ENTRY    (PIXIE_RENDER_ENTRIES - 2)
#define END_DUMMY_ENTRY   (PIXIE_RENDER_ENTRIES - 1)
#define BACKGROUND_DMA_JOBS (PIXIE_RENDER_ROWS * 2)
#define REG8(address) (*(volatile unsigned char *)(address))

struct BackgroundDmaJob {
    unsigned char command;
    unsigned int count;
    unsigned int source;
    unsigned char source_bank;
    unsigned int destination;
    unsigned char destination_bank;
    unsigned char subcommand;
    unsigned int modulo;
};

struct BackgroundDmaNext {
    unsigned char end_options;
    struct BackgroundDmaJob job;
};

struct BackgroundDmaList {
    unsigned char option_0b;
    unsigned char option_80;
    unsigned char source_mb;
    unsigned char option_81;
    unsigned char destination_mb;
    unsigned char end_options;
    struct BackgroundDmaJob first_job;
    struct BackgroundDmaNext next[BACKGROUND_DMA_JOBS - 1];
};

static unsigned char *screen_base;
static unsigned char *color_base;
static unsigned char *screen_out;
static unsigned char *color_out;
/* Every raster row is its own fixed-capacity display-list buffer.  Keep the
   append position instead of recalculating row * ROW_BYTES for every slice. */
static unsigned char *row_screen_out[PIXIE_RENDER_ROWS];
static unsigned char *row_color_out[PIXIE_RENDER_ROWS];
static unsigned char used[PIXIE_RENDER_ROWS];
static unsigned char *known_screen[2];
static unsigned char initialized[2];
static unsigned char background_initialized[2];
static unsigned char previous_used[2][PIXIE_RENDER_ROWS];
static unsigned char current_buffer;
#define background_dma ((struct BackgroundDmaList *)0xB800)
static unsigned char background_dma_initialized[2];

#define WRITE_ENTRY(value, attribute, palette) do {                 \
    unsigned int write_value = (value);                           \
    *screen_out++ = (unsigned char)write_value;                    \
    *screen_out++ = (unsigned char)(write_value >> 8);             \
    *color_out++ = (attribute);                                    \
    *color_out++ = (palette);                                      \
} while (0)

static void set_output(unsigned char row, unsigned char entry)
{
    unsigned int offset = (unsigned int)row * PIXIE_RENDER_ROW_BYTES +
                          (unsigned int)entry * 2;
    screen_out = screen_base + offset;
    color_out = color_base + offset;
}

static void prepare_background_dma(unsigned char *screen)
{
    struct BackgroundDmaList *list = &background_dma[current_buffer];
    struct BackgroundDmaJob *job;
    unsigned char row;
    unsigned char layer;
    unsigned char index = 0;

    list->option_0b = 0x0B;
    list->option_80 = 0x80;
    list->source_mb = 0;
    list->option_81 = 0x81;
    list->destination_mb = 0;
    list->end_options = 0;
    for (row = 0; row < PIXIE_RENDER_ROWS; ++row) {
        for (layer = 0; layer < 2; ++layer) {
            unsigned int run = (unsigned int)(screen +
                (unsigned int)row * PIXIE_RENDER_ROW_BYTES +
                ((unsigned int)layer * (PIXIE_BACKGROUND_CHARS + 1) + 1) * 2);
            if (!index) job = &list->first_job;
            else {
                list->next[index - 1].end_options = 0;
                job = &list->next[index - 1].job;
            }
            job->command = 0x04; /* Copy, another enhanced request follows. */
            job->count = PIXIE_BACKGROUND_CHARS * 2 - 4;
            job->source = run;
            job->source_bank = 0;
            job->destination = run + 4;
            job->destination_bank = 0;
            job->subcommand = 0;
            job->modulo = 0;
            ++index;
        }
    }
    list->next[BACKGROUND_DMA_JOBS - 2].job.command = 0;
    background_dma_initialized[current_buffer] = 1;
}

static void run_background_dma(void)
{
    unsigned int address = (unsigned int)&background_dma[current_buffer];
    REG8(0xD702) = 0;
    REG8(0xD704) = 0;
    REG8(0xD701) = (unsigned char)(address >> 8);
    REG8(0xD705) = (unsigned char)address;
}

void pixie_renderer_begin(unsigned char *screen, unsigned char *color,
                          const PixieBackground *layers,
                          unsigned char layer_count)
{
    unsigned char row;
    unsigned char background_entries =
        layer_count * (PIXIE_BACKGROUND_CHARS + 1);
    unsigned char use_background_dma = layer_count == 2 &&
        !layers[0].alternate_character_offset &&
        !layers[1].alternate_character_offset;

    if (known_screen[0] == screen) current_buffer = 0;
    else if (known_screen[1] == screen) current_buffer = 1;
    else if (!known_screen[0]) {
        known_screen[0] = screen;
        current_buffer = 0;
    } else {
        known_screen[1] = screen;
        current_buffer = 1;
    }

    screen_base = screen;
    color_base = color;
    if (use_background_dma && !background_dma_initialized[current_buffer])
        prepare_background_dma(screen);
    for (row = 0; row < PIXIE_RENDER_ROWS; ++row) {
        unsigned char layer;
        unsigned char entries = 0;

        screen_out = screen + (unsigned int)row * PIXIE_RENDER_ROW_BYTES;
        color_out = color + (unsigned int)row * PIXIE_RENDER_ROW_BYTES;

        if (!initialized[current_buffer]) {
            unsigned char entry;
            for (entry = 0; entry < PIXIE_RENDER_ENTRIES; ++entry)
                WRITE_ENTRY(PIXIE_RENDER_VIEW_WIDTH - 1,
                            COLOR_GOTOX | COLOR_TRANSPARENT, 0);
        } else if (previous_used[current_buffer][row] > background_entries) {
            unsigned char entry;
            set_output(row, background_entries);
            for (entry = background_entries;
                 entry < previous_used[current_buffer][row]; ++entry)
                WRITE_ENTRY(PIXIE_RENDER_VIEW_WIDTH - 1,
                            COLOR_GOTOX | COLOR_TRANSPARENT, 0);
        }

        screen_out = screen + (unsigned int)row * PIXIE_RENDER_ROW_BYTES;
        color_out = color + (unsigned int)row * PIXIE_RENDER_ROW_BYTES;

        for (layer = 0; layer < layer_count; ++layer) {
            unsigned char tile;
            unsigned char palette = layers[layer].palette_bank;
            unsigned char tile_phase = layers[layer].scroll_x >> 4;
            /* GOTOX performs only fine scrolling inside the native 16-pixel
               NCM character. Passing the full world X moved the entire run
               progressively off-screen and made a layer disappear. */
            unsigned int x = (unsigned int)(-(int)
                (layers[layer].scroll_x & 15)) & 0x03FF;
            unsigned int character = layers[layer].character_base +
                ((layers[layer].scroll_y + row * 8) & 15);

            /* The background layout and its colour attributes are static.
               Only GOTOX and the character selected for the current vertical
               phase change while scrolling.  Avoid rewriting two colour
               bytes for every background character on every frame: colour
               RAM is the expensive half of this cc65 hot loop. */
            *screen_out++ = (unsigned char)x;
            *screen_out++ = (unsigned char)(x >> 8);
            if (!background_initialized[current_buffer]) {
                *color_out++ = COLOR_GOTOX | COLOR_TRANSPARENT;
                *color_out++ = 0;
            } else {
                color_out += 2;
            }
            ++entries;
            if (use_background_dma) {
                /* Four seed bytes are enough for DMAgic's pipelined forward
                   copy to repeat this word through the remaining 19 cells. */
                *screen_out++ = (unsigned char)character;
                *screen_out++ = (unsigned char)(character >> 8);
                *screen_out++ = (unsigned char)character;
                *screen_out++ = (unsigned char)(character >> 8);
                screen_out += PIXIE_BACKGROUND_CHARS * 2 - 4;
                if (!background_initialized[current_buffer]) {
                    for (tile = 0; tile < PIXIE_BACKGROUND_CHARS; ++tile) {
                        *color_out++ = COLOR_NCM;
                        *color_out++ = palette;
                    }
                } else {
                    color_out += PIXIE_BACKGROUND_CHARS * 2;
                }
            } else {
                for (tile = 0; tile < PIXIE_BACKGROUND_CHARS; ++tile) {
                    unsigned int tile_character = character;
                    if (((tile + tile_phase) & 1) &&
                        layers[layer].alternate_character_offset)
                        tile_character += layers[layer].alternate_character_offset;
                    *screen_out++ = (unsigned char)tile_character;
                    *screen_out++ = (unsigned char)(tile_character >> 8);
                    if (!background_initialized[current_buffer]) {
                        *color_out++ = COLOR_NCM;
                        *color_out++ = palette;
                    } else {
                        color_out += 2;
                    }
                }
            }
            entries += PIXIE_BACKGROUND_CHARS;
        }
        used[row] = entries;
        row_screen_out[row] = screen_out;
        row_color_out[row] = color_out;
    }
    if (use_background_dma)
        run_background_dma();
    background_initialized[current_buffer] = 1;
    initialized[current_buffer] = 1;
}

unsigned char pixie_renderer_draw(const PixieObject *objects,
                                  unsigned char object_count,
                                  unsigned char reserved_top_rows,
                                  unsigned char reserved_entries)
{
    unsigned char dropped = 0;

    while (object_count--) {
        if (objects->visible) {
            int y = objects->y;
            unsigned char row = (unsigned int)y >> 3;
            unsigned char phase = y & 7;
            unsigned int character = objects->character_base +
                (unsigned int)objects->frame * objects->frame_stride +
                (unsigned int)phase * objects->phase_stride;
            unsigned char slice;

            for (slice = 0; slice < objects->height_slices; ++slice) {
                unsigned char target_row = row + slice;
                unsigned char limit = END_GOTO_ENTRY;
                unsigned char entry;
                unsigned char width = objects->width_chars;
                if (target_row < reserved_top_rows)
                    limit -= reserved_entries;
                if (target_row >= PIXIE_RENDER_ROWS) {
                    ++dropped;
                } else {
                    entry = used[target_row];
                    if ((unsigned int)entry + 1 + width > limit) {
                        ++dropped;
                    } else {
                        unsigned int encoded = (unsigned int)objects->x & 0x03FF;
                        unsigned int run_character = character;
                        screen_out = row_screen_out[target_row];
                        color_out = row_color_out[target_row];
                        WRITE_ENTRY(encoded,
                                    COLOR_GOTOX | COLOR_TRANSPARENT, 0);
                        while (width--) {
                            WRITE_ENTRY(run_character++, COLOR_NCM,
                                        objects->palette_bank);
                        }
                        used[target_row] = entry + objects->width_chars + 1;
                        row_screen_out[target_row] = screen_out;
                        row_color_out[target_row] = color_out;
                    }
                }
                character += objects->row_stride;
            }
        }
        ++objects;
    }
    return dropped;
}

unsigned char pixie_renderer_append_gotox(unsigned char row, int x)
{
    unsigned char entry;
    if (row >= PIXIE_RENDER_ROWS || used[row] >= END_GOTO_ENTRY) return 0;
    entry = used[row]++;
    screen_out = row_screen_out[row];
    color_out = row_color_out[row];
    WRITE_ENTRY((unsigned int)x & 0x03FF,
                COLOR_GOTOX | COLOR_TRANSPARENT, 0);
    row_screen_out[row] = screen_out;
    row_color_out[row] = color_out;
    return 1;
}

void pixie_renderer_set_background_tile(unsigned char row,
                                        unsigned char layer,
                                        unsigned char tile,
                                        unsigned int character)
{
    unsigned int entry;
    unsigned char *target;
    if (row >= PIXIE_RENDER_ROWS || tile >= PIXIE_BACKGROUND_CHARS)
        return;
    entry = (unsigned int)layer * (PIXIE_BACKGROUND_CHARS + 1) + 1 + tile;
    if (entry >= PIXIE_RENDER_ENTRIES) return;
    target = screen_base + (unsigned int)row * PIXIE_RENDER_ROW_BYTES + entry * 2;
    target[0] = (unsigned char)character;
    target[1] = (unsigned char)(character >> 8);
}

unsigned char pixie_renderer_append_fcm(unsigned char row,
                                        unsigned int character)
{
    return pixie_renderer_append_fcm_palette(row, character, 0);
}

unsigned char pixie_renderer_append_fcm_palette(unsigned char row,
                                                unsigned int character,
                                                unsigned char palette_bank)
{
    unsigned char entry;
    if (row >= PIXIE_RENDER_ROWS || used[row] >= END_GOTO_ENTRY) return 0;
    entry = used[row]++;
    screen_out = row_screen_out[row];
    color_out = row_color_out[row];
    WRITE_ENTRY(character, 0, palette_bank);
    row_screen_out[row] = screen_out;
    row_color_out[row] = color_out;
    return 1;
}

void pixie_renderer_finish(unsigned int transparent_character)
{
    unsigned char row;

    for (row = 0; row < PIXIE_RENDER_ROWS; ++row) {
        unsigned char entry = used[row];
        previous_used[current_buffer][row] = entry;
        /* Unused slots were initialized once and stale dynamic slots are
           cleared in begin(). Only the formal final pair changes here. */
        set_output(row, END_GOTO_ENTRY);
        WRITE_ENTRY(PIXIE_RENDER_VIEW_WIDTH - 1,
                    COLOR_GOTOX | COLOR_TRANSPARENT, 0);
        WRITE_ENTRY(transparent_character,
                    COLOR_NCM, 0);
    }
}

unsigned char pixie_renderer_row_entries(unsigned char row)
{
    return row < PIXIE_RENDER_ROWS ? used[row] : 0;
}

unsigned int pixie_renderer_total_entries(void)
{
    unsigned char row;
    unsigned int total = 0;
    for (row = 0; row < PIXIE_RENDER_ROWS; ++row)
        total += used[row];
    return total;
}
