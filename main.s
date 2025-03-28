;******************** (C) Yifeng ZHU *******************************************
; @file    main.s
; @author  Yifeng Zhu
; @date    May-17-2015
; @note
;           This code is for the book "Embedded Systems with ARM Cortex-M 
;           Microcontrollers in Assembly Language and C, Yifeng Zhu, 
;           ISBN-13: 978-0982692639, ISBN-10: 0982692633
; @attension
;           This code is provided for education purpose. The author shall not be 
;           held liable for any direct, indirect or consequential damages, for any 
;           reason whatever. More information can be found from book website: 
;           http:;www.eece.maine.edu/~zhu/book
;*******************************************************************************


	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s      
	INCLUDE motor_functions.s	;issue
	
	IMPORT 	System_Clock_Init
	IMPORT 	UART2_Init
	IMPORT	USART2_Write
	;IMPORT 	motorControl	;issue
	
	AREA    main, CODE, READONLY
	EXPORT	__main				; make __main visible to linker
	ENTRY			
				
__main	PROC
	
;---------------------------CONFIGS-----------------------------
;---------------------ENABLING CLOCKS FOR GPIO Ports C and B------------------------
	;enable clock of GPIO Port B and GPIO Port C
	LDR	r0, =RCC_BASE		;load RCC module address to r0
	LDR r1, [r0,#RCC_AHB2ENR]	;load AHB2ENR register value into r1
	ORR r1, r1, #0x00000006		;set GPIO B clock and GPIO C clock 
	STR r1, [r0, #RCC_AHB2ENR]	;store values back into memory

;---------------CONFIG FOR GPIO C---------------------------------------------------

	LDR r0, =GPIOC_BASE		;select base reg as GPIO B
	LDR r1, [r0, #GPIO_MODER]	;load contents of moder reg to r1
	;BIC r1, r1, #0x0000F0F0		;clear bits 15,14,13,12,7,6,5,4 (PB 2,3,6,7) 
	BIC r1,r1, #0x0000F000
	BIC r1, r1,#0x000000F0
	;ORR r1, r1,#0x00005050		;set bits 14,12,6,4 (setting PB 2,3,6,7 to digital output)
	ORR r1, r1,#0x00005000
	ORR r1, r1,#0x00000050
	STR r1, [r0, #GPIO_MODER]	;store back into memory 
	
	;select push pull for PB.2,3,6,7
	LDR r0, =GPIOC_BASE		;select base reg as GPIO B
	LDR r1, [r0, #GPIO_OTYPER]	;load contents of OTYPER reg to r1
	;BIC r1, r1, #0x0000F0F0		;clear bits 15,14,13,12,7,6,5,4 (PB 2,3,6,7) 
	BIC r1,r1, #0x0000F000
	BIC r1, r1,#0x000000F0
	STR r1, [r0, #GPIO_OTYPER]	;store values back into memory
	
	;select no pullup no pulldown for PB.1,2,3,5
	LDR r0, =GPIOC_BASE		;select base reg as GPIO B
	LDR r1, [r0, #GPIO_PUPDR]	;load contents of PUPDR reg to r1
	;BIC r1, r1, #0x0000F0F0		;clear bits 2-7 and bits 10, 11
	BIC r1,r1, #0x0000F000
	BIC r1, r1,#0x000000F0
	STR r1, [r0, #GPIO_PUPDR]	;store values back into memory

;------------END GPIO C CONFIGS--------------------------------------------------
;-----------CONFIG FOR GPIO B-------------------------------------------------------

	;Set PB.2,3,6,7 mode to digital output
	LDR r0, =GPIOB_BASE		;select base reg as GPIO B
	LDR r1, [r0, #GPIO_MODER]	;load contents of moder reg to r1
	;BIC r1, r1, #0x0000F0F0		;clear bits 15,14,13,12,7,6,5,4 (PB 2,3,6,7) 
	BIC r1,r1, #0x0000F000
	BIC r1, r1,#0x000000F0
	;ORR r1, r1,#0x00005050		;set bits 14,12,6,4 (setting PB 2,3,6,7 to digital output)
	ORR r1, r1,#0x00005000
	ORR r1, r1,#0x00000050
	STR r1, [r0, #GPIO_MODER]	;store back into memory 
	
	;select push pull for PB.2,3,6,7
	LDR r0, =GPIOB_BASE		;select base reg as GPIO B
	LDR r1, [r0, #GPIO_OTYPER]	;load contents of OTYPER reg to r1
	;BIC r1, r1, #0x0000F0F0		;clear bits 15,14,13,12,7,6,5,4 (PB 2,3,6,7) 
	BIC r1,r1, #0x0000F000
	BIC r1, r1,#0x000000F0
	STR r1, [r0, #GPIO_OTYPER]	;store values back into memory
	
	;select no pullup no pulldown for PB.1,2,3,5
	LDR r0, =GPIOB_BASE		;select base reg as GPIO B
	LDR r1, [r0, #GPIO_PUPDR]	;load contents of PUPDR reg to r1
	;BIC r1, r1, #0x0000F0F0		;clear bits 2-7 and bits 10, 11
	BIC r1,r1, #0x0000F000
	BIC r1, r1,#0x000000F0
	STR r1, [r0, #GPIO_PUPDR]	;store values back into memory
;----------------------END GPIO B CONFIGS-------------------------------------------


;--------------------------END CONFIGS--------------------------

;------------------MAIN CODE------------------------------------
our_main
	BL automated_route
	
loo B loo	;dead loop here	
automated_route ;going from a to b to c
	PUSH {LR}
	
	;a to b
	MOV r5, #0x0
	MOV r3, #512
	BL gb_CWrot
	BL open_close_doors
	
	;b to c
	MOV r5, #0x0
	MOV r3, #512
	BL gb_CWrot
	BL open_close_doors
	
	;c to a
	MOV r5, #0x0
	MOV r3, #1024
	BL gb_CCrot
	BL open_close_doors
	
	POP {LR}
	BX LR
	
open_close_doors
	PUSH {LR}
	MOV r5, #0x0
	MOV r3, #0x80
	BL gc_CWrot
	
	BL delay_door
	
	MOV r5, #0x0
	MOV r3, #0x80
	BL gc_CCrot
	POP {LR}
	BX LR
	
;---------------------END MAIN CODE-----------------------------

;---------------DELAY FOR TRAIN DOOR----------------------------
delay_door	PROC	
	LDR	r4, =5000000
delayloop_door
	SUBS	r4, #1
	BNE	delayloop_door
	BX LR
	
	ENDP
;---------------------------------------------------------------
	ENDP		
		
	
	ALIGN			

	AREA myData, DATA, READWRITE
	ALIGN
; Replace ECE1770 with your last name
str DCB "BARSOTTI",0
	END