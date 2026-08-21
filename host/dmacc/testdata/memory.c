/* Memory: local and global arrays, structs with sub-word fields,
   pointer walks, string bytes, and a bubble sort. */
typedef struct { char tag; short v; int w; } Item;
Item items[5];

int strsum(const char *s) {
  int n = 0;
  while (*s) n = n * 31 + *s++;
  return n;
}
void bubble(int *a, int n) {
  for (int i = 0; i < n; i++)
    for (int j = 0; j + 1 < n - i; j++)
      if (a[j] > a[j + 1]) { int t = a[j]; a[j] = a[j + 1]; a[j + 1] = t; }
}
int main(void) {
  int a[8] = {5, -3, 9, 0, -7, 2, 8, 1};
  bubble(a, 8);
  int acc = 0;
  for (int i = 0; i < 8; i++) acc = acc * 10 + a[i] + 7;
  for (int i = 0; i < 5; i++) {
    items[i].tag = (char)(i * 50);
    items[i].v = (short)(i * 1000 - 1500);
    items[i].w = i * 123456;
  }
  for (int i = 0; i < 5; i++) acc += items[i].tag + items[i].v + items[i].w;
  acc += strsum("dma-cpu");
  return acc & 0x7FFFFFFF;
}
