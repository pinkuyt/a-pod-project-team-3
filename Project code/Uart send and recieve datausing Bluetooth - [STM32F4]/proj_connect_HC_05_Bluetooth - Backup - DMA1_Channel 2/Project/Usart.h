#include "stm32f4xx.h"
#include "stdio.h"


/* Private typedef -----------------------------------------------------------*/
//GPIO_InitTypeDef  GPIO_InitStructure;

/* Private function prototypes -----------------------------------------------*/
void UART2_CONFIG(uint32_t baudrate);
void usart_send_string(char* string);
void usart_send_char(char string);
void USART2_IRQHandler(void);