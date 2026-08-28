# DMA-CPU build/test entry points (see prompts/overview.md, Phase 0).

.PHONY: all build test vet fmt clean test-hw

all: build

build:
	go build -o bin/dmaemu ./host/cmd/dmaemu
	go build -o bin/dmaasm ./host/cmd/dmaasm
	go build -o bin/dmacc ./host/cmd/dmacc

test: fmt vet
	go test ./...

# gofmt's output is the house style, always — run `gofmt -w ./host` to
# fix. Checked here so a hand-aligned struct or comment can never drift
# the tree out of format again.
fmt:
	@out=$$(gofmt -l ./host); \
	  if [ -n "$$out" ]; then \
	    echo "gofmt: not formatted (run gofmt -w ./host):"; \
	    echo "$$out"; exit 1; \
	  fi

vet:
	go vet ./...

clean:
	rm -rf bin

# --- libc (Phase 4.5): picolibc through the dmacc pipeline ---
# Compiles the curated picolibc sources (integer-only stdio + string) to
# IR goldens in target/libc/ll/, which are committed and linked into programs by
# passing them to dmacc alongside the program's own .ll. Regenerate after
# changing target/libc/picolibc.h, target/libc/dma_stdio.c, or the submodule pin.
PICOLIBC := target/libc/picolibc
LIBC_STDIO := printf vfiprintf puts putchar fputs fputc \
              sprintf snprintf vsnprintf filestrput
LIBC_STRING := strlen strnlen strcmp strncmp strcpy strncpy strchr memchr memcmp
LIBC_CLANG = clang --target=armv6m-none-eabi $(LLGEN_FLAGS) -ffreestanding \
             -nostdinc -I$(CURDIR)/target/libc -I$(CURDIR)/target/libc/include \
             -I$(CURDIR)/$(PICOLIBC)/libc/include -I$(CURDIR)/$(PICOLIBC)/libc/locale \
             -I$(shell clang -print-resource-dir)/include -S -emit-llvm

.PHONY: libc
libc:
	@mkdir -p target/libc/ll
	$(LIBC_CLANG) target/libc/dma_stdio.c -o target/libc/ll/dma_stdio.ll
	@for f in $(LIBC_STDIO); do \
	  (cd $(PICOLIBC)/libc/stdio && $(LIBC_CLANG) $$f.c -o $(CURDIR)/target/libc/ll/$$f.ll) || exit 1; done
	@for f in $(LIBC_STRING); do \
	  (cd $(PICOLIBC)/libc/string && $(LIBC_CLANG) $$f.c -o $(CURDIR)/target/libc/ll/$$f.ll) || exit 1; done
	@echo "target/libc/ll: $$(ls target/libc/ll | wc -l | tr -d ' ') modules"

# --- xv6 port (xv6/PORT.md): compile vendored sources to IR goldens ---
# The curated list grows as the port proceeds; goldens in target/xv6/ll are
# committed and linked by dmacc like the libc ones.
XV6_SRCS = kernel/string.c user/umalloc.c user/ulib.c user/printf.c user/echo.c user/sh.c \
           user/cat.c user/ls.c user/wc.c user/vi.c \
           user/toolbox.c user/hwtools.c user/fbtest.c user/show.c \
           user/spin.c user/killprog.c user/syncprog.c user/trap.c \
           dma/usys.c dma/kproc.c dma/kcons.c dma/kconsstub.c dma/kgpio.c dma/kfb.c dma/kfbcon.c \
           dma/kfbstub.c dma/kdma.c dma/ksd.c dma/kfsstub.c dma/calflash.c
XV6_CLANG = clang --target=armv6m-none-eabi $(LLGEN_FLAGS) -ffreestanding \
            -I$(CURDIR)/target/xv6 -S -emit-llvm

# Kernel-side fs sources compile VERBATIM against the shim headers in
# target/xv6/dma/shim (no-op locks, pointer-into-disk bufs, fs-view proc): the
# shadow copy makes quoted includes resolve shim-first, then upstream.
XV6_FS_SRCS = fs.c file.c
# DMA-side fs glue, compiled against the same shim-first include order.
XV6_FSGLUE_SRCS = kbio.c kfsglue.c kpipe.c kflash.c kfat.c kdev.c

.PHONY: xv6-ll
xv6-ll:
	@mkdir -p target/xv6/ll
	@for f in $(XV6_SRCS); do \
	  out=target/xv6/ll/$$(basename $$f .c).ll; \
	  (cd target/xv6 && $(XV6_CLANG) $$f -o $(CURDIR)/$$out) || exit 1; \
	  echo "  $$f -> $$out"; \
	done
	@mkdir -p bin/utshadow/kernel bin/utshadow/user
	@for f in param.h types.h stat.h fs.h fcntl.h syscall.h; do cp target/xv6/kernel/$$f bin/utshadow/kernel/; done
	@cp target/xv6/dma/shim/riscv.h target/xv6/dma/shim/memlayout.h bin/utshadow/kernel/
	@cp target/xv6/user/user.h bin/utshadow/user/ && cp target/xv6/user/usertests.c bin/utshadow/
	@(cd bin/utshadow && clang --target=armv6m-none-eabi $(LLGEN_FLAGS) -ffreestanding \
	  -I. -S -emit-llvm usertests.c -o $(CURDIR)/target/xv6/ll/usertests.ll) && echo "  user/usertests.c (shimmed riscv/memlayout) -> target/xv6/ll/usertests.ll"
	@mkdir -p bin/fsshadow
	@for f in $(XV6_FS_SRCS); do \
	  vfs=""; if [ $$f = file.c ]; then vfs=-DDMA_VFS_CALLS; fi; \
	  cp target/xv6/kernel/$$f bin/fsshadow/ && \
	  (cd bin/fsshadow && clang --target=armv6m-none-eabi $(LLGEN_FLAGS) -ffreestanding \
	    -I$(CURDIR)/target/xv6/dma/shim -I$(CURDIR)/target/xv6/kernel $$vfs -S -emit-llvm \
	    $$f -o $(CURDIR)/target/xv6/ll/k$$(basename $$f .c).ll) || exit 1; \
	  echo "  kernel/$$f (shimmed) -> target/xv6/ll/k$$(basename $$f .c).ll"; \
	done
	@for f in $(XV6_FSGLUE_SRCS); do \
	  (cd target/xv6/dma && clang --target=armv6m-none-eabi $(LLGEN_FLAGS) -ffreestanding \
	    -I$(CURDIR)/target/xv6/dma/shim -I$(CURDIR)/target/xv6/kernel -S -emit-llvm \
	    $$f -o $(CURDIR)/target/xv6/ll/$$(basename $$f .c).ll) || exit 1; \
	  echo "  dma/$$f -> target/xv6/ll/$$(basename $$f .c).ll"; \
	done

# gamepico bare-metal sources -> IR (no xv6 headers; self-contained).
GAME_SRCS = grt.c lcd.c gfx.c input.c fx.c seq.c cpumon.c bench.c radio.c menu.c dino.c lanwalk.c yacht.c boing.c chute.c puni.c gmain.c

.PHONY: game-ll
game-ll:
	@mkdir -p target/game/ll
	@for f in $(GAME_SRCS); do \
	  (cd target/game/src && clang --target=armv6m-none-eabi $(LLGEN_FLAGS) -ffreestanding \
	    -S -emit-llvm $$f -o $(CURDIR)/target/game/ll/$$(basename $$f .c).ll) || exit 1; \
	  echo "  target/game/src/$$f -> target/game/ll/$$(basename $$f .c).ll"; \
	done

# --- Profile-guided settings (prompts/042 §1) ---
# Boots every deployable payload in the emulator, drives its
# representative workload, and rewrites host/pgo/{lits,funcs}_gen.go
# from the measured literal-pool and per-function heat. These are build
# INPUTS, not test goldens: regenerating changes image layout and cycle
# counts, so report the before/after instead of refreshing on a failure.
# Takes ~15 minutes (the profiler disables the emulator's fast read
# path) and needs no host toolchain.
.PHONY: pgo
pgo:
	GEN_PGO=1 go test -count=1 -timeout 3h -run TestGenPGO ./host/dmacc/ -v
	gofmt -w ./host/pgo

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
	@: > host/dmacc/testdata/expected.txt
	@for f in $(CC_TESTS); do \
	  clang --target=armv6m-none-eabi $(LLGEN_FLAGS) -ffreestanding -S -emit-llvm \
	    host/dmacc/testdata/$$f.c -o host/dmacc/testdata/$$f.ll || exit 1; \
	  if [ $$f != recurse ]; then \
	    clang $(LLGEN_FLAGS) -Dmain=testmain -c host/dmacc/testdata/$$f.c -o bin/llgen_$$f.o && \
	    clang bin/llgen_$$f.o bin/llgen_driver.c -o bin/llgen_$$f && \
	    echo "$$f $$(./bin/llgen_$$f)" >> host/dmacc/testdata/expected.txt || exit 1; \
	  fi; \
	done
	@cat host/dmacc/testdata/expected.txt
	@# stdio differential goldens: host stdout is the expected console,
	@# the exit value arrives via stderr so the streams don't mix.
	@printf '#include <stdio.h>\nint testmain(void);\nint main(void){int r=testmain();fflush(stdout);fprintf(stderr,"%%d\\n",r);return 0;}\n' > bin/llgen_sdriver.c
	@for f in $(CC_STDIO_TESTS); do \
	  (cd host/dmacc/testdata && $(LIBC_CLANG) $$f.c -o $$f.ll) && \
	  clang $(LLGEN_FLAGS) -Dmain=testmain -c host/dmacc/testdata/$$f.c -o bin/llgen_$$f.o && \
	  clang bin/llgen_$$f.o bin/llgen_sdriver.c -o bin/llgen_$$f && \
	  ./bin/llgen_$$f > host/dmacc/testdata/$$f.console 2> bin/llgen_$$f.exit && \
	  echo "$$f $$(cat bin/llgen_$$f.exit)" > host/dmacc/testdata/$$f.expected || exit 1; \
	done
	@cat host/dmacc/testdata/*.expected 2>/dev/null || true
	@# Target-only programs (no host truth: infinite loops / hardware IO).
	clang --target=armv6m-none-eabi $(LLGEN_FLAGS) -ffreestanding -S -emit-llvm \
	  host/dmacc/testdata/proc.c -o host/dmacc/testdata/proc.ll
	(cd host/dmacc/testdata && $(LIBC_CLANG) shell.c -o shell.ll)
	clang --target=armv6m-none-eabi $(LLGEN_FLAGS) -ffreestanding -I$(CURDIR)/target/xv6 \
	  -S -emit-llvm host/dmacc/testdata/xv6malloc.c -o host/dmacc/testdata/xv6malloc.ll
	@for f in xv6sys xv6proc xv6spawn xv6hello xv6readline xv6kill xv6sig xv6trap; do \
	  clang --target=armv6m-none-eabi $(LLGEN_FLAGS) -ffreestanding -I$(CURDIR)/target/xv6 \
	    -S -emit-llvm host/dmacc/testdata/$$f.c -o host/dmacc/testdata/$$f.ll || exit 1; done

# --- Firmware build + hardware-in-the-loop ---
# Toolchain locations, all overridable from the environment or the make
# command line so this builds on any machine (see docs/building-firmware.md):
#   PICO_SDK_PATH  path to a pico-sdk checkout (2.3.0 or newer)
#   PICO_TOOLS     ':'-separated dirs prepended to PATH for the build
#                  (arm-none-eabi-gcc, cmake, ninja). Leave empty when they
#                  are already on PATH, e.g. installed via apt in CI:
#                  make firmware PICO_TOOLS= PICO_SDK_PATH=/path/to/pico-sdk
#   OPENOCD        openocd binary for 'make test-hw'; RP2350 needs a build
#                  with rp2350 support (e.g. the Raspberry Pi openocd fork).
# The defaults below match a pico-sdk installer layout under ~/.pico-sdk.
PICO_SDK_PATH ?= $(HOME)/.pico-sdk/sdk/2.3.0
PICO_TOOLS ?= $(HOME)/.pico-sdk/toolchain/15_2_Rel1/bin:$(HOME)/.pico-sdk/cmake/v4.3.4/bin:$(HOME)/.pico-sdk/ninja/v1.13.2
OPENOCD ?= openocd
# Prepend PICO_TOOLS to PATH only when it is non-empty (avoids a stray ':').
PATH_WITH_TOOLS = $(if $(strip $(PICO_TOOLS)),$(PICO_TOOLS):,)$$PATH

# The deployable target, U-Boot style: a board (boards/boards.go) fixes
# the SKU, memory partition, flash sections, and installed apps.
#   make firmware HIL_BOARD=pico2    (RP2350 HIL bench; the default)
#   make firmware HIL_BOARD=pico     (RP2040 HIL bench)
#   make firmware HIL_BOARD=feather  (RP2350 presentation console)
#   make firmware HIL_BOARD=gamepico (RP2040 game console)
HIL_BOARD ?= pico2
# The pico-sdk board name matches our board names except where a
# vendor board carries a longer SDK identifier (boards.Board.PicoBoard).
PICO_BOARD = $(HIL_BOARD)
ifeq ($(HIL_BOARD),feather)
PICO_BOARD = adafruit_feather_rp2350
endif
ifeq ($(HIL_BOARD),gamepico)
PICO_BOARD = pico
endif
BUILD_DIR = target/firmware/build-$(HIL_BOARD)
OPENOCD_TARGET_pico2 = target/rp2350.cfg
OPENOCD_TARGET_pico = target/rp2040.cfg
OPENOCD_TARGET_gamepico = target/rp2040.cfg
OPENOCD_TARGET_feather = target/rp2350.cfg

.PHONY: images firmware

# Regenerate the embedded test images + expectations from the emulator.
images: game-ll
	go run ./host/cmd/dmxgen -board $(HIL_BOARD) -o target/firmware/generated/images.h

# HIL_DEV=1 keeps the on-boot test/calibration suite (development);
# the default is a release boot straight to the game/shell. Passed
# explicitly both ways so the CMake cache can't leak a stale ON.
HIL_DEV ?= 0
ifeq ($(HIL_DEV),1)
HIL_DEV_OPT = -DHIL_DEV_TESTS=ON
else
HIL_DEV_OPT = -DHIL_DEV_TESTS=OFF
endif

# gamepico links the game blobs at their XIP homes (passed both ways
# so a cached ON never leaks into another board's build).
ifeq ($(HIL_BOARD),gamepico)
GAME_BLOB_OPT = -DHIL_GAME_BLOBS=ON
else
GAME_BLOB_OPT = -DHIL_GAME_BLOBS=OFF
endif

firmware: images
	PATH="$(PATH_WITH_TOOLS)" PICO_SDK_PATH="$(PICO_SDK_PATH)" \
	  cmake -S target/firmware -B $(BUILD_DIR) -G Ninja -DPICO_BOARD=$(PICO_BOARD) $(HIL_DEV_OPT) $(GAME_BLOB_OPT)
	PATH="$(PATH_WITH_TOOLS)" ninja -C $(BUILD_DIR)

# Flash with OpenOCD over a Debug Probe, then watch the UART (115200):
# TEST/CAL lines under HIL_DEV=1, the payload's own output on a release
# build. Automated capture-and-diff is a future CI stage.
test-hw: firmware
	$(OPENOCD) -f interface/cmsis-dap.cfg -c "adapter speed 5000" -f $(OPENOCD_TARGET_$(HIL_BOARD)) \
	  -c "program $(BUILD_DIR)/dma_hil.elf verify reset exit"
