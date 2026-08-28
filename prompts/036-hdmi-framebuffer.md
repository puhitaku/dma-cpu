# Phase 22: HDMI framebuffer + fbcon (Feather RP2350 HSTX)

Goal: a framebuffer in PSRAM scanned out to HDMI by HSTX, a kernel
terminal emulator (fbcon) mirroring the console onto it, and a kernel
framebuffer API so a userspace program can take the display over —
on a new board, the Adafruit Feather RP2350 with PSRAM.

## Board facts (references/datasheets/adafruit-feather-rp2350.pdf, pinouts pp.12-22)

- HSTX pins GPIO12-19 on the 22-pin port. DVI lane map (silk):
  D2±=GPIO12/13, CK±=GPIO14/15, D1±=GPIO16/17, D0±=GPIO18/19.
  In HSTX bit numbers (bit N = GPIO 12+N): clock on bits 2/3,
  lane0 on bits 6/7, lane1 on bits 4/5, lane2 on bits 0/1.
- PSRAM: 8 MB QSPI (133 MHz class), CS on GPIO8 = QMI CS1.
  XIP CS1 window 0x11000000 (cached) / 0x15000000 (uncached alias).
- Red LED GPIO7, NeoPixel GPIO21, UART console GPIO0/1 (unchanged),
  RP2350A, 8 MB flash. SDK board `adafruit_feather_rp2350`
  (PICO_PSRAM_CS_PIN 8, PICO_AUTO_DETECT_PSRAM_SIZE 1).

## Display architecture: a pure-DMA scanout ring

No ARM, no IRQs — the scanout is a self-running DMA descriptor
structure, in the machine's spirit. Three channels above the compact
machine's 0-10 (RP2350 has 16):

| ch | role |
|----|------|
| 13 | ring walker: 4-word blocks -> ch14's alias0, write-ring 16 B |
| 14 | executor: streams words to the HSTX FIFO (DREQ 52) or, for kick blocks, writes 3 words into ch15's alias3 |
| 15 | line copy: PSRAM (uncached) -> SRAM line buffer, kicked one line ahead |

Per active line the ring holds two blocks for ch14: a *kick* (copy 3
words {WRITE_ADDR, TRANS_COUNT, READ_ADDR_TRIG} from the kick table
into ch15's alias3 — primes fb line n+1 into the other line buffer)
and a *stream* (line buffer -> FIFO: 9 command words + 160 pixel
words, paced by DREQ_HSTX, chain back to ch13). Vblank regions are
one block each, reading an 8-word command buffer through a 32 B read
ring (RAW_REPEAT sync sequences, pico-examples layout). A tail block
makes ch14 rewrite ch13's READ_ADDR_TRIG with the ring start: the
frame loops forever with zero CPU involvement.

Line buffers in SRAM decouple sync integrity from QMI contention:
the FIFO is always fed from SRAM at AHB speed; if PSRAM is starved
(flash XIP fetches share the QSPI bus), pixels go stale for a line
but sync never slips. `kicktab[n] = {buf[(n)&1]+36, 160, fb+n*640}`.

Mode: 640x480@60, RGB332 (8 bpp), CEA timing at 25.2 MHz pixel clock
(pll_usb repurposed: VCO 1260 MHz /5/2 = clk_hstx 126 MHz = 5x pixel
clock; the machine keeps its calibrated 150 MHz clk_sys, and clk_peri
is pinned to clk_sys first so the UART is unaffected). 16 bpp at 640
wide (37 MB/s) exceeds QSPI PSRAM bandwidth (~30-35 MB/s effective at
75 MHz QPI) — 8 bpp (18.4 MB/s) is the sustainable default. Geometry
and timings live in one `fbmode` struct in kfb.c — changeable in code.

Scroll is a vertical pan, fbcon-style: the fb is a circular row
buffer; scrolling rewrites the kick table's READ column (480 word
stores in SRAM) and clears one row — never a 300 KB PSRAM memmove.

QMI direct mode (machine-driven flash sync) blocks the XIP window, so
kflash sync brackets itself with kfb_pause()/kfb_resume() (CHAN_ABORT
the three channels, then rebuild-and-restart the ring).

## fbcon

kfbcon.c, a VT subset informed by references/simpleterminal (MIT/X,
st lineage): BS/TAB/LF/CR, CSI A/B/C/D/H/J/K/m (16 ANSI colors ->
RGB332 palette), ?1049h/l as clear. Font: the 8x8 embedded font from
SimpleTerminal (attributed in LICENSE). 80x60 cells. Glyph rendering
via a per-color nibble->word LUT (rebuilt on SGR change): one glyph
row = 2 LUT loads + 2 word stores into the uncached PSRAM window.
`cputc` tees every console byte to UART *and* fbcon; when a userspace
owner holds the fb, fbcon skips rendering (UART unaffected).

## Kernel fb API (SYS_fb)

For the future presentation app and USB DisplayLink output:
FB_INFO (base/w/h/bpp/pitch into a user struct), FB_ACQUIRE (fbcon
detaches, pan resets to 0 so the owner sees a linear fb), FB_RELEASE
(clear + fbcon resumes). Owner-pid tracked like raw console mode;
death auto-releases. /dev/fb0 shows geometry, pan, owner.

## Emulator

- Machine.PSRAM []byte at XIP offset 0x01000000 (cached + uncached
  windows, faulting during QMI direct mode like flash); writable.
- HSTX FIFO writes (Variant.HSTXFifoBase, RP2350 only) captured into
  Machine.HSTXOut for tests; DREQ 52 credits injected by tests via
  PulseDREQ — with no credits the ring idles harmlessly, so normal
  tests pay nothing for an enabled scanout.
- The ring test drives credits and asserts two identical consecutive
  frames: per-line command prefixes, pixel words matching PSRAM
  content (validates walker + kicks + copies end to end).

## Validation

Emulator: fbcon glyph/scroll/SGR tests against PSRAM bytes (cell
identity checks, no-newline discriminators for cursor state), fbtest
(user app: FB_INFO/ACQUIRE/write/readback/RELEASE), feather boot
suite, cycle benchmarks (DMACC_BENCH=1) for putc and scroll before/
after optimization. Silicon: boot log prints PSRAM size + fb self
test; the TV picture is the end-to-end check.

## Results (silicon: Adafruit Feather RP2350 with PSRAM)

Everything above is implemented and validated; the console renders on
HDMI while the UART stays authoritative. Findings the hardware forced:

- **HSTX FIFO write port is base+4** (base+0 is the read-only STAT).
  Streaming at +0 discards every word, so the FIFO never fills, its
  DREQ never deasserts, and the unpaced scanout saturates the bus —
  the machine and even the ARM's XIP fetches starve. Variant carries
  the corrected address.
- **The SDK's PSRAM bring-up leaves one residual word in the QMI
  direct-RX FIFO** (DIRECT_CSR read RXLEVEL=1 at the wedge). The
  machine's flash driver assumes an empty FIFO: every read of its
  session came back shifted and the session hung; the ARM then timed
  out back into flash code with XIP still down — lockup (PC
  0xEFFFFFFE). The firmware drains direct-RX before the machine runs.
- **hardware_psram grows the firmware's .bss past 0x20002000**, the
  family's machine-RAM floor. The boot check caught it; the feather's
  KernText moved to 0x20002800 and dmxgen honors a board floor above
  the SKU layout.
- **The feather firmware ELF exceeds 2 MiB**, so the pico2 flash map's
  slot at 0x10200000 would sit inside the program image. All feather
  flash sections moved to the upper 4 MiB of the 8 MiB part.
- **Machine-driven flash sync is incompatible with the display.** The
  QMI driver leaves XIP in plain-SPI mode; that degraded M0 traffic
  interleaved with the scanout's QPI CS1 bursts corrupted kernel
  fetches within ~a millisecond of resuming (machine halted, no error
  bits, PC mid-kernel-text). The feather syncs through the parked
  ARM's mailbox executor instead (MachineFlashExec=false), which ends
  every op with flash_start_xip(): full-speed quad XIP plus the CS1
  hook, restored before the ack lands. kfb_pause()/kfb_resume() still
  bracket the sync, and pause now polls CHAN_ABORT until the aborts
  retire (the abort is asynchronous on silicon; the emulator's was
  instant, which is why tests missed it).

## Benchmarks (TestZZBenchFbcon, emulator cycles, feather vs pico2)

The first cut cost ~63k cycles per rendered character — 5x the UART's
13k-cycle pacing budget. Root cause: dmacc lowers right shifts through
a per-bit runtime loop (~28 iterations), and the glyph path shifted
every font byte. After the optimization round (byte-indexed dual
256-word LUTs, fully unrolled glyph rows, XOR-underline cursor,
shift-free pan/clear loops with 8x unrolling):

| workload            | before      | after       |
|---------------------|-------------|-------------|
| echo (40 chars)     | +5.66M      | below noise |
| scroll (12x ls /dev)| +157M       | +36M (~335k/scroll, 2-3 ms) |

A second round (2026-08-29) took the scroll row from +40.2M to +29.8M
(the tree had drifted up from the +36M above). It came from PROFILING
first — `host/dmacc/zz_fbconprof_test.go` attributes machine fetches
per kernel function, feather against pico2 — which found the cost was
not in the pixels at all: ~40 % of it sat in the comparison millicode,
because dmacc lowers every test as a call and the per-byte path made
about thirty of them. The wins, in order: order kfbcon_putc by byte
frequency instead of by the VT grammar (the control-byte switch used
to run five equality sites ahead of the printable case); let the glyph
blit un-draw the cursor it is about to overwrite, instead of a second
cursor_xor; count the blit loops down to zero (`__cw_eqz`, three
records) rather than up to a constant (`__cw_eq`, four); keep the
cursor row's base address standing instead of multiplying it out per
byte; and fill a full-width span in one DMA instead of sixteen. All
size-neutral bar the frowa cache, which costs 2.6 K of XIP text (the
kernel's data and .ramtext windows are down to ~40 and ~550 bytes of
slack, so nothing could be spent there). Per console byte over
`cat README` + 12x `ls /dev`: 13,584 cycles -> 9,750, and 7,337
kernel-text fetches -> 4,869. What remains is mostly the scroll's own
pixel move (ch11) plus the compare millicode; unrolling the blits
would take another bite and is priced in kfbcon.c's comments — it does
not fit those windows. `TestXv6FbconPixels` pins the rendered
framebuffer bytes against the pre-round renderer, so the round changed
no pixel.

fbcon now costs less than the UART pacing it shadows. The open item
noted here — dmacc lacking constant-shift strength reduction for
lshr/ashr — was closed later by byte-lane constant shifts
(prompts/042 §3); llvm.usub.sat was added to the intrinsic set along
the way (clang emits it for clamped subtraction).

## The sync saga (second silicon round)

Two more stacked bugs surfaced once sync ran with the display live,
each pinned by SWD snapshots:

- **CHAN_ABORT on the running ring corrupts it.** kfb_pause aborted
  active channels; prompts/006 already measured ~50% wedge rates for
  exactly that. The half-wedged executor free-ran unpaced after
  resume: garbage video, machine starved of bus slots (~15 s per
  keystroke). Fixed: pause parks the ring at a frame boundary by its
  own machinery — the tail block is redirected to write a sentinel,
  the chain ends itself, and the follow-up abort only cleans parked
  or stalled states. Snapshot-verified on silicon.
- **The bootrom's "saved XIP setup stub" is a lottery.** The op-3
  XIP restore called the pointer boot RAM holds; boot RAM is reused
  after boot, and the ARM hard-faulted mid-op (mailbox seq=ack+1, PC
  in the fault handler) — the machine then waits forever on the ack,
  which read as "sluggish". Fixed: the firmware snapshots the
  bootrom's M0 window registers at boot (per-burst EB quad, no
  continuous-read mode — blind register restore is exact) and the
  executor writes them back once per sync (mailbox op 3), after
  flash_start_xip re-validates the window. Post-sync console: 9 ms
  echo, sync 2.3 s, verified over repeated syncs.

The feather also ships **read-only by default** (boards.ReadOnlyFS):
g_fsslot = 0, no slot staging, sync returns -1 — persistence is a
nice-to-have and can never disturb the display in a demo. The sync
machinery stays covered: silicon-validated above, and
TestXv6ShFeather re-arms the slot in the emulator.

Open items: 320x240 double-scan mode table entry; DisplayLink USB
output sharing the same framebuffer + FB_ACQUIRE contract; a
presentation app on SYS_fb.

## The framebuffer moves to SRAM (third silicon round)

*Superseded in one number: prompts/041 re-measured the "~1000x slower"
PSRAM figure on a quiet bus and found copier contention — DMA-master
access through the window is wire-speed. What still bars PSRAM from the
render side is sustained window traffic while the display scans.*

The display held sync only while the machine idled. The chain of
measurements that explained it, in order:

- The scanout's vblank lines carried one padding NOP beyond the
  pico-examples sequence (a leftover of an abandoned read-ring
  layout); the display held sync for seconds and dropped it, over and
  over. Vblank lines are the 7-word example sequence verbatim now,
  one block per line — no DMA read ring anywhere in the engine.
- clk_hstx measured EXACTLY 126000 kHz by the on-chip frequency
  counter (fc0 prints at boot): clocking exonerated with data.
- The line copier could not hold its line budget once other QMI
  traffic broke its PSRAM bursts, and at HIGH_PRIORITY +
  TREQ_PERMANENT a perpetually-behind channel monopolizes the DMA
  arbiter. Demoting it and even feeding it from the QMI's XIP
  STREAMER (merged internal fetches, DREQ-paced FIFO drain — the
  emulator now models STREAM_ADDR/CTR/the XIP_AUX port, with the
  stream DREQ as a LEVEL request, and arbitrates round-robin within a
  priority tier like the hardware) fixed the starvation but not the
  renders.
- The decisive dual-layer benchmark: the ARM writes the PSRAM window
  at 0.15 us/word; THE MACHINE writes it at ~1 ms/word — DMA-master
  accesses through the QMI memory-mapped window are ~1000x slower
  than CPU accesses on silicon, reads and writes alike. This machine
  IS DMA: PSRAM can never be its framebuffer.

Final architecture: the framebuffer is 640x240 RGB332 IN SRAM
(150 KiB, boards.FbBuf), every row scanned twice — the wire format
stays exactly VESA 640x480@60. The scanout is two channels streaming
command words and pixels straight from SRAM: no copier, no line
buffers, nothing in the video path that can touch the QSPI bus. Sync
integrity is structural; renders run at SRAM speed (full-screen test
card: 0.4 s, was 70+ s). The terminal is 80x30 with 8x16-shaped
glyphs. PSRAM remains for bulk storage on the ARM's fast path
(slides over USB). Cost: vi comes off the feather (80 KiB arena).

Extra lore bought by this round: CHAN_ABORT on a RUNNING scanout
corrupts it (~50% wedge, prompts/006 applies to any channel) — pause
parks the ring at a frame boundary via a redirected tail block; the
bootrom's saved XIP-setup pointer in boot RAM goes stale (calling it
hard-faulted the ARM mid-sync); flash_start_xip on RP2350 ends in
slow 03h serial mode, so the mailbox executor restores the M0 window
registers snapshotted at boot (per-burst EB quad, no continuous-read
mode — register restore is exact and cannot fault).

## Final architecture: the core-1 video feeder (fourth silicon round)

*Superseded: the pure-DMA scanout came back and holds
(`host/boards/scanout.go`); the core-1 feeder is the
`HIL_VIDEO_CPU_FEEDER=1` fallback. What changed: console DMA silenced
the idle machine's flash reads, the descriptor table runs from SRAM,
HIGH_PRIORITY is the pixel pair's alone, and exec's flash copies go
through the QMI streamer.*

The SRAM framebuffer alone was not enough. With the console at the
prompt, sh retries its read every tick — hundreds of wide kernel
round-trips per second through XIP-resident code — and every XIP
cache miss parks the SINGLE SHARED DMA READ MASTER for over a
microsecond. The HSTX FIFO holds 8 words (~1.3 us): one miss at the
wrong moment drops a sync word. That is why fbtest's held card
(process asleep, machine quiet) was rock solid while the text console
"struggled to sync" no matter how the scanout was built: EVERY
DMA-fed design shares that master with the machine itself.

The fix uses the one component with a private path to memory: ARM
core 1, parked and idle since Phase 1. The firmware's video_feeder
(SRAM-resident, ~15 instructions of hot loop) pushes the HSTX command
words and SRAM framebuffer pixels with CPU stores, paced by the
FIFO's FULL flag. It reads nothing but SRAM and the FIFO: the machine
cannot stall it, flash sync cannot stall it, PSRAM traffic cannot
stall it. Silicon: text console AND fbtest hold sync indefinitely,
under load, across resets (user-confirmed on the display).

The machine's whole video interface is now memory: the 640x240 fb
(boards.FbBuf) and ONE control word (boards.FbHome) — the vertical
pan in fb rows, sampled by the feeder once per scan line. Scroll
became O(1). kfb.c shrank to state-keeping; DMA channels 13-15 are
free again; kfb_pause/resume are vestigial no-ops (nothing to
protect). The pure-DMA scanout rings above remain as the record of
why they cannot work on this machine: the display is the one hard
real-time consumer in the system, and the machine's own bus traffic
is unschedulable around it.

## Noted for later: the slide converter

A host-side tool (Go, stdlib-only per the repo rules) that converts
images into the display's native format: 640x240 RGB332 bytes per
slide. Two outputs: individual slide files for the vfat card, and —
the fast path — one preallocated CONTIGUOUS `slides.bin` (slide N at
byte offset N*153600) so the viewer can resolve the file's start LBA
once and then issue raw multi-block SD reads; drag-and-drop
convenience with raw-read speed. Scaling + RGB332 quantization
(optionally dithered) happens on the host, never on the device.
