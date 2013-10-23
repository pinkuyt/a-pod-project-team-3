#include "clock.h"
void clock()
{

		if (sec < 59)
			{
				sec++;	
			}
			else
			{
				sec = 0;
				if (min < 59)
				{
				min++;
				}
				else
				{
					min = 0;
					if(hour < 23)
					{
						hour++;
					}
					else
					{
						hour = 0;
					}
				}
			}
}