STATE = $02     ;current animation case (like jump,hit,run etc.)
FRAME = $03     ;current frame within the case
SPRITE_POINTER = SCREEN_MEM+$03f8 


spriteAnimation: 
      ;increase animation frame
      inc FRAME               ;increase animation frame
      ldx STATE               ;and compare with frameCount
      lda frameCount,x        ;for this state
      cmp FRAME               
      bne +
      lda #$00
      sta FRAME 
+      
      ;calculate sprite pointer
      lda frameInit,x       ;calculate sprite pointer to use
      clc                   ;frameInit + FRAME
      adc FRAME             ;
      sta SPRITE_PONITER    ;set animation frame
      
      rts


frameCount:
!by 3,1           ;number of frames for each animation case
frameInit:
!by 0,3           ;beginning frame for each animation case
