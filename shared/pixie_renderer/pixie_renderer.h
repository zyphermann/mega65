#ifndef PIXIE_RENDERER_H
#define PIXIE_RENDERER_H

#define PIXIE_RENDER_ROWS          25
#define PIXIE_RENDER_ENTRIES       80
#define PIXIE_RENDER_ROW_BYTES     (PIXIE_RENDER_ENTRIES * 2)
#define PIXIE_RENDER_VIEW_WIDTH    320
#define PIXIE_BACKGROUND_CHARS     21

typedef struct PixieObject {
    int x;
    int y;
    unsigned int character_base;
    unsigned char frame;
    unsigned char frame_stride;
    unsigned char phase_stride;
    unsigned char width_chars;
    unsigned char height_slices;
    unsigned char row_stride;
    unsigned char palette_bank;
    unsigned char visible;
} PixieObject;

typedef struct PixieBackground {
    unsigned int character_base;
    unsigned char alternate_character_offset;
    unsigned char palette_bank;
    unsigned char scroll_x;
    unsigned char scroll_y;
} PixieBackground;

void pixie_renderer_begin(unsigned char *screen, unsigned char *color,
                          const PixieBackground *layers,
                          unsigned char layer_count);
unsigned char pixie_renderer_draw(const PixieObject *objects,
                                  unsigned char object_count,
                                  unsigned char reserved_top_rows,
                                  unsigned char reserved_entries);
unsigned char pixie_renderer_append_gotox(unsigned char row, int x);
void pixie_renderer_set_background_tile(unsigned char row,
                                        unsigned char layer,
                                        unsigned char tile,
                                        unsigned int character);
unsigned char pixie_renderer_append_fcm(unsigned char row,
                                        unsigned int character);
unsigned char pixie_renderer_append_fcm_palette(unsigned char row,
                                                unsigned int character,
                                                unsigned char palette_bank);
void pixie_renderer_finish(unsigned int transparent_character);
unsigned char pixie_renderer_row_entries(unsigned char row);
/* Logical entries currently generated across all rows.  Each entry occupies
   two screen bytes and two colour bytes. */
unsigned int pixie_renderer_total_entries(void);

#endif
