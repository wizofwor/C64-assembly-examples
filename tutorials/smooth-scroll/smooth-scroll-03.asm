/* ============================================================== *

  C64 ASM TUTORIALS by wizofwor

  SMOOTH SCROLL WITH VARIABLE SCROOl SPEED

  Environment: KickAssembler v.4.12
  Date: November 2014 - September 2018   
 
 * ============================================================== */

// Address Definitions:
.const SCREEN_RAM = $0400
.const COLOR_RAM = $D800
.const music = $1000
.const music_play = music+3

// Zeropage Addresses:
.const COUNTER	= $05
.const offset1	= $06
.const offset2	= $07
.const offset3	= $08
.const offset4	= $09
.const offset5	= $0A
.const buffer1	= $10
.const buffer2	= $11
.const buffer3	= $12
.const buffer4	= $13
.const buffer5	= $14

// --- Main Program with Basic Upstarter ---------------------------

BasicUpstart2(start)

* = $c000 "Main Program"

start:
        	jsr init
        	jsr print_screen

        	lda #00
        	sta COUNTER

        	jsr set_raster

        	jmp *

// --- Subroutines -------------------------------------------------

#import "scroller-subroutines.asm"

// IRQ - Calculation Part
irq: {		
	        jsr music_play

delay:          inc COUNTER 	// increase the COUNTER
 	        ldx COUNTER		
        	cpx #05
        	bne delay2

        	ldx #00
        	stx COUNTER

delay2:
        	cpx #04		// Skip clculation parts as per
        	beq part2 	// delay value
        	cpx #03
        	beq part3
        	cpx #02
        	beq part4
        	cpx #01
        	beq part5


part1:
        	lda offset1	// Caculate offset for logo parts
        	sec
        	sbc #01
        	and #07
        	sta offset1
        		
        	cmp #07		// when offset value is not 7
        	bne part2	// skip char shifting part
        	jsr move_logo

part2:
        	lda offset2
        	sec
        	sbc #01
        	and #07
        	sta offset2
        	cmp #07
        	bne part3
        	jsr shift2

part3:
        	lda offset3
        	sec
        	sbc #01
        	and #07
        	sta offset3

        	cmp #07
        	bne part4
        	jsr shift3

part4:          lda offset4
        	sec
        	sbc #01
        	and #07
        	sta offset4

        	cmp #07
        	bne part5
        	jsr shift4

part5:          lda offset5
        	sec
        	sbc #01
        	and #07
        	sta offset5

        	cmp #07
        	bne action
        	jsr shift5

action:         // IRQ - Action Part
raster1:        lda #80			//  Wait for raster line
	        cmp $d012		
	        bne raster1+2	
	        lda offset1
	        sta $d016

raster2:        lda #138		
        	cmp $d012		
        	bne raster2+2	
        	lda offset2
        	sta $d016

raster3: 	lda #146		
        	cmp $d012		
        	bne raster3+2	
        	lda offset3
        	sta $d016	

raster4:       	lda #154	
        	cmp $d012		
        	bne raster4+2	
        	lda offset4
        	sta $d016

raster5: 	lda #162	
        	cmp $d012		
        	bne raster5+2	
        	lda offset5
        	sta $d016
	
raster6:        lda #170
        	cmp $d012		
        	bne raster6+2	
        	lda offset1
        	sta $d016

end:	        dec $d019	// acnowledge IRQ register
	        jmp $ea81 	// return to kernel
}


// --- Data --------------------------------------------------------

text1:          .text " wow! wow! wow!     wow! wow! wow!      "
         	.text " a smooth scroller with different       "
         	.text " speeds on seperate rows                "
         	.text " and with a nice sid from slowhand      "
         	.text "                                        "

text2:          .text "  0   0 00 000 000 000 0   0 000 000    "
         	.text "  0   0 00   0 0 0 000 0   0 0 0 0 0    "
         	.text "  0 0 0 00 000 0 0 0   0 0 0 0 0 00     "
         	.text "   0 0  00 0   000 00   0 0  0 0 0 0    "
         	.text "   0 0  00 000 000 0    0 0  000 0 0    "
 
 * = music
 	        .import binary "LittleSecret.sid",$7c+2