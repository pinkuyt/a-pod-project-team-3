#include <mega328p.h>
#include "SSC32.h"
#include "Utilities.h"

unsigned char Delay_Count;

char Max(char* arr,char length)
{
    char i, max = arr[0];
    for (i=0;i<length;i++)
    {
        if (max < arr[i])
        {
            max = arr[i];
        }
    }
    return max;
}
// Delay Time = 10 x time (ms)
void Delay_10ms(char time)
{
    Delay_Count = 0;
    TCCR0B=0x05;
    while (Delay_Count<time);
    TCCR0B=0x00;
    TCNT0=0x00;
}