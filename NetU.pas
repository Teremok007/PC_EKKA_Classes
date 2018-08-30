Unit NetU;

Interface

Uses Windows, Messages, SysUtils, Variants, Classes, WinSock;

Const
 MAX_ADAPTER_NAME_LENGTH        = 256;
 MAX_ADAPTER_DESCRIPTION_LENGTH = 128;
 MAX_ADAPTER_ADDRESS_LENGTH     = 8;
 IPHelper = 'iphlpapi.dll';

 MIB_IF_TYPE_OTHER     = 1;
 MIB_IF_TYPE_ETHERNET  = 6;
 MIB_IF_TYPE_TOKENRING = 9;
 MIB_IF_TYPE_FDDI      = 15;
 MIB_IF_TYPE_PPP       = 23;
 MIB_IF_TYPE_LOOPBACK  = 24;
 MIB_IF_TYPE_SLIP      = 28;

Type
 time_t = Longint;

 IP_ADDRESS_STRING = record
   S: array [0..15] of Char;
 end;
 IP_MASK_STRING = IP_ADDRESS_STRING;
 PIP_MASK_STRING = ^IP_MASK_STRING;

 PIP_ADDR_STRING = ^IP_ADDR_STRING;
 IP_ADDR_STRING = record
   Next: PIP_ADDR_STRING;
   IpAddress: IP_ADDRESS_STRING;
   IpMask: IP_MASK_STRING;
   Context: DWORD;
 end;

 PIP_ADAPTER_INFO = ^IP_ADAPTER_INFO;
 IP_ADAPTER_INFO = record
   Next: PIP_ADAPTER_INFO;
   ComboIndex: DWORD;
   AdapterName: array [0..MAX_ADAPTER_NAME_LENGTH + 3] of Char;
   Description: array [0..MAX_ADAPTER_DESCRIPTION_LENGTH + 3] of Char;
   AddressLength: UINT;
   Address: array [0..MAX_ADAPTER_ADDRESS_LENGTH - 1] of BYTE;
   Index: DWORD;
   Type_: UINT;
   DhcpEnabled: UINT;
   CurrentIpAddress: PIP_ADDR_STRING;
   IpAddressList: IP_ADDR_STRING;
   GatewayList: IP_ADDR_STRING;
   DhcpServer:IP_ADDR_STRING;
   HaveWins:BOOL;
   PrimaryWinsServer:IP_ADDR_STRING;
   SecondaryWinsServer:IP_ADDR_STRING;
   LeaseObtained: time_t;
   LeaseExpires: time_t;
 end;

procedure GetIPConfig(var Ip,Mask,GateWay:String);
procedure SetIPConfig(Ip,Mask,GateWay:String; DHCP:Boolean);

Implementation

function SetAdapterIpAddress(szAdapterGUID: PChar; dwDHCP, dwIP, dwMask, dwGateway: DWORD): DWORD; stdcall; external 'iphlpapi.dll';

function GetAdaptersInfo(pAdapterInfo: PIP_ADAPTER_INFO; var pOutBufLen: ULONG): DWORD; stdcall; external IPHelper;

function GetAdapterGUID:String;
var InterfaceInfo,
    TmpPointer: PIP_ADAPTER_INFO;
    Len:ULONG;
 begin
  if GetAdaptersInfo(nil, Len) = ERROR_BUFFER_OVERFLOW then
   begin
    GetMem(InterfaceInfo, Len);
    try
      if GetAdaptersInfo(InterfaceInfo, Len) = ERROR_SUCCESS then
      begin
        TmpPointer := InterfaceInfo;
        repeat
          if Result<>'' then
            Result:=Result+#13#10;
          Result:=Result+TmpPointer^.AdapterName;
          TmpPointer:=TmpPointer.Next;
        until TmpPointer=nil;
      end;
    finally
     FreeMem(InterfaceInfo);
    end;
  end;
 end;

procedure GetIPConfig(var Ip,Mask,GateWay:String);
var InterfaceInfo,
    TmpPointer: PIP_ADAPTER_INFO;
    Len:ULONG;
    S:String;
 begin
  Ip:=''; Mask:=''; GateWay:=''; 
  if GetAdaptersInfo(nil, Len)<>ERROR_BUFFER_OVERFLOW then Abort;
  GetMem(InterfaceInfo, Len);
  try
   if GetAdaptersInfo(InterfaceInfo, Len) = ERROR_SUCCESS then
    begin
     TmpPointer:=InterfaceInfo;
     Repeat
      S:=TmpPointer^.IpAddressList.IpAddress.S;
      if (Ip<>'') and (S<>'') then Ip:=Ip+#13#10;
      Ip:=Ip+S;

      S:=TmpPointer^.IpAddressList.IpMask.S;
      if (Mask<>'') and (S<>'') then Mask:=Mask+#13#10;
      Mask:=Mask+S;

      S:=TmpPointer^.GatewayList.IpAddress.S;
      if (GateWay<>'') and (S<>'') then GateWay:=GateWay+#13#10;
      GateWay:=GateWay+S;

      TmpPointer:=TmpPointer.Next;
     Until TmpPointer=nil;
    end else raise EAbort.Create('Ошибка чтения параметров сетевого адаптера!');
  finally
   FreeMem(InterfaceInfo);
  end;
  if Not (Ip<>'') and (Mask<>'') and (GateWay<>'') then raise EAbort.Create('Ошибка чтения параметров сетевого адаптера!');
 end;

procedure SetIPConfig(Ip,Mask,GateWay:String; DHCP:Boolean);
var strl:TStringList;
    s1,s2,s3:String;
    d:DWord;
 begin
  Strl:=TStringList.Create;
  try
   Strl.Text:=GetAdapterGUID;
   if strl.Count<=0 then raise EAbort.Create('Ошибка определния сетевого адаптера!');
   GetIPConfig(s1,s2,s3);
   if DHCP then d:=Inet_Addr('255.255.255.255') else d:=0;
   if Ip=''      then Ip:=s1;
   if Mask=''    then Mask:=s2;
   if GateWay='' then GateWay:=s3;
   if SetAdapterIpAddress(PChar(Strl.Strings[0]),
                          d,
                          Inet_Addr(PChar(Ip)),
                          Inet_Addr(PChar(Mask)),
                          Inet_Addr(PChar(GateWay))) <> ERROR_SUCCESS then raise EAbort.Create('Ошибка установки параметров сетевого адаптера!');;
  finally
   strl.Free;
  end;
 end;

End.