;
; load vectrex bios routine definitions
                    INCLUDE  "VECTREX.I"                  ; vectrex function includes
                    INCLUDE  "macro.i"                    ; vectrex macro includes
;
; *******************************************************************
; ********************** STRUCTRUES *********************************
; *******************************************************************

                    struct   DemoListEntry 
                    ds       BANK,2                       ; bank demo is in
                    ds       SUBROUTINE,2                 ; subroutine to play demo (one cycle)
                    ds       INITROUTINE,2                ; init routine to play demo
                    ds       CYCLES,2                     ;  
                    ds       LISTDATA,2                   ;  
                    end struct 

                    struct   Demo 
                    ds       POINTER,2               ; address of demo in list (bank 3)
                    ds       STATE,1                 ; state machine of demo state
                    ds       COUNTER,1               ; some counter
                    ds       BRIGHTNESS,1            ; brightness if applicable
                    ds       SAMPLE_POINTER, 0       ; for playing samples, stores the y reg
                    ds       POS,0                   ; Position if applicable
                    ds       POSY,1                  ; 
                    ds       POSX,1                  ; 
                    ds       DATA,2                  ; like a scene
                    end struct 
TEN_SECONDS = 500
TWENTY_SECONDS = 1000
ONE_MINUTE = 3000

STATE_FADE_IN = 1
STATE_FADE_OUT = 2
STATE_PLAY = 3

STATE_FADE_IN       =        1 
STATE_FADE_OUT      =        2 
STATE_PLAY          =        3 
STATE_DONE          =        4 


; *******************************************************************
; YM
; *******************************************************************

 if USE_ENVELOPES = 1
REGS_MAX = 14
 else
REGS_MAX = 11
 endif


INFO_START=0
BYTE_POS=0
BIT_POS=2
CURRENT_DATA_BYTE=3
CURRENT_REG_BYTE=4
CURRENT_RLE_COUNTER=5
REG_PHRASE_MAP=7
CURRENT_IS_PHRASE=9
CURRENT_PLACE_IN_PHRASE=11
PHRASE_DEFINITION_START=12
REG_USED=14
CURRENT_PHRASE_LEN=15
INFO_END=16
STRUCT_LEN=(INFO_END-INFO_START)

; *******************************************************************
; YM END
; *******************************************************************

;
; ...
;
; *******************************************************************
; ********************** CONSTANTS **********************************
; *******************************************************************
; ...
; *******************************************************************
; ********************** RAM ****************************************
; *******************************************************************
;
; RAM that is "always" the same
;                    include  "RAMLayoutStatic.asm"
                    bss      
; saving memory, using BIOS MEM
 org Vec_Counters ; 14 bytes available
demo1Data ds Demo; 9
random_a  ds 1                      ; vars for own "random" - is much better than the internal BIOS one! 
random_b  ds 1                             ; see https://www.electro-tech-online.com/threads/ultra-fast-pseudorandom-number-generator-for-8-bit.124249/ 
random_c  ds 1
random_x  ds 1 ; c83a

bigCounter ds 2 ; -> not anymore!!! -> 2 byte left for use

 org Vec_Music_Work

demo2Data ds Demo
demo3Data ds Demo
; c85d

demoFlag            ds       1 ; set to 1 when a demo starts a round, if demo is finished - flag will be 0
current_song        ds       1 
firstDemoDone ds 1
demoRunningFlag ds 1
lastDemoPointer ds 2

; ATTENTION!
; We are not using RANDOM
;Vec_Seed_Ptr        EQU      $C87B                        ;Pointer to 3-byte random number seed (=$C87D) 
;Vec_Random_Seed     EQU      $C87D 

; *******************************************************************
; YM
; *******************************************************************
; end of "normal" ram - now something the the player

cregister:
                    ds       1
temp:
                    ds       1
temp2:
                    ds       1
temp3:
                    ds       1
calc_coder:
                    ds       1
calc_bits:
                    ds       1
ym_len:
                    ds       2
ym_data_current:
                    ds       2
ym_name:
                    ds       2
ym_regs_used:       ds       1
ym_regs_count:      ds       1
ym_data_start:      ds       REGS_MAX * STRUCT_LEN
; *******************************************************************
; YM END
; *******************************************************************

; *******************************************************************
; SAMPLE
; *******************************************************************

; sample RAM can be used, when not sample playing...
sample_ram ds 0

user_ram            
user_ram_start      ds 0
via_b_start         ds 1
digit_sound_struct  ds 0
digit_is_playing    ds 1
digit_start_pos     ds 2
digit_length        ds 2
digit_looping       ds 1
digit_current_pos   ds 2
digit_end_pos       ds 2
digit_recal_counter  ds 2
digit_sound_struct_end  ds 2

endOfNormalRam ds 0 



; *******************************************************************
; SAMPLE END
; *******************************************************************



