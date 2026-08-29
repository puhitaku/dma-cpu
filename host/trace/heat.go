package trace

import (
	"fmt"
	"io"
	"sort"
	"strings"
)

// SiteMaxBytes bounds one comparison site's span: five compact
// records, the longest form (four moves and the jump). The next label
// normally ends a site well inside that — measured spans are 16, 32
// and 40 bytes — but a site whose successor label the table cannot see
// would otherwise swallow the code after it.
const SiteMaxBytes = 40

// Region is one profiled address range and the per-word read counts
// the emulator collected over it — emu.Machine.ProfileWindows in,
// ProfileCountsAt out, paired with the window it was given.
type Region struct {
	Name   string // for the report ("xip text", ".ramtext", "data")
	Lo     uint32 // window base, as passed to ProfileWindows
	Counts []uint32
	// Flash marks a window whose reads come off XIP flash. The
	// emulator charges them what it charges SRAM (no wait states are
	// modelled), so this only SPLITS the report: it says which reads
	// would park the shared read master on silicon.
	Flash bool
}

// Attribute folds the regions' read counts onto the table's labels.
// Pool-literal words are skipped wherever they fall — under
// dmaasm.Options.PoolText the cold half of the pool rides the text
// segment's tail, inside the same window as the code.
func (t *Table) Attribute(rs ...Region) *Heat {
	h := &Heat{t: t, lab: make([]labHeat, len(t.labs))}
	for _, r := range rs {
		if r.Name != "" {
			h.Regions = append(h.Regions, r.Name)
		}
		// The label span each word falls in, walked forward with the
		// window (both are in address order).
		si := sort.Search(len(t.labs), func(i int) bool { return t.labs[i].Addr > r.Lo })
		si--
		for i, c := range r.Counts {
			a := r.Lo + uint32(i)*4
			if t.lits[a] {
				h.Pool += uint64(c)
				continue
			}
			for si+1 < len(t.labs) && t.labs[si+1].Addr <= a {
				si++
			}
			if si < 0 || t.labs[si].Addr > a || a >= t.labs[si].Addr+t.labs[si].Size {
				h.Unowned += uint64(c)
				continue
			}
			l := &h.lab[si]
			l.reads += uint64(c)
			l.words++
			if r.Flash {
				l.flash += uint64(c)
				h.Flash += uint64(c)
			}
			h.Reads += uint64(c)
		}
	}
	return h
}

// labHeat is one label's share.
type labHeat struct {
	reads, flash uint64
	words        uint64 // words of the label that lay inside a window
}

// Heat is one attributed run.
type Heat struct {
	Reads   uint64 // words read inside the windows, code only
	Flash   uint64 // of those, from a Region marked Flash
	Pool    uint64 // literal-pool words read inside the windows
	Unowned uint64 // reads in a window that no label covers (padding, crt data)
	// Regions names the windows this heat came from, in the order they
	// were attributed; the report prints them so a figure is never
	// separated from the memory it was measured over.
	Regions []string

	t   *Table
	lab []labHeat
}

// Level selects an attribution level — what one row of a report is.
type Level int

const (
	// ByFunction folds every label onto its compiled function. The
	// shared helpers own themselves: `__cw_eqz` is a row, not a
	// contribution to whichever function precedes it in the image.
	ByFunction Level = iota
	// ByBlock resolves the same reads to `B_<func>_<block>`, the
	// granularity dmacc's Options.ColdBlocks consumes.
	ByBlock
	// BySite reports comparison sites (`cws_<func>_<n>`) in
	// EXECUTIONS, not reads: the two site forms are different lengths,
	// so raw reads would rank the sites the last profile made fast.
	BySite
	// ByHelper reports the runtime, millicode and outlined helpers.
	ByHelper
	// ByCategory groups dmacc's emission stubs by tag (`Cj`, `St`, `Ld`
	// …), which is as close to "by IR construct" as the labels get.
	// Read it as "reads under each tag", not "cost of the lowering":
	// the control-flow tags label an arm's entry, so a row covers the
	// stub AND the code it fronts, up to the next label.
	ByCategory
	// ByLabel reports every label, unfolded.
	ByLabel
)

var levelName = [...]string{"function", "block", "site", "helper", "category", "label"}

func (l Level) String() string {
	if int(l) < len(levelName) {
		return levelName[l]
	}
	return "level?"
}

// Entry is one row of a report.
type Entry struct {
	Name  string
	Kind  Kind
	Func  string // owning function, where the row is not itself one
	Reads uint64 // words fetched (= records executed, over text)
	Flash uint64 // of those, off XIP flash
	Bytes uint32 // static size of the owner
	Words uint64 // profiled words of the owner
	// Execs is Reads/Words: the number of times the owner ran. Exact
	// for a straight-line owner (a comparison site, a block with no
	// internal branch), an average over the body for anything bigger.
	Execs uint64
}

// By ranks the heat at one level, hottest first, ties by name. Owners
// that were never read are left out except at ByBlock, where a
// zero-read block inside a function that DID run is the whole point
// (that is the cold-block signal).
func (h *Heat) By(l Level) []Entry {
	agg := map[string]*Entry{}
	fnRead := map[string]uint64{}
	for i, lab := range h.t.labs {
		if lab.Func != "" {
			fnRead[lab.Func] += h.lab[i].reads
		}
	}
	for i, lab := range h.t.labs {
		lh := &h.lab[i]
		if lh.words == 0 {
			continue // outside every window
		}
		var key string
		var e Entry
		switch l {
		case ByFunction:
			switch {
			case lab.Func != "":
				key, e = lab.Func, Entry{Name: lab.Func, Kind: KindFunc}
			case lab.Helper != "":
				key, e = lab.Helper, Entry{Name: lab.Helper, Kind: lab.Kind}
			default:
				key, e = lab.Name, Entry{Name: lab.Name, Kind: lab.Kind}
			}
		case ByBlock:
			key = lab.Block
			if key == "" {
				continue
			}
			e = Entry{Name: key, Kind: KindBlock, Func: lab.Func}
		case BySite:
			if lab.Kind != KindSite {
				continue
			}
			key, e = lab.Name, Entry{Name: lab.Name, Kind: KindSite, Func: lab.Func}
		case ByHelper:
			if lab.Helper == "" {
				continue
			}
			key, e = lab.Helper, Entry{Name: lab.Helper, Kind: lab.Kind}
		case ByCategory:
			if lab.Kind != KindStub {
				continue
			}
			key, e = lab.Tag, Entry{Name: lab.Tag, Kind: KindStub}
		case ByLabel:
			key, e = lab.Name, Entry{Name: lab.Name, Kind: lab.Kind, Func: lab.Func}
		}
		a, ok := agg[key]
		if !ok {
			row := e
			a = &row
			agg[key] = a
		}
		a.Reads += lh.reads
		a.Flash += lh.flash
		a.Words += lh.words
		a.Bytes += lab.Size
	}
	out := make([]Entry, 0, len(agg))
	for _, a := range agg {
		e := *a
		if e.Reads == 0 && !(l == ByBlock && fnRead[e.Func] > 0) {
			continue
		}
		if l == BySite {
			// A site's span is capped the way its emission is: every
			// word of it is fetched once per execution.
			if e.Words > SiteMaxBytes/4 {
				e.Words = SiteMaxBytes / 4
			}
		}
		if e.Words > 0 {
			e.Execs = e.Reads / e.Words
		}
		out = append(out, e)
	}
	sort.Slice(out, func(i, j int) bool {
		a, b := out[i], out[j]
		if l == BySite && a.Execs != b.Execs {
			return a.Execs > b.Execs
		}
		if a.Reads != b.Reads {
			return a.Reads > b.Reads
		}
		return a.Name < b.Name
	})
	return out
}

// Total is the reads a level's rows share out, the denominator its
// percentages are taken against.
func (h *Heat) Total(l Level) uint64 {
	var n uint64
	for _, e := range h.By(l) {
		n += e.Reads
	}
	return n
}

// Report writes a ranked table of the top n rows at level l (n <= 0 =
// all of them), headed by title. This is the query the throwaway
// probes kept rewriting: "where do the reads go, by …?".
func (h *Heat) Report(w io.Writer, title string, l Level, n int) error {
	rows := h.By(l)
	tot := uint64(0)
	for _, e := range rows {
		tot += e.Reads
	}
	var b strings.Builder
	b.WriteString(title)
	if len(h.Regions) != 0 {
		fmt.Fprintf(&b, " [%s]", strings.Join(h.Regions, ", "))
	}
	fmt.Fprintf(&b, " — by %s: %d reads (%d off flash) over %d rows",
		l, tot, h.Flash, len(rows))
	if h.Pool != 0 || h.Unowned != 0 {
		fmt.Fprintf(&b, "; %d pool, %d unowned", h.Pool, h.Unowned)
	}
	b.WriteString("\n")
	head := "reads"
	if l == BySite {
		head = "execs"
	}
	fmt.Fprintf(&b, "  %-34s %-9s %12s %12s %7s %8s\n",
		"name", "kind", head, "flash", "share", "bytes")
	if n <= 0 || n > len(rows) {
		n = len(rows)
	}
	for _, e := range rows[:n] {
		v := e.Reads
		if l == BySite {
			v = e.Execs
		}
		share := 0.0
		if tot != 0 {
			share = 100 * float64(e.Reads) / float64(tot)
		}
		fmt.Fprintf(&b, "  %-34s %-9s %12d %12d %6.2f%% %8d\n",
			trunc(e.Name, 34), e.Kind, v, e.Flash, share, e.Bytes)
	}
	_, err := io.WriteString(w, b.String())
	return err
}

func trunc(s string, n int) string {
	if len(s) <= n {
		return s
	}
	return s[:n-1] + "…"
}
