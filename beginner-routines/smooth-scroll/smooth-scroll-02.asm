/*-----------------------------------------------------*

  SMOOTH SCROLL TUTORIAL V2 by Wizofwor - November 2014
  (SMOOTH SCROLL + COLORWASH)
 *-----------------------------------------------------*/

	BasicUpstart2(start)

	.const offset	= $02
	.const delay	= $03
	.const charCount   = $04
	.const colorWashCount = $05

	* = $c000 "Main Program"

start:	
	sei
	lda #00
	sta charCount

// Clear Screen
prepare:
	lda #05 	// Set Colors
	sta $d020
	lda #06
	sta $d021
	
	ldx #00 	// Fill the screen with $20
	lda #$20 	// which is space
clear:
	sta $0400,x
	sta $0500,x
	sta $0600,x
	sta $0700,x
	inx
	bne clear

// Place the text message	
	ldx #00		
write:
	lda text,x
	sta $0400,x
	lda text+40,x
	sta $07c0,x
	inx
	cpx #40
	bne write

// Actual Drawing / Scrolling Part
raster1:
	lda #60		//Wait for row 60 to scroll
	cmp $d012		
	bne raster1+2

	ldx #11		// Wait a little for stable raster
wait:
	dex
	bne wait	
	
	inc $d020
	lda offset
	sta $d016	
	
// Actual Drawing / Fixed part 
		
raster2:
	lda #241	// Wait for row 240 to scroll
	cmp $d012		
	bne raster2+2
	
	ldx #2		// Wait a little for stable raster
wait2:
	dex
	bne wait2	

	lda #00		// reset $d016
	sta $d016	
	dec $d020	
		
// Offset calculation
	lda offset	
	sec
	sbc #01
	and #07
	sta offset

// Shift character row 
	cmp #07			// When offset value is 7
	bne colWash		// shift charecter row
	
	ldx #00			// Shift character slots
shift:
	lda $05e0,x		// between 00-38
	sta $05df,x
	inx
	cpx #39
	bne shift
	
	ldx charCount	// grab next character
	lda text+80,x	// from the table
	sta $0606						

	inc charCount
	lda #80									
	cmp charCount	// check textCount and
	bne spaceCheck	// reset if larger then 80
	lda #00
	sta charCount

// Color wash effect 

colWash:
	lda colorWashCount 	// Increase clorWashCount
	cmp #40				// untill 40
	bne !+ 				// then reset
		lda #00
		sta colorWashCount
!:	ldx #$00
	ldy colorWashCount	// pick colors from table
!:	lda colorTable,y 	// using colorWashCount as intex
	sta $d800+40*12,x
	sta $d801,x
	inx
	iny
	cpy #40
	bne !-

    inc colorWashCount
	
// Check for spacebar 
spaceCheck:
	lda $dc01		// Check for spacebar
	cmp #$ef		// if pressed restore kernel IRQ
	bne raster1		// and return to BASIC
	sei
	jsr $ff81
	rts
		

text:
.text "         one row smooth scroller        "
.text "          press space to quit           "	
.text "hello world!                 in a smooth"	
.text " way(!)                                 "

colorTable:
.byte 12,12,12,12,12,12,12,12,12,12
.byte 12,12,12,12,12,12,12,12,12,12
.byte 4,3,1,1,3,4,12,12,12,12,12,12
.byte 12,12,12,12,12,12,12,12,12,12

.byte 12,12,12,12,12,12,12,12,12,12
.byte 12,12,12,12,12,12,12,12,12,12
.byte 4,3,1,1,3,4,12,12,12,12,12,12
.byte 12,12,12,12,12,12,12,12,12,12