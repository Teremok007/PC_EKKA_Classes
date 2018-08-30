UNIT Marry301U;

INTERFACE

Uses Windows, Dialogs, Messages, SysUtils, Classes, CPDrv, Util, IniFiles,Graphics, ADODB;

Type

 TMarry301 = class (TCommPortDriver)

 private

  FLog:TStrings;
  FIsCRC:Integer;
  FResComm:String;
  FKassir:String;
  FUseEKKA:Boolean;
  FRnd:Char;
  FSumSales:Integer;
  FSumVoids:Integer;
  FLastNumCheck:Integer;
  FIsNewVersion:Boolean;
  FLogFile:String;
  FQrL:TADOQuery;
  FIP:String;

  procedure SetPortNum(const Value:Integer);
  procedure SetLog(const Value:TStrings);
  procedure SetKassir(Value:String);
  procedure SetLogFile(const Value: String);

  function GetCommName(S:String):String;
  function GetPortNum:Integer;

  function SendCommand(Comm:String; IsRet:Boolean):Boolean;

  function SplitRes(S,P:String; SL:TStrings):Boolean;
  function GetLastErrorDescr:String;
  function SendStringMy(S:String):Boolean;
  function ReadString(var S:String):Boolean;
  function SwapData(Comm:String): Boolean;
  function IntToArt(N:Integer):String;
  function GetCommParams(S:String):String;
  function GetServiceNumber:Integer;

 protected

  FArtFile:String;
  FKassaID:Byte;
  FRD_Item:TStringList;
  FVzhNum:Int64;
  FVzhNumS:String;
  FFN:Int64;
  FLastError:String;

  function GetReceiptNumber:Integer; virtual;
  function GetVzhNum:Int64; virtual;

 public

  constructor Create(AOwner:TComponent); override;
  destructor Destroy; override;

  procedure ClearLog;                                        // ������� ����
  procedure fpClosePort; virtual;                            // ������� ��� ����

  function  fpSendCommand(var Comm:String):Boolean; virtual; // ���������� ������������ �������, ���� ���� ����������, �� ��� ������������� � Comm

  function  fpGetNewArt:String; virtual;
  function  ErrorDescr(Code:String):String; virtual;                 // ��������� ��������� �� ���� ������

  { --- ��������� ����� � ���� --- }
  function  fpConnect:Boolean; virtual;                      // ��������� ����� � ����

  { --- ��������� ������� ����� ---}
  function  fpSetINSP(FN:String; ID:String; PN:String; Str1,Str2,Str3,Str4:String):Boolean; virtual; // ��������������� ���������� ���������.
  function  fpSetTime(T:TDateTime):Boolean; virtual;         // ��������� ������� EKKA

  function  fpLoadLogo(Logo:String; Active:Boolean):Boolean;  overload; virtual; // �������� ������������ ������-�������� �� �����
  function  fpLoadLogo(Logo:TBitMap; Active:Boolean):Boolean; overload; virtual; // �������� ������������ ������-�������� �� BitMap

  function  fpActiveLogo(P:Byte):Boolean; virtual;              // ����������� ������ ������������ ������ (0 �� ��������, 1 - ��������)
  function  fpCutBeep(C,B,N:Byte):Boolean; overload; virtual;   // ���������� ������� ��������� ������� ����� � �������� ��������
  function  fpCutBeep(C,B:Byte):Boolean; overload; virtual;     // ���������� ������� ��������� ������� ����� � �������� ��������
  function  fpSetHead(S:String):Boolean; virtual;               // ��������� ������������ ������

  { --- ���������� ��������������� ������������ --- }
  function  fpOpenCashBox:Boolean; virtual;          // �������� ��������� �����

  { --- ���������������� ���������� ������ --- }
  function  fpSetBottomStr(S:String):Boolean; virtual; // ���������������� �������������� �������������� ������ �� ����.
  function  fpSetBottomStrEx(S:String; N,P,W:Byte):Boolean; virtual; // ���������������� �������������� �������������� ������ �� ����.

  { --- ���������� � ������� ������� � ����� --- }
  function  fpOpenFiscalReceipt(Param:Byte=1; NChek:Integer=0; ControlStrim:Byte=0):Boolean; virtual; // �������� ������ ����
  function  fpAddSale(Name:String;                              // ����������� ������� ����� �������
                      Kol:Integer;
                      Cena:Currency;
                      Divis:Byte;
                      Artic:Integer;
                      Nalog:Byte;
                      DiscSum:Currency;
                      DiscDescr:String
                     ):Boolean;  virtual;

  function  fpSetBackReceipt(S:String):Boolean;  virtual;      // ����������� ������ ����������� ����
  function  fpAddBack(Name:String;                             // ����������� ������� ��������
                      Kol:Integer;
                      Cena:Currency;
                      Divis:Byte;
                      Artic:Integer;
                      Nalog:Byte;
                      DiscSum:Currency;
                      DiscDescr:String
                     ):Boolean; virtual;

  function  fpAddFinStr(S:String):Boolean; virtual;  // �������������� ���������� � ������ (������)

  function  fpServiceText(TextPos:Integer;                     // ����������� ��������� ������ � ����
                          Print2:Integer;
                          FontHeight:Integer;
                          S:String
                         ):Boolean;  virtual;

  function  fpCloseFiscalReceipt(TakedSumm:Currency;           // �������� ����
                                 TypeOplat:Integer;
                                 SumCheck:Currency=0;
                                 SumB1:Currency=0;
                                 IsDnepr:Boolean=False;
                                 ControlStreem:Byte=0;
                                 RRN: longint = 1;
                                 BankCard: string='000000000000000'
                                ):Boolean; virtual;

  function  fpCloseFiscalReceiptB(TakedSumm:Currency; TypeOplat:Integer; SumCheck:Currency=0):Boolean;

  function  fpCancelFiscalReceipt:Boolean; virtual;            // ������ ����
  function  fpCheckCopy(Cnt:Byte=1; NChForce:Integer=0):Boolean; virtual;                      // ������ ����� ����

  { --- ��������� ��������/������� �������� ������� --- }
  function  fpCashInput(C:Currency):Boolean; virtual;         // �������� �������� �������
  function  fpCashOutput(C:Currency; P:Byte=0):Boolean; virtual;        // ������� �������� �������

  { --- ��������� ����������������� ���������� � ��������� ���� --- }
  function  fpGetStatus:Boolean; virtual;                    // ��������� ����������� ��������� EKKA
  function  fpCashState(P:Integer):Boolean; virtual;         // ������ ���������� � �������� ������� �� ����� (0 - �� ������� �����, 1 - �� �������)
  function  fpFiscState:Boolean; virtual;                    // ������ �������� ��������� ������� ���������� ���������

  { --- ���������� ������ --- }
  function  fpXRep:Boolean; virtual;                         // X-�����
  function  fpZRep:Boolean; virtual;                         // Z-�����
  function  fpPerFullRepD(D1,D2:TDateTime):Boolean; virtual; // ������ ������������� ����� �� �����
  function  fpPerShortRepD(D1,D2:TDateTime):Boolean; virtual;// ����������� ������������� ����� �� �����
  function  fpPerFullRepN(N1,N2:Integer):Boolean; virtual;   // ������ ������������� ����� �� ������� Z-�������
  function  fpPerShortRepN(N1,N2:Integer):Boolean; virtual;  // ����������� ������������� ����� �� ����� Z-�������

  { --- ������������� � ��������� ������ --- }
  function  fpDiscRep:Boolean; virtual;                       // ����� �� ������� � ���������
  function  fpZeroCheck:Boolean; virtual;                     // ������� ���

  { --- ������������ ��������� ��������� �� --- }
  function  fpClearServiceText:Boolean; virtual;              // ������  ��������� ����������
  function  fpCancelServiceReceipt:Boolean; virtual;          // ������ ���������� ����
  function  fpOpenServiceReceipt:Boolean; virtual;            // �������� ���������� ����
  function  fpCloseServiceReceipt:Boolean; virtual;           //  �������� ���������� ����

  { --- ������� ��������� � ��������� ���������� ��������� ����������� --- }
  function fpServPassw(P1:String; P2:String=''):Boolean; virtual; // ���� ������ ��������� ����������� (��������� ��������� - 2222222222)
  function fpPrintLimit(P:Integer):Boolean; virtual;              // ���� ���������� �����, ����� �������� ���� �����������
  function fpDayLimit(D:Integer):Boolean; virtual;                // ���� ���������� ����, ����� �������� ���� �����������
  function fpGetLimitStatus:Boolean; virtual;                    // ������ ��������������� ������� ���� ������ � ����� ������
  function fpResetUsPassw:Boolean; virtual;                      // ����� ������ ������������ � ��������� - '1111111111'

  { --- ���������� ��������������� ������������ --- }
  function fpStrToDisp(S:String):Boolean; virtual;
  function fpCurrToDisp(S:Currency):Boolean; virtual;

  { --- �������������� ������� ---}
  function  KeyPosition(Key:Byte):Boolean; virtual;          // �������� ��������� �����

  { --- �������� ����c�� --- }
  property  Log:TStrings read FLog write SetLog;     // ��� ������ (����� ��� ����������� ���� ���������)
  property  IsCRC:Integer read FIsCRC write FIsCRC;  // ������� ������������� ����������� ����� ��� �������� ������
  property  UseEKKA:Boolean read FUseEKKA write FUseEKKA;     // ���� ���������� EKKA
  property  Kassir:String read FKassir write SetKassir;       // ��� ������� ��� �����������
  property  PortNum:Integer read GetPortNum write SetPortNum; // ������������� ����� ��� �����
  property  LastError:String read FLastError;                 // ��������� ������ ������� ���������� �������
  property  LastErrorDescr:String read GetLastErrorDescr;     // �������� ��������� ������ ������� ���������� �������
  property  RD_Item:TStringList read FRD_Item;                // ������ �������, ����������� ����� ���������� ������ fpGeStatus,
  property  ReceiptNumber:Integer read GetReceiptNumber;      // ����� ���������� ������� ������������ ����
  property  Rnd:Char read FRnd write FRnd;                    // ������� ����������
  property  IsNewVersion:Boolean read FIsNewVersion write FIsNewVersion; // ������� ������ ���� (True - T7, False - T3,T4)
  property  VzhNum:Int64 read GetVzhNum;                        // ��������� ����� ��������� ��������
  property  VzhNumS:String read FVzhNumS;                      // ��������� ����� ��������� ��������
  property  FN:Int64 read FFN;                                // ���������� ����� ��������� ��������
  property  ArtFile:String read FArtFile write FArtFile;      // ���� ��������� , ��������� ��� ��������� ��� �������� �������� � ���������� �������� ���������
  property  LogFile:String read FLogFile write SetLogFile;
  property  QrL:TADOQuery read FQrL write FQrL;
  property  KassaID:Byte read FKassaID write FKassaID;                        // ����� �����
  property  IP:String read FIP write FIP;

 end;

const C_UNSAFE=0;  // ������ ��� ����������� �����
      C_CRC=1;     // ������ � ����������� ������
      TIME_OUT=6;  // ����� �������� ����������� ������� � ��������

      // ��������� �����
      KEY_O=0; // ��������
      KEY_W=1; // ������
      KEY_X=2; // X-�����
      KEY_Z=4; // Z-�����
      KEY_P=8; // ����������������

      RND_MATH='0'; // �� �������� �����������
      RND_MAX ='1'; // �� ���������� ��������
      RND_MIN ='2'; // �� ���������� ��������

Function Marry301:TMarry301;

IMPLEMENTATION

uses EKKAU;

Var FMarry301:TMarry301=nil;
    Arr:Array of Integer;

Function Marry301:TMarry301;
 begin
  if FMarry301=nil then FMarry301:=TMarry301.Create(nil);
  Result:=FMarry301;
 end;

constructor TMarry301.Create(AOwner:TComponent);
 begin
  inherited Create(AOwner);

  FRD_Item:=TStringList.Create;
  FKassaID:=1;
  FLog:=nil;
  FQrL:=nil;
  FBaudRate:=br115200;
  FBaudRateValue:=115200;
  FParity:=ptEVEN;
  FPort:=pnCOM1;
  FPortName:='\\.\COM1';

  FStopBits:=sb2BITS;

  FInputTimeOut:=50;
  FOutPutTimeOut:=1000;
  FPollingDelay:=100;

  FLastError:='';
  FIsCRC:=C_UNSAFE;
  FIsNewVersion:=True;
  Kassir:='';
  FUseEKKA:=True;

  FLogFile:='';

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

//function TMarry301.CustomConnect(Ksr:String):Integer;
function TMarry301.fpConnect:Boolean;
var i:Integer;
    S:String;
    B:Boolean;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
  try
   if inherited Connect=false then AbortS('ERP_9998');
   B:=False;
   for i:=1 to 5 do
    begin
     SendChar('U');
     Delay(0.2);
     SendChar('U');
     if ReadString(S) then
      if Pos('READY',S)<>0 then
       begin

        SwapData('UPAS1111111111'+FKassir);
        if FLastError='SOFTUPAS' then AbortS(FLastError);
        SwapData('CONF');
        if Length(Copy(FResComm,1,10))<>10 then AbortS(FLastError) else
         begin
          try
           FVzhNumS:=Copy(FResComm,1,10);
           FVzhNum:=StrToInt64(FVzhNumS);
           if (Copy(FResComm,11,10)='XXXXXXXXXX') or (Copy(FResComm,11,10)='          ') then FFN:=0
                                                                               else FFN:=StrToInt64(Copy(FResComm,11,10));
          except
           AbortS('ERP_9993');
          end;
          B:=True;
          Break;
         end;
       end;
    end;
   if Not (B) then AbortS('ERP_9993');
   Result:=True;
  except
   on E:Exception do
    begin
     Result:=False;
     Disconnect;
     if FLastError='' then FLastError:=E.Message;
     if FLastError='' then FLastError:='ERP_9999';
    end;
  end;
 end;

function TMarry301.ReadString(var S:String):Boolean;
var i:Integer;
    B:Boolean;
    Ch:Byte;
 begin
  B:=False;
  S:='';
  Ch:=0;
  ReadByte(Ch);
  if Ch=253 then
   begin
    S:=S+OemToChar(Ch);
    for i:=0 to 255 do
     begin
      if ReadByte(Ch) then S:=S+OemToChar(Ch);
      if Ch=254 then begin B:=True; Break; end;
     end;
   end;
  if Not B then S:='ERROR';
  Result:=B;
 end;

function TMarry301.SwapData(Comm:String):Boolean;
var T:TDateTime;
    Res,ss1,RS:String;
 begin
  Result:=False;
  FLastError:='';
  FResComm:='';
  if SendStringMy(Comm)=False then begin FLastError:='ERP_9993'; Exit; end;
  T:=Time;
  Repeat
   if ReadString(RS) then
    begin
     Res:=GetCommName(RS);
     if Not ((Res='WAIT') or (Res='READY') or (Res='DONE') or (Res='PRN') or (Res='WRK')) then
      if FLog<>nil then
       begin
        FLog.Add(Res);
        if FLogFile<>'' then FLog.SaveToFile(FLogFile);
       end;

     ss1:=Copy(Res,1,4);

     if ((ss1='SOFT') or (ss1='HARD') or (ss1='MEM_') or (ss1='RTC_') or (ss1='ERRO')) and (AnsiUpperCase(Copy(Res,1,9))<>'SOFTPAPER') and (AnsiUpperCase(Copy(Res,1,9))<>'HARDPOINT') {and (AnsiUpperCase(Copy(Res,1,9))<>'HARDPAPER')} then FLastError:=Res else

     if ss1=Copy(Comm,1,4) then FResComm:=Copy(Res,5,Length(Res)-4) else
     if Res='DONE' then Result:=True else
     if Res='READY' then Break;
     T:=Time;
    end;
   if Abs(Time-T)*100000>=TIME_OUT then begin FLastError:='ERP_9993'; Break; end;
  Until False;
 end;

(*
function TMarry301.SendCommand(Comm:String; IsRet:Boolean):Boolean;
var Rc,Lr:String;
    Sl:TStringList;
    q:Integer;

 function ReConnect:Boolean;
  begin
   Result:=False;
   if FLastError<>'ERP_9993' then Exit;
   Result:=True;
   try
    if SwapData('GGG') then Exit;
    fpClosePort;
    if Not fpConnect then Abort;
   except
    FLastError:='ERP_9993';
    Result:=False;
   end;
  end;

 Begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
  Result:=True;

//  AppendStringToFile('D:\AVA\Kassa.txt',Comm);
  q:=0;
   try
    Inc(q);
    SwapData('SYNC123');
    if FResComm<>'123' then
     if Not ReConnect then Abort;
    if Not SwapData(Comm) then
     begin
      Lr:=FLastError;
      Rc:=FResComm;
      try
       if Not ReConnect then Abort;
       SwapData('CONF');
       if Copy(FResComm,103,4)<>Copy(Comm,1,4) then Abort else Exit;
      finally
       FLastError:=Lr;
       FResComm:=Rc;
      end;
     end else Exit;
    if FLastError<>'' then AbortS(FLastError);
    if (IsRet) and (FResComm='') then AbortS('ERP_9995');
   except
    on E:Exception do
     begin
      Result:=False;
      if FLastError='' then FLastError:=E.Message;
      if FLastError='' then FLastError:='ERP_9999';
     end;
   end;
 End;
*)
function TMarry301.SendCommand(Comm:String; IsRet:Boolean):Boolean;
var Rc,Lr:String;
    Sl:TStringList;
    q:Integer;
    Dt:TDateTime;

 function ReConnect:Boolean;
  begin
   Result:=False;
   if FLastError<>'ERP_9993' then Exit;
   Result:=True;
   try
    if SwapData('GGG') then Exit;
    fpClosePort;
    if Not fpConnect then Abort;
   except
    FLastError:='ERP_9993';
    Result:=False;
   end;
  end;

 Begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
  Result:=True;
  Dt:=Now;
//  AppendStringToFile('D:\AVA\Kassa.txt',Comm);
  q:=0;
  try
   Repeat
    try
     Inc(q);
     SwapData('SYNC123');
     if FResComm<>'123' then
      if Not ReConnect then Abort;
     if Not SwapData(Comm) then
      begin
       Lr:=FLastError;
       Rc:=FResComm;
       try
        if Not ReConnect then Abort;
        SwapData('CONF');
        if Copy(FResComm,103,4)<>Copy(Comm,1,4) then Abort else Exit;
       finally
        FLastError:=Lr;
        FResComm:=Rc;
       end;
      end else Exit;
     if FLastError='HARDPOINT' then FLastError:='';
//     if FLastError='HARDPAPER' then FLastError:='';
     if FLastError<>'' then AbortS(FLastError);
     if (IsRet) and (FResComm='') then AbortS('ERP_9995');
     Break;
    except
     on E:Exception do
      begin
       Result:=False;
       if (FLastError='SOFTBLOCK') and (q<3) then Continue;

       if FLastError='' then FLastError:=E.Message;
       if FLastError='' then FLastError:='ERP_9999';
       Break;
      end;
    end;
   Until False;
  finally
   if FQrL<>nil then
    try
     FQrL.Close;
     FQrL.SQL.Text:='exec Report..spY_RegisterRRO :pComm, '''+FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',Dt)+''','''+FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',Now)+''',:pIDK,:pIP,:pErr';
//    FQrL.SQL.SaveToFile('c:\log\lLog.txt');
     FQrL.Parameters.ParseSQL(FQrL.SQL.Text,True);
     FQrL.Parameters.ParamByName('pComm').Value:=Comm;
     FQrL.Parameters.ParamByName('pIDK').Value:=FKassaID;
     FQrL.Parameters.ParamByName('pIP').Value:=FIP;
     FQrL.Parameters.ParamByName('pErr').Value:=FLastError;
     FQrL.ExecSQL;
    except
   {
     on E:Exception do
      begin
       FQrL.Close;
       FQrL.SQL.Text:=E.Message;
       FQrL.SQL.SaveToFile('c:\log\lErr.txt');
      end;
   }
    end;
  end
 End;

{
FISC
������ �����
000001303
000001303
00001
1
0
000000
�00700
000000
000000
000000
000000
000000
000000
0011
0

000000000
�(���.�������) �-�'
}

function TMarry301.ErrorDescr(Code:String):String;
 begin
  { --- ������ ������������ ������ --- }
  if Code='ERP_9986' then Result:='������ ���������� ���������� ������ ��������!' else
  if Code='ERP_9987' then Result:='������ ����������� ������ ����!' else
  if Code='ERP_9988' then Result:='������ �������� ������������ ������!' else
  if Code='ERP_9989' then Result:='������ ������ Z-������!' else
  if Code='ERP_9990' then Result:='������ �������� ����!' else
  if Code='ERP_9991' then Result:='������ �������� ����!' else

  if Code='ERP_9992' then Result:='������������ ��������� �������!' else
  if Code='ERP_9993' then Result:='��� ������ �� ������������!' else
  if Code='ERP_9994' then Result:='��� ���������� �������, ������� ������ ��������� �� ������!' else

  if Code='ERP_9995' then Result:='������ ���������� ���������� �������!' else
  if Code='ERP_9996' then Result:='��� ������ �� ������������!' else
  if Code='ERP_9997' then Result:='������ ������� �������!' else
  if Code='ERP_9998' then Result:='�� ����������� ����������� � �����!' else
  if Code='ERP_9999' then Result:='����������� ������!' else

  { --- ������ ����������� ������ --- }
  if Code='HARDPAPER'	 then Result:='����������� ������� ���/� ����������� �����' else
  if Code='HARDSENSOR' then Result:='������������ ������������� ����� ���������� �������.' else
  if Code='HARDPOINT'	 then Result:='������ ����������� ���������� �������.' else
  if Code='HARDTXD'		 then Result:='������ ������ �����: �������� �� ��������' else
  if Code='HARDTIMER'	 then Result:='������ ��������� ������ ��������� ����� ��������� ������� (������������ ��������� ''SHUTDOWN'')' else
  if Code='HARDMEMORY' then Result:='������ �������� ������ � ���������� ������ (������������ ��������� ''SHUTDOWN'')' else
  if Code='HARDLCD'		 then Result:='������������� ����������� ������� ����������' else
  if Code='HARDUCCLOW' then Result:='������ ���������� ������� (������������ ��������� ''SHUTDOWN'')' else
  if Code='HARDCUTTER' then Result:='������������� ��������� ������� �����' else
  if Code='HARDBADHSET'then Result:='����������� ������� ���������� ������������ ������������� �� ������������� ���������� ����� ������������.' else
  if Code='HARDEXTDISP'then Result:='������������� ��������� ������� ���������� - ���������� ��������� (������������� ����������������� ������, ��� �������).' else
  if Code='SHUTDOWN'	 then Result:='���� ���������� �� ����������� ��������: ������������� ����� ��������� �������, ������ ��� ������ � ���������� ������� ��� ������� ���������� ������� ���� ����������� �������.' else

  { --- ������ ����������� ������ --- }
  if Code='SOFTBLOCK'	 then Result:='��������� ���������� ����� ������� (SOFTBLOCK)' else
  if Code='SOFTNREP'	 then Result:='��� ���������� ������ ���������� ����� Z-����� (SOFTNREP)'else
  if Code='SOFTSYSLOCK'then Result:='������������ ��������� ���������� ����� (SOFTSYSLOCK)' else
  if Code='SOFTCOMMAN' then Result:='������������ ������� (SOFTCOMMAN)' else
  if Code='SOFTPROTOC' then Result:='�������� ������������������ ������ ��� ���������� ����� Z-����� ���� ��������� ������ �������� �������� (SOFTPROTOC)' else
  if Code='SOFTZREPOR' then Result:='Z-����� �� ����������� ��-�� ������ ��� ������ (SOFTZREPOR)' else
  if Code='SOFTFMFULL' then Result:='������������ ���������� ������ (SOFTFMFULL)' else
  if Code='SOFTPARAM'	 then Result:='���, ���������� ��� �������� ���������� ������� ������� (SOFTPARAM)' else
  if Code='SOFTUPAS'	 then Result:='��������� ��������� ���� � ����������� ������� ���� ������� (SOFTUPAS)' else
  if Code='SOFTCHECK'	 then Result:='�� ��������� ����������� ����� ����������� ������� ��� �� �������� �� ����� ��������� (SOFTCHECK)' else
  if Code='SOFTSLWORK' then Result:='���������� ���� � ��������� "������ "(�)' else
  if Code='SOFTSLPROG' then Result:='���������� ���� � ��������� "����������������" (�)' else
  if Code='SOFTSLZREP' then Result:='���������� ���� � ��������� "X-�����" (�)' else
  if Code='SOFTSLNREP' then Result:='���������� ���� � ��������� "Z-�����" (Z)' else
  if Code='SOFTREPL'	 then Result:='��������������� �������� ��� ���� � �� (SOFTREPL)' else
  if Code='SOFTREGIST' then Result:='� �� ����������� ��������������� ���������� (SOFTREGIST)' else
  if Code='SOFTOVER' 	 then Result:='������������ ������� ��������� ��� ��������� ������������ ���������� ����������� ����� (SOFTOVER)' else
  if Code='SOFTNEED'   then Result:='������������ ������������� ��������� �������� ��������� ��� ������������� ���������� ������� ������� � ����� (SOFTNEED)' else
  if Code='SOFT24HOUR' then Result:='������ ������������ ����� 24-� �����. ���������� ����� Z-�����' else

  if Code='SOFTDIFART' then Result:='���������� ��������� ������������ ��� ���� ��������������� ��� �������� ���������. ���������� ����� Z-����� (SOFTDIFART)' else

  if Code='SOFTBADART' then Result:='����� �������� ������� �� ������� ��������� (SOFTBADART)' else
  if Code='SOFTCOPY'   then Result:='������������ ������ �����������. � ���� ����� 300 ����� (SOFTCOPY)' else
  if Code='SOFTOVART'	 then Result:='��������� ������������ ���������� ������ � ���� - ����� 720 (SOFTOVART)' else
  if Code='SOFTBADDISC'then Result:='���� ������ ������ ����� ������� �� ��������������� �������-��� ������� (SOFTBADDISC)' else
  if Code='SOFTBADCS'	 then Result:='�������������� ����������� ���� (SOFTBADCS)' else
  if Code='SOFTARTMODE'then Result:='������������ �������� ����������� ������� (SOFTARTMODE)' else
  if Code='SOFTPAPER'  then Result:='������������� ������� ������ � �������� ��������' else
  if Code='SOFTTXTOUT' then Result:='��������� ����� �������� ������ ������� - ����� 2-� ������ (SOFTTXTOUT)' else

  { --- ��������� �� ������� ����� 304}
  if Code='SOFTpDATSIZE' then Result:='���������� ������ ������ ��� ���������� ������������ ��������� (SOFTpDATSIZE)' else
  if Code='SOFTpMODEM' then Result:='���������� � ��������� ������� ��������� �������� ��������� ��� ���� ��� ������ �� ��������! ���� � ������� �������� ������ ��� ����� �����������, ����������� � IT-�����. (SOFTpMODEM)' else
  if Code='SOFTpOVER72H' then Result:='��������� � �������� ������� �������� ��������, ��������� ����� ������ � ��������� ��������. ���� �� ������� - ����������� � IT-�����(SOFTpOVER72H)' else
  if Code='SOFTpNRKSEF' then Result:='��� ����� �� �������� ����. ����������� � IT-����� ��� ������� ��������� ������� (SOFTpNRKSEF)' else
  if Code='SOFTpCORRDAT' then Result:='��������� ����������� ������ ������ ���� (SOFTpCORRDAT)' else
  if Code='SOFTpERKSEF' then Result:='�������� ���� �� ��������������. ����������� � IT-����� ��� ������� ��������� ������� (SOFTpERKSEF)' else
  if Code='SOFTpNODATA' then Result:='��� ����������� ������ � �������� ���� (SOFTpNODATA)' else
  if Code='SOFTpPDNS' then Result:='����� ������ ���������� �������� ��� �� ������� �� �������� ���� (SOFTpPDNS)' else
  if Code='SOFTpNPRSN' then Result:='�� ����������� ��������� �������������� (SOFTpNPRSN)' else
  if Code='SOFTp7816' then Result:='������ ������������� ���������� ����� SAM (SOFTp7816)' else
  if Code='SOFTpIDDEV' then Result:='� SAM ���������� ������ ID_DEV ���������� ������ ����������, ����������� � IT-�����. (SOFTpIDDEV)' else
  if Code='SOFTpSAMINT' then Result:='������ ������������� SAM (SOFTpSAMINT)' else
  if Code='SOFTpSYSTEM' then Result:='������ ������������� ���������� �������� � �������� ���������� (SOFTpSYSTEM)' else

  { --- ��������� ���� ��� ����������  --- }
  if Code='MEM_ERROR_CODE_01'	then Result:='������ ������ � ��: ������ �� ����� ���� ��������' else
  if Code='MEM_ERROR_CODE_02'	then Result:='������ ������ � ��: �������� ������� ����� ������ �� ������' else
  if Code='MEM_ERROR_CODE_05'	then Result:='����������� ��� ������� ��������� �����, ���������� � ��' else
  if Code='MEM_ERROR_CODE_06'	then Result:='����������� ������ � ������ �����' else
  if Code='MEM_ERROR_CODE_07'	then Result:='����� ���������� Z-������, ����������� � ��, ������ ������ �������� Z-������' else
  if Code='MEM_ERROR_CODE_08'	then Result:='����� �������� Z-������ ����� ��� �� ������� ��������-�� �� ������ ���������� Z-������, ����������� � ��' else
  if Code='MEM_ERROR_CODE_10'	then Result:='�������� ���������� ���������� ������ � Z-������' else
  if Code='MEM_ERROR_CODE_11'	then Result:='�������� ���������� ���������� ������ � ������' else
  if Code='MEM_ERROR_CODE_12'	then Result:='�������� ���������� ���������� ������ � �����������' else
  if Code='MEM_ERROR_CODE_13'	then Result:='�������� ���������� ���������� ������ � ������ �����' else
  if Code='MEM_ERROR_CODE_14'	then Result:='�������� ������������������ ������� Z-������� ��� ���-��������� ������ �� ������' else
  if Code='MEM_ERROR_CODE_19'	then Result:='��������� ���������� ���������� ���������  ����������� ������ (����� �������� ���� � ��������� ������)' else
  if Code='MEM_ERROR_CODE_20'	then Result:='�������� ���������� ���������� ������ �� ��������� ����������� ������' else
  if Code='MEM_ERROR_CODE_21'	then Result:='��������� ������ ���������� ������ � ������� ������� � �����������' else
  if Code='MEM_ERROR_CODE_22'	then Result:='��������� ������ ���������� ������ � ������� ������� � �������' else
  if Code='MEM_ERROR_CODE_23'	then Result:='��������� ������ ���������� ������ � ������� ������� � ������ �����' else
  if Code='MEM_ERROR_CODE_25'	then Result:='��������� ������ ���������� ������ � ������� ������� � ������� ���������� �������' else
  if Code='MEM_ERROR_CODE_27'	then Result:='��������� ������� ���������� ������ � ��' else
  if Code='MEM_ERROR_CODE_28'	then Result:='����������� ����������������� ������ � ��' else

  { --- 	�������� ������ ����� ��������� �������  --- }
  if Code='RTC_ERROR_CODE_01'	then Result:='��������� ���� ��������� ������� �����������' else
  if Code='RTC_ERROR_CODE_02'	then Result:='���� ���������� Z-������, ����������� � ��, ������ ������� ���� � ��������� ����� ��������� �������' else
  if Code='RTC_ERROR_CODE_03'	then Result:='�������� ����� � ��������� ����� ��������� �������' else
  if Code='RTC_ERROR_CODE_04'	then Result:='�������� ���� � ��������� ����� ��������� �������' else
  if Code='RTC_ERROR_CODE_05'	then Result:='������������� ���������� ����� ��������� ������� ��� ������ ����� ���������-����'
                              else Result:=Code;
 end;

function TMarry301.GetCommName(S:String):String;
var i,q:Integer;
    B:Boolean;
 begin
  try
   if S='' then raise EAbort.Create('');
   B:=False; q:=0;
   for i:=Length(S) downto 1 do
    if S[i]=Chr(254) then begin q:=i; B:=True; Break; end;
   if Not (B) then EAbort.Create('');
   Result:=Copy(S,2,Ord(S[q-1])-1);
  except
   Result:='';
  end;
 end;

procedure TMarry301.ClearLog;
 begin
  if FLog<>nil then FLog.Clear;
 end;

function TMarry301.GetPortNum:Integer;
 begin
  try
   Result:=StrToInt(Copy(PortName,8,2));
  except
   Result:=0;
  end;
 end;

procedure TMarry301.SetPortNum(const Value:Integer);
 begin
  PortName:='\\.\COM'+IntToStr(Value);
 end;

procedure TMarry301.SetLog(const Value: TStrings);
 begin
  FLog:=Value;
 end;

procedure TMarry301.fpClosePort;
 begin
  Disconnect;
 end;

function TMarry301.fpGetStatus:Boolean;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
  SendCommand('CONF',True);
  Result:=SplitRes(FResComm,'10,10,36,8,6,1,1,1,4,1,12,12,4,4,8,18,8,1,3',FRD_Item);
{  if FRD_Item[1]='XXXXXXXXXX' then FRD_Item[1]:='0000000000';
  try
   if Length(Copy(FResComm,1,10))<>10 then Abort;
   FVzhNumS:=Copy(FResComm,1,10);
   FVzhNum:=StrToInt64(FVzhNumS);
   if FVzhNum<=0 then Abort;
  except
   Result:=False;
   FLastError:='ERP_9986';
  end;
}
 end;

function TMarry301.GetVzhNum:Int64;
 begin

  if Not UseEKKA then begin Result:=0; Exit; end;
  try
   if FVzhNum<=0 then
    begin
     SendCommand('CONF',True);
     if FLastError<>'' then Abort;
     if Not SplitRes(FResComm,'10,10,36,8,6,1,1,1,4,1,12,12,4,4,8,18,8,1,3',FRD_Item) then Abort;
     FVzhNumS:=Copy(FResComm,1,10);
     FVzhNum:=StrToInt64(FVzhNumS);
    end;
   if FVzhNum<=0 then Abort;
   Result:=FVzhNum;
  except
   Result:=0;
   if FLastError='' then FLastError:='ERP_9986';
  end;
 end;

function TMarry301.fpCashState(P:Integer):Boolean;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
  Result:=SendCommand('CCAS'+IntToStr(P),True);
  if Not Result then Exit;
  Result:=SplitRes(FResComm,'11,11,11,11,11,11,11,11',FRD_Item);
 end;

function TMarry301.fpSendCommand(var Comm:String):Boolean;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
  Result:=SendCommand(Comm,True);
  SplitRes(FResComm,GetCommParams(Copy(Comm,1,4)+FResComm),FRD_Item);
  Comm:=FResComm;
  if FLastError='ERP_9995' then begin FLastError:=''; Result:=True; end;
 end;

function TMarry301.SendStringMy(S:String):Boolean;
var i:Integer;
 begin
  try
   if Not (SendByte(253)) then Abort;
   if S<>'CON' then
    begin
     for i:=1 to Length(S) do  if Not (SendByte(CharToOem(S[i]))) then Abort;
     if Not (SendByte(Length(S)+1)) then Abort;
    end else begin
              if Not (SendByte(253)) then Abort;
              for i:=1 to 3 do if Not (SendByte(254)) then Abort;
             end;
   if Not (SendByte(254)) then Abort;
   Result:=True;
  except
   Result:=False;
  end;
 end;

function TMarry301.fpXRep:Boolean;
 begin
  Result:=SendCommand('ZREP',False);
 end;

function TMarry301.fpZRep:Boolean;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
  Result:=SendCommand('NREP',False);
  if Result then
   if fpGetStatus then
    if Ord(RD_Item[9][1])=1 then
     begin
      DeleteFile(FArtFile);
      Result:=True;
     end else begin
               FLastError:='ERP_9989';
               Result:=False;
              end;
 end;

function TMarry301.fpZeroCheck:Boolean;
 begin
  Result:=SendCommand('NULL',False);
 end;

function TMarry301.SplitRes(S,P:String; SL:TStrings):Boolean;
var A:TIntArray;
    i:Integer;
    ss:String;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
  try
   GetIntArray(P,A,[',']);
   SL.Text:='';
   for i:=Low(A) to High(A) do
    begin
     ss:=Copy(S,1,A[i]);
     if Length(ss)<>A[i] then Abort;
     SL.Add(ss);
     Delete(S,1,A[i]);
    end;
   Result:=True;
  except
   SL.Text:='';
   Result:=False;
   FLastError:='ERP_9995';
  end;
 end;

function TMarry301.fpPerFullRepD(D1,D2:TDateTime):Boolean;
 begin
  Result:=SendCommand('FIRP'+FormatDateTime('yyyymmdd',D1)+FormatDateTime('yyyymmdd',D2),False);
 end;

function TMarry301.fpPerFullRepN(N1,N2:Integer):Boolean;
 begin
  Result:=SendCommand('FIRN'+IntToStrF(N1,4)+IntToStrF(N2,4),False);
 end;

function TMarry301.fpPerShortRepD(D1,D2:TDateTime):Boolean;
 begin
  Result:=SendCommand('IREP'+FormatDateTime('yyyymmdd',D1)+FormatDateTime('yyyymmdd',D2),False);
 end;

function TMarry301.fpPerShortRepN(N1,N2:Integer):Boolean;
 begin
  Result:=SendCommand('IREN'+IntToStrF(N1,4)+IntToStrF(N2,4),False);
 end;

procedure TMarry301.SetKassir(Value:String);
 begin
  if Value='' then Value:='KASSIR';
  if Length(Value)=10 then Value:=Value+' ';
  FKassir:=Value;
 end;

function TMarry301.GetReceiptNumber:Integer;
var S:String;
 begin
  try
   if Not UseEKKA then Abort;
   if Not SendCommand('CONf',True) then Abort;
   S:=Copy(FResComm,91,12);
   if Length(S)<>12 then Abort;
   Result:=StrToInt(S);
  except
   Result:=-1;
  end;
 end;

function TMarry301.fpOpenFiscalReceipt(Param:Byte=1; NChek:Integer=0; ControlStrim:Byte=0):Boolean;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
  try
   FSumSales:=0;
   FSumVoids:=0;
   Result:=fpCancelFiscalReceipt;
   if Not Result then Exit;
   FLastNumCheck:=GetReceiptNumber;
   if FLastNumCheck=-1 then Abort;
   if Not Result then Abort;
//   Result:=SendCommand('PPMD1',False);
//   Result:=SendCommand('PPOD',False);
   Result:=SendCommand('PREP1',False);
  except
   FLastError:='ERP_9990';
   Result:=False;
  end;
 end;

function TMarry301.GetLastErrorDescr:String;
 begin
  Result:=ErrorDescr(FLastError);
 end;

function TMarry301.fpCashInput(C:Currency):Boolean;
 begin
  Result:=SendCommand('CAIOI'+CurrToStr2(C,10),False);
 end;

function TMarry301.fpCashOutput(C:Currency; P:Byte=0):Boolean;
 begin
  Result:=SendCommand('CAIOO'+CurrToStr2(C,10),False);
 end;

function TMarry301.fpSetTime(T:TDateTime):Boolean;
 begin
  Result:=SendCommand('CTIM'+FormatDateTime('hhnnss',T),False);
 end;

function TMarry301.IntToArt(N:Integer):String;
 begin
  if (N<10000) or (N>20688) then Result:=IntToStrF(N,4)
                            else Result:=Chr(StrToInt(Copy(IntToStr(N),1,2))+55)+IntToStrF(N,3);
 end;

function TMarry301.fpGetNewArt:String;
var IniF:TIniFile;
    Num:Integer;
 Begin
  try
   if Not (FUseEKKA) then Abort;
   IniF:=TIniFile.Create(FArtFile);
   try
    Num:=IniF.ReadInteger('EKKA','Articul',4)+1;
    Result:=IntToArt(Num);
    IniF.WriteInteger('EKKA','Articul',Num);
   finally
    IniF.Free;
   end;
  except
   Result:=IntToArt(0);
  end;
 End;

function TMarry301.fpAddSale(Name:String;
                             Kol:Integer;
                             Cena:Currency;
                             Divis:Byte;
                             Artic:Integer;
                             Nalog:Byte;
                             DiscSum:Currency;
                             DiscDescr:String
                            ):Boolean;

var S,Nm,Nm1,Sh:String;
    Pl:Char;
    SS,DS:String;
    K:Integer;
    IniF:TIniFile;
    Com,Art:String;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
  try
   Nm:=CopyStrF(Name,12);
   Nm1:=Copy(Name,13,31);
   SS:=CurrToStr2(Kol*Cena,9);
   if DiscSum<0 then Pl:='-' else
   if DiscSum>0 then Pl:='+' else Pl:='0';
   K:=StrToInt(Pl+'1')*1;
   DS:=CurrToStr2(Abs(DiscSum),9);
   Repeat
    if Artic=0 then Art:=fpGetNewArt else
    if Artic=99999 then Art:='1111'
                   else Art:=IntToArt(Artic);

    if Artic=99999 then
     begin
      Com:='BFIS';
      FSumVoids:=FSumVoids+StrToInt(SS)+K*StrToInt(DS)
     end else begin
               Com:='FISC';
               FSumSales:=FSumSales+StrToInt(SS)+K*StrToInt(DS);
              end;

    Case Nalog of
     1:Sh:='�02000'+'000000'+'000000';
     2:Sh:='000000'+'�00700'+'000000';
     3:Sh:='000000'+'000000'+'�00000' else Abort;
    end;
    if Not (Divis in [0,1]) then Abort;
    Sh:=Sh+'000000'+'000000'+'000000'+'000000'+'000000';
    S:=Com+
       Nm+
       SS+
       CurrToStr2(Cena,9)+
       IntToStrF(Kol,5)+
       IntToStrF(Divis,1)+
       Rnd+
       Sh+
       Art+
       Pl+
       CopyStrF(DiscDescr,13)+
       DS+
       Nm1;
    Result:=SendCommand(S,False);
    if Artic=99999 then Break;
    if (Artic=0) and (AnsiUpperCase(FLastError)<>'SOFTDIFART') then Break else
     try
      IniF:=TIniFile.Create(FArtFile);
      try
       IniF.WriteInteger('EKKA','Articul',IniF.ReadInteger('EKKA','Articul',4)+50);
      finally
       IniF.Free;
      end;
     except
     end;
   Until False;
  except
   Result:=False;
   FLastError:='ERP_9992';
  end;
 end;

function TMarry301.fpAddBack(Name:String;
                             Kol:Integer;
                             Cena:Currency;
                             Divis:Byte;
                             Artic:Integer;
                             Nalog:Byte;
                             DiscSum:Currency;
                             DiscDescr:String
                            ):Boolean;
 begin
  Result:=fpAddSale(Name,Kol,Cena,Divis,99999,Nalog,DiscSum,DiscDescr);
 end;

function TMarry301.fpCancelFiscalReceipt:Boolean;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
  Result:=SendCommand('CANC',False);
  if Not Result then Exit;
  Result:=fpGetStatus;
  if Not Result then Exit;
  if Ord(RD_Item[6][1])<>3 then Result:=False;
 end;

function TMarry301.fpCloseFiscalReceiptB(TakedSumm:Currency; TypeOplat:Integer; SumCheck:Currency=0):Boolean;
var S:String;
    TOpl,Sm:String;
    T:TDateTime;
    B:Boolean;
 begin
  Result:=True;
  if Not (FUseEKKA) then Exit;
  Result:=False;
  try
   if Round(TakedSumm*100)<FSumSales then TakedSumm:=FSumSales/100;
   if TypeOplat=4 then
    begin
     if FSumVoids>0 then Sm:=CurrToStr2(0,10) else Sm:=CurrToStr2(TakedSumm,10);
    end else Sm:=IntToStrF(Abs(FSumSales-FSumVoids),10);
   Case TypeOplat of
    1:TOpl:=Sm+'0000000000'+'0000000000'+'0000000000';
    2:TOpl:='0000000000'+Sm+'0000000000'+'0000000000';
    3:TOpl:='0000000000'+'0000000000'+Sm+'0000000000';
    4:TOpl:='0000000000'+'0000000000'+'0000000000'+Sm else AbortS('ERT_9992');
   end;
   if (LastError<>'') then Abort;
   S:='COMP'+
      IntToStrF(FSumSales,10)+
      IntToStrF(FSumVoids,10)+
      TOpl;
   fpServiceText(1,1,0,'�����: '+Kassir);
   if Not (SendCommand(S,False)) then
    begin
     ShowMessage(LastError);
     T:=Time;
     B:=False;
     Repeat
      if fpGetStatus then
       if Ord(RD_Item[6][1])=3 then begin B:=True; Break; end;
      if Abs(Time-T)*100000>=2 then Abort;
     Until False;
     if Not B then AbortS('ERP_9991');
//     ShowMessage(IntToSTr(GetReceiptNumber)+' - '+IntToSTr(FLastNumCheck));
     if GetReceiptNumber-FLastNumCheck=1 then Result:=True else AbortS('ERP_9991');
    end else Result:=True;
    SendCommand('CANC',False);
  except
   on E:Exception do
    begin
     Result:=False;
     T:=Time;
     Repeat
      SendCommand('CANC',False);
      if fpGetStatus then
       if Ord(RD_Item[6][1])=3 then Break;
      if Abs(Time-T)*100000>=2 then Break;
     Until False;
     if FLastError='' then FLastError:=E.Message;
     if FLastError='' then FLastError:='ERP_9999';
    end;
  end;
 end;


function TMarry301.fpCloseFiscalReceipt(TakedSumm:Currency; TypeOplat:Integer; SumCheck:Currency=0; SumB1:Currency=0; IsDnepr:Boolean=False; ControlStreem:Byte=0; RRN: longint = 1; BankCard: string='000000000000000'):Boolean;
var S:String;
    TOpl,Sm,Sm1:String;
    T:TDateTime;
    B:Boolean;
 begin
  Result:=True;
  if Not (FUseEKKA) then Exit;
  Result:=False;
  try
   if FSumVoids=0 then
    begin
     if Round(TakedSumm*100)<(FSumSales-SumB1*100) then TakedSumm:=(FSumSales-Round(SumB1*100))/100;
     if TakedSumm<0 then TakedSumm:=0;
    end else

   if FSumVoids=0 then
    if FSumSales-Round(SumB1*100)<0 then TypeOplat:=3;

   if TypeOplat=4 then
    begin
     if FSumVoids>0 then
      begin
       if SumB1>0 then Sm:=CurrToStr2(FSumVoids-Round(SumB1*100),10)
                  else Sm:=CurrToStr2(0,10);
      end else Sm:=CurrToStr2(TakedSumm,10);
    end else

   if (TypeOplat=2) and (SumB1>0) then Sm:=CurrToStr2(TakedSumm,10)
                                  else Sm:=IntToStrF(Abs(FSumSales-FSumVoids),10);

   Sm1:=CurrToStr2(SumB1,10);
   if IsDnepr=False then
    begin
//     ShowMessage(CurrToStr(SumB1)+' | '+IntToStr(TypeOplat)+' | False');
     Case TypeOplat of
      1:TOpl:=Sm+'0000000000'+'0000000000'+'0000000000';
      2:begin
         if SumB1>0 then
          TOpl:='0000000000'+Sm+Sm1+'0000000000'
         else
          TOpl:='0000000000'+Sm+'0000000000'+'0000000000'
        end;
      3:TOpl:='0000000000'+'0000000000'+Sm+'0000000000';
      4:TOpl:='0000000000'+'0000000000'+Sm1+Sm else AbortS('ERT_9992');
     end
    end
   else begin
//     ShowMessage(CurrToStr(SumB1)+' | '+IntToStr(TypeOplat)+' | True');
    Case TypeOplat of
     1:TOpl:=Sm+'0000000000'+'0000000000'+'0000000000';
     2:TOpl:=Sm1+Sm+'0000000000'+'0000000000';
     3:TOpl:='0000000000'+'0000000000'+Sm+'0000000000';
     4:TOpl:=Sm1+'0000000000'+'0000000000'+Sm else AbortS('ERT_9992');
    end; end;

//   ShowMessage(TOpl);
//   FLastError:='qqq';
   if (LastError<>'') then Abort;
   S:='COMP'+
      IntToStrF(FSumSales,10)+
      IntToStrF(FSumVoids,10)+
      TOpl;
   fpServiceText(1,1,0,'�����: '+Kassir);
   Result:=SendCommand(S,False);
{   if Not (SendCommand(S,False)) then
    begin
     T:=Time;
     B:=False;
     Repeat
      if fpGetStatus then
       if Ord(RD_Item[6][1])=3 then begin B:=True; Break; end;
      if Abs(Time-T)*100000>=2 then Abort;
     Until False;
     if Not B then AbortS('ERP_9991');
//     ShowMessage(IntToSTr(GetReceiptNumber)+' - '+IntToSTr(FLastNumCheck));
     if GetReceiptNumber-FLastNumCheck=1 then Result:=True else AbortS('ERP_9991');
    end else Result:=True;
 }
//    SendCommand('CANC',False);
  except
   on E:Exception do
    begin
     Result:=False;
   {  T:=Time;
     Repeat
      SendCommand('CANC',False);
      if fpGetStatus then
       if Ord(RD_Item[6][1])=3 then Break;
      if Abs(Time-T)*100000>=2 then Break;
     Until False;
    }
     if FLastError='' then FLastError:=E.Message;
     if FLastError='' then FLastError:='ERP_9999';
    end;
  end;
 end;

(*
function TMarry301.fpCloseFiscalReceipt(TakedSumm:Currency; TypeOplat:Integer; SumCheck:Currency=0; SumB1:Currency=0; IsDnepr:Boolean=False):Boolean;
var S:String;
    TOpl,Sm,Sm1:String;
    T:TDateTime;
    B:Boolean;
 begin
  Result:=True;
  if Not (FUseEKKA) then Exit;
  Result:=False;
  try
   if Round(TakedSumm*100)<(FSumSales-SumB1*100) then TakedSumm:=(FSumSales-Round(SumB1*100))/100;
   if TakedSumm<0 then TakedSumm:=0;

   if FSumSales-Round(SumB1*100)<0 then TypeOplat:=3;

   if TypeOplat=4 then
    begin
     if FSumVoids>0 then Sm:=CurrToStr2(0,10) else Sm:=CurrToStr2(TakedSumm,10);
    end else Sm:=IntToStrF(Abs(FSumSales-FSumVoids),10);

   Sm1:=CurrToStr2(SumB1,10);
   if IsDnepr=False then
    Case TypeOplat of
      1:TOpl:=Sm+'0000000000'+'0000000000'+'0000000000';
      2:TOpl:='0000000000'+Sm+'0000000000'+'0000000000';
      3:TOpl:='0000000000'+'0000000000'+Sm+'0000000000';
      4:TOpl:='0000000000'+'0000000000'+Sm1+Sm else AbortS('ERT_9992');
    end
   else
    Case TypeOplat of
     1:TOpl:=Sm+'0000000000'+'0000000000'+'0000000000';
     2:TOpl:='0000000000'+Sm+'0000000000'+'0000000000';
     3:TOpl:='0000000000'+'0000000000'+Sm+'0000000000';
     4:TOpl:=Sm1+'0000000000'+'0000000000'+Sm else AbortS('ERT_9992');
    end;

   if (LastError<>'') then Abort;
   S:='COMP'+
      IntToStrF(FSumSales,10)+
      IntToStrF(FSumVoids,10)+
      TOpl;
   fpServiceText(1,1,0,'�����: '+Kassir);
   Result:=SendCommand(S,False);

  except
   on E:Exception do
    begin
     Result:=False;
     if FLastError='' then FLastError:=E.Message;
     if FLastError='' then FLastError:='ERP_9999';
    end;
  end;
 end;
*)

function TMarry301.fpOpenCashBox:Boolean;
 begin
  Result:=SendCommand('KASS',False);
 end;

function TMarry301.fpServiceText(TextPos,Print2,FontHeight:Integer; S:String):Boolean;
var ss:String;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
  try
   if Not (TextPos in [0,1]) then Abort;
   if Not (Print2 in [0,1]) then Abort;
   if Not (FontHeight in [0..3]) then Abort;
   ss:='TEXT'+
      IntToStr(TextPos)+
      IntToStr(Print2)+
      IntToStr(FontHeight)+
      Copy(S,1,43);
   Result:=SendCommand(ss,False);
  except
   Result:=False;
   FLastError:='ERP_9992';
  end;
 end;

function TMarry301.fpSetBackReceipt(S:String):Boolean;
 begin
  Result:=SendCommand('BCHN'+Copy(S,1,86),False);
 end;

function TMarry301.fpLoadLogo(Logo:TBitMap; Active:Boolean): Boolean;
var i,j,k,dx,dy:Integer;
    ss,S:String;

 function GetPix(C:TColor):Char;
  begin
   if C>$808080 then Result:='0' else Result:='1';
  end;

 function GetHex(S:String):Char;
  begin
   if S='0000' then Result:='0' else
   if S='0001' then Result:='1' else
   if S='0010' then Result:='2' else
   if S='0011' then Result:='3' else
   if S='0100' then Result:='4' else
   if S='0101' then Result:='5' else
   if S='0110' then Result:='6' else
   if S='0111' then Result:='7' else
   if S='1000' then Result:='8' else
   if S='1001' then Result:='9' else
   if S='1010' then Result:='A' else
   if S='1011' then Result:='B' else
   if S='1100' then Result:='C' else
   if S='1101' then Result:='D' else
   if S='1110' then Result:='E' else
   if S='1111' then Result:='F' else Result:='0';
  end;

 Begin
  Result:=True;
  if Not UseEKKA then Exit;
  try
   if Logo=nil then Abort;
   if Logo.Height>192 then dy:=192 else dy:=Logo.Height;
   if Logo.Width>432 then dx:=432 else dx:=Logo.Width;
   for j:=0 to dy-1 do
    begin
     S:=''; for i:=1 to 108 do S:=S+'0';
     for i:=0 to (dx div 4)-1 do
      begin
       ss:='';
       for k:=0 to 3 do  ss:=ss+GetPix(Logo.Canvas.Pixels[4*i+k,j]);
       S[i]:=GetHex(ss);
      end;
     Result:=SendCommand('LUPC'+IntToStrF(j+1,3)+Copy(S,1,108),False);
     if Not Result then Exit;
    end;
   if Active then Result:=fpActiveLogo(dy)
             else Result:=fpActiveLogo(0);
  except
   FLastError:='ERP_9988';
   Result:=False;
  end;
 End;

function TMarry301.fpLoadLogo(Logo:String; Active:Boolean):Boolean;
var Bm:TBitMap;
 begin
  Result:=True;
  if Not UseEKKA then Exit;
  Result:=False;
  if Not (FileExists(Logo)) then FLastError:='���� � ����������� ������� �����������!' else
   try
    Bm:=TBitMap.Create;
    try
     Bm.LoadFromFile(Logo);
     Result:=fpLoadLogo(Bm,Active);
    finally
     Bm.Free;
    end;
   except
    FLastError:='ERP_9988';
   end;
 end;

function TMarry301.fpActiveLogo(P:Byte):Boolean;
 begin
  if P>192 then P:=192;
  Result:=SendCommand('AUPC'+IntToStrF(P,3),False);
 end;

function TMarry301.fpCutBeep(C,B,N:Byte):Boolean;
 begin
  if Not ((C in [0,1]) or (B in [0,1]) or (N in [0,1])) then
   begin
    FLastError:='ERP_9992';
    Result:=False;
   end else Result:=SendCommand('CUTR'+IntToStrF(C,1)+IntToStrF(B,1)+IntToStrF(N,1),True);
 end;

function TMarry301.fpCutBeep(C,B:Byte):Boolean;
 begin
  if Not ((C in [0,1]) or (B in [0,1])) then
   begin
    FLastError:='ERP_9992';
    Result:=False
   end else Result:=SendCommand('CUTR'+IntToStrF(C,1)+IntToStrF(B,1),True);
 end;

function TMarry301.fpSetHead(S:String):Boolean;
 begin
  Result:=SendCommand('HEAD'+CenterStr(Copy(S,1,43),43),false);
 end;

function TMarry301.fpFiscState:Boolean;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
  Result:=SendCommand('CFIS',True);
  if Not Result then Exit;
  Result:=SplitRes(FResComm,'12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12',FRD_Item);
 end;

function TMarry301.fpServPassw(P1:String; P2:String=''):Boolean;
 begin
  Result:=SendCommand('SPAS'+P1+P2,True);
 end;

function TMarry301.fpDayLimit(D:Integer):Boolean;
 begin
  Result:=SendCommand('DLIM'+IntToStr(D),False);
 end;

function TMarry301.fpPrintLimit(P:Integer):Boolean;
 begin
  Result:=SendCommand('PLIM'+IntToStr(P),False);
 end;

function TMarry301.fpGetLimitStatus:Boolean;
 begin
  Result:=SendCommand('CRES',True);
  if Not Result then Exit;
  Result:=SplitRes(FResComm,'10,10,10,10',FRD_Item);
 end;

function TMarry301.fpResetUsPassw: Boolean;
 begin
  Result:=SendCommand('cusp',False);
 end;

function TMarry301.GetCommParams(S:String):String;
 begin
  Result:=Copy(S,5,Length(S)-4);
  S:=Copy(S,1,4);
  if S='CRES' then Result:='10,10,10,10' else
  if (S='CONF') or (S='CONf') then Result:='10,10,36,8,6,1,1,1,4,1,12,12,4,4,8,18,8,1,3' else
  if S='CCAS' then Result:='11,11,11,11,11,11,11,11' else
  if S='CFIS' then Result:='12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12';
 end;

function TMarry301.fpCheckCopy(Cnt:Byte=1; NChForce:Integer=0):Boolean;
 begin
  Result:=SendCommand('COPY',False);
 end;

function TMarry301.KeyPosition(Key:Byte):Boolean;
 begin
  try
   if Not UseEKKA then begin Result:=True; Exit; end;
   if Not fpGetStatus then Abort;
   Result:=Key=Ord(RD_Item[5][1]);
  except
   Result:=False;
  end;
 end;

function TMarry301.fpCurrToDisp(S:Currency):Boolean;
var ss,s1:String[10];
    q1,P,q,i,N:Integer;
 begin
  ss:=CurrToStr(S);
  P:=0; q:=0; s1:='          '; q1:=10;
  for i:=Length(ss) downto 1 do
   begin
    Inc(q);
    if ss[i]='.' then P:=q else
     begin
      s1[q1]:=ss[i];
      Dec(q1);
     end;
    if q=10 then Break;
   end;
  Result:=True;//SendCommand('DISp0'+IntToStr(P)[1]+s1,False);
 end;

function TMarry301.fpDiscRep: Boolean;
 begin
  Result:=SendCommand('DIZV',False);
 end;

function TMarry301.fpStrToDisp(S:String):Boolean;
 begin
  Result:=True;//SendCommand('DISp'+S,False);
 end;

function TMarry301.fpAddFinStr(S:String):Boolean;
 begin
  Result:=SendCommand('FINF'+Copy(S,1,86),False);
 end;

function TMarry301.fpSetBottomStr(S:String):Boolean;
 begin
  Result:=SendCommand('BOTM'+Copy(S,1,43),False);
 end;

function TMarry301.fpSetBottomStrEx(S:String; N,P,W:Byte):Boolean;
 begin
  if N>9 then N:=9;
  if P>1 then P:=1;
  if W>1 then W:=1;
  Result:=SendCommand('BOTm'+IntToStr(N)+IntToStr(P)+IntToStr(W)+Copy(S,1,43),False);
 end;

function TMarry301.fpSetINSP(FN,ID,PN,Str1,Str2,Str3,Str4:String):Boolean;
var S:String;
 begin
  S:='INSP'+CopyStrF(FN,10)+CopyStrF(ID,10)+CopyStrF(PN,12)+
            CenterStr(Str1,42)+CenterStr(Str2,42)+CenterStr(Str3,42)+CenterStr(Str4,42);
  Result:=SendCommand(S,False);
 end;

function TMarry301.GetServiceNumber:Integer;
var S:String;
 begin
  try
   if Not UseEKKA then Abort;
   if Not SendCommand('GLCN',True) then Abort;
   S:=Copy(FResComm,11,10);
   if Length(S)<>10 then Abort;
   Result:=StrToInt(S);
  except
   Result:=-1;
  end;
 end;

function TMarry301.fpOpenServiceReceipt:Boolean;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
  try
   FSumSales:=0;
   FSumVoids:=0;
   Result:=fpClearServiceText;
   Result:=fpCancelServiceReceipt;
   if Not Result then Exit;
   FLastNumCheck:=GetServiceNumber;
   if FLastNumCheck=-1 then Abort;
   if Not Result then Abort;
   Result:=SendCommand('DBEG1',False);
  except
   FLastError:='ERP_9987';
   Result:=False;
  end;
 end;

function TMarry301.fpClearServiceText:Boolean;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
  Result:=SendCommand('CTXT',False);
 end;

function TMarry301.fpCancelServiceReceipt:Boolean;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
  Result:=SendCommand('CANC',False);
 end;

function TMarry301.fpCloseServiceReceipt:Boolean;
 begin
  if Not (FUseEKKA) then begin Result:=True; Exit; end;
  Result:=SendCommand('PRTX',False);
 end;

procedure TMarry301.SetLogFile(const Value:String);
 begin
  FLogFile:=Value;
  if (FLogFile<>'') and (FileExists(FLogFile)=True) then
   if FLog<>nil then
    FLog.LoadFromFile(FLogFile);
 end;

Initialization

 SetLength(Arr,0);

Finalization

 if FMarry301<>nil then FMarry301.Free;

END.



