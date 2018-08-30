Unit IndicatorU;

Interface

Uses Windows, Dialogs, Messages, Classes, SysUtils, Util, ComU;

Type
     TIndicator=class;

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

     TIndicator=class(TComPort)
     private

       FTh:TThIndic;
       FCt:TCommTimeouts;
       FPortNumber:Integer;
       FUseIndicator:Boolean;
       FAsynchron:Boolean;

       procedure SetUseIndicator(const Value:Boolean);
       procedure SetAsynchron(const Value:Boolean);
       procedure AddCommand(S:String);

       function Connect:Boolean;
       function SendCommand(S:String):Boolean;

     public

       constructor Create; override;
       destructor Destroy; override;

       procedure ClearBuffer;                               // Очистка буфера очереди

       { --- Выполнение комманд в потоке --- }
       procedure inClearScreen;                      // Очистка всего экрана
       procedure inClearString(N:Integer);           // Очистка одной из строк экрана
       procedure inShowString(N:Integer; S:String);  // Вывод строки в область экрана
       procedure inSetBrightness(V:Byte);            // Установить яркость подсветки экрана

       function  inSendCommand(S:String):Boolean;    // Выполнение произвольной команды

       property PortNumber:Integer read FPortNumber write FPortNumber;
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
  inherited;
  FPortNumber:=2;
  FUseIndicator:=False;
  FCt.ReadIntervalTimeout:=500;
  FTh:=TThIndic.Create(True);
  FTh.Parent:=Self;
  FAsynchron:=False;
  Asynchron:=True;
 end;

function TIndicator.SendCommand(S:String):Boolean;
var B:Array[1..255] of Byte;
    i:Integer;
 begin
  try
   S:=#1+Chr(Length(S)+3)+S+#$2;
   for i:=1 to Length(S) do B[i]:=Ord(S[i]);
   SendCom(B,Length(S));
   ReceiveCom(B,1);
   Result:=B[1]=6;
  except
   Result:=False;
  end;
 end;

function TIndicator.Connect:Boolean;
var Pn,i:Integer;
    B:Boolean;
 begin
  Result:=True;
  if IsConnect then
   if SendCommand(#112+#33) then Exit;
  try
   CloseCom;
   B:=False;
   for i:=1 to 32 do
    begin
     if i=1 then Pn:=FPortNumber else Pn:=i;
     if Not InitCom(9600,Pn,#1,FCt) then Continue;
     ClearInputCom;
     if SendCommand(#112+#33) then
      begin
       B:=True;
       FPortNumber:=Pn;
       Break;
      end;
    end;
   Result:=B;
  except
   Result:=False;
  end;
 end;

function TIndicator.inSendCommand(S:String):Boolean;
 begin
  Result:=True;
  if Not UseIndicator then Exit;
  Result:=Connect;
  if Not Connect then Exit;
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
  AddCommand(#$53+Chr($31+N-1)+Copy(S,1,21));
 end;

procedure TIndicator.inSetBrightness(V:Byte);
 begin
  AddCommand(#$4C+Chr(V));
 end;

destructor TIndicator.Destroy;
var T:TDateTime;
 begin
  FTh.ArrStr.Clear;
  FTh.EndTh:=True;
  T:=Time;
  inClearScreen;
  inSetBrightness(0);
  Repeat
   if FTh.IsEnd then Break else
   if Abs(Time-T)*100000>=2 then
    begin
     TerminateThread(FTh.Handle,0);
     Break;
    end;
  Until False;
  FAsynchron:=False;
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
    if FArrStr.Count>0 then
     begin
      if FParent<>nil then
       FParent.inSendCommand(FArrStr[0]);
       FArrStr.Delete(0);
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