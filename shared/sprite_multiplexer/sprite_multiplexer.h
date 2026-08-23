#ifndef SPRITE_MULTIPLEXER_H
#define SPRITE_MULTIPLEXER_H

#define SMUX_MAX_LOGICAL_SPRITES 256
#define SMUX_MAX_EVENTS 64
#define SMUX_HARDWARE_SLOTS 8

/* One independent 16-pixel-high VIC-IV sprite submitted by the game. */
struct SmuxSprite {
    unsigned int x;
    unsigned char y;
    unsigned char image;
    unsigned char priority;
};

/* Reset the logical list before submitting the next complete frame. */
void smux_begin_frame(void);
unsigned char smux_add(unsigned int x, unsigned char y,
                       unsigned char image, unsigned char priority);

/* Builds the backbuffer outside the raster IRQ and publishes it atomically. */
void smux_build_and_publish(void);

/* Call after VIC-IV sprite data, palette and pointer-table setup. */
void smux_start(void);
void smux_stop(void);

unsigned int smux_submitted_count(void);
unsigned int smux_scheduled_count(void);
unsigned int smux_dropped_count(void);
void smux_set_debug(unsigned char enabled);

#endif
