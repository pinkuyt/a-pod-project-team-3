
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

unsigned const char Servo[32] = {1,2,3,4,5,7,6,0, 
8,9,10,11,12,13,14,15,
23,22,21,20,19,18,17,16,
24,31,30,29,28,27,26,25};

unsigned char PW_SPI_B0[33];
unsigned char PW_SPI_B1[33];
unsigned char PW_SPI_B2[33];
unsigned char PW_SPI_B3[33];

unsigned char Edges_Ctr;

unsigned char Edges_Ptr;

unsigned long int PW_Mask[32];

unsigned int PW_Time[32];

unsigned int PW_Width[32];

unsigned int SV_Width[32];
unsigned char delay = 22;
unsigned char ctr;

void PW_Init()
{ 
int i;

PW_Time[0] = 2764-delay;
PW_Mask[0]  = 0xFFFFFFFF;
PW_Width[0] = 1500;

for (i=0;i<32;i++) 
{
SV_Width[i] = 1500;
}   

Edges_Ptr = 0;
Edges_Ctr = 1;

PW_SPI_B0[0] = 0; PW_SPI_B2[0] = 0;
PW_SPI_B1[0] = 0; PW_SPI_B3[0] = 0;

PW_SPI_B0[1] = 0xFF; PW_SPI_B2[1] = 0xFF;
PW_SPI_B1[1] = 0xFF; PW_SPI_B3[1] = 0xFF;

}

void PW_Start()
{
(*(unsigned char *) 0x8b) = PW_Time[0]>>8;
(*(unsigned char *) 0x8a) = PW_Time[0]&0xFF;
(*(unsigned char *) 0x81)=0x02;
}

void PW_Stop()
{

(*(unsigned char *) 0x81)=0x00;

SPDR= 0; 
while(!(SPSR>>7));
PORTB.1 = 1;PORTB.1 = 0;
PORTB.2 = 1;PORTB.2 = 0;
PORTD.6 = 1;PORTD.6 = 0;
PORTD.7 = 1;PORTD.7 = 0;
}

void PW_Update_SPI()
{
char i;

(*(unsigned char *) 0x81)=0x00;

Edges_Ctr = ctr;
PW_SPI_B0[Edges_Ctr] = 0xFF; PW_SPI_B2[Edges_Ctr] = 0xFF;
PW_SPI_B1[Edges_Ctr] = 0xFF; PW_SPI_B3[Edges_Ctr] = 0xFF;

PW_SPI_B0[0] =  PW_SPI_B0[Edges_Ctr]^PW_Mask[0]>>0;
PW_SPI_B1[0] =  PW_SPI_B1[Edges_Ctr]^PW_Mask[0]>>8;
PW_SPI_B2[0] =  PW_SPI_B2[Edges_Ctr]^PW_Mask[0]>>16;  
PW_SPI_B3[0] =  PW_SPI_B3[Edges_Ctr]^PW_Mask[0]>>24;
PW_Time[0] =  1.8432f * (float)PW_Width[0] - delay;

for (i=1;i<(Edges_Ctr);i++)
{
PW_SPI_B0[i] =  PW_SPI_B0[i-1]^PW_Mask[i]>>0;
PW_SPI_B1[i] =  PW_SPI_B1[i-1]^PW_Mask[i]>>8;
PW_SPI_B2[i] =  PW_SPI_B2[i-1]^PW_Mask[i]>>16;  
PW_SPI_B3[i] =  PW_SPI_B3[i-1]^PW_Mask[i]>>24;
PW_Time[i] =  1.8432f * (float)PW_Width[i] - delay;    
}

(*(unsigned char *) 0x8b) = PW_Time[0]>>8;
(*(unsigned char *) 0x8a) = PW_Time[0]&0xFF;
(*(unsigned char *) 0x81)=0x02;
}

void PW_Set(char channel, int width, char extend)
{
char i,j ;
char pos ;
ctr = Edges_Ctr + extend;
SV_Width[channel] = width;

i = 0;
while (i < ctr)
{

PW_Mask[i] &= 0xFFFFFFFF^(1<<(long)channel);

if (PW_Mask[i] == 0)
{   

for(j=i;j<ctr;j++)
{
PW_Mask[j] = PW_Mask[j+1];
PW_Width[j] = PW_Width[j+1];
}

ctr--;
}
else
{
i++;
}
}

pos = 0;
while (pos < ctr)
{

if (width == PW_Width[pos])
{
PW_Mask[pos] |= 1<<(long)channel;
return;
}

if (width < PW_Width[pos])
{

for (i= ctr;i>pos;i--)
{
PW_Width[i] = PW_Width[i-1];
PW_Mask[i] = PW_Mask[i-1];
}

PW_Width[pos] = width;
PW_Mask[pos] = 1<<(long)channel; 

ctr++;
return;
}

pos++;
}

PW_Width[ctr] = width;
PW_Mask[ctr] = 1<<(long)channel;

ctr++; 
}

void PW_Set_Serial(char* channel, int* width,char length)
{
char i,j,k;
char pos;

long cleanMark=0;

ctr = Edges_Ctr;

for (i=0;i<length;i++)
{
SV_Width[channel[i]] = width[i];
cleanMark |= (1<<(long)(channel[i]));  
}

i = 0;
while (i < ctr)
{

PW_Mask[i] &= 0xFFFFFFFF^cleanMark;

if (PW_Mask[i] == 0)
{   

for(j=i;j<ctr;j++)
{
PW_Mask[j] = PW_Mask[j+1];
PW_Width[j] = PW_Width[j+1];
}

ctr--;
}
else
{
i++;
}
}
for (k=0; k< length;k++)
{

ctr += k;

pos = 0;
while (pos < ctr)
{

if (width[k] == PW_Width[pos])
{
PW_Mask[pos] |= 1<<(long)channel[k];
return;
}

if (width[k] < PW_Width[pos])
{

for (i= ctr;i>pos;i--)
{
PW_Width[i] = PW_Width[i-1];
PW_Mask[i] = PW_Mask[i-1];
}

PW_Width[pos] = width[k];
PW_Mask[pos] = 1<<(long)channel[k]; 

ctr++;
return;
}

pos++;
}

PW_Width[ctr] = width[k];
PW_Mask[ctr] = 1<<(long)channel[k];

ctr++;  
} 
}

