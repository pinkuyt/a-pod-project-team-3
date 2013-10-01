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
int i =0;
/* A03 */
// Output edge data
SPDR= PW_SPI_B0[Edges_Ctr]; //while(!(SPSR>>7));
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
PORTB.1 = 1;PORTB.1 = 0;// pulse bank 0  
SPDR= PW_SPI_B1[Edges_Ctr];  //while(!(SPSR>>7));
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
PORTB.2 = 1;PORTB.2 = 0;// pulse bank 1   
SPDR= PW_SPI_B2[Edges_Ctr];  //while(!(SPSR>>7));
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
PORTD.6 = 1;PORTD.6 = 0;// pulse bank 2   
SPDR= PW_SPI_B3[Edges_Ctr];  //while(!(SPSR>>7));
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
PORTD.7 = 1;PORTD.7 = 0;// pulse bank 3
/* A15 */

b_exec = 0;
// reset counter
TCNT1H=0x00;
TCNT1L=0x00;

/*Take less than 1 timer clocks*/
}

// Timer 1 output compare B interrupt service routine
interrupt [TIM1_COMPB] void timer1_compb_isr(void)
{
int i =0;
/* AD1 */
// Output edge data
SPDR= PW_SPI_B0[Edges_Ptr]; //while(!(SPSR>>7));
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
PORTB.1 = 1;PORTB.1 = 0;// pulse bank 0  
SPDR= PW_SPI_B1[Edges_Ptr];  //while(!(SPSR>>7));
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
PORTB.2 = 1;PORTB.2 = 0;// pulse bank 1   
SPDR= PW_SPI_B2[Edges_Ptr];  //while(!(SPSR>>7));
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
PORTD.6 = 1;PORTD.6 = 0;// pulse bank 2   
SPDR= PW_SPI_B3[Edges_Ptr];  //while(!(SPSR>>7));
i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
PORTD.7 = 1;PORTD.7 = 0;// pulse bank 3
/* AEA */
// update pointer
Edges_Ptr ++;
if (Edges_Ptr == Edges_Ctr)
{
    b_exec = 1;
    Edges_Ptr = 0;
}
// set next edge
OCR1BH = PW_Time[Edges_Ptr]>>8;
OCR1BL = PW_Time[Edges_Ptr]&0xFF;
/*Take 105 timer clocks*/
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
bit b_move;
bit b_step;

unsigned char cmd;
unsigned char CMD_Pattern[3];
unsigned char CMD_Count;
unsigned char CMD_Channel[32];
unsigned int  CMD_Time[32];

// counting step of each command 
unsigned char SP_Steps[32];
// moving direction of each command
unsigned char SP_Dir[32];

unsigned char i,j;
unsigned char channel,tmp;

void main(void)
{
// Declare your local variables here
CMD_Count = 0;
b_move = 0;
b_step = 0;
b_exec = 0;

SSC32_Init();
PW_Init();
//PW_Start();

while (1)
    {   
        // waiting for command
        cmd = getchar();
        // process command
        switch (cmd)
        {
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
            case 0x21:
                /* execute command */
                b_move = 1;
                break;
            case 0x22:
                /* execute with timing command */
                b_step = 1;
                break;
            default:
                break;
        }
        // start moving
        if (b_move)
        {
            for (i =0;i< CMD_Count; i++)
            {
                PW_Set(CMD_Channel[i],CMD_Time[i], i);
            }
            //PW_Set_Serial(CMD_Channel,CMD_Time, CMD_Count);
            while(!b_exec);
            PW_Update_SPI();
            
            //reset command counter
            CMD_Count = 0;
            //reset state bit
            b_move = 0;
            b_exec = 0;    
        }
        // stepping mode
        if (b_step)
        {
            // calculate steps needed
            for (i=0;i<CMD_Count;i++)
            {
                channel = CMD_Channel[i];
                // backward
                if (SV_Width[channel] > CMD_Time[i])
                {
                    SP_Steps[i] = (SV_Width[channel] - CMD_Time[i])/50;
                    SP_Dir[i] = 0;
                }
                else //forward: (SV_Width[channel] < CMD_Time[i])
                {   
                    SP_Steps[i] = (CMD_Time[i] - SV_Width[channel])/50;
                    SP_Dir[i] = 1;
                }
            }
            tmp = Max(SP_Steps,CMD_Count);
            for (i=0;i<tmp;i++)
            {
                for (j=0;j<CMD_Count;j++)
                {
                    if (SP_Steps[j]>0)
                    {
                        SP_Steps[j]--;
                        channel = CMD_Channel[j];
                        SV_Width[channel] +=  SP_Dir[j]*100 -50;
                        PW_Set(channel,SV_Width[channel],j);
                    }
                }
                
                while(!b_exec);
                PW_Update_SPI();
                b_exec = 0;
                
                Delay_10ms(5);
            }
            // reset command counter
            CMD_Count = 0;
            // reset state bit
            b_step = 0;
        }
    };
}


