#ifndef TIMEPILOT_OBJECT_MODEL_H
#define TIMEPILOT_OBJECT_MODEL_H

#define TP_OBJECT_COUNT 8
#define TP_PLAYER_OBJECT 0
#define TP_FIRST_CLOUD_OBJECT 1

#define TP_OBJECT_FREE 0
#define TP_OBJECT_ACTIVE 1
#define TP_OBJECT_PLAYER 1
#define TP_OBJECT_CLOUD 2

/* Fixed pool: no pointers and no allocation, matching the original design. */
struct TpObject {
    unsigned char state;
    unsigned char type;
    unsigned char direction;
    unsigned char speed;
    long x;
    long y;
};

/* Renderer-facing projection of one logical multiplexed cloud object. */
struct TpCloudRender {
    unsigned int first_x;
    unsigned int second_x;
    unsigned char first_y;
    unsigned char second_y;
    unsigned char rewrite_line;
};

extern struct TpObject tp_objects[TP_OBJECT_COUNT];

void tp_initialise_objects(const unsigned int *initial_x,
                           const unsigned char *initial_y);
void tp_set_player_direction(unsigned char direction);
void tp_update_objects(unsigned char direction,
                       const signed char vectors[32][2]);
void tp_project_cloud(unsigned char slot, unsigned char height,
                      unsigned char safety_lines,
                      struct TpCloudRender *render);

#endif
