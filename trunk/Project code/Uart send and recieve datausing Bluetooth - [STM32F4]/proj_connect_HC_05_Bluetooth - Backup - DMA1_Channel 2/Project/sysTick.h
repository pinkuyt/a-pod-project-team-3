#include "stm32f4xx.h"


static __IO uint32_t TimingDelay;

	
	
	void SysTick_Handler(void);
	
	void systick_init(void);
	
	void TimingDelay_Decrement(void);
	
	uint64_t GetTickCount(void);
	
	uint8_t CheckTick(uint64_t, uint64_t);
	
	void Delay(__IO uint32_t);	
	