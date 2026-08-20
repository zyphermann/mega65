SOURCE := ../assets/time-pilot-v2.png
NORMALIZED_MAP := generated/time-pilot-tiles.png
CLOUD_HEADER := generated/time-pilot-clouds.h

.PHONY: all clean

all: $(NORMALIZED_MAP) $(CLOUD_HEADER)

$(NORMALIZED_MAP): $(SOURCE) ../tools/normalize_tilemap.py ../tools/png_tile.py
	@mkdir -p generated
	python3 ../tools/normalize_tilemap.py $< $@ --scale 4 --color-key 255,0,255

$(CLOUD_HEADER): $(NORMALIZED_MAP) ../tools/time_pilot_clouds.py ../tools/png_tile.py
	python3 ../tools/time_pilot_clouds.py $< $@

clean:
	$(RM) $(NORMALIZED_MAP) $(CLOUD_HEADER)
