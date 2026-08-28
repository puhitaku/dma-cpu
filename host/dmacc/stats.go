package dmacc

import (
	"fmt"
	"sort"
	"strings"
)

// Stats collects code-size attribution during compilation: which IR
// constructs the emitted blocks pay for. Enabled via Options.Stats.
type Stats struct {
	ByCategory map[string]int // category -> blocks
	ByFunc     map[string]int // function -> blocks
	Total      int            // total emitted blocks (text only)
	Runtime    []string       // runtime modules linked
}

// blockCost prices one emitted dmaasm instruction in 16-byte blocks,
// mirroring dmaasm's instruction table. Sign-dispatch macros include
// their two pooled arena slots so the report reflects real bytes.
//
// This is the CLASSIC encoding, and every shipped image is compact, so
// the report ranks constructs rather than predicting bytes: a compact
// record is 8 bytes but a macro that visits more than one channel bank
// pays a window-switch record per transition, and the ratio is not
// uniform. Measured compact records vs the blocks below: move 1/1 (4
// on an incr byte bank: count set, switch, record, count restore),
// or/xor/andn 3/3, and 6/6, add 5/3, shl 5/3, sub 7/5, mulc k-dependent
// (7 for 3, 9 for 10, 13 for 100) /3, call 2/2, safepoint 2/2, jneg
// 10/6, jbool 12/6, jsign 8/4, jeq 24/12, jlt and jltu 25/16 (all four
// plus the same two arena slots). The switch share is structural, not
// planner slack — host/dmaasm/compact.go states why.
var blockCost = map[string]int{
	"move": 1, "add": 3, "sub": 5, "or": 3, "xor": 3, "andn": 3,
	"and": 6, "shl": 3, "mulc": 3,
	"jump": 1, "jumpr": 1, "ret": 1, "gpio": 1, "halt": 1, "nop": 1,
	"jneg": 6, "jbool": 6, "safepoint": 2, "call": 2,
	"jsign": 4 + 2, "jeq": 12 + 2, "jlt": 16 + 2, "jltu": 16 + 2,
}

func (s *Stats) record(fn, category, mnemonic string) {
	cost, ok := blockCost[mnemonic]
	if !ok {
		cost = 1
	}
	if s.ByCategory == nil {
		s.ByCategory = map[string]int{}
		s.ByFunc = map[string]int{}
	}
	s.ByCategory[category] += cost
	s.ByFunc[fn] += cost
	s.Total += cost
}

// Report renders the collected numbers, largest first.
func (s *Stats) Report() string {
	var b strings.Builder
	fmt.Fprintf(&b, "text: %d blocks (%d bytes)\n", s.Total, s.Total*16)
	if len(s.Runtime) > 0 {
		fmt.Fprintf(&b, "runtime modules: %s\n", strings.Join(s.Runtime, " "))
	}
	type row struct {
		name   string
		blocks int
	}
	dump := func(title string, m map[string]int, limit int) {
		rows := make([]row, 0, len(m))
		for k, v := range m {
			rows = append(rows, row{k, v})
		}
		sort.Slice(rows, func(i, j int) bool {
			if rows[i].blocks != rows[j].blocks {
				return rows[i].blocks > rows[j].blocks
			}
			return rows[i].name < rows[j].name
		})
		fmt.Fprintf(&b, "%s:\n", title)
		for i, r := range rows {
			if limit > 0 && i >= limit {
				fmt.Fprintf(&b, "  ... (%d more)\n", len(rows)-limit)
				break
			}
			fmt.Fprintf(&b, "  %-24s %7d blocks %7d B  %4.1f%%\n",
				r.name, r.blocks, r.blocks*16, 100*float64(r.blocks)/float64(s.Total))
		}
	}
	dump("by IR construct", s.ByCategory, 0)
	dump("by function", s.ByFunc, 24)
	return b.String()
}
