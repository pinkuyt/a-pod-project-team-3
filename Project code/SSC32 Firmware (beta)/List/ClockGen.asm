
;CodeVisionAVR C Compiler V2.03.4 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 14.745600 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : Yes
;char is unsigned       : Yes
;global const stored in FLASH  : No
;8 bit enums            : Yes
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	LDI  R23,BYTE4(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+@1,R0
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index0=R3
	.DEF _rx_rd_index0=R5
	.DEF _rx_counter0=R7
	.DEF _tx_wr_index0=R9
	.DEF _tx_rd_index0=R11
	.DEF _tx_counter0=R13

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  _timer1_compb_isr
	JMP  0x00
	JMP  _timer0_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  _spi_isr
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GPIOR0 INITIALIZATION
	.EQU  __GPIOR0_INIT=0x00

_0x40003:
	.DB  0x1,0x2,0x3,0x4,0x5,0x7,0x6,0x0
	.DB  0x8,0x9,0xA,0xB,0xC,0xD,0xE,0xF
	.DB  0x17,0x16,0x15,0x14,0x13,0x12,0x11,0x10
	.DB  0x18,0x1F,0x1E,0x1D,0x1C,0x1B,0x1A,0x19
_0x40004:
	.DB  0x1D

__GLOBAL_INI_TBL:
	.DW  0x20
	.DW  _Servo
	.DW  _0x40003*2

	.DW  0x01
	.DW  _delay
	.DW  _0x40004*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x800)
	LDI  R25,HIGH(0x800)
	LDI  R26,LOW(0x100)
	LDI  R27,HIGH(0x100)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x8FF)
	OUT  SPL,R30
	LDI  R30,HIGH(0x8FF)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x300)
	LDI  R29,HIGH(0x300)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.03.4 Standard
;Automatic Program Generator
;� Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 9/6/2013
;Author  :
;Company :
;Comments:
;
;
;Chip type           : ATmega328P
;Program type        : Application
;Clock frequency     : 14.745600 MHz
;Memory model        : Small
;External RAM size   : 0
;Data Stack size     : 512
;*****************************************************/
;
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include <delay.h>
;#include "SSC32.h"
;#include "PulseWidth.h"
;#include "Utilities.h"
;
;//*********************************************************************
;// USART interrupt service routine
;//*********************************************************************
;
;#define RXB8 1
;#define TXB8 0
;#define UPE 2
;#define OVR 3
;#define FE 4
;#define UDRE 5
;#define RXC 7
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<OVR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE0 256
;char rx_buffer0[RX_BUFFER_SIZE0];
;
;#if RX_BUFFER_SIZE0<256
;unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
;#else
;unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 003F {

	.CSEG
_usart_rx_isr:
	CALL SUBOPT_0x0
; 0000 0040 char status,data;
; 0000 0041 status=UCSR0A;
;	status -> R17
;	data -> R16
	LDS  R17,192
; 0000 0042 data=UDR0;
	LDS  R16,198
; 0000 0043 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	CALL SUBOPT_0x1
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BRNE _0x3
; 0000 0044    {
; 0000 0045    rx_buffer0[rx_wr_index0]=data;
	__GETW1R 3,4
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 0046    if (++rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	__GETW1R 3,4
	ADIW R30,1
	__PUTW1R 3,4
	CPI  R30,LOW(0x100)
	LDI  R26,HIGH(0x100)
	CPC  R31,R26
	BRNE _0x4
	CLR  R3
	CLR  R4
; 0000 0047    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x4:
	__GETW1R 7,8
	ADIW R30,1
	__PUTW1R 7,8
	CPI  R30,LOW(0x100)
	LDI  R26,HIGH(0x100)
	CPC  R31,R26
	BRNE _0x5
; 0000 0048       {
; 0000 0049       rx_counter0=0;
	CLR  R7
	CLR  R8
; 0000 004A       rx_buffer_overflow0=1;
	SBI  0x1E,0
; 0000 004B       };
_0x5:
; 0000 004C    };
_0x3:
; 0000 004D }
	RJMP _0x73
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0054 {
_getchar:
; 0000 0055 char data;
; 0000 0056 while (rx_counter0==0);
	ST   -Y,R17
;	data -> R17
_0x8:
	MOV  R0,R7
	OR   R0,R8
	BREQ _0x8
; 0000 0057 data=rx_buffer0[rx_rd_index0];
	LDI  R26,LOW(_rx_buffer0)
	LDI  R27,HIGH(_rx_buffer0)
	ADD  R26,R5
	ADC  R27,R6
	LD   R17,X
; 0000 0058 if (++rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
	__GETW1R 5,6
	ADIW R30,1
	__PUTW1R 5,6
	CPI  R30,LOW(0x100)
	LDI  R26,HIGH(0x100)
	CPC  R31,R26
	BRNE _0xB
	CLR  R5
	CLR  R6
; 0000 0059 #asm("cli")
_0xB:
	cli
; 0000 005A --rx_counter0;
	__GETW1R 7,8
	SBIW R30,1
	__PUTW1R 7,8
; 0000 005B #asm("sei")
	sei
; 0000 005C return data;
	MOV  R30,R17
	JMP  _0x2060003
; 0000 005D }
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE0 256
;char tx_buffer0[TX_BUFFER_SIZE0];
;
;#if TX_BUFFER_SIZE0<256
;unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;
;#else
;unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 006D {
_usart_tx_isr:
	ST   -Y,R0
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 006E if (tx_counter0)
	MOV  R0,R13
	OR   R0,R14
	BREQ _0xC
; 0000 006F    {
; 0000 0070    --tx_counter0;
	__GETW1R 13,14
	SBIW R30,1
	__PUTW1R 13,14
; 0000 0071    UDR0=tx_buffer0[tx_rd_index0];
	LDI  R26,LOW(_tx_buffer0)
	LDI  R27,HIGH(_tx_buffer0)
	ADD  R26,R11
	ADC  R27,R12
	LD   R30,X
	STS  198,R30
; 0000 0072    if (++tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	__GETW1R 11,12
	ADIW R30,1
	__PUTW1R 11,12
	CPI  R30,LOW(0x100)
	LDI  R26,HIGH(0x100)
	CPC  R31,R26
	BRNE _0xD
	CLR  R11
	CLR  R12
; 0000 0073    };
_0xD:
_0xC:
; 0000 0074 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R0,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 007B {
; 0000 007C while (tx_counter0 == TX_BUFFER_SIZE0);
;	c -> Y+0
; 0000 007D #asm("cli")
; 0000 007E if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
; 0000 007F    {
; 0000 0080    tx_buffer0[tx_wr_index0]=c;
; 0000 0081    if (++tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
; 0000 0082    ++tx_counter0;
; 0000 0083    }
; 0000 0084 else
; 0000 0085    UDR0=c;
; 0000 0086 #asm("sei")
; 0000 0087 }
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;bit b_exec;
;//*********************************************************************
;// Timer 0 interrupt service routine
;//*********************************************************************
;
;// Timer 0 output compare A interrupt service routine
;interrupt [TIM0_COMPA] void timer0_compa_isr(void)
; 0000 0094 {
_timer0_compa_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0095     Delay_Count++;
	LDS  R30,_Delay_Count
	SUBI R30,-LOW(1)
	STS  _Delay_Count,R30
; 0000 0096     TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0097 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;//*********************************************************************
;// Timer 1 interrupt service routine
;//*********************************************************************
;
;// Timer 1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 009E {
_timer1_compa_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 009F int i =0;
; 0000 00A0 /* A03 */
; 0000 00A1 // Output edge data
; 0000 00A2 SPDR= PW_SPI_B0[Edges_Ctr]; //while(!(SPSR>>7));
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 00A3 i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
; 0000 00A4 PORTB.1 = 1;PORTB.1 = 0;// pulse bank 0
; 0000 00A5 SPDR= PW_SPI_B1[Edges_Ctr];  //while(!(SPSR>>7));
	CALL SUBOPT_0x2
	CALL SUBOPT_0x4
; 0000 00A6 i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
; 0000 00A7 PORTB.2 = 1;PORTB.2 = 0;// pulse bank 1
; 0000 00A8 SPDR= PW_SPI_B2[Edges_Ctr];  //while(!(SPSR>>7));
	CALL SUBOPT_0x2
	CALL SUBOPT_0x5
; 0000 00A9 i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
; 0000 00AA PORTD.6 = 1;PORTD.6 = 0;// pulse bank 2
; 0000 00AB SPDR= PW_SPI_B3[Edges_Ctr];  //while(!(SPSR>>7));
	CALL SUBOPT_0x2
	CALL SUBOPT_0x6
; 0000 00AC i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
; 0000 00AD PORTD.7 = 1;PORTD.7 = 0;// pulse bank 3
; 0000 00AE /* A15 */
; 0000 00AF 
; 0000 00B0 b_exec = 0;
	CBI  0x1E,1
; 0000 00B1 // reset counter
; 0000 00B2 TCNT1H=0x00;
	LDI  R30,LOW(0)
	STS  133,R30
; 0000 00B3 TCNT1L=0x00;
	STS  132,R30
; 0000 00B4 
; 0000 00B5 /*Take less than 1 timer clocks*/
; 0000 00B6 }
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;// Timer 1 output compare B interrupt service routine
;interrupt [TIM1_COMPB] void timer1_compb_isr(void)
; 0000 00BA {
_timer1_compb_isr:
	CALL SUBOPT_0x0
; 0000 00BB int i =0;
; 0000 00BC /* AD1 */
; 0000 00BD // Output edge data
; 0000 00BE SPDR= PW_SPI_B0[Edges_Ptr]; //while(!(SPSR>>7));
;	i -> R16,R17
	__GETWRN 16,17,0
	CALL SUBOPT_0x7
	CALL SUBOPT_0x3
; 0000 00BF i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
; 0000 00C0 PORTB.1 = 1;PORTB.1 = 0;// pulse bank 0
; 0000 00C1 SPDR= PW_SPI_B1[Edges_Ptr];  //while(!(SPSR>>7));
	CALL SUBOPT_0x7
	CALL SUBOPT_0x4
; 0000 00C2 i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
; 0000 00C3 PORTB.2 = 1;PORTB.2 = 0;// pulse bank 1
; 0000 00C4 SPDR= PW_SPI_B2[Edges_Ptr];  //while(!(SPSR>>7));
	CALL SUBOPT_0x7
	CALL SUBOPT_0x5
; 0000 00C5 i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
; 0000 00C6 PORTD.6 = 1;PORTD.6 = 0;// pulse bank 2
; 0000 00C7 SPDR= PW_SPI_B3[Edges_Ptr];  //while(!(SPSR>>7));
	CALL SUBOPT_0x7
	CALL SUBOPT_0x6
; 0000 00C8 i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
; 0000 00C9 PORTD.7 = 1;PORTD.7 = 0;// pulse bank 3
; 0000 00CA /* AEA */
; 0000 00CB // update pointer
; 0000 00CC Edges_Ptr ++;
	LDS  R30,_Edges_Ptr
	SUBI R30,-LOW(1)
	STS  _Edges_Ptr,R30
; 0000 00CD if (Edges_Ptr == Edges_Ctr)
	LDS  R30,_Edges_Ctr
	LDS  R26,_Edges_Ptr
	CP   R30,R26
	BRNE _0x38
; 0000 00CE {
; 0000 00CF     b_exec = 1;
	SBI  0x1E,1
; 0000 00D0     Edges_Ptr = 0;
	LDI  R30,LOW(0)
	STS  _Edges_Ptr,R30
; 0000 00D1 }
; 0000 00D2 // set next edge
; 0000 00D3 OCR1BH = PW_Time[Edges_Ptr]>>8;
_0x38:
	CALL SUBOPT_0x8
	MOV  R30,R31
	LDI  R31,0
	STS  139,R30
; 0000 00D4 OCR1BL = PW_Time[Edges_Ptr]&0xFF;
	CALL SUBOPT_0x8
	STS  138,R30
; 0000 00D5 /*Take 105 timer clocks*/
; 0000 00D6 }
_0x73:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;//*********************************************************************
;// SPI interrupt service routine
;//*********************************************************************
;
;// SPI interrupt service routine
;interrupt [SPI_STC] void spi_isr(void)
; 0000 00DE {
_spi_isr:
; 0000 00DF unsigned char data;
; 0000 00E0 data=SPDR;
	ST   -Y,R17
;	data -> R17
	IN   R17,46
; 0000 00E1 // Place your code here
; 0000 00E2 
; 0000 00E3 }
	LD   R17,Y+
	RETI
;//*********************************************************************
;// Global variables.
;//*********************************************************************
;bit b_move;
;bit b_step;
;
;unsigned char cmd;
;unsigned char CMD_Pattern[3];
;unsigned char CMD_Count;
;unsigned char CMD_Channel[32];
;unsigned int  CMD_Time[32];
;
;// counting step of each command
;unsigned char SP_Steps[32];
;// moving direction of each command
;unsigned char SP_Dir[32];
;
;unsigned char i,j;
;unsigned char channel,tmp;
;
;void main(void)
; 0000 00F9 {
_main:
; 0000 00FA // Declare your local variables here
; 0000 00FB CMD_Count = 0;
	LDI  R30,LOW(0)
	STS  _CMD_Count,R30
; 0000 00FC b_move = 0;
	CBI  0x1E,2
; 0000 00FD b_step = 0;
	CBI  0x1E,3
; 0000 00FE b_exec = 0;
	CBI  0x1E,1
; 0000 00FF 
; 0000 0100 SSC32_Init();
	RCALL _SSC32_Init
; 0000 0101 PW_Init();
	CALL _PW_Init
; 0000 0102 //PW_Start();
; 0000 0103 
; 0000 0104 while (1)
_0x41:
; 0000 0105     {
; 0000 0106         // waiting for command
; 0000 0107         cmd = getchar();
	CALL SUBOPT_0x9
; 0000 0108         // process command
; 0000 0109         switch (cmd)
	LDI  R31,0
; 0000 010A         {
; 0000 010B             case 'S':
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BRNE _0x47
; 0000 010C                 /* on(1)/off(0) command  */
; 0000 010D                 cmd = getchar();
	CALL SUBOPT_0x9
; 0000 010E                 if (cmd)
	CPI  R30,0
	BREQ _0x48
; 0000 010F                 {
; 0000 0110                     PW_Start();
	CALL _PW_Start
; 0000 0111                 }
; 0000 0112                 else
	RJMP _0x49
_0x48:
; 0000 0113                 {
; 0000 0114                     PW_Stop();
	CALL _PW_Stop
; 0000 0115                 }
_0x49:
; 0000 0116                 break;
	RJMP _0x46
; 0000 0117             case '#':
_0x47:
	CPI  R30,LOW(0x23)
	LDI  R26,HIGH(0x23)
	CPC  R31,R26
	BRNE _0x4A
; 0000 0118                 /* moving command */
; 0000 0119                 PORTD ^= 0x04;
	IN   R30,0xB
	LDI  R31,0
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	EOR  R30,R26
	EOR  R31,R27
	OUT  0xB,R30
; 0000 011A                 CMD_Pattern[0] = getchar();
	RCALL _getchar
	STS  _CMD_Pattern,R30
; 0000 011B                 CMD_Pattern[1] = getchar();
	RCALL _getchar
	__PUTB1MN _CMD_Pattern,1
; 0000 011C                 CMD_Pattern[2] = getchar();
	RCALL _getchar
	__PUTB1MN _CMD_Pattern,2
; 0000 011D 
; 0000 011E                 CMD_Channel[CMD_Count]= Servo[CMD_Pattern[0]];
	LDS  R26,_CMD_Count
	LDI  R27,0
	SUBI R26,LOW(-_CMD_Channel)
	SBCI R27,HIGH(-_CMD_Channel)
	LDS  R30,_CMD_Pattern
	LDI  R31,0
	SUBI R30,LOW(-_Servo)
	SBCI R31,HIGH(-_Servo)
	LD   R30,Z
	ST   X,R30
; 0000 011F                 CMD_Time[CMD_Count]= CMD_Pattern[2]+(CMD_Pattern[1]<<8);
	LDS  R30,_CMD_Count
	CALL SUBOPT_0xA
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	__GETB2MN _CMD_Pattern,2
	CLR  R27
	__GETBRMN 31,_CMD_Pattern,1
	LDI  R30,LOW(0)
	ADD  R30,R26
	ADC  R31,R27
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 0120 
; 0000 0121                 CMD_Count++;
	LDS  R30,_CMD_Count
	SUBI R30,-LOW(1)
	STS  _CMD_Count,R30
; 0000 0122                 break;
	RJMP _0x46
; 0000 0123             case 0x21:
_0x4A:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0x4B
; 0000 0124                 /* execute command */
; 0000 0125                 b_move = 1;
	SBI  0x1E,2
; 0000 0126                 break;
	RJMP _0x46
; 0000 0127             case 0x22:
_0x4B:
	CPI  R30,LOW(0x22)
	LDI  R26,HIGH(0x22)
	CPC  R31,R26
	BRNE _0x51
; 0000 0128                 /* execute with timing command */
; 0000 0129                 b_step = 1;
	SBI  0x1E,3
; 0000 012A                 break;
; 0000 012B             default:
_0x51:
; 0000 012C                 break;
; 0000 012D         }
_0x46:
; 0000 012E         // start moving
; 0000 012F         if (b_move)
	SBIS 0x1E,2
	RJMP _0x52
; 0000 0130         {
; 0000 0131             for (i =0;i< CMD_Count; i++)
	LDI  R30,LOW(0)
	STS  _i,R30
_0x54:
	LDS  R30,_CMD_Count
	LDS  R26,_i
	CP   R26,R30
	BRSH _0x55
; 0000 0132             {
; 0000 0133                 PW_Set(CMD_Channel[i],CMD_Time[i], i);
	CALL SUBOPT_0xB
	ST   -Y,R30
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_i
	ST   -Y,R30
	CALL _PW_Set
; 0000 0134             }
	CALL SUBOPT_0xE
	RJMP _0x54
_0x55:
; 0000 0135             //PW_Set_Serial(CMD_Channel,CMD_Time, CMD_Count);
; 0000 0136             while(!b_exec);
_0x56:
	SBIS 0x1E,1
	RJMP _0x56
; 0000 0137             PW_Update_SPI();
	CALL _PW_Update_SPI
; 0000 0138 
; 0000 0139             //reset command counter
; 0000 013A             CMD_Count = 0;
	LDI  R30,LOW(0)
	STS  _CMD_Count,R30
; 0000 013B             //reset state bit
; 0000 013C             b_move = 0;
	CBI  0x1E,2
; 0000 013D             b_exec = 0;
	CBI  0x1E,1
; 0000 013E         }
; 0000 013F         // stepping mode
; 0000 0140         if (b_step)
_0x52:
	SBIS 0x1E,3
	RJMP _0x5D
; 0000 0141         {
; 0000 0142             // calculate steps needed
; 0000 0143             for (i=0;i<CMD_Count;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
_0x5F:
	LDS  R30,_CMD_Count
	LDS  R26,_i
	CP   R26,R30
	BRSH _0x60
; 0000 0144             {
; 0000 0145                 channel = CMD_Channel[i];
	CALL SUBOPT_0xB
	CALL SUBOPT_0xF
; 0000 0146                 // backward
; 0000 0147                 if (SV_Width[channel] > CMD_Time[i])
	CALL SUBOPT_0x10
	CALL SUBOPT_0xD
	CP   R30,R0
	CPC  R31,R1
	BRSH _0x61
; 0000 0148                 {
; 0000 0149                     SP_Steps[i] = (SV_Width[channel] - CMD_Time[i])/50;
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_SP_Steps)
	SBCI R31,HIGH(-_SP_Steps)
	MOVW R22,R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x10
	CALL SUBOPT_0xD
	CALL SUBOPT_0x13
; 0000 014A                     SP_Dir[i] = 0;
	SUBI R30,LOW(-_SP_Dir)
	SBCI R31,HIGH(-_SP_Dir)
	LDI  R26,LOW(0)
	RJMP _0x72
; 0000 014B                 }
; 0000 014C                 else //forward: (SV_Width[channel] < CMD_Time[i])
_0x61:
; 0000 014D                 {
; 0000 014E                     SP_Steps[i] = (CMD_Time[i] - SV_Width[channel])/50;
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_SP_Steps)
	SBCI R31,HIGH(-_SP_Steps)
	MOVW R22,R30
	CALL SUBOPT_0xC
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X+
	LD   R1,X
	CALL SUBOPT_0x12
	CALL SUBOPT_0xD
	CALL SUBOPT_0x13
; 0000 014F                     SP_Dir[i] = 1;
	SUBI R30,LOW(-_SP_Dir)
	SBCI R31,HIGH(-_SP_Dir)
	LDI  R26,LOW(1)
_0x72:
	STD  Z+0,R26
; 0000 0150                 }
; 0000 0151             }
	CALL SUBOPT_0xE
	RJMP _0x5F
_0x60:
; 0000 0152             tmp = Max(SP_Steps,CMD_Count);
	LDI  R30,LOW(_SP_Steps)
	LDI  R31,HIGH(_SP_Steps)
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_CMD_Count
	ST   -Y,R30
	CALL _Max
	STS  _tmp,R30
; 0000 0153             for (i=0;i<tmp;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
_0x64:
	LDS  R30,_tmp
	LDS  R26,_i
	CP   R26,R30
	BRLO PC+3
	JMP _0x65
; 0000 0154             {
; 0000 0155                 for (j=0;j<CMD_Count;j++)
	LDI  R30,LOW(0)
	STS  _j,R30
_0x67:
	LDS  R30,_CMD_Count
	LDS  R26,_j
	CP   R26,R30
	BRLO PC+3
	JMP _0x68
; 0000 0156                 {
; 0000 0157                     if (SP_Steps[j]>0)
	CALL SUBOPT_0x14
	SUBI R30,LOW(-_SP_Steps)
	SBCI R31,HIGH(-_SP_Steps)
	LD   R30,Z
	CPI  R30,LOW(0x1)
	BRLO _0x69
; 0000 0158                     {
; 0000 0159                         SP_Steps[j]--;
	LDS  R26,_j
	LDI  R27,0
	SUBI R26,LOW(-_SP_Steps)
	SBCI R27,HIGH(-_SP_Steps)
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
; 0000 015A                         channel = CMD_Channel[j];
	CALL SUBOPT_0x14
	SUBI R30,LOW(-_CMD_Channel)
	SBCI R31,HIGH(-_CMD_Channel)
	LD   R30,Z
	CALL SUBOPT_0xF
; 0000 015B                         SV_Width[channel] +=  SP_Dir[j]*100 -50;
	ADD  R30,R26
	ADC  R31,R27
	MOVW R24,R30
	LD   R22,Z
	LDD  R23,Z+1
	CALL SUBOPT_0x14
	SUBI R30,LOW(-_SP_Dir)
	SBCI R31,HIGH(-_SP_Dir)
	CALL SUBOPT_0x15
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12
	SBIW R30,50
	ADD  R30,R22
	ADC  R31,R23
	MOVW R26,R24
	ST   X+,R30
	ST   X,R31
; 0000 015C                         PW_Set(channel,SV_Width[channel],j);
	LDS  R30,_channel
	ST   -Y,R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0xD
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_j
	ST   -Y,R30
	CALL _PW_Set
; 0000 015D                     }
; 0000 015E                 }
_0x69:
	LDS  R30,_j
	SUBI R30,-LOW(1)
	STS  _j,R30
	RJMP _0x67
_0x68:
; 0000 015F 
; 0000 0160                 while(!b_exec);
_0x6A:
	SBIS 0x1E,1
	RJMP _0x6A
; 0000 0161                 PW_Update_SPI();
	CALL _PW_Update_SPI
; 0000 0162                 b_exec = 0;
	CBI  0x1E,1
; 0000 0163 
; 0000 0164                 Delay_10ms(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _Delay_10ms
; 0000 0165             }
	CALL SUBOPT_0xE
	RJMP _0x64
_0x65:
; 0000 0166             // reset command counter
; 0000 0167             CMD_Count = 0;
	LDI  R30,LOW(0)
	STS  _CMD_Count,R30
; 0000 0168             // reset state bit
; 0000 0169             b_step = 0;
	CBI  0x1E,3
; 0000 016A         }
; 0000 016B     };
_0x5D:
	RJMP _0x41
; 0000 016C }
_0x71:
	RJMP _0x71
;
;
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include "SSC32.h"
;
;void SSC32_Init()
; 0001 0005 {

	.CSEG
_SSC32_Init:
; 0001 0006 // Crystal Oscillator division factor: 1
; 0001 0007 #pragma optsize-
; 0001 0008 CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0001 0009 CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0001 000A #ifdef _OPTIMIZE_SIZE_
; 0001 000B #pragma optsize+
; 0001 000C #endif
; 0001 000D 
; 0001 000E // Input/Output Ports initialization
; 0001 000F // Port B initialization
; 0001 0010 // Func7=In Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=In
; 0001 0011 // State7=T State6=T State5=0 State4=0 State3=0 State2=0 State1=0 State0=T
; 0001 0012 PORTB=0x00;
	OUT  0x5,R30
; 0001 0013 DDRB=0x3E;
	LDI  R30,LOW(62)
	OUT  0x4,R30
; 0001 0014 
; 0001 0015 // Port C initialization
; 0001 0016 // Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0001 0017 // State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0001 0018 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0001 0019 DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x7,R30
; 0001 001A 
; 0001 001B // Port D initialization
; 0001 001C // Func7=Out Func6=Out Func5=In Func4=In Func3=In Func2=Out Func1=In Func0=In
; 0001 001D // State7=0 State6=0 State5=T State4=T State3=T State2=0 State1=T State0=T
; 0001 001E PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0001 001F DDRD=0xC4;
	LDI  R30,LOW(196)
	OUT  0xA,R30
; 0001 0020 
; 0001 0021 // Timer/Counter 0 initialization
; 0001 0022 // Clock source: 14400
; 0001 0023 // Clock value: Timer 0 Stopped
; 0001 0024 // Mode: Normal top=FFh
; 0001 0025 // OC0A output: Disconnected
; 0001 0026 // OC0B output: Disconnected
; 0001 0027 TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0001 0028 // current clock: stop(0x00)
; 0001 0029 TCCR0B=0x00;
	OUT  0x25,R30
; 0001 002A TCNT0=0x00;
	OUT  0x26,R30
; 0001 002B // 144 = 10ms (at clock: 14400 Hz)
; 0001 002C OCR0A=0x90;
	LDI  R30,LOW(144)
	OUT  0x27,R30
; 0001 002D OCR0B=0x00;
	LDI  R30,LOW(0)
	OUT  0x28,R30
; 0001 002E 
; 0001 002F // Timer/Counter 1 initialization
; 0001 0030 // Clock source: System Clock
; 0001 0031 // Clock value: 1843.200 kHz
; 0001 0032 // Mode: Normal top=FFFFh
; 0001 0033 // OC1A output: Discon.
; 0001 0034 // OC1B output: Discon.
; 0001 0035 // Noise Canceler: Off
; 0001 0036 // Input Capture on Falling Edge
; 0001 0037 // Timer 1 Overflow Interrupt: Off
; 0001 0038 // Input Capture Interrupt: Off
; 0001 0039 // Compare A Match Interrupt: On
; 0001 003A // Compare B Match Interrupt: On
; 0001 003B 
; 0001 003C // timer 1 stop
; 0001 003D TCCR1A=0x00;
	STS  128,R30
; 0001 003E TCCR1B=0x00;
	STS  129,R30
; 0001 003F TCCR1C=0x00;
	STS  130,R30
; 0001 0040 //TCCR1A=0x00;
; 0001 0041 //TCCR1B=0x02;
; 0001 0042 
; 0001 0043 
; 0001 0044 ICR1H=0x00;
	STS  135,R30
; 0001 0045 ICR1L=0x00;
	STS  134,R30
; 0001 0046 // 20ms
; 0001 0047 OCR1AH=0x90;
	LDI  R30,LOW(144)
	STS  137,R30
; 0001 0048 OCR1AL=0x00;
	LDI  R30,LOW(0)
	STS  136,R30
; 0001 0049 // 1.5ms
; 0001 004A OCR1BH=0x0A;
	LDI  R30,LOW(10)
	STS  139,R30
; 0001 004B OCR1BL=0xCD;
	LDI  R30,LOW(205)
	STS  138,R30
; 0001 004C 
; 0001 004D // Timer/Counter 2 initialization
; 0001 004E // Clock source: System Clock
; 0001 004F // Clock value: Timer 2 Stopped
; 0001 0050 // Mode: Normal top=FFh
; 0001 0051 // OC2A output: Disconnected
; 0001 0052 // OC2B output: Disconnected
; 0001 0053 ASSR=0x00;
	LDI  R30,LOW(0)
	STS  182,R30
; 0001 0054 TCCR2A=0x00;
	STS  176,R30
; 0001 0055 TCCR2B=0x00;
	STS  177,R30
; 0001 0056 TCNT2=0x00;
	STS  178,R30
; 0001 0057 OCR2A=0x00;
	STS  179,R30
; 0001 0058 OCR2B=0x00;
	STS  180,R30
; 0001 0059 
; 0001 005A // External Interrupt(s) initialization
; 0001 005B // INT0: Off
; 0001 005C // INT1: Off
; 0001 005D // Interrupt on any change on pins PCINT0-7: Off
; 0001 005E // Interrupt on any change on pins PCINT8-14: Off
; 0001 005F // Interrupt on any change on pins PCINT16-23: Off
; 0001 0060 EICRA=0x00;
	STS  105,R30
; 0001 0061 EIMSK=0x00;
	OUT  0x1D,R30
; 0001 0062 PCICR=0x00;
	STS  104,R30
; 0001 0063 
; 0001 0064 // Timer/Counter 0 Interrupt(s) initialization (compare A)
; 0001 0065 TIMSK0=0x02;
	LDI  R30,LOW(2)
	STS  110,R30
; 0001 0066 // Timer/Counter 1 Interrupt(s) initialization (compare A + compare B)
; 0001 0067 TIMSK1=0x06;
	LDI  R30,LOW(6)
	STS  111,R30
; 0001 0068 // Timer/Counter 2 Interrupt(s) initialization
; 0001 0069 TIMSK2=0x00;
	LDI  R30,LOW(0)
	STS  112,R30
; 0001 006A 
; 0001 006B // USART initialization
; 0001 006C // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0001 006D // USART Receiver: On
; 0001 006E // USART Transmitter: On
; 0001 006F // USART0 Mode: Asynchronous
; 0001 0070 // USART Baud Rate: 9600
; 0001 0071 UCSR0A=0x00;
	STS  192,R30
; 0001 0072 UCSR0B=0xD8;
	LDI  R30,LOW(216)
	STS  193,R30
; 0001 0073 UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0001 0074 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0001 0075 UBRR0L=0x5F;
	LDI  R30,LOW(95)
	STS  196,R30
; 0001 0076 
; 0001 0077 // Analog Comparator initialization
; 0001 0078 // Analog Comparator: Off
; 0001 0079 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0001 007A ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0001 007B ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0001 007C 
; 0001 007D // SPI initialization
; 0001 007E // SPI Type: Master
; 0001 007F // SPI Clock Rate: 2*3686.400 kHz
; 0001 0080 // SPI Clock Phase: Cycle Half
; 0001 0081 // SPI Clock Polarity: Low
; 0001 0082 // SPI Data Order: MSB First
; 0001 0083 SPCR=0x50;
	LDI  R30,LOW(80)
	OUT  0x2C,R30
; 0001 0084 SPSR=0x01;
	LDI  R30,LOW(1)
	OUT  0x2D,R30
; 0001 0085 
; 0001 0086 // Clear the SPI interrupt flag
; 0001 0087 #asm
; 0001 0088     in   r30,spsr
    in   r30,spsr
; 0001 0089     in   r30,spdr
    in   r30,spdr
; 0001 008A #endasm
; 0001 008B 
; 0001 008C // Global enable interrupts
; 0001 008D #asm("sei")
	sei
; 0001 008E 
; 0001 008F }
	RET
;
;void DebugLong(long var)
; 0001 0092 {
; 0001 0093     TCCR1B=0x00;
;	var -> Y+0
; 0001 0094     SPDR = var&0xFF;while(!(SPSR>>7));
; 0001 0095     BANK0_RCK = 1;BANK0_RCK = 0;
; 0001 0096     SPDR = var>>8;while(!(SPSR>>7));
; 0001 0097     BANK1_RCK = 1;BANK1_RCK = 0;
; 0001 0098     SPDR = var>>16;while(!(SPSR>>7));
; 0001 0099     BANK2_RCK = 1;BANK2_RCK = 0;
; 0001 009A     SPDR = var>>24;while(!(SPSR>>7));
; 0001 009B     BANK3_RCK = 1;BANK3_RCK = 0;
; 0001 009C 
; 0001 009D     while(1);
; 0001 009E }
;void DebugInt(int var)
; 0001 00A0 {
; 0001 00A1     TCCR1B=0x00;
;	var -> Y+0
; 0001 00A2     SPDR = var&0xFF;while(!(SPSR>>7));
; 0001 00A3     BANK0_RCK = 1;BANK0_RCK = 0;
; 0001 00A4     SPDR = var>>8;while(!(SPSR>>7));
; 0001 00A5     BANK1_RCK = 1;BANK1_RCK = 0;
; 0001 00A6 
; 0001 00A7     while(1);
; 0001 00A8 }
;void DebugChar(char var)
; 0001 00AA {
; 0001 00AB     TCCR1B=0x00;
;	var -> Y+0
; 0001 00AC     SPDR = var&0xFF;while(!(SPSR>>7));
; 0001 00AD     BANK0_RCK = 1;BANK0_RCK = 0;
; 0001 00AE 
; 0001 00AF     while(1);
; 0001 00B0 }
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include "SSC32.h"
;#include "PulseWidth.h"
;//*********************************************************************
;// Global variables.                                                 **
;//*********************************************************************
;// mapping servo number with output channel
;unsigned const char Servo[32] = {1,2,3,4,5,7,6,0,
;                                8,9,10,11,12,13,14,15,
;                                23,22,21,20,19,18,17,16,
;                                24,31,30,29,28,27,26,25};

	.DSEG
;// Array contain SPI output for each bank at each edge: 1 edge = 4 bank;
;unsigned char PW_SPI_B0[33];
;unsigned char PW_SPI_B1[33];
;unsigned char PW_SPI_B2[33];
;unsigned char PW_SPI_B3[33];
;
;// number of pulse edges
;unsigned char Edges_Ctr;
;// pointer to current edge
;unsigned char Edges_Ptr;
;
;//  8 bits indicate which servo to pulse in each edge: 1- active 0- inactive
;//  Channel | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | ... | 30 | 31 |
;unsigned long int PW_Mask[32];
;// array contain pulse width value in ascending order (counter): edges index
;unsigned int PW_Time[32];
;// array contain pulse width value in ascending order (us) : edges index
;unsigned int PW_Width[32];
;// array contain pulse width value in ascending order (us) : servo index
;unsigned int SV_Width[32];
;unsigned char delay = 29;
;unsigned char ctr;
;
;//*********************************************************************
;// Pulse width control routine                                       **
;//*********************************************************************
;//*********************************************************************
;// Initiate array
;//*********************************************************************
;void PW_Init()
; 0002 002A {

	.CSEG
_PW_Init:
; 0002 002B     int i;
; 0002 002C     // All channel: 1500 us= 2764 timer clock
; 0002 002D     // 2764 timer clock
; 0002 002E     PW_Time[0] = 2764-delay;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	CALL SUBOPT_0x16
	LDI  R26,LOW(2764)
	LDI  R27,HIGH(2764)
	SUB  R26,R30
	SBC  R27,R31
	STS  _PW_Time,R26
	STS  _PW_Time+1,R27
; 0002 002F     PW_Mask[0]  = 0xFFFFFFFF;
	__GETD1N 0xFFFFFFFF
	STS  _PW_Mask,R30
	STS  _PW_Mask+1,R31
	STS  _PW_Mask+2,R22
	STS  _PW_Mask+3,R23
; 0002 0030     PW_Width[0] = 1500;
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
	STS  _PW_Width,R30
	STS  _PW_Width+1,R31
; 0002 0031     // 1500 us
; 0002 0032     for (i=0;i<32;i++)
	__GETWRN 16,17,0
_0x40006:
	__CPWRN 16,17,32
	BRGE _0x40007
; 0002 0033     {
; 0002 0034         SV_Width[i] = 1500;
	MOVW R30,R16
	LDI  R26,LOW(_SV_Width)
	LDI  R27,HIGH(_SV_Width)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
	ST   X+,R30
	ST   X,R31
; 0002 0035     }
	__ADDWRN 16,17,1
	RJMP _0x40006
_0x40007:
; 0002 0036     // 1 edge
; 0002 0037     Edges_Ptr = 0;
	LDI  R30,LOW(0)
	STS  _Edges_Ptr,R30
; 0002 0038     Edges_Ctr = 1;
	LDI  R30,LOW(1)
	STS  _Edges_Ctr,R30
; 0002 0039 
; 0002 003A     // SPI at initial edge
; 0002 003B     PW_SPI_B0[0] = 0; PW_SPI_B2[0] = 0;
	LDI  R30,LOW(0)
	STS  _PW_SPI_B0,R30
	STS  _PW_SPI_B2,R30
; 0002 003C     PW_SPI_B1[0] = 0; PW_SPI_B3[0] = 0;
	STS  _PW_SPI_B1,R30
	STS  _PW_SPI_B3,R30
; 0002 003D     // SPI at 20ms tick
; 0002 003E     PW_SPI_B0[1] = 0xFF; PW_SPI_B2[1] = 0xFF;
	LDI  R30,LOW(255)
	__PUTB1MN _PW_SPI_B0,1
	__PUTB1MN _PW_SPI_B2,1
; 0002 003F     PW_SPI_B1[1] = 0xFF; PW_SPI_B3[1] = 0xFF;
	__PUTB1MN _PW_SPI_B1,1
	__PUTB1MN _PW_SPI_B3,1
; 0002 0040 
; 0002 0041 
; 0002 0042 
; 0002 0043 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;//*********************************************************************
;// Start sending signal: servo on
;//*********************************************************************
;void PW_Start()
; 0002 0048 {
_PW_Start:
; 0002 0049     OCR1BH = PW_Time[0]>>8;
	CALL SUBOPT_0x17
; 0002 004A     OCR1BL = PW_Time[0]&0xFF;
; 0002 004B     TCCR1B=0x02;
; 0002 004C }
	RET
;//*********************************************************************
;// Stop sending signal : servo off
;//*********************************************************************
;void PW_Stop()
; 0002 0051 {
_PW_Stop:
; 0002 0052     // stop clock
; 0002 0053     TCCR1B=0x00;
	LDI  R30,LOW(0)
	STS  129,R30
; 0002 0054     // send out put 0 all bank
; 0002 0055     SPDR= 0;
	OUT  0x2E,R30
; 0002 0056     while(!(SPSR>>7));
_0x40008:
	IN   R30,0x2D
	LDI  R31,0
	CALL __ASRW3
	CALL __ASRW4
	SBIW R30,0
	BREQ _0x40008
; 0002 0057     PORTB.1 = 1;PORTB.1 = 0;// pulse bank 0
	SBI  0x5,1
	CBI  0x5,1
; 0002 0058     PORTB.2 = 1;PORTB.2 = 0;// pulse bank 1
	SBI  0x5,2
	CBI  0x5,2
; 0002 0059     PORTD.6 = 1;PORTD.6 = 0;// pulse bank 2
	SBI  0xB,6
	CBI  0xB,6
; 0002 005A     PORTD.7 = 1;PORTD.7 = 0;// pulse bank 3
	SBI  0xB,7
	CBI  0xB,7
; 0002 005B }
	RET
;//*********************************************************************
;//  Update SPI output
;//*********************************************************************
;void PW_Update_SPI()
; 0002 0060 {
_PW_Update_SPI:
; 0002 0061     char i;
; 0002 0062     // PW_Stop
; 0002 0063     // stop clock
; 0002 0064     TCCR1B=0x00;
	ST   -Y,R17
;	i -> R17
	LDI  R30,LOW(0)
	STS  129,R30
; 0002 0065     // send out put 0 all bank
; 0002 0066 //    SPDR= 0;
; 0002 0067 //    while(!(SPSR>>7));
; 0002 0068 //    PORTB.1 = 1;PORTB.1 = 0;// pulse bank 0
; 0002 0069 //    PORTB.2 = 1;PORTB.2 = 0;// pulse bank 1
; 0002 006A //    PORTD.6 = 1;PORTD.6 = 0;// pulse bank 2
; 0002 006B //    PORTD.7 = 1;PORTD.7 = 0;// pulse bank 3
; 0002 006C 
; 0002 006D     Edges_Ctr = ctr;
	LDS  R30,_ctr
	STS  _Edges_Ctr,R30
; 0002 006E     PW_SPI_B0[Edges_Ctr] = 0xFF; PW_SPI_B2[Edges_Ctr] = 0xFF;
	CALL SUBOPT_0x2
	SUBI R30,LOW(-_PW_SPI_B0)
	SBCI R31,HIGH(-_PW_SPI_B0)
	CALL SUBOPT_0x18
	SUBI R30,LOW(-_PW_SPI_B2)
	SBCI R31,HIGH(-_PW_SPI_B2)
	CALL SUBOPT_0x18
; 0002 006F     PW_SPI_B1[Edges_Ctr] = 0xFF; PW_SPI_B3[Edges_Ctr] = 0xFF;
	SUBI R30,LOW(-_PW_SPI_B1)
	SBCI R31,HIGH(-_PW_SPI_B1)
	CALL SUBOPT_0x18
	SUBI R30,LOW(-_PW_SPI_B3)
	SBCI R31,HIGH(-_PW_SPI_B3)
	CALL SUBOPT_0x18
; 0002 0070 
; 0002 0071     PW_SPI_B0[0] =  PW_SPI_B0[Edges_Ctr]^PW_Mask[0]>>0;
	SUBI R30,LOW(-_PW_SPI_B0)
	SBCI R31,HIGH(-_PW_SPI_B0)
	CALL SUBOPT_0x15
	MOVW R26,R30
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	STS  _PW_SPI_B0,R30
; 0002 0072     PW_SPI_B1[0] =  PW_SPI_B1[Edges_Ctr]^PW_Mask[0]>>8;
	CALL SUBOPT_0x2
	SUBI R30,LOW(-_PW_SPI_B1)
	SBCI R31,HIGH(-_PW_SPI_B1)
	CALL SUBOPT_0x15
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1B
	LDI  R30,LOW(8)
	CALL __LSRD12
	POP  R26
	POP  R27
	CALL SUBOPT_0x1A
	STS  _PW_SPI_B1,R30
; 0002 0073     PW_SPI_B2[0] =  PW_SPI_B2[Edges_Ctr]^PW_Mask[0]>>16;
	CALL SUBOPT_0x2
	SUBI R30,LOW(-_PW_SPI_B2)
	SBCI R31,HIGH(-_PW_SPI_B2)
	CALL SUBOPT_0x15
	MOVW R26,R30
	CALL SUBOPT_0x19
	CALL __LSRD16
	CALL SUBOPT_0x1A
	STS  _PW_SPI_B2,R30
; 0002 0074     PW_SPI_B3[0] =  PW_SPI_B3[Edges_Ctr]^PW_Mask[0]>>24;
	CALL SUBOPT_0x2
	SUBI R30,LOW(-_PW_SPI_B3)
	SBCI R31,HIGH(-_PW_SPI_B3)
	CALL SUBOPT_0x15
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1B
	LDI  R30,LOW(24)
	CALL __LSRD12
	POP  R26
	POP  R27
	CALL SUBOPT_0x1A
	STS  _PW_SPI_B3,R30
; 0002 0075     PW_Time[0] =  1.8432f * (float)PW_Width[0] - delay;
	LDS  R30,_PW_Width
	LDS  R31,_PW_Width+1
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	LDI  R26,LOW(_PW_Time)
	LDI  R27,HIGH(_PW_Time)
	CALL __CFD1U
	ST   X+,R30
	ST   X,R31
; 0002 0076 
; 0002 0077     for (i=1;i<(Edges_Ctr);i++)
	LDI  R17,LOW(1)
_0x4001C:
	LDS  R30,_Edges_Ctr
	CP   R17,R30
	BRLO PC+3
	JMP _0x4001D
; 0002 0078     {
; 0002 0079         PW_SPI_B0[i] =  PW_SPI_B0[i-1]^PW_Mask[i]>>0;
	CALL SUBOPT_0x1F
	SUBI R30,LOW(-_PW_SPI_B0)
	SBCI R31,HIGH(-_PW_SPI_B0)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1
	CALL SUBOPT_0x20
	SUBI R30,LOW(-_PW_SPI_B0)
	SBCI R31,HIGH(-_PW_SPI_B0)
	CALL SUBOPT_0x21
	MOVW R26,R0
	CALL SUBOPT_0x1A
	POP  R26
	POP  R27
	ST   X,R30
; 0002 007A         PW_SPI_B1[i] =  PW_SPI_B1[i-1]^PW_Mask[i]>>8;
	CALL SUBOPT_0x1F
	SUBI R30,LOW(-_PW_SPI_B1)
	SBCI R31,HIGH(-_PW_SPI_B1)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1
	CALL SUBOPT_0x20
	SUBI R30,LOW(-_PW_SPI_B1)
	SBCI R31,HIGH(-_PW_SPI_B1)
	CALL SUBOPT_0x15
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x22
	LDI  R30,LOW(8)
	CALL __LSRD12
	POP  R26
	POP  R27
	CALL SUBOPT_0x1A
	POP  R26
	POP  R27
	ST   X,R30
; 0002 007B         PW_SPI_B2[i] =  PW_SPI_B2[i-1]^PW_Mask[i]>>16;
	CALL SUBOPT_0x1F
	SUBI R30,LOW(-_PW_SPI_B2)
	SBCI R31,HIGH(-_PW_SPI_B2)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1
	CALL SUBOPT_0x20
	SUBI R30,LOW(-_PW_SPI_B2)
	SBCI R31,HIGH(-_PW_SPI_B2)
	CALL SUBOPT_0x21
	CALL __LSRD16
	MOVW R26,R0
	CALL SUBOPT_0x1A
	POP  R26
	POP  R27
	ST   X,R30
; 0002 007C         PW_SPI_B3[i] =  PW_SPI_B3[i-1]^PW_Mask[i]>>24;
	CALL SUBOPT_0x1F
	SUBI R30,LOW(-_PW_SPI_B3)
	SBCI R31,HIGH(-_PW_SPI_B3)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1
	CALL SUBOPT_0x20
	SUBI R30,LOW(-_PW_SPI_B3)
	SBCI R31,HIGH(-_PW_SPI_B3)
	CALL SUBOPT_0x15
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x22
	LDI  R30,LOW(24)
	CALL __LSRD12
	POP  R26
	POP  R27
	CALL SUBOPT_0x1A
	POP  R26
	POP  R27
	ST   X,R30
; 0002 007D         PW_Time[i] =  1.8432f * (float)PW_Width[i] - delay;
	MOV  R30,R17
	LDI  R26,LOW(_PW_Time)
	LDI  R27,HIGH(_PW_Time)
	CALL SUBOPT_0x23
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOV  R30,R17
	CALL SUBOPT_0x24
	CALL SUBOPT_0xD
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	POP  R26
	POP  R27
	CALL __CFD1U
	ST   X+,R30
	ST   X,R31
; 0002 007E     }
	SUBI R17,-1
	RJMP _0x4001C
_0x4001D:
; 0002 007F 
; 0002 0080     // PW_Start
; 0002 0081     OCR1BH = PW_Time[0]>>8;
	CALL SUBOPT_0x17
; 0002 0082     OCR1BL = PW_Time[0]&0xFF;
; 0002 0083     TCCR1B=0x02;
; 0002 0084 }
_0x2060003:
	LD   R17,Y+
	RET
;//*********************************************************************
;//  Set new edge value
;//*********************************************************************
;void PW_Set(char channel, int width, char extend)
; 0002 0089 {
_PW_Set:
; 0002 008A     char i,j ;
; 0002 008B     char pos ;
; 0002 008C     ctr = Edges_Ctr + extend;
	CALL __SAVELOCR4
;	channel -> Y+7
;	width -> Y+5
;	extend -> Y+4
;	i -> R17
;	j -> R16
;	pos -> R19
	LDS  R26,_Edges_Ctr
	CLR  R27
	LDD  R30,Y+4
	LDI  R31,0
	ADD  R30,R26
	STS  _ctr,R30
; 0002 008D     SV_Width[channel] = width;
	LDD  R30,Y+7
	LDI  R26,LOW(_SV_Width)
	LDI  R27,HIGH(_SV_Width)
	CALL SUBOPT_0x23
	CALL SUBOPT_0x25
; 0002 008E     // clear old mask for this channel
; 0002 008F     i = 0;
	LDI  R17,LOW(0)
; 0002 0090     while (i < ctr)
_0x4001E:
	LDS  R30,_ctr
	CP   R17,R30
	BRLO PC+3
	JMP _0x40020
; 0002 0091     {
; 0002 0092         // clear old mask
; 0002 0093         PW_Mask[i] &= 0xFFFFFFFF^(1<<(long)channel);
	CALL SUBOPT_0x26
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x27
	__GETD2N 0xFFFFFFFF
	CALL __XORD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ANDD12
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0002 0094         // edge unused
; 0002 0095         if (PW_Mask[i] == 0)
	CALL SUBOPT_0x26
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	CALL __CPD10
	BRNE _0x40021
; 0002 0096         {
; 0002 0097             // push array to the left
; 0002 0098             for(j=i;j<ctr;j++)
	MOV  R16,R17
_0x40023:
	LDS  R30,_ctr
	CP   R16,R30
	BRSH _0x40024
; 0002 0099             {
; 0002 009A                 PW_Mask[j] = PW_Mask[j+1];
	MOV  R30,R16
	CALL SUBOPT_0x28
	MOVW R0,R30
	MOV  R26,R16
	CLR  R27
	CALL __MULW2_4
	__ADDW2MN _PW_Mask,4
	CALL __GETD1P
	MOVW R26,R0
	CALL __PUTDP1
; 0002 009B                 PW_Width[j] = PW_Width[j+1];
	MOV  R30,R16
	CALL SUBOPT_0x24
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R26,R16
	CLR  R27
	LSL  R26
	ROL  R27
	__ADDW2MN _PW_Width,2
	CALL __GETW1P
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0002 009C             }
	SUBI R16,-1
	RJMP _0x40023
_0x40024:
; 0002 009D             // update counter
; 0002 009E             ctr--;
	LDS  R30,_ctr
	SUBI R30,LOW(1)
	STS  _ctr,R30
; 0002 009F         }
; 0002 00A0         else
	RJMP _0x40025
_0x40021:
; 0002 00A1         {
; 0002 00A2             i++;
	SUBI R17,-1
; 0002 00A3         }
_0x40025:
; 0002 00A4     }
	RJMP _0x4001E
_0x40020:
; 0002 00A5     // get position to insert
; 0002 00A6     pos = 0;
	LDI  R19,LOW(0)
; 0002 00A7     while (pos < ctr)
_0x40026:
	LDS  R30,_ctr
	CP   R19,R30
	BRLO PC+3
	JMP _0x40028
; 0002 00A8     {
; 0002 00A9         // duplicated edge
; 0002 00AA         if (width == PW_Width[pos])
	MOV  R30,R19
	CALL SUBOPT_0x24
	CALL SUBOPT_0xD
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x40029
; 0002 00AB         {
; 0002 00AC             PW_Mask[pos] |= 1<<(long)channel;
	MOV  R30,R19
	CALL SUBOPT_0x28
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x27
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ORD12
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0002 00AD             return;
	RJMP _0x2060002
; 0002 00AE         }
; 0002 00AF         // new edge less than max time
; 0002 00B0         if (width < PW_Width[pos])
_0x40029:
	MOV  R30,R19
	CALL SUBOPT_0x24
	CALL SUBOPT_0xD
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x4002A
; 0002 00B1         {
; 0002 00B2             // push time array to the right
; 0002 00B3             for (i= ctr;i>pos;i--)
	LDS  R17,_ctr
_0x4002C:
	CP   R19,R17
	BRSH _0x4002D
; 0002 00B4             {
; 0002 00B5                 PW_Width[i] = PW_Width[i-1];
	MOV  R30,R17
	CALL SUBOPT_0x24
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0x1
	CALL SUBOPT_0x20
	LDI  R26,LOW(_PW_Width)
	LDI  R27,HIGH(_PW_Width)
	LSL  R30
	ROL  R31
	CALL SUBOPT_0xD
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
; 0002 00B6                 PW_Mask[i] = PW_Mask[i-1];
	CALL SUBOPT_0x26
	ADD  R30,R26
	ADC  R31,R27
	MOVW R24,R30
	CALL SUBOPT_0x1
	CALL SUBOPT_0x20
	LDI  R26,LOW(_PW_Mask)
	LDI  R27,HIGH(_PW_Mask)
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	MOVW R26,R24
	CALL __PUTDP1
; 0002 00B7             }
	SUBI R17,1
	RJMP _0x4002C
_0x4002D:
; 0002 00B8             // set value at new edge
; 0002 00B9             PW_Width[pos] = width;
	MOV  R30,R19
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
; 0002 00BA             PW_Mask[pos] = 1<<(long)channel;
	MOV  R30,R19
	RJMP _0x2060001
; 0002 00BB             // update counter
; 0002 00BC             ctr++;
; 0002 00BD             return;
; 0002 00BE         }
; 0002 00BF 
; 0002 00C0         pos++;
_0x4002A:
	SUBI R19,-1
; 0002 00C1     }
	RJMP _0x40026
_0x40028:
; 0002 00C2     // new max time edge
; 0002 00C3     // set value at new edge
; 0002 00C4     PW_Width[ctr] = width;
	LDS  R30,_ctr
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
; 0002 00C5     PW_Mask[ctr] = 1<<(long)channel;
	LDS  R30,_ctr
_0x2060001:
	LDI  R26,LOW(_PW_Mask)
	LDI  R27,HIGH(_PW_Mask)
	LDI  R31,0
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x27
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0002 00C6     // update counter
; 0002 00C7     ctr++;
	LDS  R30,_ctr
	SUBI R30,-LOW(1)
	STS  _ctr,R30
; 0002 00C8 }
_0x2060002:
	CALL __LOADLOCR4
	ADIW R28,8
	RET
;//*********************************************************************
;//  Set serial of new edges values
;//*********************************************************************
;void PW_Set_Serial(char* channel, int* width,char length)
; 0002 00CD {
; 0002 00CE     char i,j,k;
; 0002 00CF     char pos;
; 0002 00D0     // marking channel position to clear mask
; 0002 00D1     long cleanMark=0;
; 0002 00D2     // get current counter
; 0002 00D3     ctr = Edges_Ctr;
;	*channel -> Y+11
;	*width -> Y+9
;	length -> Y+8
;	i -> R17
;	j -> R16
;	k -> R19
;	pos -> R18
;	cleanMark -> Y+4
; 0002 00D4     // update width
; 0002 00D5     for (i=0;i<length;i++)
; 0002 00D6     {
; 0002 00D7         SV_Width[channel[i]] = width[i];
; 0002 00D8         cleanMark |= (1<<(long)(channel[i]));
; 0002 00D9     }
; 0002 00DA     // clear old mask for these channels
; 0002 00DB     i = 0;
; 0002 00DC     while (i < ctr)
; 0002 00DD     {
; 0002 00DE         // clear old mask
; 0002 00DF         PW_Mask[i] &= 0xFFFFFFFF^cleanMark;
; 0002 00E0         // edge unused
; 0002 00E1         if (PW_Mask[i] == 0)
; 0002 00E2         {
; 0002 00E3             // push array to the left
; 0002 00E4             for(j=i;j<ctr;j++)
; 0002 00E5             {
; 0002 00E6                 PW_Mask[j] = PW_Mask[j+1];
; 0002 00E7                 PW_Width[j] = PW_Width[j+1];
; 0002 00E8             }
; 0002 00E9             // update counter
; 0002 00EA             ctr--;
; 0002 00EB         }
; 0002 00EC         else
; 0002 00ED         {
; 0002 00EE             i++;
; 0002 00EF         }
; 0002 00F0     }
; 0002 00F1     for (k=0; k< length;k++)
; 0002 00F2     {
; 0002 00F3         // update new counter
; 0002 00F4         ctr += k;
; 0002 00F5         // get position to insert
; 0002 00F6         pos = 0;
; 0002 00F7         while (pos < ctr)
; 0002 00F8         {
; 0002 00F9             // duplicated edge
; 0002 00FA             if (width[k] == PW_Width[pos])
; 0002 00FB             {
; 0002 00FC                 PW_Mask[pos] |= 1<<(long)channel[k];
; 0002 00FD                 return;
; 0002 00FE             }
; 0002 00FF             // new edge less than max time
; 0002 0100             if (width[k] < PW_Width[pos])
; 0002 0101             {
; 0002 0102                 // push time array to the right
; 0002 0103                 for (i= ctr;i>pos;i--)
; 0002 0104                 {
; 0002 0105                     PW_Width[i] = PW_Width[i-1];
; 0002 0106                     PW_Mask[i] = PW_Mask[i-1];
; 0002 0107                 }
; 0002 0108                 // set value at new edge
; 0002 0109                 PW_Width[pos] = width[k];
; 0002 010A                 PW_Mask[pos] = 1<<(long)channel[k];
; 0002 010B                 // update counter
; 0002 010C                 ctr++;
; 0002 010D                 return;
; 0002 010E             }
; 0002 010F 
; 0002 0110             pos++;
; 0002 0111         }
; 0002 0112         // new max time edge
; 0002 0113         // set value at new edge
; 0002 0114         PW_Width[ctr] = width[k];
; 0002 0115         PW_Mask[ctr] = 1<<(long)channel[k];
; 0002 0116         // update counter
; 0002 0117         ctr++;
; 0002 0118     }
; 0002 0119 }
;
;
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include "SSC32.h"
;#include "Utilities.h"
;
;unsigned char Delay_Count;
;
;char Max(char* arr,char length)
; 0003 0008 {

	.CSEG
_Max:
; 0003 0009     char i, max = arr[0];
; 0003 000A     for (i=0;i<length;i++)
	ST   -Y,R17
	ST   -Y,R16
;	*arr -> Y+3
;	length -> Y+2
;	i -> R17
;	max -> R16
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X
	MOV  R16,R30
	LDI  R17,LOW(0)
_0x60004:
	LDD  R30,Y+2
	CP   R17,R30
	BRSH _0x60005
; 0003 000B     {
; 0003 000C         if (max < arr[i])
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CP   R16,R30
	BRSH _0x60006
; 0003 000D         {
; 0003 000E             max = arr[i];
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R16,X
; 0003 000F         }
; 0003 0010     }
_0x60006:
	SUBI R17,-1
	RJMP _0x60004
_0x60005:
; 0003 0011     return max;
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; 0003 0012 }
;// Delay Time = 10 x time (ms)
;void Delay_10ms(char time)
; 0003 0015 {
_Delay_10ms:
; 0003 0016     Delay_Count = 0;
;	time -> Y+0
	LDI  R30,LOW(0)
	STS  _Delay_Count,R30
; 0003 0017     TCCR0B=0x05;
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0003 0018     while (Delay_Count<time);
_0x60007:
	LD   R30,Y
	LDS  R26,_Delay_Count
	CP   R26,R30
	BRLO _0x60007
; 0003 0019     TCCR0B=0x00;
	LDI  R30,LOW(0)
	OUT  0x25,R30
; 0003 001A     TCNT0=0x00;
	OUT  0x26,R30
; 0003 001B }
	ADIW R28,1
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_Servo:
	.BYTE 0x20
_PW_SPI_B0:
	.BYTE 0x21
_PW_SPI_B1:
	.BYTE 0x21
_PW_SPI_B2:
	.BYTE 0x21
_PW_SPI_B3:
	.BYTE 0x21
_Edges_Ctr:
	.BYTE 0x1
_Edges_Ptr:
	.BYTE 0x1
_PW_Mask:
	.BYTE 0x80
_PW_Time:
	.BYTE 0x40
_PW_Width:
	.BYTE 0x40
_SV_Width:
	.BYTE 0x40
_Delay_Count:
	.BYTE 0x1
_rx_buffer0:
	.BYTE 0x100
_tx_buffer0:
	.BYTE 0x100
_cmd:
	.BYTE 0x1
_CMD_Pattern:
	.BYTE 0x3
_CMD_Count:
	.BYTE 0x1
_CMD_Channel:
	.BYTE 0x20
_CMD_Time:
	.BYTE 0x40
_SP_Steps:
	.BYTE 0x20
_SP_Dir:
	.BYTE 0x20
_i:
	.BYTE 0x1
_j:
	.BYTE 0x1
_channel:
	.BYTE 0x1
_tmp:
	.BYTE 0x1
_delay:
	.BYTE 0x1
_ctr:
	.BYTE 0x1
_p_S1020024:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	MOV  R26,R17
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x2:
	LDS  R30,_Edges_Ctr
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3:
	SUBI R30,LOW(-_PW_SPI_B0)
	SBCI R31,HIGH(-_PW_SPI_B0)
	LD   R30,Z
	OUT  0x2E,R30
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	SBI  0x5,1
	CBI  0x5,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x4:
	SUBI R30,LOW(-_PW_SPI_B1)
	SBCI R31,HIGH(-_PW_SPI_B1)
	LD   R30,Z
	OUT  0x2E,R30
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	SBI  0x5,2
	CBI  0x5,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x5:
	SUBI R30,LOW(-_PW_SPI_B2)
	SBCI R31,HIGH(-_PW_SPI_B2)
	LD   R30,Z
	OUT  0x2E,R30
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	SBI  0xB,6
	CBI  0xB,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x6:
	SUBI R30,LOW(-_PW_SPI_B3)
	SBCI R31,HIGH(-_PW_SPI_B3)
	LD   R30,Z
	OUT  0x2E,R30
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	__ADDWRN 16,17,1
	SBI  0xB,7
	CBI  0xB,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	LDS  R30,_Edges_Ptr
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x8:
	LDS  R30,_Edges_Ptr
	LDI  R26,LOW(_PW_Time)
	LDI  R27,HIGH(_PW_Time)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CALL _getchar
	STS  _cmd,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(_CMD_Time)
	LDI  R27,HIGH(_CMD_Time)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDS  R30,_i
	LDI  R31,0
	SUBI R30,LOW(-_CMD_Channel)
	SBCI R31,HIGH(-_CMD_Channel)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDS  R30,_i
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xD:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDS  R30,_i
	SUBI R30,-LOW(1)
	STS  _i,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	STS  _channel,R30
	LDI  R26,LOW(_SV_Width)
	LDI  R27,HIGH(_SV_Width)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X+
	LD   R1,X
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x11:
	LDS  R30,_i
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x12:
	LDS  R30,_channel
	LDI  R26,LOW(_SV_Width)
	LDI  R27,HIGH(_SV_Width)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	MOVW R26,R0
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL __DIVW21U
	MOVW R26,R22
	ST   X,R30
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDS  R30,_j
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
	LD   R30,Z
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDS  R30,_delay
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x17:
	LDS  R30,_PW_Time+1
	STS  139,R30
	LDS  R30,_PW_Time
	LDS  R31,_PW_Time+1
	STS  138,R30
	LDI  R30,LOW(2)
	STS  129,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(255)
	STD  Z+0,R26
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	LDS  R30,_PW_Mask
	LDS  R31,_PW_Mask+1
	LDS  R22,_PW_Mask+2
	LDS  R23,_PW_Mask+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1A:
	CALL __CWD2
	CALL __XORD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	LDS  R26,_PW_Mask
	LDS  R27,_PW_Mask+1
	LDS  R24,_PW_Mask+2
	LDS  R25,_PW_Mask+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1D:
	__GETD2N 0x3FEBEDFA
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	RCALL SUBOPT_0x1C
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x21:
	LD   R0,Z
	CLR  R1
	MOV  R30,R17
	LDI  R26,LOW(_PW_Mask)
	LDI  R27,HIGH(_PW_Mask)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x22:
	MOV  R30,R17
	LDI  R26,LOW(_PW_Mask)
	LDI  R27,HIGH(_PW_Mask)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x23:
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x24:
	LDI  R26,LOW(_PW_Width)
	LDI  R27,HIGH(_PW_Width)
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x25:
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x26:
	MOV  R30,R17
	LDI  R26,LOW(_PW_Mask)
	LDI  R27,HIGH(_PW_Mask)
	LDI  R31,0
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x27:
	LDD  R30,Y+7
	LDI  R31,0
	CALL __CWD1
	__GETD2N 0x1
	CALL __LSLD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x28:
	LDI  R26,LOW(_PW_Mask)
	LDI  R27,HIGH(_PW_Mask)
	LDI  R31,0
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET


	.CSEG
__ANDD12:
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	RET

__ORD12:
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	RET

__XORD12:
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__LSRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSRD12R
__LSRD12L:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRD12L
__LSRD12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__LSRD16:
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	RET

__MULW2_4:
	LSL  R26
	ROL  R27
	LSL  R26
	ROL  R27
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF129
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
