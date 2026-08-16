# Phase 5c results: xv6 syscalls on the DMA machine

Goal (xv6/PORT.md, after the pristine vendor of xv6-riscv): give the
machine its "ecall instruction" — a syscall mechanism in the shape xv6
expects — and bring up the first syscalls: `write`, `getpid`,
`uptime`, `pause` (interim yield), `exit`.

## The design that failed: syscall as a self-inflicted trap

The first implementation made a syscall look like an interrupt: the
process wrote its mailbox, self-patched its own dispatch word with the
kernel's syscall vector, and spun until the kernel marked the call
done — delivery at the next safepoint, exactly like a tick.

The emulator killed it immediately, and the trace is worth keeping.
The very first `SYS_write` worked ("hello from pid 1" arrived through
the full detour), but `ticks` stayed 0 forever: the syscall
self-patch and the injector's tick patch race on the SAME dispatch
word. A tick that lands while the process is in the self-patch loop is
overwritten before the safepoint fires — and since only the
scheduler's EOI re-arms the one-shot injector chain, a single eaten
tick kills the timer permanently. Retry loops and idempotence guards
patch around the symptom, but the race is structural.

## The design that works: syscall as a call

The realization: a syscall is *voluntary*. It does not need trap
delivery at all — the process can simply CALL the kernel:

- `xv6/dma/usys.c` (replaces `user/usys.pl`'s ecall stubs): write the
  per-process mailbox (`num, a0..a2, ret, done`), then make a plain
  indirect call through `__dma_syscall_entry` (loader-patched to this
  instance's vector). dmacc's indirect-call protocol leaves the return
  address in the caller's `lr` word.
- `kernel.dasm` `sys_from_a`/`sys_from_b` (per-process vectors, so the
  kernel knows the caller statically): set the C kernel's `r0` to the
  caller id and its `lr` to a return trampoline, `jumpr` into
  `f_dma_ksyscall`. On return, `jbool wsw`: 0 → jump through the
  caller's `lr` (plain return); 1 → save that `lr` as the resume
  point, flip `curr`, resume the other process (yield/exit path — no
  tick counted, no timer re-arm).
- `xv6/dma/ksyscall.c`: the C kernel core, compiled with
  `NoSafepoints` (the kernel is not preemptible by construction —
  its own dispatch word is never patched by anyone). Reads the
  caller's mailbox via loader-patched pointers, dispatches on the
  upstream `kernel/syscall.h` numbers, writes `ret`/`done`, and
  requests a context switch by writing the kernel's `wsw` word
  through a pointer. SYS_write copies straight from the caller's
  buffer to the UART with TXFF pacing — flat memory means no
  copyin/copyout.

Nothing in this path touches any dispatch word, so there is no race
against the tick injectors by construction: a tick that lands before
or during a syscall just stays patched and delivers at the caller's
next safepoint. Interrupts remain approach B, unchanged.

Cross-image wiring (loader/dmxgen-patched): kernel gets `kentry`,
`pKr0`, `pKlr`, `pAlr`, `pBlr` (+ the existing sched pointers); the
kernel core gets `dma_mail[2]`, `dma_wsw`, `dma_ticks`; each process
gets `__dma_syscall_entry`. A syscall costs the two mailbox-and-call
stubs plus ~10 kernel blocks — no per-syscall code in dasm at all
beyond the two vectors.

Interim semantics, to be replaced by the proc.c adaptation: `pause(n)`
yields once regardless of n; `exit(status)` records the status in the
kernel and parks the process in a safepointed spin (it stays in the
two-slot round-robin).

## Emulator validation

`TestXv6Syscalls` (dmacc/syscall_test.go): four images — kernel.dasm,
the C kernel core, and two relocated instances of
`dmacc/testdata/xv6sys.c` + `usys.ll` — one binary, branching on
`getpid()`. pid 1 writes three lines via SYS_write, spins on
`uptime()` until the clock advances 4 ticks under live preemption,
pauses twice, and exits; pid 2 counts and periodically pauses.
Asserts: the console equals the exact concatenation of pid 1's writes
(kernel-serialized), `donetick > 0`, exit status 0, and pid 2 still
advancing after pid 1's exit. PASS on rp2040 and rp2350
(ticks=39, bgcount=1572 at pid-1 exit in both).

dmxgen gained a `sysBundle` (same address window as the shell bundle;
they never run at the same time) with the same inline emulator
verification, and the firmware an `exp_syscall` stage before the shell
handoff: loads the four images, starts pid 1, arms the tick chain
(start-then-arm, per the prompts/013 race), waits for pid 1's exit,
and prints PASS with ticks/donetick/exit/bgcount. pid 1's SYS_write
lines appear directly on the UART.

## Silicon status: blocked on the probe, not the design

The full firmware (with exp_syscall) flashes and runs — fragments of
the whole test pass and the dma-sh banner are visible — but the Debug
Probe's USB-UART bridge is degraded again (the prompts/013 failure
mode, this time dropping ~99% of bytes instead of all of them; SWD
unaffected). Silicon confirmation of exp_syscall waits for a probe
replug.

Bring-up lessons that cost real time today:

- A failed `halt`/`resume` over SWD can leave the RP2350 with its
  debug domain unreachable ("Failed to read memory at 0xe000edf0"
  while DPIDR still answers) and the firmware not running. Recovery is
  always: rescue DP (`-f target/rp2350-rescue.cfg -c "init; exit"`),
  then reflash. Flashing without the rescue first fails from this
  state.
- The capture must hold one fd with raw termios for the whole window;
  `stty && cat` reopens the device and loses the stream.
- Distinguish "board dead" from "bridge dead" before touching the
  board: SWD liveness + fragment analysis of whatever bytes arrive.
  The fragments here spanned the entire pass — firmware fine, link
  sick.

## Next

- Silicon PASS of exp_syscall after the probe replug.
- proc.c adaptation: struct proc, real states (RUNNABLE/SLEEPING/
  ZOMBIE), an N-slot run queue replacing the hardwired A/B dasm
  scheduler, upstream syscall.c's dispatch-table shape.
- write() behind the file layer (console.c port) so xv6's own sh.c
  can eventually replace dma-sh.
