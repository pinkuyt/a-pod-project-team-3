#include "led1.h"

void led12(void)
{
	GPIO_WriteBit(GPIOD,GPIO_Pin_12,(BitAction)(1-GPIO_ReadOutputDataBit(GPIOD,GPIO_Pin_12)));
}
void led13(void)
{
	GPIO_WriteBit(GPIOD,GPIO_Pin_13, (BitAction) (1-GPIO_ReadOutputDataBit(GPIOD,GPIO_Pin_13)));
}
void led14(void)
{
	GPIO_WriteBit(GPIOD,GPIO_Pin_14, (BitAction) (1-GPIO_ReadOutputDataBit(GPIOD,GPIO_Pin_14)));
}
void led15(void)
{
	GPIO_WriteBit(GPIOD,GPIO_Pin_15, (BitAction) (1-GPIO_ReadOutputDataBit(GPIOD,GPIO_Pin_15)));
}