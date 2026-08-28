#include "types.h"

void *
memset(void *dst, int c, uint n)
{
  char *cdst = (char *)dst;
  uint w;

  while (n > 0 && ((uint)cdst & 3) != 0) {
    *cdst++ = c;
    n--;
  }
  w = (uchar)c;
  w |= w << 8;
  w |= w << 16;
  while (n >= 4) {
    *(uint *)cdst = w;
    cdst += 4;
    n -= 4;
  }
  while (n-- > 0) {
    *cdst++ = c;
  }
  return dst;
}

int
memcmp(const void *v1, const void *v2, uint n)
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    if (*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}

void *
memmove(void *dst, const void *src, uint n)
{
  const char *s;
  char *d;

  if (n == 0)
    return dst;

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    s += n;
    d += n;
    if ((((uint)s ^ (uint)d) & 3) == 0) {
      while (n > 0 && ((uint)d & 3) != 0) {
        *--d = *--s;
        n--;
      }
      while (n >= 4) {
        d -= 4;
        s -= 4;
        *(uint *)d = *(const uint *)s;
        n -= 4;
      }
    }
    while (n-- > 0)
      *--d = *--s;
  } else {
    if ((((uint)s ^ (uint)d) & 3) == 0) {
      while (n > 0 && ((uint)d & 3) != 0) {
        *d++ = *s++;
        n--;
      }
      while (n >= 4) {
        *(uint *)d = *(const uint *)s;
        d += 4;
        s += 4;
        n -= 4;
      }
    }
    while (n-- > 0)
      *d++ = *s++;
  }

  return dst;
}

// memcpy exists to placate GCC.  Use memmove.
void *
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
}

int
strncmp(const char *p, const char *q, uint n)
{
  while (n > 0 && *p && *p == *q)
    n--, p++, q++;
  if (n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}

char *
strncpy(char *s, const char *t, int n)
{
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    ;
  while (n-- > 0)
    *s++ = 0;
  return os;
}

// Like strncpy but guaranteed to NUL-terminate.
char *
safestrcpy(char *s, const char *t, int n)
{
  char *os;

  os = s;
  if (n <= 0)
    return os;
  while (--n > 0 && (*s++ = *t++) != 0)
    ;
  *s = 0;
  return os;
}

int
strlen(const char *s)
{
  int n;

  for (n = 0; s[n]; n++)
    ;
  return n;
}
