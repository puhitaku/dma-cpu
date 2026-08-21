/* dma-sh: an interactive shell running on the DMA machine (Phase 5b).
 *
 * Runs as process A under prog/hil/kernel.dasm while a counter process
 * runs as B; every input-wait loop iteration crosses a safepoint, so the
 * background process keeps running while the shell sits at the prompt —
 * `stat` makes the multitasking visible.
 *
 * Input is UART0 RX read directly by the machine (FR.RXFE poll + DR
 * pop); output is the usual picolibc printf. The two stat_* pointers
 * are patched by the loader with the kernel's tick counter and the
 * background process's counter.
 */
#include <stdio.h>
#include <string.h>
#include <dma/mmio.h>

volatile unsigned int *volatile stat_ticks;   /* loader-patched: &kernel.ticks */
volatile unsigned int *volatile stat_counter; /* loader-patched: &procB.counter */

/* Phase 5f: `run` spawns registered images via the kernel's own
 * loader (xv6/dma/usys.c syscalls; linked in as a separate module). */
int fork(void);
int exec(const char *path, char **argv);
int wait(int *status);
void exit(int status);

static int sh_getchar(void) {
  while (__dma_uart_fr & DMA_UART_FR_RXFE)
    ;
  return (int)(__dma_uart_dr & 0xFFu);
}

static void sh_getline(char *buf, int cap) {
  int n = 0;
  for (;;) {
    int c = sh_getchar();
    if (c == '\r' || c == '\n') {
      putchar('\n');
      buf[n] = 0;
      return;
    }
    if (c == 0x7F || c == 0x08) { /* backspace */
      if (n > 0) {
        n--;
        printf("\b \b");
      }
      continue;
    }
    if (n < cap - 1 && c >= 32 && c < 127) {
      buf[n++] = (char)c;
      putchar(c);
    }
  }
}

static const char *skip_spaces(const char *s) {
  while (*s == ' ')
    s++;
  return s;
}

/* Parse hex (with or without 0x) or decimal. */
static unsigned parse_num(const char *s, const char **end, int *ok) {
  unsigned v = 0;
  int hex = 0, any = 0;
  s = skip_spaces(s);
  if (s[0] == '0' && (s[1] == 'x' || s[1] == 'X')) {
    hex = 1;
    s += 2;
  }
  for (;; s++) {
    unsigned d;
    if (*s >= '0' && *s <= '9')
      d = (unsigned)(*s - '0');
    else if (hex && *s >= 'a' && *s <= 'f')
      d = (unsigned)(*s - 'a' + 10);
    else if (hex && *s >= 'A' && *s <= 'F')
      d = (unsigned)(*s - 'A' + 10);
    else
      break;
    v = hex ? v * 16 + d : v * 10 + d;
    any = 1;
  }
  if (end)
    *end = s;
  *ok = any;
  return v;
}

static void cmd_help(void) {
  printf("commands:\n"
         "  help              this text\n"
         "  echo <text>       print text\n"
         "  stat              scheduler ticks + background process counter\n"
         "  peek <addr>       read a 32-bit word (SRAM or MMIO)\n"
         "  poke <addr> <val> write a 32-bit word\n"
         "  primes <n>        sieve primes up to n (max 500)\n"
         "  run <img> [args]  fork+exec a registered image, wait for it\n");
}

/* fork + exec + wait. The vfork child only calls exec/exit (both have
 * private frames in usys.c), keeping the shared frames intact for the
 * suspended parent. On exec failure it must NOT printf (that would
 * re-enter shared libc/syscall frames): the parent reports instead. */
static void cmd_run(char *args) {
  char *argv[8];
  int argc = 0;
  char *p = args;
  while (argc < 7) {
    while (*p == ' ')
      *p++ = 0;
    if (!*p)
      break;
    argv[argc++] = p;
    while (*p && *p != ' ')
      p++;
  }
  argv[argc] = 0;
  if (argc == 0) {
    printf("usage: run <img> [args]\n");
    return;
  }
  int pid = fork();
  if (pid == 0) {
    exec(argv[0], argv);
    exit(127); /* exec failed */
  }
  int st = -1;
  int rp = wait(&st);
  if (st == 127)
    printf("run: exec %s failed\n", argv[0]);
  else
    printf("[pid %d exited, status %d]\n", rp, st);
}

static void cmd_stat(void) {
  printf("ticks=%u bgcounter=%u\n", *stat_ticks, *stat_counter);
}

static void cmd_peek(const char *args) {
  int ok;
  unsigned addr = parse_num(args, 0, &ok);
  if (!ok) {
    printf("usage: peek <addr>\n");
    return;
  }
  printf("[%08x] = %08x\n", addr, *(volatile unsigned *)addr);
}

static void cmd_poke(const char *args) {
  int ok1, ok2;
  const char *rest;
  unsigned addr = parse_num(args, &rest, &ok1);
  unsigned val = parse_num(rest, 0, &ok2);
  if (!ok1 || !ok2) {
    printf("usage: poke <addr> <val>\n");
    return;
  }
  *(volatile unsigned *)addr = val;
  printf("[%08x] <- %08x\n", addr, val);
}

static unsigned char composite[501];

static void cmd_primes(const char *args) {
  int ok;
  unsigned n = parse_num(args, 0, &ok);
  if (!ok || n < 2)
    n = 100;
  if (n > 500)
    n = 500;
  memset(composite, 0, sizeof composite);
  for (unsigned p = 2; p * p <= n; p++)
    if (!composite[p])
      for (unsigned m = p * p; m <= n; m += p)
        composite[m] = 1;
  int col = 0;
  for (unsigned i = 2; i <= n; i++)
    if (!composite[i]) {
      printf("%4u%c", i, (++col % 10 == 0) ? '\n' : ' ');
    }
  if (col % 10 != 0)
    putchar('\n');
  printf("(%d primes <= %u)\n", col, n);
}

int main(void) {
  char line[80];
  printf("\ndma-sh: a shell running on the RP2 DMA controller.\n"
         "Type 'help' for commands.\n");
  for (;;) {
    printf("dma> ");
    sh_getline(line, sizeof line);
    const char *s = skip_spaces(line);
    if (!*s)
      continue;
    if (!strcmp(s, "help"))
      cmd_help();
    else if (!strncmp(s, "echo ", 5))
      printf("%s\n", s + 5);
    else if (!strcmp(s, "echo"))
      putchar('\n');
    else if (!strcmp(s, "stat"))
      cmd_stat();
    else if (!strncmp(s, "peek", 4))
      cmd_peek(s + 4);
    else if (!strncmp(s, "poke", 4))
      cmd_poke(s + 4);
    else if (!strncmp(s, "primes", 6))
      cmd_primes(s + 6);
    else if (!strncmp(s, "run ", 4))
      cmd_run((char *)s + 4);
    else
      printf("unknown command: %s\n", s);
  }
}
