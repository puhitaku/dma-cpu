#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "kernel/riscv.h"
#include "kernel/vm.h"
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  exit(r);
}

char *
strcpy(char *s, const char *t)
{
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
    ;
  return os;
}

int
strcmp(const char *p, const char *q)
{
  while (*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
  int n;

  for (n = 0; s[n]; n++)
    ;
  return n;
}

void *
memset(void *dst, int c, uint n)
{
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    cdst[i] = c;
  }
  return dst;
}

char *
strchr(const char *s, char c)
{
  for (; *s; s++)
    if (*s == c)
      return (char *)s;
  return 0;
}

char *
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
  return buf;
}

int
stat(const char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if (fd < 0)
    return -1;
  r = fstat(fd, st);
  close(fd);
  return r;
}

int
atoi(const char *s)
{
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
    n = n * 10 + *s++ - '0';
  return n;
}

void *
memmove(void *vdst, const void *vsrc, int n)
{
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    while (n-- > 0)
      *dst++ = *src++;
  } else {
    dst += n;
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}

int
memcmp(const void *s1, const void *s2, uint n)
{
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    if (*p1 != *p2) {
      return *p1 - *p2;
    }
    p1++;
    p2++;
  }
  return 0;
}

void *
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
}

char *
sbrk(int n)
{
  return sys_sbrk(n, SBRK_EAGER);
}

char *
sbrklazy(int n)
{
  return sys_sbrk(n, SBRK_LAZY);
}

// DMA port (prompts/029, no-verbatim policy): printf replacements —
// write()-based string/decimal output. Programs that only need these
// avoid printf's ~20 KB static footprint on the disk.
void
fputstr(int fd, const char *s)
{
  int n = 0;
  while (s[n])
    n++;
  write(fd, s, n);
}

void
fputnum(int fd, int v)
{
  char b[12];
  int i = 12;
  unsigned int u = v < 0 ? (unsigned int)-v : (unsigned int)v;
  do {
    b[--i] = '0' + u % 10;
    u /= 10;
  } while (u);
  if (v < 0)
    b[--i] = '-';
  write(fd, b + i, 12 - i);
}

// --- readline: raw-mode line editor (DMA port, for the demo CUI) ---
// Arrow-key editing, an 8-line history ring, and tab completion over
// directory entries. Needs SYS_ttyraw; the prompt is re-emitted on
// mid-line redraws, so the caller hands it in instead of printing it.

#include "kernel/fs.h"

#define RL_HIST 8
#define RL_MAX 128
static char rl_hist[RL_HIST][RL_MAX];
static int rl_nhist;

static void
rl_redraw(const char *prompt, char *buf, int len, int cur)
{
  fputstr(1, "\r");
  fputstr(1, prompt);
  write(1, buf, len);
  fputstr(1, "\x1b[K\r");
  fputstr(1, prompt);
  write(1, buf, cur);
}

/* Complete buf[wstart..cur): the first word of the line searches "/"
 * (where the programs live), later words the word's directory part.
 * Returns 1 when the line changed. */
static int
rl_complete(char *buf, int *len, int *cur, int max, int wstart)
{
  char dirname[RL_MAX];
  int pre = wstart, i;
  for (i = wstart; i < *cur; i++)
    if (buf[i] == '/')
      pre = i + 1;
  if (pre > wstart) {
    memmove(dirname, buf + wstart, pre - wstart);
    dirname[pre - wstart] = 0;
  } else if (wstart == 0) {
    strcpy(dirname, "/");
  } else {
    strcpy(dirname, ".");
  }
  int plen = *cur - pre;
  int fd = open(dirname, 0);
  if (fd < 0)
    return 0;
  struct dirent de;
  char common[DIRSIZ + 1];
  int nmatch = 0, clen = 0;
  while (read(fd, &de, sizeof(de)) == sizeof(de)) {
    if (de.inum == 0 || de.name[0] == '.')
      continue;
    if (plen > (int)sizeof(de.name))
      continue;
    for (i = 0; i < plen; i++)
      if (de.name[i] != buf[pre + i])
        break;
    if (i < plen)
      continue;
    int nl = 0;
    while (nl < DIRSIZ && de.name[nl])
      nl++;
    if (nmatch == 0) {
      memmove(common, de.name, nl);
      clen = nl;
    } else {
      for (i = 0; i < clen && i < nl && common[i] == de.name[i]; i++)
        ;
      clen = i;
    }
    nmatch++;
  }
  close(fd);
  if (nmatch == 0 || clen <= plen)
    return 0;
  int add = clen - plen;
  if (*len + add + 1 >= max)
    return 0;
  memmove(buf + *cur + add, buf + *cur, *len - *cur);
  memmove(buf + *cur, common + plen, add);
  *len += add;
  *cur += add;
  if (nmatch == 1 && *len + 1 < max) {
    memmove(buf + *cur + 1, buf + *cur, *len - *cur);
    buf[*cur] = ' ';
    (*len)++;
    (*cur)++;
  }
  return 1;
}

char *
readline(const char *prompt, char *buf, int max)
{
  int len = 0, cur = 0, hist = rl_nhist;
  fputstr(1, prompt);
  ttyraw(1);
  for (;;) {
    char c;
    if (read(0, &c, 1) < 1)
      break;
    if (c == '\r' || c == '\n')
      break;
    if (c == 3) { /* Ctrl-C: abandon the line */
      len = cur = 0;
      fputstr(1, "^C\n");
      fputstr(1, prompt);
      continue;
    }
    if (c == '\b' || c == 0x7F) {
      if (cur > 0) {
        memmove(buf + cur - 1, buf + cur, len - cur);
        cur--;
        len--;
        if (cur == len)
          fputstr(1, "\b \b");
        else
          rl_redraw(prompt, buf, len, cur);
      }
      continue;
    }
    if (c == 1) { /* Ctrl-A */
      cur = 0;
      rl_redraw(prompt, buf, len, cur);
      continue;
    }
    if (c == 5) { /* Ctrl-E */
      cur = len;
      rl_redraw(prompt, buf, len, cur);
      continue;
    }
    if (c == 21) { /* Ctrl-U: kill to start */
      memmove(buf, buf + cur, len - cur);
      len -= cur;
      cur = 0;
      rl_redraw(prompt, buf, len, cur);
      continue;
    }
    if (c == '\t') {
      int ws = cur;
      while (ws > 0 && buf[ws - 1] != ' ')
        ws--;
      if (rl_complete(buf, &len, &cur, max - 2, ws))
        rl_redraw(prompt, buf, len, cur);
      continue;
    }
    if (c == 0x1B) { /* ESC [ X (CSI) or ESC O X (application mode) */
      char c2 = 0, c3 = 0;
      if (read(0, &c2, 1) < 1 || (c2 != '[' && c2 != 'O'))
        continue;
      if (read(0, &c3, 1) < 1)
        continue;
      if (c3 == 'D' && cur > 0) { /* left */
        cur--;
        fputstr(1, "\b");
      } else if (c3 == 'C' && cur < len) { /* right */
        write(1, buf + cur, 1);
        cur++;
      } else if (c3 == 'H' || c3 == 'F') { /* home/end */
        cur = c3 == 'H' ? 0 : len;
        rl_redraw(prompt, buf, len, cur);
      } else if (c3 == '3') { /* delete: ESC [ 3 ~ */
        read(0, &c3, 1);
        if (cur < len) {
          memmove(buf + cur, buf + cur + 1, len - cur - 1);
          len--;
          rl_redraw(prompt, buf, len, cur);
        }
      } else if (c3 == 'A' || c3 == 'B') { /* history */
        int h = hist + (c3 == 'A' ? -1 : 1);
        if (h < 0 || h > rl_nhist || rl_nhist == 0 || rl_nhist - h > RL_HIST)
          continue;
        hist = h;
        if (h == rl_nhist) {
          len = cur = 0;
        } else {
          strcpy(buf, rl_hist[h % RL_HIST]);
          len = cur = strlen(buf);
        }
        rl_redraw(prompt, buf, len, cur);
      }
      continue;
    }
    if (c >= ' ' && c < 0x7F && len + 1 < max - 1) {
      memmove(buf + cur + 1, buf + cur, len - cur);
      buf[cur] = c;
      len++;
      cur++;
      if (cur == len)
        write(1, &c, 1);
      else
        rl_redraw(prompt, buf, len, cur);
    }
  }
  ttyraw(0);
  fputstr(1, "\n");
  if (len > 0 && len < RL_MAX) {
    buf[len] = 0;
    if (rl_nhist == 0 || strcmp(rl_hist[(rl_nhist - 1) % RL_HIST], buf) != 0) {
      strcpy(rl_hist[rl_nhist % RL_HIST], buf);
      rl_nhist++;
    }
  }
  buf[len] = '\n';
  buf[len + 1] = 0;
  return buf;
}
