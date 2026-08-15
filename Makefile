# DMA-CPU build/test entry points (see prompts/overview.md, Phase 0).

.PHONY: all build test vet clean test-hw

all: build

build:
	go build -o dmaemu ./cmd/dmaemu

test: vet
	go test ./...

vet:
	go vet ./...

clean:
	rm -f dmaemu

# --- Hardware-in-the-loop (see prompts/004-hw-calibration.md) ---
# Environment (adjust to your install):
PICO_SDK_PATH ?= $(HOME)/.pico-sdk/sdk/2.3.0
PICO_TOOLS ?= $(HOME)/.pico-sdk/toolchain/15_2_Rel1/bin:$(HOME)/.pico-sdk/cmake/v4.3.4/bin:$(HOME)/.pico-sdk/ninja/v1.13.2
HIL_SKU ?= rp2350

.PHONY: images firmware

# Regenerate the embedded test images + expectations from the emulator.
images:
	go run ./cmd/dmxgen -sku $(HIL_SKU) -o target/firmware/generated/images.h

firmware: images
	PATH="$(PICO_TOOLS):$$PATH" PICO_SDK_PATH=$(PICO_SDK_PATH) \
	  cmake -S target/firmware -B target/firmware/build -G Ninja -DPICO_BOARD=pico2
	PATH="$(PICO_TOOLS):$$PATH" ninja -C target/firmware/build

# Flash with OpenOCD over a Debug Probe, then watch the UART (115200) for
# TEST/CAL lines. Automated capture-and-diff is a future CI stage.
test-hw: firmware
	openocd -f interface/cmsis-dap.cfg -c "adapter speed 5000" -f target/rp2350.cfg \
	  -c "program target/firmware/build/dma_hil.elf verify reset exit"
