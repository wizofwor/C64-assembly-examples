/* =========================================== *

  C64 ASM TUTORIALS by wizofwor

  CUSTOM CHARSET

  Replace standart character set with custom one 

  Environment: KickAssembler v.4.12
  Date: September 2018 

 * =========================================== */

	.const SCREEN_RAM = $0400
	.const COLOR_RAM = $d800
	.const CHARSET = $2000

// --- Main Program with Basic Upstarter --------

BasicUpstart2(start)

*=$c000 "Main Program"

	// Change Border Color
start:	lda #$03
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

	// Set new charset
	lda #$18
	sta $d018

	rts
	
// --- Include Data -----------------------------
* = CHARSET "Character Set"
.import c64 "antik_1.64c"
