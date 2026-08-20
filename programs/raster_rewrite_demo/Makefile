PROGRAM := raster_rewrite_demo
SOURCES := main.c raster_irq.s
GENERATED_DIR := generated
GENERATED_HEADER := $(GENERATED_DIR)/directions.h
EXTRA_DEPS := $(GENERATED_HEADER)
CLEAN_FILES := $(GENERATED_HEADER)

$(GENERATED_HEADER): ../../shared/generated/time-pilot-tiles.png ../../tools/png_tile.py ../../tools/time_pilot_flight.py
	@mkdir -p $(GENERATED_DIR)
	python3 ../../tools/time_pilot_flight.py $< $@

include ../../mk/program.mk
