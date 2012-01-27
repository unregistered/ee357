#include <stdarg.h>
#include "usc_support.h"

/********************************************************************/
/*
 * Pause for the specified number of micro-seconds.
 * Uses DTIM3 as a timer
 */
void
cpu_pause(int usecs)
{
    /* Enable the DMA Timer 3 */
    MCF_DTIM3_DTRR = (uint32)(usecs - 1);
    MCF_DTIM3_DTER = MCF_DTIM_DTER_REF;
    MCF_DTIM3_DTMR = 0
        | MCF_DTIM_DTMR_PS(SYSTEM_CLOCK_KHZ / 1000)
        | MCF_DTIM_DTMR_ORRI
        | MCF_DTIM_DTMR_FRR
        | MCF_DTIM_DTMR_CLK_DIV1
        | MCF_DTIM_DTMR_RST;

    while ((MCF_DTIM3_DTER & MCF_DTIM_DTER_REF) == 0) 
    {};
    
    /* Disable the timer */
    MCF_DTIM3_DTMR = 0;
}

uint32 mcf5xxx_set_cpl(uint32 level)
{
  register uint32 my_sr;
  uint32 my_ipl;
  uint32 old_level;
  	
  asm
  {
	move.w  SR,D0
	move.l  D0,my_sr	
	
  }
	
  my_sr &= 0x0000f8ff;
  my_ipl = level & 0x07;
  old_level = my_sr >> 8;
  old_level = my_sr & 0x07;
  my_ipl = my_ipl << 8;
  my_sr |= my_ipl; 
	
  asm
  {
	move.l  my_sr,D0
	move.w  D0,SR
  }	
  return old_level;
}

uint32 mcf5xxx_get_cpl()
{
  uint32 my_sr;
  	
  asm
  {
	move.w  SR,D0
	move.l  D0,my_sr	
	
  }
	
  my_sr = my_sr >> 8;
  my_sr = my_sr & 0x07;
  return my_sr;
}
	
	
void mcf5xxx_irq_enable()
{
  mcf5xxx_set_cpl(0);	
}

void mcf5xxx_irq_disable()
{
  mcf5xxx_set_cpl(7);	
}

void
mcf5xxx_set_handler (int vector, void (*handler) (void))
{
    extern uint32 __VECTOR_RAM[];

    __VECTOR_RAM[vector] = (uint32)handler;
}

// *** printf ***************************************************************

// N.B. we add buffering to the default printf since we can only process
//      a few BDM accesses per second thru the "Trap #14" mechanism... :-(

#define assert(x)  if (! (x)) { asm { halt } }

#define isdigit(c)  ((c) >= '0' && (c) <= '9')

#define MAXDIGITS  32

static char digits[] = "0123456789abcdef";
static char zeros[] = "00000000000000000000000000000000";
static char spaces[] = "                                ";

static asm __declspec(register_abi)
unsigned char
TRKAccessFile(long command, unsigned long file_handle, unsigned long *length_ptr, char *buffer_ptr)
{
    move.l    D3,-(a7)
    andi.l    #0x000000ff,D0
    move.l    A1,D3
    movea.l   A0,A1
    move.l    (A1),D2
    trap      #14
    move.l    D1,(A1)
    move.l    (A7)+,D3
    rts
}

#define SYNCHRONOUS  1

unsigned long mybufferi = 0;
static
int
myputchar(char ch)
{
    static unsigned long bufferi;
    static char buffer[256];

    if (ch) {
        buffer[bufferi++] = ch;
    }
    if ((! ch && bufferi) || (SYNCHRONOUS && ch == '\n') || bufferi == sizeof(buffer)) {
        if(SYNCHRONOUS && ch == '\n')
        	mybufferi = 0;
        else
        	mybufferi += bufferi;
        TRKAccessFile(0xD0, 0, &bufferi, buffer);
        bufferi = 0;
    }
}

static
int
myputchars(char *s, int n)
{
    int i;

    i = 0;
    if (! n) {
        n--;
    }
    while (*s && n--) {
        myputchar(*s++);
        i++;
    }
    return i;
}

static
int
convert(unsigned value, unsigned radix, char *buffer)
{
    int i;
    int n;
    unsigned scale;
    unsigned lastscale;
    unsigned digit;

    assert(radix >= 2 && radix < sizeof(digits));

    // first find our scale
    lastscale = 1;
    scale = radix;
    for (n = 0; n < MAXDIGITS; n++) {
        if (value < scale || scale/radix != lastscale) {
            break;
        }
        lastscale = scale;  // in case we overflow
        scale *= radix;
    }
    scale = lastscale;

    // then work our digits
    i = 0;
    do {
        assert(scale);
        digit = value/scale;
        buffer[i++] = digits[digit];
        value -= digit*scale;
        scale /= radix;
    } while (n--);

    // nul terminate
    buffer[i] = '\0';
    return i;
}


int flush_delay;

int
myprintf(char *format, ...)
{

    int i;
    int j;
    int n;
    char c;
    char *p;
    int zero;
    int width;
    va_list ap;
    char buffer[MAXDIGITS+1];

    i = 0;

    va_start(ap, format);
    mcf5xxx_irq_disable();
    flush_delay = 1000;

    for (p = format; *p; p++) {
        c = *p;
        if (c == '%') {
            zero = 0;
            width = 0;
            c = *++p;
            if (isdigit(c)) {
                if (c == '0') {
                    zero = 1;
                    c = *++p;
                    assert(isdigit(c));
                }
                width = c - '0';
                c = *++p;
            }
            n = va_arg(ap, int);
            switch (c) {
                case 'b':
                    j = convert( (unsigned int)n, 2, buffer);
                    break;
                case 'c':
                    buffer[0] = (char)n;
                    buffer[1] = '\0';
                    j = 1;
                    break;
                case 'd':
                    j = convert((unsigned int)n, 10, buffer);
                    break;
                case 'o':
                    j = convert((unsigned int)n, 8, buffer);
                    break;
                case 's':
                    j = myputchars((char *)n, 0);
                    buffer[0] = '\0';
                    break;
                case 'x':
                    j = convert((unsigned int)n, 16, buffer);
                    break;
                default:
                    assert(0);
            }
            if (j < width) {
                if (zero) {
                    myputchars(zeros, width-j);
                } else {
                    myputchars(spaces, width-j);
                }
            }
            i += j;
            myputchars(buffer, 0);
        } else {
            i++;
            myputchar(c);
        }
    }
    myputchar('\0');

    mcf5xxx_irq_enable();
    va_end(ap);

    return i;
}

void
flush(void)
{
    mcf5xxx_irq_disable();
    myputchar('\0');
    mcf5xxx_irq_enable();
}

int
myasmputc(uint32 c)
{
    mcf5xxx_irq_disable();
	myputchar((char) c);
    myputchar('\0');
    mcf5xxx_irq_enable();

}
// **************************************************************************
