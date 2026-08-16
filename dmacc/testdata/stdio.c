/* Differential stdio test: printf/snprintf/puts through picolibc on the
   DMA machine vs the host libc. The exit code folds the console text so
   silicon runs are machine-checkable too. */
#include <stdio.h>
#include <string.h>

volatile int base = 100;

int main(void) {
  int acc = 0;
  char buf[48];
  printf("stdio on the DMA machine\n");
  for (int i = 0; i < 5; i++) {
    int v = (base + i) * (i - 2);
    printf("i=%d v=%d u=%u x=%x c=%c\n", i, v, (unsigned)v, (unsigned)v & 0xFFF, 'a' + i);
    acc = acc * 31 + v;
  }
  int n = snprintf(buf, sizeof buf, "[%06d|%-8s|%04x]", -1234, "left", 0xC0DE);
  puts(buf);
  acc += n + (int)strlen(buf);
  printf("acc=%d\n", acc);
  return acc & 0x7FFFFFFF;
}
