/* ============================================================== *

  C64 ASM TUTORIALS by wizofwor

  SPRITE GRAPHICS

  Environment: KickAssembler v.4.12
  Date: February 2015 - October 2018   
 
 * ============================================================== */

                /* compiled program will reside on memory start from $c000 
                can be executed by writing sys 49152 */

                * = $c000 "Main"

                // Initialize
                lda #$ff
                sta $d000 	// set x position of sprite

                lda #$64
                sta $d001 	// set y position of sprite

                lda #$01 	// enable sprite0
                sta $d015 	

                lda #$01        // disable xpand-y
                sta $d017 	

                lda #$01        // set sprite/background priority
                sta $d01b       

                lda #$00        // set hires
                sta $d01c 	

                lda #$01 	// disable xpand-x
                sta $d01d 	

                lda #$07        // set sprite color
                sta $d027 	

                lda #spriteData/64	// set sprite pointer
                sta $07f8

                rts

// -- Data ---------------------------------------------------------

/* Lets use the famous baloon sprite from 
Commodore 64 Programmer's Reference */

//Set spriteBitmap as String
.var spriteBitmap = List(21)
.eval spriteBitmap.set(0,  "         *******        ")
.eval spriteBitmap.set(1,  "       ***********      ")
.eval spriteBitmap.set(2,  "      *************     ")
.eval spriteBitmap.set(3,  "     ******  *******    ")
.eval spriteBitmap.set(4,  "    ****** **  ******   ")
.eval spriteBitmap.set(5,  "    ****** **********   ")
.eval spriteBitmap.set(6,  "    ****** **  ******   ")
.eval spriteBitmap.set(7,  "     ******  *******    ")
.eval spriteBitmap.set(8,  "     ***************    ")
.eval spriteBitmap.set(9,  "      *************     ")
.eval spriteBitmap.set(10, "      * ********* *     ")
.eval spriteBitmap.set(11, "       * ******* *      ")
.eval spriteBitmap.set(12, "       *  *****  *      ")
.eval spriteBitmap.set(13, "        *  ***  *       ") 
.eval spriteBitmap.set(14, "        *  ***  *       ")
.eval spriteBitmap.set(15, "         *  *  *        ")
.eval spriteBitmap.set(16, "         *  *  *        ")
.eval spriteBitmap.set(17, "          *****         ")
.eval spriteBitmap.set(18, "          *****         ")
.eval spriteBitmap.set(19, "          *****         ")
.eval spriteBitmap.set(20, "           ***          ")    

// Divide spriteBitmap into 8 char parts
.var spriteBytesStr = List(21*3)
.for(var i=0;i<=20;i++) {
        .var row = spriteBitmap.get(i)
        .for(var j=0;j<=2;j++) {
                .eval spriteBytesStr.set(i*3+j,row.substring(j*8,j*8+8))
        }
        .print(row)
}

// Convert spriteByteStr into Byte value
.var spriteBytes = List(21*3)
.for(var i=0;i<21*3;i=i+1) {
        .var byteStr = spriteBytesStr.get(i)
        .var byteValue = 0
        .for(var j=0;j<=7;j++) {
                .if (byteStr.charAt(7-j) == "*") {
                        .eval byteValue = byteValue + pow(2,j)
                }
        }
        .eval spriteBytes.set(i, byteValue)
}

// fill memory
* = $2140 "Sprite Data"
spriteData:     .fill spriteBytes.size(), spriteBytes.get(i)