PYTHON ?= python3
MAME ?= mame
MOTION_TRACE_SECONDS ?= 300

ROOT := $(abspath ../..)
ROM_DIR := $(ROOT)/assets/gaunt2
TOOLS_DIR := $(ROOT)/tools
OUTPUT_DIR := $(CURDIR)/extracted
LEVEL_DIR := $(OUTPUT_DIR)/levels
LEVEL_TILESET_DIR := $(OUTPUT_DIR)/level-tilesets
EXTRACTOR := $(TOOLS_DIR)/extract_gauntlet_graphics.py
LEVEL_EXTRACTOR := $(TOOLS_DIR)/extract_gauntlet_levels.py
LEVEL_TILESET_EXTRACTOR := $(TOOLS_DIR)/extract_gauntlet_level_tilesets.py
MO_TRACER := $(TOOLS_DIR)/trace_gauntlet_motion_objects.lua
MO_CATALOG_BUILDER := $(TOOLS_DIR)/build_gauntlet_motion_catalog.py
PALETTE_DUMPER := $(TOOLS_DIR)/dump_gauntlet_palette.lua
MO_DIR := $(OUTPUT_DIR)/motion-objects
MO_TRACE := $(MO_DIR)/trace.csv

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
.PHONY: all graphics tiles png palette palette-dump levels level-tilesets motion-trace motion-catalog verify clean help

all: graphics palette levels verify
graphics: tiles png
tiles: $(CHAR_BIN) $(TILE_BIN)
png: $(CHAR_PNG) $(TILE_PNG)
palette: $(PALETTE_CSV)
palette-dump: $(PALETTE_BIN) $(PALETTE_CSV)

levels: graphics palette $(LEVEL_ROMS) $(PROGRAM_ROMS) $(LEVEL_EXTRACTOR)
	@mkdir -p $(LEVEL_DIR)
	$(PYTHON) $(LEVEL_EXTRACTOR) --game gaunt2 --rom-dir $(ROM_DIR) \
		--output $(LEVEL_DIR) --playfield-output $(LEVEL_DIR) \
		--tiles $(TILE_BIN) --palette-dump $(PALETTE_BIN)

level-tilesets: levels $(LEVEL_TILESET_EXTRACTOR)
	@mkdir -p $(LEVEL_TILESET_DIR)
	$(PYTHON) $(LEVEL_TILESET_EXTRACTOR) --levels $(LEVEL_DIR) \
		--output $(LEVEL_TILESET_DIR)

motion-trace: $(MO_TRACE)

$(MO_TRACE): $(ALL_ROMS) $(MO_TRACER)
	@command -v $(MAME) >/dev/null || { echo "mame fehlt"; exit 1; }
	@set -eu; \
		tmp_dir=$$(mktemp -d); \
		trap 'rm -rf "$$tmp_dir"' EXIT HUP INT TERM; \
		mkdir -p "$$tmp_dir/roms/gaunt2" "$$tmp_dir/cfg" \
			"$$tmp_dir/nvram" "$$tmp_dir/snap" "$$tmp_dir/home" $(MO_DIR); \
		cp $(ALL_ROMS) "$$tmp_dir/roms/gaunt2/"; \
		cp $(ROM_DIR)/74s287-136037-103.4r \
			"$$tmp_dir/roms/gaunt2/82s129-136043-1103.4r"; \
		dd if=/dev/zero of="$$tmp_dir/roms/gaunt2/136043-1104.6p" \
			bs=8192 seek=1 count=1 conv=notrunc >/dev/null 2>&1; \
		GAUNTLET_MO_TRACE_FILE=$(MO_TRACE) GAUNTLET_MO_TRACE_START=900 \
			GAUNTLET_AUTOSTART=1 SDL_VIDEODRIVER=dummy $(MAME) gaunt2 \
			-rompath "$$tmp_dir/roms" -cfg_directory "$$tmp_dir/cfg" \
			-nvram_directory "$$tmp_dir/nvram" -snapshot_directory "$$tmp_dir/snap" \
			-homepath "$$tmp_dir/home" -skip_gameinfo -video none -sound none \
			-nothrottle -autoboot_script $(MO_TRACER) \
			-seconds_to_run $(MOTION_TRACE_SECONDS)

motion-catalog: $(MO_TRACE) graphics palette $(MO_CATALOG_BUILDER)
	$(PYTHON) $(MO_CATALOG_BUILDER) --game gaunt2 --trace $(MO_TRACE) \
		--rom-dir $(ROM_DIR) --tiles $(TILE_BIN) \
		--palette-dump $(PALETTE_BIN) --output $(MO_DIR)

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

verify: graphics palette levels level-tilesets motion-catalog
	@test "$$(wc -c < $(CHAR_BIN) | tr -d ' ')" -eq 32768
	@test "$$(wc -c < $(TILE_BIN) | tr -d ' ')" -eq 786432
	@test "$$(wc -c < $(PALETTE_BIN) | tr -d ' ')" -eq 2048
	@test -s $(CHAR_PNG) -a -s $(TILE_PNG) -a -s $(PALETTE_CSV)
	@test "$$(find $(LEVEL_DIR) -type f -name 'level-*.txt' | wc -l | tr -d ' ')" -eq 103
	@test "$$(find $(LEVEL_DIR) -type f -name 'level-*.png' ! -name '*-playfield.png' | wc -l | tr -d ' ')" -eq 103
	@test "$$(find $(LEVEL_DIR) -type f -name 'demo-*.txt' | wc -l | tr -d ' ')" -eq 1
	@test "$$(find $(LEVEL_DIR) -type f -name 'demo-*.png' ! -name '*-playfield.png' | wc -l | tr -d ' ')" -eq 1
	@test "$$(find $(LEVEL_DIR) -type f -name 'treasure-room-*.txt' | wc -l | tr -d ' ')" -eq 11
	@test "$$(find $(LEVEL_DIR) -type f -name 'treasure-room-*.png' ! -name '*-playfield.png' | wc -l | tr -d ' ')" -eq 11
	@test "$$(find $(LEVEL_DIR) -type f -name 'secret-room-*.txt' | wc -l | tr -d ' ')" -eq 2
	@test "$$(find $(LEVEL_DIR) -type f -name 'secret-room-*.png' ! -name '*-playfield.png' | wc -l | tr -d ' ')" -eq 2
	@test "$$(find $(LEVEL_DIR) -type f -name 'level-*-playfield.png' | wc -l | tr -d ' ')" -eq 103
	@test "$$(find $(LEVEL_DIR) -type f -name 'demo-*-playfield.png' | wc -l | tr -d ' ')" -eq 1
	@test "$$(find $(LEVEL_DIR) -type f -name 'treasure-room-*-playfield.png' | wc -l | tr -d ' ')" -eq 11
	@test "$$(find $(LEVEL_DIR) -type f -name 'secret-room-*-playfield.png' | wc -l | tr -d ' ')" -eq 2
	@test "$$(find $(LEVEL_TILESET_DIR) -type f -name '*-playfield-tiles.png' | wc -l | tr -d ' ')" -eq 117
	@test "$$(find $(LEVEL_TILESET_DIR) -type f -name '*-playfield-map.txt' | wc -l | tr -d ' ')" -eq 117
	@test "$$(find $(LEVEL_TILESET_DIR) -type f -name '*-motion-object-layer.png' | wc -l | tr -d ' ')" -eq 117
	@test "$$(find $(LEVEL_TILESET_DIR) -type f -name '*-motion-object-tiles.png' | wc -l | tr -d ' ')" -eq 117
	@test "$$(find $(LEVEL_TILESET_DIR) -type f -name '*-motion-object-map.txt' | wc -l | tr -d ' ')" -eq 117
	@test -s $(LEVEL_TILESET_DIR)/index.csv
	@test -s $(MO_TRACE) -a -s $(MO_DIR)/frames.png -a -s $(MO_DIR)/frames.csv
	@test -s $(MO_DIR)/pen-1-mask.png
	@test -s $(LEVEL_DIR)/index.txt
	@echo "Gauntlet II geprüft: 117 ASCII-Karten sowie 117 vollständige und 117 Playfield-only-PNGs."

clean:
	$(RM) $(GRAPHICS_OUTPUTS) $(PALETTE_BIN) $(PALETTE_CSV)
	$(RM) -r $(LEVEL_DIR) $(LEVEL_TILESET_DIR) $(MO_DIR)

help:
	@echo "make                Grafik, Palette, ASCII-Level und Prüfung"
	@echo "make graphics       Tile-Binaries und PNG-Sheets"
	@echo "make palette        Laufzeitpalette mit MAME aufnehmen/konvertieren"
	@echo "make levels         Karten als ASCII, vollständige PNGs und Playfield-only-PNGs"
	@echo "make level-tilesets eindeutige 16x16-Playfield-/MO-Tiles und 32x32-Indexmaps"
	@echo "make motion-trace   echte MO-Frames und Paletten über MAME protokollieren"
	@echo "make motion-catalog beobachtete Frames plus ROM-Energiestufen als 16x16-Atlas"
	@echo "make verify         Größen und Vollständigkeit prüfen"
	@echo "make clean          generierte Gauntlet-II-Assets entfernen"
