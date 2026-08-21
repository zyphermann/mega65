#!/usr/bin/env python3
"""Generate FCM data for the Time Pilot tilemap inspection demo."""

import argparse
import hashlib
from pathlib import Path

import extract_timepilot_font as font


RED_ATTRIBUTE = 0x14
WHITE_ATTRIBUTE = 0x10
RED_CODES = (0x96, 0x10, 0x0D, 0x88, 0xC4, 0xFD, 0xED, 0x77, 0x68, 0xD7, 0x34)
WHITE_CODES = font.DIGIT_TILE_CODES


def fcm_tile(tile, attribute, lookup):
    """Expand four ROM pixel values to FCM palette indices 16..31."""
    return bytes((lookup[attribute * 4 + pixel] & 0x0F) + 0x10
                 for pixel in tile)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("rom_dir")
    parser.add_argument("gallery_output")
    parser.add_argument("hud_output")
    parser.add_argument("header_output")
    args = parser.parse_args()

    rom_dir = Path(args.rom_dir)
    tm6 = (rom_dir / "tm6").read_bytes()
    if hashlib.sha1(tm6).hexdigest() != font.EXPECTED_TM6_SHA1:
        raise ValueError("unexpected tm6 SHA-1")
    lookup = (rom_dir / "timeplt.e12").read_bytes()
    b4 = (rom_dir / "timeplt.b4").read_bytes()
    b5 = (rom_dir / "timeplt.b5").read_bytes()
    if hashlib.sha1(lookup).hexdigest() != font.EXPECTED_E12_SHA1:
        raise ValueError("unexpected timeplt.e12 SHA-1")
    if hashlib.sha1(b4).hexdigest() != font.EXPECTED_B4_SHA1:
        raise ValueError("unexpected timeplt.b4 SHA-1")
    if hashlib.sha1(b5).hexdigest() != font.EXPECTED_B5_SHA1:
        raise ValueError("unexpected timeplt.b5 SHA-1")
    palette = font.decode_arcade_palette(b4, b5)[16:32]

    tiles = [font.rotate_upright(font.decode_tile(tm6, index))
             for index in range(font.TILE_COUNT)]

    gallery = b"".join(fcm_tile(tile, 0x00, lookup) for tile in tiles)
    hud_codes = RED_CODES + WHITE_CODES
    hud = b"".join(
        fcm_tile(tiles[code], RED_ATTRIBUTE if index < len(RED_CODES)
                 else WHITE_ATTRIBUTE, lookup)
        for index, code in enumerate(hud_codes)
    )
    black_char = 0x7000 // 64 + len(hud_codes)
    hud += bytes([0x10] * 64)

    gallery_path = Path(args.gallery_output)
    gallery_path.parent.mkdir(parents=True, exist_ok=True)
    gallery_path.write_bytes(gallery)
    Path(args.hud_output).write_bytes(hud)

    red_map = {code: 0x7000 // 64 + index
               for index, code in enumerate(RED_CODES)}
    white_base = 0x7000 // 64 + len(RED_CODES)
    lines = ["/* Generated; do not edit. */",
             "#ifndef TIME_PILOT_TILEMAP_DEMO_H",
             "#define TIME_PILOT_TILEMAP_DEMO_H", "",
             "#define TP_GALLERY_CHAR_BASE 512", "",
             f"#define TP_BLACK_CHAR {black_char}", "",
             "static const unsigned int tp_red_1up[4] = {"]
    lines.append("    " + ", ".join(str(red_map[c]) for c in (0x96, 0x10, 0x0D, 0x88)) + ",")
    lines += ["};", "", "static const unsigned int tp_red_hi_score[8] = {"]
    lines.append("    " + ", ".join(str(red_map[c]) for c in font.HI_SCORE_TILE_CODES) + ",")
    lines += ["};", "", "static const unsigned int tp_white_digits[10] = {"]
    lines.append("    " + ", ".join(str(white_base + i) for i in range(10)) + ",")
    lines += ["};", "", "static const unsigned char tp_character_palette[16][3] = {"]
    lines += [f"    {{{r >> 4}, {g >> 4}, {b >> 4}}}," for r, g, b in palette]
    lines += ["};", "", "#endif", ""]
    Path(args.header_output).write_text("\n".join(lines))


if __name__ == "__main__":
    main()
