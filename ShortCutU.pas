unit ShortCutU;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs, StdCtrls, Buttons, ExtCtrls, ShellApi;

type TShortCut=class(TSpeedButton)
     private

       FX0,FY0:Integer;
       FIsDrag,FDraging:Boolean;
       FExeName:String;
       FPath:String;
       FParamStr:String;
       FWnStyle:Integer;

       procedure SetPath(const Value:String);

     protected

       procedure MouseDown(Button: TMouseButton; Shift:TShiftState; X,Y:Integer); override;
       procedure MouseMove(Shift: TShiftState; X, Y:Integer); override;
       procedure MouseUp(Button: TMouseButton; Shift:TShiftState; X,Y:Integer); override;

     public

       constructor Create(AOwner: TComponent); override;

       procedure Click; override;

       property ExeName:String read FExeName write FExeName;
       property Path:String read FPath write SetPath;
       property ParamStr:String read FParamStr write FParamStr;
       property WnStyle:Integer read FWnStyle write FWnStyle;

     end;

implementation

uses MainU;

{ TShortCut }

procedure TShortCut.Click;
 begin
  if FIsDrag then Exit;
  inherited;
  ShellExecute(0,'open',PChar(Path+ExeName),PChar(ParamStr),PChar(Path),WnStyle);
 end;

constructor TShortCut.Create(AOwner: TComponent);
 begin
  inherited;
  FX0:=0; FY0:=0;
  FDraging:=False;
  Transparent:=True;
  Flat:=True;
  LayOut:=blGlyphTop;
  ShowHint:=True;
 end;

procedure TShortCut.MouseDown(Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
 begin
  inherited;
//  FIsDrag:=False; FDraging:=True; FX0:=x; FY0:=y;
 end;

procedure TShortCut.MouseMove(Shift: TShiftState; X, Y: Integer);
 begin
  inherited;
{  if FDraging then
   begin
    FIsDrag:=True;
    if (Left+X-FX0>=0) and (Left+X-FX0+Width<Screen.Width) then
     Left:=Left+X-FX0;
    if (Top+Y-FY0>=0) and (Top+Y-FY0+Height<Screen.Height-MainF.pnTask.Height) then
     Top:=Top+Y-FY0;
   end;
}
 end;

procedure TShortCut.MouseUp(Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
 begin
  inherited;
//  FDraging:=False;
 end;

procedure TShortCut.SetPath(const Value:String);
 begin
  FPath:=IncludeTrailingBackSlash(Value);
 end;

end.
