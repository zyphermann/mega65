#!/usr/bin/env python3
"""Build compact FCM HUD data for the Time Pilot sprite browser."""

import argparse
import hashlib
from pathlib import Path

import extract_timepilot_font as font


RED_ATTRIBUTE = 0x14
WHITE_ATTRIBUTE = 0x10
RED_CODES = (0x96, 0x10, 0x0D, 0x88, 0xC4, 0xFD, 0xED, 0x77, 0x68, 0xD7, 0x34)
# S P R I T E. T occurs twice in tm6 with identical upright pixels; $6d is
# used here as the canonical browser code.
SPRITE_CODES = (0xED, 0x88, 0xD7, 0xFD, 0x6D, 0x34)
PALETTE_CODES = (0x88, 0x74, 0x57, 0x34, 0x6D, 0x6D, 0x34)


def fcm_tile(tile, attribute, lookup):
    return bytes((lookup[attribute * 4 + pixel] & 0x0F) + 0x10
                 for pixel in tile)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("rom_dir")
    parser.add_argument("hud_output")
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
    palette = font.decode_arcade_palette(b4, b5)[16:32]

    tiles = [font.rotate_upright(font.decode_tile(tm6, index))
             for index in range(font.TILE_COUNT)]
    codes = RED_CODES + font.DIGIT_TILE_CODES + SPRITE_CODES + PALETTE_CODES
    data = b"".join(
        fcm_tile(tiles[code], RED_ATTRIBUTE if index < len(RED_CODES)
                 else WHITE_ATTRIBUTE, lookup)
        for index, code in enumerate(codes)
    )
    black_char = 0x3000 // 64 + len(codes)
    data += bytes([0x10] * 64)
    Path(args.hud_output).parent.mkdir(parents=True, exist_ok=True)
    Path(args.hud_output).write_bytes(data)

    red_map = {code: 0x3000 // 64 + index
               for index, code in enumerate(RED_CODES)}
    white_base = 0x3000 // 64 + len(RED_CODES)
    sprite_base = white_base + len(font.DIGIT_TILE_CODES)
    palette_base = sprite_base + len(SPRITE_CODES)
    lines = ["/* Generated; do not edit. */",
             "#ifndef TIME_PILOT_SPRITE_BROWSER_DATA_H",
             "#define TIME_PILOT_SPRITE_BROWSER_DATA_H", "",
             f"#define TP_BLACK_CHAR {black_char}", "",
             "static const unsigned int tp_red_1up[4] = {",
             "    " + ", ".join(str(red_map[c]) for c in
                                  (0x96, 0x10, 0x0D, 0x88)) + ",",
             "};", "", "static const unsigned int tp_red_hi_score[8] = {",
             "    " + ", ".join(str(red_map[c]) for c in
                                  font.HI_SCORE_TILE_CODES) + ",",
             "};", "", "static const unsigned int tp_white_digits[10] = {",
             "    " + ", ".join(str(white_base + i) for i in range(10)) + ",",
             "};", "", "static const unsigned int tp_white_sprite[6] = {",
             "    " + ", ".join(str(sprite_base + i) for i in range(6)) + ",",
             "};", "", "static const unsigned int tp_white_palette[7] = {",
             "    " + ", ".join(str(palette_base + i) for i in range(7)) + ",",
             "};", "", "static const unsigned char tp_character_palette[16][3] = {"]
    lines += [f"    {{{r >> 4}, {g >> 4}, {b >> 4}}}," for r, g, b in palette]
    lines += ["};", "", "#endif", ""]
    Path(args.header_output).write_text("\n".join(lines))


if __name__ == "__main__":
    main()
