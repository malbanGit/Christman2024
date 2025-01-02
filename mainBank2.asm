CURRENT_BANK        EQU      2                            ; 
                    Bank     2 
                    include  "commonGround.i"
; following is needed for VIDE
; to replace "vars" in this bank with values from the other bank
; #genVarlist# varFromBank2
;
;***************************************************************************
; CODE SECTION
;***************************************************************************

; on Entry: 
;     Y is always a pointer to the RAM of the demo (1,2,3)
;     X is always a pointer to the ROM list entry of demo lists
SceneInit 
                    lda      #STATE_FADE_IN 
                    sta      STATE,y 
                    lda      #50                          ; 1 second 
                    sta      COUNTER,y 
                    clr      BRIGHTNESS,y 
                    rts      

;...
ScenePlay 
                    lda      STATE,y  
                    cmpa     #STATE_FADE_IN 
                    bne      notFadeIn_MS 

; STATE FADE IN
                    lda      #2 
                    adda     BRIGHTNESS,y  
                    sta      BRIGHTNESS,y
                    dec      COUNTER,y  
                    bne      doPlay_MS_Cont 
                    lda      #STATE_PLAY 
                    sta      STATE,y 
                    lda      #100 
                    sta      COUNTER,y  
                    bra      doPlay_MS_Cont 

notFadeIn_MS 
                    cmpa     #STATE_FADE_OUT 
                    bne      notFadeOut_MS 

; STATE FADE OUT
                    lda      #-2 
                    adda     BRIGHTNESS,y  
                    sta      BRIGHTNESS,y  
                    dec      COUNTER,y  
                    bne      doPlay_MS_Cont 
                    lda      #STATE_DONE 
                    sta      STATE,y 
                    bra      out_MS 

notFadeOut_MS 
                    cmpa     #STATE_PLAY 
                    beq      doPlay_MS 
out_MS  ; error? 
                    clr      demoFlag                     ; flag this demo is finshed 
                    rts      
; STATE PLAY

doPlay_MS 
                    dec      COUNTER,y  
                    bne      doPlay_MS_Cont
                    lda      #STATE_FADE_OUT 
                    sta      STATE,y 
                    lda      #25 
                    sta      COUNTER,y  

doPlay_MS_Cont 
                    lda      BRIGHTNESS,y  
                    jsr      Intensity_a 
                    LDy      DATA,y           ; address of data 
                    bra      drawSmartScene 

;***************************************************************************
; input scene list in y
drawSmartScene 
                    lda      #SPRITE_SCALE 
                    sta      VIA_t1_cnt_lo 
                    LDA      #$CE                         ;Blank low, zero high? 
                    STA      <VIA_cntl 
                    LDU      ,y++ 
                    beq      ret 
                    bsr      drawSmart 
                    BRA      drawSmartScene 
ret 
                    rts      

;***************************************************************************
;***************************************************************************
;***************************************************************************

                    include  "smartList.asm"
                    include  "ListData_2.asm"
                    include  "synclists.asm"

 include "candles.asm"

