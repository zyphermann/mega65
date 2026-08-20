#!/usr/bin/env python3
"""Build a reproducible, annotated baseline disassembly of Time Pilot's main Z80 ROM."""

from __future__ import annotations

import argparse
import hashlib
import shutil
import subprocess
import tempfile
from pathlib import Path


EXPECTED_ROMS = {
    "tm1": (0x2000, "c72f30988ac00cbe6549b71c3bcb414511e8b997"),
    "tm2": (0x2000, "ab517efa93ae7be780af55faea82a6e83edd828c"),
    "tm3": (0x2000, "ef98a1abb45b22d7498a0aca520f43bbee248b22"),
}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rom-dir", type=Path, required=True)
    parser.add_argument("--symbols", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--symbol-output", type=Path, required=True)
    args = parser.parse_args()

    executable = shutil.which("z80dasm")
    if executable is None:
        raise SystemExit("z80dasm fehlt (macOS: brew install z80dasm)")

    image = bytearray()
    for name, (expected_size, expected_sha1) in EXPECTED_ROMS.items():
        data = (args.rom_dir / name).read_bytes()
        actual_sha1 = hashlib.sha1(data).hexdigest()
        if len(data) != expected_size or actual_sha1 != expected_sha1:
            raise SystemExit(
                f"{name}: unerwarteter ROM-Dump "
                f"(Groesse={len(data)}, SHA-1={actual_sha1})"
            )
        image.extend(data)

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.symbol_output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="timepilot-disasm-") as temp_dir:
        binary = Path(temp_dir) / "timepilot-main.bin"
        binary.write_bytes(image)
        subprocess.run(
            [
                executable,
                "--origin=0x0000",
                "--address",
                "--source",
                "--labels",
                "--sym-comments",
                f"--sym-input={args.symbols.resolve()}",
                f"--sym-output={args.symbol_output.resolve()}",
                f"--output={args.output.resolve()}",
                str(binary),
            ],
            check=True,
        )

    generated = args.output.read_text()
    generated = "\n".join(
        line for line in generated.splitlines() if not line.startswith("; command line:")
    ) + "\n"
    header = (
        "; GENERATED FILE - do not edit. Run `make disassemble` instead.\n"
        "; Linear baseline: code and embedded data are not separated yet.\n"
        "; ROM image: tm1 @ $0000, tm2 @ $2000, tm3 @ $4000.\n\n"
    )
    args.output.write_text(header + generated)


if __name__ == "__main__":
    main()
