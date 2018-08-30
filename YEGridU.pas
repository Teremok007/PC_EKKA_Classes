Unit YEGridU;

Interface

Uses Windows, Messages, SysUtils, Classes, Controls, Grids;

type

  TYEGrid = class (TStringGrid)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  private
                                
  end;

Implementation

constructor TYEGrid.Create(AOwner:TComponent);
 begin
  inherited Create(AOwner);
  FixedCols:=0;
  DefaultRowHeight:=17;
 end;

destructor TYEGrid.Destroy;
 begin
  inherited Destroy;
 end;

End.
