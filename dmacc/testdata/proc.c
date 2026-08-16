/* A Phase 5a "process": the smallest useful program to schedule. Two
   relocated instances of this image run round-robin under
   prog/hil/kernel.dasm. The loop back-edge carries the safepoint where
   preemption is delivered. */
volatile unsigned int counter;

int main(void) {
  for (;;) counter++;
}
