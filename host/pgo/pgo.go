// Package pgo holds the committed profile-guided settings: the
// hot-literal sets that decide each image's flash/SRAM pool split, the
// hot-function sets that decide which functions keep the fast four-move
// compare protocol under dmacc's OptSize, and the cold-block sets that
// decide each function's block layout.
//
// Every map in this package is GENERATED, never hand-edited. The
// generator is TestGenPGO (host/dmacc/zz_pgogen_test.go): it boots each
// deployable payload in the emulator, drives its representative
// workload, and counts bus reads per word over the images' literal
// pools (SRAM data) and XIP text (instruction fetch = flash reads).
// Regenerate with
//
//	make pgo
//
// The settings are INPUTS to the build, not test expectations: a
// regenerated set changes image layout and cycle counts, so a
// regeneration is a measurement to be reported, not a golden to be
// refreshed when something fails.
//
// The consumers:
//
//   - dmaasm.Options.HotLits — the *Lits maps. Under Options.PoolText a
//     literal not named here moves to the flash text tail; the named
//     ones stay in resident SRAM data. Bigger set = fewer flash reads,
//     more SRAM (4 bytes per key).
//   - dmacc.Options.HotFuncs — the *HotFuncs maps, with OptSize on. A
//     function named here keeps the four-move compare protocol; every
//     other function takes the two-record descriptor form.
//   - dmacc.Options.ColdBlocks — the *ColdBlocks maps. A block named
//     here sinks to the end of its function, so the blocks that do run
//     lie back to back. Cold-set, not hot-set: an unlisted block is
//     left where it is, which makes a stale set a lost optimization
//     rather than a wrong one.
//
// Board windows bound the *Lits sets: the generator trims each set by
// descending read count until its resident cost fits the tightest board
// that ships the image (host/boards). The trim is recorded in the
// header comment of the generated file.
package pgo

// LitsFor returns the hot-literal set for a registry image built by
// name — the images that are compiled and staged one at a time by both
// dmxgen and the test harness. Names without a profile get nil, which
// means "all cold" under Options.PoolText.
func LitsFor(name string) map[string]bool {
	switch name {
	case "vi":
		return ViLits
	}
	return nil
}

// ColdBlocksFor returns the cold-block set for a registry image built
// by name, the ColdBlocks companion of LitsFor. Names without a profile
// get nil, which is the plain IR-order layout.
func ColdBlocksFor(name string) map[string]bool {
	switch name {
	case "vi":
		return ViColdBlocks
	}
	return nil
}
