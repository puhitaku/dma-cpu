# Phase 9 results: the exam — upstream usertests grades the port

user/usertests.c — xv6's own 3,439-line test suite — compiles
byte-for-byte (via the shadow-include trick: shim riscv.h/memlayout.h
supply PGSIZE/MAXVA/r_sp; everything else upstream) and runs
preloaded on the compact fs kernel, one test per boot with argv poked
straight into the image's r0/r1. The curated roster:

    30 passed / 30 run

fs: opentest writetest createtest dirtest createdelete unlinkread
linktest linkunlink concreate subdir bigfile bigwrite dirfile
fourteen rmdot iref truncate1 truncate2 truncate3 unlinkcwd
proc: exectest sharedfd fourfiles openiput exitiput iput exitwait
twochildren forkfork bsstest

That includes the tests that stress exactly what this port does
differently: exitwait's 100 fork/wait rounds and twochildren's 1000
double-fork rounds run entirely on vfork discipline with deposit
completions; forkfork's grandchildren nest three vfork suspensions;
concreate interleaves (serialized by vfork, assertions intact) parent
and child creates; iref exhausts and recovers the inode cache;
sharedfd checks fd-offset sharing across fork.

## What the exam caught

- **fileclose(iput(0)) crash**: the synthetic console fds had no
  inode. Fixed the upstream way: the disk now carries a real
  `console` T_DEVICE inode (fsimg.AddDevice — mirroring mkfs), and
  kfs_start opens it for fds 0/1/2, so `ls` lists `console 3 2 0` and
  fileclose has something real to iput. (First attempt looked it up
  with a relative path before cwd existed — namei("/console").)
- **sbrk(-n)**: countfree() probes memory by growing sbrk and
  releasing it; dma/sbrk.c now shrinks, so repeated leak-checks agree.
- **dmacc i64 copy pairs**: clang -Oz coalesces two-pointer argv
  arrays into an i64 load feeding an i64 store; dmacc lowers the pair
  to two word moves (offset-capable loadWordAt/storeWordAt).

## What stays out, and why (the honest list)

- copyin/copyout/copyinstr1-3, validatetest, badarg, kernmem, pgbug,
  nowrite, textwrite-class: wild-pointer probes that EXPECT a fault —
  flat memory with no MMU faults the machine instead of the process.
- stacktest: guard pages don't exist (shim r_sp returns 0).
- pipe1, preempt, killstatus, reparent, reparent2, forkforkfork:
  need truly concurrent fork halves or kill(); vfork suspends the
  parent, and kill is a stub.
- sbrkbasic/sbrkmuch/sbrkfail/sbrkarg/sbrk8000/mem: assume paged
  growth semantics; the heap is a 36 KB static arena.
- writebig: writes a MAXFILE (268 KB) file — larger than any RAM
  disk this machine can host.

## Harness

TestXv6Usertests (skipped under -short): boots the exam image per
test (~208 KB resident: usertests text 107 KB + its 101 KB of static
test buffers), 96-block disk with the console device + echo (for
exectest), 16 KB arena. Watches for ALL TESTS PASSED / FAILED /
NO TESTS EXECUTED / panic. The exam is emulator-run; the binaries and
kernel are the identical silicon-proven stack, and the xsh silicon
session was re-validated after the console-inode change (24/24 boot,
ls showing the device inode, `echo exam passed > result; cat result`).

## Next

- Persistence (flash-backed disk); kill() + reparenting to expand the
  exam roster; a per-process sbrk arena to admit the sbrk tests.
