; standart.asm
; macros for standart codes
;============================================================================

!macro SET_START .address {
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
.loop	sta SCREEN_RAM,x
	sta SCREEN_RAM+255,x
	sta SCREEN_RAM+510,x
	sta SCREEN_RAM+765,x
	sta SCREEN_RAM+1020,x
	dex
	bne .loop
}

; KERNAL ADRESSES
;============================================================================
SCINIT = $FF81