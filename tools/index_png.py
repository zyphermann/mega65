#!/usr/bin/env python3
"""Convert an 8-bit RGB PNG losslessly to an indexed PNG and palette files."""

from __future__ import annotations

import argparse
import colorsys
import csv
import struct
import zlib
from pathlib import Path


PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"


def read_rgb_png(path: Path) -> tuple[int, int, bytes]:
    data = path.read_bytes()
    if not data.startswith(PNG_SIGNATURE):
        raise ValueError(f"{path} is not a PNG")
    position = len(PNG_SIGNATURE)
    compressed = []
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
            if (depth, colour_type, compression, filtering, interlace) != (8, 2, 0, 0, 0):
                raise ValueError("input must be a non-interlaced 8-bit RGB PNG")
        elif kind == b"IDAT":
            compressed.append(payload)
        elif kind == b"IEND":
            break

    raw = zlib.decompress(b"".join(compressed))
    bytes_per_pixel = 3
    stride = width * bytes_per_pixel
    previous = bytearray(stride)
    pixels = bytearray()
    source = 0
    for _ in range(height):
        filter_type = raw[source]
        source += 1
        row = bytearray(raw[source:source + stride])
        source += stride
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
    return width, height, bytes(pixels)


def png_chunk(kind: bytes, payload: bytes) -> bytes:
    body = kind + payload
    return struct.pack(">I", len(payload)) + body + struct.pack(">I", zlib.crc32(body))


def write_indexed_png(
    path: Path, width: int, height: int, pixels: bytes, palette: list[bytes]
) -> None:
    rows = b"".join(
        b"\0" + pixels[y * width:(y + 1) * width] for y in range(height)
    )
    path.write_bytes(
        PNG_SIGNATURE
        + png_chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 3, 0, 0, 0))
        + png_chunk(b"PLTE", b"".join(palette))
        + png_chunk(b"IDAT", zlib.compress(rows, 9))
        + png_chunk(b"IEND", b"")
    )


def write_palette_files(
    binary_path: Path,
    csv_path: Path,
    palette: list[bytes],
    roles: list[str] | None = None,
    sources: list[bytes | None] | None = None,
) -> None:
    binary_path.write_bytes(b"".join(palette))
    with csv_path.open("w", newline="") as stream:
        writer = csv.writer(stream, lineterminator="\n")
        writer.writerow(("index", "red", "green", "blue", "rgb", "role", "source_rgb"))
        for index, colour in enumerate(palette):
            red, green, blue = colour
            source = sources[index] if sources is not None else None
            writer.writerow((
                index,
                red,
                green,
                blue,
                f"#{red:02x}{green:02x}{blue:02x}",
                roles[index] if roles is not None else "original",
                "" if source is None else f"#{source[0]:02x}{source[1]:02x}{source[2]:02x}",
            ))


def marker_colours(count: int, forbidden: set[bytes]) -> list[bytes]:
    """Generate vivid RGB markers that cannot occur in MAME's IRGB output."""
    result = []
    steps = max(count, 1)
    candidate = 0
    while len(result) < count:
        hue = ((candidate / steps) + 5 / 6) % 1.0
        rgb = bytes(
            round(channel * 255)
            for channel in colorsys.hsv_to_rgb(hue, 1.0, 1.0)
        )
        if rgb not in forbidden and rgb not in result:
            result.append(rgb)
        candidate += 1
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--palette-bin", type=Path, required=True)
    parser.add_argument("--palette-csv", type=Path, required=True)
    parser.add_argument("--animated-phase", type=Path)
    parser.add_argument("--marked-output", type=Path)
    parser.add_argument("--marked-palette-bin", type=Path)
    parser.add_argument("--marked-palette-csv", type=Path)
    args = parser.parse_args()

    width, height, rgb_pixels = read_rgb_png(args.input)
    colours = list(dict.fromkeys(
        rgb_pixels[offset:offset + 3] for offset in range(0, len(rgb_pixels), 3)
    ))
    black = b"\0\0\0"
    if black in colours:
        colours.remove(black)
        colours.insert(0, black)
    if len(colours) > 256:
        raise ValueError(f"lossless indexing requires {len(colours)} colours")

    lookup = {colour: index for index, colour in enumerate(colours)}
    indices = bytes(
        lookup[rgb_pixels[offset:offset + 3]]
        for offset in range(0, len(rgb_pixels), 3)
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    write_indexed_png(args.output, width, height, indices, colours)
    write_palette_files(args.palette_bin, args.palette_csv, colours)

    marker_args = (
        args.animated_phase,
        args.marked_output,
        args.marked_palette_bin,
        args.marked_palette_csv,
    )
    if any(marker_args) and not all(marker_args):
        parser.error("all marked-output options require --animated-phase")

    marker_count = 0
    animated_pixels = 0
    if all(marker_args):
        phase_width, phase_height, phase_pixels = read_rgb_png(args.animated_phase)
        if (phase_width, phase_height) != (width, height):
            raise ValueError("animated phase dimensions do not match input")
        animated = [
            rgb_pixels[offset:offset + 3] != phase_pixels[offset:offset + 3]
            for offset in range(0, len(rgb_pixels), 3)
        ]
        animated_colours = list(dict.fromkeys(
            rgb_pixels[index * 3:index * 3 + 3]
            for index, active in enumerate(animated)
            if active
        ))
        markers = marker_colours(len(animated_colours), set(colours))
        marker_lookup = {
            colour: len(colours) + index
            for index, colour in enumerate(animated_colours)
        }
        marked_palette = colours + markers
        marked_indices = bytes(
            marker_lookup[rgb_pixels[index * 3:index * 3 + 3]]
            if active
            else lookup[rgb_pixels[index * 3:index * 3 + 3]]
            for index, active in enumerate(animated)
        )
        write_indexed_png(
            args.marked_output, width, height, marked_indices, marked_palette
        )
        write_palette_files(
            args.marked_palette_bin,
            args.marked_palette_csv,
            marked_palette,
            ["original"] * len(colours) + ["animated_marker"] * len(markers),
            [None] * len(colours) + animated_colours,
        )
        marker_count = len(markers)
        animated_pixels = sum(animated)

    print(
        f"indexed {width}x{height} PNG losslessly with {len(colours)} colours; "
        f"marked {animated_pixels} animated pixels with {marker_count} exclusive colours"
    )


if __name__ == "__main__":
    main()
