# Phase 12 results: the heap moves into the kernel

sbrk was user-space fiction until now: a 36 KB static BSS array baked
into every malloc-linked binary, with a bump pointer beside it. It is
now a real syscall — SYS_sbrk (upstream number 12), per-process
heapbase/heapmax/brk in the proc table (procWords 16), heap memory
drawn lazily from the exec arena.

## Semantics

- First call allocates an arena chunk: at least HEAPCHUNK (16 KB) so
  later small growth has headroom, or the ask when bigger (umalloc's
  morecore wants 32 KB in one call), or the ask when the arena cannot
  spare HEAPCHUNK. The break then moves within the chunk; no growth
  past it. Newly exposed bytes are zeroed, like upstream's fresh
  pages. Shrink below heapbase or growth past heapmax returns -1
  (SBRK_ERROR). The laziness flag is accepted and ignored — eager
  either way, there is no paging.
- rwsbrk's contract: SYS_read/SYS_write refuse buffers overlapping
  the RETURNED region [brk, heapmax). Buffers outside the heap
  region stay fair game — no MMU says otherwise.
- Exit and re-exec free the chunk with the rest of the image
  (kfree_exec); binaries lost the static heap, so cat/wc/ls blobs
  and the sh/usertests data segments shrank by 36 KB each.

## The vfork wrinkle (a real bug, caught by trace)

Upstream sh parses — and therefore mallocs — IN THE CHILD:
`if(fork1() == 0) runcmd(parsecmd(buf))`. Under the shared vfork
image the child triggered the first chunk allocation, the chunk was
owned by the child slot, and the child's exec freed it — while the
K&R allocator's statics (in the shared image) still pointed into it.
The next arena allocation reused the memory (ls's argv strings landed
at chunk+0x40) and sh later chased "ls" bytes as a pointer. The fix
follows the sharing:

- ksbrk mirrors chunk identity (heapbase/heapmax) up the suspended
  vfork-parent chain and hoists chunk OWNERSHIP to the chain's top,
  so no child exec/exit can free memory its parents still see.
- The BREAK is not mirrored continuously: exec syncs it up the chain
  (the allocator state hands off with the image), while plain exit
  rolls the child's growth back — which is exactly what usertests'
  free-page accounting (countfree around every test) expects.

## Exam roster: 30 -> 36

New: rwsbrk, sbrkarg, sbrklast, sbrk8000 (heap semantics), plus
reparent and reparent2 — 200/800 fork-exit storms that exercise
init-adoption (prompts/024) and slot recycling. Still out, honestly:
sbrkbasic (fork-divergent memory under a shared image), sbrkmuch
(grows to a 100 MB virtual address), the lazy tests (1 GB regions),
killstatus/preempt (children must run concurrently with the parent).

## Loader hardening

Every layout breakage this phase surfaced as a silently corrupted
machine (ticks dead, no fault): a kernel data segment growing 32
bytes into a process image cannot be seen by intra-image checks. The
emulator's LoadBytes now remembers loaded ranges per machine and
refuses cross-image overlaps — the sched/shell/syscall/exec bundle
layouts and every lean-kernel test layout were re-spaced against the
kernel's measured sizes (lean: 61.5 KB text + 8 KB data; compact fs:
95.6 KB + 28 KB).

## Validation

- Full suite green both SKUs; TestXv6Malloc now runs kernel-less
  against a test-local arena (the deleted sbrk.c shim's last user).
- Exam 36/36, including the six new tests.
- dmxgen bundles re-verified; silicon: full HIL suite PASS, and an
  interactive session on the Pico 2 — ls, `cat README | wc` (pipes),
  `echo a; echo b; echo c` (lists), `spin &` / `kill 11` — all with
  sh's parser malloc-ing from the kernel arena on every command line;
  the persisted `keep` file still lists from flash generation 1.

## Next (per the recorded roadmap)

Signals with user-space handling (the runaway-foreground fix), then
parenthesized sh commands; then the presentation goals: HSTX DVI out,
DisplayLink over PIO USB, mount() + SD.
