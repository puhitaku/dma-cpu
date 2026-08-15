/* DMX loader implementation. See dmx.h and doc/dmx.md. */

#include "dmx.h"

#define DMX_MAGIC 0x31584D44u /* "DMX1" */
#define DMX_REF_ABS 0xFFFFFFFFu

/* DMA register block (RP2040 datasheet §2.5). */
#define DMA_BASE 0x50000000u
#define DMA_CH_STRIDE 0x40u
#define DMA_CH_READ_ADDR 0x00u
#define DMA_CH_WRITE_ADDR 0x04u
#define DMA_CH_TRANS_COUNT 0x08u
#define DMA_CH_CTRL_TRIG 0x0Cu
#define DMA_CH_AL1_CTRL 0x10u
#define DMA_CH_AL1_READ_ADDR 0x14u
#define DMA_CH_AL1_WRITE_ADDR 0x18u
#define DMA_CH_AL2_TRANS_COUNT 0x24u
#define DMA_CH_AL2_WRITE_ADDR_TRIG 0x2Cu

/* CTRL fields used by the machine channels. */
#define CTRL_EN (1u << 0)
#define CTRL_SIZE32 (2u << 2)
#define CTRL_INCR_READ (1u << 4)
#define CTRL_INCR_WRITE (1u << 5)
#define CTRL_CHAIN_TO(ch) ((uint32_t)(ch) << 11)
#define CTRL_TREQ_PERMANENT (0x3Fu << 15)
#define CTRL_IRQ_QUIET (1u << 21)

static inline void mmio_write(uint32_t addr, uint32_t val)
{
    *(volatile uint32_t *)(uintptr_t)addr = val;
}

static inline uint32_t ch_reg(int ch, uint32_t off)
{
    return DMA_BASE + (uint32_t)ch * DMA_CH_STRIDE + off;
}

/* The image may live in flash at arbitrary alignment: assemble words
 * bytewise (DMX is little-endian). */
static uint32_t rd32(const uint8_t *p)
{
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) | ((uint32_t)p[2] << 16) |
           ((uint32_t)p[3] << 24);
}

static void wr32_sram(uint32_t addr, uint32_t val)
{
    *(uint32_t *)(uintptr_t)addr = val;
}

static uint32_t rd32_sram(uint32_t addr)
{
    return *(const uint32_t *)(uintptr_t)addr;
}

int dmx_load(const uint8_t *image, size_t len, const dmx_placement *pl,
             uint32_t *entry_out)
{
    if (len < 7 * 4) {
        return DMX_ERR_TRUNCATED;
    }
    if (rd32(image) != DMX_MAGIC) {
        return DMX_ERR_MAGIC;
    }
    if (rd32(image + 4) != 0) {
        return DMX_ERR_FLAGS;
    }
    uint32_t n_seg = rd32(image + 8);
    uint32_t n_rel = rd32(image + 12);
    uint32_t n_wr = rd32(image + 16);
    uint32_t entry_seg = rd32(image + 20);
    uint32_t entry_off = rd32(image + 24);
    if (n_seg > DMX_MAX_SEGMENTS) {
        return DMX_ERR_TOO_MANY;
    }

    const uint8_t *seg_tab = image + 7 * 4;
    const uint8_t *rel_tab = seg_tab + (size_t)n_seg * 8;
    const uint8_t *wr_tab = rel_tab + (size_t)n_rel * 12;
    const uint8_t *seg_data = wr_tab + (size_t)n_wr * 12;
    /* Overflow-safe total-size check: accumulate in size_t steps. */
    size_t need = (size_t)(seg_data - image);
    if (need > len) {
        return DMX_ERR_TRUNCATED;
    }

    uint32_t place[DMX_MAX_SEGMENTS];
    uint32_t delta[DMX_MAX_SEGMENTS];
    uint32_t size[DMX_MAX_SEGMENTS];
    for (uint32_t i = 0; i < n_seg; i++) {
        uint32_t link = rd32(seg_tab + i * 8);
        size[i] = rd32(seg_tab + i * 8 + 4);
        place[i] = link;
        if (pl != NULL && pl->addr[i] != 0) {
            place[i] = pl->addr[i];
        }
        if ((place[i] % 4) != 0 || (size[i] % 4) != 0) {
            return DMX_ERR_ALIGN;
        }
        delta[i] = place[i] - link;
        need += size[i];
    }
    if (need > len) {
        return DMX_ERR_TRUNCATED;
    }

    /* Copy segments to their placed addresses. */
    const uint8_t *src = seg_data;
    for (uint32_t i = 0; i < n_seg; i++) {
        for (uint32_t off = 0; off < size[i]; off += 4) {
            wr32_sram(place[i] + off, rd32(src + off));
        }
        src += size[i];
    }

    /* Apply relocations in place. */
    for (uint32_t i = 0; i < n_rel; i++) {
        uint32_t seg = rd32(rel_tab + i * 12);
        uint32_t off = rd32(rel_tab + i * 12 + 4);
        uint32_t ref = rd32(rel_tab + i * 12 + 8);
        if (seg >= n_seg || ref >= n_seg || (off % 4) != 0 ||
            off + 4 > size[seg]) {
            return DMX_ERR_RANGE;
        }
        uint32_t addr = place[seg] + off;
        wr32_sram(addr, rd32_sram(addr) + delta[ref]);
    }

    /* Init writes, in table order. */
    for (uint32_t i = 0; i < n_wr; i++) {
        uint32_t addr = rd32(wr_tab + i * 12);
        uint32_t val = rd32(wr_tab + i * 12 + 4);
        uint32_t ref = rd32(wr_tab + i * 12 + 8);
        if (ref != DMX_REF_ABS) {
            if (ref >= n_seg) {
                return DMX_ERR_RANGE;
            }
            val += delta[ref];
        }
        mmio_write(addr, val);
    }

    if (entry_seg >= n_seg || entry_off >= size[entry_seg]) {
        return DMX_ERR_RANGE;
    }
    uint32_t entry = place[entry_seg] + entry_off;
    if ((entry % 16) != 0) {
        return DMX_ERR_ALIGN;
    }
    *entry_out = entry;
    return DMX_OK;
}

int dmx_start(const dmx_machine_cfg *cfg, uint32_t entry)
{
    if (cfg->fetch == cfg->exec || cfg->exec == cfg->fix ||
        cfg->fetch == cfg->fix) {
        return DMX_ERR_CONFIG;
    }
    if ((entry % 16) != 0) {
        return DMX_ERR_ALIGN;
    }
    uint32_t exec_regs = ch_reg(cfg->exec, 0);

    /* Mirrors emu.SetupFetchExec (img/load.go is the reference).
     * Fix: one transfer, scratch -> fetch.AL2_WRITE_ADDR_TRIG. */
    wr32_sram(cfg->scratch, exec_regs);
    mmio_write(ch_reg(cfg->fix, DMA_CH_AL1_READ_ADDR), cfg->scratch);
    mmio_write(ch_reg(cfg->fix, DMA_CH_AL1_WRITE_ADDR),
               ch_reg(cfg->fetch, DMA_CH_AL2_WRITE_ADDR_TRIG));
    mmio_write(ch_reg(cfg->fix, DMA_CH_AL2_TRANS_COUNT), 1);
    mmio_write(ch_reg(cfg->fix, DMA_CH_AL1_CTRL),
               CTRL_EN | CTRL_SIZE32 | CTRL_TREQ_PERMANENT |
                   CTRL_CHAIN_TO(cfg->fix) | CTRL_IRQ_QUIET);

    /* Fetch: four transfers per block, both pointers incrementing. */
    uint32_t fetch_ctrl = CTRL_EN | CTRL_SIZE32 | CTRL_INCR_READ |
                          CTRL_INCR_WRITE | CTRL_TREQ_PERMANENT |
                          CTRL_CHAIN_TO(cfg->fetch) | CTRL_IRQ_QUIET;
    mmio_write(ch_reg(cfg->fetch, DMA_CH_READ_ADDR), entry);
    mmio_write(ch_reg(cfg->fetch, DMA_CH_WRITE_ADDR), exec_regs);
    mmio_write(ch_reg(cfg->fetch, DMA_CH_TRANS_COUNT), 4);

    /* Writing CTRL_TRIG with EN set starts the first fetch. */
    mmio_write(ch_reg(cfg->fetch, DMA_CH_CTRL_TRIG), fetch_ctrl);
    return DMX_OK;
}
