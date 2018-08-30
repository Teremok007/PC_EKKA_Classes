UNIT EKKAU;

INTERFACE

Uses Windows, Dialogs, Messages, SysUtils, Classes, Marry301U, Util, ComObj, Variants, ADODB, MarryFont;

Type TArrStr=Array of OleVariant;

     RetData=Record
              Count:Integer;
              CmdCode:Integer;
              UserData:Integer;
              Status:Integer;
              CmdName:PAnsiChar;
              SendStr:PAnsiChar;
              Whole:PAnsiChar;
              RetItem:Array[1..20] of PAnsiChar;
              OrigStat:Array[1..6] of Byte;
             end;

     n1RetData=Array[1..10] of Byte;
     nRetData=^n1RetData;

     TMathFunc=procedure(const rt:RetData)stdcall;

     TEKKA=class(TMarry301)

     private

       FTypeEKKA:Byte;
       FKassaID:Byte;
       FNumVoidChek:String;
       FIsConnected:Boolean;
       FP:Variant;
       FDatePOEx:String;
       FEmulEKKA:Boolean;
       FQr:TADOQuery;
       FQr1:TADOQuery;
       FQrEx:TADOQuery;
       FAptekaID:Integer;
       FFirmNameUA: String;
       FsZN:String;
       FsPN:String;
       FsFN:String;
       FsID:String;
       FTypeLogo:Byte;
       FDtChek:TDateTime;
       FBNumb_Chek:Integer;
       FIsCopy:Boolean;
       FCopy_Chek:Integer;

       FSumNA,FSumNB,FSumNC,FSumSale,FSumVoid,FSumDis:Currency;
       FIsFLP:Boolean;

       function ReConnect:Boolean;
       function CancelFiscalReceipt:Boolean;
       function CheckErrorExellio:Boolean;
       function GetPaperOut:Boolean;
       function GetLinkOut:Boolean;
       function GetSumm: Currency;

       procedure SetTypeEKKA(const Value:Byte);
       procedure SaveRegisters;

       procedure bPrintFooter(Param:Byte);
       procedure bPrintHead(P:Byte=0);
       procedure GetInfo(NumZ:Integer=0);

       function  GetNewServiceNumbChek:Integer;

     protected

       function GetReceiptNumber:Integer; override;
       function GetVzhNum:Int64; override;

     public

       IsAbort:Boolean;
       Passw:Array[1..16] of String;
       eStr:Array[1..4] of String;
       sArr:Array of Record
                      S:String;
                      F:Integer;
                     end;

       constructor Create(AOwner:TComponent); override;
       destructor Destroy; override;

       procedure Gh;
       procedure bPrintRep(Param:Byte; NumZ:Integer=0);

       procedure fpClosePort; override;                            // ������� ��� ����
       procedure fpSendToEKV;                                      // ������ ��������� �������� ������

       function  ErrorDescr(Code:String):String; override;         // ��������� ��������� �� ���� ������

       function  fpCloseNoFCheck:Boolean;
       function  fpGetOperatorInfo(O:Byte):Boolean;
       function  fpGetCorectSums:Boolean;
       function  fpGetCheckCopyText:String;                        // ���������� ����� ����, ���� ������ ��� FP2000


       { --- ��������� ����� � ���� --- }
       function  fpLoadExellio: Boolean;
       function  fpConnect:Boolean; override;                      // ��������� ����� � ����

       { --- ���������� ������������ ������� --- }
       function  fpSendCommand(var Comm:String):Boolean; override; // ���������� ������������ �������, ���� ���� ����������, �� ��� ������������� � Comm

       { --- ��������� ������� ����� ---}
       function  fpSetINSP(FN:String; ID:String; PN:String; Str1,Str2,Str3,Str4:String):Boolean; override; // ��������������� ���������� ���������.
       function  fpSetTime(T:TDateTime):Boolean; override;         // ��������� ������� EKKA
       function  fpActiveLogo(P:Byte):Boolean; override;           // ����������� ������ ������������ ������ (0 �� ��������, 1 - ��������)

       { --- ���������������� ���������� ������ --- }
       function  fpSetBottomStr(S:String):Boolean; override; // ���������������� �������������� �������������� ������ �� ����.
       function  fpSetBottomStrEx(S:String; N,P,W:Byte):Boolean; override;

       { --- ���������� � ������� ������� � ����� --- }

       function  fpOpenFiscalReceipt(Param:Byte=1):Boolean; override;  // �������� ������ ����
       function  fpCancelFiscalReceipt:Boolean; override;              // ������ ����

       function  fpAddSale(Name:String;                                // ����������� ������� ����� �������
                           Kol:Integer;
                           Cena:Currency;
                           Divis:Byte;
                           Artic:Integer;
                           Nalog:Byte;
                           DiscSum:Currency;
                           DiscDescr:String
                          ):Boolean;  override;

       function  fpAddFinStr(S:String):Boolean; override;  // �������������� ���������� � ������ (������)

       function  fpAddBack(
                           Name:String;                             // ����������� ������� ��������
                           Kol:Integer;
                           Cena:Currency;
                           Divis:Byte;
                           Artic:Integer;
                           Nalog:Byte;
                           DiscSum:Currency;
                           DiscDescr:String
                          ):Boolean; override;

       function  fpSetBackReceipt(S:String):Boolean; override;      // ����������� ������ ����������� ����
       function  fpServiceText(TextPos:Integer;                     // ����������� ��������� ������ � ����
                               Print2:Integer;
                               FontHeight:Integer;
                               S:String
                              ):Boolean; override;

       function  fpCloseFiscalReceipt(TakedSumm:Currency;           // �������� ����
                                      TypeOplat:Integer;
                                      SumCheck:Currency=0;
                                      SumB1:Currency=0;
                                      IsDnepr:Boolean=False):Boolean; override;

       function fpCloseFiscalReceiptB(TakedSumm:Currency; TypeOplat:Integer; SumCheck:Currency=0):Boolean;
       function fpCheckCopy(Cnt:Byte=1):Boolean; override;                      // ������ ����� ����


       { --- ��������� ��������/������� �������� ������� --- }
       function  fpCashInput(C:Currency):Boolean; override;         // �������� �������� �������
       function  fpCashOutput(C:Currency; P:Byte=0):Boolean; override;        // ������� �������� �������

       { --- ���������� ������ --- }
       function  fpXRep:Boolean; override;                         // X-�����
       function  fpZRep:Boolean; override;                         // Z-�����
       function  fpPerFullRepD(D1,D2:TDateTime):Boolean; override; // ������ ������������� ����� �� �����
       function  fpPerShortRepD(D1,D2:TDateTime):Boolean; override;// ����������� ������������� ����� �� �����
       function  fpPerFullRepN(N1,N2:Integer):Boolean; override;   // ������ ������������� ����� �� ������� Z-�������
       function  fpPerShortRepN(N1,N2:Integer):Boolean; override;  // ����������� ������������� ����� �� ����� Z-�������

       { --- ������������� � ��������� ������ --- }
       function  fpZeroCheck:Boolean; override;                     // ������� ���

       { --- ���������� ��������������� ������������}
       function fpCurrToDisp(S:Currency): Boolean; override;
       function fpStrToDisp(S: String): Boolean; override;

       { --- ��������� ����������������� ���������� � ��������� ���� --- }
       function  fpGetStatus:Boolean; override;                    // ��������� ����������� ��������� EKKA
       function  fpCashState(P:Integer):Boolean; override;         // ������ ���������� � �������� ������� �� ����� (0 - �� ������� �����, 1 - �� �������)
       function  fpFiscState:Boolean; override;                    // ������ �������� ��������� ������� ���������� ���������

       { --- �������������� ������� ---}
       function  KeyPosition(Key:Byte):Boolean; override;          // �������� ��������� �����
       function  fpIsNonClosedReceipt:Boolean;
       function  fpSoundEx(Hz,Ms:Integer):Boolean;
       function  fpCutBeep(C,B,N:Byte):Boolean; overload;     // ���������� ������� ��������� ������� ����� � �������� ��������

       function  fpDisplayText(S:String; L:Byte):Boolean;

       property  TypeEKKA:Byte read FTypeEKKA write SetTypeEKKA;   // ��� ����
       property  KassaID:Byte read FKassaID write FKassaID;        // ����� �����
       property  PaperOut:Boolean read GetPaperOut;                // ������ ������������ ����/��� ������
       property  LinkOut:Boolean read GetLinkOut;                  // ������ ������������ ����/��� �����

       property  EmulEKKA:Boolean read FEmulEKKA write FEmulEKKA;  // �������� ������ ����� ����� 301/304
       property  Qr:TADOQuery read FQr write FQr;                  // ������� Query
       property  QrEx:TADOQuery read FQrEx write FQrEx;            // ������� Query �2
       property  Qr1:TADOQuery read FQr1 write FQr1;                  // ������� Query �3
       property  AptekaID:Integer read FAptekaID write FAptekaID;
       property  FirmNameUA:String read FFirmNameUA write FFirmNameUA;

       property  sID:String read FsID write FsID;
       property  sPN:String read FsPN write FsPN;
       property  sZN:String read FsZN write FsZN;
       property  sFN:String read FsFN write FsFN;

       property  TypeLogo:Byte read FTypeLogo write FTypeLogo;

       property  IsFLP:Boolean read FIsFLP write FIsFLP;

     end;

Const { --- ���� EKKA --- }
      EKKA_MARRY301MTM=1; // ���� ����� 301��� T7
      EKKA_DATECS3530T=2; // EKKA ������ 3530T
      EKKA_EXELLIO=3;     // EKKA Exellio LP 1000
      EKKA_FP2000=4;      // EKKA Exellio FP 2000
      EKKA_N707=5;        // EKKA MG N707TS (����) HTTP

      { --- ��������� ����� --- }
      KEY_O=0; // ��������
      KEY_W=1; // ������
      KEY_X=2; // X-�����
      KEY_Z=4; // Z-�����
      KEY_P=8; // ����������������

      { --- �������� �������� ����� --- }
      CH_SALE=1; // ��������� ���
      CH_BACK=2; // ���������� ���

procedure PrinterResults(const rt:RetData)stdcall;

function  GetStatus(hWin:HWND; fun:TMathFunc; par:LPARAM; int1: BOOL):integer; stdcall	;external 'fpl.dll' name 'GetStatus';
function  GetDiagnosticInfo(hWin:HWND; fun:TMathFunc; par:LPARAM; Calc: BOOL):integer; stdcall	;external 'fpl.dll' name 'GetDiagnosticInfo';
function  GetDateTime(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall	;external 'fpl.dll' name 'GetDateTime';
function  GetLastReceipt(hWin:HWND; fun:TMathFunc; par:LPARAM):integer;stdcall;external 'fpl.dll' name 'GetLastReceipt';
function  DayInfo(hWin:HWND; fun:TMathFunc; par:LPARAM):integer;stdcall;external 'fpl.dll' name 'DayInfo';
function  SetDateTime(hWin:HWND; fun:TMathFunc; par:LPARAM; Date:LPSTR; Time:LPSTR):integer;stdcall;external 'fpl.dll' name 'SetDateTime';
function  OpenFiscalReceipt(hWin:HWND; fun:TMathFunc; par:LPARAM;i1: DWORD;i2: LPSTR;i3: DWORD;i4: BOOL):integer;stdcall;external 'fpl.dll' name 'OpenFiscalReceipt';
function  ResetReceipt(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall	;external 'fpl.dll' name 'ResetReceipt';
function  OpenRepaymentReceipt(hWin:HWND; fun:TMathFunc; par:LPARAM;i1: DWORD;i2: LPSTR;i3: DWORD;i4: BOOL):integer;stdcall;external 'fpl.dll' name 'OpenRepaymentReceipt';
function  RegisterItem(hWin:HWND; fun:TMathFunc; par:LPARAM; n:LPSTR; n1: char; n2:double; n3:double):integer;stdcall;external 'fpl.dll' name 'RegisterItem';
function  InitFPport(int1,int2:integer):integer;stdcall	; external 'fpl.dll' name 'InitFPport';
function  CloseFPport():integer;stdcall	; external 'fpl.dll' name 'CloseFPport';
function  PrintDiagnosticInfo(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall	;external 'fpl.dll' name 'PrintDiagnosticInfo';
function  SetDecimals(int1:integer):integer;stdcall;external 'fpl.dll' name 'SetDecimals';
function  SubTotal(hWin:HWND; fun:TMathFunc; par:LPARAM; n1:BOOL;n2:BOOL; n3:double; n4:double):integer; stdcall	;external 'fpl.dll' name 'SubTotal';
function  Total(hWin:HWND; fun:TMathFunc; par:LPARAM; n1:LPSTR;n2:char; n3:double):integer; stdcall	;external 'fpl.dll' name 'Total';
function  CloseFiscalReceipt(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall	;external 'fpl.dll' name 'CloseFiscalReceipt';
function  FiscalClosure(hWin:HWND; fun:TMathFunc; par: LPARAM;n:LPSTR;s:char):integer; stdcall;external 'fpl.dll' name 'FiscalClosure';
function  ServiceInputOutput(hWin:HWND; fun:TMathFunc; par:LPARAM ; sum:Double) :integer; stdcall	;external 'fpl.dll' name 'ServiceInputOutput';
function  PrintFiscalMemoryByNum(hWin:HWND; fun:TMathFunc; par: LPARAM; psw:LPSTR; n1:integer; n2:integer):integer; stdcall;external 'fpl.dll' name 'PrintFiscalMemoryByNum';
function  PrintFiscalMemoryByDate(hWin:HWND; fun:TMathFunc; par: LPARAM; psw:LPSTR; d1:LPSTR; d2:LPSTR):integer; stdcall;external 'fpl.dll' name 'PrintFiscalMemoryByDate';
function  PrintReportByNum(hWin:HWND; fun:TMathFunc; par: LPARAM; psw:LPSTR; n1:integer; n2:integer):integer; stdcall;external 'fpl.dll' name 'PrintReportByNum';
function  PrintReportByDate(hWin:HWND; fun:TMathFunc; par: LPARAM; psw:LPSTR; d1:LPSTR; d2:LPSTR):integer; stdcall;external 'fpl.dll' name 'PrintReportByDate';
function  OpenDrawer(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall	;external 'fpl.dll' name 'OpenDrawer';
function  PrintFiscalText(hWin:HWND; fun:TMathFunc; par:LPARAM; int1: LPSTR):integer; stdcall	;external 'fpl.dll' name 'PrintFiscalText';
function  SaleArticle(hWin:HWND; fun:TMathFunc; par:LPARAM; sign: Boolean;  numart:integer; qwant,perc,dc:double ):integer; stdcall  ;external 'fpl.dll' name 'SaleArticle';
function  SaleArticleAndDisplay(hWin:HWND; fun:TMathFunc; par:LPARAM; sign: Boolean;  numart:integer; qwant,perc,dc:double ):integer; stdcall  ;external 'fpl.dll' name 'SaleArticleAndDisplay';
function  ProgrammingArticle(hWin:HWND; fun:TMathFunc; par:LPARAM; nal:char; gr:integer; cod:integer; Sena:double; pass:LPSTR; name:LPSTR):integer; stdcall  ;external 'fpl.dll' name 'ProgrammingArticle';
function  DeleteArticle(hWin:HWND; fun:TMathFunc; par:LPARAM; cod:integer; pass:LPSTR):integer; stdcall  ;external 'fpl.dll' name 'DeleteArticle';
function  ChangeArticlePrice(hWin:HWND; fun:TMathFunc; par:LPARAM; cod:integer;sena:Double; pass:LPSTR):integer; stdcall  ;external 'fpl.dll' name 'ChangeArticlePrice';
function  SetOperatorName(hWin:HWND; fun:TMathFunc; par:LPARAM; i1:DWORD; i2:LPSTR; i3:LPSTR):integer;stdcall;external 'fpl.dll' name 'SetOperatorName';
function  GetFiscalClosureStatus(hWin:HWND; fun:TMathFunc; par:LPARAM; i1:BOOL):integer;stdcall;external 'fpl.dll' name 'GetFiscalClosureStatus';
function  MakeReceiptCopy(hWin:HWND; fun:TMathFunc; par:LPARAM; i1:Char):integer;stdcall;external 'fpl.dll' name 'MakeReceiptCopy';
function  SetHeaderFooter(hWin:HWND; fun:TMathFunc; par:LPARAM; i1:Integer; S:LPSTR):integer;stdcall;external 'fpl.dll' name 'SetHeaderFooter';
function  PrintNonfiscalText(hWin:HWND; fun:TMathFunc; par:LPARAM; int1: LPSTR):integer; stdcall	;external 'fpl.dll' name 'PrintNonfiscalText';
function  OperatorsReport(hWin:HWND; fun:TMathFunc; par:LPARAM; ps:LPSTR):integer; stdcall	;external 'fpl.dll' name 'OperatorsReport';
function  GetCurrentTaxes(hWin:HWND; fun:TMathFunc; par:LPARAM; int1:Integer):integer; stdcall	;external 'fpl.dll' name 'GetCurrentTaxes';

function  DisplayTextLL(hWin:HWND; fun:TMathFunc; par:LPARAM; S:LPSTR):integer; stdcall; external 'fpl.dll' name 'DisplayTextLL';
function  DisplayTextUL(hWin:HWND; fun:TMathFunc; par:LPARAM; S:LPSTR):integer; stdcall; external 'fpl.dll' name 'DisplayTextUL';

Function EKKA:TEKKA;

IMPLEMENTATION

Var FEKKA:TEKKA=nil;

{ TEKKA }

Function EKKA:TEKKA;
 begin
  if FEKKA=nil then FEKKA:=TEKKA.Create(nil);
  Result:=FEKKA;
 end;

procedure TEKKA.Gh;
//var Sum:Real;
 begin
//  PrintNonfiscalText(0,PrinterResults,0,'������� ��� ������''�!');
//  fpFiscState;
//  OperatorsReport(0,PrinterResults,0,'0000');
//  fpActiveLogo(0);
  //CloseFiscalReceipt(0,PrinterResults,0);
{  if ProgrammingArticle(0,PrinterResults,0,'�',100,1,10.01,PAnsiChar(Passw[14]),'�������� N10')=0 then
   ShowMessage(FRD_Item[0]);}
 end;

function GetNumZ:Integer;
var sl:TStringList;
 begin
  try
   sl:=TStringList.Create;
   try
    sl.LoadFromFile('1NumZ.txt');
    Result:=StrToInt(sl[0]);
   finally
    sl.Free;
   end;
  except
   Result:=1;
  end;
 end;

procedure NextNumZ;
var sl:TStringList;
 begin
  try
   sl:=TStringList.Create;
   try
    sl.Text:=IntToStr(GetNumZ+1);
    sl.SaveToFile('1NumZ.txt');
   finally
    sl.Free;
   end;
  except
  end;
 end;

function TEKKA.GetSumm:Currency;
var i:Integer;
 begin
  Result:=0;
  try
   for i:=0 to 4 do
    Result:=Result+StrToInt64(FRD_Item[i]);
   Result:=Result*0.01;
  except
   Result:=0;
  end;
 end;

procedure PrinterResults(const rt:RetData) stdcall;
var i:Integer;
 begin
  EKKA.FLastError:='';
  EKKA.FRD_Item.Clear;
  for i:=Low(rt.RetItem) to High(rt.RetItem) do
   EKKA.FRD_Item.Add(rt.RetItem[i]);

  if rt.Status and $00000001=$00000001 then EKKA.FLastError:='SYNTAX_ERROR' else
  if rt.Status and $00000200=$00000200 then EKKA.FLastError:='PAPER_OUT' else
  if rt.Status and $00000002=$00000002 then EKKA.FLastError:='INVALID_CMD' else
  if rt.Status and $00000004=$00000004 then EKKA.FLastError:='INVALID_TIME' else
  if rt.Status and $00000008=$00000008 then EKKA.FLastError:='PRINT_ERROR' else
  if rt.Status and $00000010=$00000010 then EKKA.FLastError:='SUM_OVERFLOW' else
  if rt.Status and $00000020=$00000020 then EKKA.FLastError:='CMD_NOT_ALLOWED' else
  if rt.Status and $00000040=$00000040 then EKKA.FLastError:='RAM_CLEARED' else
  if rt.Status and $00000080=$00000080 then EKKA.FLastError:='PRINT_RESTART' else
  if rt.Status and $00000100=$00000100 then EKKA.FLastError:='RAM_DESTROYED' else
  if rt.Status and $00000400=$00000400 then EKKA.FLastError:='FISCAL_OPEN' else
  if rt.Status and $00000800=$00000800 then EKKA.FLastError:='NONFISCAL_OPEN' else
  if rt.Status and $00002000=$00002000 then EKKA.FLastError:='F_ABSENT' else
  if rt.Status and $00010000=$00010000 then EKKA.FLastError:='F_WRITE_ERROR' else
  if rt.Status and $00020000=$00020000 then EKKA.FLastError:='F_FULL' else
  if rt.Status and $00040000=$00040000 then EKKA.FLastError:='F_READ_ONLY' else
  if rt.Status and $00080000=$00080000 then EKKA.FLastError:='F_CLOSE_ERROR' else
  if rt.Status and $00100000=$00100000 then EKKA.FLastError:='F_LESS_30' else
  if rt.Status and $01000000=$01000000 then EKKA.FLastError:='PROTOCOL_ERROR' else
  if rt.Status and $02000000=$02000000 then EKKA.FLastError:='NACK_RECEIVED' else
  if rt.Status and $04000000=$04000000 then EKKA.FLastError:='TIMEOUT_ERROR' else
  if rt.Status and $08000000=$08000000 then EKKA.FLastError:='COMMON_ERROR';

//  if rt.Status and $00400000=$00400000 then EKKA.FLastError:='F_FISCALIZED' else
//  if rt.Status and $00004000=$00004000 then EKKA.FLastError:='F_MODULE_NUM' else
//  if rt.Status and $00200000=$00200000 then EKKA.FLastError:='F_FORMATTED' else
//  if rt.Status and $00800000=$00800000 then EKKA.FLastError:='F_SER_NUM' else
 end;

constructor TEKKA.Create(AOwner:TComponent);
var i:Byte;
 begin
  inherited;
  FEmulEKKA:=False;
  IsAbort:=False;
  FIsConnected:=False;
  FKAssaID:=1;
  FBNumb_Chek:=-1;
  FNumVoidChek:='';
  TypeEKKA:=EKKA_MARRY301MTM;
  FCopy_Chek:=-1;
  FIsCopy:=False;
  FIsFLP:=False;
  for i:=Low(Passw) to High(Passw) do Passw[i]:='0000';

 end;

destructor TEKKA.Destroy;
 begin
  inherited;
 end;

function TEKKA.ErrorDescr(Code:String):String;
 begin
  Result:=inherited ErrorDescr(Code);
  if Result=Code then
  if Code='SYNTAX_ERROR'    then Result:='�������������� ������' else
  if Code='INVALID_CMD'     then Result:='�������� �������' else
  if Code='INVALID_TIME'    then Result:='���� � ����� �������' else
  if Code='PRINT_ERROR'     then Result:='������ ������' else
  if Code='SUM_OVERFLOW'    then Result:='�������������� ������������' else
  if Code='CMD_NOT_ALLOWED' then Result:='������� �� ���������' else
  if Code='RAM_CLEARED'     then Result:='��������� ���' else
  if Code='PRINT_RESTART'   then Result:='������ ��� ��������' else
  if Code='RAM_DESTROYED'   then Result:='���������� ���������� � ���' else
  if Code='PAPER_OUT'       then Result:='����������� ������� ���/� ����������� �����' else
  if Code='FISCAL_OPEN'     then Result:='������ ���������� ���' else
  if Code='NONFISCAL_OPEN'  then Result:='������ ������������ ���' else
  if Code='F_ABSENT'        then Result:='�� ��������� ������ ����. ������' else
  if Code='F_WRITE_ERROR'   then Result:='������ ������ � ����. ������' else
  if Code='F_FULL'          then Result:='����. ������ �����������' else
  if Code='F_READ_ONLY'     then Result:='������ � ����. ������ ���������' else
  if Code='F_CLOSE_ERROR'   then Result:='������ ���������� Z-������' else
  if Code='F_LESS_30'       then Result:='� ����. ������ ���� ���������� ������������' else
  if Code='PROTOCOL_ERROR'  then Result:='������ ���������' else
  if Code='NACK_RECEIVED'   then Result:='������ NACK' else
  if Code='TIMEOUT_ERROR'   then Result:='��� ������ �� ������������' else
  if Code='COMMON_ERROR'    then Result:='����� ������' else
  if Code='ERROR_COM'       then Result:='������ �������� Ole-�������' else
  if TypeEKKA=EKKA_EXELLIO  then Result:=FP.LastErrorText else
  if TypeEKKA=EKKA_FP2000   then Result:=FP.LastErrorDescr;
 end;

procedure TEKKA.fpClosePort;
 begin
  if EmulEKKA then Exit;
  if Not (UseEKKA) then Exit;

  FIsConnected:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:inherited;
   EKKA_DATECS3530T:begin
                     CloseFPport;
                    end;
   EKKA_EXELLIO:begin
                 FP.ClosePort;
                 FIsConnected:=False;
                end;
   EKKA_FP2000:begin
                 FP.Disconnect;
                 FIsConnected:=False;
                end;
  end;
 end;

function TEKKA.ReConnect:Boolean;
 begin
  if (FLastError='TIMEOUT_ERROR') or (FIsConnected=False) then
   begin
    fpClosePort;
    Result:=fpConnect;
   end else Result:=True;
 end;

function TEKKA.fpLoadExellio:Boolean;
var Com,Enc:Variant;
 begin
  if TypeEKKA=EKKA_EXELLIO then
   try
    FP:=CreateOleObject('ExellioFP.FiscalPrinter');
    Result:=True;
   except
    FLastError:='ERROR_COM';
    Result:=False;
   end else
  if TypeEKKA=EKKA_FP2000 then
   try
//    Com:=CreateOleObject('CashReg.COMPort');
    Enc:=CreateOleObject('CashReg.Encoding');
    FP:=CreateOleObject('CashReg.ExellioFP2000');
    FP.ComPortName:='COM'+IntToStr(PortNum);
    FP.SetRecommendedPortSettings;
    FP.ComBaudRate:=115200;
    FP.ComEncoding:=Enc.GetEncodingOfCodePage(1251);
//    FP.SetComPort(Com);
    Result:=True;
   except
    FLastError:='ERROR_COM';
    Result:=False;
   end else Result:=True;
 end;

procedure TEKKA.SaveRegisters;
var SL:TStringList;
 begin
  try
   SL:=TStringList.Create;
   try
    SL.Clear;
    SL.Add('1 |'+FP.s1+'|');
    SL.Add('2 |'+FP.s2+'|');
    SL.Add('3 |'+FP.s3+'|');
    SL.Add('4 |'+FP.s4+'|');
    SL.Add('5 |'+FP.s5+'|');
    SL.Add('6 |'+FP.s6+'|');
    SL.Add('7 |'+FP.s7+'|');
    SL.Add('8 |'+FP.s8+'|');
    SL.Add('9 |'+FP.s9+'|');
    SL.Add('10|'+FP.s10+'|');
    SL.Add('11|'+FP.s11+'|');
    SL.SaveToFile(PrPath+'\SList.txt');
   finally
    SL.Free;
   end;
  except
  end;
 end;

function TEKKA.CheckErrorExellio:Boolean;
var S:String;
    i:Integer;
 begin
  if TypeEKKA=EKKA_EXELLIO then
   begin
    if FP.LastError<>0 then
     begin
      FLastError:=FP.LastError;
      Result:=False;
     end else begin
               FLastError:='';
               Result:=True;
              end;
   end else
  if TypeEKKA=EKKA_FP2000 then
   begin


    if VarArrayHighBound(FP.LastError,1)<>-1 then
     begin
      FLastError:=FP.LastErrorDescr; //'ERFP2000';// FP.LastError;
 {
      S:='';
      for i:=0 to VarArrayHighBound(FP.LastError,1) do
       begin
        S:=S+FP.LastError[i]+' | ';
       end;
 }
      Result:=False;
     end else begin
               FLastError:='';
               Result:=True;
              end;
   end else Result:=True;
 end;

function TEKKA.fpConnect:Boolean;
 begin
  if EmulEKKA then
   begin

    FVzhNum:=FKassaID+100100;
    FVzhNumS:=IntToStr(FVzhNum);

    Result:=True;
    Exit;
   end;

  if (Not (UseEKKA)) or (EmulEKKA=True) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpConnect;
   EKKA_DATECS3530T:begin
                     try
                      Result:=InitFPport(PortNum,19200)>0;
//                     Result:=InitFPport(PortNum,115200)>0;
                      if Not Result then Abort;

                      CancelFiscalReceipt;

                      try
                       FIsConnected:=True;
                       Result:=fpGetStatus;
                      finally
                       FIsConnected:=False;
                      end;

                      if Not Result then Exit;
//                      ShowMessage(FVZhNumS);
                      FVZhNumS:=FRD_Item[0];
                      if Length(FRD_Item[1])<>10 then Abort;
                      FVZhNum:=StrToInt64(FRD_Item[1]);
                      FFN:=StrToInt64(FRD_Item[1]);
//                      Result:=(SetOperatorName(0,PrinterResults,0,1,PAnsiChar(Passw[1]),PAnsiChar(Copy(Kassir,1,24)))=0) and (FLastError='');
                      if Not Result then Abort;
                      FIsConnected:=True;
                     except
                      FIsConnected:=False;
                      if FLastError='' then FLastError:='TIMEOUT_ERROR';
                     end;
                    end;
   EKKA_EXELLIO:begin
                 try
                  FP.OpenPort('COM'+IntToStr(PortNum),115200);
 //                SaveRegisters;
                  Result:=FP.LastError=0;
//                  FP.SetOperatorName(1,0000,Copy(Kassir,1,24));

                  if Not Result then FLastError:=FP.LastError;
                  if Not Result then Abort;
                  if Length(FP.s7)<>10 then Abort;
                  FVZhNumS:=FP.s6;
                  FVZhNum:=FP.s7;
                  FFN:=FP.s7;
                  FDatePOEx:=FP.s2;
                  FLastError:='';
                  FIsConnected:=True;
                 except
                  FIsConnected:=False;
                  if FLastError='' then FLastError:='TIMEOUT_ERROR';
                 end;
                end;
   EKKA_FP2000:begin
                try
                 FP.Connect;
                 Result:=VarArrayHighBound(FP.LastError,1)=-1;
                 if Not Result then Abort;

                 if Length(FP.FiscalNumber)<>10 then Abort;
                 FVZhNumS:=FP.SerialNumber;
                 FVZhNum:=FP.FiscalNumber;
                 FFN:=FP.FiscalNumber;

                 FDatePOEx:=FormatDateTime('yyyymmdd',FP.ProgramVersionDate);
                 FLastError:='';
                 FIsConnected:=True;
                except
                 FIsConnected:=False;
                 if FLastError='' then FLastError:='TIMEOUT_ERROR';
                end;

               end;
  end;
 end;

function TEKKA.fpGetStatus:Boolean;
var ri:TStringList;
    sm,DatePO,Ver,S,ss:String;
    i:Integer;
 begin
  if EmulEKKA then
   try
    Result:=False;

    GetInfo(0);
    FRD_Item.Clear;
    for i:=0 to 8 do FRD_Item.Add(' ');

    if Qr.FieldByName('IsOpen').AsInteger=1 then FRD_Item.Add(Chr(0))
                                            else FRD_Item.Add(Chr(1));
    Result:=True;
    Exit;
   except
    FLastError:='ERP_9995';
    Result:=True;
    Exit;
   end;

  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpGetStatus;
   EKKA_DATECS3530T:begin
                     try
                      Result:=ReConnect; if Not Result then Exit;
                      Result:=(GetDiagnosticInfo(0,PrinterResults,0,False)=0) and (FLastError='');
                      if Not Result then Abort;
                      ri:=TStringList.Create;
                      try
                       Ver:=FRD_Item[0];
                       DatePO:=FRD_Item[1];
                       ri.Clear;
                       ri.Add(FRD_Item[6]); // ��� ����� (������� ����������)
                       ri.Add(FRD_Item[7]); // ���������� �����
                       ri.Add('');          // ������������ � ����� ����������� (������ �����)
                       Result:=(GetDateTime(0,PrinterResults,0)=0) and (FLastError='');
                       if Not Result then Abort;
                       S:=FRD_Item[0];
                       ri.Add('20'+Copy(S,7,2)+Copy(S,4,2)+Copy(S,1,2));
                       S:=FRD_Item[1];
                       if Length(S)>=8 then ri.Add(Copy(S,1,2)+Copy(S,4,2)+Copy(S,7,2))
                                       else ri.Add(Copy(S,1,2)+Copy(S,4,2)+'00');
                       ri.Add('1'); // ��������� ���������� ����� (������ 1)
                       ri.Add('1'); // ������� �������� ������� (������ 1)
                       ri.Add('1'); // ������� ������������������� ������� (������ 1)
                       ri.Add('    ');


                       if Not fpCashState(0) then Abort;
                     {  Result:=(GetCurrentTaxes(0,PrinterResults,0,1)=0) and (FLastError='');
                       if Not Result then Exit;
                     }

//                       ShowMessage(CurrToStrF((StrToInt(FRD_Item[3])-StrToInt(FRD_Item[4])+StrToInt(FRD_Item[6])-StrToInt(FRD_Item[7]))*0.01,ffFixed,2));
                       if (StrToInt(FRD_Item[3])-StrToInt(FRD_Item[4])+StrToInt(FRD_Item[6])-StrToInt(FRD_Item[7]))*0.01<=0 then sm:='1' else sm:='0';
                       ri.Add('');

                       Result:=(DayInfo(0,PrinterResults,0)=0) and (FLastError='');
                       if Not Result then Abort;
                       if sm='0' then ri.Add(IntToStr(StrToInt(RD_Item[4])+1)) // ����� ���������� Z-������
                                 else ri.Add(RD_Item[4]);
                       Result:=(GetLastReceipt(0,PrinterResults,0)=0) and (FLastError='');
                       if Not Result then Abort;
                       ri.Add(RD_Item[0]); // ����� ���������� ����������� ����
                       ri.Add('    ');
                       ri.Add(Ver);
                       ri.Add(DatePO);
                       ri.Add('');
                       ri.Add(DatePO);
                       ri.Add('2');
                       ri.Add('���');
                       FRD_Item.Text:=ri.Text;
                       FRD_Item[9]:=Chr(StrToInt(sm));
                       Result:=True;
                       FLastError:='';
                      finally
                       ri.Free;
                      end;
                     except
                      Result:=False;
                      if FLastError='' then FLastError:='ERP_9995';
                     end;
                    end;
   EKKA_EXELLIO:begin
                 try
                  Result:=ReConnect; if Not Result then Exit;
                  ri:=TStringList.Create;
                  try
                   ri.Clear;
                   ri.Add(IntToStr(FFn));
                   ri.Add(IntToStr(FFn));
                   ri.Add('');
                   FP.GetDateTime;
                   if Not CheckErrorExellio then Abort;

                   ri.Add('20'+Copy(FP.s1,7,2)+Copy(FP.s1,4,2)+Copy(FP.s1,1,2));
                   ri.Add(Copy(FP.s1,10,2)+Copy(FP.s1,13,2)+Copy(FP.s1,16,2));

                   ri.Add('1'); // ��������� ���������� ����� (������ 1)
                   ri.Add('1'); // ������� �������� ������� (������ 1)
                   ri.Add('1'); // ������� ������������������� ������� (������ 1)
                   ri.Add('    ');
                   FP.GetSmenLen;
//                   SaveRegisters;
                   if Not CheckErrorExellio then Abort;
                   if FP.s1='Z' then sm:='1' else sm:='0';
//                   ri.Add(Chr(StrToInt(sm)));
                   ri.Add('');

                   FP.LastFiscalClosure(0);
                   if Not CheckErrorExellio then
                    begin

                     {FP.GetLastReceiptNum;
                     if Not CheckErrorExellio then Abort;
                     ss:=FP.s1;}
                     ss:=IntToStr(GetNumZ);
                    end else  ss:=FP.s1;

                   if sm='0' then ri.Add(IntToStr(StrToInt(ss)+1))
                             else ri.Add(ss);

                   FP.GetLastReceiptNum;
                   if Not CheckErrorExellio then Abort;
                   ri.Add(FP.s1); // ����� ���������� ����������� ����
                   FP.GetDiagnosticInfo(False);
                   if Not CheckErrorExellio then Abort;
                   ri.Add('    ');
                   ri.Add(FP.s1);
                   ri.Add(FDatePOEx);
                   ri.Add('');
                   ri.Add(FDatePOEx);
                   ri.Add('2');
                   ri.Add('���');
                   FRD_Item.Text:=ri.Text;
                   FRD_Item[9]:=Chr(StrToInt(sm));
                   Result:=True;
                   FLastError:='';
                  finally
                   ri.Free;
                  end;
                 except
                  Result:=False;
                  if FLastError='' then FLastError:='ERP_9995';
                 end;
                end;
   EKKA_FP2000: begin
                 try
                  Result:=ReConnect; if Not Result then Exit;
                  ri:=TStringList.Create;
                  try
                   ri.Clear;
                   ri.Add(IntToStr(FFn));
                   ri.Add(IntToStr(FFn));
                   ri.Add('');
                   ri.Add(FormatDateTime('yyyymmdd',FP.GetDateTime));
                   ri.Add(FormatDateTime('hhnnss',FP.GetDateTime));
                   if Not CheckErrorExellio then Abort;
                   ri.Add('1'); // ��������� ���������� ����� (������ 1)
                   ri.Add('1'); // ������� �������� ������� (������ 1)
                   ri.Add('1'); // ������� ������������������� ������� (������ 1)
                   ri.Add('    ');

                   if FP.GetShiftStatus.IsOpen then sm:='0' else sm:='1';
//                   SaveRegisters;
                   if Not CheckErrorExellio then Abort;
                   ri.Add('');

                   ss:=IntToStr(FP.GetLastZReportInfo.ReportNumber);
                   if Not CheckErrorExellio then
                    begin
                     if Pos(AnsiUpperCase('���������� ������� ����������� � ������� ���������� ������ ������'),AnsiUpperCase(LastErrorDescr))<>0 then ss:='0' else Abort;
                    end; 

                   if sm='0' then ri.Add(IntToStr(StrToInt(ss)+1))
                             else ri.Add(ss);

{                   FP.GetLastReceiptNum;
                   if Not CheckErrorExellio then Abort;
}
                   ri.Add(FP.GetLastCheckNumber); // ����� ���������� ����������� ����

                   if Not CheckErrorExellio then Abort;
                   ri.Add('    ');
                   ri.Add(FP.ProgramVersion);

                   ri.Add(FDatePOEx);
                   ri.Add('');
                   ri.Add(FDatePOEx);
                   if Not CheckErrorExellio then Abort;
                   ri.Add('2');
                   ri.Add('���');

                   FRD_Item.Text:=ri.Text;
                   FRD_Item[9]:=Chr(StrToInt(sm));
                   Result:=True;
                   FLastError:='';
                  finally
                   ri.Free;
                  end;
                 except
                  Result:=False;
                  if FLastError='' then FLastError:='ERP_9995';
                 end;
                end;
  end;
 end;

function TEKKA.fpSetTime(T:TDateTime):Boolean;
var D:String;
 begin

  if (Not (UseEKKA) or (EmulEKKA=True)) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpSetTime(T);
   EKKA_DATECS3530T:begin
                     Result:=ReConnect; if Not Result then Exit;
                     Result:=(GetDateTime(0,PrinterResults,0)=0) and (FLastError='');
                     if Not Result then Exit;
                     D:=FRD_Item[0];
                     Result:=(SetDateTime(0,PrinterResults,0,PAnsiChar(D),PAnsiChar(FormatDateTime('hh:nn:ss',T)))=0) and (FLastError='');
                    end;
   EKKA_EXELLIO:begin
                 Result:=ReConnect; if Not Result then Exit;
                 FP.SetDateTime(FormatDateTime('dd-mm-yy',T),FormatDateTime('hh:nn',T));
                 Result:=CheckErrorExellio;
                end;
   EKKA_FP2000:begin
                 Result:=ReConnect; if Not Result then Exit;
                 FP.SetDateTime(T);
                 Result:=CheckErrorExellio;
                end;
  end;
 end;

function TEKKA.fpXRep:Boolean;
 begin

  if EmulEKKA then
   try
    bPrintRep(0);
    Result:=True;
    Exit;
   except
    on E:Exception do
     begin
      FLastError:='������ ������ X-������: '+E.Message;
      Result:=False;
      Exit;
     end;
   end;

  if Not (UseEKKA) then begin Result:=True; Exit; end;

  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpXRep;
   EKKA_DATECS3530T:begin
                     Result:=ReConnect; if Not Result then Exit;
                     Result:=(FiscalClosure(0,PrinterResults,0,PAnsiChar(Passw[15]),'2')=0) and (FLastError='');
                    end;
   EKKA_EXELLIO:begin
                 Result:=ReConnect; if Not Result then Exit;
                 FP.XReport('0000');
//                 SaveRegisters;
                 Result:=CheckErrorExellio;
                end;
   EKKA_FP2000:begin
                 Result:=ReConnect; if Not Result then Exit;
                 FP.XReport;
                 Result:=CheckErrorExellio;
                end;
  end;
 end;

function TEKKA.fpZRep:Boolean;
var B:Boolean;
    Sum:Currency;
    Res:Variant;
 begin

  if EmulEKKA then
   try
    bPrintRep(1);
    Result:=True;
    Exit;
   except
    on E:Exception do
     begin
      FLastError:='������ ������ Z-������: '+E.Message;
      Result:=False;
      Exit;
     end;
   end;

  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpZRep;
   EKKA_DATECS3530T:begin
                     Result:=ReConnect; if Not Result then Exit;
                     Result:=(ServiceInputOutput(0,PrinterResults,0,0)=0) and (FLastError='');
                     Sum:=StrToInt(FRD_Item[0])*0.01;
                     //Result:=(FiscalClosure(0,PrinterResults,0,PAnsiChar(Passw[15]),'2')=0) and (FLastError='');
                     Result:=(ServiceInputOutput(0,PrinterResults,0,-Sum)=0) and (FLastError='');
                     Result:=(FiscalClosure(0,PrinterResults,0,PAnsiChar(Passw[15]),'0')=0) and (FLastError='');
                     if Not Result then Exit;
                     DeleteArticle(0,PrinterResults,0,0,PAnsiChar(Passw[14]));
                     DeleteFile(FArtFile);
                     ServiceInputOutput(0,PrinterResults,0,Sum);
                    end;
   EKKA_EXELLIO:begin
                 Result:=ReConnect; if Not Result then Exit;
                 FP.InOut(0);
                 Sum:=StrToInt64(FP.s2)*0.01;
                 FP.InOut(-Sum);
                 FP.ZReport('0000');
                 Result:=CheckErrorExellio;
                 if Not Result then Exit;
                 FP.DelArticle('0000',0);
                 FP.InOut(Sum);

                 FP.LastFiscalClosure(0);
                 if FP.LastError<>0 then NextNumZ;
                end;
   EKKA_FP2000:begin
                Result:=ReConnect; if Not Result then Exit;
                Res:=FP.GetCashDeskInfo;
                Sum:=Res.CashSum;
                FP.CashOutput(Sum);
                FP.ZReport;
                Result:=CheckErrorExellio;
                if Not Result then Exit;
                FP.DeleteArticles;
                FP.CashInput(Sum);
               end;
  end;
 end;

function TEKKA.GetReceiptNumber:Integer;
var Res: Integer;
 begin
  if EmulEKKA then
   try
    FLastError:='';

    GetInfo;

    Result:=Qr.FieldByName('NLastChek').AsInteger;
    Exit;
   except
    on E:Exception do
     begin
      FLastError:='������ ����������� ������ ����: '+E.Message;
      Result:=-1;
      Exit;
     end;
   end;

  if Not (UseEKKA) then begin Result:=-1; Exit; end;
  Result:=-1;
  try
   Case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited GetReceiptNumber;
    EKKA_DATECS3530T:try
                      if Not ReConnect then Abort;
                      if GetLastReceipt(0,PrinterResults,0)<>0 then Abort;
                      Result:=StrToInt(FRD_Item[0]);
                     except
                      Result:=-1;
                     end;
    EKKA_EXELLIO:begin
                  if Not ReConnect then Exit;
                  FP.GetLastReceiptNum;
                  if Not CheckErrorExellio then Exit;
                  Result:=FP.s1;
                 end;
    EKKA_FP2000:begin
                  if Not ReConnect then Exit;
                  Res:=FP.GetLastCheckNumber;
                  if Not CheckErrorExellio then Exit;
                  Result:=Res;
                 end;
   end;
  finally
   if (Result=-1) and (FLastError='') then FLastError:='ERP_9987';
  end;
 end;

function TEKKA.GetVzhNum:Int64;
 begin
  if EmulEKKA then
   begin
    Result:=FKassaID+100100;
    Exit;
   end;

  if Not (UseEKKA) then begin Result:=0; Exit; end;
  Result:=0;
  try
   Case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited GetVzhNum;
    EKKA_DATECS3530T:try
                      if FVzhNum<=0 then
                       if Not ReConnect then Abort;
                      Result:=FVzhNum;
                     except
                      Result:=0;
                     end;
    EKKA_EXELLIO:try
                  if FVzhNum<=0 then
                   begin
                    if Not ReConnect then Abort;
                    if Not CheckErrorExellio then Exit;
                   end;
                  Result:=FVzhNum;
                 except
                  Result:=0
                 end;
    EKKA_FP2000:try
                  if FVzhNum<=0 then
                   begin
                    if Not ReConnect then Abort;
                    if Not CheckErrorExellio then Exit;
                   end;
                  Result:=FVzhNum;
                 except
                  Result:=0
                 end;
   end;
  finally
   if (Result=0) and (FLastError='') then FLastError:='ERP_9987';
  end;
 end;

function TEKKA.KeyPosition(Key:Byte):Boolean;
 begin
  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited KeyPosition(Key);
   EKKA_DATECS3530T:Result:=True;
   EKKA_EXELLIO:Result:=True;
   EKKA_FP2000:Result:=True;
  end;
 end;

function TEKKA.fpOpenFiscalReceipt(Param:Byte=1):Boolean;
 begin
  if EmulEKKA then
   try
    if FIsCopy=False then GetInfo;

    SetLength(sArr,0);

    bPrintHead;

    if FIsCopy then
     begin
      MrFont.AddStrC('*  *  * ���I� *  *  *',1);
      MrFont.AddStrC('��� �  '+IntToStr(FCopy_chek),1);
     end else MrFont.AddStrC('��� �  '+IntToStr(Qr.FieldByName('NLastChek').AsInteger+1),1);

    if IsFLP=False then
     MrFont.AddStrC('�����: '+Kassir,0);

    MrFont.AddStrC('�i��. 1',0);

    if FBNumb_Chek>-1 then MrFont.AddStr('���. �� ����'+IntToStr(FBNumb_Chek),0);

    FSumNA:=0;   FSumNB:=0; FSumNC:=0;
    FSumSale:=0; FSumVoid:=0;
    FSumDis:=0;

    Result:=True;
    Exit;
   except
    on E:Exception do
     begin
      FLastError:='������ �������� ����: '+E.Message;
      Result:=False;
      Exit;
     end;
   end;

  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpOpenFiscalReceipt;
   EKKA_DATECS3530T:begin
                     Result:=ReConnect; if Not Result then Exit;
                     Case Param of
                      CH_SALE:Result:=(OpenFiscalReceipt(0,PrinterResults,0,1,PAnsiChar(Passw[1]),KassaID,True)=0) and (FLastError='FISCAL_OPEN');
                      CH_BACK:begin
                               Result:=(OpenRepaymentReceipt(0,PrinterResults,0,1,PAnsiChar(Passw[1]),KassaID,True)=0) and ((FLastError='FISCAL_OPEN') or (FLastError='PRINT_RESTART'));
                               if Not Result then Exit;
                               Result:=(PrintFiscalText(0,PrinterResults,0,PAnsiChar(FNumVoidChek))=0) and ((FLastError='FISCAL_OPEN') or (FLastError='PRINT_RESTART'));
                              end;
                     end;
                    end;
   EKKA_EXELLIO:begin
                 Result:=ReConnect; if Not Result then Exit;
                 Case Param of
                  CH_SALE:FP.OpenFiscalReceipt(1,'0000',1);
                  CH_BACK:begin
                           FP.OpenReturnReceipt(1,'0000',1);
                           if FP.LastError=0 then FP.PrintFiscalText(FNumVoidChek);
                          end;
                 end;
                 Result:=CheckErrorExellio;
                end;
   EKKA_FP2000:begin
                Result:=ReConnect; if Not Result then Exit;
                Case Param of
                 CH_SALE:FP.OpenFiscalCheck(True);
                 CH_BACK:begin
                          FP.OpenFiscalCheck(False);
                          if CheckErrorExellio then FP.AddFiscalText(FNumVoidChek);
                         end;
                end;
                Result:=CheckErrorExellio;
               end;
  end;
 end;

function TEKKA.fpIsNonClosedReceipt:Boolean;
var Res:Boolean;
 begin
  if Not (UseEKKA) then begin Result:=False; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=False;
   EKKA_DATECS3530T:try
                     if Not ReConnect then Abort;
                     GetFiscalClosureStatus(0,PrinterResults,0,True);
                     if ((FLastError='FISCAL_OPEN') or (FLastError='PRINT_RESTART')) then
                      begin
                       Result:=Not CancelFiscalReceipt;
                      end else Exit;
                     FLastError:='';

                    except
                     Result:=True;
                     FLastError:='ERP_9993';
                    end;

   EKKA_EXELLIO:Result:=False;
   EKKA_FP2000:Result:=False;
  end;
 end;

function TEKKA.CancelFiscalReceipt:Boolean;
 begin
  try
   Result:=(GetFiscalClosureStatus(0,PrinterResults,0,False)=0) and (FLastError='');
   if Not Result then Abort;
   if StrToInt(FRD_Item[0])=1 then Abort else Result:=True;
  except
   Result:=(ResetReceipt(0,PrinterResults,0)=0) and (FLastError='');
  end;
 end;

function TEKKA.fpCancelFiscalReceipt:Boolean;
var Res:Variant;
 begin
{
  if EmulEKKA then
   begin
    MrFont.AbortPrint;
    Result:=True;
    Exit;
   end;
}
  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpCancelFiscalReceipt;
   EKKA_DATECS3530T:begin
                     Result:=ReConnect; if Not Result then Exit;
                     Result:=CancelFiscalReceipt;
                    end;
   EKKA_EXELLIO:begin
                 Result:=ReConnect; if Not Result then Exit;
                 FP.GetFiscalClosureStatus(False);
                 if FP.s1=1 then FP.CancelReceipt;
                 Result:=CheckErrorExellio;
                end;
   EKKA_FP2000:begin
                 Result:=ReConnect; if Not Result then Exit;
                 Res:=FP.GetFiscalTransactionStatus;
                 if Res.IsOpenCheck then FP.CancelCheck;
                 Result:=CheckErrorExellio;
                end;
  end;

 end;

function TEKKA.fpAddSale(Name:String;
                         Kol:Integer;
                         Cena:Currency;
                         Divis:Byte;
                         Artic:Integer;
                         Nalog:Byte;
                         DiscSum:Currency;
                         DiscDescr:String):Boolean;
var Art,i:Integer;
    Sh:Char;
    sNds,S,sArt:String;

 begin

  if EmulEKKA then
   try
    FLastError:='';

    S:=Name+' '+CurrToStrF_(Cena)+'*'+IntToStr(Kol)+'=';

    Case Nalog of
     1:begin
        sNds:='�';
        FSumNA:=FSumNA+(cena*kol+DiscSum)/6;
       end;
     2:begin
        sNds:='�';
        FSumNB:=FSumNB+(cena*kol+DiscSum)*(7/107);
       end;
     3:begin
        sNds:='�';
        FSumNC:=FSumNC; //+(cena*kol+DiscSum)*(7/107);
       end;
    end;


    if Artic=99999 then FSumVoid:=FSumVoid+cena*kol+DiscSum
                   else FSumSale:=FSumSale+cena*kol+DiscSum;

    FSumDis:=FSumDis+DiscSum;

{
    if Nalog=1 then
     begin
      MrFont.AddStr2J('��� - *�20.00%=',CurrToStrF_((cena*kol+DiscSum)/6),0,30);
      MrFont.AddStr2J('����� ��� ���=',CurrToStrF_((kol*cena+DiscSum)-(cena*kol+DiscSum)/6),0,30);
     end;
}

    While Length(S)>30 do
     begin
      MrFont.AddStr(Copy(S,1,30),0);
      S:=Copy(S,31,Length(S));
     end;

    MrFont.AddStr2J(Copy(S,1,30),CurrToStrF_(Cena*kol)+'-'+sNDS,0);

    if DiscSum<0 then
     MrFont.AddStr2J('������ -' ,' -'+CurrToStrF_(Abs(DiscSum))+'  ',0) else
    if DiscSum>0 then
     MrFont.AddStr2J('�������� -',CurrToStrF_(Abs(DiscSum))+'  ',0);

    Result:=True;
    Exit;

   except
    on E:Exception do
     begin
      FLastError:='������ ���������� ������: '+E.Message;
      Result:=False;
      Exit;
     end;
   end;

  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpAddSale(Name,Kol,Cena,Divis,Artic,Nalog,DiscSum,DiscDescr);
   EKKA_DATECS3530T:try
                     Result:=ReConnect; if Not Result then Exit;
                     Sh:=#0;
                     Case Nalog of
                      1:Sh:='�';
                      2:Sh:='�';
                      3:Sh:='�' else Abort;
                     end;
                     for i:=1 to 30 do
                      begin
                       if (Artic=0) or (Artic=99999) then Art:=StrToInt(fpGetNewArt) else Art:=Artic;
                       if (ProgrammingArticle(0,PrinterResults,0,Sh,Art,1,Cena,
                                             PAnsiChar(Passw[14]),
                                             PAnsiChar(Copy(Name,1,24)+#09+Copy(Name,25,24)))<>0) or ((FLastError<>'FISCAL_OPEN') and (FLastError<>'PRINT_RESTART')) then Abort;
                       if FRD_Item[0]<>'P' then
                        begin
                         if Artic=0 then Abort;
                        end else Break;
                      end;
                     Result:=(SaleArticle(0,PrinterResults,0,True,Art,Kol,0,DiscSum)=0) and ((FLastError='FISCAL_OPEN') or (FLastError='PRINT_RESTART'));
                    except
                     Result:=False;
                     if FLastError='' then FLastError:='ERP_9992';
                    end;
   EKKA_EXELLIO:begin
                 Result:=ReConnect; if Not Result then Exit;
                 sArt:=IntToStrF(Artic,6)+IntToStr(Nalog);
                 FP.GetArticle(sArt);
                 if FP.s1='F' then FP.SetArticle(StrToInt(sArt),Nalog,1,Cena,'0000',Copy(Name,1,36));
                 FP.RegistrItemEx(StrToInt(sArt),Kol,Cena,0,DiscSum);
                 Result:=CheckErrorExellio;
                end;
   EKKA_FP2000:begin
                 Result:=ReConnect; if Not Result then Exit;
                 sArt:=IntToStrF(Artic,6)+IntToStr(Nalog);
                 if Not FP.GetArticleInfo(StrToInt(sArt)).IsProgram then FP.SetArticleInfo(StrToInt(sArt),Copy(Name,1,36),Nalog,Cena,1);
                 FP.AddFisc(StrToInt(sArt),Kol,Cena,true,DiscSum,0);
                 Result:=CheckErrorExellio;
                end;
  end;
 end;

function TEKKA.fpAddBack(Name:String;
                         Kol:Integer;
                         Cena:Currency;
                         Divis:Byte;
                         Artic:Integer;
                         Nalog:Byte;
                         DiscSum:Currency;
                         DiscDescr:String
                        ):Boolean;

 begin
  if (TypeEKKA=EKKA_EXELLIO) or (TypeEKKA=EKKA_FP2000) then Result:=fpAddSale(Name,Kol,Cena,Divis,Artic,Nalog,DiscSum,DiscDescr)
                                                       else Result:=fpAddSale(Name,Kol,Cena,Divis,99999,Nalog,DiscSum,DiscDescr);
 end;

function TEKKA.fpSetBackReceipt(S:String):Boolean;
 begin

  if EmulEKKA then
   begin
    FBNumb_Chek:=StrToInt(S);
    Result:=True;
    Exit;
   end;

  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpSetBackReceipt(S);
   EKKA_DATECS3530T:begin
                     FNumVoidChek:='���. �� ���ӹ '+S;
                     Result:=True;
                    end;
   EKKA_EXELLIO    :begin
                     FNumVoidChek:='���. �� ���ӹ '+S;
                     Result:=True;
                    end;
   EKKA_FP2000    :begin
                     FNumVoidChek:='���. �� ���ӹ '+S;
                     Result:=True;
                    end;
  end;
 end;

function TEKKA.fpCloseFiscalReceiptB(TakedSumm:Currency; TypeOplat:Integer; SumCheck:Currency=0):Boolean;
var PaidCode:Char;
    Sum,SumItog,SumOplat:Currency;
 begin
  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpCloseFiscalReceiptB(TakedSumm,TypeOplat,SumCheck);
   EKKA_DATECS3530T:Result:=False;
   EKKA_EXELLIO:Result:=False;
   EKKA_FP2000:Result:=False;
  end;
 end;

function TEKKA.fpCloseFiscalReceipt(TakedSumm:Currency; TypeOplat:Integer; SumCheck:Currency=0; SumB1:Currency=0; IsDnepr:Boolean=False):Boolean;
var PaidCode:Char;
    Sum,SumItog,SumOplat,SumS:Currency;
    i,Ty:Integer;
    Res,Res1:Variant;
    TyB:Char;
    TyB1:Byte;
 begin

  if EmulEKKA then
   try

//  MrFont.AddStrC('- - ����� �� ���� - -',1);

    if FSumDis<0 then
     MrFont.AddStr2J('������ - ','-'+CurrToStrF_(Abs(FSumDis))+'  ',0) else
    if FSumDis>0 then
     MrFont.AddStr2J('�������� - ',CurrToStrF_(Abs(FSumDis))+'  ',0);

    MrFont.AddStrC('���� '+CurrToStrF_(Abs(FSumSale-FSumVoid))+' ���',3);

    MrFont.AddStr2J('���               *� 20.00%',CurrToStrF_(Abs(FSumNA))+'  ',0);
    MrFont.AddStr2J('���               *�  7.00%',CurrToStrF_(Abs(FSumNB))+'  ',0);
    MrFont.AddStr2J('���               *�  0.00%',CurrToStrF_(Abs(FSumNC))+'  ',0);

    MrFont.AddStrC('- - - - - �������� i�������i� - - - - -',0);

    if High(sArr)>-1 then
     for i:=Low(sArr) to High(sArr) do MrFont.AddStr(sArr[i].S,sArr[i].F);
{

    MrFont.AddStr('��� ����������� � ������������',0);
    MrFont.AddStr('38057-344-0-344',1);

}

//    Kassir:='��������';
    if IsFLP=False then
     MrFont.AddStr('�����: '+Kassir,0);
    MrFont.AddStrC('- - - - - - - - - - - - - -  - - - - - ',0);

    Case TypeOplat of
     1:MrFont.AddStr2J('������i�����.3',CurrToStrF_(Abs(FSumSale-FSumVoid))+'  ',0);
     3:MrFont.AddStr2J('������i�����.1',CurrToStrF_(Abs(FSumSale-FSumVoid))+'  ',0);
     2:MrFont.AddStr2J('������i�����.2',CurrToStrF_(Abs(FSumSale-FSumVoid))+'  ',0);
     4:begin
        if SumB1=0 then
         begin
          MrFont.AddStr2J('���i��� ',CurrToStrF_(Abs(FSumSale-FSumVoid))+'  ',0);
          if TakedSumm>SumCheck then
           begin
            MrFont.AddStr2J('���i���',' '+CurrToStrF_(Abs(TakedSumm)),1);
            MrFont.AddStr2J('�����',' '+CurrToStrF_(Abs(TakedSumm-SumCheck)),1);
           end;
         end else begin
                  {
                   MrFont.AddStr2J('���i���',' '+CurrToStrF_(37.34),0);
                   MrFont.AddStr2J('������i�����.3',' '+CurrToStrF_(287.59),0);
                  }
                   if FBNumb_chek=1 then
                    begin
                     if SumB1<FSumSale-FSumVoid then
                      begin
                       SumS:=0;
                       MrFont.AddStr2J('���i���',' '+CurrToStrF_(Abs(FSumSale-FSumVoid-SumB1)),0);
                       if TakedSumm>FSumSale-FSumVoid-SumB1 then SumS:=TakedSumm-(FSumSale-FSumVoid-SumB1);
                      end;
                      if IsDnepr then MrFont.AddStr2J('������i�����.3',' '+CurrToStrF_(Abs(SumB1)),0)
                                 else MrFont.AddStr2J('������i�����.1',' '+CurrToStrF_(Abs(SumB1)),0);
                      if SumS>0 then
                       begin
                        MrFont.AddStr2J('���i���',' '+CurrToStrF_(Abs(TakedSumm)),1);
                        MrFont.AddStr2J('�����',' '+CurrToStrF_(Abs(SumS)),1);
                       end;
                    end else begin

                               if Abs(FSumSale-FSumVoid)>SumB1 then
                                MrFont.AddStr2J('���i��� ',CurrToStrF_(Abs(FSumSale-FSumVoid)-SumB1)+'  ',0);

                               if SumB1<FSumVoid then
                                begin
                                 MrFont.AddStr2J('���i���',' '+CurrToStrF_(Abs(FSumVoid-SumB1)),0);
                                 if IsDnepr then MrFont.AddStr2J('������i�����.3',' '+CurrToStrF_(Abs(SumB1)),0)
                                            else MrFont.AddStr2J('������i�����.1',' '+CurrToStrF_(Abs(SumB1)),0);
                                end else begin
                                          if IsDnepr then MrFont.AddStr2J('������i�����.3',' '+CurrToStrF_(Abs(SumB1-FSumVoid)),0)
                                                     else MrFont.AddStr2J('������i�����.1',' '+CurrToStrF_(Abs(SumB1-FSumVoid)),0);
                                         end
                              end

                  end;
       end;
    end;

    MrFont.AddStrC('������ ��� ������''�',1);

     if FIsCopy=False then
      begin
       GetInfo;
       FDtChek:=Now();
       //FDtChek:=StrToDateTime('08.05.17 09:02:15');
       if IsFLP=False then
        MrFont.AddStr('#'+AddStr_(IntToStr(Qr.FieldByName('NLastChek').AsInteger),'_',10)+' '+DateTimeToStrSlash(FDtChek)+' ��:'+FsFN,0);
      end else begin
                if IsFLP=False then
                 MrFont.AddStr('#'+AddStr_(IntToStr(FCopy_Chek),'_',10)+' '+DateTimeToStrSlash(FDtChek)+' ��:'+FsFN,0);
               end;

    if FBNumb_chek=-1 then bPrintFooter(1) else bPrintFooter(5);

    FBNumb_Chek:=-1;
    if FIsCopy=False then
     begin
      if Qr.FieldByName('NLastChek').AsInteger mod 10=0 then fpSendToEKV;
     end;

    Result:=True;
    Exit;
   except
    on E:Exception do
     begin
      bPrintFooter(2);
      FLastError:='������ �������� ����: '+E.Message;
      Result:=False;
      Exit;
     end;
   end;

  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
   {

    ���� �����:
          �����    | ������ FP3530 | Exellio LP1000 | Exellio FP2000 | ��������
     1 - ������ 3  |      N        |       2        |        4       | ������ � ������
     2 - ������ 2  |      D        |       4        |        3       | ������ � ������� ��������� �����
     3 - ������ 1  |      C        |       3        |        2       | ������ �����
     4 - ��������  |      P        |       1        |        1       | ������ ���������

   }

  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpCloseFiscalReceipt(TakedSumm,TypeOplat,SumCheck,SumB1,IsDnepr);
   EKKA_DATECS3530T:try
                     Result:=ReConnect; if Not Result then Exit;
                     PaidCode:=#0;

                     Case TypeOplat of
                      1:PaidCode:='N';  // ������ � ������
                      2:PaidCode:='D';  // ������ � ������� ��������� �����
                      3:PaidCode:='C';  // ������ �����
                      4:PaidCode:='P'   // ������ ���������
                      else Abort;
                     end;

                     if IsDnepr then TyB:='N' else TyB:='C';

                     Result:=(GetFiscalClosureStatus(0,PrinterResults,0,True)=0) and ((FLastError='FISCAL_OPEN') or (FLastError='PRINT_RESTART'));
                     if Not Result then Abort;
                     SumItog:=StrToInt64(FRD_Item[2])*0.01;
                     SumOplat:=StrToInt64(FRD_Item[3])*0.01;
                     if TakedSumm<>0 then
                      begin
                       if CurrToStrF(SumItog,ffFixed,2)<>CurrToStrF(SumCheck,ffFixed,2) then
                        begin
                         FLastError:='SOFTBADCS';
                         Abort;
                        end;
                       Sum:=TakedSumm;
                      end else begin
                                Sum:=SumItog-SumOplat;
                               end;
                     if (Sum<>0) or ((Sum=0) and (SumItog=0)) then
                      begin

                       if SumB1=0 then
                        Result:=(Total(0,PrinterResults,0,'',PaidCode,Sum)=0) and ((FLastError='FISCAL_OPEN') or (FLastError='PRINT_RESTART'))
                       else begin
                             if (SumItog-SumOplat)>SumB1 then
                              begin
                               Result:=(Total(0,PrinterResults,0,'','P',(SumItog-SumOplat)-SumB1)=0) and ((FLastError='FISCAL_OPEN') or (FLastError='PRINT_RESTART'));
                               Result:=(Total(0,PrinterResults,0,'',TyB,SumB1)=0) and ((FLastError='FISCAL_OPEN') or (FLastError='PRINT_RESTART'));
                              end else Result:=(Total(0,PrinterResults,0,'',TyB,SumItog-SumOplat)=0) and ((FLastError='FISCAL_OPEN') or (FLastError='PRINT_RESTART'));
                            end;

                       if Not Result then Abort;
                      end;
                     if IsAbort then Abort;
                     PrintFiscalText(0,PrinterResults,0,PAnsiChar('* * * * * * * * * *'));
                     Result:=(CloseFiscalReceipt(0,PrinterResults,0)=0) and (FLastError='');
                     if Not Result then Abort;
                     FNumVoidChek:='';
                    except
                     Result:=False;
                     if FLastError='' then FLastError:='ERP_9991';
                    end;
   EKKA_EXELLIO:begin
                 Result:=ReConnect; if Not Result then Exit;
                 Case TypeOplat of
                  1:Ty:=2;
                  4:Ty:=1;
                  3:Ty:=3;
                  2:Ty:=4;
                 end;
                 if IsDnepr then TyB1:=2 else TyB1:=3;
                 try
                  if SumB1=0 then
                   begin
                    FP.TotalEx('',Ty,TakedSumm);
                    Result:=CheckErrorExellio;
                    if Not Result then Abort;
                   end else begin
                             FP.GetFiscalClosureStatus(True);
                             Result:=CheckErrorExellio;
                             if Not Result then Abort;
                             SumItog:=StrToInt64(FP.s3)*0.01;
                             SumOplat:=StrToInt64(FP.s4)*0.01;
                             if (SumItog-SumOplat)>SumB1 then
                              begin
                               FP.Total('',1,(SumItog-SumOplat)-SumB1);
                               Result:=CheckErrorExellio;
                               if Not Result then Abort;
                               FP.Total('',TyB1,(SumB1));
                               Result:=CheckErrorExellio;
                               if Not Result then Abort;
                              end else begin
                                        FP.Total('',TyB1,(SumItog-SumOplat));
                                        Result:=CheckErrorExellio;
                                        if Not Result then Abort;
                                       end;
                             FP.CloseFiscalReceipt;
                             Result:=CheckErrorExellio;
                             if Not Result then Abort;
                            end;
                  FNumVoidChek:='';
                 except
                  FP.CancelReceipt;
                  Result:=False;
                  if FLastError='' then FLastError:='ERP_9991';
                 end;
                end;
   EKKA_FP2000:begin
                Result:=ReConnect; if Not Result then Exit;
                Case TypeOplat of
                 1:Ty:=4;
                 4:Ty:=1;
                 3:Ty:=2;
                 2:Ty:=3;
                end;
                if IsDnepr then TyB1:=4 else TyB1:=2;
                try
                 if SumB1=0 then
                  begin
                   Res1:=FP.TotalEx(TakedSumm, Ty);

                   Result:=CheckErrorExellio;
                   if Not Result then raise EAbort.Create('er1');
                  end else begin
                     Res:=FP.GetFiscalTransactionStatus;
                     Result:=CheckErrorExellio;
                     if Not Result then raise EAbort.Create('er2');
                     SumItog:=Res.LastCheckSum;
                     SumOplat:=Res.LastCheckPaySum;

                     if (SumItog-SumOplat)>SumB1 then
                       begin
                         Res:=FP.Total((SumItog-SumOplat)-SumB1, 1);
                         Result:=CheckErrorExellio;
                         if Not Result then raise EAbort.Create('er3');
                         Res:=FP.Total(SumB1, TyB1);
                         Result:=CheckErrorExellio;
                         if Not Result then raise EAbort.Create('er4');
                       end else begin
                                 Res:=FP.Total((SumItog-SumOplat), TyB1);
                                 Result:=CheckErrorExellio;
                                 if Not Result then raise EAbort.Create('er5');
                                end;
                     FP.CloseFiscalCheck;
                     Result:=CheckErrorExellio;
                     if Not Result then raise EAbort.Create('er6');
                  end;
                  FNumVoidChek:='';
                 except
                  on E:Exception do
                   begin
//                    ShowMessage(E.Message);
                    FP.CancelCheck;
                    Result:=False;
                    if FLastError='' then FLastError:='ERP_9991';
                   end;
                 end;
                end;
  end;
 end;

function TEKKA.fpCheckCopy(Cnt:Byte=1):Boolean;
var i,Nds,Ty:Integer;
    Art:Integer;
    SumChek:Currency;
 begin

  if EmulEKKA then
   try
    FIsCopy:=True;
    try

     Qr1.Close;
     Qr1.SQL.Clear;
     Qr1.SQL.Add('exec spY_GetLastChek '+IntToStr(KassaID)+','+IntToStr(VzhNum));

{     Qr1.SQL.Add('declare @idk int, @vzh bigint ');
     Qr1.SQL.Add('set @idk='+IntToStr(KassaID));
     Qr1.SQL.Add('set @vzh='+IntToStr(VzhNum));
     Qr1.SQL.Add('');
     Qr1.SQL.Add('select IsNull(b.art_code,a.kod_name) as art_code,IsNull(b.names,a.names) as names,a.numb_chek,'+'Sum(Abs(case when a.kol=0 then 1 else a.kol end)) as kol,a.cena,a.type_tov,Sum(case when a.kol<0 then -a.sumskd else a.sumskd end) as sumskd,a.kassa_num,case when Sum(kol)<0 then -1 else 1 end as IsBack ');
     Qr1.SQL.Add('from ArhCheks a (nolock) ');
     Qr1.SQL.Add('      left join ');
     Qr1.SQL.Add('     SprTov b (nolock) on a.kod_name=b.kod_name ');
     Qr1.SQL.Add('where a.id_kassa=@idk and ');
     Qr1.SQL.Add('      a.vzh=@vzh and ');
     Qr1.SQL.Add('      a.date_chek=(select Max(date_chek) from  ArhCheks aa (nolock) where aa.id_kassa=@idk and vzh=@vzh) ');
     Qr1.SQL.Add('group by IsNull(b.art_code,a.kod_name),a.numb_chek,IsNull(b.names,a.names),a.cena,a.type_tov,a.kassa_num ');
     Qr1.SQL.Add('order by 2 ');
}
{
     Qr1.SQL.Add('select b.art_code,b.names,a.numb_chek,Sum(Abs(a.kol)) as kol,a.cena,a.type_tov,Sum(Abs(a.sumskd)) as sumskd,a.kassa_num,case when Sum(kol)<0 then -1 else 1 end as IsBack  ');
     Qr1.SQL.Add('from ArhCheks a (nolock), ');
     Qr1.SQL.Add('     SprTov b (nolock)');
     Qr1.SQL.Add('where a.kod_name=b.kod_name and');
     Qr1.SQL.Add('      a.id_kassa=@idk and ');
     Qr1.SQL.Add('      a.vzh=@vzh and ');
     Qr1.SQL.Add('      a.date_chek=(select Max(date_chek) from  ArhCheks aa (nolock) where aa.id_kassa=@idk and vzh=@vzh) ');
     Qr1.SQL.Add('group by b.art_code,a.numb_chek,b.names,a.cena,a.type_tov,a.kassa_num');
     Qr1.SQL.Add('order by b.names');
}

//     Qr1.SQL.SaveToFile('C:\Log\NCh_.txt');

     Qr1.Open;

     FCopy_Chek:=Qr1.FieldByName('Numb_chek').AsInteger;

     if Qr1.FieldByName('IsBack').AsInteger=-1 then
      if Not fpSetBackReceipt(IntToStr(FCopy_Chek)) then raise Eabort.Create(FLastError);

     if Not fpOpenFiscalReceipt then raise Eabort.Create(FLastError);
     SumChek:=0;
     for i:=1 to Qr1.RecordCount do
      begin
       if i=1 then Qr1.First else Qr1.Next;
       if Qr1.FieldByName('IsBack').AsInteger=-1 then Art:=99999 else Art:=0;
       if Qr1.FieldByName('type_tov').AsInteger=1 then Nds:=2 else Nds:=1;

       if Not fpAddSale(
                        Qr1.FieldByName('art_code').AsString+' '+Qr1.FieldByName('Names').AsString,
                        Qr1.FieldByName('Kol').AsInteger,
                        Qr1.FieldByName('Cena').AsCurrency,
                        1,
                        Art,
                        Nds,
                        -Qr1.FieldByName('SumSkd').AsCurrency,
                        ''
                       ) then raise Eabort.Create(FLastError);
       SumChek:=SumChek+Qr1.FieldByName('Kol').AsInteger*Qr1.FieldByName('Cena').AsCurrency-Qr1.FieldByName('SumSkd').AsCurrency;
      end;

     Case Qr1.FieldByName('kassa_num').AsInteger of
      1,3:Ty:=4;
      2,4:Ty:=2;
     end;

     if Qr1.FieldByName('Bezgot1').AsCurrency>0 then
      begin
       if Not fpCloseFiscalReceipt(SumChek-Qr1.FieldByName('Bezgot1').AsCurrency,Ty,SumChek,Qr1.FieldByName('Bezgot1').AsCurrency,False) then raise Eabort.Create(FLastError);
      end else
       if Not fpCloseFiscalReceipt(SumChek,Ty,SumChek) then raise Eabort.Create(FLastError);

     Result:=True;
     Exit;
    except
     on E:Exception do
      begin
       FLastError:='������ ������ ����� ����: '+E.Message;
       Result:=False;
       Exit;
      end;
    end;
   finally
    FCopy_Chek:=-1;
    FIsCopy:=False;
   end;

  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpCheckCopy;
   EKKA_DATECS3530T:begin
                     Result:=ReConnect; if Not Result then Exit;
                     Result:=(MakeReceiptCopy(0,PrinterResults,0,'1')=0) and (FLastError='');
                    end;
   EKKA_EXELLIO:begin
                 Result:=ReConnect; if Not Result then Exit;
                 if Cnt>2 then Cnt:=2;
                 FP.MakeReceiptCopy(Cnt);
                 Result:=CheckErrorExellio;
                end;
   EKKA_FP2000:begin
                 Result:=ReConnect; if Not Result then Exit;
                 if Cnt>2 then Cnt:=2;
                 FP.PrintCheckCopy(Cnt);
                 Result:=CheckErrorExellio;
                end;
  end;
 end;

function TEKKA.fpServiceText(TextPos,Print2,FontHeight:Integer; S:String):Boolean;
var CA,P:Integer;

 begin

  if EmulEKKA then
   try

//    bPrintHead;

//    MrFont.AddStr(S,FontHeight);

//    bPrintFooter(4);

    CA:=High(sArr)+1;
    SetLength(sArr,CA+1);
    sArr[CA].S:=S;
    sArr[CA].F:=FontHeight;

    Result:=True;
    Exit;
   except
    on E:Exception do
     begin
      FLastError:='������ ������ ��������� ������: '+E.Message;
      Result:=False;
      Exit;
     end;
   end;

  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpServiceText(TextPos,Print2,FontHeight,S);
   EKKA_DATECS3530T:begin
                     Result:=ReConnect; if Not Result then Exit;
                     Result:=(PrintFiscalText(0,PrinterResults,0,PAnsiChar(S))=0) and (FLastError='');
                    end;
   EKKA_EXELLIO:begin
                 Result:=ReConnect; if Not Result then Exit;
                 FP.PrintFiscalText(Copy(S,1,36));
                 Result:=CheckErrorExellio;
                end;
   EKKA_FP2000:begin
                 Result:=ReConnect; if Not Result then Exit;
                 if S='' then S:=' ';
                 FP.AddFiscalText(Copy(S,1,42));
                 Result:=CheckErrorExellio;
                end;
  end;
 end;


function TEKKA.fpCashInput(C:Currency):Boolean;
 begin

  if EmulEKKA then
   try

    GetInfo;

    bPrintHead;

    MrFont.AddStrC('��������� ��������',1);
    MrFont.AddStrC('� 12',1);
    MrFont.AddStrC('������:  '+Kassir,0);
    MrFont.AddStrC('�������� ��������',1);
    MrFont.AddStr2J('���i����',CurrToStrF_(C),0);
    FDtChek:=Now;
    QrEx.Close;
    QrEx.SQL.Clear;
//    QrEx.SQL.Add('declare @P tinyint');
//    QrEx.SQL.Add('set @P='+IntToStr(P));
//    QrEx.SQL.Add('if (@P=0) /* or (@P=1 and getdate()>''2016-05-01'') */ ');
    QrEx.SQL.Add(' insert into CashOutPutLog(Dt,Summa,vzh,id_kassa,Cash,IsPrint,InOut,TypeO)');
    QrEx.SQL.Add(' values('''+FormatDateTime('yyyy-mm-dd hh:nn:ss',FDtChek)+''','+CurrToStrF(C,ffFixed,2)+','+IntToStr(VzhNum)+','+IntToStr(KassaID)+','+CurrToStrF(Qr.FieldByName('Sum6').AsCurrency-C,ffFixed,2)+',1,1,0)');
    QrEx.SQL.Add('select 999 as Res');
    QrEx.Open;

    bPrintFooter(4);
    Result:=True;
    Exit;
   except
    on E:Exception do
     begin
      bPrintFooter(2);
      FLastError:='������ �������� �������� �������: '+E.Message;
      Result:=False;
      Exit;
     end;
   end;

  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpCashInput(C);
   EKKA_DATECS3530T:begin
                     Result:=ReConnect; if Not Result then Exit;
                     Result:=(ServiceInputOutput(0,PrinterResults,0,Abs(C))=0) and (FLastError='');
                    end;
   EKKA_EXELLIO:begin
                 Result:=ReConnect; if Not Result then Exit;
                 FP.InOut(Abs(C));

                 Result:=CheckErrorExellio;
                end;
   EKKA_FP2000:begin
                Result:=ReConnect; if Not Result then Exit;
                FP.CashInput(Abs(C));
                Result:=CheckErrorExellio;
               end;
  end;
 end;

function TEKKA.fpCashOutput(C:Currency; P:Byte=0):Boolean;
 begin

  if EmulEKKA then
   try

    GetInfo;

    if C>Qr.FieldByName('Sum6').AsCurrency then raise EAbort.Create('����� ������� ��������� ����� ������� �������� �������.');

    bPrintHead;

    MrFont.AddStrC('��������� ��������',1);
    MrFont.AddStrC('� 12',1);
    MrFont.AddStrC('������:  '+Kassir,0);
    MrFont.AddStrC('�������� ���������',1);
    MrFont.AddStr2J('���i����',CurrToStrF_(C),0);
    FDtChek:=Now;
    QrEx.Close;
    QrEx.SQL.Clear;
//    QrEx.SQL.Add('declare @P tinyint');
//    QrEx.SQL.Add('set @P='+IntToStr(P));
//    QrEx.SQL.Add('if (@P=0) /* or (@P=1 and getdate()>''2016-05-01'') */ ');
    QrEx.SQL.Add(' insert into CashOutPutLog(Dt,Summa,vzh,id_kassa,Cash,IsPrint,InOut,TypeO)');
    QrEx.SQL.Add(' values('''+FormatDateTime('yyyy-mm-dd hh:nn:ss',FDtChek)+''','+CurrToStrF(C,ffFixed,2)+','+IntToStr(VzhNum)+','+IntToStr(KassaID)+','+CurrToStrF(Qr.FieldByName('Sum6').AsCurrency-C,ffFixed,2)+',1,-1,'+IntToStr(P)+')');
    QrEx.SQL.Add(' select 999 as Res');
    QrEx.Open;

    bPrintFooter(4);
    Result:=True;
    Exit;
   except
    on E:Exception do
     begin
      bPrintFooter(2);
      FLastError:='������ ������� �������� �������: '+E.Message;
      RegError(QrEx,'������ ������� �������� �������',E.Message);
      Result:=False;
      Exit;
     end;
   end;

  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpCashOutput(C);
   EKKA_DATECS3530T:begin
                     Result:=ReConnect; if Not Result then Exit;
                     Result:=(ServiceInputOutput(0,PrinterResults,0,-Abs(C))=0) and (FLastError='');
                    end;
   EKKA_EXELLIO:begin
                 Result:=ReConnect; if Not Result then Exit;
                 FP.InOut(-Abs(C));
                 Result:=CheckErrorExellio;
                end;
   EKKA_FP2000:begin
                Result:=ReConnect; if Not Result then Exit;
                FP.CashOutput(Abs(C));
                Result:=CheckErrorExellio;
               end;
  end;
 end;

function TEKKA.fpActiveLogo(P:Byte):Boolean;
var B:Boolean;
 begin
  if (Not (UseEKKA) or (EmulEKKA=True)) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpActiveLogo(P);
   EKKA_DATECS3530T:begin
                     if Not (P in [0,1]) then begin FLastError:='ERP_9992'; Exit; end;
                     Result:=ReConnect; if Not Result then Exit;
                     Result:=(SetHeaderFooter(0,PrinterResults,0,1,PAnsiChar(IntToStr(P)[1]))=0) and (FLastError='');
                     ShowMessage(FLastError);
                    end;
   EKKA_EXELLIO:begin
                 Result:=ReConnect; if Not Result then Exit;
                 if P=0 then B:=False else B:=True;
                 FP.EnableLogo(B);
                 Result:=CheckErrorExellio;
                end;
   EKKA_FP2000:begin
                 Result:=ReConnect; if Not Result then Exit;
                 if P=0 then B:=False else B:=True;
                 FP.SetPrintSettingPrintLogo(B);
                 Result:=CheckErrorExellio;
                end;
  end;
 end;

function TEKKA.GetNewServiceNumbChek:Integer;
 begin
  Qr.Close;
  Qr.SQL.Text:='spY_GetNewServiceNumbChek '+IntToStr(KassaID);
  Qr.Open;
  Result:=Qr.FieldByName('NCh').AsInteger;
 end;

function TEKKA.fpZeroCheck:Boolean;
 begin

  if EmulEKKA then
   try

    bPrintHead;
    MrFont.AddStrC('��������� ��������',1);

    MrFont.AddStrC('� '+IntToStr(GetNewServiceNumbChek)+' (����)',1);
    MrFont.AddStrC('������:  '+Kassir,0);
    MrFont.AddStr(' ',0);
    MrFont.AddStrC('�������� ���',1);
    MrFont.AddStr(' ',0);
    MrFont.AddStrC('����  0,00',1);
    MrFont.AddStr(' ',0);
    FDtChek:=Now;
    bPrintFooter(4);

    Result:=True;
    Exit;
   except
    on E:Exception do
     begin
      FLastError:='������ ������ �������� ����: '+E.Message;
      Result:=False;
      Exit;
     end;
   end;

  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpZeroCheck;
   EKKA_DATECS3530T:begin
                     Result:=ReConnect; if Not Result then Exit;
                     Result:=fpCancelFiscalReceipt;
                     if Not Result then Exit;
                     Result:=fpOpenFiscalReceipt;
                     if Not Result then Exit;
                     Result:=fpCloseFiscalReceipt(0,4);
                    end;
   EKKA_EXELLIO:begin
                 Result:=ReConnect; if Not Result then Exit;
                 FP.PrintNullCheck;
                 Result:=CheckErrorExellio;
                end;
   EKKA_FP2000:begin
                Result:=ReConnect; if Not Result then Exit;
                Result:=fpCancelFiscalReceipt;
                if Not Result then Exit;
                Result:=fpOpenFiscalReceipt;
                if Not Result then Exit;
                Result:=fpCloseFiscalReceipt(0,4);
               end;
  end;
 end;

procedure TEKKA.fpSendToEKV;
var NumPak:Integer;
 begin
  if EmulEKKA then
   try
    Qr.Close;
    Qr.SQL.Clear;
    Qr.SQL.Add('declare @np int ');
    Qr.SQL.Add('set @np=IsNull((select top 1 Value from Spr_Const where Descr=''NumPak'+IntToStr(KassaID)+'''),0) ');
    Qr.SQL.Add('delete from Spr_const where Descr=''NumPak'+IntToStr(KassaID)+'''' );
    Qr.SQL.Add('insert into Spr_const(Descr,Value) values(''NumPak'+IntToStr(KassaID)+''',convert(varchar,@np+10)) ' );
    Qr.SQL.Add('select @np as NumPak');
    Qr.Open;
    NumPak:=Qr.FieldByName('NumPak').AsInteger;

    bPrintHead;
    MrFont.AddStrC('��������� ��������',1);

    MrFont.AddStrC('� '+IntToStr(GetNewServiceNumbChek)+' (����)',1);
    MrFont.AddStrC('������:  '+Kassir,0);
    MrFont.AddStrC('�������i�',1);
    MrFont.AddStrC('�i�����������',1);
    MrFont.AddStr(' ',0);

    MrFont.AddStrC('������ ������',1);
    MrFont.AddStr('������: '+IntToStrF(NumPak,10)+'-'+IntToStrF(NumPak+9,10),0);
    MrFont.AddStrC('�������� �������',1);
    FDtChek:=Now;
    MrFont.AddStr('����/���: '+DateTimeToStrSlash(FDtChek),0);
    bPrintFooter(4);

    Exit;
   except
    on E:Exception do
     begin
      FLastError:='������ ������ ���������: '+E.Message;
      Exit;
     end;
   end;
 end;

function TEKKA.fpPerFullRepD(D1,D2:TDateTime):Boolean;
var N1,N2:Integer;
 begin

  if EmulEKKA then
   try

    Qr.Close;
    Qr.SQL.Text:='exec spY_GetEKKAInfoRepD_ '+IntToStr(KassaID)+','''+FormatDateTime('yyyy-mm-dd',D1)+''','''+FormatDateTime('yyyy-mm-dd hh:nn:ss',D2)+'''';
    Qr.Open;

    fpPerFullRepN(Qr.FieldByName('NumZ1').AsInteger,Qr.FieldByName('NumZ2').AsInteger);
   except
    on E:Exception do
     begin
      FLastError:=E.Message;
      Result:=False;
      Exit;
     end;
   end;

  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpPerFullRepD(D1,D2);
   EKKA_DATECS3530T:begin
                     Result:=ReConnect; if Not Result then Exit;
                     Result:=(PrintReportByDate(0,PrinterResults,0,PAnsiChar(Passw[15]),PAnsiChar(FormatDateTime('ddmmyy',D1)),PAnsiChar(FormatDateTime('ddmmyy',D2)))=0) and (FLastError='');
                    end;
   EKKA_EXELLIO:begin
                 Result:=ReConnect; if Not Result then Exit;
                 FP.PrintRepByDate('0000',FormatDateTime('ddmmyy',D1),FormatDateTime('ddmmyy',D2));
                 Result:=CheckErrorExellio;
                end;
   EKKA_FP2000:begin
                 Result:=ReConnect; if Not Result then Exit;
                 FP.PeriodicReport(D1, D2);
                 Result:=CheckErrorExellio;
                end;
  end;
 end;

function TEKKA.fpPerFullRepN(N1,N2:Integer):Boolean;

var i,MinNumZ,MaxNumZ:Integer;
    DtWriteZ,MinDateZ,MaxDateZ:TDateTime;

 begin

  if EmulEKKA then
   try

    Qr.Close;
    Qr.SQL.Clear;
    Qr.SQL.Add('select top 1 DateZ,NumZ ');
    Qr.SQL.Add('from JournZ (nolock) ');
    Qr.SQL.Add('where id_kassa='+IntToStr(KassaID)+' and vzh='+IntToStr(VzhNum)+' and ');
    Qr.SQL.Add('      NumZ>='+IntToStr(N1));
    Qr.SQL.Add('order by NumZ     ');
    Qr.Open;

    MinDateZ:=Qr.FieldByName('DateZ').AsDateTime;
    MinNumZ:=Qr.FieldByName('NumZ').AsInteger;

    Qr.Close;
    Qr.SQL.Clear;
    Qr.SQL.Add('select top 1 DateZ,NumZ ');
    Qr.SQL.Add('from JournZ (nolock) ');
    Qr.SQL.Add('where id_kassa='+IntToStr(KassaID)+' and vzh='+IntToStr(VzhNum)+' and ');
    Qr.SQL.Add('      NumZ<='+IntToStr(N2));
    Qr.SQL.Add('order by NumZ desc    ');
    Qr.Open;

    MaxDateZ:=Qr.FieldByName('DateZ').AsDateTime;
    MaxNumZ:=Qr.FieldByName('NumZ').AsInteger;

    Qr1.Close;
    Qr1.SQL.Text:=' exec spY_GetEKKAInfoRepN '+IntToStr(KassaID)+','+IntToStr(MinNumZ)+','+IntToStr(MaxNumZ);
    Qr1.Open;

    Qr.Close;
    Qr.SQL.Text:='exec spY_GetEKKAInfoRepN_ '+IntToStr(KassaID)+','+IntToStr(MinNumZ)+','+IntToStr(MaxNumZ);
    Qr.Open;

    bPrintHead;

    MrFont.AddStrC('���i������� ��i�',1);
    MrFont.AddStrC('������',1);

    MrFont.AddStrC('� � '+IntToStrF(MinNumZ,4)+' '+DateToStrSlash(MinDateZ),1);
    MrFont.AddStrC(IntToStrF(MaxNumZ,4)+' '+DateToStrSlash(MaxDateZ),1);

    {****************************************************************************}

    FDtChek:=Now;
    DtWriteZ:=Qr.FieldByName('DtRep').AsDateTime;
    MrFont.AddStr(' ����� �� �� ��������    '+DateTimeToStrSlash(DtWriteZ),0);


    MrFont.AddStr(' ������i� �i�������� ��� '+DateTimeToStrSlash(Qr.FieldByName('DtLastChek').AsDateTime),0);
    MrFont.AddStr(' ��i�� �i������          '+DateTimeToStrSlash(Qr.FieldByName('DtOpenSmena').AsDateTime),0);

    MrFont.AddStrC('������ ��i�� (���)',0);

    MrFont.AddStr('�� '+FsZN+'    �i� 11/02/14',0);
    MrFont.AddStr('�� '+FsFN+'      �i� 31/10/14',0);
    MrFont.AddStr(' - - - - - - - - - - - - - - - - - - - -',0);
    MrFont.AddStrC('- - ����i���i� - -',1);


    MrFont.AddStr('���                 *� 20.00%',0);
    MrFont.AddStrC('䳺 � 31/10/14, � �Z 0001',0);
    MrFont.AddStr2J('���� �������������',CurrToStrF_(Qr.FieldByName('SumA').AsCurrency),0);
    MrFont.AddStr2J('����� ������� �i� ����',CurrToStrF_(Qr.FieldByName('Sum_nAb').AsCurrency),0);
    MrFont.AddStr2J('����� ������� �� �����',CurrToStrF_(Qr.FieldByName('Sum_nA').AsCurrency),0);

    MrFont.AddStr('                    *� 7.00%',0);
    MrFont.AddStrC('䳺 � 31/10/14, � �Z 0001',0);
    MrFont.AddStr2J('���� �������������',CurrToStrF_(Qr.FieldByName('SumB').AsCurrency),0);
    MrFont.AddStr2J('����� ������� �i� ����',CurrToStrF_(Qr.FieldByName('Sum_nBb').AsCurrency),0);
    MrFont.AddStr2J('����� ������� �� �����',CurrToStrF_(Qr.FieldByName('Sum_nB').AsCurrency),0);

    MrFont.AddStrC('- - - - - - - - - -',0);
    MrFont.AddStr2J('������� �� ���������.','0,00',0);
    MrFont.AddStrC('- - - - - - - - - -',0);
    MrFont.AddStr2J('�� � ��''����� ���������.','0,00',0);
    MrFont.AddStrC('- - - - - - - - - -',0);

    MrFont.AddStr2J('��������� ������',CurrToStrF_(Qr.FieldByName('Sum4').AsCurrency+Qr.FieldByName('Sum7').AsCurrency),0);
    MrFont.AddStrC('- - - - - - - - - -',0);

    MrFont.AddStrC('�������� �i� ��i���� �� ������ ������',0);
    MrFont.AddStr2J('������',CurrToStrF_(Qr.FieldByName('Sum4').AsCurrency),0);
    MrFont.AddStr2J('�����������.2',CurrToStrF_(Qr.FieldByName('Sum7').AsCurrency),0);
    MrFont.AddStr2J('������� ����',Qr.FieldByName('CntCheks').AsString,0);

              // ���� ���� �������� �� ����������
    if (Qr.FieldByName('Sum5').AsCurrency>0) or (Qr.FieldByName('Sum5').AsCurrency>0) then
     begin
      MrFont.AddStr(' - - - - - - - - - - - - - - - - - - - -',0);
      MrFont.AddStrC('- - ���������� - -',1);
      MrFont.AddStr('���                 *� 20.00%',0);
      MrFont.AddStrC('䳺 � 31/10/14, � �Z 0001',0);
      MrFont.AddStr2J('���� �������������',CurrToStrF_(Qr.FieldByName('SumBA').AsCurrency),0);
      MrFont.AddStr2J('����� ������� �i� ����',CurrToStrF_(Qr.FieldByName('Sum_nBAb').AsCurrency),0);
      MrFont.AddStr2J('����� ������� �� �����',CurrToStrF_(Qr.FieldByName('Sum_nBA').AsCurrency),0);

      MrFont.AddStr('                    *� 7.00%',0);
      MrFont.AddStrC('䳺 � 31/10/14, � �Z 0001',0);
      MrFont.AddStr2J('���� �������������',CurrToStrF_(Qr.FieldByName('SumBB').AsCurrency),0);
      MrFont.AddStr2J('����� ������� �i� ����',CurrToStrF_(Qr.FieldByName('Sum_nBBb').AsCurrency),0);
      MrFont.AddStr2J('����� ������� �� �����',CurrToStrF_(Qr.FieldByName('Sum_nBB').AsCurrency),0);

      MrFont.AddStrC('- - - - - - - - - -',0);
      MrFont.AddStr2J('������� �� ���������.','0,00',0);
      MrFont.AddStrC('- - - - - - - - - -',0);
      MrFont.AddStr2J('�� � ��''����� ���������.','0,00',0);
      MrFont.AddStrC('- - - - - - - - - -',0);

      MrFont.AddStr2J('��������� ������',CurrToStrF_(Qr.FieldByName('Sum5').AsCurrency+Qr.FieldByName('Sum8').AsCurrency),0);
      MrFont.AddStrC('- - - - - - - - - -',0);

      MrFont.AddStrC('��������� ��i����� �� ������ ������',0);
      MrFont.AddStr2J('������',CurrToStrF_(Qr.FieldByName('Sum5').AsCurrency),0);
      MrFont.AddStr2J('�����������.2',CurrToStrF_(Qr.FieldByName('Sum8').AsCurrency),0);
      MrFont.AddStr2J('������� ����',Qr.FieldByName('CntCheksB').AsString,0);
     end;
    MrFont.AddStrC(' - - - - - - - - - -',1);


    MrFont.AddStrC('- - - - - - ������� ����� � ��� - - - -',0);
    MrFont.AddStr2J('���������� �������',CurrToStrF_(Qr.FieldByName('Sum1').AsCurrency),0);
    MrFont.AddStr2J('������� �������',  CurrToStrF_(Qr.FieldByName('Sum6').AsCurrency),0);
    MrFont.AddStrC('- - - - - - - - - ������� - - - - - - -',0);

    MrFont.AddStr2J('������',   CurrToStrF_(Qr.FieldByName('Sum4').AsCurrency-Qr.FieldByName('Sum5').AsCurrency),0);
    MrFont.AddStr2J('�����������',CurrToStrF_(Qr.FieldByName('Sum7').AsCurrency-Qr.FieldByName('Sum8').AsCurrency),0);

    MrFont.AddStrC('- - - - - - - - - - - - - - - - - - - -',0);
    MrFont.AddStr2J('����� ���������� ����',Qr.FieldByName('NLastChek').AsString,0);

   { -------------------------------------------------------------------------- }
    MrFont.AddStrC('- - - - -  �i������ �� Z-��i���  - - - - ',0);

    for i:=1 to Qr1.RecordCount do
     begin
      if i=1 then Qr1.First else Qr1.Next;
      MrFont.AddStr2J(IntToStrF(Qr1.FieldByName('NumZ').AsInteger,4)+' '+DateToStrSlash(Qr1.FieldByName('DateZ').AsDateTime),CurrToStrF_(Qr1.FieldByName('SumZ').AsCurrency),0);
     end;

    MrFont.AddStrC('- - - -  ����i��i ��������� ��  - - - - ',0);
    MrFont.AddStrC('����i���� �������� �� �� ����',0);

    bPrintFooter(10);

    Result:=True;
    Exit;
   except
    on E:Exception do
     begin
      FLastError:='������ ������ ������: '+E.Message;
      Result:=False;
      Exit;
     end;
   end;

  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpPerFullRepN(N1,N2);
   EKKA_DATECS3530T:begin
                     Result:=ReConnect; if Not Result then Exit;
                     Result:=(PrintReportByNum(0,PrinterResults,0,PAnsiChar(Passw[15]),N1,N2)=0) and (FLastError='');
                    end;
   EKKA_EXELLIO:begin
                 Result:=ReConnect; if Not Result then Exit;
                 FP.PrintRepByNum('0000',N1,N1);
                 Result:=CheckErrorExellio;
                end;
   EKKA_FP2000:begin
                 Result:=ReConnect; if Not Result then Exit;
                 FP.PeriodicReportN(N1,N2);
                 Result:=CheckErrorExellio;
                end;
  end;
 end;

function TEKKA.fpPerShortRepD(D1,D2:TDateTime):Boolean;
 begin
  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpPerShortRepD(D1,D2);
   EKKA_DATECS3530T:begin
                     Result:=ReConnect; if Not Result then Exit;
                    end;
   EKKA_EXELLIO:begin
                 Result:=ReConnect; if Not Result then Exit;
                 FP.PrintRepByDate('0000',FormatDateTime('ddmmyy',D1),FormatDateTime('ddmmyy',D2));
                 Result:=CheckErrorExellio;
                end;
   EKKA_FP2000:begin
                 Result:=ReConnect; if Not Result then Exit;
                 FP.PeriodicReport(D1, D2);
                 Result:=CheckErrorExellio;
                end;
  end;
 end;

function TEKKA.fpPerShortRepN(N1,N2:Integer):Boolean;
 begin
  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpPerShortRepN(N1,N2);
   EKKA_DATECS3530T:begin
                     Result:=ReConnect; if Not Result then Exit;
                    end;
   EKKA_EXELLIO:begin
                 Result:=ReConnect; if Not Result then Exit;
                 FP.PrintRepByNum('0000',N1,N1);
                 Result:=CheckErrorExellio;
                end;
   EKKA_FP2000:begin
                 Result:=ReConnect; if Not Result then Exit;
                 FP.PeriodicReportN(N1,N2);
                 Result:=CheckErrorExellio;
                end;
  end;
 end;

function TEKKA.fpCutBeep(C, B, N: Byte): Boolean;
 begin
  if (UseEKKA=False) or (FLastError='') then begin Result:=True; Exit; end;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpCutBeep(C,B,N);
   EKKA_DATECS3530T:Result:=True;
   EKKA_EXELLIO:begin
                 Result:=ReConnect; if Not Result then Exit;
                 Result:=FP.EnableCutCheck(C=1);
                 Result:=CheckErrorExellio;
                end;
   EKKA_FP2000:begin
                 Result:=ReConnect; if Not Result then Exit;
                 Result:=FP.SetPrintSettingAutoCutting(C=1);
                 Result:=CheckErrorExellio;
                end;
  end;

 end;

function TEKKA.fpStrToDisp(S:String):Boolean;
 begin
  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpStrToDisp(S);
   EKKA_DATECS3530T:begin
                     Result:=True;
                    end;
  end;
 end;

function TEKKA.fpCurrToDisp(S:Currency):Boolean;
 begin
  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpCurrToDisp(S);
   EKKA_DATECS3530T:begin
                     Result:=True;
                    end;
  end;
 end;

function TEKKA.fpDisplayText(S:String; L:Byte):Boolean;
 begin
  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  if TypeEKKA=EKKA_EXELLIO then
   begin
    Result:=ReConnect; if Not Result then Exit;
    if L<=1 then FP.DisplayTextLL(Copy(S,1,20))
            else FP.DisplayTextUL(Copy(S,1,20));
    Result:=CheckErrorExellio;
   end
  else if TypeEKKA=EKKA_FP2000 then
   begin
    Result:=ReConnect; if Not Result then Exit;
    if L<=1 then FP.DisplayPrintLine1(Copy(S,1,20))
            else FP.DisplayPrintLine2(Copy(S,1,20));
    Result:=CheckErrorExellio;
   end
  else Result:=True;
 end;

procedure TEKKA.SetTypeEKKA(const Value:Byte);
 begin
  FTypeEKKA:=Value;
  Case TypeEKKA of
   EKKA_MARRY301MTM:FArtFile:=PrPath+'\$Marry301$.txt';
   EKKA_DATECS3530T:FArtFile:=PrPath+'\$Datecs3530T$.txt';
  end;
 end;

function TEKKA.fpCashState(P:Integer):Boolean;
var ri:TStringList;
    i:Integer;
    A:Array[0..7] of Currency;
    Res:Variant;
    CashSum, CreditSum, DebitSum, CheckSum, SumReturnTax1, SumReturnTax2: double;

 begin

  if EmulEKKA then
   try
    GetInfo;
    FRD_Item.Clear;
    for i:=1 to 8 do
     FRD_Item.Add(IntToStr(Abs(Round(Qr.FieldByName('Sum'+IntToStr(i)).AsCurrency*100))));
    Result:=True;
    Exit;
   except
    on E:Exception do
     begin
      FLastError:='������ ������ X-������: '+E.Message;
      Result:=False;
      Exit;
     end;
   end;

  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpCashState(P);
   EKKA_DATECS3530T:begin
                     Result:=ReConnect; if Not Result then Exit;
                     Result:=(ServiceInputOutput(0,PrinterResults,0,0)=0) and (FLastError='');
                     if Not Result then Exit;
                     try
                      ri:=TStringList.Create;
                      try
                       for i:=Low(A) to High(A) do A[i]:=0;
                       if P<>0 then Exit;
                       A[1]:=StrToInt64(FRD_Item[1])*0.01;
                       A[2]:=StrToInt64(FRD_Item[2])*0.01;
                       A[5]:=StrToInt64(FRD_Item[0])*0.01;

                       Result:=(DayInfo(0,PrinterResults,0)=0) and (FLastError='');
                       if Not Result then Exit;
                       A[3]:=StrToCurr(FRD_Item[0]);
                       A[6]:=StrToCurr(FRD_Item[2])+StrToCurr(FRD_Item[3])+StrToCurr(FRD_Item[1]);

                       Result:=(GetCurrentTaxes(0,PrinterResults,0,1)=0) and (FLastError='');
                       if Not Result then Exit;
                       A[4]:=GetSumm;

                       ri.Clear;
                       for i:=Low(A) to High(A) do ri.Add(IntToStr(Round(A[i]*100)));
                       FRD_Item.Text:=ri.Text;
                      finally
                       ri.Free;
                      end;
                     except
                      Result:=False;
                      if FLastError='' then FLastError:='ERP_9995';
                     end;
                    end;
   EKKA_EXELLIO:begin
                 Result:=ReConnect; if Not Result then Exit;
                 try
                  ri:=TStringList.Create;
                  try
                   for i:=Low(A) to High(A) do A[i]:=0;

                   FP.InOut(0);
                   if Not CheckErrorExellio then Abort;
                   A[0]:=0;
                   A[1]:=StrToInt64(FP.s3)*0.01;
                   A[2]:=StrToInt64(FP.s4)*0.01;
                   A[5]:=StrToInt64(FP.s2)*0.01;

                   FP.GetDayInfo;
                   if Not CheckErrorExellio then Abort;
                   A[3]:=StrToInt64(FP.s1)*0.01;
                   A[6]:=StrToInt64(FP.s2)*0.01+StrToInt64(FP.s3)*0.01+StrToInt64(FP.s4)*0.01;

                   FP.GetCurrentSums(1);
                   if Not CheckErrorExellio then Abort;

                   A[4]:=StrToInt64(FP.s1)*0.01+StrToInt64(FP.s2)*0.01;

                   ri.Clear;
                   for i:=Low(A) to High(A) do ri.Add(IntToStr(Round(A[i]*100)));
                   FRD_Item.Text:=ri.Text;
                   FLastError:='';
                  finally
                   ri.Free;
                  end;
                 except
                  for i:=Low(A) to High(A) do A[i]:=0; FRD_Item.Text:=ri.Text;
                  Result:=False;
                  if FLastError='' then FLastError:='ERP_9995';
                 end;
                end;
  EKKA_FP2000:begin
                 Result:=ReConnect; if Not Result then Exit;
                 try
                  ri:=TStringList.Create;
                  try
                   for i:=Low(A) to High(A) do A[i]:=0;

                   Res:=FP.GetCashDeskInfo;
                   if Not CheckErrorExellio then Abort;
                   A[0]:=0;
                   A[1]:=Res.InputSum;
                   A[2]:=Res.OutputSum;
                   A[5]:=Res.CashSum;

                   Res:=FP.GetDayPaySumsInfo;
                   if Not CheckErrorExellio then Abort;
                   CashSum:=Res.CashSum;
                   CreditSum:=Res.CreditSum;
                   DebitSum:=Res.DebitSum;
                   CheckSum:=Res.CheckSum;
                   A[3]:=CashSum;

                   A[6]:=CreditSum+DebitSum+CheckSum;

                   Res:=FP.GetDayFiscalSums;
                   if Not CheckErrorExellio then Abort;
                   SumReturnTax1:=Res.SumReturnTax1;
                   SumReturnTax2:=Res.SumReturnTax2;
                   A[4]:=SumReturnTax1+SumReturnTax2;

                   ri.Clear;
                   for i:=Low(A) to High(A) do ri.Add(IntToStr(Round(A[i]*100)));
                   FRD_Item.Text:=ri.Text;
                   FLastError:='';

                  finally
                   ri.Free;
                  end;
                 except
                  for i:=Low(A) to High(A) do A[i]:=0; FRD_Item.Text:=ri.Text;
                  Result:=False;
                  if FLastError='' then FLastError:='ERP_9995';
                 end;
                end;

  end;
 End;

function TEKKA.fpFiscState:Boolean;
var A:Array[1..20] of Currency;
    j,i:Integer;
    Sum:Currency;
    ri:TStringList;
    Res:Variant;
    SumRealizTax1, SumRealizTax2, SumRealizTax3, SumRealizTax4, SumRealizTax5: double;
    SumReturnTax1, SumReturnTax2, SumReturnTax3, SumReturnTax4, SumReturnTax5: double;
 begin
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpFiscState;
   EKKA_DATECS3530T:begin
                     Result:=ReConnect; if Not Result then Exit;
                     try
                      ri:=TStringList.Create;
                      try
                       for i:=Low(A) to High(A) do A[i]:=0;

                       Result:=(GetCurrentTaxes(0,PrinterResults,0,0)=0) and (FLastError='');
                       if Not Result then Exit;

                       Sum:=0;
                       for j:=0 to 4 do
                        begin
                         A[2+j]:=StrToInt64(FRD_Item[j])*0.01;
                         Sum:=Sum+A[1+j];
                        end;
                       A[1]:=Sum;

                       Result:=(GetCurrentTaxes(0,PrinterResults,0,1)=0) and (FLastError='');
                       Sum:=0;
                       if Not Result then Exit;
                       for j:=0 to 4 do
                        begin
                         A[12+j]:=StrToInt64(FRD_Item[j])*0.01;
                         Sum:=Sum+A[1+j];
                        end;

                       A[11]:=Sum;
                       ri.Clear;
                       for i:=Low(A) to High(A) do ri.Add(IntToStr(Round(A[i]*100)));
                       FRD_Item.Text:=ri.Text;
                       //ShowMessage(ri.Text);
                      finally
                       ri.Free;
                      end;
                     except
                      Result:=False;
                      if FLastError='' then FLastError:='ERP_9995';
                     end;
                    end;
   EKKA_EXELLIO:begin
                 Result:=ReConnect; if Not Result then Exit;
                 try
                 ri:=TStringList.Create;
                 try
                  for i:=Low(A) to High(A) do A[i]:=0;

                  FP.GetCurrentSums(0);
                  if Not CheckErrorExellio then Abort;

                  Sum:=StrToInt64(FP.s1)*0.01;
                  Sum:=Sum+StrToInt64(FP.s2)*0.01;
                  Sum:=Sum+StrToInt64(FP.s3)*0.01;
                  Sum:=Sum+StrToInt64(FP.s4)*0.01;
                  Sum:=Sum+StrToInt64(FP.s5)*0.01;

                  A[1]:=Sum;
                  A[2]:=StrToInt64(FP.s1)*0.01;
                  A[3]:=StrToInt64(FP.s2)*0.01;
                  A[4]:=StrToInt64(FP.s3)*0.01;
                  A[5]:=StrToInt64(FP.s4)*0.01;
                  A[6]:=StrToInt64(FP.s5)*0.01;

                  A[10]:=StrToInt64(FP.s2)*0.01;

                  FP.GetCurrentSums(1);
                  if Not CheckErrorExellio then Abort;

                  Sum:=StrToInt64(FP.s1)*0.01;
                  Sum:=Sum+StrToInt64(FP.s2)*0.01;
                  Sum:=Sum+StrToInt64(FP.s3)*0.01;
                  Sum:=Sum+StrToInt64(FP.s4)*0.01;
                  Sum:=Sum+StrToInt64(FP.s5)*0.01;

                  A[11]:=Sum;
                  A[12]:=StrToInt64(FP.s1)*0.01;
                  A[13]:=StrToInt64(FP.s2)*0.01;
                  A[14]:=StrToInt64(FP.s3)*0.01;
                  A[15]:=StrToInt64(FP.s4)*0.01;
                  A[16]:=StrToInt64(FP.s5)*0.01;

                  A[20]:=StrToInt64(FP.s2)*0.01;

                  ri.Clear;
                  for i:=Low(A) to High(A) do ri.Add(IntToStr(Round(A[i]*100)));
                  FRD_Item.Text:=ri.Text;
                  FLastError:='';
                       //ShowMessage(ri.Text);
                 finally
                  ri.Free;
                 end;
                except
                 for i:=Low(A) to High(A) do A[i]:=0; FRD_Item.Text:=ri.Text;
                 Result:=False;
                 if FLastError='' then FLastError:='ERP_9995';
                end;
               end;
   EKKA_FP2000:begin
                 Result:=ReConnect; if Not Result then Exit;
                 try
                 ri:=TStringList.Create;
                 try
                  for i:=Low(A) to High(A) do A[i]:=0;

                  Res:=FP.GetDayFiscalSums;
                  if Not CheckErrorExellio then Abort;

                  SumRealizTax1:=Res.SumRealizTax1;
                  SumRealizTax2:=Res.SumRealizTax2;
                  SumRealizTax3:=Res.SumRealizTax3;
                  SumRealizTax4:=Res.SumRealizTax4;
                  SumRealizTax5:=Res.SumRealizTax5;

                  Sum:=SumRealizTax1;
                  Sum:=Sum+SumRealizTax2;
                  Sum:=Sum+SumRealizTax3;
                  Sum:=Sum+SumRealizTax4;
                  Sum:=Sum+SumRealizTax5;

                  A[1]:=Sum;
                  A[2]:=SumRealizTax1;
                  A[3]:=SumRealizTax2;
                  A[4]:=SumRealizTax3;
                  A[5]:=SumRealizTax4;
                  A[6]:=SumRealizTax5;

                  A[10]:=SumRealizTax2;

                  if Not CheckErrorExellio then Abort;

                  Sum:=SumReturnTax1;
                  Sum:=Sum+SumReturnTax2;
                  Sum:=Sum+SumReturnTax3;
                  Sum:=Sum+SumReturnTax4;
                  Sum:=Sum+SumReturnTax5;

                  A[11]:=Sum;
                  A[12]:=SumReturnTax1;
                  A[13]:=SumReturnTax2;
                  A[14]:=SumReturnTax3;
                  A[15]:=SumReturnTax4;
                  A[16]:=SumReturnTax5;

                  A[20]:=SumReturnTax2;

                  ri.Clear;
                  for i:=Low(A) to High(A) do ri.Add(IntToStr(Round(A[i]*100)));
                  FRD_Item.Text:=ri.Text;
                  FLastError:='';
                       //ShowMessage(ri.Text);
                 finally
                  ri.Free;
                 end;
                except
                 for i:=Low(A) to High(A) do A[i]:=0; FRD_Item.Text:=ri.Text;
                 Result:=False;
                 if FLastError='' then FLastError:='ERP_9995';
                end;
               end;
  end;
 end;

function TEKKA.fpSendCommand(var Comm: String): Boolean;
 begin
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpSendCommand(Comm);
   EKKA_DATECS3530T:begin Result:=True; end;
  end;
 end;

function TEKKA.fpAddFinStr(S:String):Boolean;
 begin
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpAddFinStr(S);
   EKKA_DATECS3530T:begin Result:=True; end;
  end;
 end;

function TEKKA.fpSetBottomStr(S:String):Boolean;
 begin
  if EmulEKKA then begin Result:=True; Exit end;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpSetBottomStr(S);
   EKKA_DATECS3530T:begin Result:=True; end;
  end;
 end;

function TEKKA.fpSetBottomStrEx(S:String; N,P,W:Byte):Boolean;
 begin
  if EmulEKKA then begin Result:=True; Exit end;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpSetBottomStrEx(S,N,P,W);
   EKKA_DATECS3530T:begin Result:=True; end;
  end;
 end;

function TEKKA.fpSetINSP(FN,ID,PN,Str1,Str2,Str3,Str4:String):Boolean;
 begin
  if EmulEKKA then begin Result:=True; Exit end;
  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=inherited fpSetINSP(FN,ID,PN,Str1,Str2,Str3,Str4);
   EKKA_DATECS3530T:begin Result:=True; end;
  end;
 end;

function TEKKA.fpSoundEx(Hz,Ms:Integer):Boolean;
 begin
  if TypeEKKA=EKKA_EXELLIO then FP.SoundEx(Hz,Ms);
  if TypeEKKA=EKKA_FP2000 then FP.Sound(Hz,Ms);
 end;

function TEKKA.fpCloseNoFCheck:Boolean;
 begin
  if TypeEKKA=EKKA_EXELLIO then FP.CloseNonfiscalReceipt;
  if TypeEKKA=EKKA_FP2000 then FP.CloseNotFiscalCheck;
 end;

function TEKKA.fpGetOperatorInfo(O:Byte):Boolean;
var SL:TStringList;
    CheckCount, RealizCount, DiscountCount, MarkupCount, VoidCount: Integer;
    UserName: String;
    RealizSum, DiscountSum, MarkupSum, VoidSum:Real;
    Res:Variant;
 begin
  if TypeEKKA=EKKA_EXELLIO then
   begin
    FP.GetOperatorInfo(O);
    SaveRegisters;
   end;
  if TypeEKKA=EKKA_FP2000 then
   begin
    Res:=FP.GetUserInfo(O);
    try
      SL:=TStringList.Create;
      try
        CheckCount:=FP.CheckCount;
        RealizCount:=FP.RealizCount;
        DiscountCount:=FP.DiscountCount;
        MarkupCount:=FP.MarkupCount;
        VoidCount:=FP.VoidCount;
        UserName:=FP.UserName;
        RealizSum:=FP.RealizSum;
        DiscountSum:=FP.DiscountSum;
        MarkupSum:=FP.MarkupSum;
        VoidSum:=FP.VoidSum;

        SL.Clear;
        SL.Add('1 |'+IntToStr(O)+'|');
        SL.Add('2 |'+IntToStr(CheckCount)+'|');
        SL.Add('3 |'+IntToStr(RealizCount)+'|');
        SL.Add('4 |'+FloatToStr(RealizSum)+'|');
        SL.Add('5 |'+IntToStr(DiscountCount)+'|');
        SL.Add('6 |'+FloatToStr(DiscountSum)+'|');
        SL.Add('7 |'+IntToStr(MarkupCount)+'|');
        SL.Add('8 |'+FloatToStr(MarkupSum)+'|');
        SL.Add('9 |'+IntToStr(VoidCount)+'|');
        SL.Add('10|'+FloatToStr(VoidSum)+'|');
        SL.Add('11|'+UserName+'|');
        SL.SaveToFile(PrPath+'\SList.txt');
      finally
        SL.Free;
      end;
      except
    end;
  end;
end;

function TEKKA.fpGetCorectSums:Boolean;
var TotalTurn, NegTotalSum, NotPaidTotalSum: Real;
  Res:Variant;
  SL:TStringList;
 begin
  if TypeEKKA=EKKA_EXELLIO then
   begin
    FP.GetCorectSums;
    SaveRegisters;
   end;
  if TypeEKKA=EKKA_FP2000 then
   begin
    Res:=FP.GetDayFiscalSums;
    try
      SL:=TStringList.Create;
      try
        TotalTurn:=Res.TotalTurn;
        NegTotalSum:=Res.NegTotalSum;
        NotPaidTotalSum:=Res.NotPaidTotalSum;

        SL.Clear;
        SL.Add('1 |'+FloatToStr(TotalTurn)+'|');
        SL.Add('2 |'+FloatToStr(NegTotalSum)+'|');
        SL.Add('3 |'+FloatToStr(NotPaidTotalSum)+'|');
        SL.SaveToFile(PrPath+'\SList.txt');
      finally
        SL.Free;
      end;
      except
      end;
   end;
 end;

function TEKKA.fpGetCheckCopyText:String;
 begin
  if EmulEKKA then Exit;
  if (UseEKKA=False) or (TypeEKKA<>EKKA_FP2000) then begin Result:=''; Exit; end;
  Result:=FP.GetCheckCopyText;
 end;


function TEKKA.GetPaperOut:Boolean;
 begin
  if (UseEKKA=False) or (FLastError='') then begin Result:=False; Exit; end;

  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=FLastError='HARDPAPER';
   EKKA_DATECS3530T:Result:=FLastError='PAPER_OUT';
   EKKA_EXELLIO:    Result:=Pos(AnsiUpperCAse('����������� ������� ��� ����������� �����'),AnsiUpperCAse(FP.LastErrorText))<>0;
   EKKA_FP2000:     Result:=Pos(AnsiUpperCAse('����������� ������� ��� ����������� �����'),AnsiUpperCAse(FP.LastErrorDescr))<>0;
  end;

 end;

function TEKKA.GetLinkOut:Boolean;
 begin

  if (UseEKKA=False) or (FLastError='') then begin Result:=False; Exit; end;

  Case TypeEKKA of
   EKKA_MARRY301MTM:Result:=(FLastError='ERP_9993') or (FLastError='ERP_9995') or (FLastError='ERP_9998');
   EKKA_DATECS3530T:Result:=FLastError='TIMEOUT_ERROR';
   EKKA_EXELLIO:    Result:=(Pos(AnsiUpperCAse('���������� ������� COM ����'),AnsiUpperCAse(FP.LastErrorText))<>0) or
                            (Pos(AnsiUpperCAse('���������� ���������� � ���������� �������������'),AnsiUpperCAse(FP.LastErrorText))<>0);
   EKKA_FP2000:    Result:=(Pos(AnsiUpperCAse('���������� ������� COM ����'),AnsiUpperCAse(FP.LastErrorDescr))<>0) or
                            (Pos(AnsiUpperCAse('���������� ���������� � ���������� �������������'),AnsiUpperCAse(FP.LastErrorDescr))<>0);
  end;

 end;

procedure TEKKA.bPrintHead(P:Byte=0);
var i:Integer;
    S,sID,sPN,sFN,sZN:String;
 begin
  FLastError:='';

  MrFont.IntervalW:=2;
  MrFont.StartPrint;

  if IsFLP=False then
   begin
    MrFont.AddStrC(FirmNameUA,0);

    for i:=Low(eStr) to High(eStr) do if eStr[i]<>'' then MrFont.AddStrC(eStr[i],0);

    MrFont.AddStr(' �� '+FsFN+'        I� '+FsID,0);
    MrFont.AddStr(' �� '+FsZN+'      �� '+FsPN,0);
   end else begin
             MrFont.AddStrC('��� ������� ������� ����i�����',0);
             MrFont.AddStrC('2765021835',0);
            end;

  if FTypeLogo in [0,1] then MrFont.AddLogo(FTypeLogo);

  if P=1 then
   MrFont.AddInterv(10)
  else
   MrFont.AddStr(' ',0);
 end;

procedure TEKKA.bPrintFooter(Param:Byte);
var S:String;
{

 Param: 1 -��� ����������,  2 - ��� �� ����������,  3 - �����,  4 - ��������� ��������, 5 - ���������� ���

}
 begin
  if (Param in [1,2]) and ((AptekaID in [240]) or (IsFLP)) then S:='�� �I�������� ���' else
   Case Param of
    1:  S:='�I�������� ���';
    2,4:S:='!  ��  �I��������  !';
    3:  S:='';
    5:  S:='���������� ���';
   end;
  MrFont.EndPrint(S,FDtChek,Param,FIsCopy,Not IsFLP);

 end;

procedure TEKKA.GetInfo(NumZ:Integer=0);
 begin
  Qr.Close;
  if NumZ=0 then Qr.SQL.Text:='exec spY_GetEKKAInfo '+IntToStr(FKassaID)
            else Qr.SQL.Text:='exec spY_GetEKKAInfo_ '+IntToStr(FKassaID)+','+IntToStr(NumZ);
  Qr.Open
 end;

procedure TEKKA.bPrintRep(Param:Byte; NumZ:Integer=0);
var qrS,S:String;
    IsOpen:Boolean;
    DtWriteZ:TDateTime;
    i:Integer;
{
 0 - X-�����
 1 - Z-�����
}

 begin

  GetInfo(NumZ);

  bPrintHead(1);
  try

   Case Param of
    0:S:='X';
    1:S:='Z';
   end;

   IsOpen:=Qr.FieldByName('IsOpen').AsInteger=1;

   if (Param=1) and (IsOpen=False) and (NumZ=0) then
    MrFont.AddStrC('*  *  * ���i� *  *  *',1);

   MrFont.AddStrC(S+'-��i� � '+AddStr_(Qr.FieldByName('NumZ').AsString,'0',4),1);
   MrFont.AddStrC('�� '+DateToStrSlash(Qr.FieldByName('DtRep').AsDateTime),1);

   FDtChek:=Now;

   if Param=1 then
    begin

     if (IsOpen) and (NumZ=0) then DtWriteZ:=FDtChek
                              else DtWriteZ:=Qr.FieldByName('DtRep').AsDateTime;

     MrFont.AddStr(' ����� �� �� ��������    '+DateTimeToStrSlash(DtWriteZ),0);
    end;

   if NumZ>0 then FDtChek:=DtWriteZ;

   if (IsOpen=True) or (Param=1) then
    begin
     MrFont.AddStr(' ������i� �i�������� ��� '+DateTimeToStrSlash(Qr.FieldByName('DtLastChek').AsDateTime),0);
     MrFont.AddStr(' ��i�� �i������          '+DateTimeToStrSlash(Qr.FieldByName('DtOpenSmena').AsDateTime),0);
    end else MrFont.AddStrC('��i�� �� �i������',1);

   MrFont.AddStrC('������ ��i�� (���)',0);

   if NumZ>0 then
    begin
     MrFont.AddStr('�� '+FsZN+'    �i� 11/02/14',0);
     MrFont.AddStr('�� '+FsFN+'      �i� 31/10/14',0);
    end else begin
              MrFont.AddStr('�� '+FsZN+'    �i� 11/02/14',0);
              MrFont.AddStr('�� '+FsFN+'      �i� 31/10/14',0);
             end;

   MrFont.AddStr(' - - - - - - - - - - - - - - - - - - - -',0);
   MrFont.AddStrC('- - ����i���i� - -',1);

   if (IsOpen=False) and (Param=0) then
    begin
     MrFont.AddStrC('- - - - - - - - - -',0);
     MrFont.AddStr2J('��i�����i �i� ���������.','0,00',0);
     MrFont.AddStrC('- - - - - - - - - -',0);
     MrFont.AddStr2J('�� � ��''����� ���������.','0,00',0);
     MrFont.AddStrC('- - - - - - - - - -',0);
     MrFont.AddStr2J('��������� ������','0,00',0);
     MrFont.AddStrC('- - - - - - - - - -',0);
     MrFont.AddStrC('�������� �i� ��i���� �� ������ ������',0);
     MrFont.AddStrC('������ �� �����������',0);
     MrFont.AddStr2J('������� ����','0',0);
     MrFont.AddStrC(' - - - - - - - - - -',1);
    end else begin

              MrFont.AddStr('���                 *� 20.00%',0);
              if NumZ>0 then MrFont.AddStrC('䳺 � 31/10/14, � �Z 0001',0)
                        else MrFont.AddStrC('䳺 � 31/10/14, � �Z 0001',0);
              MrFont.AddStr2J('���� �������������',CurrToStrF_(Qr.FieldByName('SumA').AsCurrency),0);
              MrFont.AddStr2J('����� ������� �i� ����',CurrToStrF_(Qr.FieldByName('Sum_nAb').AsCurrency),0);
              MrFont.AddStr2J('����� ������� �� �����',CurrToStrF_(Qr.FieldByName('Sum_nA').AsCurrency),0);

              MrFont.AddStr('                    *� 7.00%',0);
              if NumZ>0 then MrFont.AddStrC('䳺 � 31/10/14, � �Z 0001',0)
                        else MrFont.AddStrC('䳺 � 31/10/14, � �Z 0001',0);
              MrFont.AddStr2J('���� �������������',CurrToStrF_(Qr.FieldByName('SumB').AsCurrency),0);
              MrFont.AddStr2J('����� ������� �i� ����',CurrToStrF_(Qr.FieldByName('Sum_nBb').AsCurrency),0);
              MrFont.AddStr2J('����� ������� �� �����',CurrToStrF_(Qr.FieldByName('Sum_nB').AsCurrency),0);

              MrFont.AddStrC('- - - - - - - - - -',0);
              MrFont.AddStr2J('������� �� ���������.','0,00',0);
              MrFont.AddStrC('- - - - - - - - - -',0);
              MrFont.AddStr2J('�� � ��''����� ���������.','0,00',0);
              MrFont.AddStrC('- - - - - - - - - -',0);

              MrFont.AddStr2J('��������� ������',CurrToStrF_(Qr.FieldByName('Sum4').AsCurrency+Qr.FieldByName('Sum7').AsCurrency),0);
              MrFont.AddStrC('- - - - - - - - - -',0);

              MrFont.AddStrC('�������� �i� ��i���� �� ������ ������',0);
              MrFont.AddStr2J('������',CurrToStrF_(Qr.FieldByName('Sum4').AsCurrency),0);

              if Qr.FieldByName('SumB1').AsCurrency>0 then
               MrFont.AddStr2J('�����������.1',CurrToStrF_(Qr.FieldByName('SumB1').AsCurrency),0);

              MrFont.AddStr2J('�����������.2',CurrToStrF_(Qr.FieldByName('Sum7').AsCurrency-Qr.FieldByName('SumB1').AsCurrency),0);
              MrFont.AddStr2J('������� ����',Qr.FieldByName('CntCheks').AsString,0);

              // ���� ���� �������� �� ����������
              if (Qr.FieldByName('Sum5').AsCurrency>0) or (Qr.FieldByName('Sum5').AsCurrency>0) then
               begin
                MrFont.AddStr(' - - - - - - - - - - - - - - - - - - - -',0);
                MrFont.AddStrC('- - ���������� - -',1);
                MrFont.AddStr('���                 *� 20.00%',0);
                MrFont.AddStrC('䳺 � 31/10/14, � �Z 0001',0);
                MrFont.AddStr2J('���� �������������',CurrToStrF_(Qr.FieldByName('SumBA').AsCurrency),0);
                MrFont.AddStr2J('����� ������� �i� ����',CurrToStrF_(Qr.FieldByName('Sum_nBAb').AsCurrency),0);
                MrFont.AddStr2J('����� ������� �� �����',CurrToStrF_(Qr.FieldByName('Sum_nBA').AsCurrency),0);

                MrFont.AddStr('                    *� 7.00%',0);
                MrFont.AddStrC('䳺 � 31/10/14, � �Z 0001',0);
                MrFont.AddStr2J('���� �������������',CurrToStrF_(Qr.FieldByName('SumBB').AsCurrency),0);
                MrFont.AddStr2J('����� ������� �i� ����',CurrToStrF_(Qr.FieldByName('Sum_nBBb').AsCurrency),0);
                MrFont.AddStr2J('����� ������� �� �����',CurrToStrF_(Qr.FieldByName('Sum_nBB').AsCurrency),0);

                MrFont.AddStrC('- - - - - - - - - -',0);
                MrFont.AddStr2J('������� �� ���������.','0,00',0);
                MrFont.AddStrC('- - - - - - - - - -',0);
                MrFont.AddStr2J('�� � ��''����� ���������.','0,00',0);
                MrFont.AddStrC('- - - - - - - - - -',0);

                MrFont.AddStr2J('��������� ������',CurrToStrF_(Qr.FieldByName('Sum5').AsCurrency+Qr.FieldByName('Sum8').AsCurrency),0);
                MrFont.AddStrC('- - - - - - - - - -',0);

                MrFont.AddStrC('��������� ��i����� �� ������ ������',0);
                MrFont.AddStr2J('������',CurrToStrF_(Qr.FieldByName('Sum5').AsCurrency),0);
                MrFont.AddStr2J('�����������.2',CurrToStrF_(Qr.FieldByName('Sum8').AsCurrency),0);
                MrFont.AddStr2J('������� ����',Qr.FieldByName('CntCheksB').AsString,0);
               end;
              MrFont.AddStrC(' - - - - - - - - - -',1);

             end;


   MrFont.AddStrC('- - - - - - ������� ����� � ��� - - - -',0);
   MrFont.AddStr2J('���������� �������',CurrToStrF_(Qr.FieldByName('Sum1').AsCurrency),0);
   MrFont.AddStr2J('�������� ��������', CurrToStrF_(Qr.FieldByName('Sum2').AsCurrency),0);
   MrFont.AddStr2J('�������� ���������',CurrToStrF_(Qr.FieldByName('Sum3').AsCurrency),0);
   MrFont.AddStr2J('������� �������',  CurrToStrF_(Qr.FieldByName('Sum6').AsCurrency),0);
   MrFont.AddStrC('- - - - - - - - - ������� - - - - - - -',0);

   MrFont.AddStr2J('������',   CurrToStrF_(Qr.FieldByName('Sum4').AsCurrency-Qr.FieldByName('Sum5').AsCurrency),0);
   MrFont.AddStr2J('�����������',CurrToStrF_(Qr.FieldByName('Sum7').AsCurrency-Qr.FieldByName('Sum8').AsCurrency),0);

   MrFont.AddStrC('- - - - - - - - - - - - - - - - - - - -',0);
   MrFont.AddStr2J('����� ���������� ����',Qr.FieldByName('NLastChek').AsString,0);

   if (Param=1) and (IsOpen=True)  then
    begin

    if NumZ=0 then
     begin
      QrEx.Close;
      QrEx.SQL.Clear;

      QrEx.SQL.Add('exec spY_WriteJournZ_ '''+FormatDateTime('yyyy-mm-dd hh:nn:ss',DtWriteZ)+''', ');
      QrEx.SQL.Add('     :vzh, :id_kassa, :numz, :isprint, :Sum1, :Sum2, :Sum3, :Sum4, :Sum5, :Sum6, :Sum7, :Sum8, :SumA, :SumB, :SumBA, :SumBB');

      QrEx.Parameters.ParamByName('vzh').Value:=EKKA.VzhNum;
      QrEx.Parameters.ParamByName('NumZ').Value:=Qr.FieldByName('NumZ').AsInteger;
      QrEx.Parameters.ParamByName('id_kassa').Value:=EKKA.KassaID;
      QrEx.Parameters.ParamByName('isprint').Value:=1;

      for i:=1 to 8 do
       QrEx.Parameters.ParamByName('Sum'+IntToStr(i)).Value:=Qr.FieldByName('Sum'+IntToStr(i)).AsCurrency;

      QrEx.Parameters.ParamByName('SumA').Value:=Qr.FieldByName('SumA').AsCurrency;
      QrEx.Parameters.ParamByName('SumB').Value:=Qr.FieldByName('SumB').AsCurrency;
      QrEx.Parameters.ParamByName('SumBA').Value:=Qr.FieldByName('SumBA').AsCurrency;
      QrEx.Parameters.ParamByName('SumBB').Value:=Qr.FieldByName('SumBB').AsCurrency;
 //    QrEx.SQL.SaveToFile('C:\tttttttttt');
      QrEx.Open;
     end;

     MrFont.AddStr('1. ������� ������ ������� �������',0);
     MrFont.AddStr('2. ���������� ������ ��� ������',0);
     MrFont.AddStrC('- - - - - - - - - - - - - - - - - - - -',0);

    end;

   bPrintFooter(3);
  except
   bPrintFooter(2);
   raise;
  end;

 end;

Initialization

Finalization

 if FEKKA<>nil then FEKKA.Free;

END.

   {

    ���� �����:
          �����    ������ FP3530  Exellio LP1000  Exellio FP2000  
     1 - ������ 3
     2 - ������ 2
     3 - ������ 1
     4 - ��������

   }



