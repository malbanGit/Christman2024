; ------------------------------
; -- VARS
; ------------------------------
                    bss      
                    org      endOfNormalRam 
                    org      sample_ram 

; VARS
                    struct   RocketEmitter 
                    ds       FW_Y_POS, 2 
                    ds       FW_BEHAVIOUR, 2 
                    ds       FW_NEXT_OBJECT, 2 
                    ds       FW_X_POS, 2 
                    ds       FW_Y_VEL, 2 
                    ds       FW_X_VEL, 2 
                    ds       FW_AGE, 1 
                    ds       FW_ZERO_RGAL ,1 
                    end struct 

                    struct   VelocityParticle 
                    ds       FW_Y_POS, 2 
                    ds       FW_BEHAVIOUR, 2 
                    ds       FW_NEXT_OBJECT, 2 
                    ds       FW_X_POS, 2 
                    ds       FW_Y_VEL, 2 
                    ds       FW_X_VEL, 2 
                    ds       FW_AGE, 1 
                    ds       FW_ZERO ,1 

                    end struct 

; RAM
; jump back addresses
; for "last" behaviour routine
PARTICLES_DONE_A    ds       2                            ; 
PARTICLES_DONE      =        PARTICLES_DONE_A-2 
PLIST_COMPARE_ADDRESS: 
;
u_offset1           =        -FW_NEXT_OBJECT              ; behaviour offset is determined by next structure element 
tmp1                ds       1 
buttonStatus        ds       1 
;
PARTICLE1_MAX_COUNT  =       50                           ;50 max when using the expensive YM Player 
;
plist_empty_head    ds       2                            ; if empty these contain a value that points to a RTS, smaller than OBJECT_LIST_COMPARE_ADDRESS 
plist_objects_head  ds       2                            ; if greater OBJECT_LIST_COMPARE_ADDRESS, than this is a pointer to a RAM location of an Object 
pobject_list        ds       VelocityParticle*PARTICLE1_MAX_COUNT 
pobject_list_end    ds       0 
;
;
; 
; ------------------------------
; -- END
; ------------------------------

                    code     

; ------------------------------
; -- Macros
; ------------------------------
_ZERO_VECTOR_BEAM   macro    
                    LDB      #$CC 
                    STB      VIA_cntl                     ;/BLANK low and /ZERO low 
                    endm     
MY_MOVE_TO_D_START  macro    
                    STA      <VIA_port_a                  ;Store Y in D/A register 
                    LDA      #$CE                         ;Blank low, zero high? 
                    STA      <VIA_cntl                    ; 
                    CLRA     
                    STA      <VIA_port_b                  ;Enable mux ; hey dis si "break integratorzero 440" 
;                    STA      <VIA_shift_reg               ;Clear shift regigster 

                    nop                                   ; y must be set more than xx cycles on some vectrex 

                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ;enable timer 
                    endm     
MY_MOVE_TO_A_END    macro    
                    local    LF33D 
                    LDA      #$40                         ; 
LF33D\?:            BITA     <VIA_int_flags               ; 
                    BEQ      LF33D\?                      ; 
                    endm     
MY_MOVE_TO_B_END    macro    
                    local    LF33D 
                    LDB      #$40                         ; 
LF33D\?:            BITB     <VIA_int_flags               ; 
                    BEQ      LF33D\?                      ; 
                    endm     
INIT_OBJECTLIST     macro    count, size, endJump 
                    ldd      #endJump                     ; explosions jump back to here after all have been rendered 
                    std      PARTICLES_DONE_A 
; setup objects

                    lda      #count 
                    ldu      #pobject_list 
                    stu      plist_empty_head 
                    ldy      #PARTICLES_DONE 
next_list_exentry_1\? 
                    leax     size,u 
                    stx      FW_NEXT_OBJECT,u 
                    leau     ,x 
                    deca     
                    bne      next_list_exentry_1\? 
                    leau     -size,u 
                    sty      FW_NEXT_OBJECT,u 
                    sty      plist_objects_head 
                    endm     
; ------------------------------
; -- Macros End
; ------------------------------

; ------------------------------
; -- object handling
; ------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; new list object to U
; destroys d, u 
newObject                                                 ;#isfunction  
                    ldu      plist_empty_head 
                    cmpu     #PLIST_COMPARE_ADDRESS 
                    bls      cs_done_no 
                                                          ; set the new empty head 
                    ldd      FW_NEXT_OBJECT,u             ; the next in out empty list will be the new 
                    std      plist_empty_head             ; head of our empty list 
                                                          ; load last of current object list 
; the old head is always our next
                    ldd      plist_objects_head 
                    std      FW_NEXT_OBJECT,u 
; newobject is always head
                    stu      plist_objects_head 
cs_done_no 
                    rts      


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this macro is placed at the end of each possible "remove" exit
; it stores the just removed object at the head of the "empty" list and 
; sets up its "next" pointer
UPDATE_EMPTY_LIST   macro    
                    ldy      plist_empty_head             ; set u free, as new free head 
                    sty      FW_NEXT_OBJECT,x             ; load to u the next linked list element 
                    stx      plist_empty_head 
                    endm     
;
destroyPObject                                            ;#isfunction  
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in ds+u_offset1 pointer to the object that must be removed
; destroys x, y 
; puls from ds the next object behaviour
; 
; this version is called at the end of an explosion called by "behaviours"
;
                    leax     u_offset1,u                  ; x -> pointer object struture (correction of offset) 
                    cmpx     plist_objects_head           ; is it the first? 
                    bne      was_not_first_enem           ; no -> jump 
was_first_enem 
                    ldu      FW_NEXT_OBJECT,x             ; s pointer to next objext 
                    stu      plist_objects_head           ; the next object will be the first 
                    bra      pRemoveDone 


was_not_first_enem                                        ;        find previous, go thru all objects from first and look where "I" am the next... 
                    ldy      plist_objects_head           ; start at list head 
try_next_enem 
                    cmpx     FW_NEXT_OBJECT,y             ; am I the next object of the current investigated list element 
                    beq      found_next_switch_enem       ; jup -> jump 
                    ldy      FW_NEXT_OBJECT,y             ; otherwise load the next as new current 
                    bra      try_next_enem                ; and search further 


found_next_switch_enem 
                    ldu      FW_NEXT_OBJECT,x             ; we load "our" next object to s 
                    stu      FW_NEXT_OBJECT,y             ; and store our next in the place of our previous next and thus eleminate ourselfs 
pRemoveDone 
                    UPDATE_EMPTY_LIST                     ; and clean up the empties 
; do a clean ending - which is usually done at the end of "SmartDraw"
;                    lda      #$7f 
;                    STa      <VIA_t1_cnt_lo 
                    _ZERO_VECTOR_BEAM  
                    MY_MOVE_TO_A_END  
                    pulu     d,pc                         ; (D = y,x, X = vectorlist) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ------------------------------
; -- object handling - end
; ------------------------------

; ------------------------------
; -- particle handling - start
; ------------------------------
PARTICLES_PER_FIRE  =        20 

; MEGA simple particles and emitters
; one object only has 6 byte
; thus nearly 140 objects can be created!
;
; the demo runs with abour 135 dots
;***************************************************************************
rocketEmitterBehaviour 
                    ldb      FW_X_POS+u_offset1,u 
                    MY_MOVE_TO_D_START  
; change coordinates, 16 bit
; ypos
                    ldd      FW_Y_VEL+u_offset1,u 
                    ldx      FW_Y_POS+u_offset1,u 
                    leax     d,x 
                    leax     d,x 
                    stx      FW_Y_POS+u_offset1,u 
; xpos
                    ldd      FW_X_VEL+u_offset1,u 
                    ldx      FW_X_POS+u_offset1,u 
                    leax     d,x 
                    leax     d,x 
                    stx      FW_X_POS+u_offset1,u 
                    dec      FW_AGE+u_offset1,u 
                    beq      explodeRocket 
                    ldu      FW_NEXT_OBJECT+u_offset1,u   ; preload next user stack 
                    LDB      #10                          ; really BRIGHT 
                    MY_MOVE_TO_A_END  
                    clra     
                    dec      <VIA_shift_reg               ;Store in VIA shift register 
LF2CC_2_rl 
                    DECB                                  ;Delay leaving beam in place 
                    bpl      LF2CC_2_rl 
                    sta      <VIA_shift_reg               ;Blank beam in VIA shift register 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,pc 
; ...............................................
explodeRocket 
                    pshs     u 
                    leax     ,u 
                    lda      #PARTICLES_PER_FIRE 
                    sta      tmp1 
contEmit_er 
                    jsr      newObject 
                    cmpu     #PLIST_COMPARE_ADDRESS 
                    lbls     noNewParticle3_er 
; 16 bit position of velocityParticle
                    clrb     
                    lda      FW_Y_POS+u_offset1,x 
                    std      FW_Y_POS, u 
                    lda      FW_X_POS+u_offset1,x 
                    std      FW_X_POS, u 
                    sta      FW_ZERO,u 
                    clra     
                    RANDOM_B_alt  
                    std      FW_Y_VEL, u 
                    RANDOM_B_alt  
                    andb     #%00111111                   ; slightly different FW_AGE 
                    negb     
                    addb     #150 
                    stb      FW_AGE,U 
                    RANDOM_B_alt  
                    andb     #$ff-$80 
                    sex      
                    std      FW_X_VEL, u 
                    ldd      #velocityPositiveXParticleParticleBehaviour 
                    std      FW_BEHAVIOUR, u 
                    dec      tmp1 
                    lbpl     contEmit_er 
noNewParticle3_er 
                    puls     u 
                    jmp      destroyPObject 


;
;***************************************************************************
;
GRAVITY_Y           =        4 
GRAVITY_X           =        1 
velocityPositiveXParticleParticleBehaviour 

; position to 
                    ldb      FW_X_POS+u_offset1,u 
                    MY_MOVE_TO_D_START  
; Thought:
; the velocity stuuf needs only be done ONCE per 'rocket', not per particle!
;
; update 
; x velocity towards 0
                    ldd      FW_X_VEL+u_offset1,u 
                    bmi      xStays 
                    subd     #GRAVITY_X 
                    std      FW_X_VEL+u_offset1,u 
xStays 
; xpos
                    addd     FW_X_POS+u_offset1,u 
                    lbvs     destroyPObject 
                    std      FW_X_POS+u_offset1,u 
;
; y velocity towards -128
                    ldd      FW_Y_VEL+u_offset1,u 
                    subd     #GRAVITY_Y 
; Hm... no overflow occurs - so don't check... (experimental proof :-) )
                    std      FW_Y_VEL+u_offset1,u 
; change coordinates, 16 bit
; ypos
                    addd     FW_Y_POS+u_offset1,u 
                    lbvs     destroyPObject 
                    std      FW_Y_POS+u_offset1,u 
; aging
                    dec      FW_AGE+u_offset1,u 
                    lbEQ     destroyPObject 
                    lda      FW_AGE+u_offset1,u 
                    lsra     
                    lsra     
                    lsra     
                    ldx      #shiftValues 
                    lda      a,x 
                    pshs     a 
                    ldb      FW_ZERO+u_offset1,u 

                    sta      <VIA_shift_reg               ;Store in VIA shift register 
                    subb     FW_X_POS+u_offset1,u 
                    clra     
                    sta      <VIA_shift_reg               ;Store in VIA shift register 
                    aslb     
                    lda      #150 
                    suba     FW_AGE+u_offset1,u 
 
                    lsra     
                    lsra     
                    lsra     

                    MY_MOVE_TO_D_START  
                    puls     a 
                    MY_MOVE_TO_B_END  

                    ldu      FW_NEXT_OBJECT+u_offset1,u   ; preload next user stack 

                    sta      <VIA_shift_reg               ;Store in VIA shift register 
                    clra     

                    LDB      #$CC 
                    sta      <VIA_shift_reg               ;Store in VIA shift register 
                    STB      VIA_cntl                     ;/BLANK low and /ZERO low 
                    pulu     d,pc 

shiftValues 
                    db       %10000000 
                    db       %10000000 
                    db       %10000000 
                    db       %10000000 
                    db       %11000000 
                    db       %11000000 
                    db       %11100000 
                    db       %11100000 
                    db       %11110000 
                    db       %11110000 
                    db       %11111000 
                    db       %11111000 
                    db       %11111100 
                    db       %11111100 
                    db       %11111110 
                    db       %11111110 
                    db       %11111110 
                    db       %11111110 
                    db       %11111110 
                    db       %11111110 
                    lsrb     
                    lsrb     
                    lsrb     

                    MY_MOVE_TO_A_END  
                    clra     
                    dec      <VIA_shift_reg               ;Store in VIA shift register 
                    nop      3 
LF2CC_vp 
                    DECB                                  ;Delay leaving beam in place 
                    bpl      LF2CC_vp 
                    sta      <VIA_shift_reg               ;Blank beam in VIA shift register 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,pc 

; ------------------------------
; -- particle handling - end
; ------------------------------

MOVE_SCALE          =        $7f 
initParticles 
 ldd #TWENTY_SECONDS ; ten seconds
 std bigCounter
                    INIT_OBJECTLIST  PARTICLE1_MAX_COUNT, VelocityParticle, particleRet 
                    clr      buttonStatus 
particleRet 
                    rts      


playParticles 
 ldd bigCounter
 subd #1
  std bigCounter
 bne notFinishedStoryboardParticles
 clr demoRunningFlag 
notFinishedStoryboardParticles


                    jsr      Intensity_1F 

REPLACE_2_2_HappyNewYearSceneData_varFromBank2_1 
                    ldy      #0 
REPLACE_1_2_drawSmartScene_varFromBank2_3 
                    ldx      #0 
                    jsr      jsrBank3to2 

                    jsr      Intensity_7F 
                    lda      #$60 
                    sta      <VIA_t1_cnt_lo 

                    RANDOM_A_alt  
                    cmpa     #5 
                    lbhi     noRLNewEmitter 
                                                          ; TODO 
                                                          ; randomize start of new missile 

; Launch a rocket on the press of a button
                    jsr      newObject 
                    cmpu     #PLIST_COMPARE_ADDRESS 
                    bls      noRLNewEmitter 
                    ldd      #rocketEmitterBehaviour 
                    std      FW_BEHAVIOUR, u 
                    ldd      #$c000 
                    std      FW_Y_POS, U                  ; current POS 16 bit 
                    ldd      #0 
                    std      FW_X_POS, U                  ; current POS 
                    clra     
                    RANDOM_B_alt  
                    orb      #%01000000 
                    std      FW_Y_VEL, u 
                    RANDOM_B_alt  
                    sex      
                    std      FW_X_VEL, u 
                    RANDOM_B_alt  
                    andb     #%00111111                   ; slightly different age 
                    negb     
                    addb     #100 
                    stb      FW_AGE,U 
noRLNewEmitter 
                    clr      buttonStatus 
                    ldu      plist_objects_head 
                    pulu     d,pc                         ; (D = y,x) ; do all objects 

                    rts      


;************************************************************************************************
;************************** PARTICLE II *********************************************************
;************************************************************************************************
                    bss      
                    org      sample_ram  

                    struct   ParticleBase 
                    ds       P_SCALE, 1 
                    ds       P_ANGLE, 1 
                    ds       BEHAVIOUR_P, 2 
                    ds       NEXT_OBJECT_P, 2 
                    end struct 

p_u_offset1         =        -NEXT_OBJECT_P               ; behaviour offset is determined by next structure element 

P_PARTICLES_DONE_A    ds       2                            ; 
P_PARTICLES_DONE      =        PARTICLES_DONE_A-2 

; jump back addresses
; for "last" behaviour routine
;
P_PLIST_COMPARE_ADDRESS: 
outerCircle         ds       1 
startParticleRAM    ds       0 


;PARTICLE1_MAX_COUNT  =       139                          ; max with below RAM 
P_PARTICLE1_MAX_COUNT  =       90                           ; max with below RAM 
;PARTICLE1_MAX_COUNT  =       70                          ; max with below RAM 
; Structures
                    struct   P_Emitter 
                    ds       PE_EMITTER_DATA, 2 
                    ds       PE_BEHAVIOUR, 2 
                    ds       PE_NEXT_OBJECT, 2 
                    end struct 
                    struct   P_EmitterData 
                    ds       PE_YPOS,1 
                    ds       PE_XPOS,1 
                    ds       PE_ECOUNTER_RESET, 1 
                    ds       PE_EDATA, 1 
                    ds       PE_ECOUNTER, 1 
                    ds       PE_EANGLE_INC, 1 
                    end struct 
                    struct   P_Particle 
                    ds       PP_SCALE, 1 
                    ds       PP_ANGLE, 1 
                    ds       PP_BEHAVIOUR, 2 
                    ds       PP_NEXT_OBJECT, 2 
                    end struct 
;
anglechangeCountDown  ds     1 
angleChangePointer  ds       2 
emitterData1        ds       P_EmitterData 
emitterData2        ds       P_EmitterData 
emitterData3        ds       P_EmitterData 
p_plist_empty_head  ds       2                            ; if empty these contain a value that points to a RTS, smaller than OBJECT_LIST_COMPARE_ADDRESS 
p_plist_objects_head  ds     2                            ; if greater OBJECT_LIST_COMPARE_ADDRESS, than this is a pointer to a RAM location of an Object 
pCount              ds       1 
p_pobject_list      ds       P_Particle*P_PARTICLE1_MAX_COUNT 
p_pobject_list_end  ds       0 
;
; ROM

 code
initParticles2 
 ldd #TWENTY_SECONDS ; ten seconds
 std bigCounter


                    bsr      initParticle1 
                    clr      outerCircle 
                    rts      


playParticles2 
 ldd bigCounter
 subd #1
  std bigCounter
 bne notFinishedStoryboardParticles2
 clr demoRunningFlag 
notFinishedStoryboardParticles2



                    JSR      Intensity_5F                 ; Sets the intensity of the 
; jsr playParticle1

                    lda      outerCircle 
                    adda     #3 
                    sta      outerCircle 
                    bsr      playParticle1                ;playParticleInteractive 
                    rts      


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
P_INIT_OBJECTLIST macro count, size, endJump
 clr pCount
                    ldd      #endJump                     ; explosions jump back to here after all have been rendered 
                    std      P_PARTICLES_DONE_A 
; setup objects

                    lda      #count 
                    ldu      #p_pobject_list 
                    stu      p_plist_empty_head 
                    ldy      #P_PARTICLES_DONE 
next_list_exentry_1\? 
                    leax     size,u 
                    stx      NEXT_OBJECT_P,u 
                    leau     ,x 
                    deca     
                    bne      next_list_exentry_1\?
                    leau     -size,u 
                    sty      NEXT_OBJECT_P,u 
                    sty      p_plist_objects_head 
 endm

initParticle1 
                    P_INIT_OBJECTLIST  P_PARTICLE1_MAX_COUNT, P_Particle, objectsFinished1 
EMITT_ANGLE_ADD     =        4 
EMITT_DELAY         =        1 
;
                    ldx      #emitterData1 
                    ldd      #0                           ; position of emitter 
                    std      PE_YPOS,x 
                    ldd      #EMITT_DELAY*256+0           ; delay 1, start angle 0 
                    std      PE_ECOUNTER_RESET,x 
                    ldd      #0*256+EMITT_ANGLE_ADD       ; start countdown = 0, angle inc = 3 
                    std      PE_ECOUNTER,x 
                    jsr      buildStationaryEmitter 
;
                    ldx      #emitterData2 
                    ldd      #0                           ; position of emitter 
                    std      PE_YPOS,x 
                    ldd      #EMITT_DELAY*256+(255/3)     ; delay 1, start angle 0 
                    std      PE_ECOUNTER_RESET,x 
                    ldd      #1*256+EMITT_ANGLE_ADD       ; start countdown = 0, angle inc = 3 
                    std      PE_ECOUNTER,x 
                    jsr      buildStationaryEmitter 
;
                    ldx      #emitterData3 
                    ldd      #0                           ; position of emitter 
                    std      PE_YPOS,x 
                    ldd      #EMITT_DELAY*256+0+((255/3)*2) ; delay 1, start angle 0 
                    std      PE_ECOUNTER_RESET,x 
                    ldd      #2*256+EMITT_ANGLE_ADD       ; start countdown = 0, angle inc = 3 
                    std      PE_ECOUNTER,x 
                    jsr      buildStationaryEmitter 
                    clr      anglechangeCountDown 
                    ldd      #angleAddData 
                    std      angleChangePointer 
                    rts      


;***************************************************************************
playParticle1 
                    dec      anglechangeCountDown 
                    bpl      noAngleChange 
                    lda      #5 
                    sta      anglechangeCountDown 
                    ldu      angleChangePointer 
                    leau     1,u 
                    cmpu     #angleAddDataEnd 
                    bne      noAngleReset 
                    ldu      #angleAddData 
noAngleReset 
                    stu      angleChangePointer 
                    lda      ,u 
                    sta      emitterData1+PE_EANGLE_INC 
                    sta      emitterData2+PE_EANGLE_INC 
                    sta      emitterData3+PE_EANGLE_INC 
noAngleChange 
; pointer to circle data - is a constant!
                    ldy      #circleData 
                    ldu      p_plist_objects_head 
                    pulu     d,pc                         ; (D = y,x) ; do all objects 
objectsFinished1 
                    rts      


;***************************************************************************
angleAddData 
                    db       1,2,3,4,5,6,7,8,9,10,10,10,10,10,10,10,10,10,10,10,11,12,13,14,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,15,15,15,15 
                    db       4,-4,4,-4,4,-4,4,-4,4,-4,4,-4,4,-4,4,-4,4,-4,4,-4 
                    db       4,4,4,4 
                    db       1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1 
                    db       1,1,1,1 

                    db       6,-6,6,-6,6,-6,6,-6,6,-6,6,-6,6,-6,6,-6,6,-6,6,-6 
                    db       6,6,6,6 
                    db       1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1 
                    db       1,1,1,1 
                    db       3,-3,3,-3,3,-3,3,-3,3,-3,3,-3,3,-3,3,-3,3,-3,3,-3 
                    db       3,3,3,3 

                    db       1,2,3,4,5,6,6,6,6,6,6,6,6,6,6,6,5,4,3,2,1,-1,-2,-3,-4,-5,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-5,-4,-3,-2,-1 
                    db       4,-4,4,-4,4,-4,4,-4,4,-4,4,-4,4,-4,4,-4,4,-4,4,-4 
                    db       4,4,4,4 
                    db       6,-6,6,-6,6,-6,6,-6,6,-6,6,-6,6,-6,6,-6,6,-6,6,-6 
                    db       6,6,6,6 
                    db       4,-4,4,-4,4,-4,4,-4,4,-4,4,-4,4,-4,4,-4,4,-4,4,-4 
                    db       4,4,4,4 

                    db       1,2,3,4,5,6,6,6,6,6,6,6,6,6,6,6,5,4,3,2,1,-1,-2,-3,-4,-5,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-5,-4,-3,-2,-1 
                    db       3,-3,3,-3,3,-3,3,-3,3,-3,3,-3,3,-3,3,-3,3,-3,3,-3 
                    db       3,3,3,3 
                    db       4,-4,4,-4,4,-4,4,-4,4,-4,4,-4,4,-4,4,-4,4,-4,4,-4 
                    db       4,4,4,4 
                    db       1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1 
                    db       1,1,1,1 
                    db       3,-3,3,-3,3,-3,3,-3,3,-3,3,-3,3,-3,3,-3,3,-3,3,-3 
                    db       3,3,3,3 
                    db       6,-6,6,-6,6,-6,6,-6,6,-6,6,-6,6,-6,6,-6,6,-6,6,-6 
                    db       6,6,6,6 

                    db       3,3,3,-3,-3,-3,3,3,3,-3,-3,-3,3,3,3,-3,-3,-3,3,3,3,-3,-3,-3,3,3,3,-3,-3,-3 
                    db       1,2,3,4,4,3,2,1,-1,-2,-3,-4,-4,-3,-2,-1,-1,1, 1,2,3,4,4,3,2,1,-1,-2,-3,-4,-4,-3,-2,-1,-1,1 
                    db       1,2,3,4,5,6,6,6,6,6,6,6,6,6,6,6,5,4,3,2,1,-1,-2,-3,-4,-5,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-5,-4,-3,-2,-1 
                    db       1,2,3,4,5,6,7,8,9,10,10,10,10,10,10,10,10,10,10,10,11,12,13,14,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,15,15,15,15 
angleAddDataEnd 
;***************************************************************************
;...........................................................................
buildStationaryEmitter 
                    jsr      p_newObject 
                    cmpu     #P_PLIST_COMPARE_ADDRESS 
                    bls      noNewEmitter 
                    stx      PE_EMITTER_DATA,u 
                    ldd      #stationaryEmitterBehaviour 
                    std      PE_BEHAVIOUR, u 
noNewEmitter 
                    rts      


;...........................................................................
stationaryEmitterBehaviour 
                    ldx      PE_EMITTER_DATA+p_u_offset1,u 
                    lda      PE_EDATA,x 
                    adda     PE_EANGLE_INC,x 
                    sta      PE_EDATA,x 
                    dec      PE_ECOUNTER,x 
                    bpl      noNewParticle 
                    pshs     u 
                    lda      PE_ECOUNTER_RESET,x 
                    sta      PE_ECOUNTER,x 
                    bsr      p_newObject 
                    cmpu     #P_PLIST_COMPARE_ADDRESS 
                    bls      noNewParticle2 
                    lda      #1                           ; start scale 
                    ldb      PE_EDATA,x                   ; position / angle 
                    std      PP_SCALE,u 
                    ldd      #scaledAngleParticleBehaviour 
                    std      PP_BEHAVIOUR, u 
noNewParticle2 
                    puls     u 
noNewParticle 
                    ldu      PE_NEXT_OBJECT+p_u_offset1,u ; preload next user stack 
                    pulu     d,pc 
;...........................................................................
scaledAngleParticleBehaviour 
; position to 
                    sta      <VIA_t1_cnt_lo 
                    clra     
                    MY_LSL_D  
                    ldd      d,y 
                    MY_MOVE_TO_D_START  
                    lda      PP_SCALE+p_u_offset1,u 
                    adda     #2 
                    cmpa     #$70 
                    bhi      p_destroyPObject 
                    sta      PP_SCALE+p_u_offset1,u 
                    ldu      PP_NEXT_OBJECT+p_u_offset1,u ; preload next user stack 

                    lda      #40 
                    sta      <VIA_t1_cnt_lo 
                    clra     
                    ldb      outerCircle 
                    MY_LSL_D  
                    ldx      d,y 

                    MY_MOVE_TO_A_END  
                    tfr      x,d 
                    MY_MOVE_TO_D_START  
                    LDB      Vec_Dot_Dwell                ;Get dot dwell (brightness) 
                    DECB                                  ;Delay leaving beam in place 
                    MY_MOVE_TO_A_END  

                    dec      <VIA_shift_reg               ;Store in VIA shift register 
LF2CC_1 
                    DECB                                  ;Delay leaving beam in place 
                    BNE      LF2CC_1 
                    stb      <VIA_shift_reg               ;Blank beam in VIA shift register 
                    _ZERO_VECTOR_BEAM  
                    pulu     d,pc 































;************************************************************************************************
;************************** OBJECTS II *********************************************************
;************************************************************************************************



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; new list object to U
; destroys d, u 
p_newObject                                                 ;#isfunction  
                    ldu      p_plist_empty_head 
                    cmpu     #P_PLIST_COMPARE_ADDRESS 
                    bls      p_cs_done_no 
                                                          ; set the new empty head 
                    ldd      NEXT_OBJECT_P,u              ; the next in out empty list will be the new 
                    std      p_plist_empty_head            ; head of our empty list 
                                                          ; load last of current object list 
; the old head is always our next
                    ldd      p_plist_objects_head 
                    std      NEXT_OBJECT_P,u 
; newobject is always head
                    stu      p_plist_objects_head 
                    inc      pCount                      ; and remember that we created a new object 
p_cs_done_no 
                    rts      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this macro is placed at the end of each possible "remove" exit
; it stores the just removed object at the head of the "empty" list and 
; sets up its "next" pointer
P_UPDATE_EMPTY_LIST  macro  
                    dec      pCount 
                    ldy      p_plist_empty_head            ; set u free, as new free head 
                    sty      NEXT_OBJECT_P,x              ; load to u the next linked list element 
                    stx      p_plist_empty_head 
                    endm     
;
p_destroyPObject                                           ;#isfunction  
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in ds+u_offset1 pointer to the object that must be removed
; destroys x, y 
; puls from ds the next object behaviour
; 
; this version is called at the end of an explosion called by "behaviours"
;
                    leax     p_u_offset1,u                  ; x -> pointer object struture (correction of offset) 
                    cmpx     p_plist_objects_head          ; is it the first? 
                    bne      p_was_not_first_enem           ; no -> jump 
p_was_first_enem 
                    ldu      NEXT_OBJECT_P,x              ; s pointer to next objext 
                    stu      p_plist_objects_head          ; the next object will be the first 
                    bra      p_pRemoveDone 

p_was_not_first_enem                                        ;        find previous, go thru all objects from first and look where "I" am the next... 
                    ldy      p_plist_objects_head          ; start at list head 
p_try_next_enem 
                    cmpx     NEXT_OBJECT_P,y              ; am I the next object of the current investigated list element 
                    beq      p_found_next_switch_enem       ; jup -> jump 
                    ldy      NEXT_OBJECT_P,y              ; otherwise load the next as new current 
                    bra      p_try_next_enem                ; and search further 

p_found_next_switch_enem 
                    ldu      NEXT_OBJECT_P,x              ; we load "our" next object to s 
                    stu      NEXT_OBJECT_P,y              ; and store our next in the place of our previous next and thus eleminate ourselfs 
                    P_UPDATE_EMPTY_LIST                ; and clean up the empties 
p_pRemoveDone 
; do a clean ending - which is usually done at the end of "SmartDraw"
                    lda      #$7f 
                    STa      <VIA_t1_cnt_lo 
                    _ZERO_VECTOR_BEAM  
                    MY_MOVE_TO_A_END  
                    pulu     d,pc                         ; (D = y,x, X = vectorlist) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; circle generated 0-360 in 255 steps (cos, -sin), radius: 127
circleData
 db $7F, $00 ; degrees: 0
 db $7E, $FD ; degrees: 1
 db $7E, $FA ; degrees: 2
 db $7E, $F7 ; degrees: 4
 db $7E, $F4 ; degrees: 5
 db $7E, $F1 ; degrees: 7
 db $7D, $EE ; degrees: 8
 db $7D, $EB ; degrees: 9
 db $7C, $E8 ; degrees: 11
 db $7B, $E5 ; degrees: 12
 db $7B, $E2 ; degrees: 14
 db $7A, $DE ; degrees: 15
 db $79, $DB ; degrees: 16
 db $78, $D9 ; degrees: 18
 db $77, $D6 ; degrees: 19
 db $76, $D3 ; degrees: 21
 db $75, $D0 ; degrees: 22
 db $74, $CD ; degrees: 23
 db $72, $CA ; degrees: 25
 db $71, $C7 ; degrees: 26
 db $6F, $C4 ; degrees: 28
 db $6E, $C2 ; degrees: 29
 db $6C, $BF ; degrees: 31
 db $6B, $BC ; degrees: 32
 db $69, $BA ; degrees: 33
 db $67, $B7 ; degrees: 35
 db $65, $B5 ; degrees: 36
 db $63, $B2 ; degrees: 38
 db $61, $B0 ; degrees: 39
 db $5F, $AD ; degrees: 40
 db $5D, $AB ; degrees: 42
 db $5B, $A9 ; degrees: 43
 db $59, $A6 ; degrees: 45
 db $57, $A4 ; degrees: 46
 db $54, $A2 ; degrees: 48
 db $52, $A0 ; degrees: 49
 db $50, $9E ; degrees: 50
 db $4D, $9C ; degrees: 52
 db $4B, $9A ; degrees: 53
 db $48, $98 ; degrees: 55
 db $46, $97 ; degrees: 56
 db $43, $95 ; degrees: 57
 db $40, $93 ; degrees: 59
 db $3E, $92 ; degrees: 60
 db $3B, $90 ; degrees: 62
 db $38, $8F ; degrees: 63
 db $35, $8D ; degrees: 64
 db $32, $8C ; degrees: 66
 db $30, $8B ; degrees: 67
 db $2D, $8A ; degrees: 69
 db $2A, $89 ; degrees: 70
 db $27, $88 ; degrees: 72
 db $24, $87 ; degrees: 73
 db $21, $86 ; degrees: 74
 db $1E, $85 ; degrees: 76
 db $1B, $84 ; degrees: 77
 db $18, $84 ; degrees: 79
 db $15, $83 ; degrees: 80
 db $11, $83 ; degrees: 81
 db $0E, $82 ; degrees: 83
 db $0B, $82 ; degrees: 84
 db $08, $82 ; degrees: 86
 db $05, $82 ; degrees: 87
 db $02, $82 ; degrees: 88
 db $00, $82 ; degrees: 90
 db $FD, $82 ; degrees: 91
 db $F9, $82 ; degrees: 93
 db $F6, $82 ; degrees: 94
 db $F3, $82 ; degrees: 95
 db $F0, $83 ; degrees: 97
 db $ED, $83 ; degrees: 98
 db $EA, $84 ; degrees: 100
 db $E7, $84 ; degrees: 101
 db $E4, $85 ; degrees: 103
 db $E1, $86 ; degrees: 104
 db $DE, $86 ; degrees: 105
 db $DB, $87 ; degrees: 107
 db $D8, $88 ; degrees: 108
 db $D5, $89 ; degrees: 110
 db $D2, $8A ; degrees: 111
 db $CF, $8C ; degrees: 112
 db $CC, $8D ; degrees: 114
 db $C9, $8E ; degrees: 115
 db $C6, $90 ; degrees: 117
 db $C4, $91 ; degrees: 118
 db $C1, $93 ; degrees: 119
 db $BE, $94 ; degrees: 121
 db $BC, $96 ; degrees: 122
 db $B9, $98 ; degrees: 124
 db $B6, $99 ; degrees: 125
 db $B4, $9B ; degrees: 127
 db $B1, $9D ; degrees: 128
 db $AF, $9F ; degrees: 129
 db $AD, $A1 ; degrees: 131
 db $AA, $A3 ; degrees: 132
 db $A8, $A5 ; degrees: 134
 db $A6, $A8 ; degrees: 135
 db $A4, $AA ; degrees: 136
 db $A2, $AC ; degrees: 138
 db $A0, $AE ; degrees: 139
 db $9E, $B1 ; degrees: 141
 db $9C, $B3 ; degrees: 142
 db $9A, $B6 ; degrees: 143
 db $98, $B8 ; degrees: 145
 db $96, $BB ; degrees: 146
 db $95, $BE ; degrees: 148
 db $93, $C0 ; degrees: 149
 db $91, $C3 ; degrees: 151
 db $90, $C6 ; degrees: 152
 db $8E, $C9 ; degrees: 153
 db $8D, $CB ; degrees: 155
 db $8C, $CE ; degrees: 156
 db $8B, $D1 ; degrees: 158
 db $8A, $D4 ; degrees: 159
 db $88, $D7 ; degrees: 160
 db $87, $DA ; degrees: 162
 db $87, $DD ; degrees: 163
 db $86, $E0 ; degrees: 165
 db $85, $E3 ; degrees: 166
 db $84, $E6 ; degrees: 167
 db $84, $E9 ; degrees: 169
 db $83, $EC ; degrees: 170
 db $83, $EF ; degrees: 172
 db $82, $F2 ; degrees: 173
 db $82, $F6 ; degrees: 175
 db $82, $F9 ; degrees: 176
 db $82, $FC ; degrees: 177
 db $82, $FF ; degrees: 179
 db $82, $01 ; degrees: 180
 db $82, $04 ; degrees: 182
 db $82, $07 ; degrees: 183
 db $82, $0A ; degrees: 184
 db $82, $0E ; degrees: 186
 db $83, $11 ; degrees: 187
 db $83, $14 ; degrees: 189
 db $84, $17 ; degrees: 190
 db $84, $1A ; degrees: 191
 db $85, $1D ; degrees: 193
 db $86, $20 ; degrees: 194
 db $87, $23 ; degrees: 196
 db $87, $26 ; degrees: 197
 db $88, $29 ; degrees: 199
 db $8A, $2C ; degrees: 200
 db $8B, $2F ; degrees: 201
 db $8C, $32 ; degrees: 203
 db $8D, $35 ; degrees: 204
 db $8E, $37 ; degrees: 206
 db $90, $3A ; degrees: 207
 db $91, $3D ; degrees: 208
 db $93, $40 ; degrees: 210
 db $95, $42 ; degrees: 211
 db $96, $45 ; degrees: 213
 db $98, $48 ; degrees: 214
 db $9A, $4A ; degrees: 215
 db $9C, $4D ; degrees: 217
 db $9E, $4F ; degrees: 218
 db $A0, $52 ; degrees: 220
 db $A2, $54 ; degrees: 221
 db $A4, $56 ; degrees: 223
 db $A6, $58 ; degrees: 224
 db $A8, $5B ; degrees: 225
 db $AA, $5D ; degrees: 227
 db $AD, $5F ; degrees: 228
 db $AF, $61 ; degrees: 230
 db $B1, $63 ; degrees: 231
 db $B4, $65 ; degrees: 232
 db $B6, $67 ; degrees: 234
 db $B9, $68 ; degrees: 235
 db $BC, $6A ; degrees: 237
 db $BE, $6C ; degrees: 238
 db $C1, $6D ; degrees: 239
 db $C4, $6F ; degrees: 241
 db $C6, $70 ; degrees: 242
 db $C9, $72 ; degrees: 244
 db $CC, $73 ; degrees: 245
 db $CF, $74 ; degrees: 247
 db $D2, $76 ; degrees: 248
 db $D5, $77 ; degrees: 249
 db $D8, $78 ; degrees: 251
 db $DB, $79 ; degrees: 252
 db $DE, $7A ; degrees: 254
 db $E1, $7A ; degrees: 255
 db $E4, $7B ; degrees: 256
 db $E7, $7C ; degrees: 258
 db $EA, $7C ; degrees: 259
 db $ED, $7D ; degrees: 261
 db $F0, $7D ; degrees: 262
 db $F3, $7E ; degrees: 263
 db $F6, $7E ; degrees: 265
 db $F9, $7E ; degrees: 266
 db $FD, $7E ; degrees: 268
 db $00, $7E ; degrees: 269
 db $02, $7E ; degrees: 271
 db $05, $7E ; degrees: 272
 db $08, $7E ; degrees: 273
 db $0B, $7E ; degrees: 275
 db $0E, $7E ; degrees: 276
 db $11, $7D ; degrees: 278
 db $15, $7D ; degrees: 279
 db $18, $7C ; degrees: 280
 db $1B, $7C ; degrees: 282
 db $1E, $7B ; degrees: 283
 db $21, $7A ; degrees: 285
 db $24, $79 ; degrees: 286
 db $27, $78 ; degrees: 287
 db $2A, $77 ; degrees: 289
 db $2D, $76 ; degrees: 290
 db $30, $75 ; degrees: 292
 db $32, $74 ; degrees: 293
 db $35, $73 ; degrees: 295
 db $38, $71 ; degrees: 296
 db $3B, $70 ; degrees: 297
 db $3E, $6E ; degrees: 299
 db $40, $6D ; degrees: 300
 db $43, $6B ; degrees: 302
 db $46, $69 ; degrees: 303
 db $48, $68 ; degrees: 304
 db $4B, $66 ; degrees: 306
 db $4D, $64 ; degrees: 307
 db $50, $62 ; degrees: 309
 db $52, $60 ; degrees: 310
 db $54, $5E ; degrees: 312
 db $57, $5C ; degrees: 313
 db $59, $5A ; degrees: 314
 db $5B, $57 ; degrees: 316
 db $5D, $55 ; degrees: 317
 db $5F, $53 ; degrees: 319
 db $61, $50 ; degrees: 320
 db $63, $4E ; degrees: 321
 db $65, $4B ; degrees: 323
 db $67, $49 ; degrees: 324
 db $69, $46 ; degrees: 326
 db $6B, $44 ; degrees: 327
 db $6C, $41 ; degrees: 328
 db $6E, $3E ; degrees: 330
 db $6F, $3C ; degrees: 331
 db $71, $39 ; degrees: 333
 db $72, $36 ; degrees: 334
 db $74, $33 ; degrees: 336
 db $75, $30 ; degrees: 337
 db $76, $2D ; degrees: 338
 db $77, $2A ; degrees: 340
 db $78, $27 ; degrees: 341
 db $79, $25 ; degrees: 343
 db $7A, $22 ; degrees: 344
 db $7B, $1E ; degrees: 345
 db $7B, $1B ; degrees: 347
 db $7C, $18 ; degrees: 348
 db $7D, $15 ; degrees: 350
 db $7D, $12 ; degrees: 351
 db $7E, $0F ; degrees: 352
 db $7E, $0C ; degrees: 354
 db $7E, $09 ; degrees: 355
 db $7E, $06 ; degrees: 357
 db $7E, $03 ; degrees: 358
 db $7F, $00 ; degrees: 0
