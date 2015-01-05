;============================================================================
; Lightning Petscii Scroller
; 
;============================================================================
!to "build/scroller04.prg",cbm
!src "standart.asm"

SCREEN_RAM = $0400
counter = $02

scrollFlag = $04 
charBuffer = $05  
colorBuffer = $06
charTarget = $07 	;two bytes for charShift target adress
colorTarget = $09  	;two bytes for colorShift target adress

music = $1000
musicPlay = music + 3 

;============================================================================

	+SET_START $C000
	+CLEAR_SCREEN

start:	
	lda #$00
	sta $d020
	sta $d021
	
	jsr setScreen
	jsr setIRQ

;============================================================================
;MAIN:
;If scrollFlag is set by IRQ
;Compare timerBase & timer
;If timer base for a row is equal to timer scroll the the row
;============================================================================
!macro shiftRows .startAdress{
	lda #<.startAdress
	sta target
	lda #>.startAdress
	sta target+1 	
	jsr shiftRows
}


main:
	
	lda scrollFlag 		;check if the scroll flag is set
	beq .endScroll

	;---------------/ Main Loop /-------------------------------------
	ldx #$00		;for each character row
mLoop	
	ldy scrollSpeed,x	;chech the speed mask
	lda speedMask,y
	bit counter
	bne +
			
	lda scrollOffset,x 	;Hardware Scroll
	sec
	sbc #$01
	and #$07
	sta scrollOffset,x
	
	cmp #$07
	bne +
	
	;Character Shift
	lda charShiftAdressesLo,x 	;set beginning adresses
	sta charTarget 			;for character shift
	lda charShiftAdressesHi,x 	;and color shift	
	sta charTarget+1
	lda colorShiftAdressesLo,x
	sta colorTarget
	lda colorShiftAdressesHi,x
	sta colorTarget+1
	jsr shiftRows 			;do shift	
+	
	inx
	cpx #25
	bne mLoop 

	;---------------/ End of Main Loop /------------------------------

 	;reset scroll flag
  	lda #00	
  	sta scrollFlag

  	;increase counter till #$0f
  	inc counter
  	lda counter
 	and #$3f	;%00011111
  	sta counter

  	;play music	
	jsr musicPlay

.endScroll	
	jmp main

;============================================================================
;DATA:
;============================================================================
irqIndex: 	  !by 0
scrollRasterLo: 
	!by 049,058,066,074,082,090,098,106,113,122
	!by 128,136,144,152,160,170,178,186,194,202
	!by 210,218,226,234,242,250
scrollOffset: !fill 25,$0
charShiftAdressesLo:
	!by $00,$28,$50,$78,$A0,$C8,$F0,$18,$40,$68
	!by $90,$B8,$E0,$08,$30,$58,$80,$A8,$D0,$F8	
	!by $20,$48,$70,$98,$C0
charShiftAdressesHi: 
	!by $04,$04,$04,$04,$04,$04,$04,$05,$05,$05
	!by $05,$05,$05,$06,$06,$06,$06,$06,$06,$06	
	!by $07,$07,$07,$07,$07
colorShiftAdressesLo:
	!by $00,$28,$50,$78,$A0,$C8,$F0,$18,$40,$68	
	!by $90,$B8,$E0,$08,$30,$58,$80,$A8,$D0,$F8	
	!by $20,$48,$70,$98,$C0
colorShiftAdressesHi: 
	!by $D8,$D8,$D8,$D8,$D8,$D8,$D8,$D9,$D9,$D9	
	!by $D9,$D9,$D9,$DA,$DA,$DA,$DA,$DA,$DA,$DA	
	!by $DB,$DB,$DB,$DB,$DB
scrollSpeed:
	!by 4,3,2,1,0,0,0,0,0,0
	!by 0,0,0,0,0,1,2,1,2,3
	!by 2,3,4,3,4
speedMask 
	!by %111111,%110111,%101010,%001001,%000000	

!src "subroutines.asm"
!src "data.asm"

* = music
	!bin "Selector_88_part_2",,$7c+2