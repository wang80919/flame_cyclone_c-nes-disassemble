#pragma once

#include <string>
#include <tchar.h>
#include <vector>
#include <windows.h>

#ifdef _UNICODE
using _tstring = std::wstring;
#else
using _tstring = std::string;
#endif

using _tstring_list = std::vector<_tstring>;

typedef struct _INI_CFG_VALUE
{
    _tstring ValueName;             // 值名
    _tstring ValueNameRaw;          // 原始值名
    _tstring ValueData;             // 值数据
    _tstring ValueDataRaw;          // 原始值数据
    _tstring_list ValueComment;     // 注释

    _INI_CFG_VALUE(const _tstring& name = _T(""), const _tstring& content = _T(""), const std::vector<_tstring>& comment = {})
        :
        ValueName(name),
        ValueData(content),
        ValueComment(comment)
    {

    }

    bool operator == (const _INI_CFG_VALUE& r) const
    {
        return this->ValueName == r.ValueName;
    }

}INI_CFG_VALUE;

using INI_VALUE_LIST = std::vector<INI_CFG_VALUE>;

typedef struct _INI_CFG_SECTION
{
    _tstring SectionName;           // 值名
    _tstring SrctionNameRaw;        // 原始值名
    _tstring_list SectionComment;   // 注释
    INI_VALUE_LIST ValueList;       // 值列表

    _INI_CFG_SECTION(const _tstring& name = _T(""), const INI_VALUE_LIST& value = {}, const std::vector<_tstring>& comment = {})
        :
        SectionName(name),
        ValueList(value),
        SectionComment(comment)
    {

    }

    bool operator == (const _INI_CFG_SECTION& r) const
    {
        return this->SectionName == r.SectionName;
    }

}INI_CFG_SECTION;

using INI_SECTION_LIST = std::vector<INI_CFG_SECTION>;

// 文本编码
enum eTextEncoding
{
    eTextAuto,              // 自动识别
    eTextAnsi,              // Ansi编码
    eTextUtf8,              // UTF-8
    eTextUtf8BOM,           // UTF-8 带字节序
    eTextUtf16LEBOM,        // UTF16 小端字节序
    eTextUtf16BEBOM         // UTF16 大端字节序
};

// Ini配置辅助类
class CIniHelperX
{
public:

    CIniHelperX(const _tstring& strPath = _T(""), bool fLoad = true, bool fAutoSave = false, bool fEncrypt = false);
    ~CIniHelperX();

    // 加载
    bool Load();
    bool LoadFromFile(const _tstring& strFileName);

    // 保存
    bool Save(eTextEncoding enc = eTextEncoding::eTextAuto);
    bool SaveToFile(const _tstring& strFileName, eTextEncoding enc = eTextEncoding::eTextAuto);

    // 清空
    void Clear();

    // 是否自动加密
    bool IsEncrypt() const;

    // 设置自动加密
    void SetEncrypt(bool fEnable = true);

    // 是否自动保存
    bool IsAutoSave() const;

    // 设置自动保存
    void SetAutoSave(bool fEnable = true);

    // 从数据加载
    bool LoadFromData(LPCVOID lpData, DWORD nSize);

    // 读写字符串
    _tstring GetString(const _tstring& strSec, const _tstring& strKey, const _tstring& strDefault = _T("")) const;
    bool SetString(const _tstring& strSec, const _tstring& strKey, const _tstring& strVal);

    // 读写布尔值
    bool GetBool(const _tstring& strSec, const _tstring& strKey, bool fDefault = false) const;
    bool SetBool(const _tstring& strSec, const _tstring& strKey, bool fValue);

    // 读写整数
    int64_t GetInt(const _tstring& strSec, const _tstring& strKey, int64_t dwDefault = 0, int radix = 10) const;
    bool SetInt(const _tstring& strSec, const _tstring& strKey, int64_t dwNumber, int radix = 10);

    // 读写浮点数
    double GetFloat(const _tstring& strSec, const _tstring& strKey, double dDefault = 0.0f) const;
    bool SetFloat(const _tstring& strSec, const _tstring& strKey, double dNumber);

    // 删除配置节
    bool DeleteSection(const _tstring& strSec);

    // 删除配置值
    bool DeleteValue(const _tstring& strSec, const _tstring& strKey = _T(""));

    // 导出文本
    std::wstring DumpWStr() const;
    std::string DumpAStr() const;
    std::string DumpU8Str() const;
    _tstring Dump() const;

    // 数据是否加密
    virtual bool IsEncrypted(const uint8_t* pData, size_t nSize);

    // 获取加密后数据
    virtual std::vector<uint8_t> GetEncryptData(const uint8_t* pData, size_t nSize);

    // 获取解密后数据
    virtual std::vector<uint8_t> GetDecryptData(const uint8_t* pData, size_t nSize);

private:

    std::vector<_tstring> SplitStringLine(const _tstring& str);
    _tstring _GetTextList(const std::vector<_tstring>& strList) const;
    bool _Parse(const _tstring& strCfg);
    _tstring _Dump(const INI_SECTION_LIST& mapData) const;

private:
    INI_SECTION_LIST m_SectionList;         // 节列表
    _tstring m_strFilePath;                 // 文件路径
    _tstring m_strCRLF;                     // 转行控制符
    std::vector<_tstring> EndTextList;      // 末尾文本
    eTextEncoding m_TextEncoding;           // 文本编码
    bool m_fAutoSave;                       // 自动保存(启用后设置数值时转储到文件)
    bool m_fEncrypt;                        // 加解密
};