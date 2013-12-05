#include "Usart.h"
#include "APOD.h"

unsigned char USART2_RX_Buffer[256];
unsigned int USART2_RX_Counter = 0;
unsigned char USART2_RX_RD_Index = 0;
unsigned char USART2_RX_WR_Index = 0;

/* Config UART 2*/
void UART2_CONFIG(uint32_t baudrate)  //(TX:PA2) (RX:PA3)
{
	GPIO_InitTypeDef  GPIO_InitStructure;
	USART_InitTypeDef USART_InitStructure;
	NVIC_InitTypeDef  NVIC_InitStructure;
	
	/* enable peripheral clock for USART2 */
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_USART2, ENABLE);
	
  /* GPIOA clock enable */
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOA, ENABLE);

	
/* GPIOA Configuration:  USART2 TX on PA2 */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_2 | GPIO_Pin_3;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
	GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_NOPULL ;
	GPIO_Init(GPIOA, &GPIO_InitStructure);
	
	//Connect USART pins to AF
  GPIO_PinAFConfig(GPIOA, GPIO_PinSource2, GPIO_AF_USART2);
  GPIO_PinAFConfig(GPIOA, GPIO_PinSource3, GPIO_AF_USART2);
	
	
/* Connect USART2 pins to AF2 */
	// TX = PA2
	GPIO_PinAFConfig(GPIOA, GPIO_PinSource2, GPIO_AF_USART2);

	USART_InitStructure.USART_BaudRate = 9600;
	USART_InitStructure.USART_WordLength = USART_WordLength_8b;
	USART_InitStructure.USART_StopBits = USART_StopBits_1;
	USART_InitStructure.USART_Parity = USART_Parity_No;
	USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
	USART_InitStructure.USART_Mode = USART_Mode_Tx | USART_Mode_Rx;
	USART_Init(USART2, &USART_InitStructure);

	USART_Cmd(USART2, ENABLE); // enable USART2

	
	/* NVIC configuration */
  /* Configure the Priority Group to 2 bits */
	  NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2);
	
	/* Enable the USARTx Interrupt */
  NVIC_InitStructure.NVIC_IRQChannel = USART2_IRQn;///
  NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;
  NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;
  NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
  NVIC_Init(&NVIC_InitStructure);
	
	 /* Enable the Receive interrupt */
	 USART_ITConfig(USART2, USART_IT_RXNE, ENABLE);
	 
	 USART_Cmd(USART2, ENABLE);
}

/*?*/
void USART2_IRQHandler(void)
{
	unsigned char temp;
	if (USART_GetITStatus(USART2, USART_IT_RXNE) != RESET)
	{
		/* Read one byte from the receive data register */
		temp = USART_ReceiveData(USART2);
		// add to buffer
		USART2_RX_Buffer[USART2_RX_WR_Index] = temp;
		// update write index
		USART2_RX_WR_Index++;
		// update buffer counter
		USART2_RX_Counter++;
	}
}
unsigned char USART2_GetData(void)
{
	unsigned char data;
	while (USART2_RX_Counter==0);
	// get data from buffer queue
	data = USART2_RX_Buffer[USART2_RX_RD_Index];
	// update read index
	USART2_RX_RD_Index++;
	// update counter index
	USART2_RX_Counter--;
	return data;
}
void USART2_Clear_Buffer(void)
{
	USART2_RX_Counter = 0;
	USART2_RX_RD_Index = 0;
	USART2_RX_WR_Index = 0;
}
