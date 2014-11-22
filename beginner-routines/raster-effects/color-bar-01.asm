!to "build/color_bar01.prg",cbm

* = $0801                               ; BASIC start address (#2049)
!byte $0d,$08,$dc,$07,$9e,$20,$34,$39   ; BASIC loader to start at $c000...
!byte $31,$35,$32,$00,$00,$00           ; puts BASIC line 2012 SYS 49152

* = $c000



	sei
	
main		

raster	lda #150		;Wait for raster line 
	cmp $D012		
        	bne raster+2	

	ldy #10		;Loose time to hide the
idle1	dey		;flickering at the beginning 
	bne idle1		;of the effect

;------------------------------------------------------------------
; Main Loop to print raster bars
;------------------------------------------------------------------
	ldx #00		
loop	lda colorTable,x	;assign background and border
   	sta $d020		;colors
	sta $d021

	ldy delayTable,x	;Loose time to hide the
idle2	dey		;flickering at the end
	bne idle2		;of the effect


	inx 		;
	cpx #09
	bne loop
;------------------------------------------------------------------
; End of main loop
;------------------------------------------------------------------

    	lda #$0e		;Assign default colors
    	sta $d020
	lda #$06
	sta $d021
	
	JMP main

colorTable:
!by 09,08,12,13,01,13,12,08,09

delayTable:
!by 08,08,09,08,12,08,08,08,09




