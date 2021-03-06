/* ============================================================== *
  
  C64 ASM TUTORIALS by wizofwor

  SMOOTH SCROLL - PETSCII SCROLLER SUBROUTINES

  Environment: KickAssembler v.4.12
  Date: November 2014 - September 2018   
  
 * ============================================================== */

setIRQ: {
        	sei	
        	lda #$7f	// turn off the cia interrupts
        	sta $dc0d
        	sta $dd0d
        	lda #$01	// enable raster irq
        	sta $d01a
        	lda $d011	// clear high bit of raster line
        	and #$7f
        	sta $d011
        	lda #100        // set low byte of raster line
        	sta $d012 
        	
        	lda #<irq	// set interrupt vectors
        	sta 788                       
        	lda #>irq
        	sta 789
        	cli	
}

setScreen: {
                ldy #$00
!:      	lda charData,y
        	sta SCREEN_RAM,y
        	lda charData+$FF-1,y
        	sta SCREEN_RAM+$FF-1,y
        	lda charData+$1FF-1,y
        	sta SCREEN_RAM+$1FF-1,y
        	lda charData+$2FF-1,y
        	sta SCREEN_RAM+$2FF-1,y
        	lda colorRam,y
        	sta $d800,y
        	lda colorRam+$FF-1,y
        	sta $d800+$FF-1,y
        	lda colorRam+$1FF-1,y
        	sta $d800+$1FF-1,y
        	lda colorRam+$2ff-1,y
        	sta $d800+$2ff-1,y
        	iny
        	bne !-
        	
        	rts
}

irq: {
            /* IRQ routine   
            
            Sets x-scroll register and for each raster zone 
            and sets scrollFlag on Each screen refresh
            */

        	// wait for next raster for stable effect
        	ldx irqIndex 
        	lda scrollRasterLo,x
        	clc
        	adc #$01
!:      	cmp $d012
        	bne !-
        	    
         	// set XSCROLL
         	lda scrollOffset,x
         	sta $d016
        	// increase irqIndex
         	inx 		
         	cpx #25
         	bne !+ 		        // index != 25, skip
         	ldx #00 	        // reset index
         	lda #01 	        // set scrollFlag
         	sta scrollFlag
!:      	stx irqIndex 	        // store updated index value
        	lda scrollRasterLo,x    // update raster row for next irq
        	sta $d012	
	
end:        dec $d019	        // acnowledge IRQ register
        	jmp $ea81 	        // return to kernel
}

shiftRows: {
            /* Shift a row by one char left 

            Input:
              beginning adress in SCREEN_RAM at charTarget, charTarget+1
              beginning adress in COLOR_RAM at colorTarget, colorTarget+1
            */

            // put cell #0 data to buffer
        	ldy #00 		
        	lda (charTarget),y
        	sta charBuffer
        	lda (colorTarget),y
        	sta colorBuffer

            // shift chars
!:      	iny	
        	lda (charTarget),y
        	dey
        	sta (charTarget),y

            // shift colors
        	iny
        	lda (colorTarget),y
        	dey
        	sta (colorTarget),y

        	iny
        	cpy #39
        	bne !-

            // copy cell #39 from buffer
        	lda charBuffer 		
        	sta (charTarget),y
        	lda colorBuffer
        	sta (colorTarget),y
        	rts
}