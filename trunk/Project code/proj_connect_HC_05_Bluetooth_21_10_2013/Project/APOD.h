#include <stdio.h>

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

// ----------------------------------------
// APOD Control
// ----------------------------------------
void APOD_Forward(int loop);
