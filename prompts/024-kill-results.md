# Phase 11 results: kill() + reparenting — and two lost-tick hazards

The silicon session (Pico 2, everything below served by the DMA
controller):

    $ spin &
    spin: pid 5
    $ .......................................k.il.l. .5.
    ...$ echo alive
    alive

The dots interleave with the echoed `kill 5` keystrokes — spin and sh
genuinely time-share the console — and stop dead when the kill lands.

## kill() design

- `struct proc` gains `killed` (word 12; procWords 13). SYS_kill on a
  RUNNING/RUNNABLE victim sets it; enforcement happens at the victim's
  next kernel entry (tick or syscall), where the kernel calls
  terminate() instead of proceeding. A SLEEPING victim is not
  schedulable mid-syscall, so the kernel executes its death
  synchronously. Suicide (kill(getpid())) exits on the spot. ZOMBIE or
  unknown pid returns -1.
- terminate(p, status) is the one shared death path (extracted from
  SYS_exit): kfs_exit, kfree_exec, vfork release, the wait()-deposit
  reap, and NEW: reparenting. Killed processes report status -1
  (upstream xv6's convention via setkilled/exit(-1)).
- Reparenting: `initpid` (loader-patched; 0 disables) names the
  adopter — the always-runnable idle proc in every bundle. It never
  calls wait(), so its adoptees (including already-ZOMBIE children of
  the dying process) free straight to UNUSED instead of lingering.
- usys kill(); disk gains `kill` (the user/kill.c behavior, rewritten
  printf-free in user/killprog.c — printf is a ~20 KB tax per binary
  that the 128 KB disk cannot afford) and `spin` (prints its pid, dots
  forever; the demo victim).

## Regression hunt: two latent lost-tick hazards

TestXv6Syscalls froze at ticks=5 the moment kproc.c grew — pure cycle
realignment exposing bugs that predate this phase. A full-transfer
emulator trace pinned both.

1. **Cold-entry dispatch clobber.** kexit re-arms the one-shot
   injector after retargeting WRITE_ADDR at the switched-to process's
   dispatch word. Timer TREQ credits bank while the channel is
   disarmed, so the fire can land ~20 cycles later — while the
   kernel's exit stub is still running. That is fine for a normal
   resume (the vecSched patch waits in the dispatch word for the next
   safepoint), but a process being scheduled for the FIRST time
   resumed at its cold crt0 entry, whose first action writes
   dispatch = crtthunk — erasing the fire. Tick never accounted,
   timer never re-armed, machine keeps running without a clock.
   FIX: preloaded processes follow the same protocol exec already
   used ("warmstart: entry for loaders that preset dispatch
   themselves"): both loaders (test wiring + dmxgen) preset each
   image's dispatch word to its crtthunk and point the initial resume
   at `warmstart`, which skips crt0's dispatch write. No process-side
   code writes a dispatch word outside the EOI anymore.

2. **Unwakeable park.** With nothing runnable the kernel parked the
   machine at a `khalt` HALT block. A HALT stops the fetch/exec
   channels; the injector's fire is a plain memory write into a
   dispatch word and cannot restart stopped channels — so a system
   whose processes all sleep (the syscall bundle after pid 1 exits;
   pid 2 alone in pause(0)) died at the first parked fire. It had
   only ever survived by scheduling luck ("keep an always-runnable
   process").
   FIX: the park is now a live spin: `parkloop: jumpr parkvec`, with
   kexit aiming the injector at `parkvec` — the park loop's own
   dispatch word, same discipline as any process. The fire patches it
   and the spin detours into sched_entry: tick accounted, sleepers
   woken, machine breathing at timer pace while "idle". Because curr
   may be a freed zombie at park time (exit with nothing runnable),
   every published cur* word points at the park cells, and kenter's
   `parked` flag skips the dispatch-word checks on the way back in;
   dma_ktick skips the resume save for park wakes (nothing was
   executing).

EXP syscall on silicon now shows `bgcount=168->849` after pid 1's
exit — the survivor advancing on park wakes over real DMA hardware.

## Disk geometry

fsimg drops the 8-block log region (nlog 0): the DMA kernel's log
layer is a no-op (kbio.c), and the blocks were the difference between
"disk full" and shipping kill + spin alongside echo/cat/wc/ls/sync in
128 KB.

## Validation

- TestXv6Kill (new, both SKUs): four preloaded instances on the lean
  kernel — pid 1 kills the spinning pid 3 (RUNNING victim; the kill
  lands at its next tick), wait() returns pid 3 / status -1, the slot
  frees, vcount stops; pid 4 (child of the victim) is adopted by init
  pid 2 and frees zombie-free when it later exit(7)s; idle survives.
- Full suite green both SKUs (usertests 30/30, persist three-boot
  loop, all dmxgen bundle verifications).
- Silicon: full HIL suite PASS; interactive demo above (SLEEPING
  victim — the complementary kill path to the emulator test);
  persistence re-verified on the new geometry (sync, hard reset,
  "disk: FLASH SLOT gen 1", file intact).

## Next (per the recorded roadmap)

Per-process heap (real sbrk semantics), parenthesized sh; then the
presentation goals: HSTX DVI out, DisplayLink over PIO USB, mount() +
SD.
