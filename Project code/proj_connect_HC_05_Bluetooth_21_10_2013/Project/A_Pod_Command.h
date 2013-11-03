#include "stm32f4xx.h"
#include "stm32f4xx_usart.h"
#include "A_Pod_define.h"
#include "Usart.h"
#include "Usart_Bluetooth.h"
#include "checkCommand.h"
#include <stdio.h>
#include <string.h>

//Command
void cmd_start(void);
void cmd_stop(void);
void initStart(void);
void initStop(void);
void tripodA_Horizontal_Front(char *command,uint16_t Pulse, uint16_t weightNumber);
void tripodA_Horizontal_Center(char *command,uint16_t Pulse, uint16_t weightNumber);
void tripodA_Horizontal_Rear(char *command,uint16_t Pulse, uint16_t weightNumber);
void tripodB_Horizontal_Front(char *command,uint16_t Pulse, uint16_t weightNumber);
void tripodB_Horizontal_Center(char *command,uint16_t Pulse, uint16_t weightNumber);
void tripodB_Horizontal_Rear(char *command,uint16_t Pulse, uint16_t weightNumber);
void tripodA_vertical_Low(char *command,uint16_t Pulse, uint16_t weightNumber);
void tripodA_vertical_Mid(char *command,uint16_t Pulse, uint16_t weightNumber);
void tripodA_vertical_High(char *command,uint16_t Pulse, uint16_t weightNumber);
void tripodB_vertical_Low(char *command,uint16_t Pulse, uint16_t weightNumber);
void tripodB_vertical_Mid(char *command,uint16_t Pulse, uint16_t weightNumber);
void tripodB_vertical_High(char *command,uint16_t Pulse, uint16_t weightNumber);
void forward();


