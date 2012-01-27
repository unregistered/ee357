/*
 * File: ee357_exceptions.h
 * Purpose: Generic exception handling for ColdFire processors
 *
 * Notes:
 */

#ifndef _EE357_EXCEPTIONS_H
#define _EE357_EXCEPTIONS_H

/* List Trap handler labels prototyped as functions below */
extern void ee357_put_str_trap(void);
extern void ee357_put_int_trap(void);
extern void ee357_get_str_trap(void);
extern void	ee357_get_int_trap(void);
extern void ee357_put_char_trap(void);

#endif

