#!/usr/bin/env python3
"""Crop a non-interlaced 8-bit RGB PNG without resampling."""

from __future__ import annotations

import argparse
import struct
import zlib
from pathlib import Path

from index_png import PNG_SIGNATURE, png_chunk, read_rgb_png


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--left", type=int, default=0)
    parser.add_argument("--top", type=int, default=0)
    parser.add_argument("--right", type=int, default=0)
    parser.add_argument("--bottom", type=int, default=0)
    args = parser.parse_args()

    width, height, pixels = read_rgb_png(args.input)
    output_width = width - args.left - args.right
    output_height = height - args.top - args.bottom
    if output_width <= 0 or output_height <= 0:
        raise ValueError("crop margins remove the complete image")

    rows = []
    for y in range(args.top, height - args.bottom):
        start = (y * width + args.left) * 3
        rows.append(b"\0" + pixels[start:start + output_width * 3])
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_bytes(
        PNG_SIGNATURE
        + png_chunk(
            b"IHDR",
            struct.pack(">IIBBBBB", output_width, output_height, 8, 2, 0, 0, 0),
        )
        + png_chunk(b"IDAT", zlib.compress(b"".join(rows), 9))
        + png_chunk(b"IEND", b"")
    )


if __name__ == "__main__":
    main()
