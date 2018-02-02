
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 1.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
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
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
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

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
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

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
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

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
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
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
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

	.MACRO __PUTBSR
	STD  Y+@1,R@0
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
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
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
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
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
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
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
	.DEF _turn=R4
	.DEF _turn_msb=R5
	.DEF _c_end=R6
	.DEF _c_end_msb=R7
	.DEF _p1=R8
	.DEF _p1_msb=R9
	.DEF _p2=R10
	.DEF _p2_msb=R11
	.DEF _round=R12
	.DEF _round_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

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

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5F,0x0,0x0,0x0,0x7
	.DB  0x0,0x7,0x0,0x14,0x7F,0x14,0x7F,0x14
	.DB  0x24,0x2A,0x7F,0x2A,0x12,0x23,0x13,0x8
	.DB  0x64,0x62,0x36,0x49,0x55,0x22,0x50,0x0
	.DB  0x5,0x3,0x0,0x0,0x0,0x1C,0x22,0x41
	.DB  0x0,0x0,0x41,0x22,0x1C,0x0,0x8,0x2A
	.DB  0x1C,0x2A,0x8,0x8,0x8,0x3E,0x8,0x8
	.DB  0x0,0x50,0x30,0x0,0x0,0x8,0x8,0x8
	.DB  0x8,0x8,0x0,0x30,0x30,0x0,0x0,0x20
	.DB  0x10,0x8,0x4,0x2,0x3E,0x51,0x49,0x45
	.DB  0x3E,0x0,0x42,0x7F,0x40,0x0,0x42,0x61
	.DB  0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31
	.DB  0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45
	.DB  0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x1
	.DB  0x71,0x9,0x5,0x3,0x36,0x49,0x49,0x49
	.DB  0x36,0x6,0x49,0x49,0x29,0x1E,0x0,0x36
	.DB  0x36,0x0,0x0,0x0,0x56,0x36,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x14,0x14,0x14
	.DB  0x14,0x14,0x41,0x22,0x14,0x8,0x0,0x2
	.DB  0x1,0x51,0x9,0x6,0x32,0x49,0x79,0x41
	.DB  0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49
	.DB  0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22
	.DB  0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49
	.DB  0x49,0x41,0x7F,0x9,0x9,0x1,0x1,0x3E
	.DB  0x41,0x41,0x51,0x32,0x7F,0x8,0x8,0x8
	.DB  0x7F,0x0,0x41,0x7F,0x41,0x0,0x20,0x40
	.DB  0x41,0x3F,0x1,0x7F,0x8,0x14,0x22,0x41
	.DB  0x7F,0x40,0x40,0x40,0x40,0x7F,0x2,0x4
	.DB  0x2,0x7F,0x7F,0x4,0x8,0x10,0x7F,0x3E
	.DB  0x41,0x41,0x41,0x3E,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x9
	.DB  0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31
	.DB  0x1,0x1,0x7F,0x1,0x1,0x3F,0x40,0x40
	.DB  0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F
	.DB  0x20,0x18,0x20,0x7F,0x63,0x14,0x8,0x14
	.DB  0x63,0x3,0x4,0x78,0x4,0x3,0x61,0x51
	.DB  0x49,0x45,0x43,0x0,0x0,0x7F,0x41,0x41
	.DB  0x2,0x4,0x8,0x10,0x20,0x41,0x41,0x7F
	.DB  0x0,0x0,0x4,0x2,0x1,0x2,0x4,0x40
	.DB  0x40,0x40,0x40,0x40,0x0,0x1,0x2,0x4
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x7F,0x48
	.DB  0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20
	.DB  0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54
	.DB  0x54,0x18,0x8,0x7E,0x9,0x1,0x2,0x8
	.DB  0x14,0x54,0x54,0x3C,0x7F,0x8,0x4,0x4
	.DB  0x78,0x0,0x44,0x7D,0x40,0x0,0x20,0x40
	.DB  0x44,0x3D,0x0,0x0,0x7F,0x10,0x28,0x44
	.DB  0x0,0x41,0x7F,0x40,0x0,0x7C,0x4,0x18
	.DB  0x4,0x78,0x7C,0x8,0x4,0x4,0x78,0x38
	.DB  0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14
	.DB  0x8,0x8,0x14,0x14,0x18,0x7C,0x7C,0x8
	.DB  0x4,0x4,0x8,0x48,0x54,0x54,0x54,0x20
	.DB  0x4,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40
	.DB  0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C
	.DB  0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28
	.DB  0x44,0xC,0x50,0x50,0x50,0x3C,0x44,0x64
	.DB  0x54,0x4C,0x44,0x0,0x8,0x36,0x41,0x0
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0x41,0x36
	.DB  0x8,0x0,0x2,0x1,0x2,0x4,0x2,0x7F
	.DB  0x41,0x41,0x41,0x7F
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x0:
	.DB  0x50,0x31,0x0,0x30,0x0,0x50,0x32,0x0
	.DB  0x52,0x0,0x54,0x75,0x72,0x6E,0x3A,0x20
	.DB  0x0,0x58,0x0,0x4F,0x0,0x58,0x4F,0x20
	.DB  0x62,0x79,0x20,0x54,0x26,0x4D,0x0,0x50
	.DB  0x6C,0x61,0x79,0x65,0x72,0x20,0x31,0x20
	.DB  0x57,0x69,0x6E,0x73,0x20,0x21,0x0,0x50
	.DB  0x6C,0x61,0x79,0x65,0x72,0x20,0x32,0x20
	.DB  0x57,0x69,0x6E,0x73,0x20,0x21,0x0,0x21
	.DB  0x20,0x44,0x72,0x61,0x77,0x20,0x21,0x0
	.DB  0x33,0x0,0x34,0x0,0x35,0x0,0x4F,0x20
	.DB  0x77,0x69,0x6E,0x73,0x21,0x0,0x58,0x20
	.DB  0x77,0x69,0x6E,0x0
_0x20C0060:
	.DB  0x1
_0x20C0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  __seed_G106
	.DW  _0x20C0060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*
; *
; * Author: T&M
; */
;#include <glcd.h>
;#include <font5x7.h>
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;int turn = 0; // 0 -> X , 1 -> O;
;int table[3][3];
;int c_end = 0;
;int p1=0;
;int p2=0;
;int round = 0;
;
;
;
;void config_LCD(){
; 0000 0013 void config_LCD(){

	.CSEG
_config_LCD:
; .FSTART _config_LCD
; 0000 0014     GLCDINIT_t glcd_init_data;
; 0000 0015     glcd_init_data.font=font5x7;
	SBIW R28,6
;	glcd_init_data -> Y+0
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0016     glcd_init(&glcd_init_data);
	MOVW R26,R28
	CALL _glcd_init
; 0000 0017 }
	ADIW R28,6
	RET
; .FEND
;
;void config_Ports(){
; 0000 0019 void config_Ports(){
_config_Ports:
; .FSTART _config_Ports
; 0000 001A     DDRC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 001B     PORTC = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 001C     DDRD = 0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 001D     PORTD = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 001E }
	RET
; .FEND
;
;void reset(){
; 0000 0020 void reset(){
_reset:
; .FSTART _reset
; 0000 0021 
; 0000 0022     int i,j;
; 0000 0023     c_end = 0 ;
	CALL __SAVELOCR4
;	i -> R16,R17
;	j -> R18,R19
	CLR  R6
	CLR  R7
; 0000 0024     //turn=0;
; 0000 0025     p1 = 0;
	CLR  R8
	CLR  R9
; 0000 0026     p2 = 0;
	CLR  R10
	CLR  R11
; 0000 0027     round = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 0028 
; 0000 0029 
; 0000 002A     glcd_clear();
	CALL _glcd_clear
; 0000 002B 
; 0000 002C 
; 0000 002D 
; 0000 002E 
; 0000 002F     glcd_line(21,0,21,63);
	CALL SUBOPT_0x0
; 0000 0030     glcd_line(0,21,63,21);
; 0000 0031     glcd_line(42,0,42,63);
; 0000 0032     glcd_line(0,42,63,42);
; 0000 0033 
; 0000 0034     glcd_outtextxyf(80,0,"P1");
	CALL SUBOPT_0x1
; 0000 0035     glcd_outtextxyf(80,10,"0");
	CALL SUBOPT_0x2
	CALL _glcd_outtextxyf
; 0000 0036     glcd_outtextxyf(100,0,"P2");
	CALL SUBOPT_0x3
; 0000 0037     glcd_outtextxyf(100,10,"0");
	CALL SUBOPT_0x4
	CALL _glcd_outtextxyf
; 0000 0038     glcd_outtextxyf(120,0,"R");
	CALL SUBOPT_0x5
; 0000 0039     glcd_outtextxyf(120,10,"1");
	CALL SUBOPT_0x6
	CALL _glcd_outtextxyf
; 0000 003A 
; 0000 003B     glcd_outtextxyf(80,20,"Turn: ");
	LDI  R30,LOW(80)
	ST   -Y,R30
	CALL SUBOPT_0x7
; 0000 003C 
; 0000 003D     if(turn==0){
	BRNE _0x3
; 0000 003E     glcd_outtextxyf(110,20,"X");
	CALL SUBOPT_0x8
	__POINTW2FN _0x0,17
	RJMP _0xAF
; 0000 003F     }
; 0000 0040     else{
_0x3:
; 0000 0041     glcd_outtextxyf(110,20,"O");
	CALL SUBOPT_0x8
	__POINTW2FN _0x0,19
_0xAF:
	CALL _glcd_outtextxyf
; 0000 0042     }
; 0000 0043 
; 0000 0044 
; 0000 0045     // clear table
; 0000 0046     for(i=0;i<3;i++){
	__GETWRN 16,17,0
_0x6:
	__CPWRN 16,17,3
	BRGE _0x7
; 0000 0047     for(j=0;j<3;j++){
	__GETWRN 18,19,0
_0x9:
	__CPWRN 18,19,3
	BRGE _0xA
; 0000 0048         table[i][j] = 2 ;
	CALL SUBOPT_0x9
; 0000 0049         }
	__ADDWRN 18,19,1
	RJMP _0x9
_0xA:
; 0000 004A     }
	__ADDWRN 16,17,1
	RJMP _0x6
_0x7:
; 0000 004B 
; 0000 004C     glcd_outtextxyf(70,56,"XO by T&M");
	CALL SUBOPT_0xA
; 0000 004D }
	RJMP _0x210000B
; .FEND
;
;void reset_without_Button(){
; 0000 004F void reset_without_Button(){
_reset_without_Button:
; .FSTART _reset_without_Button
; 0000 0050 
; 0000 0051     int i,j;
; 0000 0052     c_end = 0 ;
	CALL __SAVELOCR4
;	i -> R16,R17
;	j -> R18,R19
	CLR  R6
	CLR  R7
; 0000 0053     //turn=0;
; 0000 0054 
; 0000 0055     if (round <=5){
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R12
	CPC  R31,R13
	BRLT _0xB
; 0000 0056         round += 1;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 0057 
; 0000 0058             glcd_clear();
	CALL _glcd_clear
; 0000 0059 
; 0000 005A             glcd_outtextxyf(80,0,"P1");
	LDI  R30,LOW(80)
	ST   -Y,R30
	CALL SUBOPT_0x1
; 0000 005B             glcd_outtextxyf(100,0,"P2");
	CALL SUBOPT_0x3
; 0000 005C             glcd_outtextxyf(120,0,"R");
	CALL SUBOPT_0x5
; 0000 005D 
; 0000 005E 
; 0000 005F 
; 0000 0060             glcd_line(21,0,21,63);
	CALL SUBOPT_0x0
; 0000 0061             glcd_line(0,21,63,21);
; 0000 0062             glcd_line(42,0,42,63);
; 0000 0063             glcd_line(0,42,63,42);
; 0000 0064 
; 0000 0065             glcd_outtextxyf(80,20,"Turn: ");
	CALL SUBOPT_0x7
; 0000 0066 
; 0000 0067             if(turn==0){
	BRNE _0xC
; 0000 0068             glcd_outtextxyf(110,20,"X");
	CALL SUBOPT_0x8
	__POINTW2FN _0x0,17
	RJMP _0xB0
; 0000 0069             }
; 0000 006A             else{
_0xC:
; 0000 006B             glcd_outtextxyf(110,20,"O");
	CALL SUBOPT_0x8
	__POINTW2FN _0x0,19
_0xB0:
	CALL _glcd_outtextxyf
; 0000 006C             }
; 0000 006D 
; 0000 006E     // clear table
; 0000 006F     for(i=0;i<3;i++){
	__GETWRN 16,17,0
_0xF:
	__CPWRN 16,17,3
	BRGE _0x10
; 0000 0070     for(j=0;j<3;j++){
	__GETWRN 18,19,0
_0x12:
	__CPWRN 18,19,3
	BRGE _0x13
; 0000 0071         table[i][j] = 2 ;
	CALL SUBOPT_0x9
; 0000 0072         }
	__ADDWRN 18,19,1
	RJMP _0x12
_0x13:
; 0000 0073     }
	__ADDWRN 16,17,1
	RJMP _0xF
_0x10:
; 0000 0074 
; 0000 0075     glcd_outtextxyf(70,56,"XO by T&M");
	CALL SUBOPT_0xA
; 0000 0076 
; 0000 0077     }
; 0000 0078 
; 0000 0079 
; 0000 007A 
; 0000 007B 
; 0000 007C     if(round == 6){
_0xB:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x14
; 0000 007D         if(p1>p2){
	__CPWRR 10,11,8,9
	BRGE _0x15
; 0000 007E             glcd_clear();
	CALL SUBOPT_0xB
; 0000 007F             glcd_outtextxyf(20,32,"Player 1 Wins !");
	__POINTW2FN _0x0,31
	CALL SUBOPT_0xC
; 0000 0080             delay_ms(2000);
; 0000 0081         }
; 0000 0082         if(p1<p2){
_0x15:
	__CPWRR 8,9,10,11
	BRGE _0x16
; 0000 0083             glcd_clear();
	CALL SUBOPT_0xB
; 0000 0084             glcd_outtextxyf(20,32,"Player 2 Wins !");
	__POINTW2FN _0x0,47
	CALL SUBOPT_0xC
; 0000 0085             delay_ms(2000);
; 0000 0086         }
; 0000 0087         if(p1==p2) {
_0x16:
	__CPWRR 10,11,8,9
	BRNE _0x17
; 0000 0088             glcd_clear();
	CALL _glcd_clear
; 0000 0089             glcd_outtextxyf(50,32,"! Draw !");
	CALL SUBOPT_0xD
	__POINTW2FN _0x0,63
	CALL SUBOPT_0xC
; 0000 008A             delay_ms(2000);
; 0000 008B         }
; 0000 008C 
; 0000 008D         reset();
_0x17:
	RCALL _reset
; 0000 008E     }
; 0000 008F 
; 0000 0090 
; 0000 0091 
; 0000 0092 
; 0000 0093 }
_0x14:
_0x210000B:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;
;
;void scores(char winner)
; 0000 0097 {
_scores:
; .FSTART _scores
; 0000 0098     if(winner == 'X'){
	ST   -Y,R26
;	winner -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x58)
	BRNE _0x18
; 0000 0099         p1 += 1 ;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 009A     }
; 0000 009B     if(winner == 'O'){
_0x18:
	LD   R26,Y
	CPI  R26,LOW(0x4F)
	BRNE _0x19
; 0000 009C         p2 += 1 ;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 009D     }
; 0000 009E 
; 0000 009F 
; 0000 00A0     reset_without_Button();
_0x19:
	RCALL _reset_without_Button
; 0000 00A1 
; 0000 00A2 
; 0000 00A3     switch (p1) {
	MOVW R30,R8
; 0000 00A4     case 0:
	SBIW R30,0
	BRNE _0x1D
; 0000 00A5             glcd_outtextxyf(80,10,"0");
	CALL SUBOPT_0x2
	RJMP _0xB1
; 0000 00A6     break;
; 0000 00A7 
; 0000 00A8     case 1:
_0x1D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1E
; 0000 00A9             glcd_outtextxyf(80,10,"1");
	CALL SUBOPT_0xE
	__POINTW2FN _0x0,1
	RJMP _0xB1
; 0000 00AA     break;
; 0000 00AB     case 2:
_0x1E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1F
; 0000 00AC             glcd_outtextxyf(80,10,"2");
	CALL SUBOPT_0xE
	__POINTW2FN _0x0,6
	RJMP _0xB1
; 0000 00AD     break;
; 0000 00AE     case 3:
_0x1F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20
; 0000 00AF             glcd_outtextxyf(80,10,"3");
	CALL SUBOPT_0xE
	__POINTW2FN _0x0,72
	RJMP _0xB1
; 0000 00B0     break;
; 0000 00B1     case 4:
_0x20:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x1C
; 0000 00B2             glcd_outtextxyf(80,10,"4");
	CALL SUBOPT_0xE
	__POINTW2FN _0x0,74
_0xB1:
	CALL _glcd_outtextxyf
; 0000 00B3     break;
; 0000 00B4     };
_0x1C:
; 0000 00B5 
; 0000 00B6     switch (p2) {
	MOVW R30,R10
; 0000 00B7     case 0:
	SBIW R30,0
	BRNE _0x25
; 0000 00B8             glcd_outtextxyf(100,10,"0");
	CALL SUBOPT_0x4
	RJMP _0xB2
; 0000 00B9     break;
; 0000 00BA 
; 0000 00BB     case 1:
_0x25:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x26
; 0000 00BC             glcd_outtextxyf(100,10,"1");
	CALL SUBOPT_0xF
	__POINTW2FN _0x0,1
	RJMP _0xB2
; 0000 00BD     break;
; 0000 00BE     case 2:
_0x26:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x27
; 0000 00BF             glcd_outtextxyf(100,10,"2");
	CALL SUBOPT_0xF
	__POINTW2FN _0x0,6
	RJMP _0xB2
; 0000 00C0     break;
; 0000 00C1     case 3:
_0x27:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x28
; 0000 00C2             glcd_outtextxyf(100,10,"3");
	CALL SUBOPT_0xF
	__POINTW2FN _0x0,72
	RJMP _0xB2
; 0000 00C3     break;
; 0000 00C4     case 4:
_0x28:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x24
; 0000 00C5             glcd_outtextxyf(100,10,"4");
	CALL SUBOPT_0xF
	__POINTW2FN _0x0,74
_0xB2:
	CALL _glcd_outtextxyf
; 0000 00C6     break;
; 0000 00C7     };
_0x24:
; 0000 00C8 
; 0000 00C9 
; 0000 00CA     switch(round) {
	MOVW R30,R12
; 0000 00CB     case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2D
; 0000 00CC             glcd_outtextxyf(120,10,"1");
	CALL SUBOPT_0x6
	RJMP _0xB3
; 0000 00CD     break;
; 0000 00CE 
; 0000 00CF     case 2:
_0x2D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2E
; 0000 00D0             glcd_outtextxyf(120,10,"2");
	CALL SUBOPT_0x10
	__POINTW2FN _0x0,6
	RJMP _0xB3
; 0000 00D1     break;
; 0000 00D2     case 3:
_0x2E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2F
; 0000 00D3             glcd_outtextxyf(120,10,"3");
	CALL SUBOPT_0x10
	__POINTW2FN _0x0,72
	RJMP _0xB3
; 0000 00D4     break;
; 0000 00D5     case 4:
_0x2F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x30
; 0000 00D6             glcd_outtextxyf(120,10,"4");
	CALL SUBOPT_0x10
	__POINTW2FN _0x0,74
	RJMP _0xB3
; 0000 00D7     break;
; 0000 00D8     case 5:
_0x30:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x2C
; 0000 00D9             glcd_outtextxyf(120,10,"5");
	CALL SUBOPT_0x10
	__POINTW2FN _0x0,76
_0xB3:
	CALL _glcd_outtextxyf
; 0000 00DA     break;
; 0000 00DB 
; 0000 00DC     };
_0x2C:
; 0000 00DD 
; 0000 00DE 
; 0000 00DF 
; 0000 00E0 
; 0000 00E1 }
	JMP  _0x210000A
; .FEND
;
;void draw_winner_line(int x1, int y1, int x2, int y2)
; 0000 00E4 {
_draw_winner_line:
; .FSTART _draw_winner_line
; 0000 00E5     glcd_line(x1,y1,x2,y2);
	ST   -Y,R27
	ST   -Y,R26
;	x1 -> Y+6
;	y1 -> Y+4
;	x2 -> Y+2
;	y2 -> Y+0
	LDD  R30,Y+6
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+3
	CALL _glcd_line
; 0000 00E6 }
	ADIW R28,8
	RET
; .FEND
;
;void check_win(int t[3][3]){
; 0000 00E8 void check_win(int t[3][3]){
_check_win:
; .FSTART _check_win
; 0000 00E9     if((t[2][2]== 0 && t[0][0]==0 && t[1][1]== 0) || (t[2][2]==1 && t[0][0]==1 && t[1][1]==1) )
	CALL SUBOPT_0x11
;	t -> Y+0
	ADIW R26,16
	CALL __GETW1P
	SBIW R30,0
	BRNE _0x33
	CALL SUBOPT_0x12
	SBIW R30,0
	BRNE _0x33
	CALL SUBOPT_0x13
	SBIW R30,0
	BREQ _0x35
_0x33:
	CALL SUBOPT_0x14
	SBIW R30,1
	BRNE _0x36
	CALL SUBOPT_0x12
	SBIW R30,1
	BRNE _0x36
	CALL SUBOPT_0x13
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ _0x35
_0x36:
	RJMP _0x32
_0x35:
; 0000 00EA    {
; 0000 00EB         draw_winner_line(8,8,55,55);
	CALL SUBOPT_0x15
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 00EC         delay_ms(500);
; 0000 00ED         glcd_clear();
; 0000 00EE         if(turn==0){
	BRNE _0x39
; 0000 00EF               glcd_outtextxyf(50,32,"O wins!");
	CALL SUBOPT_0xD
	CALL SUBOPT_0x18
; 0000 00F0               scores('O');
	RJMP _0xB4
; 0000 00F1               delay_ms(500);
; 0000 00F2               //reset_without_Button();
; 0000 00F3         }
; 0000 00F4         else{
_0x39:
; 0000 00F5         glcd_outtextxyf(50,32,"X win");
	CALL SUBOPT_0xD
	CALL SUBOPT_0x19
; 0000 00F6         scores('X');
_0xB4:
	RCALL _scores
; 0000 00F7         delay_ms(500);
	CALL SUBOPT_0x1A
; 0000 00F8         //reset_without_Button();
; 0000 00F9         }
; 0000 00FA    }
; 0000 00FB 
; 0000 00FC 
; 0000 00FD    if((t[0][2]== 0 && t[0][0]==0 && t[0][1]== 0) || (t[0][2]==1 && t[0][0]==1 && t[0][1]==1))
_0x32:
	CALL SUBOPT_0x1B
	SBIW R30,0
	BRNE _0x3C
	CALL SUBOPT_0x12
	SBIW R30,0
	BRNE _0x3C
	CALL SUBOPT_0x1C
	SBIW R30,0
	BREQ _0x3E
_0x3C:
	CALL SUBOPT_0x1B
	SBIW R30,1
	BRNE _0x3F
	CALL SUBOPT_0x12
	SBIW R30,1
	BRNE _0x3F
	CALL SUBOPT_0x1C
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ _0x3E
_0x3F:
	RJMP _0x3B
_0x3E:
; 0000 00FE    {
; 0000 00FF         draw_winner_line(10,10,55,10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x16
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _draw_winner_line
; 0000 0100         delay_ms(500);
	CALL SUBOPT_0x1A
; 0000 0101         glcd_clear();
	CALL _glcd_clear
; 0000 0102         if(turn==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x42
; 0000 0103               glcd_outtextxyf(50,32,"O wins!");
	CALL SUBOPT_0xD
	CALL SUBOPT_0x18
; 0000 0104               scores('O');
	RJMP _0xB5
; 0000 0105         delay_ms(500);
; 0000 0106         //reset();
; 0000 0107         }
; 0000 0108         else{
_0x42:
; 0000 0109         glcd_outtextxyf(50,32,"X win");
	CALL SUBOPT_0xD
	CALL SUBOPT_0x19
; 0000 010A         scores('X');
_0xB5:
	RCALL _scores
; 0000 010B         delay_ms(500);
	CALL SUBOPT_0x1A
; 0000 010C         //reset();
; 0000 010D         }
; 0000 010E 
; 0000 010F    }
; 0000 0110 
; 0000 0111 
; 0000 0112    if((t[2][0]== 0 && t[1][0]==0 && t[0][0]== 0) || (t[2][0]==1 && t[1][0]==1 && t[0][0]==1))
_0x3B:
	CALL SUBOPT_0x1D
	SBIW R30,0
	BRNE _0x45
	CALL SUBOPT_0x1E
	SBIW R30,0
	BRNE _0x45
	CALL SUBOPT_0x12
	SBIW R30,0
	BREQ _0x47
_0x45:
	CALL SUBOPT_0x1D
	SBIW R30,1
	BRNE _0x48
	CALL SUBOPT_0x1E
	SBIW R30,1
	BRNE _0x48
	CALL SUBOPT_0x12
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ _0x47
_0x48:
	RJMP _0x44
_0x47:
; 0000 0113    {
; 0000 0114         draw_winner_line(8,8,8,55);
	CALL SUBOPT_0x15
	CALL SUBOPT_0x15
	CALL SUBOPT_0x15
	CALL SUBOPT_0x17
; 0000 0115         delay_ms(500);
; 0000 0116         glcd_clear();
; 0000 0117         if(turn==0){
	BRNE _0x4B
; 0000 0118         glcd_outtextxyf(50,32,"O wins!");
	CALL SUBOPT_0xD
	CALL SUBOPT_0x18
; 0000 0119         scores('O');
	RJMP _0xB6
; 0000 011A         delay_ms(500);
; 0000 011B         //reset();
; 0000 011C         }
; 0000 011D         else{
_0x4B:
; 0000 011E         glcd_outtextxyf(50,32,"X win");
	CALL SUBOPT_0xD
	CALL SUBOPT_0x19
; 0000 011F         scores('X');
_0xB6:
	RCALL _scores
; 0000 0120         delay_ms(500);
	CALL SUBOPT_0x1A
; 0000 0121         //reset();
; 0000 0122         }
; 0000 0123 
; 0000 0124    }
; 0000 0125 
; 0000 0126 
; 0000 0127 
; 0000 0128 
; 0000 0129    if(t[1][0]==t[1][1] && t[1][1]==t[1][2])
_0x44:
	LD   R30,Y
	LDD  R31,Y+1
	__GETWRZ 0,1,6
	CALL SUBOPT_0x13
	CP   R30,R0
	CPC  R31,R1
	BRNE _0x4E
	CALL SUBOPT_0x1F
	ADIW R26,10
	CALL SUBOPT_0x20
	BREQ _0x4F
_0x4E:
	RJMP _0x4D
_0x4F:
; 0000 012A    {
; 0000 012B         if(t[1][0]!= 2)
	CALL SUBOPT_0x1E
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ _0x50
; 0000 012C         {
; 0000 012D             draw_winner_line(8,32,55,32);
	CALL SUBOPT_0x15
	CALL SUBOPT_0x21
	CALL SUBOPT_0x16
	LDI  R26,LOW(32)
	LDI  R27,0
	RCALL _draw_winner_line
; 0000 012E             delay_ms(500);
	CALL SUBOPT_0x1A
; 0000 012F             glcd_clear();
	CALL _glcd_clear
; 0000 0130             if(turn==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x51
; 0000 0131                   glcd_outtextxyf(50,32,"O wins!");
	CALL SUBOPT_0xD
	CALL SUBOPT_0x18
; 0000 0132             scores('O');
	RJMP _0xB7
; 0000 0133             delay_ms(500);
; 0000 0134             //reset();
; 0000 0135             }
; 0000 0136             else{
_0x51:
; 0000 0137             glcd_outtextxyf(50,32,"X win");
	CALL SUBOPT_0xD
	CALL SUBOPT_0x19
; 0000 0138             scores('X');
_0xB7:
	RCALL _scores
; 0000 0139             delay_ms(500);
	CALL SUBOPT_0x1A
; 0000 013A             //reset();
; 0000 013B             }
; 0000 013C         }
; 0000 013D    }
_0x50:
; 0000 013E 
; 0000 013F 
; 0000 0140    if(t[2][0]==t[2][1] && t[2][1]==t[2][2])
_0x4D:
	LD   R30,Y
	LDD  R31,Y+1
	__GETWRZ 0,1,12
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,14
	CALL SUBOPT_0x20
	BRNE _0x54
	LD   R30,Y
	LDD  R31,Y+1
	__GETWRZ 0,1,14
	CALL SUBOPT_0x14
	CP   R30,R0
	CPC  R31,R1
	BREQ _0x55
_0x54:
	RJMP _0x53
_0x55:
; 0000 0141    {
; 0000 0142         if(t[2][0]!= 2)
	CALL SUBOPT_0x1D
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ _0x56
; 0000 0143         {
; 0000 0144             draw_winner_line(8,55,55,55);
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0145             delay_ms(500);
; 0000 0146             glcd_clear();
; 0000 0147             if(turn==0){
	BRNE _0x57
; 0000 0148             glcd_outtextxyf(50,32,"O wins!");
	CALL SUBOPT_0xD
	CALL SUBOPT_0x18
; 0000 0149             scores('O');
	RJMP _0xB8
; 0000 014A             delay_ms(500);
; 0000 014B             //reset();
; 0000 014C             }
; 0000 014D             else{
_0x57:
; 0000 014E             glcd_outtextxyf(50,32,"X win");
	CALL SUBOPT_0xD
	CALL SUBOPT_0x19
; 0000 014F             scores('X');
_0xB8:
	RCALL _scores
; 0000 0150             delay_ms(500);
	CALL SUBOPT_0x1A
; 0000 0151             //reset();
; 0000 0152             }
; 0000 0153         }
; 0000 0154    }
_0x56:
; 0000 0155 
; 0000 0156 
; 0000 0157    if(t[0][1]==t[1][1] && t[1][1]==t[2][1])
_0x53:
	LD   R30,Y
	LDD  R31,Y+1
	__GETWRZ 0,1,2
	CALL SUBOPT_0x13
	CP   R30,R0
	CPC  R31,R1
	BRNE _0x5A
	CALL SUBOPT_0x1F
	ADIW R26,14
	CALL SUBOPT_0x20
	BREQ _0x5B
_0x5A:
	RJMP _0x59
_0x5B:
; 0000 0158    {
; 0000 0159         if(t[0][1]!= 2)
	CALL SUBOPT_0x1C
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ _0x5C
; 0000 015A         {
; 0000 015B             draw_winner_line(32,8,32,55);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x15
	CALL SUBOPT_0x21
	CALL SUBOPT_0x17
; 0000 015C             delay_ms(500);
; 0000 015D             glcd_clear();
; 0000 015E             if(turn==0){
	BRNE _0x5D
; 0000 015F             glcd_outtextxyf(50,32,"O wins!");
	CALL SUBOPT_0xD
	CALL SUBOPT_0x18
; 0000 0160             scores('O');
	RJMP _0xB9
; 0000 0161             delay_ms(500);
; 0000 0162             //reset();
; 0000 0163             }
; 0000 0164             else{
_0x5D:
; 0000 0165             glcd_outtextxyf(50,32,"X win");
	CALL SUBOPT_0xD
	CALL SUBOPT_0x19
; 0000 0166             scores('X');
_0xB9:
	RCALL _scores
; 0000 0167             delay_ms(500);
	CALL SUBOPT_0x1A
; 0000 0168             //reset();
; 0000 0169             }
; 0000 016A         }
; 0000 016B    }
_0x5C:
; 0000 016C 
; 0000 016D 
; 0000 016E    if(t[0][2]==t[1][2] && t[1][2]==t[2][2])
_0x59:
	LD   R30,Y
	LDD  R31,Y+1
	__GETWRZ 0,1,4
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,10
	CALL SUBOPT_0x20
	BRNE _0x60
	LD   R30,Y
	LDD  R31,Y+1
	__GETWRZ 0,1,10
	CALL SUBOPT_0x14
	CP   R30,R0
	CPC  R31,R1
	BREQ _0x61
_0x60:
	RJMP _0x5F
_0x61:
; 0000 016F    {
; 0000 0170         if(t[0][2]!= 2)
	CALL SUBOPT_0x1B
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ _0x62
; 0000 0171         {
; 0000 0172             draw_winner_line(55,8,55,55);
	CALL SUBOPT_0x16
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0173             delay_ms(500);
; 0000 0174             glcd_clear();
; 0000 0175             if(turn==0){
	BRNE _0x63
; 0000 0176             glcd_outtextxyf(50,32,"O wins!");
	CALL SUBOPT_0xD
	CALL SUBOPT_0x18
; 0000 0177             scores('O');
	RJMP _0xBA
; 0000 0178             delay_ms(500);
; 0000 0179             //reset();
; 0000 017A             }
; 0000 017B             else{
_0x63:
; 0000 017C             glcd_outtextxyf(50,32,"X win");
	CALL SUBOPT_0xD
	CALL SUBOPT_0x19
; 0000 017D             scores('X');
_0xBA:
	RCALL _scores
; 0000 017E             delay_ms(500);
	CALL SUBOPT_0x1A
; 0000 017F             //reset();
; 0000 0180             }
; 0000 0181         }
; 0000 0182    }
_0x62:
; 0000 0183 
; 0000 0184 
; 0000 0185    if(t[0][2]==t[1][1] && t[1][1]==t[2][0])
_0x5F:
	LD   R30,Y
	LDD  R31,Y+1
	__GETWRZ 0,1,4
	CALL SUBOPT_0x13
	CP   R30,R0
	CPC  R31,R1
	BRNE _0x66
	LD   R30,Y
	LDD  R31,Y+1
	__GETWRZ 0,1,8
	CALL SUBOPT_0x1D
	CP   R30,R0
	CPC  R31,R1
	BREQ _0x67
_0x66:
	RJMP _0x65
_0x67:
; 0000 0186    {
; 0000 0187 
; 0000 0188         if(t[0][2]!= 2)
	CALL SUBOPT_0x1B
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ _0x68
; 0000 0189         {
; 0000 018A             draw_winner_line(55,8,8,55);
	CALL SUBOPT_0x16
	CALL SUBOPT_0x15
	CALL SUBOPT_0x15
	CALL SUBOPT_0x17
; 0000 018B             delay_ms(500);
; 0000 018C             glcd_clear();
; 0000 018D             if(turn==0){
	BRNE _0x69
; 0000 018E             glcd_outtextxyf(50,32,"O wins!");
	CALL SUBOPT_0xD
	CALL SUBOPT_0x18
; 0000 018F             scores('O');
	RJMP _0xBB
; 0000 0190             delay_ms(500);
; 0000 0191             //reset();
; 0000 0192             }
; 0000 0193             else{
_0x69:
; 0000 0194             glcd_outtextxyf(50,32,"X win");
	CALL SUBOPT_0xD
	CALL SUBOPT_0x19
; 0000 0195             scores('X');
_0xBB:
	RCALL _scores
; 0000 0196             delay_ms(500);
	CALL SUBOPT_0x1A
; 0000 0197             //reset();
; 0000 0198             }
; 0000 0199         }
; 0000 019A    }
_0x68:
; 0000 019B }
_0x65:
	ADIW R28,2
	RET
; .FEND
;
;void newInput(int table[3][3],int i1, int i2 ){
; 0000 019D void newInput(int table[3][3],int i1, int i2 ){
_newInput:
; .FSTART _newInput
; 0000 019E     if(i1 != 255 ){
	ST   -Y,R27
	ST   -Y,R26
;	table -> Y+4
;	i1 -> Y+2
;	i2 -> Y+0
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xFF)
	LDI  R30,HIGH(0xFF)
	CPC  R27,R30
	BRNE PC+2
	RJMP _0x6B
; 0000 019F         if(i1 == 254) // Button 0,0
	CPI  R26,LOW(0xFE)
	LDI  R30,HIGH(0xFE)
	CPC  R27,R30
	BRNE _0x6C
; 0000 01A0         {
; 0000 01A1             if(table[0][0]== 2)
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0x22
	BRNE _0x6D
; 0000 01A2             {
; 0000 01A3              table[0][0] = turn;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X+,R4
	ST   X,R5
; 0000 01A4 
; 0000 01A5              if(turn==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x6E
; 0000 01A6                 glcd_outtextxyf(10,10,"X");//write input
	LDI  R30,LOW(10)
	CALL SUBOPT_0x23
; 0000 01A7                 glcd_outtextxyf(110,20,"O");// write turn
	__POINTW2FN _0x0,19
	RJMP _0xBC
; 0000 01A8 
; 0000 01A9                 delay_ms(500);
; 0000 01AA              }
; 0000 01AB              else{
_0x6E:
; 0000 01AC                 glcd_outtextxyf(10,10,"O");//write input
	LDI  R30,LOW(10)
	CALL SUBOPT_0x24
; 0000 01AD                 glcd_outtextxyf(110,20,"X");// write turn
	__POINTW2FN _0x0,17
_0xBC:
	CALL _glcd_outtextxyf
; 0000 01AE                 delay_ms(500);
	CALL SUBOPT_0x1A
; 0000 01AF              }
; 0000 01B0              if(turn==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x70
; 0000 01B1                 turn = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 01B2              }
; 0000 01B3              else{
	RJMP _0x71
_0x70:
; 0000 01B4                 turn = 0;
	CLR  R4
	CLR  R5
; 0000 01B5              }
_0x71:
; 0000 01B6              c_end += 1;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 01B7             }
; 0000 01B8         }     // end Button
_0x6D:
; 0000 01B9 
; 0000 01BA         if(i1 == 253) // Button 0,1
_0x6C:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xFD)
	LDI  R30,HIGH(0xFD)
	CPC  R27,R30
	BRNE _0x72
; 0000 01BB         {
; 0000 01BC             if(table[0][1]== 2)
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,2
	CALL SUBOPT_0x22
	BRNE _0x73
; 0000 01BD             {
; 0000 01BE              table[0][1] = turn;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__PUTWZR 4,5,2
; 0000 01BF 
; 0000 01C0              if(turn==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x74
; 0000 01C1                 glcd_outtextxyf(31,10,"X");
	LDI  R30,LOW(31)
	CALL SUBOPT_0x23
; 0000 01C2                 glcd_outtextxyf(110,20,"O");// write turn
	__POINTW2FN _0x0,19
	RJMP _0xBD
; 0000 01C3 
; 0000 01C4                 delay_ms(500);
; 0000 01C5              }
; 0000 01C6              else{
_0x74:
; 0000 01C7                 glcd_outtextxyf(31,10,"O");
	LDI  R30,LOW(31)
	CALL SUBOPT_0x24
; 0000 01C8                 glcd_outtextxyf(110,20,"X");// write turn
	__POINTW2FN _0x0,17
_0xBD:
	CALL _glcd_outtextxyf
; 0000 01C9                 delay_ms(500);
	CALL SUBOPT_0x1A
; 0000 01CA              }
; 0000 01CB              if(turn==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x76
; 0000 01CC                 turn = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 01CD              }
; 0000 01CE              else{
	RJMP _0x77
_0x76:
; 0000 01CF                 turn = 0;
	CLR  R4
	CLR  R5
; 0000 01D0              }
_0x77:
; 0000 01D1              c_end += 1;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 01D2             }
; 0000 01D3         }     // end Button
_0x73:
; 0000 01D4 
; 0000 01D5 
; 0000 01D6         if(i1 == 251) // Button 0,2
_0x72:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRNE _0x78
; 0000 01D7         {
; 0000 01D8             if(table[0][2]== 2)
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,4
	CALL SUBOPT_0x22
	BRNE _0x79
; 0000 01D9             {
; 0000 01DA              table[0][2] = turn;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__PUTWZR 4,5,4
; 0000 01DB 
; 0000 01DC              if(turn==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x7A
; 0000 01DD                 glcd_outtextxyf(52,10,"X");
	LDI  R30,LOW(52)
	CALL SUBOPT_0x23
; 0000 01DE                 glcd_outtextxyf(110,20,"O");// write turn
	__POINTW2FN _0x0,19
	RJMP _0xBE
; 0000 01DF 
; 0000 01E0                 delay_ms(500);
; 0000 01E1              }
; 0000 01E2              else{
_0x7A:
; 0000 01E3                 glcd_outtextxyf(52,10,"O");
	LDI  R30,LOW(52)
	CALL SUBOPT_0x24
; 0000 01E4                 glcd_outtextxyf(110,20,"X");// write turn
	__POINTW2FN _0x0,17
_0xBE:
	CALL _glcd_outtextxyf
; 0000 01E5                 delay_ms(500);
	CALL SUBOPT_0x1A
; 0000 01E6              }
; 0000 01E7              if(turn==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x7C
; 0000 01E8                 turn = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 01E9              }
; 0000 01EA              else{
	RJMP _0x7D
_0x7C:
; 0000 01EB                 turn = 0;
	CLR  R4
	CLR  R5
; 0000 01EC              }
_0x7D:
; 0000 01ED              c_end += 1;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 01EE             }
; 0000 01EF         }     // end Button
_0x79:
; 0000 01F0 
; 0000 01F1 
; 0000 01F2         if(i1 == 247) // Button 1,0
_0x78:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xF7)
	LDI  R30,HIGH(0xF7)
	CPC  R27,R30
	BRNE _0x7E
; 0000 01F3         {
; 0000 01F4             if(table[1][0]== 2)
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,6
	CALL SUBOPT_0x22
	BRNE _0x7F
; 0000 01F5             {
; 0000 01F6              table[1][0] = turn;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__PUTWZR 4,5,6
; 0000 01F7 
; 0000 01F8              if(turn==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x80
; 0000 01F9                 glcd_outtextxyf(10,32,"X");
	LDI  R30,LOW(10)
	CALL SUBOPT_0x25
; 0000 01FA                 glcd_outtextxyf(110,20,"O");// write turn
	__POINTW2FN _0x0,19
	RJMP _0xBF
; 0000 01FB 
; 0000 01FC                 delay_ms(500);
; 0000 01FD              }
; 0000 01FE              else{
_0x80:
; 0000 01FF                 glcd_outtextxyf(10,32,"O");
	LDI  R30,LOW(10)
	CALL SUBOPT_0x26
; 0000 0200                 glcd_outtextxyf(110,20,"X");// write turn
	__POINTW2FN _0x0,17
_0xBF:
	CALL _glcd_outtextxyf
; 0000 0201                 delay_ms(500);
	CALL SUBOPT_0x1A
; 0000 0202              }
; 0000 0203              if(turn==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x82
; 0000 0204                 turn = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 0205              }
; 0000 0206              else{
	RJMP _0x83
_0x82:
; 0000 0207                 turn = 0;
	CLR  R4
	CLR  R5
; 0000 0208              }
_0x83:
; 0000 0209              c_end += 1;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 020A             }
; 0000 020B         }     // end Button
_0x7F:
; 0000 020C 
; 0000 020D 
; 0000 020E 
; 0000 020F         if(i1 == 239) // Button 1,1
_0x7E:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xEF)
	LDI  R30,HIGH(0xEF)
	CPC  R27,R30
	BRNE _0x84
; 0000 0210         {
; 0000 0211             if(table[1][1]== 2)
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,8
	CALL SUBOPT_0x22
	BRNE _0x85
; 0000 0212             {
; 0000 0213              table[1][1] = turn;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__PUTWZR 4,5,8
; 0000 0214 
; 0000 0215              if(turn==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x86
; 0000 0216                 glcd_outtextxyf(32,32,"X");
	LDI  R30,LOW(32)
	CALL SUBOPT_0x25
; 0000 0217                 glcd_outtextxyf(110,20,"O");// write turn
	__POINTW2FN _0x0,19
	RJMP _0xC0
; 0000 0218 
; 0000 0219                 delay_ms(500);
; 0000 021A              }
; 0000 021B              else{
_0x86:
; 0000 021C                 glcd_outtextxyf(32,32,"O");
	LDI  R30,LOW(32)
	CALL SUBOPT_0x26
; 0000 021D                 glcd_outtextxyf(110,20,"X");// write turn
	__POINTW2FN _0x0,17
_0xC0:
	CALL _glcd_outtextxyf
; 0000 021E                 delay_ms(500);
	CALL SUBOPT_0x1A
; 0000 021F              }
; 0000 0220              if(turn==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x88
; 0000 0221                 turn = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 0222              }
; 0000 0223              else{
	RJMP _0x89
_0x88:
; 0000 0224                 turn = 0;
	CLR  R4
	CLR  R5
; 0000 0225              }
_0x89:
; 0000 0226              c_end += 1;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0227             }
; 0000 0228         }     // end Button
_0x85:
; 0000 0229 
; 0000 022A 
; 0000 022B         if(i1 == 223) // Button 1,2
_0x84:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xDF)
	LDI  R30,HIGH(0xDF)
	CPC  R27,R30
	BRNE _0x8A
; 0000 022C         {
; 0000 022D             if(table[1][2]== 2)
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,10
	CALL SUBOPT_0x22
	BRNE _0x8B
; 0000 022E             {
; 0000 022F              table[1][2] = turn;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__PUTWZR 4,5,10
; 0000 0230 
; 0000 0231              if(turn==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x8C
; 0000 0232                 glcd_outtextxyf(53,32,"X");
	LDI  R30,LOW(53)
	CALL SUBOPT_0x25
; 0000 0233                 glcd_outtextxyf(110,20,"O");// write turn
	__POINTW2FN _0x0,19
	RJMP _0xC1
; 0000 0234 
; 0000 0235                 delay_ms(500);
; 0000 0236              }
; 0000 0237              else{
_0x8C:
; 0000 0238                 glcd_outtextxyf(53,32,"O");
	LDI  R30,LOW(53)
	CALL SUBOPT_0x26
; 0000 0239                 glcd_outtextxyf(110,20,"X");// write turn
	__POINTW2FN _0x0,17
_0xC1:
	CALL _glcd_outtextxyf
; 0000 023A                 delay_ms(500);
	CALL SUBOPT_0x1A
; 0000 023B              }
; 0000 023C              if(turn==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x8E
; 0000 023D                 turn = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 023E              }
; 0000 023F              else{
	RJMP _0x8F
_0x8E:
; 0000 0240                 turn = 0;
	CLR  R4
	CLR  R5
; 0000 0241              }
_0x8F:
; 0000 0242              c_end += 1;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0243             }
; 0000 0244         }     // end Button
_0x8B:
; 0000 0245 
; 0000 0246 
; 0000 0247 
; 0000 0248         if(i1 == 191) // Button 2,0
_0x8A:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xBF)
	LDI  R30,HIGH(0xBF)
	CPC  R27,R30
	BRNE _0x90
; 0000 0249         {
; 0000 024A             if(table[2][0]== 2)
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,12
	CALL SUBOPT_0x22
	BRNE _0x91
; 0000 024B             {
; 0000 024C              table[2][0] = turn;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__PUTWZR 4,5,12
; 0000 024D 
; 0000 024E              if(turn==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x92
; 0000 024F                 glcd_outtextxyf(10,52,"X");
	LDI  R30,LOW(10)
	CALL SUBOPT_0x27
; 0000 0250                 glcd_outtextxyf(110,20,"O");// write turn
	__POINTW2FN _0x0,19
	RJMP _0xC2
; 0000 0251 
; 0000 0252                 delay_ms(500);
; 0000 0253              }
; 0000 0254              else{
_0x92:
; 0000 0255                 glcd_outtextxyf(10,52,"O");
	LDI  R30,LOW(10)
	CALL SUBOPT_0x28
; 0000 0256                 glcd_outtextxyf(110,20,"X");// write turn
	__POINTW2FN _0x0,17
_0xC2:
	CALL _glcd_outtextxyf
; 0000 0257                 delay_ms(500);
	CALL SUBOPT_0x1A
; 0000 0258              }
; 0000 0259              if(turn==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x94
; 0000 025A                 turn = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 025B              }
; 0000 025C              else{
	RJMP _0x95
_0x94:
; 0000 025D                 turn = 0;
	CLR  R4
	CLR  R5
; 0000 025E              }
_0x95:
; 0000 025F              c_end += 1;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0260             }
; 0000 0261         }     // end Button
_0x91:
; 0000 0262 
; 0000 0263 
; 0000 0264 
; 0000 0265         if(i1 == 127) // Button 2,1
_0x90:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x7F)
	LDI  R30,HIGH(0x7F)
	CPC  R27,R30
	BRNE _0x96
; 0000 0266         {
; 0000 0267             if(table[2][1]== 2)
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,14
	CALL SUBOPT_0x22
	BRNE _0x97
; 0000 0268             {
; 0000 0269              table[2][1] = turn;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__PUTWZR 4,5,14
; 0000 026A 
; 0000 026B              if(turn==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x98
; 0000 026C                 glcd_outtextxyf(32,52,"X");
	LDI  R30,LOW(32)
	CALL SUBOPT_0x27
; 0000 026D                 glcd_outtextxyf(110,20,"O");// write turn
	__POINTW2FN _0x0,19
	RJMP _0xC3
; 0000 026E 
; 0000 026F                 delay_ms(500);
; 0000 0270              }
; 0000 0271              else{
_0x98:
; 0000 0272                 glcd_outtextxyf(32,52,"O");
	LDI  R30,LOW(32)
	CALL SUBOPT_0x28
; 0000 0273                 glcd_outtextxyf(110,20,"X");// write turn
	__POINTW2FN _0x0,17
_0xC3:
	CALL _glcd_outtextxyf
; 0000 0274                 delay_ms(500);
	CALL SUBOPT_0x1A
; 0000 0275              }
; 0000 0276              if(turn==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x9A
; 0000 0277                 turn = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 0278              }
; 0000 0279              else{
	RJMP _0x9B
_0x9A:
; 0000 027A                 turn = 0;
	CLR  R4
	CLR  R5
; 0000 027B              }
_0x9B:
; 0000 027C              c_end += 1;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 027D             }
; 0000 027E         }     // end Button
_0x97:
; 0000 027F 
; 0000 0280 
; 0000 0281     }   // end of portC
_0x96:
; 0000 0282 
; 0000 0283 
; 0000 0284     if(i2 != 255 ){
_0x6B:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFF)
	LDI  R30,HIGH(0xFF)
	CPC  R27,R30
	BREQ _0x9C
; 0000 0285 
; 0000 0286         if(i2 == 254) // Button 2,2
	CPI  R26,LOW(0xFE)
	LDI  R30,HIGH(0xFE)
	CPC  R27,R30
	BRNE _0x9D
; 0000 0287         {
; 0000 0288             if(table[2][2]== 2)
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,16
	CALL SUBOPT_0x22
	BRNE _0x9E
; 0000 0289             {
; 0000 028A              table[2][2] = turn;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__PUTWZR 4,5,16
; 0000 028B 
; 0000 028C              if(turn==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x9F
; 0000 028D                 glcd_outtextxyf(52,52,"X");
	LDI  R30,LOW(52)
	CALL SUBOPT_0x27
; 0000 028E                 glcd_outtextxyf(110,20,"O");// write turn
	__POINTW2FN _0x0,19
	RJMP _0xC4
; 0000 028F 
; 0000 0290                 delay_ms(500);
; 0000 0291              }
; 0000 0292              else{
_0x9F:
; 0000 0293                 glcd_outtextxyf(52,52,"O");
	LDI  R30,LOW(52)
	CALL SUBOPT_0x28
; 0000 0294                 glcd_outtextxyf(110,20,"X");// write turn
	__POINTW2FN _0x0,17
_0xC4:
	CALL _glcd_outtextxyf
; 0000 0295                 delay_ms(500);
	CALL SUBOPT_0x1A
; 0000 0296              }
; 0000 0297              if(turn==0){
	MOV  R0,R4
	OR   R0,R5
	BRNE _0xA1
; 0000 0298                 turn = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 0299              }
; 0000 029A              else{
	RJMP _0xA2
_0xA1:
; 0000 029B                 turn = 0;
	CLR  R4
	CLR  R5
; 0000 029C              }
_0xA2:
; 0000 029D              c_end += 1;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 029E             }
; 0000 029F         }     // end Button
_0x9E:
; 0000 02A0 
; 0000 02A1 
; 0000 02A2         if(i2 == 253) // Button reset
_0x9D:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFD)
	LDI  R30,HIGH(0xFD)
	CPC  R27,R30
	BRNE _0xA3
; 0000 02A3         {
; 0000 02A4             reset();
	RCALL _reset
; 0000 02A5         }     // end Button
; 0000 02A6     }
_0xA3:
; 0000 02A7     check_win(table);
_0x9C:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL _check_win
; 0000 02A8 }
	RJMP _0x2100009
; .FEND
;
;void main(void)
; 0000 02AB {
_main:
; .FSTART _main
; 0000 02AC 
; 0000 02AD int input1,input2;
; 0000 02AE 
; 0000 02AF 
; 0000 02B0 config_LCD();
;	input1 -> R16,R17
;	input2 -> R18,R19
	RCALL _config_LCD
; 0000 02B1 config_Ports();
	RCALL _config_Ports
; 0000 02B2 
; 0000 02B3 while (1)
_0xA4:
; 0000 02B4     {
; 0000 02B5     round = -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R12,R30
; 0000 02B6     reset();
	RCALL _reset
; 0000 02B7 
; 0000 02B8     while(c_end<= 9){
_0xA7:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R6
	CPC  R31,R7
	BRLT _0xA9
; 0000 02B9 
; 0000 02BA         input1 = PINC;
	IN   R16,19
	CLR  R17
; 0000 02BB         input2 = PIND;
	IN   R18,16
	CLR  R19
; 0000 02BC 
; 0000 02BD         if(input1!=255 || input2 !=255){
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0xAB
	CP   R30,R18
	CPC  R31,R19
	BREQ _0xAA
_0xAB:
; 0000 02BE             newInput(table,input1 , input2 );
	LDI  R30,LOW(_table)
	LDI  R31,HIGH(_table)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R18
	RCALL _newInput
; 0000 02BF         }
; 0000 02C0 
; 0000 02C1         if(c_end == 9)
_0xAA:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0xAD
; 0000 02C2         {
; 0000 02C3             glcd_clear();
	RCALL _glcd_clear
; 0000 02C4             //glcd_outtextxyf(10,32,"!!! PLAY AGAIN !!!");
; 0000 02C5             scores('');
	LDI  R26,LOW(0)
	RCALL _scores
; 0000 02C6             delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 02C7 
; 0000 02C8         }
; 0000 02C9 }
_0xAD:
	RJMP _0xA7
_0xA9:
; 0000 02CA }
	RJMP _0xA4
; 0000 02CB }
_0xAE:
	RJMP _0xAE
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_ks0108_enable_G100:
; .FSTART _ks0108_enable_G100
	nop
	SBI  0x18,0
	nop
	RET
; .FEND
_ks0108_disable_G100:
; .FSTART _ks0108_disable_G100
	CBI  0x18,0
	CBI  0x18,4
	CBI  0x18,5
	RET
; .FEND
_ks0108_rdbus_G100:
; .FSTART _ks0108_rdbus_G100
	ST   -Y,R17
	RCALL _ks0108_enable_G100
	IN   R17,25
	CBI  0x18,0
	MOV  R30,R17
	LD   R17,Y+
	RET
; .FEND
_ks0108_busy_G100:
; .FSTART _ks0108_busy_G100
	ST   -Y,R26
	ST   -Y,R17
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	SBI  0x18,1
	CBI  0x18,2
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	MOV  R17,R30
	SBRS R17,0
	RJMP _0x2000003
	SBI  0x18,4
	RJMP _0x2000004
_0x2000003:
	CBI  0x18,4
_0x2000004:
	SBRS R17,1
	RJMP _0x2000005
	SBI  0x18,5
	RJMP _0x2000006
_0x2000005:
	CBI  0x18,5
_0x2000006:
_0x2000007:
	RCALL _ks0108_rdbus_G100
	ANDI R30,LOW(0x80)
	BRNE _0x2000007
	LDD  R17,Y+0
	JMP  _0x2100003
; .FEND
_ks0108_wrcmd_G100:
; .FSTART _ks0108_wrcmd_G100
	ST   -Y,R26
	LDD  R26,Y+1
	RCALL _ks0108_busy_G100
	CALL SUBOPT_0x29
	JMP  _0x2100003
; .FEND
_ks0108_setloc_G100:
; .FSTART _ks0108_setloc_G100
	__GETB1MN _ks0108_coord_G100,1
	ST   -Y,R30
	LDS  R30,_ks0108_coord_G100
	ANDI R30,LOW(0x3F)
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G100
	__GETB1MN _ks0108_coord_G100,1
	ST   -Y,R30
	__GETB1MN _ks0108_coord_G100,2
	ORI  R30,LOW(0xB8)
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G100
	RET
; .FEND
_ks0108_gotoxp_G100:
; .FSTART _ks0108_gotoxp_G100
	ST   -Y,R26
	LDD  R30,Y+1
	STS  _ks0108_coord_G100,R30
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	__PUTB1MN _ks0108_coord_G100,1
	LD   R30,Y
	__PUTB1MN _ks0108_coord_G100,2
	RCALL _ks0108_setloc_G100
	JMP  _0x2100003
; .FEND
_ks0108_nextx_G100:
; .FSTART _ks0108_nextx_G100
	LDS  R26,_ks0108_coord_G100
	SUBI R26,-LOW(1)
	STS  _ks0108_coord_G100,R26
	CPI  R26,LOW(0x80)
	BRLO _0x200000A
	LDI  R30,LOW(0)
	STS  _ks0108_coord_G100,R30
_0x200000A:
	LDS  R30,_ks0108_coord_G100
	ANDI R30,LOW(0x3F)
	BRNE _0x200000B
	LDS  R30,_ks0108_coord_G100
	ST   -Y,R30
	__GETB2MN _ks0108_coord_G100,2
	RCALL _ks0108_gotoxp_G100
_0x200000B:
	RET
; .FEND
_ks0108_wrdata_G100:
; .FSTART _ks0108_wrdata_G100
	ST   -Y,R26
	__GETB2MN _ks0108_coord_G100,1
	RCALL _ks0108_busy_G100
	SBI  0x18,2
	CALL SUBOPT_0x29
_0x210000A:
	ADIW R28,1
	RET
; .FEND
_ks0108_rddata_G100:
; .FSTART _ks0108_rddata_G100
	__GETB2MN _ks0108_coord_G100,1
	RCALL _ks0108_busy_G100
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	SBI  0x18,1
	SBI  0x18,2
	RCALL _ks0108_rdbus_G100
	RET
; .FEND
_ks0108_rdbyte_G100:
; .FSTART _ks0108_rdbyte_G100
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	CALL SUBOPT_0x2A
	RCALL _ks0108_rddata_G100
	RCALL _ks0108_setloc_G100
	RCALL _ks0108_rddata_G100
	JMP  _0x2100003
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	SBI  0x17,0
	SBI  0x17,1
	SBI  0x17,2
	SBI  0x17,3
	SBI  0x18,3
	SBI  0x17,4
	SBI  0x17,5
	RCALL _ks0108_disable_G100
	CBI  0x18,3
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x18,3
	LDI  R17,LOW(0)
_0x200000C:
	CPI  R17,2
	BRSH _0x200000E
	ST   -Y,R17
	LDI  R26,LOW(63)
	RCALL _ks0108_wrcmd_G100
	ST   -Y,R17
	INC  R17
	LDI  R26,LOW(192)
	RCALL _ks0108_wrcmd_G100
	RJMP _0x200000C
_0x200000E:
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x200000F
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	__PUTW1MN _glcd_state,4
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x20000AC
_0x200000F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20000AC:
	__PUTW1MN _glcd_state,27
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	JMP  _0x2100002
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	CALL __SAVELOCR4
	LDI  R16,0
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x2000015
	LDI  R16,LOW(255)
_0x2000015:
_0x2000016:
	CPI  R19,8
	BRSH _0x2000018
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R19
	SUBI R19,-1
	RCALL _ks0108_gotoxp_G100
	LDI  R17,LOW(0)
_0x2000019:
	MOV  R26,R17
	SUBI R17,-1
	CPI  R26,LOW(0x80)
	BRSH _0x200001B
	MOV  R26,R16
	CALL SUBOPT_0x2B
	RJMP _0x2000019
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _ks0108_gotoxp_G100
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
	JMP  _0x2100001
; .FEND
_glcd_putpixel:
; .FSTART _glcd_putpixel
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	CPI  R26,LOW(0x80)
	BRSH _0x200001D
	LDD  R26,Y+3
	CPI  R26,LOW(0x40)
	BRLO _0x200001C
_0x200001D:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2100004
_0x200001C:
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _ks0108_rdbyte_G100
	MOV  R17,R30
	RCALL _ks0108_setloc_G100
	LDD  R30,Y+3
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R16,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x200001F
	OR   R17,R16
	RJMP _0x2000020
_0x200001F:
	MOV  R30,R16
	COM  R30
	AND  R17,R30
_0x2000020:
	MOV  R26,R17
	RCALL _ks0108_wrdata_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2100004
; .FEND
_ks0108_wrmasked_G100:
; .FSTART _ks0108_wrmasked_G100
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _ks0108_rdbyte_G100
	MOV  R17,R30
	RCALL _ks0108_setloc_G100
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x200002B
	CPI  R30,LOW(0x8)
	BRNE _0x200002C
_0x200002B:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	CALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x200002D
_0x200002C:
	CPI  R30,LOW(0x3)
	BRNE _0x200002F
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2000030
_0x200002F:
	CPI  R30,0
	BRNE _0x2000031
_0x2000030:
_0x200002D:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2000032
_0x2000031:
	CPI  R30,LOW(0x2)
	BRNE _0x2000033
_0x2000032:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x2000029
_0x2000033:
	CPI  R30,LOW(0x1)
	BRNE _0x2000034
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x2000029
_0x2000034:
	CPI  R30,LOW(0x4)
	BRNE _0x2000029
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x2000029:
	MOV  R26,R17
	CALL SUBOPT_0x2B
	LDD  R17,Y+0
_0x2100009:
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R26,Y+16
	CPI  R26,LOW(0x80)
	BRSH _0x2000037
	LDD  R26,Y+15
	CPI  R26,LOW(0x40)
	BRSH _0x2000037
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x2000037
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x2000036
_0x2000037:
	RJMP _0x2100008
_0x2000036:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x81)
	LDI  R30,HIGH(0x81)
	CPC  R27,R30
	BRLO _0x2000039
	LDD  R26,Y+16
	LDI  R30,LOW(128)
	SUB  R30,R26
	STD  Y+14,R30
_0x2000039:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	BRLO _0x200003A
	LDD  R26,Y+15
	LDI  R30,LOW(64)
	SUB  R30,R26
	STD  Y+13,R30
_0x200003A:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x200003B
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x200003F
	RJMP _0x2100008
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2000041
	RJMP _0x2100008
_0x2000041:
_0x2000042:
	LDD  R16,Y+8
	LDD  R30,Y+13
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2000044
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2000043
_0x2000044:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	LDI  R31,0
	CALL __MULW12U
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x2C
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x2000046:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x2000048
	MOV  R17,R16
_0x2000049:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200004B
	CALL SUBOPT_0x2D
	RJMP _0x2000049
_0x200004B:
	RJMP _0x2000046
_0x2000048:
_0x2000043:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x200004C
	LDD  R30,Y+14
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	CALL SUBOPT_0x2C
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x200004D
	SUBI R19,-LOW(1)
_0x200004D:
	LDI  R18,LOW(0)
_0x200004E:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2000050
	LDD  R17,Y+14
_0x2000051:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2000053
	CALL SUBOPT_0x2D
	RJMP _0x2000051
_0x2000053:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x2C
	RJMP _0x200004E
_0x2000050:
_0x200004C:
_0x200003B:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2000054:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000056
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x2000057
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x2000058
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x200005D
	CPI  R30,LOW(0x3)
	BRNE _0x200005E
_0x200005D:
	RJMP _0x200005F
_0x200005E:
	CPI  R30,LOW(0x7)
	BRNE _0x2000060
_0x200005F:
	RJMP _0x2000061
_0x2000060:
	CPI  R30,LOW(0x8)
	BRNE _0x2000062
_0x2000061:
	RJMP _0x2000063
_0x2000062:
	CPI  R30,LOW(0x6)
	BRNE _0x2000064
_0x2000063:
	RJMP _0x2000065
_0x2000064:
	CPI  R30,LOW(0x9)
	BRNE _0x2000066
_0x2000065:
	RJMP _0x2000067
_0x2000066:
	CPI  R30,LOW(0xA)
	BRNE _0x200005B
_0x2000067:
	ST   -Y,R16
	LDD  R30,Y+16
	CALL SUBOPT_0x2A
_0x200005B:
_0x2000069:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200006B
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x200006C
	RCALL _ks0108_rddata_G100
	RCALL _ks0108_setloc_G100
	CALL SUBOPT_0x2E
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ks0108_rddata_G100
	MOV  R26,R30
	CALL _glcd_writemem
	RCALL _ks0108_nextx_G100
	RJMP _0x200006D
_0x200006C:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2000071
	LDI  R21,LOW(0)
	RJMP _0x2000072
_0x2000071:
	CPI  R30,LOW(0xA)
	BRNE _0x2000070
	LDI  R21,LOW(255)
	RJMP _0x2000072
_0x2000070:
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x2000079
	CPI  R30,LOW(0x8)
	BRNE _0x200007A
_0x2000079:
_0x2000072:
	CALL SUBOPT_0x30
	MOV  R21,R30
	RJMP _0x200007B
_0x200007A:
	CPI  R30,LOW(0x3)
	BRNE _0x200007D
	COM  R21
	RJMP _0x200007E
_0x200007D:
	CPI  R30,0
	BRNE _0x2000080
_0x200007E:
_0x200007B:
	MOV  R26,R21
	CALL SUBOPT_0x2B
	RJMP _0x2000077
_0x2000080:
	CALL SUBOPT_0x31
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
_0x2000077:
_0x200006D:
	RJMP _0x2000069
_0x200006B:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2000081
_0x2000058:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000082
_0x2000057:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2000083
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000084
_0x2000083:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2000084:
	ST   -Y,R19
	MOV  R26,R18
	CALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2000088
_0x2000089:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200008B
	CALL SUBOPT_0x32
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x33
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x2E
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x2000089
_0x200008B:
	RJMP _0x2000087
_0x2000088:
	CPI  R30,LOW(0x9)
	BRNE _0x200008C
	LDI  R21,LOW(0)
	RJMP _0x200008D
_0x200008C:
	CPI  R30,LOW(0xA)
	BRNE _0x2000093
	LDI  R21,LOW(255)
_0x200008D:
	CALL SUBOPT_0x30
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	MOV  R21,R30
_0x2000090:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000092
	CALL SUBOPT_0x31
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G100
	RJMP _0x2000090
_0x2000092:
	RJMP _0x2000087
_0x2000093:
_0x2000094:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000096
	CALL SUBOPT_0x34
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
	RJMP _0x2000094
_0x2000096:
_0x2000087:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x2000097
	RJMP _0x2000056
_0x2000097:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x2000098
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20000AD
_0x2000098:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20000AD:
	STD  Y+13,R30
	LDI  R17,LOW(0)
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	LDD  R16,Y+16
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2000082:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x200009D
_0x200009E:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000A0
	CALL SUBOPT_0x32
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x33
	MOV  R30,R18
	MOV  R26,R20
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x2E
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x200009E
_0x20000A0:
	RJMP _0x200009C
_0x200009D:
	CPI  R30,LOW(0x9)
	BRNE _0x20000A1
	LDI  R21,LOW(0)
	RJMP _0x20000A2
_0x20000A1:
	CPI  R30,LOW(0xA)
	BRNE _0x20000A8
	LDI  R21,LOW(255)
_0x20000A2:
	CALL SUBOPT_0x30
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	MOV  R21,R30
_0x20000A5:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000A7
	CALL SUBOPT_0x31
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G100
	RJMP _0x20000A5
_0x20000A7:
	RJMP _0x200009C
_0x20000A8:
_0x20000A9:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000AB
	CALL SUBOPT_0x34
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
	RJMP _0x20000A9
_0x20000AB:
_0x200009C:
_0x2000081:
	LDD  R30,Y+8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2000054
_0x2000056:
_0x2100008:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x11
	CALL __CPW02
	BRLT _0x2020003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2100003
_0x2020003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRLT _0x2020004
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	JMP  _0x2100003
_0x2020004:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2100003
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x11
	CALL __CPW02
	BRLT _0x2020005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2100003
_0x2020005:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLT _0x2020006
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	JMP  _0x2100003
_0x2020006:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2100003
; .FEND
_glcd_getcharw_G101:
; .FSTART _glcd_getcharw_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0x35
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x202000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2100007
_0x202000B:
	CALL SUBOPT_0x36
	STD  Y+7,R0
	CALL SUBOPT_0x36
	STD  Y+6,R0
	CALL SUBOPT_0x36
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x202000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2100007
_0x202000C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x202000D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2100007
_0x202000D:
	LDD  R30,Y+6
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x202000E
	SUBI R20,-LOW(1)
_0x202000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x202000F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+7
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x2100007
_0x202000F:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2020010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2020012
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R26,Z
	LDI  R27,0
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	__ADDWRR 16,17,30,31
	RJMP _0x2020010
_0x2020012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x2100007:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G101:
; .FSTART _glcd_new_line_G101
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	CALL SUBOPT_0x37
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _glcd_state,7
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	CALL SUBOPT_0x35
	SBIW R30,0
	BRNE PC+2
	RJMP _0x202001F
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2020020
	RJMP _0x2020021
_0x2020020:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G101
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2020022
	RJMP _0x2100006
_0x2020022:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	__CPWRN 16,17,129
	BRLO _0x2020023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G101
_0x2020023:
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	CALL SUBOPT_0x37
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	__GETB1MN _glcd_state,2
	LDD  R26,Y+6
	ADD  R30,R26
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x37
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x38
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2020024
_0x2020021:
	RCALL _glcd_new_line_G101
	RJMP _0x2100006
_0x2020024:
_0x202001F:
	__PUTBMRN _glcd_state,2,16
_0x2100006:
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
_glcd_outtextxyf:
; .FSTART _glcd_outtextxyf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _glcd_moveto
_0x2020028:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202002A
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2020028
_0x202002A:
	LDD  R17,Y+0
	RJMP _0x2100004
; .FEND
_glcd_putpixelm_G101:
; .FSTART _glcd_putpixelm_G101
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	__GETB1MN _glcd_state,9
	LDD  R26,Y+2
	AND  R30,R26
	BREQ _0x202003E
	LDS  R30,_glcd_state
	RJMP _0x202003F
_0x202003E:
	__GETB1MN _glcd_state,1
_0x202003F:
	MOV  R26,R30
	RCALL _glcd_putpixel
	LD   R30,Y
	LSL  R30
	ST   Y,R30
	CPI  R30,0
	BRNE _0x2020041
	LDI  R30,LOW(1)
	ST   Y,R30
_0x2020041:
	LD   R30,Y
	RJMP _0x2100002
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RJMP _0x2100003
; .FEND
_glcd_line:
; .FSTART _glcd_line
	ST   -Y,R26
	SBIW R28,11
	CALL __SAVELOCR6
	LDD  R26,Y+20
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+20,R30
	LDD  R26,Y+18
	CLR  R27
	RCALL _glcd_clipx
	STD  Y+18,R30
	LDD  R26,Y+19
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+19,R30
	LDD  R26,Y+17
	CLR  R27
	RCALL _glcd_clipy
	STD  Y+17,R30
	LDD  R30,Y+18
	__PUTB1MN _glcd_state,2
	LDD  R30,Y+17
	__PUTB1MN _glcd_state,3
	LDI  R30,LOW(1)
	STD  Y+8,R30
	LDD  R30,Y+17
	LDD  R26,Y+19
	CP   R30,R26
	BRNE _0x2020042
	LDD  R17,Y+20
	LDD  R26,Y+18
	CP   R17,R26
	BRNE _0x2020043
	ST   -Y,R17
	LDD  R30,Y+20
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G101
	RJMP _0x2100005
_0x2020043:
	LDD  R26,Y+18
	CP   R17,R26
	BRSH _0x2020044
	LDD  R30,Y+18
	SUB  R30,R17
	MOV  R16,R30
	__GETWRN 20,21,1
	RJMP _0x2020045
_0x2020044:
	LDD  R26,Y+18
	MOV  R30,R17
	SUB  R30,R26
	MOV  R16,R30
	__GETWRN 20,21,-1
_0x2020045:
_0x2020047:
	LDD  R19,Y+19
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020049:
	CALL SUBOPT_0x39
	BRSH _0x202004B
	ST   -Y,R17
	ST   -Y,R19
	INC  R19
	LDD  R26,Y+10
	RCALL _glcd_putpixelm_G101
	STD  Y+7,R30
	RJMP _0x2020049
_0x202004B:
	LDD  R30,Y+7
	STD  Y+8,R30
	ADD  R17,R20
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BRNE _0x2020047
	RJMP _0x202004C
_0x2020042:
	LDD  R30,Y+18
	LDD  R26,Y+20
	CP   R30,R26
	BRNE _0x202004D
	LDD  R19,Y+19
	LDD  R26,Y+17
	CP   R19,R26
	BRSH _0x202004E
	LDD  R30,Y+17
	SUB  R30,R19
	MOV  R18,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x202011B
_0x202004E:
	LDD  R26,Y+17
	MOV  R30,R19
	SUB  R30,R26
	MOV  R18,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x202011B:
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x2020051:
	LDD  R17,Y+20
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020053:
	CALL SUBOPT_0x39
	BRSH _0x2020055
	ST   -Y,R17
	INC  R17
	CALL SUBOPT_0x3A
	STD  Y+7,R30
	RJMP _0x2020053
_0x2020055:
	LDD  R30,Y+7
	STD  Y+8,R30
	LDD  R30,Y+13
	ADD  R19,R30
	MOV  R30,R18
	SUBI R18,1
	CPI  R30,0
	BRNE _0x2020051
	RJMP _0x2020056
_0x202004D:
	LDI  R30,LOW(0)
	STD  Y+6,R30
_0x2020057:
	CALL SUBOPT_0x39
	BRLO PC+2
	RJMP _0x2020059
	LDD  R17,Y+20
	LDD  R19,Y+19
	LDI  R30,LOW(1)
	MOV  R18,R30
	MOV  R16,R30
	LDD  R26,Y+18
	CLR  R27
	LDD  R30,Y+20
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R20,R26
	TST  R21
	BRPL _0x202005A
	LDI  R16,LOW(255)
	MOVW R30,R20
	CALL __ANEGW1
	MOVW R20,R30
_0x202005A:
	MOVW R30,R20
	LSL  R30
	ROL  R31
	STD  Y+15,R30
	STD  Y+15+1,R31
	LDD  R26,Y+17
	CLR  R27
	LDD  R30,Y+19
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STD  Y+13,R26
	STD  Y+13+1,R27
	LDD  R26,Y+14
	TST  R26
	BRPL _0x202005B
	LDI  R18,LOW(255)
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	CALL __ANEGW1
	STD  Y+13,R30
	STD  Y+13+1,R31
_0x202005B:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LSL  R30
	ROL  R31
	STD  Y+11,R30
	STD  Y+11+1,R31
	ST   -Y,R17
	ST   -Y,R19
	LDI  R26,LOW(1)
	RCALL _glcd_putpixelm_G101
	STD  Y+8,R30
	LDI  R30,LOW(0)
	STD  Y+9,R30
	STD  Y+9+1,R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CP   R20,R26
	CPC  R21,R27
	BRLT _0x202005C
_0x202005E:
	ADD  R17,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CALL SUBOPT_0x3B
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R20,R26
	CPC  R21,R27
	BRGE _0x2020060
	ADD  R19,R18
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	CALL SUBOPT_0x3C
_0x2020060:
	ST   -Y,R17
	CALL SUBOPT_0x3A
	STD  Y+8,R30
	LDD  R30,Y+18
	CP   R30,R17
	BRNE _0x202005E
	RJMP _0x2020061
_0x202005C:
_0x2020063:
	ADD  R19,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	CALL SUBOPT_0x3B
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x2020065
	ADD  R17,R16
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	CALL SUBOPT_0x3C
_0x2020065:
	ST   -Y,R17
	CALL SUBOPT_0x3A
	STD  Y+8,R30
	LDD  R30,Y+17
	CP   R30,R19
	BRNE _0x2020063
_0x2020061:
	LDD  R30,Y+19
	SUBI R30,-LOW(1)
	STD  Y+19,R30
	LDD  R30,Y+17
	SUBI R30,-LOW(1)
	STD  Y+17,R30
	RJMP _0x2020057
_0x2020059:
_0x2020056:
_0x202004C:
_0x2100005:
	CALL __LOADLOCR6
	ADIW R28,21
	RET
; .FEND

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x2100004:
	ADIW R28,5
	RET
; .FEND

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	CALL __LSLB12
_0x2100003:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2080007
	CPI  R30,LOW(0xA)
	BRNE _0x2080008
_0x2080007:
	LDS  R17,_glcd_state
	RJMP _0x2080009
_0x2080008:
	CPI  R30,LOW(0x9)
	BRNE _0x208000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x2080009
_0x208000B:
	CPI  R30,LOW(0x8)
	BRNE _0x2080005
	__GETBRMN 17,_glcd_state,16
_0x2080009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x208000E
	CPI  R17,0
	BREQ _0x208000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2100002
_0x208000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2100002
_0x208000E:
	CPI  R17,0
	BRNE _0x2080011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2100002
_0x2080011:
_0x2080005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2100002
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x2080015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2100002
_0x2080015:
	CPI  R30,LOW(0x2)
	BRNE _0x2080016
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x2100002
_0x2080016:
	CPI  R30,LOW(0x3)
	BRNE _0x2080018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x2100002
_0x2080018:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
_0x2100002:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x208001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x208001B
_0x208001C:
	CPI  R30,LOW(0x2)
	BRNE _0x208001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __EEPROMWRB
	RJMP _0x208001B
_0x208001D:
	CPI  R30,LOW(0x3)
	BRNE _0x208001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x208001B:
_0x2100001:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
_table:
	.BYTE 0x12
_ks0108_coord_G100:
	.BYTE 0x3
__seed_G106:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(21)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(21)
	ST   -Y,R30
	LDI  R26,LOW(63)
	CALL _glcd_line
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(21)
	ST   -Y,R30
	LDI  R30,LOW(63)
	ST   -Y,R30
	LDI  R26,LOW(21)
	CALL _glcd_line
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R26,LOW(63)
	CALL _glcd_line
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R30,LOW(63)
	ST   -Y,R30
	LDI  R26,LOW(42)
	CALL _glcd_line
	LDI  R30,LOW(80)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW2FN _0x0,0
	JMP  _glcd_outtextxyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(80)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	__POINTW2FN _0x0,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(100)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW2FN _0x0,5
	JMP  _glcd_outtextxyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(100)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	__POINTW2FN _0x0,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(120)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	__POINTW2FN _0x0,8
	JMP  _glcd_outtextxyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(120)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	__POINTW2FN _0x0,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(20)
	ST   -Y,R30
	__POINTW2FN _0x0,10
	CALL _glcd_outtextxyf
	MOV  R0,R4
	OR   R0,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(110)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x9:
	__MULBNWRU 16,17,6
	SUBI R30,LOW(-_table)
	SBCI R31,HIGH(-_table)
	MOVW R26,R30
	MOVW R30,R18
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(70)
	ST   -Y,R30
	LDI  R30,LOW(56)
	ST   -Y,R30
	__POINTW2FN _0x0,21
	JMP  _glcd_outtextxyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	CALL _glcd_clear
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R30,LOW(32)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	CALL _glcd_outtextxyf
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(50)
	ST   -Y,R30
	LDI  R30,LOW(32)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(80)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(100)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(120)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x12:
	LD   R26,Y
	LDD  R27,Y+1
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,8
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,16
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(55)
	LDI  R31,HIGH(55)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x17:
	LDI  R26,LOW(55)
	LDI  R27,0
	CALL _draw_winner_line
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
	CALL _glcd_clear
	MOV  R0,R4
	OR   R0,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x18:
	__POINTW2FN _0x0,78
	CALL _glcd_outtextxyf
	LDI  R26,LOW(79)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x19:
	__POINTW2FN _0x0,86
	CALL _glcd_outtextxyf
	LDI  R26,LOW(88)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x1A:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1B:
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,2
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1D:
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,12
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,6
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LD   R30,Y
	LDD  R31,Y+1
	__GETWRZ 0,1,8
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	CALL __GETW1P
	CP   R30,R0
	CPC  R31,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x22:
	CALL __GETW1P
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x23:
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	__POINTW2FN _0x0,17
	CALL _glcd_outtextxyf
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x24:
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	__POINTW2FN _0x0,19
	CALL _glcd_outtextxyf
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x25:
	ST   -Y,R30
	LDI  R30,LOW(32)
	ST   -Y,R30
	__POINTW2FN _0x0,17
	CALL _glcd_outtextxyf
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x26:
	ST   -Y,R30
	LDI  R30,LOW(32)
	ST   -Y,R30
	__POINTW2FN _0x0,19
	CALL _glcd_outtextxyf
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x27:
	ST   -Y,R30
	LDI  R30,LOW(52)
	ST   -Y,R30
	__POINTW2FN _0x0,17
	CALL _glcd_outtextxyf
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x28:
	ST   -Y,R30
	LDI  R30,LOW(52)
	ST   -Y,R30
	__POINTW2FN _0x0,19
	CALL _glcd_outtextxyf
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x29:
	CBI  0x18,1
	LDI  R30,LOW(255)
	OUT  0x1A,R30
	LD   R30,Y
	OUT  0x1B,R30
	CALL _ks0108_enable_G100
	JMP  _ks0108_disable_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R26,R30
	JMP  _ks0108_gotoxp_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	CALL _ks0108_wrdata_G100
	JMP  _ks0108_nextx_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2D:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2E:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2F:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	ST   -Y,R16
	INC  R16
	LDD  R26,Y+16
	CALL _ks0108_rdbyte_G100
	AND  R30,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x33:
	MOV  R21,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	CALL _glcd_readmem
	MOV  R1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x34:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	SBIW R30,1
	RJMP SUBOPT_0x2F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x37:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x38:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	JMP  _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x39:
	LDD  R26,Y+6
	SUBI R26,-LOW(1)
	STD  Y+6,R26
	SUBI R26,LOW(1)
	__GETB1MN _glcd_state,8
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	ST   -Y,R19
	LDD  R26,Y+10
	JMP  _glcd_putpixelm_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
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
