#include "main.h"

/* Private variables ---------------------------------------------------------*/
__IO uint64_t delay_1 = 0,delay_2 = 0,delay_3 = 0,delay_4 = 0,delay_5 = 0;

static __IO uint32_t TimingDelay;
volatile char received_string[MAX_STRLEN+1]; // this will hold the recieved string
void USART_puts(USART_TypeDef* USARTx,volatile char *s);
uint16_t buffer_string[250];


/* Method definition ---------------------------------------------------------*/



int main(void) {
  
  u8 loop = 1;
	char string[256];
	//char string1[256];
	uint16_t value;
	uint16_t sizestring;
  int icase = 0;
  initPA15();
  init_USART1(BT_BAUD);
	systick_init();
	led_Init();
	button_init();
	UART2_CONFIG(9600);// 
	DMA_CONFIG();
    
  setPA15On();
  togglePA15();
	


  while(loop){ 
    //Send data through the bluetooth communication		
			if (GPIOA->IDR & 0x0001)
			{
			if (CheckTick(delay_1,500))
			{
				delay_1 = GetTickCount();
				USART_puts(USART1, "troi oi 1 2 3 4 5 6 7 8 9 10\n");
				led12();
			}
			}
			if (CheckTick(delay_2,1000))
			{
					delay_2 = GetTickCount();
					//led13();
			}
			if (CheckTick(delay_3,5000))
			{
				delay_3 = GetTickCount();
				led14();
			}
			
			if (CheckTick(delay_4,100))
			{
				delay_4 = GetTickCount();
				while(USART_GetFlagStatus(USART1, USART_FLAG_RXNE) == RESET);
				//while(DMA_GetFlagStatus(DMA1_Stream2,DMA_FLAG_TCIF1) == RESET);
				value = USART_ReceiveData(USART1);
				memset(string,0,sizeof(string[0])*256); // Clear all to 0 so string properly represented
				sprintf(string,"%c",value);
				//sizestring = sizeof(string);
				//sprintf(string1,"%c",sizestring);
				if (string != NULL)
				{

					//USART_puts(USART1,string);
					if 			(string != NULL) icase = 1;
					else if (memchr(string, '2', sizeof(string))) icase = 2;
					else if (memchr(string, '3', sizeof(string))) icase = 3;
					else if (memchr(string, '4', sizeof(string))) icase = 4;
					else if (memchr(string, '5', sizeof(string))) icase = 5;
					//else icase = 6;
					switch (icase)
					{
						case 1:
						{
							USART_puts(USART1,string);
							icase = 0;
							led15();
						}
						break;
						case 2:
						{
							USART_puts(USART1,"di xuong");
							icase = 0;
							//led14();
						}
						break;
						case 3:
						{
							USART_puts(USART1,"sang trai");
							icase = 0;
							//led13();
						}
						break;
						case 4:
						{
							USART_puts(USART1,"sang phai");
							icase = 0;
						}
						break;
						case 5:
						{
							USART_puts(USART1,"can bang");
							icase = 0;
						}
						break;
//						case 6:
//						{
//							//USART_puts(USART1,string);
//							icase = 0;
//						}
//						break;
						default: break;
						
					}
					
					//usart_send_string(string);
					//USART_SendData(USART1,value);
				}
				else
				{
					//usart_send_string(string);
				}
				led15();
			}
			if (CheckTick(delay_5,250))
		{
			delay_5 = GetTickCount();
		}
    /* Disable the UART connection */
    //USART_Cmd(USART1, DISABLE);
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
//int UART_recieve()
//{
//		uint16_t st;
//		static int rx_index = 0;
//		
//		/* Loop until the end of transmission */
//		while (USART_GetFlagStatus(USART1, USART_FLAG_TC) == RESET)
//		{
//			/* Read one byte from the receive data register */
//    StringLoop[rx_index++] = USART_ReceiveData(USART1);
// 
//    if (rx_index >= (sizeof(StringLoop) - 1))
//      rx_index = 0;
// 
//    /* Clear the UART_IT_RXNE pending interrupt, probably overkill */
//    USART_ClearITPendingBit(USART1, USART_IT_RXNE);
//		}
//		//st = USART_ReceiveData(USART1);
//		
//		return st;
//	} 	


void setPA15On(){
  // GPIO port bit set/reset low register,  Address offset: 0x18      */
  GPIOA->BSRRL = GPIO_Pin_15;
}

void togglePA15(){
  //  GPIO port output data register,        Address offset: 0x14      */
  GPIOA->ODR ^= GPIO_Pin_15;
}


/* This funcion initializes the USART1 peripheral
*
* Arguments: baudrate --> the baudrate at which the USART is
* 						   supposed to operate
*/
void init_USART1(uint32_t baudrate){

  GPIO_InitTypeDef GPIO_InitStruct; // this is for the GPIO pins used as TX and RX
  USART_InitTypeDef USART_InitStruct; // this is for the USART1 initilization
  NVIC_InitTypeDef NVIC_InitStructure; // this is used to configure the NVIC (nested vector interrupt controller)
  
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
	/* Configure the Priority Group to 2 bits */
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2);
	//
	
  NVIC_InitStructure.NVIC_IRQChannel = DMA2_Stream5_IRQn;		 // we want to configure the USART1 interrupts
  NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;// this sets the priority group of the USART1 interrupts
  NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;		 // this sets the subpriority inside the group
  NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;			 // the USART1 interrupts are globally enabled
  NVIC_Init(&NVIC_InitStructure);							 // the properties are passed to the NVIC_Init function which takes care of the low level stuff
  
  // finally this enables the complete USART1 peripheral
  USART_Cmd(USART1, ENABLE);
}

/*- Interruption handler -----------------------------------------------------*/

// this is the interrupt request handler (IRQ) for ALL USART1 interrupts
void USART1_IRQHandler(void){
	// check if the USART1 receive interrupt flag was set
	if( USART_GetITStatus(USART1, USART_IT_RXNE) ){

		static uint8_t cnt = 0; // this counter is used to determine the string length
		char t = USART1->DR; // the character from the USART1 data register is saved in t

		/* check if the received character is not the LF character (used to determine end of string)
		 * or the if the maximum string length has been been reached
		 */
		if( (t != 'n') && (cnt < MAX_STRLEN) ){
			received_string[cnt] = t;
			cnt++;
		}
		else{ // otherwise reset the character counter and print the received string
			cnt = 0;
			USART_puts(USART1, received_string);
		}
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

