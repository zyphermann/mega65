#!/usr/bin/env python3
"""Convert one tile from a simple 8-bit RGBA PNG to a MEGA65 C header."""

import argparse
import struct
import zlib
from pathlib import Path


def paeth(left, above, upper_left):
    estimate = left + above - upper_left
    distances = (abs(estimate - left), abs(estimate - above), abs(estimate - upper_left))
    return (left, above, upper_left)[distances.index(min(distances))]


def read_rgba_png(path, color_key=None):
    data = Path(path).read_bytes()
    if data[:8] != b"\x89PNG\r\n\x1a\n":
        raise ValueError("not a PNG file")

    chunks = []
    palette = None
    transparency = b""
    position = 8
    header = None
    while position < len(data):
        size = struct.unpack(">I", data[position:position + 4])[0]
        kind = data[position + 4:position + 8]
        payload = data[position + 8:position + 8 + size]
        position += size + 12
        if kind == b"IHDR":
            header = struct.unpack(">IIBBBBB", payload)
        elif kind == b"PLTE":
            palette = [tuple(payload[i:i + 3]) for i in range(0, len(payload), 3)]
        elif kind == b"tRNS":
            transparency = payload
        elif kind == b"IDAT":
            chunks.append(payload)
        elif kind == b"IEND":
            break

    if header is None:
        raise ValueError("PNG has no IHDR chunk")
    width, height, depth, color_type, compression, filtering, interlace = header
    if depth != 8 or color_type not in (2, 3, 6) or (compression, filtering, interlace) != (0, 0, 0):
        raise ValueError("expected a non-interlaced 8-bit indexed, RGB or RGBA PNG")
    if color_type == 3 and palette is None:
        raise ValueError("indexed PNG has no palette")

    packed = zlib.decompress(b"".join(chunks))
    bytes_per_pixel = {2: 3, 3: 1, 6: 4}[color_type]
    stride = width * bytes_per_pixel
    rows = []
    offset = 0
    for _ in range(height):
        filter_type = packed[offset]
        row = bytearray(packed[offset + 1:offset + 1 + stride])
        offset += stride + 1
        previous = rows[-1] if rows else bytes(stride)
        for index in range(stride):
            left = row[index - bytes_per_pixel] if index >= bytes_per_pixel else 0
            above = previous[index]
            upper_left = previous[index - bytes_per_pixel] if index >= bytes_per_pixel else 0
            if filter_type == 1:
                row[index] = (row[index] + left) & 0xFF
            elif filter_type == 2:
                row[index] = (row[index] + above) & 0xFF
            elif filter_type == 3:
                row[index] = (row[index] + ((left + above) // 2)) & 0xFF
            elif filter_type == 4:
                row[index] = (row[index] + paeth(left, above, upper_left)) & 0xFF
            elif filter_type != 0:
                raise ValueError(f"unsupported PNG filter {filter_type}")
        rows.append(row)
    if color_type == 2:
        rgba_rows = []
        for row in rows:
            rgba = bytearray()
            for index in range(0, len(row), 3):
                red, green, blue = row[index:index + 3]
                alpha = 0 if color_key == (red, green, blue) else 255
                rgba.extend((red, green, blue, alpha))
            rgba_rows.append(rgba)
        rows = rgba_rows
    elif color_type == 3:
        rgba_rows = []
        for row in rows:
            rgba = bytearray()
            for index in row:
                red, green, blue = palette[index]
                alpha = transparency[index] if index < len(transparency) else 255
                if color_key is not None and (red, green, blue) == color_key:
                    alpha = 0
                rgba.extend((red, green, blue, alpha))
            rgba_rows.append(rgba)
        rows = rgba_rows
    return width, height, rows


def convert(path, tile_x, tile_y, tile_size, global_palette=False, color_key=None,
            source_tile_size=None):
    width, height, rows = read_rgba_png(path, color_key)
    source_tile_size = source_tile_size or tile_size
    if source_tile_size % tile_size:
        raise ValueError("source tile size must be a multiple of output tile size")
    sample_step = source_tile_size // tile_size
    start_x = tile_x * source_tile_size
    start_y = tile_y * source_tile_size
    if start_x + source_tile_size > width or start_y + source_tile_size > height:
        raise ValueError("tile lies outside the image")

    pixels = []
    opaque_colors = []
    if global_palette:
        for row in rows:
            for x in range(width):
                color = tuple(row[x * 4:x * 4 + 4])
                if color[3] >= 128 and color[:3] not in opaque_colors:
                    opaque_colors.append(color[:3])
    for output_y in range(tile_size):
        y = start_y + output_y * sample_step
        for output_x in range(tile_size):
            x = start_x + output_x * sample_step
            color = tuple(rows[y][x * 4:x * 4 + 4])
            if color[3] < 128:
                pixels.append(None)
            else:
                rgb = color[:3]
                if rgb not in opaque_colors:
                    opaque_colors.append(rgb)
                pixels.append(rgb)

    if len(opaque_colors) > 15:
        raise ValueError(f"tile uses {len(opaque_colors)} opaque colors; at most 15 are supported")
    palette = [(0, 0, 0)] + opaque_colors
    indices = [0 if color is None else palette.index(color) for color in pixels]
    packed = [(indices[i] << 4) | indices[i + 1] for i in range(0, len(indices), 2)]
    return palette, packed


def write_header(path, palette, packed, source, tile_x, tile_y, name, omit_palette=False):
    guard = name.upper() + "_H"
    lines = [
        "/* Generated by tools/png_tile.py; do not edit. */",
        f"/* Source: {source}, tile ({tile_x}, {tile_y}) */",
        f"#ifndef {guard}",
        f"#define {guard}",
        "",
    ]
    if not omit_palette:
        lines += [
            f"#define {name.upper()}_PALETTE_SIZE {len(palette)}",
            f"static const unsigned char {name}_palette[{name.upper()}_PALETTE_SIZE][3] = {{",
        ]
        lines += [f"    {{{red}, {green}, {blue}}}," for red, green, blue in palette]
        lines += ["};", ""]
    lines += [f"static const unsigned char {name}_pixels[{len(packed)}] = {{"]
    for start in range(0, len(packed), 8):
        lines.append("    " + ", ".join(f"0x{value:02X}" for value in packed[start:start + 8]) + ",")
    lines += ["};", "", "#endif", ""]
    Path(path).parent.mkdir(parents=True, exist_ok=True)
    Path(path).write_text("\n".join(lines))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("input")
    parser.add_argument("output")
    parser.add_argument("--tile-x", type=int, default=0)
    parser.add_argument("--tile-y", type=int, default=0)
    parser.add_argument("--tile-size", type=int, default=16)
    parser.add_argument("--source-tile-size", type=int)
    parser.add_argument("--name", default="tile")
    parser.add_argument("--global-palette", action="store_true")
    parser.add_argument("--omit-palette", action="store_true")
    parser.add_argument("--color-key")
    args = parser.parse_args()
    color_key = tuple(map(int, args.color_key.split(","))) if args.color_key else None
    palette, packed = convert(
        args.input, args.tile_x, args.tile_y, args.tile_size, args.global_palette,
        color_key, args.source_tile_size
    )
    write_header(
        args.output, palette, packed, args.input, args.tile_x, args.tile_y,
        args.name, args.omit_palette
    )


if __name__ == "__main__":
    main()
