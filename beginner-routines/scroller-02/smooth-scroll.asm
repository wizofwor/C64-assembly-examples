!to "build/smooth_scroll.prg",cbm

* = $0801                               ; BASIC start address (#2049)
!byte $0d,$08,$dc,$07,$9e,$20,$34,$39   ; BASIC loader to start at $c000...
!byte $31,$35,$32,$00,$00,$00           ; puts BASIC line 2012 SYS 49152

offset	= $02
delay	= $03
charCount   = $04

	* = $c000
	
	sei
	lda #00
	sta charCount

;---------------------------------------------------------
; Clear Screen
;---------------------------------------------------------	
prepare	lda #05
	sta $d020
	lda #06
	sta $d021
	
	ldx #00
	lda #$20
clear	sta $0400,x
	sta $0500,x
	sta $0600,x
	sta $0700,x
	inx
	bne clear
	
	ldx #00
write	lda text,x
	sta $0400,x
	lda text+40,x
	sta $07c0,x
	inx
	cpx #40
	bne write

;-------------------------------------------------------------------------
; Actual Drawing
;-------------------------------------------------------------------------

	; Scrolling part ******************************************

raster1	lda #60		;Wait for row 60 to scroll
	cmp $d012		
	bne raster1+2

	ldx #11		;Wait a little for stable raster
wait	dex
	bne wait	
	
	inc $d020
	lda offset
	sta $d016	
	
	; Fixed part **********************************************
		
raster2	lda #241		;Wait for row 240 to scroll
	cmp $d012		
	bne raster2+2
	
	ldx #2		;Wait a little for stable raster
wait2	dex
	bne wait2	

	lda #00		;reset $d016
	sta $d016	
	dec $d020	
		
;--------------------------------------------------------------------------
; Offset calculation
;--------------------------------------------------------------------------
	lda offset		;Calculate offset value
	sec
	sbc #01
	and #07
	sta offset

	; Shift character row ***********************************	
	cmp #07		;When offset value is 7
	bne spaceCheck	;shift charecter row
	
	ldx #00		;Shift character slots
shift	lda $05e0,x		;between 00-38
	sta $05df,x
	inx
	cpx #39
	bne shift
	
	ldx charCount	;grab next character
	lda text+80,x	;from the table
	sta $0606						

	inc charCount
	lda #80									
	cmp charCount	;check textCount and
	bne spaceCheck	;reset if larger then 80
	lda #00
	sta charCount
	
	;Check for spacebar *************************************
	
spaceCheck	lda $dc01		; Check for spacebar
	cmp #$ef		; if pressed restore kernel IRQ
	bne raster1		; and return to BASIC
	sei
	jsr $ff81
	rts
		
;------------------------------------------------------------------------
; DATA
;------------------------------------------------------------------------
text
!scr "         one row smooth scroller        "
!scr "          press space to quit           "	
!scr "hello world!                 in a smooth"	
!scr " way(!)                                 "
