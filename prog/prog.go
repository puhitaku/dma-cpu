// Package prog embeds the project's DMA-machine assembly programs so
// tools (dmxgen, tests) can assemble them from anywhere.
package prog

import "embed"

//go:embed hil/*.dasm
var FS embed.FS

// HIL returns the source of a hardware-in-the-loop test program.
func HIL(name string) (string, error) {
	b, err := FS.ReadFile("hil/" + name + ".dasm")
	return string(b), err
}
