/* Includes ------------------------------------------------------------------*/
#include "stm32f4xx.h"
#include "stm32f4xx_usart.h"
#include <string.h>
#include <stdio.h>



void TimingDelay_Decrement(void);
void Delay(__IO uint32_t nCount);
void init_USART1(uint32_t baudrate);
void initPA15();
void setPA15On();
void togglePA15();
void NVIC_Configuration(void);
void GPIO_Configuration(void);
void USART_Configuration(void);
void USART1_IRQHandler(void);
void usart_rxtx(void);
void sendUSART(USART_TypeDef* USARTx, volatile char *s,int size);