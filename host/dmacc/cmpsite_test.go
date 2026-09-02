package dmacc_test

// Per-site comparison selection (prompts/042 §10c): the `cws_` site
// labels compare.go emits, and the Options.HotSites decision they key.

import (
	"sort"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/dmacc"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/llir"
)

// cmpSitesIR has four comparison sites in one function, all with
// operands that have a word address (two parameters and two constants),
// so every one of them CAN take the descriptor form and the only thing
// deciding is the policy under test.
const cmpSitesIR = `
define i32 @sites(i32 %a, i32 %b) {
entry:
  %c0 = icmp slt i32 %a, %b
  br i1 %c0, label %one, label %two
one:
  %c1 = icmp eq i32 %a, 7
  br i1 %c1, label %two, label %three
two:
  %c2 = icmp ult i32 %b, 9
  br i1 %c2, label %three, label %four
three:
  %c3 = icmp sgt i32 %a, %b
  br i1 %c3, label %four, label %five
four:
  ret i32 1
five:
  ret i32 2
}

define i32 @main() {
entry:
  %r = call i32 @sites(i32 3, i32 4)
  ret i32 %r
}
`

// siteForms reads back the form every labelled site took: "four" for
// the four-move protocol, "desc" for the two-record descriptor,
// "inline" for the full compare macro. The records of a site run from
// its label to the next label.
func siteForms(dasm string) map[string]string {
	out := map[string]string{}
	site := ""
	for _, raw := range strings.Split(dasm, "\n") {
		l := raw
		if i := strings.IndexByte(l, ';'); i >= 0 {
			l = l[:i]
		}
		t := strings.TrimSpace(l)
		switch {
		case t == "":
		case !strings.HasPrefix(l, " ") && strings.HasSuffix(t, ":"):
			site = ""
			if n := strings.TrimSuffix(t, ":"); strings.HasPrefix(n, "cws_") {
				site = n
				out[site] = "?"
			}
		case site != "":
			switch {
			case strings.HasSuffix(t, ", cw_d"):
				out[site] = "desc"
			case strings.HasSuffix(t, ", cw_t"):
				out[site] = "four"
			case strings.HasPrefix(t, "jeq ") || strings.HasPrefix(t, "jlt ") ||
				strings.HasPrefix(t, "jltu ") || strings.HasPrefix(t, "jbool "):
				out[site] = "inline"
			}
			site = ""
		}
	}
	return out
}

func siteNames(forms map[string]string) []string {
	var ns []string
	for n := range forms {
		ns = append(ns, n)
	}
	sort.Strings(ns)
	return ns
}

func compileSites(t *testing.T, opts dmacc.Options) string {
	t.Helper()
	m, err := llir.Parse(cmpSitesIR)
	if err != nil {
		t.Fatal(err)
	}
	opts.XIPText = true // descriptors are flash rodata; XIP emits them
	dasm, err := dmacc.Compile(m, opts)
	if err != nil {
		t.Fatal(err)
	}
	return dasm
}

// TestCmpSiteLabels pins the label contract: one label per site, named
// for the function and the site's ordinal in emission order, and the
// SAME names whatever form the sites take — that stability is what lets
// a profile collected from one build steer the next.
func TestCmpSiteLabels(t *testing.T) {
	t.Parallel()
	want := []string{"cws_sites_1", "cws_sites_2", "cws_sites_3", "cws_sites_4"}
	for _, tc := range []struct {
		name string
		opts dmacc.Options
	}{
		{"balanced", dmacc.Options{}},
		{"optsize", dmacc.Options{OptSize: true}},
		{"hotfunc", dmacc.Options{OptSize: true, HotFuncs: map[string]bool{"sites": true}}},
		{"hotsite", dmacc.Options{OptSize: true,
			HotSites: map[string]bool{"cws_sites_2": true}}},
		{"inlinesite", dmacc.Options{OptSize: true,
			InlineSites: map[string]bool{"cws_sites_2": true}}},
	} {
		got := siteNames(siteForms(compileSites(t, tc.opts)))
		if strings.Join(got, ",") != strings.Join(want, ",") {
			t.Errorf("%s: sites %v, want %v", tc.name, got, want)
		}
	}
	// Two compiles of the same input agree down to the byte, labels
	// included (TestDeterminism covers the whole tree; this is the
	// property the site identity itself depends on).
	if a, b := compileSites(t, dmacc.Options{OptSize: true}),
		compileSites(t, dmacc.Options{OptSize: true}); a != b {
		t.Error("recompile differs")
	}
}

// TestCmpSiteSymbols checks the labels survive assembly into
// Result.Symbols, inside the text they name — the PGO driver reads site
// addresses from exactly there, and dmaasm drops `__`-prefixed labels.
func TestCmpSiteSymbols(t *testing.T) {
	t.Parallel()
	v, err := emu.VariantByName("rp2350")
	if err != nil {
		t.Fatal(err)
	}
	const textBase, dataBase, ramBase = 0x40000000, 0x50000000, 0x60000000
	res, err := dmaasm.Assemble(compileSites(t, dmacc.Options{OptSize: true}),
		dmaasm.Options{Variant: v, Compact: true,
			TextBase: textBase, DataBase: dataBase, RAMTextBase: ramBase})
	if err != nil {
		t.Fatal(err)
	}
	textEnd := uint32(textBase + len(res.Image.Segments[0].Data))
	n := 0
	for name, addr := range res.Symbols {
		if !strings.HasPrefix(name, "cws_") {
			continue
		}
		n++
		if addr < textBase || addr >= textEnd {
			t.Errorf("%s at %#x, outside text [%#x,%#x)", name, addr, textBase, textEnd)
		}
	}
	if n != 4 {
		t.Errorf("%d cws_ symbols in the image, want 4", n)
	}
}

// TestCmpSiteHotSites is the per-site decision itself, in both
// directions: a hot site keeps four moves inside a size-optimized
// function, and a cold site drops to a descriptor inside a HOT one —
// which per-function granularity could not express.
func TestCmpSiteHotSites(t *testing.T) {
	t.Parallel()
	hot := map[string]bool{"cws_sites_2": true}
	for _, tc := range []struct {
		name string
		opts dmacc.Options
		want map[string]string
	}{
		{"promote a site in a cold function",
			dmacc.Options{OptSize: true, HotSites: hot},
			map[string]string{"cws_sites_1": "desc", "cws_sites_2": "four",
				"cws_sites_3": "desc", "cws_sites_4": "desc"}},
		{"demote the cold sites of a hot function",
			dmacc.Options{OptSize: true, HotSites: hot,
				HotFuncs: map[string]bool{"sites": true}},
			map[string]string{"cws_sites_1": "desc", "cws_sites_2": "four",
				"cws_sites_3": "desc", "cws_sites_4": "desc"}},
		{"no profile: the per-function rule stands (hot)",
			dmacc.Options{OptSize: true, HotFuncs: map[string]bool{"sites": true}},
			map[string]string{"cws_sites_1": "four", "cws_sites_2": "four",
				"cws_sites_3": "four", "cws_sites_4": "four"}},
		{"no profile: the per-function rule stands (cold)",
			dmacc.Options{OptSize: true},
			map[string]string{"cws_sites_1": "desc", "cws_sites_2": "desc",
				"cws_sites_3": "desc", "cws_sites_4": "desc"}},
		{"a balanced build ignores the profile",
			dmacc.Options{HotSites: hot},
			map[string]string{"cws_sites_1": "four", "cws_sites_2": "four",
				"cws_sites_3": "four", "cws_sites_4": "four"}},
	} {
		got := siteForms(compileSites(t, tc.opts))
		for _, n := range siteNames(tc.want) {
			if got[n] != tc.want[n] {
				t.Errorf("%s: %s is %q, want %q", tc.name, n, got[n], tc.want[n])
			}
		}
	}
}

// boolSiteIR branches on an i1 that facts.go can prove is 0 or 1 (the
// `and` of two comparisons), which is the shape emitBoolBranch inlines
// as jbool rather than as a full-range jeq against zero.
const boolSiteIR = `
define i32 @bsite(i32 %a, i32 %b) {
entry:
  %c0 = icmp slt i32 %a, %b
  %c1 = icmp eq i32 %a, 7
  %c2 = and i1 %c0, %c1
  br i1 %c2, label %one, label %two
one:
  ret i32 1
two:
  ret i32 2
}

define i32 @main() {
entry:
  %r = call i32 @bsite(i32 3, i32 4)
  ret i32 %r
}
`

// TestCmpSiteInlineSites is the third form (prompts/042 §1): a named
// site takes the whole inline macro, keeps its label, and leaves its
// siblings exactly where the outlined policy put them.
func TestCmpSiteInlineSites(t *testing.T) {
	t.Parallel()
	in := map[string]bool{"cws_sites_2": true}
	for _, tc := range []struct {
		name string
		opts dmacc.Options
		want map[string]string
	}{
		{"one site inline, the rest descriptors",
			dmacc.Options{OptSize: true, InlineSites: in},
			map[string]string{"cws_sites_1": "desc", "cws_sites_2": "inline",
				"cws_sites_3": "desc", "cws_sites_4": "desc"}},
		{"inline beats the four-move set at the same site",
			dmacc.Options{OptSize: true, InlineSites: in,
				HotSites: map[string]bool{"cws_sites_1": true, "cws_sites_2": true}},
			map[string]string{"cws_sites_1": "four", "cws_sites_2": "inline",
				"cws_sites_3": "desc", "cws_sites_4": "desc"}},
		{"inline beats a hot function too",
			dmacc.Options{OptSize: true, InlineSites: in,
				HotFuncs: map[string]bool{"sites": true}},
			map[string]string{"cws_sites_1": "four", "cws_sites_2": "inline",
				"cws_sites_3": "four", "cws_sites_4": "four"}},
		{"a balanced build inlines too: OptSize does not gate this one",
			dmacc.Options{InlineSites: in},
			map[string]string{"cws_sites_1": "four", "cws_sites_2": "inline",
				"cws_sites_3": "four", "cws_sites_4": "four"}},
		// Residency rules out the DESCRIPTOR form — the descriptor would
		// live in flash text and be loaded with the XIP window down —
		// and nothing else. The macro has no descriptor and no helper
		// call, so a named resident site takes it; its unnamed siblings
		// fall to four-move rather than to descriptors.
		{".ramtext: descriptors are out, the macro is not",
			dmacc.Options{OptSize: true, InlineSites: in,
				RAMTextFuncs: []string{"sites"}},
			map[string]string{"cws_sites_1": "four", "cws_sites_2": "inline",
				"cws_sites_3": "four", "cws_sites_4": "four"}},
	} {
		got := siteForms(compileSites(t, tc.opts))
		for _, n := range siteNames(tc.want) {
			if got[n] != tc.want[n] {
				t.Errorf("%s: %s is %q, want %q", tc.name, n, got[n], tc.want[n])
			}
		}
	}
}

// TestCmpSiteInlineBool pins the one lowering that is not a plain
// helper-to-macro mapping: a branch on a proven i1 inlines as jbool (6
// records), and the label still lands on it.
func TestCmpSiteInlineBool(t *testing.T) {
	t.Parallel()
	mod, err := llir.Parse(boolSiteIR)
	if err != nil {
		t.Fatal(err)
	}
	dasm, err := dmacc.Compile(mod, dmacc.Options{XIPText: true, OptSize: true,
		InlineSites: map[string]bool{"cws_bsite_3": true}})
	if err != nil {
		t.Fatal(err)
	}
	forms := siteForms(dasm)
	if forms["cws_bsite_3"] != "inline" {
		t.Errorf("the bool branch is %q, want inline", forms["cws_bsite_3"])
	}
	if !strings.Contains(dasm, "cws_bsite_3:\n    jbool ") {
		t.Error("the inline bool branch is not a jbool")
	}
	for _, n := range []string{"cws_bsite_1", "cws_bsite_2"} {
		if forms[n] != "desc" {
			t.Errorf("%s is %q, want desc", n, forms[n])
		}
	}
}

// TestCmpSiteEmptyProfileIsInert is the mutation test: an EMPTY HotSites
// map must compile byte-identically to no map at all, on a whole real
// image and under both compare policies. Without this an image built
// before its profile existed could silently shrink to descriptors
// everywhere.
func TestCmpSiteEmptyProfileIsInert(t *testing.T) {
	t.Parallel()
	// Compile mutates the module it lowers (alias resolution, ICF), so
	// each build gets a freshly parsed one — the same discipline
	// TestDeterminism uses.
	build := func(opts dmacc.Options) string {
		t.Helper()
		mod, err := llir.Merge(
			parseLL(t, "../../target/xv6/ll/sh.ll"), parseLL(t, "../../target/xv6/ll/ulib.ll"),
			parseLL(t, "../../target/xv6/ll/umalloc.ll"), parseLL(t, "../../target/xv6/ll/usys.ll"))
		if err != nil {
			t.Fatal(err)
		}
		dasm, err := dmacc.Compile(mod, opts)
		if err != nil {
			t.Fatal(err)
		}
		return dasm
	}
	for _, tc := range []struct {
		name string
		opts dmacc.Options
	}{
		{"optsize", dmacc.Options{RecursionDepth: 2, XIPText: true, OptSize: true}},
		{"optsize+hotfuncs", dmacc.Options{RecursionDepth: 2, XIPText: true, OptSize: true,
			HotFuncs: map[string]bool{"main": true, "runcmd": true, "getcmd": true}}},
		{"balanced", dmacc.Options{RecursionDepth: 2, XIPText: true}},
	} {
		base := build(tc.opts)
		tc.opts.HotSites = map[string]bool{}
		with := build(tc.opts)
		if base != with {
			t.Errorf("%s: an empty HotSites map changed the output", tc.name)
		}
		tc.opts.HotSites = nil
		tc.opts.InlineSites = map[string]bool{}
		if build(tc.opts) != base {
			t.Errorf("%s: an empty InlineSites map changed the output", tc.name)
		}
		if n := len(siteForms(base)); n < 100 {
			t.Errorf("%s: only %d labelled sites; the check proves little", tc.name, n)
		}
	}
}
