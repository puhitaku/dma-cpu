package dmacc_test

import (
	"encoding/binary"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/dmaasm"
	"github.com/puhitaku/dma-cpu/dmacc"
	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/fsimg"
	"github.com/puhitaku/dma-cpu/llir"
	"github.com/puhitaku/dma-cpu/prog"
)

// buildUser compiles an xv6 user program (name.ll + the userland
// modules) and assembles it reloc-intact at canonical link bases.
func buildUser(t *testing.T, v *emu.Variant, name string, extra ...string) *dmaasm.Result {
	t.Helper()
	paths := append([]string{name, "ulib", "usys"}, extra...)
	var mods []*llir.Module
	for _, p := range paths {
		mods = append(mods, parseLL(t, "../xv6/ll/"+p+".ll"))
	}
	mod, err := llir.Merge(mods...)
	if err != nil {
		t.Fatal(err)
	}
	dasm, err := dmacc.Compile(mod, dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	res, err := dmaasm.Assemble(dasm, dmaasm.Options{
		Variant: v, Compact: true, CompactScratch: 0x2007FE00,
		TextBase: 0x10000000, DataBase: 0x10040000})
	if err != nil {
		t.Fatal(err)
	}
	return res
}

// buildDisk assembles the user programs as DMX-exec files and packs
// them (plus README) into an xv6 filesystem image.
func buildDisk(t *testing.T, v *emu.Variant) []byte {
	t.Helper()
	b := fsimg.New(128, 64)
	b.AddDevice("console", 1, 0)
	b.AddFile("README", []byte("the DMA machine runs upstream xv6.\n"))
	for _, prog := range []struct {
		name  string
		extra []string
	}{
		{"echo", nil},
		{"cat", []string{"printf"}},
		{"wc", []string{"printf"}},
		{"ls", []string{"printf"}},
	} {
		res := buildUser(t, v, prog.name, prog.extra...)
		blob, err := fsimg.DMXExec(res.Image, res.Symbol)
		if err != nil {
			t.Fatal(err)
		}
		b.AddFile(prog.name, blob)
	}
	return b.Bytes()
}

// bootXsh boots UPSTREAM sh.c (slot 0) on the full fs kernel with the
// RAM disk mounted — exec resolves paths in the filesystem now.
func bootXsh(t *testing.T) (*emu.Machine, *dmaasm.Result) {
	t.Helper()
	v, err := emu.VariantByName("rp2350")
	if err != nil {
		t.Fatal(err)
	}
	shMod, err := llir.Merge(
		parseLL(t, "../xv6/ll/sh.ll"), parseLL(t, "../xv6/ll/ulib.ll"),
		parseLL(t, "../xv6/ll/printf.ll"), parseLL(t, "../xv6/ll/umalloc.ll"),
		parseLL(t, "../xv6/ll/sbrk.ll"), parseLL(t, "../xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	shDasm, err := dmacc.Compile(shMod, dmacc.Options{RecursionDepth: 8})
	if err != nil {
		t.Fatal(err)
	}
	kcDasm := compileKernel(t, true)
	idleDasm, err := dmacc.Compile(parseLL(t, "testdata/proc.ll"), dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	ksrc, err := prog.HIL("kernel")
	if err != nil {
		t.Fatal(err)
	}

	casm := func(src string, text, data uint32) (*dmaasm.Result, error) {
		return dmaasm.Assemble(src, dmaasm.Options{
			Variant: v, Compact: true, CompactScratch: 0x2007FE00,
			TextBase: text, DataBase: data})
	}
	kern, err := casm(ksrc, 0x20008000, 0x2000A000)
	if err != nil {
		t.Fatal(err)
	}
	kernC, err := casm(kcDasm, 0x2000C000, 0x20022000)
	if err != nil {
		t.Fatal(err)
	}
	sh, err := casm(shDasm, 0x2002A000, 0x20040000)
	if err != nil {
		t.Fatal(err)
	}
	idle, err := casm(idleDasm, 0x2004E000, 0x2004F000)
	if err != nil {
		t.Fatal(err)
	}

	m := emu.NewMachine(v)
	m.TXPace = 13000
	entrySh, err := sh.Image.Load(m, nil)
	if err != nil {
		t.Fatal(err)
	}
	entryI, err := idle.Image.Load(m, nil)
	if err != nil {
		t.Fatal(err)
	}
	for _, r := range []*dmaasm.Result{kern, kernC} {
		if _, err := r.Image.Load(m, nil); err != nil {
			t.Fatal(err)
		}
	}
	wireKernelEnc(t, m, v, kern, kernC, []kproc{
		{sh, entrySh, 1, 0, true},
		{idle, entryI, 2, 0, false},
	}, true)
	// The RAM disk.
	disk := buildDisk(t, v)
	const diskBase = 0x20050000
	if diskBase+len(disk) > 0x20070000 {
		t.Fatalf("disk too large: %d", len(disk))
	}
	for i := 0; i < len(disk); i += 4 {
		m.Poke32(uint32(diskBase+i), binary.LittleEndian.Uint32(disk[i:]))
	}
	m.Poke32(mustSym(t, kernC, "g_dma_disk"), diskBase)
	m.Poke32(mustSym(t, kernC, "g_dma_disksize"), uint32(len(disk)))
	// exec arena.
	m.Poke32(mustSym(t, kernC, "g_arena"), 0x20070000)
	m.Poke32(mustSym(t, kernC, "g_arena_end"), 0x2007F000)
	m.Poke32(mustSym(t, kernC, "g_nextpid"), 3)
	m.Poke32(mustSym(t, kernC, "g_k_sysentry"), mustSym(t, kern, "sys_entry"))
	if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
		Compact: true, Entry: entrySh, Scratch: 0x2007FE00,
	}); err != nil {
		t.Fatal(err)
	}
	return m, kernC
}

// TestXv6Sh: upstream sh on the full fs — ls, cat, output redirection
// (O_CREATE through sysfile's create), and a pipe into wc.
func TestXv6Sh(t *testing.T) {
	m, _ := bootXsh(t)
	m.FeedConsole("ls\rcat README\recho booom > note\rcat note\recho one; echo two\rcat README | wc\r")
	if _, err := m.Run(emu.RunConfig{MaxCycles: 900_000_000}); err != nil {
		t.Fatal(err)
	}
	out := strings.ReplaceAll(string(m.ConsoleOut), "\r", "")
	t.Logf("console:\n%s", out)
	for _, want := range []string{
		"$ ",
		"README",                             // ls lists it
		"the DMA machine runs upstream xv6.", // cat README
		"booom",               // cat note (redirected write)
		"one\n", "two\n",      // the ; list still works
		"1 6 35",              // wc on README: 1 line, 6 words, 35 bytes
	} {
		if !strings.Contains(out, want) {
			t.Errorf("console missing %q", want)
		}
	}
}
