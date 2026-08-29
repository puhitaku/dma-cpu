package dmacc_test

import (
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/dmacc"
	"github.com/puhitaku/dma-cpu/host/llir"
)

// TestOutlineInvariants checks the structural promises of
// host/dmacc/outline.go on real images: helper bodies hold only
// relocatable instructions, every helper entry and every resume label is
// defined exactly once, and no site jumps across the flash/SRAM split.
// (That the outlined code RUNS is the whole xv6 and game suite's job —
// every one of them executes it.)
func TestOutlineInvariants(t *testing.T) {
	t.Parallel()
	shMod, err := llir.Merge(
		parseLL(t, "../../target/xv6/ll/sh.ll"), parseLL(t, "../../target/xv6/ll/ulib.ll"),
		parseLL(t, "../../target/xv6/ll/umalloc.ll"), parseLL(t, "../../target/xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	shDasm, err := dmacc.Compile(shMod, dmacc.Options{RecursionDepth: 2, XIPText: true})
	if err != nil {
		t.Fatal(err)
	}
	for _, img := range []struct{ name, dasm string }{
		{"xsh-kernel", compileKernelXsh(t, false)},
		{"sh-xip", shDasm},
	} {
		checkOutline(t, img.name, img.dasm)
	}
}

func checkOutline(t *testing.T, name, dasm string) {
	t.Helper()
	// Section of every label definition, and of every reference.
	sec, defs, helpers := "", map[string]string{}, 0
	inHelper := false
	var refs []struct{ sym, sec string }
	for _, raw := range strings.Split(dasm, "\n") {
		l := raw
		if i := strings.IndexByte(l, ';'); i >= 0 {
			l = l[:i]
		}
		l = strings.TrimSpace(l)
		switch {
		case l == "":
			continue
		case l == ".text", l == ".ramtext", l == ".data":
			sec = l
			if l == ".data" {
				sec = ".data"
			}
			inHelper = false
			continue
		case sec == ".data" && strings.Contains(l, ":"):
			// A data definition ("sym: .word 0") names its own storage.
			defs[strings.TrimSpace(l[:strings.IndexByte(l, ':')])] = sec
			continue
		case strings.HasSuffix(l, ":") && !strings.ContainsAny(l, " \t"):
			lbl := strings.TrimSuffix(l, ":")
			// Only the generated names: the runtime legitimately defines
			// the same label in both arms of an `.ifcompact`.
			if old, dup := defs[lbl]; dup && strings.HasPrefix(lbl, "__ol") {
				t.Errorf("%s: label %q defined twice (%s, %s)", name, lbl, old, sec)
			}
			defs[lbl] = sec
			inHelper = strings.HasPrefix(lbl, "__ol_") && lbl != "__ol_ret"
			if inHelper {
				helpers++
			}
			continue
		}
		mnem := l
		if i := strings.IndexByte(mnem, ' '); i >= 0 {
			mnem = mnem[:i]
		}
		if inHelper {
			// Whatever moved into a helper had to be relocatable.
			switch mnem {
			case "call", "safepoint":
				t.Errorf("%s: helper body holds a %s: %q", name, mnem, l)
			}
			for _, f := range []string{".read", ".write", ".count", ".ctrl"} {
				if strings.Contains(l, f) {
					t.Errorf("%s: helper body holds a block-field reference: %q", name, l)
				}
			}
		}
		for _, tok := range strings.FieldsFunc(l, func(r rune) bool {
			return !(r == '_' || r >= 'a' && r <= 'z' || r >= 'A' && r <= 'Z' || r >= '0' && r <= '9')
		}) {
			if strings.HasPrefix(tok, "__ol_") || strings.HasPrefix(tok, "__olr_") {
				refs = append(refs, struct{ sym, sec string }{tok, sec})
			}
		}
	}
	if helpers == 0 {
		t.Fatalf("%s: the outliner produced no helpers", name)
	}
	for _, r := range refs {
		d, ok := defs[r.sym]
		if !ok {
			t.Errorf("%s: %q is referenced but never defined", name, r.sym)
			continue
		}
		if r.sym == "__ol_ret" {
			if d != ".data" {
				t.Errorf("%s: the resume cell lives in %s, not .data", name, d)
			}
			continue
		}
		// A .ramtext site must not jump into flash text, and vice versa:
		// RAMTextFuncs code runs while the XIP window is down.
		if d != r.sec {
			t.Errorf("%s: %q is defined in %s but referenced from %s", name, r.sym, d, r.sec)
		}
	}
	t.Logf("%s: %d outlined helpers", name, helpers)
}

// twoLoopsIR: two loop bodies whose leading runs are textually
// identical (constant stores to the same globals lower to the same
// `move $k, g_x` records, which two structurally-equal but
// value-word-distinct arithmetic blocks would not). Long enough that
// the outliner's own cost model says taking them pays.
const twoLoopsIR = `
@k0 = global i32 0
@k1 = global i32 0
@k2 = global i32 0
@k3 = global i32 0
@k4 = global i32 0
@k5 = global i32 0
@k6 = global i32 0
@k7 = global i32 0
@k8 = global i32 0
@k9 = global i32 0

define i32 @twoloops(i32 %n, i32 %m) {
entry:
  br label %ha
ha:
  %i = phi i32 [ 0, %entry ], [ %i2, %ba ]
  %ca = icmp slt i32 %i, %n
  br i1 %ca, label %ba, label %hb
ba:
  store i32 11, ptr @k0
  store i32 22, ptr @k1
  store i32 33, ptr @k2
  store i32 44, ptr @k3
  store i32 55, ptr @k4
  store i32 66, ptr @k5
  store i32 77, ptr @k6
  store i32 88, ptr @k7
  store i32 99, ptr @k8
  store i32 110, ptr @k9
  %i2 = add i32 %i, 1
  br label %ha
hb:
  %j = phi i32 [ 0, %ha ], [ %j2, %bb ]
  %cb = icmp slt i32 %j, %m
  br i1 %cb, label %bb, label %done
bb:
  store i32 11, ptr @k0
  store i32 22, ptr @k1
  store i32 33, ptr @k2
  store i32 44, ptr @k3
  store i32 55, ptr @k4
  store i32 66, ptr @k5
  store i32 77, ptr @k6
  store i32 88, ptr @k7
  store i32 99, ptr @k8
  store i32 110, ptr @k9
  %j2 = add i32 %j, 1
  br label %hb
done:
  ret i32 %i
}
`

func compileTwoLoops(t *testing.T, cold ...string) string {
	t.Helper()
	mod, err := llir.Parse(twoLoopsIR)
	if err != nil {
		t.Fatal(err)
	}
	var set map[string]bool
	if cold != nil {
		set = map[string]bool{}
		for _, c := range cold {
			set[c] = true
		}
	}
	dasm, err := dmacc.Compile(mod, dmacc.Options{Entry: "twoloops", ColdBlocks: set})
	if err != nil {
		t.Fatal(err)
	}
	return dasm
}

// TestOutlineColdLoop is the heat-aware half of the gate (prompts/042
// §1): a block on a CFG cycle keeps its code inline, UNLESS the profile
// measured it cold, and then it is outlined like anything else. Both
// loop bodies here are worth outlining and neither may be touched
// without the measurement.
func TestOutlineColdLoop(t *testing.T) {
	t.Parallel()
	hot := compileTwoLoops(t)
	if strings.Contains(hot, "__ol_") {
		t.Fatalf("the loop gate let a loop body outline with no cold set:\n%s", hot)
	}
	cold := compileTwoLoops(t, "B_twoloops_ba", "B_twoloops_bb")
	if !strings.Contains(cold, "__ol_") {
		t.Fatalf("a cold-listed loop body did not outline:\n%s", cold)
	}
	// Both occurrences became sites, and the body moved into one helper.
	if n := strings.Count(cold, "jump __ol_1"); n != 2 {
		t.Errorf("sites for the shared body: %d, want 2", n)
	}
	if n := strings.Count(cold, "\n__ol_1:"); n != 1 {
		t.Errorf("definitions of __ol_1: %d, want 1", n)
	}
	// The measurement is what moved, so it has to move only what it
	// names: listing one body alone leaves nothing to share with.
	if one := compileTwoLoops(t, "B_twoloops_ba"); strings.Contains(one, "__ol_") {
		t.Errorf("one cold loop body outlined against a hot one:\n%s", one)
	}
	if len(cold) >= len(hot) {
		t.Errorf("outlining the cold loops did not shrink the text: %d -> %d",
			len(hot), len(cold))
	}
}

// TestOutlineColdOff: with no measurement the gate is exactly the
// structural one it has always been. Mutation-style — an empty map and
// an absent map must produce the same bytes, on the fixture AND on a
// real image whose outliner does plenty of work.
func TestOutlineColdOff(t *testing.T) {
	t.Parallel()
	if off, empty := compileTwoLoops(t), compileTwoLoops(t); off != empty {
		t.Errorf("the fixture is not deterministic")
	}
	if off, empty := compileTwoLoops(t), compileTwoLoops(t, []string{}...); off != empty {
		t.Errorf("an empty ColdBlocks set changed the fixture")
	}
	// A fresh parse per compile: Compile expands recursion clones into
	// the module it is given.
	off, err := dmacc.Compile(shModule(t), dmacc.Options{RecursionDepth: 2, XIPText: true})
	if err != nil {
		t.Fatal(err)
	}
	empty, err := dmacc.Compile(shModule(t), dmacc.Options{RecursionDepth: 2, XIPText: true,
		ColdBlocks: map[string]bool{}})
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(off, "__ol_") {
		t.Fatal("the outliner did no work on sh: the comparison proves nothing")
	}
	if off != empty {
		t.Errorf("an empty ColdBlocks set changed %d bytes of sh's text",
			len(empty)-len(off))
	}
}
