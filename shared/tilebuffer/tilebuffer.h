#ifndef TILEBUFFER_H
#define TILEBUFFER_H

typedef struct TileBuffer {
    unsigned char *tiles;
    unsigned int width;
    unsigned int height;
    unsigned int origin_x;
    unsigned int origin_y;
    unsigned int scroll_x;
    unsigned int scroll_y;
    unsigned char fine_x;
    unsigned char fine_y;
    unsigned char tile_width;
    unsigned char tile_height;
    unsigned char mode;
    unsigned char revision;
    unsigned char blank_tile;
} TileBuffer;

#define TILEBUFFER_WRAP  0
#define TILEBUFFER_CLAMP 1

void tilebuffer_init(TileBuffer *buffer, unsigned char *storage,
                     unsigned int width, unsigned int height);
void tilebuffer_init_sized(TileBuffer *buffer, unsigned char *storage,
                           unsigned int width, unsigned int height,
                           unsigned char tile_width,
                           unsigned char tile_height);
void tilebuffer_set_mode(TileBuffer *buffer, unsigned char mode);
void tilebuffer_set_blank(TileBuffer *buffer, unsigned char tile);
unsigned char tilebuffer_get(const TileBuffer *buffer,
                             unsigned int x, unsigned int y);
void tilebuffer_set(TileBuffer *buffer, unsigned int x, unsigned int y,
                    unsigned char tile);
unsigned char tilebuffer_view(const TileBuffer *buffer,
                              unsigned int column, unsigned int row);
void tilebuffer_scroll(TileBuffer *buffer, int dx, int dy);
void tilebuffer_set_scroll(TileBuffer *buffer, unsigned int x, unsigned int y);

#endif
