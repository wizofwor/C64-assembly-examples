;##############################################################################
;#
;# MULTICOLOR PICTURE EXAMPLE
;#
;##############################################################################

!to "build/multicolor.asm",cbm
!src "standard-lib.asm" 	;standard macros

; Adress definitions
SCREEN_RAM = $0400
COLOR_RAM = $d800
BITMAP_RAM = $2000

+SET_START $4000

; program

main:
	lda $D011 	;switch to bitmap
	ora #$20
	sta $D011

	lda $d016 	;switch to multicolor
	ora #$10
	sta $d016

	lda #$18
	sta $d018

; Set Background and Border Colors

	lda back
	sta $d021
	lda border
	sta $d020	

; Copy Bitmap Data (Bitmap mask)

	ldx #$00
copyMap1:
	!for n,0,15 {
		lda bitmap+255*n,x
		sta BITMAP_RAM+255*n,x
		}							
	inx
	bne copyMap1

	ldx #$00
copyMap2:
	!for n,16,31 {
		lda bitmap+255*n,x
		sta BITMAP_RAM+255*n,x
		}							
	inx
	bne copyMap2


; Copy Screen Ram (Holds color data for mask 01 and 10 in bitmap)

	ldx #$00
copyScr:
	!for n,0,3 {
		lda screen+255*n,x
		sta SCREEN_RAM+255*n,x
		}							
	inx
	bne copyScr


; Copy Color Ram (Holds color data for mask 11 in bitmap)

	ldx #$00
copyCol:
	!for n,0,3 {
		lda colors+255*n,x
		sta COLOR_RAM+255*n,x
		}							
	inx
	bne copyCol

; endless loop

	jmp *

; Hires_data
;
; border,back: fixed colors
; bitmap: Bitmap mask, will be copied to bitmap ram
; colors: Color data for mask 01 and 10, will be copied to color ram
; screen: Color data for mask 11, will be copied to screen ram 

border:
 	!by 0
back:
	!by 0
screen:
	!bin "three_elves.scr"
colors:
	!bin "three_elves.col"
bitmap:
	!bin "three_elves.map"