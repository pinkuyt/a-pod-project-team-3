#include "DMA_USART.h"
uint32_t Buffer[32];

 void Fill_Buffer(uint16_t *pBuffer, uint16_t BufferLenght, uint32_t Offset)
 {
  uint16_t IndexTmp = 0;

  /* Put in global buffer different values */
   for (IndexTmp = 0; IndexTmp < BufferLenght; IndexTmp++ )
  {
    pBuffer[IndexTmp] = IndexTmp + Offset;
   }
 }


void DMA_CONFIG(void)
{
	
	DMA_InitTypeDef DMA_Initstructure;
	
	DMA_DeInit(DMA1_Stream2);
	/* DMA1 clock enable */
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_DMA1,ENABLE);
	
	DMA_Initstructure.DMA_Channel = DMA_Channel_4;
	DMA_Initstructure.DMA_DIR = DMA_DIR_PeripheralToMemory; //Receive
	DMA_Initstructure.DMA_Memory0BaseAddr = (uint32_t) Buffer;
	DMA_Initstructure.DMA_BufferSize = (uint16_t)sizeof(Buffer);	
	DMA_Initstructure.DMA_PeripheralBaseAddr = (uint32_t)&USART1->DR;
	DMA_Initstructure.DMA_PeripheralInc = DMA_PeripheralInc_Disable;
	DMA_Initstructure.DMA_MemoryInc = DMA_MemoryInc_Enable;
	DMA_Initstructure.DMA_PeripheralDataSize = DMA_PeripheralDataSize_Byte;
	DMA_Initstructure.DMA_Mode = DMA_Mode_Circular;
	DMA_Initstructure.DMA_Priority = DMA_Priority_High;
	DMA_Initstructure.DMA_FIFOMode = DMA_FIFOMode_Enable;
	DMA_Initstructure.DMA_FIFOThreshold = DMA_FIFOThreshold_Full;
	DMA_Initstructure.DMA_MemoryBurst = DMA_MemoryBurst_Single;
	DMA_Initstructure.DMA_PeripheralBurst = DMA_PeripheralBurst_Single;
	
	DMA_Init(DMA1_Stream2,&DMA_Initstructure);
	
	/* Enable the USART Rx DMA request */
	USART_DMACmd(USART1,USART_DMAReq_Rx,ENABLE);
	
	/* Enable DMA Stream Half Transfer and Transfer Complete interrupt */
	DMA_ITConfig(DMA1_Stream2,DMA_IT_TC,ENABLE);
	DMA_ITConfig(DMA1_Stream2,DMA_IT_HT,ENABLE);
	
	/* Enable the DMA RX Stream */
	DMA_Cmd(DMA1_Stream2,ENABLE);

}

void DMA1_Stream2_IRQHandler(void)
{
	/* Test on DMA Stream Transfer Complete interrupt */
	if (DMA_GetITStatus(DMA1_Stream2,DMA_IT_TCIF2))
	{
		/* Clear DMA Stream Transfer Complete interrupt pending bit */
		DMA_ClearITPendingBit(DMA1_Stream2,DMA_IT_TCIF2);
		
		USART_SendData(USART1,'d');
	}
	
	/* Test on DMA Stream Half Transfer interrupt */
	if (DMA_GetITStatus(DMA1_Stream2,DMA_IT_HTIF2))
	{
		/* Clear DMA Stream Half Transfer interrupt pending bit */
		DMA_ClearITPendingBit(DMA1_Stream2,DMA_IT_HTIF2);
		
		USART_SendData(USART1,'e');
	}
	
}