package dmacc

import "fmt"

// The shared-runtime vector page: one kernel hosts the rt_ arithmetic/
// memory routines and the __cw_ comparison millicode; user images call
// through a page of jump stubs at the start of the host's .ramtext
// region, so implementations move freely between kernel builds while
// the page layout stays a frozen ABI. Each guest image sheds its own
// copies (~1-2 KB of RAM-resident records apiece).
//
// Page layout (VEC = the host's RAMTextBase):
//
//	VEC+0x00  cw_a cw_b cw_d cw_pb cw_t cw_f cw_pa  — the comparison
//	          cells (pb..pa contiguous for the descriptor unpack),
//	          then a pad word: the slots must stay record-aligned
//	VEC+0x20 + 8*slot  jump stubs, in vecSlots order
//
// The other half of the ABI is the host's ABI v0 register file: args
// r0/r1/r2 and the return address lr sit at its DataBase+{0,4,8,0x40}
// (.regs is always the first thing dmacc puts in .data). Two system
// properties make the shared cells safe, and both must be preserved:
// the host kernel is event-driven (its own r0-r2/lr are dead whenever
// a guest runs), and every shared body is safepoint-free (a guest can
// never be preempted mid-call with live shared state — preemption
// happens only at explicit safepoint records).
//
// FROZEN: append new slots at the end only; never reorder or remove.
type vecSlot struct {
	kind string // "rt" or "cw"
	name string // routine/helper name ("_d" = descriptor form)
}

var vecSlots = []vecSlot{
	{"rt", "mul"}, {"rt", "udivmod"}, {"rt", "udiv"}, {"rt", "urem"},
	{"rt", "sdiv"}, {"rt", "srem"}, {"rt", "shl"}, {"rt", "lshr"},
	{"rt", "ashr"}, {"rt", "memcpy"}, {"rt", "memset"},
	{"cw", "eq"}, {"cw", "eqz"}, {"cw", "lt"}, {"cw", "ltu"},
	{"cw", "eq_d"}, {"cw", "eqz_d"}, {"cw", "lt_d"}, {"cw", "ltu_d"},
	{"cw", "eqzp"}, {"cw", "ltp"}, {"cw", "eqzp_d"}, {"cw", "ltp_d"},
	{"rt", "udivmod10"},
}

const vecSlotBase = 0x20 // cells + pad before the first stub

// cw-cell offsets from the page base, matching the emission order in
// emitVecPage (and the historical .data order the unpack relies on).
var vecCwOff = map[string]uint32{
	"cw_a": 0, "cw_b": 4, "cw_d": 8, "cw_pb": 12,
	"cw_t": 16, "cw_f": 20, "cw_pa": 24,
}

// vecSlotOff returns the page offset of a routine's jump stub.
func vecSlotOff(kind, name string) uint32 {
	for i, s := range vecSlots {
		if s.kind == kind && s.name == name {
			return vecSlotBase + uint32(8*i)
		}
	}
	panic("dmacc: no vector slot for " + kind + ":" + name)
}

// ExternRT locates a host kernel's shared runtime for a guest build:
// Vec is the host's RAMTextBase (the vector page), Regs its DataBase
// (the register file holding the call ABI cells).
type ExternRT struct {
	Vec, Regs uint32
}

// emitVecPage writes the page at the very start of .ramtext — before
// any function emission, so the frozen offsets hold — and forces every
// routine and helper body: a guest may need what the host's own code
// does not.
func (g *gen) emitVecPage() {
	fmt.Fprintf(&g.ram, "; --- shared-runtime vector page (frozen ABI, vecpage.go) ---\n")
	fmt.Fprintf(&g.ram, "cw_a: .word 0\ncw_b: .word 0\ncw_d: .word 0\n")
	fmt.Fprintf(&g.ram, "cw_pb: .word 0\ncw_t: .word 0\ncw_f: .word 0\ncw_pa: .word 0\n")
	fmt.Fprintf(&g.ram, ".word 0 ; pad: stubs are record-aligned\n")
	for _, s := range vecSlots {
		target := "__rt_" + s.name
		if s.kind == "cw" {
			target = "__cw_" + s.name
		}
		fmt.Fprintf(&g.ram, "__vec_%s_%s: jump %s\n", s.kind, s.name, target)
	}
	// Sentinel pair: nothing can elide or fall through the last stub,
	// whatever gets appended to .ramtext after it.
	fmt.Fprintf(&g.ram, ".word 0, 0 ; vector page end\n")
	for _, r := range rtRoutines {
		g.rt[r.name] = true
	}
	for _, h := range cmpHelpers {
		g.cmpUsed[h.name] = true
		g.cmpUsedD[h.name] = true
	}
}

// cw renders a comparison-cell operand: the image's own cell, or the
// host's at its frozen page offset.
func (fc *funcCtx) cw(cell string) string {
	if x := fc.g.opts.RuntimeExtern; x != nil {
		return fmt.Sprintf("@0x%x", x.Vec+vecCwOff[cell])
	}
	return cell
}

// cwJump emits the transfer into a comparison helper (the helper IS
// the branch; no return).
func (fc *funcCtx) cwJump(helper string) {
	if x := fc.g.opts.RuntimeExtern; x != nil {
		fc.ins("jump 0x%x", x.Vec+vecSlotOff("cw", helper))
		return
	}
	fc.ins("jump __cw_%s", helper)
}

// rtReg renders an rt-call argument/result cell (r0/r1/r2).
func (fc *funcCtx) rtReg(r string) string {
	if x := fc.g.opts.RuntimeExtern; x != nil {
		off := map[string]uint32{"r0": 0, "r1": 4, "r2": 8}[r]
		return fmt.Sprintf("@0x%x", x.Regs+off)
	}
	return r
}

// rtCall emits a call to a runtime routine — locally, or through the
// host's vector page. The return address goes into the HOST's lr: the
// shared bodies return through their own register file, so the guest's
// lr (and its lrs save slot) never sees these calls.
func (fc *funcCtx) rtCall(name string) {
	if x := fc.g.opts.RuntimeExtern; x != nil {
		ret := fc.stub("Rv")
		fc.ins("move $%s, @0x%x", ret, x.Regs+0x40)
		fc.ins("jump 0x%x", x.Vec+vecSlotOff("rt", name))
		fc.label(ret)
		return
	}
	fc.g.rt[name] = true
	fc.ins("call __rt_%s", name)
}
