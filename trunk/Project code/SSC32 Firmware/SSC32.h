//*********************************************************************
// Defines
//*********************************************************************

/* Port B*/
#define PB0 PORTB.0
#define PB1 PORTB.1
#define PB2 PORTB.2
#define PB3 PORTB.3
#define PB4 PORTB.4
#define PB5 PORTB.5
#define PB6 PORTB.6
#define PB7 PORTB.7
// Function
#define BANK0_RCK PORTB.1
#define BANK1_RCK PORTB.2
#define MOSI PORTB.3
#define SCK PORTB.5

/* Port C*/
#define PC0 PORTC.0
#define PC1 PORTC.1
#define PC2 PORTC.2
#define PC3 PORTC.3
#define PC4 PORTC.4
#define PC5 PORTC.5
#define PC6 PORTC.6
#define PC7 PORTC.7
// Function
#define SP_A PORTC.0
#define SP_B PORTC.1
#define SP_C PORTC.2
#define SP_D PORTC.3
#define SDA PORTC.4
#define SCL PORTC.5

/* Port D*/
#define PD0 PORTD.0
#define PD1 PORTD.1
#define PD2 PORTD.2
#define PD3 PORTD.3
#define PD4 PORTD.4
#define PD5 PORTD.5
#define PD6 PORTD.6
#define PD7 PORTD.7
// Function
#define RXD PORTD.0
#define TXD PORTD.1
#define LED PORTD.2
#define BAUD1 PORTD.3
#define BAUD2 PORTD.4
#define BANK2_RCK PORTD.6
#define BANK3_RCK PORTD.7


#define ADC_VREF_TYPE 0x00
//*********************************************************************
// Typedef
//*********************************************************************

/* unused */

//*********************************************************************
// Global variables.
//*********************************************************************

/* unused */

//*********************************************************************
// Prototypes
//*********************************************************************
void SSC32_Init();
void SetBaud(char PD);
// debug operation
void DebugLong(unsigned long var);
void DebugInt(unsigned int var);
void DebugChar(unsigned char var);

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input);