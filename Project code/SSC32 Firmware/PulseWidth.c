#include <mega328p.h>
#include "SSC32.h"
#include "PulseWidth.h"
//*********************************************************************
// Global variables.                                                 **
//*********************************************************************
// mapping servo number with output channel
unsigned const char Servo[32] = {1,2,3,4,5,7,6,0, 
                                8,9,10,11,12,13,14,15,
                                23,22,21,20,19,18,17,16,
                                24,31,30,29,28,27,26,25};
// Array contain SPI output for each bank at each edge: 1 edge = 4 bank;
unsigned char PW_SPI_B0[33];
unsigned char PW_SPI_B1[33];
unsigned char PW_SPI_B2[33];
unsigned char PW_SPI_B3[33];

// number of pulse edges
unsigned char Edges_Ctr;
// pointer to current edge
unsigned char Edges_Ptr;

//  8 bits indicate which servo to pulse in each edge: 1- active 0- inactive
//  Channel | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | ... | 30 | 31 | 
unsigned long int PW_Mask[32];
// array contain pulse width value in ascending order (counter): edges index
unsigned int PW_Time[32];
// array contain pulse width value in ascending order (us) : edges index
unsigned int PW_Width[32];
// array contain pulse width value in ascending order (us) : servo index
unsigned int SV_Width[32];
unsigned char delay = 17;
unsigned char ctr;

//*********************************************************************
// Pulse width control routine                                       **
//*********************************************************************
//*********************************************************************
// Initiate array 
//*********************************************************************
void PW_Init()
{ 
    int i;
    // All channel: 1500 us= 2764 timer clock
    // 2764 timer clock                                
    PW_Time[0] = 2764-delay;
    PW_Mask[0]  = 0xFFFFFFFF;
    PW_Width[0] = 1500;
    // 1500 us
    for (i=0;i<32;i++) 
    {
        SV_Width[i] = 1500;
    }   
    // 1 edge
    Edges_Ptr = 0;
    Edges_Ctr = 1;
    
    // SPI at initial edge
    PW_SPI_B0[0] = 0; PW_SPI_B2[0] = 0;
    PW_SPI_B1[0] = 0; PW_SPI_B3[0] = 0;
    // SPI at 20ms tick
    PW_SPI_B0[1] = 0xFF; PW_SPI_B2[1] = 0xFF;
    PW_SPI_B1[1] = 0xFF; PW_SPI_B3[1] = 0xFF;
    
    
                          
}
//*********************************************************************
// Start sending signal: servo on
//*********************************************************************
void PW_Start()
{
    OCR1BH = PW_Time[0]>>8;
    OCR1BL = PW_Time[0]&0xFF;
    TCCR1B=0x02;
}
//*********************************************************************
// Stop sending signal : servo off
//*********************************************************************
void PW_Stop()
{
    // stop clock
    TCCR1B=0x00;
    // send out put 0 all bank
    SPDR= 0; 
    while(!(SPSR>>7));
    PORTB.1 = 1;PORTB.1 = 0;// pulse bank 0  
    PORTB.2 = 1;PORTB.2 = 0;// pulse bank 1   
    PORTD.6 = 1;PORTD.6 = 0;// pulse bank 2   
    PORTD.7 = 1;PORTD.7 = 0;// pulse bank 3
}
//*********************************************************************
//  Update SPI output
//*********************************************************************
void PW_Update_SPI()
{
    char i;
    // PW_Stop
    // stop clock
    TCCR1B=0x00;
    // send out put 0 all bank
//    SPDR= 0; 
//    while(!(SPSR>>7));
//    PORTB.1 = 1;PORTB.1 = 0;// pulse bank 0  
//    PORTB.2 = 1;PORTB.2 = 0;// pulse bank 1   
//    PORTD.6 = 1;PORTD.6 = 0;// pulse bank 2   
//    PORTD.7 = 1;PORTD.7 = 0;// pulse bank 3
    
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
    
    // PW_Start
    OCR1BH = PW_Time[0]>>8;
    OCR1BL = PW_Time[0]&0xFF;
    TCCR1B=0x02;
}
//*********************************************************************
//  Set new edge value
//*********************************************************************
void PW_Set(char channel, int width, char extend)
{
    char i,j ;
    char pos ;
    ctr = Edges_Ctr + extend;
    SV_Width[channel] = width;
    // clear old mask for this channel
    i = 0;
    while (i < ctr)
    {
        // clear old mask
        PW_Mask[i] &= 0xFFFFFFFF^(1<<(long)channel);
        // edge unused
        if (PW_Mask[i] == 0)
        {   
            // push array to the left
            for(j=i;j<ctr;j++)
            {
                PW_Mask[j] = PW_Mask[j+1];
                PW_Width[j] = PW_Width[j+1];
            }
            // update counter
            ctr--;
        }
        else
        {
            i++;
        }
    }
    // get position to insert
    pos = 0;
    while (pos < ctr)
    {
        // duplicated edge
        if (width == PW_Width[pos])
        {
            PW_Mask[pos] |= 1<<(long)channel;
            return;
        }
        // new edge less than max time 
        if (width < PW_Width[pos])
        {
            // push time array to the right
            for (i= ctr;i>pos;i--)
            {
                PW_Width[i] = PW_Width[i-1];
                PW_Mask[i] = PW_Mask[i-1];
            }
            // set value at new edge
            PW_Width[pos] = width;
            PW_Mask[pos] = 1<<(long)channel; 
            // update counter   
            ctr++;
            return;
        }
        
        pos++;
    }
    // new max time edge
    // set value at new edge
    PW_Width[ctr] = width;
    PW_Mask[ctr] = 1<<(long)channel;
    // update counter   
    ctr++; 
}
