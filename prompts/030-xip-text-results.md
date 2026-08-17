# Phase 17 results: XIP text — the kernel and sh execute from flash

Downsizing item 3 of 6: program text now executes straight from the
flash XIP window, freeing most of the machine's SRAM. On the Pico 2
the fs kernel and xv6 sh fetch their records from QSPI flash; only
their data and a small RAM-resident stub region stay in SRAM. The
exec arena grew from 75 KiB to 255 KiB:

    $ free
    arena: total 261120  used 53248  free 207872  largest 207872
    of it: heap 33024  exec 20224
    procs: 3/8  uptime 17893 ticks

## Why it works at all

The machine has always been able to fetch from XIP — the FAT32 driver
reads the volume through it, and the DMA fetch channel does not care
whether READ_ADDR points at SRAM or flash (ACCESSCTRL unlocked the
QMI for DMA in prompts/028). The blocker was self-modifying text: the
`.read/.write/.count/.ctrl` block-field patches are the machine's
addressing mode for indirect loads and stores, and flash is immutable
under XIP.

## The .ramtext split (dmaasm)

dmaasm gained one directive and one option. `.ramtext` marks a point
in the text stream; everything after it becomes a third image segment
linked at `Options.RAMTextBase`. Layout stays a single continuous
offset counter — only address resolution maps offsets past the split
into the RAM segment, so the compact planner, block-field payload
deltas, and the jpair arena all work unchanged (the arena, appended
after the last instruction, simply lands in ramtext). The assembler
rejects an instruction that could fall through the split, where the
link address is discontinuous.

## dmacc Options.XIPText

Every patched record moves out of line. A load that was

    move p, Ld.read
    Ld: move @0, dst          ; patched in place, falls through

becomes

    move p, Ld.read           ; flash: patches RAM
    jump Ld                   ; flash
    Ld: move @0, dst          ; ramtext
    jump ret_label            ; ramtext

Flash text stays the same size (the jump replaces the inline record);
each site costs two ramtext records. The runtime and comparison
millicode move to ramtext wholesale — memcpy/memset patch their own
blocks, and the rest is shared with code that must survive XIP-down
windows (below). The fs kernel needs 25 KiB of ramtext, sh 5 KiB:

    fs-kernel    text 152880 (149 KB)  data 39312 (38 KB)             [SRAM 187 KB]
    fs-kern-xip  text 140328 (137 KB)  data 45800 (44 KB)  ram 25 KB  [SRAM  69 KB]
    sh(K12)      text  51104 ( 49 KB)  data 15376 (15 KB)             [SRAM  64 KB]
    sh-xip       text  49344 ( 48 KB)  data 17272 (16 KB)  ram  5 KB  [SRAM  22 KB]

## The sync trap: RAMTextFuncs

`sync` burns the RAM disk into flash through a QMI direct-mode
session — which tears down the very XIP window the kernel text now
lives behind. Any record fetched from flash between exit-XIP and the
serial-XIP restore would hang the machine. `Options.RAMTextFuncs`
names roots (here `kflash_sync`) whose transitive callees are all
emitted into ramtext, so the entire session executes from SRAM.
Verified on silicon: sync, reboot, `FLASH SLOT gen 1`, file survived.

## Staging

The xsh flash map: fs slot 0x10100000, fat volume 0x10140000, kernel
text 0x10160000, sh text 0x101A0000. dmxgen strips the flash text
segment out of the DMX container (the loader only copies SRAM) and
ships it as a blob; the firmware stages each blob with a memcmp guard
— an unchanged build never reflashes — before dmx_start. The
emulator's LoadBytes accepts XIP-window addresses and writes into the
flash model, mirroring the staging step. One boot-guard regression
along the way: the staging sector buffer pushed firmware bss past
0x20002000 into machine RAM (the FATAL guard caught it); the buffer
is now shared with the fat-golden stager.

## Measured on silicon (Pico 2)

The full battery passes with kernel + sh text in flash: ls, 8-deep
parens, recursion-overflow degradation, pipes, free, sync + reboot
persistence, and the vfat mount session.
