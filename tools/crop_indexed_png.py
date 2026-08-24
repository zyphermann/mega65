#!/usr/bin/env python3
"""Crop rows and selected columns from an 8-bit indexed PNG."""

from __future__ import annotations

import argparse
import struct
import zlib
from pathlib import Path

from index_png import PNG_SIGNATURE, write_indexed_png


def read_indexed_png(path: Path) -> tuple[int, int, bytes, list[bytes]]:
    data = path.read_bytes()
    if not data.startswith(PNG_SIGNATURE):
        raise ValueError(f"{path} is not a PNG")
    position = len(PNG_SIGNATURE)
    compressed = []
    palette = b""
    width = height = 0
    while position < len(data):
        size = struct.unpack_from(">I", data, position)[0]
        kind = data[position + 4:position + 8]
        payload = data[position + 8:position + 8 + size]
        position += size + 12
        if kind == b"IHDR":
            width, height, depth, colour_type, compression, filtering, interlace = (
                struct.unpack(">IIBBBBB", payload)
            )
            if (depth, colour_type, compression, filtering, interlace) != (8, 3, 0, 0, 0):
                raise ValueError("input must be a non-interlaced 8-bit indexed PNG")
        elif kind == b"PLTE":
            palette = payload
        elif kind == b"IDAT":
            compressed.append(payload)
        elif kind == b"IEND":
            break

    raw = zlib.decompress(b"".join(compressed))
    previous = bytearray(width)
    pixels = bytearray()
    source = 0
    for _ in range(height):
        filter_type = raw[source]
        source += 1
        row = bytearray(raw[source:source + width])
        source += width
        for index in range(width):
            left = row[index - 1] if index else 0
            above = previous[index]
            upper_left = previous[index - 1] if index else 0
            if filter_type == 1:
                row[index] = (row[index] + left) & 0xFF
            elif filter_type == 2:
                row[index] = (row[index] + above) & 0xFF
            elif filter_type == 3:
                row[index] = (row[index] + ((left + above) // 2)) & 0xFF
            elif filter_type == 4:
                estimate = left + above - upper_left
                distances = (
                    abs(estimate - left), abs(estimate - above), abs(estimate - upper_left)
                )
                predictor = (left, above, upper_left)[distances.index(min(distances))]
                row[index] = (row[index] + predictor) & 0xFF
            elif filter_type != 0:
                raise ValueError(f"unsupported PNG filter {filter_type}")
        pixels.extend(row)
        previous = row
    return width, height, bytes(pixels), [
        palette[offset:offset + 3] for offset in range(0, len(palette), 3)
    ]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--remove-columns", required=True)
    parser.add_argument("--top", type=int, default=0)
    parser.add_argument("--bottom", type=int, default=0)
    args = parser.parse_args()

    width, height, pixels, palette = read_indexed_png(args.input)
    removed = {int(value) for value in args.remove_columns.split(",")}
    if any(column < 0 or column >= width for column in removed):
        raise ValueError("column outside input image")
    kept = [column for column in range(width) if column not in removed]
    output_height = height - args.top - args.bottom
    if not kept or output_height <= 0:
        raise ValueError("crop removes the complete image")

    output = bytes(
        pixels[y * width + x]
        for y in range(args.top, height - args.bottom)
        for x in kept
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    write_indexed_png(args.output, len(kept), output_height, output, palette)
    print(
        f"cropped indexed PNG from {width}x{height} to {len(kept)}x{output_height}; "
        f"removed columns {','.join(str(value) for value in sorted(removed))}"
    )


if __name__ == "__main__":
    main()
