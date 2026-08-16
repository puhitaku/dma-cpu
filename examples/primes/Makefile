# C -> DMA machine, in one command: `make run`.
# See README.md; the toolchain details live in prompts/007-phase4-results.md.

REPO   := ../..
SKU    ?= rp2350
PROG   ?= primes
DUMPS  ?= -dump nprimes -dump primes:46

# The front half is stock clang. Keep these flags: -O1 puts the IR in the
# form dmacc expects, -fsigned-char keeps char semantics identical to the
# differential-test hosts.
CLANG_FLAGS := --target=armv6m-none-eabi -O1 -fno-unroll-loops \
               -fsigned-char -ffreestanding

.PHONY: run dasm dmx clean

run: build/$(PROG).ll $(REPO)/bin/dmacc
	$(REPO)/bin/dmacc -sku $(SKU) -run $(DUMPS) build/$(PROG).ll

# Inspect the generated assembly.
dasm: build/$(PROG).ll $(REPO)/bin/dmacc
	$(REPO)/bin/dmacc -o build/$(PROG).dasm build/$(PROG).ll

# Produce a loadable DMX executable (doc/dmx.md) for the target loader.
dmx: build/$(PROG).ll $(REPO)/bin/dmacc
	$(REPO)/bin/dmacc -sku $(SKU) -o build/$(PROG).dasm -dmx build/$(PROG).dmx build/$(PROG).ll

build/%.ll: %.c
	@mkdir -p build
	clang $(CLANG_FLAGS) -S -emit-llvm $< -o $@

$(REPO)/bin/dmacc:
	$(MAKE) -C $(REPO) build

clean:
	rm -rf build
