/* SYS_read exercise using upstream ulib.c's gets() and printf.c: asks
   for a name over the cooked console (kernel line discipline: echo,
   backspace editing) and greets it. Runs as a preloaded process. */
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  char buf[64];
  printf("name? ");
  gets(buf, sizeof(buf));
  buf[strlen(buf) - 1] = 0; /* chop the newline, as sh does */
  printf("hi %s!\n", buf);
  exit(0);
}
