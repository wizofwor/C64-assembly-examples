!to "build/colorwash.prg",cbm
!src "standart.asm"

	;----------------------------------------
	;CONSTANTS
	;----------------------------------------
	
	SCREEN_RAM = $0400
	COLOR_RAM = $d800
	EFFECT_COUNTER = $02

	+BASIC_START

	;-----------------------------------------
	; MAIN
	;-----------------------------------------
	
	* = $c000

	+CLEAR_SCREEN
	
	;Metnimizi ekrana yerleştirelim
	
	ldx #00
-	lda metin,x
	sta SCREEN_RAM+40*5,x
	inx
	cpx #120
	bne - 
	
	;Efect sayacını maksimum değere getirelim
	lda #40
	sta EFFECT_COUNTER
	
	;Ekran tazelenene kadar bekleyelim
	;1/50 saniye	

cwash	lda #00	
-	cmp $d012	
	bne -	
		
	;Renk geçişi efekti iki index yazmacını
	;birlikte kullanıyor. Y okunacak rengi
	;X yazılacak adresi indexliyor
	
	ldy EFFECT_COUNTER
	ldx #00
-	lda renkler,y
	sta COLOR_RAM+40*5,x
	inx
	sta COLOR_RAM+40*6,x
	inx
	sta COLOR_RAM+40*7,x
	iny
	dex
	cpx #40
	bne -
	
	dec EFFECT_COUNTER
	
	lda #00
	cmp EFFECT_COUNTER
	bne cwash
	
	lda #40
	sta EFFECT_COUNTER
	
	jmp cwash

	;-----------------------------------------
	; DATA
	;-----------------------------------------
	
metin 
	!scr "          + ++ hi there! ++ +           "
	!scr "   ---------------------------------    "
	!scr "   this is a smiple colorwash effect    "

renkler
	!by  14,14,14,14,14,14,14,14,14,14
	!by  14,14,14,14,14,14,14,15,01,07
	!by  01,07,15,14,14,14,14,14,14,14
	!by  14,14,14,14,14,14,14,14,14,14

	!by  14,14,14,14,14,14,14,14,14,14
	!by  14,14,14,14,14,14,14,15,01,07
	!by  01,07,15,14,14,14,14,14,14,14
	!by  14,14,14,14,14,14,14,14,14,14
