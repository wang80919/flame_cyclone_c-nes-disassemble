Label_EA7E
    LDA <$6D
    BNE Label_EA88
    LDA #$1C
    STA <$F5
    BPL Label_EA8C
Label_EA88
    LDA #$01
    STA <$F5
Label_EA8C
    LDA #$00
    LDX #$03
Label_EA90
    STA <$F9,X
    DEX
    BPL Label_EA90
    LDA #$00
    STA <$F4
    LDA #$1C
    STA <$F0
    LDA #$03
    STA <$F1
Label_EAA1
    LDX <$F4
    LDA $0300,X
    BEQ Label_EAE3
    LDY #$00
    LDA [$F0],Y
    BEQ Label_EAE3
    CMP #$05
    BCC Label_EABD
    SEC
    SBC #$05
    TAX
    LDA #$01
    STA <$F9,X
    JMP Label_EAE3
Label_EABD
    TAX
    DEX
    LDA <$F9,X
    BNE Label_EAE3
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
Label_EAD8
    INY
    LDA [$F0],Y
    STA $4000,X
    INX
    DEC <$FD
    BNE Label_EAD8
Label_EAE3
    CLC
    LDA <$F0
    ADC #$08
    STA <$F0
    BCC Label_EAEE
    INC <$F1
Label_EAEE
    INC <$F4
    LDA <$F4
    CMP <$F5
    BCC Label_EAA1
    LDX #$00
Label_EAF8
    STX <$FD
    LDA <$F9,X
    BNE Label_EB0A
    TXA
    ASL A
    ASL A
    TAX
    ASL A
    AND #$10
    EOR #$10
    STA $4000,X
Label_EB0A
    LDX <$FD
    INX
    CPX #$04
    BCC Label_EAF8
    LDY #$00
    STY <$F4
    LDA #$1C
    STA <$F0
    LDA #$03
    STA <$F1
Label_EB1D
    LDX <$F4
    LDA $0300,X
    BEQ Label_EB2E
    CMP #$01
    BNE Label_EB42
    INC $0300,X
    JMP Label_EB4F
Label_EB2E
    CLC
    LDA <$F0
    ADC #$08
    STA <$F0
    BCC Label_EB39
    INC <$F1
Label_EB39
    INC <$F4
    LDA <$F4
    CMP <$F5
    BCC Label_EB1D
    RTS
Label_EB42
    LDY #$07
    LDA [$F0],Y
    SEC
    SBC #$01
    STA [$F0],Y
    BEQ Label_EB85
    BNE Label_EB2E
Label_EB4F
    LDA #$00
    LDY #$05
    STA [$F0],Y
    JSR Label_ECAF
    JSR Label_ECBE
    LDY #$00
    STA [$F0],Y
    JSR Label_ECBE
    LDY #$01
    STA [$F0],Y
    JSR Label_ECBE
    LDY #$02
    STA [$F0],Y
    JSR Label_ECBE
    LDY #$04
    STA [$F0],Y
    LDY #$00
    LDA [$F0],Y
    CMP #$04
    BNE Label_EB88
    JSR Label_ECBE
    LDY #$03
    STA [$F0],Y
    BPL Label_EB88
Label_EB85
    JSR Label_ECAF
Label_EB88
    JSR Label_ECBE
    CMP #$E8
    BCS Label_EBE1
    CMP #$60
    BEQ Label_EBD7
    BCC Label_EB9E
    SBC #$60
    LDY #$06
    STA [$F0],Y
    JMP Label_EB88