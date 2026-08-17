/* kill() + reparenting exercise (prompts/024): four instances branch
   on getpid(). pid 1 kills the spinning victim and reaps it (status
   -1); pid 2 is the idle/init adopter; pid 3 spins until killed;
   pid 4 is the victim's child — orphaned by the kill, adopted by
   init, and freed without a zombie when it later exits. */
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

volatile uint idlecount;
volatile uint vcount;
volatile uint reap_pid;
volatile int reap_status;
volatile uint done_at;

int
main(void)
{
  int pid = getpid();
  if (pid == 2) {
    for (;;)
      idlecount++;
  }
  if (pid == 1) {
    pause(3);
    kill(3);
    int st = 0;
    reap_pid = (uint)wait(&st);
    reap_status = st;
    done_at = (uint)uptime();
    for (;;)
      pause(50);
  }
  if (pid == 3) {
    for (;;)
      vcount++;
  }
  /* pid 4: the orphan-to-be */
  pause(30);
  exit(7);
}
