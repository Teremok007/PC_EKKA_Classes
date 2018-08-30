unit svButtons;

interface

uses Windows, Dialogs, Buttons, SysUtils, Variants, Classes, Graphics, Controls, StdCtrls, ExtCtrls, OpenLib, Util;

const brTabs=1;
      brBtns=2;

type TsvBtn = class(TPanel)
     private

      FIm:TImage;
      FBm:TBitMap;
      FLb:TLabel;
      FCaption:String;
      FColorDown:TColor;
      FColorUp:TColor;
      FRadius:Integer;
      FSelectTab:Boolean;
      FHint:String;
      FFLash:Boolean;

      procedure SetCaption(const Value:String);
      procedure SetColorDown(const Value:TColor);
      procedure SetColorUp(const Value:TColor);
      procedure SetRadius(const Value:Integer);
      procedure lbMouseEnter(Sender:TObject);
      procedure lbMouseLeave(Sender:TObject);
      procedure imClick(Sender:TObject);
      procedure SetSelectTab(const Value: Boolean);
      procedure SetKind(const Value: Byte);
      procedure SetHint(const Value: String);
      procedure SetFlash(const Value: Boolean);

      function GetBkColor:TColor;

     protected

      FKind:Byte;

     public

      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;

      procedure SetBounds(ALeft,ATop, AWidth, AHeight: Integer); override;

     published

      property Caption:String read FCaption write SetCaption;
      property ColorUp:TColor read FColorUp write SetColorUp;
      property ColorDown:TColor read FColorDown write SetColorDown;
      property Radius:Integer read FRadius write SetRadius;
      property SelectTab:Boolean read FSelectTab write SetSelectTab;
      property Glyph:TBitmap read FBm;
      property Kind:Byte read FKind write SetKind;
      property Hint:String read FHint write SetHint;
      property Flash:Boolean read FFLash write SetFlash;
      property OnClick;

     end;

     TsvBar=class;

     TsvTab = class(TCollectionItem)
     private

      FBtn:TsvBtn;

     protected

     public

      constructor Create(Collection: TCollection); override;
      destructor Destroy; override;

      property Btn:TsvBtn read FBtn;

     end;

     TTabClass= class of TsvTab;

     TsvTabs=class(TCollection)
     private

      FBar:TsvBar;

      function  GetTab(Index:Integer):TsvTab;
      procedure SetTab(Index:Integer; const Value:TsvTab);

     protected

     public

      constructor Create(Bar:TsvBar; TabClass:TTabClass);

      function Add:TsvTab;
      property Bar:TsvBar read FBar;
      property Items[Index:Integer]:TsvTab read GetTab write SetTab;

     end;


     TsvBar=class(TPanel)
     private

      FTabs:TsvTabs;
      FKind:Byte;

      procedure SetTabs(const Value:TsvTabs);
      procedure SetKind(const Value:Byte);

     protected

      function CreateTabs:TsvTabs;  dynamic;

     public

      constructor Create(AOwner:TComponent); override;
      destructor  Destroy; override;

      property Tabs:TsvTabs read FTabs write SetTabs;
      property Kind:Byte read FKind write SetKind;

     published

     end;


implementation

{ TsvTab }

const K1=0.9;
      K2=0.9;

constructor TsvBtn.Create(AOwner:TComponent);
 begin
  inherited;
  FHint:='';
  FIm:=TImage.Create(AOwner);
  FLb:=TLabel.Create(AOwner);
  FBm:=TBitMap.Create;

  FFlash:=False;

  FIm.Parent:=Self;
  FLb.Parent:=Self;

  BevelOuter:=bvNone;
  Caption:='';

  FSelectTab:=False;

  FColorUp:=$00A7B3BA;
  FColorDown:=$00C8D0D4;
  FRadius:=8;

  FLb.AutoSize:=False;
  FLb.Alignment:=taCenter;

  FLb.Left:=0;
  FLb.ShowHint:=True;
  FLb.Width:=Width;
  FLb.Top:=Height-14;

  FLb.Caption:=Name;
  FLb.Font.Color:=clNavy;

//  FLb.Anchors:=[akLeft,akRight,akBottom];

  FIm.Left:=0;
  FIm.Width:=Width;
  FIm.Top:=0;
  FIm.ShowHint:=True;
  FIm.Height:=Height;
//  FIm.Anchors:=[akTop,akLeft,akRight,akBottom];

  HighLightImage(FIm,FColorUp,FColorDown,FRadius,FSelectTab,GetBkColor,FBm,FKind,Trim(FCaption)<>'');

  FLb.Transparent:=True;

  FLb.OnMouseEnter:=lbMouseEnter;
  FLb.OnMouseLeave:=lbMouseLeave;
  FIm.OnClick:=imClick;
  FLb.OnClick:=imClick;

 end;

destructor TsvBtn.Destroy;
 begin
  FLb.Free;
  FIm.Free;
  FBm.Free;
  inherited;
 end;

procedure TsvBtn.lbMouseEnter(Sender:TObject);
 begin
  if Trim(FLb.Caption)='' then Exit;
  if Not Assigned(Sender) then Exit;
  if TLabel(Sender).Enabled=False then Exit;
  TLabel(Sender).Font.Style:=[fsUnderline];
 end;

procedure TsvBtn.lbMouseLeave(Sender: TObject);
 begin
  if Trim(FLb.Caption)='' then Exit;
  if Not Assigned(Sender) then Exit;
  if TLabel(Sender).Enabled=False then Exit;
  TLabel(Sender).Font.Style:=[];
 end;

procedure TsvBtn.SetBounds(ALeft,ATop,AWidth,AHeight:Integer);
 begin
  inherited;
  if Assigned(FIm) then
   begin
    FIm.Picture:=nil;
    FIm.Left:=0;
    FIm.Width:=AWidth;
    FIm.Top:=0;
    FIm.Height:=AHeight;

    FLb.Left:=0;
    FLb.Width:=AWidth;
    FLb.Top:=AHeight-18;
    HighLightImage(FIm,FColorUp,FColorDown,FRadius,FSelectTab,GetBkColor,FBm,FKind,Trim(FCaption)<>'');
   end;
 end;

procedure TsvBtn.SetCaption(const Value:String);
var dx,i:Integer;
 begin
  FCaption:=Value;
  FLb.Caption:=Value;
  SetBounds(Left,Top,TextPixWidth(Value,FLb.Font)+10,Height);
  if Assigned(Parent) then
    begin
     dx:=0;
     for i:=0 to TsvBar(Parent).Tabs.Count-1 do
      Inc(dx,TsvBar(Parent).Tabs.Items[i].Btn.Width);
    TsvBar(Parent).Width:=dx+1;
   end;
 end;

procedure TsvBtn.SetColorDown(const Value:TColor);
 begin
  FColorDown:=Value;
  HighLightImage(FIm,FColorUp,FColorDown,FRadius,FSelectTab,GetBkColor,FBm,FKind,Trim(FCaption)<>'');
 end;

procedure TsvBtn.SetColorUp(const Value:TColor);
 begin
  FColorUp:=Value;
  HighLightImage(FIm,FColorUp,FColorDown,FRadius,FSelectTab,GetBkColor,FBm,FKind,Trim(FCaption)<>'');
 end;

procedure TsvBtn.SetRadius(const Value:Integer);
 begin
  FRadius:=Value;
 end;

procedure TsvBtn.imClick(Sender:TObject);
 begin
  if SelectTab=False then SelectTab:=True;
 end;

function TsvBtn.GetBkColor:TColor;
 begin
  try
   if Assigned(Parent) then Result:=TPanel(Parent).Color else Abort;
  except
   Result:=clBtnFace;
  end;
 end;

{ TsvTab }

constructor TsvTab.Create(Collection: TCollection);
var Bar:TsvBar;
 begin
  Bar:=nil;
  if Assigned(Collection) and (Collection is TsvTabs) then Bar:=TsvTabs(Collection).Bar;
  inherited Create(Collection);
  if Assigned(Bar) then
   begin
    FBtn:=TsvBtn.Create(Bar);
    FBtn.Parent:=Bar;
    FBtn.Top:=0;
    FBtn.Left:=0;
    FBtn.Width:=0;
    FBtn.Anchors:=[akLeft,akTop,akBottom];
    FBtn.Height:=Bar.Height;
    FBtn.Kind:=Bar.Kind;
   end;
 end;

destructor TsvTab.Destroy;
 begin
  FBtn.Free;
  inherited;
 end;

{ TsvBar }

constructor TsvBar.Create(AOwner:TComponent);
 begin
  inherited;
  FKind:=brTabs;
  FTabs:=CreateTabs;
  BevelOuter:=bvNone;
  Caption:='';
 end;

function TsvBar.CreateTabs: TsvTabs;
 begin
  Result:=TsvTabs.Create(Self,TsvTab);
 end;

destructor TsvBar.Destroy;
 begin
  FTabs.Free;
  FTabs:=nil;
  inherited;
 end;

procedure TsvBar.SetKind(const Value:Byte);
var i:Integer;
 begin
  FKind:=Value;
  for i:=0 to Tabs.Count-1 do Tabs.Items[i].Btn.Kind:=Value;
 end;

procedure TsvBar.SetTabs(const Value:TsvTabs);
 begin
  Tabs.Assign(Value);
 end;

{ TsvTabs }

function TsvTabs.Add:TsvTab;
var dx,i:Integer;
 begin
  dx:=0;
  for i:=0 to Bar.Tabs.Count-1 do Inc(dx,Bar.Tabs.Items[i].Btn.Width);
  Result:=TsvTab(inherited Add);
  TsvTab(Result).Btn.Left:=dx+1;
 end;

constructor TsvTabs.Create(Bar:TsvBar; TabClass:TTabClass);
 begin
  inherited Create(TabClass);
  FBar:=Bar;
 end;

function TsvTabs.GetTab(Index:Integer):TsvTab;
 begin
  Result:=TsvTab(inherited Items[Index]);
 end;

procedure TsvTabs.SetTab(Index:Integer; const Value:TsvTab);
 begin
  Items[Index].Assign(Value);
 end;

procedure TsvBtn.SetSelectTab(const Value: Boolean);
var i:Integer;
    R,G,B:Single;
    R1,G1,B1:Single;

 begin
  if FKind=brTabs then
   begin
    FSelectTab:=Value;
    if Value then
     begin
      for i:=0 to TsvBar(Parent).Tabs.Count-1 do
       if TsvBar(Parent).Tabs.Items[i].Btn<>Self then
        TsvBar(Parent).Tabs.Items[i].Btn.SelectTab:=False;
     end;
    HighLightImage(FIm,FColorUp,FColorDown,FRadius,FSelectTab,GetBkColor,FBm,FKind,Trim(FCaption)<>'');
   end else FSelectTab:=False;

  if ((FKind=brTabs) and (Value=True)) or (FKind=brBtns) then
   try
    ColorToGL(FColorUp,R,G,B); ColorToGL(FColorDown,R1,G1,B1);
    HighLightImage(FIm,Round((B*K1)*255)*65536+Round((G*K1)*255)*256+Round((R*K1)*255),
                       Round((B1*K2)*255)*65536+Round((G1*K2)*255)*256+Round((R1*K2)*255),FRadius,FSelectTab,GetBkColor,FBm,FKind,Trim(FCaption)<>'');
    Click;
   finally
    HighLightImage(FIm,FColorUp,FColorDown,FRadius,FSelectTab,GetBkColor,FBm,FKind,Trim(FCaption)<>'');
   end;
 end;

{  ColorToGL(Col1,R1,G1,B1); ColorToGL(Col2,R2,G2,B2);
  StR:=(R2-R1)/Bm.Height;
  StG:=(G2-G1)/Bm.Height;
  StB:=(B2-B1)/Bm.Height;
  for i:=1 to Bm.Height do
   begin
    Bm.Canvas.Pen.Color:=;
 }
procedure TsvBtn.SetKind(const Value: Byte);
 begin
  FKind:=Value;
  SetBounds(Left,Top,Width,Height);
 end;

procedure TsvBtn.SetHint(const Value: String);
 begin
  FHint:=Value;
  FIm.Hint:=Value;
  FLb.Hint:=Value;

  FIm.ShowHint:=FHint<>'';
  FLb.ShowHint:=FHint<>'';
 end;
       
procedure TsvBtn.SetFlash(const Value: Boolean);
var R,G,B:Single;
    R1,G1,B1:Single;
 begin
  FFLash:=Value;
  if Value then
   begin
    ColorToGL(FColorUp,R,G,B); ColorToGL(FColorDown,R1,G1,B1);
    HighLightImage(FIm,Round((B*K1)*255)*65536+Round((G*K1)*255)*256+Round((R*K1)*255),
                       Round((B1*K2)*255)*65536+Round((G1*K2)*255)*256+Round((R1*K2)*255),FRadius,FSelectTab,GetBkColor,FBm,FKind,Trim(FCaption)<>'')
   end else HighLightImage(FIm,FColorUp,FColorDown,FRadius,FFLash,GetBkColor,FBm,FKind,Trim(FCaption)<>'');
 end;

end.
