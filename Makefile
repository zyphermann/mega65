XMEGA65 ?= xmega65
BUILD_DIR := build
PROGRAM ?= hello_world
PROGRAM_DIRS := $(sort $(dir $(wildcard programs/*/Makefile)))
PROGRAM_OUTPUTS := $(foreach dir,$(PROGRAM_DIRS),$(BUILD_DIR)/$(notdir $(patsubst %/,%,$(dir))).prg)

.PHONY: all clean check-toolchain shared-assets run disassemble FORCE

all: check-toolchain shared-assets $(PROGRAM_OUTPUTS)

shared-assets:
	$(MAKE) --no-print-directory -C shared all

check-toolchain:
	@command -v cl65 >/dev/null || { \
		echo "cl65 fehlt. Installiere den aktuellen cc65-Stand (siehe README.md)."; \
		exit 1; \
	}
	@cl65 --print-target-path | xargs -I{} test -d {}/mega65 || { \
		echo "Das installierte cc65 kennt das Target 'mega65' nicht."; \
		echo "Installiere cc65 aus dem aktuellen Git-Stand (siehe README.md)."; \
		exit 1; \
	}

$(BUILD_DIR)/%.prg: programs/%/Makefile FORCE | shared-assets
	@mkdir -p $(BUILD_DIR)
	$(MAKE) --no-print-directory -C programs/$* all

FORCE:

run: all
	@command -v $(XMEGA65) >/dev/null || { \
		echo "xmega65 fehlt. Installationshinweise stehen in README.md."; \
		exit 1; \
	}
	@test -f $(BUILD_DIR)/$(PROGRAM).prg || { \
		echo "Unbekanntes Programm: $(PROGRAM)"; \
		exit 1; \
	}
	$(XMEGA65) -prg $(BUILD_DIR)/$(PROGRAM).prg

disassemble:
	python3 tools/disassemble_timepilot.py \
		--rom-dir assets/timeplt \
		--symbols reverse-engineering/timepilot/hardware.sym \
		--output reverse-engineering/timepilot/timepilot-main.asm \
		--symbol-output reverse-engineering/timepilot/timepilot-main.symbols

clean:
	@for dir in $(PROGRAM_DIRS); do $(MAKE) --no-print-directory -C $$dir clean; done
	$(MAKE) --no-print-directory -C shared clean
	rm -rf $(BUILD_DIR)
