;###############################################################################
; Sprite Tutorial - 001
; February 2015 wizofwor
;###############################################################################

!to "build/tutorial.prg",cbm

	* = $c000
	;compiled program will reside on memory start from $c000 
	;can be executed by writing sys 49152

	lda #$ff
	sta $d000 	;set x position of sprite

	lda #$64
	sta $d001 	;set y position of sprite

	lda #$01 	;enable sprite0
	sta $d015 	

	lda #$01 
	sta $d017 	;disable xpand-y

	lda #$01
	sta $d01b   ;set sprite/background priority

	lda #$00 
	sta $d01c 	;set hires

	lda #$01 	
	sta $d01d 	;disable xpand-x
	
	lda #$01
	sta $d027 	;set sprite color

	lda #spriteData/64	;set sprite pointer
	sta $07f8

	rts

;lets use the famous baloon sprite from
;Commodore 64 Programmer's reference
* = $2140
spriteData:
!by %00000000,%01111111,%00000000
!by %00000001,%11111111,%11000000
!by %00000011,%11111111,%11100000
!by %00000111,%11100111,%11110000
!by %00001111,%11011001,%11111000
!by %00001111,%11011111,%11111000
!by %00001111,%11011001,%11111000
!by %00000111,%11100111,%11110000
!by %00000111,%11111111,%11110000
!by %00000011,%11111111,%11100000 ;10
!by %00000010,%11111111,%10100000
!by %00000001,%01111111,%01000000
!by %00000001,%00111110,%01000000
!by %00000000,%10011100,%10000000 ;14
!by %00000000,%10011100,%10000000
!by %00000000,%01001001,%00000000
!by %00000000,%01001001,%00000000
!by %00000000,%00111110,%00000000
!by %00000000,%00111110,%00000000
!by %00000000,%00111110,%00000000
!by %00000000,%00011100,%00000000