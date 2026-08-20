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

## M1.5: the RP2040 calibration campaign (silicon PASS)

The hunt ran over SWD (openocd `read_memory`/`write_memory` replays
of exact emulator state) and ended with 17/17 HIL PASS at 200 MHz
and the game machine drawing its test card on metal. Five distinct
bugs, none of them the emulator's instruction semantics:

1. **`DMX_TARGET_RP2350` was defined unconditionally** in the
   firmware CMakeLists, so dmx_start armed RP2350 CTRL words
   (chain/treq/quiet fields shifted 2 bits) on RP2040 silicon —
   the machine never fetched a single record. The SWD replay that
   proved the classic tier runs fine on metal was the wedge that
   cracked it. Fix: `if(PICO_RP2350)`. 0/17 → 15/17.
2. **UART wedge on the clk_peri switch**: a byte in flight when
   clk_peri moves to the USB PLL wedges the PL011 state machine and
   every later printf blocks on TXFF forever (intermittent boot
   hang). Flush + `uart_default_tx_wait_blocking()` before the
   overclock; same discipline before the game handover.
3. **The self-TRANS_COUNT wedge** — the big one. A channel that
   writes its OWN TRANS_COUNT (any alias) mid-transfer wedges after
   that beat on RP2040: stuck busy, immune to CHAN_ABORT and
   re-trigger, surviving core resets; only a RESETS-level DMA block
   reset revives it. (RP2350 latches the write as reload-only —
   which is what the emulator modelled, and why ccc_* passed on the
   Feather.) The compact tier's mulc/jbool used exactly this as the
   "in-bank count restore" trick: the sniff bank restoring its own
   reload to 1 while sniff-summing k ones. Busy-channel readback
   also lies (rd/wr read ~12 bytes low), which cost a day of
   red-herring numerology. Fixes:
   - dmaasm: mulc is now a binary-method multiply on the
     accumulator (S += S by the sniff bank reading SNIFF_DATA —
     doubling in one count-1 beat; S += v on set bits of k), and
     jbool's 8*v is v plus three doublings. Every record stays
     count-1, so the deferred sniff-read fast path holds and the
     count machinery never runs. jbool text size is unchanged.
   - emu: `Variant.SelfCountWedge` (RP2040 true) wedges the channel
     in the model exactly as measured, so this class of program can
     never pass emulation again.
4. **SSPDMACR.TXDMAE was never set**: the PL022 only raises its TX
   DREQ with the DMA enable bit on; the paced pixel channel starved
   with a full TRANS_COUNT and an empty FIFO at flush row 0. The
   emulator's "SPI TX always drains" level DREQ now gates on the
   DMACR write, and lcd_init sets it.
5. **The freeze/abort experiments leave wedged channels behind**
   ("wedges=N/500" is literal): whether the game booted after them
   was luck of the draw. The firmware now does a full DMA block
   reset at startup (insurance — wedges survive resets) and again
   at game handover before dmx_load.

Diagnostic notes for the next campaign: openocd `reset halt` does
NOT reset peripherals — un-reset via RESETS and remember a wedged
channel's state survives it, so "pristine" reads can be last week's
crash; assert+release RESETS bit 2 for a true DMA reset. The
minimal wedge repro is a 4-word no-increment transfer targeting the
channel's own AL2_TRANS_COUNT — completes on 11 channels, wedges on
the one that is its own destination, sniff on or off.
