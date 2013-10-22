/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 9/6/2013
Author  : 
Company : 
Comments: 


Chip type           : ATmega328P
Program type        : Application
Clock frequency     : 14.745600 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 512
*****************************************************/

#include <mega328p.h>
#include <delay.h>
#include "SSC32.h"
#include "PulseWidth.h"
#include "Utilities.h"

//*********************************************************************
// USART interrupt service routine
//*********************************************************************

#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE0 256
char rx_buffer0[RX_BUFFER_SIZE0];

#if RX_BUFFER_SIZE0<256
unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
#else
unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow0;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSR0A;
data=UDR0;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer0[rx_wr_index0]=data;
   if (++rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
   if (++rx_counter0 == RX_BUFFER_SIZE0)
      {
      rx_counter0=0;
      rx_buffer_overflow0=1;
      };
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter0==0);
data=rx_buffer0[rx_rd_index0];
if (++rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
#asm("cli")
--rx_counter0;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE0 256
char tx_buffer0[TX_BUFFER_SIZE0];

#if TX_BUFFER_SIZE0<256
unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;
#else
unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter0)
   {
   --tx_counter0;
   UDR0=tx_buffer0[tx_rd_index0];
   if (++tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter0 == TX_BUFFER_SIZE0);
#asm("cli")
if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer0[tx_wr_index0]=c;
   if (++tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
   ++tx_counter0;
   }
else
   UDR0=c;
#asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>
bit b_exec;
//*********************************************************************
// Timer 0 interrupt service routine
//*********************************************************************

// Timer 0 output compare A interrupt service routine
interrupt [TIM0_COMPA] void timer0_compa_isr(void)
{
    Delay_Count++;
    TCNT0=0x00;
}
//*********************************************************************
// Timer 1 interrupt service routine
//*********************************************************************

// Timer 1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
#asm
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;0000 009F /* A03 */
;0000 00A0 // Output edge data
;0000 00A1 SPDR= PW_SPI_B0[Edges_Ctr]; //while(!(SPSR>>7));
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
	nop ;1
	nop ;2
	nop ;3
	nop ;4
	nop ;5
	nop ;6
	nop ;7
	nop ;8
;0000 00B2 PORTB.1 = 1;PORTB.1 = 0;// pulse bank 0
	SBI  0x5,1
	CBI  0x5,1
;0000 00B3 SPDR= PW_SPI_B1[Edges_Ctr];  //while(!(SPSR>>7));
	LDS  R30,_Edges_Ctr
	LDI  R31,0
	SUBI R30,LOW(-_PW_SPI_B1)
	SBCI R31,HIGH(-_PW_SPI_B1)
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
	nop ;1
	nop ;2
	nop ;3
	nop ;4
	nop ;5
	nop ;6
	nop ;7
	nop ;8
;0000 00C4 PORTB.2 = 1;PORTB.2 = 0;// pulse bank 1
	SBI  0x5,2
	CBI  0x5,2
;0000 00C5 SPDR= PW_SPI_B2[Edges_Ctr];  //while(!(SPSR>>7));
	LDS  R30,_Edges_Ctr
	LDI  R31,0
	SUBI R30,LOW(-_PW_SPI_B2)
	SBCI R31,HIGH(-_PW_SPI_B2)
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
	nop ;1
	nop ;2
	nop ;3
	nop ;4
	nop ;5
	nop ;6
	nop ;7
	nop ;8
;0000 00D6 PORTD.6 = 1;PORTD.6 = 0;// pulse bank 2
	SBI  0xB,6
	CBI  0xB,6
;0000 00D7 SPDR= PW_SPI_B3[Edges_Ctr];  //while(!(SPSR>>7));
	LDS  R30,_Edges_Ctr
	LDI  R31,0
	SUBI R30,LOW(-_PW_SPI_B3)
	SBCI R31,HIGH(-_PW_SPI_B3)
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
	nop ;1
	nop ;2
	nop ;3
	nop ;4
	nop ;5
	nop ;6
	nop ;7
	nop ;8
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
// Timer 1 output compare B interrupt service routine
interrupt [TIM1_COMPB] void timer1_compb_isr(void)
{
#asm
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;0000 00F6 /* AD1 */
;0000 00F7 // Output edge data
;0000 00F8 SPDR= PW_SPI_B0[Edges_Ptr]; //while(!(SPSR>>7));
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
	nop ;1
	nop ;2
	nop ;3
	nop ;4
	nop ;5
	nop ;6
	nop ;7
	nop ;8
;0000 0109 PORTB.1 = 1;PORTB.1 = 0;// pulse bank 0
	SBI  0x5,1
	CBI  0x5,1
;0000 010A SPDR= PW_SPI_B1[Edges_Ptr];  //while(!(SPSR>>7));
	LDS  R30,_Edges_Ptr
	LDI  R31,0
	SUBI R30,LOW(-_PW_SPI_B1)
	SBCI R31,HIGH(-_PW_SPI_B1)
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
	nop ;1
	nop ;2
	nop ;3
	nop ;4
	nop ;5
	nop ;6
	nop ;7
	nop ;8
;0000 011B PORTB.2 = 1;PORTB.2 = 0;// pulse bank 1
	SBI  0x5,2
	CBI  0x5,2
;0000 011C SPDR= PW_SPI_B2[Edges_Ptr];  //while(!(SPSR>>7));
	LDS  R30,_Edges_Ptr
	LDI  R31,0
	SUBI R30,LOW(-_PW_SPI_B2)
	SBCI R31,HIGH(-_PW_SPI_B2)
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
	nop ;1
	nop ;2
	nop ;3
	nop ;4
	nop ;5
	nop ;6
	nop ;7
	nop ;8
;0000 012D PORTD.6 = 1;PORTD.6 = 0;// pulse bank 2
	SBI  0xB,6
	CBI  0xB,6
;0000 012E SPDR= PW_SPI_B3[Edges_Ptr];  //while(!(SPSR>>7));
	LDS  R30,_Edges_Ptr
	LDI  R31,0
	SUBI R30,LOW(-_PW_SPI_B3)
	SBCI R31,HIGH(-_PW_SPI_B3)
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
	nop ;1
	nop ;2
	nop ;3
	nop ;4
	nop ;5
	nop ;6
	nop ;7
	nop ;8
;0000 013F PORTD.7 = 1;PORTD.7 = 0;// pulse bank 3
	SBI  0xB,7
	CBI  0xB,7
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
	BRNE _RESET
;0000 0144 {
;0000 0145     b_exec = 1;
	SBI  0x1E,1
;0000 0146     Edges_Ptr = 0;
	LDI  R30,LOW(0)
	STS  _Edges_Ptr,R30
;0000 0147 }
;0000 0148 // set next edge
;0000 0149 OCR1BH = PW_Time[Edges_Ptr]>>8;
_RESET:
	LDS  R30,_Edges_Ptr
	LDI  R26,LOW(_PW_Time)
	LDI  R27,HIGH(_PW_Time)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	MOV  R30,R31
	LDI  R31,0
	STS  139,R30
;0000 014A OCR1BL = PW_Time[Edges_Ptr]&0xFF;
	LDS  R30,_Edges_Ptr
	LDI  R26,LOW(_PW_Time)
	LDI  R27,HIGH(_PW_Time)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	STS  138,R30
;0000 014B 
;0000 014C }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
#endasm
}
//*********************************************************************
// SPI interrupt service routine
//*********************************************************************

// SPI interrupt service routine
interrupt [SPI_STC] void spi_isr(void)
{
unsigned char data;
data=SPDR;
// Place your code here

}
//*********************************************************************
// Global variables.
//*********************************************************************

/* State bits*/
bit b_move;
bit b_step;
bit b_recieve_cmd;

/* Command processing */
// Command type
unsigned char cmd;
// Command arguments
unsigned char CMD_Pattern[3];
// Number of command to be handle
unsigned char CMD_Count;
// Channels to be affected
unsigned char CMD_Channel[32];
// New values of affected channel 
unsigned int  CMD_Time[32];

/* Moving speed congtrol */
// counting step of each command 
unsigned char SP_Steps[32];
// moving direction of each command: 1- increase 0- decrease (pulse width)
unsigned char SP_Dir[32];
// step adjustment (synchronize move)
unsigned char SP_Interval[32];

/* Multi purposes variables*/ 
unsigned char i,j;
unsigned char channel,tmp;
unsigned int adc = 0;

void main(void)
{
// Declare your local variables here

CMD_Count = 0;
b_move = 0;
b_step = 0;
b_exec = 0;
// cmd loop enable
b_recieve_cmd = 1;

SSC32_Init();
PW_Init();
//PW_Start();
SetBaud((PIND&0x18)>>3);

while (1)
    {   
        // command loop
        if (b_recieve_cmd)
        {
            // waiting for command
            cmd = getchar();
            // process command
            switch (cmd)
            {
                case 'D': 
                    /* Read digital input */
                    cmd = getchar();
                    switch (cmd)
                    {
                        case 'A':
                            break;
                        case 'B':            
                            break;
                        case 'C':     
                            break;
                        case 'D':      
                            break;
                    }
                    putchar(adc>>8);
                    putchar(adc&0xFF);
                    break;
                    break;
                case 'V': 
                    /* Read analog(V) input */
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
                    /* on(1)/off(0) command  */
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
                    /* moving command */
                    PORTD ^= 0x04;
                    CMD_Pattern[0] = getchar();
                    CMD_Pattern[1] = getchar();
                    CMD_Pattern[2] = getchar();
                        
                    CMD_Channel[CMD_Count]= Servo[CMD_Pattern[0]];
                    CMD_Time[CMD_Count]= CMD_Pattern[2]+(CMD_Pattern[1]<<8);
                        
                    CMD_Count++;
                    break;
                case 'T':
                    /* Timing option */
                    cmd = getchar();
                    // disable cmd loop
                    b_recieve_cmd = 0;
                    
                    if (!cmd)
                    {         
                        /* instance move */
                        b_move = 1;
                    }
                    else 
                    {        
                        /* timing move */
                        b_step = 1;
                    }
                default:
                    break;
            }
        }
        // start moving
        if (b_move)
        {
            for (i =0;i< CMD_Count; i++)
            {
                PW_Set(CMD_Channel[i],CMD_Time[i], i);
            }
            // update spi output (execute command)
            while(!b_exec);
            PW_Update_SPI();
            
            //reset command counter
            CMD_Count = 0;
            //reset state bit
            // - enable cmd loop
            b_recieve_cmd = 1;
            // - disable instance move
            b_move = 0;
            // - done execution 
            b_exec = 0;    
        }
        // stepping mode
        if (b_step)
        {
            // calculate steps needed
            for (i=0;i<CMD_Count;i++)
            {
                channel = CMD_Channel[i];
                // decrease
                if (SV_Width[channel] > CMD_Time[i])
                {
                    SP_Steps[i] = (SV_Width[channel] - CMD_Time[i])/20;
                    SP_Dir[i] = 0;
                }
                else //increase: (SV_Width[channel] < CMD_Time[i])
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
            // step execution
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
                
                // execute
                while(!b_exec);
                PW_Update_SPI();
                b_exec = 0;
                
                Delay_10ms(2);
            }
            // reset command counter
            CMD_Count = 0;
            // reset state bit 
            // - enable cmd loop
            b_recieve_cmd = 1;
            // - disable timing move
            b_step = 0;
        }
    };
}


