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

## M2: the console is a console

Menu plus all three games, written in C, compiled by dmacc, and run
entirely by the compact machine — the ARM stays in wfi. Verified on
silicon (17/17 HIL + boot to "menu up" with heartbeats; the sticks
are not wired yet, so gameplay ran in the emulator) and end-to-end
in emulation: every screen decoded from the SPI stream and eyeballed
as PNG, a full 12-turn Yacht game, a LANWalk board solved by a Go
backtracking solver driving the cursor, and a dino auto-player
vaulting three cacti before dying on purpose.

- input.c: both sticks merged, active-low edges, first-poll baseline
  (no phantom edges on boot), xorshift32 RNG entropy-fed by input
  timing. frame_sync paces every loop at one tick per 33 ms.
- menu.c: picker with the once-a-second "beat N" heartbeat kept as
  the HIL scripts' sync point.
- dino.c: Chrome-runner. 1bpp sprite art pre-rendered to RGB565
  cells (background baked in), so each frame is opaque word-aligned
  gdma blits; movers step 2 px to stay aligned. Fixed-point jump
  physics tuned so the apex stays inside the redrawn strip.
- lanwalk.c: NetWalk. Randomized-DFS spanning tree over 7x7, server
  at center, leaves drawn as terminals; scramble by random rotation;
  relight = BFS over mutually-agreed edges; only tiles whose lit
  state changed redraw.
- yacht.c: traditional scoring, hold bars, roll counter, score
  preview in the sheet, endgame panel.
- gfx: 2x text, outline rects, clipped blits, sprite renderer, and
  clipped text (an unclipped footer wrote past x=239 into the next
  fb row).
- emu: Machine.SetPadIn drives pad input levels for tests; the fast
  TIMERAWL model (Cycle<<16) makes emulated games free-run, so the
  tests' press() is adaptive — hold until g_in_down reflects the
  state, release until it clears. Fixed-length presses got swallowed
  whenever they started inside a long flush.
- dmacc bug found by the menu's colors: negative narrow constants
  rendered sign-extended (see the "canonicalize narrow constants"
  commit) — any RGB565 with red >= 128 was one LSB off on odd
  pixels of word-filled rects.

Still open for M3: PIO I2S audio (MAX98357) and the two WS2811
LEDs, wiring permitting; a hardware gameplay session needs the
sticks soldered.

## M3: sound and light

PIO0 runs both effects, and the machine does its own PIO bring-up —
instruction memory and SM config are plain APB registers, so the DMA
CPU loads the hand-assembled programs (I2S on SM0, WS2811 on SM1),
sets the wraps/shifts/pins, force-executes the entry jumps, and
enables the block. No ARM involvement at any point.

- Audio: SM0 clocks 16-bit-stereo I2S to the MAX98357 (GP13..15) at
  2 PIO cycles per bit. Channel 9 — the compact machine's IRQ
  injector, never armed by the game build — streams a 4 KiB ring of
  frames into TXF0 with a ~54-hour TRANS_COUNT, ring-wrapped on the
  read side, paced by DREQ 0. Once armed, audio costs the machine
  zero attention: silence is a zeroed ring (the amp's SD_MODE is
  strapped on, so frames never stop and nothing pops). Tones are a
  power-of-two-period square wave in the ring — written once,
  doubled out by log2 gdma copies, wrapping seamlessly — with fine
  pitch from SM0 CLKDIV. The MAX98357 tracks LRCLK only in its
  specified ranges (22.05 kHz is by name NOT supported, p.16 —
  caught by the user), so fs stays clamped inside the continuous
  30.4-50.4 kHz band and octaves come from the period: bands
  118-196, 237-393, 475-787, 950-1575, 1900-3150, 3800-6300 Hz,
  gaps landing on the nearest edge. Idle fs is 44.1 kHz. snd_play
  takes (hz, vol, frames); frame_sync ticks the countdown and zeroes
  the ring when it expires.
- Light: SM1 shifts WS2811 800 kHz frames out of GP12; two LEDs are
  two FIFO words written directly (autopull 24, shift left, GRB).
  The >50 us inter-frame gap latches for free at game frame rates.
- Emulator: a PIO stub, not a PIO emulator — TXF writes are captured
  per SM, config lands in the generic mmio map (FSTAT reads zero =
  never full), and each SM's TX DREQ is granted once per CLKDIV*64
  cycles, the I2S program's cadence. The pioListen gate requires
  CtrlEN so idle channels (ctrl=0 decodes TREQ_SEL=0 = PIO0 TX0!)
  do not defeat it.
- Verified: emulator tests assert silence at boot, the exact GRB LED
  words, blips that sound and decay; on silicon 17/17 + "fx up",
  and a live SWD probe measured ch9 draining 22071 frames/s —
  22.05 kHz on the nose, with the machine's beats still ticking.
- Games got starter hooks (menu blips, jump/death/milestone,
  rotate/solved, roll/book/finale + LED moods) for the user to tune.
