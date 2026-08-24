PYTHON ?= python3
MAME ?= mame
MOTION_TRACE_SECONDS ?= 300

ROOT := $(abspath ../..)
ROM_DIR := $(ROOT)/assets/gauntlet/romset
TOOLS_DIR := $(ROOT)/tools
OUTPUT_DIR := $(CURDIR)/extracted
EXTRACTOR := $(TOOLS_DIR)/extract_gauntlet_graphics.py
LEVEL_EXTRACTOR := $(TOOLS_DIR)/extract_gauntlet_levels.py
LEVEL_TILESET_EXTRACTOR := $(TOOLS_DIR)/extract_gauntlet_level_tilesets.py
MO_TRACER := $(TOOLS_DIR)/trace_gauntlet_motion_objects.lua
MO_CATALOG_BUILDER := $(TOOLS_DIR)/build_gauntlet_motion_catalog.py
PALETTE_DUMPER := $(TOOLS_DIR)/dump_gauntlet_palette.lua
TITLE_CAPTURE := $(TOOLS_DIR)/capture_gauntlet_title_screen.lua
TITLE_CYCLE_CAPTURE := $(TOOLS_DIR)/capture_gauntlet_title_cycle.lua
TITLE_CYCLE_BUILDER := $(TOOLS_DIR)/build_gauntlet_title_cycle.py
PNG_INDEXER := $(TOOLS_DIR)/index_png.py
TITLE_CROPPER := $(TOOLS_DIR)/crop_rgb_png.py
INDEXED_CROPPER := $(TOOLS_DIR)/crop_indexed_png.py
NEOGEO_TITLE_BUILDER := $(TOOLS_DIR)/build_neogeo_title.py
NEOGEO_CROM_CONVERTER := $(TOOLS_DIR)/convert_neogeo_crom.py
LEVEL_DIR := $(OUTPUT_DIR)/levels
LEVEL_TILESET_DIR := $(OUTPUT_DIR)/level-tilesets
MO_DIR := $(OUTPUT_DIR)/motion-objects
MO_TRACE := $(MO_DIR)/trace.csv

CHAR_ROM := $(ROM_DIR)/136037-104.6p
TILE_ROMS := \
	$(ROM_DIR)/136037-111.1a \
	$(ROM_DIR)/136037-112.1b \
	$(ROM_DIR)/136037-113.1l \
	$(ROM_DIR)/136037-114.1mn \
	$(ROM_DIR)/136037-115.2a \
	$(ROM_DIR)/136037-116.2b \
	$(ROM_DIR)/136037-117.2l \
	$(ROM_DIR)/136037-118.2mn
PROGRAM_ROMS := \
	$(ROM_DIR)/136037-1307.9a \
	$(ROM_DIR)/136037-1308.9b \
	$(ROM_DIR)/136037-205.10a \
	$(ROM_DIR)/136037-206.10b \
	$(ROM_DIR)/136037-1409.7a \
	$(ROM_DIR)/136037-1410.7b
LEVEL_ROMS := $(ROM_DIR)/136037-205.10a $(ROM_DIR)/136037-206.10b
SOUND_ROMS := $(ROM_DIR)/136037-119.16s $(ROM_DIR)/136037-120.16r
PROM_ROMS := \
	$(ROM_DIR)/74s472-136037-101.7u \
	$(ROM_DIR)/74s472-136037-102.5l \
	$(ROM_DIR)/74s287-136037-103.4r
ALL_ROMS := $(CHAR_ROM) $(TILE_ROMS) $(PROGRAM_ROMS) $(SOUND_ROMS) $(PROM_ROMS)

CHAR_BIN := $(OUTPUT_DIR)/chars.bin
TILE_BIN := $(OUTPUT_DIR)/playfield-motion-objects.bin
CHAR_PNG := $(OUTPUT_DIR)/chars.png
TILE_PNG := $(OUTPUT_DIR)/playfield-motion-objects.png
LOGO_PNG := $(OUTPUT_DIR)/logo.png
TITLE_SCREEN_PNG := $(OUTPUT_DIR)/title-screen.png
TITLE_SCREEN_PHASE_PNG := $(OUTPUT_DIR)/title-screen-phase.png
TITLE_SCREEN_INDEXED_PNG := $(OUTPUT_DIR)/title-screen-indexed.png
TITLE_SCREEN_PALETTE_BIN := $(OUTPUT_DIR)/title-screen-palette.bin
TITLE_SCREEN_PALETTE_CSV := $(OUTPUT_DIR)/title-screen-palette.csv
TITLE_SCREEN_MARKED_PNG := $(OUTPUT_DIR)/title-screen-indexed-marked.png
TITLE_SCREEN_MARKED_PALETTE_BIN := $(OUTPUT_DIR)/title-screen-marked-palette.bin
TITLE_SCREEN_MARKED_PALETTE_CSV := $(OUTPUT_DIR)/title-screen-marked-palette.csv
TITLE_SCREEN_MARKED_CROPPED_PNG := $(OUTPUT_DIR)/title-screen-indexed-marked-cropped.png
TITLE_SCREEN_CYCLE_INDEXED_PNG := $(OUTPUT_DIR)/title-screen-cycle-indexed.png
TITLE_SCREEN_CYCLE_PALETTE_BIN := $(OUTPUT_DIR)/title-screen-cycle-palette.bin
TITLE_SCREEN_CYCLE_PALETTE_CSV := $(OUTPUT_DIR)/title-screen-cycle-palette.csv
TITLE_SCREEN_CYCLE_BIN := $(OUTPUT_DIR)/title-screen-cycle.bin
TITLE_SCREEN_CYCLE_CSV := $(OUTPUT_DIR)/title-screen-cycle.csv
TITLE_SCREEN_CYCLE_SUMMARY := $(OUTPUT_DIR)/title-screen-cycle-summary.json
TITLE_SCREEN_CYCLE_CROPPED_PNG := $(OUTPUT_DIR)/title-screen-cycle-indexed-cropped.png
TITLE_SCREEN_NEOGEO_PNG := $(OUTPUT_DIR)/title-screen-indexed-marked-cropped-neogeo.png
TITLE_SCREEN_NEOGEO_TILES := $(OUTPUT_DIR)/title-screen-neogeo-tiles-4bpp.bin
TITLE_SCREEN_NEOGEO_TILEMAP_BIN := $(OUTPUT_DIR)/title-screen-neogeo-tilemap.bin
TITLE_SCREEN_NEOGEO_TILEMAP_CSV := $(OUTPUT_DIR)/title-screen-neogeo-tilemap.csv
TITLE_SCREEN_NEOGEO_PALETTES_BIN := $(OUTPUT_DIR)/title-screen-neogeo-palettes.bin
TITLE_SCREEN_NEOGEO_PALETTES_CSV := $(OUTPUT_DIR)/title-screen-neogeo-palettes.csv
TITLE_SCREEN_NEOGEO_ANIMATION_PALETTES_BIN := $(OUTPUT_DIR)/title-screen-neogeo-animation-palettes.bin
TITLE_SCREEN_NEOGEO_ANIMATION_PALETTES_CSV := $(OUTPUT_DIR)/title-screen-neogeo-animation-palettes.csv
TITLE_SCREEN_NEOGEO_SUMMARY := $(OUTPUT_DIR)/title-screen-neogeo-summary.json
TITLE_SCREEN_NEOGEO_C1 := $(OUTPUT_DIR)/title-screen-neogeo-c1.bin
TITLE_SCREEN_NEOGEO_C2 := $(OUTPUT_DIR)/title-screen-neogeo-c2.bin
TITLE_SCREEN_NEOGEO_CROM_SUMMARY := $(OUTPUT_DIR)/title-screen-neogeo-crom-summary.json
TITLE_SCREEN_NEOGEO_OUTPUTS := $(TITLE_SCREEN_NEOGEO_PNG) \
	$(TITLE_SCREEN_NEOGEO_TILES) $(TITLE_SCREEN_NEOGEO_TILEMAP_BIN) \
	$(TITLE_SCREEN_NEOGEO_TILEMAP_CSV) $(TITLE_SCREEN_NEOGEO_PALETTES_BIN) \
	$(TITLE_SCREEN_NEOGEO_PALETTES_CSV) \
	$(TITLE_SCREEN_NEOGEO_ANIMATION_PALETTES_BIN) \
	$(TITLE_SCREEN_NEOGEO_ANIMATION_PALETTES_CSV) $(TITLE_SCREEN_NEOGEO_SUMMARY)
TITLE_SCREEN_NEOGEO_CROM_OUTPUTS := $(TITLE_SCREEN_NEOGEO_C1) \
	$(TITLE_SCREEN_NEOGEO_C2) $(TITLE_SCREEN_NEOGEO_CROM_SUMMARY)
TITLE_SCREEN_INDEX_OUTPUTS := $(TITLE_SCREEN_INDEXED_PNG) \
	$(TITLE_SCREEN_PALETTE_BIN) $(TITLE_SCREEN_PALETTE_CSV) \
	$(TITLE_SCREEN_MARKED_PNG) $(TITLE_SCREEN_MARKED_PALETTE_BIN) \
	$(TITLE_SCREEN_MARKED_PALETTE_CSV)
TITLE_SCREEN_CYCLE_OUTPUTS := $(TITLE_SCREEN_CYCLE_INDEXED_PNG) \
	$(TITLE_SCREEN_CYCLE_PALETTE_BIN) $(TITLE_SCREEN_CYCLE_PALETTE_CSV) \
	$(TITLE_SCREEN_CYCLE_BIN) $(TITLE_SCREEN_CYCLE_CSV) \
	$(TITLE_SCREEN_CYCLE_SUMMARY)
PALETTE_BIN := $(OUTPUT_DIR)/palette.bin
PALETTE_CSV := $(OUTPUT_DIR)/palette.csv
GRAPHICS_OUTPUTS := $(CHAR_BIN) $(TILE_BIN) $(CHAR_PNG) $(TILE_PNG) $(LOGO_PNG)

# GNU Make 3.81 (the macOS system make) has no grouped targets.  Serialising
# avoids invoking the one-pass extractor more than once when all outputs are
# initially absent.
.NOTPARALLEL:

.PHONY: all graphics tiles png palette palette-dump title-screen title-screen-neogeo levels level-tilesets motion-trace motion-catalog verify clean help

all: graphics palette title-screen levels verify

graphics: tiles png

tiles: $(CHAR_BIN) $(TILE_BIN)

png: $(CHAR_PNG) $(TILE_PNG) $(LOGO_PNG)

palette: $(PALETTE_CSV)

palette-dump: $(PALETTE_BIN) $(PALETTE_CSV)

title-screen: $(TITLE_SCREEN_PNG) $(TITLE_SCREEN_PHASE_PNG) $(TITLE_SCREEN_INDEX_OUTPUTS) $(TITLE_SCREEN_MARKED_CROPPED_PNG) $(TITLE_SCREEN_CYCLE_OUTPUTS) $(TITLE_SCREEN_CYCLE_CROPPED_PNG) $(TITLE_SCREEN_NEOGEO_OUTPUTS) $(TITLE_SCREEN_NEOGEO_CROM_OUTPUTS)

title-screen-neogeo: $(TITLE_SCREEN_NEOGEO_OUTPUTS) $(TITLE_SCREEN_NEOGEO_CROM_OUTPUTS)

$(TITLE_SCREEN_PNG) $(TITLE_SCREEN_PHASE_PNG): $(ALL_ROMS) $(TITLE_CAPTURE) $(TITLE_CROPPER) $(PNG_INDEXER)
	@command -v $(MAME) >/dev/null || { echo "mame fehlt"; exit 1; }
	@set -eu; \
		tmp_dir=$$(mktemp -d); \
		trap 'rm -rf "$$tmp_dir"' EXIT HUP INT TERM; \
		mkdir -p "$$tmp_dir/roms/gauntlet" "$$tmp_dir/cfg" \
			"$$tmp_dir/nvram" "$$tmp_dir/snap" "$$tmp_dir/home" $(OUTPUT_DIR); \
		cp $(ALL_ROMS) "$$tmp_dir/roms/gauntlet/"; \
		dd if=/dev/zero of="$$tmp_dir/roms/gauntlet/136037-104.6p" \
			bs=8192 seek=1 count=1 conv=notrunc >/dev/null 2>&1; \
		SDL_VIDEODRIVER=dummy GAUNTLET_TITLE_FRAME=9510 \
			GAUNTLET_TITLE_PHASE_FRAME=9540 $(MAME) gauntlet \
			-rompath "$$tmp_dir/roms" -cfg_directory "$$tmp_dir/cfg" \
			-nvram_directory "$$tmp_dir/nvram" \
			-snapshot_directory "$$tmp_dir/snap" \
			-homepath "$$tmp_dir/home" -skip_gameinfo -video none -sound none \
			-nothrottle -autoboot_script $(TITLE_CAPTURE) \
			-seconds_to_run 161 >/dev/null 2>&1; \
		test -s "$$tmp_dir/snap/title-screen.png"; \
		test -s "$$tmp_dir/snap/title-screen-phase.png"; \
		$(PYTHON) $(TITLE_CROPPER) --input "$$tmp_dir/snap/title-screen.png" \
			--output $(TITLE_SCREEN_PNG) --left 1 --top 1 --right 9 --bottom 1; \
		$(PYTHON) $(TITLE_CROPPER) --input "$$tmp_dir/snap/title-screen-phase.png" \
			--output $(TITLE_SCREEN_PHASE_PNG) --left 1 --top 1 --right 9 --bottom 1

$(TITLE_SCREEN_INDEX_OUTPUTS): $(TITLE_SCREEN_PNG) $(TITLE_SCREEN_PHASE_PNG) $(PNG_INDEXER)
	$(PYTHON) $(PNG_INDEXER) --input $(TITLE_SCREEN_PNG) \
		--output $(TITLE_SCREEN_INDEXED_PNG) \
		--palette-bin $(TITLE_SCREEN_PALETTE_BIN) \
		--palette-csv $(TITLE_SCREEN_PALETTE_CSV) \
		--animated-phase $(TITLE_SCREEN_PHASE_PNG) \
		--marked-output $(TITLE_SCREEN_MARKED_PNG) \
		--marked-palette-bin $(TITLE_SCREEN_MARKED_PALETTE_BIN) \
		--marked-palette-csv $(TITLE_SCREEN_MARKED_PALETTE_CSV)

$(TITLE_SCREEN_MARKED_CROPPED_PNG): $(TITLE_SCREEN_MARKED_PNG) $(INDEXED_CROPPER) $(PNG_INDEXER)
	$(PYTHON) $(INDEXED_CROPPER) --input $(TITLE_SCREEN_MARKED_PNG) \
		--output $@ --top 7 --bottom 7 \
		--remove-columns 1,2,3,140,193,325

$(TITLE_SCREEN_CYCLE_OUTPUTS): $(ALL_ROMS) $(TITLE_CYCLE_CAPTURE) \
		$(TITLE_CYCLE_BUILDER) $(PNG_INDEXER) $(NEOGEO_TITLE_BUILDER)
	@command -v $(MAME) >/dev/null || { echo "mame fehlt"; exit 1; }
	@set -eu; \
		tmp_dir=$$(mktemp -d); \
		trap 'rm -rf "$$tmp_dir"' EXIT HUP INT TERM; \
		mkdir -p "$$tmp_dir/roms/gauntlet" "$$tmp_dir/cfg" \
			"$$tmp_dir/nvram" "$$tmp_dir/snap" "$$tmp_dir/home" \
			"$$tmp_dir/cycle" $(OUTPUT_DIR); \
		cp $(ALL_ROMS) "$$tmp_dir/roms/gauntlet/"; \
		dd if=/dev/zero of="$$tmp_dir/roms/gauntlet/136037-104.6p" \
			bs=8192 seek=1 count=1 conv=notrunc >/dev/null 2>&1; \
		SDL_VIDEODRIVER=dummy GAUNTLET_TITLE_CYCLE_DIR="$$tmp_dir/cycle" \
			GAUNTLET_TITLE_CYCLE_FIRST=9510 GAUNTLET_TITLE_CYCLE_LAST=9996 \
			GAUNTLET_TITLE_CYCLE_STEP=3 $(MAME) gauntlet \
			-rompath "$$tmp_dir/roms" -cfg_directory "$$tmp_dir/cfg" \
			-nvram_directory "$$tmp_dir/nvram" \
			-snapshot_directory "$$tmp_dir/snap" \
			-homepath "$$tmp_dir/home" -skip_gameinfo -video none -sound none \
			-nothrottle -autoboot_script $(TITLE_CYCLE_CAPTURE) \
			-seconds_to_run 168 >/dev/null 2>&1; \
		test "$$(find "$$tmp_dir/cycle" -name 'title-cycle-*.png' | wc -l | tr -d ' ')" -eq 163; \
		$(PYTHON) $(TITLE_CYCLE_BUILDER) --input-directory "$$tmp_dir/cycle" \
			--output $(TITLE_SCREEN_CYCLE_INDEXED_PNG) \
			--palette-bin $(TITLE_SCREEN_CYCLE_PALETTE_BIN) \
			--palette-csv $(TITLE_SCREEN_CYCLE_PALETTE_CSV) \
			--cycle-bin $(TITLE_SCREEN_CYCLE_BIN) \
			--cycle-csv $(TITLE_SCREEN_CYCLE_CSV) \
			--summary $(TITLE_SCREEN_CYCLE_SUMMARY)

$(TITLE_SCREEN_CYCLE_CROPPED_PNG): $(TITLE_SCREEN_CYCLE_INDEXED_PNG) $(INDEXED_CROPPER) $(PNG_INDEXER)
	$(PYTHON) $(INDEXED_CROPPER) --input $(TITLE_SCREEN_CYCLE_INDEXED_PNG) \
		--output $@ --top 7 --bottom 7 \
		--remove-columns 1,2,3,140,193,325

$(TITLE_SCREEN_NEOGEO_OUTPUTS): $(TITLE_SCREEN_CYCLE_CROPPED_PNG) \
		$(TITLE_SCREEN_CYCLE_PALETTE_CSV) $(TITLE_SCREEN_CYCLE_CSV) $(NEOGEO_TITLE_BUILDER) \
		$(INDEXED_CROPPER) $(PNG_INDEXER)
	$(PYTHON) $(NEOGEO_TITLE_BUILDER) \
		--input $(TITLE_SCREEN_CYCLE_CROPPED_PNG) \
		--marker-palette-csv $(TITLE_SCREEN_CYCLE_PALETTE_CSV) \
		--animation-cycle-csv $(TITLE_SCREEN_CYCLE_CSV) \
		--output $(TITLE_SCREEN_NEOGEO_PNG) \
		--tiles $(TITLE_SCREEN_NEOGEO_TILES) \
		--tilemap-bin $(TITLE_SCREEN_NEOGEO_TILEMAP_BIN) \
		--tilemap-csv $(TITLE_SCREEN_NEOGEO_TILEMAP_CSV) \
		--palettes-bin $(TITLE_SCREEN_NEOGEO_PALETTES_BIN) \
		--palettes-csv $(TITLE_SCREEN_NEOGEO_PALETTES_CSV) \
		--animation-palettes-bin $(TITLE_SCREEN_NEOGEO_ANIMATION_PALETTES_BIN) \
		--animation-palettes-csv $(TITLE_SCREEN_NEOGEO_ANIMATION_PALETTES_CSV) \
		--summary $(TITLE_SCREEN_NEOGEO_SUMMARY)

$(TITLE_SCREEN_NEOGEO_CROM_OUTPUTS): $(TITLE_SCREEN_NEOGEO_TILES) \
		$(NEOGEO_CROM_CONVERTER)
	$(PYTHON) $(NEOGEO_CROM_CONVERTER) \
		--input $(TITLE_SCREEN_NEOGEO_TILES) \
		--c1 $(TITLE_SCREEN_NEOGEO_C1) --c2 $(TITLE_SCREEN_NEOGEO_C2) \
		--summary $(TITLE_SCREEN_NEOGEO_CROM_SUMMARY)

levels: graphics palette $(LEVEL_ROMS) $(PROGRAM_ROMS) $(LEVEL_EXTRACTOR)
	@mkdir -p $(LEVEL_DIR)
	$(PYTHON) $(LEVEL_EXTRACTOR) --rom-dir $(ROM_DIR) --output $(LEVEL_DIR) \
		--playfield-output $(LEVEL_DIR) \
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
		mkdir -p "$$tmp_dir/roms/gauntlet" "$$tmp_dir/cfg" \
			"$$tmp_dir/nvram" "$$tmp_dir/snap" "$$tmp_dir/home" $(MO_DIR); \
		cp $(ALL_ROMS) "$$tmp_dir/roms/gauntlet/"; \
		dd if=/dev/zero of="$$tmp_dir/roms/gauntlet/136037-104.6p" \
			bs=8192 seek=1 count=1 conv=notrunc >/dev/null 2>&1; \
		GAUNTLET_MO_TRACE_FILE=$(MO_TRACE) GAUNTLET_MO_TRACE_START=900 \
			GAUNTLET_AUTOSTART=1 SDL_VIDEODRIVER=dummy $(MAME) gauntlet \
			-rompath "$$tmp_dir/roms" -cfg_directory "$$tmp_dir/cfg" \
			-nvram_directory "$$tmp_dir/nvram" -snapshot_directory "$$tmp_dir/snap" \
			-homepath "$$tmp_dir/home" -skip_gameinfo -video none -sound none \
			-nothrottle -autoboot_script $(MO_TRACER) \
			-seconds_to_run $(MOTION_TRACE_SECONDS)

motion-catalog: $(MO_TRACE) graphics palette $(MO_CATALOG_BUILDER)
	$(PYTHON) $(MO_CATALOG_BUILDER) --game gauntlet --trace $(MO_TRACE) \
		--rom-dir $(ROM_DIR) --tiles $(TILE_BIN) \
		--palette-dump $(PALETTE_BIN) --output $(MO_DIR)

$(GRAPHICS_OUTPUTS): $(CHAR_ROM) $(TILE_ROMS) $(EXTRACTOR)
	@mkdir -p $(OUTPUT_DIR)
	$(PYTHON) $(EXTRACTOR) --rom-dir $(ROM_DIR) --output $(OUTPUT_DIR)

$(PALETTE_BIN): $(ALL_ROMS) $(PALETTE_DUMPER)
	@command -v $(MAME) >/dev/null || { \
		echo "mame fehlt; installiere MAME oder lege einen 0x800-Byte-Dump als $@ ab."; \
		exit 1; \
	}
	@set -eu; \
		tmp_dir=$$(mktemp -d); \
		trap 'rm -rf "$$tmp_dir"' EXIT HUP INT TERM; \
		mkdir -p "$$tmp_dir/roms/gauntlet" "$$tmp_dir/cfg" \
			"$$tmp_dir/nvram" "$$tmp_dir/snap" "$$tmp_dir/home" $(OUTPUT_DIR); \
		cp $(ALL_ROMS) "$$tmp_dir/roms/gauntlet/"; \
		dd if=/dev/zero of="$$tmp_dir/roms/gauntlet/136037-104.6p" \
			bs=8192 seek=1 count=1 conv=notrunc >/dev/null 2>&1; \
		cd $(OUTPUT_DIR); \
		SDL_VIDEODRIVER=dummy GAUNTLET_PALETTE_FILE=palette.bin $(MAME) gauntlet \
			-rompath "$$tmp_dir/roms" \
			-cfg_directory "$$tmp_dir/cfg" \
			-nvram_directory "$$tmp_dir/nvram" \
			-snapshot_directory "$$tmp_dir/snap" \
			-homepath "$$tmp_dir/home" \
			-skip_gameinfo -video none -sound none \
		-autoboot_script $(PALETTE_DUMPER) -seconds_to_run 17

$(PALETTE_CSV): $(PALETTE_BIN) $(EXTRACTOR)
	$(PYTHON) $(EXTRACTOR) --output $(OUTPUT_DIR) \
		--palette-dump $(PALETTE_BIN) --palette-only

verify: graphics palette title-screen levels level-tilesets motion-catalog
	@test "$$(wc -c < $(CHAR_BIN) | tr -d ' ')" -eq 32768
	@test "$$(wc -c < $(TILE_BIN) | tr -d ' ')" -eq 524288
	@test "$$(wc -c < $(PALETTE_BIN) | tr -d ' ')" -eq 2048
	@test -s $(CHAR_PNG) -a -s $(TILE_PNG) -a -s $(LOGO_PNG) -a -s $(PALETTE_CSV)
	@test -s $(TITLE_SCREEN_PNG)
	@test -s $(TITLE_SCREEN_PHASE_PNG)
	@test -s $(TITLE_SCREEN_INDEXED_PNG) -a -s $(TITLE_SCREEN_PALETTE_BIN) \
		-a -s $(TITLE_SCREEN_PALETTE_CSV)
	@test -s $(TITLE_SCREEN_MARKED_PNG) -a -s $(TITLE_SCREEN_MARKED_PALETTE_BIN) \
		-a -s $(TITLE_SCREEN_MARKED_PALETTE_CSV)
	@test -s $(TITLE_SCREEN_MARKED_CROPPED_PNG)
	@test -s $(TITLE_SCREEN_CYCLE_INDEXED_PNG) \
		-a -s $(TITLE_SCREEN_CYCLE_PALETTE_BIN) \
		-a -s $(TITLE_SCREEN_CYCLE_PALETTE_CSV) \
		-a -s $(TITLE_SCREEN_CYCLE_BIN) -a -s $(TITLE_SCREEN_CYCLE_CSV) \
		-a -s $(TITLE_SCREEN_CYCLE_SUMMARY) -a -s $(TITLE_SCREEN_CYCLE_CROPPED_PNG)
	@test "$$(wc -c < $(TITLE_SCREEN_CYCLE_BIN) | tr -d ' ')" -eq 6480
	@$(PYTHON) -c 'import json; s=json.load(open("$(TITLE_SCREEN_CYCLE_SUMMARY)")); assert s["period_phases"] == 162; assert s["period_frames"] == 486; assert s["animated_tracks"] == 20; assert s["phase_zero_distinct_animated_colours"] == 19; assert s["animated_pixels"] == 5735'
	@test -s $(TITLE_SCREEN_NEOGEO_PNG) -a -s $(TITLE_SCREEN_NEOGEO_TILES) \
		-a -s $(TITLE_SCREEN_NEOGEO_TILEMAP_BIN) \
		-a -s $(TITLE_SCREEN_NEOGEO_TILEMAP_CSV) \
		-a -s $(TITLE_SCREEN_NEOGEO_PALETTES_BIN) \
		-a -s $(TITLE_SCREEN_NEOGEO_PALETTES_CSV) \
		-a -s $(TITLE_SCREEN_NEOGEO_ANIMATION_PALETTES_BIN) \
		-a -s $(TITLE_SCREEN_NEOGEO_ANIMATION_PALETTES_CSV) \
		-a -s $(TITLE_SCREEN_NEOGEO_SUMMARY)
	@test "$$(wc -c < $(TITLE_SCREEN_NEOGEO_TILEMAP_BIN) | tr -d ' ')" -eq 1120
	@test "$$(wc -c < $(TITLE_SCREEN_NEOGEO_PALETTES_BIN) | tr -d ' ')" -eq 8192
	@$(PYTHON) -c 'import json, pathlib; s=json.load(open("$(TITLE_SCREEN_NEOGEO_SUMMARY)")); assert s["max_colours_per_tile_including_transparency"] <= 16; assert s["changed_marker_pixels"] == 0; assert s["animation_phases"] == 162; assert s["animation_tracks"] == 20; assert s["animated_palette_entries"] == 91; assert s["animation_palette_bytes"] == pathlib.Path("$(TITLE_SCREEN_NEOGEO_ANIMATION_PALETTES_BIN)").stat().st_size'
	@test "$$(wc -c < $(TITLE_SCREEN_NEOGEO_C1) | tr -d ' ')" -eq \
		"$$(($$(wc -c < $(TITLE_SCREEN_NEOGEO_TILES) | tr -d ' ') / 2))"
	@test "$$(wc -c < $(TITLE_SCREEN_NEOGEO_C2) | tr -d ' ')" -eq \
		"$$(($$(wc -c < $(TITLE_SCREEN_NEOGEO_TILES) | tr -d ' ') / 2))"
	@$(PYTHON) -c 'import json, pathlib; s=json.load(open("$(TITLE_SCREEN_NEOGEO_CROM_SUMMARY)")); assert s["tile_count"] == pathlib.Path("$(TITLE_SCREEN_NEOGEO_TILES)").stat().st_size // 128; assert s["roundtrip_verified_tiles"] == s["tile_count"]'
	@test "$$(find $(LEVEL_DIR) -type f -name 'level-*.txt' | wc -l | tr -d ' ')" -eq 114
	@test "$$(find $(LEVEL_DIR) -type f -name 'demo-*.txt' | wc -l | tr -d ' ')" -eq 2
	@test "$$(find $(LEVEL_DIR) -type f -name 'treasure-room-*.txt' | wc -l | tr -d ' ')" -eq 11
	@test "$$(find $(LEVEL_DIR) -type f -name 'level-*.png' ! -name '*-playfield.png' | wc -l | tr -d ' ')" -eq 114
	@test "$$(find $(LEVEL_DIR) -type f -name 'demo-*.png' ! -name '*-playfield.png' | wc -l | tr -d ' ')" -eq 2
	@test "$$(find $(LEVEL_DIR) -type f -name 'treasure-room-*.png' ! -name '*-playfield.png' | wc -l | tr -d ' ')" -eq 11
	@test "$$(find $(LEVEL_DIR) -type f -name 'level-*-playfield.png' | wc -l | tr -d ' ')" -eq 114
	@test "$$(find $(LEVEL_DIR) -type f -name 'demo-*-playfield.png' | wc -l | tr -d ' ')" -eq 2
	@test "$$(find $(LEVEL_DIR) -type f -name 'treasure-room-*-playfield.png' | wc -l | tr -d ' ')" -eq 11
	@test "$$(find $(LEVEL_TILESET_DIR) -type f -name '*-playfield-tiles.png' | wc -l | tr -d ' ')" -eq 127
	@test "$$(find $(LEVEL_TILESET_DIR) -type f -name '*-playfield-map.txt' | wc -l | tr -d ' ')" -eq 127
	@test "$$(find $(LEVEL_TILESET_DIR) -type f -name '*-motion-object-layer.png' | wc -l | tr -d ' ')" -eq 127
	@test "$$(find $(LEVEL_TILESET_DIR) -type f -name '*-motion-object-tiles.png' | wc -l | tr -d ' ')" -eq 127
	@test "$$(find $(LEVEL_TILESET_DIR) -type f -name '*-motion-object-map.txt' | wc -l | tr -d ' ')" -eq 127
	@test -s $(LEVEL_TILESET_DIR)/index.csv
	@test -s $(MO_TRACE) -a -s $(MO_DIR)/frames.png -a -s $(MO_DIR)/frames.csv
	@test -s $(MO_DIR)/pen-1-mask.png
	@test -s $(LEVEL_DIR)/index.txt
	@echo "Gauntlet assets geprüft: 127 ASCII-Karten sowie 127 vollständige und 127 Playfield-only-PNGs."

clean:
	$(RM) $(GRAPHICS_OUTPUTS) $(PALETTE_BIN) $(PALETTE_CSV)
	$(RM) $(TITLE_SCREEN_PNG)
	$(RM) $(TITLE_SCREEN_PHASE_PNG)
	$(RM) $(TITLE_SCREEN_INDEX_OUTPUTS)
	$(RM) $(TITLE_SCREEN_MARKED_CROPPED_PNG)
	$(RM) $(TITLE_SCREEN_CYCLE_OUTPUTS)
	$(RM) $(TITLE_SCREEN_CYCLE_CROPPED_PNG)
	$(RM) $(TITLE_SCREEN_NEOGEO_OUTPUTS)
	$(RM) $(TITLE_SCREEN_NEOGEO_CROM_OUTPUTS)
	$(RM) -r $(LEVEL_DIR) $(LEVEL_TILESET_DIR) $(MO_DIR)

help:
	@echo "make                Grafik, Palette, ASCII-Level und Prüfung"
	@echo "make graphics       Tile-Binaries und PNG-Sheets"
	@echo "make tiles          ungepackte Tile-Binaries"
	@echo "make png            PNG-Übersichten"
	@echo "make palette        Palette-CSV; erzeugt bei Bedarf einen MAME-Dump"
	@echo "make palette-dump   Laufzeitpalette mit MAME neu aufnehmen"
	@echo "make title-screen   Titelbild und vollständigen 162-Phasen-Palettenzyklus aufnehmen"
	@echo "make title-screen-neogeo 320x224-Titelbild auf max. 16 Farben je 16x16-Tile reduzieren"
	@echo "make levels         Karten als ASCII, vollständige PNGs und Playfield-only-PNGs"
	@echo "make level-tilesets eindeutige 16x16-Playfield-/MO-Tiles und 32x32-Indexmaps"
	@echo "make motion-trace   echte MO-Frames und Paletten über MAME protokollieren"
	@echo "make motion-catalog beobachtete Frames plus ROM-Energiestufen als 16x16-Atlas"
	@echo "make verify         Größen und Vollständigkeit prüfen"
	@echo "make clean          alle generierten Gauntlet-Assets entfernen"
