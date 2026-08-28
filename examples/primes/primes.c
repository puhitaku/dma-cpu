/* Hello, DMA machine: sieve of Eratosthenes, printed with picolibc.
 *
 * printf goes to UART0: the emulator shows it as console output
 * (`make run`), and on real hardware the same bytes appear on the
 * board's serial port. main()'s return value becomes the `exitcode`
 * word. The `limit` global is volatile so clang -Oz cannot compute the
 * whole program at compile time — without it you would be flashing the
 * answer, not the computation.
 */
#include <stdio.h>

volatile int limit = 200;

static unsigned char composite[201];
int primes[64];
int nprimes;

int main(void) {
  int lim = limit;
  for (int p = 2; p * p <= lim; p++) {
    if (composite[p]) continue;
    for (int m = p * p; m <= lim; m += p) composite[m] = 1;
  }
  int checksum = 0;
  for (int n = 2; n <= lim; n++) {
    if (!composite[n]) {
      primes[nprimes++] = n;
      checksum += n;
    }
  }

  printf("Hello, DMA machine!\n");
  printf("primes up to %d:\n", lim);
  for (int i = 0; i < nprimes; i++)
    printf("%4d%c", primes[i], (i % 10 == 9 || i == nprimes - 1) ? '\n' : ' ');
  printf("count=%d checksum=%d\n", nprimes, checksum);

  /* 46 primes up to 200, summing to 4227 -> expect 4604227. */
  return nprimes * 100000 + checksum;
}
