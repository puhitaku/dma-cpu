package emu

// SPI-mode SD card model (machine-driven SD, the last ARM storage
// duty): attached behind SPI0 whenever Machine.SDImage is set. Full
// duplex at byte granularity — every SSPDR write clocks one TX byte
// into the card and one response byte into the RX queue; SSPSR.RNE
// and the SPI0 RX DREQ track the queue level. Command handling covers
// the SPI-mode init handshake (CMD0/8/55/ACMD41/58/16), capacity
// (CMD9, CSD v2 synthesized from the image size) and single-sector
// reads (CMD17, block addressing — the OCR reports CCS=1). Responses
// are prefixed with one 0xFF (the card's Ncr gap), so drivers that
// poll for R1 exercise their loops. Reads past the image serve 0xFF,
// like a bigger card with unwritten sectors.
type sdCard struct {
	cmd  []byte // command frame being collected
	resp []byte // queued response bytes (shifted out on further clocks)
	acmd bool   // previous command was CMD55
	a41  int    // ACMD41 polls seen (first answers busy: 0x01)
}

// sdStep clocks one full-duplex byte exchange.
func (m *Machine) sdStep(tx byte) byte {
	c := &m.sdc
	if len(c.resp) > 0 {
		r := c.resp[0]
		c.resp = c.resp[1:]
		return r
	}
	if len(c.cmd) == 0 {
		if tx&0xC0 == 0x40 {
			c.cmd = append(c.cmd[:0], tx)
		}
		return 0xFF
	}
	c.cmd = append(c.cmd, tx)
	if len(c.cmd) < 6 {
		return 0xFF
	}
	cmd := c.cmd[0] & 0x3F
	arg := uint32(c.cmd[1])<<24 | uint32(c.cmd[2])<<16 |
		uint32(c.cmd[3])<<8 | uint32(c.cmd[4])
	c.cmd = c.cmd[:0]
	acmd := c.acmd
	c.acmd = false
	r1 := func(bs ...byte) {
		c.resp = append(append(c.resp[:0], 0xFF), bs...)
	}
	switch {
	case cmd == 0:
		r1(0x01)
	case cmd == 8:
		r1(0x01, 0x00, 0x00, 0x01, 0xAA)
	case cmd == 55:
		c.acmd = true
		r1(0x01)
	case cmd == 41 && acmd:
		c.a41++
		if c.a41 >= 2 {
			r1(0x00)
		} else {
			r1(0x01)
		}
	case cmd == 58:
		r1(0x00, 0xC0, 0x00, 0x00, 0x00) // powered up, CCS=1 (SDHC)
	case cmd == 16:
		r1(0x00)
	case cmd == 9: // SEND_CSD: v2, capacity = (C_SIZE+1) * 1024 sectors
		secs := (uint32(len(m.SDImage)) + 511) / 512
		csize := (secs + 1023) / 1024
		if csize > 0 {
			csize--
		}
		var csd [16]byte
		csd[0] = 0x40
		csd[7] = byte(csize>>16) & 0x3F
		csd[8] = byte(csize >> 8)
		csd[9] = byte(csize)
		c.resp = append(c.resp[:0], 0xFF, 0x00, 0xFF, 0xFE)
		c.resp = append(c.resp, csd[:]...)
		c.resp = append(c.resp, 0, 0) // CRC
	case cmd == 17: // READ_SINGLE_BLOCK (block-addressed: CCS=1)
		c.resp = append(c.resp[:0], 0xFF, 0x00, 0xFF, 0xFE)
		off := int(arg) * 512
		for i := 0; i < 512; i++ {
			b := byte(0xFF)
			if p := off + i; p >= 0 && p < len(m.SDImage) {
				b = m.SDImage[p]
			}
			c.resp = append(c.resp, b)
		}
		c.resp = append(c.resp, 0, 0) // CRC
	default:
		r1(0x04) // illegal command
	}
	return 0xFF
}
