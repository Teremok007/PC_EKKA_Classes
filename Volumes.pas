unit Volumes;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
     Dialogs,mmsystem, StdCtrls;

function GetVolumeV: Byte;
procedure SetVolumeV(aVolume: Byte);

implementation

type
TVolumeRec = record
case Integer of
0: (LongVolume: Longint);
1: (LeftVolume,RightVolume : Word);
end;

function GetVolumeV: Byte;
var Vol: TVolumeRec;
begin
Vol.LongVolume := 0;
waveOutGetVolume(1, @Vol.LongVolume);
Result := (Vol.LeftVolume + Vol.RightVolume) shr 9;
end;

procedure SetVolumeV(aVolume: Byte);
var Vol: TVolumeRec;
begin
Vol.LeftVolume := aVolume shl 8;
Vol.RightVolume := Vol.LeftVolume;
waveOutSetVolume(1,Vol.LongVolume);
end;

END.