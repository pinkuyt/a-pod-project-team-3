#include "stm32f4xx.h"
#include "stm32f4xx_usart.h"
#include "A_Pod_define.h"
#include "Usart.h"
#include "Usart_Bluetooth.h"
#include "checkCommand.h"
#include <stdio.h>
#include <string.h>

//char P1200[] = {0x04, 0xB0};
//char P1300[] = {0x05, 0x14};
//char P1500[] = {0x05, 0xDC};
//char P1700[] = {0x06, 0xA4};
//char P1800[] = {0x07, 0x08};	

//char T[] = {0x54,1};

//Command
void cmd_start(void);
void cmd_stop(void);
void initStart(void);
void test(void);
void test1(void);

