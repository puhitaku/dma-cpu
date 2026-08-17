# Phase 10 results: flash persistence — files survive reboot

The silicon session, across three boots and two hard resets:

    boot 1: disk: golden gen 0
    $ echo I SURVIVED THE REBOOT > keep
    $ sync
    boot 2: disk: FLASH SLOT gen 1
    $ cat keep
    I SURVIVED THE REBOOT
    $ echo gen two > keep2
    $ sync
    boot 3: disk: FLASH SLOT gen 2
    $ cat keep keep2
    I SURVIVED THE REBOOT
    gen two

## Layout (simple by decision)

Two flash regions, nothing else: the firmware + rodata (baked images,
golden fs.img) below, and ONE fs slot at 0x10100000 — a 4 KB header
sector (magic 'DMFS', generation, length, word-sum checksum) followed
by the 128 KB disk image. Sync erases the header FIRST and programs
it LAST: a torn sync leaves an invalid header and boot falls back to
the golden image. Boot staging (ARM, before parking) and the kernel's
kflash_init both read the header via plain XIP.

## Sync: kernel policy, pluggable executor

kfs_sync lives in the kernel (kflash.c): incremental burns driven by
the dirty-sector map (upstream's log_write is the interception point —
one line in kbio.c), full burns when the slot isn't our lineage,
header-last commit, generation bump. The erase/program PRIMITIVES go
through one of two executors:

- **QMI direct mode** (the machine does everything itself): a full
  serial-NOR driver — exit-XIP, WREN, RDSR/WIP polling, 4K erase,
  256B page program — over the RP2350 QMI direct registers. This is
  the reference implementation, exercised end-to-end by the
  emulator's new QSPI model (emu/flash.go: XIP window + direct-mode
  FIFO + a NOR command state machine with AND-semantics programming).
  TestXv6Persist runs the full three-boot loop against it.
- **The ARM mailbox executor** (silicon): the first hardware sync
  wedged in RDSR polling — the flash sits in QUAD continuous-read
  mode under XIP, and the single-lane FFh exit dance is not enough to
  make plain-SPI commands parse; the proper dance belongs to the
  bootrom. Rather than reverse-engineer it, the parked ARM's
  SRAM-resident loop doubles as a flash service: the kernel posts
  {op, offset, src} requests to a mailbox word block at scratch+0x10
  and spins on the ack; the ARM executes SDK flash_range_erase/
  program (XIP-safe, RAM-resident, bootrom-danced) and acks. Policy
  never leaves the kernel; the ARM is a dumb disk controller that
  never fetches flash outside SDK-managed windows.

The ARM's park state changed accordingly: cpsid + an SRAM-resident
poll loop (wfi remains for non-persistent builds). A firmware boot
check asserts the binary hasn't grown into the slot.

## Pieces

- kbio.c: fs_dirty sector bitmap via log_write (32 sectors = one word).
- kflash.c: driver + sync + header logic; kflash_arm selects executor.
- SYS_sync wired (upstream number 22; user.h already declared sync());
  xv6/dma/syncprog.c gives sh a `sync` command (on the disk).
- emu/flash.go: Machine.Flash + QMI + NOR model; XIP reads bus-served.
- fsimg disks carry the console device inode + sync program.
- dmxgen: slot constant, mailbox address, disk-length macros; the xsh
  bundle verification runs against a blank flash model.

## Honest notes

- The emulator's flash has no continuous-read modes, so the QMI
  executor's exit-XIP inadequacy was invisible off-silicon — exactly
  the class of gap the cal-first rule exists for; the pluggable
  executor keeps the QMI path alive for a future proper dance.
- Sync burns dirty sectors in place within the single slot; between
  header-erase and header-program the only fallback is the golden
  image. Accepted per the simplicity decision.
- Flash endurance: ~100K cycles per sector; sync is explicit and
  dirty-only. Fine for this machine's life.

## Next (per the recorded roadmap)

kill() + reparenting, per-process heap, parenthesized sh; then the
presentation goals: HSTX DVI out, DisplayLink over PIO USB
(references/pico-usb-disp), mount() + SD (references/xv6-ns).
