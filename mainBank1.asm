CURRENT_BANK        EQU      1                            ; 
                    Bank     1 
                    include  "commonGround.i"
; following is needed for VIDE
; to replace "vars" in this bank with values from the other bank
; #genVarlist# varFromBank1
;
;***************************************************************************
; CODE SECTION
;***************************************************************************
sampleInit 
                    LDD      #sampleasm_data_start        ; position of sample 
                    LDX      sampleasm_length             ; length of sample 
                    pshs     y 
                    bSR      init_digit_sound             ; init it! thi ssets up y reg - must be saved! 
                    tfr      y,d 
                    puls     y 
                    std      SAMPLE_POINTER,y 
                    lda      #0 
                    sta      digit_looping 

                                                          ; stopSound 
                    lda      #$0800 
                    jsr      Sound_Byte_raw 
                    lda      #$0900 
                    jsr      Sound_Byte_raw 
                    lda      #$0a00 
                    jsr      Sound_Byte_raw 
                    ldb      #%00111111 
                    lda      #$07 
                    jsr      Sound_Byte_raw 
                    
                    rts      


samplePlay 
                    ldy      SAMPLE_POINTER,y 
samplePlayLoop 
                                                          ; first allways is a wait_recal, as usual 
                    bSR      wait_recal_digitj            ; same as makro: WAIT_RECAL_DIGIT 
                                                          ; set some intensity for our to be displayed vectors 

;
; Note:
; here we can not display vectors with these routines
; since they would do bankswitching away from bank 1
; it certainly is possible to without T1 or Shift
; but right now I can't be bothered to crank out these routines
;

;                    LDA      #$5f                         ; seems about bright enough 
;                    JSR      intensity_a_digitj           ; and set the intensity 
                                                          ; same as makro: INTENSITY_A_DIGIT 
;                    LDA      #$40                 ; scalefactor
;                    STA      VIA_t1_cnt_lo
;                    LDA      #-$68                       ; load y 
;                    LDB      #-$10                        ; load x 
;                    JSR      move_to_d_digitj             ; and move there... 
                                                          ; same as makro: MOVE_TO_D_DIGIT 
;                    LDX      #SmallTree                ; load right vector list 
;                    JSR      draw_vlc_digitj              ; and draw it 

;                    LDA      #$50                         ; load y 
;                    LDB      #-$50                        ; load x 
;                    JSR      move_to_d_digitj             ; and move there... 
;                    ldd      #text 
;                    jsr      Print_Str_digit 
                    lda      digit_is_playing 
                    beq      returnFromSample 
                    BRA      samplePlayLoop               ; and repeat "forever" 


returnFromSample 
                    inc      firstDemoDone 
                    clr      demoFlag                     ; flag this demo as finshed 
                    rts      


                    include  "digitalPlayer.i"
                    include  "sample.asm"
SmallTree: 
                    DB       +$33                         ; number of lines to draw 
                    DB       +$30, -$04                   ; draw to y, x 
                    DB       -$0A, +$32                   ; draw to y, x 
                    DB       +$1C, -$06                   ; draw to y, x 
                    DB       -$18, +$42                   ; draw to y, x 
                    DB       +$0C, +$5C                   ; draw to y, x 
                    DB       +$28, -$42                   ; draw to y, x 
                    DB       +$02, +$30                   ; draw to y, x 
                    DB       +$24, -$3C                   ; draw to y, x 
                    DB       +$08, +$2A                   ; draw to y, x 
                    DB       +$30, -$5E                   ; draw to y, x 
                    DB       +$0C, +$38                   ; draw to y, x 
                    DB       +$06, -$10                   ; draw to y, x 
                    DB       +$10, +$14                   ; draw to y, x 
                    DB       +$18, -$50                   ; draw to y, x 
                    DB       +$0C, +$4A                   ; draw to y, x 
                    DB       +$10, -$42                   ; draw to y, x 
                    DB       +$0E, +$18                   ; draw to y, x 
                    DB       +$14, -$34                   ; draw to y, x 
                    DB       +$0C, +$18                   ; draw to y, x 
                    DB       +$0A, -$1C                   ; draw to y, x 
                    DB       +$06, +$10                   ; draw to y, x 
                    DB       +$4C, -$38                   ; draw to y, x 
                    DB       -$0C, +$20                   ; draw to y, x 
                    DB       +$20, -$06                   ; draw to y, x 
                    DB       +$12, +$20                   ; draw to y, x 
                    DB       +$06, -$30                   ; draw to y, x 
                    DB       +$21, -$10                   ; draw to y, x 
                    DB       -$23, -$12                   ; draw to y, x 
                    DB       -$04, -$28                   ; draw to y, x 
                    DB       -$14, +$1C                   ; draw to y, x 
                    DB       -$1E, -$04                   ; draw to y, x 
                    DB       +$0C, +$20                   ; draw to y, x 
                    DB       -$48, -$3E                   ; draw to y, x 
                    DB       -$04, +$1C                   ; draw to y, x 
                    DB       -$20, -$42                   ; draw to y, x 
                    DB       -$14, +$28                   ; draw to y, x 
                    DB       -$1A, -$4A                   ; draw to y, x 
                    DB       -$10, +$3A                   ; draw to y, x 
                    DB       -$14, -$56                   ; draw to y, x 
                    DB       -$1A, +$48                   ; draw to y, x 
                    DB       -$38, -$60                   ; draw to y, x 
                    DB       -$0C, +$4C                   ; draw to y, x 
                    DB       -$2A, -$48                   ; draw to y, x 
                    DB       -$08, +$0C                   ; draw to y, x 
                    DB       -$06, -$12                   ; draw to y, x 
                    DB       -$1A, +$0C                   ; draw to y, x 
                    DB       +$0C, +$52                   ; draw to y, x 
                    DB       -$1A, -$12                   ; draw to y, x 
                    DB       +$1A, +$46                   ; draw to y, x 
                    DB       -$12, -$06                   ; draw to y, x 
                    DB       +$0E, +$18                   ; draw to y, x 
                    DB       -$3A, -$03                   ; draw to y, x 
