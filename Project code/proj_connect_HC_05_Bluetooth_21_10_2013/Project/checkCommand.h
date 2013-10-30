#include "stm32f4xx.h"
#include <stdio.h>
#include <string.h>

uint16_t highPulse(uint16_t Pulse);
uint16_t lowPulse(uint16_t Pulse);
void mergeCmd(char *desCommand,const char *srcCommand);