#include "stm32f4xx.h"
#include "stdio.h"

extern unsigned char USART2_RX_Buffer[256];
extern unsigned char USART2_RX_Size;
/* Private typedef -----------------------------------------------------------*/
//GPIO_InitTypeDef  GPIO_InitStructure;

/* Private function prototypes -----------------------------------------------*/
void UART2_CONFIG(uint32_t baudrate);
void USART2_IRQHandler(void);
unsigned char USART2_GetData(void);
void USART2_Clear_Buffer(void);
