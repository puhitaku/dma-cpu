package dmacc_test

import (
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/dmacc"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/llir"
	"github.com/puhitaku/dma-cpu/host/prog"
)

// TestXv6Syscalls runs the syscall exercise from Phase 5c on the
// Phase 5d proc-table kernel: two relocated instances of
// testdata/xv6sys.c make write/getpid/uptime/pause/exit syscalls under
// live timer preemption. pause(0) is now a real (zero-tick) sleep and
// exit leaves a ZOMBIE. Asserts the kernel-serialized console, clock
// progress, pid 1's recorded exit state, and pid 2 surviving pid 1.
func TestXv6Syscalls(t *testing.T) {
	t.Parallel()
	pmod, err := llir.Merge(parseLL(t, "testdata/xv6sys.ll"), parseLL(t, "../../target/xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	procDasm, err := dmacc.Compile(pmod, dmacc.Options{})
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
				Variant: v, TextBase: 0x20000000, DataBase: 0x20002000})
			if err != nil {
				t.Fatal(err)
			}
			kernC := buildKernelC(t, v, 0x20004000, 0x20038000)
			procA, err := dmaasm.Assemble(procDasm, dmaasm.Options{
				Variant: v, TextBase: 0x20021000, DataBase: 0x20024000})
			if err != nil {
				t.Fatal(err)
			}
			procB, err := dmaasm.Assemble(procDasm, dmaasm.Options{
				Variant: v, TextBase: 0x20028000, DataBase: 0x2002C000})
			if err != nil {
				t.Fatal(err)
			}

			m := emu.NewMachine(v)
			entryA, err := procA.Image.Load(m, nil)
			if err != nil {
				t.Fatal(err)
			}
			entryB, err := procB.Image.Load(m, nil)
			if err != nil {
				t.Fatal(err)
			}
			for _, r := range []*dmaasm.Result{kern, kernC} {
				if _, err := r.Image.Load(m, nil); err != nil {
					t.Fatal(err)
				}
			}
			// pid 2 must always be schedulable while pid 1 blocks in
			// its uptime spin, and vice versa after pid 1 exits: the
			// bg counter only pauses(0), waking the same tick.
			wireKernel(t, m, v, kern, kernC, []kproc{
				{procA, entryA, 1, 0, true},
				{procB, entryB, 2, 0, true},
			})
			if err := emu.SetupFetchExec(m, emu.FetchExecConfig{
				Fetch: 0, Exec: 1, Fix: 2, Entry: entryA, Scratch: 0x2003FF00,
			}); err != nil {
				t.Fatal(err)
			}

			exited := false
			for i := 0; i < 100; i++ {
				if _, err := m.Run(emu.RunConfig{MaxCycles: 200_000}); err != nil {
					t.Fatal(err)
				}
				if strings.Contains(string(m.ConsoleOut), "pid 1 exiting") {
					exited = true
					break
				}
			}
			if !exited {
				t.Fatalf("pid 1 never exited; console so far: %q, ticks=%d",
					m.ConsoleOut, m.Peek32(mustSym(t, kernC, "g_ticks")))
			}
			if got := strings.ReplaceAll(string(m.ConsoleOut), "\r", ""); got != wantConsole {
				t.Errorf("console:\n got %q\nwant %q", got, wantConsole)
			}
			if dt := m.Peek32(mustSym(t, procA, "g_donetick")); dt == 0 {
				t.Error("pid 1 never observed uptime > 0")
			}
			// Let pid 1's post-syscall exit state settle (ZOMBIE), then
			// check pid 2 keeps running.
			bg1 := m.Peek32(mustSym(t, procB, "g_bgcount"))
			if _, err := m.Run(emu.RunConfig{MaxCycles: 400_000}); err != nil {
				t.Fatal(err)
			}
			bg2 := m.Peek32(mustSym(t, procB, "g_bgcount"))
			if bg2 <= bg1 {
				t.Errorf("pid 2 stalled after pid 1 exit: bgcount %d -> %d", bg1, bg2)
			}
			if st := procField(m, kernC, 0, pfState); st != stZombie {
				t.Errorf("pid 1 slot state %d, want ZOMBIE(%d)", st, stZombie)
			}
			if xs := procField(m, kernC, 0, pfXstate); xs != 0 {
				t.Errorf("pid 1 exit status %d, want 0", xs)
			}
			t.Logf("ticks=%d bgcount=%d donetick=%d",
				m.Peek32(mustSym(t, kernC, "g_ticks")), bg2,
				m.Peek32(mustSym(t, procA, "g_donetick")))
		})
	}
}
