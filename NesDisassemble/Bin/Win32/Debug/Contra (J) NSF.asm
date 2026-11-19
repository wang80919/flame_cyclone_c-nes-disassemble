;Contra (J) NSF
;Disassemble by FlameCyclone
;2025.4.16

	.INSFVERSION          	1
	.INSFTOTALSONGS      	44
	.INSFSTARTSONG       	1
	.INSFLOAD        		$8000
	.INSFINIT        		Init_Addr
	.INSFPLAY        		Play_Addr
	.INSFNAME             	"Contra"
	.INSFARTIST		   		"H. Maezawa, K. Sada"
	.INSFCOPYRIGHT        	"1988 Konami"
	.INSFSPEEDNTSC  		16666
	.INSFBANKSWITCH      	0,1,2,3,4,5,6,7
	.INSFSPEEDPAL   		16666
	.INSFSTANDARD         	0
	.INSFEXTRASOUND      	0

Zero_25 = $25
Zero_E0 = $E0
Zero_E1 = Zero_E0 + $01
Zero_E4 = Zero_E0 + $04
Zero_E5 = Zero_E0 + $05
Zero_E6 = Zero_E0 + $06
Zero_E7 = Zero_E0 + $07
Zero_E8 = Zero_E0 + $08
Zero_E9 = Zero_E0 + $09
Zero_EA = Zero_E0 + $0A
Zero_EB = Zero_E0 + $0B
Zero_EC = Zero_E0 + $0C
Zero_ED = Zero_E0 + $0D
Zero_EE = Zero_E0 + $0E
Zero_EF = Zero_E0 + $0F
Absolute_0100 = $0100
Absolute_0106 = Absolute_0100 + $06
Absolute_0107 = Absolute_0100 + $07
Absolute_010A = Absolute_0100 + $0A
Absolute_010C = Absolute_0100 + $0C
Absolute_0112 = Absolute_0100 + $12
Absolute_0118 = Absolute_0100 + $18
Absolute_011E = Absolute_0100 + $1E
Absolute_0120 = Absolute_0100 + $20
Absolute_0121 = Absolute_0100 + $21
Absolute_0122 = Absolute_0100 + $22
Absolute_0123 = Absolute_0100 + $23
Absolute_0124 = Absolute_0100 + $24
Absolute_0128 = Absolute_0100 + $28
Absolute_012A = Absolute_0100 + $2A
Absolute_012D = Absolute_0100 + $2D
Absolute_012F = Absolute_0100 + $2F
Absolute_0130 = Absolute_0100 + $30
Absolute_0132 = Absolute_0100 + $32
Absolute_0135 = Absolute_0100 + $35
Absolute_0136 = Absolute_0100 + $36
Absolute_013C = Absolute_0100 + $3C
Absolute_013E = Absolute_0100 + $3E
Absolute_0140 = Absolute_0100 + $40
Absolute_0141 = Absolute_0100 + $41
Absolute_0142 = Absolute_0100 + $42
Absolute_0144 = Absolute_0100 + $44
Absolute_0148 = Absolute_0100 + $48
Absolute_014E = Absolute_0100 + $4E
Absolute_0154 = Absolute_0100 + $54
Absolute_015A = Absolute_0100 + $5A
Absolute_0160 = Absolute_0100 + $60
Absolute_0166 = Absolute_0100 + $66
Absolute_016C = Absolute_0100 + $6C
Absolute_0172 = Absolute_0100 + $72
Absolute_0178 = Absolute_0100 + $78
Absolute_017A = Absolute_0100 + $7A
Absolute_017C = Absolute_0100 + $7C
Absolute_017E = Absolute_0100 + $7E
Absolute_0180 = Absolute_0100 + $80
Absolute_0194 = Absolute_0100 + $94

PLAY_PROGRAM_BANK 	= $00
PLAY_PROGRAM_ADDR 	= $8000

MUSIC_DATA_BANK   	= -1
MUSIC_DATA_ADDR   	= -1

DMC_DATA_BANK   	= $00
DMC_DATA_ADDR   	= $C000

 .BANK32 PLAY_PROGRAM_BANK
 .ORG PLAY_PROGRAM_ADDR
Proc_Start ;$806D
    LDA #$30
    STA $4000,X ;$4000
    JSR sound_delay ;$870C
    BNE Label_5 ;$808D
Label_3 ;$8077
    LDA Absolute_0124,X ;$0124
    AND #$41
    ORA Absolute_012F ;$012F
    BNE Proc_Start ;$806D
Label_4 ;$8081
    LDA Absolute_0160,X ;$0160
    ORA Absolute_014E,X ;$014E
    STA $4000,Y ;$4000
    JSR sound_delay ;$870C
Label_5 ;$808D
    LDA Absolute_0172,X ;$0172
    STA $4002,Y ;$4002
    JSR sound_delay ;$870C
    LDA Absolute_010C,X ;$010C
    STA $4003,Y ;$4003
    JMP sound_delay ;$870C

Label_6 ;$809F
    LDA <Zero_25
    CMP Absolute_012F ;$012F
    BEQ Label_10 ;$80D4
    STA Absolute_012F ;$012F
    CMP #$00
    BEQ Label_7 ;$80B0
    JMP Label_136 ;$8758

Label_7 ;$80B0
    LDA Absolute_010A ;$010A
    BEQ Label_9 ;$80C8
    LDA Absolute_0128 ;$0128
    BPL Label_8 ;$80C0
    LDA Absolute_012D ;$012D
    STA $4001 ;$4001
Label_8 ;$80C0
    LDX #$04
    LDY #$00
    JSR Label_4 ;$8081
    RTS

Label_9 ;$80C8
    LDA Absolute_0106 ;$0106
    BEQ Label_10 ;$80D4
    LDX #$00
    LDY #$00
    JSR Label_3 ;$8077
Label_10 ;$80D4
    RTS

Play_Addr ;$80D5
    JSR Label_6 ;$809F
    LDX #$00
    LDY #$00
Label_12 ;$80DC
    STX Absolute_0120 ;$0120
    STY Absolute_0123 ;$0123
    LDA Absolute_0106,X ;$0106
    BEQ Label_13 ;$80EB
    TAY
    JSR Label_17 ;$8103
Label_13 ;$80EB
    INX
    CPX #$06
    BEQ Label_16 ;$8102
    CPX #$05
    BNE Label_14 ;$80F9
    LDA #$0C
    JMP Label_15 ;$80FE

Label_14 ;$80F9
    TXA
    ASL A
    ASL A
    AND #$0F
Label_15 ;$80FE
    TAY
    JMP Label_12 ;$80DC

Label_16 ;$8102
    RTS

Label_17 ;$8103
    LDA Absolute_012F ;$012F
    BEQ Label_18 ;$810F
    LDA Absolute_0106,X ;$0106
    CMP #$74
    BNE Label_16 ;$8102
Label_18 ;$810F
    JSR Label_116 ;$861D
    LDA Absolute_0124,X ;$0124
    DEC Absolute_0100,X ;$0100
    BNE Label_19 ;$811D
    JMP Label_45 ;$8259

Label_19 ;$811D
    AND #$41
    BNE Label_28 ;$818F
    CPX #$02
    BEQ Label_28 ;$818F
    CPX #$03
    BEQ Label_28 ;$818F
    CPX #$02
    BCS Label_20 ;$8140
    LDA Absolute_0178,X ;$0178
    BMI Label_20 ;$8140
    INC Absolute_017A,X ;$017A
    LDA Absolute_017E,X ;$017E
    CMP Absolute_017A,X ;$017A
    BCS Label_20 ;$8140
    JSR Label_40 ;$81F5
Label_20 ;$8140
    LDA Absolute_0124,X ;$0124
    AND #$20
    BNE Label_21 ;$814C
    LDA Absolute_011E,X ;$011E
    BMI Label_34 ;$81BD
Label_21 ;$814C
    LDA Absolute_0124,X ;$0124
    TAY
    AND #$04
    BNE Label_31 ;$81A7
Label_22 ;$8154
    LDA Absolute_011E,X ;$011E
    ASL A
    TAY
    LDA data_index,Y ;$8001
    STA <Zero_E4
    LDA data_index + 1,Y ;$8002
    STA <Zero_E5
Label_23 ;$8163
    LDA Absolute_012A,X ;$012A
    TAY
    LDA [Zero_E4],Y ;$8167
    CMP #$FE
    BCS Label_29 ;$8190
    INC Absolute_012A,X ;$012A
    AND #$1F
Label_24 ;$8172
    STA Absolute_0160,X ;$0160
Label_25 ;$8175
    CMP #$02
    BCC Label_26 ;$8181
    SEC
    SBC Absolute_013C ;$013C
    BPL Label_26 ;$8181
    LDA #$00
Label_26 ;$8181
    ORA Absolute_014E,X ;$014E
    JSR Label_118 ;$8637
    BCS Label_27 ;$818C
    STA $4000,X ;$4000
Label_27 ;$818C
    LDX Absolute_0120 ;$0120
Label_28 ;$818F
    RTS

Label_29 ;$8190
    BNE Label_30 ;$819E
    INY
    LDA [Zero_E4],Y ;$8193
    STA Absolute_012A,X ;$012A
    JSR Label_32 ;$81AC
    JMP Label_23 ;$8163

Label_30 ;$819E
    LDA Absolute_0124,X ;$0124
    ORA #$04
    STA Absolute_0124,X ;$0124
    RTS

Label_31 ;$81A7
    TYA
    AND #$02
    BNE Label_36 ;$81D8
Label_32 ;$81AC
    LDA Absolute_0100,X ;$0100
    CMP Absolute_0130,X ;$0130
    BCS Label_33 ;$81BC
    LDA Absolute_0124,X ;$0124
    ORA #$06
    STA Absolute_0124,X ;$0124
Label_33 ;$81BC
    RTS

Label_34 ;$81BD
    DEC Absolute_012A,X ;$012A
    BMI Label_35 ;$81CD
    DEC Absolute_0160,X ;$0160
    BMI Label_37 ;$81E3
    LDA Absolute_0160,X ;$0160
    JMP Label_25 ;$8175

Label_35 ;$81CD
    LDA Absolute_0124,X ;$0124
    ORA #$20
    STA Absolute_0124,X ;$0124
    JMP Label_30 ;$819E

Label_36 ;$81D8
    DEC Absolute_0160,X ;$0160
    BEQ Label_37 ;$81E3
    LDA Absolute_0160,X ;$0160
    JMP Label_25 ;$8175

Label_37 ;$81E3
    INC Absolute_0160,X ;$0160
    RTS

Label_38 ;$81E7
    LDA [Zero_E0],Y ;$81E7
    CMP #$FD
    BCC Label_39 ;$81F2
    AND #$0F
    JMP Label_86 ;$84A2

Label_39 ;$81F2
    JMP Label_54 ;$82D5

Label_40 ;$81F5
    TYA
    PHA
    LDY Absolute_0123 ;$0123
    SEC
    SBC Absolute_017E,X ;$017E
    STA <Zero_E4
    LDA Absolute_0180,X ;$0180
    AND #$F0
    LSR A
    LSR A
    LSR A
    LSR A
    CMP <Zero_E4
    BNE Label_41 ;$8222
    LDA Absolute_017E,X ;$017E
    STA Absolute_017A,X ;$017A
    INC Absolute_0178,X ;$0178
    LDA Absolute_0178,X ;$0178
    CMP #$04
    BCC Label_41 ;$8222
    LDA #$00
    STA Absolute_0178,X ;$0178
Label_41 ;$8222
    LDA Absolute_0178,X ;$0178
    AND #$01
    BNE Label_43 ;$8235
    LDA Absolute_017C,X ;$017C
Label_42 ;$822C
    STA $4002,Y ;$4002
    JSR sound_delay ;$870C
    PLA
    TAY
    RTS

Label_43 ;$8235
    LDA Absolute_0180,X ;$0180
    AND #$0F
    STA <Zero_E4
    LDA Absolute_0178,X ;$0178
    AND #$02
    BNE Label_44 ;$8250
    LDA <Zero_E4
    CLC
    ADC Absolute_017C,X ;$017C
    BCC Label_42 ;$822C
    LDA #$FF
    JMP Label_42 ;$822C

Label_44 ;$8250
    LDA Absolute_017C,X ;$017C
    SEC
    SBC <Zero_E4
    JMP Label_42 ;$822C

Label_45 ;$8259
    LSR A
    BCS Label_38 ;$81E7
Label_46 ;$825C
    LDA Absolute_0120 ;$0120
    CMP #$03
    BEQ Label_48 ;$8288
    LDA [Zero_E0],Y ;$8263
    AND #$F0
    CMP #$C0
    BCS Label_47 ;$826E
    JMP Label_69 ;$8395

Label_47 ;$826E
    AND #$30
    LSR A
    LSR A
    LSR A
    TAX
    LDA program_play_index2,X ;$86D4
    STA <Zero_E4
    LDA program_play_index2 + 1,X ;$86D5
    STA <Zero_E5
    LDX Absolute_0120 ;$0120
    LDA [Zero_E0],Y ;$8281
    AND #$0F
    JMP [Zero_E4]

Label_48 ;$8288
    LDA [Zero_E0],Y ;$8288
    AND #$F0
    CMP #$F0
    BNE Label_49 ;$8297
    LDA [Zero_E0],Y ;$8290
    AND #$0F
    JMP Label_86 ;$84A2

Label_49 ;$8297
    CMP #$D0
    BEQ Label_50 ;$829E
    JMP Label_106 ;$85B7

Label_50 ;$829E
    LDA [Zero_E0],Y ;$829E
    AND #$0F
    STA Absolute_0154,X ;$0154
    INY
    JMP Label_48 ;$8288

Label_51 ;$82A9
    LDA [Zero_E0],Y ;$82A9
    LSR A
    LSR A
    LSR A
    LSR A
    CMP #$0C
    BEQ Label_52 ;$82C9
    TAX
    STA Absolute_0121 ;$0121
    LDA Label_53,X ;$82CD
    JSR Label_138 ;$87A2
    LDA Absolute_0121 ;$0121
    CMP #$03
    BCC Label_52 ;$82C9
    LDA #$02
    JSR Label_138 ;$87A2
Label_52 ;$82C9
    LDX Absolute_0120 ;$0120
    RTS

Label_54 ;$82D5
    AND #$F0
    CMP #$20
    BNE Label_56 ;$82F3
    LDA [Zero_E0],Y ;$82DB
    AND #$0F
    BNE Label_55 ;$82E4
    INY
    LDA [Zero_E0],Y ;$82E2
Label_55 ;$82E4
    STA Absolute_0154,X ;$0154
    INY
    LDA [Zero_E0],Y ;$82E8
    STA Absolute_014E,X ;$014E
    INY
    BEQ Label_56 ;$82F3
    JMP Label_38 ;$81E7

Label_56 ;$82F3
    CMP #$10
    BNE Label_62 ;$8339
    LDA [Zero_E0],Y ;$82F7
    INY
    CMP #$10
    BNE Label_61 ;$832E
    LDA [Zero_E0],Y ;$82FE
    BNE Label_57 ;$830E
    LDA Absolute_0124,X ;$0124
    AND #$7F
    STA Absolute_0124,X ;$0124
    LDA #$7F
    BNE Label_58 ;$8318
Label_57 ;$830E
    LDA Absolute_0124,X ;$0124
    ORA #$80
    STA Absolute_0124,X ;$0124
    LDA [Zero_E0],Y ;$8316
Label_58 ;$8318
    CPX #$04
    BNE Label_59 ;$831F
    STA Absolute_012D ;$012D
Label_59 ;$831F
    JSR Label_118 ;$8637
    BCS Label_60 ;$8327
    STA $4001,X ;$4001
Label_60 ;$8327
    LDX Absolute_0120 ;$0120
    INY
    JMP Label_38 ;$81E7

Label_61 ;$832E
    LDA Absolute_0124,X ;$0124
    ORA #$10
    STA Absolute_0124,X ;$0124
    JMP Label_38 ;$81E7

Label_62 ;$8339
    LDA Absolute_0154,X ;$0154
    STA Absolute_0100,X ;$0100
    LDA [Zero_E0],Y ;$833F
    CMP #$F8
    BNE Label_63 ;$8348
    INY
    LDA [Zero_E0],Y ;$8346
Label_63 ;$8348
    LSR A
    LSR A
    LSR A
    LSR A
    STA Absolute_0142,X ;$0142
    LDA Absolute_014E,X ;$014E
    AND #$10
    BEQ Label_66 ;$8375
    LDA Absolute_0142,X ;$0142
    ORA Absolute_014E,X ;$014E
Label_64 ;$835C
    JSR Label_118 ;$8637
    BCS Label_65 ;$8364
    STA $4000,X ;$4000
Label_65 ;$8364
    LDX Absolute_0120 ;$0120
    LDA [Zero_E0],Y ;$8367
    AND #$0F
    STA <Zero_EF
    INY
    LDA [Zero_E0],Y ;$836E
    STA <Zero_EE
    JMP Label_75 ;$8409

Label_66 ;$8375
    LDA Absolute_014E,X ;$014E
    JMP Label_64 ;$835C

Label_67 ;$837B
    LDA Absolute_0144 ;$0144
    STA $4008 ;$4008
    JMP Label_70 ;$83AD

Label_68 ;$8384
    LDA Absolute_0142,X ;$0142
    JSR Label_24 ;$8172
    LDA Absolute_011E,X ;$011E
    AND #$0F
    STA Absolute_012A,X ;$012A
    JMP Label_70 ;$83AD

Label_69 ;$8395
    JSR Label_106 ;$85B7
    CPX #$02
    BEQ Label_67 ;$837B
    LDA Absolute_011E,X ;$011E
    BMI Label_68 ;$8384
    LDA #$00
    STA Absolute_012A,X ;$012A
    STY <Zero_E6
    JSR Label_22 ;$8154
    LDY <Zero_E6
Label_70 ;$83AD
    LDA Absolute_0124,X ;$0124
    AND #$99
    STA Absolute_0124,X ;$0124
    LDA [Zero_E0],Y ;$83B5
    AND #$F0
    LSR A
    LSR A
    LSR A
    TAX
    TYA
    PHA
    LDY Absolute_0120 ;$0120
    LDA Absolute_0132,Y ;$0132
    BEQ Label_71 ;$83CD
    TXA
    CLC
    ADC Absolute_0132,Y ;$0132
    TAX
Label_71 ;$83CD
    PLA
    TAY
    LDA Label_131,X ;$86DC
    STA <Zero_EE
    LDA Label_131 + 1,X ;$86DD
    STA <Zero_EF
    LDX Absolute_0120 ;$0120
    LDA Absolute_015A,X ;$015A
    TAX
Label_72 ;$83E0
    CPX #$04
    BEQ Label_73 ;$83EB
    LSR <Zero_EF
    ROR <Zero_EE
    INX
    BNE Label_72 ;$83E0
Label_73 ;$83EB
    LDX Absolute_0120 ;$0120
    CPX #$02
    BCS Label_75 ;$8409
    LDA Absolute_0178,X ;$0178
    BMI Label_75 ;$8409
    LDA <Zero_EE
    STA Absolute_017C,X ;$017C
    LDA Absolute_0124,X ;$0124
    AND #$10
    BEQ Label_74 ;$8406
    INC Absolute_017C,X ;$017C
Label_74 ;$8406
    LDX Absolute_0120 ;$0120
Label_75 ;$8409
    LDA Absolute_0124,X ;$0124
    AND #$10
    BEQ Label_76 ;$8416
    INC <Zero_EE
    BNE Label_76 ;$8416
    INC <Zero_EF
Label_76 ;$8416
    LDA <Zero_EF
    CPX #$02
    BEQ Label_78 ;$8433
    CPX #$05
    BEQ Label_77 ;$8431
    CMP Absolute_010C,X ;$010C
    BNE Label_78 ;$8433
    LDA Absolute_0124,X ;$0124
    BMI Label_77 ;$8431
    LDA Absolute_014E,X ;$014E
    AND #$10
    BNE Label_79 ;$8440
Label_77 ;$8431
    LDA <Zero_EF
Label_78 ;$8433
    STA Absolute_010C,X ;$010C
    ORA #$08
    JSR Label_118 ;$8637
    BCS Label_79 ;$8440
    STA $4003,X ;$4003
Label_79 ;$8440
    LDA <Zero_EE
    LDX Absolute_0120 ;$0120
    CPX #$02
    BCS Label_80 ;$844C
    STA Absolute_0172,X ;$0172
Label_80 ;$844C
    JSR Label_118 ;$8637
    BCS Label_81 ;$8454
    STA $4002,X ;$4002
Label_81 ;$8454
    LDX Absolute_0120 ;$0120
Label_82 ;$8457
    INY
    TYA
    CLC
    ADC <Zero_E0
    STA Absolute_0112,X ;$0112
    LDA #$00
    ADC <Zero_E1
    STA Absolute_0118,X ;$0118
    RTS

Label_83 ;$8467
    LDA Absolute_0166,X ;$0166
    STA <Zero_E0
    LDA Absolute_016C,X ;$016C
    STA <Zero_E1
    LDA Absolute_0124,X ;$0124
    AND #$F7
    STA Absolute_0124,X ;$0124
    LDY #$00
    JMP Label_90 ;$84DC

Label_84 ;$847E
    LDA Absolute_0124,X ;$0124
    AND #$08
    BNE Label_83 ;$8467
    LDA Absolute_0106,X ;$0106
    STA <Zero_E6
    LDA #$00
Label_85 ;$848C
    STA Absolute_0106,X ;$0106
    TXA
    ASL A
    TAX
    LDA program_play_index1,X ;$86C6
    STA <Zero_E4
    LDA program_play_index1 + 1,X ;$86C7
    STA <Zero_E5
    LDX Absolute_0120 ;$0120
    JMP [Zero_E4]

Label_86 ;$84A2
    CMP #$0E
    BEQ Label_87 ;$84C6
    BCS Label_84 ;$847E
    JSR Label_117 ;$862A
    INY
    TYA
    CLC
    ADC <Zero_E0
    STA Absolute_0166,X ;$0166
    LDA #$00
    TAY
    ADC <Zero_E1
    STA Absolute_016C,X ;$016C
    LDA Absolute_0124,X ;$0124
    ORA #$08
    STA Absolute_0124,X ;$0124
    JMP Label_89 ;$84D9

Label_87 ;$84C6
    INC Absolute_0148,X ;$0148
    LDA Absolute_0148,X ;$0148
    INY
    CMP [Zero_E0],Y ;$84CD
    BEQ Label_92 ;$84E8
    BMI Label_88 ;$84D6
    DEC Absolute_0148,X ;$0148
Label_88 ;$84D6
    JSR Label_117 ;$862A
Label_89 ;$84D9
    JSR Label_116 ;$861D
Label_90 ;$84DC
    LDA Absolute_0124,X ;$0124
    LSR A
    BCS Label_91 ;$84E5
    JMP Label_46 ;$825C

Label_91 ;$84E5
    JMP Label_38 ;$81E7

Label_92 ;$84E8
    LDA #$00
    STA Absolute_0148,X ;$0148
    INY
    INY
    INY
    TYA
    CLC
    ADC <Zero_E0
    STA <Zero_E0
    LDA #$00
    TAY
    ADC <Zero_E1
    STA <Zero_E1
    JMP Label_90 ;$84DC

Label_93 ;$8500
    JSR Label_107 ;$85BB
    LDA #$00
    CPX #$02
    BEQ Label_94 ;$850C
    LDA Absolute_014E,X ;$014E
Label_94 ;$850C
    JSR Label_118 ;$8637
    BCS Label_95 ;$8514
    STA $4000,X ;$4000
Label_95 ;$8514
    LDX Absolute_0120 ;$0120
    LDA Absolute_0124,X ;$0124
    ORA #$40
    STA Absolute_0124,X ;$0124
    JMP Label_82 ;$8457

Label_96 ;$8522
    STA Absolute_0154,X ;$0154
    INY
    LDA [Zero_E0],Y ;$8526
    CPX #$02
    BEQ Label_98 ;$8555
    AND #$0F
    SEC
    SBC Absolute_013C ;$013C
    BPL Label_97 ;$8539
    LDA #$00
    JMP Label_85 ;$848C

Label_97 ;$8539
    STA Absolute_0142,X ;$0142
    LDA [Zero_E0],Y ;$853C
    AND #$F0
    STA Absolute_014E,X ;$014E
    INY
    LDA [Zero_E0],Y ;$8544
    STA Absolute_011E,X ;$011E
    INY
    LDA [Zero_E0],Y ;$854A
    AND #$0F
    STA Absolute_0136,X ;$0136
    INY
    JMP Label_46 ;$825C

Label_98 ;$8555
    STA Absolute_0144 ;$0144
    INY
    JMP Label_46 ;$825C

Label_99 ;$855C
    CMP #$05
    BCS Label_100 ;$8567
    STA Absolute_015A,X ;$015A
    INY
    JMP Label_46 ;$825C

Label_100 ;$8567
    CMP #$08
    BEQ Label_101 ;$8577
    CMP #$0B
    BEQ Label_102 ;$8583
    CMP #$0C
    BEQ Label_104 ;$85A5
    INY
    JMP Label_46 ;$825C

Label_101 ;$8577
    LDA Absolute_0124,X ;$0124
    EOR #$10
    STA Absolute_0124,X ;$0124
    INY
    JMP Label_46 ;$825C

Label_102 ;$8583
    INY
    LDA [Zero_E0],Y ;$8584
    STA Absolute_017E,X ;$017E
    CMP #$FF
    BEQ Label_103 ;$859C
    INY
    LDA [Zero_E0],Y ;$858E
    STA Absolute_0180,X ;$0180
    LDA #$00
    STA Absolute_0178,X ;$0178
    INY
    JMP Label_46 ;$825C

Label_103 ;$859C
    LDA #$80
    STA Absolute_0178,X ;$0178
    INY
    JMP Label_46 ;$825C

Label_104 ;$85A5
    INY
    LDA [Zero_E0],Y ;$85A6
    ASL A
    STA Absolute_0132,X ;$0132
    INY
    JMP Label_46 ;$825C

Label_105 ;$85B0
    JSR Label_82 ;$8457
    DEY
    JMP Label_51 ;$82A9

Label_106 ;$85B7
    LDA [Zero_E0],Y ;$85B7
    AND #$0F
Label_107 ;$85BB
    STA <Zero_E4
    BEQ Label_109 ;$85CC
    LDA Absolute_0154,X ;$0154
Label_108 ;$85C2
    CLC
    ADC Absolute_0154,X ;$0154
    DEC <Zero_E4
    BNE Label_108 ;$85C2
    BEQ Label_110 ;$85CF
Label_109 ;$85CC
    LDA Absolute_0154,X ;$0154
Label_110 ;$85CF
    STA Absolute_0100,X ;$0100
    CPX #$02
    BCS Label_111 ;$85E0
    LDA Absolute_0178,X ;$0178
    BMI Label_111 ;$85E0
    LDA #$00
    STA Absolute_017A,X ;$017A
Label_111 ;$85E0
    CPX #$02
    BEQ Label_112 ;$85F1
    CPX #$03
    BEQ Label_105 ;$85B0
    LDA Absolute_0136,X ;$0136
    JSR Label_113 ;$85F2
    STA Absolute_0130,X ;$0130
Label_112 ;$85F1
    RTS

Label_113 ;$85F2
    AND #$0F
    STA <Zero_E4
    LDA #$00
    STA <Zero_E6
    STA <Zero_E7
Label_114 ;$85FC
    DEC <Zero_E4
    BMI Label_115 ;$860E
    CLC
    LDA Absolute_0100,X ;$0100
    ADC <Zero_E6
    STA <Zero_E6
    BCC Label_114 ;$85FC
    INC <Zero_E7
    BNE Label_114 ;$85FC
Label_115 ;$860E
    ASL A
    ROL <Zero_E7
    ASL A
    ROL <Zero_E7
    ASL A
    ROL <Zero_E7
    ASL A
    ROL <Zero_E7
    LDA <Zero_E7
    RTS

Label_116 ;$861D
    LDY #$00
    LDA Absolute_0112,X ;$0112
    STA <Zero_E0
    LDA Absolute_0118,X ;$0118
    STA <Zero_E1
    RTS

Label_117 ;$862A
    INY
    LDA [Zero_E0],Y ;$862B
    STA Absolute_0112,X ;$0112
    INY
    LDA [Zero_E0],Y ;$8631
    STA Absolute_0118,X ;$0118
    RTS

Label_118 ;$8637
    PHA
    CPX #$01
    BCC Label_120 ;$8642
Label_119 ;$863C
    CLC
    LDX Absolute_0123 ;$0123
    PLA
    RTS

Label_120 ;$8642
    INX
    INX
    INX
    INX
    LDA Absolute_0106,X ;$0106
    BEQ Label_119 ;$863C
    LDX Absolute_0120 ;$0120
    SEC
    PLA
Label_121 ;$8650
    RTS

Label_122 ;$8651
    LDA #$30
    JSR Label_118 ;$8637
    BCS Label_123 ;$865B
    STA $4000,X ;$4000
Label_123 ;$865B
    LDX Absolute_0120 ;$0120
    RTS

Label_124 ;$865F
    LDA #$0B
    STA $4015 ;$4015
    LDA #$00
    STA $4008 ;$4008
    LDA #$0F
    STA $4015 ;$4015
    RTS

Label_125 ;$866F
    LDX Absolute_0123 ;$0123
    LDA #$30
    STA $4000,X ;$4000
    JSR sound_delay ;$870C
    LDA #$7F
    STA $4001,X ;$4001
    TXA
    LSR A
    LSR A
    TAX
    LDA Absolute_0106,X ;$0106
    BEQ Label_128 ;$86BE
    LDY Absolute_0123 ;$0123
    JSR Label_3 ;$8077
    LDX Absolute_0120 ;$0120
    RTS

Label_126 ;$8692
    LDA #$30
    STA $400C ;$400C
    LDA <Zero_E6
    CMP #$6A
    BNE Label_127 ;$86A3
    LDA #$6E
    JMP Label_138 ;$87A2

    RTS

Label_127 ;$86A3
    CMP #$77
    BNE Label_121 ;$8650
    LDA Absolute_0120 ;$0120
    CMP #$05
    BNE Label_121 ;$8650
    LDA Absolute_0194 ;$0194
    BEQ Label_121 ;$8650
    LDA #$62
    JSR Label_138 ;$87A2
    RTS

    LDA #$66
    JMP Label_138 ;$87A2

Label_128 ;$86BE
    LDX Absolute_0120 ;$0120
    LDA <Zero_E6
    JMP Label_121 ;$8650

sound_delay ;$870C
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RTS

Label_134 ;$8719
    TXA
    PHA
    TYA
    PHA
    LDA #$00
    TAX
Label_135 ;$8720
    STA Absolute_0106,X ;$0106
    INX
    CPX #$06
    BCC Label_135 ;$8720
    STA Absolute_0140 ;$0140
    STA Absolute_013E ;$013E
    STA Absolute_013C ;$013C
    JSR Label_124 ;$865F
    LDA #$30
    STA $4000 ;$4000
    JSR sound_delay ;$870C
    STA $4004 ;$4004
    JSR sound_delay ;$870C
    STA $400C ;$400C
    JSR sound_delay ;$870C
    LDX #$7F
    STX $4001 ;$4001
    JSR sound_delay ;$870C
    STX $4005 ;$4005
    PLA
    TAY
    PLA
    TAX
    RTS

Label_136 ;$8758
    JSR Label_124 ;$865F
    LDA #$30
    STA $4000 ;$4000
    JSR sound_delay ;$870C
    STA $4004 ;$4004
    JSR sound_delay ;$870C
    STA $400C ;$400C
    JSR sound_delay ;$870C
    LDX #$7F
    STX $4001 ;$4001
    JSR sound_delay ;$870C
    STX $4005 ;$4005
    RTS

    TXA
    PHA
    TYA
    PHA
    LDX #$00
    STX <Zero_E6
    LDA Absolute_010A ;$010A
    BEQ Label_137 ;$8791
    STX Absolute_010A ;$010A
    STX Absolute_0123 ;$0123
    JSR Label_125 ;$866F
Label_137 ;$8791
    PLA
    TAY
    PLA
    TAX
    RTS

    STA Absolute_013E ;$013E
    STA Absolute_0141 ;$0141
    LDA #$00
    STA Absolute_013C ;$013C
    RTS

Label_138 ;$87A2
    STA Absolute_0122 ;$0122
    CMP #$82
    BCC Label_139 ;$87AA
    RTS

Label_139 ;$87AA
    CMP #$7F
    BCC Label_140 ;$87B1
    JMP Label_160 ;$88DA

Label_140 ;$87B1
    LDA Absolute_0107 ;$0107
    CMP #$62
    BNE Label_141 ;$87C0
    LDA Absolute_0122 ;$0122
    CMP #$0B
    BEQ Label_141 ;$87C0
    RTS

Label_141 ;$87C0
    LDA Absolute_0122 ;$0122
    CMP #$77
    BNE Label_142 ;$87CD
    JSR Label_134 ;$8719
    JMP Label_147 ;$87FA

Label_142 ;$87CD
    CMP #$62
    BNE Label_144 ;$87DE
    LDA Absolute_0107 ;$0107
    CMP #$77
    BNE Label_143 ;$87D9
    RTS

Label_143 ;$87D9
    CMP #$62
    BNE Label_144 ;$87DE
    RTS

Label_144 ;$87DE
    CMP #$46
    BEQ Label_145 ;$87EA
    CMP #$4A
    BEQ Label_145 ;$87EA
    CMP #$07
    BNE Label_147 ;$87FA
Label_145 ;$87EA
    LDA Absolute_0135 ;$0135
Label_146 ;$87ED
    STA $4011 ;$4011
    SEC
    SBC #$01
    BPL Label_146 ;$87ED
    LDA #$00
    STA $4011 ;$4011
Label_147 ;$87FA
    CMP #$18
    BNE Label_148 ;$8806
    LDA Absolute_010A ;$010A
    CMP #$16
    BNE Label_148 ;$8806
    RTS

Label_148 ;$8806
    TXA
    PHA
    TYA
    PHA
    LDA Label_133 ;$8717
    STA <Zero_EC
    LDA Label_133 + 1 ;$8718
    STA <Zero_ED
    LDA #$03
    STA <Zero_EA
Label_149 ;$8818
    LDA Absolute_0122 ;$0122
    CLC
    ADC <Zero_EC
    STA <Zero_EC
    LDA #$00
    ADC <Zero_ED
    STA <Zero_ED
    DEC <Zero_EA
    BNE Label_149 ;$8818
    LDY #$00
    STY <Zero_EB
    LDA [Zero_EC],Y ;$882E
    LSR A
    LSR A
    LSR A
    AND #$03
    STA <Zero_EA
Label_150 ;$8837
    LDA <Zero_EB
    ASL A
    CLC
    ADC <Zero_EB
    TAY
    LDA [Zero_EC],Y ;$883E
    AND #$07
    TAX
    LDA Absolute_0122 ;$0122
    CMP Absolute_0106,X ;$0106
    BCC Label_157 ;$88C0
    LDA #$00
    STA Absolute_0106,X ;$0106
    INY
    LDA [Zero_EC],Y ;$8851
    STA Absolute_0112,X ;$0112
    STA <Zero_E8
    INY
    LDA [Zero_EC],Y ;$8859
    STA Absolute_0118,X ;$0118
    STA <Zero_E9
    LDA #$F8
    STA Absolute_010C,X ;$010C
    LDA #$01
    STA Absolute_0100,X ;$0100
    CPX #$03
    BCS Label_152 ;$887C
    CPX #$02
    BEQ Label_151 ;$8877
    LDA #$80
    STA Absolute_0178,X ;$0178
Label_151 ;$8877
    LDA #$00
    STA Absolute_0132,X ;$0132
Label_152 ;$887C
    LDA #$00
    STA Absolute_0148,X ;$0148
    TAY
    LDA [Zero_E8],Y ;$8882
    INY
    CMP #$30
    BCC Label_153 ;$8890
    DEY
    STY Absolute_013E ;$013E
    STY Absolute_013C ;$013C
Label_153 ;$8890
    TYA
    STA Absolute_0124,X ;$0124
    LDA Absolute_0122 ;$0122
    STA Absolute_0106,X ;$0106
    TXA
    CMP #$01
    BCC Label_159 ;$88CE
    CPX #$05
    BNE Label_154 ;$88A8
    LDA #$0C
    JMP Label_155 ;$88AC

Label_154 ;$88A8
    ASL A
    ASL A
    AND #$0F
Label_155 ;$88AC
    TAX
    LDA #$00
    CPX #$08
    BEQ Label_156 ;$88B5
    LDA #$30
Label_156 ;$88B5
    STA $4000,X ;$4000
    JSR sound_delay ;$870C
    LDA #$7F
    STA $4001,X ;$4001
Label_157 ;$88C0
    INC <Zero_EB
    DEC <Zero_EA
    BPL Label_158 ;$88CB
    PLA
    TAY
    PLA
    TAX
    RTS

Label_158 ;$88CB
    JMP Label_150 ;$8837

Label_159 ;$88CE
    ORA #$04
    TAY
    LDA Absolute_0106,Y ;$0106
    BNE Label_157 ;$88C0
    TXA
    JMP Label_154 ;$88A8

Label_160 ;$88DA
    SEC
    SBC #$7F
    STA Absolute_0122 ;$0122
    TYA
    PHA
    LDA Absolute_0122 ;$0122
    ASL A
    ASL A
    TAY
    LDA Label_161 + 1,Y ;$8914
    STA Absolute_0135 ;$0135
    LDA #$0F
    STA $4015 ;$4015
    LDA Label_161,Y ;$8913
    STA $4010 ;$4010
    LDA Label_161 + 1,Y ;$8914
    STA $4011 ;$4011
    LDA Label_161 + 2,Y ;$8915
	CLC
	ADC #(DMC_Data-$C000)/$40
    STA $4012 ;$4012
    LDA Label_161 + 3,Y ;$8916
    STA $4013 ;$4013
    LDA #$1F
    STA $4015 ;$4015
    PLA
    TAY
    RTS

bank_id ;$8000
    .DB $12
data_index ;$8001
    .DW Label_561 ;$9B21
    .DW Label_562 ;$9B29
    .DW Label_563 ;$9B2E
    .DW Label_564 ;$9B3B
    .DW Label_565 ;$9B48
    .DW Label_566 ;$9B5A
    .DW Label_567 ;$9B6D
    .DW Label_568 ;$9B80
    .DW Label_865 ;$AD1F
    .DW Label_866 ;$AD2C
    .DW Label_867 ;$AD32
    .DW Label_868 ;$AD39
    .DW Label_869 ;$AD46
    .DW Label_870 ;$AD53
    .DW Label_958 ;$B04A
    .DW Label_978 ;$B3A3
    .DW Label_979 ;$B3B0
    .DW Label_980 ;$B3B7
    .DW Label_991 ;$B490
    .DW Label_992 ;$B49D
    .DW Label_993 ;$B4AA
    .DW Label_994 ;$B4B5
    .DW Label_981 ;$B3BC
    .DW Label_608 ;$A20E
    .DW Label_609 ;$A219
    .DW Label_610 ;$A22E
    .DW Label_611 ;$A235
    .DW Label_612 ;$A241
    .DW Label_613 ;$A248
    .DW Label_614 ;$A24D
    .DW Label_615 ;$A259
    .DW Label_616 ;$A260
    .DW Label_617 ;$A26C
    .DW Label_747 ;$A7B5
    .DW Label_748 ;$A7C1
    .DW Label_666 ;$A587
    .DW Label_667 ;$A594
    .DW Label_668 ;$A59D
    .DW Label_669 ;$A5A9
    .DW Label_802 ;$A9A8
    .DW Label_803 ;$A9B6
    .DW Label_804 ;$A9C4
    .DW Label_805 ;$A9CC
    .DW Label_749 ;$A7C8
    .DW Label_750 ;$A7D4
    .DW Label_751 ;$A7E0
    .DW Label_959 ;$B057
    .DW Label_960 ;$B05F
    .DW Label_961 ;$B06C
    .DW Label_999 ;$B55E
    .DW Label_1000 ;$B567
    .DW Label_1001 ;$B577
    .DW Label_1002 ;$B578
    .DW Label_982 ;$B3C9
	
Label_133 ;$8717
    .DW Label_162 ;$8920
	
Label_53 ;$82CD
    .DB $02,$7F,$80,$7F,$80,$3E,$81,$82
program_play_index1 ;$86C6
    .DW Label_122 ;$8651
    .DW Label_122 ;$8651
    .DW Label_124 ;$865F
    .DW Label_126 ;$8692
    .DW Label_125 ;$866F
    .DW Label_126 ;$8692
    .DW Label_122 ;$8651
program_play_index2 ;$86D4
    .DW Label_93 ;$8500
    .DW Label_96 ;$8522
    .DW Label_99 ;$855C
    .DW Label_86 ;$84A2
Label_131 ;$86DC
    .DB $AE,$06,$4E,$06,$F4,$05,$9E,$05,$4E,$05,$01,$05,$B9,$04,$76,$04
    .DB $36,$04,$F9,$03,$C0,$03,$8A,$03,$57,$03,$27,$03,$FA,$02,$CF,$02
    .DB $A7,$02,$81,$02,$5D,$02,$3B,$02,$1B,$02,$FD,$01,$E0,$01,$C5,$01
	
Label_1051 ;$BBA0
    .DB $3F,$43,$46,$5A,$4A,$4E,$52,$56,$5E,$62,$66,$6E,$6A,$77,$3A,$0B
    .DB $0D,$0E,$10,$13,$1A,$1E,$20,$24,$26,$28,$19,$2A,$2C,$2E,$2F,$2B
    .DB $33,$34,$30,$31,$37,$38,$39,$3D,$3E,$75,$72,$74
Init_Addr ;$BBF0
    TAX
    LDA Label_1051,X ;$BBA0
    JMP Label_138 ;$87A2
	
 .BANK32 MUSIC_DATA_BANK
	.ORG MUSIC_DATA_ADDR
	
Label_161 ;$8913
    .DB $0F,$2F,$00,$05,$0F,$75,$03,$25,$0F,$7F,$03,$03,$0F
Label_162 ;$8920
    .DB $00,$03,$25,$03,$CB,$8A,$05
Label_163 ;$8927
    .DW Label_373 ;$8AA9
Label_164 ;$8929
    .DB $18,$47,$92,$01,$47,$92,$02,$56,$92,$05,$61,$92,$18,$68,$92,$01
    .DB $68,$92,$02,$C4,$92,$05,$91,$92,$0C
Label_165 ;$8942
    .DW Label_375 ;$8ACC
Label_166 ;$8944
    .DB $05
Label_167 ;$8945
    .DW Label_376 ;$8ADD
Label_168 ;$8947
    .DB $04
Label_169 ;$8948
    .DW Label_377 ;$8AE8
Label_170 ;$894A
    .DB $0C
Label_171 ;$894B
    .DW Label_378 ;$8B1F
Label_172 ;$894D
    .DB $05
Label_173 ;$894E
    .DW Label_379 ;$8B29
Label_174 ;$8950
    .DB $14
Label_175 ;$8951
    .DW Label_380 ;$8B37
Label_176 ;$8953
    .DB $01
Label_177 ;$8954
    .DW Label_381 ;$8B41
Label_178 ;$8956
    .DB $05
Label_179 ;$8957
    .DW Label_382 ;$8B48
Label_180 ;$8959
    .DB $04
Label_181 ;$895A
    .DW Label_383 ;$8B56
Label_182 ;$895C
    .DB $0C,$AE,$8B,$01,$EA,$8B,$0C,$22,$8C,$01,$59,$8C,$00,$95,$8B,$05
Label_183 ;$896C
    .DW Label_425 ;$8F26
Label_184 ;$896E
    .DB $0C
Label_185 ;$896F
    .DW Label_384 ;$8C90
Label_186 ;$8971
    .DB $05
Label_187 ;$8972
    .DW Label_385 ;$8CB9
Label_188 ;$8974
    .DB $0C,$E2,$8C,$05,$0F,$8D,$0C
Label_189 ;$897B
    .DW Label_388 ;$8D36
Label_190 ;$897D
    .DB $05
Label_191 ;$897E
    .DW Label_391 ;$8D63
Label_192 ;$8980
    .DB $1C
Label_193 ;$8981
    .DW Label_394 ;$8D8A
Label_194 ;$8983
    .DB $01
Label_195 ;$8984
    .DW Label_400 ;$8DA1
Label_196 ;$8986
    .DB $03
Label_197 ;$8987
    .DW Label_406 ;$8DB5
Label_198 ;$8989
    .DB $05
Label_199 ;$898A
    .DW Label_410 ;$8DBC
Label_200 ;$898C
    .DB $0C
Label_201 ;$898D
    .DW Label_415 ;$8DFE
Label_202 ;$898F
    .DB $05
Label_203 ;$8990
    .DW Label_416 ;$8E35
Label_204 ;$8992
    .DB $0C
Label_205 ;$8993
    .DW Label_417 ;$8E98
Label_206 ;$8995
    .DB $05
Label_207 ;$8996
    .DW Label_420 ;$8EAC
Label_208 ;$8998
    .DB $0C
Label_209 ;$8999
    .DW Label_423 ;$8EBE
Label_210 ;$899B
    .DB $05
Label_211 ;$899C
    .DW Label_424 ;$8ECC
Label_212 ;$899E
    .DB $04
Label_213 ;$899F
    .DW Label_426 ;$8F5F
Label_214 ;$89A1
    .DB $04
Label_215 ;$89A2
    .DW Label_433 ;$8FEE
Label_216 ;$89A4
    .DB $0C
Label_217 ;$89A5
    .DW Label_429 ;$8F79
Label_218 ;$89A7
    .DB $05
Label_219 ;$89A8
    .DW Label_430 ;$8F9C
Label_220 ;$89AA
    .DB $04
Label_221 ;$89AB
    .DW Label_431 ;$8FC1
Label_222 ;$89AD
    .DB $04
Label_223 ;$89AE
    .DW Label_432 ;$8FD8
Label_224 ;$89B0
    .DB $04
Label_225 ;$89B1
    .DW Label_445 ;$9082
Label_226 ;$89B3
    .DB $0C
Label_227 ;$89B4
    .DW Label_446 ;$90D4
Label_228 ;$89B6
    .DB $05
Label_229 ;$89B7
    .DW Label_449 ;$914E
Label_230 ;$89B9
    .DB $04
Label_231 ;$89BA
    .DW Label_434 ;$901B
Label_232 ;$89BC
    .DB $0C
Label_233 ;$89BD
    .DW Label_454 ;$9209
Label_234 ;$89BF
    .DB $05
Label_235 ;$89C0
    .DW Label_457 ;$922A
Label_236 ;$89C2
    .DB $04,$77,$91,$04
Label_237 ;$89C6
    .DW Label_450 ;$918F
Label_238 ;$89C8
    .DB $04
Label_239 ;$89C9
    .DW Label_452 ;$91AA
Label_240 ;$89CB
    .DB $04
Label_241 ;$89CC
    .DW Label_453 ;$91C1
Label_242 ;$89CE
    .DB $14
Label_243 ;$89CF
    .DW Label_460 ;$9657
Label_244 ;$89D1
    .DB $01
Label_245 ;$89D2
    .DW Label_460 ;$9657
Label_246 ;$89D4
    .DB $05
Label_247 ;$89D5
    .DW Label_488 ;$9716
Label_248 ;$89D7
    .DB $05
Label_249 ;$89D8
    .DW Label_504 ;$9755
Label_250 ;$89DA
    .DB $05
Label_251 ;$89DB
    .DW Label_507 ;$9794
Label_252 ;$89DD
    .DB $18
Label_253 ;$89DE
    .DW Label_522 ;$9971
Label_254 ;$89E0
    .DB $01
Label_255 ;$89E1
    .DW Label_523 ;$9987
Label_256 ;$89E3
    .DB $02
Label_257 ;$89E4
    .DW Label_524 ;$999F
Label_258 ;$89E6
    .DB $03
Label_259 ;$89E7
    .DW Label_525 ;$99AF
Label_260 ;$89E9
    .DB $10
Label_261 ;$89EA
    .DW Label_535 ;$99EF
Label_262 ;$89EC
    .DB $01
Label_263 ;$89ED
    .DW Label_546 ;$9A61
Label_264 ;$89EF
    .DB $02
Label_265 ;$89F0
    .DW Label_557 ;$9AE2
Label_266 ;$89F2
    .DB $18
Label_267 ;$89F3
    .DW Label_574 ;$9D6C
Label_268 ;$89F5
    .DB $01
Label_269 ;$89F6
    .DW Label_569 ;$9B92
Label_270 ;$89F8
    .DB $02
Label_271 ;$89F9
    .DW Label_579 ;$9F0B
Label_272 ;$89FB
    .DB $03
Label_273 ;$89FC
    .DW Label_589 ;$A0B9
Label_274 ;$89FE
    .DB $18
Label_275 ;$89FF
    .DW Label_621 ;$A2C9
Label_276 ;$8A01
    .DB $01
Label_277 ;$8A02
    .DW Label_631 ;$A3B5
Label_278 ;$8A04
    .DB $02
Label_279 ;$8A05
    .DW Label_646 ;$A4AB
Label_280 ;$8A07
    .DB $03
Label_281 ;$8A08
    .DW Label_657 ;$A512
Label_282 ;$8A0A
    .DB $18
Label_283 ;$8A0B
    .DW Label_674 ;$A5E8
Label_284 ;$8A0D
    .DB $01
Label_285 ;$8A0E
    .DW Label_691 ;$A676
Label_286 ;$8A10
    .DB $02
Label_287 ;$8A11
    .DW Label_706 ;$A6DE
Label_288 ;$8A13
    .DB $03
Label_289 ;$8A14
    .DW Label_730 ;$A762
Label_290 ;$8A16
    .DB $18
Label_291 ;$8A17
    .DW Label_752 ;$A7EC
Label_292 ;$8A19
    .DB $01
Label_293 ;$8A1A
    .DW Label_760 ;$A88A
Label_294 ;$8A1C
    .DB $02
Label_295 ;$8A1D
    .DW Label_771 ;$A8FC
Label_296 ;$8A1F
    .DB $03
Label_297 ;$8A20
    .DW Label_785 ;$A947
Label_298 ;$8A22
    .DB $18
Label_299 ;$8A23
    .DW Label_806 ;$A9D6
Label_300 ;$8A25
    .DB $01
Label_301 ;$8A26
    .DW Label_829 ;$AAEB
Label_302 ;$8A28
    .DB $02
Label_303 ;$8A29
    .DW Label_836 ;$ABD9
Label_304 ;$8A2B
    .DB $03
Label_305 ;$8A2C
    .DW Label_852 ;$AC73
Label_306 ;$8A2E
    .DB $18
Label_307 ;$8A2F
    .DW Label_877 ;$ADAC
Label_308 ;$8A31
    .DB $01
Label_309 ;$8A32
    .DW Label_899 ;$AEB4
Label_310 ;$8A34
    .DB $02
Label_311 ;$8A35
    .DW Label_915 ;$AF2F
Label_312 ;$8A37
    .DB $03
Label_313 ;$8A38
    .DW Label_935 ;$AFBE
Label_314 ;$8A3A
    .DB $18
Label_315 ;$8A3B
    .DW Label_969 ;$B0D7
Label_316 ;$8A3D
    .DB $01
Label_317 ;$8A3E
    .DW Label_970 ;$B1BC
Label_318 ;$8A40
    .DB $02
Label_319 ;$8A41
    .DW Label_973 ;$B23F
Label_320 ;$8A43
    .DB $03
Label_321 ;$8A44
    .DW Label_975 ;$B352
Label_322 ;$8A46
    .DB $18
Label_323 ;$8A47
    .DW Label_983 ;$B3D6
Label_324 ;$8A49
    .DB $01
Label_325 ;$8A4A
    .DW Label_984 ;$B3F7
Label_326 ;$8A4C
    .DB $02
Label_327 ;$8A4D
    .DW Label_985 ;$B418
Label_328 ;$8A4F
    .DB $03
Label_329 ;$8A50
    .DW Label_986 ;$B433
Label_330 ;$8A52
    .DB $18
Label_331 ;$8A53
    .DW Label_987 ;$B448
Label_332 ;$8A55
    .DB $01
Label_333 ;$8A56
    .DW Label_988 ;$B45E
Label_334 ;$8A58
    .DB $02
Label_335 ;$8A59
    .DW Label_989 ;$B475
Label_336 ;$8A5B
    .DB $03
Label_337 ;$8A5C
    .DW Label_990 ;$B485
Label_338 ;$8A5E
    .DB $18
Label_339 ;$8A5F
    .DW Label_1004 ;$B62C
Label_340 ;$8A61
    .DB $01
Label_341 ;$8A62
    .DW Label_1010 ;$B6A7
Label_342 ;$8A64
    .DB $02
Label_343 ;$8A65
    .DW Label_1026 ;$B792
Label_344 ;$8A67
    .DB $03
Label_345 ;$8A68
    .DW Label_1046 ;$B814
Label_346 ;$8A6A
    .DB $18
Label_347 ;$8A6B
    .DW Label_995 ;$B4C0
Label_348 ;$8A6D
    .DB $01
Label_349 ;$8A6E
    .DW Label_996 ;$B4E8
Label_350 ;$8A70
    .DB $02
Label_351 ;$8A71
    .DW Label_997 ;$B512
Label_352 ;$8A73
    .DB $03
Label_353 ;$8A74
    .DW Label_998 ;$B53E
Label_354 ;$8A76
    .DB $0C
Label_355 ;$8A77
    .DW Label_520 ;$98F3
Label_356 ;$8A79
    .DB $05
Label_357 ;$8A7A
    .DW Label_521 ;$9946
Label_358 ;$8A7C
    .DB $04
Label_359 ;$8A7D
    .DW Label_374 ;$8AB1
Label_360 ;$8A7F
    .DB $0C
Label_361 ;$8A80
    .DW Label_510 ;$97CF
Label_362 ;$8A82
    .DB $05
Label_363 ;$8A83
    .DW Label_511 ;$97E8
Label_364 ;$8A85
    .DB $1C
Label_365 ;$8A86
    .DW Label_514 ;$9827
Label_366 ;$8A88
    .DB $01
Label_367 ;$8A89
    .DW Label_515 ;$986F
Label_368 ;$8A8B
    .DB $03
Label_369 ;$8A8C
    .DW Label_516 ;$98B3
Label_370 ;$8A8E
    .DB $05
Label_371 ;$8A8F
    .DW Label_517 ;$98B8
Label_372 ;$8A91
    .DB $1C,$27,$98,$01,$6F,$98,$03,$B3,$98,$05,$B8,$98,$03,$CB,$8A,$03
    .DB $CB,$8A,$03,$CB,$8A,$03,$CB,$8A
Label_373 ;$8AA9
    .DB $21,$33,$60,$03,$F8,$20,$02,$FF
Label_374 ;$8AB1
    .DB $25,$82,$00,$D5,$00,$8E,$00,$A9,$22,$B0,$E0,$6A,$D0,$6A,$B0,$6A
    .DB $A0,$6A,$90,$6A,$70,$6A,$50,$6A,$40,$6A,$FF
Label_375 ;$8ACC
    .DB $21,$30,$40,$F0,$00,$00,$00,$00,$21,$F0,$F8,$20,$0A,$F8,$10,$0B
    .DB $FF
Label_376 ;$8ADD
    .DB $21,$0F,$A0,$0C,$00,$00,$23,$30,$30,$02,$FF
Label_377 ;$8AE8
    .DB $21,$70,$10,$83,$F3,$8C,$F2,$F6,$F3,$15,$73,$77,$D3,$8C,$00,$00
    .DB $D3,$15,$00,$00,$D3,$8C,$B3,$45,$33,$11,$B3,$50,$73,$33,$B4,$00
    .DB $00,$00,$B2,$DD,$00,$00,$00,$00,$A3,$50,$00,$00,$73,$22,$00,$00
    .DB $53,$50,$00,$00,$32,$EE,$FF
Label_378 ;$8B1F
    .DB $26,$30,$10,$99,$40,$A9,$F8,$10,$A9,$FF
Label_379 ;$8B29
    .DB $21,$30,$F0,$07,$90,$02,$70,$07,$50,$02,$F8,$20,$02,$FF
Label_380 ;$8B37
    .DB $26,$30,$10,$B9,$30,$B0,$F8,$10,$B0,$FF
Label_381 ;$8B41
    .DB $26,$F0,$10,$89,$30,$B0,$FF
Label_382 ;$8B48
    .DB $21,$30,$F0,$07,$90,$02,$70,$07,$50,$02,$F8,$20,$02,$FF
Label_383 ;$8B56
    .DB $21,$30,$10,$8A,$F8,$21,$02,$30,$F1,$40,$E0,$50,$D0,$60,$C1,$60
    .DB $B2,$60,$A3,$60,$95,$60,$87,$60,$79,$60,$6B,$60,$5E,$60,$51,$70
    .DB $4E,$80,$4B,$90,$49,$A0,$46,$F8,$10,$79,$F8,$10,$6B,$F8,$10,$5E
    .DB $F8,$10,$51,$F8,$10,$4E,$F8,$20,$4B,$F8,$20,$49,$30,$46,$FF,$24
    .DB $30,$60,$B4,$00,$00,$60,$D6,$F8,$20,$B4,$00,$00,$F8,$20,$D6,$F8
    .DB $10,$B4,$00,$00,$F8,$10,$D6,$FF,$29,$B0,$00,$00,$21,$B0,$F8,$12
    .DB $C0,$F8,$22,$91,$32,$68,$42,$40,$52,$20,$52,$00,$51,$E8,$51,$D0
    .DB $51,$C0,$51,$B4,$2F,$B0,$51,$B0,$51,$B0,$51,$B0,$51,$B0,$26,$B0
    .DB $51,$B0,$51,$B0,$41,$B0,$31,$B0,$31,$B0,$F8,$21,$B0,$F8,$11,$B0
    .DB $FE,$FF,$B2,$8B,$21,$B0,$F8,$12,$C0,$F8,$22,$91,$32,$68,$42,$40
    .DB $52,$20,$52,$00,$51,$E8,$51,$D0,$51,$C0,$51,$B4,$2F,$B0,$51,$AB
    .DB $51,$AB,$51,$AB,$51,$AB,$26,$B0,$51,$AB,$51,$AB,$41,$AB,$31,$AB
    .DB $31,$AB,$F8,$21,$AB,$F8,$11,$AB,$FE,$FF,$EA,$8B,$23,$B0,$B1,$00
    .DB $00,$00,$B0,$80,$00,$00,$B0,$40,$51,$00,$B0,$20,$50,$80,$00,$00
    .DB $50,$40,$F8,$21,$00,$50,$20,$F8,$20,$80,$00,$00,$F8,$20,$40,$F8
    .DB $11,$00,$F8,$20,$20,$F8,$10,$80,$00,$00,$F8,$10,$40,$00,$00,$F8
    .DB $10,$20,$FF,$23,$B0,$B1,$80,$00,$00,$B0,$C0,$00,$00,$B0,$60,$51
    .DB $80,$B0,$30,$50,$C0,$00,$00,$50,$60,$F8,$21,$80,$50,$30,$F8,$20
    .DB $C0,$00,$00,$F8,$20,$60,$F8,$11,$80,$F8,$20,$30,$F8,$10,$C0,$00
    .DB $00,$F8,$10,$60,$00,$00,$F8,$10,$30,$FF
Label_384 ;$8C90
    .DB $25,$70,$10,$83,$D2,$86,$B0,$C0,$21,$F0,$A0,$09,$25,$70,$60,$F2
    .DB $21,$F0,$A0,$0A,$25,$70,$51,$2B,$41,$76,$31,$D3,$F8,$22,$44,$F8
    .DB $12,$DD,$F8,$13,$99,$F8,$14,$7E,$FF
Label_385 ;$8CB9
    .DB $21,$30,$F0,$09,$D0,$0E,$F8,$20,$0A,$F8,$20,$09,$00,$00,$FE,$02
Label_386 ;$8CC9
    .DW Label_385 ;$8CB9
Label_387 ;$8CCB
    .DB $23,$30,$70,$0B,$F8,$20,$0E,$30,$0E,$F8,$20,$0B,$00,$00,$30,$0A
    .DB $F8,$20,$0D,$F8,$10,$0B,$FF,$21,$F0,$10,$83,$C2,$3B,$81,$0D,$71
    .DB $C5,$C0,$08,$FE,$02,$E2,$8C,$25,$F0,$60,$F2,$21,$F0,$B0,$08,$25
    .DB $F0,$51,$2B,$41,$76,$31,$D3,$F8,$22,$44,$F8,$12,$DD,$F8,$13,$99
    .DB $F8,$14,$7E,$FF,$21,$30,$F0,$09,$D0,$0E,$F8,$20,$0A,$F8,$10,$09
    .DB $FE,$02,$0F,$8D,$23,$30,$70,$0B,$F8,$20,$0E,$30,$0E,$F8,$20,$0B
    .DB $00,$00,$30,$0A,$F8,$20,$0D,$F8,$10,$0B,$FF
Label_388 ;$8D36
    .DB $21,$F0,$10,$83,$C2,$3B,$81,$0D,$71,$C5,$C0,$08,$FE,$0A
Label_389 ;$8D44
    .DW Label_388 ;$8D36
Label_390 ;$8D46
    .DB $25,$F0,$60,$F2,$21,$F0,$B0,$08,$25,$F0,$51,$2B,$41,$76,$31,$D3
    .DB $F8,$22,$44,$F8,$12,$DD,$F8,$13,$99,$F8,$14,$7E,$FF
Label_391 ;$8D63
    .DB $21,$30,$F0,$09,$D0,$0E,$F8,$20,$0A,$F8,$10,$09,$FE,$0A
Label_392 ;$8D71
    .DW Label_391 ;$8D63
Label_393 ;$8D73
    .DB $23,$30,$70,$0B,$F8,$20,$0E,$30,$0E,$F8,$20,$0B,$00,$00,$30,$0A
    .DB $F8,$20,$0D,$F8,$10,$0B,$FF
Label_394 ;$8D8A
    .DB $21,$30,$10,$83,$00,$00
Label_395 ;$8D90
    .DB $F1,$3B,$31,$0D,$F8,$21,$C5,$00,$00,$FE,$30
Label_396 ;$8D9B
    .DW Label_395 ;$8D90
Label_397 ;$8D9D
    .DB $FD
Label_398 ;$8D9E
    .DW Label_414 ;$8DE3
Label_399 ;$8DA0
    .DB $FF
Label_400 ;$8DA1
    .DB $21,$F0,$10,$83
Label_401 ;$8DA5
    .DB $F2,$3B,$61,$0D,$51,$C5,$C0,$09,$FE,$30
Label_402 ;$8DAF
    .DW Label_401 ;$8DA5
Label_403 ;$8DB1
    .DB $FD
Label_404 ;$8DB2
    .DW Label_414 ;$8DE3
Label_405 ;$8DB4
    .DB $FF
Label_406 ;$8DB5
    .DB $D4
Label_407 ;$8DB6
    .DB $60,$FE,$30
Label_408 ;$8DB9
    .DW Label_407 ;$8DB6
Label_409 ;$8DBB
    .DB $FF
Label_410 ;$8DBC
    .DB $21,$30
Label_411 ;$8DBE
    .DB $F0,$08,$A0,$0B,$F8,$20,$0A,$F8,$10,$09,$FE,$30
Label_412 ;$8DCA
    .DW Label_411 ;$8DBE
Label_413 ;$8DCC
    .DB $23,$30,$70,$0B,$F8,$20,$0E,$30,$0E,$F8,$20,$0B,$00,$00,$30,$0A
    .DB $F8,$20,$0D,$F8,$10,$0B,$FF
Label_414 ;$8DE3
    .DB $25,$F0,$60,$F2,$21,$F0,$B0,$08,$25,$F0,$71,$2B,$61,$76,$51,$D3
    .DB $42,$44,$32,$DD,$F8,$23,$99,$F8,$14,$7E,$FF
Label_415 ;$8DFE
    .DB $22,$30,$10,$83,$30,$39,$40,$40,$50,$47,$60,$50,$70,$5A,$80,$65
    .DB $90,$71,$A0,$7F,$A0,$8F,$90,$A0,$90,$B4,$80,$CA,$80,$E2,$80,$FE
    .DB $81,$1D,$71,$40,$71,$68,$61,$94,$61,$C5,$61,$FC,$62,$36,$62,$81
    .DB $52,$CF,$53,$27,$53,$8A,$FF
Label_416 ;$8E35
    .DB $21,$30,$30,$0B,$40,$0A,$50,$09,$60,$08,$70,$07,$70,$06,$80,$06
    .DB $80,$06,$80,$06,$80,$06,$80,$06,$80,$06,$80,$07,$80,$06,$80,$07
    .DB $80,$07,$80,$08,$80,$07,$80,$08,$80,$08,$80,$09,$80,$08,$80,$09
    .DB $80,$09,$80,$0A,$70,$09,$70,$0A,$70,$0A,$70,$0B,$70,$0A,$70,$0B
    .DB $70,$0B,$70,$0C,$70,$0B,$70,$0C,$70,$0C,$60,$0D,$60,$0C,$60,$0D
    .DB $60,$0D,$50,$0E,$50,$0D,$50,$0E,$50,$0E,$50,$0E,$50,$0E,$40,$0E
    .DB $40,$0E,$FF
Label_417 ;$8E98
    .DB $23,$F0,$10,$82,$B0,$35,$90,$50,$70,$78,$FE,$03
Label_418 ;$8EA4
    .DW Label_417 ;$8E98
Label_419 ;$8EA6
    .DB $30,$B4,$F8,$21,$0D,$FF
Label_420 ;$8EAC
    .DB $23,$30,$40,$06,$50,$08,$60,$0A,$FE,$03
Label_421 ;$8EB6
    .DW Label_420 ;$8EAC
Label_422 ;$8EB8
    .DB $30,$0C,$F8,$10,$0D,$FF
Label_423 ;$8EBE
    .DB $2A,$30,$10,$8B,$B2,$66,$72,$66,$32,$66,$F8,$12,$66,$FF
Label_424 ;$8ECC
    .DB $21,$30,$B0,$0E,$B0,$0D,$B0,$0C,$B0,$0B,$B0,$0A,$B0,$09,$B0,$08
    .DB $B0,$07,$B0,$06,$B0,$05,$70,$0E,$70,$0D,$70,$0C,$70,$0B,$70,$0A
    .DB $70,$09,$70,$08,$70,$07,$70,$06,$70,$05,$30,$0E,$30,$0D,$30,$0C
    .DB $30,$0B,$30,$0A,$30,$09,$30,$08,$30,$07,$30,$06,$30,$05,$F8,$10
    .DB $0E,$F8,$10,$0D,$F8,$10,$0C,$F8,$10,$0B,$F8,$10,$0A,$F8,$10,$09
    .DB $F8,$10,$08,$F8,$10,$07,$F8,$10,$06,$FF
Label_425 ;$8F26
    .DB $22,$30,$F0,$0E,$F0,$0D,$F0,$0C,$A0,$07,$A0,$08,$B0,$09,$C0,$0A
    .DB $C0,$0B,$C0,$0C,$C0,$0D,$23,$30,$F0,$0E,$E0,$0E,$D0,$0E,$C0,$0E
    .DB $B0,$0E,$A0,$0E,$90,$0E,$80,$0E,$70,$0E,$60,$0E,$50,$0E,$40,$0E
    .DB $30,$0E,$F8,$20,$0E,$F8,$10,$0E,$FF
Label_426 ;$8F5F
    .DB $21,$30,$90,$20,$C0,$08,$60,$80,$FE,$02
Label_427 ;$8F69
    .DW Label_426 ;$8F5F
Label_428 ;$8F6B
    .DB $30,$20,$24,$30,$30,$80,$30,$20,$50,$08,$F8,$10,$80,$FF
Label_429 ;$8F79
    .DB $23,$F0,$10,$82,$B0,$33,$22,$30,$10,$8E,$B0,$66,$70,$5A,$50,$50
    .DB $40,$48,$30,$40,$30,$3F,$F8,$20,$3F,$F8,$20,$3F,$F8,$10,$3F,$F8
    .DB $10,$3F,$FF
Label_430 ;$8F9C
    .DB $21,$30,$D0,$0B,$50,$0A,$30,$09,$70,$0A,$50,$09,$50,$09,$40,$0A
    .DB $40,$0B,$30,$0B,$40,$0B,$30,$0B,$F8,$20,$0B,$F8,$20,$0B,$F8,$10
    .DB $0B,$F8,$10,$0A,$FF
Label_431 ;$8FC1
    .DB $21,$30,$10,$81,$F0,$59,$24,$F0,$10,$82,$F0,$FE,$C0,$35,$90,$59
    .DB $70,$D5,$51,$59,$31,$7F,$FF
Label_432 ;$8FD8
    .DB $28,$B0,$10,$83,$F1,$0D,$28,$F0,$10,$82,$F0,$FE,$C0,$D5,$50,$B3
    .DB $30,$A0,$F8,$10,$A0,$FF
Label_433 ;$8FEE
    .DB $23,$B0,$10,$82,$F2,$70,$00,$00,$23,$B0,$F1,$AB,$F1,$67,$E1,$AB
    .DB $D1,$67,$C1,$AB,$B1,$67,$A1,$AB,$91,$67,$81,$AB,$71,$67,$61,$AB
    .DB $51,$67,$41,$AB,$31,$67,$F8,$21,$AB,$F8,$11,$67,$FF
Label_434 ;$901B
    .DB $21,$B0,$00,$00,$FD
Label_435 ;$9020
    .DW Label_441 ;$9029
Label_436 ;$9022
    .DB $FD
Label_437 ;$9023
    .DW Label_441 ;$9029
Label_438 ;$9025
    .DB $FD
Label_439 ;$9026
    .DW Label_441 ;$9029
Label_440 ;$9028
    .DB $FF
Label_441 ;$9029
    .DB $21,$F0,$10,$85,$F8,$12,$D7,$F8,$22,$B7,$32,$97,$42,$77,$52,$57
    .DB $62,$37,$72,$17,$81,$F7,$91,$D7,$A1,$B7,$B1,$97,$C1,$77,$D1,$57
    .DB $D1,$47,$D1,$3F,$D1,$3B,$D1,$37,$10,$86
Label_442 ;$9053
    .DB $E1,$3A,$A1,$3B,$FE,$0C
Label_443 ;$9059
    .DW Label_442 ;$9053
Label_444 ;$905B
    .DB $B1,$37,$B1,$37,$A1,$37,$A1,$37,$51,$37,$24,$F0,$10,$82,$B1,$37
    .DB $B1,$37,$71,$37,$71,$37,$31,$37,$31,$37,$F8,$11,$37,$F8,$11,$37
    .DB $F8,$11,$37,$F8,$11,$37,$FF
Label_445 ;$9082
    .DB $23,$F0,$F8,$10,$1F,$F8,$20,$20,$30,$21,$40,$22,$50,$23,$60,$24
    .DB $70,$25,$80,$26,$90,$27,$A0,$28,$A0,$29,$A0,$2A,$90,$2B,$90,$2C
    .DB $90,$2D,$80,$2E,$80,$2F,$80,$30,$70,$31,$70,$32,$70,$33,$60,$34
    .DB $60,$35,$60,$36,$50,$37,$50,$38,$50,$39,$40,$3A,$40,$3B,$40,$3C
    .DB $30,$3D,$30,$3E,$30,$3F,$30,$40,$F8,$20,$41,$F8,$20,$42,$F8,$20
    .DB $43,$FF
Label_446 ;$90D4
    .DB $22,$30,$F8
Label_447 ;$90D7
    .DB $20,$E0,$F8
Label_448 ;$90DA
    .DB $20,$E2,$30,$E4,$30,$E6,$40,$E8,$40,$EA,$50,$EC,$50,$EE,$60,$F0
    .DB $60,$F2,$70,$F4,$70,$F6,$70,$F8,$70,$FA,$70,$FC,$70,$FE,$71,$00
    .DB $71,$02,$71,$04,$71,$06,$71,$08,$71,$0A,$71,$0C,$71,$0E,$71,$10
    .DB $71,$12,$71,$14,$71,$16,$71,$18,$71,$1A,$71,$1C,$71,$1E,$71,$20
    .DB $71,$22,$71,$24,$71,$26,$61,$28,$61,$2A,$61,$2C,$61,$2E,$51,$30
    .DB $51,$32,$51,$34,$51,$36,$51,$38,$51,$3A,$41,$3C,$41,$3E,$41,$40
    .DB $41,$42,$31,$44,$31,$46,$31,$48,$31,$4A,$F8,$21,$4C,$F8,$21,$4E
    .DB $F8,$21,$50,$FF
Label_449 ;$914E
    .DB $2A,$30,$40,$0C,$50,$0B,$60,$0A,$70,$09,$80,$0A,$90,$0B,$90,$0C
    .DB $90,$0D,$90,$0C,$90,$0B,$80,$0A,$70,$0B,$60,$0C,$50,$0D,$40,$0E
    .DB $30,$0D,$F8,$20,$0C,$F8,$10,$0B,$FF,$21,$B0,$10,$82,$C3,$02,$21
    .DB $70,$F8,$20,$66,$21,$B0,$C3,$01,$03,$01,$C3,$01,$21,$70,$30,$33
    .DB $FF
Label_450 ;$918F
    .DB $21,$B0,$10,$82,$C3,$02,$21,$70,$F8,$20,$66,$21,$B0,$C3,$01,$03
    .DB $01,$C3,$01,$21,$70,$30,$33,$FE,$FF
Label_451 ;$91A8
    .DW Label_450 ;$918F
Label_452 ;$91AA
    .DB $28,$B0,$10,$8B,$A3,$FA,$B1,$7D,$70,$7F,$50,$5F,$40,$5F,$30,$5F
    .DB $F8,$20,$5F,$F8,$10,$5F,$FF
Label_453 ;$91C1
    .DB $22,$F0,$F0,$7F,$21,$30,$F0,$7F,$00,$00,$00,$00,$25,$F0,$D0,$3F
    .DB $22,$F0,$F8,$20,$7F,$25,$F0,$B0,$3F,$22,$F0,$F8,$20,$7F,$25,$F0
    .DB $90,$3F,$22,$F0,$F8,$20,$7F,$25,$F0,$70,$3F,$22,$F0,$F8,$20,$7F
    .DB $25,$F0,$50,$3F,$22,$F0,$F8,$20,$7F,$25,$F0,$30,$3F,$22,$F0,$F8
    .DB $10,$7F,$25,$F0,$F8,$10,$3F,$FF
Label_454 ;$9209
    .DB $21,$30,$10,$89,$D1,$FD,$FE,$28
Label_455 ;$9211
    .DW Label_454 ;$9209
Label_456 ;$9213
    .DB $C1,$FD,$B1,$FD,$B1,$FD,$91,$FD,$91,$FD,$71,$FD,$61,$FD,$51,$FD
    .DB $51,$FD,$31,$FD,$31,$FD,$FF
Label_457 ;$922A
    .DB $21,$30,$70,$06,$FE,$28
Label_458 ;$9230
    .DW Label_457 ;$922A
Label_459 ;$9232
    .DB $60,$06,$60,$06,$50,$06,$50,$06,$50,$06,$40,$06,$40,$06,$40,$06
    .DB $30,$06,$30,$06,$FF,$21,$F0,$10,$A2,$C3,$8A,$33,$57,$F8,$23,$27
    .DB $F8,$13,$27,$FF,$21,$88,$01,$9D,$01,$20,$01,$9D,$01,$20,$FF,$22
    .DB $30,$60,$0E,$50,$0E,$FF,$21,$F0,$10,$A2,$D3,$8A,$53,$57,$43,$27
    .DB $33,$27,$FE,$2B,$6C,$92,$E3,$8A,$63,$57,$53,$27,$43,$27,$FE,$2C
    .DB $78,$92,$F3,$8A,$73,$57,$63,$27,$63,$27,$FE,$30,$84,$92,$FF,$22
    .DB $30,$60,$0E,$50,$0E,$FE,$13,$91,$92,$22,$30,$70,$0E,$60,$0E,$FE
    .DB $13,$9B,$92,$22,$30,$80,$0E,$70,$0E,$FE,$13,$A5,$92,$22,$30,$90
    .DB $0E,$70,$0E,$FE,$13,$AF,$92,$22,$30,$A0,$0E,$80,$0E,$FE,$2D,$B9
    .DB $92,$FF,$21,$88,$01,$9D,$01,$20,$01,$9D,$01,$20,$01,$9C,$01,$1F
    .DB $01,$9C,$01,$1F,$01,$9B,$01,$1E,$01,$9B,$01,$1E,$01,$9A,$01,$1D
    .DB $01,$9A,$01,$1D,$01,$99,$01,$1C,$01,$99,$01,$1C,$01,$98,$01,$1B
    .DB $01,$98,$01,$1B,$01,$97,$01,$1A,$01,$97,$01,$1A,$01,$96,$01,$19
    .DB $01,$96,$01,$19,$01,$95,$01,$18,$01,$95,$01,$18,$01,$94,$01,$17
    .DB $01,$94,$01,$17,$01,$93,$01,$16,$01,$93,$01,$16,$01,$92,$01,$15
    .DB $01,$92,$01,$15,$01,$91,$01,$14,$01,$91,$01,$14,$01,$90,$01,$13
    .DB $01,$90,$01,$13,$01,$8F,$01,$12,$01,$8F,$01,$12,$01,$8E,$01,$11
    .DB $01,$8E,$01,$11,$01,$8D,$01,$10,$01,$8D,$01,$10,$01,$8C,$01,$0F
    .DB $01,$8C,$01,$0F,$01,$8B,$01,$0E,$01,$8B,$01,$0E,$01,$8A,$01,$0D
    .DB $01,$8A,$01,$0D,$01,$89,$01,$0C,$01,$89,$01,$0C,$01,$88,$01,$0B
    .DB $01,$88,$01,$0B,$01,$87,$01,$0A,$01,$87,$01,$0A,$01,$86,$01,$09
    .DB $01,$86,$01,$09,$01,$85,$01,$08,$01,$85,$01,$08,$01,$84,$01,$07
    .DB $01,$84,$01,$07,$01,$83,$01,$06,$01,$83,$01,$06,$01,$82,$01,$05
    .DB $01,$82,$01,$05,$01,$81,$01,$04,$01,$81,$01,$04,$01,$80,$01,$03
    .DB $01,$80,$01,$03,$01,$7F,$01,$02,$01,$7F,$01,$02,$01,$7E,$01,$01
    .DB $01,$7E,$01,$01,$01,$7D,$01,$00,$01,$7D,$01,$00,$01,$7C,$00,$FF
    .DB $01,$7C,$00,$FF,$01,$7B,$00,$FE,$01,$7B,$00,$FE,$01,$7A,$00,$FD
    .DB $01,$7A,$00,$FD,$01,$79,$00,$FC,$01,$79,$00,$FC,$01,$78,$00,$FB
    .DB $01,$78,$00,$FB,$01,$77,$00,$FA,$01,$77,$00,$FA,$01,$76,$00,$F9
    .DB $01,$76,$00,$F9,$01,$75,$00,$F8,$01,$75,$00,$F8,$01,$74,$00,$F7
    .DB $01,$74,$00,$F7,$01,$73,$00,$F6,$01,$73,$00,$F6,$01,$72,$00,$F5
    .DB $01,$72,$00,$F5,$01,$71,$00,$F4,$01,$71,$00,$F4,$01,$70,$00,$F3
    .DB $01,$70,$00,$F3,$01,$6F,$00,$F2,$01,$6F,$00,$F2,$01,$6E,$00,$F1
    .DB $01,$6E,$00,$F1,$01,$6D,$00,$F0,$01,$6D,$00,$F0,$01,$6C,$00,$EF
    .DB $01,$6C,$00,$EF,$01,$6B,$00,$EE,$01,$6B,$00,$EE,$01,$6A,$00,$ED
    .DB $01,$6A,$00,$ED,$01,$69,$00,$EC,$01,$69,$00,$EC,$01,$68,$00,$EB
    .DB $01,$68,$00,$EB,$01,$67,$00,$EA,$01,$67,$00,$EA,$01,$66,$00,$E9
    .DB $01,$66,$00,$E9,$01,$65,$00,$E8,$01,$65,$00,$E8,$01,$64,$00,$E7
    .DB $01,$64,$00,$E7,$01,$63,$00,$E6,$01,$63,$00,$E6,$01,$62,$00,$E5
    .DB $01,$62,$00,$E5,$01,$61,$00,$E4,$01,$61,$00,$E4,$01,$60,$00,$E3
    .DB $01,$60,$00,$E3,$01,$5F,$00,$E2,$01,$5F,$00,$E2,$01,$5E,$00,$E1
    .DB $01,$5E,$00,$E1,$01,$5D,$00,$E0,$01,$5D,$00,$E0,$01,$5C,$00,$DF
    .DB $01,$5C,$00,$DF,$01,$5B,$00,$DE,$01,$5B,$00,$DE,$01,$5A,$00,$DD
    .DB $01,$5A,$00,$DD,$01,$59,$00,$DC,$01,$59,$00,$DC,$01,$58,$00,$DB
    .DB $01,$58,$00,$DB,$01,$57,$00,$DA,$01,$57,$00,$DA,$01,$56,$00,$D9
    .DB $01,$56,$00,$D9,$01,$55,$00,$D8,$01,$55,$00,$D8,$01,$54,$00,$D7
    .DB $01,$54,$00,$D7,$01,$53,$00,$D6,$01,$53,$00,$D6,$01,$52,$00,$D5
    .DB $01,$52,$00,$D5,$01,$51,$00,$D4,$01,$51,$00,$D4,$01,$50,$00,$D3
    .DB $01,$50,$00,$D3,$01,$4F,$00,$D2,$01,$4F,$00,$D2,$01,$4E,$00,$D1
    .DB $01,$4E,$00,$D1,$01,$4D,$00,$D0,$01,$4D,$00,$D0,$01,$4C,$00,$CF
    .DB $01,$4C,$00,$CF,$01,$4B,$00,$CE,$01,$4B,$00,$CE,$01,$4A,$00,$CD
    .DB $01,$4A,$00,$CD,$01,$49,$00,$CC,$01,$49,$00,$CC,$01,$48,$00,$CB
    .DB $01,$48,$00,$CB,$01,$47,$40,$CA,$01,$47,$00,$CA,$01,$46,$00,$C9
    .DB $01,$46,$00,$C9,$01,$45,$00,$C8,$01,$45,$00,$C8,$01,$44,$00,$C7
    .DB $01,$44,$00,$C7,$01,$43,$00,$C6,$01,$43,$00,$C6,$01,$42,$00,$C5
    .DB $01,$42,$00,$C5,$01,$41,$00,$C4,$01,$41,$00,$C4,$01,$40,$00,$C3
    .DB $01,$40,$00,$C3,$01,$3F,$00,$C2,$01,$3F,$00,$C2,$01,$3E,$00,$C1
    .DB $01,$3E,$00,$C1,$01,$3D,$00,$C0,$01,$3D,$00,$C0,$01,$3C,$00,$BF
    .DB $01,$3C,$00,$BF,$01,$3B,$00,$BE,$01,$3B,$00,$BE,$01,$3A,$00,$BD
    .DB $01,$3A,$00,$BD,$01,$39,$00,$BC,$01,$39,$00,$BC,$01,$38,$00,$BB
    .DB $01,$38,$00,$BB,$01,$37,$00,$BA,$01,$37,$00,$BA,$01,$36,$00,$B9
    .DB $01,$36,$00,$B9,$01,$35,$00,$B8,$01,$35,$00,$B8,$01,$34,$40,$B7
    .DB $01,$34,$00,$B7,$01,$33,$00,$B6,$01,$33,$00,$B6,$01,$32,$00,$B5
    .DB $01,$32,$00,$B5,$01,$31,$00,$B4,$01,$31,$00,$B4,$01,$30,$00,$B3
    .DB $01,$30,$00,$B3,$01,$2F,$00,$B2,$01,$2F,$00,$B2,$01,$2E,$00,$B1
    .DB $01,$2E,$00,$B1,$01,$2D,$00,$B0,$01,$2D,$00,$B0,$01,$2C,$00,$AF
    .DB $01,$2C,$00,$AF,$FF
Label_460 ;$9657
    .DB $21,$30,$10,$82,$63,$83,$33,$63,$F8,$23,$53,$00,$00
Label_461 ;$9664
    .DB $73,$83,$33,$64,$F8,$23,$53,$F8,$13,$33,$FE,$0F
Label_462 ;$9670
    .DW Label_461 ;$9664
Label_463 ;$9672
    .DB $83,$83,$43,$65,$33,$53,$F8,$13,$33,$FE,$10
Label_464 ;$967D
    .DW Label_463 ;$9672
Label_465 ;$967F
    .DB $93,$83,$43,$66,$33,$53,$F8,$13,$33,$FE,$10
Label_466 ;$968A
    .DW Label_465 ;$967F
Label_467 ;$968C
    .DB $A3,$83,$43,$67,$33,$53,$F8,$13,$33,$FE,$10
Label_468 ;$9697
    .DW Label_467 ;$968C
Label_469 ;$9699
    .DB $93,$83,$43,$66,$33,$53,$F8,$13,$33,$FE,$08
Label_470 ;$96A4
    .DW Label_469 ;$9699
Label_471 ;$96A6
    .DB $83,$83,$43,$65,$33,$53,$F8,$13,$33,$FE,$08
Label_472 ;$96B1
    .DW Label_471 ;$96A6
Label_473 ;$96B3
    .DB $73,$83,$33,$65,$F8,$23,$53,$F8,$13,$33,$FE,$07
Label_474 ;$96BF
    .DW Label_473 ;$96B3
Label_475 ;$96C1
    .DB $63,$83,$33,$63,$F8,$23,$53,$00,$00,$FE,$07
Label_476 ;$96CC
    .DW Label_475 ;$96C1
Label_477 ;$96CE
    .DB $53,$83,$F8,$23,$63,$F8,$13,$53,$00,$00,$FE,$06
Label_478 ;$96DA
    .DW Label_477 ;$96CE
Label_479 ;$96DC
    .DB $43,$83,$F8,$23,$63,$F8,$13,$53,$00,$00,$FE,$06
Label_480 ;$96E8
    .DW Label_479 ;$96DC
Label_481 ;$96EA
    .DB $33,$83,$F8,$13,$63,$F8,$13,$53,$00,$00,$FE,$05
Label_482 ;$96F6
    .DW Label_481 ;$96EA
Label_483 ;$96F8
    .DB $F8,$23,$83,$F8,$13,$63,$F8,$13,$53,$00,$00,$FE,$05
Label_484 ;$9705
    .DW Label_483 ;$96F8
Label_485 ;$9707
    .DB $F8,$13,$83,$F8,$13,$63,$00,$00,$00,$00,$FE,$05
Label_486 ;$9713
    .DW Label_485 ;$9707
Label_487 ;$9715
    .DB $FF
Label_488 ;$9716
    .DB $28,$30
Label_489 ;$9718
    .DB $F8,$20,$0E,$F8,$20,$0E,$FE,$03
Label_490 ;$9720
    .DW Label_489 ;$9718
Label_491 ;$9722
    .DB $30,$0E,$30,$0E,$FE,$04
Label_492 ;$9728
    .DW Label_491 ;$9722
Label_493 ;$972A
    .DB $40,$0E,$40,$0E,$FE,$04
Label_494 ;$9730
    .DW Label_493 ;$972A
Label_495 ;$9732
    .DB $50,$0E,$50,$0E,$FE,$06
Label_496 ;$9738
    .DW Label_495 ;$9732
Label_497 ;$973A
    .DB $40,$0E,$40,$0E,$FE,$04
Label_498 ;$9740
    .DW Label_497 ;$973A
Label_499 ;$9742
    .DB $30,$0E,$30,$0E,$FE,$04
Label_500 ;$9748
    .DW Label_499 ;$9742
Label_501 ;$974A
    .DB $F8,$20,$0E,$F8,$20,$0E,$FE,$04
Label_502 ;$9752
    .DW Label_501 ;$974A
Label_503 ;$9754
    .DB $FF
Label_504 ;$9755
    .DB $21,$30,$F0,$0E,$F0,$0F,$FE,$02
Label_505 ;$975D
    .DW Label_504 ;$9755
Label_506 ;$975F
    .DB $22,$30,$F0,$0F,$F0,$08,$F0,$0F,$F0,$08,$F0,$0F,$F0,$0C,$F0,$0B
    .DB $F0,$0B,$F0,$0B,$E0,$0B,$D0,$0B,$C0,$0D,$B0,$0C,$A0,$0B,$90,$0B
    .DB $B0,$0B,$70,$0B,$60,$0B,$23,$30,$50,$0B,$40,$0B,$30,$0C,$F8,$20
    .DB $0C,$F8,$10,$0B,$FF
Label_507 ;$9794
    .DB $21,$30,$F0,$0E,$F0,$0F,$FE,$04
Label_508 ;$979C
    .DW Label_507 ;$9794
Label_509 ;$979E
    .DB $22,$30,$F0,$0F,$F0,$08,$F0,$0F,$27,$30,$F0,$0C,$F0,$0B,$F0,$0B
    .DB $F0,$0B,$E0,$0B,$D0,$0B,$C0,$0D,$B0,$0C,$A0,$0B,$90,$0B,$80,$0B
    .DB $70,$0B,$60,$0C,$50,$0B,$40,$0B,$30,$0C,$F8,$20,$0C,$F8,$10,$0B
    .DB $FF
Label_510 ;$97CF
    .DB $23,$B0,$10,$83,$D2,$11,$D2,$11,$26,$B0,$C0,$B8,$B0,$BC,$A0,$C0
    .DB $90,$C5,$70,$CA,$50,$CF,$30,$D4,$FF
Label_511 ;$97E8
    .DB $21,$30,$F0,$0E,$F0,$0F,$FE,$02
Label_512 ;$97F0
    .DW Label_511 ;$97E8
Label_513 ;$97F2
    .DB $25,$30,$F0,$0F,$F0,$0A,$F0,$0F,$F0,$0A,$F0,$0F,$F0,$0C,$F0,$0C
    .DB $F0,$0B,$F0,$0B,$E0,$0B,$D0,$0C,$C0,$0D,$B0,$0D,$A0,$0C,$90,$0C
    .DB $B0,$0C,$70,$0C,$60,$0C,$23,$30,$50,$0C,$40,$0C,$30,$0D,$F8,$20
    .DB $0D,$F8,$20,$0C,$FF
Label_514 ;$9827
    .DB $21,$B0,$00,$00,$25,$B0,$10,$83,$F1,$FD,$10,$83,$F0,$FE,$2F,$B0
    .DB $10,$83,$F0,$FE,$10,$83,$91,$12,$10,$83,$B1,$23,$10,$83,$D1,$01
    .DB $10,$83,$91,$12,$10,$83,$51,$1D,$10,$83,$41,$2E,$10,$83,$31,$40
    .DB $10,$83,$31,$1D,$10,$83,$F8,$21,$2E,$10,$83,$F8,$21,$40,$10,$83
    .DB $F8,$11,$1D,$23,$B0,$00,$00,$FF
Label_515 ;$986F
    .DB $25,$B0,$10,$83,$F1,$FD,$10,$83,$F0,$FE,$2F,$B0,$10,$83,$F0,$FE
    .DB $10,$83,$91,$12,$10,$83,$B1,$23,$10,$83,$D1,$01,$10,$83,$91,$12
    .DB $10,$83,$51,$1D,$10,$83,$41,$2E,$10,$83,$31,$40,$10,$83,$31,$1D
    .DB $10,$83,$F8,$21,$2E,$10,$83,$F8,$21,$40,$10,$83,$F8,$11,$1D,$24
    .DB $B0,$00,$00,$FF
Label_516 ;$98B3
    .DB $DF,$CB,$DE,$C0,$FF
Label_517 ;$98B8
    .DB $21,$30,$F0,$0E,$F0,$0F,$FE,$04
Label_518 ;$98C0
    .DW Label_517 ;$98B8
Label_519 ;$98C2
    .DB $22,$30,$F0,$0F,$F0,$08,$F0,$0F,$2A,$30,$F0,$0C,$F0,$0B,$F0,$0B
    .DB $F0,$0B,$E0,$0B,$D0,$0B,$C0,$0D,$B0,$0C,$A0,$0B,$90,$0B,$80,$0B
    .DB $70,$0B,$60,$0C,$50,$0B,$40,$0B,$30,$0C,$F8,$20,$0C,$F8,$10,$0B
    .DB $FF
Label_520 ;$98F3
    .DB $23,$F0,$10,$81,$F0,$FE,$70,$FE,$30,$FE,$22,$30,$00,$00,$22,$30
    .DB $10,$83,$F0,$8E,$F0,$97,$F0,$9B,$F0,$AD,$F0,$B7,$F0,$CD,$F0,$D9
    .DB $F0,$F4,$E1,$02,$E1,$21,$E1,$32,$E1,$57,$D1,$6B,$D1,$97,$D1,$AF
    .DB $D1,$E4,$C2,$01,$C2,$3F,$C2,$61,$C2,$AB,$B2,$D3,$B3,$2B,$B3,$5B
    .DB $B3,$C4,$B3,$FA,$B4,$76,$B4,$BA,$B5,$4E,$B5,$9E,$B6,$4E,$B6,$AE
    .DB $B6,$AE,$FF
Label_521 ;$9946
    .DB $23,$30,$50,$0C,$40,$06,$30,$03,$22,$30,$00,$00,$24,$30,$50,$02
    .DB $50,$03,$50,$04,$50,$05,$50,$06,$50,$07,$60,$08,$60,$09,$60,$0A
    .DB $60,$0B,$70,$0C,$70,$0D,$70,$0E,$70,$0F,$FF
Label_522 ;$9971
    .DB $E8,$D9,$F8,$87,$0A,$E3,$03,$D9,$F7,$84,$06,$E2,$93,$73,$23,$DA
    .DB $F7,$84,$02,$E2,$4F,$FF
Label_523 ;$9987
    .DB $D9,$39,$86,$0A,$E3,$53,$D9,$3A,$87,$05,$E1,$03,$E2,$B3,$73,$DA
    .DB $38,$85,$03,$95,$E1,$21,$47,$FF
Label_524 ;$999F
    .DB $D9,$6F,$E3,$53,$E1,$43,$23,$E2,$B3,$DA,$90,$E3,$95,$21,$97,$FF
Label_525 ;$99AF
    .DB $D9,$33,$03,$03,$33,$DA,$55,$11,$17,$FF
Label_526 ;$99B9
    .DB $E1,$40,$E2,$B0,$E1,$60,$70,$40,$E2,$B0,$FE,$04
Label_527 ;$99C5
    .DW Label_526 ;$99B9
Label_528 ;$99C7
    .DB $E1,$20,$E2,$90,$E1,$40,$50,$20,$E2,$90,$FE,$04
Label_529 ;$99D3
    .DW Label_528 ;$99C7
Label_530 ;$99D5
    .DB $E1,$40,$E2,$B0,$E1,$60,$70,$40,$E2,$B0,$FE,$04
Label_531 ;$99E1
    .DW Label_530 ;$99D5
Label_532 ;$99E3
    .DB $E1,$70,$20,$90,$A0,$70,$20,$FE,$04
Label_533 ;$99EC
    .DW Label_532 ;$99E3
Label_534 ;$99EE
    .DB $FF
Label_535 ;$99EF
    .DB $DA,$F3,$81,$02,$E1,$40,$FD
Label_536 ;$99F6
    .DW Label_526 ;$99B9
Label_537 ;$99F8
    .DB $FD
Label_538 ;$99F9
    .DW Label_526 ;$99B9
Label_539 ;$99FB
    .DB $FD
Label_540 ;$99FC
    .DW Label_526 ;$99B9
Label_541 ;$99FE
    .DB $E1,$40,$E2,$B0,$E1,$60,$70,$40,$E2,$B0,$FE,$04
Label_542 ;$9A0A
    .DW Label_541 ;$99FE
Label_543 ;$9A0C
    .DB $E1,$20,$E2,$90,$E1,$40,$50,$20,$E2,$90,$FE,$04
Label_544 ;$9A18
    .DW Label_543 ;$9A0C
Label_545 ;$9A1A
    .DB $DA,$F3,$82,$02,$E1,$40,$E2,$B0,$E1,$60,$70,$40,$E2,$B0,$DA,$F3
    .DB $82,$02,$E1,$40,$E2,$B0,$E1,$60,$70,$40,$E2,$B0,$DA,$F2,$81,$02
    .DB $E1,$40,$E2,$B0,$E1,$60,$70,$40,$E2,$B0,$DA,$F1,$81,$02,$E1,$40
    .DB $E2,$B0,$E1,$60,$70,$40,$E2,$B0,$DA,$F1,$81,$02,$E1,$20,$E2,$90
    .DB $E1,$40,$50,$20,$E2,$90,$FF
Label_546 ;$9A61
    .DB $DA,$F8,$85,$02,$FD
Label_547 ;$9A66
    .DW Label_526 ;$99B9
Label_548 ;$9A68
    .DB $FD
Label_549 ;$9A69
    .DW Label_526 ;$99B9
Label_550 ;$9A6B
    .DB $FD
Label_551 ;$9A6C
    .DW Label_526 ;$99B9
Label_552 ;$9A6E
    .DB $E1,$40,$E2,$B0,$E1,$60,$70,$40,$E2,$B0,$FE,$04
Label_553 ;$9A7A
    .DW Label_552 ;$9A6E
Label_554 ;$9A7C
    .DB $E1,$20,$E2,$90,$E1,$40,$50,$20,$E2,$90,$FE,$04
Label_555 ;$9A88
    .DW Label_554 ;$9A7C
Label_556 ;$9A8A
    .DB $DA,$F7,$84,$02,$E1,$40,$E2,$B0,$E1,$60,$70,$40,$E2,$B0,$DA,$F6
    .DB $83,$02,$E1,$40,$E2,$B0,$E1,$60,$70,$40,$E2,$B0,$DA,$F5,$83,$02
    .DB $E1,$40,$E2,$B0,$E1,$60,$70,$40,$E2,$B0,$DA,$F4,$83,$02,$E1,$40
    .DB $E2,$B0,$E1,$60,$70,$40,$E2,$B0,$DA,$F3,$83,$02,$E1,$70,$20,$90
    .DB $A0,$70,$20,$DA,$F2,$82,$02,$70,$20,$90,$A0,$70,$20,$DA,$F1,$81
    .DB $02,$70,$20,$90,$A0,$70,$20,$FF
Label_557 ;$9AE2
    .DB $DA,$90
Label_558 ;$9AE4
    .DB $E2,$4A,$E3,$B0,$E2,$49,$60,$70,$2A,$E3,$90,$E2,$25,$72,$70,$60
    .DB $50,$49,$E3,$B0,$E2,$40,$BB,$79,$90,$A0,$E1,$25,$E2,$72,$70,$60
    .DB $50,$FE,$03
Label_559 ;$9B07
    .DW Label_558 ;$9AE4
Label_560 ;$9B09
    .DB $E2,$4A,$E3,$B0,$E2,$49,$60,$70,$2A,$E3,$90,$E2,$25,$72,$70,$60
    .DB $50,$E2,$4A,$E3,$B0,$E2,$4B,$FF
Label_561 ;$9B21
    .DB $05,$06,$07,$06,$05,$04,$03,$FF
Label_562 ;$9B29
    .DB $03,$04,$03,$02,$FF
Label_563 ;$9B2E
    .DB $07,$06,$05,$04,$03,$02,$01,$00,$00,$00,$02,$02,$FF
Label_564 ;$9B3B
    .DB $06,$05,$04,$03,$02,$01,$00,$00,$00,$00,$01,$01,$FF
Label_565 ;$9B48
    .DB $07,$06,$05,$04,$03,$03,$02,$01,$00,$00,$00,$00,$00,$00,$00,$02
    .DB $02,$FF
Label_566 ;$9B5A
    .DB $07,$06,$05,$04,$03,$00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01
    .DB $01,$01,$FF
Label_567 ;$9B6D
    .DB $05,$04,$03,$02,$01,$01,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01
    .DB $01,$01,$FF
Label_568 ;$9B80
    .DB $06,$05,$04,$03,$02,$02,$02,$01,$00,$00,$00,$00,$00,$00,$00,$01
    .DB $01,$FF
Label_569 ;$9B92
    .DB $EC,$01,$EB,$2A,$22,$D6,$F7,$84,$00,$E1,$40,$20,$E2,$B0,$90,$B0
    .DB $90,$70,$60,$70,$60,$40,$20,$40,$E3,$90,$B0,$E2,$20
Label_570 ;$9BAF
    .DB $D6,$F0,$00,$04,$E2,$49,$B0,$C0,$90,$B1,$E1,$10,$2F,$E2,$49,$B0
    .DB $C0,$90,$B1,$E1,$10,$E2,$7E,$C0,$FE,$02
Label_571 ;$9BC9
    .DW Label_570 ;$9BAF
Label_572 ;$9BCB
    .DB $D6,$F7,$02,$00,$E2,$B0,$C0,$D6,$F7,$84,$01,$B2,$E1,$12,$D6,$F7
    .DB $02,$00,$20,$C0,$20,$C0,$D6,$F1,$80,$00,$C0,$20,$C0,$20,$D6,$F7
    .DB $02,$00,$E1,$10,$C0,$D6,$F7,$84,$01,$12,$22,$D6,$F7,$02,$00,$40
    .DB $C0,$40,$C0,$20,$D6,$F7,$84,$01,$42,$D6,$F7,$02,$00,$E2,$B0,$C0
    .DB $D6,$F7,$84,$01,$B2,$E1,$12,$D6,$F7,$02,$00,$20,$C0,$20,$C0,$D6
    .DB $F1,$80,$00,$C0,$20,$C0,$20,$D6,$F7,$02,$00,$E1,$10,$C0,$D6,$F7
    .DB $84,$01,$12,$22,$D6,$F7,$00,$00,$43,$93,$D6,$F7,$84,$00,$E1,$60
    .DB $40,$E0,$10,$E1,$B0,$90,$80,$60,$40,$60,$40,$E1,$10,$E2,$B0,$E1
    .DB $10,$E2,$B0,$90,$80,$EB,$2A,$24,$D6,$F7,$85,$01,$E3,$B2,$C0,$D6
    .DB $F7,$04,$00,$B0,$E2,$11,$20,$61,$41,$20,$11,$E3,$90,$D6,$F7,$84
    .DB $03,$BF,$D6,$F7,$04,$00,$83,$90,$B2,$E2,$13,$20,$42,$63,$80,$91
    .DB $B0,$E1,$13,$E2,$B0,$EB,$2A,$22,$D6,$F7,$84,$03,$E3,$B0,$E2,$20
    .DB $40,$60,$40,$60,$E3,$B1,$B0,$E2,$20,$40,$61,$90,$80,$90,$81,$40
    .DB $6F,$E3,$83,$90,$B2,$E2,$13,$20,$42,$60,$60,$60,$C0,$60,$81,$90
    .DB $E1,$13,$E2,$B3,$D6,$F7,$05,$00,$E2,$90,$90,$90,$92,$90,$90,$90
    .DB $91,$91,$D6,$F7,$84,$03,$82,$D6,$F7,$05,$00,$60,$60,$60,$62,$60
    .DB $60,$60,$61,$61,$D6,$F7,$84,$03,$82,$D6,$F7,$05,$00,$90,$90,$90
    .DB $92,$90,$90,$90,$91,$91,$D6,$F7,$84,$03,$82,$D6,$F7,$05,$00,$60
    .DB $60,$60,$62,$60,$80,$90,$B0,$E1,$10,$E2,$B1,$D6,$F7,$84,$03,$82
    .DB $D6,$F7,$05,$00,$E1,$10,$10,$10,$12,$10,$10,$10,$11,$11,$D6,$F7
    .DB $84,$03,$E2,$B2,$D6,$F7,$05,$00,$90,$90,$90,$92,$90,$90,$90,$91
    .DB $91,$D6,$F7,$84,$03,$B2,$D6,$F7,$05,$00,$E1,$10,$10,$10,$12,$10
    .DB $10,$10,$11,$11,$D6,$F7,$84,$03,$22,$D6,$F7,$05,$00,$40,$40,$40
    .DB $42,$40,$40,$40,$43,$D6,$F8,$00,$00,$E3,$B0,$E2,$20,$40,$60,$40
    .DB $60,$E3,$B1,$B0,$E2,$20,$40,$60,$40,$60,$91,$90,$80,$90,$60,$40
    .DB $60,$E3,$B1,$B0,$E2,$20,$40,$C0,$60,$C0,$80,$C0,$92,$FE,$FF
Label_573 ;$9D6A
    .DW Label_570 ;$9BAF
Label_574 ;$9D6C
    .DB $EC,$01,$E8,$D6,$F6,$01,$04,$E2,$B0,$90,$60,$40,$60,$40,$20,$10
    .DB $20,$10,$E3,$B0,$90,$90,$40,$60,$90,$D6,$F6,$01,$04
Label_575 ;$9D89
    .DB $E3,$B9,$E2,$60,$C0,$40,$61,$70,$9F,$E3,$B9,$E2,$60,$C0,$40,$61
    .DB $80,$2E,$C0,$FE,$02
Label_576 ;$9D9E
    .DW Label_575 ;$9D89
Label_577 ;$9DA0
    .DB $D6,$F7,$03,$00,$E2,$60,$C0,$62,$82,$90,$C0,$90,$C0,$D6,$B6,$85
    .DB $00,$C0,$E2,$60,$90,$B0,$D6,$F7,$03,$00,$E2,$80,$C0,$82,$92,$B0
    .DB $C0,$B0,$C0,$90,$D6,$F4,$81,$00,$B2,$D6,$F7,$03,$00,$E2,$60,$C0
    .DB $62,$82,$90,$C0,$90,$C0,$D6,$B6,$85,$00,$C0,$E2,$60,$90,$B0,$D6
    .DB $F7,$03,$00,$E2,$80,$C0,$82,$92,$D6,$F5,$83,$00,$B3,$E1,$43,$D6
    .DB $F3,$81,$00,$E1,$60,$40,$60,$40,$E0,$10,$E1,$B0,$90,$80,$60,$40
    .DB $60,$40,$E1,$10,$E2,$B0,$E1,$10,$E2,$B0,$D6,$F5,$83,$03,$E3,$63
    .DB $D6,$F7,$07,$03,$60,$E2,$11,$20,$61,$41,$20,$11,$E3,$90,$D6,$F7
    .DB $86,$00,$E4,$B0,$B0,$B1,$B0,$D6,$F7,$85,$00,$E3,$12,$22,$E4,$B0
    .DB $E3,$40,$62,$D6,$F5,$07,$00,$E3,$43,$60,$82,$93,$B0,$E2,$12,$23
    .DB $20,$41,$60,$93,$80,$D6,$F7,$84,$03,$E3,$B0,$E2,$20,$40,$60,$40
    .DB $60,$E3,$B1,$B0,$E2,$20,$40,$61,$90,$80,$90,$81,$40,$D6,$37,$84
    .DB $03,$E2,$60,$40,$60,$E3,$B1,$B0,$E2,$20,$40,$61,$90,$80,$90,$B1
    .DB $E1,$10,$D6,$F7,$84,$03,$E3,$43,$60,$82,$93,$B0,$E2,$12,$20,$20
    .DB $20,$C0,$20,$41,$60,$93,$83,$D6,$F7,$06,$00,$E2,$60,$60,$60,$62
    .DB $60,$60,$60,$61,$61,$42,$20,$20,$20,$22,$20,$20,$20,$21,$21,$42
    .DB $60,$60,$60,$62,$60,$60,$60,$61,$61,$42,$20,$20,$20,$22,$20,$40
    .DB $60,$80,$90,$81,$42,$90,$90,$90,$92,$90,$90,$90,$91,$91,$82,$60
    .DB $60,$60,$62,$60,$60,$60,$61,$61,$82,$90,$90,$90,$92,$90,$90,$90
    .DB $91,$81,$92,$B0,$B0,$B0,$B2,$B0,$B0,$B0,$B3,$D6,$F6,$00,$00,$E3
    .DB $60,$B0,$E2,$10,$20,$10,$20,$E3,$61,$60,$B0,$E2,$10,$20,$10,$20
    .DB $61,$60,$40,$60,$20,$10,$20,$E3,$61,$60,$B0,$E2,$10,$C0,$D6,$F6
    .DB $01,$04,$20,$C0,$40,$C0,$62,$FE,$FF
Label_578 ;$9F09
    .DW Label_575 ;$9D89
Label_579 ;$9F0B
    .DB $EC,$01,$D6,$12,$E1,$40,$20,$E2,$B0,$90,$B0,$90,$70,$60,$70,$60
    .DB $40,$20,$40,$E3,$90,$B0,$E2,$20
Label_580 ;$9F23
    .DB $D6,$0F,$E3,$B0,$90,$B0,$41,$40,$70,$90,$B0,$90,$B0,$E2,$21,$20
    .DB $10,$20,$E3,$B0,$90,$B0,$41,$40,$70,$90,$B0,$C0,$E2,$20,$E3,$B0
    .DB $E2,$20,$11,$E3,$90,$FE,$03
Label_581 ;$9F4A
    .DW Label_580 ;$9F23
Label_582 ;$9F4C
    .DB $E3,$B0,$90,$B0,$41,$40,$70,$90,$B0,$90,$B0,$E2,$21,$20,$10,$20
    .DB $E3,$B0,$90,$B0,$41,$40,$70,$90,$B0,$90,$B0,$E2,$21,$20,$40,$60
    .DB $D6,$12,$E3,$B1,$B2,$E2,$12,$21,$E3,$B0,$E2,$41,$60,$90,$B0,$11
    .DB $11,$C0,$22,$41,$41,$20,$D6,$7F,$40,$40,$40,$D6,$12,$E3,$B1,$B2
    .DB $E2,$12,$21,$E3,$B0,$E2,$41,$60,$90,$B0,$11,$12,$22,$E2,$D6,$7F
    .DB $40,$40,$40,$40,$90,$90,$90,$90,$D6,$10,$E1,$60,$40,$E0,$10,$E1
    .DB $B0,$90,$80,$60,$40,$60,$40,$10,$E2,$B0,$E1,$10,$E2,$B0,$90,$80
    .DB $D6,$10,$E3,$B1,$B1,$B0,$E2,$11,$20,$E3,$B1,$E2,$10,$21,$E3,$60
    .DB $90,$A0,$B0,$B0,$B1,$B0,$D6,$1A,$E2,$12,$22,$D6,$10,$E3,$B0,$E2
    .DB $40,$D6,$7F,$60,$60,$60,$D6,$0F,$41,$40,$40,$41,$40,$40,$E3,$91
    .DB $90,$90,$91,$90,$90,$E2,$21,$20,$20,$21,$20,$20,$E3,$61,$60,$60
    .DB $40,$60,$80,$90
Label_583 ;$A000
    .DB $B1,$B0,$B0,$FE,$04
Label_584 ;$A005
    .DW Label_583 ;$A000
Label_585 ;$A007
    .DB $E2,$21,$20,$20,$FE,$04
Label_586 ;$A00D
    .DW Label_585 ;$A007
Label_587 ;$A00F
    .DB $41,$40,$40,$41,$40,$40,$E3,$91,$90,$90,$91,$90,$90,$E2,$20,$20
    .DB $21,$D6,$20,$20,$41,$20,$D6,$3F,$63,$43,$D6,$10,$E2,$60,$60,$60
    .DB $60,$C1,$60,$60,$60,$60,$C0,$60,$C0,$D6,$2F,$42,$D6,$10,$20,$20
    .DB $20,$20,$C1,$20,$20,$20,$20,$C0,$20,$C0,$D6,$2F,$42,$D6,$10,$60
    .DB $60,$60,$60,$C1,$60,$60,$60,$60,$C0,$60,$C0,$D6,$2F,$42,$D6,$10
    .DB $20,$20,$20,$20,$C1,$20,$40,$60,$80,$90,$80,$C0,$D6,$2F,$42,$D6
    .DB $10,$60,$60,$60,$60,$C1,$60,$60,$60,$60,$C0,$60,$C0,$40,$60,$80
    .DB $20,$20,$20,$20,$C1,$20,$20,$20,$20,$C0,$20,$C0,$20,$20,$40,$60
    .DB $60,$60,$60,$C1,$60,$60,$60,$60,$C0,$60,$C0,$20,$40,$60,$40,$40
    .DB $40,$40,$C1,$40,$40,$40,$40,$C1,$C3,$CF,$C7,$D6,$10,$E3,$C0,$60
    .DB $C0,$80,$C0,$D6,$2F,$92,$FE,$FF
Label_588 ;$A0B7
    .DW Label_580 ;$9F23
Label_589 ;$A0B9
    .DB $D6,$00,$00,$00,$00,$FE,$03
Label_590 ;$A0C0
    .DW Label_589 ;$A0B9
Label_591 ;$A0C2
    .DB $40,$40,$30,$40
Label_592 ;$A0C6
    .DB $30,$30,$30,$30,$20,$00,$30,$30,$00,$10,$00,$10,$20,$30,$30,$30
    .DB $30,$30,$30,$30,$20,$00,$30,$30,$00,$10,$00,$10,$20,$40,$30,$40
    .DB $FE,$03
Label_593 ;$A0E8
    .DW Label_592 ;$A0C6
Label_594 ;$A0EA
    .DB $30,$30,$30,$30,$20,$00,$30,$30,$00,$10,$00,$10,$20,$30,$30,$30
    .DB $30,$30,$30,$30,$20,$00,$30,$30,$20,$20,$00,$20,$20,$00,$20,$20
    .DB $40,$00,$40,$30,$00,$20,$00,$30,$40,$10,$40,$10,$00,$30,$30,$30
    .DB $40,$00,$40,$30,$00,$40,$00,$30,$40,$10,$40,$10,$40,$40,$30,$30
    .DB $40,$00,$40,$30,$00,$40,$00,$30,$40,$10,$40,$10,$00,$30,$30,$30
    .DB $40,$00,$40,$30,$00,$40,$00,$30,$40,$10,$40,$10,$40,$40,$30,$40
    .DB $30,$00,$00,$00,$10,$00,$00,$00,$30,$00,$00,$00,$40,$00,$40,$40
    .DB $30,$30,$30,$30,$20,$00,$30,$30,$00,$10,$00,$10,$20,$30,$30,$30
    .DB $30,$30,$30,$30,$20,$00,$30,$30,$00,$10,$00,$10,$20,$30,$40,$40
    .DB $30,$30,$30,$30,$20,$00,$30,$30,$00,$10,$00,$10,$20,$30,$30,$30
    .DB $30,$30,$30,$30,$20,$00,$30,$30,$00,$10,$00,$10,$30,$40,$40,$40
Label_595 ;$A19A
    .DB $30,$30,$30,$30,$20,$00,$30,$30,$00,$10,$00,$10,$20,$30,$30,$30
    .DB $FE,$03
Label_596 ;$A1AC
    .DW Label_595 ;$A19A
Label_597 ;$A1AE
    .DB $40,$40,$40,$00,$40,$41,$40,$20,$01,$00,$20,$01,$00
Label_598 ;$A1BB
    .DB $30,$30,$30,$30,$20,$00,$30,$30,$30,$10,$00,$10,$20,$31,$30,$FE
    .DB $03
Label_599 ;$A1CC
    .DW Label_598 ;$A1BB
Label_600 ;$A1CE
    .DB $30,$30,$30,$30,$20,$00,$40,$40,$40,$20,$40,$20,$10,$40,$30,$30
Label_601 ;$A1DE
    .DB $30,$30,$30,$30,$20,$00,$30,$30,$30,$10,$00,$10,$20,$31,$30,$FE
    .DB $03
Label_602 ;$A1EF
    .DW Label_601 ;$A1DE
Label_603 ;$A1F1
    .DB $40,$40,$40,$40,$10,$00,$40,$40,$40,$40,$C1,$C3
Label_604 ;$A1FD
    .DB $33,$FE,$06
Label_605 ;$A200
    .DW Label_604 ;$A1FD
Label_606 ;$A202
    .DB $30,$40,$30,$40,$30,$40,$00,$30,$FE,$FF
Label_607 ;$A20C
    .DW Label_592 ;$A0C6
Label_608 ;$A20E
    .DB $07,$06,$05,$04,$03,$03,$00,$00,$00,$02,$FF
Label_609 ;$A219
    .DB $03,$04,$05,$06,$07,$07,$07,$06,$06,$06,$06,$05,$05,$05,$05,$04
    .DB $04,$04,$04,$03,$FF
Label_610 ;$A22E
    .DB $06,$07,$06,$05,$04,$03,$FF
Label_611 ;$A235
    .DB $06,$07,$06,$05,$04,$03,$00,$00,$00,$00,$01,$FF
Label_612 ;$A241
    .DB $04,$05,$06,$05,$04,$03,$FF
Label_613 ;$A248
    .DB $04,$05,$04,$03,$FF
Label_614 ;$A24D
    .DB $03,$04,$03,$03,$03,$03,$00,$00,$00,$00,$01,$FF
Label_615 ;$A259
    .DB $04,$05,$06,$05,$04,$03,$FF
Label_616 ;$A260
    .DB $08,$07,$06,$05,$04,$03,$00,$00,$00,$00,$01,$FF
Label_617 ;$A26C
    .DB $FF
Label_618 ;$A26D
    .DB $D6,$35,$19,$03,$E2,$41,$D6,$F5,$1D,$02,$50,$71,$D6,$F5,$1C,$02
    .DB $92,$51,$D6,$F5,$1D,$02,$20,$E3,$B1,$D6,$F5,$1E,$04,$E3,$90,$E2
    .DB $70,$D6,$F8,$86,$0A,$E4,$92,$E3,$00,$E4,$90,$E3,$20,$20,$E4,$91
    .DB $E3,$00,$00,$E4,$92,$71,$60,$FE,$02
Label_619 ;$A2A6
    .DW Label_618 ;$A26D
Label_620 ;$A2A8
    .DB $D6,$F7,$1D,$02,$E2,$91,$70,$90,$B1,$90,$B0,$E1,$01,$E2,$B0,$E1
    .DB $00,$23,$E2,$B1,$70,$B0,$E1,$01,$E2,$B0,$E1,$00,$21,$00,$20,$43
    .DB $FF
Label_621 ;$A2C9
    .DB $D6,$B8,$18,$01,$E3,$9F,$E2,$2F,$4F,$7F,$D6,$B8,$18,$00,$BF,$D6
    .DB $B3,$80,$01,$BF
Label_622 ;$A2DD
    .DB $FD
Label_623 ;$A2DE
    .DW Label_618 ;$A26D
Label_624 ;$A2E0
    .DB $D6,$F8,$87,$00,$E4,$71,$E2,$40,$E4,$90,$90,$E2,$40,$E4,$90,$90
    .DB $E2,$20,$E4,$90,$90,$E2,$00,$E4,$90,$90,$E2,$41,$E4,$71,$E2,$40
    .DB $E4,$90,$90,$E2,$40,$E4,$90,$90,$E2,$20,$E4,$90,$90,$E2,$00,$E4
    .DB $90,$90,$E2,$41,$FD
Label_625 ;$A315
    .DW Label_618 ;$A26D
Label_626 ;$A317
    .DB $E8,$D6,$36,$85,$00,$E2,$90,$70,$40,$20,$40,$20,$00,$E3,$90,$E2
    .DB $00,$E3,$90,$70,$90,$C3,$C7,$E8,$D6,$F7,$1F,$02,$E3,$40,$40,$41
    .DB $51,$51,$D6,$36,$83,$02,$E2,$01,$00,$00,$00,$00,$20,$42,$21,$41
    .DB $61,$01,$00,$00,$00,$00,$20,$42,$21,$00,$E3,$B2,$E2,$01,$00,$00
    .DB $00,$00,$20,$42,$21,$41,$61,$00,$20,$40,$21,$40,$60,$41,$60,$70
    .DB $61,$70,$91,$FE,$FF
Label_627 ;$A36C
    .DW Label_622 ;$A2DD
Label_628 ;$A36E
    .DB $D6,$F7,$19,$02,$E2,$91,$D6,$F7,$1A,$02,$B0,$E1,$01,$D6,$F7,$19
    .DB $02,$22,$E2,$B1,$D6,$F7,$1A,$02,$70,$41,$D6,$F7,$1B,$04,$E2,$90
    .DB $E1,$70,$65,$E2,$90,$E1,$60,$48,$FE,$02
Label_629 ;$A398
    .DW Label_628 ;$A36E
Label_630 ;$A39A
    .DB $D6,$F7,$19,$03,$E1,$51,$20,$50,$71,$50,$70,$91,$70,$90,$B3,$71
    .DB $40,$70,$91,$70,$90,$B1,$90,$B0,$E0,$03,$FF
Label_631 ;$A3B5
    .DB $D6,$F6,$17,$00
Label_632 ;$A3B9
    .DB $E1,$70,$40,$60,$71,$70,$40,$60,$70,$40,$60,$71,$70,$40,$60,$FE
    .DB $06
Label_633 ;$A3CA
    .DW Label_632 ;$A3B9
Label_634 ;$A3CC
    .DB $FD
Label_635 ;$A3CD
    .DW Label_628 ;$A36E
Label_636 ;$A3CF
    .DB $D6,$F7,$1F,$02
Label_637 ;$A3D3
    .DB $E3,$71,$E1,$90,$E2,$90,$90,$E1,$70,$E2,$90,$90,$E1,$60,$E2,$90
    .DB $90,$E1,$40,$E2,$90,$90,$E1,$71,$FE,$02
Label_638 ;$A3ED
    .DW Label_637 ;$A3D3
Label_639 ;$A3EF
    .DB $FD
Label_640 ;$A3F0
    .DW Label_628 ;$A36E
Label_641 ;$A3F2
    .DB $D6,$F9,$87,$00,$E1,$90,$70,$40,$20,$40,$20,$00,$E2,$90,$E1,$00
    .DB $E2,$90,$70,$90,$C3,$C7,$D6,$F7,$1F,$02,$E3,$90,$90,$91,$81,$81
    .DB $D6,$F8,$85,$02,$E2,$91,$90,$90,$90,$90,$B0,$E1,$02,$E2,$B1,$E1
    .DB $01,$21,$E2,$91,$90,$90,$90,$90,$B0,$E1,$02,$E2,$B1,$90,$72,$91
    .DB $90,$90,$90,$90,$B0,$E1,$02,$E2,$B1,$E1,$01,$21,$E2,$40,$60,$70
    .DB $61,$70,$90,$71,$90,$B0,$91,$B0,$E1,$01,$FE,$FF
Label_642 ;$A44E
    .DW Label_634 ;$A3CC
Label_643 ;$A450
    .DB $D6,$14,$E3,$91,$D6,$0E,$E2,$00,$E3,$90,$E2,$20,$20,$D6,$14,$E3
    .DB $91,$D6,$0E,$E2,$00,$00,$D6,$1B,$E3,$92,$D6,$0F,$71,$80,$FE,$04
Label_644 ;$A470
    .DW Label_643 ;$A450
Label_645 ;$A472
    .DB $D6,$14,$E3,$51,$D6,$0E,$90,$50,$E2,$20,$20,$D6,$14,$E3,$91,$D6
    .DB $0E,$E2,$00,$00,$D6,$1B,$E3,$92,$D6,$0F,$51,$60,$D6,$15,$E3,$71
    .DB $D6,$0E,$B0,$70,$E2,$20,$20,$D6,$14,$E3,$B1,$D6,$0E,$E2,$00,$00
    .DB $D6,$1B,$E3,$92,$D6,$0F,$51,$60,$FF
Label_646 ;$A4AB
    .DB $D6,$0D,$E2
Label_647 ;$A4AE
    .DB $90,$FE,$60
Label_648 ;$A4B1
    .DW Label_647 ;$A4AE
Label_649 ;$A4B3
    .DB $FD
Label_650 ;$A4B4
    .DW Label_643 ;$A450
Label_651 ;$A4B6
    .DB $D6,$0F,$E3,$71,$E2,$90,$E3,$90,$90,$E2,$70,$E3,$90,$90,$E2,$60
    .DB $E3,$90,$90,$E2,$40,$E3,$90,$90,$E2,$71,$FE,$02
Label_652 ;$A4D2
    .DW Label_651 ;$A4B6
Label_653 ;$A4D4
    .DB $FD
Label_654 ;$A4D5
    .DW Label_643 ;$A450
Label_655 ;$A4D7
    .DB $D6,$0F,$E2,$90,$70,$40,$20,$40,$20,$00,$E3,$90,$E2,$00,$E3,$90
    .DB $70,$90,$C3,$C7,$90,$90,$90,$C0,$B0,$C0,$B0,$C0,$D6,$0F,$E2,$91
    .DB $91,$CB,$91,$91,$C7,$71,$71,$91,$91,$CB,$E2,$90,$90,$90,$90,$C2
    .DB $01,$20,$40,$20,$20,$40,$61,$FE,$FF
Label_656 ;$A510
    .DW Label_649 ;$A4B3
Label_657 ;$A512
    .DB $D6
Label_658 ;$A513
    .DB $00,$FE,$50
Label_659 ;$A516
    .DW Label_658 ;$A513
Label_660 ;$A518
    .DB $40,$FE,$10
Label_661 ;$A51B
    .DW Label_660 ;$A518
Label_662 ;$A51D
    .DB $30,$10,$30,$30,$40,$30,$00,$30,$31,$30,$30,$40,$31,$30,$30,$10
    .DB $30,$30,$40,$30,$00,$30,$31,$30,$30,$40,$40,$00,$40,$FE,$07
Label_663 ;$A53C
    .DW Label_662 ;$A51D
Label_664 ;$A53E
    .DB $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$C3,$40,$42,$33
    .DB $40,$40,$40,$C0,$40,$30,$40,$30,$31,$31,$00,$00,$01,$00,$00,$01
    .DB $00,$02,$31,$31,$00,$00,$01,$00,$00,$01,$01,$01,$31,$31,$00,$00
    .DB $01,$00,$00,$01,$00,$02,$30,$30,$30,$30,$40,$40,$40,$40,$40,$40
    .DB $40,$40,$40,$40,$41,$FE,$FF
Label_665 ;$A585
    .DW Label_662 ;$A51D
Label_666 ;$A587
    .DB $08,$07,$06,$05,$04,$00,$00,$00,$00,$00,$00,$01,$FF
Label_667 ;$A594
    .DB $08,$07,$06,$05,$04,$03,$02,$01,$FF
Label_668 ;$A59D
    .DB $07,$06,$05,$04,$03,$02,$01,$00,$00,$00,$01,$FF
Label_669 ;$A5A9
    .DB $04,$03,$02,$02,$02,$00,$00,$00,$00,$00,$01,$FF
Label_670 ;$A5B5
    .DB $D6,$F7,$24,$00,$E2,$91,$E1,$21,$31,$20,$01,$E2,$A0,$E1,$01,$E2
    .DB $71,$91,$91,$E1,$21,$31,$20,$51,$30,$71,$E2,$71,$91,$D6,$35,$25
    .DB $00
Label_671 ;$A5D6
    .DB $E1,$21,$91,$E0,$21,$E1,$91,$FE,$02
Label_672 ;$A5DF
    .DW Label_671 ;$A5D6
Label_673 ;$A5E1
    .DB $21,$51,$91,$91,$21,$51,$FF
Label_674 ;$A5E8
    .DB $E8,$D6,$37,$26,$00,$E3
Label_675 ;$A5EE
    .DB $41,$FE,$10
Label_676 ;$A5F1
    .DW Label_675 ;$A5EE
Label_677 ;$A5F3
    .DB $E8
Label_678 ;$A5F4
    .DB $D6,$F8,$86,$05,$E2,$50,$46,$D6,$36,$84,$0F,$81,$41,$81,$91,$FE
    .DB $04
Label_679 ;$A605
    .DW Label_678 ;$A5F4
Label_680 ;$A607
    .DB $D6,$F8,$86,$05,$E2,$80,$76,$D6,$36,$84,$0F,$B1,$71,$B1,$E1,$01
    .DB $FE,$04
Label_681 ;$A619
    .DW Label_680 ;$A607
Label_682 ;$A61B
    .DB $D6,$F8,$86,$05,$E2,$B0,$A6,$D6,$36,$84,$0F,$E2,$21,$21,$21,$21
    .DB $D6,$F8,$86,$05,$E1,$10,$06,$D6,$36,$84,$0F,$E2,$41,$41,$41,$41
    .DB $FE,$02
Label_683 ;$A63D
    .DW Label_682 ;$A61B
Label_684 ;$A63F
    .DB $FD
Label_685 ;$A640
    .DW Label_670 ;$A5B5
Label_686 ;$A642
    .DB $91,$91,$FD
Label_687 ;$A645
    .DW Label_670 ;$A5B5
Label_688 ;$A647
    .DB $93,$FE,$FF
Label_689 ;$A64A
    .DW Label_678 ;$A5F4
Label_690 ;$A64C
    .DB $D6,$F7,$24,$00,$E1,$21,$91,$A1,$90,$71,$50,$71,$01,$21,$21,$91
    .DB $A1,$90,$E0,$01,$E1,$A0,$E0,$01,$E1,$01,$2F,$C1,$D6,$35,$25,$00
    .DB $E1,$51,$91,$E0,$21,$01,$E1,$51,$91,$FF
Label_691 ;$A676
    .DB $D6,$F7,$23,$00,$E4
Label_692 ;$A67B
    .DB $41,$FE,$10
Label_693 ;$A67E
    .DW Label_692 ;$A67B
Label_694 ;$A680
    .DB $D6,$F8,$86,$05,$E2,$90,$86,$D6,$37,$86,$00,$B1,$91,$B1,$E1,$01
    .DB $FE,$04
Label_695 ;$A692
    .DW Label_694 ;$A680
Label_696 ;$A694
    .DB $D6,$F8,$86,$05,$E1,$00,$E2,$B6,$D6,$37,$86,$00,$E1,$21,$01,$21
    .DB $31,$FE,$04
Label_697 ;$A6A7
    .DW Label_696 ;$A694
Label_698 ;$A6A9
    .DB $D6,$F8,$86,$05,$E1,$30,$26,$D6,$37,$86,$00,$E2,$A1,$91,$A1,$E1
    .DB $01,$D6,$F8,$86,$05,$E1,$50,$46,$D6,$37,$86,$00,$E2,$A1,$91,$A1
    .DB $E1,$01,$FE,$02
Label_699 ;$A6CD
    .DW Label_698 ;$A6A9
Label_700 ;$A6CF
    .DB $FD
Label_701 ;$A6D0
    .DW Label_690 ;$A64C
Label_702 ;$A6D2
    .DB $E0,$21,$01,$FD
Label_703 ;$A6D6
    .DW Label_690 ;$A64C
Label_704 ;$A6D8
    .DB $E0,$23,$FE,$FF
Label_705 ;$A6DC
    .DW Label_694 ;$A680
Label_706 ;$A6DE
    .DB $D6,$0E,$E2
Label_707 ;$A6E1
    .DB $41,$FE,$10
Label_708 ;$A6E4
    .DW Label_707 ;$A6E1
Label_709 ;$A6E6
    .DB $D6,$0E,$50,$D6,$20,$42,$D6,$0E,$41,$41,$41,$41,$41,$41,$FE,$04
Label_710 ;$A6F6
    .DW Label_709 ;$A6E6
Label_711 ;$A6F8
    .DB $D6,$0E,$80,$D6,$20,$72,$D6,$0E,$71,$71,$71,$71,$71,$71,$FE,$04
Label_712 ;$A708
    .DW Label_711 ;$A6F8
Label_713 ;$A70A
    .DB $D6,$0E,$E2,$B0,$D6,$20,$A2,$D6,$0E,$A1,$A1,$A1,$A1,$A1,$A1,$E1
    .DB $10,$D6,$20,$02,$D6,$0E,$01,$01,$01,$01,$01,$01,$FE,$02
Label_714 ;$A728
    .DW Label_713 ;$A70A
Label_715 ;$A72A
    .DB $D6,$0E,$E2
Label_716 ;$A72D
    .DB $21,$FE,$10
Label_717 ;$A730
    .DW Label_716 ;$A72D
Label_718 ;$A732
    .DB $21,$91,$FE,$08
Label_719 ;$A736
    .DW Label_718 ;$A732
Label_720 ;$A738
    .DB $D6,$0E,$E2
Label_721 ;$A73B
    .DB $21,$FE,$10
Label_722 ;$A73E
    .DW Label_721 ;$A73B
Label_723 ;$A740
    .DB $21,$91,$FE,$08
Label_724 ;$A744
    .DW Label_723 ;$A740
Label_725 ;$A746
    .DB $FE,$FF
Label_726 ;$A748
    .DW Label_709 ;$A6E6
Label_727 ;$A74A
    .DB $30,$32,$31,$31,$31,$31,$41,$30,$00,$FE,$03
Label_728 ;$A755
    .DW Label_727 ;$A74A
Label_729 ;$A757
    .DB $30,$32,$31,$31,$30,$00,$31,$30,$00,$31,$FF
Label_730 ;$A762
    .DB $D6
Label_731 ;$A763
    .DB $31,$FE,$10
Label_732 ;$A766
    .DW Label_731 ;$A763
Label_733 ;$A768
    .DB $FD
Label_734 ;$A769
    .DW Label_727 ;$A74A
Label_735 ;$A76B
    .DB $FD
Label_736 ;$A76C
    .DW Label_727 ;$A74A
Label_737 ;$A76E
    .DB $30,$32,$31,$31,$31,$31,$41,$30,$00,$FE,$03
Label_738 ;$A779
    .DW Label_737 ;$A76E
Label_739 ;$A77B
    .DB $31,$31,$31,$31,$40,$40,$41,$40,$40,$41
Label_740 ;$A785
    .DB $31,$31,$41,$31,$31,$31,$41,$30,$00,$FE,$03
Label_741 ;$A790
    .DW Label_740 ;$A785
Label_742 ;$A792
    .DB $31,$31,$41,$31,$41,$41,$41,$40,$40
Label_743 ;$A79B
    .DB $31,$31,$41,$31,$31,$31,$41,$30,$00,$FE,$03
Label_744 ;$A7A6
    .DW Label_743 ;$A79B
Label_745 ;$A7A8
    .DB $31,$31,$41,$31,$41,$41,$40,$40,$41,$FE,$FF
Label_746 ;$A7B3
    .DW Label_733 ;$A768
Label_747 ;$A7B5
    .DB $08,$07,$06,$05,$04,$03,$00,$00,$00,$00,$01,$FF
Label_748 ;$A7C1
    .DB $06,$07,$06,$05,$04,$03,$FF
Label_749 ;$A7C8
    .DB $05,$04,$03,$03,$03,$03,$00,$00,$00,$00,$01,$FF
Label_750 ;$A7D4
    .DB $08,$07,$06,$05,$04,$03,$03,$00,$00,$00,$01,$FF
Label_751 ;$A7E0
    .DB $06,$05,$04,$03,$02,$00,$00,$00,$00,$00,$01,$FF
Label_752 ;$A7EC
    .DB $E8,$D6,$F9,$87,$00,$E3,$C8
Label_753 ;$A7F3
    .DB $D6,$F9,$87,$00,$E3,$70,$80,$A0,$D6,$37,$84,$05,$E2,$08,$00,$10
    .DB $30,$71,$56,$50,$30,$10,$31,$19,$31,$13,$E3,$A1,$73,$E2,$08,$00
    .DB $10,$30,$71,$56,$50,$30,$10,$31,$13,$D6,$38,$86,$04,$E2,$81,$73
    .DB $E2,$31,$13,$E3,$A1,$73
Label_754 ;$A829
    .DB $D6,$37,$21,$00,$E2,$01,$00,$D6,$B7,$21,$00,$E3,$32,$62,$02,$FE
    .DB $04
Label_755 ;$A83A
    .DW Label_754 ;$A829
Label_756 ;$A83C
    .DB $D6,$37,$21,$00,$E3,$71,$70,$D6,$B7,$21,$00,$E3,$A2,$E2,$12,$E3
    .DB $72,$FE,$03
Label_757 ;$A84F
    .DW Label_756 ;$A83C
Label_758 ;$A851
    .DB $D6,$37,$21,$00,$E2,$71,$70,$D6,$F7,$21,$00,$E3,$A2,$E2,$80,$80
    .DB $80,$A0,$A0,$A0,$D6,$F4,$82,$00,$E0,$51,$00,$E1,$80,$E0,$00,$E1
    .DB $80,$50,$80,$50,$00,$50,$00,$E2,$80,$E1,$50,$00,$E2,$80,$E1,$00
    .DB $E2,$80,$50,$80,$50,$FE,$FF
Label_759 ;$A888
    .DW Label_753 ;$A7F3
Label_760 ;$A88A
    .DB $D6,$F9,$87,$04,$E2,$C8
Label_761 ;$A890
    .DB $D6,$F8,$85,$05,$E2,$00,$10,$30
Label_762 ;$A898
    .DB $E2,$58,$50,$70,$80,$E1,$01,$E2,$A6,$A0,$80,$70,$81,$79,$81,$73
    .DB $31,$03,$FE,$02
Label_763 ;$A8AC
    .DW Label_762 ;$A898
Label_764 ;$A8AE
    .DB $D6,$F7,$21,$00
Label_765 ;$A8B2
    .DB $E2,$51,$50,$E3,$32,$62,$02,$FE,$04
Label_766 ;$A8BB
    .DW Label_765 ;$A8B2
Label_767 ;$A8BD
    .DB $E1,$01,$00,$E3,$A2,$E2,$12,$E3,$72,$FE,$03
Label_768 ;$A8C8
    .DW Label_767 ;$A8BD
Label_769 ;$A8CA
    .DB $E1,$01,$00,$E3,$A2,$E1,$10,$10,$10,$30,$30,$30,$D6,$F7,$83,$00
    .DB $E0,$50,$00,$E1,$80,$E0,$00,$E1,$80,$50,$80,$50,$00,$50,$00,$E2
    .DB $80,$E1,$50,$00,$E2,$80,$E1,$00,$E2,$80,$50,$80,$50,$00,$FE,$FF
Label_770 ;$A8FA
    .DW Label_761 ;$A890
Label_771 ;$A8FC
    .DB $D6,$0E,$E2,$C8
Label_772 ;$A900
    .DB $D6,$0E,$E2,$00,$10,$30
Label_773 ;$A906
    .DB $50,$C0,$50,$FE,$0F
Label_774 ;$A90B
    .DW Label_773 ;$A906
Label_775 ;$A90D
    .DB $00,$10,$30
Label_776 ;$A910
    .DB $50,$C0,$50,$FE,$0F
Label_777 ;$A915
    .DW Label_776 ;$A910
Label_778 ;$A917
    .DB $00,$10,$30,$D6,$12
Label_779 ;$A91C
    .DB $E2,$52,$32,$62,$02,$FE,$04
Label_780 ;$A923
    .DW Label_779 ;$A91C
Label_781 ;$A925
    .DB $E2,$02,$E3,$A2,$E2,$12,$E3,$72,$FE,$03
Label_782 ;$A92F
    .DW Label_781 ;$A925
Label_783 ;$A931
    .DB $E2,$01,$00,$E3,$A2,$D6,$10,$E2,$10,$10,$10,$30,$30,$30,$D6,$90
    .DB $5B,$38,$FE,$FF
Label_784 ;$A945
    .DW Label_772 ;$A900
Label_785 ;$A947
    .DB $D6
Label_786 ;$A948
    .DB $20,$FE,$09
Label_787 ;$A94B
    .DW Label_786 ;$A948
Label_788 ;$A94D
    .DB $D6,$40,$40,$40
Label_789 ;$A951
    .DB $31,$30,$40,$00,$00,$31,$30,$40,$30,$30,$FE,$03
Label_790 ;$A95D
    .DW Label_789 ;$A951
Label_791 ;$A95F
    .DB $31,$30,$40,$00,$00,$31,$30,$40,$40,$40
Label_792 ;$A969
    .DB $31,$30,$40,$00,$00,$31,$30,$40,$30,$30,$FE,$03
Label_793 ;$A975
    .DW Label_792 ;$A969
Label_794 ;$A977
    .DB $31,$30,$40,$00,$00,$31,$30,$40,$40,$40
Label_795 ;$A981
    .DB $31,$30,$40,$00,$00,$31,$00,$40,$00,$00,$FE,$07
Label_796 ;$A98D
    .DW Label_795 ;$A981
Label_797 ;$A98F
    .DB $31,$30,$40,$30,$30,$40,$40,$40,$40,$40,$40
Label_798 ;$A99A
    .DB $30,$00,$00,$FE,$06
Label_799 ;$A99F
    .DW Label_798 ;$A99A
Label_800 ;$A9A1
    .DB $40,$40,$40,$FE,$FF
Label_801 ;$A9A6
    .DW Label_788 ;$A94D
Label_802 ;$A9A8
    .DB $07,$06,$05,$04,$03,$03,$03,$03,$00,$00,$00,$00,$01,$FF
Label_803 ;$A9B6
    .DB $05,$04,$03,$03,$03,$03,$03,$03,$00,$00,$00,$00,$01,$FF
Label_804 ;$A9C4
    .DB $05,$06,$07,$06,$05,$04,$03,$FF
Label_805 ;$A9CC
    .DB $0B,$0A,$09,$08,$07,$06,$05,$04,$03,$FF
Label_806 ;$A9D6
    .DB $DC,$F7,$29,$02,$E1,$1D,$7D,$3D,$9D
Label_807 ;$A9DF
    .DB $D7,$37,$28,$00,$E3,$A2,$E2,$32,$A1,$E1,$31,$E2,$01,$E1,$53,$E8
    .DB $D7,$B9,$87,$00,$E3,$00,$50,$50,$E2,$00,$E1,$00,$E2,$00,$E8,$FE
    .DB $02
Label_808 ;$AA00
    .DW Label_807 ;$A9DF
Label_809 ;$AA02
    .DB $E8,$D7,$34,$82,$00,$E2,$A1
Label_810 ;$AA09
    .DB $E2,$A0,$E1,$A0,$80,$60,$50,$30,$10,$00,$E2,$A0,$80,$FE,$02
Label_811 ;$AA18
    .DW Label_810 ;$AA09
Label_812 ;$AA1A
    .DB $E2,$A0,$E1,$A0,$80,$60,$50,$30,$10,$00,$E8,$E8,$D7,$FA,$88,$00
Label_813 ;$AA2A
    .DB $E3,$00,$E2,$00,$FE,$03
Label_814 ;$AA30
    .DW Label_813 ;$AA2A
Label_815 ;$AA32
    .DB $D7,$F7,$85,$00,$E4,$A0,$E3,$A0,$E4,$A1,$A1,$D7,$FA,$88,$00
Label_816 ;$AA41
    .DB $E3,$00,$E2,$00,$FE,$03
Label_817 ;$AA47
    .DW Label_816 ;$AA41
Label_818 ;$AA49
    .DB $D7,$F7,$85,$00,$E4,$90,$E3,$90,$E4,$91,$91,$D7,$FA,$88,$00
Label_819 ;$AA58
    .DB $E3,$00,$E2,$00,$FE,$03
Label_820 ;$AA5E
    .DW Label_819 ;$AA58
Label_821 ;$AA60
    .DB $D7,$F7,$85,$00,$E4,$80,$E3,$80,$E4,$81,$81,$D7,$37,$84,$00,$E2
    .DB $30,$E3,$A0,$70,$E2,$20,$E3,$90,$60,$E2,$10,$E3,$80,$60,$E2,$00
    .DB $E3,$60,$30,$D7,$FA,$88,$00
Label_822 ;$AA87
    .DB $E3,$00,$E2,$00,$FE,$03
Label_823 ;$AA8D
    .DW Label_822 ;$AA87
Label_824 ;$AA8F
    .DB $D7,$F7,$85,$00,$E4,$A0,$E3,$A0,$E4,$A1,$A1,$D7,$FA,$88,$00
Label_825 ;$AA9E
    .DB $E3,$00,$E2,$00,$FE,$03
Label_826 ;$AAA4
    .DW Label_825 ;$AA9E
Label_827 ;$AAA6
    .DB $D7,$F7,$85,$00,$E4,$90,$E3,$90,$E4,$91,$91,$E8,$D7,$F6,$84,$02
    .DB $E3,$80,$80,$80,$80,$80,$80,$81,$80,$A2,$E2,$80,$80,$80,$80,$80
    .DB $80,$81,$A1,$E1,$30,$70,$60,$60,$60,$30,$30,$30,$60,$60,$20,$20
    .DB $50,$50,$10,$10,$60,$60,$60,$30,$30,$30,$80,$80,$50,$50,$A0,$E0
    .DB $12,$FE,$FF
Label_828 ;$AAE9
    .DW Label_807 ;$A9DF
Label_829 ;$AAEB
    .DB $DC,$F7,$29,$02,$E1,$6D,$E0,$0D,$E1,$8D,$E0,$2D
Label_830 ;$AAF7
    .DB $D7,$F7,$27,$00,$E2,$32,$62,$E1,$31,$61,$E2,$51,$E1,$93,$D7,$3B
    .DB $89,$00,$E4,$00,$50,$50,$E3,$00,$E2,$00,$E3,$00,$FE,$02
Label_831 ;$AB15
    .DW Label_830 ;$AAF7
Label_832 ;$AB17
    .DB $D7,$39,$86,$00,$E2,$A0,$E1,$A0,$80,$60,$50,$30,$10,$00,$E2,$A0
    .DB $80,$FE,$03
Label_833 ;$AB2A
    .DW Label_832 ;$AB17
Label_834 ;$AB2C
    .DB $D7,$37,$2A,$04,$E1,$75,$D7,$FA,$87,$00,$E4,$A0,$E3,$A0,$E4,$A1
    .DB $A1,$D7,$37,$2A,$04,$E1,$65,$D7,$FA,$87,$00,$E4,$90,$E3,$90,$E4
    .DB $91,$91,$D7,$37,$2A,$04,$E1,$55,$D7,$FA,$87,$00,$E4,$80,$E3,$80
    .DB $E4,$81,$81,$D7,$FB,$8A,$00,$E1,$30,$E3,$A0,$70,$E2,$20,$E3,$90
    .DB $60,$E2,$10,$E3,$80,$60,$E2,$00,$E3,$60,$30,$D7,$37,$2A,$04,$E1
    .DB $75,$D7,$FA,$87,$00,$E4,$A0,$E3,$A0,$E4,$A1,$A1,$D7,$37,$2A,$04
    .DB $E1,$65,$D7,$FA,$87,$00,$E4,$90,$E3,$90,$E4,$91,$91,$D7,$F8,$86
    .DB $02,$E2,$10,$10,$10,$10,$10,$10,$11,$10,$32,$E1,$10,$10,$10,$10
    .DB $10,$10,$11,$31,$70,$A0,$E0,$30,$30,$30,$E1,$A0,$A0,$A0,$E0,$20
    .DB $20,$E1,$A0,$A0,$E0,$10,$10,$E1,$80,$80,$E0,$30,$30,$30,$E1,$A0
    .DB $A0,$A0,$E0,$50,$50,$00,$00,$60,$82,$FE,$FF
Label_835 ;$ABD7
    .DW Label_830 ;$AAF7
Label_836 ;$ABD9
    .DB $D7,$12,$E2,$33,$43,$33,$43,$33,$43,$FE,$04
Label_837 ;$ABE4
    .DW Label_836 ;$ABD9
Label_838 ;$ABE6
    .DB $D7,$0F,$E2,$00,$E1,$00,$FE,$16
Label_839 ;$ABEE
    .DW Label_838 ;$ABE6
Label_840 ;$ABF0
    .DB $D7,$20,$E1,$12,$02,$D7,$12,$E2,$A1,$81,$D7,$20,$A2
Label_841 ;$ABFD
    .DB $82,$D7,$12,$61,$51,$D7,$20,$62,$52,$D7,$12,$31,$11
Label_842 ;$AC0A
    .DB $D7,$0E,$E2,$00,$E1,$00,$E2,$00,$E1,$00,$E2,$00,$E1,$00,$D7,$90
    .DB $E1,$05,$FE,$03
Label_843 ;$AC1E
    .DW Label_842 ;$AC0A
Label_844 ;$AC20
    .DB $D7,$17,$E1,$30,$E2,$A0,$70,$E1,$20,$E2,$90,$60,$E1,$10,$E2,$80
    .DB $60,$E1,$00,$E2,$60,$30
Label_845 ;$AC36
    .DB $D7,$0E,$E2,$00,$E1,$00,$E2,$00,$E1,$00,$E2,$00,$E1,$00,$D7,$90
    .DB $E1,$05,$FE,$02
Label_846 ;$AC4A
    .DW Label_845 ;$AC36
Label_847 ;$AC4C
    .DB $D7,$0E
Label_848 ;$AC4E
    .DB $E2,$10,$E1,$10,$FE,$0C
Label_849 ;$AC54
    .DW Label_848 ;$AC4E
Label_850 ;$AC56
    .DB $D7,$2F,$E2,$32,$32,$21,$21,$D7,$10,$10,$10,$10,$10,$D7,$2F,$32
    .DB $32,$51,$51,$D7,$10,$60,$80,$80,$80,$FE,$FF
Label_851 ;$AC71
    .DW Label_838 ;$ABE6
Label_852 ;$AC73
    .DB $D7
Label_853 ;$AC74
    .DB $33,$FE,$16
Label_854 ;$AC77
    .DW Label_853 ;$AC74
Label_855 ;$AC79
    .DB $40,$40,$40,$40,$40,$40,$40,$30
Label_856 ;$AC81
    .DB $30,$30,$30,$30,$00,$00,$40,$00,$30,$00,$40,$00,$40,$00,$00,$00
    .DB $30,$30,$40,$40,$40,$40,$FE,$02
Label_857 ;$AC99
    .DW Label_856 ;$AC81
Label_858 ;$AC9B
    .DB $30,$00,$00,$30,$00,$00,$40,$00,$30,$00,$FE,$02
Label_859 ;$ACA7
    .DW Label_858 ;$AC9B
Label_860 ;$ACA9
    .DB $30,$00,$00,$30,$00,$00,$40,$40,$40,$40
Label_861 ;$ACB3
    .DB $30,$30,$30,$30,$30,$30,$40,$40,$40,$30,$40,$30,$FE,$03
Label_862 ;$ACC1
    .DW Label_861 ;$ACB3
Label_863 ;$ACC3
    .DB $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$30,$30,$30,$30
    .DB $30,$30,$40,$40,$40,$30,$40,$30,$30,$30,$30,$30,$30,$30,$40,$40
    .DB $40,$40,$40,$40,$30,$30,$30,$40,$30,$30,$30,$00,$30,$40,$30,$30
    .DB $30,$30,$30,$40,$30,$30,$30,$00,$30,$40,$40,$40,$40,$30,$30,$40
    .DB $30,$30,$40,$30,$40,$30,$40,$40,$40,$40,$40,$30,$30,$40,$30,$30
    .DB $40,$30,$40,$30,$40,$40,$40,$30,$FE,$FF
Label_864 ;$AD1D
    .DW Label_856 ;$AC81
Label_865 ;$AD1F
    .DB $07,$07,$06,$05,$04,$03,$00,$00,$00,$01,$01,$01,$FF
Label_866 ;$AD2C
    .DB $07,$06,$05,$04,$03,$FF
Label_867 ;$AD32
    .DB $03,$04,$05,$04,$03,$02,$FF
Label_868 ;$AD39
    .DB $06,$07,$06,$05,$04,$03,$00,$00,$00,$00,$01,$01,$FF
Label_869 ;$AD46
    .DB $07,$06,$05,$04,$03,$00,$00,$00,$00,$00,$01,$01,$FF
Label_870 ;$AD53
    .DB $05,$04,$03,$03,$03,$00,$00,$00,$00,$00,$01,$01,$FF
Label_871 ;$AD60
    .DB $D6,$35,$08,$02,$E2,$41,$41,$D6,$35,$0A,$01,$71,$41,$B2,$92,$71
    .DB $FE,$03
Label_872 ;$AD72
    .DW Label_871 ;$AD60
Label_873 ;$AD74
    .DB $D6,$35,$08,$02,$E2,$41,$41,$D6,$35,$0A,$01,$71,$41,$92,$B2,$E1
    .DB $01
Label_874 ;$AD85
    .DB $D6,$F7,$08,$02,$E2,$51,$51,$D6,$35,$0A,$01,$91,$51,$E1,$02,$E2
    .DB $B2,$91,$FE,$03
Label_875 ;$AD99
    .DW Label_874 ;$AD85
Label_876 ;$AD9B
    .DB $D6,$F7,$08,$02,$51,$51,$D6,$35,$0A,$01,$91,$51,$B2,$E1,$02,$11
    .DB $FF
Label_877 ;$ADAC
    .DB $EC,$01,$D6,$F7,$08,$02,$E2,$41,$41,$D6,$F5,$0A,$01,$71,$41,$B2
    .DB $92,$71,$FE,$03
Label_878 ;$ADC0
    .DW Label_877 ;$ADAC
Label_879 ;$ADC2
    .DB $D6,$F7,$08,$02,$E2,$41,$41,$D6,$F5,$0A,$01,$71,$41,$92,$B2,$E1
    .DB $01
Label_880 ;$ADD3
    .DB $D6,$F7,$08,$02,$E2,$51,$51,$D6,$F5,$0A,$01,$91,$51,$E1,$02,$E2
    .DB $B2,$91,$FE,$03
Label_881 ;$ADE7
    .DW Label_880 ;$ADD3
Label_882 ;$ADE9
    .DB $D6,$F7,$08,$02,$51,$51,$D6,$F5,$0A,$01,$91,$51,$B2,$E1,$02,$11
Label_883 ;$ADF9
    .DB $D6,$37,$0B,$02,$E2,$00,$01,$E3,$B4,$D6,$F7,$0D,$03,$E2,$91,$91
    .DB $B3,$D6,$37,$0B,$02,$E3,$90,$91,$B4,$D6,$F7,$0D,$03,$E1,$01,$01
    .DB $23,$D6,$37,$0B,$02,$E2,$00,$01,$E3,$B4,$D6,$F7,$0D,$03,$E1,$41
    .DB $41,$53,$D6,$37,$0B,$02,$E3,$90,$91,$B4,$D6,$F7,$0D,$02,$E1,$90
    .DB $92,$90,$92,$FD
Label_884 ;$AE3D
    .DW Label_871 ;$AD60
Label_885 ;$AE3F
    .DB $D6,$35,$84,$08,$E3,$73,$43,$83,$43,$FE,$04
Label_886 ;$AE4A
    .DW Label_885 ;$AE3F
Label_887 ;$AE4C
    .DB $71,$71,$41,$41,$81,$81,$41,$41,$FE,$04
Label_888 ;$AE56
    .DW Label_887 ;$AE4C
Label_889 ;$AE58
    .DB $FD
Label_890 ;$AE59
    .DW Label_871 ;$AD60
Label_891 ;$AE5B
    .DB $FE,$FF
Label_892 ;$AE5D
    .DW Label_883 ;$ADF9
Label_893 ;$AE5F
    .DB $D6,$F7,$08,$02,$E2,$91,$91,$D6,$F7,$09,$01,$E1,$01,$E2,$91,$E1
    .DB $32,$22,$01,$FE,$03
Label_894 ;$AE74
    .DW Label_893 ;$AE5F
Label_895 ;$AE76
    .DB $D6,$F7,$08,$02,$E2,$91,$91,$D6,$F7,$09,$01,$E1,$01,$E2,$91,$E1
    .DB $22,$32,$41
Label_896 ;$AE89
    .DB $D6,$F7,$08,$02,$E2,$B1,$B1,$D6,$F7,$09,$01,$E1,$21,$E2,$B1,$E1
    .DB $52,$42,$21,$FE,$03
Label_897 ;$AE9E
    .DW Label_896 ;$AE89
Label_898 ;$AEA0
    .DB $D6,$F7,$08,$02,$E2,$B1,$B1,$D6,$F7,$09,$01,$E1,$21,$E2,$B1,$E1
    .DB $42,$52,$61,$FF
Label_899 ;$AEB4
    .DB $EC,$01,$FD
Label_900 ;$AEB7
    .DW Label_893 ;$AE5F
Label_901 ;$AEB9
    .DB $D6,$F7,$0B,$02,$E2,$50,$51,$44,$D6,$B7,$0C,$03,$E1,$21,$21,$43
    .DB $D6,$F7,$0B,$02,$E2,$20,$21,$44,$D6,$B7,$0C,$03,$E1,$51,$51,$73
    .DB $D6,$F7,$0B,$02,$E2,$50,$51,$44,$D6,$B7,$0C,$03,$E1,$91,$91,$B3
    .DB $D6,$F7,$0B,$02,$E2,$20,$21,$44,$D6,$B7,$0C,$03,$E0,$20,$22,$40
    .DB $42,$FD
Label_902 ;$AEFB
    .DW Label_893 ;$AE5F
Label_903 ;$AEFD
    .DB $D6,$38,$87,$08,$E2,$03,$E3,$93,$E2,$13,$E3,$93,$FE,$04
Label_904 ;$AF0B
    .DW Label_903 ;$AEFD
Label_905 ;$AF0D
    .DB $E2,$01,$01,$E3,$91,$91,$E2,$11,$11,$E3,$91,$91,$FE,$04
Label_906 ;$AF1B
    .DW Label_905 ;$AF0D
Label_907 ;$AF1D
    .DB $FE,$FF
Label_908 ;$AF1F
    .DW Label_899 ;$AEB4
Label_909 ;$AF21
    .DB $D6,$10,$E3
Label_910 ;$AF24
    .DB $91,$FE,$20
Label_911 ;$AF27
    .DW Label_910 ;$AF24
Label_912 ;$AF29
    .DB $B1,$FE,$20
Label_913 ;$AF2C
    .DW Label_912 ;$AF29
Label_914 ;$AF2E
    .DB $FF
Label_915 ;$AF2F
    .DB $EC,$01,$D6,$10,$E2,$91,$91,$CB,$FE,$04
Label_916 ;$AF39
    .DW Label_915 ;$AF2F
Label_917 ;$AF3B
    .DB $E3,$B1,$FE,$20
Label_918 ;$AF3F
    .DW Label_917 ;$AF3B
Label_919 ;$AF41
    .DB $D6,$10,$E2,$50,$50,$C0,$D6,$7F,$44,$D6,$10,$21,$21,$43,$20,$20
    .DB $C0,$D6,$7F,$44,$D6,$10,$51,$51,$73,$50,$50,$C0,$D6,$7F,$44,$D6
    .DB $10,$91,$91,$B3,$20,$20,$C0,$D6,$7F,$44,$D6,$10,$20,$22,$40,$42
    .DB $FD
Label_920 ;$AF72
    .DW Label_909 ;$AF21
Label_921 ;$AF74
    .DB $D6,$15,$E2,$03,$93,$13,$93,$FE,$04
Label_922 ;$AF7D
    .DW Label_921 ;$AF74
Label_923 ;$AF7F
    .DB $01,$01,$91,$91,$11,$11,$91,$91,$FE,$04
Label_924 ;$AF89
    .DW Label_923 ;$AF7F
Label_925 ;$AF8B
    .DB $FD
Label_926 ;$AF8C
    .DW Label_909 ;$AF21
Label_927 ;$AF8E
    .DB $FE,$FF
Label_928 ;$AF90
    .DW Label_919 ;$AF41
Label_929 ;$AF92
    .DB $31,$01,$41,$01,$31,$31,$41,$01,$FE,$03
Label_930 ;$AF9C
    .DW Label_929 ;$AF92
Label_931 ;$AF9E
    .DB $31,$01,$41,$01,$31,$31,$41,$40,$40
Label_932 ;$AFA7
    .DB $31,$01,$41,$01,$31,$31,$41,$01,$FE,$03
Label_933 ;$AFB1
    .DW Label_932 ;$AFA7
Label_934 ;$AFB3
    .DB $31,$01,$41,$01,$40,$40,$41,$41,$40,$40,$FF
Label_935 ;$AFBE
    .DB $D6,$31,$31,$03,$03,$03,$FE,$03
Label_936 ;$AFC6
    .DW Label_935 ;$AFBE
Label_937 ;$AFC8
    .DB $31,$31,$33,$33,$40,$40,$41
Label_938 ;$AFCF
    .DB $31,$01,$41,$01,$31,$31,$41,$01,$FE,$03
Label_939 ;$AFD9
    .DW Label_938 ;$AFCF
Label_940 ;$AFDB
    .DB $31,$01,$41,$01,$31,$31,$41,$40,$40
Label_941 ;$AFE4
    .DB $40,$40,$30,$40,$00,$00,$31,$31,$31,$41,$00,$00,$FE,$03
Label_942 ;$AFF2
    .DW Label_941 ;$AFE4
Label_943 ;$AFF4
    .DB $40,$40,$30,$40,$00,$00,$31,$40,$40,$00,$00,$40,$40,$00,$00,$FD
Label_944 ;$B004
    .DW Label_929 ;$AF92
Label_945 ;$B006
    .DB $31,$31,$41,$01,$31,$31,$41,$01,$31,$01,$41,$01,$31,$31,$41,$01
    .DB $31,$31,$41,$01,$31,$31,$41,$01,$31,$01,$41
Label_946 ;$B021
    .DB $01,$31
Label_947 ;$B023
    .DB $31,$40
Label_948 ;$B025
    .DB $40,$40,$40
Label_949 ;$B028
    .DB $31,$31,$41,$31,$FE,$03
Label_950 ;$B02E
    .DW Label_949 ;$B028
Label_951 ;$B030
    .DB $31,$31,$41,$41
Label_952 ;$B034
    .DB $31,$31,$41,$31,$FE,$03
Label_953 ;$B03A
    .DW Label_952 ;$B034
Label_954 ;$B03C
    .DB $40,$40,$41,$40,$40,$40,$40,$FD
Label_955 ;$B044
    .DW Label_929 ;$AF92
Label_956 ;$B046
    .DB $FE,$FF
Label_957 ;$B048
    .DW Label_941 ;$AFE4
Label_958 ;$B04A
    .DB $05,$06,$05,$04,$03,$02,$00,$00,$00,$00,$00,$01,$FF
Label_959 ;$B057
    .DB $0C,$0B,$0A,$09,$08,$07,$06,$FF
Label_960 ;$B05F
    .DB $08,$07,$06,$05,$04,$03,$03,$00,$00,$00,$00,$01,$FF
Label_961 ;$B06C
    .DB $0A,$09,$08,$07,$06,$05,$04,$00,$00,$00,$00,$01,$FF
Label_962 ;$B079
    .DB $E4,$60,$80,$60,$90,$60,$80,$60,$80,$60,$B0,$60,$80,$FE,$02
Label_963 ;$B088
    .DW Label_962 ;$B079
Label_964 ;$B08A
    .DB $E4,$80,$90,$80,$B0,$80,$90,$80,$90,$80,$E3,$10,$E4,$80,$90,$FE
    .DB $02
Label_965 ;$B09B
    .DW Label_964 ;$B08A
Label_966 ;$B09D
    .DB $E4,$90,$B0,$90,$E3,$10,$E4,$90,$B0,$90,$B0,$90,$E3,$10,$E4,$90
    .DB $B0,$FE,$02
Label_967 ;$B0B0
    .DW Label_966 ;$B09D
Label_968 ;$B0B2
    .DB $E4,$B0,$E3,$10,$E4,$B0,$E3,$20,$E4,$B0,$E3,$10,$E4,$B0,$E3,$10
    .DB $E4,$B0,$E3,$20,$E4,$B0,$E3,$10,$10,$20,$10,$40,$10,$20,$10,$40
    .DB $10,$50,$10,$80,$FF
Label_969 ;$B0D7
    .DB $D7,$36,$0E,$00,$E2,$60,$61,$60,$90,$80,$63,$40,$50,$E2,$60,$E3
    .DB $61,$60,$E2,$90,$80,$91,$81,$41,$80,$81,$80,$B0,$90,$83,$60,$70
    .DB $E2,$80,$E3,$81,$80,$E2,$B0,$90,$B1,$91,$81,$90,$91,$90,$E1,$10
    .DB $E2,$B0,$93,$E2,$70,$80,$90,$E3,$91,$90,$E1,$10,$E2,$B0,$E1,$11
    .DB $E2,$B1,$91,$B0,$B1,$B0,$E1,$20,$10,$E2,$B3,$E2,$B0,$E1,$00,$10
    .DB $E2,$11,$10,$E1,$40,$50,$11,$51,$81,$FE,$02,$D7,$B0,$E8,$D7,$38
    .DB $2F,$00,$E2,$20,$21,$E3,$B0,$B1,$D7,$38,$87,$00,$E2,$20,$20,$20
    .DB $20,$20,$20,$20,$20,$20,$20,$20,$10,$20,$20,$20,$20,$20,$20,$D7
    .DB $38,$2F,$00,$E2,$20,$21,$80,$81,$E1,$10,$10,$10,$10,$10,$10,$10
    .DB $10,$10,$10,$10,$E2,$B0,$E1,$10,$10,$10,$10,$10,$10,$E2,$60,$61
    .DB $40,$41,$D7,$38,$87,$00,$E2,$20,$20,$20,$20,$20,$20,$20,$20,$20
    .DB $20,$20,$10,$20,$20,$20,$20,$20,$20,$D7,$36,$2F,$00,$E2,$20,$21
    .DB $80,$81,$E1,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$40
    .DB $40,$40,$40,$40,$40,$D7,$F6,$2F,$00,$E8,$E1,$60,$60,$60,$60,$61
    .DB $C5,$FE,$FF,$D7,$B0
Label_970 ;$B1BC
    .DB $D7,$F8,$2E,$00,$FD
Label_971 ;$B1C1
    .DW Label_962 ;$B079
Label_972 ;$B1C3
    .DB $FD,$79,$B0,$D7,$F8,$30,$00,$E2,$60,$61,$40,$41,$D7,$F8,$87,$00
    .DB $E1,$60,$60,$60,$60,$60,$60,$80,$80,$80,$80,$80,$80,$90,$90,$90
    .DB $90,$90,$90,$B0,$B0,$B0,$B0,$B0,$B0,$60,$60,$60,$60,$60,$60,$80
    .DB $80,$80,$80,$80,$80,$90,$90,$90,$90,$90,$90,$E0,$10,$10,$10,$10
    .DB $10,$10,$E1,$60,$60,$60,$60,$60,$60,$80,$80,$80,$80,$80,$80,$90
    .DB $90,$90,$90,$90,$90,$B0,$B0,$B0,$B0,$B0,$B0,$60,$60,$60,$60,$60
    .DB $60,$80,$80,$80,$80,$80,$80,$90,$90,$90,$90,$90,$90,$E0,$10,$10
    .DB $10,$10,$D7,$F8,$30,$00,$11,$C5,$FE,$FF,$BC,$B1
Label_973 ;$B23F
    .DB $D7,$12,$E2,$60,$60,$C0,$60,$90,$80,$D7,$7F,$63,$D7,$10,$40,$50
    .DB $E2,$60,$D7,$12,$E3,$61,$60,$E2,$90,$80,$D1,$2F,$E2,$80,$DD,$28
    .DB $90,$D7,$28,$81,$41,$D7,$12,$80,$80,$C0,$80,$B0,$90,$D7,$7F,$83
    .DB $D7,$10,$60,$70,$E2,$80,$D7,$12,$E3,$81,$80,$E2,$B0,$90,$D7,$2F
    .DB $B1,$91,$81,$D7,$12,$90,$90,$C0,$90,$E1,$10,$E2,$B0,$D7,$7F,$93
    .DB $D7,$10,$E2,$70,$80,$90,$E3,$91,$90,$E1,$10,$E2,$B0,$D7,$2F,$E1
    .DB $11,$E2,$B1,$91,$D7,$12,$B0,$B0,$C0,$B0,$E1,$20,$10,$D7,$7F,$E2
    .DB $B3,$D7,$10,$E2,$B0,$E1,$00,$10,$D7,$12,$E2,$11,$10,$E1,$40,$50
    .DB $D7,$2F,$11,$51,$81,$FE,$02,$3F,$B2,$D7,$12,$E2,$60,$61,$40,$41
    .DB $D7,$10,$E2,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$10,$20
    .DB $20,$20,$20,$20,$20,$D7,$12,$E2,$20,$21,$80,$81,$D7,$10,$60,$60
    .DB $60,$60,$60,$60,$60,$60,$60,$60,$60,$40,$60,$60,$60,$60
Label_974 ;$B2FD
    .DB $60,$60,$D7,$12,$E2,$60,$61,$40,$41,$D7,$10,$20,$20,$20,$20,$20
    .DB $20,$20,$20,$20,$20,$20,$10,$20,$20,$20,$20,$20,$20,$D7,$12,$20
    .DB $21,$80,$81,$D7,$0F,$60,$60,$60,$60,$60,$60,$80,$80,$80,$80,$80
    .DB $80,$90,$90,$90,$90,$90,$90,$D7,$0F,$60,$60,$60,$60,$60,$C0,$C5
    .DB $FE,$FF,$3F,$B2,$40,$40,$00,$40,$40,$00,$40,$40,$40,$40,$40,$30
    .DB $FE,$03,$47,$B3,$FF
Label_975 ;$B352
    .DB $D7,$30,$40,$10,$30,$40,$30,$30,$10,$00,$10,$40,$40,$30,$40,$10
    .DB $30,$40,$30,$40,$30,$40,$30,$40,$40,$FE,$07
Label_976 ;$B36D
    .DW Label_975 ;$B352
Label_977 ;$B36F
    .DB $30,$40,$10,$30,$40,$30,$30,$10,$00,$10,$40,$40,$30,$40,$10,$30
    .DB $40,$30,$40,$40,$40,$40,$40,$40,$FD,$41,$B3,$FD,$41,$B3,$FD,$41
    .DB $B3,$FD,$41,$B3,$40,$40,$40,$40,$40,$00,$40,$30,$40,$30,$40,$40
    .DB $FE,$FF,$52,$B3
Label_978 ;$B3A3
    .DB $08,$07,$06,$05,$04,$03,$03,$00,$00,$00,$00,$01,$FF
Label_979 ;$B3B0
    .DB $06,$07,$06,$05,$04,$03,$FF
Label_980 ;$B3B7
    .DB $04,$05,$04,$03,$FF
Label_981 ;$B3BC
    .DB $09,$08,$07,$06,$05,$04,$03,$00,$00,$00,$00,$01,$FF
Label_982 ;$B3C9
    .DB $08,$07,$06,$05,$04,$03,$03,$00,$00,$00,$00,$01,$FF
Label_983 ;$B3D6
    .DB $D7,$F7,$35,$00,$E1,$C0,$10,$10,$10,$12,$30,$30,$30,$30,$E2,$B0
    .DB $B0,$B0,$B1,$D7,$F7,$0F,$00,$E2,$40,$50,$90,$D7,$F7,$11,$02,$BD
    .DB $FF
Label_984 ;$B3F7
    .DB $D7,$F7,$16,$00,$E1,$C0,$40,$40,$40,$42,$60,$60,$60,$60,$20,$20
    .DB $20,$21,$D7,$F7,$0F,$00,$E2,$90,$B0,$E1,$20,$D7,$F7,$10,$02,$4D
    .DB $FF
Label_985 ;$B418
    .DB $D7,$10,$E2,$C0,$90,$90,$90,$90,$C1,$B0,$B0,$B0,$B0,$70,$70,$70
    .DB $70,$C0,$E3,$70,$90,$E2,$00,$D7,$90,$4D,$FF
Label_986 ;$B433
    .DB $D7,$C0,$40,$40,$40,$40,$11,$40,$40,$40,$40,$40,$40,$40,$40,$C0
    .DB $30,$40,$40,$40,$FF
Label_987 ;$B448
    .DB $EB,$30,$31,$D7,$39,$86,$05,$E2,$C1,$07,$B7,$97,$57,$D7,$37,$84
    .DB $02,$E3,$9F,$E3,$9F,$FF
Label_988 ;$B45E
    .DB $EB,$30,$31,$D7,$3B,$87,$05,$E2,$C1,$97,$E1,$77,$57,$27,$D7,$3B
    .DB $87,$02,$E3,$4F,$E2,$1F,$FF
Label_989 ;$B475
    .DB $D7,$90,$E2,$C1,$97,$E1,$77,$57,$27,$E3,$93,$43,$93,$43,$9F,$FF
Label_990 ;$B485
    .DB $D7,$C1,$3F,$37,$37,$43,$33,$43,$33,$3F,$FF
Label_991 ;$B490
    .DB $08,$07,$06,$05,$04,$03,$03,$00,$00,$00,$00,$01,$FF
Label_992 ;$B49D
    .DB $06,$05,$04,$03,$03,$03,$03,$00,$00,$00,$00,$01,$FF
Label_993 ;$B4AA
    .DB $05,$04,$03,$02,$02,$02,$00,$00,$00,$01,$FF
Label_994 ;$B4B5
    .DB $08,$07,$06,$05,$04,$03,$00,$00,$00,$01,$FF
Label_995 ;$B4C0
    .DB $E8,$D7,$B7,$12,$02,$E2,$C0,$41,$42,$D7,$F7,$13,$02,$70,$90,$B0
    .DB $40,$41,$22,$03,$E1,$00,$20,$45,$E2,$22,$32,$41,$E8,$D7,$F3,$14
    .DB $00,$E1,$41,$11,$E2,$A1,$97,$FF
Label_996 ;$B4E8
    .DB $D7,$F8,$12,$02,$E2,$C0,$91,$92,$70,$90,$B0,$90,$91,$72,$53,$D7
    .DB $38,$12,$02,$E1,$00,$20,$45,$D7,$F8,$12,$02,$E2,$72,$82,$91,$D7
    .DB $37,$15,$00,$E0,$41,$11,$E1,$A1,$97,$FF
Label_997 ;$B512
    .DB $D7,$10,$E2,$C0,$90,$C0,$90,$C0,$C0,$E3,$70,$90,$B0,$90,$91,$72
    .DB $D7,$7F,$53,$D7,$2F,$E2,$00,$20,$D7,$7F,$45,$D7,$10,$E3,$72,$82
    .DB $91,$D7,$0F,$E2,$41,$11,$E3,$A1,$D7,$90,$97,$FF
Label_998 ;$B53E
    .DB $D7,$C0,$30,$00,$31,$C0,$00,$00,$00,$40,$40,$30,$40,$40,$30,$43
    .DB $00,$00,$05,$30,$00,$00,$30,$00,$00,$31,$D7,$01,$01,$01,$01,$FF
Label_999 ;$B55E
    .DB $08,$09,$08,$07,$06,$05,$04,$03,$FF
Label_1000 ;$B567
    .DB $07,$06,$05,$04,$03,$03,$03,$03,$03,$03,$00,$00,$00,$00,$01,$FF
Label_1001 ;$B577
    .DB $FF
Label_1002 ;$B578
    .DB $FF
Label_1003 ;$B579
    .DB $D6,$38,$85,$03,$E2,$75,$E4,$00,$00,$01,$01,$C1,$E2,$77,$E4,$00
    .DB $00,$01,$01,$C1,$E2,$B7,$E4,$00,$00,$E2,$52,$72,$91,$47,$07,$E2
    .DB $57,$52,$42,$21,$07,$E3,$42,$52,$71,$E2,$25,$70,$90,$77,$E3,$B7
    .DB $B2,$E2,$02,$21,$E2,$75,$E4,$00,$00,$01,$01,$C1,$E2,$77,$E4,$00
    .DB $00,$01,$01,$C1,$E2,$B7,$E4,$00,$00,$E2,$52,$72,$91,$47,$07,$27
    .DB $22,$02,$E3,$B1,$E2,$07,$42,$52,$71,$E2,$25,$20,$40,$27,$70,$90
    .DB $B1,$90,$B0,$E1,$01,$E2,$57,$D6,$37,$32,$00,$E1,$01,$01,$E2,$B1
    .DB $E1,$03,$01,$E2,$B1,$E1,$01,$E2,$B1,$B1,$91,$B3,$B1,$91,$B1,$91
    .DB $91,$71,$91,$D6,$38,$85,$03,$92,$B2,$E1,$01,$D6,$38,$85,$08,$43
    .DB $23,$03,$E2,$B3,$D6,$37,$32,$00,$E1,$21,$21,$01,$23,$21,$01,$21
    .DB $21,$21,$11,$23,$21,$11,$21,$21,$21,$01,$21,$D6,$38,$85,$03,$22
    .DB $42,$51,$FF
Label_1004 ;$B62C
    .DB $E8,$FD
Label_1005 ;$B62E
    .DW Label_1003 ;$B579
Label_1006 ;$B630
    .DB $E1,$47,$57,$FD
Label_1007 ;$B634
    .DW Label_1003 ;$B579
Label_1008 ;$B636
    .DB $E1,$47,$5F,$FF
Label_1009 ;$B63A
    .DB $D6,$F8,$31,$03,$E2,$77,$72,$E1,$22,$09,$02,$52,$49,$92,$B2,$E0
    .DB $01,$E1,$77,$47,$97,$92,$72,$51,$47,$42,$22,$01,$E2,$7F,$27,$42
    .DB $52,$71,$E2,$77,$72,$E1,$22,$09,$02,$52,$49,$92,$B2,$E0,$01,$E1
    .DB $77,$47,$57,$52,$42,$21,$47,$42,$22,$01,$E2,$75,$70,$90,$77,$B0
    .DB $E1,$00,$21,$00,$20,$41,$D6,$F8,$31,$03,$E1,$97,$79,$53,$41,$59
    .DB $43,$21,$07,$02,$22,$41,$D6,$F9,$85,$08,$E1,$93,$73,$53,$43,$D6
    .DB $F8,$31,$03,$9F,$77,$72,$52,$41,$57,$52,$72,$91,$FF
Label_1010 ;$B6A7
    .DB $FD
Label_1011 ;$B6A8
    .DW Label_1009 ;$B63A
Label_1012 ;$B6AA
    .DB $77,$B7,$FD
Label_1013 ;$B6AD
    .DW Label_1009 ;$B63A
Label_1014 ;$B6AF
    .DB $77,$BF,$FF
Label_1015 ;$B6B2
    .DB $D6,$7F,$E2,$05,$D6,$0E,$00,$00,$01,$01,$C1,$00,$00,$FE,$03
Label_1016 ;$B6C1
    .DW Label_1015 ;$B6B2
Label_1017 ;$B6C3
    .DB $D6,$7F,$05,$D6,$0E,$00,$00,$41,$41,$C1,$41,$D6,$7F,$55,$D6,$0E
    .DB $50,$50,$51,$51,$C1,$50,$50,$D6,$7F,$45,$D6,$0E,$40,$40,$41,$41
    .DB $C1,$40,$40
Label_1018 ;$B6E6
    .DB $D6,$7F,$75,$D6,$0E,$70,$70,$71,$71,$C1,$70,$70,$FE,$02
Label_1019 ;$B6F4
    .DW Label_1018 ;$B6E6
Label_1020 ;$B6F6
    .DB $D6,$7F,$E2,$05,$D6,$0E,$00,$00,$01,$01,$C1,$00,$00,$FE,$03
Label_1021 ;$B705
    .DW Label_1020 ;$B6F6
Label_1022 ;$B707
    .DB $D6,$7F,$05,$D6,$0E,$00,$00,$41,$41,$C1,$41,$D6,$7F,$55,$D6,$0E
    .DB $50,$50,$51,$51,$C1,$50,$50,$D6,$7F,$45,$D6,$0E,$40,$40,$41,$41
    .DB $C1,$40,$40
Label_1023 ;$B72A
    .DB $D6,$7F,$75,$D6,$0E,$70,$70,$71,$71,$C1,$70,$70,$FE,$02
Label_1024 ;$B738
    .DW Label_1023 ;$B72A
Label_1025 ;$B73A
    .DB $D6,$7F,$E2,$05,$D6,$0E,$00,$00,$01,$01,$C1,$00,$00,$D6,$7F,$E3
    .DB $B5,$D6,$0E,$B0,$B0,$B1,$B1,$C1,$B0,$B0,$D6,$7F,$A5,$D6,$0E,$A0
    .DB $A0,$A1,$A1,$C1,$A0,$A0,$D6,$7F,$95,$D6,$0E,$90,$90,$91,$91,$C1
    .DB $90,$90,$D6,$7F,$E2,$25,$D6,$0E,$20,$20,$21,$21,$C1,$20,$20,$D6
    .DB $7F,$15,$D6,$0E,$10,$10,$11,$11,$C1,$10,$10,$D6,$7F,$25,$D6,$0E
    .DB $20,$20,$21,$21,$C1,$20,$20,$FF
Label_1026 ;$B792
    .DB $FD
Label_1027 ;$B793
    .DW Label_1015 ;$B6B2
Label_1028 ;$B795
    .DB $D6,$7F,$E3,$B5,$D6,$0E,$B0,$B0,$E2,$71,$71,$C1,$71,$FD
Label_1029 ;$B7A3
    .DW Label_1015 ;$B6B2
Label_1030 ;$B7A5
    .DB $D6,$90,$E3,$BF,$B7,$FF
Label_1031 ;$B7AB
    .DB $D6,$31,$01,$41,$00,$00,$31,$31,$41,$01,$FE,$03
Label_1032 ;$B7B7
    .DW Label_1031 ;$B7AB
Label_1033 ;$B7B9
    .DB $31,$01,$41,$00,$00,$31,$41,$01,$40,$40
Label_1034 ;$B7C3
    .DB $31,$01,$41,$00,$00,$31,$31,$41,$01,$FE,$03
Label_1035 ;$B7CE
    .DW Label_1034 ;$B7C3
Label_1036 ;$B7D0
    .DB $31,$01,$41,$00,$00,$31,$31,$41,$41
Label_1037 ;$B7D9
    .DB $31,$01,$41,$00,$00,$31,$31,$41,$01,$FE,$03
Label_1038 ;$B7E4
    .DW Label_1037 ;$B7D9
Label_1039 ;$B7E6
    .DB $31,$01,$41,$00,$00,$31,$31,$41,$40,$40
Label_1040 ;$B7F0
    .DB $31,$01,$41,$00,$00,$31,$31,$41,$01,$FE,$03
Label_1041 ;$B7FB
    .DW Label_1040 ;$B7F0
Label_1042 ;$B7FD
    .DB $31,$01,$41,$00,$00,$31,$31,$41,$41
Label_1043 ;$B806
    .DB $31,$01,$01,$30,$30,$31,$31,$41,$01,$FE,$07
Label_1044 ;$B811
    .DW Label_1043 ;$B806
Label_1045 ;$B813
    .DB $FF
Label_1046 ;$B814
    .DB $FD
Label_1047 ;$B815
    .DW Label_1031 ;$B7AB
Label_1048 ;$B817
    .DB $31,$01,$01,$30,$30,$41,$41,$31,$40,$40,$FD
Label_1049 ;$B822
    .DW Label_1031 ;$B7AB
Label_1050 ;$B824
    .DB $33,$03,$33,$03,$C7,$FF

 .BANK32 DMC_DATA_BANK
 .ORG DMC_DATA_ADDR
DMC_Data
    .DB $AA,$AA,$AA,$AA,$AA,$AF,$F0,$9E,$9F,$F0,$06,$AE,$7C,$1B,$98,$F0
    .DB $00,$03,$00,$0C,$01,$CE,$01,$80,$00,$00,$00,$00,$00,$0F,$1F,$FF
    .DB $FB,$F3,$CF,$F3,$EF,$DE,$B8,$F9,$A6,$A2,$24,$39,$81,$43,$80,$86
    .DB $19,$02,$38,$51,$87,$86,$15,$39,$8C,$A6,$55,$4D,$16,$8C,$A3,$45
    .DB $45,$90,$CA,$56,$22,$52,$70,$D6,$53,$16,$D3,$54,$D7,$4B,$37,$4B
    .DB $5B,$6B,$56,$CE,$B5,$5B,$5D,$59,$B6,$D5,$AB,$D6,$B5,$D7,$6B,$6D
    .DB $AD,$AE,$B6,$D6,$B5,$B5,$AA,$D6,$AA,$AC,$AA,$A9,$54,$A9,$94,$A4
    .DB $A9,$4A,$4A,$8A,$92,$54,$A5,$49,$29,$4A,$54,$A5,$29,$52,$A5,$4A
    .DB $A5,$54,$A9,$54,$AA,$95,$2A,$AA,$94,$95,$2A,$AA,$55,$55,$2A,$56
    .DB $66,$AA,$9A,$AA,$B5,$5A,$AD,$AB,$5A,$B5,$6B,$6B,$6B,$5A,$B5,$AA
    .DB $B5,$56,$AA,$D5,$55,$56,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$95,$55,$55
    .DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    .DB $FE,$FF,$DE,$FF,$E3,$EF,$8C,$44,$40,$31,$37,$09,$80,$18,$60,$00
    .DB $C0,$20,$2F,$3A,$A3,$EE,$3C,$EF,$77,$57,$EF,$9F,$AF,$FF,$DE,$BF
	.DB $9E,$C9,$24,$41,$09,$09,$09,$29,$00,$00,$04,$00,$18,$74,$9B,$BF
	.DB $76,$EB,$CF,$7B,$DF,$FD,$F3,$E7,$C6,$F3,$81,$E2,$68,$31,$1C,$31
	.DB $88,$6A,$C0,$8F,$06,$0A,$61,$C6,$38,$D4,$C5,$C7,$2F,$1D,$63,$A7
	.DB $D0,$FC,$63,$CF,$B8,$F1,$B1,$CF,$F1,$DC,$76,$33,$EE,$30,$E2,$D0
	.DB $08,$38,$84,$01,$42,$0E,$07,$0C,$1D,$1E,$7D,$9E,$7F,$E7,$EF,$3F
	.DB $7F,$3F,$87,$DC,$63,$18,$73,$0C,$23,$18,$88,$53,$11,$06,$0D,$62
	.DB $03,$3C,$33,$24,$E7,$7C,$AE,$F3,$E7,$1F,$F8,$F0,$F3,$CF,$71,$AE
	.DB $1C,$8E,$CF,$08,$CE,$0C,$CC,$18,$31,$C2,$40,$E1,$8E,$18,$2C,$D1
	.DB $91,$ED,$9F,$0F,$CF,$A7,$3C,$FF,$93,$C7,$CC,$F5,$38,$39,$B8,$19
	.DB $47,$88,$46,$D6,$04,$76,$31,$85,$1C,$58,$63,$9C,$61,$79,$8C,$F3
	.DB $98,$F7,$78,$27,$C7,$9F,$64,$77,$39,$0F,$8C,$F5,$86,$2F,$91,$8C
	.DB $71,$C7,$21,$E1,$C4,$19,$8C,$41,$66,$07,$A6,$2E,$8A,$E7,$43,$CF
	.DB $9E,$1F,$9E,$71,$F3,$E3,$B7,$18,$FC,$63,$C3,$18,$C3,$B0,$E0,$E3
	.DB $0F,$08,$E0,$71,$8C,$C1,$8F,$19,$C3,$39,$39,$99,$F1,$BC,$74,$76
	.DB $E2,$F3,$C7,$97,$19,$E3,$63,$39,$87,$C6,$37,$0F,$09,$C6,$71,$23
	.DB $88,$E0,$A9,$83,$8B,$19,$87,$66,$71,$8C,$EF,$0D,$DA,$F4,$73,$EE
	.DB $1C,$DB,$8E,$76,$1A,$39,$0E,$71,$C6,$2E,$31,$C3,$9C,$59,$07,$A1
	.DB $C0,$F1,$19,$9C,$58,$CE,$2E,$2D,$6E,$3C,$E3,$39,$E3,$8E,$B8,$E7
	.DB $1C,$E3,$A7,$0D,$8E,$47,$94,$B7,$05,$C2,$39,$E6,$26,$36,$19,$8C
	.DB $74,$98,$CD,$47,$38,$59,$E8,$D3,$53,$B8,$F2,$6E,$AC,$B3,$B4,$E5
	.DB $71,$27,$8E,$8C,$8F,$1A,$3C,$8A,$73,$8E,$1C,$6B,$29,$8E,$1C,$2C
	.DB $68,$D9,$31,$E3,$55,$47,$39,$AB,$2D,$97,$38,$D3,$B1,$CE,$38,$F1
	.DB $D4,$B3,$4E,$A9,$62,$AD,$54,$B2,$38,$C9,$A8,$AC,$A9,$18,$E6,$51
	.DB $9A,$73,$29,$9E,$39,$9A,$D5,$A7,$96,$D3,$65,$9D,$58,$BA,$61,$DA
	.DB $46,$AA,$3C,$52,$B1,$A5,$66,$63,$8D,$31,$E0,$E5,$95,$2A,$CC,$B2
	.DB $9C,$AC,$AB,$39,$66,$A7,$4B,$99,$5A,$6A,$CC,$AB,$8B,$55,$A6,$A6
	.DB $AA,$3C,$5A,$39,$38,$E2,$A4,$B9,$30,$B9,$54,$AA,$95,$AA,$65,$5A
	.DB $9C,$C7,$59,$B2,$AE,$6B,$34,$DC,$B2,$D4,$B1,$D4,$63,$C5,$34,$6A
	.DB $65,$69,$65,$4C,$E3,$35,$4C,$71,$A5,$54,$D6,$33,$4D,$71,$92,$EA
	.DB $9A,$AB,$56,$55,$5A,$CA,$6A,$CE,$33,$3A,$3C,$65,$56,$39,$8D,$62
	.DB $C6,$6A,$33,$49,$A9,$55,$61,$AC,$AD,$2A,$AA,$D5,$8D,$6A,$AC,$D5
	.DB $5A,$D3,$95,$3A,$C8,$E6,$95,$94,$AD,$4B,$16,$5A,$62,$E3,$4C,$CB
	.DB $2A,$B3,$2A,$AA,$96,$A6,$5A,$9A,$AA,$AA,$AC,$D3,$55,$55,$55,$A6
	.DB $A6,$AA,$AA,$B4,$CB,$2C,$D2,$CA,$CA,$AA,$96,$95,$55,$52,$CA,$AA
	.DB $96,$66,$55,$55,$AA,$96,$AB,$2C,$AD,$59,$65,$A6,$AA,$AC,$B3,$34
	.DB $CB,$4C,$AA,$CA,$AA,$A5,$A6,$56,$55,$54,$D3,$2A,$C6,$AA,$6A,$96
	.DB $A6,$66,$AA,$AA,$B2,$B4,$D5,$55,$66,$9A,$AA,$AA,$AA,$AA,$AA,$AA
	.DB $AA,$AA,$AA,$AA,$9A,$A6,$56,$55,$52,$B2,$AA,$AA,$AA,$96,$AA,$65
	.DB $AA,$AA,$AA,$B5,$55,$56,$6A,$6A,$AA,$AA,$AA,$6A,$72,$9A,$AA,$9A
	.DB $9A,$A9,$96,$59,$55,$55,$55,$52,$D2,$B2,$AA,$A9,$AA,$AA,$AA,$AC
	.DB $B2,$CC,$D5,$55,$55,$65,$96,$59,$AA,$AA,$9A,$9A,$9A,$AA,$6A,$56
	.DB $A5,$65,$95,$55,$55,$55,$54,$B5,$32,$AA,$AA,$B2,$AA,$B2,$AA,$AB
	.DB $55,$55,$55,$55,$55,$69,$AA,$AA,$96,$9A,$99,$5A,$59,$5A,$55,$65
	.DB $96,$59,$55,$55,$55,$55,$55,$52,$B4,$AA,$AA,$AA,$AA,$B2,$D3,$55
	.DB $55,$55,$55,$55,$56,$55,$66,$AA,$AA,$AA,$AA,$A6,$9A,$AA,$65,$55
	.DB $55,$55,$55,$55,$32,$CC,$AA,$AA,$AA,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$3F,$3F,$3F,$3F,$3F,$FF,$FF,$FF
	.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF
	.DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	