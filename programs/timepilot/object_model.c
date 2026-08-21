#include "object_model.h"

#define TP_FIXED_SHIFT 8

#pragma code-name ("OBJECTCODE")

struct TpObject tp_objects[TP_OBJECT_COUNT];

void tp_initialise_objects(const unsigned int *initial_x,
                           const unsigned char *initial_y)
{
    unsigned char slot;

    tp_objects[TP_PLAYER_OBJECT].state = TP_OBJECT_ACTIVE;
    tp_objects[TP_PLAYER_OBJECT].type = TP_OBJECT_PLAYER;
    tp_objects[TP_PLAYER_OBJECT].direction = 0;
    tp_objects[TP_PLAYER_OBJECT].speed = 0;
    tp_objects[TP_PLAYER_OBJECT].x = (long)176 << TP_FIXED_SHIFT;
    tp_objects[TP_PLAYER_OBJECT].y = (long)120 << TP_FIXED_SHIFT;

    for (slot = TP_FIRST_CLOUD_OBJECT; slot < TP_OBJECT_COUNT; ++slot) {
        struct TpObject *object = &tp_objects[slot];
        object->state = TP_OBJECT_ACTIVE;
        object->type = TP_OBJECT_CLOUD;
        object->direction = 0;
        object->speed = slot <= 3 ? 24 : 8;
        object->x = (long)initial_x[slot] << TP_FIXED_SHIFT;
        object->y = (long)initial_y[slot] << TP_FIXED_SHIFT;
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
