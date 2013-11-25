#include "main.h"
#include "APOD.h"
#include "A_Pod_Command.h"
char RecievedCommand;
char b_Command;


char b_Start;
char b_Stop;

char b_Forward;
char b_Backward;
char b_TurnLeft;
char b_TurnRight;

char b_TowardTheFront;
char b_TowardTheBack;
char b_SqueezeToLeft;
char b_SqueezeToRight;

char b_StandLift;
char b_StandDrop;
char b_StandBalance;

char b_WavetheTail;

char b_RotateHeadLeft;
char b_RotateHeadRight;

char b_TurnHeadLeft;
char b_turnHeadRight;

char b_LiftHeadUp;
char b_DropHeadDown;

char b_NipMandible;
char b_ReleaseMandible;

char b_Greeting;


char string[256];
uint8_t checkStart = 0;


int main(void)
{
	
	usart_rxtx();
// Reset States
	RecievedCommand = 0x00;
	b_Command = 0;

	b_Start 					= 0;
	b_Stop 						= 0;

	b_Forward 				= 0;
	b_Backward 				= 0;
	b_TurnLeft 				= 0;
	b_TurnRight 			= 0;
	
	b_TowardTheFront 	= 0;
	b_TowardTheBack  	= 0;
	
	b_SqueezeToLeft		= 0;
	b_SqueezeToRight	=	0;
	
	b_StandBalance		= 0;
	b_StandDrop				= 0;
	b_StandLift				= 0;
	
	b_WavetheTail			= 0;
	
	b_RotateHeadLeft	= 0;
	b_RotateHeadRight	= 0;
	
	b_TurnHeadLeft		= 0;
	b_turnHeadRight		= 0;
	
	b_LiftHeadUp			= 0;
	b_DropHeadDown		= 0;
	
	b_NipMandible			= 0;
	b_ReleaseMandible	= 0;
	
	b_Greeting				= 0;
	
	while(1)
	{
		// ----------------------------------------
		// Process command
		if (b_Command)
		{
			switch (RecievedCommand)
			{
				case 0x31: 	// Start Apod
					b_Start = 1;
					break;
				case 0x32:	// Stop Apod
					b_Stop = 1;
					break;
				case 0x33:	// Move Forward
					b_Forward = 1;
					break;
				case 0x34:	// Move BackWard
					b_Backward = 1;
					break;
				case 0x35:	// Move Left
					b_TurnLeft = 1;
					break;
				case 0x36:	// Move Right6
					b_TurnRight = 1;
					break;
				case 0x37:	// Toward the Front
					b_TowardTheFront = 1;
					break;
				case 0x38:	// Toward the Back
					b_TowardTheBack = 1;
					break;
				case 0x39:	// Squeeze to Left
					b_SqueezeToLeft = 1;
					break;
				case 0x40:	// Squeeze to Right
					b_SqueezeToRight = 1;
					break;
				case 0x41:	// Stand Lift
					b_StandLift = 1;
					break;
				case 0x42:	// Stand Drop
					b_StandDrop = 1;
					break;
				case 0x43:	// Stand Balance
					b_StandBalance = 1;
					break;
				case 0x44:	// Wave the Tail
					b_WavetheTail = 1;
					break;
				case 0x45:	// Rotate Head Left
					b_RotateHeadLeft = 1;
					break;	
				case 0x46:	// Rotate Head Right
					b_RotateHeadRight = 1;
					break;
				case 0x47:	// Turn Head Left
					b_TurnHeadLeft = 1;
					break;
				case 0x48:	// Turn Head Right
					b_turnHeadRight = 1;
					break;
				case 0x49:	// Lift Head up
					b_LiftHeadUp = 1;
					break;
				case 0x50:	// Drop Head Down
					b_DropHeadDown = 1;
					break;
				case 0x51:	// Nip Mandible
					b_NipMandible = 1;
					break;
				case 0x52:	// Release Mandible
					b_ReleaseMandible = 1;
					break;
				case 0x53:	// Greeting Audience
					b_Greeting = 1;
					break;
				
			}
			// Clear state
			b_Command = 0;
		}
		// ----------------------------------------
		if (b_Start)
		{
			/* do something */
				cmd_start();
				GenerateCommand_All(string);
				sendUSART(USART2,string,sizeof(string));
				
				checkStart = 1;
			// Clear state
			b_Start = 0;
		}
		if (b_Stop)
		{
			/* do something */
				Apod_Balance();  
				LEG_Reset_All();
				cmd_stop();
				
				checkStart = 0;
			// Clear state
			b_Stop = 0;
		}
		// ----------------------------------------
		// Forward move
		if (b_Forward)
		{
			/* do something */
			APOD_Forward(2,100,100,1638400);
			// Clear state
			b_Forward = 0;
		}
		// Backward move
		if (b_Backward)
		{
			/* do something */
			APOD_Backward(2,100,100,1638400);
			// Clear state
			b_Backward = 0;
		}
		// Turn Left
		if (b_TurnLeft)
		{
			/* do something */
			APOD_TurnLeft(1,100,100,1638400);
			// Clear state
			b_TurnLeft = 0;
		}
		// Turn Right
		if (b_TurnRight)
		{
			/* do something */
			APOD_TurnRight(1,100,100,1638400);
			// Clear state
			b_TurnRight = 0;
		}
		// toward Front
		if (b_TowardTheFront)
		{
			/* do something */
			Apod_towardtheFront(50);
			// Clear state
			b_TowardTheFront = 0;
		}
		// toward Back
		if (b_TowardTheFront)
		{
			/* do something */
			Apod_towardtheBack(50);
			// Clear state
			b_TowardTheBack = 0;
		}
		
		// squeeze to Left
		if (b_SqueezeToLeft)
		{
			/* do something */
			Apod_Squeeze_Left(50);
			// Clear state
			b_SqueezeToLeft = 0;
		}
		
		// Squeeze to Right
		if (b_SqueezeToRight)
		{
			/* do something */
			Apod_Squeeze_Right(50);
			// Clear state
			b_SqueezeToRight = 0;
		}
		
		// Stand Lift
		if (b_StandLift)
		{
			/* do something */
			Apod_lift(50);
			// Clear state
			b_StandLift = 0;
		}
		
		// Stand Drop
		if (b_StandDrop)
		{
			/* do something */
			Apod_Drop(50);
			// Clear state
			b_StandDrop = 0;
		}
		
		// Stand balance
		if (b_StandBalance)
		{
			/* do something */
			Apod_Balance(50);
			// Clear state
			 b_StandBalance = 0;
		}
		
		// Wave the Tail
		if (b_WavetheTail)
		{
			/* do something */
			
			// Clear state
			 b_WavetheTail = 0;
		}
		
		// Rotate Head Left
		if (b_RotateHeadLeft)
		{
			/* do something */
			APod_Neck_Rotate_Left(100);
			// Clear state
			 b_RotateHeadLeft = 0;
		}
		// Rotate Head Right
		if (b_RotateHeadRight)
		{
			/* do something */
			Apod_Neck_Rotate_Right(100);
			// Clear state
			 b_RotateHeadRight = 0;
		}
		
		// Turn Head Left
		if (b_TurnHeadLeft)
		{
			/* do something */
			Apod_Head_Left(100);
			// Clear state
			 b_TurnHeadLeft = 0;
		}
		
		// Turn Head Right
		if (b_turnHeadRight)
		{
			/* do something */
			Apod_Head_Right(100);
			// Clear state
			 b_turnHeadRight = 0;
		}
		
		// Lift head Up
		if (b_LiftHeadUp)
		{
			/* do something */
			Apod_Head_Up(100);
			// Clear state
			 b_LiftHeadUp = 0;
		}
		
		// Drop head Down
		if (b_DropHeadDown)
		{
			/* do something */
			Apod_Head_Down(100);
			// Clear state
			 b_DropHeadDown = 0;
		}
		
		// Nip Mandible
		if (b_NipMandible)
		{
			/* do something */
			Apod_Mandible_Nip(100);
			// Clear state
			 b_NipMandible = 0;
		}
		
		// Release Mandible
		if (b_ReleaseMandible)
		{
			/* do something */
			Apod_Mandible_Release(100);
			// Clear state
			 b_ReleaseMandible = 0;
		}
		
		// Greeting audience
		if (b_Greeting)
		{
			/* do something */
			
			// Clear state
			 b_Greeting = 0;
		}
	}
}


/*******************************************************************************
* Function Name  : UARTSend
* Description    : Send a string to the UART.
* Input          : - pucBuffer: buffers to be printed.
*                : - ulCount  : buffer's length
*******************************************************************************/


void initPA15(){
  GPIO_InitTypeDef  GPIO_InitStructure;
  
  /* Enable the GPIO_LED Clock */
  RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOA, ENABLE);
  
  /* Configure the GPIO_LED pin */
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_15;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;
  GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_UP;
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_Init(GPIOA, &GPIO_InitStructure);
}
