/* Phase 5e spawner: two instances branch on getpid(). pid 1 idles;
   pid 2 forks (vfork semantics), the child execs the registered
   "hello" image, the parent waits and reaps it. Exercises the whole
   kernel-side loader: allocproc, kalloc placement, relocation,
   deposit-through-exec and deposit-through-exit. */
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

volatile uint idlecount;
volatile uint spawn_pid;
volatile uint reap_pid;
volatile int reap_status;

int
main(void)
{
  if (getpid() == 1) {
    for (;;)
      idlecount++;
  }
  write(1, "parent: spawning\n", 17);
  int pid = fork();
  if (pid == 0) {
    exec("hello", 0);
    write(1, "exec failed\n", 12);
    exit(111);
  }
  spawn_pid = (uint)pid;
  int st = -1;
  reap_pid = (uint)wait(&st);
  reap_status = st;
  write(1, "parent: reaped\n", 15);
  for (;;)
    pause(100);
}
