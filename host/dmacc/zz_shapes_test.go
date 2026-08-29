package dmacc_test

import (
	"encoding/binary"
	"fmt"
	"os"
	"sort"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/dmacc"
	"github.com/puhitaku/dma-cpu/host/emu"
	"github.com/puhitaku/dma-cpu/host/img"
	"github.com/puhitaku/dma-cpu/host/llir"
	"github.com/puhitaku/dma-cpu/host/pgo"
)

// TestZZShapes is the measurement side of prompts/043 (compact encoding
// v2): it histograms the RECORD SHAPES of every deployable image and
// prices the candidate 4-byte encodings against them.
//
// A compact record is exactly two link-time addresses, (READ_ADDR,
// WRITE_ADDR) — there is no CTRL word and no count field, so "the
// record with its variable operands abstracted out" can only mean one
// of three things, and the probe reports all three:
//
//   - the EXACT pair (S, D): the shape a zero-operand dictionary index
//     would name;
//   - the pair with the source abstracted, (*, D): the shape a
//     destination-sticky half record names;
//   - the pair with the destination abstracted, (S, *): the shape a
//     source-sticky half record names.
//
// The probe also reconstructs the bank window state across the record
// stream (the same classification host/dmacc/zz_banktax_test.go makes at
// runtime, done statically here) so half-mode candidacy can be limited
// to the plain and sniff banks — the two that chain straight back to
// fetch. Auto-return banks go through cleanup, which rewrites fetch's
// write pointer with the 8-byte plain window and would drop the machine
// out of any half mode.
//
//	SHAPES=1 go test ./host/dmacc/ -run TestZZShapes -v
func TestZZShapes(t *testing.T) {
	if os.Getenv("SHAPES") == "" {
		t.Skip("set SHAPES=1 to histogram compact record shapes")
	}
	t.Parallel()
	for _, im := range shapeImages(t) {
		analyzeShapes(t, im)
	}
}

// --- image set ---

type shapeImage struct {
	name string
	dasm string
	opts dmaasm.Options
}

func shapeImages(t *testing.T) []shapeImage {
	t.Helper()
	v, _ := emu.VariantByName("rp2350")
	// Bases chosen to keep every operand class distinguishable: text and
	// ramtext away from SRAM, data away from the DMA register block at
	// 0x50000000 (which TestZZAllSizes happens to overlap — harmless
	// there, fatal to an operand classifier).
	base := dmaasm.Options{Variant: v, Compact: true,
		TextBase: 0x10000000, DataBase: 0x20010000, RAMTextBase: 0x20000000}

	user := func(t *testing.T, name string, opts dmacc.Options, extra ...string) string {
		t.Helper()
		mods := []*llir.Module{parseLL(t, "../../target/xv6/ll/"+name+".ll"),
			parseLL(t, "../../target/xv6/ll/ulib.ll"),
			parseLL(t, "../../target/xv6/ll/usys.ll")}
		for _, e := range extra {
			mods = append(mods, parseLL(t, "../../target/xv6/ll/"+e+".ll"))
		}
		mod, err := llir.Merge(mods...)
		if err != nil {
			t.Fatal(err)
		}
		dasm, err := dmacc.Compile(mod, opts)
		if err != nil {
			t.Fatal(err)
		}
		return dasm
	}

	return []shapeImage{
		{"fs-kern-xip", compileKernelOpts(t, true, true), base},
		{"fs-xip-pgo", compileKernelPGO(t), base},
		{"sh(K2)", user(t, "sh", dmacc.Options{RecursionDepth: 2}, "umalloc"), base},
		{"vi", user(t, "vi", dmacc.Options{XIPText: true, ColdBlocks: pgo.ViColdBlocks},
			"umalloc"), base},
		{"game", compileGameDasm(t), base},
	}
}

// --- record extraction ---

// A rec is one 8-byte compact record at link address addr.
type rec struct {
	addr uint32
	s, d uint32
	bank int  // reconstructed window at the time it is fetched
	tgt  bool // a label or jump target lands here
	smod bool // some record in the image writes into this record
}

// descStart finds the byte offset in the text segment where dmacc's
// constant flash rodata (the comparison descriptors and `constant`
// globals of an XIPText image) begins. Everything before it is records;
// everything from it on is .word data and must not be decoded.
func descStart(dasm string, res *dmaasm.Result, seg img.Segment) uint32 {
	end := seg.LinkAddr + uint32(len(seg.Data))
	i := strings.Index(dasm, "; --- comparison descriptors")
	if i < 0 {
		return end
	}
	for _, ln := range strings.Split(dasm[i:], "\n") {
		ln = strings.TrimSpace(ln)
		j := strings.Index(ln, ":")
		if j <= 0 || strings.HasPrefix(ln, ";") || strings.HasPrefix(ln, ".") {
			continue
		}
		if a, ok := res.Symbols[ln[:j]]; ok && a >= seg.LinkAddr && a <= end {
			return a
		}
	}
	return end
}

// word reads the link-time word at addr out of the assembled image.
func word(im *img.Image, addr uint32) (uint32, bool) {
	for _, s := range im.Segments {
		if addr >= s.LinkAddr && addr+4 <= s.LinkAddr+uint32(len(s.Data)) {
			return binary.LittleEndian.Uint32(s.Data[addr-s.LinkAddr:]), true
		}
	}
	return 0, false
}

// --- analysis ---

type analysis struct {
	name string
	res  *dmaasm.Result
	v    *emu.Variant
	recs []rec

	textLo, textHi uint32 // record region of segment 0
	rodata         int    // .word bytes in the text tail
	ramLo, ramHi   uint32

	litVal  map[uint32]uint32 // pool word address -> value
	symAt   map[uint32]string
	fnStart []uint32
	fnName  map[uint32]string
}

func analyzeShapes(t *testing.T, im shapeImage) {
	t.Helper()
	res, err := dmaasm.Assemble(im.dasm, im.opts)
	if err != nil {
		t.Fatalf("%s: %v", im.name, err)
	}
	a := &analysis{name: im.name, res: res, v: im.opts.Variant,
		litVal: map[uint32]uint32{}, symAt: map[uint32]string{},
		fnName: map[uint32]string{}}

	text := res.Image.Segments[0]
	ds := descStart(im.dasm, res, text)
	a.textLo, a.textHi = text.LinkAddr, ds
	a.rodata = int(text.LinkAddr) + len(text.Data) - int(ds)
	if len(res.Image.Segments) > 2 {
		rt := res.Image.Segments[2]
		a.ramLo, a.ramHi = rt.LinkAddr, rt.LinkAddr+uint32(len(rt.Data))
	}

	for _, addr := range res.LitAddrs {
		if v, ok := word(res.Image, addr); ok {
			a.litVal[addr] = v
		}
	}
	for n, addr := range res.Symbols {
		if old, ok := a.symAt[addr]; !ok || len(n) < len(old) {
			a.symAt[addr] = n
		}
		if strings.HasPrefix(n, "f_") {
			a.fnStart = append(a.fnStart, addr)
			a.fnName[addr] = n
		}
	}
	sort.Slice(a.fnStart, func(i, j int) bool { return a.fnStart[i] < a.fnStart[j] })

	a.decode()
	a.report(t)
}

// decode walks the two record regions, reconstructing the bank window
// as it goes and marking branch targets and self-modified records.
func (a *analysis) decode() {
	swDst := emu.ChanRegAddr(emu.CompactFetch, emu.OffAl3WriteAddr)
	winBank := map[uint32]int{}
	for b := 0; b < emu.CompactNumBanks; b++ {
		winBank[emu.CompactWindow(b)] = b
	}
	regions := [][2]uint32{{a.textLo, a.textHi}}
	if a.ramHi != 0 {
		regions = append(regions, [2]uint32{a.ramLo, a.ramHi})
	}
	for _, r := range regions {
		bank := emu.CompactPlain
		for addr := r[0]; addr+8 <= r[1]; addr += 8 {
			s, _ := word(a.res.Image, addr)
			d, _ := word(a.res.Image, addr+4)
			rc := rec{addr: addr, s: s, d: d, bank: bank}
			a.recs = append(a.recs, rc)
			switch {
			case d == swDst:
				if b, ok := winBank[a.litVal[s]]; ok {
					bank = b
				}
			case emu.CompactAutoReturn(bank):
				bank = emu.CompactPlain
			}
		}
	}
	// Branch targets: every text symbol, plus every pool literal whose
	// VALUE lands in a record region (the assembler drops `__`-prefixed
	// labels from Result.Symbols, so the literal pool is the only
	// complete view of where jumps go).
	tgt := map[uint32]bool{}
	inText := func(x uint32) bool {
		return (x >= a.textLo && x < a.textHi) || (a.ramHi != 0 && x >= a.ramLo && x < a.ramHi)
	}
	for addr := range a.symAt {
		if inText(addr) {
			tgt[addr] = true
		}
	}
	for _, v := range a.litVal {
		if inText(v) {
			tgt[v] = true
		}
	}
	// Self-modified records: any record whose destination lands inside a
	// record region patches the instruction stream there.
	smod := map[uint32]bool{}
	for _, r := range a.recs {
		if inText(r.d) {
			smod[r.d&^7] = true
		}
	}
	for i := range a.recs {
		a.recs[i].tgt = tgt[a.recs[i].addr]
		a.recs[i].smod = smod[a.recs[i].addr]
	}
}

// class names an operand's address by role — the readable taxonomy
// behind the raw shape counts.
func (a *analysis) class(x uint32) string {
	switch {
	case x == 0:
		return "zero"
	case x >= emu.DMABase && x < emu.DMABase+16*emu.ChanStride:
		ch := int((x - emu.DMABase) / emu.ChanStride)
		return fmt.Sprintf("ch%d+%#02x", ch, (x-emu.DMABase)%emu.ChanStride)
	case x == a.v.SniffDataAddr():
		return "sniff"
	case x >= emu.DMABase && x < emu.DMABase+0x4000:
		return "dmareg"
	case (x >= a.textLo && x < a.textHi) || (a.ramHi != 0 && x >= a.ramLo && x < a.ramHi):
		return "text"
	}
	if _, ok := a.litVal[x]; ok {
		return "lit"
	}
	if n, ok := a.symAt[x]; ok {
		return "sym:" + n
	}
	return "data"
}

// regClass collapses a data operand onto the ABI register file names so
// the class histogram stays readable.
func (a *analysis) regClass(x uint32) string {
	c := a.class(x)
	if strings.HasPrefix(c, "sym:") {
		n := c[4:]
		switch n {
		case "at", "at2", "null", "zero", "lr", "dispatch", "irqresume":
			return "reg:" + n
		}
		if len(n) >= 2 && n[0] == 'r' && n[1] >= '0' && n[1] <= '9' {
			return "reg:rN"
		}
		return "data"
	}
	return c
}

// --- reporting ---

type kv struct {
	k string
	n int
}

func topK(h map[string]int, total int, ks ...int) string {
	var l []kv
	for k, n := range h {
		l = append(l, kv{k, n})
	}
	sort.Slice(l, func(i, j int) bool {
		if l[i].n != l[j].n {
			return l[i].n > l[j].n
		}
		return l[i].k < l[j].k
	})
	var b strings.Builder
	fmt.Fprintf(&b, "distinct=%-6d", len(l))
	for _, k := range ks {
		sum := 0
		for i := 0; i < k && i < len(l); i++ {
			sum += l[i].n
		}
		fmt.Fprintf(&b, " top%-3d=%5.1f%%", k, 100*float64(sum)/float64(total))
	}
	return b.String()
}

func (a *analysis) report(t *testing.T) {
	n := len(a.recs)
	p := func(f string, args ...any) { fmt.Printf("SHAPE %-12s "+f+"\n", append([]any{a.name}, args...)...) }
	p("records=%d text=%d ramtext=%d rodata-in-text=%d",
		n, a.textHi-a.textLo, a.ramHi-a.ramLo, a.rodata)

	pair, src, dst := map[string]int{}, map[string]int{}, map[string]int{}
	cls := map[string]int{}
	bankN := map[int]int{}
	hi16, hi8 := map[uint32]int{}, map[uint32]int{}
	var smod, tgts int
	for _, r := range a.recs {
		pair[fmt.Sprintf("%08x,%08x", r.s, r.d)]++
		src[fmt.Sprintf("%08x", r.s)]++
		dst[fmt.Sprintf("%08x", r.d)]++
		cls[a.regClass(r.s)+" -> "+a.regClass(r.d)]++
		bankN[r.bank]++
		hi16[r.s>>16]++
		hi16[r.d>>16]++
		hi8[r.s>>24]++
		hi8[r.d>>24]++
		if r.smod {
			smod++
		}
		if r.tgt {
			tgts++
		}
	}
	p("exact-pair  %s", topK(pair, n, 4, 8, 16, 32, 64, 256, 1024))
	p("dst-only    %s", topK(dst, n, 4, 8, 16, 32, 64, 256, 1024))
	p("src-only    %s", topK(src, n, 4, 8, 16, 32, 64, 256, 1024))
	p("operand-hi16 distinct=%d  hi8 distinct=%d (of %d operands)", len(hi16), len(hi8), 2*n)
	p("branch-targets=%d (%.1f%%)  self-modified=%d (%.2f%%)",
		tgts, 100*float64(tgts)/float64(n), smod, 100*float64(smod)/float64(n))
	var bl []string
	for b := 0; b < emu.CompactNumBanks; b++ {
		if bankN[b] > 0 {
			bl = append(bl, fmt.Sprintf("b%d=%.1f%%", b, 100*float64(bankN[b])/float64(n)))
		}
	}
	p("bank mix    %s", strings.Join(bl, " "))

	// class taxonomy, top 12
	var cl []kv
	for k, c := range cls {
		cl = append(cl, kv{k, c})
	}
	sort.Slice(cl, func(i, j int) bool { return cl[i].n > cl[j].n })
	for i := 0; i < 12 && i < len(cl); i++ {
		p("  class %-34s %6d (%4.1f%%)", cl[i].k, cl[i].n, 100*float64(cl[i].n)/float64(n))
	}

	a.perScope(p, "function", a.fnScopes())
	a.perScope(p, "page256", a.pageScopes(256))
	a.perScope(p, "page1k", a.pageScopes(1024))
	a.runs(p)
	a.candidates(p)
}

func (a *analysis) fnScopes() [][]rec {
	if len(a.fnStart) == 0 {
		return [][]rec{a.recs}
	}
	var out [][]rec
	var cur []rec
	idx := 0
	for _, r := range a.recs {
		for idx < len(a.fnStart) && a.fnStart[idx] <= r.addr {
			if a.fnStart[idx] == r.addr && len(cur) > 0 {
				out = append(out, cur)
				cur = nil
			}
			idx++
		}
		cur = append(cur, r)
	}
	if len(cur) > 0 {
		out = append(out, cur)
	}
	return out
}

func (a *analysis) pageScopes(size uint32) [][]rec {
	var out [][]rec
	var cur []rec
	var page uint32
	for i, r := range a.recs {
		pg := r.addr / size
		if i == 0 || pg != page {
			if len(cur) > 0 {
				out = append(out, cur)
			}
			cur, page = nil, pg
		}
		cur = append(cur, r)
	}
	if len(cur) > 0 {
		out = append(out, cur)
	}
	return out
}

// perScope reports how much of each scope's records a LOCAL dictionary
// of exact pairs would cover — the "per-page / per-function template
// dictionary" of the §7 sketch, priced at its own granularity.
func (a *analysis) perScope(p func(string, ...any), label string, scopes [][]rec) {
	n := len(a.recs)
	var dictAll int
	cov := map[int]int{}
	for _, sc := range scopes {
		h := map[string]int{}
		for _, r := range sc {
			h[fmt.Sprintf("%08x,%08x", r.s, r.d)]++
		}
		dictAll += len(h)
		var l []int
		for _, c := range h {
			l = append(l, c)
		}
		sort.Sort(sort.Reverse(sort.IntSlice(l)))
		for _, k := range []int{4, 8, 16, 32, 64} {
			s := 0
			for i := 0; i < k && i < len(l); i++ {
				s += l[i]
			}
			cov[k] += s
		}
	}
	var b strings.Builder
	for _, k := range []int{4, 8, 16, 32, 64} {
		fmt.Fprintf(&b, " top%-3d=%5.1f%%", k, 100*float64(cov[k])/float64(n))
	}
	p("%-9s scopes=%-5d local-distinct-pairs=%-6d%s", label, len(scopes), dictAll, b.String())
}

// runs measures the raw material candidate A needs: maximal runs of
// consecutive fetch-chained records that share a destination (or a
// source), broken at branch targets, self-modified records and
// auto-return banks.
func (a *analysis) runs(p func(string, ...any)) {
	for _, mode := range []string{"dst", "src"} {
		hist := map[int]int{}
		var cur int
		var key uint32
		flush := func() {
			if cur > 0 {
				hist[cur]++
			}
			cur = 0
		}
		for _, r := range a.recs {
			ok := !r.smod && (r.bank == emu.CompactPlain || r.bank == emu.CompactSniff)
			k := r.d
			if mode == "src" {
				k = r.s
			}
			if !ok || r.tgt {
				flush()
			}
			if !ok {
				continue
			}
			if cur > 0 && k == key {
				cur++
				continue
			}
			flush()
			cur, key = 1, k
		}
		flush()
		var b strings.Builder
		tot, inLong := 0, 0
		for l, c := range hist {
			tot += l * c
			if l >= 7 {
				inLong += l * c
			}
		}
		for _, l := range []int{2, 3, 4, 6, 7, 10, 16} {
			s := 0
			for ln, c := range hist {
				if ln >= l {
					s += ln * c
				}
			}
			fmt.Fprintf(&b, " >=%-2d=%5.2f%%", l, 100*float64(s)/float64(len(a.recs)))
		}
		mx := 0
		for l := range hist {
			if l > mx {
				mx = l
			}
		}
		p("runs-%s   eligible=%.1f%% longest=%d  share of records in runs of%s",
			mode, 100*float64(tot)/float64(len(a.recs)), mx, b.String())
	}
}

// candidates prices the encodings of prompts/043 against this image.
func (a *analysis) candidates(p func(string, ...any)) {
	n := len(a.recs)
	base := 8 * n

	// Candidate A: sticky-operand half records. A run costs 8 B to set
	// the sticky operand, 8 B to enter half mode, 4 B per record and 8 B
	// to leave — so the optimal segmentation is a one-dimensional DP over
	// each label-free, fetch-chained span.
	for _, mode := range []string{"dst", "src", "best"} {
		total := 0
		var span []rec
		run := func() {
			total += dpSpan(span, mode)
			span = nil
		}
		for _, r := range a.recs {
			ok := !r.smod && (r.bank == emu.CompactPlain || r.bank == emu.CompactSniff)
			if r.tgt || !ok {
				run()
			}
			if !ok {
				total += 8
				continue
			}
			span = append(span, r)
		}
		run()
		p("cand-A(%-4s) text %d -> %d (%+.2f%%)", mode, base, total,
			100*float64(total-base)/float64(base))
	}

	// Candidate B: every record becomes a 4-byte POINTER at an 8-byte
	// dictionary entry, expanded by a DMA channel (no mode, no CPU —
	// host/dmaasm/zz_reccycles_test.go builds the machine and prices it
	// at 4 cycles/record against 3). Cost is exact: 4 B per record plus
	// one 8 B entry per DISTINCT pair.
	h := map[string]int{}
	for _, r := range a.recs {
		h[fmt.Sprintf("%08x,%08x", r.s, r.d)]++
	}
	var l []int
	for _, c := range h {
		l = append(l, c)
	}
	sort.Sort(sort.Reverse(sort.IntSlice(l)))
	mult := map[string]int{}
	for _, c := range l {
		switch {
		case c == 1:
			mult["x1"] += c
		case c == 2:
			mult["x2"] += c
		case c <= 4:
			mult["x3-4"] += c
		case c <= 16:
			mult["x5-16"] += c
		default:
			mult["x17+"] += c
		}
	}
	var mb strings.Builder
	for _, k := range []string{"x1", "x2", "x3-4", "x5-16", "x17+"} {
		fmt.Fprintf(&mb, " %s=%4.1f%%", k, 100*float64(mult[k])/float64(n))
	}
	p("pair multiplicity: distinct/records=%.3f  records by reuse:%s",
		float64(len(l))/float64(n), mb.String())

	pure := 4*n + 8*len(l)
	p("cand-B(all)  text %d -> %d (%+.2f%%) at 4/3 cycles per record",
		base, pure, 100*float64(pure-base)/float64(base))

	// The unattainable bound for any pooling scheme: pool a pair only
	// when it pays, and switch encodings for free.
	ideal := 0
	for _, c := range l {
		ideal += min(8*c, 4*c+8)
	}
	p("cand-B(ideal, free mode switch) text %d -> %d (%+.2f%%)",
		base, ideal, 100*float64(ideal-base)/float64(base))

	// Partial dictionaries, ignoring how the non-pooled records would be
	// told apart from the pooled ones (they could not be, for free).
	for _, k := range []int{256, 1024, 4096} {
		hit := 0
		for i := 0; i < k && i < len(l); i++ {
			hit += l[i]
		}
		sz := 4*hit + 8*(n-hit) + 8*min(k, len(l))
		p("cand-B(dict=%-4d) hit=%5.1f%%  text %d -> %d (%+.2f%%, mode switching NOT counted)",
			k, 100*float64(hit)/float64(n), base, sz,
			100*float64(sz-base)/float64(base))
	}

	// Candidate C: the honest hybrid — pointer mode where it pays,
	// inline 8-byte records where it does not, with the mode switch
	// priced at what the machine actually charges for one (8 B to enter
	// from inline mode, 4 B to leave from pointer mode; see prompts/043).
	for _, thr := range []int{2, 3, 4} {
		sz, ptr, ent, sw := a.hybrid(h, thr, false)
		p("cand-C(pool>=%d) text %d -> %d (%+.2f%%)  ptr-records=%4.1f%% entries=%d switches=%d",
			thr, base, sz, 100*float64(sz-base)/float64(base),
			100*float64(ptr)/float64(n), ent, sw)
	}
	// Sensitivity: the same DP with the canonical-mode-at-entry-points
	// rule dropped. Unsound (the mode is machine state and a jump carries
	// it into its target), but it bounds how much of candidate C's
	// shortfall the probe's over-approximation of branch targets and %pc
	// writes could possibly explain.
	sz, ptr, _, _ := a.hybrid(h, 2, true)
	p("cand-C(pool>=2, entry rule dropped — UNSOUND bound) text %d -> %d (%+.2f%%) ptr-records=%4.1f%%",
		base, sz, 100*float64(sz-base)/float64(base), 100*float64(ptr)/float64(n))
}

// hybrid runs the two-mode DP: at every record the stream is either in
// 8-byte inline mode or in 4-byte pointer mode, and the canonical mode
// (inline) is required at every branch target, at every record on an
// auto-return bank (cleanup resets fetch's write pointer, which IS the
// mode) and at every self-modified record. Pairs seen at least thr
// times get a shared dictionary entry; anything else pooled would need
// a private entry and pays 12 B, which the DP is free to reject.
func (a *analysis) hybrid(h map[string]int, thr int, freeEntry bool) (size, ptrRecs, entries, switches int) {
	const inf = 1 << 30
	const enter, leave = 8, 4
	n := len(a.recs)
	// dp[0] = inline mode, dp[1] = pointer mode
	dp := [2]int{0, inf}
	from := make([][2]int8, n+1)
	for i, r := range a.recs {
		key := fmt.Sprintf("%08x,%08x", r.s, r.d)
		pooled := h[key] >= thr
		// A control transfer must leave the machine in canonical mode:
		// the mode IS fetch's write pointer plus its count, and a jump
		// carries it into the target. So every record that writes %pc
		// executes in inline mode, which is what making it ineligible
		// means here (the DP then pays the leave transition before it).
		eligible := !r.smod && (freeEntry || (!r.tgt &&
			r.d != emu.ChanRegAddr(emu.CompactFetch, emu.OffReadAddr))) &&
			(r.bank == emu.CompactPlain || r.bank == emu.CompactSniff)
		pc := 12
		if pooled {
			pc = 4
		}
		var nx [2]int
		// inline mode after this record
		nx[0], from[i][0] = dp[0]+8, 0
		if dp[1] != inf && dp[1]+leave+8 < nx[0] {
			nx[0], from[i][0] = dp[1]+leave+8, 1
		}
		// pointer mode after this record
		nx[1], from[i][1] = inf, 0
		if eligible {
			nx[1], from[i][1] = dp[0]+enter+pc, 0
			if dp[1] != inf && dp[1]+pc < nx[1] {
				nx[1], from[i][1] = dp[1]+pc, 1
			}
		}
		dp = nx
	}
	end := 0
	total := dp[0]
	if dp[1] != inf && dp[1]+leave < total {
		total, end = dp[1]+leave, 1
	}
	// reconstruct to count the entries actually referenced
	used := map[string]bool{}
	st := end
	for i := n - 1; i >= 0; i-- {
		if st == 1 {
			ptrRecs++
			used[fmt.Sprintf("%08x,%08x", a.recs[i].s, a.recs[i].d)] = true
		}
		prev := int(from[i][st])
		if prev != st {
			switches++
		}
		st = prev
	}
	for k := range used {
		if h[k] >= thr {
			entries++
		}
	}
	return total + 8*entries, ptrRecs, entries, switches
}

// dpSpan returns the byte cost of one label-free span under candidate A.
// State 0 is 8-byte mode; entering a half run costs 16 B (set the sticky
// operand, then switch fetch's mode), each half record 4 B, and leaving
// 8 B.
func dpSpan(span []rec, mode string) int {
	n := len(span)
	if n == 0 {
		return 0
	}
	const inf = 1 << 30
	best := make([]int, n+1)
	for i := range best {
		best[i] = inf
	}
	best[0] = 0
	for i := 0; i < n; i++ {
		if best[i] == inf {
			continue
		}
		if best[i]+8 < best[i+1] {
			best[i+1] = best[i] + 8 // stay in 8-byte mode
		}
		// a half run starting at i
		for _, m := range []string{"dst", "src"} {
			if mode != "best" && m != mode {
				continue
			}
			k := span[i].d
			if m == "src" {
				k = span[i].s
			}
			for j := i; j < n; j++ {
				kk := span[j].d
				if m == "src" {
					kk = span[j].s
				}
				if kk != k {
					break
				}
				cost := best[i] + 16 + 4*(j-i+1) + 8
				if cost < best[j+1] {
					best[j+1] = cost
				}
			}
		}
	}
	return best[n]
}
