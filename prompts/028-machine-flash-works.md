# Phase 15 results: machine-only flash writes WORK — prompts/023 retracted

The silicon printout:

    CAL flash: done phase=7 csr=01010801 timer n/EN/after=0041db7c/0041db7e/0041db7f
    CAL flash: jedec=ef4016 sr=00 wel=02 erased=ffffffff prog=0da0ce11 xip=0da0ce11
               -> machine-only flash WORKS

And the end-to-end: `echo ... > keep; sync` with the ARM parked in
wfi, hard reset, `disk: FLASH SLOT gen 1`, `cat keep` returns the
file. The DMA controller programs its own persistent storage.

## The real cause: ACCESSCTRL, not hardware

prompts/023 concluded the RP2350 DMA engine "cannot read QMI
registers" and that DIRECT_CSR.EN "freezes its peripheral reads
irrecoverably" — hardware-blocked, ARM executor irreducible. Wrong.
RP2350 datasheet §10.6.2.1: most bus endpoints reset with DMA access
allowed (0xFC — TIMER0, PADS_QSPI, IO_BANK0...), but a short list
resets to 0xB8 — **DMA access forbidden** — and it includes exactly
the two blocks the flash driver needs: **XIP_QMI and XIP_CTRL**.
Every machine access to the QMI was an ACCESSCTRL bus fault; the
"stall" and the "frozen reads" were the DMA channel's fault behavior,
not QMI semantics. (Credit where due: the project's user read page
825 and asked the right question.)

The fix is two register writes in the firmware's main(), before the
machine ever runs (ACCESSCTRL is writable only by a Secure,
Privileged processor, never by the DMA — by design):

    accessctrl_hw->xip_qmi  = ACCESSCTRL_PASSWORD_BITS | 0xFC;
    accessctrl_hw->xip_ctrl = ACCESSCTRL_PASSWORD_BITS | 0xFC;

## The reinstated driver

The prompts/022 QMI direct-mode driver came back from git history —
exit-XIP dance (pad-override bit-bang, works from quad continuous
read), WREN, **RDSR/WIP polling** (real reads now), 4K erase, 256B
page program — plus two new pieces:

- qmi_serial_xip(): after direct-mode work the flash sits in plain
  SPI, so the driver programs M0_RFMT/RCMD for serial 03h reads with
  the command prefix re-sent per burst. XIP stays readable (slow;
  the disk lives in RAM, XIP is only metadata). A reboot restores the
  bootrom's quad config.
- kflash_slot_gen reads the header via the uncached XIP alias
  (+0x0400_0000): neither executor flushes the XIP cache for the
  machine.

kflash_arm now defaults to 0 — the machine drives the QMI itself in
the xsh bundle and the emulator tests. The ARM mailbox executor stays
in the kernel as a dormant fallback (repoint g_kflash_arm to use it).
The ARM's park loop is unchanged (SRAM-resident, cpsid, wfi): it must
not fetch flash while the machine owns the bus.

## Two silicon lessons along the way

- An interrupt during the machine's direct-mode session fetches its
  vector from flash: instruction bus error straight into lockup
  (CFSR=0x100, PC=0xEFFFFFFE, read post-mortem over SWD while the
  calres words survived in SRAM — the designed failure path). The
  cal wait now runs under save_and_disable_interrupts().
- dmx_start-to-SRAM is a race: the machine reaches DIRECT_CSR in
  microseconds while the ARM is still printf-ing from flash. The
  machine now waits for a GO word the ARM writes from inside its
  SRAM wait loop (the emulator verifier grants it at load).

## Validation

- cal_flash spec restored (emulator NOR model back in emu/flash.go,
  machine.go read/write hooks and the 0x14000000 uncached alias
  added); dmxgen verifies the driver against it.
- TestXv6Persist: the three-boot loop passes with the MACHINE driving
  the NOR model — serviceFlashMailbox never fires.
- Full suite green both SKUs; silicon: the cal printout above, the
  full HIL suite after it (the ARM survives the machine's flash
  session), and the write/sync/hard-reset/read demo, machine-only.

## Standing correction

PORT.md's machine-only-flash item is rewritten; prompts/023 remains
as the historical record of a wrong conclusion drawn from probes that
were themselves ACCESSCTRL-faulted. The generalizable lesson: when a
DMA access to an RP2350 peripheral misbehaves, check §10.6.2.1 before
blaming the peripheral.
