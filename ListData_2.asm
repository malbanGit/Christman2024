MegaStarSceneData
 DW MegaStar_0 ; list of all single vectorlists in this
 DW MegaStar_1
 DW MegaStar_2
 DW MegaStar_3
 DW MegaStar_4
 DW MegaStar_5
 DW MegaStar_6
 DW MegaStar_7
 DW MegaStar_8
 DW MegaStar_9
 DW MegaStar_10
 DW MegaStar_11
 DW MegaStar_12
 DW MegaStar_13
 DW MegaStar_14
 DW MegaStar_15
 DW MegaStar_16
 DW MegaStar_17
 DW MegaStar_18
 DW MegaStar_19
 DW 0

MegaStar_0
	db  $5D, $01,  $00, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $3F, $01,  $00, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $36, $01,  $40, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $12, $01,  $3E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$0F, $01,  $51, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$0C, $01,  $55
	db  $3B, $01,  $5F
	db  $64, $01,  $09
	db  $2B, $01, -$32
	db  $11, $01, -$22
	db -$11, $01, -$52
	db -$18, $01, -$44, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db -$26, $01, -$28
	db -$4F, $01, -$31
	db -$1B, $01, -$45
	db -$16, $01, -$42
	db  $77, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $0F, $01,  $3E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $44, $01,  $71, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $29, $01,  $00
	db  $00, $01, -$54
	db -$29, $01, -$47
	db -$23, $01, -$46
	db  $4C, $01, -$0C
	db  $42, $01,  $03
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MegaStar_1
	db  $65, $01,  $00, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $65, $01,  $00, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$16, $01, -$1B, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$3F, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $27, $01, -$50, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$4B, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db -$29, $01,  $00
	db -$44, $01,  $6E
	db -$0F, $01,  $3F, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$77, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $26, $01, -$43, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $22, $01, -$40
	db  $3E, $01, -$31
	db  $38, $01, -$29
	db  $19, $01, -$3F
	db -$08, $01, -$56
	db -$11, $01, -$29
	db -$2B, $01, -$32, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db -$6D, $01,  $00
	db -$41, $01,  $4A
	db  $03, $01,  $60
	db  $18, $01,  $46
	db  $16, $01,  $22
	db -$30, $01,  $5D, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$3E, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MegaStar_2
	db  $5D, $01, -$04, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$3E, $01,  $00, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$28, $01, -$5D, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db -$38, $01, -$26
	db -$4F, $01,  $00
	db -$27, $01,  $41, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$51, $01,  $12, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$2B, $01, -$3F
	db  $16, $01, -$3F
	db  $16, $01, -$35
	db  $6A, $01, -$28
	db  $35, $01, -$61
	db -$0F, $01, -$48
	db -$0B, $01, -$3D, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $20, $01, -$69
	db  $17, $01, -$4F
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MegaStar_3
	db  $31, $01, -$6C, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $24, $01, -$50, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $4B, $01, -$34, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $4D, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $20, $01,  $47, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db  $39, $01,  $2E
	db  $52, $01,  $06
	db  $1F, $01, -$15
	db  $16, $01, -$2E
	db  $00, $01, -$43, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$38, $01, -$41, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db -$55, $01, -$15
	db -$33, $01,  $34
	db -$20, $01,  $31
	db -$4D, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $19, $01, -$40, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $1B, $01, -$41, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $67, $01, -$0D, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $0E, $01, -$2D, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$5F, $01,  $03, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $13, $01, -$37, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $20, $01, -$21
	db  $11, $01, -$22
	db  $00, $01, -$28
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MegaStar_4
	db  $32, $01, -$6F, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $32, $01, -$6F, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$41, $01,  $03, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$1F, $01,  $4D, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$19, $01,  $3F
	db -$1E, $01, -$6A
	db -$14, $01, -$55
	db -$3C, $01,  $00
	db  $00, $01,  $3F
	db  $31, $01,  $4E
	db  $1F, $01,  $6E, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$19, $01,  $40, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$19, $01,  $48, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$2B, $01, -$53, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$16, $01, -$51
	db  $12, $01, -$6D
	db  $04, $01, -$49
	db -$16, $01, -$46
	db -$42, $01, -$39
	db -$66, $01,  $00
	db -$27, $01,  $54, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db -$0D, $01,  $59
	db  $16, $01,  $39
	db  $2E, $01,  $26
	db  $2C, $01,  $0A
	db  $1E, $01,  $14
	db  $1B, $01,  $3D, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $16, $01,  $3E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$20, $01,  $41, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MegaStar_5
	db  $29, $01, -$6B, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$20, $01,  $4E, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$66, $01,  $00, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$2A, $01,  $2B
	db -$0D, $01,  $30
	db -$02, $01,  $61
	db  $11, $01,  $5D
	db -$1B, $01,  $48
	db -$0F, $01,  $35
	db -$0F, $01, -$47, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$1B, $01, -$32
	db  $0F, $01, -$3C
	db  $0C, $01, -$25
	db -$0C, $01, -$4A
	db -$21, $01, -$4C
	db -$22, $01, -$21
	db -$40, $01, -$05, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$1C, $01, -$4C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MegaStar_6
	db -$23, $01, -$6B, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$2B, $01, -$47, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $1A, $01, -$3E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $29, $01, -$6E, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $39, $01, -$02
	db  $2E, $01, -$22
	db  $16, $01, -$2C
	db  $16, $01, -$39
	db -$16, $01, -$53
	db -$21, $01, -$3A
	db -$52, $01, -$1A, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$42, $01,  $20
	db -$1F, $01,  $50
	db  $03, $01,  $68
	db  $1C, $01,  $4C
	db -$1F, $01,  $6A
	db -$14, $01,  $3F
	db -$20, $01, -$45, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$3C, $01, -$71, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $29, $01, -$69
	db  $28, $01, -$6E
	db  $00, $01, -$33
	db -$33, $01,  $00
	db -$1E, $01,  $4E
	db -$14, $01,  $53
	db -$6B, $01, -$6E, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$1B, $01,  $0F
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MegaStar_7
	db -$31, $01, -$6E, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$31, $01, -$6E, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$04, $01,  $16, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $22, $01,  $2B, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $27, $01,  $3A
	db -$09, $01,  $2B
	db -$51, $01, -$05, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$1F, $01,  $27, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $74, $01,  $17
	db  $6E, $01,  $0F
	db  $40, $01,  $73
	db  $1F, $01,  $43, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$48, $01,  $00, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$42, $01, -$06
	db -$34, $01, -$31
	db -$2F, $01, -$31
	db -$61, $01,  $06
	db -$47, $01,  $4D
	db  $03, $01,  $6E
	db  $2B, $01,  $47, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $19, $01,  $15
	db  $5C, $01, -$19
	db  $34, $01, -$1B
	db  $34, $01, -$47
	db  $74, $01,  $00
	db  $48, $01,  $4E
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MegaStar_8
	db -$34, $01, -$73, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $32, $01,  $67, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$30, $01,  $5E, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $0E, $01,  $61
	db  $22, $01,  $2C
	db  $32, $01,  $27
	db  $46, $01,  $15
	db  $22, $01,  $35
	db  $00, $01,  $41
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MegaStar_9
	db -$3C, $01, -$48, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $00, $01,  $2D, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$5D, $01,  $00, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db -$1F, $01, -$37
	db -$1E, $01, -$2A
	db -$6F, $01,  $00
	db -$20, $01,  $2A
	db -$28, $01,  $37
	db -$42, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MegaStar_10
	db -$59, $01, -$04, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$42, $01,  $00, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$38, $01, -$61, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$38, $01, -$71
	db  $00, $01, -$58
	db -$04, $01, -$2B
	db -$19, $01, -$44
	db -$39, $01, -$24
	db -$2B, $01, -$07
	db -$58, $01,  $1A, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$1A, $01,  $4B
	db  $00, $01,  $40
	db  $13, $01,  $33
	db  $1D, $01,  $31
	db  $4C, $01,  $1A
	db  $55, $01,  $04
	db  $22, $01,  $50, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $2E, $01,  $4D
	db -$77, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$1F, $01, -$3F, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$35, $01, -$6E, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db -$2D, $01,  $00
	db  $00, $01,  $4B
	db  $31, $01,  $50, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$45, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$1F, $01,  $03, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MegaStar_11
	db -$64, $01, -$01, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$64, $01, -$01, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$04, $01,  $15, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $50, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01,  $48, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db -$1B, $01,  $3F
	db -$3C, $01,  $32
	db  $09, $01,  $34
	db  $2D, $01,  $00
	db  $40, $01, -$71
	db  $19, $01, -$3E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $77, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$2E, $01,  $52, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$22, $01,  $47
	db -$55, $01,  $0A
	db -$4C, $01,  $19
	db -$0F, $01,  $0F
	db -$0E, $01,  $0B
	db -$1C, $01,  $3F
	db  $09, $01,  $50, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $20, $01,  $42
	db  $24, $01,  $23
	db  $44, $01,  $03
	db  $4E, $01, -$30
	db  $1D, $01, -$35
	db  $00, $01, -$3C
	db  $00, $01, -$5D, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $38, $01, -$67
	db  $38, $01, -$68
	db  $45, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MegaStar_12
	db -$59, $01,  $00, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $45, $01,  $00, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $46, $01,  $64, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db  $67, $01,  $11
	db  $47, $01, -$75
	db  $5D, $01,  $00
	db  $00, $01,  $28
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MegaStar_13
	db -$3C, $01,  $2A, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $00, $01,  $3E, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$22, $01,  $36, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db -$5A, $01,  $00
	db -$1E, $01,  $38
	db -$22, $01,  $31
	db -$06, $01,  $65
	db  $28, $01,  $56
	db -$1B, $01,  $43, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MegaStar_14
	db -$2E, $01,  $63, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$20, $01,  $40, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$37, $01,  $0A, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$39, $01, -$0A
	db -$35, $01, -$16
	db -$38, $01, -$30
	db -$3E, $01, -$09
	db -$41, $01,  $0C
	db -$23, $01,  $57
	db  $01, $01,  $46, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $22, $01,  $33
	db  $21, $01,  $2F
	db  $61, $01,  $0C
	db  $20, $01, -$47
	db  $21, $01, -$42
	db  $68, $01,  $0C
	db -$17, $01,  $4E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$20, $01,  $3E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$6F, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $18, $01,  $35, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $52, $01,  $05, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$20, $01,  $42, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $04, $01,  $1A, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MegaStar_15
	db -$31, $01,  $6C, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$31, $01,  $6C, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $1E, $01,  $07, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $6B, $01, -$6E, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $2D, $01,  $53
	db  $08, $01,  $48
	db  $30, $01,  $1E
	db  $00, $01, -$4B
	db -$28, $01, -$6E
	db -$29, $01, -$6C
	db  $29, $01, -$73, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $24, $01, -$40, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $19, $01,  $44, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $2E, $01,  $6F
	db -$1F, $01,  $43
	db -$0C, $01,  $4E
	db  $22, $01,  $57
	db  $36, $01,  $2F
	db  $47, $01,  $03
	db  $38, $01, -$53, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db  $16, $01, -$3F
	db -$0A, $01, -$50
	db -$3E, $01, -$41
	db -$4B, $01, -$0A
	db -$29, $01, -$6F
	db -$1A, $01, -$47, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $27, $01, -$3E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MegaStar_16
	db -$23, $01,  $66, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $1C, $01, -$4D, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $3C, $01, -$08, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $40, $01, -$21
	db  $13, $01, -$2B
	db -$0C, $01, -$6D
	db -$0F, $01, -$4D
	db  $1B, $01, -$54
	db  $0F, $01, -$3E
	db  $1B, $01,  $52, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $21, $01,  $53
	db -$12, $01,  $3E
	db -$0F, $01,  $58
	db  $1C, $01,  $51
	db  $31, $01,  $14
	db  $50, $01,  $00
	db  $1A, $01,  $4A, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MegaStar_17
	db  $29, $01,  $66, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $21, $01,  $4C, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$16, $01,  $40, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$37, $01,  $6F, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$3C, $01,  $18
	db -$3C, $01,  $3B
	db -$0C, $01,  $56
	db  $0C, $01,  $45
	db  $4E, $01,  $48
	db  $5B, $01, -$09
	db  $1D, $01, -$32, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db  $1F, $01, -$43
	db -$17, $01, -$56
	db -$08, $01, -$62
	db  $16, $01, -$5C
	db  $28, $01, -$49
	db  $1B, $01,  $42, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $32, $01,  $73, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$14, $01,  $6C
	db -$2B, $01,  $74
	db -$02, $01,  $42
	db  $24, $01, -$0E
	db  $1D, $01, -$5D
	db  $2A, $01, -$61
	db  $2C, $01,  $45, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $33, $01,  $4E
	db  $11, $01, -$15
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MegaStar_18
	db  $33, $01,  $6C, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $33, $01,  $6C, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$02, $01, -$17, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$25, $01, -$3D, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$1E, $01, -$3E
	db  $5E, $01, -$04, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$24, $01, -$35, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$5C, $01, -$05, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$1B, $01, -$3E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$20, $01, -$46, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $55, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $20, $01,  $33, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $43, $01,  $35
	db  $48, $01, -$06
	db  $38, $01, -$42
	db -$03, $01, -$47, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$34, $01, -$4F, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db -$40, $01, -$0D
	db -$4C, $01,  $3A
	db -$1D, $01,  $50
	db -$5B, $01,  $06, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MegaStar_19
	db  $2F, $01,  $5D, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$27, $01, -$4B, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$1F, $01, -$4A, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $1A, $01, -$5D, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $00, $01, -$5E
	db -$1A, $01, -$31
	db -$2A, $01, -$2D
	db -$47, $01, -$0B
	db -$40, $01, -$62
	db  $00, $01, -$3C
	db  $3E, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $4F, $01,  $59, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $6D, $01,  $05
	db  $37, $01, -$5E
	db  $45, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)



RendeerSceneData
 DW Rendeer_0 ; list of all single vectorlists in this
 DW Rendeer_1
 DW Rendeer_2
 DW Rendeer_3
 DW Rendeer_4
 DW Rendeer_5
 DW Rendeer_6
 DW Rendeer_7
 DW Rendeer_8
 DW 0

Rendeer_0
	db  $5D, $01,  $0C, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $5D, $01,  $0C, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$60, $01, -$40, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$48, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$48, $01, -$08, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$50, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $50, $01, -$20, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $20, $01, -$30, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $10, $01, -$30
	db  $00, $01, -$10
	db -$20, $01, -$20
	db -$40, $01,  $20, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$48, $01,  $18, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$50, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$30, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $60, $01, -$30
	db  $40, $01, -$40
	db  $10, $01, -$20, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$50, $01,  $20, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$40, $01,  $10
	db -$48, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$50, $01, -$40, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $10, $01, -$30
	db  $10, $01, -$40
	db  $00, $01, -$40, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$7E, hi(SMVB_continue_yStays_single), lo(SMVB_continue_yStays_single); y is  $00
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Rendeer_1
	db  $3E, $01, -$62, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $58, $01,  $00, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$10, $01, -$10, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$10, $01, -$20
	db -$30, $01, -$20
	db -$40, $01, -$10
	db  $00, $01, -$30
	db -$10, $01, -$30
	db  $20, $01, -$10
	db  $30, $01, -$10, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $70, $01,  $20
	db  $60, $01,  $10
	db  $10, $01, -$10
	db  $10, $01, -$20
	db -$20, $01, -$20
	db  $00, $01, -$10
	db -$60, $01, -$10, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$10, $01, -$20, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $00, $01, -$10
	db  $40, $01, -$10
	db  $40, $01,  $00
	db  $60, $01, -$15, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $30, $01, -$20, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $30, $01, -$30
	db  $00, $01, -$70
	db -$50, $01,  $00
	db -$60, $01,  $28, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $00, $01, -$10, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$10, $01,  $00
	db  $30, $01, -$70
	db  $20, $01, -$70
	db  $00, $01, -$50
	db -$20, $01,  $20
	db -$20, $01,  $30
	db -$20, $01,  $50, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$10, $01, -$10, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $10, $01, -$40, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $00, $01, -$50
	db -$10, $01, -$30
	db -$20, $01, -$30
	db -$10, $01,  $10, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $0C, $01,  $60, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $00, $01,  $57, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Rendeer_2
	db  $3A, $01, -$6A, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$20, $01,  $00, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $00, $01, -$48, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$20, $01, -$10, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$20, $01,  $60, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db -$30, $01,  $50
	db -$20, $01,  $00
	db -$40, $01, -$40
	db -$60, $01, -$50
	db -$30, $01, -$6A, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$30, $01, -$20, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db -$20, $01, -$20
	db -$50, $01,  $00
	db -$50, $01,  $60
	db -$08, $01,  $50, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$30, $01,  $60, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01,  $48, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $30, $01,  $30, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $48, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $01,  $40, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $30, $01,  $50
	db -$13, $01,  $07
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Rendeer_3
	db -$0A, $01, -$5A, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $00, $01,  $10, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$60, $01,  $40, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db -$50, $01,  $30
	db -$40, $01,  $00
	db -$68, $01, -$40, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$60, $01, -$48, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$68, $01,  $10, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$50, $01,  $40, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$60, $01,  $40
	db  $00, $01,  $40
	db -$10, $01,  $30
	db  $20, $01,  $30
	db  $10, $01,  $20
	db  $60, $01,  $00
	db  $50, $01, -$40, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $60, $01, -$40
	db  $30, $01,  $20
	db  $30, $01,  $10
	db  $70, $01,  $50
	db  $60, $01,  $50
	db  $10, $01,  $20
	db  $17, $01,  $20, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Rendeer_4
	db -$70, $01, -$30, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$62, $01, -$05, hi(SMVB_startDraw_hex), lo(SMVB_startDraw_hex)
	db -$60, $01,  $00, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$10, $01,  $20, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01,  $48, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $20, $01,  $10, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $6A, $01,  $05, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $10, $01,  $10, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $20, $01,  $40, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $20, $01,  $3C
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Rendeer_5
	db -$7A, $01,  $45, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $00, $01,  $5A, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db -$50, $01,  $60, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$20, $01,  $00
	db -$40, $01, -$20, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$48, $01, -$20, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$50, $01, -$10, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$58, $01, -$10, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$60, $01,  $20, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $00, $01,  $50, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $10, $01,  $20, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $20, $01,  $30
	db  $48, $01,  $08, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $50, $01,  $08, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $01,  $18, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $01,  $20, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$0C, $01,  $10, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Rendeer_6
	db -$4A, $01,  $66, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$50, $01, -$10, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$58, $01, -$08, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$70, $01,  $10, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$10, $01,  $20, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db -$10, $01,  $30
	db  $00, $01,  $50
	db  $10, $01,  $60
	db  $60, $01, -$10
	db  $78, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $01, -$08, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $01,  $30, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $01,  $28, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $01,  $08, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$05, $01,  $55, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $30, $01,  $50, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $30, $01,  $00
	db  $08, $01, -$40, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $20, $01,  $20, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $30, $01,  $10
	db  $50, $01,  $00
	db -$10, $01, -$50, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $01, -$20, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db  $30, $01, -$20
	db  $00, $01, -$20
	db -$10, $01, -$30
	db -$60, $01,  $00
	db -$60, $01, -$0C
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Rendeer_7
	db -$05, $01,  $61, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$05, $01,  $61, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $30, $01, -$60, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $2A, $01, -$75, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $08, $01, -$60, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$60, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$10, $01, -$70, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$18, $01, -$70, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$50, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db -$10, $01, -$50
	db  $30, $01,  $10
	db  $56, $01,  $16, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Rendeer_8
	db  $65, $01, -$65, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $00, $01,  $50, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $20, $01,  $20, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $20, $01,  $30
	db  $20, $01, -$10
	db  $00, $01, -$10
	db  $00, $01, -$50, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $01,  $00, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $20, $01,  $40
	db  $30, $01,  $30
	db -$10, $01,  $70
	db -$10, $01,  $60
	db -$10, $01,  $70
	db  $00, $01,  $70
	db  $30, $01,  $00, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db  $20, $01, -$60
	db  $10, $01, -$60
	db  $30, $01,  $00
	db  $00, $01,  $50
	db  $00, $01,  $40
	db  $10, $01,  $70, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $10, $01,  $30, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $20, $01,  $00, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$10, $01, -$70
	db -$10, $01, -$60
	db  $00, $01, -$30
	db -$10, $01, -$30
	db  $40, $01,  $00
	db  $60, $01,  $40
	db  $50, $01,  $30, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $01,  $08, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $48, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$30, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$50, $01, -$40, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)


MariaJosephSceneData
 DW MariaJoseph_0 ; list of all single vectorlists in this
 DW MariaJoseph_1
 DW MariaJoseph_2
 DW MariaJoseph_3
 DW MariaJoseph_4
 DW MariaJoseph_5
 DW MariaJoseph_6
 DW MariaJoseph_7
 DW MariaJoseph_8
 DW MariaJoseph_9
 DW MariaJoseph_10
 DW MariaJoseph_11
 DW MariaJoseph_12
 DW MariaJoseph_13
 DW MariaJoseph_14
 DW MariaJoseph_15
 DW MariaJoseph_16
 DW MariaJoseph_17
 DW 0

MariaJoseph_0
	db  $64, $01,  $4C, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $64, $01,  $4C, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$4E, $01,  $2E, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$5D, $01, -$0A, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$3F, $01, -$29, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $49, $01, -$3F
	db  $3E, $01, -$0A
	db  $34, $01,  $1F
	db  $34, $01, -$1F
	db  $3F, $01, -$3E
	db -$15, $01, -$68
	db -$2A, $01, -$2A, hi(SMVB_continue_yEqx_single), lo(SMVB_continue_yEqx_single); y is -$2A
	db -$77, $01, -$15, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $63, $01, -$29, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $5D, $01,  $29, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $49, $01,  $73, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$1A, $01,  $58, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MariaJoseph_1
	db -$79, $01,  $26, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$44, $01,  $58, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$43, $01,  $0F, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$49, $01,  $49, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$6D, $01, -$0D, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$34, $01, -$2A, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $02, $01, -$67, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $3E, $01, -$49, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $63, $01, -$0F, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $77, $01,  $29, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $72, $01,  $30, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $34, $01,  $0A, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$48, $01,  $5E
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MariaJoseph_2
	db -$58, $01, -$72, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$24, $01,  $58, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $00, $01,  $58, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $20, $01,  $3E, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$61, $01, -$14, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$0A, $01, -$5D, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $6B, $01, -$42, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $6B, $01,  $14, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $1F, $01,  $3F, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$15, $01,  $3E
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MariaJoseph_3
	db -$62, $01, -$7A, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$49, $01,  $00, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$72, $01,  $43, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$49, $01,  $1F, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$0A, $01, -$58, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $68, $01, -$54, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $68, $01, -$0F, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $4E, $01,  $39, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$49, $01,  $0A, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MariaJoseph_4
	db -$0C, $01,  $59, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$0C, $01,  $59, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$3F, $01,  $29, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$3E, $01, -$1F, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $49, $01, -$2A
	db  $72, $01, -$14
	db -$3E, $01,  $34
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MariaJoseph_5
	db -$27, $01, -$58, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$27, $01, -$58, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$3E, $01,  $15, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$7D, $01, -$34, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $5A, $01, -$03, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$53, $01,  $2A, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MariaJoseph_6
	db  $5E, $01,  $77, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $72, $01,  $49, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $53, $01,  $05, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $68, $01, -$3E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $10, $01, -$5E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$15, $01, -$34, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db -$68, $01, -$72
	db -$3F, $01, -$1F
	db -$7C, $01, -$0B
	db -$44, $01,  $10, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$4B, $01,  $41, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MariaJoseph_7
	db  $7E, $01,  $66, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$34, $01, -$0A, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$49, $01, -$5E, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$56, $01, -$0D, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$3F, $01,  $3E, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$33, $01,  $1F
	db -$7F, $01, -$16, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MariaJoseph_8
	db -$7F, $01,  $6A, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $00, $01, -$3F, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $52, $01, -$68, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MariaJoseph_9
	db -$5A, $01,  $11, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $4E, $01,  $24, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$72, $01,  $58, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $5E, $01,  $68, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $7C, $01, -$07, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $3E, $01,  $29, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db  $00, $01, -$7C
	db  $68, $01,  $0A
	db -$34, $01, -$5E
	db -$53, $01, -$29
	db -$34, $01, -$77, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MariaJoseph_10
	db  $3E, $01, -$62, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $3F, $01, -$1F, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $48, $01, -$2A, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $72, $01, -$22, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $34, $01,  $3F, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$20, $01, -$34
	db  $34, $01, -$2A
	db  $5E, $01,  $0A
	db  $68, $01,  $20
	db  $53, $01, -$0B
	db  $1F, $01, -$34
	db  $00, $01, -$5D, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$5D, $01, -$54
	db -$77, $01, -$23, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MariaJoseph_11
	db  $6D, $01, -$70, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $3E, $01, -$34, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $49, $01, -$10, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $72, $01,  $20, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db  $5E, $01,  $48
	db  $34, $01,  $5E
	db  $00, $01,  $5E
	db -$34, $01,  $5D
	db -$68, $01,  $39, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $43, $01, -$10, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $43, $01, -$58, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$68, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db -$49, $01, -$7D
	db -$7D, $01, -$53
	db -$62, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$7D, $01,  $4B, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MariaJoseph_12
	db  $66, $01, -$75, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$53, $01, -$34, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$7D, $01, -$0D, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$3E, $01,  $53, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$53, $01, -$0A
	db  $0A, $01, -$58, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$53, $01, -$5D, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$6B, $01, -$1C, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$53, $01,  $15, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$6F, $01, -$1E, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MariaJoseph_13
	db -$48, $01, -$67, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$48, $01, -$67, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$15, $01,  $3E, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$56, $01,  $03, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$3E, $01,  $0B, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$1F, $01, -$70
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MariaJoseph_14
	db -$67, $01, -$6A, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$67, $01, -$6A, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$01, $01,  $61, hi(SMVB_startDraw_octo), lo(SMVB_startDraw_octo)
	db -$01, $01,  $61, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$01, $01,  $61, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MariaJoseph_15
	db -$6A, $01,  $58, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$6A, $01,  $58, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $34, $01, -$0A, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $6F, $01,  $01, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $48, $01,  $43, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $62, $01,  $2A, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $62, $01, -$0A, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $2F, $01, -$53, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $72, $01, -$1F, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $34, $01, -$2A, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $3F, $01,  $05
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MariaJoseph_16
	db -$5B, $01, -$17, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$5B, $01, -$17, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$3E, $01,  $15, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $0A, $01, -$34, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $3F, $01, -$0B
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
MariaJoseph_17
	db -$69, $01,  $43, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $0B, $01, -$34, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $34, $01, -$15, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$34, $01,  $49
	db  $3E, $01,  $0A, hi(SMVB_startMove_single), lo(SMVB_startMove_single)
	db  $15, $01, -$48, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$0B, $01,  $3E, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)


CherubinSceneData
 DW Cherubin_0 ; list of all single vectorlists in this
 DW Cherubin_1
 DW Cherubin_2
 DW Cherubin_3
 DW Cherubin_4
 DW Cherubin_5
 DW Cherubin_6
 DW Cherubin_7
 DW Cherubin_8
 DW Cherubin_9
 DW Cherubin_10
 DW 0

Cherubin_0
	db  $6B, $01, -$03, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $6B, $01, -$03, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$49, $01, -$2A, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$69, $01, -$0A, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$76, $01, -$28, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Cherubin_1
	db  $4C, $01, -$5A, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$15, $01, -$34, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $0B, $01, -$68, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $0A, $01,  $53
	db  $15, $01, -$3E
	db  $05, $01, -$5D, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$29, $01, -$3F, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$53, $01, -$48, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$0A, $01, -$3C, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Cherubin_2
	db  $05, $01, -$6B, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $4C, $01, -$6E, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db -$1F, $01, -$34, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db -$3F, $01, -$15
	db -$3E, $01,  $00
	db -$1F, $01,  $72
	db -$49, $01,  $15
	db -$33, $01,  $34
	db -$5D, $01,  $0A, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$15, $01, -$53, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$68, $01,  $29
	db -$58, $01,  $43, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$15, $01,  $49, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $2A, $01,  $78, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Cherubin_3
	db -$4D, $01, -$6D, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$5E, $01, -$24, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$7C, $01, -$54, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$2A, $01, -$29
	db -$34, $01, -$1F
	db -$3E, $01, -$5E
	db -$3F, $01,  $0A
	db -$5D, $01, -$53
	db -$0B, $01,  $34
	db -$5D, $01, -$0A, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db -$3F, $01, -$1F
	db -$1F, $01,  $34
	db  $49, $01,  $3E
	db  $68, $01,  $2A
	db -$1F, $01,  $3E
	db  $77, $01,  $5D, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $6B, $01,  $2E, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Cherubin_4
	db -$61, $01, -$53, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$0A, $01,  $3F, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$53, $01,  $6B, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$20, $01,  $69, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $00, $01,  $3F, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $49, $01,  $1B, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Cherubin_5
	db -$77, $01,  $69, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $0A, $01,  $68, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$0A, $01,  $5D, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $0F, $01,  $44, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$0A, $01,  $3E, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $34, $01,  $15
	db  $29, $01, -$34
	db  $00, $01, -$68
	db  $2A, $01, -$53
	db -$34, $01, -$2A
	db  $0A, $01, -$49
	db  $7D, $01, -$0F, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $72, $01, -$1A, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Cherubin_6
	db -$3B, $01,  $69, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $26, $01,  $56, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db  $00, $01,  $49, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $3E, $01, -$34
	db -$0A, $01, -$49
	db  $29, $01, -$5E
	db -$29, $01, -$3E
	db -$2A, $01, -$49
	db  $15, $01, -$34
	db  $43, $01, -$34, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$1A, $01, -$68, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Cherubin_7
	db -$64, $01,  $53, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $3E, $01,  $2A, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $34, $01,  $34, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $3F, $01, -$0B
	db  $34, $01,  $34
	db  $34, $01, -$0A
	db  $3D, $01,  $49
	db  $53, $01,  $34
	db  $15, $01, -$49
	db  $7D, $01,  $7D, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $49, $01,  $29
	db  $3E, $01,  $00
	db -$0A, $01, -$49
	db  $7C, $01,  $3F
	db  $5E, $01,  $1F
	db  $49, $01, -$0A
	db -$15, $01, -$34, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $68, $01,  $0B, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Cherubin_8
	db  $6D, $01,  $47, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $49, $01, -$1F, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$1F, $01, -$34, hi(SMVB_continue_newY_eq_oldX_single), lo(SMVB_continue_newY_eq_oldX_single) ; y is -$1F
	db  $43, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $3E, $01, -$1F, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $0B, $01, -$34
	db -$54, $01, -$2A
	db  $5E, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $34, $01, -$1F, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $0A, $01, -$3E
	db -$3E, $01, -$1F
	db -$5A, $01, -$0A, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $49, $01, -$14, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$0A, $01, -$54
	db  $53, $01,  $00
	db  $3E, $01, -$14
	db -$29, $01, -$3F
	db  $53, $01,  $00
	db  $49, $01, -$14
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Cherubin_9
	db -$01, $01, -$66, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$49, $01,  $0A, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$0F, $01,  $44, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$49, $01,  $34, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$53, $01, -$68, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$0A, $01, -$3F, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $62, $01, -$2E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $49, $01,  $0A, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $34, $01,  $34
	db  $3D, $01,  $1F
	db -$1E, $01,  $49
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Cherubin_10
	db  $06, $01, -$7F, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$14, $01,  $49, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$1F, $01, -$3E, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $0A, $01, -$3F
	db  $34, $01, -$29
	db -$0B, $01,  $5D
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)


Deer2SceneData
 DW Deer2_0 ; list of all single vectorlists in this
 DW Deer2_1
 DW Deer2_2
 DW Deer2_3
 DW Deer2_4
 DW Deer2_5
 DW Deer2_6
 DW Deer2_7
 DW Deer2_8
 DW Deer2_9
 DW Deer2_10
 DW Deer2_11
 DW Deer2_12
 DW 0

Deer2_0
	db  $61, $01,  $25, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $61, $01,  $25, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$59, $01,  $0C, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $43, $01, -$5A, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$4E, $01,  $16
	db -$0C, $01, -$70
	db -$59, $01,  $44
	db -$43, $01,  $43
	db -$65, $01,  $00
	db  $2D, $01, -$70
	db  $59, $01,  $00, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $5A, $01, -$43
	db  $65, $01, -$0C
	db  $60, $01, -$46
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Deer2_1
	db  $66, $01,  $0D, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $66, $01,  $0D, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$4E, $01,  $0B, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$4E, $01,  $0C, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $38, $01, -$5A
	db -$65, $01,  $38
	db -$17, $01, -$4E
	db -$32, $01,  $43, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$70, $01,  $16, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db -$38, $01, -$4E
	db  $43, $01, -$65
	db -$65, $01,  $65
	db -$2D, $01,  $4E
	db -$43, $01, -$38
	db  $05, $01,  $49, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $17, $01,  $70, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$16, $01,  $52, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Deer2_2
	db  $61, $01,  $61, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$16, $01, -$43, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$38, $01,  $38, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db -$70, $01,  $17
	db -$5A, $01, -$22
	db -$4E, $01, -$21
	db -$43, $01, -$4F
	db -$21, $01, -$48, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$1C, $01, -$49, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$7A, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $0B, $01, -$62, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Deer2_3
	db  $09, $01, -$5D, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$21, $01, -$5A, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$2C, $01, -$65, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db -$65, $01, -$59
	db -$64, $01, -$65
	db -$0C, $01,  $65
	db -$6C, $01,  $04, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Deer2_4
	db -$44, $01, -$68, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$34, $01, -$50, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$5A, $01,  $00, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$4E, $01, -$21, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$43, $01, -$38, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$4E, $01, -$0C, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db -$4F, $01, -$0B
	db  $2D, $01,  $43
	db  $38, $01,  $38
	db  $54, $01,  $2D, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $54, $01,  $27, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $2D, $01,  $65, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $2D, $01,  $70
	db  $4E, $01,  $56
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Deer2_5
	db -$5C, $01, -$6A, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$55, $01,  $5D, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$70, $01,  $0B, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$70, $01,  $16
	db -$43, $01,  $27, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$49, $01,  $27, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$4E, $01,  $22, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$22, $01,  $59
	db  $49, $01, -$10, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $7B, $01, -$4F, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $5A, $01, -$16
	db  $4E, $01, -$22
	db  $7C, $01,  $17, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Deer2_6
	db -$7D, $01, -$53, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$2D, $01,  $70, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$0B, $01,  $7C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $02, $01,  $6E, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Deer2_7
	db -$6A, $01,  $3F, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$6C, $01, -$3B, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$43, $01, -$21, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$43, $01, -$43, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db -$44, $01, -$38
	db -$7B, $01, -$2D
	db -$70, $01,  $00
	db  $65, $01,  $5A
	db  $5A, $01,  $2C
	db  $48, $01,  $38, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $4E, $01,  $38, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $46, $01,  $38, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Deer2_8
	db -$64, $01,  $4E, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$0E, $01,  $7E, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db -$5A, $01, -$38, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db -$43, $01, -$5A
	db -$38, $01, -$5A
	db -$70, $01, -$16
	db  $2D, $01,  $59, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $48, $01,  $5F, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $65, $01,  $59, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $2D, $01, -$4E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $2C, $01, -$64, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Deer2_9
	db -$4F, $01,  $7E, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $3F, $01,  $0E, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $70, $01,  $0B, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $49, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $4D, $01,  $0B, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $4E, $01,  $05, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $2D, $01,  $7B, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db -$16, $01,  $7C
	db  $64, $01,  $43
	db  $3E, $01, -$49, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $1C, $01, -$48, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $16, $01, -$78, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Deer2_10
	db  $62, $01,  $79, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $21, $01,  $43, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $43, $01,  $59, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $4F, $01,  $4F
	db  $00, $01,  $4E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $38, $01, -$65, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $16, $01, -$4F
	db  $5A, $01, -$2C
	db -$43, $01, -$11, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$4E, $01, -$38, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db -$4E, $01, -$4E
	db  $38, $01, -$40
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Deer2_11
	db  $7B, $01,  $79, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $70, $01,  $38, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $4E, $01,  $0C, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db -$38, $01, -$44
	db  $38, $01, -$43
	db -$49, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$59, $01, -$0B, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $05, $01, -$43, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $7B, $01, -$22, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $70, $01,  $16
	db  $4F, $01, -$16
	db  $4E, $01,  $05, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $5A, $01, -$38, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$5A, $01,  $0B
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Deer2_12
	db  $79, $01,  $3D, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $38, $01, -$5A, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$2C, $01,  $65, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)


KrippeSceneData
 DW Krippe_0 ; list of all single vectorlists in this
 DW Krippe_1
 DW Krippe_2
 DW Krippe_3
 DW Krippe_4
 DW Krippe_5
 DW Krippe_6
 DW Krippe_7
 DW Krippe_8
 DW Krippe_9
 DW Krippe_10
 DW Krippe_11
 DW Krippe_12
 DW Krippe_13
 DW Krippe_14
 DW 0

Krippe_0
	db  $5A, $01,  $0E, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $5A, $01,  $0E, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $5D, $01,  $78, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $3E, $01, -$78, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $55, $01, -$08, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$4B, $01, -$7E, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $24, $01, -$4E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$4E, $01,  $06, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$4A, $01, -$78, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$5D, $01,  $7C
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe_1
	db  $5A, $01, -$0A, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $5A, $01, -$0A, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$52, $01, -$6A, hi(SMVB_startDraw_hex), lo(SMVB_startDraw_hex)
	db -$54, $01,  $18, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$51, $01, -$63, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$6C, $01,  $3C, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$5A, $01, -$7E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$60, $01, -$27, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$0C, $01,  $47, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe_2
	db -$2A, $01, -$76, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$2A, $01, -$76, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $18, $01,  $4E, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$78, $01,  $24, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $12, $01,  $42, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$6A, $01,  $02, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$0C, $01, -$60, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db -$54, $01, -$3C
	db -$6C, $01,  $24
	db -$24, $01,  $30
	db  $00, $01,  $62, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $00, $01,  $62, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $00, $01,  $62, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe_3
	db -$76, $01,  $64, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$76, $01,  $64, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $78, $01,  $54, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $6C, $01, -$48, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $0C, $01, -$54
	db  $6E, $01, -$02, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $00, $01,  $76, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe_4
	db -$2B, $01,  $7A, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$2B, $01,  $7A, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $30, $01,  $0C, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $7E, $01, -$4E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $0C, $01,  $48, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $64, $01, -$5C, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $30, $01,  $24, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $68, $01, -$7C, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $78, $01, -$0C, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $52, $01, -$65, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe_5
	db -$7F, $01, -$6D, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $6C, $01,  $00, hi(SMVB_startDraw_hex), lo(SMVB_startDraw_hex)
	db  $60, $01,  $78, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $0C, $01,  $6C
	db  $6C, $01,  $1C, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$0C, $01,  $60, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $58, $01,  $30, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $0C, $01,  $6C, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $78, $01,  $72, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$18, $01,  $3C, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$72, $01,  $60, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01,  $42, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$76, $01,  $3A, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$18, $01,  $5A, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$76, $01, -$01, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe_6
	db -$60, $01,  $4C, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$60, $01,  $4C, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $69, $01, -$33, hi(SMVB_startDraw_quadro), lo(SMVB_startDraw_quadro)
	db -$0C, $01,  $48, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $70, $01, -$20, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $24, $01, -$6C, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $36, $01, -$72, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$6C, $01, -$54, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$48, $01,  $2A, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$60, $01,  $54, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db -$48, $01, -$0C
	db -$56, $01, -$5B
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe_7
	db -$55, $01,  $23, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $70, $01, -$09, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $0C, $01, -$60, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db -$78, $01, -$30
	db  $48, $01,  $48
	db -$0C, $01,  $30
	db -$4C, $01,  $01, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$72, $01,  $01, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $00, $01, -$50, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe_8
	db -$62, $01,  $08, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$62, $01,  $08, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $48, $01, -$24, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $0C, $01,  $30, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $30, $01,  $0C
	db  $18, $01,  $30
	db  $48, $01, -$0C
	db  $54, $01, -$6C
	db  $54, $01,  $00
	db  $3C, $01, -$3C
	db -$0C, $01, -$6C, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db -$3C, $01, -$30
	db -$3C, $01,  $00
	db -$48, $01, -$60
	db -$60, $01, -$18
	db -$24, $01,  $24, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$3C, $01,  $0C, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$18, $01, -$70
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe_9
	db -$62, $01, -$1B, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$62, $01, -$1B, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $48, $01,  $0C, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $6C, $01, -$7E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$1E, $01,  $5A, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $54, $01,  $06, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $3C, $01,  $6C, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $18, $01, -$6C
	db  $00, $01, -$6C
	db  $48, $01,  $0C
	db  $30, $01, -$18
	db -$30, $01,  $3C
	db  $18, $01,  $48
	db  $30, $01,  $18, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $30, $01,  $30
	db  $6C, $01, -$24
	db  $18, $01, -$30
	db -$38, $01, -$6C, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$60, $01, -$24, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$74, $01, -$2C, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$3C, $01,  $24, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$0C, $01,  $48
	db -$10, $01, -$40, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe_10
	db -$5F, $01, -$04, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$5F, $01, -$04, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $0C, $01,  $48, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$30, $01,  $18, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $00, $01, -$66, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $30, $01,  $18, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$18, $01,  $30
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe_11
	db -$61, $01, -$01, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$3C, $01,  $0C, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $21, $01, -$3D, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db -$21, $01, -$3A
	db  $48, $01,  $18
	db  $0C, $01,  $30
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe_12
	db  $6E, $01, -$06, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $6E, $01, -$06, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$38, $01,  $5D, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $38, $01,  $56, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$63, $01,  $00
	db -$38, $01,  $54
	db -$24, $01, -$54
	db -$78, $01,  $00
	db  $30, $01, -$6C
	db -$30, $01, -$48
	db  $60, $01,  $0C, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $3C, $01, -$60
	db  $30, $01,  $60
	db  $6C, $01, -$0C
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe_13
	db -$62, $01,  $2C, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$54, $01,  $0C, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $6C, $01,  $6C, hi(SMVB_continue_yEqx_single), lo(SMVB_continue_yEqx_single); y is  $6C
	db -$66, $01,  $00, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $00, $01, -$48, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $6E, $01, -$03, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$48, $01,  $2A, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe_14
	db -$61, $01, -$01, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $18, $01, -$24, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)




Krippe2SceneData
 DW Krippe2_0 ; list of all single vectorlists in this
 DW Krippe2_1
 DW Krippe2_2
 DW Krippe2_3
 DW Krippe2_4
 DW Krippe2_5
 DW Krippe2_6
 DW Krippe2_7
 DW Krippe2_8
 DW Krippe2_9
 DW Krippe2_10
 DW Krippe2_11
 DW Krippe2_12
 DW Krippe2_13
 DW Krippe2_14
 DW Krippe2_15
 DW 0

Krippe2_0
	db  $6B, $01,  $2F, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $6B, $01,  $2F, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $1B, $01, -$7B, hi(SMVB_startDraw_quadro), lo(SMVB_startDraw_quadro)
	db -$04, $01, -$58, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$18, $01, -$60, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$34, $01, -$60, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$36, $01, -$42, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$75, $01, -$57, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$50, $01, -$25, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe2_1
	db  $20, $01, -$76, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $20, $01, -$76, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$1E, $01,  $54, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $00, $01,  $6C, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$42, $01,  $24, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$6B, $01,  $19, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$6B, $01,  $19, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$5A, $01, -$78, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$60, $01, -$28, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe2_2
	db -$72, $01, -$58, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$72, $01, -$58, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$01, $01,  $57, hi(SMVB_startDraw_octo), lo(SMVB_startDraw_octo)
	db -$01, $01,  $57, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$01, $01,  $57, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $60, $01, -$18, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $48, $01, -$48
	db  $30, $01, -$4E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $7B, $01,  $18, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $7B, $01,  $18, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe2_3
	db  $1C, $01,  $5A, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $1C, $01,  $5A, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$0C, $01,  $7E, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $48, $01,  $48, hi(SMVB_continue_yEqx_single), lo(SMVB_continue_yEqx_single); y is  $48
	db  $68, $01, -$34, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $68, $01, -$54, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $45, $01, -$6C, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe2_4
	db  $66, $01, -$02, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $66, $01, -$02, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$6C, $01,  $49, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$3C, $01,  $42, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$18, $01,  $48, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$60, $01,  $3C, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$54, $01,  $78, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$18, $01,  $45, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe2_5
	db  $6A, $01,  $7E, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$67, $01,  $10, hi(SMVB_startDraw_octo), lo(SMVB_startDraw_octo)
	db -$70, $01, -$19, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $18, $01, -$6C, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $41, $01, -$4A, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe2_6
	db -$74, $01,  $34, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $58, $01,  $5A, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $57, $01, -$09, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $5D, $01,  $41, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $5E, $01, -$35
	db  $15, $01, -$7D
	db -$18, $01, -$60
	db  $18, $01, -$48, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$35, $01, -$56, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db -$72, $01, -$15
	db -$50, $01,  $32
	db -$4F, $01, -$07, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$54, $01,  $60, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$5C, $01, -$5D, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe2_7
	db -$7F, $01,  $1E, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $06, $01, -$5A, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $60, $01, -$24, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $72, $01, -$0C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $60, $01, -$30, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db  $3C, $01, -$60
	db  $30, $01, -$60
	db  $60, $01,  $30
	db  $6C, $01,  $60
	db  $54, $01,  $06, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $3C, $01, -$6C, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$50, $01, -$23, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe2_8
	db -$18, $01, -$60, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $54, $01, -$2A, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $78, $01,  $3C, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db  $6C, $01,  $18
	db  $60, $01, -$18
	db  $18, $01, -$6C
	db -$30, $01, -$6C
	db -$54, $01, -$30, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$5C, $01, -$14, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$7B, $01,  $03, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$78, $01,  $48, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$70, $01, -$0C, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$60, $01, -$14, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe2_9
	db -$5B, $01, -$37, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$5B, $01, -$37, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $6D, $01, -$1E, hi(SMVB_startDraw_octo), lo(SMVB_startDraw_octo)
	db  $69, $01,  $0F, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $38, $01,  $6C, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $4E, $01,  $3C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $2A, $01,  $60, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $54, $01,  $54, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $73, $01,  $42
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe2_10
	db  $59, $01,  $00, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $59, $01,  $00, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$42, $01, -$15, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$22, $01, -$6C, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db -$30, $01,  $5B
	db -$78, $01,  $30
	db  $6F, $01,  $35
	db  $2C, $01,  $66
	db  $31, $01, -$75
	db  $41, $01, -$0D, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe2_11
	db -$7E, $01,  $37, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$08, $01, -$41, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $3C, $01,  $54, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe2_12
	db -$5A, $01,  $26, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$01, $01,  $61, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db -$62, $01,  $0B, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$49, $01, -$50, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $4E, $01, -$5A, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $5F, $01,  $0D, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe2_13
	db  $0C, $01, -$4E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$18, $01, -$60, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe2_14
	db  $25, $01, -$70, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$5C, $01, -$0C, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db  $6C, $01, -$20, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $54, $01,  $60, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $6C, $01,  $3C
	db -$78, $01, -$0C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe2_15
	db  $3A, $01,  $70, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$60, $01,  $78, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$7C, $01, -$20, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $60, $01, -$0E, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$6C, $01,  $3C, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)



ThingsSceneData
 DW Things_0 ; list of all single vectorlists in this
 DW Things_1
 DW Things_2
 DW Things_3
 DW Things_4
 DW Things_5
 DW Things_6
 DW Things_7
 DW Things_8
 DW Things_9
 DW Things_10
 DW Things_11
 DW Things_12
 DW Things_13
 DW Things_14
 DW Things_15
 DW Things_16
 DW Things_17
 DW Things_18
 DW Things_19
 DW Things_20
 DW Things_21
 DW Things_22
 DW Things_23
 DW Things_24
 DW Things_25
 DW Things_26
 DW Things_27
 DW Things_28
 DW Things_29
 DW Things_30
 DW Things_31
 DW Things_32
 DW Things_33
 DW Things_34
 DW Things_35
 DW Things_36
 DW Things_37
 DW Things_38
 DW Things_39
 DW Things_40
 DW Things_41
 DW Things_42
 DW Things_43
 DW Things_44
 DW Things_45
 DW Things_46
 DW Things_47
 DW 0

Things_0
	db  $7B, $01, -$1A, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $7B, $01, -$1A, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $33, $01,  $25, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $1E, $01,  $3D, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $00, $01, -$64
	db -$1E, $01, -$7B
	db -$4F, $01, -$72, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$6C, $01, -$4B, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_1
	db  $60, $01, -$44, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $60, $01, -$44, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $6D, $01, -$19, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$60, $01, -$1C, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $32, $01, -$59, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$62, $01,  $1C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$16, $01, -$79, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$2A, $01,  $61, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$68, $01, -$37, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $3A, $01,  $73, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$63, $01,  $12, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $57, $01,  $36, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$30, $01,  $52, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $69, $01, -$31, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $09, $01,  $61, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $23, $01, -$6E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_2
	db  $76, $01, -$5A, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $1A, $01,  $50, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$07, $01,  $58, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$1D, $01,  $68, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $7C, $01, -$51, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $25, $01, -$5B, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_3
	db  $59, $01, -$13, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $59, $01, -$13, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $28, $01,  $2E, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $06, $01,  $62, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$10, $01,  $48, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$4F, $01,  $7B, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_4
	db  $75, $01,  $30, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $79, $01, -$55, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$18, $01,  $56, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$29, $01,  $6A, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $67, $01, -$62, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $28, $01, -$5E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $12, $01, -$6B, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $0B, $01,  $40, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$07, $01,  $5B, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_5
	db  $72, $01,  $22, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $72, $01,  $22, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $28, $01, -$54, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $14, $01, -$6C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$04, $01, -$73, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_6
	db  $74, $01, -$04, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $12, $01,  $40, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $74, $01,  $43, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$6B, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$57, $01, -$3C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $01,  $04, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $6B, $01, -$53, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_7
	db  $74, $01, -$04, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$1E, $01,  $62, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $20, $01,  $65, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_8
	db  $6A, $01,  $15, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$74, $01,  $51, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$21, $01,  $79, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$6F, $01, -$54
	db -$45, $01,  $06, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $31, $01, -$78, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$13, $01, -$42, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_9
	db  $70, $01,  $4A, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $5C, $01, -$41, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_10
	db  $7D, $01,  $5E, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$4E, $01, -$24, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$4F, $01, -$23, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$0E, $01, -$4C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$7C, $01,  $6C, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$57, $01, -$05, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_11
	db  $56, $01,  $69, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $45, $01,  $7E, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$25, $01,  $42, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $5A, $01, -$07, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $75, $01,  $66, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $15, $01, -$4C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $49, $01, -$20, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_12
	db  $79, $01,  $5D, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$6A, $01,  $01, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $51, $01, -$3C, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $41, $01,  $1C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_13
	db  $69, $01,  $65, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$52, $01, -$32, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $68, $01, -$02, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$7F, $01,  $36, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_14
	db  $68, $01,  $55, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$57, $01,  $3B, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $21, $01, -$59, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $14, $01,  $78, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_15
	db  $67, $01,  $67, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$1B, $01,  $74, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$1A, $01, -$52, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $4F, $01,  $31, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_16
	db  $65, $01,  $45, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$24, $01,  $57, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$26, $01, -$56, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $6E, $01, -$59
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_17
	db  $63, $01,  $76, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$5F, $01, -$52, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $2A, $01, -$56, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $1B, $01,  $54, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_18
	db  $79, $01,  $7B, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$58, $01, -$33, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $44, $01,  $05, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $26, $01,  $5C, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_19
	db  $5A, $01,  $60, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$2A, $01,  $53, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$44, $01,  $08, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $59, $01, -$32, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_20
	db  $77, $01,  $7D, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$79, $01, -$06, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$38, $01, -$63, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $59, $01,  $34, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_21
	db  $77, $01,  $7F, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$5A, $01,  $34, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $40, $01, -$68, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $74, $01,  $00
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_22
	db  $6B, $01, -$6C, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$57, $01, -$2B, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$28, $01,  $2B, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$14, $01,  $33
	db -$27, $01,  $1E
	db  $1E, $01,  $56
	db  $3B, $01,  $00
	db  $28, $01, -$1C
	db  $00, $01, -$48
	db  $2D, $01, -$07, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $0E, $01, -$29
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_23
	db  $34, $01, -$75, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$20, $01, -$28, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$75, $01, -$4C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$27, $01, -$21, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$28, $01,  $58, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $35, $01,  $0D, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $4A, $01, -$21, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $6C, $01, -$12, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $3E, $01,  $17
	db  $1F, $01,  $11
	db  $4A, $01,  $3C
	db  $2B, $01, -$4A, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$42, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$0F, $01, -$31, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_24
	db  $5B, $01, -$47, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$21, $01, -$50, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$7E, $01, -$78, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$5F, $01,  $00, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$6B, $01,  $35, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $2E, $01,  $50, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $49, $01,  $7E, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $26, $01,  $5B, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $1F, $01,  $12, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $36, $01, -$1F
	db  $4D, $01, -$51
	db  $43, $01, -$3C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $16, $01, -$17, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $08, $01, -$1A
	db  $00, $01, -$69
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_25
	db -$05, $01, -$59, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$05, $01, -$59, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$24, $01, -$1F, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$28, $01, -$20, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db -$20, $01, -$0E
	db -$1C, $01,  $00
	db -$27, $01,  $1F
	db -$32, $01,  $6A, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $00, $01,  $35, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $56, $01,  $43
	db  $4F, $01, -$14
	db  $18, $01, -$22
	db  $36, $01, -$73, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $15, $01, -$1A, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $0C, $01, -$18
	db  $29, $01, -$5A
	db  $00, $01, -$30
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_26
	db -$3E, $01,  $74, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$36, $01, -$62, hi(SMVB_startDraw_quadro), lo(SMVB_startDraw_quadro)
	db -$12, $01, -$1F, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$24, $01, -$40, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$29, $01, -$0D, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db -$24, $01,  $04
	db -$36, $01,  $11
	db -$27, $01,  $33
	db  $22, $01,  $50, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $3A, $01,  $5F, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $22, $01,  $41, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $3D, $01,  $6C, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $69, $01, -$28
	db  $29, $01, -$51
	db -$29, $01, -$47
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_27
	db -$2F, $01, -$78, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$44, $01, -$12, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$49, $01,  $35, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db -$29, $01,  $37
	db  $00, $01,  $6B
	db  $45, $01,  $4B
	db  $43, $01, -$76, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$16, $01, -$23, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_28
	db -$63, $01,  $32, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$4A, $01, -$71, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$43, $01, -$6C, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db -$4B, $01,  $75
	db  $0D, $01,  $4B
	db  $63, $01,  $53
	db  $7A, $01, -$1D
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_29
	db -$71, $01,  $73, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$5A, $01,  $01, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db  $00, $01,  $58, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01,  $36, hi(SMVB_continue_yStays_single), lo(SMVB_continue_yStays_single); y is  $00
	db  $00, $01,  $56, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $58, $01,  $02, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_30
	db -$43, $01,  $70, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$43, $01,  $70, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $00, $01, -$31, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $12, $01,  $0D, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $21, $01, -$04
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_31
	db -$44, $01,  $5E, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$44, $01,  $5E, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$56, $01,  $1B, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$2D, $01,  $06, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db -$0D, $01,  $17
	db  $16, $01,  $24
	db  $24, $01,  $00
	db  $62, $01, -$34
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_32
	db -$43, $01,  $6B, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$43, $01,  $6B, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $02, $01, -$41, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$0F, $01, -$21, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_33
	db -$4B, $01,  $65, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$4B, $01,  $65, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$04, $01,  $6C, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_34
	db -$4C, $01,  $6F, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$4C, $01,  $6F, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $20, $01,  $1A, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $2D, $01,  $04, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $17, $01, -$11
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_35
	db -$43, $01,  $61, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$43, $01,  $61, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $27, $01,  $62, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $05, $01,  $2A, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db  $36, $01, -$2A
	db -$32, $01, -$62
	db  $00, $01, -$21
	db -$12, $01, -$1C
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_36
	db -$3F, $01,  $60, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$3F, $01,  $60, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$2E, $01,  $04, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_37
	db -$44, $01,  $5E, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$44, $01,  $5E, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$49, $01, -$13, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $02, $01, -$1B, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $19, $01, -$1A
	db  $6E, $01,  $35
	db  $34, $01,  $0C
	db  $29, $01, -$27
	db  $16, $01, -$4D
	db -$16, $01, -$19
	db -$20, $01,  $00, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $00, $01,  $35
	db -$21, $01,  $4F
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_38
	db -$43, $01,  $5A, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$43, $01,  $5A, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $00, $01, -$67, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$02, $01, -$2A, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_39
	db -$61, $01,  $76, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$1C, $01, -$0B, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$0D, $01, -$26, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$53, $01,  $01
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_40
	db -$71, $01,  $70, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$04, $01,  $44, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_41
	db -$62, $01,  $5C, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$62, $01,  $5C, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $6C, $01,  $00, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_42
	db -$4C, $01,  $5C, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$4C, $01,  $5C, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $00, $01,  $2D, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_43
	db -$50, $01,  $60, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$50, $01,  $60, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$6E, $01,  $00, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_44
	db -$68, $01,  $5F, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$23, $01, -$6E, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$4F, $01,  $35, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$12, $01,  $20
	db  $00, $01,  $30
	db -$25, $01,  $1B
	db -$20, $01, -$1E
	db -$15, $01, -$06
	db  $17, $01,  $3B
	db  $11, $01,  $3F, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $0C, $01, -$42
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_45
	db -$63, $01,  $4F, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $2A, $01, -$20, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $15, $01,  $1E, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $1B, $01,  $05
	db  $18, $01, -$09
	db  $17, $01, -$15
	db -$0E, $01, -$20
	db -$09, $01, -$1C
	db -$06, $01, -$26
	db  $0A, $01,  $21, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $07, $01,  $29
	db  $11, $01,  $13
	db  $1F, $01, -$0F
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_46
	db -$72, $01,  $3C, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$48, $01, -$29, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$1B, $01,  $06, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$1B, $01,  $26
	db -$17, $01, -$14
	db -$19, $01, -$1E
	db -$05, $01, -$32
	db -$0F, $01,  $1A
	db -$16, $01,  $57
	db  $18, $01, -$02, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $12, $01, -$14
	db  $2D, $01,  $15
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Things_47
	db -$65, $01,  $2E, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $07, $01,  $39, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $0E, $01,  $16, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $25, $01,  $11
	db  $15, $01, -$2C
	db  $06, $01, -$24
	db  $00, $01,  $23
	db -$0A, $01,  $1B
	db -$03, $01,  $1C
	db  $1B, $01,  $0C, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $22, $01, -$6C
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)

WatchingSledSceneData
 DW WatchingSled_0 ; list of all single vectorlists in this
 DW WatchingSled_1
 DW WatchingSled_2
 DW WatchingSled_3
 DW WatchingSled_4
 DW WatchingSled_5
 DW WatchingSled_6
 DW WatchingSled_7
 DW WatchingSled_8
 DW WatchingSled_9
 DW WatchingSled_10
 DW WatchingSled_11
 DW WatchingSled_12
 DW WatchingSled_13
 DW WatchingSled_14
 DW WatchingSled_15
 DW WatchingSled_16
 DW WatchingSled_17
 DW WatchingSled_18
 DW WatchingSled_19
 DW WatchingSled_20
 DW WatchingSled_21
 DW WatchingSled_22
 DW WatchingSled_23
 DW WatchingSled_24
 DW WatchingSled_25
 DW WatchingSled_26
 DW WatchingSled_27
 DW WatchingSled_28
 DW WatchingSled_29
 DW WatchingSled_30
 DW WatchingSled_31
 DW WatchingSled_32
 DW WatchingSled_33
 DW WatchingSled_34
 DW WatchingSled_35
 DW WatchingSled_36
 DW WatchingSled_37
 DW WatchingSled_38
 DW WatchingSled_39
 DW WatchingSled_40
 DW WatchingSled_41
 DW WatchingSled_42
 DW WatchingSled_43
 DW 0

WatchingSled_0
	db  $63, $01,  $72, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $31, $01,  $0B, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $0E, $01, -$1E, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$12, $01, -$1C
	db -$2B, $01, -$07
	db -$2B, $01,  $16
	db -$23, $01,  $2E
	db -$18, $01,  $33
	db  $26, $01,  $48
	db  $3F, $01, -$60, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$01, $01, -$29
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_1
	db  $3E, $01,  $57, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $3E, $01,  $57, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$28, $01,  $4C, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$26, $01, -$0E, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$1C, $01, -$13
	db -$15, $01, -$1E
	db  $09, $01, -$39
	db  $1A, $01, -$2C
	db  $31, $01, -$0A
	db  $20, $01,  $06
	db  $22, $01, -$08, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$17, $01,  $64
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_2
	db  $26, $01,  $57, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $26, $01,  $57, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$1A, $01,  $50, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$43, $01,  $10, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $20, $01, -$68, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $2F, $01,  $3B, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$1C, $01,  $5B, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_3
	db  $20, $01,  $68, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $20, $01,  $68, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $0D, $01,  $67, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $0B, $01,  $23, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $29, $01,  $27
	db  $36, $01,  $15
	db  $48, $01,  $0D
	db  $1B, $01,  $0E
	db  $3F, $01,  $42
	db  $17, $01,  $37
	db  $16, $01, -$24, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $1A, $01, -$06
	db  $11, $01, -$24
	db -$0C, $01, -$1B
	db  $22, $01, -$05
	db -$04, $01, -$28
	db -$12, $01, -$1A
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_4
	db  $20, $01,  $67, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $20, $01,  $67, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$1B, $01,  $0B, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$25, $01,  $13, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db -$0C, $01,  $41
	db  $0D, $01,  $3B
	db -$18, $01,  $04
	db -$12, $01, -$2C
	db -$03, $01, -$2B
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_5
	db  $16, $01,  $6D, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $16, $01,  $6D, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $1F, $01, -$60, hi(SMVB_startDraw_hex), lo(SMVB_startDraw_hex)
	db  $17, $01, -$2D, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $23, $01, -$30
	db  $22, $01, -$1B
	db  $15, $01, -$07
	db  $2E, $01, -$06
	db  $21, $01,  $0D
	db  $16, $01,  $24
	db  $03, $01,  $23, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$10, $01,  $29
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_6
	db  $6E, $01,  $78, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $30, $01,  $0B, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $1E, $01,  $16, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $20, $01,  $38
	db  $0B, $01,  $4A
	db  $1E, $01,  $0B
	db  $19, $01, -$13
	db  $2D, $01,  $45
	db -$14, $01,  $22
	db -$21, $01, -$06, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$1E, $01, -$0E
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_7
	db  $64, $01,  $78, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$26, $01,  $50, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $1B, $01,  $1B, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$12, $01,  $38
	db  $16, $01,  $1F
	db  $07, $01,  $27
	db  $17, $01,  $20
	db -$07, $01,  $27
	db  $00, $01,  $25
	db -$15, $01,  $21, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_8
	db  $59, $01,  $07, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $59, $01,  $07, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db SHITREG_POKE_VALUE, $01, -$11, hi(SMVB_startDraw_newY_eq_oldX_single), lo(SMVB_startDraw_newY_eq_oldX_single) ; y was  $07, now SHIFT
	db  $1F, $01,  $0D, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$09, $01, -$12
	db  $15, $01,  $00
	db  $21, $01,  $0B
	db  $15, $01,  $0F
	db -$07, $01, -$19
	db  $20, $01,  $0A
	db -$0A, $01, -$11, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db  $12, $01,  $03
	db  $14, $01, -$06
	db -$16, $01, -$0B
	db -$55, $01,  $03
	db -$0B, $01, -$18
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_9
	db  $5C, $01,  $01, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $5C, $01,  $01, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $23, $01,  $00, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $15, $01,  $0B, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $04, $01, -$11
	db  $17, $01,  $06
	db -$05, $01, -$16
	db  $16, $01, -$06
	db -$12, $01, -$07
	db -$47, $01,  $12
	db -$16, $01,  $00, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db -$1E, $01, -$0B
	db  $01, $01, -$16
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_10
	db  $58, $01, -$02, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $58, $01, -$02, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $31, $01, -$02, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $10, $01, -$0E, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$1A, $01,  $00
	db  $15, $01, -$12
	db -$12, $01, -$04
	db -$19, $01,  $10
	db -$18, $01,  $00
	db  $0D, $01, -$16
	db  $10, $01, -$0B, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $14, $01, -$1D
	db -$09, $01, -$13
	db -$1D, $01, -$18
	db  $00, $01,  $1C
	db  $02, $01,  $17
	db -$11, $01,  $15
	db -$1B, $01,  $22, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_11
	db  $56, $01, -$04, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $56, $01, -$04, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$19, $01, -$24, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$26, $01, -$21, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db -$19, $01,  $15
	db  $0E, $01,  $1B
	db -$06, $01,  $1D
	db -$1E, $01,  $03
	db -$41, $01,  $13, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$10, $01, -$2A, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$4C, $01, -$56
	db -$27, $01, -$20
	db  $00, $01,  $1F
	db  $41, $01,  $42
	db  $16, $01,  $26
	db  $02, $01,  $1A
	db -$02, $01,  $14, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_12
	db  $7E, $01,  $02, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$4A, $01, -$0F, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$15, $01,  $0B, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$0C, $01,  $20
	db -$1B, $01,  $40
	db  $07, $01,  $17
	db  $14, $01, -$15
	db  $0C, $01, -$33
	db  $1A, $01, -$23
	db  $48, $01,  $33, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_13
	db  $7D, $01,  $0B, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $05, $01,  $69, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $0F, $01,  $2D, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$15, $01,  $0D
	db -$37, $01,  $3E
	db -$35, $01, -$13
	db -$27, $01, -$1C
	db -$03, $01,  $16
	db  $0A, $01,  $11
	db  $2B, $01,  $0A, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $36, $01,  $1A
	db  $14, $01, -$0C
	db  $18, $01, -$05
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_14
	db  $7E, $01,  $31, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$1E, $01,  $30, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $00, $01,  $24, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$3D, $01,  $33
	db -$0E, $01,  $15
	db -$08, $01,  $16
	db  $12, $01, -$05
	db  $16, $01, -$0D
	db  $0E, $01, -$19
	db  $21, $01, -$1B, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $23, $01, -$10
	db  $07, $01, -$2F
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_15
	db  $60, $01,  $2C, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $19, $01, -$06, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $32, $01, -$08, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db  $1B, $01,  $04
	db  $06, $01,  $15
	db  $30, $01, -$56
	db -$0B, $01, -$7F
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_16
	db  $72, $01,  $14, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $19, $01, -$6C, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $26, $01, -$17, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $21, $01, -$1B
	db  $18, $01,  $12
	db  $08, $01, -$20
	db  $14, $01,  $24
	db -$04, $01,  $17
	db  $0A, $01,  $25
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_17
	db  $5B, $01,  $02, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $5B, $01,  $02, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $0E, $01,  $0C, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_18
	db  $7E, $01, -$5E, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $19, $01, -$6D, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $27, $01, -$17, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $21, $01, -$1C
	db  $1A, $01,  $12
	db  $07, $01, -$1F
	db  $14, $01,  $23
	db -$03, $01,  $18
	db  $08, $01,  $25
	db  $07, $01, -$12, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $1F, $01,  $0D
	db -$09, $01, -$12
	db  $15, $01,  $00
	db  $21, $01,  $0B
	db  $15, $01,  $10
	db -$07, $01, -$19
	db  $21, $01,  $09, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$0B, $01, -$11
	db  $12, $01,  $03
	db  $14, $01, -$06
	db -$15, $01, -$0B
	db -$56, $01,  $04
	db -$0A, $01, -$1A
	db  $26, $01, -$01, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $16, $01,  $0C
	db  $03, $01, -$12
	db  $17, $01,  $06
	db -$05, $01, -$15
	db  $16, $01, -$05
	db -$12, $01, -$08
	db -$47, $01,  $12, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db -$16, $01,  $00
	db -$1E, $01, -$09
	db  $02, $01, -$16
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_19
	db  $60, $01, -$4F, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $60, $01, -$4F, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $32, $01, -$02, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $0F, $01, -$0E, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$1A, $01,  $00
	db  $15, $01, -$11
	db -$12, $01, -$04
	db -$19, $01,  $0F
	db -$21, $01,  $02
	db  $16, $01, -$17
	db  $10, $01, -$0B, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $14, $01, -$1C
	db -$09, $01, -$14
	db -$10, $01, -$0A
	db -$0D, $01, -$0E
	db  $00, $01,  $1C
	db  $02, $01,  $17
	db -$10, $01,  $15, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$1C, $01,  $21
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_20
	db  $5E, $01, -$51, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $5E, $01, -$51, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$19, $01, -$24, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$27, $01, -$22, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db -$1A, $01,  $16
	db  $0E, $01,  $1A
	db -$06, $01,  $1C
	db -$1E, $01,  $03
	db -$41, $01,  $13, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$10, $01, -$18, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$0B, $01, -$20
	db -$42, $01, -$47
	db -$27, $01, -$20
	db  $00, $01,  $1F
	db  $41, $01,  $42
	db  $16, $01,  $26
	db  $02, $01,  $18, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$02, $01,  $13
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_21
	db  $6B, $01, -$71, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$4A, $01, -$0E, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$14, $01,  $0A, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$0C, $01,  $21
	db -$11, $01,  $20
	db -$0B, $01,  $21
	db  $07, $01,  $16
	db  $15, $01, -$15
	db  $0C, $01, -$33
	db  $09, $01, -$13, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db  $10, $01, -$11
	db  $48, $01,  $34
	db -$05, $01,  $65
	db  $08, $01,  $15
	db  $0B, $01,  $20
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_22
	db  $6C, $01, -$57, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$16, $01,  $0D, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$37, $01,  $3E, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$35, $01, -$13
	db -$28, $01, -$1C
	db -$03, $01,  $16
	db  $0B, $01,  $11
	db  $2B, $01,  $0B
	db  $36, $01,  $1A
	db  $14, $01, -$0C, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $18, $01, -$06
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_23
	db  $6B, $01, -$4E, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$1E, $01,  $31, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $00, $01,  $26, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$3D, $01,  $32
	db -$0E, $01,  $16
	db -$07, $01,  $15
	db  $12, $01, -$05
	db  $15, $01, -$0D
	db  $0F, $01, -$19
	db  $20, $01, -$1A, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $23, $01, -$11
	db  $10, $01, -$2E
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_24
	db  $6C, $01, -$46, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $4B, $01, -$0E, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $1B, $01,  $05, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $06, $01,  $14
	db  $0E, $01, -$16
	db  $21, $01, -$40
	db -$05, $01, -$40, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_25
	db  $63, $01, -$4A, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $63, $01, -$4A, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $0E, $01,  $0C, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$11, $01, -$03, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_26
	db -$66, $01, -$49, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $6E, $01,  $00, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db  $0D, $01, -$08, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$02, $01, -$09
	db -$7D, $01,  $01, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$17, $01, -$0F, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$2B, $01,  $0F
	db -$7B, $01,  $02, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $03, $01,  $0A, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_27
	db -$6B, $01, -$30, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$6B, $01, -$30, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $73, $01, -$01, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_28
	db -$73, $01, -$4B, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$23, $01,  $1B, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$04, $01,  $19, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$4D, $01, -$05, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$0E, $01,  $21, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db -$54, $01,  $0D
	db -$4C, $01, -$0A
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_29
	db -$6B, $01, -$2C, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$6B, $01, -$2C, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $00, $01,  $32, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $2B, $01, -$06, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $78, $01,  $04
	db  $00, $01,  $2F
	db -$18, $01,  $00
	db -$36, $01,  $0D
	db -$47, $01,  $05
	db -$0B, $01,  $56
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_30
	db -$6B, $01, -$1B, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$6B, $01, -$1B, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $2C, $01, -$31, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $27, $01, -$13, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $64, $01,  $06
	db  $08, $01,  $16
	db  $51, $01, -$11
	db  $0A, $01,  $0E
	db  $31, $01,  $00
	db  $1F, $01, -$0E
	db  $15, $01,  $08, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_31
	db -$70, $01, -$2E, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $02, $01,  $0F, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $6B, $01,  $05, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $66, $01, -$4C
	db  $07, $01, -$2D
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_32
	db -$71, $01, -$4D, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $24, $01,  $10, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $17, $01, -$08, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $0C, $01, -$10
	db  $19, $01, -$12
	db  $00, $01, -$26
	db -$13, $01, -$16
	db -$58, $01,  $03
	db -$34, $01, -$1F
	db -$6E, $01, -$14, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_33
	db -$6C, $01,  $2D, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $26, $01, -$2C, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $3D, $01, -$13, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $08, $01, -$33
	db  $09, $01, -$03
	db  $3D, $01,  $49
	db  $04, $01,  $22
	db -$0C, $01,  $16
	db -$13, $01,  $09
	db -$14, $01, -$0D, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db -$0D, $01,  $09
	db -$0C, $01,  $1D
	db  $00, $01,  $33
	db  $04, $01,  $10
	db  $08, $01,  $75
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_34
	db -$7D, $01,  $62, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$08, $01,  $1C, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$14, $01,  $0F, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$5D, $01, -$06
	db -$13, $01,  $12
	db -$29, $01,  $02
	db -$22, $01, -$0B
	db  $00, $01, -$18
	db  $26, $01,  $0F
	db  $17, $01, -$08, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $13, $01, -$11
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_35
	db -$6D, $01,  $4B, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$38, $01, -$21, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$10, $01,  $00, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$16, $01, -$0A
	db  $00, $01, -$1B
	db  $05, $01,  $00
	db  $3B, $01,  $1E
	db  $10, $01,  $00
	db  $16, $01, -$12
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_36
	db -$6D, $01,  $45, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $04, $01, -$0D, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $01, $01, -$7A, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$19, $01, -$06
	db -$26, $01,  $0B
	db -$0D, $01, -$10
	db -$0F, $01,  $00
	db -$03, $01, -$1C
	db  $0D, $01,  $00
	db  $0F, $01,  $10, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db  $2B, $01, -$0C
	db -$47, $01, -$16
	db  $00, $01, -$1D
	db  $38, $01,  $1D
	db  $2F, $01,  $03
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_37
	db -$75, $01,  $3C, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$02, $01, -$0E, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$08, $01,  $0E, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_38
	db -$6E, $01,  $1A, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $0F, $01,  $01, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $2F, $01, -$17, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $0A, $01, -$19
	db -$04, $01, -$0D
	db -$23, $01, -$3B
	db -$09, $01,  $0C
	db -$02, $01,  $0D
	db -$08, $01, -$0B
	db -$09, $01, -$52, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $09, $01, -$62
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_39
	db -$6C, $01, -$08, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$0A, $01, -$26, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$11, $01, -$19, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$24, $01, -$0C
	db -$33, $01,  $04
	db -$15, $01, -$17
	db -$41, $01,  $00
	db -$0E, $01,  $03
	db  $00, $01,  $1C
	db  $0E, $01, -$08, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $05, $01, -$08
	db  $1E, $01,  $00
	db  $23, $01,  $23
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_40
	db -$79, $01, -$0E, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$25, $01,  $13, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$0B, $01,  $00, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$10, $01,  $11
	db -$29, $01,  $16
	db -$03, $01,  $1F
	db  $1A, $01, -$0E
	db  $04, $01, -$0C
	db  $1E, $01, -$13
	db  $17, $01,  $18, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $25, $01,  $0D
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_41
	db -$7A, $01, -$05, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$07, $01,  $19, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $00, $01,  $2E, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $03, $01,  $26
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_42
	db -$7B, $01,  $05, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$43, $01, -$13, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$1A, $01,  $02, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db  $00, $01,  $1D
	db  $08, $01, -$07
	db  $1C, $01, -$08
	db  $25, $01,  $16
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
WatchingSled_43
	db -$79, $01,  $08, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$6E, $01,  $02, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $00, $01,  $20, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $17, $01, -$10
	db  $3D, $01,  $05
	db  $1C, $01,  $25
	db  $18, $01,  $15
	db  $34, $01,  $1C
	db  $05, $01,  $12
	db  $06, $01,  $12, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)



HappyNewYearSceneData
 DW HappyNewYear_0 ; list of all single vectorlists in this
 DW HappyNewYear_1
 DW HappyNewYear_2
 DW HappyNewYear_3
 DW HappyNewYear_4
 DW 0

HappyNewYear_0
	db  $68, $01,  $04, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$61, $01,  $1A, hi(SMVB_startDraw_quadro), lo(SMVB_startDraw_quadro)
	db  $08, $01,  $60, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $5F, $01,  $1C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01,  $10, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$5F, $01,  $14, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$03, $01,  $6B, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $60, $01,  $19, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $00, $01, -$67, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$70, $01, -$18, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $70, $01, -$24, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$48, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$70, $01, -$24, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $70, $01, -$18, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$68, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $00, $01, -$7F, hi(SMVB_startMove_double), lo(SMVB_startMove_double)
	db -$7F, $01,  $02, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db  $00, $01,  $6C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $50, $01,  $08, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $04, $01, -$40, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $3F, $01,  $00, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db  $08, $01,  $78
	db  $50, $01, -$10
	db  $08, $01, -$70
	db  $28, $01,  $00
	db  $04, $01,  $40, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $58, $01,  $08, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $00, $01, -$74, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$6D, hi(SMVB_startMove_tripple), lo(SMVB_startMove_tripple)
	db -$7F, $01,  $00, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db  $00, $01,  $50, hi(SMVB_continue_newY_eq_oldX_single), lo(SMVB_continue_newY_eq_oldX_single) ; y is  $00
	db  $5F, $01,  $04, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$5F, $01,  $44, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01,  $38, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $7F, $01,  $02, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $00, $01, -$58, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$5C, $01, -$04, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $5C, $01, -$40, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$40, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
HappyNewYear_1
	db  $60, $01,  $4A, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$75, $01, -$02, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db -$08, $01,  $48, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $67, $01,  $00
	db  $18, $01,  $20
	db -$7F, $01,  $48
	db  $10, $01,  $3F
	db  $67, $01, -$2F
	db  $60, $01,  $37
	db  $50, $01, -$10, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $40, $01, -$37
	db  $00, $01, -$54, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$77, hi(SMVB_startMove_double), lo(SMVB_startMove_double)
	db -$78, $01, -$22, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db  $00, $01,  $50, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db  $3F, $01,  $28
	db  $00, $01,  $58
	db -$3F, $01,  $20
	db  $00, $01,  $48
	db  $78, $01, -$22, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $00, $01, -$68, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$15, $01,  $60, hi(SMVB_startMove_quadro), lo(SMVB_startMove_quadro)
	db -$40, $01,  $00, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$08, $01, -$50, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $38, $01,  $00
	db  $10, $01,  $50
	db -$0A, $01, -$6D, hi(SMVB_startMove_tripple), lo(SMVB_startMove_tripple)
	db -$60, $01,  $18, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $00, $01, -$38, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $08, $01,  $00
	db  $57, $01,  $20
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
HappyNewYear_2
	db  $60, $01, -$41, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$75, $01,  $00, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db  $00, $01,  $64, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $4F, $01,  $00, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $08, $01, -$70
	db  $2F, $01,  $00
	db  $00, $01,  $68
	db  $50, $01, -$08
	db  $07, $01, -$60
	db  $28, $01,  $08
	db  $07, $01,  $68, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $50, $01,  $00
	db  $00, $01, -$64, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$66, hi(SMVB_startMove_tripple), lo(SMVB_startMove_tripple)
	db -$74, $01,  $34, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$7F, $01,  $00, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $00, $01,  $48
	db  $7F, $01,  $00
	db  $74, $01,  $30, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$50, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db -$70, $01, -$38
	db  $70, $01, -$38
	db  $00, $01, -$51
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
HappyNewYear_3
	db  $62, $01, -$2D, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $62, $01, -$2D, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$5A, $01,  $00, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db -$10, $01,  $40, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db  $70, $01,  $00
	db  $00, $01,  $40
	db -$60, $01,  $08
	db  $00, $01,  $38
	db  $5A, $01,  $02, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $00, $01, -$40, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db -$60, $01,  $00
	db  $00, $01, -$48
	db  $60, $01,  $00
	db  $00, $01, -$40
	db  $00, $01,  $65, hi(SMVB_startMove_tripple), lo(SMVB_startMove_tripple)
	db  SHITREG_POKE_VALUE, $01,  $48, hi(SMVB_startDraw_yStays_single), lo(SMVB_startDraw_yStays_single); y was  $00, now SHIFT Poke
	db -$5D, $01,  $1A, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $00, $01, -$38, hi(SMVB_continue5_single), lo(SMVB_continue5_single)
	db  $30, $01, -$10
	db  $00, $01, -$50
	db -$30, $01, -$10
	db  $00, $01, -$48
	db  $5D, $01,  $1D, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$6F, $01,  $1F, hi(SMVB_startMove_single), lo(SMVB_startMove_single)
	db -$40, $01,  $18, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $00, $01, -$30, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db  $40, $01,  $18
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
HappyNewYear_4
	db  $62, $01,  $0B, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $62, $01,  $0B, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$5D, $01,  $00, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db  $00, $01,  $38, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db  $50, $01,  $00
	db  $08, $01,  $50
	db  $30, $01,  $30
	db  $58, $01,  $00
	db  $38, $01, -$30
	db  $00, $01, -$44, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01,  $5C, hi(SMVB_startMove_double), lo(SMVB_startMove_double)
	db  SHITREG_POKE_VALUE, $01,  $48, hi(SMVB_startDraw_yStays_single), lo(SMVB_startDraw_yStays_single); y was  $00, now SHIFT Poke
	db -$50, $01,  $2D, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $50, $01,  $2A
	db  $00, $01,  $47
	db -$58, $01, -$2B, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$68, $01,  $00, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $00, $01, -$38
	db  $60, $01,  $00
	db  $5C, $01, -$2C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$3F, $01, -$47, hi(SMVB_startMove_single), lo(SMVB_startMove_single)
	db  $00, $01, -$38, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$40, $01,  $00, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $00, $01,  $38
	db  $40, $01,  $00
	db  $00, $01, -$6B, hi(SMVB_startMove_double), lo(SMVB_startMove_double)
	db -$40, $01,  $00, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $00, $01, -$30, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $40, $01,  $00
	db  $00, $01,  $30
	db  $41, $01, -$67, hi(SMVB_startMove_single), lo(SMVB_startMove_single)
	db -$5D, $01,  $00, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db  $00, $01,  $38, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db  $50, $01,  $00
	db  $08, $01,  $48
	db  $30, $01,  $30
	db  $58, $01,  $00
	db  $38, $01, -$30
	db  $00, $01, -$40, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)

Krippe3SceneData
 DW Krippe3_0 ; list of all single vectorlists in this
 DW Krippe3_1
 DW Krippe3_2
 DW Krippe3_3
 DW Krippe3_4
 DW Krippe3_5
 DW Krippe3_6
 DW Krippe3_7
 DW Krippe3_8
 DW Krippe3_9
 DW Krippe3_10
 DW Krippe3_11
 DW Krippe3_12
 DW 0

Krippe3_0
	db  $61, $01, -$0C, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $61, $01, -$0C, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $13, $01, -$5D, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db  $0F, $01,  $63, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $74, $01, -$36, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$3D, $01,  $71, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $64, $01,  $0E, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$64, $01,  $0E, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $3C, $01,  $7B, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$6E, $01, -$49, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$10, $01,  $76, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$20, $01, -$5C, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe3_1
	db  $5E, $01,  $19, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $5E, $01,  $19, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$1A, $01,  $60, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db -$44, $01,  $68, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$56, $01,  $3C, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$69, $01,  $15, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$72, $01, -$22, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe3_2
	db -$58, $01,  $6B, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$58, $01,  $6B, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$65, $01, -$56, hi(SMVB_startDraw_quadro), lo(SMVB_startDraw_quadro)
	db -$39, $01, -$64, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$10, $01, -$73, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $2D, $01, -$78, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $66, $01, -$54, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe3_3
	db -$4B, $01, -$71, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$4B, $01, -$71, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $56, $01, -$13, hi(SMVB_startDraw_hex), lo(SMVB_startDraw_hex)
	db  $6E, $01,  $13, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $69, $01,  $51, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $2B, $01,  $79, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe3_4
	db  $71, $01,  $03, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $71, $01,  $03, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$6A, $01, -$1E, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$23, $01, -$69, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$1F, $01,  $5D
	db -$69, $01,  $0C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $66, $01,  $16, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $23, $01,  $65, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $22, $01, -$62
	db  $6C, $01, -$1E
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe3_5
	db  $6B, $01, -$6A, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $28, $01,  $6C, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db  $26, $01,  $65, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$6B, $01, -$37, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $2B, $01,  $5D, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$58, $01,  $09, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $58, $01,  $0D, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$2B, $01,  $60, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $65, $01, -$2B, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$21, $01,  $7E, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe3_6
	db  $7F, $01,  $49, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$47, $01,  $63, hi(SMVB_startDraw_quadro), lo(SMVB_startDraw_quadro)
	db -$74, $01,  $4F, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$7C, $01,  $59, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$67, $01,  $12, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$71, $01, -$1E, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$14, $01, -$40, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe3_7
	db -$5B, $01,  $5D, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$5B, $01,  $5D, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $48, $01, -$57, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $65, $01, -$0E, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $41, $01,  $2B, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $01, -$0E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $5B, $01, -$3C, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $48, $01, -$48, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $00, $01, -$48, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$56, $01, -$56, hi(SMVB_continue_yEqx_single), lo(SMVB_continue_yEqx_single); y is -$56
	db -$41, $01,  $15, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$64, $01,  $48, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$77, $01,  $20
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe3_8
	db -$57, $01,  $62, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $4A, $01, -$39, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db -$65, $01, -$2C, hi(SMVB_continue2_single), lo(SMVB_continue2_single)
	db -$48, $01,  $48
	db -$4F, $01, -$07, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$1D, $01,  $65, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$40, $01, -$07, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$48, $01, -$32, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$74, $01, -$0F, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $05, $01, -$76, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe3_9
	db -$5C, $01,  $13, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$5C, $01,  $13, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $4F, $01, -$56, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $5D, $01,  $56, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $74, $01,  $1D, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $39, $01,  $56
	db  $48, $01, -$56
	db -$03, $01, -$6C
	db  $49, $01, -$20, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$72, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db -$56, $01, -$57
	db -$3A, $01, -$56
	db -$1D, $01, -$65
	db -$64, $01, -$0E
	db -$48, $01,  $56
	db -$73, $01,  $5D, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$48, $01, -$56, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$5A, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe3_10
	db -$5B, $01, -$27, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$5B, $01, -$27, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $7C, $01, -$0C, hi(SMVB_startDraw_hex), lo(SMVB_startDraw_hex)
	db  $2B, $01,  $65, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $64, $01,  $07, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $65, $01, -$0E, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db  $65, $01,  $2B
	db  $00, $01, -$73
	db -$65, $01, -$1D
	db  $48, $01, -$32, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $2B, $01,  $65, hi(SMVB_continue6_single), lo(SMVB_continue6_single)
	db  $65, $01,  $39
	db  $65, $01,  $57
	db  $65, $01, -$2B
	db  $39, $01, -$65
	db -$0E, $01, -$73
	db -$72, $01, -$62, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe3_11
	db  $16, $01, -$56, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $16, $01, -$56, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$69, $01,  $00, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db -$69, $01, -$25, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $7C, $01, -$1E, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $6C, $01,  $15, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $6E, $01,  $55, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $5F, $01,  $50, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Krippe3_12
	db -$6B, $01, -$03, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$08, $01,  $46, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$70, $01,  $18, hi(SMVB_startMove_tripple), lo(SMVB_startMove_tripple)
	db -$39, $01, -$40, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $39, $01, -$40, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01,  $56, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$73, $01, -$40, hi(SMVB_startMove_double), lo(SMVB_startMove_double)
	db -$57, $01, -$47, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $15, $01,  $40, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)


BellaSceneData
 DW Bella_0 ; list of all single vectorlists in this
 DW Bella_1
 DW Bella_2
 DW Bella_3
 DW Bella_4
 DW 0

Bella_0
	db  $72, $01,  $21, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $0E, $01,  $7F, hi(SMVB_startDraw_hex), lo(SMVB_startDraw_hex)
	db  $59, $01,  $2C, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $16, $01, -$70, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$3F, $01, -$61, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $61, $01,  $0F, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $00, $01, -$77, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$61, $01,  $16, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $3F, $01, -$64, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$0F, $01, -$77, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$68, $01,  $2D, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$12, $01,  $7B, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Bella_1
	db  $6F, $01, -$19, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$27, $01, -$70, hi(SMVB_startDraw_quadro), lo(SMVB_startDraw_quadro)
	db -$7B, $01, -$7B, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$6F, $01, -$05, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$61, $01, -$43, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$34, $01, -$70, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Bella_2
	db -$46, $01, -$7B, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$46, $01, -$7B, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$70, $01,  $65, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $00, $01,  $66, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $00, $01,  $66, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $00, $01,  $66, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $25, $01,  $5A, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Bella_3
	db -$50, $01,  $79, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$50, $01,  $79, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $59, $01, -$68, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db  $61, $01, -$3B, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $6D, $01, -$05, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $4A, $01, -$6C, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
Bella_4
	db -$59, $01,  $05, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$59, $01,  $05, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db -$4E, $01,  $7B, hi(SMVB_startDraw_quadro), lo(SMVB_startDraw_quadro)
	db  $3B, $01,  $61, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $16, $01, -$61, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)


PresentsSceneData
 DW presents_0 ; list of all single vectorlists in this
 DW presents_1
 DW presents_2
 DW presents_3
 DW presents_4
 DW presents_5
 DW presents_6
 DW presents_7
 DW presents_8
 DW presents_9
 DW presents_10
 DW presents_11
 DW presents_12
 DW presents_13
 DW presents_14
 DW 0

presents_0
	db -$63, $01, -$36, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$63, $01, -$36, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $5E, $01,  $01, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db  $00, $01,  $30, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$5E, $01,  $01, hi(SMVB_startMove_tripple), lo(SMVB_startMove_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
presents_1
	db -$7F, $01, -$6E, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $13, $01,  $20, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $00, $01,  $24, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $34, $01,  $67
	db -$39, $01,  $2C
	db -$1F, $01,  $05
	db -$13, $01, -$0E
	db  $00, $01,  $35
	db -$1D, $01,  $15
	db -$2F, $01, -$05, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$24, $01, -$1A
	db  $05, $01, -$78
	db -$26, $01,  $00
	db -$17, $01, -$26
	db  $0E, $01, -$18
	db  $2F, $01, -$08
	db  $5D, $01, -$1C, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
presents_2
	db -$72, $01, -$33, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$5E, $01, -$02, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db  $00, $01, -$5C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$39, hi(SMVB_continue_yStays_single), lo(SMVB_continue_yStays_single); y is  $00
	db  $00, $01, -$5F, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $5F, $01, -$01, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
presents_3
	db -$72, $01, -$5A, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $04, $01, -$49, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $5E, $01, -$05, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $0E, $01,  $29
	db  $2B, $01,  $1A
	db -$2D, $01, -$11, hi(SMVB_startMove_single), lo(SMVB_startMove_single)
	db -$07, $01,  $29, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $09, $01,  $74, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $29, $01, -$57
	db  $00, $01, -$37
	db  $21, $01,  $00
	db  $18, $01,  $1A
	db -$18, $01,  $54
	db -$2A, $01,  $29
	db -$38, $01, -$0C, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db -$74, $01, -$3A
	db -$1A, $01,  $1D
	db -$02, $01,  $1D
	db  $4C, $01,  $17, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $10, $01,  $24, hi(SMVB_startMove_single), lo(SMVB_startMove_single)
	db  $31, $01, -$04, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
presents_4
	db -$7D, $01, -$4A, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db -$05, $01, -$2C, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$29, $01, -$67, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$02, $01,  $45, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
presents_5
	db -$65, $01, -$4E, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $10, $01,  $24, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$70, $01,  $3E, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
presents_6
	db -$5B, $01, -$09, hi(SMVB_continue_hex), lo(SMVB_continue_hex)
	db  $5E, $01,  $01, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db  $00, $01,  $30, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$5E, $01,  $01, hi(SMVB_startMove_tripple), lo(SMVB_startMove_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
presents_7
	db -$73, $01, -$39, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $13, $01,  $20, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $00, $01,  $24, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $35, $01,  $67
	db -$3A, $01,  $2D
	db -$1F, $01,  $05
	db -$13, $01, -$0E
	db  $00, $01,  $35
	db -$1D, $01,  $15
	db -$30, $01, -$05, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db -$24, $01, -$1A
	db  $05, $01, -$78
	db -$26, $01,  $00
	db -$18, $01, -$26
	db  $0F, $01, -$18
	db  $2F, $01, -$08
	db  $5D, $01, -$1C, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
presents_8
	db -$58, $01,  $40, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$5E, $01, -$02, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db  $00, $01, -$5C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$39, hi(SMVB_continue_yStays_single), lo(SMVB_continue_yStays_single); y is  $00
	db  $00, $01, -$5F, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $60, $01, -$01, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
presents_9
	db -$58, $01, -$29, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $04, $01, -$49, hi(SMVB_startDraw_double), lo(SMVB_startDraw_double)
	db  $5E, $01, -$05, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $0E, $01,  $29
	db  $2B, $01,  $1A
	db -$2D, $01, -$11, hi(SMVB_startMove_single), lo(SMVB_startMove_single)
	db -$07, $01,  $29, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $09, $01,  $74, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $29, $01, -$57
	db  $00, $01, -$37
	db  $22, $01,  $00
	db  $18, $01,  $1A
	db -$18, $01,  $54
	db -$2B, $01,  $29
	db -$38, $01, -$0C, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db -$75, $01, -$3A
	db -$1A, $01,  $1D
	db -$02, $01,  $1D
	db  $4C, $01,  $17, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $10, $01,  $24, hi(SMVB_startMove_single), lo(SMVB_startMove_single)
	db  $31, $01, -$04, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
presents_10
	db -$32, $01,  $4F, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$05, $01, -$2D, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$29, $01, -$67, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$02, $01,  $45, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
presents_11
	db -$51, $01, -$0C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $10, $01,  $24, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$70, $01,  $3E, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
presents_12
	db -$1C, $01,  $60, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db  $00, $01,  $74, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$5A, $01,  $03, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$15, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db -$69, $01, -$02, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$01, $01, -$7B, hi(SMVB_continue_quadro), lo(SMVB_continue_quadro)
	db  $6B, $01,  $00, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $0D, $01, -$24, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $55, $01,  $04, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01,  $76, hi(SMVB_continue7_single), lo(SMVB_continue7_single)
	db  $27, $01, -$2E
	db  $30, $01,  $00
	db  $1C, $01,  $1C
	db  $00, $01,  $41
	db -$4C, $01,  $70
	db  $4C, $01,  $65
	db  $00, $01,  $3D, hi(SMVB_continue4_single), lo(SMVB_continue4_single)
	db -$19, $01,  $2A
	db -$24, $01,  $00
	db -$36, $01, -$36
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
presents_13
	db -$20, $01,  $6C, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$75, $01, -$07, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$04, $01, -$58, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $7E, $01,  $00, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $00, $01,  $5C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $00, $01, -$66, hi(SMVB_startMove_double), lo(SMVB_startMove_double)
	db -$77, $01, -$08, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db -$07, $01, -$52, hi(SMVB_continue3_single), lo(SMVB_continue3_single)
	db  $7E, $01,  $00
	db  $00, $01,  $5A
	db  $00, $01, -$77, hi(SMVB_startMove_yStays_single), lo(SMVB_startMove_yStays_single); y was  $00, now 0
	db -$7E, $01, -$0C, hi(SMVB_startDraw_single), lo(SMVB_startDraw_single)
	db  $00, $01, -$52, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $7E, $01,  $00, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $00, $01,  $58, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
presents_14
	db -$33, $01,  $68, hi(SMVB_continue_octo), lo(SMVB_continue_octo)
	db -$63, $01,  $00, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db  $00, $01, -$4A, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $63, $01,  $00, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $00, $01,  $4A, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db -$02, $01, -$5F, hi(SMVB_startMove_tripple), lo(SMVB_startMove_tripple)
	db -$5E, $01, -$01, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db -$04, $01, -$4C, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $63, $01,  $00, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db -$04, $01,  $4E, hi(SMVB_continue_double), lo(SMVB_continue_double)
	db  $08, $01,  $77, hi(SMVB_startMove_single), lo(SMVB_startMove_single)
	db -$61, $01, -$02, hi(SMVB_startDraw_tripple), lo(SMVB_startDraw_tripple)
	db -$08, $01, -$52, hi(SMVB_continue_single), lo(SMVB_continue_single)
	db  $63, $01,  $00, hi(SMVB_continue_tripple), lo(SMVB_continue_tripple)
	db  $00, $01,  $5A, hi(SMVB_continue_newY_eq_oldX_single), lo(SMVB_continue_newY_eq_oldX_single) ; y is  $00
	db  $40, $00,  $00, hi(SMVB_lastDraw_rts), lo(SMVB_lastDraw_rts)
