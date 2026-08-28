package dmacc_test

// The PGO driver: emulator traces of representative workloads in,
// committed settings out (host/pgo). One generator owns every
// profile-guided knob in the tree, so a workload change re-derives all
// of them together instead of leaving hand-applied leftovers behind.
//
//	make pgo
//
// What it measures, per deployable payload, in ONE emulated run each:
//
//	(a) literal-pool word reads. The images are profiled in their
//	    DEPLOYED shape, pool split and all: Result.LitAddrs gives every
//	    key's address whether it ended up resident in SRAM data or cold
//	    in the flash text tail, so counting both regions and folding
//	    through LitAddrs prices every key on one run. (An unsplit build
//	    would put them all in one range, but sh's all-resident data
//	    overruns its board window — the split shape is also the shape
//	    the settings ship in.) Keys read at loop rate stay resident.
//	(b) per-function text reads — one profile window over the image's
//	    XIP text segment, minus the cold pool words sharing its tail. A
//	    text read IS an instruction fetch here, so the histogram is
//	    execution heat AND (text being flash) the XIP-parking signal
//	    that ranks ResidentFuncs.
//	(c) the same over the kernel's .ramtext, which prices what the
//	    current ResidentFuncs list is buying.
//
// Attribution note (prompts/042 §8): dmaasm drops every `__`-prefixed
// symbol from Result.Symbols, so a nearest-preceding-symbol scan over
// ALL symbols silently credits the runtime and compare millicode to
// whatever compiled function precedes them. Under XIPText the runtime
// and millicode live in .ramtext, not in the XIP text this attributes,
// and the only labels left there are dmacc's own — so ownership comes
// from the `f_` function labels alone, which is exact.

import (
	"fmt"
	"os"
	"sort"
	"strings"
	"testing"

	"github.com/puhitaku/dma-cpu/host/boards"
	"github.com/puhitaku/dma-cpu/host/dmaasm"
	"github.com/puhitaku/dma-cpu/host/emu"
)

// litHotReads is the "read at loop rate" bar a pool word must clear to
// be considered for residency: below it a key is a one-shot constant
// that costs 4 bytes of SRAM to save a handful of flash reads.
const litHotReads = 32

// funcHotCover is the share of executed text reads the hot-function set
// must cover. Functions outside it take the two-record descriptor
// compare form (dmacc Options.OptSize); inside it they keep the
// four-move protocol. The knee: the tail past this point is thousands
// of cold records for a vanishing share of executed ones.
const funcHotCover = 0.97

// imgProfile is one payload's measured heat.
type imgProfile struct {
	name    string
	lits    map[string]uint64 // pool key -> word reads
	litTot  uint64
	litN    int               // pool size (keys)
	funcs   map[string]uint64 // C function name -> text-word reads
	funcTot uint64
}

// poolWindowIn is the profile window over the pool literals an image
// kept inside [lo, hi) — the resident half, in its data segment. The
// cold half rides the text window instead.
func poolWindowIn(res *dmaasm.Result, lo, hi uint32) [2]uint32 {
	w := [2]uint32{^uint32(0), 0}
	for _, a := range res.LitAddrs {
		if a < lo || a >= hi {
			continue
		}
		if a < w[0] {
			w[0] = a
		}
		if a+4 > w[1] {
			w[1] = a + 4
		}
	}
	if w[1] <= w[0] {
		return [2]uint32{0, 0}
	}
	return w
}

// textWindow is the profile window over an image's text segment.
func textWindow(res *dmaasm.Result, base uint32) [2]uint32 {
	return [2]uint32{base, base + uint32(len(res.Image.Segments[0].Data))}
}

// window pairs a profile window with the counts it collected.
type window struct {
	w      [2]uint32
	counts []uint32
}

func (w window) at(addr uint32) (uint32, bool) {
	if w.counts == nil || addr < w.w[0] || addr >= w.w[1] {
		return 0, false
	}
	return w.counts[(addr-w.w[0])>>2], true
}

// litCounts folds every pool word's reads back onto its key, looking in
// each of the given windows (resident half in data, cold half in the
// text tail).
func litCounts(res *dmaasm.Result, ws ...window) (map[string]uint64, uint64) {
	out := make(map[string]uint64, len(res.LitAddrs))
	var tot uint64
	for k, a := range res.LitAddrs {
		for _, w := range ws {
			if c, ok := w.at(a); ok {
				out[k] += uint64(c)
				tot += uint64(c)
			}
		}
	}
	return out, tot
}

// litSet is the address set of an image's pool words, so the text
// histogram can skip the cold pool riding its tail.
func litSet(res *dmaasm.Result) map[uint32]bool {
	m := make(map[uint32]bool, len(res.LitAddrs))
	for _, a := range res.LitAddrs {
		m[a] = true
	}
	return m
}

// funcCounts folds a text window's per-word counts onto the owning
// function: dmacc lays each function out contiguously behind its `f_`
// label, so the nearest preceding one is the owner.
func funcCounts(res *dmaasm.Result, w window, skip map[uint32]bool) (map[string]uint64, uint64) {
	type ent struct {
		name string
		addr uint32
	}
	var fs []ent
	for n, a := range res.Symbols {
		if strings.HasPrefix(n, "f_") && a >= w.w[0] && a < w.w[1] {
			fs = append(fs, ent{n[2:], a})
		}
	}
	sort.Slice(fs, func(i, j int) bool { return fs[i].addr < fs[j].addr })
	out := map[string]uint64{}
	var tot uint64
	si := 0
	for i, c := range w.counts {
		a := w.w[0] + uint32(i)*4
		if c == 0 || skip[a] {
			continue
		}
		for si+1 < len(fs) && fs[si+1].addr <= a {
			si++
		}
		if si < len(fs) && fs[si].addr <= a {
			out[fs[si].name] += uint64(c)
		} else {
			out["(pre-first-function)"] += uint64(c)
		}
		tot += uint64(c)
	}
	return out, tot
}

// rankLits returns the pool keys that cleared the loop-rate bar, most
// read first.
func rankLits(lits map[string]uint64) []string {
	var keys []string
	for k, c := range lits {
		if c >= litHotReads {
			keys = append(keys, k)
		}
	}
	sort.Slice(keys, func(i, j int) bool {
		if lits[keys[i]] != lits[keys[j]] {
			return lits[keys[i]] > lits[keys[j]]
		}
		return keys[i] < keys[j]
	})
	return keys
}

// coverage is the share of reads a prefix of a ranked key list covers.
func coverage(lits map[string]uint64, keys []string, tot uint64) float64 {
	if tot == 0 {
		return 0
	}
	var got uint64
	for _, k := range keys {
		got += lits[k]
	}
	return 100 * float64(got) / float64(tot)
}

// setOf turns a key list into the map shape the settings use.
func setOf(keys []string) map[string]bool {
	m := make(map[string]bool, len(keys))
	for _, k := range keys {
		m[k] = true
	}
	return m
}

// largestFit binary-searches the longest prefix of ranked for which
// fits reports true (fits is monotone: more resident keys, more SRAM).
func largestFit(ranked []string, fits func(n int) bool) int {
	if fits(len(ranked)) {
		return len(ranked)
	}
	lo, hi := 0, len(ranked) // fits(lo) assumed, !fits(hi)
	for hi-lo > 1 {
		mid := (lo + hi) / 2
		if fits(mid) {
			lo = mid
		} else {
			hi = mid
		}
	}
	return lo
}

// TestGenPGO regenerates host/pgo/lits_gen.go and host/pgo/funcs_gen.go.
//
//	GEN_PGO=1 go test -count=1 -timeout 3h -run TestGenPGO ./host/dmacc/
func TestGenPGO(t *testing.T) {
	if os.Getenv("GEN_PGO") == "" {
		t.Skip("generator: run `make pgo` (sets GEN_PGO=1) to regenerate host/pgo")
	}
	kern, sh, vi := profileXsh(t)
	game := profileGame(t)

	bd := boards.Feather
	v, err := emu.VariantByName(bd.SKU)
	if err != nil {
		t.Fatal(err)
	}

	// --- hot literal pools, trimmed to the tightest board window ---
	type litOut struct {
		p       *imgProfile
		ranked  []string
		kept    []string
		note    string
		limitOf string
	}
	outs := map[string]*litOut{}
	for _, p := range []*imgProfile{kern, sh, vi, game} {
		outs[p.name] = &litOut{p: p, ranked: rankLits(p.lits)}
	}

	// The kernel ships on every xv6 board; its resident pool must fit
	// the tightest KernCData window of the three.
	kdasm := map[string]string{}
	for _, b := range []*boards.Board{boards.Pico2, boards.Pico, boards.Feather} {
		kdasm[b.Name] = compileKernelXsh(t, b.FbBuf != 0)
	}
	ko := outs["kernel"]
	ko.limitOf = "KernCData window"
	ko.kept = ko.ranked[:largestFit(ko.ranked, func(n int) bool {
		hot := setOf(ko.ranked[:n])
		for _, b := range []*boards.Board{boards.Pico2, boards.Pico, boards.Feather} {
			bv, _ := emu.VariantByName(b.SKU)
			res, err := dmaasm.Assemble(kdasm[b.Name], dmaasm.Options{
				Variant: bv, Compact: true, TextBase: b.KernTextXIP,
				DataBase: b.KernCData, RAMTextBase: b.KernCRText,
				PoolText: true, HotLits: hot})
			if err != nil {
				t.Fatal(err)
			}
			if b.KernCData+uint32(len(res.Image.Segments[1].Data))+windowMargin > b.ShRText {
				return false
			}
		}
		return true
	})]

	// sh: same shape, its own ShData window.
	shDasm := compileShDasm(t, bd)
	so := outs["sh"]
	so.limitOf = "ShData window"
	so.kept = so.ranked[:largestFit(so.ranked, func(n int) bool {
		hot := setOf(so.ranked[:n])
		for _, b := range []*boards.Board{boards.Pico2, boards.Pico, boards.Feather} {
			bv, _ := emu.VariantByName(b.SKU)
			res, err := dmaasm.Assemble(shDasm, dmaasm.Options{
				Variant: bv, Compact: true, TextBase: b.ShTextXIP,
				DataBase: b.ShData, RAMTextBase: b.ShRText,
				PoolText: true, HotLits: hot})
			if err != nil {
				t.Fatal(err)
			}
			if b.ShData+uint32(len(res.Image.Segments[1].Data))+windowMargin > b.IdleText {
				return false
			}
		}
		return true
	})]

	// vi: a registry image whose [ramtext][data] claim comes out of the
	// arena, which also has to hold sh's heap and vi's own 40 KiB heap
	// ask — the feather map budgets those three against 82.2 KiB with
	// little to spare. So vi's hot pool must be FREE: the claim with it
	// may not exceed the all-cold claim, which means the set lives in
	// the slack of kalloc's 256-byte rounding.
	viDasm := compileUserResident(t, bd, "vi", "umalloc")
	viCold := viClaim(t, v, bd, viDasm, nil)
	vo := outs["vi"]
	vo.limitOf = fmt.Sprintf("all-cold arena claim (%d bytes)", viCold)
	vo.kept = vo.ranked[:largestFit(vo.ranked, func(n int) bool {
		return viClaim(t, v, bd, viDasm, setOf(vo.ranked[:n])) <= viCold
	})]

	// The game's data segment grows toward the fixed audio ring at
	// 0x20038000 (fx.c); its text grows toward the asset blob.
	gdasm := compileGameDasm(t)
	go_ := outs["game"]
	go_.limitOf = "GameData/audio-ring gap"
	gb := boards.GamePico
	gv, _ := emu.VariantByName(gb.SKU)
	go_.kept = go_.ranked[:largestFit(go_.ranked, func(n int) bool {
		res, err := dmaasm.Assemble(gdasm, dmaasm.Options{
			Variant: gv, Compact: true, TextBase: gb.GameTextXIP,
			DataBase: gb.GameData, RAMTextBase: gb.GameRAMText,
			PoolText: true, HotLits: setOf(go_.ranked[:n])})
		if err != nil {
			t.Fatal(err)
		}
		return gb.GameData+uint32(len(res.Image.Segments[1].Data))+windowMargin <= gameAudioBase
	})]

	// --- hot functions: four-move compares where execution lives ---
	hotFuncs := func(p *imgProfile) []string {
		type ent struct {
			name string
			n    uint64
		}
		var es []ent
		for n, c := range p.funcs {
			es = append(es, ent{n, c})
		}
		sort.Slice(es, func(i, j int) bool {
			if es[i].n != es[j].n {
				return es[i].n > es[j].n
			}
			return es[i].name < es[j].name
		})
		var got uint64
		var out []string
		for _, e := range es {
			if float64(got) >= funcHotCover*float64(p.funcTot) {
				break
			}
			out = append(out, e.name)
			got += e.n
		}
		sort.Strings(out)
		return out
	}
	kernHot, gameHot := hotFuncs(kern), hotFuncs(game)

	// --- emit ---
	var b strings.Builder
	genHeader(&b)
	wrapComment(&b, fmt.Sprintf("The hot-literal sets. Under dmaasm's "+
		"Options.PoolText a pool word named here stays in resident SRAM data; "+
		"everything else appends to the image's flash text tail and is read "+
		"over XIP. Each set is the keys read at least %d times during the "+
		"workload below, ranked by read count and trimmed until the resident "+
		"half fits every board that ships the image, with %d bytes of the "+
		"window left over.", litHotReads, windowMargin))
	for _, name := range []string{"kernel", "sh", "vi", "game"} {
		o := outs[name]
		b.WriteString("\n")
		wrapComment(&b, fmt.Sprintf("%s: %d of %d pool words resident (%d bytes "+
			"of SRAM), covering %.1f%% of the %d pool reads the workload made.",
			litVar(name), len(o.kept), o.p.litN, 4*len(o.kept),
			coverage(o.p.lits, o.kept, o.p.litTot), o.p.litTot))
		if len(o.kept) < len(o.ranked) {
			wrapComment(&b, fmt.Sprintf("Trimmed from %d loop-rate keys by the %s "+
				"(%.1f%% coverage untrimmed): the %d coldest of them pay flash instead.",
				len(o.ranked), o.limitOf, coverage(o.p.lits, o.ranked, o.p.litTot),
				len(o.ranked)-len(o.kept)))
		}
		wrapComment(&b, "Workload: "+workloadOf(name)+".")
		keys := append([]string(nil), o.kept...)
		sort.Strings(keys)
		fmt.Fprintf(&b, "var %s = map[string]bool{\n", litVar(name))
		for _, k := range keys {
			fmt.Fprintf(&b, "\t%q: true,\n", k)
		}
		b.WriteString("}\n")
	}
	if err := os.WriteFile("../pgo/lits_gen.go", []byte(b.String()), 0o644); err != nil {
		t.Fatal(err)
	}

	b.Reset()
	genHeader(&b)
	wrapComment(&b, fmt.Sprintf("The hot-function sets. With dmacc's "+
		"Options.OptSize on, a function named here keeps the fast four-move "+
		"comparison protocol; every other function's compare sites shrink to "+
		"the two-record descriptor form. Each set is the functions that own "+
		"the top %.0f%% of the text reads (= instruction fetches) the workload "+
		"made, so the descriptor form lands on the code that executes rarely "+
		"and costs bytes.", 100*funcHotCover))
	b.WriteString("//\n")
	wrapComment(&b, "Names are IR function names and are NOT validated by "+
		"dmacc: a board that links a different module set (the displayless "+
		"kernels take the fb stub) simply has no function by some of these "+
		"names.")
	for _, x := range []struct {
		v, img string
		hot    []string
		p      *imgProfile
	}{{"KernelHotFuncs", "kernel", kernHot, kern}, {"GameHotFuncs", "game", gameHot, game}} {
		var got uint64
		for _, n := range x.hot {
			got += x.p.funcs[n]
		}
		b.WriteString("\n")
		wrapComment(&b, fmt.Sprintf("%s: %d of %d executed functions, covering "+
			"%.1f%% of the %d text reads the workload made.", x.v, len(x.hot),
			len(x.p.funcs), 100*float64(got)/float64(x.p.funcTot), x.p.funcTot))
		wrapComment(&b, "Workload: "+workloadOf(x.img)+".")
		fmt.Fprintf(&b, "var %s = map[string]bool{\n", x.v)
		for _, n := range x.hot {
			fmt.Fprintf(&b, "\t%q: true,\n", n)
		}
		b.WriteString("}\n")
	}
	if err := os.WriteFile("../pgo/funcs_gen.go", []byte(b.String()), 0o644); err != nil {
		t.Fatal(err)
	}

	for _, name := range []string{"kernel", "sh", "vi", "game"} {
		o := outs[name]
		fmt.Printf("PGO %-7s lits %4d/%-5d hot (%5d B SRAM) %5.1f%% of %10d reads\n",
			name, len(o.kept), o.p.litN, 4*len(o.kept),
			coverage(o.p.lits, o.kept, o.p.litTot), o.p.litTot)
	}
	fmt.Printf("PGO kernel  funcs %d/%d hot of %d text reads\n",
		len(kernHot), len(kern.funcs), kern.funcTot)
	fmt.Printf("PGO game    funcs %d/%d hot of %d text reads\n",
		len(gameHot), len(game.funcs), game.funcTot)
}

// windowMargin is the SRAM a resident pool must leave free in its
// board window. Without it the generator fills every window to the last
// word and the next byte anyone adds to that image fails the build; one
// allocator page of slack keeps ordinary work moving between
// regenerations.
const windowMargin = 256

// gameAudioBase is fx.c's fixed 16 KiB audio ring; the game's data
// segment must stop short of it (dmxgen checks the same bound).
const gameAudioBase = 0x20038000

func litVar(img string) string {
	return map[string]string{"kernel": "KernelLits", "sh": "ShLits",
		"vi": "ViLits", "game": "GameLits"}[img]
}

func workloadOf(img string) string {
	switch img {
	case "game":
		return "gamepico boot to the menu, menu navigation, then the " +
			"Dino, LANWalk and Yacht scenes played to their first scoring event"
	case "vi":
		return "an editing session on the feather (open, insert, yank, " +
			"paste x10, delete, replace, substitute, quit)"
	}
	return "a feather boot to the prompt, the xsh benchmark command " +
		"set run cold and warm, then an editing session in vi"
}

// wrapComment writes text as a Go line comment block at the width the
// tree's hand-written comments use.
func wrapComment(b *strings.Builder, text string) {
	line := "//"
	for _, w := range strings.Fields(text) {
		if len(line)+1+len(w) > 72 {
			b.WriteString(line + "\n")
			line = "//"
		}
		line += " " + w
	}
	b.WriteString(line + "\n")
}

func genHeader(b *strings.Builder) {
	b.WriteString("// Code generated by TestGenPGO (host/dmacc/zz_pgogen_test.go);\n")
	b.WriteString("// regenerate with `make pgo`. DO NOT EDIT.\n\npackage pgo\n\n")
}

// viClaim assembles vi against a candidate hot set and returns the
// arena bytes exec would claim for it (the dmxgen/casmResident sum).
func viClaim(t *testing.T, v *emu.Variant, bd *boards.Board, dasm string,
	hot map[string]bool) uint32 {
	t.Helper()
	probe, err := dmaasm.Assemble(dasm, dmaasm.Options{
		Variant: v, Compact: true,
		TextBase: 0x10000000, DataBase: 0x10040000, RAMTextBase: 0x10080000})
	if err != nil {
		t.Fatal(err)
	}
	rt := (uint32(len(probe.Image.Segments[2].Data)) + 7) &^ 7
	sram := bd.Arena + 0x100
	res, err := dmaasm.Assemble(dasm, dmaasm.Options{
		Variant: v, Compact: true,
		TextBase: bd.ViHome, DataBase: sram + rt, RAMTextBase: sram,
		PoolText: true, HotLits: hot})
	if err != nil {
		t.Fatal(err)
	}
	rt = (uint32(len(res.Image.Segments[2].Data)) + 7) &^ 7
	data := uint32(len(res.Image.Segments[1].Data))
	return (rt+data+255)&^255 + 0x100
}

// profileXsh runs the xv6 workload once with every pool unsplit and
// returns the kernel, sh and vi profiles.
func profileXsh(t *testing.T) (*imgProfile, *imgProfile, *imgProfile) {
	t.Helper()
	bd := boards.Feather
	flash := make([]byte, bd.FlashSize)
	m, kernC := buildXshBoard(t, flash, bd)
	viRes := registerVi(t, m, kernC, bd)
	shRes := buildShXsh(t, m.Variant(), bd)

	// Boot to the prompt (mailbox pump, golden-boot style).
	booted := false
	for i := 0; i < 600 && !booted; i++ {
		if _, err := m.Run(emu.RunConfig{MaxCycles: 5_000_000}); err != nil {
			t.Fatalf("boot: %v\nconsole:\n%s", err, m.ConsoleOut)
		}
		for serviceMailboxAt(m, bd.Scratch+0x10, m.Flash, nil) {
		}
		booted = strings.HasSuffix(string(m.ConsoleOut), "$ ")
	}
	if !booted {
		t.Fatalf("no prompt\nconsole:\n%s", m.ConsoleOut)
	}
	m.TXPace = 0

	kLit := poolWindowIn(kernC, bd.KernCData, bd.ShRText)
	sLit := poolWindowIn(shRes, bd.ShData, bd.IdleText)
	vLit := poolWindowIn(viRes, bd.Arena, bd.ArenaEnd)
	kTxt := textWindow(kernC, bd.KernTextXIP)
	sTxt := textWindow(shRes, bd.ShTextXIP)
	vTxt := textWindow(viRes, bd.ViHome)
	kRam := [2]uint32{bd.KernCRText, bd.KernCData}
	m.ProfileWindows([][2]uint32{kLit, sLit, vLit, kTxt, sTxt, vTxt, kRam})

	// The shell half: the benchmark command set, cold then warm.
	for _, c := range benchCmds {
		for i := 0; i < 2; i++ {
			m.FeedConsole(c + "\r")
			runScript(t, m, 3_000_000_000)
		}
	}
	// The editor half: TestZZBenchVi's session.
	for _, s := range viBenchSteps {
		feedQuiet(t, m, s.feed, 20_000_000_000)
	}
	if !strings.HasSuffix(string(m.ConsoleOut), "$ ") {
		t.Fatalf("vi did not exit to the prompt; tail %q", tail(m.ConsoleOut, 200))
	}

	mk := func(name string, res *dmaasm.Result, lw, tw [2]uint32, li, ti int) *imgProfile {
		lwin := window{lw, m.ProfileCountsAt(li)}
		twin := window{tw, m.ProfileCountsAt(ti)}
		lits, ltot := litCounts(res, lwin, twin)
		fns, ftot := funcCounts(res, twin, litSet(res))
		return &imgProfile{name: name, lits: lits, litTot: ltot,
			litN: len(res.LitAddrs), funcs: fns, funcTot: ftot}
	}
	// The kernel's .ramtext heat prices what ResidentFuncs already
	// buys; report it beside the XIP text it was pulled out of.
	rfns, rtot := funcCounts(kernC, window{kRam, m.ProfileCountsAt(6)}, litSet(kernC))
	reportHeat("kernel .ramtext (resident today)", rfns, rtot)
	kp := mk("kernel", kernC, kLit, kTxt, 0, 3)
	reportHeat("kernel XIP text (flash reads = parking)", kp.funcs, kp.funcTot)
	sp := mk("sh", shRes, sLit, sTxt, 1, 4)
	reportHeat("sh XIP text", sp.funcs, sp.funcTot)
	vp := mk("vi", viRes, vLit, vTxt, 2, 5)
	reportHeat("vi XIP text", vp.funcs, vp.funcTot)
	fmt.Printf("PGO vi pool reads %d vs vi text reads %d (%.1f%% of vi flash reads are pool)\n",
		vp.litTot, vp.funcTot, 100*float64(vp.litTot)/float64(vp.litTot+vp.funcTot))
	return kp, sp, vp
}

// benchCmds is TestZZBenchXsh's command set — the workload the kernel
// and shell settings are tuned against, so the bench prices exactly
// what the profile optimized.
var benchCmds = []string{
	"echo hi", "ls", "cat README", "cat README | wc", "free",
	"((((echo deep))))",
}

// viBenchSteps is TestZZBenchVi's session, verbatim.
var viBenchSteps = []struct{ name, feed string }{
	{"open README", "vi README\r"},
	{"insert a line", "ithe quick brown fox jumps over the lazy dog\x1b"},
	{"yank line (yy)", "yy"},
	{"paste x10 (p)", strings.Repeat("p", 10)},
	{"delete x5 (dd)", strings.Repeat("dd", 5)},
	{"replace char (rX)", "rX"},
	{"open aaa line (o)", "o" + strings.Repeat("a", 20) + "\x1b"},
	{"yank aaa (yy)", "yy"},
	{"paste aaa x10 (p)", strings.Repeat("p", 10)},
	{"subst %s/a/A/g", ":%s/a/A/g\r"},
	{"quit (:q!)", ":q!\r"},
}

// feedQuiet feeds a key sequence and runs until the screen stops
// changing (TestZZBenchVi's phase, without the cycle accounting).
func feedQuiet(t *testing.T, m *emu.Machine, feed string, budget uint64) {
	t.Helper()
	m.FeedConsole(feed)
	var spent uint64
	quiet := 0
	last := len(m.ConsoleOut)
	for spent < budget && quiet < 100 {
		rr, err := m.Run(emu.RunConfig{MaxCycles: 500_000})
		if err != nil {
			t.Fatalf("%v (console tail %q)", err, tail(m.ConsoleOut, 300))
		}
		spent += rr.Cycles
		if len(m.ConsoleOut) == last {
			quiet++
		} else {
			quiet, last = 0, len(m.ConsoleOut)
		}
	}
}

// reportHeat prints the top of one heat histogram, so a regeneration
// leaves the ranking that produced it on the record.
func reportHeat(tag string, fns map[string]uint64, tot uint64) {
	type ent struct {
		name string
		n    uint64
	}
	var es []ent
	for n, c := range fns {
		es = append(es, ent{n, c})
	}
	sort.Slice(es, func(i, j int) bool { return es[i].n > es[j].n })
	fmt.Printf("PGO HEAT %s: total %d reads over %d functions\n", tag, tot, len(es))
	for i := 0; i < len(es) && i < 20; i++ {
		fmt.Printf("PGO   %-30s %12d (%5.2f%%)\n", es[i].name, es[i].n,
			100*float64(es[i].n)/float64(tot))
	}
}

// profileGame runs the gamepico workload with its pool unsplit: boot to
// the menu, walk the menu, then play three scenes. Each scene starts
// from its own boot because the scenes do not all have an exit path.
func profileGame(t *testing.T) *imgProfile {
	t.Helper()
	var lits map[string]uint64
	var fns map[string]uint64
	var litTot, funcTot uint64
	var litN int

	run := func(drive func(m *emu.Machine, prog *dmaasm.Result, at int)) {
		m, prog := bootGame(t)
		gb := boards.GamePico
		lw := poolWindowIn(prog, gb.GameData, gameAudioBase)
		tw := textWindow(prog, gb.GameTextXIP)
		m.ProfileWindows([][2]uint32{lw, tw})
		at := runUntil(t, m, "menu up", 0, 300_000_000)
		drive(m, prog, at)
		lwin, twin := window{lw, m.ProfileCountsAt(0)}, window{tw, m.ProfileCountsAt(1)}
		l, lt := litCounts(prog, lwin, twin)
		f, ft := funcCounts(prog, twin, litSet(prog))
		if lits == nil {
			lits, fns, litN = map[string]uint64{}, map[string]uint64{}, len(prog.LitAddrs)
		}
		for k, c := range l {
			lits[k] += c
		}
		for k, c := range f {
			fns[k] += c
		}
		litTot += lt
		funcTot += ft
	}

	// Menu navigation, then Dino played to a game over and restarted.
	run(func(m *emu.Machine, prog *dmaasm.Result, at int) {
		press(t, m, prog, pinDown)
		at = runUntil(t, m, "menu: LANWalk", at, 100_000_000)
		press(t, m, prog, pinUp)
		at = runUntil(t, m, "menu: Dinosaur", at, 100_000_000)
		press(t, m, prog, pinA)
		at = runUntil(t, m, "dino: start", at, 100_000_000)
		press(t, m, prog, pinUp)
		runUntil(t, m, "dino: over score=", at, 2_000_000_000)
	})
	// LANWalk: generate a board and rotate a tile four times.
	run(func(m *emu.Machine, prog *dmaasm.Result, at int) {
		press(t, m, prog, pinDown)
		at = runUntil(t, m, "menu: LANWalk", at, 100_000_000)
		press(t, m, prog, pinA)
		runUntil(t, m, "lanwalk: start", at, 100_000_000)
		if _, err := m.Run(emu.RunConfig{MaxCycles: 30_000_000}); err != nil {
			t.Fatal(err)
		}
		for i := 0; i < 4; i++ {
			press(t, m, prog, pinA)
		}
	})
	// Yacht: one reroll and one booked category.
	run(func(m *emu.Machine, prog *dmaasm.Result, at int) {
		press(t, m, prog, pinDown)
		at = runUntil(t, m, "menu: LANWalk", at, 100_000_000)
		press(t, m, prog, pinDown)
		at = runUntil(t, m, "menu: Yacht", at, 100_000_000)
		press(t, m, prog, pinA)
		at = runUntil(t, m, "yacht: start", at, 100_000_000)
		press(t, m, prog, pinA)
		at = runUntil(t, m, "yacht: roll", at, 100_000_000)
		press(t, m, prog, pinDown)
		press(t, m, prog, pinA)
		runUntil(t, m, "yacht: cat=0 score=", at, 100_000_000)
	})
	reportHeat("game XIP text", fns, funcTot)
	return &imgProfile{name: "game", lits: lits, litTot: litTot, litN: litN,
		funcs: fns, funcTot: funcTot}
}
