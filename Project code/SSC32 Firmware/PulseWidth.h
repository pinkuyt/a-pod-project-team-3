//*********************************************************************
// Defines
//*********************************************************************

/* unused */

//*********************************************************************
// Typedef
//*********************************************************************

/* unused */

//*********************************************************************
// Global variables.
//*********************************************************************
// mapping servo number with output channel
extern unsigned const char Servo[32];
// Array contain SPI output for each bank at each edge: 1 edge = 4 bank;
extern unsigned char PW_SPI_B0[33];
extern unsigned char PW_SPI_B1[33];
extern unsigned char PW_SPI_B2[33];
extern unsigned char PW_SPI_B3[33];
// number of pulse edges
extern unsigned char Edges_Ctr;
// pointer to current edge
extern unsigned char Edges_Ptr;

//  32 bits indicate which servo to pulse in each edge: 1- active 0- inactive
extern unsigned long int PW_Mask[32];
// array contain pulse width value in ascending order (timer clock)
extern unsigned int PW_Time[32];
// array contain pulse width value in ascending order (us)
extern unsigned int PW_Width[32];

// array contain pulse width value in ascending order (us) : channel index
extern unsigned int SV_Width[32];

//*********************************************************************
// Prototypes
//*********************************************************************
// Initiate array 
void PW_Init();
// Start sending signal: servo on
void PW_Start();
// Stop sending signal : servo off
void PW_Stop();
//  Set new edge value
void PW_Set(char channel, int width, char extend);          
//  Update SPI output
void PW_Update_SPI();
