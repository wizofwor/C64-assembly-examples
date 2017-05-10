/*=============================================

  6502 TUTORIALS - COLOR WASH

 ============================================*/

// Definitions
	.const SCREEN_RAM = $0400
	.const COLOR_RAM = $d800
	.const EFFECT_COUNTER = $02
	
	BasicUpstart2(start)

	* = $c000 "Main Program"

// Clear Screen
start:
	ldx #$00
	lda #$20
!:	sta SCREEN_RAM,x
	sta SCREEN_RAM+$100,x
	sta SCREEN_RAM+$200,x
	sta SCREEN_RAM+$300,x
	dex
	bne !-
	
// Place the text on screen
	ldx #00
!:	lda text,x
	sta SCREEN_RAM+40*5,x
	inx
	cpx #120
	bne !- 
	
// 	Initialize the counter
	lda #40
	sta EFFECT_COUNTER
	
//  Wait till the screen refresh (1/50 seconds)	
cwash:
	lda #00	
!:	cmp $d012	
	bne !-	
		
	/*Renk geçişi efekti iki index yazmacını
	;birlikte kullanıyor. Y okunacak rengi
	;X yazılacak adresi indexliyor*/
	
	ldy EFFECT_COUNTER
	ldx #00
!:	lda colors,y
	sta COLOR_RAM+40*5,x
	inx
	sta COLOR_RAM+40*6,x
	inx
	sta COLOR_RAM+40*7,x
	iny
	dex
	cpx #40
	bne !-
	
	dec EFFECT_COUNTER
	
	lda #00
	cmp EFFECT_COUNTER
	bne cwash
	
	lda #40
	sta EFFECT_COUNTER
	
	jmp cwash

// Data	----------------------------------------------------
text: 
	.text "          + ++ hi there! ++ +           "
	.text "   ---------------------------------    "
	.text "   this is a smiple colorwash effect    "

colors:
	.by  14,14,14,14,14,14,14,14,14,14
	.by  14,14,14,14,14,14,14,15,01,07
	.by  01,07,15,14,14,14,14,14,14,14
	.by  14,14,14,14,14,14,14,14,14,14

	.by  14,14,14,14,14,14,14,14,14,14
	.by  14,14,14,14,14,14,14,15,01,07
	.by  01,07,15,14,14,14,14,14,14,14
	.by  14,14,14,14,14,14,14,14,14,14
