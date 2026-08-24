#!/usr/bin/env python3
"""Build per-level 16x16 playfield and Motion Object tilesets.

The level renderer already reproduces Atari's palette-dependent Motion Object
pen 1.  This tool therefore derives the visible MO layer from each full PNG
and its playfield-only counterpart instead of guessing a context-free colour.
Only the Python standard library is required.
"""

from __future__ import annotations

import argparse
import csv
import struct
import zlib
from dataclasses import dataclass
from pathlib import Path


PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"
TILE_SIZE = 16
ATLAS_COLUMNS = 16
GENERATED_SUFFIXES = (
    "-playfield-tiles.png",
    "-playfield-map.txt",
    "-motion-object-layer.png",
    "-motion-object-tiles.png",
    "-motion-object-map.txt",
)


@dataclass(frozen=True)
class RgbImage:
    width: int
    height: int
    pixels: bytes


def read_indexed_png(path: Path) -> RgbImage:
    """Read the filter-0 indexed PNGs emitted by extract_gauntlet_graphics."""
    data = path.read_bytes()
    if not data.startswith(PNG_SIGNATURE):
        raise ValueError(f"{path}: not a PNG")

    position = len(PNG_SIGNATURE)
    width = height = bit_depth = colour_type = None
    palette = b""
    compressed = bytearray()
    while position < len(data):
        if position + 12 > len(data):
            raise ValueError(f"{path}: truncated PNG chunk")
        length = struct.unpack_from(">I", data, position)[0]
        kind = data[position + 4:position + 8]
        payload = data[position + 8:position + 8 + length]
        stored_crc = struct.unpack_from(">I", data, position + 8 + length)[0]
        if zlib.crc32(kind + payload) & 0xFFFFFFFF != stored_crc:
            raise ValueError(f"{path}: invalid {kind.decode('ascii', 'replace')} CRC")
        position += 12 + length
        if kind == b"IHDR":
            width, height, bit_depth, colour_type, compression, filtering, interlace = (
                struct.unpack(">IIBBBBB", payload)
            )
            if (compression, filtering, interlace) != (0, 0, 0):
                raise ValueError(f"{path}: unsupported PNG encoding")
        elif kind == b"PLTE":
            palette = payload
        elif kind == b"IDAT":
            compressed.extend(payload)
        elif kind == b"IEND":
            break

    if None in (width, height, bit_depth, colour_type):
        raise ValueError(f"{path}: missing IHDR")
    if (bit_depth, colour_type) != (8, 3) or not palette:
        raise ValueError(f"{path}: expected an 8-bit indexed PNG")
    rows = zlib.decompress(bytes(compressed))
    stride = width + 1
    if len(rows) != stride * height:
        raise ValueError(f"{path}: unexpected decompressed size")

    rgb = bytearray(width * height * 3)
    for y in range(height):
        row = rows[y * stride:(y + 1) * stride]
        if row[0] != 0:
            raise ValueError(f"{path}: expected PNG filter 0")
        for x, index in enumerate(row[1:]):
            source = index * 3
            if source + 3 > len(palette):
                raise ValueError(f"{path}: palette index {index} is out of range")
            destination = (y * width + x) * 3
            rgb[destination:destination + 3] = palette[source:source + 3]
    return RgbImage(width, height, bytes(rgb))


def write_rgba_png(path: Path, width: int, height: int, pixels: bytes) -> None:
    if len(pixels) != width * height * 4:
        raise ValueError("RGBA pixel size does not match image dimensions")

    def chunk(kind: bytes, payload: bytes) -> bytes:
        body = kind + payload
        return (
            struct.pack(">I", len(payload))
            + body
            + struct.pack(">I", zlib.crc32(body) & 0xFFFFFFFF)
        )

    rows = b"".join(
        b"\0" + pixels[y * width * 4:(y + 1) * width * 4]
        for y in range(height)
    )
    path.write_bytes(
        PNG_SIGNATURE
        + chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0))
        + chunk(b"IDAT", zlib.compress(rows, 9))
        + chunk(b"IEND", b"")
    )


def rgb_to_rgba(pixels: bytes) -> bytes:
    result = bytearray(len(pixels) // 3 * 4)
    for source in range(0, len(pixels), 3):
        destination = source // 3 * 4
        result[destination:destination + 4] = pixels[source:source + 3] + b"\xff"
    return bytes(result)


def motion_layer(full: RgbImage, playfield: RgbImage) -> bytes:
    if (full.width, full.height) != (playfield.width, playfield.height):
        raise ValueError("full and playfield images have different dimensions")
    result = bytearray(full.width * full.height * 4)
    for source in range(0, len(full.pixels), 3):
        if full.pixels[source:source + 3] != playfield.pixels[source:source + 3]:
            destination = source // 3 * 4
            result[destination:destination + 4] = full.pixels[source:source + 3] + b"\xff"
    return bytes(result)


def split_unique_tiles(
    pixels: bytes,
    width: int,
    height: int,
    channels: int,
    reserve_empty: bool = False,
) -> tuple[list[bytes], list[int]]:
    if width % TILE_SIZE or height % TILE_SIZE:
        raise ValueError("level dimensions must be multiples of 16")
    tile_bytes = TILE_SIZE * TILE_SIZE * channels
    tiles: list[bytes] = []
    lookup: dict[bytes, int] = {}
    if reserve_empty:
        empty = bytes(tile_bytes)
        lookup[empty] = 0
        tiles.append(empty)

    tilemap = []
    for tile_y in range(height // TILE_SIZE):
        for tile_x in range(width // TILE_SIZE):
            tile = bytearray()
            for pixel_y in range(TILE_SIZE):
                start = (
                    ((tile_y * TILE_SIZE + pixel_y) * width + tile_x * TILE_SIZE)
                    * channels
                )
                tile.extend(pixels[start:start + TILE_SIZE * channels])
            key = bytes(tile)
            if key not in lookup:
                lookup[key] = len(tiles)
                tiles.append(key)
            tilemap.append(lookup[key])
    return tiles, tilemap


def write_atlas(
    path: Path,
    tiles: list[bytes],
    channels: int,
    columns: int = ATLAS_COLUMNS,
) -> None:
    rows = (len(tiles) + columns - 1) // columns
    width = columns * TILE_SIZE
    height = max(1, rows) * TILE_SIZE
    atlas = bytearray(width * height * 4)
    for number, tile in enumerate(tiles):
        tile_rgba = rgb_to_rgba(tile) if channels == 3 else tile
        origin_x = (number % columns) * TILE_SIZE
        origin_y = (number // columns) * TILE_SIZE
        for y in range(TILE_SIZE):
            source = y * TILE_SIZE * 4
            destination = ((origin_y + y) * width + origin_x) * 4
            atlas[destination:destination + TILE_SIZE * 4] = (
                tile_rgba[source:source + TILE_SIZE * 4]
            )
    write_rgba_png(path, width, height, bytes(atlas))


def pack_motion_groups(
    pixels: bytes,
    width: int,
    height: int,
) -> tuple[list[bytes], list[int], int]:
    """Pack connected occupied cells while preserving their 16x16 layout.

    Atari objects are built from 8x8 source graphics and may overhang the
    logical level cell.  The Neo Geo cannot address those source tiles.  We
    therefore keep every occupied 16x16 world cell adjacent to the other
    cells in its component.  Repeated cells are deliberately not deduplicated
    here: a later global pass may merge them after object chains are known.
    """
    source_tiles, source_map = split_unique_tiles(
        pixels, width, height, 4, reserve_empty=True
    )
    map_width = width // TILE_SIZE
    map_height = height // TILE_SIZE
    occupied = {
        (x, y)
        for y in range(map_height)
        for x in range(map_width)
        if source_map[y * map_width + x] != 0
    }

    groups: list[set[tuple[int, int]]] = []
    remaining = set(occupied)
    while remaining:
        start = min(remaining, key=lambda point: (point[1], point[0]))
        remaining.remove(start)
        group = {start}
        pending = [start]
        while pending:
            x, y = pending.pop()
            for dy in (-1, 0, 1):
                for dx in (-1, 0, 1):
                    if not (dx or dy):
                        continue
                    neighbour = (x + dx, y + dy)
                    if neighbour in remaining:
                        remaining.remove(neighbour)
                        group.add(neighbour)
                        pending.append(neighbour)
        groups.append(group)

    # A full-width component must fit without wrapping, so the packed atlas
    # uses the level's complete 32-cell width.  Row zero is reserved as an
    # all-transparent row; tile index zero therefore remains the empty tile.
    columns = map_width
    placements = []
    cursor_x = 0
    cursor_y = 1
    shelf_height = 0
    for group in groups:
        min_x = min(x for x, _ in group)
        max_x = max(x for x, _ in group)
        min_y = min(y for _, y in group)
        max_y = max(y for _, y in group)
        group_width = max_x - min_x + 1
        group_height = max_y - min_y + 1
        if cursor_x + group_width > columns:
            cursor_x = 0
            cursor_y += shelf_height
            shelf_height = 0
        placements.append((group, min_x, min_y, cursor_x, cursor_y))
        cursor_x += group_width
        shelf_height = max(shelf_height, group_height)
    rows = cursor_y + shelf_height

    empty = bytes(TILE_SIZE * TILE_SIZE * 4)
    atlas_tiles = [empty] * (columns * max(1, rows))
    packed_map = [0] * (map_width * map_height)
    for group, min_x, min_y, atlas_x, atlas_y in placements:
        for source_x, source_y in group:
            destination_x = atlas_x + source_x - min_x
            destination_y = atlas_y + source_y - min_y
            destination_index = destination_y * columns + destination_x
            source_index = source_map[source_y * map_width + source_x]
            atlas_tiles[destination_index] = source_tiles[source_index]
            packed_map[source_y * map_width + source_x] = destination_index
    return atlas_tiles, packed_map, len(groups)


def write_tilemap(
    path: Path,
    source_name: str,
    kind: str,
    tilemap: list[int],
    width: int,
    height: int,
    unique_count: int,
    extra_metadata: tuple[str, ...] = (),
    count_label: str = "UNIQUE_TILES",
) -> None:
    map_width = width // TILE_SIZE
    map_height = height // TILE_SIZE
    lines = [
        f"ATARI GAUNTLET {kind.upper()} 16X16 TILEMAP",
        f"SOURCE: {source_name}",
        f"GRID: {map_width} X {map_height}",
        f"TILE_SIZE: {TILE_SIZE} X {TILE_SIZE}",
        f"{count_label}: {unique_count}",
        *extra_metadata,
        "",
    ]
    for y in range(map_height):
        row = tilemap[y * map_width:(y + 1) * map_width]
        lines.append(" ".join(f"{value:04X}" for value in row))
    lines.append("")
    path.write_text("\n".join(lines), encoding="ascii", newline="\n")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--levels", type=Path, required=True,
                        help="directory containing full and *-playfield.png level images")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    pairs = []
    for full_path in sorted(args.levels.glob("*.png")):
        if full_path.stem.endswith("-playfield"):
            continue
        playfield_path = full_path.with_name(f"{full_path.stem}-playfield.png")
        if playfield_path.is_file():
            pairs.append((full_path, playfield_path))
    if not pairs:
        parser.error("no full/playfield PNG pairs found")

    args.output.mkdir(parents=True, exist_ok=True)
    expected = {"index.csv"}
    rows = []
    for full_path, playfield_path in pairs:
        stem = full_path.stem
        names = {suffix: f"{stem}{suffix}" for suffix in GENERATED_SUFFIXES}
        expected.update(names.values())

        full = read_indexed_png(full_path)
        playfield = read_indexed_png(playfield_path)
        motion = motion_layer(full, playfield)
        playfield_tiles, playfield_map = split_unique_tiles(
            playfield.pixels, playfield.width, playfield.height, 3
        )
        unique_motion_tiles, _ = split_unique_tiles(
            motion, full.width, full.height, 4, reserve_empty=True
        )
        motion_tiles, motion_map, motion_groups = pack_motion_groups(
            motion, full.width, full.height
        )

        write_atlas(args.output / names["-playfield-tiles.png"], playfield_tiles, 3)
        write_tilemap(
            args.output / names["-playfield-map.txt"],
            playfield_path.name,
            "playfield",
            playfield_map,
            playfield.width,
            playfield.height,
            len(playfield_tiles),
        )
        write_rgba_png(
            args.output / names["-motion-object-layer.png"],
            full.width,
            full.height,
            motion,
        )
        write_atlas(
            args.output / names["-motion-object-tiles.png"],
            motion_tiles,
            4,
            columns=full.width // TILE_SIZE,
        )
        write_tilemap(
            args.output / names["-motion-object-map.txt"],
            full_path.name,
            "motion object",
            motion_map,
            full.width,
            full.height,
            len(motion_tiles),
            (
                f"UNIQUE_PIXEL_TILES: {len(unique_motion_tiles)}",
                f"CONNECTED_OBJECT_GROUPS: {motion_groups}",
            ),
            count_label="ATLAS_TILES",
        )

        rows.append((
            stem,
            len(playfield_tiles),
            len(unique_motion_tiles),
            sum(value != 0 for value in motion_map),
            motion_groups,
            len(motion_tiles),
        ))

    for stale in args.output.iterdir():
        if stale.is_file() and stale.name != "index.csv" and (
            any(stale.name.endswith(suffix) for suffix in GENERATED_SUFFIXES)
        ) and stale.name not in expected:
            stale.unlink()

    with (args.output / "index.csv").open("w", newline="") as stream:
        writer = csv.writer(stream, lineterminator="\n")
        writer.writerow((
            "level", "unique_playfield_tiles", "unique_motion_object_tiles",
            "occupied_motion_object_cells", "connected_motion_object_groups",
            "packed_motion_object_atlas_tiles",
        ))
        writer.writerows(rows)
    print(f"extracted per-level 16x16 playfield and Motion Object tilesets for {len(rows)} maps")


if __name__ == "__main__":
    main()
