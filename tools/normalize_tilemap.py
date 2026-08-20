#!/usr/bin/env python3
"""Normalize a 4x nearest-neighbour indexed atlas to its logical resolution."""

import argparse
import binascii
import struct
import zlib
from pathlib import Path

import png_tile


def png_chunk(kind, payload):
    checksum = binascii.crc32(kind + payload) & 0xFFFFFFFF
    return struct.pack(">I", len(payload)) + kind + payload + struct.pack(">I", checksum)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("input")
    parser.add_argument("output")
    parser.add_argument("--scale", type=int, default=4)
    parser.add_argument("--color-key", default="255,0,255")
    args = parser.parse_args()

    key = tuple(map(int, args.color_key.split(",")))
    width, height, rows = png_tile.read_rgba_png(args.input, color_key=key)
    if width % args.scale or height % args.scale:
        raise ValueError("image dimensions must be divisible by scale")

    sampled = []
    palette = []
    for y in range(0, height, args.scale):
        row = []
        for x in range(0, width, args.scale):
            color = tuple(rows[y][x * 4:x * 4 + 4])
            if color not in palette:
                palette.append(color)
            row.append(palette.index(color))
        sampled.append(row)

    output_width = width // args.scale
    output_height = height // args.scale
    image_data = b"".join(b"\0" + bytes(row) for row in sampled)
    palette_data = b"".join(bytes(color[:3]) for color in palette)
    transparency = bytes(color[3] for color in palette)
    header = struct.pack(">IIBBBBB", output_width, output_height, 8, 3, 0, 0, 0)
    png = (
        b"\x89PNG\r\n\x1a\n" + png_chunk(b"IHDR", header) +
        png_chunk(b"PLTE", palette_data) + png_chunk(b"tRNS", transparency) +
        png_chunk(b"IDAT", zlib.compress(image_data, 9)) + png_chunk(b"IEND", b"")
    )
    output = Path(args.output)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_bytes(png)


if __name__ == "__main__":
    main()
