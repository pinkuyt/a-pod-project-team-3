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
1500,1500,1500,1500,1500,1500,1500,1500,
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
// {RotateNeck servo,Horizontal Neck servo, Verical Neck servo, Mandible}
// ----------------------------------------

unsigned int Neck[3] = {13,14,15};		
unsigned int Mandible[2] = {3,19};

// ----------------------------------------
// Mandible control
// ----------------------------------------
void MANDIBLE(char mandible, int interval)
{
	switch(mandible)
	{
		case 0: //MANDIBLE_LEFT
			Servos[Mandible[0]] -= interval;
			break;
		case 1: //MANDIBLE_RIGHT
			Servos[Mandible[1]] += interval;
			break;
	}
}

int MANDIBLE_EXPAND(void)
{
	int interval =  2000 - Servos[Mandible[1]];
	Servos[Mandible[0]] = 1000;
	Servos[Mandible[1]] = 2000;
	return interval;
}
void MANDIBLE_Reset_All(void)
{
	Servos[Mandible[0]] = DEFAULT_MANDIBLE_LEFT;
	Servos[Mandible[1]] = DEFAULT_MANDIBLE_RIGHT;
}
// ----------------------------------------
// Neck control
// ----------------------------------------
void Neck_Rotate(int interval)
{
	Servos[(Neck[0])] += interval;
}

void Neck_Horizontal(int interval)
{
	Servos[(Neck[1])] += interval;
}

void Neck_Vertical(int interval)
{
	Servos[(Neck[2])] += interval;
}
void NECK_Reset_All(void)
{
	Servos[(Neck[0])] = DEFAULT_NECK_ROTATE;
	Servos[(Neck[1])] = DEFAULT_NECK_HORIZONTAL;
	Servos[(Neck[2])] = DEFAULT_NECK_VERTICAL;
}

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
	sendUSART(USART2,stop,2);
}
// normal moves
void APOD_Forward(int loop, int intervalVertical, int intervalHorizontal, int delay)
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
// Advance moves
void APOD_Forward_Advance(int intervalVertical, int intervalHorizontal, int delay)
{
	char cmd[74];
	
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
	
	while (!b_Release)
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
void APOD_Backward_Advance(int intervalVertical, int intervalHorizontal, int delay)
{
	char cmd[74];
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
	
	while (!b_Release)
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
void APOD_TurnLeft_Advance(int intervalVertical, int intervalHorizontal, int delay)
{
	
	char cmd[74];
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
	
	while (!b_Release)
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
void APOD_TurnRight_Advance(int intervalVertical, int intervalHorizontal, int delay)
{
	char cmd[74];
	
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
	
	while (!b_Release)
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
// ------------------------------------
// BODY
// ------------------------------------
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

void Apod_Drop(int interval)
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

void Apod_lift(int interval)
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

void Apod_Balance(void)
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
	sendUSART(USART2,cmd,74);
	}
}

void Apod_towardtheBack(int interval)
{
	char cmd[74];
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
	sendUSART(USART2,cmd,74);
	}
}


// ------------------------------------ 
// HEAD
// ------------------------------------ 
void APod_Neck_Rotate_Left (int interval)
{
	char cmd[22];
	Neck_Rotate(interval);
	
	GenerateCommand_Head(cmd);
	sendUSART(USART2,cmd,22);
}

void Apod_Neck_Rotate_Right(int interval)
{
	char cmd[22];
	Neck_Rotate(-interval);
	
	GenerateCommand_Head(cmd);
	sendUSART(USART2,cmd,22);
}

void Apod_Head_Down(int interval)
{
	char cmd[22];
	Neck_Vertical(interval);
	
	GenerateCommand_Head(cmd);
	sendUSART(USART2,cmd,22);
}

void Apod_Head_Up(int interval)
{
	char cmd[22];
	Neck_Vertical(-interval);
	
	GenerateCommand_Head(cmd);
	sendUSART(USART2,cmd,22);
}

void Apod_Head_Left(int interval)
{
	char cmd[22];
	Neck_Horizontal(interval);
	
	GenerateCommand_Head(cmd);
	sendUSART(USART2,cmd,22);
}

void Apod_Head_Right(int interval)
{
	char cmd[22];
	Neck_Horizontal(-interval);
	
	GenerateCommand_Head(cmd);
	sendUSART(USART2,cmd,22);
}


// ------------------------------------
// MANDIBLES
// ------------------------------------
int Apod_Mandibles_Expand(void)
{
	char cmd[10];
	int interval;
	interval = MANDIBLE_EXPAND();
	GenerateCommand_Mandibles(cmd);
	sendUSART(USART2,cmd,sizeof(cmd));
	return interval;
}
void Apod_Mandible_Nip(int interval)
{
	char cmd[10];
	MANDIBLE(MANDIBLE_LEFT,interval);
	MANDIBLE(MANDIBLE_RIGHT,interval);
	
	GenerateCommand_Mandibles(cmd);
	sendUSART(USART2,cmd,sizeof(cmd));
}

void Apod_Mandible_Release(int interval)
{	
	Apod_Mandible_Nip(-interval);
}
// ------------------------------------
// TAILS
// ------------------------------------

// ------------------------------------
// SENSOR
// ------------------------------------
unsigned char Apod_Read_Distance(void)
{
	int i = 0;
	unsigned int d = 0;
	USART2_Clear_Buffer();
	for (i=0;i<16;i++)
	{
		USART_SendData(USART2,'D');
		while(!USART2_RX_Size);
		d +=  USART2_GetData();
	}
	d = (d>>4);
	return (d&0xFF);
}
// ----------------------------------------
// COMMAND GENERATOR
// ----------------------------------------
// Command for all 32 servos: 128 bytes + 2 bytes
void GenerateCommand_All(char* cmd)
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
	while(i<18) // cmd index : 60 -> 71
	{
		servo = LeftRear[(i%3)];
		cmd[4*i] = '#';
		cmd[4*i+1] = servo;								// servo number
		cmd[4*i+2] = (Servos[servo])>>8;  // high byte
		cmd[4*i+3] = (Servos[servo])&0xFF;// low byte
		i++;
	}
  //Mandible[2] = {3,19};
	while(i<20) // cmd index : 72 -> 79
	{
		servo = Mandible[(i%3)];
		cmd[4*i] = '#';
		cmd[4*i+1] = servo;								// servo number
		cmd[4*i+2] = (Servos[servo])>>8;  // high byte
		cmd[4*i+3] = (Servos[servo])&0xFF;// low byte
		i++;
	}
	//Neck[3] = {13,14,15};		
	while(i<23) // cmd index : 80 -> 91
	{
		servo = Neck[(i%4)];
		cmd[4*i] = '#';
		cmd[4*i+1] = servo;								// servo number
		cmd[4*i+2] = (Servos[servo])>>8;  // high byte
		cmd[4*i+3] = (Servos[servo])&0xFF;// low byte
		i++;
	}
	
	cmd[4*i] = 'T';
	cmd[4*i+1] = 0x01;
}
// Command for Head's servos only
void GenerateCommand_Head(char* cmd)
{
	int servo;
	cmd[0] = '#';
	cmd[1] = Mandible[0];
	servo = Mandible[0];
	cmd[2] = (Servos[servo])>>8;
	cmd[3] = (Servos[servo])&0xFF;
	
	cmd[4] = '#';
	cmd[5] = Mandible[1];
	servo = Mandible[1];
	cmd[6] = (Servos[servo])>>8;
	cmd[7] = (Servos[servo])&0xFF;
	
	cmd[8] = '#';
	cmd[9] = Neck[0];
	servo = Neck[0];
	cmd[10] = (Servos[servo])>>8;
	cmd[11] = (Servos[servo])&0xFF;
	
	cmd[12] = '#';
	cmd[13] = Neck[1];
	servo = Neck[1];
	cmd[14] = (Servos[servo])>>8;
	cmd[15] = (Servos[servo])&0xFF;
	
	cmd[16] = '#';
	cmd[17] = Neck[2];
	servo = Neck[2];
	cmd[18] = (Servos[servo])>>8;
	cmd[19] = (Servos[servo])&0xFF;
	
	cmd[20] = 'T';
	cmd[21] = 0x01;
}

// Command for Mandibles's servos only
void GenerateCommand_Mandibles(char* cmd)
{
	int servo;
	cmd[0] = '#';
	cmd[1] = Mandible[0];
	servo = Servos[(Mandible[0])];
	cmd[2] = servo>>8;
	cmd[3] = servo&0xFF;
	
	cmd[4] = '#';
	cmd[5] = Mandible[1];
	servo = Servos[(Mandible[1])];
	cmd[6] = servo>>8;
	cmd[7] = servo&0xFF;
	
	cmd[8] = 'T';
	cmd[9] = 0x01;
}
// Command for Neck's servos only
void GenerateCommand_Neck(char* cmd)
{
	int servo;
	cmd[0] = '#';
	cmd[1] = Neck[0];
	servo = (Neck[0]);
	cmd[2] = (Servos[servo])>>8;
	cmd[3] = (Servos[servo])&0xFF;
	
	cmd[4] = '#';
	cmd[5] = Neck[1];
	servo = (Neck[1]);
	cmd[6] = (Servos[servo])>>8;
	cmd[7] = (Servos[servo])&0xFF;
	
	cmd[8] = '#';
	cmd[9] = Neck[2];
	servo = (Neck[2]);
	cmd[10] = (Servos[servo])>>8;
	cmd[11] = (Servos[servo])&0xFF;
	
	cmd[12] = 'T';
	cmd[13] = 0x01;
}
// Command for Legs's servos only
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
	while(i<18) // cmd index : 60 -> 71
	{
		servo = LeftRear[(i%3)];
		cmd[4*i] = '#';
		cmd[4*i+1] = servo;								// servo number
		cmd[4*i+2] = (Servos[servo])>>8;  // high byte
		cmd[4*i+3] = (Servos[servo])&0xFF;// low byte
		i++;
	}
	cmd[4*i] = 'T';
	cmd[4*i+1] = 0x01;
}
// ----------------------------------------
// AUTO SECTION
// ----------------------------------------
void APOD_Grip(void) 
{
	int count = 0;
	uint16_t d = Apod_Read_Distance();
	int interval;
	interval = Apod_Mandibles_Expand();
	while ((d>4) && (count<15))
	{
		APOD_Forward(1,120,60,3000000);
	  d = Apod_Read_Distance();
		count++;
	}
	Apod_Mandible_Nip(interval);
}
