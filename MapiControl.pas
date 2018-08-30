unit MapiControl;

 interface

 uses
 Windows, Messages, SysUtils, Classes, Graphics, Controls,
 Forms, Dialogs;

 type
 { Вводим новый тип события для получения Errorcode }
 TMapiErrEvent = procedure(Sender:TObject; ErrCode: Integer) of object;

 TMapiControl = class(TComponent)
  constructor Create(AOwner:TComponent); override;
  destructor Destroy; override;
  private
  { Private-объявления }
  FSubject: string;
  FMailtext: string;
  FFromName: string;
  FFromAdress: string;
  FTOAdr: TStrings; 
  FCCAdr: TStrings; 
  FBCCAdr: TStrings; 
  FAttachedFileName: TStrings; 
  FDisplayFileName: TStrings; 
  FShowDialog: Boolean; 
  FUseAppHandle: Boolean; 
  { Error Events: } 
  FOnUserAbort: TNotifyEvent; 
  FOnMapiError: TMapiErrEvent; 
  FOnSuccess: TNotifyEvent; 
  { +> Изменения, внесённые Eugene Mayevski [mailto:Mayevski@eldos.org]} 
  procedure SetToAddr(newValue : TStrings);
  procedure SetCCAddr(newValue : TStrings);
  procedure SetBCCAddr(newValue : TStrings);
  procedure SetAttachedFileName(newValue : TStrings);
  { +< конец изменений }
 protected
  { Protected-объявления }
 public
  { Public-объявления }
  ApplicationHandle: THandle;
  procedure Sendmail();
  procedure Reset();
 published
  { Published-объявления }
  property Subject: string read FSubject write FSubject;
  property Body: string read FMailText write FMailText;
  property FromName: string read FFromName write FFromName;
  property FromAdress: string read FFromAdress write FFromAdress;
  property Recipients: TStrings read FTOAdr write SetTOAddr;
  property CopyTo: TStrings read FCCAdr write SetCCAddr;
  property BlindCopyTo: TStrings read FBCCAdr write SetBCCAddr;
  property AttachedFiles: TStrings read FAttachedFileName write SetAttachedFileName;
  property DisplayFileName: TStrings read FDisplayFileName;
  property ShowDialog: Boolean read FShowDialog write FShowDialog;
  property UseAppHandle: Boolean read FUseAppHandle write FUseAppHandle;

  { события: }
  property OnUserAbort: TNotifyEvent read FOnUserAbort write FOnUserAbort;
  property OnMapiError: TMapiErrEvent read FOnMapiError write FOnMapiError;
  property OnSuccess: TNotifyEvent read FOnSuccess write FOnSuccess;
 end;

// procedure register;

 implementation

 uses Mapi;

 { регистрируем компонент: }
{ procedure register;
 begin
 RegisterComponents('expectIT', [TMapiControl]);
 end;
}
 { TMapiControl } 
 
 constructor TMapiControl.Create(AOwner: TComponent); 
 begin 
 inherited Create(AOwner); 
 FOnUserAbort := nil; 
 FOnMapiError := nil; 
 FOnSuccess := nil; 
 FSubject := ''; 
 FMailtext := ''; 
 FFromName := ''; 
 FFromAdress := ''; 
 FTOAdr := TStringList.Create; 
 FCCAdr := TStringList.Create; 
 FBCCAdr := TStringList.Create; 
 FAttachedFileName := TStringList.Create; 
 FDisplayFileName := TStringList.Create; 
 FShowDialog := False; 
 ApplicationHandle := Application.Handle; 
 end; 
 
 { +> Изменения, внесённые Eugene Mayevski [mailto:Mayevski@eldos.org]} 
 procedure TMapiControl.SetToAddr(newValue : TStrings); 
 begin 
 FToAdr.Assign(newValue); 
 end; 
 
 procedure TMapiControl.SetCCAddr(newValue : TStrings); 
 begin 
 FCCAdr.Assign(newValue); 
 end; 
 
 procedure TMapiControl.SetBCCAddr(newValue : TStrings); 
 begin 
 FBCCAdr.Assign(newValue); 
 end; 
 
 procedure TMapiControl.SetAttachedFileName(newValue : TStrings); 
 begin 
 FAttachedFileName.Assign(newValue); 
 end; 
 { +< конец изменений } 
 
 destructor TMapiControl.Destroy; 
 begin 
 FTOAdr.Free; 
 FCCAdr.Free; 
 FBCCAdr.Free; 
 FAttachedFileName.Free; 
 FDisplayFileName.Free; 
 inherited destroy; 
 end; 
 
 { Сбрасываем все используемые поля} 
 procedure TMapiControl.Reset; 
 begin 
 FSubject := ''; 
 FMailtext := ''; 
 FFromName := ''; 
 FFromAdress := ''; 
 FTOAdr.Clear; 
 FCCAdr.Clear; 
 FBCCAdr.Clear; 
 FAttachedFileName.Clear; 
 FDisplayFileName.Clear; 
 end; 
 
 { Эта процедура составляет и отправляет Email } 
 procedure TMapiControl.Sendmail; 
 var 
 MapiMessage: TMapiMessage; 
 MError: Cardinal; 
 Sender: TMapiRecipDesc; 
 PRecip, Recipients: PMapiRecipDesc; 
 PFiles, Attachments: PMapiFileDesc; 
 i: Integer; 
 AppHandle: THandle; 
 begin 
 { Перво-наперво сохраняем Handle приложения, if not 
 the Component might fail to send the Email or 
 your calling Program gets locked up. } 
 AppHandle := Application.Handle; 
 
 { Нам нужно зарезервировать память для всех получателей } 
 MapiMessage.nRecipCount := FTOAdr.Count + FCCAdr.Count + FBCCAdr.Count; 
 GetMem(Recipients, MapiMessage.nRecipCount * sizeof(TMapiRecipDesc)); 
 
 try 
  with MapiMessage do 
  begin 
  ulReserved := 0; 
  { Устанавливаем поле Subject: } 
  lpszSubject := PChar(Self.FSubject); 
 
  { ... Body: } 
  lpszNoteText := PChar(FMailText); 
 
  lpszMessageType := nil; 
  lpszDateReceived := nil; 
  lpszConversationID := nil; 
  flFlags := 0; 
 
  { и отправителя: (MAPI_ORIG) } 
  Sender.ulReserved := 0; 
  Sender.ulRecipClass := MAPI_ORIG; 
  Sender.lpszName := PChar(FromName); 
  Sender.lpszAddress := PChar(FromAdress); 
  Sender.ulEIDSize := 0; 
  Sender.lpEntryID := nil; 
  lpOriginator := @Sender; 
 
  PRecip := Recipients; 
 
  { У нас много получателей письма: (MAPI_TO) 
  установим для каждого: } 
  if nRecipCount > 0 then 
  begin 
  for i := 1 to FTOAdr.Count do 
  begin 
   PRecip^.ulReserved := 0; 
   PRecip^.ulRecipClass := MAPI_TO; 
   { lpszName should carry the Name like in the 
   contacts or the adress book, I will take the 
   email adress to keep it short: } 
   PRecip^.lpszName := PChar(FTOAdr.Strings[i - 1]); 
   { Если Вы используете этот компонент совместно с Outlook97 или 2000 
   (не Express версии) , то Вам прийдётся добавить 
   'SMTP:' в начало каждого (email-) адреса. 
   } 
   PRecip^.lpszAddress := PChar('SMTP:' + FTOAdr.Strings[i - 1]); 
   PRecip^.ulEIDSize := 0; 
   PRecip^.lpEntryID := nil; 
   Inc(PRecip); 
  end; 
 
  { То же самое проделываем с получателями копии письма: (CC, MAPI_CC) } 
  for i := 1 to FCCAdr.Count do 
  begin 
   PRecip^.ulReserved := 0; 
   PRecip^.ulRecipClass := MAPI_CC; 
   PRecip^.lpszName := PChar(FCCAdr.Strings[i - 1]); 
   PRecip^.lpszAddress := PChar('SMTP:' + FCCAdr.Strings[i - 1]); 
   PRecip^.ulEIDSize := 0; 
   PRecip^.lpEntryID := nil; 
   Inc(PRecip); 
  end; 
 
  { ... тоже самое для Bcc: (BCC, MAPI_BCC) } 
  for i := 1 to FBCCAdr.Count do 
  begin 
   PRecip^.ulReserved := 0; 
   PRecip^.ulRecipClass := MAPI_BCC; 
   PRecip^.lpszName := PChar(FBCCAdr.Strings[i - 1]); 
   PRecip^.lpszAddress := PChar('SMTP:' + FBCCAdr.Strings[i - 1]); 
   PRecip^.ulEIDSize := 0; 
   PRecip^.lpEntryID := nil; 
   Inc(PRecip); 
  end; 
  end; 
  lpRecips := Recipients; 
 
  { Теперь обработаем прикреплённые к письму файлы: } 
 
  if FAttachedFileName.Count > 0 then 
  begin 
  nFileCount := FAttachedFileName.Count; 
  GetMem(Attachments, MapiMessage.nFileCount * sizeof(TMapiFileDesc)); 
 
  PFiles := Attachments; 
 
  { Во первых установим отображаемые на экране имена файлов (без пути): } 
  FDisplayFileName.Clear; 
  for i := 0 to FAttachedFileName.Count - 1 do 
   FDisplayFileName.Add(ExtractFileName(FAttachedFileName[i])); 
 
  if nFileCount > 0 then 
  begin 
   { Теперь составим структурку для прикреплённого файла: } 
   for i := 1 to FAttachedFileName.Count do 
   begin 
   { Устанавливаем полный путь } 
   Attachments^.lpszPathName := PChar(FAttachedFileName.Strings[i - 1]); 
   { ... и имя, отображаемое на дисплее: } 
   Attachments^.lpszFileName := PChar(FDisplayFileName.Strings[i - 1]); 
   Attachments^.ulReserved := 0; 
   Attachments^.flFlags := 0; 
   { Положение должно быть -1, за разьяснениями обращайтесь в WinApi Help. } 
   Attachments^.nPosition := Cardinal(-1); 
   Attachments^.lpFileType := nil; 
   Inc(Attachments); 
   end; 
  end; 
  lpFiles := PFiles; 
  end 
  else 
  begin 
  nFileCount := 0; 
  lpFiles := nil; 
  end; 
  end; 
 
  { 
  Send the Mail, silent or verbose: 
  Verbose means in Express a Mail is composed and shown as setup. 
  In non-Express versions we show the Login-Dialog for a new 
  session and after we have choosen the profile to use, the 
  composed email is shown before sending 
 
  Silent does currently not work for non-Express version. We have 
  no Session, no Login Dialog so the system refuses to compose a 
  new email. In Express Versions the email is sent in the 
  background. 
  } 
  if FShowDialog then 
  MError := MapiSendMail(0, AppHandle, MapiMessage, MAPI_DIALOG 
  or MAPI_LOGON_UI or MAPI_NEW_SESSION, 0) 
  else 
  MError := MapiSendMail(0, AppHandle, MapiMessage, 0, 0); 
 
  { 
  Теперь обработаем сообщения об ошибках. В MAPI их присутствует достаточное. 
  количество. В этом примере я обрабатываю только два из них: USER_ABORT и SUCCESS, 
  относящиеся к специальным. 
 
  Сообщения, не относящиеся к специальным: 
  MAPI_E_AMBIGUOUS_RECIPIENT, 
  MAPI_E_ATTACHMENT_NOT_FOUND, 
  MAPI_E_ATTACHMENT_OPEN_FAILURE, 
  MAPI_E_BAD_RECIPTYPE, 
  MAPI_E_FAILURE, 
  MAPI_E_INSUFFICIENT_MEMORY, 
  MAPI_E_LOGIN_FAILURE, 
  MAPI_E_TEXT_TOO_LARGE, 
  MAPI_E_TOO_MANY_FILES, 
  MAPI_E_TOO_MANY_RECIPIENTS, 
  MAPI_E_UNKNOWN_RECIPIENT: 
  } 
 
  case MError of 
  MAPI_E_USER_ABORT: 
  begin 
  if Assigned(FOnUserAbort) then 
   FOnUserAbort(Self); 
  end; 
  SUCCESS_SUCCESS: 
  begin 
  if Assigned(FOnSuccess) then 
   FOnSuccess(Self); 
  end 
  else 
  begin 
  if Assigned(FOnMapiError) then 
   FOnMapiError(Self, MError); 
  end; 
  end; 
 finally 
  { В заключение освобождаем память } 
  FreeMem(Recipients, MapiMessage.nRecipCount * sizeof(TMapiRecipDesc)); 
 end; 
 end; 
 { Вопросы и замечания присылайте Автору. } 
 end. 
 