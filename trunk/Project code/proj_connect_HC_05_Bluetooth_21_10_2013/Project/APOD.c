#include "APOD.h"

const char RIGHT_FRONT = 0;
const char RIGHT_CENTER = 1;
const char RIGHT_REAR = 2;
const char LEFT_FRONT = 3;
const char LEFT_CENTER = 4;
const char LEFT_REAR = 5;

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
void APOD_Forward(int loop)
{
	char length ;
	char cmd[100];
	
	char i = 0;
	// --------------------------------
	// States	|	Tripod A	  | Tripod B
	// Init		|	Mid,Center	| Mid,Center
	// --------------------------------
	
	// --------------------------------
	// 0			|	Low,Center	| High,Center
	// --------------------------------
	
	/* TODO: Delay 500 ms */
	
	// Tripod A :  Mid to Low
	Tripod_A_Drop(100);
	// Tripod B : Mid to High
	Tripod_B_Lift(100);
	
	/* TODO: Send Command */
	
	for (i=0;i<loop;i++) 
	{
		// --------------------------------
		// 1			|	Low,Rear		| Mid,Front
		// --------------------------------
		
			/* TODO: Delay 500 ms */
			
			// Tripod A: Center to Rear
			Tripod_A_Backward(100);
			// Tripod B: Center to Front
			Tripod_B_Forward(100);
			// Tripod B: High to Mid
			Tripod_B_Drop(100);
			
			/* TODO: Send Command */
			
		// --------------------------------
		// 2			|	Low,Rear		| Low,Front
		// --------------------------------
		
			/* TODO: Delay 500 ms */
			
			// Tripod B: Mid to Low
			Tripod_B_Drop(100);
			
			/* TODO: Send Command */
			
		// --------------------------------
		// 3			|	Mid,Rear		| Low,Front
		// --------------------------------
			
			/* TODO: Delay 500 ms */
			
			// Tripod A:  Low to Mid
			Tripod_A_Lift(100);
			
			/* TODO: Send Command */
			
		// --------------------------------
		// 4			|	High,Center	| Low,Center
		// --------------------------------
			
			/* TODO: Delay 500 ms */
			
			// Tripod A: Mid to High
			Tripod_A_Lift(100);
			// Tripod A: Rear to Center
			Tripod_A_Forward(100);
			// Tripod B: Front to Center
			Tripod_B_Backward(100);
			
			/* TODO: Send Command */
			
		// --------------------------------
		// 5			|	Mid,Front		| Low,Rear
		// --------------------------------
		
			/* TODO: Delay 500 ms */
			
			// Tripod A: High to Mid
			Tripod_A_Drop(100);
			// Tripod A: Center to Front
			Tripod_A_Forward(100);
			// Tripod B: Center to Rear
			Tripod_B_Backward(100);
			
			/* TODO: Send Command */
			
		// --------------------------------
		// 6			|	Low,Front		| Low,Rear
		// --------------------------------
			
			/* TODO: Delay 500 ms */
			
			// Tripod A: Mid to Low
			Tripod_A_Drop(100);
			
			/* TODO: Send Command */
			
		// --------------------------------
		// 7			|	Low,Front		| Mid,Rear
		// --------------------------------
		
			/* TODO: Delay 500 ms */
			
			// Tripod B: Low to Mid
			Tripod_B_Lift(100);
			
			/* TODO: Send Command */
			
		// --------------------------------
		// 0			|	Low,Center	| High,Center
		// --------------------------------
		
			/* TODO: Delay 500 ms */
			
			// Tripod A: Front to Center
			Tripod_A_Backward(100);
			// Tripod B: Rear to Center
			Tripod_B_Forward(100);
			// Tripod B: Mid to High
			Tripod_B_Lift(100);
			
			/* TODO: Send Command */
	}
	
	// --------------------------------
	// End		|	Mid,Center	| Mid,Center
	// --------------------------------
	
			/* TODO: Delay 500 ms */
			
			// Tripod A: Low to Mid
			Tripod_A_Lift(100);
			// Tripod B: High to Mid
			Tripod_B_Drop(100);
			
			/* TODO: Send Command */
}



// ----------------------------------------
// Command generator
// ----------------------------------------
// generate command for all 32 servos: 128 bytes +2 bytes
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
