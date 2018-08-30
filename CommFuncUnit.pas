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

  _string_type:=copy(_string,1,8); //Выдергиваем тип для обычной UTF-8

  //Проверяем не является ли кодировка обычной UTF-8
  if _string_type='0*UTF-8' then
  begin
    //Конвертим строку UTF-8 в win1251
    _string_base:=Utf8ToAnsi(_string_base);
  end;


  _string_type:=copy(_string,1,10); //Выдергиваем тип для UTF-8 под base64

  //Проверяем не является ли кодировка UTF-8 под base64
  if _string_type='=?UTF-8?B?' then
  begin

    startp:= String_PosStartAt(_string_type, _string_base, 1, true);
    while startp > 0 do begin
      endp := String_PosStartAt('?=', _string_base, startp, true);
      if endp > 0 then
      substr_for_decode := copy(_string_base, startp+length(_string_type), endp-3);
      //Конвертим строку из base64 в UTF-8
      substr_for_decode:=Mail_ConvertFromBase64(substr_for_decode,1);
      //Конвертим строку UTF-8 в win1251
      substr_for_decode:=Utf8ToAnsi(substr_for_decode);
      _string_base := copy (_string_base, 1, startp -1 )+ substr_for_decode + copy (_string_base, endp+2, length(_string_base));
      startp:= String_PosStartAt(_string_type, _string_base, 1, true);
    end

(*
   //Конвертим строку из base64 в UTF-8
  _string_base:= copy(_string_base,11,length(_string_base)-2);
  _string_base:=Mail_ConvertFromBase64(_string_base,1);//uses XPBase64
  //Конвертим строку UTF-8 в win1251
  _string_base:=Utf8ToAnsi(_string_base);
*)
  end;

  _string_type:=copy(_string,1,11); //Выдергиваем тип темы для KOI8_R
  //Проверяем не является ли кодировка KOI8-R под base64
  if (_string_type = '=?KOI8-R?Q?') or (_string_type = '=?koi8-r?Q?') then //нет, не явялется
  begin
    //Преварительное декодирование
    indy_decoder :=  TIdDecoderQuotedPrintable.Create(nil);
    _string_base:= indy_decoder.DecodeString(_string_base);
    indy_decoder.Free;
    _string_base:=Mail_ConvertKoiToWin(_string_base); //Конвертим строку из KOI8-R в win1251
    //Выдергиваем необработанное тело темы
    _string_base:=copy(_string_base,11,length(_string_base)-11);
    //Три следующие строчки: убиваем паразитов в строке
    _string_base:=StringReplace(_string_base,'?KOI8-R?Q?','', [rfReplaceAll, rfIgnoreCase]);
    _string_base:=StringReplace(_string_base,'?','', [rfReplaceAll, rfIgnoreCase]);
    _string_base:=StringReplace(_string_base,'_',' ', [rfReplaceAll, rfIgnoreCase]);
  end;
  //Проверяем не является ли кодировка KOI8-R под base64
  if (_string_type = '=?koi8-r?B?') or (_string_type = '=?KOI8-R?B?') then //да, является
  begin
   //Конвертим строку из base64 в KOI8-R
   _string_base:=Mail_ConvertFromBase64(copy(_string_base,12,length(_string_base)-4),1);
   //Конвертим строку из KOI8-R в win1251
   _string_base:=Mail_ConvertKoiToWin(_string_base);
  end;

  //Возращаем строку в кодировке win1251
  Result:=_string_base;
end;

function Mail_ConvertKoiToWin(Str: string): string;
const
  Koi: array[0..66] of Char = ( 'T', 'Ё', 'ё', 'А', 'Б', 'В', 'Г', 'Д', 'Е', 'Ж',
  'З', 'И', 'Й', 'К', 'Л', 'М', 'Н', 'О', 'П', 'Р', 'С', 'Т', 'У', 'Ф', 'Х', 'Ц', 'Ч', 'Ш', 'Щ', 'Ъ',
  'Ы', 'Ь', 'Э', 'Ю', 'Я', 'а', 'б', 'в', 'г', 'д', 'е', 'ж', 'з', 'и', 'й', 'к', 'л', 'м', 'н', 'о',
  'п', 'р', 'с', 'т', 'у', 'ф', 'х', 'ц', 'ч', 'ш', 'щ', 'ъ', 'ы', 'ь', 'э', 'ю', 'я');
  Win: array[0..66] of Char = ( 'ё', 'Ё', 'T', 'ю', 'а', 'б', 'ц', 'д', 'е', 'ф',
  'г', 'х', 'и', 'й', 'к', 'л', 'м', 'н', 'о', 'п', 'я', 'р', 'с', 'т', 'у', 'ж', 'в', 'ь', 'ы', 'з',
  'ш', 'э', 'щ', 'ч', 'ъ', 'Ю', 'А', 'Б', 'Ц', 'Д', 'Е', 'Ф', 'Г', 'Х', 'И', 'Й', 'К', 'Л', 'М', 'Н',
  'О', 'П', 'Я', 'Р', 'С', 'Т', 'У', 'Ж', 'В', 'Ь', 'Ы', 'З', 'Ш', 'Э', 'Щ', 'Ч', 'Ъ');

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
  // запускаем Excel.Application, делаем его видимым и добавляем одну
  // пустую книгу
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
      raise Exception.CreateFmt('Ошибка вызова Excel.Application'#10'%s', [E.Message]);
  end;
end;

procedure FinishExcel(XL: TExcelApplication);
begin
  // отсоединяемся от Excel'я без его закрытия, если есть хоть одна книга
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
