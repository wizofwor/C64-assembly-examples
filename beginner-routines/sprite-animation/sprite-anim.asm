STATE = $02
FRAME = $03
LIMIT = #$01
SPRITE_POINTER = SCREEN_MEM+$03f8 


loop:	LDA STATE 		;load state
	ASL 			;mulitply by 2
	TAX 			;and jump to this adress
	JMP (JUMP_TABLE,X) 	
return:	LDA STATE 		;increase state
	CLC 			;value in memory
	ADC #$01 		;till STATE>LIMIT
	AND LIMIT 		;then roll over
	STA STATE
jmp loop

	;animation frames for each state 
STATE1: 
	LDX FRAME  		;animation state 1 has three frames
	LDA SPRITE_POINTERS_TB,X
	STA SPRITE_POINTER
	LDA FRAME 		;increase
	ADC #$01 		;animation
	AND #$03		;frame
	STA FRAME 		;index
	JMP return
STATE2:
	LDA #$03 		;animation state 2 has only one frare
	STA SPRITE_POINTER
	JMP return

* = JUMP_TABLE 
!by >STATE1,<STATE1,>STATE2,<STATE2

* = SPRITE_PONITERS_TB
!by = 0,1,2,3
