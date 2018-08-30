unit DiagU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TDiagF = class(TForm)
    BitBtn1: TBitBtn;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Timer1: TTimer;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

    Ex:Boolean;
    Path:String;

  end;

var
  DiagF: TDiagF;

implementation

uses MainU;

{$R *.dfm}

procedure TDiagF.BitBtn1Click(Sender: TObject);
 begin
  Close;
 end;

procedure TDiagF.FormActivate(Sender: TObject);
 begin
  if Ex then Image1.Visible:=True
        else Image2.Visible:=True; 
 end;

procedure TDiagF.Timer1Timer(Sender: TObject);
 begin
  if Not(DirectoryExists(Path)) then Close;
 end;

end.
