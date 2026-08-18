# Phase 20 results: pads in hand — GPIO, pin mux, PIO, and /dev

The machine now owns its pins. Three syscalls (SYS_gpio, SYS_pinmux,
SYS_pio) expose IO_BANK0, PADS_BANK0 and the PIO blocks as a kernel
API, gpiod-style — a deliberate contrast to device files, keeping the
whole driver a few hundred bytes. None of those blocks are on
ACCESSCTRL's DMA-forbidden list, so the machine reaches them with
plain MMIO.

## The parts

- **gpio write/read**: output drives the pad through the IO_BANK0
  OUTOVER override (the same silicon-proven trick as the dmaasm
  `gpio` instruction — SIO is CPU-private, invisible to DMA); input
  is GPIOx_STATUS.INFROMPAD. The emulator loops driven levels back
  through STATUS, so `gpio read` self-verifies everywhere.
- **mux PIN role**: FUNCSEL by name (spi/uart/i2c/pwm/sio/pio0..2) or
  number, pad initialized (IE, drive, RP2350 ISO latch cleared).
- **SYS_pio**: program load into INSTR_MEM, SM init (clkdiv,
  execctrl, shiftctrl, pinctrl, restart + forced jmp to origin), and
  SM_ENABLE gating — a state machine owned end to end from the shell.
- **blink PIN**: `blink gpio N` soft-loops (Ctrl-C douses the LED and
  exits via the SIGINT handler); `blink pio N` loads a hand-assembled
  8-instruction blinker (clkdiv 65535: ~0.45 s halves at 150 MHz),
  starts SM0, and EXITS — the LED keeps blinking with no CPU and no
  machine cycles until `blink stop N`.
- **/dev**: a second synthetic vfs backend, auto-mounted, listing
  console (openable, the real device), fat0 (the raw volume bytes
  straight off XIP), gpio (per-pad levels), pio0..2 (enabled-SM
  masks). `mount` reports it; writes are refused.

## What it took underneath

vfs_resolve became namei-first: the mount-aware component walk runs
only where a synthetic fs can be involved, and a namei-failure
fallback accepts only synthetic results — because the walk lacks
namex's corner handling and usertests' unlinkcwd (operations from a
deleted cwd) will ilock a freed dinode if the walk answers for the
plain fs. The persistent-slot header now carries the golden disk's
checksum, so a slot synced by an older build self-invalidates instead
of resurrecting a disk that lacks the new binaries (this bit two
silicon sessions before the fix). The new kernel code costs ~25 KB of
text — flash-resident in the shipping XIP kernel.

## Measured on silicon (GPIO15)

gpio write/read loopback on the real pad, devfs listing and reads,
soft blink with Ctrl-C cleanup, PIO blink running asynchronously
(both pad levels observed from the machine itself), devfs showing
SM0 enabled, `blink stop` gating it off, and sync + reboot
persistence under the new header — twelve for twelve. Wire an LED
(with a resistor) from GPIO15 to ground and `blink pio 15` shows a
DMA controller conducting a PIO state machine, no CPU anywhere.
