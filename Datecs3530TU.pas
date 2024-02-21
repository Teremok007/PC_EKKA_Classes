UNIT Datecs3530TU;

INTERFACE

Uses Windows, Dialogs, Messages, SysUtils, Classes, CPDrv, Util, IniFiles,Graphics;

Type RetData=Record
              Count:Integer;
              CmdCode:Integer;
              UserData:Integer;
              Status:Integer;
              CmdName:PChar;
              SendStr:PChar;
              Whole:PChar;
              RetItem:Array[1..20] of PChar;
              OrigStat:Array[1..6] of Byte;
             end;

     n1RetData=Array[1..10] of Byte;
     nRetData=^n1RetData;

     TMathFunc=procedure(const rt:RetData)stdcall;


 TMarry301 = class (TCommPortDriver)

 private

  FHND:HWND;
  FPortNum:Integer;
  FLog:TStrings;
  FLastError:String;
  FIsCRC:Integer;
  FRD_Item:TStringList;
  FResComm:String;
  FKassir:String;
  FUseEKKA:Boolean;
  FArtFile:String;
  FRnd:Char;
  FSumSales:Integer;
  FSumVoids:Integer;
  FLastNumCheck:Integer;
  FIsNewVersion:Boolean;
  FVzhNum:Int64;

  procedure SetLog(const Value:TStrings);
  procedure SetKassir(Value:String);

  function GetReceiptNumber:Integer;
  function GetKeyPosition:Integer;
  function GetLastErrorDescr: String;

 public

  constructor Create(AOwner:TComponent); override;
  destructor Destroy; override;

  procedure ClearLog;                                        // ������� ����
  procedure fpClosePort; virtual;                            // ������� ��� ����

  function  fpSendCommand(var Comm:String):Boolean; virtual; // ���������� ������������ �������, ���� ���� ����������, �� ��� ������������� � Comm

  function  ErrorDescr(Code:String):String;                  // ��������� ��������� �� ���� ������

  { --- ��������� ����� � ���� --- }
  function  fpConnect:Boolean; virtual;                      // ��������� ����� � ����

  { --- ��������� ������� ����� ---}
  function  fpSetTime(T:TDateTime):Boolean; virtual;         // ��������� ������� EKKA
  function  fpLoadLogo(Logo:String; Active:Boolean):Boolean;  overload; virtual;  // �������� ������������ ������-�������� �� �����
  function  fpLoadLogo(Logo:TBitMap; Active:Boolean):Boolean; overload; virtual; // �������� ������������ ������-�������� �� BitMap
  function  fpActiveLogo(P:Byte):Boolean; virtual;             // ����������� ������ ������������ ������ (0 �� ��������, 1 - ��������)
  function  fpCutBeep(C,B,N:Byte):Boolean; overload; virtual;  // ���������� ������� ��������� ������� ����� � �������� ��������
  function  fpCutBeep(C,B:Byte):Boolean;   overload; virtual;  // ���������� ������� ��������� ������� ����� � �������� ��������
  function  fpSetHead(S:String):Boolean;                // ��������� ������������ ������

  { --- ���������� ��������������� ������������ --- }
  function  fpOpenCashBox:Boolean; virtual;  // �������� ��������� �����

  { --- ���������������� ���������� ������ --- }

  { --- ���������� � ������� ������� � ����� --- }
  function  fpOpenFiscalReceipt:Boolean;             // �������� ������ ����
  function  fpAddSale(Name:String;                   // ����������� ������� ����� �������
                      Kol:Integer;
                      Cena:Currency;
                      Divis:Byte;
                      Artic:Integer;
                      Nalog:Byte;
                      DiscSum:Currency;
                      DiscDescr:String
                     ):Boolean;
  function  fpSetBackReceipt(S:String):Boolean;       // ����������� ������ ����������� ����
  function  fpAddBack(Name:String;                    // ����������� ������� ��������
                      Kol:Integer;
                      Cena:Currency;
                      Divis:Byte;
                      Nalog:Byte;
                      DiscSum:Currency;
                      DiscDescr:String
                     ):Boolean;
  function  fpServiceText(TextPos:Integer;            // ����������� ��������� ������ � ����
                          Print2:Integer;
                          FontHeight:Integer;
                          S:String
                         ):Boolean;
  function  fpCloseFiscalReceipt(TakedSumm:Currency;  // �������� ����
                                 TypeOplat:Integer
                                ):Boolean;
  function  fpCancelFiscalReceipt:Boolean;            // ������ ����
  function  fpCheckCopy:Boolean;                      // ������ ����� ����

  { --- ��������� ��������/������� �������� ������� --- }
  function  fpCashInput(C:Currency):Boolean;         // �������� �������� �������
  function  fpCashOutput(C:Currency):Boolean;        // ������� �������� �������

  { --- ��������� ����������������� ���������� � ��������� ���� --- }
  function  fpGetStatus:Boolean;                    // ��������� ����������� ��������� EKKA
  function  fpCashState(P:Integer):Boolean;         // ������ ���������� � �������� ������� �� ����� (0 - �� ������� �����, 1 - �� �������)
  function  fpFiscState:Boolean;                    // ������ �������� ��������� ������� ���������� ���������

  { --- ���������� ������ --- }
  function  fpXRep:Boolean;                          // X-�����
  function  fpZRep:Boolean;                          // �-�����
  function  fpPerFullRepD(D1,D2:TDateTime):Boolean;  // ������ ������������� ����� �� �����
  function  fpPerShortRepD(D1,D2:TDateTime):Boolean; // ����������� ������������� ����� �� �����
  function  fpPerFullRepN(N1,N2:Integer):Boolean;    // ������ ������������� ����� �� ������� �-�������
  function  fpPerShortRepN(N1,N2:Integer):Boolean;   // ����������� ������������� ����� �� ����� �-�������

  { --- ������������� � ��������� ������ --- }
  function  fpZeroCheck:Boolean;                     // ������� ���

  { --- ������������ ��������� ��������� �� --- }

  { --- ������� ��������� � ��������� ���������� ��������� ����������� --- }
  function fpServPassw(P1:String; P2:String=''):Boolean; // ���� ������ ��������� ����������� (��������� ��������� - 2222222222)
  function fpPrintLimit(P:Integer):Boolean;              // ���� ���������� �����, ����� �������� ���� �����������
  function fpDayLimit(D:Integer):Boolean;                // ���� ���������� ����, ����� �������� ���� �����������
  function fpGetLimitStatus:Boolean;                     // ������ ��������������� ������� ���� ������ � ����� ������
  function fpResetUsPassw:Boolean;                       // ����� ������ ������������ � ��������� - '1111111111'

  { --- �������� ����c�� --- }
  property  Log:TStrings read FLog write SetLog;     // ��� ������ (����� ��� ����������� ���� ���������)
  property  IsCRC:Integer read FIsCRC write FIsCRC;  // ������� ������������� ����������� ����� ��� �������� ������
  property  UseEKKA:Boolean read FUseEKKA write FUseEKKA;     // ���� ���������� EKKA
  property  Kassir:String read FKassir write SetKassir;       // ��� ������� ��� �����������
  property  PortNum:Integer read FPortNum write FPortNum; // ������������� ����� ��� �����
  property  LastError:String read FLastError;                 // ��������� ������ ������� ���������� �������
  property  LastErrorDescr:String read GetLastErrorDescr;     // �������� ��������� ������ ������� ���������� �������
  property  RD_Item:TStringList read FRD_Item;                // ������ �������, ����������� ����� ���������� ������ fpGeStatus,
  property  ReceiptNumber:Integer read GetReceiptNumber;      // ����� ���������� ������� ������������ ����
  property  KeyPosition:Integer read GetKeyPosition;          // ��������� �����
  property  Rnd:Char read FRnd write FRnd;                    // ������� ����������
  property  IsNewVersion:Boolean read FIsNewVersion write FIsNewVersion; // ������� ������ ���� (True - T7, False - T3,T4)
  property  VzhNum:Int64 read FVzhNum;                       // ��������� ����� ��������� ��������

 end;

const C_UNSAFE=0;  // ������ ��� ����������� �����
      C_CRC=1;     // ������ � ����������� ������
      TIME_OUT=6;  // ����� �������� ����������� ������� � ��������

      // ��������� �����
      KEY_O=0; // ��������
      KEY_W=1; // ������
      KEY_X=2; // X-�����
      KEY_Z=4; // �-�����
      KEY_P=8; // ����������������

      RND_MATH='0'; // �� �������� �����������
      RND_MAX ='1'; // �� ���������� ��������
      RND_MIN ='2'; // �� ���������� ��������

procedure PrinterResults(const rt:RetData)stdcall;

function  GetStatus(hWin:HWND; fun:TMathFunc; par:LPARAM; int1: BOOL):integer; stdcall	;external 'fpl.dll' name 'GetStatus';
function  OpenFiscalReceipt(hWin:HWND; fun:TMathFunc; par:LPARAM;i1: DWORD;i2: LPSTR;i3: DWORD;i4: BOOL):integer;stdcall;external 'fpl.dll' name 'OpenFiscalReceipt';
function  RegisterItem(hWin:HWND; fun:TMathFunc; par:LPARAM; n:LPSTR; n1: char; n2:double; n3:double):integer;stdcall;external 'fpl.dll' name 'RegisterItem';
function  InitFPport(int1,int2:integer):integer;stdcall	; external 'fpl.dll' name 'InitFPport';
function  CloseFPport():integer;stdcall	; external 'fpl.dll' name 'CloseFPport';
function  PrintDiagnosticInfo(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall	;external 'fpl.dll' name 'PrintDiagnosticInfo';
function  SetDecimals(int1:integer):integer;stdcall;external 'fpl.dll' name 'SetDecimals';
function  SubTotal(hWin:HWND; fun:TMathFunc; par:LPARAM; n1:BOOL;n2:BOOL; n3:double):integer; stdcall	;external 'fpl.dll' name 'SubTotal';
function  Total(hWin:HWND; fun:TMathFunc; par:LPARAM; n1:LPSTR;n2:char; n3:double):integer; stdcall	;external 'fpl.dll' name 'Total';
function  CloseFiscalReceipt(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall	;external 'fpl.dll' name 'CloseFiscalReceipt';
function  FiscalClosure(hWin:HWND; fun:TMathFunc; par: LPARAM;n:LPSTR; s:char):integer; stdcall;external 'fpl.dll' name 'FiscalClosure';
function  ServiceInputOutput(hWin:HWND; fun:TMathFunc; par:LPARAM ; sum:Double) :integer; stdcall	;external 'fpl.dll' name 'ServiceInputOutput';
function  PrintFiscalMemoryByNum(hWin:HWND; fun:TMathFunc; par: LPARAM; n1:integer; n2:integer; BOOL:boolean):integer; stdcall;external 'fpl.dll' name 'PrintFiscalMemoryByNum';
function  PrintFiscalMemoryByDate(hWin:HWND; fun:TMathFunc; par: LPARAM; d1:LPSTR; d2:LPSTR; BOOL:boolean):integer; stdcall;external 'fpl.dll' name 'PrintFiscalMemoryByDate';
function  OpenDrawer(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall	;external 'fpl.dll' name 'OpenDrawer';
function  PrintFiscalText(hWin:HWND; fun:TMathFunc; par:LPARAM; int1: LPSTR):integer; stdcall	;external 'fpl.dll' name 'PrintFiscalText';
function  SaleArticleAndDisplay(hWin:HWND; fun:TMathFunc; par:LPARAM; sign: Boolean;  numart:integer; qwant,perc,dc:double ):integer; stdcall  ;external 'fpl.dll' name 'SaleArticleAndDisplay';
function  ProgrammingArticle(hWin:HWND; fun:TMathFunc; par:LPARAM; nal:char; gr:integer; cod:integer; Sena:double; pass:LPSTR; name:LPSTR):integer; stdcall  ;external 'fpl.dll' name 'ProgrammingArticle';
function  DeleteArticle(hWin:HWND; fun:TMathFunc; par:LPARAM; cod:integer; pass:LPSTR):integer; stdcall  ;external 'fpl.dll' name 'DeleteArticle';
function  ChangeArticlePrice(hWin:HWND; fun:TMathFunc; par:LPARAM; cod:integer;sena:Double; pass:LPSTR):integer; stdcall  ;external 'fpl.dll' name 'ChangeArticlePrice';

IMPLEMENTATION

procedure PrinterResults(const rt:RetData)stdcall;
 begin
 end;

constructor TMarry301.Create;
 begin
  inherited Create(AOwner);
  FRD_Item:=TStringList.Create;
  FLog:=nil;
  FPortNum:=1;
  FHND:=0;
  FLastError:='';
  FIsCRC:=C_UNSAFE;
  FIsNewVersion:=True;
  Kassir:='';
  FUseEKKA:=True;
  FArtFile:=PrPath+'\$Marry301$.txt';
  FRnd:=RND_MATH;
  FSumSales:=0;
  FSumVoids:=0;
  FVzhNum:=0;
 end;

destructor TMarry301.Destroy;
 begin
  FRD_Item.Free;
  inherited Destroy;
 end;

function TMarry301.fpConnect:Boolean;
var i:Integer;
    S:String;
    B:Boolean;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
  FHND:=InitFPport(FPortNum,19200);
  if FHND<0 then FLastError:='ERP_9996';
 end;

function TMarry301.ErrorDescr(Code:String):String;
 begin
  if Code='ERP_9996' then Result:='��� ������ �� ������������!' else
                          Result:=Code;
 end;

procedure TMarry301.ClearLog;
 begin
  if FLog<>nil then FLog.Clear;
 end;

procedure TMarry301.SetLog(const Value:TStrings);
 begin
  FLog:=Value;
 end;

procedure TMarry301.fpClosePort;
 begin
  CloseFPport;
 end;

function TMarry301.fpGetStatus:Boolean;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
 end;

function TMarry301.fpCashState(P:Integer):Boolean;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
 end;

function TMarry301.fpSendCommand(var Comm:String):Boolean;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
 end;


function TMarry301.fpXRep:Boolean;
 begin
  FiscalClosure(FHND,PrinterResults,0,'0','2');
 end;

function TMarry301.fpZRep:Boolean;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
 end;

function TMarry301.fpZeroCheck:Boolean;
 begin
 end;

function TMarry301.fpPerFullRepD(D1,D2:TDateTime):Boolean;
 begin
 end;

function TMarry301.fpPerFullRepN(N1,N2:Integer):Boolean;
 begin
 end;

function TMarry301.fpPerShortRepD(D1,D2:TDateTime):Boolean;
 begin
 end;

function TMarry301.fpPerShortRepN(N1,N2:Integer):Boolean;
 begin
 end;

procedure TMarry301.SetKassir(Value:String);
 begin
  if Value='' then Value:='KASSIR';
  FKassir:=Value;
 end;

function TMarry301.GetReceiptNumber:Integer;
var S:String;
 begin
  try
   if Not UseEKKA then Abort;
  except
   Result:=-1;
  end;
 end;

function TMarry301.GetKeyPosition:Integer;
 begin
  try
   if Not UseEKKA then Abort;
   if Not fpGetStatus then Abort;
   Result:=Ord(RD_Item[5][1]);
  except
   Result:=0;
  end;
 end;

function TMarry301.fpOpenFiscalReceipt:Boolean;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
 end;

function TMarry301.GetLastErrorDescr:String;
 begin
  Result:=ErrorDescr(FLastError);
 end;

function TMarry301.fpCashInput(C:Currency):Boolean;
 begin
 end;

function TMarry301.fpCashOutput(C:Currency):Boolean;
 begin
 end;

function TMarry301.fpSetTime(T:TDateTime):Boolean;
 begin
 end;

function TMarry301.fpAddSale(Name:String;
                             Kol:Integer;
                             Cena:Currency;
                             Divis:Byte;
                             Artic:Integer;
                             Nalog:Byte;
                             DiscSum:Currency;
                             DiscDescr:String
                            ):Boolean;

 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
 end;

function TMarry301.fpAddBack(Name:String;
                             Kol:Integer;
                             Cena:Currency;
                             Divis:Byte;
                             Nalog:Byte;
                             DiscSum:Currency;
                             DiscDescr:String
                            ):Boolean;
 begin
 end;

function TMarry301.fpCancelFiscalReceipt:Boolean;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
 end;

function TMarry301.fpCloseFiscalReceipt(TakedSumm:Currency; TypeOplat:Integer):Boolean;
 begin
  Result:=True;
  if Not (FUseEKKA) then Exit;
  Result:=False;
 end;

function TMarry301.fpOpenCashBox:Boolean;
 begin
 end;

function TMarry301.fpServiceText(TextPos,Print2,FontHeight:Integer; S:String):Boolean;
var ss:String;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
 end;

function TMarry301.fpSetBackReceipt(S:String):Boolean;
 begin
 end;

function TMarry301.fpLoadLogo(Logo:TBitMap; Active:Boolean): Boolean;
 begin
  Result:=True;
  if Not UseEKKA then Exit;
 end;

function TMarry301.fpLoadLogo(Logo:String; Active:Boolean):Boolean;
 begin
  Result:=True;
  if Not UseEKKA then Exit;
 end;

function TMarry301.fpActiveLogo(P:Byte):Boolean;
 begin
 end;

function TMarry301.fpCutBeep(C,B,N:Byte):Boolean;
 begin
 end;

function TMarry301.fpCutBeep(C,B:Byte):Boolean;
 begin
 end;

function TMarry301.fpSetHead(S:String):Boolean;
 begin
 end;

function TMarry301.fpFiscState:Boolean;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
 end;

function TMarry301.fpServPassw(P1:String; P2:String=''):Boolean;
 begin
 end;

function TMarry301.fpDayLimit(D:Integer):Boolean;
 begin
 end;

function TMarry301.fpPrintLimit(P:Integer):Boolean;
 begin
 end;

function TMarry301.fpGetLimitStatus:Boolean;
 begin
 end;

function TMarry301.fpResetUsPassw: Boolean;
 begin
 end;

function TMarry301.fpCheckCopy:Boolean;
 begin
 end;

END.



