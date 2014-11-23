!to "build/raster01.prg",cbm

* = $0801                               ; BASIC start address (#2049)
!byte $0d,$08,$dc,$07,$9e,$20,$34,$39   ; BASIC loader to start at $c000...
!byte $31,$35,$32,$00,$00,$00           ; puts BASIC line 2012 SYS 49152

* = $c000

counter = $02
scanline = $03

	lda #50
	sta scanline

	jsr clear_screen
	jsr set_irq

	jmp *

;----------------------------------------------------------
; CLEAR SCREEN
;----------------------------------------------------------
clear_screen	
	lda #$20
	ldx #00
-	sta $0400,x
	sta $0500,x
	inx
	bne -
	rts	

;--------------------------------------------------------
; SET IRQ
;--------------------------------------------------------
set_irq	sei

	lda #$7f	;Disable CIA I and CIA II interrupts
	sta $dc0d

	lda $d01a	;Enable raster interrupts
	ora #$01
	sta $d01a

	lda #$00
	sta $dc0e
	
	lda #48 	;set raster line
	sta $d012
	lda $d011
	and #$7f 	;%01111111
    	sta $d011
		
	lda #<irq 	;set interrupt handler
	sta $0314
	lda #>irq
	sta $0315
 
    	cli
	
	rts

;---------------------------------------------------------
; IRQ 
;---------------------------------------------------------
!zone irq1{
irq
	ldx #03  	;wait for new line
-	dex
	bne -

	ldx #00    	;reset counter
.next	lda colors,x 	
	sta $d020
	sta $d021

	ldy delay,x 	;grab delay value and
.wait	dey 		;wait for end of line
	bne .wait

	inx 	 	;compare x with
	cpx #200 	;number of bars and
	bne .next 	;loop for next bar

	ldx #03  	;wait for new line
-	dex
	bne -

	lda #00 	;reset colors
	sta $d020
	sta $d021

	;jsr calculate 	;calculate the effect	

.end	asl $d019 	;acknowledge interrupt register
	jmp $ea81

}
;----------------------------------------------------------
; CALCULATe
;----------------------------------------------------------
calc
	ldx counter
	dex
	bne .end

.end	rts

;----------------------------------------------------------
; Data
;----------------------------------------------------------

delay !for label, 15 {!by 8,8,2,6,8,8,9,8}
colors !fill 200, 00
