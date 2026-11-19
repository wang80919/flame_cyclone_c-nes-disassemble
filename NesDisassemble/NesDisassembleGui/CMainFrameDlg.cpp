#include "CMainFrameDlg.h"
#include "resource.h"
#include "6502/C6502Disassemble.h"
#include "Win32Utils/CFileHelper.h"
#include "Win32Utils/CStrUtils.h"
#include "Win32Utils/CBytesUtils.h"
#include "Win32Utils/CPathUtils.h"
#include "Win32Utils/CClipboardUtils.h"
#include <commctrl.h>
#include <strsafe.h>
#include <Windowsx.h>
#include <set>

#define WM_LANGUAGE_CHANGE                                  (WM_USER + 2)

const UINT WM_TASKBARCREATED = ::RegisterWindowMessage(_T("TaskbarCreated"));

BEGIN_DLG_MESSAGE_MAP(CMainFrameDlg, CDialogBase)

    ON_DLG_MESSAGE(WM_INITDIALOG, &CMainFrameDlg::OnInitDialog)
    ON_DLG_MESSAGE(WM_DROPFILES, &CMainFrameDlg::OnDragFiles)
    ON_DLG_MESSAGE(WM_LANGUAGE_CHANGE, &CMainFrameDlg::OnLanguageChange)
    ON_DLG_MESSAGE(WM_CLOSE, &CMainFrameDlg::OnClose)
    ON_DLG_MESSAGE(WM_GETMINMAXINFO, &CMainFrameDlg::GetMinMaxInfo)
    ON_DLG_MESSAGE(WM_SIZE, &CMainFrameDlg::OnSize)
    ON_DLG_MESSAGE(WM_NOTIFY, &CMainFrameDlg::OnNotify)
    ON_DLG_MESSAGE(WM_CTLCOLOREDIT, &CMainFrameDlg::OnColor)
    
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
    ON_DLG_COMMAND(IDC_CHECK_SHOW_ADDR, &CMainFrameDlg::OnShowAddr)

END_DLG_MESSAGE_MAP()

CMainFrameDlg::CMainFrameDlg()
    :
    m_cfg(_T("config\\config.ini"), true, true, false)
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
    }

    return TRUE;
}

LRESULT CMainFrameDlg::OnReset(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd)
{
    SetDlgItemText(m_hWnd, IDC_EDIT_LOAD_ADDR, _T("8000"));
    SetDlgItemText(m_hWnd, IDC_EDIT_LABEL_NAME, _T("Label_"));
    
    if (0 != wID)
    {
        OnDisassemble(0, 0, 0, 0, 0);
    }

    return TRUE;
}

LRESULT CMainFrameDlg::OnInitDialog(WPARAM wParam, LPARAM lParam)
{
    CHANGEFILTERSTRUCT cfs = { 0 };
    cfs.cbSize = sizeof(cfs);
    ChangeWindowMessageFilterEx(m_hWnd, WM_DROPFILES, MSGFLT_ALLOW, &cfs);
    ChangeWindowMessageFilterEx(m_hWnd, WM_COPYDATA, MSGFLT_ALLOW, &cfs);
    ChangeWindowMessageFilterEx(m_hWnd, WM_COPYDATA - 1, MSGFLT_ALLOW, &cfs);

    // 设置图标
    HICON hIcon = LoadIcon(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_ICON));
    if (hIcon)
    {
        ::SendMessage(m_hWnd, WM_SETICON, ICON_BIG, (LPARAM)hIcon);
        ::SendMessage(m_hWnd, WM_SETICON, ICON_SMALL, (LPARAM)hIcon);
    }

    Edit_LimitText(GetDlgItem(m_hWnd,IDC_EDIT_INPUT), STRING_BUF_SIZE);
    Edit_LimitText(GetDlgItem(m_hWnd, IDC_EDIT_OUTPUT), STRING_BUF_SIZE);

    OnReset(0, 0, 0, 0, 0);

    m_langId = m_cfg.GetInt(_T("config"), CONFIG_LANG_ID, -1);
    if (UINT16_MAX != m_langId)
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

    m_dwSyntaxType = m_cfg.GetInt(_T("config"), CONFIG_OUTPUT_SYNTAX, 0);
    if (0 == m_dwSyntaxType)
    {
        CheckMenuItem(GetMenu(m_hWnd), ID_SYNTAX_NESASM, MF_BYCOMMAND | MF_CHECKED);
    }
    else
    {
        CheckMenuItem(GetMenu(m_hWnd), ID_SYNTAX_6502_SIMULATOR, MF_BYCOMMAND | MF_CHECKED);
    }

    _tstring strCfgDir = CPathUtils::GetCurrentModuleDir() + _T("\\config");
    CPathUtils::CreateDir(strCfgDir);

    _tstring strValue;

    ::SendMessage(GetItem(IDC_EDIT_INPUT), EM_LIMITTEXT, 1024 * 1024 * 64, 0);
    ::SendMessage(GetItem(IDC_EDIT_OUTPUT), EM_LIMITTEXT, 1024 * 1024 * 64, 0);

    SetItemString(IDC_EDIT_LOAD_ADDR, m_cfg.GetString(_T("config"), CONFIG_LOAD_ADDR));
    SetItemString(IDC_EDIT_LABEL_NAME, m_cfg.GetString(_T("config"), CONFIG_LABEL_NAME));
    SetItemString(IDC_EDIT_OUT_PATH, m_cfg.GetString(_T("config"), CONFIG_OUT_PATH));
    SetItemString(IDC_EDIT_INPUT, m_cfg.GetString(_T("config"), CONFIG_IN_PATH));
    SetItemString(IDC_EDIT_OUTPUT, CStrUtils::FromFile(strCfgDir + _T("\\output.txt"), true));

    m_fShowAddr = m_cfg.GetInt(_T("config"), CONFIG_SHOW_ADDR, 0);
    if (m_fShowAddr)
    {
        ::CheckDlgButton(m_hWnd, IDC_CHECK_SHOW_ADDR, BST_CHECKED);
    }

    RECT rt = { 0 };
    ::GetClientRect(m_hWnd, &rt);
    PostMessage(WM_SIZE, 0, MAKELONG(rt.right - rt.left, rt.bottom - rt.top));

    return TRUE;
}

RECT CMainFrameDlg::GetChildRect(HWND hWnd)
{
    RECT rect = { 0 };
    GetWindowRect(hWnd, &rect);
    POINT pt = { rect.left, rect.top };
    ::ScreenToClient(m_hWnd, &pt);

    return { pt.x, pt.y,  pt.x + (rect.right - rect.left), pt.y + (rect.bottom - rect.top) };
}

LRESULT CMainFrameDlg::GetMinMaxInfo(WPARAM wParam, LPARAM lParam)
{
    LPMINMAXINFO pMinMaxInfo = (LPMINMAXINFO)lParam;

    pMinMaxInfo->ptMinTrackSize = {768, 480};

    return TRUE;
}

LRESULT CMainFrameDlg::OnSize(WPARAM wParam, LPARAM lParam)
{
    if (SIZE_MINIMIZED == wParam)
    {
        return TRUE;
    }

    int nClientWidth = LOWORD(lParam);
    int nClientHeight = HIWORD(lParam);
    int nInterval = 8;

    // 输入窗口
    {

        {
            HWND hStaticLoadAddr = GetItem(IDC_STATIC_LOAD_ADDR);
            HWND hEditLoadAddr = GetItem(IDC_EDIT_LOAD_ADDR);
            RECT rtItem1 = GetChildRect(hStaticLoadAddr);
            int nPosX = rtItem1.left;
            int nPosY = rtItem1.top;
            int nHeight = rtItem1.bottom - rtItem1.top;
            int nWidth = rtItem1.right - rtItem1.left;
            ::MoveWindow(hStaticLoadAddr, nPosX, nPosY, nWidth, nHeight, TRUE);

            RECT rtItem = GetChildRect(hEditLoadAddr);
            nPosY = rtItem.top;
            nPosX = rtItem1.right;
            nHeight = rtItem.bottom - rtItem.top;
            nWidth = nClientWidth / 2 - rtItem1.right;
            ::MoveWindow(hEditLoadAddr, nPosX, nPosY, nWidth, nHeight, TRUE);
        }

        {
            HWND hStaticInput = GetItem(IDC_STATIC_INPUT);
            HWND hInputEdit = GetItem(IDC_EDIT_INPUT);

            RECT rtItem1 = GetChildRect(hStaticInput);
            int nPosX = rtItem1.left;
            int nPosY = rtItem1.top;
            int nHeight = rtItem1.bottom - rtItem1.top;
            int nWidth = rtItem1.right - rtItem1.left;
            ::MoveWindow(hStaticInput, nPosX, nPosY, nWidth, nHeight, TRUE);

            RECT rtItem = GetChildRect(hInputEdit);
            nPosY = rtItem.top;
            nPosX = rtItem1.right;
            nHeight = rtItem.bottom - rtItem.top;
            nWidth = nClientWidth - rtItem1.right - ::GetSystemMetrics(SM_CXVSCROLL);
            ::MoveWindow(hInputEdit, nPosX, nPosY, nWidth, nHeight, TRUE);
        }
    }

    // 输出窗口
    {
        {
            HWND hStaticLabelName = GetItem(IDC_STATIC_LABEL_NAME);
            HWND hEditLabelName = GetItem(IDC_EDIT_LABEL_NAME);
            HWND hCheckShowAddr = GetItem(IDC_CHECK_SHOW_ADDR);

            RECT rtItem1 = GetChildRect(hStaticLabelName);
            int nPosX = nClientWidth / 2;
            int nPosY = rtItem1.top;
            int nHeight = rtItem1.bottom - rtItem1.top;
            int nWidth = rtItem1.right - rtItem1.left;
            ::MoveWindow(hStaticLabelName, nPosX, nPosY, nWidth, nHeight, TRUE);

            RECT rtItem3 = GetChildRect(hCheckShowAddr);
            nPosY = rtItem3.top;
            nWidth = rtItem3.right - rtItem3.left;
            nPosX = nClientWidth - nWidth - ::GetSystemMetrics(SM_CXVSCROLL) - nInterval;
            nHeight = rtItem3.bottom - rtItem3.top;
            ::MoveWindow(hCheckShowAddr, nPosX, nPosY, nWidth, nHeight, TRUE);

            RECT rtItem2 = GetChildRect(hEditLabelName);
            nPosY = rtItem2.top;
            nPosX = nClientWidth / 2 + (rtItem1.right - rtItem1.left);
            nWidth = (nClientWidth - (rtItem3.right - rtItem3.left) - ::GetSystemMetrics(SM_CXVSCROLL) - nInterval) - (nClientWidth / 2 +(rtItem1.right - rtItem1.left)) - nInterval;
            nHeight = rtItem2.bottom - rtItem2.top;
            ::MoveWindow(hEditLabelName, nPosX, nPosY, nWidth, nHeight, TRUE);
        }
        {
            HWND hStaticOutPath = GetItem(IDC_STATIC_OUT_PATH);
            HWND hEditOutPath = GetItem(IDC_EDIT_OUT_PATH);

            RECT rtItem1 = GetChildRect(hStaticOutPath);
            int nPosX = rtItem1.left;
            int nPosY = rtItem1.top;
            int nHeight = rtItem1.bottom - rtItem1.top;
            int nWidth = rtItem1.right - rtItem1.left;
            ::MoveWindow(hStaticOutPath, nPosX, nPosY, nWidth, nHeight, TRUE);

            RECT rtItem = GetChildRect(hEditOutPath);
            nPosY = rtItem.top;
            nPosX = rtItem1.right;
            nHeight = rtItem.bottom - rtItem.top;
            nWidth = nClientWidth - rtItem1.right - ::GetSystemMetrics(SM_CXVSCROLL);
            ::MoveWindow(hEditOutPath, nPosX, nPosY, nWidth, nHeight, TRUE);
        }

        {
            HWND hStaticOut = GetItem(IDC_STATIC_OUTPUT);
            HWND hButtonDisassemble = GetItem(IDC_BUTTON_DISASSEMBLE);
            HWND hButtonCopy = GetItem(IDC_BUTTON_COPY);

            int nWidth = (nClientWidth - (nInterval * 2)) /  3 - nInterval;
            RECT rtItem = GetChildRect(hStaticOut);
            int nPosX = nInterval;
            int nPosY = rtItem.top;
            int nHeight = rtItem.bottom - rtItem.top;
            ::MoveWindow(hStaticOut, nPosX, nPosY, nWidth - nInterval, nHeight, TRUE);

            rtItem = GetChildRect(hButtonDisassemble);
            nPosY = rtItem.top;
            nPosX += nWidth;
            nHeight = rtItem.bottom - rtItem.top;
            ::MoveWindow(hButtonDisassemble, nPosX, nPosY, nWidth - nInterval, nHeight, TRUE);

            rtItem = GetChildRect(hButtonCopy);
            nPosY = rtItem.top;
            nPosX += nWidth;
            nHeight = rtItem.bottom - rtItem.top;
            ::MoveWindow(hButtonCopy, nPosX, nPosY, nWidth - nInterval, nHeight, TRUE);
        }

        {
            HWND hOutputEdit = GetItem(IDC_EDIT_OUTPUT);
            RECT rtItem = GetChildRect(hOutputEdit);
            int nPosY = rtItem.top;
            int nWidth = (nClientWidth - (nInterval * 2));
            int nHeight = nClientHeight - rtItem.top - nInterval;
            int nPosX = nInterval;
            ::MoveWindow(hOutputEdit, nPosX, nPosY, nWidth, nHeight, TRUE);
        }
    }

    return TRUE;
}

LRESULT CMainFrameDlg::OnLanguageChange(WPARAM wParam, LPARAM lParam)
{
    m_langId = (LANGID)wParam;
    SetThreadUILanguage(m_langId);

    SetItemString(IDC_STATIC_LOAD_ADDR, LoadString(IDS_STRING_LOAD_ADDR));
    SetItemString(IDC_STATIC_LABEL_NAME, LoadString(IDS_STRING_LABEL_NAME));
    SetItemString(IDC_STATIC_INPUT, LoadString(IDS_STRING_INPUT));
    SetItemString(IDC_STATIC_OUTPUT, LoadString(IDS_STRING_OUTPUT));
    SetItemString(IDC_BUTTON_DISASSEMBLE, LoadString(IDS_STRING_DISASSEMBLE));
    SetItemString(IDC_BUTTON_COPY, LoadString(IDS_STRING_COPY));
    SetItemString(IDC_CHECK_SHOW_ADDR, LoadString(IDS_STRING_SHOW_ADDR));
    SetItemString(IDC_BUTTON_FORMAT, LoadString(IDS_STRING_FORMAT));
    SetItemString(IDC_STATIC_OUT_PATH, LoadString(IDS_STRING_OUT_PATH));

    HMENU hMenu = GetMenu(m_hWnd);
    ModifyMenuText(hMenu, 0, IDS_STRING_FILE, TRUE);
    ModifyMenuText(hMenu, ID_FILE_EXIT, IDS_STRING_EXIT, FALSE);
    ModifyMenuText(hMenu, 1, IDS_STRING_SETTINGS, TRUE);
    ModifyMenuText(GetSubMenu(hMenu, 1), 0, IDS_STRING_LANGUAGE, TRUE);
    ModifyMenuText(GetSubMenu(hMenu, 1), 1, IDS_STRING_OUTPUT_SYNTAX, TRUE);
    ModifyMenuText(hMenu, ID_RESET, IDS_STRING_RESET, FALSE);

    m_cfg.SetInt(_T("config"), CONFIG_LANG_ID, m_langId);

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
    m_cfg.SetInt(_T("config"), CONFIG_OUTPUT_SYNTAX, m_dwSyntaxType);
    SendMessage(WM_COMMAND, IDC_BUTTON_DISASSEMBLE, 0);
    return TRUE;
}

LRESULT CMainFrameDlg::OnSyntax6502Simulator(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd)
{
    CheckMenuItem(GetMenu(m_hWnd), ID_SYNTAX_NESASM, MF_BYCOMMAND | MF_UNCHECKED);
    CheckMenuItem(GetMenu(m_hWnd), ID_SYNTAX_6502_SIMULATOR, MF_BYCOMMAND | MF_UNCHECKED);
    CheckMenuItem(GetMenu(m_hWnd), wID, MF_BYCOMMAND | MF_CHECKED);

    m_dwSyntaxType = 1;
    m_cfg.SetInt(_T("config"), CONFIG_OUTPUT_SYNTAX, m_dwSyntaxType);
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

LRESULT CMainFrameDlg::OnExit(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd)
{
    PostMessage(WM_CLOSE, 0, 0);
    return TRUE;
}

LRESULT CMainFrameDlg::OnClose(WPARAM wParam, LPARAM lParam)
{
    SaveConfig();

    return FALSE;
}

void CMainFrameDlg::SaveConfig()
{
    m_cfg.SetString(_T("config"), CONFIG_LOAD_ADDR, GetItemString(IDC_EDIT_LOAD_ADDR));
    m_cfg.SetString(_T("config"), CONFIG_LABEL_NAME, GetItemString(IDC_EDIT_LABEL_NAME));
    m_cfg.SetString(_T("config"), CONFIG_IN_PATH, GetItemString(IDC_EDIT_INPUT));
    m_cfg.SetString(_T("config"), CONFIG_OUT_PATH, GetItemString(IDC_EDIT_OUT_PATH));
    m_cfg.SetInt(_T("config"), CONFIG_LANG_ID, m_langId);
    m_cfg.SetInt(_T("config"), CONFIG_SHOW_ADDR, m_fShowAddr);

    _tstring strCfgDir = CPathUtils::GetCurrentModuleDir() + _T("\\config");
    CStrUtils::ToFile(GetItemString(IDC_EDIT_OUTPUT), strCfgDir + _T("\\output.txt"));
}

dlg_msg LRESULT CMainFrameDlg::OnDragFiles(WPARAM wParam, LPARAM lParam)
{
    HDROP hDrop = (HDROP)wParam;

    TCHAR szBuf[MAX_PATH * 4] = { 0 }; 
    DragQueryFile(hDrop, 0, szBuf, _countof(szBuf));

    ::DragFinish(hDrop);

    if (CPathUtils::IsArchive(szBuf))
    {
        SetItemString(IDC_EDIT_INPUT, szBuf);
    }

    return FALSE;
}

LRESULT CMainFrameDlg::OnDisassemble(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd)
{
    _tstring strLabelName = GetItemString(IDC_EDIT_LABEL_NAME);
    _tstring strInput = CStrUtils::FromFile(GetItemString(IDC_EDIT_INPUT), true);
    uint16_t loadAddr = CStrUtils::StrToInt(GetItemString(IDC_EDIT_LOAD_ADDR), 16);

    m_fShowAddr = IsDlgButtonChecked(m_hWnd, IDC_CHECK_SHOW_ADDR);

    SaveConfig();

    _tstring strOutput = DisassembleText(strInput, strLabelName, loadAddr, m_fShowAddr, m_dwSyntaxType);
    SetItemString(IDC_EDIT_OUTPUT, strOutput);

    CFileHelper outFile(GetItemString(IDC_EDIT_OUT_PATH), false);
    if (outFile.IsOpen())
    {
        outFile.Clear();
        std::string strAsm = CStrUtils::TStrToU8Str(strOutput);
        outFile.Write(strAsm.c_str(), strAsm.size());
    }

    return TRUE;
}

LRESULT CMainFrameDlg::OnPasteInput(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd)
{
    _tstring strInput;
    if (CClipboardUtils::GetText(strInput))
    {
        SetItemString(IDC_EDIT_INPUT, strInput);
    }

    return TRUE;
}

LRESULT CMainFrameDlg::OnClearInput(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd)
{
    SetItemString(IDC_EDIT_INPUT, _T(""));
    return TRUE;
}

LRESULT CMainFrameDlg::OnCopyOutput(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd)
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

LRESULT CMainFrameDlg::OnShowAddr(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd)
{
    m_fShowAddr = BST_CHECKED == ::IsDlgButtonChecked(m_hWnd, IDC_CHECK_SHOW_ADDR);
    return TRUE;
}

