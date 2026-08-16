/* Sub-word integers: signed/unsigned char and short arithmetic,
   truncation wraparound, sign/zero extension, sub-word compares. */
volatile int init = 0;

int main(void) {
  signed char sc = (signed char)(init - 100);
  unsigned char uc = (unsigned char)(init + 200);
  short ss = (short)(init - 30000);
  unsigned short us = (unsigned short)(init + 60000);
  int acc = 0;
  for (int i = 0; i < 10; i++) {
    sc = (signed char)(sc + 37);
    uc = (unsigned char)(uc * 3 + 1);
    ss = (short)(ss + 12345);
    us = (unsigned short)(us * 5 + 7);
    acc += sc * ss - uc * us;
    acc ^= (sc < 0) + (ss > 0) + (uc > 128) + (us < 30000);
  }
  return acc & 0x7FFFFFFF;
}
