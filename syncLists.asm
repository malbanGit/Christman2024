                    bss      
 org endOfNormalRam
                    struct   FlakeData 
                    ds       F_SCALE,1                    ; subroutine to play demo (one cycle) 
                    ds       F_INTENSITY,2                ; bank demo is in 
                    ds       F_LISTPOINTER,2              ; bank demo is in 
                    ds       F_ANIMATION_COUNTER,1        ; bank demo is in 
                    ds       F_ANIMATION_DELAY,1          ; bank demo is in 
                    ds       F_ANIMATION_SPEED,1          ; bank demo is in 
                    ds       F_POS,0                      ; init routine to play demo 
                    ds       F_POSY,1 
                    ds       F_POSX,1 
                    ds       F_SPEEDY,1 
                    ds       F_SPEEDX,1 
                    end struct 

FlakeData1          ds       FlakeData 
FlakeData2          ds       FlakeData 
FlakeData3          ds       FlakeData 
FlakeData4          ds       FlakeData 

                    code     
initFlakes 
 ldd #TEN_SECONDS ; ten seconds
 std bigCounter


                    ldx      #FlakeData1 
                    clr      0*FlakeData,x                ; scale == 0 -> flake1 is not initialized 
                    clr      1*FlakeData,x                ; scale == 0 -> flake2 is not initialized 
                    clr      2*FlakeData,x                ; scale == 0 -> flake3 is not initialized 
                    clr      3*FlakeData,x                ; scale == 0 -> flake3 is not initialized 
                    rts      


playFlakes 
 ldd bigCounter
 subd #1
  std bigCounter
 bne notFinishedStoryboardFlakes
 clr demoRunningFlag 
notFinishedStoryboardFlakes



                    ldx      #FlakeData1 
                    bsr      doFlake 
                    ldx      #FlakeData2 
                    bsr      doFlake 
                    ldx      #FlakeData3 
                    bsr      doFlake 
                    ldx      #FlakeData4 
                    bsr      doFlake 
                    rts      
newRandom
 RANDOM_A_alt
 rts

doFlake 
                    lda      F_SCALE,x 
                    bne      nextFlakeStep 
; Init flake
FlakeIntensityLoop 
                    bsr newRandom  

                    anda     #%0111111 
                    cmpa     #$10 
                    blo      FlakeIntensityLoop 

                    sta      F_INTENSITY,x 
                    bsr newRandom  
                    anda     #$f                         
                    sta      F_SCALE,x 
                    beq      FlakeIntensityLoop ; not null
                    deca
                    beq      FlakeIntensityLoop ; not one
                    lda      #$7f 
                    sta      F_POSY,x 
                    bsr newRandom  
                    anda     #%1011111 ; not too far from the center starting
                    sta      F_POSX,x 
FlakeYToBig
                    bsr newRandom  
                    anda     #$7 
                    adda     #1 
                    cmpa     #4
                    bhi FlakeYToBig
                    nega                                  ; fall speed is always negative 
                    sta      F_SPEEDY,x 

                    bsr newRandom  
                    tsta     
                    bmi      negSpeedX                    ; wind speed is either negative or positive 
                    anda     #$7 
                    sta      F_SPEEDX,x 
                    bra      cont_doFlakeSpeedX 


negSpeedX 
                    anda     #$7 
                    nega     
                    sta      F_SPEEDX,x 
                    bra      cont_doFlakeSpeedX 


cont_doFlakeSpeedX 

                    bsr newRandom  
                    anda     #$7 
                    inca     
                    sta      F_ANIMATION_SPEED,x 
                    sta      F_ANIMATION_DELAY,x 
                    clr      F_ANIMATION_COUNTER,x 

                    bsr newRandom  
                    anda     #1 
                    beq      oneFlakeList 
                    ldd      #SnowFlake2d 
                    std      F_LISTPOINTER,x 
                    bra      nextFlakeStep 


oneFlakeList 
                    ldd      #SnowFlake1d 
                    std      F_LISTPOINTER,x 

nextFlakeStep 
                    ldd      F_POS,x 
                    addb     F_SPEEDX,x 
                    stb      F_POSX,x 

                    adda     F_SPEEDY,x 
                    bvc      contFlakeStepYOk 
flakeisOOB 
; snowFlage left the screen
                    clr      F_SCALE,x                    ; set to uninitalized 
                    rts                                   ; and do nothing 


contFlakeStepYOk 
                    sta      F_POSY,x 

                    lda      F_INTENSITY,x 
                    jsr      Intensity_a 

                    dec      F_ANIMATION_DELAY,x 
                    bne      noAnimChangeFlake 
                    inc      F_ANIMATION_COUNTER,x 

                    lda      F_ANIMATION_SPEED,x 
                    sta      F_ANIMATION_DELAY,x 

                    lda      F_ANIMATION_COUNTER,x 
                    cmpa     #37 
                    bne      noAnimChangeFlake 
                    clr      F_ANIMATION_COUNTER,x 
noAnimChangeFlake 
                    clra     
                    LDB      F_ANIMATION_COUNTER,x 
                    ASLB                                  ; times two since it is a word pointer 
                    ROLA     

                    ldu      F_LISTPOINTER,x              ; pointer to synclist animation 
                    ldu      d,u                          ; pointing to correct animation 
                    ldb      F_SCALE,x                    ; size of flake 
                    lda      #$7f                         ; scale positioning 

                    ldx      F_POS,x 

                    BSR      draw_synced_list             ; Vectrex BIOS print routine 
                    rts      


MY_MOVE_TO_D_START  macro    
                    STA      <VIA_port_a                  ;Store Y in D/A register 
                    LDA      #$CE                         ;Blank low, zero high? 
                    STA      <VIA_cntl                    ; 
                    CLRA     
                    STA      <VIA_port_b                  ;Enable mux ; hey dis si "break integratorzero 440" 
                    STA      <VIA_shift_reg               ;Clear shift regigster 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ;enable timer 
                    endm     
MY_MOVE_TO_A_END    macro    
                    local    LF33D 
                    LDA      #$40                         ; 
LF33D:              BITA     <VIA_int_flags               ; 
                    BEQ      LF33D                        ; 
                    endm     
MY_MOVE_TO_B_END    macro    
                    local    LF33D 
                    LDB      #$40                         ; 
LF33D:              BITB     <VIA_int_flags               ; 
                    BEQ      LF33D                        ; 
                    endm     
MY_MOVE_TO_D        macro    
; optimzed, tweaked not perfect... 'MOVE TO D' makro
                    MY_MOVE_TO_D_START  
                    MY_MOVE_TO_B_END  
                    endm     

;SUB_START

;***************************************************************************
; SUBROUTINE SECTION
;***************************************************************************

;ZERO ing the integrators takes time. Measures at my vectrex show e.g.:
;If you move the beam with a to x = -127 and y = -127 at diffferent scale values, the time to reach zero:
;- scale $ff -> zero 110 cycles
;- scale $7f -> zero 75 cycles
;- scale $40 -> zero 57 cycles
;- scale $20 -> zero 53 cycles
ZERO_DELAY_AS       EQU      7                            ; delay 7 counter is exactly 111 cycles delay between zero SETTING and zero unsetting (in moveto_d) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;U = address of vectorlist
;X = (y,x) position of vectorlist (this will be point 0,0), positioning on screen
;A = scalefactor "Move" (after sync)
;B = scalefactor "Vector" (vectors in vectorlist)
;
;     mode, rel y, rel x,                                             
;     mode, rel y, rel x,                                             
;     .      .      .                                                
;     .      .      .                                                
;     mode, rel y, rel x,                                             
;     0x02
; where mode has the following meaning:         
; negative draw line                    
; 0 move to specified endpoint                              
; 1 sync (and move to list start and than to place in vectorlist)      
; 2 end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
draw_synced_list: 
                    pshs     a                            ; remember out different scale factors 
                    pshs     b 
                                                          ; first list entry (first will be a sync + moveto_d, so we just stay here!) 
                    lda      ,u+                          ; this will be a "1" 
sync_as: 
                    deca                                  ; test if real sync - or end of list (2) 
                    bne      drawdone_as                  ; if end of list -> jump 
; zero integrators
                    ldb      #$CC                         ; zero the integrators 
                    stb      <VIA_cntl                    ; store zeroing values to cntl 
                    ldb      #ZERO_DELAY_AS               ; and wait for zeroing to be actually done 
; reset integrators
                    clr      <VIA_port_a                  ; reset integrator offset 
                    lda      #%10000010 
; wait that zeroing surely has the desired effect!
zeroLoop_as: 
                    sta      <VIA_port_b                  ; while waiting, zero offsets 
                    decb     
                    bne      zeroLoop_as 
                    inc      <VIA_port_b 
; unzero is done by moveto_d
                    lda      1,s                          ; scalefactor move 
                    sta      <VIA_t1_cnt_lo               ; to timer t1 (lo= 
                    tfr      x,d                          ; load our coordinates of "entry" of vectorlist 
                    MY_MOVE_TO_D                          ;jsr Moveto_d ; move there 
                    lda      ,s                           ; scale factor vector 
                    sta      <VIA_t1_cnt_lo               ; to timer T1 (lo) 
moveTo_as: 
                    ldd      ,u++                         ; do our "internal" moveto d 
                    beq      nextListEntry_as             ; there was a move 0,0, if so 
                    MY_MOVE_TO_D                          ;jsr Moveto_d 
nextListEntry_as: 
                    lda      ,u+                          ; load next "mode" byte 
                    beq      moveTo_as                    ; if 0, than we should move somewhere 
                    bpl      sync_as                      ; if still positive it is a 1 pr 2 _> goto sync 
; now we should draw a vector 
                    ldd      ,u++                         ;Get next coordinate pair 
                    STA      <VIA_port_a                  ;Send Y to A/D 
                    CLR      <VIA_port_b                  ;Enable mux 
                    LDA      #$ff                         ;Get pattern byte 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Send X to A/D 
                    LDB      #$40                         ;B-reg = T1 interrupt bit 
                    CLR      <VIA_t1_cnt_hi               ;Clear T1H 
                    STA      <VIA_shift_reg               ;Store pattern in shift register 
setPatternLoop_as: 
                    BITB     <VIA_int_flags               ;Wait for T1 to time out 
                    beq      setPatternLoop_as            ; wait till line is finished 
 nop ; if between the two entries lie less then x cycles - the shift will stall, the nop ensures enough time
                    CLR      <VIA_shift_reg               ; switch the light off (for sure) 
                    bra      nextListEntry_as 


drawdone_as: 
                    puls     d                            ; correct stack and go back 
                    rts      


;***************************************************************************
;SUB_END
; DATA SECTION
;******************

SnowFlake2d 
vDataLength         =        37 
SnowFlake2d: 
                    DW       SnowFlake2d_0                ; list of all single vectorlists in this 
                    DW       SnowFlake2d_1 
                    DW       SnowFlake2d_2 
                    DW       SnowFlake2d_3 
                    DW       SnowFlake2d_4 
                    DW       SnowFlake2d_5 
                    DW       SnowFlake2d_6 
                    DW       SnowFlake2d_7 
                    DW       SnowFlake2d_8 
                    DW       SnowFlake2d_9 
                    DW       SnowFlake2d_10 
                    DW       SnowFlake2d_11 
                    DW       SnowFlake2d_12 
                    DW       SnowFlake2d_13 
                    DW       SnowFlake2d_14 
                    DW       SnowFlake2d_15 
                    DW       SnowFlake2d_16 
                    DW       SnowFlake2d_17 
                    DW       SnowFlake2d_18 
                    DW       SnowFlake2d_19 
                    DW       SnowFlake2d_20 
                    DW       SnowFlake2d_21 
                    DW       SnowFlake2d_22 
                    DW       SnowFlake2d_23 
                    DW       SnowFlake2d_24 
                    DW       SnowFlake2d_25 
                    DW       SnowFlake2d_26 
                    DW       SnowFlake2d_27 
                    DW       SnowFlake2d_28 
                    DW       SnowFlake2d_29 
                    DW       SnowFlake2d_30 
                    DW       SnowFlake2d_31 
                    DW       SnowFlake2d_32 
                    DW       SnowFlake2d_33 
                    DW       SnowFlake2d_34 
                    DW       SnowFlake2d_35 
                    DW       SnowFlake2d_36 
                    DW       0 

SnowFlake2d_0: 
                    DB       $01, +$7F, -$06              ; sync and move to y, x 
                    DB       $00, +$7F, +$00              ; additional sync move to y, x 
                    DB       $00, +$74, +$00              ; additional sync move to y, x 
                    DB       $FF, -$41, -$06              ; draw, y, x 
                    DB       $FF, -$41, -$06              ; draw, y, x 
                    DB       $FF, +$44, -$6E              ; draw, y, x 
                    DB       $FF, -$5F, +$6A              ; draw, y, x 
                    DB       $FF, -$63, +$02              ; draw, y, x 
                    DB       $FF, -$62, +$02              ; draw, y, x 
                    DB       $FF, +$2F, -$4E              ; draw, y, x 
                    DB       $FF, +$2F, -$4E              ; draw, y, x 
                    DB       $FF, +$4D, -$1E              ; draw, y, x 
                    DB       $FF, +$4D, -$1E              ; draw, y, x 
                    DB       $FF, -$44, +$11              ; draw, y, x 
                    DB       $FF, -$44, +$11              ; draw, y, x 
                    DB       $FF, +$36, -$72              ; draw, y, x 
                    DB       $FF, -$42, +$62              ; draw, y, x 
                    DB       $FF, -$3E, -$7E              ; draw, y, x 
                    DB       $FF, +$16, +$4D              ; draw, y, x 
                    DB       $FF, +$16, +$4D              ; draw, y, x 
                    DB       $FF, -$30, +$52              ; draw, y, x 
                    DB       $FF, -$30, +$52              ; draw, y, x 
                    DB       $01, +$02, -$18              ; sync and move to y, x 
                    DB       $FF, -$2E, -$4F              ; draw, y, x 
                    DB       $FF, -$2E, -$4F              ; draw, y, x 
                    DB       $FF, +$0C, -$4B              ; draw, y, x 
                    DB       $FF, +$0C, -$4B              ; draw, y, x 
                    DB       $FF, -$2A, +$7A              ; draw, y, x 
                    DB       $FF, -$38, -$68              ; draw, y, x 
                    DB       $FF, +$1E, +$62              ; draw, y, x 
                    DB       $FF, -$78, -$0C              ; draw, y, x 
                    DB       $FF, +$49, +$1B              ; draw, y, x 
                    DB       $FF, +$49, +$1B              ; draw, y, x 
                    DB       $FF, +$30, +$4F              ; draw, y, x 
                    DB       $FF, +$30, +$4F              ; draw, y, x 
                    DB       $FF, -$51, -$02              ; draw, y, x 
                    DB       $FF, -$51, -$02              ; draw, y, x 
                    DB       $FF, -$74, -$64              ; draw, y, x 
                    DB       $FF, +$4C, +$60              ; draw, y, x 
                    DB       $FF, -$4A, +$06              ; draw, y, x 
                    DB       $FF, -$4A, +$06              ; draw, y, x 
                    DB       $01, -$7F, -$0C              ; sync and move to y, x 
                    DB       $00, -$7F, +$00              ; additional sync move to y, x 
                    DB       $00, -$6C, +$00              ; additional sync move to y, x 
                    DB       $FF, +$49, +$04              ; draw, y, x 
                    DB       $FF, +$49, +$04              ; draw, y, x 
                    DB       $FF, -$54, +$62              ; draw, y, x 
                    DB       $FF, +$7E, -$5E              ; draw, y, x 
                    DB       $FF, +$51, +$01              ; draw, y, x 
                    DB       $FF, +$51, +$01              ; draw, y, x 
                    DB       $FF, -$31, +$54              ; draw, y, x 
                    DB       $FF, -$31, +$54              ; draw, y, x 
                    DB       $FF, -$7E, +$24              ; draw, y, x 
                    DB       $FF, +$74, -$12              ; draw, y, x 
                    DB       $FF, -$22, +$44              ; draw, y, x 
                    DB       $FF, -$22, +$44              ; draw, y, x 
                    DB       $FF, +$5A, -$72              ; draw, y, x 
                    DB       $FF, +$12, +$42              ; draw, y, x 
                    DB       $FF, +$12, +$42              ; draw, y, x 
                    DB       $FF, -$0E, -$51              ; draw, y, x 
                    DB       $FF, -$0E, -$51              ; draw, y, x 
                    DB       $FF, +$2D, -$57              ; draw, y, x 
                    DB       $FF, +$2D, -$57              ; draw, y, x 
                    DB       $01, +$00, +$06              ; sync and move to y, x 
                    DB       $FF, +$31, +$54              ; draw, y, x 
                    DB       $FF, +$31, +$54              ; draw, y, x 
                    DB       $FF, -$16, +$54              ; draw, y, x 
                    DB       $FF, -$16, +$54              ; draw, y, x 
                    DB       $FF, +$1F, -$44              ; draw, y, x 
                    DB       $FF, +$1F, -$44              ; draw, y, x 
                    DB       $FF, +$42, +$68              ; draw, y, x 
                    DB       $FF, -$36, -$70              ; draw, y, x 
                    DB       $FF, +$7C, +$12              ; draw, y, x 
                    DB       $FF, -$44, -$17              ; draw, y, x 
                    DB       $FF, -$44, -$17              ; draw, y, x 
                    DB       $FF, -$32, -$54              ; draw, y, x 
                    DB       $FF, -$32, -$54              ; draw, y, x 
                    DB       $FF, +$62, +$02              ; draw, y, x 
                    DB       $FF, +$62, +$02              ; draw, y, x 
                    DB       $FF, +$60, +$68              ; draw, y, x 
                    DB       $FF, -$42, -$6C              ; draw, y, x 
                    DB       $FF, +$40, -$04              ; draw, y, x 
                    DB       $FF, +$40, -$04              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_1: 
                    DB       $01, +$7F, -$44              ; sync and move to y, x 
                    DB       $00, +$7F, +$00              ; additional sync move to y, x 
                    DB       $00, +$68, +$00              ; additional sync move to y, x 
                    DB       $FF, -$40, +$05              ; draw, y, x 
                    DB       $FF, -$40, +$05              ; draw, y, x 
                    DB       $FF, +$30, -$77              ; draw, y, x 
                    DB       $FF, -$4B, +$78              ; draw, y, x 
                    DB       $FF, -$5F, +$13              ; draw, y, x 
                    DB       $FF, -$5F, +$12              ; draw, y, x 
                    DB       $FF, +$20, -$55              ; draw, y, x 
                    DB       $FF, +$20, -$55              ; draw, y, x 
                    DB       $FF, +$46, -$2A              ; draw, y, x 
                    DB       $FF, +$46, -$2B              ; draw, y, x 
                    DB       $FF, -$7E, +$39              ; draw, y, x 
                    DB       $FF, +$21, -$7A              ; draw, y, x 
                    DB       $FF, -$30, +$6C              ; draw, y, x 
                    DB       $FF, -$51, -$72              ; draw, y, x 
                    DB       $FF, +$22, +$48              ; draw, y, x 
                    DB       $FF, +$22, +$48              ; draw, y, x 
                    DB       $FF, -$21, +$59              ; draw, y, x 
                    DB       $FF, -$20, +$59              ; draw, y, x 
                    DB       $01, -$02, -$18              ; sync and move to y, x 
                    DB       $FF, -$3A, -$46              ; draw, y, x 
                    DB       $FF, -$3A, -$46              ; draw, y, x 
                    DB       $FF, -$01, -$4C              ; draw, y, x 
                    DB       $FF, -$01, -$4C              ; draw, y, x 
                    DB       $FF, -$14, +$7F              ; draw, y, x 
                    DB       $FF, -$48, -$5D              ; draw, y, x 
                    DB       $FF, +$2D, +$5B              ; draw, y, x 
                    DB       $FF, -$76, +$09              ; draw, y, x 
                    DB       $FF, +$4C, +$0E              ; draw, y, x 
                    DB       $FF, +$4B, +$0E              ; draw, y, x 
                    DB       $FF, +$3C, +$46              ; draw, y, x 
                    DB       $FF, +$3C, +$46              ; draw, y, x 
                    DB       $FF, -$4F, +$0C              ; draw, y, x 
                    DB       $FF, -$4F, +$0B              ; draw, y, x 
                    DB       $FF, -$41, -$27              ; draw, y, x 
                    DB       $FF, -$41, -$28              ; draw, y, x 
                    DB       $FF, +$5A, +$52              ; draw, y, x 
                    DB       $FF, -$47, +$12              ; draw, y, x 
                    DB       $FF, -$47, +$12              ; draw, y, x 
                    DB       $01, -$7F, +$30              ; sync and move to y, x 
                    DB       $00, -$7F, +$00              ; additional sync move to y, x 
                    DB       $00, -$64, +$00              ; additional sync move to y, x 
                    DB       $FF, +$48, -$08              ; draw, y, x 
                    DB       $FF, +$47, -$08              ; draw, y, x 
                    DB       $FF, -$41, +$6F              ; draw, y, x 
                    DB       $FF, +$6B, -$72              ; draw, y, x 
                    DB       $FF, +$4F, -$0D              ; draw, y, x 
                    DB       $FF, +$4F, -$0C              ; draw, y, x 
                    DB       $FF, -$21, +$5B              ; draw, y, x 
                    DB       $FF, -$22, +$5B              ; draw, y, x 
                    DB       $FF, -$74, +$38              ; draw, y, x 
                    DB       $FF, +$6D, -$25              ; draw, y, x 
                    DB       $FF, -$15, +$49              ; draw, y, x 
                    DB       $FF, -$16, +$49              ; draw, y, x 
                    DB       $FF, +$22, -$40              ; draw, y, x 
                    DB       $FF, +$22, -$40              ; draw, y, x 
                    DB       $FF, +$3A, +$7C              ; draw, y, x 
                    DB       $FF, -$1B, -$4E              ; draw, y, x 
                    DB       $FF, -$1C, -$4D              ; draw, y, x 
                    DB       $FF, +$1D, -$5D              ; draw, y, x 
                    DB       $FF, +$1D, -$5D              ; draw, y, x 
                    DB       $01, +$01, +$06              ; sync and move to y, x 
                    DB       $FF, +$3E, +$4A              ; draw, y, x 
                    DB       $FF, +$3E, +$4B              ; draw, y, x 
                    DB       $FF, -$08, +$56              ; draw, y, x 
                    DB       $FF, -$07, +$57              ; draw, y, x 
                    DB       $FF, +$13, -$48              ; draw, y, x 
                    DB       $FF, +$13, -$48              ; draw, y, x 
                    DB       $FF, +$51, +$5B              ; draw, y, x 
                    DB       $FF, -$47, -$65              ; draw, y, x 
                    DB       $FF, +$7B, -$03              ; draw, y, x 
                    DB       $FF, -$46, -$0C              ; draw, y, x 
                    DB       $FF, -$46, -$0B              ; draw, y, x 
                    DB       $FF, -$3F, -$4B              ; draw, y, x 
                    DB       $FF, -$3E, -$4A              ; draw, y, x 
                    DB       $FF, +$5F, -$0E              ; draw, y, x 
                    DB       $FF, +$60, -$0E              ; draw, y, x 
                    DB       $FF, +$6F, +$56              ; draw, y, x 
                    DB       $FF, -$53, -$5F              ; draw, y, x 
                    DB       $FF, +$7B, -$1E              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_2: 
                    DB       $01, +$7F, -$7A              ; sync and move to y, x 
                    DB       $00, +$7F, +$00              ; additional sync move to y, x 
                    DB       $00, +$49, +$00              ; additional sync move to y, x 
                    DB       $FF, -$78, +$1E              ; draw, y, x 
                    DB       $FF, +$18, -$7D              ; draw, y, x 
                    DB       $FF, -$19, +$41              ; draw, y, x 
                    DB       $FF, -$18, +$40              ; draw, y, x 
                    DB       $FF, -$57, +$21              ; draw, y, x 
                    DB       $FF, -$57, +$21              ; draw, y, x 
                    DB       $FF, +$10, -$58              ; draw, y, x 
                    DB       $FF, +$10, -$59              ; draw, y, x 
                    DB       $FF, +$75, -$69              ; draw, y, x 
                    DB       $FF, -$6E, +$4B              ; draw, y, x 
                    DB       $FF, +$0A, -$7C              ; draw, y, x 
                    DB       $FF, -$1A, +$71              ; draw, y, x 
                    DB       $FF, -$61, -$63              ; draw, y, x 
                    DB       $FF, +$2D, +$42              ; draw, y, x 
                    DB       $FF, +$2D, +$41              ; draw, y, x 
                    DB       $FF, -$0F, +$5D              ; draw, y, x 
                    DB       $FF, -$0F, +$5C              ; draw, y, x 
                    DB       $01, -$06, -$17              ; sync and move to y, x 
                    DB       $FF, -$43, -$3C              ; draw, y, x 
                    DB       $FF, -$44, -$3C              ; draw, y, x 
                    DB       $FF, -$0E, -$4A              ; draw, y, x 
                    DB       $FF, -$0E, -$4B              ; draw, y, x 
                    DB       $FF, +$02, +$40              ; draw, y, x 
                    DB       $FF, +$01, +$40              ; draw, y, x 
                    DB       $FF, -$54, -$51              ; draw, y, x 
                    DB       $FF, +$3B, +$53              ; draw, y, x 
                    DB       $FF, -$6F, +$1B              ; draw, y, x 
                    DB       $FF, +$4A, +$03              ; draw, y, x 
                    DB       $FF, +$4A, +$02              ; draw, y, x 
                    DB       $FF, +$45, +$3C              ; draw, y, x 
                    DB       $FF, +$45, +$3B              ; draw, y, x 
                    DB       $FF, -$48, +$17              ; draw, y, x 
                    DB       $FF, -$49, +$18              ; draw, y, x 
                    DB       $FF, -$44, -$1D              ; draw, y, x 
                    DB       $FF, -$45, -$1D              ; draw, y, x 
                    DB       $FF, +$64, +$43              ; draw, y, x 
                    DB       $FF, -$40, +$1C              ; draw, y, x 
                    DB       $FF, -$40, +$1D              ; draw, y, x 
                    DB       $01, -$7F, +$66              ; sync and move to y, x 
                    DB       $00, -$7F, +$00              ; additional sync move to y, x 
                    DB       $00, -$48, +$00              ; additional sync move to y, x 
                    DB       $FF, +$43, -$13              ; draw, y, x 
                    DB       $FF, +$42, -$13              ; draw, y, x 
                    DB       $FF, -$2A, +$77              ; draw, y, x 
                    DB       $FF, +$28, -$40              ; draw, y, x 
                    DB       $FF, +$28, -$40              ; draw, y, x 
                    DB       $FF, +$49, -$19              ; draw, y, x 
                    DB       $FF, +$48, -$18              ; draw, y, x 
                    DB       $FF, -$0F, +$5E              ; draw, y, x 
                    DB       $FF, -$10, +$5F              ; draw, y, x 
                    DB       $FF, -$64, +$49              ; draw, y, x 
                    DB       $FF, +$61, -$35              ; draw, y, x 
                    DB       $FF, -$07, +$4B              ; draw, y, x 
                    DB       $FF, -$08, +$4B              ; draw, y, x 
                    DB       $FF, +$15, -$44              ; draw, y, x 
                    DB       $FF, +$15, -$44              ; draw, y, x 
                    DB       $FF, +$4C, +$71              ; draw, y, x 
                    DB       $FF, -$28, -$48              ; draw, y, x 
                    DB       $FF, -$27, -$48              ; draw, y, x 
                    DB       $FF, +$0B, -$60              ; draw, y, x 
                    DB       $FF, +$0B, -$60              ; draw, y, x 
                    DB       $01, +$02, +$06              ; sync and move to y, x 
                    DB       $FF, +$47, +$3F              ; draw, y, x 
                    DB       $FF, +$48, +$40              ; draw, y, x 
                    DB       $FF, +$08, +$56              ; draw, y, x 
                    DB       $FF, +$09, +$57              ; draw, y, x 
                    DB       $FF, +$05, -$4A              ; draw, y, x 
                    DB       $FF, +$05, -$4A              ; draw, y, x 
                    DB       $FF, +$5D, +$4D              ; draw, y, x 
                    DB       $FF, -$55, -$59              ; draw, y, x 
                    DB       $FF, +$74, -$15              ; draw, y, x 
                    DB       $FF, -$44, -$01              ; draw, y, x 
                    DB       $FF, -$44, +$00              ; draw, y, x 
                    DB       $FF, -$49, -$40              ; draw, y, x 
                    DB       $FF, -$48, -$3F              ; draw, y, x 
                    DB       $FF, +$57, -$1D              ; draw, y, x 
                    DB       $FF, +$58, -$1D              ; draw, y, x 
                    DB       $FF, +$78, +$44              ; draw, y, x 
                    DB       $FF, -$5E, -$51              ; draw, y, x 
                    DB       $FF, +$6F, -$30              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_3: 
                    DB       $01, +$7F, -$7F              ; sync and move to y, x 
                    DB       $00, +$7F, -$24              ; additional sync move to y, x 
                    DB       $00, +$19, +$00              ; additional sync move to y, x 
                    DB       $FF, -$69, +$2D              ; draw, y, x 
                    DB       $FF, -$02, -$7D              ; draw, y, x 
                    DB       $FF, -$0A, +$43              ; draw, y, x 
                    DB       $FF, -$0A, +$42              ; draw, y, x 
                    DB       $FF, -$4B, +$2C              ; draw, y, x 
                    DB       $FF, -$4A, +$2B              ; draw, y, x 
                    DB       $FF, -$02, -$58              ; draw, y, x 
                    DB       $FF, -$02, -$58              ; draw, y, x 
                    DB       $FF, +$58, -$76              ; draw, y, x 
                    DB       $FF, -$57, +$58              ; draw, y, x 
                    DB       $FF, -$0E, -$7B              ; draw, y, x 
                    DB       $FF, -$03, +$72              ; draw, y, x 
                    DB       $FF, -$6D, -$54              ; draw, y, x 
                    DB       $FF, +$6D, +$74              ; draw, y, x 
                    DB       $FF, +$04, +$5C              ; draw, y, x 
                    DB       $FF, +$03, +$5C              ; draw, y, x 
                    DB       $01, -$0A, -$16              ; sync and move to y, x 
                    DB       $FF, -$49, -$31              ; draw, y, x 
                    DB       $FF, -$4A, -$32              ; draw, y, x 
                    DB       $FF, -$1B, -$46              ; draw, y, x 
                    DB       $FF, -$1C, -$47              ; draw, y, x 
                    DB       $FF, +$1B, +$7D              ; draw, y, x 
                    DB       $FF, -$5D, -$43              ; draw, y, x 
                    DB       $FF, +$47, +$48              ; draw, y, x 
                    DB       $FF, -$62, +$29              ; draw, y, x 
                    DB       $FF, +$45, -$07              ; draw, y, x 
                    DB       $FF, +$45, -$08              ; draw, y, x 
                    DB       $FF, +$4B, +$31              ; draw, y, x 
                    DB       $FF, +$4B, +$30              ; draw, y, x 
                    DB       $FF, -$7D, +$42              ; draw, y, x 
                    DB       $FF, -$45, -$13              ; draw, y, x 
                    DB       $FF, -$45, -$13              ; draw, y, x 
                    DB       $FF, +$69, +$33              ; draw, y, x 
                    DB       $FF, -$6B, +$4A              ; draw, y, x 
                    DB       $01, -$7F, +$7F              ; sync and move to y, x 
                    DB       $00, -$7F, +$11              ; additional sync move to y, x 
                    DB       $00, -$1C, +$00              ; additional sync move to y, x 
                    DB       $FF, +$73, -$38              ; draw, y, x 
                    DB       $FF, -$10, +$7A              ; draw, y, x 
                    DB       $FF, +$19, -$44              ; draw, y, x 
                    DB       $FF, +$19, -$44              ; draw, y, x 
                    DB       $FF, +$7D, -$43              ; draw, y, x 
                    DB       $FF, +$04, +$5E              ; draw, y, x 
                    DB       $FF, +$03, +$5E              ; draw, y, x 
                    DB       $FF, -$4E, +$55              ; draw, y, x 
                    DB       $FF, +$4F, -$41              ; draw, y, x 
                    DB       $FF, +$07, +$4A              ; draw, y, x 
                    DB       $FF, +$08, +$4A              ; draw, y, x 
                    DB       $FF, +$06, -$45              ; draw, y, x 
                    DB       $FF, +$07, -$45              ; draw, y, x 
                    DB       $FF, +$5C, +$64              ; draw, y, x 
                    DB       $FF, -$33, -$41              ; draw, y, x 
                    DB       $FF, -$32, -$41              ; draw, y, x 
                    DB       $FF, -$08, -$5F              ; draw, y, x 
                    DB       $FF, -$08, -$5F              ; draw, y, x 
                    DB       $01, +$03, +$05              ; sync and move to y, x 
                    DB       $FF, +$4E, +$34              ; draw, y, x 
                    DB       $FF, +$4F, +$35              ; draw, y, x 
                    DB       $FF, +$18, +$53              ; draw, y, x 
                    DB       $FF, +$18, +$53              ; draw, y, x 
                    DB       $FF, -$0A, -$49              ; draw, y, x 
                    DB       $FF, -$09, -$49              ; draw, y, x 
                    DB       $FF, +$65, +$3F              ; draw, y, x 
                    DB       $FF, -$60, -$4B              ; draw, y, x 
                    DB       $FF, +$67, -$25              ; draw, y, x 
                    DB       $FF, -$7E, +$12              ; draw, y, x 
                    DB       $FF, -$4F, -$34              ; draw, y, x 
                    DB       $FF, -$4F, -$34              ; draw, y, x 
                    DB       $FF, +$4C, -$28              ; draw, y, x 
                    DB       $FF, +$4C, -$28              ; draw, y, x 
                    DB       $FF, +$7B, +$32              ; draw, y, x 
                    DB       $FF, -$67, -$42              ; draw, y, x 
                    DB       $FF, +$5E, -$3E              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_4: 
                    DB       $01, +$7F, -$7F              ; sync and move to y, x 
                    DB       $00, +$5D, -$3B              ; additional sync move to y, x 
                    DB       $FF, -$56, +$37              ; draw, y, x 
                    DB       $FF, -$1C, -$77              ; draw, y, x 
                    DB       $FF, +$04, +$41              ; draw, y, x 
                    DB       $FF, +$05, +$40              ; draw, y, x 
                    DB       $FF, -$75, +$63              ; draw, y, x 
                    DB       $FF, -$14, -$53              ; draw, y, x 
                    DB       $FF, -$15, -$54              ; draw, y, x 
                    DB       $FF, +$38, -$7A              ; draw, y, x 
                    DB       $FF, -$3D, +$5D              ; draw, y, x 
                    DB       $FF, -$27, -$73              ; draw, y, x 
                    DB       $FF, +$16, +$6C              ; draw, y, x 
                    DB       $FF, -$75, -$43              ; draw, y, x 
                    DB       $FF, +$7B, +$62              ; draw, y, x 
                    DB       $FF, +$17, +$57              ; draw, y, x 
                    DB       $FF, +$16, +$57              ; draw, y, x 
                    DB       $01, -$0E, -$14              ; sync and move to y, x 
                    DB       $FF, -$4D, -$27              ; draw, y, x 
                    DB       $FF, -$4E, -$27              ; draw, y, x 
                    DB       $FF, -$28, -$40              ; draw, y, x 
                    DB       $FF, -$28, -$40              ; draw, y, x 
                    DB       $FF, +$34, +$73              ; draw, y, x 
                    DB       $FF, -$64, -$35              ; draw, y, x 
                    DB       $FF, +$50, +$3D              ; draw, y, x 
                    DB       $FF, -$50, +$32              ; draw, y, x 
                    DB       $FF, +$7A, -$1E              ; draw, y, x 
                    DB       $FF, +$4F, +$26              ; draw, y, x 
                    DB       $FF, +$4F, +$26              ; draw, y, x 
                    DB       $FF, -$65, +$4C              ; draw, y, x 
                    DB       $FF, -$42, -$0B              ; draw, y, x 
                    DB       $FF, -$43, -$0A              ; draw, y, x 
                    DB       $FF, +$6A, +$26              ; draw, y, x 
                    DB       $FF, -$52, +$52              ; draw, y, x 
                    DB       $01, -$7F, +$7F              ; sync and move to y, x 
                    DB       $00, -$64, +$29              ; additional sync move to y, x 
                    DB       $FF, +$5E, -$42              ; draw, y, x 
                    DB       $FF, +$0A, +$76              ; draw, y, x 
                    DB       $FF, +$09, -$44              ; draw, y, x 
                    DB       $FF, +$09, -$43              ; draw, y, x 
                    DB       $FF, +$63, -$4E              ; draw, y, x 
                    DB       $FF, +$17, +$59              ; draw, y, x 
                    DB       $FF, +$17, +$5A              ; draw, y, x 
                    DB       $FF, -$35, +$5A              ; draw, y, x 
                    DB       $FF, +$3A, -$47              ; draw, y, x 
                    DB       $FF, +$16, +$45              ; draw, y, x 
                    DB       $FF, +$17, +$46              ; draw, y, x 
                    DB       $FF, -$09, -$43              ; draw, y, x 
                    DB       $FF, -$08, -$42              ; draw, y, x 
                    DB       $FF, +$68, +$55              ; draw, y, x 
                    DB       $FF, -$76, -$70              ; draw, y, x 
                    DB       $FF, -$1C, -$5A              ; draw, y, x 
                    DB       $FF, -$1B, -$59              ; draw, y, x 
                    DB       $01, +$04, +$05              ; sync and move to y, x 
                    DB       $FF, +$52, +$29              ; draw, y, x 
                    DB       $FF, +$53, +$29              ; draw, y, x 
                    DB       $FF, +$27, +$4C              ; draw, y, x 
                    DB       $FF, +$28, +$4D              ; draw, y, x 
                    DB       $FF, -$18, -$44              ; draw, y, x 
                    DB       $FF, -$18, -$44              ; draw, y, x 
                    DB       $FF, +$69, +$30              ; draw, y, x 
                    DB       $FF, -$67, -$3D              ; draw, y, x 
                    DB       $FF, +$56, -$2E              ; draw, y, x 
                    DB       $FF, -$6F, +$1F              ; draw, y, x 
                    DB       $FF, -$53, -$29              ; draw, y, x 
                    DB       $FF, -$53, -$29              ; draw, y, x 
                    DB       $FF, +$79, -$5D              ; draw, y, x 
                    DB       $FF, +$7C, +$22              ; draw, y, x 
                    DB       $FF, -$6C, -$34              ; draw, y, x 
                    DB       $FF, +$48, -$45              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_5: 
                    DB       $01, +$7F, -$7F              ; sync and move to y, x 
                    DB       $00, +$1E, -$3C              ; additional sync move to y, x 
                    DB       $FF, -$42, +$38              ; draw, y, x 
                    DB       $FF, -$35, -$6A              ; draw, y, x 
                    DB       $FF, +$26, +$75              ; draw, y, x 
                    DB       $FF, -$2A, +$32              ; draw, y, x 
                    DB       $FF, -$29, +$32              ; draw, y, x 
                    DB       $FF, -$26, -$4B              ; draw, y, x 
                    DB       $FF, -$26, -$4B              ; draw, y, x 
                    DB       $FF, +$17, -$74              ; draw, y, x 
                    DB       $FF, -$22, +$5A              ; draw, y, x 
                    DB       $FF, -$3E, -$66              ; draw, y, x 
                    DB       $FF, +$2C, +$62              ; draw, y, x 
                    DB       $FF, -$79, -$35              ; draw, y, x 
                    DB       $FF, +$44, +$28              ; draw, y, x 
                    DB       $FF, +$43, +$28              ; draw, y, x 
                    DB       $FF, +$29, +$4E              ; draw, y, x 
                    DB       $FF, +$28, +$4E              ; draw, y, x 
                    DB       $01, -$11, -$11              ; sync and move to y, x 
                    DB       $FF, -$4F, -$1D              ; draw, y, x 
                    DB       $FF, -$50, -$1E              ; draw, y, x 
                    DB       $FF, -$66, -$6F              ; draw, y, x 
                    DB       $FF, +$49, +$66              ; draw, y, x 
                    DB       $FF, -$66, -$29              ; draw, y, x 
                    DB       $FF, +$56, +$32              ; draw, y, x 
                    DB       $FF, -$3D, +$33              ; draw, y, x 
                    DB       $FF, +$68, -$24              ; draw, y, x 
                    DB       $FF, +$51, +$1C              ; draw, y, x 
                    DB       $FF, +$50, +$1C              ; draw, y, x 
                    DB       $FF, -$4A, +$4E              ; draw, y, x 
                    DB       $FF, -$7E, -$08              ; draw, y, x 
                    DB       $FF, +$6A, +$19              ; draw, y, x 
                    DB       $FF, -$38, +$52              ; draw, y, x 
                    DB       $01, -$7F, +$7F              ; sync and move to y, x 
                    DB       $00, -$28, +$2D              ; additional sync move to y, x 
                    DB       $FF, +$46, -$44              ; draw, y, x 
                    DB       $FF, +$25, +$6B              ; draw, y, x 
                    DB       $FF, -$10, -$7D              ; draw, y, x 
                    DB       $FF, +$48, -$4F              ; draw, y, x 
                    DB       $FF, +$2A, +$50              ; draw, y, x 
                    DB       $FF, +$2A, +$50              ; draw, y, x 
                    DB       $FF, -$1C, +$56              ; draw, y, x 
                    DB       $FF, +$25, -$45              ; draw, y, x 
                    DB       $FF, +$48, +$7B              ; draw, y, x 
                    DB       $FF, -$2E, -$78              ; draw, y, x 
                    DB       $FF, +$73, +$46              ; draw, y, x 
                    DB       $FF, -$43, -$2F              ; draw, y, x 
                    DB       $FF, -$43, -$2E              ; draw, y, x 
                    DB       $FF, -$2E, -$50              ; draw, y, x 
                    DB       $FF, -$2D, -$50              ; draw, y, x 
                    DB       $01, +$05, +$04              ; sync and move to y, x 
                    DB       $FF, +$54, +$1F              ; draw, y, x 
                    DB       $FF, +$54, +$1F              ; draw, y, x 
                    DB       $FF, +$35, +$42              ; draw, y, x 
                    DB       $FF, +$36, +$43              ; draw, y, x 
                    DB       $FF, -$4B, -$78              ; draw, y, x 
                    DB       $FF, +$6B, +$24              ; draw, y, x 
                    DB       $FF, -$6B, -$30              ; draw, y, x 
                    DB       $FF, +$43, -$31              ; draw, y, x 
                    DB       $FF, -$5E, +$25              ; draw, y, x 
                    DB       $FF, -$55, -$1F              ; draw, y, x 
                    DB       $FF, -$55, -$1F              ; draw, y, x 
                    DB       $FF, +$2C, -$2F              ; draw, y, x 
                    DB       $FF, +$2D, -$2F              ; draw, y, x 
                    DB       $FF, +$78, +$15              ; draw, y, x 
                    DB       $FF, -$6E, -$27              ; draw, y, x 
                    DB       $FF, +$32, -$44              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_6: 
                    DB       $01, +$61, -$7F              ; sync and move to y, x 
                    DB       $00, +$00, -$29              ; additional sync move to y, x 
                    DB       $FF, -$2E, +$33              ; draw, y, x 
                    DB       $FF, -$4B, -$58              ; draw, y, x 
                    DB       $FF, +$40, +$62              ; draw, y, x 
                    DB       $FF, -$1A, +$2D              ; draw, y, x 
                    DB       $FF, -$19, +$2D              ; draw, y, x 
                    DB       $FF, -$6B, -$7B              ; draw, y, x 
                    DB       $FF, -$04, -$32              ; draw, y, x 
                    DB       $FF, -$05, -$33              ; draw, y, x 
                    DB       $FF, -$08, +$4F              ; draw, y, x 
                    DB       $FF, -$52, -$54              ; draw, y, x 
                    DB       $FF, +$41, +$51              ; draw, y, x 
                    DB       $FF, -$7C, -$26              ; draw, y, x 
                    DB       $FF, +$48, +$1F              ; draw, y, x 
                    DB       $FF, +$47, +$1E              ; draw, y, x 
                    DB       $FF, +$39, +$41              ; draw, y, x 
                    DB       $FF, +$38, +$40              ; draw, y, x 
                    DB       $01, -$14, -$0D              ; sync and move to y, x 
                    DB       $FF, -$50, -$15              ; draw, y, x 
                    DB       $FF, -$50, -$15              ; draw, y, x 
                    DB       $FF, -$79, -$5A              ; draw, y, x 
                    DB       $FF, +$5C, +$53              ; draw, y, x 
                    DB       $FF, -$67, -$1D              ; draw, y, x 
                    DB       $FF, +$5B, +$26              ; draw, y, x 
                    DB       $FF, -$2B, +$2F              ; draw, y, x 
                    DB       $FF, +$56, -$25              ; draw, y, x 
                    DB       $FF, +$51, +$14              ; draw, y, x 
                    DB       $FF, +$50, +$14              ; draw, y, x 
                    DB       $FF, -$18, +$23              ; draw, y, x 
                    DB       $FF, -$18, +$23              ; draw, y, x 
                    DB       $FF, -$75, +$00              ; draw, y, x 
                    DB       $FF, +$67, +$10              ; draw, y, x 
                    DB       $FF, -$1F, +$48              ; draw, y, x 
                    DB       $01, -$6E, +$7F              ; sync and move to y, x 
                    DB       $00, +$00, +$1C              ; additional sync move to y, x 
                    DB       $FF, +$2F, -$3D              ; draw, y, x 
                    DB       $FF, +$3D, +$59              ; draw, y, x 
                    DB       $FF, -$2E, -$69              ; draw, y, x 
                    DB       $FF, +$17, -$24              ; draw, y, x 
                    DB       $FF, +$17, -$24              ; draw, y, x 
                    DB       $FF, +$3A, +$42              ; draw, y, x 
                    DB       $FF, +$3B, +$42              ; draw, y, x 
                    DB       $FF, -$04, +$4B              ; draw, y, x 
                    DB       $FF, +$10, -$3D              ; draw, y, x 
                    DB       $FF, +$61, +$66              ; draw, y, x 
                    DB       $FF, -$48, -$64              ; draw, y, x 
                    DB       $FF, +$7A, +$35              ; draw, y, x 
                    DB       $FF, -$49, -$24              ; draw, y, x 
                    DB       $FF, -$48, -$24              ; draw, y, x 
                    DB       $FF, -$3E, -$42              ; draw, y, x 
                    DB       $FF, -$3E, -$42              ; draw, y, x 
                    DB       $01, +$05, +$03              ; sync and move to y, x 
                    DB       $FF, +$55, +$16              ; draw, y, x 
                    DB       $FF, +$55, +$16              ; draw, y, x 
                    DB       $FF, +$41, +$36              ; draw, y, x 
                    DB       $FF, +$42, +$36              ; draw, y, x 
                    DB       $FF, -$63, -$63              ; draw, y, x 
                    DB       $FF, +$6B, +$19              ; draw, y, x 
                    DB       $FF, -$6E, -$22              ; draw, y, x 
                    DB       $FF, +$31, -$2E              ; draw, y, x 
                    DB       $FF, -$4C, +$24              ; draw, y, x 
                    DB       $FF, -$56, -$16              ; draw, y, x 
                    DB       $FF, -$55, -$15              ; draw, y, x 
                    DB       $FF, +$1C, -$2B              ; draw, y, x 
                    DB       $FF, +$1D, -$2B              ; draw, y, x 
                    DB       $FF, +$73, +$0C              ; draw, y, x 
                    DB       $FF, -$6E, -$1B              ; draw, y, x 
                    DB       $FF, +$1D, -$3D              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_7: 
                    DB       $01, +$2E, -$7F              ; sync and move to y, x 
                    DB       $00, +$00, -$03              ; additional sync move to y, x 
                    DB       $FF, -$1D, +$28              ; draw, y, x 
                    DB       $FF, -$5D, -$40              ; draw, y, x 
                    DB       $FF, +$55, +$48              ; draw, y, x 
                    DB       $FF, -$0B, +$23              ; draw, y, x 
                    DB       $FF, -$0C, +$23              ; draw, y, x 
                    DB       $FF, -$42, -$2D              ; draw, y, x 
                    DB       $FF, -$42, -$2E              ; draw, y, x 
                    DB       $FF, -$11, -$26              ; draw, y, x 
                    DB       $FF, -$11, -$26              ; draw, y, x 
                    DB       $FF, +$0C, +$3C              ; draw, y, x 
                    DB       $FF, -$62, -$3D              ; draw, y, x 
                    DB       $FF, +$52, +$3B              ; draw, y, x 
                    DB       $FF, -$7E, -$19              ; draw, y, x 
                    DB       $FF, +$4B, +$15              ; draw, y, x 
                    DB       $FF, +$4A, +$15              ; draw, y, x 
                    DB       $FF, +$46, +$2F              ; draw, y, x 
                    DB       $FF, +$45, +$2F              ; draw, y, x 
                    DB       $01, -$16, -$0A              ; sync and move to y, x 
                    DB       $FF, -$4F, -$0D              ; draw, y, x 
                    DB       $FF, -$50, -$0E              ; draw, y, x 
                    DB       $FF, -$44, -$20              ; draw, y, x 
                    DB       $FF, -$44, -$20              ; draw, y, x 
                    DB       $FF, +$6B, +$3C              ; draw, y, x 
                    DB       $FF, -$68, -$13              ; draw, y, x 
                    DB       $FF, +$5F, +$1A              ; draw, y, x 
                    DB       $FF, -$1C, +$25              ; draw, y, x 
                    DB       $FF, +$24, -$0F              ; draw, y, x 
                    DB       $FF, +$23, -$10              ; draw, y, x 
                    DB       $FF, +$50, +$0D              ; draw, y, x 
                    DB       $FF, +$4F, +$0D              ; draw, y, x 
                    DB       $FF, -$0D, +$1B              ; draw, y, x 
                    DB       $FF, -$0D, +$1C              ; draw, y, x 
                    DB       $FF, -$6D, +$03              ; draw, y, x 
                    DB       $FF, +$64, +$09              ; draw, y, x 
                    DB       $FF, -$04, +$1C              ; draw, y, x 
                    DB       $FF, -$05, +$1C              ; draw, y, x 
                    DB       $01, -$3D, +$79              ; sync and move to y, x 
                    DB       $FF, +$0E, -$18              ; draw, y, x 
                    DB       $FF, +$0D, -$18              ; draw, y, x 
                    DB       $FF, +$50, +$42              ; draw, y, x 
                    DB       $FF, -$46, -$4F              ; draw, y, x 
                    DB       $FF, +$0C, -$1C              ; draw, y, x 
                    DB       $FF, +$0C, -$1B              ; draw, y, x 
                    DB       $FF, +$47, +$30              ; draw, y, x 
                    DB       $FF, +$47, +$30              ; draw, y, x 
                    DB       $FF, +$10, +$39              ; draw, y, x 
                    DB       $FF, +$00, -$2E              ; draw, y, x 
                    DB       $FF, +$74, +$4A              ; draw, y, x 
                    DB       $FF, -$5D, -$4A              ; draw, y, x 
                    DB       $FF, +$40, +$12              ; draw, y, x 
                    DB       $FF, +$40, +$13              ; draw, y, x 
                    DB       $FF, -$4D, -$1A              ; draw, y, x 
                    DB       $FF, -$4D, -$19              ; draw, y, x 
                    DB       $FF, -$4B, -$30              ; draw, y, x 
                    DB       $FF, -$4A, -$30              ; draw, y, x 
                    DB       $01, +$06, +$02              ; sync and move to y, x 
                    DB       $FF, +$54, +$0E              ; draw, y, x 
                    DB       $FF, +$55, +$0F              ; draw, y, x 
                    DB       $FF, +$4B, +$27              ; draw, y, x 
                    DB       $FF, +$4B, +$27              ; draw, y, x 
                    DB       $FF, -$76, -$48              ; draw, y, x 
                    DB       $FF, +$6A, +$10              ; draw, y, x 
                    DB       $FF, -$6F, -$17              ; draw, y, x 
                    DB       $FF, +$21, -$25              ; draw, y, x 
                    DB       $FF, -$3D, +$1E              ; draw, y, x 
                    DB       $FF, -$55, -$0E              ; draw, y, x 
                    DB       $FF, -$55, -$0E              ; draw, y, x 
                    DB       $FF, +$0F, -$21              ; draw, y, x 
                    DB       $FF, +$10, -$21              ; draw, y, x 
                    DB       $FF, +$6E, +$05              ; draw, y, x 
                    DB       $FF, -$6E, -$11              ; draw, y, x 
                    DB       $FF, +$0B, -$2F              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_8: 
                    DB       $01, +$0B, -$4D              ; sync and move to y, x 
                    DB       $FF, -$12, +$18              ; draw, y, x 
                    DB       $FF, -$68, -$25              ; draw, y, x 
                    DB       $FF, +$63, +$29              ; draw, y, x 
                    DB       $FF, -$02, +$15              ; draw, y, x 
                    DB       $FF, -$03, +$15              ; draw, y, x 
                    DB       $FF, -$4A, -$1A              ; draw, y, x 
                    DB       $FF, -$4A, -$1A              ; draw, y, x 
                    DB       $FF, -$1A, -$16              ; draw, y, x 
                    DB       $FF, -$1A, -$17              ; draw, y, x 
                    DB       $FF, +$0E, +$12              ; draw, y, x 
                    DB       $FF, +$0D, +$12              ; draw, y, x 
                    DB       $FF, -$6D, -$24              ; draw, y, x 
                    DB       $FF, +$5D, +$23              ; draw, y, x 
                    DB       $FF, -$7E, -$0E              ; draw, y, x 
                    DB       $FF, +$4D, +$0C              ; draw, y, x 
                    DB       $FF, +$4C, +$0B              ; draw, y, x 
                    DB       $FF, +$4E, +$1C              ; draw, y, x 
                    DB       $FF, +$4E, +$1B              ; draw, y, x 
                    DB       $01, -$17, -$05              ; sync and move to y, x 
                    DB       $FF, -$4F, -$07              ; draw, y, x 
                    DB       $FF, -$50, -$08              ; draw, y, x 
                    DB       $FF, -$48, -$12              ; draw, y, x 
                    DB       $FF, -$49, -$12              ; draw, y, x 
                    DB       $FF, +$75, +$22              ; draw, y, x 
                    DB       $FF, -$68, -$0A              ; draw, y, x 
                    DB       $FF, +$61, +$0E              ; draw, y, x 
                    DB       $FF, -$11, +$16              ; draw, y, x 
                    DB       $FF, +$1E, -$09              ; draw, y, x 
                    DB       $FF, +$1D, -$09              ; draw, y, x 
                    DB       $FF, +$50, +$07              ; draw, y, x 
                    DB       $FF, +$4F, +$06              ; draw, y, x 
                    DB       $FF, -$05, +$10              ; draw, y, x 
                    DB       $FF, -$06, +$11              ; draw, y, x 
                    DB       $FF, -$67, +$02              ; draw, y, x 
                    DB       $FF, +$61, +$05              ; draw, y, x 
                    DB       $FF, +$03, +$10              ; draw, y, x 
                    DB       $FF, +$02, +$11              ; draw, y, x 
                    DB       $01, -$1C, +$48              ; sync and move to y, x 
                    DB       $FF, +$08, -$0E              ; draw, y, x 
                    DB       $FF, +$07, -$0E              ; draw, y, x 
                    DB       $FF, +$5C, +$26              ; draw, y, x 
                    DB       $FF, -$57, -$2E              ; draw, y, x 
                    DB       $FF, +$05, -$11              ; draw, y, x 
                    DB       $FF, +$04, -$10              ; draw, y, x 
                    DB       $FF, +$50, +$1B              ; draw, y, x 
                    DB       $FF, +$50, +$1C              ; draw, y, x 
                    DB       $FF, +$1E, +$22              ; draw, y, x 
                    DB       $FF, -$0D, -$1C              ; draw, y, x 
                    DB       $FF, +$41, +$15              ; draw, y, x 
                    DB       $FF, +$41, +$16              ; draw, y, x 
                    DB       $FF, -$6B, -$2B              ; draw, y, x 
                    DB       $FF, +$41, +$0A              ; draw, y, x 
                    DB       $FF, +$42, +$0B              ; draw, y, x 
                    DB       $FF, -$50, -$0F              ; draw, y, x 
                    DB       $FF, -$50, -$0E              ; draw, y, x 
                    DB       $FF, -$53, -$1C              ; draw, y, x 
                    DB       $FF, -$53, -$1B              ; draw, y, x 
                    DB       $01, +$06, +$01              ; sync and move to y, x 
                    DB       $FF, +$54, +$07              ; draw, y, x 
                    DB       $FF, +$54, +$08              ; draw, y, x 
                    DB       $FF, +$51, +$16              ; draw, y, x 
                    DB       $FF, +$52, +$17              ; draw, y, x 
                    DB       $FF, -$41, -$15              ; draw, y, x 
                    DB       $FF, -$41, -$14              ; draw, y, x 
                    DB       $FF, +$68, +$08              ; draw, y, x 
                    DB       $FF, -$70, -$0D              ; draw, y, x 
                    DB       $FF, +$17, -$15              ; draw, y, x 
                    DB       $FF, -$1A, +$09              ; draw, y, x 
                    DB       $FF, -$19, +$09              ; draw, y, x 
                    DB       $FF, -$54, -$08              ; draw, y, x 
                    DB       $FF, -$54, -$07              ; draw, y, x 
                    DB       $FF, +$06, -$13              ; draw, y, x 
                    DB       $FF, +$06, -$14              ; draw, y, x 
                    DB       $FF, +$6A, +$02              ; draw, y, x 
                    DB       $FF, -$6C, -$09              ; draw, y, x 
                    DB       $FF, -$02, -$1C              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_9: 
                    DB       $01, -$05, -$10              ; sync and move to y, x 
                    DB       $FF, -$06, +$03              ; draw, y, x 
                    DB       $FF, -$07, +$02              ; draw, y, x 
                    DB       $FF, -$6D, -$07              ; draw, y, x 
                    DB       $FF, +$69, +$08              ; draw, y, x 
                    DB       $FF, +$02, +$05              ; draw, y, x 
                    DB       $FF, +$02, +$04              ; draw, y, x 
                    DB       $FF, -$4E, -$05              ; draw, y, x 
                    DB       $FF, -$4E, -$06              ; draw, y, x 
                    DB       $FF, -$1D, -$04              ; draw, y, x 
                    DB       $FF, -$1E, -$05              ; draw, y, x 
                    DB       $FF, +$11, +$04              ; draw, y, x 
                    DB       $FF, +$10, +$03              ; draw, y, x 
                    DB       $FF, -$71, -$07              ; draw, y, x 
                    DB       $FF, +$61, +$07              ; draw, y, x 
                    DB       $FF, -$7E, -$03              ; draw, y, x 
                    DB       $FF, +$4D, +$03              ; draw, y, x 
                    DB       $FF, +$4D, +$02              ; draw, y, x 
                    DB       $FF, +$52, +$06              ; draw, y, x 
                    DB       $FF, +$52, +$05              ; draw, y, x 
                    DB       $01, -$18, -$01              ; sync and move to y, x 
                    DB       $FF, -$4F, -$01              ; draw, y, x 
                    DB       $FF, -$4F, -$02              ; draw, y, x 
                    DB       $FF, -$4B, -$03              ; draw, y, x 
                    DB       $FF, -$4B, -$04              ; draw, y, x 
                    DB       $FF, +$7A, +$07              ; draw, y, x 
                    DB       $FF, -$68, -$02              ; draw, y, x 
                    DB       $FF, +$62, +$03              ; draw, y, x 
                    DB       $FF, -$0C, +$04              ; draw, y, x 
                    DB       $FF, +$1B, -$02              ; draw, y, x 
                    DB       $FF, +$1B, -$02              ; draw, y, x 
                    DB       $FF, +$4F, +$02              ; draw, y, x 
                    DB       $FF, +$4F, +$01              ; draw, y, x 
                    DB       $FF, -$02, +$03              ; draw, y, x 
                    DB       $FF, -$02, +$04              ; draw, y, x 
                    DB       $FF, -$64, +$00              ; draw, y, x 
                    DB       $FF, +$60, +$01              ; draw, y, x 
                    DB       $FF, +$06, +$03              ; draw, y, x 
                    DB       $FF, +$05, +$04              ; draw, y, x 
                    DB       $01, -$0D, +$0F              ; sync and move to y, x 
                    DB       $FF, +$05, -$03              ; draw, y, x 
                    DB       $FF, +$04, -$03              ; draw, y, x 
                    DB       $FF, +$61, +$08              ; draw, y, x 
                    DB       $FF, -$5D, -$0A              ; draw, y, x 
                    DB       $FF, +$01, -$03              ; draw, y, x 
                    DB       $FF, +$01, -$03              ; draw, y, x 
                    DB       $FF, +$54, +$05              ; draw, y, x 
                    DB       $FF, +$54, +$06              ; draw, y, x 
                    DB       $FF, +$23, +$07              ; draw, y, x 
                    DB       $FF, -$11, -$06              ; draw, y, x 
                    DB       $FF, +$43, +$04              ; draw, y, x 
                    DB       $FF, +$44, +$05              ; draw, y, x 
                    DB       $FF, -$71, -$09              ; draw, y, x 
                    DB       $FF, +$42, +$02              ; draw, y, x 
                    DB       $FF, +$42, +$02              ; draw, y, x 
                    DB       $FF, -$51, -$03              ; draw, y, x 
                    DB       $FF, -$51, -$03              ; draw, y, x 
                    DB       $FF, -$57, -$06              ; draw, y, x 
                    DB       $FF, -$57, -$05              ; draw, y, x 
                    DB       $01, +$06, +$00              ; sync and move to y, x 
                    DB       $FF, +$54, +$01              ; draw, y, x 
                    DB       $FF, +$54, +$02              ; draw, y, x 
                    DB       $FF, +$54, +$04              ; draw, y, x 
                    DB       $FF, +$54, +$05              ; draw, y, x 
                    DB       $FF, -$44, -$04              ; draw, y, x 
                    DB       $FF, -$44, -$04              ; draw, y, x 
                    DB       $FF, +$68, +$01              ; draw, y, x 
                    DB       $FF, -$70, -$02              ; draw, y, x 
                    DB       $FF, +$12, -$05              ; draw, y, x 
                    DB       $FF, -$17, +$02              ; draw, y, x 
                    DB       $FF, -$17, +$02              ; draw, y, x 
                    DB       $FF, -$54, -$02              ; draw, y, x 
                    DB       $FF, -$54, -$01              ; draw, y, x 
                    DB       $FF, +$02, -$04              ; draw, y, x 
                    DB       $FF, +$02, -$04              ; draw, y, x 
                    DB       $FF, +$68, +$01              ; draw, y, x 
                    DB       $FF, -$6C, -$02              ; draw, y, x 
                    DB       $FF, -$03, -$03              ; draw, y, x 
                    DB       $FF, -$04, -$03              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_10: 
                    DB       $01, +$00, +$2F              ; sync and move to y, x 
                    DB       $FF, -$07, -$07              ; draw, y, x 
                    DB       $FF, -$07, -$07              ; draw, y, x 
                    DB       $FF, -$6C, +$16              ; draw, y, x 
                    DB       $FF, +$68, -$19              ; draw, y, x 
                    DB       $FF, +$00, -$0D              ; draw, y, x 
                    DB       $FF, +$00, -$0D              ; draw, y, x 
                    DB       $FF, -$4C, +$10              ; draw, y, x 
                    DB       $FF, -$4D, +$10              ; draw, y, x 
                    DB       $FF, -$1C, +$0D              ; draw, y, x 
                    DB       $FF, -$1D, +$0E              ; draw, y, x 
                    DB       $FF, +$10, -$0B              ; draw, y, x 
                    DB       $FF, +$10, -$0A              ; draw, y, x 
                    DB       $FF, -$71, +$15              ; draw, y, x 
                    DB       $FF, +$61, -$15              ; draw, y, x 
                    DB       $FF, -$7E, +$08              ; draw, y, x 
                    DB       $FF, +$4D, -$07              ; draw, y, x 
                    DB       $FF, +$4C, -$07              ; draw, y, x 
                    DB       $FF, +$51, -$11              ; draw, y, x 
                    DB       $FF, +$50, -$10              ; draw, y, x 
                    DB       $01, -$18, +$03              ; sync and move to y, x 
                    DB       $FF, -$4F, +$04              ; draw, y, x 
                    DB       $FF, -$4F, +$05              ; draw, y, x 
                    DB       $FF, -$4A, +$0B              ; draw, y, x 
                    DB       $FF, -$4A, +$0B              ; draw, y, x 
                    DB       $FF, +$78, -$15              ; draw, y, x 
                    DB       $FF, -$68, +$06              ; draw, y, x 
                    DB       $FF, +$62, -$08              ; draw, y, x 
                    DB       $FF, -$0E, -$0E              ; draw, y, x 
                    DB       $FF, +$1C, +$05              ; draw, y, x 
                    DB       $FF, +$1C, +$06              ; draw, y, x 
                    DB       $FF, +$4F, -$04              ; draw, y, x 
                    DB       $FF, +$4F, -$03              ; draw, y, x 
                    DB       $FF, -$03, -$0A              ; draw, y, x 
                    DB       $FF, -$04, -$0A              ; draw, y, x 
                    DB       $FF, -$65, -$02              ; draw, y, x 
                    DB       $FF, +$61, -$03              ; draw, y, x 
                    DB       $FF, +$05, -$0A              ; draw, y, x 
                    DB       $FF, +$04, -$0A              ; draw, y, x 
                    DB       $01, -$12, -$2C              ; sync and move to y, x 
                    DB       $FF, +$06, +$09              ; draw, y, x 
                    DB       $FF, +$05, +$08              ; draw, y, x 
                    DB       $FF, +$5F, -$17              ; draw, y, x 
                    DB       $FF, -$5B, +$1C              ; draw, y, x 
                    DB       $FF, +$03, +$0A              ; draw, y, x 
                    DB       $FF, +$02, +$0A              ; draw, y, x 
                    DB       $FF, +$52, -$10              ; draw, y, x 
                    DB       $FF, +$53, -$11              ; draw, y, x 
                    DB       $FF, +$22, -$15              ; draw, y, x 
                    DB       $FF, -$10, +$11              ; draw, y, x 
                    DB       $FF, +$42, -$0D              ; draw, y, x 
                    DB       $FF, +$43, -$0D              ; draw, y, x 
                    DB       $FF, -$6F, +$1A              ; draw, y, x 
                    DB       $FF, +$41, -$06              ; draw, y, x 
                    DB       $FF, +$42, -$06              ; draw, y, x 
                    DB       $FF, -$51, +$09              ; draw, y, x 
                    DB       $FF, -$50, +$08              ; draw, y, x 
                    DB       $FF, -$56, +$11              ; draw, y, x 
                    DB       $FF, -$55, +$10              ; draw, y, x 
                    DB       $01, +$06, -$01              ; sync and move to y, x 
                    DB       $FF, +$54, -$04              ; draw, y, x 
                    DB       $FF, +$54, -$05              ; draw, y, x 
                    DB       $FF, +$53, -$0D              ; draw, y, x 
                    DB       $FF, +$53, -$0E              ; draw, y, x 
                    DB       $FF, -$43, +$0D              ; draw, y, x 
                    DB       $FF, -$43, +$0C              ; draw, y, x 
                    DB       $FF, +$68, -$04              ; draw, y, x 
                    DB       $FF, -$70, +$07              ; draw, y, x 
                    DB       $FF, +$14, +$0D              ; draw, y, x 
                    DB       $FF, -$18, -$05              ; draw, y, x 
                    DB       $FF, -$18, -$06              ; draw, y, x 
                    DB       $FF, -$54, +$05              ; draw, y, x 
                    DB       $FF, -$54, +$04              ; draw, y, x 
                    DB       $FF, +$03, +$0C              ; draw, y, x 
                    DB       $FF, +$04, +$0C              ; draw, y, x 
                    DB       $FF, +$69, -$01              ; draw, y, x 
                    DB       $FF, -$6C, +$05              ; draw, y, x 
                    DB       $FF, -$06, +$11              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_11: 
                    DB       $01, +$1A, +$69              ; sync and move to y, x 
                    DB       $FF, -$17, -$21              ; draw, y, x 
                    DB       $FF, -$63, +$34              ; draw, y, x 
                    DB       $FF, +$5D, -$3A              ; draw, y, x 
                    DB       $FF, -$06, -$1C              ; draw, y, x 
                    DB       $FF, -$07, -$1C              ; draw, y, x 
                    DB       $FF, -$46, +$24              ; draw, y, x 
                    DB       $FF, -$47, +$24              ; draw, y, x 
                    DB       $FF, -$16, +$1E              ; draw, y, x 
                    DB       $FF, -$16, +$1E              ; draw, y, x 
                    DB       $FF, +$0B, -$18              ; draw, y, x 
                    DB       $FF, +$0A, -$18              ; draw, y, x 
                    DB       $FF, -$69, +$31              ; draw, y, x 
                    DB       $FF, +$58, -$2F              ; draw, y, x 
                    DB       $FF, -$7D, +$13              ; draw, y, x 
                    DB       $FF, +$4C, -$11              ; draw, y, x 
                    DB       $FF, +$4B, -$10              ; draw, y, x 
                    DB       $FF, +$4A, -$25              ; draw, y, x 
                    DB       $FF, +$4A, -$25              ; draw, y, x 
                    DB       $01, -$17, +$08              ; sync and move to y, x 
                    DB       $FF, -$4F, +$0A              ; draw, y, x 
                    DB       $FF, -$50, +$0A              ; draw, y, x 
                    DB       $FF, -$46, +$19              ; draw, y, x 
                    DB       $FF, -$47, +$1A              ; draw, y, x 
                    DB       $FF, +$71, -$30              ; draw, y, x 
                    DB       $FF, -$68, +$0F              ; draw, y, x 
                    DB       $FF, +$60, -$14              ; draw, y, x 
                    DB       $FF, -$16, -$1E              ; draw, y, x 
                    DB       $FF, +$20, +$0C              ; draw, y, x 
                    DB       $FF, +$20, +$0D              ; draw, y, x 
                    DB       $FF, +$50, -$0A              ; draw, y, x 
                    DB       $FF, +$50, -$0A              ; draw, y, x 
                    DB       $FF, -$09, -$16              ; draw, y, x 
                    DB       $FF, -$09, -$16              ; draw, y, x 
                    DB       $FF, -$6A, -$03              ; draw, y, x 
                    DB       $FF, +$63, -$07              ; draw, y, x 
                    DB       $FF, -$01, -$16              ; draw, y, x 
                    DB       $FF, -$01, -$17              ; draw, y, x 
                    DB       $01, -$2B, -$62              ; sync and move to y, x 
                    DB       $FF, +$0B, +$14              ; draw, y, x 
                    DB       $FF, +$0A, +$13              ; draw, y, x 
                    DB       $FF, +$56, -$35              ; draw, y, x 
                    DB       $FF, -$4F, +$3F              ; draw, y, x 
                    DB       $FF, +$08, +$17              ; draw, y, x 
                    DB       $FF, +$08, +$16              ; draw, y, x 
                    DB       $FF, +$4C, -$26              ; draw, y, x 
                    DB       $FF, +$4C, -$27              ; draw, y, x 
                    DB       $FF, +$18, -$2D              ; draw, y, x 
                    DB       $FF, -$08, +$25              ; draw, y, x 
                    DB       $FF, +$7D, -$3B              ; draw, y, x 
                    DB       $FF, -$66, +$3B              ; draw, y, x 
                    DB       $FF, +$41, -$0E              ; draw, y, x 
                    DB       $FF, +$41, -$0F              ; draw, y, x 
                    DB       $FF, -$4F, +$14              ; draw, y, x 
                    DB       $FF, -$4F, +$14              ; draw, y, x 
                    DB       $FF, -$4F, +$26              ; draw, y, x 
                    DB       $FF, -$4F, +$26              ; draw, y, x 
                    DB       $01, +$06, -$02              ; sync and move to y, x 
                    DB       $FF, +$54, -$0B              ; draw, y, x 
                    DB       $FF, +$55, -$0B              ; draw, y, x 
                    DB       $FF, +$4E, -$1E              ; draw, y, x 
                    DB       $FF, +$4F, -$1F              ; draw, y, x 
                    DB       $FF, -$7D, +$39              ; draw, y, x 
                    DB       $FF, +$69, -$0C              ; draw, y, x 
                    DB       $FF, -$70, +$12              ; draw, y, x 
                    DB       $FF, +$1C, +$1D              ; draw, y, x 
                    DB       $FF, -$1C, -$0C              ; draw, y, x 
                    DB       $FF, -$1C, -$0C              ; draw, y, x 
                    DB       $FF, -$55, +$0B              ; draw, y, x 
                    DB       $FF, -$54, +$0A              ; draw, y, x 
                    DB       $FF, +$0A, +$1B              ; draw, y, x 
                    DB       $FF, +$0B, +$1B              ; draw, y, x 
                    DB       $FF, +$6C, -$04              ; draw, y, x 
                    DB       $FF, -$6D, +$0D              ; draw, y, x 
                    DB       $FF, +$03, +$26              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_12: 
                    DB       $01, +$46, +$7F              ; sync and move to y, x 
                    DB       $00, +$00, +$18              ; additional sync move to y, x 
                    DB       $FF, -$25, -$2E              ; draw, y, x 
                    DB       $FF, -$55, +$4C              ; draw, y, x 
                    DB       $FF, +$4C, -$55              ; draw, y, x 
                    DB       $FF, -$13, -$29              ; draw, y, x 
                    DB       $FF, -$12, -$28              ; draw, y, x 
                    DB       $FF, -$78, +$6C              ; draw, y, x 
                    DB       $FF, -$0B, +$2C              ; draw, y, x 
                    DB       $FF, -$0B, +$2C              ; draw, y, x 
                    DB       $FF, +$02, -$46              ; draw, y, x 
                    DB       $FF, -$5A, +$4A              ; draw, y, x 
                    DB       $FF, +$4A, -$47              ; draw, y, x 
                    DB       $FF, -$7D, +$20              ; draw, y, x 
                    DB       $FF, +$49, -$1A              ; draw, y, x 
                    DB       $FF, +$49, -$1A              ; draw, y, x 
                    DB       $FF, +$7F, -$70              ; draw, y, x 
                    DB       $01, -$15, +$0C              ; sync and move to y, x 
                    DB       $FF, -$50, +$11              ; draw, y, x 
                    DB       $FF, -$50, +$11              ; draw, y, x 
                    DB       $FF, -$40, +$26              ; draw, y, x 
                    DB       $FF, -$41, +$27              ; draw, y, x 
                    DB       $FF, +$65, -$48              ; draw, y, x 
                    DB       $FF, -$69, +$18              ; draw, y, x 
                    DB       $FF, +$5E, -$20              ; draw, y, x 
                    DB       $FF, -$23, -$2A              ; draw, y, x 
                    DB       $FF, +$27, +$11              ; draw, y, x 
                    DB       $FF, +$27, +$11              ; draw, y, x 
                    DB       $FF, +$50, -$11              ; draw, y, x 
                    DB       $FF, +$50, -$10              ; draw, y, x 
                    DB       $FF, -$12, -$1F              ; draw, y, x 
                    DB       $FF, -$12, -$20              ; draw, y, x 
                    DB       $FF, -$71, -$02              ; draw, y, x 
                    DB       $FF, +$65, -$0C              ; draw, y, x 
                    DB       $FF, -$09, -$20              ; draw, y, x 
                    DB       $FF, -$0A, -$21              ; draw, y, x 
                    DB       $01, -$54, -$7F              ; sync and move to y, x 
                    DB       $00, +$00, -$0D              ; additional sync move to y, x 
                    DB       $FF, +$13, +$1C              ; draw, y, x 
                    DB       $FF, +$12, +$1B              ; draw, y, x 
                    DB       $FF, +$46, -$4E              ; draw, y, x 
                    DB       $FF, -$3A, +$5D              ; draw, y, x 
                    DB       $FF, +$11, +$20              ; draw, y, x 
                    DB       $FF, +$11, +$20              ; draw, y, x 
                    DB       $FF, +$41, -$39              ; draw, y, x 
                    DB       $FF, +$42, -$3A              ; draw, y, x 
                    DB       $FF, +$06, -$43              ; draw, y, x 
                    DB       $FF, +$08, +$37              ; draw, y, x 
                    DB       $FF, +$6B, -$58              ; draw, y, x 
                    DB       $FF, -$53, +$57              ; draw, y, x 
                    DB       $FF, +$7D, -$2D              ; draw, y, x 
                    DB       $FF, -$4C, +$1F              ; draw, y, x 
                    DB       $FF, -$4B, +$1F              ; draw, y, x 
                    DB       $FF, -$45, +$39              ; draw, y, x 
                    DB       $FF, -$44, +$39              ; draw, y, x 
                    DB       $01, +$05, -$03              ; sync and move to y, x 
                    DB       $FF, +$55, -$12              ; draw, y, x 
                    DB       $FF, +$55, -$12              ; draw, y, x 
                    DB       $FF, +$46, -$2E              ; draw, y, x 
                    DB       $FF, +$47, -$2F              ; draw, y, x 
                    DB       $FF, -$6D, +$56              ; draw, y, x 
                    DB       $FF, +$6B, -$14              ; draw, y, x 
                    DB       $FF, -$6F, +$1C              ; draw, y, x 
                    DB       $FF, +$29, +$2A              ; draw, y, x 
                    DB       $FF, -$45, -$22              ; draw, y, x 
                    DB       $FF, -$55, +$12              ; draw, y, x 
                    DB       $FF, -$55, +$12              ; draw, y, x 
                    DB       $FF, +$15, +$26              ; draw, y, x 
                    DB       $FF, +$16, +$27              ; draw, y, x 
                    DB       $FF, +$71, -$09              ; draw, y, x 
                    DB       $FF, -$6E, +$16              ; draw, y, x 
                    DB       $FF, +$13, +$37              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_13: 
                    DB       $01, +$7E, +$7F              ; sync and move to y, x 
                    DB       $00, +$00, +$35              ; additional sync move to y, x 
                    DB       $FF, -$38, -$37              ; draw, y, x 
                    DB       $FF, -$40, +$62              ; draw, y, x 
                    DB       $FF, +$34, -$6C              ; draw, y, x 
                    DB       $FF, -$22, -$31              ; draw, y, x 
                    DB       $FF, -$21, -$30              ; draw, y, x 
                    DB       $FF, -$2E, +$45              ; draw, y, x 
                    DB       $FF, -$2E, +$45              ; draw, y, x 
                    DB       $FF, +$06, +$6D              ; draw, y, x 
                    DB       $FF, -$15, -$55              ; draw, y, x 
                    DB       $FF, -$48, +$5E              ; draw, y, x 
                    DB       $FF, +$37, -$5A              ; draw, y, x 
                    DB       $FF, -$7B, +$2D              ; draw, y, x 
                    DB       $FF, +$46, -$23              ; draw, y, x 
                    DB       $FF, +$46, -$23              ; draw, y, x 
                    DB       $FF, +$31, -$48              ; draw, y, x 
                    DB       $FF, +$30, -$48              ; draw, y, x 
                    DB       $01, -$13, +$0F              ; sync and move to y, x 
                    DB       $FF, -$4F, +$19              ; draw, y, x 
                    DB       $FF, -$50, +$19              ; draw, y, x 
                    DB       $FF, -$70, +$65              ; draw, y, x 
                    DB       $FF, +$53, -$5D              ; draw, y, x 
                    DB       $FF, -$67, +$23              ; draw, y, x 
                    DB       $FF, +$59, -$2C              ; draw, y, x 
                    DB       $FF, -$34, -$32              ; draw, y, x 
                    DB       $FF, +$5F, +$26              ; draw, y, x 
                    DB       $FF, +$51, -$18              ; draw, y, x 
                    DB       $FF, +$50, -$18              ; draw, y, x 
                    DB       $FF, -$1E, -$25              ; draw, y, x 
                    DB       $FF, -$1F, -$26              ; draw, y, x 
                    DB       $FF, -$79, +$04              ; draw, y, x 
                    DB       $FF, +$68, -$15              ; draw, y, x 
                    DB       $FF, -$2B, -$4E              ; draw, y, x 
                    DB       $01, -$7F, -$7F              ; sync and move to y, x 
                    DB       $00, -$0B, -$27              ; additional sync move to y, x 
                    DB       $FF, +$3A, +$41              ; draw, y, x 
                    DB       $FF, +$31, -$62              ; draw, y, x 
                    DB       $FF, -$1F, +$74              ; draw, y, x 
                    DB       $FF, +$1E, +$26              ; draw, y, x 
                    DB       $FF, +$1D, +$26              ; draw, y, x 
                    DB       $FF, +$32, -$49              ; draw, y, x 
                    DB       $FF, +$33, -$4A              ; draw, y, x 
                    DB       $FF, -$10, -$51              ; draw, y, x 
                    DB       $FF, +$1B, +$42              ; draw, y, x 
                    DB       $FF, +$55, -$72              ; draw, y, x 
                    DB       $FF, -$3C, +$6F              ; draw, y, x 
                    DB       $FF, +$77, -$3D              ; draw, y, x 
                    DB       $FF, -$46, +$2A              ; draw, y, x 
                    DB       $FF, -$46, +$29              ; draw, y, x 
                    DB       $FF, -$36, +$49              ; draw, y, x 
                    DB       $FF, -$36, +$49              ; draw, y, x 
                    DB       $01, +$05, -$04              ; sync and move to y, x 
                    DB       $FF, +$55, -$1A              ; draw, y, x 
                    DB       $FF, +$55, -$1B              ; draw, y, x 
                    DB       $FF, +$77, -$79              ; draw, y, x 
                    DB       $FF, -$57, +$6F              ; draw, y, x 
                    DB       $FF, +$6B, -$1E              ; draw, y, x 
                    DB       $FF, -$6E, +$28              ; draw, y, x 
                    DB       $FF, +$3B, +$31              ; draw, y, x 
                    DB       $FF, -$55, -$26              ; draw, y, x 
                    DB       $FF, -$56, +$1A              ; draw, y, x 
                    DB       $FF, -$55, +$1A              ; draw, y, x 
                    DB       $FF, +$24, +$2E              ; draw, y, x 
                    DB       $FF, +$25, +$2E              ; draw, y, x 
                    DB       $FF, +$75, -$10              ; draw, y, x 
                    DB       $FF, -$6E, +$21              ; draw, y, x 
                    DB       $FF, +$27, +$41              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_14: 
                    DB       $01, +$7F, +$7F              ; sync and move to y, x 
                    DB       $00, +$3E, +$3E              ; additional sync move to y, x 
                    DB       $FF, -$4C, -$38              ; draw, y, x 
                    DB       $FF, -$29, +$71              ; draw, y, x 
                    DB       $FF, +$18, -$7C              ; draw, y, x 
                    DB       $FF, -$32, -$33              ; draw, y, x 
                    DB       $FF, -$32, -$32              ; draw, y, x 
                    DB       $FF, -$1D, +$50              ; draw, y, x 
                    DB       $FF, -$1E, +$50              ; draw, y, x 
                    DB       $FF, +$27, +$78              ; draw, y, x 
                    DB       $FF, -$30, -$5D              ; draw, y, x 
                    DB       $FF, -$32, +$6E              ; draw, y, x 
                    DB       $FF, +$21, -$68              ; draw, y, x 
                    DB       $FF, -$77, +$3C              ; draw, y, x 
                    DB       $FF, +$41, -$2D              ; draw, y, x 
                    DB       $FF, +$40, -$2C              ; draw, y, x 
                    DB       $FF, +$20, -$54              ; draw, y, x 
                    DB       $FF, +$1F, -$53              ; draw, y, x 
                    DB       $01, -$10, +$12              ; sync and move to y, x 
                    DB       $FF, -$4E, +$22              ; draw, y, x 
                    DB       $FF, -$4F, +$22              ; draw, y, x 
                    DB       $FF, -$5B, +$79              ; draw, y, x 
                    DB       $FF, +$3E, -$6D              ; draw, y, x 
                    DB       $FF, -$65, +$2F              ; draw, y, x 
                    DB       $FF, +$54, -$38              ; draw, y, x 
                    DB       $FF, -$47, -$33              ; draw, y, x 
                    DB       $FF, +$71, +$22              ; draw, y, x 
                    DB       $FF, +$50, -$21              ; draw, y, x 
                    DB       $FF, +$50, -$21              ; draw, y, x 
                    DB       $FF, -$58, -$4E              ; draw, y, x 
                    DB       $FF, -$40, +$07              ; draw, y, x 
                    DB       $FF, -$41, +$07              ; draw, y, x 
                    DB       $FF, +$6A, -$20              ; draw, y, x 
                    DB       $FF, -$45, -$52              ; draw, y, x 
                    DB       $01, -$7F, -$7F              ; sync and move to y, x 
                    DB       $00, -$46, -$2D              ; additional sync move to y, x 
                    DB       $FF, +$52, +$43              ; draw, y, x 
                    DB       $FF, +$18, -$71              ; draw, y, x 
                    DB       $FF, +$00, +$42              ; draw, y, x 
                    DB       $FF, +$00, +$41              ; draw, y, x 
                    DB       $FF, +$56, +$50              ; draw, y, x 
                    DB       $FF, +$20, -$55              ; draw, y, x 
                    DB       $FF, +$21, -$56              ; draw, y, x 
                    DB       $FF, -$28, -$59              ; draw, y, x 
                    DB       $FF, +$30, +$47              ; draw, y, x 
                    DB       $FF, +$1D, -$42              ; draw, y, x 
                    DB       $FF, +$1D, -$42              ; draw, y, x 
                    DB       $FF, -$20, +$7F              ; draw, y, x 
                    DB       $FF, +$6E, -$4D              ; draw, y, x 
                    DB       $FF, -$7E, +$67              ; draw, y, x 
                    DB       $FF, -$25, +$56              ; draw, y, x 
                    DB       $FF, -$25, +$55              ; draw, y, x 
                    DB       $01, +$04, -$04              ; sync and move to y, x 
                    DB       $FF, +$53, -$24              ; draw, y, x 
                    DB       $FF, +$54, -$25              ; draw, y, x 
                    DB       $FF, +$2F, -$47              ; draw, y, x 
                    DB       $FF, +$2F, -$48              ; draw, y, x 
                    DB       $FF, -$1F, +$41              ; draw, y, x 
                    DB       $FF, -$1F, +$40              ; draw, y, x 
                    DB       $FF, +$6A, -$2A              ; draw, y, x 
                    DB       $FF, -$69, +$36              ; draw, y, x 
                    DB       $FF, +$4D, +$31              ; draw, y, x 
                    DB       $FF, -$67, -$23              ; draw, y, x 
                    DB       $FF, -$54, +$24              ; draw, y, x 
                    DB       $FF, -$54, +$24              ; draw, y, x 
                    DB       $FF, +$34, +$2F              ; draw, y, x 
                    DB       $FF, +$35, +$30              ; draw, y, x 
                    DB       $FF, +$7A, -$1C              ; draw, y, x 
                    DB       $FF, -$6D, +$2D              ; draw, y, x 
                    DB       $FF, +$3D, +$46              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_15: 
                    DB       $01, +$7F, +$7F              ; sync and move to y, x 
                    DB       $00, +$7C, +$32              ; additional sync move to y, x 
                    DB       $FF, -$60, -$33              ; draw, y, x 
                    DB       $FF, -$0F, +$7B              ; draw, y, x 
                    DB       $FF, -$03, -$42              ; draw, y, x 
                    DB       $FF, -$03, -$42              ; draw, y, x 
                    DB       $FF, -$43, -$30              ; draw, y, x 
                    DB       $FF, -$42, -$2F              ; draw, y, x 
                    DB       $FF, -$0B, +$56              ; draw, y, x 
                    DB       $FF, -$0C, +$57              ; draw, y, x 
                    DB       $FF, +$48, +$79              ; draw, y, x 
                    DB       $FF, -$4A, -$5B              ; draw, y, x 
                    DB       $FF, -$1B, +$78              ; draw, y, x 
                    DB       $FF, +$0A, -$70              ; draw, y, x 
                    DB       $FF, -$71, +$4B              ; draw, y, x 
                    DB       $FF, +$74, -$6B              ; draw, y, x 
                    DB       $FF, +$0D, -$5A              ; draw, y, x 
                    DB       $FF, +$0D, -$5A              ; draw, y, x 
                    DB       $01, -$0C, +$15              ; sync and move to y, x 
                    DB       $FF, -$4C, +$2C              ; draw, y, x 
                    DB       $FF, -$4C, +$2C              ; draw, y, x 
                    DB       $FF, -$21, +$43              ; draw, y, x 
                    DB       $FF, -$22, +$44              ; draw, y, x 
                    DB       $FF, +$27, -$78              ; draw, y, x 
                    DB       $FF, -$60, +$3C              ; draw, y, x 
                    DB       $FF, +$4B, -$43              ; draw, y, x 
                    DB       $FF, -$59, -$2E              ; draw, y, x 
                    DB       $FF, +$41, +$0B              ; draw, y, x 
                    DB       $FF, +$41, +$0C              ; draw, y, x 
                    DB       $FF, +$4E, -$2B              ; draw, y, x 
                    DB       $FF, +$4D, -$2B              ; draw, y, x 
                    DB       $FF, -$72, -$48              ; draw, y, x 
                    DB       $FF, -$43, +$0F              ; draw, y, x 
                    DB       $FF, -$44, +$0E              ; draw, y, x 
                    DB       $FF, +$6A, -$2C              ; draw, y, x 
                    DB       $FF, -$5F, -$4F              ; draw, y, x 
                    DB       $01, -$7F, -$7F              ; sync and move to y, x 
                    DB       $00, -$7F, -$1F              ; additional sync move to y, x 
                    DB       $00, -$01, +$00              ; additional sync move to y, x 
                    DB       $FF, +$68, +$3D              ; draw, y, x 
                    DB       $FF, -$02, -$78              ; draw, y, x 
                    DB       $FF, +$11, +$44              ; draw, y, x 
                    DB       $FF, +$11, +$44              ; draw, y, x 
                    DB       $FF, +$70, +$4A              ; draw, y, x 
                    DB       $FF, +$0D, -$5C              ; draw, y, x 
                    DB       $FF, +$0E, -$5D              ; draw, y, x 
                    DB       $FF, -$43, -$58              ; draw, y, x 
                    DB       $FF, +$46, +$45              ; draw, y, x 
                    DB       $FF, +$0E, -$48              ; draw, y, x 
                    DB       $FF, +$0F, -$49              ; draw, y, x 
                    DB       $FF, -$01, +$45              ; draw, y, x 
                    DB       $FF, -$01, +$44              ; draw, y, x 
                    DB       $FF, +$63, -$5D              ; draw, y, x 
                    DB       $FF, -$6E, +$79              ; draw, y, x 
                    DB       $FF, -$12, +$5D              ; draw, y, x 
                    DB       $FF, -$12, +$5D              ; draw, y, x 
                    DB       $01, +$03, -$05              ; sync and move to y, x 
                    DB       $FF, +$51, -$2F              ; draw, y, x 
                    DB       $FF, +$51, -$2F              ; draw, y, x 
                    DB       $FF, +$20, -$4F              ; draw, y, x 
                    DB       $FF, +$20, -$50              ; draw, y, x 
                    DB       $FF, -$11, +$47              ; draw, y, x 
                    DB       $FF, -$11, +$46              ; draw, y, x 
                    DB       $FF, +$68, -$37              ; draw, y, x 
                    DB       $FF, -$64, +$43              ; draw, y, x 
                    DB       $FF, +$5F, +$2B              ; draw, y, x 
                    DB       $FF, -$77, -$19              ; draw, y, x 
                    DB       $FF, -$52, +$2F              ; draw, y, x 
                    DB       $FF, -$51, +$2E              ; draw, y, x 
                    DB       $FF, +$44, +$2B              ; draw, y, x 
                    DB       $FF, +$45, +$2C              ; draw, y, x 
                    DB       $FF, +$7C, -$29              ; draw, y, x 
                    DB       $FF, -$6A, +$3B              ; draw, y, x 
                    DB       $FF, +$54, +$42              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_16: 
                    DB       $01, +$7F, +$7F              ; sync and move to y, x 
                    DB       $00, +$7F, +$11              ; additional sync move to y, x 
                    DB       $00, +$33, +$00              ; additional sync move to y, x 
                    DB       $FF, -$71, -$26              ; draw, y, x 
                    DB       $FF, +$0B, +$7E              ; draw, y, x 
                    DB       $FF, -$12, -$42              ; draw, y, x 
                    DB       $FF, -$11, -$42              ; draw, y, x 
                    DB       $FF, -$51, -$27              ; draw, y, x 
                    DB       $FF, -$51, -$27              ; draw, y, x 
                    DB       $FF, +$07, +$59              ; draw, y, x 
                    DB       $FF, +$07, +$59              ; draw, y, x 
                    DB       $FF, +$67, +$70              ; draw, y, x 
                    DB       $FF, -$63, -$52              ; draw, y, x 
                    DB       $FF, -$02, +$7C              ; draw, y, x 
                    DB       $FF, -$0F, -$72              ; draw, y, x 
                    DB       $FF, -$67, +$5C              ; draw, y, x 
                    DB       $FF, +$64, -$7C              ; draw, y, x 
                    DB       $FF, -$06, -$5D              ; draw, y, x 
                    DB       $FF, -$06, -$5C              ; draw, y, x 
                    DB       $01, -$08, +$17              ; sync and move to y, x 
                    DB       $FF, -$47, +$36              ; draw, y, x 
                    DB       $FF, -$47, +$37              ; draw, y, x 
                    DB       $FF, -$15, +$49              ; draw, y, x 
                    DB       $FF, -$15, +$49              ; draw, y, x 
                    DB       $FF, +$10, -$7F              ; draw, y, x 
                    DB       $FF, -$5A, +$4A              ; draw, y, x 
                    DB       $FF, +$42, -$4E              ; draw, y, x 
                    DB       $FF, -$69, -$23              ; draw, y, x 
                    DB       $FF, +$48, +$03              ; draw, y, x 
                    DB       $FF, +$48, +$03              ; draw, y, x 
                    DB       $FF, +$48, -$36              ; draw, y, x 
                    DB       $FF, +$48, -$36              ; draw, y, x 
                    DB       $FF, -$44, -$1C              ; draw, y, x 
                    DB       $FF, -$44, -$1D              ; draw, y, x 
                    DB       $FF, -$44, +$18              ; draw, y, x 
                    DB       $FF, -$45, +$17              ; draw, y, x 
                    DB       $FF, +$66, -$3A              ; draw, y, x 
                    DB       $FF, -$76, -$43              ; draw, y, x 
                    DB       $01, -$7F, -$7D              ; sync and move to y, x 
                    DB       $00, -$7F, +$00              ; additional sync move to y, x 
                    DB       $00, -$34, +$00              ; additional sync move to y, x 
                    DB       $FF, +$7D, +$30              ; draw, y, x 
                    DB       $FF, -$1D, -$79              ; draw, y, x 
                    DB       $FF, +$21, +$43              ; draw, y, x 
                    DB       $FF, +$21, +$42              ; draw, y, x 
                    DB       $FF, +$44, +$1E              ; draw, y, x 
                    DB       $FF, +$43, +$1D              ; draw, y, x 
                    DB       $FF, -$06, -$5F              ; draw, y, x 
                    DB       $FF, -$06, -$5F              ; draw, y, x 
                    DB       $FF, -$5A, -$50              ; draw, y, x 
                    DB       $FF, +$59, +$3C              ; draw, y, x 
                    DB       $FF, +$00, -$4B              ; draw, y, x 
                    DB       $FF, -$01, -$4B              ; draw, y, x 
                    DB       $FF, +$0E, +$45              ; draw, y, x 
                    DB       $FF, +$0E, +$45              ; draw, y, x 
                    DB       $FF, +$54, -$6B              ; draw, y, x 
                    DB       $FF, -$2D, +$45              ; draw, y, x 
                    DB       $FF, -$2D, +$44              ; draw, y, x 
                    DB       $FF, +$01, +$61              ; draw, y, x 
                    DB       $FF, +$02, +$60              ; draw, y, x 
                    DB       $01, +$02, -$05              ; sync and move to y, x 
                    DB       $FF, +$4B, -$3A              ; draw, y, x 
                    DB       $FF, +$4C, -$3B              ; draw, y, x 
                    DB       $FF, +$10, -$54              ; draw, y, x 
                    DB       $FF, +$11, -$55              ; draw, y, x 
                    DB       $FF, -$03, +$4A              ; draw, y, x 
                    DB       $FF, -$02, +$49              ; draw, y, x 
                    DB       $FF, +$62, -$46              ; draw, y, x 
                    DB       $FF, -$5B, +$52              ; draw, y, x 
                    DB       $FF, +$6E, +$1E              ; draw, y, x 
                    DB       $FF, -$42, -$04              ; draw, y, x 
                    DB       $FF, -$42, -$05              ; draw, y, x 
                    DB       $FF, -$4C, +$3A              ; draw, y, x 
                    DB       $FF, -$4C, +$39              ; draw, y, x 
                    DB       $FF, +$52, +$23              ; draw, y, x 
                    DB       $FF, +$53, +$23              ; draw, y, x 
                    DB       $FF, +$7A, -$3B              ; draw, y, x 
                    DB       $FF, -$63, +$4A              ; draw, y, x 
                    DB       $FF, +$67, +$37              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_17: 
                    DB       $01, +$7F, +$60              ; sync and move to y, x 
                    DB       $00, +$7F, +$00              ; additional sync move to y, x 
                    DB       $00, +$5B, +$00              ; additional sync move to y, x 
                    DB       $FF, -$7D, -$14              ; draw, y, x 
                    DB       $FF, +$24, +$7B              ; draw, y, x 
                    DB       $FF, -$3E, -$7E              ; draw, y, x 
                    DB       $FF, -$5C, -$1A              ; draw, y, x 
                    DB       $FF, -$5C, -$1A              ; draw, y, x 
                    DB       $FF, +$18, +$57              ; draw, y, x 
                    DB       $FF, +$19, +$57              ; draw, y, x 
                    DB       $FF, +$40, +$30              ; draw, y, x 
                    DB       $FF, +$41, +$30              ; draw, y, x 
                    DB       $FF, -$77, -$42              ; draw, y, x 
                    DB       $FF, +$16, +$7B              ; draw, y, x 
                    DB       $FF, -$25, -$6F              ; draw, y, x 
                    DB       $FF, -$5A, +$6B              ; draw, y, x 
                    DB       $FF, +$28, -$45              ; draw, y, x 
                    DB       $FF, +$28, -$45              ; draw, y, x 
                    DB       $FF, -$18, -$5B              ; draw, y, x 
                    DB       $FF, -$18, -$5B              ; draw, y, x 
                    DB       $01, -$04, +$18              ; sync and move to y, x 
                    DB       $FF, -$3F, +$41              ; draw, y, x 
                    DB       $FF, -$3F, +$41              ; draw, y, x 
                    DB       $FF, -$07, +$4B              ; draw, y, x 
                    DB       $FF, -$08, +$4C              ; draw, y, x 
                    DB       $FF, -$04, -$40              ; draw, y, x 
                    DB       $FF, -$05, -$40              ; draw, y, x 
                    DB       $FF, -$4F, +$57              ; draw, y, x 
                    DB       $FF, +$35, -$58              ; draw, y, x 
                    DB       $FF, -$73, -$11              ; draw, y, x 
                    DB       $FF, +$4B, -$09              ; draw, y, x 
                    DB       $FF, +$4B, -$08              ; draw, y, x 
                    DB       $FF, +$41, -$41              ; draw, y, x 
                    DB       $FF, +$41, -$40              ; draw, y, x 
                    DB       $FF, -$4C, -$12              ; draw, y, x 
                    DB       $FF, -$4D, -$12              ; draw, y, x 
                    DB       $FF, -$43, +$22              ; draw, y, x 
                    DB       $FF, -$43, +$22              ; draw, y, x 
                    DB       $FF, +$60, -$4A              ; draw, y, x 
                    DB       $FF, -$44, -$18              ; draw, y, x 
                    DB       $FF, -$44, -$18              ; draw, y, x 
                    DB       $01, -$7F, -$4D              ; sync and move to y, x 
                    DB       $00, -$7F, +$00              ; additional sync move to y, x 
                    DB       $00, -$58, +$00              ; additional sync move to y, x 
                    DB       $FF, +$46, +$0E              ; draw, y, x 
                    DB       $FF, +$45, +$0E              ; draw, y, x 
                    DB       $FF, -$36, -$73              ; draw, y, x 
                    DB       $FF, +$5E, +$7A              ; draw, y, x 
                    DB       $FF, +$4C, +$13              ; draw, y, x 
                    DB       $FF, +$4C, +$12              ; draw, y, x 
                    DB       $FF, -$18, -$5D              ; draw, y, x 
                    DB       $FF, -$19, -$5D              ; draw, y, x 
                    DB       $FF, -$6D, -$42              ; draw, y, x 
                    DB       $FF, +$68, +$2E              ; draw, y, x 
                    DB       $FF, -$0E, -$4A              ; draw, y, x 
                    DB       $FF, -$0F, -$4A              ; draw, y, x 
                    DB       $FF, +$1C, +$42              ; draw, y, x 
                    DB       $FF, +$1B, +$42              ; draw, y, x 
                    DB       $FF, +$43, -$77              ; draw, y, x 
                    DB       $FF, -$21, +$4B              ; draw, y, x 
                    DB       $FF, -$22, +$4B              ; draw, y, x 
                    DB       $FF, +$15, +$5F              ; draw, y, x 
                    DB       $FF, +$14, +$5F              ; draw, y, x 
                    DB       $01, +$02, -$06              ; sync and move to y, x 
                    DB       $FF, +$43, -$45              ; draw, y, x 
                    DB       $FF, +$43, -$45              ; draw, y, x 
                    DB       $FF, +$00, -$57              ; draw, y, x 
                    DB       $FF, +$01, -$57              ; draw, y, x 
                    DB       $FF, +$0C, +$4A              ; draw, y, x 
                    DB       $FF, +$0C, +$49              ; draw, y, x 
                    DB       $FF, +$58, -$55              ; draw, y, x 
                    DB       $FF, -$4F, +$60              ; draw, y, x 
                    DB       $FF, +$78, +$0C              ; draw, y, x 
                    DB       $FF, -$46, +$06              ; draw, y, x 
                    DB       $FF, -$45, +$06              ; draw, y, x 
                    DB       $FF, -$44, +$45              ; draw, y, x 
                    DB       $FF, -$44, +$45              ; draw, y, x 
                    DB       $FF, +$5C, +$16              ; draw, y, x 
                    DB       $FF, +$5D, +$16              ; draw, y, x 
                    DB       $FF, +$74, -$4D              ; draw, y, x 
                    DB       $FF, -$59, +$58              ; draw, y, x 
                    DB       $FF, +$76, +$27              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_18: 
                    DB       $01, +$7F, +$25              ; sync and move to y, x 
                    DB       $00, +$7F, +$00              ; additional sync move to y, x 
                    DB       $00, +$71, +$00              ; additional sync move to y, x 
                    DB       $FF, -$41, +$00              ; draw, y, x 
                    DB       $FF, -$41, +$01              ; draw, y, x 
                    DB       $FF, +$3A, +$74              ; draw, y, x 
                    DB       $FF, -$55, -$72              ; draw, y, x 
                    DB       $FF, -$62, -$0B              ; draw, y, x 
                    DB       $FF, -$62, -$0A              ; draw, y, x 
                    DB       $FF, +$28, +$52              ; draw, y, x 
                    DB       $FF, +$28, +$52              ; draw, y, x 
                    DB       $FF, +$4A, +$24              ; draw, y, x 
                    DB       $FF, +$4A, +$24              ; draw, y, x 
                    DB       $FF, -$42, -$17              ; draw, y, x 
                    DB       $FF, -$42, -$16              ; draw, y, x 
                    DB       $FF, +$2C, +$76              ; draw, y, x 
                    DB       $FF, -$39, -$67              ; draw, y, x 
                    DB       $FF, -$48, +$78              ; draw, y, x 
                    DB       $FF, +$1C, -$4B              ; draw, y, x 
                    DB       $FF, +$1C, -$4A              ; draw, y, x 
                    DB       $FF, -$29, -$56              ; draw, y, x 
                    DB       $FF, -$28, -$56              ; draw, y, x 
                    DB       $01, +$00, +$18              ; sync and move to y, x 
                    DB       $FF, -$34, +$4B              ; draw, y, x 
                    DB       $FF, -$35, +$4B              ; draw, y, x 
                    DB       $FF, +$06, +$4B              ; draw, y, x 
                    DB       $FF, +$05, +$4C              ; draw, y, x 
                    DB       $FF, -$1F, -$7D              ; draw, y, x 
                    DB       $FF, -$40, +$63              ; draw, y, x 
                    DB       $FF, +$26, -$5F              ; draw, y, x 
                    DB       $FF, -$79, +$02              ; draw, y, x 
                    DB       $FF, +$4B, -$15              ; draw, y, x 
                    DB       $FF, +$4B, -$15              ; draw, y, x 
                    DB       $FF, +$37, -$4B              ; draw, y, x 
                    DB       $FF, +$36, -$4A              ; draw, y, x 
                    DB       $FF, -$50, -$05              ; draw, y, x 
                    DB       $FF, -$51, -$05              ; draw, y, x 
                    DB       $FF, -$7C, +$5A              ; draw, y, x 
                    DB       $FF, +$54, -$59              ; draw, y, x 
                    DB       $FF, -$49, -$0C              ; draw, y, x 
                    DB       $FF, -$49, -$0D              ; draw, y, x 
                    DB       $01, -$7F, -$13              ; sync and move to y, x 
                    DB       $00, -$7F, +$00              ; additional sync move to y, x 
                    DB       $00, -$6A, +$00              ; additional sync move to y, x 
                    DB       $FF, +$49, +$03              ; draw, y, x 
                    DB       $FF, +$48, +$02              ; draw, y, x 
                    DB       $FF, -$4B, -$69              ; draw, y, x 
                    DB       $FF, +$75, +$68              ; draw, y, x 
                    DB       $FF, +$51, +$06              ; draw, y, x 
                    DB       $FF, +$50, +$06              ; draw, y, x 
                    DB       $FF, -$29, -$58              ; draw, y, x 
                    DB       $FF, -$2A, -$58              ; draw, y, x 
                    DB       $FF, -$7A, -$2E              ; draw, y, x 
                    DB       $FF, +$72, +$1C              ; draw, y, x 
                    DB       $FF, -$1C, -$47              ; draw, y, x 
                    DB       $FF, -$1C, -$47              ; draw, y, x 
                    DB       $FF, +$50, +$79              ; draw, y, x 
                    DB       $FF, +$17, -$40              ; draw, y, x 
                    DB       $FF, +$17, -$40              ; draw, y, x 
                    DB       $FF, -$14, +$50              ; draw, y, x 
                    DB       $FF, -$15, +$4F              ; draw, y, x 
                    DB       $FF, +$26, +$5B              ; draw, y, x 
                    DB       $FF, +$25, +$5A              ; draw, y, x 
                    DB       $01, +$01, -$06              ; sync and move to y, x 
                    DB       $FF, +$37, -$4F              ; draw, y, x 
                    DB       $FF, +$38, -$50              ; draw, y, x 
                    DB       $FF, -$0F, -$55              ; draw, y, x 
                    DB       $FF, -$0E, -$56              ; draw, y, x 
                    DB       $FF, +$19, +$47              ; draw, y, x 
                    DB       $FF, +$19, +$46              ; draw, y, x 
                    DB       $FF, +$4A, -$63              ; draw, y, x 
                    DB       $FF, -$3F, +$6C              ; draw, y, x 
                    DB       $FF, +$7D, -$08              ; draw, y, x 
                    DB       $FF, -$46, +$11              ; draw, y, x 
                    DB       $FF, -$45, +$11              ; draw, y, x 
                    DB       $FF, -$39, +$50              ; draw, y, x 
                    DB       $FF, -$39, +$4F              ; draw, y, x 
                    DB       $FF, +$61, +$06              ; draw, y, x 
                    DB       $FF, +$62, +$07              ; draw, y, x 
                    DB       $FF, +$68, -$60              ; draw, y, x 
                    DB       $FF, -$4B, +$66              ; draw, y, x 
                    DB       $FF, +$7F, +$13              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_19: 
                    DB       $01, +$7F, -$19              ; sync and move to y, x 
                    DB       $00, +$7F, +$00              ; additional sync move to y, x 
                    DB       $00, +$72, +$00              ; additional sync move to y, x 
                    DB       $FF, -$40, +$0C              ; draw, y, x 
                    DB       $FF, -$40, +$0B              ; draw, y, x 
                    DB       $FF, +$4D, +$68              ; draw, y, x 
                    DB       $FF, -$68, -$62              ; draw, y, x 
                    DB       $FF, -$62, +$06              ; draw, y, x 
                    DB       $FF, -$62, +$07              ; draw, y, x 
                    DB       $FF, +$35, +$49              ; draw, y, x 
                    DB       $FF, +$36, +$4A              ; draw, y, x 
                    DB       $FF, +$4F, +$17              ; draw, y, x 
                    DB       $FF, +$4F, +$18              ; draw, y, x 
                    DB       $FF, -$45, -$0C              ; draw, y, x 
                    DB       $FF, -$45, -$0B              ; draw, y, x 
                    DB       $FF, +$3F, +$6D              ; draw, y, x 
                    DB       $FF, -$4A, -$5C              ; draw, y, x 
                    DB       $FF, -$19, +$41              ; draw, y, x 
                    DB       $FF, -$19, +$42              ; draw, y, x 
                    DB       $FF, +$0F, -$4F              ; draw, y, x 
                    DB       $FF, +$0F, -$4E              ; draw, y, x 
                    DB       $FF, -$37, -$4E              ; draw, y, x 
                    DB       $FF, -$36, -$4D              ; draw, y, x 
                    DB       $01, +$04, +$18              ; sync and move to y, x 
                    DB       $FF, -$27, +$52              ; draw, y, x 
                    DB       $FF, -$27, +$53              ; draw, y, x 
                    DB       $FF, +$13, +$49              ; draw, y, x 
                    DB       $FF, +$12, +$4A              ; draw, y, x 
                    DB       $FF, -$34, -$76              ; draw, y, x 
                    DB       $FF, -$2F, +$6D              ; draw, y, x 
                    DB       $FF, +$15, -$64              ; draw, y, x 
                    DB       $FF, -$76, +$16              ; draw, y, x 
                    DB       $FF, +$47, -$22              ; draw, y, x 
                    DB       $FF, +$46, -$21              ; draw, y, x 
                    DB       $FF, +$29, -$53              ; draw, y, x 
                    DB       $FF, +$28, -$52              ; draw, y, x 
                    DB       $FF, -$50, +$09              ; draw, y, x 
                    DB       $FF, -$50, +$09              ; draw, y, x 
                    DB       $FF, -$6B, +$6D              ; draw, y, x 
                    DB       $FF, +$44, -$66              ; draw, y, x 
                    DB       $FF, -$4A, +$00              ; draw, y, x 
                    DB       $FF, -$4A, +$01              ; draw, y, x 
                    DB       $01, -$7F, +$2B              ; sync and move to y, x 
                    DB       $00, -$7F, +$00              ; additional sync move to y, x 
                    DB       $00, -$68, +$00              ; additional sync move to y, x 
                    DB       $FF, +$48, -$0B              ; draw, y, x 
                    DB       $FF, +$48, -$0A              ; draw, y, x 
                    DB       $FF, -$5C, -$5A              ; draw, y, x 
                    DB       $FF, +$43, +$2A              ; draw, y, x 
                    DB       $FF, +$42, +$29              ; draw, y, x 
                    DB       $FF, +$51, -$08              ; draw, y, x 
                    DB       $FF, +$50, -$08              ; draw, y, x 
                    DB       $FF, -$38, -$4F              ; draw, y, x 
                    DB       $FF, -$38, -$50              ; draw, y, x 
                    DB       $FF, -$40, -$0C              ; draw, y, x 
                    DB       $FF, -$40, -$0D              ; draw, y, x 
                    DB       $FF, +$75, +$08              ; draw, y, x 
                    DB       $FF, -$27, -$41              ; draw, y, x 
                    DB       $FF, -$28, -$41              ; draw, y, x 
                    DB       $FF, +$63, +$6A              ; draw, y, x 
                    DB       $FF, +$0C, -$43              ; draw, y, x 
                    DB       $FF, +$0C, -$44              ; draw, y, x 
                    DB       $FF, -$07, +$52              ; draw, y, x 
                    DB       $FF, -$07, +$52              ; draw, y, x 
                    DB       $FF, +$34, +$53              ; draw, y, x 
                    DB       $FF, +$34, +$53              ; draw, y, x 
                    DB       $01, -$01, -$06              ; sync and move to y, x 
                    DB       $FF, +$2A, -$58              ; draw, y, x 
                    DB       $FF, +$2A, -$58              ; draw, y, x 
                    DB       $FF, -$1D, -$51              ; draw, y, x 
                    DB       $FF, -$1D, -$52              ; draw, y, x 
                    DB       $FF, +$24, +$41              ; draw, y, x 
                    DB       $FF, +$25, +$41              ; draw, y, x 
                    DB       $FF, +$38, -$6D              ; draw, y, x 
                    DB       $FF, -$2C, +$74              ; draw, y, x 
                    DB       $FF, +$7A, -$1D              ; draw, y, x 
                    DB       $FF, -$42, +$1D              ; draw, y, x 
                    DB       $FF, -$41, +$1D              ; draw, y, x 
                    DB       $FF, -$2B, +$58              ; draw, y, x 
                    DB       $FF, -$2A, +$58              ; draw, y, x 
                    DB       $FF, +$61, -$0A              ; draw, y, x 
                    DB       $FF, +$61, -$0B              ; draw, y, x 
                    DB       $FF, +$56, -$70              ; draw, y, x 
                    DB       $FF, -$38, +$72              ; draw, y, x 
                    DB       $FF, +$40, -$01              ; draw, y, x 
                    DB       $FF, +$40, -$02              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_20: 
                    DB       $01, +$7F, -$54              ; sync and move to y, x 
                    DB       $00, +$7F, +$00              ; additional sync move to y, x 
                    DB       $00, +$5E, +$00              ; additional sync move to y, x 
                    DB       $FF, -$77, +$2B              ; draw, y, x 
                    DB       $FF, +$5C, +$5A              ; draw, y, x 
                    DB       $FF, -$74, -$50              ; draw, y, x 
                    DB       $FF, -$5D, +$17              ; draw, y, x 
                    DB       $FF, -$5C, +$16              ; draw, y, x 
                    DB       $FF, +$3F, +$40              ; draw, y, x 
                    DB       $FF, +$40, +$40              ; draw, y, x 
                    DB       $FF, +$4F, +$0A              ; draw, y, x 
                    DB       $FF, +$50, +$0A              ; draw, y, x 
                    DB       $FF, -$44, +$00              ; draw, y, x 
                    DB       $FF, -$44, +$00              ; draw, y, x 
                    DB       $FF, +$50, +$61              ; draw, y, x 
                    DB       $FF, -$57, -$4E              ; draw, y, x 
                    DB       $FF, -$0D, +$44              ; draw, y, x 
                    DB       $FF, -$0D, +$45              ; draw, y, x 
                    DB       $FF, +$01, -$50              ; draw, y, x 
                    DB       $FF, +$01, -$50              ; draw, y, x 
                    DB       $FF, -$42, -$44              ; draw, y, x 
                    DB       $FF, -$41, -$43              ; draw, y, x 
                    DB       $01, +$08, +$17              ; sync and move to y, x 
                    DB       $FF, -$17, +$57              ; draw, y, x 
                    DB       $FF, -$17, +$58              ; draw, y, x 
                    DB       $FF, +$1E, +$45              ; draw, y, x 
                    DB       $FF, +$1E, +$46              ; draw, y, x 
                    DB       $FF, -$46, -$6B              ; draw, y, x 
                    DB       $FF, -$1A, +$72              ; draw, y, x 
                    DB       $FF, +$03, -$66              ; draw, y, x 
                    DB       $FF, -$6D, +$29              ; draw, y, x 
                    DB       $FF, +$7B, -$58              ; draw, y, x 
                    DB       $FF, +$19, -$59              ; draw, y, x 
                    DB       $FF, +$19, -$58              ; draw, y, x 
                    DB       $FF, -$4B, +$16              ; draw, y, x 
                    DB       $FF, -$4C, +$16              ; draw, y, x 
                    DB       $FF, -$53, +$7D              ; draw, y, x 
                    DB       $FF, +$2F, -$70              ; draw, y, x 
                    DB       $FF, -$47, +$0C              ; draw, y, x 
                    DB       $FF, -$47, +$0D              ; draw, y, x 
                    DB       $01, -$7F, +$64              ; sync and move to y, x 
                    DB       $00, -$7F, +$00              ; additional sync move to y, x 
                    DB       $00, -$52, +$00              ; additional sync move to y, x 
                    DB       $FF, +$44, -$16              ; draw, y, x 
                    DB       $FF, +$43, -$15              ; draw, y, x 
                    DB       $FF, -$68, -$4B              ; draw, y, x 
                    DB       $FF, +$47, +$1E              ; draw, y, x 
                    DB       $FF, +$47, +$1E              ; draw, y, x 
                    DB       $FF, +$4C, -$15              ; draw, y, x 
                    DB       $FF, +$4B, -$14              ; draw, y, x 
                    DB       $FF, -$43, -$45              ; draw, y, x 
                    DB       $FF, -$43, -$46              ; draw, y, x 
                    DB       $FF, -$7F, -$04              ; draw, y, x 
                    DB       $FF, +$71, -$0B              ; draw, y, x 
                    DB       $FF, -$62, -$73              ; draw, y, x 
                    DB       $FF, +$71, +$59              ; draw, y, x 
                    DB       $FF, +$01, -$44              ; draw, y, x 
                    DB       $FF, +$00, -$45              ; draw, y, x 
                    DB       $FF, +$07, +$52              ; draw, y, x 
                    DB       $FF, +$07, +$52              ; draw, y, x 
                    DB       $FF, +$40, +$49              ; draw, y, x 
                    DB       $FF, +$40, +$49              ; draw, y, x 
                    DB       $01, -$02, -$06              ; sync and move to y, x 
                    DB       $FF, +$19, -$5D              ; draw, y, x 
                    DB       $FF, +$19, -$5D              ; draw, y, x 
                    DB       $FF, -$2A, -$4C              ; draw, y, x 
                    DB       $FF, -$2A, -$4C              ; draw, y, x 
                    DB       $FF, +$5D, +$74              ; draw, y, x 
                    DB       $FF, +$23, -$74              ; draw, y, x 
                    DB       $FF, -$16, +$79              ; draw, y, x 
                    DB       $FF, +$70, -$2F              ; draw, y, x 
                    DB       $FF, -$74, +$4D              ; draw, y, x 
                    DB       $FF, -$1A, +$5E              ; draw, y, x 
                    DB       $FF, -$1A, +$5D              ; draw, y, x 
                    DB       $FF, +$5B, -$1A              ; draw, y, x 
                    DB       $FF, +$5C, -$1A              ; draw, y, x 
                    DB       $FF, +$40, -$7C              ; draw, y, x 
                    DB       $FF, -$23, +$79              ; draw, y, x 
                    DB       $FF, +$7A, -$17              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_21: 
                    DB       $01, +$7F, -$7F              ; sync and move to y, x 
                    DB       $00, +$7F, -$06              ; additional sync move to y, x 
                    DB       $00, +$38, +$00              ; additional sync move to y, x 
                    DB       $FF, -$67, +$3B              ; draw, y, x 
                    DB       $FF, +$65, +$4B              ; draw, y, x 
                    DB       $FF, -$7A, -$3D              ; draw, y, x 
                    DB       $FF, -$53, +$23              ; draw, y, x 
                    DB       $FF, -$52, +$23              ; draw, y, x 
                    DB       $FF, +$47, +$35              ; draw, y, x 
                    DB       $FF, +$47, +$36              ; draw, y, x 
                    DB       $FF, +$4C, -$02              ; draw, y, x 
                    DB       $FF, +$4D, -$01              ; draw, y, x 
                    DB       $FF, -$7F, +$14              ; draw, y, x 
                    DB       $FF, +$5B, +$54              ; draw, y, x 
                    DB       $FF, -$5F, -$41              ; draw, y, x 
                    DB       $FF, +$00, +$45              ; draw, y, x 
                    DB       $FF, +$01, +$45              ; draw, y, x 
                    DB       $FF, -$0E, -$4E              ; draw, y, x 
                    DB       $FF, -$0D, -$4E              ; draw, y, x 
                    DB       $FF, -$4A, -$39              ; draw, y, x 
                    DB       $FF, -$49, -$39              ; draw, y, x 
                    DB       $01, +$0C, +$15              ; sync and move to y, x 
                    DB       $FF, -$06, +$59              ; draw, y, x 
                    DB       $FF, -$06, +$5A              ; draw, y, x 
                    DB       $FF, +$52, +$7F              ; draw, y, x 
                    DB       $FF, -$55, -$5F              ; draw, y, x 
                    DB       $FF, -$04, +$74              ; draw, y, x 
                    DB       $FF, -$0F, -$65              ; draw, y, x 
                    DB       $FF, -$5F, +$38              ; draw, y, x 
                    DB       $FF, +$63, -$68              ; draw, y, x 
                    DB       $FF, +$08, -$5A              ; draw, y, x 
                    DB       $FF, +$07, -$5A              ; draw, y, x 
                    DB       $FF, -$42, +$20              ; draw, y, x 
                    DB       $FF, -$43, +$21              ; draw, y, x 
                    DB       $FF, -$1B, +$43              ; draw, y, x 
                    DB       $FF, -$1C, +$43              ; draw, y, x 
                    DB       $FF, +$17, -$74              ; draw, y, x 
                    DB       $FF, -$40, +$16              ; draw, y, x 
                    DB       $FF, -$40, +$17              ; draw, y, x 
                    DB       $01, -$7F, +$7F              ; sync and move to y, x 
                    DB       $00, -$7F, +$14              ; additional sync move to y, x 
                    DB       $00, -$2A, +$00              ; additional sync move to y, x 
                    DB       $FF, +$76, -$3E              ; draw, y, x 
                    DB       $FF, -$6E, -$3A              ; draw, y, x 
                    DB       $FF, +$48, +$13              ; draw, y, x 
                    DB       $FF, +$48, +$13              ; draw, y, x 
                    DB       $FF, +$43, -$1F              ; draw, y, x 
                    DB       $FF, +$42, -$1F              ; draw, y, x 
                    DB       $FF, -$4B, -$3A              ; draw, y, x 
                    DB       $FF, -$4B, -$3B              ; draw, y, x 
                    DB       $FF, -$78, +$0F              ; draw, y, x 
                    DB       $FF, +$68, -$1B              ; draw, y, x 
                    DB       $FF, -$71, -$63              ; draw, y, x 
                    DB       $FF, +$7A, +$46              ; draw, y, x 
                    DB       $FF, -$0C, -$42              ; draw, y, x 
                    DB       $FF, -$0C, -$43              ; draw, y, x 
                    DB       $FF, +$16, +$4F              ; draw, y, x 
                    DB       $FF, +$15, +$4F              ; draw, y, x 
                    DB       $FF, +$4A, +$3F              ; draw, y, x 
                    DB       $FF, +$49, +$3E              ; draw, y, x 
                    DB       $01, -$02, -$05              ; sync and move to y, x 
                    DB       $FF, +$06, -$5F              ; draw, y, x 
                    DB       $FF, +$06, -$5F              ; draw, y, x 
                    DB       $FF, -$35, -$44              ; draw, y, x 
                    DB       $FF, -$35, -$45              ; draw, y, x 
                    DB       $FF, +$6B, +$65              ; draw, y, x 
                    DB       $FF, +$0C, -$78              ; draw, y, x 
                    DB       $FF, +$02, +$7B              ; draw, y, x 
                    DB       $FF, +$5F, -$3F              ; draw, y, x 
                    DB       $FF, -$5E, +$5D              ; draw, y, x 
                    DB       $FF, -$07, +$5F              ; draw, y, x 
                    DB       $FF, -$07, +$5F              ; draw, y, x 
                    DB       $FF, +$51, -$26              ; draw, y, x 
                    DB       $FF, +$51, -$27              ; draw, y, x 
                    DB       $FF, +$12, -$41              ; draw, y, x 
                    DB       $FF, +$12, -$42              ; draw, y, x 
                    DB       $FF, -$0A, +$7B              ; draw, y, x 
                    DB       $FF, +$6E, -$28              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_22: 
                    DB       $01, +$7F, -$7F              ; sync and move to y, x 
                    DB       $00, +$7F, -$28              ; additional sync move to y, x 
                    DB       $00, +$03, +$00              ; additional sync move to y, x 
                    DB       $FF, -$52, +$47              ; draw, y, x 
                    DB       $FF, +$6C, +$3B              ; draw, y, x 
                    DB       $FF, -$7C, -$2C              ; draw, y, x 
                    DB       $FF, -$45, +$2C              ; draw, y, x 
                    DB       $FF, -$45, +$2C              ; draw, y, x 
                    DB       $FF, +$4C, +$2B              ; draw, y, x 
                    DB       $FF, +$4C, +$2B              ; draw, y, x 
                    DB       $FF, +$45, -$0B              ; draw, y, x 
                    DB       $FF, +$46, -$0B              ; draw, y, x 
                    DB       $FF, -$70, +$23              ; draw, y, x 
                    DB       $FF, +$65, +$46              ; draw, y, x 
                    DB       $FF, -$64, -$33              ; draw, y, x 
                    DB       $FF, +$0E, +$42              ; draw, y, x 
                    DB       $FF, +$0E, +$43              ; draw, y, x 
                    DB       $FF, -$1C, -$4A              ; draw, y, x 
                    DB       $FF, -$1C, -$4A              ; draw, y, x 
                    DB       $FF, -$4F, -$2E              ; draw, y, x 
                    DB       $FF, -$4F, -$2D              ; draw, y, x 
                    DB       $01, +$0F, +$13              ; sync and move to y, x 
                    DB       $FF, +$0C, +$57              ; draw, y, x 
                    DB       $FF, +$0D, +$57              ; draw, y, x 
                    DB       $FF, +$65, +$71              ; draw, y, x 
                    DB       $FF, -$62, -$52              ; draw, y, x 
                    DB       $FF, +$14, +$70              ; draw, y, x 
                    DB       $FF, -$22, -$5F              ; draw, y, x 
                    DB       $FF, -$4C, +$42              ; draw, y, x 
                    DB       $FF, +$46, -$71              ; draw, y, x 
                    DB       $FF, -$0B, -$58              ; draw, y, x 
                    DB       $FF, -$0B, -$57              ; draw, y, x 
                    DB       $FF, -$6D, +$4E              ; draw, y, x 
                    DB       $FF, -$0C, +$44              ; draw, y, x 
                    DB       $FF, -$0C, +$45              ; draw, y, x 
                    DB       $FF, -$01, -$73              ; draw, y, x 
                    DB       $FF, -$6D, +$3B              ; draw, y, x 
                    DB       $01, -$7F, +$7F              ; sync and move to y, x 
                    DB       $00, -$73, +$33              ; additional sync move to y, x 
                    DB       $FF, +$60, -$4A              ; draw, y, x 
                    DB       $FF, -$71, -$2B              ; draw, y, x 
                    DB       $FF, +$46, +$0A              ; draw, y, x 
                    DB       $FF, +$46, +$0A              ; draw, y, x 
                    DB       $FF, +$6E, -$4D              ; draw, y, x 
                    DB       $FF, -$51, -$2F              ; draw, y, x 
                    DB       $FF, -$51, -$2F              ; draw, y, x 
                    DB       $FF, -$6A, +$1D              ; draw, y, x 
                    DB       $FF, +$59, -$27              ; draw, y, x 
                    DB       $FF, -$7A, -$51              ; draw, y, x 
                    DB       $FF, +$7D, +$34              ; draw, y, x 
                    DB       $FF, -$31, -$7E              ; draw, y, x 
                    DB       $FF, +$24, +$4A              ; draw, y, x 
                    DB       $FF, +$23, +$4A              ; draw, y, x 
                    DB       $FF, +$50, +$33              ; draw, y, x 
                    DB       $FF, +$50, +$33              ; draw, y, x 
                    DB       $01, -$03, -$05              ; sync and move to y, x 
                    DB       $FF, -$0D, -$5C              ; draw, y, x 
                    DB       $FF, -$0E, -$5D              ; draw, y, x 
                    DB       $FF, -$7C, -$76              ; draw, y, x 
                    DB       $FF, +$76, +$54              ; draw, y, x 
                    DB       $FF, -$0D, -$75              ; draw, y, x 
                    DB       $FF, +$1A, +$76              ; draw, y, x 
                    DB       $FF, +$4B, -$49              ; draw, y, x 
                    DB       $FF, -$44, +$65              ; draw, y, x 
                    DB       $FF, +$0D, +$5D              ; draw, y, x 
                    DB       $FF, +$0D, +$5D              ; draw, y, x 
                    DB       $FF, +$42, -$2F              ; draw, y, x 
                    DB       $FF, +$42, -$2F              ; draw, y, x 
                    DB       $FF, +$04, -$41              ; draw, y, x 
                    DB       $FF, +$04, -$42              ; draw, y, x 
                    DB       $FF, +$0F, +$78              ; draw, y, x 
                    DB       $FF, +$5C, -$35              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_23: 
                    DB       $01, +$7F, -$7F              ; sync and move to y, x 
                    DB       $00, +$46, -$36              ; additional sync move to y, x 
                    DB       $FF, -$3B, +$4A              ; draw, y, x 
                    DB       $FF, +$6F, +$2E              ; draw, y, x 
                    DB       $FF, -$7B, -$1E              ; draw, y, x 
                    DB       $FF, -$35, +$30              ; draw, y, x 
                    DB       $FF, -$34, +$30              ; draw, y, x 
                    DB       $FF, +$4E, +$21              ; draw, y, x 
                    DB       $FF, +$4F, +$21              ; draw, y, x 
                    DB       $FF, +$7A, -$22              ; draw, y, x 
                    DB       $FF, -$5F, +$2B              ; draw, y, x 
                    DB       $FF, +$6B, +$38              ; draw, y, x 
                    DB       $FF, -$66, -$26              ; draw, y, x 
                    DB       $FF, +$37, +$7A              ; draw, y, x 
                    DB       $FF, -$2A, -$43              ; draw, y, x 
                    DB       $FF, -$2A, -$42              ; draw, y, x 
                    DB       $FF, -$52, -$24              ; draw, y, x 
                    DB       $FF, -$51, -$23              ; draw, y, x 
                    DB       $01, +$12, +$10              ; sync and move to y, x 
                    DB       $FF, +$1E, +$50              ; draw, y, x 
                    DB       $FF, +$1F, +$50              ; draw, y, x 
                    DB       $FF, +$74, +$61              ; draw, y, x 
                    DB       $FF, -$6A, -$43              ; draw, y, x 
                    DB       $FF, +$2B, +$67              ; draw, y, x 
                    DB       $FF, -$34, -$56              ; draw, y, x 
                    DB       $FF, -$37, +$44              ; draw, y, x 
                    DB       $FF, +$27, -$6F              ; draw, y, x 
                    DB       $FF, -$1E, -$51              ; draw, y, x 
                    DB       $FF, -$1D, -$51              ; draw, y, x 
                    DB       $FF, -$52, +$53              ; draw, y, x 
                    DB       $FF, +$05, +$41              ; draw, y, x 
                    DB       $FF, +$04, +$42              ; draw, y, x 
                    DB       $FF, -$1B, -$6C              ; draw, y, x 
                    DB       $FF, -$55, +$42              ; draw, y, x 
                    DB       $01, -$7F, +$7F              ; sync and move to y, x 
                    DB       $00, -$35, +$3F              ; additional sync move to y, x 
                    DB       $FF, +$46, -$4F              ; draw, y, x 
                    DB       $FF, -$6F, -$1D              ; draw, y, x 
                    DB       $FF, +$41, +$02              ; draw, y, x 
                    DB       $FF, +$41, +$03              ; draw, y, x 
                    DB       $FF, +$53, -$52              ; draw, y, x 
                    DB       $FF, -$53, -$24              ; draw, y, x 
                    DB       $FF, -$54, -$25              ; draw, y, x 
                    DB       $FF, -$5B, +$25              ; draw, y, x 
                    DB       $FF, +$49, -$2D              ; draw, y, x 
                    DB       $FF, -$40, -$20              ; draw, y, x 
                    DB       $FF, -$41, -$20              ; draw, y, x 
                    DB       $FF, +$7E, +$25              ; draw, y, x 
                    DB       $FF, -$49, -$71              ; draw, y, x 
                    DB       $FF, +$31, +$42              ; draw, y, x 
                    DB       $FF, +$31, +$41              ; draw, y, x 
                    DB       $FF, +$54, +$29              ; draw, y, x 
                    DB       $FF, +$53, +$28              ; draw, y, x 
                    DB       $01, -$04, -$04              ; sync and move to y, x 
                    DB       $FF, -$20, -$55              ; draw, y, x 
                    DB       $FF, -$21, -$56              ; draw, y, x 
                    DB       $FF, -$45, -$31              ; draw, y, x 
                    DB       $FF, -$46, -$32              ; draw, y, x 
                    DB       $FF, +$7E, +$43              ; draw, y, x 
                    DB       $FF, -$26, -$6C              ; draw, y, x 
                    DB       $FF, +$32, +$6C              ; draw, y, x 
                    DB       $FF, +$34, -$4B              ; draw, y, x 
                    DB       $FF, -$27, +$65              ; draw, y, x 
                    DB       $FF, +$20, +$56              ; draw, y, x 
                    DB       $FF, +$20, +$56              ; draw, y, x 
                    DB       $FF, +$31, -$32              ; draw, y, x 
                    DB       $FF, +$32, -$33              ; draw, y, x 
                    DB       $FF, -$16, -$7B              ; draw, y, x 
                    DB       $FF, +$29, +$6F              ; draw, y, x 
                    DB       $FF, +$48, -$3B              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_24: 
                    DB       $01, +$7F, -$7F              ; sync and move to y, x 
                    DB       $00, +$09, -$2E              ; additional sync move to y, x 
                    DB       $FF, -$25, +$45              ; draw, y, x 
                    DB       $FF, +$71, +$21              ; draw, y, x 
                    DB       $FF, -$77, -$12              ; draw, y, x 
                    DB       $FF, -$25, +$2E              ; draw, y, x 
                    DB       $FF, -$24, +$2E              ; draw, y, x 
                    DB       $FF, +$4F, +$18              ; draw, y, x 
                    DB       $FF, +$50, +$18              ; draw, y, x 
                    DB       $FF, +$66, -$26              ; draw, y, x 
                    DB       $FF, -$4B, +$2D              ; draw, y, x 
                    DB       $FF, +$6F, +$2A              ; draw, y, x 
                    DB       $FF, -$66, -$1B              ; draw, y, x 
                    DB       $FF, +$4F, +$69              ; draw, y, x 
                    DB       $FF, -$6C, -$71              ; draw, y, x 
                    DB       $FF, -$53, -$1A              ; draw, y, x 
                    DB       $FF, -$53, -$1A              ; draw, y, x 
                    DB       $01, +$14, +$0D              ; sync and move to y, x 
                    DB       $FF, +$2F, +$45              ; draw, y, x 
                    DB       $FF, +$30, +$45              ; draw, y, x 
                    DB       $FF, +$40, +$27              ; draw, y, x 
                    DB       $FF, +$41, +$27              ; draw, y, x 
                    DB       $FF, -$71, -$34              ; draw, y, x 
                    DB       $FF, +$3F, +$58              ; draw, y, x 
                    DB       $FF, -$44, -$48              ; draw, y, x 
                    DB       $FF, -$21, +$40              ; draw, y, x 
                    DB       $FF, +$09, -$66              ; draw, y, x 
                    DB       $FF, -$2F, -$46              ; draw, y, x 
                    DB       $FF, -$2E, -$46              ; draw, y, x 
                    DB       $FF, -$1B, +$28              ; draw, y, x 
                    DB       $FF, -$1B, +$28              ; draw, y, x 
                    DB       $FF, +$27, +$73              ; draw, y, x 
                    DB       $FF, -$32, -$5D              ; draw, y, x 
                    DB       $FF, -$3E, +$3F              ; draw, y, x 
                    DB       $01, -$76, +$7F              ; sync and move to y, x 
                    DB       $00, +$00, +$35              ; additional sync move to y, x 
                    DB       $FF, +$2D, -$4A              ; draw, y, x 
                    DB       $FF, -$6D, -$12              ; draw, y, x 
                    DB       $FF, +$78, -$05              ; draw, y, x 
                    DB       $FF, +$1C, -$27              ; draw, y, x 
                    DB       $FF, +$1C, -$27              ; draw, y, x 
                    DB       $FF, -$55, -$1A              ; draw, y, x 
                    DB       $FF, -$55, -$1B              ; draw, y, x 
                    DB       $FF, -$49, +$26              ; draw, y, x 
                    DB       $FF, +$37, -$2C              ; draw, y, x 
                    DB       $FF, -$42, -$18              ; draw, y, x 
                    DB       $FF, -$43, -$19              ; draw, y, x 
                    DB       $FF, +$7C, +$19              ; draw, y, x 
                    DB       $FF, -$5E, -$60              ; draw, y, x 
                    DB       $FF, +$78, +$6E              ; draw, y, x 
                    DB       $FF, +$56, +$1E              ; draw, y, x 
                    DB       $FF, +$56, +$1E              ; draw, y, x 
                    DB       $01, -$05, -$04              ; sync and move to y, x 
                    DB       $FF, -$32, -$49              ; draw, y, x 
                    DB       $FF, -$32, -$49              ; draw, y, x 
                    DB       $FF, -$4B, -$27              ; draw, y, x 
                    DB       $FF, -$4C, -$28              ; draw, y, x 
                    DB       $FF, +$42, +$1A              ; draw, y, x 
                    DB       $FF, +$41, +$19              ; draw, y, x 
                    DB       $FF, -$3C, -$5D              ; draw, y, x 
                    DB       $FF, +$47, +$5C              ; draw, y, x 
                    DB       $FF, +$1D, -$46              ; draw, y, x 
                    DB       $FF, -$0B, +$5C              ; draw, y, x 
                    DB       $FF, +$32, +$4A              ; draw, y, x 
                    DB       $FF, +$32, +$4A              ; draw, y, x 
                    DB       $FF, +$21, -$30              ; draw, y, x 
                    DB       $FF, +$21, -$30              ; draw, y, x 
                    DB       $FF, -$32, -$6C              ; draw, y, x 
                    DB       $FF, +$40, +$60              ; draw, y, x 
                    DB       $FF, +$34, -$38              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_25: 
                    DB       $01, +$50, -$7F              ; sync and move to y, x 
                    DB       $00, +$00, -$13              ; additional sync move to y, x 
                    DB       $FF, -$0F, +$3A              ; draw, y, x 
                    DB       $FF, +$70, +$16              ; draw, y, x 
                    DB       $FF, -$72, -$0A              ; draw, y, x 
                    DB       $FF, -$16, +$27              ; draw, y, x 
                    DB       $FF, -$16, +$27              ; draw, y, x 
                    DB       $FF, +$4F, +$10              ; draw, y, x 
                    DB       $FF, +$50, +$10              ; draw, y, x 
                    DB       $FF, +$2A, -$12              ; draw, y, x 
                    DB       $FF, +$2A, -$11              ; draw, y, x 
                    DB       $FF, -$39, +$28              ; draw, y, x 
                    DB       $FF, +$70, +$1D              ; draw, y, x 
                    DB       $FF, -$65, -$11              ; draw, y, x 
                    DB       $FF, +$64, +$51              ; draw, y, x 
                    DB       $FF, -$40, -$2C              ; draw, y, x 
                    DB       $FF, -$40, -$2B              ; draw, y, x 
                    DB       $FF, -$53, -$12              ; draw, y, x 
                    DB       $FF, -$53, -$11              ; draw, y, x 
                    DB       $01, +$16, +$0A              ; sync and move to y, x 
                    DB       $FF, +$7A, +$6C              ; draw, y, x 
                    DB       $FF, +$45, +$1D              ; draw, y, x 
                    DB       $FF, +$46, +$1D              ; draw, y, x 
                    DB       $FF, -$75, -$26              ; draw, y, x 
                    DB       $FF, +$51, +$45              ; draw, y, x 
                    DB       $FF, -$51, -$38              ; draw, y, x 
                    DB       $FF, -$0E, +$36              ; draw, y, x 
                    DB       $FF, -$0A, -$2A              ; draw, y, x 
                    DB       $FF, -$09, -$29              ; draw, y, x 
                    DB       $FF, -$79, -$6E              ; draw, y, x 
                    DB       $FF, -$0E, +$21              ; draw, y, x 
                    DB       $FF, -$0F, +$22              ; draw, y, x 
                    DB       $FF, +$41, +$5C              ; draw, y, x 
                    DB       $FF, -$46, -$4A              ; draw, y, x 
                    DB       $FF, -$14, +$1B              ; draw, y, x 
                    DB       $FF, -$15, +$1B              ; draw, y, x 
                    DB       $01, -$3F, +$7F              ; sync and move to y, x 
                    DB       $00, +$00, +$18              ; additional sync move to y, x 
                    DB       $FF, +$0C, -$1F              ; draw, y, x 
                    DB       $FF, +$0B, -$1F              ; draw, y, x 
                    DB       $FF, -$69, -$0B              ; draw, y, x 
                    DB       $FF, +$6E, -$08              ; draw, y, x 
                    DB       $FF, +$10, -$21              ; draw, y, x 
                    DB       $FF, +$0F, -$21              ; draw, y, x 
                    DB       $FF, -$55, -$12              ; draw, y, x 
                    DB       $FF, -$55, -$12              ; draw, y, x 
                    DB       $FF, -$3A, +$22              ; draw, y, x 
                    DB       $FF, +$28, -$26              ; draw, y, x 
                    DB       $FF, -$43, -$11              ; draw, y, x 
                    DB       $FF, -$44, -$11              ; draw, y, x 
                    DB       $FF, +$78, +$0F              ; draw, y, x 
                    DB       $FF, -$6F, -$4A              ; draw, y, x 
                    DB       $FF, +$46, +$2A              ; draw, y, x 
                    DB       $FF, +$45, +$2A              ; draw, y, x 
                    DB       $FF, +$57, +$15              ; draw, y, x 
                    DB       $FF, +$57, +$15              ; draw, y, x 
                    DB       $01, -$05, -$03              ; sync and move to y, x 
                    DB       $FF, -$41, -$39              ; draw, y, x 
                    DB       $FF, -$42, -$3A              ; draw, y, x 
                    DB       $FF, -$4F, -$1D              ; draw, y, x 
                    DB       $FF, -$4F, -$1D              ; draw, y, x 
                    DB       $FF, +$43, +$13              ; draw, y, x 
                    DB       $FF, +$43, +$12              ; draw, y, x 
                    DB       $FF, -$50, -$4A              ; draw, y, x 
                    DB       $FF, +$59, +$48              ; draw, y, x 
                    DB       $FF, +$09, -$3A              ; draw, y, x 
                    DB       $FF, +$0E, +$4C              ; draw, y, x 
                    DB       $FF, +$41, +$3A              ; draw, y, x 
                    DB       $FF, +$40, +$3A              ; draw, y, x 
                    DB       $FF, +$12, -$28              ; draw, y, x 
                    DB       $FF, +$13, -$29              ; draw, y, x 
                    DB       $FF, -$4A, -$55              ; draw, y, x 
                    DB       $FF, +$53, +$4B              ; draw, y, x 
                    DB       $FF, +$21, -$30              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_26: 
                    DB       $01, +$25, -$66              ; sync and move to y, x 
                    DB       $FF, +$01, +$28              ; draw, y, x 
                    DB       $FF, +$6F, +$0D              ; draw, y, x 
                    DB       $FF, -$6E, -$04              ; draw, y, x 
                    DB       $FF, -$0A, +$1B              ; draw, y, x 
                    DB       $FF, -$0A, +$1B              ; draw, y, x 
                    DB       $FF, +$4E, +$09              ; draw, y, x 
                    DB       $FF, +$4F, +$0A              ; draw, y, x 
                    DB       $FF, +$23, -$0D              ; draw, y, x 
                    DB       $FF, +$23, -$0C              ; draw, y, x 
                    DB       $FF, -$16, +$0E              ; draw, y, x 
                    DB       $FF, -$16, +$0E              ; draw, y, x 
                    DB       $FF, +$72, +$12              ; draw, y, x 
                    DB       $FF, -$64, -$0A              ; draw, y, x 
                    DB       $FF, +$74, +$36              ; draw, y, x 
                    DB       $FF, -$48, -$1D              ; draw, y, x 
                    DB       $FF, -$48, -$1C              ; draw, y, x 
                    DB       $FF, -$53, -$0B              ; draw, y, x 
                    DB       $FF, -$52, -$0B              ; draw, y, x 
                    DB       $01, +$17, +$06              ; sync and move to y, x 
                    DB       $FF, +$47, +$24              ; draw, y, x 
                    DB       $FF, +$48, +$24              ; draw, y, x 
                    DB       $FF, +$49, +$13              ; draw, y, x 
                    DB       $FF, +$49, +$13              ; draw, y, x 
                    DB       $FF, -$78, -$18              ; draw, y, x 
                    DB       $FF, +$5E, +$2E              ; draw, y, x 
                    DB       $FF, -$5B, -$25              ; draw, y, x 
                    DB       $FF, +$01, +$25              ; draw, y, x 
                    DB       $FF, -$14, -$1D              ; draw, y, x 
                    DB       $FF, -$13, -$1C              ; draw, y, x 
                    DB       $FF, -$48, -$25              ; draw, y, x 
                    DB       $FF, -$47, -$24              ; draw, y, x 
                    DB       $FF, -$05, +$17              ; draw, y, x 
                    DB       $FF, -$05, +$18              ; draw, y, x 
                    DB       $FF, +$56, +$3D              ; draw, y, x 
                    DB       $FF, -$55, -$31              ; draw, y, x 
                    DB       $FF, -$0C, +$13              ; draw, y, x 
                    DB       $FF, -$0D, +$13              ; draw, y, x 
                    DB       $01, -$14, +$69              ; sync and move to y, x 
                    DB       $FF, +$03, -$16              ; draw, y, x 
                    DB       $FF, +$02, -$15              ; draw, y, x 
                    DB       $FF, -$65, -$06              ; draw, y, x 
                    DB       $FF, +$65, -$07              ; draw, y, x 
                    DB       $FF, +$06, -$17              ; draw, y, x 
                    DB       $FF, +$06, -$17              ; draw, y, x 
                    DB       $FF, -$54, -$0B              ; draw, y, x 
                    DB       $FF, -$55, -$0B              ; draw, y, x 
                    DB       $FF, -$2D, +$19              ; draw, y, x 
                    DB       $FF, +$1B, -$1B              ; draw, y, x 
                    DB       $FF, -$44, -$0A              ; draw, y, x 
                    DB       $FF, -$44, -$0B              ; draw, y, x 
                    DB       $FF, +$75, +$08              ; draw, y, x 
                    DB       $FF, -$7B, -$31              ; draw, y, x 
                    DB       $FF, +$4C, +$1C              ; draw, y, x 
                    DB       $FF, +$4C, +$1B              ; draw, y, x 
                    DB       $FF, +$57, +$0D              ; draw, y, x 
                    DB       $FF, +$57, +$0D              ; draw, y, x 
                    DB       $01, -$06, -$02              ; sync and move to y, x 
                    DB       $FF, -$4C, -$26              ; draw, y, x 
                    DB       $FF, -$4C, -$26              ; draw, y, x 
                    DB       $FF, -$52, -$12              ; draw, y, x 
                    DB       $FF, -$52, -$13              ; draw, y, x 
                    DB       $FF, +$44, +$0B              ; draw, y, x 
                    DB       $FF, +$43, +$0B              ; draw, y, x 
                    DB       $FF, -$5E, -$31              ; draw, y, x 
                    DB       $FF, +$67, +$30              ; draw, y, x 
                    DB       $FF, -$07, -$28              ; draw, y, x 
                    DB       $FF, +$10, +$1A              ; draw, y, x 
                    DB       $FF, +$10, +$1A              ; draw, y, x 
                    DB       $FF, +$4C, +$27              ; draw, y, x 
                    DB       $FF, +$4C, +$26              ; draw, y, x 
                    DB       $FF, +$06, -$1C              ; draw, y, x 
                    DB       $FF, +$07, -$1C              ; draw, y, x 
                    DB       $FF, -$5B, -$39              ; draw, y, x 
                    DB       $FF, +$62, +$32              ; draw, y, x 
                    DB       $FF, +$12, -$22              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_27: 
                    DB       $01, +$0C, -$2E              ; sync and move to y, x 
                    DB       $FF, +$05, +$09              ; draw, y, x 
                    DB       $FF, +$05, +$09              ; draw, y, x 
                    DB       $FF, +$6E, +$05              ; draw, y, x 
                    DB       $FF, -$6B, -$01              ; draw, y, x 
                    DB       $FF, -$04, +$0C              ; draw, y, x 
                    DB       $FF, -$03, +$0C              ; draw, y, x 
                    DB       $FF, +$4E, +$04              ; draw, y, x 
                    DB       $FF, +$4E, +$04              ; draw, y, x 
                    DB       $FF, +$1F, -$06              ; draw, y, x 
                    DB       $FF, +$1F, -$06              ; draw, y, x 
                    DB       $FF, -$12, +$06              ; draw, y, x 
                    DB       $FF, -$12, +$07              ; draw, y, x 
                    DB       $FF, +$72, +$08              ; draw, y, x 
                    DB       $FF, -$62, -$04              ; draw, y, x 
                    DB       $FF, +$7C, +$18              ; draw, y, x 
                    DB       $FF, -$4C, -$0D              ; draw, y, x 
                    DB       $FF, -$4C, -$0C              ; draw, y, x 
                    DB       $FF, -$52, -$05              ; draw, y, x 
                    DB       $FF, -$52, -$04              ; draw, y, x 
                    DB       $01, +$18, +$03              ; sync and move to y, x 
                    DB       $FF, +$4D, +$0F              ; draw, y, x 
                    DB       $FF, +$4E, +$10              ; draw, y, x 
                    DB       $FF, +$4A, +$08              ; draw, y, x 
                    DB       $FF, +$4B, +$08              ; draw, y, x 
                    DB       $FF, -$79, -$0A              ; draw, y, x 
                    DB       $FF, +$66, +$15              ; draw, y, x 
                    DB       $FF, -$61, -$11              ; draw, y, x 
                    DB       $FF, +$0A, +$11              ; draw, y, x 
                    DB       $FF, -$1A, -$0D              ; draw, y, x 
                    DB       $FF, -$19, -$0C              ; draw, y, x 
                    DB       $FF, -$4E, -$10              ; draw, y, x 
                    DB       $FF, -$4D, -$10              ; draw, y, x 
                    DB       $FF, +$00, +$0A              ; draw, y, x 
                    DB       $FF, +$01, +$0A              ; draw, y, x 
                    DB       $FF, +$61, +$1C              ; draw, y, x 
                    DB       $FF, -$5E, -$16              ; draw, y, x 
                    DB       $FF, -$07, +$08              ; draw, y, x 
                    DB       $FF, -$07, +$09              ; draw, y, x 
                    DB       $01, +$06, +$2F              ; sync and move to y, x 
                    DB       $FF, -$03, -$0A              ; draw, y, x 
                    DB       $FF, -$03, -$09              ; draw, y, x 
                    DB       $FF, -$62, -$02              ; draw, y, x 
                    DB       $FF, +$5F, -$04              ; draw, y, x 
                    DB       $FF, +$01, -$0B              ; draw, y, x 
                    DB       $FF, +$00, -$0A              ; draw, y, x 
                    DB       $FF, -$54, -$04              ; draw, y, x 
                    DB       $FF, -$54, -$05              ; draw, y, x 
                    DB       $FF, -$26, +$0C              ; draw, y, x 
                    DB       $FF, +$14, -$0D              ; draw, y, x 
                    DB       $FF, -$44, -$04              ; draw, y, x 
                    DB       $FF, -$44, -$04              ; draw, y, x 
                    DB       $FF, +$72, +$03              ; draw, y, x 
                    DB       $FF, -$41, -$0B              ; draw, y, x 
                    DB       $FF, -$41, -$0B              ; draw, y, x 
                    DB       $FF, +$50, +$0C              ; draw, y, x 
                    DB       $FF, +$50, +$0C              ; draw, y, x 
                    DB       $FF, +$57, +$06              ; draw, y, x 
                    DB       $FF, +$57, +$05              ; draw, y, x 
                    DB       $01, -$06, -$01              ; sync and move to y, x 
                    DB       $FF, -$52, -$10              ; draw, y, x 
                    DB       $FF, -$53, -$11              ; draw, y, x 
                    DB       $FF, -$53, -$08              ; draw, y, x 
                    DB       $FF, -$54, -$08              ; draw, y, x 
                    DB       $FF, +$44, +$05              ; draw, y, x 
                    DB       $FF, +$44, +$04              ; draw, y, x 
                    DB       $FF, -$67, -$15              ; draw, y, x 
                    DB       $FF, +$6F, +$15              ; draw, y, x 
                    DB       $FF, -$10, -$12              ; draw, y, x 
                    DB       $FF, +$16, +$0C              ; draw, y, x 
                    DB       $FF, +$15, +$0B              ; draw, y, x 
                    DB       $FF, +$53, +$11              ; draw, y, x 
                    DB       $FF, +$52, +$11              ; draw, y, x 
                    DB       $FF, +$00, -$0C              ; draw, y, x 
                    DB       $FF, -$01, -$0D              ; draw, y, x 
                    DB       $FF, -$65, -$1A              ; draw, y, x 
                    DB       $FF, +$6A, +$16              ; draw, y, x 
                    DB       $FF, +$0A, -$0F              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_28: 
                    DB       $01, +$07, +$0F              ; sync and move to y, x 
                    DB       $FF, +$05, -$03              ; draw, y, x 
                    DB       $FF, +$06, -$03              ; draw, y, x 
                    DB       $FF, +$6E, -$01              ; draw, y, x 
                    DB       $FF, -$6A, +$00              ; draw, y, x 
                    DB       $FF, -$02, -$04              ; draw, y, x 
                    DB       $FF, -$02, -$04              ; draw, y, x 
                    DB       $FF, +$4E, -$01              ; draw, y, x 
                    DB       $FF, +$4E, -$02              ; draw, y, x 
                    DB       $FF, +$1E, +$02              ; draw, y, x 
                    DB       $FF, +$1E, +$02              ; draw, y, x 
                    DB       $FF, -$11, -$02              ; draw, y, x 
                    DB       $FF, -$11, -$02              ; draw, y, x 
                    DB       $FF, +$72, -$03              ; draw, y, x 
                    DB       $FF, -$62, +$02              ; draw, y, x 
                    DB       $FF, +$7E, -$08              ; draw, y, x 
                    DB       $FF, -$4D, +$04              ; draw, y, x 
                    DB       $FF, -$4D, +$04              ; draw, y, x 
                    DB       $FF, -$52, +$02              ; draw, y, x 
                    DB       $FF, -$52, +$01              ; draw, y, x 
                    DB       $01, +$18, -$01              ; sync and move to y, x 
                    DB       $FF, +$4F, -$05              ; draw, y, x 
                    DB       $FF, +$4F, -$06              ; draw, y, x 
                    DB       $FF, +$4B, -$02              ; draw, y, x 
                    DB       $FF, +$4B, -$03              ; draw, y, x 
                    DB       $FF, -$7A, +$04              ; draw, y, x 
                    DB       $FF, +$67, -$07              ; draw, y, x 
                    DB       $FF, -$61, +$05              ; draw, y, x 
                    DB       $FF, +$0B, -$05              ; draw, y, x 
                    DB       $FF, -$1B, +$04              ; draw, y, x 
                    DB       $FF, -$1A, +$04              ; draw, y, x 
                    DB       $FF, -$4F, +$06              ; draw, y, x 
                    DB       $FF, -$4F, +$05              ; draw, y, x 
                    DB       $FF, +$02, -$03              ; draw, y, x 
                    DB       $FF, +$02, -$04              ; draw, y, x 
                    DB       $FF, +$63, -$09              ; draw, y, x 
                    DB       $FF, -$5F, +$07              ; draw, y, x 
                    DB       $FF, -$07, -$03              ; draw, y, x 
                    DB       $FF, -$06, -$03              ; draw, y, x 
                    DB       $01, +$0B, -$10              ; sync and move to y, x 
                    DB       $FF, -$04, +$04              ; draw, y, x 
                    DB       $FF, -$03, +$03              ; draw, y, x 
                    DB       $FF, -$62, +$00              ; draw, y, x 
                    DB       $FF, +$5E, +$02              ; draw, y, x 
                    DB       $FF, -$01, +$04              ; draw, y, x 
                    DB       $FF, -$01, +$03              ; draw, y, x 
                    DB       $FF, -$54, +$01              ; draw, y, x 
                    DB       $FF, -$54, +$02              ; draw, y, x 
                    DB       $FF, -$24, -$04              ; draw, y, x 
                    DB       $FF, +$12, +$04              ; draw, y, x 
                    DB       $FF, -$44, +$01              ; draw, y, x 
                    DB       $FF, -$44, +$02              ; draw, y, x 
                    DB       $FF, +$72, -$01              ; draw, y, x 
                    DB       $FF, -$42, +$03              ; draw, y, x 
                    DB       $FF, -$42, +$04              ; draw, y, x 
                    DB       $FF, +$51, -$04              ; draw, y, x 
                    DB       $FF, +$51, -$04              ; draw, y, x 
                    DB       $FF, +$57, -$02              ; draw, y, x 
                    DB       $FF, +$57, -$02              ; draw, y, x 
                    DB       $01, -$06, +$00              ; sync and move to y, x 
                    DB       $FF, -$54, +$06              ; draw, y, x 
                    DB       $FF, -$54, +$06              ; draw, y, x 
                    DB       $FF, -$54, +$02              ; draw, y, x 
                    DB       $FF, -$54, +$03              ; draw, y, x 
                    DB       $FF, +$44, -$02              ; draw, y, x 
                    DB       $FF, +$44, -$01              ; draw, y, x 
                    DB       $FF, -$67, +$07              ; draw, y, x 
                    DB       $FF, +$6F, -$07              ; draw, y, x 
                    DB       $FF, -$11, +$06              ; draw, y, x 
                    DB       $FF, +$17, -$04              ; draw, y, x 
                    DB       $FF, +$16, -$04              ; draw, y, x 
                    DB       $FF, +$54, -$06              ; draw, y, x 
                    DB       $FF, +$54, -$05              ; draw, y, x 
                    DB       $FF, -$02, +$04              ; draw, y, x 
                    DB       $FF, -$02, +$04              ; draw, y, x 
                    DB       $FF, -$67, +$09              ; draw, y, x 
                    DB       $FF, +$6B, -$08              ; draw, y, x 
                    DB       $FF, +$04, +$02              ; draw, y, x 
                    DB       $FF, +$05, +$03              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_29: 
                    DB       $01, +$16, +$4B              ; sync and move to y, x 
                    DB       $FF, +$06, -$1D              ; draw, y, x 
                    DB       $FF, +$6F, -$0A              ; draw, y, x 
                    DB       $FF, -$6C, +$03              ; draw, y, x 
                    DB       $FF, -$07, -$14              ; draw, y, x 
                    DB       $FF, -$06, -$13              ; draw, y, x 
                    DB       $FF, +$4E, -$07              ; draw, y, x 
                    DB       $FF, +$4F, -$07              ; draw, y, x 
                    DB       $FF, +$20, +$0A              ; draw, y, x 
                    DB       $FF, +$21, +$09              ; draw, y, x 
                    DB       $FF, -$14, -$0A              ; draw, y, x 
                    DB       $FF, -$13, -$0B              ; draw, y, x 
                    DB       $FF, +$72, -$0D              ; draw, y, x 
                    DB       $FF, -$63, +$07              ; draw, y, x 
                    DB       $FF, +$79, -$27              ; draw, y, x 
                    DB       $FF, -$4B, +$15              ; draw, y, x 
                    DB       $FF, -$4A, +$15              ; draw, y, x 
                    DB       $FF, -$52, +$07              ; draw, y, x 
                    DB       $FF, -$52, +$07              ; draw, y, x 
                    DB       $01, +$18, -$05              ; sync and move to y, x 
                    DB       $FF, +$4B, -$1A              ; draw, y, x 
                    DB       $FF, +$4B, -$1A              ; draw, y, x 
                    DB       $FF, +$4A, -$0D              ; draw, y, x 
                    DB       $FF, +$4A, -$0E              ; draw, y, x 
                    DB       $FF, -$7A, +$12              ; draw, y, x 
                    DB       $FF, +$64, -$22              ; draw, y, x 
                    DB       $FF, -$5F, +$1B              ; draw, y, x 
                    DB       $FF, +$07, -$1B              ; draw, y, x 
                    DB       $FF, -$18, +$15              ; draw, y, x 
                    DB       $FF, -$17, +$14              ; draw, y, x 
                    DB       $FF, -$4B, +$1B              ; draw, y, x 
                    DB       $FF, -$4B, +$1A              ; draw, y, x 
                    DB       $FF, -$02, -$11              ; draw, y, x 
                    DB       $FF, -$01, -$11              ; draw, y, x 
                    DB       $FF, +$5C, -$2D              ; draw, y, x 
                    DB       $FF, -$5A, +$24              ; draw, y, x 
                    DB       $FF, -$09, -$0E              ; draw, y, x 
                    DB       $FF, -$09, -$0E              ; draw, y, x 
                    DB       $01, -$04, -$4D              ; sync and move to y, x 
                    DB       $FF, -$01, +$10              ; draw, y, x 
                    DB       $FF, -$01, +$10              ; draw, y, x 
                    DB       $FF, -$63, +$03              ; draw, y, x 
                    DB       $FF, +$61, +$06              ; draw, y, x 
                    DB       $FF, +$03, +$11              ; draw, y, x 
                    DB       $FF, +$03, +$11              ; draw, y, x 
                    DB       $FF, -$54, +$07              ; draw, y, x 
                    DB       $FF, -$55, +$08              ; draw, y, x 
                    DB       $FF, -$29, -$12              ; draw, y, x 
                    DB       $FF, +$17, +$14              ; draw, y, x 
                    DB       $FF, -$44, +$07              ; draw, y, x 
                    DB       $FF, -$44, +$08              ; draw, y, x 
                    DB       $FF, +$73, -$06              ; draw, y, x 
                    DB       $FF, -$7F, +$23              ; draw, y, x 
                    DB       $FF, +$4F, -$14              ; draw, y, x 
                    DB       $FF, +$4E, -$14              ; draw, y, x 
                    DB       $FF, +$57, -$09              ; draw, y, x 
                    DB       $FF, +$57, -$09              ; draw, y, x 
                    DB       $01, -$06, +$01              ; sync and move to y, x 
                    DB       $FF, -$50, +$1C              ; draw, y, x 
                    DB       $FF, -$50, +$1C              ; draw, y, x 
                    DB       $FF, -$53, +$0D              ; draw, y, x 
                    DB       $FF, -$53, +$0D              ; draw, y, x 
                    DB       $FF, +$44, -$08              ; draw, y, x 
                    DB       $FF, +$44, -$08              ; draw, y, x 
                    DB       $FF, -$63, +$24              ; draw, y, x 
                    DB       $FF, +$6B, -$23              ; draw, y, x 
                    DB       $FF, -$0C, +$1D              ; draw, y, x 
                    DB       $FF, +$14, -$13              ; draw, y, x 
                    DB       $FF, +$13, -$12              ; draw, y, x 
                    DB       $FF, +$50, -$1C              ; draw, y, x 
                    DB       $FF, +$50, -$1C              ; draw, y, x 
                    DB       $FF, +$02, +$14              ; draw, y, x 
                    DB       $FF, +$03, +$15              ; draw, y, x 
                    DB       $FF, -$62, +$2A              ; draw, y, x 
                    DB       $FF, +$67, -$25              ; draw, y, x 
                    DB       $FF, +$0D, +$19              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_30: 
                    DB       $01, +$39, +$7E              ; sync and move to y, x 
                    DB       $FF, -$07, -$32              ; draw, y, x 
                    DB       $FF, +$70, -$11              ; draw, y, x 
                    DB       $FF, -$70, +$06              ; draw, y, x 
                    DB       $FF, -$10, -$21              ; draw, y, x 
                    DB       $FF, -$0F, -$21              ; draw, y, x 
                    DB       $FF, +$4F, -$0D              ; draw, y, x 
                    DB       $FF, +$4F, -$0D              ; draw, y, x 
                    DB       $FF, +$26, +$10              ; draw, y, x 
                    DB       $FF, +$27, +$0F              ; draw, y, x 
                    DB       $FF, -$33, -$22              ; draw, y, x 
                    DB       $FF, +$72, -$18              ; draw, y, x 
                    DB       $FF, -$64, +$0E              ; draw, y, x 
                    DB       $FF, +$6C, -$45              ; draw, y, x 
                    DB       $FF, -$45, +$25              ; draw, y, x 
                    DB       $FF, -$44, +$24              ; draw, y, x 
                    DB       $FF, -$53, +$0E              ; draw, y, x 
                    DB       $FF, -$52, +$0E              ; draw, y, x 
                    DB       $01, +$17, -$08              ; sync and move to y, x 
                    DB       $FF, +$42, -$2D              ; draw, y, x 
                    DB       $FF, +$43, -$2E              ; draw, y, x 
                    DB       $FF, +$47, -$18              ; draw, y, x 
                    DB       $FF, +$48, -$18              ; draw, y, x 
                    DB       $FF, -$77, +$1F              ; draw, y, x 
                    DB       $FF, +$59, -$3A              ; draw, y, x 
                    DB       $FF, -$57, +$2F              ; draw, y, x 
                    DB       $FF, -$06, -$2E              ; draw, y, x 
                    DB       $FF, -$0F, +$24              ; draw, y, x 
                    DB       $FF, -$0F, +$23              ; draw, y, x 
                    DB       $FF, -$43, +$2E              ; draw, y, x 
                    DB       $FF, -$42, +$2E              ; draw, y, x 
                    DB       $FF, -$0A, -$1D              ; draw, y, x 
                    DB       $FF, -$09, -$1D              ; draw, y, x 
                    DB       $FF, +$4D, -$4D              ; draw, y, x 
                    DB       $FF, -$4E, +$3E              ; draw, y, x 
                    DB       $FF, -$10, -$17              ; draw, y, x 
                    DB       $FF, -$10, -$18              ; draw, y, x 
                    DB       $01, -$27, -$7F              ; sync and move to y, x 
                    DB       $00, +$00, -$03              ; additional sync move to y, x 
                    DB       $FF, +$07, +$1B              ; draw, y, x 
                    DB       $FF, +$06, +$1B              ; draw, y, x 
                    DB       $FF, -$67, +$07              ; draw, y, x 
                    DB       $FF, +$69, +$09              ; draw, y, x 
                    DB       $FF, +$0A, +$1D              ; draw, y, x 
                    DB       $FF, +$0A, +$1C              ; draw, y, x 
                    DB       $FF, -$54, +$0E              ; draw, y, x 
                    DB       $FF, -$55, +$0E              ; draw, y, x 
                    DB       $FF, -$33, -$1E              ; draw, y, x 
                    DB       $FF, +$21, +$22              ; draw, y, x 
                    DB       $FF, -$44, +$0D              ; draw, y, x 
                    DB       $FF, -$44, +$0E              ; draw, y, x 
                    DB       $FF, +$77, -$0C              ; draw, y, x 
                    DB       $FF, -$76, +$3E              ; draw, y, x 
                    DB       $FF, +$49, -$23              ; draw, y, x 
                    DB       $FF, +$49, -$23              ; draw, y, x 
                    DB       $FF, +$57, -$11              ; draw, y, x 
                    DB       $FF, +$57, -$11              ; draw, y, x 
                    DB       $01, -$06, +$02              ; sync and move to y, x 
                    DB       $FF, -$47, +$30              ; draw, y, x 
                    DB       $FF, -$47, +$31              ; draw, y, x 
                    DB       $FF, -$51, +$17              ; draw, y, x 
                    DB       $FF, -$51, +$18              ; draw, y, x 
                    DB       $FF, +$44, -$0F              ; draw, y, x 
                    DB       $FF, +$43, -$0E              ; draw, y, x 
                    DB       $FF, -$57, +$3E              ; draw, y, x 
                    DB       $FF, +$60, -$3D              ; draw, y, x 
                    DB       $FF, +$01, +$32              ; draw, y, x 
                    DB       $FF, +$17, -$40              ; draw, y, x 
                    DB       $FF, +$47, -$31              ; draw, y, x 
                    DB       $FF, +$47, -$31              ; draw, y, x 
                    DB       $FF, +$0C, +$23              ; draw, y, x 
                    DB       $FF, +$0C, +$23              ; draw, y, x 
                    DB       $FF, -$53, +$48              ; draw, y, x 
                    DB       $FF, +$5B, -$40              ; draw, y, x 
                    DB       $FF, +$19, +$2A              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_31: 
                    DB       $01, +$6B, +$7F              ; sync and move to y, x 
                    DB       $00, +$00, +$23              ; additional sync move to y, x 
                    DB       $FF, -$1A, -$40              ; draw, y, x 
                    DB       $FF, +$71, -$1C              ; draw, y, x 
                    DB       $FF, -$75, +$0E              ; draw, y, x 
                    DB       $FF, -$1D, -$2B              ; draw, y, x 
                    DB       $FF, -$1C, -$2B              ; draw, y, x 
                    DB       $FF, +$4F, -$14              ; draw, y, x 
                    DB       $FF, +$4F, -$14              ; draw, y, x 
                    DB       $FF, +$2F, +$13              ; draw, y, x 
                    DB       $FF, +$2F, +$12              ; draw, y, x 
                    DB       $FF, -$43, -$2B              ; draw, y, x 
                    DB       $FF, +$70, -$23              ; draw, y, x 
                    DB       $FF, -$65, +$16              ; draw, y, x 
                    DB       $FF, +$5A, -$5E              ; draw, y, x 
                    DB       $FF, -$77, +$64              ; draw, y, x 
                    DB       $FF, -$53, +$16              ; draw, y, x 
                    DB       $FF, -$53, +$15              ; draw, y, x 
                    DB       $01, +$15, -$0C              ; sync and move to y, x 
                    DB       $FF, +$6D, -$7C              ; draw, y, x 
                    DB       $FF, +$43, -$22              ; draw, y, x 
                    DB       $FF, +$44, -$22              ; draw, y, x 
                    DB       $FF, -$74, +$2E              ; draw, y, x 
                    DB       $FF, +$49, -$50              ; draw, y, x 
                    DB       $FF, -$4B, +$41              ; draw, y, x 
                    DB       $FF, -$17, -$3C              ; draw, y, x 
                    DB       $FF, -$06, +$5E              ; draw, y, x 
                    DB       $FF, -$6C, +$7D              ; draw, y, x 
                    DB       $FF, -$14, -$25              ; draw, y, x 
                    DB       $FF, -$15, -$25              ; draw, y, x 
                    DB       $FF, +$35, -$68              ; draw, y, x 
                    DB       $FF, -$3C, +$54              ; draw, y, x 
                    DB       $FF, -$33, -$3C              ; draw, y, x 
                    DB       $01, -$59, -$7F              ; sync and move to y, x 
                    DB       $00, +$00, -$29              ; additional sync move to y, x 
                    DB       $FF, +$21, +$45              ; draw, y, x 
                    DB       $FF, -$6B, +$0E              ; draw, y, x 
                    DB       $FF, +$73, +$07              ; draw, y, x 
                    DB       $FF, +$16, +$25              ; draw, y, x 
                    DB       $FF, +$15, +$25              ; draw, y, x 
                    DB       $FF, -$55, +$16              ; draw, y, x 
                    DB       $FF, -$55, +$16              ; draw, y, x 
                    DB       $FF, -$41, -$25              ; draw, y, x 
                    DB       $FF, +$2F, +$2A              ; draw, y, x 
                    DB       $FF, -$43, +$14              ; draw, y, x 
                    DB       $FF, -$44, +$15              ; draw, y, x 
                    DB       $FF, +$7A, -$14              ; draw, y, x 
                    DB       $FF, -$66, +$56              ; draw, y, x 
                    DB       $FF, +$41, -$31              ; draw, y, x 
                    DB       $FF, +$41, -$31              ; draw, y, x 
                    DB       $FF, +$57, -$1A              ; draw, y, x 
                    DB       $FF, +$56, -$19              ; draw, y, x 
                    DB       $01, -$05, +$03              ; sync and move to y, x 
                    DB       $FF, -$3A, +$42              ; draw, y, x 
                    DB       $FF, -$3A, +$42              ; draw, y, x 
                    DB       $FF, -$4D, +$22              ; draw, y, x 
                    DB       $FF, -$4E, +$22              ; draw, y, x 
                    DB       $FF, +$42, -$16              ; draw, y, x 
                    DB       $FF, +$42, -$15              ; draw, y, x 
                    DB       $FF, -$46, +$54              ; draw, y, x 
                    DB       $FF, +$51, -$53              ; draw, y, x 
                    DB       $FF, +$12, +$41              ; draw, y, x 
                    DB       $FF, +$02, -$55              ; draw, y, x 
                    DB       $FF, +$3A, -$43              ; draw, y, x 
                    DB       $FF, +$3A, -$42              ; draw, y, x 
                    DB       $FF, +$19, +$2D              ; draw, y, x 
                    DB       $FF, +$19, +$2D              ; draw, y, x 
                    DB       $FF, -$3E, +$61              ; draw, y, x 
                    DB       $FF, +$4A, -$56              ; draw, y, x 
                    DB       $FF, +$2A, +$35              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_32: 
                    DB       $01, +$7F, +$7F              ; sync and move to y, x 
                    DB       $00, +$27, +$35              ; additional sync move to y, x 
                    DB       $FF, -$30, -$49              ; draw, y, x 
                    DB       $FF, +$71, -$27              ; draw, y, x 
                    DB       $FF, -$7A, +$17              ; draw, y, x 
                    DB       $FF, -$2D, -$30              ; draw, y, x 
                    DB       $FF, -$2C, -$2F              ; draw, y, x 
                    DB       $FF, +$4F, -$1C              ; draw, y, x 
                    DB       $FF, +$50, -$1C              ; draw, y, x 
                    DB       $FF, +$70, +$24              ; draw, y, x 
                    DB       $FF, -$55, -$2D              ; draw, y, x 
                    DB       $FF, +$6D, -$30              ; draw, y, x 
                    DB       $FF, -$66, +$20              ; draw, y, x 
                    DB       $FF, +$43, -$72              ; draw, y, x 
                    DB       $FF, -$60, +$7B              ; draw, y, x 
                    DB       $FF, -$53, +$1F              ; draw, y, x 
                    DB       $FF, -$52, +$1E              ; draw, y, x 
                    DB       $01, +$13, -$0F              ; sync and move to y, x 
                    DB       $FF, +$27, -$4B              ; draw, y, x 
                    DB       $FF, +$27, -$4B              ; draw, y, x 
                    DB       $FF, +$7B, -$57              ; draw, y, x 
                    DB       $FF, -$6D, +$3C              ; draw, y, x 
                    DB       $FF, +$35, -$61              ; draw, y, x 
                    DB       $FF, -$3C, +$50              ; draw, y, x 
                    DB       $FF, -$2C, -$44              ; draw, y, x 
                    DB       $FF, +$17, +$6C              ; draw, y, x 
                    DB       $FF, -$26, +$4C              ; draw, y, x 
                    DB       $FF, -$26, +$4C              ; draw, y, x 
                    DB       $FF, -$44, -$53              ; draw, y, x 
                    DB       $FF, +$18, -$7B              ; draw, y, x 
                    DB       $FF, -$26, +$65              ; draw, y, x 
                    DB       $FF, -$4A, -$41              ; draw, y, x 
                    DB       $01, -$7F, -$7F              ; sync and move to y, x 
                    DB       $00, -$16, -$3C              ; additional sync move to y, x 
                    DB       $FF, +$3A, +$4D              ; draw, y, x 
                    DB       $FF, -$6F, +$17              ; draw, y, x 
                    DB       $FF, +$7E, +$01              ; draw, y, x 
                    DB       $FF, +$45, +$51              ; draw, y, x 
                    DB       $FF, -$54, +$1F              ; draw, y, x 
                    DB       $FF, -$55, +$20              ; draw, y, x 
                    DB       $FF, -$52, -$27              ; draw, y, x 
                    DB       $FF, +$40, +$2E              ; draw, y, x 
                    DB       $FF, -$41, +$1C              ; draw, y, x 
                    DB       $FF, -$42, +$1C              ; draw, y, x 
                    DB       $FF, +$7D, -$1F              ; draw, y, x 
                    DB       $FF, -$54, +$69              ; draw, y, x 
                    DB       $FF, +$6E, -$79              ; draw, y, x 
                    DB       $FF, +$55, -$23              ; draw, y, x 
                    DB       $FF, +$54, -$23              ; draw, y, x 
                    DB       $01, -$05, +$04              ; sync and move to y, x 
                    DB       $FF, -$29, +$50              ; draw, y, x 
                    DB       $FF, -$2A, +$50              ; draw, y, x 
                    DB       $FF, -$48, +$2C              ; draw, y, x 
                    DB       $FF, -$49, +$2D              ; draw, y, x 
                    DB       $FF, +$41, -$1E              ; draw, y, x 
                    DB       $FF, +$40, -$1D              ; draw, y, x 
                    DB       $FF, -$31, +$65              ; draw, y, x 
                    DB       $FF, +$3C, -$65              ; draw, y, x 
                    DB       $FF, +$29, +$4A              ; draw, y, x 
                    DB       $FF, -$19, -$62              ; draw, y, x 
                    DB       $FF, +$29, -$51              ; draw, y, x 
                    DB       $FF, +$29, -$50              ; draw, y, x 
                    DB       $FF, +$29, +$32              ; draw, y, x 
                    DB       $FF, +$2A, +$32              ; draw, y, x 
                    DB       $FF, -$24, +$74              ; draw, y, x 
                    DB       $FF, +$34, -$68              ; draw, y, x 
                    DB       $FF, +$3E, +$3B              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_33: 
                    DB       $01, +$7F, +$7F              ; sync and move to y, x 
                    DB       $00, +$65, +$31              ; additional sync move to y, x 
                    DB       $FF, -$47, -$49              ; draw, y, x 
                    DB       $FF, +$6E, -$34              ; draw, y, x 
                    DB       $FF, -$7C, +$24              ; draw, y, x 
                    DB       $FF, -$7A, -$5D              ; draw, y, x 
                    DB       $FF, +$4D, -$26              ; draw, y, x 
                    DB       $FF, +$4E, -$26              ; draw, y, x 
                    DB       $FF, +$41, +$0F              ; draw, y, x 
                    DB       $FF, +$42, +$0E              ; draw, y, x 
                    DB       $FF, -$68, -$28              ; draw, y, x 
                    DB       $FF, +$68, -$3E              ; draw, y, x 
                    DB       $FF, -$65, +$2C              ; draw, y, x 
                    DB       $FF, +$15, -$40              ; draw, y, x 
                    DB       $FF, +$15, -$41              ; draw, y, x 
                    DB       $FF, -$24, +$47              ; draw, y, x 
                    DB       $FF, -$23, +$47              ; draw, y, x 
                    DB       $FF, -$51, +$28              ; draw, y, x 
                    DB       $FF, -$50, +$28              ; draw, y, x 
                    DB       $01, +$10, -$12              ; sync and move to y, x 
                    DB       $FF, +$16, -$54              ; draw, y, x 
                    DB       $FF, +$16, -$54              ; draw, y, x 
                    DB       $FF, +$6D, -$69              ; draw, y, x 
                    DB       $FF, -$66, +$4B              ; draw, y, x 
                    DB       $FF, +$1F, -$6C              ; draw, y, x 
                    DB       $FF, -$2B, +$5A              ; draw, y, x 
                    DB       $FF, -$42, -$44              ; draw, y, x 
                    DB       $FF, +$37, +$72              ; draw, y, x 
                    DB       $FF, -$15, +$55              ; draw, y, x 
                    DB       $FF, -$14, +$55              ; draw, y, x 
                    DB       $FF, -$60, -$53              ; draw, y, x 
                    DB       $FF, -$03, -$43              ; draw, y, x 
                    DB       $FF, -$04, -$43              ; draw, y, x 
                    DB       $FF, -$0E, +$70              ; draw, y, x 
                    DB       $FF, -$62, -$3F              ; draw, y, x 
                    DB       $01, -$7F, -$7F              ; sync and move to y, x 
                    DB       $00, -$55, -$3B              ; additional sync move to y, x 
                    DB       $FF, +$54, +$4D              ; draw, y, x 
                    DB       $FF, -$71, +$24              ; draw, y, x 
                    DB       $FF, +$44, -$06              ; draw, y, x 
                    DB       $FF, +$44, -$06              ; draw, y, x 
                    DB       $FF, +$60, +$51              ; draw, y, x 
                    DB       $FF, -$52, +$29              ; draw, y, x 
                    DB       $FF, -$52, +$2A              ; draw, y, x 
                    DB       $FF, -$63, -$22              ; draw, y, x 
                    DB       $FF, +$51, +$2B              ; draw, y, x 
                    DB       $FF, -$7E, +$48              ; draw, y, x 
                    DB       $FF, +$7E, -$2D              ; draw, y, x 
                    DB       $FF, -$3D, +$79              ; draw, y, x 
                    DB       $FF, +$2A, -$46              ; draw, y, x 
                    DB       $FF, +$2A, -$46              ; draw, y, x 
                    DB       $FF, +$52, -$2E              ; draw, y, x 
                    DB       $FF, +$52, -$2D              ; draw, y, x 
                    DB       $01, -$04, +$05              ; sync and move to y, x 
                    DB       $FF, -$17, +$59              ; draw, y, x 
                    DB       $FF, -$17, +$59              ; draw, y, x 
                    DB       $FF, -$42, +$36              ; draw, y, x 
                    DB       $FF, -$42, +$37              ; draw, y, x 
                    DB       $FF, +$7B, -$4B              ; draw, y, x 
                    DB       $FF, -$1A, +$71              ; draw, y, x 
                    DB       $FF, +$26, -$71              ; draw, y, x 
                    DB       $FF, +$40, +$4A              ; draw, y, x 
                    DB       $FF, -$36, -$66              ; draw, y, x 
                    DB       $FF, +$17, -$5A              ; draw, y, x 
                    DB       $FF, +$16, -$5A              ; draw, y, x 
                    DB       $FF, +$75, +$63              ; draw, y, x 
                    DB       $FF, -$04, +$40              ; draw, y, x 
                    DB       $FF, -$04, +$40              ; draw, y, x 
                    DB       $FF, +$1C, -$74              ; draw, y, x 
                    DB       $FF, +$53, +$38              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_34: 
                    DB       $01, +$7F, +$7F              ; sync and move to y, x 
                    DB       $00, +$7F, +$19              ; additional sync move to y, x 
                    DB       $00, +$1F, +$00              ; additional sync move to y, x 
                    DB       $FF, -$5D, -$42              ; draw, y, x 
                    DB       $FF, +$69, -$43              ; draw, y, x 
                    DB       $FF, -$7C, +$34              ; draw, y, x 
                    DB       $FF, -$4C, -$28              ; draw, y, x 
                    DB       $FF, -$4C, -$28              ; draw, y, x 
                    DB       $FF, +$4A, -$30              ; draw, y, x 
                    DB       $FF, +$4A, -$30              ; draw, y, x 
                    DB       $FF, +$49, +$07              ; draw, y, x 
                    DB       $FF, +$49, +$06              ; draw, y, x 
                    DB       $FF, -$78, -$1C              ; draw, y, x 
                    DB       $FF, +$61, -$4D              ; draw, y, x 
                    DB       $FF, -$62, +$3A              ; draw, y, x 
                    DB       $FF, +$07, -$44              ; draw, y, x 
                    DB       $FF, +$07, -$45              ; draw, y, x 
                    DB       $FF, -$15, +$4D              ; draw, y, x 
                    DB       $FF, -$15, +$4D              ; draw, y, x 
                    DB       $FF, -$4D, +$33              ; draw, y, x 
                    DB       $FF, -$4C, +$33              ; draw, y, x 
                    DB       $01, +$0D, -$14              ; sync and move to y, x 
                    DB       $FF, +$03, -$58              ; draw, y, x 
                    DB       $FF, +$04, -$59              ; draw, y, x 
                    DB       $FF, +$5C, -$79              ; draw, y, x 
                    DB       $FF, -$5C, +$59              ; draw, y, x 
                    DB       $FF, +$08, -$73              ; draw, y, x 
                    DB       $FF, -$19, +$62              ; draw, y, x 
                    DB       $FF, -$55, -$3D              ; draw, y, x 
                    DB       $FF, +$55, +$6D              ; draw, y, x 
                    DB       $FF, -$02, +$5A              ; draw, y, x 
                    DB       $FF, -$02, +$59              ; draw, y, x 
                    DB       $FF, -$7A, -$49              ; draw, y, x 
                    DB       $FF, -$14, -$44              ; draw, y, x 
                    DB       $FF, -$14, -$44              ; draw, y, x 
                    DB       $FF, +$0C, +$74              ; draw, y, x 
                    DB       $FF, -$77, -$35              ; draw, y, x 
                    DB       $01, -$7F, -$7F              ; sync and move to y, x 
                    DB       $00, -$7F, -$26              ; additional sync move to y, x 
                    DB       $00, -$10, +$00              ; additional sync move to y, x 
                    DB       $FF, +$6B, +$46              ; draw, y, x 
                    DB       $FF, -$6F, +$31              ; draw, y, x 
                    DB       $FF, +$47, -$0E              ; draw, y, x 
                    DB       $FF, +$46, -$0E              ; draw, y, x 
                    DB       $FF, +$7B, +$47              ; draw, y, x 
                    DB       $FF, -$4E, +$34              ; draw, y, x 
                    DB       $FF, -$4F, +$35              ; draw, y, x 
                    DB       $FF, -$71, -$17              ; draw, y, x 
                    DB       $FF, +$61, +$22              ; draw, y, x 
                    DB       $FF, -$76, +$5A              ; draw, y, x 
                    DB       $FF, +$7C, -$3D              ; draw, y, x 
                    DB       $FF, -$12, +$41              ; draw, y, x 
                    DB       $FF, -$13, +$41              ; draw, y, x 
                    DB       $FF, +$1D, -$4D              ; draw, y, x 
                    DB       $FF, +$1D, -$4C              ; draw, y, x 
                    DB       $FF, +$4D, -$39              ; draw, y, x 
                    DB       $FF, +$4C, -$39              ; draw, y, x 
                    DB       $01, -$03, +$05              ; sync and move to y, x 
                    DB       $FF, -$03, +$5E              ; draw, y, x 
                    DB       $FF, -$04, +$5F              ; draw, y, x 
                    DB       $FF, -$3A, +$40              ; draw, y, x 
                    DB       $FF, -$3A, +$40              ; draw, y, x 
                    DB       $FF, +$72, -$5D              ; draw, y, x 
                    DB       $FF, +$00, +$77              ; draw, y, x 
                    DB       $FF, +$0D, -$79              ; draw, y, x 
                    DB       $FF, +$56, +$45              ; draw, y, x 
                    DB       $FF, -$51, -$62              ; draw, y, x 
                    DB       $FF, +$02, -$5F              ; draw, y, x 
                    DB       $FF, +$03, -$5E              ; draw, y, x 
                    DB       $FF, +$4A, +$2B              ; draw, y, x 
                    DB       $FF, +$4A, +$2C              ; draw, y, x 
                    DB       $FF, +$0B, +$41              ; draw, y, x 
                    DB       $FF, +$0B, +$42              ; draw, y, x 
                    DB       $FF, +$02, -$7A              ; draw, y, x 
                    DB       $FF, +$66, +$2F              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_35: 
                    DB       $01, +$7F, +$6F              ; sync and move to y, x 
                    DB       $00, +$7F, +$00              ; additional sync move to y, x 
                    DB       $00, +$4D, +$00              ; additional sync move to y, x 
                    DB       $FF, -$70, -$35              ; draw, y, x 
                    DB       $FF, +$61, -$52              ; draw, y, x 
                    DB       $FF, -$77, +$46              ; draw, y, x 
                    DB       $FF, -$59, -$1D              ; draw, y, x 
                    DB       $FF, -$58, -$1D              ; draw, y, x 
                    DB       $FF, +$44, -$3B              ; draw, y, x 
                    DB       $FF, +$44, -$3B              ; draw, y, x 
                    DB       $FF, +$4E, -$04              ; draw, y, x 
                    DB       $FF, +$4F, -$04              ; draw, y, x 
                    DB       $FF, -$43, -$05              ; draw, y, x 
                    DB       $FF, -$42, -$05              ; draw, y, x 
                    DB       $FF, +$56, -$5B              ; draw, y, x 
                    DB       $FF, -$5B, +$48              ; draw, y, x 
                    DB       $FF, -$07, -$45              ; draw, y, x 
                    DB       $FF, -$06, -$46              ; draw, y, x 
                    DB       $FF, -$06, +$50              ; draw, y, x 
                    DB       $FF, -$06, +$50              ; draw, y, x 
                    DB       $FF, -$46, +$3E              ; draw, y, x 
                    DB       $FF, -$46, +$3E              ; draw, y, x 
                    DB       $01, +$0A, -$16              ; sync and move to y, x 
                    DB       $FF, -$0E, -$59              ; draw, y, x 
                    DB       $FF, -$0F, -$59              ; draw, y, x 
                    DB       $FF, +$23, -$43              ; draw, y, x 
                    DB       $FF, +$24, -$43              ; draw, y, x 
                    DB       $FF, -$4E, +$66              ; draw, y, x 
                    DB       $FF, -$0F, -$74              ; draw, y, x 
                    DB       $FF, -$06, +$66              ; draw, y, x 
                    DB       $FF, -$67, -$31              ; draw, y, x 
                    DB       $FF, +$70, +$61              ; draw, y, x 
                    DB       $FF, +$11, +$5A              ; draw, y, x 
                    DB       $FF, +$10, +$59              ; draw, y, x 
                    DB       $FF, -$47, -$1B              ; draw, y, x 
                    DB       $FF, -$48, -$1C              ; draw, y, x 
                    DB       $FF, -$23, -$41              ; draw, y, x 
                    DB       $FF, -$23, -$41              ; draw, y, x 
                    DB       $FF, +$24, +$72              ; draw, y, x 
                    DB       $FF, -$44, -$11              ; draw, y, x 
                    DB       $FF, -$44, -$12              ; draw, y, x 
                    DB       $01, -$7F, -$7D              ; sync and move to y, x 
                    DB       $00, -$7F, +$00              ; additional sync move to y, x 
                    DB       $00, -$40, +$00              ; additional sync move to y, x 
                    DB       $FF, +$7F, +$35              ; draw, y, x 
                    DB       $FF, -$6B, +$42              ; draw, y, x 
                    DB       $FF, +$48, -$18              ; draw, y, x 
                    DB       $FF, +$47, -$19              ; draw, y, x 
                    DB       $FF, +$48, +$1B              ; draw, y, x 
                    DB       $FF, +$48, +$1A              ; draw, y, x 
                    DB       $FF, -$47, +$40              ; draw, y, x 
                    DB       $FF, -$48, +$40              ; draw, y, x 
                    DB       $FF, -$7C, -$06              ; draw, y, x 
                    DB       $FF, +$6D, +$14              ; draw, y, x 
                    DB       $FF, -$6A, +$6A              ; draw, y, x 
                    DB       $FF, +$76, -$4F              ; draw, y, x 
                    DB       $FF, -$06, +$44              ; draw, y, x 
                    DB       $FF, -$06, +$44              ; draw, y, x 
                    DB       $FF, +$0F, -$51              ; draw, y, x 
                    DB       $FF, +$0E, -$51              ; draw, y, x 
                    DB       $FF, +$45, -$44              ; draw, y, x 
                    DB       $FF, +$45, -$43              ; draw, y, x 
                    DB       $01, -$02, +$06              ; sync and move to y, x 
                    DB       $FF, +$0F, +$5E              ; draw, y, x 
                    DB       $FF, +$10, +$5F              ; draw, y, x 
                    DB       $FF, -$2F, +$48              ; draw, y, x 
                    DB       $FF, -$30, +$48              ; draw, y, x 
                    DB       $FF, +$64, -$6C              ; draw, y, x 
                    DB       $FF, +$19, +$76              ; draw, y, x 
                    DB       $FF, -$0B, -$7A              ; draw, y, x 
                    DB       $FF, +$68, +$38              ; draw, y, x 
                    DB       $FF, -$6A, -$56              ; draw, y, x 
                    DB       $FF, -$10, -$5F              ; draw, y, x 
                    DB       $FF, -$10, -$5F              ; draw, y, x 
                    DB       $FF, +$56, +$20              ; draw, y, x 
                    DB       $FF, +$56, +$21              ; draw, y, x 
                    DB       $FF, +$19, +$40              ; draw, y, x 
                    DB       $FF, +$1A, +$40              ; draw, y, x 
                    DB       $FF, -$17, -$7A              ; draw, y, x 
                    DB       $FF, +$75, +$21              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake2d_36: 
                    DB       $01, +$7F, +$38              ; sync and move to y, x 
                    DB       $00, +$7F, +$00              ; additional sync move to y, x 
                    DB       $00, +$6A, +$00              ; additional sync move to y, x 
                    DB       $FF, -$7C, -$22              ; draw, y, x 
                    DB       $FF, +$55, -$61              ; draw, y, x 
                    DB       $FF, -$6E, +$59              ; draw, y, x 
                    DB       $FF, -$60, -$0E              ; draw, y, x 
                    DB       $FF, -$60, -$0F              ; draw, y, x 
                    DB       $FF, +$3A, -$45              ; draw, y, x 
                    DB       $FF, +$3B, -$45              ; draw, y, x 
                    DB       $FF, +$50, -$11              ; draw, y, x 
                    DB       $FF, +$50, -$11              ; draw, y, x 
                    DB       $FF, -$45, +$06              ; draw, y, x 
                    DB       $FF, -$45, +$05              ; draw, y, x 
                    DB       $FF, +$48, -$67              ; draw, y, x 
                    DB       $FF, -$51, +$55              ; draw, y, x 
                    DB       $FF, -$14, -$43              ; draw, y, x 
                    DB       $FF, -$13, -$43              ; draw, y, x 
                    DB       $FF, +$08, +$50              ; draw, y, x 
                    DB       $FF, +$09, +$4F              ; draw, y, x 
                    DB       $FF, -$3D, +$49              ; draw, y, x 
                    DB       $FF, -$3C, +$49              ; draw, y, x 
                    DB       $01, +$06, -$17              ; sync and move to y, x 
                    DB       $FF, -$1F, -$55              ; draw, y, x 
                    DB       $FF, -$20, -$56              ; draw, y, x 
                    DB       $FF, +$19, -$48              ; draw, y, x 
                    DB       $FF, +$18, -$48              ; draw, y, x 
                    DB       $FF, -$3D, +$71              ; draw, y, x 
                    DB       $FF, -$25, -$70              ; draw, y, x 
                    DB       $FF, +$0C, +$66              ; draw, y, x 
                    DB       $FF, -$72, -$20              ; draw, y, x 
                    DB       $FF, +$42, +$27              ; draw, y, x 
                    DB       $FF, +$42, +$27              ; draw, y, x 
                    DB       $FF, +$22, +$56              ; draw, y, x 
                    DB       $FF, +$21, +$55              ; draw, y, x 
                    DB       $FF, -$4E, -$0F              ; draw, y, x 
                    DB       $FF, -$4F, -$10              ; draw, y, x 
                    DB       $FF, -$5F, -$76              ; draw, y, x 
                    DB       $FF, +$39, +$6C              ; draw, y, x 
                    DB       $FF, -$49, -$06              ; draw, y, x 
                    DB       $FF, -$49, -$07              ; draw, y, x 
                    DB       $01, -$7F, -$48              ; sync and move to y, x 
                    DB       $00, -$7F, +$00              ; additional sync move to y, x 
                    DB       $00, -$60, +$00              ; additional sync move to y, x 
                    DB       $FF, +$47, +$10              ; draw, y, x 
                    DB       $FF, +$46, +$10              ; draw, y, x 
                    DB       $FF, -$62, +$53              ; draw, y, x 
                    DB       $FF, +$45, -$24              ; draw, y, x 
                    DB       $FF, +$45, -$24              ; draw, y, x 
                    DB       $FF, +$4F, +$0F              ; draw, y, x 
                    DB       $FF, +$4E, +$0E              ; draw, y, x 
                    DB       $FF, -$3E, +$4A              ; draw, y, x 
                    DB       $FF, -$3E, +$4B              ; draw, y, x 
                    DB       $FF, -$40, +$07              ; draw, y, x 
                    DB       $FF, -$40, +$08              ; draw, y, x 
                    DB       $FF, +$74, +$01              ; draw, y, x 
                    DB       $FF, -$59, +$7B              ; draw, y, x 
                    DB       $FF, +$6A, -$61              ; draw, y, x 
                    DB       $FF, +$07, +$44              ; draw, y, x 
                    DB       $FF, +$06, +$44              ; draw, y, x 
                    DB       $FF, +$00, -$53              ; draw, y, x 
                    DB       $FF, +$00, -$52              ; draw, y, x 
                    DB       $FF, +$3B, -$4E              ; draw, y, x 
                    DB       $FF, +$3A, -$4E              ; draw, y, x 
                    DB       $01, -$01, +$06              ; sync and move to y, x 
                    DB       $FF, +$21, +$5B              ; draw, y, x 
                    DB       $FF, +$22, +$5B              ; draw, y, x 
                    DB       $FF, -$24, +$4F              ; draw, y, x 
                    DB       $FF, -$23, +$4F              ; draw, y, x 
                    DB       $FF, +$53, -$7C              ; draw, y, x 
                    DB       $FF, +$2E, +$72              ; draw, y, x 
                    DB       $FF, -$21, -$78              ; draw, y, x 
                    DB       $FF, +$75, +$27              ; draw, y, x 
                    DB       $FF, -$7C, -$44              ; draw, y, x 
                    DB       $FF, -$23, -$5B              ; draw, y, x 
                    DB       $FF, -$22, -$5B              ; draw, y, x 
                    DB       $FF, +$5F, +$12              ; draw, y, x 
                    DB       $FF, +$5F, +$12              ; draw, y, x 
                    DB       $FF, +$4C, +$77              ; draw, y, x 
                    DB       $FF, -$2E, -$76              ; draw, y, x 
                    DB       $FF, +$7D, +$0E              ; draw, y, x 
                    DB       $02                          ; endmarker 

vData               =        SnowFlake1d 
vDataLength         =        37 
SnowFlake1d: 
                    DW       SnowFlake1d_0                ; list of all single vectorlists in this 
                    DW       SnowFlake1d_1 
                    DW       SnowFlake1d_2 
                    DW       SnowFlake1d_3 
                    DW       SnowFlake1d_4 
                    DW       SnowFlake1d_5 
                    DW       SnowFlake1d_6 
                    DW       SnowFlake1d_7 
                    DW       SnowFlake1d_8 
                    DW       SnowFlake1d_9 
                    DW       SnowFlake1d_10 
                    DW       SnowFlake1d_11 
                    DW       SnowFlake1d_12 
                    DW       SnowFlake1d_13 
                    DW       SnowFlake1d_14 
                    DW       SnowFlake1d_15 
                    DW       SnowFlake1d_16 
                    DW       SnowFlake1d_17 
                    DW       SnowFlake1d_18 
                    DW       SnowFlake1d_19 
                    DW       SnowFlake1d_20 
                    DW       SnowFlake1d_21 
                    DW       SnowFlake1d_22 
                    DW       SnowFlake1d_23 
                    DW       SnowFlake1d_24 
                    DW       SnowFlake1d_25 
                    DW       SnowFlake1d_26 
                    DW       SnowFlake1d_27 
                    DW       SnowFlake1d_28 
                    DW       SnowFlake1d_29 
                    DW       SnowFlake1d_30 
                    DW       SnowFlake1d_31 
                    DW       SnowFlake1d_32 
                    DW       SnowFlake1d_33 
                    DW       SnowFlake1d_34 
                    DW       SnowFlake1d_35 
                    DW       SnowFlake1d_36 
                    DW       0 

SnowFlake1d_0: 
                    DB       $01, +$7F, -$06              ; sync and move to y, x 
                    DB       $00, +$7F, +$00              ; additional sync move to y, x 
                    DB       $00, +$74, +$00              ; additional sync move to y, x 
                    DB       $FF, -$41, -$06              ; draw, y, x 
                    DB       $FF, -$41, -$06              ; draw, y, x 
                    DB       $FF, +$44, -$6E              ; draw, y, x 
                    DB       $FF, -$5F, +$6A              ; draw, y, x 
                    DB       $FF, -$63, +$02              ; draw, y, x 
                    DB       $FF, -$62, +$02              ; draw, y, x 
                    DB       $FF, +$2F, -$4E              ; draw, y, x 
                    DB       $FF, +$2F, -$4E              ; draw, y, x 
                    DB       $FF, +$4D, -$1E              ; draw, y, x 
                    DB       $FF, +$4D, -$1E              ; draw, y, x 
                    DB       $FF, -$44, +$11              ; draw, y, x 
                    DB       $FF, -$44, +$11              ; draw, y, x 
                    DB       $FF, +$36, -$72              ; draw, y, x 
                    DB       $FF, -$42, +$62              ; draw, y, x 
                    DB       $FF, -$3E, -$7E              ; draw, y, x 
                    DB       $FF, +$16, +$4D              ; draw, y, x 
                    DB       $FF, +$16, +$4D              ; draw, y, x 
                    DB       $FF, -$30, +$52              ; draw, y, x 
                    DB       $FF, -$30, +$52              ; draw, y, x 
                    DB       $01, +$02, -$18              ; sync and move to y, x 
                    DB       $FF, -$2E, -$4F              ; draw, y, x 
                    DB       $FF, -$2E, -$4F              ; draw, y, x 
                    DB       $FF, +$0C, -$4B              ; draw, y, x 
                    DB       $FF, +$0C, -$4B              ; draw, y, x 
                    DB       $FF, -$2A, +$7A              ; draw, y, x 
                    DB       $FF, -$38, -$68              ; draw, y, x 
                    DB       $FF, +$1E, +$62              ; draw, y, x 
                    DB       $FF, -$78, -$0C              ; draw, y, x 
                    DB       $FF, +$49, +$1B              ; draw, y, x 
                    DB       $FF, +$49, +$1B              ; draw, y, x 
                    DB       $FF, +$30, +$4F              ; draw, y, x 
                    DB       $FF, +$30, +$4F              ; draw, y, x 
                    DB       $FF, -$51, -$02              ; draw, y, x 
                    DB       $FF, -$51, -$02              ; draw, y, x 
                    DB       $FF, -$74, -$64              ; draw, y, x 
                    DB       $FF, +$4C, +$60              ; draw, y, x 
                    DB       $FF, -$4A, +$06              ; draw, y, x 
                    DB       $FF, -$4A, +$06              ; draw, y, x 
                    DB       $01, -$7F, -$0C              ; sync and move to y, x 
                    DB       $00, -$7F, +$00              ; additional sync move to y, x 
                    DB       $00, -$6C, +$00              ; additional sync move to y, x 
                    DB       $FF, +$49, +$04              ; draw, y, x 
                    DB       $FF, +$49, +$04              ; draw, y, x 
                    DB       $FF, -$54, +$62              ; draw, y, x 
                    DB       $FF, +$7E, -$5E              ; draw, y, x 
                    DB       $FF, +$51, +$01              ; draw, y, x 
                    DB       $FF, +$51, +$01              ; draw, y, x 
                    DB       $FF, -$31, +$54              ; draw, y, x 
                    DB       $FF, -$31, +$54              ; draw, y, x 
                    DB       $FF, -$7E, +$24              ; draw, y, x 
                    DB       $FF, +$74, -$12              ; draw, y, x 
                    DB       $FF, -$22, +$44              ; draw, y, x 
                    DB       $FF, -$22, +$44              ; draw, y, x 
                    DB       $FF, +$5A, -$72              ; draw, y, x 
                    DB       $FF, +$12, +$42              ; draw, y, x 
                    DB       $FF, +$12, +$42              ; draw, y, x 
                    DB       $FF, -$0E, -$51              ; draw, y, x 
                    DB       $FF, -$0E, -$51              ; draw, y, x 
                    DB       $FF, +$2D, -$57              ; draw, y, x 
                    DB       $FF, +$2D, -$57              ; draw, y, x 
                    DB       $01, +$00, +$06              ; sync and move to y, x 
                    DB       $FF, +$31, +$54              ; draw, y, x 
                    DB       $FF, +$31, +$54              ; draw, y, x 
                    DB       $FF, -$16, +$54              ; draw, y, x 
                    DB       $FF, -$16, +$54              ; draw, y, x 
                    DB       $FF, +$1F, -$44              ; draw, y, x 
                    DB       $FF, +$1F, -$44              ; draw, y, x 
                    DB       $FF, +$42, +$68              ; draw, y, x 
                    DB       $FF, -$36, -$70              ; draw, y, x 
                    DB       $FF, +$7C, +$12              ; draw, y, x 
                    DB       $FF, -$44, -$17              ; draw, y, x 
                    DB       $FF, -$44, -$17              ; draw, y, x 
                    DB       $FF, -$32, -$54              ; draw, y, x 
                    DB       $FF, -$32, -$54              ; draw, y, x 
                    DB       $FF, +$62, +$02              ; draw, y, x 
                    DB       $FF, +$62, +$02              ; draw, y, x 
                    DB       $FF, +$60, +$68              ; draw, y, x 
                    DB       $FF, -$42, -$6C              ; draw, y, x 
                    DB       $FF, +$40, -$04              ; draw, y, x 
                    DB       $FF, +$40, -$04              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_1: 
                    DB       $01, +$7F, -$44              ; sync and move to y, x 
                    DB       $00, +$7F, +$00              ; additional sync move to y, x 
                    DB       $00, +$6E, +$00              ; additional sync move to y, x 
                    DB       $FF, -$41, +$05              ; draw, y, x 
                    DB       $FF, -$41, +$05              ; draw, y, x 
                    DB       $FF, +$30, -$78              ; draw, y, x 
                    DB       $FF, -$4C, +$78              ; draw, y, x 
                    DB       $FF, -$61, +$13              ; draw, y, x 
                    DB       $FF, -$60, +$13              ; draw, y, x 
                    DB       $FF, +$21, -$55              ; draw, y, x 
                    DB       $FF, +$21, -$55              ; draw, y, x 
                    DB       $FF, +$47, -$2A              ; draw, y, x 
                    DB       $FF, +$47, -$2B              ; draw, y, x 
                    DB       $FF, -$41, +$1C              ; draw, y, x 
                    DB       $FF, -$40, +$1C              ; draw, y, x 
                    DB       $FF, +$22, -$79              ; draw, y, x 
                    DB       $FF, -$30, +$6C              ; draw, y, x 
                    DB       $FF, -$53, -$72              ; draw, y, x 
                    DB       $FF, +$23, +$48              ; draw, y, x 
                    DB       $FF, +$23, +$48              ; draw, y, x 
                    DB       $FF, -$22, +$59              ; draw, y, x 
                    DB       $FF, -$21, +$59              ; draw, y, x 
                    DB       $01, -$02, -$18              ; sync and move to y, x 
                    DB       $FF, -$3A, -$46              ; draw, y, x 
                    DB       $FF, -$3B, -$46              ; draw, y, x 
                    DB       $FF, -$01, -$4C              ; draw, y, x 
                    DB       $FF, -$01, -$4C              ; draw, y, x 
                    DB       $FF, -$15, +$7F              ; draw, y, x 
                    DB       $FF, -$49, -$5D              ; draw, y, x 
                    DB       $FF, +$2E, +$5C              ; draw, y, x 
                    DB       $FF, -$78, +$08              ; draw, y, x 
                    DB       $FF, +$4D, +$0F              ; draw, y, x 
                    DB       $FF, +$4C, +$0E              ; draw, y, x 
                    DB       $FF, +$3D, +$46              ; draw, y, x 
                    DB       $FF, +$3C, +$45              ; draw, y, x 
                    DB       $FF, -$50, +$0C              ; draw, y, x 
                    DB       $FF, -$50, +$0C              ; draw, y, x 
                    DB       $FF, -$41, -$27              ; draw, y, x 
                    DB       $FF, -$42, -$28              ; draw, y, x 
                    DB       $FF, +$5B, +$52              ; draw, y, x 
                    DB       $FF, -$48, +$12              ; draw, y, x 
                    DB       $FF, -$48, +$12              ; draw, y, x 
                    DB       $01, -$7F, +$31              ; sync and move to y, x 
                    DB       $00, -$7F, +$00              ; additional sync move to y, x 
                    DB       $00, -$69, +$00              ; additional sync move to y, x 
                    DB       $FF, +$49, -$08              ; draw, y, x 
                    DB       $FF, +$48, -$08              ; draw, y, x 
                    DB       $FF, -$42, +$6E              ; draw, y, x 
                    DB       $FF, +$6D, -$72              ; draw, y, x 
                    DB       $FF, +$50, -$0D              ; draw, y, x 
                    DB       $FF, +$50, -$0C              ; draw, y, x 
                    DB       $FF, -$22, +$5B              ; draw, y, x 
                    DB       $FF, -$23, +$5B              ; draw, y, x 
                    DB       $FF, -$76, +$39              ; draw, y, x 
                    DB       $FF, +$6F, -$25              ; draw, y, x 
                    DB       $FF, -$16, +$48              ; draw, y, x 
                    DB       $FF, -$16, +$49              ; draw, y, x 
                    DB       $FF, +$46, -$7F              ; draw, y, x 
                    DB       $FF, +$3A, +$7C              ; draw, y, x 
                    DB       $FF, -$1B, -$4E              ; draw, y, x 
                    DB       $FF, -$1C, -$4D              ; draw, y, x 
                    DB       $FF, +$1E, -$5E              ; draw, y, x 
                    DB       $FF, +$1D, -$5D              ; draw, y, x 
                    DB       $01, +$01, +$06              ; sync and move to y, x 
                    DB       $FF, +$3E, +$4A              ; draw, y, x 
                    DB       $FF, +$3F, +$4B              ; draw, y, x 
                    DB       $FF, -$08, +$56              ; draw, y, x 
                    DB       $FF, -$07, +$57              ; draw, y, x 
                    DB       $FF, +$13, -$49              ; draw, y, x 
                    DB       $FF, +$13, -$48              ; draw, y, x 
                    DB       $FF, +$53, +$5C              ; draw, y, x 
                    DB       $FF, -$48, -$65              ; draw, y, x 
                    DB       $FF, +$7D, -$04              ; draw, y, x 
                    DB       $FF, -$47, -$0B              ; draw, y, x 
                    DB       $FF, -$47, -$0B              ; draw, y, x 
                    DB       $FF, -$40, -$4B              ; draw, y, x 
                    DB       $FF, -$3F, -$4A              ; draw, y, x 
                    DB       $FF, +$61, -$0E              ; draw, y, x 
                    DB       $FF, +$61, -$0F              ; draw, y, x 
                    DB       $FF, +$70, +$56              ; draw, y, x 
                    DB       $FF, -$53, -$5F              ; draw, y, x 
                    DB       $FF, +$7D, -$1D              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_2: 
                    DB       $01, +$7F, -$7F              ; sync and move to y, x 
                    DB       $00, +$7F, -$02              ; additional sync move to y, x 
                    DB       $00, +$5D, +$00              ; additional sync move to y, x 
                    DB       $FF, -$7F, +$20              ; draw, y, x 
                    DB       $FF, +$1C, -$7E              ; draw, y, x 
                    DB       $FF, -$1B, +$42              ; draw, y, x 
                    DB       $FF, -$1B, +$41              ; draw, y, x 
                    DB       $FF, -$5D, +$23              ; draw, y, x 
                    DB       $FF, -$5C, +$23              ; draw, y, x 
                    DB       $FF, +$12, -$59              ; draw, y, x 
                    DB       $FF, +$13, -$5A              ; draw, y, x 
                    DB       $FF, +$7D, -$6C              ; draw, y, x 
                    DB       $FF, -$75, +$4E              ; draw, y, x 
                    DB       $FF, +$0D, -$7E              ; draw, y, x 
                    DB       $FF, -$1E, +$73              ; draw, y, x 
                    DB       $FF, -$64, -$62              ; draw, y, x 
                    DB       $FF, +$2F, +$41              ; draw, y, x 
                    DB       $FF, +$2E, +$41              ; draw, y, x 
                    DB       $FF, -$12, +$5E              ; draw, y, x 
                    DB       $FF, -$12, +$5D              ; draw, y, x 
                    DB       $01, -$06, -$17              ; sync and move to y, x 
                    DB       $FF, -$45, -$3B              ; draw, y, x 
                    DB       $FF, -$46, -$3C              ; draw, y, x 
                    DB       $FF, -$0E, -$4A              ; draw, y, x 
                    DB       $FF, -$0E, -$4B              ; draw, y, x 
                    DB       $FF, +$01, +$41              ; draw, y, x 
                    DB       $FF, +$00, +$40              ; draw, y, x 
                    DB       $FF, -$57, -$4F              ; draw, y, x 
                    DB       $FF, +$3D, +$52              ; draw, y, x 
                    DB       $FF, -$75, +$1D              ; draw, y, x 
                    DB       $FF, +$4E, +$01              ; draw, y, x 
                    DB       $FF, +$4D, +$01              ; draw, y, x 
                    DB       $FF, +$48, +$3B              ; draw, y, x 
                    DB       $FF, +$47, +$3A              ; draw, y, x 
                    DB       $FF, -$4D, +$19              ; draw, y, x 
                    DB       $FF, -$4D, +$19              ; draw, y, x 
                    DB       $FF, -$47, -$1C              ; draw, y, x 
                    DB       $FF, -$47, -$1C              ; draw, y, x 
                    DB       $FF, +$67, +$42              ; draw, y, x 
                    DB       $FF, -$43, +$1E              ; draw, y, x 
                    DB       $FF, -$44, +$1E              ; draw, y, x 
                    DB       $01, -$7F, +$6D              ; sync and move to y, x 
                    DB       $00, -$7F, +$00              ; additional sync move to y, x 
                    DB       $00, -$5B, +$00              ; additional sync move to y, x 
                    DB       $FF, +$46, -$15              ; draw, y, x 
                    DB       $FF, +$46, -$14              ; draw, y, x 
                    DB       $FF, -$2F, +$79              ; draw, y, x 
                    DB       $FF, +$2C, -$42              ; draw, y, x 
                    DB       $FF, +$2C, -$41              ; draw, y, x 
                    DB       $FF, +$4D, -$1A              ; draw, y, x 
                    DB       $FF, +$4C, -$1A              ; draw, y, x 
                    DB       $FF, -$12, +$5F              ; draw, y, x 
                    DB       $FF, -$12, +$60              ; draw, y, x 
                    DB       $FF, -$6B, +$4C              ; draw, y, x 
                    DB       $FF, +$67, -$38              ; draw, y, x 
                    DB       $FF, -$09, +$4B              ; draw, y, x 
                    DB       $FF, -$09, +$4C              ; draw, y, x 
                    DB       $FF, +$18, -$45              ; draw, y, x 
                    DB       $FF, +$17, -$44              ; draw, y, x 
                    DB       $FF, +$4D, +$70              ; draw, y, x 
                    DB       $FF, -$28, -$48              ; draw, y, x 
                    DB       $FF, -$28, -$47              ; draw, y, x 
                    DB       $FF, +$0E, -$61              ; draw, y, x 
                    DB       $FF, +$0D, -$61              ; draw, y, x 
                    DB       $01, +$02, +$06              ; sync and move to y, x 
                    DB       $FF, +$4A, +$3E              ; draw, y, x 
                    DB       $FF, +$4A, +$3F              ; draw, y, x 
                    DB       $FF, +$07, +$56              ; draw, y, x 
                    DB       $FF, +$08, +$57              ; draw, y, x 
                    DB       $FF, +$06, -$4A              ; draw, y, x 
                    DB       $FF, +$07, -$4A              ; draw, y, x 
                    DB       $FF, +$61, +$4C              ; draw, y, x 
                    DB       $FF, -$58, -$58              ; draw, y, x 
                    DB       $FF, +$7B, -$18              ; draw, y, x 
                    DB       $FF, -$48, +$01              ; draw, y, x 
                    DB       $FF, -$48, +$01              ; draw, y, x 
                    DB       $FF, -$4B, -$3F              ; draw, y, x 
                    DB       $FF, -$4B, -$3E              ; draw, y, x 
                    DB       $FF, +$5D, -$1F              ; draw, y, x 
                    DB       $FF, +$5D, -$1F              ; draw, y, x 
                    DB       $FF, +$7D, +$42              ; draw, y, x 
                    DB       $FF, -$62, -$50              ; draw, y, x 
                    DB       $FF, +$76, -$32              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_3: 
                    DB       $01, +$7F, -$7F              ; sync and move to y, x 
                    DB       $00, +$7F, -$3B              ; additional sync move to y, x 
                    DB       $00, +$42, +$00              ; additional sync move to y, x 
                    DB       $FF, -$77, +$35              ; draw, y, x 
                    DB       $FF, +$02, -$40              ; draw, y, x 
                    DB       $FF, +$03, -$41              ; draw, y, x 
                    DB       $FF, -$10, +$46              ; draw, y, x 
                    DB       $FF, -$0F, +$45              ; draw, y, x 
                    DB       $FF, -$55, +$32              ; draw, y, x 
                    DB       $FF, -$55, +$31              ; draw, y, x 
                    DB       $FF, +$03, -$5B              ; draw, y, x 
                    DB       $FF, +$03, -$5B              ; draw, y, x 
                    DB       $FF, +$69, -$7F              ; draw, y, x 
                    DB       $FF, -$66, +$60              ; draw, y, x 
                    DB       $FF, -$08, -$7E              ; draw, y, x 
                    DB       $FF, -$0A, +$76              ; draw, y, x 
                    DB       $FF, -$74, -$50              ; draw, y, x 
                    DB       $FF, +$72, +$71              ; draw, y, x 
                    DB       $FF, -$02, +$5F              ; draw, y, x 
                    DB       $FF, -$02, +$5F              ; draw, y, x 
                    DB       $01, -$0A, -$16              ; sync and move to y, x 
                    DB       $FF, -$4E, -$2E              ; draw, y, x 
                    DB       $FF, -$4F, -$2F              ; draw, y, x 
                    DB       $FF, -$1A, -$47              ; draw, y, x 
                    DB       $FF, -$1B, -$48              ; draw, y, x 
                    DB       $FF, +$17, +$7F              ; draw, y, x 
                    DB       $FF, -$63, -$3F              ; draw, y, x 
                    DB       $FF, +$4A, +$47              ; draw, y, x 
                    DB       $FF, -$6F, +$30              ; draw, y, x 
                    DB       $FF, +$4D, -$0C              ; draw, y, x 
                    DB       $FF, +$4D, -$0C              ; draw, y, x 
                    DB       $FF, +$51, +$2E              ; draw, y, x 
                    DB       $FF, +$50, +$2D              ; draw, y, x 
                    DB       $FF, -$48, +$25              ; draw, y, x 
                    DB       $FF, -$48, +$26              ; draw, y, x 
                    DB       $FF, -$4B, -$0F              ; draw, y, x 
                    DB       $FF, -$4B, -$0F              ; draw, y, x 
                    DB       $FF, +$71, +$2E              ; draw, y, x 
                    DB       $FF, -$7B, +$53              ; draw, y, x 
                    DB       $01, -$7F, +$7F              ; sync and move to y, x 
                    DB       $00, -$7F, +$27              ; additional sync move to y, x 
                    DB       $00, -$44, +$00              ; additional sync move to y, x 
                    DB       $FF, +$42, -$20              ; draw, y, x 
                    DB       $FF, +$41, -$20              ; draw, y, x 
                    DB       $FF, -$19, +$7E              ; draw, y, x 
                    DB       $FF, +$20, -$48              ; draw, y, x 
                    DB       $FF, +$20, -$47              ; draw, y, x 
                    DB       $FF, +$47, -$27              ; draw, y, x 
                    DB       $FF, +$47, -$26              ; draw, y, x 
                    DB       $FF, -$01, +$61              ; draw, y, x 
                    DB       $FF, -$02, +$61              ; draw, y, x 
                    DB       $FF, -$5D, +$5D              ; draw, y, x 
                    DB       $FF, +$5D, -$48              ; draw, y, x 
                    DB       $FF, +$04, +$4C              ; draw, y, x 
                    DB       $FF, +$03, +$4C              ; draw, y, x 
                    DB       $FF, +$0B, -$48              ; draw, y, x 
                    DB       $FF, +$0C, -$48              ; draw, y, x 
                    DB       $FF, +$60, +$62              ; draw, y, x 
                    DB       $FF, -$34, -$40              ; draw, y, x 
                    DB       $FF, -$34, -$40              ; draw, y, x 
                    DB       $FF, -$03, -$62              ; draw, y, x 
                    DB       $FF, -$03, -$62              ; draw, y, x 
                    DB       $01, +$03, +$05              ; sync and move to y, x 
                    DB       $FF, +$53, +$31              ; draw, y, x 
                    DB       $FF, +$54, +$32              ; draw, y, x 
                    DB       $FF, +$16, +$54              ; draw, y, x 
                    DB       $FF, +$16, +$54              ; draw, y, x 
                    DB       $FF, -$06, -$4B              ; draw, y, x 
                    DB       $FF, -$06, -$4A              ; draw, y, x 
                    DB       $FF, +$6C, +$3B              ; draw, y, x 
                    DB       $FF, -$66, -$48              ; draw, y, x 
                    DB       $FF, +$75, -$2C              ; draw, y, x 
                    DB       $FF, -$47, +$0D              ; draw, y, x 
                    DB       $FF, -$46, +$0D              ; draw, y, x 
                    DB       $FF, -$55, -$31              ; draw, y, x 
                    DB       $FF, -$54, -$31              ; draw, y, x 
                    DB       $FF, +$56, -$2E              ; draw, y, x 
                    DB       $FF, +$57, -$2E              ; draw, y, x 
                    DB       $FF, +$43, +$16              ; draw, y, x 
                    DB       $FF, +$44, +$16              ; draw, y, x 
                    DB       $FF, -$6F, -$3E              ; draw, y, x 
                    DB       $FF, +$6C, -$46              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_4: 
                    DB       $01, +$7F, -$7F              ; sync and move to y, x 
                    DB       $00, +$7F, -$6E              ; additional sync move to y, x 
                    DB       $00, +$1E, +$00              ; additional sync move to y, x 
                    DB       $FF, -$6D, +$48              ; draw, y, x 
                    DB       $FF, -$08, -$40              ; draw, y, x 
                    DB       $FF, -$08, -$40              ; draw, y, x 
                    DB       $FF, -$04, +$47              ; draw, y, x 
                    DB       $FF, -$03, +$47              ; draw, y, x 
                    DB       $FF, -$4C, +$40              ; draw, y, x 
                    DB       $FF, -$4B, +$3F              ; draw, y, x 
                    DB       $FF, -$0C, -$5A              ; draw, y, x 
                    DB       $FF, -$0D, -$5A              ; draw, y, x 
                    DB       $FF, +$29, -$48              ; draw, y, x 
                    DB       $FF, +$29, -$48              ; draw, y, x 
                    DB       $FF, -$54, +$70              ; draw, y, x 
                    DB       $FF, -$1E, -$7B              ; draw, y, x 
                    DB       $FF, +$0B, +$76              ; draw, y, x 
                    DB       $FF, -$40, -$1D              ; draw, y, x 
                    DB       $FF, -$40, -$1E              ; draw, y, x 
                    DB       $FF, +$42, +$2E              ; draw, y, x 
                    DB       $FF, +$41, +$2E              ; draw, y, x 
                    DB       $FF, +$0E, +$5E              ; draw, y, x 
                    DB       $FF, +$0E, +$5E              ; draw, y, x 
                    DB       $01, -$0E, -$14              ; sync and move to y, x 
                    DB       $FF, -$55, -$20              ; draw, y, x 
                    DB       $FF, -$55, -$21              ; draw, y, x 
                    DB       $FF, -$26, -$42              ; draw, y, x 
                    DB       $FF, -$26, -$42              ; draw, y, x 
                    DB       $FF, +$2C, +$79              ; draw, y, x 
                    DB       $FF, -$6D, -$2D              ; draw, y, x 
                    DB       $FF, +$55, +$39              ; draw, y, x 
                    DB       $FF, -$65, +$42              ; draw, y, x 
                    DB       $FF, +$4A, -$19              ; draw, y, x 
                    DB       $FF, +$4A, -$19              ; draw, y, x 
                    DB       $FF, +$57, +$20              ; draw, y, x 
                    DB       $FF, +$57, +$1F              ; draw, y, x 
                    DB       $FF, -$40, +$31              ; draw, y, x 
                    DB       $FF, -$41, +$32              ; draw, y, x 
                    DB       $FF, -$4C, -$03              ; draw, y, x 
                    DB       $FF, -$4D, -$02              ; draw, y, x 
                    DB       $FF, +$77, +$1B              ; draw, y, x 
                    DB       $FF, -$6B, +$66              ; draw, y, x 
                    DB       $01, -$7F, +$7F              ; sync and move to y, x 
                    DB       $00, -$7F, +$5B              ; additional sync move to y, x 
                    DB       $00, -$23, +$00              ; additional sync move to y, x 
                    DB       $FF, +$76, -$55              ; draw, y, x 
                    DB       $FF, -$01, +$40              ; draw, y, x 
                    DB       $FF, -$02, +$41              ; draw, y, x 
                    DB       $FF, +$14, -$4D              ; draw, y, x 
                    DB       $FF, +$13, -$4C              ; draw, y, x 
                    DB       $FF, +$7F, -$64              ; draw, y, x 
                    DB       $FF, +$0E, +$60              ; draw, y, x 
                    DB       $FF, +$0F, +$60              ; draw, y, x 
                    DB       $FF, -$4B, +$6C              ; draw, y, x 
                    DB       $FF, +$4F, -$57              ; draw, y, x 
                    DB       $FF, +$10, +$4A              ; draw, y, x 
                    DB       $FF, +$10, +$4A              ; draw, y, x 
                    DB       $FF, -$01, -$49              ; draw, y, x 
                    DB       $FF, +$00, -$48              ; draw, y, x 
                    DB       $FF, +$6F, +$50              ; draw, y, x 
                    DB       $FF, -$7C, -$6C              ; draw, y, x 
                    DB       $FF, -$14, -$60              ; draw, y, x 
                    DB       $FF, -$13, -$60              ; draw, y, x 
                    DB       $01, +$04, +$05              ; sync and move to y, x 
                    DB       $FF, +$5B, +$22              ; draw, y, x 
                    DB       $FF, +$5B, +$23              ; draw, y, x 
                    DB       $FF, +$23, +$4F              ; draw, y, x 
                    DB       $FF, +$24, +$4F              ; draw, y, x 
                    DB       $FF, -$13, -$49              ; draw, y, x 
                    DB       $FF, -$12, -$48              ; draw, y, x 
                    DB       $FF, +$74, +$28              ; draw, y, x 
                    DB       $FF, -$70, -$35              ; draw, y, x 
                    DB       $FF, +$6C, -$40              ; draw, y, x 
                    DB       $FF, -$44, +$18              ; draw, y, x 
                    DB       $FF, -$43, +$19              ; draw, y, x 
                    DB       $FF, -$5C, -$22              ; draw, y, x 
                    DB       $FF, -$5B, -$21              ; draw, y, x 
                    DB       $FF, +$4D, -$3C              ; draw, y, x 
                    DB       $FF, +$4E, -$3D              ; draw, y, x 
                    DB       $FF, +$46, +$0B              ; draw, y, x 
                    DB       $FF, +$46, +$0A              ; draw, y, x 
                    DB       $FF, -$77, -$2A              ; draw, y, x 
                    DB       $FF, +$5E, -$57              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_5: 
                    DB       $01, +$7F, -$7F              ; sync and move to y, x 
                    DB       $00, +$71, -$7F              ; additional sync move to y, x 
                    DB       $00, +$00, -$1C              ; additional sync move to y, x 
                    DB       $FF, -$5F, +$5A              ; draw, y, x 
                    DB       $FF, -$26, -$7C              ; draw, y, x 
                    DB       $FF, +$08, +$47              ; draw, y, x 
                    DB       $FF, +$09, +$47              ; draw, y, x 
                    DB       $FF, -$40, +$4B              ; draw, y, x 
                    DB       $FF, -$3F, +$4B              ; draw, y, x 
                    DB       $FF, -$1B, -$57              ; draw, y, x 
                    DB       $FF, -$1C, -$57              ; draw, y, x 
                    DB       $FF, +$1D, -$4D              ; draw, y, x 
                    DB       $FF, +$1C, -$4E              ; draw, y, x 
                    DB       $FF, -$41, +$7D              ; draw, y, x 
                    DB       $FF, -$31, -$74              ; draw, y, x 
                    DB       $FF, +$1D, +$72              ; draw, y, x 
                    DB       $FF, -$43, -$12              ; draw, y, x 
                    DB       $FF, -$44, -$12              ; draw, y, x 
                    DB       $FF, +$49, +$22              ; draw, y, x 
                    DB       $FF, +$48, +$22              ; draw, y, x 
                    DB       $FF, +$1E, +$5B              ; draw, y, x 
                    DB       $FF, +$1D, +$5A              ; draw, y, x 
                    DB       $01, -$11, -$11              ; sync and move to y, x 
                    DB       $FF, -$59, -$12              ; draw, y, x 
                    DB       $FF, -$5A, -$12              ; draw, y, x 
                    DB       $FF, -$61, -$75              ; draw, y, x 
                    DB       $FF, +$40, +$70              ; draw, y, x 
                    DB       $FF, -$73, -$1A              ; draw, y, x 
                    DB       $FF, +$5D, +$2A              ; draw, y, x 
                    DB       $FF, -$58, +$52              ; draw, y, x 
                    DB       $FF, +$45, -$25              ; draw, y, x 
                    DB       $FF, +$44, -$25              ; draw, y, x 
                    DB       $FF, +$5B, +$10              ; draw, y, x 
                    DB       $FF, +$5B, +$10              ; draw, y, x 
                    DB       $FF, -$6E, +$77              ; draw, y, x 
                    DB       $FF, -$4C, +$0A              ; draw, y, x 
                    DB       $FF, -$4C, +$0B              ; draw, y, x 
                    DB       $FF, +$7B, +$07              ; draw, y, x 
                    DB       $FF, -$59, +$77              ; draw, y, x 
                    DB       $01, -$7F, +$7F              ; sync and move to y, x 
                    DB       $00, -$79, +$7F              ; additional sync move to y, x 
                    DB       $00, +$00, +$0A              ; additional sync move to y, x 
                    DB       $FF, +$66, -$68              ; draw, y, x 
                    DB       $FF, +$12, +$7F              ; draw, y, x 
                    DB       $FF, +$07, -$4E              ; draw, y, x 
                    DB       $FF, +$06, -$4E              ; draw, y, x 
                    DB       $FF, +$6D, -$79              ; draw, y, x 
                    DB       $FF, +$1E, +$5C              ; draw, y, x 
                    DB       $FF, +$1F, +$5D              ; draw, y, x 
                    DB       $FF, -$38, +$76              ; draw, y, x 
                    DB       $FF, +$3F, -$63              ; draw, y, x 
                    DB       $FF, +$1C, +$46              ; draw, y, x 
                    DB       $FF, +$1D, +$47              ; draw, y, x 
                    DB       $FF, -$0D, -$48              ; draw, y, x 
                    DB       $FF, -$0D, -$47              ; draw, y, x 
                    DB       $FF, +$7B, +$3C              ; draw, y, x 
                    DB       $FF, -$46, -$2B              ; draw, y, x 
                    DB       $FF, -$46, -$2B              ; draw, y, x 
                    DB       $FF, -$24, -$5B              ; draw, y, x 
                    DB       $FF, -$23, -$5B              ; draw, y, x 
                    DB       $01, +$05, +$04              ; sync and move to y, x 
                    DB       $FF, +$5F, +$12              ; draw, y, x 
                    DB       $FF, +$5F, +$13              ; draw, y, x 
                    DB       $FF, +$30, +$48              ; draw, y, x 
                    DB       $FF, +$31, +$48              ; draw, y, x 
                    DB       $FF, -$1F, -$44              ; draw, y, x 
                    DB       $FF, -$1E, -$44              ; draw, y, x 
                    DB       $FF, +$7A, +$13              ; draw, y, x 
                    DB       $FF, -$78, -$21              ; draw, y, x 
                    DB       $FF, +$60, -$51              ; draw, y, x 
                    DB       $FF, -$7D, +$47              ; draw, y, x 
                    DB       $FF, -$60, -$12              ; draw, y, x 
                    DB       $FF, -$60, -$12              ; draw, y, x 
                    DB       $FF, +$42, -$48              ; draw, y, x 
                    DB       $FF, +$43, -$48              ; draw, y, x 
                    DB       $FF, +$46, -$02              ; draw, y, x 
                    DB       $FF, +$47, -$02              ; draw, y, x 
                    DB       $FF, -$7D, -$15              ; draw, y, x 
                    DB       $FF, +$4F, -$66              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_6: 
                    DB       $01, +$7F, -$7F              ; sync and move to y, x 
                    DB       $00, +$3E, -$7F              ; additional sync move to y, x 
                    DB       $00, +$00, -$40              ; additional sync move to y, x 
                    DB       $FF, -$4E, +$68              ; draw, y, x 
                    DB       $FF, -$3B, -$73              ; draw, y, x 
                    DB       $FF, +$14, +$44              ; draw, y, x 
                    DB       $FF, +$15, +$44              ; draw, y, x 
                    DB       $FF, -$32, +$55              ; draw, y, x 
                    DB       $FF, -$32, +$55              ; draw, y, x 
                    DB       $FF, -$29, -$51              ; draw, y, x 
                    DB       $FF, -$2A, -$51              ; draw, y, x 
                    DB       $FF, +$0F, -$51              ; draw, y, x 
                    DB       $FF, +$0E, -$51              ; draw, y, x 
                    DB       $FF, -$15, +$43              ; draw, y, x 
                    DB       $FF, -$15, +$42              ; draw, y, x 
                    DB       $FF, -$45, -$6A              ; draw, y, x 
                    DB       $FF, +$31, +$6C              ; draw, y, x 
                    DB       $FF, -$46, -$06              ; draw, y, x 
                    DB       $FF, -$46, -$07              ; draw, y, x 
                    DB       $FF, +$4D, +$16              ; draw, y, x 
                    DB       $FF, +$4D, +$15              ; draw, y, x 
                    DB       $FF, +$2D, +$54              ; draw, y, x 
                    DB       $FF, +$2D, +$54              ; draw, y, x 
                    DB       $01, -$13, -$0E              ; sync and move to y, x 
                    DB       $FF, -$5B, -$02              ; draw, y, x 
                    DB       $FF, -$5C, -$03              ; draw, y, x 
                    DB       $FF, -$73, -$63              ; draw, y, x 
                    DB       $FF, +$52, +$64              ; draw, y, x 
                    DB       $FF, -$76, -$07              ; draw, y, x 
                    DB       $FF, +$63, +$1A              ; draw, y, x 
                    DB       $FF, -$49, +$60              ; draw, y, x 
                    DB       $FF, +$7A, -$60              ; draw, y, x 
                    DB       $FF, +$5D, +$00              ; draw, y, x 
                    DB       $FF, +$5C, +$01              ; draw, y, x 
                    DB       $FF, -$2C, +$44              ; draw, y, x 
                    DB       $FF, -$2C, +$44              ; draw, y, x 
                    DB       $FF, -$49, +$17              ; draw, y, x 
                    DB       $FF, -$49, +$17              ; draw, y, x 
                    DB       $FF, +$79, -$0E              ; draw, y, x 
                    DB       $FF, -$21, +$42              ; draw, y, x 
                    DB       $FF, -$22, +$42              ; draw, y, x 
                    DB       $01, -$7F, +$7F              ; sync and move to y, x 
                    DB       $00, -$49, +$7F              ; additional sync move to y, x 
                    DB       $00, +$00, +$30              ; additional sync move to y, x 
                    DB       $FF, +$53, -$78              ; draw, y, x 
                    DB       $FF, +$28, +$7B              ; draw, y, x 
                    DB       $FF, -$07, -$4F              ; draw, y, x 
                    DB       $FF, -$07, -$4E              ; draw, y, x 
                    DB       $FF, +$2B, -$45              ; draw, y, x 
                    DB       $FF, +$2B, -$44              ; draw, y, x 
                    DB       $FF, +$2E, +$56              ; draw, y, x 
                    DB       $FF, +$2E, +$56              ; draw, y, x 
                    DB       $FF, -$23, +$7E              ; draw, y, x 
                    DB       $FF, +$2D, -$6C              ; draw, y, x 
                    DB       $FF, +$28, +$40              ; draw, y, x 
                    DB       $FF, +$28, +$41              ; draw, y, x 
                    DB       $FF, -$19, -$44              ; draw, y, x 
                    DB       $FF, -$19, -$44              ; draw, y, x 
                    DB       $FF, +$42, +$13              ; draw, y, x 
                    DB       $FF, +$42, +$13              ; draw, y, x 
                    DB       $FF, -$4D, -$1F              ; draw, y, x 
                    DB       $FF, -$4C, -$1E              ; draw, y, x 
                    DB       $FF, -$33, -$54              ; draw, y, x 
                    DB       $FF, -$32, -$54              ; draw, y, x 
                    DB       $01, +$05, +$03              ; sync and move to y, x 
                    DB       $FF, +$61, +$02              ; draw, y, x 
                    DB       $FF, +$62, +$03              ; draw, y, x 
                    DB       $FF, +$78, +$7D              ; draw, y, x 
                    DB       $FF, -$54, -$7C              ; draw, y, x 
                    DB       $FF, +$7B, -$01              ; draw, y, x 
                    DB       $FF, -$7B, -$0D              ; draw, y, x 
                    DB       $FF, +$50, -$60              ; draw, y, x 
                    DB       $FF, -$6E, +$5B              ; draw, y, x 
                    DB       $FF, -$62, -$01              ; draw, y, x 
                    DB       $FF, -$62, -$02              ; draw, y, x 
                    DB       $FF, +$35, -$52              ; draw, y, x 
                    DB       $FF, +$35, -$52              ; draw, y, x 
                    DB       $FF, +$45, -$0E              ; draw, y, x 
                    DB       $FF, +$46, -$0E              ; draw, y, x 
                    DB       $FF, -$7E, +$00              ; draw, y, x 
                    DB       $FF, +$3C, -$71              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_7: 
                    DB       $01, +$7F, -$7F              ; sync and move to y, x 
                    DB       $00, +$05, -$7F              ; additional sync move to y, x 
                    DB       $00, +$00, -$5C              ; additional sync move to y, x 
                    DB       $FF, -$3B, +$75              ; draw, y, x 
                    DB       $FF, -$4D, -$69              ; draw, y, x 
                    DB       $FF, +$1F, +$40              ; draw, y, x 
                    DB       $FF, +$20, +$40              ; draw, y, x 
                    DB       $FF, -$23, +$5C              ; draw, y, x 
                    DB       $FF, -$23, +$5C              ; draw, y, x 
                    DB       $FF, -$36, -$48              ; draw, y, x 
                    DB       $FF, -$37, -$49              ; draw, y, x 
                    DB       $FF, +$01, -$52              ; draw, y, x 
                    DB       $FF, +$00, -$53              ; draw, y, x 
                    DB       $FF, -$09, +$46              ; draw, y, x 
                    DB       $FF, -$0A, +$45              ; draw, y, x 
                    DB       $FF, -$55, -$5D              ; draw, y, x 
                    DB       $FF, +$42, +$62              ; draw, y, x 
                    DB       $FF, -$46, +$05              ; draw, y, x 
                    DB       $FF, -$46, +$05              ; draw, y, x 
                    DB       $FF, +$50, +$09              ; draw, y, x 
                    DB       $FF, +$4F, +$08              ; draw, y, x 
                    DB       $FF, +$3A, +$4B              ; draw, y, x 
                    DB       $FF, +$3A, +$4B              ; draw, y, x 
                    DB       $01, -$16, -$0B              ; sync and move to y, x 
                    DB       $FF, -$5A, +$0D              ; draw, y, x 
                    DB       $FF, -$5A, +$0E              ; draw, y, x 
                    DB       $FF, -$41, -$27              ; draw, y, x 
                    DB       $FF, -$42, -$28              ; draw, y, x 
                    DB       $FF, +$62, +$55              ; draw, y, x 
                    DB       $FF, -$76, +$0D              ; draw, y, x 
                    DB       $FF, +$67, +$09              ; draw, y, x 
                    DB       $FF, -$38, +$6B              ; draw, y, x 
                    DB       $FF, +$68, -$74              ; draw, y, x 
                    DB       $FF, +$5C, -$0F              ; draw, y, x 
                    DB       $FF, +$5B, -$0F              ; draw, y, x 
                    DB       $FF, -$20, +$4A              ; draw, y, x 
                    DB       $FF, -$20, +$4B              ; draw, y, x 
                    DB       $FF, -$44, +$23              ; draw, y, x 
                    DB       $FF, -$44, +$23              ; draw, y, x 
                    DB       $FF, +$75, -$22              ; draw, y, x 
                    DB       $FF, -$16, +$46              ; draw, y, x 
                    DB       $FF, -$16, +$47              ; draw, y, x 
                    DB       $01, -$7F, +$7F              ; sync and move to y, x 
                    DB       $00, -$13, +$7F              ; additional sync move to y, x 
                    DB       $00, +$00, +$4D              ; additional sync move to y, x 
                    DB       $FF, +$1F, -$42              ; draw, y, x 
                    DB       $FF, +$1F, -$42              ; draw, y, x 
                    DB       $FF, +$3B, +$72              ; draw, y, x 
                    DB       $FF, -$14, -$4C              ; draw, y, x 
                    DB       $FF, -$14, -$4C              ; draw, y, x 
                    DB       $FF, +$1F, -$4B              ; draw, y, x 
                    DB       $FF, +$1F, -$4A              ; draw, y, x 
                    DB       $FF, +$3C, +$4C              ; draw, y, x 
                    DB       $FF, +$3C, +$4D              ; draw, y, x 
                    DB       $FF, -$07, +$41              ; draw, y, x 
                    DB       $FF, -$07, +$42              ; draw, y, x 
                    DB       $FF, +$1B, -$73              ; draw, y, x 
                    DB       $FF, +$65, +$72              ; draw, y, x 
                    DB       $FF, -$49, -$7E              ; draw, y, x 
                    DB       $FF, +$44, +$08              ; draw, y, x 
                    DB       $FF, +$44, +$08              ; draw, y, x 
                    DB       $FF, -$51, -$11              ; draw, y, x 
                    DB       $FF, -$50, -$11              ; draw, y, x 
                    DB       $FF, -$40, -$4B              ; draw, y, x 
                    DB       $FF, -$3F, -$4A              ; draw, y, x 
                    DB       $01, +$06, +$02              ; sync and move to y, x 
                    DB       $FF, +$60, -$0E              ; draw, y, x 
                    DB       $FF, +$60, -$0E              ; draw, y, x 
                    DB       $FF, +$45, +$33              ; draw, y, x 
                    DB       $FF, +$46, +$34              ; draw, y, x 
                    DB       $FF, -$67, -$6C              ; draw, y, x 
                    DB       $FF, +$7A, -$16              ; draw, y, x 
                    DB       $FF, -$7D, +$08              ; draw, y, x 
                    DB       $FF, +$3F, -$6C              ; draw, y, x 
                    DB       $FF, -$5D, +$6D              ; draw, y, x 
                    DB       $FF, -$61, +$0F              ; draw, y, x 
                    DB       $FF, -$60, +$0F              ; draw, y, x 
                    DB       $FF, +$26, -$5A              ; draw, y, x 
                    DB       $FF, +$27, -$5A              ; draw, y, x 
                    DB       $FF, +$42, -$19              ; draw, y, x 
                    DB       $FF, +$42, -$1A              ; draw, y, x 
                    DB       $FF, -$7D, +$15              ; draw, y, x 
                    DB       $FF, +$28, -$7A              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_8: 
                    DB       $01, +$48, -$7F              ; sync and move to y, x 
                    DB       $00, +$00, -$7F              ; additional sync move to y, x 
                    DB       $00, +$00, -$6D              ; additional sync move to y, x 
                    DB       $FF, -$27, +$7D              ; draw, y, x 
                    DB       $FF, -$5D, -$5A              ; draw, y, x 
                    DB       $FF, +$53, +$73              ; draw, y, x 
                    DB       $FF, -$13, +$61              ; draw, y, x 
                    DB       $FF, -$12, +$61              ; draw, y, x 
                    DB       $FF, -$42, -$3E              ; draw, y, x 
                    DB       $FF, -$43, -$3F              ; draw, y, x 
                    DB       $FF, -$0D, -$51              ; draw, y, x 
                    DB       $FF, -$0D, -$52              ; draw, y, x 
                    DB       $FF, +$02, +$46              ; draw, y, x 
                    DB       $FF, +$02, +$46              ; draw, y, x 
                    DB       $FF, -$64, -$4D              ; draw, y, x 
                    DB       $FF, +$52, +$55              ; draw, y, x 
                    DB       $FF, -$44, +$11              ; draw, y, x 
                    DB       $FF, -$44, +$11              ; draw, y, x 
                    DB       $FF, +$50, -$05              ; draw, y, x 
                    DB       $FF, +$50, -$05              ; draw, y, x 
                    DB       $FF, +$46, +$40              ; draw, y, x 
                    DB       $FF, +$46, +$40              ; draw, y, x 
                    DB       $01, -$17, -$07              ; sync and move to y, x 
                    DB       $FF, -$57, +$1C              ; draw, y, x 
                    DB       $FF, -$57, +$1D              ; draw, y, x 
                    DB       $FF, -$46, -$1C              ; draw, y, x 
                    DB       $FF, -$47, -$1B              ; draw, y, x 
                    DB       $FF, +$6E, +$42              ; draw, y, x 
                    DB       $FF, -$72, +$21              ; draw, y, x 
                    DB       $FF, +$67, -$09              ; draw, y, x 
                    DB       $FF, -$25, +$73              ; draw, y, x 
                    DB       $FF, +$2A, -$42              ; draw, y, x 
                    DB       $FF, +$29, -$41              ; draw, y, x 
                    DB       $FF, +$58, -$1F              ; draw, y, x 
                    DB       $FF, +$57, -$1E              ; draw, y, x 
                    DB       $FF, -$13, +$4F              ; draw, y, x 
                    DB       $FF, -$13, +$4F              ; draw, y, x 
                    DB       $FF, -$7A, +$5C              ; draw, y, x 
                    DB       $FF, +$6D, -$36              ; draw, y, x 
                    DB       $FF, -$09, +$49              ; draw, y, x 
                    DB       $FF, -$0A, +$4A              ; draw, y, x 
                    DB       $01, -$58, +$7F              ; sync and move to y, x 
                    DB       $00, +$00, +$7F              ; additional sync move to y, x 
                    DB       $00, +$00, +$61              ; additional sync move to y, x 
                    DB       $FF, +$14, -$47              ; draw, y, x 
                    DB       $FF, +$13, -$46              ; draw, y, x 
                    DB       $FF, +$4E, +$67              ; draw, y, x 
                    DB       $FF, -$21, -$48              ; draw, y, x 
                    DB       $FF, -$21, -$47              ; draw, y, x 
                    DB       $FF, +$12, -$4F              ; draw, y, x 
                    DB       $FF, +$12, -$4F              ; draw, y, x 
                    DB       $FF, +$48, +$41              ; draw, y, x 
                    DB       $FF, +$48, +$42              ; draw, y, x 
                    DB       $FF, +$04, +$41              ; draw, y, x 
                    DB       $FF, +$05, +$42              ; draw, y, x 
                    DB       $FF, +$06, -$75              ; draw, y, x 
                    DB       $FF, +$77, +$5F              ; draw, y, x 
                    DB       $FF, -$5C, -$70              ; draw, y, x 
                    DB       $FF, +$44, -$04              ; draw, y, x 
                    DB       $FF, +$44, -$03              ; draw, y, x 
                    DB       $FF, -$52, -$04              ; draw, y, x 
                    DB       $FF, -$52, -$03              ; draw, y, x 
                    DB       $FF, -$4C, -$3F              ; draw, y, x 
                    DB       $FF, -$4B, -$3E              ; draw, y, x 
                    DB       $01, +$06, +$01              ; sync and move to y, x 
                    DB       $FF, +$5C, -$1E              ; draw, y, x 
                    DB       $FF, +$5D, -$1E              ; draw, y, x 
                    DB       $FF, +$4D, +$27              ; draw, y, x 
                    DB       $FF, +$4E, +$27              ; draw, y, x 
                    DB       $FF, -$78, -$59              ; draw, y, x 
                    DB       $FF, +$73, -$2B              ; draw, y, x 
                    DB       $FF, -$78, +$1E              ; draw, y, x 
                    DB       $FF, +$2B, -$76              ; draw, y, x 
                    DB       $FF, -$49, +$7B              ; draw, y, x 
                    DB       $FF, -$5D, +$20              ; draw, y, x 
                    DB       $FF, -$5D, +$1F              ; draw, y, x 
                    DB       $FF, +$17, -$5F              ; draw, y, x 
                    DB       $FF, +$17, -$60              ; draw, y, x 
                    DB       $FF, +$79, -$48              ; draw, y, x 
                    DB       $FF, -$77, +$2A              ; draw, y, x 
                    DB       $FF, +$13, -$7F              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_9: 
                    DB       $01, +$0A, -$7F              ; sync and move to y, x 
                    DB       $00, +$00, -$7F              ; additional sync move to y, x 
                    DB       $00, +$00, -$74              ; additional sync move to y, x 
                    DB       $FF, -$09, +$41              ; draw, y, x 
                    DB       $FF, -$09, +$40              ; draw, y, x 
                    DB       $FF, -$6B, -$48              ; draw, y, x 
                    DB       $FF, +$66, +$63              ; draw, y, x 
                    DB       $FF, -$02, +$63              ; draw, y, x 
                    DB       $FF, -$02, +$62              ; draw, y, x 
                    DB       $FF, -$4C, -$32              ; draw, y, x 
                    DB       $FF, -$4C, -$32              ; draw, y, x 
                    DB       $FF, -$1B, -$4E              ; draw, y, x 
                    DB       $FF, -$1B, -$4F              ; draw, y, x 
                    DB       $FF, +$0F, +$45              ; draw, y, x 
                    DB       $FF, +$0E, +$45              ; draw, y, x 
                    DB       $FF, -$70, -$3B              ; draw, y, x 
                    DB       $FF, +$5F, +$46              ; draw, y, x 
                    DB       $FF, -$40, +$1D              ; draw, y, x 
                    DB       $FF, -$40, +$1C              ; draw, y, x 
                    DB       $FF, +$4E, -$13              ; draw, y, x 
                    DB       $FF, +$4D, -$13              ; draw, y, x 
                    DB       $FF, +$50, +$34              ; draw, y, x 
                    DB       $FF, +$50, +$33              ; draw, y, x 
                    DB       $01, -$18, -$03              ; sync and move to y, x 
                    DB       $FF, -$51, +$2A              ; draw, y, x 
                    DB       $FF, -$51, +$2B              ; draw, y, x 
                    DB       $FF, -$4A, -$0F              ; draw, y, x 
                    DB       $FF, -$4B, -$0F              ; draw, y, x 
                    DB       $FF, +$79, +$2F              ; draw, y, x 
                    DB       $FF, -$6B, +$34              ; draw, y, x 
                    DB       $FF, +$64, -$1A              ; draw, y, x 
                    DB       $FF, -$12, +$77              ; draw, y, x 
                    DB       $FF, +$1F, -$48              ; draw, y, x 
                    DB       $FF, +$1E, -$47              ; draw, y, x 
                    DB       $FF, +$51, -$2D              ; draw, y, x 
                    DB       $FF, +$51, -$2D              ; draw, y, x 
                    DB       $FF, -$05, +$51              ; draw, y, x 
                    DB       $FF, -$06, +$51              ; draw, y, x 
                    DB       $FF, -$69, +$70              ; draw, y, x 
                    DB       $FF, +$63, -$48              ; draw, y, x 
                    DB       $FF, +$03, +$4A              ; draw, y, x 
                    DB       $FF, +$03, +$4A              ; draw, y, x 
                    DB       $01, -$1B, +$7F              ; sync and move to y, x 
                    DB       $00, +$00, +$7F              ; additional sync move to y, x 
                    DB       $00, +$00, +$6B              ; additional sync move to y, x 
                    DB       $FF, +$07, -$49              ; draw, y, x 
                    DB       $FF, +$07, -$48              ; draw, y, x 
                    DB       $FF, +$5E, +$58              ; draw, y, x 
                    DB       $FF, -$2C, -$41              ; draw, y, x 
                    DB       $FF, -$2C, -$41              ; draw, y, x 
                    DB       $FF, +$04, -$51              ; draw, y, x 
                    DB       $FF, +$04, -$51              ; draw, y, x 
                    DB       $FF, +$52, +$34              ; draw, y, x 
                    DB       $FF, +$52, +$35              ; draw, y, x 
                    DB       $FF, +$0F, +$40              ; draw, y, x 
                    DB       $FF, +$10, +$40              ; draw, y, x 
                    DB       $FF, -$0D, -$75              ; draw, y, x 
                    DB       $FF, +$42, +$25              ; draw, y, x 
                    DB       $FF, +$43, +$25              ; draw, y, x 
                    DB       $FF, -$6E, -$5F              ; draw, y, x 
                    DB       $FF, +$42, -$10              ; draw, y, x 
                    DB       $FF, +$43, -$0F              ; draw, y, x 
                    DB       $FF, -$52, +$0B              ; draw, y, x 
                    DB       $FF, -$51, +$0B              ; draw, y, x 
                    DB       $FF, -$55, -$31              ; draw, y, x 
                    DB       $FF, -$55, -$31              ; draw, y, x 
                    DB       $01, +$06, +$00              ; sync and move to y, x 
                    DB       $FF, +$56, -$2D              ; draw, y, x 
                    DB       $FF, +$56, -$2E              ; draw, y, x 
                    DB       $FF, +$53, +$1A              ; draw, y, x 
                    DB       $FF, +$53, +$1A              ; draw, y, x 
                    DB       $FF, -$43, -$22              ; draw, y, x 
                    DB       $FF, -$42, -$22              ; draw, y, x 
                    DB       $FF, +$6A, -$3E              ; draw, y, x 
                    DB       $FF, -$72, +$32              ; draw, y, x 
                    DB       $FF, +$18, -$7C              ; draw, y, x 
                    DB       $FF, -$1A, +$43              ; draw, y, x 
                    DB       $FF, -$1A, +$43              ; draw, y, x 
                    DB       $FF, -$56, +$2F              ; draw, y, x 
                    DB       $FF, -$56, +$2E              ; draw, y, x 
                    DB       $FF, +$06, -$62              ; draw, y, x 
                    DB       $FF, +$06, -$62              ; draw, y, x 
                    DB       $FF, +$6C, -$5B              ; draw, y, x 
                    DB       $FF, -$6F, +$3D              ; draw, y, x 
                    DB       $FF, -$01, -$40              ; draw, y, x 
                    DB       $FF, -$01, -$40              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_10: 
                    DB       $01, -$35, -$7F              ; sync and move to y, x 
                    DB       $00, +$00, -$7F              ; additional sync move to y, x 
                    DB       $00, +$00, -$70              ; additional sync move to y, x 
                    DB       $FF, +$03, +$41              ; draw, y, x 
                    DB       $FF, +$02, +$41              ; draw, y, x 
                    DB       $FF, -$76, -$35              ; draw, y, x 
                    DB       $FF, +$75, +$51              ; draw, y, x 
                    DB       $FF, +$0F, +$61              ; draw, y, x 
                    DB       $FF, +$0E, +$61              ; draw, y, x 
                    DB       $FF, -$53, -$24              ; draw, y, x 
                    DB       $FF, -$54, -$25              ; draw, y, x 
                    DB       $FF, -$27, -$48              ; draw, y, x 
                    DB       $FF, -$28, -$49              ; draw, y, x 
                    DB       $FF, +$1A, +$41              ; draw, y, x 
                    DB       $FF, +$19, +$41              ; draw, y, x 
                    DB       $FF, -$78, -$27              ; draw, y, x 
                    DB       $FF, +$6A, +$35              ; draw, y, x 
                    DB       $FF, -$75, +$4E              ; draw, y, x 
                    DB       $FF, +$4A, -$1F              ; draw, y, x 
                    DB       $FF, +$49, -$20              ; draw, y, x 
                    DB       $FF, +$58, +$25              ; draw, y, x 
                    DB       $FF, +$57, +$25              ; draw, y, x 
                    DB       $01, -$18, +$01              ; sync and move to y, x 
                    DB       $FF, -$48, +$37              ; draw, y, x 
                    DB       $FF, -$49, +$38              ; draw, y, x 
                    DB       $FF, -$4C, -$02              ; draw, y, x 
                    DB       $FF, -$4C, -$02              ; draw, y, x 
                    DB       $FF, +$7E, +$1A              ; draw, y, x 
                    DB       $FF, -$60, +$45              ; draw, y, x 
                    DB       $FF, +$5E, -$2B              ; draw, y, x 
                    DB       $FF, +$03, +$79              ; draw, y, x 
                    DB       $FF, +$12, -$4C              ; draw, y, x 
                    DB       $FF, +$11, -$4C              ; draw, y, x 
                    DB       $FF, +$49, -$3A              ; draw, y, x 
                    DB       $FF, +$48, -$39              ; draw, y, x 
                    DB       $FF, +$08, +$50              ; draw, y, x 
                    DB       $FF, +$08, +$51              ; draw, y, x 
                    DB       $FF, -$2A, +$40              ; draw, y, x 
                    DB       $FF, -$2A, +$40              ; draw, y, x 
                    DB       $FF, +$55, -$58              ; draw, y, x 
                    DB       $FF, +$0F, +$49              ; draw, y, x 
                    DB       $FF, +$10, +$49              ; draw, y, x 
                    DB       $01, +$22, +$7F              ; sync and move to y, x 
                    DB       $00, +$00, +$7F              ; additional sync move to y, x 
                    DB       $00, +$00, +$6B              ; additional sync move to y, x 
                    DB       $FF, -$06, -$49              ; draw, y, x 
                    DB       $FF, -$05, -$49              ; draw, y, x 
                    DB       $FF, +$6C, +$47              ; draw, y, x 
                    DB       $FF, -$6D, -$71              ; draw, y, x 
                    DB       $FF, -$09, -$51              ; draw, y, x 
                    DB       $FF, -$09, -$50              ; draw, y, x 
                    DB       $FF, +$59, +$26              ; draw, y, x 
                    DB       $FF, +$5A, +$26              ; draw, y, x 
                    DB       $FF, +$33, +$78              ; draw, y, x 
                    DB       $FF, -$20, -$71              ; draw, y, x 
                    DB       $FF, +$47, +$19              ; draw, y, x 
                    DB       $FF, +$48, +$19              ; draw, y, x 
                    DB       $FF, -$7C, -$4A              ; draw, y, x 
                    DB       $FF, +$7E, -$35              ; draw, y, x 
                    DB       $FF, -$4F, +$18              ; draw, y, x 
                    DB       $FF, -$4E, +$18              ; draw, y, x 
                    DB       $FF, -$5C, -$22              ; draw, y, x 
                    DB       $FF, -$5C, -$21              ; draw, y, x 
                    DB       $01, +$06, -$01              ; sync and move to y, x 
                    DB       $FF, +$4D, -$3B              ; draw, y, x 
                    DB       $FF, +$4D, -$3B              ; draw, y, x 
                    DB       $FF, +$56, +$0B              ; draw, y, x 
                    DB       $FF, +$56, +$0B              ; draw, y, x 
                    DB       $FF, -$47, -$16              ; draw, y, x 
                    DB       $FF, -$47, -$16              ; draw, y, x 
                    DB       $FF, +$5E, -$4F              ; draw, y, x 
                    DB       $FF, -$68, +$44              ; draw, y, x 
                    DB       $FF, +$02, -$7D              ; draw, y, x 
                    DB       $FF, -$0E, +$46              ; draw, y, x 
                    DB       $FF, -$0E, +$46              ; draw, y, x 
                    DB       $FF, -$4D, +$3D              ; draw, y, x 
                    DB       $FF, -$4D, +$3C              ; draw, y, x 
                    DB       $FF, -$0A, -$61              ; draw, y, x 
                    DB       $FF, -$0B, -$62              ; draw, y, x 
                    DB       $FF, +$5B, -$6C              ; draw, y, x 
                    DB       $FF, -$63, +$4F              ; draw, y, x 
                    DB       $FF, -$18, -$7E              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_11: 
                    DB       $01, -$72, -$7F              ; sync and move to y, x 
                    DB       $00, +$00, -$7F              ; additional sync move to y, x 
                    DB       $00, +$00, -$62              ; additional sync move to y, x 
                    DB       $FF, +$0E, +$40              ; draw, y, x 
                    DB       $FF, +$0D, +$40              ; draw, y, x 
                    DB       $FF, -$7E, -$21              ; draw, y, x 
                    DB       $FF, +$41, +$1E              ; draw, y, x 
                    DB       $FF, +$41, +$1E              ; draw, y, x 
                    DB       $FF, +$1F, +$5E              ; draw, y, x 
                    DB       $FF, +$1E, +$5D              ; draw, y, x 
                    DB       $FF, -$58, -$16              ; draw, y, x 
                    DB       $FF, -$59, -$16              ; draw, y, x 
                    DB       $FF, -$33, -$41              ; draw, y, x 
                    DB       $FF, -$33, -$41              ; draw, y, x 
                    DB       $FF, +$48, +$78              ; draw, y, x 
                    DB       $FF, -$7D, -$12              ; draw, y, x 
                    DB       $FF, +$72, +$22              ; draw, y, x 
                    DB       $FF, -$67, +$61              ; draw, y, x 
                    DB       $FF, +$44, -$2C              ; draw, y, x 
                    DB       $FF, +$43, -$2C              ; draw, y, x 
                    DB       $FF, +$5C, +$16              ; draw, y, x 
                    DB       $FF, +$5C, +$16              ; draw, y, x 
                    DB       $01, -$18, +$05              ; sync and move to y, x 
                    DB       $FF, -$3E, +$43              ; draw, y, x 
                    DB       $FF, -$3E, +$43              ; draw, y, x 
                    DB       $FF, -$4B, +$0A              ; draw, y, x 
                    DB       $FF, -$4B, +$0B              ; draw, y, x 
                    DB       $FF, +$41, +$02              ; draw, y, x 
                    DB       $FF, +$40, +$03              ; draw, y, x 
                    DB       $FF, -$53, +$54              ; draw, y, x 
                    DB       $FF, +$55, -$3A              ; draw, y, x 
                    DB       $FF, +$17, +$77              ; draw, y, x 
                    DB       $FF, +$05, -$4E              ; draw, y, x 
                    DB       $FF, +$04, -$4E              ; draw, y, x 
                    DB       $FF, +$3E, -$45              ; draw, y, x 
                    DB       $FF, +$3D, -$45              ; draw, y, x 
                    DB       $FF, +$16, +$4E              ; draw, y, x 
                    DB       $FF, +$16, +$4E              ; draw, y, x 
                    DB       $FF, -$1F, +$46              ; draw, y, x 
                    DB       $FF, -$1F, +$46              ; draw, y, x 
                    DB       $FF, +$46, -$64              ; draw, y, x 
                    DB       $FF, +$1B, +$45              ; draw, y, x 
                    DB       $FF, +$1C, +$45              ; draw, y, x 
                    DB       $01, +$5F, +$7F              ; sync and move to y, x 
                    DB       $00, +$00, +$7F              ; additional sync move to y, x 
                    DB       $00, +$00, +$60              ; additional sync move to y, x 
                    DB       $FF, -$12, -$47              ; draw, y, x 
                    DB       $FF, -$12, -$47              ; draw, y, x 
                    DB       $FF, +$77, +$33              ; draw, y, x 
                    DB       $FF, -$7F, -$5D              ; draw, y, x 
                    DB       $FF, -$17, -$4E              ; draw, y, x 
                    DB       $FF, -$17, -$4D              ; draw, y, x 
                    DB       $FF, +$5F, +$16              ; draw, y, x 
                    DB       $FF, +$5F, +$16              ; draw, y, x 
                    DB       $FF, +$47, +$6E              ; draw, y, x 
                    DB       $FF, -$33, -$69              ; draw, y, x 
                    DB       $FF, +$4B, +$0C              ; draw, y, x 
                    DB       $FF, +$4B, +$0D              ; draw, y, x 
                    DB       $FF, -$44, -$1B              ; draw, y, x 
                    DB       $FF, -$44, -$1A              ; draw, y, x 
                    DB       $FF, +$74, -$49              ; draw, y, x 
                    DB       $FF, -$4A, +$25              ; draw, y, x 
                    DB       $FF, -$49, +$25              ; draw, y, x 
                    DB       $FF, -$60, -$12              ; draw, y, x 
                    DB       $FF, -$60, -$11              ; draw, y, x 
                    DB       $01, +$06, -$02              ; sync and move to y, x 
                    DB       $FF, +$42, -$47              ; draw, y, x 
                    DB       $FF, +$42, -$48              ; draw, y, x 
                    DB       $FF, +$56, -$03              ; draw, y, x 
                    DB       $FF, +$57, -$04              ; draw, y, x 
                    DB       $FF, -$4A, -$09              ; draw, y, x 
                    DB       $FF, -$4A, -$0A              ; draw, y, x 
                    DB       $FF, +$50, -$5E              ; draw, y, x 
                    DB       $FF, -$5B, +$55              ; draw, y, x 
                    DB       $FF, -$13, -$7C              ; draw, y, x 
                    DB       $FF, -$02, +$48              ; draw, y, x 
                    DB       $FF, -$02, +$47              ; draw, y, x 
                    DB       $FF, -$42, +$49              ; draw, y, x 
                    DB       $FF, -$42, +$48              ; draw, y, x 
                    DB       $FF, -$1A, -$5E              ; draw, y, x 
                    DB       $FF, -$1B, -$5E              ; draw, y, x 
                    DB       $FF, +$47, -$7B              ; draw, y, x 
                    DB       $FF, -$54, +$5F              ; draw, y, x 
                    DB       $FF, -$2D, -$78              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_12: 
                    DB       $01, -$7F, -$7F              ; sync and move to y, x 
                    DB       $00, -$2D, -$7F              ; additional sync move to y, x 
                    DB       $00, +$00, -$4A              ; additional sync move to y, x 
                    DB       $FF, +$30, +$7A              ; draw, y, x 
                    DB       $FF, -$40, -$05              ; draw, y, x 
                    DB       $FF, -$41, -$06              ; draw, y, x 
                    DB       $FF, +$45, +$13              ; draw, y, x 
                    DB       $FF, +$44, +$12              ; draw, y, x 
                    DB       $FF, +$2F, +$57              ; draw, y, x 
                    DB       $FF, +$2E, +$57              ; draw, y, x 
                    DB       $FF, -$5B, -$07              ; draw, y, x 
                    DB       $FF, -$5B, -$07              ; draw, y, x 
                    DB       $FF, -$7B, -$6E              ; draw, y, x 
                    DB       $FF, +$5C, +$6A              ; draw, y, x 
                    DB       $FF, -$7E, +$03              ; draw, y, x 
                    DB       $FF, +$75, +$0F              ; draw, y, x 
                    DB       $FF, -$55, +$70              ; draw, y, x 
                    DB       $FF, +$76, -$6D              ; draw, y, x 
                    DB       $FF, +$5F, +$06              ; draw, y, x 
                    DB       $FF, +$5F, +$06              ; draw, y, x 
                    DB       $01, -$16, +$09              ; sync and move to y, x 
                    DB       $FF, -$32, +$4C              ; draw, y, x 
                    DB       $FF, -$32, +$4D              ; draw, y, x 
                    DB       $FF, -$48, +$17              ; draw, y, x 
                    DB       $FF, -$49, +$17              ; draw, y, x 
                    DB       $FF, +$40, -$09              ; draw, y, x 
                    DB       $FF, +$40, -$08              ; draw, y, x 
                    DB       $FF, -$44, +$61              ; draw, y, x 
                    DB       $FF, +$4A, -$47              ; draw, y, x 
                    DB       $FF, +$2C, +$70              ; draw, y, x 
                    DB       $FF, -$09, -$4D              ; draw, y, x 
                    DB       $FF, -$09, -$4D              ; draw, y, x 
                    DB       $FF, +$31, -$4F              ; draw, y, x 
                    DB       $FF, +$31, -$4E              ; draw, y, x 
                    DB       $FF, +$22, +$49              ; draw, y, x 
                    DB       $FF, +$23, +$49              ; draw, y, x 
                    DB       $FF, -$13, +$4A              ; draw, y, x 
                    DB       $FF, -$12, +$4B              ; draw, y, x 
                    DB       $FF, +$34, -$6F              ; draw, y, x 
                    DB       $FF, +$4D, +$7F              ; draw, y, x 
                    DB       $01, +$7F, +$7F              ; sync and move to y, x 
                    DB       $00, +$19, +$7F              ; additional sync move to y, x 
                    DB       $00, +$00, +$4B              ; additional sync move to y, x 
                    DB       $FF, -$1D, -$43              ; draw, y, x 
                    DB       $FF, -$1D, -$43              ; draw, y, x 
                    DB       $FF, +$7D, +$1F              ; draw, y, x 
                    DB       $FF, -$47, -$24              ; draw, y, x 
                    DB       $FF, -$46, -$23              ; draw, y, x 
                    DB       $FF, -$24, -$49              ; draw, y, x 
                    DB       $FF, -$23, -$48              ; draw, y, x 
                    DB       $FF, +$61, +$06              ; draw, y, x 
                    DB       $FF, +$61, +$06              ; draw, y, x 
                    DB       $FF, +$59, +$60              ; draw, y, x 
                    DB       $FF, -$44, -$5F              ; draw, y, x 
                    DB       $FF, +$4C, -$01              ; draw, y, x 
                    DB       $FF, +$4C, +$00              ; draw, y, x 
                    DB       $FF, -$47, -$0F              ; draw, y, x 
                    DB       $FF, -$47, -$0E              ; draw, y, x 
                    DB       $FF, +$65, -$5C              ; draw, y, x 
                    DB       $FF, -$42, +$31              ; draw, y, x 
                    DB       $FF, -$42, +$31              ; draw, y, x 
                    DB       $FF, -$62, -$01              ; draw, y, x 
                    DB       $FF, -$62, -$01              ; draw, y, x 
                    DB       $01, +$05, -$03              ; sync and move to y, x 
                    DB       $FF, +$35, -$51              ; draw, y, x 
                    DB       $FF, +$35, -$52              ; draw, y, x 
                    DB       $FF, +$55, -$12              ; draw, y, x 
                    DB       $FF, +$55, -$12              ; draw, y, x 
                    DB       $FF, -$4B, +$03              ; draw, y, x 
                    DB       $FF, -$4A, +$03              ; draw, y, x 
                    DB       $FF, +$3F, -$6A              ; draw, y, x 
                    DB       $FF, -$4C, +$63              ; draw, y, x 
                    DB       $FF, -$28, -$77              ; draw, y, x 
                    DB       $FF, +$0A, +$47              ; draw, y, x 
                    DB       $FF, +$0B, +$47              ; draw, y, x 
                    DB       $FF, -$35, +$53              ; draw, y, x 
                    DB       $FF, -$34, +$52              ; draw, y, x 
                    DB       $FF, -$2A, -$58              ; draw, y, x 
                    DB       $FF, -$2B, -$59              ; draw, y, x 
                    DB       $FF, +$19, -$42              ; draw, y, x 
                    DB       $FF, +$19, -$43              ; draw, y, x 
                    DB       $FF, -$43, +$6C              ; draw, y, x 
                    DB       $FF, -$41, -$6F              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_13: 
                    DB       $01, -$7F, -$7F              ; sync and move to y, x 
                    DB       $00, -$62, -$7F              ; additional sync move to y, x 
                    DB       $00, +$00, -$28              ; additional sync move to y, x 
                    DB       $FF, +$44, +$70              ; draw, y, x 
                    DB       $FF, -$40, +$05              ; draw, y, x 
                    DB       $FF, -$41, +$05              ; draw, y, x 
                    DB       $FF, +$47, +$07              ; draw, y, x 
                    DB       $FF, +$47, +$07              ; draw, y, x 
                    DB       $FF, +$3C, +$4E              ; draw, y, x 
                    DB       $FF, +$3C, +$4E              ; draw, y, x 
                    DB       $FF, -$5A, +$08              ; draw, y, x 
                    DB       $FF, -$5B, +$09              ; draw, y, x 
                    DB       $FF, -$46, -$2C              ; draw, y, x 
                    DB       $FF, -$46, -$2C              ; draw, y, x 
                    DB       $FF, +$6C, +$59              ; draw, y, x 
                    DB       $FF, -$7C, +$18              ; draw, y, x 
                    DB       $FF, +$76, -$05              ; draw, y, x 
                    DB       $FF, -$40, +$7D              ; draw, y, x 
                    DB       $FF, +$62, -$7F              ; draw, y, x 
                    DB       $FF, +$5F, -$0A              ; draw, y, x 
                    DB       $FF, +$5E, -$0A              ; draw, y, x 
                    DB       $01, -$14, +$0D              ; sync and move to y, x 
                    DB       $FF, -$24, +$54              ; draw, y, x 
                    DB       $FF, -$25, +$54              ; draw, y, x 
                    DB       $FF, -$43, +$22              ; draw, y, x 
                    DB       $FF, -$44, +$23              ; draw, y, x 
                    DB       $FF, +$7B, -$26              ; draw, y, x 
                    DB       $FF, -$32, +$6B              ; draw, y, x 
                    DB       $FF, +$3D, -$53              ; draw, y, x 
                    DB       $FF, +$3E, +$68              ; draw, y, x 
                    DB       $FF, -$16, -$4B              ; draw, y, x 
                    DB       $FF, -$16, -$4B              ; draw, y, x 
                    DB       $FF, +$23, -$56              ; draw, y, x 
                    DB       $FF, +$23, -$55              ; draw, y, x 
                    DB       $FF, +$2E, +$42              ; draw, y, x 
                    DB       $FF, +$2F, +$43              ; draw, y, x 
                    DB       $FF, -$06, +$4C              ; draw, y, x 
                    DB       $FF, -$05, +$4D              ; draw, y, x 
                    DB       $FF, +$20, -$77              ; draw, y, x 
                    DB       $FF, +$62, +$70              ; draw, y, x 
                    DB       $01, +$7F, +$7F              ; sync and move to y, x 
                    DB       $00, +$4F, +$7F              ; additional sync move to y, x 
                    DB       $00, +$00, +$2C              ; additional sync move to y, x 
                    DB       $FF, -$51, -$7A              ; draw, y, x 
                    DB       $FF, +$40, +$04              ; draw, y, x 
                    DB       $FF, +$41, +$05              ; draw, y, x 
                    DB       $FF, -$4C, -$17              ; draw, y, x 
                    DB       $FF, -$4B, -$16              ; draw, y, x 
                    DB       $FF, -$2F, -$42              ; draw, y, x 
                    DB       $FF, -$2F, -$42              ; draw, y, x 
                    DB       $FF, +$60, -$0A              ; draw, y, x 
                    DB       $FF, +$61, -$0B              ; draw, y, x 
                    DB       $FF, +$68, +$50              ; draw, y, x 
                    DB       $FF, -$53, -$52              ; draw, y, x 
                    DB       $FF, +$4A, -$0D              ; draw, y, x 
                    DB       $FF, +$4B, -$0E              ; draw, y, x 
                    DB       $FF, -$49, -$02              ; draw, y, x 
                    DB       $FF, -$48, -$02              ; draw, y, x 
                    DB       $FF, +$55, -$6C              ; draw, y, x 
                    DB       $FF, -$72, +$77              ; draw, y, x 
                    DB       $FF, -$61, +$10              ; draw, y, x 
                    DB       $FF, -$60, +$0F              ; draw, y, x 
                    DB       $01, +$05, -$04              ; sync and move to y, x 
                    DB       $FF, +$26, -$59              ; draw, y, x 
                    DB       $FF, +$27, -$59              ; draw, y, x 
                    DB       $FF, +$50, -$20              ; draw, y, x 
                    DB       $FF, +$51, -$21              ; draw, y, x 
                    DB       $FF, -$49, +$10              ; draw, y, x 
                    DB       $FF, -$49, +$0F              ; draw, y, x 
                    DB       $FF, +$2C, -$73              ; draw, y, x 
                    DB       $FF, -$3A, +$6E              ; draw, y, x 
                    DB       $FF, -$3B, -$6E              ; draw, y, x 
                    DB       $FF, +$16, +$45              ; draw, y, x 
                    DB       $FF, +$16, +$44              ; draw, y, x 
                    DB       $FF, -$26, +$5A              ; draw, y, x 
                    DB       $FF, -$26, +$5A              ; draw, y, x 
                    DB       $FF, -$38, -$50              ; draw, y, x 
                    DB       $FF, -$39, -$50              ; draw, y, x 
                    DB       $FF, +$0D, -$45              ; draw, y, x 
                    DB       $FF, +$0D, -$46              ; draw, y, x 
                    DB       $FF, -$2F, +$75              ; draw, y, x 
                    DB       $FF, -$53, -$62              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_14: 
                    DB       $01, -$7F, -$7F              ; sync and move to y, x 
                    DB       $00, -$7F, -$7D              ; additional sync move to y, x 
                    DB       $00, -$11, +$00              ; additional sync move to y, x 
                    DB       $FF, +$55, +$63              ; draw, y, x 
                    DB       $FF, -$7D, +$20              ; draw, y, x 
                    DB       $FF, +$47, -$05              ; draw, y, x 
                    DB       $FF, +$47, -$05              ; draw, y, x 
                    DB       $FF, +$49, +$43              ; draw, y, x 
                    DB       $FF, +$48, +$42              ; draw, y, x 
                    DB       $FF, -$58, +$18              ; draw, y, x 
                    DB       $FF, -$58, +$18              ; draw, y, x 
                    DB       $FF, -$4C, -$20              ; draw, y, x 
                    DB       $FF, -$4D, -$20              ; draw, y, x 
                    DB       $FF, +$7A, +$46              ; draw, y, x 
                    DB       $FF, -$76, +$2D              ; draw, y, x 
                    DB       $FF, +$74, -$19              ; draw, y, x 
                    DB       $FF, -$15, +$43              ; draw, y, x 
                    DB       $FF, -$16, +$43              ; draw, y, x 
                    DB       $FF, +$26, -$47              ; draw, y, x 
                    DB       $FF, +$25, -$47              ; draw, y, x 
                    DB       $FF, +$5C, -$1A              ; draw, y, x 
                    DB       $FF, +$5B, -$1A              ; draw, y, x 
                    DB       $01, -$12, +$10              ; sync and move to y, x 
                    DB       $FF, -$15, +$59              ; draw, y, x 
                    DB       $FF, -$16, +$59              ; draw, y, x 
                    DB       $FF, -$79, +$5B              ; draw, y, x 
                    DB       $FF, +$73, -$3B              ; draw, y, x 
                    DB       $FF, -$20, +$72              ; draw, y, x 
                    DB       $FF, +$2E, -$5B              ; draw, y, x 
                    DB       $FF, +$4F, +$5B              ; draw, y, x 
                    DB       $FF, -$22, -$46              ; draw, y, x 
                    DB       $FF, -$22, -$46              ; draw, y, x 
                    DB       $FF, +$14, -$5A              ; draw, y, x 
                    DB       $FF, +$14, -$5A              ; draw, y, x 
                    DB       $FF, +$72, +$73              ; draw, y, x 
                    DB       $FF, +$07, +$4C              ; draw, y, x 
                    DB       $FF, +$07, +$4C              ; draw, y, x 
                    DB       $FF, +$0C, -$7A              ; draw, y, x 
                    DB       $FF, +$73, +$5E              ; draw, y, x 
                    DB       $01, +$7F, +$7F              ; sync and move to y, x 
                    DB       $00, +$7E, +$7F              ; additional sync move to y, x 
                    DB       $00, +$00, +$05              ; additional sync move to y, x 
                    DB       $FF, -$64, -$6B              ; draw, y, x 
                    DB       $FF, +$40, -$06              ; draw, y, x 
                    DB       $FF, +$41, -$06              ; draw, y, x 
                    DB       $FF, -$4E, -$0A              ; draw, y, x 
                    DB       $FF, -$4E, -$0A              ; draw, y, x 
                    DB       $FF, -$74, -$71              ; draw, y, x 
                    DB       $FF, +$5D, -$1B              ; draw, y, x 
                    DB       $FF, +$5E, -$1B              ; draw, y, x 
                    DB       $FF, +$74, +$3E              ; draw, y, x 
                    DB       $FF, -$60, -$44              ; draw, y, x 
                    DB       $FF, +$47, -$19              ; draw, y, x 
                    DB       $FF, +$48, -$1A              ; draw, y, x 
                    DB       $FF, -$48, +$0A              ; draw, y, x 
                    DB       $FF, -$48, +$0A              ; draw, y, x 
                    DB       $FF, +$41, -$78              ; draw, y, x 
                    DB       $FF, -$2E, +$44              ; draw, y, x 
                    DB       $FF, -$2D, +$44              ; draw, y, x 
                    DB       $FF, -$5D, +$20              ; draw, y, x 
                    DB       $FF, -$5D, +$20              ; draw, y, x 
                    DB       $01, +$04, -$04              ; sync and move to y, x 
                    DB       $FF, +$17, -$5E              ; draw, y, x 
                    DB       $FF, +$17, -$5F              ; draw, y, x 
                    DB       $FF, +$4A, -$2D              ; draw, y, x 
                    DB       $FF, +$4A, -$2E              ; draw, y, x 
                    DB       $FF, -$46, +$1C              ; draw, y, x 
                    DB       $FF, -$45, +$1B              ; draw, y, x 
                    DB       $FF, +$18, -$79              ; draw, y, x 
                    DB       $FF, -$26, +$76              ; draw, y, x 
                    DB       $FF, -$4D, -$62              ; draw, y, x 
                    DB       $FF, +$42, +$7F              ; draw, y, x 
                    DB       $FF, -$16, +$5F              ; draw, y, x 
                    DB       $FF, -$16, +$5F              ; draw, y, x 
                    DB       $FF, -$45, -$45              ; draw, y, x 
                    DB       $FF, -$46, -$45              ; draw, y, x 
                    DB       $FF, +$02, -$47              ; draw, y, x 
                    DB       $FF, +$01, -$47              ; draw, y, x 
                    DB       $FF, -$1B, +$7C              ; draw, y, x 
                    DB       $FF, -$62, -$53              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_15: 
                    DB       $01, -$7F, -$7F              ; sync and move to y, x 
                    DB       $00, -$7F, -$4B              ; additional sync move to y, x 
                    DB       $00, -$38, +$00              ; additional sync move to y, x 
                    DB       $FF, +$65, +$53              ; draw, y, x 
                    DB       $FF, -$76, +$35              ; draw, y, x 
                    DB       $FF, +$45, -$11              ; draw, y, x 
                    DB       $FF, +$45, -$12              ; draw, y, x 
                    DB       $FF, +$53, +$36              ; draw, y, x 
                    DB       $FF, +$53, +$35              ; draw, y, x 
                    DB       $FF, -$53, +$26              ; draw, y, x 
                    DB       $FF, -$53, +$27              ; draw, y, x 
                    DB       $FF, -$50, -$13              ; draw, y, x 
                    DB       $FF, -$51, -$12              ; draw, y, x 
                    DB       $FF, +$42, +$18              ; draw, y, x 
                    DB       $FF, +$42, +$18              ; draw, y, x 
                    DB       $FF, -$6D, +$40              ; draw, y, x 
                    DB       $FF, +$6E, -$2C              ; draw, y, x 
                    DB       $FF, -$09, +$45              ; draw, y, x 
                    DB       $FF, -$0A, +$46              ; draw, y, x 
                    DB       $FF, +$19, -$4C              ; draw, y, x 
                    DB       $FF, +$19, -$4C              ; draw, y, x 
                    DB       $FF, +$56, -$29              ; draw, y, x 
                    DB       $FF, +$55, -$29              ; draw, y, x 
                    DB       $01, -$0F, +$13              ; sync and move to y, x 
                    DB       $FF, -$06, +$5B              ; draw, y, x 
                    DB       $FF, -$06, +$5B              ; draw, y, x 
                    DB       $FF, -$68, +$6F              ; draw, y, x 
                    DB       $FF, +$67, -$4E              ; draw, y, x 
                    DB       $FF, -$0C, +$76              ; draw, y, x 
                    DB       $FF, +$1E, -$62              ; draw, y, x 
                    DB       $FF, +$5D, +$4D              ; draw, y, x 
                    DB       $FF, -$5B, -$7E              ; draw, y, x 
                    DB       $FF, +$05, -$5D              ; draw, y, x 
                    DB       $FF, +$04, -$5C              ; draw, y, x 
                    DB       $FF, +$42, +$2F              ; draw, y, x 
                    DB       $FF, +$42, +$2F              ; draw, y, x 
                    DB       $FF, +$14, +$4A              ; draw, y, x 
                    DB       $FF, +$14, +$4A              ; draw, y, x 
                    DB       $FF, -$09, -$7A              ; draw, y, x 
                    DB       $FF, +$40, +$24              ; draw, y, x 
                    DB       $FF, +$41, +$25              ; draw, y, x 
                    DB       $01, +$7F, +$7F              ; sync and move to y, x 
                    DB       $00, +$7F, +$56              ; additional sync move to y, x 
                    DB       $00, +$27, +$00              ; additional sync move to y, x 
                    DB       $FF, -$74, -$59              ; draw, y, x 
                    DB       $FF, +$7C, -$22              ; draw, y, x 
                    DB       $FF, -$4F, +$03              ; draw, y, x 
                    DB       $FF, -$4E, +$04              ; draw, y, x 
                    DB       $FF, -$43, -$2E              ; draw, y, x 
                    DB       $FF, -$42, -$2E              ; draw, y, x 
                    DB       $FF, +$57, -$2A              ; draw, y, x 
                    DB       $FF, +$58, -$2A              ; draw, y, x 
                    DB       $FF, +$7D, +$28              ; draw, y, x 
                    DB       $FF, -$6A, -$32              ; draw, y, x 
                    DB       $FF, +$42, -$25              ; draw, y, x 
                    DB       $FF, +$42, -$25              ; draw, y, x 
                    DB       $FF, -$45, +$16              ; draw, y, x 
                    DB       $FF, -$45, +$16              ; draw, y, x 
                    DB       $FF, +$16, -$41              ; draw, y, x 
                    DB       $FF, +$16, -$41              ; draw, y, x 
                    DB       $FF, -$22, +$4B              ; draw, y, x 
                    DB       $FF, -$22, +$4B              ; draw, y, x 
                    DB       $FF, -$56, +$2F              ; draw, y, x 
                    DB       $FF, -$56, +$2F              ; draw, y, x 
                    DB       $01, +$03, -$05              ; sync and move to y, x 
                    DB       $FF, +$06, -$61              ; draw, y, x 
                    DB       $FF, +$07, -$61              ; draw, y, x 
                    DB       $FF, +$41, -$39              ; draw, y, x 
                    DB       $FF, +$42, -$3A              ; draw, y, x 
                    DB       $FF, -$40, +$27              ; draw, y, x 
                    DB       $FF, -$40, +$27              ; draw, y, x 
                    DB       $FF, +$04, -$7B              ; draw, y, x 
                    DB       $FF, -$12, +$7B              ; draw, y, x 
                    DB       $FF, -$5D, -$54              ; draw, y, x 
                    DB       $FF, +$57, +$72              ; draw, y, x 
                    DB       $FF, -$05, +$62              ; draw, y, x 
                    DB       $FF, -$06, +$61              ; draw, y, x 
                    DB       $FF, -$50, -$38              ; draw, y, x 
                    DB       $FF, -$50, -$39              ; draw, y, x 
                    DB       $FF, -$0B, -$46              ; draw, y, x 
                    DB       $FF, -$0B, -$46              ; draw, y, x 
                    DB       $FF, -$05, +$7F              ; draw, y, x 
                    DB       $FF, -$6F, -$41              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_16: 
                    DB       $01, -$7F, -$7F              ; sync and move to y, x 
                    DB       $00, -$7F, -$14              ; additional sync move to y, x 
                    DB       $00, -$56, +$00              ; additional sync move to y, x 
                    DB       $FF, +$72, +$41              ; draw, y, x 
                    DB       $FF, -$6B, +$48              ; draw, y, x 
                    DB       $FF, +$41, -$1D              ; draw, y, x 
                    DB       $FF, +$41, -$1D              ; draw, y, x 
                    DB       $FF, +$5B, +$27              ; draw, y, x 
                    DB       $FF, +$5A, +$27              ; draw, y, x 
                    DB       $FF, -$4B, +$33              ; draw, y, x 
                    DB       $FF, -$4B, +$34              ; draw, y, x 
                    DB       $FF, -$52, -$05              ; draw, y, x 
                    DB       $FF, -$53, -$04              ; draw, y, x 
                    DB       $FF, +$45, +$0D              ; draw, y, x 
                    DB       $FF, +$45, +$0D              ; draw, y, x 
                    DB       $FF, -$60, +$51              ; draw, y, x 
                    DB       $FF, +$64, -$3E              ; draw, y, x 
                    DB       $FF, +$03, +$46              ; draw, y, x 
                    DB       $FF, +$02, +$46              ; draw, y, x 
                    DB       $FF, +$0C, -$4F              ; draw, y, x 
                    DB       $FF, +$0B, -$4F              ; draw, y, x 
                    DB       $FF, +$4E, -$37              ; draw, y, x 
                    DB       $FF, +$4D, -$37              ; draw, y, x 
                    DB       $01, -$0C, +$15              ; sync and move to y, x 
                    DB       $FF, +$0A, +$5B              ; draw, y, x 
                    DB       $FF, +$09, +$5B              ; draw, y, x 
                    DB       $FF, -$54, +$7F              ; draw, y, x 
                    DB       $FF, +$59, -$5E              ; draw, y, x 
                    DB       $FF, +$08, +$76              ; draw, y, x 
                    DB       $FF, +$0D, -$66              ; draw, y, x 
                    DB       $FF, +$69, +$3C              ; draw, y, x 
                    DB       $FF, -$6F, -$6D              ; draw, y, x 
                    DB       $FF, -$0C, -$5C              ; draw, y, x 
                    DB       $FF, -$0B, -$5B              ; draw, y, x 
                    DB       $FF, +$49, +$23              ; draw, y, x 
                    DB       $FF, +$49, +$23              ; draw, y, x 
                    DB       $FF, +$20, +$45              ; draw, y, x 
                    DB       $FF, +$21, +$46              ; draw, y, x 
                    DB       $FF, -$1E, -$77              ; draw, y, x 
                    DB       $FF, +$46, +$19              ; draw, y, x 
                    DB       $FF, +$46, +$19              ; draw, y, x 
                    DB       $01, +$7F, +$7F              ; sync and move to y, x 
                    DB       $00, +$7F, +$21              ; additional sync move to y, x 
                    DB       $00, +$47, +$00              ; additional sync move to y, x 
                    DB       $FF, -$41, -$22              ; draw, y, x 
                    DB       $FF, -$41, -$21              ; draw, y, x 
                    DB       $FF, +$75, -$37              ; draw, y, x 
                    DB       $FF, -$4D, +$11              ; draw, y, x 
                    DB       $FF, -$4C, +$11              ; draw, y, x 
                    DB       $FF, -$4A, -$23              ; draw, y, x 
                    DB       $FF, -$49, -$22              ; draw, y, x 
                    DB       $FF, +$4F, -$38              ; draw, y, x 
                    DB       $FF, +$4F, -$39              ; draw, y, x 
                    DB       $FF, +$41, +$0A              ; draw, y, x 
                    DB       $FF, +$41, +$09              ; draw, y, x 
                    DB       $FF, -$71, -$1F              ; draw, y, x 
                    DB       $FF, +$76, -$60              ; draw, y, x 
                    DB       $FF, -$41, +$22              ; draw, y, x 
                    DB       $FF, -$40, +$21              ; draw, y, x 
                    DB       $FF, +$0A, -$43              ; draw, y, x 
                    DB       $FF, +$0B, -$44              ; draw, y, x 
                    DB       $FF, -$15, +$50              ; draw, y, x 
                    DB       $FF, -$14, +$4F              ; draw, y, x 
                    DB       $FF, -$4D, +$3D              ; draw, y, x 
                    DB       $FF, -$4D, +$3D              ; draw, y, x 
                    DB       $01, +$02, -$05              ; sync and move to y, x 
                    DB       $FF, -$0A, -$61              ; draw, y, x 
                    DB       $FF, -$0A, -$61              ; draw, y, x 
                    DB       $FF, +$37, -$43              ; draw, y, x 
                    DB       $FF, +$37, -$44              ; draw, y, x 
                    DB       $FF, -$71, +$63              ; draw, y, x 
                    DB       $FF, -$11, -$7A              ; draw, y, x 
                    DB       $FF, +$03, +$7C              ; draw, y, x 
                    DB       $FF, -$6A, -$44              ; draw, y, x 
                    DB       $FF, +$69, +$62              ; draw, y, x 
                    DB       $FF, +$0B, +$62              ; draw, y, x 
                    DB       $FF, +$0B, +$61              ; draw, y, x 
                    DB       $FF, -$58, -$2A              ; draw, y, x 
                    DB       $FF, -$59, -$2B              ; draw, y, x 
                    DB       $FF, -$16, -$43              ; draw, y, x 
                    DB       $FF, -$16, -$43              ; draw, y, x 
                    DB       $FF, +$0F, +$7D              ; draw, y, x 
                    DB       $FF, -$78, -$2D              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_17: 
                    DB       $01, -$7F, -$57              ; sync and move to y, x 
                    DB       $00, -$7F, +$00              ; additional sync move to y, x 
                    DB       $00, -$6A, +$00              ; additional sync move to y, x 
                    DB       $FF, +$7B, +$2C              ; draw, y, x 
                    DB       $FF, -$5D, +$59              ; draw, y, x 
                    DB       $FF, +$76, -$4E              ; draw, y, x 
                    DB       $FF, +$60, +$17              ; draw, y, x 
                    DB       $FF, +$60, +$16              ; draw, y, x 
                    DB       $FF, -$41, +$40              ; draw, y, x 
                    DB       $FF, -$41, +$40              ; draw, y, x 
                    DB       $FF, -$52, +$09              ; draw, y, x 
                    DB       $FF, -$52, +$0A              ; draw, y, x 
                    DB       $FF, +$46, +$00              ; draw, y, x 
                    DB       $FF, +$46, +$01              ; draw, y, x 
                    DB       $FF, -$51, +$61              ; draw, y, x 
                    DB       $FF, +$58, -$4E              ; draw, y, x 
                    DB       $FF, +$0F, +$44              ; draw, y, x 
                    DB       $FF, +$0E, +$45              ; draw, y, x 
                    DB       $FF, -$02, -$50              ; draw, y, x 
                    DB       $FF, -$02, -$50              ; draw, y, x 
                    DB       $FF, +$43, -$43              ; draw, y, x 
                    DB       $FF, +$43, -$43              ; draw, y, x 
                    DB       $01, -$08, +$17              ; sync and move to y, x 
                    DB       $FF, +$18, +$58              ; draw, y, x 
                    DB       $FF, +$19, +$58              ; draw, y, x 
                    DB       $FF, -$1F, +$45              ; draw, y, x 
                    DB       $FF, -$1E, +$46              ; draw, y, x 
                    DB       $FF, +$48, -$6C              ; draw, y, x 
                    DB       $FF, +$1C, +$73              ; draw, y, x 
                    DB       $FF, -$05, -$66              ; draw, y, x 
                    DB       $FF, +$71, +$2A              ; draw, y, x 
                    DB       $FF, -$7F, -$59              ; draw, y, x 
                    DB       $FF, -$1B, -$59              ; draw, y, x 
                    DB       $FF, -$1A, -$58              ; draw, y, x 
                    DB       $FF, +$4D, +$16              ; draw, y, x 
                    DB       $FF, +$4E, +$16              ; draw, y, x 
                    DB       $FF, +$57, +$7E              ; draw, y, x 
                    DB       $FF, -$31, -$70              ; draw, y, x 
                    DB       $FF, +$49, +$0D              ; draw, y, x 
                    DB       $FF, +$49, +$0D              ; draw, y, x 
                    DB       $01, +$7F, +$67              ; sync and move to y, x 
                    DB       $00, +$7F, +$00              ; additional sync move to y, x 
                    DB       $00, +$5D, +$00              ; additional sync move to y, x 
                    DB       $FF, -$46, -$17              ; draw, y, x 
                    DB       $FF, -$45, -$16              ; draw, y, x 
                    DB       $FF, +$6A, -$49              ; draw, y, x 
                    DB       $FF, -$49, +$1D              ; draw, y, x 
                    DB       $FF, -$49, +$1E              ; draw, y, x 
                    DB       $FF, -$4E, -$16              ; draw, y, x 
                    DB       $FF, -$4E, -$15              ; draw, y, x 
                    DB       $FF, +$44, -$45              ; draw, y, x 
                    DB       $FF, +$45, -$45              ; draw, y, x 
                    DB       $FF, +$41, -$01              ; draw, y, x 
                    DB       $FF, +$42, -$02              ; draw, y, x 
                    DB       $FF, -$75, -$0C              ; draw, y, x 
                    DB       $FF, +$65, -$72              ; draw, y, x 
                    DB       $FF, -$74, +$57              ; draw, y, x 
                    DB       $FF, -$01, -$44              ; draw, y, x 
                    DB       $FF, -$01, -$44              ; draw, y, x 
                    DB       $FF, -$07, +$52              ; draw, y, x 
                    DB       $FF, -$07, +$51              ; draw, y, x 
                    DB       $FF, -$41, +$49              ; draw, y, x 
                    DB       $FF, -$41, +$49              ; draw, y, x 
                    DB       $01, +$02, -$06              ; sync and move to y, x 
                    DB       $FF, -$1A, -$5D              ; draw, y, x 
                    DB       $FF, -$1B, -$5E              ; draw, y, x 
                    DB       $FF, +$2B, -$4C              ; draw, y, x 
                    DB       $FF, +$2A, -$4C              ; draw, y, x 
                    DB       $FF, -$5E, +$74              ; draw, y, x 
                    DB       $FF, -$26, -$75              ; draw, y, x 
                    DB       $FF, +$18, +$7A              ; draw, y, x 
                    DB       $FF, -$73, -$31              ; draw, y, x 
                    DB       $FF, +$78, +$4F              ; draw, y, x 
                    DB       $FF, +$1B, +$5E              ; draw, y, x 
                    DB       $FF, +$1B, +$5E              ; draw, y, x 
                    DB       $FF, -$5E, -$1A              ; draw, y, x 
                    DB       $FF, -$5F, -$1B              ; draw, y, x 
                    DB       $FF, -$42, -$7D              ; draw, y, x 
                    DB       $FF, +$24, +$79              ; draw, y, x 
                    DB       $FF, -$7E, -$18              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_18: 
                    DB       $01, -$7F, -$19              ; sync and move to y, x 
                    DB       $00, -$7F, +$00              ; additional sync move to y, x 
                    DB       $00, -$73, +$00              ; additional sync move to y, x 
                    DB       $FF, +$40, +$0C              ; draw, y, x 
                    DB       $FF, +$40, +$0B              ; draw, y, x 
                    DB       $FF, -$4D, +$67              ; draw, y, x 
                    DB       $FF, +$68, -$61              ; draw, y, x 
                    DB       $FF, +$63, +$06              ; draw, y, x 
                    DB       $FF, +$62, +$07              ; draw, y, x 
                    DB       $FF, -$35, +$49              ; draw, y, x 
                    DB       $FF, -$36, +$4A              ; draw, y, x 
                    DB       $FF, -$4F, +$17              ; draw, y, x 
                    DB       $FF, -$50, +$18              ; draw, y, x 
                    DB       $FF, +$45, -$0C              ; draw, y, x 
                    DB       $FF, +$45, -$0B              ; draw, y, x 
                    DB       $FF, -$3F, +$6D              ; draw, y, x 
                    DB       $FF, +$4A, -$5C              ; draw, y, x 
                    DB       $FF, +$1A, +$41              ; draw, y, x 
                    DB       $FF, +$19, +$42              ; draw, y, x 
                    DB       $FF, -$0F, -$4F              ; draw, y, x 
                    DB       $FF, -$10, -$4E              ; draw, y, x 
                    DB       $FF, +$37, -$4E              ; draw, y, x 
                    DB       $FF, +$37, -$4D              ; draw, y, x 
                    DB       $01, -$04, +$18              ; sync and move to y, x 
                    DB       $FF, +$27, +$52              ; draw, y, x 
                    DB       $FF, +$27, +$53              ; draw, y, x 
                    DB       $FF, -$12, +$49              ; draw, y, x 
                    DB       $FF, -$12, +$4A              ; draw, y, x 
                    DB       $FF, +$34, -$76              ; draw, y, x 
                    DB       $FF, +$2F, +$6D              ; draw, y, x 
                    DB       $FF, -$16, -$64              ; draw, y, x 
                    DB       $FF, +$77, +$16              ; draw, y, x 
                    DB       $FF, -$47, -$21              ; draw, y, x 
                    DB       $FF, -$46, -$21              ; draw, y, x 
                    DB       $FF, -$29, -$53              ; draw, y, x 
                    DB       $FF, -$29, -$53              ; draw, y, x 
                    DB       $FF, +$50, +$09              ; draw, y, x 
                    DB       $FF, +$51, +$09              ; draw, y, x 
                    DB       $FF, +$6B, +$6D              ; draw, y, x 
                    DB       $FF, -$44, -$66              ; draw, y, x 
                    DB       $FF, +$4A, +$00              ; draw, y, x 
                    DB       $FF, +$4B, +$01              ; draw, y, x 
                    DB       $01, +$7F, +$2B              ; sync and move to y, x 
                    DB       $00, +$7F, +$00              ; additional sync move to y, x 
                    DB       $00, +$6A, +$00              ; additional sync move to y, x 
                    DB       $FF, -$49, -$0B              ; draw, y, x 
                    DB       $FF, -$48, -$0A              ; draw, y, x 
                    DB       $FF, +$5C, -$5A              ; draw, y, x 
                    DB       $FF, -$43, +$2A              ; draw, y, x 
                    DB       $FF, -$43, +$29              ; draw, y, x 
                    DB       $FF, -$51, -$08              ; draw, y, x 
                    DB       $FF, -$50, -$08              ; draw, y, x 
                    DB       $FF, +$38, -$4F              ; draw, y, x 
                    DB       $FF, +$38, -$50              ; draw, y, x 
                    DB       $FF, +$40, -$0C              ; draw, y, x 
                    DB       $FF, +$41, -$0D              ; draw, y, x 
                    DB       $FF, -$75, +$08              ; draw, y, x 
                    DB       $FF, +$27, -$41              ; draw, y, x 
                    DB       $FF, +$28, -$41              ; draw, y, x 
                    DB       $FF, -$64, +$6A              ; draw, y, x 
                    DB       $FF, -$0C, -$43              ; draw, y, x 
                    DB       $FF, -$0C, -$44              ; draw, y, x 
                    DB       $FF, +$07, +$52              ; draw, y, x 
                    DB       $FF, +$07, +$52              ; draw, y, x 
                    DB       $FF, -$34, +$53              ; draw, y, x 
                    DB       $FF, -$34, +$53              ; draw, y, x 
                    DB       $01, +$01, -$06              ; sync and move to y, x 
                    DB       $FF, -$2A, -$58              ; draw, y, x 
                    DB       $FF, -$2A, -$58              ; draw, y, x 
                    DB       $FF, +$1D, -$51              ; draw, y, x 
                    DB       $FF, +$1D, -$52              ; draw, y, x 
                    DB       $FF, -$24, +$41              ; draw, y, x 
                    DB       $FF, -$25, +$41              ; draw, y, x 
                    DB       $FF, -$39, -$6D              ; draw, y, x 
                    DB       $FF, +$2C, +$74              ; draw, y, x 
                    DB       $FF, -$7A, -$1D              ; draw, y, x 
                    DB       $FF, +$42, +$1D              ; draw, y, x 
                    DB       $FF, +$42, +$1D              ; draw, y, x 
                    DB       $FF, +$2B, +$58              ; draw, y, x 
                    DB       $FF, +$2A, +$58              ; draw, y, x 
                    DB       $FF, -$61, -$0A              ; draw, y, x 
                    DB       $FF, -$62, -$0B              ; draw, y, x 
                    DB       $FF, -$57, -$70              ; draw, y, x 
                    DB       $FF, +$39, +$71              ; draw, y, x 
                    DB       $FF, -$40, -$01              ; draw, y, x 
                    DB       $FF, -$40, -$01              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_19: 
                    DB       $01, -$7F, +$25              ; sync and move to y, x 
                    DB       $00, -$7F, +$00              ; additional sync move to y, x 
                    DB       $00, -$72, +$00              ; additional sync move to y, x 
                    DB       $FF, +$41, +$00              ; draw, y, x 
                    DB       $FF, +$41, +$01              ; draw, y, x 
                    DB       $FF, -$3A, +$74              ; draw, y, x 
                    DB       $FF, +$56, -$72              ; draw, y, x 
                    DB       $FF, +$62, -$0B              ; draw, y, x 
                    DB       $FF, +$62, -$0A              ; draw, y, x 
                    DB       $FF, -$28, +$52              ; draw, y, x 
                    DB       $FF, -$29, +$52              ; draw, y, x 
                    DB       $FF, -$4A, +$24              ; draw, y, x 
                    DB       $FF, -$4A, +$25              ; draw, y, x 
                    DB       $FF, +$42, -$17              ; draw, y, x 
                    DB       $FF, +$42, -$17              ; draw, y, x 
                    DB       $FF, -$2C, +$76              ; draw, y, x 
                    DB       $FF, +$3A, -$67              ; draw, y, x 
                    DB       $FF, +$48, +$78              ; draw, y, x 
                    DB       $FF, -$1C, -$4B              ; draw, y, x 
                    DB       $FF, -$1D, -$4A              ; draw, y, x 
                    DB       $FF, +$29, -$56              ; draw, y, x 
                    DB       $FF, +$29, -$56              ; draw, y, x 
                    DB       $01, +$00, +$18              ; sync and move to y, x 
                    DB       $FF, +$34, +$4B              ; draw, y, x 
                    DB       $FF, +$35, +$4B              ; draw, y, x 
                    DB       $FF, -$06, +$4B              ; draw, y, x 
                    DB       $FF, -$05, +$4C              ; draw, y, x 
                    DB       $FF, +$1F, -$7D              ; draw, y, x 
                    DB       $FF, +$41, +$63              ; draw, y, x 
                    DB       $FF, -$26, -$5F              ; draw, y, x 
                    DB       $FF, +$78, +$02              ; draw, y, x 
                    DB       $FF, -$4B, -$15              ; draw, y, x 
                    DB       $FF, -$4B, -$15              ; draw, y, x 
                    DB       $FF, -$37, -$4B              ; draw, y, x 
                    DB       $FF, -$36, -$4A              ; draw, y, x 
                    DB       $FF, +$51, -$05              ; draw, y, x 
                    DB       $FF, +$51, -$05              ; draw, y, x 
                    DB       $FF, +$7C, +$5A              ; draw, y, x 
                    DB       $FF, -$54, -$59              ; draw, y, x 
                    DB       $FF, +$49, -$0C              ; draw, y, x 
                    DB       $FF, +$4A, -$0D              ; draw, y, x 
                    DB       $01, +$7F, -$13              ; sync and move to y, x 
                    DB       $00, +$7F, +$00              ; additional sync move to y, x 
                    DB       $00, +$6C, +$00              ; additional sync move to y, x 
                    DB       $FF, -$49, +$03              ; draw, y, x 
                    DB       $FF, -$49, +$02              ; draw, y, x 
                    DB       $FF, +$4B, -$69              ; draw, y, x 
                    DB       $FF, -$76, +$68              ; draw, y, x 
                    DB       $FF, -$51, +$06              ; draw, y, x 
                    DB       $FF, -$50, +$06              ; draw, y, x 
                    DB       $FF, +$29, -$58              ; draw, y, x 
                    DB       $FF, +$2A, -$58              ; draw, y, x 
                    DB       $FF, +$7B, -$2E              ; draw, y, x 
                    DB       $FF, -$72, +$1C              ; draw, y, x 
                    DB       $FF, +$1C, -$47              ; draw, y, x 
                    DB       $FF, +$1C, -$47              ; draw, y, x 
                    DB       $FF, -$50, +$79              ; draw, y, x 
                    DB       $FF, -$18, -$40              ; draw, y, x 
                    DB       $FF, -$17, -$40              ; draw, y, x 
                    DB       $FF, +$14, +$50              ; draw, y, x 
                    DB       $FF, +$15, +$4F              ; draw, y, x 
                    DB       $FF, -$26, +$5B              ; draw, y, x 
                    DB       $FF, -$25, +$5A              ; draw, y, x 
                    DB       $01, -$01, -$06              ; sync and move to y, x 
                    DB       $FF, -$37, -$4F              ; draw, y, x 
                    DB       $FF, -$38, -$50              ; draw, y, x 
                    DB       $FF, +$0F, -$55              ; draw, y, x 
                    DB       $FF, +$0E, -$56              ; draw, y, x 
                    DB       $FF, -$19, +$47              ; draw, y, x 
                    DB       $FF, -$19, +$46              ; draw, y, x 
                    DB       $FF, -$4B, -$62              ; draw, y, x 
                    DB       $FF, +$40, +$6B              ; draw, y, x 
                    DB       $FF, -$7D, -$08              ; draw, y, x 
                    DB       $FF, +$46, +$11              ; draw, y, x 
                    DB       $FF, +$45, +$11              ; draw, y, x 
                    DB       $FF, +$39, +$50              ; draw, y, x 
                    DB       $FF, +$39, +$4F              ; draw, y, x 
                    DB       $FF, -$62, +$06              ; draw, y, x 
                    DB       $FF, -$62, +$07              ; draw, y, x 
                    DB       $FF, -$68, -$5F              ; draw, y, x 
                    DB       $FF, +$4B, +$66              ; draw, y, x 
                    DB       $FF, -$7F, +$12              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_20: 
                    DB       $01, -$7F, +$63              ; sync and move to y, x 
                    DB       $00, -$7F, +$00              ; additional sync move to y, x 
                    DB       $00, -$67, +$00              ; additional sync move to y, x 
                    DB       $FF, +$41, -$0B              ; draw, y, x 
                    DB       $FF, +$40, -$0A              ; draw, y, x 
                    DB       $FF, -$26, +$7B              ; draw, y, x 
                    DB       $FF, +$41, -$7E              ; draw, y, x 
                    DB       $FF, +$5F, -$1B              ; draw, y, x 
                    DB       $FF, +$5F, -$1B              ; draw, y, x 
                    DB       $FF, -$1A, +$57              ; draw, y, x 
                    DB       $FF, -$1A, +$58              ; draw, y, x 
                    DB       $FF, -$43, +$30              ; draw, y, x 
                    DB       $FF, -$43, +$31              ; draw, y, x 
                    DB       $FF, +$7C, -$43              ; draw, y, x 
                    DB       $FF, -$18, +$7C              ; draw, y, x 
                    DB       $FF, +$27, -$70              ; draw, y, x 
                    DB       $FF, +$5C, +$6B              ; draw, y, x 
                    DB       $FF, -$28, -$45              ; draw, y, x 
                    DB       $FF, -$29, -$45              ; draw, y, x 
                    DB       $FF, +$1A, -$5C              ; draw, y, x 
                    DB       $FF, +$19, -$5B              ; draw, y, x 
                    DB       $01, +$04, +$18              ; sync and move to y, x 
                    DB       $FF, +$40, +$40              ; draw, y, x 
                    DB       $FF, +$41, +$41              ; draw, y, x 
                    DB       $FF, +$07, +$4C              ; draw, y, x 
                    DB       $FF, +$08, +$4C              ; draw, y, x 
                    DB       $FF, +$04, -$41              ; draw, y, x 
                    DB       $FF, +$05, -$40              ; draw, y, x 
                    DB       $FF, +$51, +$57              ; draw, y, x 
                    DB       $FF, -$36, -$58              ; draw, y, x 
                    DB       $FF, +$77, -$12              ; draw, y, x 
                    DB       $FF, -$4E, -$08              ; draw, y, x 
                    DB       $FF, -$4D, -$08              ; draw, y, x 
                    DB       $FF, -$42, -$41              ; draw, y, x 
                    DB       $FF, -$42, -$40              ; draw, y, x 
                    DB       $FF, +$4E, -$12              ; draw, y, x 
                    DB       $FF, +$4F, -$12              ; draw, y, x 
                    DB       $FF, +$45, +$21              ; draw, y, x 
                    DB       $FF, +$45, +$22              ; draw, y, x 
                    DB       $FF, -$62, -$4A              ; draw, y, x 
                    DB       $FF, +$46, -$18              ; draw, y, x 
                    DB       $FF, +$46, -$19              ; draw, y, x 
                    DB       $01, +$7F, -$50              ; sync and move to y, x 
                    DB       $00, +$7F, +$00              ; additional sync move to y, x 
                    DB       $00, +$63, +$00              ; additional sync move to y, x 
                    DB       $FF, -$48, +$0F              ; draw, y, x 
                    DB       $FF, -$47, +$0E              ; draw, y, x 
                    DB       $FF, +$39, -$74              ; draw, y, x 
                    DB       $FF, -$63, +$7B              ; draw, y, x 
                    DB       $FF, -$4F, +$14              ; draw, y, x 
                    DB       $FF, -$4E, +$13              ; draw, y, x 
                    DB       $FF, +$1A, -$5D              ; draw, y, x 
                    DB       $FF, +$1B, -$5E              ; draw, y, x 
                    DB       $FF, +$70, -$43              ; draw, y, x 
                    DB       $FF, -$6B, +$2F              ; draw, y, x 
                    DB       $FF, +$0F, -$4A              ; draw, y, x 
                    DB       $FF, +$10, -$4B              ; draw, y, x 
                    DB       $FF, -$1D, +$43              ; draw, y, x 
                    DB       $FF, -$1D, +$42              ; draw, y, x 
                    DB       $FF, -$44, -$77              ; draw, y, x 
                    DB       $FF, +$22, +$4B              ; draw, y, x 
                    DB       $FF, +$22, +$4B              ; draw, y, x 
                    DB       $FF, -$16, +$60              ; draw, y, x 
                    DB       $FF, -$16, +$5F              ; draw, y, x 
                    DB       $01, -$02, -$06              ; sync and move to y, x 
                    DB       $FF, -$44, -$45              ; draw, y, x 
                    DB       $FF, -$45, -$45              ; draw, y, x 
                    DB       $FF, +$01, -$56              ; draw, y, x 
                    DB       $FF, +$00, -$57              ; draw, y, x 
                    DB       $FF, -$0D, +$4A              ; draw, y, x 
                    DB       $FF, -$0D, +$49              ; draw, y, x 
                    DB       $FF, -$5A, -$54              ; draw, y, x 
                    DB       $FF, +$50, +$5F              ; draw, y, x 
                    DB       $FF, -$7C, +$0D              ; draw, y, x 
                    DB       $FF, +$48, +$06              ; draw, y, x 
                    DB       $FF, +$47, +$05              ; draw, y, x 
                    DB       $FF, +$46, +$45              ; draw, y, x 
                    DB       $FF, +$45, +$44              ; draw, y, x 
                    DB       $FF, -$5F, +$17              ; draw, y, x 
                    DB       $FF, -$60, +$17              ; draw, y, x 
                    DB       $FF, -$77, -$4D              ; draw, y, x 
                    DB       $FF, +$5B, +$58              ; draw, y, x 
                    DB       $FF, -$7A, +$28              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_21: 
                    DB       $01, -$7F, +$7F              ; sync and move to y, x 
                    DB       $00, -$7F, +$1F              ; additional sync move to y, x 
                    DB       $00, -$51, +$00              ; additional sync move to y, x 
                    DB       $FF, +$7C, -$2B              ; draw, y, x 
                    DB       $FF, -$08, +$40              ; draw, y, x 
                    DB       $FF, -$09, +$41              ; draw, y, x 
                    DB       $FF, +$16, -$44              ; draw, y, x 
                    DB       $FF, +$15, -$44              ; draw, y, x 
                    DB       $FF, +$59, -$2B              ; draw, y, x 
                    DB       $FF, +$59, -$2A              ; draw, y, x 
                    DB       $FF, -$0B, +$5A              ; draw, y, x 
                    DB       $FF, -$0B, +$5B              ; draw, y, x 
                    DB       $FF, -$73, +$76              ; draw, y, x 
                    DB       $FF, +$6E, -$57              ; draw, y, x 
                    DB       $FF, -$03, +$7E              ; draw, y, x 
                    DB       $FF, +$14, -$74              ; draw, y, x 
                    DB       $FF, +$6D, +$59              ; draw, y, x 
                    DB       $FF, -$68, -$7A              ; draw, y, x 
                    DB       $FF, +$0A, -$5F              ; draw, y, x 
                    DB       $FF, +$0A, -$5E              ; draw, y, x 
                    DB       $01, +$08, +$17              ; sync and move to y, x 
                    DB       $FF, +$4A, +$35              ; draw, y, x 
                    DB       $FF, +$4B, +$35              ; draw, y, x 
                    DB       $FF, +$14, +$49              ; draw, y, x 
                    DB       $FF, +$14, +$49              ; draw, y, x 
                    DB       $FF, -$06, -$40              ; draw, y, x 
                    DB       $FF, -$06, -$40              ; draw, y, x 
                    DB       $FF, +$5E, +$48              ; draw, y, x 
                    DB       $FF, -$44, -$4D              ; draw, y, x 
                    DB       $FF, +$72, -$27              ; draw, y, x 
                    DB       $FF, -$4E, +$05              ; draw, y, x 
                    DB       $FF, -$4D, +$06              ; draw, y, x 
                    DB       $FF, -$4C, -$34              ; draw, y, x 
                    DB       $FF, -$4C, -$34              ; draw, y, x 
                    DB       $FF, +$4A, -$1F              ; draw, y, x 
                    DB       $FF, +$4B, -$20              ; draw, y, x 
                    DB       $FF, +$49, +$16              ; draw, y, x 
                    DB       $FF, +$4A, +$15              ; draw, y, x 
                    DB       $FF, -$6D, -$38              ; draw, y, x 
                    DB       $FF, +$41, -$24              ; draw, y, x 
                    DB       $FF, +$41, -$24              ; draw, y, x 
                    DB       $01, +$7F, -$7F              ; sync and move to y, x 
                    DB       $00, +$7F, -$0B              ; additional sync move to y, x 
                    DB       $00, +$51, +$00              ; additional sync move to y, x 
                    DB       $FF, -$45, +$1B              ; draw, y, x 
                    DB       $FF, -$44, +$1A              ; draw, y, x 
                    DB       $FF, +$25, -$7C              ; draw, y, x 
                    DB       $FF, -$26, +$45              ; draw, y, x 
                    DB       $FF, -$26, +$44              ; draw, y, x 
                    DB       $FF, -$4B, +$21              ; draw, y, x 
                    DB       $FF, -$4A, +$20              ; draw, y, x 
                    DB       $FF, +$0A, -$60              ; draw, y, x 
                    DB       $FF, +$0A, -$61              ; draw, y, x 
                    DB       $FF, +$64, -$55              ; draw, y, x 
                    DB       $FF, -$62, +$40              ; draw, y, x 
                    DB       $FF, +$03, -$4C              ; draw, y, x 
                    DB       $FF, +$03, -$4C              ; draw, y, x 
                    DB       $FF, -$12, +$47              ; draw, y, x 
                    DB       $FF, -$11, +$46              ; draw, y, x 
                    DB       $FF, -$57, -$69              ; draw, y, x 
                    DB       $FF, +$2E, +$44              ; draw, y, x 
                    DB       $FF, +$2E, +$44              ; draw, y, x 
                    DB       $FF, -$05, +$62              ; draw, y, x 
                    DB       $FF, -$05, +$62              ; draw, y, x 
                    DB       $01, -$02, -$05              ; sync and move to y, x 
                    DB       $FF, -$4F, -$38              ; draw, y, x 
                    DB       $FF, -$50, -$39              ; draw, y, x 
                    DB       $FF, -$0E, -$55              ; draw, y, x 
                    DB       $FF, -$0F, -$56              ; draw, y, x 
                    DB       $FF, +$00, +$4B              ; draw, y, x 
                    DB       $FF, -$01, +$4A              ; draw, y, x 
                    DB       $FF, -$67, -$44              ; draw, y, x 
                    DB       $FF, +$60, +$50              ; draw, y, x 
                    DB       $FF, -$79, +$23              ; draw, y, x 
                    DB       $FF, +$48, -$07              ; draw, y, x 
                    DB       $FF, +$47, -$07              ; draw, y, x 
                    DB       $FF, +$51, +$38              ; draw, y, x 
                    DB       $FF, +$50, +$38              ; draw, y, x 
                    DB       $FF, -$5A, +$26              ; draw, y, x 
                    DB       $FF, -$5B, +$27              ; draw, y, x 
                    DB       $FF, -$41, -$1C              ; draw, y, x 
                    DB       $FF, -$41, -$1B              ; draw, y, x 
                    DB       $FF, +$69, +$47              ; draw, y, x 
                    DB       $FF, -$72, +$3C              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_22: 
                    DB       $01, -$7F, +$7F              ; sync and move to y, x 
                    DB       $00, -$7F, +$55              ; additional sync move to y, x 
                    DB       $00, -$31, +$00              ; additional sync move to y, x 
                    DB       $FF, +$72, -$3F              ; draw, y, x 
                    DB       $FF, +$03, +$41              ; draw, y, x 
                    DB       $FF, +$02, +$41              ; draw, y, x 
                    DB       $FF, +$0A, -$47              ; draw, y, x 
                    DB       $FF, +$0A, -$46              ; draw, y, x 
                    DB       $FF, +$51, -$39              ; draw, y, x 
                    DB       $FF, +$50, -$39              ; draw, y, x 
                    DB       $FF, +$04, +$5B              ; draw, y, x 
                    DB       $FF, +$05, +$5B              ; draw, y, x 
                    DB       $FF, -$2F, +$44              ; draw, y, x 
                    DB       $FF, -$2F, +$44              ; draw, y, x 
                    DB       $FF, +$5E, -$69              ; draw, y, x 
                    DB       $FF, +$13, +$7D              ; draw, y, x 
                    DB       $FF, +$00, -$76              ; draw, y, x 
                    DB       $FF, +$7A, +$46              ; draw, y, x 
                    DB       $FF, -$7B, -$67              ; draw, y, x 
                    DB       $FF, -$06, -$5F              ; draw, y, x 
                    DB       $FF, -$06, -$5F              ; draw, y, x 
                    DB       $01, +$0C, +$15              ; sync and move to y, x 
                    DB       $FF, +$52, +$27              ; draw, y, x 
                    DB       $FF, +$52, +$28              ; draw, y, x 
                    DB       $FF, +$20, +$45              ; draw, y, x 
                    DB       $FF, +$21, +$45              ; draw, y, x 
                    DB       $FF, -$22, -$7C              ; draw, y, x 
                    DB       $FF, +$69, +$36              ; draw, y, x 
                    DB       $FF, -$50, -$40              ; draw, y, x 
                    DB       $FF, +$6A, -$39              ; draw, y, x 
                    DB       $FF, -$4C, +$12              ; draw, y, x 
                    DB       $FF, -$4B, +$13              ; draw, y, x 
                    DB       $FF, -$54, -$27              ; draw, y, x 
                    DB       $FF, -$54, -$26              ; draw, y, x 
                    DB       $FF, +$44, -$2C              ; draw, y, x 
                    DB       $FF, +$44, -$2C              ; draw, y, x 
                    DB       $FF, +$4C, +$09              ; draw, y, x 
                    DB       $FF, +$4C, +$09              ; draw, y, x 
                    DB       $FF, -$74, -$25              ; draw, y, x 
                    DB       $FF, +$74, -$5D              ; draw, y, x 
                    DB       $01, +$7F, -$7F              ; sync and move to y, x 
                    DB       $00, +$7F, -$42              ; additional sync move to y, x 
                    DB       $00, +$35, +$00              ; additional sync move to y, x 
                    DB       $FF, -$7E, +$4B              ; draw, y, x 
                    DB       $FF, +$07, -$40              ; draw, y, x 
                    DB       $FF, +$08, -$40              ; draw, y, x 
                    DB       $FF, -$1A, +$4B              ; draw, y, x 
                    DB       $FF, -$1A, +$4A              ; draw, y, x 
                    DB       $FF, -$44, +$2D              ; draw, y, x 
                    DB       $FF, -$43, +$2C              ; draw, y, x 
                    DB       $FF, -$07, -$61              ; draw, y, x 
                    DB       $FF, -$06, -$61              ; draw, y, x 
                    DB       $FF, +$54, -$65              ; draw, y, x 
                    DB       $FF, -$56, +$50              ; draw, y, x 
                    DB       $FF, -$0A, -$4B              ; draw, y, x 
                    DB       $FF, -$0A, -$4C              ; draw, y, x 
                    DB       $FF, -$05, +$49              ; draw, y, x 
                    DB       $FF, -$05, +$48              ; draw, y, x 
                    DB       $FF, -$68, -$59              ; draw, y, x 
                    DB       $FF, +$72, +$76              ; draw, y, x 
                    DB       $FF, +$0C, +$62              ; draw, y, x 
                    DB       $FF, +$0B, +$61              ; draw, y, x 
                    DB       $01, -$03, -$05              ; sync and move to y, x 
                    DB       $FF, -$58, -$2A              ; draw, y, x 
                    DB       $FF, -$58, -$2A              ; draw, y, x 
                    DB       $FF, -$1C, -$52              ; draw, y, x 
                    DB       $FF, -$1D, -$52              ; draw, y, x 
                    DB       $FF, +$0D, +$4A              ; draw, y, x 
                    DB       $FF, +$0C, +$49              ; draw, y, x 
                    DB       $FF, -$71, -$31              ; draw, y, x 
                    DB       $FF, +$6B, +$3F              ; draw, y, x 
                    DB       $FF, -$71, +$36              ; draw, y, x 
                    DB       $FF, +$46, -$13              ; draw, y, x 
                    DB       $FF, +$45, -$13              ; draw, y, x 
                    DB       $FF, +$59, +$2A              ; draw, y, x 
                    DB       $FF, +$58, +$29              ; draw, y, x 
                    DB       $FF, -$52, +$35              ; draw, y, x 
                    DB       $FF, -$53, +$36              ; draw, y, x 
                    DB       $FF, -$45, -$11              ; draw, y, x 
                    DB       $FF, -$45, -$10              ; draw, y, x 
                    DB       $FF, +$73, +$35              ; draw, y, x 
                    DB       $FF, -$65, +$4E              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_23: 
                    DB       $01, -$7F, +$7F              ; sync and move to y, x 
                    DB       $00, -$7F, +$7F              ; additional sync move to y, x 
                    DB       $00, -$09, +$06              ; additional sync move to y, x 
                    DB       $FF, +$66, -$51              ; draw, y, x 
                    DB       $FF, +$1B, +$7F              ; draw, y, x 
                    DB       $FF, -$02, -$48              ; draw, y, x 
                    DB       $FF, -$03, -$47              ; draw, y, x 
                    DB       $FF, +$46, -$46              ; draw, y, x 
                    DB       $FF, +$46, -$45              ; draw, y, x 
                    DB       $FF, +$14, +$59              ; draw, y, x 
                    DB       $FF, +$14, +$59              ; draw, y, x 
                    DB       $FF, -$23, +$4B              ; draw, y, x 
                    DB       $FF, -$23, +$4B              ; draw, y, x 
                    DB       $FF, +$4B, -$77              ; draw, y, x 
                    DB       $FF, +$28, +$78              ; draw, y, x 
                    DB       $FF, -$14, -$75              ; draw, y, x 
                    DB       $FF, +$42, +$18              ; draw, y, x 
                    DB       $FF, +$42, +$18              ; draw, y, x 
                    DB       $FF, -$46, -$28              ; draw, y, x 
                    DB       $FF, -$45, -$28              ; draw, y, x 
                    DB       $FF, -$16, -$5D              ; draw, y, x 
                    DB       $FF, -$16, -$5C              ; draw, y, x 
                    DB       $01, +$0F, +$13              ; sync and move to y, x 
                    DB       $FF, +$58, +$19              ; draw, y, x 
                    DB       $FF, +$58, +$19              ; draw, y, x 
                    DB       $FF, +$56, +$7D              ; draw, y, x 
                    DB       $FF, -$36, -$75              ; draw, y, x 
                    DB       $FF, +$71, +$24              ; draw, y, x 
                    DB       $FF, -$5A, -$32              ; draw, y, x 
                    DB       $FF, +$5F, -$4A              ; draw, y, x 
                    DB       $FF, -$48, +$1F              ; draw, y, x 
                    DB       $FF, -$47, +$1F              ; draw, y, x 
                    DB       $FF, -$59, -$18              ; draw, y, x 
                    DB       $FF, -$59, -$18              ; draw, y, x 
                    DB       $FF, +$77, -$6D              ; draw, y, x 
                    DB       $FF, +$4C, -$04              ; draw, y, x 
                    DB       $FF, +$4D, -$04              ; draw, y, x 
                    DB       $FF, -$79, -$11              ; draw, y, x 
                    DB       $FF, +$63, -$6F              ; draw, y, x 
                    DB       $01, +$7F, -$7F              ; sync and move to y, x 
                    DB       $00, +$7F, -$73              ; additional sync move to y, x 
                    DB       $00, +$10, +$00              ; additional sync move to y, x 
                    DB       $FF, -$6F, +$5F              ; draw, y, x 
                    DB       $FF, -$04, -$40              ; draw, y, x 
                    DB       $FF, -$03, -$40              ; draw, y, x 
                    DB       $FF, -$0D, +$4E              ; draw, y, x 
                    DB       $FF, -$0D, +$4D              ; draw, y, x 
                    DB       $FF, -$77, +$6E              ; draw, y, x 
                    DB       $FF, -$16, -$5E              ; draw, y, x 
                    DB       $FF, -$17, -$5F              ; draw, y, x 
                    DB       $FF, +$42, -$71              ; draw, y, x 
                    DB       $FF, -$47, +$5D              ; draw, y, x 
                    DB       $FF, -$16, -$48              ; draw, y, x 
                    DB       $FF, -$17, -$49              ; draw, y, x 
                    DB       $FF, +$07, +$49              ; draw, y, x 
                    DB       $FF, +$06, +$48              ; draw, y, x 
                    DB       $FF, -$75, -$47              ; draw, y, x 
                    DB       $FF, +$42, +$31              ; draw, y, x 
                    DB       $FF, +$42, +$31              ; draw, y, x 
                    DB       $FF, +$1C, +$5E              ; draw, y, x 
                    DB       $FF, +$1C, +$5E              ; draw, y, x 
                    DB       $01, -$04, -$04              ; sync and move to y, x 
                    DB       $FF, -$5D, -$1B              ; draw, y, x 
                    DB       $FF, -$5E, -$1B              ; draw, y, x 
                    DB       $FF, -$2A, -$4C              ; draw, y, x 
                    DB       $FF, -$2B, -$4C              ; draw, y, x 
                    DB       $FF, +$19, +$47              ; draw, y, x 
                    DB       $FF, +$19, +$47              ; draw, y, x 
                    DB       $FF, -$78, -$1E              ; draw, y, x 
                    DB       $FF, +$75, +$2C              ; draw, y, x 
                    DB       $FF, -$66, +$48              ; draw, y, x 
                    DB       $FF, +$41, -$1E              ; draw, y, x 
                    DB       $FF, +$41, -$1E              ; draw, y, x 
                    DB       $FF, +$5E, +$1A              ; draw, y, x 
                    DB       $FF, +$5E, +$1A              ; draw, y, x 
                    DB       $FF, -$48, +$42              ; draw, y, x 
                    DB       $FF, -$48, +$42              ; draw, y, x 
                    DB       $FF, -$46, -$04              ; draw, y, x 
                    DB       $FF, -$47, -$04              ; draw, y, x 
                    DB       $FF, +$7A, +$20              ; draw, y, x 
                    DB       $FF, -$57, +$5E              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_24: 
                    DB       $01, -$7F, +$7F              ; sync and move to y, x 
                    DB       $00, -$58, +$7F              ; additional sync move to y, x 
                    DB       $00, +$00, +$2F              ; additional sync move to y, x 
                    DB       $FF, +$57, -$61              ; draw, y, x 
                    DB       $FF, +$30, +$78              ; draw, y, x 
                    DB       $FF, -$0E, -$46              ; draw, y, x 
                    DB       $FF, -$0F, -$46              ; draw, y, x 
                    DB       $FF, +$39, -$50              ; draw, y, x 
                    DB       $FF, +$39, -$50              ; draw, y, x 
                    DB       $FF, +$22, +$54              ; draw, y, x 
                    DB       $FF, +$23, +$54              ; draw, y, x 
                    DB       $FF, -$16, +$4F              ; draw, y, x 
                    DB       $FF, -$15, +$50              ; draw, y, x 
                    DB       $FF, +$1B, -$41              ; draw, y, x 
                    DB       $FF, +$1B, -$40              ; draw, y, x 
                    DB       $FF, +$3B, +$6F              ; draw, y, x 
                    DB       $FF, -$27, -$6F              ; draw, y, x 
                    DB       $FF, +$45, +$0C              ; draw, y, x 
                    DB       $FF, +$45, +$0D              ; draw, y, x 
                    DB       $FF, -$4B, -$1C              ; draw, y, x 
                    DB       $FF, -$4B, -$1C              ; draw, y, x 
                    DB       $FF, -$26, -$58              ; draw, y, x 
                    DB       $FF, -$25, -$57              ; draw, y, x 
                    DB       $01, +$12, +$10              ; sync and move to y, x 
                    DB       $FF, +$5B, +$0A              ; draw, y, x 
                    DB       $FF, +$5B, +$0A              ; draw, y, x 
                    DB       $FF, +$6A, +$6C              ; draw, y, x 
                    DB       $FF, -$49, -$6A              ; draw, y, x 
                    DB       $FF, +$75, +$11              ; draw, y, x 
                    DB       $FF, -$61, -$22              ; draw, y, x 
                    DB       $FF, +$51, -$5A              ; draw, y, x 
                    DB       $FF, -$41, +$2B              ; draw, y, x 
                    DB       $FF, -$41, +$2B              ; draw, y, x 
                    DB       $FF, -$5C, -$09              ; draw, y, x 
                    DB       $FF, -$5C, -$08              ; draw, y, x 
                    DB       $FF, +$32, -$40              ; draw, y, x 
                    DB       $FF, +$32, -$40              ; draw, y, x 
                    DB       $FF, +$4A, -$11              ; draw, y, x 
                    DB       $FF, +$4B, -$11              ; draw, y, x 
                    DB       $FF, -$7A, +$04              ; draw, y, x 
                    DB       $FF, +$4E, -$7E              ; draw, y, x 
                    DB       $01, +$7F, -$7F              ; sync and move to y, x 
                    DB       $00, +$62, -$7F              ; additional sync move to y, x 
                    DB       $00, +$00, -$1E              ; additional sync move to y, x 
                    DB       $FF, -$5D, +$71              ; draw, y, x 
                    DB       $FF, -$1D, -$7E              ; draw, y, x 
                    DB       $FF, +$00, +$4F              ; draw, y, x 
                    DB       $FF, +$00, +$4E              ; draw, y, x 
                    DB       $FF, -$31, +$41              ; draw, y, x 
                    DB       $FF, -$30, +$40              ; draw, y, x 
                    DB       $FF, -$26, -$59              ; draw, y, x 
                    DB       $FF, -$27, -$5A              ; draw, y, x 
                    DB       $FF, +$2E, -$7A              ; draw, y, x 
                    DB       $FF, -$37, +$68              ; draw, y, x 
                    DB       $FF, -$22, -$44              ; draw, y, x 
                    DB       $FF, -$23, -$44              ; draw, y, x 
                    DB       $FF, +$13, +$46              ; draw, y, x 
                    DB       $FF, +$13, +$46              ; draw, y, x 
                    DB       $FF, -$7F, -$31              ; draw, y, x 
                    DB       $FF, +$4A, +$25              ; draw, y, x 
                    DB       $FF, +$49, +$25              ; draw, y, x 
                    DB       $FF, +$2B, +$58              ; draw, y, x 
                    DB       $FF, +$2B, +$57              ; draw, y, x 
                    DB       $01, -$05, -$04              ; sync and move to y, x 
                    DB       $FF, -$60, -$0A              ; draw, y, x 
                    DB       $FF, -$61, -$0B              ; draw, y, x 
                    DB       $FF, -$36, -$43              ; draw, y, x 
                    DB       $FF, -$37, -$44              ; draw, y, x 
                    DB       $FF, +$24, +$42              ; draw, y, x 
                    DB       $FF, +$24, +$41              ; draw, y, x 
                    DB       $FF, -$7A, -$09              ; draw, y, x 
                    DB       $FF, +$7A, +$17              ; draw, y, x 
                    DB       $FF, -$59, +$59              ; draw, y, x 
                    DB       $FF, +$76, -$52              ; draw, y, x 
                    DB       $FF, +$62, +$0A              ; draw, y, x 
                    DB       $FF, +$61, +$0A              ; draw, y, x 
                    DB       $FF, -$3C, +$4D              ; draw, y, x 
                    DB       $FF, -$3C, +$4E              ; draw, y, x 
                    DB       $FF, -$46, +$07              ; draw, y, x 
                    DB       $FF, -$47, +$08              ; draw, y, x 
                    DB       $FF, +$7E, +$0B              ; draw, y, x 
                    DB       $FF, -$45, +$6C              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_25: 
                    DB       $01, -$7F, +$7F              ; sync and move to y, x 
                    DB       $00, -$22, +$7F              ; additional sync move to y, x 
                    DB       $00, +$00, +$4F              ; additional sync move to y, x 
                    DB       $FF, +$45, -$6F              ; draw, y, x 
                    DB       $FF, +$44, +$6F              ; draw, y, x 
                    DB       $FF, -$1A, -$43              ; draw, y, x 
                    DB       $FF, -$1A, -$42              ; draw, y, x 
                    DB       $FF, +$2B, -$59              ; draw, y, x 
                    DB       $FF, +$2A, -$59              ; draw, y, x 
                    DB       $FF, +$30, +$4D              ; draw, y, x 
                    DB       $FF, +$31, +$4E              ; draw, y, x 
                    DB       $FF, -$08, +$52              ; draw, y, x 
                    DB       $FF, -$08, +$52              ; draw, y, x 
                    DB       $FF, +$0F, -$45              ; draw, y, x 
                    DB       $FF, +$10, -$44              ; draw, y, x 
                    DB       $FF, +$4D, +$64              ; draw, y, x 
                    DB       $FF, -$39, -$67              ; draw, y, x 
                    DB       $FF, +$46, +$00              ; draw, y, x 
                    DB       $FF, +$46, +$01              ; draw, y, x 
                    DB       $FF, -$4F, -$0F              ; draw, y, x 
                    DB       $FF, -$4E, -$0F              ; draw, y, x 
                    DB       $FF, -$34, -$50              ; draw, y, x 
                    DB       $FF, -$33, -$4F              ; draw, y, x 
                    DB       $01, +$15, +$0D              ; sync and move to y, x 
                    DB       $FF, +$5B, -$06              ; draw, y, x 
                    DB       $FF, +$5B, -$05              ; draw, y, x 
                    DB       $FF, +$7B, +$59              ; draw, y, x 
                    DB       $FF, -$5A, -$5D              ; draw, y, x 
                    DB       $FF, +$76, -$03              ; draw, y, x 
                    DB       $FF, -$65, -$11              ; draw, y, x 
                    DB       $FF, +$41, -$66              ; draw, y, x 
                    DB       $FF, -$72, +$6A              ; draw, y, x 
                    DB       $FF, -$5C, +$07              ; draw, y, x 
                    DB       $FF, -$5C, +$07              ; draw, y, x 
                    DB       $FF, +$26, -$47              ; draw, y, x 
                    DB       $FF, +$26, -$47              ; draw, y, x 
                    DB       $FF, +$47, -$1D              ; draw, y, x 
                    DB       $FF, +$47, -$1E              ; draw, y, x 
                    DB       $FF, -$78, +$19              ; draw, y, x 
                    DB       $FF, +$1C, -$45              ; draw, y, x 
                    DB       $FF, +$1C, -$45              ; draw, y, x 
                    DB       $01, +$7F, -$7F              ; sync and move to y, x 
                    DB       $00, +$2F, -$7F              ; additional sync move to y, x 
                    DB       $00, +$00, -$40              ; additional sync move to y, x 
                    DB       $FF, -$49, +$7F              ; draw, y, x 
                    DB       $FF, -$32, -$77              ; draw, y, x 
                    DB       $FF, +$0D, +$4E              ; draw, y, x 
                    DB       $FF, +$0E, +$4D              ; draw, y, x 
                    DB       $FF, -$25, +$48              ; draw, y, x 
                    DB       $FF, -$25, +$47              ; draw, y, x 
                    DB       $FF, -$35, -$51              ; draw, y, x 
                    DB       $FF, -$35, -$52              ; draw, y, x 
                    DB       $FF, +$0C, -$40              ; draw, y, x 
                    DB       $FF, +$0C, -$40              ; draw, y, x 
                    DB       $FF, -$24, +$6F              ; draw, y, x 
                    DB       $FF, -$5B, -$7A              ; draw, y, x 
                    DB       $FF, +$1F, +$42              ; draw, y, x 
                    DB       $FF, +$1F, +$42              ; draw, y, x 
                    DB       $FF, -$43, -$0D              ; draw, y, x 
                    DB       $FF, -$43, -$0E              ; draw, y, x 
                    DB       $FF, +$4F, +$18              ; draw, y, x 
                    DB       $FF, +$4E, +$18              ; draw, y, x 
                    DB       $FF, +$3A, +$4F              ; draw, y, x 
                    DB       $FF, +$39, +$4F              ; draw, y, x 
                    DB       $01, -$05, -$03              ; sync and move to y, x 
                    DB       $FF, -$61, +$06              ; draw, y, x 
                    DB       $FF, -$61, +$06              ; draw, y, x 
                    DB       $FF, -$41, -$39              ; draw, y, x 
                    DB       $FF, -$42, -$3A              ; draw, y, x 
                    DB       $FF, +$5E, +$75              ; draw, y, x 
                    DB       $FF, -$7B, +$0C              ; draw, y, x 
                    DB       $FF, +$7D, +$02              ; draw, y, x 
                    DB       $FF, -$48, +$67              ; draw, y, x 
                    DB       $FF, +$66, -$65              ; draw, y, x 
                    DB       $FF, +$62, -$07              ; draw, y, x 
                    DB       $FF, +$61, -$07              ; draw, y, x 
                    DB       $FF, -$2E, +$57              ; draw, y, x 
                    DB       $FF, -$2E, +$57              ; draw, y, x 
                    DB       $FF, -$44, +$13              ; draw, y, x 
                    DB       $FF, -$44, +$13              ; draw, y, x 
                    DB       $FF, +$7E, -$0A              ; draw, y, x 
                    DB       $FF, -$32, +$76              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_26: 
                    DB       $01, -$67, +$7F              ; sync and move to y, x 
                    DB       $00, +$00, +$7F              ; additional sync move to y, x 
                    DB       $00, +$00, +$66              ; additional sync move to y, x 
                    DB       $FF, +$32, -$79              ; draw, y, x 
                    DB       $FF, +$55, +$61              ; draw, y, x 
                    DB       $FF, -$49, -$7A              ; draw, y, x 
                    DB       $FF, +$1B, -$5F              ; draw, y, x 
                    DB       $FF, +$1B, -$5E              ; draw, y, x 
                    DB       $FF, +$3C, +$43              ; draw, y, x 
                    DB       $FF, +$3D, +$44              ; draw, y, x 
                    DB       $FF, +$06, +$52              ; draw, y, x 
                    DB       $FF, +$06, +$53              ; draw, y, x 
                    DB       $FF, +$04, -$46              ; draw, y, x 
                    DB       $FF, +$04, -$46              ; draw, y, x 
                    DB       $FF, +$5D, +$55              ; draw, y, x 
                    DB       $FF, -$4A, -$5C              ; draw, y, x 
                    DB       $FF, +$45, -$0B              ; draw, y, x 
                    DB       $FF, +$45, -$0B              ; draw, y, x 
                    DB       $FF, -$50, -$02              ; draw, y, x 
                    DB       $FF, -$50, -$01              ; draw, y, x 
                    DB       $FF, -$41, -$46              ; draw, y, x 
                    DB       $FF, -$40, -$46              ; draw, y, x 
                    DB       $01, +$16, +$09              ; sync and move to y, x 
                    DB       $FF, +$59, -$15              ; draw, y, x 
                    DB       $FF, +$59, -$15              ; draw, y, x 
                    DB       $FF, +$44, +$21              ; draw, y, x 
                    DB       $FF, +$45, +$22              ; draw, y, x 
                    DB       $FF, -$69, -$4C              ; draw, y, x 
                    DB       $FF, +$74, -$17              ; draw, y, x 
                    DB       $FF, -$66, +$00              ; draw, y, x 
                    DB       $FF, +$2E, -$6F              ; draw, y, x 
                    DB       $FF, -$5E, +$7C              ; draw, y, x 
                    DB       $FF, -$5A, +$17              ; draw, y, x 
                    DB       $FF, -$59, +$16              ; draw, y, x 
                    DB       $FF, +$19, -$4D              ; draw, y, x 
                    DB       $FF, +$1A, -$4D              ; draw, y, x 
                    DB       $FF, +$41, -$28              ; draw, y, x 
                    DB       $FF, +$41, -$29              ; draw, y, x 
                    DB       $FF, -$72, +$2C              ; draw, y, x 
                    DB       $FF, +$0F, -$48              ; draw, y, x 
                    DB       $FF, +$10, -$49              ; draw, y, x 
                    DB       $01, +$75, -$7F              ; sync and move to y, x 
                    DB       $00, +$00, -$7F              ; additional sync move to y, x 
                    DB       $00, +$00, -$59              ; additional sync move to y, x 
                    DB       $FF, -$19, +$45              ; draw, y, x 
                    DB       $FF, -$19, +$45              ; draw, y, x 
                    DB       $FF, -$45, -$6D              ; draw, y, x 
                    DB       $FF, +$1A, +$4A              ; draw, y, x 
                    DB       $FF, +$1B, +$4A              ; draw, y, x 
                    DB       $FF, -$19, +$4D              ; draw, y, x 
                    DB       $FF, -$18, +$4D              ; draw, y, x 
                    DB       $FF, -$42, -$47              ; draw, y, x 
                    DB       $FF, -$42, -$48              ; draw, y, x 
                    DB       $FF, +$01, -$41              ; draw, y, x 
                    DB       $FF, +$01, -$42              ; draw, y, x 
                    DB       $FF, -$11, +$74              ; draw, y, x 
                    DB       $FF, -$6E, -$69              ; draw, y, x 
                    DB       $FF, +$53, +$78              ; draw, y, x 
                    DB       $FF, -$44, -$02              ; draw, y, x 
                    DB       $FF, -$45, -$02              ; draw, y, x 
                    DB       $FF, +$52, +$0A              ; draw, y, x 
                    DB       $FF, +$51, +$0A              ; draw, y, x 
                    DB       $FF, +$46, +$45              ; draw, y, x 
                    DB       $FF, +$46, +$44              ; draw, y, x 
                    DB       $01, -$06, -$02              ; sync and move to y, x 
                    DB       $FF, -$5E, +$16              ; draw, y, x 
                    DB       $FF, -$5F, +$17              ; draw, y, x 
                    DB       $FF, -$4A, -$2E              ; draw, y, x 
                    DB       $FF, -$4A, -$2E              ; draw, y, x 
                    DB       $FF, +$70, +$64              ; draw, y, x 
                    DB       $FF, -$77, +$20              ; draw, y, x 
                    DB       $FF, +$7B, -$13              ; draw, y, x 
                    DB       $FF, -$35, +$72              ; draw, y, x 
                    DB       $FF, +$53, -$75              ; draw, y, x 
                    DB       $FF, +$5F, -$17              ; draw, y, x 
                    DB       $FF, +$5F, -$17              ; draw, y, x 
                    DB       $FF, -$1E, +$5D              ; draw, y, x 
                    DB       $FF, -$1F, +$5D              ; draw, y, x 
                    DB       $FF, -$7F, +$3D              ; draw, y, x 
                    DB       $FF, +$7A, -$1F              ; draw, y, x 
                    DB       $FF, -$1E, +$7D              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_27: 
                    DB       $01, -$29, +$7F              ; sync and move to y, x 
                    DB       $00, +$00, +$7F              ; additional sync move to y, x 
                    DB       $00, +$00, +$72              ; additional sync move to y, x 
                    DB       $FF, +$0E, -$40              ; draw, y, x 
                    DB       $FF, +$0E, -$40              ; draw, y, x 
                    DB       $FF, +$65, +$52              ; draw, y, x 
                    DB       $FF, -$5D, -$6C              ; draw, y, x 
                    DB       $FF, +$0A, -$62              ; draw, y, x 
                    DB       $FF, +$0B, -$62              ; draw, y, x 
                    DB       $FF, +$47, +$38              ; draw, y, x 
                    DB       $FF, +$48, +$39              ; draw, y, x 
                    DB       $FF, +$14, +$50              ; draw, y, x 
                    DB       $FF, +$14, +$51              ; draw, y, x 
                    DB       $FF, -$09, -$46              ; draw, y, x 
                    DB       $FF, -$08, -$46              ; draw, y, x 
                    DB       $FF, +$6A, +$44              ; draw, y, x 
                    DB       $FF, -$58, -$4E              ; draw, y, x 
                    DB       $FF, +$42, -$17              ; draw, y, x 
                    DB       $FF, +$42, -$16              ; draw, y, x 
                    DB       $FF, -$4F, +$0C              ; draw, y, x 
                    DB       $FF, -$4F, +$0C              ; draw, y, x 
                    DB       $FF, -$4B, -$3A              ; draw, y, x 
                    DB       $FF, -$4B, -$3A              ; draw, y, x 
                    DB       $01, +$18, +$05              ; sync and move to y, x 
                    DB       $FF, +$54, -$23              ; draw, y, x 
                    DB       $FF, +$54, -$24              ; draw, y, x 
                    DB       $FF, +$49, +$16              ; draw, y, x 
                    DB       $FF, +$49, +$15              ; draw, y, x 
                    DB       $FF, -$74, -$39              ; draw, y, x 
                    DB       $FF, +$6E, -$2B              ; draw, y, x 
                    DB       $FF, -$65, +$12              ; draw, y, x 
                    DB       $FF, +$1B, -$76              ; draw, y, x 
                    DB       $FF, -$24, +$45              ; draw, y, x 
                    DB       $FF, -$24, +$45              ; draw, y, x 
                    DB       $FF, -$55, +$26              ; draw, y, x 
                    DB       $FF, -$54, +$25              ; draw, y, x 
                    DB       $FF, +$0C, -$50              ; draw, y, x 
                    DB       $FF, +$0D, -$50              ; draw, y, x 
                    DB       $FF, +$72, -$66              ; draw, y, x 
                    DB       $FF, -$69, +$3F              ; draw, y, x 
                    DB       $FF, +$03, -$4A              ; draw, y, x 
                    DB       $FF, +$04, -$4B              ; draw, y, x 
                    DB       $01, +$3A, -$7F              ; sync and move to y, x 
                    DB       $00, +$00, -$7F              ; additional sync move to y, x 
                    DB       $00, +$00, -$68              ; additional sync move to y, x 
                    DB       $FF, -$0E, +$48              ; draw, y, x 
                    DB       $FF, -$0D, +$48              ; draw, y, x 
                    DB       $FF, -$56, -$60              ; draw, y, x 
                    DB       $FF, +$27, +$45              ; draw, y, x 
                    DB       $FF, +$26, +$44              ; draw, y, x 
                    DB       $FF, -$0B, +$51              ; draw, y, x 
                    DB       $FF, -$0B, +$50              ; draw, y, x 
                    DB       $FF, -$4D, -$3B              ; draw, y, x 
                    DB       $FF, -$4E, -$3C              ; draw, y, x 
                    DB       $FF, -$09, -$40              ; draw, y, x 
                    DB       $FF, -$0A, -$41              ; draw, y, x 
                    DB       $FF, +$03, +$75              ; draw, y, x 
                    DB       $FF, -$7E, -$55              ; draw, y, x 
                    DB       $FF, +$65, +$68              ; draw, y, x 
                    DB       $FF, -$43, +$0A              ; draw, y, x 
                    DB       $FF, -$44, +$09              ; draw, y, x 
                    DB       $FF, +$52, -$03              ; draw, y, x 
                    DB       $FF, +$52, -$04              ; draw, y, x 
                    DB       $FF, +$51, +$38              ; draw, y, x 
                    DB       $FF, +$50, +$37              ; draw, y, x 
                    DB       $01, -$06, -$01              ; sync and move to y, x 
                    DB       $FF, -$59, +$26              ; draw, y, x 
                    DB       $FF, -$5A, +$26              ; draw, y, x 
                    DB       $FF, -$50, -$21              ; draw, y, x 
                    DB       $FF, -$51, -$20              ; draw, y, x 
                    DB       $FF, +$7F, +$4F              ; draw, y, x 
                    DB       $FF, -$70, +$34              ; draw, y, x 
                    DB       $FF, +$76, -$27              ; draw, y, x 
                    DB       $FF, -$21, +$79              ; draw, y, x 
                    DB       $FF, +$20, -$41              ; draw, y, x 
                    DB       $FF, +$1F, -$41              ; draw, y, x 
                    DB       $FF, +$5A, -$27              ; draw, y, x 
                    DB       $FF, +$59, -$26              ; draw, y, x 
                    DB       $FF, -$0E, +$61              ; draw, y, x 
                    DB       $FF, -$0F, +$61              ; draw, y, x 
                    DB       $FF, -$73, +$52              ; draw, y, x 
                    DB       $FF, +$73, -$34              ; draw, y, x 
                    DB       $FF, -$04, +$40              ; draw, y, x 
                    DB       $FF, -$04, +$40              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_28: 
                    DB       $01, +$16, +$7F              ; sync and move to y, x 
                    DB       $00, +$00, +$7F              ; additional sync move to y, x 
                    DB       $00, +$00, +$73              ; additional sync move to y, x 
                    DB       $FF, +$03, -$41              ; draw, y, x 
                    DB       $FF, +$03, -$41              ; draw, y, x 
                    DB       $FF, +$71, +$3F              ; draw, y, x 
                    DB       $FF, -$6E, -$5A              ; draw, y, x 
                    DB       $FF, -$06, -$63              ; draw, y, x 
                    DB       $FF, -$06, -$62              ; draw, y, x 
                    DB       $FF, +$50, +$2C              ; draw, y, x 
                    DB       $FF, +$50, +$2C              ; draw, y, x 
                    DB       $FF, +$21, +$4B              ; draw, y, x 
                    DB       $FF, +$21, +$4C              ; draw, y, x 
                    DB       $FF, -$14, -$44              ; draw, y, x 
                    DB       $FF, -$14, -$43              ; draw, y, x 
                    DB       $FF, +$74, +$32              ; draw, y, x 
                    DB       $FF, -$64, -$3E              ; draw, y, x 
                    DB       $FF, +$7B, -$44              ; draw, y, x 
                    DB       $FF, -$4C, +$19              ; draw, y, x 
                    DB       $FF, -$4C, +$1A              ; draw, y, x 
                    DB       $FF, -$54, -$2D              ; draw, y, x 
                    DB       $FF, -$54, -$2C              ; draw, y, x 
                    DB       $01, +$18, +$01              ; sync and move to y, x 
                    DB       $FF, +$4D, -$31              ; draw, y, x 
                    DB       $FF, +$4D, -$32              ; draw, y, x 
                    DB       $FF, +$4B, +$09              ; draw, y, x 
                    DB       $FF, +$4C, +$09              ; draw, y, x 
                    DB       $FF, -$7C, -$25              ; draw, y, x 
                    DB       $FF, +$66, -$3C              ; draw, y, x 
                    DB       $FF, -$61, +$22              ; draw, y, x 
                    DB       $FF, +$07, -$78              ; draw, y, x 
                    DB       $FF, -$18, +$4A              ; draw, y, x 
                    DB       $FF, -$18, +$4A              ; draw, y, x 
                    DB       $FF, -$4D, +$33              ; draw, y, x 
                    DB       $FF, -$4D, +$33              ; draw, y, x 
                    DB       $FF, -$01, -$51              ; draw, y, x 
                    DB       $FF, -$01, -$51              ; draw, y, x 
                    DB       $FF, +$5F, -$78              ; draw, y, x 
                    DB       $FF, -$5D, +$50              ; draw, y, x 
                    DB       $FF, -$09, -$49              ; draw, y, x 
                    DB       $FF, -$09, -$4A              ; draw, y, x 
                    DB       $01, -$03, -$7F              ; sync and move to y, x 
                    DB       $00, +$00, -$7F              ; additional sync move to y, x 
                    DB       $00, +$00, -$6C              ; additional sync move to y, x 
                    DB       $FF, -$01, +$49              ; draw, y, x 
                    DB       $FF, -$01, +$49              ; draw, y, x 
                    DB       $FF, -$66, -$50              ; draw, y, x 
                    DB       $FF, +$64, +$7A              ; draw, y, x 
                    DB       $FF, +$02, +$51              ; draw, y, x 
                    DB       $FF, +$02, +$51              ; draw, y, x 
                    DB       $FF, -$56, -$2D              ; draw, y, x 
                    DB       $FF, -$56, -$2E              ; draw, y, x 
                    DB       $FF, -$29, -$7C              ; draw, y, x 
                    DB       $FF, +$17, +$73              ; draw, y, x 
                    DB       $FF, -$45, -$1F              ; draw, y, x 
                    DB       $FF, -$46, -$1F              ; draw, y, x 
                    DB       $FF, +$76, +$55              ; draw, y, x 
                    DB       $FF, -$41, +$15              ; draw, y, x 
                    DB       $FF, -$41, +$15              ; draw, y, x 
                    DB       $FF, +$50, -$11              ; draw, y, x 
                    DB       $FF, +$50, -$12              ; draw, y, x 
                    DB       $FF, +$59, +$29              ; draw, y, x 
                    DB       $FF, +$59, +$29              ; draw, y, x 
                    DB       $01, -$06, +$00              ; sync and move to y, x 
                    DB       $FF, -$52, +$34              ; draw, y, x 
                    DB       $FF, -$52, +$35              ; draw, y, x 
                    DB       $FF, -$54, -$13              ; draw, y, x 
                    DB       $FF, -$55, -$12              ; draw, y, x 
                    DB       $FF, +$45, +$1C              ; draw, y, x 
                    DB       $FF, +$45, +$1D              ; draw, y, x 
                    DB       $FF, -$65, +$46              ; draw, y, x 
                    DB       $FF, +$6E, -$3B              ; draw, y, x 
                    DB       $FF, -$0D, +$7D              ; draw, y, x 
                    DB       $FF, +$14, -$45              ; draw, y, x 
                    DB       $FF, +$14, -$45              ; draw, y, x 
                    DB       $FF, +$52, -$36              ; draw, y, x 
                    DB       $FF, +$52, -$35              ; draw, y, x 
                    DB       $FF, +$02, +$62              ; draw, y, x 
                    DB       $FF, +$02, +$62              ; draw, y, x 
                    DB       $FF, -$64, +$64              ; draw, y, x 
                    DB       $FF, +$69, -$46              ; draw, y, x 
                    DB       $FF, +$0E, +$7F              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_29: 
                    DB       $01, +$54, +$7F              ; sync and move to y, x 
                    DB       $00, +$00, +$7F              ; additional sync move to y, x 
                    DB       $00, +$00, +$6A              ; additional sync move to y, x 
                    DB       $FF, -$08, -$41              ; draw, y, x 
                    DB       $FF, -$08, -$40              ; draw, y, x 
                    DB       $FF, +$7A, +$2B              ; draw, y, x 
                    DB       $FF, -$7C, -$46              ; draw, y, x 
                    DB       $FF, -$17, -$60              ; draw, y, x 
                    DB       $FF, -$16, -$60              ; draw, y, x 
                    DB       $FF, +$56, +$1D              ; draw, y, x 
                    DB       $FF, +$56, +$1E              ; draw, y, x 
                    DB       $FF, +$2D, +$45              ; draw, y, x 
                    DB       $FF, +$2E, +$45              ; draw, y, x 
                    DB       $FF, -$3E, -$7E              ; draw, y, x 
                    DB       $FF, +$7B, +$1D              ; draw, y, x 
                    DB       $FF, -$6D, -$2C              ; draw, y, x 
                    DB       $FF, +$6E, -$57              ; draw, y, x 
                    DB       $FF, -$47, +$25              ; draw, y, x 
                    DB       $FF, -$47, +$26              ; draw, y, x 
                    DB       $FF, -$5A, -$1E              ; draw, y, x 
                    DB       $FF, -$5A, -$1D              ; draw, y, x 
                    DB       $01, +$18, -$03              ; sync and move to y, x 
                    DB       $FF, +$43, -$3D              ; draw, y, x 
                    DB       $FF, +$44, -$3E              ; draw, y, x 
                    DB       $FF, +$4C, -$04              ; draw, y, x 
                    DB       $FF, +$4C, -$04              ; draw, y, x 
                    DB       $FF, -$40, -$08              ; draw, y, x 
                    DB       $FF, -$40, -$08              ; draw, y, x 
                    DB       $FF, +$59, -$4C              ; draw, y, x 
                    DB       $FF, -$59, +$32              ; draw, y, x 
                    DB       $FF, -$0E, -$78              ; draw, y, x 
                    DB       $FF, -$0B, +$4D              ; draw, y, x 
                    DB       $FF, -$0B, +$4D              ; draw, y, x 
                    DB       $FF, -$43, +$40              ; draw, y, x 
                    DB       $FF, -$43, +$3F              ; draw, y, x 
                    DB       $FF, -$0F, -$4F              ; draw, y, x 
                    DB       $FF, -$0F, -$50              ; draw, y, x 
                    DB       $FF, +$24, -$43              ; draw, y, x 
                    DB       $FF, +$25, -$44              ; draw, y, x 
                    DB       $FF, -$4E, +$5F              ; draw, y, x 
                    DB       $FF, -$15, -$47              ; draw, y, x 
                    DB       $FF, -$16, -$47              ; draw, y, x 
                    DB       $01, -$41, -$7F              ; sync and move to y, x 
                    DB       $00, +$00, -$7F              ; additional sync move to y, x 
                    DB       $00, +$00, -$66              ; additional sync move to y, x 
                    DB       $FF, +$0C, +$48              ; draw, y, x 
                    DB       $FF, +$0B, +$48              ; draw, y, x 
                    DB       $FF, -$71, -$3D              ; draw, y, x 
                    DB       $FF, +$76, +$67              ; draw, y, x 
                    DB       $FF, +$11, +$50              ; draw, y, x 
                    DB       $FF, +$10, +$4F              ; draw, y, x 
                    DB       $FF, -$5C, -$1E              ; draw, y, x 
                    DB       $FF, -$5D, -$1F              ; draw, y, x 
                    DB       $FF, -$3E, -$73              ; draw, y, x 
                    DB       $FF, +$2A, +$6D              ; draw, y, x 
                    DB       $FF, -$49, -$13              ; draw, y, x 
                    DB       $FF, -$4A, -$13              ; draw, y, x 
                    DB       $FF, +$41, +$20              ; draw, y, x 
                    DB       $FF, +$41, +$20              ; draw, y, x 
                    DB       $FF, -$79, +$3F              ; draw, y, x 
                    DB       $FF, +$4C, -$1E              ; draw, y, x 
                    DB       $FF, +$4C, -$1F              ; draw, y, x 
                    DB       $FF, +$5F, +$1A              ; draw, y, x 
                    DB       $FF, +$5E, +$19              ; draw, y, x 
                    DB       $01, -$06, +$01              ; sync and move to y, x 
                    DB       $FF, -$47, +$41              ; draw, y, x 
                    DB       $FF, -$48, +$42              ; draw, y, x 
                    DB       $FF, -$57, -$04              ; draw, y, x 
                    DB       $FF, -$57, -$03              ; draw, y, x 
                    DB       $FF, +$49, +$10              ; draw, y, x 
                    DB       $FF, +$49, +$10              ; draw, y, x 
                    DB       $FF, -$58, +$56              ; draw, y, x 
                    DB       $FF, +$62, -$4C              ; draw, y, x 
                    DB       $FF, +$09, +$7D              ; draw, y, x 
                    DB       $FF, +$08, -$48              ; draw, y, x 
                    DB       $FF, +$08, -$47              ; draw, y, x 
                    DB       $FF, +$48, -$43              ; draw, y, x 
                    DB       $FF, +$47, -$42              ; draw, y, x 
                    DB       $FF, +$13, +$60              ; draw, y, x 
                    DB       $FF, +$13, +$61              ; draw, y, x 
                    DB       $FF, -$52, +$73              ; draw, y, x 
                    DB       $FF, +$5C, -$57              ; draw, y, x 
                    DB       $FF, +$23, +$7B              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_30: 
                    DB       $01, +$7F, +$7F              ; sync and move to y, x 
                    DB       $00, +$11, +$7F              ; additional sync move to y, x 
                    DB       $00, +$00, +$57              ; additional sync move to y, x 
                    DB       $FF, -$26, -$7D              ; draw, y, x 
                    DB       $FF, +$40, +$0B              ; draw, y, x 
                    DB       $FF, +$40, +$0B              ; draw, y, x 
                    DB       $FF, -$43, -$19              ; draw, y, x 
                    DB       $FF, -$43, -$18              ; draw, y, x 
                    DB       $FF, -$27, -$5B              ; draw, y, x 
                    DB       $FF, -$26, -$5A              ; draw, y, x 
                    DB       $FF, +$59, +$0E              ; draw, y, x 
                    DB       $FF, +$5A, +$0F              ; draw, y, x 
                    DB       $FF, +$72, +$79              ; draw, y, x 
                    DB       $FF, -$53, -$72              ; draw, y, x 
                    DB       $FF, +$7E, +$08              ; draw, y, x 
                    DB       $FF, -$73, -$19              ; draw, y, x 
                    DB       $FF, +$5D, -$68              ; draw, y, x 
                    DB       $FF, -$7E, +$62              ; draw, y, x 
                    DB       $FF, -$5E, -$0E              ; draw, y, x 
                    DB       $FF, -$5E, -$0E              ; draw, y, x 
                    DB       $01, +$17, -$07              ; sync and move to y, x 
                    DB       $FF, +$38, -$48              ; draw, y, x 
                    DB       $FF, +$38, -$48              ; draw, y, x 
                    DB       $FF, +$4A, -$11              ; draw, y, x 
                    DB       $FF, +$4A, -$11              ; draw, y, x 
                    DB       $FF, -$40, +$03              ; draw, y, x 
                    DB       $FF, -$40, +$03              ; draw, y, x 
                    DB       $FF, +$4B, -$5A              ; draw, y, x 
                    DB       $FF, -$50, +$40              ; draw, y, x 
                    DB       $FF, -$21, -$74              ; draw, y, x 
                    DB       $FF, +$02, +$4E              ; draw, y, x 
                    DB       $FF, +$02, +$4E              ; draw, y, x 
                    DB       $FF, -$38, +$4A              ; draw, y, x 
                    DB       $FF, -$37, +$4A              ; draw, y, x 
                    DB       $FF, -$1C, -$4C              ; draw, y, x 
                    DB       $FF, -$1C, -$4C              ; draw, y, x 
                    DB       $FF, +$19, -$48              ; draw, y, x 
                    DB       $FF, +$18, -$49              ; draw, y, x 
                    DB       $FF, -$3D, +$6A              ; draw, y, x 
                    DB       $FF, -$21, -$42              ; draw, y, x 
                    DB       $FF, -$21, -$42              ; draw, y, x 
                    DB       $01, -$7C, -$7F              ; sync and move to y, x 
                    DB       $00, +$00, -$7F              ; additional sync move to y, x 
                    DB       $00, +$00, -$56              ; additional sync move to y, x 
                    DB       $FF, +$18, +$45              ; draw, y, x 
                    DB       $FF, +$17, +$45              ; draw, y, x 
                    DB       $FF, -$7A, -$29              ; draw, y, x 
                    DB       $FF, +$43, +$29              ; draw, y, x 
                    DB       $FF, +$43, +$29              ; draw, y, x 
                    DB       $FF, +$1E, +$4C              ; draw, y, x 
                    DB       $FF, +$1D, +$4B              ; draw, y, x 
                    DB       $FF, -$60, -$0E              ; draw, y, x 
                    DB       $FF, -$61, -$0F              ; draw, y, x 
                    DB       $FF, -$50, -$67              ; draw, y, x 
                    DB       $FF, +$3C, +$65              ; draw, y, x 
                    DB       $FF, -$4C, -$06              ; draw, y, x 
                    DB       $FF, -$4C, -$07              ; draw, y, x 
                    DB       $FF, +$46, +$15              ; draw, y, x 
                    DB       $FF, +$46, +$14              ; draw, y, x 
                    DB       $FF, -$6D, +$53              ; draw, y, x 
                    DB       $FF, +$46, -$2B              ; draw, y, x 
                    DB       $FF, +$45, -$2B              ; draw, y, x 
                    DB       $FF, +$62, +$09              ; draw, y, x 
                    DB       $FF, +$61, +$09              ; draw, y, x 
                    DB       $01, -$06, +$02              ; sync and move to y, x 
                    DB       $FF, -$3B, +$4D              ; draw, y, x 
                    DB       $FF, -$3C, +$4D              ; draw, y, x 
                    DB       $FF, -$56, +$0B              ; draw, y, x 
                    DB       $FF, -$56, +$0B              ; draw, y, x 
                    DB       $FF, +$4B, +$03              ; draw, y, x 
                    DB       $FF, +$4A, +$03              ; draw, y, x 
                    DB       $FF, -$48, +$64              ; draw, y, x 
                    DB       $FF, +$54, -$5B              ; draw, y, x 
                    DB       $FF, +$1E, +$79              ; draw, y, x 
                    DB       $FF, -$04, -$48              ; draw, y, x 
                    DB       $FF, -$04, -$47              ; draw, y, x 
                    DB       $FF, +$3B, -$4E              ; draw, y, x 
                    DB       $FF, +$3B, -$4D              ; draw, y, x 
                    DB       $FF, +$22, +$5B              ; draw, y, x 
                    DB       $FF, +$23, +$5C              ; draw, y, x 
                    DB       $FF, -$1E, +$40              ; draw, y, x 
                    DB       $FF, -$1E, +$40              ; draw, y, x 
                    DB       $FF, +$4B, -$66              ; draw, y, x 
                    DB       $FF, +$38, +$74              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_31: 
                    DB       $01, +$7F, +$7F              ; sync and move to y, x 
                    DB       $00, +$48, +$7F              ; additional sync move to y, x 
                    DB       $00, +$00, +$3A              ; additional sync move to y, x 
                    DB       $FF, -$3A, -$75              ; draw, y, x 
                    DB       $FF, +$40, +$00              ; draw, y, x 
                    DB       $FF, +$41, +$00              ; draw, y, x 
                    DB       $FF, -$46, -$0D              ; draw, y, x 
                    DB       $FF, -$46, -$0C              ; draw, y, x 
                    DB       $FF, -$35, -$53              ; draw, y, x 
                    DB       $FF, -$35, -$53              ; draw, y, x 
                    DB       $FF, +$5B, -$01              ; draw, y, x 
                    DB       $FF, +$5B, -$01              ; draw, y, x 
                    DB       $FF, +$42, +$32              ; draw, y, x 
                    DB       $FF, +$42, +$32              ; draw, y, x 
                    DB       $FF, -$65, -$62              ; draw, y, x 
                    DB       $FF, +$7E, -$0E              ; draw, y, x 
                    DB       $FF, -$76, -$04              ; draw, y, x 
                    DB       $FF, +$4B, -$77              ; draw, y, x 
                    DB       $FF, -$6D, +$76              ; draw, y, x 
                    DB       $FF, -$5F, +$02              ; draw, y, x 
                    DB       $FF, -$5F, +$02              ; draw, y, x 
                    DB       $01, +$15, -$0B              ; sync and move to y, x 
                    DB       $FF, +$2B, -$50              ; draw, y, x 
                    DB       $FF, +$2C, -$51              ; draw, y, x 
                    DB       $FF, +$46, -$1D              ; draw, y, x 
                    DB       $FF, +$46, -$1D              ; draw, y, x 
                    DB       $FF, -$7E, +$1C              ; draw, y, x 
                    DB       $FF, +$3B, -$66              ; draw, y, x 
                    DB       $FF, -$43, +$4D              ; draw, y, x 
                    DB       $FF, -$35, -$6D              ; draw, y, x 
                    DB       $FF, +$0F, +$4D              ; draw, y, x 
                    DB       $FF, +$10, +$4C              ; draw, y, x 
                    DB       $FF, -$2B, +$52              ; draw, y, x 
                    DB       $FF, -$2A, +$52              ; draw, y, x 
                    DB       $FF, -$28, -$46              ; draw, y, x 
                    DB       $FF, -$29, -$46              ; draw, y, x 
                    DB       $FF, +$0C, -$4B              ; draw, y, x 
                    DB       $FF, +$0C, -$4C              ; draw, y, x 
                    DB       $FF, -$2A, +$73              ; draw, y, x 
                    DB       $FF, -$58, -$78              ; draw, y, x 
                    DB       $01, -$7F, -$7F              ; sync and move to y, x 
                    DB       $00, -$35, -$7F              ; additional sync move to y, x 
                    DB       $00, +$00, -$3D              ; additional sync move to y, x 
                    DB       $FF, +$23, +$41              ; draw, y, x 
                    DB       $FF, +$23, +$40              ; draw, y, x 
                    DB       $FF, -$7F, -$14              ; draw, y, x 
                    DB       $FF, +$49, +$1D              ; draw, y, x 
                    DB       $FF, +$49, +$1D              ; draw, y, x 
                    DB       $FF, +$2A, +$46              ; draw, y, x 
                    DB       $FF, +$29, +$45              ; draw, y, x 
                    DB       $FF, -$61, +$02              ; draw, y, x 
                    DB       $FF, -$61, +$02              ; draw, y, x 
                    DB       $FF, -$61, -$58              ; draw, y, x 
                    DB       $FF, +$4C, +$59              ; draw, y, x 
                    DB       $FF, -$4B, +$07              ; draw, y, x 
                    DB       $FF, -$4C, +$07              ; draw, y, x 
                    DB       $FF, +$48, +$08              ; draw, y, x 
                    DB       $FF, +$48, +$09              ; draw, y, x 
                    DB       $FF, -$5E, +$64              ; draw, y, x 
                    DB       $FF, +$7C, -$6D              ; draw, y, x 
                    DB       $FF, +$62, -$08              ; draw, y, x 
                    DB       $FF, +$61, -$07              ; draw, y, x 
                    DB       $01, -$05, +$03              ; sync and move to y, x 
                    DB       $FF, -$2E, +$56              ; draw, y, x 
                    DB       $FF, -$2E, +$56              ; draw, y, x 
                    DB       $FF, -$53, +$19              ; draw, y, x 
                    DB       $FF, -$53, +$19              ; draw, y, x 
                    DB       $FF, +$4A, -$09              ; draw, y, x 
                    DB       $FF, +$4A, -$09              ; draw, y, x 
                    DB       $FF, -$36, +$6F              ; draw, y, x 
                    DB       $FF, +$44, -$69              ; draw, y, x 
                    DB       $FF, +$31, +$73              ; draw, y, x 
                    DB       $FF, -$10, -$46              ; draw, y, x 
                    DB       $FF, -$10, -$46              ; draw, y, x 
                    DB       $FF, +$2E, -$57              ; draw, y, x 
                    DB       $FF, +$2D, -$56              ; draw, y, x 
                    DB       $FF, +$31, +$54              ; draw, y, x 
                    DB       $FF, +$32, +$55              ; draw, y, x 
                    DB       $FF, -$13, +$44              ; draw, y, x 
                    DB       $FF, -$13, +$44              ; draw, y, x 
                    DB       $FF, +$39, -$71              ; draw, y, x 
                    DB       $FF, +$4A, +$69              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_32: 
                    DB       $01, +$7F, +$7F              ; sync and move to y, x 
                    DB       $00, +$7A, +$7F              ; additional sync move to y, x 
                    DB       $00, +$00, +$14              ; additional sync move to y, x 
                    DB       $FF, -$4D, -$6A              ; draw, y, x 
                    DB       $FF, +$40, -$0B              ; draw, y, x 
                    DB       $FF, +$40, -$0A              ; draw, y, x 
                    DB       $FF, -$48, -$01              ; draw, y, x 
                    DB       $FF, -$47, -$01              ; draw, y, x 
                    DB       $FF, -$43, -$49              ; draw, y, x 
                    DB       $FF, -$42, -$48              ; draw, y, x 
                    DB       $FF, +$59, -$10              ; draw, y, x 
                    DB       $FF, +$5A, -$10              ; draw, y, x 
                    DB       $FF, +$49, +$26              ; draw, y, x 
                    DB       $FF, +$4A, +$26              ; draw, y, x 
                    DB       $FF, -$73, -$50              ; draw, y, x 
                    DB       $FF, +$79, -$23              ; draw, y, x 
                    DB       $FF, -$75, +$0F              ; draw, y, x 
                    DB       $FF, +$1A, -$40              ; draw, y, x 
                    DB       $FF, +$1B, -$41              ; draw, y, x 
                    DB       $FF, -$2B, +$43              ; draw, y, x 
                    DB       $FF, -$2B, +$43              ; draw, y, x 
                    DB       $FF, -$5E, +$13              ; draw, y, x 
                    DB       $FF, -$5D, +$12              ; draw, y, x 
                    DB       $01, +$13, -$0E              ; sync and move to y, x 
                    DB       $FF, +$1D, -$57              ; draw, y, x 
                    DB       $FF, +$1D, -$57              ; draw, y, x 
                    DB       $FF, +$40, -$28              ; draw, y, x 
                    DB       $FF, +$41, -$29              ; draw, y, x 
                    DB       $FF, -$78, +$31              ; draw, y, x 
                    DB       $FF, +$29, -$6F              ; draw, y, x 
                    DB       $FF, -$35, +$58              ; draw, y, x 
                    DB       $FF, -$47, -$62              ; draw, y, x 
                    DB       $FF, +$1C, +$49              ; draw, y, x 
                    DB       $FF, +$1C, +$48              ; draw, y, x 
                    DB       $FF, -$1C, +$58              ; draw, y, x 
                    DB       $FF, -$1B, +$58              ; draw, y, x 
                    DB       $FF, -$68, -$7C              ; draw, y, x 
                    DB       $FF, -$01, -$4C              ; draw, y, x 
                    DB       $FF, -$01, -$4D              ; draw, y, x 
                    DB       $FF, -$15, +$78              ; draw, y, x 
                    DB       $FF, -$6B, -$67              ; draw, y, x 
                    DB       $01, -$7F, -$7F              ; sync and move to y, x 
                    DB       $00, -$67, -$7F              ; additional sync move to y, x 
                    DB       $00, +$00, -$1A              ; additional sync move to y, x 
                    DB       $FF, +$5A, +$73              ; draw, y, x 
                    DB       $FF, -$40, +$01              ; draw, y, x 
                    DB       $FF, -$41, +$01              ; draw, y, x 
                    DB       $FF, +$4D, +$10              ; draw, y, x 
                    DB       $FF, +$4D, +$10              ; draw, y, x 
                    DB       $FF, +$6A, +$7B              ; draw, y, x 
                    DB       $FF, -$5F, +$13              ; draw, y, x 
                    DB       $FF, -$60, +$13              ; draw, y, x 
                    DB       $FF, -$6F, -$47              ; draw, y, x 
                    DB       $FF, +$5B, +$4B              ; draw, y, x 
                    DB       $FF, -$49, +$13              ; draw, y, x 
                    DB       $FF, -$4A, +$14              ; draw, y, x 
                    DB       $FF, +$49, -$04              ; draw, y, x 
                    DB       $FF, +$48, -$04              ; draw, y, x 
                    DB       $FF, -$4C, +$72              ; draw, y, x 
                    DB       $FF, +$34, -$40              ; draw, y, x 
                    DB       $FF, +$33, -$40              ; draw, y, x 
                    DB       $FF, +$5F, -$18              ; draw, y, x 
                    DB       $FF, +$5F, -$17              ; draw, y, x 
                    DB       $01, -$05, +$04              ; sync and move to y, x 
                    DB       $FF, -$1E, +$5C              ; draw, y, x 
                    DB       $FF, -$1F, +$5D              ; draw, y, x 
                    DB       $FF, -$4D, +$26              ; draw, y, x 
                    DB       $FF, -$4E, +$27              ; draw, y, x 
                    DB       $FF, +$48, -$16              ; draw, y, x 
                    DB       $FF, +$47, -$15              ; draw, y, x 
                    DB       $FF, -$22, +$76              ; draw, y, x 
                    DB       $FF, +$30, -$72              ; draw, y, x 
                    DB       $FF, +$44, +$69              ; draw, y, x 
                    DB       $FF, -$1B, -$43              ; draw, y, x 
                    DB       $FF, -$1C, -$42              ; draw, y, x 
                    DB       $FF, +$1E, -$5D              ; draw, y, x 
                    DB       $FF, +$1E, -$5D              ; draw, y, x 
                    DB       $FF, +$3F, +$4B              ; draw, y, x 
                    DB       $FF, +$40, +$4B              ; draw, y, x 
                    DB       $FF, -$08, +$46              ; draw, y, x 
                    DB       $FF, -$07, +$47              ; draw, y, x 
                    DB       $FF, +$25, -$79              ; draw, y, x 
                    DB       $FF, +$5B, +$5B              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_33: 
                    DB       $01, +$7F, +$7F              ; sync and move to y, x 
                    DB       $00, +$7F, +$65              ; additional sync move to y, x 
                    DB       $00, +$26, +$00              ; additional sync move to y, x 
                    DB       $FF, -$5E, -$5B              ; draw, y, x 
                    DB       $FF, +$7A, -$2B              ; draw, y, x 
                    DB       $FF, -$46, +$0B              ; draw, y, x 
                    DB       $FF, -$46, +$0C              ; draw, y, x 
                    DB       $FF, -$4E, -$3D              ; draw, y, x 
                    DB       $FF, -$4E, -$3C              ; draw, y, x 
                    DB       $FF, +$55, -$1F              ; draw, y, x 
                    DB       $FF, +$56, -$1F              ; draw, y, x 
                    DB       $FF, +$4E, +$19              ; draw, y, x 
                    DB       $FF, +$4F, +$19              ; draw, y, x 
                    DB       $FF, -$7F, -$3B              ; draw, y, x 
                    DB       $FF, +$72, -$37              ; draw, y, x 
                    DB       $FF, -$71, +$23              ; draw, y, x 
                    DB       $FF, +$0F, -$44              ; draw, y, x 
                    DB       $FF, +$10, -$45              ; draw, y, x 
                    DB       $FF, -$20, +$4A              ; draw, y, x 
                    DB       $FF, -$1F, +$49              ; draw, y, x 
                    DB       $FF, -$59, +$22              ; draw, y, x 
                    DB       $FF, -$58, +$22              ; draw, y, x 
                    DB       $01, +$11, -$11              ; sync and move to y, x 
                    DB       $FF, +$0D, -$5A              ; draw, y, x 
                    DB       $FF, +$0E, -$5B              ; draw, y, x 
                    DB       $FF, +$71, -$66              ; draw, y, x 
                    DB       $FF, -$6D, +$45              ; draw, y, x 
                    DB       $FF, +$16, -$74              ; draw, y, x 
                    DB       $FF, -$27, +$5F              ; draw, y, x 
                    DB       $FF, -$55, -$55              ; draw, y, x 
                    DB       $FF, +$28, +$43              ; draw, y, x 
                    DB       $FF, +$27, +$43              ; draw, y, x 
                    DB       $FF, -$0C, +$5C              ; draw, y, x 
                    DB       $FF, -$0C, +$5B              ; draw, y, x 
                    DB       $FF, -$7C, -$69              ; draw, y, x 
                    DB       $FF, -$0D, -$4B              ; draw, y, x 
                    DB       $FF, -$0E, -$4C              ; draw, y, x 
                    DB       $FF, -$01, +$7B              ; draw, y, x 
                    DB       $FF, -$7B, -$54              ; draw, y, x 
                    DB       $01, -$7F, -$7F              ; sync and move to y, x 
                    DB       $00, -$7F, -$6E              ; additional sync move to y, x 
                    DB       $00, -$14, +$00              ; additional sync move to y, x 
                    DB       $FF, +$6C, +$62              ; draw, y, x 
                    DB       $FF, -$7E, +$18              ; draw, y, x 
                    DB       $FF, +$4F, +$03              ; draw, y, x 
                    DB       $FF, +$4E, +$03              ; draw, y, x 
                    DB       $FF, +$7C, +$67              ; draw, y, x 
                    DB       $FF, -$5A, +$22              ; draw, y, x 
                    DB       $FF, -$5B, +$23              ; draw, y, x 
                    DB       $FF, -$79, -$33              ; draw, y, x 
                    DB       $FF, +$66, +$3B              ; draw, y, x 
                    DB       $FF, -$45, +$1F              ; draw, y, x 
                    DB       $FF, -$46, +$20              ; draw, y, x 
                    DB       $FF, +$47, -$10              ; draw, y, x 
                    DB       $FF, +$47, -$10              ; draw, y, x 
                    DB       $FF, -$37, +$7D              ; draw, y, x 
                    DB       $FF, +$28, -$48              ; draw, y, x 
                    DB       $FF, +$28, -$47              ; draw, y, x 
                    DB       $FF, +$5A, -$28              ; draw, y, x 
                    DB       $FF, +$59, -$27              ; draw, y, x 
                    DB       $01, -$04, +$05              ; sync and move to y, x 
                    DB       $FF, -$0E, +$60              ; draw, y, x 
                    DB       $FF, -$0F, +$60              ; draw, y, x 
                    DB       $FF, -$46, +$33              ; draw, y, x 
                    DB       $FF, -$46, +$34              ; draw, y, x 
                    DB       $FF, +$43, -$22              ; draw, y, x 
                    DB       $FF, +$43, -$21              ; draw, y, x 
                    DB       $FF, -$0E, +$7B              ; draw, y, x 
                    DB       $FF, +$1C, -$7A              ; draw, y, x 
                    DB       $FF, +$55, +$5C              ; draw, y, x 
                    DB       $FF, -$4D, -$79              ; draw, y, x 
                    DB       $FF, +$0E, -$61              ; draw, y, x 
                    DB       $FF, +$0E, -$60              ; draw, y, x 
                    DB       $FF, +$4B, +$3F              ; draw, y, x 
                    DB       $FF, +$4B, +$3F              ; draw, y, x 
                    DB       $FF, +$05, +$46              ; draw, y, x 
                    DB       $FF, +$05, +$47              ; draw, y, x 
                    DB       $FF, +$10, -$7D              ; draw, y, x 
                    DB       $FF, +$69, +$4A              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_34: 
                    DB       $01, +$7F, +$7F              ; sync and move to y, x 
                    DB       $00, +$7F, +$30              ; additional sync move to y, x 
                    DB       $00, +$48, +$00              ; additional sync move to y, x 
                    DB       $FF, -$6C, -$4A              ; draw, y, x 
                    DB       $FF, +$71, -$3F              ; draw, y, x 
                    DB       $FF, -$43, +$17              ; draw, y, x 
                    DB       $FF, -$43, +$18              ; draw, y, x 
                    DB       $FF, -$57, -$2F              ; draw, y, x 
                    DB       $FF, -$57, -$2E              ; draw, y, x 
                    DB       $FF, +$4F, -$2D              ; draw, y, x 
                    DB       $FF, +$4F, -$2D              ; draw, y, x 
                    DB       $FF, +$52, +$0B              ; draw, y, x 
                    DB       $FF, +$52, +$0B              ; draw, y, x 
                    DB       $FF, -$44, -$12              ; draw, y, x 
                    DB       $FF, -$44, -$12              ; draw, y, x 
                    DB       $FF, +$67, -$49              ; draw, y, x 
                    DB       $FF, -$69, +$35              ; draw, y, x 
                    DB       $FF, +$03, -$46              ; draw, y, x 
                    DB       $FF, +$04, -$46              ; draw, y, x 
                    DB       $FF, -$13, +$4E              ; draw, y, x 
                    DB       $FF, -$12, +$4E              ; draw, y, x 
                    DB       $FF, -$52, +$30              ; draw, y, x 
                    DB       $FF, -$52, +$30              ; draw, y, x 
                    DB       $01, +$0D, -$14              ; sync and move to y, x 
                    DB       $FF, -$02, -$5B              ; draw, y, x 
                    DB       $FF, -$01, -$5C              ; draw, y, x 
                    DB       $FF, +$5E, -$77              ; draw, y, x 
                    DB       $FF, -$60, +$56              ; draw, y, x 
                    DB       $FF, +$02, -$76              ; draw, y, x 
                    DB       $FF, -$16, +$64              ; draw, y, x 
                    DB       $FF, -$63, -$45              ; draw, y, x 
                    DB       $FF, +$66, +$76              ; draw, y, x 
                    DB       $FF, +$03, +$5D              ; draw, y, x 
                    DB       $FF, +$03, +$5C              ; draw, y, x 
                    DB       $FF, -$45, -$29              ; draw, y, x 
                    DB       $FF, -$46, -$29              ; draw, y, x 
                    DB       $FF, -$1A, -$48              ; draw, y, x 
                    DB       $FF, -$1B, -$48              ; draw, y, x 
                    DB       $FF, +$14, +$79              ; draw, y, x 
                    DB       $FF, -$43, -$1F              ; draw, y, x 
                    DB       $FF, -$44, -$1F              ; draw, y, x 
                    DB       $01, -$7F, -$7F              ; sync and move to y, x 
                    DB       $00, -$7F, -$3C              ; additional sync move to y, x 
                    DB       $00, -$38, +$00              ; additional sync move to y, x 
                    DB       $FF, +$7B, +$4E              ; draw, y, x 
                    DB       $FF, -$79, +$2D              ; draw, y, x 
                    DB       $FF, +$4E, -$0A              ; draw, y, x 
                    DB       $FF, +$4E, -$0B              ; draw, y, x 
                    DB       $FF, +$47, +$29              ; draw, y, x 
                    DB       $FF, +$46, +$28              ; draw, y, x 
                    DB       $FF, -$54, +$31              ; draw, y, x 
                    DB       $FF, -$54, +$32              ; draw, y, x 
                    DB       $FF, -$7F, -$1E              ; draw, y, x 
                    DB       $FF, +$6E, +$29              ; draw, y, x 
                    DB       $FF, -$7E, +$55              ; draw, y, x 
                    DB       $FF, +$43, -$1C              ; draw, y, x 
                    DB       $FF, +$43, -$1B              ; draw, y, x 
                    DB       $FF, -$10, +$42              ; draw, y, x 
                    DB       $FF, -$11, +$42              ; draw, y, x 
                    DB       $FF, +$1C, -$4E              ; draw, y, x 
                    DB       $FF, +$1B, -$4D              ; draw, y, x 
                    DB       $FF, +$52, -$36              ; draw, y, x 
                    DB       $FF, +$51, -$36              ; draw, y, x 
                    DB       $01, -$03, +$05              ; sync and move to y, x 
                    DB       $FF, +$02, +$61              ; draw, y, x 
                    DB       $FF, +$02, +$62              ; draw, y, x 
                    DB       $FF, -$79, +$7D              ; draw, y, x 
                    DB       $FF, +$79, -$59              ; draw, y, x 
                    DB       $FF, +$07, +$7B              ; draw, y, x 
                    DB       $FF, +$07, -$7C              ; draw, y, x 
                    DB       $FF, +$64, +$4C              ; draw, y, x 
                    DB       $FF, -$61, -$6A              ; draw, y, x 
                    DB       $FF, -$03, -$62              ; draw, y, x 
                    DB       $FF, -$02, -$61              ; draw, y, x 
                    DB       $FF, +$54, +$31              ; draw, y, x 
                    DB       $FF, +$55, +$32              ; draw, y, x 
                    DB       $FF, +$10, +$44              ; draw, y, x 
                    DB       $FF, +$11, +$45              ; draw, y, x 
                    DB       $FF, -$05, -$7E              ; draw, y, x 
                    DB       $FF, +$74, +$37              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_35: 
                    DB       $01, +$7F, +$76              ; sync and move to y, x 
                    DB       $00, +$7F, +$00              ; additional sync move to y, x 
                    DB       $00, +$61, +$00              ; additional sync move to y, x 
                    DB       $FF, -$77, -$37              ; draw, y, x 
                    DB       $FF, +$65, -$51              ; draw, y, x 
                    DB       $FF, -$7D, +$44              ; draw, y, x 
                    DB       $FF, -$5E, -$1F              ; draw, y, x 
                    DB       $FF, -$5D, -$1F              ; draw, y, x 
                    DB       $FF, +$46, -$39              ; draw, y, x 
                    DB       $FF, +$47, -$3A              ; draw, y, x 
                    DB       $FF, +$52, -$03              ; draw, y, x 
                    DB       $FF, +$53, -$03              ; draw, y, x 
                    DB       $FF, -$46, -$06              ; draw, y, x 
                    DB       $FF, -$46, -$07              ; draw, y, x 
                    DB       $FF, +$59, -$59              ; draw, y, x 
                    DB       $FF, -$5F, +$46              ; draw, y, x 
                    DB       $FF, -$08, -$45              ; draw, y, x 
                    DB       $FF, -$08, -$46              ; draw, y, x 
                    DB       $FF, -$05, +$50              ; draw, y, x 
                    DB       $FF, -$05, +$4F              ; draw, y, x 
                    DB       $FF, -$49, +$3E              ; draw, y, x 
                    DB       $FF, -$48, +$3D              ; draw, y, x 
                    DB       $01, +$0A, -$16              ; sync and move to y, x 
                    DB       $FF, -$11, -$5A              ; draw, y, x 
                    DB       $FF, -$11, -$5A              ; draw, y, x 
                    DB       $FF, +$24, -$42              ; draw, y, x 
                    DB       $FF, +$24, -$43              ; draw, y, x 
                    DB       $FF, -$50, +$65              ; draw, y, x 
                    DB       $FF, -$12, -$75              ; draw, y, x 
                    DB       $FF, -$04, +$67              ; draw, y, x 
                    DB       $FF, -$6E, -$34              ; draw, y, x 
                    DB       $FF, +$78, +$64              ; draw, y, x 
                    DB       $FF, +$13, +$5B              ; draw, y, x 
                    DB       $FF, +$13, +$5A              ; draw, y, x 
                    DB       $FF, -$4B, -$1D              ; draw, y, x 
                    DB       $FF, -$4C, -$1D              ; draw, y, x 
                    DB       $FF, -$26, -$42              ; draw, y, x 
                    DB       $FF, -$26, -$43              ; draw, y, x 
                    DB       $FF, +$27, +$74              ; draw, y, x 
                    DB       $FF, -$47, -$13              ; draw, y, x 
                    DB       $FF, -$48, -$13              ; draw, y, x 
                    DB       $01, -$7F, -$7F              ; sync and move to y, x 
                    DB       $00, -$7F, -$05              ; additional sync move to y, x 
                    DB       $00, -$53, +$00              ; additional sync move to y, x 
                    DB       $FF, +$44, +$1C              ; draw, y, x 
                    DB       $FF, +$43, +$1C              ; draw, y, x 
                    DB       $FF, -$70, +$41              ; draw, y, x 
                    DB       $FF, +$4B, -$17              ; draw, y, x 
                    DB       $FF, +$4B, -$18              ; draw, y, x 
                    DB       $FF, +$4C, +$1C              ; draw, y, x 
                    DB       $FF, +$4C, +$1C              ; draw, y, x 
                    DB       $FF, -$4A, +$3F              ; draw, y, x 
                    DB       $FF, -$4A, +$3F              ; draw, y, x 
                    DB       $FF, -$41, -$04              ; draw, y, x 
                    DB       $FF, -$42, -$04              ; draw, y, x 
                    DB       $FF, +$73, +$15              ; draw, y, x 
                    DB       $FF, -$6D, +$6A              ; draw, y, x 
                    DB       $FF, +$7B, -$4E              ; draw, y, x 
                    DB       $FF, -$05, +$44              ; draw, y, x 
                    DB       $FF, -$05, +$45              ; draw, y, x 
                    DB       $FF, +$0E, -$51              ; draw, y, x 
                    DB       $FF, +$0D, -$51              ; draw, y, x 
                    DB       $FF, +$48, -$43              ; draw, y, x 
                    DB       $FF, +$47, -$43              ; draw, y, x 
                    DB       $01, -$02, +$06              ; sync and move to y, x 
                    DB       $FF, +$12, +$5F              ; draw, y, x 
                    DB       $FF, +$12, +$60              ; draw, y, x 
                    DB       $FF, -$30, +$47              ; draw, y, x 
                    DB       $FF, -$31, +$48              ; draw, y, x 
                    DB       $FF, +$68, -$6B              ; draw, y, x 
                    DB       $FF, +$1B, +$78              ; draw, y, x 
                    DB       $FF, -$0D, -$7C              ; draw, y, x 
                    DB       $FF, +$6F, +$3B              ; draw, y, x 
                    DB       $FF, -$71, -$59              ; draw, y, x 
                    DB       $FF, -$14, -$60              ; draw, y, x 
                    DB       $FF, -$13, -$60              ; draw, y, x 
                    DB       $FF, +$5C, +$22              ; draw, y, x 
                    DB       $FF, +$5C, +$23              ; draw, y, x 
                    DB       $FF, +$1C, +$41              ; draw, y, x 
                    DB       $FF, +$1C, +$41              ; draw, y, x 
                    DB       $FF, -$1A, -$7B              ; draw, y, x 
                    DB       $FF, +$7B, +$23              ; draw, y, x 
                    DB       $02                          ; endmarker 
SnowFlake1d_36: 
                    DB       $01, +$7F, +$39              ; sync and move to y, x 
                    DB       $00, +$7F, +$00              ; additional sync move to y, x 
                    DB       $00, +$70, +$00              ; additional sync move to y, x 
                    DB       $FF, -$7E, -$22              ; draw, y, x 
                    DB       $FF, +$55, -$61              ; draw, y, x 
                    DB       $FF, -$6F, +$58              ; draw, y, x 
                    DB       $FF, -$62, -$0E              ; draw, y, x 
                    DB       $FF, -$61, -$0F              ; draw, y, x 
                    DB       $FF, +$3B, -$45              ; draw, y, x 
                    DB       $FF, +$3C, -$45              ; draw, y, x 
                    DB       $FF, +$51, -$10              ; draw, y, x 
                    DB       $FF, +$51, -$11              ; draw, y, x 
                    DB       $FF, -$46, +$06              ; draw, y, x 
                    DB       $FF, -$46, +$05              ; draw, y, x 
                    DB       $FF, +$48, -$68              ; draw, y, x 
                    DB       $FF, -$51, +$56              ; draw, y, x 
                    DB       $FF, -$14, -$43              ; draw, y, x 
                    DB       $FF, -$14, -$44              ; draw, y, x 
                    DB       $FF, +$08, +$50              ; draw, y, x 
                    DB       $FF, +$09, +$4F              ; draw, y, x 
                    DB       $FF, -$3D, +$49              ; draw, y, x 
                    DB       $FF, -$3D, +$49              ; draw, y, x 
                    DB       $01, +$06, -$17              ; sync and move to y, x 
                    DB       $FF, -$20, -$56              ; draw, y, x 
                    DB       $FF, -$20, -$56              ; draw, y, x 
                    DB       $FF, +$19, -$47              ; draw, y, x 
                    DB       $FF, +$18, -$48              ; draw, y, x 
                    DB       $FF, -$3E, +$71              ; draw, y, x 
                    DB       $FF, -$26, -$70              ; draw, y, x 
                    DB       $FF, +$0D, +$65              ; draw, y, x 
                    DB       $FF, -$74, -$20              ; draw, y, x 
                    DB       $FF, +$44, +$27              ; draw, y, x 
                    DB       $FF, +$43, +$27              ; draw, y, x 
                    DB       $FF, +$22, +$56              ; draw, y, x 
                    DB       $FF, +$22, +$56              ; draw, y, x 
                    DB       $FF, -$4F, -$0F              ; draw, y, x 
                    DB       $FF, -$50, -$10              ; draw, y, x 
                    DB       $FF, -$62, -$76              ; draw, y, x 
                    DB       $FF, +$3B, +$6B              ; draw, y, x 
                    DB       $FF, -$4A, -$06              ; draw, y, x 
                    DB       $FF, -$4A, -$07              ; draw, y, x 
                    DB       $01, -$7F, -$49              ; sync and move to y, x 
                    DB       $00, -$7F, +$00              ; additional sync move to y, x 
                    DB       $00, -$65, +$00              ; additional sync move to y, x 
                    DB       $FF, +$48, +$11              ; draw, y, x 
                    DB       $FF, +$47, +$10              ; draw, y, x 
                    DB       $FF, -$64, +$52              ; draw, y, x 
                    DB       $FF, +$47, -$24              ; draw, y, x 
                    DB       $FF, +$46, -$23              ; draw, y, x 
                    DB       $FF, +$50, +$0F              ; draw, y, x 
                    DB       $FF, +$4F, +$0E              ; draw, y, x 
                    DB       $FF, -$3E, +$4A              ; draw, y, x 
                    DB       $FF, -$3F, +$4B              ; draw, y, x 
                    DB       $FF, -$41, +$07              ; draw, y, x 
                    DB       $FF, -$41, +$07              ; draw, y, x 
                    DB       $FF, +$75, +$02              ; draw, y, x 
                    DB       $FF, -$5A, +$7B              ; draw, y, x 
                    DB       $FF, +$6C, -$62              ; draw, y, x 
                    DB       $FF, +$07, +$44              ; draw, y, x 
                    DB       $FF, +$06, +$45              ; draw, y, x 
                    DB       $FF, +$00, -$53              ; draw, y, x 
                    DB       $FF, +$00, -$52              ; draw, y, x 
                    DB       $FF, +$3B, -$4E              ; draw, y, x 
                    DB       $FF, +$3B, -$4E              ; draw, y, x 
                    DB       $01, -$01, +$06              ; sync and move to y, x 
                    DB       $FF, +$22, +$5B              ; draw, y, x 
                    DB       $FF, +$22, +$5B              ; draw, y, x 
                    DB       $FF, -$24, +$4F              ; draw, y, x 
                    DB       $FF, -$24, +$4F              ; draw, y, x 
                    DB       $FF, +$55, -$7B              ; draw, y, x 
                    DB       $FF, +$2F, +$71              ; draw, y, x 
                    DB       $FF, -$22, -$77              ; draw, y, x 
                    DB       $FF, +$77, +$26              ; draw, y, x 
                    DB       $FF, -$7E, -$44              ; draw, y, x 
                    DB       $FF, -$24, -$5B              ; draw, y, x 
                    DB       $FF, -$23, -$5B              ; draw, y, x 
                    DB       $FF, +$60, +$12              ; draw, y, x 
                    DB       $FF, +$61, +$13              ; draw, y, x 
                    DB       $FF, +$4D, +$76              ; draw, y, x 
                    DB       $FF, -$2F, -$75              ; draw, y, x 
                    DB       $FF, +$40, +$07              ; draw, y, x 
                    DB       $FF, +$40, +$07              ; draw, y, x 
                    DB       $02                          ; endmarker 

SnowmanSceneData
 DW Snowman_0 ; list of all single vectorlists in this
 DW Snowman_1
 DW Snowman_2
 DW Snowman_3
 DW Snowman_4
 DW Snowman_5
 DW Snowman_6
 DW Snowman_7
 DW Snowman_8
 DW Snowman_9
 DW Snowman_10
 DW Snowman_11
 DW Snowman_12
 DW 0

Snowman_0
	db  $6E, $01,  $6C, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$02, $01,  $2F, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $10, $01,  $22, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $16, $01, -$17
	db  $00, $01, -$3B
	db  $45, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$58, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$42, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$09, $01, -$3A, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db -$22, $01,  $0A
	db  $05, $01,  $30
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Snowman_1
	db  $6D, $01,  $3E, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$60, $01, -$10, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$65, $01, -$0B, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db -$10, $01, -$20
	db -$2F, $01, -$35
	db -$44, $01, -$24
	db -$48, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$4B, $01,  $20, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db -$49, $01,  $54
	db -$2B, $01,  $5F
	db  $00, $01,  $52, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $25, $01,  $45, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $45, $01,  $25, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $45, $01,  $00, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $65, $01, -$20
	db  $54, $01, -$5B
	db  $3A, $01, -$15
	db  $4C, $01, -$0D, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Snowman_2
	db  $40, $01,  $6E, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $3A, $01,  $0B, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $3F, $01,  $10, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db  $06, $01,  $3E
	db  $0A, $01,  $3A
	db  $20, $01,  $40
	db -$06, $01,  $21
	db -$5E, $01,  $50
	db -$46, $01, -$02, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$64, $01, -$3C, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$3A, $01, -$56
	db  $05, $01, -$5E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $39, $01, -$61, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $62, $01, -$3D
	db  $66, $01, -$06
	db  $53, $01,  $24
	db  $2A, $01,  $3B
	db -$73, $01, -$20
	db -$30, $01, -$06
	db  $00, $01,  $77, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Snowman_3
	db  $64, $01,  $69, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$2D, $01, -$04, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$40, $01, -$45, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db  $00, $01, -$59
	db  $40, $01, -$4B
	db  $35, $01,  $00
	db  $30, $01,  $10
	db -$05, $01,  $67, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$2E, $01,  $0E, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Snowman_4
	db  $72, $01,  $79, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$03, $01,  $2D, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $36, $01,  $75, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db -$3B, $01, -$0A
	db -$24, $01, -$7A
	db  $17, $01, -$42, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $35, $01,  $00, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db -$2B, $01,  $45
	db -$0D, $01,  $21
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Snowman_5
	db  $54, $01,  $78, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $15, $01,  $05, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $00, $01,  $2E, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$15, $01,  $10
	db -$10, $01,  $16
	db -$16, $01, -$16
	db -$15, $01, -$10
	db  $00, $01, -$2E
	db  $15, $01, -$05
	db  $16, $01, -$0B, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $10, $01,  $0B
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Snowman_6
	db  $55, $01,  $68, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $2F, $01,  $0A, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $0B, $01, -$10, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db  $0F, $01, -$10
	db -$15, $01, -$0A
	db -$64, $01, -$1A
	db  $00, $01,  $2F
	db  $30, $01,  $0B
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Snowman_7
	db  $28, $01,  $78, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$10, $01, -$0B, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$16, $01,  $0B, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$15, $01,  $05
	db  $00, $01,  $2E
	db  $15, $01,  $10
	db  $16, $01,  $16
	db  $10, $01, -$16
	db  $15, $01, -$10
	db  $00, $01, -$2E, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$15, $01, -$05
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Snowman_8
	db  $5D, $01,  $4A, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$1B, $01,  $02, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$20, $01,  $4D, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $1B, $01,  $30
	db  $1B, $01,  $09
	db  $05, $01, -$43
	db  $00, $01, -$45, hi(SMVB_startMove_single), lo(SMVB_startMove_single)
	db  SHITREG_POKE_VALUE, $01,  $45, hi(SMVB_startDraw_yStays_single), lo(SMVB_startDraw_yStays_single); y was  $00, now SHIFT Poke
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Snowman_9
	db  $6B, $01,  $4C, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$0E, $01, -$1C, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$25, $01,  $00, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $00, $01,  $38
	db  $28, $01,  $05
	db  $0B, $01, -$21, hi(SMVB_startMove_single), lo(SMVB_startMove_single)
	db -$0B, $01,  $21, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Snowman_10
	db  $7B, $01,  $66, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $36, $01,  $00, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $00, $01, -$64, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$36, $01,  $00, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $00, $01,  $65, hi(SMVB_startMove_double), lo(SMVB_startMove_double)
	db  $00, $01, -$64, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Snowman_11
	db  $76, $01,  $67, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$0A, $01, -$6B, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $0A, $01, -$6D, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $00, $01,  $6D, hi(SMVB_startMove_double), lo(SMVB_startMove_double)
	db  $00, $01, -$6C, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Snowman_12
	db  $6A, $01,  $5D, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$0D, $01, -$25, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$27, $01,  $05, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $00, $01,  $36
	db  $20, $01,  $0B
	db  $14, $01, -$21, hi(SMVB_startMove_single), lo(SMVB_startMove_single)
	db -$14, $01,  $21, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
