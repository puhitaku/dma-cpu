# Phase 5e results: fork + exec — the loader moves into the kernel

Goal (xv6/PORT.md): kernel-created processes. After this rung the
shell pattern `fork → exec → wait` runs entirely on the DMA machine:
the kernel places, relocates and starts images with no host (or ARM)
involvement.

## fork() is vfork — and why that is the honest choice

A no-MMU fork-by-copy would need every code and data address in the
child's copied frames rebased. The relocation table covers link-time
address words, but not RUNTIME values: saved return addresses in
static frames, pointer variables aimed at the parent's data. Fixing
those exactly needs type information dmacc has at compile time but the
kernel does not have at fork time; fixing them heuristically (rebase
anything that looks like an address) corrupts integers. This is the
same wall every no-MMU Unix hit — hence uClinux's vfork — and the
port takes the same door:

- `fork()` allocates a proc slot that SHARES the parent's image; the
  child continues at the fork return point, the parent goes SLEEPING
  on the child's proc struct until the child execs or exits.
- The shared mailbox carries both return values by temporal
  separation: the child (which by construction runs first) reads 0;
  the child's exec/exit deposits the child pid into the mailbox
  before waking the parent.
- The vfork frame hazard: the child runs on the parent's static
  frames, so re-entering `dma_syscall` would overwrite the saved
  return address the suspended parent resumes through. Therefore
  `exec()` and `exit()` get PRIVATE syscall invocations in usys.c
  (own frames), and the vfork contract is: between fork and exec the
  child calls nothing else.

## exec(): the kernel is now the loader

`kproc.c` gains what dmx.c and the Go loader used to own:

- An image registry (`struct kimg[NIMG]`): pre-parsed DMX images —
  segment blobs, link bases, a PACKED relocation table (one word per
  reloc: bit31 target segment, bit30 referenced segment, low 30 bits
  offset), and the symbol offsets the kernel needs (warmstart,
  crtthunk, dispatch/irqresume/lr, mailbox, syscall-entry). Rows are
  poked at generation time; blobs live in flash or RAM.
- A bump allocator (`kalloc`) over a loader-designated arena
  (freeing comes later; exec'd images currently leak on re-exec).
- `exec(name)`: look up, place text+data with kalloc, copy word-wise,
  apply the relocs with the two placement deltas, repoint the proc's
  address fields, write the image's syscall vector, preset
  dispatch=thunk, release the vfork parent, and continue at the new
  image's crt0 — at `warmstart`.

`warmstart` is a new one-line dmacc export: a label AFTER crt0's
`move $crtthunk, dispatch`. The kernel presets the dispatch word
itself and enters past the write, so nothing can overwrite a tick
patch that lands between scheduling the fresh process and its first
instruction — the Phase 5b banner-race class is closed at the root
for kernel-loaded images.

The hello image must call exit(), not return: crt0's return path
stores the exitcode and HALTs the whole machine (right for test
programs, wrong for processes; a process-crt0 variant that calls
exit() is future work).

## Validation

`TestXv6Exec`: idle + spawner instances preloaded; the "hello" image
is registered as blobs+relocs in RAM ("flash") and NEVER loaded by
the host. pid 2 forks; the child execs "hello"; the parent's fork()
returns 3 by deposit-at-exec; hello (placed at the arena by the
kernel, 0x600 bytes total) writes its line and exits 7; wait() reaps
pid 3 status 7; the child slot returns to UNUSED; idle keeps
counting. PASS both SKUs. The kproc image grew to 25.6 KB text
(every kernC placement window in tests and bundles was widened; it
still fits the narrow rp2040 sched-bundle layout).

dmxgen gained the exec bundle (emulator-verified at generation time,
like the others): registry row and loader globals are patched into
the kproc image; the hello blobs are emitted as C arrays the firmware
stages into their registered RAM homes before starting.

## Silicon: PASS

    EXP exec: start (the kernel loads "hello" itself)
    parent: spawning
    hello from exec
    parent: reaped

    EXP exec: PASS spawn=3 reap=3 status=7 idle=235->1976

Everything else in the pass stayed green (sched, syscall with
donetick=11 again, shell handoff). "hello from exec" is a line
written over SYS_write by a process that the DMA-machine kernel
placed, relocated and scheduled without the ARM touching anything
but the initial blob staging.

## Next

- SYS_read (console input through the kernel) so xv6's own sh.c can
  replace dma-sh — at that point the exec registry becomes sh's PATH.
- Region free / image refcounts (exec currently leaks the old image).
- argv passing through exec (upstream signature already accepted).
- The file layer: fs.c stack over a flash block device; the registry
  then dissolves into the real filesystem.
