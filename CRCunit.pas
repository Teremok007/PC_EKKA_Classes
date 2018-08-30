Unit CRCunit;

Interface

function GetNewCRC(OldCRC:Cardinal; StPtr:Pointer; StLen:Integer):Cardinal;
procedure UpdateCRC(StPtr:Pointer; StLen:Integer; var CRC:Cardinal);
function GetZipCRC(StPtr:Pointer; StLen:Integer):Cardinal;
function GetFileCRC(const FileName:String): Cardinal;

Implementation

var CRCtable: array[0..255] of Cardinal;

function GetNewCRC(OldCRC:Cardinal; StPtr:Pointer; StLen:Integer):Cardinal;
 asm
   test edx,edx;
   jz @ret;
   neg ecx;
   jz @ret;
   sub edx,ecx; // Address after last element
   push ebx;
   mov ebx,0; // Set ebx=0 & align @next
 @next:
   mov bl,al;
   xor bl,byte [edx+ecx];
   shr eax,8;
   xor eax,cardinal [CRCtable+ebx*4];
   inc ecx;
   jnz @next;
   pop ebx;
 @ret:
 end;

procedure UpdateCRC(StPtr:Pointer; StLen:integer; var CRC: cardinal);
 begin
  CRC:=GetNewCRC(CRC, StPtr, StLen);
 end;

function GetZipCRC(StPtr: pointer; StLen: integer): cardinal;
 begin
  Result:=not GetNewCRC($FFFFFFFF, StPtr, StLen);
 end;

function GetFileCRC(const FileName: string):Cardinal;
const BufSize=64*1024;

var Fi:File;
   pBuf:PChar;
   Count:integer;

 begin
  Assign(Fi,FileName);
  Reset(Fi,1);
  GetMem(pBuf,BufSize);
  Result:=$FFFFFFFF;
  Repeat
   BlockRead(Fi,pBuf^,BufSize,Count);
   if Count=0 then break;
   Result:=GetNewCRC(Result, pBuf, Count);
  Until false;
  Result:=not Result;
  FreeMem(pBuf);
  CloseFile(Fi);
 end;

procedure CRCInit;
var c:Cardinal;
    i,j:Integer;
 begin
  for i := 0 to 255 do
   begin
    c:=i;
    for j:=1 to 8 do
     if odd(c) then c:=(c shr 1) xor $EDB88320
               else c:=(c shr 1);
    CRCtable[i]:=c;
   end;
 end;

Initialization
  CRCinit;

End.