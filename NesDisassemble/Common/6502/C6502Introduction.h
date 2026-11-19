#pragma once
#include <stdint.h>
#include <string>
#include <map>
#include <vector>
#include <tchar.h>

#ifdef _UNICODE
using _tstring = std::wstring;
#else
using _tstring = std::string;
#endif

//寻址模式
enum e6502AddressingMode
{
    eModeImplicit,          //隐含寻址
    eModeAccumulator,       //累加器寻址
    eModeImmediate,         //立即寻址
    eModeRelative,          //相对寻址
    eModeZeroPage,          //零页寻址
    eModeZeroPageX,         //零页寻址X变址
    eModeZeroPageY,         //零页寻址Y变址
    eModeAbsolute,          //绝对寻址
    eModeAbsoluteX,         //绝对寻址X变址
    eModeAbsoluteY,         //绝对寻址Y变址
    eModeIndirect,          //间接寻址
    eModeIndexedIndirect,   //先变址寻址后间接寻址
    eModeIndirectIndexed,   //先间接寻址后变址寻址
    eModeReserved,          //保留作为其他用途
};

// bank大小
enum eBankSize:uint16_t
{
    eBank_None,
    eBank_8,
    eBank_16,
    eBank_32
};

//指令信息
class C6502Introduction
{
public:

    C6502Introduction(
        uint8_t op,
        const _tstring& strName,
        e6502AddressingMode type,
        uint16_t addr = (uint16_t)0,
        uint16_t data = (uint16_t)0,
        uint8_t elem = (uint16_t)1,
        bool fLabbeled = false,
        bool fData = false
    )
        : 
        m_op(op), 
        m_op_name(strName), 
        m_type(type), 
        m_addr(addr), 
        m_data(data),
        m_elem(elem),
        m_fLabeled(fLabbeled), 
        m_fData(fData),
        m_id((uint16_t)-1),
        m_refId((uint16_t)-1),
        m_bank_index(0),
        m_bank_size(eBankSize::eBank_None),
        m_org(0),
        m_offset(0),
        m_refAddr(0)
    {
    }

    //获取指令名
    _tstring GetName() const;

    //获取寻址模式
    e6502AddressingMode GetAddressingMode() const;

    //获取操作数长度
    uint8_t GetDataSize() const;

    //获取指令总长度
    uint8_t GetSize() const;

    //获取指令地址
    uint16_t GetAddr() const;

    //获取下一个指令地址
    uint16_t GetNextAddr() const;

    //获取指令数据
    uint16_t GetData() const;

    //获取元素大小
    uint16_t GetElemSize() const;

    //设置元素大小
    void SetElemSize(uint8_t elem);

    //获取调用地址
    uint16_t GetCallAddr() const;

    //是否存取绝对地址
    bool IsAbsoluteRead() const;

    //是否为JSR或JMP调用地址(绝对寻址, 不包含JMP间接寻址)
    bool IsJsrOrJmpAbsolute() const;

    //是否为JMP绝对寻址
    bool IsJmpAbsolute() const;

    //是否为Jsr绝对寻址
    bool IsJsrAbsolute() const;

    //是否调用相对寻址
    bool IsRelative() const;

    //是否标签化
    bool IsLabbeled() const;

    //是否保留
    bool IsReserved() const;

    //设置保留状态
    void SetReserved(bool bData);

    //设置标签化
    void SetLabbeled(bool bLabled);

    //获取调用标签ID
    uint16_t GetRefID() const;

    //设置调用标签ID
    void SetRefID(uint16_t id);

    //设置指令地址
    void SetAddr(uint16_t addr);

    //设置操作数
    void SetData(uint16_t data);

    void SetLabelName(const _tstring& name);
    const _tstring& GetLabelName() const;

public:

    _tstring            m_op_name;              // 指令名
    uint8_t             m_op;                   // 操作码
    uint16_t            m_data;                 // 操作数
    uint16_t            m_id;                   // 标签ID
    uint16_t            m_refId;                // 引用标签ID
    uint16_t            m_refAddr;              // 引用地址
    uint16_t            m_offset;               // 引用标签偏移

    uint16_t            m_addr;                 // 指令地址
    uint16_t            m_bank_index;           // bank 索引
    eBankSize           m_bank_size;            // bank 大小
    uint16_t            m_org;                  // org 地址

    e6502AddressingMode m_type;                 // 寻址类型
    uint8_t             m_elem;                 // 元素大小
    _tstring            m_label_name;           // 标签


    bool                m_fLabeled;             // 标签化
    bool                m_fData;                // 数据保留
};

extern std::map<uint8_t, C6502Introduction> g_6502_Introduction_Set;