unit ViewSource;

interface

uses SHDocVw, MSHTML, ActiveX, ComObj, Windows,EmbeddedWB, SysUtils;

function GetSource(WebBrowser1: TEmbeddedWB): string;
function GetFrameSource(WebDoc: iHTMLDocument2): string;
function GetBrowserForFrame(Doc:IHTMLDocument2;
nFrame:integer):IWebBrowser2;

implementation

function GetSource(WebBrowser1: TEmbeddedWB): string;
//return the source for all frames in the browser
//this technique could be done recursively for frames within frames
var
docdisp : idispatch;
Webdoc, HTMLDoc : ihtmldocument2;
framesCol : iHTMLFramesCollection2;
FramesLen : integer;
FrameWin : IHTMLWindow2;
pickFrame : olevariant;
p: integer;
begin
WebDoc := WebBrowser1.Document as IHTMLDocument2;
FramesCol := WebDoc.Get_frames;
FramesLen := FramesCol.Get_length;
//Handle multiple or single frames
if FramesLen > 0 then
for p := 0 to FramesLen-1 do
begin
pickframe := p;
try//for same domain frames, use an HTMLWindow2 interface
docdisp := framesCol.item(pickframe);
OleCheck(docdisp.QueryInterface(IID_IHTMLWindow2,
FrameWin));
WebDoc := FrameWin.Get_document;
except//for a cross-domain AV, use GetBrowserForFrame
HTMLDoc := WebBrowser1.Document as iHTMLDocument2;
WebDoc := GetBrowserForFrame(HTMLDoc,
pickframe).document
as iHTMLDocument2;
end;
result := result + GetFrameSource(WebDoc);
end
else
result := GetFrameSource(WebDoc);
end;

function GetFrameSource(WebDoc: iHTMLDocument2): string;
//returns frame HTML and scripts as a text string
var
HTMLel : iHTMLElement;
HTMLcol : iHTMLElementCollection;
HTMLlen : Integer;
begin
HTMLcol := WebDoc.Get_all;
HTMLlen := HTMLcol.length;
if HTMLlen > 0 then
begin
//return the whole thing as a string including HEAD and BODY
HTMLel := HTMLCol.item(0,0) as iHTMLElement;
result := HTMLEl.outerHTML;
end
else
result := '';
end;

function GetBrowserForFrame(Doc:IHTMLDocument2; nFrame:integer):IWebBrowser2;
 //Thanks to Rik Barker
//returns an interface to the frames browser
var pContainer:IOLEContainer;
    enumerator:IEnumUnknown;
    nFetched: PLongInt;
    unkFrame: IUnknown;
 begin
  result:=nil;
  nFetched:=nil;
//Cast the page as an OLE container
  pContainer := Doc as IOleContainer;
//Get an enumerator for the frames on the page
pContainer.EnumObjects(OLECONTF_EMBEDDINGS,enumerator);
//Now skip to the frame we re interested in
enumerator.skip(nFrame);
//and get the frame as IUnknown
enumerator.next(1,unkFrame,nFetched);
//Now QI the frame for a WebBrowser Interface - I'm not entirely
//sure this is necessary, but COM never ceases to surprise me
unkframe.QueryInterface(IID_IWebBrowser2,result);
end;

end.
