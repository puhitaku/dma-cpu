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
	return factsOf(m.Funcs[0])
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
	return m.Funcs[0], factsOf(m.Funcs[0])
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
	fs := factsOf(m.Funcs[0])
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
