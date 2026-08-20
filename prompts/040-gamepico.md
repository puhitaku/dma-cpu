# Phase 26: Gaming Pico — M1 (and the RP2040 surprise)

A second device: the original Pi Pico as a bare-metal game console.
No xv6 — one dmacc-compiled image (menu + games), the machine
driving every peripheral itself, both ARM cores asleep after boot.
Plan reviewed in the session artifact; the user pinned 200 MHz
clk_sys and supplied strap details (MAX98357 SD_MODE pulled high =
(L+R)/2, GAIN strapped).

## Datasheet findings that shaped the design

- The M154 LCD module brings out 8 pins only: the ST7789V's TE
  output is NOT among them and SDA is write-only. Tear-sync is
  physically impossible; damage-rect updates keep write windows
  short instead, and init is blind (no status reads).
- The MAX98357A has no I2C at all — BCLK/LRCLK/DIN plus strap pins.

## M1, emulator-complete

- boards.GamePico: GameTextXIP (flash), GameRAMText + GameData
  (SRAM; the 240x240 RGB565 framebuffer is a static array in the
  data segment), 200 MHz ClkSysKHz.
- game/src: g.h, grt.c (UART log, us time, GPIO overrides, the
  kdma-pattern bulk channel 11 with loader-baked CTRL words), lcd.c
  (blind ST7789 init; CASET/RASET/RAMWR damage flush; pixels as
  16-bit SPI frames streamed by a DREQ_SPI0_TX-paced channel — MSB
  first = big-endian RGB565 for free), gfx.c (fill/text/damage),
  gmain.c (test card + joystick/heartbeat UART mirror).
- Emulator: SPI0 model (DR capture with cycle+width, SSPSR, level
  DREQ via a cached listener mask) and a per-variant TIMERAWL (the
  us-counter model was hardcoded at the RP2350 address — RP2040
  delay loops hung forever in emulation).
- dmxgen: a `game` bundle — compile, assemble (XIP text + SRAM),
  bake the CTRL words, verify in-emulator to the test card, emit
  blobs; firmware stages the text, dmx_loads the rest, dmx_starts
  the machine and parks. Image.Load is the loader (its init Writes
  ARE the machine's register file — a manual segment copy boots a
  machine that sits idle forever).
- Tests: TestGameBoot and TestGameTestCard with an LCD DECODER that
  replays the captured SPI stream + D/C GPIO edges into a virtual
  panel — asserts the init sequence and the test card's pixels, and
  dumps a PNG (GAME_LCD_PNG=dir) for human eyes.
- Firmware overclock, RP2040 flavor: vreg 1.20 V, clk_sys 200 MHz,
  clk_peri moved to a repurposed 125 MHz USB PLL (RP2040 has NO peri
  divider; 125 keeps the UART in spec and puts SPI0 exactly at the
  ST7789V's 62.5 MHz ceiling). stdio now initializes BEFORE the
  overclock on all boards — both keep clk_peri's frequency across
  the switch, so the overclock can narrate its own progress.

## The surprise: RP2040 silicon has never met the machine

Every HIL machine test fails on the connected Pi Pico — at 200 MHz,
at the in-spec 133, and with no overclock at all; a month-old
firmware build fails identically. Conclusion: not a regression. The
emulator was silicon-calibrated on RP2350 only (prompts/004); the
RP2040 board support has passed emulator suites for weeks but this
is its first contact with metal, and the machine does not run. The
UART side is fine (ARM prints, overclock verified); the DMA-machine
side needs a prompts/004-style calibration campaign on RP2040 —
trigger semantics, CTRL encodings, DREQ behavior, whatever the
emulator's uncalibrated RP2040 model got wrong. That campaign is
the real M1.5, ahead of any game.
