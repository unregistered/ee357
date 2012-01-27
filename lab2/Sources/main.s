		.data
NSAMP	.equ	5
arr1:	.space NSAMP

		.text
		.global _main
		.global main
		.include "../Project_Headers/ee357_asm_lib_hdr.s"
		
_main:
main:
		// Setup
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

    // Lab 2
    