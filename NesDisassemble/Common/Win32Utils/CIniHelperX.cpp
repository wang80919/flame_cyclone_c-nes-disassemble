#include "CIniHelperX.h"
#include <windows.h>
#include <strsafe.h>
#include <shlwapi.h>
#pragma comment(lib, "Shlwapi.lib")

#define FROFILE_EXTERN_NAME                     _T(".ini")

#define CRC32_POLY          (0xEDB88320L)           // CRC32标准
#define CRC32_TABLE_SIZE    (256)                   // CRC查询表大小
#define CRC32_BLOCK_SIZE    (1024 * 1024 * 64)      // CRC缓冲块大小

#define ENCRYPTED_ID        (0x20250325)            // 加密文件标识

#define _count_of(_array) (sizeof(_array) / sizeof(_array[0]))

typedef struct _INI_ENCRYPTED_HEADER
{
    uint32_t   magic;       // 加密文件标识
    uint32_t   crc_data;    // 加密后数据校验码
    uint32_t   crc_raw;     // 加密前数据校验码
    uint32_t   data_size;   // 数据大小
    uint8_t    data[0];     // 数据起始
}INI_ENCRYPTED_HEADER, * PINI_ENCRYPTED_HEADER;

static uint32_t g_Crc32Table[CRC32_TABLE_SIZE] = { 0 }; // CRC查询表
static bool g_bInitFlag = false;                        // CRC查询表初始化标记

static void _InitCrc32Table(void);
static uint32_t GetCrc32(const uint8_t* lpData, size_t byteSize);
static uint32_t GetCrc32Data(uint32_t crcInit, const uint8_t* lpData, size_t byteSize);

uint32_t GetCrc32Value(const void* lpData, size_t nSize)
{
    if (!g_bInitFlag)
    {
        _InitCrc32Table();
        g_bInitFlag = true;
    }

    return GetCrc32((uint8_t*)lpData, nSize);
}

uint32_t GetPartCrc32(uint32_t crcInit, const void* lpData, size_t byteSize)
{
    if (0 == byteSize)
    {
        return crcInit;
    }

    if (!g_bInitFlag)
    {
        _InitCrc32Table();
        g_bInitFlag = true;
    }

    return GetCrc32Data(crcInit, (uint8_t*)lpData, byteSize);
}

void _InitCrc32Table(void)
{
    for (uint32_t i = 0; i < _count_of(g_Crc32Table); i++)
    {
        uint32_t crc = i;
        for (int j = 0; j < 8; j++)
        {
            if (crc & 0x00000001L)
                crc = (crc >> 1) ^ CRC32_POLY;
            else
                crc = crc >> 1;
        }
        g_Crc32Table[i] = crc;
    }
}

uint32_t GetCrc32(const uint8_t* lpData, size_t byteSize)
{
    uint32_t dwCrc32 = 0;
    size_t nBlockSize = byteSize > CRC32_BLOCK_SIZE ? CRC32_BLOCK_SIZE : byteSize;
    uint8_t* lpBase = (uint8_t*)lpData;

    while (byteSize > 0)
    {
        dwCrc32 = GetCrc32Data(dwCrc32, lpBase, nBlockSize);
        lpBase += nBlockSize;
        byteSize -= nBlockSize;

        nBlockSize = byteSize > CRC32_BLOCK_SIZE ? CRC32_BLOCK_SIZE : byteSize;
    }

    return dwCrc32;
}

uint32_t GetCrc32Data(uint32_t crcInit, const uint8_t* lpData, size_t byteSize)
{
    uint32_t crc = crcInit ^ 0xffffffff;

    while (byteSize--)
    {
        crc = (crc >> 8) ^ g_Crc32Table[(crc & 0xff) ^ *lpData++];
    }

    return crc ^ 0xffffffff;
}

std::string _WStrToMultiStr(UINT CodePage, const std::wstring& str)
{
    int cbMultiByte = ::WideCharToMultiByte(CodePage, 0, str.c_str(), -1, NULL, 0, NULL, NULL);
    std::string strResult(cbMultiByte, 0);
    size_t nConverted = ::WideCharToMultiByte(CodePage, 0, str.c_str(), (int)str.size(), &strResult[0], (int)strResult.size(), NULL, NULL);
    strResult.resize(nConverted);
    return strResult;
}

std::wstring _MultiStrToWStr(UINT CodePage, const std::string& str)
{
    int cchWideChar = ::MultiByteToWideChar(CodePage, 0, str.c_str(), -1, NULL, 0);
    std::wstring strResult(cchWideChar, 0);
    size_t nConverted = ::MultiByteToWideChar(CodePage, 0, str.c_str(), (int)str.size(), &strResult[0], (int)strResult.size());
    strResult.resize(nConverted);
    return strResult;
}

std::string WStrToAStr(const std::wstring& str)
{
    return _WStrToMultiStr(CP_ACP, str);
}

std::string WStrToU8Str(const std::wstring& str)
{
    return _WStrToMultiStr(CP_UTF8, str);
}

_tstring WStrToTStr(const std::wstring& str)
{
#ifdef _UNICODE
    return str;
#else
    return _WStrToMultiStr(CP_ACP, str);
#endif
}

std::wstring AStrToWStr(const std::string& str)
{
    return _MultiStrToWStr(CP_ACP, str);
}

std::string AStrToU8Str(const std::string& str)
{
    return WStrToU8Str(AStrToWStr(str));
}

_tstring AStrToTStr(const std::string& str)
{
#ifdef _UNICODE
    return _MultiStrToWStr(CP_ACP, str);
#else
    return str;
#endif
}

std::wstring U8StrToWStr(const std::string& str)
{
    return _MultiStrToWStr(CP_UTF8, str);
}

std::string U8StrToAStr(const std::string& str)
{
    return WStrToAStr(U8StrToWStr(str));
}

_tstring U8StrToTStr(const std::string& str)
{
#ifdef _UNICODE
    return _MultiStrToWStr(CP_UTF8, str);
#else
    return WStrToAStr(U8StrToWStr(str));
#endif
}

std::string TStrToAStr(const _tstring& str)
{
#ifdef _UNICODE
    return _WStrToMultiStr(CP_ACP, str);
#else
    return str;
#endif
}

std::wstring TStrToWStr(const _tstring& str)
{
#ifdef _UNICODE
    return str;
#else
    return AStrToWStr(str);
#endif
}

std::string TStrToU8Str(const _tstring& str)
{
#ifdef _UNICODE
    return WStrToU8Str(str);
#else
    return WStrToU8Str(AStrToWStr(str));
#endif
}

_tstring GetCurrentModulePath()
{
    TCHAR szCurPath[MAX_PATH] = { 0 };
    ::GetModuleFileName(NULL, szCurPath, _countof(szCurPath));

    _tstring strDir = szCurPath;
    return strDir;
}

_tstring GetCurrentModuleDir()
{
    _tstring strDir = GetCurrentModulePath();
    strDir.resize(strDir.find_last_of(_T('\\')));
    return strDir;
}

_tstring GetCurrentModuleName(bool bHasExt/* = false*/)
{
    _tstring strDir = GetCurrentModulePath();
    size_t nIndex = strDir.find_last_of(_T('\\'));
    if (nIndex != _tstring::npos)
    {
        strDir = strDir.substr(nIndex + 1);
    }

    if (!bHasExt)
    {
        nIndex = strDir.find_last_of(_T('.'));
        if (nIndex != _tstring::npos)
        {
            strDir.resize(nIndex);
        }
    }

    return strDir;
}

_tstring GetFileDir(const _tstring& strPath)
{
    _tstring strDir = strPath;
    for (auto& ch : strDir)
    {
        if (_T('/') == ch)
        {
            ch = _T('\\');
        }
    }

    _tstring strResult;
    size_t nIndex = strDir.find_last_of(_T('\\'));
    if (nIndex != _tstring::npos)
    {
        strResult = strDir.substr(0, nIndex);
    }

    return strResult;
}

bool IsDirectory(const _tstring& strPath)
{
    DWORD dwAttr = ::GetFileAttributes(strPath.c_str());
    if (INVALID_FILE_ATTRIBUTES == dwAttr)
    {
        return false;
    }

    return FILE_ATTRIBUTE_DIRECTORY == (FILE_ATTRIBUTE_DIRECTORY & dwAttr);
}

bool CreateDir(const _tstring& strPath)
{
    _tstring strDriver;              //驱动器号, 如 D:
    _tstring strSubPath = strPath;   //路径, 如 Test\1\2\3

    if (strPath.empty())
    {
        return false;
    }

    //获取盘符
    do
    {
        size_t nFindIndex = strPath.find_first_of(':');  //检查是否有驱动器号
        if (nFindIndex == _tstring::npos)
        {
            break;
        }

        strDriver = strPath.substr(0, nFindIndex + 1); //得到驱动器号, 如 D:
        nFindIndex = strPath.find(_T("\\"), nFindIndex);
        if (nFindIndex == _tstring::npos)
        {
            break;
        }

        strSubPath = strPath.substr(nFindIndex + 1); //得到路径, 如 Test\1\2\3
    } while (false);

    _tstring strDestDir;
    size_t nFindBegin = 0;
    size_t nFindIndex = 0;
    do
    {
        nFindIndex = strSubPath.find(_T("\\"), nFindBegin);
        if (nFindIndex != _tstring::npos)
        {
            strDestDir = strSubPath.substr(0, nFindIndex);
            nFindBegin = nFindIndex + 1;
        }
        else
        {
            strDestDir = strSubPath;
        }

        if (!strDriver.empty())
        {
            strDestDir = strDriver + _T("\\") + strDestDir;
        }

        if (!::CreateDirectory(strDestDir.c_str(), NULL) && ERROR_ALREADY_EXISTS != ::GetLastError())
        {
            return false;
        }

    } while (nFindIndex != _tstring::npos);

    return true;
}

int GetUtf8Count(const void* data_ptr, size_t size/* = -1*/)
{
    const uint8_t* data_pos = (const uint8_t*)data_ptr;
    size_t size_count = size;
    uint32_t code_point = 0;
    int32_t byte_count = 0;
    int32_t char_count = 0;
    bool result_flag = true;

    // 字节序检查
    if ((0xEF == data_pos[0]) && (0xBB == data_pos[1]) && (0xBF == data_pos[2]))
    {
        data_pos += 3;

        if (-1 != size_count)
        {
            size_count -= 3;
        }
    }

    while ((0 != *data_pos) && (0 != size_count))
    {
        uint8_t ch = *data_pos;

        // ASCII 范围
        if (ch < 0x7F)
        {
            code_point = ch;
            char_count++;
        }
        else
        {
            if (0 == byte_count)
            {
                code_point = 0;
                if (ch >= 0xC0)
                {
                    // 获取字符编码字节数 & 首字节码点
                    if (ch >= 0xC0 && ch <= 0xDF)
                    {
                        byte_count = 2;
                        code_point = ch & 0x1F;
                    }
                    else if (ch >= 0xE0 && ch <= 0xEF)
                    {
                        byte_count = 3;
                        code_point = ch & 0x0F;
                    }
                    else if (ch >= 0xF0 && ch <= 0xF7)
                    {
                        byte_count = 4;
                        code_point = ch & 0x07;
                    }
                    else if (ch >= 0xF8 && ch <= 0xFB)
                    {
                        byte_count = 5;
                        code_point = ch & 0x03;
                    }
                    else if (ch >= 0xFC && ch <= 0xFD)
                    {
                        byte_count = 6;
                        code_point = ch & 0x01;
                    }

                    if (0 == byte_count)
                    {
                        result_flag = false;
                        break;
                    }

                    byte_count--;
                }
                else
                {
                    result_flag = false;
                    break;
                }
            }
            else
            {
                // 非首字节码点字节掩码检查
                if (0x80 != (ch & 0xC0))
                {
                    result_flag = false;
                    break;
                }

                // 码点组合
                code_point = code_point << 6;
                code_point |= ch & 0x3F;

                byte_count--;

                // 统计字符计数, 忽略字节顺序标记(BOM)
                if (0 == byte_count)
                {
                    char_count++;
                }
            }
        }

        data_pos++;

        if (-1 != size_count)
        {
            size_count--;
        }
    }

    if (!result_flag)
    {
        return -1;
    }

    return char_count;
}

int32_t GetUtf16Count(const void* data_ptr, size_t size/* = -1*/, bool* big_endian_ptr = nullptr)
{
    const uint16_t* data_pos = (const uint16_t*)data_ptr;
    size_t size_count = size;
    uint32_t code_point = 0;
    uint16_t code_point_high = 0;
    uint16_t code_point_low = 0;
    uint16_t code_point_tmp = 0;
    int32_t byte_count = 0;
    int32_t char_count = 0;
    bool big_endian_flag = false;
    bool little_endian_flag = false;
    bool result_flag = true;

    if (-1 != size_count)
    {
        if ((size_count < 2) || (0 != (size_count % 2)))
        {
            return -1;
        }
    }

    code_point_tmp = *data_pos;

    // 字节序检查
    if (0xFFFE == code_point_tmp || 0xFEFF == code_point_tmp)
    {
        // 大端序
        if (0xFFFE == code_point_tmp)
        {
            big_endian_flag = true;
        }

        // 小端序
        if (0xFEFF == code_point_tmp)
        {
            little_endian_flag = true;
        }

        data_pos++;

        if (-1 != size_count)
        {
            size_count -= 2;
        }
    }

    while ((0 != *data_pos) && (0 != size_count))
    {
        code_point_tmp = *data_pos;

        //字节序转换
        if (big_endian_flag)
        {
            code_point_tmp = ((code_point_tmp >> 8) | (code_point_tmp << 8));
        }

        // 代理区检查
        if (!(code_point_tmp >= 0xD800 && code_point_tmp <= 0xDFFF))
        {
            if (code_point_high > 0)
            {
                result_flag = false;
                break;
            }

            code_point = code_point_tmp;
            char_count++;
        }
        else
        {
            if (0 == byte_count)
            {
                // 高位代理(高10位)
                if (code_point_tmp >= 0xD800 && code_point_tmp <= 0xDBFF)
                {
                    code_point_high = (code_point_tmp - 0xD800);
                    byte_count = 1;
                }
                else
                {
                    result_flag = false;
                    break;
                }
            }
            else
            {
                if (1 == byte_count)
                {
                    // 低位代理(低10位)
                    if ((code_point_tmp >= 0xDC00) && (code_point_tmp <= 0xDFFF))
                    {
                        code_point_low = (code_point_tmp - 0xDC00);
                        code_point = 0x10000 + ((uint32_t)code_point_high << 10 | code_point_low);
                        code_point_low = 0;
                        code_point_high = 0;
                    }
                    else
                    {
                        result_flag = false;
                        break;
                    }
                }

                byte_count--;

                if (0 == byte_count)
                {
                    char_count++;
                }
            }
        }

        data_pos++;

        if (-1 != size_count)
        {
            size_count -= 2;
        }
    }

    if (!result_flag)
    {
        return -1;
    }

    if (big_endian_ptr)
    {
        *big_endian_ptr = big_endian_flag;
    }

    return char_count;
}

CIniHelperX::CIniHelperX(const _tstring& strPath/* = _T("")*/, bool fLoad/* = true*/, bool fAutoSave/* = false*/, bool fEncrypt/* = true*/)
    :
    m_strFilePath(GetCurrentModuleDir()),
    m_fAutoSave(fAutoSave),
    m_fEncrypt(fEncrypt),
    m_strCRLF(_T("\r\n")),
    m_TextEncoding(eTextEncoding::eTextUtf8)
{
    m_strFilePath += _T("\\");
    m_strFilePath += GetCurrentModuleName(false);
    m_strFilePath += FROFILE_EXTERN_NAME;

    if (!strPath.empty())
    {
        if (::PathIsRelative(strPath.c_str()))
        {
            m_strFilePath = GetCurrentModuleDir();
            m_strFilePath += _T("\\");
            m_strFilePath += strPath;
        }
        else
        {
            m_strFilePath = strPath;
        }
    }

    if (fLoad)
    {
        Load();
    }
}

CIniHelperX::~CIniHelperX()
{

}

bool CIniHelperX::LoadFromFile(const _tstring& strFileName)
{
    HANDLE hFile = INVALID_HANDLE_VALUE;
    bool bSuccess = true;

    _tstring strFilePath = strFileName;
    if (strFileName.empty())
    {
        strFilePath += GetCurrentModuleDir();
        strFilePath += _T("\\");
        strFilePath += GetCurrentModuleName(false);
        strFilePath += FROFILE_EXTERN_NAME;
    }

    hFile = ::CreateFile(strFilePath.c_str(),
        GENERIC_READ,
        FILE_SHARE_READ,
        NULL,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        NULL);

    if (INVALID_HANDLE_VALUE == hFile)
    {
        return false;
    }

    m_SectionList.clear();
    LPBYTE lpData = nullptr;
    // 读取文本
    do
    {
        LARGE_INTEGER liSize = { 0 };
        if (!::GetFileSizeEx(hFile, &liSize))
        {
            break;
        }

        lpData = (LPBYTE)::HeapAlloc(::GetProcessHeap(), HEAP_ZERO_MEMORY, (SIZE_T)liSize.QuadPart + 2);
        if (nullptr == lpData)
        {
            break;
        }

        DWORD nBytesToRead = 0;
        if (!::ReadFile(hFile, (LPVOID)lpData, liSize.LowPart, &nBytesToRead, NULL))
        {
            break;
        }

        bSuccess = LoadFromData(lpData, liSize.LowPart);

    } while (false);

    if (nullptr != lpData)
    {
        ::HeapFree(::GetProcessHeap(), 0, (LPVOID)lpData);
    }

    if (INVALID_HANDLE_VALUE != hFile)
    {
        ::CloseHandle(hFile);
    }

    return bSuccess;
}

bool CIniHelperX::Load()
{
    return LoadFromFile(m_strFilePath);
}

bool CIniHelperX::Save(eTextEncoding enc/* = eTextEncoding::eAuto*/)
{
    return SaveToFile(m_strFilePath, enc);
}

void CIniHelperX::Clear()
{
    m_SectionList.clear();
}

bool CIniHelperX::SaveToFile(const _tstring& strFileName, eTextEncoding enc/* = eTextEncoding::eAuto*/)
{
    HANDLE hFile = INVALID_HANDLE_VALUE;
    bool bSuccess = true;

    _tstring strFilePath = strFileName;
    if (strFileName.empty())
    {
        strFilePath += GetCurrentModuleDir();
        strFilePath += _T("\\");
        strFilePath += GetCurrentModuleName(false);
        strFilePath += FROFILE_EXTERN_NAME;
    }

    do
    {
        std::string strMulBytes;
        std::wstring strWideBytes;
        bool fWideByte = false;

        _tstring strDirectory = GetFileDir(strFilePath);
        if (!IsDirectory(strDirectory))
        {
            CreateDir(strDirectory);
        }

        hFile = ::CreateFile(strFilePath.c_str(),
            GENERIC_WRITE,
            FILE_SHARE_READ,
            NULL,
            CREATE_ALWAYS,
            FILE_ATTRIBUTE_NORMAL,
            NULL);

        if (INVALID_HANDLE_VALUE == hFile)
        {
            return false;
        }

        if (enc == eTextEncoding::eTextAuto)
        {
            enc = m_TextEncoding;
        }

        if (enc == eTextEncoding::eTextAnsi)
        {
            _tstring strDump = _Dump(m_SectionList);
            strMulBytes += TStrToAStr(strDump);
        }
        else if (enc == eTextEncoding::eTextUtf8)
        {
            _tstring strDump = _Dump(m_SectionList);
            strMulBytes += TStrToU8Str(strDump);
        }
        else if (enc == eTextEncoding::eTextUtf8BOM)
        {
            strMulBytes = "\xEF\xBB\xBF";
            _tstring strDump = _Dump(m_SectionList);
            strMulBytes += TStrToU8Str(strDump);
        }
        else if (enc == eTextEncoding::eTextUtf16LEBOM)
        {
            strWideBytes += wchar_t(0xFEFF);
            _tstring strDump = _Dump(m_SectionList);
            strWideBytes += TStrToWStr(strDump);
            fWideByte = true;
        }
        else if (enc == eTextEncoding::eTextUtf16BEBOM)
        {
            strWideBytes += wchar_t(0xFEFF);
            _tstring strDump = _Dump(m_SectionList);
            strWideBytes += TStrToWStr(strDump);
            fWideByte = true;

            for (auto& ch : strWideBytes)
            {
                ch = ((ch & 0x00FF) << 8) | ((ch & 0xFF00) >> 8);
            }
        }

        if (m_fEncrypt)
        {
            if (fWideByte)
            {
                std::vector<uint8_t> vData = GetEncryptData((uint8_t*)strWideBytes.c_str(), strWideBytes.size() * sizeof(wchar_t));
                bSuccess = ::WriteFile(hFile, vData.data(), vData.size(), nullptr, nullptr);
            }
            else
            {
                std::vector<uint8_t> vData = GetEncryptData((uint8_t*)strMulBytes.c_str(), strMulBytes.size());
                bSuccess = ::WriteFile(hFile, vData.data(), vData.size(), nullptr, nullptr);
            }

            if (!bSuccess)
            {
                break;
            }
        }
        else
        {
            if (fWideByte)
            {
                bSuccess = ::WriteFile(hFile, strWideBytes.data(), strWideBytes.size() * sizeof(wchar_t), nullptr, nullptr);
            }
            else
            {
                bSuccess = ::WriteFile(hFile, strMulBytes.data(), strMulBytes.size(), nullptr, nullptr);
            }

            if (!bSuccess)
            {
                break;
            }
        }

    } while (false);

    if (INVALID_HANDLE_VALUE != hFile)
    {
        ::CloseHandle(hFile);
    }

    return bSuccess;
}

bool CIniHelperX::LoadFromData(LPCVOID lpData, DWORD nSize)
{
    _tstring strContent;
    std::vector<uint8_t> DecryptData;
    uint8_t* pBytesData = (uint8_t*)lpData;
    size_t nDataSize = nSize;
    bool fBigEndian = false;

    if (IsEncrypted((uint8_t*)pBytesData, nSize))
    {
        DecryptData = GetDecryptData((uint8_t*)pBytesData, nDataSize);
        pBytesData = DecryptData.data();
        nDataSize = DecryptData.size();
    }

    // 编码自动转换
    if (GetUtf8Count(pBytesData, nDataSize) >= 0)
    {
        // UTF8 -> UTF16
        std::string strUtf8((const char*)pBytesData, nDataSize);

        m_TextEncoding = eTextEncoding::eTextUtf8;

        // 去除字节序标识
        while (strUtf8.size() >= 3 && (0xEF == (uint8_t)strUtf8[0] && 0xBB == (uint8_t)strUtf8[1] && 0xBF == (uint8_t)strUtf8[2]))
        {
            m_TextEncoding = eTextEncoding::eTextUtf8BOM;
            strUtf8 = strUtf8.substr(3);
        }

        strContent = U8StrToTStr(strUtf8);
    }
    else if (GetUtf16Count(pBytesData, nDataSize, &fBigEndian) >= 0)
    {
        // UTF16 -> Text
        std::wstring strUtf16((const wchar_t*)pBytesData, nDataSize / sizeof(wchar_t));

        m_TextEncoding = eTextEncoding::eTextUtf16LEBOM;
        if (fBigEndian)
        {
            m_TextEncoding = eTextEncoding::eTextUtf16BEBOM;
        }

        if (eTextEncoding::eTextUtf16BEBOM == m_TextEncoding)
        {
            for (auto& ch : strUtf16)
            {
                ch = ((ch & 0x00FF) << 8) | ((ch & 0xFF00) >> 8);
            }
        }

        // 去除字节序标识
        if (!strUtf16.empty() && 0xFEFF == strUtf16.front())
        {
            strUtf16 = strUtf16.substr(1);
        }

        strContent = WStrToTStr(strUtf16);
    }
    else
    {
        m_TextEncoding = eTextEncoding::eTextAnsi;
        std::string strAnsi((const char*)pBytesData, nDataSize);
        strContent = AStrToTStr(strAnsi);
    }

    if (!strContent.empty())
    {
        _Parse(strContent);
    }

    return true;
}

std::wstring CIniHelperX::DumpWStr() const
{
    return TStrToWStr(_Dump(m_SectionList));
}

std::string CIniHelperX::DumpAStr() const
{
    return TStrToAStr(_Dump(m_SectionList));
}

std::string CIniHelperX::DumpU8Str() const
{
    return TStrToU8Str(_Dump(m_SectionList));
}

_tstring CIniHelperX::Dump() const
{
    return _Dump(m_SectionList);
}

bool CIniHelperX::IsEncrypt() const
{
    return m_fEncrypt;
}

void CIniHelperX::SetEncrypt(bool fEnable/* = true*/)
{
    m_fEncrypt = fEnable;
}

bool CIniHelperX::IsAutoSave() const
{
    return m_fAutoSave;
}

void CIniHelperX::SetAutoSave(bool fEnable/* = true*/)
{
    m_fAutoSave = fEnable;
}

std::vector<_tstring> CIniHelperX::SplitStringLine(const _tstring& str)
{
    std::vector<_tstring> splitOut;
    m_strCRLF = _T("\r\n");

    if (_tstring::npos != str.find(_T("\r\n")))
    {
        m_strCRLF = _T("\r\n");
    }
    else if (_tstring::npos != str.find(_T("\r")))
    {
        m_strCRLF = _T("\r");
    }
    else if (_tstring::npos != str.find(_T("\n")))
    {
        m_strCRLF = _T("\n");
    }

    size_t iStart = 0;
    size_t iEnd = 0;

    while (_tstring::npos != (iEnd = str.find(m_strCRLF, iEnd)))
    {
        _tstring strLine = str.substr(iStart, iEnd - iStart);
        splitOut.push_back(strLine);
        iEnd += m_strCRLF.size();
        iStart = iEnd;
    }

    if (iStart != iEnd)
    {
        _tstring strLine = str.substr(iStart, iEnd - iStart);
        if (!strLine.empty() && _T('\r') == strLine.back())
        {
            strLine.resize(strLine.size() - 1);
        }

        splitOut.push_back(strLine);
    }

    return splitOut;
}

bool _IsSection(const _tstring& strContent)
{
    if (strContent.empty())
    {
        return false;
    }

    if (((_T('[') == strContent.front() && _T(']') == strContent.back())))
    {
        return true;
    }

    return false;
}

bool _IsComment(const _tstring& strContent)
{
    if (strContent.empty())
    {
        return false;
    }

    if (((_T('#') == strContent[0] || _T(';') == strContent[0])))
    {
        return true;
    }

    return false;
}

_tstring RemoveStringSpaces(_tstring& strValue, bool fLeft, bool fRight)
{
    LPCTSTR lpBegin = strValue.data();
    LPCTSTR lpEnd = strValue.data() + strValue.size();

    if (fLeft)
    {
        while (lpBegin < lpEnd)
        {
            if (_T(' ') == *lpBegin)
            {
                lpBegin++;
            }
            else
            {
                break;
            }
        }
    }

    if (fRight)
    {
        while (lpEnd > lpBegin)
        {
            if (_T(' ') == *(lpEnd - 1))
            {
                lpEnd--;
            }
            else
            {
                break;
            }
        }
    }

    return _tstring(lpBegin, lpEnd - lpBegin);
}

bool CIniHelperX::_Parse(const _tstring& strCfg)
{
    INI_CFG_SECTION iniAppInfo;
    _tstring strSection;
    std::vector<_tstring> vTestLine = SplitStringLine(strCfg);
    std::vector<_tstring> vComment;

    for (auto& item : vTestLine)
    {
        //查找到配置节
        if (_IsSection(item))
        {
            //插入节配置
            if (!strSection.empty())
            {
                iniAppInfo.SectionName = strSection;
                m_SectionList.push_back(iniAppInfo);
                iniAppInfo.ValueList.clear();
            }
            strSection = item.substr(1, item.size() - 2);

            iniAppInfo.SectionName = RemoveStringSpaces(strSection, true, true);
            iniAppInfo.SrctionNameRaw = strSection;
            iniAppInfo.SectionComment = vComment;
            vComment.clear();
        }
        else
        {
            auto itFind = item.find(_T("="));

            // 过滤注释
            if (_tstring::npos == itFind || item.empty() || _IsComment(item))
            {
                vComment.push_back(item);
                continue;
            }

            // 获取原始值名和值数据
            _tstring strRawName = item.substr(0, itFind);
            _tstring strRawValue = item.substr(itFind + 1);

            // 移除值名前后空格
            _tstring strName = RemoveStringSpaces(strRawName, true, true);

            // 移除数据前面空格
            _tstring strValue = RemoveStringSpaces(strRawValue, true, true);

            // 移除值数据前后引号
            if (strValue.size() >= 2)
            {
                // 移除值数据前后单引号
                if (_T('\'') == strValue.front() && _T('\'') == strValue.back())
                {
                    strValue = strValue.substr(1, strValue.size() - 2);
                }
                // 移除值数据前后双引号
                else if (_T('\"') == strValue.front() && _T('\"') == strValue.back())
                {
                    strValue = strValue.substr(1, strValue.size() - 2);
                }
            }

            INI_CFG_VALUE info(strName, strValue, vComment);
            info.ValueNameRaw = strRawName;
            info.ValueDataRaw = strRawValue;
            iniAppInfo.ValueList.push_back(info);
            vComment.clear();
        }
    }

    //插入节配置
    if (!strSection.empty())
    {
        m_SectionList.push_back(iniAppInfo);
    }

    EndTextList = vComment;

    return true;
}

_tstring CIniHelperX::_GetTextList(const std::vector<_tstring>& strList) const
{
    _tstring strResult;
    size_t nCount = strList.size();
    for (const auto& item : strList)
    {
        nCount--;
        if (item.empty() && nCount > 0)
        {
            strResult += m_strCRLF;
        }
        else
        {
            strResult += item;
            if (nCount > 0)
            {
                strResult += m_strCRLF;
            }
        }
    }

    return strResult;
}

_tstring CIniHelperX::_Dump(const INI_SECTION_LIST& mapData) const
{
    std::vector<_tstring> vOutput;

    size_t nCount = 0;
    for (const auto& section : mapData)
    {
        // 节注释
        nCount += section.SectionComment.size();

        // 节名
        nCount++;

        for (const auto& value : section.ValueList)
        {
            // 值注释
            nCount += value.ValueComment.size();

            // 值名 = 值数据
            nCount++;
        }
    }
    nCount += EndTextList.size();

    vOutput.reserve(nCount);

    for (const auto& section : mapData)
    {
        // 节注释
        vOutput.insert(vOutput.end(), section.SectionComment.begin(), section.SectionComment.end());

        // 节名
        vOutput.emplace_back(_T("[") + section.SrctionNameRaw + _T("]"));

        // 值列表
        for (const auto& value : section.ValueList)
        {
            // 值注释
            vOutput.insert(vOutput.end(), value.ValueComment.begin(), value.ValueComment.end());

            // 值名 = 值数据
            vOutput.emplace_back(value.ValueNameRaw + _T("=") + value.ValueDataRaw);
        }
    }
    vOutput.insert(vOutput.end(), EndTextList.begin(), EndTextList.end());

    return _GetTextList(vOutput);
}

_tstring CIniHelperX::GetString(const _tstring& strSec, const _tstring& strKey, const _tstring& strDefault/* = _T("")*/) const
{
    _tstring strText = strDefault;

    auto itSec = std::find(m_SectionList.begin(), m_SectionList.end(), strSec);
    if (itSec != m_SectionList.end())
    {
        auto itValue = std::find(itSec->ValueList.begin(), itSec->ValueList.end(), strKey);
        if (itValue != itSec->ValueList.end())
        {
            strText = itValue->ValueData;
        }
    }

    return strText;
}

bool CIniHelperX::SetString(const _tstring& strSec, const _tstring& strKey, const _tstring& strVal)
{
    auto itSec = std::find(m_SectionList.begin(), m_SectionList.end(), strSec);
    if (itSec != m_SectionList.end())
    {
        auto itValue = std::find(itSec->ValueList.begin(), itSec->ValueList.end(), strKey);
        if (itValue != itSec->ValueList.end())
        {
            itValue->ValueData = strVal;
            itValue->ValueDataRaw = strVal;
        }
        else
        {
            // 修改值, 原始值名与原始值数据也需要修改
            INI_CFG_VALUE value(strKey, strVal);
            value.ValueNameRaw = strKey;
            value.ValueDataRaw = strVal;

            itSec->ValueList.push_back(value);
        }
    }
    else
    {
        // 修改值, 原始值名与原始值数据也需要修改
        INI_CFG_VALUE value(strKey, strVal);
        value.ValueNameRaw = strKey;
        value.ValueDataRaw = strVal;

        // 修改节, 原始节名也需要修改
        INI_CFG_SECTION info(strSec, { value }, {});
        info.SrctionNameRaw = strSec;

        m_SectionList.push_back(info);
    }

    if (m_fAutoSave)
    {
        Save();
    }

    return true;
}

bool CIniHelperX::GetBool(const _tstring& strSec, const _tstring& strKey, bool fDefault/* = false*/) const
{
    return 0 == _tcsicmp(GetString(strSec, strKey, fDefault ? _T("true") : _T("false")).c_str(), _T("true"));
}

bool CIniHelperX::SetBool(const _tstring& strSec, const _tstring& strKey, bool fValue)
{
    return SetString(strSec, strKey, fValue ? _T("true") : _T("false"));
}

int64_t CIniHelperX::GetInt(const _tstring& strSec, const _tstring& strKey, int64_t dwDefault/* = 0*/, int radix/* = 10*/) const
{
    TCHAR szBuf[MAX_PATH] = { 0 };
    ::_i64tot_s(dwDefault, szBuf, _countof(szBuf), radix);
    return(::_tcstoll(GetString(strSec, strKey, szBuf).c_str(), nullptr, radix));
}

bool CIniHelperX::SetInt(const _tstring& strSec, const _tstring& strKey, int64_t dwNumber, int radix/* = 10*/)
{
    TCHAR szBuf[MAX_PATH] = { 0 };
    ::_i64tot_s(dwNumber, szBuf, _countof(szBuf), radix);
    return SetString(strSec, strKey, szBuf);
}

double CIniHelperX::GetFloat(const _tstring& strSec, const _tstring& strKey, double dDefault/* = 0.0f*/) const
{
    TCHAR szBuf[MAX_PATH] = { 0 };
    ::_stprintf_s(szBuf, _countof(szBuf), _T("%g"), dDefault);
    return(::_tcstod(GetString(strSec, strKey, szBuf).c_str(), nullptr));
}

bool CIniHelperX::SetFloat(const _tstring& strSec, const _tstring& strKey, double dNumber)
{
    TCHAR szBuf[MAX_PATH] = { 0 };
    ::_stprintf_s(szBuf, _countof(szBuf), _T("%g"), dNumber);
    return SetString(strSec, strKey, szBuf);
}

bool CIniHelperX::DeleteSection(const _tstring& strSec)
{
    auto itSec = std::find(m_SectionList.begin(), m_SectionList.end(), strSec);
    if (itSec == m_SectionList.end())
    {
        return false;
    }

    m_SectionList.erase(itSec);
    return true;
}

bool CIniHelperX::DeleteValue(const _tstring& strSec, const _tstring& strKey/* = _T("")*/)
{
    auto itSec = std::find(m_SectionList.begin(), m_SectionList.end(), strSec);
    if (itSec == m_SectionList.end())
    {
        return false;
    }

    auto itValue = std::find(itSec->ValueList.begin(), itSec->ValueList.end(), strKey);
    if (itValue == itSec->ValueList.end())
    {
        return false;
    }

    itSec->ValueList.erase(itValue);
    return true;
}

bool CIniHelperX::IsEncrypted(const uint8_t* pData, size_t nSize)
{
    bool fResult = false;

    do
    {
        PINI_ENCRYPTED_HEADER pEnc = (PINI_ENCRYPTED_HEADER)pData;
        if (nSize < sizeof(INI_ENCRYPTED_HEADER))
        {
            break;
        }

        // 检查标识
        if (ENCRYPTED_ID != pEnc->magic)
        {
            break;
        }

        // 检查大小
        if (pEnc->data_size + sizeof(INI_ENCRYPTED_HEADER) != nSize)
        {
            break;
        }

        if (pEnc->crc_data != GetCrc32Value(pEnc->data, pEnc->data_size))
        {
            break;
        }

        fResult = true;

    } while (false);

    return fResult;
}

std::vector<uint8_t> CIniHelperX::GetEncryptData(const uint8_t* pData, size_t nSize)
{
    std::vector<uint8_t> reault;

    do
    {
        if (!pData || (0 == nSize))
        {
            break;
        }

        // 检查是否已经加密过
        if (IsEncrypted(pData, nSize))
        {
            reault.resize(nSize);
            memcpy(reault.data(), pData, nSize);
            return reault;
        }

        // 加密数据
        INI_ENCRYPTED_HEADER ide = { 0 };
        ide.magic = ENCRYPTED_ID;
        ide.data_size = nSize;

        reault.resize(sizeof(INI_ENCRYPTED_HEADER) + nSize);
        PINI_ENCRYPTED_HEADER pEnc = (PINI_ENCRYPTED_HEADER)reault.data();
        memcpy(pEnc, &ide, sizeof(INI_ENCRYPTED_HEADER));
        memcpy(pEnc->data, pData, nSize);

        // 计算加密前数据校验和
        pEnc->crc_raw = GetCrc32Value(pEnc->data, pEnc->data_size);

        // 加密数据
        uint8_t* pBytesData = pEnc->data;
        size_t nBytesSize = pEnc->data_size;
        for (size_t i = 0; i < nBytesSize; i++)
        {
            pBytesData[i] = (pBytesData[i] ^ (uint8_t)(0x80 + i)) + i;
        }

        // 计算加密后数据校验和
        pEnc->crc_data = GetCrc32Value(pEnc->data, pEnc->data_size);

    } while (false);

    return reault;
}

std::vector<uint8_t> CIniHelperX::GetDecryptData(const uint8_t* pData, size_t nSize)
{
    std::vector<uint8_t> reault;

    do
    {
        if (!pData || (0 == nSize))
        {
            break;
        }

        PINI_ENCRYPTED_HEADER pEnc = (PINI_ENCRYPTED_HEADER)pData;
        if (nSize < sizeof(INI_ENCRYPTED_HEADER))
        {
            break;
        }

        // 检查标识
        if (ENCRYPTED_ID != pEnc->magic)
        {
            break;
        }

        // 检查大小
        if (pEnc->data_size + sizeof(INI_ENCRYPTED_HEADER) != nSize)
        {
            break;
        }

        std::vector<uint8_t> vDataBuf(pEnc->data_size);
        memcpy(vDataBuf.data(), pEnc->data, pEnc->data_size);
        uint8_t* pBytesData = vDataBuf.data();
        size_t nBytesSize = vDataBuf.size();

        // 检查加密后数据校验和
        if (pEnc->crc_data != GetCrc32Value(pBytesData, nBytesSize))
        {
            break;
        }

        // 解密数据
        for (size_t i = 0; i < nBytesSize; i++)
        {
            pBytesData[i] = (pBytesData[i] - i) ^ (uint8_t)(0x80 + i);
        }

        // 检查解密后数据校验和
        if (pEnc->crc_raw != GetCrc32Value(pBytesData, nBytesSize))
        {
            break;
        }

        reault = std::move(vDataBuf);

    } while (false);

    return reault;
}
