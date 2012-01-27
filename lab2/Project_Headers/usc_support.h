#ifndef USC_SUPPORT_H
#define USC_SUPPORT_H
#include "support_common.h"
#ifdef __MCF52259_H__
	#define SYSTEM_CLOCK_KHZ 64000
#endif

void cpu_pause(int);
uint32 mcf5xxx_set_cpl(uint32);
void mcf5xxx_irq_enable();
void mcf5xxx_irq_disable();
void mcf5xxx_set_handler (int , void (*handler) (void));

static int myputchar(char ch);
static int myputchars(char *s, int n);
int myprintf(char *format, ...);
void flush(void);
int myasmputc(uint32 c);
#endif