unit BlnOptionButton;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, OleCtrls, ExtCtrls, ImgList, Math;

type
  TBlnButtonState = (bsNormal, bsUp, bsDown);
  
  TBlnOptionButton = class(TCustomControl)
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  private
    { Private declarations }
    B: TBitmap;
    FCaption: TCaption;
    FFont: TFont;
    FColor: TColor;
    FImages: TImageList;
    FLeftSpacing: integer;
    FTopSpacing: integer;
    FTextLSpacing: integer;
    FTextTSpacing: integer;
    FMarginSpacing: integer;
    FWasFocus: Boolean;
    FModalResult: TModalResult;
    procedure SetCaption(const Value: TCaption);
    function GetCaption: TCaption;
    procedure SetLeftSpacing(const Value: Integer);
    procedure SetTopSpacing(const Value: Integer);
    procedure SetTextLSpacing(const Value: Integer);
    procedure SetTextTSpacing(const Value: Integer);
    procedure SetImages(const Value: TImageList);
    procedure SetMarginSpacing(const Value: integer);
    //procedure UpdateHeight;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
  protected
    { Protected declarations }
    ButtonState: TBlnButtonState;
    cleared: Boolean;
    procedure UpdateHeight;
    procedure MyDrawFocusRect(aPenMode: TPenMode);
    procedure DrawPicture(); virtual;
    procedure DrawButtonText();
    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyDownW(var Message: TMessage); message WM_KEYDOWN;
    procedure PaintW(var Message: TMessage); message WM_PAINT;
    procedure MouseOver(var Message: TMessage); message CM_MOUSEENTER;
    procedure MouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure MouseDownW(var Message: TMessage); message WM_LBUTTONDOWN;
    procedure MouseUpW(var Message: TMessage); message WM_LBUTTONUP;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WndProc(var Message: TMessage); override;
  public
    { Public declarations }
    procedure Click; override;
  published
    { Published declarations }
    property Font: TFont read FFont write FFont;
    property Caption: TCaption read GetCaption write SetCaption;
    property Color: TColor read FColor write FColor default $00E1FFFF;
    property Images: TImageList read FImages write SetImages;
    property LeftSpacing: integer read FLeftSpacing write SetLeftSpacing;
    property TopSpacing: integer read FTopSpacing write SetTopSpacing;
    property TextLSpacing: integer read FTextLSpacing write SetTextLSpacing;
    property TextTSpacing: integer read FTextTSpacing write SetTextTSpacing;
    property MarginSpacing: integer read FMarginSpacing write SetMarginSpacing;
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

{***********  TBlnOptionButton ***************}

procedure TBlnOptionButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
   begin
    Style := Style or WS_CLIPCHILDREN;
    ExStyle:=ExStyle+WS_EX_TRANSPARENT;
   end;
end;

procedure TBlnOptionButton.SetCaption(const Value: TCaption);
begin
 FCaption:=Value;
 UpdateHeight;
end;

function TBlnOptionButton.GetCaption: TCaption;
begin
 Result:=FCaption;
end;

procedure TBlnOptionButton.SetLeftSpacing(const Value: Integer);
begin
 FLeftSpacing:=Value;
 if FImages<>nil then
  TextLSpacing:=FLeftSpacing+FImages.Width+FMarginSpacing
 else
  TextLSpacing:=FLeftSpacing+FMarginSpacing
end;

procedure TBlnOptionButton.SetTopSpacing(const Value: Integer);
begin
 FTopSpacing:=Value;
end;

procedure TBlnOptionButton.SetTextLSpacing(const Value: Integer);
begin
 FTextLSpacing:=Value;
 UpdateHeight();
end;

procedure TBlnOptionButton.SetTextTSpacing(const Value: Integer);
begin
 FTextTSpacing:=Value;
 UpdateHeight();
end;

procedure TBlnOptionButton.SetImages(const Value: TImageList);
begin
 FImages:=Value;
 if FImages<>nil then
   FTextLSpacing:=LeftSpacing+FImages.Width+MarginSpacing
 else
   FTextLSpacing:=LeftSpacing+MarginSpacing;
 FTextTSpacing:=3;
 UpdateHeight();
end;

procedure TBlnOptionButton.SetMarginSpacing(const Value: integer);
begin
 FMarginSpacing:=Value;
 if FImages<>nil then
  FTextLSpacing:=LeftSpacing+FImages.Width+FMarginSpacing
 else
  FTextLSpacing:=LeftSpacing+MarginSpacing;
 UpdateHeight();
end;

procedure TBlnOptionButton.UpdateHeight;
var
 NewHeight: Integer;
 CString: array[0..255] of Char;
 r: TRect;
begin
 if not Self.Visible then
  exit;
 if Canvas=nil then
  exit;
 //NewHeight:=0;
 StrPCopy(CString, Caption);
 r:=Rect(TextLSpacing, TextTSpacing, Width-2, Height-2);
 NewHeight:=DrawText(Canvas.Handle, CString, -1, r,
      DT_LEFT or DT_WORDBREAK or DT_EXPANDTABS or DT_CALCRECT); //Вычисляем высоту текста
 if FImages<>nil then
  NewHeight:=Max(NewHeight+6, Self.FImages.Height)
 else
  NewHeight:=NewHeight+6;
 NewHeight:=NewHeight-1;
 Self.SetBounds(Self.Left, self.Top, Self.width, NewHeight);
end;

procedure TBlnOptionButton.DrawPicture();
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
 //Canvas.FillRect(Canvas.ClipRect);
 //Canvas.Refresh;
 try
   Images.GetBitmap(num, b);
   b.TransparentMode:=tmFixed;
   b.Transparent:=True;
   Canvas.Draw(LeftSpacing, TopSpacing, b);
 except
 end;
end;

procedure TBlnOptionButton.MyDrawFocusRect(aPenMode: TPenMode);
var
 r: TRect;
begin
 if Self.Focused then
  begin
   Canvas.Brush.Style:=bsClear;
   Canvas.Pen.Mode:=pmCopy;//aPenMode;
   Canvas.Pen.Style:=psDot;
   Canvas.Pen.Color:=Self.Color;

   r:=Rect(TextLSpacing-3, TextTSpacing-3, Width-1, Height-1);

   Canvas.MoveTo(r.Left, r.Top);
   Canvas.LineTo(r.Right, r.Top);
   Canvas.LineTo(r.Right, r.Bottom);
   Canvas.LineTo(r.Left, r.Bottom);
   Canvas.LineTo(r.Left, r.Top);
  end;
 DrawButtonText()
end;

procedure TBlnOptionButton.DrawButtonText();
var
  CString: array[0..255] of Char;
  TextBounds: TRect;
begin
  TextBounds:=Rect(TextLSpacing, TextTSpacing, Width-2, Height-2);
  StrPCopy(CString, Caption);
  DrawText(Canvas.Handle, CString, -1, TextBounds,
      DT_LEFT or DT_WORDBREAK or DT_EXPANDTABS);
end;

constructor TBlnOptionButton.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 Self.Visible:=false;
 Self.B:=TBitmap.Create;
 FFont:=TFont.Create;

 FLeftSpacing:=2;
 FTopSpacing:=4;
 FMarginSpacing:=5;
 FTextLSpacing:=18;
 FTextTSpacing:=FTopSpacing;
 FWasFocus:=false;

 Width:=200;
 Height:=22;
 
 Self.TabStop:=true;
end;

destructor TBlnOptionButton.Destroy;
begin
 B.free;
 FFont.Free;
 inherited Destroy;
end;

procedure TBlnOptionButton.WndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
  case Message.Msg of
    WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:
      if not Focused then
        Windows.SetFocus(Handle);
    WM_SIZE:
     begin
       UpdateHeight;
       //Invalidate;
     end;
    WM_MOVE: Invalidate;
    CM_VISIBLECHANGED:
     begin
      if Visible then
       UpdateHeight;
     end;
  end;
end;

procedure TBlnOptionButton.WMSize(var Message: TWMSize);
begin
 inherited;
 Self.Width:=Message.Width;
 Self.Height:=Message.Height;
 Invalidate;
end;

procedure TBlnOptionButton.KeyDownW(var Message: TMessage);
begin
 if Message.WParam=13 then
  Self.Click;
 inherited;
end;

procedure TBlnOptionButton.PaintW(var Message: TMessage);
begin
  inherited;
  DrawPicture();
  MyDrawFocusRect(pmCopy);
end;

procedure TBlnOptionButton.MouseOver(var Message: TMessage);
begin
  inherited;
  ButtonState:=bsUp;
  Invalidate;
end;

procedure TBlnOptionButton.MouseLeave(var Message: TMessage);
begin
  inherited;
  if ButtonState = bsUp then
   begin
    ButtonState:=bsNormal;
    Invalidate;
   end;
end;

procedure TBlnOptionButton.MouseDownW(var Message: TMessage);
//var
 //r: TRect;
begin
  inherited;
  ButtonState:=bsDown;
  Invalidate;
  //r:=Rect(Self.Left, Self.Top, Self.Left+Self.Width, Self.Top+Self.Height);
  //InvalidateRect(Self.Parent.Handle, @r, true);
  SendMessage(Handle, BM_SETSTYLE, 0, 1);
end;

procedure TBlnOptionButton.MouseUpW(var Message: TMessage);
//var
// r: TRect;
begin
  inherited;
  ButtonState:=bsUp;
  Invalidate;
  //r:=Rect(Self.Left, Self.Top, Self.Left+Self.Width, Self.Top+Self.Height);
  //InvalidateRect(Self.Parent.Handle, @r, true);
end;

procedure TBlnOptionButton.WMEraseBkgnd(var Msg: TWMEraseBkgnd);
begin
  //Inherited;
  DefaultHandler(Msg);
  Msg.Result := 1;           // Prevent background from getting erased
end;

procedure TBlnOptionButton.CMFocusChanged(var Message: TCMFocusChanged);
var
 r: Trect;
begin
  if Self.Focused then
   begin
    MyDrawFocusRect(pmCopy);
    cleared:=false;
   end
  else
   begin
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

procedure TBlnOptionButton.CMDialogChar(var Message: TCMDialogChar);
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

procedure TBlnOptionButton.Click;
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
  RegisterComponents('MSBallon', [TBlnOptionButton]);
end;

end.
