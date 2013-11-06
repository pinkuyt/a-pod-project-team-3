#include <stdio.h>
#include "Usart_Bluetooth.h"
#include "Usart.h"

#define DEFAULT_Left 1200
#define DEFAULT_Right 1800

// ----------------------------------------
// Servo value
// ----------------------------------------
extern unsigned int Servos[32];

// ----------------------------------------
// Array represent legs
// ----------------------------------------
extern unsigned int RightFront[3];	// Access index: 0
extern unsigned int RightCenter[3];	// Access index: 1
extern unsigned int RightRear[3];		// Access index: 2
extern unsigned int LeftFront[3];		// Access index: 3
extern unsigned int LeftCenter[3];	// Access index: 4
extern unsigned int LeftRear[3];		// Access index: 5

// ----------------------------------------
// Legs control
// ----------------------------------------
void LEG_Lift(char leg, int interval);
void LEG_Drop(char leg, int interval);
void LEG_Stand(char leg);
void LEG_Forward(char leg, int interval);
void LEG_Backward(char leg, int interval);
void LEG_Reset(char leg);
void LEG_Reset_All(void);

// ----------------------------------------
// Tripods Control
// ----------------------------------------
void Tripod_A_Lift(int interval);
void Tripod_A_Drop(int interval);
void Tripod_A_Forward(int interval);
void Tripod_A_Backward(int interval);
void Tripod_A_Left(int interval);
void Tripod_A_Right(int interval);

void Tripod_B_Lift(int interval);
void Tripod_B_Drop(int interval);
void Tripod_B_Forward(int interval);
void Tripod_B_Backward(int interval);
void Tripod_B_Left(int interval);
void Tripod_B_Right(int interval);

void MANDIBLE(char mandible, int interval);

void Neck_Rotate(int interval);
void Neck_Horizontal(int interval);
void Neck_Vertical(int interval);
// ----------------------------------------
// APOD Control
// ----------------------------------------
void Apod_lift(int interval);// done
void Apod_Drop(int interval);// done
void Apod_Balance(); // done
void Apod_towardtheFront(int interval);// done
void Apod_towardtheBack(int interval);// done
void Apod_Squeeze_Left(int interval);// done
void Apod_Squeeze_Right(int interval);// done
void APOD_Forward(int loop, int intervalVertical, int intervalHorizontal, int delay);// done
void APOD_Backward(int loop, int intervalVertical, int intervalHorizontal, int delay);//donw
void APOD_TurnLeft(int loop, int intervalVertical, int intervalHorizontal, int delay);//done
void APOD_TurnRight(int loop, int intervalVertical, int intervalHorizontal, int delay);//done
void APOD_WaveTail(int loop, int interval);
void APOD_waitingforOrder(int stype);

void APod_Neck_Rotate_Left(int interval);
void Apod_Neck_Rotate_Right(int interval);
void Apod_Head_Up(int interval);
void Apod_Head_Down(int interval);
void Apod_Head_Left(int interval);
void Apod_Head_Right(int interval);

void Apod_Mandible_Nip(int interval);
void Apod_Mandible_Release(int interval);

// ----------------------------------------
//	Generate Command
// ----------------------------------------
void GenerateCommand_All(char* cmd);
void GenerateCommand_Legs(char* cmd);

// ----------------------------------------
//	Step
// ----------------------------------------
void setNULL(char *string);
void readADC();



