#include "button_user.h"

int button_check(int button)
{
	//int button = 0;
	
	button = GPIO_ReadInputDataBit(GPIOA,GPIO_Pin_0);
	return button;
}