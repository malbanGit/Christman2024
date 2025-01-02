                    include  "waitMacros.i"
;***************************************************************************
_LDD                macro    pa, pb 
                    ldd      #(lo(pa)*256)+(lo(pb)) 
                    endm     
;***************************************************************************
_DP_TO_C8           macro                                 ; pretty for optimizing to use a makro :-) 
                    LDA      #$C8 
                    TFR      A,DP 
                    direct   $C8 
                    endm     
;***************************************************************************
_DP_TO_D0           macro                                 ; pretty for optimizing to use a makro :-) 
                    LDA      #$D0 
                    TFR      A,DP 
                    direct   $D0 
                    endm     
;***************************************************************************
NEG_D               macro    
                    COMA     
                    COMB     
                    ADDD     #1 
                    endm                                  ; done 
;***************************************************************************
; macro D = D *2
LSL_D               macro    
                    ASLB     
                    ROLA     
                    endm                                  ; done 
;***************************************************************************
; macro D = D /2
LSR_D               macro    
                    ASRA     
                    RORB     
                    endm                                  ; done 
;***************************************************************************
AHEX_TOUASCII       macro    
                    pshs     a 
                    lsra     
                    lsra     
                    lsra     
                    lsra     
                    adda     # '0'
                    cmpa     # '9'
                    ble      ok1\? 
                    adda     #( 'A'-'0'-10)
ok1\? 
                    sta      ,u+ 
                    lda      ,s 
                    anda     #$f 
                    adda     # '0'
                    cmpa     # '9'
                    ble      ok2\? 
                    adda     #( 'A'-'0'-10)
ok2\? 
                    sta      ,u+ 
                    leas     1,s 
                    endm     
;***************************************************************************
BHEX_TOUASCII       macro    
                    pshs     b 
                    lsrb     
                    lsrb     
                    lsrb     
                    lsrb     
                    addb     # '0'
                    cmpb     # '9'
                    ble      ok3\? 
                    addb     #( 'A'-'0'-10)
ok3\? 
                    stb      ,u+ 
                    ldb      ,s 
                    andb     #$f 
                    addb     # '0'
                    cmpb     # '9'
                    ble      ok4\? 
                    addb     #( 'A'-'0'-10)
ok4\? 
                    stb      ,u+ 
                    leas     1,s 
                    endm     
;***************************************************************************
DHEX_TOUASCII       macro    
                    AHEX_TOUASCII  
                    BHEX_TOUASCII  
                    endm     
;***************************************************************************
;
; definition of bank switch macros
;
PB6_TO_0            macro    
                    lda      #$DF                         ; Prepare DDR Registers % 1101 1111 1111 1111 
                    sta      <VIA_DDR_b                   ; all ORB/ORA to output except ORB 5, PB6 goes LOW 
                    lda      #$01                         ; A = $01, B = 0 
                    sta      <VIA_port_b                  ; ORB = $1 (ramp on, mux off), ORA = 0 (DAC) 
                    endm     
; .....
PB6_TO_1            macro    
                    lda      #$9F                         ; Prepare DDR Registers % 1001 1111 1111 1111 
                    sta      <VIA_DDR_b                   ; all ORB/ORA to output except ORB 5, PB6 goes LOW 
                    lda      #$01                         ; A = $01, B = 0 
                    sta      <VIA_port_b                  ; ORB = $1 (ramp on, mux off), ORA = 0 (DAC) 
                    endm     
; .....
IRQ_TO_1            macro                                 ; interrupt DISABLED - clear ALL interrupts to ensure other bank 
                    lda      #%01111111                   ; bit 7 = 0, each other "1" clears the IEflag, bit 6 = T1 
                    sta      <VIA_int_enable 
                                                          ; ensure shift is "normal" 
                    lda      #$98                         ; 0 = shift, 
                    sta      <VIA_aux_cntl 
                    endm     
; .....
IRQ_TO_0_T1         macro                                 ; interrupt ENABLED 
                    lda      #%11000000                   ; bit 7 = 1, each other "1" sets the IEflag, bit 6 = T1 
                    sta      <VIA_int_enable 
                                                          ; and now "trigger a interrupt" 
                    lda      #1                           ; a VERY short T1 timer 
                    sta      <VIA_t1_cnt_lo 
                    clra     
                    sta      <VIA_t1_cnt_hi               ; start timer 
                    nop      2                            ; by the time, the macros "leaves" the interrupt is set! 
                    endm     
; .....
IRQ_TO_0_SHIFT      macro                                 ; interrupt ENABLED 
                    ldd      #$98                         ; ensure that shift can generate interrupt 
; for some reason or another, VIA doesn't like a
; std VIA_shift_reg, Bankswitching (IRQ?) than crashes!
; (only on a real vectrex, not Vide)
                    stb      <VIA_aux_cntl 
                    sta      <VIA_shift_reg               ; and write 0 to shift (a) and $98 to aux (shift out enable) 
                    ldb      #%11000100                   ; bit 7 = 1, each other "1" enables interrupts(bit 6 = t1, bit 2 = shift), both enabled 
                    stb      <VIA_int_enable 
                                                          ; wait 20 cycles till store of aux (these are 23) 
                    mul                                   ; 12 
                    ldb      #$80                         ; 3 
                    stb      <VIA_aux_cntl 
                    endm     
;***************************************************************************
RANDOM_A_alt        macro    
                    inc      random_x 
                    lda      random_a 
                    eora     random_b 
                    eora     random_x 
                    sta      random_a 
                    adda     random_b 
                    sta      random_b 
                    lsra     
                    eora     random_a 
                    adda     random_c 
                    sta      random_c 
                    endm     
RANDOM_B_alt        macro    
                    inc      random_x 
                    ldb      random_a 
                    eorb     random_b 
                    eorb     random_x 
                    stb      random_a 
                    addb     random_b 
                    stb      random_b 
                    lsrb     
                    eorb     random_a 
                    addb     random_c 
                    stb      random_c 
                    endm     


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; macro D = D *2
MY_LSL_D            macro    
                    ASLB     
                    ROLA     
                    endm                                  ; done 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; macro D = D /2
MY_LSR_D            macro    
                    ASRA     
                    RORB     
                    endm                                  ; done 

                      ; 

_INTENSITY_A        macro    
                    STA      <VIA_port_a                  ;Store intensity in D/A 
                    LDD      #$0504                       ;mux disabled channel 2 
                    STA      <VIA_port_b                  ; 
                    STB      <VIA_port_b                  ;mux enabled channel 2 
                    STA      <VIA_port_b                  ;turn off mux 
                    endm     


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