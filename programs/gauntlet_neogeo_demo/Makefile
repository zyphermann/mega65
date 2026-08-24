PYTHON ?= python3
MAME ?= mame
CURL ?= curl

ROOT := $(abspath ../..)
GAUNTLET := $(ROOT)/reverse-engineering/gauntlet/extracted
BUILD := $(CURDIR)/build
ROM := $(BUILD)/rom
VENDOR := $(BUILD)/vendor
BUILDER := $(CURDIR)/build_rom.py
CAPTURE := $(CURDIR)/capture.lua

NGDEVKIT_VERSION := 0.5+202607191609-1
NGDEVKIT_BOTTLE := $(VENDOR)/ngdevkit.tar.gz
NGDEVKIT_BOTTLE_SHA256 := c6d2aca0fffa8c3f8940b661b37ccb8f247c545e590e47098effee8ecc868daa
NGDEVKIT_BOTTLE_URL := https://github.com/dciabrin/homebrew-ngdevkit/releases/download/ngdevkit-$(NGDEVKIT_VERSION)/ngdevkit-0.5%2B202607191609-1.arm64_sonoma.bottle.tar.gz
NGDEVKIT_ROOT := $(VENDOR)/ngdevkit/$(NGDEVKIT_VERSION)
NGDEVKIT_STAMP := $(VENDOR)/.ngdevkit-extracted
NULLSOUND_IHX := $(NGDEVKIT_ROOT)/share/ngdevkit/nullsound_driver.ihx
NULLBIOS := $(NGDEVKIT_ROOT)/share/ngdevkit/neogeo.zip

PALETTE := $(GAUNTLET)/title-screen-neogeo-palettes.bin
ANIMATION_PALETTES_BIN := $(GAUNTLET)/title-screen-neogeo-animation-palettes.bin
ANIMATION_PALETTES_CSV := $(GAUNTLET)/title-screen-neogeo-animation-palettes.csv
TILEMAP := $(GAUNTLET)/title-screen-neogeo-tilemap.bin
C1_INPUT := $(GAUNTLET)/title-screen-neogeo-c1.bin
C2_INPUT := $(GAUNTLET)/title-screen-neogeo-c2.bin

ROM_FILES := $(ROM)/gtdemo-p1.p1 $(ROM)/gtdemo-s1.s1 \
	$(ROM)/gtdemo-m1.m1 $(ROM)/gtdemo-v1.v1 \
	$(ROM)/gtdemo-c1.c1 $(ROM)/gtdemo-c2.c2
OUTPUTS := $(ROM_FILES) $(ROM)/gaunttitle.zip $(ROM)/neogeo.xml \
	$(ROM)/manifest.json

.NOTPARALLEL:
.PHONY: all assets roms bios run smoke verify clean help

all: roms bios verify

assets: $(PALETTE) $(ANIMATION_PALETTES_BIN) $(ANIMATION_PALETTES_CSV) $(TILEMAP) $(C1_INPUT) $(C2_INPUT)

$(PALETTE) $(ANIMATION_PALETTES_BIN) $(ANIMATION_PALETTES_CSV) $(TILEMAP) $(C1_INPUT) $(C2_INPUT):
	$(MAKE) -C $(ROOT)/reverse-engineering/gauntlet title-screen-neogeo

roms: $(OUTPUTS)

bios: $(ROM)/neogeo.zip

$(NGDEVKIT_BOTTLE):
	@mkdir -p $(VENDOR)
	$(CURL) -L --fail --silent --show-error $(NGDEVKIT_BOTTLE_URL) -o $@
	@echo "$(NGDEVKIT_BOTTLE_SHA256)  $@" | shasum -a 256 -c -

$(NGDEVKIT_STAMP): $(NGDEVKIT_BOTTLE)
	@mkdir -p $(VENDOR)
	tar -xzf $(NGDEVKIT_BOTTLE) -C $(VENDOR)
	@test -s $(NULLSOUND_IHX) -a -s $(NULLBIOS)
	@touch $@

$(OUTPUTS): $(BUILDER) $(PALETTE) $(ANIMATION_PALETTES_BIN) $(ANIMATION_PALETTES_CSV) $(TILEMAP) $(C1_INPUT) $(C2_INPUT) $(NGDEVKIT_STAMP)
	@mkdir -p $(ROM)
	$(PYTHON) $(BUILDER) --palette $(PALETTE) --tilemap $(TILEMAP) \
		--animation-palettes-csv $(ANIMATION_PALETTES_CSV) \
		--c1 $(C1_INPUT) --c2 $(C2_INPUT) \
		--nullsound-ihx $(NULLSOUND_IHX) --output $(ROM)

$(ROM)/neogeo.zip: $(NGDEVKIT_STAMP)
	@mkdir -p $(ROM)
	cp $(NULLBIOS) $@

verify: roms bios
	@test "$$(wc -c < $(ROM)/gtdemo-p1.p1 | tr -d ' ')" -eq 1048576
	@test "$$(wc -c < $(ROM)/gtdemo-s1.s1 | tr -d ' ')" -eq 131072
	@test "$$(wc -c < $(ROM)/gtdemo-v1.v1 | tr -d ' ')" -eq 524288
	@test "$$(wc -c < $(ROM)/gtdemo-c1.c1 | tr -d ' ')" -eq 524288
	@test "$$(wc -c < $(ROM)/gtdemo-c2.c2 | tr -d ' ')" -eq 524288
	@unzip -tq $(ROM)/gaunttitle.zip >/dev/null
	@$(PYTHON) -c 'import json; m=json.load(open("$(ROM)/manifest.json")); assert m["title_tile_base"] == 256; assert m["title_tiles"] == 278; assert m["palette_animation"]["phases"] == 162; assert m["palette_animation"]["tracks"] == 20; assert m["palette_animation"]["palette_entries"] == 91'
	@echo "Neo-Geo-ROMs geprüft: $(ROM)/gaunttitle.zip"

run: all
	$(MAME) -window -skip_gameinfo -noautosave -hash $(ROM) -rp $(ROM) \
		neogeo -cart1 gaunttitle

smoke: all
	@mkdir -p $(BUILD)/cfg $(BUILD)/nvram $(BUILD)/snap $(BUILD)/home
	SDL_VIDEODRIVER=dummy NEOGEO_DEMO_SNAPSHOT=$(BUILD)/gauntlet-neogeo-demo.png \
		NEOGEO_DEMO_PHASE_SNAPSHOT=$(BUILD)/gauntlet-neogeo-demo-phase.png \
		NEOGEO_DEMO_CYCLE_SNAPSHOT=$(BUILD)/gauntlet-neogeo-demo-cycle.png \
		$(MAME) -skip_gameinfo -noautosave -hash $(ROM) -rp $(ROM) \
		-cfg_directory $(BUILD)/cfg -nvram_directory $(BUILD)/nvram \
		-snapshot_directory $(BUILD)/snap -homepath $(BUILD)/home \
		-video none -sound none -nothrottle -autoboot_script $(CAPTURE) \
		-seconds_to_run 12 neogeo -cart1 gaunttitle
	@test -s $(BUILD)/gauntlet-neogeo-demo.png
	@test -s $(BUILD)/gauntlet-neogeo-demo-phase.png
	@test -s $(BUILD)/gauntlet-neogeo-demo-cycle.png
	@PYTHONPATH=$(ROOT)/tools $(PYTHON) -c 'from pathlib import Path; from index_png import read_rgb_png; a=read_rgb_png(Path("$(BUILD)/gauntlet-neogeo-demo.png")); b=read_rgb_png(Path("$(BUILD)/gauntlet-neogeo-demo-phase.png")); c=read_rgb_png(Path("$(BUILD)/gauntlet-neogeo-demo-cycle.png")); assert a[:2] == b[:2] == c[:2] == (320,224); assert sum(value != 0 for value in a[2]) > 10000; assert sum(x != y for x,y in zip(a[2],b[2])) > 100; assert a[2] == c[2]'
	@echo "MAME bestätigt Animation und exakte Wiederholung nach 486 Frames."

clean:
	$(RM) -r $(BUILD)

help:
	@echo "make        Cartridge-ROMs, nullbios und Prüfungen bauen"
	@echo "make smoke  ROM headless booten und den 486-Frame-Palettenzyklus prüfen"
	@echo "make run    Demo interaktiv in MAME starten"
	@echo "make clean  generiertes build/-Verzeichnis entfernen"
