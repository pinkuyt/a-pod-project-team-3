#include "main.h"

uint16_t i;

//ErrorStatus HSEStartUpStatus;

void NVIC_Configuration(void);
void GPIO_Configuration(void);
void USART_Configuration(void);
void USART1_IRQHandler(void);
void UARTSend(const unsigned char *pucBuffer, unsigned long ulCount);
void usart_rxtx(void);
char getcharUsart(void);
void GetString(char* buffer);
void IRDA_PutChar(char c);
void IRDA_PutString(char* s, unsigned long length);
void USART_puts(USART_TypeDef* USARTx,volatile char *s);



int main(void)
{
	usart_rxtx();
    while(1)
    {

    }
}
/**
  * @brief  This function handles USARTx global interrupt request
  * @param  None
  * @retval None
  */
void USART1_IRQHandler(void)
{	char string [256];
	int compare;
    if ((USART1->SR & USART_FLAG_RXNE) != (u16)RESET)
	{
		i = USART_ReceiveData(USART1);
		memset(string,0,sizeof(string[0])*256); // Clear all to 0 so string properly represented
		sprintf(string,"%c",i);
		compare = strncmp(string,"1234",100);	
		//GetInt(i);
//		if(compare == 0){
//			IRDA_PutString(string,sizeof(string));
//		}
//		else if(compare > 0){
//			IRDA_PutString("LED OFF\r\n",sizeof("LED OFF\r\n"));
//		}
		if (string != NULL)
		{
			USART_puts(USART1,string);
		}
			//IRDA_PutString(string, sizeof(string));
	}
}
void USART_puts(USART_TypeDef* USARTx,volatile char *s){

while(*s){
// wait until data register is empty
while( !(USARTx->SR & 0x00000040) );
USART_SendData(USARTx, *s);
 *s++;
}
}
//char getcharUsart(void)
//{
//	char c;
//	// Wait for incomming char...
//		while (USART_GetFlagStatus(USART1, USART_FLAG_RXNE) == RESET) ;
//		c = USART_ReceiveData(USART1);
//		// Char filter
//    if ( (c >= 0x20 && c <= 0x7E) || c == 0x2 || c == 0x3)
//		{
//			return c;
//		}
//		// Return NUL (null)
//    return 0x0;
//}
//void GetString(char* buffer)
//{
//    u8 idx = 0;
//    char c;
//    
//    while(idx < 8)
//    {
//        buffer[idx++] = getcharUsart();
//    }

//    buffer[idx] = '\0';
//}

void usart_rxtx(void)
{
    const unsigned char welcome_str[] = " Welcome to Bluetooth!\r\n";

    /* Enable USART1 and GPIOA clock */
    //RCC_APB2PeriphClockCmd(RCC_APB2Periph_USART1, ENABLE);

    /* NVIC Configuration */
    NVIC_Configuration();

    /* Configure the GPIOs */
    //GPIO_Configuration();

    /* Configure the USART1 */
    //USART_Configuration();

    /* Enable the USART1 Receive interrupt: this interrupt is generated when the
         USART1 receive data register is not empty */
    //USART_ITConfig(USART1, USART_IT_RXNE, ENABLE);
		init_USART1(9600);
    /* print welcome information */
    UARTSend(welcome_str, sizeof(welcome_str));
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
  
	//

	//
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

/*******************************************************************************
* Function Name  : UARTSend
* Description    : Send a string to the UART.
* Input          : - pucBuffer: buffers to be printed.
*                : - ulCount  : buffer's length
*******************************************************************************/
void UARTSend(const unsigned char *pucBuffer, unsigned long ulCount)
{
    //
    // Loop while there are more characters to send.
    //
    while(ulCount--)
    {
        USART_SendData(USART1, (uint16_t) *pucBuffer++);
        /* Loop until the end of transmission */
        while(USART_GetFlagStatus(USART1, USART_FLAG_TC) == RESET)
        {
        }
    }
}
void IRDA_PutChar(char c)
{
    // Send a char...
    USART_SendData(USART1, c);

    // ... wait until the char is sended
    while(USART_GetFlagStatus(USART1, USART_FLAG_TXE) == RESET) ;
}
void IRDA_PutString(char* s, unsigned long length)
{
	u8 idx = 0;
//    if (*s == 0x0 || length < 1 || length > 100)
//        return;
//    
//    
//    
    while (idx < length && s[idx] != '\0')
    {
        IRDA_PutChar(s[idx++]);
    }
}

void initPA15(){
  GPIO_InitTypeDef  GPIO_InitStructure;
  
  /* Enable the GPIO_LED Clock */
  RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOA, ENABLE);
  
  /* Configure the GPIO_LED pin */
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_15;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;
  GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_Init(GPIOA, &GPIO_InitStructure);
}

