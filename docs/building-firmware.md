# Building the firmware

This project ships two deployable firmwares, both built from the same
board-driven source (`host/boards`):

| Firmware        | Board (`HIL_BOARD`) | SKU     | What it is                                   |
| --------------- | ------------------- | ------- | -------------------------------------------- |
| Game console    | `gamepico`          | RP2040  | Bare-metal game console (both ARM cores sleep, the DMA machine runs everything) |
| Presentation    | `feather`           | RP2350  | xv6-on-DMA with an HDMI slide viewer (Adafruit Feather RP2350) |
| HIL bench       | `pico2` / `pico`    | RP2350 / RP2040 | The hardware-in-the-loop test target |

Adding a board is just a new descriptor in `host/boards/boards.go` plus a
matrix entry in the CI workflow — the build pipeline is the same.

## Prerequisites

To **build** a firmware you need:

- **Go ≥ 1.26** — runs the emulator/assembler/codegen (`dmxgen`).
- **clang** — cross-compiles the C payload (game / kernel) to LLVM IR
  (`--target=armv6m-none-eabi`).
- **arm-none-eabi-gcc ≥ 13**, **cmake ≥ 3.13**, **ninja** — build the
  bare-metal firmware through the pico-sdk.
- **pico-sdk 2.3.0** (or newer) — checked out somewhere on disk.

To **flash** over a debugger you additionally need:

- **OpenOCD** and a **Raspberry Pi Debug Probe** (or any CMSIS-DAP
  adapter). For RP2350 targets the OpenOCD build must have `rp2350`
  support — the stock Homebrew 0.12.0 does not; use the
  [Raspberry Pi OpenOCD fork](https://github.com/raspberrypi/openocd).

## Toolchain locations (injectable)

The Makefile does not hard-code where your tools live. Every path is
overridable from the environment or the make command line:

| Variable        | Meaning                                                              | Default (a `~/.pico-sdk` installer layout) |
| --------------- | ------------------------------------------------------------------- | ------------------------------------------ |
| `PICO_SDK_PATH` | Path to a pico-sdk checkout.                                        | `~/.pico-sdk/sdk/2.3.0`                     |
| `PICO_TOOLS`    | `:`-separated dirs prepended to `PATH` (arm-gcc, cmake, ninja). Leave **empty** if they are already on `PATH`. | the installer's toolchain/cmake/ninja dirs |
| `OPENOCD`       | `openocd` binary used by `make test-hw`.                            | `openocd`                                  |

So on a machine where the tools are already on `PATH` (a typical Linux
box, or CI), point `PICO_SDK_PATH` at your checkout and clear
`PICO_TOOLS`:

```console
$ make firmware HIL_BOARD=feather PICO_TOOLS= PICO_SDK_PATH=/opt/pico-sdk
```

## Build

```console
$ make firmware HIL_BOARD=gamepico    # RP2040 game console
$ make firmware HIL_BOARD=feather     # RP2350 presentation console
```

This runs the whole pipeline: compile the C payload to IR, bake the
emulator-computed image header (`dmxgen`), then `cmake` + `ninja` the
firmware. The artifacts land in `target/firmware/build-<board>/`:

- `dma_hil.uf2` — drag-and-drop image (BOOTSEL mass-storage).
- `dma_hil.elf` — for a debugger / OpenOCD.

### Release vs. development builds

`HIL_DEV` selects what the firmware does at boot:

- `HIL_DEV=0` (**default, release**) — boots straight to the payload
  (the game menu, or the xv6 shell / slide viewer).
- `HIL_DEV=1` — keeps the on-boot test & calibration suite that prints
  `TEST`/`CAL` lines over UART, for development.

```console
$ make firmware HIL_BOARD=feather HIL_DEV=1   # development build
```

## Flash

### Over a Debug Probe (OpenOCD)

```console
$ make test-hw HIL_BOARD=gamepico                      # RP2040
$ make test-hw HIL_BOARD=feather OPENOCD=/path/to/rpi/openocd   # RP2350
```

`make test-hw` programs, verifies, and resets. It selects the right
OpenOCD target config per board (`rp2040.cfg` / `rp2350.cfg`, both
shipped with OpenOCD).

### Over USB (UF2)

Hold **BOOTSEL** while plugging the board in (it appears as a mass-storage
device), then copy `target/firmware/build-<board>/dma_hil.uf2` onto it.

## Continuous integration

`.github/workflows/firmware.yml` builds every board in the matrix on:

- a push to a branch named **`ci-*`** — build only, artifacts uploaded;
- a **tag** push — build **and** publish a GitHub release with the
  `.uf2`/`.elf` files attached.

CI installs cmake/ninja/clang from `apt` and arm-none-eabi-gcc from the
official ARM release (the Ubuntu package omits newlib), checks out
pico-sdk at the pinned version (`PICO_SDK_REF` in the workflow), and
builds with `PICO_TOOLS=` empty — exactly the injectable-path flow
described above. See [building-hardware.md](building-hardware.md) for
how to wire the boards these firmwares run on.
