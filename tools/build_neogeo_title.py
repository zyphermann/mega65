#!/usr/bin/env python3
"""Build a Neo-Geo-safe 20x14 title image from an indexed 320x224 PNG."""

from __future__ import annotations

import argparse
import csv
import json
import struct
from collections import Counter
from pathlib import Path

from crop_indexed_png import read_indexed_png
from index_png import write_indexed_png


TILE_SIZE = 16
VISIBLE_COLOURS = 15
FIRST_SPRITE_PALETTE = 16
LAST_SPRITE_PALETTE = 254


def colour_distance(left: bytes, right: bytes) -> int:
    red = left[0] - right[0]
    green = left[1] - right[1]
    blue = left[2] - right[2]
    return red * red * 3 + green * green * 4 + blue * blue * 2


def weighted_medoids(
    colours: list[int], counts: Counter[int], slots: int, palette: list[bytes]
) -> list[int]:
    if len(colours) <= slots:
        return sorted(colours)
    if slots <= 0:
        raise ValueError("tile has no palette slots left for ordinary colours")

    medoids = [max(colours, key=lambda colour: (counts[colour], -colour))]
    while len(medoids) < slots:
        candidate = max(
            (colour for colour in colours if colour not in medoids),
            key=lambda colour: (
                min(colour_distance(palette[colour], palette[item]) for item in medoids)
                * counts[colour],
                counts[colour],
                -colour,
            ),
        )
        medoids.append(candidate)

    for _ in range(20):
        clusters = {medoid: [] for medoid in medoids}
        for colour in colours:
            closest = min(
                medoids,
                key=lambda medoid: (
                    colour_distance(palette[colour], palette[medoid]), medoid
                ),
            )
            clusters[closest].append(colour)
        updated = []
        for medoid in medoids:
            cluster = clusters[medoid]
            updated.append(min(
                cluster,
                key=lambda candidate: (
                    sum(
                        counts[colour]
                        * colour_distance(palette[candidate], palette[colour])
                        for colour in cluster
                    ),
                    candidate,
                ),
            ))
        updated = list(dict.fromkeys(updated))
        if len(updated) < slots:
            remaining = [colour for colour in colours if colour not in updated]
            while len(updated) < slots:
                updated.append(max(
                    remaining,
                    key=lambda colour: (
                        min(
                            colour_distance(palette[colour], palette[item])
                            for item in updated
                        ) * counts[colour],
                        -colour,
                    ),
                ))
                remaining.remove(updated[-1])
        if set(updated) == set(medoids):
            break
        medoids = updated
    return sorted(medoids)


def neogeo_word(rgb: bytes) -> int:
    components = [round(channel * 31 / 255) for channel in rgb]
    red, green, blue = components
    return (
        ((red & 1) << 14)
        | ((green & 1) << 13)
        | ((blue & 1) << 12)
        | ((red >> 1) << 8)
        | ((green >> 1) << 4)
        | (blue >> 1)
    )


def neogeo_rgb(word: int) -> bytes:
    red = (((word >> 8) & 15) << 1) | ((word >> 14) & 1)
    green = (((word >> 4) & 15) << 1) | ((word >> 13) & 1)
    blue = ((word & 15) << 1) | ((word >> 12) & 1)
    return bytes(round(component * 255 / 31) for component in (red, green, blue))


def pack_4bpp(pens: bytes) -> bytes:
    if len(pens) != TILE_SIZE * TILE_SIZE:
        raise ValueError("tile must contain 256 pens")
    return bytes(
        (pens[index] << 4) | pens[index + 1]
        for index in range(0, len(pens), 2)
    )


def merge_palette_sets(required_sets: list[frozenset[int]]) -> tuple[list[set[int]], list[int]]:
    order = sorted(
        range(len(required_sets)),
        key=lambda index: (-len(required_sets[index]), tuple(sorted(required_sets[index]))),
    )
    banks: list[set[int]] = []
    assignment = [-1] * len(required_sets)
    for tile_index in order:
        required = set(required_sets[tile_index])
        candidates = []
        for bank_index, bank in enumerate(banks):
            combined = bank | required
            if len(combined) <= VISIBLE_COLOURS:
                candidates.append((len(combined) - len(bank), len(combined), bank_index))
        if candidates:
            _, _, bank_index = min(candidates)
            banks[bank_index].update(required)
        else:
            bank_index = len(banks)
            banks.append(required)
        assignment[tile_index] = bank_index

    changed = True
    while changed:
        changed = False
        for right in range(len(banks) - 1, -1, -1):
            for left in range(right):
                if len(banks[left] | banks[right]) <= VISIBLE_COLOURS:
                    banks[left].update(banks[right])
                    banks.pop(right)
                    assignment = [
                        left if value == right else value - 1 if value > right else value
                        for value in assignment
                    ]
                    changed = True
                    break
            if changed:
                break
    return banks, assignment


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--marker-palette-csv", type=Path, required=True)
    parser.add_argument("--animation-cycle-csv", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--tiles", type=Path, required=True)
    parser.add_argument("--tilemap-bin", type=Path, required=True)
    parser.add_argument("--tilemap-csv", type=Path, required=True)
    parser.add_argument("--palettes-bin", type=Path, required=True)
    parser.add_argument("--palettes-csv", type=Path, required=True)
    parser.add_argument("--animation-palettes-bin", type=Path, required=True)
    parser.add_argument("--animation-palettes-csv", type=Path, required=True)
    parser.add_argument("--summary", type=Path, required=True)
    args = parser.parse_args()

    width, height, pixels, palette = read_indexed_png(args.input)
    if (width, height) != (320, 224):
        raise ValueError("Neo-Geo title input must be exactly 320x224")
    with args.marker_palette_csv.open() as stream:
        marker_rows = list(csv.DictReader(stream))
    animated_rows = [row for row in marker_rows if row["role"].startswith("animated_")]
    protected = {int(row["index"]) for row in animated_rows}
    track_for_source = {int(row["index"]): int(row["track"]) for row in animated_rows}
    if max(protected, default=0) >= len(palette):
        raise ValueError("marker palette does not match indexed input")
    animation: dict[int, dict[int, tuple[bytes, int]]] = {}
    with args.animation_cycle_csv.open(newline="") as stream:
        for row in csv.DictReader(stream):
            phase = int(row["phase"])
            track = int(row["track"])
            animation.setdefault(phase, {})[track] = (
                bytes.fromhex(row["rgb"][1:]), int(row["neo_word"], 16)
            )
    phases = sorted(animation)
    if phases != list(range(len(phases))):
        raise ValueError("animation phases must be contiguous and start at zero")
    expected_tracks = set(track_for_source.values())
    if not phases or any(set(animation[phase]) != expected_tracks for phase in phases):
        raise ValueError("animation cycle does not match protected title tracks")

    def output_word(source_colour: int, phase: int = 0) -> int:
        if source_colour in protected:
            return animation[phase][track_for_source[source_colour]][1]
        return neogeo_word(palette[source_colour])

    tiles_wide = width // TILE_SIZE
    tiles_high = height // TILE_SIZE
    tile_sources = []
    tile_maps = []
    required_sets = []
    tile_stats = []
    quantized_tiles = 0
    changed_pixels = 0
    changed_marker_pixels = 0
    squared_error = 0

    for tile_y in range(tiles_high):
        for tile_x in range(tiles_wide):
            source = bytes(
                pixels[(tile_y * TILE_SIZE + y) * width + tile_x * TILE_SIZE + x]
                for y in range(TILE_SIZE)
                for x in range(TILE_SIZE)
            )
            counts = Counter(source)
            visible = set(counts) - {0}
            markers = visible & protected
            ordinary = sorted(visible - markers)
            slots = VISIBLE_COLOURS - len(markers)
            medoids = weighted_medoids(ordinary, counts, slots, palette)
            representatives = set(markers) | set(medoids)
            mapping = {0: 0}
            mapping.update({colour: colour for colour in markers})
            for colour in ordinary:
                mapping[colour] = min(
                    medoids,
                    key=lambda representative: (
                        colour_distance(palette[colour], palette[representative]),
                        representative,
                    ),
                )
            remapped = bytes(mapping[colour] for colour in source)
            changed = sum(left != right for left, right in zip(source, remapped))
            if changed:
                quantized_tiles += 1
            changed_pixels += changed
            changed_marker_pixels += sum(
                left in protected and left != right
                for left, right in zip(source, remapped)
            )
            squared_error += sum(
                colour_distance(palette[left], palette[right])
                for left, right in zip(source, remapped)
                if left != right
            )
            tile_sources.append(source)
            tile_maps.append((mapping, remapped))
            required_sets.append(frozenset(representatives))
            tile_stats.append((len(visible), len(representatives), len(markers), changed))

    banks, assignment = merge_palette_sets(required_sets)
    if len(banks) > LAST_SPRITE_PALETTE - FIRST_SPRITE_PALETTE + 1:
        raise ValueError(f"title needs {len(banks)} sprite palettes")

    ordered_banks = []
    for bank in banks:
        ordered = sorted(bank, key=lambda colour: (colour not in protected, colour))
        ordered_banks.append([0] + ordered + [0] * (VISIBLE_COLOURS - len(ordered)))

    packed_tiles = [bytes(TILE_SIZE * TILE_SIZE // 2)]
    tile_lookup = {packed_tiles[0]: 0}
    tile_records = []
    preview_rgb = bytearray(width * height * 3)
    max_tile_colours = 0

    for tile_index, ((mapping, remapped), local_bank_index) in enumerate(zip(tile_maps, assignment)):
        bank = ordered_banks[local_bank_index]
        pens = {colour: pen for pen, colour in enumerate(bank)}
        local = bytes(pens[colour] for colour in remapped)
        max_tile_colours = max(max_tile_colours, len(set(local)))
        packed = pack_4bpp(local)
        if packed not in tile_lookup:
            tile_lookup[packed] = len(packed_tiles)
            packed_tiles.append(packed)
        graphics_tile = tile_lookup[packed]
        tile_x = tile_index % tiles_wide
        tile_y = tile_index // tiles_wide
        absolute_palette = FIRST_SPRITE_PALETTE + local_bank_index
        source_count, output_count, marker_count, changed = tile_stats[tile_index]
        tile_records.append((
            tile_x, tile_y, graphics_tile, absolute_palette,
            source_count, output_count, marker_count, changed,
        ))
        for y in range(TILE_SIZE):
            for x in range(TILE_SIZE):
                pen = local[y * TILE_SIZE + x]
                source_colour = bank[pen]
                rgb = b"\0\0\0" if pen == 0 else neogeo_rgb(output_word(source_colour))
                destination = ((tile_y * TILE_SIZE + y) * width + tile_x * TILE_SIZE + x) * 3
                preview_rgb[destination:destination + 3] = rgb

    preview_colours = list(dict.fromkeys(
        bytes(preview_rgb[offset:offset + 3])
        for offset in range(0, len(preview_rgb), 3)
    ))
    black = b"\0\0\0"
    if black in preview_colours:
        preview_colours.remove(black)
        preview_colours.insert(0, black)
    preview_lookup = {colour: index for index, colour in enumerate(preview_colours)}
    preview_indices = bytes(
        preview_lookup[bytes(preview_rgb[offset:offset + 3])]
        for offset in range(0, len(preview_rgb), 3)
    )

    for path in (
        args.output, args.tiles, args.tilemap_bin, args.tilemap_csv,
        args.palettes_bin, args.palettes_csv, args.animation_palettes_bin,
        args.animation_palettes_csv, args.summary,
    ):
        path.parent.mkdir(parents=True, exist_ok=True)
    if changed_marker_pixels:
        raise ValueError(f"quantization changed {changed_marker_pixels} marker pixels")
    write_indexed_png(args.output, width, height, preview_indices, preview_colours)
    args.tiles.write_bytes(b"".join(packed_tiles))

    # Hardware-ready big-endian palette RAM image: palettes 16.. are used by
    # this title, palette 0 colour 0 is the reference black, and palette 255
    # colour 15 is the black backdrop.
    palette_words = [0] * (256 * 16)
    palette_words[0] = 0x8000
    palette_words[255 * 16 + 15] = 0x8000
    for local_bank_index, bank in enumerate(ordered_banks):
        absolute_palette = FIRST_SPRITE_PALETTE + local_bank_index
        for pen, source_colour in enumerate(bank):
            if pen:
                palette_words[absolute_palette * 16 + pen] = output_word(source_colour)
    args.palettes_bin.write_bytes(b"".join(
        struct.pack(">H", word) for word in palette_words
    ))

    with args.palettes_csv.open("w", newline="") as stream:
        writer = csv.writer(stream, lineterminator="\n")
        writer.writerow((
            "palette", "pen", "source_index", "role", "track", "source_rgb",
            "neo_word", "neo_rgb",
        ))
        for local_bank_index, bank in enumerate(ordered_banks):
            absolute_palette = FIRST_SPRITE_PALETTE + local_bank_index
            for pen, source_colour in enumerate(bank):
                word = 0 if pen == 0 else output_word(source_colour)
                rgb = black if pen == 0 else neogeo_rgb(word)
                writer.writerow((
                    absolute_palette,
                    pen,
                    source_colour,
                    "transparent" if pen == 0 else "animated_track"
                    if source_colour in protected else "static",
                    track_for_source[source_colour] if source_colour in protected else "",
                    "#" + palette[source_colour].hex(),
                    f"0x{word:04x}",
                    "#" + rgb.hex(),
                ))

    animated_occurrences = []
    for local_bank_index, bank in enumerate(ordered_banks):
        absolute_palette = FIRST_SPRITE_PALETTE + local_bank_index
        for pen, source_colour in enumerate(bank):
            if pen and source_colour in protected:
                animated_occurrences.append((
                    absolute_palette, pen, source_colour, track_for_source[source_colour]
                ))
    animation_words = bytearray()
    with args.animation_palettes_csv.open("w", newline="") as stream:
        writer = csv.writer(stream, lineterminator="\n")
        writer.writerow((
            "phase", "palette", "pen", "source_index", "track",
            "source_rgb", "neo_word", "neo_rgb",
        ))
        for phase in phases:
            for absolute_palette, pen, source_colour, track in animated_occurrences:
                source_rgb, word = animation[phase][track]
                converted = neogeo_rgb(word)
                animation_words.extend(struct.pack(">H", word))
                writer.writerow((
                    phase, absolute_palette, pen, source_colour, track,
                    "#" + source_rgb.hex(), f"0x{word:04x}", "#" + converted.hex(),
                ))
    args.animation_palettes_bin.write_bytes(animation_words)

    with args.tilemap_csv.open("w", newline="") as stream:
        writer = csv.writer(stream, lineterminator="\n")
        writer.writerow((
            "x", "y", "tile", "palette", "source_visible_colours",
            "output_visible_colours", "marker_colours", "changed_pixels",
        ))
        writer.writerows(tile_records)

    # Column-major SCB1 order: 20 chains of 14 tiles.  Each entry is the tile
    # word followed by the attribute word (palette in bits 15..8).
    by_position = {(row[0], row[1]): row for row in tile_records}
    args.tilemap_bin.write_bytes(b"".join(
        struct.pack(">HH", by_position[(x, y)][2], by_position[(x, y)][3] << 8)
        for x in range(tiles_wide)
        for y in range(tiles_high)
    ))

    summary = {
        "width": width,
        "height": height,
        "tile_width": TILE_SIZE,
        "tile_height": TILE_SIZE,
        "columns": tiles_wide,
        "rows": tiles_high,
        "screen_tiles": len(tile_records),
        "unique_graphics_tiles_including_blank": len(packed_tiles),
        "palette_first": FIRST_SPRITE_PALETTE,
        "palette_count": len(ordered_banks),
        "palette_last": FIRST_SPRITE_PALETTE + len(ordered_banks) - 1,
        "max_colours_per_tile_including_transparency": max_tile_colours,
        "quantized_tiles": quantized_tiles,
        "changed_pixels": changed_pixels,
        "changed_marker_pixels": changed_marker_pixels,
        "weighted_squared_error": squared_error,
        "protected_marker_colours": len(protected),
        "animation_phases": len(phases),
        "animation_tracks": len(expected_tracks),
        "animated_palette_entries": len(animated_occurrences),
        "animation_palette_bytes": len(animation_words),
        "tile_data_format": "16x16, row-major, two 4-bit pens per byte, left pixel high nibble",
        "tilemap_order": "column-major for 20 Neo-Geo vertical sprite chains",
    }
    args.summary.write_text(json.dumps(summary, indent=2) + "\n")
    print(
        f"Neo-Geo title: {len(tile_records)} screen tiles, {len(packed_tiles)} graphics tiles, "
        f"{len(ordered_banks)} palettes, max {max_tile_colours} pens/tile; "
        f"quantized {quantized_tiles} tiles / {changed_pixels} pixels"
    )


if __name__ == "__main__":
    main()
