/*
 * File:    ee357_asm_lib.s
 * Purpose: I/O routines for assembly projects 
 * Author:  Mark Redekopp
 * Notes:   Output of strings and numbers without a newline can often cause bugs
 *            in future I/O.  This is why we do not allow single character I/O
 *
 */




	.rodata
printf_c_str:
_printf_c_str:  	.asciz	"%c"
printf_d_str:
_printf_d_str:  	.asciz	"%d\n"
//printf_x_str:
//_printf_x_str:  	.asciz	"%x"
scanf_d_str:
_scanf_d_str:  		.asciz	"%d\n"
//scanf_c_str:
//_scanf_c_str:  		.asciz	"%c"
//scanf_s_str:
//_scanf_s_str:  		.asciz	"%s"

	
    .text
#define myasmputc   _myasmputc
#define myprintf   _myprintf
#define flush _flush
#define scanf    _scanf
#define TERMIO_GetChar _TERMIO_GetChar
#define __read_console ___read_console
#define mybufferi _mybufferi

	.extern _myprintf
	.extern scanf
	.extern TERMIO_GetChar
	.extern myasmputc
	.extern _myasmputc
	.extern __read_console
	.extern _flush
	.extern _mybufferi
	
    .global ee357_put_str
    .global _ee357_put_str
    .global ee357_put_int
    .global _ee357_put_int
    .global ee357_get_str
    .global _ee357_get_str
    .global ee357_get_int
    .global _ee357_get_int
    .global ee357_put_char
    .global _ee357_put_char
//    .global ee357_get_char
//    .global _ee357_get_char

    .global ee357_put_str_trap
    .global _ee357_put_str_trap
    .global ee357_put_int_trap
    .global _ee357_put_int_trap
    .global ee357_get_str_trap
    .global _ee357_get_str_trap
    .global ee357_get_int_trap
    .global _ee357_get_int_trap
    .global ee357_put_char_trap
    .global _ee357_put_char_trap
    .global ee357_get_char_trap
    .global _ee357_get_char_trap

ee357_put_str:
_ee357_put_str:
	adda.l	#-56,sp
   	movem.l d0-d7/a0-a5, (sp)
	move.l	a1,-(a7)
	jsr 	myprintf
	adda.l	#4,sp
	movem.l (sp), d0-d7/a0-a5
	adda.l	#56,sp
	rts
	
ee357_put_int:
_ee357_put_int:
	adda.l	#-56,sp
   	movem.l d0-d7/a0-a5, (sp)
	move.l	d1,-(a7)
	move.l	#printf_d_str,-(a7)
	jsr 	myprintf
	adda.l	#8,sp
	movem.l (sp), d0-d7/a0-a5
	adda.l	#56,sp
	rts

ee357_get_str:
_ee357_get_str:
	adda.l	#-52,sp
   	movem.l d0/d2-d7/a0-a5, (sp)
   	move.l	a1,-(sp)
   	move.l	d1,-(sp)
   //	jsr		flush
   	move.l	(sp)+,d1
   	move.l	(sp)+,a1
	
	adda.l	#-28,sp
	move.l  mybufferi,d2
	move.l  d2,24(sp)
	move.l	a1,20(sp)
	move.l	d1,16(sp)
	clr.l	12(sp)
	move.l	sp,d1
	addi.l	#16,d1
	move.l	d1,8(sp)
	move.l	a1,4(sp)
	clr.l	(sp)
	jsr		__read_console
	move.l	16(sp),d1
	move.l	20(sp),a1
	move.l	24(sp),d2
	move.l	d1,mybufferi  // save new bufferi
	sub.l   d2,d1		// calculate difference
	move.l  d1,d3		// save difference to d3 for loop cntr
	movea.l a1,a2		// compute new start
	movea.l a1,a3
	adda.l  d2,a3
ee357_get_str_again:	// copy the string into the dest. array.
	move.b  (a3)+,(a2)+
	subq.l  #1,d3
	bne		ee357_get_str_again	
	clr.b	(a2)+		// Add the null char.
	adda.l	#28,sp		// Restore necessary reg's.
	movem.l (sp), d0/d2-d7/a0-a5
	adda.l	#52,sp
	rts	

ee357_get_int:
_ee357_get_int:
	adda.l	#-52,sp
   	movem.l d0/d2-d7/a0-a5, (sp)
   	jsr		flush
	adda.l	#-12,sp
	lea 	8(sp),a1
	move.l	a1,4(sp)
	move.l	#scanf_d_str,(sp)
	jsr 	_scanf
	move.l	8(sp),d1
	adda.l	#12,sp
	movem.l (sp), d0/d2-d7/a0-a5
	adda.l	#52,sp
	rts

ee357_put_char:
_ee357_put_char:
	adda.l	#-56,sp
 	movem.l d0-d7/a0-a5, (sp)
	extb.l	d1
	move.l	d1,-(sp)
	jsr 	myasmputc
	adda.l	#4,sp
//	move.l	#0x0a,d1
//	move.l	d1,-(sp)
//	jsr 	myasmputc	
//	adda.l	#4,sp
	movem.l (sp), d0-d7/a0-a5
	adda.l	#56,sp
	rts

//ee357_get_char:
//_ee357_get_char:
//	adda.l	#-52,sp
// 	movem.l d0/d2-d7/a0-a5, (sp)
//	adda.l	#-24,sp
//	move.l	#1,d1
//	move.l	d1,16(sp)
//	clr.l	12(sp)
//	move.l	sp,d1
//	addi.l	#16,d1
//	move.l	d1,8(sp)
//	lea		20(sp),a1
//	move.l	a1,4(sp)
//	clr.l	(sp)
//	jsr		__read_console
//	move.b	20(sp),d1
//	adda.l	#24,sp
//	movem.l (sp), d0/d2-d7/a0-a5
//	adda.l	#52,sp
//	rts	


	
ee357_put_str_trap:
_ee357_put_str_trap:
	adda.l	#-56,sp
   	movem.l d0-d7/a0-a5, (sp)
	move.l	a1,-(a7)
	jsr 	myprintf
	adda.l	#4,sp
	movem.l (sp), d0-d7/a0-a5
	adda.l	#56,sp
	rte
	
ee357_put_int_trap:
_ee357_put_int_trap:
	adda.l	#-56,sp
   	movem.l d0-d7/a0-a5, (sp)
	move.l	d1,-(a7)
	move.l	#printf_d_str,-(a7)
	jsr 	myprintf
	adda.l	#8,sp
	movem.l (sp), d0-d7/a0-a5
	adda.l	#56,sp
	rte

ee357_get_str_trap:
_ee357_get_str_trap:
	adda.l	#-52,sp
   	movem.l d0/d2-d7/a0-a5, (sp)
	adda.l	#-24,sp
	move.l	a1,20(sp)
	move.l	d1,16(sp)
	clr.l	12(sp)
	move.l	sp,d1
	addi.l	#16,d1
	move.l	d1,8(sp)
	move.l	a1,4(sp)
	clr.l	(sp)
	jsr		__read_console
	move.l	16(sp),d1
	move.l	20(sp),a1
	adda.l	#24,sp
	movem.l (sp), d0/d2-d7/a0-a5
	adda.l	#52,sp
	rte

ee357_get_int_trap:
_ee357_get_int_trap:
	adda.l	#-52,sp
   	movem.l d0/d2-d7/a0-a5, (sp)
	adda.l	#-12,sp
	lea 	8(sp),a1
	move.l	a1,4(sp)
	move.l	#scanf_d_str,(sp)
	jsr 	_scanf
	move.l	8(sp),d1
	adda.l	#12,sp
	movem.l (sp), d0/d2-d7/a0-a5
	adda.l	#52,sp
	rte

ee357_put_char_trap:
_ee357_put_char_trap:
//	adda.l	#-56,sp
// 	movem.l d0-d7/a0-a5, (sp)
//	extb.l	d1
//	move.l	d1,-(sp)
//	jsr 	fputc
//	adda.l	#4,sp
//	movem.l (sp), d0-d7/a0-a5
//	adda.l	#56,sp
	rte

ee357_get_char_trap:
_ee357_get_char_trap:
//	adda.l	#-52,sp
//   	movem.l d0/d2-d7/a0-a5, (sp)
//	adda.l	#-24,sp
//	move.l	#2,d1
//	move.l	d1,16(sp)
//	clr.l	12(sp)
//	move.l	sp,d1
//	addi.l	#16,d1
//	move.l	d1,8(sp)
//	lea		20(sp),a1
//	move.l	a1,4(sp)
//	clr.l	(sp)
//	jsr		__read_console
//	move.b	20(sp),d1
//	adda.l	#24,sp
//	movem.l (sp), d0/d2-d7/a0-a5
//	adda.l	#52,sp
	rte	

