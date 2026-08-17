# Phase 5f results: SYS_read, argv, and upstream xv6 userland on silicon

Goal: console input through the kernel and argument passing, so
registered xv6 user programs run interactively. The headline demo,
typed at the live silicon prompt:

    dma> run echo booom from real silicon
    booom from real silicon
    [pid 3 exited, status 0]

`echo` is upstream user/echo.c, linked with upstream ulib.c and
printf.c, placed and relocated by the kernel's own loader, receiving
its arguments through the new argv convention.

## What was built

- **SYS_read + cooked console** (kproc.c): the consoleintr slice of
  kernel/console.c — echo, backspace editing (`\b \b`), CR→NL, a
  128-byte line buffer; SYS_read returns only committed lines and 0
  when none is ready; the usys `read()` wrapper sleeps a tick and
  retries, so read() blocks from the caller's view. Validated by
  `TestXv6Read`: upstream `gets()`/`printf()` reading an edited line
  ("bob"+BS+"om" → "boom").
- **argv through exec**: the kernel copies the caller's argv vector
  and strings into a fresh 256-byte area and passes argc/argv through
  the new image's r0/r1 register words — crt0's `call main` leaves
  them untouched, and zero-initialized regs mean argv-less starts see
  argc=0. upstream echo.c works unmodified.
- **upstream userland compiles**: user/ulib.c and user/echo.c
  unmodified; user/printf.c narrowed to 32-bit integer paths (the
  ILP32 policy in PORT.md — its `long long` printint was the only
  i64 in the way).
- **dma-sh `run <img> [args]`**: tokenize, fork, child execs (private
  stubs only — on failure it must not printf, the parent reports),
  wait, print the exit status. The shell now links usys and
  participates in the syscall world.
- **TX pacing in the emulator** (`Machine.TXPace`): models the UART
  transmit FIFO draining at one byte per N cycles, so kernel writes
  take realistic multi-tick durations in tests and gen-time bundle
  verifications (13000 cycles/byte ≈ 115200 baud vs the 15000-cycle
  tick).
- Kernel SYS_write now emits NL as CRNL (terminal alignment; the raw
  fd semantics can return when the file layer distinguishes ttys).

## The silicon-only kernel bug: the lost-fire window

First silicon session: `run echo ...` printed "booom" and the system
hung; a later boot failed exp_exec with spawn=0 while the idle
counter ran free — the signature of a DEAD TIMER: a RUNNABLE parent
that no tick would ever schedule.

Root cause: `kenter()` checks curr's dispatch word for a pre-entry
fire and THEN retargets the injector at `tickpending`. A fire landing
between the check and the retarget patches the dispatch unseen: the
fire is never consumed, so the injector is never re-armed, and the
tick stream dies. The window is a few machine blocks out of a
15000-cycle tick (~0.1% per syscall) — invisible until the CRLF
change lengthened kernel writes and multiplied syscall time enough to
hit it within a session.

Fix: `kenter()` records the ENTRY-TIME dispatch address and thunk
(`entry_disp`/`entry_thunk` — not proc[curr].pdispatch, which exec
repoints mid-call), and `kexit()` re-checks that exact address first.
Every fire is now consumed by one of four checks (dasm detour,
entry dispatch, exit dispatch, tickpending at entry/exit), each
covering the previous one's blind window; after the retarget, fires
can only land in tickpending or on the next process's dispatch. Two
consecutive full silicon passes (24/24 green each) and a multi-spawn
interactive session confirm the fix.

Also characterized on silicon: arena exhaustion is graceful (~6
spawns on the 18 KB shell-bundle arena, then `exec` returns -1 and
`run` reports failure; the system stays healthy — the bump allocator
never frees, a known leak). And a session post-mortem: an earlier
"wedge" diagnosis was partly a shared-port artifact — minicom holding
/dev/cu.usbmodem102 splits the byte stream with any other reader.

## The blocker for upstream sh.c: recursion

The natural next step — replacing dma-sh with upstream user/sh.c —
is blocked by dmacc's v0 static frames: `parsecmd`/`runcmd` are
recursive, and dmacc rejects recursion by design. The next compiler
rung is dynamic (sp-relative) frames for functions on call-graph
cycles, keeping static frames everywhere else. With that, sh.c drops
in essentially unmodified (its fork-then-exec pattern already fits
the vfork discipline; nested fork1 for `;`/`&` needs the dynamic
frames anyway). Until then, dma-sh's `run` is the spawn surface.

## Next

- dmacc dynamic frames for recursive functions → upstream sh.c.
- Region free / refcounts for exec'd images.
- SYS_read fd semantics + console.c proper once files exist.
