	AREA    motorControl, CODE, READONLY
	EXPORT	__motorControl				; make __main visible to linker
	;ENTRY			
				
__motorControl	PROC

;-----------CC AND CW ROTATIONS FOR BOTH STEPPER MOTORS---------
;----------------GPIO B CLOCK WISE ROTATIONS FUNCTION-----------
gb_CWrot PROC
	PUSH {LR}			;preserve LR
;STEP 1
loop1	
	LDR r0, =GPIOB_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;A(~B) -> want PB 2, 7 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000084			;set PB 2,7 to 1
	STR r1, [r0, #GPIO_ODR]
	BL delay
;STEP 2
	LDR r0, =GPIOB_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;A-> want PB 2 to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000004			;set PB 2 to 1
	STR r1, [r0, #GPIO_ODR]
	BL delay
;STEP 3
	LDR r0, =GPIOB_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;AB-> want PB 2, 6 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000044			;set PB 2, 6 to 1
	STR r1, [r0, #GPIO_ODR]
	BL delay
;STEP 4
	LDR r0, =GPIOB_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;B-> want PB 6 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000040			;set PB 6 to t
	STR r1, [r0, #GPIO_ODR]	
	BL delay
;STEP 5
	LDR r0, =GPIOB_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;(~A)B-> want PB 6,3 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000048			;set PB 6,3 to 1
	STR r1, [r0, #GPIO_ODR]	
	BL delay
;STEP 6
	LDR r0, =GPIOB_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;(~A)-> want PB 3 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000008			;set PB 3 to 1
	STR r1, [r0, #GPIO_ODR]	
	BL delay
;STEP 7
	LDR r0, =GPIOB_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;(~A)(~B)-> want PB 3,7 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000088			;set PB 3,7 to 1
	STR r1, [r0, #GPIO_ODR]	
	BL delay
;STEP 8
	LDR r0, =GPIOB_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;(~B)-> want PB 7 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000080		;set PB 7 to 1
	STR r1, [r0, #GPIO_ODR]	
	BL delay

	ADD r5,#1	;increment counter
	
	CMP r5, r3		;check if counter at rotations needed
	BNE loop1		;if not at rotations needed, continue loop
	
	POP {LR}		;preserve og LR
	BX LR			;branch back to loop
	ENDP
;----------------END GPIO B CLOCK WISE FUNCTION------------------------	
	
;-------------GPIO B COUNTER CLOCK WISE ROTATIONS---------------	
gb_CCrot PROC
	PUSH {LR}		;preserve LR
loop2
;STEP 8
	LDR r0, =GPIOB_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;(~B)-> want PB 7 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000080			;set PB 7 to 1
	STR r1, [r0, #GPIO_ODR]	
	BL delay
;STEP 7
	LDR r0, =GPIOB_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;(~A)(~B)-> want PB 3,7 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000088			;set PB 3,7 to 1
	STR r1, [r0, #GPIO_ODR]	
	BL delay
;STEP 6
	LDR r0, =GPIOB_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;(~A)-> want PB 3 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000008			;set PB 3 to 1
	STR r1, [r0, #GPIO_ODR]	
	BL delay
;STEP 5
	LDR r0, =GPIOB_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;(~A)B-> want PB 6,3 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000048			;set PB 6,3 to 1
	STR r1, [r0, #GPIO_ODR]	
	BL delay
;STEP 4
	LDR r0, =GPIOB_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;B-> want PB 6 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000040			;set PB 6 to t
	STR r1, [r0, #GPIO_ODR]	
	BL delay
;STEP 3
	LDR r0, =GPIOB_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;AB-> want PB 2, 6 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000044			;set PB 2, 6 to 1
	STR r1, [r0, #GPIO_ODR]
	BL delay
;STEP 2
	LDR r0, =GPIOB_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;A-> want PB 2 to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000004			;set PB 2 to 1
	STR r1, [r0, #GPIO_ODR]
	BL delay
;STEP 1
	LDR r0, =GPIOB_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;A(~B) -> want PB 2, 7 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000084			;set PB 2,7 to 1
	STR r1, [r0, #GPIO_ODR]
	BL delay
	
	ADD r5,#1	;increment counter
	
	;MOV r3, #0x80	;init comparison
	CMP r5, r3		;check if counter at rotations needed
	BNE loop2		;if not at rotations needed, continue loop
	
	POP {LR}		;preserve og LR
	BX LR			;branch back to loop
	ENDP
;--------------END GPIO B COUNTER CLOCK WISE FUNCTION------------------


;----------------GPIO C CLOCK WISE ROTATIONS FUNCTION-----------
gc_CWrot PROC
	PUSH {LR}			;preserve LR
;STEP 1
loop3	
	LDR r0, =GPIOC_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;A(~B) -> want PB 2, 7 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000084			;set PB 2,7 to 1
	STR r1, [r0, #GPIO_ODR]
	BL delay
;STEP 2
	LDR r0, =GPIOC_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;A-> want PB 2 to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000004			;set PB 2 to 1
	STR r1, [r0, #GPIO_ODR]
	BL delay
;STEP 3
	LDR r0, =GPIOC_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;AB-> want PB 2, 6 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000044			;set PB 2, 6 to 1
	STR r1, [r0, #GPIO_ODR]
	BL delay
;STEP 4
	LDR r0, =GPIOC_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;B-> want PB 6 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000040			;set PB 6 to t
	STR r1, [r0, #GPIO_ODR]	
	BL delay
;STEP 5
	LDR r0, =GPIOC_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;(~A)B-> want PB 6,3 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000048			;set PB 6,3 to 1
	STR r1, [r0, #GPIO_ODR]	
	BL delay
;STEP 6
	LDR r0, =GPIOC_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;(~A)-> want PB 3 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000008			;set PB 3 to 1
	STR r1, [r0, #GPIO_ODR]	
	BL delay
;STEP 7
	LDR r0, =GPIOC_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;(~A)(~B)-> want PB 3,7 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000088			;set PB 3,7 to 1
	STR r1, [r0, #GPIO_ODR]	
	BL delay
;STEP 8
	LDR r0, =GPIOC_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;(~B)-> want PB 7 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000080		;set PB 7 to 1
	STR r1, [r0, #GPIO_ODR]	
	BL delay

	ADD r5,#1	;increment counter
	
	CMP r5, r3		;check if counter at rotations needed
	BNE loop3		;if not at rotations needed, continue loop
	
	POP {LR}		;preserve og LR
	BX LR			;branch back to loop
	ENDP
;----------------END GPIO C CLOCK WISE FUNCTION------------------------	
	
;-------------GPIO C COUNTER CLOCK WISE ROTATIONS---------------	
gc_CCrot PROC
	PUSH {LR}		;preserve LR
loop4
;STEP 8
	LDR r0, =GPIOC_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;(~B)-> want PB 7 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000080			;set PB 7 to 1
	STR r1, [r0, #GPIO_ODR]	
	BL delay
;STEP 7
	LDR r0, =GPIOC_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;(~A)(~B)-> want PB 3,7 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000088			;set PB 3,7 to 1
	STR r1, [r0, #GPIO_ODR]	
	BL delay
;STEP 6
	LDR r0, =GPIOC_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;(~A)-> want PB 3 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000008			;set PB 3 to 1
	STR r1, [r0, #GPIO_ODR]	
	BL delay
;STEP 5
	LDR r0, =GPIOC_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;(~A)B-> want PB 6,3 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000048			;set PB 6,3 to 1
	STR r1, [r0, #GPIO_ODR]	
	BL delay
;STEP 4
	LDR r0, =GPIOC_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;B-> want PB 6 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000040			;set PB 6 to t
	STR r1, [r0, #GPIO_ODR]	
	BL delay
;STEP 3
	LDR r0, =GPIOC_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;AB-> want PB 2, 6 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000044			;set PB 2, 6 to 1
	STR r1, [r0, #GPIO_ODR]
	BL delay
;STEP 2
	LDR r0, =GPIOC_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;A-> want PB 2 to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000004			;set PB 2 to 1
	STR r1, [r0, #GPIO_ODR]
	BL delay
;STEP 1
	LDR r0, =GPIOC_BASE 		;load base reg of GPIOB
	LDR r1, [r0, #GPIO_ODR]		;Load ODR into r1
	;A(~B) -> want PB 2, 7 set to 1
	BIC r1,r1, #0x000000CC
	ORR r1, #0x00000084			;set PB 2,7 to 1
	STR r1, [r0, #GPIO_ODR]
	BL delay
	
	ADD r5,#1	;increment counter
	
	;MOV r3, #0x80	;init comparison
	CMP r5, r3		;check if counter at rotations needed
	BNE loop4		;if not at rotations needed, continue loop
	
	POP {LR}		;preserve og LR
	BX LR			;branch back to loop
	
	ENDP
	
;--------------END GPIO C COUNTER CLOCK WISE FUNCTION-----------

;---------DELAY FUNCTION FOR STEPPER MOTORS---------------------	
delay	PROC	
	LDR	r4, =0x708
	;LDR	r2, =0xBB8
delayloop
	SUBS	r4, #1
	BNE	delayloop
	BX LR
	
	ENDP
;---------------------------------------------------------------
	

	ENDP