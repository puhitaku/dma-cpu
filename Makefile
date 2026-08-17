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

# --- libc (Phase 4.5): picolibc through the dmacc pipeline ---
# Compiles the curated picolibc sources (integer-only stdio + string) to
# IR goldens in libc/ll/, which are committed and linked into programs by
# passing them to dmacc alongside the program's own .ll. Regenerate after
# changing libc/picolibc.h, libc/dma_stdio.c, or the submodule pin.
PICOLIBC := lib/picolibc
LIBC_STDIO := printf vfiprintf puts putchar fputs fputc \
              sprintf snprintf vsnprintf filestrput
LIBC_STRING := strlen strnlen strcmp strncmp strcpy strncpy strchr memchr memcmp
LIBC_CLANG = clang --target=armv6m-none-eabi $(LLGEN_FLAGS) -ffreestanding \
             -nostdinc -I$(CURDIR)/libc -I$(CURDIR)/libc/include \
             -I$(CURDIR)/$(PICOLIBC)/libc/include -I$(CURDIR)/$(PICOLIBC)/libc/locale \
             -I$(shell clang -print-resource-dir)/include -S -emit-llvm

.PHONY: libc
libc:
	@mkdir -p libc/ll
	$(LIBC_CLANG) libc/dma_stdio.c -o libc/ll/dma_stdio.ll
	@for f in $(LIBC_STDIO); do \
	  (cd $(PICOLIBC)/libc/stdio && $(LIBC_CLANG) $$f.c -o $(CURDIR)/libc/ll/$$f.ll) || exit 1; done
	@for f in $(LIBC_STRING); do \
	  (cd $(PICOLIBC)/libc/string && $(LIBC_CLANG) $$f.c -o $(CURDIR)/libc/ll/$$f.ll) || exit 1; done
	@echo "libc/ll: $$(ls libc/ll | wc -l | tr -d ' ') modules"

# --- xv6 port (xv6/PORT.md): compile vendored sources to IR goldens ---
# The curated list grows as the port proceeds; goldens in xv6/ll are
# committed and linked by dmacc like the libc ones.
XV6_SRCS = kernel/string.c user/umalloc.c user/ulib.c user/printf.c user/echo.c user/sh.c \
           user/cat.c user/ls.c user/wc.c \
           dma/usys.c dma/kproc.c dma/kfsstub.c dma/syncprog.c \
           dma/killprog.c dma/spin.c dma/trap.c
XV6_CLANG = clang --target=armv6m-none-eabi $(LLGEN_FLAGS) -ffreestanding \
            -I$(CURDIR)/xv6 -S -emit-llvm

# Kernel-side fs sources compile VERBATIM against the shim headers in
# xv6/dma/shim (no-op locks, pointer-into-disk bufs, fs-view proc): the
# shadow copy makes quoted includes resolve shim-first, then upstream.
XV6_FS_SRCS = fs.c file.c
# DMA-side fs glue, compiled against the same shim-first include order.
XV6_FSGLUE_SRCS = kbio.c kfsglue.c kpipe.c kflash.c

.PHONY: xv6-ll
xv6-ll:
	@mkdir -p xv6/ll
	@for f in $(XV6_SRCS); do \
	  out=xv6/ll/$$(basename $$f .c).ll; \
	  (cd xv6 && $(XV6_CLANG) $$f -o $(CURDIR)/$$out) || exit 1; \
	  echo "  $$f -> $$out"; \
	done
	@mkdir -p bin/utshadow/kernel bin/utshadow/user
	@for f in param.h types.h stat.h fs.h fcntl.h syscall.h; do cp xv6/kernel/$$f bin/utshadow/kernel/; done
	@cp xv6/dma/shim/riscv.h xv6/dma/shim/memlayout.h bin/utshadow/kernel/
	@cp xv6/user/user.h bin/utshadow/user/ && cp xv6/user/usertests.c bin/utshadow/
	@(cd bin/utshadow && clang --target=armv6m-none-eabi $(LLGEN_FLAGS) -ffreestanding \
	  -I. -S -emit-llvm usertests.c -o $(CURDIR)/xv6/ll/usertests.ll) && echo "  user/usertests.c (shimmed riscv/memlayout) -> xv6/ll/usertests.ll"
	@mkdir -p bin/fsshadow
	@for f in $(XV6_FS_SRCS); do \
	  cp xv6/kernel/$$f bin/fsshadow/ && \
	  (cd bin/fsshadow && clang --target=armv6m-none-eabi $(LLGEN_FLAGS) -ffreestanding \
	    -I$(CURDIR)/xv6/dma/shim -I$(CURDIR)/xv6/kernel -S -emit-llvm \
	    $$f -o $(CURDIR)/xv6/ll/k$$(basename $$f .c).ll) || exit 1; \
	  echo "  kernel/$$f (shimmed) -> xv6/ll/k$$(basename $$f .c).ll"; \
	done
	@for f in $(XV6_FSGLUE_SRCS); do \
	  (cd xv6/dma && clang --target=armv6m-none-eabi $(LLGEN_FLAGS) -ffreestanding \
	    -I$(CURDIR)/xv6/dma/shim -I$(CURDIR)/xv6/kernel -S -emit-llvm \
	    $$f -o $(CURDIR)/xv6/ll/$$(basename $$f .c).ll) || exit 1; \
	  echo "  dma/$$f -> xv6/ll/$$(basename $$f .c).ll"; \
	done

# --- Compiler goldens (Phase 4) ---
# Regenerate the committed IR goldens and host-truth expectations for the
# dmacc differential tests. Needs a host clang. The target IR and the
# host build both use -fsigned-char so `char` semantics agree (plain
# char is unsigned on arm-none-eabi but signed on the host).
CC_TESTS = arith control memory func bits collatz recurse
CC_STDIO_TESTS = stdio
LLGEN_FLAGS = -Oz -fno-unroll-loops -fsigned-char

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
	@# stdio differential goldens: host stdout is the expected console,
	@# the exit value arrives via stderr so the streams don't mix.
	@printf '#include <stdio.h>\nint testmain(void);\nint main(void){int r=testmain();fflush(stdout);fprintf(stderr,"%%d\\n",r);return 0;}\n' > bin/llgen_sdriver.c
	@for f in $(CC_STDIO_TESTS); do \
	  (cd dmacc/testdata && $(LIBC_CLANG) $$f.c -o $$f.ll) && \
	  clang $(LLGEN_FLAGS) -Dmain=testmain -c dmacc/testdata/$$f.c -o bin/llgen_$$f.o && \
	  clang bin/llgen_$$f.o bin/llgen_sdriver.c -o bin/llgen_$$f && \
	  ./bin/llgen_$$f > dmacc/testdata/$$f.console 2> bin/llgen_$$f.exit && \
	  echo "$$f $$(cat bin/llgen_$$f.exit)" > dmacc/testdata/$$f.expected || exit 1; \
	done
	@cat dmacc/testdata/*.expected 2>/dev/null || true
	@# Target-only programs (no host truth: infinite loops / hardware IO).
	clang --target=armv6m-none-eabi $(LLGEN_FLAGS) -ffreestanding -S -emit-llvm \
	  dmacc/testdata/proc.c -o dmacc/testdata/proc.ll
	(cd dmacc/testdata && $(LIBC_CLANG) shell.c -o shell.ll)
	clang --target=armv6m-none-eabi $(LLGEN_FLAGS) -ffreestanding -I$(CURDIR)/xv6 \
	  -S -emit-llvm dmacc/testdata/xv6malloc.c -o dmacc/testdata/xv6malloc.ll
	@for f in xv6sys xv6proc xv6spawn xv6hello xv6readline xv6kill xv6sig; do \
	  clang --target=armv6m-none-eabi $(LLGEN_FLAGS) -ffreestanding -I$(CURDIR)/xv6 \
	    -S -emit-llvm dmacc/testdata/$$f.c -o dmacc/testdata/$$f.ll || exit 1; done

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
