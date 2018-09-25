!to "build/spm.prg",cbm

!src "standart.asm"

	SCREEN_RAM	= $0400
	COUNTER 	= $02
	TARGET_RASTER = $03
	OFFSET =$04

	+SET_START $c000

	jsr SCINIT

!zone {
sprite_init:       	
	lda #$0b
    sta $d020
    lda #$0c
    sta $d021

	ldx #$00		;set sprite pointers 
 	lda #$80
- 	sta $07f8,x
	inx
	cpx #$08
	bne -	

	ldx #$00 		;set sprite colors
	lda #$0b		
-	sta $d027,x 
 	inx
 	cpx #$08
	bne -	
	
	lda #$FF		;enable all sprites
	sta $d015

	lda #$FF 		;extend-sprites
	;sta $d017
	sta $d01d
	
	lda #15 		;set sprite-x
	ldx #00
-	sta $d000,x 
	inx
	inx
	cpx #16
	bne - 

	lda #128+64
	sta $d010

	ldx #$00 		; Set sprite-y
	ldy #$01
-	lda spritey,x
	sta $d000,y 
 	inx
 	iny
 	iny
 	cpx #$08
 	bne -
	}

	dec $d020

	jsr irqSetup

	lda #50
	sta TARGET_RASTER

	lda #30
	sta OFFSET

	jmp *


* = $2000
	!bin "skull.bin"

irqSetup:
!zone {
	sei			; disable interrupts
	lda #$7f	; turn off the cia interrupts
	sta $dc0d
	sta $dd0d

	lda #$00 	; disable timer irq
	sta $dc0e

	lda #$01	; enable raster irq
	sta $d01a

	lda $d011	; clear high bit of raster line
	and #$7f
	sta $d011
	lda #10    ; set low byte of raster line
	sta $d012 
	
	lda #<irq	; set interrupt vectors
	sta 788                       
	lda #>irq
	sta 789
	cli			; enable interrupts

	rts
      	}
;------------------------------------------------------------------------------

irq:
!zone irq{

	lda #0
	sta COUNTER
	
	;Shift sprites vertically ----------------------------------
    ldx #00 			; X = spriteNum
    
- 	sec					; decrease
	lda spritex,x 		; sprite-x
	sbc #01 			; by 1
	sta spritex,x

	bcs + 				;if carry is set change the page		
	lda $d010 			
	eor bitTable,x
	sta $d010


	lda bitTable,x 		;if sprite is not in page 2
	bit $d010 			;skip to +
	beq +
	lda #$f7 			;if sprite in page 2 
	sta spritex,x 		;set sprite-x to $f7
+	
	;if sprite-x is between 80-200 in page to, make it = 80  
	lda bitTable,x 		;if sprite is not in page 2
	bit $d010 			;skip to +
	beq +

	lda spritex,x 		;if x-pos<80 		
	cmp #80 			;skip to +
	bcc +
	cmp #200 			;if x-pos>200
	bcs + 				;skip to +

	lda #80 			;x-pos = 80
	sta spritex,x
+
	inx 				;repeat the loop
    cpx #8 				;for 8 sprites
 	bne -

 	;Update Sprite-x --------------------------------------------
 	ldx #00
 	ldy #00
- 	lda spritex,x
 	sta $d000,y
 	inx
 	iny
 	iny
 	cpx #08
 	bne -


 	;Copy same sprites for repeating rows--------------------------

raster_loop:
	ldx COUNTER 		;read target raster
	lda rowTable,x 		;from table
	clc 				;and add offset
 	adc OFFSET
 	sta TARGET_RASTER

 	lda TARGET_RASTER 	;wait for target raster
- 	cmp $d012
 	bne -

 	;inc $d020
 	
 	lda spritey,x 		;load sprite-y from table
 	clc 				;and add offset
 	adc OFFSET
		
 	ldy #00 			;update sprite-y
- 	sta $d001,y
 	iny
 	iny
 	cpy #16
 	bne -

    inc COUNTER 		;increase counter
    lda COUNTER 		;then loop
    cmp #8
    bne raster_loop

    dec OFFSET
    bne +
    lda #30
    sta OFFSET
+

    ;Finalize IRQ-------------------------------------------------
	lda #0
	sta $d020

	asl $d019	; ack interrupts
	jmp $ea31	; exit back to rom
	}	

rowTable: 	!by 25,55,85,115,145,175,205,235	
spritey: 	!by 30,60,90,120,150,180,210,240
dx:			!by 1,2,3,4,1,2,3,4,0
bitTable:	!by 1,2,4,8,16,32,64,128
spritex:	!by 0,48,96,144,194,242,32,80