PROGRAM := cloud_multiplex_demo
SOURCES := main.c ../raster_rewrite_demo/raster_irq.s
EXTRA_DEPS := ../../shared/generated/time-pilot-clouds.h
GENERATED_DIRECTIONS := generated/directions.h
EXTRA_DEPS += $(GENERATED_DIRECTIONS) linker.cfg
CLEAN_FILES := $(GENERATED_DIRECTIONS) generated/plane.h
EXTRA_FLAGS := -C linker.cfg

$(GENERATED_DIRECTIONS): ../../shared/generated/time-pilot-tiles.png ../../tools/png_tile.py ../../tools/time_pilot_flight.py
	@mkdir -p generated
	python3 ../../tools/time_pilot_flight.py $< $@ --segment FLIGHTDATA

include ../../mk/program.mk
