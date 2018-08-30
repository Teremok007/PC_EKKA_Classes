UNIT EKKAU;

INTERFACE

Uses
  Marry301U, MicroHelpN707, ADODB, Classes, Windows, SysUtils, ComObj, Util,
  Variants, Dialogs, Controls, MarryFont;
//  , DB;

Type
  TArrStr=Array of OleVariant;

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
    FNumVoidChek:String;
    FIsConnected:Boolean;
    FP:Variant;
    N707Status: TStatusN707;
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
    FNLastChek:Integer;
    FBNumb_Chek:Integer;
    FIsCopy:Boolean;
    FCopy_Chek:Integer;
    curr_check:TStringList;  //текущий чек
    FSumNA,FSumNB,FSumNC,FSumSale,FSumVoid,FSumDis:Currency;
    FIsFLP:Boolean;
    FDateChek:TDateTime;
    FIPAddr: string;
    FConnectString: string;

    function ReConnect:Boolean;
    function CancelFiscalReceipt:Boolean;
    function CheckErrorExellio:Boolean;
    function GetPaperOut:Boolean;
    function GetLinkOut:Boolean;
    function GetSumm: Currency;
    procedure SetTypeEKKA(const Value:Byte);
    procedure SaveRegisters;
    procedure bPrintFooter(Param:Byte);
    procedure bPrintHead(P:Byte=0; ControlStrim:Byte=0);
    procedure GetInfo(NumZ:Integer=0);
    function  GetNewServiceNumbChek:Integer;
    function GetServiceShift(ConnectStr: string; var ErrCode, ErrDescription: string):boolean;

  protected

    function GetReceiptNumber:Integer; overload; override;
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

    function ReceiptNumber(Index: integer=0):Integer; overload;
    procedure Gh;
    procedure bPrintRep(Param:Byte; NumZ:Integer=0; ControlStream:Byte=0);
    procedure fpClosePort; override;                                            // Закрыть СОМ порт
    procedure fpSendToEKV;                                                      // Печать квитанции передачи данных
    function  ErrorDescr(Code:String):String; override;                         // Строковое сообщение по коду ошибки
    function  fpCloseNoFCheck:Boolean;
    function  fpGetOperatorInfo(O:Byte):Boolean;
    function  fpGetCorectSums:Boolean;
    function  fpGetCheckCopyText:String;                                        // Элетронная копия чека, пока только для FP2000
    { --- Установка связи с ЕККА --- }
    function  fpLoadExellio: Boolean;
    function  fpConnect:Boolean; override;                                      // Установка связи с ЕККА
    { --- Выполнение произвольной команды --- }
    function  fpSendCommand(var Comm:String):Boolean; override;                 // Выполнение произвольной команды, если были результаты, то они записываються в Comm
    { --- Настройка рабочей среды ---}
    function  fpSetINSP(FN:String; ID:String; PN:String; Str1,Str2,Str3,Str4:String):Boolean; override; // Регистрационная информация владельца.
    function  fpSetTime(T:TDateTime):Boolean; override;                         // Установка времени EKKA
    function  fpActiveLogo(P:Byte):Boolean; override;                           // Активизация печати графического образа (0 не печатать, 1 - печатать)
    { --- Программирование фискальных данных --- }
    function  fpSetBottomStr(S:String):Boolean; override;                       // Программирование необязательной заключительной строки на чеке.
    function  fpSetBottomStrEx(S:String; N,P,W:Byte):Boolean; override;
    { --- Реализация и возврат товаров и услуг --- }
    function  fpOpenFiscalReceipt(Param:Byte=1; NChek:Integer=0; ControlStrim:Byte=0):Boolean; override;              // Открытие нового Чека
    function  fpCancelFiscalReceipt:Boolean; override;                          // Отмена чека
    function  fpAddSale(Name:String;                                // Регистрация продажи одной позиции
                        Kol:Integer;
                        Cena:Currency;
                        Divis:Byte;
                        Artic:Integer;
                        Nalog:Byte;
                        DiscSum:Currency;
                        DiscDescr:String
                       ):Boolean;  override;
    function  fpAddFinStr(S:String):Boolean; override;                          // Дополнительная информация о товаре (услуге)
    function  fpAddBack(Name:String;                                            // Регистрация позиции возврата
                        Kol:Integer;
                        Cena:Currency;
                        Divis:Byte;
                        Artic:Integer;
                        Nalog:Byte;
                        DiscSum:Currency;
                        DiscDescr:String
                       ):Boolean; override;
    function  fpSetBackReceipt(S:String):Boolean; override;                     // Определение номера возвратного чека
    function  fpServiceText(TextPos:Integer;                                    // Регистрация служебной строки в чеке
                            Print2:Integer;
                            FontHeight:Integer;
                            S:String
                           ):Boolean; override;
    function  fpCloseFiscalReceipt(TakedSumm:Currency;                          // Закрытие чека
                                   TypeOplat:Integer;
                                   SumCheck:Currency=0;
                                   SumB1:Currency=0;
                                   IsDnepr:Boolean=False;
                                   ControlStreem:Byte=0
                                  ):Boolean; override;
    function fpCloseFiscalReceiptB(TakedSumm:Currency; TypeOplat:Integer; SumCheck:Currency=0):Boolean;
    function fpCheckCopy(Cnt:Byte=1):Boolean; override;                         // Печать копии чека
    { --- Служебное внесение/изьятие денежных средств --- }
    function  fpCashInput(C:Currency):Boolean; override;                        // Внесение денежных средств
    function  fpCashOutput(C:Currency; P:Byte=0):Boolean; override;             // Изьятие денежных средств
    { --- Фискальные отчеты --- }
    function  fpXRep:Boolean; override;                                         // X-отчет
    function  fpZRep:Boolean; override;                                         // Z-отчет
    function  fpPerFullRepD(D1,D2:TDateTime):Boolean; override;                 // Полный периодический отчет по датам
    function  fpPerShortRepD(D1,D2:TDateTime):Boolean; override;                // Сокращенный периодический отчет по датам
    function  fpPerFullRepN(N1,N2:Integer):Boolean; override;                   // Полный периодический отчет по номерам Z-отчетов
    function  fpPerShortRepN(N1,N2:Integer):Boolean; override;                  // Сокращенный периодический отчет по датам Z-отчетов
    { --- Аналитичесике и служедные отчеты --- }
    function  fpZeroCheck:Boolean; override;                                    // Нулевой чек
    { --- Управление исполнительными устройствами}
    function fpCurrToDisp(S:Currency): Boolean; override;
    function fpStrToDisp(S: String): Boolean; override;
    { --- Получение консолидированной информации о состоянии ЕККА --- }
    function  fpGetStatus:Boolean; override;                                    // Получение внутреннего состояния EKKA
    function  fpCashState(P:Integer):Boolean; override;                         // Запрос информации о движении средств по кассе (0 - по текущей смене, 1 - по прошлой)
    function  fpFiscState:Boolean; override;                                    // Запрос текущего состояния дневных фискальных регистров
    { --- Дополнительные функции ---}
    function  KeyPosition(Key:Byte):Boolean; override;                          // Проверка положение ключа
    function  fpIsNonClosedReceipt:Boolean;
    function  fpSoundEx(Hz,Ms:Integer):Boolean;
    function  fpCutBeep(C,B,N:Byte):Boolean; overload;                          // Управление работой обрезчика чековой ленты и звуковым сигналом
    function  fpDisplayText(S:String; L:Byte):Boolean;

    property  TypeEKKA:Byte read FTypeEKKA write SetTypeEKKA;                   // Тип ЕККА
    property  PaperOut:Boolean read GetPaperOut;                                // Статус регистратора Есть/Нет бумаги
    property  LinkOut:Boolean read GetLinkOut;                                  // Статус регистратора Есть/Нет связи
    property  EmulEKKA:Boolean read FEmulEKKA write FEmulEKKA;                  // Эмуляция печати чеков Мария 301/304
    property  Qr:TADOQuery read FQr write FQr;                                  // Рабочий Query
    property  QrEx:TADOQuery read FQrEx write FQrEx;                            // Рабочий Query №2
    property  Qr1:TADOQuery read FQr1 write FQr1;                               // Рабочий Query №3
    property  AptekaID:Integer read FAptekaID write FAptekaID;
    property  FirmNameUA:String read FFirmNameUA write FFirmNameUA;
    property  sID:String read FsID write FsID;
    property  sPN:String read FsPN write FsPN;
    property  sZN:String read FsZN write FsZN;
    property  sFN:String read FsFN write FsFN;
    property  TypeLogo:Byte read FTypeLogo write FTypeLogo;
    property  IsFLP:Boolean read FIsFLP write FIsFLP;
    property  DateChek:TDateTime read FDateChek write FDateChek;

    property  IPAddr: string read FIPAddr write FIPAddr;
    property  ConnectString: string read FConnectString write FConnectString;
  end;

Const
  { --- Типы EKKA --- }
  EKKA_MARRY301MTM=1; // ЕККА Мария 301МТМ T7
  EKKA_DATECS3530T=2; // EKKA Датекс 3530T
  EKKA_EXELLIO=3;     // EKKA Exellio LP 1000
  EKKA_FP2000=4;      // EKKA Exellio FP 2000
  EKKA_N707=5;        // EKKA MG N707TS (Гера) HTTP
  { --- Положение ключа --- }
  KEY_O=0; // Отключен
  KEY_W=1; // Работа
  KEY_X=2; // X-отчет
  KEY_Z=4; // Z-отчет
  KEY_P=8; // Программирование
  { --- Признаки открытия чеков --- }
  CH_SALE=1; // Продажный чек
  CH_BACK=2; // Возвратный чек

procedure PrinterResults(const rt:RetData)stdcall;
function  GetStatus(hWin:HWND; fun:TMathFunc; par:LPARAM; int1: BOOL):integer; stdcall; external 'fpl.dll' name 'GetStatus';
function  GetDiagnosticInfo(hWin:HWND; fun:TMathFunc; par:LPARAM; Calc: BOOL):integer; stdcall; external 'fpl.dll' name 'GetDiagnosticInfo';
function  GetDateTime(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall; external 'fpl.dll' name 'GetDateTime';
function  GetLastReceipt(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall; external 'fpl.dll' name 'GetLastReceipt';
function  DayInfo(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall; external 'fpl.dll' name 'DayInfo';
function  SetDateTime(hWin:HWND; fun:TMathFunc; par:LPARAM; Date:LPSTR; Time:LPSTR):integer; stdcall; external 'fpl.dll' name 'SetDateTime';
function  OpenFiscalReceipt(hWin:HWND; fun:TMathFunc; par:LPARAM;i1: DWORD;i2: LPSTR;i3: DWORD;i4: BOOL):integer; stdcall; external 'fpl.dll' name 'OpenFiscalReceipt';
function  ResetReceipt(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall; external 'fpl.dll' name 'ResetReceipt';
function  OpenRepaymentReceipt(hWin:HWND; fun:TMathFunc; par:LPARAM;i1: DWORD;i2: LPSTR;i3: DWORD;i4: BOOL):integer; stdcall; external 'fpl.dll' name 'OpenRepaymentReceipt';
function  RegisterItem(hWin:HWND; fun:TMathFunc; par:LPARAM; n:LPSTR; n1: char; n2:double; n3:double):integer; stdcall; external 'fpl.dll' name 'RegisterItem';
function  InitFPport(int1,int2:integer):integer; stdcall; external 'fpl.dll' name 'InitFPport';
function  CloseFPport():integer; stdcall; external 'fpl.dll' name 'CloseFPport';
function  PrintDiagnosticInfo(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall; external 'fpl.dll' name 'PrintDiagnosticInfo';
function  SetDecimals(int1:integer):integer; stdcall; external 'fpl.dll' name 'SetDecimals';
function  SubTotal(hWin:HWND; fun:TMathFunc; par:LPARAM; n1:BOOL;n2:BOOL; n3:double; n4:double):integer; stdcall; external 'fpl.dll' name 'SubTotal';
function  Total(hWin:HWND; fun:TMathFunc; par:LPARAM; n1:LPSTR;n2:char; n3:double):integer; stdcall; external 'fpl.dll' name 'Total';
function  CloseFiscalReceipt(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall; external 'fpl.dll' name 'CloseFiscalReceipt';
function  FiscalClosure(hWin:HWND; fun:TMathFunc; par: LPARAM;n:LPSTR;s:char):integer; stdcall; external 'fpl.dll' name 'FiscalClosure';
function  ServiceInputOutput(hWin:HWND; fun:TMathFunc; par:LPARAM ; sum:Double) :integer; stdcall; external 'fpl.dll' name 'ServiceInputOutput';
function  PrintFiscalMemoryByNum(hWin:HWND; fun:TMathFunc; par: LPARAM; psw:LPSTR; n1:integer; n2:integer):integer; stdcall; external 'fpl.dll' name 'PrintFiscalMemoryByNum';
function  PrintFiscalMemoryByDate(hWin:HWND; fun:TMathFunc; par: LPARAM; psw:LPSTR; d1:LPSTR; d2:LPSTR):integer; stdcall; external 'fpl.dll' name 'PrintFiscalMemoryByDate';
function  PrintReportByNum(hWin:HWND; fun:TMathFunc; par: LPARAM; psw:LPSTR; n1:integer; n2:integer):integer; stdcall; external 'fpl.dll' name 'PrintReportByNum';
function  PrintReportByDate(hWin:HWND; fun:TMathFunc; par: LPARAM; psw:LPSTR; d1:LPSTR; d2:LPSTR):integer; stdcall; external 'fpl.dll' name 'PrintReportByDate';
function  OpenDrawer(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall; external 'fpl.dll' name 'OpenDrawer';
function  PrintFiscalText(hWin:HWND; fun:TMathFunc; par:LPARAM; int1: LPSTR):integer; stdcall; external 'fpl.dll' name 'PrintFiscalText';
function  SaleArticle(hWin:HWND; fun:TMathFunc; par:LPARAM; sign: Boolean;  numart:integer; qwant,perc,dc:double ):integer; stdcall; external 'fpl.dll' name 'SaleArticle';
function  SaleArticleAndDisplay(hWin:HWND; fun:TMathFunc; par:LPARAM; sign: Boolean;  numart:integer; qwant,perc,dc:double ):integer; stdcall; external 'fpl.dll' name 'SaleArticleAndDisplay';
function  ProgrammingArticle(hWin:HWND; fun:TMathFunc; par:LPARAM; nal:char; gr:integer; cod:integer; Sena:double; pass:LPSTR; name:LPSTR):integer; stdcall; external 'fpl.dll' name 'ProgrammingArticle';
function  DeleteArticle(hWin:HWND; fun:TMathFunc; par:LPARAM; cod:integer; pass:LPSTR):integer; stdcall; external 'fpl.dll' name 'DeleteArticle';
function  ChangeArticlePrice(hWin:HWND; fun:TMathFunc; par:LPARAM; cod:integer;sena:Double; pass:LPSTR):integer; stdcall; external 'fpl.dll' name 'ChangeArticlePrice';
function  SetOperatorName(hWin:HWND; fun:TMathFunc; par:LPARAM; i1:DWORD; i2:LPSTR; i3:LPSTR):integer; stdcall; external 'fpl.dll' name 'SetOperatorName';
function  GetFiscalClosureStatus(hWin:HWND; fun:TMathFunc; par:LPARAM; i1:BOOL):integer; stdcall; external 'fpl.dll' name 'GetFiscalClosureStatus';
function  MakeReceiptCopy(hWin:HWND; fun:TMathFunc; par:LPARAM; i1:Char):integer; stdcall; external 'fpl.dll' name 'MakeReceiptCopy';
function  SetHeaderFooter(hWin:HWND; fun:TMathFunc; par:LPARAM; i1:Integer; S:LPSTR):integer; stdcall; external 'fpl.dll' name 'SetHeaderFooter';
function  PrintNonfiscalText(hWin:HWND; fun:TMathFunc; par:LPARAM; int1: LPSTR):integer; stdcall; external 'fpl.dll' name 'PrintNonfiscalText';
function  OperatorsReport(hWin:HWND; fun:TMathFunc; par:LPARAM; ps:LPSTR):integer; stdcall; external 'fpl.dll' name 'OperatorsReport';
function  GetCurrentTaxes(hWin:HWND; fun:TMathFunc; par:LPARAM; int1:Integer):integer; stdcall; external 'fpl.dll' name 'GetCurrentTaxes';
function  DisplayTextLL(hWin:HWND; fun:TMathFunc; par:LPARAM; S:LPSTR):integer; stdcall; external 'fpl.dll' name 'DisplayTextLL';
function  DisplayTextUL(hWin:HWND; fun:TMathFunc; par:LPARAM; S:LPSTR):integer; stdcall; external 'fpl.dll' name 'DisplayTextUL';
Function EKKA:TEKKA;

IMPLEMENTATION

Var
  FEKKA: TEKKA=nil;

{ TEKKA }

Function EKKA:TEKKA;
begin
  if FEKKA=nil then
    FEKKA:=TEKKA.Create(nil);
  Result:=FEKKA;
end;

procedure TEKKA.Gh;
//var Sum:Real;
begin
//  PrintNonfiscalText(0,PrinterResults,0,'Бажаемо вам здоров''я!');
//  fpFiscState;
//  OperatorsReport(0,PrinterResults,0,'0000');
//  fpActiveLogo(0);
//  CloseFiscalReceipt(0,PrinterResults,0);
{  if ProgrammingArticle(0,PrinterResults,0,'Б',100,1,10.01,PAnsiChar(Passw[14]),'Анальгин N10')=0 then
   ShowMessage(FRD_Item[0]);}
end;

function GetNumZ:Integer;
var
  sl: TStringList;
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
  sl: TStringList;
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

function TEKKA.GetSumm: Currency;
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

procedure PrinterResults(const rt: RetData) stdcall;
var
  i: Integer;
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
//                                              if rt.Status and $00400000=$00400000 then EKKA.FLastError:='F_FISCALIZED' else
//                                                if rt.Status and $00004000=$00004000 then EKKA.FLastError:='F_MODULE_NUM' else
//                                                  if rt.Status and $00200000=$00200000 then EKKA.FLastError:='F_FORMATTED' else
//                                                    if rt.Status and $00800000=$00800000 then EKKA.FLastError:='F_SER_NUM' else
end;

constructor TEKKA.Create(AOwner: TComponent);
var
  i:Byte;
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
  for i:=Low(Passw) to High(Passw) do Passw[i]:='0000';
  curr_check:=TStringList.Create();
  FIPAddr:='';
end;

destructor TEKKA.Destroy;
begin
  inherited;
end;

function TEKKA.ErrorDescr(Code: String): String;
begin
  Result:=inherited ErrorDescr(Code);
  if Result=Code then
    if Code='SYNTAX_ERROR'    then Result:='Синтаксическая ошибка' else
      if Code='INVALID_CMD'     then Result:='Неверная команда' else
        if Code='INVALID_TIME'    then Result:='Дата и время неверны' else
          if Code='PRINT_ERROR'     then Result:='Ошибка печати' else
            if Code='SUM_OVERFLOW'    then Result:='Арифметическое переполнение' else
              if Code='CMD_NOT_ALLOWED' then Result:='Команда не разрешена' else
                if Code='RAM_CLEARED'     then Result:='Обнуление ОЗУ' else
                  if Code='PRINT_RESTART'   then Result:='Открыт чек возврата' else
                    if Code='RAM_DESTROYED'   then Result:='Разрушение информации в ОЗУ' else
                      if Code='PAPER_OUT'       then Result:='Отсутствует чековая или/и контрольная лента' else
                        if Code='FISCAL_OPEN'     then Result:='Открыт фискальный чек' else
                          if Code='NONFISCAL_OPEN'  then Result:='Открыт нефискальный чек' else
                            if Code='F_ABSENT'        then Result:='Не обнаружен модуль фиск. памяти' else
                              if Code='F_WRITE_ERROR'   then Result:='Ошибка записи в фиск. память' else
                                if Code='F_FULL'          then Result:='Фиск. память переполнена' else
                                  if Code='F_READ_ONLY'     then Result:='Запись в фиск. память запрещена' else
                                    if Code='F_CLOSE_ERROR'   then Result:='Ошибка последнего Z-отчета' else
                                      if Code='F_LESS_30'       then Result:='В фиск. памяти мало свободного пространства' else
                                        if Code='PROTOCOL_ERROR'  then Result:='Ошибка протокола' else
                                          if Code='NACK_RECEIVED'   then Result:='Принят NACK' else
                                            if Code='TIMEOUT_ERROR'   then Result:='Нет ответа от регистратора' else
                                              if Code='COMMON_ERROR'    then Result:='Общая ошибка' else
                                                if Code='ERROR_COM'       then Result:='Ошибка создания Ole-объекта' else
                                                  if TypeEKKA=EKKA_EXELLIO  then Result:=FP.LastErrorText else
                                                    if TypeEKKA=EKKA_FP2000   then Result:=FP.LastErrorDescr;
end;

procedure TEKKA.fpClosePort;
begin
  if EmulEKKA then Exit;
  if Not (UseEKKA) then Exit;

  FIsConnected:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: inherited;
    EKKA_DATECS3530T: CloseFPport;
    EKKA_EXELLIO: begin
                    FP.ClosePort;
                    FIsConnected:=False;
                  end;
    EKKA_FP2000: begin
                   FP.Disconnect;
                   FIsConnected:=False;
                 end;
    EKKA_N707: FIsConnected:=False;
  end;
end;

function TEKKA.ReConnect: Boolean;
begin
  if (FLastError='TIMEOUT_ERROR') or (FIsConnected=False) then
  begin
    fpClosePort;
    Result:=fpConnect;
  end
  else
    Result:=True;
end;

function TEKKA.fpLoadExellio: Boolean;
var
  Com, Enc: Variant;
begin
  case TypeEKKA of
    EKKA_EXELLIO: try
                    FP:=CreateOleObject('ExellioFP.FiscalPrinter');
                    Result:=True;
                  except
                    FLastError:='ERROR_COM';
                    Result:=False;
                  end;
    EKKA_FP2000: try
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
  SL: TStringList;
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

function TEKKA.CheckErrorExellio: Boolean;
var
  S: String;
  i: Integer;
begin
  case TypeEKKA of
    EKKA_EXELLIO: if FP.LastError<>0 then
                  begin
                    FLastError:=FP.LastError;
                    Result:=False;
                  end
                  else
                  begin
                    FLastError:='';
                    Result:=True;
                  end;
    EKKA_FP2000: if VarArrayHighBound(FP.LastError,1)<>-1 then
                 begin
                   FLastError:=FP.LastErrorDescr; //'ERFP2000';// FP.LastError;
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

function TEKKA.fpConnect: Boolean;
var
  status_N707: TStatusN707;
  Res: Integer;
begin
  if EmulEKKA then
  begin
    FVzhNum:=FKassaID+100100;
    FVzhNumS:=IntToStr(FVzhNum);
    Result:=True;
    Exit;
  end;

  if (Not (UseEKKA)) or (EmulEKKA=True) then
  begin
    Result:=True; Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpConnect;
    EKKA_DATECS3530T: begin
                        try
                          Result:=InitFPport(PortNum,19200)>0;
                          if Not Result then Abort;
                          CancelFiscalReceipt;
                          try
                            FIsConnected:=True;
                            Result:=fpGetStatus;
                          finally
                            FIsConnected:=False;
                          end;

                          if Not Result then Exit;
//                        ShowMessage(FVZhNumS);
                          FVZhNumS:=FRD_Item[0];
                          if Length(FRD_Item[1])<>10 then Abort;
                          FVZhNum:=StrToInt64(FRD_Item[1]);
                          FFN:=StrToInt64(FRD_Item[1]);
//                         Result:=(SetOperatorName(0,PrinterResults,0,1,PAnsiChar(Passw[1]),PAnsiChar(Copy(Kassir,1,24)))=0) and (FLastError='');
                          if Not Result then Abort;
                          FIsConnected:=True;
                        except
                          FIsConnected:=False;
                          if FLastError='' then FLastError:='TIMEOUT_ERROR';
                        end;
                      end;
    EKKA_EXELLIO: begin
                    try
                      FP.OpenPort('COM'+IntToStr(PortNum),115200);
                      Result:=FP.LastError=0;
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
    EKKA_FP2000: begin
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
    EKKA_N707: begin  //fpConnect
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
                 if status_N707.ErrorCode='' then //нет ошибок
                 begin
                   FVzhNum:=StrToInt64(status_N707.dev_fn); //status_N707.dev_id;
                   FVzhNumS:=status_N707.dev_zn;
                   FFn:=StrToInt64(status_N707.dev_fn);
                   FLastError:='';
                 end
                 else  //ошибка
                 begin
                   Res:=-1;
                   FLastError:=trim(status_N707.ErrorCode+' '+status_N707.ErrorDescription);
                 end;
               end;
  end;
end;

function TEKKA.GetServiceShift(ConnectStr: string; var ErrCode, ErrDescription: string):boolean;
var
  rec_id: string;
  sum_out: Currency;
  qrZ_insertion: TADOQuery;
  ADOC: TADOConnection;
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

          if (sum_out > 0)and(EKKA.TypeEKKA=EKKA_N707) then
            EKKA.fpCashInput(sum_out)
          else
            fpZeroCheck;

          Close;
          SQL.Clear;
          SQL.Add('exec spY_Z_insertion 2, '''+FormatDateTime('YYYY-MM-DD HH:MM:SS',now())+''', 0, '+IntToStr(FKassaID)+', '+IntToStr(N707Status.dev_id)+', '''+N707Status.dev_fn+''', 0, '''+FormatDateTime('YYYY-MM-DD HH:MM:SS',now())+''', 1, '''+rec_id+'''');
          ExecSQL;
        end
        else
          ShowMessage('служебное внесение не произведено');
      end;
    finally
      qrZ_insertion.Free;
    end;
  finally
    ADOC.Free;
  end;
end;

function TEKKA.fpGetStatus: Boolean;
var
  ri: TStringList;
  sm, DatePO, Ver, S, ss: String;
  i: Integer;
  chk_number: TChkNomber;//номер фискального чека и возможные ошибки при его получении
  ErrCode, ErrMess: string;
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

  if Not (UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpGetStatus;
    EKKA_DATECS3530T: begin
                        try
                          Result:=ReConnect;
                          if Not Result then Exit;
                          Result:=(GetDiagnosticInfo(0,PrinterResults,0,False)=0) and (FLastError='');
                          if Not Result then Abort;
                          ri:=TStringList.Create;
                          try
                            Ver:=FRD_Item[0];
                            DatePO:=FRD_Item[1];
                            ri.Clear;
                            ri.Add(FRD_Item[6]); // Зав номер (Реально фискальный)
                            ri.Add(FRD_Item[7]); // Фискальный номер
                            ri.Add('');          // Наименование и адрес предприятия (всегда пусто)
                            Result:=(GetDateTime(0,PrinterResults,0)=0) and (FLastError='');
                            if Not Result then Abort;
                            S:=FRD_Item[0];
                            ri.Add('20'+Copy(S,7,2)+Copy(S,4,2)+Copy(S,1,2));
                            S:=FRD_Item[1];
                            if Length(S)>=8 then
                              ri.Add(Copy(S,1,2)+Copy(S,4,2)+Copy(S,7,2))
                            else
                              ri.Add(Copy(S,1,2)+Copy(S,4,2)+'00');
                            ri.Add('1'); // Положение системного ключа (всегда 1)
                            ri.Add('1'); // Признак ожидаемо команды (всегда 1)
                            ri.Add('1'); // Признак зарегистрированного кассира (всегда 1)
                            ri.Add('    ');
                            if Not fpCashState(0) then Abort;
{
                            Result:=(GetCurrentTaxes(0,PrinterResults,0,1)=0) and (FLastError='');
                            if Not Result then Exit;
}
//                            ShowMessage(CurrToStrF((StrToInt(FRD_Item[3])-StrToInt(FRD_Item[4])+StrToInt(FRD_Item[6])-StrToInt(FRD_Item[7]))*0.01,ffFixed,2));
                            if (StrToInt(FRD_Item[3])-StrToInt(FRD_Item[4])+StrToInt(FRD_Item[6])-StrToInt(FRD_Item[7]))*0.01<=0 then sm:='1' else sm:='0';
                            ri.Add('');
                            Result:=(DayInfo(0,PrinterResults,0)=0) and (FLastError='');
                            if Not Result then Abort;
                            if sm='0' then
                              ri.Add(IntToStr(StrToInt(RD_Item[4])+1)) // Номер последнего Z-отчета
                            else
                              ri.Add(RD_Item[4]);
                            Result:=(GetLastReceipt(0,PrinterResults,0)=0) and (FLastError='');
                            if Not Result then Abort;
                            ri.Add(RD_Item[0]); // Номер последнего фискального чека
                            ri.Add('    ');
                            ri.Add(Ver);
                            ri.Add(DatePO);
                            ri.Add('');
                            ri.Add(DatePO);
                            ri.Add('2');
                            ri.Add('грн');
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
    EKKA_EXELLIO: begin
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
                        ri.Add('1'); // Положение системного ключа (всегда 1)
                        ri.Add('1'); // Признак ожидаемо команды (всегда 1)
                        ri.Add('1'); // Признак зарегистрированного кассира (всегда 1)
                        ri.Add('    ');
                        FP.GetSmenLen;
//                        SaveRegisters;
                        if Not CheckErrorExellio then Abort;
                        if FP.s1='Z' then sm:='1' else sm:='0';
//                        ri.Add(Chr(StrToInt(sm)));
                        ri.Add('');
                        FP.LastFiscalClosure(0);
                        if Not CheckErrorExellio then
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
                        if Not CheckErrorExellio then Abort;
                        ri.Add(FP.s1); // Номер последнего фискального чека
                        FP.GetDiagnosticInfo(False);
                        if Not CheckErrorExellio then Abort;
                        ri.Add('    ');
                        ri.Add(FP.s1);
                        ri.Add(FDatePOEx);
                        ri.Add('');
                        ri.Add(FDatePOEx);
                        ri.Add('2');
                        ri.Add('грн');
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
                     Result:=ReConnect;
                     if Not Result then Exit;
                     ri:=TStringList.Create;
                     try
                       ri.Clear;
                       ri.Add(IntToStr(FFn));
                       ri.Add(IntToStr(FFn));
                       ri.Add('');
                       ri.Add(FormatDateTime('yyyymmdd',FP.GetDateTime));
                       ri.Add(FormatDateTime('hhnnss',FP.GetDateTime));
                       if Not CheckErrorExellio then Abort;
                       ri.Add('1'); // Положение системного ключа (всегда 1)
                       ri.Add('1'); // Признак ожидаемо команды (всегда 1)
                       ri.Add('1'); // Признак зарегистрированного кассира (всегда 1)
                       ri.Add('    ');
                       if FP.GetShiftStatus.IsOpen then sm:='0' else sm:='1';
//                       SaveRegisters;
                       if Not CheckErrorExellio then Abort;
                       ri.Add('');
                       ss:=IntToStr(FP.GetLastZReportInfo.ReportNumber);
                       if Not CheckErrorExellio then
                       begin
                         if Pos(AnsiUpperCase('Выполнение команды недопустимо в текущем фискальном режиме работы'),AnsiUpperCase(LastErrorDescr))<>0 then
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
                       ri.Add(FP.GetLastCheckNumber); // Номер последнего фискального чека
                       if Not CheckErrorExellio then Abort;
                       ri.Add('    ');
                       ri.Add(FP.ProgramVersion);
                       ri.Add(FDatePOEx);
                       ri.Add('');
                       ri.Add(FDatePOEx);
                       if Not CheckErrorExellio then Abort;
                       ri.Add('2');
                       ri.Add('грн');
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
    EKKA_N707: begin //fpGetStatus
                 ErrCode:='';
                 ErrMess:='';
                 try
                   EKKA.FLastError:='';
                   N707Status:=GetStatusN707(IPAddr);
                   if N707Status.IsError then    //какая-то ошибка :(
                   begin
                     if N707Status.HTTPCode<>200 then//ошибка связи по http
                       FLastError:=trim(N707Status.ErrorCode+' '+N707Status.ErrorDescription)
                     else
                       if N707Status.ErrorCode<>'' then//ошибка N707
                         FLastError:=trim(N707Status.ErrorCode+' '+N707Status.ErrorDescription)
                       else
                         FLastError:='N707 вернул IsError=true. Кода ошибки нет. '+N707Status.ErrorCode+' '+N707Status.ErrorDescription;
                     Result:=false;
                   end
                   else// нет ошибок
                   begin
                       ri:=TStringList.Create;
                       try
                         ri.Clear;
                         ri.Add(N707Status.dev_zn);   //заводской номер
                         ri.Add(N707Status.dev_fn);   //фискальный номер
                         try
                           EKKA.FFN:=StrToInt64(N707Status.dev_fn);
                         except
                           EKKA.FFN:=0;
                         end;
                         ri.Add('');          // Наименование и адрес предприятия (всегда пусто)
                         ri.Add(FormatDateTime('YYYYMMDD',N707Status.dt));   //Дата
                         ri.Add(FormatDateTime('HHMMSS',N707Status.tm));   //Время
                         ri.Add('1'); // Положение системного ключа (всегда 1)
                         ri.Add('1'); // Признак ожидаемо команды (всегда 1)
                         ri.Add('1'); // Признак зарегистрированного кассира (всегда 1)
                         ri.Add('    ');
                         if N707Status.Used=1 then
                         begin
                           ri.Add('1');  //признак выполнения фискального отчета(Z-отчёта)
                           ri.Add(N707Status.currZ);
                         end
                         else
                         begin
                           ri.Add('0');
                           ri.Add(IntToStr(StrToInt(N707Status.currZ)+1));
                         end;
{
                         if N707Status.Used=1 then
                           ri.Add('1')  //признак выполнения фискального отчета(Z-отчёта)
                         else
                           ri.Add('0');
                         ri.Add(N707Status.currZ);
}
                         chk_number:=GetLastChkNo(IPAddr); // Номер последнего фискального чека
                         if trim(chk_number.ErrCode)='' then   //без ошибок
                           ri.Add(IntToStr(chk_number.ChkNumber))
                         else    //ошибка
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
                         ri.Add('грн');
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
                   if (trim(chk_number.ErrCode)='5')or(chk_number.ChkNumber <= 0) then
                     if MessageDlg('Чековая лента пустая.'+#13+'Сделать служебное внесение и/или распечатать нулевой чек?',mtWarning,[mbYes,mbNo],0)=mrYes then
                       GetServiceShift(FConnectString,ErrCode,ErrMess)
                     else
                       MessageDlg('Печать чеков временно не возможна!'+#13+
                                  ''+#13+
                                  'Для восстановления возможности печати чеков '+#13+
                                  'необходимо открыть чековую ленту.'+#13+
                                  ''+#13+
                                  'Откройте меню "Служебные" => "ОТЧЕТЫ (Z,X, внесение/выдача)..." в главном меню программы'+#13+
                                  'и распечатайте "Нулевой Чек" или сделайте Служебное Внесение.'
                                  ,mtWarning,[mbOK],0);
                 end;
               end;
  end;
end;

function TEKKA.fpSetTime(T: TDateTime): Boolean;
var
  D: String;
  ErrCode, ErrDescr: string;
begin
  if (Not (UseEKKA) or (EmulEKKA=True)) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpSetTime(T);
    EKKA_DATECS3530T: begin
                        Result:=ReConnect;
                        if Not Result then Exit;
                        Result:=(GetDateTime(0,PrinterResults,0)=0) and (FLastError='');
                        if Not Result then Exit;
                        D:=FRD_Item[0];
                        Result:=(SetDateTime(0,PrinterResults,0,PAnsiChar(D),PAnsiChar(FormatDateTime('hh:nn:ss',T)))=0) and (FLastError='');
                      end;
    EKKA_EXELLIO: begin
                    Result:=ReConnect; if Not Result then Exit;
                    FP.SetDateTime(FormatDateTime('dd-mm-yy',T),FormatDateTime('hh:nn',T));
                    Result:=CheckErrorExellio;
                  end;
    EKKA_FP2000: begin
                   Result:=ReConnect;
                   if Not Result then Exit;
                   FP.SetDateTime(T);
                   Result:=CheckErrorExellio;
                 end;
    EKKA_N707: begin //fpSetTime
                 EKKA.FLastError:='';
                 if SetClock(T,ErrCode,ErrDescr,IPAddr) then
                 begin
                   Result:=true;
                   EKKA.FLastError:=trim(ErrCode+' '+ErrDescr);
                 end;
               end;
  end;
end;

function TEKKA.fpXRep: Boolean;
var
  ErrCode, ErrDescr: string;
  chk_err: T_cgi_chk;
begin
  if EmulEKKA then
    try
      bPrintRep(0);
      Result:=True;
      Exit;
    except
      on E:Exception do
      begin
        FLastError:='Ошибка печати X-отчета: '+E.Message;
        Result:=False;
        Exit;
      end;
    end;
  if Not (UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpXRep;
    EKKA_DATECS3530T: begin
                        Result:=ReConnect;
                        if Not Result then Exit;
                        Result:=(FiscalClosure(0,PrinterResults,0,PAnsiChar(Passw[15]),'2')=0) and (FLastError='');
                      end;
    EKKA_EXELLIO: begin
                    Result:=ReConnect;
                    if Not Result then Exit;
                    FP.XReport('0000');
//                    SaveRegisters;
                    Result:=CheckErrorExellio;
                  end;
    EKKA_FP2000: begin
                   Result:=ReConnect;
                   if Not Result then Exit;
                   FP.XReport;
                   Result:=CheckErrorExellio;
                 end;
    EKKA_N707: begin //fpXRep
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
  end;
end;

function TEKKA.fpZRep: Boolean;
var
  B: Boolean;
  Sum: Currency;
  Res: Variant;
  ErrCode, ErrDescr: string;
  chk_err: T_cgi_chk;
begin
  if EmulEKKA then
    try
      bPrintRep(1);
      Result:=True;
      Exit;
    except
      on E:Exception do
      begin
        FLastError:='Ошибка печати Z-отчета: '+E.Message;
        Result:=False;
        Exit;
      end;
    end;

  if Not (UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpZRep;
    EKKA_DATECS3530T: begin
                        Result:=ReConnect;
                        if Not Result then Exit;
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
    EKKA_EXELLIO: begin
                    Result:=ReConnect;
                    if Not Result then Exit;
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
    EKKA_FP2000: begin
                   Result:=ReConnect;
                   if Not Result then Exit;
                   Res:=FP.GetCashDeskInfo;
                   Sum:=Res.CashSum;
                   FP.CashOutput(Sum);
                   FP.ZReport;
                   Result:=CheckErrorExellio;
                   if Not Result then Exit;
                   FP.DeleteArticles;
                   FP.CashInput(Sum);
                 end;
    EKKA_N707: begin //fpZRep
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
  end;
end;

function TEKKA.GetReceiptNumber: Integer;
var
  Res: Integer;
  chk_numb: TChkNomber;
  ErrCode,ErrMess: string;
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
        FLastError:='Ошибка определения номера чека: '+E.Message;
        Result:=-1;
        Exit;
      end;
    end;

  if Not (UseEKKA) then
  begin
    Result:=-1;
    Exit;
  end;
  Result:=-1;
  try
    Case TypeEKKA of
      EKKA_MARRY301MTM: Result:=inherited GetReceiptNumber;
      EKKA_DATECS3530T: try
                          if Not ReConnect then Abort;
                          if GetLastReceipt(0,PrinterResults,0)<>0 then Abort;
                          Result:=StrToInt(FRD_Item[0]);
                        except
                          Result:=-1;
                        end;
      EKKA_EXELLIO: begin
                      if Not ReConnect then Exit;
                      FP.GetLastReceiptNum;
                      if Not CheckErrorExellio then Exit;
                      Result:=FP.s1;
                    end;
      EKKA_FP2000: begin
                     if Not ReConnect then Exit;
                     Res:=FP.GetLastCheckNumber;
                     if Not CheckErrorExellio then Exit;
                     Result:=Res;
                   end;
      EKKA_N707: begin  //GetReceiptNumber
                   if Not ReConnect then Exit;
                   chk_numb:=GetLastChkNo(IPAddr);

                   if trim(chk_numb.ErrCode)='' then //нет ошибок
                   begin
                      Res:=chk_numb.ChkNumber;
                      FLastError:='';
                   end
                   else  //ошибка
                   begin
                     Res:=-1;
                     FLastError:=trim(chk_numb.ErrCode+' '+chk_numb.ErrMessage);
                     if (trim(chk_numb.ErrCode)='5')or(chk_numb.ChkNumber <= 0) then
                       if MessageDlg('Чековая лента пустая.'+#13+'Сделать служебное внесение и/или распечатать нулевой чек?',mtWarning,[mbYes,mbNo],0)=mrYes then
                       begin
                         GetServiceShift(FConnectString, ErrCode,ErrMess);
                         chk_numb:=GetLastChkNo(IPAddr);
                         Res:=chk_numb.ChkNumber;
                       end
                       else
                         MessageDlg('Печать чеков временно не возможна!'+#13+
                                    ''+#13+
                                    'Для восстановления возможности печати чеков '+#13+
                                    'необходимо открыть чековую ленту.'+#13+
                                    ''+#13+
                                    'Откройте меню "Служебные" => "ОТЧЕТЫ (Z,X, внесение/выдача)..." в главном меню программы'+#13+
                                    'и распечатайте "Нулевой Чек" или сделайте Служебное Внесение.'+#13+
                                    '',mtWarning,[mbOK],0);
                   end;
                   Result:=Res;
                 end;
    end;
  finally
    if (Result=-1) and (FLastError='') then FLastError:='ERP_9987';
  end;
end;

function TEKKA.ReceiptNumber(Index: Integer=0): Integer;//overload;
var
  chk_numb: TChkNomber;
  ErrCode,ErrMess: string;
  c_str: string;
begin
  // эта функция перекрывает область видимости свойства ReceiptNumber предка(TMarry301),
  //для того, чтобы можно было передать параметр и определить по нему тип требуемого чека(фискальный, возвратный...)
  //Index=0 - фискальный чек, 1 - возвратный чек
  FLastError:='';
  if Index=0 then //берем номер чека как раньше
  begin
    ReceiptNumber:=GetReceiptNumber;
    exit;
  end
  else
  if Index=1 then    //возвратный чек
  begin
    if TypeEKKA=EKKA_N707 then  //EKKA_N707 берем номер возвратного чека
    begin
      chk_numb:=GetLastChkNo(IPAddr,false);
      if chk_numb.ErrCode='' then
      begin
        ReceiptNumber:=chk_numb.ChkNumber;
        FLastError:='';
      end
      else//ошибка
      begin
        FLastError:='Ошибка определения номера чека: '+chk_numb.ErrCode+' '+chk_numb.ErrMessage;
        Result:=-1;
        if (trim(chk_numb.ErrCode)='5')or(chk_numb.ChkNumber <= 0) then
          if MessageDlg('Чековая лента пустая.'+#13+'Сделать служебное внесение и/или распечатать нулевой чек?',mtWarning,[mbYes,mbNo],0)=mrYes then
          begin
            GetServiceShift(FConnectString,ErrCode,ErrMess);
            chk_numb:=GetLastChkNo(IPAddr);
            Result:=chk_numb.ChkNumber;
          end
          else
            MessageDlg('Печать чеков временно не возможна!'+#13+
                       ''+#13+
                       'Для восстановления возможности печати чеков '+#13+
                       'необходимо открыть чековую ленту.'+#13+
                       ''+#13+
                       'Откройте меню "Служебные" => "ОТЧЕТЫ (Z,X, внесение/выдача)..." в главном меню программы'+#13+
                       'и распечатайте "Нулевой Чек" или сделайте Служебное Внесение.'+#13+
                       '',mtWarning,[mbOK],0);
        Exit;
      end;
    end
    else    //все аппараты кроме EKKA_N707 берем номер чека как раньше
    begin
      ReceiptNumber:=GetReceiptNumber;
      exit;
    end;
  end;
end;

function TEKKA.GetVzhNum: Int64;
var
  Res: Int64;
  status_N707: TStatusN707;
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
      EKKA_MARRY301MTM: Result:=inherited GetVzhNum;
      EKKA_DATECS3530T: try
                          if FVzhNum<=0 then
                            if Not ReConnect then Abort;
                          Result:=FVzhNum;
                        except
                          Result:=0;
                        end;
      EKKA_EXELLIO: try
                      if FVzhNum<=0 then
                      begin
                        if Not ReConnect then Abort;
                        if Not CheckErrorExellio then Exit;
                      end;
                      Result:=FVzhNum;
                    except
                      Result:=0
                    end;
      EKKA_FP2000: try
                     if FVzhNum<=0 then
                     begin
                       if Not ReConnect then Abort;
                       if Not CheckErrorExellio then Exit;
                     end;
                     Result:=FVzhNum;
                   except
                     Result:=0
                   end;
      EKKA_N707: begin //GetVzhNum
                   if Not ReConnect then Exit;
                   status_N707:=GetStatusN707(IPAddr);
                   if status_N707.ErrorCode='' then //нет ошибок
                   begin
                     Res:=status_N707.dev_id;
                     FVzhNum:=status_N707.dev_id;
                     FVzhNumS:=status_N707.dev_zn;
                     FLastError:='';
                   end
                   else  //ошибка
                   begin
                     Res:=-1;
                     FLastError:=trim(status_N707.ErrorCode+' '+status_N707.ErrorDescription);
                   end;
                   Result:=Res;
                 end;
  end;
  finally
    if (Result=0) and (FLastError='') then FLastError:='ERP_9987';
  end;
end;

function TEKKA.KeyPosition(Key:Byte): Boolean;
begin
  if Not (UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited KeyPosition(Key);
    EKKA_DATECS3530T: Result:=True;
    EKKA_EXELLIO: Result:=True;
    EKKA_FP2000: Result:=True;
    EKKA_N707: Result:=true; //KeyPosition
  end;
end;

function TEKKA.fpOpenFiscalReceipt(Param:Byte=1; NChek:Integer=0; ControlStrim:Byte=0):Boolean;
begin
  if EmulEKKA then
    try
      if FIsCopy=False then GetInfo;
      SetLength(sArr,0);
      bPrintHead(0,ControlStrim);
      if FIsCopy then
       begin
        MrFont.AddStrC('*  *  * КОПIЯ *  *  *',1);
        MrFont.AddStrC('чек №  '+IntToStr(FCopy_chek),1);
       end else begin
                 if NChek>0 then FNLastChek:=NChek
                            else FNLastChek:=Qr.FieldByName('NLastChek').AsInteger;

                 MrFont.AddStrC('чек № '+IntToStr(FNLastChek+1),1);
                end;

      if IsFLP=False then
      MrFont.AddStrC('Касир: '+Kassir,0);
      MrFont.AddStrC('Вiдд. 1',0);
      if FBNumb_Chek>-1 then MrFont.AddStr('Пов. по чеку №'+IntToStr(FBNumb_Chek),0);
      FSumNA:=0; FSumNB:=0; FSumNC:=0;
      FSumSale:=0; FSumVoid:=0;
      FSumDis:=0;
      Result:=True;
      Exit;
    except
      on E:Exception do
      begin
        FLastError:='Ошибка открытия чека: '+E.Message;
        Result:=False;
        Exit;
      end;
    end;

  if Not (UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpOpenFiscalReceipt;
    EKKA_DATECS3530T: begin
                        Result:=ReConnect; if Not Result then Exit;
                        Case Param of
                          CH_SALE: Result:=(OpenFiscalReceipt(0,PrinterResults,0,1,PAnsiChar(Passw[1]),KassaID,True)=0) and (FLastError='FISCAL_OPEN');
                          CH_BACK: begin
                                     Result:=(OpenRepaymentReceipt(0,PrinterResults,0,1,PAnsiChar(Passw[1]),KassaID,True)=0) and ((FLastError='FISCAL_OPEN') or (FLastError='PRINT_RESTART'));
                                     if Not Result then Exit;
                                     Result:=(PrintFiscalText(0,PrinterResults,0,PAnsiChar(FNumVoidChek))=0) and ((FLastError='FISCAL_OPEN') or (FLastError='PRINT_RESTART'));
                                   end;
                        end;
                      end;
    EKKA_EXELLIO: begin
                    Result:=ReConnect; if Not Result then Exit;
                    Case Param of
                      CH_SALE: FP.OpenFiscalReceipt(1,'0000',1);
                      CH_BACK: begin
                                 FP.OpenReturnReceipt(1,'0000',1);
                                 if FP.LastError=0 then FP.PrintFiscalText(FNumVoidChek);
                               end;
                    end;
                    Result:=CheckErrorExellio;
                  end;
    EKKA_FP2000: begin
                   Result:=ReConnect; if Not Result then Exit;
                   Case Param of
                     CH_SALE: FP.OpenFiscalCheck(True);
                     CH_BACK: begin
                                FP.OpenFiscalCheck(False);
                                if CheckErrorExellio then FP.AddFiscalText(FNumVoidChek);
                              end;
                   end;
                   Result:=CheckErrorExellio;
                 end;
    EKKA_N707: begin //fpOpenFiscalReceipt
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
               end;//Case TypeEKKA
  end;
end;

function TEKKA.fpIsNonClosedReceipt: Boolean;
var
  Res:Boolean;
begin
  if Not (UseEKKA) then
  begin
    Result:=False;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=False;
    EKKA_DATECS3530T: try
                        if Not ReConnect then Abort;
                        GetFiscalClosureStatus(0,PrinterResults,0,True);
                        if ((FLastError='FISCAL_OPEN') or (FLastError='PRINT_RESTART')) then
                        begin
                          Result:=Not CancelFiscalReceipt;
                        end
                        else
                          Exit;
                        FLastError:='';
                      except
                        Result:=True;
                        FLastError:='ERP_9993';
                      end;
    EKKA_EXELLIO: Result:=False;
    EKKA_FP2000: Result:=False;
    EKKA_N707: Result:=false; //fpIsNonClosedReceipt
  end;
end;

function TEKKA.CancelFiscalReceipt: Boolean;
begin
  try
    Result:=(GetFiscalClosureStatus(0,PrinterResults,0,False)=0) and (FLastError='');
    if Not Result then Abort;
    if StrToInt(FRD_Item[0])=1 then
      Abort
    else
      Result:=True;
  except
    Result:=(ResetReceipt(0,PrinterResults,0)=0) and (FLastError='');
  end;
end;

function TEKKA.fpCancelFiscalReceipt: Boolean;
var
  Res:Variant;
begin
  if EmulEKKA then
  begin
    MrFont.AbortPrint;
    Result:=True;
    Exit;
  end;

  if Not (UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpCancelFiscalReceipt;
    EKKA_DATECS3530T: begin
                        Result:=ReConnect;
                        if Not Result then Exit;
                        Result:=CancelFiscalReceipt;
                      end;
    EKKA_EXELLIO: begin
                    Result:=ReConnect;
                    if Not Result then Exit;
                    FP.GetFiscalClosureStatus(False);
                    if FP.s1=1 then FP.CancelReceipt;
                    Result:=CheckErrorExellio;
                  end;
    EKKA_FP2000: begin
                   Result:=ReConnect;
                   if Not Result then Exit;
                   Res:=FP.GetFiscalTransactionStatus;
                   if Res.IsOpenCheck then FP.CancelCheck;
                   Result:=CheckErrorExellio;
                 end;
    EKKA_N707: curr_check.Clear; //fpCancelFiscalReceipt
  end;
end;

function TEKKA.fpAddSale(Name: String; Kol: Integer; Cena: Currency; Divis: Byte;
  Artic: Integer; Nalog: Byte; DiscSum: Currency; DiscDescr: String): Boolean;
var
  Art, i, j: Integer;
  Sh: Char;
  sNds, S, sArt: String;
  str_length: integer;
  new_str: string;
begin
  if EmulEKKA then
    try
      FLastError:='';
      S:=Name+' '+CurrToStrF_(Cena)+'*'+IntToStr(Kol)+'=';
      Case Nalog of
        1: begin
             sNds:='А';
             FSumNA:=FSumNA+(cena*kol+DiscSum)/6;
           end;
        2: begin
             sNds:='Б';
             FSumNB:=FSumNB+(cena*kol+DiscSum)*(7/107);
           end;
        3: begin
             sNds:='В';
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
        MrFont.AddStr2J('ПДВ - *А20.00%=',CurrToStrF_((cena*kol+DiscSum)/6),0,30);
        MrFont.AddStr2J('Сумма без пдв=',CurrToStrF_((kol*cena+DiscSum)-(cena*kol+DiscSum)/6),0,30);
      end;
}
      While Length(S)>30 do
      begin
        MrFont.AddStr(Copy(S,1,30),0);
        S:=Copy(S,31,Length(S));
      end;
      MrFont.AddStr2J(Copy(S,1,30),CurrToStrF_(Cena*kol)+'-'+sNDS,0);
      if DiscSum<0 then
        MrFont.AddStr2J('Знижка -' ,' -'+CurrToStrF_(Abs(DiscSum))+'  ',0)
      else
        if DiscSum>0 then
          MrFont.AddStr2J('Надбавка -',CurrToStrF_(Abs(DiscSum))+'  ',0);
      Result:=True;
      Exit;
    except
      on E:Exception do
      begin
        FLastError:='Ошибка добавления строки: '+E.Message;
        Result:=False;
        Exit;
      end;
    end;

  if Not (UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpAddSale(Name,Kol,Cena,Divis,Artic,Nalog,DiscSum,DiscDescr);
    EKKA_DATECS3530T: try
                        Result:=ReConnect;
                        if Not Result then Exit;
                        Sh:=#0;
                        Case Nalog of
                          1: Sh:='А';
                          2: Sh:='Б';
                          3: Sh:='В'
                        else
                          Abort;
                        end;
                        for i:=1 to 30 do
                        begin
                          if (Artic=0) or (Artic=99999) then
                            Art:=StrToInt(fpGetNewArt)
                          else
                            Art:=Artic;
                          if (ProgrammingArticle(0,PrinterResults,0,Sh,Art,1,Cena,PAnsiChar(Passw[14]),PAnsiChar(Copy(Name,1,24)+#09+Copy(Name,25,24)))<>0)
                            or ((FLastError<>'FISCAL_OPEN')
                            and (FLastError<>'PRINT_RESTART'))
                          then
                            Abort;
                          if FRD_Item[0]<>'P' then
                          begin
                            if Artic=0 then Abort;
                          end
                          else
                            Break;
                        end;
                        Result:=(SaleArticle(0,PrinterResults,0,True,Art,Kol,0,DiscSum)=0) and ((FLastError='FISCAL_OPEN') or (FLastError='PRINT_RESTART'));
                      except
                        Result:=False;
                        if FLastError='' then FLastError:='ERP_9992';
                      end;
    EKKA_EXELLIO: begin
                    Result:=ReConnect;
                    if Not Result then Exit;
                    sArt:=IntToStrF(Artic,6)+IntToStr(Nalog);
                    FP.GetArticle(sArt);
                    if FP.s1='F' then FP.SetArticle(StrToInt(sArt),Nalog,1,Cena,'0000',Copy(Name,1,36));
                    FP.RegistrItemEx(StrToInt(sArt),Kol,Cena,0,DiscSum);
                    Result:=CheckErrorExellio;
                  end;
    EKKA_FP2000: begin
                   Result:=ReConnect;
                   if Not Result then Exit;
                   sArt:=IntToStrF(Artic,6)+IntToStr(Nalog);
                   if Not FP.GetArticleInfo(StrToInt(sArt)).IsProgram then FP.SetArticleInfo(StrToInt(sArt),Copy(Name,1,36),Nalog,Cena,1);
                   FP.AddFisc(StrToInt(sArt),Kol,Cena,true,DiscSum,0);
                   Result:=CheckErrorExellio;
                 end;
    EKKA_N707: begin  //fpAddSale
                 Result:=ReConnect;
                 if Not Result then Exit;
                 //обработка кавычек в названиях товаров
                 //--------------------------------------------------
                 j:=1;
                 if Length(Name) > 30 then
                   delete(name,31,length(name));
                 str_length:=Length(Name);
                 for i:=1 to str_length do
                 begin
                   if Name[i]='"' then//если кавычка, то удваеваем её
                   begin
                     new_str:=new_str+copy(Name,j,i-j)+'''';
                     j:=i+1;
                   end;

                   if Name[i]='/' then//если слеш, то добавляем обратный слеш
                   begin
                     new_str:=new_str+copy(Name,j,i-j)+'\';
                     j:=i;
                   end;
                 end;
                 new_str:=new_str+copy(Name,j,i-j+1);
                 if Length(new_str) > 30 then
                   delete(new_str,31,length(new_str));
                 if new_str[length(new_str)]='\' then delete(new_str,length(new_str),1);
//                 Nalog 1 - 20%, 2 - 7%
//                 curr_check.Add(IntToStr(kol)+'*'+CurrToStr(cena)+' "'+new_str+'" '+IntToStr(Artic+10)+' '+IntToStr(Nalog)); //correct VAT 20% + 7% incorrect CODE
                 curr_check.Add(IntToStr(kol)+'*'+CurrToStr(cena)+' "'+new_str+'" '+IntToStr(Artic)+' '+IntToStr(Nalog)); //correct VAT 20% + 7%
//                 curr_check.Add(IntToStr(kol)+'*'+CurrToStr(cena)+' "'+new_str+'" '+IntToStr(Artic+15)+' '+IntToStr(Nalog)); //correct VAT 20% + 7%  incorrect CODE
//                 curr_check.Add(IntToStr(kol)+'*'+CurrToStr(cena)+' "'+new_str+'" '+IntToStr(Artic)+' '+IntToStr(1)); //all VAT 20%
//                 скидка/наценка
                 if DiscSum<0 then       //скидка
                   curr_check.Add(CurrToStr(DiscSum))
               end;
  end;
end;

function TEKKA.fpAddBack(Name: String; Kol: Integer; Cena: Currency; Divis: Byte;
  Artic: Integer; Nalog: Byte; DiscSum: Currency; DiscDescr: String): Boolean;
begin
//  if (TypeEKKA=EKKA_EXELLIO) or (TypeEKKA=EKKA_FP2000) then
  if (TypeEKKA=EKKA_EXELLIO) or (TypeEKKA=EKKA_FP2000) or (TypeEKKA=EKKA_N707) then
    Result:=fpAddSale(Name,Kol,Cena,Divis,Artic,Nalog,DiscSum,DiscDescr)
  else
    Result:=fpAddSale(Name,Kol,Cena,Divis,99999,Nalog,DiscSum,DiscDescr);
end;

function TEKKA.fpSetBackReceipt(S: String): Boolean;
var
  ErrorCode, ErrorDescription: string;
  curr_chek: T_cgi_chk_object;
begin
  if EmulEKKA then
  begin
    FBNumb_Chek:=StrToInt(S);
    Result:=True;
    Exit;
  end;
  if Not (UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpSetBackReceipt(S);
    EKKA_DATECS3530T: begin
                        FNumVoidChek:='ПОВ. ПО ЧЕКУ № '+S;
                        Result:=True;
                      end;
    EKKA_EXELLIO: begin
                    FNumVoidChek:='ПОВ. ПО ЧЕКУ № '+S;
                    Result:=True;
                  end;
    EKKA_FP2000: begin
                   FNumVoidChek:='ПОВ. ПО ЧЕКУ № '+S;
                   Result:=True;
                 end;
    EKKA_N707: begin //fpSetBackReceipt
                 FNumVoidChek:='ПОВ. ПО ЧЕКУ № '+S;
                 Result:=True;
                 if ErrorCode<>'' then
                 begin
                   FLastError:=trim(ErrorCode+' '+ErrorDescription);
                   Result:=false;
                 end;
               end;
  end;
end;

function TEKKA.fpCloseFiscalReceiptB(TakedSumm: Currency; TypeOplat: Integer;
  SumCheck: Currency=0): Boolean;
var
  PaidCode: Char;
  Sum, SumItog, SumOplat: Currency;
begin
  if Not (UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpCloseFiscalReceiptB(TakedSumm,TypeOplat,SumCheck);
    EKKA_DATECS3530T: Result:=False;
    EKKA_EXELLIO: Result:=False;
    EKKA_FP2000: Result:=False;
    EKKA_N707: Result:=False; //fpCloseFiscalReceiptB
  end;
end;

function TEKKA.fpCloseFiscalReceipt(TakedSumm: Currency; TypeOplat: Integer;  SumCheck: Currency=0; SumB1: Currency=0; IsDnepr: Boolean=False; ControlStreem:Byte=0):Boolean;
var
  PaidCode: Char;
  Sum, SumItog, SumOplat, SumS: Currency;
  i, Ty: Integer;
  Res, Res1: Variant;
  TyB: Char;
  TyB1: Byte;
  ErrorCode, ErrorDescription: string;
  curr_chek: T_cgi_chk_object;
begin
  if EmulEKKA then
    try
//      MrFont.AddStrC('- - Разом по чеку - -',1);
      if FSumDis<0 then
         MrFont.AddStr2J('Знижка - ','-'+CurrToStrF_(Abs(FSumDis))+'  ',0) else
           if FSumDis>0 then
             MrFont.AddStr2J('Надбавка - ',CurrToStrF_(Abs(FSumDis))+'  ',0);
      MrFont.AddStrC('Сума '+CurrToStrF_(Abs(FSumSale-FSumVoid))+' ГРН',3);
      MrFont.AddStr2J('ПДВ               *А 20.00%',CurrToStrF_(Abs(FSumNA))+'  ',0);
      MrFont.AddStr2J('ПДВ               *Б  7.00%',CurrToStrF_(Abs(FSumNB))+'  ',0);
      MrFont.AddStr2J('ПДВ               *В  0.00%',CurrToStrF_(Abs(FSumNC))+'  ',0);
      MrFont.AddStrC('- - - - - Службова iнформацiя - - - - -',0);
      if High(sArr)>-1 then
        for i:=Low(sArr) to High(sArr) do MrFont.AddStr(sArr[i].S,sArr[i].F);
{
      MrFont.AddStr('Для предложений и комментариев',0);
      MrFont.AddStr('38057-344-0-344',1);
}
//      Kassir:='Шевченко';
      if IsFLP=False then
        MrFont.AddStr('Касир: '+Kassir,0);
      MrFont.AddStrC('- - - - - - - - - - - - - -  - - - - - ',0);
      Case TypeOplat of
        1: MrFont.AddStr2J('Безготiвкова.3',CurrToStrF_(Abs(FSumSale-FSumVoid))+'  ',0);
        3: MrFont.AddStr2J('Безготiвкова.1',CurrToStrF_(Abs(FSumSale-FSumVoid))+'  ',0);
        2: MrFont.AddStr2J('Безготiвкова.2',CurrToStrF_(Abs(FSumSale-FSumVoid))+'  ',0);
        4: begin
             if SumB1=0 then
             begin
               MrFont.AddStr2J('Готiвка ',CurrToStrF_(Abs(FSumSale-FSumVoid))+'  ',0);
               if TakedSumm>SumCheck then
               begin
                 MrFont.AddStr2J('Готiвки',' '+CurrToStrF_(Abs(TakedSumm)),1);
                 MrFont.AddStr2J('Здача',' '+CurrToStrF_(Abs(TakedSumm-SumCheck)),1);
               end;
             end
             else
             begin
{
               MrFont.AddStr2J('Готiвка',' '+CurrToStrF_(37.34),0);
               MrFont.AddStr2J('Безготiвкова.3',' '+CurrToStrF_(287.59),0);
}
               if FBNumb_chek=1 then
               begin
                 if SumB1<FSumSale-FSumVoid then
                 begin
                   SumS:=0;
                   MrFont.AddStr2J('Готiвка',' '+CurrToStrF_(Abs(FSumSale-FSumVoid-SumB1)),0);
                   if TakedSumm>FSumSale-FSumVoid-SumB1 then SumS:=TakedSumm-(FSumSale-FSumVoid-SumB1);
                 end;
                 if IsDnepr then
                   MrFont.AddStr2J('Безготiвкова.3',' '+CurrToStrF_(Abs(SumB1)),0)
                 else
                   MrFont.AddStr2J('Безготiвкова.1',' '+CurrToStrF_(Abs(SumB1)),0);
                 if SumS>0 then
                 begin
                   MrFont.AddStr2J('Готiвки',' '+CurrToStrF_(Abs(TakedSumm)),1);
                   MrFont.AddStr2J('Здача',' '+CurrToStrF_(Abs(SumS)),1);
                 end;
               end
               else
               begin
                 if Abs(FSumSale-FSumVoid)>SumB1 then
                   MrFont.AddStr2J('Готiвка ',CurrToStrF_(Abs(FSumSale-FSumVoid)-SumB1)+'  ',0);
                 if SumB1<FSumVoid then
                 begin
                   MrFont.AddStr2J('Готiвка',' '+CurrToStrF_(Abs(FSumVoid-SumB1)),0);
                   if IsDnepr then
                     MrFont.AddStr2J('Безготiвкова.3',' '+CurrToStrF_(Abs(SumB1)),0)
                   else
                     MrFont.AddStr2J('Безготiвкова.1',' '+CurrToStrF_(Abs(SumB1)),0);
                 end
                 else
                 begin
                   if IsDnepr then
                     MrFont.AddStr2J('Безготiвкова.3',' '+CurrToStrF_(Abs(SumB1-FSumVoid)),0)
                   else
                     MrFont.AddStr2J('Безготiвкова.1',' '+CurrToStrF_(Abs(SumB1-FSumVoid)),0);
                 end
               end
             end;
           end;
      end;
      MrFont.AddStrC('Бажаємо вам здоров''я',1);
      try
       if FIsCopy=False then
       begin
         GetInfo;
         if FDateChek>0 then FDtChek:=FDateChek
                        else FDtChek:=Now;
//         FDtChek:=StrToDateTime('26.10.15 11:06:00');
         if IsFLP=False then MrFont.AddStr('#'+AddStr_(IntToStr(FNLastChek+1),'_',10)+' '+DateTimeToStrSlash(FDtChek)+' ФН:'+FsFN,0);
//        if IsFLP=False then MrFont.AddStr('#'+AddStr_(IntToStr(Qr.FieldByName('NLastChek').AsInteger),'_',10)+' '+DateTimeToStrSlash(FDtChek)+' ФН:'+FsFN,0);
       end
       else
       begin
         if IsFLP=False then
           MrFont.AddStr('#'+AddStr_(IntToStr(FCopy_Chek),'_',10)+' '+DateTimeToStrSlash(FDtChek)+' ФН:'+FsFN,0);
       end;
       if FBNumb_chek=-1 then
         bPrintFooter(1)
       else
         bPrintFooter(5);
       FBNumb_Chek:=-1;
       if (FIsCopy=False) and (ControlStreem=0) then
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
        FLastError:='Ошибка закрытия чека: '+E.Message;
        Result:=False;
        Exit;
      end;
    end;
  if Not (UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
{
    Типы оплат:
          Мария    | Датекс FP3530 | Exellio LP1000 | Exellio FP2000 | N707 | Описание
     1 - Безнал 3  |      N        |       2        |        4       |   3  | Оплата в кредит
     2 - Безнал 2  |      D        |       4        |        3       |   4  | Оплата с помощью платежной карты
     3 - Безнал 1  |      C        |       3        |        2       |   2  | Оплата чеком
     4 - Наличные  |      P        |       1        |        1       |   1  | Оплата Наличными
}
  Case TypeEKKA of                  
    EKKA_MARRY301MTM: Result:=inherited fpCloseFiscalReceipt(TakedSumm,TypeOplat,SumCheck,SumB1,IsDnepr);
    EKKA_DATECS3530T: try
                        Result:=ReConnect;
                        if Not Result then Exit;
                        PaidCode:=#0;
                        Case TypeOplat of
                          1: PaidCode:='N';  // Оплата в кредит
                          2: PaidCode:='D';  // Оплата с помощью платежной карты
                          3: PaidCode:='C';  // Оплата чеком
                          4: PaidCode:='P'   // Оплата Наличными
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
    EKKA_EXELLIO: begin
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
                  end;
    EKKA_FP2000: begin
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
//                       ShowMessage(E.Message);
                       FP.CancelCheck;
                       Result:=False;
                       if FLastError='' then FLastError:='ERP_9991';
                     end;
                   end;
                 end;
    EKKA_N707: begin //fpCloseFiscalReceipt
{
    Типы оплат:
          Мария    | N707 | Описание
     1 - Безнал 3  |   3  | Оплата в кредит
     2 - Безнал 2  |   4  | Оплата с помощью платежной карты
     3 - Безнал 1  |   2  | Оплата чеком
     4 - Наличные  |   1  | Оплата Наличными
}
                 Result:=ReConnect; if Not Result then Exit;
//                 Case TypeOplat of
//                   1: Ty:=3;
//                   4: Ty:=1;
//                   3: Ty:=2;
//                   2: Ty:=4;
//                 end;
                 Case TypeOplat of
                   1: Ty:=3; //Оплата в кредит
                   2: Ty:=4; //Оплата с помощью платежной карты
                   3: Ty:=2; //Оплата чеком
                   4: Ty:=1; //Оплата Наличными
                 end;
                 curr_check.Add('$'+CurrToStr(TakedSumm));
                 if Ty <> 4 then
                 begin
                   //1 - Оплата Наличными или 2 - Оплата чеком или 3 - Оплата в кредит
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
                   //4 - Оплата с помощью платежной карты
                   if PrintCheck(curr_check.Text,ErrorCode,ErrorDescription,curr_chek,IPAddr, Ty, 1, '000000000000000') then
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
  end;
end;

function TEKKA.fpCheckCopy(Cnt: Byte=1): Boolean;
var
  i, Nds, Ty: Integer;
  Art: Integer;
  SumChek: Currency;
  ErrCode, ErrMess: string;//код ошибки и сообщение об ошибке для N707
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
        FLastError:='Ошибка печати копии чека: '+E.Message;
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
  end;
end;

function TEKKA.fpServiceText(TextPos, Print2, FontHeight: Integer;
  S: String): Boolean;
var
  CA, P: Integer;
  i, l_str, new_start: integer;
  new_str: string;
begin
  if EmulEKKA then
    try
//      bPrintHead;
//      MrFont.AddStr(S,FontHeight);
//      bPrintFooter(4);
      CA:=High(sArr)+1;
      SetLength(sArr,CA+1);
      sArr[CA].S:=S;
      sArr[CA].F:=FontHeight;
      Result:=True;
      Exit;
    except
      on E:Exception do
      begin
        FLastError:='Ошибка печати служебной строки: '+E.Message;
        Result:=False;
        Exit;
      end;
    end;
  if Not (UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpServiceText(TextPos,Print2,FontHeight,S);
    EKKA_DATECS3530T: begin
                        Result:=ReConnect;
                        if Not Result then Exit;
                        Result:=(PrintFiscalText(0,PrinterResults,0,PAnsiChar(S))=0) and (FLastError='');
                      end;
    EKKA_EXELLIO: begin
                    Result:=ReConnect;
                    if Not Result then Exit;
                    FP.PrintFiscalText(Copy(S,1,36));
                    Result:=CheckErrorExellio;
                  end;
    EKKA_FP2000: begin
                   Result:=ReConnect;
                   if Not Result then Exit;
                   if S='' then S:=' ';
                   FP.AddFiscalText(Copy(S,1,42));
                   Result:=CheckErrorExellio;
                 end;
    EKKA_N707: begin  //fpServiceText
                 Result:=ReConnect;
                 if Not Result then Exit;
                 //не более 22 символов в строке комментария. Делим строку на части по 22 символа или меньше
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
  end;
end;

function TEKKA.fpCashInput(C: Currency): Boolean;
var
  ErrCode, ErrDescr: string;
  curr_chek: T_cgi_chk_object;
begin
  if EmulEKKA then
    try
      GetInfo;
      bPrintHead;
      MrFont.AddStrC('Службовий документ',1);
      MrFont.AddStrC('№ 12',1);
      MrFont.AddStrC('Кассир:  '+Kassir,0);
      MrFont.AddStrC('Службове внесення',1);
      MrFont.AddStr2J('Готiвкою',CurrToStrF_(C),0);
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
        FLastError:='Ошибка внесення денежных средств: '+E.Message;
        Result:=False;
        Exit;
      end;
    end;
  if Not (UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpCashInput(C);
    EKKA_DATECS3530T: begin
                        Result:=ReConnect;
                        if Not Result then Exit;
                        Result:=(ServiceInputOutput(0,PrinterResults,0,Abs(C))=0) and (FLastError='');
                      end;
    EKKA_EXELLIO: begin
                    Result:=ReConnect;
                    if Not Result then Exit;
                    FP.InOut(Abs(C));
                    Result:=CheckErrorExellio;
                  end;
    EKKA_FP2000: begin
                   Result:=ReConnect;
                   if Not Result then Exit;
                   FP.CashInput(Abs(C));
                   Result:=CheckErrorExellio;
                 end;
    EKKA_N707: begin //fpCashInput
                 EKKA.FLastError:='';
                 if CashInputOutput(abs(C), ErrCode, ErrDescr,curr_chek,IPAddr) then
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
  end;
end;

function TEKKA.fpCashOutput(C: Currency; P: Byte=0): Boolean;
var
  ErrCode, ErrDescr: string;
  curr_chek: T_cgi_chk_object;
begin
  if EmulEKKA then
    try
      GetInfo;
      if C>Qr.FieldByName('Sum6').AsCurrency then raise EAbort.Create('Сумма изъятия превышает сумму остатка денежных средств.');
      bPrintHead;
      MrFont.AddStrC('Службовий документ',1);
      MrFont.AddStrC('№ 12',1);
      MrFont.AddStrC('Кассир:  '+Kassir,0);
      MrFont.AddStrC('Службове вилучення',1);
      MrFont.AddStr2J('Готiвкою',CurrToStrF_(C),0);
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
        FLastError:='Ошибка изъятия денежных средств: '+E.Message;
        RegError(QrEx,'Ошибка изъятия денежных средств',E.Message);
        Result:=False;
        Exit;
      end;
    end;
  if Not (UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpCashOutput(C);
    EKKA_DATECS3530T: begin
                        Result:=ReConnect;
                        if Not Result then Exit;
                        Result:=(ServiceInputOutput(0,PrinterResults,0,-Abs(C))=0) and (FLastError='');
                      end;
    EKKA_EXELLIO: begin
                    Result:=ReConnect;
                    if Not Result then Exit;
                    FP.InOut(-Abs(C));
                    Result:=CheckErrorExellio;
                  end;
    EKKA_FP2000: begin
                   Result:=ReConnect;
                   if Not Result then Exit;
                   FP.CashOutput(Abs(C));
                   Result:=CheckErrorExellio;
                 end;
    EKKA_N707: begin //fpCashOutput
                 EKKA.FLastError:='';
                 if CashInputOutput(-abs(C), ErrCode, ErrDescr,curr_chek, IPAddr) then
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

function TEKKA.fpActiveLogo(P: Byte): Boolean;
var
  B: Boolean;
begin
  if (Not (UseEKKA) or (EmulEKKA=True)) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpActiveLogo(P);
    EKKA_DATECS3530T: begin
                        if Not (P in [0,1]) then
                        begin
                          FLastError:='ERP_9992';
                          Exit;
                        end;
                        Result:=ReConnect;
                        if Not Result then Exit;
                        Result:=(SetHeaderFooter(0,PrinterResults,0,1,PAnsiChar(IntToStr(P)[1]))=0) and (FLastError='');
                        ShowMessage(FLastError);
                      end;
    EKKA_EXELLIO: begin
                    Result:=ReConnect;
                    if Not Result then Exit;
                    if P=0 then
                      B:=False
                    else
                      B:=True;
                    FP.EnableLogo(B);
                    Result:=CheckErrorExellio;
                  end;
    EKKA_FP2000: begin
                   Result:=ReConnect;
                   if Not Result then Exit;
                   if P=0 then
                     B:=False
                   else
                     B:=True;
                   FP.SetPrintSettingPrintLogo(B);
                   Result:=CheckErrorExellio;
                 end;
  end;
 end;

function TEKKA.GetNewServiceNumbChek: Integer;
begin
  Qr.Close;
  Qr.SQL.Text:='spY_GetNewServiceNumbChek '+IntToStr(KassaID);
  Qr.Open;
  Result:=Qr.FieldByName('NCh').AsInteger;
end;

function TEKKA.fpZeroCheck: Boolean;
var
  ErrCode, ErrMess: string;
  curr_chek: T_cgi_chk_object;
begin
  if EmulEKKA then
    try
      bPrintHead;
      MrFont.AddStrC('Службовий документ',1);
      MrFont.AddStrC('№ '+IntToStr(GetNewServiceNumbChek)+' (ЕККР)',1);
      MrFont.AddStrC('Кассир:  '+Kassir,0);
      MrFont.AddStr(' ',0);
      MrFont.AddStrC('Нульовий чек',1);
      MrFont.AddStr(' ',0);
      MrFont.AddStrC('СУМА  0,00',1);
      MrFont.AddStr(' ',0);
      FDtChek:=Now;
      bPrintFooter(4);
      Result:=True;
      Exit;
    except
      on E:Exception do
      begin
        FLastError:='Ошибка печати нулевого чека: '+E.Message;
        Result:=False;
        Exit;
      end;
    end;
  if Not (UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpZeroCheck;
    EKKA_DATECS3530T: begin
                        Result:=ReConnect;
                        if Not Result then Exit;
                        Result:=fpCancelFiscalReceipt;
                        if Not Result then Exit;
                        Result:=fpOpenFiscalReceipt;
                        if Not Result then Exit;
                        Result:=fpCloseFiscalReceipt(0,4);
                      end;
    EKKA_EXELLIO: begin
                    Result:=ReConnect;
                    if Not Result then Exit;
                    FP.PrintNullCheck;
                    Result:=CheckErrorExellio;
                  end;
    EKKA_FP2000: begin
                   Result:=ReConnect;
                   if Not Result then Exit;
                   Result:=fpCancelFiscalReceipt;
                   if Not Result then Exit;
                   Result:=fpOpenFiscalReceipt;
                   if Not Result then Exit;
                   Result:=fpCloseFiscalReceipt(0,4);
                 end;
    EKKA_N707: begin  //fpZeroCheck
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
  end;
end;

procedure TEKKA.fpSendToEKV;
var
  NumPak: Integer;
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
      MrFont.AddStrC('Службовий документ',1);
      MrFont.AddStrC('№ '+IntToStr(GetNewServiceNumbChek)+' (ЕККР)',1);
      MrFont.AddStrC('Кассир:  '+Kassir,0);
      MrFont.AddStrC('Квитанцiя',1);
      MrFont.AddStrC('пiдтвердження',1);
      MrFont.AddStr(' ',0);
      MrFont.AddStrC('пакети данних',1);
      MrFont.AddStr('пакети: '+IntToStrF(NumPak,10)+'-'+IntToStrF(NumPak+9,10),0);
      MrFont.AddStrC('передано еквайєру',1);
      FDtChek:=Now;
      MrFont.AddStr('дата/час: '+DateTimeToStrSlash(FDtChek),0);
      bPrintFooter(4);
      Exit;
    except
      on E:Exception do
      begin
        FLastError:='Ошибка печати квитанции: '+E.Message;
        Exit;
      end;
    end;
end;

function TEKKA.fpPerFullRepD(D1, D2: TDateTime): Boolean;
var
  N1, N2: Integer;
  ErrCode, ErrDescr: string;
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
    EKKA_MARRY301MTM: Result:=inherited fpPerFullRepD(D1,D2);
    EKKA_DATECS3530T: begin
                        Result:=ReConnect;
                        if Not Result then Exit;
                        Result:=(PrintReportByDate(0,PrinterResults,0,PAnsiChar(Passw[15]),PAnsiChar(FormatDateTime('ddmmyy',D1)),PAnsiChar(FormatDateTime('ddmmyy',D2)))=0) and (FLastError='');
                      end;
    EKKA_EXELLIO: begin
                    Result:=ReConnect;
                    if Not Result then Exit;
                    FP.PrintRepByDate('0000',FormatDateTime('ddmmyy',D1),FormatDateTime('ddmmyy',D2));
                    Result:=CheckErrorExellio;
                  end;
    EKKA_FP2000: begin
                   Result:=ReConnect;
                   if Not Result then Exit;
                   FP.PeriodicReport(D1, D2);
                   Result:=CheckErrorExellio;
                 end;
    EKKA_N707: begin
                 ErrCode:='';
                 ErrDescr:='';
                 Result:=ReConnect;
                 if Not Result then Exit;

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
  end;
end;

function TEKKA.fpPerFullRepN(N1, N2: Integer): Boolean;
var
  i, MinNumZ, MaxNumZ: Integer;
  DtWriteZ, MinDateZ, MaxDateZ: TDateTime;
  ErrCode, ErrDescr: String;
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
      MrFont.AddStrC('Перiодичний звiт',1);
      MrFont.AddStrC('Повний',1);
      MrFont.AddStrC('з № '+IntToStrF(MinNumZ,4)+' '+DateToStrSlash(MinDateZ),1);
      MrFont.AddStrC(IntToStrF(MaxNumZ,4)+' '+DateToStrSlash(MaxDateZ),1);
      {****************************************************************************}
      FDtChek:=Now;
      DtWriteZ:=Qr.FieldByName('DtRep').AsDateTime;
      MrFont.AddStr(' запис до ФП занесено    '+DateTimeToStrSlash(DtWriteZ),0);
      MrFont.AddStr(' останнiй фiскальний чек '+DateTimeToStrSlash(Qr.FieldByName('DtLastChek').AsDateTime),0);
      MrFont.AddStr(' змiна вiдкрита          '+DateTimeToStrSlash(Qr.FieldByName('DtOpenSmena').AsDateTime),0);
      MrFont.AddStrC('валюта звiту (грн)',0);
      MrFont.AddStr('ЗН '+FsZN+'    вiд 11/02/14',0);
      MrFont.AddStr('ФН '+FsFN+'      вiд 31/10/14',0);
      MrFont.AddStr(' - - - - - - - - - - - - - - - - - - - -',0);
      MrFont.AddStrC('- - Реалiзацiя - -',1);
      MrFont.AddStr('пдв                 *А 20.00%',0);
      MrFont.AddStrC('діє з 31/10/14, з №Z 0001',0);
      MrFont.AddStr2J('база оподаткування',CurrToStrF_(Qr.FieldByName('SumA').AsCurrency),0);
      MrFont.AddStr2J('сумма податку вiд бази',CurrToStrF_(Qr.FieldByName('Sum_nAb').AsCurrency),0);
      MrFont.AddStr2J('сумма податку по чекам',CurrToStrF_(Qr.FieldByName('Sum_nA').AsCurrency),0);
      MrFont.AddStr('                    *Б 7.00%',0);
      MrFont.AddStrC('діє з 31/10/14, з №Z 0001',0);
      MrFont.AddStr2J('база оподаткування',CurrToStrF_(Qr.FieldByName('SumB').AsCurrency),0);
      MrFont.AddStr2J('сумма податку вiд бази',CurrToStrF_(Qr.FieldByName('Sum_nBb').AsCurrency),0);
      MrFont.AddStr2J('сумма податку по чекам',CurrToStrF_(Qr.FieldByName('Sum_nB').AsCurrency),0);
      MrFont.AddStrC('- - - - - - - - - -',0);
      MrFont.AddStr2J('звільнені від оподаткув.','0,00',0);
      MrFont.AddStrC('- - - - - - - - - -',0);
      MrFont.AddStr2J('не є об''єктом оподаткув.','0,00',0);
      MrFont.AddStrC('- - - - - - - - - -',0);
      MrFont.AddStr2J('загальний оборот',CurrToStrF_(Qr.FieldByName('Sum4').AsCurrency+Qr.FieldByName('Sum7').AsCurrency),0);
      MrFont.AddStrC('- - - - - - - - - -',0);
      MrFont.AddStrC('Одержано вiд клiєнтів по формам оплати',0);
      MrFont.AddStr2J('готівка',CurrToStrF_(Qr.FieldByName('Sum4').AsCurrency),0);
      MrFont.AddStr2J('безготівкова.2',CurrToStrF_(Qr.FieldByName('Sum7').AsCurrency),0);
      MrFont.AddStr2J('кількість чеків',Qr.FieldByName('CntCheks').AsString,0);
      // Если были возвраты от покупателя
      if (Qr.FieldByName('Sum5').AsCurrency>0) or (Qr.FieldByName('Sum5').AsCurrency>0) then
      begin
        MrFont.AddStr(' - - - - - - - - - - - - - - - - - - - -',0);
        MrFont.AddStrC('- - Повернення - -',1);
        MrFont.AddStr('пдв                 *А 20.00%',0);
        MrFont.AddStrC('діє з 31/10/14, з №Z 0001',0);
        MrFont.AddStr2J('база оподаткування',CurrToStrF_(Qr.FieldByName('SumBA').AsCurrency),0);
        MrFont.AddStr2J('сумма податку вiд бази',CurrToStrF_(Qr.FieldByName('Sum_nBAb').AsCurrency),0);
        MrFont.AddStr2J('сумма податку по чекам',CurrToStrF_(Qr.FieldByName('Sum_nBA').AsCurrency),0);
        MrFont.AddStr('                    *Б 7.00%',0);
        MrFont.AddStrC('діє з 31/10/14, з №Z 0001',0);
        MrFont.AddStr2J('база оподаткування',CurrToStrF_(Qr.FieldByName('SumBB').AsCurrency),0);
        MrFont.AddStr2J('сумма податку вiд бази',CurrToStrF_(Qr.FieldByName('Sum_nBBb').AsCurrency),0);
        MrFont.AddStr2J('сумма податку по чекам',CurrToStrF_(Qr.FieldByName('Sum_nBB').AsCurrency),0);
        MrFont.AddStrC('- - - - - - - - - -',0);
        MrFont.AddStr2J('звільнені від оподаткув.','0,00',0);
        MrFont.AddStrC('- - - - - - - - - -',0);
        MrFont.AddStr2J('не є об''єктом оподаткув.','0,00',0);
        MrFont.AddStrC('- - - - - - - - - -',0);
        MrFont.AddStr2J('загальний оборот',CurrToStrF_(Qr.FieldByName('Sum5').AsCurrency+Qr.FieldByName('Sum8').AsCurrency),0);
        MrFont.AddStrC('- - - - - - - - - -',0);
        MrFont.AddStrC('Повернено клiєнтам по формам оплати',0);
        MrFont.AddStr2J('готівка',CurrToStrF_(Qr.FieldByName('Sum5').AsCurrency),0);
        MrFont.AddStr2J('безготівкова.2',CurrToStrF_(Qr.FieldByName('Sum8').AsCurrency),0);
        MrFont.AddStr2J('кількість чеків',Qr.FieldByName('CntCheksB').AsString,0);
      end;
      MrFont.AddStrC(' - - - - - - - - - -',1);
      MrFont.AddStrC('- - - - - - Готівкові кошти в касі - - - -',0);
      MrFont.AddStr2J('початковий залишок',CurrToStrF_(Qr.FieldByName('Sum1').AsCurrency),0);
      MrFont.AddStr2J('кінцевий залишок',  CurrToStrF_(Qr.FieldByName('Sum6').AsCurrency),0);
      MrFont.AddStrC('- - - - - - - - - Виручка - - - - - - -',0);
      MrFont.AddStr2J('готівка',   CurrToStrF_(Qr.FieldByName('Sum4').AsCurrency-Qr.FieldByName('Sum5').AsCurrency),0);
      MrFont.AddStr2J('безготівкова',CurrToStrF_(Qr.FieldByName('Sum7').AsCurrency-Qr.FieldByName('Sum8').AsCurrency),0);
      MrFont.AddStrC('- - - - - - - - - - - - - - - - - - - -',0);
      MrFont.AddStr2J('номер останнього чека',Qr.FieldByName('NLastChek').AsString,0);
      { -------------------------------------------------------------------------- }
      MrFont.AddStrC('- - - - -  Пiдсумки по Z-звiтах  - - - - ',0);
      for i:=1 to Qr1.RecordCount do
      begin
        if i=1 then
          Qr1.First
        else
          Qr1.Next;
        MrFont.AddStr2J(IntToStrF(Qr1.FieldByName('NumZ').AsInteger,4)+' '+DateToStrSlash(Qr1.FieldByName('DateZ').AsDateTime),CurrToStrF_(Qr1.FieldByName('SumZ').AsCurrency),0);
      end;
      MrFont.AddStrC('- - - -  Аварiйнi обнулення оп  - - - - ',0);
      MrFont.AddStrC('Аварiйних обнулень оп не було',0);
      bPrintFooter(10);
      Result:=True;
      Exit;
    except
      on E:Exception do
      begin
        FLastError:='Ошибка печати отчета: '+E.Message;
        Result:=False;
        Exit;
      end;
    end;
  if Not (UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpPerFullRepN(N1,N2);
    EKKA_DATECS3530T: begin
                        Result:=ReConnect;
                        if Not Result then Exit;
                        Result:=(PrintReportByNum(0,PrinterResults,0,PAnsiChar(Passw[15]),N1,N2)=0) and (FLastError='');
                      end;
    EKKA_EXELLIO: begin
                    Result:=ReConnect;
                    if Not Result then Exit;
                    FP.PrintRepByNum('0000',N1,N1);
                    Result:=CheckErrorExellio;
                  end;
    EKKA_FP2000: begin
                   Result:=ReConnect;
                   if Not Result then Exit;
                   FP.PeriodicReportN(N1,N2);
                   Result:=CheckErrorExellio;
                 end;
    EKKA_N707: begin
                 ErrCode:='';
                 ErrDescr:='';
                 Result:=ReConnect;
                 if Not Result then Exit;

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
  end;
end;

function TEKKA.fpPerShortRepD(D1, D2: TDateTime): Boolean;
var
  ErrCode, ErrDescr: String;
begin
  if Not (UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpPerShortRepD(D1,D2);
    EKKA_DATECS3530T: begin
                        Result:=ReConnect;
                        if Not Result then Exit;
                      end;
    EKKA_EXELLIO: begin
                    Result:=ReConnect;
                    if Not Result then Exit;
                    FP.PrintRepByDate('0000',FormatDateTime('ddmmyy',D1),FormatDateTime('ddmmyy',D2));
                    Result:=CheckErrorExellio;
                  end;
    EKKA_FP2000: begin
                   Result:=ReConnect;
                   if Not Result then Exit;
                   FP.PeriodicReport(D1, D2);
                   Result:=CheckErrorExellio;
                 end;
    EKKA_N707: begin
                 ErrCode:='';
                 ErrDescr:='';
                 Result:=ReConnect;
                 if Not Result then Exit;

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

function TEKKA.fpPerShortRepN(N1, N2: Integer): Boolean;
var
  ErrCode, ErrDescr: String;
begin
  if Not (UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpPerShortRepN(N1,N2);
    EKKA_DATECS3530T: begin
                        Result:=ReConnect;
                        if Not Result then Exit;
                      end;
    EKKA_EXELLIO: begin
                    Result:=ReConnect;
                    if Not Result then Exit;
                    FP.PrintRepByNum('0000',N1,N1);
                    Result:=CheckErrorExellio;
                  end;
    EKKA_FP2000: begin
                   Result:=ReConnect;
                   if Not Result then Exit;
                   FP.PeriodicReportN(N1,N2);
                   Result:=CheckErrorExellio;
                 end;
    EKKA_N707: begin
                 ErrCode:='';
                 ErrDescr:='';
                 Result:=ReConnect;
                 if Not Result then Exit;

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

function TEKKA.fpCutBeep(C, B, N: Byte): Boolean;
var
  ErrCode, ErrDescription: string;
begin
  if (UseEKKA=False) or (FLastError='') then
  begin
    Result:=True;
    Exit;
  end;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpCutBeep(C,B,N);
    EKKA_DATECS3530T: Result:=True;
    EKKA_EXELLIO: begin
                    Result:=ReConnect;
                    if Not Result then Exit;
                    Result:=FP.EnableCutCheck(C=1);
                    Result:=CheckErrorExellio;
                  end;
    EKKA_FP2000: begin
                   Result:=ReConnect;
                   if Not Result then Exit;
                   Result:=FP.SetPrintSettingAutoCutting(C=1);
                   Result:=CheckErrorExellio;
                 end;
    EKKA_N707: begin //fpCutBeep
                 if Sound(1000, 1000, ErrCode, ErrDescription,IPAddr) then
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

function TEKKA.fpStrToDisp(S: String): Boolean;
begin
  if Not (UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpStrToDisp(S);
    EKKA_DATECS3530T: Result:=True;
  end;
end;

function TEKKA.fpCurrToDisp(S: Currency): Boolean;
begin
  if Not (UseEKKA) then begin Result:=True; Exit; end;
  Result:=False;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpCurrToDisp(S);
    EKKA_DATECS3530T: Result:=True;
  end;
end;

function TEKKA.fpDisplayText(S: String; L: Byte): Boolean;
begin
  if Not (UseEKKA) then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  case TypeEKKA of
    EKKA_EXELLIO: begin
                    Result:=ReConnect;
                    if Not Result then Exit;
                    if L<=1 then
                      FP.DisplayTextLL(Copy(S,1,20))
                    else
                      FP.DisplayTextUL(Copy(S,1,20));
                    Result:=CheckErrorExellio;
                  end;
    EKKA_FP2000: begin
                   Result:=ReConnect;
                   if Not Result then Exit;
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

procedure TEKKA.SetTypeEKKA(const Value: Byte);
begin
  FTypeEKKA:=Value;
  Case TypeEKKA of
    EKKA_MARRY301MTM: FArtFile:=PrPath+'\$Marry301$.txt';
    EKKA_DATECS3530T: FArtFile:=PrPath+'\$Datecs3530T$.txt';
  end;
end;

function TEKKA.fpCashState(P: Integer): Boolean;
var
  ri: TStringList;
  i: Integer;
  A: Array[0..7] of Currency;
  Res: Variant;
  CashSum, CreditSum, DebitSum, CheckSum, SumReturnTax1, SumReturnTax2: double;
  GtCshStt, ErrCode, ErrDescription: string;
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
        FLastError:='Ошибка печати X-отчета: '+E.Message;
        Result:=False;
        Exit;
      end;
    end;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpCashState(P);
    EKKA_DATECS3530T: begin
                        Result:=ReConnect;
                        if Not Result then Exit;
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
    EKKA_EXELLIO: begin
                    Result:=ReConnect;
                    if Not Result then Exit;
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
    EKKA_FP2000: begin
                   Result:=ReConnect;
                   if Not Result then Exit;
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
    EKKA_N707: begin //fpCashState
                 Result:=ReConnect;
                 if Not Result then Exit;
                 try
                   EKKA.FLastError:='';
                   FRD_Item.Clear;
                   GtCshStt:='';
                   Result:=GetCashState(GtCshStt, ErrCode, ErrDescription, IPAddr);
                   EKKA.FLastError:=trim(ErrCode+' '+ErrDescription);
                   FRD_Item.Text:=GtCshStt;
                   FLastError:='';
                 except
                   Result:=False;
                   if FLastError='' then FLastError:=trim(ErrCode+' '+ErrDescription);
                 end;
               end;
  end;
End;

function TEKKA.fpFiscState: Boolean;
var
  A: Array[1..20] of Currency;
  j, i: Integer;
  Sum: Currency;
  ri: TStringList;
  Res: Variant;
  SumRealizTax1, SumRealizTax2, SumRealizTax3, SumRealizTax4, SumRealizTax5: double;
  SumReturnTax1, SumReturnTax2, SumReturnTax3, SumReturnTax4, SumReturnTax5: double;

  GtFsclStt, ErrCode, ErrDescription: string;
begin
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpFiscState;
    EKKA_DATECS3530T: begin
                        Result:=ReConnect;
                        if Not Result then Exit;
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
                          finally
                            ri.Free;
                          end;
                        except
                          Result:=False;
                          if FLastError='' then FLastError:='ERP_9995';
                        end;
                      end;
    EKKA_EXELLIO: begin
                    Result:=ReConnect;
                    if Not Result then Exit;
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
    EKKA_FP2000: begin
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
    EKKA_N707: begin //fpFiscState
                 Result:=ReConnect;
                 if Not Result then Exit;
                 try
                   EKKA.FLastError:='';
                   FRD_Item.Clear;
                   GtFsclStt:='';
                   if GetFiscalState(GtFsclStt, ErrCode, ErrDescription,IPAddr) then
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
  end;
end;

function TEKKA.fpSendCommand(var Comm: String): Boolean;
begin
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpSendCommand(Comm);
    EKKA_DATECS3530T: Result:=True; 
  end;
end;

function TEKKA.fpAddFinStr(S: String): Boolean;
begin
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpAddFinStr(S);
    EKKA_DATECS3530T: Result:=True;
    //EKKA_N707: curr_check.Add('#'+s);
  end;
end;

function TEKKA.fpSetBottomStr(S: String): Boolean;
begin
  if EmulEKKA then
  begin
    Result:=True;
    Exit
  end;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpSetBottomStr(S);
    EKKA_DATECS3530T: Result:=True; 
  end;
end;

function TEKKA.fpSetBottomStrEx(S: String; N, P, W: Byte): Boolean;
begin
  if EmulEKKA then
  begin
    Result:=True;
    Exit
  end;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpSetBottomStrEx(S,N,P,W);
    EKKA_DATECS3530T: Result:=True;
  end;
end;

function TEKKA.fpSetINSP(FN, ID, PN, Str1, Str2, Str3, Str4: String): Boolean;
begin
  if EmulEKKA then begin Result:=True; Exit end;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=inherited fpSetINSP(FN,ID,PN,Str1,Str2,Str3,Str4);
    EKKA_DATECS3530T: Result:=True;
  end;
end;

function TEKKA.fpSoundEx(Hz, Ms: Integer): Boolean;
var
  ErrCode, ErrDescription: string;
begin
  case TypeEKKA of
    EKKA_EXELLIO: FP.SoundEx(Hz,Ms);
    EKKA_FP2000: FP.Sound(Hz,Ms);
    EKKA_N707: begin //fpSoundEx
                 if Sound(Hz, Ms, ErrCode, ErrDescription,IPAddr) then
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

function TEKKA.fpCloseNoFCheck: Boolean;
begin
  case TypeEKKA of
    EKKA_EXELLIO: FP.CloseNonfiscalReceipt;
    EKKA_FP2000: FP.CloseNotFiscalCheck;
  end;
end;

function TEKKA.fpGetOperatorInfo(O: Byte): Boolean;
var
  SL: TStringList;
  CheckCount, RealizCount, DiscountCount, MarkupCount, VoidCount: Integer;
  UserName: String;
  RealizSum, DiscountSum, MarkupSum, VoidSum: Real;
  Res: Variant;
begin
{
  if TypeEKKA=EKKA_EXELLIO then
  begin
    FP.GetOperatorInfo(O);
    SaveRegisters;
  end;
}
  case TypeEKKA of
    EKKA_EXELLIO: begin
                    FP.GetOperatorInfo(O);
                    SaveRegisters;
                  end;
    EKKA_FP2000: begin
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

function TEKKA.fpGetCorectSums: Boolean;
var
  TotalTurn, NegTotalSum, NotPaidTotalSum: Real;
  Res: Variant;
  SL: TStringList;
begin
{
  if TypeEKKA=EKKA_EXELLIO then
  begin
    FP.GetCorectSums;
    SaveRegisters;
  end;
}
  case TypeEKKA of
    EKKA_EXELLIO: begin
                    FP.GetCorectSums;
                    SaveRegisters;
                  end;
    EKKA_FP2000: begin
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

function TEKKA.fpGetCheckCopyText: String;
begin
  if EmulEKKA then Exit;
  if (UseEKKA=False) or (TypeEKKA<>EKKA_FP2000) then
  begin
    Result:='';
    Exit;
  end;
  Result:=FP.GetCheckCopyText;
end;

function TEKKA.GetPaperOut: Boolean;
begin
  if (UseEKKA=False) or (FLastError='') then
  begin
    Result:=False;
    Exit;
  end;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=FLastError='HARDPAPER';
    EKKA_DATECS3530T: Result:=FLastError='PAPER_OUT';
    EKKA_EXELLIO: Result:=Pos(AnsiUpperCAse('Закончилась чековая или контрольная лента'),AnsiUpperCAse(FP.LastErrorText))<>0;
    EKKA_FP2000: Result:=Pos(AnsiUpperCAse('Закончилась чековая или контрольная лента'),AnsiUpperCAse(FP.LastErrorDescr))<>0;
  end;
end;

function TEKKA.GetLinkOut: Boolean;
begin
  if (UseEKKA=False) or (FLastError='') then
  begin
    Result:=False;
    Exit;
  end;
  Case TypeEKKA of
    EKKA_MARRY301MTM: Result:=(FLastError='ERP_9993') or (FLastError='ERP_9995') or (FLastError='ERP_9998');
    EKKA_DATECS3530T: Result:=FLastError='TIMEOUT_ERROR';
    EKKA_EXELLIO: Result:=(Pos(AnsiUpperCAse('Невозможно открыть COM порт'),AnsiUpperCAse(FP.LastErrorText))<>0) or
                          (Pos(AnsiUpperCAse('Невозможно соединится с фискальным регистратором'),AnsiUpperCAse(FP.LastErrorText))<>0);
    EKKA_FP2000: Result:=(Pos(AnsiUpperCAse('Невозможно открыть COM порт'),AnsiUpperCAse(FP.LastErrorDescr))<>0) or
                         (Pos(AnsiUpperCAse('Невозможно соединится с фискальным регистратором'),AnsiUpperCAse(FP.LastErrorDescr))<>0);
  end;
end;

procedure TEKKA.bPrintHead(P:Byte=0; ControlStrim:Byte=0);
var
  i: Integer;
  S, sID, sPN, sFN, sZN: String;
begin
  FLastError:='';
  MrFont.IntervalW:=2;
  MrFont.StartPrint;
  if IsFLP=False then
   begin

    if ControlStrim=0 then
     begin
      MrFont.AddStrC(FirmNameUA,0);
      for i:=Low(eStr) to High(eStr) do
       if eStr[i]<>'' then MrFont.AddStrC(eStr[i],0);
     end else MrFont.AddStrC(' ',0);
{   if ControlStrim=1 then
    begin
     MrFont.AddStr(' ФН А01140034774        IД '+FsID,0);
     MrFont.AddStr(' ЗН 2034005616      ПН '+FsPN,0);
    end else} begin
              MrFont.AddStr(' ФН '+FsFN+'        IД '+FsID,0);
              MrFont.AddStr(' ЗН '+FsZN+'      ПН '+FsPN,0);
             end;
   end
  else
   begin
    MrFont.AddStrC('ФОП Симонян Хачатур Сергiйович',0);
    MrFont.AddStrC('2765021835',0);
   end;
  if FTypeLogo in [0,1] then MrFont.AddLogo(FTypeLogo);
  if P=1 then
    MrFont.AddInterv(10)
  else
    MrFont.AddStr(' ',0);
end;

procedure TEKKA.bPrintFooter(Param: Byte);
var
  S: String;
//  Param: 1 -чек фискальный,  2 - чек не фискальный,  3 - отчет,  4 - служебный документ, 5 - возвратный чек
 begin
  if (Param in [1,2]) and ((AptekaID=240) or (IsFLP)) then S:='НЕ ФIСКАЛЬНИЙ ЧЕК'
  else
    Case Param of
      1: S:='ФIСКАЛЬНИЙ ЧЕК';
      2,4: S:='!  НЕ  ФIСКАЛЬНИЙ  !';
      3: S:='';
      5: S:='ВИДАТКОВИЙ ЧЕК';
    end;
  MrFont.EndPrint(S,FDtChek,Param,FIsCopy,Not IsFLP);
 end;

procedure TEKKA.GetInfo(NumZ: Integer=0);
begin
  Qr.Close;
  if NumZ=0 then
    Qr.SQL.Text:='exec spY_GetEKKAInfo '+IntToStr(FKassaID)
  else
    Qr.SQL.Text:='exec spY_GetEKKAInfo_ '+IntToStr(FKassaID)+','+IntToStr(NumZ);
  Qr.Open
end;

procedure TEKKA.bPrintRep(Param: Byte; NumZ: Integer=0; ControlStream:Byte=0);
var
  qrS, S: String;
  IsOpen: Boolean;
  DtWriteZ: TDateTime;
  i: Integer;
//  0 - X-отчет
//  1 - Z-отчет
begin
  GetInfo(NumZ);
  bPrintHead(1,ControlStream);
  try
    Case Param of
      0: S:='X';
      1: S:='Z';
    end;
    IsOpen:=Qr.FieldByName('IsOpen').AsInteger=1;
    if (Param=1) and (IsOpen=False) and (NumZ=0) then
      MrFont.AddStrC('*  *  * копiя *  *  *',1);
    MrFont.AddStrC(S+'-звiт № '+AddStr_(Qr.FieldByName('NumZ').AsString,'0',4),1);
    MrFont.AddStrC('за '+DateToStrSlash(Qr.FieldByName('DtRep').AsDateTime),1);
    FDtChek:=Now;
    if Param=1 then
    begin
      if (IsOpen) and (NumZ=0) then
        DtWriteZ:=FDtChek
      else
        DtWriteZ:=Qr.FieldByName('DtRep').AsDateTime;
      MrFont.AddStr(' запис до ФП занесено    '+DateTimeToStrSlash(DtWriteZ),0);
    end;
    if NumZ>0 then FDtChek:=DtWriteZ;
    if (IsOpen=True) or (Param=1) then
    begin
      MrFont.AddStr(' останнiй фiскальний чек '+DateTimeToStrSlash(Qr.FieldByName('DtLastChek').AsDateTime),0);
      MrFont.AddStr(' змiна вiдкрита          '+DateTimeToStrSlash(Qr.FieldByName('DtOpenSmena').AsDateTime),0);
    end
    else
      MrFont.AddStrC('змiна не вiдкрита',1);
    MrFont.AddStrC('валюта звiту (грн)',0);
    if NumZ>0 then
    begin
      MrFont.AddStr('ЗН '+FsZN+'    вiд 11/02/14',0);
      MrFont.AddStr('ФН '+FsFN+'      вiд 31/10/14',0);
    end
    else
    begin
      MrFont.AddStr('ЗН '+FsZN+'    вiд 11/02/14',0);
      MrFont.AddStr('ФН '+FsFN+'      вiд 31/10/14',0);
    end;
    MrFont.AddStr(' - - - - - - - - - - - - - - - - - - - -',0);
    MrFont.AddStrC('- - Реалiзацiя - -',1);
    if (IsOpen=False) and (Param=0) then
    begin
      MrFont.AddStrC('- - - - - - - - - -',0);
      MrFont.AddStr2J('звiльненi вiд оподаткув.','0,00',0);
      MrFont.AddStrC('- - - - - - - - - -',0);
      MrFont.AddStr2J('не є об''єктом оподаткув.','0,00',0);
      MrFont.AddStrC('- - - - - - - - - -',0);
      MrFont.AddStr2J('загальний оборот','0,00',0);
      MrFont.AddStrC('- - - - - - - - - -',0);
      MrFont.AddStrC('Одержано вiд клiєнтів по формам оплати',0);
      MrFont.AddStrC('оплата не стягувалась',0);
      MrFont.AddStr2J('кількість чеків','0',0);
      MrFont.AddStrC(' - - - - - - - - - -',1);
    end
    else
    begin
      MrFont.AddStr('пдв                 *А 20.00%',0);
      if NumZ>0 then
        MrFont.AddStrC('діє з 31/10/14, з №Z 0001',0)
      else
        MrFont.AddStrC('діє з 31/10/14, з №Z 0001',0);
      MrFont.AddStr2J('база оподаткування',CurrToStrF_(Qr.FieldByName('SumA').AsCurrency),0);
      MrFont.AddStr2J('сумма податку вiд бази',CurrToStrF_(Qr.FieldByName('Sum_nAb').AsCurrency),0);
      MrFont.AddStr2J('сумма податку по чекам',CurrToStrF_(Qr.FieldByName('Sum_nA').AsCurrency),0);
      MrFont.AddStr('                    *Б 7.00%',0);
      if NumZ>0 then
        MrFont.AddStrC('діє з 31/10/14, з №Z 0001',0)
      else
        MrFont.AddStrC('діє з 31/10/14, з №Z 0001',0);
      MrFont.AddStr2J('база оподаткування',CurrToStrF_(Qr.FieldByName('SumB').AsCurrency),0);
      MrFont.AddStr2J('сумма податку вiд бази',CurrToStrF_(Qr.FieldByName('Sum_nBb').AsCurrency),0);
      MrFont.AddStr2J('сумма податку по чекам',CurrToStrF_(Qr.FieldByName('Sum_nB').AsCurrency),0);
      MrFont.AddStrC('- - - - - - - - - -',0);
      MrFont.AddStr2J('звільнені від оподаткув.','0,00',0);
      MrFont.AddStrC('- - - - - - - - - -',0);
      MrFont.AddStr2J('не є об''єктом оподаткув.','0,00',0);
      MrFont.AddStrC('- - - - - - - - - -',0);
      MrFont.AddStr2J('загальний оборот',CurrToStrF_(Qr.FieldByName('Sum4').AsCurrency+Qr.FieldByName('Sum7').AsCurrency),0);
      MrFont.AddStrC('- - - - - - - - - -',0);
      MrFont.AddStrC('Одержано вiд клiєнтів по формам оплати',0);
      if Qr.FieldByName('Sum4').AsCurrency>0 then
       MrFont.AddStr2J('готівка',CurrToStrF_(Qr.FieldByName('Sum4').AsCurrency),0);

      if Qr.FieldByName('SumB1').AsCurrency>0 then
        MrFont.AddStr2J('безготівкова.1',CurrToStrF_(Qr.FieldByName('SumB1').AsCurrency),0);
      if Qr.FieldByName('Sum7').AsCurrency>0 then
       MrFont.AddStr2J('безготівкова.2',CurrToStrF_(Qr.FieldByName('Sum7').AsCurrency),0);
      if Qr.FieldByName('SumB3').AsCurrency>0 then
        MrFont.AddStr2J('безготівкова.3',CurrToStrF_(Qr.FieldByName('SumB3').AsCurrency),0);
      MrFont.AddStr2J('кількість чеків',Qr.FieldByName('CntCheks').AsString,0);
      // Если были возвраты от покупателя
      if (Qr.FieldByName('Sum5').AsCurrency>0) or (Qr.FieldByName('Sum5').AsCurrency>0) then
       begin
        MrFont.AddStr(' - - - - - - - - - - - - - - - - - - - -',0);
        MrFont.AddStrC('- - Повернення - -',1);
        MrFont.AddStr('пдв                 *А 20.00%',0);
        MrFont.AddStrC('діє з 31/10/14, з №Z 0001',0);
        MrFont.AddStr2J('база оподаткування',CurrToStrF_(Qr.FieldByName('SumBA').AsCurrency),0);
        MrFont.AddStr2J('сумма податку вiд бази',CurrToStrF_(Qr.FieldByName('Sum_nBAb').AsCurrency),0);
        MrFont.AddStr2J('сумма податку по чекам',CurrToStrF_(Qr.FieldByName('Sum_nBA').AsCurrency),0);
        MrFont.AddStr('                    *Б 7.00%',0);
        MrFont.AddStrC('діє з 31/10/14, з №Z 0001',0);
        MrFont.AddStr2J('база оподаткування',CurrToStrF_(Qr.FieldByName('SumBB').AsCurrency),0);
        MrFont.AddStr2J('сумма податку вiд бази',CurrToStrF_(Qr.FieldByName('Sum_nBBb').AsCurrency),0);
        MrFont.AddStr2J('сумма податку по чекам',CurrToStrF_(Qr.FieldByName('Sum_nBB').AsCurrency),0);
        MrFont.AddStrC('- - - - - - - - - -',0);
        MrFont.AddStr2J('звільнені від оподаткув.','0,00',0);
        MrFont.AddStrC('- - - - - - - - - -',0);
        MrFont.AddStr2J('не є об''єктом оподаткув.','0,00',0);
        MrFont.AddStrC('- - - - - - - - - -',0);
        MrFont.AddStr2J('загальний оборот',CurrToStrF_(Qr.FieldByName('Sum5').AsCurrency+Qr.FieldByName('Sum8').AsCurrency),0);
        MrFont.AddStrC('- - - - - - - - - -',0);
        MrFont.AddStrC('Повернено клiєнтам по формам оплати',0);

        if Qr.FieldByName('Sum5').AsCurrency>0 then
         MrFont.AddStr2J('готівка',CurrToStrF_(Qr.FieldByName('Sum5').AsCurrency),0);

        if Qr.FieldByName('SumB1_').AsCurrency>0 then
         MrFont.AddStr2J('безготівкова.1',CurrToStrF_(Qr.FieldByName('SumB1_').AsCurrency),0);
        if Qr.FieldByName('Sum8').AsCurrency>0 then
         MrFont.AddStr2J('безготівкова.2',CurrToStrF_(Qr.FieldByName('Sum8').AsCurrency),0);
        if Qr.FieldByName('SumB3_').AsCurrency>0 then
         MrFont.AddStr2J('безготівкова.3',CurrToStrF_(Qr.FieldByName('SumB3_').AsCurrency),0);
        MrFont.AddStr2J('кількість чеків',Qr.FieldByName('CntCheksB').AsString,0);
      end;
      MrFont.AddStrC(' - - - - - - - - - -',1);
    end;
    MrFont.AddStrC('- - - - - - Готівкові кошти в касі - - - -',0);
    MrFont.AddStr2J('початковий залишок',CurrToStrF_(Qr.FieldByName('Sum1').AsCurrency),0);
    MrFont.AddStr2J('службове внесення', CurrToStrF_(Qr.FieldByName('Sum2').AsCurrency),0);
    MrFont.AddStr2J('службове вилучення',CurrToStrF_(Qr.FieldByName('Sum3').AsCurrency),0);
    MrFont.AddStr2J('кінцевий залишок',  CurrToStrF_(Qr.FieldByName('Sum6').AsCurrency),0);
    MrFont.AddStrC('- - - - - - - - - Виручка - - - - - - -',0);
    MrFont.AddStr2J('готівка',   CurrToStrF_(Qr.FieldByName('Sum4').AsCurrency-Qr.FieldByName('Sum5').AsCurrency),0);
    MrFont.AddStr2J('безготівкова',CurrToStrF_(Qr.FieldByName('Sum7').AsCurrency-Qr.FieldByName('Sum8').AsCurrency),0);
    MrFont.AddStrC('- - - - - - - - - - - - - - - - - - - -',0);
    MrFont.AddStr2J('номер останнього чека',Qr.FieldByName('NLastChek').AsString,0);
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
//        QrEx.SQL.SaveToFile('C:\tttttttttt');
        QrEx.Open;
      end;
      MrFont.AddStr('1. Регістри денних підсумків обнулені',0);
      MrFont.AddStr('2. фіскальний звітний чек дійсний',0);
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

    Типы оплат:
          Мария    Датекс FP3530  Exellio LP1000  Exellio FP2000  
     1 - Безнал 3
     2 - Безнал 2
     3 - Безнал 1
     4 - Наличные

   }



