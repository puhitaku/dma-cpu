# DMA-machine HIL firmware (see main.c). Build for Pico 2 / RP2350:
#
#   export PICO_SDK_PATH=~/.pico-sdk/sdk/2.3.0
#   cmake -S target/firmware -B target/firmware/build -G Ninja \
#         -DPICO_BOARD=pico2
#   ninja -C target/firmware/build
#
# Regenerate generated/images.h with cmd/dmxgen when test programs change.
cmake_minimum_required(VERSION 3.13)

set(PICO_BOARD pico2 CACHE STRING "Board type")

include(pico_sdk_import.cmake)

project(dma_hil C CXX ASM)
set(CMAKE_C_STANDARD 11)

pico_sdk_init()

add_executable(dma_hil
    main.c
    ${CMAKE_CURRENT_LIST_DIR}/../loader/dmx.c
)

target_include_directories(dma_hil PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/../loader
    ${CMAKE_CURRENT_LIST_DIR}/generated
)

# The dmx loader's CTRL bit layout is SKU-specific. This define was
# unconditional for months — harmless while all silicon was RP2350,
# and the reason the machine never started on the first real RP2040
# (prompts/040: every CAL passed, every dmx-loaded TEST timed out).
if(PICO_RP2350)
    target_compile_definitions(dma_hil PRIVATE DMX_TARGET_RP2350)
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
