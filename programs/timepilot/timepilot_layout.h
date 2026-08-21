#ifndef TIMEPILOT_LAYOUT_H
#define TIMEPILOT_LAYOUT_H

#define TP_PLAYFIELD_WIDTH 224
#define TP_PLAYFIELD_HEIGHT 200
#define TP_VIC_VISIBLE_X 24
#define TP_VIC_VISIBLE_Y 50
#define TP_PLAYER_SIZE 16

/* The ROM artwork is optically left/bottom-heavy inside its 16x16 box.
   Keep this presentation correction separate from gameplay coordinates. */
#define TP_PLAYER_ART_ADJUST_X 2
#define TP_PLAYER_ART_ADJUST_Y (-2)

#define TP_PLAYER_VIC_X \
    (TP_VIC_VISIBLE_X + (TP_PLAYFIELD_WIDTH - TP_PLAYER_SIZE) / 2 + \
     TP_PLAYER_ART_ADJUST_X)
#define TP_PLAYER_VIC_Y \
    (TP_VIC_VISIBLE_Y + (TP_PLAYFIELD_HEIGHT - TP_PLAYER_SIZE) / 2 + \
     TP_PLAYER_ART_ADJUST_Y)

/* Logical anchor of the already calibrated tm6 projectile renderer. */
#define TP_PLAYER_MUZZLE_X 111
#define TP_PLAYER_MUZZLE_Y 91

#endif
