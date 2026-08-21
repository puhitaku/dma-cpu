/* libbb.h — DMA-port compat shim for the BusyBox vi port (user/vi.c).
 *
 * vi.c comes from BusyBox 1.38.0 (GPLv2, editors/vi.c) and includes
 * "libbb.h" for the whole BusyBox runtime. This header replaces that
 * runtime with the xv6 user library: everything vi actually calls is
 * either mapped to ulib/usys or implemented here as a static helper.
 * Single-translation-unit by design — only vi.c includes it, so the
 * helpers can be static and dmacc's reachability GC drops the unused.
 */
#ifndef DMA_LIBBB_H
#define DMA_LIBBB_H

#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

#include <stdarg.h>
#include <stddef.h>
#include <limits.h>

/* --- BusyBox config: the feature set of this port --- */
#define ENABLE_FEATURE_VI_COLON 1
#define ENABLE_FEATURE_VI_COLON_EXPAND 0
#define ENABLE_FEATURE_VI_YANKMARK 1
#define ENABLE_FEATURE_VI_SEARCH 1
#define ENABLE_FEATURE_VI_REGEX_SEARCH 0
#define ENABLE_FEATURE_VI_USE_SIGNALS 0
#define ENABLE_FEATURE_VI_DOT_CMD 0
#define ENABLE_FEATURE_VI_READONLY 0
#define ENABLE_FEATURE_VI_SETOPTS 0
#define ENABLE_FEATURE_VI_SET 0
#define ENABLE_FEATURE_VI_WIN_RESIZE 0
#define ENABLE_FEATURE_VI_ASK_TERMINAL 0
#define ENABLE_FEATURE_VI_UNDO 0
#define ENABLE_FEATURE_VI_UNDO_QUEUE 0
#define ENABLE_FEATURE_VI_VERBOSE_STATUS 0
#define ENABLE_FEATURE_VI_8BIT 0
#define ENABLE_FEATURE_ALLOW_EXEC 0
#define ENABLE_FEATURE_VI_REGEX_SEARCH 0
#define ENABLE_LOCALE_SUPPORT 0
#define ENABLE_PLATFORM_MINGW32 0
#define CONFIG_FEATURE_VI_MAX_LEN 256

#define IF_FEATURE_VI_COLON(...) __VA_ARGS__
#define IF_FEATURE_VI_COLON_EXPAND(...)
#define IF_FEATURE_VI_YANKMARK(...) __VA_ARGS__
#define IF_FEATURE_VI_SEARCH(...) __VA_ARGS__
#define IF_FEATURE_VI_REGEX_SEARCH(...)
#define IF_FEATURE_VI_USE_SIGNALS(...)
#define IF_FEATURE_VI_DOT_CMD(...)
#define IF_FEATURE_VI_READONLY(...)
#define IF_FEATURE_VI_SETOPTS(...)
#define IF_FEATURE_VI_SET(...)
#define IF_FEATURE_VI_UNDO(...)
#define IF_FEATURE_VI_UNDO_QUEUE(...)
#define IF_FEATURE_VI_ASK_TERMINAL(...)

/* --- types and attribute noise --- */
typedef int smallint;
typedef unsigned uintptr_t;
static int errno; /* only ever tested; nothing here sets it */
#define EAGAIN 11
#define STRERROR_FMT "(error)"
#define STRERROR_ERRNO /* no strerror: the format stands alone */
#define ARRAY_SIZE(x) (int)(sizeof(x) / sizeof((x)[0]))
#define S_ISREG(t) ((t) == 2 /* T_FILE, kernel/stat.h */)
#define st_mode type
typedef unsigned smalluint;
#define FAST_FUNC
#define ALIGN1
#define NOINLINE
#define ALWAYS_INLINE inline
#define UNUSED_PARAM __attribute__((unused))
#define MAIN_EXTERNALLY_VISIBLE
#ifndef TRUE
#define TRUE 1
#define FALSE 0
#endif
#define STDIN_FILENO 0
#define STDOUT_FILENO 1
#define STDERR_FILENO 2

/* --- ctype (ASCII only) --- */
static int bb_isspace(int c) { return c == ' ' || (c >= 9 && c <= 13); }
static int bb_isdigit(int c) { return c >= '0' && c <= '9'; }
static int bb_islower(int c) { return c >= 'a' && c <= 'z'; }
static int bb_isupper(int c) { return c >= 'A' && c <= 'Z'; }
static int bb_isalpha(int c) { return bb_islower(c) || bb_isupper(c); }
static int bb_isalnum(int c) { return bb_isalpha(c) || bb_isdigit(c); }
static int bb_isblank(int c) { return c == ' ' || c == '\t'; }
static int bb_ispunct(int c)
{
  return c > ' ' && c < 0x7F && !bb_isalnum(c);
}
static int bb_tolower(int c) { return bb_isupper(c) ? c + 32 : c; }
static int bb_toupper(int c) { return bb_islower(c) ? c - 32 : c; }
#define isspace bb_isspace
#define isdigit bb_isdigit
#define islower bb_islower
#define isupper bb_isupper
#define isalpha bb_isalpha
#define isalnum bb_isalnum
#define isblank bb_isblank
#define ispunct bb_ispunct
#define tolower bb_tolower
#define toupper bb_toupper
#define isprint_asciionly(c) ((unsigned char)(c) >= ' ' && (unsigned char)(c) < 0x7F)

/* --- string helpers ulib does not provide --- */
static char *bb_strcat(char *d, const char *s)
{
  char *r = d;
  while (*d)
    d++;
  while ((*d++ = *s++))
    ;
  return r;
}
static char *bb_strncpy(char *d, const char *s, int n)
{
  int i = 0;
  for (; i < n && s[i]; i++)
    d[i] = s[i];
  for (; i < n; i++)
    d[i] = 0;
  return d;
}
static int bb_strncmp(const char *a, const char *b, int n)
{
  while (n-- && *a && *a == *b)
    a++, b++;
  return n < 0 ? 0 : (unsigned char)*a - (unsigned char)*b;
}
static void *bb_memcpy(void *d, const void *s, uint n) { return memmove(d, s, (int)n); }
static void *bb_memchr(const void *p, int c, uint n)
{
  const unsigned char *b = p;
  for (uint i = 0; i < n; i++)
    if (b[i] == (unsigned char)c)
      return (void *)(b + i);
  return 0;
}
static char *bb_strchrnul(const char *s, int c)
{
  while (*s && *s != c)
    s++;
  return (char *)s;
}
static char *last_char_is(const char *s, int c)
{
  if (s && *s) {
    uint n = strlen(s);
    if (s[n - 1] == c)
      return (char *)&s[n - 1];
  }
  return 0;
}
#define strcat bb_strcat
#define strncpy bb_strncpy
#define strncmp bb_strncmp
#define memcpy bb_memcpy
#define memchr bb_memchr
#define strchrnul bb_strchrnul

/* --- allocation: umalloc plus a size-aware realloc. The Header
 * mirror must match user/umalloc.c (unit = 8 bytes, size in units
 * including the header). --- */
typedef union bb_header {
  struct {
    union bb_header *ptr;
    uint size;
  } s;
  long x[2];
} BBHeader;

static void *xmalloc(int n)
{
  void *p = malloc(n ? n : 1);
  if (!p) {
    fputstr(2, "vi: out of memory\n");
    exit(1);
  }
  return p;
}
static void *xzalloc(int n)
{
  void *p = xmalloc(n);
  memset(p, 0, (uint)n);
  return p;
}
static void *xrealloc(void *old, int n)
{
  if (!old)
    return xmalloc(n);
  BBHeader *h = (BBHeader *)old - 1;
  int oldb = (int)(h->s.size - 1) * (int)sizeof(BBHeader);
  void *p = xmalloc(n);
  memmove(p, old, oldb < n ? oldb : n);
  free(old);
  return p;
}
static char *xstrdup(const char *s)
{
  char *p = xmalloc((int)strlen(s) + 1);
  strcpy(p, s);
  return p;
}
/* umalloc's free() has no NULL tolerance ((Header*)0 - 1 walks the
 * free list from -8); libc callers like vi free(NULL) freely. */
static void bb_free(void *p)
{
  if (p)
    free(p);
}
#define free bb_free

static char *xstrndup(const char *s, int n)
{
  int l = 0;
  while (l < n && s[l])
    l++;
  char *p = xmalloc(l + 1);
  memmove(p, s, l);
  p[l] = 0;
  return p;
}

/* --- tiny vsnprintf: %s %c %d %u and the "%u;%uH" cursor escape are
 * everything the enabled features format. --- */
static int bb_vsnprintf(char *out, int cap, const char *fmt, va_list ap)
{
  int n = 0;
  char tmp[12];
  for (; *fmt; fmt++) {
    if (*fmt != '%') {
      if (n + 1 < cap)
        out[n] = *fmt;
      n++;
      continue;
    }
    fmt++;
    if (*fmt == '%') {
      if (n + 1 < cap)
        out[n] = '%';
      n++;
      continue;
    }
    if (*fmt == 'c') {
      char c = (char)va_arg(ap, int);
      if (n + 1 < cap)
        out[n] = c;
      n++;
      continue;
    }
    if (*fmt == 's') {
      const char *s = va_arg(ap, const char *);
      if (!s)
        s = "(null)";
      while (*s) {
        if (n + 1 < cap)
          out[n] = *s;
        n++;
        s++;
      }
      continue;
    }
    if (*fmt == 'd' || *fmt == 'u') {
      int v = va_arg(ap, int);
      uint u = (uint)v;
      int i = 12;
      if (*fmt == 'd' && v < 0)
        u = (uint)-v;
      do {
        tmp[--i] = '0' + (char)(u % 10);
        u /= 10;
      } while (u);
      if (*fmt == 'd' && v < 0)
        tmp[--i] = '-';
      for (; i < 12; i++) {
        if (n + 1 < cap)
          out[n] = tmp[i];
        n++;
      }
      continue;
    }
    /* unknown directive: emit verbatim so bugs are visible */
    if (n + 2 < cap) {
      out[n] = '%';
      out[n + 1] = *fmt;
    }
    n += 2;
  }
  if (cap > 0)
    out[n < cap ? n : cap - 1] = 0;
  return n;
}
static int bb_snprintf(char *out, int cap, const char *fmt, ...)
{
  va_list ap;
  va_start(ap, fmt);
  int n = bb_vsnprintf(out, cap, fmt, ap);
  va_end(ap);
  return n;
}
static int bb_sprintf(char *out, const char *fmt, ...)
{
  va_list ap;
  va_start(ap, fmt);
  int n = bb_vsnprintf(out, 0x7FFFFFF, fmt, ap);
  va_end(ap);
  return n;
}
#define vsnprintf bb_vsnprintf
#define snprintf bb_snprintf
#define sprintf bb_sprintf

/* --- I/O --- */
static int safe_read(int fd, void *buf, int n) { return read(fd, buf, n); }
static int full_read(int fd, void *buf, int n)
{
  char *b = buf;
  int got = 0;
  while (got < n) {
    int r = read(fd, b + got, n - got);
    if (r <= 0)
      break;
    got += r;
  }
  return got;
}
static int full_write(int fd, const void *buf, int n) { return write(fd, buf, n); }
static void bb_putchar(int c)
{
  char b = (char)c;
  write(1, &b, 1);
}
static void fflush_all(void) {}

struct pollfd {
  int fd;
  short events, revents;
};
#define POLLIN 1
static int safe_poll(struct pollfd *pfd, int n, int ms)
{
  (void)pfd;
  (void)n;
  if (ms > 0)
    pause(ms / 15 + 1); /* ~tick-granular sleep */
  return 0;
}

/* --- terminal --- */
#define VERASE 2
#define TERMIOS_RAW_CRNL 1
struct termios {
  unsigned char c_cc[4];
};
static int set_termios_to_raw(int fd, struct termios *t, int flags)
{
  (void)fd;
  (void)flags;
  t->c_cc[VERASE] = 8;
  return ttyraw(1);
}
static int tcsetattr_stdin_TCSANOW(const struct termios *t)
{
  (void)t;
  return ttyraw(0);
}
static int get_terminal_width_height(int fd, unsigned *w, unsigned *h)
{
  (void)fd;
  *w = 80;
  *h = 24;
  return 0;
}

/* --- key decoding: the KEYCODE_* protocol of libbb read_key --- */
enum {
  KEYCODE_UP = -2,
  KEYCODE_DOWN = -3,
  KEYCODE_RIGHT = -4,
  KEYCODE_LEFT = -5,
  KEYCODE_HOME = -6,
  KEYCODE_END = -7,
  KEYCODE_INSERT = -8,
  KEYCODE_DELETE = -9,
  KEYCODE_PAGEUP = -10,
  KEYCODE_PAGEDOWN = -11,
  KEYCODE_BUFFER_SIZE = 16,
};
static int bb_readc(void)
{
  char c;
  if (read(0, &c, 1) < 1)
    return -1;
  return (unsigned char)c;
}
/* One byte of type-ahead survives an ESC that turns out to be bare. */
static int bb_key_pending = -1;
static int safe_read_key(int fd, char *scratch, int timeout)
{
  (void)fd;
  (void)scratch;
  (void)timeout;
  int c;
  if (bb_key_pending >= 0) {
    c = bb_key_pending;
    bb_key_pending = -1;
    return c;
  }
  c = bb_readc();
  if (c != 0x1B)
    return c;
  /* ESC: wait one tick for a CSI tail; a lone ESC is the vi key. */
  pause(2);
  int c2;
  {
    char b;
    if (read_nb(0, &b, 1) < 1)
      return 0x1B;
    c2 = (unsigned char)b;
  }
  if (c2 != '[' && c2 != 'O') {
    bb_key_pending = c2;
    return 0x1B;
  }
  int c3 = bb_readc();
  switch (c3) {
  case 'A': return KEYCODE_UP;
  case 'B': return KEYCODE_DOWN;
  case 'C': return KEYCODE_RIGHT;
  case 'D': return KEYCODE_LEFT;
  case 'H': return KEYCODE_HOME;
  case 'F': return KEYCODE_END;
  case '1': bb_readc(); return KEYCODE_HOME;   /* ESC[1~ */
  case '2': bb_readc(); return KEYCODE_INSERT; /* ESC[2~ */
  case '3': bb_readc(); return KEYCODE_DELETE; /* ESC[3~ */
  case '4': bb_readc(); return KEYCODE_END;    /* ESC[4~ */
  case '5': bb_readc(); return KEYCODE_PAGEUP;
  case '6': bb_readc(); return KEYCODE_PAGEDOWN;
  }
  return c3;
}

/* --- stdio-ish --- */
#define stdout 1
static int puts(const char *s)
{
  fputstr(1, s);
  fputstr(1, "\n");
  return 0;
}
static void fputs_stdout(const char *s) { fputstr(1, s); }
static uint bb_fwrite(const void *p, uint sz, uint n, int stream)
{
  (void)stream;
  write(1, p, (int)(sz * n));
  return n;
}
#define fwrite bb_fwrite
static void *memrchr(const void *p, int c, uint n)
{
  const unsigned char *b = p;
  while (n--)
    if (b[n] == (unsigned char)c)
      return (void *)(b + n);
  return 0;
}

/* --- llist (initial :commands from argv) --- */
typedef struct llist_t {
  struct llist_t *link;
  char *data;
} llist_t;
static void llist_add_to_end(llist_t **head, void *data)
{
  llist_t *n = xzalloc(sizeof(llist_t));
  n->data = data;
  while (*head)
    head = &(*head)->link;
  *head = n;
}
static void *llist_pop(llist_t **head)
{
  llist_t *n = *head;
  void *d = 0;
  if (n) {
    d = n->data;
    *head = n->link;
    free(n);
  }
  return d;
}

/* --- more string/libbb helpers --- */
#define O_CREAT O_CREATE
static int ftruncate(int fd, int n)
{
  /* file_write opens with O_TRUNC and writes the whole buffer, so the
   * post-write shrink is already a no-op here */
  (void)fd;
  (void)n;
  return 0;
}
static char *skip_whitespace(const char *s)
{
  while (bb_isspace(*s))
    s++;
  return (char *)s;
}
static char *skip_non_whitespace(const char *s)
{
  while (*s && !bb_isspace(*s))
    s++;
  return (char *)s;
}
static char *safe_strncpy(char *d, const char *s, int n)
{
  if (n) {
    bb_strncpy(d, s, n - 1);
    d[n - 1] = 0;
  }
  return d;
}
static char *stpcpy(char *d, const char *s)
{
  while ((*d = *s))
    d++, s++;
  return d;
}
static int optind;
#define BB_VER "1.38.0-dma"

/* --- misc libbb --- */
static void bb_show_usage(void)
{
  fputstr(2, "usage: vi [file]\n");
  exit(1);
}
static void bb_simple_error_msg_and_die(const char *s)
{
  fputstr(2, s);
  fputstr(2, "\n");
  exit(1);
}
static unsigned bb_strtou(const char *s, char **end, int base)
{
  (void)base;
  unsigned v = 0;
  while (bb_isdigit(*s)) {
    v = v * 10 + (unsigned)(*s - '0');
    s++;
  }
  if (end)
    *end = (char *)s;
  return v;
}
static int index_in_strings(const char *strings, const char *key)
{
  int i = 0;
  while (*strings) {
    if (strcmp(strings, key) == 0)
      return i;
    strings += strlen(strings) + 1;
    i++;
  }
  return -1;
}
static char *getenv(const char *name)
{
  (void)name;
  return 0;
}

/* --- globals idiom --- */
struct globals;
static struct globals *ptr_to_globals;
#define G (*ptr_to_globals)
#define SET_PTR_TO_GLOBALS(x) (ptr_to_globals = (struct globals *)(x))
#define BB_GLOBAL_CONST

/* xv6 struct stat spells it `size` */
#define st_size size

#endif /* DMA_LIBBB_H */
