CURRENT_BANK        EQU      0                            ; 
                    Bank     0 
                    include  "commonGround.i"
; following is needed for VIDE
; to replace "vars" in this bank with values from the other bank
; #genVarlist# varFromBank0
;
;***************************************************************************
; CODE SECTION
;***************************************************************************
printBankString 
                    LDU      #bank_string                 ; address of string 
                    LDA      #$60                         ; Text position relative Y 
                    LDB      #0                           ; Text position relative X 
                    JSR      Print_Str_d                  ; Vectrex BIOS print 
                    rts      


;***************************************************************************
bank_string: 
                    DB       "BANK 0"                     ; only capital letters
                    DB       $80                          ; $80 is end of string 

initBank0 
                    ldd      #0 
                    std      ym_data_current 
                    deca     
                    sta      current_song 
                    rts      


doBank0Stuff 
                    ldd      ym_data_current 
                    bne      playYMSong 

                    inc      current_song 
                    lda      current_song 
                    ldx      #songs 
                    lsla     
                    ldu      a,x 
                    bne      initSong 
                    clr      current_song 
                    ldu      ,x                           ; 0 

initSong 
                    JSR      init_ym_sound 

playYMSong 
                    JSR      do_ym_sound 
                    rts      


                    include  "ymPlayer.i"
songs 
                    dw       WhiteChristmas_data 
                    dw       SilentNight_data 
                    dw       TraenenLuegenNicht_data 
                    dw       JingleBells_data 
                    dw       XMAS_data 
                    dw       0 

                    include  "SilentNight.asm"            ; we wish yo a merry christmas
                    include  "WhiteChristmas.asm"         ; we wish yo a merry christmas
                    include  "TraenenLuegenNicht.asm"     ; we wish yo a merry christmas
                    include  "JINGLE.asm"                 ; we wish yo a merry christmas
                    include  "XMAS.asm"                   ; we wish yo a merry christmas
