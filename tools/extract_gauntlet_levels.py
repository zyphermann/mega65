#!/usr/bin/env python3
"""Extract Atari Gauntlet's protected level maps as ASCII and tiled PNGs."""

from __future__ import annotations

import argparse
from collections import Counter
from dataclasses import dataclass
from pathlib import Path

from extract_gauntlet_graphics import DIAGNOSTIC_4BPP, png


BANK_SIZE = 0x2000
CPU_WINDOW = 0x038000


@dataclass(frozen=True)
class GameFormat:
    even_rom: str
    odd_rom: str
    main_even_rom: str
    main_odd_rom: str
    bank_map_offset: int
    header_size: int
    pattern_offsets: tuple[int, int, int, int]
    marker_value: int
    normal_ids: tuple[int, ...]
    demo_ids: tuple[int, ...] = ()
    treasure_ids: tuple[int, ...] = ()

    @property
    def all_ids(self) -> tuple[int, ...]:
        return self.normal_ids + self.demo_ids + self.treasure_ids


GAME_FORMATS = {
    "gauntlet": GameFormat(
        even_rom="136037-205.10a",
        odd_rom="136037-206.10b",
        main_even_rom="136037-1307.9a",
        main_odd_rom="136037-1308.9b",
        bank_map_offset=0x1FD4,
        header_size=14,
        pattern_offsets=(10, 12, 11, 13),
        marker_value=1,
        normal_ids=tuple(range(114)),
        demo_ids=(150, 151),
        treasure_ids=tuple(range(152, 163)),
    ),
    "gaunt2": GameFormat(
        even_rom="136043-1105.10a",
        odd_rom="136043-1106.10b",
        main_even_rom="136037-1307.9a",
        main_odd_rom="136037-1308.9b",
        bank_map_offset=0x1FE0,
        header_size=11,
        pattern_offsets=(7, 9, 8, 10),
        marker_value=2,
        # The protected directory has 117 non-null records (IDs 0..116).
        # Keep all of them visible until their runtime roles are fully named.
        normal_ids=tuple(range(117)),
    ),
}
TYPE_DESCRIPTIONS = {
    0x03: "horizontal unlockable wall",
    0x04: "vertical unlockable wall",
    **{value: "bone generator variant" for value in range(0x09, 0x0C)},
    **{value: "enemy generator variant" for value in range(0x0C, 0x18)},
    **{value: "monster/bone entity variant" for value in range(0x19, 0x28)},
    0x28: "treasure chest",
    0x2B: "random food",
    0x35: "key",
}

# Static representatives observed in Gauntlet II level-1/2 Motion Object RAM.
# tuple: code word, width, height, colour group, X overhang, description
G2_STATIC_OBJECTS = {
    0x0F: (0x1648, 3, 3, 12, 4, "warrior start"),
    0x13: (0x09E1, 3, 3, 4, 4, "grunt"),
    0x14: (0x183F, 3, 3, 8, 4, "dragon/demon segment"),
    0x15: (0x1B57, 3, 2, 11, 4, "large enemy/entity"),
    0x1C: (0x09AB, 3, 3, 5, 4, "small item/entity"),
    0x1D: (0x09B4, 3, 3, 5, 4, "monster/bone entity"),
    0x1E: (0x09BD, 3, 3, 5, 4, "bone pile"),
    0x1F: (0x09C6, 3, 3, 5, 4, "generator variant"),
    0x20: (0x09CF, 3, 3, 5, 4, "generator variant"),
    0x21: (0x09D8, 3, 3, 5, 4, "generator variant"),
    0x22: (0x09C6, 3, 3, 5, 4, "generator/entity variant"),
    0x24: (0x09D8, 3, 3, 5, 4, "generator variant"),
    0x2E: (0x0990, 3, 3, 1, 4, "treasure chest"),
    0x2F: (0x25E4, 3, 3, 1, 4, "level object"),
    0x31: (0x0963, 3, 3, 1, 4, "food"),
    0x32: (0x097E, 3, 3, 1, 4, "potion"),
    0x35: (0x8AFC, 2, 2, 1, 0, "key"),
}
G2_TYPE_DESCRIPTIONS = {
    0x01: "alternate floor palette",
    0x02: "solid wall",
    0x04: "solid wall variant",
    0x05: "solid wall variant",
    0x06: "solid wall variant",
    0x07: "solid wall variant",
    0x08: "solid wall variant",
    0x09: "solid wall variant",
    0x0D: "horizontal unlockable gate",
    0x0E: "vertical unlockable gate",
    0x10: "normal exit",
    0x11: "alternate exit",
    **{cell_type: fields[5] for cell_type, fields in G2_STATIC_OBJECTS.items()},
    0x3F: "red wall insert",
}

# Exact PF and stain palettes captured from the running second level.  Unlike
# Gauntlet I, G2 changes these groups when a level is loaded.  The two primary
# groups come from ROM tables selected by header byte 6; the derived groups
# include the game's animated/special-floor colours at the capture instant.
G2_LEVEL_2_PF_PALETTE = bytes.fromhex("""
1222 1666 6666 3224 1000 2647 1000 8fff 1000 0aaa 2555 1461 1777 1000 1324 1222
1222 1666 6666 3224 1000 2647 1000 8fff 1000 0aaa 2555 1461 1777 1000 1324 1222
1222 1666 6666 3224 1000 2647 1000 8fff 1000 0aaa 2555 1461 1777 1000 1324 1222
1222 1666 6666 3224 1000 2647 1000 8fff 1000 0aaa 2555 1461 1777 1000 1324 1222
1000 1000 1fec 1f00 1f00 5f20 8f20 7fff 1f00 5f21 8f76 8f98 8fdd 8fff 1000 1000
1aaa 1223 1323 1434 1434 1535 1545 0656 1989 1656 1b9b 1335 1000 1000 1000 1000
1aaa 4223 1323 1434 1434 1535 2545 3656 4989 1656 4b9b 4335 1000 1000 1000 1000
3aaa 8223 2323 5434 0434 2535 6545 7656 8989 5656 8b9b 8335 1000 1000 1000 1000
4222 4666 d666 a224 0000 9647 0000 ffff 0000 7aaa 9555 2461 3777 0000 5324 2222
8088 4666 d666 a224 0000 9647 0000 ffff 0000 7aaa 8088 2461 8088 0000 5324 2222
5550 4666 d666 a224 0000 9647 0000 ffff 0000 7aaa 5550 2461 5550 0000 5324 2222
9fff 4666 d666 a224 0000 9647 0000 ffff 0000 7aaa 9fff 2461 9fff 0000 5324 2222
0000 0000 4fec 5f00 8f00 cf20 ff20 efff 8f00 8f00 8f00 8f00 cf21 ff76 0000 0000
3aaa 8223 2323 5434 0434 2535 6545 7656 8989 5656 8b9b 8335 1000 1000 1000 1000
6aaa b223 5323 8434 3434 5535 9545 a656 b989 8656 bb9b b335 1000 1000 1000 1000
aaaa f223 9323 c434 7434 9535 d545 e656 f989 c656 fb9b f335 0000 0000 0000 0000
""")


@dataclass(frozen=True)
class Level:
    record_id: int
    bank: int
    pointer: int
    header: bytes
    compressed_size: int
    cells: tuple[int, ...]


def interleave(even: bytes, odd: bytes) -> bytes:
    if len(even) != 0x4000 or len(odd) != 0x4000:
        raise ValueError("protected even and odd ROMs must each be exactly 0x4000 bytes")
    result = bytearray(0x8000)
    result[0::2] = even
    result[1::2] = odd
    return bytes(result)


def be32(data: bytes, offset: int) -> int:
    return int.from_bytes(data[offset : offset + 4], "big")


def be16(data: bytes, offset: int) -> int:
    return int.from_bytes(data[offset : offset + 2], "big")


def decode_level(record_id: int, protected_rom: bytes, game_format: GameFormat = GAME_FORMATS["gauntlet"]) -> Level:
    directory_bank = protected_rom[:BANK_SIZE]
    mapping_bank = protected_rom[3 * BANK_SIZE : 4 * BANK_SIZE]
    directory = be32(directory_bank, 0) - CPU_WINDOW
    pointer = be32(directory_bank, directory + 4 * record_id)

    packed_banks = mapping_bank[game_format.bank_map_offset + record_id // 4]
    bank = (packed_banks >> ((record_id * 2) & 7)) & 3
    if not CPU_WINDOW <= pointer < CPU_WINDOW + BANK_SIZE:
        raise ValueError(f"record {record_id}: invalid pointer 0x{pointer:06x}")

    start = bank * BANK_SIZE + pointer - CPU_WINDOW
    source = protected_rom[start : (bank + 1) * BANK_SIZE]
    if len(source) <= game_format.header_size:
        raise ValueError(f"record {record_id}: truncated level header")

    # This follows the original 68010 routine at $4ad06. The four dictionary
    # slots are pointers to the copied header bytes in this exact order.
    cells = [0] * 1024
    position = 32
    source_position = game_format.header_size
    current = source[game_format.pattern_offsets[2]]
    patterns = tuple(source[offset] for offset in game_format.pattern_offsets)

    def linear(value: int, count: int) -> None:
        nonlocal position
        for index in range(position, min(position + count, 1024)):
            cells[index] = value
        position += count

    def vertical(value: int, count: int) -> None:
        nonlocal position
        index = position
        for _ in range(count):
            if 0 <= index < 1024:
                cells[index] = value
            index -= 32
        position += 1

    while position < 1024:
        if source_position >= len(source):
            raise ValueError(f"record {record_id}: compressed stream runs past its bank")
        command = source[source_position]
        source_position += 1
        low_five = command & 0x1F
        command_class = command & 0xC0

        if command_class == 0x00:
            current = command
            linear(current & 0x3F, 1)
        elif command_class == 0x40:
            pattern_index = (command & 0x30) >> 4
            current = patterns[pattern_index]
            pattern_class = current & 0xC0
            count = (low_five & 0x0F) + 1
            if pattern_class == 0x00:
                # Dictionary slots 1 and 3 are the two vertical writers.  Use
                # the slot identity, not a byte-value comparison: two slots
                # are allowed to contain the same logical type.  This also
                # avoids the obsolete Gauntlet-I header offsets 12/13 when
                # decoding Gauntlet II's shorter 11-byte header.
                writer = vertical if pattern_index in (1, 3) else linear
                writer(current & 0x3F, count)
            elif pattern_class == 0x40:
                linear(0, count)
                linear(current & 0x3F, 1)
            elif pattern_class == 0x80:
                linear(current & 0x3F, 1)
                linear(0, count)
            else:
                linear(game_format.marker_value, count)
                linear(current & 0x3F, 1)
        elif command_class == 0x80:
            if command & 0x20:
                count = (low_five & 0x0F) + 1
                (vertical if command & 0x10 else linear)(game_format.marker_value, count)
            else:
                linear(current & 0x3F, low_five + 1)
        else:
            linear(0, low_five + 1)
            if command & 0x20:
                linear(game_format.marker_value, 1)

    # The decoder reserves row zero. The loader immediately fills it with the
    # game's marker value (Gauntlet: 01, Gauntlet II: 02).
    cells[:32] = [game_format.marker_value] * 32
    return Level(
        record_id=record_id,
        bank=bank,
        pointer=pointer,
        header=source[:game_format.header_size],
        compressed_size=source_position - game_format.header_size,
        cells=tuple(cells),
    )


def token(value: int, game: str = "gauntlet") -> str:
    if value == 0:
        return ".."
    if value == (2 if game == "gaunt2" else 1):
        return "##"
    return f"{value:02X}"


def output_name(record_id: int, game: str = "gauntlet") -> str:
    if game == "gaunt2":
        return f"level-{record_id + 1:03d}.txt"
    if record_id < 114:
        return f"level-{record_id + 1:03d}.txt"
    if record_id < 152:
        return f"demo-{record_id}.txt"
    return f"treasure-room-{record_id - 151:02d}.txt"


def png_name(record_id: int, game: str = "gauntlet") -> str:
    return Path(output_name(record_id, game)).with_suffix(".png").name


def build_program_rom(rom_dir: Path, game: str = "gauntlet") -> bytes:
    """Recreate the main CPU ROM image, including G2's high data tables."""
    game_format = GAME_FORMATS[game]
    even = (rom_dir / game_format.main_even_rom).read_bytes()
    odd = (rom_dir / game_format.main_odd_rom).read_bytes()
    if len(even) != 0x8000 or len(odd) != 0x8000:
        raise ValueError("1307.9a and 1308.9b must each be exactly 0x8000 bytes")
    result = bytearray(0x60000 if game == "gaunt2" else 0x10000)
    result[0x8000:0x10000:2] = even[:0x4000]
    result[0x8001:0x10000:2] = odd[:0x4000]
    result[0x0000:0x8000:2] = even[0x4000:]
    result[0x0001:0x8000:2] = odd[0x4000:]
    if game == "gaunt2":
        def load_pair(address: int, even_name: str, odd_name: str, continued: bool = False) -> None:
            pair_even = (rom_dir / even_name).read_bytes()
            pair_odd = (rom_dir / odd_name).read_bytes()
            if len(pair_even) != len(pair_odd):
                raise ValueError(f"mismatched program ROM pair {even_name}/{odd_name}")
            if continued:
                # MAME loads the first $4000-byte half at address+$8000,
                # then ROM_CONTINUE places the second half at address.
                halves = ((address + 0x8000, slice(0, 0x4000)),
                          (address, slice(0x4000, 0x8000)))
            else:
                halves = ((address, slice(0, len(pair_even))),)
            for destination, source in halves:
                end = destination + len(pair_even[source]) * 2
                result[destination:end:2] = pair_even[source]
                result[destination + 1:end:2] = pair_odd[source]

        load_pair(0x38000, "136043-1105.10a", "136043-1106.10b")
        load_pair(0x40000, "136043-1109.7a", "136043-1110.7b", continued=True)
        load_pair(0x50000, "136043-1121.6a", "136043-1122.6b", continued=True)
    return bytes(result)


def irgb4444(value: int) -> tuple[int, int, int]:
    """Match MAME's standard IRGB decoder, including its 8-bit multiply."""
    intensity = ((value >> 12) & 0x0F) * 17
    return tuple((intensity * (((value >> shift) & 0x0F) * 17)) >> 8 for shift in (8, 4, 0))


def render_png(
    level: Level,
    program: bytes,
    tiles: tuple[bytes, ...],
    palette_dump: bytes,
    output: Path,
    game: str = "gauntlet",
) -> None:
    """Render the static playfield and representative motion-object overlays."""
    expected_tiles = 12288 if game == "gaunt2" else 8192
    if len(tiles) != expected_tiles or any(len(tile) != 64 for tile in tiles):
        raise ValueError(f"tile binary must contain {expected_tiles} unpacked 8x8 tiles")
    if len(palette_dump) != 0x800:
        raise ValueError("palette dump must contain exactly 0x800 bytes")

    if game == "gaunt2":
        palette_ram = bytearray(palette_dump)
        floor_palette = 0x5D5C8 + ((level.header[6] >> 4) & 0x0F) * 0x20
        wall_palette = 0x5D7E8 + (level.header[6] & 0x0F) * 0x20
        palette_ram[2 * (256 + 24 * 16):2 * (256 + 25 * 16)] = program[floor_palette:floor_palette + 0x20]
        palette_ram[2 * (256 + 31 * 16):2 * (256 + 32 * 16)] = program[wall_palette:wall_palette + 0x20]
        if level.record_id == 1:
            # Runtime-verified reference for level 2, including the derived
            # stain and alternate-floor groups 16..30.
            start = 2 * (256 + 16 * 16)
            palette_ram[start:start + len(G2_LEVEL_2_PF_PALETTE)] = G2_LEVEL_2_PF_PALETTE
        palette_dump = bytes(palette_ram)

    # GFX entry zero starts at palette index 256. Build a compact indexed PNG
    # palette by merging duplicate RGB values. This leaves room for every
    # generator colour group used by the current level as well as the eight
    # playfield groups and the diagnostic colours.
    palette: list[tuple[int, int, int]] = []
    palette_lookup: dict[tuple[int, int, int], int] = {}

    def add_colour(rgb: tuple[int, int, int]) -> int:
        if rgb not in palette_lookup:
            if len(palette) == 256:
                raise ValueError("level needs more than 256 distinct PNG colours")
            palette_lookup[rgb] = len(palette)
            palette.append(rgb)
        return palette_lookup[rgb]

    def hardware_group(group: int) -> tuple[int, ...]:
        return tuple(
            add_colour(irgb4444(be16(palette_dump, (256 + group * 16 + pen) * 2)))
            for pen in range(16)
        )

    playfield_colours = []
    playfield_stain_colours = []
    for group in range(24, 32):
        playfield_colours.append(hardware_group(group))
        # Gauntlet's special MO pen 1 clears physical palette bit $80,
        # mapping playfield groups 24..31 to groups 16..23.
        playfield_stain_colours.append(hardware_group(group - 8))
    door_colours = hardware_group(0)
    large_object_groups = [] if game == "gaunt2" else sorted(
        {
            program[0xC660 + cell_type] & 0x0F
            for cell_type in level.cells
            if 0x09 <= cell_type <= 0x17 or 0x19 <= cell_type <= 0x27
        }
    )
    large_object_colours = {group: hardware_group(group) for group in large_object_groups}
    item_colours = hardware_group(1) if game != "gaunt2" and any(0x28 <= cell_type <= 0x35 for cell_type in level.cells) else ()
    g2_object_colours = {
        group: hardware_group(group)
        for group in sorted({fields[3] for fields in G2_STATIC_OBJECTS.values()} | {0})
    } if game == "gaunt2" else {}
    marker_palette = list(DIAGNOSTIC_4BPP)
    marker_palette[0] = (0, 0, 0)

    def add_diagnostic_colour(rgb: tuple[int, int, int]) -> int:
        if rgb in palette_lookup or len(palette) < 256:
            return add_colour(rgb)
        # Preserve exact game palettes when the indexed-PNG limit is reached;
        # only provisional diagnostic markers use the nearest existing RGB.
        return min(
            range(len(palette)),
            key=lambda index: sum((palette[index][channel] - rgb[channel]) ** 2 for channel in range(3)),
        )

    marker_colours = tuple(add_diagnostic_colour(rgb) for rgb in marker_palette)

    width = height = 512
    pixels = bytearray(width * height)
    stained_pixels = bytearray(width * height)

    def cell_at(x: int, y: int) -> int:
        if game == "gaunt2":
            # Gauntlet II copies the decoded 32x32 logical map into the
            # column-major hardware tilemap with both axes negated.  Runtime
            # PF-RAM from level 1 confirms (x,y) -> (-x,-y) modulo 32.
            return level.cells[((-y) & 31) * 32 + ((-x) & 31)]
        return level.cells[(y & 31) * 32 + (x & 31)]

    def solid(x: int, y: int) -> bool:
        if game == "gaunt2":
            return cell_at(x, y) in (0x02, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x3F)
        return cell_at(x, y) in (0x01, 0x36, 0x37, 0x38, 0x39)

    def object_solid(x: int, y: int) -> bool:
        # $426c8 tests for the $8000 object records created by $441f6.
        # Only these three logical types take that representation.
        if game == "gaunt2":
            return solid(x, y)
        return cell_at(x, y) in (0x01, 0x38, 0x39)

    def wall_quartet(x: int, y: int, cell_type: int) -> tuple[int, int, int, int]:
        # $42c9c builds this eight-neighbour mask. $42b92 maps it through
        # $9c24 and chooses one of the wall themes in the $a6c0 table.
        neighbour_mask = 0
        for dx, dy, bit in (
            (-1, -1, 0x01), (0, -1, 0x02), (1, -1, 0x04),
            (-1,  0, 0x08),                    (1,  0, 0x10),
            (-1,  1, 0x20), (0,  1, 0x40), (1,  1, 0x80),
        ):
            if solid(x + dx, y + dy):
                neighbour_mask |= bit

        shape = program[0x9C24 + neighbour_mask]
        if game == "gaunt2":
            # G2 header byte 5: low nibble selects the wall tile family.
            wall_theme = level.header[5] & 0x0F
        else:
            wall_theme = 5 if cell_type in (0x36, 0x37, 0x38) else level.header[8] & 0x0F
        address = 0xA6C0 + (wall_theme * 0x44 + shape - 1) * 8
        if game == "gaunt2":
            addend = 0x7000
        elif cell_type == 0x01:
            addend = 0x1000
        elif cell_type == 0x39:
            addend = 0x4000
        else:
            addend = 0x5000 + (cell_type - 0x36) * 0x1000
        return tuple((be16(program, address + index * 2) + addend) & 0xFFFF for index in range(4))

    def quartet(x: int, y: int, cell_type: int) -> tuple[int, int, int, int]:
        wall_types = (0x02, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09) if game == "gaunt2" else (0x01, 0x36, 0x37, 0x38, 0x39)
        if cell_type in wall_types:
            return wall_quartet(x, y, cell_type)
        if game == "gaunt2" and cell_type == 0x3F:
            # Red wall inserts seen in the live level-2 PF RAM.  The game
            # cycles three cosmetic frames; a coordinate hash freezes one.
            variants = (
                (0x44A9, 0x44A3, 0x44AC, 0x44AD),
                (0x44A6, 0x44A7, 0x44A8, 0x44A5),
                (0x44A6, 0x44A7, 0x44AC, 0x44AD),
            )
            return variants[(x * 17 + y * 31 + level.record_id) % len(variants)]
        if game == "gaunt2" and cell_type in (0x10, 0x11):
            # G2's exit types are playfield graphics, not Motion Objects.
            # Level-1 PF RAM confirms $10 (EXIT) and $11 (EXIT TO 6);
            exit_quartets = (
                (0x039E, 0x039F, 0x0006, 0x0006),
                (0x039E, 0x039F, 0x03A0, 0x03A1),
            )
            return exit_quartets[cell_type - 0x10]
        if cell_type in (6, 7, 8):
            address = 0xB380 + (cell_type - 6) * 8
            return tuple((be16(program, address + index * 2) + 0x2000) & 0xFFFF for index in range(4))
        if cell_type == 0x3B:
            return tuple((be16(program, 0xB398 + index * 2) + 0x2000) & 0xFFFF for index in range(4))

        # The game chooses one of four cosmetic variants with its PRNG. A
        # coordinate hash makes that choice deterministic for reproducible PNGs.
        table_index = ((x * 17 + y * 31 + level.record_id * 13) & 3) * 4
        if solid(x - 1, y):
            table_index += 0x10
        if solid(x - 1, y + 1):
            table_index += 0x20
        if solid(x, y + 1):
            table_index += 0x40
        address = 0xA5C0 + table_index * 2
        floor_theme = level.header[5] >> 4 if game == "gaunt2" else level.header[8] >> 4
        addend = floor_theme * 0x30 + (0x3000 if cell_type == 0x3A else 0)
        if game == "gaunt2" and cell_type == 0x01:
            addend += 0x2000
        return tuple((be16(program, address + index * 2) + addend) & 0xFFFF for index in range(4))

    def draw_tile(tile_word: int, destination_x: int, destination_y: int) -> None:
        code = ((tile_word & 0x0FFF) ^ 0x0800) % len(tiles)
        tile = tiles[code]
        colours = playfield_colours[(tile_word >> 12) & 7]
        flip_x = bool(tile_word & 0x8000)
        for py in range(8):
            start = (destination_y + py) * width + destination_x
            row = tile[py * 8 : py * 8 + 8]
            if flip_x:
                row = row[::-1]
            pixels[start : start + 8] = bytes(colours[pen] for pen in row)
            stain_colours = playfield_stain_colours[(tile_word >> 12) & 7]
            stained_pixels[start : start + 8] = bytes(stain_colours[pen] for pen in row)

    def draw_marker(cell_type: int, destination_x: int, destination_y: int) -> None:
        # $c534 is the initial MO-code table used by $441f6. It is a useful
        # static representative, but not a replacement for runtime animation.
        code_word = be16(program, 0xC534 + cell_type * 2)
        code = ((code_word & 0x7FFF) ^ 0x0800) % len(tiles)
        tile = tiles[code]
        for py in range(8):
            for px in range(8):
                pen = tile[py * 8 + px]
                if pen:
                    pixels[(destination_y + py) * width + destination_x + px] = marker_colours[pen]

    def draw_motion_object(
        code_word: int,
        tile_width: int,
        tile_height: int,
        destination_x: int,
        destination_y: int,
        colours: tuple[int, ...],
    ) -> None:
        code = (code_word & 0x7FFF) ^ 0x0800
        for tile_y in range(tile_height):
            for tile_x in range(tile_width):
                tile = tiles[(code + tile_y * tile_width + tile_x) % len(tiles)]
                for py in range(8):
                    for px in range(8):
                        pen = tile[py * 8 + px]
                        output_x = (destination_x + tile_x * 8 + px) % width
                        output_y = (destination_y + tile_y * 8 + py) % height
                        output_offset = output_y * width + output_x
                        if pen == 1:
                            # Verified in the Gauntlet schematics and mirrored
                            # by MAME: MO pen 1 clears PF colour bit $80.
                            pixels[output_offset] = stained_pixels[output_offset]
                        elif pen:
                            pixels[output_offset] = colours[pen]

    def door_shape(x: int, y: int, horizontal: bool) -> int:
        # Exact connectivity calculation from $43f0c/$44080. The resulting
        # value selects one of nine closed-door shapes in the ROM tables.
        along_x, along_y = ((1, 0) if horizontal else (0, 1))
        across_x, across_y = ((0, 1) if horizontal else (1, 0))
        shape = 0
        if not object_solid(x - along_x, y - along_y):
            shape = 6
        elif (
            object_solid(x - 2 * along_x, y - 2 * along_y)
            and not object_solid(x - along_x - across_x, y - along_y - across_y)
            and not object_solid(x - along_x + across_x, y - along_y + across_y)
        ):
            shape = 3

        if not object_solid(x + along_x, y + along_y):
            shape += 2
        elif (
            object_solid(x + 2 * along_x, y + 2 * along_y)
            and not object_solid(x + along_x + across_x, y + along_y + across_y)
            and not object_solid(x + along_x - across_x, y + along_y - across_y)
        ):
            shape += 1
        return shape

    def draw_door(cell_type: int, x: int, y: int) -> None:
        horizontal = cell_type == 3
        shape = door_shape(x, y, horizontal)
        code_table = 0xA040 if horizontal else 0xA076
        offset_table = 0xA052 if horizontal else 0xA088
        attribute_table = 0xA064 if horizontal else 0xA09A
        code_word = be16(program, code_table + shape * 2)
        offset = be16(program, offset_table + shape * 2) // 0x80
        attributes = be16(program, attribute_table + shape * 2)
        tile_width = ((attributes >> 3) & 7) + 1
        tile_height = (attributes & 7) + 1
        destination_x = x * 16 - (offset if horizontal else 0)
        # The hardware stores an inverted bottom coordinate.  MAME converts
        # it back and subtracts the complete object height, so 24/32-pixel
        # vertical shapes overhang the preceding 16-pixel map cell.
        destination_y = (
            y * 16
            if horizontal
            else (y + 1) * 16 - tile_height * 8 + offset
        )
        draw_motion_object(
            code_word, tile_width, tile_height, destination_x, destination_y, door_colours
        )

    def draw_large_object(cell_type: int, x: int, y: int) -> None:
        # The generic object loader at $441f6 takes these fields directly from
        # $c534/$c5ac/$c624/$c660. Generators are 2x3 or 3x3 tiles and
        # deliberately overhang their 16x16 map cell.
        code_word = be16(program, 0xC534 + cell_type * 2)
        x_offset = be16(program, 0xC5AC + cell_type * 2) // 0x80
        attributes = program[0xC624 + cell_type]
        colour_group = program[0xC660 + cell_type] & 0x0F
        tile_width = ((attributes >> 3) & 7) + 1
        tile_height = (attributes & 7) + 1
        destination_x = x * 16 - x_offset
        destination_y = (y + 1) * 16 - tile_height * 8
        draw_motion_object(
            code_word,
            tile_width,
            tile_height,
            destination_x,
            destination_y,
            large_object_colours[colour_group],
        )

    def draw_item(cell_type: int, x: int, y: int) -> None:
        # $441f6 uses the same four object tables for treasure, potions and
        # keys. Type $2b is the exception: it picks one of three food images
        # from $cbe2. A coordinate hash makes that ROM choice reproducible.
        if cell_type == 0x2B:
            variant = (x * 17 + y * 31 + level.record_id * 13) % 3
            code_word = be16(program, 0xCBE2 + variant * 2)
        else:
            code_word = be16(program, 0xC534 + cell_type * 2)
        x_offset = be16(program, 0xC5AC + cell_type * 2) // 0x80
        attributes = program[0xC624 + cell_type]
        tile_width = ((attributes >> 3) & 7) + 1
        tile_height = (attributes & 7) + 1
        destination_x = x * 16 - x_offset
        destination_y = (y + 1) * 16 - tile_height * 8
        draw_motion_object(
            code_word,
            tile_width,
            tile_height,
            destination_x,
            destination_y,
            item_colours,
        )

    def draw_g2_object(cell_type: int, x: int, y: int) -> None:
        code_word, tile_width, tile_height, colour_group, x_offset, _ = G2_STATIC_OBJECTS[cell_type]
        if cell_type == 0x14 and (
            cell_at(x, y - 1) == cell_type or cell_at(x, y + 1) == cell_type
        ):
            # $183f is the dormant loader image.  Once a vertical dragon is
            # in the viewport, G2 changes every segment to the active $1990
            # frame.  This was verified directly in level-6 MO RAM.
            code_word = 0x1990
        draw_motion_object(
            code_word,
            tile_width,
            tile_height,
            x * 16 - x_offset,
            (y + 1) * 16 - tile_height * 8,
            g2_object_colours[colour_group],
        )

    def draw_g2_door(cell_type: int, x: int, y: int) -> None:
        if cell_type == 0x0D:
            before = cell_at(x - 1, y) == cell_type
            after = cell_at(x + 1, y) == cell_type
            if not before:
                code_word, tile_width, x_offset = 0x9D42, 3, 5
            elif not after:
                code_word, tile_width, x_offset = 0x9D52, 4, 4
            else:
                code_word, tile_width, x_offset = 0x9D48, 2, 0
            draw_motion_object(
                code_word, tile_width, 2, x * 16 - x_offset, y * 16,
                g2_object_colours[0],
            )
        else:
            before = cell_at(x, y - 1) == cell_type
            after = cell_at(x, y + 1) == cell_type
            code_word = 0x9D8C if not before else (0x9D82 if not after else 0x9D94)
            tile_height = 4 if not before else 2
            draw_motion_object(
                code_word, 2, tile_height, x * 16,
                (y + 1) * 16 - tile_height * 8, g2_object_colours[0],
            )

    for y in range(32):
        for x in range(32):
            cell_type = cell_at(x, y)
            tile_words = quartet(x, y, cell_type)
            for sub_y, sub_x, index in ((0, 0, 0), (0, 1, 1), (1, 0, 2), (1, 1, 3)):
                draw_tile(tile_words[index], x * 16 + sub_x * 8, y * 16 + sub_y * 8)

    # Motion Objects form a separate hardware layer. Draw them only after the
    # complete playfield so neighbouring cells cannot erase their overhang.
    for y in range(32):
        for x in range(32):
            cell_type = cell_at(x, y)
            # Types 03/04 are unlockable horizontal/vertical walls assembled
            # from multi-tile Motion Objects. Types 09..17 are generators,
            # 19..27 are the monster/bone entities, and 28..35 collectible
            # items. Other types retain the diagnostic overlay.
            if game == "gaunt2":
                if cell_type in (0x0D, 0x0E):
                    draw_g2_door(cell_type, x, y)
                elif cell_type in G2_STATIC_OBJECTS:
                    draw_g2_object(cell_type, x, y)
                # Other G2 values are runtime enemy/spawn/control markers;
                # leave the lossless type number to the ASCII map rather than
                # drawing a misleading Gauntlet-I object.
            elif cell_type in (3, 4):
                draw_door(cell_type, x, y)
            elif 0x09 <= cell_type <= 0x17:
                draw_large_object(cell_type, x, y)
            elif 0x19 <= cell_type <= 0x27:
                draw_large_object(cell_type, x, y)
            elif 0x28 <= cell_type <= 0x35:
                draw_item(cell_type, x, y)
            elif cell_type not in (0, 1, 6, 7, 8, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B):
                draw_marker(cell_type, x * 16 + 4, y * 16 + 4)

    png(output, width, height, bytes(pixels), palette)


def level_kind(record_id: int, game: str = "gauntlet") -> str:
    if game == "gaunt2":
        return f"level record {record_id + 1:03d}"
    if record_id < 114:
        return f"normal level {record_id + 1:03d}"
    if record_id < 152:
        return f"demo/attract map {record_id}"
    return f"treasure room {record_id - 151:02d}"


def render(level: Level, game: str = "gauntlet") -> str:
    used = sorted(set(level.cells))
    lines = [
        f"ATARI {'GAUNTLET II' if game == 'gaunt2' else 'GAUNTLET'} ASCII LEVEL MAP",
        f"KIND: {level_kind(level.record_id, game)}",
        f"ROM_RECORD_ID: {level.record_id}",
        f"SLAPSTIC_BANK: {level.bank}",
        f"CPU_POINTER: 0x{level.pointer:06X}",
        f"HEADER_00_0D: {level.header.hex(' ').upper()}",
        f"COMPRESSED_BYTES: {level.compressed_size}",
        "GRID: 32 x 32 logical metatiles; one metatile is 16 x 16 pixels",
        "CELL: two ASCII characters",
        "",
        "LEGEND",
        "  .. = type 00: empty/floor",
        f"  ## = type {2 if game == 'gaunt2' else 1:02X}: solid wall or loader-created top border",
    ]
    for value in used:
        if value not in (0, 2 if game == "gaunt2" else 1):
            if value == 5:
                description = "loader marker (not retained in the final type grid)"
            elif game == "gaunt2":
                description = G2_TYPE_DESCRIPTIONS.get(value, "Gauntlet II runtime/control type")
            else:
                description = TYPE_DESCRIPTIONS.get(value, "game terrain/object type")
            lines.append(f"  {value:02X} = type {value:02X}: {description}")
    lines.extend(
        [
            "",
            "MAP",
            "     0001020304050607080910111213141516171819202122232425262728293031",
        ]
    )
    for y in range(32):
        row = "".join(token(value, game) for value in level.cells[y * 32 : (y + 1) * 32])
        lines.append(f"{y:02d} | {row}")
    lines.extend(
        [
            "",
            "NOTES",
            "  The map is the deterministic output of the ROM decoder plus its top border.",
            "  Runtime object setup can replace markers and open individual border cells.",
            "  Unknown type names remain numeric so this file does not invent semantics.",
            "",
        ]
    )
    result = "\n".join(lines)
    result.encode("ascii")
    return result


def render_index(levels: list[Level], game: str = "gauntlet") -> str:
    counts = Counter(
        "normal" if game == "gaunt2" or level.record_id < 114
        else "demo" if level.record_id < 152 else "treasure"
        for level in levels
    )
    lines = [
        f"ATARI {'GAUNTLET II' if game == 'gaunt2' else 'GAUNTLET'} LEVEL INDEX",
        "",
        f"TOTAL: {len(levels)}",
        f"NORMAL: {counts['normal']}",
        f"DEMO_ATTRACT: {counts['demo']}",
        f"TREASURE_ROOMS: {counts['treasure']}",
        "",
        "FILE                         ID   BANK  POINTER   PACKED  HEADER_00_0D",
    ]
    for level in levels:
        lines.append(
            f"{output_name(level.record_id, game):<28} {level.record_id:3d}  "
            f"{level.bank:4d}  {level.pointer:06X}  {level.compressed_size:6d}  "
            f"{level.header.hex().upper()}"
        )
    lines.append("")
    if game == "gaunt2":
        lines.append("ROM records 0..116 are the 117 non-null entries in the protected directory.")
    else:
        lines.extend([
            "Normal files map ROM IDs 0..113 to level numbers 001..114.",
            "ROM IDs 150..151 are demo/attract maps.",
            "ROM IDs 152..162 are the eleven treasure rooms.",
            "ROM IDs 114..149 contain no level pointers in this revision.",
        ])
    lines.extend([
        "Each listed TXT file has a same-named 512x512 PNG when PNG output is enabled.",
        "",
    ])
    result = "\n".join(lines)
    result.encode("ascii")
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--game", choices=GAME_FORMATS, default="gauntlet")
    parser.add_argument("--rom-dir", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--tiles", type=Path, help="unpacked 8192 x 64-byte tile binary")
    parser.add_argument("--palette-dump", type=Path, help="0x800-byte Atari palette RAM dump")
    args = parser.parse_args()
    if bool(args.tiles) != bool(args.palette_dump):
        parser.error("--tiles and --palette-dump must be supplied together")

    game_format = GAME_FORMATS[args.game]
    protected_rom = interleave(
        (args.rom_dir / game_format.even_rom).read_bytes(),
        (args.rom_dir / game_format.odd_rom).read_bytes(),
    )
    levels = [decode_level(record_id, protected_rom, game_format) for record_id in game_format.all_ids]

    args.output.mkdir(parents=True, exist_ok=True)
    expected = {output_name(level.record_id, args.game) for level in levels} | {"index.txt"}
    if args.tiles:
        expected |= {png_name(level.record_id, args.game) for level in levels}
    for stale in args.output.iterdir():
        if stale.suffix not in (".txt", ".png"):
            continue
        if stale.name not in expected:
            stale.unlink()
    for level in levels:
        (args.output / output_name(level.record_id, args.game)).write_text(
            render(level, args.game), encoding="ascii", newline="\n"
        )
    if args.tiles:
        raw_tiles = args.tiles.read_bytes()
        expected_tile_bytes = (12288 if args.game == "gaunt2" else 8192) * 64
        if len(raw_tiles) != expected_tile_bytes:
            raise ValueError(
                f"tile binary must contain {expected_tile_bytes:#x} bytes, got {len(raw_tiles):#x}"
            )
        tiles = tuple(raw_tiles[offset : offset + 64] for offset in range(0, len(raw_tiles), 64))
        palette_dump = args.palette_dump.read_bytes()
        program = build_program_rom(args.rom_dir, args.game)
        for level in levels:
            render_png(
                level, program, tiles, palette_dump,
                args.output / png_name(level.record_id, args.game), args.game
            )
    (args.output / "index.txt").write_text(render_index(levels, args.game), encoding="ascii", newline="\n")
    print(
        f"Extracted {len(game_format.normal_ids)} normal levels, {len(game_format.demo_ids)} demo maps and "
        f"{len(game_format.treasure_ids)} treasure rooms as ASCII"
        f"{' and PNG' if args.tiles else ''} to {args.output}"
    )


if __name__ == "__main__":
    main()
