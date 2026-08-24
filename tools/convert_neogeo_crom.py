#!/usr/bin/env python3
"""Convert packed 16x16 4-bpp tiles into native Neo-Geo C1/C2 ROM data."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


PACKED_TILE_BYTES = 128
CROM_TILE_BYTES = 64
PIXELS_PER_TILE = 16 * 16

# Native C-ROM block order: upper-right, lower-right, upper-left, lower-left.
BLOCK_OFFSETS = (8, 136, 0, 128)


def unpack_chunky_tile(packed: bytes) -> bytes:
    """Expand high-nibble-first packed pixels to one pen byte per pixel."""
    if len(packed) != PACKED_TILE_BYTES:
        raise ValueError(f"logical tile must be {PACKED_TILE_BYTES} bytes")
    pixels = bytearray(PIXELS_PER_TILE)
    for index, value in enumerate(packed):
        pixels[index * 2] = value >> 4
        pixels[index * 2 + 1] = value & 0x0F
    return bytes(pixels)


def pack_chunky_tile(pixels: bytes) -> bytes:
    """Pack one-byte pens with the left pixel in the high nibble."""
    if len(pixels) != PIXELS_PER_TILE:
        raise ValueError(f"expanded tile must contain {PIXELS_PER_TILE} pixels")
    if any(pixel > 15 for pixel in pixels):
        raise ValueError("expanded tile contains a pen outside 0..15")
    return bytes(
        (pixels[index] << 4) | pixels[index + 1]
        for index in range(0, PIXELS_PER_TILE, 2)
    )


def encode_crom_tile(pixels: bytes) -> tuple[bytes, bytes]:
    """Split one expanded tile into its native complementary C1/C2 data."""
    if len(pixels) != PIXELS_PER_TILE:
        raise ValueError(f"expanded tile must contain {PIXELS_PER_TILE} pixels")
    if any(pixel > 15 for pixel in pixels):
        raise ValueError("expanded tile contains a pen outside 0..15")

    c1 = bytearray(CROM_TILE_BYTES)
    c2 = bytearray(CROM_TILE_BYTES)
    destination = 0
    for block_offset in BLOCK_OFFSETS:
        source = block_offset
        for _ in range(8):
            planes = [0, 0, 0, 0]
            for bit in range(8):
                pen = pixels[source + bit]
                for plane in range(4):
                    planes[plane] |= ((pen >> plane) & 1) << bit
            c1[destination:destination + 2] = bytes(planes[:2])
            c2[destination:destination + 2] = bytes(planes[2:])
            destination += 2
            source += 16
    return bytes(c1), bytes(c2)


def decode_crom_tile(c1: bytes, c2: bytes) -> bytes:
    """Decode one native C1/C2 tile back to one pen byte per pixel."""
    if len(c1) != CROM_TILE_BYTES or len(c2) != CROM_TILE_BYTES:
        raise ValueError(f"each C-ROM tile half must be {CROM_TILE_BYTES} bytes")
    pixels = bytearray(PIXELS_PER_TILE)
    source = 0
    for block_offset in BLOCK_OFFSETS:
        destination = block_offset
        for _ in range(8):
            planes = (c1[source], c1[source + 1], c2[source], c2[source + 1])
            for bit in range(8):
                pixels[destination + bit] = sum(
                    ((planes[plane] >> bit) & 1) << plane
                    for plane in range(4)
                )
            source += 2
            destination += 16
    return bytes(pixels)


def self_test() -> None:
    """Check exact plane, quadrant and bit direction plus a full roundtrip."""
    pixels = bytearray(PIXELS_PER_TILE)
    pixels[0] = 1       # upper-left, plane 0, first pixel
    pixels[8] = 2       # upper-right, plane 1, first pixel
    pixels[15 * 16 + 15] = 8  # lower-right, plane 3, last pixel
    c1, c2 = encode_crom_tile(pixels)
    reference_ok = (
        c1[1] == 0x01                     # upper-right plane 1
        and c1[32] == 0x01                # upper-left plane 0
        and c2[31] == 0x80                # lower-right plane 3
        and sum(c1) == 2
        and sum(c2) == 0x80
        and decode_crom_tile(c1, c2) == pixels
    )
    if not reference_ok:
        raise AssertionError("C-ROM plane/quadrant reference vector failed")

    pattern = bytes((x + y * 3) & 15 for y in range(16) for x in range(16))
    left, right = encode_crom_tile(pattern)
    if decode_crom_tile(left, right) != pattern:
        raise AssertionError("C-ROM pattern roundtrip failed")
    if unpack_chunky_tile(pack_chunky_tile(pattern)) != pattern:
        raise AssertionError("logical 4-bpp pattern roundtrip failed")


def integer(value: str) -> int:
    return int(value, 0)


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Convert high-nibble-first 16x16 4-bpp tiles to Neo-Geo C1/C2 ROMs."
    )
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--c1", type=Path, required=True)
    parser.add_argument("--c2", type=Path, required=True)
    parser.add_argument("--summary", type=Path)
    parser.add_argument(
        "--pad-size", type=integer, default=0, metavar="BYTES",
        help="pad each output ROM with transparent data; accepts decimal or 0x...",
    )
    args = parser.parse_args()

    self_test()
    packed = args.input.read_bytes()
    if not packed or len(packed) % PACKED_TILE_BYTES:
        raise ValueError(
            f"input size must be a non-zero multiple of {PACKED_TILE_BYTES} bytes"
        )

    tile_count = len(packed) // PACKED_TILE_BYTES
    c1 = bytearray()
    c2 = bytearray()
    for tile_index in range(tile_count):
        start = tile_index * PACKED_TILE_BYTES
        pixels = unpack_chunky_tile(packed[start:start + PACKED_TILE_BYTES])
        left, right = encode_crom_tile(pixels)
        if decode_crom_tile(left, right) != pixels:
            raise ValueError(f"C-ROM roundtrip failed for tile {tile_index}")
        c1.extend(left)
        c2.extend(right)

    raw_size = tile_count * CROM_TILE_BYTES
    if args.pad_size:
        if args.pad_size < raw_size:
            raise ValueError(
                f"pad size {args.pad_size} is smaller than raw C-ROM size {raw_size}"
            )
        c1.extend(bytes(args.pad_size - raw_size))
        c2.extend(bytes(args.pad_size - raw_size))

    for path in (args.c1, args.c2, args.summary):
        if path is not None:
            path.parent.mkdir(parents=True, exist_ok=True)
    args.c1.write_bytes(c1)
    args.c2.write_bytes(c2)

    summary = {
        "input": str(args.input),
        "tile_count": tile_count,
        "logical_bytes_per_tile": PACKED_TILE_BYTES,
        "bytes_per_tile_per_crom": CROM_TILE_BYTES,
        "raw_bytes_per_crom": raw_size,
        "output_bytes_per_crom": len(c1),
        "c1_planes": [0, 1],
        "c2_planes": [2, 3],
        "block_order": ["upper-right", "lower-right", "upper-left", "lower-left"],
        "roundtrip_verified_tiles": tile_count,
        "c1_sha256": hashlib.sha256(c1).hexdigest(),
        "c2_sha256": hashlib.sha256(c2).hexdigest(),
    }
    if args.summary is not None:
        args.summary.write_text(json.dumps(summary, indent=2) + "\n")
    print(
        f"Neo-Geo C-ROM: {tile_count} tiles -> "
        f"{len(c1)} bytes C1 + {len(c2)} bytes C2; roundtrip OK"
    )


if __name__ == "__main__":
    main()
