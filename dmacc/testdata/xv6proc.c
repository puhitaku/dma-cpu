/* Process-lifecycle exercise (Phase 5d): three instances of this image
   branch on getpid(). pid 1 is the always-runnable idle counter, pid 2
   waits for its child, pid 3 sleeps 5 ticks then exits with status 42.
   The console order is deterministic: the parent announces and blocks
   in wait() long before the child's 5-tick sleep expires; the child's
   exit deposits pid+status into the sleeping parent's mailbox. */
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

volatile uint idlecount;
volatile uint reap_pid;
volatile int reap_status;
volatile uint parent_done;

int
main(void)
{
  int pid = getpid();
  if (pid == 1) {
    for (;;)
      idlecount++;
  }
  if (pid == 2) {
    write(1, "parent: waiting\n", 16);
    int st = -1;
    reap_pid = (uint)wait(&st);
    reap_status = st;
    write(1, "parent: reaped\n", 15);
    parent_done = (uint)uptime();
    exit(0);
  }
  /* pid 3: the child */
  pause(5);
  write(1, "child: exiting\n", 15);
  exit(42);
}
