package dmacc_test

import (
	"os"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/dmaasm"
	"github.com/puhitaku/dma-cpu/dmacc"
	"github.com/puhitaku/dma-cpu/emu"
	"github.com/puhitaku/dma-cpu/llir"
	"github.com/puhitaku/dma-cpu/prog"
)

// TestXv6Syscalls runs the Phase 5c syscall mechanism end to end: two
// relocated instances of testdata/xv6sys.c (linked with the
// xv6/dma/usys.c stubs) make write/getpid/uptime/pause/exit syscalls
// against the C kernel core (xv6/dma/ksyscall.c, compiled without
// safepoints) via kernel.dasm's self-patched-dispatch vectors, all
// under live timer preemption. Asserts the kernel-serialized console,
// clock progress, pid 1's exit status, and pid 2 surviving pid 1.
func TestXv6Syscalls(t *testing.T) {
	parse := func(path string) *llir.Module {
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
	procMod, err := llir.Merge(parse("testdata/xv6sys.ll"), parse("../xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	procDasm, err := dmacc.Compile(procMod, dmacc.Options{})
	if err != nil {
		t.Fatal(err)
	}
	kcDasm, err := dmacc.Compile(parse("../xv6/ll/ksyscall.ll"),
		dmacc.Options{Entry: "dma_ksyscall", NoSafepoints: true})
	if err != nil {
		t.Fatal(err)
	}
	ksrc, err := prog.HIL("kernel")
	if err != nil {
		t.Fatal(err)
	}

	const wantConsole = "hello from pid 1 via SYS_write\n" +
		"pid 1 saw the clock advance\n" +
		"pid 1 exiting\n"

	for _, v := range emu.Variants {
		t.Run(v.Name, func(t *testing.T) {
			kern, err := dmaasm.Assemble(ksrc, dmaasm.Options{
				Variant: v, TextBase: 0x20000000, DataBase: 0x20004000})
			if err != nil {
				t.Fatal(err)
			}
			kernC, err := dmaasm.Assemble(kcDasm, dmaasm.Options{
				Variant: v, TextBase: 0x20008000, DataBase: 0x2000C000})
			if err != nil {
				t.Fatal(err)
			}
			procA, err := dmaasm.Assemble(procDasm, dmaasm.Options{
				Variant: v, TextBase: 0x20010000, DataBase: 0x20014000})
			if err != nil {
				t.Fatal(err)
			}
			procB, err := dmaasm.Assemble(procDasm, dmaasm.Options{
				Variant: v, TextBase: 0x20018000, DataBase: 0x2001C000})
			if err != nil {
				t.Fatal(err)
			}

			m := emu.NewMachine(v)
			for _, res := range []*dmaasm.Result{kern, kernC} {
				if _, err := res.Image.Load(m, nil); err != nil {
					t.Fatal(err)
				}
			}
			entryA, err := procA.Image.Load(m, nil)
			if err != nil {
				t.Fatal(err)
			}
			entryB, err := procB.Image.Load(m, nil)
			if err != nil {
				t.Fatal(err)
			}

			sym := func(res *dmaasm.Result, name string) uint32 {
				a, err := res.Symbol(name)
				if err != nil {
					t.Fatal(err)
				}
				return a
			}
			ks := func(name string) uint32 { return sym(kern, name) }

			// Scheduler wiring (as in TestPreemptiveScheduler).
			m.Poke32(ks("pAdisp"), sym(procA, "dispatch"))
			m.Poke32(ks("pBdisp"), sym(procB, "dispatch"))
			m.Poke32(ks("pAresume"), sym(procA, "irqresume"))
			m.Poke32(ks("pBresume"), sym(procB, "irqresume"))
			m.Poke32(ks("thunkA"), sym(procA, "crtthunk"))
			m.Poke32(ks("thunkB"), sym(procB, "crtthunk"))
			m.Poke32(ks("savedB"), entryB)

			// Syscall wiring: dasm stub -> C kernel core, and the
			// callers' lr words (syscall return/resume addresses).
			m.Poke32(ks("kentry"), sym(kernC, "f_dma_ksyscall"))
			m.Poke32(ks("pKr0"), sym(kernC, "r0"))
			m.Poke32(ks("pKlr"), sym(kernC, "lr"))
			m.Poke32(ks("pAlr"), sym(procA, "lr"))
			m.Poke32(ks("pBlr"), sym(procB, "lr"))
			// C kernel core -> mailboxes and kernel words.
			m.Poke32(sym(kernC, "g_dma_mail"), sym(procA, "g___dma_sysmail"))
			m.Poke32(sym(kernC, "g_dma_mail")+4, sym(procB, "g___dma_sysmail"))
			m.Poke32(sym(kernC, "g_dma_wsw"), ks("wsw"))
			m.Poke32(sym(kernC, "g_dma_ticks"), ks("ticks"))
			// Processes -> their per-instance kernel vector.
			m.Poke32(sym(procA, "g___dma_syscall_entry"), ks("sys_from_a"))
			m.Poke32(sym(procB, "g___dma_syscall_entry"), ks("sys_from_b"))

			// Injector chain (identical to the scheduler test).
			const inj1, inj2 = 3, 4
			m.Poke32(v.TimerAddr(1), 1<<16|15000)
			m.Poke32(emu.ChanRegAddr(inj2, emu.OffAl1ReadAddr), ks("vecB"))
			m.Poke32(emu.ChanRegAddr(inj2, emu.OffAl1WriteAddr), sym(procB, "dispatch"))
			m.Poke32(emu.ChanRegAddr(inj2, emu.OffAl2TransCount), 1)
			m.Poke32(emu.ChanRegAddr(inj2, emu.OffAl1Ctrl),
				emu.CtrlEN|emu.CtrlHighPriority|emu.CtrlSize32|
					v.CtrlTreq(emu.TreqPermanent)|v.CtrlChainTo(inj2)|v.CtrlIRQQuiet)
			m.Poke32(emu.ChanRegAddr(inj1, emu.OffAl1ReadAddr), ks("vecA"))
			m.Poke32(emu.ChanRegAddr(inj1, emu.OffAl1WriteAddr), sym(procA, "dispatch"))
			m.Poke32(emu.ChanRegAddr(inj1, emu.OffTransCount), 1)
			m.Poke32(emu.ChanRegAddr(inj1, emu.OffCtrlTrig),
				emu.CtrlEN|emu.CtrlHighPriority|emu.CtrlSize32|
					v.CtrlTreq(emu.TreqTimer1)|v.CtrlChainTo(inj2)|v.CtrlIRQQuiet)

			if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
				Fetch: 0, Exec: 1, Fix: 2, Entry: entryA, Scratch: 0x2003FF00,
			}); err != nil {
				t.Fatal(err)
			}

			// Run until pid 1 has exited (its final write is on the console).
			exited := false
			for i := 0; i < 100; i++ {
				if _, err := m.Run(emu.RunConfig{MaxCycles: 200_000}); err != nil {
					t.Fatal(err)
				}
				if strings.Contains(string(m.ConsoleOut), "pid 1 exiting\n") {
					exited = true
					break
				}
			}
			if !exited {
				t.Fatalf("pid 1 never exited; console so far: %q, ticks=%d",
					m.ConsoleOut, m.Peek32(ks("ticks")))
			}
			if got := string(m.ConsoleOut); got != wantConsole {
				t.Errorf("console:\n got %q\nwant %q", got, wantConsole)
			}
			if dt := m.Peek32(sym(procA, "g_donetick")); dt == 0 {
				t.Error("pid 1 never observed uptime > 0")
			}
			if st := m.Peek32(sym(kernC, "g_dma_exit_status")); st != 0 {
				t.Errorf("exit status of pid 1: got %d, want 0", st)
			}
			// pid 2 must keep running after pid 1's exit.
			bg1 := m.Peek32(sym(procB, "g_bgcount"))
			if _, err := m.Run(emu.RunConfig{MaxCycles: 400_000}); err != nil {
				t.Fatal(err)
			}
			bg2 := m.Peek32(sym(procB, "g_bgcount"))
			if bg2 <= bg1 {
				t.Errorf("pid 2 stalled after pid 1 exit: bgcount %d -> %d", bg1, bg2)
			}
			t.Logf("ticks=%d bgcount=%d donetick=%d",
				m.Peek32(ks("ticks")), bg2, m.Peek32(sym(procA, "g_donetick")))
		})
	}
}
