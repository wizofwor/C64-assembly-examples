VIC BANK SELECTION
------------------
Bank selection is a bit tricky:

lda $dd02   ;make sure Port A on CIA#2 is set to output
ora #03     ;
sta $dd02

lda $dd00   ;change banks
and #$fc
ora #$xx    ; xx = bank
sta $dd00

$xx Bank Adress Range 
$00  3*  $C000-$FFFF
$01  2   $8000-$BFFF
$02  1*  $4000-$7FFF
$03  0   $0000-$3FFF (Default value)
*rom character set is not available in these banks


SCREEN_RAM
----------
Upper 4 bits of $d018 controls the location of the screen memory.
Locations on Bank 0

$D018 = %0000xxxx -> screenmem is at $0000
$D018 = %0001xxxx -> screenmem is at $0400 (default)
$D018 = %0010xxxx -> screenmem is at $0800
$D018 = %0011xxxx -> screenmem is at $0c00
$D018 = %0100xxxx -> screenmem is at $1000
$D018 = %0101xxxx -> screenmem is at $1400
$D018 = %0110xxxx -> screenmem is at $1800
$D018 = %0111xxxx -> screenmem is at $1c00
$D018 = %1000xxxx -> screenmem is at $2000
$D018 = %1001xxxx -> screenmem is at $2400
$D018 = %1010xxxx -> screenmem is at $2800
$D018 = %1011xxxx -> screenmem is at $2c00
$D018 = %1100xxxx -> screenmem is at $3000
$D018 = %1101xxxx -> screenmem is at $3400
$D018 = %1110xxxx -> screenmem is at $3800
$D018 = %1111xxxx -> screenmem is at $3c00


COLOR_RAM
---------
Color memory cannot move. It is always between $d800 - $dbe7


CHARACTER_MEMORY
----------------
Character memory location is controlled by bits 3,2 and 1 of $d018
Character set stored in 2K blocks such as:

$00 xxxx000x -> $0000 - $07ff
$02 xxxx001x -> $0800 - $0fff
$04 xxxx010x -> $1000 - $17ff *Rom image in bank 0 and 1 (default)
$06 xxxx011x -> $1800 - $1fff
$08 xxxx100x -> $2000 - $27ff
$0a xxxx101x -> $2800 - $2fff
$0c xxxx110x -> $3000 - $37ff
$0e xxxx111x -> $3800 - $3fff
