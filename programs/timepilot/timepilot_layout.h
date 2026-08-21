#ifndef TIMEPILOT_LAYOUT_H
#define TIMEPILOT_LAYOUT_H

#define TP_PLAYFIELD_WIDTH 224
#define TP_PLAYFIELD_HEIGHT 200
#define TP_PLAYER_SIZE 16

/* The ROM artwork is optically left/bottom-heavy inside its 16x16 box.
   Keep this presentation correction separate from gameplay coordinates. */
#define TP_PLAYER_ART_ADJUST_X 0
#define TP_PLAYER_ART_ADJUST_Y (-2)

#define TP_PLAYER_LOGICAL_X \
    ((TP_PLAYFIELD_WIDTH - TP_PLAYER_SIZE) / 2 + TP_PLAYER_ART_ADJUST_X)
#define TP_PLAYER_LOGICAL_Y \
    ((TP_PLAYFIELD_HEIGHT - TP_PLAYER_SIZE) / 2 + TP_PLAYER_ART_ADJUST_Y)

/* Logical anchor of the already calibrated tm6 projectile renderer. */
#define TP_PLAYER_MUZZLE_X 109
#define TP_PLAYER_MUZZLE_Y 91

extern unsigned int tp_playfield_origin_x;
extern unsigned char tp_playfield_origin_y;

void tp_layout_initialise(void);
unsigned int tp_sprite_x(unsigned int logical_x);
unsigned char tp_sprite_y(unsigned char logical_y);

#endif
