# Phase 13 results: SIGINT — Ctrl-C reaches the machine

The silicon session (Pico 2, golden gen 0):

    $ cat
    ^C
    $ trap
    trap: Ctrl-C me
    ..........................................................^C
    caught SIGINT; exiting politely
    $ spin &
    spin: pid 8
    $ ......................^C-at-the-prompt......dots keep flowing...
    $ kill 8

A runaway foreground command dies to the keyboard now; a handler can
catch it instead; background jobs are untouched by a prompt-time ^C.

## Detection

cons_poll (the line discipline's RX drain) runs every tick, not just
inside SYS_read — Ctrl-C must be seen while a compute-bound job runs
and the shell reads nothing. 0x03 is never buffered; it echoes "^C"
and calls delivery. The drain is gated on `fgpid` (loader-patched,
the shell's pid): a system without an interrupt key configured may
read the UART raw from user space (dma-sh does), and the tick drain
would steal its bytes.

## Foreground

The foreground job is the subtree under the shell's current wait:
- wait(): the youngest live child (sh's fg command; older pids are
  background jobs it isn't waiting for);
- vfork suspension: the chan names the child directly (upstream sh
  runs whole pipelines inside that child, so the subtree covers both
  pipe halves).
A shell at its prompt is in neither state: no foreground job, the
interrupt is dropped, `spin &` survives. The subtree is snapshotted
before acting (terminate() reparents mid-walk otherwise), and the
parent walk stops at ppid 0 — a forked pid of 0 (an unwired nextpid
in an early test) once made every root "descend" from the victim and
Ctrl-C killed the whole machine.

## Delivery

- No handler: the kill() path — synchronous terminate for SLEEPING
  victims, the killed flag (enforced at the next kernel entry) for
  running ones. wait() reports -1.
- Handler: signal(SIGINT, fn) deposits a usys-side sigctx {entry,
  resume, save0, save1} with the kernel (SYS_signal carries its
  address — no DMX format change, no loader patches; registration
  brings everything). Delivery marks sigpend; the next kexit that
  schedules the victim saves r0/r1 (the resume point may consume a
  syscall return) and the original resume into the ctx, and resumes
  at the image's __dma_sigentry stub instead. The stub calls the
  handler, then SYS_sigreturn restores r0/r1 and jumps back. A
  victim SLEEPING in a syscall is completed with -1 first, so pause()
  returns early and the handler runs on the way out. sigpend is a
  tri-state (idle/pending/in-handler): a second ^C during a handler
  is dropped rather than clobbering the saved resume.
- Reentrancy contract (usys.c): handlers run on the interrupted
  context's static frames — keep them to leaf syscalls and flags, or
  exit. The frameless wrappers make write()/exit() safe; safepoints
  only at backward branches mean the mailbox is never mid-fill at an
  interrupt.

## Pieces

- kproc.c: fgpid, sigctx/sigpend proc fields (procWords 18),
  deliver_sigint/sigint_one/in_subtree, the kexit diversion,
  SYS_signal (23) / SYS_sigreturn (24).
- usys.c: sigctx, __dma_sigentry, signal(); user.h: SIGINT, signal().
- xv6/dma/trap.c: the polite-exit demo (on the disk).
- syncprog.c went printf-free (write(2, ...)) — the ~16 KB printf tax
  was the difference between "disk full" and shipping trap.
- Kernel growth (lean 78.6 KB text, compact fs 110 KB + 29 KB data)
  re-spaced every bundle and test layout; the cross-image overlap
  guard from prompts/025 caught each bad guess loudly.

## Validation

- TestXv6Signal (both SKUs): default death of a spinning child
  (status -1) and a handler on a child sleeping in pause(600) —
  interrupted pause returns -1, handler bumps a flag, child exits 9,
  idle survives.
- TestXv6ShSigint: the full-system session (^C on cat, trap, echo
  afterwards) against upstream sh.
- Full suite green; silicon: HIL suite PASS and the 8-check
  interactive demo above (fg kill, handler, bg survival, kill 8,
  shell alive throughout).

## Next (per the recorded roadmap)

Parenthesized sh commands; more peripherals; then the presentation
goals: HSTX DVI out, DisplayLink over PIO USB, mount() + SD.
