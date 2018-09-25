; standart.asm
; macros for standart codes
;============================================================================

!macro BASIC_START {
	* = $0801                               ; BASIC start address (#2049)
	!byte $0d,$08,$dc,$07,$9e,$20,$34,$39   ; BASIC loader to start at $c000...
	!byte $31,$35,$32,$00,$00,$00           ; puts BASIC line 2012 SYS 49152
}

!macro CLEAR_SCREEN {
	ldx #00
	lda #$20
.loop	sta SCREEN_RAM,x
	sta SCREEN_RAM+255,x
	sta SCREEN_RAM+510,x
	sta SCREEN_RAM+765,x
	sta SCREEN_RAM+1020,x
	dex
	bne .loop
}

!macro SET_RASTER_IRQ {
	sei

	lda #$7f
	sta $dc0d

	lda $d01a
	ora #$01
	sta $d01a

	lda #$00
	sta $dc0e
	
       	lda #$1b
       	sta $d011

	lda #$00
	sta $d012
		
	lda #<irq
	sta $0314
	lda #>irq
	sta $0315
 
        cli

}