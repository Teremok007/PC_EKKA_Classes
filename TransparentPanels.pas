unit TransparentPanels;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls, Windows, Graphics, Messages, Forms;

type
  TTransparentPanel = class(TPanel)
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    
  end;

procedure Register;

implementation

procedure Register;
 begin
  RegisterComponents('Standard', [TTransparentPanel]);
 end;
 
procedure CopyParentImage(Control: TControl; Dest: TCanvas);
var
  I, Count, X, Y, SaveIndex: Integer;
  DC: HDC;
  R, SelfR, CtlR: TRect;
begin
  if (Control = nil) or (Control.Parent = nil) then Exit;
  Count := Control.Parent.ControlCount;
  DC := Dest.Handle;
{$IFDEF WIN32}
  with Control.Parent do
  ControlState := ControlState + [csPaintCopy];
  try
{$ENDIF}
    with Control do
    begin
      SelfR := Bounds(Left, Top, Width, Height);
      X := -Left; Y := -Top;
    end;
    SaveIndex := SaveDC(DC);
    try
      SetViewportOrgEx(DC, X, Y, nil);
      IntersectClipRect(DC, 0, 0, Control.Parent.ClientWidth, Control.Parent.ClientHeight);
      with TWinControl(Control.Parent) do
      begin
        Perform(WM_ERASEBKGND, DC, 0);
        Perform(WM_PAINT, DC, 0);
      end;
    finally
      RestoreDC(DC, SaveIndex);
    end;
    for I := 0 to Count - 1 do
    begin
      if Control.Parent.Controls[i] = Control then
      Break
      else
      if Control.Parent.Controls[i] <> nil then
      begin
        with TGraphicControl(Control.Parent.Controls[i]) do
        begin
          CtlR := Bounds(Left, Top, Width, Height);
          if Bool(IntersectRect(R, SelfR, CtlR)) and Visible then
          begin
{$IFDEF WIN32}
            ControlState := ControlState + [csPaintCopy];
{$ENDIF}
            SaveIndex := SaveDC(DC);
            try
              SetViewportOrgEx(DC, Left + X, Top + Y, nil);
              IntersectClipRect(DC, 0, 0, Width, Height);
              Perform(WM_PAINT, DC, 0);
            finally
              RestoreDC(DC, SaveIndex);
{$IFDEF WIN32}
              ControlState := ControlState - [csPaintCopy];
{$ENDIF}
            end;
          end;
        end
      end;
    end;
{$IFDEF WIN32}
  finally
    with Control.Parent do
    ControlState := ControlState - [csPaintCopy];
  end;
{$ENDIF}
end;

constructor TTransparentPanel.Create(AOwner: TComponent);
begin
  inherited;
  Ctl3D := false;
  BorderStyle := bsNone;
end;

procedure TTransparentPanel.Paint;
begin
end;

procedure TTransparentPanel.WMEraseBkgnd(var Msg: TWMEraseBkgnd);
begin
  CopyParentImage(Self, Self.Canvas);
end;

end.