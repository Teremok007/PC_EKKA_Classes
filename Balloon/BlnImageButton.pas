unit BlnImageButton;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, ImgList,
  BlnSpeedButton;

type
  TBlnImageButton = class(TGraphicControl)
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  private
    B: TBitmap;
    FColor: TColor;
    FTransparent: Boolean;
    FImages: TImageList;
    FModalResult: TModalResult;
    FCloseParentFormOnClick: Boolean;
    procedure SetImages(const Value: TImageList);
  protected
    MouseOnControl: boolean;
    ButtonState: TBlnButtonState;
    procedure DrawPicture();
    procedure PaintW(var Message: TMessage); message WM_PAINT;
    procedure MouseOver(var Message: TMessage); message CM_MOUSEENTER;
    procedure MouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure MouseDownW(var Message: TMessage); message WM_LBUTTONDOWN;
    procedure MouseUpW(var Message: TMessage); message WM_LBUTTONUP;
  public
    { Public declarations }
    procedure Click; override;
  published
    property Transparent: Boolean read FTransparent write FTransparent;
    property Color: TColor read FColor write FColor default $00E1FFFF;
    property Images: TImageList read FImages write SetImages;
    property ModalResult: TModalResult read FModalResult write FModalResult default 0;
    property CloseParentFormOnClick: Boolean read FCloseParentFormOnClick write FCloseParentFormOnClick default false;
  end;

implementation

constructor TBlnImageButton.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 Self.B:=TBitmap.Create;
 Self.FTransparent:=True;
 CloseParentFormOnClick:=false;
end;

destructor TBlnImageButton.Destroy;
begin
 Self.B.free;
 inherited Destroy;
end;

procedure TBlnImageButton.SetImages(const Value: TImageList);
begin
 FImages:=Value;
 if FImages<>nil then
  begin
   Self.Height:=FImages.Height;
   Self.Width:=FImages.Width;
  end;
end;

procedure TBlnImageButton.DrawPicture();
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

procedure TBlnImageButton.PaintW(var Message: TMessage);
begin
  inherited;
  DrawPicture();
end;

procedure TBlnImageButton.MouseOver(var Message: TMessage);
begin
  inherited;
  ButtonState:=bsUp;
  Invalidate;
  MouseOnControl:=true; //чтобы занать что мышь пришла
end;

procedure TBlnImageButton.MouseLeave(var Message: TMessage);
begin
  inherited;
  if ButtonState = bsUp then //Чтобы когда мышь уходит при назатой конопке, она оставалась нажатой
   begin
    ButtonState:=bsNormal;
    Invalidate;
   end;
  MouseOnControl:=false; //мышь ушла
end;

procedure TBlnImageButton.MouseDownW(var Message: TMessage);
begin
  inherited;
  ButtonState:=bsDown;
  Invalidate; //Говорим перерирвоать себя
end;

procedure TBlnImageButton.MouseUpW(var Message: TMessage);
begin
  inherited;
  if MouseOnControl then
   ButtonState:=bsUp
  else
   ButtonState:=bsNormal;

  //Перерисовать себя и под нами
  Invalidate;
end;

procedure TBlnImageButton.Click;
begin
 Inherited Click;
 if CloseParentFormOnClick then
  GetParentForm(Self).Close;
end;


end.
