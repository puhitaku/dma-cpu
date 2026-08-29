package llir

import "testing"

// The wrap flags survive the parse. They are the only instruction
// FLAGS llir keeps — host/dmacc/facts.go reads them — so the round trip
// is worth pinning: an `add` that carries none must come back with both
// fields false, or every bound derived from nsw would be minted out of
// nothing.
func TestParseWrapFlags(t *testing.T) {
	const src = `
define i32 @f(i32 %n) {
entry:
  %a = add nsw i32 %n, 1
  %b = add nuw i32 %a, 2
  %c = add nuw nsw i32 %b, 3
  %d = add i32 %c, 4
  %e = sub nuw i32 %d, 5
  %g = mul nsw i32 %e, 6
  %h = shl nuw nsw i32 %g, 1
  %i = or disjoint i32 %h, 8
  %j = lshr exact i32 %i, 2
  ret i32 %j
}
`
	m, err := Parse(src)
	if err != nil {
		t.Fatal(err)
	}
	if len(m.Funcs) != 1 || len(m.Funcs[0].Blocks) != 1 {
		t.Fatalf("parsed %d funcs", len(m.Funcs))
	}
	got := map[string][2]bool{}
	for _, ins := range m.Funcs[0].Blocks[0].Instrs {
		if ins.Res != "" {
			got[ins.Res] = [2]bool{ins.NSW, ins.NUW}
		}
	}
	want := map[string][2]bool{
		"a": {true, false},  // add nsw
		"b": {false, true},  // add nuw
		"c": {true, true},   // both, in LLVM's printed order
		"d": {false, false}, // unflagged: the mutation guard
		"e": {false, true},  // sub nuw
		"g": {true, false},  // mul nsw
		"h": {true, true},   // flags ride any binary op, not just add
		"i": {false, false}, // disjoint is dropped, not mistaken for nuw
		"j": {false, false}, // exact likewise
	}
	for _, res := range []string{"a", "b", "c", "d", "e", "g", "h", "i", "j"} {
		w, ok := want[res]
		if !ok {
			continue
		}
		if got[res] != w {
			t.Errorf("%%%s: nsw/nuw = %v, want %v", res, got[res], w)
		}
	}
	// The operands must still be there: flag consumption must not eat a
	// token the value parse needed.
	for _, ins := range m.Funcs[0].Blocks[0].Instrs {
		if ins.Res != "" && len(ins.Args) != 2 {
			t.Errorf("%%%s (%s): %d args, want 2", ins.Res, ins.Op, len(ins.Args))
		}
	}
}
