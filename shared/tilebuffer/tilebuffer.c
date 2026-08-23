#include "tilebuffer.h"

static unsigned int wrap(unsigned int value, unsigned int limit)
{
    return limit ? value % limit : 0;
}

void tilebuffer_init(TileBuffer *buffer, unsigned char *storage,
                     unsigned int width, unsigned int height)
{
    tilebuffer_init_sized(buffer, storage, width, height, 8, 8);
}

void tilebuffer_init_sized(TileBuffer *buffer, unsigned char *storage,
                           unsigned int width, unsigned int height,
                           unsigned char tile_width,
                           unsigned char tile_height)
{
    buffer->tiles = storage;
    buffer->width = width;
    buffer->height = height;
    buffer->origin_x = buffer->origin_y = 0;
    buffer->scroll_x = buffer->scroll_y = 0;
    buffer->fine_x = buffer->fine_y = 0;
    buffer->tile_width = tile_width ? tile_width : 1;
    buffer->tile_height = tile_height ? tile_height : 1;
    buffer->mode = TILEBUFFER_WRAP;
    buffer->revision = 1;
    buffer->blank_tile = 0;
}

void tilebuffer_set_blank(TileBuffer *buffer, unsigned char tile)
{
    buffer->blank_tile = tile;
    ++buffer->revision;
}

void tilebuffer_set_mode(TileBuffer *buffer, unsigned char mode)
{
    buffer->mode = mode;
    ++buffer->revision;
}

unsigned char tilebuffer_get(const TileBuffer *buffer,
                             unsigned int x, unsigned int y)
{
    if (!buffer->width || !buffer->height) return 0;
    if (buffer->mode == TILEBUFFER_CLAMP &&
        (x >= buffer->width || y >= buffer->height)) return buffer->blank_tile;
    x = wrap(x, buffer->width);
    y = wrap(y, buffer->height);
    return buffer->tiles[y * buffer->width + x];
}

void tilebuffer_set(TileBuffer *buffer, unsigned int x, unsigned int y,
                    unsigned char tile)
{
    if (!buffer->width || !buffer->height) return;
    x = wrap(x, buffer->width);
    y = wrap(y, buffer->height);
    buffer->tiles[y * buffer->width + x] = tile;
    ++buffer->revision;
}

unsigned char tilebuffer_view(const TileBuffer *buffer,
                              unsigned int column, unsigned int row)
{
    return tilebuffer_get(buffer, buffer->origin_x + column,
                          buffer->origin_y + row);
}

void tilebuffer_scroll(TileBuffer *buffer, int dx, int dy)
{
    long next;
    unsigned int pixel_limit;
    if (!buffer->width || !buffer->height) return;
    pixel_limit = buffer->width * buffer->tile_width;
    next = (long)buffer->scroll_x + dx;
    if (buffer->mode == TILEBUFFER_WRAP) {
        while (next < 0) next += pixel_limit;
        while (next >= pixel_limit) next -= pixel_limit;
    } else {
        if (next < 0) next = 0;
        if (next >= pixel_limit) next = pixel_limit - 1;
    }
    buffer->scroll_x = (unsigned int)next;

    pixel_limit = buffer->height * buffer->tile_height;
    next = (long)buffer->scroll_y + dy;
    if (buffer->mode == TILEBUFFER_WRAP) {
        while (next < 0) next += pixel_limit;
        while (next >= pixel_limit) next -= pixel_limit;
    } else {
        if (next < 0) next = 0;
        if (next >= pixel_limit) next = pixel_limit - 1;
    }
    buffer->scroll_y = (unsigned int)next;
    buffer->origin_x = buffer->scroll_x / buffer->tile_width;
    buffer->origin_y = buffer->scroll_y / buffer->tile_height;
    buffer->fine_x = buffer->scroll_x & (buffer->tile_width - 1);
    buffer->fine_y = buffer->scroll_y & (buffer->tile_height - 1);
}

void tilebuffer_set_scroll(TileBuffer *buffer, unsigned int x, unsigned int y)
{
    buffer->scroll_x = buffer->scroll_y = 0;
    tilebuffer_scroll(buffer, (int)x, (int)y);
}
