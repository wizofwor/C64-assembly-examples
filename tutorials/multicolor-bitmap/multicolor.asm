/* ============================================================== *

  C64 ASM TUTORIALS by wizofwor

  SHOW MULTICOLOR IMAGE

  Environment: KickAssembler v.4.12
  Date: November 2014 - September 2018   
 
 * ============================================================== */

// Adress definitions
.const SCREEN_RAM = $0400
.const COLOR_RAM = $d800
.const BITMAP_RAM = $2000

// --- Main Program with Basic Upstarter ---------------------------

BasicUpstart2($4000)

                * = $4000

main:	        lda $D011 	// switch to bitmap
        	ora #$20
        	sta $D011

        	lda $d016 	// switch to multicolor
        	ora #$10
        	sta $d016

        	lda #$18
        	sta $d018

                // Set Background and Border Colors

        	lda back
        	sta $d021
        	lda border
        	sta $d020	

                // Copy Bitmap Data (Bitmap mask)

        	ldx #$00
copyMap1:
        	.for(var n=0;n<=15;n++) {
        		lda bitmap+255*n,x
        		sta BITMAP_RAM+255*n,x
        		}							
        	inx
        	bne copyMap1

	        ldx #$00
copyMap2:
        	.for(var n=16;n<=31;n++) {
        		lda bitmap+255*n,x
        		sta BITMAP_RAM+255*n,x
        		}							
        	inx
        	bne copyMap2


// Copy Screen Ram (Holds color data for mask 01 and 10 in bitmap)

	       ldx #$00
copyScr:
        	.for(var n=0;n<=3;n++) {
        		lda screen+255*n,x
        		sta SCREEN_RAM+255*n,x
        		}							
        	inx
        	bne copyScr

// Copy Color Ram (Holds color data for mask 11 in bitmap)

        	ldx #$00
copyCol:
        	.for(var n=0;n<=3;n++) {
        		lda colors+255*n,x
        		sta COLOR_RAM+255*n,x
        		}							
	        inx
	        bne copyCol

// endless loop

        	jmp *

/* Hires_data

  border,back: fixed colors
  bitmap: Bitmap mask, will be copied to bitmap ram
  colors: Color data for mask 01 and 10, will be copied to color ram
  screen: Color data for mask 11, will be copied to screen ram  */
border: .byte 0
back:   .byte 0
screen: .import binary "three_elves.scr"
colors: .import binary "three_elves.col"
bitmap: .import binary "three_elves.map"