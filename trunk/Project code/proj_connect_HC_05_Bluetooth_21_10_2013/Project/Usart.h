#include "stm32f4xx.h"
#include "stdio.h"


/* Private typedef -----------------------------------------------------------*/
//GPIO_InitTypeDef  GPIO_InitStructure;

/* Private function prototypes -----------------------------------------------*/
void UART2_CONFIG(uint32_t baudrate);
void usart_send_string(char* string);
void usart_send_char(char string);
void uart_send_buff( uint8_t *buff, int len );
void USART2_IRQHandler(void);