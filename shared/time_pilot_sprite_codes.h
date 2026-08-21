#ifndef TIME_PILOT_SPRITE_CODES_H
#define TIME_PILOT_SPRITE_CODES_H

/*
 * Confirmed interactively with sprite_browser_demo.
 *
 * Both rotation strips cover the visible half-turn from up via left toward
 * down. Do not assume that the following code is the exact down frame until
 * it has been checked against the original game's object tables.
 */
#define TP_SPRITE_PLAYER_FINE_FIRST       232
#define TP_SPRITE_PLAYER_FINE_UP          232
#define TP_SPRITE_PLAYER_FINE_LEFT        240
#define TP_SPRITE_PLAYER_FINE_ALMOST_DOWN 247
#define TP_SPRITE_PLAYER_FINE_LAST        247
#define TP_SPRITE_PLAYER_FINE_COUNT       16

/* Exact ROM table at Z80 $20ce, indexed by the 32-step player direction. */
static const unsigned char tp_player_sprite_by_direction[32] = {
    240,241,242,243,244,245,246,247,232,247,246,245,244,243,242,241,
    240,239,238,237,236,235,234,233,232,233,234,235,236,237,238,239
};

/* Matching original color/flip attributes from Z80 $20ee. */
static const unsigned char tp_player_attribute_by_direction[32] = {
    0x40,0x40,0x40,0x40,0x40,0x40,0x40,0x40,
    0x80,0xC0,0xC0,0xC0,0xC0,0xC0,0xC0,0xC0,
    0xC0,0xC0,0xC0,0xC0,0xC0,0xC0,0xC0,0xC0,
    0x40,0x40,0x40,0x40,0x40,0x40,0x40,0x40
};

#define TP_SPRITE_ENEMY_COARSE_FIRST       40
#define TP_SPRITE_ENEMY_COARSE_UP          40
#define TP_SPRITE_ENEMY_COARSE_ALMOST_DOWN 47
#define TP_SPRITE_ENEMY_COARSE_LAST        47
#define TP_SPRITE_ENEMY_COARSE_COUNT        8

/* Exact 16-step object table at Z80 $2b18. */
static const unsigned char tp_enemy_sprite_by_direction[16] = {
    44,45,46,47,40,47,46,45,44,43,42,41,40,41,42,43
};

static const unsigned char tp_enemy_attribute_by_direction[16] = {
    0x5B,0x5B,0x5B,0x5B,0x9B,0xDB,0xDB,0xDB,
    0xDB,0xDB,0xDB,0xDB,0x5B,0x5B,0x5B,0x5B
};

#endif
