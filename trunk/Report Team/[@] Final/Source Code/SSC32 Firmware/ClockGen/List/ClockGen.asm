
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
	JMP  _pin_change_isr1
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
	.DB  0xE

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
;© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : Servo Controller Firmware
;Version : 1.1
;Date    : 9/6/2013
;Author  : Phan Anh Dung Cuong
;Company : Capstone Project Team 3
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
	ST   -Y,R17
	ST   -Y,R16
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
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x72
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
_putchar:
; 0000 007C while (tx_counter0 == TX_BUFFER_SIZE0);
;	c -> Y+0
_0xE:
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	CP   R30,R13
	CPC  R31,R14
	BREQ _0xE
; 0000 007D #asm("cli")
	cli
; 0000 007E if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	MOV  R0,R13
	OR   R0,R14
	BRNE _0x12
	LDS  R30,192
	LDI  R31,0
	ANDI R30,LOW(0x20)
	BRNE _0x11
_0x12:
; 0000 007F    {
; 0000 0080    tx_buffer0[tx_wr_index0]=c;
	__GETW1R 9,10
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 0081    if (++tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	__GETW1R 9,10
	ADIW R30,1
	__PUTW1R 9,10
	CPI  R30,LOW(0x100)
	LDI  R26,HIGH(0x100)
	CPC  R31,R26
	BRNE _0x14
	CLR  R9
	CLR  R10
; 0000 0082    ++tx_counter0;
_0x14:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 13,14,30,31
; 0000 0083    }
; 0000 0084 else
	RJMP _0x15
_0x11:
; 0000 0085    UDR0=c;
	LD   R30,Y
	STS  198,R30
; 0000 0086 #asm("sei")
_0x15:
	sei
; 0000 0087 }
	JMP  _0x2060004
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;bit b_exec;
;
;//*********************************************************************
;// Pin change 8-14 interrupt service routine
;//*********************************************************************
;interrupt [PCINT1] void pin_change_isr1(void)
; 0000 0093 {
_pin_change_isr1:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0094     if (PINC&0x01)
	IN   R30,0x6
	LDI  R31,0
	ANDI R30,LOW(0x1)
	BREQ _0x16
; 0000 0095     {
; 0000 0096         TCCR0B=0x02;  //1843200
	LDI  R30,LOW(2)
	RJMP _0x6F
; 0000 0097     }
; 0000 0098     else if (TCCR0B)
_0x16:
	IN   R30,0x25
	CPI  R30,0
	BREQ _0x18
; 0000 0099     {
; 0000 009A         Timer_Count = ((255*Timer_Count) + TCNT0)>>1 ;
	CALL SUBOPT_0x2
	LDI  R26,LOW(255)
	LDI  R27,HIGH(255)
	CALL __MULW12U
	MOVW R26,R30
	IN   R30,0x26
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R26
	LSR  R31
	ROR  R30
	STS  _Timer_Count,R30
	STS  _Timer_Count+1,R31
; 0000 009B         b_echo_back = 1;
	LDI  R30,LOW(1)
	STS  _b_echo_back,R30
; 0000 009C         TCCR0B = 0;
	LDI  R30,LOW(0)
_0x6F:
	OUT  0x25,R30
; 0000 009D     }
; 0000 009E }
_0x18:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;//*********************************************************************
;// Timer 0 interrupt service routine
;//*********************************************************************
;
;// Timer 0 output compare A interrupt service routine
;interrupt [TIM0_COMPA] void timer0_compa_isr(void)
; 0000 00A6 {
_timer0_compa_isr:
	CALL SUBOPT_0x0
; 0000 00A7     Timer_Count++;
	LDI  R26,LOW(_Timer_Count)
	LDI  R27,HIGH(_Timer_Count)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 00A8     TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00A9 }
_0x72:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;//*********************************************************************
;// Timer 1 interrupt service routine
;//*********************************************************************
;
;// Timer 1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 00B0 {
_timer1_compa_isr:
; 0000 00B1 #asm
; 0000 00B2 	ST   -Y,R30
	ST   -Y,R30
; 0000 00B3 	ST   -Y,R31
	ST   -Y,R31
; 0000 00B4 	IN   R30,SREG
	IN   R30,SREG
; 0000 00B5 	ST   -Y,R30
	ST   -Y,R30
; 0000 00B6 ; prepare bank 0 spi data
; prepare bank 0 spi data
; 0000 00B7 	LDS  R30,_Edges_Ctr
	LDS  R30,_Edges_Ctr
; 0000 00B8 	LDI  R31,0
	LDI  R31,0
; 0000 00B9 	SUBI R30,LOW(-_PW_SPI_B0)
	SUBI R30,LOW(-_PW_SPI_B0)
; 0000 00BA 	SBCI R31,HIGH(-_PW_SPI_B0)
	SBCI R31,HIGH(-_PW_SPI_B0)
; 0000 00BB 	LD   R30,Z
	LD   R30,Z
; 0000 00BC 	OUT  0x2E,R30
	OUT  0x2E,R30
; 0000 00BD 	nop ;1
	nop ;1
; 0000 00BE 	nop ;2
	nop ;2
; 0000 00BF 	nop ;3
	nop ;3
; 0000 00C0 	nop ;4
	nop ;4
; 0000 00C1 	nop ;5
	nop ;5
; 0000 00C2 	nop ;6
	nop ;6
; 0000 00C3 	nop ;7
	nop ;7
; 0000 00C4 	nop ;8
	nop ;8
; 0000 00C5 	;nop ;1
	;nop ;1
; 0000 00C6 ; prepare bank 1 spi data
; prepare bank 1 spi data
; 0000 00C7 	LDS  R30,_Edges_Ctr ;2
	LDS  R30,_Edges_Ctr ;2
; 0000 00C8 	LDI  R31,0 ;1
	LDI  R31,0 ;1
; 0000 00C9 	SUBI R30,LOW(-_PW_SPI_B1);1
	SUBI R30,LOW(-_PW_SPI_B1);1
; 0000 00CA 	SBCI R31,HIGH(-_PW_SPI_B1);1
	SBCI R31,HIGH(-_PW_SPI_B1);1
; 0000 00CB 	LD   R30,Z;2
	LD   R30,Z;2
; 0000 00CC ; pulse bank 0
; pulse bank 0
; 0000 00CD 	SBI  0x5,1
	SBI  0x5,1
; 0000 00CE 	CBI  0x5,1
	CBI  0x5,1
; 0000 00CF ; load spi data bank 1
; load spi data bank 1
; 0000 00D0 	OUT  0x2E,R30
	OUT  0x2E,R30
; 0000 00D1 	nop ;1
	nop ;1
; 0000 00D2 	nop ;2
	nop ;2
; 0000 00D3 	nop ;3
	nop ;3
; 0000 00D4 	nop ;4
	nop ;4
; 0000 00D5 	nop ;5
	nop ;5
; 0000 00D6 	nop ;6
	nop ;6
; 0000 00D7 	nop ;7
	nop ;7
; 0000 00D8 	nop ;8
	nop ;8
; 0000 00D9 	;nop ;1
	;nop ;1
; 0000 00DA ; prepare bank 2 spi data
; prepare bank 2 spi data
; 0000 00DB 	LDS  R30,_Edges_Ctr
	LDS  R30,_Edges_Ctr
; 0000 00DC 	LDI  R31,0
	LDI  R31,0
; 0000 00DD 	SUBI R30,LOW(-_PW_SPI_B2)
	SUBI R30,LOW(-_PW_SPI_B2)
; 0000 00DE 	SBCI R31,HIGH(-_PW_SPI_B2)
	SBCI R31,HIGH(-_PW_SPI_B2)
; 0000 00DF 	LD   R30,Z
	LD   R30,Z
; 0000 00E0 ;pulse bank 1
;pulse bank 1
; 0000 00E1 	SBI  0x5,2
	SBI  0x5,2
; 0000 00E2 	CBI  0x5,2
	CBI  0x5,2
; 0000 00E3 ; load spi data bank 2
; load spi data bank 2
; 0000 00E4 	OUT  0x2E,R30
	OUT  0x2E,R30
; 0000 00E5 	nop ;1
	nop ;1
; 0000 00E6 	nop ;2
	nop ;2
; 0000 00E7 	nop ;3
	nop ;3
; 0000 00E8 	nop ;4
	nop ;4
; 0000 00E9 	nop ;5
	nop ;5
; 0000 00EA 	nop ;6
	nop ;6
; 0000 00EB 	nop ;7
	nop ;7
; 0000 00EC 	nop ;8
	nop ;8
; 0000 00ED 	;nop ;1
	;nop ;1
; 0000 00EE ; prepare bank 3 spi data
; prepare bank 3 spi data
; 0000 00EF 	LDS  R30,_Edges_Ctr
	LDS  R30,_Edges_Ctr
; 0000 00F0 	LDI  R31,0
	LDI  R31,0
; 0000 00F1 	SUBI R30,LOW(-_PW_SPI_B3)
	SUBI R30,LOW(-_PW_SPI_B3)
; 0000 00F2 	SBCI R31,HIGH(-_PW_SPI_B3)
	SBCI R31,HIGH(-_PW_SPI_B3)
; 0000 00F3 	LD   R30,Z
	LD   R30,Z
; 0000 00F4 ; pulse bank 2
; pulse bank 2
; 0000 00F5 	SBI  0xB,6
	SBI  0xB,6
; 0000 00F6 	CBI  0xB,6
	CBI  0xB,6
; 0000 00F7 ; load spi data bank 3
; load spi data bank 3
; 0000 00F8 	OUT  0x2E,R30
	OUT  0x2E,R30
; 0000 00F9 	nop ;1
	nop ;1
; 0000 00FA 	nop ;2
	nop ;2
; 0000 00FB 	nop ;3
	nop ;3
; 0000 00FC 	nop ;4
	nop ;4
; 0000 00FD 	nop ;5
	nop ;5
; 0000 00FE 	nop ;6
	nop ;6
; 0000 00FF 	nop ;7
	nop ;7
; 0000 0100 	nop ;8
	nop ;8
; 0000 0101 	nop ;1
	nop ;1
; 0000 0102 	nop ;2
	nop ;2
; 0000 0103 	nop ;3
	nop ;3
; 0000 0104 	nop ;4
	nop ;4
; 0000 0105 	nop ;5
	nop ;5
; 0000 0106 	nop ;6
	nop ;6
; 0000 0107 	nop ;7
	nop ;7
; 0000 0108 ;	nop ;8
;	nop ;8
; 0000 0109 ;0000 00E8 PORTD.7 = 1;PORTD.7 = 0;// pulse bank 3
;0000 00E8 PORTD.7 = 1;PORTD.7 = 0;// pulse bank 3
; 0000 010A 	SBI  0xB,7
	SBI  0xB,7
; 0000 010B 	CBI  0xB,7
	CBI  0xB,7
; 0000 010C ;0000 00E9 /* A15 */
;0000 00E9 /* A15 */
; 0000 010D ;0000 00EA
;0000 00EA
; 0000 010E ;0000 00EB b_exec = 0;
;0000 00EB b_exec = 0;
; 0000 010F 	CBI  0x1E,1
	CBI  0x1E,1
; 0000 0110 ;0000 00EC // reset counter
;0000 00EC // reset counter
; 0000 0111 ;0000 00ED TCNT1H=0x00;
;0000 00ED TCNT1H=0x00;
; 0000 0112 	LDI  R30,LOW(0)
	LDI  R30,LOW(0)
; 0000 0113 	STS  133,R30
	STS  133,R30
; 0000 0114 ;0000 00EE TCNT1L=0x00;
;0000 00EE TCNT1L=0x00;
; 0000 0115 	STS  132,R30
	STS  132,R30
; 0000 0116 ;0000 00EF
;0000 00EF
; 0000 0117 ;0000 00F0 /*Take less than 1 timer clocks*/
;0000 00F0 /*Take less than 1 timer clocks*/
; 0000 0118 ;0000 00F1 }
;0000 00F1 }
; 0000 0119 	LD   R30,Y+
	LD   R30,Y+
; 0000 011A 	OUT  SREG,R30
	OUT  SREG,R30
; 0000 011B 	LD   R31,Y+
	LD   R31,Y+
; 0000 011C 	LD   R30,Y+
	LD   R30,Y+
; 0000 011D #endasm
; 0000 011E }
	RETI
;// Timer 1 output compare B interrupt service routine
;interrupt [TIM1_COMPB] void timer1_compb_isr(void)
; 0000 0121 {
_timer1_compb_isr:
; 0000 0122 #asm
; 0000 0123 	ST   -Y,R26
	ST   -Y,R26
; 0000 0124 	ST   -Y,R27
	ST   -Y,R27
; 0000 0125 	ST   -Y,R30
	ST   -Y,R30
; 0000 0126 	ST   -Y,R31
	ST   -Y,R31
; 0000 0127 	IN   R30,SREG
	IN   R30,SREG
; 0000 0128 	ST   -Y,R30
	ST   -Y,R30
; 0000 0129 	ST   -Y,R17
	ST   -Y,R17
; 0000 012A 	ST   -Y,R16
	ST   -Y,R16
; 0000 012B ; prepare bank 0 spi data
; prepare bank 0 spi data
; 0000 012C 	LDS  R30,_Edges_Ptr
	LDS  R30,_Edges_Ptr
; 0000 012D 	LDI  R31,0
	LDI  R31,0
; 0000 012E 	SUBI R30,LOW(-_PW_SPI_B0)
	SUBI R30,LOW(-_PW_SPI_B0)
; 0000 012F 	SBCI R31,HIGH(-_PW_SPI_B0)
	SBCI R31,HIGH(-_PW_SPI_B0)
; 0000 0130 	LD   R30,Z
	LD   R30,Z
; 0000 0131 	OUT  0x2E,R30
	OUT  0x2E,R30
; 0000 0132 	nop ;1
	nop ;1
; 0000 0133 	nop ;2
	nop ;2
; 0000 0134 	nop ;3
	nop ;3
; 0000 0135 	nop ;4
	nop ;4
; 0000 0136 	nop ;5
	nop ;5
; 0000 0137 	nop ;6
	nop ;6
; 0000 0138 	nop ;7
	nop ;7
; 0000 0139 	nop ;8
	nop ;8
; 0000 013A 	;nop ;1
	;nop ;1
; 0000 013B ; prepare bank 1 spi data
; prepare bank 1 spi data
; 0000 013C 	LDS  R30,_Edges_Ptr ;2
	LDS  R30,_Edges_Ptr ;2
; 0000 013D 	LDI  R31,0 ;1
	LDI  R31,0 ;1
; 0000 013E 	SUBI R30,LOW(-_PW_SPI_B1);1
	SUBI R30,LOW(-_PW_SPI_B1);1
; 0000 013F 	SBCI R31,HIGH(-_PW_SPI_B1);1
	SBCI R31,HIGH(-_PW_SPI_B1);1
; 0000 0140 	LD   R30,Z;2
	LD   R30,Z;2
; 0000 0141 ; pulse bank 0
; pulse bank 0
; 0000 0142 	SBI  0x5,1
	SBI  0x5,1
; 0000 0143 	CBI  0x5,1
	CBI  0x5,1
; 0000 0144 ; load spi data bank 1
; load spi data bank 1
; 0000 0145 	OUT  0x2E,R30
	OUT  0x2E,R30
; 0000 0146 	nop ;1
	nop ;1
; 0000 0147 	nop ;2
	nop ;2
; 0000 0148 	nop ;3
	nop ;3
; 0000 0149 	nop ;4
	nop ;4
; 0000 014A 	nop ;5
	nop ;5
; 0000 014B 	nop ;6
	nop ;6
; 0000 014C 	nop ;7
	nop ;7
; 0000 014D 	nop ;8
	nop ;8
; 0000 014E 	;nop ;1
	;nop ;1
; 0000 014F ; prepare bank 2 spi data
; prepare bank 2 spi data
; 0000 0150 	LDS  R30,_Edges_Ptr
	LDS  R30,_Edges_Ptr
; 0000 0151 	LDI  R31,0
	LDI  R31,0
; 0000 0152 	SUBI R30,LOW(-_PW_SPI_B2)
	SUBI R30,LOW(-_PW_SPI_B2)
; 0000 0153 	SBCI R31,HIGH(-_PW_SPI_B2)
	SBCI R31,HIGH(-_PW_SPI_B2)
; 0000 0154 	LD   R30,Z
	LD   R30,Z
; 0000 0155 ;pulse bank 1
;pulse bank 1
; 0000 0156 	SBI  0x5,2
	SBI  0x5,2
; 0000 0157 	CBI  0x5,2
	CBI  0x5,2
; 0000 0158 ; load spi data bank 2
; load spi data bank 2
; 0000 0159 	OUT  0x2E,R30
	OUT  0x2E,R30
; 0000 015A 	nop ;1
	nop ;1
; 0000 015B 	nop ;2
	nop ;2
; 0000 015C 	nop ;3
	nop ;3
; 0000 015D 	nop ;4
	nop ;4
; 0000 015E 	nop ;5
	nop ;5
; 0000 015F 	nop ;6
	nop ;6
; 0000 0160 	nop ;7
	nop ;7
; 0000 0161 	nop ;8
	nop ;8
; 0000 0162 	;nop ;1
	;nop ;1
; 0000 0163 ; prepare bank 3 spi data
; prepare bank 3 spi data
; 0000 0164 	LDS  R30,_Edges_Ptr
	LDS  R30,_Edges_Ptr
; 0000 0165 	LDI  R31,0
	LDI  R31,0
; 0000 0166 	SUBI R30,LOW(-_PW_SPI_B3)
	SUBI R30,LOW(-_PW_SPI_B3)
; 0000 0167 	SBCI R31,HIGH(-_PW_SPI_B3)
	SBCI R31,HIGH(-_PW_SPI_B3)
; 0000 0168 	LD   R30,Z
	LD   R30,Z
; 0000 0169 ; pulse bank 2
; pulse bank 2
; 0000 016A 	SBI  0xB,6
	SBI  0xB,6
; 0000 016B 	CBI  0xB,6
	CBI  0xB,6
; 0000 016C ; load spi data bank 3
; load spi data bank 3
; 0000 016D 	OUT  0x2E,R30
	OUT  0x2E,R30
; 0000 016E 	nop ;1
	nop ;1
; 0000 016F 	nop ;2
	nop ;2
; 0000 0170 	nop ;3
	nop ;3
; 0000 0171 	nop ;4
	nop ;4
; 0000 0172 	nop ;5
	nop ;5
; 0000 0173 	;nop ;6
	;nop ;6
; 0000 0174 	;nop ;7
	;nop ;7
; 0000 0175 	;nop ;8
	;nop ;8
; 0000 0176 	;nop ;1
	;nop ;1
; 0000 0177 	;nop ;2
	;nop ;2
; 0000 0178 	;nop ;3
	;nop ;3
; 0000 0179 ;0000 0140 /* AEA */
;0000 0140 /* AEA */
; 0000 017A ;0000 0141 // update pointer
;0000 0141 // update pointer
; 0000 017B ;0000 0142 Edges_Ptr ++;
;0000 0142 Edges_Ptr ++;
; 0000 017C 	LDS  R30,_Edges_Ptr
	LDS  R30,_Edges_Ptr
; 0000 017D 	SUBI R30,-LOW(1)
	SUBI R30,-LOW(1)
; 0000 017E 	STS  _Edges_Ptr,R30
	STS  _Edges_Ptr,R30
; 0000 017F ;0000 0143 if (Edges_Ptr == Edges_Ctr)
;0000 0143 if (Edges_Ptr == Edges_Ctr)
; 0000 0180 	LDS  R30,_Edges_Ctr
	LDS  R30,_Edges_Ctr
; 0000 0181 	LDS  R26,_Edges_Ptr
	LDS  R26,_Edges_Ptr
; 0000 0182 	CP   R30,R26
	CP   R30,R26
; 0000 0183 ;0000 013F PORTD.7 = 1;PORTD.7 = 0;// pulse bank 3
;0000 013F PORTD.7 = 1;PORTD.7 = 0;// pulse bank 3
; 0000 0184 	SBI  0xB,7
	SBI  0xB,7
; 0000 0185 	CBI  0xB,7
	CBI  0xB,7
; 0000 0186 

; 0000 0187 	BRNE _NORESET
	BRNE _NORESET
; 0000 0188 ;0000 0144 {
;0000 0144 {
; 0000 0189 ;0000 0145     b_exec = 1;
;0000 0145     b_exec = 1;
; 0000 018A 	SBI  0x1E,1
	SBI  0x1E,1
; 0000 018B ;0000 0146     Edges_Ptr = 0;
;0000 0146     Edges_Ptr = 0;
; 0000 018C 	LDI  R30,LOW(0)
	LDI  R30,LOW(0)
; 0000 018D 	STS  _Edges_Ptr,R30
	STS  _Edges_Ptr,R30
; 0000 018E ;0000 0147 }
;0000 0147 }
; 0000 018F ;0000 0148 // set next edge
;0000 0148 // set next edge
; 0000 0190 ;0000 0149 OCR1BH = PW_Time[Edges_Ptr]>>8;
;0000 0149 OCR1BH = PW_Time[Edges_Ptr]>>8;
; 0000 0191 _NORESET:
_NORESET:
; 0000 0192 	LDS  R30,_Edges_Ptr
	LDS  R30,_Edges_Ptr
; 0000 0193 	LDI  R26,LOW(_PW_Time)
	LDI  R26,LOW(_PW_Time)
; 0000 0194 	LDI  R27,HIGH(_PW_Time)
	LDI  R27,HIGH(_PW_Time)
; 0000 0195 	LDI  R31,0
	LDI  R31,0
; 0000 0196 	LSL  R30
	LSL  R30
; 0000 0197 	ROL  R31
	ROL  R31
; 0000 0198 	ADD  R26,R30
	ADD  R26,R30
; 0000 0199 	ADC  R27,R31
	ADC  R27,R31
; 0000 019A 	LD   R16,X+
	LD   R16,X+
; 0000 019B 	LD   R17,X
	LD   R17,X
; 0000 019C ; 0000 014B OCR1BH = test>>8;
; 0000 014B OCR1BH = test>>8;
; 0000 019D 	MOVW R30,R16
	MOVW R30,R16
; 0000 019E 	MOV  R30,R31
	MOV  R30,R31
; 0000 019F 	CLR  R31
	CLR  R31
; 0000 01A0 	SBRC R30,7
	SBRC R30,7
; 0000 01A1 	SER  R31
	SER  R31
; 0000 01A2 	STS  139,R30
	STS  139,R30
; 0000 01A3 ; 0000 014C OCR1BL = test;
; 0000 014C OCR1BL = test;
; 0000 01A4 	STS  138,R16
	STS  138,R16
; 0000 01A5 ;0000 014B
;0000 014B
; 0000 01A6 ;0000 014C }
;0000 014C }
; 0000 01A7 	LD   R16,Y+
	LD   R16,Y+
; 0000 01A8 	LD   R17,Y+
	LD   R17,Y+
; 0000 01A9 	LD   R30,Y+
	LD   R30,Y+
; 0000 01AA 	OUT  SREG,R30
	OUT  SREG,R30
; 0000 01AB 	LD   R31,Y+
	LD   R31,Y+
; 0000 01AC 	LD   R30,Y+
	LD   R30,Y+
; 0000 01AD 	LD   R27,Y+
	LD   R27,Y+
; 0000 01AE 	LD   R26,Y+
	LD   R26,Y+
; 0000 01AF #endasm
; 0000 01B0 }
	RETI
;//*********************************************************************
;// SPI interrupt service routine
;//*********************************************************************
;
;// SPI interrupt service routine
;interrupt [SPI_STC] void spi_isr(void)
; 0000 01B7 {
_spi_isr:
; 0000 01B8 unsigned char data;
; 0000 01B9 data=SPDR;
	ST   -Y,R17
;	data -> R17
	IN   R17,46
; 0000 01BA // Place your code here
; 0000 01BB 
; 0000 01BC }
	LD   R17,Y+
	RETI
;//*********************************************************************
;// Global variables.
;//*********************************************************************
;
;/* State bits*/
;bit b_move;
;bit b_step;
;bit b_recieve_cmd;
;
;/* Command processing */
;// Command type
;unsigned char cmd;
;// Command arguments
;unsigned char CMD_Pattern[3];
;// Number of command to be handle
;unsigned char CMD_Count;
;// Channels to be affected
;unsigned char CMD_Channel[32];
;// New values of affected channel
;unsigned int  CMD_Time[32];
;
;/* Moving speed congtrol */
;// counting step of each command
;unsigned char SP_Steps[32];
;// moving direction of each command: 1- increase 0- decrease (pulse width)
;unsigned char SP_Dir[32];
;// step adjustment (synchronize move)
;unsigned char SP_Interval[32];
;
;/* Step interval*/
;unsigned char Interval;
;
;/* Multi purposes variables*/
;unsigned char i,j;
;unsigned char channel,tmp;
;unsigned int adc = 0;
;unsigned int distance = 0;
;
;void main(void)
; 0000 01E4 {
_main:
; 0000 01E5 // Declare your local variables here
; 0000 01E6 
; 0000 01E7 CMD_Count = 0;
	LDI  R30,LOW(0)
	STS  _CMD_Count,R30
; 0000 01E8 b_move = 0;
	CBI  0x1E,2
; 0000 01E9 b_step = 0;
	CBI  0x1E,3
; 0000 01EA b_exec = 0;
	CBI  0x1E,1
; 0000 01EB // cmd loop enable
; 0000 01EC b_recieve_cmd = 1;
	SBI  0x1E,4
; 0000 01ED 
; 0000 01EE // Default interval (ms) for 20us step
; 0000 01EF Interval = 1;
	LDI  R30,LOW(1)
	STS  _Interval,R30
; 0000 01F0 
; 0000 01F1 SSC32_Init();
	RCALL _SSC32_Init
; 0000 01F2 PW_Init();
	CALL _PW_Init
; 0000 01F3 //PW_Start();
; 0000 01F4 SetBaud((PIND&0x18)>>3);
	IN   R30,0x9
	LDI  R31,0
	ANDI R30,LOW(0x18)
	ANDI R31,HIGH(0x18)
	CALL __ASRW3
	ST   -Y,R30
	CALL _SetBaud
; 0000 01F5 
; 0000 01F6 while (1)
_0x21:
; 0000 01F7     {
; 0000 01F8         // command loop
; 0000 01F9         if (b_recieve_cmd)
	SBIS 0x1E,4
	RJMP _0x24
; 0000 01FA         {
; 0000 01FB             // waiting for command
; 0000 01FC             cmd = getchar();
	CALL SUBOPT_0x3
; 0000 01FD             // process command
; 0000 01FE             switch (cmd)
	LDS  R30,_cmd
	LDI  R31,0
; 0000 01FF             {
; 0000 0200                 case 'I':
	CPI  R30,LOW(0x49)
	LDI  R26,HIGH(0x49)
	CPC  R31,R26
	BRNE _0x28
; 0000 0201                     cmd = getchar();
	CALL SUBOPT_0x3
; 0000 0202                     if ((cmd>0)&&(cmd<31))
	LDS  R26,_cmd
	CPI  R26,LOW(0x1)
	BRLO _0x2A
	CPI  R26,LOW(0x1F)
	BRLO _0x2B
_0x2A:
	RJMP _0x29
_0x2B:
; 0000 0203                     {
; 0000 0204                         Interval = cmd;
	LDS  R30,_cmd
	STS  _Interval,R30
; 0000 0205                     }
; 0000 0206                     break;
_0x29:
	RJMP _0x27
; 0000 0207                 case 'D':
_0x28:
	CPI  R30,LOW(0x44)
	LDI  R26,HIGH(0x44)
	CPC  R31,R26
	BRNE _0x2C
; 0000 0208                     distance = read_distance();
	CALL _read_distance
	STS  _distance,R30
	STS  _distance+1,R31
; 0000 0209                     putchar(distance>>8);
	LDS  R30,_distance+1
	ST   -Y,R30
	CALL _putchar
; 0000 020A                     putchar(distance&0xFF);
	LDS  R30,_distance
	LDS  R31,_distance+1
	ST   -Y,R30
	CALL _putchar
; 0000 020B                     break;
	RJMP _0x27
; 0000 020C                 case 'V':
_0x2C:
	CPI  R30,LOW(0x56)
	LDI  R26,HIGH(0x56)
	CPC  R31,R26
	BRNE _0x2D
; 0000 020D                     /* Read analog(V) input */
; 0000 020E                     cmd = getchar();
	CALL SUBOPT_0x3
; 0000 020F                     switch (cmd)
	LDS  R30,_cmd
	LDI  R31,0
; 0000 0210                     {
; 0000 0211                         case 'A':
	CPI  R30,LOW(0x41)
	LDI  R26,HIGH(0x41)
	CPC  R31,R26
	BRNE _0x31
; 0000 0212                             adc = read_adc(0);
	LDI  R30,LOW(0)
	RJMP _0x70
; 0000 0213                             break;
; 0000 0214                         case 'B':
_0x31:
	CPI  R30,LOW(0x42)
	LDI  R26,HIGH(0x42)
	CPC  R31,R26
	BRNE _0x32
; 0000 0215                             adc = read_adc(1);
	LDI  R30,LOW(1)
	RJMP _0x70
; 0000 0216                             break;
; 0000 0217                         case 'C':
_0x32:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0x33
; 0000 0218                             adc = read_adc(2);
	LDI  R30,LOW(2)
	RJMP _0x70
; 0000 0219                             break;
; 0000 021A                         case 'D':
_0x33:
	CPI  R30,LOW(0x44)
	LDI  R26,HIGH(0x44)
	CPC  R31,R26
	BRNE _0x30
; 0000 021B                             adc = read_adc(3);
	LDI  R30,LOW(3)
_0x70:
	ST   -Y,R30
	CALL _read_adc
	STS  _adc,R30
	STS  _adc+1,R31
; 0000 021C                             break;
; 0000 021D                     }
_0x30:
; 0000 021E                     putchar(adc>>8);
	LDS  R30,_adc+1
	ST   -Y,R30
	CALL _putchar
; 0000 021F                     putchar(adc&0xFF);
	LDS  R30,_adc
	LDS  R31,_adc+1
	ST   -Y,R30
	CALL _putchar
; 0000 0220                     break;
	RJMP _0x27
; 0000 0221                 case 'S':
_0x2D:
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BRNE _0x35
; 0000 0222                     /* on(1)/off(0) command  */
; 0000 0223                     cmd = getchar();
	CALL SUBOPT_0x3
; 0000 0224                     if (cmd == 0x01)
	LDS  R26,_cmd
	CPI  R26,LOW(0x1)
	BRNE _0x36
; 0000 0225                     {
; 0000 0226                         PW_Start();
	CALL _PW_Start
; 0000 0227                     }
; 0000 0228                     else
	RJMP _0x37
_0x36:
; 0000 0229                     {
; 0000 022A                         PW_Stop();
	CALL _PW_Stop
; 0000 022B                     }
_0x37:
; 0000 022C                     break;
	RJMP _0x27
; 0000 022D                 case '#':
_0x35:
	CPI  R30,LOW(0x23)
	LDI  R26,HIGH(0x23)
	CPC  R31,R26
	BRNE _0x38
; 0000 022E                     /* moving command */
; 0000 022F                     PORTD ^= 0x04;
	CALL SUBOPT_0x4
; 0000 0230                     CMD_Pattern[0] = getchar();
	CALL _getchar
	STS  _CMD_Pattern,R30
; 0000 0231                     CMD_Pattern[1] = getchar();
	CALL _getchar
	__PUTB1MN _CMD_Pattern,1
; 0000 0232                     CMD_Pattern[2] = getchar();
	CALL _getchar
	__PUTB1MN _CMD_Pattern,2
; 0000 0233 
; 0000 0234                     CMD_Channel[CMD_Count]= Servo[CMD_Pattern[0]];
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
; 0000 0235                     CMD_Time[CMD_Count]= CMD_Pattern[2]+(CMD_Pattern[1]<<8);
	LDS  R30,_CMD_Count
	CALL SUBOPT_0x5
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
; 0000 0236 
; 0000 0237                     CMD_Count++;
	LDS  R30,_CMD_Count
	SUBI R30,-LOW(1)
	STS  _CMD_Count,R30
; 0000 0238                     break;
	RJMP _0x27
; 0000 0239                 case 'T':
_0x38:
	CPI  R30,LOW(0x54)
	LDI  R26,HIGH(0x54)
	CPC  R31,R26
	BRNE _0x42
; 0000 023A                     /* Timing option */
; 0000 023B                     cmd = getchar();
	CALL SUBOPT_0x3
; 0000 023C                     // disable cmd loop
; 0000 023D                     b_recieve_cmd = 0;
	CBI  0x1E,4
; 0000 023E 
; 0000 023F                     if (!cmd)
	LDS  R30,_cmd
	CPI  R30,0
	BRNE _0x3C
; 0000 0240                     {
; 0000 0241                         /* instance move */
; 0000 0242                         b_move = 1;
	SBI  0x1E,2
; 0000 0243                     }
; 0000 0244                     else
	RJMP _0x3F
_0x3C:
; 0000 0245                     {
; 0000 0246                         /* timing move */
; 0000 0247                         b_step = 1;
	SBI  0x1E,3
; 0000 0248                     }
_0x3F:
; 0000 0249                 default:
_0x42:
; 0000 024A                     break;
; 0000 024B             }
_0x27:
; 0000 024C         }
; 0000 024D         // start moving
; 0000 024E         if (b_move)
_0x24:
	SBIS 0x1E,2
	RJMP _0x43
; 0000 024F         {
; 0000 0250             for (i =0;i< CMD_Count; i++)
	LDI  R30,LOW(0)
	STS  _i,R30
_0x45:
	CALL SUBOPT_0x6
	BRSH _0x46
; 0000 0251             {
; 0000 0252                 PW_Set(CMD_Channel[i],CMD_Time[i], i);
	CALL SUBOPT_0x7
	ST   -Y,R30
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_i
	ST   -Y,R30
	CALL _PW_Set
; 0000 0253             }
	CALL SUBOPT_0xA
	RJMP _0x45
_0x46:
; 0000 0254             // update spi output (execute command)
; 0000 0255             while(!b_exec);
_0x47:
	SBIS 0x1E,1
	RJMP _0x47
; 0000 0256             PW_Update_SPI();
	CALL _PW_Update_SPI
; 0000 0257 
; 0000 0258             //reset command counter
; 0000 0259             CMD_Count = 0;
	LDI  R30,LOW(0)
	STS  _CMD_Count,R30
; 0000 025A             //reset state bit
; 0000 025B             // - enable cmd loop
; 0000 025C             b_recieve_cmd = 1;
	SBI  0x1E,4
; 0000 025D             // - disable instance move
; 0000 025E             b_move = 0;
	CBI  0x1E,2
; 0000 025F             // - done execution
; 0000 0260             b_exec = 0;
	CBI  0x1E,1
; 0000 0261         }
; 0000 0262         // stepping mode
; 0000 0263         if (b_step)
_0x43:
	SBIS 0x1E,3
	RJMP _0x50
; 0000 0264         {
; 0000 0265             // calculate steps needed
; 0000 0266             for (i=0;i<CMD_Count;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
_0x52:
	CALL SUBOPT_0x6
	BRSH _0x53
; 0000 0267             {
; 0000 0268                 channel = CMD_Channel[i];
	CALL SUBOPT_0x7
	CALL SUBOPT_0xB
; 0000 0269                 // decrease
; 0000 026A                 if (SV_Width[channel] > CMD_Time[i])
	CALL SUBOPT_0xC
	CALL SUBOPT_0x9
	CP   R30,R0
	CPC  R31,R1
	BRSH _0x54
; 0000 026B                 {
; 0000 026C                     SP_Steps[i] = (SV_Width[channel] - CMD_Time[i])/20;
	CALL SUBOPT_0xD
	SUBI R30,LOW(-_SP_Steps)
	SBCI R31,HIGH(-_SP_Steps)
	MOVW R22,R30
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC
	CALL SUBOPT_0x9
	CALL SUBOPT_0xF
; 0000 026D                     SP_Dir[i] = 0;
	SUBI R30,LOW(-_SP_Dir)
	SBCI R31,HIGH(-_SP_Dir)
	LDI  R26,LOW(0)
	RJMP _0x71
; 0000 026E                 }
; 0000 026F                 else //increase: (SV_Width[channel] < CMD_Time[i])
_0x54:
; 0000 0270                 {
; 0000 0271                     SP_Steps[i] = (CMD_Time[i] - SV_Width[channel])/20;
	CALL SUBOPT_0xD
	SUBI R30,LOW(-_SP_Steps)
	SBCI R31,HIGH(-_SP_Steps)
	MOVW R22,R30
	CALL SUBOPT_0x8
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X+
	LD   R1,X
	CALL SUBOPT_0xE
	CALL SUBOPT_0x9
	CALL SUBOPT_0xF
; 0000 0272                     SP_Dir[i] = 1;
	SUBI R30,LOW(-_SP_Dir)
	SBCI R31,HIGH(-_SP_Dir)
	LDI  R26,LOW(1)
_0x71:
	STD  Z+0,R26
; 0000 0273                 }
; 0000 0274             }
	CALL SUBOPT_0xA
	RJMP _0x52
_0x53:
; 0000 0275             tmp = Max(SP_Steps,CMD_Count);
	LDI  R30,LOW(_SP_Steps)
	LDI  R31,HIGH(_SP_Steps)
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_CMD_Count
	ST   -Y,R30
	CALL _Max
	STS  _tmp,R30
; 0000 0276             for (i=0;i<CMD_Count;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
_0x57:
	CALL SUBOPT_0x6
	BRSH _0x58
; 0000 0277             {
; 0000 0278                 SP_Interval[i] = tmp/SP_Steps[i];
	CALL SUBOPT_0xD
	MOVW R0,R30
	SUBI R30,LOW(-_SP_Interval)
	SBCI R31,HIGH(-_SP_Interval)
	MOVW R22,R30
	LDS  R26,_tmp
	CLR  R27
	MOVW R30,R0
	SUBI R30,LOW(-_SP_Steps)
	SBCI R31,HIGH(-_SP_Steps)
	CALL SUBOPT_0x10
	CALL __DIVW21
	MOVW R26,R22
	ST   X,R30
; 0000 0279             }
	CALL SUBOPT_0xA
	RJMP _0x57
_0x58:
; 0000 027A             // step execution
; 0000 027B             for (i=0;i<tmp;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
_0x5A:
	LDS  R30,_tmp
	LDS  R26,_i
	CP   R26,R30
	BRLO PC+3
	JMP _0x5B
; 0000 027C             {
; 0000 027D                 for (j=0;j<CMD_Count;j++)
	LDI  R30,LOW(0)
	STS  _j,R30
_0x5D:
	LDS  R30,_CMD_Count
	LDS  R26,_j
	CP   R26,R30
	BRLO PC+3
	JMP _0x5E
; 0000 027E                 {
; 0000 027F                     if (( (i%SP_Interval[j]) == 0) && (SP_Steps[j]>0))
	LDS  R26,_i
	CLR  R27
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_SP_Interval)
	SBCI R31,HIGH(-_SP_Interval)
	CALL SUBOPT_0x10
	CALL __MODW21
	SBIW R30,0
	BRNE _0x60
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_SP_Steps)
	SBCI R31,HIGH(-_SP_Steps)
	LD   R30,Z
	CPI  R30,LOW(0x1)
	BRSH _0x61
_0x60:
	RJMP _0x5F
_0x61:
; 0000 0280                     {
; 0000 0281                         SP_Steps[j]--;
	LDS  R26,_j
	LDI  R27,0
	SUBI R26,LOW(-_SP_Steps)
	SBCI R27,HIGH(-_SP_Steps)
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
; 0000 0282                         channel = CMD_Channel[j];
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_CMD_Channel)
	SBCI R31,HIGH(-_CMD_Channel)
	LD   R30,Z
	CALL SUBOPT_0xB
; 0000 0283                         SV_Width[channel] +=  ((SP_Dir[j])?20:-20) ;
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R26,R30
	CALL __GETW1P
	MOVW R26,R30
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_SP_Dir)
	SBCI R31,HIGH(-_SP_Dir)
	CALL SUBOPT_0x10
	SBIW R30,0
	BREQ _0x62
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RJMP _0x63
_0x62:
	LDI  R30,LOW(65516)
	LDI  R31,HIGH(65516)
_0x63:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 0284                         PW_Set(channel,SV_Width[channel],j);
	LDS  R30,_channel
	ST   -Y,R30
	CALL SUBOPT_0xE
	CALL SUBOPT_0x9
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_j
	ST   -Y,R30
	CALL _PW_Set
; 0000 0285                     }
; 0000 0286                 }
_0x5F:
	LDS  R30,_j
	SUBI R30,-LOW(1)
	STS  _j,R30
	RJMP _0x5D
_0x5E:
; 0000 0287 
; 0000 0288                 // execute
; 0000 0289                 while(!b_exec);
_0x65:
	SBIS 0x1E,1
	RJMP _0x65
; 0000 028A                 PW_Update_SPI();
	CALL _PW_Update_SPI
; 0000 028B                 b_exec = 0;
	CBI  0x1E,1
; 0000 028C 
; 0000 028D                 delay_ms(Interval);
	LDS  R30,_Interval
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 028E             }
	CALL SUBOPT_0xA
	RJMP _0x5A
_0x5B:
; 0000 028F             // reset command counter
; 0000 0290             CMD_Count = 0;
	LDI  R30,LOW(0)
	STS  _CMD_Count,R30
; 0000 0291             // reset state bit
; 0000 0292             // - enable cmd loop
; 0000 0293             b_recieve_cmd = 1;
	SBI  0x1E,4
; 0000 0294             // - disable timing move
; 0000 0295             b_step = 0;
	CBI  0x1E,3
; 0000 0296         }
; 0000 0297     };
_0x50:
	RJMP _0x21
; 0000 0298 }
_0x6E:
	RJMP _0x6E
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
;#include <delay.h>
;#include "SSC32.h"
;
;unsigned int Timer_Count;
;unsigned char b_echo_back;
;
;void SSC32_Init()
; 0001 0009 {

	.CSEG
_SSC32_Init:
; 0001 000A // Crystal Oscillator division factor: 1
; 0001 000B #pragma optsize-
; 0001 000C CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0001 000D CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0001 000E #ifdef _OPTIMIZE_SIZE_
; 0001 000F #pragma optsize+
; 0001 0010 #endif
; 0001 0011 
; 0001 0012 // Input/Output Ports initialization
; 0001 0013 // Port B initialization
; 0001 0014 // Func7=In Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=In
; 0001 0015 // State7=T State6=T State5=0 State4=0 State3=0 State2=0 State1=0 State0=T
; 0001 0016 PORTB=0x00;
	OUT  0x5,R30
; 0001 0017 DDRB=0x3E;
	LDI  R30,LOW(62)
	OUT  0x4,R30
; 0001 0018 
; 0001 0019 // Port C initialization
; 0001 001A // Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=In
; 0001 001B // State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=T
; 0001 001C PORTC=0x01;
	LDI  R30,LOW(1)
	OUT  0x8,R30
; 0001 001D DDRC=0xFE;
	LDI  R30,LOW(254)
	OUT  0x7,R30
; 0001 001E 
; 0001 001F // Port D initialization
; 0001 0020 // Func7=Out Func6=Out Func5=In Func4=In Func3=In Func2=Out Func1=In Func0=In
; 0001 0021 // State7=0 State6=0 State5=T State4=T State3=T State2=0 State1=T State0=T
; 0001 0022 PORTD=0x18;
	LDI  R30,LOW(24)
	OUT  0xB,R30
; 0001 0023 DDRD=0xC4;
	LDI  R30,LOW(196)
	OUT  0xA,R30
; 0001 0024 
; 0001 0025 // Timer/Counter 0 initialization
; 0001 0026 // Clock source: 14400
; 0001 0027 // Clock value: Timer 0 Stopped
; 0001 0028 // Mode: Normal top=FFh
; 0001 0029 // OC0A output: Disconnected
; 0001 002A // OC0B output: Disconnected
; 0001 002B TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0001 002C // current clock: stop(0x00)
; 0001 002D TCCR0B=0x00;
	OUT  0x25,R30
; 0001 002E TCNT0=0x00;
	OUT  0x26,R30
; 0001 002F //
; 0001 0030 OCR0A=0xFF;
	LDI  R30,LOW(255)
	OUT  0x27,R30
; 0001 0031 OCR0B=0x00;
	LDI  R30,LOW(0)
	OUT  0x28,R30
; 0001 0032 
; 0001 0033 // Timer/Counter 1 initialization
; 0001 0034 // Clock source: System Clock
; 0001 0035 // Clock value: 1843.200 kHz
; 0001 0036 // Mode: Normal top=FFFFh
; 0001 0037 // OC1A output: Discon.
; 0001 0038 // OC1B output: Discon.
; 0001 0039 // Noise Canceler: Off
; 0001 003A // Input Capture on Falling Edge
; 0001 003B // Timer 1 Overflow Interrupt: Off
; 0001 003C // Input Capture Interrupt: Off
; 0001 003D // Compare A Match Interrupt: On
; 0001 003E // Compare B Match Interrupt: On
; 0001 003F 
; 0001 0040 // timer 1 stop
; 0001 0041 TCCR1A=0x00;
	STS  128,R30
; 0001 0042 TCCR1B=0x00;
	STS  129,R30
; 0001 0043 TCCR1C=0x00;
	STS  130,R30
; 0001 0044 //TCCR1A=0x00;
; 0001 0045 //TCCR1B=0x02;
; 0001 0046 
; 0001 0047 
; 0001 0048 ICR1H=0x00;
	STS  135,R30
; 0001 0049 ICR1L=0x00;
	STS  134,R30
; 0001 004A // 20ms
; 0001 004B OCR1AH=0x90;
	LDI  R30,LOW(144)
	STS  137,R30
; 0001 004C OCR1AL=0x00;
	LDI  R30,LOW(0)
	STS  136,R30
; 0001 004D // 1.5ms
; 0001 004E OCR1BH=0x0A;
	LDI  R30,LOW(10)
	STS  139,R30
; 0001 004F OCR1BL=0xCD;
	LDI  R30,LOW(205)
	STS  138,R30
; 0001 0050 
; 0001 0051 // Timer/Counter 2 initialization
; 0001 0052 // Clock source: System Clock
; 0001 0053 // Clock value: Timer 2 Stopped
; 0001 0054 // Mode: Normal top=FFh
; 0001 0055 // OC2A output: Disconnected
; 0001 0056 // OC2B output: Disconnected
; 0001 0057 ASSR=0x00;
	LDI  R30,LOW(0)
	STS  182,R30
; 0001 0058 TCCR2A=0x00;
	STS  176,R30
; 0001 0059 TCCR2B=0x00;
	STS  177,R30
; 0001 005A TCNT2=0x00;
	STS  178,R30
; 0001 005B OCR2A=0x00;
	STS  179,R30
; 0001 005C OCR2B=0x00;
	STS  180,R30
; 0001 005D 
; 0001 005E // External Interrupt(s) initialization
; 0001 005F // INT0: Off
; 0001 0060 // INT1: Off
; 0001 0061 // Interrupt on any change on pins PCINT0-7: Off
; 0001 0062 // Interrupt on any change on pins PCINT8-14: On
; 0001 0063 // Interrupt on any change on pins PCINT16-23: Off
; 0001 0064 EICRA=0x00;
	STS  105,R30
; 0001 0065 EIMSK=0x00;
	OUT  0x1D,R30
; 0001 0066 // current stop
; 0001 0067 PCICR=0x00;
	STS  104,R30
; 0001 0068 //PCICR=0x02;
; 0001 0069 PCMSK1=0x01;
	LDI  R30,LOW(1)
	STS  108,R30
; 0001 006A PCIFR=0x02;
	LDI  R30,LOW(2)
	OUT  0x1B,R30
; 0001 006B 
; 0001 006C // Timer/Counter 0 Interrupt(s) initialization (compare A)
; 0001 006D TIMSK0=0x02;
	STS  110,R30
; 0001 006E // Timer/Counter 1 Interrupt(s) initialization (compare A + compare B)
; 0001 006F TIMSK1=0x06;
	LDI  R30,LOW(6)
	STS  111,R30
; 0001 0070 // Timer/Counter 2 Interrupt(s) initialization
; 0001 0071 TIMSK2=0x00;
	LDI  R30,LOW(0)
	STS  112,R30
; 0001 0072 
; 0001 0073 // USART initialization
; 0001 0074 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0001 0075 // USART Receiver: On
; 0001 0076 // USART Transmitter: On
; 0001 0077 // USART0 Mode: Asynchronous
; 0001 0078 // USART Baud Rate: 9600
; 0001 0079 UCSR0A=0x00;
	STS  192,R30
; 0001 007A UCSR0B=0xD8;
	LDI  R30,LOW(216)
	STS  193,R30
; 0001 007B UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0001 007C UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0001 007D UBRR0L=0x5F;
	LDI  R30,LOW(95)
	STS  196,R30
; 0001 007E 
; 0001 007F // Analog Comparator initialization
; 0001 0080 // Analog Comparator: Off
; 0001 0081 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0001 0082 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0001 0083 ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0001 0084 
; 0001 0085 // ADC initialization
; 0001 0086 // ADC Clock frequency: 115.200 kHz
; 0001 0087 // ADC Voltage Reference: AREF pin
; 0001 0088 // ADC Auto Trigger Source: None
; 0001 0089 // Digital input buffers on ADC0: Off, ADC1: Off, ADC2: Off, ADC3: Off
; 0001 008A // ADC4: On, ADC5: On
; 0001 008B //DIDR0=0x0F;
; 0001 008C //ADMUX=ADC_VREF_TYPE & 0xff;
; 0001 008D //ADCSRA=0x87;
; 0001 008E 
; 0001 008F // SPI initialization
; 0001 0090 // SPI Type: Master
; 0001 0091 // SPI Clock Rate: 2*3686.400 kHz
; 0001 0092 // SPI Clock Phase: Cycle Half
; 0001 0093 // SPI Clock Polarity: Low
; 0001 0094 // SPI Data Order: MSB First
; 0001 0095 SPCR=0x50;
	LDI  R30,LOW(80)
	OUT  0x2C,R30
; 0001 0096 SPSR=0x01;
	LDI  R30,LOW(1)
	OUT  0x2D,R30
; 0001 0097 
; 0001 0098 // Clear the SPI interrupt flag
; 0001 0099 #asm
; 0001 009A     in   r30,spsr
    in   r30,spsr
; 0001 009B     in   r30,spdr
    in   r30,spdr
; 0001 009C #endasm
; 0001 009D 
; 0001 009E // Global enable interrupts
; 0001 009F #asm("sei")
	sei
; 0001 00A0 
; 0001 00A1 }
	RET
;// set uart baudrate
;void SetBaud(char PD)
; 0001 00A4 {
_SetBaud:
; 0001 00A5     switch (PD)
;	PD -> Y+0
	LD   R30,Y
	LDI  R31,0
; 0001 00A6     {
; 0001 00A7         case 0:
	SBIW R30,0
	BRNE _0x20006
; 0001 00A8             UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0001 00A9             UBRR0L=0x07;
	LDI  R30,LOW(7)
	RJMP _0x20051
; 0001 00AA             break;
; 0001 00AB         case 1:
_0x20006:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x20007
; 0001 00AC             UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0001 00AD             UBRR0L=0x17;
	LDI  R30,LOW(23)
	RJMP _0x20051
; 0001 00AE             break;
; 0001 00AF         case 2:
_0x20007:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20008
; 0001 00B0             UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0001 00B1             UBRR0L=0x5F;
	LDI  R30,LOW(95)
	RJMP _0x20051
; 0001 00B2             break;
; 0001 00B3         case 3:
_0x20008:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20005
; 0001 00B4             UBRR0H=0x01;
	LDI  R30,LOW(1)
	STS  197,R30
; 0001 00B5             UBRR0L=0x7F;
	LDI  R30,LOW(127)
_0x20051:
	STS  196,R30
; 0001 00B6             break;
; 0001 00B7     }
_0x20005:
; 0001 00B8 }
	RJMP _0x2060004
;
;// read distance sensor
;unsigned int read_distance()
; 0001 00BC {
_read_distance:
; 0001 00BD     b_echo_back = 0;
	LDI  R30,LOW(0)
	STS  _b_echo_back,R30
; 0001 00BE     Timer_Count = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _Timer_Count,R30
	STS  _Timer_Count+1,R31
; 0001 00BF 
; 0001 00C0     PORTC.1 = 0;
	CBI  0x8,1
; 0001 00C1     delay_us(10);
	__DELAY_USB 49
; 0001 00C2 
; 0001 00C3     PORTC.1  = 1;
	SBI  0x8,1
; 0001 00C4     delay_us(10);
	__DELAY_USB 49
; 0001 00C5     PORTC.1 = 0;
	CBI  0x8,1
; 0001 00C6 
; 0001 00C7     PCICR=0x02;
	LDI  R30,LOW(2)
	STS  104,R30
; 0001 00C8     while(!b_echo_back);
_0x20010:
	LDS  R30,_b_echo_back
	CPI  R30,0
	BREQ _0x20010
; 0001 00C9     PCICR=0x00;
	LDI  R30,LOW(0)
	STS  104,R30
; 0001 00CA 
; 0001 00CB     if (Timer_Count) {PORTD ^= 0x04;}
	CALL SUBOPT_0x2
	SBIW R30,0
	BREQ _0x20013
	CALL SUBOPT_0x4
; 0001 00CC     return Timer_Count;
_0x20013:
	CALL SUBOPT_0x2
	RET
; 0001 00CD }
;
;// ACD obsoleted
;unsigned int read_adc(unsigned char adc_input)
; 0001 00D1 {
_read_adc:
; 0001 00D2 // set up ;
; 0001 00D3 DIDR0=0x0F;
;	adc_input -> Y+0
	LDI  R30,LOW(15)
	STS  126,R30
; 0001 00D4 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(0)
	STS  124,R30
; 0001 00D5 ADCSRA=0x87;
	LDI  R30,LOW(135)
	STS  122,R30
; 0001 00D6 
; 0001 00D7 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	LD   R30,Y
	LDI  R31,0
	STS  124,R30
; 0001 00D8 // Delay needed for the stabilization of the ADC input voltage
; 0001 00D9 delay_us(10);
	__DELAY_USB 49
; 0001 00DA // Start the AD conversion
; 0001 00DB ADCSRA|=0x40;
	CALL SUBOPT_0x12
	ORI  R30,0x40
	ST   X,R30
; 0001 00DC // Wait for the AD conversion to complete
; 0001 00DD while ((ADCSRA & 0x10)==0);
_0x20014:
	LDS  R30,122
	LDI  R31,0
	ANDI R30,LOW(0x10)
	BREQ _0x20014
; 0001 00DE ADCSRA|=0x10;
	CALL SUBOPT_0x12
	ORI  R30,0x10
	ST   X,R30
; 0001 00DF return ADCW;
	LDS  R30,120
	LDS  R31,120+1
_0x2060004:
	ADIW R28,1
	RET
; 0001 00E0 }
;
;
;void DebugLong(unsigned long var)
; 0001 00E4 {
; 0001 00E5     TCCR1B=0x00;
;	var -> Y+0
; 0001 00E6     SPDR = var&0xFF;while(!(SPSR>>7));
; 0001 00E7     BANK0_RCK = 1;BANK0_RCK = 0;
; 0001 00E8     SPDR = var>>8;while(!(SPSR>>7));
; 0001 00E9     BANK1_RCK = 1;BANK1_RCK = 0;
; 0001 00EA     SPDR = var>>16;while(!(SPSR>>7));
; 0001 00EB     BANK2_RCK = 1;BANK2_RCK = 0;
; 0001 00EC     SPDR = var>>24;while(!(SPSR>>7));
; 0001 00ED     BANK3_RCK = 1;BANK3_RCK = 0;
; 0001 00EE 
; 0001 00EF     while(1);
; 0001 00F0 }
;void DebugInt(unsigned int var)
; 0001 00F2 {
; 0001 00F3     TCCR1B=0x00;
;	var -> Y+0
; 0001 00F4     SPDR = var&0xFF;while(!(SPSR>>7));
; 0001 00F5     BANK0_RCK = 1;BANK0_RCK = 0;
; 0001 00F6     SPDR = var>>8;while(!(SPSR>>7));
; 0001 00F7     BANK1_RCK = 1;BANK1_RCK = 0;
; 0001 00F8 
; 0001 00F9     while(1);
; 0001 00FA }
;void DebugChar(unsigned char var)
; 0001 00FC {
; 0001 00FD     TCCR1B=0x00;
;	var -> Y+0
; 0001 00FE     SPDR = var&0xFF;while(!(SPSR>>7));
; 0001 00FF     BANK0_RCK = 1;BANK0_RCK = 0;
; 0001 0100 
; 0001 0101     while(1);
; 0001 0102 }
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
;unsigned char delay = 14;
;// number of edges including egdes wasn't included in SPI output
;unsigned char ctr;
;
;//*********************************************************************
;// Pulse width control routine                                       **
;//*********************************************************************
;//*********************************************************************
;// Initiate array
;//*********************************************************************
;void PW_Init()
; 0002 002B {

	.CSEG
_PW_Init:
; 0002 002C     int i;
; 0002 002D     // All channel: 1500 us= 2764 timer clock
; 0002 002E     // 2764 timer clock
; 0002 002F     PW_Time[0] = 2764-delay;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	CALL SUBOPT_0x13
	LDI  R26,LOW(2764)
	LDI  R27,HIGH(2764)
	SUB  R26,R30
	SBC  R27,R31
	STS  _PW_Time,R26
	STS  _PW_Time+1,R27
; 0002 0030     PW_Mask[0]  = 0xFFFFFFFF;
	__GETD1N 0xFFFFFFFF
	STS  _PW_Mask,R30
	STS  _PW_Mask+1,R31
	STS  _PW_Mask+2,R22
	STS  _PW_Mask+3,R23
; 0002 0031     PW_Width[0] = 1500;
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
	STS  _PW_Width,R30
	STS  _PW_Width+1,R31
; 0002 0032     // 1500 us
; 0002 0033     for (i=0;i<32;i++)
	__GETWRN 16,17,0
_0x40006:
	__CPWRN 16,17,32
	BRGE _0x40007
; 0002 0034     {
; 0002 0035         SV_Width[i] = 1500;
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
; 0002 0036     }
	__ADDWRN 16,17,1
	RJMP _0x40006
_0x40007:
; 0002 0037     // 1 edge
; 0002 0038     Edges_Ptr = 0;
	LDI  R30,LOW(0)
	STS  _Edges_Ptr,R30
; 0002 0039     Edges_Ctr = 1;
	LDI  R30,LOW(1)
	STS  _Edges_Ctr,R30
; 0002 003A 
; 0002 003B     // SPI at initial edge
; 0002 003C     PW_SPI_B0[0] = 0; PW_SPI_B2[0] = 0;
	LDI  R30,LOW(0)
	STS  _PW_SPI_B0,R30
	STS  _PW_SPI_B2,R30
; 0002 003D     PW_SPI_B1[0] = 0; PW_SPI_B3[0] = 0;
	STS  _PW_SPI_B1,R30
	STS  _PW_SPI_B3,R30
; 0002 003E     // SPI at 20ms tick
; 0002 003F     PW_SPI_B0[1] = 0xFF; PW_SPI_B2[1] = 0xFF;
	LDI  R30,LOW(255)
	__PUTB1MN _PW_SPI_B0,1
	__PUTB1MN _PW_SPI_B2,1
; 0002 0040     PW_SPI_B1[1] = 0xFF; PW_SPI_B3[1] = 0xFF;
	__PUTB1MN _PW_SPI_B1,1
	__PUTB1MN _PW_SPI_B3,1
; 0002 0041 
; 0002 0042 
; 0002 0043 
; 0002 0044 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;//*********************************************************************
;// Start sending signal: servo on
;//*********************************************************************
;void PW_Start()
; 0002 0049 {
_PW_Start:
; 0002 004A     OCR1BH = PW_Time[0]>>8;
	CALL SUBOPT_0x14
; 0002 004B     OCR1BL = PW_Time[0]&0xFF;
; 0002 004C     TCCR1B=0x02;
; 0002 004D }
	RET
;//*********************************************************************
;// Stop sending signal : servo off
;//*********************************************************************
;void PW_Stop()
; 0002 0052 {
_PW_Stop:
; 0002 0053     // stop clock
; 0002 0054     TCCR1B=0x00;
	LDI  R30,LOW(0)
	STS  129,R30
; 0002 0055     // send out put 0 all bank
; 0002 0056     SPDR= 0;
	OUT  0x2E,R30
; 0002 0057     while(!(SPSR>>7));
_0x40008:
	IN   R30,0x2D
	LDI  R31,0
	CALL __ASRW3
	CALL __ASRW4
	SBIW R30,0
	BREQ _0x40008
; 0002 0058     PORTB.1 = 1;PORTB.1 = 0;// pulse bank 0
	SBI  0x5,1
	CBI  0x5,1
; 0002 0059     PORTB.2 = 1;PORTB.2 = 0;// pulse bank 1
	SBI  0x5,2
	CBI  0x5,2
; 0002 005A     PORTD.6 = 1;PORTD.6 = 0;// pulse bank 2
	SBI  0xB,6
	CBI  0xB,6
; 0002 005B     PORTD.7 = 1;PORTD.7 = 0;// pulse bank 3
	SBI  0xB,7
	CBI  0xB,7
; 0002 005C }
	RET
;//*********************************************************************
;//  Update SPI output
;//*********************************************************************
;void PW_Update_SPI()
; 0002 0061 {
_PW_Update_SPI:
; 0002 0062     char i;
; 0002 0063     // PW_Stop
; 0002 0064     // stop clock
; 0002 0065     TCCR1B=0x00;
	ST   -Y,R17
;	i -> R17
	LDI  R30,LOW(0)
	STS  129,R30
; 0002 0066     // send out put 0 all bank
; 0002 0067 //    SPDR= 0;
; 0002 0068 //    while(!(SPSR>>7));
; 0002 0069 //    PORTB.1 = 1;PORTB.1 = 0;// pulse bank 0
; 0002 006A //    PORTB.2 = 1;PORTB.2 = 0;// pulse bank 1
; 0002 006B //    PORTD.6 = 1;PORTD.6 = 0;// pulse bank 2
; 0002 006C //    PORTD.7 = 1;PORTD.7 = 0;// pulse bank 3
; 0002 006D 
; 0002 006E     Edges_Ctr = ctr;
	LDS  R30,_ctr
	STS  _Edges_Ctr,R30
; 0002 006F     PW_SPI_B0[Edges_Ctr] = 0xFF; PW_SPI_B2[Edges_Ctr] = 0xFF;
	CALL SUBOPT_0x15
	SUBI R30,LOW(-_PW_SPI_B0)
	SBCI R31,HIGH(-_PW_SPI_B0)
	CALL SUBOPT_0x16
	SUBI R30,LOW(-_PW_SPI_B2)
	SBCI R31,HIGH(-_PW_SPI_B2)
	CALL SUBOPT_0x16
; 0002 0070     PW_SPI_B1[Edges_Ctr] = 0xFF; PW_SPI_B3[Edges_Ctr] = 0xFF;
	SUBI R30,LOW(-_PW_SPI_B1)
	SBCI R31,HIGH(-_PW_SPI_B1)
	CALL SUBOPT_0x16
	SUBI R30,LOW(-_PW_SPI_B3)
	SBCI R31,HIGH(-_PW_SPI_B3)
	CALL SUBOPT_0x16
; 0002 0071 
; 0002 0072     PW_SPI_B0[0] =  PW_SPI_B0[Edges_Ctr]^PW_Mask[0]>>0;
	SUBI R30,LOW(-_PW_SPI_B0)
	SBCI R31,HIGH(-_PW_SPI_B0)
	CALL SUBOPT_0x10
	MOVW R26,R30
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	STS  _PW_SPI_B0,R30
; 0002 0073     PW_SPI_B1[0] =  PW_SPI_B1[Edges_Ctr]^PW_Mask[0]>>8;
	CALL SUBOPT_0x15
	SUBI R30,LOW(-_PW_SPI_B1)
	SBCI R31,HIGH(-_PW_SPI_B1)
	CALL SUBOPT_0x10
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x19
	LDI  R30,LOW(8)
	CALL __LSRD12
	POP  R26
	POP  R27
	CALL SUBOPT_0x18
	STS  _PW_SPI_B1,R30
; 0002 0074     PW_SPI_B2[0] =  PW_SPI_B2[Edges_Ctr]^PW_Mask[0]>>16;
	CALL SUBOPT_0x15
	SUBI R30,LOW(-_PW_SPI_B2)
	SBCI R31,HIGH(-_PW_SPI_B2)
	CALL SUBOPT_0x10
	MOVW R26,R30
	CALL SUBOPT_0x17
	CALL __LSRD16
	CALL SUBOPT_0x18
	STS  _PW_SPI_B2,R30
; 0002 0075     PW_SPI_B3[0] =  PW_SPI_B3[Edges_Ctr]^PW_Mask[0]>>24;
	CALL SUBOPT_0x15
	SUBI R30,LOW(-_PW_SPI_B3)
	SBCI R31,HIGH(-_PW_SPI_B3)
	CALL SUBOPT_0x10
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x19
	LDI  R30,LOW(24)
	CALL __LSRD12
	POP  R26
	POP  R27
	CALL SUBOPT_0x18
	STS  _PW_SPI_B3,R30
; 0002 0076     PW_Time[0] =  1.8432f * (float)PW_Width[0] - delay;
	LDS  R30,_PW_Width
	LDS  R31,_PW_Width+1
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	LDI  R26,LOW(_PW_Time)
	LDI  R27,HIGH(_PW_Time)
	CALL __CFD1U
	ST   X+,R30
	ST   X,R31
; 0002 0077 
; 0002 0078     for (i=1;i<(Edges_Ctr);i++)
	LDI  R17,LOW(1)
_0x4001C:
	LDS  R30,_Edges_Ctr
	CP   R17,R30
	BRLO PC+3
	JMP _0x4001D
; 0002 0079     {
; 0002 007A         PW_SPI_B0[i] =  PW_SPI_B0[i-1]^PW_Mask[i]>>0;
	CALL SUBOPT_0x1D
	SUBI R30,LOW(-_PW_SPI_B0)
	SBCI R31,HIGH(-_PW_SPI_B0)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1
	CALL SUBOPT_0x1E
	SUBI R30,LOW(-_PW_SPI_B0)
	SBCI R31,HIGH(-_PW_SPI_B0)
	CALL SUBOPT_0x1F
	MOVW R26,R0
	CALL SUBOPT_0x18
	POP  R26
	POP  R27
	ST   X,R30
; 0002 007B         PW_SPI_B1[i] =  PW_SPI_B1[i-1]^PW_Mask[i]>>8;
	CALL SUBOPT_0x1D
	SUBI R30,LOW(-_PW_SPI_B1)
	SBCI R31,HIGH(-_PW_SPI_B1)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1
	CALL SUBOPT_0x1E
	SUBI R30,LOW(-_PW_SPI_B1)
	SBCI R31,HIGH(-_PW_SPI_B1)
	CALL SUBOPT_0x10
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x20
	LDI  R30,LOW(8)
	CALL __LSRD12
	POP  R26
	POP  R27
	CALL SUBOPT_0x18
	POP  R26
	POP  R27
	ST   X,R30
; 0002 007C         PW_SPI_B2[i] =  PW_SPI_B2[i-1]^PW_Mask[i]>>16;
	CALL SUBOPT_0x1D
	SUBI R30,LOW(-_PW_SPI_B2)
	SBCI R31,HIGH(-_PW_SPI_B2)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1
	CALL SUBOPT_0x1E
	SUBI R30,LOW(-_PW_SPI_B2)
	SBCI R31,HIGH(-_PW_SPI_B2)
	CALL SUBOPT_0x1F
	CALL __LSRD16
	MOVW R26,R0
	CALL SUBOPT_0x18
	POP  R26
	POP  R27
	ST   X,R30
; 0002 007D         PW_SPI_B3[i] =  PW_SPI_B3[i-1]^PW_Mask[i]>>24;
	CALL SUBOPT_0x1D
	SUBI R30,LOW(-_PW_SPI_B3)
	SBCI R31,HIGH(-_PW_SPI_B3)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1
	CALL SUBOPT_0x1E
	SUBI R30,LOW(-_PW_SPI_B3)
	SBCI R31,HIGH(-_PW_SPI_B3)
	CALL SUBOPT_0x10
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x20
	LDI  R30,LOW(24)
	CALL __LSRD12
	POP  R26
	POP  R27
	CALL SUBOPT_0x18
	POP  R26
	POP  R27
	ST   X,R30
; 0002 007E         PW_Time[i] =  1.8432f * (float)PW_Width[i] - delay;
	MOV  R30,R17
	LDI  R26,LOW(_PW_Time)
	LDI  R27,HIGH(_PW_Time)
	CALL SUBOPT_0x21
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOV  R30,R17
	CALL SUBOPT_0x22
	CALL SUBOPT_0x9
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	POP  R26
	POP  R27
	CALL __CFD1U
	ST   X+,R30
	ST   X,R31
; 0002 007F     }
	SUBI R17,-1
	RJMP _0x4001C
_0x4001D:
; 0002 0080 
; 0002 0081     // PW_Start
; 0002 0082     OCR1BH = PW_Time[0]>>8;
	CALL SUBOPT_0x14
; 0002 0083     OCR1BL = PW_Time[0]&0xFF;
; 0002 0084     TCCR1B=0x02;
; 0002 0085 }
_0x2060003:
	LD   R17,Y+
	RET
;//*********************************************************************
;//  Set new edge value
;//*********************************************************************
;void PW_Set(char channel, int width, char extend)
; 0002 008A {
_PW_Set:
; 0002 008B     char i,j ;
; 0002 008C     char pos ;
; 0002 008D     ctr = Edges_Ctr + extend;
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
; 0002 008E     SV_Width[channel] = width;
	LDD  R30,Y+7
	LDI  R26,LOW(_SV_Width)
	LDI  R27,HIGH(_SV_Width)
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
; 0002 008F     // clear old mask for this channel
; 0002 0090     i = 0;
	LDI  R17,LOW(0)
; 0002 0091     while (i < ctr)
_0x4001E:
	LDS  R30,_ctr
	CP   R17,R30
	BRLO PC+3
	JMP _0x40020
; 0002 0092     {
; 0002 0093         // clear old mask
; 0002 0094         PW_Mask[i] &= 0xFFFFFFFF^(1<<(long)channel);
	CALL SUBOPT_0x24
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
	CALL SUBOPT_0x25
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
; 0002 0095         // edge unused
; 0002 0096         if (PW_Mask[i] == 0)
	CALL SUBOPT_0x24
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	CALL __CPD10
	BRNE _0x40021
; 0002 0097         {
; 0002 0098             // push array to the left
; 0002 0099             for(j=i;j<ctr;j++)
	MOV  R16,R17
_0x40023:
	LDS  R30,_ctr
	CP   R16,R30
	BRSH _0x40024
; 0002 009A             {
; 0002 009B                 PW_Mask[j] = PW_Mask[j+1];
	MOV  R30,R16
	CALL SUBOPT_0x26
	MOVW R0,R30
	MOV  R26,R16
	CLR  R27
	CALL __MULW2_4
	__ADDW2MN _PW_Mask,4
	CALL __GETD1P
	MOVW R26,R0
	CALL __PUTDP1
; 0002 009C                 PW_Width[j] = PW_Width[j+1];
	MOV  R30,R16
	CALL SUBOPT_0x22
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
; 0002 009D             }
	SUBI R16,-1
	RJMP _0x40023
_0x40024:
; 0002 009E             // update counter
; 0002 009F             ctr--;
	LDS  R30,_ctr
	SUBI R30,LOW(1)
	STS  _ctr,R30
; 0002 00A0         }
; 0002 00A1         else
	RJMP _0x40025
_0x40021:
; 0002 00A2         {
; 0002 00A3             i++;
	SUBI R17,-1
; 0002 00A4         }
_0x40025:
; 0002 00A5     }
	RJMP _0x4001E
_0x40020:
; 0002 00A6     // get position to insert
; 0002 00A7     pos = 0;
	LDI  R19,LOW(0)
; 0002 00A8     while (pos < ctr)
_0x40026:
	LDS  R30,_ctr
	CP   R19,R30
	BRLO PC+3
	JMP _0x40028
; 0002 00A9     {
; 0002 00AA         // duplicated edge
; 0002 00AB         if (width == PW_Width[pos])
	MOV  R30,R19
	CALL SUBOPT_0x22
	CALL SUBOPT_0x9
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x40029
; 0002 00AC         {
; 0002 00AD             PW_Mask[pos] |= 1<<(long)channel;
	MOV  R30,R19
	CALL SUBOPT_0x26
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x25
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ORD12
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0002 00AE             return;
	RJMP _0x2060002
; 0002 00AF         }
; 0002 00B0         // new edge less than max time
; 0002 00B1         if (width < PW_Width[pos])
_0x40029:
	MOV  R30,R19
	CALL SUBOPT_0x22
	CALL SUBOPT_0x9
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x4002A
; 0002 00B2         {
; 0002 00B3             // push time array to the right
; 0002 00B4             for (i= ctr;i>pos;i--)
	LDS  R17,_ctr
_0x4002C:
	CP   R19,R17
	BRSH _0x4002D
; 0002 00B5             {
; 0002 00B6                 PW_Width[i] = PW_Width[i-1];
	MOV  R30,R17
	CALL SUBOPT_0x22
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0x1
	CALL SUBOPT_0x1E
	LDI  R26,LOW(_PW_Width)
	LDI  R27,HIGH(_PW_Width)
	LSL  R30
	ROL  R31
	CALL SUBOPT_0x9
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
; 0002 00B7                 PW_Mask[i] = PW_Mask[i-1];
	CALL SUBOPT_0x24
	ADD  R30,R26
	ADC  R31,R27
	MOVW R24,R30
	CALL SUBOPT_0x1
	CALL SUBOPT_0x1E
	LDI  R26,LOW(_PW_Mask)
	LDI  R27,HIGH(_PW_Mask)
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	MOVW R26,R24
	CALL __PUTDP1
; 0002 00B8             }
	SUBI R17,1
	RJMP _0x4002C
_0x4002D:
; 0002 00B9             // set value at new edge
; 0002 00BA             PW_Width[pos] = width;
	MOV  R30,R19
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
; 0002 00BB             PW_Mask[pos] = 1<<(long)channel;
	MOV  R30,R19
	RJMP _0x2060001
; 0002 00BC             // update counter
; 0002 00BD             ctr++;
; 0002 00BE             return;
; 0002 00BF         }
; 0002 00C0 
; 0002 00C1         pos++;
_0x4002A:
	SUBI R19,-1
; 0002 00C2     }
	RJMP _0x40026
_0x40028:
; 0002 00C3     // new max time edge
; 0002 00C4     // set value at new edge
; 0002 00C5     PW_Width[ctr] = width;
	LDS  R30,_ctr
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
; 0002 00C6     PW_Mask[ctr] = 1<<(long)channel;
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
	CALL SUBOPT_0x25
	POP  R26
	POP  R27
	CALL __PUTDP1
; 0002 00C7     // update counter
; 0002 00C8     ctr++;
	LDS  R30,_ctr
	SUBI R30,-LOW(1)
	STS  _ctr,R30
; 0002 00C9 }
_0x2060002:
	CALL __LOADLOCR4
	ADIW R28,8
	RET
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
;char Max(char* arr,char length)
; 0003 0006 {

	.CSEG
_Max:
; 0003 0007     char i, max = arr[0];
; 0003 0008     for (i=0;i<length;i++)
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
; 0003 0009     {
; 0003 000A         if (max < arr[i])
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CP   R16,R30
	BRSH _0x60006
; 0003 000B         {
; 0003 000C             max = arr[i];
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R16,X
; 0003 000D         }
; 0003 000E     }
_0x60006:
	SUBI R17,-1
	RJMP _0x60004
_0x60005:
; 0003 000F     return max;
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; 0003 0010 }
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
_Timer_Count:
	.BYTE 0x2
_b_echo_back:
	.BYTE 0x1
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
_SP_Interval:
	.BYTE 0x20
_Interval:
	.BYTE 0x1
_i:
	.BYTE 0x1
_j:
	.BYTE 0x1
_channel:
	.BYTE 0x1
_tmp:
	.BYTE 0x1
_adc:
	.BYTE 0x2
_distance:
	.BYTE 0x2
_delay:
	.BYTE 0x1
_ctr:
	.BYTE 0x1
_p_S1020024:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	MOV  R26,R17
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDS  R30,_Timer_Count
	LDS  R31,_Timer_Count+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	CALL _getchar
	STS  _cmd,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	IN   R30,0xB
	LDI  R31,0
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	EOR  R30,R26
	EOR  R31,R27
	OUT  0xB,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(_CMD_Time)
	LDI  R27,HIGH(_CMD_Time)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDS  R30,_CMD_Count
	LDS  R26,_i
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDS  R30,_i
	LDI  R31,0
	SUBI R30,LOW(-_CMD_Channel)
	SBCI R31,HIGH(-_CMD_Channel)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDS  R30,_i
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x9:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	LDS  R30,_i
	SUBI R30,-LOW(1)
	STS  _i,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB:
	STS  _channel,R30
	LDI  R26,LOW(_SV_Width)
	LDI  R27,HIGH(_SV_Width)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X+
	LD   R1,X
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	LDS  R30,_i
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xE:
	LDS  R30,_channel
	LDI  R26,LOW(_SV_Width)
	LDI  R27,HIGH(_SV_Width)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	MOVW R26,R0
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __DIVW21U
	MOVW R26,R22
	ST   X,R30
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x10:
	LD   R30,Z
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x11:
	LDS  R30,_j
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(122)
	LDI  R27,HIGH(122)
	LD   R30,X
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDS  R30,_delay
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x14:
	LDS  R30,_PW_Time+1
	STS  139,R30
	LDS  R30,_PW_Time
	LDS  R31,_PW_Time+1
	STS  138,R30
	LDI  R30,LOW(2)
	STS  129,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x15:
	LDS  R30,_Edges_Ctr
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDI  R26,LOW(255)
	STD  Z+0,R26
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	LDS  R30,_PW_Mask
	LDS  R31,_PW_Mask+1
	LDS  R22,_PW_Mask+2
	LDS  R23,_PW_Mask+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x18:
	CALL __CWD2
	CALL __XORD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	LDS  R26,_PW_Mask
	LDS  R27,_PW_Mask+1
	LDS  R24,_PW_Mask+2
	LDS  R25,_PW_Mask+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	__GETD2N 0x3FEBEDFA
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	RCALL SUBOPT_0x1A
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1F:
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
SUBOPT_0x20:
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
SUBOPT_0x21:
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x22:
	LDI  R26,LOW(_PW_Width)
	LDI  R27,HIGH(_PW_Width)
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x24:
	MOV  R30,R17
	LDI  R26,LOW(_PW_Mask)
	LDI  R27,HIGH(_PW_Mask)
	LDI  R31,0
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x25:
	LDD  R30,Y+7
	LDI  R31,0
	CALL __CWD1
	__GETD2N 0x1
	CALL __LSLD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x26:
	LDI  R26,LOW(_PW_Mask)
	LDI  R27,HIGH(_PW_Mask)
	LDI  R31,0
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xE66
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

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

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
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
