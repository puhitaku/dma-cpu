package dmacc

import (
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/llir"
)

func parseFacts(t *testing.T, body string) factSet {
	t.Helper()
	m, err := llir.Parse("define i32 @f(i32 %n, i8 %c) {\n" + body + "\n}\n")
	if err != nil {
		t.Fatalf("parse: %v", err)
	}
	return factsOf(m.Funcs[0], nil)
}

func wantFact(t *testing.T, fs factSet, name string, want uint8) {
	t.Helper()
	b, ok := fs.max[name]
	if !ok {
		b = maxUnknown
	}
	if got := factsOfMax(b); got != want {
		t.Errorf("%%%s: facts %#b, want %#b", name, got, want)
	}
}

// A phi whose only non-constant input is an unknown i32 must stay
// factless: the fixed point starts empty, so the cycle can never
// bootstrap a fact out of itself.
func TestFactsPhiCycleStaysUnknown(t *testing.T) {
	fs := parseFacts(t, `
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %next, %loop ]
  %next = add i32 %i, %n
  %done = icmp eq i32 %next, 0
  br i1 %done, label %out, label %loop
out:
  ret i32 %i
`)
	wantFact(t, fs, "i", 0)
	wantFact(t, fs, "next", 0)
	wantFact(t, fs, "done", factAll)
}

// A phi every one of whose inputs is nonneg does get the fact, and a
// bool phi keeps factBool.
func TestFactsPhiMeet(t *testing.T) {
	fs := parseFacts(t, `
entry:
  %m = and i32 %n, 255
  %p = icmp eq i32 %n, 7
  br i1 %p, label %a, label %b
a:
  br label %join
b:
  br label %join
join:
  %nn = phi i32 [ %m, %a ], [ 3, %b ]
  %mixed = phi i32 [ %m, %a ], [ %n, %b ]
  %bb = phi i32 [ 1, %a ], [ 0, %b ]
  ret i32 %nn
`)
	wantFact(t, fs, "m", factNonNeg)
	wantFact(t, fs, "p", factAll)
	wantFact(t, fs, "nn", factNonNeg)
	wantFact(t, fs, "mixed", 0)
	wantFact(t, fs, "bb", factAll)
}

// The op rules: masks, shifts, casts, and the meets.
func TestFactsOpRules(t *testing.T) {
	fs := parseFacts(t, `
entry:
  %hi = and i32 %n, -16
  %lo = and i32 %n, 65535
  %one = and i32 %n, 1
  %sh = lshr i32 %n, 1
  %sh0 = lshr i32 %n, 0
  %as = ashr i32 %n, 1
  %z = zext i8 %c to i32
  %t1 = trunc i32 %n to i1
  %orn = or i32 %lo, %sh
  %orbad = or i32 %lo, %n
  %xb = xor i32 %one, %t1
  %sel = select i1 %t1, i32 %lo, i32 %n
  %sum = add i32 %lo, %lo
  %wide = add i32 %sh, %sh
  %prod = mul i32 %lo, 4
  %big = mul i32 %sh, 4
  %rem = urem i32 %n, 10
  %q = udiv i32 %lo, 3
  %sl = shl i32 %lo, 8
  %slbig = shl i32 %lo, 20
  ret i32 %sum
`)
	wantFact(t, fs, "hi", 0) // the mask keeps bit 31
	wantFact(t, fs, "lo", factNonNeg)
	wantFact(t, fs, "one", factAll)
	wantFact(t, fs, "sh", factNonNeg)
	wantFact(t, fs, "sh0", 0) // a shift by zero is a copy
	wantFact(t, fs, "as", 0)  // arithmetic shift refills the sign
	wantFact(t, fs, "z", factNonNeg)
	wantFact(t, fs, "t1", factAll)
	wantFact(t, fs, "orn", factNonNeg)
	wantFact(t, fs, "orbad", 0)
	wantFact(t, fs, "xb", factAll)
	wantFact(t, fs, "sel", 0)          // one arm is unknown
	wantFact(t, fs, "sum", factNonNeg) // 65535 + 65535 still fits below bit 31
	wantFact(t, fs, "wide", 0)         // 0x7FFFFFFF doubled carries into bit 31
	wantFact(t, fs, "prod", factNonNeg)
	wantFact(t, fs, "big", 0)          // 0x7FFFFFFF * 4 overflows the word
	wantFact(t, fs, "rem", factNonNeg) // a remainder mod 10 is 0..9
	wantFact(t, fs, "q", factNonNeg)
	wantFact(t, fs, "sl", factNonNeg)
	wantFact(t, fs, "slbig", 0) // 65535 << 20 runs past bit 31
}

// wantBlockFact checks the facts a value carries INSIDE one block.
func wantBlockFact(t *testing.T, f *llir.Func, fs factSet, block, name string, want uint8) {
	t.Helper()
	for bi, b := range f.Blocks {
		if b.Name != block {
			continue
		}
		v := &llir.Value{Kind: llir.VLocal, Name: name}
		if got := fs.at(bi, v); got != want {
			t.Errorf("%%%s in %%%s: facts %#b, want %#b", name, block, got, want)
		}
		return
	}
	t.Fatalf("no block %%%s", block)
}

func parseFunc(t *testing.T, body string) (*llir.Func, factSet) {
	t.Helper()
	m, err := llir.Parse("define i32 @f(i32 %n, i32 %k, i8 %c) {\n" + body + "\n}\n")
	if err != nil {
		t.Fatalf("parse: %v", err)
	}
	return m.Funcs[0], factsOf(m.Funcs[0], nil)
}

// An unsigned guard bounds its subject on the true edge; a SIGNED one
// does not — `slt x, 100` passes every negative word too, and `sgt x, 5`
// bounds x from below, not above.
func TestFactsBranchNarrowing(t *testing.T) {
	f, fs := parseFunc(t, `
entry:
  %u = icmp ult i32 %n, 100
  br i1 %u, label %lo, label %hi
lo:
  %s = icmp slt i32 %k, 100
  br i1 %s, label %sl, label %sh
sl:
  ret i32 0
sh:
  ret i32 1
hi:
  ret i32 2
`)
	wantBlockFact(t, f, fs, "entry", "n", 0)
	wantBlockFact(t, f, fs, "lo", "n", factNonNeg)
	// The unsigned bound survives into a block the true edge dominates.
	wantBlockFact(t, f, fs, "sl", "n", factNonNeg)
	// A signed upper bound says nothing about the word.
	wantBlockFact(t, f, fs, "sl", "k", 0)
	// ... and neither does the false edge of the unsigned test.
	wantBlockFact(t, f, fs, "hi", "n", 0)
}

// `x >= 0` / `x > -1` and their negations are the signed guards that DO
// prove bit 31 clear.
func TestFactsSignedZeroGuards(t *testing.T) {
	f, fs := parseFunc(t, `
entry:
  %a = icmp sgt i32 %n, -1
  br i1 %a, label %pos, label %neg
pos:
  %b = icmp slt i32 %k, 0
  br i1 %b, label %kneg, label %kpos
kneg:
  ret i32 0
kpos:
  ret i32 1
neg:
  ret i32 2
`)
	wantBlockFact(t, f, fs, "pos", "n", factNonNeg)
	wantBlockFact(t, f, fs, "neg", "n", 0)
	wantBlockFact(t, f, fs, "kpos", "k", factNonNeg) // slt 0 is false: k >= 0
	wantBlockFact(t, f, fs, "kneg", "k", 0)
}

// The unsigned counter closes: the guard bounds %i on the back edge, so
// %next is bounded, so the phi is — with no assumption anywhere. The
// header block is its own latch here, the shape -Oz emits most often.
func TestFactsUnsignedCounterCloses(t *testing.T) {
	_, fs := parseFunc(t, `
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %next, %loop ]
  %next = add i32 %i, 1
  %c = icmp ult i32 %next, 9
  br i1 %c, label %loop, label %out
out:
  ret i32 %i
`)
	wantFact(t, fs, "i", factNonNeg)
	wantFact(t, fs, "next", factNonNeg)
}

// The adversarial counters. None of these may pick up a fact.
func TestFactsCountersThatCanWrap(t *testing.T) {
	// (a) No guard at all: `for (unsigned i = 0;; i++)` walks the whole
	// word and passes through 0x80000000.
	_, fs := parseFunc(t, `
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %next, %loop ]
  %next = add i32 %i, 1
  br label %loop
`)
	wantFact(t, fs, "i", 0)
	wantFact(t, fs, "next", 0)

	// (b) A SIGNED guard against an unknown bound: the guard admits a
	// negative %i, so nothing bounds the word and the step may wrap.
	_, fs = parseFunc(t, `
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %next, %loop ]
  %next = add i32 %i, 1
  %c = icmp slt i32 %next, %n
  br i1 %c, label %loop, label %out
out:
  ret i32 %i
`)
	wantFact(t, fs, "i", 0)
	wantFact(t, fs, "next", 0)

	// (c) An unsigned guard on the value BEFORE the step, with a stride
	// that overruns it: %i <= 0x7FFFFFFE in the body, and %i + 0x7FFFFFFF
	// lands past bit 31. (Guarding the STEPPED value instead would bound
	// the phi for any stride, which is why the guard's subject matters.)
	_, fs = parseFunc(t, `
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %next, %step ]
  %c = icmp ult i32 %i, 2147483647
  br i1 %c, label %step, label %out
step:
  %next = add i32 %i, 2147483647
  br label %loop
out:
  ret i32 %i
`)
	wantFact(t, fs, "i", 0)
	wantFact(t, fs, "next", 0)

	// (d) A phi cycle through a subtract borrows past zero.
	_, fs = parseFunc(t, `
entry:
  br label %loop
loop:
  %i = phi i32 [ 100, %entry ], [ %next, %loop ]
  %next = sub i32 %i, 1
  %c = icmp ult i32 %next, 100
  br i1 %c, label %loop, label %out
out:
  ret i32 %i
`)
	wantFact(t, fs, "next", 0)
}

// --- The wrap flags ----------------------------------------------------

// The counter loop the flags exist for. It is case (c) of
// TestFactsCountersThatCanWrap with `nsw` on the step: the guard bounds
// %i by 0x7FFFFFFE in the body, the step adds another 0x7FFFFFFF, and
// the SUM is what runs past bit 31 — so the phi meets a nonneg seed
// with an add saturated to the top and proves nothing. `add nsw` says
// that sum does not overflow int32, which with both operands nonneg
// makes it a nonnegative int32 and closes the phi.
//
// The unflagged twin is (c) itself, and it must keep proving nothing:
// the two together are the mutation guard on the flag plumbing.
func TestFactsNSWClosesSaturatedCounter(t *testing.T) {
	const shape = `
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %next, %step ]
  %c = icmp ult i32 %i, 2147483647
  br i1 %c, label %step, label %out
step:
  %next = add %FLAGS%i32 %i, 2147483647
  br label %loop
out:
  ret i32 %i
`
	_, fs := parseFunc(t, strings.Replace(shape, "%FLAGS%", "nsw ", 1))
	wantFact(t, fs, "i", factNonNeg)
	wantFact(t, fs, "next", factNonNeg)

	_, fs = parseFunc(t, strings.Replace(shape, "%FLAGS%", "", 1))
	wantFact(t, fs, "i", 0)
	wantFact(t, fs, "next", 0)
}

// What the flags may NOT be read to say. Every one of these carries a
// flag and must still come out factless.
func TestFactsWrapFlagsProveNothingMore(t *testing.T) {
	fs := parseFacts(t, `
entry:
  %h = lshr i32 %n, 1
  %half = add nsw i32 %h, %h
  %open = add nsw i32 %h, %n
  %opens = mul nsw i32 %h, %n
  %wrap = mul i32 %h, %h
  %nuwsum = add nuw i32 %h, %h
  ret i32 %half
`)
	// The rule itself: two nonneg words whose sum saturates past bit 31.
	wantFact(t, fs, "half", factNonNeg)
	// %n is unbounded, so it may be negative — and nsw says only that
	// the sum does not overflow int32, which a negative sum satisfies.
	wantFact(t, fs, "open", 0)
	wantFact(t, fs, "opens", 0)
	// The adversarial unflagged product: 0x7FFFFFFF squared wraps, and
	// without nsw nothing rules the wrapped word out.
	wantFact(t, fs, "wrap", 0)
	// nuw on an add says exactly what the unsigned rule already said:
	// 0x7FFFFFFF + 0x7FFFFFFF is 0xFFFFFFFE, which keeps bit 31.
	wantFact(t, fs, "nuwsum", 0)
}

// `mul nsw` with both operands nonneg is nonneg, on the same argument
// as add; `sub nuw` cannot borrow, so it never exceeds its minuend.
func TestFactsWrapFlagsMulAndSub(t *testing.T) {
	fs := parseFacts(t, `
entry:
  %h = lshr i32 %n, 1
  %m = and i32 %n, 65535
  %b = and i32 %n, 255
  %sq = mul nsw i32 %h, %h
  %small = mul nsw i32 %b, %b
  %d = sub nuw i32 %m, %n
  %d2 = sub i32 %m, %n
  %dopen = sub nuw i32 %n, %m
  ret i32 %sq
`)
	wantFact(t, fs, "sq", factNonNeg)
	// Already bounded without the flag: 255*255 needs no help, and the
	// flag must not LOOSEN the exact bound to the nonneg threshold.
	wantFact(t, fs, "small", factNonNeg)
	if got := fs.max["small"]; got != 65025 {
		t.Errorf("%%small: bound %#x, want 0xfe01", got)
	}
	// sub nuw takes the minuend's bound, unflagged sub takes nothing.
	wantFact(t, fs, "d", factNonNeg)
	wantFact(t, fs, "d2", 0)
	// A nuw sub of an UNBOUNDED minuend still proves nothing.
	wantFact(t, fs, "dopen", 0)
	if got := fs.max["d"]; got != 65535 {
		t.Errorf("%%d: bound %#x, want the minuend's 0xffff", got)
	}
}

// The flags describe the op's own integer type, and only a type that
// fits one machine word IS the word these bounds describe. An i64 add
// is a word pair whose low half wraps whatever the 64-bit sum does, so
// no flag on it may be read (facts.go: wrapFlagWord). Dropping that
// guard makes %w nonneg, which is exactly the unsound claim.
func TestFactsWrapFlagsIgnoreWidePairs(t *testing.T) {
	fs := parseFacts(t, `
entry:
  %h = lshr i32 %n, 1
  %z = zext i32 %h to i64
  %w = add nsw i64 %z, %z
  %p = mul nsw i64 %z, %z
  %s = sub nuw i64 %z, %z
  ret i32 %h
`)
	wantFact(t, fs, "z", factNonNeg)
	wantFact(t, fs, "w", 0)
	wantFact(t, fs, "p", 0)
	wantFact(t, fs, "s", 0)
}

// The narrowing rides only edges that every path to the block must take.
// A join reached from both arms of a branch keeps nothing.
func TestFactsNarrowingNeedsSolePredecessor(t *testing.T) {
	f, fs := parseFunc(t, `
entry:
  %u = icmp ult i32 %n, 100
  br i1 %u, label %a, label %b
a:
  br label %join
b:
  br label %join
join:
  ret i32 0
`)
	wantBlockFact(t, f, fs, "a", "n", factNonNeg)
	wantBlockFact(t, f, fs, "join", "n", 0)
}

// A conjunction taken true proves both halves; taken false, neither.
func TestFactsLogicalAndEdge(t *testing.T) {
	f, fs := parseFunc(t, `
entry:
  %p = icmp ult i32 %n, 100
  %q = icmp ult i32 %k, 100
  %both = select i1 %p, i1 %q, i1 false
  br i1 %both, label %yes, label %no
yes:
  ret i32 0
no:
  ret i32 1
`)
	wantBlockFact(t, f, fs, "yes", "n", factNonNeg)
	wantBlockFact(t, f, fs, "yes", "k", factNonNeg)
	wantBlockFact(t, f, fs, "no", "n", 0)
	wantBlockFact(t, f, fs, "no", "k", 0)
}

// A sub-word type bounds its word by its STORAGE width, not by its bit
// width: a `load i1` moves a whole byte, so 3 is a value it can hold and
// jbool-style facts must not follow from the type.
func TestFactsNarrowTypeBoundsAtStorageWidth(t *testing.T) {
	m, err := llir.Parse(`
define i32 @f(ptr %p) {
entry:
  %b = load i1, ptr %p, align 1
  %z = zext i1 %b to i32
  ret i32 %z
}
`)
	if err != nil {
		t.Fatalf("parse: %v", err)
	}
	fs := factsOf(m.Funcs[0], nil)
	wantFact(t, fs, "b", factNonNeg)
	wantFact(t, fs, "z", factNonNeg)
	if got := fs.max["b"]; got != 255 {
		t.Errorf("i1 load bound %#x, want 0xff", got)
	}
}

// A branch-narrowed operand routes its comparison to the short helper,
// and the same comparison outside the narrowed region does not.
func TestBranchNarrowedCompareRouting(t *testing.T) {
	const src = `
define i32 @main() {
entry:
  %x = load i32, ptr @gx, align 4
  %y = load i32, ptr @gy, align 4
  %g = icmp ult i32 %x, 4096
  br i1 %g, label %in, label %out
in:
  %p = icmp ult i32 %x, 100
  br i1 %p, label %t, label %f
out:
  %q = icmp ult i32 %y, 100
  br i1 %q, label %t, label %f
t:
  ret i32 1
f:
  ret i32 0
}
@gx = global i32 0
@gy = global i32 0
`
	out := compileOne(t, src, Options{})
	if !strings.Contains(out, "jump __cw_ltp\n") {
		t.Errorf("narrowed compare did not route to ltp:\n%s", out)
	}
	if !strings.Contains(out, "jump __cw_ltu\n") {
		t.Errorf("unnarrowed compare left the general helper:\n%s", out)
	}
}

// compileOne compiles a single-function module and returns its dasm.
// --- Whole-program bounds ----------------------------------------------

// analyzeIP runs the interprocedural fixed point over a whole module,
// skipping garbage collection so that a function with no caller at all
// still reaches the analysis (the adversarial shape).
func analyzeIP(t *testing.T, src string) *ipBounds {
	t.Helper()
	m, err := llir.Parse(src)
	if err != nil {
		t.Fatalf("parse: %v", err)
	}
	m.ResolveAliases()
	g := &gen{m: m, opts: Options{Entry: "main"}, funcIdx: map[string]*llir.Func{}}
	for _, f := range m.Funcs {
		g.funcIdx[f.Name] = f
	}
	_, ip := g.analyzeBounds()
	return ip
}

func wantParam(t *testing.T, ip *ipBounds, fn string, i int, want uint32) {
	t.Helper()
	if got := ip.paramBound(fn, i); got != want {
		t.Errorf("param %s#%d bound %#x, want %#x", fn, i, got, want)
	}
}

func wantRet(t *testing.T, ip *ipBounds, fn string, want uint32) {
	t.Helper()
	if got := ip.retBound(fn); got != want {
		t.Errorf("ret %s bound %#x, want %#x", fn, got, want)
	}
}

// The meet is the MAXIMUM over the call sites, and it closes what no
// per-function analysis can: an i32 parameter every caller keeps small.
func TestIPParamMeetOverSites(t *testing.T) {
	ip := analyzeIP(t, `
define i32 @cb(i32 %n, i32 %m) {
entry:
  ret i32 %n
}
define i32 @main() {
entry:
  %a = call i32 @cb(i32 5, i32 -1)
  %b = call i32 @cb(i32 7, i32 3)
  ret i32 %a
}
`)
	wantParam(t, ip, "cb", 0, 7)
	// -1 renders as the full word: one loose site sets the meet.
	wantParam(t, ip, "cb", 1, maxUnknown)
	wantRet(t, ip, "cb", 7)
	wantRet(t, ip, "main", 7)
}

// A parameter fed by a constant at one site and an unbounded load at
// another must stay at the top: the meet is the maximum, not a vote.
func TestIPOneUnboundedSiteKillsTheMeet(t *testing.T) {
	ip := analyzeIP(t, `
@gv = global i32 0
define i32 @cb(i32 %n) {
entry:
  ret i32 0
}
define i32 @main() {
entry:
  %v = load i32, ptr @gv, align 4
  %a = call i32 @cb(i32 5)
  %b = call i32 @cb(i32 %v)
  ret i32 %a
}
`)
	wantParam(t, ip, "cb", 0, maxUnknown)
	wantRet(t, ip, "cb", 0)
}

// An ADDRESS-TAKEN function keeps unbounded parameters however tight
// its visible direct call sites are: the indirect call through the
// stored pointer is a site the meet cannot count. Both escape
// mechanisms are exercised — a pointer stored to memory, and a callee
// reachable only through a constant dispatch table (the vector-page
// shape: no `call @tab` names it anywhere).
func TestIPAddressTakenStaysUnbounded(t *testing.T) {
	ip := analyzeIP(t, `
@fp = global ptr null
@tab = internal constant [2 x ptr] [ptr @tabbed, ptr null]
define i32 @stored(i32 %n) {
entry:
  ret i32 %n
}
define i32 @tabbed(i32 %n) {
entry:
  ret i32 %n
}
define i32 @plain(i32 %n) {
entry:
  ret i32 %n
}
define i32 @main() {
entry:
  store ptr @stored, ptr @fp, align 4
  %a = call i32 @stored(i32 5)
  %b = call i32 @plain(i32 5)
  %t = call i32 @tabbed(i32 5)
  %f = load ptr, ptr @fp, align 4
  %c = call i32 %f(i32 9)
  ret i32 %a
}
`)
	wantParam(t, ip, "stored", 0, maxUnknown)
	wantParam(t, ip, "tabbed", 0, maxUnknown)
	// The control: an ordinary callee beside them does get the bound.
	wantParam(t, ip, "plain", 0, 5)
	// The indirect call's own result is unbounded — it is how a value
	// the kernel deposits without running a `ret` re-enters the program.
	wantRet(t, ip, "main", maxUnknown)
}

// The entry point is entered by crt0 and by loaders (at warmstart) with
// no arguments at all: its parameters stay unbounded even when the
// module also calls it with a constant. A function with no call site at
// all keeps the top too — the empty maximum would be ZERO, the one
// shape that could mint a bound out of nothing.
func TestIPEntryAndUncalledStayUnbounded(t *testing.T) {
	ip := analyzeIP(t, `
define i32 @orphan(i32 %n) {
entry:
  ret i32 %n
}
define i32 @main(i32 %argc) {
entry:
  %a = call i32 @main(i32 3)
  ret i32 %a
}
`)
	wantParam(t, ip, "main", 0, maxUnknown)
	wantParam(t, ip, "orphan", 0, maxUnknown)
}

// Mutual recursion. The cycle may not bootstrap a bound out of itself:
// with no site outside the cycle, both parameters stay at the top,
// because the descending iteration reads each site from the CURRENT
// facts, which start pessimistic. (The same descent is why a value
// merely passed around a cycle never tightens even when every entry
// into the cycle is a constant — accepted imprecision, not a hole.)
func TestIPMutualRecursionStaysUnbounded(t *testing.T) {
	ip := analyzeIP(t, `
define i32 @a(i32 %x) {
entry:
  %r = call i32 @b(i32 %x)
  ret i32 %r
}
define i32 @b(i32 %x) {
entry:
  %r = call i32 @a(i32 %x)
  ret i32 %r
}
define i32 @main() {
entry:
  %r = call i32 @a(i32 4)
  ret i32 %r
}
`)
	wantParam(t, ip, "a", 0, maxUnknown)
	wantParam(t, ip, "b", 0, maxUnknown)
	wantRet(t, ip, "a", maxUnknown)
	wantRet(t, ip, "b", maxUnknown)
}

// A self-call is an ordinary site, and one whose argument the analysis
// can bound outright does not stop the meet: `f(n & 255)` recursing on
// a masked value keeps the parameter bounded, while the plain pass-
// through of the test above does not.
func TestIPSelfCallIsJustAnotherSite(t *testing.T) {
	ip := analyzeIP(t, `
define i32 @f(i32 %n) {
entry:
  %m = and i32 %n, 255
  %r = call i32 @f(i32 %m)
  ret i32 %r
}
define i32 @main() {
entry:
  %r = call i32 @f(i32 6)
  ret i32 %r
}
`)
	wantParam(t, ip, "f", 0, 255)
}

// The return meet: a callee that only ever returns 0 or 1 hands its
// call sites a BOOL, and one that returns an unknown load hands them
// nothing. A function with no value-returning `ret` keeps the top —
// max over zero returns would be zero.
func TestIPReturnMeet(t *testing.T) {
	ip := analyzeIP(t, `
@gv = global i32 0
define i32 @flag(i32 %n) {
entry:
  %c = icmp eq i32 %n, 0
  br i1 %c, label %t, label %f
t:
  ret i32 1
f:
  ret i32 0
}
define i32 @opaque() {
entry:
  %v = load i32, ptr @gv, align 4
  ret i32 %v
}
define void @novalue() {
entry:
  ret void
}
define i32 @main() {
entry:
  %a = call i32 @flag(i32 2)
  %b = call i32 @opaque()
  call void @novalue()
  %s = add i32 %a, %b
  ret i32 %s
}
`)
	wantRet(t, ip, "flag", 1)
	wantRet(t, ip, "opaque", maxUnknown)
	wantRet(t, ip, "novalue", maxUnknown)
}

// A variadic callee's FIXED parameters are passed positionally by every
// site like any other; the tail lands in the static va area and is read
// back by loads, which nothing here bounds. And a site that passes
// FEWER arguments than the callee has parameters — the depth-K sink
// rewrite (expandClones nils Args), or a prototype the site disagrees
// with — writes no argument word, so it tops the whole callee.
func TestIPVariadicAndPartialSites(t *testing.T) {
	ip := analyzeIP(t, `
declare i32 @printf(ptr, ...)
define i32 @vf(i32 %n, ...) {
entry:
  ret i32 %n
}
define i32 @sink(i32 %n) {
entry:
  ret i32 %n
}
define i32 @main() {
entry:
  %a = call i32 (i32, ...) @vf(i32 4, i32 -1)
  %b = call i32 (i32, ...) @vf(i32 9)
  %c = call i32 @sink(i32 3)
  %d = call i32 @sink()
  ret i32 %a
}
`)
	wantParam(t, ip, "vf", 0, 9)
	wantParam(t, ip, "sink", 0, maxUnknown)
}

// End to end: a parameter every caller keeps nonneg routes its signed
// compare to __cw_ltp — the site the per-function analysis could not
// reach (prompts/042 §10, `s:param`).
func TestIPParamRoutesSignedCompare(t *testing.T) {
	out := compileOne(t, `
@gv = global i32 0
define i32 @lim(i32 %n, i32 %k) {
entry:
  %c = icmp slt i32 %k, %n
  br i1 %c, label %t, label %f
t:
  ret i32 1
f:
  ret i32 0
}
define i32 @main() {
entry:
  %a = call i32 @lim(i32 100, i32 3)
  %b = call i32 @lim(i32 7, i32 5)
  ret i32 %a
}
`, Options{})
	if !strings.Contains(out, "jump __cw_ltp\n") {
		t.Errorf("bounded parameters did not route the signed compare to ltp:\n%s", out)
	}
	if strings.Contains(out, "jump __cw_lt\n") {
		t.Errorf("the full-range helper survived a fully bounded compare:\n%s", out)
	}
}

// The same shape with ONE loose caller keeps the full-range helper: the
// bound must not survive a site that cannot prove it.
func TestIPLooseCallerKeepsFullRangeCompare(t *testing.T) {
	out := compileOne(t, `
@gv = global i32 0
define i32 @lim(i32 %n, i32 %k) {
entry:
  %c = icmp slt i32 %k, %n
  br i1 %c, label %t, label %f
t:
  ret i32 1
f:
  ret i32 0
}
define i32 @main() {
entry:
  %v = load i32, ptr @gv, align 4
  %a = call i32 @lim(i32 100, i32 3)
  %b = call i32 @lim(i32 %v, i32 5)
  ret i32 %a
}
`, Options{})
	if !strings.Contains(out, "jump __cw_lt\n") {
		t.Errorf("a loose call site did not keep the full-range helper:\n%s", out)
	}
}

func compileOne(t *testing.T, src string, opts Options) string {
	t.Helper()
	m, err := llir.Parse(src)
	if err != nil {
		t.Fatalf("parse: %v", err)
	}
	if opts.Entry == "" {
		opts.Entry = "main"
	}
	out, err := Compile(m, opts)
	if err != nil {
		t.Fatalf("compile: %v", err)
	}
	return out
}

// A signed sub-word compare sign-extends its operands, and the
// sign-extended words are full-range: the site must keep __cw_lt even
// though both i8 value words are nonneg. The unsigned compare of the
// same operands needs no extension and does route to __cw_ltp.
func TestSubWordCompareKeepsSignExtension(t *testing.T) {
	src := func(pred string) string {
		return `
define i32 @main() {
entry:
  %a = load i8, ptr @ga, align 1
  %b = load i8, ptr @gb, align 1
  %s = icmp ` + pred + ` i8 %a, %b
  br i1 %s, label %t, label %f
t:
  ret i32 1
f:
  ret i32 0
}
@ga = global i8 0
@gb = global i8 0
`
	}
	signed := compileOne(t, src("slt"), Options{})
	if strings.Contains(signed, "jump __cw_ltp\n") {
		t.Errorf("signed i8 compare took the nonneg shortcut past its sign extension:\n%s", signed)
	}
	if !strings.Contains(signed, "jump __cw_lt\n") {
		t.Errorf("signed i8 compare did not use the full-range helper:\n%s", signed)
	}
	if !strings.Contains(signed, ", sc0\n") {
		t.Errorf("signed i8 compare skipped the sign extension:\n%s", signed)
	}
	unsigned := compileOne(t, src("ult"), Options{})
	if !strings.Contains(unsigned, "jump __cw_ltp\n") {
		t.Errorf("unsigned i8 compare did not route to ltp:\n%s", unsigned)
	}
	if strings.Contains(unsigned, ", sc0\n") {
		t.Errorf("unsigned i8 compare sign-extended its operands:\n%s", unsigned)
	}
}

// The zero test of a masked value routes to eqzp; of an unknown i32 it
// stays on eqz.
func TestZeroTestRouting(t *testing.T) {
	const src = `
define i32 @main() {
entry:
  %v = load i32, ptr @gv, align 4
  %m = and i32 %v, 255
  %p = icmp eq i32 %m, 0
  br i1 %p, label %a, label %b
a:
  %q = icmp eq i32 %v, 0
  br i1 %q, label %b, label %c
b:
  ret i32 1
c:
  ret i32 2
}
@gv = global i32 0
`
	out := compileOne(t, src, Options{})
	if !strings.Contains(out, "jump __cw_eqzp\n") {
		t.Errorf("masked zero test did not route to eqzp:\n%s", out)
	}
	if !strings.Contains(out, "jump __cw_eqz\n") {
		t.Errorf("unknown zero test left the full-range helper:\n%s", out)
	}
}
