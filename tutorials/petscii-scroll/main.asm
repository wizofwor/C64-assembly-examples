/* ============================================================== *

  C64 ASM TUTORIALS by wizofwor

  SMOOTH SCROLL - PETSCII SCROLLER

  Environment: KickAssembler v.4.12
  Date: November 2014 - September 2018   
 
 * ============================================================== */

// Address Definitions:
.const SCREEN_RAM = $0400
.const music = $1000
.const musicPlay = music + 3 

// Zero Page Addresses
.const counter 	   = $02
.const scrollFlag  = $04 
.const charBuffer  = $05  
.const colorBuffer = $06
.const charTarget  = $07 // two bytes for charShift target adress
.const colorTarget = $09 // two bytes for colorShift target adress

// --- Macros ------------------------------------------------------

.macro setStart(addr) {
        /* setStart macro is useless in KickAss provided that 
        there is built in basicUpstart macro. It is used here
        for reference purpose only. Use builtin basicUpstart insted.
        */
        * = $0801 "Basic Autostart"
        
        .byte $0c,$08,$0a,$00,$9e       // 10SYS
        .byte mod(addr/10000,10)+48
        .byte mod(addr/1000,10)+48
        .byte mod(addr/100,10)+48
        .byte mod(addr/10,10)+48
        .byte mod(addr,10)+48
        .byte 0
        
        * = addr "Main"
}

.macro clear_screen() {
                ldx #00
                lda #$20
loop:   sta SCREEN_RAM,x
                sta SCREEN_RAM+255,x
                sta SCREEN_RAM+510,x
                sta SCREEN_RAM+765,x
                sta SCREEN_RAM+1020,x
                dex
                bne loop
}

// --- Main Program with Basic Upstarter ---------------------------

setStart($C000)

        	clear_screen()

        	lda #$00
        	sta $d020
        	sta $d021
        	
        	jsr setScreen
        	jsr setIRQ

                /* If scrollFlag is set by IRQ compare timerBase & timer
                If timer base for a row is equal to the timer
                scroll the row */

                // check if the scroll flag is set
main:   	lda scrollFlag 	  
        	beq endScroll

                // Main Loop
        	ldx #$00		// for each character row	
mLoop:	        ldy scrollSpeed,x	// chech the speed mask
        	lda speedMask,y
        	bit counter
        	bne !+
        			
        	lda scrollOffset,x 	// Hardware Scroll
        	sec
        	sbc #$01
        	and #$07
        	sta scrollOffset,x
        	
        	cmp #$07
        	bne !+
	
	        // Character Shift
        	lda charShiftAdressesLo,x 	// set beginning adresses
        	sta charTarget 			// for character shift
        	lda charShiftAdressesHi,x 	// and color shift	
        	sta charTarget+1
        	lda colorShiftAdressesLo,x
        	sta colorTarget
        	lda colorShiftAdressesHi,x
        	sta colorTarget+1
        	jsr shiftRows 			// do shift	
	
!:	        inx
        	cpx #25
        	bne mLoop 

                // End of Main Loop

         	// reset scroll flag
          	lda #00	
          	sta scrollFlag

          	// increase counter till #$0f
          	inc counter
          	lda counter
         	and #$3f	// %00011111
          	sta counter

        	jsr musicPlay   // play music     
endScroll:	jmp main        // loop again

// --- Data --------------------------------------------------------


irqIndex: 	.byte 0
scrollRasterLo: .byte 049,058,066,074,082,090,098,106,113,122
	        .byte 128,136,144,152,160,170,178,186,194,202
	        .byte 210,218,226,234,242,250

scrollOffset:   .fill 25,$0
charShiftAdressesLo:
	       .byte $00,$28,$50,$78,$A0,$C8,$F0,$18,$40,$68
	       .byte $90,$B8,$E0,$08,$30,$58,$80,$A8,$D0,$F8	
	       .byte $20,$48,$70,$98,$C0
charShiftAdressesHi: 
	       .byte $04,$04,$04,$04,$04,$04,$04,$05,$05,$05
	       .byte $05,$05,$05,$06,$06,$06,$06,$06,$06,$06	
	       .byte $07,$07,$07,$07,$07
colorShiftAdressesLo:
	       .byte $00,$28,$50,$78,$A0,$C8,$F0,$18,$40,$68	
	       .byte $90,$B8,$E0,$08,$30,$58,$80,$A8,$D0,$F8	
	       .byte $20,$48,$70,$98,$C0
colorShiftAdressesHi: 
	       .byte $D8,$D8,$D8,$D8,$D8,$D8,$D8,$D9,$D9,$D9	
	       .byte $D9,$D9,$D9,$DA,$DA,$DA,$DA,$DA,$DA,$DA	
	       .byte $DB,$DB,$DB,$DB,$DB

scrollSpeed:   .byte 4,3,2,1,0,0,0,0,0,0
	       .byte 0,0,0,0,0,1,2,1,2,3
	       .byte 2,3,4,3,4

speedMask:     .byte %111111,%110111,%101010,%001001,%000000	

#import "subroutines.asm"
#import "data.asm"

* = music "Music"
.import binary "Antictxt.sid",$7c+2