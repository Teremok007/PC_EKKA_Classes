Unit IndicatorU;

Interface

Uses Windows, Dialogs, Messages, Classes, SysUtils, Util, D2XXUNIT;

Type TIndicator=class;

     TThIndic=class(TThread)
     private

       FParent:TIndicator;
       FArrStr:TStringList;
       FEndTh:Boolean;
       FIsEnd:Boolean;

     protected

       procedure Execute; override;

     public

       constructor Create(CreateSuspended:Boolean); virtual;
       destructor Destroy; override;

       property Parent:TIndicator read FParent write FParent;
       property ArrStr:TStringList read FArrStr write FArrStr;
       property EndTh:Boolean read FEndTh write FEndTh;
       property IsEnd:Boolean read FIsEnd write FIsEnd;

     end;

     TIndicator=class
     private

       FTh:TThIndic;
       FUseIndicator:Boolean;
       FAsynchron:Boolean;

       procedure SetUseIndicator(const Value:Boolean);
       procedure SetAsynchron(const Value:Boolean);
       procedure AddCommand(S:String);

       function SendCommand(S:String):Boolean;
       function SendStr(S:String):Integer;

     public

       constructor Create; virtual;
       destructor Destroy; override;

       procedure ClearBuffer;                        // Очистка буфера очереди

       { --- Выполнение комманд в потоке --- }
       procedure inClearScreen;                      // Очистка всего экрана
       procedure inClearString(N:Integer);           // Очистка одной из строк экрана
       procedure inShowString(N:Integer; S:String);  // Вывод строки в область экрана
       procedure inSetBrightness(V:Byte);            // Установить яркость подсветки экрана

       function  inSendCommand(S:String):Boolean;    // Выполнение произвольной команды

       property UseIndicator:Boolean read FUseIndicator write SetUseIndicator;
       property Asynchron:Boolean read FAsynchron write SetAsynchron;

     end;

Function Indicator:TIndicator;

Implementation

Var FIndicator:TIndicator=nil;

Function Indicator:TIndicator;
 begin
  if FIndicator=nil then FIndicator:=TIndicator.Create;
  Result:=FIndicator;
 end;

{ TIndicator }

constructor TIndicator.Create;
 begin

  FUseIndicator:=False;
  FTh:=TThIndic.Create(True);
  FTh.Parent:=Self;
  FAsynchron:=False;
  Asynchron:=True;
 end;

function TIndicator.SendStr(S:String):Integer; //Возвращает число отправленных байт
var i:Integer;
 begin
  for i:=1 to Length(S) do
   FT_Out_Buffer[i-1]:=Ord(S[i]);
  Result:=Write_USB_Device_Buffer(Length(S));
 end;

function TIndicator.SendCommand(S:String):Boolean;
 begin
  try
   FT_Current_Baud:=FT_BAUD_9600;
   FT_Current_DataBits:=FT_DATA_BITS_8;
   FT_Current_StopBits:=FT_STOP_BITS_1;
   FT_Current_Parity:=FT_PARITY_NONE;
   FT_Current_FlowControl:=FT_FLOW_NONE;
   FT_RTS_On:=False;
   FT_DTR_On:=False;
   FT_Event_On:=False;
   FT_Error_On:=False;
   S:=#1+Chr(Length(S)+3)+S+#2;
   GetFTDeviceDescription(0);
   if Open_USB_Device=FT_OK then
    begin
     try
      Set_USB_Device_BaudRate;
      Set_USB_Device_DataCharacteristics;
      Set_USB_Device_FlowControl;
      Set_USB_Device_TimeOuts(150,150);
      Clr_USB_Device_RTS;
      Clr_USB_Device_DTR;
      SendStr(S);
     finally
      Close_USB_Device;
     end; 
    end else Abort;
   Result:=True;
  except
   Result:=False;
  end;
 end;

function TIndicator.inSendCommand(S:String):Boolean;
 begin
  Result:=True;
  if Not UseIndicator then Exit;
  Result:=SendCommand(S);
 end;

procedure TIndicator.inClearScreen;
 begin
  AddCommand(#$63);
 end;

procedure TIndicator.inClearString(N:Integer);
 begin
  if N<1 then N:=1 else if N>4 then N:=4;
  AddCommand(#$43+Chr($31+N-1));
 end;

procedure TIndicator.inShowString(N:Integer; S:String);
 begin
  if N<1 then N:=1 else if N>4 then N:=4;
  S:=S+'                                        ';
  AddCommand(Chr(83)+Chr(49+N-1)+Copy(S,1,20));
 end;

procedure TIndicator.inSetBrightness(V:Byte);
 begin
  AddCommand(#$4C+Chr(V));
 end;

destructor TIndicator.Destroy;
//var T:TDateTime;
 begin
  Halt;
  FTh.ArrStr.Clear;
  FTh.EndTh:=True;
  if Not FTh.IsEnd then Halt;
{  T:=Time;
  Repeat
   if FTh.IsEnd then Break else
   if Abs(Time-T)*100000>=2 then
    begin
     TerminateThread(FTh.Handle,0);
     Break;
    end;
  Until False;
}  FAsynchron:=False;
  SendCommand(#$63);
  SendCommand(#$4C+Chr(0));
  inherited;
 end;

procedure TIndicator.SetUseIndicator(const Value:Boolean);
 begin
  FUseIndicator:=Value;
  if Value=False then FTh.Suspend
                 else begin
                       FTh.Resume;
                       inClearScreen;
                       inSetBrightness(0);
                      end;
 end;

procedure TIndicator.SetAsynchron(const Value:Boolean);
 begin
  FAsynchron:=Value;
  if Not Value then FTh.Suspend else
  if UseIndicator then FTh.Resume;
 end;

procedure TIndicator.ClearBuffer;
 begin
  FTh.ArrStr.Clear;
  inClearScreen;
  inClearScreen;
 end;

procedure TIndicator.AddCommand(S:String);
 begin
  if Not UseIndicator then Exit;
  if FAsynchron then
   begin
    FTh.ArrStr.Add(S);
    FTh.Resume;
   end else inSendCommand(S);
 end;

{ TThIndic }

constructor TThIndic.Create(CreateSuspended: Boolean);
 begin
  inherited Create(CreateSuspended);
  FEndTh:=False;
  FIsEnd:=True;
  FArrStr:=TStringList.Create;
  FParent:=nil;
 end;

destructor TThIndic.Destroy;
 begin
  FArrStr.Free;
  inherited;
 end;

procedure TThIndic.Execute;
 begin
  FreeOnTerminate:=True;
  FIsEnd:=False;
  try
   Repeat
    if FArrStr.Text<>'' then
     begin
      if FParent<>nil then
       FParent.inSendCommand(FArrStr[0]);
       if FArrStr.Text<>'' then FArrStr.Delete(0);
       Delay(0.03);
     end else
    if EndTh then Break else Suspend;
   Until False;
  finally
   FIsEnd:=True;
  end;
 end;

Initialization

Finalization
 if FIndicator<>nil then FIndicator.Free;

End.