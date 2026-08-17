package dmacc_test

import (
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/dmaasm"
	"github.com/puhitaku/dma-cpu/dmacc"
	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/llir"
	"github.com/puhitaku/dma-cpu/prog"
)

// TestXv6Sh boots UPSTREAM user/sh.c as the shell (slot 0) — the
// parser and runcmd recursion runs on depth-cloned frames, the vfork
// discipline holds through the frameless syscall wrappers, and exec
// resolves names in the kernel's image registry. rp2350 only: the
// clone family needs the wide RAM.
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
	shDasm, err := dmacc.Compile(shMod, dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	echoMod, err := llir.Merge(parseLL(t, "../xv6/ll/echo.ll"),
		parseLL(t, "../xv6/ll/ulib.ll"), parseLL(t, "../xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	echoDasm, err := dmacc.Compile(echoMod, dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	idleDasm, err := dmacc.Compile(parseLL(t, "testdata/proc.ll"), dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	ksrc, err := prog.HIL("kernel")
	if err != nil {
		t.Fatal(err)
	}

	kern, err := dmaasm.Assemble(ksrc, dmaasm.Options{
		Variant: v, TextBase: 0x20008000, DataBase: 0x2000A000})
	if err != nil {
		t.Fatal(err)
	}
	kernC := buildKernelC(t, v, 0x2000C000, 0x20015000)
	sh, err := dmaasm.Assemble(shDasm, dmaasm.Options{
		Variant: v, TextBase: 0x20018000, DataBase: 0x20048000})
	if err != nil {
		t.Fatal(err)
	}
	idle, err := dmaasm.Assemble(idleDasm, dmaasm.Options{
		Variant: v, TextBase: 0x20058000, DataBase: 0x20059000})
	if err != nil {
		t.Fatal(err)
	}
	echoImg, err := dmaasm.Assemble(echoDasm, dmaasm.Options{
		Variant: v, TextBase: 0x10000000, DataBase: 0x10020000})
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
	wireKernel(t, m, v, kern, kernC, []kproc{
		{sh, entrySh, 1, 0, true},
		{idle, entryI, 2, 0, false},
	})
	end := registerImage(t, m, kernC, 0, "echo", echoImg, 0x2005A000)
	if end > 0x2005E000 {
		t.Fatalf("blob overflow: %#x", end)
	}
	m.Poke32(mustSym(t, kernC, "g_arena"), 0x2005E000)
	m.Poke32(mustSym(t, kernC, "g_arena_end"), 0x2007F000)
	m.Poke32(mustSym(t, kernC, "g_nextpid"), 3)
	m.Poke32(mustSym(t, kernC, "g_k_sysentry"), mustSym(t, kern, "sys_entry"))
	if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
		Fetch: 0, Exec: 1, Fix: 2, Entry: entrySh, Scratch: 0x2007FE00,
	}); err != nil {
		t.Fatal(err)
	}
	return m, kernC
}

func TestXv6Sh(t *testing.T) {
	m, _ := bootXsh(t)
	m.FeedConsole("echo hi from xv6 sh\recho a; echo b\rzzz\rcd nowhere\r")
	if _, err := m.Run(emu.RunConfig{MaxCycles: 400_000_000}); err != nil {
		t.Fatal(err)
	}
	out := strings.ReplaceAll(string(m.ConsoleOut), "\r", "")
	t.Logf("console:\n%s", out)
	for _, want := range []string{
		"$ ",                    // upstream getcmd prompt
		"hi from xv6 sh",        // exec'd registry echo with argv
		"a\n", "b\n",            // the `;` list: nested vfork
		"exec zzz failed",       // runcmd's error path (vfork child printf)
		"cannot cd nowhere",     // the cd builtin hitting chdir = -1
	} {
		if !strings.Contains(out, want) {
			t.Errorf("console missing %q", want)
		}
	}
}
