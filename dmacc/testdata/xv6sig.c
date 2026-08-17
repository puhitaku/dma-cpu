/* SIGINT exercise (prompts/026), branching on getpid() like the other
 * kernel exercises. pid 2 is the always-runnable idle keeper; pid 1
 * plays the shell: it runs two foreground children and takes Ctrl-C
 * (fed by the test harness) against each.
 *
 * Phase 1: a spinning child with no handler — the default death; the
 * parent's wait() must report status -1.
 * Phase 2: a child sleeping in pause(600) with a handler — the
 * interrupted pause returns -1, the handler bumps caught, and the
 * child exits 9 by itself.
 */
#include "kernel/types.h"
#include "user/user.h"

volatile uint phase;
volatile uint st1 = 111, st2 = 111;
volatile uint caught;
volatile uint vspin;
volatile uint idlecnt;
volatile uint done;

static void
onint(int sig)
{
  (void)sig;
  caught++;
}

int
main(void)
{
  if (getpid() == 2) {
    for (;;)
      idlecnt++;
  }

  phase = 1;
  int st = 0;
  int pid = fork();
  if (pid == 0) {
    for (;;)
      vspin++;
  }
  wait(&st);
  st1 = (uint)st;

  phase = 2;
  pid = fork();
  if (pid == 0) {
    signal(SIGINT, onint);
    int r = pause(600);
    if (r == -1 && caught)
      exit(9);
    exit(3);
  }
  wait(&st);
  st2 = (uint)st;
  done = 1;
  for (;;)
    pause(50);
}
