
{------------------------------------------------------------------------------}
{******************************************************************************}
{***                                                                        ***}
{*** ДЛЯ ВСЕХ ЗАПРОСОВ К ЭККА ПРОВЕРЯТЬ ДОСТУПНОСТЬ АППАРАТА!!!             ***}
{*** (!!!нужно доделать!!!)                                                 ***}
{***                                                                        ***}
{******************************************************************************}
{------------------------------------------------------------------------------}

unit MicroHelpN707;

interface

uses
  ComObj, Controls, Classes, SysUtils, uJSON, DateUtils, AxCtrls, StdCtrls, ActiveX, ZLib;
// , Dialogs, Math;

type
  T_Error = record
    e: string;                //код ошибки или текст ошибки с параметрами
    line: integer;            //номер строки чека с ошибкой
  end;

type
  T_cgi_state = record
    ErrorCode: string;        //код ошибки, по умолчанию (ошибок нету) - пустая строка
    ErrorDescription: string; //описание ошибки, по умолчанию (ошибок нету) - пустая строка
    model: string;            //"model":"MG-P777TL"
    name: string;             //"name":"GP00000049"
    serial: string;           //"serial":"GP00000049"
    _time: TDateTime;         //"time":1498466474
    chkId: LongInt;            //"chkId":0; номер последнего фискального чека               /cgi/state/chkId
    JrnTime: TDateTime;       //"JrnTime":0
    currZ: LongInt;            //"currZ":0; номер последнего Z-отчета                       /cgi/state/currZ
    IsWrk: byte;              //"IsWrk":0
    Fiscalization: byte;      //"Fiscalization":0
    FskMode: byte;            //"FskMode":1; возможность печати чека. должно быть 1          /cgi/state/FskMode
    CurrDI: LongInt;          //"CurrDI":1
    ID_SAM: LongInt;          //"ID_SAM":0
    ID_DEV: LongInt;          //"ID_DEV":411123233
    NPrLin: LongInt;          //"NPrLin":1724
    Err: array of T_Error;             //"err":[]
  end;

type
  T_cgi_status = record
    dev_state: string; //"dev_state":57
    tm: Longint; //"tm":1498480806
    tmo: Longint; //"tmo":900
    ct: Longint; //"ct":0
    bt: Longint; //"bt":0
    ndoc: Longint; //"ndoc":0
    pers_sam_id: string; //"pers_sam_id":"-"
    pers_time: string; //"pers_time":"-"
    card_no: string; //"card_no":"ff0000100753"
    sam_id: Longint; //"sam_id":1050451
    sam_dev_id: Longint; //"sam_dev_id":411123233
    eq_id: string; //"eq_id":"272400"
  end;

type
  T_cgi_dev_info = record
    dev_zn: string;           //заводской номер                                 /cgi/dev_info/dev_zn
    dev_ver: string;          //версия прошивки EKKA                            /cgi/dev_info/dev_ver
    dev_dat: string;          //дата прошивка EKKA                              /cgi/dev_info/dev_dat
    dev_fn: string;           //Фискальный номер                                /cgi/dev_info/dev_fn
    dev_id: Int64;          //"dev_id":411123233
    dev_nn: string;           //"dev_nn":"ПН"
    prot: byte;               //"prot":1
  end;

type
  T_C = record
    cm: string;
  end;
type
  T_BC = record
    code: string;
    _type: integer;
    width: integer;
    height: integer;
    feed: integer;
  end;
type
  T_S = record
    code: Longint;
    name: string;
    qty: Double;
    price: Double;
    sum: Currency;
    dep: integer;
    grp: integer;
    tax: integer;
  end;
type
  T_D = record
    sum: Currency;
    prc: Double;
    subt: Double;
    tax: Integer;
  end;
type
  T_P = record
    no: integer;
    name: string;
    sum: Currency;
    rrn: Longint;
    card: string;
  end;
type
  T_L = record                //регистрация кассира, массив
  end;
type
  T_F = record                //строки фискального чека, массив
    BC: T_BC;                 //штрих-код
    S: T_S;                   //продажа
    D: T_D;                   //скидка
    P: T_P;                   //оплата
    C: T_C;
  end;
type
  T_R = record                //строки возвратного чека, массив
    BC: T_BC;                 //штрих-код
    S: T_S;                   //продажа
    D: T_D;                   //скидка
    P: T_P;                   //оплата
    C: T_C;
  end;
type
  T_IO = record               //строки чека служебного движения
    no: Longint;              //номер строки в таблице Pay
    name: string;
    sum: Currency;            //сумма внесения или изъятия
    C: T_C;                   //фискальный комментарий
    BC: T_BC;                 //штрих-код
  end;
type
  T_cgi_chk_object = record
    L: array of T_L;          //регистрация кассира, массив
    Z1: Longint;              //номер дневного отчета
    F: array of T_F;          //строки фискального чека, массив
    R: array of T_R;          //строки возвратного чека, массив
    IO: array of T_IO;        //строки чека служебного движения
    datetime: TDateTime;      //дата и время объекта в ленте. unixtime GMT-0
    id: Longint;              //уникальный идентификатор объекта в чековой ленте
    oper_id: Integer;         //номер оператора, связанный с объектом ленты
    no: Longint;              //для объектов L, F, R, IO - номер чека
    Pending: string;          //для объектов L, F, R, IO - признак того, что чек еще не напечатан. поле может отсутствовать. если отсутствует - чек напечатан
    DI: Longint;              //для объектов L, F, R, IO - номер документа в системе онлайн отчетности ДПА
    beg_id: LongInt;          //
    chk_type: integer;        //тип чека: 1 - фискальный; 2 - возвратный; 3 - служебное внесение/изъятие
  end;
type
  T_cgi_chk = record
    ErrorCode: string;        //код ошибки, по умолчанию (ошибок нету) - пустая строка
    ErrorDescription: string; //описание ошибки, по умолчанию (ошибок нету) - пустая строка
    max_check_no: Longint;    //номер последнего чека в ленте
    cgi_chk_object: array of T_cgi_chk_object; //объекты чековой ленты
  end;

type
  T_cgi_tbl_Time = record
    dt: TDate;
    tm: TTime;
  end;

type
  T_cgi_proc_getjrnroom = record
    Total: Longint;
    Used: Longint;
    Err: array of T_Error;
  end;

type
  TStatusN707 = record
    IsError: boolean;         //состояние EKKA: false - все нормально, можно работать (по умолчанию); true - какие-то проблемы с EKKA
                              //зависит от состояния ответов HTTP /cgi/status; /cgi/state; /cgi/dev_info и параметра /cgi/dev_info/dev_state
    ErrorCode: string;        //код ошибки EKKA, по умолчанию - пусто, IsError = false.
    ErrorDescription: string; //описание ошибки EKKA, по умолчанию - пусто, IsError = false.
    HTTPCode: integer;        //ответ HTTP. По умолчанию 200 - все в порядке, IsError = false.
    HTTPDescription: string;  //ответ HTTP. По умолчанию OK - все в порядке, IsError = false.
    dev_state: string;        //битовая маска статуса аппарата:                 /cgi/status/dev_state
                              // бит     значение
                              // 1       0 - модуль SAM не обнаружен; 1 - модуль SAM обнаружен;
                              // 2       0 - модуль SAM сопряжен с устройством; 1 - модуль SAM не сопряжен с устройством;
                              // 3       0 - персонализация отсутствует; 1 - персонализация присутствует
                              // 4       0 - система персонализирована; 1 - ошибка персонализации
                              // 5       0 - хранилище документов разрушено; 1 - хранилище документов исправно
                              // 6       0 - нет сетевого соединения; 1 - сетевое соединение установлено
                              // 7       0 - модем функционирует нормально; 1 - ошибка модема
    dev_zn: string;           //заводской номер                                 /cgi/dev_info/dev_zn
    dev_fn: string;           //Фискальный номер                                /cgi/dev_info/dev_fn
    dev_id: Int64;          //"dev_id":411123233
    //Наименование и адрес предприятия
    dt: TDate;                //Дата EKKA                                       /cgi/tbl/Time
    tm: TTime;                //Время EKKA                                      /cgi/tbl/Time
    //признак зарегистрированого кассира
    Used: integer;            //признак выполнения Z-отчета                     /cgi/proc/getjrnroom
    currZ: string;            //номер последнего Z-отчета                       /cgi/state/currZ
    chkId: string;            //номер последнего фискального чека               /cgi/state/chkId
    dev_ver: string;          //версия прошивки EKKA                            /cgi/dev_info/dev_ver
    dev_dat: string;           //дата прошивка EKKA                             /cgi/dev_info/dev_dat
  end;

type
  TChkNomber = record
    ChkNumber: integer;
    ErrCode: string;
    ErrMessage: string;
  end;
  
const
  PROTOCOL = 'http://';
  METHOD_HEAD = 'HEAD';
  METHOD_GET = 'GET';
  METHOD_POST = 'POST';

  URI_CGI_STATUS = '/cgi/status';
  URI_CGI_DEV_INFO = '/cgi/dev_info';
  URI_CGI_STATE = '/cgi/state';
  URI_CGI_CHK = '/cgi/chk';
  URI_DESC = '/desc';

  URI_CGI_TBL_TIME = '/cgi/tbl/Time';

  URI_CGI_PROC_GETJRNROOM = '/cgi/proc/getjrnroom';
  URI_CGI_PROC_PRINTREPORT = '/cgi/proc/printreport';
  URI_CGI_PROC_SETCLOCK = '/cgi/proc/setclock';
  URI_CGI_PROC_SOUND = '/cgi/proc/sound';

  PRINTREPORT_Z_REPORT = 0;
  PRINTREPORT_X_REPORT = 10;

  USERNAME_SERVICE = 'service';
  PASS_SERVICE = '751426';

  BAD_REQUEST_ERROR_CODE_400 = 400;
  BAD_REQUEST_ERROR_RESPONSE_400 = 'Сервер обнаружил в запросе клиента синтаксическую ошибку';
  UNAUTHORIZED_ERROR_CODE_401 = 401;
  UNAUTHORIZED_ERROR_RESPONSE_401 = 'Для доступа к запрашиваемому ресурсу требуется аутентификация';
  NOT_IMPLEMENTED_ERROR_CODE_404 = 404;
  NOT_IMPLEMENTED_ERROR_RESPONSE_404 = 'Сервер понял запрос, но не нашёл соответствующего ресурса по указанному URL';
  PROXY_AUTHENTICATION_REQUIRED_ERROR_CODE_407 = 407;
  PROXY_AUTHENTICATION_REQUIRED_ERROR_RESPONSE_407 = 'Для доступа к запрашиваемому ресурсу требуется аутентификация';
  REQUEST_TIMEOUT_ERROR_CODE_408 = 408;
  REQUEST_TIMEOUT_ERROR_RESPONSE_408 = 'Время ожидания сервером передачи от клиента истекло';
  GONE_ERROR_CODE_410 = 410;
  GONE_ERROR_RESPONSE_410 = 'Ресурс раньше был по указанному URL, но был удалён и теперь недоступен';
  INTERNAL_SERVER_ERROR_CODE_500 = 500;
  INTERNAL_SERVER_ERROR_RESPONSE_500 = 'Внутренняя ошибка сервера';
  NOT_IMPLEMENTED_ERROR_CODE_501 = 501;
  NOT_IMPLEMENTED_ERROR_RESPONSE_501 = 'Сервер не поддерживает возможностей, необходимых для обработки запроса';
  BAD_GATEWAY_ERROR_CODE_502 = 502;
  BAD_GATEWAY_ERROR_RESPONSE_502 = 'Сервер, выступая в роли шлюза или прокси-сервера, получил недействительное ответное сообщение от вышестоящего сервера';
  SERVICE_UNAVAILABLE_ERROR_CODE_503 = 503;
  SERVICE_UNAVAILABLE_ERROR_RESPONSE_503 = 'Сервер временно не имеет возможности обрабатывать запросы по техническим причинам';
  GATEWAY_TIMEOUT_ERROR_CODE_504 = 504;
  GATEWAY_TIMEOUT_ERROR_RESPONSE_504 = 'Сервер в роли шлюза или прокси-сервера не дождался ответа от вышестоящего сервера для завершения текущего запроса';
  TIMEOUT_ERROR_CODE_520 = 520;
  TIMEOUT_ERROR_RESPONSE_520 = 'За требуемое время от сервера не был получен ожидаемый ответ';

  DEV_STATE_ERROR_CODE_UNKNOWN = '1';
  DEV_STATE_ERROR_DESCRIPTION_UNKNOWN = 'Не могу прочитать статус EKKA';
  DEV_STATE_ERROR_CODE_CANNOT_PRINT_CHECK = '2';
  DEV_STATE_ERROR_DESCRIPTION_CANNOT_PRINT_CHECK = 'Не могу напечатать чек';
  DEV_STATE_ERROR_CODE_CANNOT_SET_CLOCK = '3';
  DEV_STATE_ERROR_DESCRIPTION_CANNOT_SET_CLOCK = 'Не могу установить дату и время';
  DEV_STATE_ERROR_CODE_CANNOT_INPUT_OUTPUT_CASH = '4';
  DEV_STATE_ERROR_DESCRIPTION_CANNOT_INPUT_OUTPUT_CASH = 'Не могу произвести служебное внесение/изъятие';
  EMPTY_RECEIPT_LINE_CODE = '5';
  EMPTY_RECEIPT_LINE_DESCRIPTION = 'Чековая лента пустая';
  DEV_NO_SOUND_HEARD_CODE = '6';
  DEV_NO_SOUND_HEARD_DESCRIPTION = 'Звук не был воспроизведен';

  IS_FISCAL_RECEIPT = 1;
  IS_RETURN_REPEIPT = 2;
  IS_INPUTOUTPUT_RECEIPT = 3;

  MAX_RECEIPT_NUMBER = 32768;

var
  StatusN707: TStatusN707;
  cgi_status: T_cgi_status;
  cgi_dev_info: T_cgi_dev_info;
  cgi_state: T_cgi_state;
  cgi_tbl_Time: T_cgi_tbl_Time;
  cgi_proc_getjrnroom: T_cgi_proc_getjrnroom;
  cgi_chk: T_cgi_chk;
  Req: OleVariant;
  Content_Length: Longint;
  Content_Type: string;
  Content_Encoding: string;
  Cache_Control: string;
  ChkNomber: TChkNomber;
  _Error: array of T_Error;

//function GetStatusN707: TStatusN707;    //получение статуса EKKA
function GetStatusN707(IPAddr: string): TStatusN707; //получение статуса EKKA
//function GetLastChkNo(const IsFiscal:boolean = true): TChkNomber;      //получение номера последнего чека в чековой ленте
function GetLastChkNo(pIPAddr: string; const IsFiscal: boolean = true): TChkNomber;      //получение номера последнего чека в чековой ленте
//function PrintCheck(const txt: string; out ErrorCode, ErrorDescription: string; out ResponsedReceipt: T_cgi_chk_object): boolean;         //печать чека
function PrintCheck(const txt: string; out ErrorCode, ErrorDescription: string; out ResponsedReceipt: T_cgi_chk_object; pIPAddr: string): boolean;         //печать чека
//function PrintZerroCheck(out ErrorCode, ErrorDescription: string; out ResponsedReceipt: T_cgi_chk_object): boolean;      //печать нулевого чека
function PrintZerroCheck(out ErrorCode, ErrorDescription: string; out ResponsedReceipt: T_cgi_chk_object; pIPAddr: string): boolean;      //печать нулевого чека
//function PrintZXReport(const ReportNom: integer; out ErrorCode, ErrorDescription: string; out ReceiptList: T_cgi_chk; const flFiscal: boolean = true): boolean;        //печать отчетов Z и X
function PrintZXReport(pIPAddr: string; const ReportNom: integer; out ErrorCode, ErrorDescription: string; out ReceiptList: T_cgi_chk; const flFiscal: boolean = true): boolean;        //печать отчетов Z и X
//function SetClock(const _dt: TDateTime; out ErrorCode, ErrorDescription: string): boolean; //установка даты и времени на устройстве
function SetClock(const _dt: TDateTime; out ErrorCode, ErrorDescription: string; pIPAddr: string): boolean; //установка даты и времени на устройстве
//function CashInputOutput(const Sum: Double; out ErrorCode, ErrorDescription: string; out ResponsedReceipt: T_cgi_chk_object): boolean; //служебное внесение / изъятие
function CashInputOutput(const Sum: Double; out ErrorCode, ErrorDescription: string; out ResponsedReceipt: T_cgi_chk_object; pIPAddr: string): boolean; //служебное внесение / изъятие
//function Sound(const Hz, Ms: Integer; out ErrorCode, ErrorDescription: string):boolean; //воспроизведение звука аппаратом
function Sound(const Hz, Ms: Integer; out ErrorCode, ErrorDescription: string; pIPAddr: string):boolean; //воспроизведение звука аппаратом
//function GetCashState(out CshStt: string; out ErrorCode, ErrorDescription: string): boolean; //состояние наличности в кассе
function GetCashState(out CshStt: string; out ErrorCode, ErrorDescription: string; pIPAddr: string): boolean; //состояние наличности в кассе
//function GetFiscalState(out FscStt: string; out ErrorCode, ErrorDescription: string): boolean; //состояние наличности в кассе с учетом налоговых ставок
function GetFiscalState(out FscStt: string; out ErrorCode, ErrorDescription: string; pIPAddr: string): boolean; //состояние наличности в кассе с учетом налоговых ставок

implementation

(*----------------------------------------------------------------------------*)
(*--- парсеры ответов от аппарата                                          ---*)
(*----------------------------------------------------------------------------*)

procedure HTTPResponseParser(StatusCode: integer; StatusText: string; out ErrCode, ErrMessage: string);
begin
  ErrCode:='';
  ErrMessage:='';
  case StatusCode of
    100..199:
      begin
        ErrCode:=IntToStr(StatusCode);
        ErrMessage:=StatusText;
      end;
    300..399:
      begin
        ErrCode:=IntToStr(StatusCode);
        ErrMessage:=StatusText;
      end;
    400:
      begin
        ErrCode:=IntToStr(BAD_REQUEST_ERROR_CODE_400);
        ErrMessage:=BAD_REQUEST_ERROR_RESPONSE_400;
      end;
    401:
      begin
        ErrCode:=IntToStr(UNAUTHORIZED_ERROR_CODE_401);
        ErrMessage:=UNAUTHORIZED_ERROR_RESPONSE_401;
      end;
    402,403:
      begin
        ErrCode:=IntToStr(StatusCode);
        ErrMessage:=StatusText;
      end;
    404:
      begin
        ErrCode:=IntToStr(NOT_IMPLEMENTED_ERROR_CODE_404);
        ErrMessage:=NOT_IMPLEMENTED_ERROR_RESPONSE_404;
      end;
    405,406:
      begin
        ErrCode:=IntToStr(StatusCode);
        ErrMessage:=StatusText;
      end;
    407:
      begin
        ErrCode:=IntToStr(PROXY_AUTHENTICATION_REQUIRED_ERROR_CODE_407);
        ErrMessage:=PROXY_AUTHENTICATION_REQUIRED_ERROR_RESPONSE_407;
      end;
    408:
      begin
        ErrCode:=IntToStr(REQUEST_TIMEOUT_ERROR_CODE_408);
        ErrMessage:=REQUEST_TIMEOUT_ERROR_RESPONSE_408;
      end;
    409:
      begin
        ErrCode:=IntToStr(StatusCode);
        ErrMessage:=StatusText;
      end;
    410:
      begin
        ErrCode:=IntToStr(GONE_ERROR_CODE_410);
        ErrMessage:=GONE_ERROR_RESPONSE_410;
      end;
    411..499:
      begin
        ErrCode:=IntToStr(StatusCode);
        ErrMessage:=StatusText;
      end;
    500:
      begin
        ErrCode:=IntToStr(INTERNAL_SERVER_ERROR_CODE_500);
        ErrMessage:=INTERNAL_SERVER_ERROR_RESPONSE_500;
      end;
    501:
      begin
        ErrCode:=IntToStr(NOT_IMPLEMENTED_ERROR_CODE_501);
        ErrMessage:=NOT_IMPLEMENTED_ERROR_RESPONSE_501;
      end;
    502:
      begin
        ErrCode:=IntToStr(BAD_GATEWAY_ERROR_CODE_502);
        ErrMessage:=BAD_GATEWAY_ERROR_RESPONSE_502;
      end;
    503:
      begin
        ErrCode:=IntToStr(SERVICE_UNAVAILABLE_ERROR_CODE_503);
        ErrMessage:=SERVICE_UNAVAILABLE_ERROR_RESPONSE_503;
      end;
    504:
      begin
        ErrCode:=IntToStr(GATEWAY_TIMEOUT_ERROR_CODE_504);
        ErrMessage:=GATEWAY_TIMEOUT_ERROR_RESPONSE_504;
      end;
    505..519:
      begin
        ErrCode:=IntToStr(StatusCode);
        ErrMessage:=StatusText;
      end;
    520:
      begin
        ErrCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
        ErrMessage:=TIMEOUT_ERROR_RESPONSE_520;
      end;
    521..599:
      begin
        ErrCode:=IntToStr(StatusCode);
        ErrMessage:=StatusText;
      end;
  end;
end;

procedure ParseDscResponseHeaders(const hdrs: string);
var
  sl: TStringList;
  i: integer;
  cl: string;
begin
  Content_Encoding:='';
  Content_Length:=0;
  Content_Type:='';
  Cache_Control:='';
  try
    sl:=TStringList.Create;
    sl.Text:=trim(hdrs);
    if length(trim(hdrs)) > 0 then
    begin
      for i:=0 to sl.Count-1 do
      begin
        if pos('content-encoding:',LowerCase(sl.Strings[i])) > 0 then
        begin
          Content_Encoding:=sl.Strings[i];
          delete(Content_Encoding,1,length('content-encoding:'));
          Content_Encoding:=trim(Content_Encoding);
        end;

        if pos('content-length:',LowerCase(sl.Strings[i])) > 0 then
        begin
          cl:=sl.Strings[i];
          Delete(cl,1,length('accept-ranges:')+1);
          cl:=trim(cl);
          try
            Content_Length:=StrToInt(cl);
          except
            Content_Length:=0;
          end;
        end;

        if pos('content-type:',LowerCase(sl.Strings[i])) > 0 then
        begin
          Content_Type:=sl.Strings[i];
          delete(Content_Type,1,length('content-type:'));
          Content_Type:=trim(Content_Type);
        end;

        if pos('cache-control:',LowerCase(sl.Strings[i])) > 0 then
        begin
          Cache_Control:=sl.Strings[i];
          delete(Cache_Control,1,length('cache-control:'));
          Cache_Control:=trim(Cache_Control);
        end;
      end;
    end;
  finally
    sl.Free;
  end;
end;

function ParseStateRequest(const js: string; out ErrorCode, ErrorDescription: string): boolean;
var
  json: TJSONObject;
  jsa: TJSONArray;
  jso: TJSONObject;
  i: integer;
begin
  ErrorCode:='';
  ErrorDescription:='';
  with cgi_state do
  begin
    ErrorCode:='';
    ErrorDescription:='';
    model:='';
    name:='';
    serial:='';
    _time:=0;
    chkId:=0;
    JrnTime:=0;
    currZ:=0;
    IsWrk:=0;
    Fiscalization:=0;
    FskMode:=0;
    CurrDI:=0;
    ID_SAM:=0;
    ID_DEV:=0;
    NPrLin:=0;
    Err:=nil;
  end;
  Result:=false; //ошибок нету

  try
    json:=TJSONObject.create(js);
    if json.has('model') then cgi_state.model:=json.getString('model');
    if json.has('name') then cgi_state.name:=json.getString('name');
    if json.has('serial') then cgi_state.serial:=json.getString('serial');
    if json.has('time') then cgi_state._time:=UnixToDateTime(json.getInt('time'));
    if json.has('chkId') then cgi_state.chkId:=json.getInt('chkId');
    if json.has('JrnTime') then cgi_state.JrnTime:=UnixToDateTime(json.getInt('JrnTime'));
    if json.has('currZ') then cgi_state.currZ:=json.getInt('currZ');
    if json.has('IsWrk') then cgi_state.IsWrk:=json.getInt('IsWrk');
    if json.has('Fiscalization') then cgi_state.Fiscalization:=json.getInt('Fiscalization');
    if json.has('FskMode') then cgi_state.FskMode:=json.getInt('FskMode');
    if json.has('CurrDI') then cgi_state.CurrDI:=json.getInt('CurrDI');
    if json.has('ID_SAM') then cgi_state.ID_SAM:=json.getInt('ID_SAM');
    if json.has('ID_DEV') then cgi_state.ID_DEV:=json.getInt('ID_DEV');
    if json.has('NPrLin') then cgi_state.NPrLin:=json.getInt('NPrLin');
    if json.has('Err') then
    begin
      try
        jsa:=TJSONArray.create(json.getString('err'));
        if jsa.length > 0 then
        begin
          SetLength(cgi_state.Err,jsa.length);
          for i:=0 to jsa.length-1 do
          begin
            try
              jso:=TJSONObject.create(jsa.getString(i));
              if jso.has('e') then cgi_state.Err[i].e:=jso.getString('e');
            finally
              jso.Free;
            end;
          end;
        end;
      finally
        jsa.destroy;
      end;
    end;
  finally
    json.destroy;
  end;

  if (cgi_state.FskMode <> 1)and(length(cgi_state.Err)>0) then
  begin
    for i:=0 to Length(cgi_state.Err)-1 do
      cgi_state.ErrorCode:=cgi_state.ErrorCode+cgi_state.Err[i].e+' ';
      ErrorCode:=cgi_state.ErrorCode;
    Result:=true;
    exit;
  end
  else
  begin
    if (cgi_state.FskMode <> 1)and(length(cgi_state.Err)=0) then
    begin
      ErrorCode:=DEV_STATE_ERROR_CODE_CANNOT_PRINT_CHECK;
      ErrorDescription:=DEV_STATE_ERROR_DESCRIPTION_CANNOT_PRINT_CHECK;
      Result:=true;
    end
    else
    begin
      if (cgi_state.FskMode = 1)and(length(cgi_state.Err)>0) then
      begin
        for i:=0 to Length(cgi_state.Err)-1 do
          cgi_state.ErrorCode:=cgi_state.ErrorCode+cgi_state.Err[i].e+' ';
        ErrorCode:=cgi_state.ErrorCode;
        Result:=false;
      end;
    end;
  end;
end;

function ParseStatusRequest(out status: T_cgi_status; const js: string): boolean;
var
  json: TJSONObject;
begin
{
  T_cgi_status = record
    dev_state: string; //"dev_state":57
    tm: Longint; //"tm":1498480806
    tmo: Longint; //"tmo":900
    ct: Longint; //"ct":0
    bt: Longint; //"bt":0
    ndoc: Longint; //"ndoc":0
    pers_sam_id: string; //"pers_sam_id":"-"
    pers_time: string; //"pers_time":"-"
    card_no: string; //"card_no":"ff0000100753"
    sam_id: Longint; //"sam_id":1050451
    sam_dev_id: Longint; //"sam_dev_id":411123233
    eq_id: string; //"eq_id":"272400"
  end;
}
//{"dev_state":57,"tm":1498480806,"tmo":900,"ct":0,"bt":0,"ndoc":0,"pers_sam_id":"-","pers_time":"-","card_no":"ff0000100753","sam_id":1050451,"sam_dev_id":411123233,"eq_id":"272400"}
  Result:=false;
  with cgi_status do
  begin
    dev_state:='';
    tm:=0;
    tmo:=0;
    ct:=0;
    bt:=0;
    ndoc:=0;
    pers_sam_id:='';
    pers_time:='';
    card_no:='';
    sam_id:=0;
    sam_dev_id:=0;
    eq_id:='';
  end;

  try
    json:=TJSONObject.create(js);
    if json.has('dev_state') then status.dev_state:=json.getString('dev_state');
    if json.has('tm') then status.tm:=json.getInt('tm');
    if json.has('tmo') then status.tmo:=json.getInt('tmo');
    if json.has('ct') then status.ct:=json.getInt('ct');
    if json.has('bt') then status.bt:=json.getInt('bt');
    if json.has('ndoc') then status.ndoc:=json.getInt('ndoc');
    if json.has('pers_sam_id') then status.pers_sam_id:=json.getString('pers_sam_id');
    if json.has('pers_time') then status.pers_time:=json.getString('pers_time');
    if json.has('card_no') then status.card_no:=json.getString('card_no');
    if json.has('sam_id') then status.sam_id:=json.getInt('sam_id');
    if json.has('sam_dev_id') then status.sam_dev_id:=json.getInt('sam_dev_id');
    if json.has('eq_id') then status.eq_id:=json.getString('eq_id');
//    if json.has('dev_state') then cgi_status.dev_state:=json.getString('dev_state') else cgi_status.dev_state:=''; //битовая маска статуса аппарата:
//        // бит     значение
//        // 1       0 - модуль SAM не обнаружен; 1 - модуль SAM обнаружен;
//        // 2       0 - модуль SAM сопряжен с устройством; 1 - модуль SAM не сопряжен с устройством;
//        // 3       0 - персонализация отсутствует; 1 - персонализация присутствует
//        // 4       0 - система персонализирована; 1 - ошибка персонализации
//        // 5       0 - хранилище документов разрушено; 1 - хранилище документов исправно
//        // 6       0 - нет сетевого соединения; 1 - сетевое соединение установлено
//        //      57 = 0111001
  finally
    json.destroy;
  end;
end;

function ParseDeviceInfoRequest(const js: string): boolean;
var
  json: TJSONObject;
begin
  cgi_dev_info.dev_zn:='';
  cgi_dev_info.dev_ver:='';
  cgi_dev_info.dev_dat:='';
  cgi_dev_info.dev_fn:='';
  cgi_dev_info.dev_nn:='';
  cgi_dev_info.dev_id:=-1;
  cgi_dev_info.prot:=0;
{
  T_cgi_dev_info = record
    dev_zn: string;           //заводской номер                                 /cgi/dev_info/dev_zn
    dev_ver: string;          //версия прошивки EKKA                            /cgi/dev_info/dev_ver
    dev_dat: string;          //дата прошивка EKKA                              /cgi/dev_info/dev_dat
    dev_fn: string;           //Фискальный номер                                /cgi/dev_info/dev_fn
    dev_id: Longint;          //"dev_id":411123233
    dev_nn: string;           //"dev_nn":"ПН"
    prot: byte;               //"prot":1
  end;
}
  try
    json:=TJSONObject.create(js);
    if json.has('dev_zn') then cgi_dev_info.dev_zn:=json.getString('dev_zn');
    if json.has('dev_ver') then cgi_dev_info.dev_ver:=json.getString('dev_ver');
    if json.has('dev_dat') then cgi_dev_info.dev_dat:=json.getString('dev_dat');
    if json.has('dev_fn') then cgi_dev_info.dev_fn:=json.getString('dev_fn');
    if json.has('dev_nn') then cgi_dev_info.dev_nn:=json.getString('dev_nn');
    if json.has('dev_id') then cgi_dev_info.dev_id:=json.getInt('dev_id');
    if json.has('prot') then cgi_dev_info.prot:=json.getInt('prot');
  finally
    json.destroy;
  end;
end;


function ParseProcGetJrnRoom(const js: string; out ErrCode: string; out ErrDescr: string): boolean;
var
  json: TJSONObject;
begin
  cgi_proc_getjrnroom.Total:=0;
  cgi_proc_getjrnroom.Used:=0;
  cgi_proc_getjrnroom.Err:=nil;
  ErrCode:='';
  ErrDescr:='';
  Result:=false; //ошибок нету

  try
    json:=TJSONObject.create(js);
    if json.has('err') then
    begin
      SetLength(cgi_proc_getjrnroom.Err,1);
      cgi_proc_getjrnroom.Err[0].e:=json.getString('err');
      ErrCode:=cgi_proc_getjrnroom.Err[0].e;
      Result:=true;
      exit;
    end
    else
    begin
      if json.has('total') then cgi_proc_getjrnroom.Total:=json.getInt('total');
      if json.has('used') then cgi_proc_getjrnroom.Used:=json.getInt('used');
    end;
  finally
    json.destroy;
  end;
end;

function ParsePrintCheckRequest(const js: string; out chk: T_cgi_chk_object): boolean;
var
  json: TJSONObject;
  ErrorString: string;
  jsa: TJSONArray;
  jso, jso1: TJSONObject;
  i: integer;
  IsArray: boolean;
  chk_obj: T_cgi_chk_object;
  IsF, IsR, IsIO: boolean;
begin
  Result:=false;
  _Error:=nil;
  IsArray:=false;
  ErrorString:='';
  chk_obj.L:=nil;
  chk_obj.Z1:=0;
  chk_obj.F:=nil;
  chk_obj.R:=nil;
  chk_obj.IO:=nil;
  chk_obj.datetime:=0;
  chk_obj.id:=0;
  chk_obj.oper_id:=0;
  chk_obj.no:=0;
  chk_obj.Pending:='';
  chk_obj.DI:=0;
  chk_obj.beg_id:=0;
  chk_obj.chk_type:=0;
  IsF:=false; IsR:=false; IsIO:=false;

  try
    json:=TJSONObject.create(js);
    if json.has('err') then
      ErrorString:=json.getString('err');
    if (length(trim(ErrorString))>0)and(ErrorString[1]='[') then IsArray:=true;
    if IsArray then
    begin
      try
        jsa:=TJSONArray.create(ErrorString);
        SetLength(_Error,jsa.length);
        for i:=0 to jsa.length-1 do
        begin
          try
            jso:=TJSONObject.create(jsa.getString(i));
            if jso.has('e') then _Error[i].e:=jso.getString('e');
            if jso.has('line') then _Error[i].line:=jso.getInt('line');
          finally
            jso.destroy;
          end;
        end;
      finally
        jsa.destroy;
      end;
    end
    else
    begin
      if length(trim(ErrorString))>0 then
        try
          jso:=TJSONObject.create(ErrorString);
          SetLength(_Error,1);
          if jso.has('e') then _Error[0].e:=jso.getString('e');
          if jso.has('line') then _Error[0].line:=jso.getInt('line');
        finally
          jso.destroy;
        end;
    end;

    if Length(_Error) > 0 then Result:=true else
    begin
      //распаршивание JSON-ответа от ЭККА после удачной печати чека
      Result:=false;
      if json.has('id') then chk_obj.id:=json.getInt('id');
      if json.has('no') then chk_obj.no:=json.getInt('no');
      if json.has('beg_id') then chk_obj.beg_id:=json.getInt('beg_id');
      if json.has('oper_id') then chk_obj.oper_id:=json.getInt('oper_id');
      if json.has('datetime') then chk_obj.datetime:=UnixToDateTime(json.getInt('datetime'));
      if json.has('DI') then chk_obj.DI:=json.getInt('DI');
      if json.has('pending') then chk_obj.Pending:=json.getString('pending');
      if json.has('Z1') then chk_obj.Z1:=json.getInt('Z1');
      if json.has('F') then IsF:=true else
        if json.has('R') then IsR:=true else
          if json.has('IO') then IsIO:=true;
      try
        if IsF then //фискальный чек
        begin
          chk_obj.chk_type:=IS_FISCAL_RECEIPT;
          jsa:=TJSONArray.create(json.getString('F'));
          if jsa.length > 0 then
          begin
            SetLength(chk_obj.F,jsa.length);
            for i:=0 to jsa.length-1 do
            begin
              try
                jso:=TJSONObject.create(jsa.getString(i));
                if jso.has('S') then
                begin
                  try
                    jso1:=TJSONObject.create(jso.getString('S'));
                    if jso1.has('code') then chk_obj.F[i].S.code:=jso1.getInt('code');
                    if jso1.has('name') then chk_obj.F[i].S.name:=jso1.getString('name');
                    if jso1.has('qty') then chk_obj.F[i].S.qty:=jso1.getDouble('qty');
                    if jso1.has('price') then chk_obj.F[i].S.price:=jso1.getDouble('price');
                    if jso1.has('sum') then chk_obj.F[i].S.sum:=jso1.getDouble('sum');
                    if jso1.has('dep') then chk_obj.F[i].S.dep:=jso1.getInt('dep');
                    if jso1.has('grp') then chk_obj.F[i].S.grp:=jso1.getInt('grp');
                    if jso1.has('tax') then chk_obj.F[i].S.tax:=jso1.getInt('tax');
                  finally
                    jso1.destroy;
                  end;
                end;
                if jso.has('D') then
                begin
                  try
                    jso1:=TJSONObject.create(jso.getString('D'));
                    if jso1.has('sum') then chk_obj.F[i].D.sum:=jso1.getDouble('sum');
                    if jso1.has('prc') then chk_obj.F[i].D.prc:=jso1.getDouble('prc');
                    if jso1.has('subt') then chk_obj.F[i].D.subt:=jso1.getDouble('subt');
                    if jso1.has('tax') then chk_obj.F[i].D.tax:=jso1.getInt('tax');
                  finally
                    jso1.destroy;
                  end;
                end;
                if jso.has('P') then
                begin
                  try
                    jso1:=TJSONObject.create(jso.getString('P'));
                    if jso1.has('no') then chk_obj.F[i].P.no:=jso1.getInt('no');
                    if jso1.has('name') then chk_obj.F[i].P.name:=jso1.getString('name');
                    if jso1.has('sum') then chk_obj.F[i].P.sum:=jso1.getDouble('sum');
                    if jso1.has('rrn') then chk_obj.F[i].P.rrn:=jso1.getInt('rrn');
                    if jso1.has('card') then chk_obj.F[i].P.card:=jso1.getString('card');
                  finally
                    jso1.destroy;
                  end;
                end;
                if jso.has('C') then
                begin
                  try
                    jso1:=TJSONObject.create(jso.getString('C'));
                    if jso1.has('cm') then chk_obj.F[i].C.cm:=jso1.getString('cm');
                  finally
                    jso1.destroy;
                  end;
                end;
                if jso.has('BC') then
                begin
                  try
                    jso1:=TJSONObject.create(jso.getString('BC'));
                    if jso1.has('code') then chk_obj.F[i].BC.code:=jso1.getString('code');
                    if jso1.has('type') then chk_obj.F[i].BC._type:=jso1.getInt('type');
                    if jso1.has('width') then chk_obj.F[i].BC.width:=jso1.getInt('width');
                    if jso1.has('height') then chk_obj.F[i].BC.height:=jso1.getInt('height');
                    if jso1.has('feed') then chk_obj.F[i].BC.feed:=jso1.getInt('feed');
                  finally
                    jso1.destroy;
                  end;
                end;
              finally
                jso.destroy;
              end;
            end;
          end;
        end //end фискальный чек
        else
          if IsR then //возвратный чек
          begin
            chk_obj.chk_type:=IS_RETURN_REPEIPT;
            jsa:=TJSONArray.create(json.getString('R'));
            if jsa.length>0 then
            begin
              SetLength(chk_obj.R,jsa.length);
              for i:=0 to jsa.length-1 do
              begin
                try
                  jso:=TJSONObject.create(jsa.getString(i));
                  if jso.has('S') then
                  begin
                    try
                      jso1:=TJSONObject.create(jso.getString('S'));
                      if jso1.has('code') then chk_obj.R[i].S.code:=jso1.getInt('code');
                      if jso1.has('name') then chk_obj.R[i].S.name:=jso1.getString('name');
                      if jso1.has('qty') then chk_obj.R[i].S.qty:=jso1.getDouble('qty');
                      if jso1.has('price') then chk_obj.R[i].S.price:=jso1.getDouble('price');
                      if jso1.has('sum') then chk_obj.R[i].S.sum:=jso1.getDouble('sum');
                      if jso1.has('dep') then chk_obj.R[i].S.dep:=jso1.getInt('dep');
                      if jso1.has('grp') then chk_obj.R[i].S.grp:=jso1.getInt('grp');
                      if jso1.has('tax') then chk_obj.R[i].S.tax:=jso1.getInt('tax');
                    finally
                      jso1.destroy;
                    end;
                  end;
                  if jso.has('D') then
                  begin
                    try
                      jso1:=TJSONObject.create(jso.getString('D'));
                      if jso1.has('sum') then chk_obj.R[i].D.sum:=jso1.getDouble('sum');
                      if jso1.has('prc') then chk_obj.R[i].D.prc:=jso1.getDouble('prc');
                      if jso1.has('subt') then chk_obj.R[i].D.subt:=jso1.getDouble('subt');
                      if jso1.has('tax') then chk_obj.R[i].D.tax:=jso1.getInt('tax');
                    finally
                      jso1.destroy;
                    end;
                  end;
                  if jso.has('P') then
                  begin
                    try
                      jso1:=TJSONObject.create(jso.getString('P'));
                      if jso1.has('no') then chk_obj.R[i].P.no:=jso1.getInt('no');
                      if jso1.has('name') then chk_obj.R[i].P.name:=jso1.getString('name');
                      if jso1.has('sum') then chk_obj.R[i].P.sum:=jso1.getDouble('sum');
                      if jso1.has('rrn') then chk_obj.R[i].P.rrn:=jso1.getInt('rrn');
                      if jso1.has('card') then chk_obj.R[i].P.card:=jso1.getString('card');
                    finally
                      jso1.destroy;
                    end;
                  end;
                  if jso.has('C') then
                  begin
                    try
                      jso1:=TJSONObject.create(jso.getString('C'));
                      if jso1.has('cm') then chk_obj.R[i].C.cm:=jso1.getString('cm');
                    finally
                      jso1.destroy;
                    end;
                  end;
                  if jso.has('BC') then
                  begin
                    try
                      jso1:=TJSONObject.create(jso.getString('BC'));
                      if jso1.has('code') then chk_obj.R[i].BC.code:=jso1.getString('code');
                      if jso1.has('type') then chk_obj.R[i].BC._type:=jso1.getInt('_type');
                      if jso1.has('width') then chk_obj.R[i].BC.width:=jso1.getInt('width');
                      if jso1.has('height') then chk_obj.R[i].BC.height:=jso1.getInt('height');
                      if jso1.has('feed') then chk_obj.R[i].BC.feed:=jso1.getInt('feed');
                    finally
                      jso1.destroy;
                    end;
                  end;
                finally
                  jso.destroy;
                end;
              end;
            end;
            //R:[S,D,P,C,BC]
          end //end возвратный чек
          else
            if IsIO then //служебное внесение/изъятие
            begin
              chk_obj.chk_type:=IS_INPUTOUTPUT_RECEIPT;
              jsa:=TJSONArray.create(json.getString('IO'));
              if jsa.length>0 then
              begin
                SetLength(chk_obj.IO,jsa.length);
                for i:=0 to jsa.length-1 do
                begin
                  try
                    jso:=TJSONObject.create(jsa.getString(i));
                    if jso.has('no') then chk_obj.IO[i].no:=jso.getInt('no');
                    if jso.has('name') then chk_obj.IO[i].name:=jso.getString('name');
                    if jso.has('sum') then chk_obj.IO[i].sum:=jso.getDouble('sum');
                    if jso.has('C') then
                    begin
                      try
                        jso1:=TJSONObject.create(jso.getString('C'));
                        if jso1.has('cm') then chk_obj.IO[i].C.cm:=jso1.getString('cm');
                      finally
                        jso1.destroy;
                      end;
                    end;
                    if jso.has('BC') then
                    begin
                      try
                        jso1:=TJSONObject.create(jso.getString('BC'));
                        if jso1.has('code') then chk_obj.IO[i].BC.code:=jso1.getString('code');
                        if jso1.has('type') then chk_obj.IO[i].BC._type:=jso1.getInt('type');
                        if jso1.has('width') then chk_obj.IO[i].BC.width:=jso1.getInt('width');
                        if jso1.has('height') then chk_obj.IO[i].BC.height:=jso1.getInt('height');
                        if jso1.has('feed') then chk_obj.IO[i].BC.feed:=jso1.getInt('feed');
                      finally
                        jso1.destroy;
                      end;
                    end;
                  finally
                    jso.destroy;
                  end;
                end;
              end;
            end //end служебное внесение/изъятие
            else
            begin
              jsa:=TJSONArray.create;
            end;
      finally
        jsa.destroy;
      end;
    end;
  finally
    json.destroy;
  end;
end;

function ParsePrintZXReport(const js: string): boolean;
var
  json: TJSONObject;
  jsa: TJSONArray;
  jso: TJSONObject;
  i: integer;
  ErrorString: string;
  IsArray: boolean;
begin
  Result:=false;
  _Error:=nil;
  ErrorString:='';
  IsArray:=false;

  try
    json:=TJSONObject.create(js);
    if json.has('err') then ErrorString:=json.getString('err');
    if (length(trim(ErrorString))>0)and(ErrorString[1]='[') then IsArray:=true;
    if IsArray then
    begin
      try
        jsa:=TJSONArray.create(ErrorString);
        SetLength(_Error,jsa.length);
        for i:=0 to jsa.length-1 do
        begin
          try
            jso:=TJSONObject.create(jsa.getString(i));
            if jso.has('e') then _Error[i].e:=jso.getString('e');
          finally
            jso.destroy;
          end;
        end;
      finally
        jsa.destroy;
      end;
    end
    else
    begin
      if length(trim(ErrorString))>0 then
        if ErrorString[1]='{' then
        begin
          try
            jso:=TJSONObject.create(ErrorString);
            SetLength(_Error,1);
            if jso.has('e') then _Error[0].e:=jso.getString('e');
          finally
            jso.destroy;
          end;
        end
        else
        begin
          SetLength(_Error,1);
          _Error[0].e:=ErrorString;
        end;
    end;

    if Length(_Error) > 0 then Result:=true;
  finally
    json.destroy;
  end;
end;

function ParseSetClock(const js: string): boolean;
var
  json: TJSONObject;
  jsa: TJSONArray;
  jso: TJSONObject;
  i: integer;
  ErrorString: string;
  IsArray: boolean;
begin
  Result:=false;
  _Error:=nil;
  ErrorString:='';
  IsArray:=false;

  try
    json:=TJSONObject.create(js);
    if json.has('err') then ErrorString:=json.getString('err');
    if (length(trim(ErrorString))>0)and(ErrorString[1]='[') then IsArray:=true;
    if IsArray then
    begin
      try
        jsa:=TJSONArray.create(ErrorString);
        SetLength(_Error,jsa.length);
        for i:=0 to jsa.length-1 do
        begin
          try
            jso:=TJSONObject.create(jsa.getString(i));
            if jso.has('e') then _Error[i].e:=jso.getString('e');
            if jso.has('line') then _Error[i].line:=jso.getInt('line');
          finally
            jso.destroy;
          end;
        end;
      finally
        jsa.destroy;
      end;
    end
    else
    begin
      if length(trim(ErrorString))>0 then
        if ErrorString[1]='{' then
        begin
          try
            jso:=TJSONObject.create(ErrorString);
            SetLength(_Error,1);
            if jso.has('e') then _Error[0].e:=jso.getString('e');
          finally
            jso.destroy;
          end;
        end
        else
        begin
          SetLength(_Error,1);
          _Error[0].e:=ErrorString;
        end;
    end;

    if Length(_Error) > 0 then Result:=true;
  finally
    json.destroy;
  end;
end;

function ParseSoundRequest(const js: string): boolean;
var
  json: TJSONObject;
  jsa: TJSONArray;
  jso: TJSONObject;
  i: integer;
  ErrorString: string;
  IsArray: boolean;
begin
  Result:=false;
  _Error:=nil;
  ErrorString:='';
  IsArray:=false;

  try
    json:=TJSONObject.create(js);
    if json.has('err') then ErrorString:=json.getString('err');
    if (length(trim(ErrorString))>0)and(ErrorString[1]='[') then IsArray:=true;
    if IsArray then
    begin
      try
        jsa:=TJSONArray.create(ErrorString);
        SetLength(_Error,jsa.length);
        for i:=0 to jsa.length-1 do
        begin
          try
            jso:=TJSONObject.create(jsa.getString(i));
            if jso.has('e') then _Error[i].e:=jso.getString('e');
            if jso.has('line') then _Error[i].line:=jso.getInt('line');
          finally
            jso.destroy;
          end;
        end;
      finally
        jsa.destroy;
      end;
    end
    else
    begin
      if length(trim(ErrorString))>0 then
        if ErrorString[1]='{' then
        begin
          try
            jso:=TJSONObject.create(ErrorString);
            SetLength(_Error,1);
            if jso.has('e') then _Error[0].e:=jso.getString('e');
          finally
            jso.destroy;
          end;
        end
        else
        begin
          SetLength(_Error,1);
          _Error[0].e:=ErrorString;
        end;
    end;

    if Length(_Error) > 0 then Result:=true;
  finally
    json.destroy;
  end;
end;

function ParseCheckListRequest(const js: string; const flFiscal: boolean = true): boolean;
var
  json: TJSONObject;
  jsa, jsa1: TJSONArray;
  jso, jso1, jso2: TJSONObject;
  i, j: integer;
begin
  cgi_chk.ErrorCode:='';        //код ошибки, по умолчанию (ошибок нету) - пустая строка
  cgi_chk.ErrorDescription:=''; //описание ошибки, по умолчанию (ошибок нету) - пустая строка
  cgi_chk.max_check_no:=-1;     //номер последнего чека в ленте
  cgi_chk.cgi_chk_object:=nil;
  Result:=false; //ошибок нету

  if js[1]='[' then
  begin
    try
      jsa:=TJSONArray.create(js);
      if jsa.length>0 then
      begin
        SetLength(cgi_chk.cgi_chk_object,jsa.length);
        for i:=0 to jsa.length-1 do
        begin
          try
            cgi_chk.cgi_chk_object[i].R:=nil;
            cgi_chk.cgi_chk_object[i].F:=nil;
            cgi_chk.cgi_chk_object[i].IO:=nil;
            cgi_chk.cgi_chk_object[i].L:=nil;
            jso:=TJSONObject.create(jsa.getString(i));
            if jso.has('id') then cgi_chk.cgi_chk_object[i].id:=jso.getInt('id') else cgi_chk.cgi_chk_object[i].id:=0; //уникальный идентификатор объекта в чековой ленте
            if jso.has('oper_id') then cgi_chk.cgi_chk_object[i].oper_id:=jso.getInt('oper_id') else cgi_chk.cgi_chk_object[i].oper_id:=0; //номер оператора, связанный с объектом ленты
            if jso.has('datetime') then cgi_chk.cgi_chk_object[i].datetime:=UnixToDateTime(jso.getInt('datetime')) else cgi_chk.cgi_chk_object[i].datetime:=0; //дата и время объекта в ленте. unixtime GMT-0
            if jso.has('L') then
            begin
//добавить обработку зарегистрированых пользователей (L)
              cgi_chk.cgi_chk_object[i].L:=nil;
            end;
            if (jso.has('F'))or(jso.has('R'))or(jso.has('IO')) then
            begin
              if jso.has('no') then
                cgi_chk.cgi_chk_object[i].no:=jso.getInt('no')
              else
                cgi_chk.cgi_chk_object[i].no:=0; //для объектов L, F, R, IO - номер чека
              if jso.has('DI') then cgi_chk.cgi_chk_object[i].DI:=jso.getInt('DI') else cgi_chk.cgi_chk_object[i].DI:=0; //для объектов L, F, R, IO - номер документа в системе онлайн отчетности ДПА
              if jso.has('pending') then cgi_chk.cgi_chk_object[i].Pending:=jso.getString('pending') else cgi_chk.cgi_chk_object[i].Pending:=''; //для объектов L, F, R, IO - признак того, что чек еще не напечатан. поле может отсутствовать. если отсутствует - чек напечатан
              if jso.has('beg_id') then cgi_chk.cgi_chk_object[i].beg_id:=jso.getInt('beg_id') else cgi_chk.cgi_chk_object[i].beg_id:=0;

              if jso.has('R') then
              begin
                cgi_chk.cgi_chk_object[i].R:=nil;
                try
                  jsa1:=TJSONArray.create(jso.getString('R'));
                  if jsa1.length>0 then
                  begin
                    SetLength(cgi_chk.cgi_chk_object[i].R,jsa1.length);
                    for j:=0 to jsa1.length-1 do
                    begin
                      cgi_chk.cgi_chk_object[i].R[j].BC.code:='';
                      cgi_chk.cgi_chk_object[i].R[j].BC._type:=0;
                      cgi_chk.cgi_chk_object[i].R[j].BC.width:=0;
                      cgi_chk.cgi_chk_object[i].R[j].BC.height:=0;
                      cgi_chk.cgi_chk_object[i].R[j].BC.feed:=0;
                      cgi_chk.cgi_chk_object[i].R[j].S.code:=0;
                      cgi_chk.cgi_chk_object[i].R[j].S.name:='';
                      cgi_chk.cgi_chk_object[i].R[j].S.qty:=0;
                      cgi_chk.cgi_chk_object[i].R[j].S.price:=0;
                      cgi_chk.cgi_chk_object[i].R[j].S.sum:=0;
                      cgi_chk.cgi_chk_object[i].R[j].S.dep:=0;
                      cgi_chk.cgi_chk_object[i].R[j].S.grp:=0;
                      cgi_chk.cgi_chk_object[i].R[j].S.tax:=0;
                      cgi_chk.cgi_chk_object[i].R[j].D.sum:=0;
                      cgi_chk.cgi_chk_object[i].R[j].D.prc:=0;
                      cgi_chk.cgi_chk_object[i].R[j].D.subt:=0;
                      cgi_chk.cgi_chk_object[i].R[j].D.tax:=0;
                      cgi_chk.cgi_chk_object[i].R[j].P.no:=0;
                      cgi_chk.cgi_chk_object[i].R[j].P.name:='';
                      cgi_chk.cgi_chk_object[i].R[j].P.sum:=0;
                      cgi_chk.cgi_chk_object[i].R[j].P.rrn:=0;
                      cgi_chk.cgi_chk_object[i].R[j].P.card:='';;
                      cgi_chk.cgi_chk_object[i].R[j].C.cm:='';

                      try
                        jso1:=TJSONObject.create(jsa1.getString(j));
                        if jso1.has('BC') then
                        begin
                          try
                            jso2:=TJSONObject.create(jso1.getString('BC'));
                            if jso2.has('code') then cgi_chk.cgi_chk_object[i].R[j].BC.code:=jso2.getString('code') else cgi_chk.cgi_chk_object[i].R[j].BC.code:='';
                            if jso2.has('type') then cgi_chk.cgi_chk_object[i].R[j].BC._type:=jso2.getInt('type') else cgi_chk.cgi_chk_object[i].R[j].BC._type:=0;
                            if jso2.has('width') then cgi_chk.cgi_chk_object[i].R[j].BC.width:=jso2.getInt('width') else cgi_chk.cgi_chk_object[i].R[j].BC.width:=0;
                            if jso2.has('height') then cgi_chk.cgi_chk_object[i].R[j].BC.height:=jso2.getInt('height') else cgi_chk.cgi_chk_object[i].R[j].BC.height:=0;
                            if jso2.has('feed') then cgi_chk.cgi_chk_object[i].R[j].BC.feed:=jso2.getInt('feed') else cgi_chk.cgi_chk_object[i].R[j].BC.feed:=0;
                          finally
                            jso2.destroy;
                          end;
                        end;
                        if jso1.has('S') then
                        begin
                          try
                            jso2:=TJSONObject.create(jso1.getString('S'));
                            if jso2.has('code') then cgi_chk.cgi_chk_object[i].R[j].S.code:=jso2.getInt('code') else cgi_chk.cgi_chk_object[i].R[j].S.code:=0;
                            if jso2.has('name') then cgi_chk.cgi_chk_object[i].R[j].S.name:=jso2.getString('name') else cgi_chk.cgi_chk_object[i].R[j].S.name:='';
                            if jso2.has('qty') then cgi_chk.cgi_chk_object[i].R[j].S.qty:=jso2.getDouble('qty') else cgi_chk.cgi_chk_object[i].R[j].S.qty:=0;
                            if jso2.has('price') then cgi_chk.cgi_chk_object[i].R[j].S.price:=jso2.getDouble('price') else cgi_chk.cgi_chk_object[i].R[j].S.price:=0;
                            if jso2.has('sum') then cgi_chk.cgi_chk_object[i].R[j].S.sum:=jso2.getDouble('sum') else cgi_chk.cgi_chk_object[i].R[j].S.sum:=0;
                            if jso2.has('dep') then cgi_chk.cgi_chk_object[i].R[j].S.dep:=jso2.getInt('dep') else cgi_chk.cgi_chk_object[i].R[j].S.dep:=0;
                            if jso2.has('grp') then cgi_chk.cgi_chk_object[i].R[j].S.grp:=jso2.getInt('grp') else cgi_chk.cgi_chk_object[i].R[j].S.grp:=0;
                            if jso2.has('tax') then cgi_chk.cgi_chk_object[i].R[j].S.tax:=jso2.getInt('tax') else cgi_chk.cgi_chk_object[i].R[j].S.tax:=0;
                          finally
                            jso2.destroy;
                          end;
                        end;
                        if jso1.has('D') then
                        begin
                          try
                            jso2:=TJSONObject.create(jso1.getString('D'));
                            if jso2.has('sum') then cgi_chk.cgi_chk_object[i].R[j].D.sum:=jso2.getDouble('sum') else cgi_chk.cgi_chk_object[i].R[j].D.sum:=0;
                            if jso2.has('prc') then cgi_chk.cgi_chk_object[i].R[j].D.prc:=jso2.getDouble('prc') else cgi_chk.cgi_chk_object[i].R[j].D.prc:=0;
                            if jso2.has('subt') then cgi_chk.cgi_chk_object[i].R[j].D.subt:=jso2.getDouble('subt') else cgi_chk.cgi_chk_object[i].R[j].D.subt:=0;
                            if jso2.has('tax') then cgi_chk.cgi_chk_object[i].R[j].D.tax:=jso2.getInt('tax') else cgi_chk.cgi_chk_object[i].R[j].D.tax:=0;
                          finally
                            jso2.destroy;
                          end;
                        end;
                        if jso1.has('P') then
                        begin
                          try
                            jso2:=TJSONObject.create(jso1.getString('P'));
                            if jso2.has('no') then
                              cgi_chk.cgi_chk_object[i].R[j].P.no:=jso2.getInt('no')
                            else
                              cgi_chk.cgi_chk_object[i].R[j].P.no:=0;
                            if jso2.has('name') then cgi_chk.cgi_chk_object[i].R[j].P.name:=jso2.getString('name') else cgi_chk.cgi_chk_object[i].R[j].P.name:='';
                            if jso2.has('sum') then cgi_chk.cgi_chk_object[i].R[j].P.sum:=jso2.getDouble('sum') else cgi_chk.cgi_chk_object[i].R[j].P.sum:=0;
                            if jso2.has('rrn') then cgi_chk.cgi_chk_object[i].R[j].P.rrn:=jso2.getInt('rrn') else cgi_chk.cgi_chk_object[i].R[j].P.rrn:=0;
                            if jso2.has('card') then cgi_chk.cgi_chk_object[i].R[j].P.card:=jso2.getString('card') else cgi_chk.cgi_chk_object[i].R[j].P.card:='';
                          finally
                            jso2.destroy;
                          end;
                        end;
                        if jso1.has('C') then
                        begin
                          try
                            jso2:=TJSONObject.create(jso1.getString('C'));
                            if jso2.has('cm') then cgi_chk.cgi_chk_object[i].R[j].C.cm:=jso2.getString('cm') else cgi_chk.cgi_chk_object[i].R[j].C.cm:='';
                          finally
                            jso2.destroy;
                          end;
                        end;
                      finally
                        jso1.destroy;
                      end;
                    end; //for j:=0 to jsa1.length-1 do
                  end //if jsa1.length>0 then
                  else
                  begin
                    SetLength(cgi_chk.cgi_chk_object[i].R,1);

                    cgi_chk.cgi_chk_object[i].R[0].BC.code:='';
                    cgi_chk.cgi_chk_object[i].R[0].BC._type:=0;
                    cgi_chk.cgi_chk_object[i].R[0].BC.width:=0;
                    cgi_chk.cgi_chk_object[i].R[0].BC.height:=0;
                    cgi_chk.cgi_chk_object[i].R[0].BC.feed:=0;
                    cgi_chk.cgi_chk_object[i].R[0].S.code:=0;
                    cgi_chk.cgi_chk_object[i].R[0].S.name:='';
                    cgi_chk.cgi_chk_object[i].R[0].S.qty:=0;
                    cgi_chk.cgi_chk_object[i].R[0].S.price:=0;
                    cgi_chk.cgi_chk_object[i].R[0].S.sum:=0;
                    cgi_chk.cgi_chk_object[i].R[0].S.dep:=0;
                    cgi_chk.cgi_chk_object[i].R[0].S.grp:=0;
                    cgi_chk.cgi_chk_object[i].R[0].S.tax:=0;
                    cgi_chk.cgi_chk_object[i].R[0].D.sum:=0;
                    cgi_chk.cgi_chk_object[i].R[0].D.prc:=0;
                    cgi_chk.cgi_chk_object[i].R[0].D.subt:=0;
                    cgi_chk.cgi_chk_object[i].R[0].D.tax:=0;
                    cgi_chk.cgi_chk_object[i].R[0].P.no:=0;
                    cgi_chk.cgi_chk_object[i].R[0].P.name:='';
                    cgi_chk.cgi_chk_object[i].R[0].P.sum:=0;
                    cgi_chk.cgi_chk_object[i].R[0].P.rrn:=0;
                    cgi_chk.cgi_chk_object[i].R[0].P.card:='';
                    cgi_chk.cgi_chk_object[i].R[0].C.cm:='';
                  end; //if jsa1.length>0 then else
                finally
                  jsa1.destroy;
                end;
              end; //if jso.has('R') then

              if jso.has('IO') then
              begin
                cgi_chk.cgi_chk_object[i].IO:=nil;
                cgi_chk.cgi_chk_object[i].no:=cgi_chk.cgi_chk_object[i].no-1;
                try
                  jsa1:=TJSONArray.create(jso.getString('IO'));
                  if jsa.length>0 then
                  begin
                    SetLength(cgi_chk.cgi_chk_object[i].IO,jsa1.length);

                    for j:=0 to jsa1.length-1 do
                    begin
                      cgi_chk.cgi_chk_object[i].IO[j].no:=0;
                      cgi_chk.cgi_chk_object[i].IO[j].name:='';
                      cgi_chk.cgi_chk_object[i].IO[j].sum:=0;
                      cgi_chk.cgi_chk_object[i].IO[j].C.cm:='';
                      cgi_chk.cgi_chk_object[i].IO[j].BC.code:='';
                      cgi_chk.cgi_chk_object[i].IO[j].BC._type:=0;
                      cgi_chk.cgi_chk_object[i].IO[j].BC.width:=0;
                      cgi_chk.cgi_chk_object[i].IO[j].BC.height:=0;
                      cgi_chk.cgi_chk_object[i].IO[j].BC.feed:=0;

                      try
                        jso1:=TJSONObject.create(jsa1.getString(j));
                        if jso1.has('IO') then
                        begin
                          try
                            jso2:=TJSONObject.create(jso1.getString('IO'));
                            if jso2.has('no') then
                              cgi_chk.cgi_chk_object[i].IO[j].no:=jso2.getInt('no')
                            else
                              cgi_chk.cgi_chk_object[i].IO[j].no:=0; //номер строки в таблице Pay
                            if jso2.has('name') then cgi_chk.cgi_chk_object[i].IO[j].name:=jso2.getString('name') else cgi_chk.cgi_chk_object[i].IO[j].name:='';
                            if jso2.has('sum') then cgi_chk.cgi_chk_object[i].IO[j].sum:=jso2.getDouble('sum') else cgi_chk.cgi_chk_object[i].IO[j].sum:=0; //сумма внесения или изъятия
                          finally
                            jso2.destroy;
                          end;
                        end;
                        if jso1.has('C') then
                        begin
                          try
                            jso2:=TJSONObject.create(jso1.getString('C'));
                            if jso2.has('cm') then cgi_chk.cgi_chk_object[i].IO[j].C.cm:=jso2.getString('cm') else cgi_chk.cgi_chk_object[i].IO[j].C.cm:=''; //фискальный коментарий
                          finally
                            jso2.destroy;
                          end;
                        end;
                        if jso1.has('BC') then
                        begin
                          try
                            jso2:=TJSONObject.create(jso1.getString('BC'));
                            if jso2.has('code') then cgi_chk.cgi_chk_object[i].IO[j].BC.code:=jso2.getString('code') else cgi_chk.cgi_chk_object[i].IO[j].BC.code:='';
                            if jso2.has('type') then cgi_chk.cgi_chk_object[i].IO[j].BC._type:=jso2.getInt('type') else cgi_chk.cgi_chk_object[i].IO[j].BC._type:=0;
                            if jso2.has('width') then cgi_chk.cgi_chk_object[i].IO[j].BC.width:=jso2.getInt('width') else cgi_chk.cgi_chk_object[i].IO[j].BC.width:=0;
                            if jso2.has('height') then cgi_chk.cgi_chk_object[i].IO[j].BC.height:=jso2.getInt('height') else cgi_chk.cgi_chk_object[i].IO[j].BC.height:=0;
                            if jso2.has('feed') then cgi_chk.cgi_chk_object[i].IO[j].BC.feed:=jso2.getInt('feed') else cgi_chk.cgi_chk_object[i].IO[j].BC.feed:=0;
                          finally
                            jso2.destroy;
                          end;
                        end;
                      finally
                        jso1.destroy;
                      end;
                    end; //for j:=0 to jsa1.length-1 do
                  end //if jsa.length>0 then
                  else
                  begin
                    SetLength(cgi_chk.cgi_chk_object[i].IO,1);

                    cgi_chk.cgi_chk_object[i].IO[0].no:=0;
                    cgi_chk.cgi_chk_object[i].IO[0].name:='';
                    cgi_chk.cgi_chk_object[i].IO[0].sum:=0;
                    cgi_chk.cgi_chk_object[i].IO[0].C.cm:='';
                    cgi_chk.cgi_chk_object[i].IO[0].BC.code:='';
                    cgi_chk.cgi_chk_object[i].IO[0].BC._type:=0;
                    cgi_chk.cgi_chk_object[i].IO[0].BC.width:=0;
                    cgi_chk.cgi_chk_object[i].IO[0].BC.height:=0;
                    cgi_chk.cgi_chk_object[i].IO[0].BC.feed:=0;
                  end; //if jsa1.length>0 then else
                finally
                  jsa1.destroy;
                end;
              end; //if jso.has('IO') then

              if jso.has('F') then
              begin
                cgi_chk.cgi_chk_object[i].F:=nil;
                try
                  jsa1:=TJSONArray.create(jso.getString('F'));
                  if jsa1.length>0 then
                  begin
                    SetLength(cgi_chk.cgi_chk_object[i].F,jsa1.length);

                    for j:=0 to jsa1.length-1 do
                    begin
                      cgi_chk.cgi_chk_object[i].F[j].BC.code:='';
                      cgi_chk.cgi_chk_object[i].F[j].BC._type:=0;
                      cgi_chk.cgi_chk_object[i].F[j].BC.width:=0;
                      cgi_chk.cgi_chk_object[i].F[j].BC.height:=0;
                      cgi_chk.cgi_chk_object[i].F[j].BC.feed:=0;
                      cgi_chk.cgi_chk_object[i].F[j].S.code:=0;
                      cgi_chk.cgi_chk_object[i].F[j].S.name:='';
                      cgi_chk.cgi_chk_object[i].F[j].S.qty:=0;
                      cgi_chk.cgi_chk_object[i].F[j].S.price:=0;
                      cgi_chk.cgi_chk_object[i].F[j].S.sum:=0;
                      cgi_chk.cgi_chk_object[i].F[j].S.dep:=0;
                      cgi_chk.cgi_chk_object[i].F[j].S.grp:=0;
                      cgi_chk.cgi_chk_object[i].F[j].S.tax:=0;
                      cgi_chk.cgi_chk_object[i].F[j].D.sum:=0;
                      cgi_chk.cgi_chk_object[i].F[j].D.prc:=0;
                      cgi_chk.cgi_chk_object[i].F[j].D.subt:=0;
                      cgi_chk.cgi_chk_object[i].F[j].D.tax:=0;
                      cgi_chk.cgi_chk_object[i].F[j].P.no:=0;
                      cgi_chk.cgi_chk_object[i].F[j].P.name:='';
                      cgi_chk.cgi_chk_object[i].F[j].P.sum:=0;
                      cgi_chk.cgi_chk_object[i].F[j].P.rrn:=0;
                      cgi_chk.cgi_chk_object[i].F[j].P.card:='';
                      cgi_chk.cgi_chk_object[i].F[j].C.cm:='';

                      try
                        jso1:=TJSONObject.create(jsa1.getString(j));
                        if jso1.has('BC') then
                        begin
                          try
                            jso2:=TJSONObject.create(jso1.getString('BC'));
                            if jso2.has('code') then cgi_chk.cgi_chk_object[i].F[j].BC.code:=jso2.getString('code') else cgi_chk.cgi_chk_object[i].F[j].BC.code:='';
                            if jso2.has('type') then cgi_chk.cgi_chk_object[i].F[j].BC._type:=jso2.getInt('type') else cgi_chk.cgi_chk_object[i].F[j].BC._type:=0;
                            if jso2.has('width') then cgi_chk.cgi_chk_object[i].F[j].BC.width:=jso2.getInt('width') else cgi_chk.cgi_chk_object[i].F[j].BC.width:=0;
                            if jso2.has('height') then cgi_chk.cgi_chk_object[i].F[j].BC.height:=jso2.getInt('height') else cgi_chk.cgi_chk_object[i].F[j].BC.height:=0;
                            if jso2.has('feed') then cgi_chk.cgi_chk_object[i].F[j].BC.feed:=jso2.getInt('feed') else cgi_chk.cgi_chk_object[i].F[j].BC.feed:=0;
                          finally
                            jso2.destroy;
                          end;
                        end;
                        if jso1.has('S') then
                        begin
                          try
                            jso2:=TJSONObject.create(jso1.getString('S'));
                            if jso2.has('code') then cgi_chk.cgi_chk_object[i].F[j].S.code:=jso2.getInt('code') else cgi_chk.cgi_chk_object[i].F[j].S.code:=0;
                            if jso2.has('name') then cgi_chk.cgi_chk_object[i].F[j].S.name:=jso2.getString('name') else cgi_chk.cgi_chk_object[i].F[j].S.name:='';
                            if jso2.has('qty') then cgi_chk.cgi_chk_object[i].F[j].S.qty:=jso2.getDouble('qty') else cgi_chk.cgi_chk_object[i].F[j].S.qty:=0;
                            if jso2.has('price') then cgi_chk.cgi_chk_object[i].F[j].S.price:=jso2.getDouble('price') else cgi_chk.cgi_chk_object[i].F[j].S.price:=0;
                            if jso2.has('sum') then cgi_chk.cgi_chk_object[i].F[j].S.sum:=jso2.getDouble('sum') else cgi_chk.cgi_chk_object[i].F[j].S.sum:=0;
                            if jso2.has('dep') then cgi_chk.cgi_chk_object[i].F[j].S.dep:=jso2.getInt('dep') else cgi_chk.cgi_chk_object[i].F[j].S.dep:=0;
                            if jso2.has('grp') then cgi_chk.cgi_chk_object[i].F[j].S.grp:=jso2.getInt('grp') else cgi_chk.cgi_chk_object[i].F[j].S.grp:=0;
                            if jso2.has('tax') then cgi_chk.cgi_chk_object[i].F[j].S.tax:=jso2.getInt('tax') else cgi_chk.cgi_chk_object[i].F[j].S.tax:=0;
                          finally
                            jso2.destroy;
                          end;
                        end;
                        if jso1.has('D') then
                        begin
                          try
                            jso2:=TJSONObject.create(jso1.getString('D'));
                            if jso2.has('sum') then cgi_chk.cgi_chk_object[i].F[j].D.sum:=jso2.getDouble('sum') else cgi_chk.cgi_chk_object[i].F[j].D.sum:=0;
                            if jso2.has('prc') then cgi_chk.cgi_chk_object[i].F[j].D.prc:=jso2.getDouble('prc') else cgi_chk.cgi_chk_object[i].F[j].D.prc:=0;
                            if jso2.has('subt') then cgi_chk.cgi_chk_object[i].F[j].D.subt:=jso2.getDouble('subt') else cgi_chk.cgi_chk_object[i].F[j].D.subt:=0;
                            if jso2.has('tax') then cgi_chk.cgi_chk_object[i].F[j].D.tax:=jso2.getInt('tax') else cgi_chk.cgi_chk_object[i].F[j].D.tax:=0;
                          finally
                            jso2.destroy;
                          end;
                        end;
                        if jso1.has('P') then
                        begin
                          try
                            jso2:=TJSONObject.create(jso1.getString('P'));
                            if jso2.has('no') then
                              cgi_chk.cgi_chk_object[i].F[j].P.no:=jso2.getInt('no')
                            else
                              cgi_chk.cgi_chk_object[i].F[j].P.no:=0;
                            if jso2.has('name') then cgi_chk.cgi_chk_object[i].F[j].P.name:=jso2.getString('name') else cgi_chk.cgi_chk_object[i].F[j].P.name:='';
                            if jso2.has('sum') then cgi_chk.cgi_chk_object[i].F[j].P.sum:=jso2.getDouble('sum') else cgi_chk.cgi_chk_object[i].F[j].P.sum:=0;
                            if jso2.has('rrn') then cgi_chk.cgi_chk_object[i].F[j].P.rrn:=jso2.getInt('rrn') else cgi_chk.cgi_chk_object[i].F[j].P.rrn:=0;
                            if jso2.has('card') then cgi_chk.cgi_chk_object[i].F[j].P.card:=jso2.getString('card') else cgi_chk.cgi_chk_object[i].F[j].P.card:='';
                          finally
                            jso2.destroy;
                          end;
                        end;
                        if jso1.has('C') then
                        begin
                          try
                            jso2:=TJSONObject.create(jso1.getString('C'));
                            if jso2.has('cm') then cgi_chk.cgi_chk_object[i].F[j].C.cm:=jso2.getString('cm') else cgi_chk.cgi_chk_object[i].F[j].C.cm:='';
                          finally
                            jso2.destroy;
                          end;
                        end;
                      finally
                        jso1.destroy;
                      end;
                    end; //for j:=0 to jsa1.length-1 do
                  end  //if jsa1.length>0 then
                  else
                  begin
                    SetLength(cgi_chk.cgi_chk_object[i].F,1);

                    cgi_chk.cgi_chk_object[i].F[0].BC.code:='';
                    cgi_chk.cgi_chk_object[i].F[0].BC._type:=0;
                    cgi_chk.cgi_chk_object[i].F[0].BC.width:=0;
                    cgi_chk.cgi_chk_object[i].F[0].BC.height:=0;
                    cgi_chk.cgi_chk_object[i].F[0].BC.feed:=0;
                    cgi_chk.cgi_chk_object[i].F[0].S.code:=0;
                    cgi_chk.cgi_chk_object[i].F[0].S.name:='';
                    cgi_chk.cgi_chk_object[i].F[0].S.qty:=0;
                    cgi_chk.cgi_chk_object[i].F[0].S.price:=0;
                    cgi_chk.cgi_chk_object[i].F[0].S.sum:=0;
                    cgi_chk.cgi_chk_object[i].F[0].S.dep:=0;
                    cgi_chk.cgi_chk_object[i].F[0].S.grp:=0;
                    cgi_chk.cgi_chk_object[i].F[0].S.tax:=0;
                    cgi_chk.cgi_chk_object[i].F[0].D.sum:=0;
                    cgi_chk.cgi_chk_object[i].F[0].D.prc:=0;
                    cgi_chk.cgi_chk_object[i].F[0].D.subt:=0;
                    cgi_chk.cgi_chk_object[i].F[0].D.tax:=0;
                    cgi_chk.cgi_chk_object[i].F[0].P.no:=0;
                    cgi_chk.cgi_chk_object[i].F[0].P.name:='';
                    cgi_chk.cgi_chk_object[i].F[0].P.sum:=0;
                    cgi_chk.cgi_chk_object[i].F[0].P.rrn:=0;
                    cgi_chk.cgi_chk_object[i].F[0].P.card:='';
                    cgi_chk.cgi_chk_object[i].F[0].C.cm:='';
                  end; //if jsa1.length>0 then else
                finally
                  jsa1.destroy;
                end;
              end; //if jso.has('F') then
            end; //if (jso.has('F'))or(jso.has('R'))or(jso.has('IO')) then
          finally
            jso.destroy;
          end;
        end; //for i:=0 to jsa.length-1 do
        if flFiscal then
          cgi_chk.max_check_no:=0
        else
          cgi_chk.max_check_no:=MAX_RECEIPT_NUMBER;
        for i:=0 to length(cgi_chk.cgi_chk_object)-1 do
          if flFiscal then
          begin
            if (cgi_chk.cgi_chk_object[i].no > cgi_chk.max_check_no)and(cgi_chk.cgi_chk_object[i].R = nil) then
              cgi_chk.max_check_no:= cgi_chk.cgi_chk_object[i].no
          end
          else
            if (cgi_chk.max_check_no < MAX_RECEIPT_NUMBER)or(cgi_chk.max_check_no < cgi_chk.cgi_chk_object[i].no) then
              cgi_chk.max_check_no:= cgi_chk.cgi_chk_object[i].no;
        cgi_chk.ErrorCode:='';
        cgi_chk.ErrorDescription:='';
        Result:=false;
      end //if jsa.length>0 then
      else
      begin
        cgi_chk.ErrorCode:=EMPTY_RECEIPT_LINE_CODE;
        cgi_chk.ErrorDescription:=EMPTY_RECEIPT_LINE_DESCRIPTION;
        cgi_chk.max_check_no:=-1;
        Result:=true;
        exit;
      end; //else if jsa.length>0 then
    finally
      jsa.destroy;
    end;
  end //if js[1]='[' then
  else
  begin
    if js[1]='{' then
    begin
      cgi_chk.ErrorCode:=EMPTY_RECEIPT_LINE_CODE;
      cgi_chk.ErrorDescription:=EMPTY_RECEIPT_LINE_DESCRIPTION;
      cgi_chk.max_check_no:=-1;
      Result:=true;
      exit;
    end; //if js[1]='{' then
  end; //else if js[1]='[' then
end;

(*----------------------------------------------------------------------------*)
(*--- вспомогательные функции                                              ---*)
(*----------------------------------------------------------------------------*)

function IntToBin(value, digits: integer): string;
var
   res: string;
   i: integer;
begin
   if digits > 32 then
      digits := 32;
   res := '';
   i := 0;
   while i < digits do
   begin
      if ((1 shl i) and value) > 0 then
         res := '1' + res
      else
         res := '0' + res;
      inc(i);
   end;
   Result := res;
end;

function CheckDeviceStatus(const dev_state: string; out StateArray: string): boolean;
var
  i: integer;
begin
  Result:=false;

  if dev_state[7]='0' then  //0 - модуль SAM не обнаружен; 1 - модуль SAM обнаружен;
  begin
    StateArray:='Модуль SAM не обнаружен'+#10#13;
    Result:=false;
  end
  else
  begin
    StateArray:='Модуль SAM обнаружен'+#10#13;
    Result:=true;
  end;

  if dev_state[6]='0' then //0 - модуль SAM сопряжен с устройством; 1 - модуль SAM не сопряжен с устройством;
  begin
    StateArray:=StateArray+'Модуль SAM сопряжен с устройством'+#10#13;
    Result:=true;
  end
  else
  begin
    StateArray:=StateArray+'Модуль SAM не сопряжен с устройством'+#10#13;
    Result:=false;
  end;

  if dev_state[5]='0' then //0 - персонализация отсутствует; 1 - персонализация присутствует
  begin
    StateArray:=StateArray+'Персонализация отсутствует'+#10#13;
    Result:=false;
  end
  else
  begin
    StateArray:=StateArray+'Персонализация присутствует'+#10#13;
    Result:=true;
  end;

  if dev_state[4]='0' then //0 - система персонализирована; 1 - ошибка персонализации
  begin
    StateArray:=StateArray+'Система персонализирована'+#10#13;
    Result:=true;
  end
  else
  begin
    StateArray:=StateArray+'Ошибка персонализации'+#10#13;
    Result:=false;
  end;

  if dev_state[3]='0' then //0 - хранилище документов разрушено; 1 - хранилище документов исправно
  begin
    StateArray:=StateArray+'Хранилище документов разрушено'+#10#13;
    Result:=false;
  end
  else
  begin
    StateArray:=StateArray+'Хранилище документов исправно'+#10#13;
    Result:=true;
  end;

  if dev_state[2]='0' then //0 - нет сетевого соединения; 1 - сетевое соединение установлено
  begin
    StateArray:=StateArray+'Нет сетевого соединения'+#10#13;
    Result:=false;
  end
  else
  begin
    StateArray:=StateArray+'Сетеве соединение установлено'+#10#13;
    Result:=true;
  end;

  if dev_state[1]='0' then //0 - модем функционирует нормально; 1 - ошибка модема
  begin
    StateArray:=StateArray+'Модем функционирует нормально'+#10#13;
    Result:=true;
  end
  else
  begin
    StateArray:=StateArray+'Ошибка модема'+#10#13;
    Result:=false;
  end;
{
      // 1       0 - модуль SAM не обнаружен; 1 - модуль SAM обнаружен;
      // 2       0 - модуль SAM сопряжен с устройством; 1 - модуль SAM не сопряжен с устройством;
      // 3       0 - персонализация отсутствует; 1 - персонализация присутствует
      // 4       0 - система персонализирована; 1 - ошибка персонализации
      // 5       0 - хранилище документов разрушено; 1 - хранилище документов исправно
      // 6       0 - нет сетевого соединения; 1 - сетевое соединение установлено
      // 7       0 - модем функционирует нормально; 1 - ошибка модема
}
end;

(*----------------------------------------------------------------------------*)
(*--- запросы к кассовому аппарату                                         ---*)
(*----------------------------------------------------------------------------*)

function GetDeviceState(out state: T_cgi_state; out ErrorCode, ErrorDescription: string; pIPAddr: string): boolean;
var
  u: ansistring;
  IsDeflated: boolean;
  V: Variant;
  os: TOLEStream;
  in_Stream: TMemoryStream;
  UnknownPtr: Pointer;
  NewSize: integer;
  curr_wide: WideString;
  memo: TMemo;
begin
  Result:=false; //аппарат доступен и готов к работе
  ErrorCode:='';
  ErrorDescription:='';
  with cgi_state do
  begin
    ErrorCode:='';
    ErrorDescription:='';
    model:='';
    name:='';
    serial:='';
    _time:=0;
    chkId:=0;
    JrnTime:=0;
    currZ:=0;
    IsWrk:=0;
    Fiscalization:=0;
    FskMode:=0;
    CurrDI:=0;
    ID_SAM:=0;
    ID_DEV:=0;
    NPrLin:=0;
    Err:=nil;
  end;

  u:=PROTOCOL+pIPAddr+URI_CGI_STATUS;
  IsDeflated:=false;
  try
    Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
    Req.Open(METHOD_HEAD, u, true);
    Req.SetRequestHeader('Connection','Keep-Alive');
    Req.SetRequestHeader('Proxy-Connection','keep-alive');
    Req.Send();
    Req.WaitForResponse;
  except
    Result:=true;
    ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
    ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
    exit;
  end;
  ParseDscResponseHeaders(Req.GetAllResponseHeaders);
  case Req.Status of //head
    100..199:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
    200..299:
      begin
        Result:=false; //аппарат доступен и готов к работе
        ErrorCode:='';
        ErrorDescription:='';

        u:=PROTOCOL+pIPAddr+URI_CGI_STATE;
        IsDeflated:=false;
        try
          Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
          Req.Open(METHOD_GET, u, true);
          Req.SetRequestHeader('Connection','Keep-Alive');
          Req.SetRequestHeader('Proxy-Connection','keep-alive');
          Req.SetCredentials(USERNAME_SERVICE,PASS_SERVICE,0);
          Req.Send();
          Req.WaitForResponse;
        except
          ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
          ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
          Result:=true;
          exit;
        end;
        ParseDscResponseHeaders(Req.GetAllResponseHeaders);
        case Req.Status of //get
          100..199:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
          200..299:
            begin
              try
                V:=req.ResponseStream;
                TVarData(V).vType:=varUnknown;
                os:=TOLEStream.Create(IStream(TVarData(V).VUnknown));
                in_Stream:=TMemoryStream.Create;
                in_Stream.CopyFrom(os,os.Size);

                if Content_Encoding='deflate' then
                begin
                  try
                    in_Stream.Position := 0;
                    DeCompressBuf(in_stream.Memory, in_stream.Size, Content_Length, UnknownPtr, NewSize);
                    in_stream.Clear;
                    in_stream.Position := 0;
                    in_stream.Write(UnknownPtr^, NewSize);
                    in_stream.Position := 0;
                    in_stream.Size;
                  finally
                    FreeMem(UnknownPtr, NewSize);
                  end;
                    IsDeflated:=true;
                end;
              finally
                SetString(curr_wide,PChar(in_stream.Memory),in_stream.Size);
              end;
              try
                memo:=TMemo.Create(nil);
                if IsDeflated then
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,4,length(curr_wide)-3)))
                else
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,0,length(curr_wide))));
                memo.Text:=UTF8ToAnsi(memo.Text);
                if ParseStateRequest(memo.Text,ErrorCode,ErrorDescription) then
                begin
                  Result:=true;
                  exit;
                end;

                if ParseStateRequest(memo.Text,ErrorCode,ErrorDescription) then
                begin
                  ErrorCode:=cgi_state.ErrorCode;
                  ErrorDescription:=cgi_state.ErrorDescription;
                  Result:=true;
                  exit;
                end;
              finally
                memo.Free;
              end;
            end;
            300..599:
              begin
                HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
                Result:=true;
              end;
        end; //get
      end;

    300..599:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
  end; //head
end;

function GetDeviceInfo(out dev_info: T_cgi_dev_info; out ErrorCode, ErrorDescription: string; pIPAddr: string): boolean;
var
  u: ansistring;
  IsDeflated: boolean;
  V: Variant;
  os: TOLEStream;
  in_Stream: TMemoryStream;
  UnknownPtr: Pointer;
  NewSize: integer;
  curr_wide: WideString;
  memo: TMemo;
begin
  with cgi_dev_info do
  begin
    dev_zn:='';
    dev_ver:='';
    dev_dat:='';
    dev_fn:='';
    dev_nn:='';
    dev_id:=-1;
    prot:=0;
  end;
  ErrorCode:='';
  ErrorDescription:='';
  Result:=false;

    //получение информации об EKKA
//
//    dev_zn: string;           //заводской номер                                 /cgi/dev_info/dev_zn
//    dev_fn: string;           //Фискальный номер                                /cgi/dev_info/dev_fn
//    dev_ver: string;          //версия прошивки EKKA                            /cgi/dev_info/dev_ver
//    dev_dat: string;           //дата прошивка EKKA                             /cgi/dev_info/dev_dat
//
  u:=PROTOCOL+pIPAddr+URI_CGI_DEV_INFO;
  IsDeflated:=false;
  //проверка доступности EKKA
  try
    Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
    Req.Open(METHOD_HEAD, u, true);
    Req.SetRequestHeader('Connection','Keep-Alive');
    Req.SetRequestHeader('Proxy-Connection','keep-alive');
    Req.Send();
    Req.WaitForResponse;
  except
    ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
    ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
    Result:=true;
    exit;
  end;

  case Req.Status of
    100..199:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
    200..299:
      begin
        try
          Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
          Req.Open(METHOD_GET, u, true);
          Req.SetRequestHeader('Connection','Keep-Alive');
          Req.SetRequestHeader('Proxy-Connection','keep-alive');
          Req.Send();
          Req.WaitForResponse;
        except
          ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
          ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
          Result:=true;
          exit;
        end;
        case Req.Status of
          100..199:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
          200..299:
            begin
              ParseDscResponseHeaders(Req.GetAllResponseHeaders);
              try
                V:=req.ResponseStream;
                TVarData(V).vType:=varUnknown;
                os:=TOLEStream.Create(IStream(TVarData(V).VUnknown));
                in_Stream:=TMemoryStream.Create;
                in_Stream.CopyFrom(os,os.Size);

                if Content_Encoding='deflate' then
                begin
                  try
                    in_Stream.Position := 0;
                    DeCompressBuf(in_stream.Memory, in_stream.Size, Content_Length, UnknownPtr, NewSize);
                    in_stream.Clear;
                    in_stream.Position := 0;
                    in_stream.Write(UnknownPtr^, NewSize);
                    in_stream.Position := 0;
                    in_stream.Size;
                  finally
                    FreeMem(UnknownPtr, NewSize);
                  end;
                  IsDeflated:=true;
                end;
              finally
                SetString(curr_wide,PChar(in_stream.Memory),in_stream.Size);
              end;

              try
                memo:=TMemo.Create(nil);
                if IsDeflated then
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,4,length(curr_wide)-3)))
                else
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,0,length(curr_wide))));
                memo.Text:=UTF8ToAnsi(memo.Text);
                if ParseDeviceInfoRequest(memo.Text) then
                begin
                  ErrorCode:=DEV_STATE_ERROR_CODE_UNKNOWN;
                  ErrorDescription:=DEV_STATE_ERROR_DESCRIPTION_UNKNOWN;
                  Result:=true;
                  exit;
                end;
              finally
                memo.Free;
              end;
            end;
          300..599:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
        end;
      end;

    300..599:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
  end;
end;

function GetDeviceStatus(out device_status: T_cgi_status; out ErrorCode, ErrorDescription: string; pIPAddr: string): boolean;
var
  u: ansistring;
  IsDeflated: boolean;
  V: Variant;
  os: TOLEStream;
  in_Stream: TMemoryStream;
  UnknownPtr: Pointer;
  NewSize: integer;
  curr_wide: WideString;
  memo: TMemo;
  DeviceStatus, DeviceStatusDescription: string;
begin
  ErrorCode:='';
  ErrorDescription:='';
  with device_status do
  begin
    dev_state:='';
    tm:=0;
    tmo:=0;
    ct:=0;
    bt:=0;
    ndoc:=0;
    pers_sam_id:='';
    pers_time:='';
    card_no:='';
    sam_id:=0;
    sam_dev_id:=0;
    eq_id:='';
  end;
  Result:=false;
  u:=PROTOCOL+pIPAddr+URI_CGI_STATUS;
  IsDeflated:=false;
  try
    Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
    Req.Open(METHOD_HEAD, u, true);
    Req.SetRequestHeader('Connection','Keep-Alive');
    Req.SetRequestHeader('Proxy-Connection','keep-alive');
    Req.Send();
    Req.WaitForResponse;
  except
    ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
    ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
    Result:=true;
    exit;
  end;

  ParseDscResponseHeaders(Req.GetAllResponseHeaders);
  case Req.Status of //тут можно будет прописать конкретное поведение для каждого из полученых ответов от сервера
    100..199:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
    200..299:
      begin
        try
          Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
          Req.Open(METHOD_GET, u, true);
          Req.SetRequestHeader('Connection','Keep-Alive');
          Req.SetRequestHeader('Proxy-Connection','keep-alive');
          Req.Send();
          Req.WaitForResponse;
        except
          ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
          ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
          Result:=true;
          exit;
        end;
        ParseDscResponseHeaders(Req.GetAllResponseHeaders);
        case Req.Status of
          100..199:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
          200..299:
          begin
            try
              V:=req.ResponseStream;
              TVarData(V).vType:=varUnknown;
              os:=TOLEStream.Create(IStream(TVarData(V).VUnknown));
              in_Stream:=TMemoryStream.Create;
              in_Stream.CopyFrom(os,os.Size);
              if Content_Encoding='deflate' then
              begin
                try
                  in_Stream.Position := 0;
                  DeCompressBuf(in_stream.Memory, in_stream.Size, Content_Length, UnknownPtr, NewSize);
                  in_stream.Clear;
                  in_stream.Position := 0;
                  in_stream.Write(UnknownPtr^, NewSize);
                  in_stream.Position := 0;
                  in_stream.Size;
                finally
                  FreeMem(UnknownPtr, NewSize);
                end;
                IsDeflated:=true;
              end;
            finally
              SetString(curr_wide,PChar(in_stream.Memory),in_stream.Size);
            end;
            try
              memo:=TMemo.Create(nil);
              if IsDeflated then
                memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,4,length(curr_wide)-3)))
              else
                memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,0,length(curr_wide))));
              memo.Text:=UTF8ToAnsi(memo.Text);
              if ParseStatusRequest(cgi_status,memo.Text) then
              begin
                Result:=true;
                exit;
              end
              else
              begin
                if length(trim(cgi_status.dev_state)) > 0 then
                begin
                  try
                    StrToInt(cgi_status.dev_state);
                  except
                    Result:=true;
                    ErrorCode:=DEV_STATE_ERROR_CODE_UNKNOWN;
                    ErrorDescription:=DEV_STATE_ERROR_DESCRIPTION_UNKNOWN;
                    exit;
                  end;
                  DeviceStatus:=IntToBin(StrToInt(cgi_status.dev_state),7);
                  if not CheckDeviceStatus(DeviceStatus, DeviceStatusDescription) then //ошибка в dev_state
                  begin
                    ErrorCode:=cgi_status.dev_state;
                    ErrorDescription:=DeviceStatus;
                    Result:=true;
                  end
                  else
                  begin
                    ErrorCode:=cgi_status.dev_state;
                    ErrorDescription:=DeviceStatusDescription;
                    Result:=false;
                  end;
                end;
              end;
            finally
              memo.Free;
            end;
          end;
          300..599:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
        end;
      end;

    300..599:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
  end;
end;

function GetJrnRoom(out get_jrn_room: T_cgi_proc_getjrnroom; out ErrorCode, ErrorDescription: string; pIPAddr: string): boolean;
var
  u: ansistring;
  IsDeflated: boolean;
  V: Variant;
  os: TOLEStream;
  in_Stream: TMemoryStream;
  UnknownPtr: Pointer;
  NewSize: integer;
  curr_wide: WideString;
  memo: TMemo;
begin
  get_jrn_room.Total:=0;
  get_jrn_room.Used:=0;
  get_jrn_room.Err:=nil;
  Result:=false;

  u:=PROTOCOL+pIPAddr+URI_CGI_STATUS;
  try
    Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
    Req.Open(METHOD_HEAD, u, true);
    Req.SetRequestHeader('Connection','Keep-Alive');
    Req.SetRequestHeader('Proxy-Connection','keep-alive');
    Req.Send();
    Req.WaitForResponse;
  except
    Result:=true;
    ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
    ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
    exit;
  end;

  case Req.Status of
    100..199:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
    200..299:
      begin
        u:=PROTOCOL+pIPAddr+URI_CGI_PROC_GETJRNROOM;
        IsDeflated:=false;
        //проверка доступности EKKA
        try
          Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
          Req.Open(METHOD_GET, u, true);
          Req.SetRequestHeader('Connection','Keep-Alive');
          Req.SetRequestHeader('Proxy-Connection','keep-alive');
          Req.SetCredentials(USERNAME_SERVICE,PASS_SERVICE,0);
          Req.Send();
          Req.WaitForResponse;
        except
          Result:=true;
          ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
          ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
          exit;
        end;

        case Req.Status of
          100..199:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
          200..299:
            begin
              ParseDscResponseHeaders(Req.GetAllResponseHeaders);
              try
                V:=req.ResponseStream;
                TVarData(V).vType:=varUnknown;
                os:=TOLEStream.Create(IStream(TVarData(V).VUnknown));
                in_Stream:=TMemoryStream.Create;
                in_Stream.CopyFrom(os,os.Size);
                if Content_Encoding='deflate' then
                begin
                  try
                    in_Stream.Position := 0;
                    DeCompressBuf(in_stream.Memory, in_stream.Size, Content_Length, UnknownPtr, NewSize);
                    in_stream.Clear;
                    in_stream.Position := 0;
                    in_stream.Write(UnknownPtr^, NewSize);
                    in_stream.Position := 0;
                    in_stream.Size;
                  finally
                    FreeMem(UnknownPtr, NewSize);
                  end;
                    IsDeflated:=true;
                end;
              finally
                SetString(curr_wide,PChar(in_stream.Memory),in_stream.Size);
              end;
              try
                memo:=TMemo.Create(nil);
                if IsDeflated then
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,4,length(curr_wide)-3)))
                else
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,0,length(curr_wide))));
                memo.Text:=UTF8ToAnsi(memo.Text);
                if ParseProcGetJrnRoom(memo.Text,ErrorCode,ErrorDescription) then
                begin
                  Result:=true;
                  ErrorCode:=cgi_proc_getjrnroom.Err[0].e;
                  ErrorDescription:=ErrorCode;
                  exit;
                end
                else
                begin
                  get_jrn_room.Used:=cgi_proc_getjrnroom.Used;
                end;
              finally
                memo.Free;
              end;
            end;
          300..599:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
        end;
      end;

    300..599:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
  end;
end;

(*----------------------------------------------------------------------------*)
(*--- API работы с кассовым аппаратом                                      ---*)
(*----------------------------------------------------------------------------*)

function GetStatusN707(IPAddr: string): TStatusN707;
var
  ErrCode,ErrDescr: string;
begin
  GetStatusN707.IsError:=False;
  GetStatusN707.ErrorCode:='';
  GetStatusN707.ErrorDescription:='';
  GetStatusN707.HTTPCode:=200;
  GetStatusN707.HTTPDescription:='OK';
  GetStatusN707.dev_state:='';
  GetStatusN707.dev_id:=-1;
  GetStatusN707.dev_zn:='';
  GetStatusN707.dev_fn:='';
  //??? Наименование и адрес предприятия
  GetStatusN707.dt:=0;  //Дата EKKA
  GetStatusN707.tm:=0;  //Время EKKA
  //??? признак зарегистрированого кассира
  GetStatusN707.Used:=0;  //признак выполнения Z-отчета
  GetStatusN707.currZ:='';
  GetStatusN707.chkId:='';
  GetStatusN707.dev_ver:='';
  GetStatusN707.dev_dat:='';

  //проверка доступности EKKA
  if GetDeviceStatus(cgi_status,ErrCode,ErrDescr,IPAddr) then
  begin
    GetStatusN707.ErrorCode:=ErrCode;
    GetStatusN707.ErrorDescription:=ErrDescr;
    GetStatusN707.IsError:=true;
    exit;
  end
  else
  begin
    GetStatusN707.dev_state:=cgi_status.dev_state;
    GetStatusN707.dt:=UnixToDateTime(cgi_status.tm);
    GetStatusN707.tm:=UnixToDateTime(cgi_status.tm);
    //получение информации об EKKA
    if GetDeviceInfo(cgi_dev_info,ErrCode,ErrDescr,IPAddr) then
    begin
      GetStatusN707.ErrorCode:=ErrCode;
      GetStatusN707.ErrorDescription:=ErrDescr;
      GetStatusN707.IsError:=true;
      exit;
    end
    else
    begin
      GetStatusN707.dev_id:=cgi_dev_info.dev_id;
      GetStatusN707.dev_zn:=cgi_dev_info.dev_zn;
      GetStatusN707.dev_fn:=cgi_dev_info.dev_fn;
      GetStatusN707.dev_ver:=cgi_dev_info.dev_ver;
      GetStatusN707.dev_dat:=cgi_dev_info.dev_dat;
    end;

    if GetDeviceState(cgi_state,ErrCode,ErrDescr,IPAddr) then
    begin
      GetStatusN707.ErrorCode:=ErrCode;
      GetStatusN707.ErrorDescription:=ErrDescr;
      GetStatusN707.IsError:=true;
      exit;
    end
    else
    begin
      GetStatusN707.currZ:=IntToStr(cgi_state.currZ);
    end;

    if GetJrnRoom(cgi_proc_getjrnroom,ErrCode,ErrDescr,IPAddr) then
    begin
      GetStatusN707.ErrorCode:=ErrCode;
      GetStatusN707.ErrorDescription:=ErrDescr;
      GetStatusN707.IsError:=true;
      exit;
    end
    else
    begin
      GetStatusN707.Used:=cgi_proc_getjrnroom.Used;
    end;
{
  TStatusN707 = record
    IsError: boolean;         //состояние EKKA: false - все нормально, можно работать (по умолчанию); true - какие-то проблемы с EKKA
                              //зависит от состояния ответов HTTP /cgi/status; /cgi/state; /cgi/dev_info и параметра /cgi/dev_info/dev_state
    ErrorCode: string;        //код ошибки EKKA, по умолчанию - пусто, IsError = false.
    ErrorDescription: string; //описание ошибки EKKA, по умолчанию - пусто, IsError = false.
    HTTPCode: integer;        //ответ HTTP. По умолчанию 200 - все в порядке, IsError = false.
    HTTPDescription: string;  //ответ HTTP. По умолчанию OK - все в порядке, IsError = false.

    //Наименование и адрес предприятия
    //признак зарегистрированого кассира
    chkId: string;            //номер последнего фискального чека               max(/cgi/chk/no) || /cgi/state/chkId
}
  end;
end;

function GetLastChkNo(pIPAddr: string; const IsFiscal: boolean = true): TChkNomber;      //получение номера последнего чека в чековой ленте
var
  u: ansistring;
  IsDeflated: boolean;
  V: Variant;
  os: TOLEStream;
  in_Stream: TMemoryStream;
  UnknownPtr: Pointer;
  NewSize: integer;
  curr_wide: WideString;
  memo: TMemo;
  ErrCode, ErrDescr: string; 
begin
  GetLastChkNo.ChkNumber:=-1;
  GetLastChkNo.ErrCode:='';
  GetLastChkNo.ErrMessage:='';
  ErrCode:='';
  ErrDescr:='';

  u:=PROTOCOL+pIPAddr+URI_CGI_STATUS;
  IsDeflated:=false;
  try
    Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
    Req.Open(METHOD_HEAD, u, true);
    Req.SetRequestHeader('Connection','Keep-Alive');
    Req.SetRequestHeader('Proxy-Connection','keep-alive');
    Req.Send();
    Req.WaitForResponse;
  except
    GetLastChkNo.ChkNumber:=-1;
    GetLastChkNo.ErrCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
    GetLastChkNo.ErrMessage:=TIMEOUT_ERROR_RESPONSE_520;
    exit;
  end;
  ParseDscResponseHeaders(Req.GetAllResponseHeaders);

  case Req.Status of //тут можно будет прописать конкретное поведение для каждого из полученых ответов от сервера
    100..199:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrCode,ErrDescr);
        GetLastChkNo.ChkNumber:=-1;
        GetLastChkNo.ErrCode:=ErrCode;
        GetLastChkNo.ErrMessage:=ErrDescr;
        //Result:=true;
      end;
    200..299:
      begin
        u:=PROTOCOL+pIPAddr+URI_CGI_CHK;
        IsDeflated:=false;
        //проверка доступности EKKA
        try
          Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
          Req.Open(METHOD_GET, u, true);
          Req.SetRequestHeader('Connection','Keep-Alive');
          Req.SetRequestHeader('Proxy-Connection','keep-alive');
          Req.SetCredentials(USERNAME_SERVICE,PASS_SERVICE,0);
          Req.Send();
          Req.WaitForResponse;
        except
          GetLastChkNo.ChkNumber:=-1;
          GetLastChkNo.ErrCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
          GetLastChkNo.ErrMessage:=TIMEOUT_ERROR_RESPONSE_520;
          exit;
        end;
        case Req.Status of
          100..199:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrCode,ErrDescr);
              GetLastChkNo.ChkNumber:=-1;
              GetLastChkNo.ErrCode:=ErrCode;
              GetLastChkNo.ErrMessage:=ErrDescr;
              //Result:=true;
            end;
          200..299:
            begin
              ParseDscResponseHeaders(Req.GetAllResponseHeaders);
              try
                V:=req.ResponseStream;
                TVarData(V).vType:=varUnknown;
                os:=TOLEStream.Create(IStream(TVarData(V).VUnknown));
                in_Stream:=TMemoryStream.Create;
                in_Stream.CopyFrom(os,os.Size);

                if Content_Encoding='deflate' then
                begin
                  try
                    in_Stream.Position := 0;
                    DeCompressBuf(in_stream.Memory, in_stream.Size, Content_Length, UnknownPtr, NewSize);
                    in_stream.Clear;
                    in_stream.Position := 0;
                    in_stream.Write(UnknownPtr^, NewSize);
                    in_stream.Position := 0;
                    in_stream.Size;
                  finally
                    FreeMem(UnknownPtr, NewSize);
                  end;
                    IsDeflated:=true;
                end;
              finally
                SetString(curr_wide,PChar(in_stream.Memory),in_stream.Size);
              end;

              try
                memo:=TMemo.Create(nil);
                if IsDeflated then
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,4,length(curr_wide)-3)))
                else
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,0,length(curr_wide))));
                memo.Text:=UTF8ToAnsi(memo.Text);
                if ParseCheckListRequest(memo.Text, IsFiscal) then
                begin
                  GetLastChkNo.ChkNumber:=cgi_chk.max_check_no;
                  GetLastChkNo.ErrCode:=cgi_chk.ErrorCode;
                  GetLastChkNo.ErrMessage:=cgi_chk.ErrorDescription;
                  exit;
                end;
              finally
                memo.Free;
              end;
              GetLastChkNo.ChkNumber:=cgi_chk.max_check_no;
              GetLastChkNo.ErrCode:='';
              GetLastChkNo.ErrMessage:='';
            end;
          300..599:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrCode,ErrDescr);
              GetLastChkNo.ChkNumber:=-1;
              GetLastChkNo.ErrCode:=ErrCode;
              GetLastChkNo.ErrMessage:=ErrDescr;
              //Result:=true;
            end;
        end;
      end;

    300..599:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrCode,ErrDescr);
        GetLastChkNo.ChkNumber:=-1;
        GetLastChkNo.ErrCode:=ErrCode;
        GetLastChkNo.ErrMessage:=ErrDescr;
        //Result:=true;
      end;
  end;
end;

function PrintCheck(const txt: string; out ErrorCode, ErrorDescription: string; out ResponsedReceipt: T_cgi_chk_object; pIPAddr: string): boolean;         //печать чека
var
  IsFiscal, IsInputOutput, IsCopy, IsReturn, IsNonFiscal: boolean;
  IsPercent, IsAll: boolean;
  sl: TStringList;
  s, substr, ss: string;
  ch: char;
  i, j: integer;
  p: integer;
  js: string;
  nums: set of '0'..'9';
  //для строки продажи (S) - чеки F и R
  _qty: double; //количество
  _price: Currency; //цена
  _name: string; //наименование
  _code: Longint; //код товара
  _tax: byte; //ставка налога
  //для строки скидки (D) - чеки F и R
  _sum: Currency;  // - сумма скидки или наценки. Положительное число описывает наценку. Отрицательное - скидку. Если поле присутствует в объекте, значит, строка чека является скидкой на сумму. Для процентных скидок поле должно отсутствовать.;
  _prc: double;  // - процент скидки или наценки. Положительное число описывает наценку. Отрицательное - скидку. Поле игнорируется, если объект имеет поле sum.;
  _all: Currency;  // - если присутствует и ненулевое - скидка производится на промежуточный итог.;
  _dn: Longint;  // - номер подтверждения льготной скидки. (Согласно требованиям НацБанка к системе передачи данных в ДПА)
  //для строки оплаты
  _no: byte; //Номер строки в таблице Pay, который соответствует типу выбранной оплаты. При отсутствии, происходит оплата наличными.;
  _rrn: Longint; //Номер транзакции (RRN) при осуществлении оплаты через банковский терминал.(Согласно требованиям НацБанка к системе передачи данных в ДПА).;
  _card: String; //Номер банковской карты при оплате через терминал

  u: ansistring;
  IsDeflated: boolean;
  V: Variant;
  os: TOLEStream;
  in_Stream: TMemoryStream;
  UnknownPtr: Pointer;
  NewSize: integer;
  curr_wide: WideString;
  memo: TMemo;
  receipt: T_cgi_chk_object;
  new_str: string;
begin
  ErrorCode:='';
  ErrorDescription:='';
  Result:=false;

//----------------------------------------************************************************************************

  nums:=['0'..'9'];
  IsFiscal:=false; IsInputOutput:=false; IsCopy:=false; IsReturn:=false; IsNonFiscal:=false;
  try
    sl:=TStringList.Create;
    sl.Text:=txt;
    s:=trim(sl.Strings[0]);
    ch:=s[1];
    if (LowerCase(ch)='f')or(trim(ch)='') then IsFiscal:=true else
      if LowerCase(ch)='r' then IsReturn:=true else
        if LowerCase(ch)='i' then IsInputOutput:=true else
          if LowerCase(ch)='p' then IsNonFiscal:=true else
            if LowerCase(ch)='l' then IsCopy:=true;
    sl.Delete(0);
    _qty:=1; _price:=0; _name:=''; _code:=0; _tax:=0;

    if IsFiscal then js:='{"F":['
    else
      if IsInputOutput then js:='{"IO":['
      else
        if IsCopy then js:='{"L":[' else
          if IsReturn then js:='{"R":[' else
            if IsNonFiscal then js:='{"P":[';
    for i:=0 to sl.Count-1 do
    begin
      if trim(sl.Strings[i]) <> '' then
      begin
        s:=sl.Strings[i];
        if s[1] in nums then
        begin
          //строка продажи "S"
          substr:=s;
          if pos('*',substr)>0 then
          begin
            delete(substr,pos('*',substr),length(substr));
            try
              _qty:=StrToFloat(substr);
            except
              _qty:=1;
            end;
            delete(s,1,pos('*',s));
          end;

          substr:=trim(s);
          if pos(' "',substr)>0 then
          begin
            Delete(substr,pos(' "',substr),length(substr));
            try
              _price:=StrToCurr(substr);
            except
              _price:=0;
            end;
            delete(s,1,pos(' "',s));
          end;

          s:=trim(s);
          substr:=trim(s);
          if (pos('" ',substr)>0) then
          begin
            p:=0;
            new_str:='';
            repeat// while not substr[pos('" ',substr)+2] in nums do
              if substr[pos('" ',substr)+2] in nums then
                p:=length(new_str)+pos('" ',substr)+1;
              new_str:=new_str+copy(substr,1,pos('" ',substr));
              delete(substr,1,length(new_str));
            until substr[pos('" ',substr)+2] in nums;
            if substr[pos('" ',substr)+2] in nums then
              p:=length(new_str)+pos('" ',substr)+1;
            new_str:=new_str+copy(substr,1,pos('" ',substr));

            substr:=trim(s);
            delete(substr,1,length(new_str)+1);
            _name:=trim(new_str);
          end;

          delete(s,1,length(_name)); //correct VAT 20% + 7%
//          delete(s,1,length(_name)); //all VAT 20%
          substr:=trim(s);
          if pos(' ',substr)>0 then
          begin
            Delete(substr,pos(' ',substr),length(substr));
            try
              _code:=StrToInt64(substr);
            except
              _code:=0;
            end;
            delete(s,1,length(substr)+1);  //correct VAT 20% + 7%
//          delete(s,1,pos(' ',s));  //all VAT 20%
          end;

          substr:=trim(s);
          if trim(substr)<>'' then
          begin
            try
              _tax:=StrToInt(substr);
            except
              _tax:=0;
            end;
          end;

          ss:=FloatToStr(_qty);
          if Pos(',',ss)>0 then ss:=StringReplace(ss,',','.',[rfReplaceAll]);
          js:=js+'{"S":{"qty":'+ss;
          ss:=CurrToStr(_price);
          if pos(',',ss)>0 then ss:=StringReplace(ss,',','.',[rfReplaceAll]);
          js:=js+',"price":'+ss+',"name":'+_name+',"code":'+IntToStr(_code);
          ss:=FloatToStr(_tax);
          if Pos(',',ss)>0 then ss:=StringReplace(ss,',','.',[rfReplaceAll]);
          if _tax<>0 then js:=js+',"tax":'+ss+'}}' else js:=js+'}}';
        //end строка продажи "S"
        end
        else
        begin
          IsPercent:=false; IsAll:=false; //IsNegative:=false;
          if (s[1]='+')or(s[1]='-')or(s[1]='=') then
          begin
          //строка скидки "D"
            _sum:=0; _prc:=0; _all:=0; _dn:=0;
            substr:=trim(s);
            if pos(';',substr)>0 then
            begin
              Delete(substr,pos(';',substr),length(substr));
              substr:=trim(substr);
            end;
            if pos('%',substr)>0 then IsPercent:=true;
            if pos('=',substr)>0 then IsAll:=true;

            if (not IsPercent)and(not IsAll) then
            begin
              _all:=0;
              try
                _sum:=StrToCurr(trim(substr));
              except
                _sum:=0;
              end;
              Delete(s,1,length(substr));
            end //if (not IsPercent)and(not IsAll) then
            else
            begin
              if (not IsPercent)and(IsAll) then
              begin
                delete(substr,pos('=',substr),1);
                _all:=1;
                try
                  _sum:=StrToCurr(trim(substr));
                except
                  _sum:=0;
                end;
                Delete(s,pos(';',substr),length(substr)+1);
              end //if (not IsPercent)and(IsAll) then
              else
              begin
                if (IsPercent)and(not IsAll) then
                begin
                  delete(substr,pos('%',substr),1);
                  _all:=0;
                  try
                    _prc:=StrToFloat(trim(substr));
                  except
                    _prc:=0;
                  end;
                  Delete(s,pos(';',substr),length(substr)+1);
                end //if (IsPercent)and(not IsAll) then
                else
                begin
                  if (IsPercent)and(IsAll) then
                  begin
                    delete(substr,pos('%',substr),1);
                    delete(substr,pos('=',substr),1);
                    _all:=1;
                    try
                      _prc:=StrToFloat(trim(substr));
                    except
                      _prc:=0;
                    end;
                    Delete(s,pos(';',substr),length(substr)+1);
                  end  //if (IsPercent)and(IsAll) then
                  else
                  begin
                  end; //else if (IsPercent)and(IsAll) then
                end; //else if (IsPercent)and(not IsAll) then
              end// else if (not IsPercent)and(IsAll) then
            end; //else if (not IsPercent)and(not IsAll) then

            ss:=CurrToStr(_sum);
            if Pos(',',ss)>0 then ss:=StringReplace(ss,',','.',[rfReplaceAll]);
            js:=js+'{"D":{"sum":'+ss;

            ss:=CurrToStr(_all);
            if Pos(',',ss)>0 then ss:=StringReplace(ss,',','.',[rfReplaceAll]);
            if IsAll then js:=js+',"all":'+ss;
            if _dn<>0 then js:=js+',"dn":'+IntToStr(_dn)+'}}' else js:=js+'}}';
          //end строка скидки "D"
          end
          else
          begin
            if s[1]='"' then
            begin
              substr:=trim(s);
            //строка нефискального коментария "N"
              delete(substr,pos('"',substr),1);
              js:=js+'{"N":{"cm":"'+substr+'","attr":"l"}}';
            //end строка нефискального коментария "N"
            end
            else
            begin
              //строка оплаты "P"
              if s[1]='$' then
              begin
                _sum:=0; _no:=0; _rrn:=0; _card:='';
                delete(s,1,1);
                if length(trim(s))>0 then
                begin
                  substr:=trim(s);
                  delete(substr,pos(';',substr),length(substr));
                  try
                    _sum:=StrToCurr(substr);
                  except
                    _sum:=0;
                  end;
                  delete(s,1,length(substr));
                  if Length(trim(s))>0 then
                  begin
                    substr:=trim(s);
                    delete(substr,pos(';',substr),length(substr));
                    try
                      _no:=StrToInt(substr);
                    except
                      _no:=0;
                    end;
                    delete(s,1,length(substr));
                    if length(trim(s))>0 then
                    begin
                      substr:=trim(s);
                      delete(substr,pos(';',substr),length(substr));
                      try
                        _rrn:=StrToInt(substr);
                      except
                        _rrn:=0;
                      end;
                      delete(s,1,length(substr));
                      if length(trim(s))>0 then
                      begin
                        substr:=trim(s);
                        _card:=substr;
                      end;
                    end;
                  end;
                end;
              end;
              ss:=CurrToStr(_sum);
              if Pos(',',ss)>0 then ss:=StringReplace(ss,',','.',[rfReplaceAll]);
              js:=js+'{"P":{"sum":'+ss;
              if _no>0 then js:=js+',"no":'+IntToStr(_no);
              if _rrn>0 then js:=js+',"rrn":'+IntToStr(_rrn);
              if trim(_card)<>'' then js:=js+',"card":'+_card;
              js:=js+'}}';
              //end строка оплаты "P"
            end;
          end;
        end;
      end;
      if (i<sl.Count-1) then js:=js+',';
    end;
  finally
    sl.Free;
  end;
  if js[length(js)]=',' then delete(js,length(js),1);
  js:=js+']}';

//----------------------------------------************************************************************************

  u:=PROTOCOL+pIPAddr+URI_CGI_STATUS;
  IsDeflated:=false;
  try
    Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
    Req.Open(METHOD_HEAD, u, true);
    Req.SetRequestHeader('Connection','Keep-Alive');
    Req.SetRequestHeader('Proxy-Connection','keep-alive');
    Req.Send();
    Req.WaitForResponse;
  except
    ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
    ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
    exit;
  end;
  ParseDscResponseHeaders(Req.GetAllResponseHeaders);
  case Req.Status of //тут можно будет прописать конкретное поведение для каждого из полученых ответов от сервера
    100..199:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
    200..299:
      begin
        u:=PROTOCOL+pIPAddr+URI_CGI_CHK;
        IsDeflated:=false;
        try
          Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
          Req.Open(METHOD_POST, u, true);
          Req.SetRequestHeader('Connection','Keep-Alive');
          Req.SetRequestHeader('Proxy-Connection','keep-alive');
          Req.SetCredentials(USERNAME_SERVICE,PASS_SERVICE,0);
          Req.Send(js);
          Req.WaitForResponse;
        except
          ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
          ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
          Result:=true;
          exit;
        end;
        case Req.Status of
          100..199:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
          200..299:
            begin
              ParseDscResponseHeaders(Req.GetAllResponseHeaders);
              try
                V:=req.ResponseStream;
                TVarData(V).vType:=varUnknown;
                os:=TOLEStream.Create(IStream(TVarData(V).VUnknown));
                in_Stream:=TMemoryStream.Create;
                in_Stream.CopyFrom(os,os.Size);

                if Content_Encoding='deflate' then
                begin
                  try
                    in_Stream.Position := 0;
                    DeCompressBuf(in_stream.Memory, in_stream.Size, Content_Length, UnknownPtr, NewSize);
                    in_stream.Clear;
                    in_stream.Position := 0;
                    in_stream.Write(UnknownPtr^, NewSize);
                    in_stream.Position := 0;
                    in_stream.Size;
                  finally
                    FreeMem(UnknownPtr, NewSize);
                  end;
                    IsDeflated:=true;
                end;
              finally
                SetString(curr_wide,PChar(in_stream.Memory),in_stream.Size);
              end;

              try
                memo:=TMemo.Create(nil);
                if IsDeflated then
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,4,length(curr_wide)-3)))
                else
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,0,length(curr_wide))));
                memo.Text:=UTF8ToAnsi(memo.Text);
                if ParsePrintCheckRequest(memo.Text,receipt) then
                begin
                  ErrorCode:=DEV_STATE_ERROR_CODE_CANNOT_PRINT_CHECK;
                  ErrorDescription:=DEV_STATE_ERROR_DESCRIPTION_CANNOT_PRINT_CHECK;
                  Result:=true;
                  exit;
                end
                else
                begin
                  ResponsedReceipt:=receipt;
                end;
              finally
                memo.Free;
              end;
            end;
          300..599:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
        end;
      end;

    300..599:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
  end;
end;

function PrintZerroCheck(out ErrorCode, ErrorDescription: string; out ResponsedReceipt: T_cgi_chk_object; pIPAddr: string): boolean;      //печать нулевого чека
var
  s: TStringList;
  u: ansistring;
  IsDeflated: boolean;
  V: Variant;
  os: TOLEStream;
  in_Stream: TMemoryStream;
  UnknownPtr: Pointer;
  NewSize: integer;
  curr_wide: WideString;
  memo: TMemo;
  receipt: T_cgi_chk_object;
begin
  Result:=false; //нулевой чек напечатан успешно
  ErrorCode:='';
  ErrorDescription:='';

  u:=PROTOCOL+pIPAddr+URI_CGI_STATUS;
  IsDeflated:=false;
  try
    Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
    Req.Open(METHOD_HEAD, u, true);
    Req.SetRequestHeader('Connection','Keep-Alive');
    Req.SetRequestHeader('Proxy-Connection','keep-alive');
    Req.Send();
    Req.WaitForResponse;
  except
    ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
    ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
    Result:=true;
    exit;
  end;
  ParseDscResponseHeaders(Req.GetAllResponseHeaders);

  case Req.Status of //тут можно будет прописать конкретное поведение для каждого из полученых ответов от сервера
    100..199:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
    200..299:
      begin
        ErrorCode:='';
        ErrorDescription:='';
        s:=TStringList.Create;
        s.Text:='{"F":[{"N":{"cm":""}}]}';
        u:=PROTOCOL+pIPAddr+URI_CGI_CHK;
        IsDeflated:=false;
        try
          Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
          Req.Open(METHOD_POST, u, true);
          Req.SetRequestHeader('Connection','Keep-Alive');
          Req.SetRequestHeader('Proxy-Connection','keep-alive');
          Req.SetCredentials(USERNAME_SERVICE,PASS_SERVICE,0);
          Req.Send(s.Text);
          Req.WaitForResponse;
        except
          ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
          ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
          s.Free;
          Result:=true;
          exit;
        end;
        s.Free;

        case Req.Status of
          100..199:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
          200..299:
            begin
              ParseDscResponseHeaders(Req.GetAllResponseHeaders);
              try
                V:=req.ResponseStream;
                TVarData(V).vType:=varUnknown;
                os:=TOLEStream.Create(IStream(TVarData(V).VUnknown));
                in_Stream:=TMemoryStream.Create;
                in_Stream.CopyFrom(os,os.Size);

                if Content_Encoding='deflate' then
                begin
                  try
                    in_Stream.Position := 0;
                    DeCompressBuf(in_stream.Memory, in_stream.Size, Content_Length, UnknownPtr, NewSize);
                    in_stream.Clear;
                    in_stream.Position := 0;
                    in_stream.Write(UnknownPtr^, NewSize);
                    in_stream.Position := 0;
                    in_stream.Size;
                  finally
                    FreeMem(UnknownPtr, NewSize);
                  end;
                    IsDeflated:=true;
                end;
              finally
                SetString(curr_wide,PChar(in_stream.Memory),in_stream.Size);
              end;

              try
                memo:=TMemo.Create(nil);
                if IsDeflated then
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,4,length(curr_wide)-3)))
                else
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,0,length(curr_wide))));
                memo.Text:=UTF8ToAnsi(memo.Text);
                if ParsePrintCheckRequest(memo.Text,receipt) then
                begin
                  ErrorCode:=DEV_STATE_ERROR_CODE_CANNOT_PRINT_CHECK;
                  ErrorDescription:=DEV_STATE_ERROR_DESCRIPTION_CANNOT_PRINT_CHECK;
                  Result:=true;
                  exit;
                end
                else
                begin
                  ResponsedReceipt:=receipt;
                end;
              finally
                memo.Free;
              end;
            end;
          300..599:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
        end;
      end;

    300..599:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
  end;
end;

function PrintZXReport(pIPAddr: string; const ReportNom: integer; out ErrorCode, ErrorDescription: string; out ReceiptList: T_cgi_chk; const flFiscal: boolean = true): boolean;        //печать отчетов Z и X
var
  u: ansistring;
  IsDeflated: boolean;
  V: Variant;
  os: TOLEStream;
  in_Stream: TMemoryStream;
  UnknownPtr: Pointer;
  NewSize: integer;
  curr_wide: WideString;
  memo: TMemo;
begin
  Result:=true;  //отчет напечатан успешно
  ErrorCode:='';
  ErrorDescription:='';

  u:=PROTOCOL+pIPAddr+URI_CGI_STATUS;
  IsDeflated:=false;
  try
    Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
    Req.Open(METHOD_HEAD, u, true);
    Req.SetRequestHeader('Connection','Keep-Alive');
    Req.SetRequestHeader('Proxy-Connection','keep-alive');
    Req.Send();
    Req.WaitForResponse;
  except
    ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
    ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
    Result:=false;
    exit;
  end;
  ParseDscResponseHeaders(Req.GetAllResponseHeaders);

  case Req.Status of //тут можно будет прописать конкретное поведение для каждого из полученых ответов от сервера
    100..199:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
    200..299:
      begin
        //получение и запись в массив чековой ленты
        u:=PROTOCOL+pIPAddr+URI_CGI_CHK;
        IsDeflated:=false;
        //проверка доступности EKKA
        try
          Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
          Req.Open(METHOD_GET, u, true);
          Req.SetRequestHeader('Connection','Keep-Alive');
          Req.SetRequestHeader('Proxy-Connection','keep-alive');
          Req.SetCredentials(USERNAME_SERVICE,PASS_SERVICE,0);
          Req.Send();
          Req.WaitForResponse;
        except
          ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
          ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
          Result:=false;
          exit;
        end;
        case Req.Status of
          100..199:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
          200..299:
            begin
              ParseDscResponseHeaders(Req.GetAllResponseHeaders);
              try
                V:=req.ResponseStream;
                TVarData(V).vType:=varUnknown;
                os:=TOLEStream.Create(IStream(TVarData(V).VUnknown));
                in_Stream:=TMemoryStream.Create;
                in_Stream.CopyFrom(os,os.Size);

                if Content_Encoding='deflate' then
                begin
                  try
                    in_Stream.Position := 0;
                    DeCompressBuf(in_stream.Memory, in_stream.Size, Content_Length, UnknownPtr, NewSize);
                    in_stream.Clear;
                    in_stream.Position := 0;
                    in_stream.Write(UnknownPtr^, NewSize);
                    in_stream.Position := 0;
                    in_stream.Size;
                  finally
                    FreeMem(UnknownPtr, NewSize);
                  end;
                    IsDeflated:=true;
                end;
              finally
                SetString(curr_wide,PChar(in_stream.Memory),in_stream.Size);
              end;

              try
                memo:=TMemo.Create(nil);
                if IsDeflated then
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,4,length(curr_wide)-3)))
                else
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,0,length(curr_wide))));
                memo.Text:=UTF8ToAnsi(memo.Text);
                if ParseCheckListRequest(memo.Text, flFiscal) then
                begin
                  ErrorCode:=cgi_chk.ErrorCode;
                  ErrorDescription:=cgi_chk.ErrorDescription;
                  exit;
                end;
              finally
                ReceiptList:=cgi_chk;
                memo.Free;
              end;
              ErrorCode:='';
              ErrorDescription:='';
              Result:=true;
            end;
          300..599:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
        end;

        //печать Z-X-отчета
        Result:=false;  //отчет напечатан успешно
        ErrorCode:='';
        ErrorDescription:='';

        u:=PROTOCOL+pIPAddr+URI_CGI_PROC_PRINTREPORT+'?'+IntToStr(ReportNom);
        IsDeflated:=false;
        try
          Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
          Req.Open(METHOD_GET, u, true);
          Req.SetRequestHeader('Connection','Keep-Alive');
          Req.SetRequestHeader('Proxy-Connection','keep-alive');
          Req.SetCredentials(USERNAME_SERVICE,PASS_SERVICE,0);
          Req.Send();
          Req.WaitForResponse;
        except
          ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
          ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
          Result:=false;
          exit;
        end;

        case Req.Status of
          100..199:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
          200..299:
            begin
              ParseDscResponseHeaders(Req.GetAllResponseHeaders);
              try
                V:=req.ResponseStream;
                TVarData(V).vType:=varUnknown;
                os:=TOLEStream.Create(IStream(TVarData(V).VUnknown));
                in_Stream:=TMemoryStream.Create;
                in_Stream.CopyFrom(os,os.Size);

                if Content_Encoding='deflate' then
                begin
                  try
                    in_Stream.Position := 0;
                    DeCompressBuf(in_stream.Memory, in_stream.Size, Content_Length, UnknownPtr, NewSize);
                    in_stream.Clear;
                    in_stream.Position := 0;
                    in_stream.Write(UnknownPtr^, NewSize);
                    in_stream.Position := 0;
                    in_stream.Size;
                  finally
                    FreeMem(UnknownPtr, NewSize);
                  end;
                    IsDeflated:=true;
                end;
              finally
                SetString(curr_wide,PChar(in_stream.Memory),in_stream.Size);
              end;

              try
                memo:=TMemo.Create(nil);
                if IsDeflated then
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,4,length(curr_wide)-3)))
                else
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,0,length(curr_wide))));
                memo.Text:=UTF8ToAnsi(memo.Text);
                if ParsePrintZXReport(memo.Text) then
                begin
                  ErrorCode:=DEV_STATE_ERROR_CODE_CANNOT_PRINT_CHECK;
                  ErrorDescription:=DEV_STATE_ERROR_DESCRIPTION_CANNOT_PRINT_CHECK;
                  Result:=false;
                  exit;
                end;
              finally
                memo.Free;
              end;
            end;
          300..599:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
        end;
      end;

    300..599:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
  end;
end;

function SetClock(const _dt: TDateTime; out ErrorCode, ErrorDescription: string; pIPAddr: string): boolean; //установка даты и времени на устройстве
var
  u: ansistring;
  IsDeflated: boolean;
  V: Variant;
  os: TOLEStream;
  in_Stream: TMemoryStream;
  UnknownPtr: Pointer;
  NewSize: integer;
  curr_wide: WideString;
  memo: TMemo;
begin
  Result:=false;  //время установлено
  ErrorCode:='';
  ErrorDescription:='';

  u:=PROTOCOL+pIPAddr+URI_CGI_STATUS;
  IsDeflated:=false;
  try
    Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
    Req.Open(METHOD_HEAD, u, true);
    Req.SetRequestHeader('Connection','Keep-Alive');
    Req.SetRequestHeader('Proxy-Connection','keep-alive');
    Req.Send();
    Req.WaitForResponse;
  except
    ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
    ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
    Result:=true;
    exit;
  end;
  ParseDscResponseHeaders(Req.GetAllResponseHeaders);

  case Req.Status of //тут можно будет прописать конкретное поведение для каждого из полученых ответов от сервера
    100..199:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
    200..299:
      begin
        u:=PROTOCOL+pIPAddr+URI_CGI_PROC_SETCLOCK+'?'+FormatDateTime('YYYY-MM-DD',_dt)+'T'+FormatDateTime('HH:MM:SS',_dt);
        IsDeflated:=false;
        try
          Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
          Req.Open(METHOD_GET, u, true);
          Req.SetRequestHeader('Connection','Keep-Alive');
          Req.SetRequestHeader('Proxy-Connection','keep-alive');
          Req.SetCredentials(USERNAME_SERVICE,PASS_SERVICE,0);
          Req.Send();
          Req.WaitForResponse;
        except
          ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
          ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
          Result:=true;
          exit;
        end;

        case Req.Status of
          100..199:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
          200..299:
            begin
              ParseDscResponseHeaders(Req.GetAllResponseHeaders);
              try
                V:=req.ResponseStream;
                TVarData(V).vType:=varUnknown;
                os:=TOLEStream.Create(IStream(TVarData(V).VUnknown));
                in_Stream:=TMemoryStream.Create;
                in_Stream.CopyFrom(os,os.Size);

                if Content_Encoding='deflate' then
                begin
                  try
                    in_Stream.Position := 0;
                    DeCompressBuf(in_stream.Memory, in_stream.Size, Content_Length, UnknownPtr, NewSize);
                    in_stream.Clear;
                    in_stream.Position := 0;
                    in_stream.Write(UnknownPtr^, NewSize);
                    in_stream.Position := 0;
                    in_stream.Size;
                  finally
                    FreeMem(UnknownPtr, NewSize);
                  end;
                  IsDeflated:=true;
                end;
              finally
                SetString(curr_wide,PChar(in_stream.Memory),in_stream.Size);
              end;

              try
                memo:=TMemo.Create(nil);
                if IsDeflated then
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,4,length(curr_wide)-3)))
                else
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,0,length(curr_wide))));
                memo.Text:=UTF8ToAnsi(memo.Text);
                if ParseSetClock(memo.Text) then
                begin
                  ErrorCode:=DEV_STATE_ERROR_CODE_CANNOT_SET_CLOCK;
                  ErrorDescription:=DEV_STATE_ERROR_DESCRIPTION_CANNOT_SET_CLOCK;
                  Result:=true;
                  exit;
                end;
              finally
                memo.Free;
              end;
            end;
          300..599:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
        end;
      end;

    300..599:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
  end;
end;

function CashInputOutput(const Sum: Double; out ErrorCode, ErrorDescription: string; out ResponsedReceipt: T_cgi_chk_object; pIPAddr: string): boolean; //служебное внесение / изъятие
var
  u: ansistring;
  IsDeflated: boolean;
  s, ss: string;
  V: Variant;
  os: TOLEStream;
  in_Stream: TMemoryStream;
  UnknownPtr: Pointer;
  NewSize: integer;
  curr_wide: WideString;
  memo: TMemo;
  receipt: T_cgi_chk_object;
begin
  //передавать JSON
  //проверять остаток в кассе
  //контроллировать сумму изъятия (отрицательная сумма). должна быть не больше, чем есть в кассе
  //формат JSON: {"IO":[{"IO":{"sum":-50}}]}

  u:=PROTOCOL+pIPAddr+URI_CGI_STATUS;
  IsDeflated:=false;
  try
    Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
    Req.Open(METHOD_HEAD, u, true);
    Req.SetRequestHeader('Connection','Keep-Alive');
    Req.SetRequestHeader('Proxy-Connection','keep-alive');
    Req.Send();
    Req.WaitForResponse;
  except
    ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
    ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
    Result:=true;
    exit;
  end;
  ParseDscResponseHeaders(Req.GetAllResponseHeaders);

  case Req.Status of //тут можно будет прописать конкретное поведение для каждого из полученых ответов от сервера
    100..199:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
    200..299:
      begin
        Result:=false;  //служебное внесение/узьятие удачное
        ErrorCode:='';
        ErrorDescription:='';
        ss:=CurrToStr(Sum);
        if Pos(',',ss)>0 then ss:=StringReplace(ss,',','.',[rfReplaceAll]);
        s:='{"IO":[{"IO":{"sum":'+ss+'}}]}';

        u:=PROTOCOL+pIPAddr+URI_CGI_CHK;//+'?'+CurrToStr(Sum);
        IsDeflated:=false;
        try
          Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
          Req.Open(METHOD_POST, u, true);
          Req.SetRequestHeader('Connection','Keep-Alive');
          Req.SetRequestHeader('Proxy-Connection','keep-alive');
          Req.SetCredentials(USERNAME_SERVICE,PASS_SERVICE,0);
          Req.Send(s);
          Req.WaitForResponse;
        except
          ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
          ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
          Result:=true;
          exit;
        end;

        case Req.Status of
          100..199:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
          200..299:
            begin
              ParseDscResponseHeaders(Req.GetAllResponseHeaders);
              try
                V:=req.ResponseStream;
                TVarData(V).vType:=varUnknown;
                os:=TOLEStream.Create(IStream(TVarData(V).VUnknown));
                in_Stream:=TMemoryStream.Create;
                in_Stream.CopyFrom(os,os.Size);

                if Content_Encoding='deflate' then
                begin
                  try
                    in_Stream.Position := 0;
                    DeCompressBuf(in_stream.Memory, in_stream.Size, Content_Length, UnknownPtr, NewSize);
                    in_stream.Clear;
                    in_stream.Position := 0;
                    in_stream.Write(UnknownPtr^, NewSize);
                    in_stream.Position := 0;
                    in_stream.Size;
                  finally
                    FreeMem(UnknownPtr, NewSize);
                  end;
                    IsDeflated:=true;
                end;
              finally
                SetString(curr_wide,PChar(in_stream.Memory),in_stream.Size);
              end;

              try
                memo:=TMemo.Create(nil);
                if IsDeflated then
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,4,length(curr_wide)-3)))
                else
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,0,length(curr_wide))));
                memo.Text:=UTF8ToAnsi(memo.Text);
                if ParsePrintCheckRequest(memo.Text,receipt) then
                begin
                  ErrorCode:=DEV_STATE_ERROR_CODE_CANNOT_INPUT_OUTPUT_CASH;
                  ErrorDescription:=DEV_STATE_ERROR_DESCRIPTION_CANNOT_INPUT_OUTPUT_CASH;
                  Result:=true;
                  exit;
                end
                else
                begin
                  ResponsedReceipt:=receipt;
                end;
              finally
                memo.Free;
              end;
            end;
          300..599:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
        end;
      end;

    300..599:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
  end;
end;

function Sound(const Hz, Ms: Integer; out ErrorCode, ErrorDescription: string; pIPAddr: string):boolean; //воспроизведение звука аппаратом
var
  u: ansistring;
  IsDeflated: boolean;
  V: Variant;
  s: string;
  os: TOLEStream;
  in_Stream: TMemoryStream;
  curr_wide: WideString;
  UnknownPtr: Pointer;
  NewSize: integer;
  memo: TMemo;
begin
  u:=PROTOCOL+pIPAddr+URI_CGI_STATUS;
  IsDeflated:=false;
  try
    Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
    Req.Open(METHOD_HEAD, u, true);
    Req.SetRequestHeader('Connection','Keep-Alive');
    Req.SetRequestHeader('Proxy-Connection','keep-alive');
    Req.Send();
    Req.WaitForResponse;
  except
    ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
    ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
    Result:=true;
    exit;
  end;
  ParseDscResponseHeaders(Req.GetAllResponseHeaders);

  case Req.Status of //тут можно будет прописать конкретное поведение для каждого из полученых ответов от сервера
    100..199:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
    200..299:
      begin
        Result:=false;  //звук воспроизведен
        ErrorCode:='';
        ErrorDescription:='';

        u:=PROTOCOL+pIPAddr+URI_CGI_PROC_SOUND+'?'+IntToStr(Hz)+'&'+IntToStr(Ms);
        IsDeflated:=false;
        try
          Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
          Req.Open(METHOD_POST, u, true);
          Req.SetRequestHeader('Connection','Keep-Alive');
          Req.SetRequestHeader('Proxy-Connection','keep-alive');
          Req.SetCredentials(USERNAME_SERVICE,PASS_SERVICE,0);
          Req.Send(s);
          Req.WaitForResponse;
        except
          ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
          ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
          Result:=true;
          exit;
        end;

        case Req.Status of
          100..199:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
          200..299:
            begin
              ParseDscResponseHeaders(Req.GetAllResponseHeaders);
              try
                V:=req.ResponseStream;
                TVarData(V).vType:=varUnknown;
                os:=TOLEStream.Create(IStream(TVarData(V).VUnknown));
                in_Stream:=TMemoryStream.Create;
                in_Stream.CopyFrom(os,os.Size);

                if Content_Encoding='deflate' then
                begin
                  try
                    in_Stream.Position := 0;
                    DeCompressBuf(in_stream.Memory, in_stream.Size, Content_Length, UnknownPtr, NewSize);
                    in_stream.Clear;
                    in_stream.Position := 0;
                    in_stream.Write(UnknownPtr^, NewSize);
                    in_stream.Position := 0;
                    in_stream.Size;
                  finally
                    FreeMem(UnknownPtr, NewSize);
                  end;
                    IsDeflated:=true;
                end;
              finally
                SetString(curr_wide,PChar(in_stream.Memory),in_stream.Size);
              end;
              try
                memo:=TMemo.Create(nil);
                if IsDeflated then
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,4,length(curr_wide)-3)))
                else
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,0,length(curr_wide))));
                memo.Text:=UTF8ToAnsi(memo.Text);
                if ParseSoundRequest(memo.Text) then
                begin
                  ErrorCode:=DEV_NO_SOUND_HEARD_CODE;
                  ErrorDescription:=DEV_NO_SOUND_HEARD_DESCRIPTION;
                  Result:=true;
                  exit;
                end;
              finally
                memo.Free;
              end;
            end;
          300..599:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
        end;
      end;

    300..599:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
  end;
end;

function GetCashState(out CshStt: string; out ErrorCode, ErrorDescription: string; pIPAddr: string): boolean; //состояние наличности в кассе
var
  u: ansistring;
  IsDeflated: boolean;
  V: Variant;
  os: TOLEStream;
  in_Stream: TMemoryStream;
  curr_wide: WideString;
  UnknownPtr: Pointer;
  NewSize: integer;
  memo: TMemo;
  ch: TStringList;
  i, j: integer;

  StartingBalance: Currency; //0 начальный остаток
  ServiceAppendix: Currency; //1 служебное внесение
  ServiceSeizure: Currency; //2 служебное изъятие
  ReceivedFromCustomer: Currency; //3 получено от клиента нал.
  IssuedToCustomer: Currency; //4 выдано клиенту нал.
  FinalBalance: Currency; //5 конечный остаток
  NonCashPayment: Currency; //6 безналичная оплата
  NonCashRefund: Currency; //7 безналичный возврат
begin
  u:=PROTOCOL+pIPAddr+URI_CGI_STATUS;
  IsDeflated:=false;
  try
    Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
    Req.Open(METHOD_HEAD, u, true);
    Req.SetRequestHeader('Connection','Keep-Alive');
    Req.SetRequestHeader('Proxy-Connection','keep-alive');
    Req.Send();
    Req.WaitForResponse;
  except
    ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
    ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
    Result:=true;
    exit;
  end;
  ParseDscResponseHeaders(Req.GetAllResponseHeaders);

  case Req.Status of //тут можно будет прописать конкретное поведение для каждого из полученых ответов от сервера
    100..199:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
    200..299:
      begin
        Result:=true;  //кассовая лента получена
        ErrorCode:='';
        ErrorDescription:='';

        u:=PROTOCOL+pIPAddr+URI_CGI_CHK;
        IsDeflated:=false;
        try
          Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
          Req.Open(METHOD_GET, u, true);
          Req.SetRequestHeader('Connection','Keep-Alive');
          Req.SetRequestHeader('Proxy-Connection','keep-alive');
          Req.SetCredentials(USERNAME_SERVICE,PASS_SERVICE,0);
          Req.Send();
          Req.WaitForResponse;
        except
          ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
          ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
          Result:=false;
          exit;
        end;

        case Req.Status of
          100..199:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
          200..299:
            begin
              ParseDscResponseHeaders(Req.GetAllResponseHeaders);
              try
                V:=req.ResponseStream;
                TVarData(V).vType:=varUnknown;
                os:=TOLEStream.Create(IStream(TVarData(V).VUnknown));
                in_Stream:=TMemoryStream.Create;
                in_Stream.CopyFrom(os,os.Size);

                if Content_Encoding='deflate' then
                begin
                  try
                    in_Stream.Position := 0;
                    DeCompressBuf(in_stream.Memory, in_stream.Size, Content_Length, UnknownPtr, NewSize);
                    in_stream.Clear;
                    in_stream.Position := 0;
                    in_stream.Write(UnknownPtr^, NewSize);
                    in_stream.Position := 0;
                    in_stream.Size;
                  finally
                    FreeMem(UnknownPtr, NewSize);
                  end;
                    IsDeflated:=true;
                end;
              finally
                SetString(curr_wide,PChar(in_stream.Memory),in_stream.Size);
              end;
              try
                memo:=TMemo.Create(nil);
                if IsDeflated then
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,4,length(curr_wide)-3)))
                else
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,0,length(curr_wide))));
                memo.Text:=UTF8ToAnsi(memo.Text);
                if ParseCheckListRequest(memo.Text) then
                begin
                  ErrorCode:=EMPTY_RECEIPT_LINE_CODE;
                  ErrorDescription:=EMPTY_RECEIPT_LINE_DESCRIPTION;
                  Result:=false;
                  exit;
                end
                else
                begin
                  try
                    StartingBalance:=0;
                    ServiceAppendix:=0;
                    ServiceSeizure:=0;
                    ReceivedFromCustomer:=0;
                    IssuedToCustomer:=0;
                    FinalBalance:=0;
                    NonCashPayment:=0;
                    NonCashRefund:=0;

                    ch:=TStringList.Create;
                    for i:=0 to 7 do ch.Add('0'); //0 начальный остаток - StartingBalance; 1 служебное внесение - ServiceAppendix; 2 служебное изъятие - ServiceSeizure; 3 получено от клиента нал. - ReceivedFromCustomer; 4 выдано клиенту нал. - IssuedToCustomer; 5 конечный остаток - FinalBalance; 6 безналичная оплата - NonCashPayment; 7 безналичный возврат - NonCashRefund
                    //0 начальный остаток - StartingBalance
                    StartingBalance:=0;
                    for i:=0 to Length(cgi_chk.cgi_chk_object)-1 do
                    begin
                      //1 служебное внесение        - ServiceAppendix
                      if Length(cgi_chk.cgi_chk_object[i].IO) > 0 then
                      begin
                        for j:=0 to length(cgi_chk.cgi_chk_object[i].IO)-1 do
                        begin
                          if cgi_chk.cgi_chk_object[i].IO[j].sum > 0 then
                            ServiceAppendix:=ServiceAppendix+abs(cgi_chk.cgi_chk_object[i].IO[j].sum)
                          else
                            //2 служебное изъятие         - ServiceSeizure
                            if cgi_chk.cgi_chk_object[i].IO[j].sum < 0 then
                              ServiceSeizure:=ServiceSeizure+abs(cgi_chk.cgi_chk_object[i].IO[j].sum);
                        end; //for j:=0 to length(cgi_chk.cgi_chk_object[i].IO) do
                      end; //if Length(cgi_chk.cgi_chk_object[i].IO) > 0 then

                      //3 получено от клиента нал.  - ReceivedFromCustomer
                      if length(cgi_chk.cgi_chk_object[i].F) > 0 then
                      begin
                        for j:=0 to length(cgi_chk.cgi_chk_object[i].F)-1 do
                        begin
                          if cgi_chk.cgi_chk_object[i].F[j].P.no = 1 then
                            ReceivedFromCustomer:=ReceivedFromCustomer+cgi_chk.cgi_chk_object[i].F[j].S.sum+cgi_chk.cgi_chk_object[i].F[j].D.sum;
                        end; //for j:=0 to length(cgi_chk.cgi_chk_object[i].F) do
                      end; //if cgi_chk.cgi_chk_object[i].F <> nil then

                      //4 выдано клиенту нал.       - IssuedToCustomer
                      if length(cgi_chk.cgi_chk_object[i].R) > 0 then
                      begin
                        for j:=0 to length(cgi_chk.cgi_chk_object[i].R)-1 do
                        begin
                          if cgi_chk.cgi_chk_object[i].R[j].P.no = 1 then
                            IssuedToCustomer:=IssuedToCustomer+cgi_chk.cgi_chk_object[i].R[j].S.sum+cgi_chk.cgi_chk_object[i].R[j].D.sum;
                        end; //for j:=0 to length(cgi_chk.cgi_chk_object[i].R) do
                      end; //if cgi_chk.cgi_chk_object[i].R <> nil then

                      //6 безналичная оплата        - NonCashPayment
                      if length(cgi_chk.cgi_chk_object[i].F) > 0 then
                      begin
                        for j:=0 to length(cgi_chk.cgi_chk_object[i].F)-1 do
                        begin
                          if cgi_chk.cgi_chk_object[i].F[j].P.no <> 1 then
                            ReceivedFromCustomer:=ReceivedFromCustomer+cgi_chk.cgi_chk_object[i].F[j].S.sum+cgi_chk.cgi_chk_object[i].F[j].D.sum;
                        end; //for j:=0 to length(cgi_chk.cgi_chk_object[i].F) do
                      end; //if cgi_chk.cgi_chk_object[i].F <> nil then

                      //7 безналичный возврат       - NonCashRefund
                      if length(cgi_chk.cgi_chk_object[i].R) > 0 then
                      begin
                        for j:=0 to length(cgi_chk.cgi_chk_object[i].R)-1 do
                        begin
                          if cgi_chk.cgi_chk_object[i].R[j].P.no <> 1 then
                            IssuedToCustomer:=IssuedToCustomer+cgi_chk.cgi_chk_object[i].R[j].S.sum+cgi_chk.cgi_chk_object[i].R[j].D.sum;
                        end; //for j:=0 to length(cgi_chk.cgi_chk_object[i].R) do
                      end; //if cgi_chk.cgi_chk_object[i].R <> nil then
                    end;

                    //5 конечный остаток          - FinalBalance
                    FinalBalance:=StartingBalance+ServiceAppendix-ServiceSeizure+ReceivedFromCustomer-IssuedToCustomer;

                    ch[0]:=IntToStr(trunc(StartingBalance/0.01)); //0 начальный остаток
                    ch[1]:=IntToStr(trunc(ServiceAppendix/0.01)); //1 служебное внесение
                    ch[2]:=IntToStr(trunc(ServiceSeizure/0.01)); //2 служебное изъятие
                    ch[3]:=IntToStr(trunc(ReceivedFromCustomer/0.01)); //3 получено от клиента нал.
                    ch[4]:=IntToStr(trunc(IssuedToCustomer/0.01)); //4 выдано клиенту нал.
                    ch[5]:=IntToStr(trunc(FinalBalance/0.01)); //5 конечный остаток
                    ch[6]:=IntToStr(trunc(NonCashPayment/0.01)); //6 безналичная оплата
                    ch[7]:=IntToStr(trunc(NonCashRefund/0.01)); //7 безналичный возврат
                    CshStt:=ch.Text;
                  finally
                    ch.Free;
                  end;
                end;
              finally
                memo.Free;
              end;
            end;
          300..599:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
        end;
      end;

    300..599:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
  end;
end;

function GetFiscalState(out FscStt: string; out ErrorCode, ErrorDescription: string; pIPAddr: string): boolean; //состояние наличности в кассе с учетом налоговых ставок
var
  u: ansistring;
  IsDeflated: boolean;
  V: Variant;
  os: TOLEStream;
  in_Stream: TMemoryStream;
  curr_wide: WideString;
  UnknownPtr: Pointer;
  NewSize: integer;
  memo: TMemo;
  ch: TStringList;
  i, j: integer;

  SalesA20: Currency;  //1  - продажи по ставке А20%
  SalesB7: Currency;   //2  - продажи по ставке Б7%
  IssuesA20: Currency; //11 - возвраты покупателям по ставке А20%
  IssuesB7: Currency;  //12 - возвраты покупателям по ставке Б7%
begin
  u:=PROTOCOL+pIPAddr+URI_CGI_STATUS;
  IsDeflated:=false;
  try
    Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
    Req.Open(METHOD_HEAD, u, true);
    Req.SetRequestHeader('Connection','Keep-Alive');
    Req.SetRequestHeader('Proxy-Connection','keep-alive');
    Req.Send();
    Req.WaitForResponse;
  except
    ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
    ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
    Result:=true;
    exit;
  end;
  ParseDscResponseHeaders(Req.GetAllResponseHeaders);

  case Req.Status of //тут можно будет прописать конкретное поведение для каждого из полученых ответов от сервера
    100..199:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
    200..299:
      begin
        Result:=false;  //кассовая лента получена
        ErrorCode:='';
        ErrorDescription:='';

        u:=PROTOCOL+pIPAddr+URI_CGI_CHK;
        IsDeflated:=false;
        try
          Req:=CreateOleObject('WinHttp.WinHttpRequest.5.1');
          Req.Open(METHOD_GET, u, true);
          Req.SetRequestHeader('Connection','Keep-Alive');
          Req.SetRequestHeader('Proxy-Connection','keep-alive');
          Req.SetCredentials(USERNAME_SERVICE,PASS_SERVICE,0);
          Req.Send();
          Req.WaitForResponse;
        except
          ErrorCode:=IntToStr(TIMEOUT_ERROR_CODE_520);
          ErrorDescription:=TIMEOUT_ERROR_RESPONSE_520;
          Result:=true;
          exit;
        end;

        case Req.Status of
          100..199:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
          200..299:
            begin
              ParseDscResponseHeaders(Req.GetAllResponseHeaders);
              try
                V:=req.ResponseStream;
                TVarData(V).vType:=varUnknown;
                os:=TOLEStream.Create(IStream(TVarData(V).VUnknown));
                in_Stream:=TMemoryStream.Create;
                in_Stream.CopyFrom(os,os.Size);

                if Content_Encoding='deflate' then
                begin
                  try
                    in_Stream.Position := 0;
                    DeCompressBuf(in_stream.Memory, in_stream.Size, Content_Length, UnknownPtr, NewSize);
                    in_stream.Clear;
                    in_stream.Position := 0;
                    in_stream.Write(UnknownPtr^, NewSize);
                    in_stream.Position := 0;
                    in_stream.Size;
                  finally
                    FreeMem(UnknownPtr, NewSize);
                  end;
                    IsDeflated:=true;
                end;
              finally
                SetString(curr_wide,PChar(in_stream.Memory),in_stream.Size);
              end;
              try
                memo:=TMemo.Create(nil);
                if IsDeflated then
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,4,length(curr_wide)-3)))
                else
                  memo.Text:=UTF8ToAnsi(Utf8Encode(copy(curr_wide,0,length(curr_wide))));
                memo.Text:=UTF8ToAnsi(memo.Text);
                if ParseCheckListRequest(memo.Text) then
                begin
                  ErrorCode:=EMPTY_RECEIPT_LINE_CODE;
                  ErrorDescription:=EMPTY_RECEIPT_LINE_DESCRIPTION;
                  Result:=true;
                  exit;
                end
                else
                begin
                  try
                    SalesA20:=0;  //1  - продажи по ставке А20%
                    SalesB7:=0;   //2  - продажи по ставке Б7%
                    IssuesA20:=0; //11 - возвраты покупателям по ставке А20%
                    IssuesB7:=0;  //12 - возвраты покупателям по ставке Б7%

                    ch:=TStringList.Create;
                    for i:=0 to 12 do
                    begin
                      //0  - 0
                      //1  - продажи по ставке А20%
                      //2  - продажи по ставке Б7%
                      //3  - 0
                      //4  - 0
                      //5  - 0
                      //6  - 0
                      //7  - 0
                      //8  - 0
                      //9  - 0
                      //10 - 0
                      //11 - возвраты покупателям по ставке А20%
                      //12 - возвраты покупателям по ставке Б7%
                      ch.Add('0');
                    end;
                    for i:=0 to Length(cgi_chk.cgi_chk_object)-1 do
                    begin
                      if length(cgi_chk.cgi_chk_object[i].F) > 0 then
                      begin
                        for j:=0 to length(cgi_chk.cgi_chk_object[i].F)-1 do
                        begin
                          //1  - продажи по ставке А20%
                          if (cgi_chk.cgi_chk_object[i].F[j].S.tax = 0)or(cgi_chk.cgi_chk_object[i].F[j].S.tax = 1) then
                            SalesA20:=SalesA20+cgi_chk.cgi_chk_object[i].F[j].S.sum
                          else
                            //2  - продажи по ставке Б7%
                            if cgi_chk.cgi_chk_object[i].F[j].S.tax = 2 then
                              SalesB7:=SalesB7+cgi_chk.cgi_chk_object[i].F[j].S.sum;
                          //1  - продажи по ставке А20%
                          if (cgi_chk.cgi_chk_object[i].F[j].D.tax = 0)or(cgi_chk.cgi_chk_object[i].F[j].D.tax = 1) then
                            SalesA20:=SalesA20+cgi_chk.cgi_chk_object[i].F[j].D.sum
                          else
                            //2  - продажи по ставке Б7%
                            if cgi_chk.cgi_chk_object[i].F[j].D.tax = 2 then
                              SalesB7:=SalesB7+cgi_chk.cgi_chk_object[i].F[j].D.sum;
                        end; //for j:=0 to length(cgi_chk.cgi_chk_object[i].F) do
                      end; //if cgi_chk.cgi_chk_object[i].F <> nil then

                      if length(cgi_chk.cgi_chk_object[i].R) > 0 then
                      begin
                        for j:=0 to length(cgi_chk.cgi_chk_object[i].R)-1 do
                        begin
                          //11 - возвраты покупателям по ставке А20%
                          if (cgi_chk.cgi_chk_object[i].R[j].S.tax = 0)or(cgi_chk.cgi_chk_object[i].R[j].S.tax = 1)
                          then
                            IssuesA20:=IssuesA20+cgi_chk.cgi_chk_object[i].R[j].S.sum
                          else
                            //12 - возвраты покупателям по ставке Б7%
                            if cgi_chk.cgi_chk_object[i].R[j].S.tax = 2 then
                              IssuesB7:=IssuesB7+cgi_chk.cgi_chk_object[i].R[j].S.sum;
                          //11 - возвраты покупателям по ставке А20%
                          if (cgi_chk.cgi_chk_object[i].R[j].D.tax = 0)or(cgi_chk.cgi_chk_object[i].R[j].D.tax = 1)
                          then
                            IssuesA20:=IssuesA20+cgi_chk.cgi_chk_object[i].R[j].D.sum
                          else
                            //12 - возвраты покупателям по ставке Б7%
                            if cgi_chk.cgi_chk_object[i].R[j].D.tax = 2 then
                              IssuesB7:=IssuesB7+cgi_chk.cgi_chk_object[i].R[j].D.sum;
                        end; //for j:=0 to length(cgi_chk.cgi_chk_object[i].F) do
                      end; //if cgi_chk.cgi_chk_object[i].F <> nil then
                    end;
                    ch[0]:='0';
                    ch[1]:=IntToStr(trunc(SalesA20/0.01));
                    ch[2]:=IntToStr(trunc(SalesB7/0.01));
                    ch[3]:='0';
                    ch[4]:='0';
                    ch[5]:='0';
                    ch[6]:='0';
                    ch[7]:='0';
                    ch[8]:='0';
                    ch[9]:='0';
                    ch[10]:='0';
                    ch[11]:=IntToStr(trunc(IssuesA20/0.01));
                    ch[12]:=IntToStr(trunc(IssuesB7/0.01));
                    FscStt:=ch.Text;
                  finally
                    ch.Free;
                  end;
                end;
              finally
                memo.Free;
              end;
            end;
          300..599:
            begin
              HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
              Result:=true;
            end;
        end;
      end;

    300..599:
      begin
        HTTPResponseParser(Req.Status,Req.StatusText,ErrorCode,ErrorDescription);
        Result:=true;
      end;
  end;
end;

end.

{------------------------------------------------------------------------------}
{******************************************************************************}
{***                                                                        ***}
{*** ДЛЯ ВСЕХ ЗАПРОСОВ К ЭККА ПРОВЕРЯТЬ ДОСТУПНОСТЬ АППАРАТА!!!             ***}
{*** (!!!нужно доделать!!!)                                                 ***}
{***                                                                        ***}
{******************************************************************************}
{------------------------------------------------------------------------------}

{
переопределенные ошибки сервера:
400 BAD_REQUEST_ERROR_RESPONSE_400 = 'Сервер обнаружил в запросе клиента синтаксическую ошибку';
401 UNAUTHORIZED_ERROR_RESPONSE_401 = 'Для доступа к запрашиваемому ресурсу требуется аутентификация';
404 NOT_IMPLEMENTED_ERROR_RESPONSE_404 = 'Сервер понял запрос, но не нашёл соответствующего ресурса по указанному URL';
407 PROXY_AUTHENTICATION_REQUIRED_ERROR_RESPONSE_407 = 'Для доступа к запрашиваемому ресурсу требуется аутентификация';
408 REQUEST_TIMEOUT_ERROR_RESPONSE_408 = 'Время ожидания сервером передачи от клиента истекло'
410 GONE_ERROR_RESPONSE_410 = 'Ресурс раньше был по указанному URL, но был удалён и теперь недоступен'
500 INTERNAL_SERVER_ERROR_RESPONSE_500 = 'Внутренняя ошибка сервера'
501 NOT_IMPLEMENTED_ERROR_RESPONSE_501 = 'Сервер не поддерживает возможностей, необходимых для обработки запроса'
502 BAD_GATEWAY_ERROR_RESPONSE_502 = 'Сервер, выступая в роли шлюза или прокси-сервера, получил недействительное ответное сообщение от вышестоящего сервера'
503 SERVICE_UNAVAILABLE_ERROR_RESPONSE_503 = 'Сервер временно не имеет возможности обрабатывать запросы по техническим причинам';
504 GATEWAY_TIMEOUT_ERROR_RESPONSE_504 = 'Сервер в роли шлюза или прокси-сервера не дождался ответа от вышестоящего сервера для завершения текущего запроса';
520 TIMEOUT_ERROR_RESPONSE_520 = 'За выделенное время от сервера не был получен ожидаемый ответ';
}

{
типичные ответы сервера:
200 OK — успешный запрос. Если клиентом были запрошены какие-либо данные, то они находятся в заголовке и/или теле сообщения. Появился в HTTP/1.0.
201 Created — в результате успешного выполнения запроса был создан новый ресурс. Сервер может указать адреса (их может быть несколько) созданного ресурса в теле ответа, при этом предпочтительный адрес указывается в заголовке Location. Серверу рекомендуется указывать в теле ответа характеристики созданного ресурса и его адреса, формат тела ответа определяется заголовком Content-Type. При обработке запроса, новый ресурс должен быть создан до отправки ответа клиенту, иначе следует использовать ответ с кодом 202. Появился в HTTP/1.0.
202 Accepted — запрос был принят на обработку, но она не завершена. Клиенту не обязательно дожидаться окончательной передачи сообщения, так как может быть начат очень долгий процесс. Появился в HTTP/1.0.
203 Non-Authoritative Information — аналогично ответу 200, но в этом случае передаваемая информация была взята не из первичного источника (резервной копии, другого сервера и т. д.) и поэтому может быть неактуальной. Появился в HTTP/1.1.
204 No Content — сервер успешно обработал запрос, но в ответе были переданы только заголовки без тела сообщения. Клиент не должен обновлять содержимое документа, но может применить к нему полученные метаданные. Появился в HTTP/1.0.
205 Reset Content — сервер обязывает клиента сбросить введённые пользователем данные. Тела сообщения сервер при этом не передаёт и документ обновлять не обязательно. Появился в HTTP/1.1.
206 Partial Content — сервер удачно выполнил частичный GET-запрос, возвратив только часть сообщения. В заголовке Content-Range сервер указывает байтовые диапазоны содержимого. Особое внимание при работе с подобными ответами следует уделить кэшированию. Появился в HTTP/1.1. (подробнее...)
207 Multi-Status — сервер передаёт результаты выполнения сразу нескольких независимых операций. Они помещаются в само тело сообщения в виде XML-документа с объектом multistatus. Не рекомендуется размещать в этом объекте статусы из серии 1xx из-за бессмысленности и избыточности. Появился в WebDAV.
226 IM Used — заголовок A-IM от клиента был успешно принят и сервер возвращает содержимое с учётом указанных параметров. Введено в RFC 3229 для дополнения протокола HTTP поддержкой дельта-кодирования.

402 Payment Required — предполагается использовать в будущем. В настоящий момент не используется. Этот код предусмотрен для платных пользовательских сервисов, а не для хостинговых компаний. Имеется в виду, что эта ошибка не будет выдана хостинговым провайдером в случае просроченной оплаты его услуг. Зарезервирован, начиная с HTTP/1.1.
Сервер вернул ошибку 403 при попытке просмотра директории «cgi-bin», доступ к которой был запрещён.
403 Forbidden[17] — сервер понял запрос, но он отказывается его выполнять из-за ограничений в доступе для клиента к указанному ресурсу. Если для доступа к ресурсу требуется аутентификация средствами HTTP, то сервер вернёт ответ 401, или 407 при использовании прокси. В противном случае ограничения были заданы администратором сервера или разработчиком веб-приложения и могут быть любыми в зависимости от возможностей используемого программного обеспечения. В любом случае клиенту следует сообщить причины отказа в обработке запроса. Наиболее вероятными причинами ограничения может послужить попытка доступа к системным ресурсам веб-сервера (например, файлам .htaccess или .htpasswd) или к файлам, доступ к которым был закрыт с помощью конфигурационных файлов, требование аутентификации не средствами HTTP, например, для доступа к системе управления содержимым или разделу для зарегистрированных пользователей либо сервер не удовлетворён IP-адресом клиента, например, при блокировках. Появился в HTTP/1.0.
405 Method Not Allowed — указанный клиентом метод нельзя применить к текущему ресурсу. В ответе сервер должен указать доступные методы в заголовке Allow, разделив их запятой. Эту ошибку сервер должен возвращать, если метод ему известен, но он не применим именно к указанному в запросе ресурсу, если же указанный метод не применим на всём сервере, то клиенту нужно вернуть код 501 (Not Implemented). Появился в HTTP/1.1.
406 Not Acceptable — запрошенный URI не может удовлетворить переданным в заголовке характеристикам. Если метод был не HEAD, то сервер должен вернуть список допустимых характеристик для данного ресурса. Появился в HTTP/1.1.
409 Conflict — запрос не может быть выполнен из-за конфликтного обращения к ресурсу. Такое возможно, например, когда два клиента пытаются изменить ресурс с помощью метода PUT.Появился в HTTP/1.1.
411 Length Required — для указанного ресурса клиент должен указать Content-Length в заголовке запроса. Без указания этого поля не стоит делать повторную попытку запроса к серверу по данному URI. Такой ответ естественен для запросов типа POST и PUT. Например, если по указанному URI производится загрузка файлов, а на сервере стоит ограничение на их объём. Тогда разумней будет проверить в самом начале заголовок Content-Length и сразу отказать в загрузке, чем провоцировать бессмысленную нагрузку, разрывая соединение, когда клиент действительно пришлёт слишком объёмное сообщение. Появился в HTTP/1.1.
412 Precondition Failed — возвращается, если ни одно из условных полей заголовка (If-Match и др., см. RFC 7232) запроса не было выполнено. Появился в HTTP/1.1.
413 Request Entity Too Large — возвращается в случае, если сервер отказывается обработать запрос по причине слишком большого размера тела запроса. Сервер может закрыть соединение, чтобы прекратить дальнейшую передачу запроса. Если проблема временная, то рекомендуется в ответ сервера включить заголовок Retry-After с указанием времени, по истечении которого можно повторить аналогичный запрос. Появился в HTTP/1.1.
414 Request-URL Too Long — сервер не может обработать запрос из-за слишком длинного указанного URL. Такую ошибку можно спровоцировать, например, когда клиент пытается передать длинные параметры через метод GET, а не POST. Появился в HTTP/1.1.
415 Unsupported Media Type — по каким-то причинам сервер отказывается работать с указанным типом данных при данном методе. Появился в HTTP/1.1.
416 Requested Range Not Satisfiable — в поле Range заголовка запроса был указан диапазон за пределами ресурса и отсутствует поле If-Range. Если клиент передал байтовый диапазон, то сервер может вернуть реальный размер в поле Content-Range заголовка. Данный ответ не следует использовать при передаче типа multipart/byteranges[источник не указан 1894 дня]. Введено в RFC 2616 (обновление HTTP/1.1).
417 Expectation Failed — по каким-то причинам сервер не может удовлетворить значению поля Expect заголовка запроса. Введено в RFC 2616 (обновление HTTP/1.1).
418 I’m a teapot — Этот код был введен в 1998 году как одна из традиционных первоапрельских шуток IETF в RFC 2324, Hyper Text Coffee Pot Control Protocol. Не ожидается, что данный код будет поддерживаться реальными серверами[19].
422 Unprocessable Entity — сервер успешно принял запрос, может работать с указанным видом данных (например, в теле запроса находится XML-документ, имеющий верный синтаксис), однако имеется какая-то логическая ошибка, из-за которой невозможно произвести операцию над ресурсом. Введено в WebDAV.
423 Locked — целевой ресурс из запроса заблокирован от применения к нему указанного метода. Введено в WebDAV.
424 Failed Dependency — реализация текущего запроса может зависеть от успешности выполнения другой операции. Если она не выполнена и из-за этого нельзя выполнить текущий запрос, то сервер вернёт этот код. Введено в WebDAV.
425 Unordered Collection — используется в расширении WebDAV Advanced Collections Protocol[20]. Посылается, если клиент указал номер элемента в неупорядоченном списке, или запросил несколько элементов в порядке, отличающемся от серверного.
426 Upgrade Required — сервер указывает клиенту на необходимость обновить протокол. Заголовок ответа должен содержать правильно сформированные поля Upgrade и Connection. Введено в RFC 2817 для возможности перехода к TLS посредством HTTP.
428 Precondition Required — сервер указывает клиенту на необходимость использования в запросе заголовков условий, наподобие If-Match. Введено в черновике стандарта RFC 6585.
429 Too Many Requests — клиент попытался отправить слишком много запросов за короткое время, что может указывать, например, на попытку DDoS-атаки. Может сопровождаться заголовком Retry-After, указывающим, через какое время можно повторить запрос. Введено в черновике стандарта RFC 6585.
431 Request Header Fields Too Large — Превышена допустимая длина заголовков. Сервер не обязан отвечать этим кодом, вместо этого он может просто сбросить соединение. Введено в черновике стандарта RFC 6585.
434 Requested host unavailable — Запрашиваемый адрес недоступен[источник не указан 1331 день].
449 Retry With — возвращается сервером, если для обработки запроса от клиента поступило недостаточно информации. При этом в заголовок ответа помещается поле Ms-Echo-Request. Введено корпорацией Microsoft для WebDAV. В настоящий момент как минимум используется программой Microsoft Money.
451 Unavailable For Legal Reasons — доступ к ресурсу закрыт по юридическим причинам, например, по требованию органов государственной власти или по требованию правообладателя в случае нарушения авторских прав. Введено в черновике IETF за авторством Google[11], при этом код ошибки является отсылкой к роману Рэя Брэдбери «451 градус по Фаренгейту». Был добавлен в стандарт 21 декабря 2015[21].

505 HTTP Version Not Supported — сервер не поддерживает или отказывается поддерживать указанную в запросе версию протокола HTTP. Появился в HTTP/1.1.
}

