# Phase 7 results: the xv6 file system

Typed at the silicon `$ ` prompt (Pico 2, ARM parked, 24/24 boot pass
green):

    $ cat README
    the DMA machine runs upstream xv6.
    $ echo booom from the silicon fs > note
    $ cat note
    booom from the silicon fs
    $ cat README | wc
    1 6 35
    $ echo one; echo two
    one
    two

`fs.c` and `file.c` are byte-for-byte upstream. `cat` and `wc` are
byte-for-byte upstream. The redirection created a real inode through
sysfile's create path (ialloc → dirlink → balloc); the pipe blocked
`wc` on an empty ring and completed it by deposit; exec() found both
programs by path on the filesystem. The exec registry is gone from
the boot shell: the disk is the namespace.

## Architecture: why verbatim was possible

Three properties collapse the hard parts of an fs port:
- the disk is RAM-resident and synchronous — no I/O sleep exists;
- the kernel runs to completion and is never preempted — locks can
  be no-ops with their API intact;
- memory is flat — either_copyin/out are memmove.

So the whole inode/directory/path/file layer runs to completion
inside one syscall, and upstream fs.c + file.c compile UNMODIFIED
against a small shim header set (xv6/dma/shim: no-op spinlock/
sleeplock structs, an fs-view struct proc, a buf whose data field is
a POINTER). The shadow-copy compile (Makefile) makes quoted includes
resolve shim-first, then upstream — fs.c's own fs.h/param.h/stat.h
stay upstream.

Replaced rather than shimmed (PORT.md disposition updated):
- bio.c + log.c + virtio_disk.c → xv6/dma/kbio.c (~60 lines): bread
  returns a pointer into the disk image with a refcounted 8-slot
  pool; bwrite/log_write/begin_op/end_op are no-ops. No copies, no
  log — honest for a RAM disk.
- pipe.c → xv6/dma/kpipe.c: DEPOSIT-RENDEZVOUS pipes. A blocked pipe
  end cannot loop inside this kernel (no kernel stacks), so the PEER
  completes it exactly like exit() completes wait(): writers copy
  directly into a sleeping reader's buffer; readers drain the ring
  and then feed a sleeping writer's mailbox-advanced remainder,
  completing it when nothing is left; close() completes peers (EOF /
  short count). kproc.c exposes a small scheduler fence (sleeper
  lookup, mailbox access, kcomplete, kblock) so kpipe never touches
  the ABI proc table.
- sysfile.c → the fd-level bodies in xv6/dma/kfsglue.c (open with
  O_CREATE/O_TRUNC via a reshaped create(), close, dup, fstat, pipe,
  chdir, mkdir) plus per-slot fsproc state (cwd + ofile[], console
  device on fds 0-2 through upstream's devsw) — the scheduler proc
  table's ABI is untouched.

Other pieces:
- read()'s blocking spectrum: console-empty returns -2 (usys retries
  a tick later), pipe-empty blocks by deposit, file-end returns 0 —
  so EOF finally means EOF.
- exec() loads DMX-exec files: a 13-word header (magic 'DMAX',
  segment lengths, link bases, reloc count, loader symbol offsets),
  then text, data, relocs. Text and data are readi'd STRAIGHT to
  their placement; relocations stream through a 256-byte buffer (no
  scratch allocation). fsimg (Go) writes these files and builds the
  fs image — mkfs.c reimplemented in ~200 lines of stdlib Go so
  tests and dmxgen share it.
- The arena learned to free: a first-fit allocator with coalescing;
  exec'd images are released at exit (and on re-exec), so spawn
  sessions no longer exhaust memory. `cat README | wc` peaks at two
  live images ≈ 46 KB.
- The kernel now builds in two flavors: LEAN (kproc + kfsstub, 48 KB
  text — the sched/syscall/exec bundles and narrow layouts) and FULL
  (with fs: 140 KB text). Both machine regions grew: rp2350
  0x20008000..0x2007FE00 (~480 KB), rp2040 0x20008000..0x2003FE00
  (~224 KB).

## The budget, honestly

Everything below is RAM-resident: full kernel 166 KB, sh 143 KB
(clone depth 5 — parenthesized commands are the casualty), idle,
disk 82 KB (echo/cat/wc/README), exec arena 46 KB. That is 479 KB of
480. `ls` (a 40 KB DMX file — printf-linked userland is heavy at one
word per SSA value) did NOT fit and waits, with deeper clone depths
and more disk, for the compact-encoding rung: Tier-C halves every
text segment and would roughly double the free space.

## Validation

- TestXv6Sh: the full scripted session (files, redirection, `;`
  lists, the pipe) in the emulator, TX-paced; the dmxgen xsh bundle
  re-verifies the same session at generation time.
- The whole suite passes with both kernel flavors; the lean-kernel
  bundles (sched/syscall/exec) and dma-sh are unchanged in behavior.
- Silicon: 24/24 boot pass, then the interactive transcript above.

## Next

- Compact encoding for the whole system: halves all text, brings
  back ls (and room for grep, mkdir demos, deeper clone depth).
- fstat/ls polish, unlink, init-style orphan reaping.
- Persistence: back the RAM disk with a flash region (write-through)
  so `note` survives reboot.
