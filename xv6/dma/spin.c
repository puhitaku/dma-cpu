/* spin: prints its pid, then emits a dot every 20 ticks forever — a
 * visible background victim for the kill demo (`spin &` then
 * `kill <pid>`: the dots stop). Formats the pid by hand to stay off
 * printf's ~20 KB disk tax (cf. killprog.c). */
#include "kernel/types.h"
#include "user/user.h"

int
main(void)
{
  char buf[16];
  int pid = getpid();
  int i = sizeof(buf);
  buf[--i] = '\n';
  do {
    buf[--i] = '0' + pid % 10;
    pid /= 10;
  } while (pid);
  write(1, "spin: pid ", 10);
  write(1, buf + i, (int)sizeof(buf) - i);
  for (;;) {
    pause(20);
    write(1, ".", 1);
  }
}
