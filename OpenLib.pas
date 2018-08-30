UNIT OpenLib;
INTERFACE

Uses Windows,SysUtils,Classes,OpenGL,Graphics,ExtCtrls, Forms, StdCtrls;

Type Vector=Record
             x,y,z:GLfloat;
            end;

     TArrF4v=Array[0..3] of GLfloat;
     TArrF13v=Array[0..12] of GLfloat;

     TPoint=Record // Тип точка
             x,y,z:GLFloat;
            end;

     TGLColor=Record // Тип цвет OpenGL
               R,G,B:GLFloat;
              end;

// 1.Загрузка модели из STL-файла
Function LoadSTL(St:String; var M,N:TList):Boolean;

// 2.Создание дисплейного списка для рисования модели
Function MakeModelList(var NameL:GLInt; Path:String; Col:TArrF13v):Boolean;

// 3.Создание части дисплейного списка для рисования составной модели
Function MakePartList(Path:String; Col:TArrF13v):Boolean;

// 4.Перевод цвета в цвет OpenGl
Procedure ColorToGL(C:TColor; var R,G,B:GLFloat);

// 5.Установка параметров материала
Procedure SetMaterial(ar,ag,ab, dr,dg,db, sr,sg,sb, er,eg,eb, shine:GLfloat);

// 6.Рисует градиентный переход на BitMap-e
Procedure MakeGradientHeightB(Bm:TBitMap; Col1,Col2:TColor);

// 7.Рисует градиентный переход на Image-e
Procedure MakeGradientHeightI(Bm:TImage; Col1,Col2:TColor); overload
Procedure MakeGradientHeightI(Bm:TImage; Col1,Col2:TColor; x1,y1,x2,y2:Integer); overload

Procedure MakeGradientWidthI(Bm:TImage; Col1,Col2:TColor; Rc:Byte=0);

// 8.Рисование рамки для Image
Procedure DrawRect(var Im:TImage; C,F:TColor);

// 9.Рисование рамки для Image
Procedure DrawSimpleRect(var Im:TImage; C:TColor);

// 10.
Procedure CopyImageTransp(im1,im2:TImage);

Procedure DrawRectBlue(var Im:TImage; C:TColor=clWhite);

// Подсветка Image на манер Вкладок как в 1С8
Procedure HighLightImage(Im:TImage; C1,C2:TColor; R:Integer; Down:Boolean; ClBk:TColor; Bm:TBitMap; Kind:Byte; IsCap:Boolean);

// Сектор
Procedure sQuad(Cv:TCanvas; x,y,R,StartAng,EndAng:Integer; Param:Byte=0);

procedure PrepareIm(Im:TImage; Cnt:Integer; ZState:Integer; var B:TBitMap);

procedure DrawGradientWithRect(Image2:TImage; C1,C2:TColor);

procedure DrawWindowRound(x,y,x1,y1:Integer; Im:TImage);

Procedure MakeGradientHeightC(C:TCanvas; Col1,Col2:TColor; x1,y1,x2,y2:Integer; CNotDraw:TColor);

Procedure DrawWrapedText(C:TCanvas; M:TMemo; R:TRect; S:String);

IMPLEMENTATION

// Загрузка модели из STL-файла
Function LoadSTL(St:String; var M,N:TList):Boolean;
var f:TextFile;
    tx,ty,tz,nx,ny,nz:GLfloat;
    s:String;
    Code:Integer;

 procedure StrTo3v(S:String; var x,y,z:GLFloat);
 var i,q:Integer;
     v:Array[1..3] of String[20];
  begin
   v[1]:=''; v[2]:=''; v[3]:=''; q:=1;
   for i:=1 to Length(S) do
    if S[i]<>' ' then v[q]:=v[q]+S[i] else Inc(q);
   Val(v[1],x,Code);
   Val(v[2],y,Code);
   Val(v[3],z,Code);
  end;

 procedure AddToModelList(x,y,z:GLfloat);
 var wrkVector:Vector;
     pwrkVector:^Vector;
  begin
   wrkVector.x:=x;  wrkVector.y:=y; wrkVector.z:=z;
   New(pwrkVector); pwrkVector^:=wrkVector; M.Add(pwrkVector);
  end;

 procedure AddToNormalList(x,y,z:GLfloat);
 var wrkVector:Vector;
     pwrkVector:^Vector;
  begin
   wrkVector.x:=x;  wrkVector.y:=y; wrkVector.z:=z;
   New(pwrkVector); pwrkVector^:=wrkVector; N.Add(pwrkVector);
  end;

 Begin
  AssignFile(f,st);
  LoadSTL:=True;
  {$I-}
  ReSet(f);
  {$I+}
  if IOResult<>0 then begin LoadStl:=False; Exit; end;
  ReadLn(f,S);
  While not Eof(f) do
   begin
    ReadLn(f,s);
    if Copy(S,4,12)='facet normal' then
     begin
      StrTo3v(Copy(S,17,Length(S)-16),nx,ny,nz);
      AddToNormalList(nx,ny,nz);
      ReadLn(f,s);
      ReadLn(f,s); StrTo3v(Copy(S,17,Length(S)-16),tx,ty,tz); AddToModelList(tx,ty,tz);
      ReadLn(f,s); StrTo3v(Copy(S,17,Length(S)-16),tx,ty,tz); AddToModelList(tx,ty,tz);
      ReadLn(f,s); StrTo3v(Copy(S,17,Length(S)-16),tx,ty,tz); AddToModelList(tx,ty,tz);
     end else
    if Copy(S,1,12)='endsolid' then Break else ReadLn(f,s);
   end;
  CloseFile(f);
 end;

// Установка параметров материала
Procedure SetMaterial(ar,ag,ab, dr,dg,db, sr,sg,sb, er,eg,eb, shine:GLfloat);
var mat:Array[0..3] of GLfloat;
 begin
  glPushMatrix;

  mat[0]:=ar; mat[1]:=ag; mat[2]:=ab;
  glMaterialfv (GL_FRONT, GL_AMBIENT, @mat);

  mat[0]:=dr; mat[1]:=dg; mat[2]:=db;
  glMaterialfv (GL_FRONT, GL_DIFFUSE, @mat);

  mat[0]:=sr; mat[1]:=sg; mat[2]:=sb;
  glMaterialfv (GL_FRONT, GL_SPECULAR, @mat);

  mat[0]:=er; mat[1]:=eg; mat[2]:=eb;
  glMaterialfv (GL_FRONT, GL_EMISSION, @mat);

  glMaterialf (GL_FRONT, GL_SHININESS, shine);

  glPopMatrix;
 end;

// Создание дисплейного списка для рисования одной модели
Function MakeModelList(var NameL:GLInt; Path:String; Col:TArrF13v):Boolean;
var Model,Normals:TList;
    i:Integer;
 begin
  Model:=TList.Create;
  Normals:=TList.Create;
  MakeModelList:=True;
  if Not LoadSTL(Path,Model,Normals) then
   begin
    MakeModelList:=False;
    Model.Free;
    Normals.Free;
    Exit;
   end;
  NameL:=glGenLists(1);
  glNewList(NameL,GL_COMPILE);
  SetMaterial(Col[0],Col[1],Col[2],Col[3],Col[4],Col[5],Col[6],Col[7],Col[8],Col[9],Col[10],Col[11],Col[12]);
  for i:=0 to Round(Model.Count/3)-1 do
   begin
    glBegin(GL_TRIANGLES);
     glNormal3fv(Normals.Items[i]);
     glvertex3fv(Model.Items[i*3]);
     glvertex3fv(Model.Items[i*3+1]);
     glvertex3fv(Model.Items[i*3+2]);
    glEnd;
   end;
  glEndList;
  Model.Free;
  Normals.Free;
 end;

// Создание части дисплейного списка для рисования составной модели
Function MakePartList(Path:String; Col:TArrF13v):Boolean;
var i:Integer;
    Model,Normals:TList;
 begin
  Model:=TList.Create;
  Normals:=TList.Create;
  MakePartList:=True;
  if Not LoadSTL(Path,Model,Normals) then
   begin
    MakePartList:=False;
    Model.Free;
    Normals.Free;
    Exit;
   end;
  SetMaterial(Col[0],Col[1],Col[2],Col[3],Col[4],Col[5],Col[6],Col[7],Col[8],Col[9],Col[10],Col[11],Col[12]);
  for i:=0 to Round(Model.Count/3)-1 do
   begin
    glBegin(GL_TRIANGLES);
     glNormal3fv(Normals.Items[i]);
     glvertex3fv(Model.Items[i*3]);
     glvertex3fv(Model.Items[i*3+1]);
     glvertex3fv(Model.Items[i*3+2]);
    glEnd;
   end;
  Model.Free;
  Normals.Free;
 end;

// Перевод цвета в цвет OpenGl
Procedure ColorToGL(C:TColor; var R,G,B:GLFloat);
 begin
  R:=(c mod $100)/255;
  G:=((c div $100) mod $100)/255;
  B:=(c div $10000)/255;
 end;

// Рисует градиентный переход на BitMap-e
Procedure MakeGradientHeightB(Bm:TBitMap; Col1,Col2:TColor);
var i:Integer;
    StR,StG,StB,R1,G1,B1,R2,G2,B2:GLFLoat;
 begin
  ColorToGL(Col1,R1,G1,B1); ColorToGL(Col2,R2,G2,B2);
  StR:=(R2-R1)/Bm.Height;
  StG:=(G2-G1)/Bm.Height;
  StB:=(B2-B1)/Bm.Height;
  for i:=1 to Bm.Height do
   begin
    Bm.Canvas.Pen.Color:=Round((B1+StB*i)*255)*65536+Round((G1+StG*i)*255)*256+Round((R1+StR*i)*255);
    Bm.Canvas.MoveTo(0,i-1);
    Bm.Canvas.LineTo(Bm.Width,i-1);
   end;
 end;

// Рисует градиентный переход на Image-e
Procedure MakeGradientHeightI(Bm:TImage; Col1,Col2:TColor);
var i:Integer;
    StR,StG,StB,R1,G1,B1,R2,G2,B2:GLFLoat;
 begin
  ColorToGL(Col1,R1,G1,B1); ColorToGL(Col2,R2,G2,B2);
  StR:=(R2-R1)/Bm.Height;
  StG:=(G2-G1)/Bm.Height;
  StB:=(B2-B1)/Bm.Height;
  for i:=1 to Bm.Height do
   begin
    Bm.Canvas.Pen.Color:=Round((B1+StB*i)*255)*65536+Round((G1+StG*i)*255)*256+Round((R1+StR*i)*255);
    Bm.Canvas.MoveTo(0,i-1);
    Bm.Canvas.LineTo(Bm.Width,i-1);
   end;
 end;

Procedure MakeGradientHeightI(Bm:TImage; Col1,Col2:TColor; x1,y1,x2,y2:Integer);
var i:Integer;
    StR,StG,StB,R1,G1,B1,R2,G2,B2:GLFLoat;
 begin
  ColorToGL(Col1,R1,G1,B1); ColorToGL(Col2,R2,G2,B2);
  StR:=(R2-R1)/Abs(y2-y1+1);
  StG:=(G2-G1)/Abs(y2-y1+1);
  StB:=(B2-B1)/Abs(y2-y1+1);
  for i:=y1 to y2 do
   begin
    Bm.Canvas.Pen.Color:=Round((B1+StB*i)*255)*65536+Round((G1+StG*i)*255)*256+Round((R1+StR*i)*255);
    Bm.Canvas.MoveTo(x1,i);
    Bm.Canvas.LineTo(x2,i);
   end;
 end;

 // Рисует градиентный переход на Image-e
Procedure MakeGradientWidthI(Bm:TImage; Col1,Col2:TColor; Rc:Byte=0);
var i:Integer;
    StR,StG,StB,R1,G1,B1,R2,G2,B2:GLFLoat;
 begin
  ColorToGL(Col1,R1,G1,B1); ColorToGL(Col2,R2,G2,B2);
  StR:=(R2-R1)/Bm.Width;
  StG:=(G2-G1)/Bm.Width;
  StB:=(B2-B1)/Bm.Width;
  for i:=1 to Bm.Width do
   begin
    Bm.Canvas.Pen.Color:=Round((B1+StB*i)*255)*65536+Round((G1+StG*i)*255)*256+Round((R1+StR*i)*255);
    Bm.Canvas.MoveTo(i-1,0);
    Bm.Canvas.LineTo(i-1,Bm.Height);
   end;
  if Rc<>0 then
   begin
    Bm.Canvas.Pen.Color:=clWhite;
    Bm.Canvas.MoveTo(0,0); Bm.Canvas.LineTo(0,Bm.Height);
    Bm.Canvas.MoveTo(0,0); Bm.Canvas.LineTo(Bm.Width,0);

    Bm.Canvas.Pen.Color:=clSilver;
    Bm.Canvas.MoveTo(Bm.Width-1,Bm.Height-1); Bm.Canvas.LineTo(0,Bm.Height-1);
    Bm.Canvas.MoveTo(Bm.Width-1,Bm.Height-1); Bm.Canvas.LineTo(Bm.Width-1,0);
   end;
 end;

// Рисует градиентный переход на Канве
Procedure MakeGradientHeightC(C:TCanvas; Col1,Col2:TColor; x1,y1,x2,y2:Integer; CNotDraw:TColor);
var H,W,i,j:Integer;
    StR,StG,StB,R1,G1,B1,R2,G2,B2:GLFLoat;
 begin
  ColorToGL(Col1,R1,G1,B1); ColorToGL(Col2,R2,G2,B2);
  H:=Abs(y2-y1)+1;
  W:=Abs(x2-x1)+1;
  StR:=(R2-R1)/H;
  StG:=(G2-G1)/H;
  StB:=(B2-B1)/H;
  for i:=1 to H do
   for j:=1 to W do
    if C.Pixels[x1+j-1,y1+i-1]<>CNotDraw then
     begin
      C.Pixels[x1+j-1,y1+i-1]:=Round((B1+StB*i)*255)*65536+Round((G1+StG*i)*255)*256+Round((R1+StR*i)*255);
     end;
 end;

// Рисование рамки для Image
Procedure DrawRect(var Im:TImage; C,F:TColor);
 begin
  With Im.Canvas do
   begin
    Brush.Color:=F;
    Rectangle(Rect(0,0,Im.Width-2,Im.Height-2));
    Pen.Color:=$00000000;
    MoveTo(Im.Width-2,2); LineTo(Im.Width-2,Im.Height);
    MoveTo(2,Im.Height-2); LineTo(Im.Width-1,Im.Height-2);
    MoveTo(Im.Width-1,2); LineTo(Im.Width-1,Im.Height);
    MoveTo(2,Im.Height-1); LineTo(Im.Width-1,Im.Height-1);
    Pixels[Im.Width-1,0]:=C; Pixels[0,Im.Height-1]:=C;
    Pixels[Im.Width-1,1]:=C; Pixels[1,Im.Height-1]:=C;
    Pixels[Im.Width-2,0]:=C; Pixels[0,Im.Height-2]:=C;
    Pixels[Im.Width-2,1]:=C; Pixels[1,Im.Height-2]:=C;
   end;
 end;

// Рисование рамки для Image
Procedure DrawSimpleRect(var Im:TImage; C:TColor);
 begin
  With Im.Canvas do
   begin
    Brush.Color:=$00000000;
    Pen.Color:=$00000000;
    FrameRect(Rect(0,0,Im.Width-2,Im.Height-2));
    MoveTo(Im.Width-2,2); LineTo(Im.Width-2,Im.Height);
    MoveTo(2,Im.Height-2); LineTo(Im.Width-1,Im.Height-2);
    MoveTo(Im.Width-1,2); LineTo(Im.Width-1,Im.Height);
    MoveTo(2,Im.Height-1); LineTo(Im.Width-1,Im.Height-1);
    Pixels[Im.Width-1,0]:=C; Pixels[0,Im.Height-1]:=C;
    Pixels[Im.Width-1,1]:=C; Pixels[1,Im.Height-1]:=C;
    Pixels[Im.Width-2,0]:=C; Pixels[0,Im.Height-2]:=C;
    Pixels[Im.Width-2,1]:=C; Pixels[1,Im.Height-2]:=C;
   end;
 end;


procedure DrawRectBlue(var Im:TImage; C:TColor=clWhite);
 begin
  With Im.Canvas do
   begin
    Pen.Color:=$FFCC99;
    RoundRect(0,0,Im.Width-2,Im.Height-2,10,10);
    Pen.Color:=$EAD4AF;
    MoveTo(6,Im.Height-2); LineTo(Im.Width-7,Im.Height-2);
    MoveTo(Im.Width-2,6); LineTo(Im.Width-2,Im.Height-7);

    Arc(Im.Width-11,Im.Height-11,Im.Width-2,Im.Height-2,Im.Width-7,Im.Height-2,Im.Width-2,Im.Height-7);


    Pen.Color:=$F1E2CB;
    MoveTo(9,Im.Height-1); LineTo(Im.Width-7,Im.Height-1);
    MoveTo(Im.Width-1,9); LineTo(Im.Width-1,Im.Height-7);
    Arc(Im.Width-10,Im.Height-10,Im.Width-1,Im.Height-1,Im.Width-7,Im.Height-2,Im.Width-2,Im.Height-7);

    Pixels[Im.Width-3,Im.Height-5]:=$EAD4AF;
    Pixels[Im.Width-5,Im.Height-3]:=$EAD4AF;

    {if C<>clWhite then
     begin
      FloodFill(0,0,C,fsSurface);
      FloodFill(Im.Width-1,0,C,fsSurface);
     end;}
   end;
 end;

procedure CopyImageTransp(im1,im2:TImage);
var i,j:Integer;
    C:TColor;
 begin
  C:=im2.Canvas.Pixels[im2.Width-1,im2.Height-1];
  for i:=0 to im2.Height do
   for j:=0 to im2.Width do
    if im2.Canvas.Pixels[i,j]<>C then im1.Canvas.Pixels[i,j]:=im2.Canvas.Pixels[i,j];
 end;

procedure HighLightImage(Im:TImage; C1,C2:TColor; R:Integer; Down:Boolean; ClBk:TColor; Bm:TBitMap; Kind:Byte; IsCap:Boolean);
var x,y,dy:Integer;
const sz=32;

 procedure DrawIcon(x,y:Integer);
 var i,j:Integer;
  begin
    if Bm<>nil then
     begin
      for j:=0 to sz-1 do
       for i:=0 to sz-1 do
        begin
         if Bm.Canvas.Pixels[i,j]<>Bm.Canvas.Pixels[0,31] then
          Im.Canvas.Pixels[x+i,y+j]:=Bm.Canvas.Pixels[i,j];
        end;
     end;
  end;

 Begin
  if IsCap then dy:=0 else dy:=8;
  if Kind=1 then
   begin
    if Down then
     begin
      Im.Canvas.Brush.Color:=C2;
      Im.Canvas.FillRect(Rect(0,0,Im.Width,Im.Height));

      MakeGradientHeightI(Im,C1,C2,0,R,Im.Width,Im.Height);


      Im.Canvas.Brush.Color:=ClBk;
      Im.Canvas.FillRect(Rect(0,0,Im.Width,R));

      Im.Canvas.Pen.Color:=Im.Canvas.Pixels[1,R];
      Im.Canvas.Brush.Color:=Im.Canvas.Pixels[1,R];
      Im.Canvas.RoundRect(0,0,Im.Width,2*R,R,R);

      MakeGradientHeightI(Im,C1,C2,0,R,Im.Width,Im.Height);
      x:=(Im.Width-sz) div 2;
      y:=((Im.Height-sz) div 2)-(8-dy);
      DrawIcon(x,y);
     end else begin
               Im.Canvas.Brush.Color:=ClBk;
               Im.Canvas.FillRect(Rect(0,0,Im.Width,R));
               Im.Canvas.Brush.Color:=C2;
               Im.Canvas.FillRect(Rect(0,R,Im.Width,Im.Height));
               Im.Canvas.Pen.Color:=C1;
               Im.Canvas.MoveTo(0,R); Im.Canvas.LineTo(Im.Width,R);
               x:=(Im.Width-sz) div 2;
               y:=((Im.Height-sz) div 2)-(4-dy);
               DrawIcon(x,y);
              end;
   end else
  if Kind=2 then
   begin
    Im.Canvas.Brush.Color:=ClBk;
    Im.Canvas.FillRect(Rect(0,0,Im.Width,Im.Height));
    MakeGradientHeightI(Im,C1,C2,1,R+1,Im.Width-1,Im.Height-R-1);

    Im.Canvas.Pen.Color:=Im.Canvas.Pixels[1,R+1];
    Im.Canvas.Brush.Color:=Im.Canvas.Pixels[1,R+1];
    Im.Canvas.RoundRect(1,0,Im.Width-1,2*R,R,R);

    Im.Canvas.Pen.Color:=Im.Canvas.Pixels[1,Im.Height-R-2];
    Im.Canvas.Brush.Color:=Im.Canvas.Pixels[1,Im.Height-R-2];

    Im.Canvas.RoundRect(1,Im.Height-2*R,Im.Width-1,Im.Height-1,R,R);

    MakeGradientHeightI(Im,C1,C2,1,R+1,Im.Width-1,Im.Height-R-1);
    x:=(Im.Width-sz) div 2;
    y:=((Im.Height-sz) div 2)-(8-dy);
    DrawIcon(x,y);
   end;
 End;

Procedure sQuad(Cv:TCanvas; x,y,R,StartAng,EndAng:Integer; Param:Byte=0);
var w,px1,px2,py1,py2,py3,px3,py4,px4,x1,y1,sx1,sy1,sx,sy:Integer;
    an:Real;
    P,B:TColor;
 begin
  With Cv do
   try
    P:=Pen.Color;
    B:=Brush.Color;
    an:=EndAng;
    sx:=x+round(r*cos(an*pi/180));
    sy:=y+round(r*sin(-an*pi/180));
    sx1:=sx; sy1:=sy;
    While an>=StartAng do
     begin

      x1:=x+round(r*cos(an*pi/180));
      y1:=y+round(r*sin(-an*pi/180));

     // Pen.Color:=B;
     // MoveTo(x,y); LineTo(x1,y1);

      Pen.Color:=P;
      MoveTo(sx,sy); LineTo(x1,y1);

      an:=an-0.1;
      sx:=x1; sy:=y1;
     end;
    MoveTo(x,y); LineTo(sx1,sy1);
    MoveTo(x,y); LineTo(x1,y1);

    x1:=x+round((r div 2)*cos( ( StartAng+((EndAng-StartAng) div 2))*pi/180));
    y1:=y+round((r div 2)*sin(-( StartAng+((EndAng-StartAng) div 2))*pi/180));
    //Pixels[x1,y1]:=B;
    FloodFill(x1,y1,P,fsBorder);

    if Param=0 then
     begin
      px1:=x+round((r-20)*cos((StartAng+1)*pi/180));
      py1:=y+round((r-20)*sin(-(StartAng+1)*pi/180));

      px2:=x+round((r-50)*cos((StartAng+1)*pi/180));
      py2:=y+round((r-50)*sin(-(StartAng+1)*pi/180));

      px3:=x+round((r-35)*cos((StartAng-2)*pi/180));
      py3:=y+round((r-35)*sin(-(StartAng-2)*pi/180));

      px4:=x+round((r-35)*cos((StartAng)*pi/180));
      py4:=y+round((r-35)*sin(-(StartAng)*pi/180));

      w:=Pen.Width;
      Pen.Width:=2;
      Pen.Color:=clBlack;

      MoveTo(px1,py1); LineTo(px2,py2);
      MoveTo(px1,py1); LineTo(px3,py3);
      MoveTo(px2,py2); LineTo(px3,py3);

      Brush.Color:=clWhite;
      Pen.Color:=clWhite;

      FloodFill(px4,py4,clBlack,fsBorder);

      Pen.Width:=w;
     end;
   finally
    Pen.Color:=P;
    Brush.Color:=B;
   end;
 end;

procedure PrepareIm(Im:TImage; Cnt:Integer; ZState:Integer; var B:TBitMap);
var dy:Integer;
 begin

  dy:=15;
  B.Height:=32;
  B.Width:=40;
  B.Canvas.Brush.Color:=$00C8D0D4;
  B.Canvas.Pen.Color:=$00C8D0D4;
  B.Canvas.FillRect(Rect(0,0,B.Width,B.Height));
  B.Canvas.Draw(0,0,Im.Picture.Bitmap);


  B.Canvas.Brush.Color:=$00A6A6FF; B.Canvas.Pen.Color:=$00A6A6FF;
  B.Canvas.RoundRect(16,0+dy,32,16+dy,12,12);

  B.Canvas.Brush.Color:=$008080FF; B.Canvas.Pen.Color:=$008080FF;
  B.Canvas.RoundRect(17,1+dy,31,15+dy,11,11);

  B.Canvas.Brush.Color:=clRed; B.Canvas.Pen.Color:=clRed;
  B.Canvas.RoundRect(18,2+dy,30,14+dy,10,10);

{
  B.Canvas.Brush.Color:=$008080FF; B.Canvas.Pen.Color:=$008080FF;
  B.Canvas.RoundRect(16,0,32,16,11,11);

  B.Canvas.Brush.Color:=clRed; B.Canvas.Pen.Color:=clRed;
  B.Canvas.RoundRect(17,1,31,15,12,12);
}
  B.Canvas.Brush.Style:=bsClear;
  B.Canvas.Font.Color:=clWhite;
  B.Canvas.Font.Name:='Courier New';
  B.Canvas.Font.Size:=8;
  B.Canvas.Font.Style:=[fsBold];
  B.Canvas.TextOut(13+((22-B.Canvas.TextWidth(IntToStr(Cnt))) div 2),0+dy,IntToStr(Cnt));

  if ZState<>0 then
   begin
    B.Canvas.Font.Color:=clred;
    B.Canvas.Font.Name:='Courier New';
    B.Canvas.Font.Size:=16;
    B.Canvas.Font.Style:=[fsBold];
    B.Canvas.TextOut(0,0,'!');
   end;
 end;

procedure DrawGradientWithRect(Image2:TImage; C1,C2:TColor);
 begin
  // Image2.Picture :=nil;
  Image2.Picture.Bitmap.Width:=Image2.Width;
  Image2.Picture.Bitmap.Height:=Image2.Height;
//  Image2.Canvas.Pen.Color:=clGray;
//  Image2.Canvas.Rectangle(0,0,Image2.Width-1,Image2.Height-1);
  MakeGradientHeightI(Image2,C1,C2,1,1,20,Image2.Height-2);
 end;

procedure DrawWindowRound(x,y,x1,y1:Integer; Im:TImage);
 begin
  MakeGradientHeightI(Im,clWhite,$00E4E4F0,1,1,x1,y1);

  With Im.Canvas do
   begin

    Pen.Color:=$00767676;
    MoveTo(x+1,y); LineTo(x1,y);  MoveTo (x+1,y1-1); LineTo(x1,y1-1);
    MoveTo(y,x+1); LineTo(x,y1);  MoveTo (x1-1,y+1); LineTo(x1-1,y1);

    Pixels[x+1,y+1]:=$00BABABA;
    Pixels[x1-2,y+1]:=$00BABABA;
    Pixels[x+1,y1-2]:=$00BABABA;
    Pixels[x1-2,y1-2]:=$00BABABA;

    Pen.Color:=$00949494;
    Pixels[x,y+2]:=$00949494;  Pixels[x+1,y+2]:= $00949494;
    Pixels[x+2,y]:=$00949494;  Pixels[x+2,y+1]:= $00949494;

    Pixels[x1-1,y+2]:=$00949494; Pixels[x1-2,y+2]:=$00949494;
    Pixels[x1-3,y]:=$00949494; Pixels[x1-3,y+1]:=$00949494;

    Pixels[x,y1-3]:=$00949494;  Pixels[x+1,y-3]:= $00949494;
    Pixels[x1-3,y1]:=$00949494; Pixels[x1-3,y1-1]:=$00949494;

   end;
 end;

procedure DrawWrapedText(C:TCanvas; M:TMemo; R:TRect; S:String);
var i:Integer;
  {
    ss:String;
    IsSpace:Boolean;
    x,y:Integer;
  }

 begin

  m.Width:=Abs(R.Right-R.Left-15);
  m.Height:=Abs(R.Bottom-R.Top);
  m.Text:=S;
  for i:=0 to m.Lines.Count-1 do C.TextOut(R.Left,R.Top+i*C.TextHeight(S),m.Lines[i]);

{
  ss:='';
  IsSpace:=False;
  x:=R.Left;
  y:=R.Top;
  for i:=1 to Length(S) do
   begin
    if (S[i]=' ') and (IsSpace=False) then
     begin
      IsSpace:=True;
      ss:=ss+' ';


     end else begin
               ss:=ss+S[i];
               IsSpace:=False;
              end;
   end;
}
 end;

END.
