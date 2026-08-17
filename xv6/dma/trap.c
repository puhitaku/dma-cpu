/* trap: demo of user-space SIGINT handling — Ctrl-C makes it bow out
 * politely instead of taking the default death (contrast with spin.c
 * or a plain `cat`). The handler keeps to leaf syscalls, per the
 * static-frame rule in usys.c. */
#include "kernel/types.h"
#include "user/user.h"

static void
onint(int sig)
{
  (void)sig;
  write(1, "\ncaught SIGINT; exiting politely\n", 33);
  exit(0);
}

int
main(void)
{
  signal(SIGINT, onint);
  write(1, "trap: Ctrl-C me\n", 16);
  for (;;) {
    pause(20);
    write(1, ".", 1);
  }
}
