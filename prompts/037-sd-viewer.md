# Phase 23: MicroSD, vfat mount, and the slide viewer

Goal: read slides from a MicroSD card and show them full-screen —
the "presentation software" is a full-screen image viewer driven
over UART and a digital joystick.

## SD driver (SPI mode)

Wiring (Feather RP2350): SCK=GPIO22, MOSI=GPIO23, MISO=GPIO20 (the
board's SPI0 pins), CS=GPIO10 (D10 — the Adalogger FeatherWing
convention). 10k pull-ups on CS/CMD/DAT0, DAT1/DAT2 not grounded.

The split follows the machine's constitution (prompts/036: DMA
accesses to memory-mapped peripherals are the machine's, but
byte-banging SPI is per-byte busywork):

- ARM core 0 (the park executor) owns the card: SPI-mode init
  (CMD0/8/ACMD41/58, 400 kHz -> 20 MHz) and single-sector CMD17
  reads, as mailbox ops 4 (read LBA -> machine SRAM) and 5 (init;
  {status, sectors} written back). A failed read poisons the buffer
  with 0xFF rather than leaving stale bytes.
- The machine's vfat driver (kfat.c) gained a second backend: every
  byte access already funnels through rd8(), so an SD volume reads
  through a 2-sector SRAM LRU cache over mailbox reads; bulk file
  reads copy per cached sector at memcpy speed (~0.25 s for a 150 KiB
  slide). MBR partition 0 (types 0x0B/0x0C) or superfloppy BPB both
  mount: `mount sd0 /sd`, then ls/cat/open work as on fat0.

The emulator plays the card in serviceMailbox (ops 4/5 against a Go
byte-slice); TestXv6SD covers superfloppy AND MBR cards end to end
through mount, ls, cat and the viewer.

## The viewer: `show`

A toolbox applet. `show DIR` displays every *.sld in the directory
(sorted; the converter numbers them), `show FILE...` an explicit
list. A slide is a raw framebuffer image: 640x240 RGB332 bytes,
loaded by read()ing STRAIGHT INTO the acquired framebuffer.

Controls — UART: n/space/l/Right-arrow next, p/h/Left-arrow prev,
q quit; joystick (self-pulled-up, active low, polled every ~2 ticks
with edge detection + debounce): right/down next, left/up prev,
press quit. Joystick wiring: UP=A0/GPIO26, DOWN=A1/GPIO27,
LEFT=A2/GPIO28, RIGHT=A3/GPIO29, PRESS=D24/GPIO24 — the contiguous
A0..D24 header block. SYS_gpio gained op 2 (read with the internal
pull-up) so unwired pins idle high instead of reading noise.

## Fallout absorbed along the way

The toolbox with the viewer outgrew RAM disks everywhere, so pico2
joined pico and feather on flash-resident apps (AppsHome rows; disks
are 24 KiB data-only now, pico2's arena grew to ~335 KiB), and
usertests moved to the XIP kernel — the RAM-resident fs kernel was
the last of its kind, and its 185 KiB made every window a fight.

## The converter: `sldgen`

Silicon confirmed the mount (the card's macOS Spotlight droppings
listed fine), so the deck tooling followed: `go run ./cmd/sldgen -o
deck img1.png img2.jpg ...` emits NN-<stem>.sld in argument order
(the numeric prefix makes the viewer's name sort replay it) plus
slides.bin, slide N at offset N*153600, for the future raw fast
path.

Conversion respects the wire geometry: sources letterbox-fit a
virtual 640x480 canvas (fb pixels are 1:2 — a naive 640x240 resize
would squash circles into eggs), area-average down, and
Floyd-Steinberg dither into RGB332 — on 256 colors dithering is the
difference between gradients and bands. Stdlib only; png/jpeg/gif.

## Still open

- The contiguous-LBA raw read path for slides.bin (mount resolves
  the start sector once, then raw multi-block reads skip the FAT
  walk), noted in prompts/036 — worth it only if per-slide load
  times bother in practice.
