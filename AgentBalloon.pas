{********************************************************************}
{                     DlgBalloon by Denis Butorin                    }
{    DlgBalloon выноска для MS Agent. Распространяется бесплатно.    }
{    Вы также можете распространять данный компонент бесплатно       }
{    в немодифициорованном виде с обязательной ссылкой на автора     }
{    компонента - Буторина Дениса и его сайт - http://subritto.h1.ru }
{    Вы можете модифицировать данный компонент в целях улучшения его }
{    функциональности. Однако, прошу вас высылать мне модификации,   }
{    чтобы они были доступны всем остальным пользователям.           }
{                           subritto@ngs.ru                          }
{********************************************************************}
unit AgentBalloon;

interface

uses
  Windows, Messages, Forms, Dialogs, SysUtils, Classes, Graphics,
  Controls, StdCtrls, ExtCtrls, OleCtrls,
  BlnTypesConst, BlnImageButton, BlnCheckBox, BlnOptionButton, BlnSpeedButton, BalloonForm,
  ShellAPI, ComObj, ActiveX, AgentObjects_TLB, AgentServerObjects_TLB, Math;

type
  TFrmBalloon = class(TObject)
    constructor Create; virtual;
    destructor Destroy; override;
  private
    FButtons: TStrings;
    FOptionButtons: TStrings;
    FComment: WideString;
    FID: Integer;
    FIcon: TMsgDlgType;
    FInterval: Integer;
    FShowIcon: Boolean;
    FMessage: WideString;
    FSepLine: Boolean;
    FShowStyle: TShowStyle;
    FTextBoxAction: TTextBoxAction;
    FTBoxLines: integer;
    FTBoxText: WideString;
    FTextBox: Boolean;
    FTitle: WideString;
    FButtonPressed: integer;
    FOptionPressed: integer;
  public
    property Comment: WideString read FComment write FComment;
    property ID: integer read FID write FID;
    property Icon: TMsgDlgType read FIcon write FIcon;
    property Interval: integer read FInterval write FInterval;
    property ShowIcon: Boolean read FShowIcon write FShowIcon;
    property Message: WideString read FMessage write FMessage;
    property SepLine: Boolean read FSepLine write FSepLine;
    property ShowStyle: TShowStyle read FShowStyle write FShowStyle;
    property TextBoxAction: TTextBoxAction read FTextBoxAction write FTextBoxAction;
    property TextBoxLines: integer read FTboxLines write FTboxLines default 2;
    property TextBoxText: WideString read FTboxText write FTboxText;
    property TextBox: Boolean read FTextBox write FTextBox;
    property Title: WideString read FTitle write FTitle;
    property ButtonPressed: integer read FButtonPressed write FButtonPressed;
    property OptionPressed: integer read FOptionPressed write FOptionPressed;
    property Buttons: TStrings read FButtons write FButtons;
    property OptionButtons: TStrings read FOptionButtons write FOptionButtons;
  end;

  TNotifyForm = class(TFrmBalloon)
  private
    FArrowPoint: TPoint;
    FCloseButton: Boolean;
    FOrientation: TNotifyOrientation;
    FTimeOut: Integer;
    FFocusHWND: HWND;
  public
    property ArrowPoint: TPoint read FArrowPoint write FArrowPoint;
    property CloseButton: Boolean read FCloseButton write FCloseButton;
    property Orientation: TNotifyOrientation read FOrientation write FOrientation;
    property TimeOut: Integer read FTimeOut write FTimeOut;
    property FocusHWND: HWND read FFocusHWND write FFocusHWND;
  end;

  TDlgBalloon = class(TComponent)
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  private
    //CurrBln: ^TBalloonForm;
    CurrModalessBln: TBalloonForm;

    FOnFrmBlnOptionClick: TBalloonOnFrmBlnOptionClick;
    FOnFrmBlnButtonClick: TBalloonOnFrmBlnButtonClick;
    FOnFrmBlnTBoxKeyPress: TBalloonOnFrmBlnTBoxKeyPress;
    FOnNotiBlnOptionClick: TBalloonOnNotiBlnOptionClick;
    FOnNotiBlnButtonClick: TBalloonOnNotiBlnButtonClick;
    FOnNotiBlnTBoxKeyPress: TBalloonOnNotiBlnTBoxKeyPress;
    FOnSuggestClick: TBalloonOnSuggestClick;
    FOnTipClose: TBalloonOnTipClose;
    FOnNotifyClick: TBalloonOnNotifyClick;

    FVisibleBalloon: TBalloonType;

    FAgentObjectType: TAgentObjectType;
    FAgentControl: IAgentCtlCharacterEx;
    FAgentServer: IAgentCharacterEx;

    FFormBalloon: TFrmBalloon;
    FNotifyForm: TNotifyForm;
    FBalloonWidth: Integer;
    FButtonPicture: TPicture;
    FURLButtonPicture: WideString;  //
    FOptionPicture: TPicture;
    FURLOptionPicture: WideString; //
    FCloseButtonImage: TPicture;
    FURLCloseButtonImage: WideString;   //
    FSuggestPicture: TPicture;
    FURLSuggestPicture: WideString; //
    FBackgroundImage: TPicture;
    FURLBackgroundImage: WideString; //
    FFont: TFont;
    FForeColor: TColor;
    FBackColor: TColor;
    FLineColor: TColor;
    FBorderColor: TColor;
    FMaskColor: TColor; //
    FUserMove: WordBool;
    FButtonsCaptions: WideString;
    FIconPicture: TPicture;
    FCustomSysIcons: TPicture;
    FIconType: TIconType;
    FURLIconPicture: WideString; //
    FBorderFocus: WordBool; //
    FStyle: TBalloonModeStyle; //
    FLinkMouseIcon: TPicture; //
    FTextBoxColor: TColor;
    FMoveStyle: TMoveStyleConstants; //
    FBalloonDistanceX: Smallint;
    FBalloonDistanceY: Smallint;
    FIconSize: Smallint;
    FShowEffect: TShowEffect;
    FSpeakingAllMsg: Boolean;
    FSpeed: integer;
    FPitch: integer;
    FTargetScreenRect: TRect;

    ImgListButtonPicture: TImageList;
    ImgListOptionPicture: TImageList;
    ImgListCloseButtonImage: TImageList;
    ImgListCustomSys32: TImageList;
    ImgListCustomSys16: TImageList;

    TimerClsModelessFrm: TTimer;

    procedure SetBalloonWidth(Value: Integer);
    procedure SetButtonPicture(const Value: TPicture);
    procedure SetOptionPicture(const Value: TPicture);
    procedure SetCloseButtonImage(const Value: TPicture);
    procedure SetSuggestPicture(const Value: TPicture);
    procedure SetBackgroundImage(const Value: TPicture);
    procedure SetFont(const Value: TFont);
    procedure SetButtonsCaptions(const Value: WideString);
    procedure SetIconPicture(const Value: TPicture);
    procedure SetCustomSysIcons(const Value: TPicture);
    procedure SetStyle(Value: TBalloonModeStyle);
    procedure SetLinkMouseIcon(const Value: TPicture);
    procedure SetMoveStyle(Value: TMoveStyleConstants);
    procedure SetIconSize(const Value: Smallint);
    procedure SetAgentObjectType(const Value: TAgentObjectType);
    function GetCharacterObject: IUnknown;
    procedure SetCharacterObject(const Value: IUnknown);
    function CreateBlnForm(typeBlb: TBalloonType; aID: Smallint; Title: WideString;
                Prompt: WideString; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons;
                ShowIcon: Boolean; SepLine: Boolean; CloseBtn: Boolean; EditBox: Boolean;
                TextEdit: WideString; CheckBox: Boolean; CheckText: WideString;
                TimeOut: Integer; aArPoint: TPoint; aNotiOrient: TNotifyOrientation): TBalloonForm;
    procedure OnBlnClose(Sender: TObject);
    procedure BalloonOn(b: Boolean);
    procedure SpeakMsg(Msg: string);

    procedure OnLFrmBlnOptionClick(Sender: TObject; Index: Integer; TBoxText: WideString);
    procedure OnLFrmBlnButtonClick(Sender: TObject; Index: Integer; TBoxText: WideString);
    procedure OnLFrmBlnTBoxKeyPress(Sender: TObject; ID: Integer; var Key: Char);
    procedure OnLNotiBlnTBoxKeyPress(Sender: TObject; ID: Integer; var Key: Char);
    procedure OnLNotiBlnOptionClick(Sender: TObject; Index: Integer; TBoxText: WideString);
    procedure OnLNotiBlnButtonClick(Sender: TObject; Index: Integer; TBoxText: WideString);

  public
    property CharacterObject: IUnknown read GetCharacterObject write SetCharacterObject;
    procedure ShowFormBalloon();
    procedure ShowNotifyBalloon();
    procedure ShowMessage(const Title: WideString; const Prompt: WideString);
    function  MessageDlg(const Title: WideString; const Prompt: WideString; DlgType: TMsgDlgType;
                         Buttons: TMsgDlgButtons): TModalResult;
    procedure QuickNotification(const Title: WideString; const Prompt: WideString;
                         DlgType: TMsgDlgType; ArrowPoint: TPoint; NotifyOrient: TNotifyOrientation;
                         ShowCloseBtn: Boolean; TimeOut: Integer);
    procedure QuickNotificationEx(const Title: WideString; const Prompt: WideString;
                         DlgType: TMsgDlgType; NotifyOrient: TNotifyOrientation;
                         ShowCloseBtn: Boolean; TimeOut: Integer; aFocusHWND: HWND);

    function  InputBox(const Title: WideString; const Prompt: WideString;
                           const Default: WideString): WideString;
    procedure Suggest(IDSuggest: Smallint; TimeOut: Integer);
    procedure TipBalloon(const Tip: WideString; IDTip: Smallint; Button: WordBool;
                         const ChkBoxText: WideString; TimeOut: Integer; TipWidth: Smallint);
    procedure About;
    procedure ResetProperties;
    procedure RaiseFrmBlnOptionClick(Index: Smallint; const TBoxText: WideString);
    procedure RaiseFrmBlnButtonClick(Index: Smallint; const TBoxText: WideString);
    procedure RaiseSuggestClick(IDSuggest: Smallint);
    procedure RaiseTipClose(IDTip: Smallint; CheckBoxValue: Smallint);
    procedure HideBalloonToMove;
    procedure MoveBalloonToCharacter;
    procedure SetCharacterPosition(CharacterLeft: Smallint; CharacterTop: Smallint;
                                   CharacterWidth: Smallint);
    procedure SetManualPosition(X: Smallint; Y: Smallint);
    procedure HideNotify;
    procedure HideSuggest;
    procedure HideTipBalloon;
  published
    property AgentObjectType: TAgentObjectType read FAgentObjectType write SetAgentObjectType;
    property FormBalloon: TFrmBalloon read FFormBalloon write FFormBalloon;
    property NotifyForm: TNotifyForm read FNotifyForm write FNotifyForm;
    property BalloonWidth: Integer read FBalloonWidth write SetBalloonWidth default 230;
    property ButtonPicture: TPicture read FButtonPicture write SetButtonPicture;
    property URLButtonPicture: WideString read FURLButtonPicture write FURLButtonPicture;
    property OptionPicture: TPicture read FOptionPicture write SetOptionPicture;
    property URLOptionPicture: WideString read FURLOptionPicture write FURLOptionPicture;
    property CloseButtonImage: TPicture read FCloseButtonImage write SetCloseButtonImage;
    property URLCloseButtonImage: WideString read FURLCloseButtonImage write FURLCloseButtonImage;
    property SuggestPicture: TPicture read FSuggestPicture write SetSuggestPicture;
    property URLSuggestPicture: WideString read FURLSuggestPicture write FURLSuggestPicture;
    property BackgroundImage: TPicture read FBackgroundImage write SetBackgroundImage;
    property URLBackgroundImage: WideString read FURLBackgroundImage write FURLBackgroundImage;
    property Font: TFont read FFont write SetFont;
    property ForeColor: TColor read FForeColor write FForeColor default clBlack;
    property BackColor: TColor read FBackColor write FBackColor default $00CCFFFF;
    property LineColor: TColor read FLineColor write FLineColor default $00E0E0E0;
    property BorderColor: TColor read FBorderColor write FBorderColor default clBlack;
    property MaskColor: TColor read FMaskColor write FMaskColor default clFuchsia;
    property UserMove: WordBool read FUserMove write FUserMove default true;
    property ButtonsCaptions: WideString read FButtonsCaptions write SetButtonsCaptions;
    property IconPicture: TPicture read FIconPicture write SetIconPicture;
    property URLIconPicture: WideString read FURLIconPicture write FURLIconPicture;
    property CustomSysIcons: TPicture read FCustomSysIcons write SetCustomSysIcons;
    property IconType: TIconType read FIconType write FIconType;
    property BorderFocus: WordBool read FBorderFocus write FBorderFocus;
    property Style: TBalloonModeStyle read FStyle write SetStyle;
    property LinkMouseIcon: TPicture read FLinkMouseIcon write SetLinkMouseIcon;
    property TextBoxColor: TColor read FTextBoxColor write FTextBoxColor;
    property MoveStyle: TMoveStyleConstants read FMoveStyle write SetMoveStyle;
    property BalloonDistanceX: Smallint read FBalloonDistanceX write FBalloonDistanceX;
    property BalloonDistanceY: Smallint read FBalloonDistanceY write FBalloonDistanceY;
    property IconSize: Smallint read FIconSize write SetIconSize default 32;
    property ShowEffect: TShowEffect read FShowEffect write FShowEffect default seNone;
    property SpeakingAllMsg: Boolean read FSpeakingAllMsg write FSpeakingAllMsg;
    property Speed: integer read FSpeed write FSpeed;
    property Pitch: integer read FPitch write FPitch;
    property TargetScreenRect: TRect read FTargetScreenRect write FTargetScreenRect; //На че показывать без агента
    property OnFrmBlnOptionClick: TBalloonOnFrmBlnOptionClick read FOnFrmBlnOptionClick write FOnFrmBlnOptionClick;
    property OnFrmBlnButtonClick: TBalloonOnFrmBlnButtonClick read FOnFrmBlnButtonClick write FOnFrmBlnButtonClick;
    property OnNotiBlnOptionClick: TBalloonOnNotiBlnOptionClick read FOnNotiBlnOptionClick write FOnNotiBlnOptionClick;
    property OnNotiBlnButtonClick: TBalloonOnNotiBlnButtonClick read FOnNotiBlnButtonClick write FOnNotiBlnButtonClick;
    property OnFrmBlnTBoxKeyPress: TBalloonOnFrmBlnTBoxKeyPress read FOnFrmBlnTBoxKeyPress write FOnFrmBlnTBoxKeyPress;
    property OnNotiBlnTBoxKeyPress: TBalloonOnNotiBlnTBoxKeyPress read FOnNotiBlnTBoxKeyPress write FOnNotiBlnTBoxKeyPress;
    property OnSuggestClick: TBalloonOnSuggestClick read FOnSuggestClick write FOnSuggestClick;
    property OnTipClose: TBalloonOnTipClose read FOnTipClose write FOnTipClose;
    property OnNotifyClick: TBalloonOnNotifyClick read FOnNotifyClick write FOnNotifyClick;
  end;

implementation

type
 TArrayString = array of string;

const
 BLN_HORZMARGIN: integer = 8;
 BLN_VERTMARGIN: integer = 6;
 BLN_BTNSPACING: integer = 5;

var
 IconIDs: array[TMsgDlgType] of PChar = (IDI_EXCLAMATION, IDI_HAND,
    IDI_ASTERISK, IDI_QUESTION, nil);
 ButtonNames: array[TMsgDlgBtn] of string = (
    'Yes', 'No', 'OK', 'Cancel', 'Abort', 'Retry', 'Ignore', 'All', 'NoToAll',
    'YesToAll', 'Help');
 ButtonCaptions: array[TMsgDlgBtn] of string = (
    '&Yes', '&No', '&OK', '&Cancel', '&Abort', '&Retry', '&Ignore', '&All', 'N&oToAll',
    'YesTo&All', '&Help');
 ModalResults: array[TMsgDlgBtn] of Integer = (
    mrYes, mrNo, mrOk, mrCancel, mrAbort, mrRetry, mrIgnore, mrAll, mrNoToAll,
    mrYesToAll, 0);

function Split(s: string; splitter: Char): TArrayString;
var
 i, p: integer;
 r: TArrayString;
begin
 i:=0;
 while pos(splitter, s)>0 do
  begin
   SetLength(r, Length(r)+1);
   p:=pos(splitter, s);
   r[i]:=copy(s, 1, p-1);
   delete(s, 1, p);
   inc(i);
  end;
 if s<>'' then
  begin
   SetLength(r, Length(r)+1);
   r[i]:=s;
  end;
 Result:=r;
end;

////////////////////////////////////////////////////////////////////////
//TFrmBalloon
constructor TFrmBalloon.Create;
begin
 inherited Create();
 FButtons:=TStringList.Create;
 FOptionButtons:=TStringList.Create;
 FInterval:=10000;
end;

destructor TFrmBalloon.Destroy;
begin
 FButtons.Free;
 FOptionButtons.Free;
 inherited Destroy;
end;

////////////////////////////////////////////////////////////////////////
//TDlgBalloon
constructor TDlgBalloon.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 FButtonPicture:=TPicture.Create;
 FOptionPicture:=TPicture.Create;
 FSuggestPicture:=TPicture.Create;
 FCustomSysIcons:=TPicture.Create;
 FBackgroundImage:=TPicture.Create;
 FCloseButtonImage:=TPicture.Create;
 FIconPicture:=TPicture.Create;
 FLinkMouseIcon:=TPicture.Create;
 FFont:=TFont.Create;
 ImgListButtonPicture:=TImageList.Create(Self);
 ImgListOptionPicture:=TImageList.Create(Self);
 ImgListCloseButtonImage:=TImageList.Create(Self);
 ImgListCustomSys32:=TImageList.Create(Self);
 ImgListCustomSys16:=TImageList.Create(Self);
 ResetProperties;
 FAgentObjectType:=aoAgentControl;
 FTargetScreenRect:=Rect(0,0,0,0);
 TimerClsModelessFrm:=TTimer.Create(Self);
 TimerClsModelessFrm.Enabled:=false;
 TimerClsModelessFrm.OnTimer:=Self.OnBlnClose;
end;


procedure TDlgBalloon.ResetProperties;
begin
 ButtonsCaptions:=DefaultBtnCaption;
 FFont.PixelsPerInch:=96;
 FFont.Color:=clBlack;
 FFont.Name:='MS Sans Serif';
 FFont.Size:=8;
 ForeColor:=clBlack;
 BackColor:=$00CCFFFF;
 LineColor:=$00E0E0E0;
 TextBoxColor:=$00FFFFFF;
 BorderColor:=clBlack;
 MaskColor:=clFuchsia;
 UserMove:=true;
 Style:=bdModal;
 BalloonWidth:=230;
 BalloonDistanceX:=0;
 BalloonDistanceY:=0;
 IconSize:=32;
 IconType:=itDefaultSystem;
 BackgroundImage.Assign(nil);
 SuggestPicture.Assign(nil);
 ShowEffect:=seNone;

 if FFormBalloon<>nil then
  FFormBalloon.Free;
 FFormBalloon:=TFrmBalloon.Create;
 FFormBalloon.ShowIcon:=true;
 FFormBalloon.SepLine:=true;
 FFormBalloon.ShowStyle:=ssModalForm;
 FFormBalloon.TextBoxLines:=2;
 FFormBalloon.TextBoxAction:=taNewLine;

 if FNotifyForm<>nil then
  FNotifyForm.Free;
 FNotifyForm:=TNotifyForm.Create;
 FNotifyForm.ShowIcon:=true;
 FNotifyForm.SepLine:=true;
 FNotifyForm.ShowStyle:=ssModeless;
 FNotifyForm.CloseButton:=true;
 FNotifyForm.TimeOut:=10000;
 FNotifyForm.Orientation:=noUpLeft;
 FNotifyForm.TextBoxLines:=2;
 FNotifyForm.TextBoxAction:=taNewLine;

 FSpeakingAllMsg:=false;
end;


destructor TDlgBalloon.Destroy;
begin
 //Self.HideNotify;
 FButtonPicture.free;
 FOptionPicture.free;
 FSuggestPicture.free;
 FCustomSysIcons.free;
 FBackgroundImage.free;
 FCloseButtonImage.free;
 FIconPicture.free;
 FLinkMouseIcon.free;
 FFont.free;
 ImgListButtonPicture.free;
 ImgListOptionPicture.free;
 ImgListCloseButtonImage.free;
 ImgListCustomSys16.free;
 ImgListCustomSys32.free;
 TimerClsModelessFrm.Enabled:=false;
 TimerClsModelessFrm.free;
 FFormBalloon.Free;
 FNotifyForm.Free;
 Inherited Destroy;
end;

procedure TDlgBalloon.OnLFrmBlnOptionClick(Sender: TObject; Index: Integer; TBoxText: WideString);
begin
 Self.FormBalloon.FOptionPressed:=Index;
 Self.FormBalloon.FButtonPressed:=-1;
 Self.FormBalloon.TextBoxText:=TBoxText;
 if Assigned(Self.OnFrmBlnOptionClick) then
  Self.OnFrmBlnOptionClick(Self, Index, TBoxText);
end;

procedure TDlgBalloon.OnLFrmBlnButtonClick(Sender: TObject; Index: Integer; TBoxText: WideString);
begin
 Self.FormBalloon.FButtonPressed:=Index;
 Self.FormBalloon.FOptionPressed:=-1;
 Self.FormBalloon.TextBoxText:=TBoxText;
 if Assigned(Self.OnFrmBlnButtonClick) then
   Self.OnFrmBlnButtonClick(Self, Index, TBoxText);
end;

procedure TDlgBalloon.OnLFrmBlnTBoxKeyPress(Sender: TObject; ID: Integer; var Key: Char);
begin
 if Assigned(Self.OnFrmBlnTBoxKeyPress) then
  Self.OnFrmBlnTBoxKeyPress(self, ID, Key);
end;

procedure TDlgBalloon.OnLNotiBlnTBoxKeyPress(Sender: TObject; ID: Integer; var Key: Char);
begin
 if Assigned(Self.OnNotiBlnTBoxKeyPress) then
  Self.OnNotiBlnTBoxKeyPress(self, ID, Key);
end;

procedure TDlgBalloon.OnLNotiBlnOptionClick(Sender: TObject; Index: Integer; TBoxText: WideString);
begin
 Self.NotifyForm.FOptionPressed:=Index;
 Self.NotifyForm.FButtonPressed:=-1;
 Self.NotifyForm.TextBoxText:=TBoxText;
 if Assigned(Self.OnNotiBlnOptionClick) then
  Self.OnNotiBlnOptionClick(Self, Index, TBoxText);
end;

procedure TDlgBalloon.OnLNotiBlnButtonClick(Sender: TObject; Index: Integer; TBoxText: WideString);
begin
 Self.NotifyForm.FButtonPressed:=Index;
 Self.NotifyForm.FOptionPressed:=-1;
 Self.NotifyForm.TextBoxText:=TBoxText;
 if Assigned(Self.OnNotiBlnButtonClick) then
  Self.OnNotiBlnButtonClick(Self, Index, TBoxText);
end;

procedure TDlgBalloon.BalloonOn(b: Boolean);
var
 f: integer;
begin
 if b then
  begin
   f:=(FAgentControl.Balloon as IAgentCtlBalloonEx).Style;
   f:=f or 1;
   (FAgentControl.Balloon as IAgentCtlBalloonEx).Style:=f;
  end
 else
  begin
   //отключаем свой баллон
   f:=(FAgentControl.Balloon as IAgentCtlBalloonEx).Style;
   f:=f and $FFFFFFFE;
   (FAgentControl.Balloon as IAgentCtlBalloonEx).Style:=f;
  end;
end;

procedure TDlgBalloon.SetBalloonWidth(Value: Integer);
begin
 if Value >= BLN_WidthArrow*2 then
   Self.FBalloonWidth:=Value;
end;

procedure TDlgBalloon.SetButtonPicture(const Value: TPicture);
var
 b: TBitmap;
 r: TRect;
 h: Integer;
 n, i: byte;
begin
 FButtonPicture.Assign(Value);
 n:=3;
 h:=ButtonPicture.Height div n;
 r:=Rect(0, 0, ButtonPicture.Width, h);
 b:=TBitmap.Create;
 b.Width:=ButtonPicture.Width;
 b.Height:=h;
 ImgListButtonPicture.Width:=b.Width;
 ImgListButtonPicture.Height:=b.Height;
 ImgListButtonPicture.Clear;
 for i:=1 to n do
  begin
   b.Canvas.CopyRect(b.Canvas.ClipRect, ButtonPicture.Bitmap.Canvas, r);
   ImgListButtonPicture.Add(b, nil);
   r.Top:=i*h;
   r.Bottom:=(i+1)*h;
  end;
 b.FreeImage;
 b.Free;
end;

procedure TDlgBalloon.SetOptionPicture(const Value: TPicture);
var
 b: TBitmap;
 r: TRect;
 h: Integer;
 n, i: byte;
begin
 FOptionPicture.Assign(Value);
 n:=4;
 h:=OptionPicture.Height div n;
 r:=Rect(0, 0, OptionPicture.Width, h);
 b:=TBitmap.Create;
 b.Width:=OptionPicture.Width;
 b.Height:=h;
 ImgListOptionPicture.Width:=b.Width;
 ImgListOptionPicture.Height:=b.Height;
 ImgListOptionPicture.Clear;
 for i:=1 to n do
  begin
   b.Canvas.CopyRect(b.Canvas.ClipRect, OptionPicture.Bitmap.Canvas, r);
   ImgListOptionPicture.Add(b, nil);
   r.Top:=i*h;
   r.Bottom:=(i+1)*h;
  end;
 b.FreeImage;
 b.Free;
end;

procedure TDlgBalloon.SetCloseButtonImage(const Value: TPicture);
var
 b: TBitmap;
 r: TRect;
 h: Integer;
 n, i: byte;
begin
 FCloseButtonImage.Assign(Value);
 n:=4;
 h:=CloseButtonImage.Height div n;
 r:=Rect(0, 0, CloseButtonImage.Width, h);
 b:=TBitmap.Create;
 b.Width:=CloseButtonImage.Width;
 b.Height:=h;
 ImgListCloseButtonImage.Width:=b.Width;
 ImgListCloseButtonImage.Height:=b.Height;
 ImgListCloseButtonImage.Clear;
 for i:=1 to n do
  begin
   b.Canvas.CopyRect(b.Canvas.ClipRect, CloseButtonImage.Bitmap.Canvas, r);
   ImgListCloseButtonImage.Add(b, nil);
   r.Top:=i*h;
   r.Bottom:=(i+1)*h;
  end;
 b.FreeImage;
 b.Free;
end;

procedure TDlgBalloon.SetSuggestPicture(const Value: TPicture);
begin
 FSuggestPicture.Assign(Value);
end;

procedure TDlgBalloon.SetBackgroundImage(const Value: TPicture);
begin
 FBackgroundImage.Assign(Value);
end;

procedure TDlgBalloon.SetFont(const Value: TFont);
begin
 FFont.Assign(Value);
end;

procedure TDlgBalloon.SetIconPicture(const Value: TPicture);
begin
 FIconPicture.Assign(Value);
end;

procedure TDlgBalloon.SetCustomSysIcons(const Value: TPicture);
var
 b: TBitmap;
 r: TRect;
 h: Integer;
 n, i: byte;
begin
 FCustomSysIcons.Assign(Value);
 n:=4;
 h:=32;
 r:=Rect(0, 0, h, h);
 b:=TBitmap.Create;
 b.Width:=h;
 b.Height:=h;
 ImgListCustomSys32.Width:=h;
 ImgListCustomSys32.Height:=h;
 ImgListCustomSys32.Clear;
 for i:=1 to n do
  begin
   b.Canvas.CopyRect(b.Canvas.ClipRect, FCustomSysIcons.Bitmap.Canvas, r);
   ImgListCustomSys32.Add(b, nil);
   r.Top:=i*h;
   r.Bottom:=(i+1)*h;
  end;

 h:=16;
 r:=Rect(32, 0, 32+h, h);
 b.Width:=h;
 b.Height:=h;
 ImgListCustomSys16.Width:=h;
 ImgListCustomSys16.Height:=h;
 ImgListCustomSys16.Clear;
 for i:=1 to n do
  begin
   b.Canvas.CopyRect(b.Canvas.ClipRect, FCustomSysIcons.Bitmap.Canvas, r);
   ImgListCustomSys16.Add(b, nil);
   r.Top:=i*h;
   r.Bottom:=(i+1)*h;
  end;
 b.FreeImage;
 b.Free;
end;

procedure TDlgBalloon.SetButtonsCaptions(const Value: WideString);
var
 s: string;
 Old, New: TArrayString;
 i, c: integer;
 im: TMsgDlgBtn;
begin
 s:=DefaultBtnCaption;
 Old:=Split(s, ';');
 New:=Split(Value, ';');
 c:=Min(Length(Old), Length(New));
 for i:=0 to c-1 do
   Old[i]:=New[i];
 i:=0;
 for im:=Low(TMsgDlgBtn) to High(TMsgDlgBtn) do
  begin
   ButtonCaptions[im]:=Old[i];
   inc(i);
  end;
 s:='';
 for i:=0 to Length(Old)-1 do
   s:=s+Old[i];
 FButtonsCaptions:=s;
end;

procedure TDlgBalloon.SetStyle(Value: TBalloonModeStyle);
begin
 FStyle:=Value;
end;

procedure TDlgBalloon.SetLinkMouseIcon(const Value: TPicture);
begin
 LinkMouseIcon.Assign(Value);
end;

procedure TDlgBalloon.SetMoveStyle(Value: TMoveStyleConstants);
begin
 FMoveStyle:=Value;
end;

procedure TDlgBalloon.SetIconSize(const Value: Smallint);
begin
 if Value in [16, 32] then
  FIconSize:=Value;
end;

procedure TDlgBalloon.SetAgentObjectType(const Value: TAgentObjectType);
begin
 if FAgentObjectType <> Value then
  begin
   FAgentObjectType:=Value;
   FAgentControl:=nil;
   FAgentServer:=nil;
  end;
end;

function TDlgBalloon.GetCharacterObject: IUnknown;
begin
  case FAgentObjectType of
   aoAgentControl:
     Result:=FAgentControl;
   aoAgentServer:
     Result:=FAgentServer;
   aoNone:
     Result:=nil;
  end;
end;

procedure TDlgBalloon.SetCharacterObject(const Value: IUnknown);
var
 c: IAgentCtlCharacterEx;
 s: IAgentCharacterEx;
begin
 try
  case FAgentObjectType of
   aoAgentControl:
    begin
     Value.QueryInterface(IID_IAgentCtlCharacterEx, c);
     FAgentControl:=c;
    end;
   aoAgentServer:
    begin
     Value.QueryInterface(IID_IAgentCharacterEx, s);
     FAgentServer:=s;
    end;
   aoNone:
    begin
     FAgentControl:=nil;
     FAgentServer:=nil;
    end;
  end;
 except
  FAgentControl:=nil;
  FAgentServer:=nil;
 end;
end;
//////////////////

procedure TDlgBalloon.OnBlnClose(Sender: TObject);
begin
  if CurrModalessBln<>nil then
   begin
    CurrModalessBln.Close;
    CurrModalessBln.Release;
    CurrModalessBln:=nil;
   end;
  TimerClsModelessFrm.Enabled:=false;
end;

//////////////////

function TDlgBalloon.CreateBlnForm(typeBlb: TBalloonType; aID: Smallint; Title: WideString;
                Prompt: WideString; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons;
                ShowIcon: Boolean; SepLine: Boolean; CloseBtn: Boolean; EditBox: Boolean;
                TextEdit: WideString; CheckBox: Boolean; CheckText: WideString;
                TimeOut: Integer; aArPoint: TPoint; aNotiOrient: TNotifyOrientation): TBalloonForm;
var
 B: TMsgDlgBtn;
 f: TBalloonForm;
 bf: TFrmBalloon;
 bm: TBitmap;
 IconID: PChar;
 ImgListNxN: TImageList;
 BottomHr, CountBtn, GroupBtnWidth, FirstBtnLeft: Integer;
 i: integer;
 ar: TRect;
begin
 f:=TBalloonForm.CreateNew(nil, Self.ShowEffect);
 f.Color:=Self.BackColor;
 f.BorderColor:=Self.BorderColor;
 f.Font:=Self.Font;
 f.Font.Color:=Self.ForeColor;
 f.Width:=Self.BalloonWidth;
 f.Height:=BLN_HORZMARGIN;
 f.CanUserMove:=Self.UserMove;
 f.BackgroundImage:=Self.BackgroundImage;
 f.ShowBgImage:=true;
 f.ImageStretch:=True;
 f.fID:=aID;
 f.BlnType:=typeBlb;
 f.OnBlnClose:=Self.OnBlnClose;
 Self.FVisibleBalloon:=typeBlb;
 BottomHr:=0;

 //Проверяем на FormBalloon и NotifyForm:
 case typeBlb of
   btForm:
    begin
      f.fID:=Self.FormBalloon.ID;
      Title:=Self.FFormBalloon.FTitle;
      Prompt:=Self.FormBalloon.Message;
      DlgType:=Self.FormBalloon.Icon;
      ShowIcon:=Self.FormBalloon.ShowIcon;
      SepLine:=Self.FormBalloon.SepLine;
    end;
   btNotiForm:
    begin
      f.fID:=Self.NotifyForm.ID;
      Title:=Self.NotifyForm.Title;
      Prompt:=Self.NotifyForm.Message;
      DlgType:=Self.NotifyForm.Icon;
      ShowIcon:=Self.NotifyForm.ShowIcon;
      SepLine:=Self.NotifyForm.SepLine;
      CloseBtn:=Self.NotifyForm.CloseButton;
      TimeOut:=Self.NotifyForm.TimeOut;
      if Self.NotifyForm.FocusHWND>0 then
       begin
        GetWindowRect(Self.NotifyForm.FocusHWND, ar);
        aArPoint:=ar.TopLeft;
       end
      else
       begin
        aArPoint:=Self.NotifyForm.ArrowPoint;
       end;
      aNotiOrient:=Self.NotifyForm.Orientation;
    end;
 end;

 if ShowIcon then
  begin
   IconID := IconIDs[DlgType];
   with TBlnImage.Create(f) do
    begin
      Name := 'Image';
      Parent := f;
      if DlgType<>mtCustom then
       begin
         if IconSize=32 then
           ImgListNxN:=ImgListCustomSys32
         else
           ImgListNxN:=ImgListCustomSys16;

         if IconType = itDefaultSystem then
           Picture.Icon.Handle := LoadIcon(0, IconID)
         else if IconType = itCustomSystem then
           begin
             bm:=TBitmap.Create;
             case DlgType of
               mtWarning: ImgListNxN.GetBitmap(2, bm);
               mtError: ImgListNxN.GetBitmap(0, bm);
               mtInformation: ImgListNxN.GetBitmap(3, bm);
               mtConfirmation: ImgListNxN.GetBitmap(1, bm);
             end;
             Picture.Assign(bm);
             Transparent:=true;
             bm.free;
           end;
       end
      else
       begin
        Picture.Assign(IconPicture);
        Transparent:=true;
       end;
      Width:=IconSize;
      Height:=IconSize;
      Stretch:=true;
      SetBounds(BLN_HORZMARGIN, BLN_VERTMARGIN, IconSize, IconSize);
     end;
  end; //if ShowIcon

 if Title<>'' then
  begin
    with TBlnLabel.Create(f) do
     begin
      Name:='Title';
      Parent:=f;
      Transparent:=true;
      AutoSize:=false;
      Font:=f.Font;
      Font.Style:=Font.Style+[fsBold];
      Caption:=Title;
      WordWrap:=true;
      if ShowIcon then
       Left:=BLN_VERTMARGIN*2+IconSize
      else
       Left:=BLN_VERTMARGIN;

      if CloseBtn then //Под кномку Close оставить место
       Width:=f.Width-Left-BLN_HORZMARGIN*2-Self.ImgListCloseButtonImage.Width
      else
       Width:=f.Width-Left-BLN_HORZMARGIN;

      AutoSize:=true;
      if (Height>IconSize) or (not ShowIcon) then
       Top:=BLN_HORZMARGIN
      else
       Top:=BLN_HORZMARGIN+IconSize-Height-(BLN_HORZMARGIN div 2);
      OnClick:=f.OnClick;
      BottomHr:=Top+Height;
     end;
  end;

 with TBlnLabel.Create(f) do
  begin
    Name:='Text';
    Parent:=f;
    Transparent:=true;
    AutoSize:=false;
    Font:=f.Font;
    Caption:=Prompt;
    WordWrap:=true;
    Left:=BLN_VERTMARGIN;
    Width:=f.Width-Left-BLN_HORZMARGIN;
    AutoSize:=true;
    Top:=BottomHr+(BLN_VERTMARGIN div 2);
    OnClick:=f.OnClick;
    BottomHr:=Top+Height;
  end;

 if EditBox then
  begin
   with TEdit.Create(f) do
    begin
     Name:='EditBox';
     Parent:=f;
     Font:=f.Font;
     Text:=TextEdit;
     Ctl3D:=false;
     BorderStyle:=bsSingle;
     Color:=TextBoxColor;
     Left:=BLN_VERTMARGIN;
     Width:=f.Width-Left-BLN_HORZMARGIN;
     Top:=BottomHr+(BLN_VERTMARGIN div 2);
     BottomHr:=Top+Height;
     OnChange:=f.OnEditChange;
     OnKeyPress:=f.OnEditKeyPress;
    end;
  end;

 case typeBlb of
  btForm, btNotiForm:
   begin
     if typeBlb = btNotiForm then
      bf:=Self.NotifyForm as TFrmBalloon
     else
      bf:=Self.FormBalloon;
     if bf.OptionButtons.Count<>0 then
      begin
       for i:=0 to bf.OptionButtons.Count-1 do
        begin
          with TBlnOptionButton.Create(f) do
           begin
            Name := 'Option'+IntToStr(i);
            Parent := f;
            Cursor:=crHandPoint;
            MarginSpacing:=8;
            Caption := bf.OptionButtons.Strings[i];
            Images:=ImgListOptionPicture;
            Top:=BottomHr+(BLN_VERTMARGIN div 2);
            Left:=BLN_HORZMARGIN;
            Width:=f.Width-BLN_HORZMARGIN*2;
            Tag:=i;
            ModalResult:=mrOk;
            Visible:=true;
            OnClick:=f.OnOptionClick;

            Font.Name:=Self.Font.Name;
            Font.Size:=Self.Font.Size;
            Font.Style:=Self.Font.Style;
            Font.Color:=Self.ForeColor;
            Font.Charset:=Self.Font.Charset;
            Font.Height:=Self.Font.Height;
            Font.Pitch:=Self.Font.Pitch;
            Font.PixelsPerInch:=96;

            BottomHr:=Top+Height;
           end; //with
        end;//for
      end;//if bf.opt.. .count<>0

     if bf.TextBox then
      begin
        if bf.TextBoxAction=taClickBtn then
         f.CloseOnPressEnterInTextBox:=true
        else
         f.CloseOnPressEnterInTextBox:=false;
        with TMemo.Create(f) do
         begin
          Name:='TextBox';
          Parent:=f;
          Font:=f.Font;
          Text:=bf.TextBoxText;
          Ctl3D:=false;
          BorderStyle:=bsSingle;
          Color:=TextBoxColor;
          Left:=BLN_VERTMARGIN;
          Width:=f.Width-Left-BLN_HORZMARGIN+1;
          Height:=abs(Self.Font.Size)*bf.TextBoxLines*bf.TextBoxLines;
          Top:=BottomHr+BLN_VERTMARGIN+2;
          BottomHr:=Top+Height;
          OnChange:=f.OnEditChange;
          OnKeyPress:=f.OnEditKeyPress;
          if typeBlb = btNotiForm then
           f.OnNotiBlnTBoxKeyPress:=Self.OnLNotiBlnTBoxKeyPress
          else if typeBlb = btForm then
           f.OnFrmBlnTBoxKeyPress:=Self.OnLFrmBlnTBoxKeyPress;
         end;
      end;
   end;
 end;

 //Ставим линию
 if SepLine then
  begin
   BottomHr:=BottomHr+BLN_VERTMARGIN;
   f.CoordLine.TopLeft:=Point(BLN_HORZMARGIN, BottomHr);
   f.CoordLine.BottomRight:=Point(f.Width-BLN_HORZMARGIN-1, BottomHr);
   f.LineColor:=Self.LineColor;
   f.ShowLine:=true;
  end;

 case typeBlb of
  btSuggest:
   begin
    f.BackgroundImage:=Self.SuggestPicture;
    f.Width:=Self.SuggestPicture.Width;
    f.Height:=Self.SuggestPicture.Height;
    if TimeOut>0 then
     begin
      f.IntervalClose:=TimeOut;
      f.AutoClose:=True;
     end;
    f.CloseOnClick:=true;
    f.OnClick:=f.OnSuggestBtnClick;
    f.OnSuggestClick:=Self.OnSuggestClick;
   end;

  btTip:
   begin
    if CheckBox then
     begin
        with TBlnCheckBox.Create(f) do
         begin
          Name:='CheckBox';
          Parent:=f;
          Font.Name:=Self.Font.Name;
          Font.Size:=Self.Font.Size;
          Font.Style:=Self.Font.Style;
          Font.Color:=Self.ForeColor;
          Font.Charset:=Self.Font.Charset;
          Font.Height:=Self.Font.Height;
          Font.Pitch:=Self.Font.Pitch;
          Font.PixelsPerInch:=96;
          MarginSpacing:=18;
          Caption:=CheckText;
          Left:=BLN_VERTMARGIN;
          Width:=f.Width-Left-BLN_HORZMARGIN;
          Top:=BottomHr+(BLN_VERTMARGIN div 2);
          BottomHr:=Top+Height+BLN_VERTMARGIN;
          OnClick:=f.OnCheckBoxClick;
          Visible:=true;
         end;
     end;

    if Buttons<>[] then
     begin
      with TBlnSpeedButton.Create(f) do
       begin
        Parent := f;
        Name := 'Ok';
        Caption := 'Ok';
        Images:=ImgListButtonPicture;
        Transparent:=true;

        f.Width:=Max(ImgListButtonPicture.Width+BLN_HORZMARGIN*2, f.Width);
        Height:=ImgListButtonPicture.Height;
        Width:=ImgListButtonPicture.Width;
        Top:=BottomHr+BLN_VERTMARGIN;
        Left:=(f.Width div 2) - (Width div 2) - 1;
        Color:=ImgListButtonPicture.BkColor;
        Visible:=true;

        Font.Name:=Self.Font.Name;
        Font.Size:=Self.Font.Size;
        Font.Style:=Self.Font.Style;
        Font.Color:=Self.ForeColor;
        Font.Charset:=Self.Font.Charset;
        Font.Height:=Self.Font.Height;
        Font.Pitch:=Self.Font.Pitch;
        Font.PixelsPerInch:=96;
        OnClick := f.OnTipBtnClick;
       end;
      BottomHr:=BottomHr+ImgListButtonPicture.Height+BLN_VERTMARGIN;
     end;

    if TimeOut>0 then
     begin
      f.IntervalClose:=TimeOut;
      f.AutoClose:=True;
     end;
    if CloseBtn then
     f.CloseOnClick:=false
    else
     f.CloseOnClick:=true;
    f.OnClick:=f.OnTipBtnClick;
    f.OnTipClose:=Self.OnTipClose;
   end;

  btNotify:
   begin
    if TimeOut>0 then
     begin
      f.IntervalClose:=TimeOut;
      f.AutoClose:=True;
     end;
    f.CloseOnClick:=true;
    f.OnClick:=f.OnNotifyBtnClick;
    f.OnNotifyClick:=Self.OnNotifyClick;
   end;

  btForm, btNotiForm:
   begin
     if typeBlb = btNotiForm then
      begin
       if TimeOut>0 then
        begin
         f.IntervalClose:=TimeOut;
         f.AutoClose:=True;
        end;
       f.CloseOnClick:=true;
       f.OnClick:=f.OnNotifyBtnClick;
       f.OnNotifyClick:=Self.OnNotifyClick;
       f.OnNotiBlnOptionClick:=Self.OnLNotiBlnOptionClick;
       f.OnNotiBlnButtonClick:=Self.OnLNotiBlnButtonClick;
      end
     else
      begin
       f.OnFrmBlnOptionClick:=Self.OnLFrmBlnOptionClick;
       f.OnFrmBlnButtonClick:=Self.OnLFrmBlnButtonClick;
      end;

     if bf.Comment<>'' then
      begin
       with TBlnLabel.Create(f) do
        begin
         Name:='Comment';
         Parent:=f;
         Transparent:=true;
         AutoSize:=false;
         Font:=f.Font;
         Caption:=bf.Comment;
         WordWrap:=true;
         Left:=BLN_VERTMARGIN;
         Width:=f.Width-Left-BLN_HORZMARGIN;
         AutoSize:=true;
         Top:=BottomHr+(BLN_VERTMARGIN div 2);
         OnClick:=f.OnClick;
         BottomHr:=Top+Height;
        end;
      end;

     if bf.Buttons.Count<>0 then
      begin
       CountBtn:=bf.Buttons.Count;
       GroupBtnWidth:=CountBtn*ImgListButtonPicture.Width+((CountBtn-1)*BLN_BTNSPACING);
       f.Width:=Max(GroupBtnWidth+BLN_HORZMARGIN*2, f.Width);
       FirstBtnLeft:=(f.Width div 2) - (GroupBtnWidth div 2) - 1;
       for i:=0 to Min(bf.Buttons.Count-1, 4) do
        begin
          with TBlnSpeedButton.Create(f) do
           begin
             Parent := f;
             Name := 'Btn'+IntToStr(i);
             Caption := bf.Buttons.Strings[i];
             ModalResult := mrOk;
             Images:=ImgListButtonPicture;
             Transparent:=true;
             Tag:=i;

             Top:=BottomHr+BLN_VERTMARGIN;
             Left:=FirstBtnLeft;
             Height:=ImgListButtonPicture.Height;
             Width:=ImgListButtonPicture.Width;
             FirstBtnLeft:=FirstBtnLeft+Width+BLN_BTNSPACING;

             Color:=ImgListButtonPicture.BkColor;
             Visible:=true;

             Font.Name:=Self.Font.Name;
             Font.Size:=Self.Font.Size;
             Font.Style:=Self.Font.Style;
             Font.Color:=Self.ForeColor;
             Font.Charset:=Self.Font.Charset;
             Font.Height:=Self.Font.Height;
             Font.Pitch:=Self.Font.Pitch;
             Font.PixelsPerInch:=96;

             OnClick := f.OnButtonClick;
           end;
        end;
       BottomHr:=BottomHr+ImgListButtonPicture.Height+BLN_VERTMARGIN;
      end;
   end;
 end; //case TypeBln

 if (Buttons<>[]) and (not (typeBlb in [btTip, btNotify, btForm, btNotiForm])) then
  begin
   CountBtn:=0;
   for B := Low(TMsgDlgBtn) to High(TMsgDlgBtn) do
    begin
      if B in Buttons then
       inc(CountBtn);
    end;
   GroupBtnWidth:=CountBtn*ImgListButtonPicture.Width+((CountBtn-1)*BLN_BTNSPACING);
   f.Width:=Max(GroupBtnWidth+BLN_HORZMARGIN*2, f.Width);
   FirstBtnLeft:=(f.Width div 2) - (GroupBtnWidth div 2) - 1;

   for B := Low(TMsgDlgBtn) to High(TMsgDlgBtn) do
     if B in Buttons then
       with TBlnSpeedButton.Create(f) do
         begin
           Parent := f;
           Name := ButtonNames[B];
           Caption := ButtonCaptions[B];
           ModalResult := ModalResults[B];
           Images:=ImgListButtonPicture;
           Transparent:=true;

           Top:=BottomHr+BLN_VERTMARGIN;
           Left:=FirstBtnLeft;
           Height:=ImgListButtonPicture.Height;
           Width:=ImgListButtonPicture.Width;
           FirstBtnLeft:=FirstBtnLeft+Width+BLN_BTNSPACING;

           Color:=ImgListButtonPicture.BkColor;
           Visible:=true;

           Font.Name:=Self.Font.Name;
           Font.Size:=Self.Font.Size;
           Font.Style:=Self.Font.Style;
           Font.Color:=Self.ForeColor;
           Font.Charset:=Self.Font.Charset;
           Font.Height:=Self.Font.Height;
           Font.Pitch:=Self.Font.Pitch;
           Font.PixelsPerInch:=96;
           if B = mbHelp then
             OnClick := f.HelpButtonClick;
         end;

   BottomHr:=BottomHr+ImgListButtonPicture.Height+BLN_VERTMARGIN;
  end; //if Buttons<>[] ... then

 if CloseBtn then //Ставим кнопку перед изменением размера формы
  begin
   with TBlnImageButton.Create(f) do
    begin
      Parent:=f;
      Images:=Self.ImgListCloseButtonImage;
      Left:=f.Width-BLN_VERTMARGIN-Width;
      Top:=BLN_VERTMARGIN;
      CloseParentFormOnClick:=true;
      Visible:=true;
    end;
  end;

 //Увиличение размера балона до необходимого.
 if typeBlb<>btSuggest then
  begin
   if not (typeBlb in [btNotify, btNotiForm]) then
    begin
     f.Width:=f.Width+BLN_WidthArrow*2;
     f.Height:=BottomHr+BLN_VERTMARGIN+BLN_WidthArrow;
    end
   else
    begin
     f.Width:=f.Width+BLN_WidthArrow*2;
     f.Height:=BottomHr+BLN_VERTMARGIN+BLN_WidthArrow*2;
    end;
  end;

 if not (typeBlb in [btNotify, btNotiForm]) then //Для Notify указание ориентации ит.д. укзана в самой процедуре
  begin
   if FAgentObjectType = aoNone then
    f.PointingOn(Self.FTargetScreenRect)
   else
    f.AssignToCharacter(FAgentControl, FAgentServer);
  end
 else
  begin
   f.PointingNotify(aArPoint, aNotiOrient);
  end;
 Result:=f;
end;
////////^^^ TCreateBlnForm ^^^///////////

procedure TDlgBalloon.SpeakMsg(Msg: string);
begin
 if FSpeakingAllMsg then
  begin
   FAgentControl.Balloon.Visible:=false;
   BalloonOn(false);
   FAgentControl.Speak('\spd='+intToStr(FSpeed)+'\\pit='+InTToStr(FPitch)+'\'+Msg, '');
  end;
end;

procedure TDlgBalloon.ShowFormBalloon();
var
 f: TBalloonForm;
begin
 f:=CreateBlnForm(btForm, 0, '', '', mtCustom, [],
      false, false, false, false, '', false, '', 0, Point(0,0), noAuto);
 //Self.CurrBln:=@f;
 if Self.FormBalloon.ShowStyle=ssModeless then
  begin
   Self.OnBlnClose(nil); //Закрываем текущий не модальный баллон
   CurrModalessBln:=f;
   if TimerClsModelessFrm.Interval>=250 then
    begin
     TimerClsModelessFrm.Interval:=Self.FormBalloon.Interval;
     TimerClsModelessFrm.Enabled:=true;
    end;
   SpeakMsg(Self.FormBalloon.Message);
   f.Show;
  end
 else
  begin
   SpeakMsg(Self.FormBalloon.Message);
   f.ShowModal;
   f.Release;
  end;
 BalloonOn(true);
end;

procedure TDlgBalloon.ShowNotifyBalloon();
var
 f: TBalloonForm;
 oSize: SmallInt;
begin
 oSize:=Self.IconSize;
 Self.IconSize:=16;
 f:=CreateBlnForm(btNotiForm, 0, '', '', mtCustom, [],
      false, false, false, false, '', false, '', 0, Point(0,0), noAuto);
 //Self.CurrBln:=@f;
 if Self.NotifyForm.ShowStyle=ssModeless then
  begin
   Self.OnBlnClose(nil); //Закрываем текущий не модальный баллон
   CurrModalessBln:=f;
   if TimerClsModelessFrm.Interval>=250 then
    begin
     TimerClsModelessFrm.Interval:=Self.NotifyForm.Interval;
     TimerClsModelessFrm.Enabled:=true;
    end;
   SpeakMsg(NotifyForm.Message);
   f.Show;
   if Self.NotifyForm.FocusHWND>0 then
    begin
     SendMessage(GetParent(Self.NotifyForm.FocusHWND), WM_SetFocus, 0, 0);
     SendMessage(Self.NotifyForm.FocusHWND, WM_SetFocus, 0, 0);
    end
  end
 else
  begin
   SpeakMsg(NotifyForm.Message);
   f.ShowModal;
   f.Release;
  end;
 Self.IconSize:=oSize;
 BalloonOn(true);
end;

procedure TDlgBalloon.ShowMessage(const Title: WideString; const Prompt: WideString);
var
 f: TBalloonForm;
begin
 f:=CreateBlnForm(btMsgDlg, 0, Title, Prompt, mtCustom, [mbOk],
         false, true, false, false, '', false, '', 0, Point(0,0), noAuto);
 SpeakMsg(Prompt);
 f.ShowModal;
 f.Release;
 BalloonOn(true);
end;

function TDlgBalloon.MessageDlg(const Title: WideString; const Prompt: WideString;
  DlgType: TMsgDlgType; Buttons: TMsgDlgButtons): TModalResult;
var
 f: TBalloonForm;
begin
 f:=CreateBlnForm(btMsgDlg, 0, Title, Prompt, DlgType,
     Buttons, true, true, false, false, '', false, '', 0, Point(0,0), noAuto);
 SpeakMsg(Prompt);
 Result:=f.ShowModal;
 f.Release;
 BalloonOn(true);
end;

procedure TDlgBalloon.QuickNotification(const Title: WideString; const Prompt: WideString;
   DlgType: TMsgDlgType; ArrowPoint: TPoint; NotifyOrient: TNotifyOrientation; ShowCloseBtn: Boolean;
   TimeOut: Integer);
var
 fNoti: TBalloonForm;
 OldSize: Smallint;
begin
 HideNotify;
 OldSize:=Self.IconSize;
 Self.IconSize:=16;
 fNoti:=CreateBlnForm(btNotify, 0, Title, Prompt, DlgType,
      [], true, false, ShowCloseBtn, false, '', false, '', TimeOut, ArrowPoint, NotifyOrient);

 //Self.CurrBln:=@fNoti;
 if ShowCloseBtn then
  begin
   SpeakMsg(Prompt);
   fNoti.ShowModal
  end
 else
  begin
   Self.OnBlnClose(nil); //Закрываем текущий не модальный баллон
   CurrModalessBln:=fNoti;
   if TimerClsModelessFrm.Interval>=250 then
    begin
     TimerClsModelessFrm.Interval:=TimeOut;
     TimerClsModelessFrm.Enabled:=true;
    end;
   SpeakMsg(Prompt);
   fNoti.Show;
  end;
 Self.IconSize:=OldSize;
 BalloonOn(true);
end;

procedure TDlgBalloon.QuickNotificationEx(const Title: WideString; const Prompt: WideString;
   DlgType: TMsgDlgType; NotifyOrient: TNotifyOrientation; ShowCloseBtn: Boolean;
   TimeOut: Integer; aFocusHWND: HWND);
var
 ar: TRect;
begin
 GetWindowRect(aFocusHWND, ar);
 Self.QuickNotification(Title, Prompt, DlgType, Point(ar.Left, ar.Top),
        NotifyOrient, ShowCloseBtn, TimeOut);
 SendMessage(GetParent(aFocusHWND), WM_SetFocus, 0, 0);
 SendMessage(aFocusHWND, WM_SetFocus, 0, 0);
end;

function TDlgBalloon.InputBox(const Title: WideString; const Prompt: WideString;
             const Default: WideString): WideString;
var
 inputForm: TBalloonForm;
begin
 inputForm:=CreateBlnForm(btInput, 0, Title, Prompt, mtCustom,
    [mbOk, mbCancel], false, false, false, true, '', false, '', 0, Point(0,0), noAuto);
 SpeakMsg(Prompt);
 if inputForm.ShowModal = mrOk then
  Result:=inputForm.InputBoxResult
 else
  Result:=Default;
 inputForm.Release;
 inputForm:=nil;
 BalloonOn(true);
end;

procedure TDlgBalloon.Suggest(IDSuggest: Smallint; TimeOut: Integer);
var
 f: TBalloonForm;
begin
 if (Self.SuggestPicture.Width <> 0) and (Self.SuggestPicture.Height <> 0) then
  begin
   f:=CreateBlnForm(btSuggest, IDSuggest, '', '', mtCustom,
       [], false, false, false, false, '', false, '', TimeOut, Point(0,0), noAuto);
       
   Self.OnBlnClose(nil); //Закрываем текущий не модальный баллон
   CurrModalessBln:=f;
   if TimerClsModelessFrm.Interval>=250 then
    begin
     TimerClsModelessFrm.Interval:=TimeOut;
     TimerClsModelessFrm.Enabled:=true;
    end;
   f.Show;
  end;
 BalloonOn(true);
end;

procedure TDlgBalloon.TipBalloon(const Tip: WideString; IDTip: Smallint; Button: WordBool;
             const ChkBoxText: WideString; TimeOut: Integer; TipWidth: Smallint);
var
 OldWidth: Integer;
 fTip: TBalloonForm;
begin
 OldWidth:=Self.BalloonWidth;
 Self.BalloonWidth:=TipWidth;

 if Button then
  fTip:=CreateBlnForm(btTip, IDTip, '', Tip, mtCustom,
      [mbOk], false, false, false, false, '', ChkBoxText<>'', ChkBoxText, TimeOut, Point(0,0), noAuto)
 else
  fTip:=CreateBlnForm(btTip, IDTip, '', Tip, mtCustom,
      [], false, false, false, false, '', ChkBoxText<>'', ChkBoxText, TimeOut, Point(0,0), noAuto);
 
 Self.OnBlnClose(nil); //Закрываем текущий не модальный баллон
 CurrModalessBln:=fTip;
 if TimerClsModelessFrm.Interval>=250 then
    begin
     TimerClsModelessFrm.Interval:=TimeOut;
     TimerClsModelessFrm.Enabled:=true;
    end;
 SpeakMsg(Tip);
 fTip.Show;
 Self.BalloonWidth:=OldWidth;
 BalloonOn(true);
end;

procedure TDlgBalloon.About;
begin

end;

procedure TDlgBalloon.RaiseFrmBlnOptionClick(Index: Smallint; const TBoxText: WideString);
begin

end;

procedure TDlgBalloon.RaiseFrmBlnButtonClick(Index: Smallint; const TBoxText: WideString);
begin

end;

procedure TDlgBalloon.RaiseSuggestClick(IDSuggest: Smallint);
begin

end;

procedure TDlgBalloon.RaiseTipClose(IDTip: Smallint; CheckBoxValue: Smallint);
begin

end;

procedure TDlgBalloon.HideBalloonToMove;
begin

end;

procedure TDlgBalloon.MoveBalloonToCharacter;
begin

end;

procedure TDlgBalloon.SetCharacterPosition(CharacterLeft: Smallint; CharacterTop: Smallint;
                  CharacterWidth: Smallint);
begin

end;

procedure TDlgBalloon.SetManualPosition(X: Smallint; Y: Smallint);
begin

end;

procedure TDlgBalloon.HideNotify;
begin
 {if (Self.CurrBln<>nil) then
  begin
   try
    Self.CurrBln^.Close;
    Self.CurrBln^.Release;
    Self.CurrBln:=nil;
   except
   end;
  end;}
end;

procedure TDlgBalloon.HideSuggest;
begin

end;

procedure TDlgBalloon.HideTipBalloon;
begin

end;



end.
