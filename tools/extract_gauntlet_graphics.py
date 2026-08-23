#!/usr/bin/env python3
"""Extract Atari Gauntlet character and playfield/MO tiles from local ROMs.

Only the Python standard library is required.  The PNG sheets use diagnostic
colours for pen indices; Gauntlet's real colours are held in palette RAM.
"""

from __future__ import annotations

import argparse
import csv
import struct
import zlib
from pathlib import Path


DIAGNOSTIC_4BPP = [
    (0, 0, 0), (29, 43, 83), (126, 37, 83), (0, 135, 81),
    (171, 82, 54), (95, 87, 79), (194, 195, 199), (255, 241, 232),
    (255, 0, 77), (255, 163, 0), (255, 236, 39), (0, 228, 54),
    (41, 173, 255), (131, 118, 156), (255, 119, 168), (255, 204, 170),
]


def png(path: Path, width: int, height: int, pixels: bytes, palette: list[tuple[int, int, int]]) -> None:
    def chunk(kind: bytes, data: bytes) -> bytes:
        body = kind + data
        return struct.pack(">I", len(data)) + body + struct.pack(">I", zlib.crc32(body))

    rows = b"".join(b"\0" + pixels[y * width:(y + 1) * width] for y in range(height))
    plte = b"".join(bytes(rgb) for rgb in palette)
    path.write_bytes(
        b"\x89PNG\r\n\x1a\n"
        + chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 3, 0, 0, 0))
        + chunk(b"PLTE", plte)
        + chunk(b"IDAT", zlib.compress(rows, 9))
        + chunk(b"IEND", b"")
    )


def sheet(tiles: list[bytes], columns: int) -> tuple[int, int, bytes]:
    rows = (len(tiles) + columns - 1) // columns
    out = bytearray(columns * 8 * rows * 8)
    width = columns * 8
    for number, tile in enumerate(tiles):
        ox, oy = (number % columns) * 8, (number // columns) * 8
        for y in range(8):
            start = (oy + y) * width + ox
            out[start:start + 8] = tile[y * 8:y * 8 + 8]
    return width, rows * 8, bytes(out)


def chars(data: bytes) -> list[bytes]:
    # 2 bpp packed nibble layout: planes at bits 0 and 4, 16 bytes per tile.
    result = []
    for base in range(0, len(data) - 15, 16):
        tile = bytearray()
        for y in range(8):
            a, b = data[base + y * 2:base + y * 2 + 2]
            for x in range(8):
                source, bit = (a, x) if x < 4 else (b, x - 4)
                # MAME gfx-layout offsets number bits from the byte's MSB.
                # Plane offsets 0 and 4 therefore mean physical bits 7 and 3.
                tile.append(((source >> (7 - bit)) & 1) | (((source >> (3 - bit)) & 1) << 1))
        result.append(bytes(tile))
    return result


def spr_tiles(region: bytes) -> list[bytes]:
    # MAME gfx_8x8x4_planar: four equal plane quarters, 8 bytes/tile/plane.
    assert len(region) == 0x40000
    plane_size = len(region) // 4
    result = []
    for number in range(plane_size // 8):
        tile = bytearray()
        for y in range(8):
            for x in range(8):
                value = 0
                for plane in range(4):
                    byte = region[plane * plane_size + number * 8 + y] ^ 0xff
                    # gfx_8x8x4_planar uses x offsets 0..7; offset zero is
                    # the physical MSB, so the previous decoder mirrored
                    # every tile horizontally.
                    value |= ((byte >> (7 - x)) & 1) << plane
                tile.append(value)
        result.append(bytes(tile))
    return result


def write_palette_csv(dump: Path, output: Path) -> None:
    raw = dump.read_bytes()
    if len(raw) != 0x800:
        raise ValueError(f"palette dump must contain 0x800 bytes, got {len(raw):#x}")
    with output.open("w", newline="") as stream:
        writer = csv.writer(stream)
        writer.writerow(("index", "bank", "raw", "intensity", "red", "green", "blue"))
        banks = ("alpha", "motion_object", "playfield", "extra")
        for index in range(1024):
            value = int.from_bytes(raw[index * 2:index * 2 + 2], "big")
            writer.writerow((index, banks[index // 256], f"0x{value:04x}",
                             (value >> 12) & 15, (value >> 8) & 15,
                             (value >> 4) & 15, value & 15))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rom-dir", type=Path, default=Path("assets/gauntlet/romset"))
    parser.add_argument("--output", type=Path, default=Path("reverse-engineering/gauntlet/extracted"))
    parser.add_argument("--palette-dump", type=Path, help="optional 0x800-byte dump of palette RAM $910000")
    parser.add_argument("--palette-only", action="store_true",
                        help="only convert --palette-dump to palette.csv")
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)

    if args.palette_only:
        if not args.palette_dump:
            parser.error("--palette-only requires --palette-dump")
        write_palette_csv(args.palette_dump, args.output / "palette.csv")
        print("converted 1024 palette entries")
        return

    char_tiles = chars((args.rom_dir / "136037-104.6p").read_bytes())
    # Keep the PCB/MAME load order explicit: it is part of the bitplane format.
    graphics = b"".join((args.rom_dir / name).read_bytes() for name in (
        "136037-111.1a", "136037-112.1b", "136037-113.1l", "136037-114.1mn",
        "136037-115.2a", "136037-116.2b", "136037-117.2l", "136037-118.2mn",
    ))
    playfield_mo_tiles = spr_tiles(graphics)

    for name, tiles, columns, palette in (
        ("chars", char_tiles, 32, DIAGNOSTIC_4BPP[:4]),
        ("playfield-motion-objects", playfield_mo_tiles, 128, DIAGNOSTIC_4BPP),
    ):
        (args.output / f"{name}.bin").write_bytes(b"".join(tiles))
        width, height, pixels = sheet(tiles, columns)
        png(args.output / f"{name}.png", width, height, pixels, palette)

    if args.palette_dump:
        write_palette_csv(args.palette_dump, args.output / "palette.csv")
    print(f"extracted {len(char_tiles)} character tiles and {len(playfield_mo_tiles)} playfield/MO tiles")


if __name__ == "__main__":
    main()
