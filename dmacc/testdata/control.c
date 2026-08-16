/* Branches: signed/unsigned comparisons at range edges, switch, and
   local array initializers (llvm.memcpy). */
int classify(int x) {
  if (x < -100) return 1;
  if (x <= 0) return 2;
  if (x == 42) return 3;
  if (x > 1000000000) return 4;
  return 5;
}
unsigned uclass(unsigned x) {
  if (x > 0x80000000u) return 7;
  if (x >= 0x10000000u) return 8;
  if (x != 0u) return 9;
  return 10;
}
int main(void) {
  int acc = 0;
  int probes[] = {-2000000000, -101, -100, -1, 0, 1, 41, 42, 43,
                  1000000000, 1000000001, 2147483647};
  for (int i = 0; i < 12; i++) acc = acc * 7 + classify(probes[i]);
  unsigned uprobes[] = {0u, 1u, 0xFFFFFFFFu, 0x80000000u, 0x80000001u,
                        0x0FFFFFFFu, 0x10000000u};
  for (int i = 0; i < 7; i++) acc = acc * 5 + (int)uclass(uprobes[i]);
  switch (acc & 7) {
  case 0: acc += 100; break;
  case 3: acc += 300; break;
  case 5: acc += 500; break;
  default: acc += 900; break;
  }
  return acc & 0x7FFFFFFF;
}
