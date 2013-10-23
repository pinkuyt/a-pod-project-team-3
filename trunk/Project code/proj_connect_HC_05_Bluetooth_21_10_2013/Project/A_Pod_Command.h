#include "stm32f4xx.h"
#include "stm32f4xx_usart.h"
#include "A_Pod_define.h"
#include "Usart.h"
#include <stdio.h>
#include <string.h>

//Command
struct APod_start
{
	uint8_t S;
	uint8_t one;
};
struct Apod_stop
{
	uint8_t S;
	uint8_t zero;
};
struct Execute_T
{
	uint8_t T;
};
struct PulseSign_P
{
	uint8_t P;
};


//Pulse
struct Pusle_1200
{
	uint8_t P_h;
	uint8_t P_l;
};
struct Pusle_1300
{
	uint8_t P_h;
	uint8_t P_l;
};
struct Pusle_1500
{
	uint8_t P_h;
	uint8_t P_l;
};
struct Pusle_1700
{
	uint8_t P_h;
	uint8_t P_l;
};
struct Pusle_1800
{
	uint8_t P_h;
	uint8_t P_l;
};

//left horizontal
struct Leg_left_1_1
{
	uint8_t Sharp;
	uint8_t servo;
};
struct Leg_left_2_1
{
	uint8_t Sharp;
	uint8_t servo;
};
struct Leg_left_3_1
{
	uint8_t Sharp;
	uint8_t servo;
};
struct Leg_right_1_1
{
	uint8_t Sharp;
	uint8_t servo;
};
struct Leg_right_2_1
{
	uint8_t Sharp;
	uint8_t servo;
};
struct Leg_right_3_1
{
	uint8_t Sharp;
	uint8_t servo;
};
//leg 1 vertical
struct Leg_left_1_2
{
	uint8_t Sharp;
	uint8_t servo;
};
struct Leg_left_2_2
{
	uint8_t Sharp;
	uint8_t servo;
};
struct Leg_left_3_2
{
	uint8_t Sharp;
	uint8_t servo;
};
struct Leg_right_1_2
{
	uint8_t Sharp;
	uint8_t servo;
};
struct Leg_right_2_2
{
	uint8_t Sharp;
	uint8_t servo;
};
struct Leg_right_3_2
{
	uint8_t Sharp;
	uint8_t servo;
};
//leg 2 vertical
struct Leg_left_1_3
{
	uint8_t Sharp;
	uint8_t servo;
};
struct Leg_left_2_3
{
	uint8_t Sharp;
	uint8_t servo;
};
struct Leg_left_3_3
{
	uint8_t Sharp;
	uint8_t servo;
};
struct Leg_right_1_3
{
	uint8_t Sharp;
	uint8_t servo;
};
struct Leg_right_2_3
{
	uint8_t Sharp;
	uint8_t servo;
};
struct Leg_right_3_3
{
	uint8_t Sharp;
	uint8_t servo;
};


void cmd_start(void);
void cmd_stop(void);
