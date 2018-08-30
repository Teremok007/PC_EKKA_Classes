Unit ComU;

interface

uses Windows;

type  TComPort=class
      private

        hFile:THandle;

        function GetIsConnect:Boolean;

      public

        constructor Create; virtual;
        destructor Destroy; override;

        procedure CloseCom;

        function InitCom(BaudRate,PortNo:Integer; Parity:Char; CommTimeOuts:TCommTimeouts):Boolean;
        function ReceiveCom(var Buffer; Size:DWORD):Integer;
        function SendCom(var Buffer; Size:DWORD):Integer;
        function ClearInputCom:Boolean;

        property IsConnect:Boolean read GetIsConnect;
        
      end;

implementation

uses SysUtils;

constructor TComPort.Create;
 begin
  inherited;
  CloseCom;
 end;

destructor TComPort.Destroy;
 begin
  CloseCom;
  inherited;
 end;

function TComPort.InitCom(BaudRate,PortNo:Integer; Parity:Char; CommTimeOuts:TCommTimeouts):Boolean;
var FileName:String;
    DCB:TDCB;
 begin
  Result:=False;
  FileName:='Com'+IntToStr(PortNo); {имя файла}
  hFile:=CreateFile(PChar(FileName),GENERIC_READ or GENERIC_WRITE,0,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  if hFile=INVALID_HANDLE_VALUE then Exit;
  //Установка требуемых параметров
  GetCommState(hFile,DCB);

  //Чтение текущих параметров порта
  DCB.BaudRate:=CBR_9600;
  DCB.Parity:=NOPARITY;
  DCB.StopBits:=ONESTOPBIT;
  DCB.ByteSize:=8;
  DCB.XonChar:=chr(17);
  DCB.XoffChar:=chr(19);
  DCB.ErrorChar:=chr(0);
  DCB.EofChar:=chr(0);
  DCB.EvtChar:=chr(0);
  DCB.XonLim:=1024;
  DCB.XoffLim:=1024;
  Result:=SetCommState(hFile,DCB); // and SetCommTimeouts(hFile, CommTimeOuts);
  if Not Result then CloseCom;
 end;

procedure TComPort.CloseCom;
 begin
  if hFile<>INVALID_HANDLE_VALUE then CloseHandle(hFile);
  hFile:=INVALID_HANDLE_VALUE;
 end;

function TComPort.ReceiveCom(var Buffer; Size:DWORD):Integer;
var Received:DWORD;
 begin
  if hFile=INVALID_HANDLE_VALUE then
   raise Exception.Create('Не открыта запись в Com порт');
   if ReadFile(hFile,Buffer,Size,Received,nil) then
    begin
     Result:=Received;
    end else raise Exception.Create('Ошибка приема данных: ' + IntToStr(GetLastError));
 end;

function TComPort.SendCom(var Buffer; Size:DWORD):Integer;
var Sended:DWORD;
 begin
  if hFile=INVALID_HANDLE_VALUE then raise Exception.Create('Не открыта запись в Com порт');
 if WriteFile(hFile,Buffer,Size,Sended,nil) then
  begin
   Result:=Sended;
  end else raise Exception.Create('Ошибка передачи данных: ' + IntToStr(GetLastError));
 end;

function TComPort.ClearInputCom: Boolean;
 begin
  if hFile=INVALID_HANDLE_VALUE then raise Exception.Create('Не открыта запись в Com порт');
  Result:=PurgeComm(hFile,PURGE_RXCLEAR);
 end;

function TComPort.GetIsConnect: Boolean;
 begin
  Result:=Not (hFile=INVALID_HANDLE_VALUE);
 end;

End.