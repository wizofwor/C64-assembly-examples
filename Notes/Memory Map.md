Default memory map of Commodore 64 priorites BASIC usage. However it is highly configarable for specific purposes. It is possible to cancel unnecassary ROM fields and reach underlying RAM.  

|  ADRESS 	| C64 Memory Map      |VIC Banks |
|-----------|---------------------|----------|
|$F000-$FFFF|	KERNAL ROM	        | Bank 3   |
|$E000-$EFFF|	KERNAL ROM         |  " |
|$D000-$DFFF|	CHAR ROM / IO	      | "   | 
|$C000-$CFFF|	Free	              | "    |
|$B000-$BFFF|	BASIC ROM           | Bank 2   |
|$A000-$AFFF|	BASIC ROM           | "     |
|$9000-$9FFF|                     | "     |
|$8000-$8FFF|	 	                 |  "     | 
|$7000-$7FFF|	Free                | "     |
|$6000-$6FFF|	Basic	              | Bank 1   |
|$5000-$5FFF|	Storage	            |  "        |
|$4000-$4FFF|	Area	              |  "        |
|$3000-$3FFF|	 	                 |  "        |
|$2000-$2FFF|	 	                 | Bank 0   |
|$1000-$1FFF|	 	                 |    "   |
|$0800-$1FFF|	                   |    "     |
|$0400-$07FF|	Screen Memory       |	 "      |
|$0200-$03FF|	OS & BASIC Pointers |	 "       |
|$0100-$01FF|	Enhanced Zero Page	|   "      |
|$0000-$00FF|	Zero Page	          |  "      |
* Between $1000-$17ff there is character generator rom. But is only visible to VIC
* Between $9000-$9FFF there is charackter generator rom shadow, which is also visible for VIC only. 
