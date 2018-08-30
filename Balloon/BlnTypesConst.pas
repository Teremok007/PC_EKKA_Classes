unit BlnTypesConst;

interface

uses
 Activex;

type
  TBIndiceConstants = TOleEnum;
const
  bdArrowLeft = $00000000;
  bdArrowRight = $00000001;
  bdArrowDownL = $00000002;
  bdArrowDownR = $00000003;

// Constants for enum MsgBalloonResult
type
  TMsgBalloonResult = TOleEnum;
const
  bdOK = $00000001;
  bdCancel = $00000002;
  bdAbort = $00000003;
  bdRetry = $00000004;
  bdIgnore = $00000005;
  bdYes = $00000006;
  bdNo = $00000007;

// Constants for enum BalloonStyle
type
  TBalloonStyle = TOleEnum;
const
  bdOKOnly = $00000000;
  bdOKCancel = $00000001;
  bdAbortRetryIgnore = $00000002;
  bdYesNoCancel = $00000003;
  bdYesNo = $00000004;
  bdRetryCancel = $00000005;
  bdCritical = $00000010;
  bdQuestion = $00000020;
  bdExclamation = $00000030;
  bdInformation = $00000040;
  bdCustom = $00000050;

// Constants for enum BalloonModeStyle
type
  TBalloonModeStyle = TOleEnum;
const
  bdModal = $00000001;
  bdNoFullModal = $00000000;

// Constants for enum ButtonState
type
  TButtonState = TOleEnum;
const
  Flat = $00000000;
  Up = $00000001;
  Down = $00000002;
  Disabled = $00000003;

// Constants for enum TipButtonStyle
type
  TTipButtonStyle = TOleEnum;
const
  bdTipNone = $FFFFFFFF;
  bdTipOKOnly = $00000000;

// Constants for enum MoveStyleConstants
type
  TMoveStyleConstants = TOleEnum;
const
  bdMoveManual = $00000000;
  bdMoveHiding = $00000001;
  bdMoveFollowing = $00000002;

// Constants for enum VisibleBalloon
type
  TVisibleBalloon = TOleEnum;
const
  bdNoneVisible = $00000000;
  bdMsgBalloonVisible = $00000001;
  bdFormBalloonVisible = $00000002;
  bdSuggestVisible = $FFFFFFFF;
  bdTipBalloonVisible = $FFFFFFFE;

// Constants for enum BlnCheckBoxConstants
type
  TBlnCheckBoxConstants = TOleEnum;
const
  bdUnchecked = $00000000;
  bdChecked = $00000001;

// Constants for enum IconConstants
type
  TIconConstants = TOleEnum;
const
  bdNone = $00000000;
  bdIconCritical = $0000000B;
  bdIconQuestion = $0000000C;
  bdIconExclamation = $0000000D;
  bdIconInformation = $0000000E;
  bdIconCustom = $00000050;

// Constants for enum ShowStyleConstants
type
  TShowStyleConstants = TOleEnum;
const
  bdModeless = $00000000;
  bdModalForm = $00000001;

const
  CountDefaultBtn: integer = 11;
  DefaultBtnCaption: string = '&Yes;&No;&Ok;&Cancel;&Abort;&Retry;&Ignore;&All;&NoToAll;&YesToAll;&Help';

type            
  TIconType = (itDefaultSystem, itCustomSystem);
  TShowEffect = (seNone, seFadeIn, seFadeOut, seFadeInOut, seFlashing);
  TShowStyle = (ssModeless, ssModalForm);
  TTextBoxAction = (taClickBtn, taNewLine);
  TAgentObjectType = (aoAgentControl, aoAgentServer, aoNone);
  TBalloonType = (btNone, btTip, btSuggest, btMsgDlg, btInput, btForm, btNotiForm, btNotify);

  //Нужно чтобы указать где располагать NotifyBalloon по отношению к указателю:
  TNotifyOrientation = (noAuto, noDownLeft, noDownRight, noLeftDown, noLeftUp,
        noRightDown, noRightUp, noUpLeft, noUpRight);

  TBalloonOnFrmBlnOptionClick = procedure(Sender: TObject; Index: Integer;
                                                           TBoxText: WideString) of object;
  TBalloonOnFrmBlnButtonClick = procedure(Sender: TObject; Index: Integer;
                                                           TBoxText: WideString) of object;
  TBalloonOnFrmBlnTBoxKeyPress = procedure(Sender: TObject; ID: Integer;
                                                           var Key: Char) of object;
  TBalloonOnNotiBlnTBoxKeyPress = procedure(Sender: TObject; ID: Integer;
                                                           var Key: Char) of object;
  TBalloonOnNotiBlnOptionClick = procedure(Sender: TObject; Index: Integer;
                                                           TBoxText: WideString) of object;
  TBalloonOnNotiBlnButtonClick = procedure(Sender: TObject; Index: Integer;
                                                           TBoxText: WideString) of object;
  TBalloonOnSuggestClick = procedure(Sender: TObject; var IDSuggest: Integer) of object;
  TBalloonOnTipClose = procedure(Sender: TObject; var IDTip: Integer; var CheckBoxValue: Boolean) of object;
  TBalloonOnNotifyClick = procedure(Sender: TObject; var IDNotify: Integer) of object;

  TBlnClose = procedure(Sender: TObject) of object;

{const
  LowBln: set of TBalloonType = (btTip, btSuggest, btNotify, btNotiForm);
  HighBln: set of TBalloonType = (btMsgDlg, btInput, btForm);
}
implementation

end.
