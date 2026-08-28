# Phase 23: MicroSD, vfat mount, and the slide viewer

Goal: read slides from a MicroSD card and show them full-screen —
the "presentation software" is a full-screen image viewer driven
over UART and a digital joystick.

## SD driver (SPI mode)

*Superseded: the machine drives the card itself now (`xv6/dma/ksd.c`,
`boards.MachineSDExec`); the ARM keeps only boot staging, and contiguous
spans read through one CMD18 instead of per-sector CMD17.*

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
listed fine), so the deck tooling followed: `go run ./host/cmd/sldgen -o
deck img1.png img2.jpg ...` emits NN-<stem>.sld in argument order
(the numeric prefix makes the viewer's name sort replay it) plus
slides.bin, slide N at offset N*153600, for the future raw fast
path.

Conversion respects the wire geometry: sources letterbox-fit a
virtual 640x480 canvas (fb pixels are 1:2 — a naive 640x240 resize
would squash circles into eggs), area-average down, and
Floyd-Steinberg dither into RGB332 — on 256 colors dithering is the
difference between gradients and bands. Stdlib only; png/jpeg/gif.

## /dev/sd0 and the second silicon pass

The first card the user inserted mounted straight off (macOS
Spotlight droppings and all), which surfaced two review questions:
mount is CALLABLE but not in ls / (answer: it is a toolbox applet
reached through the flash image registry — exec falls back to
registry names when the path misses, so flash-resident commands are
invisible to ls by design), and /dev had no sd0. Now it does: the
raw card, absolute LBA 0 onward, sized from the CSD (the firmware's
op 5 reports the capacity CMD9 reads; SPI-mode CSD v1 and v2 both
parse). ls /dev must never probe the bus, so the size shows 0 until
the card is up; the first READ of /dev/sd0 brings it up, making the
card inspectable without a mount. The sector cache now tags absolute
LBAs (raw and volume reads share it), and unmount drops the card
state so a swapped card re-inits. `show /dev/sd0` doubles as a raw
read probe in TestXv6SD.

## help, /dev/apps, and the first real card

The registry design made commands invisible to ls, so /dev grew an
`apps` file (one runnable name per line straight from the kimg
rows) and the toolbox a `help` applet that prints it in columns
after naming the one true sh builtin (cd). NIMG went 20 -> 24 for
headroom, which nudged the feather's C-kernel data past its window:
ShRText moved up 2 KiB.

The user's first real card (a >4 GB one, formatted by macOS) taught
two lessons the emulator's tidy images couldn't: stat sizes print
SIGNED, so the capacity clamp moved under 2 GiB (16 GB once listed
as -512), and macOS strews AppleDouble `._*.sld` droppings that
match the viewer's suffix filter AND sort first — show now skips
dotfiles. Both are pinned by emulator tests.

## Viewer telemetry

show now narrates to the UART: "N slides found", Opened / Start
drawing / Done drawing per slide, and one line per input event
(UART: left/right/quit, Joystick: up/down/left/right/push). The
fbcon console tee is muted while the fb is acquired, so the log
reaches the serial side without scribbling on the slide.

## Robust conversion: decks, series, and the 16:9 stretch

Round three of the converter (user feedback from real projector
use):

- Arbitrary input sizes were already letterbox-fitted with aspect
  preserved; now it is pinned by tests (a 1:3 source spans 160
  columns).
- Projectors that stretch 4:3 to 16:9 get a dedicated series: the
  169 render pre-squeezes content horizontally by 3/4 so the
  stretch restores the original aspect.
- Both series ship in ONE deck file (deck.sldk): "SLDK" magic, u32
  version/nseries/bytes-per-slide, 24-byte series entries
  {name[12], count, offset}, then fixed-size slides. `show
  deck.sldk` plays the first series, `show deck.sldk 169` selects
  by name; paging seeks — which grew the kernel a minimal SYS_seek
  (absolute offset, FD_INODE only).

The fallout was the best bug of the phase: the toolbox outgrew the
pico's arena (exec COPIES text, and one instance no longer fit),
and the failure exposed a real kernel leak — the registry exec
path leaked its text allocation when the data allocation failed,
poisoning every later exec. Fixed both ways: the leak is closed,
and fbtest/show moved into their own `fbtools` multi-call binary
installed only on fb boards, so displayless boards stopped paying
~15 KB per toolbox exec for tools they cannot link.

## Generic DMA: kdmacpy on a machine made of DMA

The user asked the right question: if this is a DMA controller, why
is the pixel copy an interpreted loop? Two answers landed:

1. SD bulk reads now point mailbox op 4 straight at the caller's
   buffer for whole aligned sectors — the ARM writes SPI bytes to
   their final home and the machine copies nothing.
2. kdma.c: kdmacpy/kdmaset drive FREE channel 11 (unused by the
   compact machine on both SKUs) as a bulk engine — one word per
   bus slot instead of tens of interpreted transfers per word.
   dmacpy_ctrl arrives loader-patched with the SKU's CTRL encoding
   (zero = plain-loop fallback for unpatched lean kernels);
   completion polls TRANS_COUNT (the BUSY bit is SKU-dependent).
   Wired into exec's image placement (a 57 KB toolbox text per
   exec), kfb_init's 150 KB blank, fbcon's row clears, and XIP
   vfat bulk reads.

The debugging lesson is a keeper: CHAIN_TO=0 in CTRL does not mean
"no chain" — it means "trigger channel 0 on completion". The first
kdmacpy re-armed a machine bank, the re-armed bank re-triggered the
copier with advanced addresses, and the copier marched through SRAM
until the bus fault. Self-chain (CHAIN_TO=11) is the no-chain
encoding, now baked into KDMACopyCtrl.

## Still open

- The contiguous-LBA raw read path for slides.bin (mount resolves
  the start sector once, then raw multi-block reads skip the FAT
  walk), noted in prompts/036 — worth it only if per-slide load
  times bother in practice.
