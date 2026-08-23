#include "sprite_multiplexer.h"

#define REG8(address) (*(volatile unsigned char *)(address))
#define VIC_CTRL1       REG8(0xD011)
#define VIC_RASTER      REG8(0xD012)
#define VIC_IRQ_STATUS  REG8(0xD019)
#define VIC_IRQ_MASK    REG8(0xD01A)
#define SPRITE_ENABLE   REG8(0xD015)

#define SMUX_BUFFER_COUNT 2
#define SMUX_SPRITE_HEIGHT 16
#define SMUX_REWRITE_AFTER 3
#define SMUX_REWRITE_BEFORE 6
#define SMUX_EVENT_ENABLE 0xFE

/* These arrays are consumed directly by sprite_multiplexer_irq.s. */
volatile unsigned char smux_irq_event;
volatile unsigned char smux_front;
volatile unsigned char smux_swap_pending;
volatile unsigned char smux_debug_enabled;
volatile unsigned char smux_event_count[SMUX_BUFFER_COUNT];
volatile unsigned char smux_event_raster[SMUX_MAX_EVENTS * SMUX_BUFFER_COUNT];
volatile unsigned char smux_event_slot[SMUX_MAX_EVENTS * SMUX_BUFFER_COUNT];
volatile unsigned char smux_event_x[SMUX_MAX_EVENTS * SMUX_BUFFER_COUNT];
volatile unsigned char smux_event_x_msb[SMUX_MAX_EVENTS * SMUX_BUFFER_COUNT];
volatile unsigned char smux_event_y[SMUX_MAX_EVENTS * SMUX_BUFFER_COUNT];
volatile unsigned char smux_event_image[SMUX_MAX_EVENTS * SMUX_BUFFER_COUNT];

static struct SmuxSprite logical[SMUX_MAX_LOGICAL_SPRITES];
static unsigned char order[SMUX_MAX_LOGICAL_SPRITES];
static unsigned int submitted;
static unsigned int scheduled;
static unsigned int dropped;

static void add_event(unsigned char buffer, unsigned char *count,
                      unsigned char raster, unsigned char slot,
                      unsigned int x, unsigned char y, unsigned char image)
{
    unsigned int index = (unsigned int)buffer * SMUX_MAX_EVENTS + *count;

    smux_event_raster[index] = raster;
    smux_event_slot[index] = slot;
    smux_event_x[index] = (unsigned char)x;
    smux_event_x_msb[index] = (x & 0x100) != 0;
    smux_event_y[index] = y;
    smux_event_image[index] = image;
    ++*count;
}

static unsigned char comes_before(unsigned char a, unsigned char b)
{
    if (logical[a].y != logical[b].y)
        return logical[a].y < logical[b].y;
    return logical[a].priority > logical[b].priority;
}

static void sort_sprites(void)
{
    unsigned int i;
    unsigned int p;
    unsigned char candidate;

    for (i = 0; i < submitted; ++i) order[i] = (unsigned char)i;
    for (i = 1; i < submitted; ++i) {
        candidate = order[i];
        p = i;
        while (p && comes_before(candidate, order[p - 1])) {
            order[p] = order[p - 1];
            --p;
        }
        order[p] = candidate;
    }
}

static void build_buffer(unsigned char buffer)
{
    unsigned char count = 0;
    unsigned char used_mask = 0;
    unsigned char slot;
    unsigned char chosen;
    unsigned char rewrite;
    unsigned char earliest;
    unsigned char free_at[SMUX_HARDWARE_SLOTS];
    unsigned int i;
    struct SmuxSprite *sprite;

    scheduled = 0;
    dropped = 0;
    for (slot = 0; slot < SMUX_HARDWARE_SLOTS; ++slot) free_at[slot] = 0;
    sort_sprites();

    /* Event zero atomically establishes which hardware slots this frame uses. */
    add_event(buffer, &count, 0, SMUX_EVENT_ENABLE, 0, 0, 0);

    for (i = 0; i < submitted; ++i) {
        sprite = &logical[order[i]];
        chosen = 0xFF;
        rewrite = 0;
        earliest = 0xFF;

        for (slot = 0; slot < SMUX_HARDWARE_SLOTS; ++slot) {
            if (!(used_mask & (1 << slot))) {
                if (earliest) {
                    chosen = slot;
                    rewrite = 0;
                    earliest = 0;
                }
                continue;
            }
            /* There must be time both after the old bottom edge and before
               the new top edge. The IRQ itself only consumes this schedule. */
            if ((unsigned int)free_at[slot] + SMUX_REWRITE_BEFORE <= sprite->y) {
                if (free_at[slot] < earliest) {
                    chosen = slot;
                    rewrite = free_at[slot];
                    earliest = free_at[slot];
                }
            }
        }

        if (chosen == 0xFF || count >= SMUX_MAX_EVENTS) {
            ++dropped;
            continue;
        }
        add_event(buffer, &count, rewrite, chosen, sprite->x, sprite->y,
                  sprite->image);
        used_mask |= 1 << chosen;
        free_at[chosen] = sprite->y + SMUX_SPRITE_HEIGHT + SMUX_REWRITE_AFTER;
        ++scheduled;
    }

    /* The enable mask is carried in the first event's X byte. */
    smux_event_x[(unsigned int)buffer * SMUX_MAX_EVENTS] = used_mask;
    smux_event_count[buffer] = count;
}

void smux_begin_frame(void)
{
    submitted = 0;
}

unsigned char smux_add(unsigned int x, unsigned char y,
                       unsigned char image, unsigned char priority)
{
    if (submitted >= SMUX_MAX_LOGICAL_SPRITES) return 0;
    logical[submitted].x = x;
    logical[submitted].y = y;
    logical[submitted].image = image;
    logical[submitted].priority = priority;
    ++submitted;
    return 1;
}

void smux_build_and_publish(void)
{
    unsigned char back;

    __asm__("sei");
    if (smux_swap_pending) {
        __asm__("cli");
        return;
    }
    back = smux_front ^ 1;
    __asm__("cli");

    build_buffer(back);

    __asm__("sei");
    smux_swap_pending = 1;
    __asm__("cli");
}

void smux_start(void)
{
    build_buffer(0);
    build_buffer(1);
    __asm__("sei");
    smux_irq_event = 0;
    smux_front = 0;
    smux_swap_pending = 0;
    VIC_CTRL1 &= 0x7F;
    VIC_RASTER = 0;
    VIC_IRQ_STATUS = 1;
    VIC_IRQ_MASK |= 1;
    __asm__("cli");
}

void smux_stop(void)
{
    __asm__("sei");
    VIC_IRQ_MASK &= 0xFE;
    VIC_IRQ_STATUS = 1;
    SPRITE_ENABLE = 0;
    __asm__("cli");
}

unsigned int smux_submitted_count(void) { return submitted; }
unsigned int smux_scheduled_count(void) { return scheduled; }
unsigned int smux_dropped_count(void) { return dropped; }
void smux_set_debug(unsigned char enabled) { smux_debug_enabled = enabled; }
