PROGRAM := tile_demo
SOURCES := main.c
GENERATED_HEADER := generated/time_pilot_tile0.h
EXTRA_DEPS := $(GENERATED_HEADER)
CLEAN_FILES := $(GENERATED_HEADER)

$(GENERATED_HEADER): ../../shared/generated/time-pilot-tiles.png ../../tools/png_tile.py
	@mkdir -p generated
	python3 ../../tools/png_tile.py $< $@ --tile-x 8 --tile-y 14 --name tile

include ../../mk/program.mk
