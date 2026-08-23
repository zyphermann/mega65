PROGRAM := timepilot
SOURCES := main.c object_model.c timepilot_layout.c hud.c hud_data.s ../raster_rewrite_demo/raster_irq.s
GENERATED_DIR := generated
GENERATED_HEADER := $(GENERATED_DIR)/object_directions.h
SCORE_GENERATED := $(GENERATED_DIR)/score.bin $(GENERATED_DIR)/shot_table.bin \
	$(GENERATED_DIR)/score_data.h
EXTRA_DEPS := $(GENERATED_HEADER) $(SCORE_GENERATED) ../../shared/generated/time-pilot-clouds.h linker.cfg
CLEAN_FILES := $(wildcard $(GENERATED_DIR)/*.h) $(GENERATED_HEADER) $(SCORE_GENERATED)
EXTRA_FLAGS := -C linker.cfg
# This program's OBJECT linker area is deliberately tight. Aggressive cc65
# inlining currently grows it beyond the fixed region; retain compact release
# optimisation until that layout is reorganised.
RELEASE_FLAGS := -O

$(GENERATED_HEADER): ../../shared/generated/time-pilot-tiles.png ../../tools/png_tile.py ../../tools/time_pilot_flight.py
	@mkdir -p $(GENERATED_DIR)
	python3 ../../tools/time_pilot_flight.py $< $@ --segment FLIGHTDATA

$(SCORE_GENERATED) &: ../../assets/timeplt/tm1 ../../assets/timeplt/tm2 \
		../../assets/timeplt/tm3 ../../assets/timeplt/tm6 ../../assets/timeplt/timeplt.e12 \
		../../assets/timeplt/timeplt.b4 ../../assets/timeplt/timeplt.b5 \
		../../tools/extract_timepilot_font.py ../../tools/build_timepilot_score.py
	@mkdir -p $(GENERATED_DIR)
	python3 ../../tools/build_timepilot_score.py ../../assets/timeplt \
		$(GENERATED_DIR)/score.bin $(GENERATED_DIR)/shot_table.bin \
		$(GENERATED_DIR)/score_data.h

include ../../mk/program.mk
