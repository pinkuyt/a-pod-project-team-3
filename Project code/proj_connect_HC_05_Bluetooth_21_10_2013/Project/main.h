/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MAIN_H
#define __MAIN_H

/* Includes ------------------------------------------------------------------*/
#include "stm32f4xx.h"
#include "stm32f4xx_usart.h"
#include "stm32f4xx_gpio.h"
#include "stm32f4xx_rcc.h"
#include "misc.h"
#include <stdio.h>
#include "led_init.h"
#include "led1.h"
#include "Usart.h"
#include "Usart_Bluetooth.h"
#include "button_init.h"

#include <string.h>


/* Exported types ------------------------------------------------------------*/

/* Exported constants --------------------------------------------------------*/
#define BT_BAUD 9600
#define MAX_STRLEN 20 // this is the maximum string length of our string in characters

#endif /* __MAIN_H */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
