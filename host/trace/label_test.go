package trace

import "testing"

func TestLabelStream(t *testing.T) {
	src := `; a comment: not_a_label:
.data
exitcode: .word 0      // trailing comment: nope:
f_a: B_a_0: move $1, exitcode
__cw_eq:
  move exitcode, %pc
f_a:
`
	got := LabelStream(src)
	want := map[string]int{"exitcode": 0, "f_a": 1, "B_a_0": 2, "__cw_eq": 3}
	if len(got) != len(want) {
		t.Fatalf("stream = %v, want %v", got, want)
	}
	for n, i := range want {
		if got[n] != i {
			t.Errorf("%q at %d, want %d", n, got[n], i)
		}
	}
	if _, ok := got["not_a_label"]; ok {
		t.Error("a label inside a comment made it into the stream")
	}
	if _, ok := got["nope"]; ok {
		t.Error("a label inside a // comment made it into the stream")
	}
}

// TestBlockNameSplit: a C name may hold underscores, and dmacc's
// recursion clones append `__r2` / `__rt` to it, so `B_<func>_<block>`
// only splits correctly against the set of known function names.
func TestBlockNameSplit(t *testing.T) {
	funcs := map[string]bool{"read_line": true, "read": true, "sh__r2": true}
	for _, c := range []struct{ label, fn, rest string }{
		{"read_line_3", "read_line", "3"},
		{"read_3", "read", "3"},
		{"sh__r2_entry", "sh__r2", "entry"},
		{"unknown_0", "", "unknown_0"},
	} {
		fn, rest := splitFunc(c.label, funcs)
		if fn != c.fn || rest != c.rest {
			t.Errorf("B_%s -> (%q,%q), want (%q,%q)", c.label, fn, rest, c.fn, c.rest)
		}
	}
}

func TestCellOrStub(t *testing.T) {
	funcs := map[string]bool{"steps": true, "read_line": true}
	for _, c := range []struct {
		name string
		kind Kind
		tag  string
		fn   string
	}{
		{"Ct1_steps", KindStub, "Ct", "steps"},
		{"Swi12_read_line", KindStub, "Swi", "read_line"},
		{"pl_steps_3", KindCell, "", "steps"},
		{"vs_read_line_0", KindCell, "", "read_line"},
		{"lrs_steps", KindCell, "", "steps"},
		{"cw_a", KindCell, "", ""},
		{"cwd_7", KindCell, "", ""},
		{"Ct1_nosuchfunc", KindOther, "", ""},
		{"warmstart", KindOther, "", ""},
		{"rt_mul_loop", KindOther, "", ""},
		// An outliner resume label names no owner of its own: it falls
		// through to the chain, which is the function it sits inside.
		{"__olr_7", KindOther, "", ""},
	} {
		k, tag, fn := cellOrStub(c.name, funcs)
		if k != c.kind || tag != c.tag || fn != c.fn {
			t.Errorf("%s -> (%v,%q,%q), want (%v,%q,%q)",
				c.name, k, tag, fn, c.kind, c.tag, c.fn)
		}
	}
}

// TestHelperKind: which `__` names are shared helpers that own their
// own reads. The one that bites is the outliner pair — `__ol_<n>` is a
// helper BODY, `__olr_<n>` is the resume label of an open site and
// belongs to the function it sits inside (host/trace helperKind).
func TestHelperKind(t *testing.T) {
	for _, c := range []struct {
		name string
		kind Kind
	}{
		{"__cw_lt", KindMillicode},
		{"__rt_mul", KindRuntime},
		{"__ol_1", KindOutline},
		{"__ol_ret", KindOutline},
		{"__olr_1", KindOther},
		{"__olr_21", KindOther},
		{"f_main", KindOther},
	} {
		if got := helperKind(c.name); got != c.kind {
			t.Errorf("helperKind(%q) = %v, want %v", c.name, got, c.kind)
		}
	}
}

// TestAncestorHelper: a helper's continuation labels fold into it, and
// helpers whose names merely share a prefix do not.
func TestAncestorHelper(t *testing.T) {
	helpers := map[string]Kind{}
	for _, n := range []string{"__cw_eq", "__cw_eqz", "__cw_eqzp", "__cw_eq_e",
		"__cw_eqz_n", "__cw_eqzp_d", "__rt_udiv", "__rt_udivmod", "__ol_1"} {
		helpers[n] = helperKind(n)
	}
	for _, c := range []struct{ name, want string }{
		{"__cw_eq_e", "__cw_eq"},
		{"__cw_eqz_n", "__cw_eqz"},
		{"__cw_eqzp_d", "__cw_eqzp"},
		{"__cw_eqz", "__cw_eqz"},   // not a continuation of __cw_eq
		{"__cw_eqzp", "__cw_eqzp"}, // nor of __cw_eqz
		{"__rt_udivmod", "__rt_udivmod"},
		{"__ol_1", "__ol_1"},
	} {
		if got := ancestorHelper(c.name, helpers); got != c.want {
			t.Errorf("%s folds into %q, want %q", c.name, got, c.want)
		}
	}
}
