#!/usr/bin/env python3
"""Generate the small FCM character set used by the Time Pilot score bar."""

import argparse
import hashlib
import struct
from pathlib import Path

import extract_timepilot_font as font


RED_ATTRIBUTE = 0x14
WHITE_ATTRIBUTE = 0x10
RED_CODES = (0x96, 0x10, 0x0D, 0x88, 0xC4, 0xFD, 0xED, 0x77, 0x68, 0xD7, 0x34)
LIFE_CODES = (0x0B, 0x09, 0x0C, 0x0A)
CREDIT_CODES = (0x77, 0xD7, 0x34, 0x87, 0xFD, 0xDC)
# VIC-IV sees the RAM underneath BASIC ROM. Keeping FCM graphics at $8000+
# leaves the entire lower half of the CPU address space available to C.
CHAR_BASE = 0x8000 // 64
FCM_PALETTE_BASE = 0xE0


def fcm_tile(tile, attribute, lookup):
    # E12 has eight address bits: six colour-attribute bits plus two pixel
    # bits. The upper bits of arcade colour RAM (e.g. in $f1) are controls.
    prom_attribute = attribute & 0x3F
    return bytes((lookup[prom_attribute * 4 + pixel] & 0x0F) + FCM_PALETTE_BASE
                 for pixel in tile)


def shot_tile(tile, attribute, lookup):
    """Convert the PROM mask, using the demo's stable bright HUD white."""
    colour = attribute & 0x1F
    result = []
    for pixel in tile:
        pen = lookup[colour * 4 + pixel] & 0x0F
        result.append(0 if pen == 0 else FCM_PALETTE_BASE + 15)
    return bytes(result)


def projectile_tile(upright_tiles, code, attribute):
    """Apply Time Pilot's tile-code extension and portrait flip flags."""
    effective_code = code + 8 * (attribute & 0x20)
    tile = upright_tiles[effective_code]
    # MAME applies flips before the cabinet image is rotated clockwise.
    # Portrait flip-X therefore becomes upright flip-Y and vice versa.
    if attribute & 0x40:
        tile = [tile[(7 - y) * 8 + x] for y in range(8) for x in range(8)]
    if attribute & 0x80:
        tile = [tile[y * 8 + (7 - x)] for y in range(8) for x in range(8)]
    return tile


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
    parser.add_argument("shot_table_output")
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
    # Original $53d4-$55d3 table: 64 subpositions, four neighbouring cells,
    # and one (tm6 code, colour attribute) pair per cell.
    program = b"".join((rom_dir / f"tm{i}").read_bytes() for i in range(1, 4))
    shot_rom_table = program[0x53D4:0x55D4]
    if len(shot_rom_table) != 512:
        raise ValueError("incomplete original shot table")
    shot_pairs = []
    for offset in range(0, len(shot_rom_table), 2):
        pair = tuple(shot_rom_table[offset:offset + 2])
        if pair[0] and pair not in shot_pairs:
            shot_pairs.append(pair)
    shot_base = credit_base + len(CREDIT_CODES)
    data += b"".join(shot_tile(projectile_tile(tiles, code, attribute),
                               attribute, lookup)
                     for code, attribute in shot_pairs)
    shot_pair_chars = {pair: shot_base + index
                       for index, pair in enumerate(shot_pairs)}
    black_char = shot_base + len(shot_pairs)
    blue_char = black_char + 1
    data += bytes([FCM_PALETTE_BASE] * 64)  # Opaque black HUD foreground.
    # Pixel zero is the character background. With sprites set behind
    # foreground, they remain visible here but disappear below the HUD pixels.
    data += bytes([0x00] * 64)
    # Keep this lookup away from the FCM characters below the C stack.
    # $ffff marks an original zero/skip entry.
    shot_table_address = 0x4000
    converted_shot_table = []
    for offset in range(0, len(shot_rom_table), 2):
        pair = tuple(shot_rom_table[offset:offset + 2])
        converted_shot_table.append(shot_pair_chars.get(pair, 0xFFFF))
    shot_table_data = b"".join(struct.pack("<H", value)
                               for value in converted_shot_table)
    Path(args.data_output).parent.mkdir(parents=True, exist_ok=True)
    Path(args.data_output).write_bytes(data)
    Path(args.shot_table_output).write_bytes(shot_table_data)

    red_map = {code: CHAR_BASE + i for i, code in enumerate(RED_CODES)}
    white_base = CHAR_BASE + len(RED_CODES)
    palette = font.decode_arcade_palette(b4, b5)[16:32]
    lines = [
        "/* Generated; do not edit. */",
        "#ifndef TIMEPILOT_SCORE_DATA_H",
        "#define TIMEPILOT_SCORE_DATA_H", "",
        f"#define TP_SCORE_BLACK_CHAR {black_char}",
        f"#define TP_SCORE_BLUE_CHAR {blue_char}", "",
        f"#define TP_SCORE_SHOT_TABLE ((const unsigned int *)0x{shot_table_address:04X})", "",
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
