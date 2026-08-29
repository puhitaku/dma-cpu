// Package trace attributes emulated machine activity back to code.
//
// Every optimization round in this tree started as "watching the
// trace" — a throwaway zz_ probe that counted emulator reads over one
// image's text and folded them onto function names. This package is
// that probe built once (prompts/042 §8): assemble, symbolize, count,
// rank, report.
//
// # What the emulator gives us, and what it does not
//
// The only machine-activity signal host/emu exposes is
// Machine.ProfileWindows: per-word bus-read counts over a set of
// address ranges. There is no per-record hook and no per-owner cycle
// counter, so the honest statement about precision is:
//
//   - Over an image's TEXT, a word read IS an instruction fetch: the
//     fetch channel is the only master that reads text words, and it
//     reads every word of a record it executes exactly once. So text
//     counts are exact EXECUTION counts, and Entry.Execs (reads
//     divided by the owner's own words) recovers the number of times a
//     straight-line owner ran.
//
//   - Cycles are not the same number. The machine spends one cycle per
//     word moved, of which the fetch is only a part: a record whose
//     exec half copies a kilobyte costs a thousand cycles and one
//     fetch. Text reads are therefore proportional to cycles for
//     ordinary code and understate the bulk-move records
//     (memcpy/memset, the framebuffer blits). Where the absolute
//     figure matters, price it with RunResult.Cycles and use this
//     package to say WHERE the records went.
//
//   - "Flash stalls" are not modelled. The emulator charges a flash
//     read exactly what it charges an SRAM read — no XIP wait states,
//     no cache. What it can say is WHICH reads would stall on silicon,
//     which is why Region carries a Flash flag: reads over an XIP text
//     window are the flash-read (read-master parking) signal that ranks
//     residency, and the report splits them out. Turning that into
//     cycles needs a silicon measurement, not a better query.
//
// # Ownership comes from the .dasm label stream
//
// dmaasm drops every `__`-prefixed label from Result.Symbols by
// default, so a nearest-preceding-symbol scan over that table credits
// the shared runtime and the comparison millicode (`__rt_*`, `__cw_*`,
// `__ol_*`) to whatever compiled function happens to precede them —
// the mistake prompts/042 §8 warns about, and the reason the throwaway
// probes grew a "rename `__` and assemble a twin" dance.
//
// Symbolize does it properly, from two sources that need each other:
//
//   - dmaasm.Options.InternalSyms gives the ADDRESS of every label,
//     internal ones included;
//   - the .dasm label stream — every label dmacc emitted appears as a
//     `name:` line in the source it handed the assembler — says which
//     of those names are real owners. The assembler mints names of its
//     own during layout (`__L<n>` inside compact macros, `__JP<n>` for
//     jump pairs) that name no code anyone wrote; they are absent from
//     the stream and are dropped. Names that are neither `__`-prefixed
//     nor in the stream (the `.regs` register file) are kept: they are
//     data cells a data-window profile should be able to name.
//
// The stream also breaks address ties in source order, so a leaf
// function whose `f_` and first `B_` label share a word resolves the
// way it was emitted.
//
// A `__` prefix is not by itself a claim of ownership, either. The
// outliner's open sites park a resume label (`__olr_<n>`) at the point
// the helper jumps back to, which is INSIDE the function that was
// outlined and is followed by that function's own records; only the
// helper bodies (`__ol_<n>`) are shared code. helperKind draws that
// line, and it is the one distinction the levels below cannot recover
// on their own.
//
// # Attribution levels
//
// Labels carry dmacc's naming scheme, so one profile answers several
// questions at once (Level):
//
//	ByFunction  compiled function (`f_`), with each runtime helper,
//	            millicode entry and outlined helper owning ITS own
//	            reads instead of leaking into a neighbour
//	ByBlock     `B_<func>_<block>` — the granularity Options.ColdBlocks
//	            consumes
//	BySite      `cws_<func>_<n>` — one comparison site, in executions
//	ByHelper    the runtime/millicode/outliner helpers alone
//	ByCategory  dmacc's emission tags (`Cj`, `St`, `Ld` …), the closest
//	            the labels get to "by IR construct"
//	ByLabel     every label, unfolded
//
// A label owns the bytes from it to the next label, which is exact for
// the entry-point levels (a function, a block and a comparison site
// each run from their label to the next one) and generous for the
// emission tags, whose labels head an ARM rather than a body.
//
// C source lines are NOT available. The IR goldens in the tree are
// compiled without -g, host/llir does not parse metadata, and nothing
// carries a location into .dasm; see prompts/042 §8 for the scoped
// list of what a C-line level would need.
package trace

import (
	"fmt"
	"sort"
	"strings"

	"github.com/puhitaku/dma-cpu/host/dmaasm"
)

// Kind is what a label names, as dmacc's naming scheme reports it.
type Kind uint8

const (
	KindOther     Kind = iota // anything unclassified (hand-written .dasm, crt data)
	KindFunc                  // f_<name>: a compiled function's entry
	KindBlock                 // B_<func>_<block>: one IR basic block
	KindSite                  // cws_<func>_<n>: one outlined comparison site
	KindStub                  // <Tag><n>_<func>: one of dmacc's emission categories
	KindMillicode             // __cw_*: the comparison millicode
	KindRuntime               // __rt_*: the shared runtime helpers
	KindOutline               // __ol_*: the record outliner's helpers
	KindStartup               // __start, warmstart, crtthunk: the crt
	KindCell                  // pl_/vs_/v_/lrs_/cw*: a compiler-owned data cell
)

var kindName = [...]string{"other", "func", "block", "site", "stub",
	"millicode", "runtime", "outline", "startup", "cell"}

func (k Kind) String() string {
	if int(k) < len(kindName) {
		return kindName[k]
	}
	return "kind?"
}

// Helper reports whether the kind is one of the shared helpers that
// owns its reads instead of folding into a caller.
func (k Kind) Helper() bool {
	return k == KindMillicode || k == KindRuntime || k == KindOutline
}

// Label is one owning name in an assembled image.
type Label struct {
	Name   string
	Addr   uint32
	Size   uint32 // bytes owned: up to the next label, or the segment end
	Kind   Kind
	Func   string // owning compiled function, "" where the label has none
	Block  string // owning B_ label, "" where unknown or not applicable
	Helper string // owning `__` helper, "" where the label has none
	Tag    string // KindStub: the emission tag ("Ct", "Ld", …)
	Seg    int    // image segment holding it (0 text, 1 data, 2 ramtext)
	Order  int    // position in the .dasm label stream, -1 if absent
}

// Table is one assembled image's label table: every owner, in address
// order, with the pool-literal addresses that must not be mistaken for
// code.
type Table struct {
	// Res is the image Symbolize assembled — the same bytes the
	// caller's own build produced (checked when a reference is given).
	Res *dmaasm.Result

	labs []Label
	lits map[uint32]bool
	segs [][2]uint32
}

// Symbolize assembles dasm with opts and returns its label table.
//
// The assembly is repeated here rather than taken from the caller
// because the table needs dmaasm.Options.InternalSyms, which a
// deployment build has no reason to set. Pass the caller's own Result
// as ref and the two images are compared byte for byte, so a table can
// never quietly describe a different build from the one that ran; pass
// nil when there is nothing to compare against (Table.Res is then the
// image to load).
func Symbolize(dasm string, opts dmaasm.Options, ref *dmaasm.Result) (*Table, error) {
	opts.InternalSyms = true
	res, err := dmaasm.Assemble(dasm, opts)
	if err != nil {
		return nil, fmt.Errorf("symbolize: %v", err)
	}
	if ref != nil {
		if err := sameImage(res, ref); err != nil {
			return nil, fmt.Errorf("symbolize: %v", err)
		}
	}
	return NewTable(dasm, res)
}

// NewTable builds the table from a .dasm source and an image already
// assembled from it with dmaasm.Options.InternalSyms set. Symbolize is
// the usual entry point; this one is for callers holding both halves
// already.
func NewTable(dasm string, res *dmaasm.Result) (*Table, error) {
	if res == nil || res.Image == nil {
		return nil, fmt.Errorf("trace: no image")
	}
	t := &Table{Res: res, lits: map[uint32]bool{}}
	for _, a := range res.LitAddrs {
		t.lits[a] = true
	}
	for _, s := range res.Image.Segments {
		t.segs = append(t.segs, [2]uint32{s.LinkAddr, s.LinkAddr + uint32(len(s.Data))})
	}
	stream := LabelStream(dasm)
	for name, addr := range res.Symbols {
		ord, inStream := stream[name]
		if !inStream {
			ord = -1
			// Assembler-minted internal names (`__L<n>`, `__JP<n>`, the
			// register file's reserved slots) name no code the source
			// wrote: they would only fragment their neighbour's span.
			if strings.HasPrefix(name, "__") {
				continue
			}
		}
		t.labs = append(t.labs, Label{Name: name, Addr: addr, Order: ord,
			Seg: t.segOf(addr)})
	}
	sort.Slice(t.labs, func(i, j int) bool {
		if t.labs[i].Addr != t.labs[j].Addr {
			return t.labs[i].Addr < t.labs[j].Addr
		}
		if t.labs[i].Order != t.labs[j].Order {
			return t.labs[i].Order < t.labs[j].Order
		}
		return t.labs[i].Name < t.labs[j].Name
	})
	t.classify()
	t.size()
	return t, nil
}

// LabelStream returns every label DEFINED in a .dasm source, mapped to
// its position in the file. Definitions are the `name:` prefixes
// dmaasm's own parser recognizes, several to a line; `.ifcompact`
// conditionals are not evaluated, because a label the assembly
// skipped simply never appears in the symbol table.
func LabelStream(src string) map[string]int {
	out := map[string]int{}
	n := 0
	for _, raw := range strings.Split(src, "\n") {
		text := raw
		if i := strings.IndexByte(text, ';'); i >= 0 {
			text = text[:i]
		}
		if i := strings.Index(text, "//"); i >= 0 {
			text = text[:i]
		}
		text = strings.TrimSpace(text)
		for text != "" {
			f := strings.Fields(text)
			if len(f) == 0 {
				break
			}
			name, ok := strings.CutSuffix(f[0], ":")
			if !ok || name == "" {
				break
			}
			if _, dup := out[name]; !dup {
				out[name] = n
				n++
			}
			text = strings.TrimSpace(text[len(f[0]):])
		}
	}
	return out
}

// Labels returns the table in address order.
func (t *Table) Labels() []Label { return t.labs }

// Lookup returns the label owning addr.
func (t *Table) Lookup(addr uint32) (Label, bool) {
	i := sort.Search(len(t.labs), func(i int) bool { return t.labs[i].Addr > addr })
	if i == 0 {
		return Label{}, false
	}
	l := t.labs[i-1]
	if addr >= l.Addr+l.Size {
		return Label{}, false
	}
	return l, true
}

// Funcs returns the compiled function names the image defines, sorted.
func (t *Table) Funcs() []string {
	var out []string
	for _, l := range t.labs {
		if l.Kind == KindFunc {
			out = append(out, l.Func)
		}
	}
	sort.Strings(out)
	return out
}

// IsPoolLit reports whether addr is a literal-pool word. Cold pool
// words ride the text segment's tail under dmaasm's PoolText, where
// they are data inside a text profile window; attribution skips them.
func (t *Table) IsPoolLit(addr uint32) bool { return t.lits[addr] }

func (t *Table) segOf(addr uint32) int {
	for i, s := range t.segs {
		if addr >= s[0] && addr < s[1] {
			return i
		}
	}
	return -1
}

// classify fills in Kind, Func, Block, Helper and Tag.
//
// The function a label belongs to comes from its NAME wherever dmacc
// puts one there, never from the label ahead of it: a stub moved to
// .ramtext under XIPText sits among strangers, and the name is the
// only thing that still knows whose it is. The BLOCK does come from
// the preceding labels — nothing encodes it — so it is only trusted
// while the chain's function agrees with the label's own. So does the
// owning HELPER: the runtime is hand-written .dasm whose internal
// labels (`rt_mul_loop`, `rt_mul_skip`) carry no marker at all, and
// left on their own they would each rank as a separate mystery.
func (t *Table) classify() {
	funcs := map[string]bool{}
	for i := range t.labs {
		if n, ok := strings.CutPrefix(t.labs[i].Name, "f_"); ok {
			t.labs[i].Kind, t.labs[i].Func = KindFunc, n
			funcs[n] = true
		}
	}
	helpers := map[string]Kind{}
	for _, l := range t.labs {
		if k := helperKind(l.Name); k != KindOther {
			helpers[l.Name] = k
		}
	}
	longest := func(s string) (string, string) { return splitFunc(s, funcs) }
	curFn, curBlk, curHlp, curSeg := "", "", "", -2
	for i := range t.labs {
		l := &t.labs[i]
		if l.Seg != curSeg {
			curFn, curBlk, curHlp, curSeg = "", "", "", l.Seg
		}
		switch {
		case l.Kind == KindFunc:
			curFn, curBlk, curHlp = l.Func, "", ""
		case strings.HasPrefix(l.Name, "B_"):
			l.Kind = KindBlock
			l.Func, _ = longest(l.Name[2:])
			if l.Func != "" {
				curFn = l.Func
			}
			curBlk, l.Block, curHlp = l.Name, l.Name, ""
		case strings.HasPrefix(l.Name, "cws_"):
			l.Kind = KindSite
			l.Func, _ = longest(l.Name[4:])
		case helperKind(l.Name) != KindOther:
			// A helper's own continuation labels (`__cw_lt_t` under
			// `__cw_lt`) belong to it; a differently named helper next
			// door starts its own group.
			l.Helper = ancestorHelper(l.Name, helpers)
			l.Kind = helpers[l.Helper]
			curFn, curBlk, curHlp = "", "", l.Helper
		case l.Name == "__start" || l.Name == "warmstart" || l.Name == "crtthunk":
			l.Kind, curFn, curBlk, curHlp = KindStartup, "", "", ""
		default:
			l.Kind, l.Tag, l.Func = cellOrStub(l.Name, funcs)
		}
		if l.Kind == KindStub || l.Kind == KindOther {
			if l.Func == "" {
				l.Func, l.Block, l.Helper = curFn, curBlk, curHlp
				if curHlp != "" {
					l.Kind = helpers[curHlp]
				}
			} else if l.Func == curFn {
				l.Block = curBlk
			}
		}
	}
}

// splitFunc is the disambiguator for the `<tag>_<func>_<rest>` labels
// (`B_`, `cws_`): a C name may hold underscores of its own, and
// dmacc's recursion clones append `__r2` / `__rt` to it, so the split
// point is whichever KNOWN function name matches farthest to the
// right. Returns the owning function and the rest, or "" and the
// whole string when no function claims it.
func splitFunc(s string, funcs map[string]bool) (string, string) {
	for i := len(s); i > 0; i-- {
		if s[i-1] != '_' {
			continue
		}
		if fn := s[:i-1]; funcs[fn] {
			return fn, s[i:]
		}
	}
	return "", s
}

// helperKind classifies a shared-helper label by dmacc's naming.
//
// `__olr_<n>` is deliberately NOT one of them, close as the name sits
// to `__ol_<n>`. An open outlining site parks a resume label, jumps to
// the helper, and the helper jumps back — so `__olr_<n>` marks the
// point control RETURNS to, inside the function that was outlined, and
// the records behind it are that function's own (outline.go, "site:
// park + jump"). Reading it as a helper would cut a function's body in
// half at every open site and file the tail under a stub that owns no
// code at all.
func helperKind(name string) Kind {
	switch {
	case strings.HasPrefix(name, "__cw_"):
		return KindMillicode
	case strings.HasPrefix(name, "__rt_"):
		return KindRuntime
	case strings.HasPrefix(name, "__ol_"):
		return KindOutline // the helper bodies and the shared __ol_ret cell
	}
	return KindOther
}

// ancestorHelper folds a helper's continuation label into the helper
// it continues: `__cw_lt_t` under `__cw_lt`, but `__cw_eqzp` (no
// separator) and `__rt_udivmod10` stand on their own.
func ancestorHelper(name string, helpers map[string]Kind) string {
	best := ""
	for h := range helpers {
		if h == name || !strings.HasPrefix(name, h+"_") {
			continue
		}
		if len(h) > len(best) {
			best = h // the most specific parent wins
		}
	}
	if best == "" {
		return name
	}
	return best
}

// cellOrStub classifies the labels dmacc mints inside a function: the
// per-block emission stubs (`<Tag><n>_<func>`, func.go stub()) and the
// data cells that hold a function's SSA values and spill pool
// (`v_`/`vs_`/`pl_`/`lrs_`).
func cellOrStub(name string, funcs map[string]bool) (Kind, string, string) {
	for _, p := range []string{"v_", "vs_", "pl_", "lrs_"} {
		if rest, ok := strings.CutPrefix(name, p); ok {
			for fn := range funcs {
				if rest == fn || strings.HasPrefix(rest, fn+"_") {
					return KindCell, "", fn
				}
			}
			return KindCell, "", ""
		}
	}
	if strings.HasPrefix(name, "cw") {
		return KindCell, "", "" // cw_a…cw_pa operands, cwc_/cwd_ descriptors
	}
	// A stub is <Tag><ordinal>_<function>: the tag is letters, the
	// ordinal digits, and everything past the first underscore is the
	// function that asked for it.
	i := strings.IndexByte(name, '_')
	if i <= 0 {
		return KindOther, "", ""
	}
	head, fn := name[:i], name[i+1:]
	tag := strings.TrimRight(head, "0123456789")
	if tag == "" || tag == head || !funcs[fn] {
		return KindOther, "", ""
	}
	for _, r := range tag {
		if !(r >= 'A' && r <= 'Z' || r >= 'a' && r <= 'z') {
			return KindOther, "", ""
		}
	}
	return KindStub, tag, fn
}

// size gives every label the bytes from it to the next label at a
// HIGHER address, clamped to its own segment. Labels sharing an
// address (an empty function in front of the next one, a leaf whose
// `f_` and entry-block labels coincide) all span the same range;
// Attribute hands the words to the last of the group, so the earlier
// ones read zero and drop out of the report.
func (t *Table) size() {
	for i := range t.labs {
		l := &t.labs[i]
		if l.Seg < 0 {
			continue
		}
		end := t.segs[l.Seg][1]
		for j := i + 1; j < len(t.labs); j++ {
			if t.labs[j].Addr > l.Addr {
				if t.labs[j].Addr < end {
					end = t.labs[j].Addr
				}
				break
			}
		}
		if end > l.Addr {
			l.Size = end - l.Addr
		}
	}
}

// sameImage reports whether two assemblies produced the same bytes at
// the same addresses.
func sameImage(got, want *dmaasm.Result) error {
	if len(got.Image.Segments) != len(want.Image.Segments) {
		return fmt.Errorf("%d segments, reference has %d",
			len(got.Image.Segments), len(want.Image.Segments))
	}
	for i, s := range got.Image.Segments {
		r := want.Image.Segments[i]
		if s.LinkAddr != r.LinkAddr || len(s.Data) != len(r.Data) {
			return fmt.Errorf("segment %d links %#x/%d bytes, reference %#x/%d",
				i, s.LinkAddr, len(s.Data), r.LinkAddr, len(r.Data))
		}
		for j := range s.Data {
			if s.Data[j] != r.Data[j] {
				return fmt.Errorf("segment %d differs from the reference at +%#x", i, j)
			}
		}
	}
	return nil
}
