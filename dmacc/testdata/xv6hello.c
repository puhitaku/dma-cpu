/* The exec target: loaded, placed and relocated by the kernel itself
   (kproc.c exec), never by the host loader. Must exit(), not return —
   crt0's return path halts the whole machine. */
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  write(1, "hello from exec\n", 16);
  exit(7);
}
