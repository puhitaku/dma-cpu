package emu

// QSPI flash: the model is a plain byte array served through the XIP
// read window (machine.go). There is deliberately NO QMI direct-mode
// or NOR command model: the RP2350 DMA engine cannot drive flash
// writes (it cannot read QMI registers, and entering direct mode
// freezes its peripheral-read path — silicon-characterized in
// prompts/023), so the machine-side driver was removed. Writes happen
// through the ARM-executor mailbox, which emulator tests service
// directly against Flash between run chunks.
const XIPBase = 0x10000000
