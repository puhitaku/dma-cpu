/* DMA shim: no paging — the layout constants usertests mentions map
 * to harmless flat-space values (the tests that probe them belong to
 * the expected-fail set on a machine without an MMU). */
#ifndef DMA_SHIM_MEMLAYOUT_H
#define DMA_SHIM_MEMLAYOUT_H
#define KERNBASE 0x20000000u
#define TRAMPOLINE (MAXVA - PGSIZE)
#define TRAPFRAME (TRAMPOLINE - PGSIZE)
#endif
