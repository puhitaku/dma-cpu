package dmacc_test

// Block layout (prompts/042 §1): Options.ColdBlocks sinks the blocks a
// profile never saw execute to the end of their function, so the hot
// ones sit back to back and their jumps fall away. What is pinned down
// here: the partition happens, it is free when the set is empty, and
// the two things that could go wrong invisibly — it may not move a
// safepoint, and it may not change a single instruction inside the
// blocks it moves.

import (
	"sort"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/dmacc"
	"github.com/puhitaku/dma-cpu/host/llir"
)

// diamondIR is one if/else join: IR order entry, hot, cold, join.
const diamondIR = `
define i32 @diamond(i32 %n) {
entry:
  %c = icmp eq i32 %n, 0
  br i1 %c, label %cold, label %hot
hot:
  %a = add i32 %n, 1
  br label %join
cold:
  %b = add i32 %n, 7
  br label %join
join:
  %r = phi i32 [ %a, %hot ], [ %b, %cold ]
  ret i32 %r
}
`

// loopIR is a counted loop whose HEADER precedes its body in IR order,
// so the backedge body -> head is backward and carries a safepoint.
// Sinking the header is the layout that would turn that edge lexically
// forward — see TestColdBlockSafepoint.
const loopIR = `
define i32 @loopy(i32 %n) {
entry:
  br label %head
head:
  %i = phi i32 [ 0, %entry ], [ %i2, %body ]
  %c = icmp slt i32 %i, %n
  br i1 %c, label %body, label %done
body:
  %i2 = add i32 %i, 1
  br label %head
done:
  ret i32 %i
}
`

func compileIR(t *testing.T, ir string, cold ...string) string {
	t.Helper()
	mod, err := llir.Parse(ir)
	if err != nil {
		t.Fatal(err)
	}
	set := map[string]bool{}
	for _, c := range cold {
		set[c] = true
	}
	if len(cold) == 0 {
		set = nil
	}
	dasm, err := dmacc.Compile(mod, dmacc.Options{Entry: "diamond",
		NoOutline: true, ColdBlocks: set})
	if err != nil {
		t.Fatal(err)
	}
	return dasm
}

// labelOrder returns the positions of the named labels in the emitted
// text, in emission order, and fails if one is missing.
func labelOrder(t *testing.T, dasm string, labels ...string) []int {
	t.Helper()
	lines := strings.Split(dasm, "\n")
	at := make([]int, len(labels))
	for i, l := range labels {
		at[i] = -1
		for j, raw := range lines {
			if strings.TrimSpace(raw) == l+":" {
				at[i] = j
				break
			}
		}
		if at[i] < 0 {
			t.Fatalf("label %s not emitted", l)
		}
	}
	return at
}

// TestColdBlockLayout: the cold arm of a diamond sinks past the join,
// and the hot arm's jump to the join goes away with it.
func TestColdBlockLayout(t *testing.T) {
	t.Parallel()
	base := compileIR(t, diamondIR)
	at := labelOrder(t, base, "B_diamond_entry", "B_diamond_hot",
		"B_diamond_cold", "B_diamond_join")
	if !(at[0] < at[1] && at[1] < at[2] && at[2] < at[3]) {
		t.Fatalf("baseline layout is not IR order: %v", at)
	}

	sunk := compileIR(t, diamondIR, "B_diamond_cold")
	at = labelOrder(t, sunk, "B_diamond_entry", "B_diamond_hot",
		"B_diamond_cold", "B_diamond_join")
	if !(at[0] < at[1] && at[1] < at[3] && at[3] < at[2]) {
		t.Errorf("cold arm did not sink past the join: entry %d hot %d cold %d join %d",
			at[0], at[1], at[2], at[3])
	}
	// The hot arm now runs into the join: elideFallthroughJumps drops
	// its jump, so the line above the join label is not a branch.
	lines := strings.Split(sunk, "\n")
	prev := ""
	for i := at[3] - 1; i >= 0; i-- {
		if s := strings.TrimSpace(lines[i]); s != "" {
			prev = s
			break
		}
	}
	if strings.HasPrefix(prev, "jump") {
		t.Errorf("hot edge into the join is still a jump: %q", prev)
	}
	// The cold arm's own jump to the join survives — it is a real
	// branch now, which is exactly the trade.
	if n := strings.Count(sunk, "jump B_diamond_join"); n != 1 {
		t.Errorf("jumps to the join: %d, want 1", n)
	}
}

// TestColdBlockLayoutOff: with no cold set the emitted text is what it
// has always been, byte for byte, on a real image.
func TestColdBlockLayoutOff(t *testing.T) {
	t.Parallel()
	// A fresh parse per compile: Compile expands recursion clones into
	// the module it is given, so a reused one is not the same input.
	off, err := dmacc.Compile(shModule(t), dmacc.Options{RecursionDepth: 2, XIPText: true})
	if err != nil {
		t.Fatal(err)
	}
	empty, err := dmacc.Compile(shModule(t), dmacc.Options{RecursionDepth: 2, XIPText: true,
		ColdBlocks: map[string]bool{}})
	if err != nil {
		t.Fatal(err)
	}
	if off != empty {
		t.Errorf("an empty ColdBlocks set changed %d bytes of text",
			len(empty)-len(off))
	}
}

// TestColdBlockSafepoint is the guardrail. Safepoints mark backedges,
// and a backedge is an IR-order fact: laying the loop header out last
// makes the edge lexically forward, and a layout-dependent test would
// drop the safepoint there — an unbounded interrupt-latency hole that
// no functional test would notice. Sink the header and demand the
// safepoint anyway.
func TestColdBlockSafepoint(t *testing.T) {
	t.Parallel()
	mod, err := llir.Parse(loopIR)
	if err != nil {
		t.Fatal(err)
	}
	dasm, err := dmacc.Compile(mod, dmacc.Options{Entry: "loopy", NoOutline: true,
		ColdBlocks: map[string]bool{"B_loopy_head": true}})
	if err != nil {
		t.Fatal(err)
	}
	// The header really did sink past the body it loops back to...
	at := labelOrder(t, dasm, "B_loopy_body", "B_loopy_head")
	if at[0] > at[1] {
		t.Fatalf("the header did not sink: body %d head %d", at[0], at[1])
	}
	// ...and the backedge out of the body still parks a safepoint.
	lines := strings.Split(dasm, "\n")
	body := lines[at[0]:]
	for i, raw := range body[1:] {
		if strings.HasSuffix(strings.TrimSpace(raw), ":") {
			body = body[:i+1]
			break
		}
	}
	if !strings.Contains(strings.Join(body, "\n"), "safepoint") {
		t.Errorf("backedge lost its safepoint when the loop header sank:\n%s",
			strings.Join(body, "\n"))
	}
}

// TestColdBlockSafepointCount is the same guarantee at scale: whatever
// a profile says about a real image's blocks, the safepoints it emits
// are the same ones.
func TestColdBlockSafepointCount(t *testing.T) {
	t.Parallel()
	base, err := dmacc.Compile(shModule(t), dmacc.Options{RecursionDepth: 2})
	if err != nil {
		t.Fatal(err)
	}
	// Every third block label of the image, cold — an arbitrary
	// partition, which is the point: no set may change the count.
	cold, n := map[string]bool{}, 0
	for _, raw := range strings.Split(base, "\n") {
		l := strings.TrimSpace(raw)
		if strings.HasPrefix(l, "B_") && strings.HasSuffix(l, ":") {
			if n%3 == 0 {
				cold[strings.TrimSuffix(l, ":")] = true
			}
			n++
		}
	}
	if len(cold) < 100 {
		t.Fatalf("only %d cold candidates out of %d blocks", len(cold), n)
	}
	sunk, err := dmacc.Compile(shModule(t), dmacc.Options{RecursionDepth: 2, ColdBlocks: cold})
	if err != nil {
		t.Fatal(err)
	}
	if a, b := countIns(base, "safepoint"), countIns(sunk, "safepoint"); a != b {
		t.Errorf("safepoints: %d without a cold set, %d with one", a, b)
	}
}

// TestColdBlockSameCode is the invariant the layout rests on: a cold
// set may reorder finished blocks and nothing else. Lowering carries
// state forward — a folded GEP registers a link-time address and a pure
// copy registers an alias, both emitting no code at all and both read
// at every later use site — so lowering the blocks out of order would
// quietly rewrite the code inside them. It did, once: sinking a block
// whose three folded GEPs the loop below it used turned four constant
// stores into self-modified indirect ones through value words nothing
// wrote, and the game's dino scene wrote 4 bytes to address 0xa.
//
// Every instruction that is not a block jump must therefore survive a
// cold set unchanged, in kind and in count. (Jumps are exactly what
// layout is allowed to change: that is the optimization.)
func TestColdBlockSameCode(t *testing.T) {
	t.Parallel()
	opts := dmacc.Options{RecursionDepth: 2, XIPText: true, NoOutline: true}
	base, err := dmacc.Compile(shModule(t), opts)
	if err != nil {
		t.Fatal(err)
	}
	cold, n := map[string]bool{}, 0
	for _, raw := range strings.Split(base, "\n") {
		l := strings.TrimSpace(raw)
		if strings.HasPrefix(l, "B_") && strings.HasSuffix(l, ":") {
			if n%2 == 0 {
				cold[strings.TrimSuffix(l, ":")] = true
			}
			n++
		}
	}
	opts.ColdBlocks = cold
	sunk, err := dmacc.Compile(shModule(t), opts)
	if err != nil {
		t.Fatal(err)
	}
	body := func(dasm string) []string {
		var out []string
		for _, raw := range strings.Split(dasm, "\n") {
			l := strings.TrimSpace(raw)
			if l == "" || strings.HasSuffix(l, ":") || strings.HasPrefix(l, ";") ||
				strings.HasPrefix(l, ".") || strings.HasPrefix(l, "jump B_") {
				continue
			}
			out = append(out, l)
		}
		sort.Strings(out)
		return out
	}
	a, b := body(base), body(sunk)
	if len(a) != len(b) {
		t.Fatalf("cold set changed the instruction count: %d -> %d", len(a), len(b))
	}
	for i := range a {
		if a[i] != b[i] {
			t.Fatalf("cold set rewrote an instruction: %q -> %q", a[i], b[i])
		}
	}
}

func countIns(dasm, mnem string) int {
	n := 0
	for _, raw := range strings.Split(dasm, "\n") {
		if strings.TrimSpace(raw) == mnem {
			n++
		}
	}
	return n
}

func shModule(t *testing.T) *llir.Module {
	t.Helper()
	mod, err := llir.Merge(
		parseLL(t, "../../target/xv6/ll/sh.ll"), parseLL(t, "../../target/xv6/ll/ulib.ll"),
		parseLL(t, "../../target/xv6/ll/umalloc.ll"), parseLL(t, "../../target/xv6/ll/usys.ll"))
	if err != nil {
		t.Fatal(err)
	}
	return mod
}
