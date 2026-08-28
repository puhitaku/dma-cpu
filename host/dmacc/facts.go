package dmacc

import (
	"math/bits"

	"github.com/puhitaku/dma-cpu/host/llir"
)

// Value facts: a proven upper bound on the machine WORD of every SSA
// value of one function, read by the comparison lowering (compare.go)
// to pick a cheaper helper.
//
// One lattice element is one uint32 — "this word is <= max" — ordered
// by <=, with 0xFFFFFFFF (nothing known) at the top. Two thresholds
// carry names, because they are what the lowering asks about:
//
//	factNonNeg — max <= 0x7FFFFFFF: bit 31 is provably clear.
//	factBool   — max <= 1: the word is provably 0 or 1 (implies nonneg).
//
// The bounds describe the word dmacc stores, not the abstract C value.
// A narrow (i1/i8/i16) value lives zero-extended in its word — the
// invariant every lowering maintains (maskTo after add/sub/mul/shift,
// size8/size16 loads, andn on trunc, width-canonicalized constants in
// op()) — so a value of a narrow integer type is bounded by its
// STORAGE width, rounded up to whole bytes: an i1 word is whatever byte
// a size8 load found, so its type alone bounds it by 255 and never by
// 1. factBool is therefore only ever granted by an op that provably
// writes a 0 or a 1. The sign-extended operands a signed sub-word
// compare builds are covered by nothing here: sextInto writes a
// full-range word, and the site drops the facts.
//
// Two kinds of bound feed the analysis:
//
//   - Value bounds (factSet.max), one per SSA name, valid wherever the
//     value is live. A value's bound is derived at its definition, so it
//     may use anything that holds in the defining block.
//   - Block bounds (factSet.blk), one map per block, holding the
//     narrowings a dominating branch proves. On the true edge of
//     `icmp ult x, n` with n nonneg, x < n <= 2^31-1, so x <= 2^31-2 in
//     every block that edge dominates. compare.go asks for the bound AT
//     its site (factSet.at), so a site inside such a region sees it.
//
// Together they close the counter induction of an UNSIGNED loop with no
// optimistic assumption at all: in `for (i = 0; i < n; i++)` compared
// with `ult` and n bounded, the body edge bounds i by n-1, so the
// latch's `i + 1` is bounded by n, so the header phi — the meet of 0
// with that add — is bounded, and the guard itself routes to __cw_ltp.
// The chain never reads i's own bound to prove i's bound: the body edge
// bounds i out of n alone.
//
// A SIGNED counter does not close, and cannot here. `slt i, n` bounds
// i's WORD only once i is already known nonneg — a negative word passes
// it too — so the derivation would have to assume what it proves. An
// assume-and-verify round for that shape was built and measured on the
// kernel and the game (prompts/042 §10): it discharges the assumption
// on 36 and 20 counters respectively and moves exactly one comparison
// site, because a signed loop's BOUND is an i32 parameter or load that
// nothing local bounds, and `slt a, b` needs both sides nonneg. It is
// not here.
//
// Soundness: the fixed point starts at the TOP (0xFFFFFFFF everywhere,
// nothing known) and only tightens. Every rule states a bound implied
// by the CURRENT bounds of its inputs, so every intermediate state is
// already sound and the iteration cap below cannot mint a wrong fact —
// it can only stop early with a looser one. Where a rule is unclear the
// value keeps the top bound and the site keeps the general helper.
const (
	factNonNeg uint8 = 1 << iota
	factBool
)

const factAll = factNonNeg | factBool

// maxUnknown is the lattice top: every 32-bit word satisfies it.
const maxUnknown uint32 = 0xFFFFFFFF

// maxNonNeg is the largest word with bit 31 clear.
const maxNonNeg uint32 = 0x7FFFFFFF

// factsPasses caps the value/edge iteration. Convergence is fast (the
// pessimistic start means a phi cycle settles on its loosest incoming
// in one sweep); the cap only bounds pathological input.
const factsPasses = 8

// factsOfMax names the thresholds of a bound.
func factsOfMax(m uint32) uint8 {
	switch {
	case m <= 1:
		return factAll
	case m <= maxNonNeg:
		return factNonNeg
	}
	return 0
}

// factSet holds the derived bounds of one function's local values.
type factSet struct {
	max map[string]uint32   // per-value bound, valid wherever the value is live
	blk []map[string]uint32 // per-block bounds proven by dominating branches
}

// typeMax is the bound a value's type alone grants: a narrow integer
// lives zero-extended in its word at its STORAGE width, so an i1 or an
// i8 is bounded by 255 and an i16 by 65535. Rounding up to whole bytes
// is what makes a `load i1` safe — the load moves a byte and the word
// keeps every bit of it.
func typeMax(t *llir.Type) uint32 {
	if t == nil || t.Kind != llir.TInt || t.Bits < 1 || t.Bits >= 32 {
		return maxUnknown
	}
	b := (t.Bits + 7) &^ 7
	if b >= 32 {
		return maxUnknown
	}
	return 1<<uint(b) - 1
}

// resTypeMax is typeMax of an instruction's RESULT. Instr.Typ means the
// result type for most ops but the operand type for icmp, the element
// type for getelementptr/alloca (whose results are pointers, and a
// pointer into the SIO/MMIO aperture has bit 31 set), and the aggregate
// type for insert/extractvalue. The word-forwarding casts are excluded
// too: they move the source word unchanged, so a `ptrtoint ptr to i8`
// result is a full pointer however its type reads.
func resTypeMax(ins *llir.Instr) uint32 {
	switch ins.Op {
	case "icmp", "getelementptr", "alloca", "insertvalue", "extractvalue",
		"zext", "bitcast", "ptrtoint", "inttoptr", "freeze":
		return maxUnknown
	}
	return typeMax(ins.Typ)
}

// constMax is the word a constant operand renders to. Constants render
// at the operand's width (op()), so an i8 -1 is the word 0x000000FF,
// not 0xFFFFFFFF.
func constMax(v *llir.Value) uint32 {
	c := uint32(v.Int)
	if v.Typ != nil && v.Typ.Kind == llir.TInt && v.Typ.Bits >= 1 && v.Typ.Bits < 32 {
		c &= 1<<uint(v.Typ.Bits) - 1
	}
	return c
}

// boundAt returns the bound of an operand as seen from block bi.
func (fs factSet) boundAt(bi int, v *llir.Value) uint32 {
	if v == nil {
		return maxUnknown
	}
	switch v.Kind {
	case llir.VConst:
		return constMax(v)
	case llir.VLocal:
		m := typeMax(v.Typ)
		if b, ok := fs.max[v.Name]; ok && b < m {
			m = b
		}
		if bi >= 0 && bi < len(fs.blk) {
			if b, ok := fs.blk[bi][v.Name]; ok && b < m {
				m = b
			}
		}
		return m
	}
	return maxUnknown
}

// at returns the named facts of an operand as seen from block bi — the
// form the comparison sites use, so a branch-narrowed operand routes to
// the restricted-range helper.
func (fs factSet) at(bi int, v *llir.Value) uint8 { return factsOfMax(fs.boundAt(bi, v)) }

// maskUp rounds a bound up to the all-ones mask of its bit length: if
// a <= A and b <= B then a|b (and a^b) is <= maskUp(A|B), because every
// bit either operand can set lies inside that mask.
func maskUp(v uint32) uint32 {
	n := bits.Len32(v)
	if n >= 32 {
		return maxUnknown
	}
	return 1<<uint(n) - 1
}

// addMax, mulMax, shlMax saturate to the top on overflow.
func addMax(a, b uint32) uint32 {
	s := uint64(a) + uint64(b)
	if s > uint64(maxUnknown) {
		return maxUnknown
	}
	return uint32(s)
}

func mulMax(a, b uint32) uint32 {
	p := uint64(a) * uint64(b)
	if p > uint64(maxUnknown) {
		return maxUnknown
	}
	return uint32(p)
}

func shlMax(a uint32, s uint32) uint32 {
	if s >= 32 {
		return maxUnknown
	}
	return shiftMax(uint64(a) << s)
}

func shiftMax(v uint64) uint32 {
	if v > uint64(maxUnknown) {
		return maxUnknown
	}
	return uint32(v)
}

// constShift returns a shift/divide operand's constant value.
func constShift(v *llir.Value) (uint32, bool) {
	if v == nil || v.Kind != llir.VConst {
		return 0, false
	}
	return constMax(v), true
}

// --- CFG and dominators -----------------------------------------------

// funcCFG is the block graph of one function plus its dominator tree.
type funcCFG struct {
	idx   map[string]int
	preds [][]int
	succs [][]int
	idom  []int // immediate dominator, -1 for the entry and for unreachable blocks
	rpo   []int // reachable blocks in reverse postorder (idom of a block precedes it)
	rpoNo []int // block -> position in rpo, -1 if unreachable
}

// succsOf lists the successor block names of a terminator.
func succsOf(term *llir.Instr) []string {
	switch term.Op {
	case "br":
		return term.Labels
	case "switch":
		out := append([]string{}, term.Labels...)
		for _, c := range term.Cases {
			out = append(out, c.Label)
		}
		return out
	}
	return nil
}

func newFuncCFG(f *llir.Func) *funcCFG {
	n := len(f.Blocks)
	c := &funcCFG{idx: make(map[string]int, n), preds: make([][]int, n),
		succs: make([][]int, n), idom: make([]int, n), rpoNo: make([]int, n)}
	for i, b := range f.Blocks {
		c.idx[b.Name] = i
	}
	for i, b := range f.Blocks {
		c.idom[i], c.rpoNo[i] = -1, -1
		if len(b.Instrs) == 0 {
			continue
		}
		for _, s := range succsOf(b.Instrs[len(b.Instrs)-1]) {
			if j, ok := c.idx[s]; ok {
				c.succs[i] = append(c.succs[i], j)
				c.preds[j] = append(c.preds[j], i)
			}
		}
	}
	if n == 0 {
		return c
	}
	// Postorder DFS from the entry, then reverse.
	var post []int
	seen := make([]bool, n)
	type frame struct{ b, k int }
	stack := []frame{{0, 0}}
	seen[0] = true
	for len(stack) > 0 {
		fr := &stack[len(stack)-1]
		if fr.k < len(c.succs[fr.b]) {
			s := c.succs[fr.b][fr.k]
			fr.k++
			if !seen[s] {
				seen[s] = true
				stack = append(stack, frame{s, 0})
			}
			continue
		}
		post = append(post, fr.b)
		stack = stack[:len(stack)-1]
	}
	for i := len(post) - 1; i >= 0; i-- {
		c.rpoNo[post[i]] = len(c.rpo)
		c.rpo = append(c.rpo, post[i])
	}
	// Cooper/Harvey/Kennedy iterative dominators.
	c.idom[0] = 0
	for changed := true; changed; {
		changed = false
		for _, b := range c.rpo[1:] {
			nd := -1
			for _, p := range c.preds[b] {
				if c.rpoNo[p] < 0 || c.idom[p] < 0 {
					continue // unreachable, or not processed yet
				}
				if nd < 0 {
					nd = p
					continue
				}
				nd = c.intersect(nd, p)
			}
			if nd >= 0 && c.idom[b] != nd {
				c.idom[b] = nd
				changed = true
			}
		}
	}
	c.idom[0] = -1
	return c
}

func (c *funcCFG) intersect(a, b int) int {
	for a != b {
		for c.rpoNo[a] > c.rpoNo[b] {
			a = c.idom[a]
		}
		for c.rpoNo[b] > c.rpoNo[a] {
			b = c.idom[b]
		}
	}
	return a
}

// --- Edge narrowing ----------------------------------------------------

// negPred is the predicate that holds on a branch's false edge.
var negPred = map[string]string{
	"eq": "ne", "ne": "eq",
	"ult": "uge", "uge": "ult", "ule": "ugt", "ugt": "ule",
	"slt": "sge", "sge": "slt", "sle": "sgt", "sgt": "sle",
}

// edgeBounds returns the bounds on x and y that hold where `icmp pred
// x, y` is TRUE, given the bounds bx and by that hold at the compare.
// Only 32-bit operands reach here (narrowEdges filters), so a constant
// operand's word is its two's-complement image and int32(word) is its
// signed value.
//
// The proofs, all on 32-bit words:
//
//	eq        the two words are equal, so each is bounded by the other.
//	ult x,y   x <u y <= by, hence x <= by-1 (by > 0, else the edge is
//	          unreachable and any bound holds vacuously).
//	ule x,y   x <=u y <= by.
//	ugt/uge   the same, with the operands swapped.
//	slt x,y   if x's word is nonneg then int32(x) = x >= 0 and int32(y)
//	          > x >= 0, so y's word is nonneg too. If BOTH words are
//	          nonneg then the compare is the unsigned one, so x <= y-1
//	          — and y's bound may be the one just derived, since both
//	          conclusions hold at the same place on the same edge.
//	sle x,y   likewise with x <= y.
//	sgt/sge   the same, with the operands swapped.
//	slt/sle   against a constant c: c >= -1 (resp. c >= 0) forces the
//	          other side nonneg (it is > c >= -1, resp. >= c >= 0) —
//	          the `x >= 0` and `x > -1` guards, whose negative constant
//	          no upper bound can express.
func edgeBounds(pred string, x, y *llir.Value, bx, by uint32) (uint32, uint32) {
	mx, my := maxUnknown, maxUnknown
	// atLeast reports whether an operand is >= lo as a SIGNED value,
	// either because its word is nonneg (lo is never below -1 here) or
	// because it is a constant at or above the threshold.
	atLeast := func(v *llir.Value, b uint32, lo int32) bool {
		if b <= maxNonNeg {
			return true
		}
		return v != nil && v.Kind == llir.VConst && int32(uint32(v.Int)) >= lo
	}
	switch pred {
	case "eq":
		m := min(bx, by)
		return m, m
	case "ult":
		if by > 0 {
			mx = by - 1
		} else {
			mx = 0
		}
	case "ule":
		mx = by
	case "ugt":
		if bx > 0 {
			my = bx - 1
		} else {
			my = 0
		}
	case "uge":
		my = bx
	case "slt":
		if atLeast(x, bx, -1) {
			my = maxNonNeg
		}
		if e := min(by, my); bx <= maxNonNeg && e <= maxNonNeg {
			if e > 0 {
				mx = e - 1
			} else {
				mx = 0
			}
		}
	case "sle":
		if atLeast(x, bx, 0) {
			my = maxNonNeg
		}
		if e := min(by, my); bx <= maxNonNeg && e <= maxNonNeg {
			mx = e
		}
	case "sgt":
		if atLeast(y, by, -1) {
			mx = maxNonNeg
		}
		if e := min(bx, mx); e <= maxNonNeg && by <= maxNonNeg {
			if e > 0 {
				my = e - 1
			} else {
				my = 0
			}
		}
	case "sge":
		if atLeast(y, by, 0) {
			mx = maxNonNeg
		}
		if e := min(bx, mx); e <= maxNonNeg && by <= maxNonNeg {
			my = e
		}
	}
	return mx, my
}

// putBound records a tightened bound for an operand.
func putBound(m map[string]uint32, v *llir.Value, b uint32) {
	if v == nil || v.Kind != llir.VLocal || b >= maxUnknown {
		return
	}
	if old, ok := m[v.Name]; !ok || b < old {
		m[v.Name] = b
	}
}

// condDepth caps the walk through a branch condition's i1 algebra.
const condDepth = 4

// condBounds collects into m what "cond evaluates to `taken`" proves
// about the values it compares, reading operand bounds as of block at.
//
// LLVM writes short-circuit `&&` as `select i1 c, i1 x, i1 false` and
// `||` as `select i1 c, i1 true, i1 y`; the non-short-circuit forms are
// `and`/`or` on i1 and a logical NOT is `xor i1 v, true`. A conjunction
// taken TRUE proves both halves; a disjunction taken FALSE proves both
// halves false. The other direction proves nothing — either half may
// have decided the result — and is deliberately absent.
func (fs *factSet) condBounds(m map[string]uint32, cond *llir.Value, taken bool,
	at int, defs map[string]*llir.Instr, depth int) {
	if depth <= 0 || cond == nil || cond.Kind != llir.VLocal {
		return
	}
	d := defs[cond.Name]
	if d == nil {
		return
	}
	isTrue := func(v *llir.Value) bool {
		return v != nil && v.Kind == llir.VConst && uint32(v.Int)&1 == 1
	}
	isFalse := func(v *llir.Value) bool {
		return v != nil && v.Kind == llir.VConst && uint32(v.Int) == 0
	}
	switch d.Op {
	case "icmp":
		if !cmpWord32(d.Typ) {
			return
		}
		pred := d.Pred
		if !taken {
			pred = negPred[pred]
		}
		x, y := d.Args[0], d.Args[1]
		mx, my := edgeBounds(pred, x, y, fs.boundAt(at, x), fs.boundAt(at, y))
		putBound(m, x, mx)
		putBound(m, y, my)
	case "select":
		switch {
		case taken && isFalse(d.Args[2]): // c && x
			fs.condBounds(m, d.Args[0], true, at, defs, depth-1)
			fs.condBounds(m, d.Args[1], true, at, defs, depth-1)
		case !taken && isTrue(d.Args[1]): // c || y
			fs.condBounds(m, d.Args[0], false, at, defs, depth-1)
			fs.condBounds(m, d.Args[2], false, at, defs, depth-1)
		}
	case "and":
		if taken {
			fs.condBounds(m, d.Args[0], true, at, defs, depth-1)
			fs.condBounds(m, d.Args[1], true, at, defs, depth-1)
		}
	case "or":
		if !taken {
			fs.condBounds(m, d.Args[0], false, at, defs, depth-1)
			fs.condBounds(m, d.Args[1], false, at, defs, depth-1)
		}
	case "xor":
		// The i1 NOT: one operand is the constant 1.
		if isTrue(d.Args[1]) {
			fs.condBounds(m, d.Args[0], !taken, at, defs, depth-1)
		} else if isTrue(d.Args[0]) {
			fs.condBounds(m, d.Args[1], !taken, at, defs, depth-1)
		}
	case "zext", "freeze", "bitcast":
		// Same word, same truth value.
		fs.condBounds(m, d.Args[0], taken, at, defs, depth-1)
	}
}

// edgeNarrow returns what taking the edge from block p to block h
// proves, over and above what already holds throughout p.
func (fs *factSet) edgeNarrow(f *llir.Func, p, h int, defs map[string]*llir.Instr) map[string]uint32 {
	m := map[string]uint32{}
	pb := f.Blocks[p]
	if len(pb.Instrs) == 0 {
		return m
	}
	term := pb.Instrs[len(pb.Instrs)-1]
	name := f.Blocks[h].Name
	switch {
	case term.Op == "br" && len(term.Labels) == 2 && term.Labels[0] != term.Labels[1]:
		fs.condBounds(m, term.Args[0], term.Labels[0] == name, p, defs, condDepth)
	case term.Op == "switch":
		// Every case edge into h pins the switched value to its case
		// constant; the bound is the largest of them. The default edge
		// proves nothing, and neither does a block that is both.
		if term.Labels[0] == name {
			return m
		}
		best, any := uint32(0), false
		for _, cs := range term.Cases {
			if cs.Label != name {
				continue
			}
			any = true
			if w := uint32(cs.Val); w > best {
				best = w
			}
		}
		if any {
			putBound(m, term.Args[0], best)
		}
	}
	return m
}

// narrowEdges recomputes the per-block bounds: every block inherits its
// immediate dominator's, and a block whose ONLY predecessor is that
// dominator also gets what the edge from it proves. Sole predecessorship
// is what makes the edge (and not merely the branch) dominating: every
// path to the block ends with that edge, so its condition held.
//
// Inheriting down the dominator tree is sound even around a loop, where
// the narrowed value is a phi that takes a new value each iteration.
// Let b hold the narrowing, d be dominated by b, and R define the
// narrowed value (R dominates b, since the guard uses the value). Every
// path R -> d runs through b: otherwise the FIRST arrival at R — which
// cannot have passed b, because b needs R first — extended by that path
// would be an entry -> d path avoiding b, and b dominates d. So no
// redefinition can slip between b and d, and the bound b proved is a
// bound on the value d sees.
func (fs *factSet) narrowEdges(f *llir.Func, c *funcCFG, defs map[string]*llir.Instr) bool {
	changed := false
	for _, bi := range c.rpo {
		m := map[string]uint32{}
		if p := c.idom[bi]; p >= 0 {
			for k, v := range fs.blk[p] {
				m[k] = v
			}
			if len(c.preds[bi]) == 1 && c.preds[bi][0] == p {
				for k, v := range fs.edgeNarrow(f, p, bi, defs) {
					if old, ok := m[k]; !ok || v < old {
						m[k] = v
					}
				}
			}
		}
		if !sameBounds(fs.blk[bi], m) {
			fs.blk[bi] = m
			changed = true
		}
	}
	return changed
}

// cmpWord32 reports whether an icmp's operands are full 32-bit words.
// Narrower operands are already bounded by their type, and a SIGNED
// narrow compare works on the sign-extended copies the site builds, not
// on the value words an edge fact would name.
func cmpWord32(t *llir.Type) bool {
	if t == nil {
		return false
	}
	return t.Kind == llir.TPtr || (t.Kind == llir.TInt && t.Bits == 32)
}

func sameBounds(a, b map[string]uint32) bool {
	if len(a) != len(b) {
		return false
	}
	for k, v := range a {
		if w, ok := b[k]; !ok || w != v {
			return false
		}
	}
	return true
}

// --- The value rules ---------------------------------------------------

// factsOf derives the value bounds of one function.
func factsOf(f *llir.Func) factSet {
	c := newFuncCFG(f)
	defs := map[string]*llir.Instr{}
	for _, blk := range f.Blocks {
		for _, ins := range blk.Instrs {
			if ins.Res != "" {
				defs[ins.Res] = ins
			}
		}
	}
	fs := factSet{max: map[string]uint32{}, blk: make([]map[string]uint32, len(f.Blocks))}
	for pass := 0; pass < factsPasses; pass++ {
		changed := fs.narrowEdges(f, c, defs)
		if fs.narrowValues(f, c, defs) {
			changed = true
		}
		if !changed {
			break
		}
	}
	return fs
}

// insBound is the bound one non-phi definition's result carries, given
// a reader for its operands. The rules are the arithmetic of unsigned
// upper bounds on 32-bit words; every one saturates to the top rather
// than wrap. Splitting it out lets the same rules re-run against the
// tighter operand bounds an edge proves (edgeBound below).
func (fs *factSet) insBound(ins *llir.Instr, opnd func(*llir.Value) uint32) uint32 {
	b := maxUnknown
	if len(ins.Args) > 0 {
		b = opnd(ins.Args[0])
	}
	k := maxUnknown
	switch ins.Op {
	case "icmp":
		// Materialized as a literal 0 or 1 (func.go).
		k = 1
	case "and":
		// a & b <= min(a, b): AND can only clear bits.
		k = min(b, opnd(ins.Args[1]))
	case "or", "xor":
		k = maskUp(b | opnd(ins.Args[1]))
	case "add":
		k = addMax(b, opnd(ins.Args[1]))
	case "mul":
		k = mulMax(b, opnd(ins.Args[1]))
	case "sub":
		// Only a subtraction of zero cannot borrow.
		if s, ok := constShift(ins.Args[1]); ok && s == 0 {
			k = b
		}
	case "select":
		k = max(opnd(ins.Args[1]), opnd(ins.Args[2]))
	case "zext", "bitcast", "ptrtoint", "inttoptr", "freeze":
		// The same word, forwarded unchanged.
		k = b
	case "trunc":
		// Mirrors the emission: a narrowing trunc masks, a widening or
		// same-width one forwards the word.
		dstW, err := width(ins.To)
		srcW := 32
		if a := ins.Args[0].Typ; a != nil && a.Kind == llir.TInt && a.Bits <= 32 {
			srcW = a.Bits
		}
		switch {
		case err != nil:
			k = maxUnknown
		case dstW >= 32 || srcW <= dstW:
			k = b
		default:
			k = min(b, 1<<uint(dstW)-1)
		}
	case "shl":
		if s, ok := constShift(ins.Args[1]); ok && s < 32 {
			k = shlMax(b, s)
		}
	case "lshr":
		if s, ok := constShift(ins.Args[1]); ok && s < 32 {
			k = b >> s
		}
	case "udiv":
		// A quotient never exceeds its dividend — but only a nonzero
		// divisor is a divide at all; __rt_udivmod's answer for zero is
		// its own business.
		if d, ok := constShift(ins.Args[1]); ok && d > 0 {
			k = b / d
		}
	case "urem":
		if d, ok := constShift(ins.Args[1]); ok && d > 0 {
			k = d - 1
		}
	}
	if t := resTypeMax(ins); t < k {
		k = t
	}
	return k
}

// edgeDepth caps how far edgeBound re-derives a value from the
// operands an edge narrows.
const edgeDepth = 3

// edgeBound is the bound of v where control leaves block p, given what
// that edge proves (e). Beyond looking v up, it RE-DERIVES v's defining
// instruction against the same narrowed operands — which is what closes
// a loop counter whose header is also its latch:
//
//	6: %i = phi [0, %entry], [%next, %6]
//	   %next = add %i, 1
//	   %c = icmp ult %i, 9
//	   br %c, label %6, label %out
//
// Block 6 has two predecessors, so no edge dominates it and %i carries
// no block bound there. But the back edge 6->6 is the true edge of
// `ult %i, 9`, so on it %i <= 8 and re-deriving %next gives %next <= 9.
// The phi meets 0 with 9 and is nonneg, and the guard routes to
// __cw_ltp. The derivation never reads %i's own bound to get there.
//
// Re-derivation is sound wherever the value is: an SSA value is written
// once, so the word the edge constrains is the word the definition
// produced, and re-running the same rule with a tighter (still sound)
// operand bound yields a sound result bound. Phis are not re-derived —
// their inputs belong to other edges.
func (fs *factSet) edgeBound(v *llir.Value, p int, e map[string]uint32,
	defs map[string]*llir.Instr, depth int) uint32 {
	if v == nil {
		return maxUnknown
	}
	if v.Kind == llir.VConst {
		return constMax(v)
	}
	if v.Kind != llir.VLocal {
		return maxUnknown
	}
	b := fs.boundAt(p, v)
	if x, ok := e[v.Name]; ok && x < b {
		b = x
	}
	if depth > 0 {
		if d := defs[v.Name]; d != nil && d.Op != "phi" {
			k := fs.insBound(d, func(a *llir.Value) uint32 {
				return fs.edgeBound(a, p, e, defs, depth-1)
			})
			if k < b {
				b = k
			}
		}
	}
	return b
}

// edgeCache memoizes the per-edge narrowings of one sweep.
type edgeCache map[[2]int]map[string]uint32

// phiBound is the bound a phi's result carries: the meet (here the
// maximum) of every incoming value as seen on ITS OWN edge.
func (fs *factSet) phiBound(f *llir.Func, c *funcCFG, defs map[string]*llir.Instr,
	bi int, ins *llir.Instr, ec edgeCache) uint32 {
	if len(ins.Phi) == 0 {
		return maxUnknown
	}
	k := uint32(0)
	for _, e := range ins.Phi {
		pb, ok := c.idx[e.Pred]
		if !ok {
			return maxUnknown
		}
		key := [2]int{pb, bi}
		en, ok := ec[key]
		if !ok {
			en = fs.edgeNarrow(f, pb, bi, defs)
			ec[key] = en
		}
		k = max(k, fs.edgeBound(e.Val, pb, en, defs, edgeDepth))
	}
	if t := resTypeMax(ins); t < k {
		k = t
	}
	return k
}

// narrowValues sweeps every definition once, bounding its result from
// the bounds its operands carry in the defining block — and a phi's
// from the bounds each incoming value carries on ITS edge.
func (fs *factSet) narrowValues(f *llir.Func, c *funcCFG, defs map[string]*llir.Instr) bool {
	changed := false
	ec := edgeCache{}
	for bi, blk := range f.Blocks {
		for _, ins := range blk.Instrs {
			if ins.Res == "" {
				continue
			}
			var k uint32
			if ins.Op == "phi" {
				k = fs.phiBound(f, c, defs, bi, ins, ec)
			} else {
				k = fs.insBound(ins, func(v *llir.Value) uint32 { return fs.boundAt(bi, v) })
			}
			if old, ok := fs.max[ins.Res]; !ok || k < old {
				fs.max[ins.Res] = k
				changed = true
			}
		}
	}
	return changed
}
