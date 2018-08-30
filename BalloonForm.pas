unit BalloonForm;

interface

uses
  Windows, Messages, SysUtils, Classes, {Variants,} Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, OleCtrls, ShellAPI, ComObj, ActiveX,
  BlnOptionButton, BlnSpeedButton, BlnCheckBox, BlnTypesConst,
  jpeg, math, AgentObjects_TLB;

const
 {
  0---1
    - 2
 }
 BLN_WidthArrow: integer = 18;  //Длинна указателя
 BLN_HeightArrow: integer = 10; //Высота указателя
 BLN_Round: integer = 13; //Радиус закругления уголв
 BLN_TopArrowSpacing: integer = 24; //Отсутп от верха окна, когда указатель должен быть сбоку
 BLN_ArrowSpacing: integer = 4; //РАсстояние между указателем и обещктом указывания
 BLN_HozMargen: integer = 64; //РАсборос по горизонтали, насолько может перемещатсяь указатель,
                              //когда он должен показываться внизу.
type
  TBlnLabel = class(TLabel)
    procedure MouseDownW(var Message: TMessage); message WM_LBUTTONDOWN;
  end;

  TBlnImage = class(TImage)
    procedure MouseDownW(var Message: TMessage); message WM_LBUTTONDOWN;
  end;

  TBlnPaintBox = class(TPaintBox)
    procedure MouseDownW(var Message: TMessage); message WM_LBUTTONDOWN;
  end;

  TBalloonForm = class(TForm)
    constructor CreateNew(AOwner: TComponent; ABlnEffects: TShowEffect); reintroduce;
    destructor Destroy; override;
  private
    FOnFrmBlnOptionClick: TBalloonOnFrmBlnOptionClick;
    FOnFrmBlnButtonClick: TBalloonOnFrmBlnButtonClick;
    FOnFrmBlnTBoxKeyPress: TBalloonOnFrmBlnTBoxKeyPress;
    FOnNotiBlnOptionClick: TBalloonOnNotiBlnOptionClick;
    FOnNotiBlnButtonClick: TBalloonOnNotiBlnButtonClick;
    FOnNotiBlnTBoxKeyPress: TBalloonOnNotiBlnTBoxKeyPress;
    FOnSuggestClick: TBalloonOnSuggestClick;
    FOnTipClose: TBalloonOnTipClose;
    FOnNotifyClick: TBalloonOnNotifyClick;

    FEffects: TShowEffect; {0 - none, 1 - in, 2 - out, 3 - InOut, 4 - flash }
    FlashCount: byte;
    FBackImage: string;
    FInputBoxResult: string;
    FCheckBoxResult: Boolean;
    FShowBgImage: boolean;
    BgImage: TBlnImage;
    BgPaintBox: TBlnPaintBox;
    FBorderColor: TColor;
    FLineColor: TColor;
    TimerIn: TTimer;
    TimerOut: TTimer;
    TimerChar: TTimer;
    TimerClose: TTimer;
    function GetBackgroundImage: TPicture;
    procedure SetBackgroundImage(Value: TPicture);
    function GetImageStretch: Boolean;
    procedure SetImageStretch(Value: Boolean);
    procedure SetBackImage(Value: string);
    procedure SetShowBgImage(Value: Boolean);
    function GetAutoClose(): boolean;
    procedure SetAutoClose(Value: boolean);
    function GetIntervalClose(): integer;
    procedure SetIntervalClose(Value: integer);
    procedure DrawBackGround();
    procedure FindIncScreen(); //Определяем отступы от TaskBar и ложит в IncScreenRect
  protected
    
    ArrowPoints: array[0..2] of TPoint;
    RArrowPoints: array[0..2] of TPoint;
    CtrlMoved: Boolean; //КОнтролы перемещались, из-за вырезки формы(чтобы повторно не смещать)
    IncScreenRect: TRect; //С каких боков че нужно учитывать TaskBar
    RegionCut: TRect; //регион по которому будет вырезка(обозначаются толкьо отсутупы со сторон)
    Orient: byte; {Где распологать баллон 0 - top, 1 - left, 2 - right}
    NotifyOrient: TNotifyOrientation;
    CChar: IAgentCtlCharacterEx;
    SChar: IAgentCharacterEx;
    OldRectChar: TRect;
    fSaveModalResult: Integer;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure ShowFormW(var Message: TMessage); message WM_SHOWWINDOW; //WM_NCACTIVATE;
    procedure PaintW(var Message: TMessage); message WM_PAINT;
    procedure MouseDownW(var Message: TMessage); message WM_LBUTTONDOWN;
    procedure SysCmdW(var Message: TMessage); message WM_SysCommand;
    procedure OnTimerIn(Sender: TObject);
    procedure OnTimerOut(Sender: TObject);
    procedure OnTimerChar(Sender: TObject);
    procedure OnTimerClose(Sender: TObject);
    function BitmapToRegion(Bitmap: TBitmap; TransColor: TColor): HRGN;
    procedure UpdateArrow();
  public
    //HReg: THandle;
    CanUserMove: Boolean; //МОжно ли перемещать
    ShowLine: Boolean; //Прорисовывать линию
    CloseOnClick: Boolean; //Закрывать окно по щелчку на закрывающей кнопке
    CloseOnPressEnterInTextBox: Boolean; //Закрываться при нажатии Enter в TextBox
    BlnType: TBalloonType;
    CoordLine: TRect; //Коориднаты лини-разделителя
    dx, dy: Integer; //Смещение по ося от персонажа(поминимо констант)
    fID: Integer; //Идентицикационный номер шарика, используется в Tip, Notify и FOrmBln
    OnBlnClose: TBlnClose; //Адрес метода котоный ножно запустить у TDlgBalloon
    procedure PointingNotify(aPoint: TPoint; NotifyOrient: TNotifyOrientation); //Позиционироывание около
                      //точик для NotifyBalloon. Тоже не следить за персонажем.
    procedure PointingOn(aRect: TRect); //Расичтывает отображение стрелки в шарике и расположение
                     //шарика и позиционирует его. Если его вызвать, то шарик не буедт следить за Agent'ом
    procedure AssignToCharacter(aCChar: IAgentCtlCharacterEx; aSChar: IAgentCharacterEx);//связывает шарик
                         //с пероснажем, чтобы потому автоматически перемещаться за ним
                         //Если вызывается этот метод, то вызывать PointingOn не нужно.
    function CloseQuery: Boolean; override; //Переделываем закрытие окна, чтобы делать постепенно изчезновение
    procedure HelpButtonClick(Sender: TObject);
    procedure OnOptionClick(Sender: TObject); //Клик по OptionButton
    procedure OnButtonClick(Sender: TObject); //клик по SpeedButton в FormBalloon
    procedure OnEditChange(Sender: TObject); //Изменение в поле редактирования в InputBox
    procedure OnEditKeyPress(Sender: TObject; var Key: Char); //Обработка нажатия клавиши, для Enter,
                     //чтоыб автоматически закрывался InputBox
    procedure OnCheckBoxClick(Sender: TObject); //Щелчок по CheckBox
    procedure OnTipBtnClick(Sender: TObject); //Клик по Tip баллону, чтобы он закрылся.
    procedure OnNotifyBtnClick(Sender: TObject); //Клик по Notify баллону, чтобы он закрылся.
    procedure OnSuggestBtnClick(Sender: TObject); //Клик по Suggest баллону, чтобы он закрылся.
    procedure OnCloseForm(Sender: TObject; var Action: TCloseAction);
    property InputBoxResult: string read FInputBoxResult;
    property CheckBoxResult: Boolean read FCheckBoxResult;
  published
    property BackgroundImage: TPicture read GetBackgroundImage write SetBackgroundImage;
    property BackImage: string read FBackImage write SetBackImage;
    property ShowBgImage: boolean read FShowBgImage write SetShowBgImage;
    property ImageStretch: boolean read GetImageStretch write SetImageStretch;
    property BorderColor: TColor read FBorderColor write FBorderColor default clBlack;
    property LineColor: TColor read FLineColor write FLineColor default $00E0E0E0;
    property AutoClose: Boolean read GetAutoClose write SetAutoClose;
    property IntervalClose: Integer read GetIntervalClose write SetIntervalClose;
    property OnFrmBlnOptionClick: TBalloonOnFrmBlnOptionClick read FOnFrmBlnOptionClick write FOnFrmBlnOptionClick;
    property OnFrmBlnButtonClick: TBalloonOnFrmBlnButtonClick read FOnFrmBlnButtonClick write FOnFrmBlnButtonClick;
    property OnNotiBlnOptionClick: TBalloonOnNotiBlnOptionClick read FOnNotiBlnOptionClick write FOnNotiBlnOptionClick;
    property OnNotiBlnButtonClick: TBalloonOnNotiBlnButtonClick read FOnNotiBlnButtonClick write FOnNotiBlnButtonClick;
    property OnFrmBlnTBoxKeyPress: TBalloonOnFrmBlnTBoxKeyPress read FOnFrmBlnTBoxKeyPress write FOnFrmBlnTBoxKeyPress;
    property OnNotiBlnTBoxKeyPress: TBalloonOnNotiBlnTBoxKeyPress read FOnNotiBlnTBoxKeyPress write FOnNotiBlnTBoxKeyPress;
    property OnSuggestClick: TBalloonOnSuggestClick read FOnSuggestClick write FOnSuggestClick;
    property OnTipClose: TBalloonOnTipClose read FOnTipClose write FOnTipClose;
    property OnNotifyClick: TBalloonOnNotifyClick read FOnNotifyClick write FOnNotifyClick;
  end;


implementation

uses Types;

const
 SC_DragMove = $F012;

////////////////////////////////////////////////////
{TBlnLabel}

procedure TBlnLabel.MouseDownW(var Message: TMessage);
begin
  ReleaseCapture;
  if Self.Parent<>nil then
   Self.Parent.Perform(WM_SysCommand, SC_DragMove, 0);
end;

////////////////////////////////////////////////////
{TBlnImage}

procedure TBlnImage.MouseDownW(var Message: TMessage);
begin
  ReleaseCapture;
  if Self.Parent<>nil then
   Self.Parent.Perform(WM_SysCommand, SC_DragMove, 0);
end;

////////////////////////////////////////////////////
{TBlnPaintBox}

procedure TBlnPaintBox.MouseDownW(var Message: TMessage);
begin
  ReleaseCapture;
  if Self.Parent<>nil then
   Self.Parent.Perform(WM_SysCommand, SC_DragMove, 0);
end;

///////////////////////////////////////////////////////
{TBalloonForm}

procedure TBalloonForm.DrawBackGround();
begin
 if Self.BlnType=btSuggest then
  Exit;
 BgPaintBox.Canvas.Pen.Mode:=pmCopy;
 BgPaintBox.Canvas.Pen.Color:=Self.BorderColor;
 BgPaintBox.Canvas.Brush.Color:=Self.Color;
 BgPaintBox.Canvas.Brush.Style:=bsClear;
 BgPaintBox.Canvas.RoundRect(RegionCut.Left, RegionCut.Top,
     RegionCut.Right, RegionCut.Bottom, BLN_Round+1, BLN_Round+1);

 BgPaintBox.Canvas.MoveTo(RArrowPoints[1].x, RArrowPoints[1].y);
 BgPaintBox.Canvas.LineTo(RArrowPoints[0].x, RArrowPoints[0].y);
 BgPaintBox.Canvas.LineTo(RArrowPoints[2].x, RArrowPoints[2].y);
 if Orient = 0 then
  begin
   BgPaintBox.Canvas.MoveTo(RArrowPoints[2].x, RArrowPoints[2].y);
   BgPaintBox.Canvas.LineTo(RArrowPoints[0].x, RArrowPoints[0].y);
  end;
 if NotifyOrient = noLeftDown then
  begin
   BgPaintBox.Canvas.MoveTo(RArrowPoints[2].x+1, RArrowPoints[2].y);
   BgPaintBox.Canvas.LineTo(RArrowPoints[0].x, RArrowPoints[0].y+1);
  end;
 if NotifyOrient = noLeftUp then
  begin
   BgPaintBox.Canvas.MoveTo(RArrowPoints[2].x, RArrowPoints[2].y-1);
   BgPaintBox.Canvas.LineTo(RArrowPoints[0].x+1, RArrowPoints[0].y);
  end;

 BgPaintBox.Canvas.Pen.Color:=Self.Color;
 BgPaintBox.Canvas.MoveTo(RArrowPoints[1].x, RArrowPoints[1].y);
 BgPaintBox.Canvas.LineTo(RArrowPoints[2].x, RArrowPoints[2].y);

 if ShowLine then
  begin
   BgPaintBox.Canvas.Pen.Color:=Self.LineColor;
   BgPaintBox.Canvas.MoveTo(Self.CoordLine.TopLeft.X, Self.CoordLine.TopLeft.Y);
   BgPaintBox.Canvas.LineTo(Self.CoordLine.BottomRight.X, Self.CoordLine.BottomRight.Y);
  end;
end;

procedure TBalloonForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
   begin
    //Style := Style - WS_CAPTION - WS_BORDER;
    ExStyle:=ExStyle+WS_EX_TOPMOST;
   end;
end;

constructor TBalloonForm.CreateNew(AOwner: TComponent; ABlnEffects: TShowEffect);
var
  NonClientMetrics: TNonClientMetrics;
begin
  inherited CreateNew(AOwner);
  NonClientMetrics.cbSize := sizeof(NonClientMetrics);
  if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then
    Font.Handle := CreateFontIndirect(NonClientMetrics.lfMessageFont);
  IncScreenRect:=Rect(0, 0, 0, 0);
  RegionCut:=Rect(0, 0, Self.Width, Self.Height);
  SetWindowPos(Self.Handle, HWND_TOPMOST, Self.Left, Self.Top, Self.Width, Self.Height, SWP_NOZORDER);

  Self.BorderStyle:=bsNone;
  FormStyle:=fsStayOnTop;
  Color:=$00CCFFFF;
  Self.OnClose:=Self.OnCloseForm;

  CanUserMove:=true;
  CloseOnClick:=false;
  dx:=0;
  dy:=0;

  BgImage:=TBlnImage.Create(Self);
  BgImage.Parent:=Self as TWinControl;
  BgImage.Align:=alClient;
  BgImage.Stretch:=true;
  BgImage.Picture:=TPicture.Create;
  BgImage.SendToBack;
  BgImage.OnClick:=Self.OnClick;

  BgPaintBox:=TBlnPaintBox.Create(Self);
  BgPaintBox.Parent:=Self as TWinControl;
  BgPaintBox.Align:=alClient;
  BgPaintBox.BringToFront;
  BgPaintBox.OnClick:=Self.OnClick;

  TimerChar:=TTimer.Create(Self);
  TimerChar.Interval:=1000;
  TimerChar.Enabled:=false;
  TimerChar.OnTimer:=Self.OnTimerChar;

  TimerIn:=TTimer.Create(Self);
  TimerIn.Interval:=50;
  TimerIn.Enabled:=false;
  TimerIn.OnTimer:=Self.OnTimerIn;

  TimerOut:=TTimer.Create(Self);
  TimerOut.Interval:=50;
  TimerOut.Enabled:=false;
  TimerOut.OnTimer:=Self.OnTimerOut;

  TimerClose:=TTimer.Create(Self);
  TimerClose.Interval:=5000;
  TimerClose.Enabled:=false;
  TimerClose.OnTimer:=Self.OnTimerClose;

  FEffects:=ABlnEffects;
  if FEffects in [seFadeIn, seFadeInOut] then
   begin
    Self.AlphaBlendValue:=0;
    Self.AlphaBlend:=true;
    Self.TimerIn.Interval:=50;
    Self.TimerIn.Enabled:=true;
   end
  else if FEffects = seFlashing then
   begin
    FlashCount:=0;
    Self.TimerIn.Interval:=200;
    Self.TimerIn.Enabled:=true;
   end;

  CtrlMoved:=false;

  UpdateArrow();
end;

destructor TBalloonForm.Destroy;
begin
 BgImage.free;
 BgPaintBox.free;
 TimerChar.free;
 TimerIn.free;
 TimerOut.free;
 TimerClose.Enabled:=false;
 TimerClose.free;
 SelectObject(Handle, 0);
 SetWindowRgn(Handle, 0, true);
 {if integer(DeleteObject(HReg))<>0 then
  ShowMessage('del')
 else
  ShowMessage('NOT del');}   
 inherited Destroy;
end;

procedure TBalloonForm.ShowFormW(var Message: TMessage);
var
 i: integer;
begin
 inherited;
 if not CtrlMoved then
  begin
   for i:=0 to Self.ControlCount-1 do
    begin
     Controls[i].Left:=Controls[i].Left+RegionCut.Left;
     Controls[i].Top:=Controls[i].Top+RegionCut.Top;
    end;
   CoordLine.Top:=CoordLine.Top+RegionCut.Top;
   CoordLine.Bottom:=CoordLine.Bottom+RegionCut.Top;
   CoordLine.Left:=CoordLine.Left+RegionCut.Left;
   CoordLine.Right:=CoordLine.Right+RegionCut.Left;
   
   CtrlMoved:=true;
  end;

 UpdateArrow();
 DrawBackGround();
 UpdateControlState;
end;

procedure TBalloonForm.PaintW(var Message: TMessage);
begin
 inherited;
 DrawBackGround();
end;

procedure TBalloonForm.MouseDownW(var Message: TMessage);
begin
 if not CloseOnClick then
  begin
   ReleaseCapture;
   perform(WM_SysCommand, SC_DragMove, 0);
  end;
end;

procedure TBalloonForm.SysCmdW(var Message: TMessage);
begin
 if Message.WParam = SC_DragMove then
  begin
   if CloseOnClick then
    begin
     case Self.BlnType of
      btSuggest:
       begin
        if Assigned(Self.OnSuggestClick) then
          Self.OnSuggestClick(Self, Self.fID);
       end;
      btTip:
       begin
        Self.OnTipBtnClick(Self);
       end;
      btNotify:
       begin
        if Assigned(Self.OnNotifyClick) then
          Self.OnNotifyClick(Self, Self.fID);
       end;
     end;
     Self.Perform(WM_CLOSE, 0, 0);
    end
   else if CanUserMove then
    inherited;
  end
 else
  inherited;
end;

procedure TBalloonForm.OnTimerIn(Sender: TObject);
begin
 if FEffects in [seFadeIn, seFadeInOut] then
  begin
   Self.AlphaBlendValue:=Self.AlphaBlendValue+51;
   if Self.AlphaBlendValue=255 then
    TimerIn.Enabled:=false;
  end
 else
  begin
   Self.Visible:=not Self.Visible;
   FlashCount:=FlashCount+1;
   if FlashCount = 4 then
    TimerIn.Enabled:=false;
  end;
end;

procedure TBalloonForm.OnTimerOut(Sender: TObject);
begin
 Self.AlphaBlendValue:=Self.AlphaBlendValue-51;
 if Self.AlphaBlendValue=0 then
  begin
   TimerOut.Enabled:=false;
   Close;
  end;
end;

procedure TBalloonForm.OnCloseForm(Sender: TObject; var Action: TCloseAction);
//var
 //b: Boolean;
begin
 //if Assigned(Self.OnBlnClose) then
 //  Self.OnBlnClose(Self);
   {case Self.BlnType of
    btSuggest:
     begin
      if Assigned(Self.OnSuggestClick) then
        Self.OnSuggestClick(Self, Self.fID);
     end;
    btTip:
     begin
      b:=Self.CheckBoxResult;
      if Assigned(Self.OnTipClose) then
        Self.OnTipClose(Self, Self.fID, b);
     end;
    btNotify:
     begin
      if Assigned(Self.OnNotifyClick) then
        Self.OnNotifyClick(Self, Self.fID);
     end;
   end; }
 //Self.TimerClose.Enabled:=false;
end;

function TBalloonForm.CloseQuery: Boolean;
begin
 inherited CloseQuery;
 Self.TimerChar.Enabled:=false;
 if FEffects in [seFadeOut, seFadeInOut] then
  begin
   TimerOut.Enabled:=true;
   if Self.AlphaBlendValue=0 then
    begin
     Self.ModalResult:=fSaveModalResult;
     TimerOut.Enabled:=false;
     Result:=true;
    end
   else
    begin
     fSaveModalResult:=Self.ModalResult;
     Result:=false;
    end;
  end
 else
  Result:=true;
end;

procedure TBalloonForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;

procedure TBalloonForm.FindIncScreen();
var
 apBar: APPBARDATA;
begin
 try
  //Узнаем все о TaskBar
  SHAppBarMessage(ABM_GETTASKBARPOS, apBar);
  //Смотря где расположен туда и прибавляем, для учета инкримента
  case apBar.uEdge of
   ABE_BOTTOM:
     IncScreenRect.Bottom:=apBar.rc.Bottom-apBar.rc.Top;
   ABE_LEFT:
     IncScreenRect.Left:=apBar.rc.Right;
   ABE_RIGHT:
     IncScreenRect.Right:=apBar.rc.Right-apBar.rc.Left;
   ABE_TOP:
     IncScreenRect.Top:=apBar.rc.Bottom;
  end;
 except
 end;
end;


procedure TBalloonForm.PointingNotify(aPoint: TPoint; NotifyOrient: TNotifyOrientation);
var
 rFreeSpace: TRect;
 PosOk: Boolean;
 cntSelect: Integer;
begin
 FindIncScreen();
 
 RegionCut:=Rect(BLN_WidthArrow, BLN_WidthArrow, Self.Width-BLN_WidthArrow, Self.Height-BLN_WidthArrow);
 rFreeSpace.Top:=aPoint.Y-Self.IncScreenRect.Top;
 rFreeSpace.Left:=aPoint.X-Self.IncScreenRect.Left;
 rFreeSpace.Right:=Screen.Width-aPoint.X-Self.IncScreenRect.Right;
 rFreeSpace.Bottom:=Screen.Height-aPoint.Y-Self.IncScreenRect.Bottom;
 //Проверям что хватит ли места со сторон с которых запросили расположить баллон:
 PosOk:=false;
 cntSelect:=0;
 repeat
 case NotifyOrient of
   noAuto:
    begin
      if (rFreeSpace.Left>rFreeSpace.Right) and (rFreeSpace.Top>rFreeSpace.Bottom) then
       NotifyOrient:=noUpLeft;
      if (rFreeSpace.Right>rFreeSpace.Left) and (rFreeSpace.Top>rFreeSpace.Bottom) then
       NotifyOrient:=noUpRight;
      if (rFreeSpace.Left>rFreeSpace.Right) and (rFreeSpace.Bottom>rFreeSpace.Top) then
       NotifyOrient:=noDownLeft;
      if (rFreeSpace.Right>rFreeSpace.Left) and (rFreeSpace.Bottom>rFreeSpace.Top) then
       NotifyOrient:=noDownRight;
    end;
   noDownLeft:
    begin
      if (rFreeSpace.Bottom>=(Self.Height-BLN_WidthArrow)) then
       begin
         //Место слева - длинна шарика за вычетом рассточния под стрелку, которое
         //отризается слева и то, что шарик будет смещен в право на длинну равную
         //смещению стрелки от правой граници шарика:
         {
           |<------------->|

            ______________/|___
           (___________________)
         }
        if (rFreeSpace.Left>=(Self.Width-BLN_WidthArrow-BLN_TopArrowSpacing)) then
         begin
          Self.Top:=aPoint.Y;
          Self.Left:=aPoint.X-Self.Width+BLN_TopArrowSpacing+BLN_WidthArrow;

          ArrowPoints[0]:=Point(Self.Width-BLN_TopArrowSpacing-BLN_WidthArrow, 0);
          ArrowPoints[1]:=Point(ArrowPoints[0].X, BLN_WidthArrow+1);
          ArrowPoints[2]:=Point(ArrowPoints[1].X-BLN_WidthArrow-1, ArrowPoints[1].Y);
          RArrowPoints[0]:=point(ArrowPoints[0].X-1, ArrowPoints[0].Y+1);
          RArrowPoints[1]:=point(ArrowPoints[1].X-1, ArrowPoints[1].Y-1);
          RArrowPoints[2]:=point(ArrowPoints[2].X+1, ArrowPoints[2].Y-1);
          PosOk:=true;
         end
        else
         begin
          NotifyOrient:=noDownRight;
          cntSelect:=cntSelect+1;
         end;
       end
      else
        begin
         NotifyOrient:=noUpLeft;
         cntSelect:=cntSelect+1;
        end;
    end;
   noDownRight:
    begin
      if (rFreeSpace.Bottom>=(Self.Height-BLN_WidthArrow)) then
       begin
         {
               |<------------->|

            ___|\______________
           (___________________)
         }
        if (rFreeSpace.Right>=(Self.Width+BLN_WidthArrow-BLN_TopArrowSpacing)) then
         begin
          Self.Top:=aPoint.Y;
          Self.Left:=aPoint.X-BLN_TopArrowSpacing-BLN_WidthArrow;

          ArrowPoints[0]:=Point(BLN_TopArrowSpacing+BLN_WidthArrow, 0);
          ArrowPoints[1]:=Point(ArrowPoints[0].X, BLN_WidthArrow);
          ArrowPoints[2]:=Point(ArrowPoints[1].X+BLN_WidthArrow, ArrowPoints[1].Y);
          RArrowPoints[0]:=point(ArrowPoints[0].X, ArrowPoints[0].Y+1);
          RArrowPoints[1]:=point(ArrowPoints[1].X, ArrowPoints[1].Y);
          RArrowPoints[2]:=point(ArrowPoints[2].X-1, ArrowPoints[2].Y);
          PosOk:=true;
         end
        else
         begin
          NotifyOrient:=noDownLeft;
          cntSelect:=cntSelect+1;
         end;
       end
      else
       begin
        NotifyOrient:=noUpRight;
        cntSelect:=cntSelect+1;
       end;
    end;
   noLeftDown:
    begin
      if (rFreeSpace.Left>=(Self.Width-BLN_WidthArrow)) then
         {
            ___________________
           (                   --
           (                   /
           (___________________)
         }
        begin
         if (rFreeSpace.Bottom>=(Self.Height-BLN_WidthArrow-BLN_TopArrowSpacing)) then
          begin
           Self.Top:=aPoint.Y-BLN_TopArrowSpacing-BLN_WidthArrow;
           Self.Left:=aPoint.X-Self.Width;

           ArrowPoints[0]:=Point(Self.Width+1, BLN_TopArrowSpacing+BLN_WidthArrow);
           ArrowPoints[1]:=Point(ArrowPoints[0].X-BLN_WidthArrow-1, ArrowPoints[0].y);
           ArrowPoints[2]:=Point(ArrowPoints[1].x, ArrowPoints[1].y+BLN_WidthArrow);

           RArrowPoints[0]:=point(ArrowPoints[0].x-2, ArrowPoints[0].y);
           RArrowPoints[1]:=point(ArrowPoints[1].x-1, ArrowPoints[1].y);
           RArrowPoints[2]:=point(ArrowPoints[2].x-1, ArrowPoints[2].y);
           PosOk:=true;
          end
         else
          begin
           NotifyOrient:=noLeftUp;
           cntSelect:=cntSelect+1;
          end;
        end
      else
        begin
         NotifyOrient:=noRightDown;
         cntSelect:=cntSelect+1;
        end;
    end;
   noLeftUp:
    begin
      if (rFreeSpace.Left>=(Self.Width-BLN_WidthArrow)) then
         {
            ___________________
           (                   )
           (                   \
           (___________________--
         }
        begin
         if (rFreeSpace.Top>=(Self.Height+BLN_WidthArrow-BLN_TopArrowSpacing)) then
          begin
           Self.Top:=aPoint.Y-Self.Height+BLN_TopArrowSpacing+BLN_WidthArrow;
           Self.Left:=aPoint.X-Self.Width;

           ArrowPoints[0]:=Point(Self.Width, Self.Height-BLN_TopArrowSpacing-BLN_WidthArrow);
           ArrowPoints[1]:=Point(Self.Width-BLN_WidthArrow-1, ArrowPoints[0].y);
           ArrowPoints[2]:=Point(ArrowPoints[1].x, ArrowPoints[1].y-BLN_WidthArrow);

           RArrowPoints[0]:=point(ArrowPoints[0].x-3, ArrowPoints[0].y-1);
           RArrowPoints[1]:=point(ArrowPoints[1].x, ArrowPoints[1].y-1);
           RArrowPoints[2]:=point(ArrowPoints[2].x, ArrowPoints[2].y+1);
           PosOk:=true;
          end
         else
          begin
           NotifyOrient:=noLeftUp;
           cntSelect:=cntSelect+1;
          end;
        end
      else
        begin
         NotifyOrient:=noRightDown;
         cntSelect:=cntSelect+1;
        end;
    end;
   noRightDown:
    begin
      if (rFreeSpace.Right>=(Self.Width-BLN_WidthArrow)) then
         {
             ___________________
           --                   )
            \                   )
            (___________________)
         }
        begin
         if (rFreeSpace.Bottom>=(Self.Height-BLN_WidthArrow-BLN_TopArrowSpacing)) then
          begin
           Self.Top:=aPoint.Y-BLN_WidthArrow-BLN_TopArrowSpacing;
           Self.Left:=aPoint.X;

           ArrowPoints[0]:=Point(0, BLN_TopArrowSpacing+BLN_WidthArrow+1);
           ArrowPoints[1]:=Point(BLN_WidthArrow, ArrowPoints[0].y);
           ArrowPoints[2]:=Point(ArrowPoints[1].x, BLN_TopArrowSpacing+2*BLN_WidthArrow+1);

           RArrowPoints[0]:=point(ArrowPoints[0].x, ArrowPoints[0].y);
           RArrowPoints[1]:=ArrowPoints[1];
           RArrowPoints[2]:=point(ArrowPoints[2].x, ArrowPoints[2].y);
           PosOk:=true;
          end
         else
          begin
           NotifyOrient:=noRightUp;
           cntSelect:=cntSelect+1;
          end;
        end
      else
        begin
         NotifyOrient:=noLeftDown;
         cntSelect:=cntSelect+1;
        end;
    end;
   noRightUp:
    begin
      if (rFreeSpace.Right>=(Self.Width-BLN_WidthArrow)) then
         {
             ___________________
            (                   )
            /                   )
           --___________________)
         }
        begin
         if (rFreeSpace.Top>=(Self.Height-BLN_WidthArrow-BLN_TopArrowSpacing)) then
          begin
           Self.Top:=aPoint.Y-Self.Height+BLN_WidthArrow+BLN_TopArrowSpacing;
           Self.Left:=aPoint.X;

           ArrowPoints[0]:=Point(0, Self.Height-BLN_TopArrowSpacing-BLN_WidthArrow);
           ArrowPoints[1]:=Point(BLN_WidthArrow, ArrowPoints[0].Y);
           ArrowPoints[2]:=Point(ArrowPoints[1].X, ArrowPoints[1].y-BLN_WidthArrow);

           RArrowPoints[0]:=point(ArrowPoints[0].x+1, ArrowPoints[0].y-1);
           RArrowPoints[1]:=point(ArrowPoints[1].x, ArrowPoints[1].y-1);
           RArrowPoints[2]:=point(ArrowPoints[2].x, ArrowPoints[2].y);
           PosOk:=true;
          end
         else
          begin
           NotifyOrient:=noRightDown;
           cntSelect:=cntSelect+1;
          end;
        end
      else
        begin
         NotifyOrient:=noLeftUp;
         cntSelect:=cntSelect+1;
        end;
    end;
   noUpLeft:
    begin
      if (rFreeSpace.Top>=(Self.Height-BLN_WidthArrow)) then
         {
             ___________________
            (                   )
            (                   )
            (_______________  __)
                            \|
         }
        begin
         if (rFreeSpace.Left>=(Self.Width-2*BLN_WidthArrow-BLN_TopArrowSpacing)) then
          begin
           Self.Top:=aPoint.Y-Self.Height;
           Self.Left:=aPoint.X-Self.Width+BLN_WidthArrow+BLN_TopArrowSpacing;

           ArrowPoints[0]:=Point(Self.Width-BLN_WidthArrow-BLN_TopArrowSpacing, Self.Height);
           ArrowPoints[1]:=Point(ArrowPoints[0].X, Self.Height-BLN_WidthArrow);
           ArrowPoints[2]:=Point(ArrowPoints[1].X-BLN_WidthArrow, ArrowPoints[1].y);

           RArrowPoints[0]:=point(ArrowPoints[0].x-1, ArrowPoints[0].y-1);
           RArrowPoints[1]:=point(ArrowPoints[1].x-1, ArrowPoints[1].y-1);
           RArrowPoints[2]:=point(ArrowPoints[2].x-1, ArrowPoints[2].y-1);
           PosOk:=true;
          end
         else
          begin
           NotifyOrient:=noUpRight;
           cntSelect:=cntSelect+1;
          end;
        end
      else
        begin
         NotifyOrient:=noDownLeft;
         cntSelect:=cntSelect+1;
        end;
    end;
   noUpRight:
    begin
      if (rFreeSpace.Top>=(Self.Height-BLN_WidthArrow)) then
         {
             ___________________
            (                   )
            (                   )
            (__  _______________)
               |/
         }
        begin
         if (rFreeSpace.Right>=(Self.Width-2*BLN_WidthArrow-BLN_TopArrowSpacing)) then
          begin
           Self.Top:=aPoint.Y-Self.Height;
           Self.Left:=aPoint.X-BLN_TopArrowSpacing-BLN_WidthArrow;

           ArrowPoints[0]:=Point(BLN_WidthArrow+BLN_TopArrowSpacing, Self.Height);
           ArrowPoints[1]:=Point(ArrowPoints[0].X, Self.Height-BLN_WidthArrow);
           ArrowPoints[2]:=Point(ArrowPoints[1].X+BLN_WidthArrow, ArrowPoints[1].y);

           RArrowPoints[0]:=point(ArrowPoints[0].x, ArrowPoints[0].y-1);
           RArrowPoints[1]:=point(ArrowPoints[1].x, ArrowPoints[1].y-1);
           RArrowPoints[2]:=point(ArrowPoints[2].x, ArrowPoints[2].y-1);
           PosOk:=true;
          end
         else
          begin
           NotifyOrient:=noUpRight;
           cntSelect:=cntSelect+1;
          end;
        end
      else
        begin
         NotifyOrient:=noDownLeft;
         cntSelect:=cntSelect+1;
        end;
    end;
 end; //case Notify
 until PosOk;
 Self.NotifyOrient:=NotifyOrient;
 UpdateArrow();
end;

procedure TBalloonForm.PointingOn(aRect: TRect);
var
 Head: TPoint;
 fTop, fLeft, fRight: integer;
 fHoz: boolean; //true - слево больше
 //Orient: byte; {0 - top, 1 - left, 2 - right}
 m: integer;
begin
 FindIncScreen(); //Определяем отстыпы от TaskBar
 if Self.BlnType<>btSuggest then
  RegionCut:=Rect(BLN_WidthArrow, 0, Self.Width-BLN_WidthArrow, Self.Height-BLN_WidthArrow)
 else
  RegionCut:=Rect(0,0,Self.Width,Self.Height);

 //Пололжение головы персонажа
 Head.x:=aRect.Left+((aRect.Right-aRect.Left) div 2);
 Head.y:=aRect.Top;
 //Выч. свободное пространство сверху и с боков
 fTop:=aRect.Top-BLN_ArrowSpacing-Self.Height-IncScreenRect.Top;
 fLeft:=aRect.Left-BLN_ArrowSpacing-Self.Width-IncScreenRect.Left;
 fRight:=Screen.Width-(aRect.Right+BLN_ArrowSpacing+Self.Width)-IncScreenRect.Right;
 //Где больше с лева или справа?
 fHoz:=fLeft>fRight;
 //если сверху достаточно, то...
 if (fTop>0) then
  begin
    Orient:=0  //балон распологать сверху
  end
 else
  begin
   if fHoz then
    Orient:=1 //Слева
   else
    Orient:=2; //Справа
  end;

 //Вычисляем положение уголка указателя
 case Orient of
  0:
   begin
    {
       1   2
         0
    }
    if fHoz then
     Self.Left:=Min(Head.x-(Self.width div 2), Screen.Width-Self.Width+BLN_WidthArrow-IncScreenRect.Right)
    else
     Self.Left:=Max(Head.x-(Self.width div 2), -1*BLN_WidthArrow+IncScreenRect.Left);
    self.Top:=max(Head.y - BLN_ArrowSpacing - Self.Height, IncScreenRect.Top);

    if fHoz then //если слева много места, стрелкой придется тянуться правее(есть на левом краю дело)
     begin
       {ArrowPoints[0]:=Point(min(Head.x-Self.Left, (Self.Width div 2)+BLN_HozMargen),
          Self.Height+1);    //^^^минимум из желаемой позиции указателя и возможной
       ArrowPoints[1]:=Point(ArrowPoints[0].x-BLN_HeightArrow-1, Self.Height-BLN_WidthArrow);
       ArrowPoints[2]:=Point(ArrowPoints[1].x+BLN_HeightArrow, ArrowPoints[1].y);

       RArrowPoints[0]:=point(ArrowPoints[0].x-1, ArrowPoints[0].y-1);
       RArrowPoints[1]:=point(ArrowPoints[1].x+1, ArrowPoints[1].y-1);
       RArrowPoints[2]:=point(ArrowPoints[2].x, ArrowPoints[2].y-1); }
       ArrowPoints[0]:=Point(min(Head.x-Self.Left, (Self.Width div 2)+BLN_HozMargen),
          Self.Height+1);    //^^^минимум из желаемой позиции указателя и возможной
       ArrowPoints[1]:=Point(ArrowPoints[0].x, Self.Height-BLN_WidthArrow);
       ArrowPoints[2]:=Point(ArrowPoints[1].x-BLN_HeightArrow-1, ArrowPoints[1].y);

       RArrowPoints[0]:=point(ArrowPoints[0].x-1, ArrowPoints[0].y-2);
       RArrowPoints[1]:=point(ArrowPoints[1].x-1, ArrowPoints[1].y-1);
       RArrowPoints[2]:=point(ArrowPoints[2].x+1, ArrowPoints[2].y-1);
     end
    else  //и наоборот
     begin
       ArrowPoints[0]:=Point(max(Head.x-Self.Left, (Self.Width div 2)-BLN_HozMargen),
          Self.Height);    //^^^максимум из желаемой позиции указателя и возможной(с парвой стороны дело)
       ArrowPoints[1]:=Point(ArrowPoints[0].x, Self.Height-BLN_WidthArrow-1);
       ArrowPoints[2]:=Point(ArrowPoints[1].x+BLN_HeightArrow, ArrowPoints[1].y);

       RArrowPoints[0]:=point(ArrowPoints[0].x, ArrowPoints[0].y);
       RArrowPoints[1]:=point(ArrowPoints[1].x, ArrowPoints[1].y);
       RArrowPoints[2]:=point(ArrowPoints[2].x-1, ArrowPoints[2].y);
     end;
   end;
  1: //балон слева от rect(стрекла значит справой сторон)
   begin
    //большее из расчитанной и минимально возможной левой гарницей:
    Self.Left:=max(aRect.Left-BLN_ArrowSpacing-Self.Width, -1*BLN_WidthArrow+IncScreenRect.Left);
    //Min - как можно выше к указываемому обеъкту(не ушел низе taskBar)
    //Max - но большее из расчитанного и минимально возможного(не ушел выше потолка)
    Self.Top:=max(Min(aRect.Top, Screen.Height-Self.Height-IncScreenRect.Bottom), IncScreenRect.Top);
    m:=BLN_TopArrowSpacing;
    ArrowPoints[0]:=Point(Self.Width, m);
    ArrowPoints[1]:=Point(Self.Width-BLN_WidthArrow, ArrowPoints[0].y);
    ArrowPoints[2]:=Point(ArrowPoints[1].x, ArrowPoints[1].y+BLN_HeightArrow);

    RArrowPoints[0]:=point(ArrowPoints[0].x, ArrowPoints[0].y);
    RArrowPoints[1]:=point(ArrowPoints[1].x-1, ArrowPoints[1].y);
    RArrowPoints[2]:=point(ArrowPoints[2].x-1, ArrowPoints[2].y-1);
   end;
  2: //балон справа от rect(стрекла значит слевой сторон)
   begin
    //аналогично выше
    Self.Left:=min(aRect.Right+BLN_ArrowSpacing, Screen.Width+BLN_WidthArrow-IncScreenRect.Right);
    Self.Top:=max(Min(aRect.Top, Screen.Height-Self.Height-IncScreenRect.Bottom), IncScreenRect.Top);
    m:=BLN_TopArrowSpacing+1;
    ArrowPoints[0]:=Point(0, m);
    ArrowPoints[1]:=Point(BLN_WidthArrow, ArrowPoints[0].y);
    ArrowPoints[2]:=Point(ArrowPoints[1].x, m+BLN_HeightArrow);

    RArrowPoints[0]:=point(ArrowPoints[0].x, ArrowPoints[0].y);
    RArrowPoints[1]:=ArrowPoints[1];
    RArrowPoints[2]:=point(ArrowPoints[2].x, ArrowPoints[2].y-1);
   end;
 end;
 Self.Left:=Self.Left+dx;
 Self.Top:=Self.Top+dy;
end;

procedure TBalloonForm.AssignToCharacter(aCChar: IAgentCtlCharacterEx; aSChar: IAgentCharacterEx);
var
 l, t, r, b: integer;
begin
 CChar:=aCChar;
 SChar:=aSChar;
 if CChar<>nil then
  begin
   OldRectChar:=Rect(CChar.Left, CChar.Top, CChar.left+CChar.Width, CChar.top+CChar.height);
   PointingOn(OldRectChar);
   UpdateArrow();
   TimerChar.Enabled:=true;
   CChar.StopAll(EmptyParam);
   CChar.Play('RestPose');
  end
 else if SChar<>nil then
  begin
   SChar.GetPosition(l, t);
   SChar.GetSize(r, b);
   OldRectChar:=Rect(l, t, r+l, b+t);
   PointingOn(OldRectChar);
   UpdateArrow();
   TimerChar.Enabled:=true;
   SChar.StopAll(0);
   SChar.Play('RestPose', r);
  end
 else
  TimerChar.Enabled:=false;
end;

procedure TBalloonForm.OnTimerChar(Sender: TObject);
var
 CurrRect: TRect;
 l, t, r, b: integer;
begin
 if Self.Visible then
  begin
   if CChar<>nil then
    begin
     CurrRect:=Rect(CChar.Left, CChar.Top, CChar.left+CChar.Width, CChar.top+CChar.height);
     if (CurrRect.Left <> OldRectChar.Left) or
        (CurrRect.Top <> OldRectChar.Top) or
        (CurrRect.Right <> OldRectChar.Right) or
        (CurrRect.Bottom <> OldRectChar.Bottom) then
       begin
        Self.Visible:=false;
        OldRectChar:=CurrRect;
        PointingOn(OldRectChar);
        //UpdateArrow();
        Self.Visible:=true;
       end
    end
   else if SChar<>nil then
    begin
     SChar.GetPosition(l, t);
     SChar.GetSize(r, b);
     CurrRect:=Rect(l, t, r+l, b+t);
     if (CurrRect.Left <> OldRectChar.Left) or
        (CurrRect.Top <> OldRectChar.Top) or
        (CurrRect.Right <> OldRectChar.Right) or
        (CurrRect.Bottom <> OldRectChar.Bottom) then
       begin
        Self.Visible:=false;
        OldRectChar:=CurrRect;
        PointingOn(OldRectChar);
        //UpdateArrow();
        Self.Visible:=true;
       end
    end
  end;
end;

procedure TBalloonForm.OnTimerClose(Sender: TObject);
begin
 Self.Close;
 Self.TimerClose.Enabled:=false;
end;

function TBalloonForm.GetBackgroundImage: TPicture;
begin
 Result:=Self.BgImage.Picture;
end;

procedure TBalloonForm.SetBackgroundImage(Value: TPicture);
begin
 BgImage.Picture.Assign(Value);
end;

procedure TBalloonForm.SetBackImage(Value: string);
begin
  FBackImage:=Value;
  if ShowBgImage then
   begin
    if FileExists(Self.BackImage) then
     begin
      BgImage.Picture.LoadFromFile(Self.BackImage);
      BgImage.Visible:=true;
     end;
   end
  else
   begin
     BgImage.Visible:=false;
   end;
end;

function TBalloonForm.GetImageStretch: Boolean;
begin
 Result:=BgImage.Stretch;
end;

procedure TBalloonForm.SetImageStretch(Value: Boolean);
begin
 BgImage.Stretch:=Value;
end;

procedure TBalloonForm.SetShowBgImage(Value: Boolean);
begin
  FShowBgImage:=Value;
  if ShowBgImage then
   begin
    if FileExists(Self.BackImage) then
     begin
      BgImage.Picture.LoadFromFile(Self.BackImage);
      BgImage.Visible:=true;
     end;
   end
  else
   begin
     BgImage.Visible:=false;
   end;
end;

function TBalloonForm.GetAutoClose(): boolean;
begin
  Result:=TimerClose.Enabled;
end;

procedure TBalloonForm.SetAutoClose(Value: boolean);
begin
 if TimerClose.Interval>=250 then 
  TimerClose.Enabled:=Value;
end;

function TBalloonForm.GetIntervalClose(): integer;
begin
  Result:=TimerClose.Interval;
end;

procedure TBalloonForm.SetIntervalClose(Value: integer);
begin
  TimerClose.Interval:=Value;
end;

function TBalloonForm.BitmapToRegion(Bitmap: TBitmap; TransColor: TColor): HRGN;
var
 X, Y: Integer;
 XStart: Integer;
begin
 Result := 0;
 with Bitmap do
  for Y := 0 to Height - 1 do
   begin
    X := 0;
    while X < Width do
     begin     // Пропускаем прозрачные точки
      while (X < Width) and (Canvas.Pixels[X, Y] = TransColor) do
       Inc(X);
      if X >= Width then
       Break;
      XStart := X;    // Пропускаем непрозрачные точки
      while (X < Width) and (Canvas.Pixels[X, Y] <> TransColor) do
       Inc(X);// Создаём новый прямоугольный регион и добавляем его к
      if Result = 0 then  // региону всей картинки
       Result := CreateRectRgn(XStart, Y, X, Y + 1)
      else
       CombineRgn(Result, Result, CreateRectRgn(XStart, Y, X, Y + 1), RGN_OR);
     end;
   end;
end;

procedure TBalloonForm.UpdateArrow();
var
 HReg: THandle;
begin
 if Self.BlnType<>btSuggest then
  begin
   HReg:=CreateRoundRectRgn(RegionCut.Left, RegionCut.Top, RegionCut.Right+1,
        RegionCut.Bottom+1, BLN_Round, BLN_Round);
   CombineRgn(HReg, HReg, CreatePolygonRgn(ArrowPoints, 3, WINDING), RGN_OR);
  end
 else
  begin
   HReg:=Self.BitmapToRegion(Self.BgImage.Picture.Bitmap,
      Self.BgImage.Picture.Bitmap.Canvas.Pixels[0, Self.BgImage.Picture.Height-1]);
  end;
 SetWindowRgn(Self.Handle, HReg, true);
 DeleteObject(HReg); 
end;

procedure TBalloonForm.OnOptionClick(Sender: TObject); //Клик по OptionButton
begin
 case Self.BlnType of
  btForm:
   begin
    if Assigned(Self.OnFrmBlnOptionClick) then
     Self.OnFrmBlnOptionClick(Self, TComponent(Sender).Tag, Self.InputBoxResult);
    Self.Close;
   end;
  btNotiForm:
   begin
    if Assigned(Self.OnNotiBlnOptionClick) then
     Self.OnNotiBlnOptionClick(Self, TComponent(Sender).Tag, Self.InputBoxResult);
    Self.Close;
   end;
 end;
end;

procedure TBalloonForm.OnButtonClick(Sender: TObject); //клик по SpeedButton в FormBalloon
begin
 case Self.BlnType of
  btForm:            
   begin
    if Assigned(Self.OnFrmBlnOptionClick) then
     Self.OnFrmBlnButtonClick(Self, TComponent(Sender).Tag, Self.InputBoxResult);
    Self.Close;
   end;
  btNotiForm:
   begin
    if Assigned(Self.OnNotiBlnOptionClick) then
     Self.OnNotiBlnButtonClick(Self, TComponent(Sender).Tag, Self.InputBoxResult);
    Self.Close;
   end;
 end;
end;

procedure TBalloonForm.OnEditChange(Sender: TObject);
begin
 FInputBoxResult:=TEdit(Sender).Text;
end;

procedure TBalloonForm.OnEditKeyPress(Sender: TObject; var Key: Char);
begin
 case Self.BlnType of
  btForm:
   begin
     if Assigned(Self.FOnFrmBlnTBoxKeyPress) then
       Self.FOnFrmBlnTBoxKeyPress(Self, Self.fID, Key);
   end;
  btNotify:
   begin
     if Assigned(Self.FOnNotiBlnTBoxKeyPress) then
       Self.FOnNotiBlnTBoxKeyPress(Self, Self.fID, Key);
   end;
 end;
 if ((Self.BlnType in [btForm, btNotify]) and (Self.CloseOnPressEnterInTextBox)) xor
    (not (Self.BlnType in [btForm, btNotify])) then
   if (Key = #13) then
    begin
     Self.ModalResult:=mrOk;
     //Self.Close;
    end;
end;

procedure TBalloonForm.OnCheckBoxClick(Sender: TObject);
begin
 FCheckBoxResult:=TBlnCheckBox(Sender).Checked;
 TimerClose.Enabled:=false;
end;

procedure TBalloonForm.OnSuggestBtnClick(Sender: TObject);
begin
 Self.Close;
end;

procedure TBalloonForm.OnTipBtnClick(Sender: TObject);
var
 b: boolean;
begin
 if (CloseOnClick) or (Sender is TBlnSpeedButton) then
  begin
   b:=Self.CheckBoxResult;
   if Assigned(Self.OnTipClose) then
    Self.OnTipClose(Self, Self.fID, b);       
   Self.Close;
  end;
end;

procedure TBalloonForm.OnNotifyBtnClick(Sender: TObject);
begin
 if CloseOnClick then
  begin
   Self.Close;
  end;
end;

end.
