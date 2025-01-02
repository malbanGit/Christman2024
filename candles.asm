                    bss      
                    org      endOfNormalRam 

                    struct   FlameParameter 
                    ds       C_POS, 2 
                    ds       Y_UPDATE, 1 
                    ds       Y_OFFSET, 1 
                    ds       X_OFFSET, 1 
                    ds       X_WAITER, 1 
                    ds       Y_WAITER, 1 
                    ds       X_RESET, 1 
                    ds       Y_RESET, 1 
                    ds       SCALE, 1 
                    ds       C_COUNTER, 1 
                    ds       VALUES, 2 
                    ds       SYNCPOS,2 
                    ds       SYNCSCALE,2 
                    end struct 
;
;
XWAIT               =        4 ; how nervous is the candle in X direction
YWAIT               =        5 ; how nervous is the candle in Y direction
BIGGESTX            =        10 
LOWESTX             =        -10 
BIGGESTY            =        10 
LOWESTY             =        -5 
;
                    bss      
candle1             ds       FlameParameter 
candle2             ds       FlameParameter 
counter             ds       1 
;
                    code     
;
;***************************************************************************
; CODE SECTION
;***************************************************************************
; here the cartridge program starts off
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
initCandles 
 ldd #TEN_SECONDS ; ten seconds
 std bigCounter

                    ldy      #candle1 
;--
;initCandle 
                    ldd      #0 
                    sta      C_POS,Y 
                    ldd      #xUpdate1 
                    std      VALUES,y 
                    clr      C_COUNTER,y 
                    lda      #50 
                    sta      SCALE,y 
                    lda      #XWAIT 
                    sta      X_WAITER,y 
                    lda      #YWAIT 
                    sta      Y_WAITER,y 
                    clr      Y_OFFSET,y 
                    clr      X_OFFSET,y 
                    lda      #COUNTER_X 
                    sta      C_COUNTER,y 
                    lda      #20 
                    sta      Y_UPDATE, y 

                    ldd      #$a070
                    std      C_POS,Y 
                    ldd      #$b070 
                    std      SYNCPOS,y 
                    lda      #$40                         ; scale positioning 
                    ldb      #$30                         ; scale move in list 
                    std SYNCSCALE,y

;--



                    ldy      #candle2 
;--
;initCandle 
                    ldd      #0 
                    sta      C_POS,Y 
                    ldd      #xUpdate2 
                    std      VALUES,y 
                    clr      C_COUNTER,y 
                    lda      #100 
                    sta      SCALE,y 
                    lda      #XWAIT 
                    sta      X_WAITER,y 
                    lda      #YWAIT 
                    sta      Y_WAITER,y 
                    clr      Y_OFFSET,y 
                    clr      X_OFFSET,y 
                    lda      #COUNTER_X 
                    sta      C_COUNTER,y 
                    lda      #12 ; how tall is the flame
                    sta      Y_UPDATE, y 

                    ldd      #$24c4
                    std      C_POS,Y 

                    ldd      #$30b0
                    std      SYNCPOS,y 

                    lda      #$40                         ; scale positioning 
                    ldb      #$20                         ; scale move in list 
                    std SYNCSCALE,y
;--

                    rts      

playCandles: 
 ldd bigCounter
 subd #1
  std bigCounter
 bne notFinishedStoryboardCandles
 clr demoRunningFlag 
notFinishedStoryboardCandles


;                              tst    animDelayCounter       ; one global animation counter 
;                              bpl    noAnimChangeML 
;                              lda    #ANIMATION_DELAY 
;                              sta    animDelayCounter 
noAnimChangeML 
;                              dec    animDelayCounter 
;                              JSR    Wait_Recal             ; Vectrex BIOS recalibration 

                    JSR      Intensity_1F                 ; Sets the intensity of the 
                                                          ; vector beam to $5f 

 ldy #SnowmanSceneData
 jsr drawSmartScene
                    JSR      Intensity_3F                 ; Sets the intensity of the 

                    ldy      #candle1 
                    bsr      doOneCandle 

                    JSR      Intensity_3F                 ; Sets the intensity of the 
                    ldy      #candle2 
                    bsr      doOneCandle 
                    rts      


doOneCandle 

                    ldu      #candleList                  ; address of list 
                    ldx      SYNCPOS,y 
 ldd SYNCSCALE,y
                    jsr      draw_synced_list 
                    jsr      Reset0Ref 
                    bsr      flame 
                    rts      
;
;***************************************************************************
;
flame 
                    RANDOM_A_alt
                    ora      #%01110000 
                    ora      #%00110000 
                    anda     #%01111111 
;                    anda     #%00111111 
                    jsr      Intensity_a 
                    lda      SCALE,y 
                    sta      VIA_t1_cnt_lo 
                    ldd      C_POS,y 
                    jsr      Moveto_d 
                    ldu      VALUES,y 
                    jsr      drawCandle 
                    dec      X_WAITER ,y 
                    bne      xdoneAll 
; X "size2
                    RANDOM_A_alt
                    bmi      xneg 
                    inc      X_OFFSET,y 
                    lda      X_OFFSET,y 
                    cmpa     #BIGGESTX 
                    blt      xDone 
                    lda      #BIGGESTX 
                    sta      X_OFFSET,y 
                    bra      xDone 


xneg 
                    dec      X_OFFSET,y 
                    lda      X_OFFSET,y 
                    cmpa     #LOWESTX 
                    bgt      xDone 
                    lda      #LOWESTX 
                    sta      X_OFFSET,y 
xDone 
                    lda      #XWAIT 
                    sta      X_WAITER ,y 
xdoneAll 
; Y "size2
                    dec      Y_WAITER ,y 
                    bne      ydoneAll 
                    RANDOM_A_alt
                    bmi      yneg 
                    inc      Y_OFFSET,y 
                    lda      Y_OFFSET,y 
                    cmpa     #BIGGESTY 
                    blt      yDone 
                    lda      #BIGGESTY 
                    sta      Y_OFFSET,y 
                    bra      yDone 


yneg 
                    dec      Y_OFFSET,y 
                    lda      Y_OFFSET,y 
                    cmpa     #LOWESTY 
                    bgt      yDone 
                    lda      #LOWESTY 
                    sta      Y_OFFSET,y 
yDone 
                    lda      #YWAIT 
                    sta      Y_WAITER ,y 
ydoneAll 
                    rts      


;
;***************************************************************************
;
;***************************************************************************
;
COUNTER_X           =        19 
SS                  =        5 
xUpdate1 
                    db       -1*SS 
                    db       -2*SS 
                    db       -3*SS 
                    db       -4*SS 
                    db       -5*SS 
                    db       -4*SS 
                    db       -3*SS 
                    db       -2*SS 
                    db       -1*SS 
                    db       -0*SS 
                    db       1*SS 
                    db       2*SS 
                    db       3*SS 
                    db       4*SS 
                    db       5*SS 
                    db       6*SS 
                    db       4*SS 
                    db       3*SS 
                    db       1*SS 
                    db       0*SS 

;COUNTER_X           =        19 
SS2                  =        3 ; how "FAT" is the Flame
xUpdate2
                    db       -1*SS2 
                    db       -2*SS2 
                    db       -3*SS2 
                    db       -4*SS2 
                    db       -5*SS2
                    db       -4*SS2 
                    db       -3*SS2 
                    db       -2*SS2 
                    db       -1*SS2 
                    db       -0*SS2 
                    db       1*SS2 
                    db       2*SS2 
                    db       3*SS2 
                    db       4*SS2 
                    db       5*SS2 
                    db       6*SS2 
                    db       4*SS2 
                    db       3*SS2 
                    db       1*SS2 
                    db       0*SS2 

;
;***************************************************************************
;
drawCandle: 
                    lda      C_COUNTER,y 
                    sta      counter 
                    LDD      #$1881                       ; load D with VIA pokes 
                    STB      VIA_port_b                   ; poke $81 to port B 
                                                          ; disable MUX 
                                                          ; disable ~RAMP 
                    STA      VIA_aux_cntl                 ; poke $18 to AUX 
                                                          ; shift mode 4 
                                                          ; PB7 not timer controlled 
                                                          ; PB7 is ~RAMP 
                    LDA      Y_UPDATE,y                   ; ,U+ ; load next Y_update 
                    adda     Y_OFFSET,y 
                    STA      VIA_port_a                   ; poke to DAC 
                    DECB                                  ; B now $80 
                    STB      VIA_port_b                   ; enable MUX, that means put 
                                                          ; DAC to Y integrator S/H 
                    lda      #$ff 
                    INC      VIA_port_b                   ; MUX off, only X on DAC now 
                    LDB      ,U+ 
                    STB      VIA_port_a                   ; store B (X_update) to DAC 
                    LDB      #$01                         ; load poke for MUX disable, 
                                                          ; ~RAMP enable 
x_update_loop_init: 
                    STB      VIA_port_b                   ; MUX disable, ~RAMP enable 
                    STA      VIA_shift_reg                ; poke the enable byte (A) found to 
                                                          ; shift, that enables/disables ~BLANK 
x_update_loop: 
                    dec      counter 
                    BEQ      finnish_x_update             ; if zero, we are done with this 
                    LDA      ,U+                          ; load next X_update value 
                    adda     X_OFFSET,y 
                                                          ; X_update 
                    STA      VIA_port_a                   ; otherwise put the found value to 
                                                          ; DAC and thus to X integration 
                    BRA      x_update_loop                ; go on, look if another X_update 


                                                          ; value is there... 
finnish_x_update: 
                    LDB      #$81                         ; load value for ramp off, MUX off 
                    STB      VIA_port_b                   ; poke $81, ramp off, MUX off 
secondHalf 
                    lda      C_COUNTER,y 
                    sta      counter 
                    LDA      Y_UPDATE,y                   ; ,U+ ; load next Y_update 
                    adda     Y_OFFSET,y 
                    nega     
                    STA      VIA_port_a                   ; poke to DAC 
                    DECB                                  ; B now $80 
                    STB      VIA_port_b                   ; enable MUX, that means put 
                                                          ; DAC to Y integrator S/H 
                    lda      #$ff 
                    INC      VIA_port_b                   ; MUX off, only X on DAC now 
                    LDB      ,U+ 
                    STB      VIA_port_a                   ; store B (X_update) to DAC 
                    LDB      #$01                         ; load poke for MUX disable, 
                                                          ; ~RAMP enable 
                    STB      VIA_port_b                   ; MUX disable, ~RAMP enable 
                    STA      VIA_shift_reg                ; poke the enable byte (A) found to 
                                                          ; shift, that enables/disables ~BLANK 
x_update_loop2: 
                    dec      counter 
                    BEQ      finnish_x_update2            ; if zero, we are done with this 
                    LDA      ,-U                          ; load next X_update value 
                    suba     X_OFFSET,y 
                                                          ; X_update 
                    STA      VIA_port_a                   ; otherwise put the found value to 
                                                          ; DAC and thus to X integration 
                    BRA      x_update_loop2               ; go on, look if another X_update 


                                                          ; value is there... 
finnish_x_update2: 
                    LDB      #$81                         ; load value for ramp off, MUX off 
                    STB      VIA_port_b                   ; poke $81, ramp off, MUX off 
                    NOP                                   ; these NOP's seem to be neccessary 
                    NOP                                   ; since the delay between VIA and 
                    NOP                                   ; integration hardware 
                                                          ; NOP ; otherwise, there is a space 
                                                          ; between Y_updates... Malban 
                    clra     
                    STA      VIA_shift_reg                ; A == %00000000 
                    LDA      #$98                         ; load AUX setting 
                    STA      VIA_aux_cntl                 ; restore usual AUX setting 
                                                          ; (enable PB7 timer, SHIFT mode 4) 
                    RTS                                   ; and out of here 


;***************************************************************************
; DATA SECTION
;***************************************************************************
candleList: 
                    DB       $01, -$21, +$10              ; sync and move to y, x 
                    DB       $FF, +$02, +$26              ; draw, y, x 
                    DB       $FF, +$05, +$21              ; draw, y, x 
                    DB       $FF, +$0A, +$19              ; draw, y, x 
                    DB       $FF, +$0B, +$0E              ; draw, y, x 
                    DB       $FF, +$0A, +$00              ; draw, y, x 
                    DB       $FF, +$0B, -$0E              ; draw, y, x 
                    DB       $FF, +$09, -$1F              ; draw, y, x 
                    DB       $FF, +$06, -$1F              ; draw, y, x 
                    DB       $FF, +$02, -$20              ; draw, y, x 
                    DB       $FF, +$00, -$24              ; draw, y, x 
                    DB       $FF, -$02, -$20              ; draw, y, x 
                    DB       $FF, -$06, -$1F              ; draw, y, x 
                    DB       $FF, -$09, -$1F              ; draw, y, x 
                    DB       $FF, -$0B, -$0E              ; draw, y, x 
                    DB       $FF, -$0A, +$00              ; draw, y, x 
                    DB       $FF, -$0B, +$0E              ; draw, y, x 
                    DB       $FF, -$09, +$1F              ; draw, y, x 
                    DB       $FF, -$06, +$1F              ; draw, y, x 
                    DB       $01, -$1F, -$32              ; sync and move to y, x 
                    DB       $FF, -$02, +$20              ; draw, y, x 
                    DB       $FF, +$00, +$22              ; draw, y, x 
                    DB       $00, +$0E, -$06              ; mode, y, x 
                    DB       $FF, +$07, -$09              ; draw, y, x 
                    DB       $FF, +$07, -$05              ; draw, y, x 
                    DB       $FF, +$09, -$06              ; draw, y, x 
                    DB       $FF, +$0D, -$01              ; draw, y, x 
                    DB       $FF, +$0F, +$05              ; draw, y, x 
                    DB       $FF, +$08, +$02              ; draw, y, x 
                    DB       $FF, +$07, +$07              ; draw, y, x 
                    DB       $FF, +$06, +$03              ; draw, y, x 
                    DB       $FF, +$03, -$01              ; draw, y, x 
                    DB       $FF, -$09, -$0B              ; draw, y, x 
                    DB       $FF, -$0E, -$07              ; draw, y, x 
                    DB       $FF, -$0F, -$05              ; draw, y, x 
                    DB       $FF, -$0E, +$01              ; draw, y, x 
                    DB       $FF, -$10, +$09              ; draw, y, x 
                    DB       $FF, -$07, +$05              ; draw, y, x 
                    DB       $FF, -$02, -$01              ; draw, y, x 
                    DB       $01, -$7F, -$7F              ; sync and move to y, x 
                    DB       $00, -$7F, +$00              ; additional sync move to y, x 
                    DB       $00, -$2A, +$00              ; additional sync move to y, x 
                    DB       $FF, +$49, +$01              ; draw, y, x 
                    DB       $FF, +$48, +$00              ; draw, y, x 
                    DB       $FF, +$49, +$00              ; draw, y, x 
                    DB       $FF, +$48, +$00              ; draw, y, x 
                    DB       $00, -$13, +$30              ; mode, y, x 
                    DB       $FF, +$06, -$03              ; draw, y, x 
                    DB       $FF, +$07, +$09              ; draw, y, x 
                    DB       $FF, +$06, +$15              ; draw, y, x 
                    DB       $FF, +$04, +$15              ; draw, y, x 
                    DB       $FF, +$02, +$15              ; draw, y, x 
                    DB       $FF, +$00, +$17              ; draw, y, x 
                    DB       $FF, -$02, +$16              ; draw, y, x 
                    DB       $FF, -$04, +$14              ; draw, y, x 
                    DB       $FF, -$06, +$15              ; draw, y, x 
                    DB       $FF, -$07, +$09              ; draw, y, x 
                    DB       $FF, -$07, -$01              ; draw, y, x 
                    DB       $00, +$14, +$29              ; mode, y, x 
                    DB       $FF, -$4A, +$00              ; draw, y, x 
                    DB       $FF, -$4A, +$00              ; draw, y, x 
                    DB       $FF, -$4A, +$00              ; draw, y, x 
                    DB       $FF, -$4B, +$00              ; draw, y, x 
                    DB       $02                          ; endmarker 


;
;***************************************************************************
;
