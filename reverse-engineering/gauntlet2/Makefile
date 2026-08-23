PYTHON ?= python3
MAME ?= mame

ROOT := $(abspath ../..)
ROM_DIR := $(ROOT)/assets/gaunt2
TOOLS_DIR := $(ROOT)/tools
OUTPUT_DIR := $(CURDIR)/extracted
LEVEL_DIR := $(OUTPUT_DIR)/levels
EXTRACTOR := $(TOOLS_DIR)/extract_gauntlet_graphics.py
LEVEL_EXTRACTOR := $(TOOLS_DIR)/extract_gauntlet_levels.py
PALETTE_DUMPER := $(TOOLS_DIR)/dump_gauntlet_palette.lua

CHAR_ROM := $(ROM_DIR)/136043-1104.6p
TILE_ROMS := \
	$(ROM_DIR)/136043-1111.1a $(ROM_DIR)/136037-112.1b \
	$(ROM_DIR)/136043-1123.1c $(ROM_DIR)/136043-1113.1l \
	$(ROM_DIR)/136037-114.1mn $(ROM_DIR)/136043-1124.1p \
	$(ROM_DIR)/136043-1115.2a $(ROM_DIR)/136037-116.2b \
	$(ROM_DIR)/136043-1125.2c $(ROM_DIR)/136043-1117.2l \
	$(ROM_DIR)/136037-118.2mn $(ROM_DIR)/136043-1126.2p
PROGRAM_ROMS := \
	$(ROM_DIR)/136037-1307.9a $(ROM_DIR)/136037-1308.9b \
	$(ROM_DIR)/136043-1105.10a $(ROM_DIR)/136043-1106.10b \
	$(ROM_DIR)/136043-1109.7a $(ROM_DIR)/136043-1110.7b \
	$(ROM_DIR)/136043-1121.6a $(ROM_DIR)/136043-1122.6b
LEVEL_ROMS := $(ROM_DIR)/136043-1105.10a $(ROM_DIR)/136043-1106.10b
SOUND_ROMS := $(ROM_DIR)/136043-1119.16s $(ROM_DIR)/136043-1120.16r
PROM_ROMS := \
	$(ROM_DIR)/74s472-136037-101.7u \
	$(ROM_DIR)/74s472-136037-102.5l \
	$(ROM_DIR)/74s287-136037-103.4r
ALL_ROMS := $(CHAR_ROM) $(TILE_ROMS) $(PROGRAM_ROMS) $(SOUND_ROMS) $(PROM_ROMS)

CHAR_BIN := $(OUTPUT_DIR)/chars.bin
TILE_BIN := $(OUTPUT_DIR)/playfield-motion-objects.bin
CHAR_PNG := $(OUTPUT_DIR)/chars.png
TILE_PNG := $(OUTPUT_DIR)/playfield-motion-objects.png
PALETTE_BIN := $(OUTPUT_DIR)/palette.bin
PALETTE_CSV := $(OUTPUT_DIR)/palette.csv
GRAPHICS_OUTPUTS := $(CHAR_BIN) $(TILE_BIN) $(CHAR_PNG) $(TILE_PNG)

.NOTPARALLEL:
.PHONY: all graphics tiles png palette palette-dump levels verify clean help

all: graphics palette levels verify
graphics: tiles png
tiles: $(CHAR_BIN) $(TILE_BIN)
png: $(CHAR_PNG) $(TILE_PNG)
palette: $(PALETTE_CSV)
palette-dump: $(PALETTE_BIN) $(PALETTE_CSV)

levels: graphics palette $(LEVEL_ROMS) $(PROGRAM_ROMS) $(LEVEL_EXTRACTOR)
	@mkdir -p $(LEVEL_DIR)
	$(PYTHON) $(LEVEL_EXTRACTOR) --game gaunt2 --rom-dir $(ROM_DIR) \
		--output $(LEVEL_DIR) --tiles $(TILE_BIN) --palette-dump $(PALETTE_BIN)

$(GRAPHICS_OUTPUTS): $(CHAR_ROM) $(TILE_ROMS) $(EXTRACTOR)
	@mkdir -p $(OUTPUT_DIR)
	$(PYTHON) $(EXTRACTOR) --game gaunt2 --rom-dir $(ROM_DIR) --output $(OUTPUT_DIR)

$(PALETTE_BIN): $(ALL_ROMS) $(PALETTE_DUMPER)
	@command -v $(MAME) >/dev/null || { \
		echo "mame fehlt; installiere MAME oder lege einen 0x800-Byte-Dump als $@ ab."; \
		exit 1; \
	}
	@set -eu; \
		tmp_dir=$$(mktemp -d); \
		trap 'rm -rf "$$tmp_dir"' EXIT HUP INT TERM; \
		mkdir -p "$$tmp_dir/roms/gaunt2" "$$tmp_dir/cfg" \
			"$$tmp_dir/nvram" "$$tmp_dir/snap" "$$tmp_dir/home" $(OUTPUT_DIR); \
		cp $(ALL_ROMS) "$$tmp_dir/roms/gaunt2/"; \
		cp $(ROM_DIR)/74s287-136037-103.4r \
			"$$tmp_dir/roms/gaunt2/82s129-136043-1103.4r"; \
		dd if=/dev/zero of="$$tmp_dir/roms/gaunt2/136043-1104.6p" \
			bs=8192 seek=1 count=1 conv=notrunc >/dev/null 2>&1; \
		cd $(OUTPUT_DIR); \
		SDL_VIDEODRIVER=dummy GAUNTLET_AUTOSTART=1 GAUNTLET_PALETTE_FRAME=1650 \
			GAUNTLET_PALETTE_FILE=palette.bin $(MAME) gaunt2 \
			-rompath "$$tmp_dir/roms" -cfg_directory "$$tmp_dir/cfg" \
			-nvram_directory "$$tmp_dir/nvram" -snapshot_directory "$$tmp_dir/snap" \
			-homepath "$$tmp_dir/home" -skip_gameinfo -video none -sound none \
			-autoboot_script $(PALETTE_DUMPER) -seconds_to_run 29

$(PALETTE_CSV): $(PALETTE_BIN) $(EXTRACTOR)
	$(PYTHON) $(EXTRACTOR) --game gaunt2 --output $(OUTPUT_DIR) \
		--palette-dump $(PALETTE_BIN) --palette-only

verify: graphics palette levels
	@test "$$(wc -c < $(CHAR_BIN) | tr -d ' ')" -eq 32768
	@test "$$(wc -c < $(TILE_BIN) | tr -d ' ')" -eq 786432
	@test "$$(wc -c < $(PALETTE_BIN) | tr -d ' ')" -eq 2048
	@test -s $(CHAR_PNG) -a -s $(TILE_PNG) -a -s $(PALETTE_CSV)
	@test "$$(find $(LEVEL_DIR) -type f -name 'level-*.txt' | wc -l | tr -d ' ')" -eq 117
	@test "$$(find $(LEVEL_DIR) -type f -name 'level-*.png' | wc -l | tr -d ' ')" -eq 117
	@test -s $(LEVEL_DIR)/index.txt
	@echo "Gauntlet II geprüft: 512 Chars, 12288 PF/MO-Tiles, 1024 Farben, 117 ASCII- und PNG-Karten."

clean:
	$(RM) $(GRAPHICS_OUTPUTS) $(PALETTE_BIN) $(PALETTE_CSV)
	$(RM) -r $(LEVEL_DIR)

help:
	@echo "make                Grafik, Palette, ASCII-Level und Prüfung"
	@echo "make graphics       Tile-Binaries und PNG-Sheets"
	@echo "make palette        Laufzeitpalette mit MAME aufnehmen/konvertieren"
	@echo "make levels         117 ROM-Karten als ASCII und 512x512-PNG"
	@echo "make verify         Größen und Vollständigkeit prüfen"
	@echo "make clean          generierte Gauntlet-II-Assets entfernen"
