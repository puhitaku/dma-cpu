/* Mixed integer arithmetic over LCG-generated values: exercises add,
   sub, mul (variable), udiv, urem, and, or, xor, shl, lshr, ashr. */
unsigned lcg(unsigned *s) { *s = *s * 1664525u + 1013904223u; return *s; }

volatile unsigned seed0 = 12345;

int main(void) {
  unsigned s = seed0;
  unsigned acc = 0;
  for (int i = 0; i < 20; i++) {
    unsigned a = lcg(&s), b = lcg(&s) | 1u;
    acc += a + b;
    acc ^= a - b;
    acc += a & b;
    acc ^= a | b;
    acc += a % b;
    acc ^= a / b;
    int sa = (int)a >> 3;
    acc += (unsigned)sa;
    acc += a >> (b & 31u);
    acc += a << (b & 31u);
    acc += a * b;
  }
  return (int)(acc & 0x7FFFFFFF);
}
