Unit PrintReport;

Interface

Uses Windows,Controls,Classes,StdCtrls,SysUtils,Dialogs,Graphics,Printers,Forms,Math,DB,Util, JPeg, ADODB;

Type MyInteger=Integer;

     TMargins=Record
       Left,Top,Right,Bottom:Double;
     end;

     TQrTableInfo=Record
      Nm:String;
      NumF:Integer;
      Width:Integer;
      Tp:Char;
     end;

     TCustomRep=class;

     TPrintObj=class (TObject)
     private

       FX:MyInteger;        // Х в пикс
       FY:MyInteger;        // Y в пикс
       FWidth:MyInteger;    // Ширина в пикс
       FHeight:MyInteger;   // Высота в пикс

       FNumPage:MyInteger;  // Номер страницы для вывода

       FKoefX:Real;        // Коэффициент масштабирования по X
       FKoefY:Real;        // Коэффициент масштабирования по Y

       FBounds:TRect;      // Границы вывода
       FCanvas:TCanvas;    // Канва для рисования
       FLastY:MyInteger;
       FUpY:MyInteger;
       FLastPage:MyInteger;
       FParent:TCustomRep;
       FDY:MyInteger;

       procedure Build; virtual; // Размещение объекта на области печати
       procedure Draw; virtual; abstract; // Вывод объекта

       function  GetNumPages:MyInteger; virtual; abstract;
       function  GetLastPage:MyInteger;
       function  GetLastY:MyInteger;

     public

       constructor Create; virtual;

       property X:MyInteger read FX write FX;
       property Y:MyInteger read FY write FY;
       property NumPage:MyInteger read FNumPage write FNumPage;
       property KoefX:Real read FKoefX write FKoefX;
       property KoefY:Real read FKoefY write FKoefY;
       property Bounds:TRect read FBounds write FBounds;
       property Canvas:TCanvas read FCanvas write FCanvas;
       property LastPage:MyInteger read GetLastPage;
       property LastY:MyInteger read GetLastY;
       property NumPages:MyInteger read GetNumPages;
       property Parent:TCustomRep read FParent;
       property DY:MyInteger read FDY write FDY;
       property UpY:MyInteger read FUpY write FUpY;

     end;

     TBorder=Record
       Color:TColor;
       Width:MyInteger;
       Style:TPenStyle;
     end;

     TChar=Record
       X:MyInteger;         // Х - координата в пискелах
       Y:MyInteger;         // Y - координата в пискелах
       NumPage:MyInteger;   // Номер страницы
       Height:MyInteger;    // Высота шрифта
       Name:MyInteger;      // Номер шрифта
       Style:TFontStyles;   // Стиль шрифта
       Color:TColor;        // Цвет символа
       BColor:TColor;       // Цвет фона символа, -1 - без заливки
     end;

     TAChar=Array of TChar;

     TParagr=Record
       Align:Byte;            // Расположение текста
       Indent:MyInteger;      // Отступ первой строки в пикселах
       RightIndent:MyInteger; // Отступ правого края абзаца в пикселах
       LeftIndent:MyInteger;  // Отступ левого края абзаца в пикселах
     end;

     TAParagr=Array of TParagr;

     TTextObj=class (TPrintObj)
     private
       FPrAdj:TAParagr;
       FChAdj:TAChar;
       FNumPr:Array of Integer;
       FData:String;

       procedure SetData(const Value:String);
       procedure Build; override;
       procedure Draw; override;

       function  GetNumPages:MyInteger; override;

     public

       constructor Create; override;
       destructor Destroy; override;

       property Data:String read FData write SetData;

     end;

     TImageObj=class (TPrintObj)
     private
       FParagr:TParagr;
       FCh:TChar;
       FBm:TBitMap;
       FStretch:Boolean;
       FStWidth:MyInteger;
       FAspectRatio:Real;
       FFileName:String;

       procedure Build; override;
       procedure Draw; override;

       function  GetNumPages:MyInteger; override;

     public

       constructor Create; override;
       destructor Destroy; override;

       property Bm:TBitMap read FBm write FBm;

     end;

    TCell=class;
    TCells=Array of TCell;

    TDrawCell=procedure(C:TCanvas; R:TRect; H:Integer; Kp:Integer);

    TTableObj=class (TPrintObj) // Класс "Объект Таблица"
     private

       FCells:TCells;

       FRows:MyInteger;
       FCols:MyInteger;

       FFRow1:MyInteger;
       FFRow2:MyInteger;
       FFixStPage:MyInteger;
       FFixDY:MyInteger;
       FOnDrawCell:TDrawCell;

       procedure CorrCol(var Col:MyInteger);
       procedure CorrRow(var Row:MyInteger);

       procedure SetColWidths(Col:MyInteger; const Value:MyInteger);
       procedure SetRowHeights(Row:MyInteger; Value:MyInteger);

       procedure Build; override;
       procedure Draw; override;

       function  GetLastRow:MyInteger;
       function  GetCell(Col,Row:MyInteger):TCell;
       function  GetFactCell(Col,Row:MyInteger):TCell;
       function  GetNumPages:MyInteger; override;
       function  GetColCount(Row:MyInteger):MyInteger;
       function  GetColWidths(Col:MyInteger):MyInteger;
       function  GetRowHeights(Row:MyInteger):MyInteger;

       property  LastRow:MyInteger read GetLastRow;
       property  FactCell[Col,Row:MyInteger]:TCell read GetFactCell;

     public

       constructor Create; override;
       destructor Destroy; override;

       procedure Clear;
       procedure MergeCells(Col1,Row1,Col2,Row2:MyInteger);
       procedure SetBorders(Col1,Row1,Col2,Row2:MyInteger; const Br:TBorder);
       procedure FixRows(Row1,Row2:MyInteger);
       procedure SetWidths(P:String);

       property  Cell[Col,Row:MyInteger]:TCell read GetCell; // Возвращает ячейку с учетом объединенных
       property  ColCount[Row:MyInteger]:MyInteger read GetColCount; // Количество столбцов в строке с учетом объединенных ячеек

       property  ColWidths[Col:MyInteger]:MyInteger read GetColWidths write SetColWidths;  // Разиер в миллиметрах !!!
       property  RowHeights[Row:MyInteger]:MyInteger read GetRowHeights write SetRowHeights; // Разиер в миллиметрах !!!

       property  Cols:MyInteger read FCols; // Количество столбцов без учета объединенных
       property  Rows:MyInteger read FRows; // Количество строк без учета объединенных
       property  OnDrawCell:TDrawCell read FOnDrawCell write FOnDrawCell;

     end;

     TCustomRep=class
     private

       FBColor:TColor;      // Цвет фона
       FStretch:Boolean;    // Растягивать ли рисунок
       FAspectRatio:Real;   // Пропорции изображения
       FFont:TFont;         // Текущий шрифт
       // Текущие настройки расположения объекта
       FAlign:Byte;
       FIndent:MyInteger;
       FRightIndent:MyInteger;
       FLeftIndent:MyInteger;

       FLeftBorder:TBorder;
       FTopBorder:TBorder;
       FRightBorder:TBorder;
       FBottomBorder:TBorder;

       FLm:MyInteger;
       FRm:MyInteger;
       FTm:MyInteger;
       FBm:MyInteger;
       FPw:MyInteger;
       FPh:MyInteger;
       FNumPage:MyInteger;
       FFirstPage:MyInteger;
       FLastPage:MyInteger;
       FCellY:MyInteger;
       FLastY:MyInteger;
       FUpY:Integer;

       FBlocks:Array of TPrintObj; // Массив объектов для печати

       FLeftMargin:MyInteger;     // Левое поле в пикселах
       FRightMargin:MyInteger;    // Правое поле в пикселах
       FTopMargin:MyInteger;      // Верхнее поле в пикселах
       FBottomMargin:MyInteger;   // Нижнее поле в пикселах

       FPrintScale:Real;        // Коэфф. масштабирования при печати (по 1 (100%))
       FPageDev:Integer;
       FTextAng:Integer;

       procedure BuildQueue; virtual;
       procedure AddIm(W:MyInteger);
       procedure SetPrintScale(const V:Real);
       procedure SetBottomBorder(Value:TBorder); virtual;
       procedure SetRightBorder(Value:TBorder); virtual;
       procedure SetLeftBorder(Value:TBorder); virtual;
       procedure SetTopBorder(Value:TBorder); virtual;
       procedure SetBColor(Value:TColor); virtual;

       function  GetPageHeight:MyInteger; virtual; abstract;
       function  GetPageWidth:MyInteger; virtual; abstract;
       function  GetLastItem:TPrintObj;
       function  GetLastTable:TTableObj;

       property CellY:MyInteger read FCellY;

     public

       constructor Create; virtual;
       destructor Destroy; override;

       procedure Clear; virtual;
       procedure SetDefault; virtual;    // Сброс настроек печати в настройки по умолчанию

       procedure AddText(S:String); // Добавление текскового объекта
       procedure AddInterv(Size:MyInteger);

       procedure AddImage(Im:TBitMap); overload;
       procedure AddImage(Im:String); overload;
       procedure AddImage(Im:TBitMap; W:MyInteger); overload;
       procedure AddImage(Im:String; W:MyInteger); overload;

       procedure AddTextAng(S:String; Ang:Real); // Добавление обекта Текст под углом

       procedure AddTable(Cols,Rows:MyInteger); // Добавление новой таблицы
       procedure AddRows(Rows:MyInteger); // Добавление строк к последней таблице (если она есть)

       property  LeftMargin:MyInteger read FLeftMargin write FLeftMargin;
       property  RightMargin:MyInteger read FRightMargin write FRightMargin;
       property  TopMargin:MyInteger read FTopMargin write FTopMargin;
       property  BottomMargin:MyInteger read FBottomMargin write FBottomMargin;

       property  PageWidth:MyInteger read GetPageWidth;
       property  PageHeight:MyInteger read GetPageHeight;
       property  PrintScale:Real read FPrintScale write SetPrintScale;

       property  LastItem:TPrintObj read GetLastItem;
       property  LastTable:TTableObj read GetLastTable;

       property  BColor:TColor read FBColor write SetBColor;
       property  Stretch:Boolean read FStretch write FStretch;
       property  AspectRatio:Real read FAspectRatio write FAspectRatio;
       property  Align:Byte read FAlign write FAlign;
       property  Indent:MyInteger read FIndent write FIndent;
       property  RightIndent:MyInteger read FRightIndent write FRightIndent;
       property  LeftIndent:MyInteger read FLeftIndent write FLeftIndent;
       property  Font:TFont read FFont write FFont;
       property  UpY:Integer read FUpY write FUpY;

       property  LeftBorder:TBorder read FLeftBorder write SetLeftBorder;
       property  TopBorder:TBorder read FTopBorder write SetTopBorder;
       property  RightBorder:TBorder read FRightBorder write SetRightBorder;
       property  BottomBorder:TBorder read FBottomBorder write SetBottomBorder;

       property  PageDev:Integer read FPageDev write FPageDev;

       property  TextAng:Integer read FTextAng write FTextAng;

     end;

     TKolontitul=class(TCustomRep)
     private
       FText:String;
       FPicture:TBitMap;

       function  GetPageHeight:MyInteger; override;
       function  GetPageWidth:MyInteger; override;

     public
       constructor Create; override;
       destructor Destroy; override;

       property Text:String read FText write FText;
       property Picture:TBitMap read FPicture write FPicture;

     end;

     TPrintRep=class(TCustomRep)
     private

       FPageSize:MyInteger;       // формат бумаги
       FOrientation:MyInteger;    // 0 - книжная, 1 альбомная

       FViewBtn:Boolean;        // Флаг показа кнопки Просмотр в свойствах печати
       FPDialog:TPrintDialog;   // Диалог печати
       FIsDialog:Boolean;       // Признак прямой печати или через диалог
       FPrintSource:MyInteger;    // Источник вывода (Экран или Принтер)
       FMaxPage:MyInteger;        // Начальная страница для печати
       FMinPage:MyInteger;        // Конечная страница для печати

       FMinLeftMargin:MyInteger;
       FMinRightMargin:MyInteger;
       FMinTopMargin:MyInteger;
       FMinBottomMargin:MyInteger;
       FUpKolontit:TKolontitul;      // Верхний колонтитул
       FDownKolontit:TKolontitul;    // Нижний колонтитул
       FPrintDirect:Boolean;         // Направление печати
       FPrintRange:MyInteger;        // Диапазон печати (все, четные нечетные)
       FSilentPrint:Boolean;         // Печать без выода окна отмены печати
       FIsPrinting:Boolean;
       FQr:TDataSet;
       FPrinterName:String;
       FPageSetupChange:Boolean;
       FID_Apteka:Integer;

       procedure SetPageSize(const V:MyInteger);
       procedure SetOrientation(const V:MyInteger);
       procedure SetMaxPage(const Value:MyInteger);
       procedure SetMinPage(const Value:MyInteger);
       procedure Init;
       procedure BuildQueue; override;
       procedure SetPrinterName(const Value:String);

       function  GetPageHeight:MyInteger; override;
       function  GetPageWidth:MyInteger; override;
       function  GetNumPages:MyInteger;
       function  GetKp:ShortInt;
       function  GetMaxPage:MyInteger;
       function  GetMinPage:MyInteger;
       function  GetPrinterName: String;


       property  MinPage:MyInteger read GetMinPage write SetMinPage; // Номер первой страницы (всегда 1)
       property  MaxPage:MyInteger read GetMaxPage write SetMaxPage;
       property  PageSetupChange:Boolean read FPageSetupChange write FPageSetupChange;
       property  Kp:ShortInt read GetKp; // Направление координаты Y (разное для Экрана и Принтера)

     public

       constructor Create; override;
       destructor Destroy; override;

       procedure Clear; override;
       procedure Print;
       procedure PrintPage(C:TCanvas; W,H:MyInteger; N:MyInteger);
       procedure SaveToFile(FName:String);
       procedure PrintCennik(Firm:String; MaxSkd:Real; QrEx:TADOQuery; ID_Apteka:Integer; Skd:Byte=0; Param:Byte=0; Param1:Boolean=False; SkdSrok:Byte=0);
       procedure PrintCennikExt;
       procedure PrintStiker;
       procedure PrintTable(Nds:Boolean; It:Integer; Kol:Integer; SumOnly:Boolean=False);
       procedure PrintEAN13; // Печать стикеров
       procedure PageToBitMap(var B:TBitMap; N:MyInteger=1);
       procedure SetDefault; override;    // Сброс настроек печати в настройки по умолчанию

       function  PageSetup:Boolean;
       function  PrintDialog:Boolean;
       function  PreView:Boolean;

       property  PageSize:MyInteger read FPageSize write SetPageSize;
       property  PageWidth:MyInteger read GetPageWidth;
       property  PageHeight:MyInteger read GetPageHeight;
       property  Orientation:MyInteger read FOrientation write SetOrientation;
       property  NumPages:MyInteger read GetNumPages;
       property  UpKolontit:TKolontitul read FUpKolontit write FUpKolontit;
       property  DownKolontit:TKolontitul read FDownKolontit write FDownKolontit;
       property  PrintDirect:Boolean read FPrintDirect write FPrintDirect;
       property  PrintRange:MyInteger read FPrintRange write FPrintRange;
       property  SilentPrint:Boolean read FSilentPrint write FSilentPrint;
       property  Qr:TDataSet read FQr write FQr;
       property  PrinterName:String read GetPrinterName;
       property  ID_Apteka:Integer read FID_Apteka write FID_Apteka;

     end;

     TCell=class(TCustomRep)
     private
       FMLeft:MyInteger;
       FMTop:MyInteger;
       FCoords:TRect;
       FParent:TTableObj;

       FCellX:MyInteger;
       FInitCellWidth:MyInteger;
       FInitCellHeight:MyInteger;
       FCellWidth:MyInteger;
       FCellHeight:MyInteger;
       FObjHeight:MyInteger;

       procedure BuildQueue; override;

       procedure SetCellWidth(Value:MyInteger);
       procedure SetCellHeight(Value:MyInteger);
       procedure SetFactCellHeight(Value:MyInteger);
       procedure SetObjHeight(Value:MyInteger);
       procedure SetHeight(H:MyInteger);

       procedure SetBottomBorder(Value:TBorder); override;
       procedure SetRightBorder(Value:TBorder); override;
       procedure SetLeftBorder(Value:TBorder); override;
       procedure SetTopBorder(Value:TBorder); override;
       procedure SetBColor(Value:TColor); override;

       function  GetHeight(fP,lP,fY,lY:MyInteger):MyInteger;
       function  GetPageWidth:MyInteger; override;
       function  GetPageHeight:MyInteger; override;
       function  GetCellWidth:MyInteger;
       function  GetCellHeight:MyInteger;
       function  GetFactCellHeight:MyInteger;

       function  GetNumPages:MyInteger;

       property  NumPages:MyInteger read GetNumPages;

       property  ObjHeight:MyInteger read FObjHeight write SetObjHeight;
       property  FactCellHeight:MyInteger read GetFactCellHeight write SetFactCellHeight;
       property  CellWidth:MyInteger read GetCellWidth write SetCellWidth;
       property  CellHeight:MyInteger read GetCellHeight write SetCellHeight;

       property CellX:MyInteger read FCellX;

     public

       constructor Create; override;

       procedure  Clear; override;

       property Parent:TTableObj read FParent;

       property Width:MyInteger read GetCellWidth;
       property Height:MyInteger read GetCellHeight;
     end;

Const AL_CENTER=0; // Выравнивание по центру
      AL_LEFT=1;   // Выравнивание по левому краю
      AL_RIGHT=2;  // Выравнивание по правому краю
      AL_JUST=3;   // Выравнивание по ширине

      TO_PRINT=1;  // Печать на принтер
      TO_IMAGE=2;  // Печать на Image (для просмотра)

      PF_A3=0;   // Формат листа A3
      PF_A4=1;   // Формат листа A4
      PF_A5=2;   // Формат листа A5
      PF_S1=3;   // Формат листа A5

      O_PORTR=0;  // Книжная
      O_LANDS=1;  // Альбомная

      DEFAULT_BORDER:TBorder=(Color:clBlack; Width:1; Style:psSolid); // Настройки границ по умолчанию
      EMPTY_BORDER:TBorder=(Color:clBlack; Width:1; Style:psClear); // Настройки границ по умолчанию

      PR_ALL=1;   // Печать всех листов
      PR_EVEN=2;  // Печать четных листов
      PR_ODD=3;   // Печать нечетных листов

Var PixPerI:Integer;
    IsPreviewing:Boolean;

function PrintRep(P:Byte=0):TPrintRep;

// Поворот координаты x,y вокруг x0,y0 на угол Ang
Procedure RotateXY(x0,y0,x,y:MyInteger; var x1,y1:MyInteger; Ang:Real);

// Поворот текста на любой угол работает только для True Type шрифтов
procedure CanvasSetTextAngle(C:TCanvas; D:Single);

// Пикселы в миллиметры
function PixToMM(V:Real):Real;

// Номер шрифта из списка системных шрифтов
function GetFontIndex(S:String):MyInteger;

// Ширина строки в пикселах
function TextWidth(S:String; F:TFont):MyInteger;

// Возвращает значение типа TBorder
function Border(Cl:TColor; Wd:MyInteger; St:TPenStyle):TBorder;

// Минимальные границы принтера
procedure GetPrinterMargins(var Margins:TMargins);

procedure PrintCennikLenta(C:TCennik);

Implementation

uses PrintSetupU, PreviewU, PrintStatusU, PrintThU;

var FPrintRep:TPrintRep=nil;

// Минимальные границы принтера
procedure GetPrinterMargins(var Margins:TMargins);
var PixelsPerInch:TPoint;
     PhysPageSize:TPoint;
     OffsetStart:TPoint;
     PageRes:TPoint;
 begin
  PixelsPerInch.y := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
  PixelsPerInch.x := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
  Escape(Printer.Handle, GETPHYSPAGESIZE, 0, nil, @PhysPageSize);
  Escape(Printer.Handle, GETPRINTINGOFFSET, 0, nil, @OffsetStart);
  PageRes.y := GetDeviceCaps(Printer.Handle, VERTRES);
  PageRes.x := GetDeviceCaps(Printer.Handle, HORZRES);
  // Top Margin
  Margins.Top := OffsetStart.y / PixelsPerInch.y;
  // Left Margin
  Margins.Left := OffsetStart.x / PixelsPerInch.x;
  // Bottom Margin
  Margins.Bottom:=((PhysPageSize.y -PageRes.y)/PixelsPerInch.y)-(OffsetStart.y/PixelsPerInch.y);
  // Right Margin
  Margins.Right:=((PhysPageSize.x-PageRes.x)/PixelsPerInch.x)-(OffsetStart.x/PixelsPerInch.x);
 end;

// Поворот координаты x,y вокруг x0,y0 на угол Ang
Procedure RotateXY(x0,y0,x,y:MyInteger; var x1,y1:MyInteger; Ang:Real);
var m,n:Real;
 begin
  m:=Cos(Ang*pi/180); n:=Sin(Ang*pi/180);
  x1:=x0+Round( (x-x0)*m+(y-y0)*n);
  y1:=y0+Round(-(x-x0)*n+(y-y0)*m);
 end;

// Поворот текста на любой угол работает только для True Type шрифтов
procedure CanvasSetTextAngle(C:TCanvas; D:Single);
var LogRec:TLOGFONT; // Информация о шрифте
 begin
  // Читаем текущюю информацию о шрифте
  GetObject(c.Font.Handle,SizeOf(LogRec),Addr(LogRec));
  // Изменяем угол
  LogRec.lfEscapement:=Round(d*10);
  // Устанавливаем новые параметры
  C.Font.Handle:=CreateFontIndirect(LogRec);
 end;

// Номер шрифта из списка системных шрифтов
function GetFontIndex(S:String):MyInteger;
var Ind:MyInteger;
 begin
  Ind:=Screen.Fonts.IndexOf(S);
  if Ind<>-1 then Result:=Ind else Result:=Screen.Fonts.IndexOf('Times New Roman');
 end;

// Дюймы в миллиметры
function InchToMM(Pixel:Single):Single;
 begin
  Result:=Pixel*25.4
 end;

// Дюймы в пикселы с учетом что в 1 мм - 10 пикс
function InchToPix(Pixel:Single):MyInteger;
 begin
  Result:=Round(Pixel*254);
 end;

// Пикселы в миллиметры
function PixToMM(V:Real):Real;
 begin
  Result:=V*0.1;
 end;

// Миллиметры в пикселы
function MMToPix(V:Real):MyInteger;
 begin
  Result:=Round(V*10);
 end;

// Ширина строки в пискелах
function TextWidth(S:String; F:TFont):MyInteger;
var Bm:TBitMap;
 begin
  try
   Bm:=TBitMap.Create;
   try
    Bm.Canvas.Font:=F;
    Bm.Canvas.Font.PixelsPerInch:=PixPerI;
    Result:=Bm.Canvas.TextWidth(S);
   finally
    Bm.Free;
   end;
  except
   Result:=0;
  end;
 end;

function Border(Cl:TColor; Wd:MyInteger; St:TPenStyle):TBorder;
var Br:TBorder;
 begin
  if Wd>1000 then Wd:=1000;
  Br.Color:=Cl;
  Br.Width:=Wd;
  Br.Style:=St;
  Result:=Br;
 end;

//******************** Реализация методов и свойств ************************************
function PrintRep(P:Byte=0):TPrintRep;
 begin

  if P=1 then
   if FPrintRep<>nil then
    begin
     FPrintRep.Free;
     FPrintRep:=nil;
    end;

  if FPrintRep=nil then FPrintRep:=TPrintRep.Create;

  Result:=FPrintRep;
 end;

{ TPrintRep }

constructor TPrintRep.Create;
 begin
  inherited;
  DownKolontit:=TKolontitul.Create;
  UpKolontit:=TKolontitul.Create;
  FViewBtn:=True;
  FPDialog:=TPrintDialog.Create(nil);
  FIsDialog:=False;
  FPrintDirect:=True;
  FPrintRange:=PR_ALL;
  FSilentPrint:=True;
  FIsPrinting:=False;
  PrintStatusF:=nil;
  FQr:=nil;
  FPageSetupChange:=True;
 end;

procedure TCustomRep.SetBColor(Value: TColor);
 begin
  FBColor:=Value;
 end;

procedure TCustomRep.AddText(S:String);
var Cn,CA,CC:Integer;
    Tx:TTextObj;
    Ch:TChar;
    Pr:TParagr;
    i:Integer;

 function GetIndPr(Pr:TParagr):Integer;
 var i:Integer;
  begin
   for i:=Low(Tx.FPrAdj) to High(Tx.FPrAdj) do
    if (Tx.FPrAdj[i].Align=Pr.Align) and
       (Tx.FPrAdj[i].Indent=Pr.Indent) and
       (Tx.FPrAdj[i].RightIndent=Pr.RightIndent) and
       (Tx.FPrAdj[i].LeftIndent=Pr.LeftIndent) then
    begin
     Result:=i;
     Exit;
    end;
   i:=High(Tx.FPrAdj)+1; SetLength(Tx.FPrAdj,i+1); Tx.FPrAdj[i]:=Pr; Result:=i;
  end;

 Begin
  if (LastItem=nil) or (LastItem.ClassName<>'TTextObj') then
   begin
    CA:=High(FBlocks)+1;
    SetLength(FBlocks,CA+1);
    FBlocks[CA]:=TTextObj.Create;
    FBlocks[CA].UpY:=UpY; UpY:=0;
   end else CA:=High(FBlocks);
  Tx:=TTextObj(FBlocks[CA]);
  Tx.FParent:=Self;
  Cn:=Length(Tx.Data);
  Tx.Data:=Tx.Data+S;
  Pr.Align:=Align;
  Pr.Indent:=MMToPix(Indent);
  Pr.LeftIndent:=MMToPix(LeftIndent);
  Pr.RightIndent:=MMToPix(RightIndent);
  CC:=High(Tx.FChAdj)+1;
  SetLength(Tx.FChAdj,CC+Length(S));
  for i:=1 to Length(S) do
   begin
    Ch.X:=-1;
    Ch.Y:=-1;
    Ch.NumPage:=0;
    Ch.Height:=Abs(FFont.Height);
    Ch.Name:=GetFontIndex(FFont.Name);
    Ch.Color:=FFont.Color;
    Ch.BColor:=BColor;
    Ch.Style:=FFont.Style;
    Tx.FParent:=Self;
    Tx.FChAdj[CC]:=Ch;
    Tx.FNumPr[Cn+i-1]:=GetIndPr(Pr);
    Inc(CC);
   end;
 End;

procedure TCustomRep.Clear;
var i:Integer;
 begin
  for i:=Low(FBlocks) to High(FBlocks) do FBlocks[i].Free;
  SetLength(FBlocks,0);
 end;

procedure TPrintRep.PrintPage(C:TCanvas; W,H:MyInteger; N:MyInteger);
var i:Integer;
    kx,ky:Real;

 procedure DrawKolontit(Kl:TKolontitul; Y:Integer);
 var i:Integer;
     S:String;

  begin
   if Kl.Text='' then Exit;
   Kl.Clear;
   Kl.FCellY:=Y;
   Kl.FFirstPage:=N;
   S:=StringReplace(Kl.Text,'&NumP&',IntToStr(N),[rfReplaceAll,rfIgnoreCase]);
   Kl.AddText(S);
   Kl.BuildQueue;
   for i:=Low(Kl.FBlocks) to High(Kl.FBlocks) do
    begin
     Kl.FBlocks[i].NumPage:=N;
     Kl.FBlocks[i].Canvas:=C;
     Kl.FBlocks[i].KoefX:=kx;
     Kl.FBlocks[i].KoefY:=ky;
     Kl.FBlocks[i].Draw;
    end;
  end;

 Begin
  C.Font.PixelsPerInch:=PixPerI;
  C.Pen.Color:=clBlack;
  C.Pen.Style:=psSolid;
  C.Brush.Style:=bsClear;

  kx:=(PrintScale*W)/PageWidth;
  ky:=(PrintScale*Kp*H)/PageHeight;
  DrawKolontit(UpKolontit,0);
  DrawKolontit(DownKolontit,FPh-FBm);
  for i:=Low(FBlocks) to High(FBlocks) do
   begin
    FBlocks[i].NumPage:=N;
    FBlocks[i].Canvas:=C;
    FBlocks[i].KoefX:=kx;
    FBlocks[i].KoefY:=ky;
    FBlocks[i].Draw;
   end;
 End;

procedure TPrintRep.PageToBitMap(var B:TBitMap; N:MyInteger=1);
 begin
  BuildQueue;
  PrintPage(B.Canvas,B.Width,B.Height,N);
 end;

function TPrintRep.PreView:Boolean;
var tmp:TMessageEvent;
 begin
  Result:=False;
  try
   IsPreviewing:=True;
   tmp:=Application.OnMessage;
   PreviewF:=TPreviewF.Create(nil);
   try
    FViewBtn:=False;
    BuildQueue;
    PreviewF.BitBtn2.Enabled:=FPageSetupChange;
    Application.ProcessMessages;
    PreviewF.ShowModal;
    Result:=PreviewF.IsPrint;
   finally
    IsPreviewing:=False;
    PreviewF.Free;
    
    Application.OnMessage:=tmp;
    FViewBtn:=True;
   end;
  except
//   on E:Exception do Aplication.MessageBox('')  
  end;
 end;

procedure TPrintRep.Print;
var PS:Integer;
    M:TMargins;
    i,Lm,Tm,Bm,Rm:Integer;
    IsFirst:Boolean;

 procedure PrPage(N:Integer);
  begin
   if FIsPrinting=False then Abort;
   if Not(IsFirst) then Printer.NewPage;
   PrintPage(Printer.Canvas,PageWidth,PageHeight,N);
   if IsFirst then IsFirst:=False;
   if PrintStatusF<>nil then
    begin
     PrintStatusF.Label2.Caption:='Страница №'+IntToStr(N);
     PrintStatusF.ProgressBar1.Position:=N;
    end;
   if FIsPrinting=False then Abort;
  end;

 Begin
  if Not (FIsDialog) then
   begin
    FIsPrinting:=True;
    BuildQueue;
   end;
  PS:=FPrintSource;
  Lm:=LeftMargin;
  Bm:=BottomMargin;
  Rm:=RightMargin;
  Tm:=TopMargin;
  try
   FPrintSource:=TO_PRINT;
   GetPrinterMargins(M);
   FMinLeftMargin:=InchToPix(Abs(M.Left));
   FMinRightMargin:=InchToPix(Abs(M.Right));
   FMinTopMargin:=InchToPix(Abs(M.Top));
   FMinBottomMargin:=InchToPix(Abs(M.Bottom));
   Dec(FLeftMargin,FMinLeftMargin);
   Dec(FTopMargin,FMinTopMargin);
   Dec(FRightMargin,FMinRightMargin);
   Dec(FBottomMargin,FMinBottomMargin);
   BuildQueue;

   Printer.BeginDoc;
   SetMapMode(Printer.Canvas.Handle,MM_LOMETRIC);

   IsFirst:=True;
   if PrintDirect then
    begin
     for i:=MinPage to MaxPage do
      begin
       if PrintRange=PR_EVEN then if i mod 2<>0 then Continue;
       if PrintRange=PR_ODD then if i mod 2=0 then Continue;
       PrPage(i);
      end;
     end else
    for i:=MaxPage downto MinPage do
     begin
      if PrintRange=PR_EVEN then if i mod 2<>0 then Continue;
      if PrintRange=PR_ODD then if i mod 2=0 then Continue;
      PrPage(i);
     end;
   finally
   Printer.EndDoc;

   FIsPrinting:=False;
   FSilentPrint:=True;
   FPrintSource:=PS;
   FMinLeftMargin:=0;
   FMinRightMargin:=0;
   FMinTopMargin:=0;
   FMinBottomMargin:=0;
   LeftMargin:=Lm;
   BottomMargin:=Bm;
   RightMargin:=Rm;
   TopMargin:=Tm;
   BuildQueue;
   if PrintStatusF<>nil then
    begin
     PrintStatusF.Close;
     PrintStatusF.Free;
     PrintStatusF:=nil;
    end;
  end;
 End;

function TPrintRep.PageSetup:Boolean;
var F:Integer;
 begin
  try
   PrintSetupF:=TPrintSetupF.Create(nil);
   try
    PrintSetupF.Flag:=0;
    PrintSetupF.ComboBox1.ItemIndex:=PageSize;
    PrintSetupF.UpDown2.Position:=Round(PixToMM(LeftMargin));
    PrintSetupF.UpDown3.Position:=Round(PixToMM(RightMargin));
    PrintSetupF.UpDown1.Position:=Round(PixToMM(TopMargin));
    PrintSetupF.UpDown4.Position:=Round(PixToMM(BottomMargin));
    PrintSetupF.UpDown5.Position:=Round(PrintScale*100);
    PrintSetupF.CheckBox1.Checked:=Not PrintDirect;
    PrintSetupF.Memo1.Lines.Text:=UpKolontit.Text;
    PrintSetupF.Memo1.Font.Assign(UpKolontit.Font);
    PrintSetupF.Memo1.Font.Size:=((3*PrintSetupF.Memo1.Font.Size) div 2);
    Case UpKolontit.Align of
     AL_LEFT:PrintSetupF.SpeedButton1.Click;
     AL_CENTER:PrintSetupF.SpeedButton2.Click;
     AL_RIGHT:PrintSetupF.SpeedButton3.Click;
     AL_JUST:PrintSetupF.SpeedButton11.Click;
    end;
    Case PrintRange of
     PR_ALL:PrintSetupF.RadioButton3.Checked:=True;
     PR_ODD:PrintSetupF.RadioButton4.Checked:=True;
     PR_EVEN:PrintSetupF.RadioButton5.Checked:=True;
    end;
    PrintSetupF.Memo2.Lines.Text:=DownKolontit.Text;
    PrintSetupF.Memo2.Font.Assign(DownKolontit.Font);
    PrintSetupF.Memo2.Font.Size:=((3*PrintSetupF.Memo2.Font.Size) div 2);
    Case DownKolontit.Align of
     AL_LEFT:PrintSetupF.SpeedButton5.Click;
     AL_CENTER:PrintSetupF.SpeedButton6.Click;
     AL_RIGHT:PrintSetupF.SpeedButton7.Click;
     AL_JUST:PrintSetupF.SpeedButton12.Click;
    end;

    PrintSetupF.RadioButton1.Checked:=True;
    if Orientation=O_LANDS then PrintSetupF.RadioButton2.Checked:=True;
    PrintSetupF.BitBtn2.Visible:=FViewBtn;
    PrintSetupF.ShowModal;
    F:=PrintSetupF.Flag;
    if F>0 then
     begin
      PageSize:=PrintSetupF.ComboBox1.ItemIndex;
      LeftMargin:=MMToPix(PrintSetupF.UpDown2.Position);
      RightMargin:=MMToPix(PrintSetupF.UpDown3.Position);
      TopMargin:=MMToPix(PrintSetupF.UpDown1.Position);
      BottomMargin:=MMToPix(PrintSetupF.UpDown4.Position);
      if PrintSetupF.RadioButton1.Checked then Orientation:=O_PORTR
                                          else Orientation:=O_LANDS;
      PrintScale:=0.01*PrintSetupF.UpDown5.Position;

      UpKolontit.Text:=PrintSetupF.Memo1.Lines.Text;
      UpKolontit.Font.Assign(PrintSetupF.Memo1.Font);
      UpKolontit.Font.Size:=((2*UpKolontit.Font.Size) div 3);
      UpKolontit.Align:=PrintSetupF.FAlignU;

      DownKolontit.Text:=PrintSetupF.Memo2.Lines.Text;
      DownKolontit.Font.Assign(PrintSetupF.Memo2.Font);
      DownKolontit.Font.Size:=((2*DownKolontit.Font.Size) div 3);
      DownKolontit.Align:=PrintSetupF.FAlignD;
      PrintDirect:=Not PrintSetupF.CheckBox1.Checked;
      if PrintSetupF.RadioButton3.Checked then PrintRange:=PR_ALL else
      if PrintSetupF.RadioButton4.Checked then PrintRange:=PR_ODD else
      if PrintSetupF.RadioButton5.Checked then PrintRange:=PR_EVEN;

      BuildQueue;
     end;
   finally
    PrintSetupF.Free;
   end;
   Case F of
    2:PrintDialog;
    3:PreView;
   end;
   if F<=0 then raise EAbort.Create('');
   Result:=True;
  except
   Result:=False;
  end;
 end;

procedure TPrintRep.SetPageSize(const V:MyInteger);
 begin
  if V in [0..3] then FPageSize:=V else FPageSize:=PF_A4;
 end;

function TPrintRep.GetPageHeight:MyInteger;
 begin
  Result:=2970;
  Case FOrientation of
   O_PORTR:Case FPageSize of
            PF_A3:Result:=4200;
            PF_A4:Result:=2970;
            PF_A5:Result:=2100;

            PF_S1:Result:=980;
           end;
   O_LANDS:Case FPageSize of
            PF_A3:Result:=2970;
            PF_A4:Result:=2100;
            PF_A5:Result:=1480;

            PF_S1:Result:=980;
           end;
  end;
  Result:=Result-FMinTopMargin-FMinBottomMargin;
 end;

function TPrintRep.GetPageWidth:MyInteger;
 begin
  Result:=2100;
  Case FOrientation of
   O_LANDS:Case FPageSize of
            PF_A3:Result:=4200;
            PF_A4:Result:=2970;
            PF_A5:Result:=2100;

            PF_S1:Result:=980;
           end;
   O_PORTR:Case FPageSize of
            PF_A3:Result:=2970;
            PF_A4:Result:=2100;
            PF_A5:Result:=1480;

            PF_S1:Result:=980;
           end;
  end;
  Result:=Result-FMinLeftMargin-FMinRightMargin;
 end;

procedure TPrintRep.SetOrientation(const V:MyInteger);
 begin
  if V in [O_PORTR,O_LANDS] then
   begin
    FOrientation:=V;
    Case V of
     O_PORTR:Printer.Orientation:=poPortrait;
     O_LANDS:Printer.Orientation:=poLandscape;
    end;
   end;
 end;

procedure TCustomRep.SetPrintScale(const V:Real);
 begin
  if V<0.1 then FPrintScale:=0.1 else
  if V>1 then FPrintScale:=1 else FPrintScale:=V;
 end;

function TPrintRep.PrintDialog:Boolean;
var P:TPrintTh;
 begin
  try
   BuildQueue;
   FPDialog.Options:=[poPageNums];
   FPDialog.MinPage:=1;
   FPDialog.FromPage:=1;
   FPDialog.ToPage:=NumPages;
   FPDialog.MaxPage:=NumPages;
   if Not(FPDialog.Execute) then raise EAbort.Create('');
//   ShowMessage('1');
   FIsDialog:=True;
   try
    if FPDialog.PrintRange=prAllPages then
     begin
      MinPage:=1;
      MaxPage:=NumPages;
     end else
    if FPDialog.PrintRange=prPageNums then
     begin
      MinPage:=FPDialog.FromPage;
      MaxPage:=FPDialog.ToPage;
     end;
    SilentPrint:=False;
    FIsPrinting:=True;
//    ShowMessage('2');
    PrintStatusF:=TPrintStatusF.Create(nil);
    PrintStatusF.ProgressBar1.Min:=MinPage;
    PrintStatusF.ProgressBar1.Max:=MaxPage;
    PrintStatusF.Label1.Caption:='Печать '+#10+' на '+#10+Printer.Printers[Printer.PrinterIndex];
//    ShowMessage('3');
    P:=TPrintTh.Create(True);
//    ShowMessage('4');
    P.Resume;
//    ShowMessage('5');
    PrintStatusF.ShowModal;
    if PrintStatusF.Flag=1 then FIsPrinting:=False;
    Result:=True;
   finally
    FIsDialog:=False;
   end;
  except
   on E:Exception do
    begin
     if E.Message<>'' then ShowMessage(E.Message);
     Result:=False;
   end;
  end;
 end;

destructor TPrintRep.Destroy;
 begin
  Clear;
  FPDialog.Free;
  UpKolontit.Free;
  DownKolontit.Free;
  inherited;
 end;

procedure TCustomRep.BuildQueue;
var i,Y,NP:Integer;
 begin
  for i:=Low(FBlocks) to High(FBlocks) do
   begin
    if i=Low(FBlocks) then
     begin
      Y:=FCellY+FTopMargin; NP:=FFirstPage;
     end else begin
               Y:=FBlocks[i-1].LastY; NP:=FBlocks[i-1].LastPage;
              end;
    FBlocks[i].X:=0;
    FBlocks[i].Y:=Y;
    FBlocks[i].NumPage:=NP;
    FBlocks[i].Bounds:=Rect(FLm,FTm,FPw-FRm,FPh-FBm);
    FBlocks[i].Build;
    if i=High(FBlocks) then
     begin
      FLastPage:=FBlocks[i].LastPage;
      FLastY:=FBlocks[i].LastY;
     end;
   end;
 end;

function TPrintRep.GetNumPages:MyInteger;
var i:Integer;
    Max:Integer;
 begin
  Max:=0;
  for i:=Low(FBlocks) to High(FBlocks) do
   if FBlocks[i].NumPages>Max then Max:=FBlocks[i].NumPages;
  Result:=Max;
 end;

function TPrintRep.GetKp:ShortInt;
 begin
  Result:=1;
  if FPrintSource=TO_PRINT then Result:=-1;
 end;

function TPrintRep.GetMaxPage:MyInteger;
 begin
  if FIsDialog then Result:=FMaxPage else Result:=NumPages;
 end;

function TPrintRep.GetMinPage:MyInteger;
 begin
  if FIsDialog then Result:=FMinPage else Result:=1;
 end;

procedure TPrintRep.SetMaxPage(const Value:MyInteger);
var NP:Integer;
 begin
  NP:=NumPages;
  if Value>NP then FMaxPage:=NP else FMaxPage:=Value;
 end;

procedure TPrintRep.SetMinPage(const Value:MyInteger);
 begin
  if Value<1 then FMaxPage:=1 else FMinPage:=Value;
 end;

procedure TCustomRep.SetBottomBorder(Value:TBorder);
 begin
  FBottomBorder:=Value;
 end;

procedure TCustomRep.SetLeftBorder(Value:TBorder);
 begin
  FLeftBorder:=Value;
 end;

procedure TCustomRep.SetRightBorder(Value:TBorder);
 begin
  FRightBorder:=Value;
 end;

procedure TCustomRep.SetTopBorder(Value:TBorder);
 begin
  FTopBorder:=Value;
 end;

procedure TPrintRep.BuildQueue;
var iT:Integer;
 begin
  iT:=FTopMargin;
  try
   FLm:=Round(LeftMargin/FPrintScale);
   FRm:=Round(RightMargin/FPrintScale);
   FBm:=Round(BottomMargin/FPrintScale);
   FPw:=Round(PageWidth/FPrintScale);
   FPh:=Round(PageHeight/FPrintScale);
   FTm:=Round(TopMargin/FPrintScale);

   UpKolontit.Clear;
   UpKolontit.FCellY:=0;
   UpKolontit.FFirstPage:=1;
   UpKolontit.FLm:=FLm;
   UpKolontit.FTm:=0;
   UpKolontit.TopMargin:=0;
   UpKolontit.FLm:=FLm;
   UpKolontit.FRm:=FRm;
   UpKolontit.FBm:=FBm;
   UpKolontit.FPh:=FPh;
   UpKolontit.FPw:=FPw;
   UpKolontit.AddText(UpKolontit.Text);
   UpKolontit.BuildQueue;
   if UpKolontit.FLastY>FTopMargin then FTopMargin:=UpKolontit.FLastY;

   FTm:=Round(TopMargin/FPrintScale);

   DownKolontit.Clear;
   DownKolontit.FCellY:=0;
   DownKolontit.FFirstPage:=1;
   DownKolontit.FLm:=FLm;
   DownKolontit.FTm:=0;
   DownKolontit.TopMargin:=0;
   DownKolontit.FLm:=FLm;
   DownKolontit.FRm:=FRm;
   DownKolontit.FBm:=0;
   DownKolontit.FPh:=FPh;
   DownKolontit.FPw:=FPw;
   DownKolontit.AddText(DownKolontit.Text);
//   DownKolontit.AddImage(DownKolontit.Picture);
   DownKolontit.BuildQueue;
   if DownKolontit.FLastY>FBm then FBm:=DownKolontit.FLastY;

   FFirstPage:=FNumPage;
   inherited;
  finally
   FTopMargin:=iT;
  end;
 end;

procedure TPrintRep.Init;
 begin
  FMinLeftMargin:=0;
  FMinRightMargin:=0;
  FMinTopMargin:=0;
  FMinBottomMargin:=0;

  FPageSize:=PF_A4;
  LeftMargin:=100;
  RightMargin:=100;
  TopMargin:=100;
  BottomMargin:=150;
  FOrientation:=O_PORTR;
  UpKolontit.Text:='';
  UpKolontit.Align:=Align;
  UpKolontit.Font.Assign(FFont);

  DownKolontit.Text:='';
  DownKolontit.Align:=Align;
  DownKolontit.Font.Assign(FFont);
 end;

procedure TPrintRep.Clear;
 begin
  inherited;
  Init;
 end;

procedure TPrintRep.PrintStiker;
var i,j,k,RC:Integer;
    Tb,Tb1:TTableObj;
    EAN13:String;
    Br:TBorder;
 begin
  if Qr=nil then Exit;
  RC:=Qr.RecordCount;
  if RC mod 3<>0 then RC:=RC+(3-(RC mod 3));
  PrintRep.Font.Name:='Arial';
  PrintRep.Font.Size:=4;
  PrintRep.AddTable(1,RC div 3);

  Tb:=PrintRep.LastTable;
  Qr.First;
  Br:=Border(clBlack,2,psSolid);
  for j:=1 to RC div 3 do
   begin
    Tb.Cell[1,j].LeftMargin:=3; Tb.Cell[1,j].TopMargin:=3; Tb.Cell[1,j].BottomMargin:=3; Tb.Cell[1,j].RightMargin:=3;
    Tb.Cell[1,j].AddTable(6,2);
    Tb.SetBorders(1,j,1,j,EMPTY_BORDER);
    Tb1:=Tb.Cell[1,j].LastTable;
    Tb1.SetWidths('6100,3900,6100,3900,6100,3900');
    for i:=1 to 3 do
     begin
      if Qr.Eof then Break;
      Tb1.MergeCells(i*2-1,1,i*2,1);
      Tb1.Cell[i*2-1,1].BottomBorder:=EMPTY_BORDER;
      Tb1.Cell[i*2-1,2].RightBorder:=EMPTY_BORDER;

      Tb1.Cell[i*2-1,1].Font.Size:=3;
//      Tb1.Cell[i*2-1,1].Font.Style:=[fsBold];
      Tb1.Cell[i*2-1,1].Align:=AL_CENTER;
      Tb1.Cell[i*2-1,1].AddText(Qr.FieldByName('Names').AsString);

      Tb1.Cell[i*2,2].Font.Size:=3;
      Tb1.Cell[i*2,2].Align:=AL_CENTER;
      Tb1.Cell[i*2,2].AddText(IntToStr(Qr.FieldByName('Art_Code').AsInteger)+#10+DateToStr(Date));
      for k:=1 to 2 do Tb1.Cell[k*2-1,1].RightBorder:=Br;
      for k:=1 to 2 do Tb1.Cell[k*2+1,2].LeftBorder:=Br;

      EAN13:=Copy(Qr.FieldByName('EAN13').AsString,1,12);
      if Length(EAN13)=12 then
       begin
        Tb1.Cell[i*2-1,2].Font.Name:='EanBwrP36Tt';
        Tb1.Cell[i*2-1,2].Font.Size:=10;
        Tb1.Cell[i*2-1,2].Font.CharSet:=ANSI_CHARSET;
        Tb1.Cell[i*2-1,2].AddText(GenEAN13(EAN13));
       end;
      Qr.Next;
     end;
    if Qr.Eof then Break;
   end;
 end;

(*
procedure TPrintRep.PrintCennik(Firm:String; MaxSkd:Real; Skd:Byte=0; Param:Byte=0; Param1:Boolean=False);
var k,i,j,RC,MaxL,y:Integer;
    Tb,Tb1:TTableObj;
    EAN13:String;
    Br:TBorder;

 Begin
  if Param1 then
   begin
    PrintRep.LeftMargin:=230;
    PrintRep.RightMargin:=230;
    PrintRep.TopMargin:=50;
    PrintRep.BottomMargin:=50;
   end;

  if Qr=nil then Exit;
  RC:=Qr.RecordCount;
  if RC mod 3<>0 then RC:=RC+(3-(RC mod 3));
  PrintRep.Font.Name:='Arial';
  PrintRep.Font.Size:=4;
  PrintRep.AddTable(1,RC div 3);
  Tb:=PrintRep.LastTable;
  Qr.First;
  Br:=Border(clBlack,6,psSolid);
  for j:=1 to RC div 3 do
   begin
    Tb.Cell[1,j].LeftMargin:=3; Tb.Cell[1,j].TopMargin:=3; Tb.Cell[1,j].BottomMargin:=3; Tb.Cell[1,j].RightMargin:=3;
    if Param1 then Tb.Cell[1,j].AddTable(7,3) else
    if Skd=0 then Tb.Cell[1,j].AddTable(6,3)
             else Tb.Cell[1,j].AddTable(6,4);
    Tb.SetBorders(1,j,1,j,Br);

    Tb1:=Tb.Cell[1,j].LastTable;
    if Param1 then Tb1.Cell[7,1].AddInterv(7);
   {   Tb1.SetBorders(1,1,6,3,EMPTY_BORDER);

    Tb1.Cell[2,1].LeftBorder:=DEFAULT_BORDER;
    for k:=2 to 3 do Tb1.Cell[2,k].RightBorder:=DEFAULT_BORDER;

    Tb1.Cell[4,1].LeftBorder:=DEFAULT_BORDER;
    for k:=2 to 3 do Tb1.Cell[4,k].RightBorder:=DEFAULT_BORDER;
}
//    for k:=1 to 3 do Tb1.Cell[1,k].LeftBorder:=Br;

    for k:=1 to 2 do Tb1.Cell[k*2-1,1].RightBorder:=Br;
    for k:=1 to 2 do Tb1.Cell[k*2+1,2].LeftBorder:=Br;
    for k:=1 to 2 do Tb1.Cell[k*2+1,3].LeftBorder:=Br;
    for k:=1 to 2 do Tb1.Cell[k*2+1,4].LeftBorder:=Br;

 {    begin
      Tb1.Cell[1,k].RightBorder:=Br;
      Tb1.Cell[3,k].LeftBorder:=Br;
     end; }
    Case Param1 of
     False:Tb1.SetWidths('3900,6100,3900,6100,3900,6100');
     True:begin
           Tb1.SetWidths('4000,5900,4000,5900,4000,5900,5');
           for k:=1 to 3 do Tb1.Cell[7,k].LeftBorder:=EMPTY_BORDER;
          end;
    end;
    for i:=1 to 3 do
     begin
      if Qr.Eof then Break;
      Tb1.MergeCells(i*2-1,1,i*2,1);
{      Case Param1 of
       False:
       True:Tb1.Cell[i*2-1,1].Font.Size:=4;
      end;}
      Tb1.Cell[i*2-1,1].Font.Size:=5;
      Tb1.Cell[i*2-1,1].Font.Style:=[fsBold];
      Tb1.Cell[i*2-1,1].Align:=AL_CENTER;
      if Param1 then Tb1.Cell[i*2-1,1].AddInterv(1);
      Tb1.Cell[i*2-1,1].AddText(Qr.FieldByName('Names').AsString);

{      if Param1=False then
       begin
}        y:=3;

        Tb1.Cell[i*2,2].Align:=AL_JUST;
        if Param1=False then
         begin
          Tb1.Cell[i*2-1,2].Font.Size:=2;
          Tb1.Cell[i*2-1,2].AddText(AnsiUpperCase(Firm));
          Tb1.Cell[i*2,2].Font.Size:=2;
          Tb1.Cell[i*2,2].AddText(DateToStr(Date)+' ');
         end;

        Tb1.Cell[i*2,2].Font.Size:=3;
        if Param1=False then
         begin
          Tb1.Cell[i*2,2].AddText(IntToStr(Qr.FieldByName('P1').AsInteger)+'/');
          Tb1.Cell[i*2,2].AddText(IntToStr(Qr.FieldByName('P2').AsInteger)+'/');
          Tb1.Cell[i*2,2].AddText(IntToStr(Qr.FieldByName('P3').AsInteger)+' ');
         end;

        Case Param1 of
         False:Tb1.Cell[i*2,2].AddText(IntToStr(Qr.FieldByName('Art_Code').AsInteger));
         True:begin
               Tb1.Cell[i*2,2].Align:=AL_RIGHT;
               Tb1.Cell[i*2,2].AddText(IntToStr(Qr.FieldByName('Art_Code').AsInteger));
               Tb1.Cell[i*2-1,2].RightBorder:=EMPTY_BORDER;
              end;
        end;
//       end else y:=3;
        // Добавление Штрих-Кода
      Tb1.Cell[i*2,y].Align:=AL_RIGHT;
      if Param1=False then
       begin
        if Skd=0 then Tb1.Cell[i*2,y].Font.Size:=9
                 else Case Param of
                       0:begin Tb1.Cell[i*2,y].Font.Style:=[fsBold]; Tb1.Cell[i*2,y].Font.Size:=4; end;
                       1:begin Tb1.Cell[i*2,y].Font.Style:=[fsBold,fsStrikeOut]; Tb1.Cell[i*2,y].Font.Size:=7; end;
                      end;
       end else begin Tb1.Cell[i*2,y].Font.Style:=[fsBold]; Tb1.Cell[i*2,y].Font.Size:=9; end;

//      if Param1 then Tb1.Cell[i*2,y].AddInterv(1);
      Tb1.Cell[i*2,y].AddText(CurrToStrF(Qr.FieldByName('Cena').AsCurrency,ffFixed,2));
      Tb1.Cell[i*2,y].Font.Size:=3;
      Tb1.Cell[i*2,y].Font.Style:=[];
      Tb1.Cell[i*2,y].AddText(' грн.');

      if Param1 then Tb1.Cell[i*2,y].AddInterv(3);

      if Param1=False then
       begin
        if Skd<>0 then
         begin
          Tb1.Cell[i*2-1,4].Font.Size:=4;
          Tb1.Cell[i*2-1,4].Font.Style:=[fsBold];
          Case Param of
           0:Tb1.Cell[i*2-1,4].AddText('Со скидкой');
           1:Tb1.Cell[i*2-1,4].AddText('Скидка '+IntToStr(Skd)+'%');
          end;

          Tb1.Cell[i*2,4].Align:=AL_RIGHT;
          Tb1.Cell[i*2,4].Font.Size:=8;
          Tb1.Cell[i*2,4].Font.Style:=[fsBold];
          Tb1.Cell[i*2,4].AddText(CurrToStrF(((100-Skd)/100)*Qr.FieldByName('Cena').AsCurrency,ffFixed,2));
          Tb1.Cell[i*2,4].Font.Size:=3;
          Tb1.Cell[i*2,4].Font.Style:=[];
          Tb1.Cell[i*2,4].AddText(' грн.');
         end;
       end;
//      if Param1=False then
       begin
        EAN13:=Copy(Qr.FieldByName('EAN13').AsString,1,12);
        if Length(EAN13)=12 then
         begin
          Tb1.Cell[i*2-1,y].Font.Name:='EanBwrP36Tt';
          Tb1.Cell[i*2-1,y].Font.Size:=8;
          Tb1.Cell[i*2-1,y].Font.CharSet:=ANSI_CHARSET;
//        if Param1 then Tb1.Cell[i*2-1,y].AddInterv(2);
          Tb1.Cell[i*2-1,y].AddText(GenEAN13(EAN13));
         end;
       end;
      Qr.Next;
     end;
    if Qr.Eof then Break;
   end;
 end;
*)

procedure TPrintRep.PrintCennikExt;
var TypeA,RC,N4,WidthMM,j,ii,i,szMainCena,szSecondCena,k,dxa:Integer;
    Tb,Tb1,Tb2:TTableObj;
    EAN13,ss,sGrn,sKolEd,sCn,ssA,sCnMain,sCap:String;
    Br:TBorder;
    IsOpt:Boolean;

const SZ_NAMES=3;

function Ind(N:Integer; sd:Integer=0):Integer;
 begin
  if TypeA=0 then Result:=N
             else Result:=N*3-1+sd;
 end;

 Begin
  if Qr=nil then Exit;
  FPageSetupChange:=False;

  RC:=Qr.RecordCount;
  N4:=Qr.FieldByName('NumInRow').AsInteger;
  WidthMM:=Qr.FieldByName('WidthMM').AsInteger;
  IsOpt:=Qr.FieldByName('IsOpt').AsInteger=1;
  TypeA:=Qr.FieldByName('Type_Akc').AsInteger;

  if RC mod N4<>0 then RC:=RC+(N4-(RC mod N4));

  PrintRep.Font.Name:='Arial';
  PrintRep.Font.Size:=SZ_NAMES;
  PrintRep.AddTable(1,RC div N4);

  Tb2:=PrintRep.LastTable;
  Tb2.SetWidths(IntToStr(N4*WidthMM*10+40));
  Qr.First;
  Br:=Border(clBlack,6,psSolid);

  for j:=1 to RC div N4 do
   begin
    if TypeA=0 then
     begin
      Tb2.Cell[1,j].AddTable(N4+1,2);
      dxa:=0;
     end else begin
               Tb2.Cell[1,j].AddTable(N4*3+1,3);
               dxa:=1;
              end;

    Tb2.Cell[1,j].LeftMargin:=0; Tb2.Cell[1,j].TopMargin:=0; Tb2.Cell[1,j].BottomMargin:=0; Tb2.Cell[1,j].RightMargin:=0;
    Tb2.SetBorders(1,j,1,j,EMPTY_BORDER);

    Tb:=Tb2.Cell[1,j].LastTable;
    ss:='';
    for i:=1 to N4 do
     begin
      if TypeA=0 then ss:=ss+IntToStr(WidthMM*10)+','
                 else ss:=ss+'50,'+IntToStr((WidthMM-10)*10)+',50,';
     end;

    Tb.SetWidths(ss+'40');

    for i:=1 to N4+1 do
     begin
      Tb.Cell[Ind(i),2].LeftMargin:=0; Tb.Cell[Ind(i),2].TopMargin:=0; Tb.Cell[Ind(i),2].BottomMargin:=0; Tb.Cell[Ind(i),2].RightMargin:=0;

      if i<N4+1 then
       begin
        Tb.Cell[Ind(i,-1),1].LeftBorder:=Br;
        Tb.Cell[Ind(i,-1),2].LeftBorder:=Br;
        Tb.Cell[Ind(i,+1),1].RightBorder:=Br;
        Tb.Cell[Ind(i,+1),2].RightBorder:=Br;
        Tb.Cell[Ind(i),1].TopBorder:=Br;

        if TypeA=0 then
         begin
          Tb.Cell[Ind(i),2].BottomBorder:=Br;
         end else
        if TypeA>0 then
         begin
          Tb.Cell[Ind(i,-1),3].LeftBorder:=Br;
          Tb.Cell[Ind(i,+1),3].RightBorder:=Br;

          Tb.Cell[Ind(i,-1),1].TopBorder:=Br;
          Tb.Cell[Ind(i,+1),1].TopBorder:=Br;

          Tb.Cell[Ind(i,-1),3].BottomBorder:=Br;
          Tb.Cell[Ind(i,+0),3].BottomBorder:=Br;
          Tb.Cell[Ind(i,+1),3].BottomBorder:=Br;

          Tb.Cell[Ind(i,-1),1].BottomBorder:=EMPTY_BORDER;
          Tb.Cell[Ind(i,-1),2].BottomBorder:=EMPTY_BORDER;
          Tb.Cell[Ind(i,+1),1].BottomBorder:=EMPTY_BORDER;
          Tb.Cell[Ind(i,+1),2].BottomBorder:=EMPTY_BORDER;

          for ii:=1 to 3 do
           begin
            Tb.Cell[Ind(i,-1),ii].LeftMargin:=0;
            Tb.Cell[Ind(i,-1),ii].RightMargin:=0;
            Tb.Cell[Ind(i,-1),ii].Align:=AL_CENTER;
            Tb.Cell[Ind(i,-1),ii].Font.Size:=4;
            Tb.Cell[Ind(i,+1),ii].LeftMargin:=0;
            Tb.Cell[Ind(i,+1),ii].RightMargin:=0;
            Tb.Cell[Ind(i,+1),ii].Align:=AL_CENTER;
            Tb.Cell[Ind(i,+1),ii].Font.Size:=4;
           end;

          Tb.Cell[Ind(i,-1),1].AddText('!'#10'!'#10'!'#10);
          Tb.Cell[Ind(i,+1),1].AddText('!'#10'!'#10'!'#10);

          Tb.Cell[Ind(i,-1),2].AddText('!'#10'!'#10'!'#10'!'#10'!');
          Tb.Cell[Ind(i,+1),2].AddText('!'#10'!'#10'!'#10'!'#10'!');

          {
           Tb.Cell[Ind(i,-1),3].AddText('!');
           Tb.Cell[Ind(i,+1),3].AddText('!');
          }
         end;

        if Qr.Eof=False then
         begin
          Tb.Cell[Ind(i),1].TopMargin:=15;
          Tb.Cell[Ind(i),1].BottomMargin:=0;

          TypeA:=Qr.FieldByName('Type_Akc').AsInteger;

          if TypeA>0 then
           begin
            Tb.Cell[Ind(i),3].TopMargin:=0;
            Tb.Cell[Ind(i),3].BottomMargin:=10;
            Tb.Cell[Ind(i),3].Font.Size:=5;
            Tb.Cell[Ind(i),3].Align:=AL_CENTER;
            Tb.Cell[Ind(i),3].BColor:=$00595959;
            Tb.Cell[Ind(i),3].Font.Color:=clWhite;
            Tb.Cell[Ind(i),3].Font.Style:=[fsBold];

            if TypeA=1 then ssA:=AnsiUpperCase('Краща цiна!') else
            if TypeA=2 then ssA:='УВАГА! ЗНИЖКА!' else ssA:='УВАГА! АКЦIЯ!';
            Tb.Cell[Ind(i),3].AddText(ssA);
           end;

          sGrn:='грн'#10;

          Tb.Cell[Ind(i),1].Font.Size:=SZ_NAMES;
          Tb.Cell[Ind(i),1].Align:=AL_CENTER;
          Tb.Cell[Ind(i),1].Font.Style:=[fsBold];
          Tb.Cell[Ind(i),1].AddText(Qr.FieldByName('Names').AsString);

          Tb.Cell[Ind(i),2].AddTable(4,4);
          Tb1:=Tb.Cell[Ind(i),2].LastTable;

          Tb1.SetWidths('210,70,92,65');
          Tb1.MergeCells(1,1,1,2);
          Tb1.Cell[1,1].LeftMargin:=0;
          Tb1.Cell[1,1].RightMargin:=0;

          EAN13:=Copy(Qr.FieldByName('EAN13').AsString,1,12);
          if Length(EAN13)=12 then
           begin
            Tb1.Cell[1,1].Align:=AL_CENTER;
            Tb1.Cell[1,1].Font.Name:='EanBwrP36Tt';
            Tb1.Cell[1,1].Font.Size:=8;
            Tb1.Cell[1,1].Font.CharSet:=ANSI_CHARSET;
            Tb1.Cell[1,1].AddText(GenEAN13(EAN13));
           end;

          Tb1.Cell[2,1].Font.Size:=2;
          Tb1.Cell[2,1].AddText(DateToStr(Date));
          Tb1.Cell[2,1].AddInterv(1);
          Tb1.Cell[2,1].RightBorder:=EMPTY_BORDER;
          Tb1.Cell[2,1].RightMargin:=0;

          Tb1.Cell[3,1].Align:=AL_CENTER;
          Tb1.Cell[3,1].Font.Size:=2;
          Tb1.Cell[3,1].AddText(Qr.FieldByName('NmReg').AsString);
          Tb1.Cell[3,1].LeftMargin:=0;
          Tb1.Cell[3,1].RightMargin:=0;

          Tb1.Cell[4,1].Font.Size:=2;
          Tb1.Cell[4,1].Align:=AL_RIGHT;
          Tb1.Cell[4,1].AddText(IntToStr(Qr.FieldByName('Art_Code').AsInteger));
          Tb1.Cell[4,1].LeftMargin:=0;
          Tb1.Cell[4,1].LeftBorder:=EMPTY_BORDER;

          Tb1.MergeCells(2,2,4,2);
          Tb1.Cell[2,2].Align:=AL_CENTER;
          Tb1.Cell[2,2].Font.Size:=2;
          Tb1.Cell[2,2].AddText(AnsiUpperCase(Qr.FieldByName('FirmName').AsString));

          Tb1.MergeCells(2,4,4,4);
          sCnMain:=CurrToStrF(Qr.FieldByName('Cena').AsCurrency,ffFixed,2);
          szMainCena:=7;
          szSecondCena:=6;

          if (IsOpt=False) and (TypeA=0) then
           begin
            Tb1.MergeCells(1,3,4,3);
            Tb1.MergeCells(1,4,4,4);
            szMainCena:=10;
            Tb1.Cell[3,3].LeftBorder:=EMPTY_BORDER;
            Tb1.Cell[3,3].RightBorder:=EMPTY_BORDER;

            for k:=2 to 4 do Tb1.Cell[k,3].BottomBorder:=EMPTY_BORDER;

           end else
          if TypeA in [1,3,4] then
           begin
            szMainCena:=6;
            Tb1.MergeCells(1,3,4,3);
            Tb1.Cell[1,4].Font.Size:=4;
            Tb1.Cell[1,4].Font.Style:=[fsBold];
            Tb1.Cell[1,4].Align:=AL_LEFT;
            Tb1.Cell[1,4].Indent:=1;

            Case TypeA of
             1:begin
                sCap:='Акцiя'; // sCap:='Краща'#10'цiна';
                sCnMain:=CurrToStrF(Qr.FieldByName('CenaA').AsCurrency,ffFixed,2);
               end;
             4:sCap:='Плюс'#10'подарунок';
            end;

            Tb1.Cell[1,4].AddText(sCap);
           end else
          if (TypeA=2) then
           begin
            szMainCena:=6;
            szSecondCena:=6;
            Tb1.Cell[1,3].Font.Size:=3;
            Tb1.Cell[1,3].Font.Style:=[fsBold];
            Tb1.Cell[1,3].Align:=AL_LEFT;
            Tb1.Cell[1,3].Indent:=1;
            Tb1.Cell[1,3].AddText('Стара цiна');

            Tb1.Cell[2,3].LeftBorder:=EMPTY_BORDER;

            Tb1.MergeCells(2,3,4,3);

            Tb1.Cell[1,4].Font.Size:=4;
            Tb1.Cell[1,4].Font.Style:=[fsBold];
            Tb1.Cell[1,4].Align:=AL_LEFT;
            Tb1.Cell[1,4].Indent:=1;
            Tb1.Cell[1,4].AddText('Нова цiна');

            sCn:=CurrToStrF(Qr.FieldByName('Cena').AsCurrency,ffFixed,2);

            Tb1.Cell[2,3].Align:=AL_RIGHT;
            Tb1.Cell[2,3].Font.Size:=szSecondCena;
            Tb1.Cell[2,3].Font.Style:=[fsStrikeOut];
            Tb1.Cell[2,3].AddText(sCn);
            Tb1.Cell[2,3].Font.Size:=2;
            Tb1.Cell[2,3].AddText(sGrn);

            sCnMain:=CurrToStrF(Qr.FieldByName('CenaA').AsCurrency,ffFixed,2);
           end else
          if IsOpt=True then
           begin
            szMainCena:=6;
            szSecondCena:=6;
            Tb1.Cell[1,3].Font.Size:=3;
            Tb1.Cell[1,3].Font.Style:=[fsBold];
            Tb1.Cell[1,3].BColor:=clSilver;
            Tb1.Cell[1,3].Align:=AL_LEFT;
            Tb1.Cell[1,3].Indent:=1;
            Tb1.Cell[1,3].AddText('Накопичення'#10'на карту');

            if Qr.FieldByName('Cena').AsCurrency<=Qr.FieldByName('CenaOpt').AsCurrency then
             sCn:='0'
            else
             sCn:=CurrToStrF(Qr.FieldByName('Cena').AsCurrency-Qr.FieldByName('CenaOpt').AsCurrency,ffFixed,2);
            sKolEd:='(вiд 3-х одиниць)';

            Tb1.MergeCells(2,3,4,3);
            Tb1.Cell[2,3].BColor:=clSilver;
            Tb1.Cell[2,3].Align:=AL_RIGHT;

            Tb1.Cell[2,3].Font.Size:=szSecondCena;
            Tb1.Cell[2,3].AddText(sCn);
            Tb1.Cell[2,3].Font.Size:=2;
            Tb1.Cell[2,3].AddText(sGrn);

            Tb1.Cell[2,3].Align:=AL_CENTER;
            Tb1.Cell[2,3].Font.Size:=3;
            Tb1.Cell[2,3].AddText(sKolEd);
            Tb1.Cell[2,3].LeftBorder:=EMPTY_BORDER;
           end;

          Tb1.Cell[2,4].Align:=AL_RIGHT;
          if IsOpt=True then Tb1.Cell[2,4].Font.Style:=[fsBold];
          Tb1.Cell[2,4].Font.Size:=szMainCena;

          if IsOpt=True then
           begin
            Tb1.Cell[1,4].Indent:=0;
            Tb1.Cell[1,4].Font.Size:=4;
            Tb1.Cell[1,4].Font.Style:=[fsBold];
            Tb1.Cell[1,4].AddText('Роздрiбна'#10'цiна');
            sCnMain:=CurrToStrF(Qr.FieldByName('Cena').AsCurrency,ffFixed,2);
           end;

          Tb1.Cell[2,4].AddText(sCnMain);

          if IsOpt=False then Tb1.Cell[2,4].Font.Size:=3
                         else Tb1.Cell[2,4].Font.Size:=2;

          Tb1.Cell[2,4].Font.Style:=[];
          Tb1.Cell[2,4].AddText('грн');

          Tb1.Cell[2,4].BottomBorder:=EMPTY_BORDER;
          Tb1.Cell[1,4].BottomBorder:=EMPTY_BORDER;
          Tb1.Cell[1,4].LeftBorder:=EMPTY_BORDER;
          Tb1.Cell[1,4].RightBorder:=EMPTY_BORDER;

          Qr.Next;
         end;

       end else begin
                 Tb.Cell[Ind(i),1].AddInterv(SZ_NAMES);
                 Tb.Cell[Ind(i),1].AddInterv(SZ_NAMES);
                 Tb.Cell[Ind(i),1].AddInterv(SZ_NAMES);

                 Tb.Cell[Ind(i),1].TopBorder:=EMPTY_BORDER;
                 Tb.Cell[Ind(i),1].RightBorder:=EMPTY_BORDER;
                 Tb.Cell[Ind(i),1].BottomBorder:=EMPTY_BORDER;
                 Tb.Cell[Ind(i),2].RightBorder:=EMPTY_BORDER;
                 Tb.Cell[Ind(i),2].BottomBorder:=EMPTY_BORDER;
                 Tb.Cell[Ind(i),3].RightBorder:=EMPTY_BORDER;
                 Tb.Cell[Ind(i),3].BottomBorder:=EMPTY_BORDER;
                end;
   end;
  end;
 end;

procedure TPrintRep.PrintCennik(Firm:String; MaxSkd:Real; QrEx:TADOQuery; ID_Apteka:Integer; Skd:Byte=0; Param:Byte=0; Param1:Boolean=False; SkdSrok:Byte=0);
var szMainCena,szSecondCena,tmpSz,k,i,j,RC,MaxL,y,m:Integer;
    Tb,Tb1,Tb2:TTableObj;
    EAN13:String;
    Br:TBorder;
    tSkd:Real;
    sGrn,sCn,sKolEd,sCena:String;
    Vin3:Boolean;

const N4=4;
      SZ_NAMES=3;

 begin

  if Qr=nil then Exit;
  FPageSetupChange:=False;
  RC:=Qr.RecordCount;
  if RC mod 4<>0 then RC:=RC+(4-(RC mod 4));

  PrintRep.Font.Name:='Arial';
  PrintRep.Font.Size:=SZ_NAMES;
  PrintRep.AddTable(1,RC div N4);

(*
  -- Закоментировано 03.08.2017
  Vin3:=(ID_Apteka=280) or (ID_Apteka=254) or (ID_Apteka=304) or (ID_Apteka=226) or (ID_Apteka=301) or (ID_Apteka=316) or
        (ID_Apteka=188) or (ID_Apteka=302) or (ID_Apteka=224) or (ID_Apteka=234) or (ID_Apteka=200); { or (ID_Apteka=313) закоментировано 03.10.2016 по задаче в документообороте}
*)

  Vin3:=False;

 // Vin3:=False;

  Tb2:=PrintRep.LastTable;
  Tb2.SetWidths('1800');
  Qr.First;
  Br:=Border(clBlack,6,psSolid);
  for j:=1 to RC div N4 do
   begin
    Tb2.Cell[1,j].AddTable(N4+1,2);
    Tb2.Cell[1,j].LeftMargin:=0; Tb2.Cell[1,j].TopMargin:=0; Tb2.Cell[1,j].BottomMargin:=0; Tb2.Cell[1,j].RightMargin:=0;
    Tb2.SetBorders(1,j,1,j,EMPTY_BORDER);

    Tb:=Tb2.Cell[1,j].LastTable;
    Tb.SetWidths('450,450,450,450,40');

    for i:=1 to N4+1 do
     begin
      Tb.Cell[i,2].LeftMargin:=0; Tb.Cell[i,2].TopMargin:=0; Tb.Cell[i,2].BottomMargin:=0; Tb.Cell[i,2].RightMargin:=0;

      if i<N4+1 then
       begin
        Tb.Cell[i,1].LeftBorder:=Br;
        Tb.Cell[i,1].RightBorder:=Br;
        Tb.Cell[i,1].TopBorder:=Br;
        Tb.Cell[i,2].LeftBorder:=Br;
        Tb.Cell[i,2].RightBorder:=Br;
        Tb.Cell[i,2].BottomBorder:=Br;
        Tb.Cell[i,2].BottomBorder:=Br;

        if Qr.Eof=False then
         begin
          if MaxSkd<=-3 then Tb.Cell[i,1].TopMargin:=0 else Tb.Cell[i,1].TopMargin:=15;
          Tb.Cell[i,1].BottomMargin:=0;

          sGrn:='грн'#10;

         {
          if MaxSkd<=-3 then
           begin
            Tb.Cell[i,1].Align:=AL_RIGHT;
            Tb.Cell[i,1].Font.Size:=2;
            Tb.Cell[i,1].AddText('АПТЕКА ОПТОВИХ ЦIН'+#10);
           end;
         }
          Tb.Cell[i,1].Font.Size:=SZ_NAMES;
          Tb.Cell[i,1].Align:=AL_CENTER;
          Tb.Cell[i,1].Font.Style:=[fsBold];
          try
           QrEx.Close;
           QrEx.SQL.Text:='select top 1 apteka_net.dbo.GetNamesUpak(case when IsNull(NamesUA,'''')='''' then Names else NamesUA end+'' ''+IsNull(Manufacturer,'''')) as names from apteka_net.dbo.Plist (nolock) where art_code='+Qr.FieldByName('art_code').AsString;
           QrEx.Open;
           Tb.Cell[i,1].AddText(QrEx.FieldByName('Names').AsString);
          except
           Tb.Cell[i,1].AddText(Qr.FieldByName('Names').AsString);
          end;

          Tb.Cell[i,2].AddTable(4,4);
          Tb1:=Tb.Cell[i,2].LastTable;

          Tb1.SetWidths('210,70,92,65');
          Tb1.MergeCells(1,1,1,2);
          Tb1.Cell[1,1].LeftMargin:=0;
          Tb1.Cell[1,1].RightMargin:=0;

          EAN13:=Copy(Qr.FieldByName('EAN13').AsString,1,12);
          if Length(EAN13)=12 then
           begin
            Tb1.Cell[1,1].Align:=AL_CENTER;
            Tb1.Cell[1,1].Font.Name:='EanBwrP36Tt';
            Tb1.Cell[1,1].Font.Size:=8;
            Tb1.Cell[1,1].Font.CharSet:=ANSI_CHARSET;
            Tb1.Cell[1,1].AddText(GenEAN13(EAN13));
           end;

          Tb1.Cell[2,1].Font.Size:=2;
          Tb1.Cell[2,1].AddText(DateToStr(Date));
          Tb1.Cell[2,1].AddInterv(1);
          Tb1.Cell[2,1].RightBorder:=EMPTY_BORDER;
          Tb1.Cell[2,1].RightMargin:=0;

          Tb1.Cell[3,1].Align:=AL_CENTER;
          Tb1.Cell[3,1].Font.Size:=2;
          Tb1.Cell[3,1].AddText(IntToStr(Qr.FieldByName('P1').AsInteger)+'/');
          Tb1.Cell[3,1].AddText(IntToStr(Qr.FieldByName('P2').AsInteger)+'/');
          Tb1.Cell[3,1].AddText(IntToStr(Qr.FieldByName('P3').AsInteger)+' ');
          Tb1.Cell[3,1].LeftMargin:=0;
          Tb1.Cell[3,1].RightMargin:=0;

          Tb1.Cell[4,1].Font.Size:=2;
          Tb1.Cell[4,1].Align:=AL_RIGHT;
          Tb1.Cell[4,1].AddText(IntToStr(Qr.FieldByName('Art_Code').AsInteger));
          Tb1.Cell[4,1].LeftMargin:=0;
          Tb1.Cell[4,1].LeftBorder:=EMPTY_BORDER;

          Tb1.MergeCells(2,2,4,2);
          Tb1.Cell[2,2].Align:=AL_CENTER;
          Tb1.Cell[2,2].Font.Size:=2;
          Tb1.Cell[2,2].AddText(AnsiUpperCase(Firm));

          Tb1.MergeCells(2,4,4,4);

          szMainCena:=7;
          szSecondCena:=6;
          if MaxSkd=-1 then
           begin
            Tb1.MergeCells(1,3,4,3);
            Tb1.MergeCells(1,4,4,4);
            szMainCena:=10;
            Tb1.Cell[3,3].LeftBorder:=EMPTY_BORDER;
            Tb1.Cell[3,3].RightBorder:=EMPTY_BORDER;

            if FID_Apteka<>46 then
             Tb1.Cell[2,3].AddInterv(2);

            for k:=2 to 4 do Tb1.Cell[k,3].BottomBorder:=EMPTY_BORDER;
           end else
          if (MaxSkd>=0) or (SkdSrok=1) then
           begin
            Tb1.MergeCells(1,3,4,3);
            Tb1.Cell[1,3].BColor:=clSilver;
            Tb1.Cell[1,3].Align:=AL_RIGHT;
            Tb1.Cell[1,3].Font.Style:=[fsBold];
            Tb1.Cell[1,3].Font.Size:=3;
            if SkdSrok=1 then
             begin
              Tb1.Cell[1,3].AddText('Старая цена ');
              Tb1.Cell[1,3].Font.Style:=[fsStrikeOut];
              sCena:=CurrToStrF(Qr.FieldByName('Cena').AsCurrency,ffFixed,2);
             end else begin
                       Tb1.Cell[1,3].AddText('Клубная цена ');
                       Tb1.Cell[1,3].Font.Style:=[];
                       sCena:=CurrToStrF(((100-Qr.FieldByName('Skd').AsInteger)/100)*Qr.FieldByName('Cena').AsCurrency,ffFixed,2);
                      end;

            Tb1.Cell[1,3].Font.Size:=szSecondCena;
            Tb1.Cell[1,3].AddText(sCena);

            Tb1.Cell[1,3].Font.Size:=2;
            Tb1.Cell[1,3].AddText('грн');
           end else
          if MaxSkd<=-3 then
           begin
            szMainCena:=6;
            szSecondCena:=6;
            Tb1.Cell[1,3].Font.Size:=3;
            Tb1.Cell[1,3].Font.Style:=[fsBold];
            Tb1.Cell[1,3].BColor:=clSilver;
            Tb1.Cell[1,3].Align:=AL_LEFT;
            Tb1.Cell[1,3].Indent:=1;
            if Vin3 then
             begin
              Tb1.Cell[1,3].Indent:=0;
              Tb1.Cell[1,3].Font.Size:=4;
              Tb1.Cell[1,3].AddText('Стара цiна'#10);

              Tb1.Cell[1,3].Font.Size:=3;
              Tb1.Cell[1,3].AddText('Роздрiбна'#10'цiна зi знижк.');

//              Tb1.Cell[1,3].AddText('Оптова цiна');
              sCn:=CurrToStrF(Qr.FieldByName('Cena').AsCurrency,ffFixed,2);
             end else begin
//                     Tb1.Cell[1,3].AddText('Оптова'#10'цiна');
                       Tb1.Cell[1,3].AddText('Накопичення'#10'на карту');

                       if Qr.FieldByName('Cena').AsCurrency<=Qr.FieldByName('CenaOpt').AsCurrency then
                        sCn:='0'
                       else
                        sCn:=CurrToStrF(Qr.FieldByName('Cena').AsCurrency-Qr.FieldByName('CenaOpt').AsCurrency,ffFixed,2);
                      end;
//            sCn:=CurrToStrF(Qr.FieldByName('CenaOpt').AsCurrency,ffFixed,2);
            sKolEd:='(вiд 3-х одиниць)';


            Tb1.MergeCells(2,3,4,3);
            Tb1.Cell[2,3].BColor:=clSilver;
            Tb1.Cell[2,3].Align:=AL_RIGHT;
            m:=0;
            if Vin3 then
             begin
              m:=1;
              Tb1.Cell[2,3].Font.Size:=4;
              Tb1.Cell[2,3].Font.Style:=Tb1.Cell[2,3].Font.Style+[fsStrikeOut];
              Tb1.Cell[2,3].AddText(CurrToStrF(Qr.FieldByName('Cena').AsCurrency*(100/92),ffFixed,2));
              Tb1.Cell[2,3].Font.Size:=2;
              Tb1.Cell[2,3].AddText('грн.');
              Tb1.Cell[2,3].Font.Size:=4;
              Tb1.Cell[2,3].AddText(#10);
              Tb1.Cell[2,3].Font.Style:=Tb1.Cell[2,3].Font.Style-[fsStrikeOut];
             end;

            Tb1.Cell[2,3].Font.Size:=szSecondCena;
            Tb1.Cell[2,3].AddText(sCn);
            Tb1.Cell[2,3].Font.Size:=2;
            Tb1.Cell[2,3].AddText(sGrn);

            if Vin3=False then
             begin
              Tb1.Cell[2,3].Align:=AL_CENTER;
              Tb1.Cell[2,3].Font.Size:=3;
              Tb1.Cell[2,3].AddText(sKolEd);
             end;
            Tb1.Cell[2,3].LeftBorder:=EMPTY_BORDER;
           end;

//          Tb1.MergeCells(1,4,3,4);
          Tb1.Cell[2,4].Align:=AL_RIGHT;
          if MaxSkd>-3 then Tb1.Cell[2,4].Font.Style:=[fsBold];
          Tb1.Cell[2,4].Font.Size:=szMainCena;

          tmpSz:=Tb1.Cell[2,4].Font.Size;
          if SkdSrok=1 then
           begin
            Tb1.Cell[2,4].Font.Size:=3;
            Tb1.Cell[2,4].Font.Style:=[];
            Tb1.Cell[2,4].AddText('-'+Qr.FieldByName('SkdSrok').AsString+'%  ');
            Tb1.Cell[2,4].Font.Style:=[fsBold];
            Tb1.Cell[2,4].Font.Size:=tmpSz;
            Tb1.Cell[2,4].AddText(CurrToStrF(Qr.FieldByName('Cena').AsCurrency*(1-0.01*Qr.FieldByName('SkdSrok').AsCurrency),ffFixed,2));
           end else begin
                     if MaxSkd<=-3 then
                      begin
//                       Tb1.Cell[1,4].Align:=AL_JUST;
                       Tb1.Cell[1,4].Indent:=0;
                       Tb1.Cell[1,4].Font.Size:=4;
                       Tb1.Cell[1,4].Font.Style:=[fsBold];
                       if Vin3 then
                        begin
                         Tb1.Cell[1,4].Font.Size:=4;
                         Tb1.Cell[1,4].AddText('Оптова цiна');
                         Tb1.Cell[2,4].AddText(CurrToStrF(Qr.FieldByName('CenaOpt').AsCurrency,ffFixed,2));
                         {
                          Tb1.Cell[1,4].AddText('Роздрiбна'#10'цiна зi знижк.');
                          Tb1.Cell[2,4].AddText(CurrToStrF(Qr.FieldByName('Cena').AsCurrency,ffFixed,2));
                         }
                        end else begin
                                  Tb1.Cell[1,4].AddText('Роздрiбна'#10'цiна');
                                  Tb1.Cell[2,4].AddText(CurrToStrF(Qr.FieldByName('Cena').AsCurrency,ffFixed,2));
                                 end;
                      end else Tb1.Cell[2,4].AddText(CurrToStrF(Qr.FieldByName('Cena').AsCurrency,ffFixed,2));
                    end;

          if MaxSkd=-1 then Tb1.Cell[2,4].Font.Size:=3
                       else Tb1.Cell[2,4].Font.Size:=2;

          Tb1.Cell[2,4].Font.Style:=[];
          Tb1.Cell[2,4].AddText('грн');
          if Vin3 then
           begin
            Tb1.Cell[2,4].Align:=AL_CENTER;
            Tb1.Cell[2,4].Font.Size:=3;
            Tb1.Cell[2,4].AddText(#10+sKolEd);
           end;
//          Tb1.Cell[2,4].AddInterv(2);

          Tb1.Cell[2,4].BottomBorder:=EMPTY_BORDER;
          Tb1.Cell[1,4].BottomBorder:=EMPTY_BORDER;
          Tb1.Cell[1,4].LeftBorder:=EMPTY_BORDER;
          Tb1.Cell[1,4].RightBorder:=EMPTY_BORDER;

          Qr.Next;
         end;

       end else begin
                 Tb.Cell[i,1].AddInterv(SZ_NAMES);
                 Tb.Cell[i,1].AddInterv(SZ_NAMES);
                 Tb.Cell[i,1].AddInterv(SZ_NAMES);

                 Tb.Cell[i,1].TopBorder:=EMPTY_BORDER;
                 Tb.Cell[i,1].RightBorder:=EMPTY_BORDER;
                 Tb.Cell[i,1].BottomBorder:=EMPTY_BORDER;
                 Tb.Cell[i,2].RightBorder:=EMPTY_BORDER;
                 Tb.Cell[i,2].BottomBorder:=EMPTY_BORDER;
                end;
     end;
   end;
  (*
  PrintRep.LeftMargin:=70;
  PrintRep.RightMargin:=70;


  if Qr=nil then Exit;
  RC:=Qr.RecordCount;
  if RC mod 3<>0 then RC:=RC+(3-(RC mod 3));
  PrintRep.Font.Name:='Arial';
  PrintRep.Font.Size:=4;
  PrintRep.AddTable(1,RC div 3);

  Tb:=PrintRep.LastTable;
  Qr.First;
  Br:=Border(clBlack,6,psSolid);
  for j:=1 to RC div 3 do
   begin
    Tb.Cell[1,j].LeftMargin:=3; Tb.Cell[1,j].TopMargin:=3; Tb.Cell[1,j].BottomMargin:=3; Tb.Cell[1,j].RightMargin:=3;
    if Param1 then Tb.Cell[1,j].AddTable(7,4) else
    if Skd=0 then Tb.Cell[1,j].AddTable(6,4)
             else Tb.Cell[1,j].AddTable(6,5);
    Tb.SetBorders(1,j,1,j,Br);

    Tb1:=Tb.Cell[1,j].LastTable;
    if Param1 then Tb1.Cell[7,1].AddInterv(7);
   {   Tb1.SetBorders(1,1,6,3,EMPTY_BORDER);

    Tb1.Cell[2,1].LeftBorder:=DEFAULT_BORDER;
    for k:=2 to 3 do Tb1.Cell[2,k].RightBorder:=DEFAULT_BORDER;

    Tb1.Cell[4,1].LeftBorder:=DEFAULT_BORDER;
    for k:=2 to 3 do Tb1.Cell[4,k].RightBorder:=DEFAULT_BORDER;
}
//    for k:=1 to 3 do Tb1.Cell[1,k].LeftBorder:=Br;

    for k:=1 to 2 do Tb1.Cell[k*2-1,1].RightBorder:=Br;
    for k:=1 to 2 do Tb1.Cell[k*2+1,2].LeftBorder:=Br;
    for k:=1 to 2 do Tb1.Cell[k*2+1,3].LeftBorder:=Br;
    for k:=1 to 2 do Tb1.Cell[k*2+1,4].LeftBorder:=Br;

 {    begin
      Tb1.Cell[1,k].RightBorder:=Br;
      Tb1.Cell[3,k].LeftBorder:=Br;
     end; }
    Case Param1 of
     False:Tb1.SetWidths('3700,6100,3900,6300,3900,6000');
     True:begin
           Tb1.SetWidths('4000,5900,4000,5900,4000,5900,5');
           for k:=1 to 3 do Tb1.Cell[7,k].LeftBorder:=EMPTY_BORDER;
          end;
    end;
    for i:=1 to 3 do
     begin
      if Qr.Eof then Break;
      Tb1.MergeCells(i*2-1,1,i*2,1);
{      Case Param1 of
       False:
       True:Tb1.Cell[i*2-1,1].Font.Size:=4;
      end;}
      Tb1.Cell[i*2-1,1].Font.Size:=5;
      Tb1.Cell[i*2-1,1].Font.Style:=[fsBold];
      Tb1.Cell[i*2-1,1].Align:=AL_CENTER;
      if Param1 then Tb1.Cell[i*2-1,1].AddInterv(1);
      if MaxSkd=-3 then
       begin
        Tb1.Cell[i*2-1,1].Align:=AL_RIGHT;
        Tb1.Cell[i*2-1,1].Font.Size:=2;
        Tb1.Cell[i*2-1,1].AddText('АПТЕКА ОПТОВИХ ЦIН'+#10);

        Tb1.Cell[i*2-1,1].Font.Size:=5;
        Tb1.Cell[i*2-1,1].Font.Style:=[fsBold];
        Tb1.Cell[i*2-1,1].Align:=AL_CENTER;

        Tb1.Cell[i*2-1,1].AddText(Qr.FieldByName('Names').AsString);
       end else Tb1.Cell[i*2-1,1].AddText(Qr.FieldByName('Names').AsString);

{      if Param1=False then
       begin
}        y:=4;

        Tb1.Cell[i*2,2].Align:=AL_JUST;
        if Param1=False then
         begin
          Tb1.Cell[i*2-1,2].Font.Size:=2;
          Tb1.Cell[i*2-1,2].AddText(AnsiUpperCase(Firm));
          Tb1.Cell[i*2,2].Font.Size:=2;
          Tb1.Cell[i*2,2].AddText(DateToStr(Date)+' ');
         end;

        Tb1.Cell[i*2,2].Font.Size:=3;
        if Param1=False then
         begin
          Tb1.Cell[i*2,2].AddText(IntToStr(Qr.FieldByName('P1').AsInteger)+'/');
          Tb1.Cell[i*2,2].AddText(IntToStr(Qr.FieldByName('P2').AsInteger)+'/');
          Tb1.Cell[i*2,2].AddText(IntToStr(Qr.FieldByName('P3').AsInteger)+' ');
         end;

        Case Param1 of
         False:Tb1.Cell[i*2,2].AddText(IntToStr(Qr.FieldByName('Art_Code').AsInteger));
         True:begin
               Tb1.Cell[i*2,2].Align:=AL_RIGHT;
               Tb1.Cell[i*2,2].AddText(IntToStr(Qr.FieldByName('Art_Code').AsInteger));
               Tb1.Cell[i*2-1,2].RightBorder:=EMPTY_BORDER;
              end;
        end;
//       end else y:=3;

      if MaxSkd<>-1 then
       begin
        if MaxSkd=-3 then tSkd:=3 else tSkd:=Qr.FieldByName('Skd').AsCurrency;
        if SkdSrok=1 then tSkd:=0;

        Tb1.Cell[i*2,y].Align:=AL_RIGHT;
        sCena:=CurrToStrF(((100-tSkd)/100)*Qr.FieldByName('Cena').AsCurrency,ffFixed,2);

        Tb1.Cell[i*2,y-1].BColor:=clSilver;
        Tb1.Cell[i*2,y-1].Font.Size:=3;
        Tb1.Cell[i*2,y-1].Align:=AL_RIGHT;

        if MaxSkd=-3 then
         begin
          Tb1.Cell[i*2,y-1].Align:=AL_JUST;
//          Tb1.Cell[i*2,y-1].AddText('Опт. цiна ');
          Tb1.Cell[i*2,y-1].Font.Style:=[fsBold];
          Tb1.Cell[i*2,y-1].Font.Size:=4;

          Case Length(sCena) of
           4:Tb1.Cell[i*2,y-1].AddText('Оптова           ');
           5:Tb1.Cell[i*2,y-1].AddText('Оптова        ');
           6:Tb1.Cell[i*2,y-1].AddText('Оптова    ');
           7:Tb1.Cell[i*2,y-1].AddText('Оптова  ');
          end;

          Tb1.Cell[i*2,y-1].Font.Size:=3;
          Tb1.Cell[i*2,y-1].Font.Style:=[];
         end else begin
                   if SkdSrok=1 then Tb1.Cell[i*2,y-1].AddText('Старая цена ')
                                else Tb1.Cell[i*2,y-1].AddText('Клуб. цена ');
                  end;

//      Tb1.Cell[i*2,y].Font.Style:=[fsBold];

        if MaxSkd=-3 then Tb1.Cell[i*2,y-1].Font.Size:=7 else Tb1.Cell[i*2,y-1].Font.Size:=6;
        if SkdSrok=1 then Tb1.Cell[i*2,y-1].Font.Style:=[fsStrikeOut];

        Tb1.Cell[i*2,y-1].AddText(sCena);
        Tb1.Cell[i*2,y-1].Font.Size:=3;
        Tb1.Cell[i*2,y-1].Font.Style:=[];
        Tb1.Cell[i*2,y-1].AddText('грн');

        if MaxSkd=-3 then
         begin
          Tb1.Cell[i*2,y-1].Align:=AL_LEFT;
          Tb1.Cell[i*2,y-1].Font.Style:=[fsBold];
          Tb1.Cell[i*2,y-1].Font.Size:=4;
          Tb1.Cell[i*2,y-1].AddText(#10'цiна     ');
          Tb1.Cell[i*2,y-1].Font.Size:=3;
          Tb1.Cell[i*2,y-1].Font.Style:=[];
          Tb1.Cell[i*2,y-1].AddText('(вiд 3-х одиниць)');
         end;

       end else Tb1.Cell[i*2,y-1].BottomBorder:=EMPTY_BORDER;

        // Добавление Штрих-Кода
      if Param1=False then
       begin
        if Skd=0 then begin
                       if MaxSkd=-3 then Tb1.Cell[i*2,y].Font.Size:=7 else Tb1.Cell[i*2,y].Font.Size:=9;
                      end
                 else Case Param of
                       0:begin Tb1.Cell[i*2,y].Font.Style:=[fsBold]; Tb1.Cell[i*2,y].Font.Size:=4; end;
                       1:begin Tb1.Cell[i*2,y].Font.Style:=[fsBold,fsStrikeOut]; Tb1.Cell[i*2,y].Font.Size:=7; end;
                      end;
       end else begin Tb1.Cell[i*2,y].Font.Style:=[fsBold]; Tb1.Cell[i*2,y].Font.Size:=9; end;

//      if Param1 then Tb1.Cell[i*2,y].AddInterv(1);

      if SkdSrok=1 then
       begin
        tmpSz:=Tb1.Cell[i*2,y].Font.Size;
        Tb1.Cell[i*2,y].Font.Size:=4;
        Tb1.Cell[i*2,y].AddText('-'+Qr.FieldByName('SkdSrok').AsString+'%  ');

        Tb1.Cell[i*2,y].Font.Size:=8;
        Tb1.Cell[i*2,y].AddText(CurrToStrF(Qr.FieldByName('Cena').AsCurrency*(1-0.01*Qr.FieldByName('SkdSrok').AsCurrency),ffFixed,2));
       end else Tb1.Cell[i*2,y].AddText(CurrToStrF(Qr.FieldByName('Cena').AsCurrency,ffFixed,2));

      Tb1.Cell[i*2,y].Font.Size:=3;
      Tb1.Cell[i*2,y].Font.Style:=[];

      Tb1.Cell[i*2,y].AddText('грн');

      if Param1 then Tb1.Cell[i*2,y].AddInterv(3);

      if Param1=False then
       begin
        if Skd<>0 then
         begin
          Tb1.Cell[i*2-1,4].Font.Size:=4;
          Tb1.Cell[i*2-1,4].Font.Style:=[fsBold];
          Case Param of
           0:Tb1.Cell[i*2-1,4].AddText('Со скидкой');
           1:Tb1.Cell[i*2-1,4].AddText('Скидка '+IntToStr(Skd)+'%');
          end;

          Tb1.Cell[i*2,4].Align:=AL_RIGHT;
          Tb1.Cell[i*2,4].Font.Size:=8;
          Tb1.Cell[i*2,4].Font.Style:=[fsBold];
          Tb1.Cell[i*2,4].AddText(CurrToStrF(((100-Skd)/100)*Qr.FieldByName('Cena').AsCurrency,ffFixed,2));
          Tb1.Cell[i*2,4].Font.Size:=3;
          Tb1.Cell[i*2,4].Font.Style:=[];
          Tb1.Cell[i*2,4].AddText(' грн');
         end;
       end;
//      if Param1=False then
       begin
        EAN13:=Copy(Qr.FieldByName('EAN13').AsString,1,12);
        if Length(EAN13)=12 then
         begin
          Tb1.MergeCells(i*2-1,y-1,i*2-1,y);
          Tb1.Cell[i*2-1,y-1].Font.Name:='EanBwrP36Tt';
          Tb1.Cell[i*2-1,y-1].Font.Size:=8;
          Tb1.Cell[i*2-1,y-1].Font.CharSet:=ANSI_CHARSET;
//        if Param1 then Tb1.Cell[i*2-1,y].AddInterv(2);
          Tb1.Cell[i*2-1,y-1].AddText(GenEAN13(EAN13));
         end;
       end;
      Qr.Next;
     end;
    if Qr.Eof then Break;
   end;
  *) 
 end;

// Печать таблицы по запросу
procedure TPrintRep.PrintTable(Nds:Boolean; It:Integer; Kol:Integer; SumOnly:Boolean=False );
var CA,RC,i,j,NumS:Integer;
    aSs:TStrArray;
    Arr:Array of TQrTableInfo;
    Tb:TTableObj;
    SumNDS,Sum:Real;
    SumKol:Integer;

 function ReplZer(S:String):String;
 var i:Integer;
  begin
   Result:='';
   for i:=1 to Length(S) do
    if S[i]='0' then Result:=Result+' ' else Result:=Result+S[i];
  end;

 procedure AddTbRow(C:Integer);
 var Al,j:Integer;
     Wd,Tx:String;
  begin
   Wd:='';
   Al:=AL_LEFT;
   for j:=Low(Arr) to High(Arr) do
    begin
     if C=0 then
      begin
       Tx:=ReplZer(Arr[j].Nm);
       Al:=AL_CENTER;
       Wd:=Wd+IntToStr(Arr[j].Width);
       Tb.Cell[j+1,C+1].Font.Style:=[fsBold];
       if j<High(Arr) then Wd:=Wd+',';
      end else begin
                Case Arr[j].Tp of
                 'S':begin
                      if Qr.Fields[Arr[j].NumF].AsString='NumS' then
                       begin
                        Al:=AL_RIGHT;
                        Tx:=IntToStr(NumS);
                       end else begin
                                 Al:=AL_LEFT;
                                 Tx:=Qr.Fields[Arr[j].NumF].AsString;
                                end;
                     end;
                 'C':begin
                      Al:=AL_CENTER;
                      if Qr.Fields[Arr[j].NumF].AsString='NumS' then Tx:=IntToStr(NumS)
                                                      else Tx:=Qr.Fields[Arr[j].NumF].AsString;
                     end;
                 'R':begin
                      Al:=AL_RIGHT;
                      if Qr.Fields[Arr[j].NumF].AsString='NumS' then Tx:=IntToStr(NumS)
                                                      else Tx:=Qr.Fields[Arr[j].NumF].AsString;
                     end;
                 'I':begin
                      Al:=AL_CENTER;
                      try
                       if Qr.Fields[Arr[j].NumF].AsString='' then Tx:='' else Tx:=IntToStr(Qr.Fields[Arr[j].NumF].AsInteger);
                      except
                       Tx:='';
                      end;
                     end;
                 'N':begin
                      Al:=AL_RIGHT;
                      try
                       if Qr.Fields[Arr[j].NumF].AsString='' then Tx:=''
                                                   else Tx:=CurrToStrF(Qr.Fields[Arr[j].NumF].AsCurrency,ffFixed,2);
                      except
                       Tx:='';
                      end;
                     end;
                end;
               end;
     Tb.Cell[j+1,C+1].Align:=Al;
     Tb.Cell[j+1,C+1].AddText(Tx);
    end;
   if It<>0 then Sum:=Sum+Qr.Fields[Abs(It)-1].AsCurrency;
// if Kol>0 then SumKol:=SumKol+Qr.Fields[Kol-1].AsInteger;
   Tb.SetWidths(Wd);
  end;

 Begin
  NumS:=0;
  if Qr=nil then Exit;
  SetLength(Arr,Qr.Fields.Count);
  CA:=0;
  for i:=0 to Qr.Fields.Count-1 do
   begin
    if Pos('_',Qr.Fields[i].FieldName)=0 then Continue;
    GetStrArray(Qr.Fields[i].FieldName,aSs,['_']);
    Arr[CA].Nm:=aSs[0];
    Arr[CA].Tp:=aSs[1][1];
    Arr[CA].NumF:=i;
    Arr[CA].Width:=StrToInt(aSs[2]);
    Inc(CA);
   end;
  RC:=Qr.RecordCount;
  if It<0 then PrintRep.AddTable(High(Arr)+1,RC+2)
          else PrintRep.AddTable(High(Arr)+1,RC+1);

  Tb:=PrintRep.LastTable;
  Tb.FixRows(1,1);
  AddTbRow(0);
  Sum:=0;
  SumKol:=0;
  for i:=1 to RC do
   begin
    if i=1 then Qr.First else Qr.Next;
    Inc(NumS);
    AddTbRow(i);
   end;
  if (Sum>0) then
   begin
    if It<0 then
     begin
      LastTable.Cell[1,RC+2].Addtext('Всього:');
      LastTable.Cell[Abs(It),RC+2].Align:=AL_RIGHT;
      LastTable.Cell[Abs(It),RC+2].Addtext(CurrToStrF(Sum,ffFixed,2));
     end else
   if It>0 then
    begin
     AddTable(2,3);
     LastTable.SetWidths('14800,3400');
     for j:=1 to 3 do
      for i:=1 to 2 do
       begin
        LastTable.Cell[i,j].Align:=AL_RIGHT;
        if i=1 then PrintRep.LastTable.Cell[i,j].Font.Size:=4
               else PrintRep.LastTable.Cell[i,j].Font.Size:=5;
        LastTable.Cell[i,j].Font.Style:=[fsBold];
        LastTable.Cell[i,j].RightBorder:=EMPTY_BORDER;
        LastTable.Cell[i,j].TopBorder:=EMPTY_BORDER;
        LastTable.Cell[i,j].LeftBorder:=EMPTY_BORDER;
        if j=3 then PrintRep.LastTable.Cell[i,j].BottomBorder:=Border(clBlack,5,psSolid)
               else PrintRep.LastTable.Cell[i,j].BottomBorder:=EMPTY_BORDER;
       end;
     LastTable.Cell[1,1].AddText('Сумма без учета НДС');
     LastTable.Cell[1,2].AddText('Сумма НДС');
     LastTable.Cell[1,3].AddText('Сумма с учетом НДС');
     if NDS then SumNDS:=Sum*5/6
            else SumNDS:=Sum*100/107;

     LastTable.Cell[2,1].AddText(CurrToStrF(SumNDS,ffFixed,2));
     LastTable.Cell[2,2].AddText(CurrToStrF(Sum-SumNDS,ffFixed,2));
     LastTable.Cell[2,3].AddText(CurrToStrF(Sum,ffFixed,2));
    end;
    AddInterv(1);
    if SumOnly then Exit;
    AddText('Всего отпущено наименований: '+IntToWordsRU(RC,0)+'.'+#10);
//    AddText('Всего единиц товара: '+IntToWordsRU(SumKol,0)+'.'+#10);
    AddInterv(1);
    if NDS then
     begin
      AddText('На сумму '+CurrToWordsRU(Sum*5/6,0)+' без НДС'+#10);
      AddInterv(1);
     end else begin
               AddText('На сумму '+CurrToWordsRU(Sum*100/107,0)+' без НДС'+#10);
               AddInterv(1);
              end;
    PrintRep.AddText('На сумму '+CurrToWordsRU(Sum,0));
//    if NDS then
     PrintRep.AddText(' с учетом НДС'+#10);
//           else PrintRep.AddText(#10+'                         НДС не предусмотрен'+#10);
   end;

 End; {PrintTable}

procedure TPrintRep.SaveToFile(FName:String);
var i:Integer;
    Bm:TBitMap;
    J:TJpegImage;
 begin
  BuildQueue;
  Bm:=TBitMap.Create;
  J:=TJpegImage.Create;
  try
   for i:=MinPage to MaxPage do
    begin
     Bm.Width:=PageWidth;
     Bm.Height:=PageHeight;
     Bm.Canvas.Pen.Color:=clWhite;
     Bm.Canvas.Brush.Color:=clWhite;
     Bm.Canvas.FillRect(Rect(0,0,Bm.Width,Bm.Height));
     PrintPage(Bm.Canvas,Bm.Width,Bm.Height,i);
     J.Assign(Bm);
     J.Compress;
     J.SaveToFile(MyFileName(FName)+IntToStr(i)+'.jpg');
    end;
  finally
   J.Free;
   Bm.Free;
  end;
 end;

procedure TPrintRep.SetDefault;
 begin
  inherited;
  Orientation:=O_PORTR;
  FPageSetupChange:=True;
 end;

procedure TPrintRep.SetPrinterName(const Value: String);
 begin
  FPrinterName:=Value;
 end;

function TPrintRep.GetPrinterName:String;
 begin
  Result:=Printer.Printers[Printer.PrinterIndex];
 end;

{ TTextObj }

constructor TTextObj.Create;
 begin
  inherited Create;
  FData:='';
  SetLength(FNumPr,0);
  SetLength(FChAdj,0);
  SetLength(FPrAdj,0);
 end;

destructor TTextObj.Destroy;
 begin
  FData:='';
  SetLength(FNumPr,0);
  SetLength(FChAdj,0);
  SetLength(FPrAdj,0);
  inherited;
 end;

procedure TTextObj.Build;
var CA,xP,yP,nP,i,StrY:Integer;
    Pr:TParagr;
    CurrStr:Array of Integer;
    Bm:TBitMap;

 function GetChWidth(N:Integer):Integer;
  begin
   if Ord(Data[N])<32 then begin Result:=0; Exit; end;
   Bm.Canvas.Font.Height:=-Abs(FChAdj[N-1].Height);
   Bm.Canvas.Font.Name:=Screen.Fonts[FChAdj[N-1].Name];
   Bm.Canvas.Font.Style:=FChAdj[N-1].Style;
   Result:=Bm.Canvas.TextWidth(Data[N]);
  end;

 function GetChHeight(N:Integer):Integer;
  begin
   Bm.Canvas.Font.Height:=-Abs(FChAdj[N-1].Height);
   Bm.Canvas.Font.Name:=Screen.Fonts[FChAdj[N-1].Name];
   Bm.Canvas.Font.Style:=FChAdj[N-1].Style;
   Result:=Bm.Canvas.TextHeight('A');
  end;

 procedure AlignString;
 var i,Ind,SpaceW,q,WdPrint,dx:Integer;
  begin
   if High(CurrStr)=-1 then Exit;
   SpaceW:=0; Ind:=0; q:=0;
   for i:=Low(CurrStr) to High(CurrStr) do
    begin
     FChAdj[CurrStr[i]-1].Y:=Round(FChAdj[CurrStr[i]-1].Y+(StrY-Abs(FChAdj[CurrStr[i]-1].Height))*(42/47));
     if (Data[CurrStr[i]] in [#32]) and (i<High(CurrStr)) then Inc(q);
    end;
   WdPrint:=Abs(Bounds.Right-Pr.RightIndent-xP);
   Case Pr.Align of
    AL_CENTER:Ind:=WdPrint div 2;
    AL_RIGHT:Ind:=WdPrint;
    AL_JUST:if q>0 then SpaceW:=WdPrint div q;
   end;
   if Data[CurrStr[High(CurrStr)]] in [#10] then SpaceW:=0;
   if Pr.Align<>AL_LEFT then
    begin
     dx:=Ind+FChAdj[CurrStr[0]-1].X;
     for i:=Low(CurrStr) to High(CurrStr) do
      begin
       FChAdj[CurrStr[i]-1].X:=dx;
       Inc(dx,GetChWidth(CurrStr[i]));
       if (Data[CurrStr[i]] in [#32]) and (i<High(CurrStr)) then Inc(dx,SpaceW);
      end;
    end;
  end;

 procedure NextString;
 var i:Integer;
  begin
   if yP+StrY>Bounds.Bottom then
    begin
     yP:=Bounds.Top;
     Inc(Np);
     for i:=Low(CurrStr) to High(CurrStr) do
      begin
       FChAdj[CurrStr[i]-1].NumPage:=NP;
       FChAdj[CurrStr[i]-1].Y:=yP;
      end;
    end;
   AlignString;
   SetLength(CurrStr,0);
   xP:=Bounds.Left+Pr.LeftIndent;
   yP:=yP+StrY;
   StrY:=0;
  end;

 procedure NextParagr;
  begin
   if i<Length(Data) then Pr:=FPrAdj[FNumPr[i]];
   xP:=Bounds.Left+Pr.Indent;
  end;

 procedure NextPage;
  begin
   NextParagr;
   Inc(Np);
   yP:=Bounds.Top;
  end;

 procedure NextPages(Pd:Integer);
 var i,dy:Integer;
  begin
   dy:=NumPage-(NumPage div Pd)*Pd;
   if ((NumPage div Pd)*Pd)=NumPage then NextPage else
   for i:=1 to Pd-dy+1 do NextPage;
  end;

 function IsNeedSplit(ii:Integer):Boolean;
 var i,dx:Integer;
  begin
   dx:=0;
   for i:=ii+1 to Length(Data) do
    if (Not (Data[i] in [#32,#10,#13,#12])) then
     begin
      Inc(dx,GetChWidth(i));
      if xP+dx>(Bounds.Right-Pr.RightIndent) then begin Result:=True; Exit; end;
     end else break;
   if xP+dx>(Bounds.Right-Pr.RightIndent) then Result:=True else Result:=False;
  end;

 Begin
  inherited;
  if Data='' then Exit;
  Bm:=TBitMap.Create;
  try
   Bm.Canvas.Font.PixelsPerInch:=PixPerI;
   SetLength(CurrStr,0);
   Pr:=FPrAdj[0];
   xP:=X+Pr.Indent+Bounds.Left; yP:=Y;
   nP:=NumPage; FHeight:=0; StrY:=0;
   for i:=1 to Length(Data) do
    begin
     CA:=High(CurrStr)+1; SetLength(CurrStr,CA+1); CurrStr[CA]:=i;
     FChAdj[i-1].X:=xP;
     FChAdj[i-1].Y:=yP;
     FChAdj[i-1].NumPage:=NP;
     Inc(xP,GetChWidth(i));
     if GetChHeight(i)>StrY then StrY:=GetChHeight(i);

     if Data[i] in [#12,#10] then NextString;
     if Data[i] in [#12] then NextPage else
//     if Data[i] in [#144] then NextPages(4) else
     if Data[i] in [#10] then NextParagr else
     if ((Data[i] in [#32]) and (IsNeedSplit(i))) or
        (xP+GetChWidth(i)>=Bounds.Right-Pr.RightIndent) then NextString;
    end;
   AlignString;
   FLastY:=yP+StrY;
   FLastPage:=NP;
  finally
   Bm.Free;
  end;
 End;

procedure TTextObj.Draw;
var i:Integer;
    Ch:TChar;
    LogFont:TLogFont;
 begin
  inherited;
  for i:=1 to Length(Data) do
   if FChAdj[i-1].NumPage=NumPage then
    begin
     Ch:=FChAdj[i-1];
     Canvas.Font.Name:=Screen.Fonts[Ch.Name];
     Canvas.Font.Style:=Ch.Style;
     Canvas.Font.Height:=-Abs(Round(Ch.Height*KoefY));
     Canvas.Font.Color:=Ch.Color;
     if Canvas.Font.Name='EanBwrP36Tt' then
      Canvas.Font.Charset:=ANSI_CHARSET
     else
      Canvas.Font.Charset:=RUSSIAN_CHARSET;
     if Ch.BColor=-1 then Canvas.Brush.Style:=bsClear else
      begin
       Canvas.Brush.Style:=bsSolid;
       Canvas.Brush.Color:=Ch.BColor;
      end;

{
     if Parent.FTextAng<>0 then
      begin
       GetObject(Canvas.Font.Handle,SizeOf(TLogFont),@LogFont);
       LogFont.lfEscapement:=Parent.FTextAng*10;
       Canvas.Font.Handle:=CreateFontIndirect(LogFont);
      end;
}
     if Ord(Data[i])>=32 then Canvas.TextOut(Round(Ch.X*KoefX),Round((Ch.Y-DY)*KoefY),Data[i]);

//     if Ord(Data[i])>=32 then Canvas.TextOut(Round((Ch.Y-DY)*KoefY),Round(Ch.X*KoefX),Data[i]);
    end;
 end;

procedure TCustomRep.SetDefault;
 begin
  FPageDev:=1;
  FFont.PixelsPerInch:=PixPerI;
  FFont.Size:=6;
  FFont.Name:='Times New Roman';
  FFont.Style:=[];
  FFont.Color:=clBlack;
  FFont.CharSet:=RUSSIAN_CHARSET;
  FBColor:=-1;
  FIndent:=10;
  FAlign:=AL_LEFT;
  FLeftIndent:=0;
  FRightIndent:=0;
  FStretch:=False;
  FAspectRatio:=1;
  FPrintScale:=1;
  FLeftBorder:=DEFAULT_BORDER;
  FRightBorder:=DEFAULT_BORDER;
  FTopBorder:=DEFAULT_BORDER;
  FBottomBorder:=DEFAULT_BORDER;
  FNumPage:=1;
  FFirstPage:=1;
  FLastPage:=1;
  FCellY:=0;
  FLastY:=0;
  FUpY:=0;
 end;

constructor TCustomRep.Create;
 begin
  FFont:=TFont.Create;
  SetDefault;
 end;

destructor TCustomRep.Destroy;
 begin
  FFont.Free;
  inherited;
 end;

function TCustomRep.GetLastItem:TPrintObj;
 begin
  if High(FBlocks)>-1 then Result:=FBlocks[High(FBlocks)] else Result:=nil;
 end;

procedure TTextObj.SetData(const Value:String);
 begin
  FData:=Value;
  SetLength(FNumPr,Length(FData));
 end;

function TTextObj.GetNumPages:MyInteger;
var i:Integer;
    Max:Integer;
 begin
  Max:=0;
  for i:=Low(FChAdj) to High(FChAdj) do
   if FChAdj[i].NumPage>Max then Max:=FChAdj[i].NumPage;
  Result:=Max;
 end;

{ TPrintObj }

procedure TPrintObj.Build;
 begin
  if (Y-FUpY)<FBounds.Top then Y:=FBounds.Top else Y:=Y-FUpY;
 end;

constructor TPrintObj.Create;
 begin
  FHeight:=0;
  FParent:=nil;
  FDy:=0;
 end;

function TPrintObj.GetLastPage:MyInteger;
 begin
  Result:=FLastPage;
 end;

function TPrintObj.GetLastY:MyInteger;
 begin
  Result:=FLastY;
 end;

{ TImageObj }

constructor TImageObj.Create;
 begin
  inherited;
  FBm:=TBitMap.Create;
  FFileName:='';
 end;

destructor TImageObj.Destroy;
 begin
  FBm.Free;
  inherited;
 end;

procedure TImageObj.Build;
var PrW,PrH:Integer;

 function K2_6(V:Real):Integer;
  begin
   Result:=Round(V*2.6);
  end;

 Begin
  inherited;
  PrW:=Abs(Bounds.Right-Bounds.Left-FParagr.LeftIndent-FParagr.RightIndent);
  PrH:=Abs(Bounds.Bottom-Bounds.Top-Y);

  if FStretch then
   begin
    if FStWidth=0 then FStWidth:=K2_6(FBm.Width);
    FWidth:=FStWidth;
    FHeight:=Round((FBm.Height/FBm.Width)*FStWidth*FAspectRatio);
   end else begin
             FWidth:=K2_6(FBm.Width);
             FHeight:=K2_6(FBm.Height);
            end;

//  if (FHeight>PrH) and (FHeight<Bounds.Bottom-Bounds.Top) then
  if (FHeight>PrH) and (Y>Bounds.Top) then
   begin
    NumPage:=NumPage+1;
    Y:=Bounds.Top;
    PrH:=Abs(Bounds.Bottom-Bounds.Top-Y);
   end;

  if (FWidth>PrW) and (FHeight>PrH) then
   begin
    if (FWidth-PrW)>(FHeight-PrH) then
     begin
      FHeight:=Round(FHeight/(FWidth/PrW));
      FWidth:=PrW;
     end else begin
               FWidth:=Round(FWidth/(FHeight/PrH));
               FHeight:=PrH;
              end;
   end else
  if FWidth>PrW then
   begin
    FHeight:=Round(FHeight/(FWidth/PrW));
    FWidth:=PrW;
   end else
  if FHeight>PrH then
   begin
    FWidth:=Round(FWidth/(FHeight/PrH));
    FHeight:=PrH;
   end;
  FCh.X:=Bounds.Left+FParagr.LeftIndent;
  Case FParagr.Align of
   AL_CENTER:FCh.X:=Bounds.Left+FParagr.LeftIndent+Abs(PrW-FWidth) div 2;
   AL_RIGHT:FCh.X:=Bounds.Left+FParagr.LeftIndent+Abs(PrW-FWidth);
  end;
  FCh.Y:=Y;
  FCh.NumPage:=NumPage;
  FLastY:=Y+FHeight;
  FLastPage:=NumPage;
 End;

procedure TImageObj.Draw;
var Bm:TBitMap;
 begin
  inherited;
  if FCh.NumPage=NumPage then
   begin
    if FStretch then
     Canvas.StretchDraw(Rect(Round(FCh.X*KoefX),Round((FCh.Y-DY)*KoefY),Round((FCh.X+FWidth)*KoefX),Round(((FCh.Y-DY)+FHeight)*KoefY)),FBm)
    else begin
          Bm:=TBitMap.Create;
          try
           Bm.Width:=Round(FWidth/2.6);
           Bm.Height:=Round(FHeight/2.6);
           Bm.Canvas.CopyRect(Rect(0,0,FWidth,FHeight),
                              FBm.Canvas,
                              Rect(0,0,FWidth,FHeight)
                             );
           Canvas.StretchDraw(Rect(Round((FCh.X)*KoefX),Round((FCh.Y-DY)*KoefY),Round((FCh.X+FWidth)*KoefX),Round((FCh.Y-DY+FHeight)*KoefY)),Bm);
          finally
           Bm.Free;
          end;
         end;
   end;
 end;

function TImageObj.GetNumPages:MyInteger;
 begin
  Result:=FCh.NumPage;
 end;

procedure TCustomRep.AddIm(W:MyInteger);
var CA:Integer;
    Img:TImageObj;
    Ch:TChar;
    Pr:TParagr;
 begin
  CA:=High(FBlocks)+1; SetLength(FBlocks,CA+1);
  FBlocks[CA]:=TImageObj.Create;
  Img:=TImageObj(LastItem);
  Img.FStretch:=Stretch;
  Ch.X:=-1;
  Ch.Y:=-1;
  Ch.NumPage:=0;
  Img.FCh:=Ch;
  Img.UpY:=UpY; UpY:=0;
  Pr.Align:=Align;
  Pr.Indent:=MMToPix(Indent);
  Pr.LeftIndent:=MMToPix(LeftIndent);
  Pr.RightIndent:=MMToPix(RightIndent);
  Img.FParent:=Self;
  Img.FParagr:=Pr;
  Img.FStWidth:=MMToPix(W);
  Img.FAspectRatio:=AspectRatio;
 end;

procedure TCustomRep.AddTextAng(S:String; Ang:Real);
var TxA:TImageObj;
    B:TBitMap;
    dx,dy,x,y,x1,y1,xr1,yr1,xr2,yr2,xr3,yr3,xB0,yB0,xb1,yB1:MyInteger;

 function GetMin4(x,y,z,k:Integer):Integer;
  begin
   Result:=x;
   if y<Result then Result:=y;
   if z<Result then Result:=z;
   if k<Result then Result:=k;
  end;

 function GetMax4(x,y,z,k:Integer):Integer;
  begin
   Result:=x;
   if y>Result then Result:=y;
   if z>Result then Result:=z;
   if k>Result then Result:=k;
  end;

 Begin
  AddIm(0);
  TxA:=TImageObj(LastItem);
  TxA.FStretch:=True;
  TxA.FAspectRatio:=1;
  B:=TBitMap.Create;
  try
   B.Canvas.Font.PixelsPerInch:=FFont.PixelsPerInch;
   B.Canvas.Font.Name:=FFont.Name;
   B.Canvas.Font.Size:=FFont.Size;
   B.Canvas.Font.Style:=FFont.Style;
   B.Canvas.Font.Color:=FFont.Color;
   B.Canvas.Font.CharSet:=FFont.CharSet;
   x:=0; y:=0;
   x1:=x+B.Canvas.TextWidth(S);
   y1:=y+B.Canvas.TextHeight('A');
   RotateXY(x,y,x1,y,xr1,yr1,Ang);
   RotateXY(x,y,x1,y1,xr2,yr2,Ang);
   RotateXY(x,y,x,y1,xr3,yr3,Ang);
   xb0:=GetMin4(x,xr1,xr2,xr3); xb1:=GetMax4(x,xr1,xr2,xr3);
   yb0:=GetMin4(y,yr1,yr2,yr3); yb1:=GetMax4(y,yr1,yr2,yr3);
   dx:=0; if xb0<0 then dx:=Abs(xb0);
   dy:=0; if yb0<0 then dy:=Abs(yb0);
   Inc(xb0,dx); Inc(x,dx); Inc(xb1,dx);
   Inc(yb0,dy); Inc(y,dy); Inc(yb1,dy);
   B.Width:=Abs(xb0-xb1);
   B.Height:=Abs(yb0-yb1);
   CanvasSetTextAngle(B.Canvas,Ang);
   B.Canvas.TextOut(x,y,S);
   CanvasSetTextAngle(B.Canvas,0);
   TxA.FStWidth:=Abs(xb0-xb1);
   TxA.Bm.Width:=Abs(xb0-xb1);
   TxA.Bm.Height:=Abs(yb0-yb1);
   TxA.Bm.Canvas.CopyRect(Rect(0,0,TxA.Bm.Width,TxA.Bm.Height),B.Canvas,Rect(xb0,yb0,xb1,yb1));
  finally
   B.Free;
  end;
 End;

procedure TCustomRep.AddImage(Im:TBitMap);
 begin
  AddImage(Im,0);
 end;

procedure TCustomRep.AddImage(Im:String);
 begin
  AddImage(Im,0);
 end;

procedure TCustomRep.AddImage(Im: TBitMap; W:MyInteger);
var Img:TImageObj;
 begin
  AddIm(W);
  Img:=TImageObj(LastItem);
  Img.Bm.Assign(Im);
 end;

procedure TCustomRep.AddImage(Im: String; W:MyInteger);
var Img:TImageObj;
 begin
  AddIm(W);
  Img:=TImageObj(LastItem);
  Img.Bm.LoadFromFile(Im);
  Img.FFileName:=Im;
 end;

{ TTableObj }

procedure TTableObj.Clear;
var i:Integer;
 begin
  for i:=Low(FCells) to High(FCells) do FCells[i].Free;
  SetLength(FCells,0);
  FCols:=0; FRows:=0;
 end;

procedure TTableObj.CorrCol(var Col:MyInteger);
 begin
  if Col>FCols then Col:=FCols else if Col<1 then Col:=1;
 end;

procedure TTableObj.CorrRow(var Row:MyInteger);
 begin
  if Row>FRows then Row:=FRows else if Row<1 then Row:=1;
 end;

constructor TTableObj.Create;
 begin
  inherited;
  SetLength(FCells,0);
  FCols:=0;
  FRows:=0;
  FFrow1:=0;
  FFrow2:=-1;
  FFixStPage:=0;
  FFixDY:=0;
 end;

destructor TTableObj.Destroy;
 begin
  Clear;
  inherited;
 end;

procedure TTableObj.Build;
var HCell,dy,FreeDY,Bt,FixY,MaxNp,Q,TW,WS,i,j,k,pX,MaxLY,MaxB:Integer;
    B:Boolean;
    kX:Real;

 begin
  inherited;
  FixY:=0; MaxLY:=Y; MaxNp:=NumPage; TW:=0; Q:=0;

  for i:=1 to FCols do
   begin
    Inc(TW,FactCell[i,1].FInitCellWidth);
    if FactCell[i,1].FInitCellWidth=0 then Inc(Q);
   end;

  kX:=1; if TW>Abs(Bounds.Left-Bounds.Right) then kX:=(Abs(Bounds.Left-Bounds.Right)/TW)*((100-Q)*0.01);
  Bt:=Bounds.Top;
  try
   for j:=1 to FRows do
    begin
     TW:=0; Q:=0; pX:=Bounds.Left; MaxB:=0;
     // Разрывает ячейку. Если перед циклом, то не разрывает ячейку
     if (MaxLY+FactCell[1,j].ObjHeight)>Bounds.Bottom then begin Inc(MaxNP); MaxLY:=Bounds.Top; end;

     // Расчет сквозных строк
     if j=FFrow1 then begin FFixStPage:=MaxNP+1; FFixDY:=MaxLY-Bounds.Top; end;

     for i:=1 to FCols do
      begin
       FactCell[i,j].FCellWidth:=Round(kX*FactCell[i,j].FInitCellWidth);
       TW:=TW+FactCell[i,j].FCellWidth;
       if FactCell[i,1].FCellWidth=0 then Inc(Q);
       FactCell[i,j].FFirstPage:=MaxNP;
       FactCell[i,j].FCellY:=MaxLY;
       FactCell[i,j].FLastY:=0;
       FactCell[i,j].FLastPage:=0;
       if FactCell[i,j].FBottomMargin>MaxB then MaxB:=FactCell[i,j].FBottomMargin;
       FactCell[i,j].FCellHeight:=FactCell[i,j].FInitCellHeight;
       FactCell[i,j].ObjHeight:=0;
      end;

     WS:=Round(Abs(Abs(Bounds.Left-Bounds.Right)-TW)/Q);
     MaxLY:=MaxLY+FactCell[1,j].ObjHeight;

     for i:=1 to FCols do
      begin
       if FactCell[i,j].FCellWidth=0 then FactCell[i,j].FCellWidth:=WS;
       FactCell[i,j].FCellX:=pX;
       Inc(pX,FactCell[i,j].FCellWidth);
      end;

     for i:=1 to FCols do
      begin
       FactCell[i,j].BuildQueue;
       FactCell[i,j].ObjHeight:=FactCell[i,j].GetHeight(FactCell[i,j].FFirstPage,
                                                        FactCell[i,j].FLastPage,
                                                        FactCell[i,j].FCellY,
                                                        FactCell[i,j].FLastY);
       if FactCell[i,j].FCellHeight>FactCell[i,j].FObjHeight then FactCell[i,j].SetHeight(FactCell[i,j].FCellHeight);
       if FactCell[i,j].FLastPage>MaxNP then begin MaxLY:=Bounds.Top; MaxNP:=FactCell[i,j].FLastPage; end;
      end;

     // TODO: Дописать правильный расчет строк
     for i:=1 to FCols do
      begin
       if FactCell[i,j].FFirstPage<MaxNP then
        begin
         FactCell[i,j].FFirstPage:=MaxNP;
         FactCell[i,j].FCellY:=Bounds.Top;
         FactCell[i,j].BuildQueue;
        end;
      end;

     // Расчет Y-ка нижней границы ячейки на максимальной странице
     for i:=1 to FCols do
      if FactCell[i,j].FLastPage=MaxNP then
       if FactCell[i,j].FLastY>MaxLY then MaxLY:=FactCell[i,j].FLastY;

     FreeDY:=0; B:=True;
     for i:=1 to FCols do
      if FactCell[i,j].FLastPage=MaxNP then
       if Cell[i,j].FCoords.Top=FactCell[i,j].FCoords.Top then
        begin
         HCell:=FactCell[i,j].FLastY-FactCell[i,j].FCellY;
         if HCell<=0 then HCell:=FactCell[i,j].FObjHeight;
         for k:=FactCell[i,j].FCoords.Top+1 to FactCell[i,j].FCoords.Bottom do Inc(HCell,FactCell[i,k].FCellHeight);
         dy:=Abs((MaxLY-FactCell[i,j].FCellY)-HCell);
         if (dy<FreeDY) or (B=True) then
          begin
           FreeDY:=dy;
           B:=False;
          end;
        end;

     if (FreeDY<0) or (Abs(Bounds.Top-MaxLY)<FactCell[1,j].FObjHeight) then FreeDY:=0;

     // Присвоение нижних границ ячеек
     Inc(MaxLY,MaxB); Dec(MaxLY,FreeDY);
     for i:=1 to FCols do
      begin
       FactCell[i,j].FLastPage:=MaxNP;
       FactCell[i,j].FLastY:=MaxLY;
      end;

     // Сквозные строки
     if (j>=FFRow1) and (j<=FFRow2) then Inc(FixY,RowHeights[j]);
     if j=FFRow2 then FBounds.Top:=FBounds.Top+MMToPix(FixY);
    end;
  finally
   FBounds.Top:=Bt;
  end;
  FLastY:=MaxLY;
  FLastPage:=MaxNP;
 end;

procedure TTableObj.Draw;
var j:Integer;

 procedure SetCanvas(Br:TBorder);
  begin
   Canvas.Pen.Color:=Br.Color;
   Canvas.Pen.Width:=Round(Br.Width*KoefX);
   Canvas.Pen.Style:=Br.Style;
  end;

 procedure DrawRow(R:Integer; lDy:Integer; Param:Integer);
 var i,k,x1,x2,y1,y2,xx1,xx2:Integer;
     Cl,Cl1:TCell;
  begin
   for i:=1 to FCols do
    begin
     Cl:=FactCell[i,R];
     Cl1:=Cell[i,R];
     Case Param of
      0:if Not((NumPage>=Cl.FFirstPage) and (NumPage<=Cl.FLastPage)) then Continue;
      1:if (NumPage<FFixStPage) or (NumPage>FLastPage) then Continue;
     end;

     if Cl.BColor=-1 then Canvas.Brush.Style:=bsClear else
      begin
       Canvas.Brush.Style:=bsSolid;
       Canvas.Brush.Color:=Cl.BColor;
      end;

      x1:=Round(Cl.CellX*KoefX);
      xx1:=Round(Cl1.CellX*KoefX);
      if (NumPage=Cl.FFirstPage) or (Param=1) then y1:=Round((Cl.CellY-lDy-Dy)*KoefY)
                                              else y1:=Round((Bounds.Top-lDy-Dy)*KoefY);

      x2:=Round((Cl.CellX+Cl.FCellWidth)*KoefX);
      xx2:=Round((Cl1.CellX+Cl1.CellWidth)*KoefX);

      if (Cl.FLastPage=NumPage) or (Param=1) then y2:=Round((Cl.FLastY-lDy-Dy)*KoefY)
                                             else y2:=Round((Bounds.Bottom-lDy-Dy)*KoefY);

      if (Cl.FCoords.Left=Cl1.FCoords.Left) and (Cl.FCoords.Right=Cl1.FCoords.Right) then Canvas.FillRect(Rect(xx1,y1,xx2,y2));

      SetCanvas(Cl.LeftBorder);
      if Cl.LeftBorder.Style<>psClear then
       begin
        Canvas.MoveTo(x1,y1); Canvas.LineTo(x1,y2);
       end;

      SetCanvas(Cl.TopBorder);
      if Cl.TopBorder.Style<>psClear then
       begin
        Canvas.MoveTo(x1,y1); Canvas.LineTo(x2,y1);
       end;

      SetCanvas(Cl.RightBorder);
      if Cl.RightBorder.Style<>psClear then
       begin
        Canvas.MoveTo(x2,y1); Canvas.LineTo(x2,y2);
       end;

      SetCanvas(Cl.BottomBorder);
      if Cl.BottomBorder.Style<>psClear then
       begin
        Canvas.MoveTo(x1,y2); Canvas.LineTo(x2,y2);
       end;


      if (Cl.FCoords.Left=Cl1.FCoords.Left) and (Cl.FCoords.Right=Cl1.FCoords.Right) then
       for k:=Low(Cl.FBlocks) to High(Cl.FBlocks) do
        begin
         Case Param of
          0:Cl.FBlocks[k].NumPage:=NumPage;
          1:Cl.FBlocks[k].NumPage:=FFixStPage-1;
         end;
         Cl.FBlocks[k].Canvas:=Canvas;
         Cl.FBlocks[k].DY:=lDy+Dy;
         Cl.FBlocks[k].KoefX:=KoefX;
         Cl.FBlocks[k].KoefY:=KoefY;
         Cl.FBlocks[k].Draw;
        end;

{     if (Cl.FCoords.Left=Cl1.FCoords.Left) and (Cl.FCoords.Right=Cl1.FCoords.Right) then
      if Assigned(FOnDrawCell) then FOnDrawCell(Canvas,Rect(xx1,y1,xx2,y2),-Abs(Round(CL.Font.Height*KoefY)));
}
    end;
  end;

 Begin
  inherited;
  for j:=1 to FRows do DrawRow(j,0,0);
  for j:=FFrow1 to FFRow2 do
   DrawRow(j,FFixDY,1);
 End;

procedure TCustomRep.AddTable(Cols,Rows:MyInteger);
var CA:Integer;
    Tb:TTableObj;
    i,dx:Integer;
 begin
  CA:=High(FBlocks)+1;
  SetLength(FBlocks,CA+1);
  FBlocks[CA]:=TTableObj.Create;
  Tb:=TTableObj(FBlocks[CA]);
  Tb.FCols:=Cols; Tb.FRows:=0;
  Tb.UpY:=UpY; UpY:=0;
  AddRows(Rows);
  dX:=2100 div Cols;
  for i:=1 to Cols do Tb.ColWidths[i]:=dx;
 end;

function TCustomRep.GetLastTable:TTableObj;
var i:Integer;
 begin
  Result:=nil;
  for i:=High(FBlocks) downto Low(FBlocks) do
   if FBlocks[i].ClassName='TTableObj' then begin Result:=TTableObj(FBlocks[i]); Break; end;
 end;

procedure TCustomRep.AddRows(Rows:MyInteger);
var Tb:TTableObj;
    LR,CA,CC,i,j:MyInteger;
 begin
  if (LastItem=nil) or (LastItem.ClassName<>'TTableObj') then
   begin
    CA:=High(FBlocks)+1;
    SetLength(FBlocks,CA+1);
    FBlocks[CA]:=TTableObj.Create;
    TTableObj(FBlocks[CA]).FRows:=0;
    TTableObj(FBlocks[CA]).FCols:=1;
   end;

  Tb:=LastTable;
  LR:=Tb.LastRow;
  CC:=High(Tb.FCells)+1;
  SetLength(Tb.FCells,CC+Tb.FCols*Rows);
  for j:=1 to Rows do
   for i:=1 to Tb.FCols do
    begin
     Tb.FCells[CC]:=TCell.Create;
     Tb.FCells[CC].FCoords:=Rect(i,j+LR,i,j+LR);
     Tb.FCells[CC].ObjHeight:=0;
     Tb.FCells[CC].FParent:=Tb;
     Tb.FCells[CC].Font.Assign(Font);
     Tb.FCells[CC].FBColor:=FBColor;
     Tb.FCells[CC].FStretch:=FStretch;
     Tb.FCells[CC].FAspectRatio:=FAspectRatio;
     Tb.FCells[CC].FAlign:=FAlign;
     Tb.FCells[CC].FRightIndent:=FRightIndent;
     Tb.FCells[CC].FLeftIndent:=FLeftIndent;
     Tb.FParent:=Self;
     Inc(CC);
    end;
  Tb.FRows:=Tb.FRows+Rows;
  for i:=1 to Tb.FCols do Tb.ColWidths[i]:=Tb.Cell[i,1].CellWidth;
 end;

function TTableObj.GetCell(Col,Row:MyInteger):TCell;
var C,R:Integer;
 begin
  CorrCol(Col); CorrRow(Row);
  C:=FactCell[Col,Row].FMLeft;
  R:=FactCell[Col,Row].FMTop;
  if ((C=0) and (R=0)) then Result:=FactCell[Col,Row]
                       else Result:=FactCell[C,R];
 end;

function TTableObj.GetColCount(Row:MyInteger):MyInteger;
var i,q:Integer;
 begin
  i:=1; q:=0;
  CorrRow(Row);
  While i<FCols do
   begin
    Inc(q);
    Inc(i,Abs(FactCell[i,Row].FCoords.Left-FactCell[i,Row].FCoords.Right))
   end;
  Result:=q;
 end;

function TTableObj.GetColWidths(Col:MyInteger):MyInteger;
 begin
  CorrCol(Col);
  Result:=FactCell[Col,1].CellWidth;
 end;

function TTableObj.GetFactCell(Col,Row:MyInteger):TCell;
 begin
  CorrCol(Col);
  CorrRow(Row);
  Result:=FCells[FCols*(Row-1)+Col-1];
 end;

function TTableObj.GetLastRow:MyInteger;
var i,Max:Integer;
 begin
  Max:=0;
  for i:=Low(FCells) to High(FCells) do
   if FCells[i].FCoords.Top>Max then Max:=FCells[i].FCoords.Top;
  Result:=Max;
 end;

function TTableObj.GetNumPages:MyInteger;
var i:Integer;
    Max:Integer;
 begin
  Max:=0;
  for i:=Low(FCells) to High(FCells) do
   if FCells[i].NumPages>Max then Max:=FCells[i].NumPages;
  Result:=Max;
 end;

function TTableObj.GetRowHeights(Row:MyInteger):MyInteger;
 begin
  CorrRow(Row);
  Result:=Round(PixToMM(FactCell[1,Row].CellHeight));
 end;

procedure TTableObj.MergeCells(Col1,Row1,Col2,Row2:MyInteger);
var C1,R1,C2,R2,i,j:MyInteger;

 procedure GetCoords(var C1,R1,C2,R2:MyInteger);
 var cC1,cR1,cC2,cR2,i:MyInteger;
     mC1,mR1,mC2,mR2:Integer;

  begin
   mR1:=0; mR2:=0; mC1:=0; mC2:=0;
   for i:=C1 to C2 do
    begin
     if R1-Cell[i,R1].FCoords.Top>mR1 then mR1:=R1-Cell[i,R1].FCoords.Top;
     if Cell[i,R2].FCoords.Bottom-R2>mR2 then mR2:=Cell[i,R2].FCoords.Bottom-R2;
    end;

   for i:=R1 to R2 do
    begin
     if C1-Cell[C1,i].FCoords.Left>mC1 then mC1:=C1-Cell[C1,i].FCoords.Left;
     if Cell[C2,i].FCoords.Right-C2>mC2 then mC2:=Cell[C2,i].FCoords.Right-C2;
    end;

   cC1:=C1-mC1; cC2:=C2+mC2; cR1:=R1-mR1; cR2:=R2+mR2;
   if (cC1<>C1) or (cR1<>R1) or (cC2<>C2) or (cR2<>R2) then GetCoords(cC1,cR1,cC2,cR2);
   C1:=cC1; C2:=cC2; R1:=cR1; R2:=cR2;
  end;

 Begin
  if Col1>Col2 then Col2:=Col1;
  if Row1>Row2 then Row2:=Row1;
  CorrCol(Col1); CorrCol(Col2);
  CorrRow(Row1); CorrRow(Row2);

  C1:=Cell[Col1,Row1].FCoords.Left;
  R1:=Cell[Col1,Row1].FCoords.Top;
  C2:=Cell[Col2,Row2].FCoords.Right;
  R2:=Cell[Col2,Row2].FCoords.Bottom;

  GetCoords(C1,R1,C2,R2);

  for i:=C1 to C2 do
   for j:=R1 to R2 do
    begin
     FactCell[i,j].FMLeft:=C1;
     FactCell[i,j].FMTop:=R1;
    end;

  FactCell[C1,R1].FCoords.Right:=C2;
  FactCell[C1,R1].FCoords.Bottom:=R2;

  Cell[C1,R1].LeftBorder:=Cell[C1,R1].LeftBorder;
  Cell[C1,R1].RightBorder:=Cell[C1,R1].RightBorder;
  Cell[C1,R1].TopBorder:=Cell[C1,R1].TopBorder;
  Cell[C1,R1].BottomBorder:=Cell[C1,R1].BottomBorder;
  Cell[C1,R1].BColor:=Cell[C1,R1].BColor;
  // TODO: Дописать объединение свойств ячеек на все объединяемые ячейки (если еще потребуется)

  for i:=C1 to C2 do
   for j:=R1 to R2 do
    begin
     if (i<>C1) and (j<>R1) then
      begin
       FactCell[i,j].FCoords.Right:=FactCell[i,j].FCoords.Left;
       FactCell[i,j].FCoords.Bottom:=FactCell[i,j].FCoords.Top;
       FactCell[i,j].Clear;
      end;
     FactCell[i,j].BColor:=-1;
     if i>C1 then FactCell[i,j].FLeftBorder.Style:=psClear;
     if i<C2 then FactCell[i,j].FRightBorder.Style:=psClear;
     if j>R1 then FactCell[i,j].FTopBorder.Style:=psClear;
     if j<R2 then FactCell[i,j].FBottomBorder.Style:=psClear;
    end;
 End;

procedure TTableObj.SetColWidths(Col:MyInteger; const Value:MyInteger);
var i:MyInteger;
 begin
  CorrCol(Col);
  for i:=1 to FRows do
   begin
    FactCell[Col,i].CellWidth:=Value;
    FactCell[Col,i].FInitCellWidth:=FactCell[Col,i].CellWidth;
   end;
 end;

procedure TTableObj.SetRowHeights(Row:MyInteger; Value:MyInteger);
var He,i:MyInteger;
 begin
  CorrRow(Row);
  if Parent<>nil then
   begin
    He:=Parent.PageHeight-Parent.TopMargin-Parent.BottomMargin;
    if Value>He then Value:=He;
   end;
  for i:=1 to FCols do
   begin
    FactCell[i,Row].CellHeight:=Value;
    FactCell[i,Row].FInitCellHeight:=FactCell[i,Row].CellHeight;
   end;
 end;

procedure TTableObj.FixRows(Row1,Row2:MyInteger);
 begin
  CorrRow(Row1);
  CorrRow(Row2);
  if Row1>Row2 then Row2:=Row1;
  FFrow1:=Row1;
  FFrow2:=Row2;
 end;

procedure TTableObj.SetWidths(P:String);
var i:Integer;
    A:TIntArray;
 begin
  GetIntArray(P,A,[',']);
  for i:=Low(A) to High(A) do
   begin
    if i=FCols then Break;
    if A[i]<>0 then ColWidths[i+1]:=A[i];
   end;
 end;

procedure TTableObj.SetBorders(Col1,Row1,Col2,Row2:MyInteger; const Br:TBorder);
var i,j:Integer;
 begin
  if Col1>Col2 then Col2:=Col1;
  if Row1>Row2 then Row2:=Row1;
  CorrCol(Col1); CorrCol(Col2);
  CorrRow(Row1); CorrRow(Row2);
  for i:=Col1 to Col2 do
   for j:=Row1 to Row2 do
    begin
     Cell[i,j].LeftBorder:=Br;
     Cell[i,j].TopBorder:=Br;
     Cell[i,j].RightBorder:=Br;
     Cell[i,j].BottomBorder:=Br;
    end;
 end;

{ TCell }

procedure TCell.BuildQueue;
 begin
  FLm:=LeftMargin+FCellX;
  FRm:=RightMargin;
  FBm:=BottomMargin;
  if Parent<>nil then
   begin
    FTm:=Parent.Bounds.Top;
    FPw:=Parent.FactCell[FCoords.Right,FCoords.Top].FCellX+
         Parent.FactCell[FCoords.Right,FCoords.Top].FCellWidth;
    FPh:=Parent.Bounds.Bottom;
   end else begin
             FTm:=TopMargin;
             FPw:=PageWidth;
             FPh:=PageHeight;
            end;
  FLastY:=FCellY;
  FLastPage:=FFirstPage;
  inherited;
 end;

procedure TCell.Clear;
 begin
  inherited;
  ObjHeight:=0;
 end;

constructor TCell.Create;
 begin
  inherited;
  FIndent:=0;
  FCellWidth:=0;
  FObjHeight:=0;
  FInitCellWidth:=0;
  FInitCellHeight:=0;
  FCellHeight:=0;
  FParent:=nil;
  FLeftMargin:=5;
  FRightMargin:=5;
  FTopMargin:=5;
  FBottomMargin:=5;
  FCellY:=FTopMargin;
  FMLeft:=0;
  FMTop:=0;
 end;

function TCell.GetCellHeight:MyInteger;
var i:MyInteger;
 begin
  Result:=0;
  if Parent=nil then Result:=FactCellHeight else
  for i:=FCoords.Top to FCoords.Bottom do Result:=Result+Parent.FactCell[FCoords.Left,i].FactCellHeight;
 end;

function TCell.GetCellWidth:MyInteger;
var i:MyInteger;
 begin
  Result:=0;
  if Parent=nil then Result:=FCellWidth else
  for i:=FCoords.Left to FCoords.Right do Result:=Result+Parent.FactCell[i,FCoords.Top].FCellWidth;
 end;

function TCell.GetFactCellHeight:MyInteger;
var H:MyInteger;
 begin
  H:=GetHeight(FFirstPage,FLastPage,FCellY,FLastY);
  if H<FCellHeight then Result:=FCellHeight
                   else Result:=H;
 end;

function TCell.GetHeight(fP,lP,fY,lY:MyInteger):MyInteger;
var bT,bB:MyInteger;
 begin
  if Parent<>nil then
   begin
    bT:=Parent.Bounds.Top;
    bB:=Parent.Bounds.Bottom;
   end else begin
             bT:=0;
             bB:=0;
            end;
  if lP-fP<=0 then Result:=lY-fY else
                   Result:=(bB-fY)+(lP-fP-1)*(bB-bT)+lY;
 end;

function TCell.GetNumPages:MyInteger;
 begin
  Result:=FLastPage;
 end;

function TCell.GetPageHeight:MyInteger;
 begin
  Result:=CellHeight;
 end;

function TCell.GetPageWidth:MyInteger;
 begin
  Result:=CellWidth;
 end;

procedure TCell.SetBColor(Value:TColor);
var i,j:Integer;
 begin
  if Parent<>nil then
   begin
    for i:=FCoords.Left to FCoords.Right do
     for j:=FCoords.Top to FCoords.Bottom do
      Parent.FactCell[i,j].FBColor:=Value;
   end else inherited;
 end;

procedure TCell.SetBottomBorder(Value:TBorder);
var i:Integer;
    Cl:TCell;
 begin
  if Parent<>nil then
   begin
    Cl:=Parent.Cell[FCoords.Left,FCoords.Top];
    for i:=Cl.FCoords.Left to Cl.FCoords.Right do
     begin
      Parent.FactCell[i,Cl.FCoords.Bottom].FBottomBorder:=Value;
      if Cl.FCoords.Bottom<Parent.FRows then
       Parent.FactCell[i,Cl.FCoords.Bottom+1].FTopBorder:=Value;
     end;
   end else inherited;
 end;

procedure TCell.SetCellHeight(Value:MyInteger);
 begin
  FactCellHeight:=Value;
 end;

procedure TCell.SetCellWidth(Value:MyInteger);
 begin
  if Value<0 then Value:=0;
  FCellWidth:=Value;
 end;

procedure TCell.SetFactCellHeight(Value:MyInteger);
 begin
  if High(FBlocks)<0 then ObjHeight:=0;
  if Value<ObjHeight then FCellHeight:=ObjHeight
                     else FCellHeight:=Value;
 end;

procedure TCell.SetHeight(H:MyInteger);
var bT,bB:Integer;
 begin
  if Parent<>nil then
   begin
    bT:=Parent.Bounds.Top;
    bB:=Parent.Bounds.Bottom;
    if FCellY+H<bB then FLastY:=FCellY+H else
     begin
      H:=H-(bB-FCellY); Inc(FLastPage);
      While (H>(bB-bT)) do
       begin
        Inc(FLastPage);
        Dec(H,bB-bT);
       end;
      FLastY:=H;
     end;
   end else FLastY:=FCellY+H;
 end;

procedure TCell.SetLeftBorder(Value:TBorder);
var i:Integer;
    Cl:TCell;
 begin
  if Parent<>nil then
   begin
    Cl:=Parent.Cell[FCoords.Left,FCoords.Top];
    for i:=Cl.FCoords.Top to Cl.FCoords.Bottom do
     begin
      Parent.FactCell[Cl.FCoords.Left,i].FLeftBorder:=Value;
      if Cl.FCoords.Left>1 then
       Parent.FactCell[Cl.FCoords.Left-1,i].FRightBorder:=Value;
     end;
   end else inherited;
 end;

procedure TCell.SetObjHeight(Value:MyInteger);
 begin
  if Value<0 then Value:=0;
  if Value<Abs(Font.Height) then Value:=Abs(Font.Height);
  FObjHeight:=Value;
  if FCellHeight<FObjHeight then FCellHeight:=FObjHeight;
 end;

procedure TCell.SetRightBorder(Value:TBorder);
var i:Integer;
    Cl:TCell;
 begin
  if Parent<>nil then
   begin
    Cl:=Parent.Cell[FCoords.Left,FCoords.Top];
    for i:=Cl.FCoords.Top to Cl.FCoords.Bottom do
     begin
      Parent.FactCell[Cl.FCoords.Right,i].FRightBorder:=Value;
      if Cl.FCoords.Right<Parent.FCols then
       Parent.FactCell[Cl.FCoords.Right+1,i].FLeftBorder:=Value;
     end
   end else inherited;
 end;

procedure TCell.SetTopBorder(Value:TBorder);
var i:Integer;
    Cl:TCell;
 begin
  if Parent<>nil then
   begin
    Cl:=Parent.Cell[FCoords.Left,FCoords.Top];
    for i:=Cl.FCoords.Left to Cl.FCoords.Right do
     begin
      Parent.FactCell[i,Cl.FCoords.Top].FTopBorder:=Value;
      if Cl.FCoords.Top>1 then
       Parent.FactCell[i,Cl.FCoords.Top-1].FBottomBorder:=Value;
     end;
   end else inherited;
 end;



procedure TPrintRep.PrintEAN13;
var i,j,RC:Integer;

 procedure PrepareCell(Cl:TCell; A:Integer; N:String; EAN13:String);
 var Tb:TTableObj;
     Br:TBorder;
     NumStr,NStrEAN:Integer;
  begin
   Br:=Border(clBlack,1,psClear);
   Cl.LeftMargin:=0; Cl.TopMargin:=0; Cl.BottomMargin:=0;Cl.RightMargin:=0;
   NumStr:=2;
   NStrEAN:=2;
   Cl.AddTable(3,NumStr);
   Tb:=Cl.LastTable;
   Tb.SetWidths('600,200,200');
   Tb.SetBorders(1,1,3,NumStr,EMPTY_BORDER);

   Tb.MergeCells(1,1,2,1);
   Tb.MergeCells(2,2,3,2);

   Tb.Cell[1,1].Align:=AL_LEFT;
   Tb.Cell[1,1].Font.Size:=3;
   Tb.Cell[1,1].AddText(N);

   Tb.Cell[3,1].Align:=AL_RIGHT;
   Tb.Cell[3,1].Font.Size:=3;
   Tb.Cell[3,1].Font.Style:=[fsBold];
   Tb.Cell[3,1].AddText(IntToStr(A));

   // Добавление даты и Штрих-Кода
   Tb.Cell[2,NStrEAN].Align:=AL_CENTER;
   Tb.Cell[2,NStrEAN].Font.Size:=3;
   Tb.Cell[2,NStrEAN].AddText(FormatDateTime('dd.mm.yy hh:nn',Now));
   if Length(EAN13)=12 then
    begin
     Tb.Cell[1,NStrEAN].Font.Name:='EanBwrP36Tt';
     Tb.Cell[1,NStrEAN].Font.Size:=8;
     Tb.Cell[1,NStrEAN].Font.CharSet:=ANSI_CHARSET;
     Tb.Cell[1,NStrEAN].AddText(GenEAN13(EAN13));
    end;

{    try
     Bm:=TBitMap.Create;
     try
      Bm.Width:=400;
      Bm.Height:=80;
      DrawBarCode(Bm.Canvas,EAN13,20,0,0,Round(Bm.Width*0.70),Round(Bm.Height*0.65));
      Tb.Cell[1,NStrEAN].Align:=AL_CENTER;
      Tb.Cell[1,NStrEAN].Stretch:=True;
      Tb.Cell[1,NStrEAN].AddImage(Bm);
     finally
      Bm.Free;
     end;

    except
    end;
 }
  end;

 Begin
  if Qr=nil then Exit;
  RC:=Qr.RecordCount;
  if RC mod 4<>0 then RC:=RC+(4-(RC mod 4));
  PrintRep.Font.Name:='Arial';
  PrintRep.Font.Size:=4;
  PrintRep.AddTable(4,RC div 4);
  Qr.First;
  for j:=1 to RC div 4 do
   begin
    for i:=1 to 4 do
     begin
      if Qr.Eof then Break;
      PrepareCell(PrintRep.LastTable.Cell[i,j],
                  Qr.FieldByName('sp5585').AsInteger,
                  TrimRight(Qr.FieldByName('nm_s').AsString),
                  Copy(Qr.FieldByName('Descr').AsString,1,12)
                  );
      Qr.Next;
     end;
    if Qr.Eof then Break;
   end;
 end;

{ TKolontitul }

constructor TKolontitul.Create;
 begin
  inherited;
  FText:='';
  Indent:=0;
 end;

destructor TKolontitul.Destroy;
 begin
  FText:='';
  inherited;
 end;

function TKolontitul.GetPageHeight:MyInteger;
 begin
  Result:=0;
 end;

function TKolontitul.GetPageWidth:MyInteger;
 begin
  Result:=0;
 end;

procedure TCustomRep.AddInterv(Size:MyInteger);
var SZ:MyInteger;
 begin
  SZ:=Font.Size;
  try
   Font.Size:=Size;
   AddText(' '+#10+' ');
  finally
   Font.Size:=SZ;
  end;
 end;

procedure PrintCennikLenta(C:TCennik);
var Tb,Tb1:TTableObj;
    i:Integer;
 begin
  With PrintRep do
   begin

    AddTable(4,4);
    Tb:=LastTable;
    Tb.SetWidths('264,70,70,70');
    Tb.SetBorders(1,1,4,4,Border(clBlack,5,psSolid));

    Tb.MergeCells(1,1,4,1);
    Tb.MergeCells(1,2,1,3);
    Tb.MergeCells(2,3,4,3);
    Tb.MergeCells(1,4,4,4);

    Tb.Cell[1,1].BottomBorder:=Border(clBlack,3,psSolid);
    Tb.Cell[1,4].TopBorder:=Border(clBlack,3,psSolid);
    Tb.Cell[2,2].BottomBorder:=Border(clBlack,3,psSolid);
    Tb.Cell[3,2].BottomBorder:=Border(clBlack,3,psSolid);
    Tb.Cell[4,2].BottomBorder:=Border(clBlack,3,psSolid);
    Tb.Cell[1,2].RightBorder:=Border(clBlack,3,psSolid);
    Tb.Cell[1,3].RightBorder:=Border(clBlack,3,psSolid);

    Tb.Cell[2,2].RightBorder:=EMPTY_BORDER;
    Tb.Cell[3,2].RightBorder:=EMPTY_BORDER;

    Tb.Cell[1,1].Align:=AL_CENTER;
    Tb.Cell[1,1].Font.Style:=[fsBold];
    Tb.Cell[1,1].AddText(C.Names);

    Tb.Cell[2,2].Align:=AL_LEFT;
    Tb.Cell[2,2].Font.Size:=2;
    Tb.Cell[2,2].AddText(DateToStr(Date));

    Tb.Cell[3,2].Align:=AL_CENTER;
    Tb.Cell[3,2].Font.Size:=2;
    Tb.Cell[3,2].AddText(IntToStr(C.P1)+'/'+IntToStr(C.P2)+'/'+IntToStr(C.P3)+'/');

    Tb.Cell[4,2].Align:=AL_RIGHT;
    Tb.Cell[4,2].Font.Size:=2;
    Tb.Cell[4,2].AddText(IntToStr(C.Art_Code));

    Tb.Cell[2,3].Align:=AL_CENTER;
    Tb.Cell[2,3].Font.Style:=[fsBold];
    Tb.Cell[2,3].Font.Size:=3;
    Tb.Cell[2,3].AddText(C.FirmName);

    Tb.Cell[1,4].Align:=AL_RIGHT;
    Tb.Cell[1,4].Font.Size:=10;
    Tb.Cell[1,4].Font.Style:=[fsBold];
    Tb.Cell[1,4].AddText(CurrToStrF(C.Cena,ffFixed,2));
    Tb.Cell[1,4].Font.Size:=3;
    Tb.Cell[1,4].AddText(' грн.');

    C.EAN13:=Copy(C.EAN13,1,12);
    if Length(C.EAN13)=12 then
     begin
      Tb.Cell[1,2].Align:=AL_LEFT;
      Tb.Cell[1,2].Font.Name:='EanBwrP36Tt';
      Tb.Cell[1,2].Font.Size:=9;
      Tb.Cell[1,2].Font.CharSet:=ANSI_CHARSET;
      Tb.Cell[1,2].AddText(GenEAN13(C.EAN13));
     end;

   end;

 end;

Initialization

 IsPreviewing:=False;
 PixperI:=600;

Finalization

 FPrintRep.Free;

End.


