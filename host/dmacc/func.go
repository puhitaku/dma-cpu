package dmacc

import (
	"fmt"
	"math/bits"
	"sort"
	"strconv"
	"strings"

	"github.com/puhitaku/dma-cpu/host/llir"
)

type addrC struct {
	sym string
	off uint32
}

type funcCtx struct {
	g *gen
	f *llir.Func

	declared  map[string]bool   // value words already declared
	allocas   map[string]string // alloca result -> data symbol
	constAddr map[string]addrC  // GEP result folded to a static address
	uses      map[string]int
	defs      map[string]*llir.Instr
	defBlock  map[string]int
	fused     map[string]bool   // icmp results emitted at their branch
	fwd       map[string]string // pure-copy results forwarded to their source operand
	blockIdx  map[string]int
	directPhi map[string]bool             // blocks whose phis are written directly on edges
	tail      map[*llir.Instr]bool        // calls emitted as tail jumps
	tailRet   map[*llir.Instr]bool        // rets consumed by a preceding tail call
	pair64    map[*llir.Instr]*llir.Instr // i64 store -> its feeding i64 load (8-byte copy idiom)
	pair64Ld  map[*llir.Instr]bool        // the loads consumed by pair64
	poolable  map[string]bool             // block-local temps eligible for slot sharing
	slotOf    map[string]string           // escaping values colored onto shared vs_ words
	poolSym   map[string]string           // current block: value -> assigned pool slot
	poolFree  []string                    // recycled slots (freed at block boundaries)
	poolN     int                         // slots minted for this function
	facts     factSet                     // this function's value bounds (facts.go)

	hasCalls   bool
	cmpN       int  // compare sites emitted so far (site-label ordinal)
	optSize    bool // this function's compare sites take the descriptor form
	inRAM      bool // whole function emitted into .ramtext (RAMTextFuncs)
	rec        bool // uses the recursion frame stack (push/pop)
	frameBytes int  // data bytes emitted for this function's frame
	curBlock   int
	blockOut   *strings.Builder // current block's own text (emit)
	cat        string           // size-report attribution for emitted code
}

func (g *gen) emitFunc(f *llir.Func) error {
	fc := &funcCtx{
		g: g, f: f, rec: g.recSet[f.Name], inRAM: g.ramSet[f.Name],
		optSize:   g.opts.OptSize && !g.opts.HotFuncs[f.Name],
		declared:  map[string]bool{},
		allocas:   map[string]string{},
		constAddr: map[string]addrC{},
		uses:      map[string]int{},
		defs:      map[string]*llir.Instr{},
		defBlock:  map[string]int{},
		fused:     map[string]bool{},
		fwd:       map[string]string{},
		tail:      map[*llir.Instr]bool{},
		tailRet:   map[*llir.Instr]bool{},
		pair64:    map[*llir.Instr]*llir.Instr{},
		pair64Ld:  map[*llir.Instr]bool{},
		blockIdx:  map[string]int{},
		directPhi: map[string]bool{},
		poolable:  map[string]bool{},
		slotOf:    map[string]string{},
		poolSym:   map[string]string{},
		facts:     g.facts[f.Name],
	}
	if g.tailSet[f.Name] {
		// Tail frames form ONE block, so the fork barrier saves them all
		// with a single burst. expandClones appends the tail copies last
		// and together; anything emitted between them would put a
		// stranger's words inside the block.
		if g.ftailN == 0 {
			fmt.Fprintf(&g.data, "g___dmacc_ftail:\n")
		}
		g.ftailN++
	} else if g.ftailN != 0 && g.ftailN < len(g.tailSet) {
		return fmt.Errorf("dmacc: %q splits the recursion tail frame block", f.Name)
	}
	// Framed: recSet needs the region for push/pop, saveSet for the
	// fork barrier's save of its own activation.
	framed := fc.rec || g.saveSet[f.Name]
	if framed {
		// The whole frame must be contiguous for the push/pop and
		// fork-barrier bursts: label it and measure every data byte
		// emitted while this function compiles.
		fmt.Fprintf(&g.data, "fr_%s:\n", sanitize(f.Name))
	}
	if err := fc.prepass(); err != nil {
		return err
	}
	if err := fc.emit(); err != nil {
		return err
	}
	if framed {
		g.frameSz[f.Name] = fc.frameBytes
		if g.tailSet[f.Name] {
			g.ftailBytes += fc.frameBytes
		}
	}
	return nil
}

func (fc *funcCtx) word(local string) string {
	if s, ok := fc.slotOf[local]; ok {
		return s
	}
	if fc.poolable[local] {
		if s, ok := fc.poolSym[local]; ok {
			return s
		}
		var s string
		if n := len(fc.poolFree); n > 0 {
			s = fc.poolFree[n-1]
			fc.poolFree = fc.poolFree[:n-1]
		} else {
			fc.poolN++
			s = fmt.Sprintf("pl_%s_%d", sanitize(fc.f.Name), fc.poolN)
			fc.declWord(s)
		}
		fc.poolSym[local] = s
		return s
	}
	return "v_" + sanitize(fc.f.Name) + "_" + sanitize(local)
}

// poolRelease returns the finished block's slot assignments to the free
// list. Pool slots are only ever shared ACROSS blocks — every value
// keeps a private word for its whole block, so no lowering order can
// alias a live operand.
func (fc *funcCtx) poolRelease() {
	for n, s := range fc.poolSym {
		fc.poolFree = append(fc.poolFree, s)
		delete(fc.poolSym, n)
	}
	sort.Strings(fc.poolFree) // deterministic assignment order
}
func (fc *funcCtx) shadow(local string) string {
	return "s_" + sanitize(fc.f.Name) + "_" + sanitize(local)
}
func (fc *funcCtx) blockLabel(name string) string {
	return "B_" + sanitize(fc.f.Name) + "_" + sanitize(name)
}
func (fc *funcCtx) lrsWord() string { return "lrs_" + sanitize(fc.f.Name) }

func (fc *funcCtx) declWord(sym string) {
	if !fc.declared[sym] {
		fc.declared[sym] = true
		fc.frameBytes += 4
		fmt.Fprintf(&fc.g.data, "%s: .word 0\n", sym)
	}
}

func (fc *funcCtx) ins(format string, args ...any) {
	if s := fc.g.opts.Stats; s != nil {
		mnem := format
		if i := strings.IndexByte(mnem, ' '); i >= 0 {
			mnem = mnem[:i]
		}
		s.record(fc.f.Name, fc.cat, mnem)
	}
	fmt.Fprintf(fc.outBuf(), "    "+format+"\n", args...)
}
func (fc *funcCtx) label(l string) {
	fmt.Fprintf(fc.outBuf(), "%s:\n", l)
}

// outBuf is where this function's records land: the block buffer while
// emit is lowering one (block layout, see emit), then .ramtext for the
// RAMTextFuncs closure or the main text.
func (fc *funcCtx) outBuf() *strings.Builder {
	if fc.blockOut != nil {
		return fc.blockOut
	}
	if fc.inRAM {
		return &fc.g.ram
	}
	return &fc.g.text
}
func (fc *funcCtx) stub(prefix string) string {
	fc.g.stubN++
	return fmt.Sprintf("%s%d_%s", prefix, fc.g.stubN, sanitize(fc.f.Name))
}

// stubBody places a stub's single self-modified record. Normally it sits
// inline and execution falls through it; under XIPText the record must
// live in RAM (flash text is immutable), so it moves to the .ramtext
// region with a jump there and a jump back. The patching move that
// precedes stubBody targets the record by label either way.
func (fc *funcCtx) stubBody(ld, format string, args ...any) {
	if !fc.g.opts.XIPText || fc.inRAM {
		fc.label(ld)
		fc.ins(format, args...)
		return
	}
	ret := fc.stub("Xr")
	fc.ins("jump %s", ld)
	fmt.Fprintf(&fc.g.ram, "%s:\n", ld)
	fmt.Fprintf(&fc.g.ram, "    "+format+"\n", args...)
	fmt.Fprintf(&fc.g.ram, "    jump %s\n", ret)
	fc.label(ret)
}

// width returns the value width in bits, rejecting what the machine
// cannot hold in one word.
func width(t *llir.Type) (int, error) {
	switch t.Kind {
	case llir.TInt:
		if t.Bits > 32 {
			return 0, fmt.Errorf("i%d is not supported (one machine word is 32 bits)", t.Bits)
		}
		return t.Bits, nil
	case llir.TPtr:
		return 32, nil
	case llir.TArray, llir.TStruct:
		// Small aggregates (ABI-coerced values like va_list) live in one
		// word, addressed at their byte size.
		switch s := t.Size(); {
		case s <= 1:
			return 8, nil
		case s <= 2:
			return 16, nil
		case s <= 4:
			return 32, nil
		}
	}
	return 0, fmt.Errorf("value of type %s is not supported", t)
}

// --- Prepass: counts, allocas, word declarations, fusion ---

func (fc *funcCtx) prepass() error {
	f := fc.f
	for i, b := range f.Blocks {
		fc.blockIdx[b.Name] = i
	}
	countVal := func(v *llir.Value) {
		if v != nil && v.Kind == llir.VLocal {
			fc.uses[v.Name]++
		}
	}
	for i, b := range f.Blocks {
		for _, ins := range b.Instrs {
			for _, a := range ins.Args {
				countVal(a)
			}
			for _, e := range ins.Phi {
				countVal(e.Val)
			}
			if ins.Res != "" {
				fc.defs[ins.Res] = ins
				fc.defBlock[ins.Res] = i
			}
		}
	}
	// Frame-slot coloring (downsizing 6/6): a value defined and only
	// used inside one block can share its frame word with same-shaped
	// values in other blocks. Escapes disqualify: a use in another
	// block, a use on a phi edge from another block, or a use by a
	// forwarding op (casts, GEP) whose result aliases our word and may
	// itself travel anywhere. Phi results (written on edges/heads) and
	// the pair64 ferry loads keep dedicated words.
	fwdOps := map[string]bool{"zext": true, "bitcast": true, "ptrtoint": true,
		"inttoptr": true, "freeze": true, "sext": true, "trunc": true,
		"insertvalue": true, "extractvalue": true, "getelementptr": true}
	escape := map[string]bool{}
	useBlks := map[string]map[int]bool{} // value -> blocks where its word is read
	fwdSrcs := map[string][]string{}     // fwd-op result -> sources it may alias
	noteUse := func(v *llir.Value, useBlk int, byFwd bool) {
		if v == nil || v.Kind != llir.VLocal {
			return
		}
		if byFwd || fc.defBlock[v.Name] != useBlk {
			escape[v.Name] = true
		}
		if useBlks[v.Name] == nil {
			useBlks[v.Name] = map[int]bool{}
		}
		useBlks[v.Name][useBlk] = true
	}
	for i, b := range f.Blocks {
		for _, ins := range b.Instrs {
			for _, a := range ins.Args {
				noteUse(a, i, fwdOps[ins.Op])
				if fwdOps[ins.Op] && ins.Res != "" && a.Kind == llir.VLocal {
					fwdSrcs[ins.Res] = append(fwdSrcs[ins.Res], a.Name)
				}
			}
			noteUse(ins.CalleeVal, i, false)
			for _, e := range ins.Phi {
				// The edge copy reads the value at the END of the
				// predecessor block.
				noteUse(e.Val, fc.blockIdx[e.Pred], false)
			}
		}
	}
	// A forwarding op's result may resolve to its source's word (see
	// forward()), so the source is read wherever the result is — charge
	// those use blocks back through the alias chain to a fixpoint.
	for changed := true; changed; {
		changed = false
		for res, srcs := range fwdSrcs {
			for _, s := range srcs {
				for b := range useBlks[res] {
					if !useBlks[s][b] {
						if useBlks[s] == nil {
							useBlks[s] = map[int]bool{}
						}
						useBlks[s][b] = true
						changed = true
					}
				}
			}
		}
	}
	// Pooling wins over the copy-fold peephole where they compete: a
	// pooled slot is multi-referenced, so foldCopies skips it (+8B
	// text per lost fold), but the shared word saves SRAM — and under
	// XIP, text is flash while every data word is SRAM.
	for n, d := range fc.defs {
		if !escape[n] && d.Op != "phi" && d.Op != "alloca" {
			fc.poolable[n] = true
		}
	}
	// 8-byte copy idiom: clang -Oz coalesces small aggregate copies
	// (a two-pointer argv array, a pair of ints) into an i64 load whose
	// only use is an i64 store. Lower the pair to two word moves.
	for _, b := range f.Blocks {
		for _, ins := range b.Instrs {
			if ins.Op != "store" || ins.Typ == nil || ins.Typ.Kind != llir.TInt || ins.Typ.Bits != 64 {
				continue
			}
			v := ins.Args[0]
			if v.Kind != llir.VLocal || fc.uses[v.Name] != 1 {
				continue
			}
			ld := fc.defs[v.Name]
			if ld == nil || ld.Op != "load" || ld.Typ.Kind != llir.TInt || ld.Typ.Bits != 64 {
				continue
			}
			fc.pair64[ins] = ld
			fc.pair64Ld[ld] = true
		}
	}
	// Cross-block slot coloring: an escaping value's live range, at
	// block granularity, is its writer blocks, its (alias-charged) use
	// blocks, and every block on a path between them. Values whose
	// ranges never overlap share one vs_ word. Phi results join with
	// the edge-copy sites as writers (all preds when the block's phis
	// are direct, the head-latch block otherwise) — co-located phis
	// and edge sources always interfere, so parallel copies never
	// alias. Allocas and the pair64 ferry loads keep dedicated
	// storage; block granularity absorbs edge-stub reads and fused
	// compares conservatively.
	fc.computeDirectPhis()
	preds := make([][]int, len(f.Blocks))
	for i, b := range f.Blocks {
		term := b.Instrs[len(b.Instrs)-1]
		for _, l := range term.Labels {
			preds[fc.blockIdx[l]] = append(preds[fc.blockIdx[l]], i)
		}
		for _, c := range term.Cases {
			preds[fc.blockIdx[c.Label]] = append(preds[fc.blockIdx[c.Label]], i)
		}
	}
	writersOf := func(n string) map[int]bool {
		d := fc.defs[n]
		bi := fc.defBlock[n]
		w := map[int]bool{bi: true}
		if d.Op == "phi" && fc.directPhi[f.Blocks[bi].Name] {
			for _, e := range d.Phi {
				w[fc.blockIdx[e.Pred]] = true
			}
		}
		return w
	}
	liveOf := func(n string) map[int]bool {
		// The backward walk stops only at the def block — the one
		// block guaranteed to dominate every use. A phi's edge-copy
		// writers do NOT dominate uses reached through their other
		// successors, so the walk continues through them; they still
		// join the live set (the copy fires at their end, clashing
		// with anything live across them).
		def := fc.defBlock[n]
		live := map[int]bool{}
		var stack []int
		for u := range useBlks[n] {
			if u != def && !live[u] {
				live[u] = true
				stack = append(stack, u)
			}
		}
		for len(stack) > 0 {
			b := stack[len(stack)-1]
			stack = stack[:len(stack)-1]
			for _, p := range preds[b] {
				if p != def && !live[p] {
					live[p] = true
					stack = append(stack, p)
				}
			}
		}
		for w := range writersOf(n) {
			live[w] = true
		}
		return live
	}
	var cands []string
	if !fc.g.forkSet[f.Name] {
		for n, d := range fc.defs {
			if (escape[n] || d.Op == "phi") && d.Op != "alloca" && !fc.pair64Ld[d] {
				cands = append(cands, n)
			}
		}
	}
	sort.Slice(cands, func(i, j int) bool {
		if a, b := fc.defBlock[cands[i]], fc.defBlock[cands[j]]; a != b {
			return a < b
		}
		return cands[i] < cands[j]
	})
	type slot struct {
		sym  string
		live map[int]bool
	}
	var slots []slot
	for _, n := range cands {
		ln := liveOf(n)
		at := -1
		for i := range slots {
			clash := false
			for b := range ln {
				if slots[i].live[b] {
					clash = true
					break
				}
			}
			if !clash {
				at = i
				break
			}
		}
		if at < 0 {
			at = len(slots)
			slots = append(slots, slot{sym: fmt.Sprintf("vs_%s_%d", sanitize(f.Name), at), live: map[int]bool{}})
		}
		for b := range ln {
			slots[at].live[b] = true
		}
		fc.slotOf[n] = slots[at].sym
	}
	// Tail calls: a call immediately followed by a ret of its (sole-use)
	// result — or a discarded/void result — jumps to the callee with the
	// caller's lr intact, so the callee returns directly to our caller.
	// This makes single-call wrappers frameless, which the vfork
	// discipline relies on (xv6/dma/usys.c).
	for _, b := range f.Blocks {
		if fc.rec {
			break // frame-stack functions must pop before returning
		}
		for j := 0; j+1 < len(b.Instrs); j++ {
			ins, ret := b.Instrs[j], b.Instrs[j+1]
			if ins.Op != "call" || ret.Op != "ret" {
				continue
			}
			if isNopIntrinsic(ins.Callee) || strings.HasPrefix(ins.Callee, "llvm.") {
				continue
			}
			if ins.Callee == "fork" && fc.g.saveSet[f.Name] {
				continue // the vfork barrier needs a return to land on
			}
			if ins.CalleeVal == nil {
				if _, ok := fc.g.funcIdx[ins.Callee]; !ok {
					continue // undefined (memcpy/memset lowering)
				}
			} else if len(ins.Args) > 4 || ins.FixedArgs >= 0 && len(ins.Args) > ins.FixedArgs {
				continue // emitIndirectCall would reject; keep its error path
			}
			ok := false
			if len(ret.Args) == 0 {
				ok = ins.Res == "" || fc.uses[ins.Res] == 0
			} else if a := ret.Args[0]; a.Kind == llir.VLocal && ins.Res != "" &&
				a.Name == ins.Res && fc.uses[ins.Res] == 1 {
				ok = true
			}
			if ok {
				fc.tail[ins] = true
				fc.tailRet[ret] = true
			}
		}
	}
	for _, b := range f.Blocks {
		for _, ins := range b.Instrs {
			// Ops that lower to runtime calls count as calls, so the
			// prologue always saves lr before one happens. Tail calls
			// never clobber lr and don't count.
			switch ins.Op {
			case "call":
				if !isNopIntrinsic(ins.Callee) && !fc.tail[ins] {
					fc.hasCalls = true
				}
			case "udiv", "sdiv", "urem", "srem":
				// A power-of-two divisor is byte lanes and masks in
				// place; every other constant, and every variable one,
				// goes to a routine.
				if !divConstInline(ins) {
					fc.hasCalls = true
				}
			case "mul":
				// A constant factor is a double-and-add chain in place.
				if ins.Args[0].Kind != llir.VConst && ins.Args[1].Kind != llir.VConst {
					fc.hasCalls = true
				}
			case "shl", "lshr", "ashr":
				// Constant counts lower to byte lanes; only a shift by a
				// value the compiler cannot see reaches the runtime.
				if ins.Args[1].Kind != llir.VConst {
					fc.hasCalls = true
				}
			}
		}
	}
	// Fuse icmp into a same-block conditional branch when it is the sole use.
	for i, b := range f.Blocks {
		term := b.Instrs[len(b.Instrs)-1]
		if term.Op == "br" && len(term.Args) == 1 && term.Args[0].Kind == llir.VLocal {
			n := term.Args[0].Name
			if d := fc.defs[n]; d != nil && d.Op == "icmp" && fc.uses[n] == 1 && fc.defBlock[n] == i {
				fc.fused[n] = true
			}
		}
	}
	// Frame: params, results, phi shadows, allocas, lr slot.
	for _, p := range f.Params {
		fc.declWord(fc.word(p.Name))
	}
	for _, b := range f.Blocks {
		for _, ins := range b.Instrs {
			if ins.Op == "alloca" {
				size := ins.Typ.Size() * ins.AllocN
				// One word of slack: .data is 4-aligned, and clang may
				// round an 8-aligned alloca's pointer up by 4 (ptrmask).
				size = (size+3)&^3 + 4
				sym := "a_" + sanitize(f.Name) + "_" + sanitize(ins.Res)
				fc.allocas[ins.Res] = sym
				fc.frameBytes += int(size)
				fmt.Fprintf(&fc.g.data, "%s: .space %d\n", sym, size)
				continue
			}
			if ins.Res != "" && !fc.poolable[ins.Res] {
				fc.declWord(fc.word(ins.Res))
			}
			if ins.Op == "phi" && !fc.directPhi[b.Name] {
				fc.declWord(fc.shadow(ins.Res))
			}
		}
	}
	if fc.hasCalls {
		fc.declWord(fc.lrsWord())
	}
	if f.Variadic {
		n := fc.g.maxVar[f.Name]
		if n < 1 {
			n = 1
		}
		fc.frameBytes += 4 * n
		fmt.Fprintf(&fc.g.data, "%s: .space %d\n", fc.vaArea(), 4*n)
	}
	return nil
}

func (fc *funcCtx) vaArea() string { return "va_" + sanitize(fc.f.Name) }

// computeDirectPhis decides, per block, whether its phis are written
// directly on incoming edges (no shadow words, no head latch). Edge
// copies run on the taken edge only — multi-successor predecessors
// route through per-edge stubs — so the only remaining parallel-copy
// hazard is a block whose own phi results feed its own phis (swap/
// rotation): those keep the shadow-and-latch scheme.
func (fc *funcCtx) computeDirectPhis() {
	for _, b := range fc.f.Blocks {
		phis := map[string]bool{}
		for _, ins := range b.Instrs {
			if ins.Op == "phi" {
				phis[ins.Res] = true
			}
		}
		if len(phis) == 0 {
			continue
		}
		direct := true
		for _, ins := range b.Instrs {
			if ins.Op != "phi" {
				continue
			}
			for _, e := range ins.Phi {
				if e.Val.Kind == llir.VLocal && phis[e.Val.Name] {
					direct = false
				}
			}
		}
		fc.directPhi[b.Name] = direct
	}
}

// --- Operand resolution ---

func (fc *funcCtx) globalOperand(v *llir.Value) string {
	sym := globalSym(v.Name)
	if _, isFn := fc.g.funcIdx[v.Name]; isFn {
		sym = funcSym(v.Name)
	}
	if v.Off != 0 {
		return fmt.Sprintf("%s+%d", sym, v.Off)
	}
	return sym
}

// op renders a value as a dmaasm operand (reading it yields the value).
func (fc *funcCtx) op(v *llir.Value) (string, error) {
	switch v.Kind {
	case llir.VConst:
		// Canonicalize to the operand's width: sub-32-bit words keep
		// their high bits zero everywhere (zext is a pure forward on
		// that assumption), but a negative narrow constant would
		// otherwise render sign-extended — an i16 -377 became
		// 0xFFFFFE87 and poisoned every use downstream of a zext
		// (found as a one-bit color error in the gamepico menu).
		c := uint32(v.Int)
		if v.Typ != nil && v.Typ.Kind == llir.TInt && v.Typ.Bits < 32 {
			c &= 1<<uint(v.Typ.Bits) - 1
		}
		return fmt.Sprintf("$0x%x", c), nil
	case llir.VGlobal, llir.VFunc:
		if hwMMIO(v.Name) != "" {
			return "", fmt.Errorf("the address of %s cannot be taken (hardware register)", v.Name)
		}
		return "$" + fc.globalOperand(v), nil
	case llir.VLocal:
		if s, ok := fc.fwd[v.Name]; ok {
			return s, nil
		}
		if a, ok := fc.allocas[v.Name]; ok {
			return "$" + a, nil
		}
		if c, ok := fc.constAddr[v.Name]; ok {
			if c.off != 0 {
				return fmt.Sprintf("$%s+%d", c.sym, c.off), nil
			}
			return "$" + c.sym, nil
		}
		return fc.word(v.Name), nil
	}
	return "", fmt.Errorf("unresolvable value")
}

// forward makes res an alias of src instead of emitting a copy. Phi
// results mutate at block heads and edges, so copies of them stay real.
func (fc *funcCtx) forward(res string, src *llir.Value) error {
	s, err := fc.op(src)
	if err != nil {
		return err
	}
	if src.Kind == llir.VLocal {
		if d := fc.defs[src.Name]; d != nil && d.Op == "phi" {
			fc.ins("move %s, %s", s, fc.word(res))
			return nil
		}
	}
	fc.fwd[res] = s
	return nil
}

// directAddr renders a pointer value as a static address operand if its
// target is known at link time.
func (fc *funcCtx) directAddr(v *llir.Value) (string, bool) {
	switch v.Kind {
	case llir.VGlobal:
		if m := hwMMIO(v.Name); m != "" {
			return m, true
		}
		return fc.globalOperand(v), true
	case llir.VLocal:
		if a, ok := fc.allocas[v.Name]; ok {
			return a, true
		}
		if c, ok := fc.constAddr[v.Name]; ok {
			if c.off != 0 {
				return fmt.Sprintf("%s+%d", c.sym, c.off), true
			}
			return c.sym, true
		}
		// A value forwarded to an address literal is a static address.
		if s, ok := fc.fwd[v.Name]; ok && strings.HasPrefix(s, "$") {
			rest := s[1:]
			if rest != "" && rest[0] != '-' && (rest[0] < '0' || rest[0] > '9') {
				return rest, true
			}
		}
	}
	return "", false
}

// --- Emission ---

// layoutOrder returns this function's blocks as IR indices in the order
// their finished text is PLACED: the entry block, then every block the
// profile did not call cold, then the cold ones — a stable partition,
// so both halves keep their IR order (prompts/042 §1,
// Options.ColdBlocks). Lowering order is separate, and is always IR
// order; see emit.
//
// Sinking never-executed code out from between hot blocks is worth two
// things on this machine. The prefetch path shortens (text is XIP
// flash: a taken jump into an unprefetched record parks the shared read
// master), and the hot edges the cold block used to separate become
// adjacent, so elideFallthroughJumps drops their jumps outright.
//
// Deliberately NOT hot-path chaining: no successor ordering, no edge
// weights, no block duplication. The simple partition is the thing
// being measured.
func (fc *funcCtx) layoutOrder() []int {
	n := len(fc.f.Blocks)
	order := make([]int, 0, n)
	for i := range fc.f.Blocks {
		order = append(order, i)
	}
	if len(fc.g.opts.ColdBlocks) == 0 || n < 3 {
		return order
	}
	// The entry block is pinned: the prologue falls through into it.
	hot, cold := []int{0}, []int(nil)
	for i, b := range fc.f.Blocks[1:] {
		if fc.g.opts.ColdBlocks[fc.blockLabel(b.Name)] {
			cold = append(cold, i+1)
		} else {
			hot = append(hot, i+1)
		}
	}
	return append(hot, cold...)
}

func (fc *funcCtx) emit() error {
	f := fc.f
	fmt.Fprintf(&fc.g.text, "\n; --- %s ---\n", f.Name)
	// ICF (outline.go): the folded-away functions of this group keep
	// their own entry labels, stacked on this one body.
	for _, n := range fc.g.icfAlias[f.Name] {
		fc.label(funcSym(n))
	}
	fc.label(funcSym(f.Name))
	fc.cat = "prologue"
	if fc.rec {
		fc.emitFramePush()
	} else {
		if fc.hasCalls {
			fc.ins("move lr, %s", fc.lrsWord())
		}
		for i, p := range f.Params {
			if i < 4 {
				fc.ins("move r%d, %s", i, fc.word(p.Name))
			}
		}
	}
	// The outliner's hot gate reads this: loop bodies keep their code
	// inline, unless Options.ColdBlocks measured them cold (outline.go,
	// gen.outlineHot). Same label spelling as the cold set, by
	// construction — both go through blockLabel.
	for name := range loopBlocks(f) {
		fc.g.loopLabels[fc.blockLabel(name)] = true
	}
	// Blocks are LOWERED in IR order and PLACED in layout order: each
	// one lands in its own buffer, and the buffers are concatenated
	// below. Lowering is full of order-carried state — a folded GEP
	// registers a link-time address (constAddr) and a pure copy
	// registers an alias (fwd), both emitting no code and both read at
	// every later use site; the block's pool slots are handed out at its
	// head; stub labels are numbered as they are minted. Lowering out of
	// order silently loses those: a use emitted before its own folded
	// definition reads a value word nothing ever writes (found as a
	// 4-byte write to address 0xa in the game's dino scene). Placement
	// moves finished text, which nothing else can observe.
	bufs := make([]strings.Builder, len(f.Blocks))
	for bi, b := range f.Blocks {
		fc.curBlock = bi
		fc.blockOut = &bufs[bi]
		fc.poolRelease()
		fc.label(fc.blockLabel(b.Name))
		// Phi heads: latch shadows into value words (shadow-mode blocks
		// only — direct-mode blocks were written on the edges).
		fc.cat = "phi"
		if !fc.directPhi[b.Name] {
			for _, ins := range b.Instrs {
				if ins.Op == "phi" {
					fc.ins("move %s, %s", fc.shadow(ins.Res), fc.word(ins.Res))
				}
			}
		}
		for _, ins := range b.Instrs {
			fc.cat = ins.Op
			if ins.Op == "call" && strings.HasPrefix(ins.Callee, "llvm.") {
				fc.cat = "intrinsic"
			}
			if err := fc.emitInstr(b, ins); err != nil {
				return fmt.Errorf("%s (IR line %d): %v", f.Name, ins.Line, err)
			}
		}
	}
	fc.blockOut = nil
	for _, bi := range fc.layoutOrder() {
		fc.outBuf().WriteString(bufs[bi].String())
	}
	return nil
}

func maskComplement(bits int) uint32 { return ^uint32(1<<bits - 1) }

// constOf returns the constant among two operands, if either is one.
func constOf(a, b *llir.Value) (uint32, bool) {
	if a.Kind == llir.VConst {
		return uint32(a.Int), true
	}
	if b.Kind == llir.VConst {
		return uint32(b.Int), true
	}
	return 0, false
}

// maskTo truncates a value word to the given width in place.
func (fc *funcCtx) maskTo(sym string, bits int) {
	if bits < 32 {
		fc.ins("andn %s, $0x%x, %s", sym, maskComplement(bits), sym)
	}
}

// sextInto emits sign extension of a sub-word operand into dst.
func (fc *funcCtx) sextInto(opnd string, bits int, dst string) {
	s := uint32(1) << (bits - 1)
	fc.ins("xor %s, $0x%x, %s", opnd, s, dst)
	fc.ins("sub %s, $0x%x, %s", dst, s, dst)
}

func sizeFlag(bits int) string {
	switch {
	case bits <= 8:
		return ", size8"
	case bits <= 16:
		return ", size16"
	}
	return ""
}

func (fc *funcCtx) emitInstr(b *llir.Block, ins *llir.Instr) error {
	switch ins.Op {
	case "phi", "alloca":
		return nil // handled elsewhere

	case "add", "sub", "and", "or", "xor":
		w, err := width(ins.Typ)
		if err != nil {
			return err
		}
		x, y := ins.Args[0], ins.Args[1]
		// Identities: x op 0 (and 0 op x for the commutative ones) is x.
		if y.Kind == llir.VConst && uint32(y.Int) == 0 && ins.Op != "and" {
			return fc.forward(ins.Res, x)
		}
		if x.Kind == llir.VConst && uint32(x.Int) == 0 && (ins.Op == "add" || ins.Op == "or" || ins.Op == "xor") {
			return fc.forward(ins.Res, y)
		}
		a, err := fc.op(x)
		if err != nil {
			return err
		}
		bb, err := fc.op(y)
		if err != nil {
			return err
		}
		res := fc.word(ins.Res)
		if ins.Op == "and" {
			// AND with a constant is the 3-block andn with the mask's
			// complement; the general and macro costs 6.
			if x.Kind == llir.VConst {
				x, a, bb = y, bb, a
			}
			if k, isC := constOf(ins.Args[0], ins.Args[1]); isC {
				if k == 0xFFFFFFFF {
					return fc.forward(ins.Res, x)
				}
				fc.ins("andn %s, $0x%x, %s", a, ^k, res)
				return nil
			}
		}
		fc.ins("%s %s, %s, %s", ins.Op, a, bb, res)
		if ins.Op == "add" || ins.Op == "sub" {
			fc.maskTo(res, w)
		}
		return nil

	case "mul":
		return fc.emitMul(ins)

	case "shl":
		return fc.emitShl(ins)

	case "lshr", "ashr":
		if done, err := fc.emitShrConst(ins); done || err != nil {
			return err
		}
		return fc.emitRuntimeOp(ins)

	case "udiv", "sdiv", "urem", "srem":
		if done, err := fc.emitDivConst(ins); done || err != nil {
			return err
		}
		return fc.emitRuntimeOp(ins)

	case "icmp":
		if fc.fused[ins.Res] {
			return nil // emitted at the branch
		}
		res := fc.word(ins.Res)
		t, f := fc.stub("Ct"), fc.stub("Cf")
		j := fc.stub("Cj")
		if err := fc.emitCompareBranch(ins, t, f); err != nil {
			return err
		}
		fc.label(t)
		fc.ins("move $1, %s", res)
		fc.ins("jump %s", j)
		fc.label(f)
		fc.ins("move $0, %s", res)
		fc.label(j)
		return nil

	case "select":
		res := fc.word(ins.Res)
		av, err := fc.op(ins.Args[1])
		if err != nil {
			return err
		}
		bv, err := fc.op(ins.Args[2])
		if err != nil {
			return err
		}
		if ins.Args[0].Kind == llir.VConst {
			if ins.Args[0].Int != 0 {
				fc.ins("move %s, %s", av, res)
			} else {
				fc.ins("move %s, %s", bv, res)
			}
			return nil
		}
		t, f, j := fc.stub("St"), fc.stub("Sf"), fc.stub("Sj")
		if err := fc.emitBoolBranch(ins.Args[0], t, f); err != nil {
			return err
		}
		fc.label(t)
		fc.ins("move %s, %s", av, res)
		fc.ins("jump %s", j)
		fc.label(f)
		fc.ins("move %s, %s", bv, res)
		fc.label(j)
		return nil

	case "load":
		if fc.pair64Ld[ins] {
			return nil // emitted as a two-word copy at the paired store
		}
		// i64 loads exist only to consume 8-byte varargs (%lld skip):
		// keep the low word — correct for every trunc-to-32 use, and any
		// other use of the value fails width() with a clear error.
		if ins.Typ.Kind == llir.TInt && ins.Typ.Bits == 64 {
			ins = &llir.Instr{Op: "load", Res: ins.Res, Typ: &llir.Type{Kind: llir.TInt, Bits: 32}, Args: ins.Args}
		}
		w, err := width(ins.Typ)
		if err != nil {
			return err
		}
		res := fc.word(ins.Res)
		if w < 32 {
			fc.ins("move $0, %s", res)
		}
		if addr, ok := fc.directAddr(ins.Args[0]); ok {
			fc.ins("move %s, %s%s", addr, res, sizeFlag(w))
			return nil
		}
		p, err := fc.op(ins.Args[0])
		if err != nil {
			return err
		}
		ld := fc.stub("Ld")
		fc.ins("move %s, %s.read", p, ld)
		fc.stubBody(ld, "move @0, %s%s", res, sizeFlag(w))
		return nil

	case "store":
		if ld, ok := fc.pair64[ins]; ok {
			tmp := fc.word(ld.Res) // declared word doubles as the ferry
			for _, off := range []uint32{0, 4} {
				if err := fc.loadWordAt(ld.Args[0], off, tmp); err != nil {
					return err
				}
				if err := fc.storeWordAt(ins.Args[1], off, tmp); err != nil {
					return err
				}
			}
			return nil
		}
		w, err := width(ins.Typ)
		if err != nil {
			return err
		}
		val, err := fc.op(ins.Args[0])
		if err != nil {
			return err
		}
		if addr, ok := fc.directAddr(ins.Args[1]); ok {
			fc.ins("move %s, %s%s", val, addr, sizeFlag(w))
			return nil
		}
		p, err := fc.op(ins.Args[1])
		if err != nil {
			return err
		}
		st := fc.stub("Sd")
		fc.ins("move %s, %s.write", p, st)
		fc.stubBody(st, "move %s, @0%s", val, sizeFlag(w))
		return nil

	case "getelementptr":
		return fc.emitGEP(ins)

	case "insertvalue", "extractvalue":
		// Only the single-word aggregate case (ABI-coerced values like
		// [1 x i32] va_list): the element IS the word, so both are copies.
		if s := ins.Typ.Size(); s > 4 {
			return fmt.Errorf("%s on %d-byte aggregate is not supported", ins.Op, s)
		}
		src := ins.Args[0]
		if ins.Op == "insertvalue" {
			src = ins.Args[1]
		}
		return fc.forward(ins.Res, src)

	case "zext", "bitcast", "ptrtoint", "inttoptr", "freeze":
		return fc.forward(ins.Res, ins.Args[0])

	case "sext":
		srcW, err := width(ins.Args[0].Typ)
		if err != nil {
			return err
		}
		dstW, err := width(ins.To)
		if err != nil {
			return err
		}
		if srcW == 32 {
			return fc.forward(ins.Res, ins.Args[0])
		}
		src, err := fc.op(ins.Args[0])
		if err != nil {
			return err
		}
		res := fc.word(ins.Res)
		fc.sextInto(src, srcW, res)
		fc.maskTo(res, dstW)
		return nil

	case "trunc":
		// trunc from i64 needs only the low word, which is what an i64
		// load leaves in the value word.
		dstW, err := width(ins.To)
		if err != nil {
			return err
		}
		srcW := 32
		if ins.Args[0].Typ != nil && ins.Args[0].Typ.Kind == llir.TInt && ins.Args[0].Typ.Bits <= 32 {
			srcW = ins.Args[0].Typ.Bits
		}
		if dstW >= 32 || srcW <= dstW {
			return fc.forward(ins.Res, ins.Args[0])
		}
		src, err := fc.op(ins.Args[0])
		if err != nil {
			return err
		}
		res := fc.word(ins.Res)
		fc.ins("andn %s, $0x%x, %s", src, maskComplement(dstW), res)
		return nil

	case "call":
		return fc.emitCall(ins)

	case "br":
		return fc.emitBr(b, ins)

	case "switch":
		return fc.emitSwitch(b, ins)

	case "ret":
		if fc.tailRet[ins] {
			return nil // the preceding tail call already left
		}
		if fc.rec {
			return fc.emitFramePop(ins)
		}
		if len(ins.Args) > 0 {
			v, err := fc.op(ins.Args[0])
			if err != nil {
				return err
			}
			fc.ins("move %s, r0", v)
		}
		if fc.hasCalls {
			fc.ins("move %s, lr", fc.lrsWord())
		}
		fc.ins("ret")
		return nil

	case "unreachable":
		fc.ins("halt")
		return nil
	}
	return fmt.Errorf("unsupported instruction %q", ins.Op)
}

// --- Multiplication and shifts ---

// emitMulConst computes res = src * k with a double-and-add chain
// (exact mod 2^32 for any k, including "negative" constants). Uses sc0.
func (fc *funcCtx) emitMulConst(src string, k uint32, res string) {
	switch {
	case k == 0:
		fc.ins("move $0, %s", res)
		return
	case k == 1:
		fc.ins("move %s, %s", src, res)
		return
	case k <= 64:
		fc.ins("mulc %s, %d, %s", src, k, res)
		return
	}
	fc.ins("move %s, sc0", src)
	first := true
	for bit := 0; bit < 32 && k>>bit != 0; bit++ {
		if k>>bit&1 == 1 {
			if first {
				if bit == 0 {
					fc.ins("move sc0, %s", res)
				} else {
					fc.ins("move sc0, %s", res)
				}
				first = false
			} else {
				fc.ins("add %s, sc0, %s", res, res)
			}
		}
		if k>>(bit+1) != 0 {
			fc.ins("shl sc0, sc0")
		}
	}
}

func (fc *funcCtx) emitMul(ins *llir.Instr) error {
	w, err := width(ins.Typ)
	if err != nil {
		return err
	}
	res := fc.word(ins.Res)
	a, b := ins.Args[0], ins.Args[1]
	if b.Kind == llir.VConst || a.Kind == llir.VConst {
		if a.Kind == llir.VConst {
			a, b = b, a
		}
		src, err := fc.op(a)
		if err != nil {
			return err
		}
		fc.emitMulConst(src, uint32(b.Int), res)
		fc.maskTo(res, w)
		return nil
	}
	av, err := fc.op(a)
	if err != nil {
		return err
	}
	bv, err := fc.op(b)
	if err != nil {
		return err
	}
	fc.hasCalls = true
	fc.ins("move %s, %s", av, fc.rtReg("r0"))
	fc.ins("move %s, %s", bv, fc.rtReg("r1"))
	fc.rtCall("mul")
	fc.ins("move %s, %s", fc.rtReg("r0"), res)
	fc.maskTo(res, w)
	return nil
}

// --- Byte-lane constant shifts ---
//
// Every value is a little-endian word in byte-addressable SRAM, so a
// constant shift by a whole number of bytes is a copy of a byte range:
// x >> 8 is the three bytes at &x+1 landing at &res+0, x << 16 is the
// low half of x landing at &res+2. The result word is zeroed first, so
// the lanes the copy does not cover read as zero.

// laneable reports whether an operand is a bare data-word symbol — the
// only form a byte offset can be taken of. Literals ($imm), MMIO names
// and absolute addresses are not, and neither is an operand that
// already carries an offset or a block field.
func laneable(op string) bool {
	return op != "" && !strings.ContainsAny(op, "$%@+.")
}

// laneSrc returns an operand equal to src that byte offsets can be
// taken of, ferrying through scratch when src is not addressable or
// aliases dst (the lane copies zero dst before reading src).
func (fc *funcCtx) laneSrc(src, dst, scratch string) string {
	if laneable(src) && src != dst {
		return src
	}
	fc.ins("move %s, %s", src, scratch)
	return scratch
}

// laneShr emits dst = src >> (8*k) for k in 1..3. src and dst must be
// distinct addressable words.
func (fc *funcCtx) laneShr(src string, k int, dst string) {
	fc.ins("move $0, %s", dst)
	switch k {
	case 1:
		fc.ins("move %s+1, %s, size8, count=3, incrr, incrw", src, dst)
	case 2:
		fc.ins("move %s+2, %s, size16", src, dst)
	case 3:
		fc.ins("move %s+3, %s, size8", src, dst)
	}
}

// laneShl emits dst = src << (8*k) for k in 1..3: laneShr mirrored.
func (fc *funcCtx) laneShl(src string, k int, dst string) {
	fc.ins("move $0, %s", dst)
	switch k {
	case 1:
		fc.ins("move %s, %s+1, size8, count=3, incrr, incrw", src, dst)
	case 2:
		fc.ins("move %s, %s+2, size16", src, dst)
	case 3:
		fc.ins("move %s, %s+3, size8", src, dst)
	}
}

// shlConst emits dst = src << n (n >= 0, exact mod 2^32) for the bits a
// byte lane cannot carry. mulc's counted accumulate doubles the sniffer
// sum once per transfer, so it carries up to six bits in one three-block
// macro where a doubling chain spends three blocks per bit. Its count
// holds 2^n, which is what caps a step at six.
func (fc *funcCtx) shlConst(src string, n int, dst string) {
	for n > 6 {
		fc.ins("mulc %s, 64, %s", src, dst)
		src, n = dst, n-6
	}
	switch {
	case n == 1:
		fc.ins("shl %s, %s", src, dst)
	case n > 1:
		fc.ins("mulc %s, %d, %s", src, 1<<n, dst)
	case src != dst:
		fc.ins("move %s, %s", src, dst)
	}
}

// laneShrConst emits dst = src >>u n for 1 <= n <= 31.
//
// Whole bytes are one lane copy. A leftover r = n%8 rides a left shift
// by 8-r through the lanes the copy freed, then one more lane brings it
// down: src >> 8k has at least eight leading zeros, so that shift
// cannot overflow.
//
// Below one byte there is no such headroom, so the word splits at the
// byte boundary: x >> n is (x >> 8) << (8-n) for everything above the
// low byte, OR'd with byte 1 of x << (8-n) for the rest. That byte
// holds bits n..n+7 of x, so the two halves overlap on bits 8..n+7 —
// and place them at the same positions, which is what makes the merge
// a disjunction.
func (fc *funcCtx) laneShrConst(src string, n int, dst string) {
	k, r := n/8, n%8
	switch {
	case r == 0:
		fc.laneShr(fc.laneSrc(src, dst, "sc1"), k, dst)
	case k > 0:
		fc.laneShr(fc.laneSrc(src, "sc1", "sc2"), k, "sc1")
		fc.shlConst("sc1", 8-r, "sc1")
		fc.laneShr("sc1", 1, dst)
	default:
		s := fc.laneSrc(src, "sc1", "sc2")
		fc.laneShr(s, 1, "sc1")
		fc.shlConst("sc1", 8-n, "sc1")
		fc.shlConst(s, 8-n, "sc2")
		fc.ins("move $0, %s", dst)
		fc.ins("move sc2+1, %s, size8", dst)
		fc.ins("or %s, sc1, %s", dst, dst)
	}
}

// emitShl lowers a left shift. A constant count splits into a byte-lane
// copy for its 8*k bits and a mulc for the remaining 0..7.
func (fc *funcCtx) emitShl(ins *llir.Instr) error {
	w, err := width(ins.Typ)
	if err != nil {
		return err
	}
	res := fc.word(ins.Res)
	a, sh := ins.Args[0], ins.Args[1]
	av, err := fc.op(a)
	if err != nil {
		return err
	}
	if sh.Kind == llir.VConst {
		n := int(uint32(sh.Int)) & 31
		if n == 0 {
			return fc.forward(ins.Res, a)
		}
		if k := n / 8; k > 0 {
			fc.laneShl(fc.laneSrc(av, res, "sc1"), k, res)
			fc.shlConst(res, n%8, res)
		} else {
			fc.shlConst(av, n, res)
		}
		fc.maskTo(res, w)
		return nil
	}
	sv, err := fc.op(sh)
	if err != nil {
		return err
	}
	fc.hasCalls = true
	fc.ins("move %s, %s", av, fc.rtReg("r0"))
	fc.ins("move %s, %s", sv, fc.rtReg("r1"))
	fc.rtCall("shl")
	fc.ins("move %s, %s", fc.rtReg("r0"), res)
	fc.maskTo(res, w)
	return nil
}

// emitShrConst lowers lshr/ashr by a constant count and reports whether
// it took the instruction: every constant count goes through the byte
// lanes (laneShrConst), so only a run-time count reaches the runtime.
// An arithmetic shift is the logical one plus the sign fold
// (y ^ s) - s with s = 1 << (31-n), two blocks either way. The
// subtraction rides `add` with the negated constant: three blocks
// against `sub`'s five.
func (fc *funcCtx) emitShrConst(ins *llir.Instr) (bool, error) {
	sh := ins.Args[1]
	if sh.Kind != llir.VConst {
		return false, nil
	}
	n := int(uint32(sh.Int)) & 31
	if n == 0 {
		return true, fc.forward(ins.Res, ins.Args[0])
	}
	signed := ins.Op == "ashr"
	w, err := width(ins.Typ)
	if err != nil {
		return false, err
	}
	av, err := fc.op(ins.Args[0])
	if err != nil {
		return false, err
	}
	res := fc.word(ins.Res)
	if signed && w < 32 {
		fc.sextInto(av, w, "sc0")
		av = "sc0"
	}
	fc.laneShrConst(av, n, res)
	if signed {
		s := uint32(1) << uint(31-n)
		fc.ins("xor %s, $0x%x, %s", res, s, res)
		fc.ins("add %s, $0x%x, %s", res, -s, res)
	}
	if signed || w < 32 {
		fc.maskTo(res, w)
	}
	return true, nil
}

// --- Division by a constant ---
//
// __rt_udivmod is 31 restoring-division rounds — ~6,900 emulator
// cycles whatever the divisor — and clang leaves division by a
// constant as an IR div on this target (no backend runs after it). So
// the divisors the compiler CAN see are lowered here instead: powers of two
// as byte lanes and masks with no call at all, 10 and 100 as calls to
// the reciprocal routine (runtime.go, __rt_udivmod10).
//
// Every other constant still calls __rt_udivmod. The general cure is a
// magic-number multiply — q = (x * M) >> (32 + s) — and its high half
// is a 64-bit product this machine has no way to spell: the sniffer
// accumulates 32 bits and drops the carry. Splitting x into halves and
// summing partial products does reach the same answer, but at three
// multiplies plus the adds it is no cheaper than the reciprocal call it
// would replace. divConstChain below is where a new divisor goes.

// divConstChain maps a constant divisor to the /10 steps that divide by
// it. Truncating division composes for positive factors —
// trunc(trunc(x/10)/10) == trunc(x/100) — so a power of ten is one call
// per digit, and adding 1000 is one more entry. Each step is a call
// though, and the routine's ~410 cycles stop being a bargain against
// __rt_udivmod's ~6,900 long before the chain runs out of divisors.
var divConstChain = map[uint32]int{10: 1, 100: 2}

// divConstant reads a div/rem instruction's divisor at the operation's
// own width and signedness: mag is its magnitude, neg its sign (always
// false for the unsigned ops). ok is false when the divisor is not a
// constant.
func divConstant(ins *llir.Instr) (mag uint32, neg, ok bool) {
	d := ins.Args[1]
	if d.Kind != llir.VConst {
		return 0, false, false
	}
	w, err := width(ins.Typ)
	if err != nil {
		return 0, false, false
	}
	k := uint32(d.Int) &^ maskComplement(w)
	if ins.Op == "sdiv" || ins.Op == "srem" {
		if k>>uint(w-1)&1 != 0 {
			k |= maskComplement(w) // sign-extend to the full word
		}
		if int32(k) < 0 {
			return uint32(-int32(k)), true, true
		}
	}
	return k, false, true
}

// divConstInline reports whether emitDivConst takes an instruction
// without emitting a call — which is what lets the prologue skip saving
// lr. The identity and power-of-two divisors qualify; a zero divisor is
// undefined in C and keeps whatever the runtime does with it.
func divConstInline(ins *llir.Instr) bool {
	mag, _, ok := divConstant(ins)
	return ok && mag != 0 && mag&(mag-1) == 0
}

// signBias emits dst = (x < 0 ? 2^n - 1 : 0) for 1 <= n <= 31, the bias
// that turns an arithmetic right shift into C's truncation toward zero.
// Branchless: s = x >>a 31 is 0 or -1 (all ones), and s >>u (32-n) is 0
// or exactly the low n ones. n == 1 collapses to the sign bit itself.
// x must not name sc1 or sc2, which the lane shifts use as scratch.
func (fc *funcCtx) signBias(x string, n int, dst string) {
	fc.laneShrConst(x, 31, dst) // 0 or 1
	if n == 1 {
		return
	}
	fc.ins("xor %s, $1, %s", dst, dst)          // 1 or 0
	fc.ins("add %s, $0xffffffff, %s", dst, dst) // 0 or -1
	fc.laneShrConst(dst, 32-n, dst)
}

// emitDivConst lowers a udiv/sdiv/urem/srem whose divisor is a constant
// this machine has a short sequence for, and reports whether it took the
// instruction.
//
// Powers of two, with x already sign-extended to the full word when the
// operation is signed and the type is not:
//
//	udiv x, 2^n  = x >>u n                     (byte lanes)
//	urem x, 2^n  = x & (2^n - 1)               (one andn)
//	sdiv x, 2^n  = (x + bias) >>a n            bias = signBias(x, n)
//	srem x, 2^n  = ((x + bias) & (2^n-1)) - bias
//
// C truncates toward zero, which the shifts do not: they floor. Adding
// 2^n - 1 before shifting a negative dividend rounds the quotient the
// other way, and nothing overflows doing it — the bias is positive and
// smaller than 2^n <= 2^31, so x + bias stays inside [x, -1] for every
// negative x, INT_MIN included.
//
// The remainder identity follows from the quotient's: for x >= 0 it is
// the plain mask, and for x < 0, ((x - 1) mod 2^n) - (2^n - 1) lands in
// (-2^n, 0], which is C's sign-of-the-dividend remainder. INT_MIN % 2^n
// is 0 both ways.
//
// A negative divisor divides by its magnitude and negates the quotient;
// the remainder takes the dividend's sign whatever the divisor's is, so
// it is the magnitude's remainder unchanged. That covers x / INT_MIN,
// which is the n == 31 case.
func (fc *funcCtx) emitDivConst(ins *llir.Instr) (bool, error) {
	mag, neg, ok := divConstant(ins)
	if !ok || mag == 0 {
		return false, nil
	}
	steps, chained := divConstChain[mag]
	pow2 := mag&(mag-1) == 0
	signed := ins.Op == "sdiv" || ins.Op == "srem"
	rem := ins.Op == "urem" || ins.Op == "srem"
	if !pow2 && !(chained && !signed) {
		return false, nil
	}
	w, err := width(ins.Typ)
	if err != nil {
		return false, err
	}
	av, err := fc.op(ins.Args[0])
	if err != nil {
		return false, err
	}
	res := fc.word(ins.Res)

	// x / 1 is x and x % 1 is 0, at either sign.
	if mag == 1 {
		switch {
		case rem:
			fc.ins("move $0, %s", res)
		case !neg:
			return true, fc.forward(ins.Res, ins.Args[0])
		default:
			fc.ins("sub zero, %s, %s", av, res)
			fc.maskTo(res, w)
		}
		return true, nil
	}
	if signed && w < 32 {
		// The value word of a narrow signed operand holds only w bits;
		// every identity here reads the whole word.
		fc.sextInto(av, w, "sc0")
		av = "sc0"
	}
	switch {
	case pow2 && !signed:
		if rem {
			fc.ins("andn %s, $0x%x, %s", av, ^(mag - 1), res)
			return true, nil
		}
		fc.laneShrConst(av, bits.TrailingZeros32(mag), res)
		return true, nil

	case pow2:
		n := bits.TrailingZeros32(mag)
		fc.signBias(av, n, res)
		if rem {
			fc.ins("add %s, %s, sc1", av, res)
			fc.ins("andn sc1, $0x%x, sc1", ^(mag - 1))
			fc.ins("sub sc1, %s, %s", res, res)
			fc.maskTo(res, w)
			return true, nil
		}
		fc.ins("add %s, %s, %s", av, res, res)
		fc.laneShrConst(res, n, res)
		s := uint32(1) << uint(31-n)
		fc.ins("xor %s, $0x%x, %s", res, s, res)
		fc.ins("add %s, $0x%x, %s", res, -s, res)
		if neg {
			fc.ins("sub zero, %s, %s", res, res)
		}
		fc.maskTo(res, w)
		return true, nil
	}

	// Unsigned 10 and its powers: one call per digit, quotient in r0 —
	// which is also the next step's dividend, so the calls simply
	// follow one another. The single-step remainder comes back in r1;
	// a longer chain rebuilds it from the quotient.
	fc.hasCalls = true
	fc.ins("move %s, %s", av, fc.rtReg("r0"))
	for i := 0; i < steps; i++ {
		fc.rtCall("udivmod10")
	}
	if !rem {
		fc.ins("move %s, %s", fc.rtReg("r0"), res)
		return true, nil
	}
	if steps == 1 {
		fc.ins("move %s, %s", fc.rtReg("r1"), res)
		return true, nil
	}
	fc.ins("move %s, %s", fc.rtReg("r0"), res)
	fc.emitMulConst(res, mag, res)
	fc.ins("sub %s, %s, %s", av, res, res)
	return true, nil
}

// emitRuntimeOp lowers variable-count lshr/ashr, and the div/rem whose
// divisor emitDivConst declined, via runtime calls. Those divides still
// meet the reciprocal on the way: __rt_udivmod checks for a divisor of
// 10 before starting its long division.
func (fc *funcCtx) emitRuntimeOp(ins *llir.Instr) error {
	w, err := width(ins.Typ)
	if err != nil {
		return err
	}
	res := fc.word(ins.Res)
	av, err := fc.op(ins.Args[0])
	if err != nil {
		return err
	}
	bv, err := fc.op(ins.Args[1])
	if err != nil {
		return err
	}
	signed := ins.Op == "ashr" || ins.Op == "sdiv" || ins.Op == "srem"
	if signed && w < 32 {
		fc.sextInto(av, w, "sc0")
		av = "sc0"
		if ins.Op != "ashr" {
			fc.sextInto(bv, w, "sc1")
			bv = "sc1"
		}
	}
	rt := map[string]string{
		"lshr": "lshr", "ashr": "ashr", "udiv": "udiv",
		"sdiv": "sdiv", "urem": "urem", "srem": "srem",
	}[ins.Op]
	fc.hasCalls = true
	fc.ins("move %s, %s", av, fc.rtReg("r0"))
	fc.ins("move %s, %s", bv, fc.rtReg("r1"))
	fc.rtCall(rt)
	fc.ins("move %s, %s", fc.rtReg("r0"), res)
	if signed || ins.Op == "lshr" && w < 32 {
		fc.maskTo(res, w)
	}
	return nil
}

// --- GEP ---

func (fc *funcCtx) emitGEP(ins *llir.Instr) error {
	base := ins.Args[0]
	indices := ins.Args[1:]
	cur := ins.Typ
	constOff := int64(0)
	type varPart struct {
		v     *llir.Value
		scale int
	}
	var vars []varPart
	for j, iv := range indices {
		if j > 0 {
			switch cur.Kind {
			case llir.TArray:
				cur = cur.Elem
			case llir.TStruct:
				if iv.Kind != llir.VConst {
					return fmt.Errorf("GEP struct index must be constant")
				}
				idx := int(int32(iv.Int))
				constOff += int64(cur.FieldOffset(idx))
				cur = cur.Fields[idx]
				continue
			default:
				return fmt.Errorf("GEP walks into scalar type %s", cur)
			}
		}
		scale := cur.Size()
		if j == 0 {
			scale = ins.Typ.Size()
		}
		if iv.Kind == llir.VConst {
			constOff += int64(int32(iv.Int)) * int64(scale)
		} else {
			vars = append(vars, varPart{iv, scale})
		}
	}
	// Fully static: fold to a link-time address, no code.
	if len(vars) == 0 {
		if addr, ok := fc.directAddr(base); ok {
			sym, off := addr, uint32(0)
			if i := strings.IndexByte(addr, '+'); i >= 0 {
				sym = addr[:i]
				fmt.Sscanf(addr[i+1:], "%d", &off)
			}
			fc.constAddr[ins.Res] = addrC{sym: sym, off: off + uint32(constOff)}
			return nil
		}
	}
	// A no-op GEP (zero offset, no variable indices) is an alias of
	// its base: forward instead of copying (0 blocks vs 1).
	if constOff == 0 && len(vars) == 0 {
		return fc.forward(ins.Res, base)
	}
	res := fc.word(ins.Res)
	bv, err := fc.op(base)
	if err != nil {
		return err
	}
	// Fold the base into the first arithmetic op instead of a leading
	// `move base, res` (an add costs 3 blocks; the move is pure waste).
	first := true
	acc := func(operand string) {
		if first {
			fc.ins("add %s, %s, %s", bv, operand, res)
			first = false
			return
		}
		fc.ins("add %s, %s, %s", res, operand, res)
	}
	if constOff != 0 {
		acc(fmt.Sprintf("$0x%x", uint32(int32(constOff))))
	}
	for _, vp := range vars {
		iv, err := fc.op(vp.v)
		if err != nil {
			return err
		}
		if vp.scale == 1 {
			acc(iv)
			continue
		}
		fc.emitMulConst(iv, uint32(vp.scale), "sc1")
		acc("sc1")
	}
	return nil
}

// --- Calls ---

func isNopIntrinsic(name string) bool {
	for _, pre := range []string{"llvm.lifetime.", "llvm.assume", "llvm.dbg.", "llvm.experimental.noalias", "llvm.prefetch"} {
		if strings.HasPrefix(name, pre) {
			return true
		}
	}
	return false
}

func (fc *funcCtx) emitCall(ins *llir.Instr) error {
	name := ins.Callee
	if isNopIntrinsic(name) {
		return nil
	}
	if strings.HasPrefix(name, "llvm.") {
		return fc.emitIntrinsic(ins)
	}
	if ins.CalleeVal != nil {
		return fc.emitIndirectCall(ins)
	}
	if name == recOverflowName {
		// Depth-K intra-cycle call in an image with no frame-stack tail
		// to fall into (computeRecursion): bounded recursion exhausted.
		// If the program defines the sink itself (usys.c does: report
		// and exit, dying as a process), route there — it must not
		// return. Otherwise HALT stops the machine at a well-defined
		// point.
		if _, ok := fc.g.funcIdx[name]; !ok {
			fc.ins("halt")
			return nil
		}
	}
	callee, ok := fc.g.funcIdx[name]
	if !ok {
		// Freestanding clang may emit direct libcalls for the memory
		// builtins; they lower to the native DMA runtime like their
		// intrinsic forms.
		switch name {
		case "memcpy", "memset":
			if len(ins.Args) == 3 {
				if err := fc.emitMemRT(name, ins.Args[0], ins.Args[1], ins.Args[2]); err != nil {
					return err
				}
				// Both return their first argument.
				if ins.Res != "" && ins.Typ.Kind != llir.TVoid {
					return fc.forward(ins.Res, ins.Args[0])
				}
				return nil
			}
		}
		return fmt.Errorf("call to undefined function %q (no external linkage on this target)", name)
	}
	nfix := len(callee.Params)
	if callee.Variadic && len(ins.Args) < nfix || !callee.Variadic && len(ins.Args) != nfix {
		return fmt.Errorf("call to %q: %d args, %d params", name, len(ins.Args), nfix)
	}
	ccName := sanitize(callee.Name)
	for i, av := range ins.Args {
		v, err := fc.op(av)
		if err != nil {
			return err
		}
		switch {
		case i >= nfix: // variadic tail: contiguous words in the va area
			if av.Typ != nil && av.Typ.Kind == llir.TInt && av.Typ.Bits > 32 {
				return fmt.Errorf("call to %q: long long variadic arguments are not supported", name)
			}
			if off := 4 * (i - nfix); off != 0 {
				fc.ins("move %s, va_%s+%d", v, ccName, off)
			} else {
				fc.ins("move %s, va_%s", v, ccName)
			}
		case i < 4:
			fc.ins("move %s, r%d", v, i)
		default:
			// Beyond r3, args go directly into the callee's frame.
			fc.ins("move %s, v_%s_%s", v, ccName, sanitize(callee.Params[i].Name))
		}
	}
	if fc.tail[ins] {
		if fc.hasCalls {
			fc.ins("move %s, lr", fc.lrsWord()) // restore before leaving
		}
		fc.ins("jump %s", funcSym(name))
		return nil
	}
	barrier := name == "fork" && fc.g.saveSet[fc.f.Name]
	if barrier {
		fc.emitForkPush()
	}
	fc.ins("call %s", funcSym(name))
	if barrier {
		fc.emitForkPop()
	}
	if ins.Res != "" && ins.Typ.Kind != llir.TVoid {
		fc.ins("move r0, %s", fc.word(ins.Res))
	}
	return nil
}

// --- The vfork barrier (see gen.computeRecursion, invariant (ii)) ---
//
// Bracketing a direct fork() call: everything the suspended parent
// still owns and the child is free to overwrite goes onto a save area
// before the call, and comes back on the parent's return.
//
//	[fsp] -> the shadow stack        the frame pointer the child leaks
//	                                 upward by pushing and then exec'ing
//	[this activation's frame]        the child re-emerges HERE and runs
//	                                 forward through these words
//	[the whole tail block]           the child's deeper recursion
//	                                 overwrites each tail copy's static
//	                                 cells (its outer copies are safely
//	                                 below fsp — invariant (i))
//
// The two frames ride the recursion frame stack itself, above the
// parent's fsp, so nesting is automatic: a child's own barrier saves
// land above its parent's. Only the fsp word needs a stack of its own,
// because restoring fsp is what makes the frame stack usable again.
//
// It is emitted INLINE at every site. A shared helper would need a
// static lr cell of its own, and that cell is exactly the kind of
// hidden state a vfork child clobbers on the way past.
func (fc *funcCtx) emitForkPush() {
	self := sanitize(fc.f.Name)
	// Room for this frame plus the tail block, then the shadow word.
	fc.ins("add g___dmacc_fsp, $@FRV_%s@, sc2", self)
	fc.emitStackCheck("sc2")
	fc.ins("add g___dmacc_fshp, $4, sc1")
	shOK := fc.stub("Vok")
	fc.emitCmpSite("ltu", fmt.Sprintf("$g___dmacc_fshadow+%d", 4*forkShadowWords),
		"sc1", "__fovf", shOK)
	fc.label(shOK)
	sh := fc.stub("Vsh")
	fc.ins("move g___dmacc_fshp, %s.write", sh)
	fc.stubBody(sh, "move g___dmacc_fsp, @0")
	fc.ins("move sc1, g___dmacc_fshp")
	fc.frameBurst("Vsv", "g___dmacc_fsp", "$fr_"+self)
	fc.ins("add g___dmacc_fsp, $@FR_%s@, sc1", self)
	fc.tailBurst("Vst", "sc1", "$g___dmacc_ftail")
	fc.ins("move sc2, g___dmacc_fsp")
}

// emitForkPop is the other half: nonzero (a pid, or -1 for a failed
// fork) means the PARENT is resuming and must undo the child's damage;
// zero means this IS the child, which owns the image from here and
// leaves the parent's save area exactly where it is.
func (fc *funcCtx) emitForkPop() {
	self := sanitize(fc.f.Name)
	child, parent := fc.stub("Vch"), fc.stub("Vpa")
	fc.emitCmpSite("eqz", "r0", "", child, parent)
	fc.label(parent)
	fc.ins("sub g___dmacc_fshp, $4, sc1")
	fc.ins("move sc1, g___dmacc_fshp")
	rs := fc.stub("Vrs")
	fc.ins("move sc1, %s.read", rs)
	fc.stubBody(rs, "move @0, g___dmacc_fsp")
	fc.frameBurst("Vrf", "$fr_"+self, "g___dmacc_fsp")
	fc.ins("add g___dmacc_fsp, $@FR_%s@, sc1", self)
	fc.tailBurst("Vrt", "$g___dmacc_ftail", "sc1")
	fc.label(child)
}

// tailBurst moves the whole tail frame block (every tail copy's static
// frame, emitted back to back by emitFunc) in one patched record.
func (fc *funcCtx) tailBurst(prefix, dst, src string) {
	blk := fc.stub(prefix)
	fc.ins("move %s, %s.write", dst, blk)
	fc.ins("move %s, %s.read", src, blk)
	fc.stubBody(blk, "move @0, @0, incrr, incrw, wcount=@FRTW@")
}

// emitIndirectCall calls through a function-pointer value: store the
// return address into lr, jump through the pointer word. The callee's
// prologue saves lr like any other call. Only register args fit — the
// callee's frame is unknown at compile time.
func (fc *funcCtx) emitIndirectCall(ins *llir.Instr) error {
	if len(ins.Args) > 4 {
		return fmt.Errorf("indirect call with %d args: only 4 register args are supported", len(ins.Args))
	}
	if ins.FixedArgs >= 0 && len(ins.Args) > ins.FixedArgs {
		return fmt.Errorf("indirect variadic calls are not supported")
	}
	for i, av := range ins.Args {
		v, err := fc.op(av)
		if err != nil {
			return err
		}
		fc.ins("move %s, r%d", v, i)
	}
	ptr, err := fc.op(ins.CalleeVal)
	if err != nil {
		return err
	}
	if fc.tail[ins] {
		if fc.hasCalls {
			fc.ins("move %s, lr", fc.lrsWord())
		}
		fc.ins("jumpr %s", ptr)
		return nil
	}
	ret := fc.stub("Ri")
	fc.ins("move $%s, lr", ret)
	fc.ins("jumpr %s", ptr)
	fc.label(ret)
	if ins.Res != "" && ins.Typ.Kind != llir.TVoid {
		fc.ins("move r0, %s", fc.word(ins.Res))
	}
	return nil
}

// loadWordAt reads the 32-bit word at pointer p plus a byte offset
// into dst; storeWordAt is its mirror. Both fold the offset into
// direct addresses and otherwise compute through at2.
func (fc *funcCtx) loadWordAt(p *llir.Value, off uint32, dst string) error {
	if addr, ok := fc.directAddr(p); ok {
		if off != 0 {
			addr = fmt.Sprintf("%s+%d", addr, off)
		}
		fc.ins("move %s, %s", addr, dst)
		return nil
	}
	pv, err := fc.op(p)
	if err != nil {
		return err
	}
	ld := fc.stub("Lw")
	if off != 0 {
		fc.ins("add %s, $%d, at2", pv, off)
		fc.ins("move at2, %s.read", ld)
	} else {
		fc.ins("move %s, %s.read", pv, ld)
	}
	fc.stubBody(ld, "move @0, %s", dst)
	return nil
}

func (fc *funcCtx) storeWordAt(p *llir.Value, off uint32, src string) error {
	if addr, ok := fc.directAddr(p); ok {
		if off != 0 {
			addr = fmt.Sprintf("%s+%d", addr, off)
		}
		fc.ins("move %s, %s", src, addr)
		return nil
	}
	pv, err := fc.op(p)
	if err != nil {
		return err
	}
	st := fc.stub("Sw")
	if off != 0 {
		fc.ins("add %s, $%d, at2", pv, off)
		fc.ins("move at2, %s.write", st)
	} else {
		fc.ins("move %s, %s.write", pv, st)
	}
	fc.stubBody(st, "move %s, @0", src)
	return nil
}

// storeWordTo writes the value operand `src` through pointer value p.
func (fc *funcCtx) storeWordTo(p *llir.Value, src string) error {
	if addr, ok := fc.directAddr(p); ok {
		fc.ins("move %s, %s", src, addr)
		return nil
	}
	pv, err := fc.op(p)
	if err != nil {
		return err
	}
	st := fc.stub("Sv")
	fc.ins("move %s, %s.write", pv, st)
	fc.stubBody(st, "move %s, @0", src)
	return nil
}

// loadWordFrom reads a word through pointer value p into dst.
func (fc *funcCtx) loadWordFrom(p *llir.Value, dst string) error {
	if addr, ok := fc.directAddr(p); ok {
		fc.ins("move %s, %s", addr, dst)
		return nil
	}
	pv, err := fc.op(p)
	if err != nil {
		return err
	}
	ld := fc.stub("Lv")
	fc.ins("move %s, %s.read", pv, ld)
	fc.stubBody(ld, "move @0, %s", dst)
	return nil
}

func (fc *funcCtx) emitIntrinsic(ins *llir.Instr) error {
	name := ins.Callee
	base := name
	if i := strings.Index(name[5:], "."); i >= 0 {
		base = name[:5+i]
	}
	switch base {
	case "llvm.va_start":
		if !fc.f.Variadic {
			return fmt.Errorf("va_start outside a variadic function")
		}
		return fc.storeWordTo(ins.Args[0], "$"+fc.vaArea())
	case "llvm.va_end":
		return nil
	case "llvm.va_copy": // *dst = *src, one pointer word
		if err := fc.loadWordFrom(ins.Args[1], "sc2"); err != nil {
			return err
		}
		return fc.storeWordTo(ins.Args[0], "sc2")
	case "llvm.memcpy":
		return fc.emitMemRT("memcpy", ins.Args[0], ins.Args[1], ins.Args[2])
	case "llvm.memset":
		return fc.emitMemRT("memset", ins.Args[0], ins.Args[1], ins.Args[2])
	case "llvm.ptrmask": // pointer & mask
		a, err := fc.op(ins.Args[0])
		if err != nil {
			return err
		}
		b, err := fc.op(ins.Args[1])
		if err != nil {
			return err
		}
		fc.ins("and %s, %s, %s", a, b, fc.word(ins.Res))
		return nil
	case "llvm.expect":
		return fc.forward(ins.Res, ins.Args[0])
	case "llvm.abs":
		v, err := fc.op(ins.Args[0])
		if err != nil {
			return err
		}
		res := fc.word(ins.Res)
		neg, pos := fc.stub("An"), fc.stub("Aj")
		fc.ins("move %s, %s", v, res)
		fc.ins("jsign %s, %s, %s", res, neg, pos)
		fc.label(neg)
		fc.ins("sub zero, %s, %s", res, res)
		fc.label(pos)
		return nil
	case "llvm.smax", "llvm.smin", "llvm.umax", "llvm.umin":
		a, err := fc.op(ins.Args[0])
		if err != nil {
			return err
		}
		b, err := fc.op(ins.Args[1])
		if err != nil {
			return err
		}
		res := fc.word(ins.Res)
		lt, ge, j := fc.stub("Mlt"), fc.stub("Mge"), fc.stub("Mj")
		cmp := "jlt"
		if base == "llvm.umax" || base == "llvm.umin" {
			cmp = "jltu"
		}
		fc.ins("%s %s, %s, %s, %s", cmp, a, b, lt, ge)
		aWins := base == "llvm.smin" || base == "llvm.umin" // a<b: min picks a
		fc.label(lt)
		if aWins {
			fc.ins("move %s, %s", a, res)
		} else {
			fc.ins("move %s, %s", b, res)
		}
		fc.ins("jump %s", j)
		fc.label(ge)
		if aWins {
			fc.ins("move %s, %s", b, res)
		} else {
			fc.ins("move %s, %s", a, res)
		}
		fc.label(j)
		return nil
	case "llvm.usub":
		// usub.sat(a, b): a - b clamped at 0, i.e. 0 when a < b.
		// (usub.with.overflow stays unsupported and falls through.)
		if !strings.HasPrefix(name, "llvm.usub.sat") {
			break
		}
		a, err := fc.op(ins.Args[0])
		if err != nil {
			return err
		}
		b, err := fc.op(ins.Args[1])
		if err != nil {
			return err
		}
		res := fc.word(ins.Res)
		lt, ge, j := fc.stub("Ult"), fc.stub("Uge"), fc.stub("Uj")
		fc.ins("jltu %s, %s, %s, %s", a, b, lt, ge)
		fc.label(lt)
		fc.ins("move $0, %s", res)
		fc.ins("jump %s", j)
		fc.label(ge)
		fc.ins("sub %s, %s, %s", a, b, res)
		fc.label(j)
		return nil
	}
	return fmt.Errorf("unsupported intrinsic %q", name)
}

// staticAddr resolves a pointer to a link-time address operand and
// reports its alignment: every dmacc data label is word-aligned (words,
// .space multiples of 4 and word-rounded globals), so only the folded
// byte offset can misalign one. MMIO names and absolute addresses are
// not offsettable and never qualify.
func (fc *funcCtx) staticAddr(p *llir.Value) (sym string, off uint32, ok bool) {
	a, ok := fc.directAddr(p)
	if !ok || a == "" || a[0] == '%' || a[0] == '@' {
		return "", 0, false
	}
	if i := strings.IndexByte(a, '+'); i >= 0 {
		v, err := strconv.ParseUint(a[i+1:], 0, 32)
		if err != nil {
			return "", 0, false
		}
		return a[:i], uint32(v), true
	}
	return a, 0, true
}

// atOff renders "sym+off", dropping a zero offset.
func atOff(sym string, off uint32) string {
	if off == 0 {
		return sym
	}
	return fmt.Sprintf("%s+%d", sym, off)
}

// emitMemInline lowers a memcpy/memset whose length is a compile-time
// constant and whose addresses are link-time known into INCR records at
// the call site: no argument moves, no call, and — when both ends are
// word-aligned — one transfer per WORD plus a byte tail. Nothing is
// patched, so the records are as happy in flash text as in RAM.
// Reports whether it handled the call.
func (fc *funcCtx) emitMemInline(rt string, dst, src, n *llir.Value) (bool, error) {
	// A count wide enough to reach TRANS_COUNT's MODE field (RP2350's
	// top nibble) is not a length any real call has; leave it to the
	// runtime rather than encode a mode by accident.
	if n.Kind != llir.VConst || n.Int < 0 || n.Int >= 1<<28 {
		return false, nil
	}
	nb := uint32(n.Int)
	dsym, doff, ok := fc.staticAddr(dst)
	if !ok {
		return false, nil
	}
	var ssym string
	var soff uint32
	value := ""
	if rt == "memcpy" {
		if ssym, soff, ok = fc.staticAddr(src); !ok {
			return false, nil
		}
	} else if src.Kind == llir.VConst {
		// A constant fill byte splats into a word: the read address
		// stays put, so all four lanes must carry it.
		b := uint32(src.Int) & 0xFF
		value = fmt.Sprintf("$0x%x", b*0x01010101)
	}
	if nb == 0 {
		return true, nil // silicon NOPs a zero count; skip the record too
	}
	words := uint32(0)
	if doff%4 == 0 && (rt == "memset" && value != "" || rt == "memcpy" && soff%4 == 0) {
		words = nb / 4
	}
	if words > 0 {
		if rt == "memcpy" {
			fc.ins("move %s, %s, incrr, incrw, wcount=%d", atOff(ssym, soff), atOff(dsym, doff), words)
		} else {
			fc.ins("move %s, %s, incrw, wcount=%d", value, atOff(dsym, doff), words)
		}
	}
	if tail := nb - 4*words; tail > 0 {
		to := doff + 4*words
		if rt == "memcpy" {
			fc.ins("move %s, %s, size8, incrr, incrw, count=%d",
				atOff(ssym, soff+4*words), atOff(dsym, to), tail)
		} else {
			v := value
			if v == "" {
				sv, err := fc.op(src)
				if err != nil {
					return false, err
				}
				v = sv // a value word: size8 reads its low byte
			}
			fc.ins("move %s, %s, size8, incrw, count=%d", v, atOff(dsym, to), tail)
		}
	}
	return true, nil
}

func (fc *funcCtx) emitMemRT(rt string, dst, src, n *llir.Value) error {
	if done, err := fc.emitMemInline(rt, dst, src, n); done || err != nil {
		return err
	}
	dv, err := fc.op(dst)
	if err != nil {
		return err
	}
	sv, err := fc.op(src)
	if err != nil {
		return err
	}
	nv, err := fc.op(n)
	if err != nil {
		return err
	}
	fc.hasCalls = true
	fc.ins("move %s, %s", dv, fc.rtReg("r0"))
	fc.ins("move %s, %s", sv, fc.rtReg("r1"))
	fc.ins("move %s, %s", nv, fc.rtReg("r2"))
	fc.rtCall(rt)
	return nil
}

// --- Recursion frame stack (see gen.computeRecursion) ---
//
// A recSet function keeps ONE copy of its code; each activation saves
// the whole frame to the software stack on entry and restores it on
// return. Layout per push: [frame bytes][frame base][frame size], with
// g___dmacc_fsp past the record.
//
// NOTHING READS THE TRAILER. It was laid down for an unwinder
// (`__dmacc_funwind`) that was never built and does not exist anywhere
// in the tree: the stack is only ever pushed and popped in lockstep by
// the code that owns it, and a process that dies mid-flight abandons
// its pushes instead of unwinding them (computeRecursion's accepted
// leak). Deleting it was tried and measured under prompts/042 §6 — it
// gives back 7 records and 8 bytes per push, but the text it shifts
// costs 3.4% on the warm `echo hi` bench (TestZZBenchXsh), a scheduling
// and encoding-layout effect rather than extra work. Hot-path cycles
// outrank those bytes, so it stays until someone re-measures it
// deliberately; anyone deleting it owes that benchmark a re-run.
//
// Entry runs BEFORE lr/args are stored: they arrive in the machine
// cells (lr, r0..r3) and land in the fresh frame once the save is out
// of the way. Nothing in between touches them — the overflow compare
// works out of the cw_* cells and at/at2, and the save is an inline
// burst rather than a call — so they need no parking.
//
// The frame move itself is an inline patched burst: its length is a
// link-time constant, so the record carries a static word count
// (@FRW_) and moves the frame a word at a time wherever the encoding
// has an incrementing 32-bit channel.
func (fc *funcCtx) emitFramePush() {
	f := fc.f
	sz := "$@FR_" + sanitize(f.Name) + "@"
	rec := "$@FRH_" + sanitize(f.Name) + "@" // size + 8-byte trailer
	frame := "$fr_" + sanitize(f.Name)
	// Overflow: new sp past the stack end diverts to the sink.
	fc.ins("add g___dmacc_fsp, %s, sc2", rec)
	fc.emitStackCheck("sc2")
	// Save the live frame.
	fc.frameBurst("Fsv", "g___dmacc_fsp", frame)
	// The trailer (see above), then commit the new sp.
	hs := fc.stub("Fha")
	fc.ins("add g___dmacc_fsp, %s, sc2", sz)
	fc.ins("move sc2, %s.write", hs)
	fc.stubBody(hs, "move %s, @0", frame)
	hs2 := fc.stub("Fhb")
	fc.ins("add sc2, $4, sc2")
	fc.ins("move sc2, %s.write", hs2)
	fc.stubBody(hs2, "move %s, @0", sz)
	fc.ins("add sc2, $4, sc2")
	fc.ins("move sc2, g___dmacc_fsp")
	// The fresh activation: linkage and parameters, still in their
	// machine cells.
	fc.ins("move lr, %s", fc.lrsWord())
	for i, p := range f.Params {
		if i < 4 {
			fc.ins("move r%d, %s", i, fc.word(p.Name))
		}
	}
}

// emitStackCheck diverts to the overflow sink when the prospective new
// frame-stack pointer in `sp` has run past the stack's end.
func (fc *funcCtx) emitStackCheck(sp string) {
	ok := fc.stub("Fok")
	fc.emitCmpSite("ltu", fmt.Sprintf("$g___dmacc_fstack+%d", fc.g.frameStackSize()),
		sp, "__fovf", ok)
	fc.label(ok)
}

// frameBurst emits one whole-frame move: patch the record's addresses
// (dst and src read as addresses — a word or an address literal), then
// run it at this function's static word count. The record patches
// itself, so it goes through stubBody: RAM-resident under XIPText.
func (fc *funcCtx) frameBurst(prefix, dst, src string) {
	blk := fc.stub(prefix)
	fc.ins("move %s, %s.write", dst, blk)
	fc.ins("move %s, %s.read", src, blk)
	fc.stubBody(blk, "move @0, @0, incrr, incrw, wcount=@FRW_%s@", sanitize(fc.f.Name))
}

func (fc *funcCtx) emitFramePop(ins *llir.Instr) error {
	f := fc.f
	rec := "$@FRH_" + sanitize(f.Name) + "@"
	frame := "$fr_" + sanitize(f.Name)
	// The result and this activation's lr must survive the restore
	// (both live in the frame about to be overwritten).
	if len(ins.Args) > 0 {
		v, err := fc.op(ins.Args[0])
		if err != nil {
			return err
		}
		fc.ins("move %s, fs_r0", v)
	}
	fc.ins("move %s, fs_lr", fc.lrsWord())
	fc.ins("sub g___dmacc_fsp, %s, sc2", rec)
	fc.ins("move sc2, g___dmacc_fsp")
	fc.frameBurst("Frs", frame, "sc2")
	if len(ins.Args) > 0 {
		fc.ins("move fs_r0, r0")
	}
	fc.ins("move fs_lr, lr")
	fc.ins("ret")
	return nil
}

// --- Branches ---

// phiCopiesFor emits the parallel copies for one edge from -> succ:
// into phi words for direct-mode successors, into shadows otherwise.
// Reports whether the successor has any phis.
func (fc *funcCtx) phiCopiesFor(from *llir.Block, succ string) (bool, error) {
	savedCat := fc.cat
	fc.cat = "phi"
	defer func() { fc.cat = savedCat }()
	idx, ok := fc.blockIdx[succ]
	if !ok {
		return false, fmt.Errorf("branch to unknown block %q", succ)
	}
	dst := fc.shadow
	if fc.directPhi[succ] {
		dst = fc.word
	}
	any := false
	for _, ins := range fc.f.Blocks[idx].Instrs {
		if ins.Op != "phi" {
			continue
		}
		any = true
		for _, e := range ins.Phi {
			if e.Pred == from.Name {
				v, err := fc.op(e.Val)
				if err != nil {
					return false, err
				}
				fc.ins("move %s, %s", v, dst(ins.Res))
			}
		}
	}
	return any, nil
}

// edgePlan routes phi-carrying edges of a multi-way branch. Shadow-mode
// successors take their copies inline before the branch (stray shadow
// writes on the untaken edge are harmless — the head latch only runs on
// entry). Direct-mode successors get a per-edge stub so their phi words
// are written on the taken edge only.
type edgePlan struct {
	from   *llir.Block
	labels map[string]string // succ -> branch target label
	stubs  []string          // direct-mode succs needing a stub, in order
}

func (fc *funcCtx) planEdge(p *edgePlan, succ string) (string, error) {
	if l, ok := p.labels[succ]; ok {
		return l, nil
	}
	idx, ok := fc.blockIdx[succ]
	if !ok {
		return "", fmt.Errorf("branch to unknown block %q", succ)
	}
	hasPhi := false
	for _, ins := range fc.f.Blocks[idx].Instrs {
		if ins.Op == "phi" {
			hasPhi = true
			break
		}
	}
	lbl := fc.blockLabel(succ)
	switch {
	case !hasPhi:
	case !fc.directPhi[succ]:
		if _, err := fc.phiCopiesFor(p.from, succ); err != nil {
			return "", err
		}
	default:
		lbl = fc.stub("Pe")
		p.stubs = append(p.stubs, succ)
		p.labels[succ] = lbl
		return lbl, nil
	}
	p.labels[succ] = lbl
	return lbl, nil
}

func (fc *funcCtx) flushEdgeStubs(p *edgePlan) error {
	for _, succ := range p.stubs {
		fc.label(p.labels[succ])
		if _, err := fc.phiCopiesFor(p.from, succ); err != nil {
			return err
		}
		fc.cat = "phi"
		fc.ins("jump %s", fc.blockLabel(succ))
	}
	return nil
}

// backward reports whether any target is a backedge: a branch to a
// block at or before this one in the function's IR block order.
//
// IR order, never placed order. blockIdx and curBlock are both IR
// indices, and emit runs this decision inside its IR-order lowering
// pass, so the safepoint set a function carries is the same whatever
// Options.ColdBlocks says about its blocks. Deciding it on placed
// position instead would let a sunk loop header turn its backedge
// lexically forward and silently drop the safepoint — unbounded
// interrupt latency, and nothing but TestColdBlockSafepoint to notice.
func (fc *funcCtx) backward(targets ...string) bool {
	for _, t := range targets {
		if idx, ok := fc.blockIdx[t]; ok && idx <= fc.curBlock {
			return true
		}
	}
	return false
}

func (fc *funcCtx) maybeSafepoint(targets ...string) {
	if !fc.g.opts.NoSafepoints && fc.backward(targets...) {
		fc.ins("safepoint")
	}
}

func (fc *funcCtx) emitBr(b *llir.Block, ins *llir.Instr) error {
	if len(ins.Labels) == 1 {
		// Single successor: copies go inline regardless of mode.
		if _, err := fc.phiCopiesFor(b, ins.Labels[0]); err != nil {
			return err
		}
		fc.maybeSafepoint(ins.Labels[0])
		fc.ins("jump %s", fc.blockLabel(ins.Labels[0]))
		return nil
	}
	tl, fl := ins.Labels[0], ins.Labels[1]
	fc.maybeSafepoint(tl, fl)
	cond := ins.Args[0]
	if cond.Kind == llir.VConst {
		tgt := fl
		if cond.Int != 0 {
			tgt = tl
		}
		if _, err := fc.phiCopiesFor(b, tgt); err != nil {
			return err
		}
		fc.ins("jump %s", fc.blockLabel(tgt))
		return nil
	}
	p := &edgePlan{from: b, labels: map[string]string{}}
	tLbl, err := fc.planEdge(p, tl)
	if err != nil {
		return err
	}
	fLbl, err := fc.planEdge(p, fl)
	if err != nil {
		return err
	}
	if d := fc.defs[cond.Name]; d != nil && fc.fused[cond.Name] {
		if err := fc.emitCompareBranch(d, tLbl, fLbl); err != nil {
			return err
		}
		return fc.flushEdgeStubs(p)
	}
	if err := fc.emitBoolBranch(cond, tLbl, fLbl); err != nil {
		return err
	}
	return fc.flushEdgeStubs(p)
}

func (fc *funcCtx) emitSwitch(b *llir.Block, ins *llir.Instr) error {
	succs := []string{ins.Labels[0]}
	for _, c := range ins.Cases {
		succs = append(succs, c.Label)
	}
	fc.maybeSafepoint(succs...)
	v, err := fc.op(ins.Args[0])
	if err != nil {
		return err
	}
	// Canonicalize case values to the scrutinee's width — the same
	// rule op() applies to constant operands. A `switch i8` carries
	// sign-extended case values (i8 -2 parses as 0x...FFFE) while the
	// operand word holds the zero-extended truncation (0x000000FE):
	// unmasked, the compare can never match. Found on silicon as the
	// SD driver's data token (0xFE) sailing straight through its
	// dispatch — the emulator agreed the moment it ran the real path.
	cases := make([]llir.SwitchCase, len(ins.Cases))
	copy(cases, ins.Cases)
	if t := ins.Args[0].Typ; t != nil && t.Kind == llir.TInt && t.Bits < 32 {
		mask := uint64(1)<<uint(t.Bits) - 1
		for i := range cases {
			cases[i].Val &= mask
		}
	}
	ins = &llir.Instr{Op: ins.Op, Res: ins.Res, Typ: ins.Typ, Args: ins.Args,
		Labels: ins.Labels, Cases: cases, Phi: ins.Phi}
	p := &edgePlan{from: b, labels: map[string]string{}}
	def, err := fc.planEdge(p, ins.Labels[0])
	if err != nil {
		return err
	}
	caseLbl := make([]string, len(ins.Cases))
	for i, c := range ins.Cases {
		if caseLbl[i], err = fc.planEdge(p, c.Label); err != nil {
			return err
		}
	}

	// Dense value sets dispatch through a jump table: bounds-check,
	// scale by the instruction size (one jump per slot), add the table
	// base, jump.
	minV, maxV := uint32(ins.Cases[0].Val), uint32(ins.Cases[0].Val)
	for _, c := range ins.Cases {
		if uint32(c.Val) < minV {
			minV = uint32(c.Val)
		}
		if uint32(c.Val) > maxV {
			maxV = uint32(c.Val)
		}
	}
	span := int(maxV-minV) + 1
	if len(ins.Cases) >= 4 && span <= 2*len(ins.Cases)+8 && !fc.g.opts.InlineCompares {
		idx := v
		if minV != 0 {
			fc.ins("sub %s, $0x%x, sc0", v, minV)
			idx = "sc0"
		}
		in, tbl := fc.stub("Swi"), fc.stub("Swt")
		fc.emitCmpSite("ltu", idx, fmt.Sprintf("$0x%x", uint32(span)), in, def)
		fc.label(in)
		// The slot scale is the encoding's instruction size: 16-byte
		// blocks classic, 8-byte records compact.
		fc.ins(".ifcompact")
		fc.ins("mulc %s, 8, sc1", idx)
		fc.ins(".else")
		fc.ins("mulc %s, 16, sc1", idx)
		fc.ins(".endif")
		fc.ins("add sc1, $%s, sc1", tbl)
		fc.ins("jumpr sc1")
		fc.label(tbl)
		slots := make([]string, span)
		for i := range slots {
			slots[i] = def
		}
		for i, c := range ins.Cases {
			slots[uint32(c.Val)-minV] = caseLbl[i]
		}
		for _, s := range slots {
			fc.ins("jump %s", s)
		}
		return fc.flushEdgeStubs(p)
	}

	for i, c := range ins.Cases {
		next := fc.stub("Sw")
		if fc.g.opts.InlineCompares {
			fc.ins("jeq %s, $0x%x, %s, %s", v, uint32(c.Val), caseLbl[i], next)
		} else {
			fc.emitCmpSite("eq", v, fmt.Sprintf("$0x%x", uint32(c.Val)), caseLbl[i], next)
		}
		fc.label(next)
	}
	fc.ins("jump %s", def)
	return fc.flushEdgeStubs(p)
}
