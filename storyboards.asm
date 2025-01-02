
NO_OF_LANES_SLED = (3 +1) ; plus one for ZERO

BEHAVIOUR_NONE equ 0
BEHAVIOUR_PAUSE equ 4
BEHAVIOUR_ANIMATION_LOOP equ 8

ELEMENT_ANIM EQU 0
ELEMENT_PAUSE EQU 1
ELEMENT_LIST EQU 2
ELEMENT_YM EQU 3
ELEMENT_GOTO EQU 4

 bss
 org sample_ram

; V2
 struct laneData
  ds LANE_CURRENT_ELEMENT,1
  ds LANE_DELAY_COUNT,1
  ds LANE_ANIM_COUNT,1
  ds LANE_ANIM_LOOP,1
  ds LANE_CURRENT_MOVE_SCALE, 1
  ds LANE_CURRENT_DRAW_SCALE, 1
  ds LANE_SCALE_TO,1
  ds LANE_SCALE_DELAY,1
  ds LANE_SCALE_INCREASE,1
  ds LANE_CURRENT_INTENSITY, 1
  ds LANE_INTENSITY_DELAY,1
  ds LANE_INTENSITY_TO,1
  ds LANE_INTENSITY_INCREASE,1
  ds LANE_CURRENT_POSITION, 0
  ds LANE_CURRENT_POSITION_Y, 1
  ds LANE_CURRENT_POSITION_X, 1
  ds LANE_POS_TO, 0
  ds LANE_POS_Y_TO,1
  ds LANE_POS_X_TO,1
  ds LANE_POS_DELAY, 0
  ds LANE_POS_DELAY_Y,1
  ds LANE_POS_DELAY_X,1
  ds LANE_POS_INCREASE, 0
  ds LANE_POS_INCREASE_Y,1
  ds LANE_POS_INCREASE_X,1
  ds LANE_ELEMENT_COUNT,2
  ds LANE_DRAW,2
  ds LANE_ROM_DATA,2
 end struct 


 struct elementData
 ds ELEMENT_ANIM_LIST,2
 ds ELEMENT_ANIM_DELAY,1
 ds ELEMENT_SCALE_FROM,1
 ds ELEMENT_SCALE_TO,1
 ds ELEMENT_SCALE_DELAY,1
 ds ELEMENT_SCALE_INCREASE,1
 ds ELEMENT_INTENSITY_FROM,1
 ds ELEMENT_INTENSITY_TO,1
 ds ELEMENT_INTENSITY_DELAY,1
 ds ELEMENT_INTENSITY_INCREASE,1
 ds ELEMENT_POS_FROM,0
 ds ELEMENT_POS_FROM_Y,1
 ds ELEMENT_POS_FROM_X,1
 ds ELEMENT_POS_TO,0
 ds ELEMENT_POS_TO_Y,1
 ds ELEMENT_POS_TO_X,1
 ds ELEMENT_POS_DELAY,0
 ds ELEMENT_POS_DELAY_Y,1
 ds ELEMENT_POS_DELAY_X,1
 ds ELEMENT_POS_INCREASE,0
 ds ELEMENT_POS_INCREASE_Y,1
 ds ELEMENT_POS_INCREASE_X,1
 ds ELEMENT_MOVE_SCALE,1
 ds ELEMENT_DRAW,2
 ds ELEMENT_BEHAVIOUR,1
 ds ELEMENT_END_COUNT,2
 ds ELEMENT_TYPE, 1
 end struct

laneRAM_SLED ds laneData*NO_OF_LANES_SLED
roundCounter_SLED ds 2
 code

initStoryboardSLED
 ldd #TEN_SECONDS-100 ; ten seconds
 std bigCounter


 ldu #(laneRAM_SLED-laneData)

 leau laneData,u 
 ldx #lane37Data_SLED 
 bsr initLane

 leau laneData,u 
 ldx #lane38Data_SLED 
 bsr initLane

 leau laneData,u 
 ldx #lane39Data_SLED 
 bsr initLane


 ldd #0
 std roundCounter_SLED
 leau laneData,u
 std ,u
 rts


playStoryboardSLED
 ldd bigCounter
 subd #1
  std bigCounter
 bne notFinishedStoryboardSLED
 clr demoRunningFlag 
notFinishedStoryboardSLED


 ldy #laneRAM_SLED
doNextLane_SLED
 ldd ,y
 beq lanesDone_SLED
 jsr doLane
 leay laneData,y
 bra doNextLane_SLED
lanesDone_SLED:

; increase round counter!
 ldx roundCounter_SLED
 leax 1,x
 stx roundCounter_SLED
 rts


; V2
;***************************************************************************
; in U pointer to lane RAM
; in X pointer to lane Data
initLane:
 stx LANE_ROM_DATA, u
 ldx ,x ; first element
  clr LANE_CURRENT_ELEMENT,u
 

init_element:
 lda ELEMENT_BEHAVIOUR,x
 anda #BEHAVIOUR_ANIMATION_LOOP
 sta LANE_ANIM_LOOP,u

 lda ELEMENT_MOVE_SCALE,x ;  
 sta LANE_CURRENT_MOVE_SCALE,u

 lda ELEMENT_ANIM_DELAY ,x 
 sta LANE_DELAY_COUNT, u
 clr LANE_ANIM_COUNT, u

; SCALE
 lda ELEMENT_SCALE_FROM,x ;  
 sta LANE_CURRENT_DRAW_SCALE,u
 lda ELEMENT_SCALE_DELAY,x 
 sta LANE_SCALE_DELAY,u
 lda ELEMENT_SCALE_INCREASE,x
 sta LANE_SCALE_INCREASE,u
 lda ELEMENT_SCALE_TO,x ;  
 sta LANE_SCALE_TO,u


; INTENSITY
 lda ELEMENT_INTENSITY_FROM,x ;  
 sta LANE_CURRENT_INTENSITY,u
 lda ELEMENT_INTENSITY_DELAY,x 
 sta LANE_INTENSITY_DELAY,u
 lda ELEMENT_INTENSITY_INCREASE,x
 sta LANE_INTENSITY_INCREASE,u
 lda ELEMENT_INTENSITY_TO,x ;  
 sta LANE_INTENSITY_TO,u

; POS
 ldd ELEMENT_POS_FROM,x ;  
 std LANE_CURRENT_POSITION,u
 ldd ELEMENT_POS_DELAY,x 
 std LANE_POS_DELAY,u
 ldd ELEMENT_POS_INCREASE,x
 std LANE_POS_INCREASE,u
 ldd ELEMENT_POS_TO,x ;  
 std LANE_POS_TO,u

 ldd ELEMENT_DRAW,x
 std LANE_DRAW,u
 
 ldd ELEMENT_END_COUNT, x
 std LANE_ELEMENT_COUNT, u
draw_pause: ; some direct RTS
 rts

; pointer to lane RAM in Y
initNextElement

 ldx LANE_ROM_DATA,y
 lda LANE_CURRENT_ELEMENT, y
 asla
 ldx a,x

not_gotoElement:
 tfr y,u
 inc LANE_CURRENT_ELEMENT,y
 lda LANE_CURRENT_ELEMENT,y

 ldx LANE_ROM_DATA,y
 asla
 ldx a,x
 bne not_last_element
 lda #$ff
 sta LANE_CURRENT_ELEMENT,y
 bra not_gotoElement
not_last_element
 bsr init_element
;***************************************************************************

; pointer to lane RAM in Y
doLane
 ldx LANE_ELEMENT_COUNT,y
 leax -1,x
 stx LANE_ELEMENT_COUNT,y ; dec element counter

 beq initNextElement
continueWithElement

 ldx LANE_ROM_DATA,y
 lda LANE_CURRENT_ELEMENT, y
 asla
 ldx a,x

; in x pointer to ROM element data struct
 dec LANE_DELAY_COUNT,y
 bne drawCurrentAnimationFrame
 lda ELEMENT_ANIM_DELAY ,x 
 sta LANE_DELAY_COUNT, y
 inc LANE_ANIM_COUNT, y

 CLRA
    LDB      LANE_ANIM_COUNT,y     ; current animation frame
    ASLB                          ; times two since it is a word pointer
 ROLA
    LDU      ,x               ; address of data 
    LDU      d,U
 bne drawCurrentAnimationFrame
; otherwise this animation is done
; check for loop - or init next lane element!
 tst LANE_ANIM_LOOP,y
 bne loopAnim
 
 ; stay at current frame
 dec LANE_ANIM_COUNT, y


 bra drawCurrentAnimationFrame
loopAnim:
 clr LANE_ANIM_COUNT, y ; for now reset animation
; todo check for "stay"continueWithElement

drawCurrentAnimationFrame:
 lda LANE_SCALE_INCREASE,y
 beq noScaleChange
 dec LANE_SCALE_DELAY,y
 bne noScaleChange
 adda LANE_CURRENT_DRAW_SCALE,y
 sta LANE_CURRENT_DRAW_SCALE,y
 suba LANE_SCALE_TO,y
 bne scale_final_not_reached 
 clr LANE_SCALE_INCREASE,y ; zero means no change
 bra noScaleChange
scale_final_not_reached
 lda ELEMENT_SCALE_DELAY,x
 sta LANE_SCALE_DELAY,y
noScaleChange

 lda LANE_INTENSITY_INCREASE,y
 beq noIntensityChange
 dec LANE_INTENSITY_DELAY,y
 bne noIntensityChange
 adda LANE_CURRENT_INTENSITY,y
 sta LANE_CURRENT_INTENSITY,y
 suba LANE_INTENSITY_TO,y
 bne intensity_final_not_reached
 clr LANE_INTENSITY_INCREASE,y ; zero means no change
 bra noIntensityChange
intensity_final_not_reached 
 lda ELEMENT_INTENSITY_DELAY,x
 sta LANE_INTENSITY_DELAY,y
noIntensityChange

 lda LANE_POS_INCREASE_X,y
 beq noXChange
 dec LANE_POS_DELAY_X,y
 bne noXChange
 adda LANE_CURRENT_POSITION_X,y
 sta LANE_CURRENT_POSITION_X,y
 suba LANE_POS_X_TO,y
 bne X_final_not_reached
 clr LANE_POS_INCREASE_X,y ; zero means no change
 bra noXChange
X_final_not_reached
 lda  ELEMENT_POS_DELAY_X,x
 sta LANE_POS_DELAY_X,y
noXChange

 lda LANE_POS_INCREASE_Y,y
 beq noYChange
 dec LANE_POS_DELAY_Y,y
 bne noYChange
 adda LANE_CURRENT_POSITION_Y,y
 sta LANE_CURRENT_POSITION_Y,y
 suba LANE_POS_Y_TO,y
 bne Y_final_not_reached
 clr LANE_POS_INCREASE_Y,y ; zero means no change
 bra noYChange
Y_final_not_reached
 lda ELEMENT_POS_DELAY_Y,x
 sta LANE_POS_DELAY_Y,y
noYChange

 lda LANE_CURRENT_INTENSITY,y
 bmi noIntensity
 _INTENSITY_A
noIntensity
; todo set intensity - when another vlist that extended sync is done

 CLRA
    LDB      LANE_ANIM_COUNT,y     ; current animation frame
    ASLB                          ; times two since it is a word pointer
 ROLA
    LDU      ,x               ; address of data 
    LDU      d,U

    LDd      LANE_CURRENT_POSITION,y     ; current animation frame
    tfr      d,x                          ; in x position of list 

; A scale positioning 
; N scale move in list 
 ldd LANE_CURRENT_MOVE_SCALE, y
    JSR      [LANE_DRAW, y]      ; Vectrex BIOS print routine 

 rts
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
ZERO_DELAY_AS          EQU      7                            ; delay 7 counter is exactly 111 cycles delay between zero SETTING and zero unsetting (in moveto_d) 
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
                    bne      drawdone_as                     ; if end of list -> jump 
; zero integrators
                    ldb      #$CC                         ; zero the integrators 
                    stb      <VIA_cntl                    ; store zeroing values to cntl 
                    ldb      #ZERO_DELAY_AS                  ; and wait for zeroing to be actually done 
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
                    MY_MOVE_TO_D;jsr      Moveto_d                     ; move there 
                    lda      ,s                           ; scale factor vector 
                    sta      <VIA_t1_cnt_lo               ; to timer T1 (lo) 
moveTo_as: 
                    ldd      ,u++                         ; do our "internal" moveto d 
                    beq      nextListEntry_as                ; there was a move 0,0, if so 
                    MY_MOVE_TO_D;jsr      Moveto_d 
nextListEntry_as: 
                    lda      ,u+                          ; load next "mode" byte 
                    beq      moveTo_as                       ; if 0, than we should move somewhere 
                    bpl      sync_as                         ; if still positive it is a 1 pr 2 _> goto sync 
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
                    beq      setPatternLoop_as               ; wait till line is finished 
                    CLR      <VIA_shift_reg               ; switch the light off (for sure) 
                    bra      nextListEntry_as 

drawdone_as: 
                    puls     d                            ; correct stack and go back 
                    rts      
;***************************************************************************
;SUB_END
;SUB_END

lane37Data_SLED: 
 dw element_371_SLED
 dw 0

element_371_SLED:
 dw AnimList_65_SLED
 db 3; delay
 db 40; scale from
 db 40; scale to
 db 0; scale delay
 db 0; scale increase
 db 50; intensityFrom
 db 50; intensityTo
 db 0; intensityDelay
 db 0; intensityIncrease
 db -60, 120; position from (y,x)
 db -20, -120; position to (y,x)
 db 11, 2; position delay (y,x)
 db 1, -1; position increase (y,x)
 db 80; move scale
 dw draw_synced_list; draw jsr
 db BEHAVIOUR_NONE+BEHAVIOUR_ANIMATION_LOOP ; BEHAVIOUR_PAUSE / BEHAVIOUR_ANIMATION_LOOP
 dw 400; element end count
 db ELEMENT_ANIM ; type of element 

lane38Data_SLED: 
 dw element_381_SLED
 dw 0

element_381_SLED:
 dw AnimList_66_SLED
 db 3; delay
 db 20; scale from
 db 20; scale to
 db 0; scale delay
 db 0; scale increase
 db 127; intensityFrom
 db 127; intensityTo
 db 0; intensityDelay
 db 0; intensityIncrease
 db 120, 40; position from (y,x)
 db 120, 40; position to (y,x)
 db 0, 0; position delay (y,x)
 db 0, 0; position increase (y,x)
 db 80; move scale
 dw draw_synced_list; draw jsr
 db BEHAVIOUR_NONE+BEHAVIOUR_ANIMATION_LOOP ; BEHAVIOUR_PAUSE / BEHAVIOUR_ANIMATION_LOOP
 dw 200; element end count
 db ELEMENT_ANIM ; type of element 

lane39Data_SLED: 
 dw element_391_SLED
 dw 0

element_391_SLED:
 dw AnimList_67_SLED
 db 3; delay
 db 10; scale from
 db 10; scale to
 db 0; scale delay
 db 0; scale increase
 db 40; intensityFrom
 db 40; intensityTo
 db 0; intensityDelay
 db 0; intensityIncrease
 db -120, 120; position from (y,x)
 db -120, 120; position to (y,x)
 db 0, 0; position delay (y,x)
 db 0, 0; position increase (y,x)
 db 80; move scale
 dw draw_synced_list; draw jsr
 db BEHAVIOUR_NONE+BEHAVIOUR_ANIMATION_LOOP ; BEHAVIOUR_PAUSE / BEHAVIOUR_ANIMATION_LOOP
 dw 200; element end count
 db ELEMENT_ANIM ; type of element 
BLOW_UP_66_SLED EQU 1

AnimList_65_SLED:
 DW AnimList_65_SLED_0 ; list of all single vectorlists in this
 DW 0

AnimList_65_SLED_0:
 DB $01, +$29*BLOW_UP_66_SLED, +$22*BLOW_UP_66_SLED ; sync and move to y, x
 DB $FF, +$03*BLOW_UP_66_SLED, +$13*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$01*BLOW_UP_66_SLED, +$1F*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$02*BLOW_UP_66_SLED, +$0A*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$09*BLOW_UP_66_SLED, -$01*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$00*BLOW_UP_66_SLED, -$0E*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$04*BLOW_UP_66_SLED, -$04*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$06*BLOW_UP_66_SLED, +$00*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$10*BLOW_UP_66_SLED, +$13*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$11*BLOW_UP_66_SLED, +$01*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$0F*BLOW_UP_66_SLED, -$0D*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$04*BLOW_UP_66_SLED, -$0E*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$05*BLOW_UP_66_SLED, -$01*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$05*BLOW_UP_66_SLED, +$1C*BLOW_UP_66_SLED ; draw, y, x
 DB $01, -$1F*BLOW_UP_66_SLED, +$5C*BLOW_UP_66_SLED ; sync and move to y, x
 DB $00, +$00*BLOW_UP_66_SLED, +$03*BLOW_UP_66_SLED ; additional sync move to y, x
 DB $FF, -$04*BLOW_UP_66_SLED, +$03*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$04*BLOW_UP_66_SLED, -$1E*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$03*BLOW_UP_66_SLED, -$06*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$00*BLOW_UP_66_SLED, -$5C*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$02*BLOW_UP_66_SLED, -$01*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$04*BLOW_UP_66_SLED, -$38*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$0A*BLOW_UP_66_SLED, -$0A*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$10*BLOW_UP_66_SLED, +$00*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$08*BLOW_UP_66_SLED, +$09*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$00*BLOW_UP_66_SLED, +$0F*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$09*BLOW_UP_66_SLED, +$09*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$08*BLOW_UP_66_SLED, +$00*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$09*BLOW_UP_66_SLED, -$09*BLOW_UP_66_SLED ; draw, y, x
 DB $01, -$1D*BLOW_UP_66_SLED, -$4A*BLOW_UP_66_SLED ; sync and move to y, x
 DB $FF, +$00*BLOW_UP_66_SLED, -$06*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$06*BLOW_UP_66_SLED, -$08*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$06*BLOW_UP_66_SLED, +$00*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$04*BLOW_UP_66_SLED, +$06*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$02*BLOW_UP_66_SLED, +$04*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$02*BLOW_UP_66_SLED, +$06*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$07*BLOW_UP_66_SLED, +$01*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$07*BLOW_UP_66_SLED, -$05*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$00*BLOW_UP_66_SLED, -$08*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$08*BLOW_UP_66_SLED, -$09*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$09*BLOW_UP_66_SLED, +$00*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$09*BLOW_UP_66_SLED, +$0A*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$03*BLOW_UP_66_SLED, +$38*BLOW_UP_66_SLED ; draw, y, x
 DB $01, -$24*BLOW_UP_66_SLED, -$1B*BLOW_UP_66_SLED ; sync and move to y, x
 DB $FF, +$04*BLOW_UP_66_SLED, +$02*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$04*BLOW_UP_66_SLED, -$13*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$09*BLOW_UP_66_SLED, -$09*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$11*BLOW_UP_66_SLED, -$04*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$11*BLOW_UP_66_SLED, +$06*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$0C*BLOW_UP_66_SLED, -$01*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$08*BLOW_UP_66_SLED, +$0B*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$10*BLOW_UP_66_SLED, +$07*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$06*BLOW_UP_66_SLED, +$08*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, -$01*BLOW_UP_66_SLED, +$14*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$05*BLOW_UP_66_SLED, +$0C*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$13*BLOW_UP_66_SLED, +$04*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$0D*BLOW_UP_66_SLED, +$0B*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$09*BLOW_UP_66_SLED, +$0D*BLOW_UP_66_SLED ; draw, y, x
 DB $01, -$20*BLOW_UP_66_SLED, +$3C*BLOW_UP_66_SLED ; sync and move to y, x
 DB $FF, -$05*BLOW_UP_66_SLED, +$01*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$00*BLOW_UP_66_SLED, -$51*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$05*BLOW_UP_66_SLED, +$03*BLOW_UP_66_SLED ; draw, y, x
 DB $FF, +$00*BLOW_UP_66_SLED, -$4D*BLOW_UP_66_SLED ; draw, y, x
 DB $02 ; endmarker 
BLOW_UP_67_SLED EQU 1

AnimList_66_SLED:
 DW AnimList_66_SLED_0 ; list of all single vectorlists in this
 DW 0

AnimList_66_SLED_0:
 DB $01, +$38*BLOW_UP_67_SLED, -$7F*BLOW_UP_67_SLED ; sync and move to y, x
 DB $00, +$00*BLOW_UP_67_SLED, -$59*BLOW_UP_67_SLED ; additional sync move to y, x
 DB $FF, -$4B*BLOW_UP_67_SLED, +$04*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$15*BLOW_UP_67_SLED, +$1F*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$1C*BLOW_UP_67_SLED, -$18*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$0C*BLOW_UP_67_SLED, +$46*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$00*BLOW_UP_67_SLED, -$48*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$21*BLOW_UP_67_SLED, +$20*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$1A*BLOW_UP_67_SLED, -$26*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$50*BLOW_UP_67_SLED, -$03*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$06*BLOW_UP_67_SLED, -$02*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$4A*BLOW_UP_67_SLED, -$06*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$22*BLOW_UP_67_SLED, -$24*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$29*BLOW_UP_67_SLED, +$1F*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$08*BLOW_UP_67_SLED, -$4F*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$02*BLOW_UP_67_SLED, +$4F*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$1D*BLOW_UP_67_SLED, -$19*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$15*BLOW_UP_67_SLED, +$1F*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$4B*BLOW_UP_67_SLED, +$06*BLOW_UP_67_SLED ; draw, y, x
 DB $01, +$7F*BLOW_UP_67_SLED, -$7F*BLOW_UP_67_SLED ; sync and move to y, x
 DB $00, +$7F*BLOW_UP_67_SLED, -$7F*BLOW_UP_67_SLED ; additional sync move to y, x
 DB $00, +$00*BLOW_UP_67_SLED, -$2A*BLOW_UP_67_SLED ; additional sync move to y, x
 DB $FF, -$5A*BLOW_UP_67_SLED, +$04*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$24*BLOW_UP_67_SLED, +$26*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$26*BLOW_UP_67_SLED, -$22*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$00*BLOW_UP_67_SLED, +$58*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$07*BLOW_UP_67_SLED, -$57*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$22*BLOW_UP_67_SLED, +$1B*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$1A*BLOW_UP_67_SLED, -$1E*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$5A*BLOW_UP_67_SLED, -$06*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$5A*BLOW_UP_67_SLED, -$04*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$24*BLOW_UP_67_SLED, -$24*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$26*BLOW_UP_67_SLED, +$20*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$04*BLOW_UP_67_SLED, -$5C*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$05*BLOW_UP_67_SLED, +$59*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$22*BLOW_UP_67_SLED, -$1D*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$1C*BLOW_UP_67_SLED, +$24*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$5A*BLOW_UP_67_SLED, +$04*BLOW_UP_67_SLED ; draw, y, x
 DB $01, +$7F*BLOW_UP_67_SLED, -$6C*BLOW_UP_67_SLED ; sync and move to y, x
 DB $00, +$7F*BLOW_UP_67_SLED, +$00*BLOW_UP_67_SLED ; additional sync move to y, x
 DB $00, +$04*BLOW_UP_67_SLED, +$00*BLOW_UP_67_SLED ; additional sync move to y, x
 DB $FF, +$18*BLOW_UP_67_SLED, +$24*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$21*BLOW_UP_67_SLED, -$1E*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$05*BLOW_UP_67_SLED, +$54*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$0A*BLOW_UP_67_SLED, -$50*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$1C*BLOW_UP_67_SLED, +$1A*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$17*BLOW_UP_67_SLED, -$25*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$53*BLOW_UP_67_SLED, +$01*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$06*BLOW_UP_67_SLED, -$02*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$4C*BLOW_UP_67_SLED, -$0A*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$1C*BLOW_UP_67_SLED, -$20*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$23*BLOW_UP_67_SLED, +$1C*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$0B*BLOW_UP_67_SLED, -$52*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$05*BLOW_UP_67_SLED, +$54*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$23*BLOW_UP_67_SLED, -$1E*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$1C*BLOW_UP_67_SLED, +$24*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$4E*BLOW_UP_67_SLED, +$06*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$4E*BLOW_UP_67_SLED, +$02*BLOW_UP_67_SLED ; draw, y, x
 DB $01, +$7F*BLOW_UP_67_SLED, -$12*BLOW_UP_67_SLED ; sync and move to y, x
 DB $00, +$35*BLOW_UP_67_SLED, +$00*BLOW_UP_67_SLED ; additional sync move to y, x
 DB $FF, -$3E*BLOW_UP_67_SLED, +$28*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$04*BLOW_UP_67_SLED, +$51*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$3B*BLOW_UP_67_SLED, -$31*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$12*BLOW_UP_67_SLED, +$49*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$12*BLOW_UP_67_SLED, +$49*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$5D*BLOW_UP_67_SLED, +$6C*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$5B*BLOW_UP_67_SLED, +$40*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$3F*BLOW_UP_67_SLED, +$12*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$26*BLOW_UP_67_SLED, -$26*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$0A*BLOW_UP_67_SLED, -$26*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$1C*BLOW_UP_67_SLED, +$14*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$34*BLOW_UP_67_SLED, +$02*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$52*BLOW_UP_67_SLED, -$0A*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$40*BLOW_UP_67_SLED, -$0C*BLOW_UP_67_SLED ; draw, y, x
 DB $01, -$7F*BLOW_UP_67_SLED, +$7F*BLOW_UP_67_SLED ; sync and move to y, x
 DB $00, -$7F*BLOW_UP_67_SLED, +$7F*BLOW_UP_67_SLED ; additional sync move to y, x
 DB $00, -$18*BLOW_UP_67_SLED, +$3C*BLOW_UP_67_SLED ; additional sync move to y, x
 DB $FF, +$28*BLOW_UP_67_SLED, -$1A*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$16*BLOW_UP_67_SLED, -$2A*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$39*BLOW_UP_67_SLED, +$02*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$33*BLOW_UP_67_SLED, -$20*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$49*BLOW_UP_67_SLED, -$06*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$49*BLOW_UP_67_SLED, -$06*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$50*BLOW_UP_67_SLED, -$38*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$64*BLOW_UP_67_SLED, -$6E*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$3E*BLOW_UP_67_SLED, -$19*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$3F*BLOW_UP_67_SLED, -$2A*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, -$26*BLOW_UP_67_SLED, -$44*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$49*BLOW_UP_67_SLED, +$0D*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$36*BLOW_UP_67_SLED, -$32*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$0E*BLOW_UP_67_SLED, +$4F*BLOW_UP_67_SLED ; draw, y, x
 DB $FF, +$4A*BLOW_UP_67_SLED, +$25*BLOW_UP_67_SLED ; draw, y, x
 DB $02 ; endmarker 
BLOW_UP_68_SLED EQU 1

AnimList_67_SLED:
 DW AnimList_67_SLED_0 ; list of all single vectorlists in this
 DW 0

AnimList_67_SLED_0:
 DB $01, +$74*BLOW_UP_68_SLED, +$52*BLOW_UP_68_SLED ; sync and move to y, x
 DB $00, +$4E*BLOW_UP_68_SLED, +$00*BLOW_UP_68_SLED ; additional sync move to y, x
 DB $FF, +$20*BLOW_UP_68_SLED, -$04*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$10*BLOW_UP_68_SLED, +$0A*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$36*BLOW_UP_68_SLED, -$02*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$1E*BLOW_UP_68_SLED, +$06*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$02*BLOW_UP_68_SLED, +$18*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$2A*BLOW_UP_68_SLED, +$02*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$0A*BLOW_UP_68_SLED, +$0C*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$0A*BLOW_UP_68_SLED, +$0C*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$22*BLOW_UP_68_SLED, -$0C*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$0A*BLOW_UP_68_SLED, +$0C*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$1C*BLOW_UP_68_SLED, +$18*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$18*BLOW_UP_68_SLED, +$06*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$10*BLOW_UP_68_SLED, +$08*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$0E*BLOW_UP_68_SLED, +$20*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$00*BLOW_UP_68_SLED, -$1C*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$26*BLOW_UP_68_SLED, -$36*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$0E*BLOW_UP_68_SLED, +$30*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$16*BLOW_UP_68_SLED, +$1A*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$12*BLOW_UP_68_SLED, -$0C*BLOW_UP_68_SLED ; draw, y, x
 DB $01, +$34*BLOW_UP_68_SLED, +$74*BLOW_UP_68_SLED ; sync and move to y, x
 DB $00, +$00*BLOW_UP_68_SLED, +$4C*BLOW_UP_68_SLED ; additional sync move to y, x
 DB $FF, +$04*BLOW_UP_68_SLED, -$16*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$08*BLOW_UP_68_SLED, -$16*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$4C*BLOW_UP_68_SLED, +$00*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$3E*BLOW_UP_68_SLED, -$0A*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$1D*BLOW_UP_68_SLED, +$2F*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$36*BLOW_UP_68_SLED, -$4F*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$14*BLOW_UP_68_SLED, +$04*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$26*BLOW_UP_68_SLED, +$25*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$04*BLOW_UP_68_SLED, -$2B*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$70*BLOW_UP_68_SLED, -$58*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$14*BLOW_UP_68_SLED, +$00*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$60*BLOW_UP_68_SLED, +$36*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$02*BLOW_UP_68_SLED, -$5A*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$10*BLOW_UP_68_SLED, -$28*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$38*BLOW_UP_68_SLED, -$0C*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$34*BLOW_UP_68_SLED, +$18*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$1A*BLOW_UP_68_SLED, +$06*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$06*BLOW_UP_68_SLED, -$10*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$51*BLOW_UP_68_SLED, -$24*BLOW_UP_68_SLED ; draw, y, x
 DB $01, -$74*BLOW_UP_68_SLED, -$5E*BLOW_UP_68_SLED ; sync and move to y, x
 DB $00, -$14*BLOW_UP_68_SLED, +$00*BLOW_UP_68_SLED ; additional sync move to y, x
 DB $FF, +$20*BLOW_UP_68_SLED, -$0D*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$0E*BLOW_UP_68_SLED, -$10*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$10*BLOW_UP_68_SLED, -$26*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$3C*BLOW_UP_68_SLED, -$1E*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$12*BLOW_UP_68_SLED, -$16*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$1C*BLOW_UP_68_SLED, +$04*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$34*BLOW_UP_68_SLED, +$20*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$10*BLOW_UP_68_SLED, +$00*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$10*BLOW_UP_68_SLED, +$1C*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$3A*BLOW_UP_68_SLED, +$00*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$02*BLOW_UP_68_SLED, -$12*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$24*BLOW_UP_68_SLED, +$22*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$0E*BLOW_UP_68_SLED, +$22*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$08*BLOW_UP_68_SLED, +$74*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$16*BLOW_UP_68_SLED, +$34*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$2A*BLOW_UP_68_SLED, +$1A*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$1E*BLOW_UP_68_SLED, -$0E*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$08*BLOW_UP_68_SLED, +$18*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$08*BLOW_UP_68_SLED, -$1C*BLOW_UP_68_SLED ; draw, y, x
 DB $01, +$70*BLOW_UP_68_SLED, +$4C*BLOW_UP_68_SLED ; sync and move to y, x
 DB $FF, -$06*BLOW_UP_68_SLED, -$2E*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$0C*BLOW_UP_68_SLED, +$0A*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$08*BLOW_UP_68_SLED, -$0E*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$12*BLOW_UP_68_SLED, -$12*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$09*BLOW_UP_68_SLED, +$15*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$07*BLOW_UP_68_SLED, +$0A*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$14*BLOW_UP_68_SLED, -$04*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$12*BLOW_UP_68_SLED, -$18*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$04*BLOW_UP_68_SLED, +$0E*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$12*BLOW_UP_68_SLED, -$0A*BLOW_UP_68_SLED ; draw, y, x
 DB $01, +$74*BLOW_UP_68_SLED, +$10*BLOW_UP_68_SLED ; sync and move to y, x
 DB $00, +$56*BLOW_UP_68_SLED, +$00*BLOW_UP_68_SLED ; additional sync move to y, x
 DB $FF, -$0A*BLOW_UP_68_SLED, +$10*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$1C*BLOW_UP_68_SLED, -$04*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$2F*BLOW_UP_68_SLED, +$19*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$14*BLOW_UP_68_SLED, +$00*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, -$08*BLOW_UP_68_SLED, +$14*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$12*BLOW_UP_68_SLED, +$00*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$1C*BLOW_UP_68_SLED, -$18*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$02*BLOW_UP_68_SLED, +$14*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$0E*BLOW_UP_68_SLED, -$04*BLOW_UP_68_SLED ; draw, y, x
 DB $FF, +$0C*BLOW_UP_68_SLED, -$10*BLOW_UP_68_SLED ; draw, y, x
 DB $02 ; endmarker 


;**********************************************************************************
;**********************************************************************************
;** Deer Feed
;**********************************************************************************


NO_OF_LANES_DeerFeed = (3 +1) ; plus one for ZERO


 bss
 org sample_ram

laneRAM_DeerFeed ds laneData*NO_OF_LANES_DeerFeed
roundCounter_DeerFeed ds 2
 code

initStoryboardDeerFeed
; here the cartridge program starts off
 ldd #TEN_SECONDS ; ten seconds
 std bigCounter

 ldu #(laneRAM_DeerFeed-laneData)


 leau laneData,u 
 ldx #lane72Data_DeerFeed 
 jsr initLane

 leau laneData,u 
 ldx #lane95Data_DeerFeed 
 jsr initLane

 leau laneData,u 
 ldx #lane96Data_DeerFeed 
 jsr initLane

 ldd #0
 std roundCounter_DeerFeed
 leau laneData,u
 std ,u
 rts

playStoryboardDeerFeed

 ldd bigCounter
 subd #1
  std bigCounter
 bne notFinishedStoryboardDeerFeed
 clr demoRunningFlag 
notFinishedStoryboardDeerFeed


 ldy #laneRAM_DeerFeed
doNextLane_DeerFeed
 ldd ,y
 beq lanesDone_DeerFeed
 jsr doLane
 leay laneData,y
 bra doNextLane_DeerFeed
lanesDone_DeerFeed:

; increase round counter!
 ldx roundCounter_DeerFeed
 leax 1,x
 stx roundCounter_DeerFeed
 rts


;SUB_START


lane72Data_DeerFeed: 
 dw element_721_DeerFeed
 dw element_722_DeerFeed
 dw element_723_DeerFeed
 dw element_724_DeerFeed
 dw 0

element_721_DeerFeed:
 dw AnimList_151_DeerFeed
 db 3; delay
 db 40; scale from
 db 40; scale to
 db 0; scale delay
 db 0; scale increase
 db 80; intensityFrom
 db 80; intensityTo
 db 0; intensityDelay
 db 0; intensityIncrease
 db 0, -120; position from (y,x)
 db 0, -120; position to (y,x)
 db 0, 0; position delay (y,x)
 db 0, 0; position increase (y,x)
 db 20; move scale
 dw draw_synced_list; draw jsr
 db BEHAVIOUR_NONE+BEHAVIOUR_ANIMATION_LOOP ; BEHAVIOUR_PAUSE / BEHAVIOUR_ANIMATION_LOOP
 dw 100; element end count
 db ELEMENT_ANIM ; type of element 

element_722_DeerFeed:
 dw AnimList_152_DeerFeed
 db 3; delay
 db 20; scale from
 db 20; scale to
 db 0; scale delay
 db 0; scale increase
 db 80; intensityFrom
 db 80; intensityTo
 db 0; intensityDelay
 db 0; intensityIncrease
 db 0, -120; position from (y,x)
 db 0, -120; position to (y,x)
 db 0, 0; position delay (y,x)
 db 0, 0; position increase (y,x)
 db 20; move scale
 dw draw_synced_list; draw jsr
 db BEHAVIOUR_NONE+BEHAVIOUR_ANIMATION_LOOP ; BEHAVIOUR_PAUSE / BEHAVIOUR_ANIMATION_LOOP
 dw 100; element end count
 db ELEMENT_ANIM ; type of element 

element_723_DeerFeed:
 dw AnimList_153_DeerFeed
 db 3; delay
 db 40; scale from
 db 40; scale to
 db 0; scale delay
 db 0; scale increase
 db 80; intensityFrom
 db 80; intensityTo
 db 0; intensityDelay
 db 0; intensityIncrease
 db 0, -120; position from (y,x)
 db 0, -120; position to (y,x)
 db 0, 0; position delay (y,x)
 db 0, 0; position increase (y,x)
 db 20; move scale
 dw draw_synced_list; draw jsr
 db BEHAVIOUR_NONE+BEHAVIOUR_ANIMATION_LOOP ; BEHAVIOUR_PAUSE / BEHAVIOUR_ANIMATION_LOOP
 dw 50; element end count
 db ELEMENT_ANIM ; type of element 

element_724_DeerFeed:
 dw AnimList_154_DeerFeed
 db 3; delay
 db 43; scale from
 db 43; scale to
 db 0; scale delay
 db 0; scale increase
 db 80; intensityFrom
 db 80; intensityTo
 db 0; intensityDelay
 db 0; intensityIncrease
 db 0, -120; position from (y,x)
 db 0, -120; position to (y,x)
 db 0, 0; position delay (y,x)
 db 0, 0; position increase (y,x)
 db 20; move scale
 dw draw_synced_list; draw jsr
 db BEHAVIOUR_NONE+BEHAVIOUR_ANIMATION_LOOP ; BEHAVIOUR_PAUSE / BEHAVIOUR_ANIMATION_LOOP
 dw 50; element end count
 db ELEMENT_ANIM ; type of element 

lane95Data_DeerFeed: 
 dw element_951_DeerFeed
 dw 0

element_951_DeerFeed:
 dw AnimList_155_DeerFeed
 db 3; delay
 db 60; scale from
 db 60; scale to
 db 0; scale delay
 db 0; scale increase
 db 40; intensityFrom
 db 40; intensityTo
 db 0; intensityDelay
 db 0; intensityIncrease
 db 120, 120; position from (y,x)
 db 120, 120; position to (y,x)
 db 0, 0; position delay (y,x)
 db 0, 0; position increase (y,x)
 db 60; move scale
 dw draw_synced_list; draw jsr
 db BEHAVIOUR_NONE+BEHAVIOUR_ANIMATION_LOOP ; BEHAVIOUR_PAUSE / BEHAVIOUR_ANIMATION_LOOP
 dw 200; element end count
 db ELEMENT_ANIM ; type of element 

lane96Data_DeerFeed: 
 dw element_961_DeerFeed
 dw 0

element_961_DeerFeed:
 dw AnimList_156_DeerFeed
 db 3; delay
 db 40; scale from
 db 40; scale to
 db 0; scale delay
 db 0; scale increase
 db 80; intensityFrom
 db 80; intensityTo
 db 0; intensityDelay
 db 0; intensityIncrease
 db -120, 120; position from (y,x)
 db -120, 120; position to (y,x)
 db 0, 0; position delay (y,x)
 db 0, 0; position increase (y,x)
 db 80; move scale
 dw draw_synced_list; draw jsr
 db BEHAVIOUR_NONE+BEHAVIOUR_ANIMATION_LOOP ; BEHAVIOUR_PAUSE / BEHAVIOUR_ANIMATION_LOOP
 dw 200; element end count
 db ELEMENT_ANIM ; type of element 
BLOW_UP_152_DeerFeed EQU 1

AnimList_151_DeerFeed:
 DW AnimList_151_DeerFeed_0 ; list of all single vectorlists in this
 DW 0

AnimList_151_DeerFeed_0:
 DB $01, -$4C*BLOW_UP_152_DeerFeed, -$09*BLOW_UP_152_DeerFeed ; sync and move to y, x
 DB $00, -$20*BLOW_UP_152_DeerFeed, +$00*BLOW_UP_152_DeerFeed ; additional sync move to y, x
 DB $FF, -$09*BLOW_UP_152_DeerFeed, -$05*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$00*BLOW_UP_152_DeerFeed, +$0A*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$22*BLOW_UP_152_DeerFeed, +$00*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$1E*BLOW_UP_152_DeerFeed, +$12*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$07*BLOW_UP_152_DeerFeed, +$09*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$0D*BLOW_UP_152_DeerFeed, -$02*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$01*BLOW_UP_152_DeerFeed, -$05*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$05*BLOW_UP_152_DeerFeed, +$00*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$26*BLOW_UP_152_DeerFeed, -$12*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$19*BLOW_UP_152_DeerFeed, +$01*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $01, -$26*BLOW_UP_152_DeerFeed, -$01*BLOW_UP_152_DeerFeed ; sync and move to y, x
 DB $FF, -$07*BLOW_UP_152_DeerFeed, +$24*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$07*BLOW_UP_152_DeerFeed, +$22*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$4C*BLOW_UP_152_DeerFeed, -$10*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$03*BLOW_UP_152_DeerFeed, -$03*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$00*BLOW_UP_152_DeerFeed, +$0A*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$3A*BLOW_UP_152_DeerFeed, +$14*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$03*BLOW_UP_152_DeerFeed, +$05*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$39*BLOW_UP_152_DeerFeed, +$0D*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$06*BLOW_UP_152_DeerFeed, -$05*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$01*BLOW_UP_152_DeerFeed, +$0A*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $01, -$4C*BLOW_UP_152_DeerFeed, +$4C*BLOW_UP_152_DeerFeed ; sync and move to y, x
 DB $00, -$32*BLOW_UP_152_DeerFeed, +$1A*BLOW_UP_152_DeerFeed ; additional sync move to y, x
 DB $FF, +$0C*BLOW_UP_152_DeerFeed, +$02*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$35*BLOW_UP_152_DeerFeed, -$07*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$13*BLOW_UP_152_DeerFeed, -$0A*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$34*BLOW_UP_152_DeerFeed, +$04*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$0B*BLOW_UP_152_DeerFeed, -$05*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$04*BLOW_UP_152_DeerFeed, +$0B*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$02*BLOW_UP_152_DeerFeed, -$07*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$0C*BLOW_UP_152_DeerFeed, +$0A*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$0C*BLOW_UP_152_DeerFeed, -$12*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $01, +$1A*BLOW_UP_152_DeerFeed, +$4C*BLOW_UP_152_DeerFeed ; sync and move to y, x
 DB $00, +$00*BLOW_UP_152_DeerFeed, +$06*BLOW_UP_152_DeerFeed ; additional sync move to y, x
 DB $FF, +$03*BLOW_UP_152_DeerFeed, -$11*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$02*BLOW_UP_152_DeerFeed, -$26*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$06*BLOW_UP_152_DeerFeed, -$31*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$3F*BLOW_UP_152_DeerFeed, -$25*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$04*BLOW_UP_152_DeerFeed, -$07*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$25*BLOW_UP_152_DeerFeed, +$02*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$0B*BLOW_UP_152_DeerFeed, -$04*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$0A*BLOW_UP_152_DeerFeed, -$01*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$2E*BLOW_UP_152_DeerFeed, -$0F*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$21*BLOW_UP_152_DeerFeed, +$07*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$1B*BLOW_UP_152_DeerFeed, -$1B*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$0B*BLOW_UP_152_DeerFeed, +$05*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$0E*BLOW_UP_152_DeerFeed, -$11*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$19*BLOW_UP_152_DeerFeed, +$13*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$03*BLOW_UP_152_DeerFeed, -$18*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$0C*BLOW_UP_152_DeerFeed, +$14*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $01, +$01*BLOW_UP_152_DeerFeed, -$4C*BLOW_UP_152_DeerFeed ; sync and move to y, x
 DB $00, +$00*BLOW_UP_152_DeerFeed, -$19*BLOW_UP_152_DeerFeed ; additional sync move to y, x
 DB $FF, -$0B*BLOW_UP_152_DeerFeed, +$01*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$0D*BLOW_UP_152_DeerFeed, +$06*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$10*BLOW_UP_152_DeerFeed, +$15*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$1E*BLOW_UP_152_DeerFeed, -$02*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$1C*BLOW_UP_152_DeerFeed, -$04*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$0A*BLOW_UP_152_DeerFeed, -$0D*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$0E*BLOW_UP_152_DeerFeed, +$08*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$0E*BLOW_UP_152_DeerFeed, +$00*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $01, -$20*BLOW_UP_152_DeerFeed, -$4C*BLOW_UP_152_DeerFeed ; sync and move to y, x
 DB $00, +$00*BLOW_UP_152_DeerFeed, -$08*BLOW_UP_152_DeerFeed ; additional sync move to y, x
 DB $FF, +$15*BLOW_UP_152_DeerFeed, -$20*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$13*BLOW_UP_152_DeerFeed, +$14*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$03*BLOW_UP_152_DeerFeed, -$0C*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$05*BLOW_UP_152_DeerFeed, -$0E*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$0A*BLOW_UP_152_DeerFeed, +$14*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$09*BLOW_UP_152_DeerFeed, +$03*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$09*BLOW_UP_152_DeerFeed, +$00*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$03*BLOW_UP_152_DeerFeed, +$06*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$10*BLOW_UP_152_DeerFeed, +$12*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$0F*BLOW_UP_152_DeerFeed, -$02*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$28*BLOW_UP_152_DeerFeed, +$0A*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$00*BLOW_UP_152_DeerFeed, +$06*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$1C*BLOW_UP_152_DeerFeed, +$0D*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$15*BLOW_UP_152_DeerFeed, -$02*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, +$12*BLOW_UP_152_DeerFeed, +$1F*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $FF, -$46*BLOW_UP_152_DeerFeed, +$0A*BLOW_UP_152_DeerFeed ; draw, y, x
 DB $02 ; endmarker 
BLOW_UP_153_DeerFeed EQU 2

AnimList_152_DeerFeed:
 DW AnimList_152_DeerFeed_0 ; list of all single vectorlists in this
 DW 0

AnimList_152_DeerFeed_0:
 DB $01, +$3F*BLOW_UP_153_DeerFeed, -$0F*BLOW_UP_153_DeerFeed ; sync and move to y, x
 DB $00, +$3F*BLOW_UP_153_DeerFeed, +$00*BLOW_UP_153_DeerFeed ; additional sync move to y, x
 DB $00, +$0D*BLOW_UP_153_DeerFeed, +$00*BLOW_UP_153_DeerFeed ; additional sync move to y, x
 DB $FF, -$1D*BLOW_UP_153_DeerFeed, +$01*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$0C*BLOW_UP_153_DeerFeed, -$05*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$12*BLOW_UP_153_DeerFeed, -$0B*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$12*BLOW_UP_153_DeerFeed, +$06*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$0A*BLOW_UP_153_DeerFeed, -$03*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$0F*BLOW_UP_153_DeerFeed, -$0F*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$12*BLOW_UP_153_DeerFeed, -$04*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$12*BLOW_UP_153_DeerFeed, +$02*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$09*BLOW_UP_153_DeerFeed, -$06*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$20*BLOW_UP_153_DeerFeed, +$00*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $01, +$3F*BLOW_UP_153_DeerFeed, -$33*BLOW_UP_153_DeerFeed ; sync and move to y, x
 DB $00, +$05*BLOW_UP_153_DeerFeed, +$00*BLOW_UP_153_DeerFeed ; additional sync move to y, x
 DB $FF, -$07*BLOW_UP_153_DeerFeed, -$0F*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$02*BLOW_UP_153_DeerFeed, -$08*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$16*BLOW_UP_153_DeerFeed, +$00*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$1A*BLOW_UP_153_DeerFeed, +$1B*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$0B*BLOW_UP_153_DeerFeed, +$00*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$0E*BLOW_UP_153_DeerFeed, -$08*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$06*BLOW_UP_153_DeerFeed, -$08*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$0E*BLOW_UP_153_DeerFeed, -$06*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$0E*BLOW_UP_153_DeerFeed, +$01*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$0C*BLOW_UP_153_DeerFeed, -$06*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $01, +$3F*BLOW_UP_153_DeerFeed, -$3F*BLOW_UP_153_DeerFeed ; sync and move to y, x
 DB $00, +$37*BLOW_UP_153_DeerFeed, -$0C*BLOW_UP_153_DeerFeed ; additional sync move to y, x
 DB $FF, -$09*BLOW_UP_153_DeerFeed, -$03*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$10*BLOW_UP_153_DeerFeed, +$04*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$06*BLOW_UP_153_DeerFeed, -$0B*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$0D*BLOW_UP_153_DeerFeed, -$07*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$0C*BLOW_UP_153_DeerFeed, -$01*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$0E*BLOW_UP_153_DeerFeed, +$0A*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$19*BLOW_UP_153_DeerFeed, +$03*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$0B*BLOW_UP_153_DeerFeed, -$14*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$02*BLOW_UP_153_DeerFeed, -$0C*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$0A*BLOW_UP_153_DeerFeed, -$02*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $01, +$26*BLOW_UP_153_DeerFeed, -$3F*BLOW_UP_153_DeerFeed ; sync and move to y, x
 DB $00, +$00*BLOW_UP_153_DeerFeed, -$34*BLOW_UP_153_DeerFeed ; additional sync move to y, x
 DB $FF, +$00*BLOW_UP_153_DeerFeed, +$09*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$0C*BLOW_UP_153_DeerFeed, +$12*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$00*BLOW_UP_153_DeerFeed, +$11*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$1B*BLOW_UP_153_DeerFeed, +$02*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$09*BLOW_UP_153_DeerFeed, +$03*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$0E*BLOW_UP_153_DeerFeed, -$1D*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$0D*BLOW_UP_153_DeerFeed, +$00*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$25*BLOW_UP_153_DeerFeed, +$19*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$14*BLOW_UP_153_DeerFeed, -$01*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$02*BLOW_UP_153_DeerFeed, +$0A*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $01, -$3F*BLOW_UP_153_DeerFeed, -$3C*BLOW_UP_153_DeerFeed ; sync and move to y, x
 DB $00, -$1D*BLOW_UP_153_DeerFeed, +$00*BLOW_UP_153_DeerFeed ; additional sync move to y, x
 DB $FF, -$11*BLOW_UP_153_DeerFeed, +$03*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$0D*BLOW_UP_153_DeerFeed, -$04*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$04*BLOW_UP_153_DeerFeed, +$0B*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$3A*BLOW_UP_153_DeerFeed, -$08*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$13*BLOW_UP_153_DeerFeed, -$07*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$0D*BLOW_UP_153_DeerFeed, +$1D*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$00*BLOW_UP_153_DeerFeed, +$2E*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$0C*BLOW_UP_153_DeerFeed, +$18*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$0C*BLOW_UP_153_DeerFeed, +$07*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$0E*BLOW_UP_153_DeerFeed, +$17*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $01, -$3F*BLOW_UP_153_DeerFeed, +$3F*BLOW_UP_153_DeerFeed ; sync and move to y, x
 DB $00, -$0D*BLOW_UP_153_DeerFeed, +$00*BLOW_UP_153_DeerFeed ; additional sync move to y, x
 DB $FF, -$2A*BLOW_UP_153_DeerFeed, +$05*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$0B*BLOW_UP_153_DeerFeed, -$05*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$02*BLOW_UP_153_DeerFeed, +$0B*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$2D*BLOW_UP_153_DeerFeed, -$04*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$09*BLOW_UP_153_DeerFeed, +$06*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$1F*BLOW_UP_153_DeerFeed, +$0D*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$06*BLOW_UP_153_DeerFeed, +$07*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$24*BLOW_UP_153_DeerFeed, -$0F*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$36*BLOW_UP_153_DeerFeed, +$05*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$20*BLOW_UP_153_DeerFeed, -$09*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $01, -$06*BLOW_UP_153_DeerFeed, +$3F*BLOW_UP_153_DeerFeed ; sync and move to y, x
 DB $00, +$00*BLOW_UP_153_DeerFeed, +$0E*BLOW_UP_153_DeerFeed ; additional sync move to y, x
 DB $FF, -$07*BLOW_UP_153_DeerFeed, +$08*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$0B*BLOW_UP_153_DeerFeed, -$02*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$07*BLOW_UP_153_DeerFeed, -$08*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$00*BLOW_UP_153_DeerFeed, -$0B*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$07*BLOW_UP_153_DeerFeed, -$16*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$02*BLOW_UP_153_DeerFeed, -$3F*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$08*BLOW_UP_153_DeerFeed, -$0E*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$13*BLOW_UP_153_DeerFeed, -$0C*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$0C*BLOW_UP_153_DeerFeed, -$03*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$0D*BLOW_UP_153_DeerFeed, +$0B*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $01, +$3E*BLOW_UP_153_DeerFeed, -$26*BLOW_UP_153_DeerFeed ; sync and move to y, x
 DB $FF, -$02*BLOW_UP_153_DeerFeed, -$09*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$08*BLOW_UP_153_DeerFeed, +$08*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$05*BLOW_UP_153_DeerFeed, +$0B*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$09*BLOW_UP_153_DeerFeed, +$14*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$02*BLOW_UP_153_DeerFeed, -$08*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$0E*BLOW_UP_153_DeerFeed, +$08*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, -$08*BLOW_UP_153_DeerFeed, -$0E*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$08*BLOW_UP_153_DeerFeed, +$04*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$0B*BLOW_UP_153_DeerFeed, +$06*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$15*BLOW_UP_153_DeerFeed, +$00*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $FF, +$0D*BLOW_UP_153_DeerFeed, -$03*BLOW_UP_153_DeerFeed ; draw, y, x
 DB $02 ; endmarker 
BLOW_UP_154_DeerFeed EQU 1

AnimList_153_DeerFeed:
 DW AnimList_153_DeerFeed_0 ; list of all single vectorlists in this
 DW 0

AnimList_153_DeerFeed_0:
 DB $01, +$44*BLOW_UP_154_DeerFeed, -$26*BLOW_UP_154_DeerFeed ; sync and move to y, x
 DB $00, +$44*BLOW_UP_154_DeerFeed, +$00*BLOW_UP_154_DeerFeed ; additional sync move to y, x
 DB $00, +$0C*BLOW_UP_154_DeerFeed, +$00*BLOW_UP_154_DeerFeed ; additional sync move to y, x
 DB $FF, -$14*BLOW_UP_154_DeerFeed, -$0A*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$0B*BLOW_UP_154_DeerFeed, -$01*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$0D*BLOW_UP_154_DeerFeed, +$07*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$06*BLOW_UP_154_DeerFeed, -$0B*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$26*BLOW_UP_154_DeerFeed, +$22*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$08*BLOW_UP_154_DeerFeed, -$0A*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$07*BLOW_UP_154_DeerFeed, +$08*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$00*BLOW_UP_154_DeerFeed, +$0A*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$0B*BLOW_UP_154_DeerFeed, -$04*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$02*BLOW_UP_154_DeerFeed, -$08*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$0C*BLOW_UP_154_DeerFeed, +$03*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$08*BLOW_UP_154_DeerFeed, +$09*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$09*BLOW_UP_154_DeerFeed, -$04*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$09*BLOW_UP_154_DeerFeed, -$0F*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $01, +$04*BLOW_UP_154_DeerFeed, -$1E*BLOW_UP_154_DeerFeed ; sync and move to y, x
 DB $FF, -$0C*BLOW_UP_154_DeerFeed, -$07*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$1E*BLOW_UP_154_DeerFeed, +$00*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$1B*BLOW_UP_154_DeerFeed, +$0E*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$30*BLOW_UP_154_DeerFeed, -$02*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$0C*BLOW_UP_154_DeerFeed, -$05*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$12*BLOW_UP_154_DeerFeed, +$09*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$28*BLOW_UP_154_DeerFeed, +$06*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$0A*BLOW_UP_154_DeerFeed, +$03*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$2E*BLOW_UP_154_DeerFeed, -$03*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$05*BLOW_UP_154_DeerFeed, +$07*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$2D*BLOW_UP_154_DeerFeed, +$01*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$34*BLOW_UP_154_DeerFeed, +$04*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$3C*BLOW_UP_154_DeerFeed, +$06*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$3C*BLOW_UP_154_DeerFeed, +$07*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$22*BLOW_UP_154_DeerFeed, +$03*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$21*BLOW_UP_154_DeerFeed, +$03*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $01, -$39*BLOW_UP_154_DeerFeed, +$10*BLOW_UP_154_DeerFeed ; sync and move to y, x
 DB $FF, +$17*BLOW_UP_154_DeerFeed, +$09*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$1C*BLOW_UP_154_DeerFeed, +$00*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$09*BLOW_UP_154_DeerFeed, -$03*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$34*BLOW_UP_154_DeerFeed, -$01*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$06*BLOW_UP_154_DeerFeed, +$09*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$09*BLOW_UP_154_DeerFeed, -$05*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$0C*BLOW_UP_154_DeerFeed, +$10*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$0D*BLOW_UP_154_DeerFeed, +$03*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$05*BLOW_UP_154_DeerFeed, -$07*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$15*BLOW_UP_154_DeerFeed, +$03*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$12*BLOW_UP_154_DeerFeed, -$08*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$06*BLOW_UP_154_DeerFeed, -$07*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$0D*BLOW_UP_154_DeerFeed, +$08*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$0C*BLOW_UP_154_DeerFeed, +$05*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$09*BLOW_UP_154_DeerFeed, -$04*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $01, +$44*BLOW_UP_154_DeerFeed, +$22*BLOW_UP_154_DeerFeed ; sync and move to y, x
 DB $00, +$23*BLOW_UP_154_DeerFeed, +$00*BLOW_UP_154_DeerFeed ; additional sync move to y, x
 DB $FF, +$09*BLOW_UP_154_DeerFeed, -$07*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$0E*BLOW_UP_154_DeerFeed, +$07*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$19*BLOW_UP_154_DeerFeed, -$09*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$06*BLOW_UP_154_DeerFeed, -$09*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$04*BLOW_UP_154_DeerFeed, -$0E*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$00*BLOW_UP_154_DeerFeed, -$0B*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$0E*BLOW_UP_154_DeerFeed, -$07*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$09*BLOW_UP_154_DeerFeed, -$0A*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$0E*BLOW_UP_154_DeerFeed, -$06*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$10*BLOW_UP_154_DeerFeed, +$06*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$0B*BLOW_UP_154_DeerFeed, +$05*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, -$15*BLOW_UP_154_DeerFeed, -$0D*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$04*BLOW_UP_154_DeerFeed, -$07*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$0E*BLOW_UP_154_DeerFeed, -$04*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $FF, +$17*BLOW_UP_154_DeerFeed, +$07*BLOW_UP_154_DeerFeed ; draw, y, x
 DB $02 ; endmarker 
BLOW_UP_155_DeerFeed EQU 1

AnimList_154_DeerFeed:
 DW AnimList_154_DeerFeed_0 ; list of all single vectorlists in this
 DW 0

AnimList_154_DeerFeed_0:
 DB $01, +$61*BLOW_UP_155_DeerFeed, +$27*BLOW_UP_155_DeerFeed ; sync and move to y, x
 DB $00, +$26*BLOW_UP_155_DeerFeed, +$00*BLOW_UP_155_DeerFeed ; additional sync move to y, x
 DB $FF, -$18*BLOW_UP_155_DeerFeed, +$05*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$13*BLOW_UP_155_DeerFeed, +$00*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$15*BLOW_UP_155_DeerFeed, -$03*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$09*BLOW_UP_155_DeerFeed, -$04*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$07*BLOW_UP_155_DeerFeed, +$01*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$06*BLOW_UP_155_DeerFeed, +$03*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$0B*BLOW_UP_155_DeerFeed, +$00*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$05*BLOW_UP_155_DeerFeed, -$05*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$15*BLOW_UP_155_DeerFeed, +$05*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$0C*BLOW_UP_155_DeerFeed, +$00*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$06*BLOW_UP_155_DeerFeed, -$04*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$07*BLOW_UP_155_DeerFeed, -$01*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$18*BLOW_UP_155_DeerFeed, +$00*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$10*BLOW_UP_155_DeerFeed, -$0B*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$01*BLOW_UP_155_DeerFeed, -$14*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$08*BLOW_UP_155_DeerFeed, -$08*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$07*BLOW_UP_155_DeerFeed, -$04*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$16*BLOW_UP_155_DeerFeed, -$02*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$16*BLOW_UP_155_DeerFeed, -$01*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $01, +$3A*BLOW_UP_155_DeerFeed, -$0A*BLOW_UP_155_DeerFeed ; sync and move to y, x
 DB $FF, +$07*BLOW_UP_155_DeerFeed, -$03*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$1B*BLOW_UP_155_DeerFeed, +$00*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$15*BLOW_UP_155_DeerFeed, +$05*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$0F*BLOW_UP_155_DeerFeed, -$06*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$02*BLOW_UP_155_DeerFeed, -$05*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$23*BLOW_UP_155_DeerFeed, +$05*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$06*BLOW_UP_155_DeerFeed, -$05*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$29*BLOW_UP_155_DeerFeed, -$01*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$15*BLOW_UP_155_DeerFeed, -$05*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$0C*BLOW_UP_155_DeerFeed, +$00*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $01, +$5E*BLOW_UP_155_DeerFeed, -$19*BLOW_UP_155_DeerFeed ; sync and move to y, x
 DB $FF, -$15*BLOW_UP_155_DeerFeed, +$05*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$0F*BLOW_UP_155_DeerFeed, +$07*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$0D*BLOW_UP_155_DeerFeed, +$0B*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$01*BLOW_UP_155_DeerFeed, -$0D*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$09*BLOW_UP_155_DeerFeed, +$08*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$02*BLOW_UP_155_DeerFeed, +$0A*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$1E*BLOW_UP_155_DeerFeed, -$05*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$05*BLOW_UP_155_DeerFeed, -$13*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$04*BLOW_UP_155_DeerFeed, -$06*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$09*BLOW_UP_155_DeerFeed, -$08*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $01, -$0F*BLOW_UP_155_DeerFeed, -$23*BLOW_UP_155_DeerFeed ; sync and move to y, x
 DB $FF, -$02*BLOW_UP_155_DeerFeed, +$06*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$08*BLOW_UP_155_DeerFeed, +$03*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$0B*BLOW_UP_155_DeerFeed, +$01*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$10*BLOW_UP_155_DeerFeed, +$08*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$43*BLOW_UP_155_DeerFeed, -$02*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$08*BLOW_UP_155_DeerFeed, +$05*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$00*BLOW_UP_155_DeerFeed, +$06*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$05*BLOW_UP_155_DeerFeed, -$04*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$22*BLOW_UP_155_DeerFeed, -$03*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$0B*BLOW_UP_155_DeerFeed, +$08*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$2B*BLOW_UP_155_DeerFeed, +$02*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$07*BLOW_UP_155_DeerFeed, +$03*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$00*BLOW_UP_155_DeerFeed, +$08*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$07*BLOW_UP_155_DeerFeed, -$04*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$05*BLOW_UP_155_DeerFeed, -$05*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$21*BLOW_UP_155_DeerFeed, +$01*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$0A*BLOW_UP_155_DeerFeed, +$06*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$04*BLOW_UP_155_DeerFeed, +$06*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$3B*BLOW_UP_155_DeerFeed, +$03*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $01, -$61*BLOW_UP_155_DeerFeed, +$0C*BLOW_UP_155_DeerFeed ; sync and move to y, x
 DB $00, -$1F*BLOW_UP_155_DeerFeed, +$00*BLOW_UP_155_DeerFeed ; additional sync move to y, x
 DB $FF, +$00*BLOW_UP_155_DeerFeed, +$08*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$07*BLOW_UP_155_DeerFeed, -$05*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$2B*BLOW_UP_155_DeerFeed, -$01*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$0B*BLOW_UP_155_DeerFeed, +$03*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$1E*BLOW_UP_155_DeerFeed, +$08*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$1F*BLOW_UP_155_DeerFeed, +$00*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$00*BLOW_UP_155_DeerFeed, +$0A*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$05*BLOW_UP_155_DeerFeed, -$06*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$31*BLOW_UP_155_DeerFeed, +$02*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$30*BLOW_UP_155_DeerFeed, +$03*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$18*BLOW_UP_155_DeerFeed, -$06*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $01, -$01*BLOW_UP_155_DeerFeed, +$1D*BLOW_UP_155_DeerFeed ; sync and move to y, x
 DB $FF, +$1A*BLOW_UP_155_DeerFeed, +$02*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$0A*BLOW_UP_155_DeerFeed, -$04*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$03*BLOW_UP_155_DeerFeed, +$0B*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$08*BLOW_UP_155_DeerFeed, +$07*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$03*BLOW_UP_155_DeerFeed, -$07*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, -$03*BLOW_UP_155_DeerFeed, -$07*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$0D*BLOW_UP_155_DeerFeed, +$09*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$10*BLOW_UP_155_DeerFeed, +$05*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$25*BLOW_UP_155_DeerFeed, +$00*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $FF, +$16*BLOW_UP_155_DeerFeed, -$07*BLOW_UP_155_DeerFeed ; draw, y, x
 DB $02 ; endmarker 
BLOW_UP_156_DeerFeed EQU 1

AnimList_155_DeerFeed:
 DW AnimList_155_DeerFeed_0 ; list of all single vectorlists in this
 DW 0

AnimList_155_DeerFeed_0:
 DB $01, +$43*BLOW_UP_156_DeerFeed, -$19*BLOW_UP_156_DeerFeed ; sync and move to y, x
 DB $00, +$3A*BLOW_UP_156_DeerFeed, +$00*BLOW_UP_156_DeerFeed ; additional sync move to y, x
 DB $FF, -$10*BLOW_UP_156_DeerFeed, -$09*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, -$03*BLOW_UP_156_DeerFeed, -$16*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, -$0A*BLOW_UP_156_DeerFeed, +$0E*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, -$0F*BLOW_UP_156_DeerFeed, -$02*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$06*BLOW_UP_156_DeerFeed, +$10*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, -$2C*BLOW_UP_156_DeerFeed, -$23*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$06*BLOW_UP_156_DeerFeed, +$12*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, -$19*BLOW_UP_156_DeerFeed, -$21*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$00*BLOW_UP_156_DeerFeed, +$14*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, -$13*BLOW_UP_156_DeerFeed, -$25*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, -$01*BLOW_UP_156_DeerFeed, +$1D*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, -$12*BLOW_UP_156_DeerFeed, -$2E*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $01, -$10*BLOW_UP_156_DeerFeed, -$43*BLOW_UP_156_DeerFeed ; sync and move to y, x
 DB $00, +$00*BLOW_UP_156_DeerFeed, -$2D*BLOW_UP_156_DeerFeed ; additional sync move to y, x
 DB $FF, -$04*BLOW_UP_156_DeerFeed, +$27*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, -$1C*BLOW_UP_156_DeerFeed, -$30*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, -$06*BLOW_UP_156_DeerFeed, +$26*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, -$27*BLOW_UP_156_DeerFeed, -$3B*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$02*BLOW_UP_156_DeerFeed, +$22*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$02*BLOW_UP_156_DeerFeed, +$21*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, -$0D*BLOW_UP_156_DeerFeed, -$09*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$0D*BLOW_UP_156_DeerFeed, +$23*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, -$09*BLOW_UP_156_DeerFeed, -$03*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$07*BLOW_UP_156_DeerFeed, +$0C*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, -$1D*BLOW_UP_156_DeerFeed, +$01*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$00*BLOW_UP_156_DeerFeed, +$18*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$1A*BLOW_UP_156_DeerFeed, +$03*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, -$05*BLOW_UP_156_DeerFeed, +$11*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $01, -$43*BLOW_UP_156_DeerFeed, +$07*BLOW_UP_156_DeerFeed ; sync and move to y, x
 DB $00, -$21*BLOW_UP_156_DeerFeed, +$00*BLOW_UP_156_DeerFeed ; additional sync move to y, x
 DB $FF, +$0E*BLOW_UP_156_DeerFeed, -$03*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, -$0C*BLOW_UP_156_DeerFeed, +$21*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, -$01*BLOW_UP_156_DeerFeed, +$2A*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$1C*BLOW_UP_156_DeerFeed, -$27*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$00*BLOW_UP_156_DeerFeed, +$21*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$12*BLOW_UP_156_DeerFeed, -$1E*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$00*BLOW_UP_156_DeerFeed, +$17*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$1B*BLOW_UP_156_DeerFeed, -$31*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, -$08*BLOW_UP_156_DeerFeed, +$2A*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$13*BLOW_UP_156_DeerFeed, -$26*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, -$02*BLOW_UP_156_DeerFeed, +$1C*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$14*BLOW_UP_156_DeerFeed, -$2A*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $01, +$04*BLOW_UP_156_DeerFeed, +$08*BLOW_UP_156_DeerFeed ; sync and move to y, x
 DB $FF, +$00*BLOW_UP_156_DeerFeed, +$27*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$0E*BLOW_UP_156_DeerFeed, -$23*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$06*BLOW_UP_156_DeerFeed, +$0D*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$0A*BLOW_UP_156_DeerFeed, -$1B*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$00*BLOW_UP_156_DeerFeed, +$10*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$0B*BLOW_UP_156_DeerFeed, -$12*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$03*BLOW_UP_156_DeerFeed, +$0C*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$26*BLOW_UP_156_DeerFeed, -$20*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, -$06*BLOW_UP_156_DeerFeed, +$10*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$10*BLOW_UP_156_DeerFeed, -$03*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$09*BLOW_UP_156_DeerFeed, +$10*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$03*BLOW_UP_156_DeerFeed, -$18*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $FF, +$10*BLOW_UP_156_DeerFeed, -$06*BLOW_UP_156_DeerFeed ; draw, y, x
 DB $02 ; endmarker 
BLOW_UP_157_DeerFeed EQU 1

AnimList_156_DeerFeed:
 DW AnimList_156_DeerFeed_0 ; list of all single vectorlists in this
 DW 0

AnimList_156_DeerFeed_0:
 DB $01, +$45*BLOW_UP_157_DeerFeed, -$31*BLOW_UP_157_DeerFeed ; sync and move to y, x
 DB $FF, +$00*BLOW_UP_157_DeerFeed, +$15*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, -$09*BLOW_UP_157_DeerFeed, +$13*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, -$18*BLOW_UP_157_DeerFeed, +$1A*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, -$08*BLOW_UP_157_DeerFeed, +$11*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, +$02*BLOW_UP_157_DeerFeed, +$34*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, -$04*BLOW_UP_157_DeerFeed, +$0B*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, -$06*BLOW_UP_157_DeerFeed, +$02*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, -$06*BLOW_UP_157_DeerFeed, -$02*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, -$07*BLOW_UP_157_DeerFeed, -$0E*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, +$02*BLOW_UP_157_DeerFeed, -$2A*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $01, +$09*BLOW_UP_157_DeerFeed, +$29*BLOW_UP_157_DeerFeed ; sync and move to y, x
 DB $FF, -$07*BLOW_UP_157_DeerFeed, +$22*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, +$04*BLOW_UP_157_DeerFeed, +$14*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, -$05*BLOW_UP_157_DeerFeed, +$07*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, -$06*BLOW_UP_157_DeerFeed, -$03*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, -$04*BLOW_UP_157_DeerFeed, -$0A*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, +$01*BLOW_UP_157_DeerFeed, -$2A*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, +$0F*BLOW_UP_157_DeerFeed, -$28*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, +$29*BLOW_UP_157_DeerFeed, -$2C*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, +$08*BLOW_UP_157_DeerFeed, -$14*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, +$07*BLOW_UP_157_DeerFeed, -$05*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $01, +$3F*BLOW_UP_157_DeerFeed, -$3E*BLOW_UP_157_DeerFeed ; sync and move to y, x
 DB $FF, +$03*BLOW_UP_157_DeerFeed, +$06*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, +$03*BLOW_UP_157_DeerFeed, +$07*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $00, -$19*BLOW_UP_157_DeerFeed, -$0A*BLOW_UP_157_DeerFeed ; mode, y, x
 DB $FF, +$06*BLOW_UP_157_DeerFeed, +$05*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, -$03*BLOW_UP_157_DeerFeed, +$08*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, -$27*BLOW_UP_157_DeerFeed, +$2A*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, -$15*BLOW_UP_157_DeerFeed, +$37*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, -$01*BLOW_UP_157_DeerFeed, +$21*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, -$08*BLOW_UP_157_DeerFeed, +$04*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, -$18*BLOW_UP_157_DeerFeed, +$04*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $01, -$2E*BLOW_UP_157_DeerFeed, +$57*BLOW_UP_157_DeerFeed ; sync and move to y, x
 DB $00, +$00*BLOW_UP_157_DeerFeed, +$05*BLOW_UP_157_DeerFeed ; additional sync move to y, x
 DB $FF, -$06*BLOW_UP_157_DeerFeed, +$07*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, -$0D*BLOW_UP_157_DeerFeed, +$00*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, +$00*BLOW_UP_157_DeerFeed, -$10*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, +$05*BLOW_UP_157_DeerFeed, -$0B*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, -$0A*BLOW_UP_157_DeerFeed, -$57*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, +$11*BLOW_UP_157_DeerFeed, -$3D*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, -$01*BLOW_UP_157_DeerFeed, -$19*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, +$07*BLOW_UP_157_DeerFeed, +$00*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, +$0F*BLOW_UP_157_DeerFeed, +$0C*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, +$1C*BLOW_UP_157_DeerFeed, +$03*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $FF, +$30*BLOW_UP_157_DeerFeed, +$1B*BLOW_UP_157_DeerFeed ; draw, y, x
 DB $02 ; endmarker 
