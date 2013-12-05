#include "Usart_Bluetooth.h"
#include "Usart.h"
#include "APOD.h"
#include "Global.h"

uint16_t i;

int checkstep = 0;
/**
  * @brief  This function handles USARTx global interrupt request
  * @param  None
  * @retval None
  */
void USART1_IRQHandler(void)
{	
	char stringc[256];
	//char string [256];
	
  if ((USART1->SR & USART_FLAG_RXNE) != (u16)RESET)
	{
		uint16_t data = USART_ReceiveData(USART1);
		memset(stringc,0,sizeof(stringc[0])*256); // Clear all to 0 so string properly represented
		sprintf(stringc,"%c",i);
		switch(data)
		{
			case 0xAA:
				b_Release = 1;
				break;
			default:
				RecievedCommand = data;
				b_Command = 1;
		}
	}
}


void sendUSART(USART_TypeDef* USARTx,volatile char *s,int size)
{
    int index=0;
    // Iterate over the buffer2 and print char by char
    for (index = 0; index<size; index ++) {
         
        // Wait until the TXE bit is set to 1
        while(!USART_GetFlagStatus(USARTx, USART_FLAG_TXE));
 
        USART_SendData(USARTx, (uint8_t) s[index]);  
 
        if (index>130)
            break;
    }
 
    //Loop until the end of transmission; this is very important
     while(USART_GetFlagStatus(USARTx, USART_FLAG_TC) == RESET);
}

void usart_rxtx(void)
{
    //const unsigned char welcome_str[] = " A-Pod Bluetooth!\r\n";
    /* NVIC Configuration */
    NVIC_Configuration();
		init_USART1(9600);
		UART2_CONFIG(9600);	
		
}

void init_USART1(uint32_t baudrate){

  GPIO_InitTypeDef GPIO_InitStruct; // this is for the GPIO pins used as TX and RX
  USART_InitTypeDef USART_InitStruct; // this is for the USART1 initilization
  //NVIC_InitTypeDef NVIC_InitStructure; // this is used to configure the NVIC (nested vector interrupt controller)
  
  /* enable APB2 peripheral clock for USART1
  * note that only USART1 and USART6 are connected to APB2
  * the other USARTs are connected to APB1
  */
  RCC_APB2PeriphClockCmd(RCC_APB2Periph_USART1, ENABLE);
  
  /* enable the peripheral clock for the pins used by
  * USART1, PB6 for TX and PB7 for RX
  */
  RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOB, ENABLE);
  
  /* This sequence sets up the TX and RX pins
  * so they work correctly with the USART1 peripheral
  */
  GPIO_InitStruct.GPIO_Pin = GPIO_Pin_6 | GPIO_Pin_7; // Pins 6 (TX) and 7 (RX) are used
  GPIO_InitStruct.GPIO_Mode = GPIO_Mode_AF; 			// the pins are configured as alternate function so the USART peripheral has access to them
  GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;		// this defines the IO speed and has nothing to do with the baudrate!
  GPIO_InitStruct.GPIO_OType = GPIO_OType_PP;			// this defines the output type as push pull mode (as opposed to open drain)
  GPIO_InitStruct.GPIO_PuPd = GPIO_PuPd_NOPULL;			// this activates the pullup resistors on the IO pins
  
  GPIO_Init(GPIOB, &GPIO_InitStruct);					// now all the values are passed to the GPIO_Init() function which sets the GPIO registers
  
  /* The RX and TX pins are now connected to their AF
  * so that the USART1 can take over control of the
  * pins
  */
  GPIO_PinAFConfig(GPIOB, GPIO_PinSource6, GPIO_AF_USART1); //
  GPIO_PinAFConfig(GPIOB, GPIO_PinSource7, GPIO_AF_USART1);
  
  /* Now the USART_InitStruct is used to define the
  * properties of USART1
  */
  USART_InitStruct.USART_BaudRate = baudrate;				// the baudrate is set to the value we passed into this init function
  USART_InitStruct.USART_WordLength = USART_WordLength_8b;// we want the data frame size to be 8 bits (standard)
  USART_InitStruct.USART_StopBits = USART_StopBits_1;		// we want 1 stop bit (standard)
  USART_InitStruct.USART_Parity = USART_Parity_No;		// we don't want a parity bit (standard)
  USART_InitStruct.USART_HardwareFlowControl = USART_HardwareFlowControl_None; // we don't want flow control (standard)
  USART_InitStruct.USART_Mode = USART_Mode_Tx | USART_Mode_Rx; // we want to enable the transmitter and the receiver
  USART_Init(USART1, &USART_InitStruct);					// again all the properties are passed to the USART_Init function which takes care of all the bit setting
  
  
  /* Here the USART1 receive interrupt is enabled
  * and the interrupt controller is configured
  * to jump to the USART1_IRQHandler() function
  * if the USART1 receive interrupt occurs
  */
  USART_ITConfig(USART1, USART_IT_RXNE, ENABLE); // enable the USART1 receive interrupt
  // the properties are passed to the NVIC_Init function which takes care of the low level stuff 
  // finally this enables the complete USART1 peripheral
  USART_Cmd(USART1, ENABLE);
}
/**
  * @brief  Configures the nested vectored interrupt controller.
  * @param  None
  * @retval None
  */
void NVIC_Configuration(void)
{
	/* Configure the Priority Group to 2 bits */
  NVIC_InitTypeDef NVIC_InitStructure;
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2);
  /* Enable the USARTx Interrupt */
  NVIC_InitStructure.NVIC_IRQChannel = USART1_IRQn;
  NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;
  NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;
  NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
  NVIC_Init(&NVIC_InitStructure);
}
/*---------------------------------
No fucking idea! :(
168000000
---------------------------------*/
void Delay(__IO uint32_t ms) 
	{
		uint32_t nCount = ms * 40000;
		while(nCount>0)
		{
			nCount--;
		}
	}

