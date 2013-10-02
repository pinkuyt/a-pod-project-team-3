#include <mega328p.h>
#include "SSC32.h"

void SSC32_Init()
{
// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=In 
// State7=T State6=T State5=0 State4=0 State3=0 State2=0 State1=0 State0=T 
PORTB=0x00;
DDRB=0x3E;

// Port C initialization
// Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTC=0x00;
DDRC=0xFF;

// Port D initialization
// Func7=Out Func6=Out Func5=In Func4=In Func3=In Func2=Out Func1=In Func0=In 
// State7=0 State6=0 State5=T State4=T State3=T State2=0 State1=T State0=T 
PORTD=0x18;
DDRD=0xC4;

// Timer/Counter 0 initialization
// Clock source: 14400 
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
// current clock: stop(0x00)
TCCR0B=0x00;
TCNT0=0x00;
// 144 = 10ms (at clock: 14400 Hz)
OCR0A=0x90;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 1843.200 kHz
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: On

// timer 1 stop
TCCR1A=0x00;
TCCR1B=0x00;
TCCR1C=0x00;
//TCCR1A=0x00;
//TCCR1B=0x02;


ICR1H=0x00;
ICR1L=0x00;
// 20ms
OCR1AH=0x90;
OCR1AL=0x00;
// 1.5ms
OCR1BH=0x0A;
OCR1BL=0xCD;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
// OC2A output: Disconnected
// OC2B output: Disconnected
ASSR=0x00;
TCCR2A=0x00;
TCCR2B=0x00;
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-14: Off
// Interrupt on any change on pins PCINT16-23: Off
EICRA=0x00;
EIMSK=0x00;
PCICR=0x00;

// Timer/Counter 0 Interrupt(s) initialization (compare A)
TIMSK0=0x02;
// Timer/Counter 1 Interrupt(s) initialization (compare A + compare B)
TIMSK1=0x06;
// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART0 Mode: Asynchronous
// USART Baud Rate: 9600
UCSR0A=0x00;
UCSR0B=0xD8;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x5F;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
ADCSRB=0x00;

// SPI initialization
// SPI Type: Master
// SPI Clock Rate: 2*3686.400 kHz
// SPI Clock Phase: Cycle Half
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=0x50;
SPSR=0x01;

// Clear the SPI interrupt flag
#asm
    in   r30,spsr
    in   r30,spdr
#endasm

// Global enable interrupts
#asm("sei")

}

void SetBaud(char PD)
{
    switch (PD)
    {
        case 0:
            UBRR0H=0x00;
            UBRR0L=0x07;
            break;
        case 1:  
            UBRR0H=0x00;
            UBRR0L=0x17;
            break;
        case 2: 
            UBRR0H=0x00;
            UBRR0L=0x5F;
            break;
        case 3: 
            UBRR0H=0x01;
            UBRR0L=0x7F;
            break;
    }   
}

void DebugLong(long var)
{
    TCCR1B=0x00;
    SPDR = var&0xFF;while(!(SPSR>>7));
    BANK0_RCK = 1;BANK0_RCK = 0;
    SPDR = var>>8;while(!(SPSR>>7));
    BANK1_RCK = 1;BANK1_RCK = 0;
    SPDR = var>>16;while(!(SPSR>>7));
    BANK2_RCK = 1;BANK2_RCK = 0;
    SPDR = var>>24;while(!(SPSR>>7));
    BANK3_RCK = 1;BANK3_RCK = 0;
        
    while(1);
}
void DebugInt(int var)
{
    TCCR1B=0x00;
    SPDR = var&0xFF;while(!(SPSR>>7));
    BANK0_RCK = 1;BANK0_RCK = 0;
    SPDR = var>>8;while(!(SPSR>>7));
    BANK1_RCK = 1;BANK1_RCK = 0;
        
    while(1);
}
void DebugChar(char var)
{
    TCCR1B=0x00;
    SPDR = var&0xFF;while(!(SPSR>>7));
    BANK0_RCK = 1;BANK0_RCK = 0;
        
    while(1);
}
