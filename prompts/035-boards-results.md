# Phase 21 results: boards — one definition, two silicon targets

The build system grew a U-Boot-style board layer. boards/boards.go is
the single source of truth for a deployable target: SKU, the
machine's RAM partition, the flash sections, the flash-sync executor,
and the apps to install. Everything downstream consumes it —
`dmxgen -board pico2` builds the shipped firmware image, and the
emulator test harness boots the SAME struct (bootXshBoard), so the
recurring chore of hand-mirroring memory maps between the generator
and the tests is gone.

## pico2 (RP2350)

Exactly the system built so far — 520 KiB SRAM, 4 MiB flash, vi, the
machine-driven QMI flash executor, and the shell/syscall/exec demo
bundles. The silicon battery passes unchanged on the board-built
firmware.

## pico (RP2040) — xv6 on the smaller part

The full xv6 + readline + GPIO/PIO/devfs experience in 264 KiB of
SRAM and 2 MiB of flash. Three board knobs made it fit:

- **Apps in flash**: the user programs (echo, cat, ls, toolbox and
  its twelve multi-call aliases) leave the RAM disk and become
  flash-resident registry images — the mechanism vi pioneered, with
  the registry grown to 20 rows so each alias gets a row over the
  shared toolbox blob. That converts ~80 KiB of RAM disk into flash,
  leaving a 24 KiB data-only disk and a ~105 KiB exec arena.
- **ARM-mailbox flash executor**: RP2040's SSI has no equivalent of
  the RP2350 QMI direct-mode trick, so sync posts erase/program
  requests to the parked ARM — the dormant fallback path, now a
  per-board switch. The machine waits in .ramtext while XIP is down,
  the same discipline the QMI executor needed.
- **No vi**: its in-arena footprint (161 KiB) is bigger than the
  whole arena.

TestXv6ShPico boots the board definition on the rp2040 variant and
runs the real session: ls, cat through a registry exec, redirection
onto the RAM disk, a pipe into wc, GPIO write/read loopback, /dev,
free. The RP2040 firmware compiles and links (`make firmware
HIL_BOARD=pico`); the ACCESSCTRL unlock is RP2350-guarded since
RP2040 has no ACCESSCTRL and needs none.

## What's next

The board layer is the substrate for CI recipes: one matrix job per
board — build images, run the emulator suite, build firmware —
without bespoke per-target logic.
