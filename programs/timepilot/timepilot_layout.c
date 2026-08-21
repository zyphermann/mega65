#include "timepilot_layout.h"

#define REG8(address) (*(volatile unsigned char *)(address))
#define VIC_TEXT_X_LO REG8(0xD04C)
#define VIC_TEXT_X_HI REG8(0xD04D)
#define VIC_CTRL2 REG8(0xD016)
#define VIC_TOP_BORDER_LO REG8(0xD048)
#define VIC_TOP_BORDER_HI REG8(0xD049)
#define VIC_BOTTOM_BORDER_LO REG8(0xD04A)
#define VIC_BOTTOM_BORDER_HI REG8(0xD04B)
#define VIC_TEXT_Y_LO REG8(0xD04E)
#define VIC_TEXT_Y_HI REG8(0xD04F)
#define VIC_HOTREG REG8(0xD05D)
#define VIC_VIDEO_STANDARD REG8(0xD06F)
#define VIC_SPRITE_Y_ADJUST REG8(0xD072)

#define TP_TEXT_Y_PHYSICAL 55
#define TP_TOP_BORDER_PHYSICAL 55
#define TP_BOTTOM_BORDER_PHYSICAL 455
#define TP_SPRITE_Y_ADJUST 24

unsigned int tp_playfield_origin_x;
unsigned char tp_playfield_origin_y;

void tp_layout_initialise(void)
{
    /* $D031 is a hot VIC-III register. During FCM setup it propagates the
       KERNAL's startup geometry, which differs radically between an NTSC
       start (TEXTYPOS=55, SPRYADJ=24) and a PAL start (104, 0). The border
       positions are propagated at the same time. Freeze hot propagation,
       then install one complete vertical geometry for both standards.
       Preserve the upper sprite-mode nibbles in the paired MSB registers. */
    VIC_HOTREG &= 0x7F;
    VIC_TOP_BORDER_LO = (unsigned char)TP_TOP_BORDER_PHYSICAL;
    VIC_TOP_BORDER_HI = (VIC_TOP_BORDER_HI & 0xF0) |
        (TP_TOP_BORDER_PHYSICAL >> 8);
    VIC_BOTTOM_BORDER_LO = (unsigned char)TP_BOTTOM_BORDER_PHYSICAL;
    VIC_BOTTOM_BORDER_HI = (VIC_BOTTOM_BORDER_HI & 0xF0) |
        (TP_BOTTOM_BORDER_PHYSICAL >> 8);
    VIC_TEXT_Y_LO = TP_TEXT_Y_PHYSICAL;
    VIC_TEXT_Y_HI &= 0xF0;
    VIC_SPRITE_Y_ADJUST = TP_SPRITE_Y_ADJUST;

    /* Read the actual VIC-IV display geometry after FCM setup.
       The upper register nibbles contain unrelated sprite-tile flags.
       Horizontal text position uses the 640-pixel raster, while sprite X is
       in 320-pixel units and starts 16 logical pixels before the text area.
       Vertically, TEXTYPOS is the origin of the FCM tilemap that also renders
       projectiles. It is in physical V400 rasters, while sprite Y uses V200
       lines and has its own hardware origin in SPRYADJ. Using TEXTYPOS rather
       than the border edge keeps tiles and sprites on one coordinate system;
       PAL/NTSC startup differences remain confined to this projection. */
    tp_playfield_origin_x =
        (((VIC_TEXT_X_LO |
           ((unsigned int)(VIC_TEXT_X_HI & 0x0F) << 8)) -
          ((VIC_CTRL2 & 0x07) << 1)) >> 1) - 16;
    tp_playfield_origin_y =
        (unsigned char)((VIC_TEXT_Y_LO |
            ((unsigned int)(VIC_TEXT_Y_HI & 0x0F) << 8)) >> 1) +
        VIC_SPRITE_Y_ADJUST;
}

#pragma code-name ("OBJECTCODE")

unsigned int tp_sprite_x(unsigned int logical_x)
{
    return (tp_playfield_origin_x + logical_x) & 0x01FF;
}

unsigned char tp_sprite_y(unsigned char logical_y)
{
    unsigned char projected_y = tp_playfield_origin_y + logical_y;

    /* Keep the PAL correction strictly inside the VIC presentation adapter.
       Empirical raster/tile probes show that the PAL sprite path is eight
       V200 pixels lower than FCM for otherwise identical VIC-IV geometry.
       Gameplay objects and projectile tile coordinates remain unchanged. */
    if (!(VIC_VIDEO_STANDARD & 0x80)) projected_y -= 8;
    return projected_y;
}

#pragma code-name ("CODE")
