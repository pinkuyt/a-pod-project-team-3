#include "APOD.h"

const char RIGHT_FRONT = 0;
const char RIGHT_CENTER = 1;
const char RIGHT_REAR = 2;
const char LEFT_FRONT = 3;
const char LEFT_CENTER = 4;
const char LEFT_REAR = 5;

const char	MANDIBLE_LEFT = 0;
const char	MANDIBLE_RIGHT = 1;

const char NECK_ROTATE = 0;
const char NECK_HORIZONTAL = 1;
const char NECK_VERTICAL = 2;

// ----------------------------------------
// Position value of 32 servo
// ----------------------------------------
unsigned int Servos[32] = 
{
1500,1500,1500,1500,1500,1500,1500,1500,
1500,1500,1500,1500,1500,1700,1500,1500,
1500,1500,1500,1500,1500,1500,1500,1500,
1500,1500,1500,1500,1500,1500,1500,1500
};


// ----------------------------------------
// Leg's servo number mapping.
// {Horrizontal servo, Upper Vertical servo, Lower Vertical servo}
// ----------------------------------------
unsigned int RightFront[3] = {0,1,2};		
unsigned int RightCenter[3] = {4,5,6};	
unsigned int RightRear[3] = {8,9,10};		
unsigned int LeftFront[3] = {16,17,18}; 
unsigned int LeftCenter[3] = {20,21,22};	
unsigned int LeftRear[3] = {24,25,26};		

// ----------------------------------------
// Head servo number mapping.
// {RotateNeck servo, Verical Neck servo, Horizontal Neck servo, Mandible}
// ----------------------------------------

unsigned int Neck[3] = {13,14,15};		
unsigned int Mandible[2] = {3,19};

//-----------------------------------------
//	checkstep in command
//-----------------------------------------

// ----------------------------------------
// Mandible control
// ----------------------------------------
void MANDIBLE(char mandible, int interval)
{
	switch(mandible)
	{
		case 0: //MANDIBLE_LEFT
			Servos[Mandible[0]] += interval;
			break;
		case 1: //MANDIBLE_RIGHT
			Servos[Mandible[1]] -= interval;
			break;
	}
}

// ----------------------------------------
// Neck control
// ----------------------------------------
void Neck_Rotate(int interval)
{
	Servos[Neck[0]] += interval;
}

void Neck_Horizontal(int interval)
{
	Servos[Neck[1]] += interval;
}

void Neck_Vertical(int interval)
{
	Servos[Neck[2]] += interval;
}

	char isStop = 1;
// ----------------------------------------
// Legs control
// ----------------------------------------
void LEG_Lift(char leg, int interval)
{
	switch(leg)
	{
		case 0: // RIGHT_FRONT
			Servos[RightFront[1]] += interval;
			break;
		case 1: // RIGHT_CENTER
			Servos[RightCenter[1]] += interval;
			break;
		case 2: // RIGHT_REAR
			Servos[RightRear[1]] += interval;
			break;
		case 3: // LEFT_FRONT
			Servos[LeftFront[1]] -= interval;
			break;
		case 4: // LEFT_CENTER
			Servos[LeftCenter[1]] -= interval;
			break;
		case 5: // LEFT_REAR
			Servos[LeftRear[1]] -= interval;
			break;
	}
}
void LEG_Drop(char leg, int interval)
{
	LEG_Lift(leg, -interval);
}
void LEG_Stand(char leg)
{
	switch(leg)
	{
		case 0: // RIGHT_FRONT
			Servos[RightFront[2]] = Servos[RightFront[1]];
			break;
		case 1: // RIGHT_CENTER
			Servos[RightCenter[2]] = Servos[RightCenter[1]];
			break;
		case 2: // RIGHT_REAR
			Servos[RightRear[2]] = Servos[RightRear[1]];
			break;
		case 3: // LEFT_FRONT
			Servos[LeftFront[2]] = Servos[LeftFront[1]];
			break;
		case 4: // LEFT_CENTER
			Servos[LeftCenter[2]] = Servos[LeftCenter[1]];
			break;
		case 5: // LEFT_REAR
			Servos[LeftRear[2]] = Servos[LeftRear[1]];
			break;
	}
}

void LEG_Forward(char leg, int interval)
{
	switch(leg)
	{
		case 0: // RIGHT_FRONT
			Servos[RightFront[0]] += interval;
			break;
		case 1: // RIGHT_CENTER
			Servos[RightCenter[0]] += interval;
			break;
		case 2: // RIGHT_REAR
			Servos[RightRear[0]] += interval;
			break;
		case 3: // LEFT_FRONT
			Servos[LeftFront[0]] -= interval;
			break;
		case 4: // LEFT_CENTER
			Servos[LeftCenter[0]] -= interval;
			break;
		case 5: // LEFT_REAR
			Servos[LeftRear[0]] -= interval;
			break;
	}
}
void LEG_Backward(char leg, int interval)
{
	LEG_Forward(leg,-interval);
}



void LEG_Reset(char leg)
{
	switch(leg)
	{
		case 0: // RIGHT_FRONT
			Servos[RightFront[0]] = 1500;
			Servos[RightFront[1]] = DEFAULT_Right;
			Servos[RightFront[2]] = DEFAULT_Right;
			break;
		case 1: // RIGHT_CENTER
			Servos[RightCenter[0]] = 1500;
			Servos[RightCenter[1]] = DEFAULT_Right;
			Servos[RightCenter[2]] = DEFAULT_Right;
			break;
		case 2: // RIGHT_REAR
			Servos[RightRear[0]] = 1500;
			Servos[RightRear[1]] = DEFAULT_Right;
			Servos[RightRear[2]] = DEFAULT_Right;
			break;
		case 3: // LEFT_FRONT
			Servos[LeftFront[0]] = 1500;
			Servos[LeftFront[1]] = DEFAULT_Left;
			Servos[LeftFront[2]] = DEFAULT_Left;
			break;
		case 4: // LEFT_CENTER
			Servos[LeftCenter[0]] = 1500;
			Servos[LeftCenter[1]] = DEFAULT_Left;
			Servos[LeftCenter[2]] = DEFAULT_Left;
			break;
		case 5: // LEFT_REAR
			Servos[LeftRear[0]] = 1500;
			Servos[LeftRear[1]] = DEFAULT_Left;
			Servos[LeftRear[2]] = DEFAULT_Left;
			break;
	}
}
void LEG_Reset_All(void)
{
		Servos[RightFront[0]] = 1500;
		Servos[RightFront[1]] = DEFAULT_Right;
		Servos[RightFront[2]] = DEFAULT_Right;
		Servos[RightCenter[0]] = 1500;
		Servos[RightCenter[1]] = DEFAULT_Right;
		Servos[RightCenter[2]] = DEFAULT_Right;
		Servos[RightRear[0]] = 1500;
		Servos[RightRear[1]] = DEFAULT_Right;
		Servos[RightRear[2]] = DEFAULT_Right;
		Servos[LeftFront[0]] = 1500;
		Servos[LeftFront[1]] = DEFAULT_Left;
		Servos[LeftFront[2]] = DEFAULT_Left;
		Servos[LeftCenter[0]] = 1500;
		Servos[LeftCenter[1]] = DEFAULT_Left;
		Servos[LeftCenter[2]] = DEFAULT_Left;
		Servos[LeftRear[0]] = 1500;
		Servos[LeftRear[1]] = DEFAULT_Left;
		Servos[LeftRear[2]] = DEFAULT_Left;
}





// ----------------------------------------
// Tripods Control
// ----------------------------------------
void Tripod_A_Lift(int interval)
{
	LEG_Lift(LEFT_FRONT, interval);
	LEG_Lift(RIGHT_CENTER, interval);
	LEG_Lift(LEFT_REAR, interval);
	
	LEG_Stand(LEFT_FRONT);
	LEG_Stand(RIGHT_CENTER);
	LEG_Stand(LEFT_REAR);
}
void Tripod_A_Drop(int interval)
{
	Tripod_A_Lift(-interval);
}

void Tripod_A_Forward(int interval)
{
	LEG_Forward(LEFT_FRONT, interval);
	LEG_Forward(RIGHT_CENTER, interval);
	LEG_Forward(LEFT_REAR, interval);
}
void Tripod_A_Backward(int interval)
{
	Tripod_A_Forward(-interval);
}

void Tripod_A_Left(int interval)
{
	LEG_Backward(LEFT_FRONT, interval);
	LEG_Forward(RIGHT_CENTER, interval);
	LEG_Backward(LEFT_REAR, interval);
}
void Tripod_A_Right(int interval)
{
	Tripod_A_Left(-interval);
}

void Tripod_B_Lift(int interval)
{
	LEG_Lift(RIGHT_FRONT, interval);
	LEG_Lift(LEFT_CENTER, interval);
	LEG_Lift(RIGHT_REAR, interval);
	
	LEG_Stand(RIGHT_FRONT);
	LEG_Stand(LEFT_CENTER);
	LEG_Stand(RIGHT_REAR);
}
void Tripod_B_Drop(int interval)
{
	Tripod_B_Lift(-interval);
}

void Tripod_B_Forward(int interval)
{
	LEG_Forward(RIGHT_FRONT, interval);
	LEG_Forward(LEFT_CENTER, interval);
	LEG_Forward(RIGHT_REAR, interval);
}
void Tripod_B_Backward(int interval)
{
	Tripod_B_Forward(-interval);
}

void Tripod_B_Left(int interval)
{
	LEG_Forward(RIGHT_FRONT, interval);
	LEG_Backward(LEFT_CENTER, interval);
	LEG_Forward(RIGHT_REAR, interval);
}
void Tripod_B_Right(int interval)
{
	Tripod_B_Left(-interval);
}

// ----------------------------------------
// APOD Control
// ----------------------------------------
/*Command: start Apod*/
void cmd_start(void)
{
	char start[] = {0x53,1};
	sendUSART(USART2,start,strlen(start));
}

/*Command: stop Apod*/
void cmd_stop(void)
{
	char stop[] = {0x53,2};
	sendUSART(USART2,stop,strlen(stop));
}

void APOD_Forward(int loop, int intervalVertical, int intervalHorizontal, int delay)
{
	char length ;
	char cmd[74];
	
	char i = 0;
		// --------------------------------
	// States	|	Tripod A	  | Tripod B
	// Init		|	Mid,Center	| Mid,Center
	// --------------------------------
	
	// --------------------------------
	// 0			|	Low,Center	| High,Center
	// --------------------------------
	
	/* TODO: Delay 500 ms */
	Delay(delay);
	// Tripod A :  Mid to Low
	Tripod_A_Drop(intervalVertical);
	// Tripod B : Mid to High
	Tripod_B_Lift(intervalVertical);

	/* TODO: Send Command */
	GenerateCommand_Legs(cmd);
	sendUSART(USART2,cmd,sizeof(cmd));
	
	for (i=0;i<loop;i++) 
	{

		// --------------------------------
		// 1			|	Low,Rear		| Mid,Front
		// --------------------------------
		
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A: Center to Rear
			Tripod_A_Backward(intervalHorizontal);
			// Tripod B: Center to Front
			Tripod_B_Forward(intervalHorizontal);
			// Tripod B: High to Mid
			Tripod_B_Drop(intervalVertical);

			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));


		// --------------------------------
		// 2			|	Low,Rear		| Low,Front
		// --------------------------------

			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod B: Mid to Low
			Tripod_B_Drop(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));

		// --------------------------------
		// 3			|	Mid,Rear		| Low,Front
		// --------------------------------
			
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A:  Low to Mid
			Tripod_A_Lift(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));

		// --------------------------------
		// 4			|	High,Center	| Low,Center
		// --------------------------------
			
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A: Mid to High
			Tripod_A_Lift(intervalVertical);
			// Tripod A: Rear to Center
			Tripod_A_Forward(intervalHorizontal);
			// Tripod B: Front to Center
			Tripod_B_Backward(intervalHorizontal);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));

		// --------------------------------
		// 5			|	Mid,Front		| Low,Rear
		// --------------------------------
		
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A: High to Mid
			Tripod_A_Drop(intervalVertical);
			// Tripod A: Center to Front
			Tripod_A_Forward(intervalHorizontal);
			// Tripod B: Center to Rear
			Tripod_B_Backward(intervalHorizontal);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));

		// --------------------------------
		// 6			|	Low,Front		| Low,Rear
		// --------------------------------
			
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A: Mid to Low
			Tripod_A_Drop(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));
			
		// --------------------------------
		// 7			|	Low,Front		| Mid,Rear
		// --------------------------------
		
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod B: Low to Mid
			Tripod_B_Lift(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));

		// --------------------------------
		// 0			|	Low,Center	| High,Center
		// --------------------------------
		
			/* TODO: Delay 500 ms */
				Delay(delay);
			// Tripod A: Front to Center
			Tripod_A_Backward(intervalHorizontal);
			// Tripod B: Rear to Center
			Tripod_B_Forward(intervalHorizontal);
			// Tripod B: Mid to High
			Tripod_B_Lift(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));
		}
	// --------------------------------
	// End		|	Mid,Center	| Mid,Center
	// --------------------------------

			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A: Low to Mid
			Tripod_A_Lift(intervalVertical);
			// Tripod B: High to Mid
			Tripod_B_Drop(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));
}

void APOD_Backward(int loop, int intervalVertical, int intervalHorizontal, int delay)
{
	char length ;
	char cmd[74];
	
	char i = 0;
		// --------------------------------
	// States	|	Tripod A	  | Tripod B
	// Init		|	Mid,Center	| Mid,Center
	// --------------------------------
	
	// --------------------------------
	// 0			|	Low,Center	| High,Center
	// --------------------------------
	
	/* TODO: Delay 500 ms */
	Delay(delay);
	// Tripod A :  Mid to Low
	Tripod_A_Drop(intervalVertical);
	// Tripod B : Mid to High
	Tripod_B_Lift(intervalVertical);

	/* TODO: Send Command */
	GenerateCommand_Legs(cmd);
	sendUSART(USART2,cmd,sizeof(cmd));
	
	for (i=0;i<loop;i++) 
	{

		// --------------------------------
		// 1			|	Low,Front		| Mid,Rear
		// --------------------------------
		
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A: Center to Front
			Tripod_A_Forward(intervalHorizontal);
			// Tripod B: Center to Rear
			Tripod_B_Backward(intervalHorizontal);
			// Tripod B: High to Mid
			Tripod_B_Drop(intervalVertical);

			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));


		// --------------------------------
		// 2			|	Low,Front		| Low,Rear
		// --------------------------------

			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod B: Mid to Low
			Tripod_B_Drop(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));

		// --------------------------------
		// 3			|	Mid,Front		| Low,Rear
		// --------------------------------
			
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A:  Low to Mid
			Tripod_A_Lift(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));

		// --------------------------------
		// 4			|	High,Center	| Low,Center
		// --------------------------------
			
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A: Mid to High
			Tripod_A_Lift(intervalVertical);
			// Tripod A: front to Center
			Tripod_A_Backward(intervalHorizontal);
			// Tripod B: Rear to Center
			Tripod_B_Forward(intervalHorizontal);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));

		// --------------------------------
		// 5			|	Mid,Rear		| Low,Front
		// --------------------------------
		
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A: High to Mid
			Tripod_A_Drop(intervalVertical);
			// Tripod A: Center to Front
			Tripod_A_Backward(intervalHorizontal);
			// Tripod B: Center to Rear
			Tripod_B_Forward(intervalHorizontal);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));

		// --------------------------------
		// 6			|	Low,Rear		| Low,Front
		// --------------------------------
			
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A: Mid to Low
			Tripod_A_Drop(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));
			
		// --------------------------------
		// 7			|	Low,Rear		| Mid,Front
		// --------------------------------
		
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod B: Low to Mid
			Tripod_B_Lift(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));

		// --------------------------------
		// 0			|	Low,Center	| High,Center
		// --------------------------------
		
			/* TODO: Delay 500 ms */
				Delay(delay);
			// Tripod A: Front to Center
			Tripod_A_Forward(intervalHorizontal);
			// Tripod B: Rear to Center
			Tripod_B_Backward(intervalHorizontal);
			// Tripod B: Mid to High
			Tripod_B_Lift(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));
		}
	// --------------------------------
	// End		|	Mid,Center	| Mid,Center
	// --------------------------------

			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A: Low to Mid
			Tripod_A_Lift(intervalVertical);
			// Tripod B: High to Mid
			Tripod_B_Drop(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));
}
void APOD_TurnLeft(int loop, int intervalVertical, int intervalHorizontal, int delay)
{
	
	char cmd[74];
	
	char i = 0;
		// --------------------------------
	// States	|	Tripod A	  | Tripod B
	// Init		|	Mid,Center	| Mid,Center
	// --------------------------------
	
	// --------------------------------
	// 0			|	Low,Center	| High,Center
	// --------------------------------
	
	/* TODO: Delay 500 ms */
	Delay(delay);
	// Tripod A :  Mid to Low
	Tripod_A_Drop(intervalVertical);
	// Tripod B : Mid to High
	Tripod_B_Lift(intervalVertical);

	/* TODO: Send Command */
	GenerateCommand_Legs(cmd);
	sendUSART(USART2,cmd,sizeof(cmd));
	
	for (i=0;i<loop;i++) 
	{

		// --------------------------------
		// 1			|	Low,Right	| Mid,Left
		// --------------------------------
		
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A: Center to Rear
			Tripod_A_Right(intervalHorizontal);
			// Tripod B: Center to Front
			Tripod_B_Left(intervalHorizontal);
			// Tripod B: High to Mid
			Tripod_B_Drop(intervalVertical);

			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));


		// --------------------------------
		// 2			|	Low,Right		| Low,Left
		// --------------------------------

			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod B: Mid to Low
			Tripod_B_Drop(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));

		// --------------------------------
		// 3			|	Mid,Right		| Low,Left
		// --------------------------------
			
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A:  Low to Mid
			Tripod_A_Lift(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));

		// --------------------------------
		// 4			|	High,Center	| Low,Center
		// --------------------------------
			
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A: Mid to High
			Tripod_A_Lift(intervalVertical);
			// Tripod A: Rear to Center
			Tripod_A_Left(intervalHorizontal);
			// Tripod B: Front to Center
			Tripod_B_Right(intervalHorizontal);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));

		// --------------------------------
		// 5			|	Mid,Left		| Low,Right
		// --------------------------------
		
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A: High to Mid
			Tripod_A_Drop(intervalVertical);
			// Tripod A: Center to Front
			Tripod_A_Left(intervalHorizontal);
			// Tripod B: Center to Rear
			Tripod_B_Right(intervalHorizontal);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));

		// --------------------------------
		// 6			|	Low,Left		| Low,Right
		// --------------------------------
			
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A: Mid to Low
			Tripod_A_Drop(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));
			
		// --------------------------------
		// 7			|	Low,Left		| Mid,Right
		// --------------------------------
		
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod B: Low to Mid
			Tripod_B_Lift(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));

		// --------------------------------
		// 0			|	Low,Center	| High,Center
		// --------------------------------
		
			/* TODO: Delay 500 ms */
				Delay(delay);
			// Tripod A: Front to Center
			Tripod_A_Right(intervalHorizontal);
			// Tripod B: Rear to Center
			Tripod_B_Left(intervalHorizontal);
			// Tripod B: Mid to High
			Tripod_B_Lift(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));
		}
	// --------------------------------
	// End		|	Mid,Center	| Mid,Center
	// --------------------------------

			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A: Low to Mid
			Tripod_A_Lift(intervalVertical);
			// Tripod B: High to Mid
			Tripod_B_Drop(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));
}
void APOD_TurnRight(int loop, int intervalVertical, int intervalHorizontal, int delay)
{
	char cmd[74];
	
	char i = 0;
		// --------------------------------
	// States	|	Tripod A	  | Tripod B
	// Init		|	Mid,Center	| Mid,Center
	// --------------------------------
	
	// --------------------------------
	// 0			|	Low,Center	| High,Center
	// --------------------------------
	
	/* TODO: Delay 500 ms */
	Delay(delay);
	// Tripod A :  Mid to Low
	Tripod_A_Drop(intervalVertical);
	// Tripod B : Mid to High
	Tripod_B_Lift(intervalVertical);

	/* TODO: Send Command */
	GenerateCommand_Legs(cmd);
	sendUSART(USART2,cmd,sizeof(cmd));
	
	for (i=0;i<loop;i++) 
	{

		// --------------------------------
		// 1			|	Low,Left	| Mid,Right
		// --------------------------------
		
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A: Center to Rear
			Tripod_A_Left(intervalHorizontal);
			// Tripod B: Center to Front
			Tripod_B_Right(intervalHorizontal);
			// Tripod B: High to Mid
			Tripod_B_Drop(intervalVertical);

			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));


		// --------------------------------
		// 2			|	Low,Left		| Low,Right
		// --------------------------------

			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod B: Mid to Low
			Tripod_B_Drop(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));

		// --------------------------------
		// 3			|	Mid,Left		| Low,Right
		// --------------------------------
			
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A:  Low to Mid
			Tripod_A_Lift(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));

		// --------------------------------
		// 4			|	High,Center	| Low,Center
		// --------------------------------
			
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A: Mid to High
			Tripod_A_Lift(intervalVertical);
			// Tripod A: Rear to Center
			Tripod_A_Right(intervalHorizontal);
			// Tripod B: Front to Center
			Tripod_B_Left(intervalHorizontal);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));

		// --------------------------------
		// 5			|	Mid,Right		| Low,Left
		// --------------------------------
		
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A: High to Mid
			Tripod_A_Drop(intervalVertical);
			// Tripod A: Center to Front
			Tripod_A_Right(intervalHorizontal);
			// Tripod B: Center to Rear
			Tripod_B_Left(intervalHorizontal);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));

		// --------------------------------
		// 6			|	Low,Right		| Low,Left
		// --------------------------------
			
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A: Mid to Low
			Tripod_A_Drop(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));
			
		// --------------------------------
		// 7			|	Low,Right		| Mid,Left
		// --------------------------------
		
			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod B: Low to Mid
			Tripod_B_Lift(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));

		// --------------------------------
		// 0			|	Low,Center	| High,Center
		// --------------------------------
		
			/* TODO: Delay 500 ms */
				Delay(delay);
			// Tripod A: Front to Center
			Tripod_A_Left(intervalHorizontal);
			// Tripod B: Rear to Center
			Tripod_B_Right(intervalHorizontal);
			// Tripod B: Mid to High
			Tripod_B_Lift(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));
		}
	// --------------------------------
	// End		|	Mid,Center	| Mid,Center
	// --------------------------------

			/* TODO: Delay 500 ms */
			Delay(delay);
			// Tripod A: Low to Mid
			Tripod_A_Lift(intervalVertical);
			// Tripod B: High to Mid
			Tripod_B_Drop(intervalVertical);
			
			/* TODO: Send Command */
			GenerateCommand_Legs(cmd);
			sendUSART(USART2,cmd,sizeof(cmd));
}
void APOD_WaveTail(int loop, int interval)
{}
void APOD_waitingforOrder(int stype)
{}
void Apod_Squeeze_Left(int interval)
{
	char cmd[74];
	
	LEG_Drop(LEFT_FRONT,interval);
	LEG_Drop(LEFT_CENTER,interval);
	LEG_Drop(LEFT_REAR,interval);
	
	LEG_Lift(RIGHT_FRONT,interval);
	LEG_Lift(RIGHT_CENTER,interval);
	LEG_Lift(RIGHT_REAR,interval);
	
	LEG_Stand(LEFT_FRONT);
	LEG_Stand(LEFT_CENTER);
	LEG_Stand(LEFT_REAR);
	
	LEG_Stand(RIGHT_FRONT);
	LEG_Stand(RIGHT_CENTER);
	LEG_Stand(RIGHT_REAR);
	
	GenerateCommand_Legs(cmd);
	sendUSART(USART2,cmd,sizeof(cmd));
}

void Apod_Squeeze_Right(int interval)
{
	Apod_Squeeze_Left(-interval);
}

void Apod_lift(int interval)
{
	char cmd[74];
	if (Servos[5] < 2100) // 1500 + (100* 6 times)
	{
	Tripod_A_Lift(interval);
	Tripod_B_Lift(interval);
	GenerateCommand_Legs(cmd);
	sendUSART(USART2,cmd,sizeof(cmd));
	}
	else 
	{}
	
}

void Apod_Drop(int interval)
{
	char cmd[74];
	if (Servos[5] > 1000)  // 1500 - (100*5 times)
	{
	Tripod_A_Drop(interval);
	Tripod_B_Drop(interval);
	
	GenerateCommand_Legs(cmd);
	sendUSART(USART2,cmd,sizeof(cmd));
	}
}

void Apod_Balance()
{
	char cmd[74];
	int i;
	
	for (i=0; i<32; i++)
	{
		Servos[i] = 1500;
	}
	
	GenerateCommand_Legs(cmd);
	sendUSART(USART2,cmd,sizeof(cmd));
}

void Apod_towardtheFront(int interval)
{
	char cmd[74];
	int haflInterval;
	haflInterval = interval/2;
	if (Servos[1] > 900)
	{
	LEG_Lift(RIGHT_REAR, interval);
	LEG_Lift(LEFT_REAR, interval);
	LEG_Lift(RIGHT_FRONT, -interval);
	LEG_Lift(LEFT_FRONT, -interval);
	
	LEG_Stand(RIGHT_REAR);
	LEG_Stand(LEFT_REAR);
	LEG_Stand(RIGHT_FRONT);
	LEG_Stand(LEFT_FRONT);
	
	GenerateCommand_Legs(cmd);
	sendUSART(USART2,cmd,sizeof(cmd));
	}
}

void Apod_towardtheBack(int interval)
{
	char cmd[74];
	int haflInterval;
	haflInterval = interval/2;
	if (Servos[1] < 2000)
	{
	LEG_Lift(RIGHT_REAR, -interval);
	LEG_Lift(LEFT_REAR, -interval);
	LEG_Lift(RIGHT_FRONT, interval);
	LEG_Lift(LEFT_FRONT, interval);
	
	LEG_Stand(RIGHT_REAR);
	LEG_Stand(LEFT_REAR);
	LEG_Stand(RIGHT_FRONT);
	LEG_Stand(LEFT_FRONT);
	
	GenerateCommand_Legs(cmd);
	sendUSART(USART2,cmd,sizeof(cmd));
	}
}

void APod_Neck_Rotate_Left (int interval)
{
	char cmd[130];
	if (Servos[13] < 2000)
	{
	Neck_Rotate(interval);
	
	GenerateCommand_All(cmd);
	sendUSART(USART2,cmd,sizeof(cmd));
	}
}

void Apod_Neck_Rotate_Right(int interval)
{
	char cmd[130];
	if (Servos[13] > 1000)
	{
	Neck_Rotate(-interval);
	
	GenerateCommand_All(cmd);
	sendUSART(USART2,cmd,sizeof(cmd));
	}
}

void Apod_Head_Down(int interval)
{
	char cmd[130];
	if (Servos[29] < 2000)
	{
	Neck_Vertical(interval);
	
	GenerateCommand_All(cmd);
	sendUSART(USART2,cmd,sizeof(cmd));
	}
}

void Apod_Head_Up(int interval)
{
	char cmd[130];
	if (Servos[29] > 1000)
	{
		Neck_Vertical(-interval);
	
	GenerateCommand_All(cmd);
	sendUSART(USART2,cmd,sizeof(cmd));
	}
}

void Apod_Head_Left(int interval)
{
	char cmd[130];
	if (Servos[13] < 2100)
	{
	Neck_Horizontal(interval);
	
	GenerateCommand_All(cmd);
	sendUSART(USART2,cmd,sizeof(cmd));
	}
}

void Apod_Head_Right(int interval)
{
	char cmd[130];
	if (Servos[13] > 1100)
	{
	Neck_Horizontal(-interval);
	
	GenerateCommand_All(cmd);
	sendUSART(USART2,cmd,sizeof(cmd));
	}
}

void Apod_Mandible_Nip(int interval)
{
	char cmd[130];
	uint16_t i,j;
	readADC();
	Delay(8192);
	i = USART_ReceiveData(USART2);
	j = USART_ReceiveData(USART2);
	if (Servos[19] > 1300 )
	{
	MANDIBLE(MANDIBLE_LEFT,interval);
	MANDIBLE(MANDIBLE_RIGHT,interval);
	
	GenerateCommand_All(cmd);
	sendUSART(USART2,cmd,sizeof(cmd));
	}
	else {}
	USART_SendData(USART1,i);
	USART_SendData(USART1,j);
}

void Apod_Mandible_Release(int interval)
{	
	
	char cmd[130];
	uint16_t i;
	readADC();
	Delay(8192);
	i = USART_ReceiveData(USART2);
	if (Servos[19] < 1800 )
	{
	MANDIBLE(MANDIBLE_LEFT,-interval);
	MANDIBLE(MANDIBLE_RIGHT,-interval);
	
	GenerateCommand_All(cmd);
	sendUSART(USART2,cmd,sizeof(cmd));
	}
	else{}
	USART_SendData(USART1,i);
}
// ----------------------------------------
// Command generator
// ----------------------------------------
// generate command for all 32 servos: 128 bytes +2 bytes
void readADC()
{
	char cmd[2];
	cmd[0] = 'V';
	cmd[1] = 'A';
	sendUSART(USART2,cmd,2);
}

void GenerateCommand_All(char* cmd)
{
	int i =0;
	for (i=0;i<32;i++)
	{
		cmd[4*i] = '#';
		cmd[4*i+1] = i;
		cmd[4*i+2] = (Servos[i])>>8;
		cmd[4*i+3] = (Servos[i])&0xFF;
	}
	cmd[128] = 'T';
	cmd[129] = 0x02;
}
// generrate command for legs only: 72 bytes
void GenerateCommand_Legs(char* cmd)
{
	char i = 0;
	unsigned int servo;
	
	//RightFront[3] = {0,1,2};
	while(i<3) // cmd index : 0 -> 11
	{
		servo = RightFront[i];
		cmd[4*i] = '#';
		cmd[4*i+1] = servo;								// servo number
		cmd[4*i+2] = (Servos[servo])>>8;  // high byte
		cmd[4*i+3] = (Servos[servo])&0xFF;// low byte
		i++;
	}
	
	//RightCenter[3] = {4,5,6};	
	while(i<6) // cmd index : 12 -> 23
	{
		servo = RightCenter[(i%3)];
		cmd[4*i] = '#';
		cmd[4*i+1] = servo;								// servo number
		cmd[4*i+2] = (Servos[servo])>>8;  // high byte
		cmd[4*i+3] = (Servos[servo])&0xFF;// low byte
		i++;
	}
	//RightRear[3] = {8,9,10};		
	while(i<9) // cmd index : 24 -> 35
	{
		servo = RightRear[(i%3)];
		cmd[4*i] = '#';
		cmd[4*i+1] = servo;								// servo number
		cmd[4*i+2] = (Servos[servo])>>8;  // high byte
		cmd[4*i+3] = (Servos[servo])&0xFF;// low byte
		i++;
	}
	//LeftFront[3] = {16,17,18}; 
	while(i<12) // cmd index : 36 -> 47
	{
		servo = LeftFront[(i%3)];
		cmd[4*i] = '#';
		cmd[4*i+1] = servo;								// servo number
		cmd[4*i+2] = (Servos[servo])>>8;  // high byte
		cmd[4*i+3] = (Servos[servo])&0xFF;// low byte
		i++;
	}
	//LeftCenter[3] = {20,21,22};	
	while(i<15) // cmd index : 48 -> 59
	{
		servo = LeftCenter[(i%3)];
		cmd[4*i] = '#';
		cmd[4*i+1] = servo;								// servo number
		cmd[4*i+2] = (Servos[servo])>>8;  // high byte
		cmd[4*i+3] = (Servos[servo])&0xFF;// low byte
		i++;
	}
	//LeftRear[3] = {24,25,26};	
	while(i<18) // cmd index : 60 -> 72
	{
		servo = LeftRear[(i%3)];
		cmd[4*i] = '#';
		cmd[4*i+1] = servo;								// servo number
		cmd[4*i+2] = (Servos[servo])>>8;  // high byte
		cmd[4*i+3] = (Servos[servo])&0xFF;// low byte
		i++;
	}
	cmd[4*i] = 'T';
	cmd[4*i+1] = 0x02;
}



					
void ff()
{
	
	while(isStop) 
	{
		//forward_(200,100);
		Delay(500);
	}
}