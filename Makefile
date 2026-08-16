# DMA-CPU build/test entry points (see prompts/overview.md, Phase 0).

.PHONY: all build test vet clean test-hw

all: build

build:
	go build -o bin/dmaemu ./cmd/dmaemu
	go build -o bin/dmaasm ./cmd/dmaasm
	go build -o bin/dmacc ./cmd/dmacc

test: vet
	go test ./...

vet:
	go vet ./...

clean:
	rm -rf bin

# --- Compiler goldens (Phase 4) ---
# Regenerate the committed IR goldens and host-truth expectations for the
# dmacc differential tests. Needs a host clang. The target IR and the
# host build both use -fsigned-char so `char` semantics agree (plain
# char is unsigned on arm-none-eabi but signed on the host).
CC_TESTS = arith control memory func bits collatz recurse
LLGEN_FLAGS = -O1 -fno-unroll-loops -fsigned-char

.PHONY: llgen
llgen:
	@mkdir -p bin
	@printf '#include <stdio.h>\nint testmain(void);\nint main(void){printf("%%d\\n", testmain());return 0;}\n' > bin/llgen_driver.c
	@: > dmacc/testdata/expected.txt
	@for f in $(CC_TESTS); do \
	  clang --target=armv6m-none-eabi $(LLGEN_FLAGS) -ffreestanding -S -emit-llvm \
	    dmacc/testdata/$$f.c -o dmacc/testdata/$$f.ll || exit 1; \
	  if [ $$f != recurse ]; then \
	    clang $(LLGEN_FLAGS) -Dmain=testmain -c dmacc/testdata/$$f.c -o bin/llgen_$$f.o && \
	    clang bin/llgen_$$f.o bin/llgen_driver.c -o bin/llgen_$$f && \
	    echo "$$f $$(./bin/llgen_$$f)" >> dmacc/testdata/expected.txt || exit 1; \
	  fi; \
	done
	@cat dmacc/testdata/expected.txt

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
