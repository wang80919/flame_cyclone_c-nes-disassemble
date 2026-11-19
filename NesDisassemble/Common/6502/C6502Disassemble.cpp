#include "C6502Disassemble.h"
#include <strsafe.h>
#include <Windows.h>
#include <set>
#include "Win32Utils/CStrUtils.h"
#include "Win32Utils/CBytesUtils.h"

const int FORMAT_COUNT_MAX = (1024 * 1024 * 64);
_tstring Format(LPCTSTR pFormat, ...)
{
    size_t nCchCount = MAX_PATH;
    _tstring strResult(nCchCount, 0);
    va_list args;

    va_start(args, pFormat);

    do
    {
        //格式化输出字符串
        int nSize = _vsntprintf_s(&strResult[0], nCchCount, _TRUNCATE, pFormat, args);
        if (-1 != nSize)
        {
            strResult.resize(nSize);
            break;
        }

        //缓冲大小超限终止
        if (nCchCount >= FORMAT_COUNT_MAX)
        {
            break;
        }

        //重新分配缓冲
        nCchCount *= 2;
        strResult.resize(nCchCount);

    } while (true);

    va_end(args);

    return strResult;
}

_tstring GetIntroductionText(
    const std::map<uint16_t, C6502Introduction>& introductionList,
    const C6502Introduction& Introduction, 
    const _tstring& strLabel/* = _T("")*/, 
    bool b6502SimulatorSyntax/* = false*/, 
    bool bShowAddr/* = false*/
)
{
    _tstring strResult;
    _tstring strData;

    e6502AddressingMode AddrMode = Introduction.GetAddressingMode();
    uint16_t intData = Introduction.GetData();
    _tstring strName = Introduction.GetName();
    uint16_t refID = Introduction.GetRefID();
    uint16_t callAddr = Introduction.GetCallAddr();
    _tstring strCall;

    if (AddrMode == eModeReserved)
    {
        return strResult;
    }

    // 零页寻址
    if (e6502AddressingMode::eModeZeroPage == AddrMode ||
        e6502AddressingMode::eModeZeroPageX == AddrMode ||
        e6502AddressingMode::eModeZeroPageY == AddrMode)
    {
        if (!b6502SimulatorSyntax)
        {
            strData = _T("<");
        }
    }

    if ((AddrMode >= eModeZeroPage && AddrMode < eModeReserved))
    {
        if (intData < 0x100)
        {
            strData += Format(_T("Zero_%02X"), intData);
        }
        else if (intData < 0x800)
        {
            strData += Format(_T("Absolute_%04X"), intData);
        }
        else
        {
            strData += Format(_T("$%04X"), intData);
        }
    }

    do
    {
        // 输出指令名
        strResult = Format(_T("%s"), strName.c_str());

        if (e6502AddressingMode::eModeAccumulator == AddrMode)
        {
            if (!b6502SimulatorSyntax)
            {
                strResult += Format(_T(" A"));
            }
            break;
        }

        // 立即寻址
        if (e6502AddressingMode::eModeImmediate == AddrMode)
        {
            strResult += Format(_T(" #$%02X"), (uint8_t)intData);
            break;
        }

        // 调用或跳转相关指令
        if ((Introduction.IsRelative() || Introduction.IsJsrOrJmpAbsolute()))
        {
            auto itFind = introductionList.find(callAddr);
            if (introductionList.end() != itFind)
            {
                if (!itFind->second.m_label_name.empty())
                {
                    strData = itFind->second.m_label_name;
                }
                else
                {
                    if ((uint16_t)-1 != Introduction.m_refId)
                    {
                        if (!strLabel.empty())
                        {
                            strData = Format(_T("%s%d"), strLabel.c_str(), Introduction.m_refId);
                        }
                        else
                        {
                            strData = Format(_T("Label_%04X"), Introduction.GetCallAddr());
                        }
                    }
                    else
                    {
                        strData = Format(_T("$%04X"), callAddr);
                    }
                }
            }
            else
            {
                if ((uint16_t)-1 != Introduction.m_refId)
                {
                    if (!strLabel.empty())
                    {
                        strData = Format(_T("%s%d"), strLabel.c_str(), Introduction.m_refId);
                    }
                    else
                    {
                        strData = Format(_T("Label_%04X"), Introduction.GetCallAddr());
                    }
                }
                else
                {
                    if (strData.empty())
                    {
                        strData = Format(_T("$%04X"), callAddr);
                    }
                }
            }

            strCall = Format(_T(";$%04X"), callAddr);
        }

        // 绝对寻址
        else if (e6502AddressingMode::eModeAbsolute == AddrMode ||
            e6502AddressingMode::eModeAbsoluteX == AddrMode ||
            e6502AddressingMode::eModeAbsoluteY == AddrMode)
        {
            // 根据地址查找标签名
            auto itRef = introductionList.find(Introduction.m_refAddr);
            if (introductionList.end() != itRef)
            {
                if (!itRef->second.m_label_name.empty())
                {
                    strData = Format(_T("%s"), itRef->second.m_label_name.c_str());
                }
                else
                {
                    if (!strLabel.empty())
                    {
                        strData = Format(_T("%s%d"), strLabel.c_str(), Introduction.m_refId);
                    }
                    else
                    {
                        strData = Format(_T("Label_%04X"), Introduction.GetCallAddr());
                    }
                }
            }

            if (Introduction.m_offset)
            {
                strData += Format(_T(" + %d"), Introduction.m_offset);
            }

            if (e6502AddressingMode::eModeAbsoluteX == AddrMode)
            {
                strData += _T(",X");
            }
            if (e6502AddressingMode::eModeAbsoluteY == AddrMode)
            {
                strData += _T(",Y");
            }
            strData += Format(_T(" ;$%04X"), intData);
        }

        // 零页寻址
        if (e6502AddressingMode::eModeZeroPage == AddrMode || 
            e6502AddressingMode::eModeZeroPageX == AddrMode || 
            e6502AddressingMode::eModeZeroPageY == AddrMode)
        {
            // 零页X变址
            if (e6502AddressingMode::eModeZeroPageX == AddrMode)
            {
                strData += _T(",X");
            }

            // 零页Y变址
            if (e6502AddressingMode::eModeZeroPageY == AddrMode)
            {
                strData += _T(",Y");
            }
        }

        // 间接寻址
        if (e6502AddressingMode::eModeIndirect == AddrMode)
        {
            if (b6502SimulatorSyntax)
            {
                strResult += Format(_T(" (%s)"), strData.c_str());
            }
            else
            {
                strResult += Format(_T(" [%s]"), strData.c_str());
            }
            break;
        }

        // 先变址寻址后间接寻址
        if (e6502AddressingMode::eModeIndexedIndirect == AddrMode)
        {
            if (b6502SimulatorSyntax)
            {
                strResult += Format(_T(" (%s,X)"), strData.c_str());
            }
            else
            {
                strResult += Format(_T(" [%s,X]"), strData.c_str());
            }
            strResult += Format(_T(" ;$%04X"), Introduction.m_addr);
            break;
        }

        // 先间接寻址后变址寻址
        if (e6502AddressingMode::eModeIndirectIndexed == AddrMode)
        {
            if (b6502SimulatorSyntax)
            {
                strResult += Format(_T(" (%s),Y"), strData.c_str());
            }
            else
            {
                strResult += Format(_T(" [%s],Y"), strData.c_str());
            }
            strResult += Format(_T(" ;$%04X"), Introduction.m_addr);
            break;
        }

        if (!strData.empty())
        {
            strResult += Format(_T(" %s"), strData.c_str());
            if (bShowAddr && !strCall.empty())
            {
                strResult += Format(_T(" ;$%04X"), callAddr);
            }
            break;
        }

    } while (false);

    return strResult;
}

//
// @brief: 获取指令列表
// @param: Introductions      指令列表
// @param: DataReserved         保留的数据
// @param: pBaseAddr            反汇编数据地址
// @param: size                 数据大小
// @param: addr                 反汇编地址
// @param: depth                递归深度
// @ret: void
static void _DisassembleInstructions(
    std::map<uint16_t, C6502Introduction>& introductionList,
    const std::map<uint16_t, ASM_INPUT_INFO>& dataList,
    uint8_t* pBaseAddr,
    uint32_t size,
    const ASM_INPUT_INFO& info,
    int32_t depth = 8
);

_tstring GetDisassembleText(
    const std::map<uint16_t, C6502Introduction>& introductionList,
    const _tstring& strLabel,
    uint8_t* pBaseAddr,
    uint32_t size,
    bool bShowAddr/* = false*/,
    bool b6502SimulatorSyntax/* = false*/
)
{
    LPBYTE lpData = pBaseAddr;
    _tstring strResult;
    _tstring strOutput;

    std::set<uint16_t> addrList;

    _tstring strLabelName = strLabel;

    for (auto& item : introductionList)
    {
        // 输出 bank 号
        switch (item.second.m_bank_size)
        {
        case eBankSize::eBank_32:
            strOutput += CStrUtils::Format(_T("    .BANK32 %d\r\n"), item.second.m_bank_index);
            break;
        case eBankSize::eBank_16:
            strOutput += CStrUtils::Format(_T("    .BANK16 %d\r\n"), item.second.m_bank_index);
            break;
        case eBankSize::eBank_8:
            strOutput += CStrUtils::Format(_T("    .BANK8 %d\r\n"), item.second.m_bank_index);
            break;
        }

        // 输出 org
        if (item.second.m_org)
        {
            strOutput += CStrUtils::Format(_T("    .ORG $%.4X\r\n"), item.second.m_org);
        }

        // 输出标签
        if (item.second.IsLabbeled())
        {
            if (!item.second.m_label_name.empty())
            {
                strOutput += CStrUtils::Format(_T("%s"), item.second.m_label_name.c_str());
            }
            else
            {
                if (strLabelName.empty())
                {
                    strOutput += CStrUtils::Format(_T("Label_%.4X"), item.second.GetAddr());
                }
                else
                {
                    strOutput += CStrUtils::Format(_T("%s%d"), strLabelName.c_str(), item.second.m_id);
                }
            }

            if (bShowAddr)
            {
                strOutput += CStrUtils::Format(_T(" ;$%04X"), item.second.GetAddr());
            }

            strOutput += CStrUtils::Format(_T("\r\n"));
        }

        if (item.second.IsReserved())
        {
            if (1 == item.second.GetElemSize())
            {
                uint16_t addr = item.second.GetAddr();
                int16_t dataSize = item.second.GetData();
                if (dataSize > 0)
                {
                    _tstring strDB = _T("    .DB ");
                    for (int i = 0; i < dataSize; i++)
                    {
                        if (0 != i && (0 == i % 16))
                        {
                            strDB += _T("\r\n    .DB ");
                        }

                        if (0 == i % 16)
                        {
                            strDB += CStrUtils::Format(_T("$%02X"), lpData[addr + i]);
                        }
                        else
                        {
                            strDB += CStrUtils::Format(_T(",$%02X"), lpData[addr + i]);
                        }
                    }

                    strOutput += strDB;
                    strOutput += _T("\r\n");
                }
            }

            if (2 == item.second.GetElemSize())
            {
                uint16_t addr = item.second.GetAddr();
                int16_t dataSize = item.second.GetData();

                if (dataSize > 0)
                {
                    _tstring strDB = _T("    .DW ");
                    for (int i = 0; i < dataSize; i += 2)
                    {
                        if (0 != i && (0 == i % 2))
                        {
                            strDB += _T("\r\n    .DW ");
                        }

                        uint16_t data = lpData[addr + i] | (lpData[addr + i + 1] << 8);

                        auto itFind = introductionList.find(data);
                        if (itFind != introductionList.end())
                        {
                            _tstring strData;

                            if (!itFind->second.m_label_name.empty())
                            {
                                strData = itFind->second.m_label_name;
                            }
                            else
                            {
                                if ((uint16_t)(-1) != itFind->second.m_id)
                                {
                                    if (strLabelName.empty())
                                    {
                                        strData = CStrUtils::Format(_T("Label_%.4X"), itFind->second.GetAddr());
                                    }
                                    else
                                    {
                                        strData = CStrUtils::Format(_T("%s%d"), strLabelName.c_str(), itFind->second.m_id);
                                    }
                                }
                                else
                                {
                                    strData = CStrUtils::Format(_T("$%04X"), data);
                                }
                            }

                            if (bShowAddr)
                            {
                                strData += CStrUtils::Format(_T(" ;$%04X"), data);
                            }

                            strDB += strData.c_str();
                        }
                        else
                        {
                            if (0 == i % 2)
                            {
                                strDB += CStrUtils::Format(_T("$%04X"), data);
                            }
                            else
                            {
                                strDB += CStrUtils::Format(_T(",$%04X"), data);
                            }
                        }
                    }

                    strOutput += strDB;
                    strOutput += _T("\r\n");
                }
            }
        }
        else
        {
            e6502AddressingMode AddrMode = item.second.GetAddressingMode();
            uint16_t intData = item.second.GetData();
            if ((AddrMode >= eModeZeroPage && AddrMode < eModeReserved) && intData < 0x800)
            {
                addrList.insert(intData);
            }

            strOutput += CStrUtils::Format(_T("    %s\r\n"), GetIntroductionText(introductionList, item.second, strLabel, b6502SimulatorSyntax, bShowAddr).c_str());
            if (item.second.GetName() == _T("JMP") || item.second.GetName() == _T("RTS"))
            {
                strOutput += _T("\r\n");
            }
        }
    }

    for (const auto& item : addrList)
    {
        if (item < 0x100)
        {
            strResult += Format(_T("Zero_%02X = $%02X"), item, item);
        }
        else if (item < 0x800)
        {
            strResult += Format(_T("Absolute_%04X = $%04X"), item, item);
        }

        strResult += _T("\r\n");
    }

    if (!strResult.empty())
    {
        strResult += _T("\r\n");
    }

    strResult += strOutput;

    return strResult;
}

std::map<_tstring, _tstring> GetKeyValue(const _tstring& strLine)
{
    std::map<_tstring, _tstring> mapResult;
    std::vector<_tstring> strList = CStrUtils::SplitStr(strLine, _T(";"));

    for (const auto& item : strList)
    {
        auto chPos = item.find(_T("="));
        if (_tstring::npos != chPos)
        {
            _tstring strKey = item.substr(0, chPos);
            _tstring strValue = CStrUtils::RemoveSpaces(item.substr(chPos + 1));

            if ('$' == strValue.front())
            {
                strValue = strValue.substr(1);
            }

            mapResult.emplace(strKey, strValue);
        }
        else
        {
            mapResult.emplace(item, _T(""));
        }
    }

    return mapResult;
}

void DisassembleInstructions(
    std::map<uint16_t, C6502Introduction>& IntroductionSet,
    const std::map<uint16_t, ASM_INPUT_INFO>& programList,
    const std::map<uint16_t, ASM_INPUT_INFO>& dataList,
    uint8_t* pBaseAddr,
    uint32_t size
)
{
    //设置保留数据段
    for (const auto& item : dataList)
    {
        C6502Introduction info(00, _T("Data"), e6502AddressingMode::eModeReserved, item.first, item.second.size, item.second.elem_size, true, true);
        info.m_org = item.second.org;
        info.m_bank_index = item.second.bank_index;
        info.m_bank_size = item.second.bank_size;
        info.m_label_name = item.second.label_name;

        IntroductionSet.insert(std::make_pair(item.first, info));
    }

    //反汇编每个指定地址
    for (const auto& item : programList)
    {
        _DisassembleInstructions(IntroductionSet, dataList, pBaseAddr, size, item.second, 16);
    }

    for (const auto& item : programList)
    {
        auto itFind = IntroductionSet.find(item.first);
        if (IntroductionSet.end() != itFind)
        {
            itFind->second.m_label_name = item.second.label_name;
        }
    }

    // 标记可以设置标签

    for (auto it = IntroductionSet.begin(); it != IntroductionSet.end(); it++)
    {
        if (_T("JMP") == it->second.GetName() ||
            _T("JSR") == it->second.GetName() ||
            _T("RTS") == it->second.GetName()
            )
        {
            auto nextItem = it;
            nextItem++;
            if (nextItem != IntroductionSet.end() && !nextItem->second.IsReserved())
            {
                if (_T("RTS") != nextItem->second.GetName())

                nextItem->second.SetLabbeled(true);
            }
        }
    }

    // 标签排序
    std::map<uint16_t, uint16_t> labelCount;
    uint16_t nLabelIndex = 0;
    for (auto& item : IntroductionSet)
    {
        if (programList.end() != programList.find(item.first))
        {
            item.second.SetLabbeled(true);
        }

        if (item.second.IsLabbeled()/* && item.second.m_label_name.empty()*/)
        {
            item.second.m_id = nLabelIndex;
            nLabelIndex++;
        }
    }

    // 调用引用标签处理
    for (auto& item : IntroductionSet)
    {
        if (item.second.IsJsrOrJmpAbsolute() || item.second.IsRelative())
        {
            auto data = IntroductionSet.find(item.second.GetCallAddr());
            if (data != IntroductionSet.end())
            {
                item.second.SetRefID(data->second.m_id);
            }
        }
    }

    // 绝对寻址引用标签处理
    for (auto& item : IntroductionSet)
    {
        if (item.second.IsAbsoluteRead())
        {
            uint16_t data = item.second.GetData();

            auto itFind = IntroductionSet.find(data);
            if (itFind != IntroductionSet.end())
            {
                item.second.SetRefID(itFind->second.m_id);
                item.second.m_refAddr = itFind->first;
                item.second.m_offset = data - itFind->first;
            }
            else
            {
                for (auto& info : dataList)
                {
                    if (data >= info.first && data < (info.first + info.second.size))
                    {
                        auto itFind = IntroductionSet.find(info.first);
                        if (IntroductionSet.end() != itFind)
                        {
                            item.second.m_refAddr = itFind->first;
                            item.second.m_offset = data - itFind->first;
                            break;
                        }
                    }
                }
            }
        }
    }

    return;
}

void _DisassembleInstructions(
    std::map<uint16_t, C6502Introduction>& introductionList,
    const std::map<uint16_t, ASM_INPUT_INFO>& dataList,
    uint8_t* pBaseAddr,
    uint32_t size,
    const ASM_INPUT_INFO& info,
    int32_t depth/* = 8*/
)
{
    //检测递归深度
    if (depth < 0)
    {
        return;
    }

    //反汇编地址检查
    uint8_t* pBegin = pBaseAddr + info.addr;
    if (pBegin >= pBaseAddr + size)
    {
        return;
    }

    uint16_t tmpAddr = info.addr;

    do
    {
        //查找指令, 找不到则结束
        auto itIntroduction = g_6502_Introduction_Set.find(*pBegin);
        if (itIntroduction == g_6502_Introduction_Set.end())
        {
            break;
        }

        bool bBreak = false;
        //遇到数据段则跳过
        for (const auto& item : dataList)
        {
            if (item.second.fData && (tmpAddr >= item.first) && (tmpAddr < (item.first + item.second.size)))
            {
                pBegin += item.second.size;
                tmpAddr += item.second.size;
                bBreak = true;
                break;
            }
        }

        if (bBreak)
        {
            continue;
        }

        C6502Introduction Introduction(itIntroduction->second);
        uint8_t* pData = pBegin + 1;

        //首个指令设置一个标签记号
        if (info.addr == tmpAddr)
        {
            Introduction.SetLabbeled(true);
        }

        //获取指令数据
        if (1 == Introduction.GetDataSize())
        {
            uint8_t data = *(pData);
            Introduction.SetData(data);
        }
        else if (2 == Introduction.GetDataSize())
        {
            Introduction.SetData(*(uint16_t*)pData);
        }

        //设置指令地址
        Introduction.SetAddr(tmpAddr);

        //记录指令
        introductionList.insert(std::make_pair((uint16_t)tmpAddr, Introduction));

        //遇到 相对跳转 或 JSR 或 JMP调用 子程序, 则递归处理
        if (Introduction.IsRelative() || Introduction.IsJsrOrJmpAbsolute())
        {
            uint16_t callAddr = Introduction.GetCallAddr();
            auto itFind = introductionList.find(callAddr);
            if (introductionList.end() == itFind)
            {
                _DisassembleInstructions(introductionList, dataList, pBaseAddr, size, callAddr, depth - 1);
            }
            else
            {
                itFind->second.SetLabbeled(true);
            }
        }

        //遇到子程序返回则结束
        if (_T("RTS") == Introduction.GetName())
        {
            // break;
        }

        //遇到中断返回则结束
        if (_T("RTI") == Introduction.GetName())
        {
            // break;
        }

        //遇到JMP跳转则结束
        if (_T("JMP") == Introduction.GetName())
        {
            // break;
        }

        //遇到子程序返回则结束
        if (_T("INT") == Introduction.GetName())
        {
            //break;
        }

        //解析指针向后增加
        pBegin += itIntroduction->second.GetSize();

        //指令地址向后增加
        tmpAddr += itIntroduction->second.GetSize();

    } while (pBegin < pBaseAddr + size);
}

_tstring DisassembleText(
    const _tstring& strInput,
    const _tstring& strLabelName,
    uint16_t loadAddr,
    bool fShowAddr,
    uint16_t dwSyntaxType
)
{
    std::vector<_tstring> strLines = CStrUtils::SplitLines(strInput);
    std::set<ASM_DATA_INFO> AsmProgramList;
    std::set<ASM_DATA_INFO> AsmDataList;
    std::map<_tstring, std::set<uint16_t>> mapNameAddrList;
    std::set<uint16_t> ProgramAddrSet;
    std::set<uint16_t> DataAddrSet;

    // 索引数据记录
    std::map<uint16_t, bool> mapDataIndex;

    //分配 64KB 缓冲空间
    std::vector<uint8_t> dataBuffer(1024 * 64, 0xFF);
    LPBYTE lpData = dataBuffer.data();
    uint16_t startAddr = loadAddr;
    uint32_t dataAddr = startAddr;

    // 解析获得大致输入信息
    ASM_DATA_INFO dataInfo;
    for (const auto& line : strLines)
    {
        if (line.size() < 2)
        {
            continue;
        }

        if (_T('#') == line.front() || _T(';') == line.front())
        {
            continue;
        }

        if ((_T('[') == line.front() && _T(']') == line.back()) ||
            (_T('(') == line.front() && _T(')') == line.back()) ||
            (_T('{') == line.front() && _T('}') == line.back())
            )
        {
            dataInfo.addr = startAddr;
            if (!dataInfo.data.empty())
            {
                if (dataInfo.fData)
                {
                    AsmDataList.emplace(dataInfo);
                }
                else
                {
                    AsmProgramList.emplace(dataInfo);
                }

                if (startAddr + dataInfo.data.size() < 0x10000)
                {
                    memcpy_s(lpData + startAddr, dataBuffer.size(), dataInfo.data.data(), dataInfo.data.size());
                }

                startAddr += dataInfo.data.size();
                if (dataInfo.fDataIndex && !dataInfo.data.empty())
                {
                    const uint16_t* pData = (uint16_t*)dataInfo.data.data();
                    size_t nCount = dataInfo.data.size() / 2;
                    while (nCount > 0)
                    {
                        mapDataIndex.emplace(*pData, false);
                        pData++;
                        nCount--;
                    }
                }

                if (dataInfo.fProgramIndex && !dataInfo.data.empty())
                {
                    const uint16_t* pData = (uint16_t*)dataInfo.data.data();
                    size_t nCount = dataInfo.data.size() / 2;
                    while (nCount > 0)
                    {
                        ProgramAddrSet.emplace(*pData);
                        pData++;
                        nCount--;
                    }
                }

                dataInfo.clear();
            }

            _tstring strLine = line.substr(1, line.size() - 2);
            std::map<_tstring, _tstring> KeyValue = GetKeyValue(strLine);

            if (_T('[') == line.front())
            {
                dataInfo.fData = true;
            }
            else if (_T('(') == line.front())
            {
                dataInfo.fData = true;
                dataInfo.fIgnore = true;
            }
            else
            {
                dataInfo.fData = false;
            }

            // 输入文本解析
            for (const auto& item : KeyValue)
            {
                if (item.first == _T("org"))
                {
                    dataInfo.org = CStrUtils::StrToInt(item.second, 16);
                    continue;
                }

                if (item.first == _T("data"))
                {
                    if (item.second == _T("true"))
                    {
                        dataInfo.fData = true;
                    }
                    else
                    {
                        dataInfo.fData = false;
                    }
                    continue;
                }

                if (item.first == _T("name"))
                {
                    dataInfo.name = item.second;
                    continue;
                }

                if (item.first == _T("bank32"))
                {
                    dataInfo.bank_size = eBankSize::eBank_32;
                    dataInfo.bank = CStrUtils::StrToInt(item.second, 16);
                    continue;
                }

                if (item.first == _T("bank16"))
                {
                    dataInfo.bank_size = eBankSize::eBank_16;
                    dataInfo.bank = CStrUtils::StrToInt(item.second, 16);
                    continue;
                }

                if (item.first == _T("bank8"))
                {
                    dataInfo.bank_size = eBankSize::eBank_8;
                    dataInfo.bank = CStrUtils::StrToInt(item.second, 16);
                    continue;
                }

                if (item.first == _T("data_index"))
                {
                    if (item.second == _T("true"))
                    {
                        dataInfo.fDataIndex = true;
                    }
                    continue;
                }

                if (item.first == _T("program_index"))
                {
                    if (item.second == _T("true"))
                    {
                        dataInfo.fProgramIndex = true;
                    }
                    continue;
                }

                // 索引表处理
                if (item.first == _T("index_list"))
                {
                    std::vector<_tstring> addrList = CStrUtils::SplitStr(item.second, _T(","));

                    for (const auto& item : addrList)
                    {
                        mapDataIndex.emplace(CStrUtils::StrToInt(CStrUtils::RemoveSpaces(item), 16), true);
                    }

                    continue;
                }

                if (item.first == _T("data_list"))
                {
                    std::vector<_tstring> addrList = CStrUtils::SplitStr(item.second, _T(","));

                    for (const auto& item : addrList)
                    {
                        DataAddrSet.emplace(CStrUtils::StrToInt(CStrUtils::RemoveSpaces(item), 16));
                    }

                    continue;
                }

                if (item.first == _T("program_list"))
                {
                    std::vector<_tstring> addrList = CStrUtils::SplitStr(item.second, _T(","));

                    for (const auto& item : addrList)
                    {
                        ProgramAddrSet.emplace(CStrUtils::StrToInt(CStrUtils::RemoveSpaces(item), 16));
                    }

                    continue;
                }
            }

            continue;
        }

        if (_tstring::npos != line.find(_T("=")))
        {
            std::map<_tstring, std::set<uint16_t>> KeyValue;
            std::map<_tstring, _tstring> pair = GetKeyValue(line);

            for (const auto& item : pair)
            {
                std::vector<_tstring> addrList = CStrUtils::SplitStr(item.second, _T(","));
                std::set<uint16_t> addrSet;

                for (const auto& item : addrList)
                {
                    if (!item.empty())
                    {
                        addrSet.emplace(CStrUtils::StrToInt(item, 16));
                    }
                }

                std::map<_tstring, std::set<uint16_t>> nameAddrList;

                nameAddrList.emplace(item.first, addrSet);

                mapNameAddrList.insert(nameAddrList.begin(), nameAddrList.end());
            }

            continue;
        }

        std::vector<uint8_t> data = CBytesUtils::BytesFromHexString(line);
        dataInfo.data.insert(dataInfo.data.end(), data.begin(), data.end());
    }

    if (!dataInfo.data.empty())
    {
        dataInfo.addr = startAddr;
        if (dataInfo.fData)
        {
            AsmDataList.emplace(dataInfo);
        }
        else
        {
            AsmProgramList.emplace(dataInfo);
        }

        if (startAddr + dataInfo.data.size() < 0x10000)
        {
            memcpy_s(lpData + startAddr, dataBuffer.size(), dataInfo.data.data(), dataInfo.data.size());
        }

        startAddr += dataInfo.data.size();

        if (dataInfo.fDataIndex && !dataInfo.data.empty())
        {
            const uint16_t* pData = (uint16_t*)dataInfo.data.data();
            size_t nCount = dataInfo.data.size() / 2;
            while (nCount > 0)
            {
                mapDataIndex.emplace(*pData, false);
                pData++;
                nCount--;
            }
        }

        if (dataInfo.fProgramIndex && !dataInfo.data.empty())
        {
            const uint16_t* pData = (uint16_t*)dataInfo.data.data();
            size_t nCount = dataInfo.data.size() / 2;
            while (nCount > 0)
            {
                ProgramAddrSet.emplace(*pData);
                pData++;
                nCount--;
            }
        }

        dataInfo.clear();
    }

    std::map<uint16_t, ASM_INPUT_INFO> programList;
    std::map<uint16_t, ASM_INPUT_INFO> dataList;
    std::map<uint16_t, bool> mapAddrIndexList;
    std::map<uint16_t, bool> mapDataAddrList;

    // 索引表处理
    for(const auto& item: mapDataIndex)
    {
        if (item.second)
        {
            uint16_t data = *(uint16_t*)(lpData + item.first);
            mapAddrIndexList.emplace(item.first, true);
            if (0xFFFF != data)
            {
                mapAddrIndexList.emplace(data, false);
            }
        }
        else
        {
            mapAddrIndexList.emplace(item.first, false);
        }
    }

    for (const auto& item : mapAddrIndexList)
    {
        if (item.second)
        {
            mapDataAddrList.emplace(item.first, true);
            mapDataAddrList.emplace(item.first + 2, false);
        }
        else
        {
            mapDataAddrList.emplace(item.first, false);
        }
    }

    for (const auto& item : DataAddrSet)
    {
        mapDataAddrList.emplace(item, false);
    }

    // 程序段分解
    for (const auto& item : AsmProgramList)
    {
        std::set<uint16_t> addrSet;

        if (item.fIgnore)
        {
            continue;
        }

        // 筛选数据地址
        for (const auto& info : ProgramAddrSet)
        {
            if (info >= item.addr && info < item.addr + item.data.size())
            {
                addrSet.emplace(info);
            }
        }

        if (!addrSet.empty())
        {
            addrSet.emplace(item.addr);

            for (const auto& info : addrSet)
            {
                ASM_INPUT_INFO asmInfo;
                asmInfo.addr = info;

                auto itFind = addrSet.find(info);
                if (addrSet.end() != itFind)
                {
                    itFind++;
                }

                if (addrSet.end() != itFind)
                {
                    asmInfo.size = *itFind - asmInfo.addr;
                }
                else
                {
                    asmInfo.size = item.addr + item.data.size() - asmInfo.addr;
                }

                if (info == item.addr)
                {
                    asmInfo.label_name = item.name;
                    asmInfo.bank_index = item.bank;
                    asmInfo.bank_size = item.bank_size;
                    asmInfo.addr = item.addr;
                    asmInfo.org = item.org;
                }

                programList.emplace(asmInfo.addr, asmInfo);
            }

        }
        else
        {
            ASM_INPUT_INFO asmInfo;
            asmInfo.label_name = item.name;
            asmInfo.bank_index = item.bank;
            asmInfo.bank_size = item.bank_size;
            asmInfo.addr = item.addr;
            asmInfo.org = item.org;

            programList.emplace(asmInfo.addr, asmInfo);
        }
    }

    // 数据段分解
    for (const auto& item : AsmDataList)
    {
        std::map<uint16_t, bool> addrSet;

        if (item.fIgnore)
        {
            continue;
        }

        // 筛选数据地址
        for (const auto& info : mapDataAddrList)
        {
            if (info.first >= item.addr && info.first < item.addr + item.data.size())
            {
                addrSet.emplace(info);
            }
        }

        if (addrSet.empty())
        {
            ASM_INPUT_INFO asmInfo;
            asmInfo.label_name = item.name;
            asmInfo.bank_index = item.bank;
            asmInfo.bank_size = item.bank_size;
            asmInfo.addr = item.addr;
            asmInfo.org = item.org;
            asmInfo.size = item.data.size();
            asmInfo.fData = true;
            if (item.fDataIndex || item.fProgramIndex)
            {
                asmInfo.elem_size = 2;
            }

            asmInfo.fData = true;
            dataList.emplace(asmInfo.addr, asmInfo);
        }
        else
        {
            addrSet.emplace(item.addr, false);

            for (const auto& info : addrSet)
            {
                ASM_INPUT_INFO asmInfo;
                asmInfo.addr = info.first;

                auto itFind = addrSet.find(info.first);
                if (addrSet.end() != itFind)
                {
                    itFind++;
                }

                if (addrSet.end() != itFind)
                {
                    asmInfo.size = itFind->first - asmInfo.addr;
                }
                else
                {
                    asmInfo.size = item.addr + item.data.size() - asmInfo.addr;
                }

                if (asmInfo.addr == item.addr)
                {
                    asmInfo.label_name = item.name;
                    asmInfo.bank_index = item.bank;
                    asmInfo.bank_size = item.bank_size;
                    asmInfo.org = item.org;
                }

                if (info.second)
                {
                    asmInfo.elem_size = 2;
                }

                asmInfo.fData = true;
                dataList.emplace(asmInfo.addr, asmInfo);
            }
        }
    }

    std::map<uint16_t, C6502Introduction> IntroductionData;
    DisassembleInstructions(IntroductionData, programList, dataList, lpData, (uint32_t)dataBuffer.size());

    _tstring strOutput = GetDisassembleText(IntroductionData, strLabelName, lpData, (uint32_t)dataBuffer.size(), fShowAddr, dwSyntaxType);

    return strOutput;
}
