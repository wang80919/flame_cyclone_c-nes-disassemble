#pragma once
#include "CWindow/CDialogBase.h"
#include "Win32Utils/CIniHelperX.h"

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
#define CONFIG_SHOW_ADDR                                    _T("ShowAddr")
#define CONFIG_IN_PATH                                      _T("InPath")
#define CONFIG_OUT_PATH                                     _T("OutPath")


#define STRING_BUF_SIZE                                     (1024 * 1024 * 64)

class CMainFrameDlg :
    public CDialogBase
{
public:

    CMainFrameDlg();
    ~CMainFrameDlg();

    dlg_msg LRESULT OnInitDialog(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT OnLanguageChange(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT OnClose(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT OnDragFiles(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT OnNotify(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT GetMinMaxInfo(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT OnSize(WPARAM wParam, LPARAM lParam);

    dlg_msg LRESULT OnReset(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd);
    dlg_msg LRESULT OnLangZh(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd);
    dlg_msg LRESULT OnLangEn(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd);
    dlg_msg LRESULT OnSyntaxNesasm(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd);
    dlg_msg LRESULT OnSyntax6502Simulator(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd);
    dlg_msg LRESULT OnDisassemble(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd);
    dlg_msg LRESULT OnPasteInput(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd);
    dlg_msg LRESULT OnClearInput(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd);
    dlg_msg LRESULT OnCopyOutput(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd);

    dlg_msg LRESULT OnExit(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd);
    dlg_msg LRESULT OnCtrlCommand(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd);
    dlg_msg LRESULT OnColor(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT OnShowAddr(WORD wNotify, WORD wID, HWND hWnd, WORD wStart, WORD wEnd);

private:

    RECT GetChildRect(HWND hWnd);
    void SaveConfig();

    DECLARE_DLG_MESSAGE_MAP()

private:

    CIniHelperX m_cfg;
    HBRUSH m_hBrush = nullptr;
    HBRUSH m_hStaticBrush = nullptr;
    DWORD m_dwSyntaxType = 0;
    LANGID m_langId = 0;
    bool m_fShowAddr = false;
};


