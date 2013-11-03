#include "stm32f4xx.h"
#include <stdio.h>
#include <string.h>

uint16_t highPulse(uint16_t Pulse);
uint16_t lowPulse(uint16_t Pulse);
int8_t checkSide(char *Servo);
void servoCmd(char *command, char *servo, char *highPulse, char *lowPulse);
void mergeCmd(char *desCommand,const char *srcCommand);
void servos(char *command, char *servo, uint16_t Pulse,uint16_t weightNumber);