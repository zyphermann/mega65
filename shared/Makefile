SOURCE := ../assets/time-pilot-v2.png
NORMALIZED_MAP := generated/time-pilot-tiles.png
CLOUD_HEADER := generated/time-pilot-clouds.h
FONT_BIN := generated/time-pilot-font.bin
FONT_PREVIEW := generated/time-pilot-font.png
FONT_HEADER := generated/time-pilot-font.h
FONT_PALETTE_DIR := generated/time-pilot-font-palettes
FONT_PALETTE_STAMP := $(FONT_PALETTE_DIR)/.stamp
SPRITE_BIN := generated/time-pilot-sprites.bin
SPRITE_PREVIEW := generated/time-pilot-sprites.png
SPRITE_HEADER := generated/time-pilot-sprites.h
SPRITE_STAMP := generated/.time-pilot-sprites.stamp

.PHONY: all clean

all: $(NORMALIZED_MAP) $(CLOUD_HEADER) $(FONT_PALETTE_STAMP) $(SPRITE_STAMP)

$(NORMALIZED_MAP): $(SOURCE) ../tools/normalize_tilemap.py ../tools/png_tile.py
	@mkdir -p generated
	python3 ../tools/normalize_tilemap.py $< $@ --scale 4 --color-key 255,0,255

$(CLOUD_HEADER): $(NORMALIZED_MAP) ../tools/time_pilot_clouds.py ../tools/png_tile.py
	python3 ../tools/time_pilot_clouds.py $< $@

$(FONT_PALETTE_STAMP): \
		../assets/timeplt/tm6 ../assets/timeplt/timeplt.b4 \
		../assets/timeplt/timeplt.b5 ../assets/timeplt/timeplt.e12 \
		../tools/extract_timepilot_font.py
	python3 ../tools/extract_timepilot_font.py ../assets/timeplt \
		$(FONT_BIN) $(FONT_PREVIEW) $(FONT_HEADER) \
		--palette-dir $(FONT_PALETTE_DIR)

$(SPRITE_STAMP): \
		../assets/timeplt/tm4 ../assets/timeplt/tm5 \
		../tools/extract_timepilot_sprites.py
	python3 ../tools/extract_timepilot_sprites.py ../assets/timeplt \
		$(SPRITE_BIN) $(SPRITE_PREVIEW) $(SPRITE_HEADER)
	@touch $@

clean:
	$(RM) $(NORMALIZED_MAP) $(CLOUD_HEADER) $(FONT_BIN) $(FONT_PREVIEW) $(FONT_HEADER)
	$(RM) $(SPRITE_BIN) $(SPRITE_PREVIEW) $(SPRITE_HEADER)
	$(RM) $(SPRITE_STAMP)
	$(RM) -r $(FONT_PALETTE_DIR)
