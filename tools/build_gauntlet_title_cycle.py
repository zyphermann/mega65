#!/usr/bin/env python3
"""Recover Gauntlet's exact per-pixel title-logo palette animation."""

from __future__ import annotations

import argparse
import csv
import json
import struct
from pathlib import Path

from build_neogeo_title import neogeo_rgb, neogeo_word
from index_png import marker_colours, read_rgb_png, write_indexed_png


def crop_rgb(
    width: int, height: int, pixels: bytes, left: int, top: int, right: int, bottom: int
) -> tuple[int, int, bytes]:
    output_width = width - left - right
    output_height = height - top - bottom
    if output_width <= 0 or output_height <= 0:
        raise ValueError("crop removes the complete image")
    output = b"".join(
        pixels[(y * width + left) * 3:(y * width + width - right) * 3]
        for y in range(top, height - bottom)
    )
    return output_width, output_height, output


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input-directory", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--palette-bin", type=Path, required=True)
    parser.add_argument("--palette-csv", type=Path, required=True)
    parser.add_argument("--cycle-bin", type=Path, required=True)
    parser.add_argument("--cycle-csv", type=Path, required=True)
    parser.add_argument("--summary", type=Path, required=True)
    parser.add_argument("--frame-step", type=int, default=3)
    parser.add_argument("--left", type=int, default=1)
    parser.add_argument("--top", type=int, default=1)
    parser.add_argument("--right", type=int, default=9)
    parser.add_argument("--bottom", type=int, default=1)
    args = parser.parse_args()

    paths = sorted(args.input_directory.glob("title-cycle-*.png"))
    if len(paths) < 2:
        raise ValueError("title cycle needs at least two captured PNGs")
    frames = []
    dimensions = None
    for path in paths:
        width, height, pixels = read_rgb_png(path)
        cropped = crop_rgb(
            width, height, pixels, args.left, args.top, args.right, args.bottom
        )
        if dimensions is None:
            dimensions = cropped[:2]
        elif cropped[:2] != dimensions:
            raise ValueError("title cycle frames have inconsistent dimensions")
        frames.append(cropped[2])
    width, height = dimensions

    period = next((index for index in range(1, len(frames)) if frames[index] == frames[0]), 0)
    if not period:
        raise ValueError("captured title sequence does not contain a complete cycle")
    phases = frames[:period]
    if len(set(phases)) != period:
        raise ValueError("title cycle repeats internally before its detected period")

    signatures: dict[tuple[bytes, ...], list[int]] = {}
    for pixel_index in range(width * height):
        offset = pixel_index * 3
        signature = tuple(frame[offset:offset + 3] for frame in phases)
        if len(set(signature)) > 1:
            signatures.setdefault(signature, []).append(pixel_index)
    if not signatures:
        raise ValueError("title cycle contains no animated pixels")

    # Spatial ordering makes track numbers deterministic even when two tracks
    # have the same colour in phase zero.
    ordered_signatures = sorted(signatures, key=lambda signature: signatures[signature][0])
    track_for_signature = {
        signature: track for track, signature in enumerate(ordered_signatures)
    }
    track_for_pixel = {}
    for signature, pixels in signatures.items():
        track = track_for_signature[signature]
        track_for_pixel.update((pixel, track) for pixel in pixels)

    phase_zero = phases[0]
    base_colours = list(dict.fromkeys(
        phase_zero[offset:offset + 3] for offset in range(0, len(phase_zero), 3)
    ))
    black = b"\0\0\0"
    if black in base_colours:
        base_colours.remove(black)
        base_colours.insert(0, black)
    markers = marker_colours(len(ordered_signatures), set(base_colours))
    palette = base_colours + markers
    base_lookup = {colour: index for index, colour in enumerate(base_colours)}
    marker_base = len(base_colours)
    indexed = bytes(
        marker_base + track_for_pixel[pixel]
        if pixel in track_for_pixel
        else base_lookup[phase_zero[pixel * 3:pixel * 3 + 3]]
        for pixel in range(width * height)
    )

    for path in (
        args.output, args.palette_bin, args.palette_csv,
        args.cycle_bin, args.cycle_csv, args.summary,
    ):
        path.parent.mkdir(parents=True, exist_ok=True)
    write_indexed_png(args.output, width, height, indexed, palette)
    args.palette_bin.write_bytes(b"".join(palette))
    with args.palette_csv.open("w", newline="") as stream:
        writer = csv.writer(stream, lineterminator="\n")
        writer.writerow(("index", "red", "green", "blue", "rgb", "role", "source_rgb", "track"))
        for index, colour in enumerate(palette):
            track = index - marker_base
            animated = track >= 0
            source = ordered_signatures[track][0] if animated else None
            writer.writerow((
                index, *colour, "#" + colour.hex(),
                "animated_track" if animated else "original",
                "" if source is None else "#" + source.hex(),
                track if animated else "",
            ))

    cycle_words = bytearray()
    with args.cycle_csv.open("w", newline="") as stream:
        writer = csv.writer(stream, lineterminator="\n")
        writer.writerow(("phase", "track", "red", "green", "blue", "rgb", "neo_word", "neo_rgb"))
        for phase in range(period):
            for track, signature in enumerate(ordered_signatures):
                colour = signature[phase]
                word = neogeo_word(colour)
                converted = neogeo_rgb(word)
                cycle_words.extend(struct.pack(">H", word))
                writer.writerow((
                    phase, track, *colour, "#" + colour.hex(),
                    f"0x{word:04x}", "#" + converted.hex(),
                ))
    args.cycle_bin.write_bytes(cycle_words)

    summary = {
        "width": width,
        "height": height,
        "captured_frames": len(frames),
        "frame_step": args.frame_step,
        "period_phases": period,
        "period_frames": period * args.frame_step,
        "animated_tracks": len(ordered_signatures),
        "animated_pixels": sum(len(pixels) for pixels in signatures.values()),
        "phase_zero_distinct_animated_colours": len({
            signature[0] for signature in ordered_signatures
        }),
        "logical_palette_words": period * len(ordered_signatures),
        "logical_palette_bytes": len(cycle_words),
    }
    args.summary.write_text(json.dumps(summary, indent=2) + "\n")
    print(
        f"recovered {period} phases x {len(ordered_signatures)} tracks "
        f"from {sum(len(pixels) for pixels in signatures.values())} animated pixels"
    )


if __name__ == "__main__":
    main()
