#include <mega328p.h>
#include "SSC32.h"
#include "Speed.h"

//*********************************************************************
// Global variables.                                                 **
//*********************************************************************
// counting step of each command 
unsigned char SP_Steps[32];
// moving direction of each command
unsigned char SP_Dir[32];

