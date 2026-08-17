# Phase 8 results: the whole system in Tier-C compact encoding

The silicon session, at the compact machine's `$ ` prompt:

    $ ls
    .              1 1 112
    ..             1 1 112
    README         2 2 35
    echo           2 3 3444
    cat            2 4 22764
    wc             2 5 24528
    ls             2 6 30788
    $ echo compact booom > note
    $ cat note
    compact booom
    $ cat README | wc
    1 6 35
    $ ls
    ..             1 1 128
    ...
    note           2 7 14

Everything — kernel.dasm, the fs kernel, upstream sh, and every user
program on the disk — runs in 8-byte records. `ls` is back (the
Phase 7 casualty), the shell parses at clone depth 8 again, the disk
grew to 128 KiB, and the exec arena runs 60 KiB. The second `ls`
listing `note` (root dir 112 → 128 bytes) is the fs updating itself
under the compact encoding.

## The finding: multi-image compact needs a shared window selector

First boot faulted instantly (fetch reading address 0x80). The cause
is structural: every compact image carried its OWN `__cscr`
window-selector word plus init writes aiming the fix channel at it.
With four images loaded, the last one's init writes win — but every
image's mode-switch records rewrite its own selector, so any mode
switch by any other image (memcpy's size8RW bank, a byte store)
leaves the machine reading a stale window. Single-image tests could
never see this.

Fix: `dmaasm.Options.CompactScratch` — an absolute machine-global
address (the machine scratch word, unused by the compact fetch path)
hosting the selector. Every image's switch records target it, every
image's init writes configure fix/cleanup to it and seed it with the
plain window (idempotent across images). Per-image selectors remain
the default for single-image use.

## The injector rides channel 9

The compact channel map had reserved `CompactInjector = 9` ("parity
with classic ch3") since the Tier-C design — it had just never been
exercised. kproc.c's injector registers became loader-patched globals
(`inj_wreg`/`inj_treg`, classic ch3 defaults), and the wiring patches
channel 9 for compact systems. TestCompactSched validated the
long-open backlog item from prompts/012 — compact + scheduler +
approach-B injection — before anything bigger ran: ticks fire,
safepoint detours execute as 8-byte records, both processes progress.

Everything else was encoding-agnostic by construction: dispatch
patches and EOIs write data words; the kernel's exec copies segments
verbatim and applies byte-offset relocations (DMX-exec files are now
compact-assembled; kalloc's 256-byte alignment covers the 8-byte
entry requirement); the deposit machinery never touches text.

## Sizes

- fs kernel: 140.6 → 85.4 KB text (61%)
- upstream sh (K=8): 130.1 → ~78 KB text
- user blobs: cat 29.7 → 22.8 KB, ls 40.2 → 30.8 KB (relocations
  don't shrink, so blobs land at ~76%)
- Budget: kernel 111 K + sh 134 K + idle + disk 128 K + arena 60 K
  inside the 480 KB machine region, with slack again.

## Validation

- TestCompactSched: the minimal untested combo, both SKUs.
- TestXv6Sh now runs the ENTIRE fs session compact (ls, cat,
  redirection, `;` lists, `cat README | wc` = "1 6 35"), TX-paced;
  the dmxgen xsh bundle re-verifies it at generation time.
- The full suite passes; classic bundles (sched/syscall/exec, dma-sh)
  are untouched and still green — both encodings remain first-class.
- Silicon: 24/24 boot pass, then the transcript above.

## Next

- Persistence: back the RAM disk with a flash region so `note`
  survives reboot.
- init-style orphan reaping; unlink; parenthesized sh commands
  (deeper clone budget now exists).
- usertests.c — upstream's own test suite as the machine's exam.
