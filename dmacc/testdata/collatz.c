/* Collatz step counts: while loops, unsigned division by two (lshr),
   3n+1 (constant multiply). */
int steps(unsigned n) {
  int c = 0;
  while (n != 1u) {
    if (n & 1u) n = 3u * n + 1u;
    else n = n / 2u;
    c++;
  }
  return c;
}
int main(void) {
  int acc = 0;
  for (unsigned n = 1; n <= 30u; n++) acc += steps(n);
  return acc;
}
