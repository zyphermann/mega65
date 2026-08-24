#!/usr/bin/env python3
"""Build a self-contained Neo-Geo MVS title-screen demo cartridge."""

from __future__ import annotations

import argparse
import binascii
import csv
import hashlib
import json
import struct
import zipfile
from pathlib import Path


P1_SIZE = 0x100000
S1_SIZE = 0x020000
M1_SIZE = 0x020000
V1_SIZE = 0x080000
CROM_SIZE = 0x080000
SYSTEM_CROM_TILES = 256
NGH = 0x7777

BIOS_INIT_HARDWARE = 0xC00402
BIOS_EXC_BUS_ERROR = 0xC00408
BIOS_EXC_ADDR_ERROR = 0xC0040E
BIOS_EXC_ILLEGAL_OP = 0xC00414
BIOS_EXC_INVALID_OP = 0xC0041A
BIOS_EXC_TRACE = 0xC00420
BIOS_EXC_FPU_EMU = 0xC00426
BIOS_UNINITIALIZED_INT = 0xC0042C
BIOS_SPURIOUS_INT = 0xC00432
SYSTEM_INT1 = 0xC00438
SYSTEM_INT2 = 0xC0043E
SYSTEM_RETURN = 0xC00444

REG_WATCHDOG = 0x300001
REG_VRAMADDR = 0x3C0000
REG_VRAMRW = 0x3C0002
REG_VRAMMOD = 0x3C0004
REG_IRQACK = 0x3C000C
REG_NOSHADOW = 0x3A0001
REG_CRTFIX = 0x3A001B
REG_PALBANK0 = 0x3A001F
BIOS_USER_REQUEST = 0x10FDAE
BIOS_SYSTEM_MODE = 0x10FD80
PALETTE_RAM = 0x400000
ANIMATION_COUNTER = 0x100000
ANIMATION_PHASE = 0x100001
ANIMATION_POINTER = 0x100002
ANIMATION_DELAY = 3


class M68KBuilder:
    """Very small emitter for the fixed 68000 subset used by this demo."""

    def __init__(self, origin: int):
        self.origin = origin
        self.data = bytearray()
        self.labels: dict[str, int] = {}
        self.absolute_fixups: list[tuple[int, str]] = []
        self.relative_fixups: list[tuple[int, str]] = []

    @property
    def pc(self) -> int:
        return self.origin + len(self.data)

    def label(self, name: str) -> None:
        if name in self.labels:
            raise ValueError(f"duplicate label {name}")
        self.labels[name] = self.pc

    def bytes(self, value: bytes) -> None:
        self.data.extend(value)

    def word(self, value: int) -> None:
        self.data.extend(struct.pack(">H", value & 0xFFFF))

    def long(self, value: int) -> None:
        self.data.extend(struct.pack(">I", value & 0xFFFFFFFF))

    def absolute_label(self, name: str) -> None:
        self.absolute_fixups.append((len(self.data), name))
        self.long(0)

    def branch(self, opcode: int, name: str) -> None:
        self.word(opcode)
        self.relative_fixups.append((len(self.data), name))
        self.word(0)

    def resolve(self) -> bytes:
        for offset, name in self.absolute_fixups:
            self.data[offset:offset + 4] = struct.pack(">I", self.labels[name])
        for offset, name in self.relative_fixups:
            # On 68000, word-sized Bcc/DBRA displacements are relative to the
            # address of the extension word itself, not the following word.
            displacement = self.labels[name] - (self.origin + offset)
            if not -32768 <= displacement <= 32767:
                raise ValueError(f"branch to {name} is out of range")
            self.data[offset:offset + 2] = struct.pack(">h", displacement)
        return bytes(self.data)

    def jmp_abs(self, address: int) -> None:
        self.word(0x4EF9)
        self.long(address)

    def jmp_label(self, name: str) -> None:
        self.word(0x4EF9)
        self.absolute_label(name)

    def lea_abs(self, address: int, areg: int) -> None:
        self.word(0x41F9 | (areg << 9))
        self.long(address)

    def lea_label(self, name: str, areg: int) -> None:
        self.word(0x41F9 | (areg << 9))
        self.absolute_label(name)

    def move_w_imm_sr(self, value: int) -> None:
        self.word(0x46FC)
        self.word(value)

    def move_w_imm_abs(self, value: int, address: int) -> None:
        self.word(0x33FC)
        self.word(value)
        self.long(address)

    def move_b_imm_abs(self, value: int, address: int) -> None:
        self.word(0x13FC)
        self.word(value & 0xFF)
        self.long(address)

    def move_b_dn_abs(self, dn: int, address: int) -> None:
        self.word(0x13C0 | dn)
        self.long(address)

    def move_b_abs_dn(self, address: int, dn: int) -> None:
        self.word(0x1039 | (dn << 9))
        self.long(address)

    def move_w_dn_abs(self, dn: int, address: int) -> None:
        self.word(0x33C0 | dn)
        self.long(address)

    def move_w_imm_dn(self, value: int, dn: int) -> None:
        self.word(0x303C | (dn << 9))
        self.word(value)

    def moveq(self, value: int, dn: int) -> None:
        if not -128 <= value <= 127:
            raise ValueError("MOVEQ value out of range")
        self.word(0x7000 | (dn << 9) | (value & 0xFF))

    def cmpi_b(self, value: int, dn: int) -> None:
        self.word(0x0C00 | dn)
        self.word(value & 0xFF)

    def btst_imm_abs(self, bit: int, address: int) -> None:
        self.word(0x0839)
        self.word(bit)
        self.long(address)

    def addq_b(self, value: int, dn: int) -> None:
        if not 1 <= value <= 8:
            raise ValueError("ADDQ value must be 1..8")
        encoded = 0 if value == 8 else value
        self.word(0x5000 | (encoded << 9) | dn)

    def clr_b_abs(self, address: int) -> None:
        self.word(0x4239)
        self.long(address)

    def movea_l_apost(self, source_areg: int, target_areg: int) -> None:
        self.word(0x2040 | (target_areg << 9) | 0x18 | source_areg)

    def movea_l_abs(self, address: int, target_areg: int) -> None:
        self.word(0x2079 | (target_areg << 9))
        self.long(address)

    def move_w_apost_aind(self, source_areg: int, target_areg: int) -> None:
        self.word(0x3000 | (target_areg << 9) | (2 << 6) | 0x18 | source_areg)

    def move_l_areg_abs(self, areg: int, address: int) -> None:
        self.word(0x23C8 | areg)
        self.long(address)

    def move_w_a0post_a1post(self) -> None:
        self.word(0x32D8)

    def move_w_apost_abs(self, areg: int, address: int) -> None:
        self.word(0x33D8 | areg)
        self.long(address)

    def addi_w(self, value: int, dn: int) -> None:
        self.word(0x0640 | dn)
        self.word(value)

    def dbra(self, dn: int, name: str) -> None:
        self.word(0x51C8 | dn)
        self.relative_fixups.append((len(self.data), name))
        self.word(0)

    def rts(self) -> None:
        self.word(0x4E75)

    def rte(self) -> None:
        self.word(0x4E73)


SCODE = (
    0x7600, 0x4A6D, 0x0A14, 0x6600, 0x003C, 0x206D, 0x0A04, 0x3E2D,
    0x0A08, 0x13C0, 0x0030, 0x0001, 0x3210, 0x0C01, 0x00FF, 0x671A,
    0x3028, 0x0002, 0xB02D, 0x0ACE, 0x6610, 0x3028, 0x0004, 0xB02D,
    0x0ACF, 0x6606, 0xB22D, 0x0AD0, 0x6708, 0x5088, 0x51CF, 0xFFD4,
    0x3607, 0x4E75, 0x206D, 0x0A04, 0x3E2D, 0x0A08, 0x3210, 0xE049,
    0x0C01, 0x00FF, 0x671A, 0x3010, 0xB02D, 0x0ACE, 0x6612, 0x3028,
    0x0002, 0xE048, 0xB02D, 0x0ACF, 0x6606, 0xB22D, 0x0AD0, 0x6708,
    0x5888, 0x51CF, 0xFFD8, 0x3607, 0x4E75,
)


def read_animation(
    palette: bytes, animation_palettes_csv: Path
) -> tuple[bytes, list[tuple[int, int]], list[list[int]], list[int]]:
    rows_by_phase: dict[int, list[dict[str, str]]] = {}
    with animation_palettes_csv.open(newline="") as stream:
        for row in csv.DictReader(stream):
            rows_by_phase.setdefault(int(row["phase"]), []).append(row)
    phases = sorted(rows_by_phase)
    if phases != list(range(len(phases))):
        raise ValueError("animation phases must be contiguous and start at zero")
    if not phases or not rows_by_phase[0]:
        raise ValueError("animation palette contains no entries")

    def identity(row: dict[str, str]) -> tuple[int, int, int, int]:
        return (
            int(row["palette"]), int(row["pen"]),
            int(row["source_index"]), int(row["track"]),
        )

    reference = [identity(row) for row in rows_by_phase[0]]
    for phase in phases:
        if [identity(row) for row in rows_by_phase[phase]] != reference:
            raise ValueError(f"animation palette order differs in phase {phase}")

    occurrences = [
        (palette_number * 16 + pen, track)
        for palette_number, pen, _, track in reference
    ]
    frames = [
        [int(row["neo_word"], 16) for row in rows_by_phase[phase]]
        for phase in phases
    ]
    patched = bytearray(palette)
    for (word_index, _), word in zip(occurrences, frames[0], strict=True):
        struct.pack_into(">H", patched, word_index * 2, word)
    tracks = sorted({track for _, track in occurrences})
    return bytes(patched), occurrences, frames, tracks


def build_code(
    palette: bytes,
    tilemap: bytes,
    occurrences: list[tuple[int, int]],
    animation_frames: list[list[int]],
) -> tuple[bytes, dict[str, int]]:
    if len(palette) != 0x2000:
        raise ValueError("palette image must be exactly 8192 bytes")
    if len(tilemap) != 20 * 14 * 4:
        raise ValueError("title tilemap must contain 20 x 14 four-byte entries")

    adjusted = bytearray()
    for offset in range(0, len(tilemap), 4):
        tile, attributes = struct.unpack_from(">HH", tilemap, offset)
        adjusted.extend(struct.pack(">HH", tile + SYSTEM_CROM_TILES, attributes))

    code = M68KBuilder(0x200)
    code.label("vblank")
    code.btst_imm_abs(7, BIOS_SYSTEM_MODE)
    code.branch(0x6600, "runtime_vblank")  # BNE.W
    code.jmp_abs(SYSTEM_INT1)

    code.label("runtime_vblank")
    code.move_w_imm_abs(4, REG_IRQACK)
    code.move_b_dn_abs(0, REG_WATCHDOG)
    code.move_b_abs_dn(ANIMATION_COUNTER, 0)
    code.addq_b(1, 0)
    code.cmpi_b(ANIMATION_DELAY, 0)
    code.branch(0x6600, "store_animation_counter")
    code.clr_b_abs(ANIMATION_COUNTER)

    # Each record is (absolute palette address, colour word).  Keeping the
    # addresses in the ROM makes the IRQ routine independent of the many
    # tile-local palettes created by the 16-colour conversion.
    code.movea_l_abs(ANIMATION_POINTER, 0)
    code.move_w_imm_dn(len(occurrences) - 1, 0)
    code.label("animation_write")
    code.movea_l_apost(0, 1)
    code.move_w_apost_aind(0, 1)
    code.dbra(0, "animation_write")
    code.move_l_areg_abs(0, ANIMATION_POINTER)

    code.move_b_abs_dn(ANIMATION_PHASE, 0)
    code.addq_b(1, 0)
    code.cmpi_b(len(animation_frames), 0)
    code.branch(0x6600, "store_animation_phase")
    code.moveq(0, 0)
    code.lea_label("animation_phase_0", 0)
    code.move_l_areg_abs(0, ANIMATION_POINTER)
    code.label("store_animation_phase")
    code.move_b_dn_abs(0, ANIMATION_PHASE)
    code.rte()

    code.label("store_animation_counter")
    code.move_b_dn_abs(0, ANIMATION_COUNTER)
    code.rte()
    code.label("timer")
    code.jmp_abs(SYSTEM_INT2)

    code.label("user")
    code.move_b_dn_abs(0, REG_WATCHDOG)
    code.move_b_abs_dn(BIOS_USER_REQUEST, 0)
    code.cmpi_b(2, 0)
    code.branch(0x6700, "display")       # BEQ.W
    code.cmpi_b(3, 0)
    code.branch(0x6700, "display")
    code.jmp_abs(SYSTEM_RETURN)

    code.label("player_start")
    code.rts()
    code.label("demo_end")
    code.rts()
    code.label("coin_sound")
    code.rts()

    code.label("display")
    code.move_w_imm_sr(0x2700)
    code.move_w_imm_abs(7, REG_IRQACK)
    code.move_b_dn_abs(0, REG_WATCHDOG)
    code.move_b_dn_abs(0, REG_PALBANK0)
    code.move_b_dn_abs(0, REG_NOSHADOW)
    code.move_b_dn_abs(0, REG_CRTFIX)

    code.lea_label("palette", 0)
    code.lea_abs(PALETTE_RAM, 1)
    code.move_w_imm_dn(4095, 0)
    code.label("palette_loop")
    code.move_w_a0post_a1post()
    code.dbra(0, "palette_loop")

    # Hide all 381 line sprites before replacing slots 0..19.
    code.move_w_imm_abs(1, REG_VRAMMOD)
    code.move_w_imm_abs(0x8200, REG_VRAMADDR)
    code.move_w_imm_dn(380, 0)
    code.label("clear_sprites")
    code.move_w_imm_abs(0, REG_VRAMRW)
    code.dbra(0, "clear_sprites")

    # SCB1: twenty columns, each with fourteen tile/attribute pairs.
    code.lea_label("tilemap", 0)
    code.moveq(0, 1)
    code.moveq(19, 2)
    code.label("column_loop")
    code.move_w_dn_abs(1, REG_VRAMADDR)
    code.moveq(27, 0)
    code.label("column_word_loop")
    code.move_w_apost_abs(0, REG_VRAMRW)
    code.dbra(0, "column_word_loop")
    code.addi_w(64, 1)
    code.dbra(2, "column_loop")

    # SCB2/3/4 tables: full zoom, 14 active tiles, X=0..304.
    code.lea_label("sprite_controls", 0)
    for address, loop_name in (
        (0x8000, "zoom_loop"),
        (0x8200, "height_loop"),
        (0x8400, "x_loop"),
    ):
        code.move_w_imm_abs(address, REG_VRAMADDR)
        code.moveq(19, 0)
        code.label(loop_name)
        code.move_w_apost_abs(0, REG_VRAMRW)
        code.dbra(0, loop_name)

    code.clr_b_abs(ANIMATION_COUNTER)
    code.move_b_imm_abs(1, ANIMATION_PHASE)
    code.lea_label("animation_phase_1", 0)
    code.move_l_areg_abs(0, ANIMATION_POINTER)
    code.move_w_imm_abs(7, REG_IRQACK)
    code.move_w_imm_sr(0x2000)

    code.label("idle")
    code.move_b_dn_abs(0, REG_WATCHDOG)
    code.branch(0x6000, "idle")           # BRA.W

    if code.pc & 1:
        code.bytes(b"\0")
    code.label("dip")
    code.bytes(b"GAUNTLET TITLE".ljust(16, b" "))
    code.bytes(bytes((0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF)))
    code.bytes(bytes(10))

    code.label("sprite_controls")
    for value in [0x0FFF] * 20 + [14] * 20 + [(x * 16) << 7 for x in range(20)]:
        code.word(value)
    code.label("palette")
    code.bytes(palette)
    code.label("tilemap")
    code.bytes(adjusted)
    code.label("animation_frames")
    for phase, colours in enumerate(animation_frames):
        code.label(f"animation_phase_{phase}")
        for (word_index, _), colour in zip(occurrences, colours, strict=True):
            code.long(PALETTE_RAM + word_index * 2)
            code.word(colour)
    return code.resolve(), code.labels


def build_cpu_image(code: bytes, labels: dict[str, int]) -> bytes:
    vectors = [
        0x10F300, BIOS_INIT_HARDWARE,
        BIOS_EXC_BUS_ERROR, BIOS_EXC_ADDR_ERROR, BIOS_EXC_ILLEGAL_OP,
        BIOS_EXC_INVALID_OP, BIOS_EXC_INVALID_OP, BIOS_EXC_INVALID_OP,
        BIOS_EXC_INVALID_OP, BIOS_EXC_TRACE, BIOS_EXC_FPU_EMU, BIOS_EXC_FPU_EMU,
        *([0xFFFFFFFF] * 3), BIOS_UNINITIALIZED_INT,
        *([0xFFFFFFFF] * 8), BIOS_SPURIOUS_INT, labels["vblank"], labels["timer"],
        0, *([0] * 4), *([0xFFFFFFFF] * 32),
    ]
    if len(vectors) != 64:
        raise AssertionError(f"expected 64 exception vectors, got {len(vectors)}")

    image = bytearray(b"\xFF" * P1_SIZE)
    image[:0x100] = b"".join(struct.pack(">I", value) for value in vectors)
    header = bytearray(b"NEO-GEO\0")
    header.extend(struct.pack(">HIIHBB", NGH, P1_SIZE, 0x100000, 0, 0, 0))
    header.extend(struct.pack(">III", labels["dip"], labels["dip"], labels["dip"]))
    for label in ("user", "player_start", "demo_end", "coin_sound"):
        header.extend(struct.pack(">HI", 0x4EF9, labels[label]))
    header.extend(b"\xFF" * 70)
    header.extend(struct.pack(">H", 0))
    scode_address = 0x186
    header.extend(struct.pack(">I", scode_address))
    header.extend(b"".join(struct.pack(">H", word) for word in SCODE))
    if len(header) != 0x100:
        raise AssertionError(f"Neo-Geo header must be 256 bytes, got {len(header)}")
    image[0x100:0x200] = header
    image[0x200:0x200 + len(code)] = code
    return bytes(image)


def wordswap(data: bytes) -> bytes:
    if len(data) & 1:
        raise ValueError("word-swapped data must have even size")
    swapped = bytearray(len(data))
    swapped[0::2] = data[1::2]
    swapped[1::2] = data[0::2]
    return bytes(swapped)


def read_ihex(path: Path, size: int) -> bytes:
    output = bytearray(size)
    upper = 0
    saw_eof = False
    for line_number, raw in enumerate(path.read_text().splitlines(), 1):
        if not raw.startswith(":"):
            raise ValueError(f"{path}:{line_number}: invalid Intel HEX line")
        record = bytes.fromhex(raw[1:])
        if sum(record) & 0xFF:
            raise ValueError(f"{path}:{line_number}: Intel HEX checksum mismatch")
        count = record[0]
        address = int.from_bytes(record[1:3], "big")
        kind = record[3]
        payload = record[4:4 + count]
        if len(payload) != count:
            raise ValueError(f"{path}:{line_number}: truncated Intel HEX record")
        if kind == 0:
            start = upper + address
            if start + count > size:
                raise ValueError(f"{path}:{line_number}: data exceeds M1 ROM")
            output[start:start + count] = payload
        elif kind == 1:
            saw_eof = True
        elif kind == 4:
            upper = int.from_bytes(payload, "big") << 16
        else:
            raise ValueError(f"{path}:{line_number}: unsupported Intel HEX type {kind}")
    if not saw_eof:
        raise ValueError(f"{path}: missing Intel HEX EOF record")
    return bytes(output)


def checksums(data: bytes) -> tuple[str, str]:
    return f"{binascii.crc32(data) & 0xFFFFFFFF:08x}", hashlib.sha1(data).hexdigest()


def xml_rom(name: str, data: bytes, offset: int, loadflag: str = "") -> str:
    crc, sha1 = checksums(data)
    flag = f' loadflag="{loadflag}"' if loadflag else ""
    return (
        f'                <rom name="{name}" offset="0x{offset:06x}" '
        f'size="0x{len(data):06x}" crc="{crc}" sha1="{sha1}"{flag} />'
    )


def write_zip(path: Path, files: dict[str, bytes]) -> None:
    with zipfile.ZipFile(path, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for name, data in files.items():
            info = zipfile.ZipInfo(name, (1980, 1, 1, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o100644 << 16
            archive.writestr(info, data)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--palette", type=Path, required=True)
    parser.add_argument("--animation-palettes-csv", type=Path, required=True)
    parser.add_argument("--tilemap", type=Path, required=True)
    parser.add_argument("--c1", type=Path, required=True)
    parser.add_argument("--c2", type=Path, required=True)
    parser.add_argument("--nullsound-ihx", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    palette, occurrences, animation_frames, animation_tracks = read_animation(
        args.palette.read_bytes(), args.animation_palettes_csv
    )
    tilemap = args.tilemap.read_bytes()
    raw_c1 = args.c1.read_bytes()
    raw_c2 = args.c2.read_bytes()
    if len(raw_c1) != len(raw_c2) or len(raw_c1) % 64:
        raise ValueError("C1/C2 inputs must contain equally many 64-byte tile halves")

    code, labels = build_code(palette, tilemap, occurrences, animation_frames)
    cpu_image = build_cpu_image(code, labels)
    p1 = wordswap(cpu_image)
    s1 = bytes(S1_SIZE)
    m1 = read_ihex(args.nullsound_ihx, M1_SIZE)
    v1 = bytes(V1_SIZE)
    prefix = bytes(SYSTEM_CROM_TILES * 64)
    if len(prefix) + len(raw_c1) > CROM_SIZE:
        raise ValueError("title graphics do not fit configured C-ROM size")
    c1 = (prefix + raw_c1).ljust(CROM_SIZE, b"\0")
    c2 = (prefix + raw_c2).ljust(CROM_SIZE, b"\0")

    roms = {
        "gtdemo-p1.p1": p1,
        "gtdemo-s1.s1": s1,
        "gtdemo-m1.m1": m1,
        "gtdemo-v1.v1": v1,
        "gtdemo-c1.c1": c1,
        "gtdemo-c2.c2": c2,
    }
    args.output.mkdir(parents=True, exist_ok=True)
    for name, data in roms.items():
        (args.output / name).write_bytes(data)
    write_zip(args.output / "gaunttitle.zip", roms)

    xml = "\n".join((
        '<?xml version="1.0"?>',
        '<!DOCTYPE softwarelist SYSTEM "softwarelist.dtd">',
        '<softwarelist name="neogeo" description="Local Neo-Geo cartridges">',
        '    <software name="gaunttitle">',
        '        <description>Gauntlet Neo-Geo title screen demo</description>',
        '        <year>2026</year>',
        '        <publisher>Zentronic</publisher>',
        '        <sharedfeat name="release" value="MVS" />',
        '        <sharedfeat name="compatibility" value="MVS,AES" />',
        '        <part name="cart" interface="neo_cart">',
        '            <dataarea name="maincpu" width="16" endianness="big" size="0x100000">',
        xml_rom("gtdemo-p1.p1", p1, 0, "load16_word_swap"),
        '            </dataarea>',
        '            <dataarea name="fixed" size="0x020000">',
        xml_rom("gtdemo-s1.s1", s1, 0),
        '            </dataarea>',
        '            <dataarea name="audiocpu" size="0x020000">',
        xml_rom("gtdemo-m1.m1", m1, 0),
        '            </dataarea>',
        '            <dataarea name="ymsnd" size="0x080000">',
        xml_rom("gtdemo-v1.v1", v1, 0),
        '            </dataarea>',
        '            <dataarea name="sprites" size="0x100000">',
        xml_rom("gtdemo-c1.c1", c1, 0, "load16_byte"),
        xml_rom("gtdemo-c2.c2", c2, 1, "load16_byte"),
        '            </dataarea>',
        '        </part>',
        '    </software>',
        '</softwarelist>',
        '',
    ))
    (args.output / "neogeo.xml").write_text(xml)

    manifest = {
        "software": "gaunttitle",
        "ngh": f"0x{NGH:04x}",
        "title_tile_base": SYSTEM_CROM_TILES,
        "title_tiles": len(raw_c1) // 64,
        "sprite_columns": 20,
        "tiles_per_column": 14,
        "palette_animation": {
            "tracks": len(animation_tracks),
            "palette_entries": len(occurrences),
            "phases": len(animation_frames),
            "frames_per_phase": ANIMATION_DELAY,
            "frequency_hz_at_60fps": 60 / ANIMATION_DELAY,
        },
        "program_labels": {name: f"0x{value:06x}" for name, value in labels.items()},
        "roms": {
            name: {"size": len(data), "crc32": checksums(data)[0], "sha1": checksums(data)[1]}
            for name, data in roms.items()
        },
    }
    (args.output / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(f"Built {args.output / 'gaunttitle.zip'} ({len(raw_c1) // 64} title tiles)")


if __name__ == "__main__":
    main()
