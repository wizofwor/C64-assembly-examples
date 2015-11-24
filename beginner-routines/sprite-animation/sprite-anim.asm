STATE = $02 	;current animation case (like jump,hit,run etc.)
FRAME = $03 	;current frame within the case
LIMIT = $01
SPRITE_POINTER = SCREEN_MEM+$03f8 

spriteAnimation:
	lda STATE 		;load state
	asl 			;mulitply by 2
	tax 			;and jump to this adress
	jmp (JUMP_TABLE,X) 	
	rts
	
	;animation frames for each state 
state1: 
	ldx FRAME  		;animation state 1 has three frames
	lda SPRITE_POINTERS_TB,X
	sta SPRITE_POINTER
	lda FRAME 		;increase
	adc #$01 		;animation
	and #$03		;frame
	sta FRAME 		;index
	jmp return
state:
	lda #$03 		;animation state 2 has only one frame
	sta SPRITE_POINTER
	jmp return

* = JUMP_TABLE 
!by >state1,<state1,>state1,<state2

* = SPRITE_PONITERS_TB
!by = 0,1,2,3
