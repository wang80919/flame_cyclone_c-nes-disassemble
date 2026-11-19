;文件头
NES_16KB_PRG_SIZE           = 2
NES_8KB_CHR_SIZE            = 1
MAPPER_NUMBER               = 4
BANK_DATA_MASK              = NES_16KB_PRG_SIZE * 2 - 1     ;bank号掩码
RESET_BANK                  = NES_16KB_PRG_SIZE * 2 - 1
;======================================================================
PRG_DATA_BANK_C000          = NES_16KB_PRG_SIZE * 2 - 2
PRG_DATA_BANK_E000          = NES_16KB_PRG_SIZE * 2 - 1
;======================================================================
 .INESPRG NES_16KB_PRG_SIZE                              ;16KB PRG 数量
 .INESCHR NES_8KB_CHR_SIZE                                ;8KB CHR 数量
 .INESMAP MAPPER_NUMBER                                       ;mapper号
 .INESSUBMAP 0
 .INESMIR 0                                     ;命名表镜像 0水平 1垂直
 .INESPRGRAM 7
 .INESPRGNVRAM 0
 .INESCHRRAM 7
 .INESCHRNVRAM 0
 .INESBAT 0
 .INESTIM 0
 
 .BANK 03
 
 .ORG $EA51
 .INCLUDE "[FC][Code].asm"
 
 .ORG $F000

ResetProgram
    SEI
    CLD
    LDA #$00
    STA $2000
    STA $2001

Main_Loop
    JMP Main_Loop


NmiProgram
IrqProgram
    RTI
    
 .ORG $FFFA
 .WORD NmiProgram
 .WORD ResetProgram
 .WORD IrqProgram