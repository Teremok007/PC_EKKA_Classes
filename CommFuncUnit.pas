unit CommFuncUnit;


interface

uses Windows, SysUtils, Forms, Classes, IdCoderQuotedPrintable,
  {
  Messages, Variants, Graphics, Controls,
  Dialogs, ComObj, BCLDataUnit, ActnList, Menus, ToolWin, ComCtrls, XPMan,
  IdBaseComponent, IdCoder;

  }
  OleServer, ExcelXP, OfficeXP, Variants ;
const
  // Flags:
  CRYPT_STRING_BASE64HEADER = 0;
  // Base64, with certificate beginning and ending headers
  CRYPT_STRING_BASE64 = 1;
  // Base64, without headers
  CRYPT_STRING_BINARY = 2;
  // Pure binary copy
  CRYPT_STRING_BASE64REQUESTHEADER = 3;
  // Base64, with request beginning and ending headers
  CRYPT_STRING_HEX = 4;
  // Hexadecimal only
  CRYPT_STRING_HEXASCII= 5;
  // Hexadecimal, with ASCII character display
  CRYPT_STRING_BASE64X509CRLHEADER = 9;
  // Base64, with X.509 CRL beginning and ending headers
  CRYPT_STRING_HEXADDR = 10;
  // Hexadecimal, with address display
  CRYPT_STRING_HEXASCIIADDR = 11;
  // Hexadecimal, with ASCII character and address display
  CRYPT_STRING_HEXRAW = 12;
  // A raw hex string.

  // for Excel
  lcid = LOCALE_USER_DEFAULT;

  function String_PosStartAt(const SubStr,s : string; StartPos : Cardinal = 0; IgnoreCase : boolean = false) : integer;
  function Mail_ConvertHeaderToWin1251(_string: string): string;
  function Mail_ConvertKoiToWin(Str: string): string;
  function Mail_ConvertToBase64(s: string; Flags: dword = CRYPT_STRING_BASE64REQUESTHEADER): string;
  function Mail_ConvertFromBase64(s: string; Flags: dword = CRYPT_STRING_BASE64REQUESTHEADER): string;
  function Path_GetTempPath: string;
  function Path_GetCurrentDirectory: string;
  procedure FinishExcel(XL: TExcelApplication);
  function StartExcel(ConnectKind: TConnectKind = ckNewInstance): TExcelApplication;


implementation




function CryptStringToBinary(pszString: PChar; cchString: dword; dwFlags: dword;
         pbBinary: pointer; var pcbBinary: dword; var pdwSkip: dword;
         var pdwFlags: dword): boolean; stdcall;
         external 'crypt32.dll' name 'CryptStringToBinaryA';
function CryptBinaryToString(pbBinary: pointer; cbBinary: dword; dwFlags: dword;
         pszString: PChar; var pcchString: dword): boolean; stdcall;
         external 'crypt32.dll' name 'CryptBinaryToStringA';


function Mail_ConvertHeaderToWin1251(_string: string): string;
var
  _string_base: string;
  _string_type: string;
  indy_decoder : TIdDecoderQuotedPrintable;
  startp, endp :integer;
  substr_for_decode :string;
begin
  _string_base:=_string;

  _string_type:=copy(_string,1,8); //����������� ��� ��� ������� UTF-8

  //��������� �� �������� �� ��������� ������� UTF-8
  if _string_type='0*UTF-8' then
  begin
    //��������� ������ UTF-8 � win1251
    _string_base:=Utf8ToAnsi(_string_base);
  end;


  _string_type:=copy(_string,1,10); //����������� ��� ��� UTF-8 ��� base64

  //��������� �� �������� �� ��������� UTF-8 ��� base64
  if _string_type='=?UTF-8?B?' then
  begin

    startp:= String_PosStartAt(_string_type, _string_base, 1, true);
    while startp > 0 do begin
      endp := String_PosStartAt('?=', _string_base, startp, true);
      if endp > 0 then
      substr_for_decode := copy(_string_base, startp+length(_string_type), endp-3);
      //��������� ������ �� base64 � UTF-8
      substr_for_decode:=Mail_ConvertFromBase64(substr_for_decode,1);
      //��������� ������ UTF-8 � win1251
      substr_for_decode:=Utf8ToAnsi(substr_for_decode);
      _string_base := copy (_string_base, 1, startp -1 )+ substr_for_decode + copy (_string_base, endp+2, length(_string_base));
      startp:= String_PosStartAt(_string_type, _string_base, 1, true);
    end

(*
   //��������� ������ �� base64 � UTF-8
  _string_base:= copy(_string_base,11,length(_string_base)-2);
  _string_base:=Mail_ConvertFromBase64(_string_base,1);//uses XPBase64
  //��������� ������ UTF-8 � win1251
  _string_base:=Utf8ToAnsi(_string_base);
*)
  end;

  _string_type:=copy(_string,1,11); //����������� ��� ���� ��� KOI8_R
  //��������� �� �������� �� ��������� KOI8-R ��� base64
  if (_string_type = '=?KOI8-R?Q?') or (_string_type = '=?koi8-r?Q?') then //���, �� ��������
  begin
    //�������������� �������������
    indy_decoder :=  TIdDecoderQuotedPrintable.Create(nil);
    _string_base:= indy_decoder.DecodeString(_string_base);
    indy_decoder.Free;
    _string_base:=Mail_ConvertKoiToWin(_string_base); //��������� ������ �� KOI8-R � win1251
    //����������� �������������� ���� ����
    _string_base:=copy(_string_base,11,length(_string_base)-11);
    //��� ��������� �������: ������� ��������� � ������
    _string_base:=StringReplace(_string_base,'?KOI8-R?Q?','', [rfReplaceAll, rfIgnoreCase]);
    _string_base:=StringReplace(_string_base,'?','', [rfReplaceAll, rfIgnoreCase]);
    _string_base:=StringReplace(_string_base,'_',' ', [rfReplaceAll, rfIgnoreCase]);
  end;
  //��������� �� �������� �� ��������� KOI8-R ��� base64
  if (_string_type = '=?koi8-r?B?') or (_string_type = '=?KOI8-R?B?') then //��, ��������
  begin
   //��������� ������ �� base64 � KOI8-R
   _string_base:=Mail_ConvertFromBase64(copy(_string_base,12,length(_string_base)-4),1);
   //��������� ������ �� KOI8-R � win1251
   _string_base:=Mail_ConvertKoiToWin(_string_base);
  end;

  //��������� ������ � ��������� win1251
  Result:=_string_base;
end;

function Mail_ConvertKoiToWin(Str: string): string;
const
  Koi: array[0..66] of Char = ( 'T', '�', '�', '�', '�', '�', '�', '�', '�', '�',
  '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�',
  '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�',
  '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�');
  Win: array[0..66] of Char = ( '�', '�', 'T', '�', '�', '�', '�', '�', '�', '�',
  '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�',
  '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�',
  '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�');

var
  i, j, index: Integer;
begin
  Result := '';

  for i := 1 to Length(Str) do
  begin
    index := -1;
    for j := Low(Win) to High(Win) do
      if Koi[j] = Str[i] then
      begin
        index := j;
        Break;
      end;

    if index = -1 then
      Result := Result + Str[i]
    else
      Result := Result + Win[index];
  end;

end;


function Mail_ConvertToBase64(s: string;
  Flags: dword): string;
var sz: dword;
begin
  CryptBinaryToString(pointer(s), Length(s), Flags, nil, sz);
  SetLength(result, sz);
  CryptBinaryToString(pointer(s), Length(s), Flags, pointer(result), sz);
end;


function Mail_ConvertFromBase64(s: string;
  Flags: dword): string;
var sz, skip: dword;
begin
  CryptStringToBinary(pointer(s), Length(s), Flags, nil, sz, skip, Flags);
  SetLength(result, sz);
  CryptStringToBinary(pointer(s), Length(s), Flags, pointer(result), sz, skip, Flags);
end;

function String_PosStartAt(const SubStr, s: string;
  StartPos: Cardinal; IgnoreCase: boolean): integer;
begin
  if StartPos=0 then
  begin
    if IgnoreCase
    then Result := System.Pos(AnsiUpperCase(SubStr),AnsiUpperCase(s))
    else Result := System.Pos(SubStr,s)
  end else
  begin
    if IgnoreCase
    then Result := System.Pos(AnsiUpperCase(SubStr),AnsiUpperCase(System.Copy(s,StartPos,Length(s))))
    else Result := System.Pos(SubStr,System.Copy(s,StartPos,Length(s)));
    if Result>0 then Result := (Result+integer(StartPos))-1;
  end;
  end;

function Path_GetTempPath: string;
var
  Buffer: array[0..65536] of Char;
  dwRetVal :Cardinal;
begin

  dwRetVal := GetTempPath(65536,Buffer);
  SetString(Result, Buffer, dwRetVal);
end;

function Path_GetCurrentDirectory: string;
var
  Buffer: array[0..1023] of Char;
begin
  SetString(Result, Buffer, GetCurrentDirectory(Sizeof(Buffer) - 1, Buffer));
end;


function StartExcel(ConnectKind: TConnectKind = ckNewInstance): TExcelApplication;
var OldSheetCnt: Integer;
begin
  // ��������� Excel.Application, ������ ��� ������� � ��������� ����
  // ������ �����
  Result := TExcelApplication.Create(nil);
  try
    Result.ConnectKind := ConnectKind;
    Result.Connect;
    Result.AutoQuit := False;
    Result.DisplayAlerts[lcid] := False;
    Result.Visible[lcid] := True;
    if Result.Workbooks.Count = 0 then begin
      OldSheetCnt := Result.SheetsInNewWorkbook[lcid];
      if OldSheetCnt < 5 then Result.SheetsInNewWorkbook[lcid] := 1;
      Result.Workbooks.Add(EmptyParam, lcid);
      Result.SheetsInNewWorkbook[lcid] := OldSheetCnt;
    end;
  except
    on E:Exception do
      raise Exception.CreateFmt('������ ������ Excel.Application'#10'%s', [E.Message]);
  end;
end;

procedure FinishExcel(XL: TExcelApplication);
begin
  // ������������� �� Excel'� ��� ��� ��������, ���� ���� ���� ���� �����
  if not Assigned(XL) then Exit;
  if XL.Workbooks.Count = 0 then begin
    XL.Quit;
  end
  else begin
//    (XL.ActiveWorkbook.Sheets[1] as _Worksheet).Select(True, lcid);
    XL.UserControl := True;
    XL.ScreenUpdating[lcid] := True;
    if not XL.Interactive[lcid] then XL.Interactive[lcid] := True;
    if not XL.Visible[lcid] then XL.Visible[lcid] := True;
    XL.EnableEvents := True;
//    XL.ActiveWorkbook.Saved[lcid] := True;
  end;
  XL.Disconnect;
  FreeAndNil(XL);
end;



end.
