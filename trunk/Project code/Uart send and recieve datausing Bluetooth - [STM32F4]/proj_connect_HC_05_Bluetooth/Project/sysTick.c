#include "sysTick.h"

__IO uint64_t TickCnt = 0;
void SysTick_Handler(void)
{
    TickCnt++;
	
    TimingDelay_Decrement();
		

}

void systick_init(void)
{
	if (SysTick_Config(SystemCoreClock / 1000))
	{ 
		/* Capture error */ 
		while (1);
	}
}

//void TimingDelay_Decrement(void)
//{
//    if (TimingDelay != 0x00)
//    { 
//        TimingDelay--;
//    }
//}

uint64_t GetTickCount(void)
{
    return TickCnt;
}

uint8_t CheckTick(uint64_t TickBase, uint64_t Time)
{
    uint64_t CurTick;
    
    CurTick = GetTickCount();
    
    if (CurTick > TickBase)
    {
        if (CurTick >= (TickBase + Time))
        {
            return 1;
        }
    }
    else
    {
        if (CurTick >= ((uint64_t)(TickBase + Time)))
        {
            return 1;
        }
    }

    return 0;
}

//void Delay(__IO uint32_t nTime)
//{ 
//  TimingDelay = nTime;

//  while(TimingDelay != 0);
//}
