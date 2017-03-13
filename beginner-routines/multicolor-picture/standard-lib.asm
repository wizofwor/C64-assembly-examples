; standart.asm
; macros for standart codes
;============================================================================

!macro SET_START .address {

	;Inject SYS .addres in BASIC memory

	* = $0801
	
	!byte $0c,$08,$0a,$00,$9e 	; 10SYS
	!byte (.address/10000)+48
	!byte (.address/1000)%10+48
	!byte (.address/100)%10+48
	!byte (.address/10)%10+48
	!byte (.address%10)+48
	!byte 0
	
	* = .address
}

!macro CLEAR_SCREEN {
	
	ldx #00
	lda #$20
.loop:
	sta SCREEN_RAM,x
	sta SCREEN_RAM+255,x
	sta SCREEN_RAM+510,x
	sta SCREEN_RAM+765,x
	sta SCREEN_RAM+1020,x
	dex
	bne .loop
}

!macro inc16 .address{

	;16bit unsigned increase
	inc .address
	bne *+5
	inc .address+1
}

; define a pixel row of a C64 hardware sprite
!macro SpriteLine .v {
	!by .v>>16, (.v>>8)&255, .v&255
}

; KERNAL ROUTUNES
;============================================================================
SCINIT	= $FF81	; Initialize screen editor.
CHROUT	= $FFD2 ; Output character to channel.
GETIN 	= $FFE4 ; Get character from keyboard buffer.
SCNKEY	= $FF9F	; Scan keyboard.
PLOT	= $FFF0 ; Read/set X,Y cursor position.

;STANDARD ZEROPAGE
;============================================================================
CURCOL	= $0286	; Cursor color