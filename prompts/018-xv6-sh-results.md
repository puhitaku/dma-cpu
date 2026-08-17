# Phase 6 results: upstream xv6 sh.c is the shell

Typed at the silicon `$ ` prompt, served entirely by the DMA
controller, with the ARM parked:

    $ echo hello from upstream xv6 sh on silicon
    hello from upstream xv6 sh on silicon
    $ hello
    hello from exec
    $ echo one; echo two; echo three
    one
    two
    three
    $ nosuchthing
    exec nosuchthing failed
    $ cd /tmp
    cannot cd /tmp

user/sh.c is byte-for-byte upstream. Its recursive parser and runcmd
tree walk, its fork-then-exec spawning, its `;` lists (three chained
vforks in that transcript), and its error paths all work. Three
compiler/kernel mechanisms made it possible.

## 1. Tail-call optimization (dmacc)

A call immediately followed by a ret of its (sole-use or discarded)
result is emitted as a JUMP with the caller's lr intact — the callee
returns directly to the caller's caller. A function whose only calls
are tail calls saves no lr at all: it is FRAMELESS.

## 2. Frameless syscalls + kernel r0 completion

Every usys wrapper is now `fill mailbox; return dma_trap();` — a tail
chain into the kernel, no wrapper frames anywhere. The kernel
completes syscalls by writing the result into the caller's r0 word
(and the mailbox) and returning straight to the wrapper's caller.
This is what makes the syscall layer safe under vfork: a child
sharing the parent's image can make ANY syscall without clobbering a
frame the suspended parent resumes through. (sh's exec-failure path —
child fprintf after failed exec, parent still suspended in fork —
works only because of this.)

## 3. Recursion by depth cloning (dmacc)

v0's "static frames, recursion rejected" becomes "static frames,
bounded recursion": every function on a call-graph cycle is cloned
RecursionDepth (default 12) times, intra-cycle calls at depth d route
to the d+1 clones, and depth-K calls lower to HALT. Each nesting
level owns distinct frame words — which is not just recursion
support but a vfork-safety property: a child re-entering at a deeper
level cannot clobber the suspended parent's frames.

### The fork1 clobber — found by tracing, fixed by a criterion

First emulator run of `echo a; echo b`: 'b' printed twice and the
main shell ended ZOMBIE. The DMA-transfer trace told the story: main,
vfork-suspended INSIDE fork1 (not cloned — it isn't recursive), was
resumed after its child's exec, executed fork1's epilogue — and
jumped through `lrs_fork1`, which the child's own nested fork1 call
(from runcmd, for the list) had overwritten with RUNCMD's return
address. Main "returned" into the child's list logic and dutifully
exec'd `echo b` a second time before exiting.

The sound fix: functions that transitively reach fork() AND are
reachable from a cycle member join the clone set — re-entry of a
suspended function can only happen through recursive code, so this is
exactly the set with multiple live activations. (A fork-caller used
only from straight-line code — dma-sh's `run` — keeps its single
frame: dma-sh stays at 52 KB while xv6 sh carries its clones.)

## Sizes and layout

xv6 sh: 176 KB text + 56 KB data (the clone family included). The
rp2350 machine region grew to nearly all of main SRAM
(0x20008000..0x2007FE00, ~480 KB; firmware .data/.bss end low and the
core stacks live in the scratch banks). kproc.c is now 33.5 KB text —
the narrow rp2040 sched-bundle window is at its limit and noted as
such. Also fixed en route: ulib.c owns sbrk() (wrapping sys_sbrk,
which dma/sbrk.c now provides); user/printf.c stays ILP32.

## What sh cannot do yet

Pipes and redirection need the file layer (pipe/open return -1; sh
degrades exactly as upstream intends: "panic: pipe" from the vfork
child, "open failed" messages). `&` leaves orphan ZOMBIEs (no init
reparenting). Deep `;` chains beyond the clone depth HALT the
machine — bounded recursion, honestly enforced.

## Validation

- TestXv6Sh: full scripted session in the emulator (TX-paced), the
  same one the xsh dmxgen bundle re-verifies at generation time.
- The whole differential suite passes under TCO (every call+ret in
  every program changed shape).
- Silicon: 24/24 boot pass, then the interactive transcript above.

## Next

- The file layer: fs.c stack over a flash block device — unlocks
  pipes, redirection, ls/cat/wc, and dissolves the exec registry
  into a real filesystem.
- init reparenting (orphan reaping); kill/procdump.
- Region free for exec'd images (the arena still only grows).
