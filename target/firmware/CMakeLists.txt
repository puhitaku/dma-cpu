# DMA-machine HIL firmware (see main.c). Normally built through the repo
# Makefile, which regenerates the board's generated/images.h and passes
# the matching -DPICO_BOARD (docs/building-firmware.md):
#
#   make firmware HIL_BOARD=pico2   # or pico, feather, gamepico
#
# By hand, per board — generated/images.h is board-specific, not per-SKU,
# and so is the memory map below, so BOTH names must be passed:
#
#   export PICO_SDK_PATH=~/.pico-sdk/sdk/2.3.0
#   go run ./host/cmd/dmxgen -board pico2 -o target/firmware/generated/images.h
#   cmake -S target/firmware -B target/firmware/build-pico2 -G Ninja \
#         -DPICO_BOARD=pico2 -DHIL_BOARD=pico2
#   ninja -C target/firmware/build-pico2
cmake_minimum_required(VERSION 3.13)

set(PICO_BOARD pico2 CACHE STRING "Board type")

# The repo's board name (Makefile: HIL_BOARD). It is NOT always the
# pico-sdk board name: gamepico and the plain pico bench are both
# PICO_BOARD=pico, and only this name tells them apart — they have
# opposite memory maps. Defaults to PICO_BOARD, which is right for
# every board whose two names agree.
set(HIL_BOARD ${PICO_BOARD} CACHE STRING "Repo board name: pico, pico2, feather, gamepico")

include(pico_sdk_import.cmake)

project(dma_hil C CXX ASM)
set(CMAKE_C_STANDARD 11)

pico_sdk_init()

add_executable(dma_hil
    main.c
    executor.c
    devtests.c
    ${CMAKE_CURRENT_LIST_DIR}/../loader/dmx.c
)

target_include_directories(dma_hil PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/../loader
    ${CMAKE_CURRENT_LIST_DIR}/generated
)

# --- Firmware RAM placement on the deployed boards ---------------------
#
# The ARM executes from flash XIP; the only SRAM it needs is
# .data/.bss, a heap and a stack — a few KiB that the stock pico-sdk
# map parks at 0x20000000, the most valuable address on the chip. That
# is why the machine's windows used to start at 0x20002000. On the two
# boards that ship a payload (gamepico, feather) the firmware's RAM is
# moved out of the way entirely, into the SCRATCH banks the SDK
# otherwise reserves for stacks, and the machine gets SRAM from
# 0x20000000 up. Core 0 is in PSM reset by then (executor.c), so none
# of this memory is even live once the machine runs.
#
# The bench boards (pico, pico2) keep the stock map: their ARM stays
# alive as the flash mailbox executor and their images are generated
# for a 0x20002000 floor.
#
# Each half of a pair below has a mirror on the C side: HIL_FW_RAM_*
# feeds the boot check in main.c, so a half-edited map fails on the
# first boot line instead of quietly corrupting the kernel.
if(HIL_BOARD STREQUAL "gamepico")
    # RP2040, 264 KiB: RAM 0x20000000+256K, then SCRATCH_X and
    # SCRATCH_Y, 4 KiB each. .data+.bss+heap fit in SCRATCH_X with
    # room to spare; the core-0 stack keeps the exact address the
    # stock map gave it (top 2 KiB of SCRATCH_Y), and core 1 — never
    # launched on this board — keeps a nominal region below it.
    pico_set_linker_script_var(dma_hil RAM_ORIGIN 0x20040000)
    pico_set_linker_script_var(dma_hil RAM_LENGTH 0x1000)
    pico_set_linker_script_var(dma_hil SCRATCH_X_ORIGIN 0x20041000)
    pico_set_linker_script_var(dma_hil SCRATCH_X_LENGTH 0x800)
    pico_set_linker_script_var(dma_hil SCRATCH_Y_ORIGIN 0x20041800)
    pico_set_linker_script_var(dma_hil SCRATCH_Y_LENGTH 0x800)
    target_compile_definitions(dma_hil PRIVATE HIL_ARM_HALT=1
        HIL_FW_RAM_BASE=0x20040000u HIL_FW_RAM_END=0x20042000u)
elseif(PICO_BOARD STREQUAL "adafruit_feather_rp2350")
    # RP2350, 520 KiB: RAM 0x20000000+512K, then SCRATCH_X and
    # SCRATCH_Y at 0x20080000 and 0x20081000 — CONTIGUOUS, so the two
    # banks make one 8 KiB region. .data (which on this SKU also
    # carries every .time_critical function) plus .bss plus a trimmed
    # heap fit inside it; the linker's own "region RAM overflowed"
    # check is the growth alarm, and it is a hard error.
    pico_set_linker_script_var(dma_hil RAM_ORIGIN 0x20080000)
    pico_set_linker_script_var(dma_hil RAM_LENGTH 0x2000)
    # The stack is what does not fit, so it goes where memory is not
    # machine memory YET: the top 4 KiB of the kernel's exec arena.
    # The ordering argument, in full —
    #   * the arena is free RAM; dmx_load writes only the kernel's own
    #     loaded segments and never touches it (main.c already borrows
    #     the arena's BOTTOM 4 KiB as the flash staging buffer, for
    #     the same reason);
    #   * the machine only claims arena pages through kalloc, which
    #     cannot run before dmx_start starts the machine;
    #   * between dmx_start returning and core 0 entering PSM reset
    #     the ARM executes a handful of instructions (park_forever:
    #     cpsid i, one store) — well under a microsecond, while the
    #     machine is still executing its first DMA-chained
    #     instructions of kernel boot.
    # After that store the stack is not read again by anyone: core 0
    # is held in reset until the next chip reset.
    pico_set_linker_script_var(dma_hil SCRATCH_X_ORIGIN 0x2002F300)
    pico_set_linker_script_var(dma_hil SCRATCH_X_LENGTH 0x800)
    pico_set_linker_script_var(dma_hil SCRATCH_Y_ORIGIN 0x2002FB00)
    pico_set_linker_script_var(dma_hil SCRATCH_Y_LENGTH 0x800)
    # 2 KiB of heap no longer fits beside .data/.bss in the 8 KiB
    # region. Nothing in the firmware mallocs; the only user is
    # newlib's stdio buffer for the one fputs() on the handover
    # banner, and sbrk may still grow into whatever the region has
    # left over (__StackLimit is the end of SCRATCH_Y, i.e. the end of
    # the region, which is exactly the right bound now that the stack
    # is elsewhere).
    target_compile_definitions(dma_hil PRIVATE HIL_ARM_HALT=1
        PICO_HEAP_SIZE=0x400
        HIL_FW_RAM_BASE=0x20080000u HIL_FW_RAM_END=0x20082000u)
endif()

# The dmx loader's CTRL bit layout is SKU-specific. This define was
# unconditional for months — harmless while all silicon was RP2350,
# and the reason the machine never started on the first real RP2040
# (prompts/040: every CAL passed, every dmx-loaded TEST timed out).
if(PICO_RP2350)
    target_compile_definitions(dma_hil PRIVATE DMX_TARGET_RP2350)
endif()

# Development builds keep the on-boot test/calibration suite; release
# builds (the default) boot straight to the payload. The Makefile
# passes this explicitly both ways so a cached ON never leaks into a
# release flash.
option(HIL_DEV_TESTS "Run the HIL test suite at every boot" OFF)
if(HIL_DEV_TESTS)
    target_compile_definitions(dma_hil PRIVATE HIL_DEV_TESTS)
endif()

# gamepico: the game's XIP text and PCM blobs are linked at their
# flash homes (one flash copy, no staging) — addresses must match
# boards.GamePico.GameTextXIP and dmxgen's gameSFXHome.
option(HIL_GAME_BLOBS "Pin the game blobs at their XIP flash homes" OFF)
if(HIL_GAME_BLOBS)
    target_link_options(dma_hil PRIVATE
        "LINKER:--section-start=.gametext=0x10100000"
        "LINKER:--section-start=.gamesfx=0x10143000")
endif()

target_link_libraries(dma_hil pico_stdlib hardware_pio
        hardware_flash)

# The Feather board scans a PSRAM framebuffer out via HSTX
# (prompts/036): the SDK runtime brings PSRAM up on QMI CS1, and the
# firmware repurposes the USB PLL for clk_hstx.
if(PICO_BOARD STREQUAL "adafruit_feather_rp2350")
    target_link_libraries(dma_hil hardware_psram hardware_pll hardware_vreg pico_multicore hardware_spi)
endif()

pico_enable_stdio_uart(dma_hil 1)
pico_enable_stdio_usb(dma_hil 0)

pico_add_extra_outputs(dma_hil)
