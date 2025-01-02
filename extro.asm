 bss
 org sample_ram
it_stringCounter    ds       1                            ; which string in the pointer list to start with 
it_lineCounter      ds       1                            ; line for the scroll line within one string (bitmap) 
it_linePrintOffset  ds       1                            ; compensation offset while printing for line gap between two strings 
it_xlinePrintOffset  ds      1                            ; x offset of line (used to ensure MID alignment) 
tmp2_lc             ds       1                            ; counter of how many string lines have been processed within the scroller (coutdown from BITMAP_LINES_TITLE) 
tmp3_lc             ds       1 
                    code     



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; implements the vertical scroller on the 
; desktop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCROLLTEXTSIZE      =        $35 
BITMAP_LINES_TITLE  =        35                           ;45 ; if higher, the positioning has 8 bit problems, than the "spacing" (4/8) must be adjusted to fit 8 bit ; 25 
SPACE_BETWEEN_LINES  =       2                            ;2 
SPACE_BETWEEN_STRINGS  =     6*SPACE_BETWEEN_LINES        ; must be multiplyer of lines 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; u pointer to String
; in ,s position where position is synced to
NEXT_SYNC_BITMAP_LINE2_FIRST  macro  
; zero is short, since we stay near center -> no wait loop!
                    ldd      #(%10000010)*256+$CC         ; zero the integrators 
                    stb      <VIA_cntl                    ; store zeroing values to cntl 
                    clr      <VIA_port_a                  ; reset integrator offset 
                    sta      <VIA_port_b                  ; while waiting, zero offsets 
                    inca     
                    sta      <VIA_port_b 
                    ldd      ,s 
                    addb     it_xlinePrintOffset 
                    MY_MOVE_TO_D_START           ; from now on "in move" 
                    lda      ,s 
                    suba     #SPACE_BETWEEN_LINES 
                    sta      ,s                           ; next line of font is this much further down 
                    cmpx     #FONT_START_A + ((FONT_HEIGHT-1)*FONT_LENGTH) 
                    bne      continuePrinting\? 
                    lda      ,s 
                    suba     #SPACE_BETWEEN_STRINGS 
                    sta      ,s                           ; next line of font is this much further down 
; somehow get next x offset!
nextOne\? 
                    lda      ,u+ 
                    bpl      nextOne\? 
                    lda      ,u 
                    sta      it_xlinePrintOffset 
                    leau     ,y 
                    bra      skipWait\? 

continuePrinting\? 
; when using higher scale for screen positioing - adjust these waits!
                    WAIT36                                ; uses S register for a PSHS wait! 
;                    tfr      a,a                            ; 6 WAIT 
;                    tfr      a,a                            ; 6 WAIT 
;                    nop      2                              ; 4 WAIT 
;                    nop      10                             ; 20 WAIT 
skipWait\? 
                    ldd      #$1881                       ; preload values ;a?AUX: b?ORB: $8x = Disable RAMP, Disable Mux, mux sel = 01 (int offsets) 
                    STB      <VIA_port_b                  ;ramp off/on set mux to channel 1 
                    STA      <VIA_aux_cntl                ;Shift reg mode = 110 (shift out under system clock), T1 PB7 disabled, one shot mode 
                    CLR      <VIA_port_a                  ;Clear D/A output 
                    dec      <VIA_port_b 
                    nop                                   ; if not done on a real vectrex - uper lines end up slighjtly diagonal 
                    stb      <VIA_port_b                  ;Disable mux 
                    ldd      #SCROLLTEXTSIZE*256+01 
                    STA      <VIA_port_a                  ;Send it to the D/A 
                    STb      <VIA_port_b                  ;[4]enable RAMP, disable mux (start moving) 
                    LDa      ,U+                          ;Get next character 
decodeChar\? 
                    LDA      A,X                          ;Get bitmap from chargen table 
                    STA      <VIA_shift_reg               ;Save in shift register 
                    LDa      ,U+                          ;Get next character 
                    BPL      decodeChar\?                 ;Go back if not terminator 
                    LDd      #$98cc                       ;restore aux settings and zero 
                    STd      <VIA_aux_cntl                ;T1?PB7 enabled 
                    endm     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; u pointer $80 +1
; in ,s position where position is synced to
NEXT_SYNC_BITMAP_LINE2_NEXT  macro  
; zero is short, since we stay near center -> no wait loop!
; zero was done by last printing 
                    ldd      #(%10000000)*256             ; zero the integrators 
                                                          ; stb <VIA_cntl ; store zeroing values to cntl 
                    stb      <VIA_port_a                  ; reset integrator offset 
                    sta      <VIA_port_b                  ; while waiting, zero integrators (enable mux to "y") 
                    inca     
                    sta      <VIA_port_b                  ; disable mux 
                    ldd      ,s                           ; load position 
                    addb     it_xlinePrintOffset 
                    MY_MOVE_TO_D_START           ; move there, from now on "in move" 
                    dec      tmp2_lc                      ; test if line max reached, if so jump out of endless loop (out of macro) 
                    beq      breakDueTo25Lines 
                    lda      ,s                           ; ensure spacing between bitmap lines 
                    suba     #SPACE_BETWEEN_LINES 
                    sta      ,s                           ; next line of font is this much further down 
                    LEAx     FONT_LENGTH,x                ; ensure FONT is pointing to "row" of bitmap 
                    cmpx     #FONT_START_A + (FONT_HEIGHT*FONT_LENGTH) ; if end -> start next String 
                    beq      nextLineToPrint\? 
                    cmpx     #FONT_START_A + ((FONT_HEIGHT-1)*FONT_LENGTH) ; if one before end, ensure, next time position is updated wirh "in between string" spacing 
                    bne      continueNormalLinePrinting\? 
                    ldb      ,u 
                    stb      it_xlinePrintOffset 
                    lda      ,s 
                    suba     #SPACE_BETWEEN_STRINGS 
                    sta      ,s                           ; next line of font is this much further down 
continueNormalLinePrinting\? 
                    leau     ,y                           ; reset u 
                    bra      continuePrinting\? 

nextLineToPrint\? 
; u is correct
                    ldb      ,u+                          ; neg is end of list, value is xline offset, skip it! 
                    bmi      completelyOutOfHere 
                    leay     ,u                           ; save current u 
                    Ldx      #FONT_START_A                ; start new font "row" 
continuePrinting\? 
                    nop      2                            ; WAIT 
; waiting for timer to expire
                    ldd      #$1881                       ; preload values ;a?AUX: b?ORB: $8x = Disable RAMP, Disable Mux, mux sel = 01 (int offsets) 
                    STB      <VIA_port_b                  ;ramp off/on set mux to channel 1 
                    STA      <VIA_aux_cntl                ;Shift reg mode = 110 (shift out under system clock), T1 PB7 disabled, one shot mode 
                    CLR      <VIA_port_a                  ;Clear D/A output 
                    dec      <VIA_port_b 
                    nop                                   ; if not done on a real vectrex - uper lines end up slighjtly diagonal 

                    stb      <VIA_port_b                  ;Disable mux 
                    ldd      #SCROLLTEXTSIZE*256+01 
                    STA      <VIA_port_a                  ;Send it to the D/A 
                    STb      <VIA_port_b                  ;[4]enable RAMP, disable mux (start moving) 
                    LDa      ,U+                          ;Get next character 
decodeChar\?: 
                    LDA      A,X                          ;Get bitmap from chargen table 
                    STA      <VIA_shift_reg               ;Save in shift register 
                    LDa      ,U+                          ;Get next character 
                    BPL      decodeChar\?                 ;Go back if not terminator 
                    LDd      #$98cc                       ;restore aux settings and zero 
                    STd      <VIA_aux_cntl                ;T1?PB7 enabled 
                    endm     
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; in u pointer to first line of String "pointers"
; "BITMAP_LINES_TITLE" lines are printed
; in a NO of String line to start with, assumed < FONT_HEIGHT
; in x sync coordinates
; 
printStringList_25_Sync_direct                            ;#isfunction  
; put move position on stack put it so, that we can load "d" directly from stack
                    pshs     x 
                    LDX      #FONT_START_A                ;Point to start of chargen bitmaps 
; start at position IN Char
overstepOtherFontLine2 
                    deca     
                    bmi      fontPosOk2 
                    LEAx     FONT_LENGTH,x 
                    bra      overstepOtherFontLine2 

fontPosOk2 
;if (x == FONT_START_A+5*FONT_LENGTH) -> reset and find new string line
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; POSITION "EXACT" PATCH assuming x pos is middle aligned, 
; if that is a case we can use neg x pos as "opposite" string pos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; we assume we ARE zeroing here!
                    ldd      #(%10000000)*256             ; zero the integrators 
                                                          ; stb <VIA_port_a ; reset integrator offset 
                                                          ; lda #%10000010 
                                                          ; wait that zeroing surely has the desired effect! 
                    std      <VIA_port_b                  ; while waiting, zero offsets 
                    ldd      ,s 
                    negb     
                    MY_MOVE_TO_D_START  
                    lda      #BITMAP_LINES_TITLE          ; that many lines must be printed 
                    sta      tmp2_lc 
                    lda      ,u+ 
                    leay     ,u                           ; in y always a savecopy of current u AFTER the offset 
                    sta      it_xlinePrintOffset 
                    MY_MOVE_TO_A_END  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    NEXT_SYNC_BITMAP_LINE2_FIRST  
repeatTillBreak 
                    NEXT_SYNC_BITMAP_LINE2_NEXT  
                    bra      repeatTillBreak 

breakDueTo25Lines 
; zero
                    clra     
                    MY_MOVE_TO_B_END                      ; ensure timer is finished, otherwise we leave our trusty bank 0 
                    sta      <VIA_shift_reg 
                    puls     d ,pc                        ; all done, correct stack 
; end if string list encountered
completelyOutOfHere 
                    MY_MOVE_TO_B_END                      ; ensure timer is finished, otherwise we leave our trusty bank 0 
                    LDd      #$98cc                       ;[2]disable mux, disable ramp 
                    STd      <VIA_aux_cntl                ;T1?PB7 enabled 
                    puls     d ,pc                        ; all done, correct stack 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MAX_STRING_NO_DISPLAY  =     66                           ;64 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; scroller
initExtro
                    clr      it_stringCounter 
                    clr      it_lineCounter 
                    clr      it_linePrintOffset 
                    rts      

playExtro
REPLACE_2_2_BellaSceneData_varFromBank2_1 
                    ldy      #0 
REPLACE_1_2_drawSmartScene_varFromBank2_12 
                    ldx      #0 
                    jsr      jsrBank3to2 



                    lda      #$38                         ;30;28 ; scale used for positioning of scroller (strength is maxed $) changing -> waits in scroller must be adjusted 
                    sta      <VIA_t1_cnt_lo 
                    jsr      Reset_Pen 
                    jsr      Intensity_5F 
                    ldd      #$7fa0                       ;$7f90;$7f81 ; move to 
                    suba     it_linePrintOffset 
                    tfr      d,x 
                    ldu      #IntroTextScrollPointers 
                    ldb      it_stringCounter 
                    clra     
                    MY_LSL_D  
                    ldu      d,u 
                    lda      it_lineCounter 
                    jsr      printStringList_25_Sync_direct 
                    lda      Vec_Loop_Count+1 
                    anda     #%11                         ; decrease scroller each 3rd round 
                    bne      noChangeStageScroller 
                    lda      it_linePrintOffset 
                    bne      offsetChangeOnly 
                    lda      it_lineCounter 
                    inca     
                    cmpa     #FONT_HEIGHT 
                    bne      staLineCounter 
                    clra     
                    ldb      it_linePrintOffset 
                    addb     #SPACE_BETWEEN_STRINGS 
                    stb      it_linePrintOffset 
                    ldb      it_stringCounter 
                    incb     
                    cmpb     #MAX_STRING_NO_DISPLAY       ; number of max string lines printed at the moment (should be determined somehow) 
                    bne      keepStrinGlines 
                    bra      StageScrollerFinished 

                    clrb     
keepStrinGlines 
                    stb      it_stringCounter 
staLineCounter 
                    sta      it_lineCounter 
noChangeStageScroller 
                    rts      
StageScrollerFinished
                    clr      demoRunningFlag 
                    rts      


offsetChangeOnly 
                    ldb      it_linePrintOffset 
                    subb     #SPACE_BETWEEN_LINES 
                    stb      it_linePrintOffset 
                    rts      

; pointers are only needed/used in determining the start of the printing
; the text itself must be continuous from the
; start pointer passed to the scroll function
IntroTextScrollPointers 
                    dw       line01a_it 
                    dw       line01b_it 
                    dw       line01_it 
                    dw       line02_it 
                    dw       line03_it 
                    dw       line04_it 
                    dw       line05_it 
                    dw       line06_it 
                    dw       line07_it 
                    dw       line08_it 
                    dw       line09_it 
                    dw       line10_it 
                    dw       line11_it 
                    dw       line12_it 
                    dw       line13_it 
                    dw       line14_it 
                    dw       line15_it 
                    dw       line16_it 
                    dw       line17_it 
                    dw       line18_it 
                    dw       line19_it 
                    dw       line20_it 
                    dw       line21_it 
                    dw       line22_it 
                    dw       line23_it 
                    dw       line24_it 
                    dw       line25_it 
                    dw       line22_ita 
                    dw       line23_ita 
                    dw       line24_ita 
                    dw       line25_ita 
                    dw       line26_it 
                    dw       line27_it 
                    dw       line28_it 
                    dw       line29_it 
                    dw       line30_it 
                    dw       line31_it 
                    dw       line32_it 
                    dw       line33_it 
                    dw       line34_it 
                    dw       line40_it 
                    dw       line41_it 
                    dw       line52_1_it 
                    dw       line52_2_it 
                    dw       line52_3_it 
                    dw       line52ae1_it 
                    dw       line52ae2_it 
                    dw       line55_it 
                    dw       line56_it 
                    dw       line57_it 
                    dw       line58_it 
                    dw       line59_it 
                    dw       line60_it 
                    dw       line61_it 
                    dw       line62_it 
                    dw       line63_it 
                    dw       line64_it 
                    dw       line65_it 
                    dw       line66_it 
                    dw       line67_it 
                    dw       line68_it 
                    dw       line69_it 
                    dw       line70_it 
                    dw       line71_it 
                    dw       line72_it 
                    dw       line73_it 
                    DW       0 

NONE_CHAR           equ      0 
HALF_CHAR           equ      10 
QUAR_CHAR           equ      5 

scrollTextsDirect 
line01a_it          db       NONE_CHAR, " ",$80 
line01b_it          db       NONE_CHAR, " ",$80 
line01_it           db       NONE_CHAR, " ",$80 
line02_it           db       NONE_CHAR, " ",$80 
line03_it           db       NONE_CHAR, " ",$80 
line04_it           db       NONE_CHAR, " ",$80 
line05_it           db       NONE_CHAR, " ",$80 
line06_it           db       NONE_CHAR, " ",$80 
line07_it           db       NONE_CHAR, " CHRISTMAS",$80
line08_it           db       NONE_CHAR, "   2024",$80 
line09_it           db       NONE_CHAR, " ",$80 
line10_it           db       NONE_CHAR, " ",$80 
line11_it           db       NONE_CHAR, " ",$80 
line12_it           db       NONE_CHAR, "  WRITTEN",$80
line13_it           db       HALF_CHAR, "    BY",$80
line14_it           db       HALF_CHAR , "  MALBAN",$80
line15_it           db       NONE_CHAR, " ",$80
line16_it           db       NONE_CHAR, " ",$80 
line17_it           db       NONE_CHAR, " ",$80
line18_it           db       NONE_CHAR, " ",$80
line19_it           db       NONE_CHAR, "   MUSIC",$80
line20_it           db       HALF_CHAR, "    BY",$80
line21_it           db       NONE_CHAR, "   DIVERS",$80
line22_it           db       NONE_CHAR, " ",$80
line23_it           db       NONE_CHAR, " ",$80
line24_it           db       NONE_CHAR, " ",$80
line25_it           db       NONE_CHAR, " ",$80
;line18_ita          db       NONE_CHAR, " ADDITIONAL",$80
;line19_ita          db       NONE_CHAR, "    GFX",$80
;line20_ita          db       HALF_CHAR, "    BY",$80
;line51_ita          db       HALF_CHAR, " SELANSKI",$80
line22_ita          db       NONE_CHAR, " ",$80
line23_ita          db       NONE_CHAR, " ",$80
line24_ita          db       NONE_CHAR, " ",$80
line25_ita          db       NONE_CHAR, " ",$80
line26_it           db       NONE_CHAR, " ENJOY THE",$80 
line27_it           db       NONE_CHAR, "   SHOW!",$80
line28_it           db       NONE_CHAR, " ",$80
line29_it           db       NONE_CHAR, " ",$80
line30_it           db       NONE_CHAR, " ",$80
line31_it           db       NONE_CHAR, " ",$80
line32_it           db       NONE_CHAR, " GREETINGS",$80
line33_it           db       HALF_CHAR, "    TO",$80
line34_it           db       NONE_CHAR, " ",$80
;line35_it           db       HALF_CHAR, "   ALEX",$80
;line36_it           db       HALF_CHAR, "  THOMAS",$80
;line37_it           db       NONE_CHAR, "VECTREXMAD!",$80
;line38_it           db       NONE_CHAR, "  KRISTOF",$80
;line39_it           db       HALF_CHAR, "  SASCHA",$80
line40_it           db       HALF_CHAR, "   PEER",$80
line41_it           db       HALF_CHAR, " CHRIS P.",$80
;line42_it           db       HALF_CHAR, " CHRIS M.",$80
;line43_it           db       HALF_CHAR, " CHRIS T.",$80
;line44_it           db       HALF_CHAR, " CHRIS R.",$80
;line45_it           db       NONE_CHAR, "  RICHARD",$80
;line46_it           db       NONE_CHAR, "   GAUZE",$80
;line47_it           db       HALF_CHAR, "  GEORGE",$80
;line48_it           db       HALF_CHAR, "   CLAY",$80
;line49_it           db       HALF_CHAR, "   JOHN",$80
;line50_it           db       HALF_CHAR, "   JUAN",$80
;line51_it           db       HALF_CHAR, " SELANSKI",$80
;line52_it           db       NONE_CHAR, "VECTREXROLI",$80
line52_1_it         db       NONE_CHAR, "   BRETT",$80
line52_2_it         db       HALF_CHAR, "  NATHAN",$80
line52_3_it         db       HALF_CHAR, "  GRAHAM",$80
;line52_4_it         db       HALF_CHAR, "   TONY",$80
line52ae1_it        db       NONE_CHAR, " ",$80
line52ae2_it        db       NONE_CHAR, " ",$80
;line52a1_it         db       NONE_CHAR, "  SPECIAL",$80
;line52a2_it         db       HALF_CHAR, "  THANKS",$80
;line52a3_it         db       HALF_CHAR, " FOR HELP",$80
;line52a4_it         db       NONE_CHAR, "AND TESTING",$80
;line52a_it          db       NONE_CHAR, " ",$80
;line52c_it          db       HALF_CHAR, "  HELMUT",$80
;line52d_it          db       HALF_CHAR, "  JEROME",$80
;line52e_it          db       NONE_CHAR, "    VTK",$80
;line52f_it          db       NONE_CHAR, "    NIC",$80
;line52g_it          db       HALF_CHAR, "   PEER",$80
;line53_it           db       NONE_CHAR, " ",$80
;line54_it           db       NONE_CHAR, " ",$80
line55_it           db       NONE_CHAR, " ",$80
line56_it           db       NONE_CHAR, " ",$80
line57_it           db       NONE_CHAR, " ",$80
line58_it           db       NONE_CHAR, " ",$80
line59_it           db       HALF_CHAR, " KEEP THE",$80 
line60_it           db       NONE_CHAR, "  VECTREX",$80 
line61_it           db       HALF_CHAR, "  ALIVE!",$80 
line62_it           db       NONE_CHAR, " ",$80 
line63_it           db       NONE_CHAR, " ",$80 
line64_it           db       NONE_CHAR, " ",$80 
line65_it           db       NONE_CHAR, " ",$80 
line66_it           db       NONE_CHAR, " ",$80 
line67_it           db       NONE_CHAR, " ",$80 
line68_it           db       NONE_CHAR, " ",$80 
line69_it           db       NONE_CHAR, " ",$80 
line70_it           db       NONE_CHAR, " ",$80 
line71_it           db       NONE_CHAR, " ",$80 
line72_it           db       NONE_CHAR, " ",$80 
line73_it           db       NONE_CHAR, " ",$80 
                    db       -1                           ; = end 
