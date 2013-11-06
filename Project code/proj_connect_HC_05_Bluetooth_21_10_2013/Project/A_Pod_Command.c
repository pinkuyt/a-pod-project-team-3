#include "A_Pod_Command.h"

/*Tripod A horizontal*/
	char left_Front[] = {0x23, 0x10};
	char left_Rear[] = {0x23, 0x18};
	char right_Center[] = {0x23, 0x04};
/*Tripod B horizontal*/	
	char right_Front[] = {0x23, 0x00};
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
	char right_Front_1[] = {0x23, 0x01};
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
/*end T command*/
	char T[] = {0x54,1};	
	
	
/*Command: start Apod*/
void cmd_start(void)
{
	char start[] = {0x53,1};
	//USART_puts(USART2,start);
	sendUSART(USART2,start,strlen(start));
}

/*Command: stop Apod*/
void cmd_stop(void)
{
	char stop[] = {0x53,2};
	//USART_puts(USART2,stop);
	sendUSART(USART2,stop,strlen(stop));
}

/*Command: set servos with pulsewitdh = */
void initStop(void)
{
	char highP_1200[1];
	char lowP_1200[1];
	char highP_1800[1];
	char lowP_1800[1];
	char cmd[100] = "";
	
	highP_1200[0] = highPulse(0x28A); //P650
	lowP_1200[0] = lowPulse(0x28A);
	highP_1800[0] = highPulse(0x8FC); //P2200
	lowP_1800[0] = lowPulse(0x8FC);	
	
	/*Tripod A vertical*/
	servoCmd(cmd,left_Front_1,highP_1200,lowP_1200);
	servoCmd(cmd,left_Rear_1,highP_1200,lowP_1200);
	servoCmd(cmd,right_Center_1,highP_1800,lowP_1800);//
	servoCmd(cmd,left_Front_2,highP_1200,lowP_1200);
	servoCmd(cmd,left_Rear_2,highP_1200,lowP_1200);
	servoCmd(cmd,right_Center_2,highP_1800,lowP_1800);//
	
	
	/*Tripod B vertical*/
	servoCmd(cmd,right_Front_1,highP_1800,lowP_1800);
	servoCmd(cmd,right_Rear_1,highP_1800,lowP_1800);
	servoCmd(cmd,left_Center_1,highP_1200,lowP_1200);//
	servoCmd(cmd,right_Front_2,highP_1800,lowP_1800);
	servoCmd(cmd,right_Rear_2,highP_1800,lowP_1800);
	servoCmd(cmd,left_Center_2,highP_1200,lowP_1200);//
	
	/*End command*/
	mergeCmd(cmd,T);
	//USART_puts(USART2,cmd);
	sendUSART(USART2,cmd,strlen(cmd));
}
/*Command: set all servos with pulsewitdh = 1500*/
void initStart(void)
{

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
	//USART_puts(USART2,cmd);
	sendUSART(USART2,cmd,strlen(cmd));
	
}
/*init stage: first time forward*/
uint8_t initForward(uint16_t pulseVertical, uint16_t pulseHorizontal, uint8_t checkFlag)
{
	char highP_Vertical_min[1];
	char lowP_Vertical_min[1];
	
	char highP_Vertical_max[1];
	char lowP_Vertical_max[1];	
	
	char highP_horizontal_min[1];
	char lowP_horizontal_min[1];
	
	char highP_horizontal_max[1];
	char lowP_horizontal_max[1];	
	
	char cmd[100] = "";
	
	highP_Vertical_min[0] = highPulse(pulseVertical - 0x12C); //P1200 1500 - 300
	lowP_Vertical_min[0] 	= lowPulse(pulseVertical - 0X12C);
	
	highP_Vertical_max[0] = highPulse(pulseVertical + 0x12C); //P1800 1500 + 300
	lowP_Vertical_max[0] 	= lowPulse(pulseVertical + 0X12C);
	
	highP_horizontal_min[0] = highPulse(pulseHorizontal - 0xC8);//P1300 1500 - 200
	lowP_horizontal_min[0]  = lowPulse(pulseHorizontal - 0XC8);
	
	highP_horizontal_max[0] = highPulse(pulseHorizontal + 0xC8);//P1700 1500 + 200
	lowP_horizontal_max[0]  = lowPulse(pulseHorizontal + 0XC8);
	
	
	/*T_A Vertical: Low*/
	
	/*T_A Horizontal: Front*/
	
	/*T_B Vertical: Mid*/
	
	/*T_B Horizontal: Rear*/
	
	return checkFlag;
}
void tripodA_Horizontal_Front(char *command,uint16_t Pulse, uint16_t weightNumber)
{
	char hightP_min[1];
	char lowP_min[1];
	char hightP_max[1];
	char lowP_max[1];
	
	hightP_min[0] = highPulse(Pulse - weightNumber); //
	lowP_min[0] = lowPulse(Pulse - weightNumber);
	hightP_max[0] = highPulse(Pulse + weightNumber); //
	lowP_max[0] = lowPulse(Pulse + weightNumber);	
	
	servoCmd(command,left_Front,hightP_min,lowP_min);
	servoCmd(command,right_Center,hightP_max,lowP_max);
	servoCmd(command,left_Rear,hightP_min,lowP_min);
}

void tripodA_Horizontal_Center(char *command,uint16_t Pulse, uint16_t weightNumber)
{
	char hightP_min[1];
	char lowP_min[1];
	char hightP_max[1];
	char lowP_max[1];
	
	hightP_min[0] = highPulse(Pulse); //
	lowP_min[0] = lowPulse(Pulse);
	hightP_max[0] = highPulse(Pulse); //
	lowP_max[0] = lowPulse(Pulse);	
	
	servoCmd(command,left_Front,hightP_min,lowP_min);
	servoCmd(command,right_Center,hightP_max,lowP_max);
	servoCmd(command,left_Rear,hightP_min,lowP_min);
}

void tripodA_Horizontal_Rear(char *command,uint16_t Pulse, uint16_t weightNumber)
{
	char hightP_min[1];
	char lowP_min[1];
	char hightP_max[1];
	char lowP_max[1];
	
	hightP_min[0] = highPulse(Pulse + weightNumber); //
	lowP_min[0] = lowPulse(Pulse + weightNumber);
	hightP_max[0] = highPulse(Pulse - weightNumber); //
	lowP_max[0] = lowPulse(Pulse - weightNumber);	
	
	servoCmd(command,left_Front,hightP_min,lowP_min);
	servoCmd(command,right_Center,hightP_max,lowP_max);
	servoCmd(command,left_Rear,hightP_min,lowP_min);
}

/**/
void tripodB_Horizontal_Front(char *command,uint16_t Pulse, uint16_t weightNumber)
{
	char hightP_min[1];
	char lowP_min[1];
	char hightP_max[1];
	char lowP_max[1];
	
	hightP_min[0] = highPulse(Pulse + weightNumber); //
	lowP_min[0] = lowPulse(Pulse + weightNumber);
	hightP_max[0] = highPulse(Pulse - weightNumber); //
	lowP_max[0] = lowPulse(Pulse - weightNumber);		
	
	servoCmd(command,right_Front,hightP_min,lowP_min);
	servoCmd(command,left_Center,hightP_max,lowP_max);
	servoCmd(command,right_Rear,hightP_min,lowP_min);
}

void tripodB_Horizontal_Center(char *command,uint16_t Pulse, uint16_t weightNumber)
{
	char hightP_min[1];
	char lowP_min[1];
	char hightP_max[1];
	char lowP_max[1];
	
	hightP_min[0] = highPulse(Pulse); //
	lowP_min[0] = lowPulse(Pulse);
	hightP_max[0] = highPulse(Pulse); //
	lowP_max[0] = lowPulse(Pulse);	
	
	servoCmd(command,right_Front,hightP_min,lowP_min);
	servoCmd(command,left_Center,hightP_max,lowP_max);
	servoCmd(command,right_Rear,hightP_min,lowP_min);
}

void tripodB_Horizontal_Rear(char *command,uint16_t Pulse, uint16_t weightNumber)
{
	char hightP_min[1];
	char lowP_min[1];
	char hightP_max[1];
	char lowP_max[1];
	
	hightP_min[0] = highPulse(Pulse - weightNumber); //
	lowP_min[0] = lowPulse(Pulse - weightNumber);
	hightP_max[0] = highPulse(Pulse + weightNumber); //
	lowP_max[0] = lowPulse(Pulse + weightNumber);	
	
	servoCmd(command,right_Front,hightP_min,lowP_min);
	servoCmd(command,left_Center,hightP_max,lowP_max);
	servoCmd(command,right_Rear,hightP_min,lowP_min);
}

void tripodA_vertical_Low(char *command,uint16_t Pulse, uint16_t weightNumber)
{
	char hightP_min[1];
	char lowP_min[1];
	char hightP_max[1];
	char lowP_max[1];
	
	hightP_min[0] = highPulse(Pulse + weightNumber); //
	lowP_min[0] = lowPulse(Pulse + weightNumber);
	hightP_max[0] = highPulse(Pulse - weightNumber); //
	lowP_max[0] = lowPulse(Pulse - weightNumber);	
	
	servoCmd(command,left_Front_1,hightP_min,lowP_min);
	servoCmd(command,left_Front_2,hightP_min,lowP_min);
	servoCmd(command,right_Center_1,hightP_max,lowP_max);
	servoCmd(command,right_Center_2,hightP_max,lowP_max);
	servoCmd(command,left_Rear_1,hightP_min,lowP_min);
	servoCmd(command,left_Rear_2,hightP_min,lowP_min);
}

void tripodA_vertical_Mid(char *command,uint16_t Pulse, uint16_t weightNumber)
{
	char hightP_min[1];
	char lowP_min[1];
	char hightP_max[1];
	char lowP_max[1];
	
	hightP_min[0] = highPulse(Pulse + weightNumber); //
	lowP_min[0] = lowPulse(Pulse + weightNumber);
	hightP_max[0] = highPulse(Pulse - weightNumber); //
	lowP_max[0] = lowPulse(Pulse - weightNumber);	
	
	servoCmd(command,left_Front_1,hightP_min,lowP_min);
	servoCmd(command,left_Front_2,hightP_min,lowP_min);
	servoCmd(command,right_Center_1,hightP_max,lowP_max);
	servoCmd(command,right_Center_2,hightP_max,lowP_max);
	servoCmd(command,left_Rear_1,hightP_min,lowP_min);
	servoCmd(command,left_Rear_2,hightP_min,lowP_min);
}

void tripodA_vertical_High(char *command,uint16_t Pulse, uint16_t weightNumber)
{
	char hightP_min[1];
	char lowP_min[1];
	char hightP_max[1];
	char lowP_max[1];
	
	hightP_min[0] = highPulse(Pulse - weightNumber); //
	lowP_min[0] = lowPulse(Pulse - weightNumber);
	hightP_max[0] = highPulse(Pulse + weightNumber); //
	lowP_max[0] = lowPulse(Pulse + weightNumber);	
	
	servoCmd(command,left_Front_1,hightP_min,lowP_min);
	servoCmd(command,left_Front_2,hightP_min,lowP_min);
	servoCmd(command,right_Center_1,hightP_max,lowP_max);
	servoCmd(command,right_Center_2,hightP_max,lowP_max);
	servoCmd(command,left_Rear_1,hightP_min,lowP_min);
	servoCmd(command,left_Rear_2,hightP_min,lowP_min);
}

void tripodB_vertical_Low(char *command,uint16_t Pulse, uint16_t weightNumber)
{
	char hightP_min[1];
	char lowP_min[1];
	char hightP_max[1];
	char lowP_max[1];
	
	hightP_min[0] = highPulse(Pulse - weightNumber); //
	lowP_min[0] = lowPulse(Pulse - weightNumber);
	hightP_max[0] = highPulse(Pulse + weightNumber); //
	lowP_max[0] = lowPulse(Pulse + weightNumber);	
	
	servoCmd(command,right_Front_1,hightP_min,lowP_min);
	servoCmd(command,right_Front_2,hightP_min,lowP_min);
	servoCmd(command,left_Center_1,hightP_max,lowP_max);
	servoCmd(command,left_Center_2,hightP_max,lowP_max);
	servoCmd(command,right_Rear_1,hightP_min,lowP_min);
	servoCmd(command,right_Rear_2,hightP_min,lowP_min);
}
void tripodB_vertical_Mid(char *command,uint16_t Pulse, uint16_t weightNumber)
{
	char hightP_min[1];
	char lowP_min[1];
	char hightP_max[1];
	char lowP_max[1];
	
	hightP_min[0] = highPulse(Pulse + weightNumber); //
	lowP_min[0] = lowPulse(Pulse + weightNumber);
	hightP_max[0] = highPulse(Pulse - weightNumber); //
	lowP_max[0] = lowPulse(Pulse - weightNumber);	
	
	servoCmd(command,right_Front_1,hightP_min,lowP_min);
	servoCmd(command,right_Front_2,hightP_min,lowP_min);
	servoCmd(command,left_Center_1,hightP_max,lowP_max);
	servoCmd(command,left_Center_2,hightP_max,lowP_max);
	servoCmd(command,right_Rear_1,hightP_min,lowP_min);
	servoCmd(command,right_Rear_2,hightP_min,lowP_min);
}

void tripodB_vertical_High(char *command,uint16_t Pulse, uint16_t weightNumber)
{
	char hightP_min[1];
	char lowP_min[1];
	char hightP_max[1];
	char lowP_max[1];
	
	hightP_min[0] = highPulse(Pulse + weightNumber); //
	lowP_min[0] = lowPulse(Pulse + weightNumber);
	hightP_max[0] = highPulse(Pulse - weightNumber); //
	lowP_max[0] = lowPulse(Pulse - weightNumber);	
	
	servoCmd(command,right_Front_1,hightP_min,lowP_min);
	servoCmd(command,right_Front_2,hightP_min,lowP_min);
	servoCmd(command,left_Center_1,hightP_max,lowP_max);
	servoCmd(command,left_Center_2,hightP_max,lowP_max);
	servoCmd(command,right_Rear_1,hightP_min,lowP_min);
	servoCmd(command,right_Rear_2,hightP_min,lowP_min);
}
void forward()
{
	char cmd0[100];
	char cmd1[100];
	char cmd2[100];
	char cmd3[100];
	char cmd4[100];
	char cmd5[100];
	char cmd6[100];
	char cmd7[100];
	
	tripodA_vertical_Low(cmd1,0x5DC,0xC8);
	tripodA_Horizontal_Front(cmd1,0x5DC,0xC8);
	mergeCmd(cmd1,T);
	
	
	tripodB_vertical_Mid(cmd2,0x5DC,0xC8);
	tripodB_Horizontal_Rear(cmd2,0x5DC,0xC8);
	mergeCmd(cmd2,T);
	USART_puts(USART2,cmd1);
	USART_puts(USART2,cmd2);

}