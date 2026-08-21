#!/usr/bin/env python3
"""Generate the small FCM character set used by the Time Pilot score bar."""

import argparse
import hashlib
from pathlib import Path

import extract_timepilot_font as font


RED_ATTRIBUTE = 0x14
WHITE_ATTRIBUTE = 0x10
RED_CODES = (0x96, 0x10, 0x0D, 0x88, 0xC4, 0xFD, 0xED, 0x77, 0x68, 0xD7, 0x34)
LIFE_CODES = (0x0B, 0x09, 0x0C, 0x0A)
CREDIT_CODES = (0x77, 0xD7, 0x34, 0x87, 0xFD, 0xDC)
CHAR_BASE = 0x6000 // 64
FCM_PALETTE_BASE = 0xE0


def fcm_tile(tile, attribute, lookup):
    # E12 has eight address bits: six colour-attribute bits plus two pixel
    # bits. The upper bits of arcade colour RAM (e.g. in $f1) are controls.
    prom_attribute = attribute & 0x3F
    return bytes((lookup[prom_attribute * 4 + pixel] & 0x0F) + FCM_PALETTE_BASE
                 for pixel in tile)


def solid_colour_tile(tile, attribute, lookup, foreground):
    """Keep the PROM-derived transparency mask but use one clear HUD colour."""
    mapped = fcm_tile(tile, attribute, lookup)
    return bytes(FCM_PALETTE_BASE if pixel == FCM_PALETTE_BASE else foreground
                 for pixel in mapped)


def life_tile(tile):
    """Map the shared player/tile pixel values to black, white, magenta, blue."""
    colours = (FCM_PALETTE_BASE, FCM_PALETTE_BASE + 15,
               FCM_PALETTE_BASE + 6, FCM_PALETTE_BASE + 2)
    return bytes(colours[pixel] for pixel in tile)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("rom_dir")
    parser.add_argument("data_output")
    parser.add_argument("header_output")
    args = parser.parse_args()

    rom_dir = Path(args.rom_dir)
    tm6 = (rom_dir / "tm6").read_bytes()
    lookup = (rom_dir / "timeplt.e12").read_bytes()
    b4 = (rom_dir / "timeplt.b4").read_bytes()
    b5 = (rom_dir / "timeplt.b5").read_bytes()
    if hashlib.sha1(tm6).hexdigest() != font.EXPECTED_TM6_SHA1:
        raise ValueError("unexpected tm6 SHA-1")
    if hashlib.sha1(lookup).hexdigest() != font.EXPECTED_E12_SHA1:
        raise ValueError("unexpected timeplt.e12 SHA-1")
    if hashlib.sha1(b4).hexdigest() != font.EXPECTED_B4_SHA1:
        raise ValueError("unexpected timeplt.b4 SHA-1")
    if hashlib.sha1(b5).hexdigest() != font.EXPECTED_B5_SHA1:
        raise ValueError("unexpected timeplt.b5 SHA-1")

    tiles = [font.rotate_upright(font.decode_tile(tm6, code))
             for code in range(font.TILE_COUNT)]
    data = b"".join(solid_colour_tile(tiles[code], RED_ATTRIBUTE, lookup,
                                      FCM_PALETTE_BASE + 1)
                    for code in RED_CODES)
    data += b"".join(solid_colour_tile(tiles[code], WHITE_ATTRIBUTE, lookup,
                                      FCM_PALETTE_BASE + 15)
                     for code in font.DIGIT_TILE_CODES)
    # These four tm6 tiles are an exact quadrant-for-quadrant match for the
    # upright player sprite, tm4/tm5 sprite code 232.
    life_base = CHAR_BASE + len(RED_CODES) + 10
    data += b"".join(life_tile(tiles[code]) for code in LIFE_CODES)
    credit_base = life_base + len(LIFE_CODES)
    data += b"".join(solid_colour_tile(tiles[code], WHITE_ATTRIBUTE, lookup,
                                      FCM_PALETTE_BASE + 5)
                     for code in CREDIT_CODES)
    black_char = credit_base + len(CREDIT_CODES)
    blue_char = black_char + 1
    data += bytes([FCM_PALETTE_BASE] * 64)  # Opaque black HUD foreground.
    # Pixel zero is the character background. With sprites set behind
    # foreground, they remain visible here but disappear below the HUD pixels.
    data += bytes([0x00] * 64)
    Path(args.data_output).parent.mkdir(parents=True, exist_ok=True)
    Path(args.data_output).write_bytes(data)

    red_map = {code: CHAR_BASE + i for i, code in enumerate(RED_CODES)}
    white_base = CHAR_BASE + len(RED_CODES)
    palette = font.decode_arcade_palette(b4, b5)[16:32]
    lines = [
        "/* Generated; do not edit. */",
        "#ifndef TIMEPILOT_SCORE_DATA_H",
        "#define TIMEPILOT_SCORE_DATA_H", "",
        f"#define TP_SCORE_BLACK_CHAR {black_char}",
        f"#define TP_SCORE_BLUE_CHAR {blue_char}", "",
        "static const unsigned int tp_score_1up[4] = {",
        "    " + ", ".join(str(red_map[c]) for c in (0x96, 0x10, 0x0D, 0x88)) + ",",
        "};", "",
        "static const unsigned int tp_score_hi_score[8] = {",
        "    " + ", ".join(str(red_map[c]) for c in font.HI_SCORE_TILE_CODES) + ",",
        "};", "",
        "static const unsigned int tp_score_digits[10] = {",
        "    " + ", ".join(str(white_base + i) for i in range(10)) + ",",
        "};", "",
        "static const unsigned int tp_score_life[4] = {",
        "    " + ", ".join(str(life_base + i) for i in range(4)) + ",",
        "};", "",
        "static const unsigned int tp_score_credit[6] = {",
        "    " + ", ".join(str(credit_base + i) for i in range(6)) + ",",
        "};", "",
        "static const unsigned char tp_score_palette[16][3] = {",
    ]
    lines += [f"    {{{r >> 4}, {g >> 4}, {b >> 4}}}," for r, g, b in palette]
    lines += ["};", "", "#endif", ""]
    Path(args.header_output).write_text("\n".join(lines))


if __name__ == "__main__":
    main()
