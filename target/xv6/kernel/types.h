typedef unsigned int uint;
typedef unsigned short ushort;
typedef unsigned char uchar;

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef unsigned long uint64;

typedef uint64 pde_t;

// The one errno this port defines (Linux's number). Every board
// installs every user command; a syscall against hardware the board
// lacks returns -ENODEV and the COMMAND reports the miss — absence
// is handled by the kernel, never by dropping binaries from a board's
// app set (PORT.md, "Device absence").
#define ENODEV 19
