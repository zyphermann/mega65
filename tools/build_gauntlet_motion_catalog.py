#!/usr/bin/env python3
"""Render traced Gauntlet Motion Object frames on a Neo-Geo-safe 16x16 grid."""

from __future__ import annotations

import argparse
import csv
from dataclasses import dataclass
from pathlib import Path

from extract_gauntlet_level_tilesets import write_rgba_png
from extract_gauntlet_levels import build_program_rom, irgb4444


TILE_SIZE = 16
ATLAS_COLUMNS = 32


@dataclass(frozen=True)
class Frame:
    first_frame: int
    slot: int
    raw_code: int
    decoded_code: int
    width: int
    height: int
    xflip: bool
    palette: int
    palette_words: tuple[int, ...]
    source: str


def read_trace(path: Path) -> list[Frame]:
    result = []
    with path.open(newline="") as stream:
        for row in csv.DictReader(stream):
            words = tuple(int(value, 16) for value in row["palette_words"].split())
            if len(words) != 16:
                raise ValueError(f"{path}: trace row does not contain 16 palette words")
            result.append(Frame(
                first_frame=int(row["first_frame"]),
                slot=int(row["slot"]),
                raw_code=int(row["raw_code"], 16),
                decoded_code=int(row["decoded_code"], 16),
                width=int(row["width"]),
                height=int(row["height"]),
                xflip=bool(int(row["xflip"])),
                palette=int(row["palette"]),
                palette_words=words,
                source="mame-trace",
            ))
    return result


def palette_words(dump: bytes, group: int) -> tuple[int, ...]:
    start = (256 + group * 16) * 2
    return tuple(
        int.from_bytes(dump[start + pen * 2:start + pen * 2 + 2], "big")
        for pen in range(16)
    )


def seeded_energy_frames(game: str, dump: bytes) -> list[Frame]:
    """Add ROM-proven generator energy states even if one is absent in a trace."""
    if game == "gauntlet":
        families = (
            (0x0800, 3, 3, (2, 3, 4)),
            (0x09E1, 3, 3, (2, 3, 4)),
            (0x183F, 3, 3, (6, 7, 8)),
            (0x1B57, 3, 2, (9, 10, 11)),
            (0x13A2, 3, 3, (9, 10, 11)),
        )
    else:
        # Gauntlet II's initial large-object representatives. Several states
        # share group 5; keeping the code variants separate preserves them.
        families = (
            (0x09AB, 3, 3, (5,)), (0x09B4, 3, 3, (5,)),
            (0x09BD, 3, 3, (5,)), (0x09C6, 3, 3, (5,)),
            (0x09CF, 3, 3, (5,)), (0x09D8, 3, 3, (5,)),
            (0x183F, 3, 3, (8,)), (0x1990, 3, 3, (8,)),
            (0x1B57, 3, 2, (11,)), (0x1648, 3, 3, (12,)),
        )
    return [
        Frame(
            first_frame=-1,
            slot=-1,
            raw_code=code,
            decoded_code=code ^ 0x0800,
            width=width,
            height=height,
            xflip=False,
            palette=group,
            palette_words=palette_words(dump, group),
            source="rom-energy-table",
        )
        for code, width, height, groups in families
        for group in groups
    ]


def seeded_animation_frames(game: str, dump: bytes, program: bytes) -> list[Frame]:
    """Extract complete code sets from the ROM animation tables we identified."""
    # tuple: table start/end, accepted code range, Atari tile rectangle,
    # and every palette/energy group used by that object family.
    if game == "gauntlet":
        families = (
            (0x0CB80, 0x0CBD8, 0x13A0, 0x1676, 3, 3, (12, 13, 14, 15)),
            (0x0CC20, 0x0D000, 0x0800, 0x0C00, 3, 3, (2, 3, 4)),
            (0x0CC20, 0x0D000, 0x13A0, 0x1410, 3, 3, (9, 10, 11)),
            (0x0CC20, 0x0D000, 0x1800, 0x19A0, 3, 3, (6, 7, 8)),
            (0x0CC20, 0x0D000, 0x1B00, 0x1C80, 3, 2, (9, 10, 11)),
        )
    else:
        families = (
            (0x58A60, 0x58B88, 0x1100, 0x1676, 3, 3, (12, 13, 14, 15)),
            (0x590A0, 0x591A8, 0x1800, 0x19A0, 3, 3, (8,)),
            (0x59330, 0x59430, 0x2300, 0x2600, 3, 3, (1,)),
            (0x59430, 0x59540, 0x2600, 0x2688, 3, 3, (8,)),
            (0x591A0, 0x59330, 0x1B00, 0x1C80, 3, 2, (11,)),
        )

    result = []
    for start, end, first_code, last_code, width, height, groups in families:
        codes = sorted({
            int.from_bytes(program[offset:offset + 2], "big") & 0x7FFF
            for offset in range(start, end, 2)
            if first_code <= int.from_bytes(program[offset:offset + 2], "big") & 0x7FFF < last_code
        })
        for code in codes:
            for group in groups:
                result.append(Frame(
                    first_frame=-1,
                    slot=-1,
                    raw_code=code,
                    decoded_code=code ^ 0x0800,
                    width=width,
                    height=height,
                    xflip=False,
                    palette=group,
                    palette_words=palette_words(dump, group),
                    source="rom-animation-table",
                ))
    return result


def render_frame(frame: Frame, tiles: tuple[bytes, ...]) -> tuple[int, int, bytes, bytes]:
    pixel_width = frame.width * 8
    pixel_height = frame.height * 8
    padded_width = ((pixel_width + 15) // 16) * 16
    padded_height = ((pixel_height + 15) // 16) * 16
    pixels = bytearray(padded_width * padded_height * 4)
    pen1_mask = bytearray(padded_width * padded_height * 4)
    colours = tuple(irgb4444(value) for value in frame.palette_words)

    for tile_y in range(frame.height):
        for tile_x in range(frame.width):
            tile = tiles[(frame.decoded_code + tile_y * frame.width + tile_x) % len(tiles)]
            for py in range(8):
                for px in range(8):
                    pen = tile[py * 8 + px]
                    if not pen:
                        continue
                    destination_x = tile_x * 8 + px
                    destination_y = tile_y * 8 + py
                    if frame.xflip:
                        destination_x = pixel_width - 1 - destination_x
                    offset = (destination_y * padded_width + destination_x) * 4
                    if pen == 1:
                        # Atari pen 1 modifies the underlying playfield rather
                        # than using an MO colour. Preview it as 50%-opaque
                        # black while retaining the same pixels in a separate
                        # binary mask for later level/background-dependent
                        # colour synthesis. Neo Geo output itself will use a
                        # solid palette colour rather than alpha blending.
                        pixels[offset:offset + 4] = b"\x00\x00\x00\x80"
                        pen1_mask[offset:offset + 4] = b"\xff\xff\xff\xff"
                    else:
                        pixels[offset:offset + 4] = bytes(colours[pen]) + b"\xff"
    return padded_width, padded_height, bytes(pixels), bytes(pen1_mask)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--game", choices=("gauntlet", "gaunt2"), default="gauntlet")
    parser.add_argument("--trace", type=Path, required=True)
    parser.add_argument("--rom-dir", type=Path, required=True)
    parser.add_argument("--tiles", type=Path, required=True)
    parser.add_argument("--palette-dump", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    raw_tiles = args.tiles.read_bytes()
    expected_tiles = 12288 if args.game == "gaunt2" else 8192
    if len(raw_tiles) != expected_tiles * 64:
        raise ValueError(f"expected {expected_tiles} unpacked 8x8 tiles")
    tiles = tuple(raw_tiles[offset:offset + 64] for offset in range(0, len(raw_tiles), 64))
    dump = args.palette_dump.read_bytes()
    if len(dump) != 0x800:
        raise ValueError("palette dump must be exactly 0x800 bytes")

    program = build_program_rom(args.rom_dir, args.game)
    candidates = (
        read_trace(args.trace)
        + seeded_energy_frames(args.game, dump)
        + seeded_animation_frames(args.game, dump, program)
    )
    by_key = {}
    for frame in candidates:
        key = (
            frame.raw_code, frame.width, frame.height, frame.xflip,
            frame.palette, frame.palette_words,
        )
        # Prefer an actually observed record over a static seed.
        if key not in by_key or by_key[key].first_frame < 0 <= frame.first_frame:
            by_key[key] = frame
    frames = sorted(by_key.values(), key=lambda item: (
        item.raw_code, item.palette, item.width, item.height, item.xflip
    ))

    rendered = [(frame, *render_frame(frame, tiles)) for frame in frames]
    placements = []
    cursor_x = cursor_y = shelf_height = 0
    for frame, width, height, pixels, pen1_mask in rendered:
        cells_w = width // TILE_SIZE
        cells_h = height // TILE_SIZE
        if cursor_x + cells_w > ATLAS_COLUMNS:
            cursor_x = 0
            cursor_y += shelf_height + 1
            shelf_height = 0
        placements.append((
            frame, cursor_x, cursor_y, cells_w, cells_h,
            width, height, pixels, pen1_mask,
        ))
        cursor_x += cells_w + 1
        shelf_height = max(shelf_height, cells_h)
    atlas_rows = cursor_y + shelf_height
    atlas_width = ATLAS_COLUMNS * TILE_SIZE
    atlas_height = max(1, atlas_rows) * TILE_SIZE
    atlas = bytearray(atlas_width * atlas_height * 4)
    mask_atlas = bytearray(atlas_width * atlas_height * 4)
    for _, cell_x, cell_y, _, _, width, height, pixels, pen1_mask in placements:
        for y in range(height):
            source = y * width * 4
            destination = ((cell_y * TILE_SIZE + y) * atlas_width + cell_x * TILE_SIZE) * 4
            atlas[destination:destination + width * 4] = pixels[source:source + width * 4]
            mask_atlas[destination:destination + width * 4] = pen1_mask[source:source + width * 4]

    args.output.mkdir(parents=True, exist_ok=True)
    write_rgba_png(args.output / "frames.png", atlas_width, atlas_height, bytes(atlas))
    write_rgba_png(
        args.output / "pen-1-mask.png", atlas_width, atlas_height, bytes(mask_atlas)
    )
    with (args.output / "frames.csv").open("w", newline="") as stream:
        writer = csv.writer(stream, lineterminator="\n")
        writer.writerow((
            "frame_id", "source", "first_mame_frame", "slot", "raw_code",
            "decoded_code", "atari_width_8px", "atari_height_8px", "xflip",
            "palette", "atlas_x_16px", "atlas_y_16px", "width_16px",
            "height_16px", "pen_1",
        ))
        for frame_id, placement in enumerate(placements):
            frame, x, y, width, height, *_ = placement
            writer.writerow((
                frame_id, frame.source, frame.first_frame, frame.slot,
                f"0x{frame.raw_code:04X}", f"0x{frame.decoded_code:04X}",
                frame.width, frame.height, int(frame.xflip), frame.palette,
                x, y, width, height, "preview_black_alpha_128_and_separate_mask",
            ))
    print(f"rendered {len(frames)} traced/seeded Motion Object variants")


if __name__ == "__main__":
    main()
