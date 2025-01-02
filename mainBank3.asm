CURRENT_BANK        EQU      3                            ; 
                    Bank     3 
                    include  "commonGround.i"
; following is needed for VIDE
; to replace "vars" in this bank with values from the other bank
; #genVarlist# varFromBank3
;
;***************************************************************************
; CODE SECTION
;***************************************************************************
; NOTE!
; the PrintStr_d in the other banks subroutines
; use BIOS routines, which (inherently) also switch banks!
; (since they use SHIFT and T1 timer of VIA, and thus also change the Interrupt flag)
;
; in this example this is "ok", since the interrupt flags upon
; entering and exiting the BIOS functions are equal
; and so they "return" to the correct banks!
;
init: 
                    jsr      initAll 

;***************************************************************************
;** Main Loop
;***************************************************************************
mainLoop: 
                    JSR      Read_Btns                    ; get button status 
                    JSR      Wait_Recal                   ; Vectrex BIOS recalibration 

                    ldb      $C811                        ; button pressed - any 
                    bitb     #8                           ; is button 4 
                    beq      button1NotPressed 

debounceLoop: 
                    JSR      Read_Btns                    ; get button status 
                    JSR      Wait_Recal                   ; Vectrex BIOS recalibration 
                    ldb      $C811                        ; button pressed - any 
                    bitb     #8                           ; is button 4 
                    beq      debounceDone 
debounceDone 
                    clr      demoRunningFlag 
button1NotPressed 
                    jsr      playDemos 

REPLACE_1_2_doBank0Stuff_varFromBank0_1 
                    ldx      #0 
                    jsr      jsrBank3to0T1 

; check button - and skip to next music

                    BRA      mainLoop                     ; and repeat forever 


                    include  "particleFire.asm"
                    include  "storyboards.asm"
                    include  "rasterData.asm"
                    include  "jumper.asm"
                    include  "font_5.asm"
                    include  "largeFont.asm"
                    include  "extro.asm"
;***************************************************************************
;** Init
;***************************************************************************
initAll 
                    ldd      #0 
                    sta      demoRunningFlag 
                    sta      firstDemoDone 
                    std      demo1Data+POINTER 
                    std      demo2Data+POINTER 
                    std      demo3Data+POINTER 
                    ldd      #Demos-DemoListEntry         ; always add 8 later 
                    std      lastDemoPointer 

                    lda      #2 
                    sta      random_x 
                    lda      #$d4 
                    sta      random_a 
                    lda      <VIA_t2_lo 
                    sta      random_b 
                    lda      <VIA_t1_cnt_lo 
                    sta      random_c 
                    RANDOM_A_alt                          ; call random once 

REPLACE_1_2_initBank0_varFromBank0_1 
                    ldx      #0 
                    jsr      jsrBank3to0T1 
                    rts      


;***************************************************************************
;***************************************************************************

; ............................
; .. Play Demos
; three demos can be played at any given time
; there are pointers to the demo structure kept in
; currentDemo1 ds 2
; currentDemo2 ds 2
; currentDemo3 ds 2
;
; If a pointer is 0, then the demo is "done"
; 
; There is an active demo counter "demoRunningFlag"
; if that reaches zero - then new demos are selected
; but only if it reaches zero!
; 
; each demo can set the "demoFlag" = 0, when playing
; after the demo is called - it will then be discarded
;
; the demos itself are kept in a structure:
;                    struct   Demo 
;                    ds       BANK,2                       ; D current position ; BUG TARGET POS 
;                    ds       INITROUTINE,2                ; D ; BUG TARGET POS 
;                    ds       SUBROUTINE,2                 ; D ; BUG TARGET POS 
;                    ds       CYCLES,2                     ; PC 
;                    end struct 
;
; If all 4 values are 0,0,0,0 - then the list has reached its end - and will start on top again
;
; todo: randomize
; ............................

;***************************************************************************
;** Overall routine + empty demo handling
;***************************************************************************
playDemos 
                    lda      demoRunningFlag 
                    bne      runDemos 
firstDemoIsDone 
; todo init demo
; lll
; for now fixed demos
                    ldx      lastDemoPointer 
                    leax     DemoListEntry,x              ; jump to next demo 
                    ldd      BANK,x 
                    addd     INITROUTINE,x 
                    addd     SUBROUTINE,x 
                    addd     CYCLES,x 
                    bne      demoPointerGot               ; 
                    ldx      #Demos                       ; reset - all demos have been played 
demoPointerGot 
                    inc      demoRunningFlag 
                    stx      lastDemoPointer 
                    ldy      #demo1Data 
                    stx      POINTER, y 
                    bsr      initDemoInX 
; todo
; run more then one demo at a time
; build "random" demos

;***************************************************************************
;** run demos, handling of finished flag
;***************************************************************************
runDemos 
                    ldy      #demo1Data 
                    ldx      POINTER, y 
                    beq      runDemo2 
                    lda      #1 
                    sta      demoFlag 
                    bsr      runOneDemo 
                    lda      demoFlag 
                    bne      runDemo2 
                    dec      demoRunningFlag 
                    ldd      #0 
                    std      demo1Data+POINTER            ; y is not ensured anymore here!, running the demo may destroy it! 

runDemo2 
                    ldy      #demo2Data 
                    ldx      POINTER, y 
                    beq      runDemo3 
                    lda      #1 
                    sta      demoFlag 
                    bsr      runOneDemo 
                    lda      demoFlag 
                    bne      runDemo3 
                    dec      demoRunningFlag 
                    ldd      #0 
                    std      demo2Data+POINTER            ; y is not ensured anymore here!, running the demo may destroy it! 

runDemo3 
                    ldy      #demo3Data 
                    ldx      POINTER, y 
                    beq      demosDone 
                    lda      #1 
                    sta      demoFlag 
                    bsr      runOneDemo 
                    lda      demoFlag 
                    bne      demosDone 
                    dec      demoRunningFlag 
                    ldd      #0 
                    std      demo3Data+POINTER            ; y is not ensured anymore here!, running the demo may destroy it! 
demosDone 
                    rts      


;***************************************************************************
;** chose bank to run
;***************************************************************************
; ............................
; .. Run Demos
; ............................
; on Entry: 
;     Y is always a pointer to the RAM of the demo (1,2,3)
;     X is always a pointer to the ROM list entry of demo lists
runOneDemo 
                    ldd      BANK,x 
                    cmpb     #3 
                    beq      runBank3 
                    cmpb     #2 
                    beq      runBank2 
                    cmpb     #1 
                    beq      runBank1 
                    cmpb     #0 
                    beq      runBank0 
                                                          ; error - but don't bother 
                    rts      


runBank3 
                    jmp      [SUBROUTINE,x] 


runBank2 
                    ldx      SUBROUTINE,x 
                    jmp      jsrBank3to2 


runBank1 
                    ldx      SUBROUTINE,x 
                    jmp      jsrBank3to1T1 


runBank0 
                    ldx      SUBROUTINE,x 
                    jmp      jsrBank3to0T1 


;***************************************************************************
;** initialize a demo, if necessary
;***************************************************************************

; ............................
; .. Init Demos
; on Entry: 
;     Y is always a pointer to the RAM of the demo (1,2,3)
;     X is always a pointer to the ROM list entry of demo lists
; ............................
initDemoInX 
                    ldd      LISTDATA,x 
                    std      DATA,y 
                    ldd      BANK,x 
                    cmpb     #3 
                    beq      initBank3 
                    cmpb     #2 
                    beq      initBank2 
                    cmpb     #1 
                    beq      initBank1 
                    cmpb     #0 
                    beq      initBank0 
ret 
                    rts      


initBank3 
                    ldx      INITROUTINE,x 
                    beq      ret                          ; == 0, then no init routine 
                    jmp      ,x 


initBank2 
                    ldx      INITROUTINE,x 
                    beq      ret 
                    jmp      jsrBank3to2 


initBank1 
                    ldx      INITROUTINE,x 
                    beq      ret 
                    jmp      jsrBank3to1T1 


initBank0 
                    ldx      INITROUTINE,x 
                    beq      ret 
                    jmp      jsrBank3to0T1 


;***************************************************************************
SampleIntro                                               ;        of type DemoList 
REPLACE_2_2_samplePlay_varFromBank1_1 
REPLACE_4_2_sampleInit_varFromBank1_1 
                    dw       1, 0, 0, 30000 

;***************************************************************************
;** The actual demo list
;** bank information supplied by Vide
;***************************************************************************
Demos                                                     ;        of type DemoList 


REPLACE_2_2_IntroPlay_varFromBank3_11                     ;  in largeFont.asm 
REPLACE_4_2_IntroInit_varFromBank3_11 
                    dw       3, 0, 0, 13000 ,0 

REPLACE_2_2_ScenePlay_varFromBank2_11 
REPLACE_4_2_SceneInit_varFromBank2_11 
REPLACE_8_2_Krippe3SceneData_varFromBank2_11 
                    dw       2, 0, 0, 13000 ,0 

REPLACE_2_2_playStoryboardDeerFeed_varFromBank3_1 
REPLACE_4_2_initStoryboardDeerFeed_varFromBank3_1 
                    dw       3, 0, 0, 30000 ,0 

REPLACE_2_2_playRasterCat_varFromBank3_1 
REPLACE_4_2_initRasterCat_varFromBank3_1 
                    dw       3, 0, 0, 30000 ,0 

REPLACE_2_2_ScenePlay_varFromBank2_4 
REPLACE_4_2_SceneInit_varFromBank2_4 
REPLACE_8_2_MariaJosephSceneData_varFromBank2_4 
                    dw       2, 0, 0, 13000 ,0 

REPLACE_2_2_playJumper_varFromBank3_1 
REPLACE_4_2_initJumper_varFromBank3_1 
                    dw       3, 0, 0, 30000 ,0 
REPLACE_2_2_ScenePlay_varFromBank2_7 
REPLACE_4_2_SceneInit_varFromBank2_7 
REPLACE_8_2_KrippeSceneData_varFromBank2_7 
                    dw       2, 0, 0, 13000 ,0 

REPLACE_2_2_playRasterCat_varFromBank3_11 
REPLACE_4_2_initRasterCat_varFromBank3_11 
                    dw       3, 0, 0, 30000 ,0 

REPLACE_2_2_playStoryboardSLED_varFromBank3_1 
REPLACE_4_2_initStoryboardSLED_varFromBank3_1 
                    dw       3, 0, 0, 30000 ,0 

REPLACE_2_2_ScenePlay_varFromBank2_6 
REPLACE_4_2_SceneInit_varFromBank2_6 
REPLACE_8_2_Deer2SceneData_varFromBank2_6 
                    dw       2, 0, 0, 10000 ,0 

REPLACE_2_2_playParticles2_varFromBank3_1 
REPLACE_4_2_initParticles2_varFromBank3_1 
                    dw       3, 0, 0, 30000 ,0 

REPLACE_2_2_playRasterCat_varFromBank3_12 
REPLACE_4_2_initRasterCat_varFromBank3_12 
                    dw       3, 0, 0, 30000 ,0 

REPLACE_2_2_ScenePlay_varFromBank2_2 
REPLACE_4_2_SceneInit_varFromBank2_2 
REPLACE_8_2_MegaStarSceneData_varFromBank2_2 
                    dw       2, 0, 0, 20000 ,0 

REPLACE_2_2_playParticles_varFromBank3_1 
REPLACE_4_2_initParticles_varFromBank3_1 
                    dw       3, 0, 0, 30000 ,0 

REPLACE_2_2_ScenePlay_varFromBank2_10 
REPLACE_4_2_SceneInit_varFromBank2_10 
REPLACE_8_2_WatchingSledSceneData_varFromBank2_10 
                    dw       2, 0, 0, 28000 ,0 

REPLACE_2_2_playCandles_varFromBank2_1 
REPLACE_4_2_initCandles_varFromBank2_1 
                    dw       2, 0, 0, 30000 ,0 

REPLACE_2_2_playRasterCat_varFromBank3_14 
REPLACE_4_2_initRasterCat_varFromBank3_14 
                    dw       3, 0, 0, 30000 ,0 

REPLACE_2_2_ScenePlay_varFromBank2_3 
REPLACE_4_2_SceneInit_varFromBank2_3 
REPLACE_8_2_RendeerSceneData_varFromBank2_3 
                    dw       2, 0, 0, 12000 ,0 

REPLACE_2_2_playFlakes_varFromBank2_1 
REPLACE_4_2_initFlakes_varFromBank2_1 
                    dw       2, 0, 0, 30000 ,0 

REPLACE_2_2_ScenePlay_varFromBank2_9 
REPLACE_4_2_SceneInit_varFromBank2_9 
REPLACE_8_2_ThingsSceneData_varFromBank2_9 
                    dw       2, 0, 0, 25000 ,0 

REPLACE_2_2_playExtro_varFromBank3_1 
REPLACE_4_2_initExtro_varFromBank3_1 
                    dw       3, 0, 0, 30000 ,0 

REPLACE_2_2_ScenePlay_varFromBank2_5 
REPLACE_4_2_SceneInit_varFromBank2_5 
REPLACE_8_2_CherubinSceneData_varFromBank2_5 
                    dw       2, 0, 0, 9000 ,0 

REPLACE_2_2_ScenePlay_varFromBank2_8 
REPLACE_4_2_SceneInit_varFromBank2_8 
REPLACE_8_2_Krippe2SceneData_varFromBank2_8 
                    dw       2, 0, 0, 12000 ,0 

REPLACE_2_2_playRasterCat_varFromBank3_13 
REPLACE_4_2_initRasterCat_varFromBank3_13 
                    dw       3, 0, 0, 30000 ,0 

REPLACE_2_2_samplePlay_varFromBank1_2 
REPLACE_4_2_sampleInit_varFromBank1_2 
                    dw       1, 0, 0, 30000, 0 

                    dw       0, 0, 0, 0, 0                ; 0,0,0,0 = end of list 
