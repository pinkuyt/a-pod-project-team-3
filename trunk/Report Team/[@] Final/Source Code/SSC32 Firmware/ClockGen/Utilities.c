#include <mega328p.h>
#include "SSC32.h"
#include "Utilities.h"

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