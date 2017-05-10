/*=============================================

  6502 TUTORIALS - CUSTOM CHARSET 

 ============================================*/

	.const SCREEN_RAM = $0400
	.const COLOR_RAM = $d800
	.const CHARSET = $2000

	BasicUpstart2(start)

	*=$c000 "Main Program"

start:
// Change Border Color
	lda #$03
	sta $d020

// Change Screen Colors
	ldx #$00
!:	sta COLOR_RAM,x
	sta COLOR_RAM+$100,x
	sta COLOR_RAM+$200,x
	sta COLOR_RAM+$300,x
	inx
	bne !-

// Change cursor color
	sta $286


	lda #$18
	sta $d018

	rts
	
	* = CHARSET
	.import c64 "antik_1.64c"
