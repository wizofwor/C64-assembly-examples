/* ============================================================== *

  C64 ASM TUTORIALS by wizofwor

  SMOOTH SCROLL

  Environment: KickAssembler v.4.12
  Date: November 2014 - September 2018

 * ============================================================== */

// Zeropage Address
.const offset 	= $02
.const delay 	= $03
.const charCount = $04

// --- Main Program with Basic Upstarter ---------------------------

BasicUpstart2(start)

* = $c000 "Main Program"
	
start:	        sei
        	lda #00
	        sta charCount

                // Set Screen Color
prepare:        lda #05 
	        sta $d020
                lda #06
                sta $d021
	
                // Clear the screen by filling with $20
                // which is space
        	ldx #00 
        	lda #$20 	

clear:	        sta $0400,x
        	sta $0500,x
        	sta $0600,x
        	sta $0700,x
        	inx
        	bne clear

                // Place the text message	
        	ldx #00
write:	        lda text,x
        	sta $0400,x
        	lda text+40,x
        	sta $07c0,x
        	inx
        	cpx #40
        	bne write

                // Actual Drawing / Scrolling Part

                // Wait for row 60 to scroll
raster1:        lda #60	        
        	cmp $d012		
        	bne raster1+2
                // Wait a little more for stable raster
        	ldx #11	        
wait:   	dex
	        bne wait	
        	
        	inc $d020
        	lda offset
        	sta $d016	
	
                // Wait for row 240 to scroll
raster2:        lda #241	
	        cmp $d012		
	        bne raster2+2
	        // Wait a little more for stable raster
	        ldx #2		
wait2:	        dex
	        bne wait2	

                // reset $d016 for rest of the screen
        	lda #00		
        	sta $d016	
        	dec $d020	
        		
                // Calculate Offset value
        	lda offset		
        	sec
        	sbc #01
        	and #07
        	sta offset

                // Shift character row 
        	cmp #07		// When offset value is 7
        	bne spaceCheck	// shift charecter row
	
        	ldx #00		// Shift character slots
shift:	        lda $05e0,x	// between 00-38
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
        	
                // Check for spacebar 	

spaceCheck:     lda $dc01	// Check for spacebar
        	cmp #$ef	// if pressed restore kernel IRQ
        	bne raster1	// and return to BASIC
        	sei
        	jsr $ff81
        	rts

// --- Data --------------------------------------------------------		

text:
        	.text "         one row smooth scroller        "
        	.text "          press space to quit           "	
        	.text "hello world!                 in a smooth"	
        	.text " way(!)                                 "
