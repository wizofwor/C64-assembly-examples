	!to"build/music.prg",cbm

	music		= $c000		;Müzik dosyasinin yuklenecegi adres
	music_play	= music+3	;Müzik player adresi

	* = $0801
	!by $0d,$08,$0a,$00,$9e,$34,$30,$37,$30,$34
    	
	* = $9F00	 
	
	lda #$03	 
	sta $d020

	lda #$00  	;IRQ rutiniyle karışmaması için 
	sta $37 	;Basic bitiş adresini değiştirelim
	lda #$9f
	sta $38


	lda #$00	;müziği başlatalım
	jsr music	

	;Muzik rutinini her framede çağırılması lazım.
	;Bunun için bir raster irq kuruyoruz

	sei

	lda #$7f
	sta $dc0d

	lda $d01a
	ora #$01
	sta $d01a

	lda #$00
	sta $dc0e
	
       	lda #$1b
       	sta $d011

	lda #$10
	sta $d012
		
	lda #<irq
	sta $0314
	lda #>irq
	sta $0315
 
        cli
	
	rts
		
	;Muziği çalan irq rutini
irq	inc $d019
        jsr music_play	;müziði çaldýrýyoruz
	jmp $ea31


	;Veriler
	;------------------------------------------------------------------------
	; Sid player adresini sidreloc ile $c000 olarak değiştirdim.
	; Zero page adreslerinide $fb-$fe arasına aldım.
	;
	; sidreloc -r 10-1c -p c0 -z fb-fe LittleSecret.sid LittleSecret-c000.sid
	;
	; http://www.linusakesson.net/software/sidreloc/
	;-------------------------------------------------------------------------

	* = music
	!bin "LittleSecret-c000.sid",3298,$7c+2
