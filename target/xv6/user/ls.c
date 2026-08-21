#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char *
fmtname(char *path)
{
  static char buf[DIRSIZ + 1];
  char *p;

  // Find first character after last slash.
  for (p = path + strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name. dma: pad to a 15-column display width
  // instead of DIRSIZ — with DIRSIZ at 62 for vfat long names, DIRSIZ
  // padding would bury every listing in spaces; longer names simply
  // run past the column.
  if (strlen(p) >= 15)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf + strlen(p), ' ', 15 - strlen(p));
  buf[15] = '\0';
  return buf;
}

void
ls(char *path)
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if ((fd = open(path, O_RDONLY)) < 0) {
    fputstr(2, "ls: cannot open "); /* dma: no printf */
    fputstr(2, path);
    fputstr(2, "\n");
    return;
  }

  if (fstat(fd, &st) < 0) {
    fputstr(2, "ls: cannot stat ");
    fputstr(2, path);
    fputstr(2, "\n");
    close(fd);
    return;
  }

  switch (st.type) {
  case T_DEVICE:
  case T_FILE:
    fputstr(1, fmtname(path)); /* dma: no printf, same bytes */
    fputstr(1, " ");
    fputnum(1, st.type);
    fputstr(1, " ");
    fputnum(1, (int)st.ino);
    fputstr(1, " ");
    fputnum(1, (int)st.size);
    fputstr(1, "\n");
    break;

  case T_DIR:
    if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf) {
      fputstr(1, "ls: path too long\n");
      break;
    }
    strcpy(buf, path);
    p = buf + strlen(buf);
    *p++ = '/';
    while (read(fd, &de, sizeof(de)) == sizeof(de)) {
      if (de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      if (stat(buf, &st) < 0) {
        fputstr(1, "ls: cannot stat ");
        fputstr(1, buf);
        fputstr(1, "\n");
        continue;
      }
      fputstr(1, fmtname(buf));
      fputstr(1, " ");
      fputnum(1, st.type);
      fputstr(1, " ");
      fputnum(1, (int)st.ino);
      fputstr(1, " ");
      fputnum(1, (int)st.size);
      fputstr(1, "\n");
    }
    break;
  }
  close(fd);
}

int
main(int argc, char *argv[])
{
  int i;

  if (argc < 2) {
    ls(".");
    exit(0);
  }
  for (i = 1; i < argc; i++)
    ls(argv[i]);
  exit(0);
}
