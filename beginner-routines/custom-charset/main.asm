!to "build/custom-charset.prg",cbm
!src "standart.asm"

	;----------------------------------------
	;CONSTANTS
	;----------------------------------------

	SCREEN_RAM = $0400
	COLOR_RAM = $d800
	CHARSET = $2000

	;-----------------------------------------
	;MAIN
	;-----------------------------------------

	+SET_START $c000

	;Change Border Color
	lda #$03
	sta $d020

	;Change Screen Colors
	ldx #$00
-	sta $d800,x
	sta $d900,x
	sta $da00,x
	sta $db00,x
	inx
	bne -

	;Change cursor color
	sta $286

	lda #$18
	sta $d018

	rts
	
	* = CHARSET
	!bin "antik_1.64c",1024,2
