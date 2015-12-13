!to "build/rspr.prg",cbm

!src "standart.asm"

	SCREEN_RAM	= $0400
	counter = $02

	+SET_START $c000

	jsr SCINIT
        	
	lda #$0b
    sta $d020
    lda #$00
    sta $d021

	ldx #$00		;set sprite pointers 
 	lda #$80
- 	sta $07f8,x
	adc #$01
	inx
	cpx #$08
	bne -	

	ldx #$00 		;set sprite colors
	lda #$01		
-	sta $d027,x 
 	inx
 	cpx #$08
	bne -	

	lda #$01
	sta $d027	
	
	lda #$FF		;enable all sprites
	sta $d015
	
	lda #15 		;Set X-coordinates
	ldx #00
-	sta $d000,x 
	inx
	inx
	cpx #16
	bne - 

	ldx #$00 		; Set Y-coordinates
	ldy #$01
-	lda spriteY,x
	sta $d000,y 
 	inx
 	iny
 	iny
 	cpx #$08
 	bne -
	
	dec $d020

	jsr irqSetup

	jmp *


* = $2000
	!bin "rsprt_bullet.bin"

irqSetup:
!zone {
	sei			; disable interrupts
	lda #$7f	; turn off the cia interrupts
	sta $dc0d
	;sta $dd0d

	lda #$00 	; disable timer irq
	sta $dc0e

	lda #$01	; enable raster irq
	sta $d01a

	lda $d011	; clear high bit of raster line
	and #$7f
	sta $d011
	lda #$f0    ; set low byte of raster line
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
	;update sprite pointers
	ldy $07f8
	iny
	cpy #$88
	bne +
	ldy #$80		
+	sty $07f8
 	sty $07f8+1
 	sty $07f8+2
 	sty $07f8+3
 	sty $07f8+4
 	sty $07f8+5
 	sty $07f8+6
 	sty $07f8+7

 	inc $d020
	
	;Shift sprites vertically ----------------------------------
    ldx #00 			; X = spriteNum
-   ldy spriteDeltaX,x 	; y = deltaX
    
--  inc spritePosX,x 	; increase sprite x
    lda spritePosX,x 
    bne .noChange 		; <>0, extended flag will not change

	lda bitTable,x 		; set extended flag
	ora $d010
	sta $d010

.noChange:
    dey
	bne --

	inx
    cpx #8
 	bne -

 	;Chech if sprite is beyond visible area --------------------
 	ldx #00
-- 	lda bitTable,x 		; a = bitmask
 	bit $d010
 	beq +				; Z=1, skip

 	lda spritePosX,x
 	cmp #80 			;Sprite x < 20, skip
 	bcc +

 	lda #15
 	sta spritePosX,x
 	lda $d010
 	eor bitTable,x
 	sta $d010

 	lda spriteDeltaX+8 	;Sprite hızını güncelle
 	clc
 	adc #01
 	cmp #$05
 	bcc .j01
 	lda #$01
.j01	
 	sta spriteDeltaX,x
 	sta spriteDeltaX+8
+

	inx
 	cpx #08
 	bne --

 	;Update Sprites --------------------------------------------
 	ldx #00
 	ldy #00
- 	lda spritePosX,x
 	sta $d000,y
 	inx
 	iny
 	iny
 	cpx #08
 	bne -

    dec $d020
	
	
	asl $d019	; ack interrupts
	jmp $ea31	; exit back to rom
	}	

spriteDeltaX:	!by 1,2,3,4,1,2,3,4,0
spriteY: !by 100,110,120,130,140,150,160,170
bitTable  !byte 1,2,4,8,16,32,64,128
spritePosX !byte 0,0,0,0,0,0,0,0,0,0