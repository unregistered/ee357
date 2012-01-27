
// Place static data declarations/directives here
  		.data
// Replace declaration below.
mybuf:	.space 80
mymsg:  .asciz "ASM template for EE 357\n"  // Remember to put and get
prmpt0: .asciz "Here is an integer:\n"		// strings terminated with
prmpt1: .asciz "Enter a string:\n"          // newline characters 
prmpt2: .asciz "Enter an integer:\n"
  		.text
		.global _main
		.global main
		.global mydat
		.include "../Project_Headers/ee357_asm_lib_hdr.s"

_main:
main:	
//------- Template Test: Replace Me ----- //
		// Prints welcome message
		movea.l	#mymsg,a1
		jsr		ee357_put_str
		// Prints a string and an integer to the screen
		movea.l	#prmpt0,a1
		jsr		ee357_put_str
		move.l  #357,d1
		jsr		ee357_put_int

//======= Let the following few lines always end your main routing ===//		
//------- No OS to return to so loop ---- //
//------- infinitely...Never hits rts --- //		
inflp:	bra.s	inflp
		rts
		
//------ Defines subroutines here ------- //
//------  Replace sub1 definition ------- //
sub1:	clr.l d0
		rts
