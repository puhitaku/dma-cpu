/* Calls: six arguments (past r0-r3), nested calls, negative args. */
int f6(int a, int b, int c, int d, int e, int f) {
  return a + 2 * b + 3 * c + 4 * d + 5 * e + 6 * f;
}
int g2(int a, int b) { return f6(a, b, a ^ b, a - b, a + b, a * b); }
int h(int a) { return g2(a, a + 1) + g2(-a, 3); }
volatile int start = -3;

int main(void) {
  int acc = 0;
  for (int i = start; i <= 3; i++) acc = acc * 13 + h(i);
  return acc & 0x7FFFFFFF;
}
