unit SendReceiveXML;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Controls, Dialogs, Util, IdHTTP, IdURI;


type TSndRecXML=class

     private

       FHTTP:TIDHTTP;
       FXMLBody:String;
       FVariable:String;
       FURL:String;
       FResults:String;

     public

       procedure Post;

       constructor Create;
       destructor Destroy; override;

       property XMLBody:String read FXMLBody write FXMLBody;
       property Variable:String read FVariable write FVariable;
       property Results:String read FResults write FResults;
       property URL:String read FURL write FURL;
       property HTTP:TIDHTTP read FHTTP write FHTTP;

     end;

function SndRecXML:TSndRecXML;

implementation

var FSndRecXML:TSndRecXML=nil;

function SndRecXML:TSndRecXML;
 begin
  if FSndRecXML=nil then FSndRecXML:=TSndRecXML.Create;
  Result:=FSndRecXML;
 end;

{ TSndRecXML }

constructor TSndRecXML.Create;
 begin
  FHTTP:=TidHTTP.Create(nil);
  FHTTP.HTTPOptions:=[];
  FHTTP.AllowCookies:=True;
  FHTTP.HandleRedirects:=True;
  FHTTP.Request.BasicAuthentication:=True;
  FHTTP.ProtocolVersion:=pv1_1;

  FHTTP.Request.ContentType:='Content-Type';
  FHTTP.Request.ContentType:='application/x-www-form-urlencoded';

  FHTTP.Request.Accept:='text/xml';
  FHTTP.Request.Connection:='keep-alive';

{
  FHTTP.ProxyParams.ProxyServer:='192.168.101.236';
  FHTTP.ProxyParams.ProxyPort:=8080;
}
  FHTTP.ReadTimeout:=60000;
//  ShowMessage(IntToStr(FHTTP.ReadTimeout));
  FURL:='';
  FVariable:='';
  FResults:='';
  FXMLBody:='';
 end;

destructor TSndRecXML.Destroy;
 begin
  FHTTP.Free;
  inherited;
 end;

procedure TSndRecXML.Post;
var SL:TStringList;
 begin
  SL:=TStringList.Create;
  try
   FResults:='';
   SL.Text:=FXMLBody;
   if FVariable<>'' then SL.Text:=FVariable+'='+EncodeBase64(FXMLBody);
   SL.Text:=TidUri.PathEncode(SL.Text);
   FResults:=Utf8ToAnsi(DecodeBase64(FHTTP.POST(FURL,SL)));
  finally
   SL.Free;
  end;
 end;

Initialization

Finalization

 FSndRecXML.Free;

end.
