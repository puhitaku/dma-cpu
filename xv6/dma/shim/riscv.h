/* DMA shim (xv6/PORT.md): no RISC-V, no paging. PGSIZE survives only
 * because a couple of files mention it. */
#ifndef DMA_SHIM_RISCV_H
#define DMA_SHIM_RISCV_H
#define PGSIZE 4096
typedef unsigned int pagetable_t; /* vestigial: copyout shim ignores it */
#endif
