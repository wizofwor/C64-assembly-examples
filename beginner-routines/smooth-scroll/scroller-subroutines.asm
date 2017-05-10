// Subroutines for scroller.asm

init: {
	lda #$06		// set background color
	sta $d020

	ldx #$00 		// set counter
	lda #$20 		// set fill char
loop:
	sta SCREEN_RAM,x
	sta SCREEN_RAM+$FF,x
	sta SCREEN_RAM+$1FF,x
	sta SCREEN_RAM+$2FF,x
	inx
	bne loop
	rts	
}	

print_screen: {
	ldx #$00
loop:
 	lda text1,x
	sta SCREEN_RAM+440,x
	lda text2,x
	sta SCREEN_RAM+200,x
	inx
	cpx #200
	bne loop
	rts
}

set_raster: {
    sei             // block interrupts

    lda #$7f
    sta $dc0d		// Cancel CIA IRQ's

    lda $d01a		// Set raster IRQ request		
    ora	#$01
    sta $d01a

    lda $d011       // Set rasterline
    and #$7f        // first bit of $d011 is actually ...
    sta $d011       // ... 8th bit of the rasterline

    lda #$FB        // trigger first interrupt at row 0
    sta $d012

    lda #<irq  		// set interrupt vectors
    sta $314  		// the address of our interrupt code
    lda #>irq
    sta $315

    cli     		// enable maskable interrupts again

    rts
	}


shift2: {
	ldx #$00
	ldy SCREEN_RAM+40*11
loop:
	lda SCREEN_RAM+40*11+1,x
	sta SCREEN_RAM+40*11,x
	inx
	cpx #40
	bne loop
	sty SCREEN_RAM+40*11+39
	rts
}

shift3: {
	ldx #$00
	ldy SCREEN_RAM+40*12
loop:
	lda SCREEN_RAM+40*12+1,x
	sta SCREEN_RAM+40*12,x
	inx
	cpx #40
	bne loop
	sty SCREEN_RAM+40*12+39
	rts
}

shift4: {
	ldx #$00
	ldy SCREEN_RAM+40*13
loop:
	lda SCREEN_RAM+40*13+1,x
	sta SCREEN_RAM+40*13,x
	inx
	cpx #40
	bne loop
	sty SCREEN_RAM+40*13+39
	rts
}

shift5: {
	ldx #$00
	ldy SCREEN_RAM+40*14
loop:
	lda SCREEN_RAM+40*14+1,x
	sta SCREEN_RAM+40*14,x
	inx
	cpx #40
	bne loop
	sty SCREEN_RAM+40*14+39
	rts
	}


move_logo: {
	lda SCREEN_RAM+40*5			// grab first characters
	sta buffer1					// and put into buffer
	lda SCREEN_RAM+40*6
	sta buffer2
	lda SCREEN_RAM+40*7
	sta buffer3
	lda SCREEN_RAM+40*8
	sta buffer4
	lda SCREEN_RAM+40*9
	sta buffer5

	ldx #$00
loop:
	lda SCREEN_RAM+40*5+1,x		// shift row1
	sta SCREEN_RAM+40*5,x
	sta SCREEN_RAM+40*16,x
	lda SCREEN_RAM+40*6+1,x		// shift row2
	sta SCREEN_RAM+40*6,x
	sta SCREEN_RAM+40*17,x
	lda SCREEN_RAM+40*7+1,x		// shift row3
	sta SCREEN_RAM+40*7,x
	sta SCREEN_RAM+40*18,x		
	lda SCREEN_RAM+40*8+1,x		// shift row4
	sta SCREEN_RAM+40*8,x
	sta SCREEN_RAM+40*19,x		
	lda SCREEN_RAM+40*9+1,x		// shift row5
	sta SCREEN_RAM+40*9,x
	sta SCREEN_RAM+40*20,x				
	inx
	cpx #40
	bne loop

	lda buffer1					// put back first characters
	sta SCREEN_RAM+40*5+39		// to the end of rows
	lda buffer2
	sta SCREEN_RAM+40*6+39	
	lda buffer3
	sta SCREEN_RAM+40*7+39
	lda buffer4
	sta SCREEN_RAM+40*8+39
	lda buffer5
	sta SCREEN_RAM+40*9+39

	rts

	}