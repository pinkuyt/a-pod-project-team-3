#include "A_Pod_Command.h"

void cmd_start(void)

{

   struct APod_start starts;

   int len = sizeof(struct APod_start);

   /* Make up data */

	starts.S = 83;
	starts.one = 1;

    /* Send data */

    //uart_send_buff ((uint8_t  *)&starts,  len);

}
void cmd_stop(void)

{
   struct Apod_stop stops;

   int len = sizeof(struct APod_start);

   /* Make up data */

	stops.S = 83;
	stops.zero = 0;

    /* Send data */

    //uart_send_buff ((uint8_t  *)&stops,  len);

}

