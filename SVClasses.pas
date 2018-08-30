UNIT SVClasses;

INTERFACE

Uses Windows,Classes,SysUtils;

Type TArrComponent=class
     private
       FList:Array of TObject;
       procedure SetObject(Index: Integer; const Value:TObject);

       function GetObject(Index:Integer):TObject;
       function GetLastItem:TObject;

     public

       constructor Create; virtual;
       destructor Destroy; override;

       procedure Clear;
       procedure Add;                         DBGrids

       function Count:Integer;

       property Items[Index:Integer]:TObject read GetObject write SetObject;
       property LastItem:TObject read GetLastItem;

     end;

IMPLEMENTATION

{ TArrComponent }

procedure TArrComponent.Add;
var CA:Integer;
 begin
  CA:=High(FList)+1; SetLength(FList,CA+1);
 end;

procedure TArrComponent.Clear;
var i:Integer;
 begin
  for i:=Low(FList) to High(FList) do FList[i].Free;
  SetLength(FList,0);
 end;

function TArrComponent.Count:Integer;
 begin
  Result:=High(FList)-Low(FList)+1
 end;

constructor TArrComponent.Create;
 begin
  SetLength(FList,0);
 end;

destructor TArrComponent.Destroy;
 begin
  Clear;
  inherited;
 end;

function TArrComponent.GetLastItem:TObject;
 begin
  if High(FList)<0 then Result:=nil else Result:=FList[High(FList)];
 end;

function TArrComponent.GetObject(Index:Integer):TObject;
var FIndex:Integer;
 begin
  if High(FList)<0 then begin Result:=nil; Exit; end;
  if Index<Low(FList) then FIndex:=Low(FList) else
  if Index>High(FList) then FIndex:=High(FList) else FIndex:=Index;
  Result:=FList[FIndex];
 end;

procedure TArrComponent.SetObject(Index: Integer; const Value: TObject);
var FIndex:Integer;
 begin
  if High(FList)<0 then Exit;
  if Index<Low(FList) then FIndex:=Low(FList) else
  if Index>High(FList) then FIndex:=High(FList) else FIndex:=Index;
  Flist[FIndex]:=Value
 end;

END.
