.data
	NSAMP	.equ	2
	SECOND .equ 4440000
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

	move.l arr1,a1
	move.b #NSAMP,d7
	sample:
		move.b #8,d6 // Count down from 8
		countdown:
			move.b d6,0x4010000f // Display on LEDs
			// Pause for 1 second
			move.l #1*SECOND,d0
			bsr sleep
			
			subq.l #1,d6
			bne countdown
		
		// Do sampling
		move.b 0x40100044,d3
		not.l d3
		lsr.l #4,d3
		move.b d3,(a1)+
		
		subq.l #1,d7
		bne sample
    
	move.b #NSAMP,d1
	playback:
		// Display on LEDs
		move.l #arr1,a1
		move.b (a1),0x4010000f
	
		// Pause for 2 seconds
		move.l #2*SECOND,d0
		bsr sleep
		
		subq.l #1,d1
		bne playback

sleep:
		subq.l #1,d0
		bne sleep
		rts
	
	
      
