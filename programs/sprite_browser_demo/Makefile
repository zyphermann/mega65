PROGRAM := sprite_browser_demo
SOURCES := main.c data.s
GENERATED := generated/hud.bin generated/browser_data.h generated/.stamp
EXTRA_DEPS := $(GENERATED)
EXTRA_FLAGS := -C linker.cfg
CLEAN_FILES := generated/hud.bin generated/browser_data.h generated/.stamp

generated/.stamp: ../../assets/timeplt/tm6 ../../assets/timeplt/timeplt.e12 \
		../../assets/timeplt/timeplt.b4 ../../assets/timeplt/timeplt.b5 \
		../../tools/extract_timepilot_font.py ../../tools/build_timepilot_sprite_browser.py \
		../../shared/generated/time-pilot-sprites.bin
	@mkdir -p generated
	python3 ../../tools/build_timepilot_sprite_browser.py ../../assets/timeplt \
		generated/hud.bin generated/browser_data.h
	@touch $@

generated/hud.bin generated/browser_data.h: generated/.stamp

include ../../mk/program.mk
