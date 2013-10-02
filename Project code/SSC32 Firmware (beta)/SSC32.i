
#pragma used+
sfrb PINB=3;
sfrb DDRB=4;
sfrb PORTB=5;
sfrb PINC=6;
sfrb DDRC=7;
sfrb PORTC=8;
sfrb PIND=9;
sfrb DDRD=0xa;
sfrb PORTD=0xb;
sfrb TIFR0=0x15;
sfrb TIFR1=0x16;
sfrb TIFR2=0x17;
sfrb PCIFR=0x1b;
sfrb EIFR=0x1c;
sfrb EIMSK=0x1d;
sfrb GPIOR0=0x1e;
sfrb EECR=0x1f;
sfrb EEDR=0x20;
sfrb EEARL=0x21;
sfrb EEARH=0x22;
sfrw EEAR=0x21;   
sfrb GTCCR=0x23;
sfrb TCCR0A=0x24;
sfrb TCCR0B=0x25;
sfrb TCNT0=0x26;
sfrb OCR0A=0x27;
sfrb OCR0B=0x28;
sfrb GPIOR1=0x2a;
sfrb GPIOR2=0x2b;
sfrb SPCR=0x2c;
sfrb SPSR=0x2d;
sfrb SPDR=0x2e;
sfrb ACSR=0x30;
sfrb MONDR=0x31;
sfrb SMCR=0x33;
sfrb MCUSR=0x34;
sfrb MCUCR=0x35;
sfrb SPMCSR=0x37;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
#endasm

void SSC32_Init();
void SetBaud(char PD);

void DebugLong(long var);
void DebugInt(int var);
void DebugChar(char var);

void SSC32_Init()
{

#pragma optsize-
(*(unsigned char *) 0x61)=0x80;
(*(unsigned char *) 0x61)=0x00;
#pragma optsize+

PORTB=0x00;
DDRB=0x3E;

PORTC=0x00;
DDRC=0xFF;

PORTD=0x18;
DDRD=0xC4;

TCCR0A=0x00;

TCCR0B=0x00;
TCNT0=0x00;

OCR0A=0x90;
OCR0B=0x00;

(*(unsigned char *) 0x80)=0x00;
(*(unsigned char *) 0x81)=0x00;
(*(unsigned char *) 0x82)=0x00;

(*(unsigned char *) 0x87)=0x00;
(*(unsigned char *) 0x86)=0x00;

(*(unsigned char *) 0x89)=0x90;
(*(unsigned char *) 0x88)=0x00;

(*(unsigned char *) 0x8b)=0x0A;
(*(unsigned char *) 0x8a)=0xCD;

(*(unsigned char *) 0xb6)=0x00;
(*(unsigned char *) 0xb0)=0x00;
(*(unsigned char *) 0xb1)=0x00;
(*(unsigned char *) 0xb2)=0x00;
(*(unsigned char *) 0xb3)=0x00;
(*(unsigned char *) 0xb4)=0x00;

(*(unsigned char *) 0x69)=0x00;
EIMSK=0x00;
(*(unsigned char *) 0x68)=0x00;

(*(unsigned char *) 0x6e)=0x02;

(*(unsigned char *) 0x6f)=0x06;

(*(unsigned char *) 0x70)=0x00;

(*(unsigned char *) 0xc0)=0x00;
(*(unsigned char *) 0xc1)=0xD8;
(*(unsigned char *) 0xc2)=0x06;
(*(unsigned char *) 0xc5)=0x00;
(*(unsigned char *) 0xc4)=0x5F;

ACSR=0x80;
(*(unsigned char *) 0x7b)=0x00;

SPCR=0x50;
SPSR=0x01;

#asm
    in   r30,spsr
    in   r30,spdr
#endasm

#asm("sei")

}

void SetBaud(char PD)
{
switch (PD)
{
case 0:
(*(unsigned char *) 0xc5)=0x00;
(*(unsigned char *) 0xc4)=0x07;
break;
case 1:  
(*(unsigned char *) 0xc5)=0x00;
(*(unsigned char *) 0xc4)=0x17;
break;
case 2: 
(*(unsigned char *) 0xc5)=0x00;
(*(unsigned char *) 0xc4)=0x5F;
break;
case 3: 
(*(unsigned char *) 0xc5)=0x01;
(*(unsigned char *) 0xc4)=0x7F;
break;
}   
}

void DebugLong(long var)
{
(*(unsigned char *) 0x81)=0x00;
SPDR = var&0xFF;while(!(SPSR>>7));
PORTB.1 = 1;PORTB.1 = 0;
SPDR = var>>8;while(!(SPSR>>7));
PORTB.2 = 1;PORTB.2 = 0;
SPDR = var>>16;while(!(SPSR>>7));
PORTD.6 = 1;PORTD.6 = 0;
SPDR = var>>24;while(!(SPSR>>7));
PORTD.7 = 1;PORTD.7 = 0;

while(1);
}
void DebugInt(int var)
{
(*(unsigned char *) 0x81)=0x00;
SPDR = var&0xFF;while(!(SPSR>>7));
PORTB.1 = 1;PORTB.1 = 0;
SPDR = var>>8;while(!(SPSR>>7));
PORTB.2 = 1;PORTB.2 = 0;

while(1);
}
void DebugChar(char var)
{
(*(unsigned char *) 0x81)=0x00;
SPDR = var&0xFF;while(!(SPSR>>7));
PORTB.1 = 1;PORTB.1 = 0;

while(1);
}
