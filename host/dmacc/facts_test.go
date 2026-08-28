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
	if got := fs[name]; got != want {
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
	wantFact(t, fs, "sel", 0) // one arm is unknown
	wantFact(t, fs, "sum", 0) // the sum of two nonnegs can carry into bit 31
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
