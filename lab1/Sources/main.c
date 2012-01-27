 /*
 * main implementation: use this sample to create your own application
 *
 */


#include "support_common.h" /* include peripheral declarations and more */
#if (CONSOLE_IO_SUPPORT || ENABLE_UART_SUPPORT)
/* Standard IO is only possible if Console or UART support is enabled. */
#include <stdio.h>
#endif


int main(void)
{
	int counter = 0;

#if (CONSOLE_IO_SUPPORT || ENABLE_UART_SUPPORT)
	printf("Hello World in C++ from MCF52259 derivative on MCF52259 board\n\r");
#endif
	asm {
		move.l #0,d0
		move.b d0,0x4010006F     // set PTCPAR for GPIO on all 4 bits
		move.l #0x0f,d0
		move.b d0,0x40100027     // set DDRTC to make PTCPAR[3:0] outputs
		move.l #0x00,d0
		move.b d0,0x4010000F     // set the output bits
		
		move.l #0x0,d0
		move.b d0,0x40100074     // set PDDPAR for GPIO for all 8 bits
		move.l #0,d0
		move.b d0,0x4010002C     // set DDRDD as inputs
		
MAIN:	move.b 0x40100044,d0
		not.l d0
		lsr.l #4,d0
		move.b d0,0x4010000f
		
		
		bra MAIN
	
	}	
	for(;;) {	   
	   	counter++;
	}
}
