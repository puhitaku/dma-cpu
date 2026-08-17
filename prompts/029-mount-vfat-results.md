# Phase 16 results: free, mount, and FAT32 — plus the end of the printf tax

The silicon session (Pico 2; the firmware staged the golden vfat
volume into flash at 0x10140000 on first boot):

    $ free
    arena: total 77312  used 52224  free 25088  largest 25088
    of it: heap 33024  exec 19200
    procs: 3/8  uptime 545 ticks
    $ mkdir /mnt
    $ mount fat0 /mnt
    $ mount
    fat0 on /mnt type vfat (ro)
    $ ls /mnt
    hello.txt      2 4 30
    ls: cannot stat /mnt/presentation-n
    sub            1 3 512
    $ cat /mnt/HELLO.TXT
    hello from vfat on real flash
    $ cat /mnt/presentation-notes.txt
    the DMA CPU mounts FAT32 now
    $ cd /mnt/SUB
    $ cat NESTED.TXT
    nested vfat read
    $ cd /
    $ mount -u /mnt

## free (SYS_meminfo)

The kernel walks its arena free list and ownership tables: arena
total/free/largest, the heap share (live sbrk chunks, via their
kalloc size headers), the exec share (placed images + argv areas),
proc slots, ticks. The silicon numbers read true: sh's 33 KB umalloc
chunk plus the running tool's own 19 KB image.

## mount (SYS_mount / SYS_umount)

One mount point, path-prefix routed in kfsglue: paths under the
target (and relative paths whenever the cwd is a FAT directory) go to
the FAT driver instead of namei. `cd` into and out of the mount
works; exec from a FAT cwd falls back to the xv6 root (FAT holds no
DMX executables and its nodes must not leak into namei). Every write
path — O_CREATE, write opens, link/unlink/mkdir — is refused under
the mount. umount refuses while any FAT node is referenced (open fd
or a cwd inside). `mount` with no arguments prints the table.

The file layer required NO fs.c/file.c patches: shim defs.h renames
file.c's inode calls (readi/writei/ilock/iunlock/iput/stati) to vfs_*
dispatch shims when the Makefile compiles it with -DDMA_VFS_CALLS;
the shims route FAT nodes (dev 0xFA7, masquerading as struct inode)
to kfat.c and everything else onward.

## FAT32 (xv6/dma/kfat.c, read-only)

BPB-driven geometry (512-byte sectors required; sectors-per-cluster,
reserved count, FAT size/count, root cluster all read from the boot
sector, so PC-formatted volumes and future SD cards parse the same),
cluster-chain walks over the XIP window, 8.3 names lowercased plus
VFAT long-name assembly, directories synthesized as xv6 dirents so
upstream ls iterates them unchanged (names past DIRSIZ list but
cannot be stat'ed via their truncated form — visible above, honest).
fsimg/fatimg.go builds volumes in Go (BPB, FSInfo, FAT chains, LFN
entries with checksums) for tests and the baked golden image. Small
volumes carry a FAT32 BPB below the spec's 65525-cluster threshold —
the driver trusts the BPB, as noted in both files.

## The printf purge (the no-verbatim decision)

Mid-phase the standing verbatim rule was lifted: printf costs ~20 KB
per statically-linked binary and the sizing pressure was constant.
- ulib.c gained fputstr/fputnum (write()-based); cat.c, ls.c and
  sh.c now emit through them with byte-identical output. sh dropped
  printf entirely.
- The dma utilities merged into ONE multi-call `toolbox` binary
  (argv[0] dispatch, busybox-style): kill, spin, trap, free, sync,
  mount, umount, wc, mkdir — stored once, hard-linked under each
  name (fsimg.AddLink). wc reimplements upstream's counting and
  output shape printf-free.
- The disk shrank to 96 KB; machine RAM gained the firmware's unused
  low headroom (base 0x20002000 — bss ends at ~0x20000DD0, and the
  boot check still FATALs if that ever changes).
- A patching lesson for the record: upstream sh's `cannot cd` was an
  UNBRACED single-statement if — a three-statement replacement leaked
  two statements out of it.

## Two more real bugs shaken out

- The every-tick console drain (prompts/026) DROPPED input beyond the
  128-byte cooked buffer — scripted feeds lost commands mid-word.
  cons_poll now stops draining at a full buffer (backpressure into
  the RX FIFO) instead of popping-and-dropping.
- Flash staging while the machine runs is forbidden twice over: the
  SDK flash calls need a RAM source (a rodata source hard-faults with
  XIP down), and the running machine reads the fs slot header over
  XIP — the vfat staging now runs before dmx_start and bounces each
  sector through RAM.

## Validation

- TestXv6Mount: mount/list/ls (8.3 + LFN + subdir + multi-cluster
  file)/cat by both names/cd + relative reads/read-only guard/
  umount/echo-after, against the emulator's XIP-window flash.
- Full suite green both SKUs (exam 36/36 on the slimmed images).
- Silicon: the 7-check session above; the firmware staged the 64 KB
  golden volume once ("XSH: staged the vfat volume (65536 bytes)")
  and `mount fat0 /mnt` reads it from real flash.

## Next (per the recorded roadmap)

More peripherals; then the presentation goals: HSTX DVI out,
DisplayLink over PIO USB, and mount()'s obvious sequel — the SD card
as a second, writable FAT volume.
