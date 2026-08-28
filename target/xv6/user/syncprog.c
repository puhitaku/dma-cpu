/* `sync` for the shell (DMA-machine addition; upstream has no sync
 * userland program): asks the kernel to burn the RAM disk into the
 * flash slot. */
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  if (sync() < 0) {
    write(2, "sync: not supported\n", 20);
    exit(1);
  }
  exit(0);
}
