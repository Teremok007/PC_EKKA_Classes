Unit Apteks;

Interface

Uses Forms,SysUtils,StdCtrls,Windows,Graphics,Dialogs,ComCtrls,Classes,ADODB;

Type TCustomApteka=class
     private

       FID:Integer;
       FApteka:String;
       FEKKA_NAME:String;
       FBasePath:String;

       FSourceName:String;
       FTypeNakl:Integer;
       FShortName:String;

       FID_1C:String;
       FID_1CCHP:String;
       FID_SPDFL:String;
       FID_FIRM:String;
       FChp:Integer;
       FKod_GAMMA:String;
       FKod_SPDFL:String;
       FManager:Integer;

       FIP:String;
       FBase:String;
       FBUser:String;
       FBPassw:String;
       FPEKKA_NET:String;
       FClosed:Integer;

       function GetFullName:String;

     protected

       FTypePoint:Integer;

     public

       property  ID:Integer read FID write FID;
       property  Apteka:String read FApteka write FApteka;
       property  EKKA_NAME:String read FEKKA_NAME write FEKKA_NAME;
       property  BasePath:String read FBasePath write FBasePath;
       property  ID_1C:String read FID_1C write FID_1C;
       property  ID_1CCHP:String read FID_1CCHP write FID_1CCHP;
       property  ID_SPDFL:String read FID_SPDFL write FID_SPDFL;
       property  ID_FIRM:String read FID_FIRM write FID_FIRM;
       property  Chp:Integer read FChp write FChp;
       property  TypeNakl:Integer read FTypeNakl write FTypeNakl;
       property  TypePoint:Integer read FTypePoint write FTypePOint;
       property  SourceName:String read FSourceName write FSourceName;
       property  ShortName:String read FShortName write FShortName;
       property  FullName:String read GetFullName;
       property  Kod_GAMMA:String read FKod_GAMMA write FKod_GAMMA;
       property  Kod_SPDFL:String read FKod_SPDFL write FKod_SPDFL;
       property  Manager:Integer read FManager write FManager;
       property  IP:String read FIP write FIP;
       property  Base:String read FBase write FBase;
       property  BUser:String read FBUser write FBUser;
       property  BPassw:String read FBPassw write FBPassw;
       property  PEKKA_NET:String read FPEKKA_NET write FPEKKA_NET;
       property  Closed:Integer read FClosed write FClosed;

     end;

     TCustomApteks=class
     private

       FSQL:String;

       procedure InitQruery;

       function  GetCount:Integer;

     protected

       FQr:TADOQuery;
       FList:Array of TCustomApteka;

       procedure InitList; virtual;

       function  GetApteka(Index:Integer):TCustomApteka;

     public

       constructor Create;
       destructor Destroy; override;

       procedure Clear; virtual;
       procedure CreateList; virtual;

       function  AptekaByID(ID:Integer):TCustomApteka;

       property  Qr:TADOQuery read FQr write FQr;
       property  Count:Integer read GetCount;
       property  Items[Index:Integer]:TCustomApteka read GetApteka;
       property  SQL:String read FSQL write FSQL;

     end;

Implementation

{ TCustomApteka }

function TCustomApteka.GetFullName: String;
 begin
  if FTypePoint=1 then Result:='Аптека "'+Apteka+ '"'
                  else Result:='Аптеч. киоск "'+Apteka+ '"';
 end;

{ TCustomApteks }

procedure TCustomApteks.Clear;
var i:Integer;
 begin
  for i:=Low(Flist) to High(Flist) do FList[i].Free;
  SetLength(FList,0);
 end;

constructor TCustomApteks.Create;
 begin
  inherited;
  SetLength(FList,0);
  FQr:=nil;
  FSQL:='select * from ekka_net..Apteks order by Apteka';
 end;

procedure TCustomApteks.InitQruery;
 begin
  if FQr=nil then Exit;
  FQr.Close;
  FQr.SQL.Text:=FSQL;
  FQr.Open;
  Clear;
  SetLength(Flist,FQr.RecordCount);
 end;

procedure TCustomApteks.InitList;
var i:Integer;
 begin
  if FQr=nil then Exit;
  for i:=1 to FQr.RecordCount do
   begin
    if i=1 then FQr.First else FQr.Next;
    Flist[i-1]:=TCustomApteka.Create;
   end;
 end;

procedure TCustomApteks.CreateList;
var i:Integer;
 begin
  if FQr=nil then Exit;
  InitQruery;
  InitList;
  for i:=1 to FQr.RecordCount do
   begin
    if i=1 then FQr.First else FQr.Next;
    FList[i-1].ID:=FQr.FieldByName('ID_APTEKA').AsInteger;
    FList[i-1].Apteka:=FQr.FieldByName('APTEKA').AsString;
    FList[i-1].TypePoint:=FQr.FieldByName('TypePoint').AsInteger;
    FList[i-1].SourceName:=FQr.FieldByName('SourceName').AsString;
    FList[i-1].EKKA_NAME:=FQr.FieldByName('DestName').AsString;
    FList[i-1].BasePath:=FQr.FieldByName('BasePath').AsString;
    FList[i-1].TypeNakl:=FQr.FieldByName('TypeNakl').AsInteger;
    FList[i-1].ID_1C:=FQr.FieldByName('ID_1C').AsString;
    FList[i-1].ID_1CCHP:=FQr.FieldByName('ID_1CCHP').AsString;
    FList[i-1].ID_SPDFL:=FQr.FieldByName('ID_SPDFL').AsString;
    FList[i-1].ID_FIRM:=FQr.FieldByName('ID_FIRM').AsString;
    FList[i-1].Kod_SPDFL:=FQr.FieldByName('Kod_SPDFL').AsString;
    FList[i-1].Kod_GAMMA:=FQr.FieldByName('Kod_GAMMA').AsString;
    FList[i-1].Manager:=FQr.FieldByName('Manager').AsInteger;
    FList[i-1].Chp:=FQr.FieldByName('CHP').AsInteger;
    FList[i-1].ShortName:=FQr.FieldByName('Cap').AsString;
    FList[i-1].IP:=FQr.FieldByName('IP').AsString;
    FList[i-1].Base:=FQr.FieldByName('Base').AsString;
    FList[i-1].BUser:=FQr.FieldByName('BUser').AsString;
    FList[i-1].BPassw:=FQr.FieldByName('BPassw').AsString;
    FList[i-1].PEKKA_NET:=FQr.FieldByName('PEKKA_NET').AsString;
    FList[i-1].Closed:=FQr.FieldByName('Closed').AsInteger;
   end;
 end;

destructor TCustomApteks.Destroy;
 begin
  Clear;
  inherited;
 end;

function TCustomApteks.GetApteka(Index:Integer):TCustomApteka;
var Ind:Integer;
 begin
  if High(FList)<0 then begin Result:=nil; Exit; end;
  if Index<Low(FList) then Ind:=Low(FList) else
  if Index>High(FList) then Ind:=High(FList)
                       else Ind:=Index;
  Result:=FList[Ind];
 end;

function TCustomApteks.GetCount:Integer;
 begin
  Result:=High(FList)-Low(FList)+1;
 end;

function TCustomApteks.AptekaByID(ID:Integer):TCustomApteka;
var i:Integer;
 begin
  Result:=nil;
  for i:=0 to Count-1 do
   if Items[i].ID=ID then
    begin
     Result:=Items[i];
     Break;
    end;
 end;

End.



