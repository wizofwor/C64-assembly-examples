!to "multi.prg",cbm

* = $0801                               ; BASIC start address (#2049)
!byte $0d,$08,$dc,$07,$9e,$20,$34,$39   ; BASIC loader to start at $c000...
!byte $31,$35,$32,$00,$00,$00           ; puts BASIC line 2012 SYS 49152

* = $c000

SCREEN_RAM	= $0400
COLOR_RAM	= $D800
COUNTER	= $03
ENVELOPE 	= $04
PARAM	= $05	 

;-------------------------------------------------------------------------
;  Startup
;-------------------------------------------------------------------------
	lda #$00
	sta COUNTER
	sta ENVELOPE

!zone clear_screen{
clear_screen:
	lda #$0e
	sta $d021

	ldx #$00 		; set counter
	lda #$20 		; set fill char

.loop	sta SCREEN_RAM,x
	sta SCREEN_RAM+$FF,x
	sta SCREEN_RAM+$1FF,x
	sta SCREEN_RAM+$2FF,x
	inx
	bne .loop
	}

!zone initialize_sprites{
	lda #$86		;set sprite pointers 
	sta $07f8		
	lda #$80		
	sta $07f9

	lda #$03		;enable sprites 0,1 
	sta $d015

	lda #$01		;set sprite colors
	sta $d027
	lda #$00		
	sta $d028
	}

!zone irq_setup{
	sei	; disable interrupts
	lda #$7f	; turn off the cia interrupts
	sta $dc0d
	sta $dd0d
	lda #$01	; enable raster irq
	sta $d01a
	lda $d011	; clear high bit of raster line
	and #$7f
	sta $d011
	lda #100    ; set low byte of raster line
	sta $d012 
	
	lda #<irq	; set interrupt vectors
	sta 788                       
	lda #>irq
	sta 789
	cli	; enable interrupts
      	}
	
	
;------------------------------------------------------------------------
;    Main Loop
;------------------------------------------------------------------------
main	inc $d020		; time check

	ldx #$00		; calculate positions
loop1	jsr calc_pos
	inx
	cpx #$09
	bne loop1
	
	ldx #$04
	jsr calc_pos
	inx
	jsr calc_pos
	inx
	jsr calc_pos
	jsr calc_pos
		
	;-----------------------------------
	; Draw
	;-----------------------------------
	;wait
	lda #$f8
waitframe	cmp $d012
	bne waitframe
		
waitframe2	cmp $d012
	beq waitframe2
	
	;update sprite pointers
	lda $07f9
	cmp #$85
	bne .jump
	lda #$82
	sta $07f9
.jump	inc $07f9


	dec $d020 
	jmp main

;-----------------------------------------------------------------------
; Calculate positions
;-----------------------------------------------------------------------
!zone move_player {
	;check extended position bit
calc_pos	lda table_xe,x
	sta PARAM

	lda #%00000010	; bitmask for sprite #02
	bit PARAM		; check againist bitmask
	bne .jump2		;  
	;while extended position bit is off
	lda #$FF		; if the x=$FF
	cmp table_x,x	; turn on extended position bit
	bne .increase	; and make x=$00
	lda #%00000011
	sta table_xe,x
	lda #$00
	sta table_x,x
	jmp .end
.jump2	;while extended position bit is set
	lda #$5F		; if position =$2f
	cmp $d000		; turn of extended position bit
	bne .increase	; and make x=$00
	lda #$10
	sta table_x,x
	sta table_xe,x
.increase	
	inc table_x,x		
.end	rts
	}	
	
;-----------------------------------------------------------------------
; IRQ Routine
;-----------------------------------------------------------------------
!zone irq_routine {
irq	inc ENVELOPE	; increase envelope number	
	lda #$09		; but if it is 04
	cmp ENVELOPE	; make it 00
	bne .jump
	lda #00
	sta ENVELOPE	
.jump	ldx ENVELOPE	; use envelope num. as index
	

	lda table_xe,x 	;update sprite position
	sta $d010
	lda table_x,x
	sta $d000
	sta $d002
	lda table_y,x
	sta $d001
	sta $d003
	
	stx $d027		;update some colors
	stx $d020
	

	lda $d019	; clear source of interrupts
	sta $d019
	lda table_y,x	; reset line number to go off at
	sta $d012
	jmp $ea31	; exit back to rom
	}	
	
;-----------------------------------------------------------------------
;     Data
;-----------------------------------------------------------------------
table_x !by $00,$10,$33,$28,$13,$15,$00,$10,$00,$00
table_xe !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
table_y !by $32,$48,$5e,$74,$8a,$a0,$b6,$cc,$e2,$f8

*=$2000
!bin "fly8.spd",515,3

