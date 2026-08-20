CC := cl65
TARGET := mega65
SHARED_DIR := ../../shared
SHARED_SOURCES := $(wildcard $(SHARED_DIR)/*.c)
SHARED_HEADERS := $(wildcard $(SHARED_DIR)/*.h)
OUTPUT := ../../build/$(PROGRAM).prg
MAP := ../../build/$(PROGRAM).map
EXTRA_DEPS ?=
CLEAN_FILES ?=
EXTRA_FLAGS ?=

.PHONY: all clean

all: $(OUTPUT)

$(OUTPUT): $(SOURCES) $(SHARED_SOURCES) $(SHARED_HEADERS) $(EXTRA_DEPS)
	@mkdir -p ../../build
	$(CC) --target $(TARGET) -O -I $(SHARED_DIR) $(EXTRA_FLAGS) -Wl -m,$(MAP) -o $@ $(SOURCES) $(SHARED_SOURCES)

clean:
	$(RM) $(OUTPUT) $(MAP) $(CLEAN_FILES)
