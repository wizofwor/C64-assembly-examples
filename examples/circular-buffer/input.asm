/* ========================================================================= *

	C64 ASM EXAMPLES by wizofwor
   
	C64 CIRCULAR INPUT BUFFER
   
	Read Joy2 inputs, puts input tokens in a circular
	buffer and displays buffer contents on screen 
   
	Environment: KickAssembler v.4.12
	Date 2023
   
 * ========================================================================= */
.const temp0 = $03
.const temp1 = $04
.const temp2 = $05
.const temp3 = $06

.const start  = $c000
.const screen_ram = $0400
.const color_ram = $d800

// --- Main Loop with Basic Upstart ----------------------------------------

	BasicUpstart2(start)
	* = start "Main"
		dec $d020
		
		jsr set_screen
		jsr set_irq

loop:	// update buffer labels
		
		:testBuffer(0)
		:testBuffer(1)
		:testBuffer(2)
		:testBuffer(3)
		
.macro testBuffer(n) {
		lda input+n 			// null
		cmp #$00
		bne !next+
		:print(screen_ram+(n+4)*40+9,"----")	
!next:	lda input+n 			// up
		cmp #$01 				
		bne !next+
		:print(screen_ram+(n+4)*40+9,"up  ")
!next:	lda input+n
		cmp #$02 				// down
		bne !next+
		:print(screen_ram+(n+4)*40+9,"down")
!next:	lda input+n 			// left
		cmp #$03 				
		bne !next+
		:print(screen_ram+(n+4)*40+9,"left")
!next:	lda input+n 			// right
		cmp #$04 				
		bne !next+
		:print(screen_ram+(n+4)*40+9,"rght")
!next:	lda input+n 			// hit
		cmp #$05 				
		bne !next+
		:print(screen_ram+(n+4)*40+9,"hit ")
!next:
}
		
		// check buffer to match action patterns
test_dragon:
		lda #5 			// hit
		cmp input
		bne test_projectile
		lda #4			// right
		cmp input+1
		bne test_projectile
		lda #2 			// down
		cmp input+2
		bne test_projectile
		lda #4 			// right
		cmp input+3		
		bne test_projectile
		:print(screen_ram+6*40+21,"dragon  ")
		jmp loop	
test_projectile:
		lda #5 			// hit
		cmp input
		bne test_rndhouse
		lda #4			// right
		cmp input+1
		bne test_rndhouse
		lda #2 			// down
		cmp input+2
		bne test_rndhouse
		:print(screen_ram+6*40+21,"prjctile")
		jmp loop
test_rndhouse:
		lda #5 			// hit
		cmp input
		bne test_sonic
		lda #3			// left
		cmp input+1
		bne test_sonic
		lda #2 			// down
		cmp input+2
		bne test_sonic
		:print(screen_ram+6*40+21,"rndhouse")
		jmp loop
test_sonic:
		lda #5 			// hit
		cmp input
		bne test_hit
		lda #4			// right
		cmp input+1
		bne test_hit
		lda #3 			// left
		cmp input+2
		bne test_hit
		:print(screen_ram+6*40+21,"sonic   ")
		jmp loop	
test_hit:
		lda #$5
		cmp input
		bne test_back
		:print(screen_ram+6*40+21,"hit     ")
		jmp loop
test_back:
		lda #3
		cmp input
		bne test_forward
		:print(screen_ram+6*40+21,"back    ")
		jmp loop
test_forward:
		lda #4
		cmp input
		bne test_jump
		:print(screen_ram+6*40+21,"forward ")
		jmp loop		
test_jump:
		lda #1
		cmp input
		bne test_crouch
		:print(screen_ram+6*40+21,"jump    ")
		jmp loop
test_crouch:
		lda #2
		cmp input
		bne test_stand
		:print(screen_ram+6*40+21,"crouch  ")
		jmp loop			
test_stand:		
		:print(screen_ram+6*40+21,"stand   ")
		jmp loop
end:		
		jmp loop

		
		
// --- Subroutines ----------------------------------------------------------

/* :print
		macro for print function
		addr: screen address
		text: text to be printed 
	*/
.macro print(addr, text) {
		jsr print
		.byte <addr
		.byte >addr
		.text text
		.byte 0
}

/* print:
		takes inline text data after jsr instruction and prints on screen
		first two bytes are the target address
		max 253 characters are supported.
 		*/
print:
{ 		
		pla			// took rts address from stack 
		sta temp0	//
		pla
		sta temp1
		
		// first two bytes are target address
		ldy #1
		lda (temp0),y
		sta temp2
		iny
		lda (temp0),y
		sta temp3
		iny
		
		// decrease target address by 3
		sec
		lda temp2
		sbc #3
		sta temp2
		lda temp3
		sbc #0
		sta temp3
		
		
		// text data starts after 3rd byte
loop:	lda (temp0),y
		beq exit_loop
		sta (temp2),y
		iny
		jmp loop
exit_loop:		
					
		// put return address to stack and return after inline data
		sty temp3
		clc
		lda temp0
		adc temp3
		tay
		lda temp1
		adc #0
		pha
		tya
		pha
		
		rts
}

/* set_irq
		set raster irq
		*/

set_irq: {
		sei
		
		lda #$7f	// Disable CIA1 and CIA2 interrupts
		sta $dc04
		lda $d01a	// Enable raster interrupts
		ora #$01
		sta $d01a
		lda #$00
		sta $dc0e
		
		lda #160	// set raster line
		sta $d012
		lda $d011
		and #$7f	// %01111111
		sta $d011

		lda #<irq	// set interrupt handler
		sta $0314
		lda #>irq
		sta $0315
		
		cli
		
		rts }

/* set_screen
			initialize screes
			*/
			
set_screen: {
		// set colors
		lda #$00
		sta $d020
		lda #$06
		sta $d021
		
		// clear screen
		lda #$20
		ldx #$ff
!loop:  
		sta screen_ram-1,x
		sta screen_ram+$fe,x
		sta screen_ram+$1fd,x
		sta screen_ram+$2fc,x
		dex
		bne !loop-

		//put title
		ldx #$00
		ldy #$08
!loop: 	lda title_text,x
		beq !end+
		sta screen_ram+46,x
		lda #$07
		sta color_ram+46,x
		inx
		jmp !loop-
!end:
		// labels
		:print(screen_ram+4*40," input0:")
		:print(screen_ram+5*40," input1:")
		:print(screen_ram+6*40," input2:")
		:print(screen_ram+7*40," input3:")
		:print(screen_ram+4*40+20, " state ")
				
		rts
	
title_text:
		.text "circular input buffer test"
		.byte 0
}

// --- irq routine --------------------------------------

// joy_up    = %00000001
// joy_down  = %00000010
// joy_left  = %00000100
// joy_right = %00001000
// joy_fire  = %00001000

irq:	inc $d020
		inc screen_ram+999

		// check joystick imputs and update input buffer
		// .. only changing inputs will be recorded
		// .. if the input is same as before it will be ommitted
				
		clc
		lda $dc00
		lsr
		bcc joy_up
		lsr 
		bcc joy_down
		lsr
		bcc joy_left
		lsr
		bcc joy_right
		lsr
		bcc joy_fire
joy_null:
		lda #0
		cmp input
		beq !end+
		jsr shiftBuffer
		sta input
		jmp !end+
joy_up:	
		lda #1
		cmp input 
		beq !end+
		jsr shiftBuffer
		sta input
		jmp !end+
joy_down:
		lda #2
		cmp input
		beq !end+
		jsr shiftBuffer
		sta input
		jmp !end+
joy_left:
		lda #3
		cmp input
		beq !end+
		jsr shiftBuffer
		sta input
		jmp !end+
joy_right:
		lda #4
		cmp input
		beq !end+
		jsr shiftBuffer
		sta input
		jmp !end+
joy_fire:		
		lda #5
		cmp input
		beq !end+
		jsr shiftBuffer
		sta input
		jmp !end+
!end:	
		//jsr label_test
	
		// end irq
		dec $d020

		asl $d019
		
		jmp $ea81
		

input: .byte 0,0,0,0


		// move input buffer by one byte.
		
shiftBuffer:
		ldx input+2
		stx input+3
		ldx input+1
		stx input+2
		ldx input+0
		stx input+1
		rts
	
