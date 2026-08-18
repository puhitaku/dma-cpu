#define SBRK_ERROR ((char *)-1)

struct stat;

// system calls
int fork(void);
int exit(int) __attribute__((noreturn));
int wait(int *);
int pipe(int *);
int write(int, const void *, int);
int read(int, void *, int);
int close(int);
int kill(int);
#define SIGINT 2
int signal(int, void (*)(int));
int meminfo(uint *);
int mount(const char *, const char *);
int umount(const char *);
int ttyraw(int);
int read_nb(int, void *, int);
// GPIO / pin-mux / PIO (kernel API, gpiod-style — prompts/034)
#define GPIO_WRITE 0
#define GPIO_READ 1
#define PIO_LOAD 0
#define PIO_INIT 1
#define PIO_GATE 2
int gpioctl(int op, int pin, int val);
int pinmux(int pin, int func);
int pioctl(int op, uint a, uint b);
struct pio_prog {
  uint pio, origin, count;
  uint instr[32];
};
struct pio_smcfg {
  uint pio, sm, origin;
  uint clkdiv, execctrl, shiftctrl, pinctrl;
};
void fputstr(int, const char *);
void fputnum(int, int);
int exec(const char *, char **);
int open(const char *, int);
int mknod(const char *, short, short);
int unlink(const char *);
int fstat(int fd, struct stat *);
int link(const char *, const char *);
int mkdir(const char *);
int chdir(const char *);
int dup(int);
int getpid(void);
char *sys_sbrk(int, int);
int pause(int);
int uptime(void);
int sync(void);

// ulib.c
int stat(const char *, struct stat *);
char *strcpy(char *, const char *);
void *memmove(void *, const void *, int);
char *strchr(const char *, char c);
int strcmp(const char *, const char *);
char *gets(char *, int max);
char *readline(const char *prompt, char *, int max);
uint strlen(const char *);
void *memset(void *, int, uint);
int atoi(const char *);
int memcmp(const void *, const void *, uint);
void *memcpy(void *, const void *, uint);
char *sbrk(int);
char *sbrklazy(int);

// printf.c
void fprintf(int, const char *, ...) __attribute__((format(printf, 2, 3)));
void printf(const char *, ...) __attribute__((format(printf, 1, 2)));

// umalloc.c
void *malloc(uint);
void free(void *);
