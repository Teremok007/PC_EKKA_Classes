Unit Colors;

INTERFACE

Uses Windows,Graphics;

function RGBToColor(R,G,B:Byte):TColor;
function GetR(const Color: TColor): Byte; //���������� ��������
function GetG(const Color: TColor): Byte; //���������� ��������
function GetB(const Color: TColor): Byte; //���������� ��������
function BLimit(B: Integer): Byte;

IMPLEMENTATION

function RGBToColor(R,G,B:Byte):TColor;
 begin
  Result := B shl 16 or G shl 8 or R;
 end;

function GetR(const Color: TColor): Byte; //���������� ��������
 begin
  Result:=Lo(Color);
 end;

function GetG(const Color: TColor): Byte; //���������� �������
 begin
  Result:=Lo(Color shr 8);
 end;

function GetB(const Color: TColor): Byte; //���������� ������
 begin
  Result := Lo((Color shr 8) shr 8);
 end;

function BLimit(B: Integer): Byte;
 begin
  if B<0 then Result:=0 else if B>255 then Result:=255 else Result:=B;
end;

END.
