package dmacc_test

import (
	"os"
	"strings"
	"sync"
	"testing"

	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/dmacc"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/llir"
	"github.com/puhitaku/dma-cpu/host/prog"
)

func parseLL(t *testing.T, path string) *llir.Module {
	t.Helper()
	src, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	m, err := llir.Parse(string(src))
	if err != nil {
		t.Fatalf("%s: %v", path, err)
	}
	return m
}

// compileKernel builds the kernel core: lean (kproc + fs stubs) or
// full (verbatim fs.c/file.c + glue — ~134 KB text, wide layouts only).
func compileKernel(t *testing.T, fs bool) string {
	return compileKernelOpts(t, fs, false)
}

// compileKernelSized is the -Os build (descriptor compares), kept
// measured so the speed/size gap of Options.OptSize stays visible.
func compileKernelSized(t *testing.T) string {
	t.Helper()
	return compileKernelFull(t, true, true, true, false)
}

func compileKernelOpts(t *testing.T, fs, xip bool) string {
	return compileKernelFull(t, fs, xip, false, false)
}

// compileKernelXsh is the deployable XIP configuration; fb picks the
// real display driver (PSRAM boards) or the no-op stub.
func compileKernelXsh(t *testing.T, fb bool) string {
	return compileKernelFull(t, true, true, false, fb)
}

// kernelCache memoizes compiled kernels per flag set: the compile is
// deterministic (TestDeterminism pins it), every test wants one of a
// handful of shapes, and under t.Parallel the redundant compiles
// would otherwise race for CPU. Concurrent misses may both compile;
// both store the identical string.
var kernelCache sync.Map

func compileKernelFull(t *testing.T, fs, xip, size, fb bool) string {
	t.Helper()
	key := [4]bool{fs, xip, size, fb}
	if v, ok := kernelCache.Load(key); ok {
		return v.(string)
	}
	// Only PSRAM boards carry the real fb driver (~25 KiB of machine
	// text); everything else takes the no-display stub, kfsstub-style.
	fbmods := []string{"kfbstub"}
	if fb {
		fbmods = []string{"kfb", "kfbcon"}
	}
	list := append([]string{"kproc", "kconsstub", "kgpio", "kdma"}, append(fbmods, "kfsstub")...)
	if fs {
		list = append([]string{"kproc", "kcons", "kgpio", "kdma"}, append(fbmods,
			"kfs", "kfile", "kbio", "kfsglue", "kpipe", "kflash", "kfat", "kdev", "string")...)
	}
	var mods []*llir.Module
	for _, p := range list {
		mods = append(mods, parseLL(t, "../../target/xv6/ll/"+p+".ll"))
	}
	merged, err := llir.Merge(mods...)
	if err != nil {
		t.Fatal(err)
	}
	opts := dmacc.Options{Entry: "kmain", NoSafepoints: true, XIPText: xip, OptSize: size,
		/* every XIP kernel hosts the shared runtime for its guests */
		RuntimeHost: xip}
	if xip && fs {
		// The whole sync path must execute from SRAM: its QMI session
		// tears down the XIP window the kernel text now lives behind.
		opts.RAMTextFuncs = []string{"kflash_sync"}
	}
	dasm, err := dmacc.Compile(merged, opts)
	if err != nil {
		t.Fatal(err)
	}
	kernelCache.Store(key, dasm)
	return dasm
}

// buildKernelC assembles the LEAN kernel (no fs).
func buildKernelC(t *testing.T, v *emu.Variant, text, data uint32) *dmaasm.Result {
	t.Helper()
	dasm := compileKernel(t, false)
	res, err := dmaasm.Assemble(dasm, dmaasm.Options{Variant: v, TextBase: text, DataBase: data})
	if err != nil {
		t.Fatal(err)
	}
	return res
}

// TestXv6Proc runs the Phase 5d process lifecycle end to end: three
// instances of testdata/xv6proc.c under the C kernel — an idle
// counter, a parent blocking in wait(), and a child that sleeps 5
// ticks and exits 42. The exiting child deposits pid+status into the
// sleeping parent's mailbox; the child's slot is reaped to UNUSED and
// the parent ends ZOMBIE (nobody waits for it).
func TestXv6Proc(t *testing.T) {
	t.Parallel()
	pmod, err := llir.Merge(parseLL(t, "testdata/xv6proc.ll"), parseLL(t, "../../target/xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	pdasm, err := dmacc.Compile(pmod, dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	ksrc, err := prog.HIL("kernel")
	if err != nil {
		t.Fatal(err)
	}

	const wantConsole = "parent: waiting\nchild: exiting\nparent: reaped\n"

	for _, v := range emu.Variants {
		t.Run(v.Name, func(t *testing.T) {
			kern, err := dmaasm.Assemble(ksrc, dmaasm.Options{
				Variant: v, TextBase: 0x20000000, DataBase: 0x20002000})
			if err != nil {
				t.Fatal(err)
			}
			kernC := buildKernelC(t, v, 0x20004000, 0x20038000)
			asm := func(text, data uint32) *dmaasm.Result {
				res, err := dmaasm.Assemble(pdasm, dmaasm.Options{
					Variant: v, TextBase: text, DataBase: data})
				if err != nil {
					t.Fatal(err)
				}
				return res
			}
			idle := asm(0x20020000, 0x20024000)
			parent := asm(0x20026000, 0x2002A000)
			child := asm(0x2002C000, 0x20030000)

			m := emu.NewMachine(v)
			var entries [3]uint32
			for i, r := range []*dmaasm.Result{idle, parent, child} {
				e, err := r.Image.Load(m, nil)
				if err != nil {
					t.Fatal(err)
				}
				entries[i] = e
			}
			for _, r := range []*dmaasm.Result{kern, kernC} {
				if _, err := r.Image.Load(m, nil); err != nil {
					t.Fatal(err)
				}
			}
			wireKernel(t, m, v, kern, kernC, []kproc{
				{idle, entries[0], 1, 0, true},
				{parent, entries[1], 2, 1, true},
				{child, entries[2], 3, 2, true},
			})
			if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
				Fetch: 0, Exec: 1, Fix: 2, Entry: entries[0], Scratch: 0x2003FF00,
			}); err != nil {
				t.Fatal(err)
			}

			done := false
			for i := 0; i < 100; i++ {
				if _, err := m.Run(emu.RunConfig{MaxCycles: 200_000}); err != nil {
					t.Fatal(err)
				}
				if strings.Contains(string(m.ConsoleOut), "parent: reaped\r\n") {
					done = true
					break
				}
			}
			if !done {
				t.Fatalf("lifecycle did not complete; console %q, states %d/%d/%d, kticks=%d",
					m.ConsoleOut,
					procField(m, kernC, 0, pfState),
					procField(m, kernC, 1, pfState),
					procField(m, kernC, 2, pfState),
					m.Peek32(mustSym(t, kernC, "g_ticks")))
			}
			if got := strings.ReplaceAll(string(m.ConsoleOut), "\r", ""); got != wantConsole {
				t.Errorf("console:\n got %q\nwant %q", got, wantConsole)
			}
			psym := func(name string) uint32 { return mustSym(t, parent, name) }
			if rp := m.Peek32(psym("g_reap_pid")); rp != 3 {
				t.Errorf("wait() returned pid %d, want 3", rp)
			}
			if rs := int32(m.Peek32(psym("g_reap_status"))); rs != 42 {
				t.Errorf("wait() status %d, want 42", rs)
			}
			// Run on: idle must keep counting; parent ends ZOMBIE
			// (its exit precedes; nobody reaps it), child slot UNUSED.
			id1 := m.Peek32(mustSym(t, idle, "g_idlecount"))
			if _, err := m.Run(emu.RunConfig{MaxCycles: 400_000}); err != nil {
				t.Fatal(err)
			}
			id2 := m.Peek32(mustSym(t, idle, "g_idlecount"))
			if id2 <= id1 {
				t.Errorf("idle stalled after the lifecycle: %d -> %d", id1, id2)
			}
			if st := procField(m, kernC, 1, pfState); st != stZombie {
				t.Errorf("parent slot state %d, want ZOMBIE(%d)", st, stZombie)
			}
			if st := procField(m, kernC, 2, pfState); st != stUnused {
				t.Errorf("child slot state %d, want UNUSED(%d)", st, stUnused)
			}
			if xs := int32(procField(m, kernC, 2, pfXstate)); xs != 0 && xs != 42 {
				t.Errorf("child xstate %d", xs)
			}
			t.Logf("ticks=%d idle=%d parent_done_at=%d",
				m.Peek32(mustSym(t, kernC, "g_ticks")), id2,
				m.Peek32(psym("g_parent_done")))
		})
	}
}

func mustSym(t *testing.T, res *dmaasm.Result, name string) uint32 {
	t.Helper()
	a, err := res.Symbol(name)
	if err != nil {
		t.Fatal(err)
	}
	return a
}
