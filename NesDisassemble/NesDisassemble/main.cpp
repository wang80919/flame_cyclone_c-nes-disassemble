#include <windows.h>
#include <tchar.h>
#include <string>
#include <map>
#include <locale.h>
#include "Win32Utils/CFileHelper.h"
#include "Win32Utils/CStrUtils.h"
#include "6502/C6502Introduction.h"

#ifdef _UNICODE
using _tstring = std::wstring;
#else
using _tstring = std::string;
#endif

bool Disassemble(
    const _tstring& strInFile,
    const _tstring& strOutFile,
    const _tstring& strLabel,
    uint32_t loadAddr,
    std::vector<uint16_t> vAddr,
    std::map<uint16_t, DATA_INFO>& DataReserved,
    bool b6502Simulator
);

void PrintfHelpEn()
{
    _tprintf(_T("NesDisassemble command\r\n"));
    _tprintf(_T("\r\n"));

    _tprintf(_T("-file=[string]                         The input binary file path.\r\n"));
    _tprintf(_T("-out=[string]                          The output decompiled source code file path\r\n"));
    _tprintf(_T("-load=[addr]                           Program loading address, such as: FA8E\r\n"));
    _tprintf(_T("-label=[string]                        Program jump label name, such as: Label_\r\n"));
    _tprintf(_T("-org=[addr,...]                        Decompiler address list, such as: FA8E,FA9D,FAA2\r\n"));
    _tprintf(_T("-data=[addr,size;...]                  Decompiled data address list, such as FAAD,4;FAB1,6\r\n"));
    _tprintf(_T("-type=[int]                            Decompilation output syntax, such as 0\r\n"));

    _tprintf(_T("-?/-help                               Show help for 6502 Disassemble.\r\n"));
}

void PrintfHelpZh()
{
    _tprintf(_T("NesDisassemble 命令\r\n"));
    _tprintf(_T("\r\n"));

    _tprintf(_T("-file=[字符串]                         输入的二进制文件路径.\r\n"));
    _tprintf(_T("-out=[字符串]                          输出反编译后的源代码文件路径\r\n"));
    _tprintf(_T("-load=[地址]                           程序加载地址，如: FA8E\r\n"));
    _tprintf(_T("-label=[字符串]                        程序跳转标签名, 如: Label_\r\n"));
    _tprintf(_T("-org=[地址,...]                        反编译地址列表，如: FA8E,FA9D,FAA2\r\n"));
    _tprintf(_T("-data=[地址,大小;...]                  反编译后的数据地址列表，如 FAAD,4;FAB1,6\r\n"));
    _tprintf(_T("-type=[类型]                           反编译输出语法，如 0: nesasm 1: 6502simulator\r\n"));

    _tprintf(_T("-?/-help                               显示 6502 反汇编器 帮助.\r\n"));
}

void PrintfHelp()
{
    LANGID langID = GetThreadUILanguage();
    if (LANG_CHINESE == PRIMARYLANGID(langID))
    {
        PrintfHelpZh();
    }
    else
    {
        PrintfHelpEn();
    }
}

void PrintfError(const _tstring& strCmd)
{
    LANGID langID = GetThreadUILanguage();
    if (LANG_CHINESE == PRIMARYLANGID(langID))
    {
        _tprintf(_T("不支持的命令: %s\r\n"), strCmd.c_str());
    }
    else
    {
        _tprintf(_T("Unsupported command: %s\r\n"), strCmd.c_str());
    }
}

int _tmain(int argc, LPCTSTR* argv)
{
    ::setlocale(LC_ALL, "");

    if (argc < 2)
    {
        PrintfHelp();
        return -1;
    }

    _tstring strInFile;
    _tstring strOutFile;
    _tstring strLabel;
    uint16_t loadAddr = 0x8000;
    std::vector<uint16_t> vAddr;
    std::map<uint16_t, DATA_INFO> DataReserved;
    bool b6502Simulator = false;

    //参数解析
    for (int i = 1; i < argc; i++)
    {
        _tstring strKeyValue = argv[i];
        _tstring strName;
        _tstring strValue;

        if (!(_T('-') == strKeyValue[0] || _T('/') == strKeyValue[0]))
        {
            PrintfError(strKeyValue);
            return -1;
        }

        //查找键值分隔符
        size_t nEqual = strKeyValue.find(_T('='));
        if (_tstring::npos != nEqual)
        {
            strName = strKeyValue.substr(1, nEqual - 1);
            strValue = strKeyValue.substr(nEqual + 1);
        }
        else
        {
            strName = strKeyValue.substr(1);;
        }

        if (0 == _tcsicmp(strName.c_str(), _T("?")) || 0 == _tcsicmp(strName.c_str(), _T("Help")))
        {
            PrintfHelp();
            continue;
        }

        if (0 == _tcsicmp(strName.c_str(), _T("type")))
        {
            b6502Simulator = _tcstoul(strValue.c_str(), nullptr, 10);
            continue;
        }

        if (0 == _tcsicmp(strName.c_str(), _T("file")))
        {
            strInFile = strValue;
            continue;
        }

        if (0 == _tcsicmp(strName.c_str(), _T("out")))
        {
            strOutFile = strValue;
            continue;
        }

        if (0 == _tcsicmp(strName.c_str(), _T("label")))
        {
            strLabel = strValue;
            continue;
        }

        if (0 == _tcsicmp(strName.c_str(), _T("load")))
        {
            _stscanf_s(strValue.c_str(), _T("%hx"), &loadAddr);
            continue;
        }

        if (0 == _tcsicmp(strName.c_str(), _T("org")))
        {
            std::vector<_tstring> vStrValue = CStrUtils::SplitStr(strValue, _T(","));

            for (const auto& item : vStrValue)
            {
                vAddr.push_back((uint16_t)_tcstol(item.c_str(), nullptr, 16));
            }
            continue;
        }

        if (0 == _tcsicmp(strName.c_str(), _T("data")))
        {
            std::vector<_tstring> vStrValue = CStrUtils::SplitStr(strValue, _T(";"));
            for (const auto& item : vStrValue)
            {
                uint32_t addr = 0;
                uint32_t size = 0;
                _stscanf_s(item.c_str(), _T("%4x,%4x"), &addr, &size);
                DATA_INFO info(addr, size, 1);
                DataReserved.insert(std::make_pair((uint16_t)addr, info));
            }
            continue;
        }

        PrintfError(strKeyValue);
        return -1;
    }

    if (!Disassemble(strInFile, strOutFile, strLabel, loadAddr, vAddr, DataReserved, b6502Simulator))
    {
        return -1;
    }

    return 0;
}

bool Disassemble(
    const _tstring& strInFile,
    const _tstring& strOutFile,
    const _tstring& strLabel,
    uint32_t loadAddr,
    std::vector<uint16_t> vAddr,
    std::map<uint16_t, DATA_INFO>& DataReserved,
    bool b6502Simulator
)
{
    //分配 64KB 缓冲空间
    std::vector<uint8_t> dataBuffer(1024 * 64);
    CFileHelper fileRead(strInFile, true);
    CFileHelper fileWrite(strOutFile, false);
    unsigned long long ullSize = 0;
    size_t uBufferSize = dataBuffer.size();

    if (!fileRead.IsOpen() || !fileWrite.IsOpen())
    {
        return false;
    }

    //加载地址检查
    if (loadAddr >= uBufferSize)
    {
        return false;
    }

    fileRead.GetSize(ullSize);

    //空文件不处理
    if (0 == ullSize)
    {
        return false;
    }

    DWORD dwRead = 0;
    if (loadAddr + ullSize >= uBufferSize)
    {
        dwRead = (uint32_t)uBufferSize - loadAddr;
    }

    LPBYTE lpData = dataBuffer.data();
    fileRead.Read(lpData + loadAddr, (DWORD)ullSize, 0, &dwRead, FILE_BEGIN);

    std::map<uint16_t, C6502Introduction> IntroductionData;
    DisassembleInstructions(IntroductionData, DataReserved, vAddr, lpData, (uint32_t)uBufferSize);

    _tstring strOutput = GetDisassembleText(IntroductionData, strLabel, lpData, (uint32_t)uBufferSize, b6502Simulator);

    std::string strUtf8 = CStrUtils::TStrToU8Str(strOutput);
    fileWrite.Clear();
    fileWrite.Write(strUtf8.c_str(), (DWORD)strUtf8.size(), 0, nullptr, FILE_BEGIN);

    return true;
}
