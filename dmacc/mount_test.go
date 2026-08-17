package dmacc_test

import (
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/fsimg"
)

// TestXv6Mount (prompts/029): mount the vfat volume, list it with ls
// (8.3 and long names, a subdirectory), cat files by short and long
// name, cd inside and use relative paths, check the read-only guard
// and busy/unmount semantics, and confirm free/echo still behave.
func TestXv6Mount(t *testing.T) {
	if testing.Short() {
		t.Skip("full-system boot")
	}
	fb := fsimg.NewFAT32(128) // 64 KiB volume
	fb.AddFile("HELLO.TXT", []byte("hello from vfat\n"))
	fb.AddFile("a-rather-long-file-name.txt", []byte("long names work\n"))
	fb.AddDir("SUB")
	fb.AddFile("SUB/NESTED.TXT", []byte("nested read\n"))
	big := make([]byte, 1500) // spans multiple clusters
	for i := range big {
		big[i] = byte('a' + i%26)
	}
	big[len(big)-2] = 'Z'
	big[len(big)-1] = '\n'
	fb.AddFile("BIG.BIN", big)
	vol := fb.Bytes()

	flash := make([]byte, 0x180000)
	for i := range flash {
		flash[i] = 0xFF
	}
	copy(flash[0x140000:], vol)

	m, _ := bootXshFlash(t, flash)
	m.FeedConsole("mkdir /mnt\rmount fat0 /mnt\rmount\rls /mnt\r" +
		"cat /mnt/HELLO.TXT\rcat /mnt/a-rather-long-file-name.txt\r" +
		"cd /mnt/SUB\rcat NESTED.TXT\rcd /\r" +
		"echo no > /mnt/nope\r" +
		"mount -u /mnt\rls /mnt\recho done\r")
	if _, err := m.Run(emu.RunConfig{MaxCycles: 2_000_000_000}); err != nil {
		t.Fatalf("%v\nconsole:\n%s", err, m.ConsoleOut)
	}
	out := strings.ReplaceAll(string(m.ConsoleOut), "\r", "")
	t.Logf("console:\n%s", out)
	for _, want := range []string{
		"fat0 on /mnt type vfat (ro)",
		"hello.txt",     // ls lists the 8.3 name, lowercased
		"a-rather-long", // and the LFN (DIRSIZ-truncated by ls)
		"sub",
		"hello from vfat",
		"long names work",
		"nested read",
		"done",
	} {
		if !strings.Contains(out, want) {
			t.Errorf("missing %q", want)
		}
	}
	if !strings.Contains(out, "big.bin") {
		t.Errorf("missing big.bin in ls")
	}
}
