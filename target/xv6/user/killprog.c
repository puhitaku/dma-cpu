/* kill: the user/kill.c behavior (kill each argv pid) without the
 * fprintf dependency — printf costs ~20 KB per binary, which the
 * image budget cannot afford across every utility (cf. syncprog.c). */
#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
  if (argc < 2) {
    write(2, "usage: kill pid...\n", 19);
    exit(1);
  }
  for (int i = 1; i < argc; i++)
    kill(atoi(argv[i]));
  exit(0);
}
