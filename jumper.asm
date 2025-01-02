
;bug wenn animated tile is ganz links clipped!

;DEEP_MACRO_USAGE = 1
USE_COMPILED        =        1 

; steps for a game
;
; a) animated tiles
; b) main character
; c) other sprites
; d) collision detection
; e) gravity
; f) sound (music & noise)

; * change grid to 10x10
; position of grid non tile dependend

; reuse of clipped todo:
; 3 vlists
; 1 clipped horizontal
; 1 clipped vertical
; one result (+corner)
;
; * simple clip for rectangle
;
; more performant tile list
;
; * for move to pos, use as "variable" the scale, NOT the strength!
; only possible if both "abs" pos < 64
; otherwise not feasable, since strength of x y is in general different
; 
; might be doable using a translation table, since there are only 15 different x/y positions (grid lower left points)
; using the the "greater" strength "127" and than the scale as index for the lower strength
; thus 15 different scale values and for each scale 15 "lower" values
; that would only need 15*15 bytes, a fast lookup table
; and save cycles on every positioning!
; for that to work I have to do TWO moves for eac position
; - one for coarse
; - one for fine
; positions

; * double / quadrouble
; tile lists
; which use always double strength to draw
; clipping mus respect that

; * all vectors have "double strength
; only when clipping, all coordinates get halfed

;
; simple format -> also for non simple format -> faster?

;double all strength
;do multi tiles, when not clipped

;Level definition:
;startLine0
; dw #startNextLine1
; db tile1, widthInCoords, widthInPixel (max 256 = 16 tiles)
; db tile2, widthInCoords, widthInPixel (max 256 = 16 tiles)
; db -1 ; end of line
;...
;startLine1
; dw #startNextLine2
; db tile1, widthInCoords, widthInPixel (max 256 = 16 tiles)
; db tile2, widthInCoords, widthInPixel (max 256 = 16 tiles)
; db -1 ; end of line
; ...

;***************************************************************************
; DEFINE SECTION
;***************************************************************************
; include line ->                     include  "varsAndRAM.i"
; load vectrex bios routine definitions
; include line ->                     INCLUDE  "VECTREX.I"                  ; vectrex function includes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains includes for vectrex BIOS functions and variables      ;
; it was written by Bruce Tomlin, slighte changed by Malban                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE_I           equ      1 

Vec_Snd_Shadow      EQU      $C800                        ;Shadow of sound chip registers (15 bytes) 
Vec_Btn_State       EQU      $C80F                        ;Current state of all joystick buttons 
Vec_Prev_Btns       EQU      $C810                        ;Previous state of all joystick buttons 
Vec_Buttons         EQU      $C811                        ;Current toggle state of all buttons 
Vec_Button_1_1      EQU      $C812                        ;Current toggle state of stick 1 button 1 
Vec_Button_1_2      EQU      $C813                        ;Current toggle state of stick 1 button 2 
Vec_Button_1_3      EQU      $C814                        ;Current toggle state of stick 1 button 3 
Vec_Button_1_4      EQU      $C815                        ;Current toggle state of stick 1 button 4 
Vec_Button_2_1      EQU      $C816                        ;Current toggle state of stick 2 button 1 
Vec_Button_2_2      EQU      $C817                        ;Current toggle state of stick 2 button 2 
Vec_Button_2_3      EQU      $C818                        ;Current toggle state of stick 2 button 3 
Vec_Button_2_4      EQU      $C819                        ;Current toggle state of stick 2 button 4 
Vec_Joy_Resltn      EQU      $C81A                        ;Joystick A/D resolution ($80=min $00=max) 
Vec_Joy_1_X         EQU      $C81B                        ;Joystick 1 left/right 
Vec_Joy_1_Y         EQU      $C81C                        ;Joystick 1 up/down 
Vec_Joy_2_X         EQU      $C81D                        ;Joystick 2 left/right 
Vec_Joy_2_Y         EQU      $C81E                        ;Joystick 2 up/down 
Vec_Joy_Mux         EQU      $C81F                        ;Joystick enable/mux flags (4 bytes) 
Vec_Joy_Mux_1_X     EQU      $C81F                        ;Joystick 1 X enable/mux flag (=1) 
Vec_Joy_Mux_1_Y     EQU      $C820                        ;Joystick 1 Y enable/mux flag (=3) 
Vec_Joy_Mux_2_X     EQU      $C821                        ;Joystick 2 X enable/mux flag (=5) 
Vec_Joy_Mux_2_Y     EQU      $C822                        ;Joystick 2 Y enable/mux flag (=7) 
Vec_Misc_Count      EQU      $C823                        ;Misc counter/flag byte, zero when not in use 
Vec_0Ref_Enable     EQU      $C824                        ;Check0Ref enable flag 
Vec_Loop_Count      EQU      $C825                        ;Loop counter word (incremented in Wait_Recal) 
Vec_Brightness      EQU      $C827                        ;Default brightness 
Vec_Dot_Dwell       EQU      $C828                        ;Dot dwell time? 
Vec_Pattern         EQU      $C829                        ;Dot pattern (bits) 
Vec_Text_HW         EQU      $C82A                        ;Default text height and width 
Vec_Text_Height     EQU      $C82A                        ;Default text height 
Vec_Text_Width      EQU      $C82B                        ;Default text width 
Vec_Str_Ptr         EQU      $C82C                        ;Temporary string pointer for Print_Str 
Vec_Counters        EQU      $C82E                        ;Six bytes of counters 
Vec_Counter_1       EQU      $C82E                        ;First counter byte 
Vec_Counter_2       EQU      $C82F                        ;Second counter byte 
Vec_Counter_3       EQU      $C830                        ;Third counter byte 
Vec_Counter_4       EQU      $C831                        ;Fourth counter byte 
Vec_Counter_5       EQU      $C832                        ;Fifth counter byte 
Vec_Counter_6       EQU      $C833                        ;Sixth counter byte 
Vec_RiseRun_Tmp     EQU      $C834                        ;Temp storage word for rise/run 
Vec_Angle           EQU      $C836                        ;Angle for rise/run and rotation calculations 
Vec_Run_Index       EQU      $C837                        ;Index pair for run 
*                       $C839                             ;Pointer to copyright string during startup
Vec_Rise_Index      EQU      $C839                        ;Index pair for rise 
*                       $C83B                             ;High score cold-start flag (=0 if valid)
Vec_RiseRun_Len     EQU      $C83B                        ;length for rise/run 
*                       $C83C                             ;temp byte
Vec_Rfrsh           EQU      $C83D                        ;Refresh time (divided by 1.5MHz) 
Vec_Rfrsh_lo        EQU      $C83D                        ;Refresh time low byte 
Vec_Rfrsh_hi        EQU      $C83E                        ;Refresh time high byte 
Vec_Music_Work      EQU      $C83F                        ;Music work buffer (14 bytes, backwards?) 
Vec_Music_Wk_A      EQU      $C842                        ; register 10 
*                       $C843                             ;        register 9
*                       $C844                             ;        register 8
Vec_Music_Wk_7      EQU      $C845                        ; register 7 
Vec_Music_Wk_6      EQU      $C846                        ; register 6 
Vec_Music_Wk_5      EQU      $C847                        ; register 5 
*                       $C848                             ;        register 4
*                       $C849                             ;        register 3
*                       $C84A                             ;        register 2
Vec_Music_Wk_1      EQU      $C84B                        ; register 1 
*                       $C84C                             ;        register 0
Vec_Freq_Table      EQU      $C84D                        ;Pointer to note-to-frequency table (normally $FC8D) 
Vec_Max_Players     EQU      $C84F                        ;Maximum number of players for Select_Game 
Vec_Max_Games       EQU      $C850                        ;Maximum number of games for Select_Game 
Vec_ADSR_Table      EQU      $C84F                        ;Storage for first music header word (ADSR table) 
Vec_Twang_Table     EQU      $C851                        ;Storage for second music header word ('twang' table) 
Vec_Music_Ptr       EQU      $C853                        ;Music data pointer 
Vec_Expl_ChanA      EQU      $C853                        ;Used by Explosion_Snd - bit for first channel used? 
Vec_Expl_Chans      EQU      $C854                        ;Used by Explosion_Snd - bits for all channels used? 
Vec_Music_Chan      EQU      $C855                        ;Current sound channel number for Init_Music 
Vec_Music_Flag      EQU      $C856                        ;Music active flag ($00=off $01=start $80=on) 
Vec_Duration        EQU      $C857                        ;Duration counter for Init_Music 
Vec_Music_Twang     EQU      $C858                        ;3 word 'twang' table used by Init_Music 
Vec_Expl_1          EQU      $C858                        ;Four bytes copied from Explosion_Snd's U-reg parameters 
Vec_Expl_2          EQU      $C859                        ; 
Vec_Expl_3          EQU      $C85A                        ; 
Vec_Expl_4          EQU      $C85B                        ; 
Vec_Expl_Chan       EQU      $C85C                        ;Used by Explosion_Snd - channel number in use? 
Vec_Expl_ChanB      EQU      $C85D                        ;Used by Explosion_Snd - bit for second channel used? 
Vec_ADSR_Timers     EQU      $C85E                        ;ADSR timers for each sound channel (3 bytes) 
Vec_Music_Freq      EQU      $C861                        ;Storage for base frequency of each channel (3 words) 
*                       $C85E                             ;Scratch 'score' storage for Display_Option (7 bytes)
Vec_Expl_Flag       EQU      $C867                        ;Explosion_Snd initialization flag? 
*               $C868...$C876                             ;Unused?
Vec_Expl_Timer      EQU      $C877                        ;Used by Explosion_Snd 
*                       $C878                             ;Unused?
Vec_Num_Players     EQU      $C879                        ;Number of players selected in Select_Game 
Vec_Num_Game        EQU      $C87A                        ;Game number selected in Select_Game 
Vec_Seed_Ptr        EQU      $C87B                        ;Pointer to 3-byte random number seed (=$C87D) 
Vec_Random_Seed     EQU      $C87D                        ;Default 3-byte random number seed 
                                                          ; 
*    $C880 - $CBEA is user RAM                            ;
                                                          ; 
Vec_Default_Stk     EQU      $CBEA                        ;Default top-of-stack 
Vec_High_Score      EQU      $CBEB                        ;High score storage (7 bytes) 
Vec_SWI3_Vector     EQU      $CBF2                        ;SWI2/SWI3 interrupt vector (3 bytes) 
Vec_SWI2_Vector     EQU      $CBF2                        ;SWI2/SWI3 interrupt vector (3 bytes) 
Vec_FIRQ_Vector     EQU      $CBF5                        ;FIRQ interrupt vector (3 bytes) 
Vec_IRQ_Vector      EQU      $CBF8                        ;IRQ interrupt vector (3 bytes) 
Vec_SWI_Vector      EQU      $CBFB                        ;SWI/NMI interrupt vector (3 bytes) 
Vec_NMI_Vector      EQU      $CBFB                        ;SWI/NMI interrupt vector (3 bytes) 
Vec_Cold_Flag       EQU      $CBFE                        ;Cold start flag (warm start if = $7321) 
                                                          ; 
VIA_port_b          EQU      $D000                        ;VIA port B data I/O register 
*       0 sample/hold (0=enable  mux 1=disable mux)
*       1 mux sel 0
*       2 mux sel 1
*       3 sound BC1
*       4 sound BDIR
*       5 comparator input
*       6 external device (slot pin 35) initialized to input
*       7 /RAMP
VIA_port_a          EQU      $D001                        ;VIA port A data I/O register (handshaking) 
VIA_DDR_b           EQU      $D002                        ;VIA port B data direction register (0=input 1=output) 
VIA_DDR_a           EQU      $D003                        ;VIA port A data direction register (0=input 1=output) 
VIA_t1_cnt_lo       EQU      $D004                        ;VIA timer 1 count register lo (scale factor) 
VIA_t1_cnt_hi       EQU      $D005                        ;VIA timer 1 count register hi 
VIA_t1_lch_lo       EQU      $D006                        ;VIA timer 1 latch register lo 
VIA_t1_lch_hi       EQU      $D007                        ;VIA timer 1 latch register hi 
VIA_t2_lo           EQU      $D008                        ;VIA timer 2 count/latch register lo (refresh) 
VIA_t2_hi           EQU      $D009                        ;VIA timer 2 count/latch register hi 
VIA_shift_reg       EQU      $D00A                        ;VIA shift register 
VIA_aux_cntl        EQU      $D00B                        ;VIA auxiliary control register 
*       0 PA latch enable
*       1 PB latch enable
*       2 \                     110=output to CB2 under control of phase 2 clock
*       3  > shift register control     (110 is the only mode used by the Vectrex ROM)
*       4 /
*       5 0=t2 one shot                 1=t2 free running
*       6 0=t1 one shot                 1=t1 free running
*       7 0=t1 disable PB7 output       1=t1 enable PB7 output
VIA_cntl            EQU      $D00C                        ;VIA control register 
*       0 CA1 control     CA1 -> SW7    0=IRQ on low 1=IRQ on high
*       1 \
*       2  > CA2 control  CA2 -> /ZERO  110=low 111=high
*       3 /
*       4 CB1 control     CB1 -> NC     0=IRQ on low 1=IRQ on high
*       5 \
*       6  > CB2 control  CB2 -> /BLANK 110=low 111=high
*       7 /
VIA_int_flags       EQU      $D00D                        ;VIA interrupt flags register 
*               bit                             cleared by
*       0 CA2 interrupt flag            reading or writing port A I/O
*       1 CA1 interrupt flag            reading or writing port A I/O
*       2 shift register interrupt flag reading or writing shift register
*       3 CB2 interrupt flag            reading or writing port B I/O
*       4 CB1 interrupt flag            reading or writing port A I/O
*       5 timer 2 interrupt flag        read t2 low or write t2 high
*       6 timer 1 interrupt flag        read t1 count low or write t1 high
*       7 IRQ status flag               write logic 0 to IER or IFR bit
VIA_int_enable      EQU      $D00E                        ;VIA interrupt enable register 
*       0 CA2 interrupt enable
*       1 CA1 interrupt enable
*       2 shift register interrupt enable
*       3 CB2 interrupt enable
*       4 CB1 interrupt enable
*       5 timer 2 interrupt enable
*       6 timer 1 interrupt enable
*       7 IER set/clear control
VIA_port_a_nohs     EQU      $D00F                        ;VIA port A data I/O register (no handshaking) 

Cold_Start          EQU      $F000                        ; 
Warm_Start          EQU      $F06C                        ; 
Init_VIA            EQU      $F14C                        ; 
Init_OS_RAM         EQU      $F164                        ; 
Init_OS             EQU      $F18B                        ; 
Wait_Recal          EQU      $F192                        ; 
Set_Refresh         EQU      $F1A2                        ; 
DP_to_D0            EQU      $F1AA                        ; 
DP_to_C8            EQU      $F1AF                        ; 
Read_Btns_Mask      EQU      $F1B4                        ; 
Read_Btns           EQU      $F1BA                        ; 
Joy_Analog          EQU      $F1F5                        ; 
Joy_Digital         EQU      $F1F8                        ; 
Sound_Byte          EQU      $F256                        ; 
Sound_Byte_x        EQU      $F259                        ; 
Sound_Byte_raw      EQU      $F25B                        ; 
Clear_Sound         EQU      $F272                        ; 
Sound_Bytes         EQU      $F27D                        ; 
Sound_Bytes_x       EQU      $F284                        ; 
Do_Sound            EQU      $F289                        ; 
Do_Sound_x          EQU      $F28C                        ; 
Intensity_1F        EQU      $F29D                        ; 
Intensity_3F        EQU      $F2A1                        ; 
Intensity_5F        EQU      $F2A5                        ; 
Intensity_7F        EQU      $F2A9                        ; 
Intensity_a         EQU      $F2AB                        ; 
Dot_ix_b            EQU      $F2BE                        ; 
Dot_ix              EQU      $F2C1                        ; 
Dot_d               EQU      $F2C3                        ; 
Dot_here            EQU      $F2C5                        ; 
Dot_List            EQU      $F2D5                        ; 
Dot_List_Reset      EQU      $F2DE                        ; 
Recalibrate         EQU      $F2E6                        ; 
Moveto_x_7F         EQU      $F2F2                        ; 
Moveto_d_7F         EQU      $F2FC                        ; 
Moveto_ix_FF        EQU      $F308                        ; 
Moveto_ix_7F        EQU      $F30C                        ; 
Moveto_ix_a         EQU      $F30E                        ; 
Moveto_ix           EQU      $F310                        ; 
Moveto_d            EQU      $F312                        ; 
Reset0Ref_D0        EQU      $F34A                        ; 
Check0Ref           EQU      $F34F                        ; 
Reset0Ref           EQU      $F354                        ; 
Reset_Pen           EQU      $F35B                        ; 
Reset0Int           EQU      $F36B                        ; 
Print_Str_hwyx      EQU      $F373                        ; 
Print_Str_yx        EQU      $F378                        ; 
Print_Str_d         EQU      $F37A                        ; 
Print_List_hw       EQU      $F385                        ; 
Print_List          EQU      $F38A                        ; 
Print_List_chk      EQU      $F38C                        ; 
Print_Ships_x       EQU      $F391                        ; 
Print_Ships         EQU      $F393                        ; 
Mov_Draw_VLc_a      EQU      $F3AD                        ;count y x y x ... 
Mov_Draw_VL_b       EQU      $F3B1                        ;y x y x ... 
Mov_Draw_VLcs       EQU      $F3B5                        ;count scale y x y x ... 
Mov_Draw_VL_ab      EQU      $F3B7                        ;y x y x ... 
Mov_Draw_VL_a       EQU      $F3B9                        ;y x y x ... 
Mov_Draw_VL         EQU      $F3BC                        ;y x y x ... 
Mov_Draw_VL_d       EQU      $F3BE                        ;y x y x ... 
Draw_VLc            EQU      $F3CE                        ;count y x y x ... 
Draw_VL_b           EQU      $F3D2                        ;y x y x ... 
Draw_VLcs           EQU      $F3D6                        ;count scale y x y x ... 
Draw_VL_ab          EQU      $F3D8                        ;y x y x ... 
Draw_VL_a           EQU      $F3DA                        ;y x y x ... 
Draw_VL             EQU      $F3DD                        ;y x y x ... 
Draw_Line_d         EQU      $F3DF                        ;y x y x ... 
Draw_VLp_FF         EQU      $F404                        ;pattern y x pattern y x ... $01 
Draw_VLp_7F         EQU      $F408                        ;pattern y x pattern y x ... $01 
Draw_VLp_scale      EQU      $F40C                        ;scale pattern y x pattern y x ... $01 
Draw_VLp_b          EQU      $F40E                        ;pattern y x pattern y x ... $01 
Draw_VLp            EQU      $F410                        ;pattern y x pattern y x ... $01 
Draw_Pat_VL_a       EQU      $F434                        ;y x y x ... 
Draw_Pat_VL         EQU      $F437                        ;y x y x ... 
Draw_Pat_VL_d       EQU      $F439                        ;y x y x ... 
Draw_VL_mode        EQU      $F46E                        ;mode y x mode y x ... $01 
Print_Str           EQU      $F495                        ; 
Random_3            EQU      $F511                        ; 
Random              EQU      $F517                        ; 
Init_Music_Buf      EQU      $F533                        ; 
Clear_x_b           EQU      $F53F                        ; 
Clear_C8_RAM        EQU      $F542                        ;never used by GCE carts? 
Clear_x_256         EQU      $F545                        ; 
Clear_x_d           EQU      $F548                        ; 
Clear_x_b_80        EQU      $F550                        ; 
Clear_x_b_a         EQU      $F552                        ; 
Dec_3_Counters      EQU      $F55A                        ; 
Dec_6_Counters      EQU      $F55E                        ; 
Dec_Counters        EQU      $F563                        ; 
Delay_3             EQU      $F56D                        ;30 cycles 
Delay_2             EQU      $F571                        ;25 cycles 
Delay_1             EQU      $F575                        ;20 cycles 
Delay_0             EQU      $F579                        ;12 cycles 
Delay_b             EQU      $F57A                        ;5*B + 10 cycles 
Delay_RTS           EQU      $F57D                        ;5 cycles 
Bitmask_a           EQU      $F57E                        ; 
Abs_a_b             EQU      $F584                        ; 
Abs_b               EQU      $F58B                        ; 
Rise_Run_Angle      EQU      $F593                        ; 
Get_Rise_Idx        EQU      $F5D9                        ; 
Get_Run_Idx         EQU      $F5DB                        ; 
Get_Rise_Run        EQU      $F5EF                        ; 
Rise_Run_X          EQU      $F5FF                        ; 
Rise_Run_Y          EQU      $F601                        ; 
Rise_Run_Len        EQU      $F603                        ; 

Rot_VL_ab           EQU      $F610                        ; 
Rot_VL              EQU      $F616                        ; 
Rot_VL_Mode         EQU      $F61F                        ; 
Rot_VL_M_dft        EQU      $F62B                        ; 
;Rot_VL_dft      EQU     $F637   ;

;Rot_VL_ab       EQU     $F610   ;
;Rot_VL          EQU     $F616   ;
;Rot_VL_Mode_a   EQU     $F61F   ;
;Rot_VL_Mode     EQU     $F62B   ;
;Rot_VL_dft      EQU     $F637   ;

Xform_Run_a         EQU      $F65B                        ; 
Xform_Run           EQU      $F65D                        ; 
Xform_Rise_a        EQU      $F661                        ; 
Xform_Rise          EQU      $F663                        ; 
Move_Mem_a_1        EQU      $F67F                        ; 
Move_Mem_a          EQU      $F683                        ; 
Init_Music_chk      EQU      $F687                        ; 
Init_Music          EQU      $F68D                        ; 
Init_Music_x        EQU      $F692                        ; 
Select_Game         EQU      $F7A9                        ; 
Clear_Score         EQU      $F84F                        ; 
Add_Score_a         EQU      $F85E                        ; 
Add_Score_d         EQU      $F87C                        ; 
Strip_Zeros         EQU      $F8B7                        ; 
Compare_Score       EQU      $F8C7                        ; 
New_High_Score      EQU      $F8D8                        ; 
Obj_Will_Hit_u      EQU      $F8E5                        ; 
Obj_Will_Hit        EQU      $F8F3                        ; 
Obj_Hit             EQU      $F8FF                        ; 
Explosion_Snd       EQU      $F92E                        ; 
Draw_Grid_VL        EQU      $FF9F                        ; 
                                                          ; 
music1              EQU      $FD0D                        ; 
music2              EQU      $FD1D                        ; 
music3              EQU      $FD81                        ; 
music4              EQU      $FDD3                        ; 
music5              EQU      $FE38                        ; 
music6              EQU      $FE76                        ; 
music7              EQU      $FEC6                        ; 
music8              EQU      $FEF8                        ; 
music9              EQU      $FF26                        ; 
musica              EQU      $FF44                        ; 
musicb              EQU      $FF62                        ; 
musicc              EQU      $FF7A                        ; 
musicd              EQU      $FF8F                        ; 
Char_Table          EQU      $F9F4 
Char_Table_End      EQU      $FBD4 

; include line ->                     INCLUDE  "MAKROS.I"                   ; vectrex function includes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains makro definitions of vectrex BIOS functions, these are ;
; sometimes exact clones of the BIOS functions                              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MACRO_I             equ      1 
; most of these macros are taken from the ROM to avoid
; all those JSR / RTS, in order to save time (over space)
;
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************
;***************************************************************************

;***************************************************************************

;***************************************************************************
; convenient macros as seen in:
; see: http://www.sbprojects.com/sbasm/6809.php
;***************************************************************************
; Accumulator D compound instructions
; Set and Clear instructions
; Increment and decrement instructions
;Stack instructions
; Please note that PSHU and PULU are not included as compound instructions. 
; This is to avoid confusion with the original PSHU and PULU instructions, 
; which require you to specify the registers to be pushed or pulled.
; Transfer and miscellaneous instructions

;***************************************************************************
;***************************************************************************
;***************************************************************************

;***************************************************************************
; entry:   D has clip_counter
;          v0 is set
; result: v1 = y1, x1
;         v2 = y2, x2
;         get calculated
; LEFT RIGHT
; this one assumes X0 is either 64, 32 or 16
; divide is pretty fast than...

;     ds       _pat1,1 
;     ds       _y1,1 
;     ds       _x1,1 
;     ds       _pat2,1 
;     ds       _y2,1 
;     ds       _x2,1 

;***************************************************************************
; divides D by tmp1, result in B
; uses divide_tmp as storage
; only 8 bit in tmp1, but must be manually poked to tmp1 + 1
; sign is correctly handled
;
; can probably be optimized like hell
; perhaps only nearing the result
; using 2 shifts and a plus
; might be worth a try,
; see vectrex emulator for algorithm...
; could be implemented with a tabel, which in turn
; could be caclulated on the fly... (upon startup)
;
; this makro divides exact, but slow

;***************************************************************************
; entry:   D has clip_counter
;          v0 is set
; result: v1 = y1, x1
;         v2 = y2, x2
;         get calculated
;
; this one assumes X0 is either 64, 32 or 16
; divide is pretty fast than...

;     ds       _pat1,1 
;     ds       _y1,1 
;     ds       _x1,1 
;     ds       _pat2,1 
;     ds       _y2,1 
;     ds       _x2,1 

;***************************************************************************
; entry:   D has clip_counter - in vertical direction!
;          clip_test is set
;          v0 is set
; result: v1 = y1, x1
;         v2 = y2, x2
;         get calculated
;
; this one assumes X0 is either 64, 32 or 16
; divide is pretty fast than...
; include line ->                     INCLUDE  "MY_MAKROS.I"                ; vectrex function includes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this file contains private makros, some are taken from the BIOS of vectrex;
; and changed slightly to be more speedy, other were written alltogether by ;
; me, some of these are even obsolete... but all should be in a working     ;
; state                                                                     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
MY_MAKROS_I         equ      1 
;**************************************************************************
;
;
; following are some 'private' makro definitions
;
; some heavily optimized for speed :-(
; needs: DP = D0
;***************************************************************************
;***************************************************************************
; reset integrators
;***************************************************************************

; prints the numbers in a and b at a location given
; prints in hex

;***************************************************************************
; Variable / RAM SECTION
;***************************************************************************
; insert your variables (RAM usage) in the BSS section
; user RAM starts at $c880 
                    BSS      
                    org      sample_ram 
c_bigCounter        ds       2 
simStage            ds       1 
last_joy_y          ds       1                            ; and Y, for checking, we don't want an autorun feature... 
last_joy_x          ds       1                            ; last joystick position X, 
yCoarse             ds       1                            ; position in level, that is the upper left corner 
xCoarse             ds       1                            ; position in level, that is the upper left corner 
xCoarseCheck        ds       1 

yFine               ds       1                            ; fine "pixel" for scrolling 
xFine               ds       1                            ; size depends on tile map definition 
currentLevel        ds       2 
levelYSize          ds       1 
levelXSize          ds       1 
displayPosY         ds       1                            ; position where the next tile is printed at 
displayPosX         ds       1 
tmp_debug           ds       6 
speedy              ds       1 
speedx              ds       1 
anay                ds       1 
anax                ds       1 

counter0            ds       1 
counter1            ds       1 
counter2            ds       1 
counter3            ds       1 
counter4            ds       1 
counter5            ds       1 
counter6            ds       1 
counter7            ds       1 

animationDelay      ds       1 

; lookaHead buffers
nextDisplayPos      ds       0 
nextDisplayPosY     ds       1                            ; position where the next tile is printed at, used by look ahead 
nextDisplayPosX     ds       1 

endVerticalcompare  ds       1 

; clipping
divide_tmp          ds       2 
jtmp1               ds       2 
v0: 
y0:                 ds       1 
x0:                 ds       1 
v1: 
y1:                 ds       1 
x1:                 ds       1 
v2: 
y2:                 ds       1 
x2:                 ds       1 

                    struct   CLIP_VECTORS 
                    ds       _pat1,1 
                    ds       _y1,1 
                    ds       _x1,1 
                    ds       _pat2,1 
                    ds       _y2,1 
                    ds       _x2,1 
                    end struct 

scrollReset         ds       1                            ; "round" counter of scroll text -> if 1 (or higher) the scrolltext has been fully shown 
neggi:              ds       1 
clip_test:          ds       2 
clip_line_counter:  ds       1 
clip_counter:       ds       2 
clip_pattern:       ds       2 
firstVector         ds       1 
BORDER              ds       2 
is_first_letter     ds       1 
do_another_letter   ds       1 

topclip 
bottomclip          ds       2 
rightclip 
leftclip            ds       2 

current_type        ds       1 

verticalBuffer      ds       1 
horizontalLeftBuffer  ds     1 
horizontalRightBuffer  ds    1 

clipped_vector_vertical_type  ds  1 
clipped_vector_vertical:  DS  20*3                        ; maximum 20 vectors to clip - also used as buffer 
clipped_vector_left:  DS     20*3                         ; maximum 20 vectors to clip - also used as buffer 
clipped_vector_final 
clipped_vector_right:  DS    20*3                         ; maximum 20 vectors to clip - also used as buffer 
clip_end            ds       0 

; the following values determine the "strength" of the 
; maximum move for the grid to be build
; the size of the grid should always be chosen with maximum strength and manipulated via scale
; max strength in anything is ALWAYS preferable to larger scale!
VERTICAL_MAX        =        127 
VERTICAL_MIN        =        -127 
HORIZONTAL_MAX      =        127 
HORIZONTAL_MIN      =        -127 

SCALE_MOVE          EQU      100 
SCALE_VLIST         EQU      11 

; determines the number of tiles on screen
FULL_TILES_HORIZONTAL  =     12 
FULL_TILES_VERTICAL  =       12 

GRID_HEIGHT         =        (VERTICAL_MAX-VERTICAL_MIN) 
GRID_WIDTH          =        (HORIZONTAL_MAX-HORIZONTAL_MIN) 

GRID_WIDTH          =        254 

ALL_TILES_HORIZONTAL  =      (FULL_TILES_HORIZONTAL+2)    ; scrolling allows on each side a partial tile 
ALL_TILES_VERTICAL  =        (FULL_TILES_VERTICAL+2)      ; scrolling allows on each side a partial tile 

; size of tiles in "pixel", size here means in relation to position in grid
; a "pixel" is a 1 step move in the "SCALE_MOVE" scale
; the "hardware" size of a tile is determinded by the scale "SCALE_VLIST", which should be much much smaller than 
; the move scale.
; The relation between the two is experimentally determined!
; e.g. 254 / 12 = 21 => tile width in scales
;
; these are the values added by a single tile to the position
; exact should be whats commented out
; 16 for easier calc
TILE_WIDTH          =        (GRID_WIDTH / ALL_TILES_HORIZONTAL) 
TILE_HEIGHT         =        (GRID_HEIGHT / ALL_TILES_VERTICAL) 

STEP_HORIZONTAL_TILE_IN_PIXEL  =  (128/TILE_WIDTH) 
STEP_VERTICAL_TILE_IN_PIXEL  =  (128/TILE_WIDTH) 

; start pos of draw is uper left corner
; in cartesian minX, maxY
START_POS_VERTICAL  =        ((TILE_HEIGHT*FULL_TILES_VERTICAL)/2) 
START_POS_HORIZONTAL  =      (-((TILE_WIDTH*FULL_TILES_HORIZONTAL)/2)) 
START_POS           =        (hi(START_POS_VERTICAL*256)*256) + lo(START_POS_HORIZONTAL) 

END_POS_VERTICAL    =        START_POS_VERTICAL - (FULL_TILES_VERTICAL*TILE_HEIGHT) 
END_POS_HORIZONTAL  =        START_POS_HORIZONTAL + (FULL_TILES_HORIZONTAL*TILE_WIDTH) 

END_POS_VERTICAL_TEST  =     END_POS_VERTICAL - TILE_HEIGHT 
END_POS_HORIZONTAL_TEST  =   END_POS_HORIZONTAL + TILE_WIDTH 

FINE_MAX_VERTICAL   equ      TILE_HEIGHT 
FINE_MAX_HORIZONTAL  equ     TILE_WIDTH 

TYPE_SIMPLE         equ      0                            ; can do simple clipping 
TYPE_EXPONENTIAL    equ      1                            ; no easy clipping 

; following not done!
TYPE_CONTINUE_RESET  equ     2                            ; if = continue is possible after this tile, position is = to next start point 
TYPE_CONTINUE_HERE  equ      4                            ; if = continue is possible, leaving at some arbitrary point 

TYPE_DOUBLE_SCALE   equ      8                            ; if = continue is possible, leaving at some arbitrary point 
TYPE_QUAD_SCALE     equ      16                           ; if = continue is possible, leaving at some arbitrary point 
;***************************************************************************
; CODE SECTION
;***************************************************************************
                    code     
; here the cartridge program starts off

initJumper 
                    ldd      #4*TEN_SECONDS               ; ONE_MINUTE ; ten seconds 
                    std      bigCounter 

                    ldd      #0 
                    std      c_bigCounter 
                    sta      simStage 
                    lda      #1                           ; default speed ONE 
                    sta      speedy 
                    sta      speedx 
                    ldx      #level0 
                    stx      currentLevel 
                    ldd      2,x 

                    ldd      #14*256 

                    std      yCoarse 
                    ldd      #0 
                    std      yFine 

                    ldy      #level0 
                    ldd      ,y 
                    std      levelYSize 

; adjust fine
                    lda      #STEP_HORIZONTAL_TILE_IN_PIXEL 
                    ldb      xFine 
                    mul      
                    std      rightclip 

                    lda      #7 
                    sta      animationDelay 

                    lda      #5                           ; the number of animation steps for tiles which use counter number 4 
                    sta      counter4 
                    rts      


playJumper 

                    ldd      bigCounter 
                    subd     #1 
                    std      bigCounter 
                    bne      notFinishedJumper 
                    clr      demoRunningFlag 
notFinishedJumper 
                    ldd      c_bigCounter 
                    addd     #1 
                    std      c_bigCounter 

                    dec      animationDelay 
                    bpl      counter4Ok 

                    lda      #4 
                    sta      animationDelay 

                    dec      counter4 
                    bpl      counter4Ok 
                    lda      #5                           ; the number of animation steps for tiles which use counter number 4 
                    sta      counter4 
counter4Ok 

                    jsr      handleMove 
                    jsr      Reset_Pen 
                    JSR      Intensity_5F                 ; Sets the intensity of the vector beam to $5f 
                    jsr      displayFixedWorld_Clipped 

                    LDB      #$CC 
                    STB      <VIA_cntl                    ;/BLANK low and /ZERO low 

                    rts      


simAnalag 
                    lda      simStage 
                    lsla     
                    lsla     
                    ldx      #simStages 
                    leax     a,x 
                    ldd      ,x 
                    cmpd     #$ffff 
                    bne      normalStage 
                    clr      simStage 
                    ldd      #0 
                    std      c_bigCounter 
                    ldx      #simStages 
normalStage 

                    ldd      c_bigCounter 
                    cmpd     ,x                           ; 
                    blo      keepStage 
                    inc      simStage 
                    ldd      #0 
                    std      c_bigCounter 
                    leax     4,x 

keepStage 
                    ldd      2,x 
                    sta      Vec_Joy_1_Y 
                    stb      Vec_Joy_1_X 
                    rts      

 
simStages 
; upTo, ypos,xpos
                    dw       50, (0)*256 + 0              ; 
                    dw       150, (30)*256 + 0            ; 
                    dw       15, (60)*256 + 0             ; 
                    dw       50, (0)*256 + 20             ; 
                    dw       50, (0)*256 + 25             ; 
                    dw       50, (0)*256 + 50             ; 
                    dw       50, (0)*256 + 60             ; 
                    dw       100, (0)*256 + 10            ; 
; end of MERRY
                    dw       220, (-20)*256 + -20         ; 
                    dw       250, (0)*256 + 30            ; 
                    dw       200, (0)*256 + 20            ; 
                    dw       100, (0)*256 + 60            ; 

                    dw       100, (100)*256 + -100        ; 

                    dw       200, (00)*256 + 60           ; 

                    dw       120, (-50)*256 - 100         ; 

; start of XMAS
                    dw       200, (00)*256 + 60           ; 

; 0,0
                    dw       150, (100)*256 + -100        ; 
                    dw       160, (-20)*256 + 0           ; 

                    dw       $ffff, $ffff 
;***************************************************************************
; queries joystick and
; sets coarse and fine accordingly
handleMove 
                    jsr      query_joystick_analog 
                    ldx      currentLevel 
                    LDB      last_joy_x                   ; only jump if last joy pos was zero (needed for testing later) 
                    LDA      Vec_Joy_1_X                  ; load joystick 1 position X to A 
                    STA      last_joy_x                   ; store this joystick position 
                    BEQ      moveXDoneComplete            ; no x joystick input available 
                    BMI      moveLeft                     ; joystick moved to left 
moveRight: 
                    lda      xFine                        ; load fine X 
                    adda     speedx 
                    sta      xFine                        ; store it 
                    cmpa     #FINE_MAX_HORIZONTAL         ; compare with max 
                    blo      moveXDone 
                    suba     #FINE_MAX_HORIZONTAL 
                    sta      xFine 
                    inc      xCoarse                      ; increase coarse 
                    lda      xCoarse                      ; load coarse 
                    adda     #ALL_TILES_HORIZONTAL        ; and add width of screen 
                    cmpa     1,x                          ; if that is longer than level width 
                    ble      moveXDone 
                    dec      xCoarse                      ; decrease coarse (stay at border) 
                    lda      #FINE_MAX_HORIZONTAL 
; suba speedx
                    sta      xFine 
                    bra      moveXDone 


moveLeft: 
                    lda      xFine                        ; load fine x 
                    suba     speedx 
                    sta      xFine                        ; store it 
                    bpl      moveXDone                    ; if still positive - everything is fine -> branch 
                    adda     #FINE_MAX_HORIZONTAL 
                    sta      xFine                        ; store it 
                    dec      xCoarse                      ; and decrease coarse 
                    bpl      moveXDone                    ; if coarse positive -> fine again 
                    clr      xCoarse                      ; otherwise we reached the (0) end of the level and must stay here! 
                    clr      xFine 
                    bra      moveXDone 


moveXDone: 
; adjust fine
                    lda      #STEP_HORIZONTAL_TILE_IN_PIXEL 
                    ldb      xFine 
                    mul      
                    std      rightclip 
moveXDoneComplete 

                    LDA      Vec_Joy_1_Y                  ; load joystick 1 position Y to A 
                    LDB      last_joy_y                   ; only jump if last joy pos was zero 
                    STA      last_joy_y                   ; store this joystick position 
                    BEQ      moveYDoneComplete            ; no joystick input available 
                    BMI      moveDown                     ; joystick moved to down 
moveUp: 
                    lda      yFine 
                    suba     speedy 
                    sta      yFine 
                    bpl      moveYDone 
                    adda     #FINE_MAX_VERTICAL 
                    sta      yFine 
                    dec      yCoarse 
                    bpl      moveYDone 
                    clr      yCoarse 
                    clr      yFine 
                    bra      moveYDone 


moveDown: 
                    lda      yFine 
                    adda     speedy 
                    sta      yFine 
                    cmpa     #FINE_MAX_VERTICAL 
                    blo      moveYDone 
                    suba     #FINE_MAX_VERTICAL 
                    sta      yFine 
                    inc      yCoarse 
                    lda      yCoarse 
                    adda     #ALL_TILES_VERTICAL 
                    cmpa     1,x 
                    ble      moveYDone 
                    dec      yCoarse 
                    lda      #FINE_MAX_VERTICAL 
; suba speedy 
                    sta      yFine 
                    bra      moveYDone 


moveYDone: 
; adjust fine
                    lda      #STEP_VERTICAL_TILE_IN_PIXEL 
                    ldb      yFine 
                    mul      
                    negb     
                    addb     #128 
                    clra     
                    std      topclip 
moveYDoneComplete: 
                    rts      


;***************************************************************************
;query_joystick: 
;                    QUERY_JOYSTICK  
;                    rts      

query_joystick_analog: 
                                                          ; 
; The joystick enable flags (C81F-C822) must be initialized to one of   ;
; the following values:                                                 ;
;                                                                       ;
;       0 - ignore; return no value.                                    ;
;       1 - return state of console 1 left/right position.              ;
;       3 - return state of console 1 up/down position.    
                    lda      #1 
                    sta      $C81F 
                    lda      #3 
                    sta      $C820 
                    lda      #08 
                    sta      $C81A 
                    clr      speedx 
                    clr      speedy 
;                    jsr      Joy_Analog 
                    jsr      simAnalag 

                    LDA      Vec_Joy_1_Y                  ; load joystick 1 position Y to A 
                    sta      anay 
                    LDA      Vec_Joy_1_X 
                    sta      anax 
                    bpl      xpositive 
                    nega     
xpositive 
                    cmpa     #100 
                    blo      no_64x 
                    lda      #16 
                    sta      speedx 
                    bra      xdone 


no_64x 
                    cmpa     #80 
                    blo      no_32x 
                    lda      #8 
                    sta      speedx 
                    bra      xdone 


no_32x 
                    cmpa     #60 
                    blo      no_16x 
                    lda      #4 
                    sta      speedx 
                    bra      xdone 


no_16x 
                    cmpa     #40 
                    blo      no_8x 
                    lda      #2 
                    sta      speedx 
                    bra      xdone 


no_8x 
                    cmpa     #20 
                    blo      no_4x 
                    lda      #1 
                    sta      speedx 
                    bra      xdone 


no_4x 
xdone 
                    lda      anay 
                    bpl      ypositive 
                    nega     
ypositive 
                    cmpa     #100 
                    blo      no_64y 
                    lda      #16 
                    sta      speedy 
                    bra      ydone 


no_64y 
                    cmpa     #80 
                    blo      no_32y 
                    lda      #8 
                    sta      speedy 
                    bra      ydone 


no_32y 
                    cmpa     #60 
                    blo      no_16y 
                    lda      #4 
                    sta      speedy 
                    bra      ydone 


no_16y 
                    cmpa     #40 
                    blo      no_8y 
                    lda      #2 
                    sta      speedy 
                    bra      ydone 


no_8y 
                    cmpa     #20 
                    blo      no_4y 
                    lda      #1 
                    sta      speedy 
                    bra      ydone 


no_4y 
ydone 
; TODO speed changes must respect, that sum of speeds 
; can still sum up to FINE_MAX!
; or fine max must be tested with overflow instead of equal!
;                    QUERY_JOYSTICK  
; lda #1
; sta speedx
; sta speedy
                    rts      


; include line ->                     include  "clipLeft.i"
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
; D = clipping place (in scale of added strengths of vector X positions)
; X = Vector list
; U = pointer to targetlist
; return
; result list has following format
;
; DB pattern, y, x
; DB pattern, y, x
; DB ... (till counter is 1)
;
; simple is "simple"
; either x0 OR y0 is zero
; than there is no divide needed!
; every right angled vectorlist fullfills this!
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
CALC_P2: 
; macro call ->                     HELP_CALC_P2  
                                                          ; first setup x1 and x2 according to clipping 
                                                          ; information 
                    SUBD     BORDER 
                    STB      _x2,u                        ; part of vector that is visible (or vice versa) 
                    SUBB     x0 
                    NEGB     
                    STB      _x1,u                        ; part of vector that is invisible (or vice versa) 
                                                          ; now we have to calculate the Y part of the two 
                                                          ; halves 
                                                          ; Y1/X1 and Y2/X2 should be like Y0/X0 
                                                          ; X0 = original length 
                                                          ; 
                                                          ; than Y1 = Y0*X1/X0 
                                                          ; than Y2 = Y0*X2/X0 
                                                          ; but we know that Y1 + Y2 = Y0 
                                                          ; -> Y2 = Y0 - Y1 
                                                          ; we do div and mul unsigned 
                                                          ; so check for signness here 
                                                          ; and adjust later 
                    CLRA     
                    STA      neggi 
                    LDB      x0 
                    BPL      is_pl12 
                    INC      neggi 
                    NEGB     
is_pl12: 
                    CMPB     #64 
                    BEQ      div_d_642 
                    CMPB     #32 
                    lBEQ     div_d_322 
                    CMPB     #16 
                    BEQ      div_d_162 
                    CMPB     #8 
                    BEQ      div_d_82 
                    CMPB     #4 
                    lBEQ     div_d_42 

div_d_1282 
; if vectorlist is correct,
; than here is either +127 or - 127, both are calculated by DIF 128

                    LDA      y0 
                    BPL      is_pl2_1282 
                    INC      neggi 
                    NEGA     

is_pl2_1282: 
                    LDB      _x1,u 
                    BPL      is_pl3_1282 
                    INC      neggi 
                    NEGB     
is_pl3_1282: 
                    MUL      
                    ASLB                                  ; this divides d by 64 
                    ROLA                                  ; result in A 
                    ASLB     
                    ROLA     
                    lSRA                                  ; and once again hence 128 

                    ASR      neggi 
                    BCC      no_neggi1_1282 
                    NEGA     
                    STA      _y1,u                        ; store y1 
                    NEGA                                  ; -y1 + y0 = y0 - y1 = y2 
                    ADDA     y0 
                    STA      _y2,u                        ; store y2 
                    jmp      end_macro2 


no_neggi1_1282: 
                    STA      _y1,u                        ; store y1 
                    NEGA                                  ; -y1 + y0 = y0 - y1 = y2 
                    ADDA     y0 
                    STA      _y2,u                        ; store y2 
                    jmp      end_macro2 


div_d_642 
                    LDA      y0 
                    BPL      is_pl22 
                    INC      neggi 
                    NEGA     
is_pl22: 
                    LDB      _x1,u 
                    BPL      is_pl32 
                    INC      neggi 
                    NEGB     
is_pl32: 
                    MUL      
                    ASLB                                  ; this divides d by 64 
                    ROLA                                  ; result in A 
                    ASLB     
                    ROLA     
                    ASR      neggi 
                    BCC      no_neggi12 
                    NEGA     
no_neggi12: 
                    STA      _y1,u                        ; store y1 
                    NEGA                                  ; -y1 + y0 = y0 - y1 = y2 
                    ADDA     y0 
                    STA      _y2,u                        ; store y2 
                    BRA      end_macro2 


div_d_162 
                    LDA      y0 
                    BPL      is_pl42 
                    INC      neggi 
                    NEGA     
is_pl42: 
                    LDB      _x1,u 
                    BPL      is_pl52 
                    INC      neggi 
                    NEGB     
is_pl52: 
                    MUL      
                    BRA      enter_div322 


div_d_82 
                    LDA      y0 
                    BPL      is_pl482 
                    INC      neggi 
                    NEGA     
is_pl482: 
                    LDB      _x1,u 
                    BPL      is_pl582 
                    INC      neggi 
                    NEGB     
is_pl582: 
                    MUL      
                    BRA      enter_div3282 


div_d_42 
                    LDA      y0 
                    BPL      is_pl442 
                    INC      neggi 
                    NEGA     
is_pl442: 
                    LDB      _x1,u 
                    BPL      is_pl542 
                    INC      neggi 
                    NEGB     
is_pl542: 
                    MUL      
                    BRA      enter_div3242 


div_d_322 
                    LDA      y0 
                    BPL      is_pl62 
                    INC      neggi 
                    NEGA     
is_pl62: 
                    LDB      _x1,u 
                    BPL      is_pl72 
                    INC      neggi 
                    NEGB     
is_pl72: 
                    MUL      
; macro call ->                     MY_LSR_D  
                    ASRA     
                    RORB     
enter_div322: 
; macro call ->                     MY_LSR_D  
                    ASRA     
                    RORB     
enter_div3282: 
; macro call ->                     MY_LSR_D  
                    ASRA     
                    RORB     
enter_div3242: 
; macro call ->                     MY_LSR_D  
                    ASRA     
                    RORB     
; macro call ->                     MY_LSR_D  
                    ASRA     
                    RORB     
                    ASR      neggi 
                    BCC      no_neggi2 
                    NEGB     
no_neggi2: 
                    STB      _y1,u                        ; store y1 
                    NEGB                                  ; -y1 + y0 = y0 - y1 = y2 
                    ADDB     y0 
                    STB      _y2,u                        ; store y2 
end_macro2: 
                    rts      

;-------------------------------------------------------------------------------------------
CALC_P2_exact 
; macro call ->                     HELP_CALC_P2_exact  
                                                          ; first setup x1 and x2 according to clipping 
                                                          ; information 
                    SUBD     BORDER 
                    STB      _x2,u                        ; part of vector that is visible (or vice versa) 
                    SUBB     x0 
                    NEGB     
                    STB      _x1,u                        ; part of vector that is invisible (or vice versa) 
                                                          ; now we have to calculate the Y part of the two 
                                                          ; halves 
                                                          ; Y1/X1 and Y2/X2 should be like Y0/X0 
                                                          ; X0 = original length 
                                                          ; 
                                                          ; than Y1 = Y0*X1/X0 
                                                          ; than Y2 = Y0*X2/X0 
                                                          ; but we know that Y1 + Y2 = Y0 
                                                          ; -> Y2 = Y0 - Y1 
                                                          ; we do div and mul unsigned 
                                                          ; so check for signness here 
                                                          ; and adjust later 
                    CLRA     
                    STA      neggi 
                    LDB      x0 
                    BPL      is_pl18 
                    INC      neggi 
                    NEGB     
is_pl18: 
                    std      jtmp1                        ; divide by tmp1 = x0 

                    LDA      y0 
                    BPL      is_pl2_1288 
                    INC      neggi 
                    NEGA     

is_pl2_1288: 
                    LDB      _x1,u 
                    BPL      is_pl3_1288 
                    INC      neggi 
                    NEGB     
is_pl3_1288: 
                    MUL      

; in d the value that must be divided
; tmp1 is = up

divStart: 
; macro call ->  MY_DIV_D_BY_TMP1_TO_B_UNSIGNED
                    CLR      divide_tmp 
                    TST      jtmp1+1 
                    BEQ      divide_by_zero9 
                    DEC      divide_tmp 
                    CMPD     #0 
                    BPL      divide_next9 
divide_next19: 
                    INC      divide_tmp 
                    ADDD     jtmp1 
                    BMI      divide_next19 
divide_by_zero19: 
                    LDB      divide_tmp 
                    NEGB     
                    BRA      divide_end9 

divide_next9: 
                    INC      divide_tmp 
                    SUBD     jtmp1 
                    BPL      divide_next9 
divide_by_zero9: 
                    LDB      divide_tmp 
divide_end9: 
; result in B
divEnd: 

                    ASR      neggi 
                    BCC      no_neggi1_1288 
                    NEGB     
                    STB      _y1,u                        ; store y1 
                    NEGB                                  ; -y1 + y0 = y0 - y1 = y2 
                    ADDB     y0 
                    STB      _y2,u                        ; store y2 
                    bra      end_macro8 


no_neggi1_1288: 
                    STB      _y1,u                        ; store y1 
                    NEGB                                  ; -y1 + y0 = y0 - y1 = y2 
                    ADDB     y0 
                    STB      _y2,u                        ; store y2 

end_macro8: 
                    rts      

;-------------------------------------------------------------------------------------------
SIMPLE              =        1                            ; #noDoubleWarn 
clip_vlp_nsleft 
; macro call ->                     CLIP_LEFT  
                    direct   $D0                          ; but here the code still uses c8 
                    STD      BORDER                       ; remember clipping edge 
                    LDD      #0 
                    sta      clip_test                    ; is invisible 
                    STD      clip_counter                 ; clip starts at 0 
                                                          ; we add to this each strength 
                                                          ; of a vector 
nextVector_nsleft10: 
                    lda      ,x+                          ;test byte pattern, if positive -> end 
                    bgt      done_nsleft10 
                    LDD      ,X++                         ; get current Vector strength 
                    STD      1,u                          ; remember it as v0 
                    SEX                                   ; extend it X part 
                    bmi      negativeAdd_nsleft10         ; negative "add", cross to invisible possible 
positiveAdd_nsleft10 
; here only a cross from invisble to visible possible
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BLE      addCompleteInvisible_nsleft10 ; str_pat_and_scale_vlp 
                    tst      clip_test 
                    bne      addCompleteVisible_nsleft10 
; cross from invisible to visible!
; in d clipcounter
; v0 is set
; y coordinates must always be 0 if we come here!
; macro call ->                     SIMPLE_LEFT_INV_TO_VIS  
                    subd     BORDER 
                    CLRa     
                    std      4,u                          ; y2 (=0) and x2 
                    negb     
                    addb     2,u                          ; this denotes x0 
                    std      1,u                          ; y1 (=0) and x1 
                    sta      ,u                           ; pattern 1 
                    lda      -3,x                         ; load pattern of current vector 
                    sta      3,U                          ; pattern 2 
                    leau     6,u 
                    inc      clip_test                    ; now != 0 -> visible 
                    BRA      nextVector_nsleft10 


addCompleteInvisible_nsleft10 
                    CLR      ,U                           ; pattern is 0 
                    leau     3,u 
                    BRA      nextVector_nsleft10 


addCompleteVisible_nsleft10 
                    lda      -3,x 
                    sta      ,U                           ; pattern is pattern 
                    leau     3,u 
                    BRA      nextVector_nsleft10 


negativeAdd_nsleft10 
; here only a cross from visble to invisible possible
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BGE      addCompleteVisible_nsleft10  ; str_pat_and_scale_vlp 
                    tst      clip_test 
                    beq      addCompleteInvisible_nsleft10 
; cross from visible to invisible!
; in d clipcounter
; v0 is set
; y coordinates must always be 0 if we come here!
; macro call ->                     SIMPLE_LEFT_VIS_TO_INV  
                    subd     BORDER 
                    lda      -3,x 
                    sta      ,U                           ; pattern 1 (visible) 
                    clra     
                    std      4,u                          ; y2 (=0); x2 
                    sta      3,u                          ; pattern 2 = 0 
                    negb     
                    addb     2,u                          ; denotes x0 
                    std      1,u                          ; y1 (=0), x1 
                    leau     6,u 
                    sta      clip_test                    ; now != 0 -> visible 
                    BRA      nextVector_nsleft10 


done_nsleft10 
                    sta      ,u                           ; last positibe must be stored! 
                    rts      

SIMPLE              =        0                            ; #noDoubleWarn 
;-------------------------------------------------------------------------------------------
EXPONENT            =        1                            ; #noDoubleWarn 
clip_vlp_p2_left 
; macro call ->                     CLIP_LEFT  
                    direct   $D0                          ; but here the code still uses c8 
                    STD      BORDER                       ; remember clipping edge 
                    LDD      #0 
                    sta      clip_test                    ; is invisible 
                    STD      clip_counter                 ; clip starts at 0 
                                                          ; we add to this each strength 
                                                          ; of a vector 
nextVector_nsleft13: 
                    lda      ,x+                          ;test byte pattern, if positive -> end 
                    bgt      done_nsleft13 
                    LDD      ,X++                         ; get current Vector strength 
                    STD      v0 
                    SEX                                   ; extend it X part 
                    bmi      negativeAdd_nsleft13         ; negative "add", cross to invisible possible 
positiveAdd_nsleft13 
; here only a cross from invisble to visible possible
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BLE      addCompleteInvisible_nsleft13 ; str_pat_and_scale_vlp 
                    tst      clip_test 
                    bne      addCompleteVisible_nsleft13 
; cross from invisible to visible!
; in d clipcounter
; v0 is set
; y coordinates must always be 0 if we come here!
; macro call ->                     EXPONENT_LEFT_INV_TO_VIS  
                    jsr      CALC_P2 
                    CLR      _pat1,U                      ; pattern first vector is invisible 
                    lda      -3,x 
                    sta      _pat2,U                      ; pattern second vector is visible 
                    leau     6,u 
                    inc      clip_test                    ; now != 0 -> visible 
                    BRA      nextVector_nsleft13 


addCompleteInvisible_nsleft13 
                    CLR      ,U+                          ; pattern is 0 
                    LDD      v0                           ; load current Vector 
                    STD      ,U++                         ; store it also 
                    BRA      nextVector_nsleft13 


addCompleteVisible_nsleft13 
                    lda      -3,x 
                    sta      ,U+                          ; pattern is pattern 
                    LDD      v0                           ; load current Vector 
                    STD      ,U++                         ; store it also 
                    BRA      nextVector_nsleft13 


negativeAdd_nsleft13 
; here only a cross from visble to invisible possible
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BGE      addCompleteVisible_nsleft13  ; str_pat_and_scale_vlp 
                    tst      clip_test 
                    beq      addCompleteInvisible_nsleft13 
; cross from visible to invisible!
; in d clipcounter
; v0 is set
; y coordinates must always be 0 if we come here!
; macro call ->                     EXPONENT_LEFT_VIS_TO_INV  
                    jsr      CALC_P2 
                    CLR      _pat2,U                      ; pattern first vector is invisible 
                    lda      -3,x 
                    sta      _pat1,U                      ; pattern second vector is visible 
                    leau     6,u 
                    clr      clip_test                    ; now != 0 -> visible 
                    BRA      nextVector_nsleft13 


done_nsleft13 
                    sta      ,u                           ; last positibe must be stored! 
                    rts      

EXPONENT            =        0                            ; #noDoubleWarn 
;-------------------------------------------------------------------------------------------
EXACT               =        1                            ; #noDoubleWarn 
clip_vlp_pExact_left 
; macro call ->                     CLIP_LEFT  
                    direct   $D0                          ; but here the code still uses c8 
                    STD      BORDER                       ; remember clipping edge 
                    LDD      #0 
                    sta      clip_test                    ; is invisible 
                    STD      clip_counter                 ; clip starts at 0 
                                                          ; we add to this each strength 
                                                          ; of a vector 
nextVector_nsleft16: 
                    lda      ,x+                          ;test byte pattern, if positive -> end 
                    bgt      done_nsleft16 
                    LDD      ,X++                         ; get current Vector strength 
                    STD      v0 
                    SEX                                   ; extend it X part 
                    bmi      negativeAdd_nsleft16         ; negative "add", cross to invisible possible 
positiveAdd_nsleft16 
; here only a cross from invisble to visible possible
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BLE      addCompleteInvisible_nsleft16 ; str_pat_and_scale_vlp 
                    tst      clip_test 
                    bne      addCompleteVisible_nsleft16 
; cross from invisible to visible!
; in d clipcounter
; v0 is set
; y coordinates must always be 0 if we come here!
; macro call ->                     EXACT_LEFT_INV_TO_VIS
                    jsr      CALC_P2_exact 
                    CLR      _pat1,U                      ; pattern first vector is invisible 
                    lda      -3,x 
                    sta      _pat2,U                      ; pattern second vector is visible 
                    leau     6,u 
                    inc      clip_test                    ; now != 0 -> visible 
                    BRA      nextVector_nsleft16 


addCompleteInvisible_nsleft16 
                    CLR      ,U+                          ; pattern is 0 
                    LDD      v0                           ; load current Vector 
                    STD      ,U++                         ; store it also 
                    BRA      nextVector_nsleft16 


addCompleteVisible_nsleft16 
                    lda      -3,x 
                    sta      ,U+                          ; pattern is pattern 
                    LDD      v0                           ; load current Vector 
                    STD      ,U++                         ; store it also 
                    BRA      nextVector_nsleft16 


negativeAdd_nsleft16 
; here only a cross from visble to invisible possible
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BGE      addCompleteVisible_nsleft16  ; str_pat_and_scale_vlp 
                    tst      clip_test 
                    beq      addCompleteInvisible_nsleft16 
; cross from visible to invisible!
; in d clipcounter
; v0 is set
; y coordinates must always be 0 if we come here!
; macro call ->                     EXACT_LEFT_VIS_TO_INV  
                    jsr      CALC_P2_exact 
                    CLR      _pat2,U                      ; pattern first vector is invisible 
                    lda      -3,x 
                    sta      _pat1,U                      ; pattern second vector is visible 
                    leau     6,u 
                    clr      clip_test                    ; now != 0 -> visible 
                    BRA      nextVector_nsleft16 


done_nsleft16 
                    sta      ,u                           ; last positibe must be stored! 
                    rts      

EXACT               =        0                            ; #noDoubleWarn 
;-------------------------------------------------------------------------------------------
; include line ->                     include  "clipRight.i"
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
SIMPLE              =        1                            ; #noDoubleWarn 
clip_vlp_nsright 
; macro call ->                     CLIP_RIGHT  
                    direct   $D0                          ; but here the code still uses c8 
                    STD      BORDER                       ; remember clipping edge 
                    lda      #1 
                    sta      clip_test                    ; is visible 
                    LDD      #0 
                    STD      clip_counter                 ; clip starts at 0 
                                                          ; we add to this each strength 
                                                          ; of a vector 
nextVector_nsright19: 
                    lda      ,x+                          ;test byte pattern, if positive -> end 
                    bgt      done_nsright19 
                    LDD      ,X++                         ; get current Vector strength 
                    STD      1,u                          ; remember it as v0 
                    SEX                                   ; extend it X part 
                    bmi      negativeAdd_nsright19        ; negative "add", cross to visible possible 
positiveAdd_nsright19 
; here only a cross from visble to invisible possible
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BLE      addCompleteVisible_nsright19 ; str_pat_and_scale_vlp 
                    tst      clip_test 
                    beq      addCompleteInvisible_nsright19 
; cross from visible to invisible!
; in d clipcounter
; v0 is set
; y coordinates must always be 0 if we come here!
; macro call ->                     SIMPLE_RIGHT_VIS_TO_INV  
                    subd     BORDER 
                    lda      -3,x 
                    sta      ,u                           ; pattern first vector is visible 
                    clra     
                    std      4,u                          ; y2 (=0), x2 
                    negb     
                    addb     2,u                          ; denotes x0 
                    std      1,u                          ; y1 (=0) and x1 
                    sta      3,u                          ; clear pattern 2 
                    leau     6,u 
                    sta      clip_test                    ; now = 0 -> invisible 
                    BRA      nextVector_nsright19 


addCompleteInvisible_nsright19 
                    CLR      ,U                           ; pattern is 0 
                    leau     3,u 
                    BRA      nextVector_nsright19 


addCompleteVisible_nsright19 
                    lda      -3,x 
                    sta      ,U                           ; pattern is pattern 
                    leau     3,u 
                    BRA      nextVector_nsright19 


negativeAdd_nsright19 
; here only a cross from invisble to visible possible
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BGE      addCompleteInvisible_nsright19 ; str_pat_and_scale_vlp 
                    tst      clip_test 
                    bne      addCompleteVisible_nsright19 
; cross from invisible to visible!
; in d clipcounter
; v0 is set
; y coordinates must always be 0 if we come here!
; macro call ->                     SIMPLE_RIGHT_INV_TO_VIS  
                    subd     BORDER 
                    clra     
                    sta      ,u                           ;pattern 1 
                    std      4,u                          ; y2 (=0) and x2 
                    negb     
                    addb     2,u                          ; denotes x0 
                    std      1,u                          ; y1 and y2 
                    lda      -3,x 
                    sta      3,U                          ; pattern 2 (visible) 
                    leau     6,u 
                    inc      clip_test                    ; now != 0 -> visible 
                    BRA      nextVector_nsright19 


done_nsright19: 
                    sta      ,u                           ; last positibe must be stored! 
                    rts      


SIMPLE              =        0                            ; #noDoubleWarn 
;-------------------------------------------------------------------------------------------
EXPONENT            =        1                            ; #noDoubleWarn 
clip_vlp_p2_right 
; macro call ->                     CLIP_RIGHT  
                    direct   $D0                          ; but here the code still uses c8 
                    STD      BORDER                       ; remember clipping edge 
                    lda      #1 
                    sta      clip_test                    ; is visible 
                    LDD      #0 
                    STD      clip_counter                 ; clip starts at 0 
                                                          ; we add to this each strength 
                                                          ; of a vector 
nextVector_nsright22: 
                    lda      ,x+                          ;test byte pattern, if positive -> end 
                    bgt      done_nsright22 
                    LDD      ,X++                         ; get current Vector strength 
                    STD      v0 
                    SEX                                   ; extend it X part 
                    bmi      negativeAdd_nsright22        ; negative "add", cross to visible possible 
positiveAdd_nsright22 
; here only a cross from visble to invisible possible
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BLE      addCompleteVisible_nsright22 ; str_pat_and_scale_vlp 
                    tst      clip_test 
                    beq      addCompleteInvisible_nsright22 
; cross from visible to invisible!
; in d clipcounter
; v0 is set
; y coordinates must always be 0 if we come here!
; macro call ->                     EXPONENT_RIGHT_VIS_TO_INV  
                    jsr      CALC_P2 
                    lda      -3,x 
                    sta      _pat1,U                      ; pattern second vector is visible 
                    CLR      _pat2,U                      ; pattern first vector is invisible 
                    leau     6,u 
                    clr      clip_test                    ; now = 0 -> invisible 
                    BRA      nextVector_nsright22 


addCompleteInvisible_nsright22 
                    CLR      ,U+                          ; pattern is 0 
                    LDD      v0                           ; load current Vector 
                    STD      ,U++                         ; store it also 
                    BRA      nextVector_nsright22 


addCompleteVisible_nsright22 
                    lda      -3,x 
                    sta      ,U+                          ; pattern is pattern 
                    LDD      v0                           ; load current Vector 
                    STD      ,U++                         ; store it also 
                    BRA      nextVector_nsright22 


negativeAdd_nsright22 
; here only a cross from invisble to visible possible
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BGE      addCompleteInvisible_nsright22 ; str_pat_and_scale_vlp 
                    tst      clip_test 
                    bne      addCompleteVisible_nsright22 
; cross from invisible to visible!
; in d clipcounter
; v0 is set
; y coordinates must always be 0 if we come here!
; macro call ->                     EXPONENT_RIGHT_INV_TO_VIS  
                    jsr      CALC_P2 
                    CLR      _pat1,U                      ; pattern first vector is invisible 
                    lda      -3,x 
                    sta      _pat2,U                      ; pattern second vector is visible 
                    leau     6,u 
                    inc      clip_test                    ; now != 0 -> visible 
                    BRA      nextVector_nsright22 


done_nsright22: 
                    sta      ,u                           ; last positibe must be stored! 
                    rts      


EXPONENT            =        0                            ; #noDoubleWarn 
;-------------------------------------------------------------------------------------------
EXACT               =        1                            ; #noDoubleWarn 
clip_vlp_pExact_right 
; macro call ->                     CLIP_RIGHT  
                    direct   $D0                          ; but here the code still uses c8 
                    STD      BORDER                       ; remember clipping edge 
                    lda      #1 
                    sta      clip_test                    ; is visible 
                    LDD      #0 
                    STD      clip_counter                 ; clip starts at 0 
                                                          ; we add to this each strength 
                                                          ; of a vector 
nextVector_nsright25: 
                    lda      ,x+                          ;test byte pattern, if positive -> end 
                    bgt      done_nsright25 
                    LDD      ,X++                         ; get current Vector strength 
                    STD      v0 
                    SEX                                   ; extend it X part 
                    bmi      negativeAdd_nsright25        ; negative "add", cross to visible possible 
positiveAdd_nsright25 
; here only a cross from visble to invisible possible
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BLE      addCompleteVisible_nsright25 ; str_pat_and_scale_vlp 
                    tst      clip_test 
                    beq      addCompleteInvisible_nsright25 
; cross from visible to invisible!
; in d clipcounter
; v0 is set
; y coordinates must always be 0 if we come here!
; macro call ->                     EXACT_RIGHT_VIS_TO_INV  
                    jsr      CALC_P2_exact 
                    lda      -3,x 
                    sta      _pat1,U                      ; pattern second vector is visible 
                    CLR      _pat2,U                      ; pattern first vector is invisible 
                    leau     6,u 
                    clr      clip_test                    ; now = 0 -> invisible 
                    BRA      nextVector_nsright25 


addCompleteInvisible_nsright25 
                    CLR      ,U+                          ; pattern is 0 
                    LDD      v0                           ; load current Vector 
                    STD      ,U++                         ; store it also 
                    BRA      nextVector_nsright25 


addCompleteVisible_nsright25 
                    lda      -3,x 
                    sta      ,U+                          ; pattern is pattern 
                    LDD      v0                           ; load current Vector 
                    STD      ,U++                         ; store it also 
                    BRA      nextVector_nsright25 


negativeAdd_nsright25 
; here only a cross from invisble to visible possible
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BGE      addCompleteInvisible_nsright25 ; str_pat_and_scale_vlp 
                    tst      clip_test 
                    bne      addCompleteVisible_nsright25 
; cross from invisible to visible!
; in d clipcounter
; v0 is set
; y coordinates must always be 0 if we come here!
; macro call ->                     EXACT_RIGHT_INV_TO_VIS  
                    jsr      CALC_P2_exact 
                    CLR      _pat1,U                      ; pattern first vector is invisible 
                    lda      -3,x 
                    sta      _pat2,U                      ; pattern second vector is visible 
                    leau     6,u 
                    inc      clip_test                    ; now != 0 -> visible 
                    BRA      nextVector_nsright25 


done_nsright25: 
                    sta      ,u                           ; last positibe must be stored! 
                    rts      


EXACT               =        0                            ; #noDoubleWarn 
;-------------------------------------------------------------------------------------------
; include line ->                     include  "clipBottom.i"
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
CALC_P2_y: 
; macro call ->                     HELP_CALC_P2_y_i
                                                          ; first setup x1 and x2 according to clipping 
                                                          ; information 
                    SUBD     BORDER 

                    STB      _y2,u                        ; part of vector that is visible (or vice versa) 
                    SUBB     y0 
                    NEGB     
                    STB      _y1,u                        ; part of vector that is invisible (or vice versa) 
                                                          ; now we have to calculate the X part of the two 
; TODO change y = x vice versa in description
                                                          ; halves 
                                                          ; Y1/X1 and Y2/X2 should be like Y0/X0 
                                                          ; X0 = original length 
                                                          ; 
                                                          ; than Y1 = Y0*X1/X0 
                                                          ; than Y2 = Y0*X2/X0 
                                                          ; but we know that Y1 + Y2 = Y0 
                                                          ; -> Y2 = Y0 - Y1 
                                                          ; div cycles depend on size of tmp1 
                                                          ; the bigger tmp1 the faster div 
                                                          ; we do div and mul unsigned 
                                                          ; so check for signness here 
                                                          ; and adjust later 
                    CLRA     
                    STA      neggi 
                    LDB      y0 
                    BPL      is_pl128 
                    INC      neggi 
                    NEGB     
is_pl128: 
                    CMPB     #64 
                    BEQ      div_d_6428 
                    CMPB     #32 
                    lBEQ     div_d_3228 
                    CMPB     #16 
                    BEQ      div_d_1628 
                    CMPB     #8 
                    BEQ      div_d_828 
                    CMPB     #4 
                    lBEQ     div_d_428 

div_d_12828 
; if vectorlist is correct,
; than here is either +127 or - 127, both are calculated by DIF 128

                    LDA      x0 
                    BPL      is_pl2_12828 
                    INC      neggi 
                    NEGA     

is_pl2_12828: 
                    LDB      _y1,u 
                    BPL      is_pl3_12828 
                    INC      neggi 
                    NEGB     
is_pl3_12828: 
                    MUL      
                    ASLB                                  ; this divides d by 64 
                    ROLA                                  ; result in A 
                    ASLB     
                    ROLA     
                    lSRA                                  ; and once again hence 128 

                    ASR      neggi 
                    BCC      no_neggi1_12828 
                    NEGA     
                    STA      _x1,u                        ; store y1 
                    NEGA                                  ; -y1 + y0 = y0 - y1 = y2 
                    ADDA     x0 
                    STA      _x2,u                        ; store y2 
                    jmp      end_macro28 


no_neggi1_12828: 
                    STA      _x1,u                        ; store y1 
                    NEGA                                  ; -y1 + y0 = y0 - y1 = y2 
                    ADDA     x0 
                    STA      _x2,u                        ; store y2 
                    JMP      end_macro28 


div_d_6428 
                    LDA      x0 
                    BPL      is_pl228 
                    INC      neggi 
                    NEGA     
is_pl228: 
                    LDB      _y1,u 
                    BPL      is_pl328 
                    INC      neggi 
                    NEGB     
is_pl328: 
                    MUL      
                    ASLB                                  ; this divides d by 64 
                    ROLA                                  ; result in A 
                    ASLB     
                    ROLA     
                    ASR      neggi 
                    BCC      no_neggi128 
                    NEGA     
no_neggi128: 
                    STA      _x1,u                        ; store y1 
                    NEGA                                  ; -y1 + y0 = y0 - y1 = y2 
                    ADDA     x0 
                    STA      _x2,u                        ; store y2 
                    BRA      end_macro28 


div_d_1628 
                    LDA      x0 
                    BPL      is_pl428 
                    INC      neggi 
                    NEGA     
is_pl428: 
                    LDB      _y1,u 
                    BPL      is_pl528 
                    INC      neggi 
                    NEGB     
is_pl528: 
                    MUL      
                    BRA      enter_div3228 


div_d_828 
                    LDA      x0 
                    BPL      is_pl4828 
                    INC      neggi 
                    NEGA     
is_pl4828: 
                    LDB      _y1,u 
                    BPL      is_pl5828 
                    INC      neggi 
                    NEGB     
is_pl5828: 
                    MUL      
                    BRA      enter_div32828 


div_d_428 
                    LDA      x0 
                    BPL      is_pl4428 
                    INC      neggi 
                    NEGA     
is_pl4428: 
                    LDB      _y1,u 
                    BPL      is_pl5428 
                    INC      neggi 
                    NEGB     
is_pl5428: 
                    MUL      
                    BRA      enter_div32428 


div_d_3228 
                    LDA      x0 
                    BPL      is_pl628 
                    INC      neggi 
                    NEGA     
is_pl628: 
                    LDB      _y1,u 
                    BPL      is_pl728 
                    INC      neggi 
                    NEGB     
is_pl728: 
                    MUL      
; macro call ->                     MY_LSR_D  
                    ASRA     
                    RORB     
enter_div3228: 
; macro call ->                     MY_LSR_D  
                    ASRA     
                    RORB     
enter_div32828: 
; macro call ->                     MY_LSR_D  
                    ASRA     
                    RORB     
enter_div32428: 
; macro call ->                     MY_LSR_D  
                    ASRA     
                    RORB     
; macro call ->                     MY_LSR_D  
                    ASRA     
                    RORB     
                    ASR      neggi 
                    BCC      no_neggi28 
                    NEGB     
no_neggi28: 
                    STB      _x1,u                        ; store y1 
                    NEGB                                  ; -y1 + y0 = y0 - y1 = y2 
                    ADDB     x0 
                    STB      _x2,u                        ; store y2 

end_macro28: 
                    rts      

;-------------------------------------------------------------------------------------------
SIMPLE              =        1                            ; #noDoubleWarn 
clip_vlp_sbottom 
; macro call ->                     CLIP_BOTTOM  
                    direct   $D0                          ; but here the code still uses c8 
                    STD      BORDER                       ; remember clipping edge 
                    LDD      #0 
                    sta      clip_test                    ; is invisible 
                    STD      clip_counter                 ; clip starts at 0 
                                                          ; we add to this each strength 
                                                          ; of a vector 
nextVector_nsbottom34: 
                    lda      ,x+                          ;test byte pattern, if positive -> end 
                    bgt      done_nsbottom34 
                    LDD      ,X++                         ; [8 cycles] get current Vector strength 
                    STD      1,u                          ; remember it as v0 
                    tfr      a,b                          ; [6 cycles] 
                    SEX                                   ; extend it Y part 
                    bmi      negativeAdd_nsbottom34       ; negative "add", cross to invisible possible 
positiveAdd_nsbottom34 
; here only a cross from invisble to visible possible
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BLE      addCompleteInvisible_nsbottom34 ; str_pat_and_scale_vlp 
                    tst      clip_test 
                    bne      addCompleteVisible_nsbottom34 
; cross from invisible to visible!
; in d clipcounter
; v0 is set
; x coordinates must always be 0 if we come here!
; macro call ->                     SIMPLE_BOTTOM_INV_TO_VIS  
                    subd     BORDER 
                    clra                                  ; pattern first vector is invisible 
                    stb      4,u                          ; denotes y2 
                    sta      5,u                          ; denotes x2 
                    negb     
                    addb     1,u                          ; add y0 
                    std      ,u                           ; pat1 + y1 
                    ldb      -3,x                         ; original pattern 
                    std      2,u                          ; x1 + pat2 
; clr 5,u ; clear x2
                    leau     6,u 
                    inc      clip_test                    ; now != 0 -> visible 
                    BRA      nextVector_nsbottom34 


addCompleteInvisible_nsbottom34 
                    CLR      ,U                           ; pattern is 0 
                    leau     3,u 
                    BRA      nextVector_nsbottom34 


addCompleteVisible_nsbottom34 
                    lda      -3,x 
                    sta      ,U                           ; pattern is pattern 
                    leau     3,u 
                    BRA      nextVector_nsbottom34 


negativeAdd_nsbottom34 
; here only a cross from visble to invisible possible
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BGE      addCompleteVisible_nsbottom34 ; str_pat_and_scale_vlp 
                    tst      clip_test 
                    beq      addCompleteInvisible_nsbottom34 
; cross from visible to invisible!
; in d clipcounter
; v0 is set
; y coordinates must always be 0 if we come here!
; macro call ->                     SIMPLE_BOTTOM_VIS_TO_INV  
                    subd     BORDER 
                    stb      4,u                          ; store y2 
                    negb     
                    addb     1,u                          ; denotes y0 on read 
                    lda      -3,x                         ; read original pattern 
                    std      ,u                           ; pattern 1 + y1 
                    ldd      #0 
                    std      2, u                         ; x1 + pattern 2 
                    sta      5,u                          ; x2 vector is 0 
                    leau     6,u 
                    sta      clip_test                    ; now != 0 -> visible 
                    BRA      nextVector_nsbottom34 


done_nsbottom34: 
                    sta      ,u                           ; last positibe must be stored! 
                    rts      


SIMPLE              =        0                            ; #noDoubleWarn 
;-------------------------------------------------------------------------------------------
EXPONENT            =        1                            ; #noDoubleWarn 
clip_vlp_p2_bottom 
; macro call ->                     CLIP_BOTTOM  
                    direct   $D0                          ; but here the code still uses c8 
                    STD      BORDER                       ; remember clipping edge 
                    LDD      #0 
                    sta      clip_test                    ; is invisible 
                    STD      clip_counter                 ; clip starts at 0 
                                                          ; we add to this each strength 
                                                          ; of a vector 
nextVector_nsbottom37: 
                    lda      ,x+                          ;test byte pattern, if positive -> end 
                    bgt      done_nsbottom37 
                    LDD      ,X++                         ; [8 cycles] get current Vector strength 
                    STD      v0 
                    tfr      a,b                          ; [6 cycles] 
                    SEX                                   ; extend it Y part 
                    bmi      negativeAdd_nsbottom37       ; negative "add", cross to invisible possible 
positiveAdd_nsbottom37 
; here only a cross from invisble to visible possible
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BLE      addCompleteInvisible_nsbottom37 ; str_pat_and_scale_vlp 
                    tst      clip_test 
                    bne      addCompleteVisible_nsbottom37 
; cross from invisible to visible!
; in d clipcounter
; v0 is set
; macro call ->                     EXPONENT_BOTTOM_INV_TO_VIS  
                    jsr      CALC_P2_y 
                    CLR      _pat1,U                      ; pattern first vector is invisible 
                    lda      -3,x 
                    sta      _pat2,U                      ; pattern second vector is visible 
                    leau     6,u 
                    inc      clip_test                    ; now != 0 -> visible 
                    BRA      nextVector_nsbottom37 


addCompleteInvisible_nsbottom37 
                    CLR      ,U+                          ; pattern is 0 
                    LDD      v0                           ; load current Vector 
                    STD      ,U++                         ; store it also 
                    BRA      nextVector_nsbottom37 


addCompleteVisible_nsbottom37 
                    lda      -3,x 
                    sta      ,U+                          ; pattern is pattern 
                    LDD      v0                           ; load current Vector 
                    STD      ,U++                         ; store it also 
                    BRA      nextVector_nsbottom37 


negativeAdd_nsbottom37 
; here only a cross from visble to invisible possible
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BGE      addCompleteVisible_nsbottom37 ; str_pat_and_scale_vlp 
                    tst      clip_test 
                    beq      addCompleteInvisible_nsbottom37 
; cross from visible to invisible!
; in d clipcounter
; v0 is set
; y coordinates must always be 0 if we come here!
; macro call ->                     EXPONENT_BOTTOM_VIS_TO_INV  
                    jsr      CALC_P2_y 
                    lda      -3,x 
                    sta      _pat1,U                      ; pattern second vector is visible 
                    CLR      _pat2,U                      ; pattern first vector is invisible 
                    leau     6,u 
                    clr      clip_test                    ; now != 0 -> visible 
                    BRA      nextVector_nsbottom37 


done_nsbottom37: 
                    sta      ,u                           ; last positibe must be stored! 
                    rts      


EXPONENT            =        0                            ; #noDoubleWarn 
;-------------------------------------------------------------------------------------------
EXACT               =        1                            ; #noDoubleWarn 
EXACT               =        0                            ; #noDoubleWarn 
;-------------------------------------------------------------------------------------------

; include line ->                     include  "clipTop.i"
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------
SIMPLE              =        1                            ; #noDoubleWarn 
clip_vlp_stop 
; macro call ->                     CLIP_TOP  
                    direct   $D0                          ; but here the code still uses c8 
                    STD      BORDER                       ; remember clipping edge 
                    lda      #1 
                    sta      clip_test                    ; is visible 
                    LDD      #0 
                    STD      clip_counter                 ; clip starts at 0 
                                                          ; we add to this each strength 
                                                          ; of a vector 
nextVector_nstop40 
                    lda      ,x+                          ;test byte pattern, if positive -> end 
                    bgt      done_nstop40 
                    LDD      ,X++                         ; get current Vector strength 
                    STD      1,u                          ; remember it as v0 
                    tfr      a,b 
                    SEX                                   ; extend it y part 
                    bmi      negativeAdd_nstop40          ; negative "add", cross to visible possible 
positiveAdd_nstop40 
; here only a cross from visble to invisible possible
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BLE      addCompleteVisible_nstop40   ; str_pat_and_scale_vlp 
                    tst      clip_test 
                    beq      addCompleteInvisible_nstop40 
; cross from visible to invisible!
; in d clipcounter
; v0 is set
; x coordinates must always be 0 if we come here!
; macro call ->                     SIMPLE_TOP_VIS_TO_INV  
                    subd     BORDER 
                    clra     
                    std      3,u                          ; pat2 (=0) + y2 
                    sta      5,u                          ; x2 = 0 
                    sta      2,u                          ; x1 = 0 
                    sta      clip_test                    ; now = 0 -> invisible 
                    negb     
                    addb     1,u                          ; denotes y0 
                    lda      -3,x 
                    std      ,u                           ; pat1 + y1 
                    leau     6,u 
                    BRA      nextVector_nstop40 


addCompleteInvisible_nstop40 
                    CLR      ,U                           ; pattern is 0 
                    leau     3,u 
                    BRA      nextVector_nstop40 


addCompleteVisible_nstop40 
                    lda      -3,x 
                    sta      ,U                           ; pattern is pattern 
                    leau     3,u 
                    BRA      nextVector_nstop40 


negativeAdd_nstop40 
; here only a cross from invisble to visible possible
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BGE      addCompleteInvisible_nstop40 ; str_pat_and_scale_vlp 
                    tst      clip_test 
                    bne      addCompleteVisible_nstop40 
; cross from invisible to visible!
; in d clipcounter
; v0 is set
; x coordinates must always be 0 if we come here!
; macro call ->                     SIMPLE_TOP_INV_TO_VIS  
                    subd     BORDER 
                    lda      -3,x                         ; load original pattern 
                    std      3,u                          ; pat2 (visible) + y2 
                    clra     
                    negb     
                    addb     1,u                          ; denotes y0 
                    std      ,u                           ; pat1 (=0) and y1 
                    sta      5,u                          ; x2 
                    sta      2,u                          ; x1 
                    leau     6,u 
                    inc      clip_test                    ; now != 0 -> visible 
                    BRA      nextVector_nstop40 


done_nstop40 
                    sta      ,u                           ; last positibe must be stored! 
                    rts      


SIMPLE              =        0                            ; #noDoubleWarn 
;-------------------------------------------------------------------------------------------
EXPONENT            =        1                            ; #noDoubleWarn 
clip_vlp_p2_top 
; macro call ->                     CLIP_TOP
                    direct   $D0                          ; but here the code still uses c8 
                    STD      BORDER                       ; remember clipping edge 
                    lda      #1 
                    sta      clip_test                    ; is visible 
                    LDD      #0 
                    STD      clip_counter                 ; clip starts at 0 
                                                          ; we add to this each strength 
                                                          ; of a vector 
nextVector_nstop43 
                    lda      ,x+                          ;test byte pattern, if positive -> end 
                    bgt      done_nstop43 
                    LDD      ,X++                         ; get current Vector strength 
                    STD      v0 
                    tfr      a,b 
                    SEX                                   ; extend it y part 
                    bmi      negativeAdd_nstop43          ; negative "add", cross to visible possible 
positiveAdd_nstop43 
; here only a cross from visble to invisible possible
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BLE      addCompleteVisible_nstop43   ; str_pat_and_scale_vlp 
                    tst      clip_test 
                    beq      addCompleteInvisible_nstop43 
; cross from visible to invisible!
; in d clipcounter
; v0 is set
; x coordinates must always be 0 if we come here!
; macro call ->                     EXPONENT_TOP_VIS_TO_INV  
                    jsr      CALC_P2_y 
                    lda      -3,x 
                    sta      _pat1,U                      ; pattern second vector is visible 
                    CLR      _pat2,U                      ; pattern first vector is invisible 
                    leau     6,u 
                    clr      clip_test                    ; now = 0 -> invisible 
                    BRA      nextVector_nstop43 


addCompleteInvisible_nstop43 
                    CLR      ,U+                          ; pattern is 0 
                    LDD      v0                           ; load current Vector 
                    STD      ,U++                         ; store it also 
                    BRA      nextVector_nstop43 


addCompleteVisible_nstop43 
                    lda      -3,x 
                    sta      ,U+                          ; pattern is pattern 
                    LDD      v0                           ; load current Vector 
                    STD      ,U++                         ; store it also 
                    BRA      nextVector_nstop43 


negativeAdd_nstop43 
; here only a cross from invisble to visible possible
                    ADDD     clip_counter                 ; and adjust clip_counter 
                    STD      clip_counter                 ; store it 
                                                          ; clip counter has vector 
                                                          ; 'position' at the end 
                                                          ; of current vector 
                    CMPD     BORDER                       ; test for clipping edge 
                    BGE      addCompleteInvisible_nstop43 ; str_pat_and_scale_vlp 
                    tst      clip_test 
                    bne      addCompleteVisible_nstop43 
; cross from invisible to visible!
; in d clipcounter
; v0 is set
; x coordinates must always be 0 if we come here!
; macro call ->                     EXPONENT_TOP_INV_TO_VIS  
                    jsr      CALC_P2_y 
                    CLR      _pat1,U                      ; pattern first vector is invisible 
                    lda      -3,x 
                    sta      _pat2,U                      ; pattern second vector is visible 
                    leau     6,u 
                    inc      clip_test                    ; now != 0 -> visible 
                    BRA      nextVector_nstop43 


done_nstop43 
                    sta      ,u                           ; last positibe must be stored! 
                    rts      


EXPONENT            =        0                            ; #noDoubleWarn 
;-------------------------------------------------------------------------------------------
EXACT               =        1                            ; #noDoubleWarn 
EXACT               =        0                            ; #noDoubleWarn 
;-------------------------------------------------------------------------------------------

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

; include line ->                     include  "displayWorldCompiledClippedLookAheadInline.asm"
; TODO
; at the moment  tile pos (coarse/fine)
; AND
; tile screen pos (displayx/displayy) both is tested for display
; one for lower, one for upper bound
; only one should really be needed

; TODO
; init test values
; than we can add x/y fine to display right from start
; and do not have to do that with every single printed tile!
;
; facts:
; displays level with x-1 width instead of  x, last row is truncated as of now
; displays level with y-1 width instead of  y, last column is truncated as of now
X_ENTRY_LENGTH      =        5                            ; each x entry has a length of four bytes + one position 
;***************************************************************************
;***************************************************************************

;***************************************************************************
; use U instead of X to save a cycle?
; puls d vs ldd ,x [7] <-> [8]

displaylevelDone: 
                    puls     d,pc                         ; correct stack and return 
;***************************************************************************
;
; the general idea to draw the world with clipped tiles goes:
; drawing 3 parts
; top clipped
; middle part
; bottom clipped
;
; within each part left and right clips are done seperately
; there is a right/left and vertical buffer
; if the same kind of types come in a row - they only need to be clipped once!
;***************************************************************************
displayFixedWorld_Clipped 
                    clra     
                    sta      verticalBuffer 
                    sta      horizontalLeftBuffer 
                    sta      horizontalRightBuffer 
                    lda      #END_POS_VERTICAL 
                    adda     yFine 
                    sta      endVerticalcompare 

; INIT clip Pos
;
; clipping is done in positions of tile strength
; tile strengths are 2,4,8,16,32,64,128
; (128 represented by 127) 
; so we take the max, == 128
; xfine or yfine is in resolution of screen tile size, which is TILE_WIDTH or TILE_HEIGHT
; which will be quite different
; translation is 128/TILE_WIDTH and 128/TILE_HEIGHT per step
;
; clip = xfine * (128/TILE_WIDTH)
; in the final version idealy 128/TILE_WIDTH is one of 2,4,8,16,32... than wie can do simple lsl
; for now we do a mul to be exact
;
                                                          ; clip initialized adjusted in move handle 
;
; TODO
; init test values
; than we cann add x/y fine to display right from start
; and do not have to do that with every single printed tile!
; if I place +- tile height
; I am able to add/subtract to the coordinates for scrolling!
; if I use the full size
; adding/subtracting will result in carry flags...
                    ldd      #START_POS 
                    adda     yFine 
                    std      displayPosY 
                    ldy      #lines1                      ; table of tile map horizontal data 
                    ldd      yCoarse                      ; the position within the level that is displayed 
                    lsla                                  ; two times because of word pointers 
                    leay     a,y 
                    ldy      ,y                           ; load address of first coarse line 
                    ldu      ,y++                         ; load address of next coarse line 
                    pshs     u                            ; store next on stack 
;---------------------------------------------------------------------------------------------
; PART ONE TOP CLIPPED
;---------------------------------------------------------------------------------------------
                    stb      xCoarseCheck                 ; coarse check represents the last printed position 
                                                          ; y points to first "X" data in a line 

                    tst      yFine 
                    lbeq     keepLookingCenter            ; if yFine is 0 than no top clip necessary - we can jump to center display right away 

keepLookingTop 
                    ldb      ,y                           ; load position of tile 
                    lbmi     lineEndFoundTop              ; if negative, line is finished 
                    cmpb     xCoarseCheck                 ; if higher coarsecheck, than potentially this tile can be printed 
                    bge      xStartFoundTop               ; jump if "printable" 
xNotEndOfLineFoundTop 
seekNextTopClippedTileTop 
                    leay     X_ENTRY_LENGTH,y             ; otherwise increase y with length of one "x" entry 
                    bra      keepLookingTop               ; and keep on looking for a tile 


xStartFoundTop 
; test if x pos higher display width
                    subb     xCoarse                      ; determine screen position by reducing the current start position in level display 
                    cmpb     #FULL_TILES_HORIZONTAL 
                    lbhi     lineEndFoundTop              ; if wider than one display size, jump to next line (out of top line) 
                    lda      3,y                          ; load end position of tile 
                    sta      xCoarseCheck                 ; to the xCoarse check 
; todo possibly test if  
; tile size is larger than display witdh, possibly shorten to only display a "partial" tile
; in b the tile position of the tile 
;
; now calculate the display position, multiply with "tile width" 
; here display top clipped tile 
; and adjust position with the actual start position of our display 
; realized as lookup table. since the muls are fix
                    ldu      #xPosLookup 
                    ldb      b,u 
                    stb      displayPosX                  ; this will be our x position on screen 
; macro call ->                     _SCALE   SCALE_MOVE                   ; scale for move 
                    LDA      #SCALE_MOVE                  ; scale for placing first point 
; macro call ->                     _SCALE_A  
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    lda      displayPosY 
                    subb     xFine 
; macro call ->                     MY_MOVE_TO_D_START  
                    STA      <VIA_port_a                  ;Store Y in D/A register 
                    LDA      #$CE                         ;Blank low, zero high? 
                    STA      <VIA_cntl                    ; 
                    CLRA     
                    STA      <VIA_port_b                  ;Enable mux ; hey dis si "break integratorzero 440" 
                    STA      <VIA_shift_reg               ;Clear shift regigster 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ;enable timer 
; macro call ->  LOAD_TILE_VLIST
                    ldx      1,y                          ; address of vectorlist 
                    lda      -3,x 
                    beq      endTileListLoad49 
                    ldu      #counter0 
                    lda      a,u 
                                                          ; in a the current animation counter of correct length 
                    lsla     
                    ldx      a,x 

                                                          ; in a number of animation steps of tile list 
endTileListLoad49 
; DO CLIPPING AND CHANGE OF VLIST HERE

; we buffer clipped vectors, if two same vlists are the same -> reuse the buffer
                    lda      -2,x                         ; id of vector 
                    cmpa     verticalBuffer 
                    beq      topBufferUsed 
                    sta      verticalBuffer 
                    LDU      #clipped_vector_vertical     ; address of result list 
                    lda      -1,x                         ; type of vectorlist 
                    sta      -1,u                         ; remember type, since for left/right we might need it, and it must be at vlist start -1 
                    bne      fullClipp_top                ; no -> full clip 
                    ldd      topclip                      ; place where to clip 
; macro call ->                     SIMPLE_CLIP_TOP  
                    jsr      clip_vlp_stop 
                    bra      easyClipDone_top 


fullClipp_top 
                    ldd      topclip                      ; place where to clip 
; macro call ->                     EXPONENT_CLIP_TOP  
                    jsr      clip_vlp_p2_top 
easyClipDone_top 
topBufferUsed 
                    LDX      #clipped_vector_vertical     ; use the just generated vlist as source 
; ---- top clip end
; exits with X pointing to current vlist
noTopClipNeccessary: 
; here test for left/right clip!
; first test left
                    ldb      displayPosX 
                    cmpb     #START_POS_HORIZONTAL        ; test if there is a left clip tile possible! 
                    bne      noLeftClip_top 
                    tst      xFine 
                    beq      noLeftClip_top 
; this is a corner piece, also clip left!
; D = clipping place (in scale of added strengths of vector X positions)
; X = Vector list to clip
; U = vectorlist to clip to
                    ldd      leftclip                     ; current clipping pos 
                    LDU      #clipped_vector_final        ; address of result list 
                    tst      -1,x                         ; is this an easy clip vector? 
                    bne      fullClipp_left_top           ; no -> full clip 
; macro call ->                     SIMPLE_CLIP_LEFT  
                    jsr      clip_vlp_nsleft 
                    bra      topLeftClipDone_top 


fullClipp_left_top 
; macro call ->                     EXACT_CLIP_LEFT  
                    jsr      clip_vlp_pExact_left 
topLeftClipDone_top 
                    LDx      #clipped_vector_final        ; address of result list 
; macro call ->                     DRAW_IT  
; macro call ->                     _SCALE   SCALE_VLIST 
                    LDA      #SCALE_VLIST                 ; scale for placing first point 
; macro call ->                     _SCALE_A  
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    LDA      #$80 
; macro call ->                     MY_MOVE_TO_B_END
                    LDB      #$40                         ; 
LF33D57:            BITB     <VIA_int_flags               ; 
                    BEQ      LF33D57 
                    jsr      myDraw_VL_mode2 
                    leay     X_ENTRY_LENGTH,y             ; otherwise increase y with length of one "x" entry 
                    jmp      keepLookingTop               ; and keep on looking for a tile 


;;;  multi tile up to three insert

xRightClip_Top_1tileAdd 
                    tst      xFine 
                    bne      really_right_Top_1tileAdd 
                    ldd      rightclip 
                    addd     #128-STEP_HORIZONTAL_TILE_IN_PIXEL 
                    bra      multiRightTop_cont 


really_right_Top_1tileAdd 
                    ldd      rightclip 
                    addd     #128                         ;TILE_WIDTH 
                    bra      multiRightTop_cont 


xRightClip_Top_2tileAdd 
                    tst      xFine 
                    bne      really_right_Top_2tileAdd 
                    ldd      rightclip 
                    addd     #256-STEP_HORIZONTAL_TILE_IN_PIXEL 
                    bra      multiRightTop_cont 

really_right_Top_2tileAdd 
                    ldd      rightclip 
                    addd     #256 
                    bra      multiRightTop_cont 


noLeftClip_top 
; now test for right
                    lda      4,y 
                    beq      noLeftClip_top_org 

                    cmpb     #END_POS_HORIZONTAL 
                    beq      xRightClip_top               ; check if X boundary 

addAnotherTileWidth_Top 
                    addb     #TILE_WIDTH 
                    cmpb     #END_POS_HORIZONTAL 
                    beq      xRightClip_Top_1tileAdd      ; check if X boundary 
                    deca     
                    beq      displayCont_top 
                    addb     #TILE_WIDTH 
                    cmpb     #END_POS_HORIZONTAL 
                    beq      xRightClip_Top_2tileAdd      ; check if X boundary 
; max width of multi tile is 2, so only two tests 
                    bra      displayCont_top 

;;;

noLeftClip_top_org: 
; now test for right
                    cmpb     #END_POS_HORIZONTAL 
                    beq      xRightClip_top               ; check if X boundary 
displayCont_top 
; macro call ->                     DRAW_IT  
; macro call ->                     _SCALE   SCALE_VLIST 
                    LDA      #SCALE_VLIST                 ; scale for placing first point 
; macro call ->                     _SCALE_A  
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    LDA      #$80 
; macro call ->                     MY_MOVE_TO_B_END
                    LDB      #$40                         ; 
LF33D61:            BITB     <VIA_int_flags               ; 
                    BEQ      LF33D61 
                    jsr      myDraw_VL_mode2 
                    leay     X_ENTRY_LENGTH,y             ; otherwise increase y with length of one "x" entry 
                    jmp      keepLookingTop               ; and keep on looking for a tile 


xRightClip_top 
                    tst      xFine 
                    bne      really_right_top 
                    ldd      #$0a00                       ; make sure ramping is disabled 
                    std      VIA_t1_cnt_lo                ; disable ramping 
; macro call ->                     _ZERO_VECTOR_BEAM                     ; and we go to zero 
                    LDB      #$CC 
                    STB      <VIA_cntl                    ;/BLANK low and /ZERO low 
                    bra      lineEndFoundTop              ; incTilePos_top 


really_right_top: 
; this is a corner piece, also clip right!
; D = clipping place (in scale of added strengths of vector X positions)
; X = Vector list
                    ldd      rightclip 
multiRightTop_cont 
                    LDU      #clipped_vector_final        ; address of result list 
                    tst      -1,x                         ; is this an easy clip vector? 
                    bne      fullClipp_right_top          ; no -> full clip 
; macro call ->                     SIMPLE_CLIP_RIGHT  
                    jsr      clip_vlp_nsright 
                    bra      easyRightClipDone_top 


fullClipp_right_top 
; macro call ->                     EXACT_CLIP_RIGHT  
                    jsr      clip_vlp_pExact_right 
easyRightClipDone_top 
                    LDx      #clipped_vector_final        ; address of result list 
; draw it and go to center
; macro call ->                     DRAW_IT  
; macro call ->                     _SCALE   SCALE_VLIST 
                    LDA      #SCALE_VLIST                 ; scale for placing first point 
; macro call ->                     _SCALE_A  
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    LDA      #$80 
; macro call ->                     MY_MOVE_TO_B_END
                    LDB      #$40                         ; 
LF33D68:            BITB     <VIA_int_flags               ; 
                    BEQ      LF33D68 
                    jsr      myDraw_VL_mode2 
;---------------------------------------------------------------------------------------------
lineEndFoundTop 
                    ldy      ,s                           ; on stack the beginning of the next line 
                    ldx      ,y++ 
                    stx      ,s 
;---------------------------------------------------------------------------------------------
; PART CENTER TILES
;---------------------------------------------------------------------------------------------
noTopClipDisplayEntry 
nextCenterLine 
                    lda      displayPosY                  ; go down one y position (here always one tile height) 
                    suba     #TILE_HEIGHT 
                    sta      displayPosY 
continueCenterNextLine 
                    ldb      xCoarse 
                    stb      xCoarseCheck 
                                                          ; y points to first "X" data in a line 
                                                          ; 
                                                          ; destroys x 
                                                          ; "returns" with y pointing to first x entry in whatever line 
                                                          ; displayPosY is correctly updated 
keepLookingCenter 
                    ldb      ,y                           ; load position of tile 
                    bmi      lineEndFoundCenter           ; check if line is finished, on negative -> yes branch 
                    cmpb     xCoarseCheck                 ; compare to current coarse position 
                    bge      xStartFoundCenter            ; if higher than current coarse, than print it (potentially) 
xNotEndOfLineFoundCenter 
seekNextCenterTile 
                    leay     X_ENTRY_LENGTH,y             ; increase level pointer by one X position size 
                    bra      keepLookingCenter            ; and check next entry 


lineEndFoundCenter 
                    lda      displayPosY                  ; go down one y position (here always one tile height) 
                    suba     #TILE_HEIGHT 
                    sta      displayPosY 
                    cmpa     endVerticalcompare           ; check if we approach last line 
                    lbeq     startBottomLine              ; if so - branch 
seekInNextLineCenter: 
                    ldy      ,s                           ; on stack the beginning of the next line 
                    lbmi     displaylevelDone             ; if next line is -1 than we are completly done 
                    ldx      ,y++                         ; load pointer of next line, and increase to line start 
                    stx      ,s                           ; store to stack 
                    bra      continueCenterNextLine       ; and start checking next line 


xStartFoundCenter                                         ;        here we reach if there is a printable tile 

; first time round only
; TODO optimize tile info to not "add" but sum instead!
                    lda      3,y                          ; load position of tile 
                    sta      xCoarseCheck 
; test if x pos higher display width
                    subb     xCoarse                      ; calculate correct screen posiiton in tiles 
                    cmpb     #FULL_TILES_HORIZONTAL       ; if larger than possibly displayed 
                    bhi      lineEndFoundCenter           ; go to next line 
; here display tile is an actual fact
; todo possibly test if  
 
; tile size is larger than display witdh, possibly shorten to only display a "partial" tile
; in b the tile position of the tile 
;
; now calculate the display position, multiply with "tile width" 
; here display bottom clipped tile 
; and adjust position with the actual start position of our display 
; realized as lookup table. since the muls are fix
                    ldu      #xPosLookup 
                    ldb      b,u 
                    stb      displayPosX                  ; this will be our x position on screen 
; in displayPosY/displayPosY the next position (without xFine/yFine)
; macro call ->                     _SCALE   SCALE_MOVE                   ; scale for move 
                    LDA      #SCALE_MOVE                  ; scale for placing first point 
; macro call ->                     _SCALE_A  
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    lda      displayPosY 
                    subb     xFine 
display_center_start 
; macro call ->                     MY_MOVE_TO_D_START  
                    STA      <VIA_port_a                  ;Store Y in D/A register 
                    LDA      #$CE                         ;Blank low, zero high? 
                    STA      <VIA_cntl                    ; 
                    CLRA     
                    STA      <VIA_port_b                  ;Enable mux ; hey dis si "break integratorzero 440" 
                    STA      <VIA_shift_reg               ;Clear shift regigster 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ;enable timer 
; macro call ->  LOAD_TILE_VLIST
                    ldx      1,y                          ; address of vectorlist 
                    lda      -3,x 
                    beq      endTileListLoad72 
                    ldu      #counter0 
                    lda      a,u 
                                                          ; in a the current animation counter of correct length 
                    lsla     
                    ldx      a,x 

                                                          ; in a number of animation steps of tile list 
endTileListLoad72 
; here we are "in move" check for clipping and do the clip, left/none/right
; first test left

;noTopClipNeccessary_ever

                    ldb      displayPosX 
                    cmpb     #START_POS_HORIZONTAL        ; test if there is a left clip tile possible! 
                    lbne     noLeftClip_center 
                    tst      xFine 
                    lbeq     noLeftClip_center 
                    lda      -2,x                         ; id of vector 
                    cmpa     horizontalLeftBuffer 
                    bne      startclip_center 
 
                    LDx      #clipped_vector_left         ; address of result list 
                    jmp      displayCont_center 


startclip_center: 
                    sta      horizontalLeftBuffer 
                    ldd      leftclip 
                    LDU      #clipped_vector_left         ; address of result list 
; clip left!
; D = clipping place (in scale of added strengths of vector X positions)
; X = Vector list to clip
; U = target of clipping
                    tst      -1,x                         ; is this an easy clip vector? 
                    bne      fullClipp_left_center        ; no -> full clip 
; macro call ->                     SIMPLE_CLIP_LEFT  
                    jsr      clip_vlp_nsleft 
                    LDx      #clipped_vector_left         ; address of result list 
                    bra      displayCont_center 


fullClipp_left_center 
; macro call ->                     EXPONENT_CLIP_LEFT  
                    jsr      clip_vlp_p2_left 
                    LDx      #clipped_vector_left         ; address of result list 
                    bra      displayCont_center 


xRightClip_center 
                    tst      xFine 
                    bne      really_right_center 
                    ldd      #$0a00                       ; make sure ramping is disabled 
                    std      VIA_t1_cnt_lo                ; disable ramping 
; macro call ->                     _ZERO_VECTOR_BEAM                     ; and we go to zero 
                    LDB      #$CC 
                    STB      <VIA_cntl                    ;/BLANK low and /ZERO low 
                    jmp      lineEndFoundCenter           ; incTilePos 


really_right_center 
                    ldd      rightclip 
multiRightcenter_cont 
                    LDU      #clipped_vector_right        ; address of result list 
; clip right!
; D = clipping place (in scale of added strengths of vector X positions)
; X = Vector list to clip
; U = target of clipping
                    tst      -1,x                         ; is this an easy clip vector? 
                    bne      fullClipp_right_center       ; no -> full clip 
; macro call ->                     SIMPLE_CLIP_RIGHT  
                    jsr      clip_vlp_nsright 
                    bra      easyRightClipDone_center 


fullClipp_right_center 
; macro call ->                     EXPONENT_CLIP_RIGHT  
                    jsr      clip_vlp_p2_right 
easyRightClipDone_center 
                    LDx      #clipped_vector_right        ; address of result list 
                    ldd      displayPosY 
                    subb     xFine 
                    bra      displayCont_center 

 
;  multi tile up to three insert

xRightClip_center_1tileAdd 
                    tst      xFine 
                    bne      really_right_center_1tileAdd 
                    ldd      rightclip 
                    addd     #128-STEP_HORIZONTAL_TILE_IN_PIXEL 
                    bra      multiRightcenter_cont 


really_right_center_1tileAdd 
                    ldd      rightclip 
                    addd     #128                         ;TILE_WIDTH 
                    bra      multiRightcenter_cont 


xRightClip_center_2tileAdd 
                    tst      xFine 
                    bne      really_right_center_2tileAdd 
                    ldd      rightclip 
                    addd     #256-STEP_HORIZONTAL_TILE_IN_PIXEL 
                    bra      multiRightcenter_cont 

really_right_center_2tileAdd 
                    ldd      rightclip 
                    addd     #256 
                    bra      multiRightcenter_cont 


;  multi tile up to three insert end
noLeftClip_center 
; now test for right
                    lda      4,y 
                    beq      noLeftClip_center_org 

extraMultiTileTest_Center 
                    cmpb     #END_POS_HORIZONTAL 
                    beq      xRightClip_center            ; check if X boundary 
addAnotherTileWidth_Center 
                    addb     #TILE_WIDTH 
                    cmpb     #END_POS_HORIZONTAL 
                    beq      xRightClip_center_1tileAdd   ; check if X boundary 
                    deca     
                    beq      displayCont_center 
                    addb     #TILE_WIDTH 
                    cmpb     #END_POS_HORIZONTAL 
                    beq      xRightClip_center_2tileAdd   ; check if X boundary 
                    bra      displayCont_center 

; max width of multi tile is 2, so only two tests 

noLeftClip_center_org 

                    cmpb     #END_POS_HORIZONTAL 
                    beq      xRightClip_center            ; check if X boundary 

displayCont_center 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; next time there will be use of the look ahead calculations
; this part realizes the center "in move" look ahead - start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
seekNextCenterTile_inner 
                    leay     X_ENTRY_LENGTH,y             ; increase level pointer by one X position size 
keepLookingCenter_inner 
                    ldb      ,y                           ; load position of tile 
                    bmi      lineEndFoundCenter_inner     ; check if line is finished, on negative -> yes branch 
                    cmpb     xCoarseCheck                 ; compare to current coarse position 
                    blo      seekNextCenterTile_inner     ; if higher than current coarse, than print it 
xStartFoundCenter_inner                                   ;   here we reach if there is a printable tile 
                    lda      3,y                          ; load position of tile 
                    sta      xCoarseCheck 
; test if x pos higher display width
                    subb     xCoarse                      ; calculate correct screen posiiton in tiles 
                    cmpb     #FULL_TILES_HORIZONTAL       ; if larger than possibly displayed 
                    bhi      lineEndFoundCenter_inner     ; go to next line 
; here display tile next is an actual fact
;
; now calculate the display position, multiply with "tile width" 
; here display bottom clipped tile 
; and adjust position with the actual start position of our display 
; realized as lookup table. since the muls are fix
                    ldu      #xPosLookup 
                    ldb      b,u 
                    stb      displayPosX                  ; this will be our x position on screen 
                    lda      displayPosY 
                    subb     xFine 
                    std      nextDisplayPos 
; jmp to display
; macro call ->                     DRAW_IT  
; macro call ->                     _SCALE   SCALE_VLIST 
                    LDA      #SCALE_VLIST                 ; scale for placing first point 
; macro call ->                     _SCALE_A  
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    LDA      #$80 
; macro call ->                     MY_MOVE_TO_B_END
                    LDB      #$40                         ; 
LF33D81:            BITB     <VIA_int_flags               ; 
                    BEQ      LF33D81 
                    jsr      myDraw_VL_mode2 
; macro call ->                     _SCALE   SCALE_MOVE                   ; scale for move 
                    LDA      #SCALE_MOVE                  ; scale for placing first point 
; macro call ->                     _SCALE_A  
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    ldd      nextDisplayPos 
; nop 10
                    jmp      display_center_start 


lineEndFoundCenter_inner 
                    lda      displayPosY                  ; go down one y position (here always one tile height) 
                    suba     #TILE_HEIGHT 
                    sta      displayPosY 
                    cmpa     endVerticalcompare           ; check if we approach last line 
                    beq      goBottom_inner               ; if so - branch (out of macro) 
;seekInNextLineCenter: 
                    ldy      ,s                           ; on stack the beginning of the next line 
                    bmi      goFinished_inner             ; if next line is -1 than we are completly done 
                    ldd      ,y++                         ; load pointer of next line, and increase to line start 
                    std      ,s                           ; store to stack 
;continueCenterNextLine 
                    ldb      xCoarse 
                    stb      xCoarseCheck 
                                                          ; y points to first "X" data in a line 
                                                          ; 
                                                          ; destroys x 
                                                          ; "returns" with y pointing to first x entry in whatever line 
                                                          ; displayPosY is correctly updated 
                    bra      keepLookingCenter_inner 


goBottom_inner 
; macro call ->                     DRAW_IT  
; macro call ->                     _SCALE   SCALE_VLIST 
                    LDA      #SCALE_VLIST                 ; scale for placing first point 
; macro call ->                     _SCALE_A  
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    LDA      #$80 
; macro call ->                     MY_MOVE_TO_B_END
                    LDB      #$40                         ; 
LF33D87:            BITB     <VIA_int_flags               ; 
                    BEQ      LF33D87 
                    jsr      myDraw_VL_mode2 
                    bra      startBottomLine              ; if so - branch (out of macro) 


goFinished_inner 
; macro call ->                     DRAW_IT  
; macro call ->                     _SCALE   SCALE_VLIST 
                    LDA      #SCALE_VLIST                 ; scale for placing first point 
; macro call ->                     _SCALE_A  
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    LDA      #$80 
; macro call ->                     MY_MOVE_TO_B_END
                    LDB      #$40                         ; 
LF33D91:            BITB     <VIA_int_flags               ; 
                    BEQ      LF33D91 
                    jsr      myDraw_VL_mode2 
                    jmp      displaylevelDone             ; if so - branch (out of macro) 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this part realizes the center "in move" look ahead - end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;---------------------------------------------------------------------------------------------
; PART BOTTOM TILES
;---------------------------------------------------------------------------------------------
startBottomLine 
                    clr      verticalBuffer               ; in preparation of bottom 
                    ldy      ,s                           ; on stack the beginning of the next line 
                    lbmi     displaylevelDone             ; if next line is -1 than we are completly done 
                    ldx      ,y++                         ; load pointer of next line, and increase to line start 
                    stx      ,s                           ; store to stack 
                    ldb      xCoarse 
                    stb      xCoarseCheck                 ; coarse check represents the last printed position 
                                                          ; y points to first "X" data in a line 
                                                          ; 
                                                          ; destroys x 
                                                          ; "returns" with y pointing to first x entry in whatever line 
                                                          ; displayPosY is correctly updated 
keepLookingBottom 
                    ldb      ,y                           ; load position of tile 
                    lbmi     displaylevelDone             ; if negative, line is finished, which on the bottom line also means display is finished 
                    cmpb     xCoarseCheck                 ; if higher coarsecheck, than potentially this tile can be printed 
                    bge      xStartFoundBottom            ; jump if "printable" 
xNotEndOfLineFoundBottom 
seekNextClippedTileBottom 
                    leay     X_ENTRY_LENGTH,y             ; otherwise increase y with length of one "x" entry 
                    bra      keepLookingBottom            ; and keep on looking for a tile 


xStartFoundBottom 
; TODO optimize tile info to not "add" but sum instead!
                    lda      3,y                          ; load position of tile 
                    sta      xCoarseCheck                 ; to the xCoarse check 
; test if x pos higher display width
                    subb     xCoarse                      ; determine screen position by reducing the current start position in level display 
                    cmpb     #FULL_TILES_HORIZONTAL 
                    lbhi     displaylevelDone             ; if wider than one display size, which on the bottom line also means display is finished 
; todo possibly test if  
; tile size is larger than display witdh, possibly shorten to only display a "partial" tile
; in b the tile position of the tile 
;
; now calculate the display position, multiply with "tile width" 
; here display bottom clipped tile 
; and adjust position with the actual start position of our display 
; realized as lookup table. since the muls are fix
                    ldu      #xPosLookup 
                    ldb      b,u 
                    stb      displayPosX                  ; this will be our x position on screen 
; in displayPosY/displayPosX the next position (without yFine/xFine)
; macro call ->                     _SCALE   SCALE_MOVE                   ; scale for move 
                    LDA      #SCALE_MOVE                  ; scale for placing first point 
; macro call ->                     _SCALE_A  
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    lda      displayPosY 
                    subb     xFine 
; macro call ->                     MY_MOVE_TO_D_START  
                    STA      <VIA_port_a                  ;Store Y in D/A register 
                    LDA      #$CE                         ;Blank low, zero high? 
                    STA      <VIA_cntl                    ; 
                    CLRA     
                    STA      <VIA_port_b                  ;Enable mux ; hey dis si "break integratorzero 440" 
                    STA      <VIA_shift_reg               ;Clear shift regigster 
                    INC      <VIA_port_b                  ;Disable mux 
                    STB      <VIA_port_a                  ;Store X in D/A register 
                    STA      <VIA_t1_cnt_hi               ;enable timer 
; DO CLIPPING AND CHANGE OF VLIST HERE
; ---- bottom clip start
                    tst      yFine 
                    lbeq     levelDoneBottom 
; we buffer clipped vectors, if two same vlists are the same -> reuse the buffer
; macro call ->  LOAD_TILE_VLIST
                    ldx      1,y                          ; address of vectorlist 
                    lda      -3,x 
                    beq      endTileListLoad95 
                    ldu      #counter0 
                    lda      a,u 
                                                          ; in a the current animation counter of correct length 
                    lsla     
                    ldx      a,x 

                                                          ; in a number of animation steps of tile list 
endTileListLoad95 

                    lda      -2,x                         ; id of vector 
                    cmpa     verticalBuffer 
                    beq      bottomBufferUsed 
                    sta      verticalBuffer 
                    LDU      #clipped_vector_vertical     ; address of result list 
                    lda      -1,x                         ; type of vectorlist 
                    sta      -1,u                         ; remember type, since for left/right we might need it, and it must be at vlist start -1 
                    bne      fullClipp_bottom             ; no -> full clip 
                    ldd      bottomclip                   ; place where to clip 
; macro call ->                     SIMPLE_CLIP_BOTTOM  
                    jsr      clip_vlp_sbottom 
                    bra      easyClipDone_bottom 


fullClipp_bottom 
                    ldd      bottomclip                   ; place where to clip 
; macro call ->                     EXPONENT_CLIP_BOTTOM  
                    jsr      clip_vlp_p2_bottom 
easyClipDone_bottom 
bottomBufferUsed 
                    LDX      #clipped_vector_vertical     ; use the just generated vlist as source 
; ---- bottom clip end
; exits with X pointing to current vlist
;noBottomClipNeccessary: 
; here test for left/right clip!
; first test left
                    ldb      displayPosX 
                    cmpb     #START_POS_HORIZONTAL        ; test if there is a left clip tile possible! 
                    bne      noLeftClip_bottom 
                    tst      xFine 
                    beq      noLeftClip_bottom 
; this is a corner piece, also clip left!
; D = clipping place (in scale of added strengths of vector X positions)
; X = Vector list
                    ldd      leftclip 
                    LDU      #clipped_vector_final        ; address of result list 
                    tst      -1,x                         ; is this an easy clip vector? 
                    bne      fullClipp_left_bottom        ; no -> full clip 
; macro call ->                     SIMPLE_CLIP_LEFT  
                    jsr      clip_vlp_nsleft 
                    bra      leftClipDone_bottom 


fullClipp_left_bottom 
; macro call ->                     EXACT_CLIP_LEFT  
                    jsr      clip_vlp_pExact_left 
leftClipDone_bottom 
                    LDx      #clipped_vector_final        ; address of result list 
                    bra      displayCont_bottom 


;### multi tile up to three insert

;;;

xRightClip_bottom_1tileAdd 
                    tst      xFine 
                    bne      really_right_bottom_1tileAdd 
                    ldd      rightclip 
                    addd     #128-STEP_HORIZONTAL_TILE_IN_PIXEL 
                    bra      multiRightbottom_cont 


really_right_bottom_1tileAdd 
                    ldd      rightclip 
                    addd     #128                         ;TILE_WIDTH 
                    bra      multiRightbottom_cont 


xRightClip_bottom_2tileAdd 
                    tst      xFine 
                    bne      really_right_bottom_2tileAdd 
                    ldd      rightclip 
                    addd     #256-STEP_HORIZONTAL_TILE_IN_PIXEL 
                    bra      multiRightbottom_cont 

really_right_bottom_2tileAdd 
                    ldd      rightclip 
                    addd     #256 
                    bra      multiRightbottom_cont 


noLeftClip_bottom 
; now test for right
                    lda      4,y 
                    beq      noLeftClip_bottom_org 

                    cmpb     #END_POS_HORIZONTAL 
                    beq      xRightClip_bottom            ; check if X boundary 

addAnotherTileWidth_bottom 
                    addb     #TILE_WIDTH 
                    cmpb     #END_POS_HORIZONTAL 
                    beq      xRightClip_bottom_1tileAdd   ; check if X boundary 
                    deca     
                    beq      displayCont_bottom 
                    addb     #TILE_WIDTH 
                    cmpb     #END_POS_HORIZONTAL 
                    beq      xRightClip_bottom_2tileAdd   ; check if X boundary 
                    bra      displayCont_bottom 

; max width of multi tile is 2, so only two tests 

;;;

;###

noLeftClip_bottom_org: 
; now test for right
                    cmpb     #END_POS_HORIZONTAL 
                    beq      xRightClip_bottom            ; check if X boundary 
displayCont_bottom 
; macro call ->                     DRAW_IT  
; macro call ->                     _SCALE   SCALE_VLIST 
                    LDA      #SCALE_VLIST                 ; scale for placing first point 
; macro call ->                     _SCALE_A  
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    LDA      #$80 
; macro call ->                     MY_MOVE_TO_B_END
                    LDB      #$40                         ; 
LF33D103:           BITB     <VIA_int_flags               ; 
                    BEQ      LF33D103 
                    jsr      myDraw_VL_mode2 
                    leay     X_ENTRY_LENGTH,y             ; otherwise increase y with length of one "x" entry 
                    jmp      keepLookingBottom            ; and keep on looking for a tile 


xRightClip_bottom 
                    tst      xFine 
                    bne      really_right_bottom 
levelDoneBottom 
                    ldd      #$0a00                       ; make sure ramping is disabled 
                    std      VIA_t1_cnt_lo                ; disable ramping 
; macro call ->                     _ZERO_VECTOR_BEAM                     ; and we go to zero 
                    LDB      #$CC 
                    STB      <VIA_cntl                    ;/BLANK low and /ZERO low 
                    jmp      displaylevelDone             ; incTilePos_bottom, which on the bottom line also means display is finished 


really_right_bottom: 
; this is a corner piece, also clip right!
; D = clipping place (in scale of added strengths of vector X positions)
; X = Vector list
                    ldd      rightclip 
multiRightbottom_cont 
                    LDU      #clipped_vector_final        ; address of result list 
                    tst      -1,x                         ; is this an easy clip vector? 
                    bne      fullClipp_right_bottom       ; no -> full clip 
; macro call ->                     SIMPLE_CLIP_RIGHT  
                    jsr      clip_vlp_nsright 
                    bra      easyRightClipDone_bottom 


fullClipp_right_bottom 
; macro call ->                     EXACT_CLIP_RIGHT  
                    jsr      clip_vlp_pExact_right 
easyRightClipDone_bottom 
                    LDx      #clipped_vector_final        ; address of result list 
                    ldd      displayPosY 
                    subb     xFine 
; macro call ->                     DRAW_IT  
; macro call ->                     _SCALE   SCALE_VLIST 
                    LDA      #SCALE_VLIST                 ; scale for placing first point 
; macro call ->                     _SCALE_A  
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    LDA      #$80 
; macro call ->                     MY_MOVE_TO_B_END
                    LDB      #$40                         ; 
LF33D110:           BITB     <VIA_int_flags               ; 
                    BEQ      LF33D110 
                    jsr      myDraw_VL_mode2 
; and jump to exit, bottom right -> == finish
                    jmp      displaylevelDone             ; incTilePos_bottom, which on the bottom line also means display is finished 


; the general idea to draw the world with clipped tiles goes:
; drawing 3 parts
; top clipped
; middle part
; bottom clipped
;
; top/bottom
; in these lines 2 tiles (corner pieces) may be clipped two times
;
; clipping
; for each clipping direction top/bottom/left/right
; four different optimized routines exist:
; a) exact clip - all vectors can be clipped regardless of any size/position (only used atm for the second corner clips)
;    this is by far the slowest
; b) exponent clip - here each vector of a list must be one of 2,4,8,16,32,64,128 sizes (127=128)
;    if these criteria is met, division within the clip routines is done via "easy" asr...
; c) simple clipping - here each x,y pair of coordinates in a vectorlist must have one of its values zero
;    if this is the case clipping can be done WITHOUT any divide - this is the fastest
;    for easy "visiblily" - all rectangles are "simple"!
;
; clipping - when needed is executed in the "move" section of the tile print
; but usually takes longer than the actual move, so here is "loss"
;
; for center tiles (tiles without top/bottom clipping) the moveTo section is used to "look ahead", and locate the next
; possible tile
;
; within each part left and right clips are done seperately
; there is a right/left and vertical buffer
; if the same kind of types come in a row - they only need to be clipped once!
; 
; the tilemap is "compiled" to be more "condensed"
; only the actual tiles are kept in a level, along with its "x"-position
; each level has a list of "horizontal" tile definitions
; so the actual y coordinate within the tile map can easily be calculated (as word pointers)
;
; within one line the tile is searched via "tile" coordinates, till the first displayable tile is found
; than all tiles are displayed till line end - or the new tile is "out of display bounds" than the next line begins
; 
; within the routine, the next line address is always stored on the stack, so it can be easily found
;
; while displaying tiles horizontally a tile can have a horizontal size, 
; so in horizontal directions tiles can be larger than one tile position, that way
; one can save positionings and draw "larger" portions in one go, this
; comes at the expanse of more clipping on the edges
;
; big tiles (larger than one tile posiion) must have "left split children". Meaning if a tile is e.g. has a width of
; 3 tiles, than there must be defined actually 3 tiles, one with a size of 3 
; one with a size of two and one with a size of one
; each shorter tile is a left-clipped (one/two complete tiles clipped away) version of the larger tile
; the tile map must be build this way
; meaning, if the sign "3" denotes the tile with a width of three, and "2" denotes the two width tile, 
; and "1" the one width tile, the
; original level definition must look look like "321".
; the tile definition must be such, that the "3" tile is definted with a width of 3, "2" width of 2 and  "1" one.
; if the tile is fully displayed, the 3 of the "3" is added to the horizontal coordinates, so the following two
; tiles are not displayed at all.
; when the level is scrolled that only the "21" is visible, the 3 automatically gets skipped, because it is "out of bounds"
; so the "2" kicks in and so on...
; include "displayWorldCompiledClippedLookAhead.asm"
; include "displayWorldCompiledClipped.asm"
;***************************************************************************
; DATA SECTION
;***************************************************************************
;***************************************************************************

xPosLookup 
                    db       (0*TILE_WIDTH)+START_POS_HORIZONTAL 
                    db       (1*TILE_WIDTH)+START_POS_HORIZONTAL 
                    db       (2*TILE_WIDTH)+START_POS_HORIZONTAL 
                    db       (3*TILE_WIDTH)+START_POS_HORIZONTAL 
                    db       (4*TILE_WIDTH)+START_POS_HORIZONTAL 
                    db       (5*TILE_WIDTH)+START_POS_HORIZONTAL 
                    db       (6*TILE_WIDTH)+START_POS_HORIZONTAL 
                    db       (7*TILE_WIDTH)+START_POS_HORIZONTAL 
                    db       (8*TILE_WIDTH)+START_POS_HORIZONTAL 
                    db       (9*TILE_WIDTH)+START_POS_HORIZONTAL 
                    db       (10*TILE_WIDTH)+START_POS_HORIZONTAL 
                    db       (11*TILE_WIDTH)+START_POS_HORIZONTAL 
                    db       (12*TILE_WIDTH)+START_POS_HORIZONTAL 
                    db       (13*TILE_WIDTH)+START_POS_HORIZONTAL 
                    db       (14*TILE_WIDTH)+START_POS_HORIZONTAL 
                    db       (15*TILE_WIDTH)+START_POS_HORIZONTAL 
                    db       (16*TILE_WIDTH)+START_POS_HORIZONTAL 
                    db       (17*TILE_WIDTH)+START_POS_HORIZONTAL 
                    db       (18*TILE_WIDTH)+START_POS_HORIZONTAL 
                    db       (19*TILE_WIDTH)+START_POS_HORIZONTAL 

; include line ->                     include  "tileDef1.i"
; 
BLOCK_SIZE          equ      4 
; all of these start at the lower left corner

; "exponential" tiles have strengths of 2 exponentials
; 127 = 128
; 
BLOCK_MAX           =        127 
BLOCK_HALF          =        64 
BLOCK_QUARTER       =        32 
BLOCK_SMALL         =        16 
BLOCK_MIN           =        8 

; tile macro
; dw address of tile in lo/hi
; width of tile in "char"

                    db       0                            ; animTileCount (ANIMATION) 
                    db       11,TYPE_SIMPLE               ; ID, clip type 
Trippling 
                    DB       $ff, +$00 * BLOCK_SIZE, BLOCK_MAX ; mode, y, x 
                    DB       $ff, +$00 * BLOCK_SIZE, BLOCK_MAX ; mode, y, x 
                    DB       $ff, +$00 * BLOCK_SIZE, BLOCK_MAX ; mode, y, x 
                    DB       $ff, +BLOCK_MAX, +$00 * BLOCK_SIZE ; mode, y, x 
                    DB       $ff, +$00 * BLOCK_SIZE, -BLOCK_MAX ; mode, y, x 
                    DB       $ff, +$00 * BLOCK_SIZE, -BLOCK_MAX ; mode, y, x 
                    DB       $ff, +$00 * BLOCK_SIZE, -BLOCK_MAX ; mode, y, x 
                    DB       $ff, -BLOCK_MAX, +$00 * BLOCK_SIZE ; mode, y, x 
                    DB       $01                          ; endmarker (1) 

;---------------------------------------------------------------------------
                    db       0                            ; animTileCount (ANIMATION) 
                    db       1,TYPE_SIMPLE                ; ID, clip type 
openRBlockList 
                    DB       $ff, +$00 * BLOCK_SIZE, BLOCK_MAX ; mode, y, x 
                    DB       $00, +BLOCK_MAX, +$00 * BLOCK_SIZE ; mode, y, x 
                    DB       $ff, +$00 * BLOCK_SIZE, -BLOCK_MAX ; mode, y, x 
                    DB       $ff, -BLOCK_MAX, +$00 * BLOCK_SIZE ; mode, y, x 
                    DB       $01                          ; endmarker (1) 

;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
                    db       0                            ; animTileCount (ANIMATION) 
                    db       2,TYPE_SIMPLE                ; ID, type 
openLRBlockList 
                    DB       $ff, +$00 * BLOCK_SIZE, +BLOCK_MAX ; mode, y, x 
                    DB       $00, +BLOCK_MAX, +$00 * BLOCK_SIZE ; mode, y, x 
                    DB       $ff, +$00 * BLOCK_SIZE, -BLOCK_MAX ; mode, y, x 

                    DB       $00, +$00 * BLOCK_SIZE, +BLOCK_MAX ; mode, y, x 
                    DB       $00, -BLOCK_MAX, +$00 * BLOCK_SIZE ; mode, y, x 

                    DB       $01                          ; endmarker (1) 
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
                    db       0                            ; animTileCount (ANIMATION) 
                    db       3,TYPE_SIMPLE                ; ID, type 
openLBlockList 
                    DB       $ff, +$00 * BLOCK_SIZE, +BLOCK_MAX ; mode, y, x 
                    DB       $ff, +BLOCK_MAX, +$00 * BLOCK_SIZE ; mode, y, x 
                    DB       $ff, +$00 * BLOCK_SIZE, -BLOCK_MAX ; mode, y, x 
                    DB       $01                          ; endmarker (1) 
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
; diagonals only allowed as 4,8,16,32,64
                    db       0                            ; animTileCount (ANIMATION) 
                    db       4, TYPE_EXPONENTIAL          ; ID, type 
testBlock 
                    DB       $00, +BLOCK_MAX, +BLOCK_MAX  ; pattern, y, x 
                    DB       $FF, -BLOCK_MAX, +$00*BLOCK_SIZE ; pattern, y, x 
                    DB       $FF, +$00*BLOCK_SIZE, -BLOCK_HALF ; pattern, y, x 
                    DB       $FF, +BLOCK_MAX, +$00*BLOCK_SIZE ; pattern, y, x 
                    DB       $FF, +$00*BLOCK_SIZE, -BLOCK_HALF ; pattern, y, x 
                    DB       $01                          ; endmarker (high bit in pattern not set) 
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
                    db       0                            ; animTileCount (ANIMATION) 
                    db       5,TYPE_SIMPLE                ; ID, type 
Square 
                    DB       $ff, +$00 * BLOCK_SIZE, BLOCK_MAX ; mode, y, x 
                    DB       $ff, +BLOCK_MAX, +$00 * BLOCK_SIZE ; mode, y, x 
                    DB       $ff, +$00 * BLOCK_SIZE, -BLOCK_MAX ; mode, y, x 
                    DB       $ff, -BLOCK_MAX, +$00 * BLOCK_SIZE ; mode, y, x 
                    DB       $01                          ; endmarker (1) 
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
                    db       0                            ; animTileCount (ANIMATION) 
                    db       6,TYPE_EXPONENTIAL           ; ID, type 
testPattern2: 
                    DB       $00, +BLOCK_MAX, +$00        ; pattern, y, x 
                    DB       $FF, -BLOCK_MIN, +BLOCK_SMALL ; pattern, y, x 
                    DB       $FF, -BLOCK_HALF, +BLOCK_HALF ; pattern, y, x 
                    DB       $FF, -BLOCK_HALF, +$00       ; pattern, y, x 
                    DB       $FF, +$00, +BLOCK_HALF       ; pattern, y, x 
                    DB       $01                          ; endmarker (high bit in pattern not set) 
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
                    db       0                            ; animTileCount (ANIMATION) 
                    db       7,TYPE_EXPONENTIAL           ; ID, type 
testPattern3: 
                    DB       $00, +BLOCK_MAX, +$00        ; pattern, y, x 
                    DB       $FF, -BLOCK_SMALL, +BLOCK_SMALL ; pattern, y, x 
                    DB       $FF, -BLOCK_HALF, +BLOCK_HALF ; pattern, y, x 
                    DB       $FF, -BLOCK_HALF, +$00       ; pattern, y, x 
                    DB       $FF, +$00, +BLOCK_HALF       ; pattern, y, x 
                    DB       $01                          ; endmarker (high bit in pattern not set) 
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
                    db       0                            ; animTileCount (ANIMATION) 
                    db       TYPE_DOUBLE_SCALE            ; multiTileCount 
                    db       20,TYPE_SIMPLE               ; ID, type 
openLRBlockList_double 
; same hight, double X
                    DB       $ff, +$00 * BLOCK_SIZE, +BLOCK_MAX ; mode, y, x 
                    DB       $00, +BLOCK_HALF, +$00 * BLOCK_SIZE ; mode, y, x 
                    DB       $ff, +$00 * BLOCK_SIZE, -BLOCK_MAX ; mode, y, x 
                    DB       $01                          ; endmarker (1) 
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
                    db       0                            ; animTileCount (ANIMATION) 
                    db       9, TYPE_EXPONENTIAL          ; ID, type 
testBlockDiaog 
                    DB       $ff, +BLOCK_MAX, +BLOCK_MAX  ; pattern, y, x 
                    DB       $FF, 0 , -BLOCK_MAX          ; pattern, y, x 
                    DB       $FF, -BLOCK_MAX, +BLOCK_MAX  ; pattern, y, x 
                    DB       $01                          ; endmarker (high bit in pattern not set) 
;---------------------------------------------------------------------------

;;;;;;;;;;;;;;
                    db       4                            ; animTileCount (ANIMATION), this is the number of the counter to be used, NOT the number of animation steps! 
                    db       -1,-1                        ; ID, type - irrelevant for multi tiles 
MultiTileTest: 
; DW AnimList_0 ; list of all single vectorlists in this
; DW AnimList_1
; DW AnimList_2
; DW AnimList_3
                    DW       StarFlashing_0               ; list of all single vectorlists in this 
                    DW       StarFlashing_1 
                    DW       StarFlashing_2 
                    DW       StarFlashing_3 
                    DW       StarFlashing_2 
                    DW       StarFlashing_1 

BLOW_UP             EQU      8 
                    db       10,TYPE_EXPONENTIAL          ; ID, type 
AnimList_0: 
                    DB       $FF, +$04*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$04*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$04*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$04*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $01                          ; endmarker (high bit in pattern not set) 

                    db       11,TYPE_EXPONENTIAL          ; ID, type 
AnimList_1: 
                    DB       $00, +$02*BLOW_UP, +$00*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$02*BLOW_UP, +$02*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$04*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$04*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$04*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$02*BLOW_UP, +$02*BLOW_UP ; pattern, y, x 
                    DB       $01                          ; endmarker (high bit in pattern not set) 

                    db       12,TYPE_EXPONENTIAL          ; ID, type 
AnimList_2: 
                    DB       $00, +$04*BLOW_UP, +$00*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$04*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$04*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$04*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$04*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $01                          ; endmarker (high bit in pattern not set) 

                    db       13,TYPE_EXPONENTIAL          ; ID, type 
AnimList_3: 
                    DB       $00, +$02*BLOW_UP, +$00*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$02*BLOW_UP, +$02*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$04*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$04*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$04*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$02*BLOW_UP, +$02*BLOW_UP ; pattern, y, x 
                    DB       $01                          ; endmarker (high bit in pattern not set) 

StarFlashing: 
                    DW       StarFlashing_0               ; list of all single vectorlists in this 
                    DW       StarFlashing_1 
                    DW       StarFlashing_2 
                    DW       StarFlashing_3 
                    DW       StarFlashing_2 
                    DW       StarFlashing_1 

                    db       14,TYPE_SIMPLE               ; ID, type 
StarFlashing_0: 
                    DB       $00, +$0C*BLOW_UP, +$00*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$00*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$04*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$04*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$00*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$04*BLOW_UP, -$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$04*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$00*BLOW_UP, -$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$04*BLOW_UP, -$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$04*BLOW_UP, -$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$00*BLOW_UP, -$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$04*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$04*BLOW_UP, -$04*BLOW_UP ; pattern, y, x 
                    DB       $01                          ; endmarker (high bit in pattern not set) 

                    db       15,TYPE_SIMPLE               ; ID, type 
StarFlashing_1: 
                    DB       $00, +$0A*BLOW_UP, +$04*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$00*BLOW_UP, +$02*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$02*BLOW_UP, +$02*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$02*BLOW_UP, +$02*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$00*BLOW_UP, +$02*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$02*BLOW_UP, -$02*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$02*BLOW_UP, +$02*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$00*BLOW_UP, -$02*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$02*BLOW_UP, -$02*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$02*BLOW_UP, -$02*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$00*BLOW_UP, -$02*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$02*BLOW_UP, +$02*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$02*BLOW_UP, -$02*BLOW_UP ; pattern, y, x 
                    DB       $01                          ; endmarker (high bit in pattern not set) 

                    db       16,TYPE_SIMPLE               ; ID, type 
StarFlashing_2: 
                    DB       $00, +$09*BLOW_UP, +$06*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$00*BLOW_UP, +$01*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$01*BLOW_UP, +$01*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$01*BLOW_UP, +$01*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$00*BLOW_UP, +$01*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$01*BLOW_UP, -$01*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$01*BLOW_UP, +$01*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$00*BLOW_UP, -$01*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$01*BLOW_UP, -$01*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$01*BLOW_UP, -$01*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$00*BLOW_UP, -$01*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$01*BLOW_UP, +$01*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$01*BLOW_UP, -$01*BLOW_UP ; pattern, y, x 
                    DB       $01                          ; endmarker (high bit in pattern not set) 

                    db       17,TYPE_SIMPLE               ; ID, type 
StarFlashing_3: 
                    DB       $00, +$09*BLOW_UP, +$07*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$00*BLOW_UP, +$02*BLOW_UP ; pattern, y, x 
                    DB       $FF, -$02*BLOW_UP, +$00*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$00*BLOW_UP, -$02*BLOW_UP ; pattern, y, x 
                    DB       $FF, +$02*BLOW_UP, +$00*BLOW_UP ; pattern, y, x 
                    DB       $01                          ; endmarker (high bit in pattern not set) 

;;;;;;;;;;;;;;

;BLOW_UP EQU 1

AnimList: 
                    DW       AnimList_0                   ; list of all single vectorlists in this 
                    DW       AnimList_1 
                    DW       AnimList_2 
                    DW       AnimList_3 
    
objectsPointers: 
                    dw       openRBlockList               ; 1 
                    dw       openLRBlockList              ; 2 
                    dw       openLBlockList               ; 3 
                    dw       testBlock                    ;4 
                    dw       Square                       ; 5 
                    dw       testPattern2                 ; 6 
                    dw       testPattern3                 ; 7 
; dw openLRBlockList_double ;8
                    dw       Trippling                    ; 8 
                    dw       testBlockDiaog               ; 9 
                    dw       MultiTileTest                ; ":" 
                    dw       MultiTileTest                ; ";" 
                    dw       MultiTileTest                ; "<" 
                    dw       MultiTileTest                ; "=" 
                    dw       MultiTileTest                ; ">" 
                    dw       MultiTileTest                ; "?" 
                    dw       MultiTileTest                ; "@" 
                    dw       MultiTileTest                ; A 
***********************************************************  
level0: 
                    db       80,80                        ; size y,x in ascii 
                    db       0,0                          ; start pos (middle) 
; include line ->                     include  "level1.i.asm"
levelCompiled1: 
line1_0: 
                    dw       line1_1                      ; next line start 
                    db       31 
; macro call ->  TILE_A (31)
                    db       hi(MultiTileTest), lo(MultiTileTest),((31)+1), 0 
                    db       -1                           ; end of line 
line1_1: 
                    dw       line1_2                      ; next line start 
                    db       10 
; macro call ->  TILE_A (10)
                    db       hi(MultiTileTest), lo(MultiTileTest),((10)+1), 0 
                    db       54 
; macro call ->  TILE_A (54)
                    db       hi(MultiTileTest), lo(MultiTileTest),((54)+1), 0 
                    db       -1                           ; end of line 
line1_2: 
                    dw       line1_3                      ; next line start 
                    db       -1                           ; end of line 
line1_3: 
                    dw       line1_4                      ; next line start 
                    db       2 
; macro call ->  TILE_5 (2)
                    db       hi(Square), lo(Square),((2)+1), 0 
                    db       3 
; macro call ->  TILE_5 (3)
                    db       hi(Square), lo(Square),((3)+1), 0 
                    db       7 
; macro call ->  TILE_5 (7)
                    db       hi(Square), lo(Square),((7)+1), 0 
                    db       8 
; macro call ->  TILE_5 (8)
                    db       hi(Square), lo(Square),((8)+1), 0 
                    db       11 
; macro call ->  TILE_5 (11)
                    db       hi(Square), lo(Square),((11)+1), 0 
                    db       12 
; macro call ->  TILE_5 (12)
                    db       hi(Square), lo(Square),((12)+1), 0 
                    db       13 
; macro call ->  TILE_5 (13)
                    db       hi(Square), lo(Square),((13)+1), 0 
                    db       14 
; macro call ->  TILE_5 (14)
                    db       hi(Square), lo(Square),((14)+1), 0 
                    db       17 
; macro call ->  TILE_5 (17)
                    db       hi(Square), lo(Square),((17)+1), 0 
                    db       18 
; macro call ->  TILE_5 (18)
                    db       hi(Square), lo(Square),((18)+1), 0 
                    db       19 
; macro call ->  TILE_5 (19)
                    db       hi(Square), lo(Square),((19)+1), 0 
                    db       23 
; macro call ->  TILE_5 (23)
                    db       hi(Square), lo(Square),((23)+1), 0 
                    db       24 
; macro call ->  TILE_5 (24)
                    db       hi(Square), lo(Square),((24)+1), 0 
                    db       25 
; macro call ->  TILE_5 (25)
                    db       hi(Square), lo(Square),((25)+1), 0 
                    db       29 
; macro call ->  TILE_5 (29)
                    db       hi(Square), lo(Square),((29)+1), 0 
                    db       33 
; macro call ->  TILE_5 (33)
                    db       hi(Square), lo(Square),((33)+1), 0 
                    db       56 
; macro call ->  TILE_A (56)
                    db       hi(MultiTileTest), lo(MultiTileTest),((56)+1), 0 
                    db       -1                           ; end of line 
line1_4: 
                    dw       line1_5                      ; next line start 
                    db       2 
; macro call ->  TILE_5 (2)
                    db       hi(Square), lo(Square),((2)+1), 0 
                    db       4 
; macro call ->  TILE_5 (4)
                    db       hi(Square), lo(Square),((4)+1), 0 
                    db       6 
; macro call ->  TILE_5 (6)
                    db       hi(Square), lo(Square),((6)+1), 0 
                    db       8 
; macro call ->  TILE_5 (8)
                    db       hi(Square), lo(Square),((8)+1), 0 
                    db       11 
; macro call ->  TILE_5 (11)
                    db       hi(Square), lo(Square),((11)+1), 0 
                    db       17 
; macro call ->  TILE_5 (17)
                    db       hi(Square), lo(Square),((17)+1), 0 
                    db       20 
; macro call ->  TILE_5 (20)
                    db       hi(Square), lo(Square),((20)+1), 0 
                    db       23 
; macro call ->  TILE_5 (23)
                    db       hi(Square), lo(Square),((23)+1), 0 
                    db       26 
; macro call ->  TILE_5 (26)
                    db       hi(Square), lo(Square),((26)+1), 0 
                    db       30 
; macro call ->  TILE_5 (30)
                    db       hi(Square), lo(Square),((30)+1), 0 
                    db       32 
; macro call ->  TILE_5 (32)
                    db       hi(Square), lo(Square),((32)+1), 0 
                    db       72 
; macro call ->  TILE_A (72)
                    db       hi(MultiTileTest), lo(MultiTileTest),((72)+1), 0 
                    db       -1                           ; end of line 
line1_5: 
                    dw       line1_6                      ; next line start 
                    db       2 
; macro call ->  TILE_5 (2)
                    db       hi(Square), lo(Square),((2)+1), 0 
                    db       5 
; macro call ->  TILE_A (5)
                    db       hi(MultiTileTest), lo(MultiTileTest),((5)+1), 0 
                    db       8 
; macro call ->  TILE_5 (8)
                    db       hi(Square), lo(Square),((8)+1), 0 
                    db       11 
; macro call ->  TILE_5 (11)
                    db       hi(Square), lo(Square),((11)+1), 0 
                    db       12 
; macro call ->  TILE_5 (12)
                    db       hi(Square), lo(Square),((12)+1), 0 
                    db       13 
; macro call ->  TILE_A (13)
                    db       hi(MultiTileTest), lo(MultiTileTest),((13)+1), 0 
                    db       17 
; macro call ->  TILE_5 (17)
                    db       hi(Square), lo(Square),((17)+1), 0 
                    db       18 
; macro call ->  TILE_A (18)
                    db       hi(MultiTileTest), lo(MultiTileTest),((18)+1), 0 
                    db       19 
; macro call ->  TILE_5 (19)
                    db       hi(Square), lo(Square),((19)+1), 0 
                    db       23 
; macro call ->  TILE_5 (23)
                    db       hi(Square), lo(Square),((23)+1), 0 
                    db       24 
; macro call ->  TILE_A (24)
                    db       hi(MultiTileTest), lo(MultiTileTest),((24)+1), 0 
                    db       25 
; macro call ->  TILE_5 (25)
                    db       hi(Square), lo(Square),((25)+1), 0 
                    db       31 
; macro call ->  TILE_A (31)
                    db       hi(MultiTileTest), lo(MultiTileTest),((31)+1), 0 
                    db       -1                           ; end of line 
line1_6: 
                    dw       line1_7                      ; next line start 
                    db       2 
; macro call ->  TILE_5 (2)
                    db       hi(Square), lo(Square),((2)+1), 0 
                    db       8 
; macro call ->  TILE_5 (8)
                    db       hi(Square), lo(Square),((8)+1), 0 
                    db       11 
; macro call ->  TILE_5 (11)
                    db       hi(Square), lo(Square),((11)+1), 0 
                    db       17 
; macro call ->  TILE_5 (17)
                    db       hi(Square), lo(Square),((17)+1), 0 
                    db       19 
; macro call ->  TILE_5 (19)
                    db       hi(Square), lo(Square),((19)+1), 0 
                    db       23 
; macro call ->  TILE_5 (23)
                    db       hi(Square), lo(Square),((23)+1), 0 
                    db       25 
; macro call ->  TILE_5 (25)
                    db       hi(Square), lo(Square),((25)+1), 0 
                    db       32 
; macro call ->  TILE_5 (32)
                    db       hi(Square), lo(Square),((32)+1), 0 
                    db       -1                           ; end of line 
line1_7: 
                    dw       line1_8                      ; next line start 
                    db       2 
; macro call ->  TILE_5 (2)
                    db       hi(Square), lo(Square),((2)+1), 0 
                    db       8 
; macro call ->  TILE_5 (8)
                    db       hi(Square), lo(Square),((8)+1), 0 
                    db       11 
; macro call ->  TILE_5 (11)
                    db       hi(Square), lo(Square),((11)+1), 0 
                    db       12 
; macro call ->  TILE_5 (12)
                    db       hi(Square), lo(Square),((12)+1), 0 
                    db       13 
; macro call ->  TILE_5 (13)
                    db       hi(Square), lo(Square),((13)+1), 0 
                    db       14 
; macro call ->  TILE_5 (14)
                    db       hi(Square), lo(Square),((14)+1), 0 
                    db       17 
; macro call ->  TILE_5 (17)
                    db       hi(Square), lo(Square),((17)+1), 0 
                    db       20 
; macro call ->  TILE_5 (20)
                    db       hi(Square), lo(Square),((20)+1), 0 
                    db       23 
; macro call ->  TILE_5 (23)
                    db       hi(Square), lo(Square),((23)+1), 0 
                    db       26 
; macro call ->  TILE_5 (26)
                    db       hi(Square), lo(Square),((26)+1), 0 
                    db       33 
; macro call ->  TILE_5 (33)
                    db       hi(Square), lo(Square),((33)+1), 0 
                    db       54 
; macro call ->  TILE_A (54)
                    db       hi(MultiTileTest), lo(MultiTileTest),((54)+1), 0 
                    db       -1                           ; end of line 
line1_8: 
                    dw       line1_9                      ; next line start 
                    db       -1                           ; end of line 
line1_9: 
                    dw       line1_10                     ; next line start 
                    db       -1                           ; end of line 
line1_10: 
                    dw       line1_11                     ; next line start 
                    db       -1                           ; end of line 
line1_11: 
                    dw       line1_12                     ; next line start 
                    db       -1                           ; end of line 
line1_12: 
                    dw       line1_13                     ; next line start 
                    db       -1                           ; end of line 
line1_13: 
                    dw       line1_14                     ; next line start 
                    db       -1                           ; end of line 
line1_14: 
                    dw       line1_15                     ; next line start 
                    db       9 
; macro call ->  TILE_A (9)
                    db       hi(MultiTileTest), lo(MultiTileTest),((9)+1), 0 
                    db       -1                           ; end of line 
line1_15: 
                    dw       line1_16                     ; next line start 
                    db       8 
; macro call ->  TILE_A (8)
                    db       hi(MultiTileTest), lo(MultiTileTest),((8)+1), 0 
                    db       11 
; macro call ->  TILE_A (11)
                    db       hi(MultiTileTest), lo(MultiTileTest),((11)+1), 0 
                    db       23 
; macro call ->  TILE_A (23)
                    db       hi(MultiTileTest), lo(MultiTileTest),((23)+1), 0 
                    db       43 
; macro call ->  TILE_A (43)
                    db       hi(MultiTileTest), lo(MultiTileTest),((43)+1), 0 
                    db       58 
; macro call ->  TILE_A (58)
                    db       hi(MultiTileTest), lo(MultiTileTest),((58)+1), 0 
                    db       -1                           ; end of line 
line1_16: 
                    dw       line1_17                     ; next line start 
                    db       7 
; macro call ->  TILE_A (7)
                    db       hi(MultiTileTest), lo(MultiTileTest),((7)+1), 0 
                    db       10 
; macro call ->  TILE_A (10)
                    db       hi(MultiTileTest), lo(MultiTileTest),((10)+1), 0 
                    db       -1                           ; end of line 
line1_17: 
                    dw       line1_18                     ; next line start 
                    db       3 
; macro call ->  TILE_A (3)
                    db       hi(MultiTileTest), lo(MultiTileTest),((3)+1), 0 
                    db       6 
; macro call ->  TILE_A (6)
                    db       hi(MultiTileTest), lo(MultiTileTest),((6)+1), 0 
                    db       7 
; macro call ->  TILE_A (7)
                    db       hi(MultiTileTest), lo(MultiTileTest),((7)+1), 0 
                    db       8 
; macro call ->  TILE_A (8)
                    db       hi(MultiTileTest), lo(MultiTileTest),((8)+1), 0 
                    db       9 
; macro call ->  TILE_A (9)
                    db       hi(MultiTileTest), lo(MultiTileTest),((9)+1), 0 
                    db       14 
; macro call ->  TILE_A (14)
                    db       hi(MultiTileTest), lo(MultiTileTest),((14)+1), 0 
                    db       -1                           ; end of line 
line1_18: 
                    dw       line1_19                     ; next line start 
                    db       2 
; macro call ->  TILE_A (2)
                    db       hi(MultiTileTest), lo(MultiTileTest),((2)+1), 0 
                    db       3 
; macro call ->  TILE_A (3)
                    db       hi(MultiTileTest), lo(MultiTileTest),((3)+1), 0 
                    db       4 
; macro call ->  TILE_A (4)
                    db       hi(MultiTileTest), lo(MultiTileTest),((4)+1), 0 
                    db       5 
; macro call ->  TILE_A (5)
                    db       hi(MultiTileTest), lo(MultiTileTest),((5)+1), 0 
                    db       6 
; macro call ->  TILE_A (6)
                    db       hi(MultiTileTest), lo(MultiTileTest),((6)+1), 0 
                    db       7 
; macro call ->  TILE_A (7)
                    db       hi(MultiTileTest), lo(MultiTileTest),((7)+1), 0 
                    db       8 
; macro call ->  TILE_A (8)
                    db       hi(MultiTileTest), lo(MultiTileTest),((8)+1), 0 
                    db       9 
; macro call ->  TILE_A (9)
                    db       hi(MultiTileTest), lo(MultiTileTest),((9)+1), 0 
                    db       10 
; macro call ->  TILE_A (10)
                    db       hi(MultiTileTest), lo(MultiTileTest),((10)+1), 0 
                    db       11 
; macro call ->  TILE_A (11)
                    db       hi(MultiTileTest), lo(MultiTileTest),((11)+1), 0 
                    db       12 
; macro call ->  TILE_A (12)
                    db       hi(MultiTileTest), lo(MultiTileTest),((12)+1), 0 
                    db       -1                           ; end of line 
line1_19: 
                    dw       line1_20                     ; next line start 
                    db       2 
; macro call ->  TILE_A (2)
                    db       hi(MultiTileTest), lo(MultiTileTest),((2)+1), 0 
                    db       3 
; macro call ->  TILE_A (3)
                    db       hi(MultiTileTest), lo(MultiTileTest),((3)+1), 0 
                    db       4 
; macro call ->  TILE_A (4)
                    db       hi(MultiTileTest), lo(MultiTileTest),((4)+1), 0 
                    db       5 
; macro call ->  TILE_A (5)
                    db       hi(MultiTileTest), lo(MultiTileTest),((5)+1), 0 
                    db       -1                           ; end of line 
line1_20: 
                    dw       line1_21                     ; next line start 
                    db       3 
; macro call ->  TILE_A (3)
                    db       hi(MultiTileTest), lo(MultiTileTest),((3)+1), 0 
                    db       17 
; macro call ->  TILE_5 (17)
                    db       hi(Square), lo(Square),((17)+1), 0 
                    db       21 
; macro call ->  TILE_5 (21)
                    db       hi(Square), lo(Square),((21)+1), 0 
                    db       25 
; macro call ->  TILE_5 (25)
                    db       hi(Square), lo(Square),((25)+1), 0 
                    db       26 
; macro call ->  TILE_5 (26)
                    db       hi(Square), lo(Square),((26)+1), 0 
                    db       27 
; macro call ->  TILE_5 (27)
                    db       hi(Square), lo(Square),((27)+1), 0 
                    db       28 
; macro call ->  TILE_5 (28)
                    db       hi(Square), lo(Square),((28)+1), 0 
                    db       31 
; macro call ->  TILE_5 (31)
                    db       hi(Square), lo(Square),((31)+1), 0 
                    db       32 
; macro call ->  TILE_5 (32)
                    db       hi(Square), lo(Square),((32)+1), 0 
                    db       36 
; macro call ->  TILE_5 (36)
                    db       hi(Square), lo(Square),((36)+1), 0 
                    db       37 
; macro call ->  TILE_5 (37)
                    db       hi(Square), lo(Square),((37)+1), 0 
                    db       42 
; macro call ->  TILE_5 (42)
                    db       hi(Square), lo(Square),((42)+1), 0 
                    db       43 
; macro call ->  TILE_5 (43)
                    db       hi(Square), lo(Square),((43)+1), 0 
                    db       49 
; macro call ->  TILE_5 (49)
                    db       hi(Square), lo(Square),((49)+1), 0 
                    db       50 
; macro call ->  TILE_5 (50)
                    db       hi(Square), lo(Square),((50)+1), 0 
                    db       51 
; macro call ->  TILE_5 (51)
                    db       hi(Square), lo(Square),((51)+1), 0 
                    db       -1                           ; end of line 
line1_21: 
                    dw       line1_22                     ; next line start 
                    db       18 
; macro call ->  TILE_5 (18)
                    db       hi(Square), lo(Square),((18)+1), 0 
                    db       20 
; macro call ->  TILE_5 (20)
                    db       hi(Square), lo(Square),((20)+1), 0 
                    db       24 
; macro call ->  TILE_5 (24)
                    db       hi(Square), lo(Square),((24)+1), 0 
                    db       31 
; macro call ->  TILE_5 (31)
                    db       hi(Square), lo(Square),((31)+1), 0 
                    db       33 
; macro call ->  TILE_5 (33)
                    db       hi(Square), lo(Square),((33)+1), 0 
                    db       35 
; macro call ->  TILE_5 (35)
                    db       hi(Square), lo(Square),((35)+1), 0 
                    db       37 
; macro call ->  TILE_5 (37)
                    db       hi(Square), lo(Square),((37)+1), 0 
                    db       41 
; macro call ->  TILE_5 (41)
                    db       hi(Square), lo(Square),((41)+1), 0 
                    db       44 
; macro call ->  TILE_5 (44)
                    db       hi(Square), lo(Square),((44)+1), 0 
                    db       48 
; macro call ->  TILE_5 (48)
                    db       hi(Square), lo(Square),((48)+1), 0 
                    db       -1                           ; end of line 
line1_22: 
                    dw       line1_23                     ; next line start 
                    db       19 
; macro call ->  TILE_A (19)
                    db       hi(MultiTileTest), lo(MultiTileTest),((19)+1), 0 
                    db       25 
; macro call ->  TILE_5 (25)
                    db       hi(Square), lo(Square),((25)+1), 0 
                    db       26 
; macro call ->  TILE_A (26)
                    db       hi(MultiTileTest), lo(MultiTileTest),((26)+1), 0 
                    db       27 
; macro call ->  TILE_5 (27)
                    db       hi(Square), lo(Square),((27)+1), 0 
                    db       31 
; macro call ->  TILE_5 (31)
                    db       hi(Square), lo(Square),((31)+1), 0 
                    db       34 
; macro call ->  TILE_A (34)
                    db       hi(MultiTileTest), lo(MultiTileTest),((34)+1), 0 
                    db       37 
; macro call ->  TILE_5 (37)
                    db       hi(Square), lo(Square),((37)+1), 0 
                    db       40 
; macro call ->  TILE_5 (40)
                    db       hi(Square), lo(Square),((40)+1), 0 
                    db       45 
; macro call ->  TILE_5 (45)
                    db       hi(Square), lo(Square),((45)+1), 0 
                    db       49 
; macro call ->  TILE_5 (49)
                    db       hi(Square), lo(Square),((49)+1), 0 
                    db       50 
; macro call ->  TILE_A (50)
                    db       hi(MultiTileTest), lo(MultiTileTest),((50)+1), 0 
                    db       51 
; macro call ->  TILE_5 (51)
                    db       hi(Square), lo(Square),((51)+1), 0 
                    db       72 
; macro call ->  TILE_A (72)
                    db       hi(MultiTileTest), lo(MultiTileTest),((72)+1), 0 
                    db       -1                           ; end of line 
line1_23: 
                    dw       line1_24                     ; next line start 
                    db       18 
; macro call ->  TILE_5 (18)
                    db       hi(Square), lo(Square),((18)+1), 0 
                    db       20 
; macro call ->  TILE_5 (20)
                    db       hi(Square), lo(Square),((20)+1), 0 
                    db       28 
; macro call ->  TILE_5 (28)
                    db       hi(Square), lo(Square),((28)+1), 0 
                    db       31 
; macro call ->  TILE_5 (31)
                    db       hi(Square), lo(Square),((31)+1), 0 
                    db       37 
; macro call ->  TILE_5 (37)
                    db       hi(Square), lo(Square),((37)+1), 0 
                    db       40 
; macro call ->  TILE_5 (40)
                    db       hi(Square), lo(Square),((40)+1), 0 
                    db       41 
; macro call ->  TILE_5 (41)
                    db       hi(Square), lo(Square),((41)+1), 0 
                    db       42 
; macro call ->  TILE_A (42)
                    db       hi(MultiTileTest), lo(MultiTileTest),((42)+1), 0 
                    db       43 
; macro call ->  TILE_A (43)
                    db       hi(MultiTileTest), lo(MultiTileTest),((43)+1), 0 
                    db       44 
; macro call ->  TILE_5 (44)
                    db       hi(Square), lo(Square),((44)+1), 0 
                    db       45 
; macro call ->  TILE_5 (45)
                    db       hi(Square), lo(Square),((45)+1), 0 
                    db       52 
; macro call ->  TILE_5 (52)
                    db       hi(Square), lo(Square),((52)+1), 0 
                    db       -1                           ; end of line 
line1_24: 
                    dw       line1_25                     ; next line start 
                    db       17 
; macro call ->  TILE_5 (17)
                    db       hi(Square), lo(Square),((17)+1), 0 
                    db       21 
; macro call ->  TILE_5 (21)
                    db       hi(Square), lo(Square),((21)+1), 0 
                    db       24 
; macro call ->  TILE_5 (24)
                    db       hi(Square), lo(Square),((24)+1), 0 
                    db       25 
; macro call ->  TILE_5 (25)
                    db       hi(Square), lo(Square),((25)+1), 0 
                    db       26 
; macro call ->  TILE_5 (26)
                    db       hi(Square), lo(Square),((26)+1), 0 
                    db       27 
; macro call ->  TILE_5 (27)
                    db       hi(Square), lo(Square),((27)+1), 0 
                    db       31 
; macro call ->  TILE_5 (31)
                    db       hi(Square), lo(Square),((31)+1), 0 
                    db       37 
; macro call ->  TILE_5 (37)
                    db       hi(Square), lo(Square),((37)+1), 0 
                    db       40 
; macro call ->  TILE_5 (40)
                    db       hi(Square), lo(Square),((40)+1), 0 
                    db       45 
; macro call ->  TILE_5 (45)
                    db       hi(Square), lo(Square),((45)+1), 0 
                    db       49 
; macro call ->  TILE_5 (49)
                    db       hi(Square), lo(Square),((49)+1), 0 
                    db       50 
; macro call ->  TILE_5 (50)
                    db       hi(Square), lo(Square),((50)+1), 0 
                    db       51 
; macro call ->  TILE_5 (51)
                    db       hi(Square), lo(Square),((51)+1), 0 
                    db       -1                           ; end of line 
line1_25: 
                    dw       line1_26                     ; next line start 
                    db       69 
; macro call ->  TILE_A (69)
                    db       hi(MultiTileTest), lo(MultiTileTest),((69)+1), 0 
                    db       -1                           ; end of line 
line1_26: 
                    dw       line1_27                     ; next line start 
                    db       -1                           ; end of line 
line1_27: 
                    dw       line1_28                     ; next line start 
                    db       -1                           ; end of line 
line1_28: 
                    dw       line1_29                     ; next line start 
                    db       68 
; macro call ->  TILE_A (68)
                    db       hi(MultiTileTest), lo(MultiTileTest),((68)+1), 0 
                    db       -1                           ; end of line 
line1_29: 
                    dw       line1_30                     ; next line start 
                    db       -1                           ; end of line 
line1_30: 
                    dw       line1_31                     ; next line start 
                    db       -1                           ; end of line 
line1_31: 
                    dw       line1_32                     ; next line start 
                    db       -1                           ; end of line 
line1_32: 
                    dw       line1_33                     ; next line start 
                    db       -1                           ; end of line 
line1_33: 
                    dw       line1_34                     ; next line start 
                    db       -1                           ; end of line 
line1_34: 
                    dw       line1_35                     ; next line start 
                    db       -1                           ; end of line 
line1_35: 
                    dw       line1_36                     ; next line start 
                    db       -1                           ; end of line 
line1_36: 
                    dw       line1_37                     ; next line start 
                    db       -1                           ; end of line 
lines1: 
                    dw       line1_0 
                    dw       line1_1 
                    dw       line1_2 
                    dw       line1_3 
                    dw       line1_4 
                    dw       line1_5 
                    dw       line1_6 
                    dw       line1_7 
                    dw       line1_8 
                    dw       line1_9 
                    dw       line1_10 
                    dw       line1_11 
                    dw       line1_12 
                    dw       line1_13 
                    dw       line1_14 
                    dw       line1_15 
                    dw       line1_16 
                    dw       line1_17 
                    dw       line1_18 
                    dw       line1_19 
                    dw       line1_20 
                    dw       line1_21 
                    dw       line1_22 
                    dw       line1_23 
                    dw       line1_24 
                    dw       line1_25 
                    dw       line1_26 
                    dw       line1_27 
                    dw       line1_28 
                    dw       line1_29 
                    dw       line1_30 
                    dw       line1_31 
                    dw       line1_32 
                    dw       line1_33 
                    dw       line1_34 
                    dw       line1_35 
                    dw       line1_36 
                    dw       -1                           ; end of line 
line1_37            =        -1 

***********************************************************  
; include line ->                     INCLUDE  "drawRoutines.i"                
***********************************************************  
; input list in X - scale 6
; 0 move
; negative draw
; positive end
myDraw_VL_mode:                                           ;        #isfunction 
                    LDA      #$80 
                    STA      <VIA_aux_cntl                ; Shift reg mode = 000 free disable, T1 PB7 enabled 
next_line 
                    lda      ,x+ 
                    beq      move_vl 
                    bmi      draw_vl 
done_vl: 
; VIA values back to default
                    LDD      #$98ce                       ;[6] check 
                    STa      <VIA_aux_cntl                ; [4] Shift reg mode = 000 free disable, T1 PB7 enabled 
                    STB      <VIA_cntl                    ; [4] $CC /BLANK low and /ZERO low 
                    rts      


draw_vl: 
                    nop      4 
                    lda      #$ce                         ; [2] 
                    sta      <VIA_cntl                    ; [4] ; light OFF, ZERO OFF 
                    ldd      ,x++ 

                    STA      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    ldb      #$ee                         ; light ON, ZERO OFF 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 (6 cycles) 
; light on
                    stb      <VIA_cntl                    ; [4] ZERO disabled, and BLANK disabled 
; 24 cycles -> light off
                    lda      ,x+                          ;[7] 
                    bmi      draw_vl                      ; [3] 
                    beq      move_vl                      ; [3] 
                    bra      done_vl                      ; [3] 


move_vl: 
                    nop      3                            ; one branch not taken less 
                    lda      #$ce                         ; [2] 
                    sta      <VIA_cntl                    ; [4] ; light OFF, ZERO OFF 
                    ldd      ,x++ 

                    STA      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 (6 cycles) 
; light on
                                                          ; stb <VIA_cntl ; [4] ZERO disabled, and BLANK disabled 
; 24 cycles -> light off
                    lda      ,x+                          ;[7] 
                    bmi      draw_vl                      ; [3] 
                    beq      move_vl                      ; [3] 
                    bra      done_vl                      ; [3] 


***********************************************************  
; draw bigger vlists than above one - scale 16
; input list in X
; destroys u
; 0 move
; negative use as shift
; positive end
myDraw_VL_mode2:                                          ;        #isfunction 
                    LDA      #$80 
                    STA      <VIA_aux_cntl                ; Shift reg mode = 000 free disable, T1 PB7 enabled 
next_line2 
                    lda      ,x+ 
                    beq      move_vl2 
                    bmi      draw_vl2 
done_vl2: 
; VIA values back to default
;                    LDD      #$98ce                       ;[6] check 
                    LDD      #$98cc                       ;[6] check 
                    nop      4 
                    STa      <VIA_aux_cntl                ; [4] Shift reg mode = 000 free disable, T1 PB7 enabled 
                    STB      <VIA_cntl                    ; [4] $CC /BLANK low and /ZERO low 
                    rts      


draw_vl2: 
                    ldd      ,x++ 
                    ldu      #$ce00 
                    STA      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    stu      <VIA_cntl 
                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    ldb      #$ee                         ; light ON, ZERO OFF 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 (6 cycles) 
; light on
                    stb      <VIA_cntl                    ; [4] ZERO disabled, and BLANK disabled 
; 24 cycles -> light off
                    lda      ,x+                          ;[7] 
                    bmi      draw_vl2                     ; [3] 
                    beq      move_vl2                     ; [3] 
                    bra      done_vl2                     ; [3] 


move_vl2: 
                    ldd      ,x++ 
                    ldu      #$ce00 
                    STA      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    stu      <VIA_cntl 
                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 (6 cycles) 
; light on
                                                          ; stb <VIA_cntl ; [4] ZERO disabled, and BLANK disabled 
; 24 cycles -> light off
                    lda      ,x+                          ;[7] 
                    bmi      draw_vl2                     ; [3] 
                    beq      move_vl2                     ; [3] 
                    bra      done_vl2                     ; [3] 


; draw bigger vlists than above one - scale 24
; input list in X
; destroys u
; 0 move
; negative use as shift
; positive end
                    direct   $D0 
myDraw_VL_mode3: 
                    LDA      #$80 
                    STA      <VIA_aux_cntl                ; Shift reg mode = 000 free disable, T1 PB7 enabled 
next_line3 
                    lda      ,x+ 
                    beq      move_vl3 
                    bmi      draw_vl3 
done_vl3: 
; VIA values back to default
                    nop      8 
                    LDD      #$98ce                       ;[6] check 
                    STa      <VIA_aux_cntl                ; [4] Shift reg mode = 000 free disable, T1 PB7 enabled 
                                                          ;nop 2 
                    STB      <VIA_cntl                    ; [4] $CC /BLANK low and /ZERO low 
                    rts      


draw_vl3: 
                    ldd      ,x++ 
                    ldu      #$ce00                       ; $ce is light off 
                    STA      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    nop      2 
                    bra      wait_bra_1 


wait_bra_1 
                    stu      <VIA_cntl 
                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    ldb      #$ee                         ; light ON, ZERO OFF 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 (6 cycles) 
; light on
                    stb      <VIA_cntl                    ; [4] ZERO disabled, and BLANK disabled 
; 24 cycles -> light off
                    lda      ,x+                          ;[7] 
                    bmi      draw_vl3                     ; [3] 
                    beq      move_vl3                     ; [3] 
                    bra      done_vl3                     ; [3] 


move_vl3: 
                    ldd      ,x++ 
                    ldu      #$ce00 
                    STA      <VIA_port_a                  ;(2) [4] Send Y to A/D 
; nop 4
                    nop      2 
                    bra      wait_bra_2 


wait_bra_2 
                    stu      <VIA_cntl 
                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
; nop 4
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 (6 cycles) 
; light on
                    nop      4 
                                                          ; stb <VIA_cntl ; [4] ZERO disabled, and BLANK disabled 
; 24 cycles -> light off
                    lda      ,x+                          ;[7] 
                    bmi      draw_vl3                     ; [3] 
                    beq      move_vl3                     ; [3] 
                    bra      done_vl3                     ; [3] 


***********************************************************  
; draw bigger vlists than above one - scale 40
; input list in X
; destroys u
; 0 move
; negative use as shift
; positive end
myDraw_VL_mode4: 
                    LDA      #$80 
                    STA      <VIA_aux_cntl                ; Shift reg mode = 000 free disable, T1 PB7 enabled 
;next_line4 
                    lda      ,x+ 
                    beq      move_vl4 
                    bmi      draw_vl4 
done_vl4: 
; VIA values back to default
                    nop      6 
                    LDD      #$98ce                       ;[6] check 
                    STa      <VIA_aux_cntl                ; [4] Shift reg mode = 000 free disable, T1 PB7 enabled 
                    nop      2 
                    STB      <VIA_cntl                    ; [4] $CC /BLANK low and /ZERO low 
                    rts      


draw_vl4: 
                    ldd      ,x++ 
                    ldu      #$ce00 
                    STA      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    nop      4 
                    stu      <VIA_cntl 
                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    ldb      #$ee                         ; light ON, ZERO OFF 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 (6 cycles) 
; light on
                    stb      <VIA_cntl                    ; [4] ZERO disabled, and BLANK disabled 
; 24 cycles -> light off
                    lda      ,x+                          ;[7] 
                    nop      8                            ;NEW 
                    bmi      draw_vl4                     ; [3] 
                    beq      move_vl4                     ; [3] 
                    bra      done_vl4                     ; [3] 


move_vl4: 
                    ldd      ,x++ 
                    ldu      #$ce00 
                    STA      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    nop      4 
                    stu      <VIA_cntl 
                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
; nop 4
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 (6 cycles) 
; light on
                    nop      4 
                                                          ; stb <VIA_cntl ; [4] ZERO disabled, and BLANK disabled 
; 24 cycles -> light off
                    lda      ,x+                          ;[7] 
                    nop      8                            ;NEW 
                    bmi      draw_vl4                     ; [3] 
                    beq      move_vl4                     ; [3] 
                    bra      done_vl4                     ; [3] 


***********************************************************  
; draw bigger vlists than above one - scale 40
; input list in X
; destroys u
; 0 move
; negative use as shift
; positive end
myDraw_VL_mode32: 
                    LDA      #$80 
                    STA      <VIA_aux_cntl                ; Shift reg mode = 000 free disable, T1 PB7 enabled 
;next_line4 
                    lda      ,x+ 
                    beq      move_vl32 
                    bmi      draw_vl32 
done_vl32: 
; VIA values back to default
                    nop      3 
                    LDD      #$98ce                       ;[6] check 
                    STa      <VIA_aux_cntl                ; [4] Shift reg mode = 000 free disable, T1 PB7 enabled 
                    nop      1 
                    STB      <VIA_cntl                    ; [4] $CC /BLANK low and /ZERO low 
                    rts      


draw_vl32: 
                    ldd      ,x++ 
                    ldu      #$ce00 
                    STA      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    nop      2 
                    stu      <VIA_cntl 
                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    ldb      #$ee                         ; light ON, ZERO OFF 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 (6 cycles) 
; light on
                    stb      <VIA_cntl                    ; [4] ZERO disabled, and BLANK disabled 
; 24 cycles -> light off
                    lda      ,x+                          ;[7] 
                    nop      4                            ;NEW 
                    bmi      draw_vl32                    ; [3] 
                    beq      move_vl32                    ; [3] 
                    bra      done_vl32                    ; [3] 


move_vl32: 
                    ldd      ,x++ 
                    ldu      #$ce00 
                    STA      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    nop      2 
                    stu      <VIA_cntl 
                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
; nop 4
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 (6 cycles) 
; light on
                    nop      2 
                                                          ; stb <VIA_cntl ; [4] ZERO disabled, and BLANK disabled 
; 24 cycles -> light off
                    lda      ,x+                          ;[7] 
                    nop      4                            ;NEW 
                    bmi      draw_vl32                    ; [3] 
                    beq      move_vl32                    ; [3] 
                    bra      done_vl32                    ; [3] 


***********************************************************  
; draw bigger vlists than above one - scale 16
; input list in X
; destroys u
; 0 move
; negative use as shift
; positive end
myDraw_VL_mode2_full:                                     ;     #isfunction 
; macro call ->                     _SCALE   SCALE_VLIST 
                    LDA      #SCALE_VLIST                 ; scale for placing first point 
; macro call ->                     _SCALE_A  
                    STA      VIA_t1_cnt_lo                ; move to time 1 lo, this means scaling 
                    LDA      #$80 
; macro call ->                     MY_MOVE_TO_B_END
                    LDB      #$40                         ; 
LF33D252:           BITB     <VIA_int_flags               ; 
                    BEQ      LF33D252 

                    STA      <VIA_aux_cntl                ; Shift reg mode = 000 free disable, T1 PB7 enabled 
next_line2_full 
                    lda      ,x+ 
                    beq      move_vl2_full 
                    bmi      draw_vl2_full 
done_vl2_full: 
; VIA values back to default
                    LDD      #$98cc                       ;[6] check 
                    nop      4 
                    STa      <VIA_aux_cntl                ; [4] Shift reg mode = 000 free disable, T1 PB7 enabled 
                    STB      <VIA_cntl                    ; [4] $CC /BLANK low and /ZERO low 

                    rts      


draw_vl2_full: 
                    ldd      ,x++ 
                    ldu      #$ce00 
                    STA      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    stu      <VIA_cntl 
                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    ldb      #$ee                         ; light ON, ZERO OFF 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 (6 cycles) 
; light on
                    stb      <VIA_cntl                    ; [4] ZERO disabled, and BLANK disabled 
; 24 cycles -> light off
                    lda      ,x+                          ;[7] 
                    bmi      draw_vl2_full                ; [3] 
                    beq      move_vl2_full                ; [3] 
                    bra      done_vl2_full                ; [3] 


move_vl2_full: 
                    ldd      ,x++ 
                    ldu      #$ce00 
                    STA      <VIA_port_a                  ;(2) [4] Send Y to A/D 
                    stu      <VIA_cntl 
                    CLR      <VIA_port_b                  ;(2) [4] enable mux, thus y integrators are set to Y 
                    INC      <VIA_port_b                  ;[6] Disable mux 
                    STB      <VIA_port_a                  ; [6] Send X to A/D 
                    CLR      <VIA_t1_cnt_hi               ; [4] enable timer 1 (6 cycles) 
; light on
                                                          ; stb <VIA_cntl ; [4] ZERO disabled, and BLANK disabled 
; 24 cycles -> light off
                    lda      ,x+                          ;[7] 
                    bmi      draw_vl2_full                ; [3] 
                    beq      move_vl2_full                ; [3] 
                    bra      done_vl2_full                ; [3] 
