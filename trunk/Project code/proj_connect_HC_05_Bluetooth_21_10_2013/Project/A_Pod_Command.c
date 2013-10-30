#include "A_Pod_Command.h"

/*Tripod A horizontal*/
	char left_Front[] = {0x23, 0x10};
	char left_Rear[] = {0x23, 0x18};
	char right_Center[] = {0x23, 0x04};
/*Tripod B horizontal*/	
	char right_Front[] = {0x23, 0x03};
	char right_Rear[] = {0x23, 0x08};
	char left_Center[] = {0x23, 0x14};
/*Tripod A vertical*/	
	char left_Front_1[] = {0x23, 0x11};
	char left_Rear_1[] = {0x23, 0x19};
	char right_Center_1[] = {0x23, 0x05}; 
	char left_Front_2[] = {0x23, 0x12};
	char left_Rear_2[] = {0x23, 0x1A};
	char right_Center_2[] = {0x23, 0x06};
/*Tripod B vertical*/	
	char right_Front_1[] = {0x23, 0x03};
	char right_Rear_1[] = {0x23, 0x09};
	char left_Center_1[] = {0x23, 0x15};
	char right_Front_2[] = {0x23, 0x02};
	char right_Rear_2[] = {0x23, 0x0A};
	char left_Center_2[] = {0x23, 0x16};
/*Mandible*/	
	char left[] = {0x23, 0x1C};
	char right[] = {0x23, 0x0C};
/*Neck*/		
	char Vertical[] = {0x23, 0x1D};
	char Horizontal[] = {0x23, 0x0D};
	char Balance[] = {0x23, 0x0E};
	

void cmd_start(void)
{
	char start[] = {0x53,1};
	USART_puts(USART2,start);
}

void cmd_stop(void)
{
	char stop[] = {0x53,2};
	USART_puts(USART2,stop);
}

void initStart(void)
{
	char T[] = {0x54,1};
	char highP[1];
	char lowP[1];

	char cmd[100] = "";
	highP[0] = highPulse(0x5DC); //P1500
	lowP[0] = lowPulse(0x5DC);
		
	// assign command here
	/*Defaul Pulsewitdh = 1500*/
	/*Tripod A horizontal*/
	mergeCmd(cmd,left_Front);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	mergeCmd(cmd,left_Rear);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	mergeCmd(cmd,right_Center);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	/*Tripod A vertical*/
	mergeCmd(cmd,left_Front_1);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	mergeCmd(cmd,left_Rear_1);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	mergeCmd(cmd,right_Center_1);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	mergeCmd(cmd,left_Front_2);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	mergeCmd(cmd,left_Rear_2);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	mergeCmd(cmd,right_Center_2);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	/*Tripod B horizontal*/
	mergeCmd(cmd,right_Front);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	mergeCmd(cmd,right_Rear);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	mergeCmd(cmd,left_Center);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	/*Tripod B vertical*/
	mergeCmd(cmd,right_Front_1);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	mergeCmd(cmd,right_Rear_1);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	mergeCmd(cmd,left_Center_1);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	mergeCmd(cmd,right_Front_2);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	mergeCmd(cmd,right_Rear_2);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	mergeCmd(cmd,left_Center_2);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	/*Mandible*/
	mergeCmd(cmd,left);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	mergeCmd(cmd,right);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	/*Neck*/
	mergeCmd(cmd,Balance);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	mergeCmd(cmd,Horizontal);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	mergeCmd(cmd,Vertical);
	mergeCmd(cmd,highP);
	mergeCmd(cmd,lowP);
	/*End command*/
	mergeCmd(cmd,T);
	USART_puts(USART2,cmd);
	
}
void test(void)

{
	char servo[] = {0x23,0x08};
	char end[] = {0x54,0x01};
	char highP[1];
	char lowP[1];
	highP[0] = highPulse(0x4B0);
	lowP[0] = lowPulse(0x4B0);
	
	USART_puts(USART2,servo);
	USART_puts(USART2,highP);
	USART_puts(USART2,lowP);
	USART_puts(USART2,end);
}

void test1(void)

{
	uint16_t Htemp,Ltemp;
	char servo[] = {0x23,0x08};
	char end[] = {0x54,0x01};
	char highP[1];
	char lowP[1];
	highP[0] = highPulse(0x708);
	lowP[0] = lowPulse(0x708);
	
	USART_puts(USART2,servo);
	USART_puts(USART2,highP);
	USART_puts(USART2,lowP);
	USART_puts(USART2,end);
}

