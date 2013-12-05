
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

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

extern unsigned int Timer_Count;
extern unsigned char b_echo_back;

void SSC32_Init();
void SetBaud(char PD);

void DebugLong(unsigned long var);
void DebugInt(unsigned int var);
void DebugChar(unsigned char var);

unsigned int read_adc(unsigned char adc_input);

unsigned int read_distance();

extern unsigned const char Servo[32];

extern unsigned char PW_SPI_B0[33];
extern unsigned char PW_SPI_B1[33];
extern unsigned char PW_SPI_B2[33];
extern unsigned char PW_SPI_B3[33];

extern unsigned char Edges_Ctr;

extern unsigned char Edges_Ptr;

extern unsigned long int PW_Mask[32];

extern unsigned int PW_Time[32];

extern unsigned int PW_Width[32];

extern unsigned int SV_Width[32];

void PW_Init();

void PW_Start();

void PW_Stop();

void PW_Set(char channel, int width, char extend);          

void PW_Update_SPI();

char Max(char* arr,char length);

char rx_buffer0[256];

unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;

bit rx_buffer_overflow0;

interrupt [19] void usart_rx_isr(void)
{
char status,data;
status=(*(unsigned char *) 0xc0);
data=(*(unsigned char *) 0xc6);
if ((status & ((1<<4) | (1<<2) | (1<<3)))==0)
{
rx_buffer0[rx_wr_index0]=data;
if (++rx_wr_index0 == 256) rx_wr_index0=0;
if (++rx_counter0 == 256)
{
rx_counter0=0;
rx_buffer_overflow0=1;
};
};
}

#pragma used+
char getchar(void)
{
char data;
while (rx_counter0==0);
data=rx_buffer0[rx_rd_index0];
if (++rx_rd_index0 == 256) rx_rd_index0=0;
#asm("cli")
--rx_counter0;
#asm("sei")
return data;
}
#pragma used-

char tx_buffer0[256];

unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;

interrupt [21] void usart_tx_isr(void)
{
if (tx_counter0)
{
--tx_counter0;
(*(unsigned char *) 0xc6)=tx_buffer0[tx_rd_index0];
if (++tx_rd_index0 == 256) tx_rd_index0=0;
};
}

#pragma used+
void putchar(char c)
{
while (tx_counter0 == 256);
#asm("cli")
if (tx_counter0 || (((*(unsigned char *) 0xc0) & (1<<5))==0))
{
tx_buffer0[tx_wr_index0]=c;
if (++tx_wr_index0 == 256) tx_wr_index0=0;
++tx_counter0;
}
else
(*(unsigned char *) 0xc6)=c;
#asm("sei")
}
#pragma used-

typedef char *va_list;

#pragma used+

char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);

char *gets(char *str,unsigned int len);

void printf(char flash *fmtstr,...);
void sprintf(char *str, char flash *fmtstr,...);
void snprintf(char *str, unsigned int size, char flash *fmtstr,...);
void vprintf (char flash * fmtstr, va_list argptr);
void vsprintf (char *str, char flash * fmtstr, va_list argptr);
void vsnprintf (char *str, unsigned int size, char flash * fmtstr, va_list argptr);
signed char scanf(char flash *fmtstr,...);
signed char sscanf(char *str, char flash *fmtstr,...);

#pragma used-

#pragma library stdio.lib

bit b_exec;

interrupt [5] void pin_change_isr1(void)
{                
if (PINC&0x01)
{
TCCR0B=0x02;  
}
else if (TCCR0B)
{  
Timer_Count = ((255*Timer_Count) + TCNT0)>>1 ; 
b_echo_back = 1;
TCCR0B = 0; 
}    
}

interrupt [15] void timer0_compa_isr(void)
{
Timer_Count++;
TCNT0=0x00;
}

interrupt [12] void timer1_compa_isr(void)
{
#asm
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; prepare bank 0 spi data
	LDS  R30,_Edges_Ctr
	LDI  R31,0
	SUBI R30,LOW(-_PW_SPI_B0)
	SBCI R31,HIGH(-_PW_SPI_B0)
	LD   R30,Z
	OUT  0x2E,R30
	nop ;1
	nop ;2
	nop ;3
	nop ;4
	nop ;5
	nop ;6
	nop ;7
	nop ;8
	;nop ;1
; prepare bank 1 spi data
	LDS  R30,_Edges_Ctr ;2
	LDI  R31,0 ;1
	SUBI R30,LOW(-_PW_SPI_B1);1
	SBCI R31,HIGH(-_PW_SPI_B1);1
	LD   R30,Z;2
; pulse bank 0
	SBI  0x5,1
	CBI  0x5,1
; load spi data bank 1
	OUT  0x2E,R30
	nop ;1
	nop ;2
	nop ;3
	nop ;4
	nop ;5
	nop ;6
	nop ;7
	nop ;8
	;nop ;1
; prepare bank 2 spi data
	LDS  R30,_Edges_Ctr
	LDI  R31,0
	SUBI R30,LOW(-_PW_SPI_B2)
	SBCI R31,HIGH(-_PW_SPI_B2)
	LD   R30,Z
;pulse bank 1
	SBI  0x5,2
	CBI  0x5,2
; load spi data bank 2
	OUT  0x2E,R30
	nop ;1
	nop ;2
	nop ;3
	nop ;4
	nop ;5
	nop ;6
	nop ;7
	nop ;8
	;nop ;1
; prepare bank 3 spi data
	LDS  R30,_Edges_Ctr
	LDI  R31,0
	SUBI R30,LOW(-_PW_SPI_B3)
	SBCI R31,HIGH(-_PW_SPI_B3)
	LD   R30,Z
; pulse bank 2
	SBI  0xB,6
	CBI  0xB,6
; load spi data bank 3
	OUT  0x2E,R30
	nop ;1
	nop ;2
	nop ;3
	nop ;4
	nop ;5
	nop ;6
	nop ;7
	nop ;8
	nop ;1
	nop ;2
	nop ;3
	nop ;4
	nop ;5
	nop ;6
	nop ;7
;	nop ;8
;0000 00E8 PORTD.7 = 1;PORTD.7 = 0;// pulse bank 3
	SBI  0xB,7
	CBI  0xB,7
;0000 00E9 /* A15 */
;0000 00EA 
;0000 00EB b_exec = 0;
	CBI  0x1E,1
;0000 00EC // reset counter
;0000 00ED TCNT1H=0x00;
	LDI  R30,LOW(0)
	STS  133,R30
;0000 00EE TCNT1L=0x00;
	STS  132,R30
;0000 00EF 
;0000 00F0 /*Take less than 1 timer clocks*/
;0000 00F1 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
#endasm
}

interrupt [13] void timer1_compb_isr(void)
{
#asm
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
; prepare bank 0 spi data
	LDS  R30,_Edges_Ptr
	LDI  R31,0
	SUBI R30,LOW(-_PW_SPI_B0)
	SBCI R31,HIGH(-_PW_SPI_B0)
	LD   R30,Z
	OUT  0x2E,R30
	nop ;1
	nop ;2
	nop ;3
	nop ;4
	nop ;5
	nop ;6
	nop ;7
	nop ;8
	;nop ;1
; prepare bank 1 spi data
	LDS  R30,_Edges_Ptr ;2
	LDI  R31,0 ;1
	SUBI R30,LOW(-_PW_SPI_B1);1
	SBCI R31,HIGH(-_PW_SPI_B1);1
	LD   R30,Z;2
; pulse bank 0
	SBI  0x5,1
	CBI  0x5,1
; load spi data bank 1
	OUT  0x2E,R30
	nop ;1
	nop ;2
	nop ;3
	nop ;4
	nop ;5
	nop ;6
	nop ;7
	nop ;8
	;nop ;1
; prepare bank 2 spi data
	LDS  R30,_Edges_Ptr
	LDI  R31,0
	SUBI R30,LOW(-_PW_SPI_B2)
	SBCI R31,HIGH(-_PW_SPI_B2)
	LD   R30,Z
;pulse bank 1
	SBI  0x5,2
	CBI  0x5,2
; load spi data bank 2
	OUT  0x2E,R30
	nop ;1
	nop ;2
	nop ;3
	nop ;4
	nop ;5
	nop ;6
	nop ;7
	nop ;8
	;nop ;1
; prepare bank 3 spi data
	LDS  R30,_Edges_Ptr
	LDI  R31,0
	SUBI R30,LOW(-_PW_SPI_B3)
	SBCI R31,HIGH(-_PW_SPI_B3)
	LD   R30,Z
; pulse bank 2
	SBI  0xB,6
	CBI  0xB,6
; load spi data bank 3
	OUT  0x2E,R30
	nop ;1
	nop ;2
	nop ;3
	nop ;4
	nop ;5
	;nop ;6
	;nop ;7
	;nop ;8
	;nop ;1
	;nop ;2
	;nop ;3
;0000 0140 /* AEA */
;0000 0141 // update pointer
;0000 0142 Edges_Ptr ++;
	LDS  R30,_Edges_Ptr
	SUBI R30,-LOW(1)
	STS  _Edges_Ptr,R30      
;0000 0143 if (Edges_Ptr == Edges_Ctr)
	LDS  R30,_Edges_Ctr
	LDS  R26,_Edges_Ptr        
	CP   R30,R26
;0000 013F PORTD.7 = 1;PORTD.7 = 0;// pulse bank 3
	SBI  0xB,7
	CBI  0xB,7

	BRNE _NORESET
;0000 0144 {
;0000 0145     b_exec = 1;
	SBI  0x1E,1
;0000 0146     Edges_Ptr = 0;
	LDI  R30,LOW(0)
	STS  _Edges_Ptr,R30
;0000 0147 }
;0000 0148 // set next edge
;0000 0149 OCR1BH = PW_Time[Edges_Ptr]>>8;
_NORESET:
	LDS  R30,_Edges_Ptr
	LDI  R26,LOW(_PW_Time)
	LDI  R27,HIGH(_PW_Time)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R16,X+
	LD   R17,X
; 0000 014B OCR1BH = test>>8;
	MOVW R30,R16
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	STS  139,R30
; 0000 014C OCR1BL = test;
	STS  138,R16
;0000 014B 
;0000 014C }
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
#endasm
}

interrupt [18] void spi_isr(void)
{
unsigned char data;
data=SPDR;

}

bit b_move;
bit b_step;
bit b_recieve_cmd;

unsigned char cmd;

unsigned char CMD_Pattern[3];

unsigned char CMD_Count;

unsigned char CMD_Channel[32];

unsigned int  CMD_Time[32];

unsigned char SP_Steps[32];

unsigned char SP_Dir[32];

unsigned char SP_Interval[32];

unsigned char Interval;

unsigned char i,j;
unsigned char channel,tmp;
unsigned int adc = 0;
unsigned int distance = 0;

void main(void)
{

CMD_Count = 0;
b_move = 0;
b_step = 0;
b_exec = 0;

b_recieve_cmd = 1;

Interval = 1;

SSC32_Init();
PW_Init();

SetBaud((PIND&0x18)>>3);

while (1)
{   

if (b_recieve_cmd)
{

cmd = getchar();

switch (cmd)
{
case 'I': 
cmd = getchar();
if ((cmd>0)&&(cmd<31))
{
Interval = cmd;
}
break; 
case 'D': 
distance = read_distance();
putchar(distance>>8);
putchar(distance&0xFF);
break;
case 'V': 

cmd = getchar();
switch (cmd)
{
case 'A':
adc = read_adc(0);
break;
case 'B':            
adc = read_adc(1);
break;
case 'C':     
adc = read_adc(2);  
break;
case 'D':      
adc = read_adc(3); 
break;
}
putchar(adc>>8);
putchar(adc&0xFF);
break;
case 'S':

cmd = getchar();
if (cmd == 0x01)
{
PW_Start(); 
}
else
{
PW_Stop();
}
break;
case '#':

PORTD ^= 0x04;
CMD_Pattern[0] = getchar();
CMD_Pattern[1] = getchar();
CMD_Pattern[2] = getchar();

CMD_Channel[CMD_Count]= Servo[CMD_Pattern[0]];
CMD_Time[CMD_Count]= CMD_Pattern[2]+(CMD_Pattern[1]<<8);

CMD_Count++;
break;
case 'T':

cmd = getchar();

b_recieve_cmd = 0;

if (!cmd)
{         

b_move = 1;
}
else 
{        

b_step = 1;
}
default:
break;
}
}

if (b_move)
{
for (i =0;i< CMD_Count; i++)
{
PW_Set(CMD_Channel[i],CMD_Time[i], i);
}

while(!b_exec);
PW_Update_SPI();

CMD_Count = 0;

b_recieve_cmd = 1;

b_move = 0;

b_exec = 0;    
}

if (b_step)
{

for (i=0;i<CMD_Count;i++)
{
channel = CMD_Channel[i];

if (SV_Width[channel] > CMD_Time[i])
{
SP_Steps[i] = (SV_Width[channel] - CMD_Time[i])/20;
SP_Dir[i] = 0;
}
else 
{   
SP_Steps[i] = (CMD_Time[i] - SV_Width[channel])/20;
SP_Dir[i] = 1;
}
}
tmp = Max(SP_Steps,CMD_Count);
for (i=0;i<CMD_Count;i++)
{
SP_Interval[i] = tmp/SP_Steps[i];
}

for (i=0;i<tmp;i++)
{
for (j=0;j<CMD_Count;j++)
{
if (( (i%SP_Interval[j]) == 0) && (SP_Steps[j]>0))
{
SP_Steps[j]--;
channel = CMD_Channel[j];
SV_Width[channel] +=  ((SP_Dir[j])?20:-20) ;
PW_Set(channel,SV_Width[channel],j);
}
}

while(!b_exec);
PW_Update_SPI();
b_exec = 0;

delay_ms(Interval);
}

CMD_Count = 0;

b_recieve_cmd = 1;

b_step = 0;
}
};
}

