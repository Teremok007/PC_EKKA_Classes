unit ComponentPlus;

interface

Uses Windows,Classes, StdCtrls, Controls;

type TComboPlus = class (TWinControl)

     private
       FCombo:TComboBox;
       FList:TListBox;

       FLeft:Integer;
       FTop:Integer;
       FWidth:Integer;
       FHeight:Integer;
     protected
       Procedure SetLeft(V:Integer);
       Procedure SetTop(V:Integer);
       Procedure SetWidth(V:Integer);
       Procedure SetHeight(V:Integer);
     public
       constructor Create(AOwner:TComponent); override;
       destructor Destroy; override;

     published
       property Left:Integer read FLeft write SetLeft;
       property Top:Integer read FTop write SetTop;
       property Width:Integer read FWidth write SetWidth;
       property Height:Integer read FHeight write SetHeight;

     end;

implementation

constructor TComboPlus.Create(AOwner:TComponent);
 begin
  inherited Create(AOwner);
  FCombo:=TComboBox.Create(AOwner);
  FList:=TListBox.Create(AOwner);
 end;

destructor TComboPlus.Destroy;
 begin
  FCombo.Free;
  FList.Free;
  inherited Destroy;
 end;

end.
