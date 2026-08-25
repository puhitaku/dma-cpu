/* The SIGINT-handler demo the toolbox used to ship as `trap`: register
 * a handler, announce, spin printing dots, bow out politely on Ctrl-C.
 * It left the user-facing toolbox (a demo, not a tool) but the
 * full-system coverage it carried — sh's foreground job delivering
 * SIGINT into a userspace handler on a registry app — lives on:
 * TestXv6ShSigint registers this image under the old name. */
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
