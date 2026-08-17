/* Lean-kernel stub: satisfies kproc.c's fs externs for builds without
 * the file layer (the sched/syscall/exec bundles and the narrow
 * rp2040 layouts). dma_disk stays 0, so none of these ever run. */
#include "kernel/types.h"

uint dma_disk;
uint dma_disksize;
uint fsready;

void kfs_start(void) {}
void kfs_forkcopy(int parent, int child) { (void)parent; (void)child; }
void kfs_exit(int slot) { (void)slot; }
int kfs_read(int fd, uint addr, int n) { (void)fd; (void)addr; (void)n; return -1; }
int kfs_write(int fd, uint addr, int n) { (void)fd; (void)addr; (void)n; return -1; }
int kfs_open(uint pathaddr, int omode) { (void)pathaddr; (void)omode; return -1; }
int kfs_close(int fd) { (void)fd; return -1; }
int kfs_dup(int fd) { (void)fd; return -1; }
int kfs_fstat(int fd, uint staddr) { (void)fd; (void)staddr; return -1; }
int kfs_pipe(uint fdarray) { (void)fdarray; return -1; }
int kfs_chdir(uint pathaddr) { (void)pathaddr; return -1; }
int kfs_mkdir(uint pathaddr) { (void)pathaddr; return -1; }
int kfs_link(uint oldaddr, uint newaddr) { (void)oldaddr; (void)newaddr; return -1; }
int kfs_unlink(uint pathaddr) { (void)pathaddr; return -1; }
int kflash_sync(void) { return -1; }
void kflash_init(void) {}
uint kflash_arm;
uint kfs_iopen(const char *path) { (void)path; return 0; }
int kfs_iread(uint ipu, uint off, uint dst, uint n) { (void)ipu; (void)off; (void)dst; (void)n; return -1; }
void kfs_iclose(uint ipu) { (void)ipu; }

int
kfs_mount(uint srcaddr, uint tgtaddr)
{
  (void)srcaddr;
  (void)tgtaddr;
  return -1;
}

int
kfs_umount(uint tgtaddr)
{
  (void)tgtaddr;
  return -1;
}
