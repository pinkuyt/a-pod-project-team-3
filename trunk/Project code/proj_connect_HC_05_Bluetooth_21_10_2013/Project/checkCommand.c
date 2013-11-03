#include "checkCommand.h"
#include "A_Pod_Command.h"

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
void servoCmd(char *command, char *servo, char *highPulse, char *lowPulse)
{
	mergeCmd(command,servo);
	mergeCmd(command,highPulse);
	mergeCmd(command,lowPulse);
}

int8_t checkSide(char *Servo)
{
	int8_t side;
	if (Servo[1] == 0x10 | Servo[1] == 0x18 | Servo[1] == 0x14 | Servo[1] == 0x11 | Servo[1] == 0x19 |
			Servo[1] == 0x12 | Servo[1] == 0x1A | Servo[1] == 0x15 | Servo[1] == 0x16 | Servo[1] == 0x1C)
	{
		side = 2;
	}
	else side = 1;
	return side;
}
void servos(char *command, char *servo, uint16_t Pulse,uint16_t weightNumber)
{
	int8_t side;
	uint16_t tempPulse;
	checkSide(servo);
	if (side == 1)
	{
		tempPulse = Pulse + weightNumber;
	}
	else 
	{
		tempPulse = Pulse - weightNumber;
	}
}
