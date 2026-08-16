# C -> DMA machine, in one command: `make run`.
# See README.md; the toolchain details live in prompts/007-phase4-results.md.

REPO    := ../..
SKU     ?= rp2350
PROG    ?= primes
DUMPS   ?= -dump nprimes -dump primes:46
# The picolibc IR goldens (printf & friends); `make libc` at the repo
# root regenerates them. Drop this for a libc-free program.
LIBC_LL := $(wildcard $(REPO)/libc/ll/*.ll)

# The front half is stock clang. Keep these flags: -O1 puts the IR in the
# form dmacc expects, -fsigned-char keeps char semantics identical to the
# differential-test hosts. The -I paths provide picolibc's headers.
CLANG_FLAGS := --target=armv6m-none-eabi -O1 -fno-unroll-loops \
               -fsigned-char -ffreestanding -nostdinc \
               -I$(REPO)/libc -I$(REPO)/libc/include \
               -I$(REPO)/lib/picolibc/libc/include \
               -I$(shell clang -print-resource-dir)/include

.PHONY: run dasm dmx clean

run: build/$(PROG).ll $(REPO)/bin/dmacc
	$(REPO)/bin/dmacc -sku $(SKU) -run $(DUMPS) build/$(PROG).ll $(LIBC_LL)

# Inspect the generated assembly.
dasm: build/$(PROG).ll $(REPO)/bin/dmacc
	$(REPO)/bin/dmacc -o build/$(PROG).dasm build/$(PROG).ll $(LIBC_LL)

# Produce a loadable DMX executable (doc/dmx.md) for the target loader.
dmx: build/$(PROG).ll $(REPO)/bin/dmacc
	$(REPO)/bin/dmacc -sku $(SKU) -o build/$(PROG).dasm -dmx build/$(PROG).dmx build/$(PROG).ll $(LIBC_LL)

build/%.ll: %.c
	@mkdir -p build
	clang $(CLANG_FLAGS) -S -emit-llvm $< -o $@

$(REPO)/bin/dmacc:
	$(MAKE) -C $(REPO) build

clean:
	rm -rf build
