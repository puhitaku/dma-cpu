/* Hello, DMA machine: sieve of Eratosthenes.
 *
 * main()'s return value becomes the `exitcode` word; global variables
 * are visible by name after the run (`-dump primes:46`). The `limit`
 * global is volatile so clang -O1 cannot compute the whole program at
 * compile time — without it you would be flashing the answer, not the
 * computation.
 */
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
  /* 46 primes up to 200, summing to 4227 -> expect 4604227. */
  return nprimes * 100000 + checksum;
}
