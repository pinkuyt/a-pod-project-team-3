;--- set P0 = Trigger Pin
;--- set P1 = Echo Pin
P_trig CON P0
P_echo CON P1

;--- set Variables
time VAR word
distance VAR word
range VAR word
value VAR word

;--- set Serial Baud rate
sethserial1 h9600

;--- Main program
Main
	;--- Active Trigger Pin	
	pulsout P_trig, 20
	;--- Active Echo Pin, store Duration value in variable "time"
	pulsin P_echo,0 ,time
	
	;--- Distance = time * 340 (m/s) /2 ( double distance ) / 2 (BMS store value in 0.5 microsecond increment)
	distance = time/2/58	
	;--- set default range for Alert Sound
	range = 30
	
	Serout s_out,i9600,["Range : ", DEC distance,13]	
	
	;---Sound active when distance < range (30)
	;if distance < range then
	;---Pin 9 = Onboard Speaker Pin
	;freqout P9, 1000, 3000
	;endif		
	
	;---- Sending data through TXD/RXD. Pin 15 = TX, PIN 14 = RX
	;---- Data are converter into ASCII code 
	;if distance < 10 then
	;	hserout [48, 48, DEC distance]
	;elseif distance < 100
	;	hserout [48, DEC distance]
	;else
	;	hserout [DEC distance]
	;endif
	
	pause 1000
	
	;//Addition : Analog Receive function 
	;ADIN P3, value
	;serout s_out,i9600,["Analog Value : ",DEC value,13]
	;pause 500
	;// End of function	
Goto Main
	
	
