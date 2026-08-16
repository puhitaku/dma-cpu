/* Compiler-known hardware registers: dmacc maps these globals to the
 * SKU-resolved UART0 registers (%uartdr/%uartfr in dmaasm). Loads and
 * stores become direct MMIO moves; taking their address is an error. */
#ifndef _DMA_MMIO_H_
#define _DMA_MMIO_H_

extern volatile unsigned int __dma_uart_dr; /* PL011 UART0 DR */
extern volatile unsigned int __dma_uart_fr; /* PL011 UART0 FR */

#define DMA_UART_FR_TXFF (1u << 5)

#endif
