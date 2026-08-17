package dmacc_test

import (
	"testing"

	"github.com/puhitaku/dma-cpu/dmaasm"
	"github.com/puhitaku/dma-cpu/emu"
)

// struct proc field word offsets (xv6/dma/kproc.c — all-uint layout).
const (
	pfState = iota
	pfPid
	pfPpid
	pfChan
	pfWakeTick
	pfXstate
	pfPdispatch
	pfPirqresume
	pfPlr
	pfThunk
	pfResume
	pfPmail
	procWords // 12
)

// enum procstate (kproc.c / upstream proc.h).
const (
	stUnused   = 0
	stSleeping = 2
	stRunnable = 3
	stRunning  = 4
	stZombie   = 5
)

// kproc describes one process slot for wireKernel.
type kproc struct {
	res     *dmaasm.Result
	entry   uint32
	pid     uint32
	ppid    uint32
	syscall bool // image links usys (has a mailbox + syscall vector)
}

// wireKernel pokes the Phase 5d kernel wiring: the kernel.dasm words,
// the kproc.c proc table, each process's syscall vector, and the
// single one-shot tick injector (ABI ch3) aimed at slot 0's dispatch.
// Slot 0 must be always-runnable (it starts as the machine's entry).
func wireKernel(t *testing.T, m *emu.Machine, v *emu.Variant,
	kern, kernC *dmaasm.Result, procs []kproc) {
	t.Helper()
	sym := func(res *dmaasm.Result, name string) uint32 {
		a, err := res.Symbol(name)
		if err != nil {
			t.Fatal(err)
		}
		return a
	}
	ks := func(name string) uint32 { return sym(kern, name) }
	kc := func(name string) uint32 { return sym(kernC, name) }

	// kernel.dasm -> kernel-C entries.
	m.Poke32(ks("pKlr"), kc("lr"))
	m.Poke32(ks("ktickv"), kc("f_dma_ktick"))
	m.Poke32(ks("ksysv"), kc("f_dma_ksyscall"))
	// kernel-C -> kernel.dasm words.
	m.Poke32(kc("g_kw_pcurdisp"), ks("pCurDisp"))
	m.Poke32(kc("g_kw_curthunk"), ks("curThunk"))
	m.Poke32(kc("g_kw_pcurresume"), ks("pCurResume"))
	m.Poke32(kc("g_kw_curresume"), ks("curResume"))
	m.Poke32(kc("g_kw_nextresume"), ks("nextResume"))
	m.Poke32(kc("g_kw_khalt"), ks("khalt"))

	// The proc table.
	base := kc("g_proc")
	pf := func(slot int, field int, val uint32) {
		m.Poke32(base+uint32(slot*procWords+field)*4, val)
	}
	for i, p := range procs {
		state := uint32(stRunnable)
		if i == 0 {
			state = stRunning
		}
		pf(i, pfState, state)
		pf(i, pfPid, p.pid)
		pf(i, pfPpid, p.ppid)
		pf(i, pfPdispatch, sym(p.res, "dispatch"))
		pf(i, pfPirqresume, sym(p.res, "irqresume"))
		pf(i, pfPlr, sym(p.res, "lr"))
		pf(i, pfThunk, sym(p.res, "crtthunk"))
		pf(i, pfResume, p.entry)
		if p.syscall {
			pf(i, pfPmail, sym(p.res, "g___dma_sysmail"))
			m.Poke32(sym(p.res, "g___dma_syscall_entry"), ks("sys_entry"))
		}
	}

	// cur* seeds for slot 0 (running from machine start).
	m.Poke32(ks("pCurDisp"), sym(procs[0].res, "dispatch"))
	m.Poke32(ks("curThunk"), sym(procs[0].res, "crtthunk"))
	m.Poke32(ks("pCurResume"), sym(procs[0].res, "irqresume"))

	// Single one-shot tick injector: timer-paced, no chain.
	const inj = 3
	m.Poke32(v.TimerAddr(1), 1<<16|15000)
	m.Poke32(emu.ChanRegAddr(inj, emu.OffAl1ReadAddr), ks("vecSched"))
	m.Poke32(emu.ChanRegAddr(inj, emu.OffAl1WriteAddr), sym(procs[0].res, "dispatch"))
	m.Poke32(emu.ChanRegAddr(inj, emu.OffTransCount), 1)
	m.Poke32(emu.ChanRegAddr(inj, emu.OffCtrlTrig),
		emu.CtrlEN|emu.CtrlHighPriority|emu.CtrlSize32|
			v.CtrlTreq(emu.TreqTimer1)|v.CtrlChainTo(inj)|v.CtrlIRQQuiet)
}

// procField reads a proc-table field back from the machine.
func procField(m *emu.Machine, kernC *dmaasm.Result, slot, field int) uint32 {
	base, err := kernC.Symbol("g_proc")
	if err != nil {
		panic(err)
	}
	return m.Peek32(base + uint32(slot*procWords+field)*4)
}
