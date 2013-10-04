
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

void SSC32_Init();
void SetBaud(char PD);

void DebugLong(long var);
void DebugInt(int var);
void DebugChar(char var);

unsigned int read_adc(unsigned char adc_input);

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

void PW_Set_Serial(char* channel, int* width,char length);

void PW_Update_SPI();

extern unsigned char Delay_Count;

char Max(char* arr,char length);
void Delay_10ms(char time);

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

interrupt [15] void timer0_compa_isr(void)
{
Delay_Count++;
TCNT0=0x00;
}

interrupt [12] void timer1_compa_isr(void)
{

SPDR= PW_SPI_B0[Edges_Ctr]; 
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
PORTB.1 = 1;PORTB.1 = 0;
SPDR= PW_SPI_B1[Edges_Ctr];  
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
PORTB.2 = 1;PORTB.2 = 0;
SPDR= PW_SPI_B2[Edges_Ctr];  
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
PORTD.6 = 1;PORTD.6 = 0;
SPDR= PW_SPI_B3[Edges_Ctr];  
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
PORTD.7 = 1;PORTD.7 = 0;

b_exec = 0;

(*(unsigned char *) 0x85)=0x00;
(*(unsigned char *) 0x84)=0x00;

}

interrupt [13] void timer1_compb_isr(void)
{

SPDR= PW_SPI_B0[Edges_Ptr]; 
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
PORTB.1 = 1;PORTB.1 = 0;
SPDR= PW_SPI_B1[Edges_Ptr];  
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
PORTB.2 = 1;PORTB.2 = 0;
SPDR= PW_SPI_B2[Edges_Ptr];  
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
PORTD.6 = 1;PORTD.6 = 0;
SPDR= PW_SPI_B3[Edges_Ptr];  
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
PORTD.7 = 1;PORTD.7 = 0;

Edges_Ptr ++;
if (Edges_Ptr == Edges_Ctr)
{
b_exec = 1;
Edges_Ptr = 0;
}

(*(unsigned char *) 0x8b) = PW_Time[Edges_Ptr]>>8;
(*(unsigned char *) 0x8a) = PW_Time[Edges_Ptr]&0xFF;

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

unsigned char i,j;
unsigned char channel,tmp;
unsigned int adc[1] = {0};
void main(void)
{

CMD_Count = 0;
b_move = 0;
b_step = 0;
b_exec = 0;

b_recieve_cmd = 1;

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
case 'V':
cmd = getchar();
switch (cmd)
{
case 'A':
adc[0] = read_adc(0);
break;
case 'B':            
adc[0] = read_adc(1);
break;
case 'C':     
adc[0] = read_adc(2);  
break;
case 'D':      
adc[0] = read_adc(3); 
break;
}
putchar(adc[0]>>8);
putchar(adc[0]&0xFF);
break;
case 'S':

cmd = getchar();
if (cmd)
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
SP_Steps[i] = (SV_Width[channel] - CMD_Time[i])/25;
SP_Dir[i] = 0;
}
else 
{   
SP_Steps[i] = (CMD_Time[i] - SV_Width[channel])/25;
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
SV_Width[channel] +=  ((SP_Dir[j])?25:-25) ;
PW_Set(channel,SV_Width[channel],j);
}
}

while(!b_exec);
PW_Update_SPI();
b_exec = 0;

Delay_10ms(3);
}

CMD_Count = 0;

b_recieve_cmd = 1;

b_step = 0;
}
};
}

