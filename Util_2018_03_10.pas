UNIT Util;

INTERFACE

Uses BDE,Windows,Messages,DBTables,SysUtils,Grids,Registry,Graphics,Forms,Classes,StdCtrls,Dialogs, Controls,
     ShellApi, DB, ADODB, ActiveX, ExtCtrls,TlHelp32, ShlObj, ComObj, Math, WinSock, ComCtrls, CRCUnit,
     MMSystem, DateUtils, DBGrids, MemDS, DBAccess, MSAccess, SHFolder, SHDocVw, MSHTML;

Type TIntArray=Array of Integer;

     TRep=Record
           DtWriteFP:TDateTime;

{
           DtLastChek:TDateTime;
           DtFirstChek:TDateTime;
           Sums:Array[0..11] of Currency;
           NumLastChek:Integer;
}
          end;

     TRealArray=Array of Real;

     TExtendedArray=Array of Extended;

     TSetChar=Set of Char;

     TStrArray=Array of String;

     TCennik=Record
         Brend:Integer;
         Names:String;
         Art_Code:Integer;
         EAN13:String;
         Cena:Currency;
         CenaOpt:Currency;
         SrokSkd:Byte;
         FirmName:String;
         P1:Integer;
         P2:Integer;
         P3:Integer;
        end;

     TDownLoadInfo=Record
                    SizeFrom:Integer;
                    SizeTo:Integer;
                    Read:Boolean;
                    Write:Boolean;
                   end;

     TCRCInfo=Record
               CRC32:Cardinal;
               Date:TDateTime;
              end;

Const // Констатны  Для видео наблюдения
      TAPIERR_CONNECTED=0;
      TAPIERR_DROPPED=-1;
      TAPIERR_NOREQUESTRECIPIENT=-2;
      TAPIERR_REQUESTQUEUEFULL=-3;
      TAPIERR_INVALDESTADDRESS=-4;
      TAPIERR_INVALWINDOWHANDLE=-5;
      TAPIERR_INVALDEVICECLASS=-6;
      TAPIERR_INVALDEVICEID=-7;
      TAPIERR_DEVICECLASSUNAVAIL=-8;
      TAPIERR_DEVICEIDUNAVAIL=-9;
      TAPIERR_DEVICEINUSE=-10;
      TAPIERR_DESTBUSY=-11;
      TAPIERR_DESTNOANSWER=-12;
      TAPIERR_DESTUNAVAIL=-13;
      TAPIERR_UNKNOWNWINHANDLE=-14;
      TAPIERR_UNKNOWNREQUESTID=-15;
      TAPIERR_REQUESTFAILED=-16;
      TAPIERR_REQUESTCANCELLED=-17;
      TAPIERR_INVALPOINTER=-18;

      WM_CAP_START = WM_USER;
      WM_CAP_STOP = WM_CAP_START + 68;
      WM_CAP_DRIVER_CONNECT = WM_CAP_START + 10;
      WM_CAP_DRIVER_DISCONNECT = WM_CAP_START + 11;
      WM_CAP_SAVEDIB = WM_CAP_START + 25;
      WM_CAP_GRAB_FRAME = WM_CAP_START + 60;

      WM_CAP_DLG_VIDEOFORMAT = WM_CAP_START + 41;
      WM_CAP_DLG_VIDEOSOURCE = WM_CAP_START + 42;
      
      WM_CAP_SEQUENCE = WM_CAP_START + 62;
      WM_CAP_FILE_SET_CAPTURE_FILEA = WM_CAP_START + 20;

      TAPIMAXDESTADDRESSSIZE = 80;
      TAPIMAXAPPNAMESIZE = 40;
      TAPIMAXCOMMENTSIZE = 80;
      TAPIMAXDEVICECLASSSIZE = 40;
      TAPIMAXDEVICEIDSIZE = 40;

      WM_CAP_SET_SCALE = WM_CAP_START + 53;
      WM_CAP_SET_PREVIEW = WM_CAP_START + 50;
      WM_CAP_SET_PREVIEWRATE = WM_CAP_START + 52;

      LOAD_IN=1;  // Закачка на удаленный компюьтер
      LOAD_OUT=2; // Закачка с удаленого компьютера

      WINSOCK_VERSION = $0101;

// 1. Перехід в будь-якій таблиці на запис з номером ID
Function GoToID(T:Ttable; F:String; ID:Integer):Boolean;

// 2. Перехід в будь-якій таблиці на запис з номером ID зi збереженням фiльтру-------
//---------------------пользоваться острожно или лучше вообще не пользоваться-----
Function GoToIDF(T:Ttable; F:String; ID:Integer):Boolean;

// 3. Перехід в будь-якій таблиці на запис iз значенням S
Function GoToStr(T:Ttable; F:String; S:String):Boolean;

// 4. Проверка правильности введеного целого числа
Function CheckInt(S:String):Boolean;

// 5. Проверка правильности введеного действительного числа
Function CheckFloat(S:String):Boolean;

// 6. Проверка правильности введеного денежного значения
Function CheckCurrency(S:String):Boolean;

// 7. Проверка правильности введеной даты
Function CheckDate(S:String):Boolean;

// 8. Удаление всех записей с таблицы по полю F с целочисленным зачением V
Procedure DeleteID(T:TTable; F:String; V:Integer);

// 9. Удаление всех записей с таблицы по полю F со строковым зачением V
Procedure DeleteStr(T:TTable; F:String; V:String);

// 10. Корректировка действительного числа (меняет точку на запятую)
Function CorrectFloatNumXp(N:String):String;

// 11. Удаление строки со StringGrid
Procedure DelRows(SG:TStringGrid; Num:Integer);

// 12. Перевод денежной формы в строку
Function CurrencyToStr(Price:Real):String;

// 13. Переход по ID по фильтрованой таблице
Function GoToFiltID(T:Ttable; F:String; ID:Integer):Boolean;

// 14. Форматированный перевод вещественного числа в строку
Function FloatToStrF(F:Real; P1,P2:Byte):String;

// 15. Возвращает имя файла без расширения
Function MyFileName(Name:String):String;

// 16. Удаление файлов по маске
Procedure DeleteFiles(Path:String; Mask:String);

// 17. Дата создания файла
Function GetFileDateTime(FileName:String):TDateTime;

// 18. Копирование прямоугольной области
Function CaptureScreenRect(ARect:TRect):TBitmap;

// 19. копировние целого экрана
Function CaptureScreen:TBitmap;

// 20. Замена всех цветов на отенки одного
Procedure ModColors(Bitmap:TBitmap; Color:TColor);

// 21. Выводит сообщение об ошибке
Procedure ShowErM(Ed:TCustomEdit; Mes,Cap:String);

// 22. Проверяет на непустость значение в TEDit и выводит сообщение если оно пусто
Function IsEmpty(Ed:TCustomEdit; Mes,Cap:String):Boolean;

// 23. Проверяет целочисленное значение в Edit
Function IsInt(Ed:TCustomEdit; Mes,Cap:String):Boolean;

// 24. Проверяет вещественное значение в Edit
Function IsFloat(Ed:TCustomEdit; Mes,Cap:String):Boolean;

// 25. Получить имя компьютера
Function GetCompName:String;

// 26. Очистка группы ячеек в StringGrid
Procedure ClearRegion(SG:TStringGrid; x,y,dx,dy:Integer);

// 27. Обрезка SG до 2-x строк и очитска последнй строки
Procedure TruncateGrid(SG:TStringGrid);

// 28. Обрезание пустых строк в SG с конца
Procedure TruncateEmpty(SG:TStringGrid);

// 29. Конвертирование даты с Журнала документов 1С
Function JDateToStr(D:String):String;

// 30. Перевод строки в число с полной защиой
Function StrToReal(S:String):Real;

// 31. Задержка в СЕКУНДАХ !!!!!!
Procedure Delay(Sec:Real);

// 32. Расчет 2-х байтового СRС16
Function CRC16(S:String):String;

// 33. Расчет 2-х байтового СRС16 для полинома x16+x12+x5+1 для RS232
Function CountCRC16(Mem:String):String;

// 33. Конвертирование даты с таблицы SQL
Function MSDateToStr(D:String):String;

// 34. Проверка вставлен ли диск (Дискета или Компакт диск)
Function DiskInDrive(Drive: Char): Boolean;

// 35. Быстрое форматирование дисков А
Function QuickFormatDiskA(Handle:HWND):Boolean;

function SHFormatDrive(hWnd:HWND;
                       Drive:Word;
                       fmtID:Word;
                       Options:Word):Longint stdcall; external 'Shell32.dll' name 'SHFormatDrive';

// 36. Копирование каталога полностью
Function CopyDir(const fromDir, toDir: string): Boolean;

// 37. Перемещение каталога полностью со всем содержимым
Function MoveDir(const fromDir, toDir: string): Boolean;

// 38. Удаление каталога со всем содержимым
Function DelDir(dir: string): Boolean;

// 39. Упаковка таблиц
Procedure PkTable(Table:TTable);

// 40. Номер дня недели
Function GetDayWeekNum(D:TDateTime):Integer;

// 41. Подготовка и запуск SQL функцией Open
Function OpenSQL(Qr:TQuery; SQL:String):Integer;

// 42. Подготовка и запуск SQL функцией ExecSQL
Function ExecSQL(Qr:TQuery; SQL:String):Integer;

// 43. Вставка столбца в StringGrid
Procedure InsertColumn(SG:TStringGrid; N:Integer; V:String);

// 44. Удаление столбца в StringGrid
Procedure DeleteColumn(SG:TStringGrid; N:Integer);

// 45. Дата через слэш, так как FormatDateTime отказывается отображать дату в таком формате
Function DateToStrSlash(D:TDateTime):String;
Function DateTimeToStrSlash(D:TDateTime):String;

// 46. Подготовка и запуск ADOSQL функцией Open
Function OpenADOSQL(Qr:TDataSet; SQL:String):Integer;

// 47. Подготовка и запуск ADOSQL функцией ExecSQL
Function ExecADOSQL(Qr:TDataSet; SQL:String):Integer;

// 48. Выгрузка в текст по формату, но работает медленно лучше выгружать через xp_cmdshell
Function UnLoadToTxt(var Qr:TQuery; FName:String; FS:TStringList):Boolean;

// 49. Динамическое изменени главной формы на любую другую !!!!!!!!!!!
Procedure SetAsMainForm(aForm:TForm);

// 50. Длина текста в пикселах в зависимости от шрифта
Function TextPixWidth(S:String; F:TFont):Integer;

// 51 ... (нужна для функции ниже)
Function SHAutoComplete(hwndEdit: THandle; Flags: Cardinal): HRESULT; stdcall;

// 52. Для организации поиска в ComboBox
Function EnableAutoComplete(Handle: THandle; FileSystem, URL: Boolean): Boolean;

// 53. Извлечение красного
Function GetR(const Color: TColor): Byte;

// 54. Извлечение зелёного
Function GetG(const Color: TColor): Byte;

// 55. Извлечение синего
Function GetB(const Color: TColor): Byte;

// 56. Дописывает строку в текстовый файл, если файла нет, то функция создант новый
Procedure AppendStringToFile(FName:String; S:String);

// 57. Проверка строки на соответствие типу Integer
Function IsInteger(S:String):Boolean;

// 58. Первое и последнее число месяца текущего года
Procedure GetDaysOfMonth(M:Integer; var D1,D31:TDateTime);

// 59. Получить информацию о любом диске втом числе и серийный номер
Procedure GetDriveInfo(VolumeName:String; var VolumeLabel,SerialNumber,FileSystem:String);

// 60. Бакапит любую базу через ADO запрос
Function BackUpDataBase(Qr:TADOQuery; FileName:String; BaseName:String):Boolean;
Function BackUpDataBaseMS(Qr:TMSQuery; FileName:String; BaseName:String):Boolean;
Procedure BackUpDataBase_(Qr:TADOQuery; FileName:String; BaseName:String);

// 61. Разворачивает любую базу нчерез ADO запрос. BaseName имя базы куда разворачиваем, MediaName - имя базы которая в файле бакапа
Function RestoreDataBase(Qr:TADOQuery; FileName:String; BaseName:String; MediaName:String=''):Boolean;

// 62. Создание базы
Procedure CreateDataBase(Qr:TADOQuery; BaseName:String);

// 63. Разбирает строку на елементы целочисленного массива
Procedure GetIntArray(S:String; var A:TIntArray; Spliter:TSetChar);

// 64. Запис числа словами на украинском языке
Function IntToWordsUA(D:LongInt; p:Byte):String;

// 65. Запис числа словами на русском языке
Function IntToWordsRU(D:LongInt; p:Byte):String;

// 66. Запись денежного числа словами
Function CurrToWordsRU(C:Currency; P:Byte):String;

// 66.1. Запись денежного числа словами UA
Function CurrToWordsUA(C:Currency; P:Byte):String;

// 66.2 Запись float/double числа словами
Function FloatToWordsRU(C:double; P1,P2:Byte):String;

// 66.3. Запись float/double числа словами UA
Function FloatToWordsUA(C:double; P1,P2:Byte):String;

// 67. Путь к самому себе.
Function PrPath:String;

// 68. Размер файла в байтах
Function GetFileSize(FName:String):Int64;

// 69. Выгрузка DB таблиц в текст
Function UnArhCheks(FName,ToF:String):Boolean;

// 70. Загрузка таблицы из текстового файла
Function RestoreTxtTable(Qr:TADOQuery; FName,TName,BName:String):Boolean;

// 71. 866 в 1251
Function OemToChar(N:Byte):Char;

// 72. 1251 в 866
Function CharToOem(N:Char):Byte;

// 73. Наша функция возвращает PID найденного процесса или 0, если процесс не найден.
Function ProcessExists(ExeName:String):Cardinal;

// 74. Получить имя процесса по PID
Function GetExeNameByProcID (ProcID:DWord):String;

// 75. Получить HANDLE главного окна по имени процесса
Function GetHandleByExeName(Handle:HWND; ExeName:String):HWND;

// 76. Путь к Program Files
Function GetProgramFilesDir:String;

// 77. Наконецто написал ShowMessage для Integer. Сколько лет нужно было промучаться!!!!!!!!!!!!!!
Procedure ShowMessageI(I:Int64);

// 78. Аналогичная предыдущей, только для Currency
Procedure ShowMessageC(I:Currency);

// 79. Создание ярлыка на рабочем столе
Procedure CreateShortCut(FN,Cap:String);

// 80. Путь к Мои Документы
Function GetMyDocsDir:String;

// 81. Извлеч иконку Exe файла который запускает данный файл
Function GetRegistryIconHandle(FileName:String):HICON;

// 82. Путь к папке System32
Function GetSystemDir:String;

// 83. Проверка на надичие таблицы SQL через ADO
Function TableExists(Qr:TADOQuery; Tb:String):Boolean;

// 84. Возвращает символ разделитель целой и дробной части
Function GetDivPoint:Char;

// 85. Число в строку по формату, заполняет отсутствующие цифры в строке нулями (0005)
Function IntToStrF(I:Int64; P:Integer):String;
Function IntToStrFL(I:Int64; P:Integer):String;

// 86. Перевод денежного значения в копейки, а затем в строку с лидирующими нулями
Function CurrToStr2(C:Currency; P:Integer):String;

// 87. Корректировка разделителя десятичных чисел в строке
Function CorrFloatNum(N:String):String;

// 88. Забивает в строке недостающие символы пробелами а лишние обрезает
Function CopyStrF(S:String; P:Integer):String;

// 89. Разбирает строку на елементы строкового массива
Procedure GetStrArray(S:String; var A:TStrArray; Spliter:TSetChar);

// 90. Выгрузка DB таблиц для Apteka_Net
Function UnArhCheksNew(FName,ToF:String):Boolean;

// 91. Правильное округление до двух знаков после запятой
Function RoundCurr(C:Double):Currency;

// 92. Выгрузка запроса в текстовый файл
Function SaveQrToText(Qr:TADOQuery; FName:String):Boolean;

// 93. Рабочий путь к программе
Function WorkPath:String;

// 94. Корректировка строки для передачи в SQL на предмет одинарных кавычек
Function CorrSQLString(S:String):String;
function CorrSQLString1(S:String):String;

// 95. Генерация исключительной ситуации с сообщением
Procedure AbortS(S:String);

// 96. Преобразование строки в цвет (поддерживаются константы принятые в Delphi)
Function StrToColor(S:String):TColor;

// 97. Центрирует строку внутри диапазона
Function CenterStr(S:String; C:Integer):String;

// 98. Равномероно распределяет две строки по правому и левому краю диапазона
Function AddStr(S1,S2:String; Param:Integer):String;
Function AddStr_(S:String; Ch:Char; Param:Integer):String;

// 99. Загрузка накладных из текстового файла во TmpNakl в любую базу APTEKA_NET
Function LoadTmpNakl(ADOCo:TADOConnection; Qr:TADOQuery; FName:String; Silent:Byte; Param:Byte):Boolean;
Function LoadTmpNaklMS(ADOCo:TMSConnection; Qr:TMSQuery; FName:String; UserID:Integer):Boolean;

// 100. Получить новый уникальный номер накладной по шаблону
Function GetNewNomNakl(Qr:TDataSet; Shab:String):String;

// 101. Изменение системного времени с учетом часового пояса
Function SetTime(tDati:TDateTime):Boolean;

// 102. Выравнивание строки по правому краю
Function CopyStrR(S:String; P:Integer):String;

{ 103..107 --- Функции для видеонаблюдения ---}
Function tapiRequestMakeCallA(DestAddress:PAnsiChar; AppName:PAnsiChar;CalledParty:PAnsiChar; Comment:PAnsiChar):LongInt;stdcall; external 'TAPI32.DLL';
Function tapiRequestMakeCallW(DestAddress:PWideChar; AppName:PWideChar;CalledParty:PWideChar;Comment:PWideChar):LongInt;stdcall; external 'TAPI32.DLL';
Function tapiRequestMakeCall(DestAddress:PChar; AppName:PChar;CalledParty:PChar;Comment:PChar):LongInt; stdcall; external 'TAPI32.DLL';

Function capCreateCaptureWindowA(lpszWindowName:PChar;
                                 dwStyle:longint;
                                 x:integer;
                                 y:integer;
                                 nWidth:integer;
                                 nHeight:integer;
                                 ParentWin:HWND;
                                 nId:integer):HWND;
stdcall external 'AVICAP32.DLL';
{ --- }

// 108. Определение собственного IP адреса
Function GetLocalIP:String;

// 109. Возвращает имя IDENTITY-поля таблицы
Function GetIndentFieldName(Qr:TADOQuery; TbName:String):String;

// 110. Перевод числа из десятичной в любую другую систему исчисления (2-16)
Function ConvertToCS(val:integer; CS:integer; Dec:Byte):String;

// 111. Возвращает описание даты в фомате д месяц год на украинском языке
Function DateToStrUA(D:TDateTime;  dd:String='d'):String;

// 112. Закачка порции файла
Function DownLoadFileBlock(FromF,ToF:String; var Dl:TDownLoadInfo):Boolean;

// 113. Конвертирует время из формата кассового аппарата в человеческое
Function JTimeToStr(T:String):String;

// 114. Сравнивает два файла по дате создания и размеру
Function CompareFiles(FromF,ToF:String):Boolean;

// 115. Рисование штрих-кода EAN13
Procedure DrawBarCode(Canv:TCanvas; Code:String; Size,X,Y,Width,Height:Integer);

// 116. Генеарция штрихкода для шрифта EanBwrP36Tt
Function GenEAN13(Code:String):String;

// 117. Закача всего файла на или с удаленого компьютера
Function DownLoadFile(FromF,ToF:String; Direction:Byte; PrBar:TProgressBar):Boolean;

// 118. Создает файлик с контрольной суммой указанного файла
Function MakeCRC32File(FileName:String):Boolean;

// 119. Проверяет контрольную сумма файла
Function CheckCRCFile(FileName:String):Boolean;

// 120. Запускает процесс и дожидается его выполнения
Function ExecuteAndWait(CommandLine:String; HideApplication:Boolean):Boolean;

// 121. Дата на русском в формате 12 апреля 2009 г.
Function DateToStrRU(D:TDateTime):String;

Function MonthToStrRU(D:TDateTime):String;

// 122. День недели по русскому стилю (превый день - понедельник)
Function DayOfWeekRU(D:TDateTime):Integer;

// 123. Транслитерация русского символа
Function Translit(Ch:Char):String;

// 124. Транслитерация русских символов в строке
Function TranslitStr(S:String):String;

// 125. Установка громкости
Procedure SetVolume(const volL, volR: Word);

// 126. Логические значение в цифровые: True=1, False=0
Function BoolToInt(B:Boolean):Byte;

// 127. Возвращает целочисленное зачения из строки фильтра
Function GetIntValue(V:String; Def:Integer=0):Int64;

// 128. Возвращает строковое зачения из строки фильтра
Function GetStrValue(V:String; Def:String='Все'):String;

// 129. Получить ID дискового устройства
Function GetFlashID(L:Char):String;

// 130. Регистрация флешек пришедших с аптеки
//Function RegFlash(Qr:TADOQuery; L:Char; P:Byte=0):Boolean;

// 131. Поиск баз для итогов на флешках
Procedure FindBaseInFlash(PathF,PathTo:String; NumA:Integer; Pn:TPanel=nil);

// 132. Выгружает строки DBGrid в Excel
Procedure DBGridToExcel(db:TDBGrid; Caption:String='');

// 133. Первый символ строки большой, остальные маленькие
Function UpperLowerStr(S:String):String;

// 134. Строку в число для TEdit
Function StrToIntEd(S:String):Integer;

// 135. Очистка буфера клавиатуры
Procedure EmptyKeyQueue;

// 136. Установить имя компьютера
Function SetComputerName(AComputerName:String):Boolean;

// 137. Установить дату время файла
Function SetFileDateTime(FileName:String; NewTime:TDateTime):Boolean;

// 138. Загрузка Файла в базу MSSQL
Function LoadExeToSQL(Qr:TADOQuery; FName:String; FNameCap,FPath:String; ServerOnly:Byte; Major,Minor,Release,Build,UseVerForUpd:Integer; var Er:String):Boolean;

// 139. Сохранение файла из базы MSSQL
Function SaveExeFromSQL(Qr:TADOQuery; Path,FName:String; var Er:String):Boolean;

// 140. Определение положнеия точки относительно прямой
Function PointMap(x1,y1,x2,y2:Real; x,y:Real):Integer; overload;

Function PointMap(k,b:Real; x,y:Real):Integer; overload;

// 141. Определение направление прямоу (возрастающая или убывающая)
Function LineDirect(x1,y1,x2,y2:Real):Integer;

// 142. Получить Y по X прямой заданой 2-я точками
Function GetLineY(x,x1,y1,x2,y2:Real):Real;

// 143. StringGrid в Excel
Procedure StringGridToExcel(db:TStringGrid);

// 144. IP адрес по имени компьютера
Function GetIPAddress(name:String):String;

// 145. Закодировать строку в Base64
Function EncodeBase64(const inStr:String):String;

// 146. Раскодировать строку из Base64
Function DecodeBase64(const CinLine:String):String;

// 147. Лидирующий ноль
Function LeadZero(N:Integer):String;

//148. Значение из XML
Function GetValueFromXML(KeyWord:String; XMLStr:String):String;

// 149. Сравнивает 2 изображения попиксельно в процентах
Function Compare2Img(Bm,Bm1:TBitMap):Real;

// 150. Выгрузка справочников аптек
Function UnLoadPrice(QrS,Qr:TADOQuery; ZakPath:String; PathTo:String; ID_Apteka:Integer):String;

// 151. Создание архивов справочников
Procedure MakeArhs(QrS,Qr:TADOQuery; SPath:String);

// 152. ----------- Для выгрузки накладных ------------------
Procedure AddToLog(Qr:TADOQuery; Param:Integer; MM:TMemo=nil; Chp:Integer=0);
Function  AddNaklToTxt(Qr:TADOQuery; FName:String; Param:Integer; ID_APTEKA:Integer; NReady:Boolean; IsEmpty:Boolean=False; MM:TMemo=nil; Chp:Integer=0):Boolean;
Function  AddNaklCHPToTxt(Qr:TADOQuery; FName:String; Param:Integer; ID_APTEKA:Integer; NReady:Boolean; IsEmpty:Boolean=False; MM:TMemo=nil; Chp:Integer=0):Boolean;
Procedure GetScanDop(Qr:TADOQuery; FName,NN_Nakl:String; Date_Nakl:TDateTime; IDA:Integer);
// ----------------------------------------------------------

// 153. Версия файла
Function FileVersion(AFileName: string):String;

// 154. Пути к системным папкам
Function GetSpecialFolderPath(folder:integer):string;

// 155. Строку в Hex 1 байт =2 бата
Function StrToHex2(S:String):String;

// 156. Строку Hex 1 байт =2 бата в строку
Function Hex2ToStr(S:String):String;

// 157. Проверка принадлежности класса к классу Name
Function IsClassInherit(Value:TClass; const Name:String):Boolean;

// 158. RGB to TColor
Function RGBToColor(R,G,B:Byte):TColor;

// 159. Подбирает опитмальный размер шрифта
Function GetOptimalFontSize(S:String; F:TFont; Width,MaxFontSize:Integer):Integer;

// 160.
Function GetFont(Name:String; Size:Integer; C:TColor; FStyle:TFontStyles):TFont;




// 161. Для ввода номера телефона
Function GetPos1(L:Integer):Integer;

// 162. Для ввода номера телефона
Procedure EditKeyPress(Sender: TObject; var Key: Char);

// 163. Для ввода номера телефона
Procedure EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);

// 164. Для ввода номера телефона
Procedure EditEnter(Sender: TObject);

// 165. Для ввода номера телефона
Function IsEmptyPhone(S:String):Boolean;

// 166. Для ввода номера телефона
Function IsCorrectPhone(S:String):Boolean;




// 167
Function GetVolume:DWord;

// 168
Procedure GetCoordControl(AOwner: TComponent; Sender:TObject; var dx,dy:Integer);

//169.
procedure WB_LoadHTML(WebBrowser: TWebBrowser; HTMLCode: string);
procedure WB_LoadHTMLBlob(WebBrowser: TWebBrowser; HTMLCode:TMemoryStream);

function GiveEveryoneFullAccessToRegistryKey(const RootKey:HKey; const RegPath:String; out ErrorMsg:String):Boolean;


// 170 два знака после запятой , дробный разделитель - запятая
function CurrToStrF_(C:Currency):String;

// 171.
function CountWords(S:String):Integer;

// 172.
function PrepareStringFilter(S:String):String;

// 173. Регистрирование ошибки в базу или в файл
procedure RegError(Qr:TADOQuery; Caption:String; EMessage:String; LogFile:String=''; BaseLog:String='Report');

// 174. Генерация ежечасного пароля
function GetKodForEachHour:String;

// 175.
function SetWaveVolume(const AVolume:DWORD):Boolean;

// 176.
function BonusStr(C:Currency; P:String):String;

// 177. Заменяет запятую на точку в строковом виде Currency
function CorrCurr(C:String):String;

// 178. Query в Excel
procedure QrToExcel(qr:TADOQuery; Caption:String=''; BottomStr:String='');

IMPLEMENTATION

function SHAutoComplete; external 'ShlWApi' name 'SHAutoComplete';

// Перехід в будь-якій таблиці на запис з номером ID
Function GoToID(T:Ttable; F:String; ID:Integer):Boolean;
var S:String;
 begin
  T.Filter:='';
  T.Filtered:=False;
  S:=T.IndexFieldNames;
  T.IndexFieldNames:=F;
  T.SetKey;
  T.FieldByName(F).AsInteger:=ID;
  GoToID:=T.GoToKey;
  T.IndexFieldNames:=S;
 end;

//перехід в будь-якій таблиці на запис з номером ID iз збереженням фiльтру
Function GoToIDF(T:Ttable; F:String; ID:Integer):Boolean;
var Ft,S:String;
 begin
  Ft:=T.Filter;
  T.Filter:='';
  T.Filtered:=False;
  S:=T.IndexFieldNames;
  T.IndexFieldNames:=F;
  T.SetKey;
  T.FieldByName(F).AsInteger:=ID;
  GoToIDF:=T.GoToKey;
  T.IndexFieldNames:=S;
  T.Filter:=Ft;
  T.Filtered:=True;
 end;

//перехід в будь-якій таблиці на запис iз значенням S
Function GoToStr(T:Ttable; F:String; S:String):Boolean;
var ss:String;
 begin
  T.Filter:='';
  T.Filtered:=False;
  ss:=T.IndexFieldNames;
  T.IndexFieldNames:=F;
  T.SetKey;
  T.FieldByName(F).AsString:=S;
  GoToStr:=T.GoToKey;
  T.IndexFieldNames:=ss;
 end;

// переход по ID по фильтрованой таблице
Function GoToFiltID(T:Ttable; F:String; ID:Integer):Boolean;
var FF:Boolean;
 begin
  FF:=False;
  if T.FindFirst then
   Repeat
    if T.FieldByName(F).AsInteger=ID then begin FF:=True; Break;end;
   Until T.FindNext=False;
  if FF=False then T.FindFirst;
  GoToFiltID:=FF;
 end;

{проверка правильности введеного целого числа}
Function CheckInt(S:String):Boolean;
 begin
  if S<>'' then
   begin
    try
     StrToInt(S); CheckInt:=True;
    except
     on EConvertError do CheckInt:=False;
    end;
   end
  else CheckInt:=True;
 end;

{проверка правильности введеного действительного числа}
Function CheckFloat(S:String):Boolean;
 begin
  if S<>'' then
   begin
    try
     StrToFloat(S); CheckFloat:=True;
    except
     on EConvertError do CheckFloat:=False;
    end;
   end
  else CheckFloat:=True;
 end;

{проверка правильности введеного денежного значения}
Function CheckCurrency(S:String):Boolean;
 begin
  if S<>'' then
   begin
    try
     StrToFloat(S); CheckCurrency:=True;
     if StrToFloat(S)<0 then CheckCurrency:=False;
    except
     on EConvertError do CheckCurrency:=False;
    end;
   end
  else CheckCurrency:=True;
 end;


{Проверка правильности введеной даты}
Function CheckDate(S:String):Boolean;
 begin
  if S<>'  .  .  ' then
   begin
    try
     StrToDate(S); CheckDate:=True;
    except
     on EConvertError do CheckDate:=False;
    end;
   end else CheckDate:=True;
 end;

//Удаление всех записей с таблицы по полю F с целочисленным зачением V  
Procedure DeleteID(T:TTable; F:String; V:Integer);
 begin
  Repeat
   if GoToID(T,F,V)then T.Delete else Break;
  Until False;
  T.Refresh;
 end;

//Удаление всех записей с таблицы по полю F со строковым зачением V
Procedure DeleteStr(T:TTable; F:String; V:String);
 begin
  Repeat
   if GoToStr(T,F,V) then T.Delete else Break;
  Until False;
  T.Refresh;
 end;

// корректировка действительного числа (меняет точку на запятую)
Function CorrectFloatNumXP(N:String):String;
var i:Byte;
    S,ss:String;
    Ch:Char;
    R:TRegistry;
 begin
  R:=TRegistry.Create;
  R.RootKey:=HKEY_CURRENT_USER;
  if R.KeyExists('Control Panel\International') then
   begin
    R.OpenKey('Control Panel\International',False);
    ss:=R.ReadString('sDecimal');
    if (ss='') or (Length(ss)>1) then Ch:=',' else Ch:=ss[1];
   end else Ch:=',';
  R.CloseKey;
  S:=N;
  for i:=1 to Length(S) do if S[i] in ['.',','] then S[i]:=Ch;
  CorrectFloatNumXP:=S;
 end;

// удаление строки со StringGrid
Procedure DelRows(SG:TStringGrid; Num:Integer);
var i,j:Integer;
 begin
  if SG.RowCount<=2 then
   begin
    for j:=1 to SG.ColCount do SG.Cells[j,1]:='';
   end else begin
             for i:=Num to SG.RowCount-1 do
              SG.Rows[i]:=SG.Rows[i+1];
//              for j:=1 to SG.ColCount do SG.Cells[j,i]:=SG.Cells[j,i+1];
             SG.RowCount:=SG.RowCount-1;
            end;
 end;

// перевод денежной формы в строку
Function CurrencyToStr(Price:Real):String;
var S:String[50];
 begin
  Str(Price:4:2,S);
  S:=CorrectFloatNumXP(S);
  CurrencyToStr:=S;
 end;

// форматированный перевод вещественного числа в строку
Function FloatToStrF(F:Real; P1,P2:Byte):String;
var Res:String;
 begin
  Str(F:P1:P2,Res);
  FloatToStrF:=Res;
 end;

// Возвращает имя файла без расширения
Function MyFileName(Name:String):String;
var P,i:Byte;
 begin
  P:=0;
  for i:=Length(Name) downto 1 do
   if Name[i]='.' then begin P:=i; Break; end;
  if P<>0 then Delete(Name,P,Length(Name)-P+1);
  MyFileName:=Name;
 end;

// Удаление файлов по маске
Procedure DeleteFiles(Path:String; Mask:String);
Var DirInfo:TSearchRec;
 begin
  if FindFirst(Trim(Path)+Mask,faArchive,DirInfo)=0 then
   Repeat
    DeleteFile(Trim(Path)+DirInfo.Name);
   Until FindNext(DirInfo)<>0;
 end;

// Дата создания файла
Function GetFileDateTime(FileName:String):TDateTime;
var intFileAge:LongInt;
 begin
  intFileAge:=FileAge(FileName);
  if intFileAge=-1 then Result:=0
                   else Result:=FileDateToDateTime(intFileAge)
 end;

function SetFileDateTime(FileName:String; NewTime:TDateTime):Boolean;
var vhnd: Integer;
 begin
  try
   vhnd:=FileOpen(filename,fmOpenReadWrite);
   if vhnd=-1 then Abort;
   FileSetDate(vhnd,Datetimetofiledate(NewTime));
   FileClose(vhnd);
   Result:=True;
  except
   Result:=False;
  end;
 end;

// Получение системной палитры
function GetSystemPalette:HPalette;
var
 PaletteSize  : integer;
 LogSize      : integer;
 LogPalette   : PLogPalette;
 DC           : HDC;
 Focus        : HWND;
begin
 Focus:=GetFocus;
 DC:=GetDC(Focus);
 try
   PaletteSize:=GetDeviceCaps(DC, SIZEPALETTE);
   LogSize:=SizeOf(TLogPalette)+(PaletteSize-1)*SizeOf(TPaletteEntry);
   GetMem(LogPalette, LogSize);
   try
     with LogPalette^ do
     begin
       palVersion:=$0300;
       palNumEntries:=PaletteSize;
       GetSystemPaletteEntries(DC, 0, PaletteSize, palPalEntry);
     end;
     result:=CreatePalette(LogPalette^);
   finally
     FreeMem(LogPalette, LogSize);
   end;
 finally
   ReleaseDC(Focus, DC);
 end;
end;                             
 
// Копирование прямоугольной области
Function CaptureScreenRect(ARect:TRect):TBitmap;
var ScreenDC:HDC;
 begin                
  Result:=TBitmap.Create;
  with result, ARect do begin
   Width:=Right-Left;
   Height:=Bottom-Top;
   ScreenDC:=GetDC(0);
   try
    BitBlt(Canvas.Handle, 0,0,Width,Height,ScreenDC, Left, Top, SRCCOPY	);
   finally
    ReleaseDC(0, ScreenDC);
   end;
   Palette:=GetSystemPalette;
  end;
 end;

// копирование целого экрана
function CaptureScreen: TBitmap;
 begin
  with Screen do Result:=CaptureScreenRect( Rect( 0, 0, Width, Height ));
 end;

// Замена всех цветов на отенки одного
Procedure ModColors(Bitmap: TBitmap; Color: TColor);

 function GetR(const Color: TColor): Byte; //извлечение красного
  begin
   Result:=Lo(Color);
  end;

 function GetG(const Color: TColor): Byte; //извлечение зелёного
  begin
   Result:=Lo(Color shr 8);
  end;

 function GetB(const Color: TColor): Byte; //извлечение синего
  begin
   Result := Lo((Color shr 8) shr 8);
  end;

 function BLimit(B: Integer): Byte;
  begin
   if B<0 then Result:=0 else if B>255 then Result:=255 else Result:=B;
 end;

 type TRGB=Record
            B,G,R:Byte;
           end;

      pRGB = ^TRGB;

 var  r1,g1,b1:Byte;
      x,y:Integer;
      Dest:pRGB;
      A:Double;

 Begin
  Bitmap.PixelFormat:=pf24Bit;
  r1:=Round(255/100*GetR(Color));
  g1:=Round(255/100*GetG(Color));
  b1:=Round(255/100*GetB(Color));
  for y:=0 to Bitmap.Height-1 do
   begin
    Dest:=Bitmap.ScanLine[y];
    for x:=0 to Bitmap.Width-1 do
     begin
      With Dest^ do
       begin
        A:=(r+b+g)/300;
        With Dest^ do
         begin
          R:=BLimit(Round(r1*A));
          G:=BLimit(Round(g1*A));
          B:=BLimit(Round(b1*A));
         end;
       end;
      Inc(Dest);
     end;
   end;
 end;

Procedure ShowErM(Ed:TCustomEdit; Mes,Cap:String);
var A:TApplication;
 begin
  try
   A:=TApplication.Create(nil);
   try
    A.MessageBox(PChar(Mes),PChar(Cap),MB_ICONWARNING+MB_OK);
   finally
    A.Free;
   end;
  except
   ShowMessage(Mes);
  end;
  Ed.SetFocus;
 end;

function IsEmpty(Ed:TCustomEdit; Mes,Cap:String):Boolean;
 begin
  if Ed.Text='' then
   begin
    ShowErM(Ed,Mes,Cap);
    Result:=False;
   end else Result:=True;
 end;

function IsInt(Ed:TCustomEdit; Mes,Cap:String):Boolean;
 begin
  if Not(CheckInt(Ed.Text)) then
   begin
    ShowErM(Ed,Mes,Cap);
    Result:=False;
   end else Result:=True;
 end;

function IsFloat(Ed:TCustomEdit; Mes,Cap:String):Boolean;
 begin
  if Not(CheckFloat(Ed.Text)) then
   begin
    ShowErM(Ed,Mes,Cap);
    Result:=False;
   end else Result:=True;
 end;

function GetCompName:String;
var s1:PAnsiChar;
    kol:LPDWORD;
    vCompName:String;
 begin
  vCompName:='';
  kol:=nil; s1:=nil;
  try
   new(kol);
   kol^:=MAX_COMPUTERNAME_LENGTH+1;
   GetMem(s1,126);
   GetComputerNameA(s1,kol^);
   vCompName:=s1;
  finally
   Dispose(kol);
   FreeMem(s1,126);
  end;
  Result:=vCompName;
 end;

procedure ClearRegion(SG:TStringGrid; x,y,dx,dy:Integer);
var i,j,ix,iy:Integer;
 begin
  if x>SG.ColCount-1 then x:=SG.ColCount-1;
  if y>SG.RowCount-1 then y:=SG.RowCount-1;

  ix:=x+dx-1;
  iy:=y+dy-1;

  if ix>SG.ColCount-1 then ix:=SG.ColCount-1;
  if iy>SG.RowCount-1 then iy:=SG.RowCount-1;

  for i:=x to ix do for j:=y to iy do SG.Cells[i,j]:='';
 end;

procedure TruncateGrid(SG:TStringGrid);
var i:Integer;
 begin
  for i:=1 to SG.RowCount do SG.Rows[i].Clear;
  SG.RowCount:=2;
 end;

procedure TruncateEmpty(SG:TStringGrid);
var i,j,RC:Integer;
    F:Boolean; 
 begin
  RC:=SG.RowCount;
  for i:=SG.RowCount-1 downto 2 do
   begin
    F:=True;
    for j:=0 to SG.ColCount-1 do
     if SG.Cells[j,i]<>'' then begin F:=False; Break; end;
    if F then begin SG.Rows[i].Clear; Dec(RC); end; 
   end;
  SG.RowCount:=RC;
 end;

function JDateToStr(D:String):String;
 begin
  if Length(D)=8 then
   Result:=Copy(D,7,2)+'.'+Copy(D,5,2)+'.'+Copy(D,1,4)
  else
   Result:=D;
 end;

function StrToReal(S:String):Real;
 begin
  try
   Result:=StrToFloat(S);
  except
   Result:=0;
  end;
 end;

procedure Delay(Sec:Real);
var t1:TDateTime;
 begin
  t1:=Time;
  Repeat
   if (Time-t1)*100000>=Sec then Break;
  Until False;
 end;

function CRC16(S:String):String;
var i,b:Integer;
      t:Byte;
      c:Word;
 begin
  c:=0;
  for i:=1 to Length(S) do
   begin
    t:=Ord(S[i]);
    for b:=1 to 8 do
     begin
      c:=(c shl 1)xor($8005*((t xor Hi(c)) and $80)shr 7);
      t:=t shl 1;
     end;
   end;
  Result:=Chr(Hi(c))+Chr(Lo(c));
 end;


Function CountCRC16(Mem:String):String;
var a,crc16:Word;
    Len,i:Integer;
 begin
 	crc16:=0; i:=1;
  Len:=Length(Mem);
  While Len<>0 do
	 begin
    Dec(Len);
	  crc16:=crc16 xor Ord(Mem[i]);
		a:=crc16 xor crc16*16; a:=a and 255;

		crc16:=crc16 div 256; crc16:=crc16 xor a*256;
    crc16:=crc16 xor a*8; crc16:=crc16 xor (a div 16);


{		a:=(crc16 xor (crc16 shr 4)) and 256;
		crc16:=(crc16 shl 8) xor (a shr 8) xor (a shr 3) xor (a shl 4);
 }
    Inc(i);
	 end;
 Result:=Chr(Hi(crc16))+Chr(Lo(crc16));
 end;

function MSDateToStr(D:String):String;
 begin
  if Length(D) in [10,19,23] then
   Result:=Copy(D,9,2)+'.'+Copy(D,6,2)+'.'+Copy(D,1,4)
  else
   Result:=D;
 end;

function DiskInDrive(Drive: Char): Boolean;
var ErrorMode: Word;
 begin
  if Drive in ['a'..'z'] then Dec(Drive, $20);
  if not (Drive in ['A'..'Z']) then
   raise EConvertError.Create('Not a valid drive ID');
  ErrorMode := SetErrorMode(SEM_FailCriticalErrors);
  try
   if DiskSize(Ord(Drive) - $40) = -1 then
   Result := False
   else
   Result := True;
  finally
   SetErrorMode(ErrorMode);
  end;
 end;

function QuickFormatDiskA(Handle:HWND):Boolean;

const SHFMT_DRV_A = 0;
const SHFMT_DRV_B = 1;
const SHFMT_ID_DEFAULT = $FFFF;
const SHFMT_OPT_QUICKFORMAT = 0;
const SHFMT_OPT_FULLFORMAT = 1;
const SHFMT_OPT_SYSONLY = 2;
const SHFMT_ERROR = -1;
const SHFMT_CANCEL = -2;
const SHFMT_NOFORMAT = -3;

 begin
  try
   ShFormatDrive(Handle,SHFMT_DRV_A,SHFMT_ID_DEFAULT,SHFMT_OPT_QUICKFORMAT);
   Result:=True;
  except
   Result:=False;
  end;
 end;

// Копирование каталога полностью
function CopyDir(const fromDir, toDir: string): Boolean;
var fos: TSHFileOpStruct;
 begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
   begin
    wFunc := FO_COPY;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
   // fFlags := FOF_FILESONLY;
    pFrom := PChar(fromDir + #0);
    pTo := PChar(toDir)
   end;
  Result:=(0=ShFileOperation(fos));
 end;

// Перемещение каталога полностью со всем содержимым
function MoveDir(const fromDir, toDir: string): Boolean;
var fos:TSHFileOpStruct;
 begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
  wFunc:=FO_MOVE;
  fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
  pFrom:=PChar(fromDir+#0);
  pTo:=PChar(toDir)
 end;
 Result:=(0=ShFileOperation(fos));
 end;

// Удаление каталога со всем содержимым
function DelDir(dir: string): Boolean;
 var
 fos: TSHFileOpStruct;
 begin
 ZeroMemory(@fos, SizeOf(fos));
 with fos do
 begin
  wFunc := FO_DELETE;
  fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
  pFrom := PChar(dir + #0);
 end;
 Result := (0 = ShFileOperation(fos));
 end;

procedure PkTable(Table:TTable);
var Props:CURProps;
    hDb:hDBIDb;
    TableDesc:CRTblDesc;
 begin
  if not Table.Active then
    raise EDatabaseError.Create('Table must be opened to pack');
  if not Table.Exclusive then

    raise EDatabaseError.Create('Table must be opened exclusively to pack');

  Check(DbiGetCursorProps(Table.Handle, Props));

  if Props.szTableType = szPARADOX then begin
    FillChar(TableDesc, sizeof(TableDesc), 0);

    Check(DbiGetObjFromObj(hDBIObj(Table.Handle), objDATABASE, hDBIObj(hDb)));
    StrPCopy(TableDesc.szTblName, Table.TableName);
    StrPCopy(TableDesc.szTblType, Props.szTableType);
    TableDesc.bPack := True;
    Table.Close;

    Check(DbiDoRestructure(hDb, 1, @TableDesc, nil, nil, nil, False));
  end
  else
    if (Props.szTableType = szDBASE) or (Props.szTableType = szFoxPro) then
      Check(DbiPackTable(Table.DBHandle, Table.Handle, nil, szFoxPro, True))
    else
      raise EDatabaseError.Create('Table must be either of Paradox or dBASE ' +

        'type to pack');

  Table.Open;
 end;         

Function GetDayWeekNum(D:TDateTime):Integer;
 begin
  if FormatDateTime('dddd',D)='понедельник' then Result:=1 else
  if FormatDateTime('dddd',D)='вторник'     then Result:=2 else
  if FormatDateTime('dddd',D)='среда'       then Result:=3 else
  if FormatDateTime('dddd',D)='четверг'     then Result:=4 else
  if FormatDateTime('dddd',D)='пятница'     then Result:=5 else
  if FormatDateTime('dddd',D)='суббота'     then Result:=6 else
  if FormatDateTime('dddd',D)='воскресенье' then Result:=7 else
                                                 Result:=0;
 end;

Function OpenSQL(Qr:TQuery; SQL:String):Integer;
 begin
  try
   if Qr.Active then Qr.Close;
   Qr.Params.Clear;
   Qr.SQL.Text:=SQL;
   Qr.Open;
   if Qr.RecordCount>0 then Qr.First;
   Result:=Qr.RecordCount;
  except
   Result:=-1;
  end;
 end;

Function ExecSQL(Qr:TQuery; SQL:String):Integer;
 begin
  try
   if Qr.Active then Qr.Close;
   Qr.Params.Clear;
   Qr.SQL.Text:=SQL;
   Qr.ExecSQL;
   Result:=0;
  except
   Result:=-1;
  end;
 end;

Procedure InsertColumn(SG:TStringGrid; N:Integer; V:String);
var i:Integer;
 begin
  SG.ColCount:=SG.ColCount+1;
  if N<=SG.ColCount-1 then
   begin
    for i:=SG.ColCount-2 downto N-1 do SG.Cols[i+1]:=SG.Cols[i];
    for i:=1 to SG.RowCount-1 do SG.Cells[N-1,i]:=V;
   end else for i:=1 to SG.RowCount-1 do SG.Cells[SG.ColCount-1,i]:=V;
 end;

Procedure DeleteColumn(SG:TStringGrid; N:Integer);
var i:Integer;
 begin
  if N<SG.ColCount then
   for i:=N-1 to SG.ColCount-2 do SG.Cols[i]:=SG.Cols[i+1];
  SG.ColCount:=SG.ColCount-1;
 end;

Function DateToStrSlash(D:TDateTime):String;
var Res:String;
    i:Integer;
 begin
  Res:=FormatDateTime('dd.mm.yy',D);
  for i:=1 to Length(Res) do if Res[i]='.' then Res[i]:='/';
  Result:=Res;
 end;

Function DateTimeToStrSlash(D:TDateTime):String;
var Res:String;
    i:Integer;
 begin
  Res:=FormatDateTime('dd.mm.yy',D);
  for i:=1 to Length(Res) do if Res[i]='.' then Res[i]:='/';
  Result:=Res+' '+FormatDateTime('hh:nn',D);
 end;

Function OpenADOSQL(Qr:TDataSet; SQL:String):Integer;
 begin
  try
   if Qr.Active then Qr.Close;
   if (Qr is TADOQuery) then
    begin
     TADOQuery(Qr).SQL.Text:=SQL;
     TADOQuery(Qr).Open;
    end else
   if (Qr is TMSQuery) then
    begin
     TMSQuery(Qr).SQL.Text:=SQL;
     TMSQuery(Qr).Open;
    end;
   if Qr.RecordCount>0 then Qr.First;
   Result:=Qr.RecordCount;
  except
   Result:=-1;
  end;
 end;

Function ExecADOSQL(Qr:TDataSet; SQL:String):Integer;
 begin
  try
   if Qr.Active then Qr.Close;
   if (Qr is TADOQuery) then
    begin
     TADOQuery(Qr).SQL.Text:=SQL;
     TADOQuery(Qr).ExecSQL;
    end else
   if (Qr is TMSQuery) then
    begin
     TMSQuery(Qr).SQL.Text:=SQL;
     TMSQuery(Qr).ExecSQL;
    end;
   Result:=0;
  except
   Result:=-1;
  end;
 end;

// Выгрузка в текст по формату, но работает медленно лучше выгружать через xp_cmdshell
function UnLoadToTxt(var Qr:TQuery; FName:String; FS:TStringList):Boolean;
var B:Boolean;
    F:Text;
    j:Integer;
    S:String;
    Tm:Record
        TN:String;
        FL:Array of Record
                     F:String;
                     P:Integer;
                    end;
       end;
 {

  Структура массива строк FS
  0-я строка имя таблицы
  С 1-й по последнюю строку имена полей и их размерность в формате:

   <имя поля>|<размерность>,

   если <размерность> равна нулю, то поле берется целеком, иначе берется указаное кол-во символов,
   если <размерность> равна -1> то поле берется в формате даты 'yyyy-mm-dd hh:nn:ss.zzz'

 }

 procedure CreateFieldsList;
 var S,F:String;
     CA,i,j,q:Integer;
  begin
   Tm.TN:=FS[0]; SetLength(Tm.FL,0);
   for i:=1 to FS.Count-1 do
    begin
     S:=FS[i]; F:=''; q:=0;
     if Pos('|',S)=0 then raise EAbort.Create('');
     for j:=1 to Length(S) do
      if S[j]<>'|' then F:=F+S[j] else begin q:=j+1; Break; end;

     CA:=High(Tm.FL)+1; SetLength(Tm.FL,CA+1);
     Tm.FL[CA].F:=F;
     Tm.FL[CA].P:=StrToInt(Copy(S,q,Length(S)-q+1));
    end;
  end;

 function GetFieldValue(N:Integer):String;
  begin
   Case Tm.FL[N-1].P of
    -1:Result:=FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',Qr.FieldByName(Tm.FL[N-1].F).AsDateTime);
     0:Result:=Qr.FieldByName(Tm.FL[N-1].F).AsString else
       Result:=Copy(Qr.FieldByName(Tm.FL[N-1].F).AsString,1,Tm.FL[N-1].P);
   end;
  end;

 Begin
  B:=False;
  try
   CreateFieldsList;

   if Qr.Active then Qr.Close;
   Qr.Params.Clear;
   Qr.SQL.Text:='select * from '+Tm.TN;
   Qr.Open;
   if Qr.IsEmpty then raise EAbort.Create('');


   Assign(f,FName);
   ReWrite(f);
   B:=True;

   Qr.First;
   While Not Qr.Eof do
    begin
     S:='';
     for j:=1 to FS.Count-1 do S:=S+GetFieldValue(j)+'|';
     WriteLn(f,S);
     Qr.Next;
    end;

   Close(f);
   B:=False;

   if Qr.Active then Qr.Close;
   Result:=FileExists(FName);
  except
   if Qr.Active then Qr.Close;
   if B then Close(f);
   Result:=False;
  end;
 End;

procedure SetAsMainForm(aForm:TForm);
var P:Pointer;
 begin
  P:=@Application.Mainform;
  Pointer(P^):=aForm;
 end;

function TextPixWidth(S:String; F:TFont):Integer;
var C:TBitMap;
 begin
  try
   C:=TBitMap.Create;
   try
    C.Canvas.Font.Assign(F);
    Result:=C.Canvas.TextWidth(S);
   finally
    C.Free;
   end;
  except
   Result:=-1;
  end;
 end;

function EnableAutoComplete(Handle: THandle; FileSystem, URL: Boolean): Boolean;
const SHACF_FILESYSTEM = $00000001;
      SHACF_URLHISTORY = $00000002;
      SHACF_URLMRU = $00000004;
      SHACF_USETAB = $00000008;
const IFileSystem: array[Boolean] of Cardinal = (0, SHACF_FILESYSTEM);
      IURL: array[Boolean] of Cardinal = (0, SHACF_URLHISTORY or SHACF_URLMRU);
var Flags: Cardinal;
 begin
  Result:=False;
  Flags:=IFileSystem[FileSystem] or IURL[URL];
  if Flags <> 0 then
   begin
    Flags := Flags or SHACF_USETAB;
    Result := SHAutoComplete(Handle, Flags) = 0;
   end;
  end;

function GetR(const Color: TColor): Byte; //извлечение красного
 begin
  Result:=Lo(Color);
 end;

function GetG(const Color: TColor): Byte; //извлечение зелёного
 begin
  Result:=Lo(Color shr 8);
 end;

function GetB(const Color: TColor): Byte; //извлечение синего
 begin
  Result := Lo((Color shr 8) shr 8);
 end;

procedure AppendStringToFile(FName:String; S:String);
var B:Boolean;
    F:Text;
 begin
  B:=False;
  try
   Assign(f,FName);
   if FileExists(FName) then Append(f) else ReWrite(f);
   WriteLn(f,S);
   B:=True;
   Close(f);
   B:=False;
  except
   if B then Close(f);
  end;
 end;

function IsInteger(S:String):Boolean;
 begin
  try
   StrToInt(S);
   Result:=True;
  except
   Result:=False;
  end;
 end;

procedure GetDaysOfMonth(M:Integer; var D1,D31:TDateTime);
var sY,sM:String;
 begin
  if Not (M  in [1..12]) then M:=StrToInt(FormatDateTime('mm',Date));
  if M<10 then sM:='0'+IntToStr(M) else sM:=IntToStr(M);
  sY:=FormatDateTime('yyyy',Date);
  D1:=StrToDate('01.'+sM+'.'+sY);

  if M+1<10 then sM:='0'+IntToStr(M+1) else sM:=IntToStr(M+1);
  if M=12 then D31:=StrToDate('31.12.'+sY)
          else D31:=StrToDate('01.'+sM+'.'+sY)-1;
 end;

procedure GetDriveInfo(VolumeName:String; var VolumeLabel,SerialNumber,FileSystem:String);
var VolLabel,FileSysName:Array[0..255] of Char;
    SerNum:PDword;
    MaxCompLen,FileSysFlags:Dword;
 begin
  New(SerNum);
  GetVolumeInformation(PChar(VolumeName),VolLabel,255,SerNum,MaxCompLen,FileSysFlags,FileSysName,255);
  VolumeLabel:=VolLabel;
  SerialNumber:=Format('%x',[SerNum^]);
  FileSystem:=FileSysName;
  Dispose(SerNum);
 end;

Function BackUpDataBase(Qr:TADOQuery; FileName:String; BaseName:String):Boolean;
 begin
  try
   DeleteFile(FileName);
   Qr.Close;
   Qr.SQL.Text:='BACKUP DATABASE ['+BaseName+'] TO DISK = N'''+FileName+''' WITH  NOFORMAT, INIT,  NAME = N'''+BaseName+' backup'',  SKIP, NOREWIND, NOUNLOAD, STATS = 10';
   Qr.ExecSQL;
   //if Not FileExists(FileName) then Abort;
   Result:=True;
  except
   Result:=False;
  end;
 end;

Procedure BackUpDataBase_(Qr:TADOQuery; FileName:String; BaseName:String);
 begin
  DeleteFile(FileName);
  Qr.Close;
  Qr.SQL.Clear;
  Qr.SQL.Add('BACKUP DATABASE ['+BaseName+'] TO DISK = N'''+FileName+''' WITH  NOFORMAT, INIT,  NAME = N'''+BaseName+' backup'',  SKIP, NOREWIND, NOUNLOAD, STATS = 10 ');
  Qr.SQL.Add('select 7777 as Res');
  Qr.Open;
 end;

Function BackUpDataBaseMS(Qr:TMSQuery; FileName:String; BaseName:String):Boolean;
 begin
  try
   DeleteFile(FileName);
   Qr.Close;
   Qr.SQL.Text:='BACKUP DATABASE ['+BaseName+'] TO DISK = N'''+FileName+''' WITH  INIT ,  NOUNLOAD ,  NAME = N'''+BaseName+' backup'',  NOSKIP ,  STATS = 10,  NOFORMAT';
   Qr.ExecSQL;
   //if Not FileExists(FileName) then Abort;
   Result:=True;
  except
   Result:=False;
  end;
 end;

Function RestoreDataBase(Qr:TADOQuery; FileName:String; BaseName:String; MediaName:String=''):Boolean;
 begin
  try
{   Qr.Close;
   Qr.SQL.Text:='select * from master..sysfiles';
   Qr.Open;
   Qr.First;
   SysPath:=IncludeTrailingBackSlash(ExtractFileDir(Qr.FieldByName('FileName').AsString));
}
   Qr.Close;
{   Qr.SQL.Clear;
   Qr.SQl.Add('RESTORE DATABASE '+BaseName+'         ');
   Qr.SQl.Add('   FROM DISK = '''+FileName+'''       ');
   Qr.SQl.Add('   WITH REPLACE,                      ');
   Qr.SQl.Add('   MOVE '''+MediaName+'_data'' TO '''+SysPath+BaseName+'_Data.MDF'', ');
   Qr.SQl.Add('   MOVE '''+MediaName+'_log'' TO '''+SysPath+BaseName+'_Log.LDF''    ');
}
   Qr.SQL.Text:='exec ekka_net..spY_RestoreDataBase '''+BaseName+''','''+FileName+'''';

   Qr.ExecSQL;
   Result:=True;
  except
   Result:=False;
  end;
 end;

Procedure CreateDataBase(Qr:TADOQuery; BaseName:String);
var SysPath:String;
 begin
  Qr.Close; Qr.SQL.Text:='select * from sysfiles'; Qr.Open; Qr.First;
  SysPath:=ExtractFileDir(Qr.FieldByName('FileName').AsString);
  Qr.Close;
  Qr.SQL.Clear;
  Qr.SQL.Add('CREATE DATABASE ['+BaseName+'] ON (NAME = N'''+BaseName+'_Data'',FILENAME = N'''+SysPath+BaseName+'_Data.MDF'' , SIZE = 23,FILEGROWTH = 1%) ');
  Qr.SQL.Add('                           LOG ON (NAME = N'''+BaseName+'_Log'', FILENAME = N'''+SysPath+BaseName+'_Log.LDF'' , SIZE = 19, FILEGROWTH = 1%) ');
  Qr.SQL.Add(' COLLATE SQL_Latin1_General_CP1251_CI_AS                                                                                                                                    ');
  Qr.SQL.Add('exec sp_dboption N''Annotacii'', N''autoclose'', N''false''                                                                                                                 ');
  Qr.SQL.Add('exec sp_dboption N''Annotacii'', N''bulkcopy'', N''false''                                                                                                                  ');
  Qr.SQL.Add('exec sp_dboption N''Annotacii'', N''trunc. log'', N''false''                                                                                                                ');
  Qr.SQL.Add('exec sp_dboption N''Annotacii'', N''torn page detection'', N''true''                                                                                                        ');
  Qr.SQL.Add('exec sp_dboption N''Annotacii'', N''read only'', N''false''                                                                                                                 ');
  Qr.SQL.Add('exec sp_dboption N''Annotacii'', N''dbo use'', N''false''                                                                                                                   ');
  Qr.SQL.Add('exec sp_dboption N''Annotacii'', N''single'', N''false''                                                                                                                    ');
  Qr.SQL.Add('exec sp_dboption N''Annotacii'', N''autoshrink'', N''false''                                                                                                                ');
  Qr.SQL.Add('exec sp_dboption N''Annotacii'', N''ANSI null default'', N''false''                                                                                                         ');
  Qr.SQL.Add('exec sp_dboption N''Annotacii'', N''recursive triggers'', N''false''                                                                                                        ');
  Qr.SQL.Add('exec sp_dboption N''Annotacii'', N''ANSI nulls'', N''false''                                                                                                                ');
  Qr.SQL.Add('exec sp_dboption N''Annotacii'', N''concat null yields null'', N''false''                                                                                                   ');
  Qr.SQL.Add('exec sp_dboption N''Annotacii'', N''cursor close on commit'', N''false''                                                                                                    ');
  Qr.SQL.Add('exec sp_dboption N''Annotacii'', N''default to local cursor'', N''false''                                                                                                   ');
  Qr.SQL.Add('exec sp_dboption N''Annotacii'', N''quoted identifier'', N''false''                                                                                                         ');
  Qr.SQL.Add('exec sp_dboption N''Annotacii'', N''ANSI warnings'', N''false''                                                                                                             ');
  Qr.SQL.Add('exec sp_dboption N''Annotacii'', N''auto create statistics'', N''true''                                                                                                     ');
  Qr.SQL.Add('exec sp_dboption N''Annotacii'', N''auto update statistics'', N''true''                                                                                                     ');
  Qr.SQL.Add('if(((@@microsoftversion / power(2, 24) = 8) and (@@microsoftversion & 0xffff >= 724) ) or ( (@@microsoftversion / power(2, 24) = 7) and (@@microsoftversion & 0xffff >= 1082) ) ) ');
  Qr.SQL.Add('	exec sp_dboption N''Annotacii'', N''db chaining'', N''false''   ');
  Qr.ExecSQL;
 end;

Procedure GetIntArray(S:String; var A:TIntArray; Spliter:TSetChar);
var CA,V,i:Integer;
    ss:String;
 begin
  ss:='';
  SetLength(A,0);
  for i:=1 to Length(S) do
   begin
    if S[i]=' ' then continue;
    if (S[i] in Spliter) or (i=Length(S)) then
     begin
      try
       if i=Length(S) then ss:=ss+S[i];
       V:=StrToInt(ss);
       CA:=High(A)+1; SetLength(A,CA+1); A[CA]:=V;
      except
      end;
      ss:='';
     end else ss:=ss+S[i];
   end;
 end;

procedure GetStrArray(S:String; var A:TStrArray; Spliter:TSetChar);
var CA,i:Integer;
    ss:String;
 begin
  ss:='';
  SetLength(A,0);
  if S='' then Exit;
  if S[Length(S)] in Spliter then Delete(S,Length(S),1);
  for i:=1 to Length(S) do
   begin
    if (S[i] in Spliter) or (i=Length(S)) then
     begin
      try
       if i=Length(S) then ss:=ss+S[i];
       CA:=High(A)+1; SetLength(A,CA+1); A[CA]:=ss;
      except
      end;
      ss:='';
     end else ss:=ss+S[i];
   end;
 end;

Function IntToWordsUA(D:LongInt; p:Byte):String;
const HN:Array[0..9] of String[15]=
	    ('','сто ','двiстi ','триста ','чотириста ','п''ятсот ',
	     'шiстсот ','сiмсот ','вiсiмсот ','дев''ятсот ');
      DC:Array[0..9] of String[15]=	    ('десять ','одинадцять ','дванадцять ','тринадцать ',
	     'чотирнадцять ','п''ятнадцять ','шiстнадцять ','сiмнадцять ',
	     'вiсiмнадцять ','дев''ятнадцять ');
      KC:Array[0..9] of String[13]=
	    ('','десять ','двадцять ','тридцять ','сорок ','п''ятдесят ',
	     'шiстдесят ','сiмдесят ','вiсiмдесят ','дев''яносто ');
      RM0:Array[0..9] of String[10]=
	    ('','один ','два ','три ','чотири ','п''ять ','шiсть ',
	     'сiм ','вiсiм ','дев''ять ');
      RM1:Array[0..9] of String[10]=
	    ('','одна ','двi ','три ','чотири ','п''ять ','шiсть ',
	     'сiмь ','вiсім ','дев''ять ');
      RM2:Array[0..9] of Integer=(0,1,2,2,2,0,0,0,0,0);
      GR:Array[0..4,0..2] of String[15]=
	    (('','',''),
	     ('тисяч ','тисяча ','тисячi '),
	     ('мiлiонiв ','мiлiон ','мiлiона '),
	     ('мiлiардiв ','мiлiард ','мiлiарда '),
	     ('триллiнiв ','трилiон ','трилiона '));

Var  Res:String;
     S:Array[0..9] of Integer;
     i,q,j:Integer;

{запись любого числа (от 1 до 999) словами}
function IntToStr3(D,p:Integer):String;
var Res:String;
    S:Array[0..9] of Integer;
 begin
  Res:='';
  S[2]:=D mod 10; D:=D div 10;
  S[1]:=D mod 10; D:=D div 10; S[0]:=D;
  Res:=Res+HN[S[0]];
  if S[1]=1 then Res:=Res+DC[S[2]] else
   begin
    Res:=Res+KC[S[1]];
    if p=0 then Res:=Res+RM0[S[2]] else Res:=Res+RM1[S[2]];
   end;
  IntToStr3:=Res;
 end;

 Begin
 if D=1000 then Result:='одна тисяча' else
   begin
    Res:=''; i:=0;
    While D>1000 do begin S[i]:=D mod 1000; D:=D div 1000; Inc(i); end; S[i]:=D;
    for j:=i downto 0 do
     begin
      if j=1 then q:=1 else q:=0;
      if j=0 then q:=p;
      Res:=Res+IntToStr3(S[j],q);
      if S[j] in [11..13] then Res:=Res+GR[j,0]
                          else Res:=Res+GR[j,RM2[S[j] mod 10]];
     end;
    Result:=Res;
   end;
 End;

Function IntToWordsRU(D:LongInt; p:Byte):String;
const HN:Array[0..9] of String[15]=
	    ('','сто ','двести ','триста ','четыреста ','пятьсот ',
	     'шестьсот ','семьсот ','восемьсот ','девятьсот ');
      DC:Array[0..9] of String[15]=	    ('десять ','одиннадцать ','двенадцать ','тринадцать ',
	     'четырнадцать ','пятнадцать ','шестнадцать ','семнадцать ',
	     'восемнадцать ','девятнадцать ');
      KC:Array[0..9] of String[13]=
	    ('','десять ','двадцать ','тридцать ','сорок ','пятьдесят ',
	     'шестьдесят ','семьдесят ','восемьдесят ','девяносто ');

      RM0:Array[0..9] of String[10]=
	    ('','один ','два ','три ','четыре ','пять ','шесть ',
	     'семь ','восемь ','девять ');

      RM1:Array[0..9] of String[10]=
	    ('','одна ','две ','три ','четыре ','пять ','шесть ',
	     'семь ','восемь ','девять ');
      RM2:Array[0..9] of Integer=(0,1,2,2,2,0,0,0,0,0);
      GR:Array[0..4,0..2] of String[15]=
	    (('','',''),
	     ('тысяч ','тысяча ','тысячи '),
	     ('миллионов ','миллион ','миллиона '),
	     ('миллиардов ','миллиард ','миллиарда '),
	     ('триллионов ','триллион ','триллиона '));

Var  Res:String;
     S:Array[0..9] of Integer;
     i,q,j:Integer;

{запись любого числа (от 1 до 999) словами}
function IntToStr3(D,p:Integer):String;
var Res:String;
    S:Array[0..9] of Integer;
 begin
  Res:='';
  S[2]:=D mod 10; D:=D div 10;
  S[1]:=D mod 10; D:=D div 10; S[0]:=D;
  Res:=Res+HN[S[0]];
  if S[1]=1 then Res:=Res+DC[S[2]] else
   begin
    Res:=Res+KC[S[1]];
    if p=0 then Res:=Res+RM0[S[2]] else Res:=Res+RM1[S[2]];
   end;
  IntToStr3:=Res;
 end;

 Begin
  if D=1000 then Result:='одна тисяча' else
   begin
    Res:=''; i:=0;
    While D>1000 do begin S[i]:=D mod 1000; D:=D div 1000; Inc(i); end; S[i]:=D;
    for j:=i downto 0 do
     begin
      if j=1 then q:=1 else q:=0;
      if j=0 then q:=p;
      Res:=Res+IntToStr3(S[j],q);
      if S[j] in [11..13] then Res:=Res+GR[j,0]
                          else Res:=Res+GR[j,RM2[S[j] mod 10]];
     end;
    Result:=Res;
   end;
 End;

function LeadZero(N:Integer):String;
 begin
  if N<10 then Result:='0'+IntToStr(N) else Result:=IntToStr(N);
 end;

Function CurrToWordsRU(C:Currency; P:Byte):String;
var I:Int64;
    Grn:String;
 begin
  C:=StrToCurr(CurrToStrF(C,ffFixed,2));
  I:=Trunc(C);
  Case StrToInt(Copy(IntToStr(I),Length(IntToStr(I))-1,1)) of
   1:Grn:='гривна';
   2..4:Grn:='гривны';
   0,5..9:Grn:='гривен';
  end;
  if I>0 then
   Result:=IntToWordsRU(I,P)+' гривен(ы) '+LeadZero(Trunc(100*(C-I)))+' копеек(а)'
  else
   Result:=LeadZero(Trunc(100*(C-I)))+' копеек(а)';
 end;

Function CurrToWordsUA(C:Currency; P:Byte):String;
var I:Int64;
    Grn:String;
 begin
  C:=StrToCurr(CurrToStrF(C,ffFixed,2));
  I:=Trunc(C);
  Case StrToInt(Copy(IntToStr(I),Length(IntToStr(I))-1,1)) of
   1:Grn:='гривня';
   2..4:Grn:='гривні';
   0,5..9:Grn:='гривень';
  end;
  Result:=IntToWordsUA(I,P)+' гривень(і) '+LeadZero(Trunc(100*(C-I)))+' копійок(а)';
 end;

Function FloatToWordsRu(C:double; P1,P2:Byte):String;
var I:Int64;
 begin
  C:=StrToFloat(FloatToStrF(C,P1,P2));
  I:=trunc(C);
  if C-I=0 then
  begin
    result:=IntToWordsRU(I,0);
    exit;
  end;
  if I>0 then
   Result:=IntToWordsRU(I,0)+' '+LeadZero(Trunc(power(10,P2)*(C-I)))
  else
   Result:=LeadZero(Trunc(power(10,P2)*(C-I)));
 end;

Function FloatToWordsUA(C:double; P1,P2:Byte):String;
var
  I:Int64;
begin
  C:=StrToFloat(FloatToStrF(C,P1,P2));
  I:=trunc(C);
  if C-I=0 then
  begin
    result:=IntToWordsUA(I,0);
    exit;
  end;
  if I>0 then
   Result:=IntToWordsUA(I,0)+' '+LeadZero(Trunc(power(10,P2)*(C-I)))
  else
   Result:=LeadZero(Trunc(power(10,P2)*(C-I)));
end;

Function PrPath:String;
 begin
  Result:=ExtractFileDir(Application.ExeName);
 end;

Function WorkPath:String;
 begin
  Result:=ExtractFileDir(Application.ExeName)+'\Work';
 end;

function GetFileSize(FName:String):Int64;
var F:File;
    B:Boolean;
 begin
  B:=False;
  try
   System.Assign(F,FName);
   System.ReSet(F,1);
   B:=True;
   Result:=Int64(FileSize(F));
   System.Close(F);
   B:=False;
  except
   if B then System.Close(F);
   Result:=0;
  end;
 end;

function UnArhCheks(FName,ToF:String):Boolean;
var i:Integer;
    P:Byte;
    F:Text;
    S,TxtName:String;
    B:Boolean;
    Tb:TTable;
 begin
  B:=False;
  try
   P:=1;
   if UpperCase(ExtractFileName(FName))='ARHCHEKS.DB' then P:=1 else
   if UpperCase(ExtractFileName(FName))='MOVES.DB' then P:=2 else
   if UpperCase(ExtractFileName(FName))='SPRTOV.DB' then P:=3 else
   if UpperCase(ExtractFileName(FName))='ARHDISC.DB' then P:=4 else Abort;

   Tb:=TTable.Create(nil);
   if Not (FileExists(FName)) then Abort;
   Tb.TableName:=FName;
   try
    TxtName:=ToF;
    Tb.Open;
    Assign(f,TxtName);
    ReWrite(f);
    B:=True;
    for i:=1 to Tb.RecordCount do
     begin
      if i=1 then Tb.First else Tb.Next;
      Case P of
       1:S:=Tb.FieldByName('ROW_ID').AsString+'|'+
            FormatDateTime('yyyy-mm-dd',Tb.FieldByName('DATE_CHEK').AsDateTime)+' '+
            FormatDateTime('hh:nn:ss',Tb.FieldByName('TIMES').AsDateTime)+'|'+
            Tb.FieldByName('NUMB_CHEK').AsString+'|'+
            Tb.FieldByName('KOD_NAME').AsString+'|'+
            Copy(Tb.FieldByName('NAME').AsString,1,14)+'|'+
            Tb.FieldByName('KOL').AsString+'|'+
            Tb.FieldByName('CENA').AsString+'|'+
            Tb.FieldByName('SUMROW').AsString+'|'+
            Tb.FieldByName('KASSA_NUM').AsString+'|'+
            Tb.FieldByName('TYPE_TOV').AsString+'|0|0|';
       2:S:=InttoStr(i)+'|'+
            Copy(Tb.FieldByName('NN_NAKL').AsString,1,12)+'|'+
            FormatDateTime('yyyy-mm-dd',Tb.FieldByName('DATE_NAKL').AsDateTime)+' 00:00:00.000|'+
            Tb.FieldByName('KOD_NAME').AsString+'|'+
            Tb.FieldByName('KOL').AsString+'|'+
            Tb.FieldByName('CENA').AsString+'|'+
            Tb.FieldByName('F_NDS').AsString+'|'+
            Tb.FieldByName('TYPE_TOV').AsString+'|'+
            Tb.FieldByName('TYPE_NAKL').AsString+'|'+
            Tb.FieldByName('DEBCRD').AsString+'|';
       3:S:=Tb.FieldByName('KOD_NAME').AsString+'|'+
            Tb.FieldByName('ART_CODE').AsString+'|'+
            Tb.FieldByName('NAME').AsString+'|'+
            Copy(Tb.FieldByName('ART_NAME').AsString,1,14)+'|'+
            Tb.FieldByName('OSTAT').AsString+'|'+
            Tb.FieldByName('F_NDS').AsString+'|'+
            Tb.FieldByName('TYPE_TOV').AsString+'|'+
            Tb.FieldByName('CENA').AsString+'|'+
            Tb.FieldByName('OSTAT_BEG').AsString+'|'+
            Tb.FieldByName('CENA_BEG').AsString+'|';
       4:S:=IntToStr(i)+'|'+
            IntToStr(i)+'|'+
            FormatDateTime('yyyy-mm-dd hh:nn:ss',Tb.FieldByName('DATE_CHEK').AsDateTime)+'|'+
            Tb.FieldByName('NUMB_CHEK').AsString+'|'+
            Tb.FieldByName('KOD_NAME').AsString+'|'+
            Tb.FieldByName('KOL').AsString+'|'+
            Tb.FieldByName('CENA').AsString+'|'+
            Tb.FieldByName('SKD').AsString+'|'+
            Tb.FieldByName('SUM_SKD').AsString+'|'+
            IntToStr(Tb.FieldByName('NumCard').AsInteger)+'|';
      end;
      WriteLn(f,S);
     end;
    Close(f);
    B:=False;
    if Not (FileExists(ToF)) then Abort;
    Result:=True;
   finally
    Tb.Close; Tb.Free;
   end;
  except
   if B then Close(f);
   Result:=False;
  end;
 end;

function UnArhCheksNew(FName,ToF:String):Boolean;
var i:Integer;
    P:Byte;
    F:Text;
    S,TxtName:String;
    B:Boolean;
    Tb:TTable;
 begin
  B:=False;
  try
   P:=1;
   if UpperCase(ExtractFileName(FName))='ARHCHEKS.DB' then P:=1 else
   if UpperCase(ExtractFileName(FName))='MOVES.DB' then P:=2 else
   if UpperCase(ExtractFileName(FName))='SPRTOV.DB' then P:=3 else
   if UpperCase(ExtractFileName(FName))='ARHDISC.DB' then P:=4 else
   if UpperCase(ExtractFileName(FName))='EXPCHEKS.DB' then P:=1 else
   if UpperCase(ExtractFileName(FName))='EXPMOVES.DB' then P:=2 else
   if UpperCase(ExtractFileName(FName))='EXPDISC.DB' then P:=4 else
   if UpperCase(ExtractFileName(FName))='JMOVES.DB' then P:=5 else
   if UpperCase(ExtractFileName(FName))='CARDUSER.DB' then P:=7 else
   if UpperCase(ExtractFileName(FName))='JOURNZ.DB' then P:=8 else
   if UpperCase(ExtractFileName(FName))='CARDS.DB' then P:=6 else Abort;

   Tb:=TTable.Create(nil);
   if Not (FileExists(FName)) then Abort;
   Tb.TableName:=FName;
   try
    TxtName:=ToF;
    Tb.Open;
    Assign(f,TxtName);
    ReWrite(f);
    B:=True;
    for i:=1 to Tb.RecordCount do
     begin
      if i=1 then Tb.First else Tb.Next;
      Case P of
       1:S:=Tb.FieldByName('ROW_ID').AsString+'|'+
            FormatDateTime('yyyy-mm-dd',Tb.FieldByName('DATE_CHEK').AsDateTime)+' '+
            FormatDateTime('hh:nn:ss',Tb.FieldByName('TIMES').AsDateTime)+'|'+
            Tb.FieldByName('NUMB_CHEK').AsString+'|'+
            Tb.FieldByName('KOD_NAME').AsString+'|'+
            Copy(Tb.FieldByName('NAME').AsString,1,14)+'|'+
            Tb.FieldByName('KOL').AsString+'|'+
            Tb.FieldByName('CENA').AsString+'|'+
            Tb.FieldByName('SUMROW').AsString+'|'+
            Tb.FieldByName('KASSA_NUM').AsString+'|'+
            Tb.FieldByName('TYPE_TOV').AsString+'|1|1|0|0|';
            
       2:S:=InttoStr(i)+'|'+
            Copy(Tb.FieldByName('NN_NAKL').AsString,1,12)+'|'+
            FormatDateTime('yyyy-mm-dd',Tb.FieldByName('DATE_NAKL').AsDateTime)+' 00:00:00.000|'+
            Tb.FieldByName('KOD_NAME').AsString+'|'+
            Tb.FieldByName('KOL').AsString+'|'+
            Tb.FieldByName('CENA').AsString+'|'+
            Tb.FieldByName('F_NDS').AsString+'|'+
            Tb.FieldByName('TYPE_TOV').AsString+'|'+
            Tb.FieldByName('DEBCRD').AsString+'|'+
            Tb.FieldByName('DEBCRD').AsString+'|';

       3:S:=Tb.FieldByName('KOD_NAME').AsString+'|'+
            Tb.FieldByName('ART_CODE').AsString+'|'+
            Tb.FieldByName('NAME').AsString+'|'+
            Copy(Tb.FieldByName('ART_NAME').AsString,1,14)+'|'+
            Tb.FieldByName('OSTAT').AsString+'|'+
            Tb.FieldByName('F_NDS').AsString+'|'+
            Tb.FieldByName('TYPE_TOV').AsString+'|'+
            Tb.FieldByName('CENA').AsString+'|'+
            Tb.FieldByName('OSTAT_BEG').AsString+'|'+
            Tb.FieldByName('CENA_BEG').AsString+'|';

       4:S:=IntToStr(i)+'|'+
            IntToStr(i)+'|'+
            FormatDateTime('yyyy-mm-dd hh:nn:ss',Tb.FieldByName('DATE_CHEK').AsDateTime)+'|'+
            Tb.FieldByName('NUMB_CHEK').AsString+'|'+
            Tb.FieldByName('KOD_NAME').AsString+'|'+
            Tb.FieldByName('KOL').AsString+'|'+
            Tb.FieldByName('CENA').AsString+'|'+
            Tb.FieldByName('SKD').AsString+'|'+
            Tb.FieldByName('SUM_SKD').AsString+'|'+
            IntToStr(Tb.FieldByName('NumCard').AsInteger)+'|';

       5:S:=InttoStr(i)+'|'+
            Copy(Tb.FieldByName('NN_NAKL').AsString,1,12)+'|'+
            FormatDateTime('yyyy-mm-dd',Tb.FieldByName('DATE_NAKL').AsDateTime)+' 00:00:00.000|'+
            Tb.FieldByName('SUMMA').AsString+'|'+
            Tb.FieldByName('F_NDS').AsString+'|'+
            Tb.FieldByName('TYPE_TOV').AsString+'|'+
            Tb.FieldByName('TYPE_NAKL').AsString+'|0|'+
            IntToSTr(Tb.FieldByName('PRIZNAK').AsInteger)+'|';

       6:S:=Tb.FieldByName('NumCard').AsString+'|'+
            Tb.FieldByName('Summa').AsString+'|';

       7:S:=Tb.FieldByName('NumCard').AsString+'|'+
            Copy(Tb.FieldByName('FIO').AsString,1,100)+'|'+
            Copy(Tb.FieldByName('Pasp').AsString,1,50)+'|'+
            Copy(Tb.FieldByName('Phone').AsString,1,20)+'|'+
            Copy(Tb.FieldByName('Address').AsString,1,100)+'|'+
            Copy(Tb.FieldByName('Prov').AsString,1,50)+'|';

       8:S:=FormatDateTime('yyyy-mm-dd',Tb.FieldByName('DATEZ').AsDateTime)+' '+
            FormatDateTime('hh:nn:ss',Tb.FieldByName('TIMEZ').AsDateTime)+'|'+
            IntToStr(Tb.FieldByName('NumZ').AsInteger)+'|'+
            '1|'+
            Tb.FieldByName('Sum1').AsString+'|'+
            Tb.FieldByName('Sum2').AsString+'|'+
            Tb.FieldByName('Sum3').AsString+'|'+
            Tb.FieldByName('Sum4').AsString+'|'+
            Tb.FieldByName('Sum5').AsString+'|'+
            Tb.FieldByName('Sum6').AsString+'|'+
            Tb.FieldByName('Sum7').AsString+'|'+
            Tb.FieldByName('Sum8').AsString+'|';
      end;
      WriteLn(f,S);
     end;
    Close(f);
    B:=False;
    if Not (FileExists(ToF)) then Abort;
    Result:=True;
   finally
    Tb.Close; Tb.Free;
   end;
  except
   if B then Close(f);
   Result:=False;
  end;
 end;

function RestoreTxtTable(Qr:TADOQuery; FName,TName,BName:String):Boolean;
 begin
  try
   if Qr.Active then Qr.Close;
   Qr.Parameters.Clear;
   Qr.SQL.Clear;
   Qr.SQL.Add('Begin Tran tr1');
   Qr.SQL.Add('Truncate Table '+BName+'..'+TName);
   Qr.SQL.Add('BULK INSERT '+BName+'..'+TName+' from '''+FName+''' with (FIELDTERMINATOR = ''|'', ROWTERMINATOR = ''|\n'', CODEPAGE = 1251)');
   Qr.SQL.Add('Commit Tran tr1');
   Qr.ExecSQL;
   Result:=True;
  except
   Result:=False;
  end;
 end;

function OemToChar(N:Byte):Char;
 begin
  if N=252 then Result:=Chr(185) else
  if N=241 then Result:=Chr(184) else
  if N in [128..175] then Result:=Chr(N+64) else
  if N in [224..239] then Result:=Chr(N+16)
                     else Result:=Chr(N);
 end;

function CharToOem(N:Char):Byte;
 begin
  if Ord(N)=178 then Result:=73 else
  if Ord(N)=179 then Result:=105 else
  if Ord(N)=170 then Result:=242 else
  if Ord(N)=186 then Result:=243 else
  if Ord(N)=175 then Result:=244 else
  if Ord(N)=191 then Result:=245 else
  if N='№' then Result:=252 else
  if N='ё' then Result:=241 else
  if N in ['А'..'п'] then Result:=Ord(N)-64 else
  if N in ['р'..'я'] then Result:=Ord(N)-16
                     else Result:=Ord(N);
 end;

function GetKioskName(S:String):String;
var ss:String;
    i:Integer;
 begin
  ss:='';
  for i:=1 to Length(S) do
   if S[i]<>'"' then ss:=ss+S[i];
  ss:=Copy(ss,Pos('(',ss)+1,Length(ss)-Pos('(',ss));
  Result:=Copy(ss,1,Length(ss)-1);
 end;

function ProcessExists(ExeName:String):Cardinal;
var h:Cardinal;
    p:tagPROCESSENTRY32;
    fnd:boolean;
    pr_name:String;
 begin
  Result:=0;
  // Делаем снепшот системы.
  h := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  p.dwSize := SizeOf(tagPROCESSENTRY32);
  // Находим первый процесс.
  fnd:=Process32First(h,p);
  // Цикл перебора всех процессов в системе.
  While fnd do
   begin
   // Узнаём имя найденного процесса.
    pr_name:=StrRScan(p.szExeFile, #0);
    if pr_name='' then pr_name:=p.szExeFile
                  else Delete(pr_name,1,1);
    // Проверяем имя найденного процесса и сверяем его PID с PID-ом нашего процесса.
    if AnsiUpperCase(pr_name)=AnsiUpperCase(ExeName) then
     begin
      // Вторая копия нашей программы уже существует,заканчиваем цикл и выходим.
      fnd:=false;
      result:=p.th32ProcessID;
     end else //Сходий процесс не найден, продолжаем перебор
              fnd:=Process32Next(h,p);
   end;
  // Закрываем наш снепшот.
  CloseHandle(h);
 end;

function GetExeNameByProcID(ProcID:DWord):String;
var ContinueLoop:Boolean;
    FSnapshotHandle:THandle;
    FProcessEntry32:TProcessEntry32;
 begin
  FSnapshotHandle:= CreateToolhelp32Snapshot (TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := '';
  While (Integer (ContinueLoop) <> 0) and (Result='') do
   begin
    if FProcessEntry32.th32ProcessID = ProcID then
     Result := FProcessEntry32.szExeFile;
   ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
 end;

function GetHandleByExeName(Handle:HWND; ExeName:String):HWND;
var Wnd: hWnd;
    buff: array[0..127] of Char;
    pProcID:^DWORD;
    S:String;
 begin
  try
   Result:=0;
   Wnd:=GetWindow(Application.Handle,gw_HWndFirst);
   While Wnd<>0 do
    begin {Не показываем:}
     if (Wnd<>Application.Handle) and {-Собственное окно}
        IsWindowVisible(Wnd) and {-Невидимые окна}
        (GetWindow(Wnd, gw_Owner) = 0) and {-Дочернии окна}
        (GetWindowText(Wnd, buff, sizeof(buff)) <> 0) then {-Окна без заголовков}
      begin
       GetMem (pProcID,SizeOf(DWORD));
       try
        GetWindowThreadProcessId(Wnd,pProcID);
        S:=GetExeNameByProcID(pProcID^);
        if AnsiUpperCase(S)=AnsiUpperCase(ExeName) then
         begin
          Result:=Wnd;
          Exit;
         end;
       finally
        FreeMem(pProcID);
       end;
      end;
     Wnd:=GetWindow(Wnd,gw_hWndNext);
    end;
  except
   Result:=0;
  end;
 end;

function GetProgramFilesDir:String;
var Reg:TRegistry;
 begin
  Reg:=TRegistry.Create;
  try
   reg.RootKey := HKEY_LOCAL_MACHINE;
   reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion', False);
   Result := reg.ReadString('ProgramFilesDir');
  finally
   reg.Free;
  end;
 end;

procedure ShowMessageI(I:Int64);
 begin
  ShowMessage(IntToStr(I));
 end;

procedure ShowMessageC(I:Currency);
 begin
  ShowMessage(CurrToStr(I));
 end;

procedure CreateShortCut(FN,Cap:String);
var MyObject:IUnknown;
    MySLink:IShellLink;
    MyPFile:IPersistFile;
    Directory:String;
    WFileName:WideString;
    MyReg:TRegIniFile;
 begin
  try
   MyObject:=CreateComObject(CLSID_ShellLink);
   MyReg:=TRegIniFile.Create('Software\MicroSoft\Windows\CurrentVersion\Explorer');
   try
    MySLink:=MyObject as IShellLink;
    MyPFile:=MyObject as IPersistFile;
    with MySLink do
     begin
      SetPath(PChar(FN));
      SetWorkingDirectory(PChar(ExtractFilePath(FN)));
     end;
    // Используйте следующую строчку кода для создания ярлыка на рабочем столе
    Directory := MyReg.ReadString('Shell Folders','Desktop','');
    // Используйте следующие три строчки для создания ярлыка в главном меню
    //  Directory := MyReg.ReadString('Shell Folders','Start Menu','')+
    //      '\Рулез!';
    //  CreateDir(Directory);
    WFileName:=Directory+'\'+Cap+'.lnk';
    MyPFile.Save(PWChar(WFileName),False);
   finally
    MyReg.Free;
   end;
  except
  end;
 end;

function GetMyDocsDir:String;
var Buf:Array[0..MAX_PATH] of Char;
    PIDL:PItemIDList;
 begin
  SHGetSpecialFolderLocation(0, CSIDL_PERSONAL, PIDL);
  SHGetPathFromIDList(PIDL,@Buf[0]);
  Result:=PChar(@Buf[0]);
 end;

function GetSystemDir:String;
var szPath:Array[0..MAX_PATH-1] of Char;
 begin
  GetSystemDirectory(szPath,MAX_PATH);
  Result:=StrPas(szPath);
 end;

function GetRegistryIconHandle(FileName:String):HICON;
var
  R: TRegistry;
  Alias, //псевдвним для расширения в реестре
  IconPath: String; //путь для файла с иконкой
  IconNum, //номер иконки в файле
  QPos:Integer; //позиция запятой в записи реестра
 begin
  IconNum:=0;
  R := TRegistry.Create;
  try
    R.RootKey := HKEY_CLASSES_ROOT;
    //чтение псевданима
    if R.OpenKey('\' + ExtractFileExt(FileName), True) then Alias:=R.ReadString('');
    R.CloseKey;
    //чтение записи об иконке
    if R.OpenKey('\' + Alias + '\DefaultIcon', True) then
      IconPath := R.ReadString('');
    R.CloseKey;
    //поиск запятой
    QPos := Pos(',', IconPath);
    //чтение номера иконки в файле если она имеется
    if QPos <> 0 then
     begin
      IconNum := StrToInt(Copy(IconPath, QPos + 1, 4));
      IconPath := Copy(IconPath, 1, QPos - 1)
     end;
  finally
    R.Free;
  end;
  //передача хендлера иконки как рещультат выполнения
  Result := ExtractIcon(hInstance, PChar(IconPath), IconNum);
 end;

function TableExists(Qr:TADOQuery; Tb:String):Boolean;
 begin
  try
   Qr.Close;
   Qr.SQL.Text:='select * from sysobjects where name ='''+Tb+''' and sysstat & 0xf = 3';
   Qr.Open;
   if Qr.IsEmpty then Abort;
   Result:=True;
  except
   Qr.Close;
   Result:=False;
  end;
 end;

function GetDivPoint:Char;
 begin
  try
   StrToCurr('1.1');
   Result:='.';
  except
   StrToCurr('1,1');
   Result:=',';
  end;
 end;

function CorrFloatNum(N:String):String;
var i:Integer;
    Ch:Char;
 begin
  if N='' then begin Result:='0'; Exit; end;
  Result:='';
  Ch:=GetDivPoint;
  for i:=1 to Length(N) do
   if N[i] in [',','.'] then Result:=Result+Ch else Result:=Result+N[i];
 end;

function IntToStrF(I:Int64; P:Integer):String;
var j:Integer;
    ss,S:String;
 begin
  S:=IntToStr(I);
  ss:='';
  if Length(S)>P then Result:=Copy(S,Length(S)-P+1,P) else
   begin
    for j:=1 to P-Length(S) do ss:=ss+'0';
    Result:=ss+S;
   end;
 end;

function IntToStrFL(I:Int64; P:Integer):String;
var j:Integer;
    ss,S:String;
 begin
  S:=IntToStr(I);
  ss:='';
  if Length(S)>P then Result:=Copy(S,Length(S)-P+1,P) else
   begin
    for j:=1 to P-Length(S) do ss:='0'+ss;
    Result:=ss+S;
   end;
 end;

function CurrToStr2(C:Currency; P:Integer):String;
 begin
  Result:=IntToStrF(Round(C*100),P);
 end;

function CopyStrF(S:String; P:Integer):String;
var i,k:Integer;
 begin
  if Length(S)>=P then Result:=Copy(S,1,P) else
   begin
    k:=P-Length(S);
    Result:=S;
    for i:=1 to k do Result:=Result+' ';
   end;
 end;

function CopyStrR(S:String; P:Integer):String;
var i,k:Integer;
 begin
  if Length(S)>=P then Result:=Copy(S,1,P) else
   begin
    k:=P-Length(S);
    Result:=S;
    for i:=1 to k do Result:=' '+Result;
   end;
 end;

function RoundCurr(C:Double):Currency;
var // dr:Double;
   // n:Integer;
    S:String;
 begin
 { C:=C*100;
  dr:=C-Floor(C);
  if (dr>=0.5) then n:=Floor(C)+1 else n:=Floor(C);
  Result:=n/100.;
 }
  Str(C:2:2,S);
  Result:=StrToCurr(S);
 end;

function SaveQrToText(Qr:TADOQuery; FName:String):Boolean;
var B:Boolean;
    F:Text;
    i,j:Integer;
    S:String;
 begin
  B:=False;
  try
   Assign(f,FName);
   ReWrite(f);
   B:=True;
   for i:=1 to Qr.RecordCount do
    begin
     if i=1 then Qr.First else Qr.Next;
     S:='';
     for j:=0 to Qr.Fields.Count-1 do S:=S+Qr.Fields[j].AsString+'|';
     WriteLn(f,S);
    end;
   Close(f);
   B:=False;
   if Not(FileExists(FName)) then Abort;
   Result:=True;
  except
   if B then Close(f);
   Result:=False;
  end;
 end;

function CorrSQLString(S:String):String;
var i:Integer;
 begin
  for i:=1 to Length(S) do
   if S[i]='''' then S[i]:='"' else
   if S[i]='|' then S[i]:='/';
  Result:=S;
 end;

function CorrSQLString1(S:String):String;
var i:Integer;
 begin
  Result:=StringReplace(S,'''','''''',[rfReplaceAll, rfIgnoreCase]);
 end;

procedure AbortS(S:String);
 begin
  raise EAbort.Create(S);
 end;

function StrToColor(S:String):TColor;
 begin
  S:=AnsiUpperCase(S);
  if S=AnsiUpperCase('clScrollBar')               then Result:=clScrollBar               else
  if S=AnsiUpperCase('clBackground')              then Result:=clBackground              else
  if S=AnsiUpperCase('clActiveCaption')           then Result:=clActiveCaption           else
  if S=AnsiUpperCase('clInactiveCaption')         then Result:=clInactiveCaption         else
  if S=AnsiUpperCase('clMenu')                    then Result:=clMenu                    else
  if S=AnsiUpperCase('clWindow')                  then Result:=clWindow                  else
  if S=AnsiUpperCase('clWindowFrame')             then Result:=clWindowFrame             else
  if S=AnsiUpperCase('clMenuText')                then Result:=clMenuText                else
  if S=AnsiUpperCase('clWindowText')              then Result:=clWindowText              else
  if S=AnsiUpperCase('clCaptionText')             then Result:=clCaptionText             else
  if S=AnsiUpperCase('clActiveBorder')            then Result:=clActiveBorder            else
  if S=AnsiUpperCase('clInactiveBorder')          then Result:=clInactiveBorder          else
  if S=AnsiUpperCase('clAppWorkSpace')            then Result:=clAppWorkSpace            else
  if S=AnsiUpperCase('clHighlight')               then Result:=clHighlight               else
  if S=AnsiUpperCase('clHighlightText')           then Result:=clHighlightText           else
  if S=AnsiUpperCase('clBtnFace')                 then Result:=clBtnFace                 else
  if S=AnsiUpperCase('clBtnShadow')               then Result:=clBtnShadow               else
  if S=AnsiUpperCase('clGrayText')                then Result:=clGrayText                else
  if S=AnsiUpperCase('clBtnText')                 then Result:=clBtnText                 else
  if S=AnsiUpperCase('clInactiveCaptionText')     then Result:=clInactiveCaptionText     else
  if S=AnsiUpperCase('clBtnHighlight')            then Result:=clBtnHighlight            else
  if S=AnsiUpperCase('cl3DDkShadow')              then Result:=cl3DDkShadow              else
  if S=AnsiUpperCase('cl3DLight')                 then Result:=cl3DLight                 else
  if S=AnsiUpperCase('clInfoText')                then Result:=clInfoText                else
  if S=AnsiUpperCase('clInfoBk')                  then Result:=clInfoBk                  else
  if S=AnsiUpperCase('clHotLight')                then Result:=clHotLight                else
  if S=AnsiUpperCase('clGradientActiveCaption')   then Result:=clGradientActiveCaption   else
  if S=AnsiUpperCase('clGradientInactiveCaption') then Result:=clGradientInactiveCaption else
  if S=AnsiUpperCase('clMenuHighlight')           then Result:=clMenuHighlight           else
  if S=AnsiUpperCase('clMenuBar')                 then Result:=clMenuBar                 else
  if S=AnsiUpperCase('clBlack')                   then Result:=clBlack                   else
  if S=AnsiUpperCase('clMaroon')                  then Result:=clMaroon                  else
  if S=AnsiUpperCase('clGreen')                   then Result:=clGreen                   else
  if S=AnsiUpperCase('clOlive')                   then Result:=clOlive                   else
  if S=AnsiUpperCase('clNavy')                    then Result:=clNavy                    else
  if S=AnsiUpperCase('clPurple')                  then Result:=clPurple                  else
  if S=AnsiUpperCase('clTeal')                    then Result:=clTeal                    else
  if S=AnsiUpperCase('clGray')                    then Result:=clGray                    else
  if S=AnsiUpperCase('clSilver')                  then Result:=clSilver                  else
  if S=AnsiUpperCase('clRed')                     then Result:=clRed                     else
  if S=AnsiUpperCase('clLime')                    then Result:=clLime                    else
  if S=AnsiUpperCase('clYellow')                  then Result:=clYellow                  else
  if S=AnsiUpperCase('clBlue')                    then Result:=clBlue                    else
  if S=AnsiUpperCase('clFuchsia')                 then Result:=clFuchsia                 else
  if S=AnsiUpperCase('clAqua')                    then Result:=clAqua                    else
  if S=AnsiUpperCase('clLtGray')                  then Result:=clLtGray                  else
  if S=AnsiUpperCase('clDkGray')                  then Result:=clDkGray                  else
  if S=AnsiUpperCase('clWhite')                   then Result:=clWhite                   else
  if S=AnsiUpperCase('clMoneyGreen')              then Result:=clMoneyGreen              else
  if S=AnsiUpperCase('clSkyBlue')                 then Result:=clSkyBlue                 else
  if S=AnsiUpperCase('clCream')                   then Result:=clCream                   else
  if S=AnsiUpperCase('clMedGray')                 then Result:=clMedGray
                                                  else Result:=StrToInt(S);
 end;

function CenterStr(S:String; C:Integer):String;
var k,i:Integer;
    Res:String;
const Ch=' ';
 begin

  if Length(S)>=C then Result:=Copy(S,1,C) else
   begin
    k:=(C-Length(S)) div 2;
    Res:=S;
    for i:=1 to k do Res:=Ch+Res+Ch;
    Result:=Copy(Res+Ch+Ch+Ch,1,C);
   end;
 end;

function AddStr(S1,S2:String; Param:Integer):String;
var i,Kol:Integer;
 begin
  Kol:=Param-Length(S1)-Length(S2);
  Result:=S1;
  for i:=1 to kol do Result:=Result+' ';
  Result:=Result+S2;
 end;

function AddStr_(S:String; Ch:Char; Param:Integer):String;
var i,Kol:Integer;
 begin
  Kol:=Param-Length(S);
  for i:=1 to kol do S:=Ch+S;
  Result:=S;
 end;

(*function LoadTmpNakl(ADOCo:TADOConnection; Qr:TADOQuery; FName:String; Silent:Byte=0; UserID:Integer=0):Boolean;
var F:System.Text;
    B,B1:Boolean;
    S:String;
    A:TStrArray;
    sDD,Tn:String;

 begin
  B:=False;
  try
   if GetFileSize(FName)<10 then Exit;
   System.Assign(F,FName);
   System.ReSet(F);
   B:=True;
   B1:=True;
//   ADOCo.BeginTrans;
   try
    Qr.Close;
    Qr.SQL.Clear;
//    Qr.SQL.Add('if Object_ID(N''tmpnakl1'') is not null drop table tmpnakl1 ');
    Qr.SQL.Add('if Object_ID(N''tempdb..#tmpnakl'') is not null drop table #tmpnakl ');
    Qr.SQL.Add('select top 0 NN_NAKL,DATE_NAKL,id_part8 as KOD_NAME,ART_CODE,NAMES,ART_NAME,KOL,CENA,F_NDS,TYPE_TOV,TYPENAKL,OBL,ID_POSTAV_,NN_POSTAV,convert(int,0) as id_apteka,sklad,nready,cenap,Stamp,DeliveryDate into #tmpnakl from TmpNakl');
//    Qr.SQL.Add('delete from TmpNakl where date_nakl<getdate()-1 or id_user='+IntToStr(UserID);
    Qr.ExecSQL;

    While Not(Eof(f)) do
     begin
      ReadLn(f,S);
      GetStrArray(S,A,['|']);
      Tn:='1';
      if StrToInt(A[6])=0 then Tn:='2';
      try
       if A[17]='' then sDD:='1900-01-01'
                   else sDD:=FormatDateTime('yyyy-mm-dd',StrToDate(A[17]));
      except
       sDD:='1900-01-01';
      end;

      Qr.Close;
      Qr.SQL.Clear;
      Qr.SQL.Add('Insert Into #tmpnakl(NN_NAKL,DATE_NAKL,KOD_NAME,ART_CODE,NAMES,ART_NAME,KOL,CENA,F_NDS,TYPE_TOV,TYPENAKL,OBL,ID_POSTAV_,NN_POSTAV,ID_APTEKA,SKLAD,NREADY,CENAP,DeliveryDate,Stamp)');
      Qr.SQL.Add('Values ('''+A[0]+''','''+FormatDateTime('yyyy-mm-dd',StrToDate(A[1]))+' 00:00:00'', ');
      Qr.SQL.Add('0x'+A[2]+','+A[3]+',');
      Qr.SQL.Add(''''+CorrSQLString(A[4])+''','+''''+CorrSQLString(A[5])+''',');
      Qr.SQL.Add(A[6]+','+A[7]+','+A[8]+','+A[9]+','+Tn+','+A[10]+',0x'+A[11]+','''+A[12]+''','+A[13]+','''+A[14]+''','+A[15]+','+A[16]+','''+sDD+''',0x'+A[18]+')');

      try
//       Qr.SQL.SaveToFile('C:\123456.txt');
       Qr.ExecSQL;
      except
       on E:Exception do
        begin
         if Silent=0 then ShowMEssage(E.Message);
         B1:=False;
        end;
      end;
     end;

    Qr.Close;
    Qr.SQL.Clear;

    Qr.SQL.Add(' declare @ida smallint ');
    Qr.SQL.Add(' set @ida=(select convert(int,value) from Spr_Const where Descr=''ID_APTEKA'') ');
    Qr.SQL.Add(' delete TmpNakl from TmpNakl t, JMoves t1 where t.nn_nakl=t1.nn_nakl and t.date_nakl=t1.date_nakl and t.date_nakl<getdate()-case when @ida=227 then 15 else 7 end ');

    Qr.SQL.Add(' delete TmpNakl from TmpNakl t, #tmpNakl t1 where t.nn_nakl=t1.nn_nakl and t.date_nakl=t1.date_nakl');
    Qr.SQL.Add(' delete from TmpNakl where date_nakl between (select Min(date_nakl)-3 from #tmpNakl) and (select Max(date_nakl) from #tmpNakl)');
    Qr.SQL.Add(' delete from TmpNakl where NReady=0 ');

    Qr.SQL.Add(' insert into TmpNakl(NN_NAKL,DATE_NAKL,ID_PART8,ART_CODE,NAMES,ART_NAME,KOL,CENA,F_NDS,TYPE_TOV,TYPENAKL,OBL,ID_POSTAV_,NN_POSTAV,SKLAD,NREADY,CENAP,Stamp,DeliveryDate) ');
    Qr.SQL.Add(' select NN_NAKL,DATE_NAKL,KOD_NAME,ART_CODE,NAMES,ART_NAME,KOL,CENA,F_NDS,TYPE_TOV,TYPENAKL,OBL,ID_POSTAV_,NN_POSTAV,SKLAD,NREADY,CENAP,Stamp,DeliveryDate from #tmpnakl ');
    Qr.SQL.Add(' where id_apteka=@ida ');
    Qr.SQL.Add(' delete from TmpNakl where typenakl=2 and date_nakl<getdate()-5');
    Qr.ExecSQL;

{
    try
     Qr.Close;
     Qr.SQL.Clear;
     Qr.SQL.Add('if Object_ID(N''tempdb..#scan'') is not null drop table #scan');
     Qr.SQL.Add('select top 0 convert(varchar(20),'''') as nn_nakl, getdate() as date_nakl, convert(int,0) as art_code, convert(int,0) as kol, convert(int,0) as akt, convert(int,0) as id_apteka into #scan');
     Qr.SQL.Add('BULK INSERT #scan from '''+ExtractFileDir(FName)+'\Scan.txt'' with ( FIELDTERMINATOR = ''|'', ROWTERMINATOR = ''\n'', CODEPAGE =''RAW'') ');
     Qr.SQL.Add('delete Scan');
     Qr.SQL.Add('from Scan a, #scan b');
     Qr.SQL.Add('where a.nn_nakl=b.nn_nakl and a.date_nakl=b.date_nakl and id_apteka=(select convert(int,Value) from Spr_Const where Descr=''ID_APTEKA'') ');
     Qr.SQL.Add('insert into Scan(nn_nakl,date_nakl,art_code,kol,akt)');
     Qr.SQL.Add('select nn_nakl,date_nakl,art_code,kol,akt');
     Qr.SQL.Add('from #scan a');
     Qr.SQL.Add('where id_apteka=(select convert(int,Value) from Spr_Const where Descr=''ID_APTEKA'') ');
     Qr.ExecSQL;
    except
    end;
}
//    ADOCo.CommitTrans;
   except
//    ADOCo.RollbackTrans;
    raise;
   end;

   System.Close(F);
   B:=False;

   if Not (B1) and (Silent=0) then Application.MessageBox(PChar('Чтение файла накладных произошло с ошибками!'+#10#10+
                                                                'ОБЯЗАТЕЛЬНО перепроверте суммы накладных перед загрузкой!'),PChar('Загрузка накладных'),48);
   Result:=True;
  except
   on E:Exception do
    begin
     if (Silent=0) then ShowMEssage(E.Message);
     if B then System.Close(F);
     Result:=False;
    end;
  end;
 end; {LoadTmpNakl}
*)

function LoadTmpNakl(ADOCo:TADOConnection; Qr:TADOQuery; FName:String; Silent:Byte; Param:Byte):Boolean;
 begin
  try
   Qr.Close;
   Qr.SQL.Text:='exec spY_LoadTmpNakl '+IntToStr(Param);
   Qr.Open;
   Result:=True;
  except
   on E:Exception do
    begin
     RegError(Qr,'Загрузка накладных в TmpNakl',E.Message,'D:\AVA\ErLogLoadTmpNakl.txt');
     if (Silent=0) then ShowMEssage(E.Message);
     Result:=False;
    end;
  end;
 end; {LoadTmpNakl}

function LoadTmpNaklMS(ADOCo:TMSConnection; Qr:TMSQuery; FName:String; UserID:Integer):Boolean;
var F:System.Text;
    B,B1:Boolean;
    S:String;
    A:TStrArray;
    Tn:String;
 begin
  B:=False;
  try
   System.Assign(F,FName);
   System.ReSet(F);
   B:=True;
   B1:=True;
   try
    Qr.Close;
    Qr.SQL.Text:='delete from TmpNakl where date_nakl<getdate()-1 or id_user='+IntToStr(UserID);
    Qr.ExecSQL;
    While Not(Eof(f)) do
     begin
      ReadLn(f,S);
      GetStrArray(S,A,['|']);
      Tn:='1';
      if StrToInt(A[6])=0 then Tn:='2';
      Qr.Close;
      Qr.SQL.Clear;
      Qr.SQL.Add('Insert Into TmpNakl(NN_NAKL,DATE_NAKL,KOD_NAME,ART_CODE,NAMES,ART_NAME,KOL,CENA,F_NDS,TYPE_TOV,ID_USER,TYPENAKL)');
      Qr.SQL.Add('Values ('''+A[0]+''','''+FormatDateTime('yyyy-mm-dd',StrToDate(A[1]))+' 00:00:00'', ');
      Qr.SQL.Add(A[2]+','+A[3]+',');
      Qr.SQL.Add(''''+CorrSQLString(A[4])+''','+''''+CorrSQLString(A[5])+''',');
      Qr.SQL.Add(A[6]+','+A[7]+','+A[8]+','+A[9]+','+IntToStr(UserID)+','+Tn+')');
      try
       Qr.ExecSQL;
      except
       B1:=False;
      end;
     end;
    ADOCo.Commit;
   except
    ADOCo.Rollback;
    raise;
   end;
   System.Close(F);
   B:=False;
   if Not (B1) then Application.MessageBox(PChar('Чтение файла накладных произошло с ошибками!'+#10#10+
                                           'ОБЯЗАТЕЛЬНО перепроверте суммы накладных перед загрузкой!'),PChar('Загрузка накладных'),48);
   Result:=True;
  except
   if B then System.Close(F);
   Result:=False;
  end;
 end; {LoadTmpNakl}

function GetNewNomNakl(Qr:TDataSet; Shab:String):String;
var P,NN,i:Integer;

 function GetMaxNum(Shab:String):Integer;
 var i:Integer;
     S,ss:String;

  begin
   S:='';
   for i:=1 to Length(Shab) do
    begin
     if Shab[i] in ['0'..'9'] then ss:='[0-9]' else ss:=Shab[i];
     S:=S+ss;
    end;

   if (Qr is TADOQuery) then
    begin
     TADOQuery(Qr).Close;
     TADOQuery(Qr).SQL.Clear;
     TADOQuery(Qr).SQL.Add('select IsNull(Max(Convert(int,SubString(nn_nakl,CharIndex(''-'',nn_nakl)+1,Len(nn_nakl)-CharIndex(''-'',nn_nakl)))),0) as NN ');
     TADOQuery(Qr).SQL.Add('from JMoves ');
     TADOQuery(Qr).SQL.Add('where nn_nakl like '''+S+'''');
     TADOQuery(Qr).Open;
     Result:=TADOQuery(Qr).FieldByName('NN').AsInteger;
    end else
   if (Qr is TMSQuery) then
    begin
     TMSQuery(Qr).Close;
     TMSQuery(Qr).SQL.Clear;
     TMSQuery(Qr).SQL.Add('select IsNull(Max(Convert(int,SubString(nn_nakl,CharIndex(''-'',nn_nakl)+1,Len(nn_nakl)-CharIndex(''-'',nn_nakl)))),0) as NN ');
     TMSQuery(Qr).SQL.Add('from JMoves ');
     TMSQuery(Qr).SQL.Add('where nn_nakl like '''+S+'''');
     TMSQuery(Qr).Open;
     Result:=TMSQuery(Qr).FieldByName('NN').AsInteger;
    end;

  end;

 function CheckNum(N:String):Boolean;
  begin
   if (Qr is TADOQuery) then
    begin
     TADOQuery(Qr).Close;
     TADOQuery(Qr).SQL.Text:='select * from JMoves where nn_nakl='''+N+'''';
     TADOQuery(Qr).Open;
    end else
   if (Qr is TMSQuery) then
    begin
     TMSQuery(Qr).Close;
     TMSQuery(Qr).SQL.Text:='select * from JMoves where nn_nakl='''+N+'''';
     TMSQuery(Qr).Open;
    end;
   Result:=Qr.IsEmpty;
  end;

 Begin
  try
   NN:=GetMaxNum(Shab)+1;
   for i:=1 to 1000 do
    begin
     P:=Pos('-',Shab);
     Result:=Copy(Shab,1,P)+IntToStrF(NN,Length(Shab)-P);
     if CheckNum(Result) then Break;
    end;
  except
   Result:='';
  end;
 End;

function SetTime(tDati:TDateTime):Boolean;
var tSetDati:TDateTime;
    tST:TSystemTime;
    ts:TSystemTime;
 begin
  try
   GetSystemTime(ts);
   tSetDati:=tDati-(Now-SystemTimeToDateTime(ts));
   With tST do
    begin
     wYear:=StrToInt(FormatDateTime('yyyy',tSetDati));
     wMonth:=StrToInt(FormatDateTime('mm',tSetDati));
     wDay:=StrToInt(FormatDateTime('dd',tSetDati));
     wHour:=StrToInt(FormatDateTime('hh',tSetDati));
     wMinute:=StrToInt(FormatDateTime('nn',tSetDati));
     wSecond:=StrToInt(FormatDateTime('ss',tSetDati));
     wMilliseconds:=0;
    end;
   Result:=SetSystemTime(tST);
  except
   Result:=False;
  end;
 end;

function GetLocalIP:String;
const WSVer=$101;
var wsaData:TWSAData;
    P:PHostEnt;
    Buf:array [0..127] of Char;
 begin
  Result:='EMPTY';
  if WSAStartup(WSVer, wsaData) = 0 then
   begin
    if GetHostName(@Buf, 128) = 0 then
     begin
      P:=GetHostByName(@Buf);
      if P<>nil then Result:=iNet_ntoa(PInAddr(p^.h_addr_list^)^);
     end;
    WSACleanup;
   end;
 end;

function GetIndentFieldName(Qr:TADOQuery; TbName:String):String;
 begin
  Qr.Close;
  Qr.SQL.Clear;
  Qr.SQL.Add('select IsNull((select column_name ');
  Qr.SQL.Add('from information_schema.columns   ');
  Qr.SQL.Add('where table_name='''+TbName+''' and COLUMNPROPERTY(OBJECT_ID(table_name),column_name,''IsIdentity'')=1),'''') as rid ');
  Qr.Open;
  Result:=Qr.FieldByName('').AsString;
 end;

function ItoS(val:integer):String;
var _r:string;
 begin
  Str(val,_r);
  Result:=_r;
 end;

function ConvertToCS(val:integer; CS:Integer; Dec:Byte):String;
var _r,_r1:String;
    _m,i:integer;
 begin
  _r:='';
  if CS>16 then exit;
  repeat
   _m:=val mod CS;
   val:=val div CS;
   if _m<10 then
    _r:=_r+ItoS(_m)
            else
    _r:=_r+chr(ord('A')+_m-10);
  until val=0;

  _r1:='';
  for i:=length(_r) downto 1 do _r1:=_r1+_r[i];
  for i:=1 to (Dec*8)-Length(_r) do _r1:='0'+_r1;
  Result:=_r1;
 end;

function DateToStrUA(D:TDateTime; dd:String='d'):String;
var M:Integer;
    S:String;
 begin
  Result:=FormatDateTime(dd,D);
  M:=StrToInt(FormatDateTime('m',D));
  Case M of
    1:S:=' сiчня';
    2:S:=' лютого';
    3:S:=' березня';
    4:S:=' квiтня';
    5:S:=' травня';
    6:S:=' червня';
    7:S:=' липня';
    8:S:=' серпня';
    9:S:=' вересня';
   10:S:=' жовтня';
   11:S:=' листопада';
   12:S:=' грудня';
  end;
  Result:=Result+S+' '+FormatDateTime('yyyy',D)+' р.';
 end;

Function DownLoadFileBlock(FromF,ToF:String; var Dl:TDownLoadInfo):Boolean;
const C=4096;
var hF,hT,SzT,SzF,Count,dF,dT:Integer;
    Buf:Array[1..C] of Byte;
    FEx:Boolean;
 begin
  try
   Dl.Read:=False;
   Dl.Write:=False;
   if Not FileExists(FromF) then Abort;
   hF:=0; hT:=0;
   SzF:=GetFileSize(FromF);
   SzT:=GetFileSize(ToF);
   Dl.SizeFrom:=SzF;
   if SzT>SzF then
    if Not DeleteFile(ToF) then Abort;
   if SzF<>SzT then
    begin
     try
      hF:=FileOpen(FromF,fmOpenRead); if hF<0 then Abort;
      dF:=FileGetDate(hF);
      if dF<0 then Abort;
      if SzT>0 then FEx:=True else FEx:=FileExists(ToF);
      if FEx then hT:=FileOpen(ToF,fmOpenReadWrite)
             else hT:=FileCreate(ToF);
      if hT<0 then Abort;
      if FEx then dT:=FileGetDate(hT) else
       begin
        if FileSetDate(hT,dF)<>0 then Abort;
        dT:=dF;
       end;
      if dT<0 then Abort;
      if dT=dF then
       if FileSeek(hF,SzT,0)<0 then Abort;
      Count:=FileRead(hF,Buf,C);
      if Count>0 then Dl.Read:=True;
      if dT=dF then
       if FileSeek(hT,0,2)<0 then Abort;
      if FileWrite(hT,Buf,Count)<0 then Abort;
      Dl.SizeTo:=SzT+Count;
      Dl.Write:=True;
      if FileSetDate(hT,dF)<>0 then Abort;
     finally
      if hF>-1 then FileClose(hF);
      if hT>-1 then FileClose(hT);
     end;
    end else begin
              Result:=True;
              Exit;
             end;
   Result:=False;
  except
   Result:=False;
  end;
 end;

function JTimeToStr(T:String):String;
 begin
  if Length(T)=6 then
   Result:=Copy(T,1,2)+':'+Copy(T,3,2)+':'+Copy(T,5,2)
  else
   Result:=T;
 end;

function CompareFiles(FromF,ToF:String):Boolean;
var bF,bT:Boolean;
    dF,dT:TDatetime;
    sF,sT:Integer;
    sl:TStringList;

 begin

  bF:=FileExists(FromF);
  bT:=FileExists(ToF);
  dF:=GetFileDateTime(FromF);
  dT:=GetFileDateTime(ToF);
  sF:=GetFileSize(FromF);
  sT:=GetFileSize(ToF);

  Result:=bF and
          bF and
          (dF=dT) and
          (sF=sF);

{
  sl:=TStringList.Create;

  sl.Text:='fExists '+IntToStr(BoolToInt(bF))+#10+
           'tExists '+IntToStr(BoolToInt(bT))+#10+
           DateTimeToStr(dF)+#10+
           DateTimeToStr(dT)+#10+
           IntToStr(sF)+#10+
           IntToStr(sT)+#10;

  sl.SaveToFile('C:\log\CompFile.txt');
}
 end;

function EANCorrection(Num:String):String;
var q,Sum1,Sum2,i:Integer;
 begin
  try
   Num:=Copy(Num,1,12); Sum1:=0; Sum2:=0;
   for i:=1 to Length(Num) do
    if i mod 2=0 then Inc(Sum2,StrToInt(Num[i])) else Inc(Sum1,StrToInt(Num[i]));
   Sum1:=Sum2*3+Sum1;
   q:=0;
   While Sum1 mod 10<>0 do begin Inc(Sum1); Inc(q); end;
   Result:=Num+IntToStr(q);
  except
   Result:=Num+'0';
  end;
 end;

procedure DrawBarCode(Canv:TCanvas; Code:String; Size,X,Y,Width,Height:Integer);
const
  EAN_A:Array[1..10] of String =
              ('0001101','0011001','0010011','0111101','0100011',
               '0110001','0101111','0111011','0110111','0001011');
  EAN_B:Array[1..10] of String =
              ('0100111','0110011','0011011','0100001','0011101',
               '0111001','0000101','0010001','0001001','0010111');
  EAN_C:Array[1..10] of String =
              ('1110010','1100110','1101100','1000010','1011100',
               '1001110','1010000','1000100','1001000','1110100');
  Codif:Array[1..10] of String =
                ('AAAAA','ABABB','ABBAB','ABBBA','BAABB',
                 'BBAAB','BBBAA','BABAB','BABBA','BBABA');

var Matr:String;
    dx,A,Dig,Dig2,L,ShC,Sm,VSh,WidthLine:Integer;
    sC:TColor;

 begin
  // подготовка штриховой матрицы: строка, состояшая из "1", "0" и "x";
  //"1"  - штрих, "0" - нет штриха (пустое место), "x" - длинный штрих
  Matr:='';
  Code:=EANCorrection(Code);
  Matr:=Matr+'x0x';          //два левых краевых штриха более длинные ("x" вместо "1")

  Dig := StrToInt(Code[2])+1;
  Matr := Matr + EAN_A[Dig];      //вторая слева цифра кода (всегда по EAN_A)
                                  //(первая слева цифра не кодируется)
  Dig := StrToInt(Code[1])+1;    //поз. в Codif
  for A := 3 to 7 do begin
    Dig2 := StrToInt(Code[A]) + 1;    //поз. в EAN_A и EAN_В, в завис-ти от цифры кода
    if Copy(Codif[Dig], A-2, 1) = 'A' then
      Matr := Matr + EAN_A[Dig2]
    else
      Matr := Matr + EAN_B[Dig2];
  end;

  Matr := Matr + '0x0x0';        // центральные штрихи
  for A := 8 to 13 do begin
    Matr := Matr+EAN_C[StrToInt(Code[A])+1];
  end;
  Matr:=Matr+'x0x';              //концевые штрихи
  VSh:=Size;
  WidthLine:=Round(Width/95); //95 общее кол-во элементов в штриховой матрице
  if WidthLine<2 then VSh:=Size div 2;   //уменьшить размер шрифта, если не помещается
  Canv.Font.Name:='Arial';
  Canv.Font.Size:=VSh;
  dx:=Round(1.5*Canv.TextWidth(Code[1]));
  //печать ш-к с помощью прямоугольников
  sC:=Canv.Brush.Color;
  Canv.Brush.Color := clBlack;
  for A := 1 to Length(Matr) do begin
    L := WidthLine * A + X+dx;
    if Matr[A] = '1' then
      Canv.FillRect(Rect(L, Y, WidthLine+L, Height));
    if Matr[A] = 'x' then
      Canv.FillRect(Rect(L, Y, WidthLine+L, Height+10));
  end;

//вывод текста
  Canv.Brush.Color := sC;
  Canv.TextOut(X, Y+Height, Code[1]);

  ShC := Round((WidthLine*42)/6);        //ширина, отводимая под каждую цифру (шаг)
  Sm := WidthLine*5+X+dx;                      //смещение слева
  for A := 0 to 5 do
    Canv.TextOut(ShC*A+Sm,Y+Height,Code[A+2]);

  Sm := WidthLine*51+X+dx;
  for A := 0 to 5 do
   Canv.TextOut(ShC*A+Sm,Y+Height,Code[A+8]);
 end;

Function GenEAN13(Code:String):String;
var i,FirstFlag:Integer;
    LeftStr,RightStr,RightKod,LeftKod:String;


 function AddLeft(S1:String; Count:Integer; S2:String):String;
 var S0:String;
  begin
	 S0:=S1;
 	 While Length(S0)<=Count do S0:=S2+S0;
   Result:=Copy(S0,Length(S0)-Count+1,Count);
  end;

 function NumberToUpperChar(NumS:String):String;
 const UpperCharSet='ABCDEFGHIJ';
 var Num:Integer;
  begin
   Num:=StrToInt(Copy(NumS,Length(NumS),1));
   Result:=Copy(UpperCharSet,Num+1,1);
  end;

 function NumberToLowerChar(NumS:String):String;
 const UpperCharSet='abcdefghij';
 var Num:Integer;
  begin
   Num:=StrToInt(Copy(NumS,Length(NumS),1));
   Result:=Copy(UpperCharSet,Num+1,1);
  end;

 Begin
  try
   StrToInt64(Code);
   Code:=Copy(Code,1,12);
   if Length(Code)<12 then Abort;

 	 // Добавление контрольной суммы
   Code:=EANCorrection(Code);

 	//Разбор строки
	FirstFlag:=StrToInt(Copy(Code,1,1));
	LeftStr:=Copy(Code,2,6);
	RightStr:=Copy(Code,8,6);
	RightKod:='';
	LeftKod:='';
	for i:=1 to 6 do
	 RightKod:=RightKod+NumberToLowerChar(Copy(RightStr,i,1));
  //  Формирование левой части кода зависит от значениа FirstFlag
	if FirstFlag = 0 then
//    0           A  A  A  A  A
		LeftKod:='!'+ Copy(LeftStr,1,1)
			+ Copy(LeftStr,2,1)
			+ Copy(LeftStr,3,1)
			+ Copy(LeftStr,4,1)
			+ Copy(LeftStr,5,1)
			+ Copy(LeftStr,6,1) else
	if FirstFlag=1 then
//    1           A  A  B  A  B  B
		LeftKod:='$!'
			+ Copy(LeftStr,1,1)
			+ Copy(LeftStr,2,1)
			+ NumberToUpperChar(Copy(LeftStr,3,1))
			+ Copy(LeftStr,4,1)
			+ NumberToUpperChar(Copy(LeftStr,5,1))
			+ NumberToUpperChar(Copy(LeftStr,6,1)) else
	if FirstFlag = 2 then
//    2           A  A  B  B  A  B
		LeftKod:='%!'
			+ Copy(LeftStr,1,1)
			+ Copy(LeftStr,2,1)
			+ NumberToUpperChar(Copy(LeftStr,3,1))
			+ NumberToUpperChar(Copy(LeftStr,4,1))
			+ Copy(LeftStr,5,1)
			+ NumberToUpperChar(Copy(LeftStr,6,1)) else
	if FirstFlag = 3 then
//    3           A  A  B  B  B  A
		LeftKod:='&!'
			+ Copy(LeftStr,1,1)
			+ Copy(LeftStr,2,1)
			+ NumberToUpperChar(Copy(LeftStr,3,1))
			+ NumberToUpperChar(Copy(LeftStr,4,1))
			+ NumberToUpperChar(Copy(LeftStr,5,1))
			+ Copy(LeftStr,6,1) else
	if FirstFlag = 4 then
//    4           A  B  A  A  B  B
		LeftKod:= '''!'
			+ Copy(LeftStr,1,1)
			+ NumberToUpperChar(Copy(LeftStr,2,1))
			+ Copy(LeftStr,3,1)
			+ Copy(LeftStr,4,1)
			+ NumberToUpperChar(Copy(LeftStr,5,1))
			+ NumberToUpperChar(Copy(LeftStr,6,1)) else
	if FirstFlag = 5 then
//    5           A  B  B  A  A  B
		LeftKod:='(!'
			+ Copy(LeftStr,1,1)
			+ NumberToUpperChar(Copy(LeftStr,2,1))
			+ NumberToUpperChar(Copy(LeftStr,3,1))
			+ Copy(LeftStr,4,1)
			+ Copy(LeftStr,5,1)
			+ NumberToUpperChar(Copy(LeftStr,6,1));
	if FirstFlag = 6 then
//    6           A  B  B  B  A  A
		LeftKod:=')!'
			+ Copy(LeftStr,1,1)
			+ NumberToUpperChar(Copy(LeftStr,2,1))
			+ NumberToUpperChar(Copy(LeftStr,3,1))
			+ NumberToUpperChar(Copy(LeftStr,4,1))
			+ Copy(LeftStr,5,1)
			+ Copy(LeftStr,6,1) else
	if FirstFlag = 7 then
//    7           A  B  A  B  A  B
		LeftKod:='*!'
			+ Copy(LeftStr,1,1)
			+ NumberToUpperChar(Copy(LeftStr,2,1))
			+ Copy(LeftStr,3,1)
			+ NumberToUpperChar(Copy(LeftStr,4,1))
			+ Copy(LeftStr,5,1)
			+ NumberToUpperChar(Copy(LeftStr,6,1)) else
	if FirstFlag = 8 then
//    8           A  B  A  B  B  A
		LeftKod:='+!'
			+ Copy(LeftStr,1,1)
			+ NumberToUpperChar(Copy(LeftStr,2,1))
			+ Copy(LeftStr,3,1)
			+ NumberToUpperChar(Copy(LeftStr,4,1))
			+ NumberToUpperChar(Copy(LeftStr,5,1))
			+ Copy(LeftStr,6,1) else
	if FirstFlag = 9 then
//    9           A  B  B  A  B  A
		LeftKod:=',!'
			+ Copy(LeftStr,1,1)
			+ NumberToUpperChar(Copy(LeftStr,2,1))
			+ NumberToUpperChar(Copy(LeftStr,3,1))
			+ Copy(LeftStr,4,1)
			+ NumberToUpperChar(Copy(LeftStr,5,1))
			+ Copy(LeftStr,6,1);
   Result:=LeftKod+'-'+RightKod+'!';
  except
   Result:='';
  end;
 End;

function DownLoadFile(FromF,ToF:String; Direction:Byte; PrBar:TProgressBar):Boolean;
var Dl:TDownLoadInfo;
    T1,T:TDateTime;

 begin
  T1:=Time;
  try
   if Not(Direction in [LOAD_IN,LOAD_OUT]) then Abort;
   if (Direction=LOAD_IN) and Not FileExists(FromF) then Abort;
   try
    if PrBar<>nil then
     begin
      PrBar.Max:=100;
      PrBar.Min:=0;
      PrBar.Position:=0;
     end;
    except
    end; 
   T:=Time;
   Repeat
    if DownLoadFileBlock(FromF,ToF,Dl) then Break;
    if PrBar<>nil then
     try
      if Dl.SizeFrom<>0 then
       begin
        PrBar.Position:=Round(Dl.SizeTo*PrBar.Max/Dl.SizeFrom);
        Application.ProcessMessages;
       end;
     except
     end;  
    if Not (Dl.Read and Dl.Write) then
     begin
      if Abs(Time-T)*100000>=20 then Abort;
     end else T:=Time;
   Until False;
   Result:=True;
   if PrBar<>nil then PrBar.Position:=0;
  except
   if PrBar<>nil then PrBar.Position:=0;
   Result:=False;
  end;
  ShowMessage(TimeToStr(Abs(Time-T1)));
 end;

Function MakeCRC32File(FileName:String):Boolean;
var B:Boolean;
    C:TCRCInfo;
    FCrc:String;
    F:File of TCRCInfo;
 begin
  B:=False;
  try
   FCrc:=ChangeFileExt(FileName,'.crc');
   if Not FileExists(FileName) then Abort;
   C.CRC32:=GetFileCRC(FileName);
   C.Date:=GetFileDateTime(FileName);
   System.Assign(F,FCrc);
   System.ReWrite(F);
   B:=True;
   System.Write(F,C);
   System.Close(F);
   B:=False;
   if Not FileExists(FCrc) then Abort;
   Result:=True;
  except
   if B then System.Close(F);
   Result:=False;
  end;
 end;

Function CheckCRCFile(FileName:String):Boolean;
var B:Boolean;
    C:TCRCInfo;
    F:File of TCRCInfo;
    FCrc:String;
 begin
  B:=False;
  try
   FCrc:=ChangeFileExt(FileName,'.crc');
   if Not FileExists(FCrc) then Abort;
   if Not FileExists(FileName) then Abort;
   System.Assign(F,FCrc);
   System.ReSet(F);
   B:=True;
   System.Read(F,C);
   System.Close(F);
   B:=False;
   Result:=(GetFileCRC(FileName)=C.CRC32); // and (GetFileDateTime(FileName)=C.Date);
  except
   if B then System.Close(F);
   Result:=False;
  end;
 end;

function ExecuteAndWait(CommandLine:String; HideApplication:Boolean):Boolean;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  exitc: cardinal;
 begin
  FillChar(StartupInfo, sizeof(StartupInfo), 0);
  with StartupInfo do begin
    cb := Sizeof(StartupInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := SW_SHOW;
  end;
  if not CreateProcess(nil{PChar(FileName)}, PChar(CommandLine), nil, nil, false,
    CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil,
    StartupInfo, ProcessInfo) then result := false
  else begin
    if HideApplication then begin
      Application.Minimize;
      ShowWindow(Application.Handle, SW_HIDE);
      WaitforSingleObject(ProcessInfo.hProcess, INFINITE);
    end else
      while WaitforSingleObject(ProcessInfo.hProcess, 100) =
        WAIT_TIMEOUT do begin
        Application.ProcessMessages;
        if Application.Terminated
          then TerminateProcess(ProcessInfo.hProcess, 0);
      end;
    GetExitCodeProcess(ProcessInfo.hProcess, exitc);
    result := (exitc = 0);
    if HideApplication then begin
      ShowWindow(Application.Handle, SW_SHOW);
      Application.Restore;
      Application.BringToFront;
    end;
  end;
end;

function DateToStrRU(D:TDateTime):String;
var M:Integer;
    S:String;
 begin
  Result:=FormatDateTime('d',D);
  M:=StrToInt(FormatDateTime('m',D));
  Case M of
    1:S:=' января';
    2:S:=' февраля';
    3:S:=' марта';
    4:S:=' апреля';
    5:S:=' мая';
    6:S:=' июня';
    7:S:=' июля';
    8:S:=' августа';
    9:S:=' сентября';
   10:S:=' октября';
   11:S:=' ноября';
   12:S:=' декабря';
  end;
  Result:=Result+S+' '+FormatDateTime('yyyy',D)+' г.';
 end;

function MonthToStrRU(D:TDateTime):String;
var M:Integer;
    S:String;
 begin
  M:=StrToInt(FormatDateTime('m',D));
  Case M of
    1:S:=' январь';
    2:S:=' февраль';
    3:S:=' март';
    4:S:=' апрель';
    5:S:=' май';
    6:S:=' июнь';
    7:S:=' июль';
    8:S:=' август';
    9:S:=' сентябрь';
   10:S:=' октябрь';
   11:S:=' ноябрь';
   12:S:=' декабрь';
  end;
  Result:=S;
 end;

function DayOfWeekRU(D:TDateTime):Integer;
 begin
  if DayOfWeek(D)=1 then Result:=7 else Result:=DayOfWeek(D)-1;
 end;

function Translit(Ch:Char):String;
var S:String;
 begin
  S:=Ch;
  Ch:=AnsiLowerCase(S)[1];
  Case Ch of
   'а':Result:='a';
   'б':Result:='b';
   'в':Result:='v';
   'г':Result:='g';
   'д':Result:='d';
   'е':Result:='e';
   'ё':Result:='yo';
   'ж':Result:='zh';
   'з':Result:='z';
   'и':Result:='i';
   'й':Result:='y';
   'к':Result:='k';
   'л':Result:='l';
   'м':Result:='m';
   'н':Result:='n';
   'о':Result:='o';
   'п':Result:='p';
   'р':Result:='r';
   'с':Result:='s';
   'т':Result:='t';
   'у':Result:='u';
   'ф':Result:='f';
   'х':Result:='kh';
   'ц':Result:='ts';
   'ч':Result:='ch';
   'ш':Result:='sh';
   'щ':Result:='shch';
   'ъ':Result:='';
   'ы':Result:='y';
   'ь':Result:='';
   'э':Result:='e';
   'ю':Result:='yu';
   'я':Result:='ya' else Result:='_';
  end
 end;

function TranslitStr(S:String):String;
var i:Integer;
 begin
  Result:='';
  for i:=1 to Length(S) do Result:=Result+Translit(S[i]);
 end;

procedure SetVolume(const volL, volR: Word);
var hWO:HWAVEOUT;
    waveF:TWAVEFORMATEX;
    vol:DWORD;
 begin
   // init TWAVEFORMATEX
  FillChar(waveF, SizeOf(waveF), 0);
   // open WaveMapper = std output of playsound
  waveOutOpen(@hWO, WAVE_MAPPER, @waveF, 0, 0, 0);
   vol := volL + volR shl 16;
   // set volume
  waveOutSetVolume(hWO, vol);
 end;

function BoolToInt(B:Boolean):Byte;
 begin
  if B then Result:=1 else Result:=0;
 end;

function GetIntValue(V:String; Def:Integer=0):Int64;
 begin
  try
   if V='' then Abort;
   Result:=StrToInt64(V);
  except
   Result:=Def;
  end;
 end;

function GetStrValue(V:String; Def:String='Все'):String;
 begin
  try
   if (V='') or (V=Def) then Abort;
   if V[Length(V)]='%' then Result:=V else Result:=V+'%';
  except
   Result:='%';
  end;
 end;

function GetFlashID(L:Char):String;
var VolLabel,SN,FileSystem,S:string;
 begin
  try
   S:=L+':\';
   if Not DirectoryExists(S) then Abort;
   GetDriveInfo(S,VolLabel,SN,FileSystem);
   Result:=SN;
  except
   Result:='';
  end;
 end;

{
procedure ShowDiagFlash(S:String; Cap:String; Path:String; P:Byte);
var Dg:TDiagF;
 begin
  try
   Dg:=TDiagF.Create(nil);
   try
    Dg.Ex:=P=64;
    Dg.Caption:=Cap;
    Dg.Label1.Caption:=S;
    Dg.Path:=Path;
    Dg.ShowModal;
   finally
    Dg.Free;
   end;
  except
   Application.MessageBox(PChar(S),PChar(Cap),P);
  end
 end;
}

{
Function RegFlash(Qr:TADOQuery; L:Char; P:Byte=0):Boolean;
var Fid:String;

 procedure MessEr(S:String);

  begin
   if P=0 then
    ShowDiagFlash(S,'Регистрация флешек',L+':\',48);
   Abort;
  end;

 procedure Mess(S:String; Param:Byte);
  begin
   if P=0 then
    ShowDiagFlash(S,'Регистрация флешек',L+':\',Param);
  end;

 Begin
  try
   if Not DirectoryExists(L+':\') then MessEr('Флешка не найдена!');
   Fid:=GetFlashID(L);
   if Fid='' then MessEr('Флешка не найдена!');
   Qr.Close;
   Qr.SQL.Text:='select * from WorkWith_Gamma..FlashLog where FlashID='''+Fid+'''';
   Qr.Open;
   if Qr.IsEmpty then
    begin
     Mess('Флешка "'+Fid+'" не зарегистрирована ни на одной торговой точке!',48);
     Result:=True;
     Exit;
    end;

   Qr.Close;
   Qr.SQL.Text:='select * from WorkWith_Gamma..FlashLog where IsNull(Done,0)<>1 and FlashID='''+Fid+'''';
   Qr.Open;
   if Qr.IsEmpty then
    begin
     Mess('Флешка "'+Fid+'" уже прошла регистрацию!',48);
     Result:=True;
     Exit;
    end;

   Qr.Close;
   Qr.SQL.Text:='Update WorkWith_Gamma..FlashLog set Done=1, DateIn=getdate() where IsNull(Done,0)<>1 and FlashID='''+Fid+'''';
   try
    Qr.ExecSQL;
   except
    on E:Exception do MessEr('Ошибка записи в журнал движения флешек: '+E.Message);
   end;
   Mess('Флешка "'+Fid+'" зарегистрирована успешно!',64);
   Result:=True;
  except
   Result:=False;
  end;
 End;
}

procedure FindBaseInFlash(PathF,PathTo:String; NumA:Integer; Pn:TPanel=nil);
var FName,FromF,ToF:String;
    Dt:TDateTime;
 begin
  try
   try

    FromF:=IncludeTrailingBackSlash(PathF)+'Base'+IntToStr(NumA)+'_'+FormatDateTime('mmyy',StartOfTheMonth(Date)-1)+'.bak';
    if Not FileExists(FromF) then
     begin
      FromF:=IncludeTrailingBackSlash(PathF)+'Base'+IntToStr(NumA)+'.bak';
      if Not FileExists(FromF) then Exit;
     end;

    FName:='Base'+IntToStr(NumA)+'.bak';
    Dt:=StartOfTheMonth(Date);
    While Dt<EndOfTheMonth(Date) do
     begin
      ToF:=PathTo+'\ARH_BASE\'+FormatDateTime('yyyy',Dt)+'\'+FormatDateTime('mm',Dt)+'\'+FormatDateTime('dd',Dt)+'\'+FName;
      if FileExists(ToF) and (GetFileDateTime(ToF)>=StartOfTheMonth(Date)) then Exit;
      Dt:=Dt+1;
     end;
    Dt:=StartOfTheMonth(Date)+1;

    //FromF:=IncludeTrailingBackSlash(PathF)+'Base'+IntToStr(NumA)+'_'+FormatDateTime('mmyy',StartOfTheMonth(Date)-1)+'.bak';

    if Not (FileExists(FromF) and (GetFileDateTime(FromF)>=StartOfTheMonth(Date))) then Exit;
    ToF:=PathTo+'\ARH_BASE\'+FormatDateTime('yyyy',Dt)+'\'+FormatDateTime('mm',Dt)+'\'+FormatDateTime('dd',Dt)+'\';
    ForceDirectories(ToF);
    if Pn<>nil then
     begin
      Pn.Caption:='Копируется файл '+FName;
      Pn.Visible:=True;
      Application.ProcessMessages;
     end;
    CopyFile(PChar(FromF),PChar(ToF+FName),false);
   except
   end;
  finally
   if Pn<>nil then Pn.Visible:=False;
  end;
 end;

procedure DBGridToExcel(db:TDBGrid; Caption:String='');
var Exl:Variant;
    ds:TDataSet;
    i,j:Integer;
 begin
  if db=nil then Exit;
  ds:=db.DataSource.DataSet;
  if ds=nil then Exit;
  try
   db.Visible:=False;
   Exl:=CreateOleObject('Excel.Application');
   try
    Exl.Visible:=False;
    Exl.DisplayAlerts:=False;
    Exl.Workbooks.Add;
    Exl.WorkBooks[1].Sheets[1].Activate;
    if Caption<>'' then
     begin
      Exl.WorkBooks[1].Sheets[1].Cells[1,1].Font.Bold:=True;
      Exl.WorkBooks[1].Sheets[1].Cells[1,1]:=Caption;
      Exl.WorkBooks[1].Sheets[1].Range['A1:H1'].Merge;
     end;
    for j:=1 to ds.RecordCount do
     begin
      if j=1 then ds.First else ds.Next;
      for i:=0 to db.Columns.Count-1 do
       begin
        Exl.WorkBooks[1].Sheets[1].Cells[3,i+1]:=db.Columns[i].Title.Caption;
        Exl.WorkBooks[1].Sheets[1].Cells[3,i+1].Font.Bold:=True;
        Exl.WorkBooks[1].Sheets[1].Cells[3+j,i+1]:=ds.FieldByName(db.Columns[i].FieldName).AsString;
       end;
     end;
    Exl.WorkBooks[1].Sheets[1].Columns['A:IV'].EntireColumn.AutoFit;
    Exl.Visible:=True;
   except
    Exl.WorkBooks.Close;
   end;
  finally
   db.Visible:=True;
  end;
 end;

procedure StringGridToExcel(db:TStringGrid);
var Exl:Variant;
    i,j:Integer;
 begin
  if db=nil then Exit;
  Exl:=CreateOleObject('Excel.Application');
  try
   Exl.Visible:=True;
   Exl.DisplayAlerts:=False;
   Exl.Workbooks.Add;
   Exl.WorkBooks[1].Sheets[1].Activate;
   for i:=0 to db.ColCount-1 do
    begin
     Exl.WorkBooks[1].Sheets[1].Cells[3,i+1]:=db.Cells[i,0];
     Exl.WorkBooks[1].Sheets[1].Cells[3,i+1].Font.Bold:=True;
     for j:=1 to db.RowCount do
      begin
       Exl.WorkBooks[1].Sheets[1].Cells[3+j,i+1]:=db.Cells[i,j];
      end;
    end;
   Exl.WorkBooks[1].Sheets[1].Columns['A:IV'].EntireColumn.AutoFit;
  except
   Exl.WorkBooks.Close;
  end;
 end;

procedure QrToExcel(qr:TADOQuery; Caption:String=''; BottomStr:String='');
var Exl:Variant;
    i,j,y:Integer;
 begin
  if qr=nil then Exit;
  Exl:=CreateOleObject('Excel.Application');
  try
   Exl.Visible:=False;
   Exl.DisplayAlerts:=False;
   Exl.Workbooks.Add;
   Exl.WorkBooks[1].Sheets[1].Activate;
   if Caption<>'' then
    begin
     Exl.WorkBooks[1].Sheets[1].Cells[1,1].Font.Bold:=True;
     Exl.WorkBooks[1].Sheets[1].Cells[1,1]:=Caption;
     Exl.WorkBooks[1].Sheets[1].Range['A1:H1'].Merge;
    end;
   for j:=1 to qr.RecordCount do
    begin
     if j=1 then qr.First else qr.Next;
     for i:=0 to qr.Fields.Count-1 do
      begin
       Exl.WorkBooks[1].Sheets[1].Cells[3,i+1]:=qr.Fields[i].FieldName;
       Exl.WorkBooks[1].Sheets[1].Cells[3,i+1].Font.Bold:=True;
       Exl.WorkBooks[1].Sheets[1].Cells[3+j,i+1]:=qr.FieldByName(qr.Fields[i].FieldName).AsString;
      end;
     y:=3+j;
    end;
   Exl.WorkBooks[1].Sheets[1].Columns['A:IV'].EntireColumn.AutoFit;

   if BottomStr<>'' then Exl.WorkBooks[1].Sheets[1].Cells[y+2,2]:=BottomStr;

   Exl.Visible:=True;
  except
   Exl.WorkBooks.Close;
  end;
 end;

function UpperLowerStr(S:String):String;
 begin
  Result:=AnsiUpperCase(Copy(S,1,1))+AnsiLowerCase(Copy(S,2,Length(S)-1));
 end;

function StrToIntEd(S:String):Integer;
 begin
  try
   Result:=StrToInt(S);
  except
   Result:=0
  end;
 end;

procedure EmptyKeyQueue;
var Msg:TMsg;
 begin
  while PeekMessage(Msg,0,WM_KEYFIRST,WM_KEYLAST,PM_REMOVE or PM_NOYIELD) do;
 end;

function SetComputerName(AComputerName:string): Boolean;
var ComputerName: array[0..MAX_COMPUTERNAME_LENGTH + 1] of Char;
    Size:Cardinal;
 begin
//  StrPCopy(ComputerName,AComputerName);
  Result:=Windows.SetComputerNameW(PWideChar(AComputerName));
 end;

function LoadExeToSQL(Qr:TADOQuery; FName:String; FNameCap,FPath:String; ServerOnly:Byte; Major,Minor,Release,Build,UseVerForUpd:Integer; var Er:String):Boolean;
var EFName:String;
    S,Dt,Crc:String;
 begin
  Er:='';
  try
   if Not FileExists(FName) then raise EAbort.Create('Файл "'+FName+'" не найден!');

   if FNameCap='' then EFName:=ExtractFileName(FName) else EFName:=FNameCap;
   Dt:=FormatDateTime('yyyy-mm-dd hh:nn:ss',GetFileDateTime(FName));
   Crc:=IntToStr(GetFileCRC(FName));

   Qr.Close;
   if UseVerForUpd=0 then S:='dateexe='''+Dt+''' and '
                     else S:='Major='+IntToStr(Major)+' and '+
                             'Minor='+IntToStr(Minor)+' and '+
                             'Release='+IntToStr(Release)+' and '+
                             'Build='+IntToStr(Build)+' and ';

   Qr.SQL.Text:='select exename from apteka_net..NewExe (nolock) where '+S+' crc='''+Crc+''' and ExeName='''+EFName+''' and FPath='''+FPath+''' and ServerOnly='+IntToStr(ServerOnly);
   Qr.Open;
   if Qr.IsEmpty then
    begin
     Qr.Close;
     Qr.SQL.Clear;

     Qr.SQL.Add('delete from apteka_net..NewExe where ExeName='''+EFName+''' and FPath='''+ExtractFileDir(FPath)+'''') ;
     Qr.SQL.Add('insert into apteka_net..NewExe(DateExe,FPath,ExeName,Crc,Exe,ServerOnly,Major,Minor,Release,Build,UseVerForUpd) ');
     Qr.SQL.Add('Values ('''+Dt+''','''+ExtractFileDir(FPath)+''','''+EFNAme+''','+Crc+',:b,'+IntToStr(ServerOnly)+',');
     Qr.SQL.Add(IntToStr(Major)+',');
     Qr.SQL.Add(IntToStr(Minor)+',');
     Qr.SQL.Add(IntToStr(Release)+',');
     Qr.SQL.Add(IntToStr(Build)+',');
     Qr.SQL.Add(IntToStr(UseVerForUpd)+')');

     Qr.SQL.Add('select 9999 as res');

     Qr.Parameters.ParseSQL(Qr.SQL.Text,True);
     Qr.Parameters.ParamByName('b').LoadFromFile(FName,ftBlob);

     Qr.Open;
    end;
   Result:=True;
  except
   on E:Exception do
    begin
     Er:=E.Message;
     Result:=False;
    end;
  end;
 end;

function SaveExeFromSQL(Qr:TADOQuery; Path,FName:String; var Er:String):Boolean;
var Pth:String;
    Blob:TMemoryStream;
 begin
  try
   Qr.Close;
   Qr.SQL.Text:='select * from NewExe where ExeName='''+FName+'''';
   Qr.Open;
   Pth:=IncludeTrailingBackSlash(Path);
   ForceDirectories(Pth);
   FName:=Qr.FieldByName('ExeName').AsString;
   Blob:=TADOBlobStream.Create(TBlobField(Qr.FieldByName('Exe')),bmRead);
   try
    if FileExists(Pth+FName) then DeleteFile(Pth+FName);
    if FileExists(Pth+FName) then raise EAbort.Create('Ошибка удаления старого файла!');
    Blob.SaveToFile(Pth+FName);
    if Not FileExists(Pth+FName) then raise EAbort.Create('Файл не сохранен');
    SetFileDateTime(Pth+FName,Qr.FieldByName('DateExe').AsDateTime);
    if GetFileCRC(Pth+FName)<>Qr.FieldByName('CRC').AsFloat then
     begin
      DeleteFile(Pth+FName);
      raise EAbort.Create('Контрольная сумма не сопадает! Файл не сохранен!');
     end;
   finally
    Blob.Free;
   end;
   Result:=True;
  except
   on E:Exception do
    begin
     Er:=E.Message;
     Result:=False;
    end;
  end;
 end;

function PointMap(x1,y1,x2,y2:Real; x,y:Real):Integer;
var R:Real;
 begin
  R:=(y1-y2)*x+(x2-x1)*y+x1*y2-x2*y1;
  if R<0 then Result:=-1 else
  if R>0 then Result:=1 else Result:=0;
 end;

function PointMap(k,b:Real; x,y:Real):Integer;
var R:Real;
 begin
//  R:=(y1-y2)*x+(x2-x1)*y+x1*y2-x2*y1;
  R:=y-k*x-b;
  //R:=(y1-y2)*x+(x2-x1)*y+x1*y2-x2*y1;
  if R<0 then Result:=-1 else
  if R>0 then Result:=1 else Result:=0;
 end;

function LineDirect(x1,y1,x2,y2:Real):Integer;
var K:Real;
 begin
  try
   if (x2-x1=0) or (y2-y1=0) then Result:=0 else
    begin
     K:=(y2-y1)/(x2-x1);
     if K>0 then Result:=1 else
     if K<0 then Result:=-1 else Result:=0;
    end;
  except
   Result:=0;
  end;
 end;

function GetLineY(x,x1,y1,x2,y2:Real):Real;
 begin
  try
   if (x2-x1)=0 then Abort;
   Result:=((y2-y1)/(x2-x1))*x+(x2*y1-x1*y2)/(x2-x1);
  except
   Result:=0;
  end;
 end;

function GetIPAddress(name:String):String;
var WSAData: TWSAData;
    p:PHostEnt;
 begin
  WSAStartup(WINSOCK_VERSION, WSAData);
  p := GetHostByName(PChar(name));
  Result := inet_ntoa(PInAddr(p.h_addr_list^)^);
  WSACleanup;
 end;

function EncodeBase64(const inStr: string): string;

  function Encode_Byte(b: Byte): char;
  const
    Base64Code: string[64] =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  begin
    Result := Base64Code[(b and $3F)+1];
  end;

var
  i: Integer;
begin
  i := 1;
  Result := '';
  while i <= Length(InStr) do
  begin
    Result := Result + Encode_Byte(Byte(inStr[i]) shr 2);
    Result := Result + Encode_Byte((Byte(inStr[i]) shl 4) or (Byte(inStr[i+1]) shr 4));
    if i+1 <=Length(inStr) then
      Result := Result + Encode_Byte((Byte(inStr[i+1]) shl 2) or (Byte(inStr[i+2]) shr 6))
    else
      Result := Result + '=';
    if i+2 <=Length(inStr) then
      Result:=Result + Encode_Byte(Byte(inStr[i+2]))
    else
      Result:=Result + '=';
    Inc(i, 3);
  end;
end;

// Base64 decoding
function DecodeBase64(const CinLine: string): string;
const
  RESULT_ERROR = -2;
var
  inLineIndex: Integer;
  c: Char;
  x: SmallInt;
  c4: Word;
  StoredC4: array[0..3] of SmallInt;
  InLineLength: Integer;
begin
  Result := '';
  inLineIndex := 1;
  c4 := 0;
  InLineLength := Length(CinLine);

  while inLineIndex <=InLineLength do
  begin
    while (inLineIndex <=InLineLength) and (c4 < 4) do
    begin
      c := CinLine[inLineIndex];
      case c of
        '+'     : x := 62;
        '/'     : x := 63;
        '0'..'9': x := Ord(c) - (Ord('0')-52);
        '='     : x := -1;
        'A'..'Z': x := Ord(c) - Ord('A');
        'a'..'z': x := Ord(c) - (Ord('a')-26);
      else
        x := RESULT_ERROR;
      end;
      if x <> RESULT_ERROR then
      begin
        StoredC4[c4] := x;
        Inc(c4);
      end;
      Inc(inLineIndex);
    end;

    if c4 = 4 then
    begin
      c4 := 0;
      Result := Result + Char((StoredC4[0] shl 2) or (StoredC4[1] shr 4));
      if StoredC4[2] = -1 then Exit;
      Result := Result + Char((StoredC4[1] shl 4) or (StoredC4[2] shr 2));
      if StoredC4[3] = -1 then Exit;
      Result := Result + Char((StoredC4[2] shl 6) or (StoredC4[3]));
    end;
  end;
end;

function GetValueFromXML(KeyWord:String; XMLStr:String):String;
var P1,P2:Integer;
 begin
  KeyWord:=AnsiUpperCase(KeyWord);
  XMLStr:=AnsiUpperCase(XMLStr);
  P1:=Pos('<'+KeyWord+'>',XMLStr);
  P2:=Pos('</'+KeyWord+'>',XMLStr);
  if (P1=0) or (P2=0) then Result:='' else
  Result:=Copy(XMLStr,P1+Length(KeyWord)+2,Length(XMLStr)-(P1+Length(KeyWord)+2)-(Length(XMLStr)-P2))
 end;


function Compare2Img(Bm,Bm1:TBitMap):Real;
var H,W,q,i,j:Integer;

 begin
  q:=0;

  if Bm.Width>Bm1.Width then W:=Bm1.Width else W:=Bm.Width;
  if Bm.Height>Bm1.Height then H:=Bm1.Height else H:=Bm.Height;

  for j:=0 to H-1 do
   for i:=0 to W-1 do
    begin
     if (Bm.Canvas.Pixels[i,j]=Bm1.Canvas.Pixels[i,j]) and (Bm.Canvas.Pixels[i,j]<>clWhite) and (Bm1.Canvas.Pixels[i,j]<>clWhite) then Inc(q);
    end;
  Result:=q*100/(Bm.Height*Bm.Width);
 end;

function UnLoadPrice(QrS,Qr:TADOQuery; ZakPath:String; PathTo:String; ID_Apteka:Integer):String;
var i:Integer;
    ServerPath,SFName,SFName1:String;
    Dt:TDateTime;
    sNum:String;
 begin
  try
   Result:='';
   ServerPath:=ZakPath+'_SPR\';
   ForceDirectories(ServerPath);
   QrS.Close;
   QrS.SQL.Text:='set dateformat ymd  select * from datafromapteks..FileListUn8 (nolock) /*where ForSpis=1*/ order by Num';
   QrS.Open;
   for i:=1 to QrS.RecordCount do
    begin
     if i=1 then QrS.First else QrS.Next;
     sNum:=QrS.FieldByName('Num').AsString;
     SFName:=QrS.FieldByName('FName').AsString+'.txt';
     SFName1:=SFName;
     if (QrS.FieldByName('ForAll').AsInteger<>1) and (ID_Apteka<>0) then
      SFName1:=QrS.FieldByName('FName').AsString+IntToStr(ID_Apteka)+'.txt';

     Dt:=GetFileDateTime(ServerPath+SFName1);
//     ShowMEssage(SFName+' : '+TimeToStr(Now-Dt)+' Date='+TimeToStr(Now)+' Dt='+TimeToStr(Dt));

     if (Dt<StrToDate(DateToStr(Date))) or
        ((QrS.FieldByName('Requir').AsInteger=1) and (FormatDateTime('hh:nn:ss',Now-Dt)>'02:00:00')) then
      begin
       Qr.Close;

       Qr.SQL.Text:='set dateformat ymd exec datafromapteks..spY_UnloadSpr8 '+QrS.FieldByName('Num').AsString+',''D:\ZAK\_SPR\''';
//       Qr.SQL.Text:='exec WorkWith_Gamma..spY_UnloadSpr '+QrS.FieldByName('Num').AsString+','''+ServerPath+'''';
       Qr.ExecSQL;
       Result:='9997';
      end;
     if PathTo<>'' then
      begin
       ForceDirectories(PathTo);
       if Not CompareFiles(ServerPath+SFName1,PathTo+SFName) then CopyFile(PChar(ServerPath+SFName1),PChar(PathTo+SFName),False);
      end;
    end;
  except
   on E:Exception do
    begin
     Result:='Ошибка обновления справочников: № справочника: '+sNum+' : '+E.Message;
    end;
  end;
 end;

procedure MakeArhs(QrS,Qr:TADOQuery; SPath:String);
var i:Integer;
 begin
  Qr.Close;
  Qr.SQL.Text:='select id_apteka from ekka_net..apteks where IsNull(Closed,0)=0 order by 1';
  Qr.Open;
  for i:=1 to Qr.RecordCount do
   try
    if i=1 then Qr.First else Qr.Next;
    QrS.Close;
    QrS.SQL.Text:='exec ekka_net..spY_MakeArhSprApt8 '''+SPath+''' ,'+Qr.FieldByName('id_apteka').AsString;
    QrS.ExecSQL;
   except
   end;
 end;

procedure AddToLog(Qr:TADOQuery; Param:Integer; MM:TMemo=nil; Chp:Integer=0 );
 begin
  try
   if MM=nil then Exit;
   if Qr.FieldByName('KOD_NAME').AsString='0' then
    MM.Lines.Add('Нулевой код в накладной '+Qr.FieldByName('NN_NAKL').AsString+' '+Qr.FieldByName('NAMES').AsString);

   if (Qr.FieldByName('CENA').AsFloat<=0) and (Not Qr.FieldByName('ART_CODE').AsInteger in [1,2]) and (Qr.FieldByName('type_tov').AsInteger<>99) then
    MM.Lines.Add('Нет цены: '+Qr.FieldByName('NN_NAKL').AsString+' '+
                                          Qr.FieldByName('NAMES').AsString+' '+
                                          Qr.FieldByName('KOD_NAME').AsString);
   if Param=0 then
    begin
     if Chp<>0 then
      if Qr.FieldByName('ForCHP').AsInteger=0 then
       MM.Lines.Add('В перемещении есть товар без признака ЧП: '+Qr.FieldByName('NN_NAKL').AsString+' '+
                                                                             Qr.FieldByName('NAMES').AsString+' '+
                                                                             Qr.FieldByName('KOD_NAME').AsString);
    end else
   if Param=1 then
    if Chp<>0 then
     if ((Qr.FieldByName('F_NDS').AsString='2') or ((Qr.FieldByName('F_NDS').AsString='   2LW')))
        and (Qr.FieldByName('ForCHP').AsInteger<>0) then
      MM.Lines.Add('Товар должен отпускаться на ЧП: '+Qr.FieldByName('NN_NAKL').AsString+' '+
                                                                  Qr.FieldByName('NAMES').AsString+' '+
                                                                  Qr.FieldByName('KOD_NAME').AsString);
  except
  end;
 end;

function AddNaklToTxt(Qr:TADOQuery; FName:String; Param:Integer; ID_APTEKA:Integer; NReady:Boolean; IsEmpty:Boolean=False; MM:TMemo=nil; Chp:Integer=0):Boolean;
var F:TextFile;
    B:Boolean;
    i:Integer;
    S:String;
    nn:String;
 begin
  B:=False;
  try
   AssignFile(f,FName);
   if Param=1 then ReWrite(f) else
    if FileExists(FName) then Append(f) else ReWrite(f);
   B:=True;
   for i:=1 to Qr.RecordCount do
    begin
     if i=1 then Qr.First else Qr.Next;
     AddToLog(Qr,1,MM,Chp);
     nn:=TrimRight(Qr.FieldByName('NN_NAKL').AsString);
     if Chp<>0 then
      if IsEmpty then nn:=nn+'-'+Qr.FieldByName('F_NDS').AsString+Qr.FieldByName('TYPE_TOV').AsString+Qr.FieldByName('ForCHP').AsString;

     S:=nn+'|'+
        JDateToStr(Qr.FieldByName('DATEN').AsString)+'|'+
        Qr.FieldByName('KOD_NAME').AsString+'|'+
        Qr.FieldByName('ART_CODE').AsString+'|'+

        TrimRight(Qr.FieldByName('NAMES').AsString)+' '+
        TrimRight(Qr.FieldByName('MANUF').AsString)+'|'+

        Copy(Qr.FieldByName('ARTNAME').AsString,1,14)+'|'+
        Qr.FieldByName('KOL').AsString+'|'+
        Qr.FieldByName('CENA').AsString+'|'+
        Qr.FieldByName('F_NDS').AsString+'|'+
        Qr.FieldByName('TYPE_TOV').AsString+'|'+

        Qr.FieldByName('OBL').AsString+'|';
        if Qr.FieldByName('OBL').AsInteger=1 then
         begin
          S:=S+Qr.FieldByName('KodPostav').AsString+'|'+
               Qr.FieldByName('NN_Postav').AsString+'|'+IntToStr(ID_APTEKA);
         end else S:=S+'||'+IntToStr(ID_APTEKA);

     S:=S+'|'+Qr.FieldByName('SKLAD').AsString;
     if NReady then S:=S+'|1' else S:=S+'|0';
     S:=S+'|0.00';  // Спец цена
     WriteLn(F,S);
    end;
   CloseFile(f);
   B:=False;
   Result:=True;
  except
   if B then CloseFile(f);
   Result:=False;
  end;
 end;

function AddNaklCHPToTxt(Qr:TADOQuery; FName:String; Param:Integer; ID_APTEKA:Integer; NReady:Boolean; IsEmpty:Boolean=False; MM:TMemo=nil; Chp:Integer=0):Boolean;
var F:TextFile;
    B:Boolean;
    i:Integer;
    nn,S,f_nds,ttov:String;
 begin
  B:=False;
  try
   AssignFile(f,FName);
   if Param=1 then ReWrite(f) else
    if FileExists(FName) then Append(f) else ReWrite(f);
   B:=True;
   for i:=1 to Qr.RecordCount do
    begin
     if i=1 then Qr.First else Qr.Next;
     f_nds:=''; ttov:='';
     AddToLog(Qr,0,MM,Chp);
     if Qr.FieldByName('ForCHP').AsInteger=0 then
      begin
       if Qr.FieldByName('f_nds').AsString = '   2LV' then begin f_nds := '1'; ttov:='2'; end;
       if Qr.FieldByName('f_nds').AsString = '   2LW' then begin f_nds := '2'; ttov:='1'; end;
      end else begin
                if Qr.FieldByName('f_nds').AsString = '   2LV' then  // НДС
                 begin
                  if Qr.FieldByName('DP').AsInteger=1 then begin f_nds := '3'; ttov:='3'; end;
                  if Qr.FieldByName('DP').AsInteger=0 then begin f_nds := '3'; ttov:='2'; end;
                 end else
                if Qr.FieldByName('f_nds').AsString = '   2LW' then // Без НДС
                 begin
                  if Qr.FieldByName('DP').AsInteger=1 then begin f_nds := '4'; ttov:='3'; end;
                  if Qr.FieldByName('DP').AsInteger=0 then begin f_nds := '4'; ttov:='1'; end;
                 end;
               end;
     if Qr.FieldByName('ParentId').AsString='  XZOO' then ttov:='99';
     nn:=TrimRight(Qr.FieldByName('NN_NAKL').AsString);
     if Chp<>0 then
      if IsEmpty then nn:=nn+'-'+f_nds+ttov+Qr.FieldByName('ForCHP').AsString;
     S:=nn+'|'+
        JDateToStr(Qr.FieldByName('DATEN').AsString)+'|'+
        Qr.FieldByName('KOD_NAME').AsString+'|'+
        Qr.FieldByName('ART_CODE').AsString+'|'+
        TrimRight(Qr.FieldByName('NAMES').AsString)+' '+
        TrimRight(Qr.FieldByName('MANUF').AsString)+'|'+
        Copy(Qr.FieldByName('ART_NAME').AsString,1,14)+'|'+
        Qr.FieldByName('KOL').AsString+'|'+
        Qr.FieldByName('CENA').AsString+'|'+
        f_nds+'|'+ttov+'|'+Qr.FieldByName('OBL').AsString+'|';
        if Qr.FieldByName('OBL').AsInteger=1 then
         begin
          S:=S+Qr.FieldByName('KodPostav').AsString+'|'+
               Qr.FieldByName('NN_Postav').AsString+'|'+IntToStr(ID_APTEKA);
         end else S:=S+'||'+IntToStr(ID_APTEKA);
     S:=S+'|'+Qr.FieldByName('SKLAD').AsString;
     if NReady then S:=S+'|1' else S:=S+'|0';
     S:=S+'|0.00';  // Спец цена
     WriteLn(F,S);
    end;
   CloseFile(f);
   B:=False;
   Result:=True;
  except
   if B then CloseFile(f);
   Result:=False;
  end;
 end;

procedure GetScanDop(Qr:TADOQuery; FName,NN_Nakl:String; Date_Nakl:TDateTime; IDA:Integer);
var B:Boolean;
    f:System.Text;
    i:Integer;
    S:String;
 begin
  B:=False;
  try
   AssignFile(f,FName);
   if FileExists(FName) then Append(f) else ReWrite(f);
   B:=True;
   Qr.Close;
   Qr.SQL.Clear;
   Qr.SQL.Add('select rtrim(j.docno) docno,convert(varchar,workwith_gamma.dbo.decode1Cdate(date_time_iddoc),23) as dn,a.art_code,a.kol,IsNull(a.akt,0) as akt');
   Qr.SQL.Add('from workwith_gamma..scan_nakl a, ');
   Qr.SQL.Add('     gamma.._1sjourn j    ');
   Qr.SQL.Add('where a.iddoc=j.iddoc and ');
   Qr.SQL.Add('      j.docno='''+nn_nakl+''' and ');
   Qr.SQL.Add('      convert(datetime,convert(varchar,workwith_gamma.dbo.decode1Cdate(date_time_iddoc),23))='''+FormatDateTime('yyy-mm-dd',Date_Nakl)+' 00:00:00''');
//   Qr.SQL.SaveToFile('C:\eyy.txt');
   Qr.Open;
   for i:=1 to Qr.RecordCount do
    begin
     if i=1 then Qr.First else Qr.Next;
     S:=Qr.FieldByName('docno').AsString+'|'+
        Qr.FieldByName('dn').AsString+'|'+
        Qr.FieldByName('art_code').AsString+'|'+
        Qr.FieldByName('kol').AsString+'|'+
        Qr.FieldByName('akt').AsString+'|'+IntToStr(IDA);
     WriteLn(F,S);
    end;

   CloseFile(f);
   B:=False;
  except
   if B then CloseFile(f);
  end;
 end;

{
function FileVersion(AFileName: string): string;var
  szName: array[0..255] of Char;  P: Pointer;  Value: Pointer;  Len: UINT;
  GetTranslationString: string;  FFileName: PChar;  FValid: boolean;
  FSize: DWORD;  FHandle: DWORD;  FBuffer: PChar;begin  try
    FFileName := StrPCopy(StrAlloc(Length(AFileName) + 1), AFileName);
    FValid := False;    FSize := GetFileVersionInfoSize(FFileName, FHandle);
    if FSize > 0 then    try      GetMem(FBuffer, FSize);
      FValid := GetFileVersionInfo(FFileName, FHandle, FSize, FBuffer);
    except      FValid := False;      raise;    end;    Result := '';
    if FValid then
      VerQueryValue(FBuffer, '\VarFileInfo\Translation', p, Len)    else
      p := nil;    if P <> nil then
      GetTranslationString := IntToHex(MakeLong(HiWord(Longint(P^)),
        LoWord(Longint(P^))), 8);    if FValid then    begin
      StrPCopy(szName, '\StringFileInfo\' + GetTranslationString +
        '\FileVersion');      if VerQueryValue(FBuffer, szName, Value, Len) then
        Result := StrPas(PChar(Value));    end;  finally    try
      if FBuffer <> nil then        FreeMem(FBuffer, FSize);    except    end;
    try      StrDispose(FFileName);    except    end;  end;end;
}

function GetSpecialFolderPath(folder : integer) : string;
const SHGFP_TYPE_CURRENT = 0;
var path: array [0..MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0, folder, 0, SHGFP_TYPE_CURRENT, @path[0])) then
    Result := path
  else
    Result := '';
end;

function StrToHex2(S:String):String;
var i:Integer;
 begin
  Result:='';
  for i:=1 to Length(S) do Result:=Result+IntToHex(Ord(S[i]),2);
 end;

function Hex2ToStr(S:String):String;
var i:Integer;
 begin
  Result:='';
  for i:=1 to Length(S) div 2 do Result:=Result+Chr(StrToInt('$'+Copy(S,2*i-1,2)));
 end;


function IsClassInherit(Value:TClass; const Name:String):Boolean;
 begin
  Result:=False;
  While Value<> nil do
   begin
    if SameText(Value.ClassName,Name) then
     begin
      Result:=True;
      Exit;
     end;
    Value:=Value.ClassParent;
   end;
 end;

function RGBToColor(R,G,B:Byte):TColor;
 begin
  Result := B shl 16 or G shl 8 or R;
 end;

function GetOptimalFontSize(S:String; F:TFont; Width,MaxFontSize:Integer):Integer;
var i:Integer;
 begin
  Result:=MaxFontSize;
  for i:=MaxFontSize downto 1 do
   begin
    if i mod 2<>0 then Continue;
    F.Size:=i;
    if TextPixWidth(S,F)<=Width then
     begin
      Result:=i;
      Exit;
     end;
   end;
 end;

function GetFont(Name:String; Size:Integer; C:TColor; FStyle:TFontStyles):TFont;
var F:TFont;
 begin
  try
   F:=TFont.Create;
   F.Name:=Name;
   F.Size:=Size;
   F.Color:=C;
   F.Style:=FStyle;
   Result:=F;
  except
   Result:=nil;
  end;
 end;

function GetPos1(L:Integer):Integer;
 begin

  if L<6 then Result:=0 else
  if L=6 then Result:=1 else
  if L=7 then Result:=2 else
  if L in [8..10] then Result:=3 else
  if L in [11..12] then Result:=L-7 else
  if L in [13..14] then Result:=6 else
  if L=15 then Result:=7 else
  if L in [16..17] then Result:=8 else
  if L=18 then Result:=9
          else Result:=10;
 end;

procedure EditKeyPress(Sender: TObject; var Key: Char);
var S,S1:String;
    P1,P:Integer;

 function GetPos(S:String):Integer;
 var L:Integer;
  begin
   L:=Length(S);
   if L<4 then Result:=L+5 else
   if L<6 then Result:=L+7 else
   if L<8 then Result:=L+8 else Result:=L+9;

{
+38 (___) ___-__-__
}
  end;

 Begin
  if (Key in ['0'..'9']) and (Length(TEdit(Sender).Hint)<10) then
   begin
    TEdit(Sender).Hint:=TEdit(Sender).Hint+Key;
    P:=GetPos(TEdit(Sender).Hint);
   end else
  if Key=#8 then
   begin
    S1:=TEdit(Sender).Hint;
    P1:=GetPos1(TEdit(Sender).SelStart);
    Delete(S1,P1,1);
    TEdit(Sender).Hint:=S1;
    P:=GetPos(Copy(TEdit(Sender).Hint,1,P1-1));
   end;

  Key:=#0;
  S:=Copy(TEdit(Sender).Hint+'__________',1,10);
  TEdit(Sender).Text:='+38 ('+Copy(S,1,3)+') '+Copy(S,4,3)+'-'+Copy(S,7,2)+'-'+Copy(S,9,2);
  TEdit(Sender).SelStart:=P;
 End;

procedure EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var P,P1:Integer;
    S1,S:String;
 begin

  if Key=46 then
   begin
    S1:=TEdit(Sender).Hint;
    P1:=GetPos1(TEdit(Sender).SelStart);
    Delete(S1,P1+1,1);
    TEdit(Sender).Hint:=S1;

    S:=Copy(TEdit(Sender).Hint+'__________',1,10);
    P:=TEdit(Sender).SelStart;
    TEdit(Sender).Text:='+38 ('+Copy(S,1,3)+') '+Copy(S,4,3)+'-'+Copy(S,7,2)+'-'+Copy(S,9,2);
    TEdit(Sender).SelStart:=P;
   end;

 end;

function IsEmptyPhone(S:String):Boolean;
 begin
  Result:=(S='') or (S='__________');
 end;

function IsCorrectPhone(S:String):Boolean;
 begin

  if (IsEmptyPhone(S)=False) and (Not ( (S[1]='0') and (S[2] in ['1'..'9']) )) then
   begin
    Result:=False;
    Exit;
   end;

  Result:=(
           (Length(S)=10) and (Pos('_',S)=0)
          )
           or
          (
           IsEmptyPhone(S)
          );

 end;

procedure EditEnter(Sender: TObject);
 begin
  TEdit(Sender).SelStart:=6;
 end;

function GetVolume:DWord;
var Woc:TWAVEOUTCAPS;
    Volume:DWord;
 begin
  Result:=0;
  if WaveOutGetDevCaps(WAVE_MAPPER, @Woc, sizeof(Woc)) = MMSYSERR_NOERROR then
    if Woc.dwSupport and WAVECAPS_VOLUME = WAVECAPS_VOLUME then
    begin
      WaveOutGetVolume(WAVE_MAPPER, @Volume);
      Result := Volume;
    end;
 end;

procedure GetCoordControl(AOwner: TComponent; Sender:TObject; var dx,dy:Integer);
var Com:TControl;
 begin
  dx:=TControl(AOwner).Left; dy:=TControl(AOwner).Top;
  Com:=TControl(Sender);
  While Com<>AOwner do
   begin
    Inc(dx,Com.Left);
    Inc(dy,Com.Top);
    Com:=Com.Parent;
   end;
 end;

{
    Blob:TMemoryStream;
    imE:TImageEn;
    Jp,jpeg:TJPEGImage;
    Bmp,Bm,Bm1:TBitMap;
    FromF,ToF:String;
    NumSeriya:String;
 begin
  try
   QrToOff:=TADOQuery.Create(nil);
   Bm:=TBitMap.Create;
   Bm1:=TBitMap.Create;
   B:=False;
   try
    QrToOff.ConnectionString:=Opt.ConStrMess;
    QrToOff.CommandTimeout:=600;

    QrToOff.Close;
    QrToOff.SQL.Text:='select top 1 data from datafromapteks..StampGamma (nolock) where typestamp=''gamma'' ';
    QrToOff.Open;

    Blob:=TADOBlobStream.Create(TBlobField(QrToOff.FieldByName('data')),bmRead);

}

procedure WB_LoadHTMLBlob(WebBrowser: TWebBrowser; HTMLCode:TMemoryStream);

begin
  WebBrowser.Navigate('about:blank');

  while WebBrowser.ReadyState < READYSTATE_INTERACTIVE do
   Application.ProcessMessages;

  if Assigned(WebBrowser.Document) then
   begin
//        sl.Text := S;
{
        ShowMessageI(Length(S));
        ShowMessageI(Length(sl.Text));
}
//        sl.SaveToFile('c:\h.html');
    HTMLCode.Seek(0,0);
    (WebBrowser.Document as IPersistStreamInit).Load(TStreamAdapter.Create(HTMLCode));
    while WebBrowser.ReadyState < READYSTATE_INTERACTIVE do Application.ProcessMessages;
  end;
end;

procedure WB_LoadHTML(WebBrowser: TWebBrowser; HTMLCode: string);
var sl: TStringList;
    ms: TMemoryStream;
    S:String;
    i:Integer;
begin
  WebBrowser.Navigate('about:blank');

  S:='';
  for i:=1 to Length(HTMLCode) do
   if HTMLCode[i]<>#0 then S:=S+HTMLCode[i];

  while WebBrowser.ReadyState < READYSTATE_INTERACTIVE do
   Application.ProcessMessages;

  if Assigned(WebBrowser.Document) then
   begin
    sl := TStringList.Create;
    try
      ms := TMemoryStream.Create;
      try
        sl.Text := S;
{
        ShowMessageI(Length(S));
        ShowMessageI(Length(sl.Text));
}
        sl.SaveToStream(ms);
//        sl.SaveToFile('c:\h.html');
        ms.Seek(0,0);
        (WebBrowser.Document as IPersistStreamInit).Load(TStreamAdapter.Create(ms));
        while WebBrowser.ReadyState < READYSTATE_INTERACTIVE do Application.ProcessMessages;

      finally
        ms.Free;
      end;
    finally
      sl.Free;
    end;
  end;
end;


function GiveEveryoneFullAccessToRegistryKey(  const RootKey: HKey;
                                                                            const RegPath : string;
                                                                            out ErrorMsg : string): boolean;
    var
      Access : LongWord;
      WinResult : LongWord;
      SD : PSecurity_Descriptor;
      LastError : DWORD;
      Reg : TRegistry;
    begin
      Result := TRUE;
      ErrorMsg := '';
      if (Win32Platform = VER_PLATFORM_WIN32_NT) then
        begin
            Access := KEY_ALL_ACCESS or $0100;
          Reg := TRegistry.Create(Access);
          try
            Reg.RootKey := RootKey;
            if NOT Reg.OpenKey(RegPath, TRUE) then
              Exit;
            GetMem(SD, SECURITY_DESCRIPTOR_MIN_LENGTH);
            try
              Result := InitializeSecurityDescriptor(SD, SECURITY_DESCRIPTOR_REVISION);
              if Result then
                Result := SetSecurityDescriptorDacl(SD, TRUE, NIL, FALSE); // Fails here!
              if NOT Result then
                begin
                  LastError := WINDOWS.GetLastError;
                  if NOT Result then
                    ErrorMsg := SYSUTILS.SysErrorMessage(LastError);
                end
              else
                begin
                  WinResult := RegSetKeySecurity(Reg.CurrentKey, DACL_SECURITY_INFORMATION, SD);
                  Result := (WinResult = ERROR_SUCCESS);
                  ErrorMsg := SYSUTILS.SysErrorMessage(WinResult);
                end;
            finally
              FreeMem(SD);
            end;
            Reg.CloseKey;
          finally
            FreeAndNIL(Reg);
          end;
        end;
    end; {GiveEveryoneFullAccessToRegistryKey}


function CurrToStrF_(C:Currency):String;
 begin
  Result:=StringReplace(CurrToStrF(C,ffFixed,2),'.',',',[rfReplaceAll, rfIgnoreCase]);
 end;

function CountWords(S:String):Integer;
var q,i:Integer;
 begin
  q:=1;
  for i:=1 to Length(S)-1 do
   if (S[i]=' ') and (S[i+1]<>' ') then Inc(q);
  Result:=q;
 end;

function PrepareStringFilter(S:String):String;
var i:Integer;
    Res:String;
 begin
  Res:='';
  S:=Trim(S);
  for i:=1 to Length(S) do
   begin
    if (Ord(S[i])<32) then Continue;
    if (i>1) and (S[i-1]=' ') and (S[i]=' ') then Continue;
    Res:=Res+S[i];
   end;
  Result:=Res;
 end;

procedure RegError(Qr:TADOQuery; Caption:String; EMessage:String; LogFile:String=''; BaseLog:String='Report');
 begin
  try
   Qr.Close;
   Qr.SQL.Text:='exec '+BaseLog+'..spY_RegisterError :cap , :emes select 9999 as Res ';
   Qr.Parameters.ParamByName('cap').Value:=Caption;
   Qr.Parameters.ParamByName('emes').Value:=EMessage;
   Qr.Open;
  except
   on E:Exception do
    if LogFile<>'' then AppendStringToFile(LogFile,DateTimeToStr(Now)+'|'+Caption+'|'+EMessage);
  end;
 end;

function GetKodForEachHour:String;
 begin
  Result:=FormatDateTime('yymmddhh',Now);
 end;

function SetWaveVolume(const AVolume:DWORD):Boolean;
var WaveOutCaps: TWAVEOUTCAPS;
 begin
  Result:=False;
  if WaveOutGetDevCaps(WAVE_MAPPER, @WaveOutCaps, SizeOf(WaveOutCaps)) = MMSYSERR_NOERROR then
    if WaveOutCaps.dwSupport and WAVECAPS_VOLUME = WAVECAPS_VOLUME then
      Result := WaveOutSetVolume(WAVE_MAPPER, AVolume) = MMSYSERR_NOERROR;
 end;

function BonusStr(C:Currency; P:String):String;
var N:Integer;
    S:String;
 begin
  S:=CurrToStr(C);
  N:=StrToInt(Copy(S,Length(S),1));
  Case N of
   0,5..9:Result:='бонусов';
   1:Result:='бонус';
   2..4:Result:='бонуса';
  end;
  Result:=Result+P;
 end;

function FileVersion(AFileName:String):String;
var
  szName: array[0..255] of Char;
  P: Pointer;
  Value: Pointer;
  Len: UINT;
  GetTranslationString: string;
  FFileName: PChar;
  FValid: boolean;
  FSize: DWORD;
  FHandle: DWORD;
  FBuffer: PChar;
 begin
  Result:='';
  try
   try
    FFileName := StrPCopy(StrAlloc(Length(AFileName) + 1), AFileName);
    FValid := False;
    FSize := GetFileVersionInfoSize(FFileName, FHandle);
    if FSize > 0 then
    try
      GetMem(FBuffer, FSize);
      FValid := GetFileVersionInfo(FFileName, FHandle, FSize, FBuffer);
    except
      FValid := False;
      raise;
    end;
    Result := '';
    if FValid then
      VerQueryValue(FBuffer, '\VarFileInfo\Translation', p, Len)
    else
      p := nil;
    if P <> nil then
      GetTranslationString := IntToHex(MakeLong(HiWord(Longint(P^)),
        LoWord(Longint(P^))), 8);
    if FValid then
    begin
      StrPCopy(szName, '\StringFileInfo\' + GetTranslationString +
        '\FileVersion');
      if VerQueryValue(FBuffer, szName, Value, Len) then
        Result := StrPas(PChar(Value));
    end;
   finally
    try
      if FBuffer <> nil then
        FreeMem(FBuffer, FSize);
    except
    end;
    try
      StrDispose(FFileName);
    except
    end;
   end;
  except
  end; 
 end;   

function CorrCurr(C:String):String;
 begin
  Result:=StringReplace(C,',','.',[rfReplaceAll,rfIgnoreCase]);
 end;

Initialization
 OleInitialize(nil);

Finalization
 OleUninitialize;

End.





