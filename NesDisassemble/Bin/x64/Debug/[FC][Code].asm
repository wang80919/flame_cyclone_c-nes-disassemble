Label_0;EA51
    LDA #$0F
    STA $4015
    LDA #$C0
    STA $4017
    LDA #$1C
    STA <$F0
    LDA #$03
    STA <$F1
    LDX #$00
    LDY #$00
Label_1;EA67
    TYA
    STA [$F0],Y
    STA $0300,X
    CLC
    LDA <$F0
    ADC #$08
    STA <$F0
    BCC Label_2;$EA78
    INC <$F1
Label_2;EA78
    INX
    CPX #$1C
    BNE Label_1;$EA67
    RTS

Label_3;EA7E
    LDA <$6D
    BNE Label_4;$EA88
    LDA #$1C
    STA <$F5
    BPL Label_5;$EA8C
Label_4;EA88
    LDA #$01
    STA <$F5
Label_5;EA8C
    LDA #$00
    LDX #$03
Label_6;EA90
    STA <$F9,X
    DEX
    BPL Label_6;$EA90
    LDA #$00
    STA <$F4
    LDA #$1C
    STA <$F0
    LDA #$03
    STA <$F1
Label_7;EAA1
    LDX <$F4
    LDA $0300,X
    BEQ Label_10;$EAE3
    LDY #$00
    LDA [$F0],Y
    BEQ Label_10;$EAE3
    CMP #$05
    BCC Label_8;$EABD
    SEC
    SBC #$05
    TAX
    LDA #$01
    STA <$F9,X
    JMP Label_10;$EAE3

Label_8;EABD
    TAX
    DEX
    LDA <$F9,X
    BNE Label_10;$EAE3
    LDA #$01
    STA <$F9,X
    TXA
    TAY
    CLC
    ADC #$05
    LDY #$00
    STA [$F0],Y
    TXA
    ASL A
    ASL A
    TAX
    LDA #$04
    STA <$FD
Label_9;EAD8
    INY
    LDA [$F0],Y
    STA $4000,X
    INX
    DEC <$FD
    BNE Label_9;$EAD8
Label_10;EAE3
    CLC
    LDA <$F0
    ADC #$08
    STA <$F0
    BCC Label_11;$EAEE
    INC <$F1
Label_11;EAEE
    INC <$F4
    LDA <$F4
    CMP <$F5
    BCC Label_7;$EAA1
    LDX #$00
Label_12;EAF8
    STX <$FD
    LDA <$F9,X
    BNE Label_13;$EB0A
    TXA
    ASL A
    ASL A
    TAX
    ASL A
    AND #$10
    EOR #$10
    STA $4000,X
Label_13;EB0A
    LDX <$FD
    INX
    CPX #$04
    BCC Label_12;$EAF8
    LDY #$00
    STY <$F4
    LDA #$1C
    STA <$F0
    LDA #$03
    STA <$F1
Label_14;EB1D
    LDX <$F4
    LDA $0300,X
    BEQ Label_15;$EB2E
    CMP #$01
    BNE Label_17;$EB42
    INC $0300,X
    JMP Label_18;$EB4F

Label_15;EB2E
    CLC
    LDA <$F0
    ADC #$08
    STA <$F0
    BCC Label_16;$EB39
    INC <$F1
Label_16;EB39
    INC <$F4
    LDA <$F4
    CMP <$F5
    BCC Label_14;$EB1D
    RTS

Label_17;EB42
    LDY #$07
    LDA [$F0],Y
    SEC
    SBC #$01
    STA [$F0],Y
    BEQ Label_19;$EB85
    BNE Label_15;$EB2E
Label_18;EB4F
    LDA #$00
    LDY #$05
    STA [$F0],Y
    JSR Label_40;$ECAF
    JSR Label_41;$ECBE
    LDY #$00
    STA [$F0],Y
    JSR Label_41;$ECBE
    LDY #$01
    STA [$F0],Y
    JSR Label_41;$ECBE
    LDY #$02
    STA [$F0],Y
    JSR Label_41;$ECBE
    LDY #$04
    STA [$F0],Y
    LDY #$00
    LDA [$F0],Y
    CMP #$04
    BNE Label_20;$EB88
    JSR Label_41;$ECBE
    LDY #$03
    STA [$F0],Y
    BPL Label_20;$EB88
Label_19;EB85
    JSR Label_40;$ECAF
Label_20;EB88
    JSR Label_41;$ECBE
    CMP #$E8
    BCS Label_25;$EBE1
    CMP #$60
    BEQ Label_24;$EBD7
    BCC Label_21;$EB9E
    SBC #$60
    LDY #$06
    STA [$F0],Y
    JMP Label_20;$EB88

Label_21;EB9E
    PHA
    AND #$F8
    LSR A
    LSR A
    TAX
    LDA $ECE6,X
    STA <$FD
    LDA $ECE7,X
    STA <$FE
    PLA
    AND #$07
    BEQ Label_23;$EBBB
    TAX
Label_22;EBB4
    LSR <$FD
    ROR <$FE
    DEX
    BNE Label_22;$EBB4
Label_23;EBBB
    LDY #$04
    LDA [$F0],Y
    AND #$F8
    ORA <$FD
    STA [$F0],Y
    LDA <$FE
    DEY
    STA [$F0],Y
    LDY #$00
    LDA [$F0],Y
    CMP #$05
    BCC Label_24;$EBD7
    SEC
    SBC #$04
    STA [$F0],Y
Label_24;EBD7
    LDY #$06
    LDA [$F0],Y
    INY
    STA [$F0],Y
    JMP Label_15;$EB2E

Label_25;EBE1
    SBC #$E8
    JSR Label_42;$ECD0
Label_26;EBE6
    .DB $0A,$EC,$21,$EC,$33,$EC,$45,$EC,$57,$EC,$61,$EC,$6B,$EC,$75,$EC
    .DB $81,$EC,$85,$EC,$88,$EC,$99,$EC,$99,$EC,$99,$EC,$99,$EC,$99,$EC
    .DB $99,$EC
    
Label_27;EC08
    LDA <$EC
    LDX <$F4
    LDA #$00
    STA $0300,X
    LDY #$00
    STA [$F0],Y
    LDY #$05
    LDA [$F0],Y
    SEC
    SBC #$01
    STA [$F0],Y
    JMP Label_15;$EB2E

Label_28;EC21
    JSR Label_41;$ECBE
    STA <$FD
    LDY #$01
    LDA [$F0],Y
    AND #$3F
    ORA <$FD
    STA [$F0],Y
    JMP Label_20;$EB88

Label_29;EC33
    JSR Label_41;$ECBE
    STA <$FD
    LDY #$01
    LDA [$F0],Y
    AND #$C0
    ORA <$FD
    STA [$F0],Y
    JMP Label_20;$EB88

Label_30;EC45
    JSR Label_41;$ECBE
    STA <$FD
    LDY #$01
    LDA [$F0],Y
    AND #$F0
    ORA <$FD
    STA [$F0],Y
    JMP Label_20;$EB88

Label_31;EC57
    JSR Label_41;$ECBE
    LDY #$02
    STA [$F0],Y
    JMP Label_20;$EB88

Label_32;EC61
    JSR Label_41;$ECBE
    LDY #$04
    STA [$F0],Y
    JMP Label_20;$EB88

Label_33;EC6B
    JSR Label_41;$ECBE
    LDY #$01
    STA [$F0],Y
    JMP Label_20;$EB88

Label_34;EC75
    LDA #$00
    LDX #$02
Label_35;EC79
    STA <$F6,X
    DEX
    BPL Label_35;$EC79
    JMP Label_20;$EB88

Label_36;EC81
    LDX #$00
    BEQ Label_37;$EC8A
    LDX #$01
    BIT $02A2
Label_37;EC8A
    JSR Label_41;$ECBE
    INC <$F6,X
    CMP <$F6,X
    BNE Label_39;$ECA5
    LDA #$00
    STA <$F6,X
    BEQ Label_38;$EC99
Label_38;EC99
    LDY #$05
    LDA [$F0],Y
    CLC
    ADC #$01
    STA [$F0],Y
    JMP Label_20;$EB88

Label_39;ECA5
    JSR Label_41;$ECBE
    LDY #$05
    STA [$F0],Y
    JMP Label_20;$EB88

Label_40;ECAF
    LDA <$F4
    ASL A
    TAX
    LDA $ECFE,X
    STA <$F2
    LDA $ECFF,X
    STA <$F3
    RTS

Label_41;ECBE
    LDA <$F4
    LDY #$05
    LDA [$F0],Y
    TAY
    LDA [$F2],Y
    PHA
    INY
    TYA
    LDY #$05
    STA [$F0],Y
    PLA
    RTS

Label_42;ECD0
    ASL A
    TAY
    INY
    PLA
    STA <$FD
    PLA
    STA <$FE
    LDA [$FD],Y
    TAX
    INY
    LDA [$FD],Y
    STA <$FE
    STX <$FD
    JMP [$FD]

Label_43;ECE6
    .DB $07,$F2,$07,$80,$07,$14,$06,$AE,$06,$43,$05,$F4,$05,$9E,$05,$4E
    .DB $05,$02,$04,$BA,$04,$76,$04,$36,$2C,$EE,$36,$ED,$5D,$ED,$88,$ED
    .DB $9F,$EE,$AE,$EE,$19,$EE,$B3,$ED,$D5,$ED,$48,$EE,$03,$EE,$F4,$ED
    .DB $5E,$EE,$56,$EE,$67,$EE,$12,$EE,$95,$EE,$8C,$EE,$82,$EE,$73,$EE
    .DB $7A,$EE,$C1,$EE,$DF,$EE,$0A,$EF,$3C,$EF,$4F,$EF,$62,$EF,$3A,$EE
    .DB $01,$81,$7F,$40,$EF,$68,$1B,$2B,$33,$F0,$02,$06,$33,$43,$53,$F0
    .DB $02,$0C,$43,$53,$04,$F0,$02,$12,$5B,$0C,$1C,$F0,$02,$18,$78,$1C
    .DB $68,$1C,$1C,$1C,$78,$1C,$E8,$03,$10,$7F,$08,$78,$1A,$68,$1A,$F1
    .DB $03,$07,$78,$32,$68,$32,$F1,$03,$0E,$78,$42,$68,$42,$F1,$03,$15
    .DB $5A,$F1,$03,$19,$0B,$F1,$03,$1D,$78,$52,$68,$52,$F1,$03,$24,$78
    .DB $52,$E8,$02,$81,$7F,$40,$78,$51,$68,$51,$F2,$03,$07,$78,$0A,$68
    .DB $0A,$F2,$03,$0E,$78,$1A,$68,$1A,$F2,$03,$15,$32,$F2,$03,$19,$42
    .DB $F2,$03,$1D,$78,$3A,$68,$3A,$F2,$03,$24,$78,$3A,$E8,$04,$1F,$7F
    .DB $30,$0A,$62,$49,$49,$EA,$1E,$49,$49,$EA,$1D,$49,$49,$EA,$1C,$49
    .DB $49,$EA,$1B,$49,$49,$EA,$1A,$49,$EA,$19,$49,$EA,$18,$49,$E8,$02
    .DB $1F,$7F,$30,$62,$00,$01,$00,$EA,$1E,$01,$00,$EA,$1D,$01,$00,$01
    .DB $00,$EA,$1C,$01,$EA,$1B,$00,$EA,$1A,$01,$EA,$19,$00,$E8,$02,$20
    .DB $7F,$30,$63,$1A,$12,$51,$31,$19,$11,$50,$30,$18,$E8,$04,$1F,$7F
    .DB $40,$0A,$62,$51,$EA,$1E,$51,$EA,$08,$6A,$51,$E8,$01,$8F,$82,$10
    .DB $6F,$2C,$E8,$02,$80,$7F,$40,$63,$52,$1B,$3B,$53,$4A,$13,$33,$4B
    .DB $1B,$3B,$53,$1C,$3C,$E8,$02,$82,$7F,$40,$64,$1B,$2B,$3B,$1C,$2C
    .DB $3C,$6C,$53,$E8,$02,$82,$7F,$40,$63,$53,$1B,$1C,$3B,$3C,$53,$6A
    .DB $54,$E8,$02,$60,$7F,$40,$64,$52,$3A,$52,$03,$52,$03,$13,$1B,$E8
    .DB $02,$D5,$7F,$00,$62,$1C,$1D,$E8,$03,$07,$7F,$08,$61,$3A,$13,$22
    .DB $E8,$02,$40,$7F,$00,$61,$3D,$62,$45,$EA,$10,$28,$E8,$02,$80,$7F
    .DB $18,$61,$39,$E8,$04,$00,$7F,$28,$0A,$61,$28,$E8,$02,$8C,$94,$40
    .DB $61,$10,$64,$18,$F9,$05,$02,$80,$94,$48,$62,$40,$48,$F9,$05,$01
    .DB $1F,$7F,$28,$61,$22,$42,$5A,$1B,$E8,$01,$A0,$7F,$40,$66,$1C,$3C
    .DB $1C,$53,$1C,$3C,$05,$72,$54,$E8,$02,$90,$7F,$40,$62,$38,$66,$EA
    .DB $20,$3B,$53,$3B,$1B,$3B,$53,$1C,$6A,$14,$E8,$01,$B8,$7F,$40,$EF
    .DB $65,$0C,$53,$F0,$0C,$05,$0C,$53,$F0,$0C,$0B,$34,$24,$F0,$08,$10
    .DB $EA,$30,$B0,$50,$EA,$20,$9C,$54,$E8,$02,$B8,$7F,$40,$65,$43,$33
    .DB $F1,$0C,$04,$43,$33,$F1,$0C,$0A,$14,$4B,$F1,$08,$0F,$EA,$3A,$30
    .DB $50,$09,$29,$31,$51,$0A,$2A,$32,$52,$0B,$2B,$33,$53,$0C,$2C,$9C
    .DB $EA,$20,$2C,$E8,$03,$00,$7F,$08,$A1,$01,$01,$EE,$15,$6A,$0B,$0B
    .DB $0B,$EE,$22,$6F,$33,$65,$43,$7E,$EE,$33,$53,$6A,$EE,$15,$43,$33
    .DB $53,$6F,$EE,$22,$13,$65,$23,$7E,$EE,$33,$33,$6A,$EE,$15,$23,$13
    .DB $4A,$9C,$EE,$FF,$32,$E8,$01,$42,$7F,$40,$66,$1B,$0B,$78,$1B,$68
    .DB $52,$42,$32,$1A,$1A,$1A,$78,$1A,$E8,$02,$82,$7F,$40,$66,$52,$52
    .DB $78,$52,$68,$32,$2A,$12,$1A,$1A,$1A,$78,$1A,$E8,$03,$10,$7F,$08
    .DB $66,$3B,$33,$78,$3B,$68,$1B,$0B,$52,$52,$52,$52,$78,$52,$E8,$FF
    
Label_44;EF76
    PHA
    JSR Label_0;$EA51
    PLA
    ASL A
    TAX
    LDY $EF8E,X
    LDA $EF8F,X
    TAX
    LDA #$01
Label_45;EF86
    STA $0300,Y
    INY
    DEX
    BNE Label_45;$EF86
    RTS

