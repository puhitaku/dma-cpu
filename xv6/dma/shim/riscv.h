/* DMA shim (xv6/PORT.md): no RISC-V, no paging. PGSIZE survives only
 * because a couple of files mention it. */
#ifndef DMA_SHIM_RISCV_H
#define DMA_SHIM_RISCV_H
#define PGSIZE 4096
#define MAXVA (1u << 31) /* the top of a 32-bit flat space, near enough */
typedef unsigned int pagetable_t; /* vestigial: copyout shim ignores it */

/* usertests' stacktest reads the stack pointer; this machine has no
 * meaningful sp register — the test lands in the expected-fail set. */
static inline uint64
r_sp(void)
{
  return 0;
}
#endif
