unit BlnSpeedButton;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, OleCtrls, ExtCtrls, ImgList;

type
  TBlnButtonState = (bsNormal, bsUp, bsDown);

  TBlnSpeedButton = class(TCustomControl)
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  private
    { Private declarations }
    B: TBitmap;
    FCaption: TCaption;
    FFont: TFont;
    FColor: TColor;
    FTransparent: Boolean;
    FImages: TImageList;
    FModalResult: TModalResult;
    procedure SetImages(const Value: TImageList);
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
  protected
    { Protected declarations }
    MouseOnControl: boolean;
    ButtonState: TBlnButtonState;
    cleared: Boolean;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure MyDrawFocusRect();
    procedure DrawPicture();
    procedure KeyDownW(var Message: TMessage); message WM_KEYDOWN;
    procedure PaintW(var Message: TMessage); message WM_PAINT;
    procedure MouseOver(var Message: TMessage); message CM_MOUSEENTER;
    procedure MouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure MouseDownW(var Message: TMessage); message WM_LBUTTONDOWN;
    procedure MouseUpW(var Message: TMessage); message WM_LBUTTONUP;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WndProc(var Message: TMessage); override;
    procedure DrawButtonText(Canvas: TCanvas; const Caption: String;
       TextBounds: TRect; State: TBlnButtonState);
  public
    { Public declarations }
    procedure Click; override;
  published
    { Published declarations }
    property Transparent: Boolean read FTransparent write FTransparent;
    property Font: TFont read FFont write FFont;
    property Caption: TCaption read FCaption write FCaption;
    property Color: TColor read FColor write FColor default $00E1FFFF;
    property Images: TImageList read FImages write SetImages;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property ModalResult: TModalResult read FModalResult write FModalResult default 0;
  end;

procedure Register;

implementation

procedure TBlnSpeedButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
   begin
    Style := Style or WS_CLIPCHILDREN;
    ExStyle:=ExStyle+WS_EX_TRANSPARENT;
   end;
end;

procedure TBlnSpeedButton.MyDrawFocusRect();
var
 i, j: integer;
 Rec: TRect;
begin
  Rec := Rect(6,3,self.Width-6,Self.Height-4);
  Canvas.Brush.Style:=bsClear;
  //Canvas.FillRect(ClientRect);
  if Self.Focused then
   begin
    i:=Rec.Left;
    j:=Rec.Top;
    while i<=Rec.Right do
     begin
       Canvas.Pixels[i, j]:=clBlack;
       i:=i+2;
     end;
    i:=Rec.Right;
    while j<=Rec.Bottom do
     begin
       Canvas.Pixels[i, j]:=clBlack;
       j:=j+2;
     end;
    i:=Rec.Left;
    j:=Rec.Top;
    while j<=Rec.Bottom do
     begin
       Canvas.Pixels[i, j]:=clBlack;
       j:=j+2;
     end;
    j:=Rec.Bottom;
    while i<=Rec.Right do
     begin
       Canvas.Pixels[i, j]:=clBlack;
       i:=i+2;
     end;
   end;

  if Length(Self.Caption) > 0 then
   begin
    Self.Canvas.Font := Self.Font;
    Self.DrawButtonText(Self.Canvas, Self.Caption, Rec, Self.ButtonState);
   end;
end;

procedure TBlnSpeedButton.SetImages(const Value: TImageList);
begin
 FImages:=Value;
 if FImages<>nil then
  begin
   Self.Height:=FImages.Height;
   Self.Width:=FImages.Width;
  end;
end;

procedure TBlnSpeedButton.DrawPicture();
var
  num: Integer; 
begin
 case ButtonState of
   bsNormal: num:=0;
   bsUp: num:=1;
   bsDown: num:=2;
   else
    num:=0;
 end;

 Canvas.Brush.Style:=bsClear;
 Canvas.FillRect(Canvas.ClipRect);
 Canvas.Refresh;
 try
   Images.GetBitmap(num, b);
   //b.TransparentMode:=tmFixed; //Если tmFixed то прозрачный внутри
   b.Transparent:=FTransparent;
   Canvas.Draw(0, 0, b);
 except
 end;
end;

procedure TBlnSpeedButton.DrawButtonText(Canvas: TCanvas; const Caption: String;
  TextBounds: TRect; State: TBlnButtonState);
var
  CString: array[0..255] of Char;
begin
  StrPCopy(CString, Caption);
  if State = bsDown then
    OffsetRect(TextBounds, 1, 1); //Смещение Top+1 Left+1 
  DrawText(Canvas.Handle, CString, -1, TextBounds,
      DT_CENTER or DT_VCENTER or DT_SINGLELINE);
end;

constructor TBlnSpeedButton.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 Self.B:=TBitmap.Create;
 Self.FFont:=TFont.Create;
 Self.TabStop:=true;
 Self.FTransparent:=True;
end;

destructor TBlnSpeedButton.Destroy;
begin
 Self.B.free;
 Self.FFont.Free;
 inherited Destroy;
end;

procedure TBlnSpeedButton.WndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
  case Message.Msg of
    WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:
      if not Focused then
       begin
        Windows.SetFocus(Handle);
        if not Focused then
         Exit;
       end;
    WM_SIZE, WM_MOVE: Invalidate; //Чтобы при переменещие и смене размера не оставался старый фон
  end;
  
end;

procedure TBlnSpeedButton.KeyDownW(var Message: TMessage);
begin
 if Message.WParam=13 then
  Self.Click;
 inherited;
end;

procedure TBlnSpeedButton.PaintW(var Message: TMessage);
begin
  inherited;
  DrawPicture();
  MyDrawFocusRect();
end;

procedure TBlnSpeedButton.MouseOver(var Message: TMessage);
begin
  inherited;
  ButtonState:=bsUp;
  Invalidate;
  MouseOnControl:=true; //чтобы занать что мышь пришла
end;

procedure TBlnSpeedButton.MouseLeave(var Message: TMessage);
begin
  inherited;
  if ButtonState = bsUp then //Чтобы когда мышь уходит при назатой конопке, она оставалась нажатой
   begin
    ButtonState:=bsNormal;
    Invalidate;
   end;
  MouseOnControl:=false; //мышь ушла
end;

procedure TBlnSpeedButton.MouseDownW(var Message: TMessage);
var
 r: TRect;
begin
  inherited;
  ButtonState:=bsDown;
  Invalidate; //Говорим перерирвоать себя
  r:=Rect(Self.Left, Self.Top, Self.Left+Self.Width, Self.Top+Self.Height);
  InvalidateRect(Self.Parent.Handle, @r, true); //Перерисовать под нами
  SendMessage(Handle, BM_SETSTYLE, 0, 1);  //???
end;

procedure TBlnSpeedButton.MouseUpW(var Message: TMessage);
var
 r: TRect;
begin
  inherited;
  if MouseOnControl then
   ButtonState:=bsUp
  else
   ButtonState:=bsNormal;

  //Перерисовать себя и под нами
  Invalidate;
  r:=Rect(Self.Left, Self.Top, Self.Left+Self.Width, Self.Top+Self.Height);
  InvalidateRect(Self.Parent.Handle, @r, true);
end;

procedure TBlnSpeedButton.WMEraseBkgnd(var Msg: TWMEraseBkgnd);
begin
   //Inherited;
   DefaultHandler(Msg);
   Msg.Result := 1;           // Prevent background from getting erased
end;

procedure TBlnSpeedButton.CMFocusChanged(var Message: TCMFocusChanged);
var
 r: TRect;
begin
  if Self.Focused then
   begin
    MyDrawFocusRect; 
    cleared:=false;
   end
  else
   begin
     //Чистим только одни раз под собой, чтобы постоянно не моргать самим
     if not cleared then
      begin
       Invalidate;
       r:=Rect(Self.Left, Self.Top, Self.Left+Self.Width, Self.Top+Self.Height);
       InvalidateRect(Self.Parent.Handle, @r, true);
       cleared:=true;
      end;
   end;
  inherited;
end;

procedure TBlnSpeedButton.CMDialogChar(var Message: TCMDialogChar);
var
 c1, c2: string;

 function GetHotKey(s: string): Char;
 var
  pref: Integer;
 begin
  pref:=pos('&', s);
  Result:=s[pref+1];
 end;

begin
    c1:=AnsiUpperCase(Char(Message.CharCode));
    c2:=AnsiUpperCase(GetHotKey(Caption));
    if (c1=c2) and Self.CanFocus then
    begin
      Click;
      Message.Result := 1;
    end else
      inherited;
end;

procedure TBlnSpeedButton.Click;
var
  Form: TCustomForm;
begin
  Form := GetParentForm(Self);
  if Form <> nil then
   Form.ModalResult := ModalResult;
  inherited Click;
end;

procedure Register;
begin
  RegisterComponents('MSBallon', [TBlnSpeedButton]);
end;

end.
 