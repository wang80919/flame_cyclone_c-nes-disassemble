#pragma once
#include <stdint.h>
#include <string>
#include <map>
#include <vector>
#include <tchar.h>
#include "C6502Introduction.h"

#ifdef _UNICODE
using _tstring = std::wstring;
#else
using _tstring = std::string;
#endif

// 反汇编数据信息
typedef struct _ASM_DATA_INFO
{
    uint16_t addr = 0;
    int16_t org = 0;
    uint16_t bank = 0;
    eBankSize bank_size = eBankSize::eBank_None;
    bool fData = false;
    bool fDataIndex = false;
    bool fProgramIndex = false;
    bool fIgnore = false;
    std::vector<uint8_t> data;
    _tstring name;

    void clear()
    {
        data.clear();
        name.clear();
        org = 0;
        bank_size = eBankSize::eBank_None;
        bank = 0;
        fDataIndex = false;
        fProgramIndex = false;
        fData = false;
        fIgnore = false;
        addr = 0;
    }

    bool operator < (const _ASM_DATA_INFO& r) const
    {
        return addr < r.addr;
    }

}ASM_DATA_INFO;

// 反汇编输入信息
typedef struct _ASM_INPUT_INFO
{
    _tstring    label_name;                             // 标签名
    eBankSize   bank_size   = eBankSize::eBank_None;    // bank 大小
    uint16_t    bank_index  = 0;                        // bank 号
    uint16_t    org         = 0;                        // 编译地址
    uint16_t    addr        = (uint16_t)0;              // 起始地址
    uint16_t    size        = (uint16_t)0;              // 数据长度
    uint16_t    elem_size   = 1;                        // 元素长度
    bool        fData       = false;                    // 数据标志

    _ASM_INPUT_INFO(uint16_t addr = 0, uint16_t length = 1, uint8_t elem = 1)
        :
        addr(addr),
        size(length),
        elem_size(elem)
    {

    }

}ASM_INPUT_INFO;

//获取指令格式
_tstring GetIntroductionText(
    const std::map<uint16_t, C6502Introduction>& introductionList,
    const C6502Introduction& Introduction, 
    const _tstring& strLabel = _T(""), 
    bool b6502SimulatorSyntax = false, 
    bool bShowAddr = false
);

//
// @brief: 反汇编文本输入
// @param: strInput             输入文本
// @ret: _tstring               字符串
_tstring DisassembleText(
    const _tstring& strInput, 
    const _tstring& strLabelName, 
    uint16_t loadAddr,
    bool fShowAddr, 
    uint16_t dwSyntaxType
);

//
// @brief: 获取反汇编指令列表
// @param: introductionList     存放指令列表
// @param: dataList             保留的数据列表
// @param: programList          编译地址列表
// @param: pBaseAddr            反汇编数据地址
// @param: size                 数据地址大小
// @ret: void
void DisassembleInstructions(
    std::map<uint16_t, C6502Introduction>& introductionList,
    const std::map<uint16_t, ASM_INPUT_INFO>& programList,
    const std::map<uint16_t, ASM_INPUT_INFO>& dataList,
    uint8_t* pBaseAddr,
    uint32_t size
);

//
// @brief: 获取反汇编指令列表
// @param: introductionList     存放指令列表
// @param: strLabel             标签名
// @ret: _tstring               字符串
_tstring GetDisassembleText(
    const std::map<uint16_t, C6502Introduction>& introductionList,
    const _tstring& strLabel,
    uint8_t* pBaseAddr,
    uint32_t size,
    bool bShowAddr = true,
    bool b6502SimulatorSyntax = false
);
