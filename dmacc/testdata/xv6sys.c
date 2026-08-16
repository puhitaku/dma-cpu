/* Two-instance syscall exercise (Phase 5c): the same image runs as both
   processes and branches on getpid() — pid 1 talks to the console
   through SYS_write and watches SYS_uptime advance under preemption,
   then exits; pid 2 counts in the background, yielding periodically
   via the interim pause(0). The test asserts pid 1's writes arrive
   intact and in order (kernel-serialized) and that pid 2 keeps running
   after pid 1's exit. */
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

volatile uint bgcount;   /* pid 2's heartbeat, sampled by the test */
volatile uint donetick;  /* pid 1: uptime observed just before exit */

int
main(void)
{
  if (getpid() == 1) {
    write(1, "hello from pid 1 via SYS_write\n", 31);
    uint t0 = (uint)uptime();
    while ((uint)uptime() < t0 + 4)
      ;
    write(1, "pid 1 saw the clock advance\n", 28);
    pause(0);
    pause(0);
    donetick = (uint)uptime();
    write(1, "pid 1 exiting\n", 14);
    exit(0);
  }
  for (;;) {
    bgcount++;
    if ((bgcount & 0xFFF) == 0)
      pause(0);
  }
}
