#include "CMainFrameDlg.h"
#include "resource.h"
#include "6502/C6502Introduction.h"
#include "Win32Utils/CFileHelper.h"
#include "Win32Utils/CStrUtils.h"
#include "Win32Utils/CClipboardUtils.h"
#include "Win32Utils/CRegUtils.h"
#include <commctrl.h>
#include <strsafe.h>
#include <Windowsx.h>

#define WM_LANGUAGE_CHANGE                                  (WM_USER + 2)

#define CONFIG_REG_KEY                                      HKCU
#define CONFIG_ROOT_PATH                                    _T("Software\\FCDisassemble")
#define CONFIG_LOAD_ADDR                                    _T("LoadAddr")
#define CONFIG_LABEL_NAME                                   _T("LabelName")
#define CONFIG_ADDR_LIST                                    _T("AddrList")
#define CONFIG_DATA_LIST                                    _T("DataList")
#define CONFIG_INPUT_TEXT                                   _T("InputText")
#define CONFIG_OUTPUT_TEXT                                  _T("OutputText")
#define CONFIG_LANG_ID                                      _T("Language")
#define CONFIG_OUTPUT_SYNTAX                                _T("Syntax")

const UINT WM_TASKBARCREATED = ::RegisterWindowMessage(_T("TaskbarCreated"));

BEGIN_DLG_MESSAGE_MAP(CMainFrameDlg, CDialogBase)

    ON_DLG_MESSAGE(WM_INITDIALOG, &CMainFrameDlg::OnInitDialog)
    ON_DLG_MESSAGE(WM_LANGUAGE_CHANGE, &CMainFrameDlg::OnLanguageChange)
    ON_DLG_MESSAGE(WM_CLOSE, &CMainFrameDlg::OnClose)
    ON_DLG_MESSAGE(WM_NOTIFY, &CMainFrameDlg::OnNotify)
    //ON_DLG_MESSAGE(WM_CTLCOLORBTN, &CMainFrameDlg::OnColor)
    ON_DLG_MESSAGE(WM_CTLCOLOREDIT, &CMainFrameDlg::OnColor)
    //ON_DLG_MESSAGE(WM_CTLCOLORDLG, &CMainFrameDlg::OnColor)
    //ON_DLG_MESSAGE(WM_CTLCOLORLISTBOX, &CMainFrameDlg::OnColor)
    //ON_DLG_MESSAGE(WM_CTLCOLORSCROLLBAR, &CMainFrameDlg::OnColor)
    
    ON_DLG_COMMAND(IDC_BUTTON_DISASSEMBLE, &CMainFrameDlg::OnDisassemble)
    ON_DLG_COMMAND(IDC_BUTTON_PASTE, &CMainFrameDlg::OnPasteInput)
    ON_DLG_COMMAND(IDC_BUTTON_CLEAR, &CMainFrameDlg::OnClearInput)
    ON_DLG_COMMAND(IDC_BUTTON_COPY, &CMainFrameDlg::OnCopyOutput)
    ON_DLG_COMMAND(ID_FILE_EXIT, &CMainFrameDlg::OnExit)
    ON_DLG_COMMAND(ID_LANG_ZH_CN, &CMainFrameDlg::OnLangZh)
    ON_DLG_COMMAND(ID_LANG_EN_US, &CMainFrameDlg::OnLangEn)
    ON_DLG_COMMAND(ID_SYNTAX_NESASM, &CMainFrameDlg::OnSyntaxNesasm)
    ON_DLG_COMMAND(ID_SYNTAX_6502_SIMULATOR, &CMainFrameDlg::OnSyntax6502Simulator)
    ON_DLG_COMMAND(ID_RESET, &CMainFrameDlg::OnReset)
    //ON_DLG_COMMAND(IDC_EDIT_ADDR_CFG, &CMainFrameDlg::OnCtrlCommand)
    //ON_DLG_COMMAND(IDC_EDIT_INPUT, &CMainFrameDlg::OnCtrlCommand)

END_DLG_MESSAGE_MAP()

CMainFrameDlg::CMainFrameDlg()
{

}

CMainFrameDlg::~CMainFrameDlg()
{
    if (m_hBrush)
    {
        ::DeleteObject(m_hBrush);
    }
}

HWND CreateToolTip(int toolID, HWND hDlg, PTSTR pszText)
{
    if (!toolID || !hDlg || !pszText)
    {
        return FALSE;
    }

    // Get the window of the tool.
    HWND hwndTool = GetDlgItem(hDlg, toolID);

    // Create the tooltip. g_hInst is the global instance handle.
    HWND hwndTip = CreateWindowEx(NULL, TOOLTIPS_CLASS, NULL,
        WS_POPUP | TTS_ALWAYSTIP | TTS_BALLOON,
        CW_USEDEFAULT, CW_USEDEFAULT,
        CW_USEDEFAULT, CW_USEDEFAULT,
        hDlg, NULL,
        ::GetModuleHandle(NULL), NULL);

    if (!hwndTool || !hwndTip)
    {
        return (HWND)NULL;
    }

    // Associate the tooltip with the tool.
    TOOLINFO toolInfo = { 0 };
    toolInfo.cbSize = sizeof(toolInfo);
    toolInfo.hwnd = hDlg;
    toolInfo.uFlags = TTF_IDISHWND | TTF_SUBCLASS;
    toolInfo.uId = (UINT_PTR)hwndTool;
    toolInfo.lpszText = LPSTR_TEXTCALLBACK;
    SendMessage(hwndTip, TTM_ADDTOOL, 0, (LPARAM)&toolInfo);

    return hwndTip;
}

LRESULT CMainFrameDlg::OnNotify(WPARAM wParam, LPARAM lParam)
{
    LPNMHDR lpNmhdr = (LPNMHDR)lParam;
    if (TTN_GETDISPINFO == lpNmhdr->code)
    {
        SetThreadUILanguage(m_langId);

        LPNMTTDISPINFO lpNmTtd = (LPNMTTDISPINFO)lParam;

        if (m_hAddrListTip == lpNmhdr->hwndFrom)
        {
            StringCchPrintf(lpNmTtd->lpszText, 80,
                LoadString(IDS_STRING_ADDR_LIST_TIPS).c_str()
            );
        }

        if (m_hDataListTip == lpNmhdr->hwndFrom)
        {
            StringCchPrintf(lpNmTtd->lpszText, 80,
                LoadString(IDS_STRING_DATA_LIST_TIPS).c_str()
            );
        }

        if (m_hLoadAddrTip == lpNmhdr->hwndFrom)
        {
            StringCchPrintf(lpNmTtd->lpszText, 80,
                LoadString(IDS_STRING_LOAD_ADDR_TIPS).c_str()
            );
        }
    }

    return TRUE;
}

LRESULT CMainFrameDlg::OnReset(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd)
{
    SetDlgItemText(m_hWnd, IDC_EDIT_INPUT, _T(""));
    
    if (0 != wID)
    {
        OnDisassemble(0, 0);
    }

    return TRUE;
}

LRESULT CMainFrameDlg::OnInitDialog(WPARAM wParam, LPARAM lParam)
{
    // 设置图标
    HICON hIcon = LoadIcon(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_ICON));
    if (hIcon)
    {
        ::SendMessage(m_hWnd, WM_SETICON, ICON_BIG, (LPARAM)hIcon);
        ::SendMessage(m_hWnd, WM_SETICON, ICON_SMALL, (LPARAM)hIcon);
    }

    m_hAddrListTip = CreateToolTip(IDC_EDIT_ADDR_CFG, m_hWnd, LPSTR_TEXTCALLBACK);
    m_hDataListTip = CreateToolTip(IDC_EDIT_DATA_CFG, m_hWnd, LPSTR_TEXTCALLBACK);
    m_hLoadAddrTip = CreateToolTip(IDC_EDIT_LOAD_ADDR, m_hWnd, LPSTR_TEXTCALLBACK);

    Edit_LimitText(GetDlgItem(m_hWnd,IDC_EDIT_INPUT), 1024 * 1024 * 64);
    Edit_LimitText(GetDlgItem(m_hWnd, IDC_EDIT_OUTPUT), 1024 * 1024 * 64);

    OnReset(0, 0);

    if (CRegUtils::GetDword(CONFIG_REG_KEY, CONFIG_ROOT_PATH, CONFIG_LANG_ID, (DWORD&)m_langId))
    {
        if (LANG_CHINESE == PRIMARYLANGID(m_langId))
        {
            ::PostMessage(m_hWnd, WM_COMMAND, ID_LANG_ZH_CN, 0);
        }
        else
        {
            ::PostMessage(m_hWnd, WM_COMMAND, ID_LANG_EN_US, 0);
        }
    }
    else
    {
        LANGID langID = GetThreadUILanguage();
        if (LANG_CHINESE == PRIMARYLANGID(langID))
        {
            ::PostMessage(m_hWnd, WM_COMMAND, ID_LANG_ZH_CN, 0);
        }
        else
        {
            ::PostMessage(m_hWnd, WM_COMMAND, ID_LANG_EN_US, 0);
        }
    }

    if (CRegUtils::GetDword(CONFIG_REG_KEY, CONFIG_ROOT_PATH, CONFIG_OUTPUT_SYNTAX, m_dwSyntaxType))
    {
        if (0 == m_dwSyntaxType)
        {
            CheckMenuItem(GetMenu(m_hWnd), ID_SYNTAX_NESASM, MF_BYCOMMAND | MF_CHECKED);
        }
        else
        {
            CheckMenuItem(GetMenu(m_hWnd), ID_SYNTAX_6502_SIMULATOR, MF_BYCOMMAND | MF_CHECKED);
        }
    }
    else
    {
        CheckMenuItem(GetMenu(m_hWnd), ID_SYNTAX_NESASM, MF_BYCOMMAND | MF_CHECKED);
    }

    _tstring strValue;
    if (CRegUtils::GetString(CONFIG_REG_KEY, CONFIG_ROOT_PATH, CONFIG_INPUT_TEXT, strValue))
    {
        SetItemString(IDC_EDIT_INPUT, strValue);
    }
    if (CRegUtils::GetString(CONFIG_REG_KEY, CONFIG_ROOT_PATH, CONFIG_OUTPUT_TEXT, strValue))
    {
        SetItemString(IDC_EDIT_OUTPUT, strValue);
    }

    return TRUE;
}

LRESULT CMainFrameDlg::OnLanguageChange(WPARAM wParam, LPARAM lParam)
{
    m_langId = (LANGID)wParam;
    SetThreadUILanguage(m_langId);

    SetItemString(IDC_STATIC_INPUT, LoadString(IDS_STRING_INPUT));
    SetItemString(IDC_STATIC_OUTPUT, LoadString(IDS_STRING_OUTPUT));
    SetItemString(IDC_BUTTON_ASSEMBLE, LoadString(IDS_STRING_ASSEMBLE));
    SetItemString(IDC_BUTTON_COPY, LoadString(IDS_STRING_COPY));

    HMENU hMenu = GetMenu(m_hWnd);
    ModifyMenuText(hMenu, 0, IDS_STRING_FILE, TRUE);
    ModifyMenuText(hMenu, ID_FILE_EXIT, IDS_STRING_EXIT, FALSE);
    ModifyMenuText(hMenu, 1, IDS_STRING_SETTINGS, TRUE);
    ModifyMenuText(GetSubMenu(hMenu, 1), 0, IDS_STRING_LANGUAGE, TRUE);
    ModifyMenuText(GetSubMenu(hMenu, 1), 1, IDS_STRING_OUTPUT_SYNTAX, TRUE);
    ModifyMenuText(hMenu, ID_RESET, IDS_STRING_RESET, FALSE);

    CRegUtils::SetDword(CONFIG_REG_KEY, CONFIG_ROOT_PATH, CONFIG_LANG_ID, m_langId);

    ::SetWindowText(m_hWnd, LoadString(IDS_STRING_CAPTION).c_str());

    ::DrawMenuBar(m_hWnd);

    return TRUE;
}

LRESULT CMainFrameDlg::OnSyntaxNesasm(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd)
{
    CheckMenuItem(GetMenu(m_hWnd), ID_SYNTAX_NESASM, MF_BYCOMMAND | MF_UNCHECKED);
    CheckMenuItem(GetMenu(m_hWnd), ID_SYNTAX_6502_SIMULATOR, MF_BYCOMMAND | MF_UNCHECKED);
    CheckMenuItem(GetMenu(m_hWnd), wID, MF_BYCOMMAND | MF_CHECKED);

    m_dwSyntaxType = 0;
    CRegUtils::SetDword(CONFIG_REG_KEY, CONFIG_ROOT_PATH, CONFIG_OUTPUT_SYNTAX, m_dwSyntaxType);

    SendMessage(WM_COMMAND, IDC_BUTTON_DISASSEMBLE, 0);
    return TRUE;
}

LRESULT CMainFrameDlg::OnSyntax6502Simulator(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd)
{
    CheckMenuItem(GetMenu(m_hWnd), ID_SYNTAX_NESASM, MF_BYCOMMAND | MF_UNCHECKED);
    CheckMenuItem(GetMenu(m_hWnd), ID_SYNTAX_6502_SIMULATOR, MF_BYCOMMAND | MF_UNCHECKED);
    CheckMenuItem(GetMenu(m_hWnd), wID, MF_BYCOMMAND | MF_CHECKED);

    m_dwSyntaxType = 1;
    CRegUtils::SetDword(CONFIG_REG_KEY, CONFIG_ROOT_PATH, CONFIG_OUTPUT_SYNTAX, m_dwSyntaxType);

    SendMessage(WM_COMMAND, IDC_BUTTON_DISASSEMBLE, 0);
    return TRUE;
}

LRESULT CMainFrameDlg::OnLangZh(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd)
{
    m_langId = MAKELANGID(LANG_CHINESE, SUBLANG_CHINESE_SIMPLIFIED);
    PostMessage(WM_LANGUAGE_CHANGE, m_langId, 0);

    CheckMenuItem(GetMenu(m_hWnd), ID_LANG_ZH_CN, MF_BYCOMMAND | MF_UNCHECKED);
    CheckMenuItem(GetMenu(m_hWnd), ID_LANG_EN_US, MF_BYCOMMAND | MF_UNCHECKED);
    CheckMenuItem(GetMenu(m_hWnd), wID, MF_BYCOMMAND | MF_CHECKED);
    return TRUE;
}

LRESULT CMainFrameDlg::OnLangEn(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd)
{
    m_langId = MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_US);
    PostMessage(WM_LANGUAGE_CHANGE, m_langId, 0);

    CheckMenuItem(GetMenu(m_hWnd), ID_LANG_ZH_CN, MF_BYCOMMAND | MF_UNCHECKED);
    CheckMenuItem(GetMenu(m_hWnd), ID_LANG_EN_US, MF_BYCOMMAND | MF_UNCHECKED);
    CheckMenuItem(GetMenu(m_hWnd), wID, MF_BYCOMMAND | MF_CHECKED);
    return TRUE;
}

LRESULT CMainFrameDlg::OnExit(WPARAM wParam, LPARAM lParam)
{
    PostMessage(WM_CLOSE, 0, 0);
    return TRUE;
}

LRESULT CMainFrameDlg::OnClose(WPARAM wParam, LPARAM lParam)
{
    CRegUtils::SetString(CONFIG_REG_KEY, CONFIG_ROOT_PATH, CONFIG_LOAD_ADDR, GetItemString(IDC_EDIT_LOAD_ADDR));
    CRegUtils::SetString(CONFIG_REG_KEY, CONFIG_ROOT_PATH, CONFIG_LABEL_NAME, GetItemString(IDC_EDIT_LABEL_NAME));
    CRegUtils::SetString(CONFIG_REG_KEY, CONFIG_ROOT_PATH, CONFIG_ADDR_LIST, GetItemString(IDC_EDIT_ADDR_CFG));
    CRegUtils::SetString(CONFIG_REG_KEY, CONFIG_ROOT_PATH, CONFIG_DATA_LIST, GetItemString(IDC_EDIT_DATA_CFG));
    CRegUtils::SetString(CONFIG_REG_KEY, CONFIG_ROOT_PATH, CONFIG_INPUT_TEXT, GetItemString(IDC_EDIT_INPUT));
    CRegUtils::SetString(CONFIG_REG_KEY, CONFIG_ROOT_PATH, CONFIG_OUTPUT_TEXT, GetItemString(IDC_EDIT_OUTPUT));
    CRegUtils::SetDword(CONFIG_REG_KEY, CONFIG_ROOT_PATH, CONFIG_LANG_ID, m_langId);

    return FALSE;
}

LRESULT CMainFrameDlg::OnDisassemble(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd)
{
    _tstring strLoadAddr = GetItemString(IDC_EDIT_LOAD_ADDR);
    _tstring strLabelName = GetItemString(IDC_EDIT_LABEL_NAME);
    _tstring strAddrCfg = GetItemString(IDC_EDIT_ADDR_CFG);
    _tstring strDataCfg = GetItemString(IDC_EDIT_DATA_CFG);
    _tstring strInput = GetItemString(IDC_EDIT_INPUT);

    std::vector<uint16_t> addrList;
    std::map<uint16_t, uint16_t> dataList;
    uint16_t loadAddr = 0x8000;

    _stscanf_s(strLoadAddr.c_str(), _T("%hx"), &loadAddr);

    //解析地址段
    {
        std::vector<_tstring> vStrValue = CStrUtils::SplitStr(strAddrCfg, _T(","));
        for (const auto& item : vStrValue)
        {
            addrList.push_back((uint16_t)_tcstol(item.c_str(), nullptr, 16));
        }

        if (addrList.empty())
        {
            addrList.push_back(loadAddr);
        }
    }

    //解析数据段
    {
        std::vector<_tstring> vStrValue = CStrUtils::SplitStr(strDataCfg, _T(";"));
        for (const auto& item : vStrValue)
        {
            uint32_t addr = 0;
            uint32_t size = 0;
            _stscanf_s(item.c_str(), _T("%4x,%4x"), &addr, &size);
            dataList.insert(std::make_pair((uint16_t)addr, (uint16_t)size));
        }
    }

    //分配 64KB 缓冲空间
    std::vector<uint8_t> dataBuffer(1024 * 64);

    LPBYTE lpData = dataBuffer.data();

    HexStringToBytes(strInput.c_str(), strInput.size(), lpData + loadAddr, dataBuffer.size() - loadAddr);

    std::map<uint16_t, C6502Introduction> IntroductionData;
    DisassembleInstructions(IntroductionData, dataList, addrList, lpData, (uint32_t)dataBuffer.size());
    _tstring strOutput = GetDisassembleText(IntroductionData, strLabelName, lpData, (uint32_t)dataBuffer.size(), true, m_dwSyntaxType);

    SetItemString(IDC_EDIT_OUTPUT, strOutput);

    return TRUE;
}

LRESULT CMainFrameDlg::OnPasteInput(WPARAM wParam, LPARAM lParam)
{
    _tstring strInput;
    if (CClipboardUtils::GetText(strInput))
    {
        SetItemString(IDC_EDIT_INPUT, strInput);
    }

    return TRUE;
}

LRESULT CMainFrameDlg::OnClearInput(WPARAM wParam, LPARAM lParam)
{
    SetItemString(IDC_EDIT_INPUT, _T(""));
    return TRUE;
}

LRESULT CMainFrameDlg::OnCopyOutput(WPARAM wParam, LPARAM lParam)
{
    CClipboardUtils::SetText(GetItemString(IDC_EDIT_OUTPUT));
    return TRUE;
}

LRESULT CMainFrameDlg::OnColor(WPARAM wParam, LPARAM lParam)
{
    HDC hdc = (HDC)wParam;

    if (NULL == m_hBrush)
    {
        m_hBrush = CreateSolidBrush(RGB(77, 77, 77));
    }

    ::SetTextColor(hdc, RGB(250, 250, 250));
    ::SetBkColor(hdc, RGB(77, 77, 77));

    return (LRESULT)m_hBrush;
}

LRESULT CMainFrameDlg::OnCtrlCommand(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd)
{
    if (IDC_EDIT_INPUT == wID && wNotify == EN_CHANGE)
    {
        _tstring strAddrCfg = GetItemString(wID);

        std::vector<uint8_t> dataBuffer(1024 * 64);
        LPBYTE lpData = dataBuffer.data();
        int nBytes = HexStringToBytes(strAddrCfg.c_str(), strAddrCfg.size(), lpData, dataBuffer.size());

        std::vector<uint8_t>  dataString(1024 * 128);
        LPTSTR lpStr = (LPTSTR)dataString.data();
        BytesToHexString(lpData, nBytes, lpStr, dataString.size());
        //SetItemString(wId, lpStr);
        return FALSE;
    }


    if (wNotify == EN_CHANGE)
    {
        _tstring strAddrCfg = GetItemString(wID);

        return FALSE;
    }

    return FALSE;
}

int CMainFrameDlg::HexStringToBytes(LPCTSTR pString, int nStrCount, uint8_t* pBytes, int nBytesSize)
{
    int nConvertSize = 0;
    uint8_t byteHigh = 0;
    uint8_t byteLow = 0;

    if (nullptr == pString || nStrCount <= 0 || nullptr == pBytes || nBytesSize <= 0)
    {
        return 0;
    }

    for (int i = 0; i < nStrCount; )
    {
        byteHigh = (uint8_t)pString[i];
        byteLow = (uint8_t)pString[i + 1];

        //高4位
        if (byteHigh >= '0' && byteHigh <= '9')
        {
            byteHigh = byteHigh - '0';
        }
        else if (byteHigh >= 'A' && byteHigh <= 'F')
        {
            byteHigh = byteHigh - 'A' + 10;
        }
        else if (byteHigh >= 'a' && byteHigh <= 'f')
        {
            byteHigh = byteHigh - 'a' + 10;
        }
        else
        {
            i++;
            continue;
        }
        i++;

        //低4位
        if (byteLow >= '0' && byteLow <= '9')
        {
            byteLow = byteLow - '0';
        }
        else if (byteLow >= 'A' && byteLow <= 'F')
        {
            byteLow = byteLow - 'A' + 10;
        }
        else if (byteLow >= 'a' && byteLow <= 'f')
        {
            byteLow = byteLow - 'a' + 10;
        }
        else
        {
            i++;
            continue;
        }
        i++;

        pBytes[nConvertSize] = (byteHigh << 4) | byteLow;
        nConvertSize++;

        //检查已转换大小, 及时跳出防止缓冲区溢出
        if (nConvertSize >= nBytesSize)
        {
            break;
        }
    }

    return nConvertSize;
}

int CMainFrameDlg::BytesToHexString(const uint8_t* pBytes, int nBytesSize, LPTSTR pString, int nStrCount)
{
    const char szHex[] = "0123456789ABCDEF";
    int nConvertSize = 0;

    if (nullptr == pString || nStrCount <= 0 || nullptr == pBytes || nBytesSize <= 0)
    {
        return 0;
    }

    int nStrIndex = 0;
    for (int i = 0; i < nBytesSize; i++)
    {
        if (0 != i && (0 == (i % 0x10)))
        {
            pString[nStrIndex++] = _T('\r');
            pString[nStrIndex++] = _T('\n');
        }

        pString[nStrIndex++] = szHex[pBytes[i] >> 4];
        pString[nStrIndex++] = szHex[pBytes[i] & 0x0F];
        pString[nStrIndex++] = _T(' ');
        nConvertSize += 2;

        //检查已转换大小, 及时跳出防止缓冲区溢出
        if (nConvertSize >= nStrCount || (nConvertSize + 1) >= nStrCount)
        {
            break;
        }
    }

    if (nConvertSize < nStrCount)
    {
        pString[nConvertSize * sizeof(TCHAR)] = '\0';
    }

    return nConvertSize;
}