PROGRAM := hud_tilemap_demo
SOURCES := main.c fcm_data.s
GENERATED := generated/gallery.bin generated/hud.bin generated/tilemap_data.h
EXTRA_DEPS := $(GENERATED)
EXTRA_FLAGS := -C linker.cfg
CLEAN_FILES := $(GENERATED)

$(GENERATED) &: ../../assets/timeplt/tm6 ../../assets/timeplt/timeplt.e12 \
		../../assets/timeplt/timeplt.b4 ../../assets/timeplt/timeplt.b5 \
		../../tools/extract_timepilot_font.py ../../tools/build_timepilot_tilemap_demo.py
	@mkdir -p generated
	python3 ../../tools/build_timepilot_tilemap_demo.py ../../assets/timeplt \
		generated/gallery.bin generated/hud.bin generated/tilemap_data.h

include ../../mk/program.mk
