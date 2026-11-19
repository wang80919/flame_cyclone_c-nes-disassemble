#pragma once
#include "CWindow/CDialogBase.h"

class CMainFrameDlg :
    public CDialogBase
{
public:

    CMainFrameDlg();
    ~CMainFrameDlg();

    dlg_msg LRESULT OnInitDialog(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT OnLanguageChange(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT OnLangZh(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT OnLangEn(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT OnSyntaxNesasm(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT OnSyntax6502Simulator(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT OnReset(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT OnClose(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT OnDisassemble(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT OnPasteInput(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT OnClearInput(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT OnCopyOutput(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT OnNotify(WPARAM wParam, LPARAM lParam);

    dlg_msg LRESULT OnExit(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT OnCtrlCommand(WPARAM wParam, LPARAM lParam);
    dlg_msg LRESULT OnColor(WPARAM wParam, LPARAM lParam);

private:

    int HexStringToBytes(LPCTSTR pString, int nStrCount, uint8_t* pBytes, int nBytesSize);
    int BytesToHexString(const uint8_t* pBytes, int nBytesSize, LPTSTR pString, int nStrCount);

    DECLARE_DLG_MESSAGE_MAP()

private:

    HBRUSH m_hBrush = nullptr;
    HBRUSH m_hStaticBrush = nullptr;
    HWND m_hAddrListTip = nullptr;
    HWND m_hDataListTip = nullptr;
    HWND m_hLoadAddrTip = nullptr;
    DWORD m_dwSyntaxType = 0;
};


