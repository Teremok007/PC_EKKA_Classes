unit ElemClasses;

interface

uses SysUtils,Classes,Dialogs,Forms,Windows;

type

 EExcept = class(Exception)   // Собственный класс обработки исключений
  public
    procedure ShowMsgError; overload;
    procedure ShowMsgError(Cap:String); overload;
 end;

 TBase = class(TPersistent) // Класс Шаблон
  private
    FCaption:String;
    FCode:Integer;
    procedure SetCaption(Value:String); virtual;
    procedure SetCode(Value:Integer); virtual;
  public
    procedure Assign(Source:TPersistent);
    property Caption:String read FCaption write SetCaption;
    property Code:Integer read FCode write SetCode;
 end;

 TObjArr = class (TPersistent)
  private
    FArr:Array of TObject;
    function GetCount:Integer;
    function GetHigh:Integer;
    function GetLow:Integer;
    function Get(Index:Integer):TObject;
    procedure Put(Index:Integer; Value:TObject);
  public
    destructor Destroy; override;
    procedure Add;
    procedure Clear;
    procedure Delete(Index:Integer);
    property Count:Integer read GetCount;
    property LowA:Integer read GetLow;
    property HighA:Integer read GetHigh;
    property Items[Index:Integer]:TObject read Get write Put;
 end;

 TApteka = class(TBase) // Класс Аптека
  private
    FBasePath:String;
    FSourceName:String;
    FDestName:String;            
    FTypeNakl:Integer;
    procedure SetBasePath(Value:String);
    procedure SetSourceName(Value:String);
    procedure SetDestName(Value:String);
    procedure SetTypeNakl(Value:Integer);
  public
    procedure Assign(Source:TPersistent);
    property BasePath:String read FBasePath write SetBasePath;
    property SourceName:String read FSourceName write SetSourceName;
    property DestName:String read FDestName write SetDestName;
    property TypeNakl:Integer read FTypeNakl write SetTypeNakl;
 end;

 TApteks = class(TObjArr) // Класс Аптеки
  private
    function  Get(Index:Integer):TApteka;
    procedure Put(Index:Integer; Value:TApteka);
  public
    procedure Assign(Source:TPersistent);
    procedure Add(Value:TApteka);
    property Items[Index:Integer]:TApteka read Get write Put;
 end;

 TBlock = class(TPersistent)
  private
    FStore:String;
  public
    procedure Assign(Source:TPersistent);
    property Store:String read FStore write FStore;
 end;

 TFileOptions = class(TObjArr) // Базовый клас для работы с файлами настроек
  private
    FFileName:String;
    procedure SetFileName(Value:String);
    function  Get(Index:Integer):TBlock;
    procedure Put(Index:Integer; Value:TBlock);
    function  RWFile(Param:Integer):Boolean;
    procedure Add(Value:TBlock);
    procedure PrepareData; virtual; abstract;
    function  ExtractData:Boolean; virtual; abstract;
    property Items[Index:Integer]:TBlock read Get write Put;
  public
    constructor Create; overload;
    constructor Create(CrFile:String); overload;
    procedure AddStr(Value:String);
    function WriteToFile:Boolean;
    function ReadFromFile:Boolean;
    property FileName:String read FFileName write SetFileName;
 end;

 TApteksFile = class(TFileOptions) // Класс 'Файл настройки аптек'
    FApteks:TApteks;
    procedure Put(Value:TApteks);
    procedure PrepareData; virtual;
    function  ExtractData:Boolean; virtual;
  public
    constructor Create;
    destructor Destroy;
    property Apteks:TApteks read FApteks write Put;
 end;

implementation

// Методы класса EExcept;
procedure EExcept.ShowMsgError;
 begin
  ShowMessage(Message);
 end;

procedure EExcept.ShowMsgError(Cap:String);
var A:TApplication;
 begin
  try
   A:=TApplication.Create(nil);
   try
    A.MessageBox(PChar(Message),PChar(Cap),MB_ICONWARNING+MB_OK);
   finally
    A.Free;
   end; 
  except
   ShowMessage(Message);
  end;
 end;

procedure TBlock.Assign(Source:TPersistent);
 begin
  if Source is TBlock then
   Store:=TBlock(Source).Store;
 end;

// Методы класса TObjArr
procedure TObjArr.Add;
var CA:Integer;
 begin
  try
   CA:=High(FArr)+1;
   SetLength(FArr,CA+1);
  except
   raise EExcept.Create('Ошибка выделения памяти.');
  end;
 end;

function TObjArr.GetCount:Integer;
 begin
  Result:=High(FArr)-Low(FArr)+1;
 end;

function TObjArr.GetHigh:Integer;
 begin
  Result:=High(FArr);
 end;

function TObjArr.GetLow:Integer;
 begin
  Result:=Low(FArr);
 end;

function TObjArr.Get(Index:Integer):TObject;
 begin
  if Index>HighA then
   raise EExcept.Create('Выход за границу диапазона.')
  else
   Result:=FArr[Index];
 end;

procedure TObjArr.Put(Index:Integer; Value:TObject);
 begin
  if Index>HighA then
   raise EExcept.Create('Выход за границу диапазона.')
  else
 end;

destructor TObjArr.Destroy;
 begin
  Clear;
  inherited Destroy;
 end;

procedure TObjArr.Clear;
 begin
  try
   SetLength(FArr,0);
  except
   raise EExcept.Create('Ошибка освобождения памяти.');
  end;
 end;

procedure TObjArr.Delete(Index:Integer);
var CA,i:Integer;
 begin
  if Index>HighA then raise EExcept.Create('Выход за границу диапазона.');
  try
   CA:=HighA-1;
   for i:=Index to CA do FArr[i]:=FArr[i+1];
   SetLength(FArr,CA);
  except
   raise EExcept.Create('Ошибка удаление елемента массива.');
  end;
 end;

// Методы класса "ШАБЛОН"
procedure TBase.SetCaption(Value:String);
 begin
  FCaption:=Value;
 end;

procedure TBase.SetCode(Value:Integer);
 begin
  FCode:=Value;
 end;

procedure TBase.Assign(Source:TPersistent);
 begin
  if Source is TBase then
   begin
    Caption:=TBase(Source).Caption;
    Code:=TBase(Source).Code;
   end;
 end;

// Методы класса "АПТЕКА"
procedure TApteka.SetBasePath(Value:String);
 begin
  FBasePath:=ExcludeTrailingBackSlash(Value)
 end;

procedure TApteka.SetDestName(Value:String);
 begin
  FDestName:=ExcludeTrailingBackSlash(Value)
 end;

procedure TApteka.SetSourceName(Value:String);
 begin
  FSourceName:=ExcludeTrailingBackSlash(Value)
 end;

procedure TApteka.SetTypeNakl(Value:Integer);
 begin
  FTypeNakl:=Value;
 end;

procedure TApteka.Assign(Source:TPersistent);
 begin
  if Source is TApteka then
   begin
    BasePath:=TApteka(Source).BasePath;
    DestName:=TApteka(Source).DestName;
    SourceName:=TApteka(Source).SourceName;
    TypeNakl:=TApteka(Source).TypeNakl;
   end;
  inherited Assign(Source);
 end;

// Методы класса "АПТЕКИ"
function TApteks.Get(Index:Integer):TApteka;
 begin
  Result:=TApteka(inherited Get(Index));
 end;

procedure TApteks.Put(Index:Integer; Value:TApteka);
 begin
  TApteka(FArr[Index]).Assign(Value);
 end;

procedure TApteks.Add(Value:TApteka);
 begin
  inherited Add;
  FArr[HighA]:=TApteka.Create;
  if Value<>nil then Put(HighA,Value);
 end;

procedure TApteks.Assign(Source:TPersistent);
var i:Integer;
 begin
  if Source is TApteks then
   begin
    Clear;
    for i:=TApteks(Source).LowA to TApteks(Source).HighA do
     Add(TApteks(Source).Items[i]);
   end;
 end;

// Методы класса "TFileOptions"
constructor TFileOptions.Create(CrFile:String);
 begin
  inherited Create;
  FFileName:=CrFile;
 end;

constructor TFileOptions.Create;
 begin
  inherited Create;
 end;

procedure TFileOptions.AddStr(Value:String);
var B:TBlock;
 begin
  try
   B:=TBlock.Create;
   try
    B.Store:=Value;
    Add(B);
   finally
    B.Free;
   end
  except
   raise EExcept.Create('Ошибка выделения памяти.');
  end;
 end;
 
procedure TFileOptions.SetFileName(Value:String);
 begin
  FFileName:=Value;
 end;

procedure TFileOptions.Put(Index:Integer; Value:TBlock);
 begin
  TBlock(FArr[Index]).Assign(Value);
 end;

function TFileOptions.Get(Index:Integer):TBlock;
 begin
  Result:=TBlock(inherited Get(Index));
 end;

procedure TFileOptions.Add(Value:TBlock);
 begin
  inherited Add;
  FArr[HighA]:=TBlock.Create;
  if (Value<>nil) then Put(HighA,Value);
 end;

function TFileOptions.RWFile(Param:Integer):Boolean;
var F:Text;
    i:Integer;
    B:Boolean;
    S:String;
    Bl:TBlock;
 begin
  B:=False;
  try
   System.Assign(f,FileName);
   Case Param of
    1:ReSet(F);
    2:ReWrite(F);
   end;
   B:=True;
   Case Param of
    1:begin
       Clear; Bl:=TBlock.Create;
       try
        While Not Eof(f) do
         begin
          ReadLn(F,S); Bl.Store:=S; Add(Bl);
         end;
        ExtractData;
       finally
        Bl.Free;
       end;
      end;
    2:begin
       PrepareData;
       for i:=LowA to HighA do WriteLn(F,Items[i].Store);
      end;
    end;
   Close(F);
   B:=False;
   Result:=True;
  except
   if B then Close(F); Result:=False;
  end;
 end;

function TFileOptions.WriteToFile:Boolean;
 begin
  Result:=RWFile(2);
 end;

function TFileOptions.ReadFromFile:Boolean;
 begin
  Result:=RWFile(1);
 end;

// Методы класса TApteksFile
constructor TApteksFile.Create;
 begin
  inherited Create;
  FApteks:=TApteks.Create;
 end;

destructor TApteksFile.Destroy;
 begin
  FApteks.Free;
  inherited Destroy;
 end;

procedure TApteksFile.Put(Value:TApteks);
 begin
  FApteks.Assign(Value);
 end;

function TApteksFile.ExtractData:Boolean;
var q,i:Integer;
    A:TApteka;
 begin
  if Count mod 6<>0 then begin Result:=False; Exit; end;
  try
   q:=0; Apteks.Clear;
   A:=TApteka.Create;
   try
    for i:=0 to (Count mod 6)-1 do
     begin
      A.BasePath:=Items[q].Store;
      A.SourceName:=Items[q].Store;
      A.DestName:=Items[q].Store;
      A.TypeNakl:=StrToInt(Items[q].Store);
      A.Caption:=Items[q].Store;
      A.Code:=StrToInt(Items[q].Store);
      Apteks.Add(A);
      Inc(q);
     end;
   finally
    A.Free;
   end;
   Result:=True;
  except
   Result:=False;
  end;
 end;

procedure TApteksFile.PrepareData;
var i:Integer;
 begin
  Clear;
  for i:=Apteks.LowA to Apteks.HighA do
   begin
    AddStr(Apteks.Items[i].BasePath);
    AddStr(Apteks.Items[i].SourceName);
    AddStr(Apteks.Items[i].DestName);
    AddStr(IntToStr(Apteks.Items[i].TypeNakl));
    AddStr(Apteks.Items[i].Caption);
    AddStr(IntToStr(Apteks.Items[i].Code));
   end;
 end;

end.
