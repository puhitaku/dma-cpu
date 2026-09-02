package dmacc_test

import (
	"encoding/binary"
	"testing"

	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/emu"
)

// struct proc field word offsets (xv6/dma/kproc.c — all-uint layout).
const (
	pfState = iota
	pfPid
	pfPpid
	pfChan
	pfWakeUS
	pfXstate
	pfPdispatch
	pfPirqresume
	pfPlr
	pfThunk
	pfResume
	pfPmail
	pfKilled
	pfHeapbase
	pfHeapmax
	pfBrk
	pfSigctx
	pfSigpend
	procWords // 18
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
	syscall bool   // image links usys (has a mailbox + syscall vector)
	name    string // proc-table name (`ps`); exec renames the slot
}

// wireKernel pokes the Phase 5d kernel wiring: the kernel.dasm words,
// the kproc.c proc table, each process's syscall vector, and the
// single one-shot tick injector aimed at slot 0's dispatch (classic:
// ABI ch3; compact: emu.CompactInjector, see wireKernelEnc). Slot 0
// must be always-runnable (it starts as the machine's entry).
func wireKernel(t *testing.T, m *emu.Machine, v *emu.Variant,
	kern, kernC *dmaasm.Result, procs []kproc) {
	wireKernelEnc(t, m, v, kern, kernC, procs, false)
}

func wireKernelEnc(t *testing.T, m *emu.Machine, v *emu.Variant,
	kern, kernC *dmaasm.Result, procs []kproc, compact bool) {
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
	m.Poke32(kc("g_kw_park"), ks("parkloop"))
	m.Poke32(kc("g_kw_parkvec"), ks("parkvec"))

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
		// The slot's name, as the loader leaves it for `ps` (dmxgen
		// wireKernel does the same); exec renames it from there.
		var nb [12]byte
		copy(nb[:], p.name)
		for w := 0; w < 3; w++ {
			m.Poke32(kc("g_procname")+uint32(i*12+w*4),
				binary.LittleEndian.Uint32(nb[w*4:]))
		}
		pf(i, pfPdispatch, sym(p.res, "dispatch"))
		pf(i, pfPirqresume, sym(p.res, "irqresume"))
		pf(i, pfPlr, sym(p.res, "lr"))
		pf(i, pfThunk, sym(p.res, "crtthunk"))
		// First schedule enters at warmstart with dispatch preset here
		// (as exec does): a cold-entry resume would let crt0's dispatch
		// write clobber a tick that fired during the switch to this
		// proc, killing the timer (prompts/024).
		pf(i, pfResume, sym(p.res, "warmstart"))
		m.Poke32(sym(p.res, "dispatch"), sym(p.res, "crtthunk"))
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
	inj := 3
	if compact {
		inj = emu.CompactInjector
		m.Poke32(kc("g_inj_wreg"), emu.ChanRegAddr(inj, emu.OffWriteAddr))
		m.Poke32(kc("g_inj_treg"), emu.ChanRegAddr(inj, emu.OffAl1TransCountTrig))
	}
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
