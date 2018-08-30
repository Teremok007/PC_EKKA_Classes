unit BlnCheckBox;

interface

uses
 Windows, Messages, Graphics, BlnOptionButton;

type
 TBlnCheckBox = class(TBlnOptionButton)
 protected
   FChecked: Boolean;
   procedure DrawPicture(); override;
   procedure KeyDownW(var Message: TMessage); message WM_KEYDOWN;
 public
   { Public declarations }
   procedure Click; override;
 published
   property Checked: Boolean read FChecked write FChecked;
 end;

implementation

procedure TBlnCheckBox.DrawPicture();
var
 b: TBitmap;
begin
 if Self.Images<>nil then
  inherited DrawPicture
 else
  begin
   b:=TBitmap.Create;
   b.Width:=13;
   b.Height:=13;
   //b.Transparent:=true;
   b.Canvas.Brush.Color:=$00FFFFFF;
   b.Canvas.Brush.Style:=bsSolid;
   b.Canvas.Rectangle(0,0,b.Width,b.Height);
   b.Canvas.Pen.Color:=$808080;
   b.Canvas.MoveTo(0, 0);
   b.Canvas.LineTo(0, b.Height-1);
   b.Canvas.MoveTo(0, 0);
   b.Canvas.LineTo(b.Width-1, 0);
   b.Canvas.Pen.Color:=$404040;
   b.Canvas.MoveTo(1, 1);
   b.Canvas.LineTo(1, b.Height-2);
   b.Canvas.MoveTo(1, 1);
   b.Canvas.LineTo(b.Width-2, 1);
   b.Canvas.Pen.Color:=$C8D0D4;
   b.Canvas.MoveTo(b.Width-2, b.Height-2);
   b.Canvas.LineTo(b.Width-2, 1);
   b.Canvas.MoveTo(b.Width-2, b.Height-2);
   b.Canvas.LineTo(1, b.Height-2);
   b.Canvas.Pen.Color:=$00FFFFFF;
   b.Canvas.MoveTo(b.Width-1, b.Height-1);
   b.Canvas.LineTo(b.Width-1, -1);
   b.Canvas.MoveTo(b.Width-1, b.Height-1);
   b.Canvas.LineTo(-1, b.Height-1);
   if FChecked then
    begin
     b.Canvas.Pen.Color:=0;
     b.Canvas.Pen.Width:=2;
     b.Canvas.MoveTo(3, b.Height div 2);
     b.Canvas.LineTo(5, b.Height-4);
     b.Canvas.LineTo(b.Width-3, 4);
    end;
   Canvas.Brush.Style:=bsClear;
   Canvas.Draw(LeftSpacing, TopSpacing, b);
   b.Free;
  end;
end;

procedure TBlnCheckBox.Click;
begin
  Checked:=not Checked;
  DrawPicture();
  inherited Click;
end;

procedure TBlnCheckBox.KeyDownW(var Message: TMessage);
begin
 inherited KeyDownW(Message);
 if Message.WParam=32 then
   Click;
end;

end.
