#include "object_model.h"
#include "timepilot_layout.h"

#define TP_FIXED_SHIFT 8

#pragma code-name ("OBJECTCODE")

struct TpObject tp_objects[TP_OBJECT_COUNT];
struct TpShot tp_shots[TP_SHOT_COUNT];
static unsigned char shot_direction[TP_SHOT_COUNT];
static unsigned char fire_was_held;
static unsigned char fire_release_frames;
static unsigned char shot_cooldown;
static unsigned char burst_remaining;

#define TP_FIRE_RELEASE_DEBOUNCE 3

/* Original ROM $2771: 32 rounded projectile origins around the fixed player,
   normalized from its arcade centre (120,132).  Unlike a scaled direction
   vector this follows the asymmetric 16x16 artwork without diagonal wobble. */
static const signed char muzzle_x[32] = {
     6,  6,  6,  5,  4,  3,  2,  1,
     0, -1, -2, -3, -4, -5, -6, -6,
    -6, -6, -6, -5, -4, -3, -2, -1,
     0,  1,  2,  3,  4,  5,  6,  6
};
static const signed char muzzle_y[32] = {
     0,  1,  2,  3,  4,  5,  6,  6,
     6,  6,  6,  5,  4,  3,  2,  1,
     0, -1, -2, -3, -4, -5, -6, -6,
    -6, -6, -6, -5, -4, -3, -2, -1
};

void tp_initialise_objects(const unsigned int *initial_x,
                           const unsigned char *initial_y)
{
    unsigned char slot;

    fire_was_held = 0;
    fire_release_frames = TP_FIRE_RELEASE_DEBOUNCE;
    shot_cooldown = 0;
    burst_remaining = 0;
    for (slot = 0; slot < TP_SHOT_COUNT; ++slot)
        tp_shots[slot].active = 0;

    tp_objects[TP_PLAYER_OBJECT].state = TP_OBJECT_ACTIVE;
    tp_objects[TP_PLAYER_OBJECT].type = TP_OBJECT_PLAYER;
    tp_objects[TP_PLAYER_OBJECT].direction = 0;
    tp_objects[TP_PLAYER_OBJECT].speed = 0;
    /* Logical coordinates are relative to the 224x200 playfield, unlike the
       VIC sprite registers which include the (24,50) display origin. */
    tp_objects[TP_PLAYER_OBJECT].x = (long)112 << TP_FIXED_SHIFT;
    tp_objects[TP_PLAYER_OBJECT].y = (long)100 << TP_FIXED_SHIFT;

    for (slot = TP_FIRST_CLOUD_OBJECT; slot < TP_OBJECT_COUNT; ++slot) {
        struct TpObject *object = &tp_objects[slot];
        object->state = TP_OBJECT_ACTIVE;
        object->type = TP_OBJECT_CLOUD;
        object->direction = 0;
        /* Slots 1..4 form the fast foreground layer; 5..7 are the slower,
           smaller background clouds. */
        object->speed = slot <= 4 ? 24 : 8;
        object->x = (long)initial_x[slot] << TP_FIXED_SHIFT;
        object->y = (long)initial_y[slot] << TP_FIXED_SHIFT;
    }
}

void tp_set_fire(unsigned char held, unsigned char direction)
{
    unsigned char slot;

    /* The original recognises a new press from a shifted input history and
       spaces the three rounds by six frames. The emulated CIA matrix can
       briefly read released while Space is held, so require three stable
       released frames before arming the next edge. */
    if (held) {
        fire_release_frames = 0;
        if (!fire_was_held) {
            burst_remaining = 3;
            fire_was_held = 1;
        }
    } else if (fire_release_frames < TP_FIRE_RELEASE_DEBOUNCE) {
        ++fire_release_frames;
        if (fire_release_frames == TP_FIRE_RELEASE_DEBOUNCE)
            fire_was_held = 0;
    }
    if (shot_cooldown) --shot_cooldown;
    if (!burst_remaining || shot_cooldown) return;

    for (slot = 0; slot < TP_SHOT_COUNT; ++slot) {
        if (!tp_shots[slot].active) {
            tp_shots[slot].active = 1;
            direction &= 31;
            /* Sprite registers include the VIC display origin; FCM tile
               coordinates do not.  The visible art is centred at (111,99),
               then the original rounded muzzle table supplies the offset. */
            tp_shots[slot].x =
                (long)(TP_PLAYER_MUZZLE_X + muzzle_x[direction]) <<
                TP_FIXED_SHIFT;
            tp_shots[slot].y =
                (long)(TP_PLAYER_MUZZLE_Y + muzzle_y[direction]) <<
                TP_FIXED_SHIFT;
            shot_direction[slot] = direction;
            --burst_remaining;
            shot_cooldown = 6;
            return;
        }
    }
}

void tp_update_shots(const signed char vectors[32][2])
{
    unsigned char slot;
    for (slot = 0; slot < TP_SHOT_COUNT; ++slot) {
        struct TpShot *shot = &tp_shots[slot];
        unsigned char direction;
        if (!shot->active) continue;
        direction = shot_direction[slot];
        shot->x += (long)vectors[direction][0] * 96;
        shot->y += (long)vectors[direction][1] * 96;
        if (shot->x < 0 || shot->x >= ((long)224 << TP_FIXED_SHIFT) ||
            shot->y < 0 || shot->y >= ((long)200 << TP_FIXED_SHIFT))
            shot->active = 0;
    }
}

void tp_set_player_direction(unsigned char direction)
{
    tp_objects[TP_PLAYER_OBJECT].direction = direction & 31;
}

void tp_update_objects(unsigned char direction,
                       const signed char vectors[32][2])
{
    unsigned char slot;
    const long x_range = (long)512 << TP_FIXED_SHIFT;
    const long y_range = (long)256 << TP_FIXED_SHIFT;

    for (slot = TP_FIRST_CLOUD_OBJECT; slot < TP_OBJECT_COUNT; ++slot) {
        struct TpObject *object = &tp_objects[slot];
        if (object->state == TP_OBJECT_FREE || object->type != TP_OBJECT_CLOUD)
            continue;

        object->x -= (long)vectors[direction][0] * object->speed;
        object->y -= (long)vectors[direction][1] * object->speed;
        while (object->x < 0) object->x += x_range;
        while (object->x >= x_range) object->x -= x_range;
        while (object->y < 0) object->y += y_range;
        while (object->y >= y_range) object->y -= y_range;
    }
}

void tp_project_cloud(unsigned char slot, unsigned char height,
                      unsigned char safety_lines,
                      struct TpCloudRender *render)
{
    const struct TpObject *object = &tp_objects[slot];
    unsigned int first_x = (unsigned int)(object->x >> TP_FIXED_SHIFT) & 0x01FF;
    unsigned int second_x = (first_x + 128) & 0x01FF;
    unsigned char first_y = (unsigned char)(object->y >> TP_FIXED_SHIFT);
    unsigned char second_y = first_y + 128;

    /* The logical object owns two render instances. Crossing the 128-pixel
       band swaps their order; object identity and motion do not change. */
    if (second_y < first_y) {
        unsigned int swap_x = first_x;
        unsigned char swap_y = first_y;
        first_x = second_x;
        first_y = second_y;
        second_x = swap_x;
        second_y = swap_y;
    }

    render->first_x = first_x;
    render->second_x = second_x;
    render->first_y = first_y;
    render->second_y = second_y;
    render->rewrite_line = first_y + height + safety_lines;
}
