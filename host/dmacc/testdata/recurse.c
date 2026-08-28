/* The recursion exercise: frames are static, so the cycle rides the
   software frame stack. Tree recursion so -O1 cannot rewrite it into
   a loop. */
int tree(int n) {
  if (n <= 1) return 1;
  return tree(n - 1) + tree(n - 2);
}
int main(void) { return tree(10); }
