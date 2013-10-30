#include "checkCommand.h"

uint16_t lowPulse(uint16_t Pulse)
{
	uint16_t P,tempP;
	uint16_t lowPulse;
	P = 0;
	tempP = 0;
	
	P = Pulse/0x100; 
	tempP = P*0x100;
	lowPulse = Pulse - tempP;
	
	return lowPulse;
}

uint16_t highPulse(uint16_t Pulse)
{	
	return Pulse/0x100;
}

void mergeCmd(char *desCommand,const char *srcCommand)
{
	int i;
	i = strlen(desCommand);
	if (desCommand != NULL)
	{
	memcpy(desCommand + i , srcCommand, 2);
	}
}