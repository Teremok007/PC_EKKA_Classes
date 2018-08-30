unit Volume;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Dialogs, MMSystem;

Procedure SetMasterVolumeToZero;

Procedure SetMasterVolumeToValue(value:word);

implementation

function GetVolumeControl(aMixer:HMixer; componentType,ctrlType:Longint;   var mxc:TMixerControl):Boolean;
 var
   mxl: TMixerLine;
   mxlc: TMixerLineControls;
   rc: Longint;
 begin
   Result := False;
   FillChar(mxl, SizeOf(TMixerLine), 0);
   mxl.cbStruct := SizeOf(TMixerLine);
   mxl.dwComponentType := componentType;
   {Obtain a line corresponding to the component type}
   rc := mixerGetLineInfo(aMixer, @mxl, MIXER_GETLINEINFOF_COMPONENTTYPE);
   if rc = MMSYSERR_NOERROR then
   begin
     with mxlc do
     begin
       cbStruct := SizeOf(TMixerLineControls);
       dwLineID := mxl.dwLineID;
       dwControlType := ctrlType;
       cControls := 1;
       cbmxctrl := SizeOf(TMixerLine);
       pamxctrl := @mxc;
       pamxctrl^.cbStruct := SizeOf(TMixerControl);
     end;
     mixerGetLineControls(aMixer, @mxlc, MIXER_GETLINECONTROLSF_ONEBYTYPE);
     rc := mixerGetLineControls(aMixer, @mxlc, MIXER_GETLINECONTROLSF_ONEBYTYPE);
     Result := rc = MMSYSERR_NOERROR;
   end;
 end;

function SetVolumeControl(aMixer: HMixer; mxc: TMixerControl; volume: Longint): Boolean;
 var
   mxcd: TMixerControlDetails;
   vol: TMixerControlDetails_Unsigned;
   rc: MMRESULT;
 begin
   FillChar(mxcd, SizeOf(mxcd), 0);
   with mxcd do
   begin
     cbStruct := SizeOf(TMixerControlDetails);
     dwControlID := mxc.dwControlID;
     cbDetails := SizeOf(TMixerControlDetails_Unsigned);
     paDetails := @vol;
     cMultipleItems := 0;
     cChannels := 1;
   end;
   vol.dwValue := volume;
   rc := mixerSetControlDetails(aMixer, @mxcd, MIXER_SETCONTROLDETAILSF_VALUE);
   Result := rc = MMSYSERR_NOERROR;
 end;

 function InitMixer: HMixer;
 var
   Err: MMRESULT;
 begin
   Err := mixerOpen(@Result, 0, 0, 0, 0);
   if Err <> MMSYSERR_NOERROR then
     Result := 0;
 end;

procedure SetMasterVolumeToZero;
 var
   MyMixerHandle: HMixer;
   MyVolCtrl: TMixerControl;
 begin
   MyMixerHandle := InitMixer;
   if MyMixerHandle <> 0 then
     try
       FillChar(MyVolCtrl, SizeOf(MyVolCtrl), 0);
       if GetVolumeControl(MyMixerHandle, MIXERLINE_COMPONENTTYPE_DST_SPEAKERS,
         MIXERCONTROL_CONTROLTYPE_VOLUME, MyVolCtrl) then
       begin
         {The last parameter (0) here is the volume level}
         if SetVolumeControl(MyMixerHandle, MyVolCtrl, 0) then
           ShowMessage('Volume should now be set to zero');
       end;
     finally
       mixerClose(MyMixerHandle);
     end;
 end;

procedure SetMasterVolumeToValue(value:word);
 var
   MyMixerHandle: HMixer;
   MyVolCtrl: TMixerControl;
 begin
   MyMixerHandle := InitMixer;
   if MyMixerHandle <> 0 then
     try
       FillChar(MyVolCtrl, SizeOf(MyVolCtrl), 0);
       if GetVolumeControl(MyMixerHandle, MIXERLINE_COMPONENTTYPE_DST_SPEAKERS,
         MIXERCONTROL_CONTROLTYPE_VOLUME, MyVolCtrl) then
       begin
         {The last parameter (0) here is the volume level}
         SetVolumeControl(MyMixerHandle, MyVolCtrl, value);
       end;
     finally
       mixerClose(MyMixerHandle);
     end;
 end;

end.

