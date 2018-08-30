////////////////////////////////////////////////////////////////////////////////
//
//  ****************************************************************************
//  * Unit Name : FWSysTrayInfo
//  * Purpose   : ���� ��� ��������� ���������� � ��������� ����.
//  * Author    : ��������� (Rouse_) ������
//  * Copyright : � Fangorn Wizards Lab 1998 - 2006.
//  * Version   : 1.00
//  ****************************************************************************
//

unit FWSysTrayInfo;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Graphics,
  CommCtrl,
  Controls,
  TlHelp32,
  ShellAPI;

type
  DUMMYUNIONNAME = record
    case Integer of
      0: (
        uTimeout: UINT);
      1: (
        uVersion: UINT);
  end;

  // �������� � �������������� ��������� ��� ������ � �����
  // ANSI �������
  _NOTIFYICONDATAA_V1 = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array [0..63] of AnsiChar;
  end;

  P_NOTIFYICONDATAA_V2 = ^_NOTIFYICONDATAA_V2;
  _NOTIFYICONDATAA_V2 = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;

    // ���������� ��������� ��� Shell32.dll ������ ����
    szTip: array [0..MAXCHAR - 1] of AnsiChar;
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array [0..MAXBYTE - 1] of AnsiChar;
    UNIONNAME: DUMMYUNIONNAME;
    //uTimeout: UINT;
    szInfoTitle:  array [0..63] of AnsiChar;
    dwInfoFlags: DWORD;

    // ���������� ��������� ��� Shell32.dll ������ �����
    //guidItem: DWORD;
  end;

  PNprivIcon = ^TNprivIcon;
  _TNPRIVICON = record
    hWnd: THandle;
    uID: UINT;
    uCallbackMessage: UINT;
    dwState: DWORD;
    uVersion: UINT;
    hIcon: HICON;
  end;
  TNprivIcon = _TNPRIVICON;

  TFWSysIconItem = record
    uID: UINT;
    iImage: Integer;
    szTip: array [0..MAXCHAR - 1] of AnsiChar;
    dwState: DWORD;
    szInfo: array [0..MAXBYTE - 1] of AnsiChar;
    szInfoTitle:  array [0..63] of AnsiChar;
    dwInfoFlags: DWORD;
    hWnd: THandle;
    szAppPath: String;
  end;

  TFWSysIconData = record
    Items: array of TFWSysIconItem;
    ImageList: TImageList;
  end;

  TFWSysTrayInfo = class
  private
    FSysTrayHandle: THandle;
    FIconCount: Integer;
    FIconData: TFWSysIconData;
    function GetImageList: TImageList;
    function GetIconItem(Index: Integer): TFWSysIconItem;
  protected
    function GetAppName(const Wnd: THandle): String;
    procedure DoGetSysTrayHandle; virtual;
    procedure DoGetIconCount; virtual;
    procedure DoGetIconsInfo; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure UpdateInfo;
    procedure DeleteIco(const Index: Integer);
    property IconCount: Integer read FIconCount;
    property IconItem[Index: Integer]: TFWSysIconItem read GetIconItem;
    property ImageList: TImageList read GetImageList;
  end;

implementation

// �������� ��� ��� ��� ���:
// Shell_TrayWnd
//    |- Button                     - ������ �����
//    |- ReBarWindow32
//    |    |- MSTaskSwWClass
//    |    |    +- ToolbarWindow32  - ������ ����������
//    |    +- ToolbarWindow32       - ������ ������
//    +- TrayNotifyWnd 
//         |- TrayClockWClass       - ��� ��� ��� ������ ;)
//         |- SysPager 
//         |    +- ToolbarWindow32  - ��� ���� ������
//         +- Button                - ������ �������� ����������

const
  Shell_TrayWnd   = 'Shell_TrayWnd';
  TrayNotifyWnd   = 'TrayNotifyWnd';
  SysPager        = 'SysPager';
  ToolbarWindow32 = 'ToolbarWindow32';

{ TFWSysTrayInfo }

constructor TFWSysTrayInfo.Create;
begin
  FIconCount := 0;
  FIconData.ImageList := TImageList.Create(nil);
end;

procedure TFWSysTrayInfo.DeleteIco(const Index: Integer);
var
  IconData: _NOTIFYICONDATAA_V1;
begin
  ZeroMemory(@IconData, SizeOf(_NOTIFYICONDATAA_V1));
  IconData.cbSize := SizeOf(_NOTIFYICONDATAA_V1);
  IconData.uID := FIconData.Items[Index].uID;
  IconData.Wnd := FIconData.Items[Index].hWnd;
  Shell_NotifyIcon(NIM_DELETE, @IconData);
end;

destructor TFWSysTrayInfo.Destroy;
begin
  FIconData.ImageList.Free;
  inherited;
end;

procedure TFWSysTrayInfo.DoGetIconCount;
begin
  FIconCount := SendMessage(FSysTrayHandle, TB_BUTTONCOUNT, 0, 0);
  SetLength(FIconData.Items, FIconCount);
  FIconData.ImageList.Clear;
  ImageList_SetImageCount(FIconData.ImageList.Handle, FIconCount);
end;

function SetDebugPriv: Boolean;
var
  Token: THandle;
  tkp: TTokenPrivileges;
begin
  Result := false;
  if OpenProcessToken(GetCurrentProcess,
    TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, Token) then
  begin
    if LookupPrivilegeValue(nil, PChar('SeDebugPrivilege'),
      tkp.Privileges[0].Luid) then
    begin
      tkp.PrivilegeCount := 1;
      tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      Result := AdjustTokenPrivileges(Token, False,
        tkp, 0, PTokenPrivileges(nil)^, PDWord(nil)^);
    end;
  end;
end;

procedure TFWSysTrayInfo.DoGetIconsInfo;
var
  dwProcessID, dwBytesWriten: DWORD;
  hProcess, hImageList: THandle;
  pButtonInfo: PTBButtonInfo;
  ButtonInfo: TTBButtonInfo;
  I: Integer;
  szTextBuffer: array [0..MAXCHAR - 1] of Char;
  pszTextBuffer: Pointer;
  NprivIcon: TNprivIcon;
  SHFileInfo: TSHFileInfo;
begin

  // ����� �������� � �����������, ������� ����� �������� ���������� ����������
  if not SetDebugPriv then Exit;

  // �������� ID ��������, �������� ����������� ��������� ����
  GetWindowThreadProcessId(FSysTrayHandle, &dwProcessID);
  if dwProcessID = 0 then ExitProcess(GetLastError);

  // ��������� �������
  hProcess := OpenProcess(PROCESS_ALL_ACCESS or PROCESS_DUP_HANDLE, TRUE, dwProcessID);
  if hProcess <> 0 then
  try
    // �������� � ��� ������ ��� ��������� ������
    pszTextBuffer := VirtualAllocEx(hProcess, nil, MAX_PATH,
      MEM_COMMIT or MEM_TOP_DOWN, PAGE_READWRITE);
    if pszTextBuffer <> nil then
    try
      // �������� � ��� ������ ��� ��������� TTBButtonInfo
      pButtonInfo := VirtualAllocEx(hProcess, nil, SizeOf(TTBButtonInfo),
        MEM_COMMIT or MEM_TOP_DOWN, PAGE_READWRITE);
      if GetLastError = 0 then
      try
        // ��������� ���������
        ZeroMemory(@ButtonInfo, SizeOf(TTBButtonInfo));
        ButtonInfo.cbSize := SizeOf(TTBButtonInfo);
        ButtonInfo.dwMask := TBIF_IMAGE or TBIF_TEXT or TBIF_STATE or TBIF_STYLE
          or TBIF_LPARAM or TBIF_COMMAND or TBIF_SIZE or TBIF_BYINDEX;
        ButtonInfo.pszText := pszTextBuffer;
        ButtonInfo.cchText := MAXCHAR;

        // ����� �� � ������ ���������� ��������
        if not WriteProcessMemory(hProcess, pButtonInfo, @ButtonInfo,
          SizeOf(TTBButtonInfo), dwBytesWriten) then ExitProcess(GetLastError);

        // �������� ���������� �� ���� ���������
        for I := 0 to FIconCount - 1 do
        begin

          // ���������� ��������� � ���������� �� ���������� ������
          SendMessage(FSysTrayHandle, TB_GETBUTTONINFO,
            I, Integer(pButtonInfo));

          // ������ ���������� � ������
          ZeroMemory(@ButtonInfo, SizeOf(TTBButtonInfo));
          ReadProcessMemory(hProcess, pButtonInfo,
            @ButtonInfo, SizeOf(TTBButtonInfo), dwBytesWriten);

          // ������ ���������
          ZeroMemory(@szTextBuffer[0], MAXCHAR);
          ReadProcessMemory(hProcess, ButtonInfo.pszText,
            @FIconData.Items[I].szTip[0], ButtonInfo.cchText, dwBytesWriten);

          // ������ ����������� ���������� �� ������
          ZeroMemory(@NprivIcon, SizeOf(TNprivIcon));
          ReadProcessMemory(hProcess, Pointer(ButtonInfo.lParam),
            @NprivIcon, SizeOf(TNprivIcon), dwBytesWriten);

          // ��������� ��������� �������
          FIconData.Items[I].uID := NprivIcon.uID;
          FIconData.Items[I].dwState := ButtonInfo.fsState;
          FIconData.Items[I].hWnd := NprivIcon.hWnd;
          FIconData.Items[I].iImage := ButtonInfo.iImage;

          // ���������� ���� � ���������� ����������� ������
          FIconData.Items[I].szAppPath := GetAppName(NprivIcon.hWnd);

          // ��� ������ ������, �������� �� - �������� ������
          // ����� ����� ImageList �������, �������� ������� �����
          // �������� ��� ��������� TB_GETIMAGELIST.
          // �� ���� ��������, ������:
          // http://support.microsoft.com/default.aspx?scid=kb%3Ben-us%3B811415
          // ������� �� ������ ������ �����.
          // ��� � ��� ����?
          // � ��� ���� ����� ������, ������� �������� � ����. (NprivIcon.hIcon)
          // ���� ����� ����������� ������ ���������� � ������ ��� ������
          // �� ���� ����������.
          // �� ������� SHGetFileInfo � ������ SHGFI_SYSICONINDEX,
          // ����� ���� � ��������� ���������� ���������� ImageList
          // ����� ����� ����� ����� � ��� �� ����� � �� ����� ��������
          // ���� �� ��������� ������� ����� �������, ����� ������� � ��� ����� ����.
          // �.�. ��� ������ ����������� ������ �������� - ������ ����������
          // ������������� � �� �������� ��������� � ���� ImageList
          // ����� :)

          ZeroMemory(@SHFileInfo, SizeOf(TSHFileInfo));
          hImageList := SHGetFileInfo(PChar(FIconData.Items[I].szAppPath),
            0, SHFileInfo, SizeOf(TSHFileInfo), SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
          ImageList_ReplaceIcon(hImageList, SHFileInfo.iIcon, NprivIcon.hIcon);
          ImageList_ReplaceIcon(FIconData.ImageList.Handle, ButtonInfo.iImage,
            ImageList_GetIcon(hImageList, SHFileInfo.iIcon, ILD_NORMAL));
        end;
      finally
        VirtualFreeEx(hProcess, pButtonInfo, SizeOf(TTBButtonInfo), MEM_RELEASE);
      end;
    finally
      VirtualFreeEx(hProcess, pszTextBuffer, MAX_PATH, MEM_RELEASE);
    end;
  finally
    CloseHandle(hProcess);
  end;
end;

procedure TFWSysTrayInfo.DoGetSysTrayHandle;
var
  TempHandle: THandle;
begin
  FSysTrayHandle := 0;
  TempHandle := FindWindow(Shell_TrayWnd, nil);
  if TempHandle = 0 then Exit;
  TempHandle := FindWindowEx(TempHandle, 0, TrayNotifyWnd, nil);
  if TempHandle = 0 then Exit;
  TempHandle := FindWindowEx(TempHandle, 0, SysPager, nil);
  if TempHandle = 0 then Exit;
  FSysTrayHandle := FindWindowEx(TempHandle, 0, ToolbarWindow32, nil);
end;

function TFWSysTrayInfo.GetAppName(const Wnd: THandle): String;
var
  hModuleSnap: THandle;
  ModuleEntry: TModuleEntry32;
  CurrentPID: DWORD;
begin
  Result := '';
  GetWindowThreadProcessId(Wnd, CurrentPID);
  hModuleSnap := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, CurrentPID);
  if hModuleSnap <> INVALID_HANDLE_VALUE then
  try
    ModuleEntry.dwSize := SizeOf(TModuleEntry32);
    if Module32First(hModuleSnap, ModuleEntry) then
      Result := ModuleEntry.szExePath;
  finally
    CloseHandle(hModuleSnap);
  end;
end;

function TFWSysTrayInfo.GetIconItem(Index: Integer): TFWSysIconItem;
begin
  Result := FIconData.Items[Index];
end;

function TFWSysTrayInfo.GetImageList: TImageList;
begin
  Result := FIconData.ImageList;
end;

procedure TFWSysTrayInfo.UpdateInfo;
begin
  DoGetSysTrayHandle;
  DoGetIconCount;
  DoGetIconsInfo;
end;

end.

