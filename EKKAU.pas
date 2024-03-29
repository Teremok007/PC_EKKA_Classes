unit EKKAU;

interface

uses Marry301U, MicroHelpN707, ADODB, Classes, Windows, SysUtils, Graphics, ComObj,Util,
     Variants, Dialogs, DB, Controls, MarryFont,ICS_E810T, PrintReport, DelphiZXingQRCode,
     ShellApi, Forms;

type TArrStr=array of OleVariant;

  RetData=record
    Count:Integer;
    CmdCode:Integer;
    UserData:Integer;
    Status:Integer;
    CmdName:PAnsiChar;
    SendStr:PAnsiChar;
    Whole:PAnsiChar;
    RetItem:array[1..20] of PAnsiChar;
    OrigStat:array[1..6] of Byte;
  end;

  TXZPayment=Record
              CntCheck:Integer;
              Nal:Currency;
              Beznal1:Currency;
              Beznal2:Currency;
              Beznal3:Currency;
              OborotA:Currency;
              OborotB:Currency;
              OborotV:Currency;
              NalogA:Currency;
              NalogB:Currency;
              NalogV:Currency;
             end;

  TPeriodData=Record
               NumZ:Integer;
               dateZ:TDateTime;
               SumZ:Currency
              end; 

  TXZRep=Record
          Tp:Char; // 'X' ��� 'Z' ��� 'P'
          dtStart:TDatetime;
          dtEnd:TDatetime;
          strH1:String;
          strH2:String;
          strH3:String;
          strH4:String;
          strH5:String;
          ID:String;
          PN:String;
          FN:String;
          Sale:TXZPayment;
          Back:TXZPayment;
          SumStart:Currency;
          CashIn:Currency;
          CashOut:Currency;
          CashBox:Currency;
          DtCheck:TDateTime;
          NumZ:Integer;
          NumZ_:Integer;
          TypeOut:Byte; // 1 - ����� �� ������������, 2 - ����� �� �����
          aStr:Array of TPeriodData;
          LastNChek:Integer;
         end;

  n1RetData=array[1..10] of Byte;
  nRetData=^n1RetData;

  TMathFunc=procedure(const rt:RetData) stdcall;

  TCheckPos=Record // ������� ���� ������������ ���
   Letter:Char;       // ������ ������ �,�,�
   TaxPrc:Byte;       // % ������
   Code:Integer;      // ��� ������
   UnitCode:String;   // ��� ��. ���. ����
   UnitName:String;   // ��. ���. ����
   Name:String;       // �������� ��������
   UKTZED:String;     // ��� ������
   Amount:Integer;    // ���-��
   Price:Currency;    // ����
   Cost:Currency;     // ���������
   Discount:Currency; // ����� ������ ��� ��������
  end;

  TService=Record
            S:String;
            TextPos:Byte;
            Align:Byte;
            Style:TFontStyles;
           end;

  TCheck=Record  // ��� ������������ ���
   TypeChek:Byte;        // ��� �������� ��� ������� (CH_SALE ��� CH_BACK)
   NumbChek:Integer;     // �������� ��������� �����
   OrderNum:String;
   DtCheck:TDateTime;
   strH1:String;
   strH2:String;
   strH3:String;
   strH4:String;
   strH5:String;
   ID:String;
   PN:String;
   FN:String;
   Products:Array of TCheckPos;
   Service:Array of TService;
   TakedSum:Currency;
   SumNal:Currency;
   SumB1:Currency;
   SumB2:Currency;
   SumB3:Currency;
   guid:String;
   TypeOut:Byte; // ��� ������ ���� 1 - ����� ����������� � PrintReport, 2 - ����� ���� pdf
   URL:String;   // ������ �� ��� ����� ���� �� ��� � Arh_All, � ����� � ���������
   IsPrinted:Boolean;
  end;

  TEKKA=class(TMarry301)
  private
    FTypeEKKA:Byte;
    FNumVoidChek:string;
    FIsConnected:Boolean;
    FP:Variant;
    N707Status:TStatusN707;
    FDatePOEx:string;
    FEmulEKKA:Boolean;
    FQr:TADOQuery;
    FQr1:TADOQuery;
    FQrEx:TADOQuery;
    FAptekaID:Integer;
    FFirmNameUA:string;
    FsZN:string;
    FsPN:string;
    FsFN:string;
    FsID:string;
    FTypeLogo:Byte;
    FDtChek:TDateTime;
    FNLastChek:Integer;
    FBNumb_Chek:Integer;
    FIsCopy:Boolean;
    FCopy_Chek:Integer;
    curr_check:TStringList;//������� ���
    FSumNA,FSumNB,FSumNC,FSumSale,FSumVoid,FSumDis:Currency;
    FIsFLP:Boolean;
    FDateChek:TDateTime;
    FIPAddr:string;
    FConnectString:string;
    FBank:string;
    FMFO:string;
    FOKPO:string;
    FR_R:string;
    FNumbChek:Longint;
    FSumChek:real;
    FDiscSumAll:Currency;
    FDiscOnAllSum:Boolean;
    FOrderNum:String;
    FGenNewNumbChek:Boolean;
    FNewNumbChek:Integer;
    FTypeChek:Integer;
    fJsonChek:String;
    fID_User:Integer;
    fForce:Integer;
    FRealizDay:Currency;
    fForceInOut:Byte;
    fSumInOutB:Currency;
    fSumInOutK:Currency;
    fSumCashB:Currency;
    fSumCashK:Currency;
    FPrinterPRRO:String;
    FLastServiceText:String;

    procedure SetTypeEKKA(const Value:Byte);
    procedure SaveRegisters;
    procedure bPrintFooter(Param:Byte);
    procedure bPrintHead(P:Byte=0;ControlStrim:Byte=0);
    procedure GetInfo(NumZ:Integer=0);
    procedure bxPrintRep(xzR:TXZRep);
    procedure printXRep(EmEKKA: Byte; FData: TField; Cap: String);
    procedure printServiceInOut(tmpQr:TADOQuery; Param:Char);

    function ReConnect:Boolean;
    function CancelFiscalReceipt:Boolean;
    function CheckErrorExellio:Boolean;
    function GetPaperOut:Boolean;
    function GetLinkOut:Boolean;
    function GetSumm:Currency;
    function GetNewServiceNumbChek:Integer;
    function GetServiceShift(ConnectStr:string;var ErrCode,ErrDescription:string):boolean;
    function GetLastServiceShiftValue(ConnectStr:string):double;

//    procedure SetviceShiftNotification(const check: TChkNomber); overload;//virtual;abstract;
//    function  SetviceShiftNotification: integer; overload;//virtual;abstract;

  protected

    function GetReceiptNumber:Integer; overload; override;
    function GetVzhNum:Int64; override;

  public

    IsAbort:Boolean;
    Passw:array[1..16] of string;
    eStr:array[1..4] of string;

    sArr:array of record
          S:string;
          F:Integer;
         end;

    check:TCheck;

    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;

    procedure printChek_NOT_FISCAL(var Check: TCheck);

    function ReceiptNumber(Index:integer=0):Integer; overload;
    procedure Gh;
    procedure bPrintRep(Param:Byte;NumZ:Integer=0;ControlStream:Byte=0);
    procedure fpClosePort; override;// ������� ��� ����
    procedure fpSendToEKV;// ������ ��������� �������� ������
    procedure fpZXPrintReport(Param:Char; NumZ_Group:Integer=0); // ������ ������������� X, Z ������� ��
    procedure fpPeriodPrintReport(dtStart, dtEnd: TDateTime); // ������ �������������� ��� ������������

    function ErrorDescr(Code:string):string; override;// ��������� ��������� �� ���� ������
    function fpCloseNoFCheck:Boolean;
    function fpGetOperatorInfo(O:Byte):Boolean;
    function fpGetCorectSums:Boolean;
    function fpGetCheckCopyText:string;// ���������� ����� ����, ���� ������ ��� FP2000
    { --- ��������� ����� � ���� --- }
    function fpLoadExellio:Boolean;
    function fpConnect:Boolean; override;// ��������� ����� � ����
    { --- ���������� ������������ ������� --- }
    function fpSendCommand(var Comm:string):Boolean; override;// ���������� ������������ �������, ���� ���� ����������, �� ��� ������������� � Comm
    { --- ��������� ������� ����� ---}
    function fpSetINSP(FN:string;ID:string;PN:string;Str1,Str2,Str3,Str4:string):Boolean; override;// ��������������� ���������� ���������.
    function fpSetTime(T:TDateTime):Boolean; override;// ��������� ������� EKKA
    function fpActiveLogo(P:Byte):Boolean; override;// ����������� ������ ������������ ������ (0 �� ��������, 1 - ��������)
    { --- ���������������� ���������� ������ --- }
    function fpSetBottomStr(S:string):Boolean; override;// ���������������� �������������� �������������� ������ �� ����.
    function fpSetBottomStrEx(S:string;N,P,W:Byte):Boolean; override;
    { --- ���������� � ������� ������� � ����� --- }
    function fpOpenFiscalReceipt(Param:Byte=1;NChek:Integer=0;ControlStrim:Byte=0):Boolean; override;// �������� ������ ����
    function fpCancelFiscalReceipt:Boolean; override;// ������ ����
    function fpAddSale(Name:string;// ����������� ������� ����� �������
      Kol:Integer;
      Cena:Currency;
      Divis:Byte;
      Artic:Integer;
      Nalog:Byte;
      DiscSum:Currency;
      DiscDescr:string
      ):Boolean; override;
    function fpAddFinStr(S:string):Boolean; override;// �������������� ���������� � ������ (������)
    function fpAddBack(Name:string;// ����������� ������� ��������
      Kol:Integer;
      Cena:Currency;
      Divis:Byte;
      Artic:Integer;
      Nalog:Byte;
      DiscSum:Currency;
      DiscDescr:string
      ):Boolean; override;

    function fpSetBackReceipt(S:string):Boolean; override;// ����������� ������ ����������� ����

    function fpServiceText(TextPos:Integer; // ����������� ��������� ������ � ����
      Print2:Integer;     // ����������� ������
      FontHeight:Integer; // 0 - �������, 1 - ��������� ������, 2 - ��������� ������, 3 - ��������� ������ � ��������� ������
      S:string;
      ForcePrint:Boolean=False  // ���������������� ������, ������� ��� ������ ��������� ��������� ���������� ��� ��������
      ):Boolean; override;

    function fpCloseFiscalReceipt(TakedSumm:Currency;// �������� ����
      TypeOplat:Integer;
      SumCheck:Currency=0;
      SumB1:Currency=0;
      IsDnepr:Boolean=False;
      ControlStreem:Byte=0;
      RRN:longint=1;
      BankCard:String='000000000000000';
      IsPrintCheck:Boolean=False
      ):Boolean; override;

    function fpCloseFiscalReceiptB(TakedSumm:Currency;TypeOplat:Integer;SumCheck:Currency=0):Boolean;
    function fpCheckCopy(Cnt:Byte=1; NChForce:Integer=0):Boolean; override;                         // ������ ����� ����
    { --- ��������� ��������/������� �������� ������� --- }
    function fpCashInput(C:Currency):Boolean; override;// �������� �������� �������
    function fpCashOutput(C:Currency;P:Byte=0):Boolean; override;// ������� �������� �������
    { --- ���������� ������ --- }
    function fpXRep:Boolean; override;// X-�����
    function fpZRep:Boolean; override;// �-�����
    function fpPerFullRepD(D1,D2:TDateTime):Boolean; override;// ������ ������������� ����� �� �����
    function fpPerShortRepD(D1,D2:TDateTime):Boolean; override;// ����������� ������������� ����� �� �����
    function fpPerFullRepN(N1,N2:Integer):Boolean; override;// ������ ������������� ����� �� ������� �-�������
    function fpPerShortRepN(N1,N2:Integer):Boolean; override;// ����������� ������������� ����� �� ����� �-�������
    { --- ������������� � ��������� ������ --- }
    function fpZeroCheck(Dt:TDateTime=0):Boolean; override;// ������� ���

    { --- ������������ ��������� ��������� �� --- }
    function fpClearServiceText:Boolean; override;// ������  ��������� ����������
    function fpCancelServiceReceipt:Boolean; override;// ������ ���������� ����
    function fpOpenServiceReceipt:Boolean; override;// �������� ���������� ����
    function fpCloseServiceReceipt:Boolean; override;//  �������� ���������� ����
    function fpCloseServiceReceiptIApteka:Boolean; // �������� ���������� ���� (������ ��� iApteka)

    { --- ���������� ��������������� ������������}
    function fpCurrToDisp(S:Currency):Boolean; override;
    function fpStrToDisp(S:string):Boolean; override;
    { --- ��������� ����������������� ���������� � ��������� ���� --- }
    function fpGetStatus:Boolean; override;// ��������� ����������� ��������� EKKA
    function fpCashState(P:Integer):Boolean; override;// ������ ���������� � �������� ������� �� ����� (0 - �� ������� �����, 1 - �� �������)
    function fpFiscState:Boolean; override;// ������ �������� ��������� ������� ���������� ���������
    { --- �������������� ������� ---}
    function KeyPosition(Key:Byte):Boolean; override;// �������� ��������� �����
    function fpIsNonClosedReceipt:Boolean;
    function fpSoundEx(Hz,Ms:Integer):Boolean;
    function fpCutBeep(C,B,N:Byte):Boolean; overload;// ���������� ������� ��������� ������� ����� � �������� ��������
    function fpDisplayText(S:string;L:Byte):Boolean;
    function fpOpenCashBox:Boolean; override;          // �������� ��������� �����

    property TypeEKKA:Byte read FTypeEKKA write SetTypeEKKA;// ��� ����
    property PaperOut:Boolean read GetPaperOut;// ������ ������������ ����/��� ������
    property LinkOut:Boolean read GetLinkOut;// ������ ������������ ����/��� �����
    property EmulEKKA:Boolean read FEmulEKKA write FEmulEKKA;// �������� ������ ����� ����� 301/304
    property Qr:TADOQuery read FQr write FQr;// ������� Query
    property QrEx:TADOQuery read FQrEx write FQrEx;// ������� Query �2
    property Qr1:TADOQuery read FQr1 write FQr1;// ������� Query �3
    property AptekaID:Integer read FAptekaID write FAptekaID;
    property FirmNameUA:string read FFirmNameUA write FFirmNameUA;
    property sID:string read FsID write FsID;
    property sPN:string read FsPN write FsPN;
    property sZN:string read FsZN write FsZN;
    property sFN:string read FsFN write FsFN;
    property TypeLogo:Byte read FTypeLogo write FTypeLogo;
    property IsFLP:Boolean read FIsFLP write FIsFLP;
    property DateChek:TDateTime read FDateChek write FDateChek;

    property IPAddr:string read FIPAddr write FIPAddr;
    property ConnectString:string read FConnectString write FConnectString;

    property Bank:string read FBank write FBank;
    property MFO:string read FMFO write FMFO;
    property OKPO:string read FOKPO write FOKPO;
    property R_R:string read FR_R write FR_R;
    property NumbChek:Longint read FNumbChek write FNumbChek;
    property SumChek:real read FSumChek write FSumChek;
    property IsCopy:Boolean read FIsCopy write FIsCopy;
    property Copy_Chek:Integer read FCopy_Chek write FCopy_Chek;
    property DiscOnAllSum:Boolean read FDiscOnAllSum write FDiscOnAllSum;
    property OrderNum:String read FOrderNum;
    property GenNewNumbChek:Boolean read FGenNewNumbChek write FGenNewNumbChek;
    property TypeChek:Integer read FTypeChek write FTypeChek;
    property JsonCheck:String read fJsonChek write fJsonChek;
    property ID_User:Integer read fID_User write fID_User;
    property Force:Integer read fForce write fForce;
    property RealizDay:Currency read FRealizDay write FRealizDay;
    property ForceInOut:Byte read fForceInOut write fForceInOut;
    property SumInOutB:Currency read fSumInOutB;
    property SumInOutK:Currency read fSumInOutK;
    property SumCashB:Currency read fSumCashB;
    property SumCashK:Currency read fSumCashK;
    property PrinterPRRO:String read FPrinterPRRO write FPrinterPRRO;
    property LastServiceText:String read FLastServiceText;

  end;

const
  { --- ���� EKKA --- }
  EKKA_MARRY301MTM=1;// ���� ����� 301��� T7
  EKKA_DATECS3530T=2;// EKKA ������ 3530T
  EKKA_EXELLIO=3;    // EKKA Exellio LP 1000
  EKKA_FP2000=4;     // EKKA Exellio FP 2000
  EKKA_N707=5;       // EKKA MG N707TS (����) HTTP
  EKKA_E810T=6;      // EKKA IKCE810T
  EKKA_VIRTUAL=7;    // EKKA - �����������

  { --- ��������� ����� --- }
  KEY_O=0;// ��������
  KEY_W=1;// ������
  KEY_X=2;// X-�����
  KEY_Z=4;// �-�����
  KEY_P=8;// ����������������

  { --- �������� �������� ����� --- }
  CH_SALE=1;    // ��������� ���
  CH_BACK=2;    // ���������� ���
  CH_SERVICE=3; // ��������� ���

  { --- ������ ��� IKC-E810T --- }
  P_CASHIRER=0;//������ �������
  P_PROGRAMMING=0;//������ ����������������
  P_REPORTS=0;//������ �������
  CAN_NOT_CONNECT_TO_EKKA = '�� ���� ������������ � ����';
  EE_KASS=0;
  EE_BAL=1;
  EE_ALL=2;

procedure PrinterResults(const rt:RetData) stdcall;
function GetStatus(hWin:HWND;fun:TMathFunc;par:LPARAM;int1:BOOL):integer;stdcall;external'fpl.dll' name'GetStatus';
function GetDiagnosticInfo(hWin:HWND;fun:TMathFunc;par:LPARAM;Calc:BOOL):integer;stdcall;external'fpl.dll' name'GetDiagnosticInfo';
function GetDateTime(hWin:HWND;fun:TMathFunc;par:LPARAM):integer;stdcall;external'fpl.dll' name'GetDateTime';
function GetLastReceipt(hWin:HWND;fun:TMathFunc;par:LPARAM):integer;stdcall;external'fpl.dll' name'GetLastReceipt';
function DayInfo(hWin:HWND;fun:TMathFunc;par:LPARAM):integer;stdcall;external'fpl.dll' name'DayInfo';
function SetDateTime(hWin:HWND;fun:TMathFunc;par:LPARAM;Date:LPSTR;Time:LPSTR):integer;stdcall;external'fpl.dll' name'SetDateTime';
function OpenFiscalReceipt(hWin:HWND;fun:TMathFunc;par:LPARAM;i1:DWORD;i2:LPSTR;i3:DWORD;i4:BOOL):integer;stdcall;external'fpl.dll' name'OpenFiscalReceipt';
function ResetReceipt(hWin:HWND;fun:TMathFunc;par:LPARAM):integer;stdcall;external'fpl.dll' name'ResetReceipt';
function OpenRepaymentReceipt(hWin:HWND;fun:TMathFunc;par:LPARAM;i1:DWORD;i2:LPSTR;i3:DWORD;i4:BOOL):integer;stdcall;external'fpl.dll' name'OpenRepaymentReceipt';
function RegisterItem(hWin:HWND;fun:TMathFunc;par:LPARAM;n:LPSTR;n1:char;n2:double;n3:double):integer;stdcall;external'fpl.dll' name'RegisterItem';
function InitFPport(int1,int2:integer):integer;stdcall;external'fpl.dll' name'InitFPport';
function CloseFPport():integer;stdcall;external'fpl.dll' name'CloseFPport';
function PrintDiagnosticInfo(hWin:HWND;fun:TMathFunc;par:LPARAM):integer;stdcall;external'fpl.dll' name'PrintDiagnosticInfo';
function SetDecimals(int1:integer):integer;stdcall;external'fpl.dll' name'SetDecimals';
function SubTotal(hWin:HWND;fun:TMathFunc;par:LPARAM;n1:BOOL;n2:BOOL;n3:double;n4:double):integer;stdcall;external'fpl.dll' name'SubTotal';
function Total(hWin:HWND;fun:TMathFunc;par:LPARAM;n1:LPSTR;n2:char;n3:double):integer;stdcall;external'fpl.dll' name'Total';
function CloseFiscalReceipt(hWin:HWND;fun:TMathFunc;par:LPARAM):integer;stdcall;external'fpl.dll' name'CloseFiscalReceipt';
function FiscalClosure(hWin:HWND;fun:TMathFunc;par:LPARAM;n:LPSTR;s:char):integer;stdcall;external'fpl.dll' name'FiscalClosure';
function ServiceInputOutput(hWin:HWND;fun:TMathFunc;par:LPARAM;sum:Double):integer;stdcall;external'fpl.dll' name'ServiceInputOutput';
function PrintFiscalMemoryByNum(hWin:HWND;fun:TMathFunc;par:LPARAM;psw:LPSTR;n1:integer;n2:integer):integer;stdcall;external'fpl.dll' name'PrintFiscalMemoryByNum';
function PrintFiscalMemoryByDate(hWin:HWND;fun:TMathFunc;par:LPARAM;psw:LPSTR;d1:LPSTR;d2:LPSTR):integer;stdcall;external'fpl.dll' name'PrintFiscalMemoryByDate';
function PrintReportByNum(hWin:HWND;fun:TMathFunc;par:LPARAM;psw:LPSTR;n1:integer;n2:integer):integer;stdcall;external'fpl.dll' name'PrintReportByNum';
function PrintReportByDate(hWin:HWND;fun:TMathFunc;par:LPARAM;psw:LPSTR;d1:LPSTR;d2:LPSTR):integer;stdcall;external'fpl.dll' name'PrintReportByDate';
function OpenDrawer(hWin:HWND;fun:TMathFunc;par:LPARAM):integer;stdcall;external'fpl.dll' name'OpenDrawer';
function PrintFiscalText(hWin:HWND;fun:TMathFunc;par:LPARAM;int1:LPSTR):integer;stdcall;external'fpl.dll' name'PrintFiscalText';
function SaleArticle(hWin:HWND;fun:TMathFunc;par:LPARAM;sign:Boolean;numart:integer;qwant,perc,dc:double):integer;stdcall;external'fpl.dll' name'SaleArticle';
function SaleArticleAndDisplay(hWin:HWND;fun:TMathFunc;par:LPARAM;sign:Boolean;numart:integer;qwant,perc,dc:double):integer;stdcall;external'fpl.dll' name'SaleArticleAndDisplay';
function ProgrammingArticle(hWin:HWND;fun:TMathFunc;par:LPARAM;nal:char;gr:integer;cod:integer;Sena:double;pass:LPSTR;name:LPSTR):integer;stdcall;external'fpl.dll' name'ProgrammingArticle';
function DeleteArticle(hWin:HWND;fun:TMathFunc;par:LPARAM;cod:integer;pass:LPSTR):integer;stdcall;external'fpl.dll' name'DeleteArticle';
function ChangeArticlePrice(hWin:HWND;fun:TMathFunc;par:LPARAM;cod:integer;sena:Double;pass:LPSTR):integer;stdcall;external'fpl.dll' name'ChangeArticlePrice';
function SetOperatorName(hWin:HWND;fun:TMathFunc;par:LPARAM;i1:DWORD;i2:LPSTR;i3:LPSTR):integer;stdcall;external'fpl.dll' name'SetOperatorName';
function GetFiscalClosureStatus(hWin:HWND;fun:TMathFunc;par:LPARAM;i1:BOOL):integer;stdcall;external'fpl.dll' name'GetFiscalClosureStatus';
function MakeReceiptCopy(hWin:HWND;fun:TMathFunc;par:LPARAM;i1:Char):integer;stdcall;external'fpl.dll' name'MakeReceiptCopy';
function SetHeaderFooter(hWin:HWND;fun:TMathFunc;par:LPARAM;i1:Integer;S:LPSTR):integer;stdcall;external'fpl.dll' name'SetHeaderFooter';
function PrintNonfiscalText(hWin:HWND;fun:TMathFunc;par:LPARAM;int1:LPSTR):integer;stdcall;external'fpl.dll' name'PrintNonfiscalText';
function OperatorsReport(hWin:HWND;fun:TMathFunc;par:LPARAM;ps:LPSTR):integer;stdcall;external'fpl.dll' name'OperatorsReport';
function GetCurrentTaxes(hWin:HWND;fun:TMathFunc;par:LPARAM;int1:Integer):integer;stdcall;external'fpl.dll' name'GetCurrentTaxes';
function DisplayTextLL(hWin:HWND;fun:TMathFunc;par:LPARAM;S:LPSTR):integer;stdcall;external'fpl.dll' name'DisplayTextLL';
function DisplayTextUL(hWin:HWND;fun:TMathFunc;par:LPARAM;S:LPSTR):integer;stdcall;external'fpl.dll' name'DisplayTextUL';

function EKKA:TEKKA;

implementation

uses ShareU,QRGraphics,QR_Win1251,QR_URL;

var
  FEKKA:TEKKA=nil;
  ics:TIKC_E810T;

{ TEKKA }

function EKKA:TEKKA;
begin
  if FEKKA=nil then
    FEKKA:=TEKKA.Create(nil);
  Result:=FEKKA;
end;

procedure TEKKA.Gh;
//var Sum:Real;
begin
//  PrintNonfiscalText(0,PrinterResults,0,'������� ��� ������''�!');
//  fpFiscState;
//  OperatorsReport(0,PrinterResults,0,'0000');
//  fpActiveLogo(0);
//  CloseFiscalReceipt(0,PrinterResults,0);
{  if ProgrammingArticle(0,PrinterResults,0,'�',100,1,10.01,PAnsiChar(Passw[14]),'�������� N10')=0 then
   ShowMessage(FRD_Item[0]);}
end;

function GetNumZ:Integer;
var
  sl:TStringList;
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
var
  sl:TStringList;
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
var
  i:Integer;
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
var
  i:Integer;
begin
  EKKA.FLastError:='';
  EKKA.FRD_Item.Clear;
  for i:=Low(rt.RetItem)to High(rt.RetItem) do
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
//                                              if rt.Status and $00400000=$00400000 then EKKA.FLastError:='F_FISCALIZED' else
//                                                if rt.Status and $00004000=$00004000 then EKKA.FLastError:='F_MODULE_NUM' else
//                                                  if rt.Status and $00200000=$00200000 then EKKA.FLastError:='F_FORMATTED' else
//                                                    if rt.Status and $00800000=$00800000 then EKKA.FLastError:='F_SER_NUM' else
end;

constructor TEKKA.Create(AOwner:TComponent);
var i:Byte;
 begin
  inherited;
  FEmulEKKA:=False;
  IsAbort:=False;
  FIsConnected:=False;
  FBNumb_Chek:=-1;
  FNumVoidChek:='';
  TypeEKKA:=EKKA_MARRY301MTM;
  FCopy_Chek:=-1;
  FIsCopy:=False;
  FIsFLP:=False;
  for i:=Low(Passw)to High(Passw) do Passw[i]:='0000';
  curr_check:=TStringList.Create();
  FIPAddr:='';
  FDiscOnAllSum:=True;
  FGenNewNumbChek:=False;
  fForce:=0;
  fTypeChek:=0;
  fForceInOut:=0;
  FPrinterPRRO:='';
 end;

destructor TEKKA.Destroy;
 begin
  inherited;
 end;

function TEKKA.ErrorDescr(Code:string):string;
begin
  Result:=inherited ErrorDescr(Code);
  if Result=Code then
    if Code='SYNTAX_ERROR' then Result:='�������������� ������' else
      if Code='INVALID_CMD' then Result:='�������� �������' else
        if Code='INVALID_TIME' then Result:='���� � ����� �������' else
          if Code='PRINT_ERROR' then Result:='������ ������' else
            if Code='SUM_OVERFLOW' then Result:='�������������� ������������' else
              if Code='CMD_NOT_ALLOWED' then Result:='������� �� ���������' else
                if Code='RAM_CLEARED' then Result:='��������� ���' else
                  if Code='PRINT_RESTART' then Result:='������ ��� ��������' else
                    if Code='RAM_DESTROYED' then Result:='���������� ���������� � ���' else
                      if Code='PAPER_OUT' then Result:='����������� ������� ���/� ����������� �����' else
                        if Code='FISCAL_OPEN' then Result:='������ ���������� ���' else
                          if Code='NONFISCAL_OPEN' then Result:='������ ������������ ���' else
                            if Code='F_ABSENT' then Result:='�� ��������� ������ ����. ������' else
                              if Code='F_WRITE_ERROR' then Result:='������ ������ � ����. ������' else
                                if Code='F_FULL' then Result:='����. ������ �����������' else
                                  if Code='F_READ_ONLY' then Result:='������ � ����. ������ ���������' else
                                    if Code='F_CLOSE_ERROR' then Result:='������ ���������� �-������' else
                                      if Code='F_LESS_30' then Result:='� ����. ������ ���� ���������� ������������' else
                                        if Code='PROTOCOL_ERROR' then Result:='������ ���������' else
                                          if Code='NACK_RECEIVED' then Result:='������ NACK' else
                                            if Code='TIMEOUT_ERROR' then Result:='��� ������ �� ������������' else
                                              if Code='COMMON_ERROR' then Result:='����� ������' else
                                                if Code='ERROR_COM' then Result:='������ �������� Ole-�������' else
                                                  if TypeEKKA=EKKA_EXELLIO then Result:=FP.LastErrorText else
                                                    if TypeEKKA=EKKA_FP2000 then Result:=FP.LastErrorDescr;
end;

procedure TEKKA.fpClosePort;
//var
//  ics: TIKC_E810T;
begin
  if EmulEKKA then Exit;
  if not(UseEKKA) then Exit;

  FIsConnected:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:inherited;
    EKKA_DATECS3530T:CloseFPport;
    EKKA_EXELLIO:
      begin
        FP.ClosePort;
        FIsConnected:=False;
      end;
    EKKA_FP2000:
      begin
        FP.Disconnect;
        FIsConnected:=False;
      end;
    EKKA_N707:FIsConnected:=False;
    EKKA_E810T: begin//fpClosePort
                  FLastError:='';
                  try
                    try
                      if FIsConnected then
                        if not ics.FPClose then
                         //if not ics.fpReleaseUSBDevice then
                           raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                    finally
                      FIsConnected:=false;
                    end;
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                end;//fpClosePort
  end;
end;

function TEKKA.ReConnect:Boolean;
begin
  if (FLastError='TIMEOUT_ERROR')or(FIsConnected=False) then
  begin
    fpClosePort;
//    if EKKA.TypeEKKA=EKKA_E810T then
//    begin
//      if not FIsConnected then
//        FIsConnected:=fpConnect;
//      Result:=FIsConnected;
//    end
//    else
//    begin
      FIsConnected:=fpConnect;
      Result:=FIsConnected;
//    end;
  end
  else
    Result:=True;
end;

function TEKKA.fpLoadExellio:Boolean;
var
  Com,Enc:Variant;
begin
  case TypeEKKA of
    EKKA_EXELLIO:
      try
        FP:=CreateOleObject('ExellioFP.FiscalPrinter');
        Result:=True;
      except
        FLastError:='ERROR_COM';
        Result:=False;
      end;
    EKKA_FP2000:
      try
        Enc:=CreateOleObject('CashReg.Encoding');
        FP:=CreateOleObject('CashReg.ExellioFP2000');
        FP.ComPortName:='COM'+IntToStr(PortNum);
        FP.SetRecommendedPortSettings;
        FP.ComBaudRate:=115200;
        FP.ComEncoding:=Enc.GetEncodingOfCodePage(1251);
        Result:=True;
      except
        FLastError:='ERROR_COM';
        Result:=False;
      end;
  else
    Result:=True;
  end;
{
  if TypeEKKA=EKKA_EXELLIO then
    try
      FP:=CreateOleObject('ExellioFP.FiscalPrinter');
      Result:=True;
    except
      FLastError:='ERROR_COM';
      Result:=False;
    end
  else
    if TypeEKKA=EKKA_FP2000 then
      try
//      Com:=CreateOleObject('CashReg.COMPort');
        Enc:=CreateOleObject('CashReg.Encoding');
        FP:=CreateOleObject('CashReg.ExellioFP2000');
        FP.ComPortName:='COM'+IntToStr(PortNum);
        FP.SetRecommendedPortSettings;
        FP.ComBaudRate:=115200;
        FP.ComEncoding:=Enc.GetEncodingOfCodePage(1251);
//        FP.SetComPort(Com);
        Result:=True;
      except
        FLastError:='ERROR_COM';
        Result:=False;
      end
    else
      Result:=True;
}
end;

procedure TEKKA.SaveRegisters;
var
  SL:TStringList;
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
var
  S:string;
  i:Integer;
begin
  case TypeEKKA of
    EKKA_EXELLIO:if FP.LastError<>0 then
      begin
        FLastError:=FP.LastError;
        Result:=False;
      end
      else
      begin
        FLastError:='';
        Result:=True;
      end;
    EKKA_FP2000:if VarArrayHighBound(FP.LastError,1)<>-1 then
      begin
        FLastError:=FP.LastErrorDescr;//'ERFP2000';// FP.LastError;
        Result:=False;
      end
      else
      begin
        FLastError:='';
        Result:=True;
      end;
  else
    Result:=True;
  end;
{
  if TypeEKKA=EKKA_EXELLIO then
  begin
    if FP.LastError<>0 then
    begin
      FLastError:=FP.LastError;
      Result:=False;
    end
    else
    begin
      FLastError:='';
      Result:=True;
    end;
  end
  else
    if TypeEKKA=EKKA_FP2000 then
    begin
      if VarArrayHighBound(FP.LastError,1)<>-1 then
      begin
        FLastError:=FP.LastErrorDescr; //'ERFP2000';// FP.LastError;
//      S:='';
//      for i:=0 to VarArrayHighBound(FP.LastError,1) do
//       begin
//        S:=S+FP.LastError[i]+' | ';
//       end;
        Result:=False;
      end
      else
      begin
        FLastError:='';
        Result:=True;
      end;
    end
    else
      Result:=True;
}
end;

function TEKKA.fpConnect:Boolean;
var
  status_N707:TStatusN707;
  Res:Integer;
//  r1,r2:boolean;
//  ikc: OleVariant;
begin
  if EmulEKKA then
   begin
    FVzhNum:=FKassaID+100100;
    FVzhNumS:=IntToStr(FVzhNum);
    Result:=True;
    Exit;
   end;

  if (not(UseEKKA))or(EmulEKKA=True) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpConnect;
    EKKA_DATECS3530T:
      begin
        try
          Result:=InitFPport(PortNum,19200)>0;
          if not Result then Abort;
          CancelFiscalReceipt;
          try
            FIsConnected:=True;
            Result:=fpGetStatus;
          finally
            FIsConnected:=False;
          end;

          if not Result then Exit;
//                        ShowMessage(FVZhNumS);
          FVZhNumS:=FRD_Item[0];
          if Length(FRD_Item[1])<>10 then Abort;
          FVZhNum:=StrToInt64(FRD_Item[1]);
          FFN:=StrToInt64(FRD_Item[1]);
//                         Result:=(SetOperatorName(0,PrinterResults,0,1,PAnsiChar(Passw[1]),PAnsiChar(Copy(Kassir,1,24)))=0) and (FLastError='');
          if not Result then Abort;
          FIsConnected:=True;
        except
          FIsConnected:=False;
          if FLastError='' then FLastError:='TIMEOUT_ERROR';
        end;
      end;
    EKKA_EXELLIO:
      begin
        try
          FP.OpenPort('COM'+IntToStr(PortNum),115200);
          Result:=FP.LastError=0;
          if not Result then FLastError:=FP.LastError;
          if not Result then Abort;
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
    EKKA_FP2000:
      begin
        try
          FP.Connect;
          Result:=VarArrayHighBound(FP.LastError,1)=-1;
          if not Result then Abort;
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
    EKKA_N707:
      begin//fpConnect
        try
          FIsConnected:=True;
          Result:=fpGetStatus;
        except
          FIsConnected:=False;
          if FLastError='' then FLastError:='TIMEOUT_ERROR';
          exit;
        end;
        FLastError:='';
        status_N707:=GetStatusN707(IPAddr);
        if status_N707.ErrorCode='' then //��� ������
        begin
          FVzhNum:=StrToInt64(status_N707.dev_fn);//status_N707.dev_id;
          FVzhNumS:=status_N707.dev_zn;
          FFn:=StrToInt64(status_N707.dev_fn);
          FLastError:='';
        end
        else //������
        begin
          Res:=-1;
          FLastError:=trim(status_N707.ErrorCode+' '+status_N707.ErrorDescription);
        end;
      end;
    EKKA_E810T: begin//fpConnect
                  FLastError:='';
                  try
                     if not FIsConnected then
                      begin
                        if not ics.FPInitialize=0 then
                         raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));

                        if not ics.FPOpen(IntToStr(PortNum)) then
                         //if not ics.FPClaimUSBDevice then
                          raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));

                        if (ics.prPrinterError)or(ics.prTapeNearEnd)or(ics.prTapeEnded) then
                          raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                        if not ics.FPGetCurrentStatus then
                          raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));

                        if not ics.ModemInitialize(PortNum)=0 then
                          raise Exception.Create('������ ������ '+IntToStr(ics.prGetModemErrorCode)+': '+ics.prGetModemErrorText);
//                        if not ics.ModemUpdateStatus then
//                          raise Exception.Create('������ ������ '+IntToStr(ics.prGetModemErrorCode)+': '+ics.prGetModemErrorText+' ��� ������ ������ '+IntToStr(ics.stModemFailCode));
                        FVzhNum:=StrToInt64(ics.prFiscalNumber);
                        FVzhNumS:=ics.prSerialNumber;
                        FFN:=StrToInt64(ics.prFiscalNumber);
                        Result:=True;
                        FIsConnected:=true;
                      end else raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                end;//fpConnect
    EKKA_VIRTUAL:begin
                  FLastError:='';
                  try

                   QrEx.Close;
                   QrEx.SQL.Text:='select ecr.GetValue(''FN''+convert(varchar,'+IntToStr(KassaID)+')) as Fn';
                   QrEx.Open;
                   FVZhNumS:=QrEx.FieldByName('Fn').AsString;
                   FFn:=StrToInt64(FVZhNumS);
                   FVZhNum:=FFn;

                   FDatePOEx:='20210101';
                   FLastError:='';
                   FIsConnected:=True;
                   Result:=True;
                  except
                   on E:Exception do
                    begin
                     Result:=False;
                     FIsConnected:=False;
                     FLastError:=E.Message;
                    end
                  end;
                 end;
  end;
end;

function TEKKA.GetLastServiceShiftValue(ConnectStr:string):double;
{
var
  rec_id: string;
  sum_out: Currency;
  qrZ_insertion: TADOQuery;
  ADOC: TADOConnection;
}
begin
  Result:=0;
  if length(trim(ConnectStr))=0 then exit;
  with TADOQuery.Create(self) do
  begin
    ConnectionString:=ConnectStr;
    CommandTimeout:=3000;
    try
      SQL.Clear;
      SQL.Add('use APTEKA_NET');
      SQL.Add('');
      SQL.Add('select');
      SQL.Add('  count (rec_id) as rec_cnt');
      SQL.Add('from');
      SQL.Add('  journ_insertion');
      SQL.Add('where');
      SQL.Add('  vzh = '+IntToStr(N707Status.dev_id));
      SQL.Add('  and fn = '+N707Status.dev_fn);
      SQL.Add('  and id_kassa = '+IntToStr(FKassaID));
      SQL.Add('  and dt_insertion is null');
      SQL.Add('  and is_inserted is null');
      SQL.Add('');
      Open;
      if FieldByName('rec_cnt').AsInteger<=0 then
      begin
        Result:=0;
      end
      else
      begin
        SQL.Clear;
        SQL.Add('use APTEKA_NET');
        SQL.Add('');
        SQL.Add('declare @max_date_z datetime');
        SQL.Add('set @max_date_z = (');
        SQL.Add('  select ');
        SQL.Add('    max(date_z)');
        SQL.Add('  from ');
        SQL.Add('    journ_insertion');
        SQL.Add('  where ');
        SQL.Add('    dt_insertion is null ');
        SQL.Add('    and is_inserted is null');
        SQL.Add('    and vzh = '+IntToStr(N707Status.dev_id));
        SQL.Add('    and fn = '''+N707Status.dev_fn+'''');
        SQL.Add('    and id_kassa = '+IntToStr(FKassaID));
        SQL.Add(')');
        SQL.Add('');
        SQL.Add('select');
        SQL.Add('  sum_out');
        SQL.Add('from');
        SQL.Add('  journ_insertion');
        SQL.Add('where');
        SQL.Add('  dt_insertion is null');
        SQL.Add('  and is_inserted is null');
        SQL.Add('  and vzh = '+IntToStr(N707Status.dev_id));
        SQL.Add('  and fn = '''+N707Status.dev_fn+'''');
        SQL.Add('  and id_kassa = '+IntToStr(FKassaID));
        SQL.Add('  and date_z = @max_date_z');
        //SQL.Add('  and num_z = @max_num_z');
        SQL.Add('');
        //sql.SaveToFile('1234');
        Open;
        Result:=FieldByName('sum_out').AsCurrency;
      end;
    finally
      Free;
    end;
  end;
end;

function TEKKA.GetServiceShift(ConnectStr:string;var ErrCode,ErrDescription:string):boolean;
var
  rec_id:string;
  sum_out:Currency;
  qrZ_insertion:TADOQuery;
  ADOC:TADOConnection;
begin
  ErrCode:='';
  ErrDescription:='';
  Result:=true;
  rec_id:='';
  sum_out:=0;
  try
    ADOC:=TADOConnection.Create(nil);
    ADOC.ConnectionTimeout:=300;
    ADOC.LoginPrompt:=false;
    ADOC.Provider:='SQLOLEDB.1';
    ADOC.ConnectionString:=EKKA.ConnectString;
    try
      qrZ_insertion:=TADOQuery.Create(nil);
      qrZ_insertion.CommandTimeout:=3000;
      qrZ_insertion.Connection:=ADOC;
      with qrZ_insertion do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select ');
        SQL.Add('  count(rec_id) as Records_Count, convert(uniqueidentifier,rec_id) as rec_id');
        SQL.Add('from ');
        SQL.Add('  APTEKA_NET.dbo.journ_insertion');
        SQL.Add('where');
        SQL.Add('  vzh = '+IntToStr(N707Status.dev_id));
        SQL.Add('  and fn = '+N707Status.dev_fn);
        SQL.Add('  and id_kassa = '+IntToStr(FKassaID));
        SQL.Add('  and dt_insertion is null');
        SQL.Add('  and is_inserted is null');
        SQL.Add('');
        SQL.Add('group by');
        SQL.Add('  rec_id');
        Open;
        if FieldByName('Records_Count').Value>0 then rec_id:=FieldByName('rec_id').Value else rec_id:='00000000-0000-0000-0000-000000000000';
        if length(trim(rec_id))>0 then
        begin
          Close;
          SQL.Clear;
          SQL.Add('exec spY_Z_insertion 3, '''+FormatDateTime('YYYY-MM-DD HH:MM:SS',now())+''', 0, '+IntToStr(FKassaID)+', '+IntToStr(N707Status.dev_id)+', '''+N707Status.dev_fn+''', 0, '''+FormatDateTime('YYYY-MM-DD HH:MM:SS',now())+''', 1, '''+rec_id+'''');
          Open;
          if not FieldByName('sum_out').IsNull then sum_out:=FieldByName('sum_out').Value else sum_out:=0;

          if (sum_out>0)and(EKKA.TypeEKKA=EKKA_N707) then
            EKKA.fpCashInput(sum_out)
          else
            fpZeroCheck;

          Close;
          SQL.Clear;
          SQL.Add('exec spY_Z_insertion 2, '''+FormatDateTime('YYYY-MM-DD HH:MM:SS',now())+''', 0, '+IntToStr(FKassaID)+', '+IntToStr(N707Status.dev_id)+', '''+N707Status.dev_fn+''', 0, '''+FormatDateTime('YYYY-MM-DD HH:MM:SS',now())+''', 1, '''+rec_id+'''');
          ExecSQL;
        end
        else
          ShowMessage('��������� �������� �� �����������');
      end;
    finally
      qrZ_insertion.Free;
    end;
  finally
    ADOC.Free;
  end;
end;

{
procedure TEKKA.SetviceShiftNotification(const check: TChkNomber);
begin
  if (length(trim(check.ErrCode))>0)or(check.ChkNumber <= 0) then
    MessageDlg('������� ����� ������.'+#13+
               '������ ����� �������� �� ��������!'+#13+
               '��� �������������� ����������� ������ �����'+#13+
               '���������� ������� ������� �����.'+#13+
               ''+#13+
               '�������� ���� "���������" => "������ (Z,X, ��������/������)..." '+#13+
               '� ������� ���� ��������� � ������������ "������� ���" '+#13+
               '��� �������� ��������� �������� � ������� ����� ���������� �������.',mtWarning,[mbOK],0);
end;
}
{
function TEKKA.SetviceShiftNotification: integer;
begin
//
end;
}

function TEKKA.fpGetStatus:Boolean;
var
  ri:TStringList;
  sm,DatePO,Ver,S,ss:string;
  i:Integer;
  chk_number:TChkNomber;//����� ����������� ���� � ��������� ������ ��� ��� ���������
  ErrCode,ErrMess:string;
  msg:string;
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

  if not(UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpGetStatus;
    EKKA_DATECS3530T:
      begin
        try
          Result:=ReConnect;
          if not Result then Exit;
          Result:=(GetDiagnosticInfo(0,PrinterResults,0,False)=0)and(FLastError='');
          if not Result then Abort;
          ri:=TStringList.Create;
          try
            Ver:=FRD_Item[0];
            DatePO:=FRD_Item[1];
            ri.Clear;
            ri.Add(FRD_Item[6]);// ��� ����� (������� ����������)
            ri.Add(FRD_Item[7]);// ���������� �����
            ri.Add('');// ������������ � ����� ����������� (������ �����)
            Result:=(GetDateTime(0,PrinterResults,0)=0)and(FLastError='');
            if not Result then Abort;
            S:=FRD_Item[0];
            ri.Add('20'+Copy(S,7,2)+Copy(S,4,2)+Copy(S,1,2));
            S:=FRD_Item[1];
            if Length(S)>=8 then
              ri.Add(Copy(S,1,2)+Copy(S,4,2)+Copy(S,7,2))
            else
              ri.Add(Copy(S,1,2)+Copy(S,4,2)+'00');
            ri.Add('1');// ��������� ���������� ����� (������ 1)
            ri.Add('1');// ������� �������� ������� (������ 1)
            ri.Add('1');// ������� ������������������� ������� (������ 1)
            ri.Add('    ');
            if not fpCashState(0) then Abort;
{
                            Result:=(GetCurrentTaxes(0,PrinterResults,0,1)=0) and (FLastError='');
                            if Not Result then Exit;
}
//                            ShowMessage(CurrToStrF((StrToInt(FRD_Item[3])-StrToInt(FRD_Item[4])+StrToInt(FRD_Item[6])-StrToInt(FRD_Item[7]))*0.01,ffFixed,2));
            if (StrToInt(FRD_Item[3])-StrToInt(FRD_Item[4])+StrToInt(FRD_Item[6])-StrToInt(FRD_Item[7]))*0.01<=0 then sm:='1' else sm:='0';
            ri.Add('');
            Result:=(DayInfo(0,PrinterResults,0)=0)and(FLastError='');
            if not Result then Abort;
            if sm='0' then
              ri.Add(IntToStr(StrToInt(RD_Item[4])+1))// ����� ���������� �-������
            else
              ri.Add(RD_Item[4]);
            Result:=(GetLastReceipt(0,PrinterResults,0)=0)and(FLastError='');
            if not Result then Abort;
            ri.Add(RD_Item[0]);// ����� ���������� ����������� ����
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
    EKKA_EXELLIO:
      begin
        try
          Result:=ReConnect;
          if not Result then Exit;
          ri:=TStringList.Create;
          try
            ri.Clear;
            ri.Add(IntToStr(FFn));
            ri.Add(IntToStr(FFn));
            ri.Add('');
            FP.GetDateTime;
            if not CheckErrorExellio then Abort;
            ri.Add('20'+Copy(FP.s1,7,2)+Copy(FP.s1,4,2)+Copy(FP.s1,1,2));
            ri.Add(Copy(FP.s1,10,2)+Copy(FP.s1,13,2)+Copy(FP.s1,16,2));
            ri.Add('1');// ��������� ���������� ����� (������ 1)
            ri.Add('1');// ������� �������� ������� (������ 1)
            ri.Add('1');// ������� ������������������� ������� (������ 1)
            ri.Add('    ');
            FP.GetSmenLen;
//                        SaveRegisters;
            if not CheckErrorExellio then Abort;
            if FP.s1='Z' then sm:='1' else sm:='0';
//                        ri.Add(Chr(StrToInt(sm)));
            ri.Add('');
            FP.LastFiscalClosure(0);
            if not CheckErrorExellio then
            begin
{                          FP.GetLastReceiptNum;
                          if Not CheckErrorExellio then Abort;
                          ss:=FP.s1;}
              ss:=IntToStr(GetNumZ);
            end
            else
              ss:=FP.s1;
            if sm='0' then
              ri.Add(IntToStr(StrToInt(ss)+1))
            else
              ri.Add(ss);
            FP.GetLastReceiptNum;
            if not CheckErrorExellio then Abort;
            ri.Add(FP.s1);// ����� ���������� ����������� ����
            FP.GetDiagnosticInfo(False);
            if not CheckErrorExellio then Abort;
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
    EKKA_FP2000:
      begin
        try
          Result:=ReConnect;
          if not Result then Exit;
          ri:=TStringList.Create;
          try
            ri.Clear;
            ri.Add(IntToStr(FFn));
            ri.Add(IntToStr(FFn));
            ri.Add('');
            ri.Add(FormatDateTime('yyyymmdd',FP.GetDateTime));
            ri.Add(FormatDateTime('hhnnss',FP.GetDateTime));
            if not CheckErrorExellio then Abort;
            ri.Add('1');// ��������� ���������� ����� (������ 1)
            ri.Add('1');// ������� �������� ������� (������ 1)
            ri.Add('1');// ������� ������������������� ������� (������ 1)
            ri.Add('    ');
            if FP.GetShiftStatus.IsOpen then sm:='0' else sm:='1';
//                       SaveRegisters;
            if not CheckErrorExellio then Abort;
            ri.Add('');
            ss:=IntToStr(FP.GetLastZReportInfo.ReportNumber);
            if not CheckErrorExellio then
            begin
              if Pos(AnsiUpperCase('���������� ������� ����������� � ������� ���������� ������ ������'),AnsiUpperCase(LastErrorDescr))<>0 then
                ss:='0'
              else
                Abort;
            end;
            if sm='0' then
              ri.Add(IntToStr(StrToInt(ss)+1))
            else
              ri.Add(ss);
{                       FP.GetLastReceiptNum;
                       if Not CheckErrorExellio then Abort;
}
            ri.Add(FP.GetLastCheckNumber);// ����� ���������� ����������� ����
            if not CheckErrorExellio then Abort;
            ri.Add('    ');
            ri.Add(FP.ProgramVersion);
            ri.Add(FDatePOEx);
            ri.Add('');
            ri.Add(FDatePOEx);
            if not CheckErrorExellio then Abort;
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
    EKKA_N707:
      begin//fpGetStatus
        ErrCode:='';
        ErrMess:='';
        try
          EKKA.FLastError:='';
          N707Status:=GetStatusN707(IPAddr);
          if N707Status.IsError then //�����-�� ������ :(
          begin
            if N707Status.HTTPCode<>200 then //������ ����� �� http
              FLastError:=trim(N707Status.ErrorCode+' '+N707Status.ErrorDescription)
            else
              if N707Status.ErrorCode<>'' then //������ N707
                FLastError:=trim(N707Status.ErrorCode+' '+N707Status.ErrorDescription)
              else
                FLastError:='N707 ������ IsError=true. ���� ������ ���. '+N707Status.ErrorCode+' '+N707Status.ErrorDescription;
            Result:=false;
          end
          else // ��� ������
          begin
            ri:=TStringList.Create;
            try
              ri.Clear;
              ri.Add(N707Status.dev_zn);//��������� �����
              ri.Add(N707Status.dev_fn);//���������� �����
              try
                EKKA.FFN:=StrToInt64(N707Status.dev_fn);
              except
                EKKA.FFN:=0;
              end;
              ri.Add('');// ������������ � ����� ����������� (������ �����)
              ri.Add(FormatDateTime('YYYYMMDD',N707Status.dt));//����
              ri.Add(FormatDateTime('HHMMSS',N707Status.tm));//�����
              ri.Add('1');// ��������� ���������� ����� (������ 1)
              ri.Add('1');// ������� �������� ������� (������ 1)
              ri.Add('1');// ������� ������������������� ������� (������ 1)
              ri.Add('    ');

              if N707Status.Used>0 then
                ri.Add('1')
              else
                ri.Add('0');
                           //ri.Add(IntToStrF(N707Status.Used,0));  //������� ���������� ����������� ������(�-������)
              ri.Add(N707Status.currZ);
(*
                         if N707Status.Used=1 then
                         begin
                           ri.Add('1');  //������� ���������� ����������� ������(�-������)
                           ri.Add(N707Status.currZ);
                         end
                         else
                         begin
                           ri.Add('0');
                           ri.Add(IntToStr(StrToInt(N707Status.currZ)+1));
                         end;
*)
              chk_number:=GetLastChkNo(IPAddr);// ����� ���������� ����������� ����
              if trim(chk_number.ErrCode)='' then //��� ������
                ri.Add(IntToStr(chk_number.ChkNumber))
              else //������
              begin
                FLastError:=trim(chk_number.ErrCode+' '+chk_number.ErrMessage);
                raise Exception.Create(FLastError);
              end;
              ri.Add('    ');
              ri.Add(N707Status.dev_ver);
              ri.Add(N707Status.dev_dat);
              ri.Add('');
              ri.Add(N707Status.dev_dat);
              ri.Add('2');
              ri.Add('���');
              FRD_Item.Text:=ri.Text;
              Result:=True;
              FLastError:='';
            finally
              ri.Free;
            end;
          end;
        except
          Result:=False;
          if FLastError='' then FLastError:=trim(chk_number.ErrCode+' '+chk_number.ErrMessage);
          if (length(trim(FLastError))>0)or(chk_number.ChkNumber<=0) then
          begin
            msg:='������� ����� ������.'+#13+
              '������ ����� �������� �� ��������!'+#13+
              '��� �������������� ����������� ������ �����'+#13+
              '���������� ������� ������� �����.'+#13+
              ''+#13+
              '����� ������� ������� �����'+#13+
              '�������� ���� "���������" => "������ (Z,X, ��������/������)..." '+#13+
              '� ������� ���� ��������� � ������������ "������� ���" '+#13+
              '��� �������� ��������� �������� � ������� ����� '+#13+
              '���������� ��������������� �������.'+#13+
              ''+#13+
              '�������������� ������� ������������ ������������� '+#13+
              '�� ����� ������ �-������.'+#13+
              '�������������� ������� ����������'+#13+
              '����� ���������� ���������� ������� �� ���� ������ ���������� '+FloatToStrF(GetLastServiceShiftValue(ConnectString),12,2)+' ���.';
            MessageDlg(msg,mtWarning, [mbOK],0);
          end;
        end;
      end;
    EKKA_E810T: begin//fpGetStatus
                  FLastError:='';
                  try
                    //Result:=ReConnect;
                    if not FIsConnected then fpConnect;
                    if FIsConnected then
                    begin
                      if not ics.FPGetCurrentDate then
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                      if not ics.FPGetCurrentTime then
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                      if not ics.FPGetDayReportProperties then
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                      if not ics.ModemUpdateStatus then
                        raise Exception.Create('������ ������ '+IntToStr(ics.prGetModemErrorCode)+': '+ics.prGetModemErrorText+' ��� ������ ������ '+IntToStr(ics.stModemFailCode));
                      if not ics.FPGetCurrentStatus then
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                      try
                        ri:=TStringList.Create;
                        ri.Clear;
                        ri.Add(ics.prSerialNumber);   //0 ��������� �����
                        ri.Add(ics.prFiscalNumber);   //1 ���������� �����
                        ri.Add('    ');                   //2 ������������ � ����� ����������� (������ �����)
                        ri.Add(FormatDateTime('YYYYMMDD',ics.prCurrentDate));   //3 ����
                        ri.Add(FormatDateTime('HHMMSS',ics.prCurrentTime));     //4 �����
                        ri.Add(chr(1)); //5 ��������� ���������� ����� (������ 1)
                        ri.Add('1'); //6 ������� ��������� ������� (������ 1)
                        ri.Add('1'); //7 ������� ������������������� ������� (������ 1)
                        ri.Add('    '); //8 ������������� ������������������� �������

                        if ics.stFiscalDayIsOpened then sm:='0' else sm:='1'; //9 ������� ���������� ����������� ������(�-������)
                        ri.Add('');
                        if ics.stFiscalDayIsOpened then ri.Add(IntToStr(ics.prCurrentZReport)) else ri.Add(IntToStr(ics.prCurrentZReport-1)); //10 ����� ����������� ��������� ����

                        ri.Add(IntToStr(ics.stModemPID_LastWrite));//11 ����� ���������� ������� ���������� ����
                        ri.Add('');//12 ������������� ��������� ������� ����������� �������
                        ri.Add(ics.prHardwareVersion);//13 ������������� ������ �� ����;
                        ri.Add('');//14 ���� �������� ������ �� ���� � ������� ��������;
                        ri.Add('');//15 ������� �������������� ������ ����
                        ri.Add(FormatDateTime('YYYYMMDD',ics.prDateFiscalization));//16 ���� ���������������� ������ ���� � ������� ��������
                        ri.Add('2');//17 ���������� ������ ����� ���������� ����� � ����������� ����
                        ri.Add('���');//18 ����������� ������������ ������ ����
                        FRD_Item.Text:=ri.Text;
                        FRD_Item[9]:=Chr(StrToInt(sm));
                        Result:=True;
                        FLastError:='';
                      finally
                        ri.Free;
                      end;
                    end
                    else
                      raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                end;//fpGetStatus
    EKKA_VIRTUAL:begin
                  Result:=ReConnect;
                  FLastError:='';
                  try
                   QrEx.Close;
                   QrEx.SQL.Text:='exec ecr.spY_GetStatus '+IntToStr(KassaID);
                   QrEx.Open;
//                   10,10,36,8,6,1,1,1,4,1,12,12,4,4,8,18,8,1,3

                   ri:=TStringList.Create;
                   try
                    ri.Clear;
                    ri.Add(IntToStr(FFn));
                    ri.Add(IntToStr(FFn));
                    ri.Add('');
                    ri.Add(QrEx.FieldByName('date').AsString);
                    ri.Add(QrEx.FieldByName('time').AsString);
                    ri.Add('1');// ��������� ���������� ����� (������ 1)
                    ri.Add('1');// ������� �������� ������� (������ 1)
                    ri.Add('1');// ������� ������������������� ������� (������ 1)
                    ri.Add('    ');
                    if QrEx.FieldByName('SmenaOpen').AsInteger=1 then sm:='0' else sm:='1';
                    ri.Add('');
                    ri.Add(QrEx.FieldByName('LastNumZ').AsString); // ����� ���������� �-������
                    ri.Add(QrEx.FieldByName('LastNCh').AsString); // ����� ���������� ����
                    ri.Add('    ');
                    ri.Add('PRRO'); // ������ ����
                    ri.Add(FDatePOEx); // ������ ����
                    ri.Add('    ');
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
                   on E:Exception do
                    begin
                     Result:=False;
                     FLastError:=E.Message;
                     if FLastError='' then FLastError:='ERP_9995';
                    end; 
                  end;
                 end;
  end;
end;

function TEKKA.fpSetTime(T:TDateTime):Boolean;
var
  D:string;
  ErrCode,ErrDescr:string;
begin
  if (not(UseEKKA)or(EmulEKKA=True)) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpSetTime(T);
    EKKA_DATECS3530T:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        Result:=(GetDateTime(0,PrinterResults,0)=0)and(FLastError='');
        if not Result then Exit;
        D:=FRD_Item[0];
        Result:=(SetDateTime(0,PrinterResults,0,PAnsiChar(D),PAnsiChar(FormatDateTime('hh:nn:ss',T)))=0)and(FLastError='');
      end;
    EKKA_EXELLIO:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        FP.SetDateTime(FormatDateTime('dd-mm-yy',T),FormatDateTime('hh:nn',T));
        Result:=CheckErrorExellio;
      end;
    EKKA_FP2000:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        FP.SetDateTime(T);
        Result:=CheckErrorExellio;
      end;
    EKKA_N707:
      begin//fpSetTime
        EKKA.FLastError:='';
        if SetClock(T,ErrCode,ErrDescr,IPAddr) then
        begin
          Result:=true;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescr);
        end;
      end;
    EKKA_E810T: begin//fpSetTime
                  FLastError:='';
                  try
                    //Result:=ReConnect;
                    if FIsConnected then
                    begin
                      Result:=ics.FPSetCurrentTime(T);
                      if not Result then
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                    end
                    else
                      raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                end;//fpSetTime
  end;
end;

procedure TEKKA.bxPrintRep(xzR:TXZRep);
var Tb:TTableObj;
    FNAme:String;
    dy,i:Integer;
 begin
  With PrintRep do
   begin
    Clear;
    SetDefault;
    Font.Name:='Tahoma';
    Font.Size:=3;
    TopMargin:=30;
    LeftMargin:=40;
    dy:=0;
    if xzR.Tp='P' then dy:=4;

    AddTable(2,10+dy);
    Tb:=LastTable;
    Tb.SetWidths('335,175');

    Tb.MergeCells(1,1,2,1);
    Tb.MergeCells(1,3,2,3);
    Tb.MergeCells(1,5,2,5);
    Tb.MergeCells(1,7,2,7);
    Tb.MergeCells(1,9,2,9);

    if xzR.Tp='P' then
     begin
      Tb.MergeCells(1,11,2,11);
      Tb.MergeCells(1,13,2,11);
     end;

    Tb.SetBorders(1,1,2,10+dy,EMPTY_BORDER);

    Tb.Cell[1,1].Align:=AL_CENTER;
    Tb.Cell[1,1].Font.Style:=[fsBold];
    if xzR.strH1<>'' then
     Tb.Cell[1,1].AddText('    '+xzR.strH1+#10);
    if xzR.strH2<>'' then
     Tb.Cell[1,1].AddText(xzR.strH2+#10);
    if xzR.strH3<>'' then
     Tb.Cell[1,1].AddText(xzR.strH3+#10);
    if xzR.strH4<>'' then
     Tb.Cell[1,1].AddText(xzR.strH4+#10);
    if xzR.strH5<>'' then
     Tb.Cell[1,1].AddText(xzR.strH5+#10);

    Tb.Cell[1,1].Align:=AL_LEFT;
    Tb.Cell[1,1].AddText(#10'��  '+xzR.PN+#10);
    Tb.Cell[1,1].AddText('I�  '+xzR.ID+#10);

    Tb.Cell[1,1].Align:=AL_CENTER;
    if xzR.Tp='P' then
     begin
      Tb.Cell[1,1].AddText(#10+'��в������� �²�'+#10);
      Tb.Cell[1,1].Align:=AL_LEFT;
      Tb.Cell[1,1].AddText('� �'+IntToStr(xzR.NumZ)+'   '+DateToStr(xzR.dtStart)+#10);
      Tb.Cell[1,1].AddText('�� �'+IntToStr(xzR.NumZ_)+'   '+DateToStr(xzR.dtEnd)+#10);
     end else Tb.Cell[1,1].AddText(#10+xzR.Tp+'-��i�'+#10);

    Tb.Cell[1,1].Align:=AL_CENTER;
    Tb.Cell[1,1].AddText(#10+'---------- ����i���i� ----------');

    Tb.Cell[1,2].Align:=AL_LEFT; Tb.Cell[2,2].Align:=AL_RIGHT;
    Tb.Cell[1,2].Font.Style:=[]; Tb.Cell[2,2].Font.Style:=[];

    Tb.Cell[1,2].AddText('�i���i��� ���i�'#10); Tb.Cell[2,2].AddText(IntToStr(xzR.Sale.CntCheck)+#10);

    if xzR.Sale.Beznal1>0 then begin Tb.Cell[1,2].AddText('������I���.1'#10); Tb.Cell[2,2].AddText(CurrToStrF(xzR.Sale.Beznal1,ffFixed,2)+#10); end;
    if xzR.Sale.Beznal2>0 then begin Tb.Cell[1,2].AddText('������I���.2'#10); Tb.Cell[2,2].AddText(CurrToStrF(xzR.Sale.Beznal2,ffFixed,2)+#10); end;
    if xzR.Sale.Beznal3>0 then begin Tb.Cell[1,2].AddText('������I���.3'#10); Tb.Cell[2,2].AddText(CurrToStrF(xzR.Sale.Beznal3,ffFixed,2)+#10); end;
    if xzR.Sale.Nal>0     then begin Tb.Cell[1,2].AddText('���I���'#10);      Tb.Cell[2,2].AddText(CurrToStrF(xzR.Sale.Nal,ffFixed,2)+#10); end;

    if xzR.Sale.OborotA>0 then begin Tb.Cell[1,2].AddText('��I� ��� � 20%'#10); Tb.Cell[2,2].AddText(CurrToStrF(xzR.Sale.OborotA,ffFixed,2)+#10); end;
    if xzR.Sale.OborotB>0 then begin Tb.Cell[1,2].AddText('��I� ��� � 7%'#10);  Tb.Cell[2,2].AddText(CurrToStrF(xzR.Sale.OborotB,ffFixed,2)+#10); end;
    if xzR.Sale.OborotV>0 then begin Tb.Cell[1,2].AddText('��I� ��� � 0%'#10);  Tb.Cell[2,2].AddText(CurrToStrF(xzR.Sale.OborotV,ffFixed,2)+#10); end;

    if xzR.Sale.OborotA>0 then begin Tb.Cell[1,2].AddText('��� � 20%'#10); Tb.Cell[2,2].AddText(CurrToStrF(xzR.Sale.NalogA,ffFixed,2)+#10); end;
    if xzR.Sale.OborotB>0 then begin Tb.Cell[1,2].AddText('��� � 7%'#10);  Tb.Cell[2,2].AddText(CurrToStrF(xzR.Sale.NalogB,ffFixed,2)+#10); end;
    if xzR.Sale.OborotV>0 then begin Tb.Cell[1,2].AddText('��� � 0%'#10);  Tb.Cell[2,2].AddText(CurrToStrF(xzR.Sale.NalogV,ffFixed,2)+#10); end;

    Tb.Cell[1,2].Font.Style:=[fsBold];
    Tb.Cell[1,2].AddText('�������� ���� ������i�'#10); Tb.Cell[2,2].AddText(CurrToStrF(xzR.Sale.NalogA+xzR.Sale.NalogB+xzR.Sale.NalogV,ffFixed,2)+#10);
    Tb.Cell[1,2].AddText('�������� ����'#10);          Tb.Cell[2,2].AddText(CurrToStrF(xzR.Sale.Nal+xzR.Sale.Beznal1+xzR.Sale.Beznal2+xzR.Sale.Beznal3,ffFixed,2)+#10);

    Tb.Cell[1,3].Align:=AL_CENTER; Tb.Cell[1,3].Font.Style:=[fsBold];
    Tb.Cell[1,3].AddText('--------- ���������� ---------');

    Tb.Cell[1,4].Align:=AL_LEFT; Tb.Cell[2,4].Align:=AL_RIGHT;
    Tb.Cell[1,4].Font.Style:=[]; Tb.Cell[2,4].Font.Style:=[];

    Tb.Cell[1,4].AddText('�i���i��� ���i�'#10); Tb.Cell[2,4].AddText(IntToStr(xzR.Back.CntCheck)+#10);

    if xzR.Back.Beznal1>0 then begin Tb.Cell[1,4].AddText('������I���.1'#10); Tb.Cell[2,4].AddText(CurrToStrF(xzR.Back.Beznal1,ffFixed,2)+#10); end;
    if xzR.Back.Beznal2>0 then begin Tb.Cell[1,4].AddText('������I���.2'#10); Tb.Cell[2,4].AddText(CurrToStrF(xzR.Back.Beznal2,ffFixed,2)+#10); end;
    if xzR.Back.Beznal3>0 then begin Tb.Cell[1,4].AddText('������I���.3'#10); Tb.Cell[2,4].AddText(CurrToStrF(xzR.Back.Beznal3,ffFixed,2)+#10); end;
    if xzR.Back.Nal>0     then begin Tb.Cell[1,4].AddText('���I���'#10);      Tb.Cell[2,4].AddText(CurrToStrF(xzR.Back.Nal,ffFixed,2)+#10); end;

    if xzR.Back.OborotA>0 then begin Tb.Cell[1,4].AddText('��I� ��� � 20%'#10); Tb.Cell[2,4].AddText(CurrToStrF(xzR.Back.OborotA,ffFixed,2)+#10); end;
    if xzR.Back.OborotB>0 then begin Tb.Cell[1,4].AddText('��I� ��� � 7%'#10);  Tb.Cell[2,4].AddText(CurrToStrF(xzR.Back.OborotB,ffFixed,2)+#10); end;
    if xzR.Back.OborotV>0 then begin Tb.Cell[1,4].AddText('��I� ��� � 0%'#10);  Tb.Cell[2,4].AddText(CurrToStrF(xzR.Back.OborotV,ffFixed,2)+#10); end;

    if xzR.Back.OborotA>0 then begin Tb.Cell[1,4].AddText('��� � 20%'#10); Tb.Cell[2,4].AddText(CurrToStrF(xzR.Back.NalogA,ffFixed,2)+#10); end;
    if xzR.Back.OborotB>0 then begin Tb.Cell[1,4].AddText('��� � 7%'#10);  Tb.Cell[2,4].AddText(CurrToStrF(xzR.Back.NalogB,ffFixed,2)+#10); end;
    if xzR.Back.OborotV>0 then begin Tb.Cell[1,4].AddText('��� � 0%'#10);  Tb.Cell[2,4].AddText(CurrToStrF(xzR.Back.NalogV,ffFixed,2)+#10); end;

    Tb.Cell[1,4].Font.Style:=[fsBold];
    Tb.Cell[1,4].AddText('�������� ���� ������i�'#10); Tb.Cell[2,4].AddText(CurrToStrF(xzR.Back.NalogA+xzR.Back.NalogB+xzR.Back.NalogV,ffFixed,2)+#10);
    Tb.Cell[1,4].AddText('�������� ����'#10);          Tb.Cell[2,4].AddText(CurrToStrF(xzR.Back.Nal+xzR.Back.Beznal1+xzR.Back.Beznal2+xzR.Back.Beznal3,ffFixed,2)+#10);

    Tb.Cell[1,5].Align:=AL_CENTER; Tb.Cell[1,5].Font.Style:=[fsBold];
    Tb.Cell[1,5].AddText('-----------------------------------------');

    Tb.Cell[1,6].Align:=AL_LEFT; Tb.Cell[2,6].Align:=AL_RIGHT;
    Tb.Cell[1,6].Font.Style:=[]; Tb.Cell[2,6].Font.Style:=[];
    Tb.Cell[1,6].AddText('���������� �������:'#10); Tb.Cell[2,6].AddText(CurrToStrF(xzR.SumStart,ffFixed,2)+#10);
    Tb.Cell[1,6].AddText('�������� ��������'#10);   Tb.Cell[2,6].AddText(CurrToStrF(xzR.CashIn,ffFixed,2)+#10);
    Tb.Cell[1,6].AddText('�������� ������'#10);     Tb.Cell[2,6].AddText(CurrToStrF(xzR.CashOut,ffFixed,2)+#10);
    Tb.Cell[1,6].AddText('����i � ���i'#10);        Tb.Cell[2,6].AddText(CurrToStrF(xzR.CashBox,ffFixed,2)+#10);


    Tb.Cell[1,7].Align:=AL_CENTER; Tb.Cell[1,7].Font.Style:=[fsBold];
    Tb.Cell[1,7].AddText('-----------------------------------------');

    Tb.Cell[1,8].Align:=AL_LEFT; Tb.Cell[2,8].Align:=AL_RIGHT;
    Tb.Cell[1,8].Font.Style:=[]; Tb.Cell[2,8].Font.Style:=[];

    if xzR.Tp='Z' then
     begin
      Tb.Cell[1,8].AddText('����� ����'#10);
      Tb.Cell[2,8].Font.Style:=[fsBold];
      Tb.Cell[2,8].AddText(IntToStr(xzR.NumZ)+#10);
      Tb.Cell[2,8].Font.Style:=[];
     end else
    if xzR.Tp='P' then
     begin
      Tb.Cell[1,8].AddText('����� ���������� ����'#10);
      Tb.Cell[2,8].Font.Style:=[fsBold];
      Tb.Cell[2,8].AddText(IntToStr(xzR.LastNChek)+#10);
      Tb.Cell[2,8].Font.Style:=[];

      Tb.Cell[1,9].Align:=AL_CENTER; Tb.Cell[1,9].Font.Style:=[fsBold];
      Tb.Cell[1,9].AddText('---------- ϳ������ ----------');

      for i:=Low(xzR.aStr) to High(xzR.aStr) do
       begin
        Tb.Cell[1,10].Align:=AL_LEFT; Tb.Cell[2,10].Align:=AL_RIGHT;
        Tb.Cell[1,10].Font.Style:=[]; Tb.Cell[2,10].Font.Style:=[];
        Tb.Cell[1,10].AddText(IntToStr(xzR.aStr[i].numZ)+'   '+DateToStr(xzR.aStr[i].dateZ)+#10); Tb.Cell[2,10].AddText(CurrToStrF(xzR.aStr[i].sumZ,ffFixed,2)+#10);

       end;

      Tb.Cell[1,11].Align:=AL_CENTER; Tb.Cell[1,11].Font.Style:=[fsBold];
      Tb.Cell[1,11].AddText('-----------------------------------------');
     end;

    Tb.Cell[1,8+dy].AddText(DateToStr(xzR.DtCheck)); Tb.Cell[2,8+dy].AddText(TimeToStr(xzR.DtCheck));

    Tb.Cell[1,9+dy].Align:=AL_CENTER; Tb.Cell[1,9+dy].Font.Style:=[fsBold];
    Tb.Cell[1,9+dy].AddText('-----------------------------------------');

    Tb.Cell[1,10+dy].Align:=AL_LEFT; Tb.Cell[2,10+dy].Align:=AL_RIGHT;
    Tb.Cell[1,10+dy].Font.Style:=[]; Tb.Cell[2,10+dy].Font.Style:=[fsBold];
    Tb.Cell[1,10+dy].AddText('��  '+xzR.FN+#10); Tb.Cell[2,10+dy].AddText('������'+#10);

    Tb.Cell[2,10+dy].Font.Style:=[];
    Tb.Cell[1,10+dy].AddText('��������� ���'); Tb.Cell[2,10+dy].AddText('CashDesk');


    FName:=GetTemporaryFName(xzR.Tp+'rep','.pdf');
    SaveToFilePDF(FName);
    // ShellExecute(Application.Handle,'open',PChar(FName),PChar('/t'),nil,SW_SHOWNORMAL);

    if xzR.Tp='P' then PreView
                  else Print(EKKA.PrinterPRRO);
   end;
 end;

procedure TEKKA.fpZXPrintReport(Param:Char; NumZ_Group:Integer=0);
var R:TXZRep;
    sP:String;
 begin

  QrEx.Close;
  QrEx.SQL.Text:='ecr.spY_GetXZreport '''+Param+''','+IntToStr(KassaID)+','+IntToStr(NumZ_Group);


  try
   QrEx.SQL.SaveToFile('c:\log\spY_GetXZreport.txt');
  except
  end;

  QrEx.Open;

  R.Tp:=Param;
  R.strH1:=QrEx.FieldByName('strH1').AsString;
  R.strH2:=QrEx.FieldByName('strH2').AsString;
  R.strH3:=QrEx.FieldByName('strH3').AsString;
  R.strH4:=QrEx.FieldByName('strH4').AsString;
  R.strH5:=QrEx.FieldByName('strH5').AsString;
  R.ID:=QrEx.FieldByName('ID').AsString;
  R.PN:=QrEx.FieldByName('PN').AsString;
  R.FN:=QrEx.FieldByName('FN').AsString;

  R.DtCheck:=QrEx.FieldByName('DtRep').AsDateTime;
  R.NumZ:=NumZ_Group;

  R.Sale.Nal:=0.01*QrEx.FieldByName('Sum4').AsCurrency;
  R.Sale.Beznal1:=0.01*QrEx.FieldByName('SumB1').AsCurrency;
  R.Sale.Beznal3:=0.01*QrEx.FieldByName('SumB3').AsCurrency;
  R.Sale.Beznal2:=0.01*(QrEx.FieldByName('Sum7').AsCurrency)-R.Sale.Beznal1-R.Sale.Beznal3;
  R.Sale.CntCheck:=QrEx.FieldByName('CntCheks').AsInteger;

  R.Back.Nal:=0.01*QrEx.FieldByName('Sum5').AsCurrency;
  R.Back.Beznal1:=0.01*QrEx.FieldByName('SumBB1').AsCurrency;
  R.Back.Beznal3:=0.01*QrEx.FieldByName('SumBB3').AsCurrency;
  R.Back.Beznal2:=0.01*(QrEx.FieldByName('Sum8').AsCurrency)-R.Back.Beznal1-R.Back.Beznal3;
  R.Back.CntCheck:=QrEx.FieldByName('CntCheksB').AsInteger;

  R.SumStart:= 0.01*QrEx.FieldByName('Sum1').AsCurrency;
  R.CashIn:=   0.01*QrEx.FieldByName('Sum2').AsCurrency;
  R.CashOut:=  0.01*QrEx.FieldByName('Sum3').AsCurrency;
  R.CashBox:=  0.01*QrEx.FieldByName('Sum6').AsCurrency;

  R.Sale.OborotA:=0.01*QrEx.FieldByName('SumA').AsCurrency;
  R.Sale.OborotB:=0.01*QrEx.FieldByName('SumB').AsCurrency;
  R.Sale.OborotV:=0.01*QrEx.FieldByName('SumV').AsCurrency;

  R.Sale.NalogA:=0.01*QrEx.FieldByName('Sum_nA').AsCurrency;
  R.Sale.NalogB:=0.01*QrEx.FieldByName('Sum_nB').AsCurrency;
  R.Sale.NalogV:=0.01*QrEx.FieldByName('Sum_nV').AsCurrency;

  R.Back.OborotA:=0.01*QrEx.FieldByName('SumBA').AsCurrency;
  R.Back.OborotB:=0.01*QrEx.FieldByName('SumBB').AsCurrency;
  R.Back.OborotV:=0.01*QrEx.FieldByName('SumBV').AsCurrency;

  R.Back.NalogA:=0.01*QrEx.FieldByName('Sum_nBA').AsCurrency;
  R.Back.NalogB:=0.01*QrEx.FieldByName('Sum_nBB').AsCurrency;
  R.Back.NalogV:=0.01*QrEx.FieldByName('Sum_nBV').AsCurrency;

  bxPrintRep(R);
 end;

procedure TEKKA.fpPeriodPrintReport(dtStart,dtEnd:TDateTime);
var R:TXZRep;
    sP:String;
    i:Integer;
 begin

  QrEx.Close;
  QrEx.SQL.Text:='ecr.spY_GetPreportH '+IntToStr(KassaID)+','''+FormatDateTime('yyyy-mm-dd',dtStart)+''','''+FormatDateTime('yyyy-mm-dd',dtEnd)+' 23:59:59''';
  QrEx.Open;

  R.Tp:='P';
  R.dtStart:=dtStart;
  R.dtEnd:=dtEnd;
  R.strH1:=QrEx.FieldByName('strH1').AsString;
  R.strH2:=QrEx.FieldByName('strH2').AsString;
  R.strH3:=QrEx.FieldByName('strH3').AsString;
  R.strH4:=QrEx.FieldByName('strH4').AsString;
  R.strH5:=QrEx.FieldByName('strH5').AsString;
  R.ID:=QrEx.FieldByName('ID').AsString;
  R.PN:=QrEx.FieldByName('PN').AsString;
  R.FN:=QrEx.FieldByName('FN').AsString;

  R.DtCheck:=QrEx.FieldByName('DtRep').AsDateTime;
  R.NumZ:=QrEx.FieldByName('NumZ').AsInteger;
  R.NumZ_:=QrEx.FieldByName('NumZ_').AsInteger;
  R.LastNChek:=QrEx.FieldByName('LastNChek').AsInteger;

  R.Sale.Nal:=0.01*QrEx.FieldByName('Sum4').AsCurrency;
  R.Sale.Beznal1:=0.01*QrEx.FieldByName('SumB1').AsCurrency;
  R.Sale.Beznal3:=0.01*QrEx.FieldByName('SumB3').AsCurrency;
  R.Sale.Beznal2:=0.01*(QrEx.FieldByName('Sum7').AsCurrency)-R.Sale.Beznal1-R.Sale.Beznal3;
  R.Sale.CntCheck:=QrEx.FieldByName('CntCheks').AsInteger;

  R.Back.Nal:=0.01*QrEx.FieldByName('Sum5').AsCurrency;
  R.Back.Beznal1:=0.01*QrEx.FieldByName('SumBB1').AsCurrency;
  R.Back.Beznal3:=0.01*QrEx.FieldByName('SumBB3').AsCurrency;
  R.Back.Beznal2:=0.01*(QrEx.FieldByName('Sum8').AsCurrency)-R.Back.Beznal1-R.Back.Beznal3;
  R.Back.CntCheck:=QrEx.FieldByName('CntCheksB').AsInteger;

  R.SumStart:= 0.01*QrEx.FieldByName('Sum1').AsCurrency;
  R.CashIn:=   0.01*QrEx.FieldByName('Sum2').AsCurrency;
  R.CashOut:=  0.01*QrEx.FieldByName('Sum3').AsCurrency;
  R.CashBox:=  0.01*QrEx.FieldByName('Sum6').AsCurrency;

  R.Sale.OborotA:=0.01*QrEx.FieldByName('SumA').AsCurrency;
  R.Sale.OborotB:=0.01*QrEx.FieldByName('SumB').AsCurrency;
  R.Sale.OborotV:=0.01*QrEx.FieldByName('SumV').AsCurrency;

  R.Sale.NalogA:=0.01*QrEx.FieldByName('Sum_nA').AsCurrency;
  R.Sale.NalogB:=0.01*QrEx.FieldByName('Sum_nB').AsCurrency;
  R.Sale.NalogV:=0.01*QrEx.FieldByName('Sum_nV').AsCurrency;

  R.Back.OborotA:=0.01*QrEx.FieldByName('SumBA').AsCurrency;
  R.Back.OborotB:=0.01*QrEx.FieldByName('SumBB').AsCurrency;
  R.Back.OborotV:=0.01*QrEx.FieldByName('SumBV').AsCurrency;

  R.Back.NalogA:=0.01*QrEx.FieldByName('Sum_nBA').AsCurrency;
  R.Back.NalogB:=0.01*QrEx.FieldByName('Sum_nBB').AsCurrency;
  R.Back.NalogV:=0.01*QrEx.FieldByName('Sum_nBV').AsCurrency;

  QrEx.Close;
  QrEx.SQL.Text:='ecr.spY_GetPreportT '+IntToStr(KassaID)+','''+FormatDateTime('yyyy-mm-dd',dtStart)+''','''+FormatDateTime('yyyy-mm-dd',dtEnd)+' 23:59:59''';
  QrEx.Open;

  SetLength(R.aStr,0);
  SetLength(R.aStr,QrEx.RecordCount);
  for i:=1 to QrEx.RecordCount do
   begin
    if i=1 then QrEx.First else QrEx.Next;
    R.aStr[i-1].numZ:=QrEx.FieldByName('numZ').AsInteger;
    R.aStr[i-1].dateZ:=QrEx.FieldByName('dateZ').AsDateTime;
    R.aStr[i-1].sumZ:=QrEx.FieldByName('sumZ').AsCurrency;
   end;

  bxPrintRep(R);
 end;

function TEKKA.fpXRep:Boolean;
var ErrCode,ErrDescr:string;
    chk_err:T_cgi_chk;
    R:TXZRep;
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
  if not(UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpXRep;
    EKKA_DATECS3530T:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        Result:=(FiscalClosure(0,PrinterResults,0,PAnsiChar(Passw[15]),'2')=0)and(FLastError='');
      end;
    EKKA_EXELLIO:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        FP.XReport('0000');
//                    SaveRegisters;
        Result:=CheckErrorExellio;
      end;
    EKKA_FP2000:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        FP.XReport;
        Result:=CheckErrorExellio;
      end;
    EKKA_N707:
      begin//fpXRep
        EKKA.FLastError:='';
        if PrintZXReport(IPAddr,PRINTREPORT_X_REPORT,ErrCode,ErrDescr,chk_err) then
        begin
          Result:=false;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescr);
        end
        else
        begin
          Result:=true;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescr);
        end;
      end;
    EKKA_E810T: begin //fpXRep
                  FLastError:='';
                  try
                    //Result:=ReConnect;
                    if FIsConnected then
                    begin
                      Result:=ics.FPMakeXReport(P_REPORTS);
                      if not Result then
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                    end
                    else
                      raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                end;
    EKKA_VIRTUAL:begin
                  try
                   //Result:=ReConnect;

                   { -- �������� ������ ��� ��� printXRep ����� ������� �������� ��������� ������ �� X-������.
                    QrEx.Close;
                    QrEx.SQL.Text:='exec ecr.spY_ZXReports ''X'','+IntToStr(KassaID);
                    QrEx.Open;
                   }
                   //printXRep(QrEx.FieldByName('EmulEKKA').AsInteger,QrEx.FieldByName('pdf'),'xRep');
                   printXRep(0,nil,'xRep');

                   FLastError:='';
                   Result:=True;
                  except
                   on E:Exception do
                    begin
                     FLastError:=E.Message;
                     Result:=false;
                    end;
                  end;
                 end;
  end;
end;

function TEKKA.fpZRep:Boolean;
var
  B:Boolean;
  Sum:Currency;
  Res:Variant;
  ErrCode,ErrDescr:String;
  chk_err:T_cgi_chk;
  SumCash:Integer;

 begin
  if EmulEKKA then
  try
    bPrintRep(1);
    Result:=True;
    Exit;
  except
    on E:Exception do
    begin
      FLastError:='������ ������ �-������: '+E.Message;
      Result:=False;
      Exit;
    end;
  end;

  if not(UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpZRep;
    EKKA_DATECS3530T:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        Result:=(ServiceInputOutput(0,PrinterResults,0,0)=0)and(FLastError='');
        Sum:=StrToInt(FRD_Item[0])*0.01;
                        //Result:=(FiscalClosure(0,PrinterResults,0,PAnsiChar(Passw[15]),'2')=0) and (FLastError='');
        Result:=(ServiceInputOutput(0,PrinterResults,0,-Sum)=0)and(FLastError='');
        Result:=(FiscalClosure(0,PrinterResults,0,PAnsiChar(Passw[15]),'0')=0)and(FLastError='');
        if not Result then Exit;
        DeleteArticle(0,PrinterResults,0,0,PAnsiChar(Passw[14]));
        DeleteFile(FArtFile);
        ServiceInputOutput(0,PrinterResults,0,Sum);
      end;
    EKKA_EXELLIO:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        FP.InOut(0);
        Sum:=StrToInt64(FP.s2)*0.01;
        FP.InOut(-Sum);
        FP.ZReport('0000');
        Result:=CheckErrorExellio;
        if not Result then Exit;
        FP.DelArticle('0000',0);
        FP.InOut(Sum);
        FP.LastFiscalClosure(0);
        if FP.LastError<>0 then NextNumZ;
      end;
    EKKA_FP2000:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        Res:=FP.GetCashDeskInfo;
        Sum:=Res.CashSum;
        FP.CashOutput(Sum);
        FP.ZReport;
        Result:=CheckErrorExellio;
        if not Result then Exit;
        FP.DeleteArticles;
        FP.CashInput(Sum);
      end;
    EKKA_N707:
      begin//fpZRep
        EKKA.FLastError:='';
        if PrintZXReport(IPAddr,PRINTREPORT_Z_REPORT,ErrCode,ErrDescr,chk_err) then
        begin
          Result:=true;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescr);
        end
        else
        begin
          Result:=false;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescr);
        end;
      end;
    EKKA_E810T: begin //fpZRep
                  FLastError:='';
                  try
                    //Result:=ReConnect;
                    if FIsConnected then
                    begin
                      if not ics.ModemAckuirerUnconditionalConnect then
                        raise Exception.Create('������ ������ '+IntToStr(ics.prGetModemErrorCode)+': '+ics.prGetModemErrorText);
                      if not ics.ModemUpdateStatus then
                        raise Exception.Create('������ ������ '+IntToStr(ics.prGetModemErrorCode)+': '+ics.prGetModemErrorText);
                      if ics.stModemFailCode <> 0 then
                        raise Exception.Create('������ ������ '+IntToStr(ics.prGetModemErrorCode)+': '+ics.prGetModemErrorText+'(��� ������: '+IntToStr(ics.stModemFailCode)+')');

                      Result:=ics.FPGetDayReportData;
                      if Not Result then
                       raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));

                      SumCash:=ics.prDayCashInSum-ics.prDayCashOutSum+ics.prDaySaleSumOnPayForm4-ics.prDayRefundSumOnPayForm4;

                      Result:=ics.FPCashOut(SumCash);
                      if not Result then
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));

                      Result:=ics.FPMakeZReport(P_REPORTS);

                      if not Result then
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));

                      ics.FPCashIn(SumCash);
                    end
                    else
                      raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                end;
    EKKA_VIRTUAL:begin
                  try
                   Result:=ReConnect;
                   QrEx.Close;
                   QrEx.SQL.Text:='exec ecr.spY_ZXReports ''Z'','+IntToStr(KassaID);
                   QrEx.Open;
                   FOrderNum:=QrEx.FieldByName('OrderNum').AsString;

                   {
                    if QrEx.FieldByName('EmulEKKA').AsInteger=0 then
                     SaveBlobAndOpen(QrEx.FieldByName('pdf'),'zRep');
                    }
                   FLastError:='';

                   Result:=True;
                  except
                   on E:Exception do
                    begin
                     FLastError:=E.Message;
                     Result:=false;
                    end;
                  end;
                 end;
  end;
end;

function TEKKA.GetReceiptNumber:Integer;
var
  Res:Integer;
  chk_numb:TChkNomber;
  ErrCode,ErrMess:string;
  msg:string;
//  ics: TIKC_E810T;
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

  if not(UseEKKA) then
  begin
    Result:=-1;
    Exit;
  end;
  Result:=-1;
  try
    case TypeEKKA of
      EKKA_MARRY301MTM:Result:=inherited GetReceiptNumber;
      EKKA_DATECS3530T:
        try
          if not ReConnect then Abort;
          if GetLastReceipt(0,PrinterResults,0)<>0 then Abort;
          Result:=StrToInt(FRD_Item[0]);
        except
          Result:=-1;
        end;
      EKKA_EXELLIO:
        begin
          if not ReConnect then Exit;
          FP.GetLastReceiptNum;
          if not CheckErrorExellio then Exit;
          Result:=FP.s1;
        end;
      EKKA_FP2000:
        begin
          if not ReConnect then Exit;
          Res:=FP.GetLastCheckNumber;
          if not CheckErrorExellio then Exit;
          Result:=Res;
        end;
      EKKA_N707:
        begin//GetReceiptNumber
          if not ReConnect then Exit;
          chk_numb:=GetLastChkNo(IPAddr);

          if trim(chk_numb.ErrCode)='' then //��� ������
          begin
            Res:=chk_numb.ChkNumber;
            FLastError:='';
          end
          else //������
          begin
            Res:=-1;
            FLastError:=trim(chk_numb.ErrCode+' '+chk_numb.ErrMessage);
            msg:='';
            if (length(trim(FLastError))>0)or(chk_numb.ChkNumber<=0) then
            begin
              msg:='������� ����� ������.'+#13+
                '������ ����� �������� �� ��������!'+#13+
                '��� �������������� ����������� ������ �����'+#13+
                '���������� ������� ������� �����.'+#13+
                ''+#13+
                '����� ������� ������� �����'+#13+
                '�������� ���� "���������" => "������ (Z,X, ��������/������)..." '+#13+
                '� ������� ���� ��������� � ������������ "������� ���" '+#13+
                '��� �������� ��������� �������� � ������� ����� '+#13+
                '���������� ��������������� �������.'+#13+
                ''+#13+
                '�������������� ������� ������������ ������������� '+#13+
                '�� ����� ������ �-������.'+#13+
                '�������������� ������� ����������'+#13+
                '����� ���������� ���������� ������� �� ���� ������ ���������� '+FloatToStrF(GetLastServiceShiftValue(ConnectString),12,2)+' ���.';
              MessageDlg(msg,mtWarning, [mbOK],0);
            end;
          end;
          Result:=Res;
        end;
      EKKA_E810T: begin//GetReceiptNumber
                    FLastError:='';
                    try
                      //ReConnect;
                      if FIsConnected then
                        Result:=ics.stModemPID_Unused-1
                      else
                        raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                    except
                      on E:Exception do
                      begin
                        FLastError:=E.Message;
                        Result:=0;
                        if FIsConnected then
                          if not ics.FPClose then
                            FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                        FIsConnected:=false;
                      end;
                    end;
                  end;//GetReceiptNumber
      EKKA_VIRTUAL:begin
                    try
                     try
                      QrEx.Close;
                      QrEx.SQL.Text:='exec ecr.spY_GetRecieptNumber '+IntToStr(KassaID)+','+IntToStr(BoolToInt(FGenNewNumbChek));
                      QrEx.Open;
                      FLastError:='';
                      Result:=QrEx.FieldByName('numb_chek').AsInteger;

                      if FGenNewNumbChek=True then FNewNumbChek:=QrEx.FieldByName('numb_chek').AsInteger;

                     finally
                      FGenNewNumbChek:=False;
                     end;
                    except
                     on E:Exception do
                      begin
                       FLastError:=E.Message;
                       Result:=0;
                      end;
                    end;
                   end;
    end;
  finally
    if (Result=-1)and(FLastError='') then FLastError:='ERP_9987';
  end;
end;

function TEKKA.ReceiptNumber(Index:Integer=0):Integer; //overload;
var
  chk_numb:TChkNomber;
  ErrCode,ErrMess:string;
  c_str:string;
  msg:string;
begin
  // ��� ������� ����������� ������� ��������� �������� ReceiptNumber ������(TMarry301),
  //��� ����, ����� ����� ���� �������� �������� � ���������� �� ���� ��� ���������� ����(����������, ����������...)
  //Index=0 - ���������� ���, 1 - ���������� ���
  FLastError:='';
  if Index=0 then //����� ����� ���� ��� ������
  begin
    ReceiptNumber:=GetReceiptNumber;
    exit;
  end
  else
    if Index=1 then //���������� ���
     begin
      if TypeEKKA=EKKA_N707 then //EKKA_N707 ����� ����� ����������� ����
       begin
        chk_numb:=GetLastChkNo(IPAddr,false);
        if chk_numb.ErrCode='' then
        begin
          ReceiptNumber:=chk_numb.ChkNumber;
          FLastError:='';
        end
        else //������
        begin
          FLastError:='������ ����������� ������ ����: '+chk_numb.ErrCode+' '+chk_numb.ErrMessage;
          Result:=-1;
//          if (length(trim(chk_number.ErrCode))>0)or(chk_number.ChkNumber <= 0) then
          msg:='';
          if (length(trim(FLastError))>0)or(chk_numb.ChkNumber<=0) then
          begin
            msg:='������� ����� ������.'+#13+
              '������ ����� �������� �� ��������!'+#13+
              '��� �������������� ����������� ������ �����'+#13+
              '���������� ������� ������� �����.'+#13+
              ''+#13+
              '����� ������� ������� �����'+#13+
              '�������� ���� "���������" => "������ (Z,X, ��������/������)..." '+#13+
              '� ������� ���� ��������� � ������������ "������� ���" '+#13+
              '��� �������� ��������� �������� � ������� ����� '+#13+
              '���������� ��������������� �������.'+#13+
              ''+#13+
              '�������������� ������� ������������ ������������� '+#13+
              '�� ����� ������ �-������.'+#13+
              '�������������� ������� ����������'+#13+
              '����� ���������� ���������� ������� �� ���� ������ ���������� '+FloatToStrF(GetLastServiceShiftValue(ConnectString),12,2)+' ���.';
            MessageDlg(msg,mtWarning, [mbOK],0);
          end;
          Exit;
        end;
      end else //��� �������� ����� EKKA_N707 ����� ����� ���� ��� ������
      begin
        ReceiptNumber:=GetReceiptNumber;
        exit;
      end;
    end;

end;

function TEKKA.GetVzhNum:Int64;
var
  Res:Int64;
  status_N707:TStatusN707;
//  ics: TIKC_E810T;
begin
  if EmulEKKA then
   begin
    Result:=FKassaID+100100;
    Exit;
   end;

  if not(UseEKKA) then
  begin
    Result:=0;
    Exit;
  end;
  Result:=0;
  try
    case TypeEKKA of
      EKKA_MARRY301MTM:Result:=inherited GetVzhNum;
      EKKA_DATECS3530T:
        try
          if FVzhNum<=0 then
            if not ReConnect then Abort;
          Result:=FVzhNum;
        except
          Result:=0;
        end;
      EKKA_EXELLIO:
        try
          if FVzhNum<=0 then
          begin
            if not ReConnect then Abort;
            if not CheckErrorExellio then Exit;
          end;
          Result:=FVzhNum;
        except
          Result:=0
        end;
      EKKA_FP2000:
        try
          if FVzhNum<=0 then
          begin
            if not ReConnect then Abort;
            if not CheckErrorExellio then Exit;
          end;
          Result:=FVzhNum;
        except
          Result:=0
        end;
      EKKA_N707:
        begin//GetVzhNum
          if not ReConnect then Exit;
          status_N707:=GetStatusN707(IPAddr);
          if status_N707.ErrorCode='' then //��� ������
          begin
            Res:=status_N707.dev_id;
            FVzhNum:=status_N707.dev_id;
            FVzhNumS:=status_N707.dev_zn;
            FLastError:='';
          end
          else //������
          begin
            Res:=-1;
            FLastError:=trim(status_N707.ErrorCode+' '+status_N707.ErrorDescription);
          end;
          Result:=Res;
        end;
      EKKA_E810T: begin//GetVzhNum
                  FLastError:='';
                  try
                    //ReConnect;
                    if FIsConnected then
                    begin
                     {
                      Result:=ics.stModemID_DEV;
                      FVzhNum:=ics.stModemID_DEV;
                      FVzhNumS:=ics.prSerialNumber;
                     }
                     Result:=StrToInt64(ics.prFiscalNumber);
                    end
                    else
                      raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=0;
                      FVzhNum:=0;
                      FVzhNumS:='';
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                  end;
     EKKA_VIRTUAL:begin
                   ReConnect;
                   Result:=FVZhNum;
                  end;
    end;
  finally
    if (Result=0)and(FLastError='') then FLastError:='ERP_9987';
  end;
end;

function TEKKA.KeyPosition(Key:Byte):Boolean;
begin
  if not(UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited KeyPosition(Key);
    EKKA_DATECS3530T:Result:=True;
    EKKA_EXELLIO:Result:=True;
    EKKA_FP2000:Result:=True;
    EKKA_N707:Result:=true;//KeyPosition
  end;
end;

function TEKKA.fpOpenFiscalReceipt(Param:Byte=1;NChek:Integer=0;ControlStrim:Byte=0):Boolean;
 begin
  if EmulEKKA then
  try
    if FIsCopy=False then GetInfo;
    SetLength(sArr,0);
    bPrintHead(0,ControlStrim);
    if FIsCopy then
    begin
      MrFont.AddStrC('*  *  * ���I� *  *  *',1);
      MrFont.AddStrC('��� �  '+IntToStr(FCopy_chek),1);
    end else
    begin
      if NChek>0 then FNLastChek:=NChek
      else FNLastChek:=Qr.FieldByName('NLastChek').AsInteger;

      MrFont.AddStrC('��� � '+IntToStr(FNLastChek+1),1);
    end;

    if IsFLP=False then
      MrFont.AddStrC('�����: '+Kassir,0);
    MrFont.AddStrC('�i��. 1',0);
    if FBNumb_Chek>-1 then MrFont.AddStr('���. �� ���� �'+IntToStr(FBNumb_Chek),0);

    FSumNA:=0;
    FSumNB:=0;
    FSumNC:=0;
    FSumSale:=0;
    FSumVoid:=0;
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

  if not(UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpOpenFiscalReceipt;
    EKKA_DATECS3530T:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        case Param of
          CH_SALE:Result:=(OpenFiscalReceipt(0,PrinterResults,0,1,PAnsiChar(Passw[1]),KassaID,True)=0)and(FLastError='FISCAL_OPEN');
          CH_BACK:
            begin
              Result:=(OpenRepaymentReceipt(0,PrinterResults,0,1,PAnsiChar(Passw[1]),KassaID,True)=0)and((FLastError='FISCAL_OPEN')or(FLastError='PRINT_RESTART'));
              if not Result then Exit;
              Result:=(PrintFiscalText(0,PrinterResults,0,PAnsiChar(FNumVoidChek))=0)and((FLastError='FISCAL_OPEN')or(FLastError='PRINT_RESTART'));
            end;
        end;
      end;
    EKKA_EXELLIO:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        case Param of
          CH_SALE:FP.OpenFiscalReceipt(1,'0000',1);
          CH_BACK:
            begin
              FP.OpenReturnReceipt(1,'0000',1);
              if FP.LastError=0 then FP.PrintFiscalText(FNumVoidChek);
            end;
        end;
        Result:=CheckErrorExellio;
      end;
    EKKA_FP2000:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        case Param of
          CH_SALE:FP.OpenFiscalCheck(True);
          CH_BACK:
            begin
              FP.OpenFiscalCheck(False);
              if CheckErrorExellio then FP.AddFiscalText(FNumVoidChek);
            end;
        end;
        Result:=CheckErrorExellio;
      end;
    EKKA_N707:
      begin//fpOpenFiscalReceipt
        Result:=ReConnect;
        if not Result then Exit;
        curr_check.Clear;
        case Param of
          CH_SALE:
            begin
              curr_check.Add('F');
              Result:=true;
            end;
          CH_BACK:
            begin
              curr_check.Add('R');
              curr_check.Add('"'+FNumVoidChek);
              Result:=true;
            end;
        end;//case Param
      end;//Case TypeEKKA
    EKKA_E810T: begin//fpOpenFiscalReceipt
                  FLastError:='';
                  try
                    if FIsConnected then
                     begin
                      FDiscSumAll:=0;
                      ics.FPAnnulReceipt;
                      Result:=True; //ics.FPMakeXReport(P_REPORTS);
                      {if not Result then
                       raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                      }
                     end else raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                end;
   EKKA_VIRTUAL:begin
                  try
                   SetLength(Check.Products,0);
                   SetLength(Check.Service,0);
                   FSumChek:=0;
                   FOrderNum:='';
                   Check.TypeChek:=Param;
                   Check.NumbChek:=FNewNumbChek;

                   FLastError:='';
                   Result:=True;
                  except
                   on E:Exception do
                    begin
                     FLastError:=E.Message;
                     Result:=false;
                    end;
                  end;
                end;
  end;
end;

function TEKKA.fpIsNonClosedReceipt:Boolean;
var
  Res:Boolean;
begin
  if not(UseEKKA) then
  begin
    Result:=False;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=False;
    EKKA_DATECS3530T:
      try
        if not ReConnect then Abort;
        GetFiscalClosureStatus(0,PrinterResults,0,True);
        if ((FLastError='FISCAL_OPEN')or(FLastError='PRINT_RESTART')) then
        begin
          Result:=not CancelFiscalReceipt;
        end
        else
          Exit;
        FLastError:='';
      except
        Result:=True;
        FLastError:='ERP_9993';
      end;
    EKKA_EXELLIO:Result:=False;
    EKKA_FP2000:Result:=False;
    EKKA_N707:Result:=false;//fpIsNonClosedReceipt
    EKKA_E810T: begin //fpIsNonClosedReceipt
                  FLastError:='';
                  try
                    //Result:=ReConnect;
                    if FIsConnected then
                    begin
                      Result:=ics.stReceiptIsOpened;
                      if Result then
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                    end
                    else
                      raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                end; //fpIsNonClosedReceipt
  end;
end;

function TEKKA.CancelFiscalReceipt:Boolean;
begin
  try
    Result:=(GetFiscalClosureStatus(0,PrinterResults,0,False)=0)and(FLastError='');
    if not Result then Abort;
    if StrToInt(FRD_Item[0])=1 then
      Abort
    else
      Result:=True;
  except
    Result:=(ResetReceipt(0,PrinterResults,0)=0)and(FLastError='');
  end;
end;

function TEKKA.fpCancelFiscalReceipt:Boolean;
var
  Res:Variant;
begin
  if EmulEKKA then
  begin
    MrFont.AbortPrint;
    Result:=True;
    Exit;
  end;

  if not(UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpCancelFiscalReceipt;
    EKKA_DATECS3530T:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        Result:=CancelFiscalReceipt;
      end;
    EKKA_EXELLIO:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        FP.GetFiscalClosureStatus(False);
        if FP.s1=1 then FP.CancelReceipt;
        Result:=CheckErrorExellio;
      end;
    EKKA_FP2000:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        Res:=FP.GetFiscalTransactionStatus;
        if Res.IsOpenCheck then FP.CancelCheck;
        Result:=CheckErrorExellio;
      end;
    EKKA_N707:curr_check.Clear;//fpCancelFiscalReceipt
    EKKA_E810T:begin//fpCancelFiscalReceipt
                  FLastError:='';
                  try
                    //Result:=ReConnect;
                    if FIsConnected then
                    begin
                      Result:=ics.FPAnnulReceipt;
                      if not Result then
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                    end
                    else
                      raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                end;//fpCancelFiscalReceipt
    EKKA_VIRTUAl:begin
                  Result:=True;
                  FLastError:='';
                 end;
  end;
end;

function TEKKA.fpAddSale(Name:string;Kol:Integer;Cena:Currency; Divis:Byte; Artic:Integer; Nalog:Byte;DiscSum:Currency;DiscDescr:string):Boolean;
var Art,i,j,ArticB:Integer;
    Sh:Char;
    sNds,S,sArt,sArt1:String;
    str_length,CA:Integer;
    new_str:String;
    Letter:Char;
    Prc:Integer;

 begin
  if EmulEKKA then
   try
    FLastError:='';
    S:=Name+' '+CurrToStrF_(Cena)+'*'+IntToStr(Kol)+'=';
    case Nalog of
      1:
        begin
          sNds:='�';
          FSumNA:=FSumNA+(cena*kol+DiscSum)/6;
        end;
      2:
        begin
          sNds:='�';
          FSumNB:=FSumNB+(cena*kol+DiscSum)*(7/107);
        end;
      3:
        begin
          sNds:='�';
          FSumNC:=FSumNC; //+(cena*kol+DiscSum)*(7/107);
        end;
    end;
    if Artic=99999
      then FSumVoid:=FSumVoid+cena*kol+DiscSum
    else
      FSumSale:=FSumSale+cena*kol+DiscSum;
    FSumDis:=FSumDis+DiscSum;
{
      if Nalog=1 then
      begin
        MrFont.AddStr2J('��� - *�20.00%=',CurrToStrF_((cena*kol+DiscSum)/6),0,30);
        MrFont.AddStr2J('����� ��� ���=',CurrToStrF_((kol*cena+DiscSum)-(cena*kol+DiscSum)/6),0,30);
      end;
}
    while Length(S)>30 do
     begin
      MrFont.AddStr(Copy(S,1,30),0);
      S:=Copy(S,31,Length(S));
     end;
    MrFont.AddStr2J(Copy(S,1,30),CurrToStrF_(Cena*kol)+'-'+sNDS,0);
    if DiscSum<0 then
     MrFont.AddStr2J('������ -',' -'+CurrToStrF_(Abs(DiscSum))+'  ',0)
    else
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

  if not(UseEKKA) then
   begin
    Result:=True;
    Exit;
   end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpAddSale(Name,Kol,Cena,Divis,Artic,Nalog,DiscSum,DiscDescr);
    EKKA_DATECS3530T:
      try
        Result:=ReConnect;
        if not Result then Exit;
        Sh:=#0;
        case Nalog of
          1:Sh:='�';
          2:Sh:='�';
          3:Sh:='�'
        else
          Abort;
        end;
        for i:=1 to 30 do
        begin
          if (Artic=0)or(Artic=99999) then
            Art:=StrToInt(fpGetNewArt)
          else
            Art:=Artic;
          if (ProgrammingArticle(0,PrinterResults,0,Sh,Art,1,Cena,PAnsiChar(Passw[14]),PAnsiChar(Copy(Name,1,24)+#09+Copy(Name,25,24)))<>0)
            or((FLastError<>'FISCAL_OPEN')
            and(FLastError<>'PRINT_RESTART'))
            then
            Abort;
          if FRD_Item[0]<>'P' then
          begin
            if Artic=0 then Abort;
          end
          else
            Break;
        end;
        Result:=(SaleArticle(0,PrinterResults,0,True,Art,Kol,0,DiscSum)=0)and((FLastError='FISCAL_OPEN')or(FLastError='PRINT_RESTART'));
      except
        Result:=False;
        if FLastError='' then FLastError:='ERP_9992';
      end;
    EKKA_EXELLIO:
      begin
        Result:=ReConnect;
        if Not Result then Exit;
        sArt:=IntToStrF(Artic,6)+IntToStr(Nalog);
        FP.GetArticle(sArt);
        if FP.s1='F' then FP.SetArticle(StrToInt(sArt),Nalog,1,Cena,'0000',Copy(Name,1,36));
        FP.RegistrItemEx(StrToInt(sArt),Kol,Cena,0,DiscSum);
        Result:=CheckErrorExellio;
      end;
    EKKA_FP2000:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        sArt:=IntToStrF(Artic,6)+IntToStr(Nalog);
        if not FP.GetArticleInfo(StrToInt(sArt)).IsProgram then FP.SetArticleInfo(StrToInt(sArt),Copy(Name,1,36),Nalog,Cena,1);
        FP.AddFisc(StrToInt(sArt),Kol,Cena,true,DiscSum,0);
        Result:=CheckErrorExellio;
      end;
    EKKA_N707:
      begin//fpAddSale

        Result:=ReConnect;
        if not Result then Exit;

                 //��������� ������� � ��������� �������
                 //--------------------------------------------------
        j:=1;
        if Length(Name)>30 then
          delete(name,31,length(name));
        str_length:=Length(Name);

        for i:=1 to str_length do
         begin
          if Name[i]='"' then //���� �������, �� ��������� �
          begin
            new_str:=new_str+copy(Name,j,i-j)+'''';
            j:=i+1;
          end;

          if Name[i]='/' then //���� ����, �� ��������� �������� ����
          begin
            new_str:=new_str+copy(Name,j,i-j)+'\';
            j:=i;
          end;
        end;

        new_str:=new_str+copy(Name,j,i-j+1);
        if Length(new_str)>30 then
          delete(new_str,31,length(new_str));
        if new_str[length(new_str)]='\' then delete(new_str,length(new_str),1);
{        if (Artic=0)or(Artic=99999) then
            Art:=StrToInt(fpGetNewArt)
        else
            Art:=Artic;
}

        //sArt1:=fpGetNewArt;
        Art:=fpGetNewArtNumeric; // StrToInt(sArt1);

//                 Nalog 1 - 20%, 2 - 7%
//                 curr_check.Add(IntToStr(kol)+'*'+CurrToStr(cena)+' "'+new_str+'" '+IntToStr(Artic+10)+' '+IntToStr(Nalog)); //correct VAT 20% + 7% incorrect CODE
					curr_check.Add(IntToStr(kol)+'*'+CurrToStr(cena)+' "'+new_str+'" '+IntToStr(Art)+' '+IntToStr(Nalog));//correct VAT 20% + 7%
//                 curr_check.Add(IntToStr(kol)+'*'+CurrToStr(cena)+' "'+new_str+'" '+IntToStr(Artic+15)+' '+IntToStr(Nalog)); //correct VAT 20% + 7%  incorrect CODE
//                 curr_check.Add(IntToStr(kol)+'*'+CurrToStr(cena)+' "'+new_str+'" '+IntToStr(Artic)+' '+IntToStr(1)); //all VAT 20%
//                 ������/�������
        if DiscSum<0 then //������
          curr_check.Add(CurrToStr(DiscSum));

       try
        curr_check.SaveToFile('c:\log\curr_check.txt');
       except
       end

      end;
    EKKA_E810T: begin//fpAddSale
                  FLastError:='';
                  try
                    //Result:=ReConnect;
                    if FIsConnected then
                     begin
                      if Artic=99999 then
                       begin
                        ArticB:=Random(9999)+100;
                        Result:=ics.FPRefundItem(Kol,0,false,false,false,trunc(Cena*100),Nalog,Name,ArticB);
                       end else Result:=ics.FPSaleItem(Kol,0,false,false,false,trunc(Cena*100),Nalog,Name,Artic);
                      if not Result then
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));

                      if FDiscOnAllSum=False then
                       begin
                        if DiscSum<0 then
                         Result:=ics.FPMakeDiscount(false,false,Trunc(Abs(DiscSum*100)),'')
                        else
                         Result:=ics.FPMakeMarkup(false,false,Trunc(DiscSum*100),'');
                        if not Result then
                         raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                       end;
                      FDiscSumAll:=FDiscSumAll+DiscSum;
                    end else raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                end;
    EKKA_VIRTUAL:begin
                  try

                   CA:=High(Check.Products)+1;
                   SetLength(Check.Products,CA+1);

                   Check.Products[CA].Name:=StringReplace(Name,'\','\\',[rfReplaceAll, rfIgnoreCase]);
                   Check.Products[CA].Name:=StringReplace(Check.Products[CA].Name,'"','\"',[rfReplaceAll, rfIgnoreCase]);
                   Check.Products[CA].Name:=StringReplace(Check.Products[CA].Name,#9,' ',[rfReplaceAll, rfIgnoreCase]);

                   Check.Products[CA].Amount:=Kol;
                   Check.Products[CA].Price:=Cena;
                   Check.Products[CA].Cost:=Kol*Cena;

                   //ShowMessage(CurrToStr(DiscSum));

                   Check.Products[CA].Discount:=DiscSum;
                   Check.Products[CA].Code:=Artic;
                   FSumChek:=FSumChek+Kol*Cena+DiscSum;

                   Case Nalog of
                    1:begin
                       Letter:='�';
                       Prc:=20;
                      end;
                    2:begin
                       Letter:='�';
                       Prc:=7;
                      end;
                    3:begin
                       Letter:='�';
                       Prc:=0;
                      end;
                   end;
                   Check.Products[CA].Letter:=Letter;
                   Check.Products[CA].TaxPrc:=Prc;

                   QrEx.Close;
                   QrEx.SQL.Clear;
                   QrEx.SQL.Add('select e.KodNalog, ');
                   QrEx.SQL.Add('       e.Descr, ');
                   QrEx.SQL.Add('	      p.UKTZED ');
                   QrEx.SQL.Add('from Plist p (nolock) ');
                   QrEx.SQL.Add('      left join ');
                   QrEx.SQL.Add('     SprEdBuhg e (nolock) on p.EdBuhg=e.id ');
                   QrEx.SQL.Add('where p.art_code='+IntToStr(Artic) );
                   QrEx.Open;

                   Check.Products[CA].UnitCode:=QrEx.FieldByName('KodNalog').AsString;
                   Check.Products[CA].UnitName:=QrEx.FieldByName('Descr').AsString;
                   Check.Products[CA].UKTZED:=QrEx.FieldByName('UKTZED').AsString;

                   FLastError:='';
                   Result:=True;
                  except
                   on E:Exception do
                    begin
                     FLastError:=E.Message;
                     Result:=false;
                    end;
                  end;
                 end;
  end;
end;

function TEKKA.fpAddBack(Name:string;Kol:Integer;Cena:Currency;Divis:Byte;
  Artic:Integer;Nalog:Byte;DiscSum:Currency;DiscDescr:string):Boolean;
begin
//  if (TypeEKKA=EKKA_EXELLIO) or (TypeEKKA=EKKA_FP2000) then
  case EKKA.TypeEKKA of
    EKKA_MARRY301MTM:Result:=fpAddSale(Name,Kol,Cena,Divis,99999,Nalog,DiscSum,DiscDescr);
    EKKA_DATECS3530T:Result:=fpAddSale(Name,Kol,Cena,Divis,99999,Nalog,DiscSum,DiscDescr);
    EKKA_EXELLIO:Result:=fpAddSale(Name,Kol,Cena,Divis,Artic,Nalog,DiscSum,DiscDescr);
    EKKA_FP2000:Result:=fpAddSale(Name,Kol,Cena,Divis,Artic,Nalog,DiscSum,DiscDescr);
    EKKA_N707:Result:=fpAddSale(Name,Kol,Cena,Divis,Artic,Nalog,DiscSum,DiscDescr);
    EKKA_E810T:Result:=fpAddSale(Name,Kol,Cena,Divis,99999,Nalog,DiscSum,DiscDescr);
    EKKA_VIRTUAL:Result:=fpAddSale(Name,Kol,Cena,Divis,Artic,Nalog,DiscSum,DiscDescr);
  end;
 end;

function TEKKA.fpSetBackReceipt(S:string):Boolean;
var
  ErrorCode,ErrorDescription:string;
  curr_chek:T_cgi_chk_object;
begin
  if EmulEKKA then
  begin
    FBNumb_Chek:=StrToInt(S);
    Result:=True;
    Exit;
  end;
  if not(UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpSetBackReceipt(S);
    EKKA_DATECS3530T:
      begin
        FNumVoidChek:='���. �� ���� � '+S;
        Result:=True;
      end;
    EKKA_EXELLIO:
      begin
        FNumVoidChek:='���. �� ���� � '+S;
        Result:=True;
      end;
    EKKA_FP2000:
      begin
        FNumVoidChek:='���. �� ���� � '+S;
        Result:=True;
      end;
    EKKA_N707:
      begin//fpSetBackReceipt
        FNumVoidChek:='���. �� ���� � '+S;
        Result:=True;
        if ErrorCode<>'' then
        begin
          FLastError:=trim(ErrorCode+' '+ErrorDescription);
          Result:=false;
        end;
      end;
    EKKA_E810T:
      begin
        FNumVoidChek:='���. �� ���� � '+S;
        Result:=True;
      end;
    EKKA_VIRTUAL:
      begin
        FNumVoidChek:='���. �� ���� � '+S;
        Result:=True;
      end;
(*
    EKKA_E810T: begin//fpSetBackReceipt
                  FLastError:='';
                  try
                    if not ics.FPInitialize=0 then
                      raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    if not ics.FPOpen(IntToStr(PortNum)) then
                      raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    if not ics.FPGetCurrentStatus then
                      raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    if (ics.prPrinterError)or(ics.prTapeNearEnd)or(ics.prTapeEnded) then
                      raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    if not ics.ModemInitialize(IntToStr(PortNum))=0 then
                      raise Exception.Create('������ ������ '+ics.ModedErrorCode+': '+ics.ModemErrorText);

                    if not ics.ModemInitialize(IntToStr(PortNum))=0 then
                      raise Exception.Create('������ ������ '+ics.ModedErrorCode+': '+ics.ModemErrorText);
                    if not ics.ModemUpdateStatus then
                      raise Exception.Create('������ ������ '+ics.ModedErrorCode+': '+ics.ModemErrorText);

                    try
                      Result:=ics.stPID_LastWrite<>2147483647;
                      if not Result then
                        raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    finally
                      if not ics.FPClose then
                        raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    end;
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      if not ics.FPClose then
                        FLastError:=ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte;
                    end;
                  end;
                end;//fpSetBackReceipt
*)
  end;
end;

function TEKKA.fpCloseFiscalReceiptB(TakedSumm:Currency;TypeOplat:Integer;
  SumCheck:Currency=0):Boolean;
var
  PaidCode:Char;
  Sum,SumItog,SumOplat:Currency;
begin
  if not(UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpCloseFiscalReceiptB(TakedSumm,TypeOplat,SumCheck);
    EKKA_DATECS3530T:Result:=False;
    EKKA_EXELLIO:Result:=False;
    EKKA_FP2000:Result:=False;
    EKKA_N707:Result:=False;//fpCloseFiscalReceiptB
  end;
end;

function TEKKA.fpCloseFiscalReceipt(
                                    TakedSumm:Currency;
                                    TypeOplat:Integer;
                                    SumCheck:Currency=0;
                                    SumB1:Currency=0;
                                    IsDnepr:Boolean=False;
                                    ControlStreem:Byte=0;
                                    RRN:longint=1;
                                    BankCard:string='000000000000000';
                                    IsPrintCheck:Boolean=False):Boolean;
var
  PaidCode:Char;
  Sum,SumItog,SumOplat,SumS:Currency;
  i,Ty:Integer;
  Res,Res1:Variant;
  TyB:Char;
  TyB1:Byte;
  sCheck,ErrorCode,ErrorDescription:string;
  curr_chek:T_cgi_chk_object;
  sStr,sPm:String;

begin
  if EmulEKKA then
  try
//      MrFont.AddStrC('- - ����� �� ���� - -',1);
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
      for i:=Low(sArr)to High(sArr) do MrFont.AddStr(sArr[i].S,sArr[i].F);
{
      MrFont.AddStr('��� ����������� � ������������',0);
      MrFont.AddStr('38057-344-0-344',1);
}
//      Kassir:='��������';
    if IsFLP=False then
      MrFont.AddStr('�����: '+Kassir,0);
    MrFont.AddStrC('- - - - - - - - - - - - - -  - - - - - ',0);
    case TypeOplat of
      1:MrFont.AddStr2J('������i�����.3',CurrToStrF_(Abs(FSumSale-FSumVoid))+'  ',0);
      3:MrFont.AddStr2J('������i�����.1',CurrToStrF_(Abs(FSumSale-FSumVoid))+'  ',0);
      2:begin
         if SumB1=0 then
          begin
           MrFont.AddStr2J('������i�����.2',CurrToStrF_(Abs(FSumSale-FSumVoid))+'  ',0);
          end else begin
                    if Abs(FSumSale-FSumVoid)>SumB1 then
                     MrFont.AddStr2J('������i�����.2',CurrToStrF_(Abs(FSumSale-FSumVoid)-SumB1)+'  ',0);
                    if IsDnepr then
                     MrFont.AddStr2J('������i�����.3',' '+CurrToStrF_(Abs(SumB1)),0)
                    else
                     MrFont.AddStr2J('������i�����.1',' '+CurrToStrF_(Abs(SumB1)),0);
                   end;

        end;
      4:
        begin
          if SumB1=0 then
          begin
            MrFont.AddStr2J('���i��� ',CurrToStrF_(Abs(FSumSale-FSumVoid))+'  ',0);
            if TakedSumm>SumCheck then
            begin
              MrFont.AddStr2J('���i���',' '+CurrToStrF_(Abs(TakedSumm)),1);
              MrFont.AddStr2J('�����',' '+CurrToStrF_(Abs(TakedSumm-SumCheck)),1);
            end;
          end
          else
          begin
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
              if IsDnepr then
                MrFont.AddStr2J('������i�����.3',' '+CurrToStrF_(Abs(SumB1)),0)
              else
                MrFont.AddStr2J('������i�����.1',' '+CurrToStrF_(Abs(SumB1)),0);
              if SumS>0 then
              begin
                MrFont.AddStr2J('���i���',' '+CurrToStrF_(Abs(TakedSumm)),1);
                MrFont.AddStr2J('�����',' '+CurrToStrF_(Abs(SumS)),1);
              end;
            end
            else
            begin
              if Abs(FSumSale-FSumVoid)>SumB1 then
                MrFont.AddStr2J('���i��� ',CurrToStrF_(Abs(FSumSale-FSumVoid)-SumB1)+'  ',0);
              if SumB1<FSumVoid then
              begin
                MrFont.AddStr2J('���i���',' '+CurrToStrF_(Abs(FSumVoid-SumB1)),0);
                if IsDnepr then
                  MrFont.AddStr2J('������i�����.3',' '+CurrToStrF_(Abs(SumB1)),0)
                else
                  MrFont.AddStr2J('������i�����.1',' '+CurrToStrF_(Abs(SumB1)),0);
              end
              else
              begin
                if IsDnepr then
                  MrFont.AddStr2J('������i�����.3',' '+CurrToStrF_(Abs(SumB1-FSumVoid)),0)
                else
                  MrFont.AddStr2J('������i�����.1',' '+CurrToStrF_(Abs(SumB1-FSumVoid)),0);
              end
            end
          end;
        end;
    end;
    MrFont.AddStrC('������ ��� ������''�',1);
    try
      if FIsCopy=False then
      begin
        GetInfo;
        if FDateChek>0 then FDtChek:=FDateChek
        else FDtChek:=Now;
//         FDtChek:=StrToDateTime('26.10.15 11:06:00');
        if IsFLP=False then MrFont.AddStr('#'+AddStr_(IntToStr(FNLastChek+1),'_',10)+' '+DateTimeToStrSlash(FDtChek)+' ��:'+FsFN,0);
//        if IsFLP=False then MrFont.AddStr('#'+AddStr_(IntToStr(Qr.FieldByName('NLastChek').AsInteger),'_',10)+' '+DateTimeToStrSlash(FDtChek)+' ��:'+FsFN,0);
      end
      else
      begin
        if IsFLP=False then
          MrFont.AddStr('#'+AddStr_(IntToStr(FCopy_Chek),'_',10)+' '+DateTimeToStrSlash(FDtChek)+' ��:'+FsFN,0);
      end;
      if FBNumb_chek=-1 then
        bPrintFooter(1)
      else
        bPrintFooter(5);
      FBNumb_Chek:=-1;
      if (FIsCopy=False)and(ControlStreem=0) then
      begin
        if Qr.FieldByName('NLastChek').AsInteger mod 10=0 then fpSendToEKV;
      end;
      Result:=True;
      Exit;
    finally
      FDateChek:=0;
    end
  except
    on E:Exception do
    begin
      bPrintFooter(2);
      FLastError:='������ �������� ����: '+E.Message;
      Result:=False;
      Exit;
    end;
  end;
  if not(UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
{
    ���� �����:
          �����    | ������ FP3530 | Exellio LP1000 | Exellio FP2000 | N707 | ���810� | ��������
     1 - ������ 3  |      N        |       2        |        4       |   3  |    2    | ������ � ������
     2 - ������ 2  |      D        |       4        |        3       |   4  |    1    | ������ � ������� ��������� �����
     3 - ������ 1  |      C        |       3        |        2       |   2  |    3    | ������ �����
     4 - ��������  |      P        |       1        |        1       |   1  |    4    | ������ ���������
}
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpCloseFiscalReceipt(TakedSumm,TypeOplat,SumCheck,SumB1,IsDnepr);
    EKKA_DATECS3530T:
      try
        Result:=ReConnect;
        if not Result then Exit;
        PaidCode:=#0;
        case TypeOplat of
          1:PaidCode:='N';// ������ � ������
          2:PaidCode:='D';// ������ � ������� ��������� �����
          3:PaidCode:='C';// ������ �����
          4:PaidCode:='P'// ������ ���������
        else
          Abort;
        end;
        if IsDnepr then
          TyB:='N'
        else
          TyB:='C';
        Result:=(GetFiscalClosureStatus(0,PrinterResults,0,True)=0)and((FLastError='FISCAL_OPEN')or(FLastError='PRINT_RESTART'));
        if not Result then Abort;
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
        end
        else
          Sum:=SumItog-SumOplat;
        if (Sum<>0)or((Sum=0)and(SumItog=0)) then
        begin
          if SumB1=0 then
            Result:=(Total(0,PrinterResults,0,'',PaidCode,Sum)=0)and((FLastError='FISCAL_OPEN')or(FLastError='PRINT_RESTART'))
          else
          begin
            if (SumItog-SumOplat)>SumB1 then
            begin
              Result:=(Total(0,PrinterResults,0,'','P',(SumItog-SumOplat)-SumB1)=0)and((FLastError='FISCAL_OPEN')or(FLastError='PRINT_RESTART'));
              Result:=(Total(0,PrinterResults,0,'',TyB,SumB1)=0)and((FLastError='FISCAL_OPEN')or(FLastError='PRINT_RESTART'));
            end
            else
              Result:=(Total(0,PrinterResults,0,'',TyB,SumItog-SumOplat)=0)and((FLastError='FISCAL_OPEN')or(FLastError='PRINT_RESTART'));
          end;
          if not Result then Abort;
        end;
        if IsAbort then Abort;
        PrintFiscalText(0,PrinterResults,0,PAnsiChar('* * * * * * * * * *'));
        Result:=(CloseFiscalReceipt(0,PrinterResults,0)=0)and(FLastError='');
        if not Result then Abort;
        FNumVoidChek:='';
      except
        Result:=False;
        if FLastError='' then FLastError:='ERP_9991';
      end;
    EKKA_EXELLIO:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        case TypeOplat of
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
            if not Result then Abort;
          end else
          begin
            FP.GetFiscalClosureStatus(True);
            Result:=CheckErrorExellio;
            if not Result then Abort;
            SumItog:=StrToInt64(FP.s3)*0.01;
            SumOplat:=StrToInt64(FP.s4)*0.01;
            if (SumItog-SumOplat)>SumB1 then
            begin
              FP.Total('',Ty,(SumItog-SumOplat)-SumB1);
              Result:=CheckErrorExellio;
              if not Result then Abort;
              FP.Total('',TyB1,(SumB1));
              Result:=CheckErrorExellio;
              if not Result then Abort;
            end else
            begin
              FP.Total('',TyB1,(SumItog-SumOplat));
              Result:=CheckErrorExellio;
              if not Result then Abort;
            end;
            FP.CloseFiscalReceipt;
            Result:=CheckErrorExellio;
            if not Result then Abort;
          end;
          FNumVoidChek:='';
        except
          FP.CancelReceipt;
          Result:=False;
          if FLastError='' then FLastError:='ERP_9991';
        end;
      end;
    EKKA_FP2000:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        case TypeOplat of
          1:Ty:=4;
          4:Ty:=1;
          3:Ty:=2;
          2:Ty:=3;
        end;
        if IsDnepr then
          TyB1:=4
        else
          TyB1:=2;
        try
          if SumB1=0 then
          begin
            Res1:=FP.TotalEx(TakedSumm,Ty);
            Result:=CheckErrorExellio;
            if not Result then raise EAbort.Create('er1');
          end
          else
          begin
            Res:=FP.GetFiscalTransactionStatus;
            Result:=CheckErrorExellio;
            if not Result then raise EAbort.Create('er2');
            SumItog:=Res.LastCheckSum;
            SumOplat:=Res.LastCheckPaySum;
            if (SumItog-SumOplat)>SumB1 then
            begin
              Res:=FP.Total((SumItog-SumOplat)-SumB1,Ty);
              Result:=CheckErrorExellio;
              if not Result then raise EAbort.Create('er3');
              Res:=FP.Total(SumB1,TyB1);
              Result:=CheckErrorExellio;
              if not Result then raise EAbort.Create('er4');
            end
            else
            begin
              Res:=FP.Total((SumItog-SumOplat),TyB1);
              Result:=CheckErrorExellio;
              if not Result then raise EAbort.Create('er5');
            end;
            FP.CloseFiscalCheck;
            Result:=CheckErrorExellio;
            if not Result then raise EAbort.Create('er6');
          end;
          FNumVoidChek:='';
        except
          on E:Exception do
          begin
//                       ShowMessage(E.Message);
            FP.CancelCheck;
            Result:=False;
            if FLastError='' then FLastError:='ERP_9991';
          end;
        end;
      end;
    EKKA_N707:
      begin//fpCloseFiscalReceipt
{
    ���� �����:
          �����    | N707 | ��������
     1 - ������ 3  |   3  | ������ � ������
     2 - ������ 2  |   4  | ������ � ������� ��������� �����
     3 - ������ 1  |   2  | ������ �����
     4 - ��������  |   1  | ������ ���������
}
        Result:=ReConnect;
        if not Result then Exit;
//                 Case TypeOplat of
//                   1: Ty:=3;
//                   4: Ty:=1;
//                   3: Ty:=2;
//                   2: Ty:=4;
//                 end;
        case TypeOplat of
          1:Ty:=3;//������ � ������
          2:Ty:=4;//������ � ������� ��������� �����
          3:Ty:=2;//������ �����
          4:Ty:=1;//������ ���������
        end;
        curr_check.Add('$'+CurrToStr(TakedSumm));
        if Ty<>4 then
        begin
                   //1 - ������ ��������� ��� 2 - ������ ����� ��� 3 - ������ � ������
          if PrintCheck(curr_check.Text,ErrorCode,ErrorDescription,curr_chek,IPAddr,Ty) then
          begin
            Result:=false;
            EKKA.FLastError:=trim(ErrorCode+' '+ErrorDescription);
          end
          else
          begin
            Result:=true;
            EKKA.FLastError:=trim(ErrorCode+' '+ErrorDescription);
          end;
        end
        else
        begin
                   //4 - ������ � ������� ��������� �����
                   //if PrintCheck(curr_check.Text,ErrorCode,ErrorDescription,curr_chek,IPAddr, Ty, 1, '000000000000000') then
          if PrintCheck(curr_check.Text,ErrorCode,ErrorDescription,curr_chek,IPAddr,Ty,RRN,BankCard) then
          begin
            Result:=false;
            EKKA.FLastError:=trim(ErrorCode+' '+ErrorDescription);
          end
          else
          begin
            Result:=true;
            EKKA.FLastError:=trim(ErrorCode+' '+ErrorDescription);
          end;
        end;
{
                 if PrintCheck(curr_check.Text,ErrorCode,ErrorDescription,curr_chek,IPAddr, Ty) then
                 begin
                   Result:=false;
                   EKKA.FLastError:=trim(ErrorCode+' '+ErrorDescription);
                 end
                 else
                 begin
                   Result:=true;
                   EKKA.FLastError:=trim(ErrorCode+' '+ErrorDescription);
                 end;
}
      end;
    EKKA_E810T: begin //fpCloseFiscalReceipt
{
    ���� �����:
          �����    | E810T| ��������
     1 - ������ 3  |   2  | ������ � ������
     2 - ������ 2  |   1  | ������ � ������� ��������� �����
     3 - ������ 1  |   3  | ������ �����
     4 - ��������  |   4  | ������ ���������
}
                  FLastError:='';
                  try
                    case TypeOplat of
                      1:Ty:=2;//������ � ������
                      2:Ty:=1;//������ � ������� ��������� �����
                      3:Ty:=3;//������ �����
                      4:Ty:=4;//������ ���������
                    end;
                    if IsDnepr then TyB1:=2 else TyB1:=3;

                    //Result:=ReConnect;
                    if FIsConnected then
                     begin

                      if FDiscOnAllSum=True then
                       begin
                        if FDiscSumAll<0 then
                         Result:=ics.FPMakeDiscount(false,false,Trunc(Abs(FDiscSumAll*100)),'')
                        else
                         Result:=ics.FPMakeMarkup(false,false,Trunc(FDiscSumAll*100),'');
                       end;

                      if not Result then raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                      if SumB1=0 then
                       begin
                        case Ty of
                         1: Result:=ics.FPPaymentByCard(Ty, ics.prSumTotal,true,true,BankCard,IntToStr(RRN)); //������ � ������� ��������� �����
                         2: Result:=ics.FPPayment(Ty, ics.prSumTotal,true,true,''); //������ � ������
                         3: Result:=ics.FPPayment(Ty, ics.prSumTotal,true,true,''); //������ �����
                         4: Result:=ics.FPPayment(Ty, ics.prSumTotal,true,true,''); //������ ���������
                        end;
                        if not Result then raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                       end else begin
                                 if ics.prSumTotal>Trunc(SumB1*100) then
                                  begin
                                   Result:=ics.FPPayment(TyB1,Trunc(SumB1*100),false,true,'');
                                   if not Result then raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                                   Result:=ics.FPPayment(Ty, ics.prSumTotal-Trunc(SumB1*100),false,true,'');
                                   if not Result then raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                                  end else begin
                                            Result:=ics.FPPayment(TyB1,ics.prSumTotal,true,true,'');
                                            if not Result then raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                                           end; 
                                end;

                     end
                    else
                      raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                end;
    EKKA_VIRTUAL:begin
                  try
                   Result:=ReConnect;

                   sCheck:='{"num_fiscal":"'+FVZhNumS+'",';

                   Case Check.TypeChek of
                    CH_SALE:sCheck:=sCheck+'"action_type":"Z_SALE",';
                    CH_BACK:sCheck:=sCheck+'"action_type":"RETURN",';
                   end;

                   sCheck:=sCheck+'"products": [';
                   for i:=Low(Check.Products) to High(Check.Products) do
                    begin
                     sCheck:=sCheck+'{'+
                             '"letters":"'+Check.Products[i].Letter+'",'+
                             '"tax_prc":'+IntToStr(Check.Products[i].TaxPrc)+','+
                             '"code":"'+IntToStr(Check.Products[i].Code)+'",'+
                             '"unit_code":"'+Check.Products[i].UnitCode+'",'+
                             '"unit_name":"'+Check.Products[i].UnitName+'",'+
                             '"name":"'+Check.Products[i].Name+'",'+
                             '"uktzed":"'+Check.Products[i].UKTZED+'",'+
                             '"amount":'+IntToStr(Check.Products[i].Amount)+','+
                             '"price":'+CurrToStrF(Check.Products[i].Price,ffFixed,2)+','+
                             '"cost":'+CurrToStrF(Check.Products[i].Cost,ffFixed,2)+','+
                             '"sum_discount":'+CurrToStrF(Check.Products[i].Discount,ffFixed,2)+
                             '}';
                     if i<High(Check.Products) then sCheck:=sCheck+',';

                    end;
                   Check.SumNal:=0;
                   Check.SumB1:=0;
                   Check.SumB2:=0;
                   Check.SumB3:=0;

                   Check.TakedSum:=TakedSumm;

                   sCheck:=sCheck+'],';
                   sPm:='';
                   sCheck:=sCheck+'"payments": [';
                   if FSumChek-SumB1>0 then
                    begin
                     Case TypeOplat of
                      1:begin sPm:='{"code":"3","name":"�����Ҳ���.3",'; Check.SumB3:=FSumChek-SumB1; end;
                      2:begin sPm:='{"code":"2","name":"�����Ҳ���.2",'; Check.SumB2:=FSumChek-SumB1 end;
                      3:begin sPm:='{"code":"1","name":"�����Ҳ���.1",'; Check.SumB1:=FSumChek-SumB1; end;
                      4:begin sPm:='{"code":"0","name":"��Ҳ���", "noround":1, '; Check.SumNal:=FSumChek-SumB1; end;
                     end;
                     sPm:=sPm+'"sum":"'+CurrToStrF(FSumChek-SumB1,ffFixed,2)+'",';
                     if (TypeOplat=4) and (TakedSumm>FSumChek-SumB1) then sPm:=sPm+'"sum_provided":"'+CurrToStrF(TakedSumm,ffFixed,2)+'","sum_remains":"'+CurrToStrF(TakedSumm-(FSumChek-SumB1),ffFixed,2)+'"'
                                                                     else sPm:=sPm+'"sum_provided":"'+CurrToStrF(FSumChek-SumB1,ffFixed,2)+'","sum_remains":0';
                     sPm:=sPm+'}';
                    end;

                   if sPm<>'' then sCheck:=sCheck+sPm;
                   if SumB1>0 then
                    begin
                     if sPm<>'' then sCheck:=sCheck+',';
                     if IsDnepr then begin sCheck:=sCheck+'{"code":"3","name":"�����Ҳ���.3",'; Check.SumB3:=SumB1; end
                                else begin sCheck:=sCheck+'{"code":"1","name":"�����Ҳ���.1",'; Check.SumB1:=SumB1; end;
                     sCheck:=sCheck+
                             '"sum":"'+CurrToStrF(SumB1,ffFixed,2)+'",'+
                             '"sum_provided":"'+CurrToStrF(SumB1,ffFixed,2)+'"';
                     sCheck:=sCheck+'}';

                    end;

                   QrEx.Close;
                   QrEx.SQL.Clear;
                   QrEx.SQL.Add('declare @url varchar(1000),');
                   QrEx.SQL.Add('        @textWidth tinyint');
                   QrEx.SQL.Add('set @url=ecr.GetValue(''URI'')');
                   QrEx.SQL.Add('select case when @url like ''%10.%'' then 24 else 32 end as TextWidth');
                   QrEx.Open;

                   sCheck:=sCheck+'],';

                   {
                   if High(Check.Service)>-1 then
                    begin
                     sStr:='';
                     sCheck:=sCheck+'"footer":"';
                     for i:=Low(Check.Service) to High(Check.Service) do
                      begin
                       sStr:=sStr+Check.Service[i].S;
                       if i<High(Check.Service) then
                        sStr:=sStr+'\n'
                      end;
                     sCheck:=sCheck+Copy(sStr,1,2000)+'",'
                    end;
                   }

                   sCheck:=sCheck+
                           '"open_shift":false,'+
                           '"local_number":"'+IntToStr(Check.NumbChek)+'",'+
                           //'"no_pdf":"'+IntToStr(BoolToInt(Not IsPrintCheck))+'",'+
                           '"no_pdf":false,'+
                           '"print_width":"'+QrEx.FieldByName('TextWidth').AsString+'",'+
                           '"total_sum": "'+CurrToStrF(SumChek,ffFixed,2)+'"}';

//                   Check.TakedSumm:=TakedSumm;
                   try
                    QrEx.Close;
                    QrEx.SQL.Text:=sCheck;
                    QrEx.SQL.SaveToFile('c:\log\JSONcheck.txt');
                   except
                   end;

                   QrEx.Close;
                   QrEx.SQL.Text:='exec ecr.spY_CheckSaleBack :check,'+IntToStr(KassaID)+','+IntToStr(fForce)+','+IntToStr(fID_User);
                   QrEx.Parameters.ParamByName('check').Value:=sCheck;

                   try
                    QrEx.SQL.SaveToFile('c:\log\spY_CheckSaleBack.txt');
                   except
                   end;

                   FOrderNum:='';
                   QrEx.Open;

                   FOrderNum:=QrEx.FieldByName('OrderNum').AsString;
                   FTypeChek:=QrEx.FieldByName('EmulEKKA').AsInteger;
                   FVzhNum:=StrToInt64(QrEx.FieldByName('Vzh').AsString);
                   fRealizDay:=QrEx.FieldByName('RealizDay').AsCurrency;
                   fJsonChek:=sCheck;

                   Check.strH1:=QrEx.FieldByName('strH1').AsString;
                   Check.strH2:=QrEx.FieldByName('strH2').AsString;
                   Check.strH3:=QrEx.FieldByName('strH3').AsString;
                   Check.strH4:=QrEx.FieldByName('strH4').AsString;
                   Check.strH5:=QrEx.FieldByName('strH5').AsString;
                   Check.ID:=QrEx.FieldByName('ID').AsString;
                   Check.PN:=QrEx.FieldByName('PN').AsString;
                   Check.FN:=QrEx.FieldByName('FN').AsString;
                   Check.DtCheck:=Now();

                   if (FOrderNum<>NOT_FISCAL) and
                      (QrEx.FieldByName('IsOwnCheckPDF').AsInteger=0) then SaveBlobAndOpen(QrEx.FieldByName('pdf'),'Check');
                                           { else PrintChek_NOT_FISCAL(Check);}

                   FLastError:='';
                   Result:=True;
                  except
                   on E:Exception do
                    begin
                     FOrderNum:=ON_ERROR;
                     FLastError:=E.Message;
                     Result:=false;
                    end;
                  end;
                 end;
  end;
end;

procedure TEKKA.printChek_NOT_FISCAL(var Check:TCheck);
var Tb:TTableObj;
    i,SumKol:Integer;
    SumA,SumB,SumV,SumCheck:Currency;
    IsNDSA,IsNDSB,IsNDSV:Boolean;
    Bm:TBitMap;
    QRCode:TDelphiZXingQRCode;
    FName:String;

 function AddOneCol:TTableObj;
  begin
   PrintRep.Align:=AL_LEFT;
   PrintRep.Font.Style:=[];
   PrintRep.AddTable(1,1);
   Tb:=PrintRep.LastTable;
   Tb.SetWidths('510');
   Tb.SetBorders(1,1,1,1,EMPTY_BORDER);
   Result:=Tb;
  end;

 function AddTwoCol(Txt1,Txt2:String; Fstl1:TFontStyles=[]; Fstl2:TFontStyles=[fsBold]):TTableObj;
  begin
   PrintRep.Align:=AL_LEFT;
   PrintRep.Font.Style:=[];
   PrintRep.AddTable(2,1);
   Tb:=PrintRep.LastTable;
   Tb.SetWidths('320,190');
   Tb.SetBorders(1,1,2,1,EMPTY_BORDER);
   Tb.Cell[1,1].Font.Style:=Fstl1;
   Tb.Cell[1,1].AddText(Txt1);

   Tb.Cell[2,1].Font.Style:=Fstl2;
   Tb.Cell[2,1].Align:=AL_RIGHT;
   Tb.Cell[2,1].AddText(Txt2);
   Result:=Tb;
  end;

 procedure PrintServiceText(TextPos:Byte);
 var i:Integer;
     Tb:TTableObj;
     QRCode:TDelphiZXingQRCode;
     Bm:TBitMap;
     S:String;
  begin
   for i:=Low(Check.Service) to High(Check.Service) do
    if Check.Service[i].TextPos=TextPos then
     begin
      Tb:=AddOneCol;

      if Copy(Check.Service[i].S,1,3)='QR_' then
       try
        QRCode:=TDelphiZXingQRCode.Create;
        try
         QRCode.RegisterEncoder(ENCODING_WIN1251, TWin1251Encoder);
         QRCode.RegisterEncoder(ENCODING_URL, TURLEncoder);

         QRCode.BeginUpdate;
         QRCode.Data:=Copy(Check.Service[i].S,4,Length(Check.Service[i].S)-3);
         QRCode.Encoding:=0;
         QRCode.ErrorCorrectionOrdinal:=TErrorCorrectionOrdinal(0);
         QRCode.QuietZone:=4;
         QRCode.EndUpdate(True);
         Bm:=TBitMap.Create;
         try
          Bm.Width:=QRCode.Columns*10;
          Bm.Height:=QRCode.Rows*10;
          Bm.Canvas.Pen.Color:=clBlack;
          Bm.Canvas.Brush.Color:=clWhite;

          DrawQR(Bm.Canvas,Rect(0,0,Bm.Width,Bm.Height),QRCode,0,TQRDrawingMode(0),True);

          Tb.Cell[1,1].Align:=AL_CENTER;
          Tb.Cell[1,1].LeftMargin:=100;
          Tb.Cell[1,1].RightMargin:=100;
          Tb.Cell[1,1].Stretch:=True;
          Tb.Cell[1,1].AddImage(Bm);
         finally
          Bm.Free;
         end;
        finally
         QRCode.Free;
        end;
      except
      end else
     if Copy(Check.Service[i].S,1,7)='PCOD00E' then
      begin
       S:=Copy(Check.Service[i].S,8,12);
       Tb.Cell[1,1].Align:=AL_CENTER;
       Tb.Cell[1,1].Font.Name:='EanBwrP36Tt';
       Tb.Cell[1,1].Font.Size:=10;
       Tb.Cell[1,1].Font.CharSet:=ANSI_CHARSET;
       Tb.Cell[1,1].AddText(GenEAN13(S));
      end else begin
                Tb.Cell[1,1].Align:=Check.Service[i].Align;
                Tb.Cell[1,1].Font.Style:=Check.Service[i].Style;
                Tb.Cell[1,1].AddText(Check.Service[i].S);
               end; 
     end;
  end;

 Begin
  PrintRep(1).Clear;
  With PrintRep do
   begin
    SetDefault;
    Font.Name:='Tahoma';
    Font.Size:=3;
    TopMargin:=30;
    LeftMargin:=48;

    Tb:=AddOneCol;
    Tb.Cell[1,1].Align:=AL_CENTER;
    Tb.Cell[1,1].Font.Style:=[fsBold];
    if Check.strH1<>'' then
     Tb.Cell[1,1].AddText('  '+Check.strH1+#10);
    if Check.strH2<>'' then
     Tb.Cell[1,1].AddText(Check.strH2+#10);
    if Check.strH3<>'' then
     Tb.Cell[1,1].AddText(Check.strH3+#10);
    if Check.strH4<>'' then
     Tb.Cell[1,1].AddText(Check.strH4+#10);
    if Check.strH5<>'' then
     Tb.Cell[1,1].AddText(Check.strH5+#10);

    Tb.Cell[1,1].Align:=AL_LEFT;
    Tb.Cell[1,1].AddText(#10'��  '+Check.PN+#10);
    Tb.Cell[1,1].AddText('I�  '+Check.ID+#10#10);

    Tb.Cell[1,1].Align:=AL_CENTER; Tb.Cell[1,1].Font.Style:=[fsBold];
//    Tb.Cell[1,1].AddText('------------------------------------------------');

    if Check.TypeChek=CH_BACK then
     begin
      Tb:=AddOneCol;
      Tb.Cell[1,1].Align:=AL_CENTER; Tb.Cell[1,1].Font.Style:=[fsBold];
      Tb.Cell[1,1].AddText('����������'#10);
     end;

    PrintServiceText(0);

    if Check.TypeChek in [CH_SALE,CH_BACK] then
     begin
      SumA:=0; SumB:=0; SumV:=0; SumCheck:=0;
      IsNDSA:=False; IsNDSB:=False; IsNDSV:=False;
      for i:=Low(Check.Products) to High(Check.Products) do
       begin
        Tb:=AddOneCol;
        Tb.Cell[1,1].Align:=AL_LEFT; Tb.Cell[1,1].Font.Style:=[];
        Tb.Cell[1,1].AddText('��� ��� '+Check.Products[i].UKTZED+#10);
        Tb.Cell[1,1].Align:=AL_JUST;
        Tb.Cell[1,1].AddText(Check.Products[i].Name+#10);

        AddTwoCol(CurrToStrF(Check.Products[i].Price,ffFixed,2)+' * '+IntToStr(Abs(Check.Products[i].Amount))+' '+Check.Products[i].UnitName,
                  CurrToStrF(Check.Products[i].Price*Abs(Check.Products[i].Amount),ffFixed,2)+' ('+Check.Products[i].Letter+')',[],[fsBold]);

        if Check.Products[i].Discount<0 then
         AddTwoCol('������',CurrToStrF(Check.Products[i].Discount,ffFixed,2)+' ('+Check.Products[i].Letter+')')
        else
        if Check.Products[i].Discount>0 then
         AddTwoCol('���i���',CurrToStrF(Check.Products[i].Discount,ffFixed,2)+' ('+Check.Products[i].Letter+')');

        Case Check.Products[i].Letter of
         '�':begin IsNDSA:=True; SumA:=SumA+Check.Products[i].Price*Check.Products[i].Amount/6; end;
         '�':begin IsNDSB:=True; SumB:=SumB+Check.Products[i].Price*Check.Products[i].Amount*(7/107); end;
         '�':IsNDSV:=True;
        end;
//      SumCheck:=SumCheck+Check.Products[i].Price*Check.Products[i].Amount+Check.Products[i].Discount;
       end;



      Tb:=AddOneCol;
      Tb.Cell[1,1].Align:=AL_CENTER; Tb.Cell[1,1].Font.Style:=[fsBold];
      Tb.Cell[1,1].AddText('������'#10);

     {
      if Check.SumNal>0 then
       begin
        if Check.TakedSum>Check.SumNal then AddTwoCol('���I���',CurrToStrF(Check.TakedSum,ffFixed,2)+' ���')
                                       else AddTwoCol('���I���',CurrToStrF(Check.SumNal,ffFixed,2)+' ���');
       end;
     }

      SumCheck:=Check.SumNal+Check.SumB1+Check.SumB2+Check.SumB3;

      Tb:=AddTwoCol('����',CurrToStrF(SumCheck,ffFixed,2)+' ���',[fsBold],[fsBold]);
      Tb.Cell[1,1].Font.Style:=[fsBold];

      if IsNDSA then AddTwoCol('��� � 20%',CurrToStrF(SumA,ffFixed,2)+' ���');
      if IsNDSB then AddTwoCol('��� � 7%',CurrToStrF(SumB,ffFixed,2)+' ���');
      if IsNDSV then AddTwoCol('��� � 0%',CurrToStrF(SumV,ffFixed,2)+' ���');

      if Check.SumB1>0  then AddTwoCol('������I���.1',CurrToStrF(Check.SumB1,ffFixed,2)+' ���');
      if Check.SumB2>0  then AddTwoCol('������I���.2',CurrToStrF(Check.SumB2,ffFixed,2)+' ���');
      if Check.SumB3>0  then AddTwoCol('������I���.3',CurrToStrF(Check.SumB3,ffFixed,2)+' ���');
      //if Check.SumNal>0 then AddTwoCol('���I���',CurrToStrF(Check.SumNal,ffFixed,2)+' ���');

      if (Check.TakedSum>Check.SumNal) and (Check.SumNal>0) and (Check.TypeChek=CH_SALE) then
       begin
        AddTwoCol('���I���',CurrToStrF(Check.TakedSum,ffFixed,2)+' ���');
        AddTwoCol('�����',CurrToStrF(-(Check.TakedSum-Check.SumNal),ffFixed,2)+' ���');
       end else AddTwoCol('���I���',CurrToStrF(Check.SumNal,ffFixed,2)+' ���');

     end;

    Tb:=AddOneCol;
    Tb.Cell[1,1].AddText(' '#10);

    if (Check.OrderNum<>NOT_FISCAL) and (Check.OrderNum<>'') and (Check.TypeChek in [CH_SALE,CH_BACK]) then
     begin
      AddTwoCol('�i�������� ����� ����',Check.OrderNum);
//      AddTwoCol('����� ���� (�����.)',IntToStr(Check.NumbChek));
     end;
     
    AddTwoCol(DateToStr(Check.DtCheck),TimeToStr(Check.DtCheck),[]);

    if (Check.guid<>'') and (Check.TypeChek in [CH_SALE,CH_BACK]) then
     try
      QRCode:=TDelphiZXingQRCode.Create;
      try
       QRCode.RegisterEncoder(ENCODING_WIN1251, TWin1251Encoder);
       QRCode.RegisterEncoder(ENCODING_URL, TURLEncoder);

       QRCode.BeginUpdate;
       QRCode.Data:=Check.URL;  
       QRCode.Encoding:=0;
       QRCode.ErrorCorrectionOrdinal:=TErrorCorrectionOrdinal(0);
       QRCode.QuietZone:=4;
       QRCode.EndUpdate(True);
       Bm:=TBitMap.Create;
       try
        Bm.Width:=QRCode.Columns*10;
        Bm.Height:=QRCode.Rows*10;
        Bm.Canvas.Pen.Color:=clBlack;
        Bm.Canvas.Brush.Color:=clWhite;

        DrawQR(Bm.Canvas,Rect(0,0,Bm.Width,Bm.Height),QRCode,0,TQRDrawingMode(0),True);

        Tb:=AddOneCol;
        Tb.Cell[1,1].Align:=AL_CENTER;
        Tb.Cell[1,1].LeftMargin:=100;
        Tb.Cell[1,1].RightMargin:=100;
        Tb.Cell[1,1].Stretch:=True;
        Tb.Cell[1,1].AddImage(Bm);
       finally
        Bm.Free;
       end;
      finally
       QRCode.Free;
      end;
    except
    end;

    AddTwoCol('�� ���� '+Check.FN,'������');

    Case Check.TypeChek of
     CH_SALE,CH_BACK:AddTwoCol('�I�������� ���','CashDesk',[]);
          CH_SERVICE:AddTwoCol('��������� ���','CashDesk',[]);
    end;

    AddTwoCol('����� ���� (�����.) ',IntToStr(Check.NumbChek));
    PrintServiceText(1);


{
    if High(Check.Service)>-1 then
     begin
      Tb:=AddOneCol;
      for i:=Low(Check.Service) to High(Check.Service) do
       Tb.Cell[1,1].AddText(Check.Service[i].S+#10);
     end;
 }

    if Check.TypeOut=1 then Check.IsPrinted:=PreView else
     begin
      try
       FName:=GetTemporaryFName('Check','.pdf');
       SaveToFilePDF(FName);
      except
      end;
      // PreView;
      Print(EKKA.PrinterPRRO);
     end;
   end;

 end;

function TEKKA.fpCheckCopy(Cnt:Byte=1; NChForce:Integer=0):Boolean;
var
  i, Nds, Ty: Integer;
  Art: Integer;
  SumChek: Currency;
  ErrCode, ErrMess: string;//��� ������ � ��������� �� ������ ��� N707
  curr_chek: T_cgi_chk_object;
begin
  if EmulEKKA then
  try
    FIsCopy:=True;
    try
      Qr1.Close;
      Qr1.SQL.Clear;
      Qr1.SQL.Add('exec spY_GetLastChek '+IntToStr(KassaID)+','+IntToStr(VzhNum));
//      Qr1.SQL.SaveToFile('C:\Log\NCh_.txt');
      Qr1.Open;
      FCopy_Chek:=Qr1.FieldByName('Numb_chek').AsInteger;
      if Qr1.FieldByName('IsBack').AsInteger=-1 then
        if Not fpSetBackReceipt(IntToStr(FCopy_Chek)) then raise Eabort.Create(FLastError);
      if Not fpOpenFiscalReceipt then raise Eabort.Create(FLastError);
      SumChek:=0;
      for i:=1 to Qr1.RecordCount do
      begin
        if i=1 then Qr1.First else Qr1.Next;
        if Qr1.FieldByName('IsBack').AsInteger=-1 then
          Art:=99999
        else
          Art:=0;
        if Qr1.FieldByName('type_tov').AsInteger=0 then Nds:=3 else
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
                       )
        then
          raise Eabort.Create(FLastError);
        SumChek:=SumChek+Qr1.FieldByName('Kol').AsInteger*Qr1.FieldByName('Cena').AsCurrency-Qr1.FieldByName('SumSkd').AsCurrency;
      end;
      Case Qr1.FieldByName('kassa_num').AsInteger of
        1, 3: Ty:=4;
        2, 4: Ty:=2;
      end;
      if Qr1.FieldByName('Bezgot1').AsCurrency>0 then
      begin
        if Not fpCloseFiscalReceipt(SumChek-Qr1.FieldByName('Bezgot1').AsCurrency,Ty,SumChek,Qr1.FieldByName('Bezgot1').AsCurrency,False) then raise Eabort.Create(FLastError);
      end
      else
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
  if Not (UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpCheckCopy;
    EKKA_DATECS3530T: begin
                        Result:=ReConnect;
                        if Not Result then Exit;
                        Result:=(MakeReceiptCopy(0,PrinterResults,0,'1')=0) and (FLastError='');
                      end;
    EKKA_EXELLIO: begin
                    Result:=ReConnect;
                    if Not Result then Exit;
                    if Cnt>2 then Cnt:=2;
                    FP.MakeReceiptCopy(Cnt);
                    Result:=CheckErrorExellio;
                  end;
    EKKA_FP2000: begin
                   Result:=ReConnect;
                   if Not Result then Exit;
                   if Cnt>2 then Cnt:=2;
                   FP.PrintCheckCopy(Cnt);
                   Result:=CheckErrorExellio;
                 end;
    EKKA_N707: begin //fpCheckCopy
                 Result:=ReConnect; if Not Result then Exit;
                 curr_check.Text:='L';
                 if PrintCheck(curr_check.Text,ErrCode,ErrMess,curr_chek,IPAddr) then
                 begin
                   FLastError:=trim(ErrCode+' '+ErrMess);
                   Result:=true;
                   exit;
                 end
                 else
                 begin
                   FLastError:=trim(ErrCode+' '+ErrMess);
                   Result:=false;
                   exit;
                 end;
               end;
    EKKA_E810T: begin //fpCheckCopy
                  FLastError:='';
                  try
                    //Result:=ReConnect;
                    if FIsConnected then
                    begin
                      Result:=ics.FPPrintLastKsefPacket;
                      if not Result then
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                    end
                    else
                      raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                     begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=true;
                    end;
                  end;
                end; //fpCheckCopy

  end;
end;

function TEKKA.fpServiceText(TextPos,Print2,FontHeight:Integer; S:string; ForcePrint:Boolean=False):Boolean;
var CA,P:Integer;
    i,l_str,new_start:integer;
    new_str:String;

{-- ��� "�����"
 �������� TextPos (��������� ���� fpServiceText ������������ � ������ ����������� ����, ��� ���������� ���� - �����������)
  0 - � ������� ����� ����
  1 - � ������ ����� ����

 �������� Print2
  0 ��� 1

 �������� FontHeight
  0 - �������
  1 - ��������� ������
  2 - ��������� ������
  3 - ��������� ������ � ������
}

{-- ��� ������������ ���
 �������� TextPos (��������� ���� fpServiceText ������������ � ������ ����������� ����, ��� ���������� ���� - �����������)
  0 - � ������� ����� ����
  1 - � ������ ����� ����

 �������� Print2
  1 - ������������ ������ �� ������ ����
  2 - ������������ �� ������
  3 - ������������ ������ �� ��a���� ����

 �������� FontHeight
  0 - ������� - []
  1 - ������  - [fsBold]
}

 begin
  FLastServiceText:=S;

  if EmulEKKA then
  try
//      bPrintHead;
//      MrFont.AddStr(S,FontHeight);
//      bPrintFooter(4);
    CA:=High(sArr)+1;
    SetLength(sArr,CA+1);
    sArr[CA].S:=S;
    sArr[CA].F:=FontHeight;
    if ForcePrint then
     MrFont.AddStr(S,FontHeight);
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
  if not(UseEKKA) then
   begin
    Result:=True;
    Exit;
   end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpServiceText(TextPos,Print2,FontHeight,S,False);
    EKKA_DATECS3530T:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        Result:=(PrintFiscalText(0,PrinterResults,0,PAnsiChar(S))=0)and(FLastError='');
      end;
    EKKA_EXELLIO:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        FP.PrintFiscalText(Copy(S,1,36));
        Result:=CheckErrorExellio;
      end;
    EKKA_FP2000:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        if S='' then S:=' ';
        FP.AddFiscalText(Copy(S,1,42));
        Result:=CheckErrorExellio;
      end;
    EKKA_N707:
      begin//fpServiceText
        Result:=ReConnect;
        if not Result then Exit;
                 //�� ����� 22 �������� � ������ �����������. ����� ������ �� ����� �� 22 ������� ��� ������
        l_str:=1;
        new_str:='';
        new_start:=1;
        for i:=1 to Length(S) do
        begin
          if l_str>=22 then
          begin
            new_str:=new_str+'"'+copy(s,new_start,i-new_start+1)+#13+#10;
            l_str:=1;
            new_start:=i+1;
          end
          else
            inc(l_str);
        end;
        new_str:=new_str+'"'+copy(s,new_start,i-new_start);
        curr_check.Add(new_str);
      end;
    EKKA_E810T: begin//fpServiceText
               {   FLastError:='';
                  try
                    //Result:=ReConnect;
                    if FIsConnected then
                    begin
                      Result:=ics.FPCommentLine(Copy(S,1,27),false);
                      if not Result then
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                    end
                    else
                      raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                }
                end;
   EKKA_VIRTUAL:try
                 CA:=High(Check.Service)+1;
                 SetLength(Check.Service,CA+1);
                 Check.Service[CA].S:=S;

                 if Check.TypeChek=CH_SERVICE then
                  Check.Service[CA].TextPos:=0
                 else
                  Check.Service[CA].TextPos:=TextPos;

                 Check.Service[CA].Align:=AL_LEFT;
                 Check.Service[CA].Style:=[];
                 Case Print2 of
                  2:Check.Service[CA].Align:=AL_CENTER;
                  3:Check.Service[CA].Align:=AL_RIGHT;
                 end;
                 if FontHeight=1 then Check.Service[CA].Style:=[fsBold];
                 Result:=True;
                except
                 on E:Exception do
                  begin
                   FLastError:=E.Message;
                   Result:=False;
                  end; 
                end;
  end;
end;

procedure TEKKA.printServiceInOut(tmpQr:TADOQuery; Param:Char);
var nm,FName:String;
    Tb:TTableObj;
 begin
{
  if tmpQr.FieldByName('EmulEKKA').AsInteger=0 then
   begin
    Case Param of
     'I':nm:='Input';
     'O':nm:='Output';
    end;
    SaveBlobAndOpen(QrEx.FieldByName('pdf'),nm);
   end else
  if tmpQr.FieldByName('EmulEKKA').AsInteger=1 then
}
   With PrintRep do
    begin
     Case Param of
      'I':nm:='�������� ��������';
      'O':nm:='�������� ������';
     end;
     Clear;
     SetDefault;
     Font.Name:='Tahoma';
     Font.Size:=3;
     TopMargin:=30;
     LeftMargin:=40;
     AddTable(2,4);
     Tb:=LastTable;
     Tb.SetWidths('335,175');

     Tb.MergeCells(1,1,2,1);
     Tb.MergeCells(1,3,2,3);
     Tb.SetBorders(1,1,2,4,EMPTY_BORDER);

     Tb.Cell[1,1].Align:=AL_CENTER;
     Tb.Cell[1,1].Font.Style:=[fsBold];
     if tmpQr.FieldByName('strH1').AsString<>'' then
      Tb.Cell[1,1].AddText(tmpQr.FieldByName('strH1').AsString+#10);
     if tmpQr.FieldByName('strH2').AsString<>'' then
      Tb.Cell[1,1].AddText(tmpQr.FieldByName('strH2').AsString+#10);
     if tmpQr.FieldByName('strH3').AsString<>'' then
      Tb.Cell[1,1].AddText(tmpQr.FieldByName('strH3').AsString+#10);
     if tmpQr.FieldByName('strH4').AsString<>'' then
      Tb.Cell[1,1].AddText(tmpQr.FieldByName('strH4').AsString+#10);
     if tmpQr.FieldByName('strH5').AsString<>'' then
      Tb.Cell[1,1].AddText(tmpQr.FieldByName('strH5').AsString+#10);

     Tb.Cell[1,1].Align:=AL_LEFT;
     Tb.Cell[1,1].AddText(#10'��  '+tmpQr.FieldByName('PN').AsString+#10);
     Tb.Cell[1,1].AddText('I�  '+tmpQr.FieldByName('ID').AsString+#10);

     Tb.Cell[1,1].Align:=AL_CENTER; Tb.Cell[1,1].Font.Style:=[fsBold];
     Tb.Cell[1,1].AddText('------------------------------------------------');

     Tb.Cell[1,2].Align:=AL_LEFT; Tb.Cell[2,2].Align:=AL_RIGHT;
     Tb.Cell[1,2].Font.Style:=[]; Tb.Cell[2,2].Font.Style:=[];
     Tb.Cell[1,2].AddText(nm+#10);            Tb.Cell[2,2].AddText(CurrToStrF(tmpQr.FieldByName('SumInOut').AsCurrency,ffFixed,2)+#10);
     Tb.Cell[1,2].AddText('����i � ���i'#10); Tb.Cell[2,2].AddText(CurrToStrF(tmpQr.FieldByName('SumCash').AsCurrency,ffFixed,2)+#10);

     Tb.Cell[1,3].Align:=AL_CENTER; Tb.Cell[1,3].Font.Style:=[fsBold];
     Tb.Cell[1,3].AddText('------------------------------------------------');

     Tb.Cell[1,4].Align:=AL_LEFT; Tb.Cell[2,4].Align:=AL_RIGHT;
     Tb.Cell[1,4].Font.Style:=[]; Tb.Cell[2,4].Font.Style:=[];

     Tb.Cell[1,4].AddText(DateToStr(tmpQr.FieldByName('DtRep').AsDateTime)+#10); Tb.Cell[2,4].AddText(TimeToStr(tmpQr.FieldByName('DtRep').AsDateTime)+#10);

     Tb.Cell[1,4].AddText('��  '+tmpQr.FieldByName('FN').AsString+#10);
     Tb.Cell[2,4].Font.Style:=[fsBold];
     Tb.Cell[2,4].AddText('������'+#10);
     Tb.Cell[2,4].Font.Style:=[];

     Tb.Cell[2,4].Font.Style:=[];
     Tb.Cell[1,4].AddText('��������� ���'); Tb.Cell[2,4].AddText('CashDesk');

     //PreView;
     {
      FName:=GetTemporaryFName(Param+'rep','.pdf');
      SaveToFilePDF(FName);
      ShellExecute(Application.Handle,'open',PChar(FName),PChar('/t'),nil,SW_SHOWNORMAL);
     }
     Print(EKKA.PrinterPRRO);
   end;
 end;

function TEKKA.fpCashInput(C:Currency):Boolean;
var
  ErrCode,ErrDescr:string;
  curr_chek:T_cgi_chk_object;
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

//      QrEx.SQL.Add('declare @P tinyint');
//      QrEx.SQL.Add('set @P='+IntToStr(P));
//      QrEx.SQL.Add('if (@P=0) /* or (@P=1 and getdate()>''2016-05-01'') */ ');

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
  if not(UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpCashInput(C);
    EKKA_DATECS3530T:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        Result:=(ServiceInputOutput(0,PrinterResults,0,Abs(C))=0)and(FLastError='');
      end;
    EKKA_EXELLIO:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        FP.InOut(Abs(C));
        Result:=CheckErrorExellio;
      end;
    EKKA_FP2000:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        FP.CashInput(Abs(C));
        Result:=CheckErrorExellio;
      end;
    EKKA_N707:
      begin//fpCashInput
        EKKA.FLastError:='';
        if CashInputOutput(abs(C),ErrCode,ErrDescr,curr_chek,IPAddr) then
        begin
          Result:=false;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescr);
        end
        else
        begin
          Result:=true;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescr);
        end;
      end;
    EKKA_E810T: begin //fpCashInput
                  FLastError:='';
                  try
                    //Result:=ReConnect;
                    if FIsConnected then
                    begin
                      Result:=ics.FPCashIn(trunc(C*100));
                      if not Result then
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                    end
                    else
                      raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                end;
    EKKA_VIRTUAL:begin
                  try
                   Result:=ReConnect;
                   QrEx.Close;
                   QrEx.SQL.Text:='exec ecr.spY_CashInOut 1,'+CurrToStrF(C,ffFixed,2)+','+IntToStr(KassaID)+',0,'+IntToStr(fForceInOut)+','+IntToStr(fID_User);
                   QrEx.Open;
                   printServiceInOut(QrEx,'I');
                   FLastError:='';
                   Result:=True;
                  except
                   on E:Exception do
                    begin
                     FLastError:=E.Message;
                     Result:=false;
                    end;
                  end;
                 end;
  end;
end;

function TEKKA.fpCashOutput(C:Currency;P:Byte=0):Boolean;
var
  ErrCode,ErrDescr:string;
  curr_chek:T_cgi_chk_object;
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
//      QrEx.SQL.Add('declare @P tinyint');
//      QrEx.SQL.Add('set @P='+IntToStr(P));
//      QrEx.SQL.Add('if (@P=0) /* or (@P=1 and getdate()>''2016-05-01'') */ ');
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
  if not(UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:begin
                      Result:=inherited fpCashOutput(C);
                      fSumInOutK:=C;
                     end; 
    EKKA_DATECS3530T:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        Result:=(ServiceInputOutput(0,PrinterResults,0,-Abs(C))=0)and(FLastError='');
      end;
    EKKA_EXELLIO:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        FP.InOut(-Abs(C));
        Result:=CheckErrorExellio;
      end;
    EKKA_FP2000:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        FP.CashOutput(Abs(C));
        Result:=CheckErrorExellio;
      end;
    EKKA_N707:
      begin//fpCashOutput
        EKKA.FLastError:='';
        if CashInputOutput(-abs(C),ErrCode,ErrDescr,curr_chek,IPAddr) then
        begin
          Result:=true;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescr);
        end
        else
        begin
          Result:=false;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescr);
        end;
      end;
    EKKA_E810T: begin //fpCashOutput
                  FLastError:='';
                  try
                    //Result:=ReConnect;
                    if FIsConnected then
                    begin
                      Result:=ics.FPCashOut(trunc(C*100));
                      if not Result then
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                    end
                    else
                      raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                end;
    EKKA_VIRTUAL:begin
                  try
                   Result:=ReConnect;
                   QrEx.Close;
                   QrEx.SQL.Text:='exec ecr.spY_CashInOut -1,'+CurrToStrF(C,ffFixed,2)+','+IntToStr(KassaID)+',0,'+IntToStr(fForceInOut)+','+IntToStr(fID_User);

                   try
                    QrEx.SQL.SaveToFile('c:\log\spY_CashInOut.txt');
                   except
                   end;

                   QrEx.Open;

                   fSumInOutB:=QrEx.FieldByName('SumInOutB').AsCurrency;
                   fSumInOutK:=QrEx.FieldByName('SumInOutK').AsCurrency;
                   fSumCashB:=QrEx.FieldByName('SumCashB').AsCurrency;
                   fSumCashK:=QrEx.FieldByName('SumCashK').AsCurrency;

                   printServiceInOut(QrEx,'O');
                   FLastError:='';
                   Result:=True;
                  except
                   on E:Exception do
                    begin
                     FLastError:=E.Message;
                     Result:=false;
                    end;
                  end;
                 end;

  end;
end;

function TEKKA.fpActiveLogo(P:Byte):Boolean;
var
  B:Boolean;
begin
  if (not(UseEKKA)or(EmulEKKA=True)) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpActiveLogo(P);
    EKKA_DATECS3530T:
      begin
        if not(P in [0,1]) then
        begin
          FLastError:='ERP_9992';
          Exit;
        end;
        Result:=ReConnect;
        if not Result then Exit;
        Result:=(SetHeaderFooter(0,PrinterResults,0,1,PAnsiChar(IntToStr(P)[1]))=0)and(FLastError='');
        ShowMessage(FLastError);
      end;
    EKKA_EXELLIO:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        if P=0 then
          B:=False
        else
          B:=True;
        FP.EnableLogo(B);
        Result:=CheckErrorExellio;
      end;
    EKKA_FP2000:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        if P=0 then
          B:=False
        else
          B:=True;
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

procedure TEKKA.printXRep(EmEKKA:Byte; FData:TField; Cap:String);
 begin
 // if EmEKKA=1 then
   fpZXPrintReport('X')

 { else
   SaveBlobAndOpen(FData,Cap);
   }
 end;


function TEKKA.fpZeroCheck(Dt:TDateTime=0):Boolean;
var
  ErrCode,ErrMess:string;
  curr_chek:T_cgi_chk_object;
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

{    if Dt>0 then
     FDtChek:=Dt
    else
 }
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
  if not(UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpZeroCheck;
    EKKA_DATECS3530T:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        Result:=fpCancelFiscalReceipt;
        if not Result then Exit;
        Result:=fpOpenFiscalReceipt;
        if not Result then Exit;
        Result:=fpCloseFiscalReceipt(0,4);
      end;
    EKKA_EXELLIO:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        FP.PrintNullCheck;
        Result:=CheckErrorExellio;
      end;
    EKKA_FP2000:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        Result:=fpCancelFiscalReceipt;
        if not Result then Exit;
        Result:=fpOpenFiscalReceipt;
        if not Result then Exit;
        Result:=fpCloseFiscalReceipt(0,4);
      end;
    EKKA_N707:
      begin//fpZeroCheck
        EKKA.FLastError:='';
        if PrintZerroCheck(ErrCode,ErrMess,curr_chek,IPAddr) then
        begin
          Result:=true;
          EKKA.FLastError:=trim(ErrCode+' '+ErrMess);
        end
        else
        begin
          Result:=false;
          EKKA.FLastError:=trim(ErrCode+' '+ErrMess);
        end;
      end;
    EKKA_E810T: begin //fpZeroCheck
                  FLastError:='';
                  try
                    //Result:=ReConnect;
                    if FIsConnected then
                    begin
                      Result:=ics.FPPrintZeroReceipt;
                      if not Result then
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                    end
                    else
                      raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                     begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=true;
                    end;
                  end;
                end;
    EKKA_VIRTUAL:begin
                  try
                   Result:=ReConnect;
                   QrEx.Close;
                   QrEx.SQL.Text:='exec ecr.spY_OpenShift '+IntToStr(KassaID)+','+IntToStr(ID_User);
                   QrEx.Open;

                   printXRep(QrEx.FieldByName('EmulEKKA').AsInteger,QrEx.FieldByName('pdf'),'xRep');

                   FLastError:='';
                   Result:=True;
                  except
                   on E:Exception do
                    begin
                     FLastError:=E.Message;
                     Result:=false;
                    end;
                  end;
                 end;
  end;
end;

procedure TEKKA.fpSendToEKV;
var
  NumPak:Integer;
begin
  if EmulEKKA then
  try
    Qr.Close;
    Qr.SQL.Clear;
    Qr.SQL.Add('declare @np int ');
    Qr.SQL.Add('set @np=IsNull((select top 1 Value from Spr_Const where Descr=''NumPak'+IntToStr(KassaID)+'''),0) ');
    Qr.SQL.Add('delete from Spr_const where Descr=''NumPak'+IntToStr(KassaID)+'''');
    Qr.SQL.Add('insert into Spr_const(Descr,Value) values(''NumPak'+IntToStr(KassaID)+''',convert(varchar,@np+10)) ');
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
var
  N1,N2:Integer;
  ErrCode,ErrDescr:string;
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
  if not(UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpPerFullRepD(D1,D2);
    EKKA_DATECS3530T:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        Result:=(PrintReportByDate(0,PrinterResults,0,PAnsiChar(Passw[15]),PAnsiChar(FormatDateTime('ddmmyy',D1)),PAnsiChar(FormatDateTime('ddmmyy',D2)))=0)and(FLastError='');
      end;
    EKKA_EXELLIO:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        FP.PrintRepByDate('0000',FormatDateTime('ddmmyy',D1),FormatDateTime('ddmmyy',D2));
        Result:=CheckErrorExellio;
      end;
    EKKA_FP2000:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        FP.PeriodicReport(D1,D2);
        Result:=CheckErrorExellio;
      end;
    EKKA_N707:
      begin
        ErrCode:='';
        ErrDescr:='';
        Result:=ReConnect;
        if not Result then Exit;

        EKKA.FLastError:='';
        if PrintFMReport(IPAddr,ErrCode,ErrDescr,PRINTFMREPORT_FULL_BY_DATE,D1,D2,-1,-1) then
        begin
          Result:=true;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescr);
        end
        else
        begin
          Result:=false;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescr);
        end;
      end;
    EKKA_E810T: begin //fpPerFullRepD
                  FLastError:='';
                  try
                    //Result:=ReConnect;
                    if FIsConnected then
                    begin
                      Result:=ics.FPMakePeriodicReportOnDate(P_REPORTS,D1,D2);
                      if not Result then
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                    end
                    else
                      raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                end; //fpPerFullRepD
    EKKA_VIRTUAL:begin
                  try
                   Result:=ReConnect;
                   QrEx.Close;
                   QrEx.SQL.Text:='exec ecr.spY_PeriodReports '''+FormatDateTime('yyyy-mm-dd',D1)+''','''+FormatDateTime('yyyy-mm-dd',D2)+''','+IntToStr(KassaID);
                   QrEx.Open;
                   SaveBlobAndOpen(QrEx.FieldByName('pdf'),'xRep');
                   FLastError:='';
                   Result:=True;
                  except
                   on E:Exception do
                    begin
                     FLastError:=E.Message;
                     Result:=false;
                    end;
                  end;
                 end;
  end;
end;

function TEKKA.fpPerFullRepN(N1,N2:Integer):Boolean;
var
  i,MinNumZ,MaxNumZ:Integer;
  DtWriteZ,MinDateZ,MaxDateZ:TDateTime;
  ErrCode,ErrDescr:string;
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
    if (Qr.FieldByName('Sum5').AsCurrency>0)or(Qr.FieldByName('Sum5').AsCurrency>0) then
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
      MrFont.AddStr2J('����� ������� �i� ����',CurrToStrF_(Qr.FieldByName('Sum_nBBb_').AsCurrency),0);
      MrFont.AddStr2J('����� ������� �� �����',CurrToStrF_(Qr.FieldByName('Sum_nBB_').AsCurrency),0);
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
    MrFont.AddStr2J('������� �������',CurrToStrF_(Qr.FieldByName('Sum6').AsCurrency),0);
    MrFont.AddStrC('- - - - - - - - - ������� - - - - - - -',0);
    MrFont.AddStr2J('������',CurrToStrF_(Qr.FieldByName('Sum4').AsCurrency-Qr.FieldByName('Sum5').AsCurrency),0);
    MrFont.AddStr2J('�����������',CurrToStrF_(Qr.FieldByName('Sum7').AsCurrency-Qr.FieldByName('Sum8').AsCurrency),0);
    MrFont.AddStrC('- - - - - - - - - - - - - - - - - - - -',0);
    MrFont.AddStr2J('����� ���������� ����',Qr.FieldByName('NLastChek').AsString,0);
      { -------------------------------------------------------------------------- }
    MrFont.AddStrC('- - - - -  �i������ �� �-��i���  - - - - ',0);
    for i:=1 to Qr1.RecordCount do
    begin
      if i=1 then
        Qr1.First
      else
        Qr1.Next;
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
  if not(UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpPerFullRepN(N1,N2);
    EKKA_DATECS3530T:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        Result:=(PrintReportByNum(0,PrinterResults,0,PAnsiChar(Passw[15]),N1,N2)=0)and(FLastError='');
      end;
    EKKA_EXELLIO:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        FP.PrintRepByNum('0000',N1,N1);
        Result:=CheckErrorExellio;
      end;
    EKKA_FP2000:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        FP.PeriodicReportN(N1,N2);
        Result:=CheckErrorExellio;
      end;
    EKKA_N707:
      begin
        ErrCode:='';
        ErrDescr:='';
        Result:=ReConnect;
        if not Result then Exit;

        EKKA.FLastError:='';
        if PrintFMReport(IPAddr,ErrCode,ErrDescr,PRINTFMREPORT_FULL_BY_Z,0,0,N1,N2) then
        begin
          Result:=true;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescr);
        end
        else
        begin
          Result:=false;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescr);
        end;
      end;
    EKKA_E810T: begin //fpPerFullRepN
                  FLastError:='';
                  try
                    //Result:=ReConnect;
                    if FIsConnected then
                    begin
                      Result:=ics.FPMakePeriodicReportOnNumber(P_REPORTS,N1,N2);
                      if not Result then
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                    end
                    else
                      raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                end; //fpPerFullRepN
  end;
end;

function TEKKA.fpPerShortRepD(D1,D2:TDateTime):Boolean;
var
  ErrCode,ErrDescr:string;
begin
  if not(UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpPerShortRepD(D1,D2);
    EKKA_DATECS3530T:
      begin
        Result:=ReConnect;
        if not Result then Exit;
      end;
    EKKA_EXELLIO:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        FP.PrintRepByDate('0000',FormatDateTime('ddmmyy',D1),FormatDateTime('ddmmyy',D2));
        Result:=CheckErrorExellio;
      end;
    EKKA_FP2000:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        FP.PeriodicReport(D1,D2);
        Result:=CheckErrorExellio;
      end;
    EKKA_N707:
      begin
        ErrCode:='';
        ErrDescr:='';
        Result:=ReConnect;
        if not Result then Exit;

        EKKA.FLastError:='';
        if PrintFMReport(IPAddr,ErrCode,ErrDescr,PRINTFMREPORT_SHORT_BY_DATE,D1,D2,-1,-1) then
        begin
          Result:=true;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescr);
        end
        else
        begin
          Result:=false;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescr);
        end;
      end;
  end;
end;

function TEKKA.fpPerShortRepN(N1,N2:Integer):Boolean;
var
  ErrCode,ErrDescr:string;
begin
  if not(UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpPerShortRepN(N1,N2);
    EKKA_DATECS3530T:
      begin
        Result:=ReConnect;
        if not Result then Exit;
      end;
    EKKA_EXELLIO:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        FP.PrintRepByNum('0000',N1,N1);
        Result:=CheckErrorExellio;
      end;
    EKKA_FP2000:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        FP.PeriodicReportN(N1,N2);
        Result:=CheckErrorExellio;
      end;
    EKKA_N707:
      begin
        ErrCode:='';
        ErrDescr:='';
        Result:=ReConnect;
        if not Result then Exit;

        EKKA.FLastError:='';
        if PrintFMReport(IPAddr,ErrCode,ErrDescr,PRINTFMREPORT_SHORT_BY_Z,0,0,N1,N2) then
        begin
          Result:=true;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescr);
        end
        else
        begin
          Result:=false;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescr);
        end;
      end;
  end;
end;

function TEKKA.fpCutBeep(C,B,N:Byte):Boolean;
var ErrCode,ErrDescription:string;
 begin
  if (UseEKKA=False) then
  begin
    Result:=True;
    Exit;
  end;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpCutBeep(C,B,N);
    EKKA_DATECS3530T:Result:=True;
    EKKA_EXELLIO:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        Result:=FP.EnableCutCheck(C=1);
        Result:=CheckErrorExellio;
      end;
    EKKA_FP2000:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        Result:=FP.SetPrintSettingAutoCutting(C=1);
        Result:=CheckErrorExellio;
      end;
    EKKA_N707:
      begin//fpCutBeep
        if Sound(1000,1000,ErrCode,ErrDescription,IPAddr) then
        begin
          Result:=false;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescription);
        end
        else
        begin
          Result:=true;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescription);
        end;
      end;
  end;
end;

function TEKKA.fpStrToDisp(S:string):Boolean;
begin
  if not(UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpStrToDisp(S);
    EKKA_DATECS3530T:Result:=True;
    EKKA_E810T: begin //fpStrToDisp
                  FLastError:='';
                  try
                    //Result:=ReConnect;
                    if FIsConnected then
                    begin
                      Result:=ics.FPSetLineCustomerDisplay(1,s);
                      if not Result then
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                    end
                    else
                      raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                end; //fpStrToDisp
  end;
end;

function TEKKA.fpCurrToDisp(S:Currency):Boolean;
begin
  if not(UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpCurrToDisp(S);
    EKKA_DATECS3530T:Result:=True;
    EKKA_E810T: begin //fpCurrToDisp
                  FLastError:='';
                  try
                    //Result:=ReConnect;
                    if FIsConnected then
                    begin
                      Result:=ics.FPSetLineCustomerDisplay(2,CurrToStr(s));
                      if not Result then
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                    end
                    else
                      raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                end; //fpCurrToDisp
  end;
end;

function TEKKA.fpDisplayText(S:string;L:Byte):Boolean;
begin
  if not(UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_EXELLIO:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        if L<=1 then
          FP.DisplayTextLL(Copy(S,1,20))
        else
          FP.DisplayTextUL(Copy(S,1,20));
        Result:=CheckErrorExellio;
      end;
    EKKA_FP2000:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        if L<=1 then
          FP.DisplayPrintLine1(Copy(S,1,20))
        else
          FP.DisplayPrintLine2(Copy(S,1,20));
        Result:=CheckErrorExellio;
      end;
  else
    Result:=true;
  end;
{
  if TypeEKKA=EKKA_EXELLIO then
  begin
    Result:=ReConnect;
    if Not Result then Exit;
    if L<=1 then
      FP.DisplayTextLL(Copy(S,1,20))
    else
      FP.DisplayTextUL(Copy(S,1,20));
    Result:=CheckErrorExellio;
  end
  else
    if TypeEKKA=EKKA_FP2000 then
    begin
      Result:=ReConnect;
      if Not Result then Exit;
      if L<=1 then
        FP.DisplayPrintLine1(Copy(S,1,20))
      else
        FP.DisplayPrintLine2(Copy(S,1,20));
      Result:=CheckErrorExellio;
    end
    else
      Result:=True;
}
end;

procedure TEKKA.SetTypeEKKA(const Value:Byte);
begin
  FTypeEKKA:=Value;
  case TypeEKKA of
    EKKA_MARRY301MTM:FArtFile:=PrPath+'\$Marry301$.txt';
    EKKA_DATECS3530T:FArtFile:=PrPath+'\$Datecs3530T$.txt';
(*
    EKKA_E810T:FArtFile:=PrPath+'$IKCE810T$.txt';
*)
  end;
end;

function TEKKA.fpCashState(P:Integer):Boolean;
{
 ������� P
  0 - ������� �����
  1 - ������� �����
}
var
  ri:TStringList;
  i:Integer;
  A:array[0..7] of Currency;
  Res:Variant;
  CashSum,CreditSum,DebitSum,CheckSum,SumReturnTax1,SumReturnTax2:double;
  GtCshStt,ErrCode,ErrDescription:String;

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
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpCashState(P);
    EKKA_DATECS3530T:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        Result:=(ServiceInputOutput(0,PrinterResults,0,0)=0)and(FLastError='');
        if not Result then Exit;
        try
          ri:=TStringList.Create;
          try
            for i:=Low(A)to High(A) do A[i]:=0;
            if P<>0 then Exit;
            A[1]:=StrToInt64(FRD_Item[1])*0.01;
            A[2]:=StrToInt64(FRD_Item[2])*0.01;
            A[5]:=StrToInt64(FRD_Item[0])*0.01;
            Result:=(DayInfo(0,PrinterResults,0)=0)and(FLastError='');
            if not Result then Exit;
            A[3]:=StrToCurr(FRD_Item[0]);
            A[6]:=StrToCurr(FRD_Item[2])+StrToCurr(FRD_Item[3])+StrToCurr(FRD_Item[1]);
            Result:=(GetCurrentTaxes(0,PrinterResults,0,1)=0)and(FLastError='');
            if not Result then Exit;
            A[4]:=GetSumm;
            ri.Clear;
            for i:=Low(A)to High(A) do ri.Add(IntToStr(Round(A[i]*100)));
            FRD_Item.Text:=ri.Text;
          finally
            ri.Free;
          end;
        except
          Result:=False;
          if FLastError='' then FLastError:='ERP_9995';
        end;
      end;
    EKKA_EXELLIO:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        try
          ri:=TStringList.Create;
          try
            for i:=Low(A)to High(A) do A[i]:=0;
            FP.InOut(0);
            if not CheckErrorExellio then Abort;
            A[0]:=0;
            A[1]:=StrToInt64(FP.s3)*0.01;
            A[2]:=StrToInt64(FP.s4)*0.01;
            A[5]:=StrToInt64(FP.s2)*0.01;
            FP.GetDayInfo;
            if not CheckErrorExellio then Abort;
            A[3]:=StrToInt64(FP.s1)*0.01;
            A[6]:=StrToInt64(FP.s2)*0.01+StrToInt64(FP.s3)*0.01+StrToInt64(FP.s4)*0.01;
            FP.GetCurrentSums(1);
            if not CheckErrorExellio then Abort;
            A[4]:=StrToInt64(FP.s1)*0.01+StrToInt64(FP.s2)*0.01;
            ri.Clear;
            for i:=Low(A)to High(A) do ri.Add(IntToStr(Round(A[i]*100)));
            FRD_Item.Text:=ri.Text;
            FLastError:='';
          finally
            ri.Free;
          end;
        except
          for i:=Low(A)to High(A) do A[i]:=0;
          FRD_Item.Text:=ri.Text;
          Result:=False;
          if FLastError='' then FLastError:='ERP_9995';
        end;
      end;
    EKKA_FP2000:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        try
          ri:=TStringList.Create;
          try
            for i:=Low(A)to High(A) do A[i]:=0;
            Res:=FP.GetCashDeskInfo;
            if not CheckErrorExellio then Abort;
            A[0]:=0;
            A[1]:=Res.InputSum;
            A[2]:=Res.OutputSum;
            A[5]:=Res.CashSum;
            Res:=FP.GetDayPaySumsInfo;
            if not CheckErrorExellio then Abort;
            CashSum:=Res.CashSum;
            CreditSum:=Res.CreditSum;
            DebitSum:=Res.DebitSum;
            CheckSum:=Res.CheckSum;
            A[3]:=CashSum;
            A[6]:=CreditSum+DebitSum+CheckSum;
            Res:=FP.GetDayFiscalSums;
            if not CheckErrorExellio then Abort;
            SumReturnTax1:=Res.SumReturnTax1;
            SumReturnTax2:=Res.SumReturnTax2;
            A[4]:=SumReturnTax1+SumReturnTax2;
            ri.Clear;
            for i:=Low(A)to High(A) do ri.Add(IntToStr(Round(A[i]*100)));
            FRD_Item.Text:=ri.Text;
            FLastError:='';
          finally
            ri.Free;
          end;
        except
          for i:=Low(A)to High(A) do A[i]:=0;
          FRD_Item.Text:=ri.Text;
          Result:=False;
          if FLastError='' then FLastError:='ERP_9995';
        end;
      end;
    EKKA_N707:
      begin//fpCashState
        Result:=ReConnect;
        if not Result then Exit;
        try
          EKKA.FLastError:='';
          FRD_Item.Clear;
          GtCshStt:='';
          Result:=GetCashState(GtCshStt,ErrCode,ErrDescription,IPAddr);
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescription);
          FRD_Item.Text:=GtCshStt;
          FLastError:='';
        except
          Result:=False;
          if FLastError='' then FLastError:=trim(ErrCode+' '+ErrDescription);
        end;
      end;
    EKKA_E810T: begin //fpCashState
                  FLastError:='';
                  try
                    //Result:=ReConnect;
                    if FIsConnected then
                    begin
                      Result:=ics.FPGetDayReportData;
                      if Result then
                      begin
                        FRD_Item.Clear;
                        FRD_Item.Add(IntToStr(0)); //0 ��������� �������
                        FRD_Item.Add(IntToStr(ics.prDayCashInSum)); //1 ��������� ��������
                        FRD_Item.Add(IntToStr(ics.prDayCashOutSum)); //2 ��������� �������
                        FRD_Item.Add(IntToStr(ics.prDaySaleSumOnPayForm4));//3 �������� �� ������� ���.
                        FRD_Item.Add(IntToStr(ics.prDayRefundSumOnPayForm4));//4 ������ ������� ���.
                        FRD_Item.Add(IntToStr(ics.prDayCashInSum-ics.prDayCashOutSum+ics.prDaySaleSumOnPayForm4-ics.prDayRefundSumOnPayForm4));//5 �������� �������
                        FRD_Item.Add(IntToStr(ics.prDaySaleSumOnPayForm1+ics.prDaySaleSumOnPayForm2+ics.prDaySaleSumOnPayForm3));//6 ����������� ������
                        FRD_Item.Add(IntToStr(ics.prDayRefundSumOnPayForm1+ics.prDayRefundSumOnPayForm2+ics.prDayRefundSumOnPayForm3));//7 ����������� �������
                      end
                      else
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                    end
                    else
                      raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                end;
    EKKA_VIRTUAL:begin
                  try
                   Result:=ReConnect;

                   try
                    QrEx.Close;
                    QrEx.SQL.Text:=fJsonChek;
                    QrEx.SQL.SaveToFile('c:\log\JSonCheck1.txt');
                   except
                   end;


                   QrEx.Close;
                   QrEx.SQL.Clear;
                   QrEx.SQL.Add('exec ecr.spY_CashState '+IntToStr(P)+','+IntToStr(KassaID)+','+IntToStr(FTypeChek)+', :check');
                   QrEx.Parameters.ParamByName('check').Value:=fJsonChek;


                   try
                    QrEx.SQL.SaveToFile('c:\log\spY_CashState.txt');
                   except
                   end;


                   QrEx.Open;
                   fRealizDay:=QrEx.FieldByName('RealizDay').AsCurrency;

                   FRD_Item.Clear;

                   for i:=1 to 8 do
                    FRD_Item.Add(QrEx.FieldByName('Sum'+IntToStr(i)).AsString);

                   FRD_Item.Add(QrEx.FieldByName('SumB1').AsString);   // 8
                   FRD_Item.Add(QrEx.FieldByName('SumB3').AsString);   // 9
                   FRD_Item.Add(QrEx.FieldByName('SumB1_').AsString);  //10
                   FRD_Item.Add(QrEx.FieldByName('SumB3_').AsString);  //11
                   FRD_Item.Add(QrEx.FieldByName('CntCheks').AsString);  //12
                   FRD_Item.Add(QrEx.FieldByName('CntCheksB').AsString);  //13

                   FLastError:='';
                   Result:=True;
                  except
                   on E:Exception do
                    begin
                     FLastError:=E.Message;
                     Result:=false;
                    end;
                  end;
                 end;
  end;
  if TypeEKKA<>EKKA_VIRTUAl then // ��������� ���� ����� ������ ������� ��� ��������� �������� ��������� ��� ����������
   begin
    FRD_Item.Add('0');
    FRD_Item.Add('0');
    FRD_Item.Add('0');
    FRD_Item.Add('0');
    FRD_Item.Add('0');
    FRD_Item.Add('0');
   end;
end;

function TEKKA.fpFiscState:Boolean;
var
  A:array[1..20] of Currency;
  j,i:Integer;
  Sum:Currency;
  ri:TStringList;
  Res:Variant;
  SumRealizTax1,SumRealizTax2,SumRealizTax3,SumRealizTax4,SumRealizTax5:double;
  SumReturnTax1,SumReturnTax2,SumReturnTax3,SumReturnTax4,SumReturnTax5:double;

  GtFsclStt,ErrCode,ErrDescription:string;
 begin
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpFiscState;
    EKKA_DATECS3530T:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        try
          ri:=TStringList.Create;
          try
            for i:=Low(A)to High(A) do A[i]:=0;
            Result:=(GetCurrentTaxes(0,PrinterResults,0,0)=0)and(FLastError='');
            if not Result then Exit;
            Sum:=0;
            for j:=0 to 4 do
            begin
              A[2+j]:=StrToInt64(FRD_Item[j])*0.01;
              Sum:=Sum+A[1+j];
            end;
            A[1]:=Sum;
            Result:=(GetCurrentTaxes(0,PrinterResults,0,1)=0)and(FLastError='');
            Sum:=0;
            if not Result then Exit;
            for j:=0 to 4 do
            begin
              A[12+j]:=StrToInt64(FRD_Item[j])*0.01;
              Sum:=Sum+A[1+j];
            end;
            A[11]:=Sum;
            ri.Clear;
            for i:=Low(A)to High(A) do ri.Add(IntToStr(Round(A[i]*100)));
            FRD_Item.Text:=ri.Text;
          finally
            ri.Free;
          end;
        except
          Result:=False;
          if FLastError='' then FLastError:='ERP_9995';
        end;
      end;
    EKKA_EXELLIO:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        try
          ri:=TStringList.Create;
          try
            for i:=Low(A)to High(A) do A[i]:=0;
            FP.GetCurrentSums(0);
            if not CheckErrorExellio then Abort;
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
            if not CheckErrorExellio then Abort;
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
            for i:=Low(A)to High(A) do ri.Add(IntToStr(Round(A[i]*100)));
            FRD_Item.Text:=ri.Text;
            FLastError:='';
                        //ShowMessage(ri.Text);
          finally
            ri.Free;
          end;
        except
          for i:=Low(A)to High(A) do A[i]:=0;
          FRD_Item.Text:=ri.Text;
          Result:=False;
          if FLastError='' then FLastError:='ERP_9995';
        end;
      end;
    EKKA_FP2000:
      begin
        Result:=ReConnect;
        if not Result then Exit;
        try
          ri:=TStringList.Create;
          try
            for i:=Low(A)to High(A) do A[i]:=0;
            Res:=FP.GetDayFiscalSums;
            if not CheckErrorExellio then Abort;
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
            if not CheckErrorExellio then Abort;
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
            for i:=Low(A)to High(A) do ri.Add(IntToStr(Round(A[i]*100)));
            FRD_Item.Text:=ri.Text;
            FLastError:='';
                       //ShowMessage(ri.Text);
          finally
            ri.Free;
          end;
        except
          for i:=Low(A)to High(A) do A[i]:=0;
          FRD_Item.Text:=ri.Text;
          Result:=False;
          if FLastError='' then FLastError:='ERP_9995';
        end;
      end;
    EKKA_N707:
      begin//fpFiscState
        Result:=ReConnect;
        if not Result then Exit;
        try
          EKKA.FLastError:='';
          FRD_Item.Clear;
          GtFsclStt:='';
          if GetFiscalState(GtFsclStt,ErrCode,ErrDescription,IPAddr) then
          begin
            EKKA.FLastError:=trim(ErrCode+' '+ErrDescription);
            Result:=true;
            exit;
          end;
          FRD_Item.Text:=GtFsclStt;
          FLastError:='';
        except
          Result:=False;
          if FLastError='' then FLastError:='ERP_9995';
        end;
      end;
    EKKA_E810T: begin //fpFiscState
                  FLastError:='';
                  try
                    //Result:=ReConnect;
                    if FIsConnected then
                    begin
                      Result:=ics.FPGetDayReportData;
                      if Result then
                      begin
                        FRD_Item.Clear;
                        FRD_Item.Add(IntToStr(0)); //0  - 0
                        FRD_Item.Add(IntToStr(ics.prDaySaleSumOnTax1)); //1  - ������� �� ������ �20%
                        FRD_Item.Add(IntToStr(ics.prDaySaleSumOnTax2)); //2  - ������� �� ������ �7%
                        FRD_Item.Add(IntToStr(ics.prDaySaleSumOnTax3)); //3  - ������� �� ������ �0%
                        FRD_Item.Add(IntToStr(ics.prDaySaleSumOnTax4)); //4  - ������� �� ������ �
                        FRD_Item.Add(IntToStr(ics.prDaySaleSumOnTax5)); //5  - ������� �� ������ �
                        FRD_Item.Add(IntToStr(ics.prDaySaleSumOnTax6)); //6  - ������� �� ������ �
                        FRD_Item.Add(IntToStr(0)); //7  - ������� �� ������ �
                        FRD_Item.Add(IntToStr(0)); //8  - ������� �� ������ �
                        FRD_Item.Add(IntToStr(0)); //9  - 0
                        FRD_Item.Add(IntToStr(0)); //10 - 0
                        FRD_Item.Add(IntToStr(ics.prDayRefundSumOnTax1)); //11 - �������� ����������� �� ������ �20%
                        FRD_Item.Add(IntToStr(ics.prDayRefundSumOnTax2)); //12 - �������� ����������� �� ������ �7%
                        FRD_Item.Add(IntToStr(ics.prDayRefundSumOnTax3)); //13 - �������� ����������� �� ������ �0%
                        FRD_Item.Add(IntToStr(ics.prDayRefundSumOnTax4)); //14 - �������� ����������� �� ������ �
                        FRD_Item.Add(IntToStr(ics.prDayRefundSumOnTax5)); //15 - �������� ����������� �� ������ �
                        FRD_Item.Add(IntToStr(ics.prDayRefundSumOnTax6)); //16 - �������� ����������� �� ������ �
                        FRD_Item.Add(IntToStr(0)); //17 - �������� ����������� �� ������ �
                        FRD_Item.Add(IntToStr(0)); //18 - �������� ����������� �� ������ �
                      end
                      else
                        raise Exception.Create(ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte));
                    end
                    else
                      raise Exception.Create(CAN_NOT_CONNECT_TO_EKKA);
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=false;
                      if FIsConnected then
                        if not ics.FPClose then
                          FLastError:=ics.prGetErrorText+'. ��� ������ '+IntToStr(ics.prGetResultByte)+#13+'������ '+IntToStr(ics.prGetStatusByte)+' �������������� ����� '+IntToStr(ics.prGetReserveByte);
                      FIsConnected:=false;
                    end;
                  end;
                end;
    EKKA_VIRTUAL:begin
                  try
                   Result:=ReConnect;
                   QrEx.Close;
                   QrEx.SQL.Text:='exec ecr.spY_FiscState '+IntToStr(KassaID)+','+IntToStr(FTypeChek);;
                   QrEx.Open;
                   FRD_Item.Clear;

                   for i:=1 to 20 do
                    FRD_Item.Add(QrEx.FieldByName('Sum'+IntToStr(i)).AsString);

                   FLastError:='';
                   Result:=True;
                  except
                   on E:Exception do
                    begin
                     FLastError:=E.Message;
                     Result:=false;
                    end;
                  end;
                 end;
  end;
end;

function TEKKA.fpSendCommand(var Comm:string):Boolean;
begin
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpSendCommand(Comm);
    EKKA_DATECS3530T:Result:=True;
  end;
end;

function TEKKA.fpAddFinStr(S:string):Boolean;
begin
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpAddFinStr(S);
    EKKA_DATECS3530T:Result:=True;
    //EKKA_N707: curr_check.Add('#'+s);
(*
    EKKA_E810T: begin//fpAddFinStr
                  FLastError:='';
                  try
                    if not ics.FPInitialize=0 then
                      raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    if not ics.FPOpen(IntToStr(PortNum)) then
                      raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    if (ics.prPrinterError)or(ics.prTapeNearEnd)or(ics.prTapeEnded) then
                      raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    if not ics.ModemInitialize(IntToStr(PortNum))=0 then
                      raise Exception.Create('������ ������ '+ics.ModedErrorCode+': '+ics.ModemErrorText);

                    try
                      Result:=ics.FPCommentLine(S,false);
                      if not Result then
                        raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    finally
                      if not ics.FPClose then
                        raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    end;
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      if not ics.FPClose then
                        FLastError:=ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte;
                    end;
                  end;
                end;//fpAddFinStr
*)
  end;
end;

function TEKKA.fpSetBottomStr(S:string):Boolean;
begin
  if EmulEKKA then
  begin
    Result:=True;
    Exit
  end;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpSetBottomStr(S);
    EKKA_DATECS3530T:Result:=True;
(*
    EKKA_E810T: begin//fpSetBottomStr
                  FLastError:='';
                  try
                    if not ics.FPInitialize=0 then
                      raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    if not ics.FPOpen(IntToStr(PortNum)) then
                      raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    if not ics.FPGetCurrentStatus then
                      raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    if (ics.prPrinterError)or(ics.prTapeNearEnd)or(ics.prTapeEnded) then
                      raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    if not ics.ModemInitialize(IntToStr(PortNum))=0 then
                      raise Exception.Create('������ ������ '+ics.ModedErrorCode+': '+ics.ModemErrorText);
                    if not ics.ModemUpdateStatus then
                      raise Exception.Create('������ ������ '+ics.ModedErrorCode+': '+ics.ModemErrorText);

                    try
                      Result:=ics.FPSetAdvTrailerLine(1,S,false,false);
                      if not Result then
                        raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    finally
                      if not ics.FPClose then
                        raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    end;
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      if not ics.FPClose then
                        FLastError:=ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte;
                    end;
                  end;
                end;//fpSetBottomStr
*)
  end;
end;

function TEKKA.fpSetBottomStrEx(S:string;N,P,W:Byte):Boolean;
var
  wi,hi:boolean;
begin
  if EmulEKKA then
  begin
    Result:=True;
    Exit
  end;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpSetBottomStrEx(S,N,P,W);
    EKKA_DATECS3530T:Result:=True;
(*
    EKKA_E810T: begin//fpSetBottomStr
                  FLastError:='';
                  try
                    if not ics.FPInitialize=0 then
                      raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    if not ics.FPOpen(IntToStr(PortNum)) then
                      raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    if not ics.FPGetCurrentStatus then
                      raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    if (ics.prPrinterError)or(ics.prTapeNearEnd)or(ics.prTapeEnded) then
                      raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    if not ics.ModemInitialize(IntToStr(PortNum))=0 then
                      raise Exception.Create('������ ������ '+ics.ModedErrorCode+': '+ics.ModemErrorText);
                    if not ics.ModemUpdateStatus then
                      raise Exception.Create('������ ������ '+ics.ModedErrorCode+': '+ics.ModemErrorText);
                    case W of
                      0:
                        begin
                          wi:=false;
                          hi:=false;
                        end;
                      1:
                        begin
                          wi:=true;
                          hi:=false;
                        end;
                      2:
                        begin
                          wi:=false;
                          hi:=true;
                        end;
                      3:
                        begin
                          wi:=true;
                          hi:=true;
                        end;
                    end;
                    try
                      Result:=ics.FPSetAdvTrailerLine(N,S,wi,hi);
                      if not Result then
                        raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    finally
                      if not ics.FPClose then
                        raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    end;
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      if not ics.FPClose then
                        FLastError:=ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte;
                    end;
                  end;
                end;//fpSetBottomStr
*)
  end;
end;

function TEKKA.fpSetINSP(FN,ID,PN,Str1,Str2,Str3,Str4:string):Boolean;
begin
  if EmulEKKA then
  begin
    Result:=True;
    Exit
  end;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=inherited fpSetINSP(FN,ID,PN,Str1,Str2,Str3,Str4);
    EKKA_DATECS3530T:Result:=True;
  end;
end;

function TEKKA.fpSoundEx(Hz,Ms:Integer):Boolean;
var
  ErrCode,ErrDescription:string;
begin
  case TypeEKKA of
    EKKA_EXELLIO:FP.SoundEx(Hz,Ms);
    EKKA_FP2000:FP.Sound(Hz,Ms);
    EKKA_N707:
      begin//fpSoundEx
        if Sound(Hz,Ms,ErrCode,ErrDescription,IPAddr) then
        begin
          Result:=false;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescription);
        end
        else
        begin
          Result:=true;
          EKKA.FLastError:=trim(ErrCode+' '+ErrDescription);
        end;
      end;
  end;
end;

function TEKKA.fpCloseNoFCheck:Boolean;
begin
  case TypeEKKA of
    EKKA_EXELLIO:FP.CloseNonfiscalReceipt;
    EKKA_FP2000:FP.CloseNotFiscalCheck;
  end;
end;

function TEKKA.fpGetOperatorInfo(O:Byte):Boolean;
var
  SL:TStringList;
  CheckCount,RealizCount,DiscountCount,MarkupCount,VoidCount:Integer;
  UserName:string;
  RealizSum,DiscountSum,MarkupSum,VoidSum:Real;
  Res:Variant;
begin
{
  if TypeEKKA=EKKA_EXELLIO then
  begin
    FP.GetOperatorInfo(O);
    SaveRegisters;
  end;
}
  case TypeEKKA of
    EKKA_EXELLIO:
      begin
        FP.GetOperatorInfo(O);
        SaveRegisters;
      end;
    EKKA_FP2000:
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
{
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
}
end;

function TEKKA.fpGetCorectSums:Boolean;
var
  TotalTurn,NegTotalSum,NotPaidTotalSum:Real;
  Res:Variant;
  SL:TStringList;
begin
{
  if TypeEKKA=EKKA_EXELLIO then
  begin
    FP.GetCorectSums;
    SaveRegisters;
  end;
}
  case TypeEKKA of
    EKKA_EXELLIO:
      begin
        FP.GetCorectSums;
        SaveRegisters;
      end;
    EKKA_FP2000:
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
{
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
}
end;

function TEKKA.fpGetCheckCopyText:string;
begin
  if EmulEKKA then Exit;
  if (UseEKKA=False)or(TypeEKKA<>EKKA_FP2000) then
  begin
    Result:='';
    Exit;
  end;
  Result:=FP.GetCheckCopyText;
end;

function TEKKA.GetPaperOut:Boolean;
 begin
  if (UseEKKA=False) or (FLastError='') then
  begin
    Result:=False;
    Exit;
  end;
  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=FLastError='HARDPAPER';
    EKKA_DATECS3530T:Result:=FLastError='PAPER_OUT';
    EKKA_EXELLIO:Result:=Pos(AnsiUpperCAse('����������� ������� ��� ����������� �����'),AnsiUpperCAse(FP.LastErrorText))<>0;
    EKKA_FP2000:Result:=Pos(AnsiUpperCAse('����������� ������� ��� ����������� �����'),AnsiUpperCAse(FP.LastErrorDescr))<>0;
    EKKA_VIRTUAL:Result:=False;
  end;
 end;

function TEKKA.GetLinkOut:Boolean;
begin
  if (UseEKKA=False) or (FLastError='') then
   begin
    Result:=False;
    Exit;
   end;

  case TypeEKKA of
    EKKA_MARRY301MTM:Result:=(FLastError='ERP_9993')or(FLastError='ERP_9995')or(FLastError='ERP_9998');
    EKKA_DATECS3530T:Result:=FLastError='TIMEOUT_ERROR';
    EKKA_EXELLIO:Result:=(Pos(AnsiUpperCAse('���������� ������� COM ����'),AnsiUpperCAse(FP.LastErrorText))<>0)or
      (Pos(AnsiUpperCAse('���������� ���������� � ���������� �������������'),AnsiUpperCAse(FP.LastErrorText))<>0);
    EKKA_FP2000:Result:=(Pos(AnsiUpperCAse('���������� ������� COM ����'),AnsiUpperCAse(FP.LastErrorDescr))<>0)or
      (Pos(AnsiUpperCAse('���������� ���������� � ���������� �������������'),AnsiUpperCAse(FP.LastErrorDescr))<>0);
    EKKA_VIRTUAL:Result:=False;

(*
    EKKA_E810T: begin//GetLinkOut
                  FLastError:='';
                  try
                    try
                      if not ics.FPInitialize=0 then
                        raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                      Result:=ics.FPOpen(IntToStr(PortNum));
                      if not Result then
                        raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                      if not ics.FPGetCurrentStatus then
                        raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);

                      if not ics.ModemInitialize(IntToStr(PortNum))=0 then
                        raise Exception.Create('������ ������ '+ics.ModedErrorCode+': '+ics.ModemErrorText);
                      if not ics.ModemUpdateStatus then
                        raise Exception.Create('������ ������ '+ics.ModedErrorCode+': '+ics.ModemErrorText);
                    finally
                      if not ics.FPClose then
                        raise Exception.Create(ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte);
                    end;
                  except
                    on E:Exception do
                    begin
                      FLastError:=E.Message;
                      Result:=false;
                      if not ics.FPClose then
                        FLastError:=ics.prErrorText+'. ��� ������ '+ics.prGetResultByte+#13+'������ '+ics.prGetStatusByte+' �������������� ����� '+ics.prGetReserveByte;
                    end;
                  end;
                end;//GetLinkOut
*)
  end;
end;

procedure TEKKA.bPrintHead(P:Byte=0;ControlStrim:Byte=0);
var
  i:Integer;
  S,sID,sPN,sFN,sZN:string;
begin
  FLastError:='';
  MrFont.IntervalW:=2;
  MrFont.StartPrint;
  if IsFLP=False then
  begin

    if ControlStrim=0 then
    begin
      MrFont.AddStrC(FirmNameUA,0);
      for i:=Low(eStr)to High(eStr) do
        if eStr[i]<>'' then MrFont.AddStrC(eStr[i],0);
    end else MrFont.AddStrC(' ',0);
{   if ControlStrim=1 then
    begin
     MrFont.AddStr(' �� �01140034774        I� '+FsID,0);
     MrFont.AddStr(' �� 2034005616      �� '+FsPN,0);
    end else}
    begin
      MrFont.AddStr(' �� '+FsFN+'        I� '+FsID,0);
      MrFont.AddStr(' �� '+FsZN+'      �� '+FsPN,0);
    end;
  end
  else
  begin
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
var
  S:string;
//  Param: 1 -��� ����������,  2 - ��� �� ����������,  3 - �����,  4 - ��������� ��������, 5 - ���������� ���
begin
  if (Param in [1,2])and((AptekaID=240)or(IsFLP)) then S:='�� �I�������� ���'
  else
    case Param of
      1:S:='�I�������� ���';
      2,4:S:='!  ��  �I��������  !';
      3:S:='';
      5:S:='���������� ���';
    end;
  MrFont.EndPrint(S,FDtChek,Param,FIsCopy,not IsFLP);
end;

procedure TEKKA.GetInfo(NumZ:Integer=0);
begin
  Qr.Close;
  if NumZ=0 then
    Qr.SQL.Text:='exec spY_GetEKKAInfo '+IntToStr(FKassaID)
  else
    Qr.SQL.Text:='exec spY_GetEKKAInfo_ '+IntToStr(FKassaID)+','+IntToStr(NumZ);
  Qr.Open
end;

procedure TEKKA.bPrintRep(Param:Byte;NumZ:Integer=0;ControlStream:Byte=0);
var
  qrS,S:string;
  IsOpen:Boolean;
  DtWriteZ:TDateTime;
  i:Integer;
//  0 - X-�����
//  1 - �-�����
begin
  GetInfo(NumZ);
  bPrintHead(1,ControlStream);
  try
    case Param of
     0:S:='X';
     1:S:='Z';
    end;
    IsOpen:=Qr.FieldByName('IsOpen').AsInteger=1;
    if (Param=1)and(IsOpen=False)and(NumZ=0) then
      MrFont.AddStrC('*  *  * ���i� *  *  *',1);
    MrFont.AddStrC(S+'-��i� � '+AddStr_(Qr.FieldByName('NumZ').AsString,'0',4),1);
    MrFont.AddStrC('�� '+DateToStrSlash(Qr.FieldByName('DtRep').AsDateTime),1);
    FDtChek:=Now;
    if Param=1 then
     begin
      if (IsOpen)and(NumZ=0) then
        DtWriteZ:=FDtChek
      else
        DtWriteZ:=Qr.FieldByName('DtRep').AsDateTime;
      MrFont.AddStr(' ����� �� �� ��������    '+DateTimeToStrSlash(DtWriteZ),0);
     end;
    if NumZ>0 then FDtChek:=DtWriteZ;
    if (IsOpen=True)or(Param=1) then
    begin
      MrFont.AddStr(' ������i� �i�������� ��� '+DateTimeToStrSlash(Qr.FieldByName('DtLastChek').AsDateTime),0);
      MrFont.AddStr(' ��i�� �i������          '+DateTimeToStrSlash(Qr.FieldByName('DtOpenSmena').AsDateTime),0);
    end
    else
      MrFont.AddStrC('��i�� �� �i������',1);
    MrFont.AddStrC('������ ��i�� (���)',0);
    if NumZ>0 then
    begin
      MrFont.AddStr('�� '+FsZN+'    �i� 11/02/14',0);
      MrFont.AddStr('�� '+FsFN+'      �i� 31/10/14',0);
    end
    else
    begin
      MrFont.AddStr('�� '+FsZN+'    �i� 11/02/14',0);
      MrFont.AddStr('�� '+FsFN+'      �i� 31/10/14',0);
    end;
    MrFont.AddStr(' - - - - - - - - - - - - - - - - - - - -',0);
    MrFont.AddStrC('- - ����i���i� - -',1);
    if (IsOpen=False)and(Param=0) then
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
    end
    else
    begin
      MrFont.AddStr('���                 *� 20.00%',0);
      if NumZ>0 then
        MrFont.AddStrC('䳺 � 31/10/14, � �Z 0001',0)
      else
        MrFont.AddStrC('䳺 � 31/10/14, � �Z 0001',0);
      MrFont.AddStr2J('���� �������������',CurrToStrF_(Qr.FieldByName('SumA').AsCurrency),0);
      MrFont.AddStr2J('����� ������� �i� ����',CurrToStrF_(Qr.FieldByName('Sum_nAb').AsCurrency),0);
      MrFont.AddStr2J('����� ������� �� �����',CurrToStrF_(Qr.FieldByName('Sum_nA').AsCurrency),0);

      MrFont.AddStr('                    *� 7.00%',0);
      if NumZ>0 then
        MrFont.AddStrC('䳺 � 31/10/14, � �Z 0001',0)
      else
        MrFont.AddStrC('䳺 � 31/10/14, � �Z 0001',0);
      MrFont.AddStr2J('���� �������������',CurrToStrF_(Qr.FieldByName('SumB').AsCurrency),0);
      MrFont.AddStr2J('����� ������� �i� ����',CurrToStrF_(Qr.FieldByName('Sum_nBb').AsCurrency),0);
      MrFont.AddStr2J('����� ������� �� �����',CurrToStrF_(Qr.FieldByName('Sum_nB').AsCurrency),0);

      MrFont.AddStr('                    *� 0.00%',0);
      if NumZ>0 then
        MrFont.AddStrC('䳺 � 11/05/18, � �Z 0001',0)
      else
        MrFont.AddStrC('䳺 � 11/05/18, � �Z 0001',0);
      MrFont.AddStr2J('���� �������������',CurrToStrF_(Qr.FieldByName('SumV').AsCurrency),0);
      MrFont.AddStr2J('����� ������� �i� ����',CurrToStrF_(Qr.FieldByName('Sum_nVb').AsCurrency),0);
      MrFont.AddStr2J('����� ������� �� �����',CurrToStrF_(Qr.FieldByName('Sum_nV').AsCurrency),0);

      MrFont.AddStrC('- - - - - - - - - -',0);
      MrFont.AddStr2J('������� �� ���������.','0,00',0);
      MrFont.AddStrC('- - - - - - - - - -',0);
      MrFont.AddStr2J('�� � ��''����� ���������.','0,00',0);
      MrFont.AddStrC('- - - - - - - - - -',0);
      MrFont.AddStr2J('��������� ������',CurrToStrF_(Qr.FieldByName('SumA').AsCurrency+Qr.FieldByName('SumB').AsCurrency+Qr.FieldByName('SumV').AsCurrency),0);
      MrFont.AddStrC('- - - - - - - - - -',0);
      MrFont.AddStrC('�������� �i� ��i���� �� ������ ������',0);
      if Qr.FieldByName('Sum4').AsCurrency>0 then
        MrFont.AddStr2J('������',CurrToStrF_(Qr.FieldByName('Sum4').AsCurrency),0);

      if Qr.FieldByName('SumB1').AsCurrency>0 then
        MrFont.AddStr2J('�����������.1',CurrToStrF_(Qr.FieldByName('SumB1').AsCurrency),0);
      if Qr.FieldByName('Sum7').AsCurrency>0 then
        MrFont.AddStr2J('�����������.2',CurrToStrF_(Qr.FieldByName('Sum7').AsCurrency),0);
      if Qr.FieldByName('SumB3').AsCurrency>0 then
        MrFont.AddStr2J('�����������.3',CurrToStrF_(Qr.FieldByName('SumB3').AsCurrency),0);
      MrFont.AddStr2J('������� ����',Qr.FieldByName('CntCheks').AsString,0);

      // ���� ���� �������� �� ����������
      if (Qr.FieldByName('Sum5').AsCurrency>0) or (Qr.FieldByName('Sum8').AsCurrency>0) or (Qr.FieldByName('SumB1_').AsCurrency>0) or  (Qr.FieldByName('SumB3_').AsCurrency>0) then
      begin
        MrFont.AddStr(' - - - - - - - - - - - - - - - - - - - -',0);
        MrFont.AddStrC('- - ���������� - -',1);
        MrFont.AddStr('���                 *� 20.00%',0);
        MrFont.AddStrC('䳺 � 31/10/14, � �Z 0001',0);
        MrFont.AddStr2J('���� �������������',CurrToStrF_(Qr.FieldByName('SumBA').AsCurrency),0);
        MrFont.AddStr2J('����� ������� �i� ����',CurrToStrF_(Qr.FieldByName('Sum_nBAb').AsCurrency),0);
        MrFont.AddStr2J('����� ������� �� �����',CurrToStrF_(Qr.FieldByName('Sum_nBAb').AsCurrency),0);

        MrFont.AddStr('                    *� 7.00%',0);
        MrFont.AddStrC('䳺 � 31/10/14, � �Z 0001',0);
        MrFont.AddStr2J('���� �������������',CurrToStrF_(Qr.FieldByName('SumBB').AsCurrency),0);
        MrFont.AddStr2J('����� ������� �i� ����',CurrToStrF_(Qr.FieldByName('Sum_nBBb_').AsCurrency),0);
        MrFont.AddStr2J('����� ������� �� �����',CurrToStrF_(Qr.FieldByName('Sum_nBB_').AsCurrency),0);

        MrFont.AddStr('                    *� 0.00%',0);
        MrFont.AddStrC('䳺 � 11/05/18, � �Z 0001',0);
        MrFont.AddStrC('䳺 � 11/05/18, � �Z 0001',0);
        MrFont.AddStr2J('���� �������������',CurrToStrF_(Qr.FieldByName('SumBV').AsCurrency),0);
        MrFont.AddStr2J('����� ������� �i� ����',CurrToStrF_(Qr.FieldByName('Sum_nBVb_').AsCurrency),0);
        MrFont.AddStr2J('����� ������� �� �����',CurrToStrF_(Qr.FieldByName('Sum_nBV_').AsCurrency),0);

        MrFont.AddStrC('- - - - - - - - - -',0);
        MrFont.AddStr2J('������� �� ���������.','0,00',0);
        MrFont.AddStrC('- - - - - - - - - -',0);
        MrFont.AddStr2J('�� � ��''����� ���������.','0,00',0);
        MrFont.AddStrC('- - - - - - - - - -',0);
        MrFont.AddStr2J('��������� ������',CurrToStrF_(Qr.FieldByName('SumBA').AsCurrency+Qr.FieldByName('SumBB').AsCurrency+Qr.FieldByName('SumBV').AsCurrency),0);
        MrFont.AddStrC('- - - - - - - - - -',0);
        MrFont.AddStrC('��������� ��i����� �� ������ ������',0);

        if Qr.FieldByName('Sum5').AsCurrency>0 then
          MrFont.AddStr2J('������',CurrToStrF_(Qr.FieldByName('Sum5').AsCurrency),0);

        if Qr.FieldByName('SumB1_').AsCurrency>0 then
          MrFont.AddStr2J('�����������.1',CurrToStrF_(Qr.FieldByName('SumB1_').AsCurrency),0);
        if Qr.FieldByName('Sum8').AsCurrency>0 then
          MrFont.AddStr2J('�����������.2',CurrToStrF_(Qr.FieldByName('Sum8').AsCurrency),0);
        if Qr.FieldByName('SumB3_').AsCurrency>0 then
          MrFont.AddStr2J('�����������.3',CurrToStrF_(Qr.FieldByName('SumB3_').AsCurrency),0);
        MrFont.AddStr2J('������� ����',Qr.FieldByName('CntCheksB').AsString,0);
      end;
      MrFont.AddStrC(' - - - - - - - - - -',1);
    end;
    MrFont.AddStrC('- - - - - - ������� ����� � ��� - - - -',0);
    MrFont.AddStr2J('���������� �������',CurrToStrF_(Qr.FieldByName('Sum1').AsCurrency),0);
    MrFont.AddStr2J('�������� ��������',CurrToStrF_(Qr.FieldByName('Sum2').AsCurrency),0);
    MrFont.AddStr2J('�������� ���������',CurrToStrF_(Qr.FieldByName('Sum3').AsCurrency),0);
    MrFont.AddStr2J('������� �������',CurrToStrF_(Qr.FieldByName('Sum6').AsCurrency),0);
    MrFont.AddStrC('- - - - - - - - - ������� - - - - - - -',0);
    MrFont.AddStr2J('������',CurrToStrF_(Qr.FieldByName('Sum4').AsCurrency-Qr.FieldByName('Sum5').AsCurrency),0);
    MrFont.AddStr2J('�����������',CurrToStrF_(Qr.FieldByName('Sum7').AsCurrency-Qr.FieldByName('Sum8').AsCurrency+Qr.FieldByName('SumB1').AsCurrency-Qr.FieldByName('SumB1_').AsCurrency+Qr.FieldByName('SumB3').AsCurrency-Qr.FieldByName('SumB3_').AsCurrency),0);
    MrFont.AddStrC('- - - - - - - - - - - - - - - - - - - -',0);
    MrFont.AddStr2J('����� ���������� ����',Qr.FieldByName('NLastChek').AsString,0);
    if (Param=1)and(IsOpen=True) then
    begin
      if NumZ=0 then
      begin
        QrEx.Close;
        QrEx.SQL.Clear;
        QrEx.SQL.Add('exec spY_WriteJournZ_ '''+FormatDateTime('yyyy-mm-dd hh:nn:ss',DtWriteZ)+''', ');
        QrEx.SQL.Add('     :vzh, :id_kassa, :numz, :isprint, :Sum1, :Sum2, :Sum3, :Sum4, :Sum5, :Sum6, :Sum7, :Sum8, :SumA, :SumB, :SumBA, :SumBB, :SumV, :SumBV, :SumG, :SumBG');
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

        QrEx.Parameters.ParamByName('SumV').Value:=Qr.FieldByName('SumV').AsCurrency;
        QrEx.Parameters.ParamByName('SumBV').Value:=Qr.FieldByName('SumBV').AsCurrency;
        QrEx.Parameters.ParamByName('SumG').Value:=Qr.FieldByName('SumG').AsCurrency;
        QrEx.Parameters.ParamByName('SumBG').Value:=Qr.FieldByName('SumBG').AsCurrency;

        //        QrEx.SQL.SaveToFile('C:\tttttttttt');
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

function TEKKA.fpCancelServiceReceipt:Boolean;
var s:string;
 begin
  if EmulEKKA then
   begin
    MrFont.AbortPrint;
    Result:=True;
    Exit;
   end;
  if not(UseEKKA) then
   begin
    Result:=True;
    Exit;
   end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:
      begin
       Result:=inherited fpCancelServiceReceipt;
        {try
          s:='CANC';
          fpSendCommand(s);
          Result:=true;
        except
          on E:Exception do
          begin
            bPrintFooter(2);
            FLastError:='������ �������� ����: '+E.Message;
            Result:=False;
            Exit;
          end;
        end;
       }
      end;
    EKKA_DATECS3530T:
      begin
(*
                        Result:=ReConnect;
                        if Not Result then Exit;
                        Result:=CancelFiscalReceipt;
*)
      end;
    EKKA_EXELLIO:
      begin
(*
                    Result:=ReConnect;
                    if Not Result then Exit;
                    FP.GetFiscalClosureStatus(False);
                    if FP.s1=1 then FP.CancelReceipt;
                    Result:=CheckErrorExellio;
*)
      end;
    EKKA_FP2000:
      begin
(*
                   Result:=ReConnect;
                   if Not Result then Exit;
                   Res:=FP.GetFiscalTransactionStatus;
                   if Res.IsOpenCheck then FP.CancelCheck;
                   Result:=CheckErrorExellio;
*)
      end;
    EKKA_N707:
      begin//fpCancelServiceReceipt
(*
                 curr_check.Clear;
*)
      end;
  end;
end;

function TEKKA.fpClearServiceText:Boolean;
var
  s:string;
begin
  if EmulEKKA then
   begin
    Result:=True;
    Exit;
   end;
  if not(UseEKKA) then
   begin
    Result:=True;
    Exit;
   end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM:
      begin
       Result:=inherited fpClearServiceText;
      {  try
          s:='CTXT'+
            'DBEG';
          fpSendCommand(s);
          Result:=true;
        except
          on E:Exception do
          begin
            bPrintFooter(2);
            FLastError:='������ �������� ����: '+E.Message;
            Result:=False;
            Exit;
          end;
        end;
      }
      end;
    EKKA_DATECS3530T:
      begin
(*
                        Result:=ReConnect;
                        if Not Result then Exit;
                        Result:=fpCancelFiscalReceipt;
                        if Not Result then Exit;
                        Result:=fpOpenFiscalReceipt;
                        if Not Result then Exit;
                        Result:=fpCloseFiscalReceipt(0,4);
*)
      end;
    EKKA_EXELLIO:
      begin
(*
                    Result:=ReConnect;
                    if Not Result then Exit;
                    FP.PrintNullCheck;
                    Result:=CheckErrorExellio;
*)
      end;
    EKKA_FP2000:
      begin
(*
                   Result:=ReConnect;
                   if Not Result then Exit;
                   Result:=fpCancelFiscalReceipt;
                   if Not Result then Exit;
                   Result:=fpOpenFiscalReceipt;
                   if Not Result then Exit;
                   Result:=fpCloseFiscalReceipt(0,4);
*)
      end;
    EKKA_N707:
      begin//fpClearServiceText
(*
                 EKKA.FLastError:='';
                 if PrintZerroCheck(ErrCode,ErrMess,curr_chek,IPAddr) then
                 begin
                   Result:=true;
                   EKKA.FLastError:=trim(ErrCode+' '+ErrMess);
                 end
                 else
                 begin
                   Result:=false;
                   EKKA.FLastError:=trim(ErrCode+' '+ErrMess);
                 end;
*)
      end;
  end;
end;

function TEKKA.fpCloseServiceReceipt:Boolean;
 begin
  if EmulEKKA then
   begin
    try
     FDtChek:=Now();
     bPrintFooter(2);
     Result:=True;
     Exit;
    except
     on E:Exception do
      begin
       FLastError:='������ �������� ���������� ��������� ����: '+E.Message;
       Result:=False;
       Exit;
     end;
    end;
   end;

  Result:=False;
  Case TypeEKKA of
   EKKA_MARRY301MTM:begin
                     Result:=inherited fpCloseServiceReceipt;
                     if LastError<>'' then Check.IsPrinted:=False else Check.IsPrinted:=True;
                    end;
   EKKA_VIRTUAL:begin
                 Result:=PrintServiceCheckVirtualEKKA(QrEx,Check,KassaID);
                end;
  end;
 end;

function TEKKA.fpCloseServiceReceiptIApteka:Boolean;
var
  s,s1,b1:string;
  l:integer;
(*
  PaidCode: Char;
  Sum, SumItog, SumOplat, SumS: Currency;
  i, Ty: Integer;
  Res, Res1: Variant;
  TyB: Char;
  TyB1: Byte;
  ErrorCode, ErrorDescription: string;
  curr_chek: T_cgi_chk_object;
*)
begin
  if EmulEKKA then
  begin
    try
      bPrintHead;
      MrFont.AddStrC('��������� ��������',1);
      MrFont.AddStrC('� '+IntToStr(GetNewServiceNumbChek)+' (����)',1);
      MrFont.AddStrC('������:  '+Kassir,0);
      MrFont.AddStr(' ',0);
      MrFont.AddStr(' '+FirmNameUA,0);
      if length(Bank)>32 then
      begin
        l:=0;
        b1:=Bank;
        while length(Bank)>=l do
        begin
          l:=l+32;
          s:=CopyStrF(b1,l);
          Delete(b1,1,32);
          MrFont.AddStr(' '+s,0);
        end;
      end
      else
        MrFont.AddStr(' '+Bank,0);
      MrFont.AddStr(' ���  - '+MFO,0);
      MrFont.AddStr(' ���� - '+OKPO,0);
      MrFont.AddStr(' �/�  - '+R_R,0);
      MrFont.AddStr(' ��� �  '+IntToStr(NumbChek),0);
      MrFont.AddStr(' ����   '+CurrencyToStr(SumChek),0);
      MrFont.AddStr(' ',0);
      bPrintFooter(4);
    except
      on E:Exception do
      begin
        bPrintFooter(2);
        FLastError:='������ �������� ����: '+E.Message;
        Result:=False;
        Exit;
      end;
    end;
  end;
  if not(UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:
      begin//Result:=inherited fpCloseServiceReceipt;
        try
          s:='CANC'+
            'CTXT';
          fpSendCommand(s);
          s:='TEXT000������:  '+Kassir;
          fpSendCommand(s);
          s:='TEXT000 ';
          fpSendCommand(s);
          s:='TEXT000'+FirmNameUA;
          fpSendCommand(s);
          s:='';
          if length(Bank)>32 then
          begin
            l:=0;
            b1:=Bank;
            while length(Bank)>=l do
            begin
              l:=l+32;
              s1:=CopyStrF(b1,l);
              Delete(b1,1,32);
              s:=s+'TEXT000'+s1;
              fpSendCommand(s);
            end;
          end
          else
          begin
            s:='TEXT000'+Bank;
            fpSendCommand(s);
          end;
          fpSendCommand(s);
          s:='TEXT000 ���  - '+MFO;
          fpSendCommand(s);
          s:='TEXT000 ���� - '+OKPO;
          fpSendCommand(s);
          s:='TEXT000 �/�  - '+R_R;
          fpSendCommand(s);
          s:='TEXT000 ��� �  '+IntToStr(NumbChek);
          fpSendCommand(s);
          s:='TEXT000 ����   '+CurrencyToStr(SumChek);
          fpSendCommand(s);
          s:='TEXT000 ';
          fpSendCommand(s);
          s:='DBEG';
          fpSendCommand(s);
          s:='PRTX';
          fpSendCommand(s);
          Result:=true;
        except
          on E:Exception do
          begin
            bPrintFooter(2);
            FLastError:='������ �������� ����: '+E.Message;
            Result:=False;
            Exit;
          end;
        end;
      end;
    EKKA_DATECS3530T:
      begin
(*
                      try
                        Result:=ReConnect;
                        if Not Result then Exit;
                        PaidCode:=#0;
                        Case TypeOplat of
                          1: PaidCode:='N';  // ������ � ������
                          2: PaidCode:='D';  // ������ � ������� ��������� �����
                          3: PaidCode:='C';  // ������ �����
                          4: PaidCode:='P'   // ������ ���������
                        else
                          Abort;
                        end;
                        if IsDnepr then
                          TyB:='N'
                        else
                          TyB:='C';
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
                        end
                        else
                          Sum:=SumItog-SumOplat;
                        if (Sum<>0) or ((Sum=0) and (SumItog=0)) then
                        begin
                          if SumB1=0 then
                            Result:=(Total(0,PrinterResults,0,'',PaidCode,Sum)=0) and ((FLastError='FISCAL_OPEN') or (FLastError='PRINT_RESTART'))
                          else
                          begin
                            if (SumItog-SumOplat)>SumB1 then
                            begin
                              Result:=(Total(0,PrinterResults,0,'','P',(SumItog-SumOplat)-SumB1)=0) and ((FLastError='FISCAL_OPEN') or (FLastError='PRINT_RESTART'));
                              Result:=(Total(0,PrinterResults,0,'',TyB,SumB1)=0) and ((FLastError='FISCAL_OPEN') or (FLastError='PRINT_RESTART'));
                            end
                            else
                              Result:=(Total(0,PrinterResults,0,'',TyB,SumItog-SumOplat)=0) and ((FLastError='FISCAL_OPEN') or (FLastError='PRINT_RESTART'));
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
*)
      end;
    EKKA_EXELLIO:
      begin
(*
                    Result:=ReConnect;
                    if Not Result then Exit;
                    Case TypeOplat of
                      1: Ty:=2;
                      4: Ty:=1;
                      3: Ty:=3;
                      2: Ty:=4;
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
                                   FP.Total('',Ty,(SumItog-SumOplat)-SumB1);
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
*)
      end;
    EKKA_FP2000:
      begin
(*
                   Result:=ReConnect;
                   if Not Result then Exit;
                   Case TypeOplat of
                     1: Ty:=4;
                     4: Ty:=1;
                     3: Ty:=2;
                     2: Ty:=3;
                   end;
                   if IsDnepr then
                     TyB1:=4
                   else
                     TyB1:=2;
                   try
                     if SumB1=0 then
                     begin
                       Res1:=FP.TotalEx(TakedSumm, Ty);
                       Result:=CheckErrorExellio;
                       if Not Result then raise EAbort.Create('er1');
                     end
                     else
                     begin
                       Res:=FP.GetFiscalTransactionStatus;
                       Result:=CheckErrorExellio;
                       if Not Result then raise EAbort.Create('er2');
                       SumItog:=Res.LastCheckSum;
                       SumOplat:=Res.LastCheckPaySum;
                       if (SumItog-SumOplat)>SumB1 then
                        begin
                         Res:=FP.Total((SumItog-SumOplat)-SumB1, Ty);
                         Result:=CheckErrorExellio;
                         if Not Result then raise EAbort.Create('er3');
                         Res:=FP.Total(SumB1, TyB1);
                         Result:=CheckErrorExellio;
                         if Not Result then raise EAbort.Create('er4');
                        end
                       else
                       begin
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
                       FP.CancelCheck;
                       Result:=False;
                       if FLastError='' then FLastError:='ERP_9991';
                     end;
                   end;
*)
      end;
    EKKA_N707:
      begin//fpCloseServiceReceipt
(*
                 Result:=ReConnect; if Not Result then Exit;
                 Case TypeOplat of
                   1: Ty:=3; //������ � ������
                   2: Ty:=4; //������ � ������� ��������� �����
                   3: Ty:=2; //������ �����
                   4: Ty:=1; //������ ���������
                 end;
                 curr_check.Add('$'+CurrToStr(TakedSumm));
                 if Ty <> 4 then
                 begin
                   //1 - ������ ��������� ��� 2 - ������ ����� ��� 3 - ������ � ������
                   if PrintCheck(curr_check.Text,ErrorCode,ErrorDescription,curr_chek,IPAddr, Ty) then
                   begin
                     Result:=false;
                     EKKA.FLastError:=trim(ErrorCode+' '+ErrorDescription);
                   end
                   else
                   begin
                     Result:=true;
                     EKKA.FLastError:=trim(ErrorCode+' '+ErrorDescription);
                   end;
                 end
                 else
                 begin
                   //4 - ������ � ������� ��������� �����
                   //if PrintCheck(curr_check.Text,ErrorCode,ErrorDescription,curr_chek,IPAddr, Ty, 1, '000000000000000') then
                   if PrintCheck(curr_check.Text,ErrorCode,ErrorDescription,curr_chek,IPAddr, Ty, RRN, BankCard) then
                   begin
                     Result:=false;
                     EKKA.FLastError:=trim(ErrorCode+' '+ErrorDescription);
                   end
                   else
                   begin
                     Result:=true;
                     EKKA.FLastError:=trim(ErrorCode+' '+ErrorDescription);
                   end;
                 end;
*)
      end;
  end;
end;

function TEKKA.fpOpenServiceReceipt:Boolean;
var s:string;
 begin
  if EmulEKKA then
   begin
    try
      if FIsCopy=False then GetInfo;
      SetLength(sArr,0);
      bPrintHead(0);
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
   end;

  if not(UseEKKA) then
   begin
    Result:=True;
    Exit;
   end;
  Result:=False;
  case TypeEKKA of
    EKKA_MARRY301MTM:
      begin
       Result:=inherited fpOpenServiceReceipt;

      {
        try
          s:='CTXT'+
            'DBEG';
          fpSendCommand(s);
          Result:=true;
        except
          on E:Exception do
          begin
            bPrintFooter(2);
            FLastError:='������ �������� ����: '+E.Message;
            Result:=False;
            Exit;
          end;
        end;
      }
      end;
    EKKA_DATECS3530T:
      begin
(*
                        Result:=ReConnect; if Not Result then Exit;
                        Case Param of
                          CH_SALE: Result:=(OpenFiscalReceipt(0,PrinterResults,0,1,PAnsiChar(Passw[1]),KassaID,True)=0) and (FLastError='FISCAL_OPEN');
                          CH_BACK: begin
                                     Result:=(OpenRepaymentReceipt(0,PrinterResults,0,1,PAnsiChar(Passw[1]),KassaID,True)=0) and ((FLastError='FISCAL_OPEN') or (FLastError='PRINT_RESTART'));
                                     if Not Result then Exit;
                                     Result:=(PrintFiscalText(0,PrinterResults,0,PAnsiChar(FNumVoidChek))=0) and ((FLastError='FISCAL_OPEN') or (FLastError='PRINT_RESTART'));
                                   end;
                        end;
*)
      end;
    EKKA_EXELLIO:
      begin
(*
                    Result:=ReConnect; if Not Result then Exit;
                    Case Param of
                      CH_SALE: FP.OpenFiscalReceipt(1,'0000',1);
                      CH_BACK: begin
                                 FP.OpenReturnReceipt(1,'0000',1);
                                 if FP.LastError=0 then FP.PrintFiscalText(FNumVoidChek);
                               end;
                    end;
                    Result:=CheckErrorExellio;
*)
      end;
    EKKA_FP2000:
      begin
(*
                   Result:=ReConnect; if Not Result then Exit;
                   Case Param of
                     CH_SALE: FP.OpenFiscalCheck(True);
                     CH_BACK: begin
                                FP.OpenFiscalCheck(False);
                                if CheckErrorExellio then FP.AddFiscalText(FNumVoidChek);
                              end;
                   end;
                   Result:=CheckErrorExellio;
*)
      end;
    EKKA_N707:
      begin//fpOpenServiceReceipt
(*
                 Result:=ReConnect;
                 if Not Result then Exit;
                 curr_check.Clear;
                 Case Param of
                   CH_SALE: begin
                              curr_check.Add('F');
                              Result:=true;
                            end;
                   CH_BACK: begin
                              curr_check.Add('R');
                              curr_check.Add('"'+FNumVoidChek);
                              Result:=true;
                            end;
                 end;//case Param
*)
      end;
    EKKA_VIRTUAL:begin
                  SetLength(Check.Service,0);
                  Check.TypeChek:=CH_SERVICE;
                 end;
  end;
end;

function TEKKA.fpOpenCashBox:Boolean;
 begin
  if TypeEKKA=EKKA_MARRY301MTM then Result:=inherited fpOpenCashBox else Result:=True;
 end;

initialization

finalization

  if FEKKA<>nil then FEKKA.Free;

end.

   {

    ���� �����:
          �����    ������ FP3530  Exellio LP1000  Exellio FP2000
     1 - ������ 3
     2 - ������ 2
     3 - ������ 1
     4 - ��������

   }


