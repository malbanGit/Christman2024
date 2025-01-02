                    include  "VECTREX.I"
ym_ram              equ      $c880 
;
                    CODE     
;***************************************************************************
                    ORG      0 
; start of vectrex memory with cartridge name...
                    DB       "g GCE 1998", $80 ; 'g' is copyright sign
                    DW       music7                       ; music from the rom 
                    DB       $F8, $50, $20, -$56          ; hight, width, rel y, rel x (from 0,0) 
some_name:
                    DB       "VECTREX STREAMED YM-SOUND", $80      ; some game information, ending with $80
                    DB       $F8, $50, $5, -$6d           ; hight, width, rel y, rel x (from 0,0) 
                    DB       "MALBAN", $80                ; some game information, ending with $80
                    DB       0                            ; end of game header 
;***************************************************************************
; here the cartridge program starts off
entry_point: 
new_game: 

                    ldu      #ymData 
                    JSR      init_ym_sound 
                    ldy      ymlen
main_loop: 
                    JSR      Wait_Recal                   ; sets dp to d0, and pos at 0, 0 
                    JSR      do_ym_sound 
                    leay     -1,y
                    beq      new_game                     ; loop default 
                    BRA      main_loop                    ; go back to main loop 

;***************************************************************************
                    INCLUDE  "JingleBells.asm"
                    INCLUDE  "ymStreamedPlayer.i"
