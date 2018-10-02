# MULTICOLOR BITMAP MODE

![](three_elves.png)

Multicolor data kept in three different places in memory.

**1) Bitmap mask**

This is the actual image data where each bit pair represent a 2x1 rectangular pixel. For instance:

Byte 1110010000. four pixels e.g:

11 > multicolor 3  
10 > multicolor 2  
01 > multicolor 1  
00 > background color   
00 > background color

**2) Color ram**

Lower nibble of the color data defines multicolor 01 for the relevant 8x8 squire (character area) this is the color to be applied for color mask 01.

Higher nibble defines the multicolor 02 in smilar manner.

**3) Screen ram**

Works like color ram for color mask 11 but only the lower nibbles are used.

**Other parameters:**   
Border `$d020` and background `$d021` colors are to be defined too.


***

*Note the `.for` directive used to repeat `lda` `sta` instructions. This is not the most effective way of copying data around. I strongly advice a self modifying memory copy routine. This solution is much simpler and works a little faster but produce  much longer code.*

     .for(var n=0;n<=15;n++) {
        		lda bitmap+255*n,x
        		sta BITMAP_RAM+255*n,x
        		}
 *I will tell about self modifying copy in another tutorial*

 