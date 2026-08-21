/* DMA shim: the fs-facing view of a process. The scheduler-facing
 * proc table lives in kproc.c (loader ABI); this parallel per-slot
 * struct carries what fs.c/file.c need. */
#ifndef DMA_SHIM_PROC_H
#define DMA_SHIM_PROC_H
#include "param.h"
struct file;
struct inode;
struct proc {
  pagetable_t pagetable; /* vestigial (copyout shim) */
  uint64 sz;             /* flat memory: init sets ~0 so bounds pass */
  struct inode *cwd;
  struct file *ofile[NOFILE];
};
struct proc *myproc(void);
#endif
