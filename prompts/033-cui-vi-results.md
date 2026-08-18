# Phase 19 results: a real CUI — readline in sh, and BusyBox vi

Two demonstration upgrades: the shell prompt gained readline-style
editing, and the machine now runs a genuine vi — BusyBox 1.38.0's
editor, ported nearly verbatim.

## Raw mode

Both features stand on one kernel primitive: `SYS_ttyraw` turns the
console line discipline off, delivering every byte uncooked and
unechoed (Ctrl-C included). The mode is owned by the enabling process
and reset if it dies, so a crashed editor cannot wedge the console.
`read_nb()` gives user space one non-blocking read attempt — the
trick that lets a lone ESC (the vi key) be told apart from an ESC [ A
arrow sequence by waiting a single tick for a tail.

## readline

`readline()` in ulib: arrows, home/end/delete, Ctrl-A/E/U, an 8-line
history ring, and tab completion over directory entries — the first
word of a line completes against "/" (where the programs live), later
words against the word's own directory part. Plain typing emits
byte-for-byte what the cooked discipline emitted, so every existing
console-matching test passed unchanged. sh's text grew 47.5 → 65.0 KB
— flash-resident under XIP, so the SRAM cost is 2 KiB.

## vi

`xv6/user/vi.c` is BusyBox's editors/vi.c with its GPLv2 header
retained and three kinds of patches: xv6's 2-argument open (O_TRUNC
up front, no ftruncate), no getopt/EXINIT/.exrc, and an xv6 `main()`.
The whole BusyBox runtime it expects is replaced by one compat header
(`xv6/user/libbb.h`): feature config (colon commands, search,
yank/mark on; undo, regex, signals, dot-repeat off), ctype/string
helpers, a size-aware `xrealloc` over umalloc's block header, a tiny
`vsnprintf`, a KEYCODE_* ESC decoder with one byte of type-ahead, and
a NULL-tolerant `free` — umalloc's `free(NULL)` walks the free list
from address -8, which is exactly where the first crash pointed (and
the stray -4 also exposed wrap-around holes in the emulator's bounds
checks, now closed).

## Sizes, as asked

    vi (compact, -Os):  text 125,864   data 35,340   relocs 28,100
    flash image:        273,604 bytes (text+data+packed relocs)
    running footprint:  ~161 KB of arena while an edit session lives

That is bigger than the fs kernel itself — no chance against the
96 KB RAM disk. So vi ships as a kernel-registry image whose blobs
stay in flash: exec copies text and data into the arena and applies
the relocs straight from XIP, and `vi file` works from the prompt
with no mount. Embedding it pushed the firmware over the old 1 MiB
boundary, so the flash map now spans the Pico 2's full 4 MiB part:

    0x10000000  firmware + embedded blobs (< 2 MiB)
    0x10200000  persistent fs slot
    0x10240000  vfat volume
    0x10260000  kernel text (XIP)      0x102A0000  sh text (XIP)
    0x102C0000  vi registry image      0x103F0000  cal scratch

The full emulator suite is green, including TestXv6Vi (insert two
lines, :wq, verify with cat) and TestXv6Readline (arrow edits, tab
completion, history recall).
