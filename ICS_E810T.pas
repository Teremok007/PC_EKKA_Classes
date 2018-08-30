unit ICS_E810T;

interface

//uses
//  Forms;//, ComObj, ComCtrls, Classes, Controls, StdCtrls, Dialogs, SysUtils;//, ActiveX;//, AxCtrls;
//  , Windows, Messages, Variants, Graphics;

type
  TIKC_E810T = class (TObject)
  private
    function GetPropertiesAutoUpdateMod: boolean;
    procedure SetPropertiesAutoUpdateMod(AutoUpdateMode: boolean = false);
    function GetUseVirtualPort: boolean;
    procedure SetUseVirtualPort(UseVirtualPort: boolean = false);
    function GetVirtualPortOpened: boolean;
    function GetTapeAnalizer: boolean;
    procedure SetTapeAnalizer(TapeAnalizer: boolean = true);
    function GetCodepageOEM: boolean;
    procedure SetCodepageOEM(CodepageOEM: boolean = false);
    function GetLangID: byte;
    procedure SetLangID(LangID: byte = 1);
    function GetRepeatCount: byte;
    procedure SetRepeatCount(RepeatCount: byte = 2);
    function GetLogRecording: boolean;
    procedure SetLogRecording(LogRecording: boolean = false);
    function GetAnswerWaiting: byte;
    procedure SetAnswerWaiting(AnswerWaiting: byte = 10);
    function GetStatusByte: byte;
    function GetResultByte: byte;
    function GetReserveByte: byte;
    function GetErrorText: string;
    function GetPrinterError: boolean;
    function GetTapeEnded: boolean;
    function GetTapeNearEnd: boolean;
    function GetItemCost: Longint;
    function GetSumTotal: Longint;
    function GetSumBalance: Longint;
    function GetItemCostStr: string;
    function GetSumTotalStr: string;
    function GetSumBalanceStr: string;
    function GetSumDiscount: Longint;
    function GetSumDiscountStr: string;
    function GetSumMarkup: Longint;
    function GetSumMarkupStr: string;
    function GetKSEFPacket: Cardinal;
    function GetKSEFPacketStr: string;
    function GetCurrentDate: TDateTime;
    function GetCurrentDateStr: string;
    function GetCurrentTime: TDateTime;
    function GetCurrentTimeStr: string;
    function GetModemError: byte;
    function GetTaxRatesCount: byte; //Количество используемых налоговых групп.
    procedure SetTaxRatesCount(TaxRatesCount: byte); //Количество используемых налоговых групп.
    function GetAddTaxType: boolean; //Тип налога: false – вложенный; true – наложенный
    procedure SetAddTaxType(AddTaxType: boolean); //Тип налога: false – вложенный; true – наложенный
    function GetTaxRate1: integer;
    function GetTaxRate2: integer;
    function GetTaxRate3: integer;
    function GetTaxRate4: integer;
    function GetTaxRate5: integer;
    function GetTaxRate6: integer;
    procedure SetTaxRate1(const Value: integer);
    procedure SetTaxRate2(const Value: integer);
    procedure SetTaxRate3(const Value: integer);
    procedure SetTaxRate4(const Value: integer);
    procedure SetTaxRate5(const Value: integer);
    function GetUsedAdditionalFee: boolean;
    procedure SetUsedAdditionalFee(const Value: boolean);
    function GetAddFeeRate1: integer;
    function GetAddFeeRate2: integer;
    function GetAddFeeRate3: integer;
    function GetAddFeeRate4: integer;
    function GetAddFeeRate5: integer;
    function GetAddFeeRate6: integer;
    procedure SetAddFeeRate1(const Value: integer);
    procedure SetAddFeeRate2(const Value: integer);
    procedure SetAddFeeRate3(const Value: integer);
    procedure SetAddFeeRate4(const Value: integer);
    procedure SetAddFeeRate5(const Value: integer);
    procedure SetAddFeeRate6(const Value: integer);
    function GetTaxOnAddFee1: boolean;
    function GetTaxOnAddFee2: boolean;
    function GetTaxOnAddFee3: boolean;
    function GetTaxOnAddFee4: boolean;
    function GetTaxOnAddFee5: boolean;
    function GetTaxOnAddFee6: boolean;
    procedure SetTaxOnAddFee1(const Value: boolean);
    procedure SetTaxOnAddFee2(const Value: boolean);
    procedure SetTaxOnAddFee3(const Value: boolean);
    procedure SetTaxOnAddFee4(const Value: boolean);
    procedure SetTaxOnAddFee5(const Value: boolean);
    procedure SetTaxOnAddFee6(const Value: boolean);
    function GetAddFeeOnRetailPrice1: boolean;
    function GetAddFeeOnRetailPrice2: boolean;
    function GetAddFeeOnRetailPrice3: boolean;
    function GetAddFeeOnRetailPrice4: boolean;
    function GetAddFeeOnRetailPrice5: boolean;
    function GetAddFeeOnRetailPrice6: boolean;
    procedure SetAddFeeOnRetailPrice1(const Value: boolean);
    procedure SetAddFeeOnRetailPrice2(const Value: boolean);
    procedure SetAddFeeOnRetailPrice3(const Value: boolean);
    procedure SetAddFeeOnRetailPrice4(const Value: boolean);
    procedure SetAddFeeOnRetailPrice5(const Value: boolean);
    procedure SetAddFeeOnRetailPrice6(const Value: boolean);
    function GetTaxRatesDate: TDateTime;
    function GetTaxRatesDateStr: string;
    function GetNamePaymentForm1: string;
    function GetNamePaymentForm10: string;
    function GetNamePaymentForm2: string;
    function GetNamePaymentForm3: string;
    function GetNamePaymentForm4: string;
    function GetNamePaymentForm5: string;
    function GetNamePaymentForm6: string;
    function GetNamePaymentForm7: string;
    function GetNamePaymentForm8: string;
    function GetNamePaymentForm9: string;
    function GetCashDrawerSum: Longint;
    function GetCashDrawerSumStr: string;
    function GetCurrentZReport: integer;
    function GetCurrentZReportStr: string;
    function GetDayEndDate: TDateTime;
    function GetDayEndDateStr: string;
    function GetDayEndTime: TDateTime;
    function GetDayEndTimeStr: string;
    function GetItemsCount: Integer;
    function GetItemsCountStr: string;
    function GetLastZReportDate: TDateTime;
    function GetLastZReportDateStr: string;
    function GetItemName: string;
    function GetItemPrice: integer;
    function GetItemRefundQtyPrecision: byte;
    function GetItemRefundQuantity: integer;
    function GetItemRefundSum: Longint;
    function GetItemRefundSumStr: string;
    function GetItemSaleQtyPrecision: byte;
    function GetItemSaleQuantity: integer;
    function GetItemSaleSum: Longint;
    function GetItemSaleSumStr: string;
    function GetItemTax: byte;
    function GetDayRefundReceiptsCount: integer;
    function GetDayRefundReceiptsCountStr: string;
    function GetDaySaleReceiptsCount: integer;
    function GetDaySaleReceiptsCountStr: string;
    function GetDaySaleSumOnTax1: Cardinal;
    function GetDaySaleSumOnTax1Str: string;
    function GetDaySaleSumOnTax2: Cardinal;
    function GetDaySaleSumOnTax2Str: string;
    function GetDaySaleSumOnTax3: Cardinal;
    function GetDaySaleSumOnTax3Str: string;
    function GetDaySaleSumOnTax4: Cardinal;
    function GetDaySaleSumOnTax4Str: string;
    function GetDaySaleSumOnTax5: Cardinal;
    function GetDaySaleSumOnTax5Str: string;
    function GetDaySaleSumOnTax6: Cardinal;
    function GetDaySaleSumOnTax6Str: string;
    function GetDayRefundSumOnTax1: Cardinal;
    function GetDayRefundSumOnTax1Str: string;
    function GetDayRefundSumOnTax2: Cardinal;
    function GetDayRefundSumOnTax2Str: string;
    function GetDayRefundSumOnTax3: Cardinal;
    function GetDayRefundSumOnTax3Str: string;
    function GetDayRefundSumOnTax4: Cardinal;
    function GetDayRefundSumOnTax4Str: string;
    function GetDayRefundSumOnTax5: Cardinal;
    function GetDayRefundSumOnTax5Str: string;
    function GetDayRefundSumOnTax6: Cardinal;
    function GetDayRefundSumOnTax6Str: string;
    function GetDaySaleSumOnPayForm1: Cardinal;
    function GetDaySaleSumOnPayForm10: Cardinal;
    function GetDaySaleSumOnPayForm10Str: string;
    function GetDaySaleSumOnPayForm1Str: string;
    function GetDaySaleSumOnPayForm2: Cardinal;
    function GetDaySaleSumOnPayForm2Str: string;
    function GetDaySaleSumOnPayForm3: Cardinal;
    function GetDaySaleSumOnPayForm3Str: string;
    function GetDaySaleSumOnPayForm4: Cardinal;
    function GetDaySaleSumOnPayForm4Str: string;
    function GetDaySaleSumOnPayForm5: Cardinal;
    function GetDaySaleSumOnPayForm5Str: string;
    function GetDaySaleSumOnPayForm6: Cardinal;
    function GetDaySaleSumOnPayForm6Str: string;
    function GetDaySaleSumOnPayForm7: Cardinal;
    function GetDaySaleSumOnPayForm7Str: string;
    function GetDaySaleSumOnPayForm8: Cardinal;
    function GetDaySaleSumOnPayForm8Str: string;
    function GetDaySaleSumOnPayForm9: Cardinal;
    function GetDaySaleSumOnPayForm9Str: string;
    function GetDayRefundSumOnPayForm1: Cardinal;
    function GetDayRefundSumOnPayForm10: Cardinal;
    function GetDayRefundSumOnPayForm2: Cardinal;
    function GetDayRefundSumOnPayForm3: Cardinal;
    function GetDayRefundSumOnPayForm4: Cardinal;
    function GetDayRefundSumOnPayForm5: Cardinal;
    function GetDayRefundSumOnPayForm6: Cardinal;
    function GetDayRefundSumOnPayForm7: Cardinal;
    function GetDayRefundSumOnPayForm8: Cardinal;
    function GetDayRefundSumOnPayForm9: Cardinal;
    function GetDayRefundSumOnPayForm10Str: string;
    function GetDayRefundSumOnPayForm1Str: string;
    function GetDayRefundSumOnPayForm2Str: string;
    function GetDayRefundSumOnPayForm3Str: string;
    function GetDayRefundSumOnPayForm4Str: string;
    function GetDayRefundSumOnPayForm5Str: string;
    function GetDayRefundSumOnPayForm6Str: string;
    function GetDayRefundSumOnPayForm7Str: string;
    function GetDayRefundSumOnPayForm8Str: string;
    function GetDayRefundSumOnPayForm9Str: string;
    function GetDayDiscountSumOnRefunds: Cardinal;
    function GetDayDiscountSumOnRefundsStr: string;
    function GetDayDiscountSumOnSales: Cardinal;
    function GetDayDiscountSumOnSalesStr: string;
    function GetDayMarkupSumOnSales: Cardinal;
    function GetDayMarkupSumOnRefunds: Cardinal;
    function GetDayMarkupSumOnSalesStr: string;
    function GetDayMarkupSumOnRefundsStr: string;
    function GetDayCashInSum: Cardinal;
    function GetDayCashInSumStr: string;
    function GetDayCashOutSum: Cardinal;
    function GetDayCashOutSumStr: string;
    function GetCurReceiptTax1Sum: Cardinal;
    function GetCurReceiptTax2Sum: Cardinal;
    function GetCurReceiptTax3Sum: Cardinal;
    function GetCurReceiptTax4Sum: Cardinal;
    function GetCurReceiptTax5Sum: Cardinal;
    function GetCurReceiptTax6Sum: Cardinal;
    function GetCurReceiptTax1SumStr: string;
    function GetCurReceiptTax2SumStr: string;
    function GetCurReceiptTax3SumStr: string;
    function GetCurReceiptTax4SumStr: string;
    function GetCurReceiptTax5SumStr: string;
    function GetCurReceiptTax6SumStr: string;
    function GetCurReceiptPayForm10Sum: Cardinal;
    function GetCurReceiptPayForm1Sum: Cardinal;
    function GetCurReceiptPayForm2Sum: Cardinal;
    function GetCurReceiptPayForm3Sum: Cardinal;
    function GetCurReceiptPayForm4Sum: Cardinal;
    function GetCurReceiptPayForm5Sum: Cardinal;
    function GetCurReceiptPayForm6Sum: Cardinal;
    function GetCurReceiptPayForm7Sum: Cardinal;
    function GetCurReceiptPayForm8Sum: Cardinal;
    function GetCurReceiptPayForm9Sum: Cardinal;
    function GetCurReceiptPayForm10SumStr: string;
    function GetCurReceiptPayForm1SumStr: string;
    function GetCurReceiptPayForm2SumStr: string;
    function GetCurReceiptPayForm3SumStr: string;
    function GetCurReceiptPayForm4SumStr: string;
    function GetCurReceiptPayForm5SumStr: string;
    function GetCurReceiptPayForm6SumStr: string;
    function GetCurReceiptPayForm7SumStr: string;
    function GetCurReceiptPayForm8SumStr: string;
    function GetCurReceiptPayForm9SumStr: string;
    function GetDayAnnuledSaleReceiptsCount: Integer;
    function GetDayAnnuledSaleReceiptsCountStr: string;
    function GetDayAnnuledSaleReceiptsSum: Cardinal;
    function GetDayAnnuledSaleReceiptsSumStr: string;
    function GetDayAnnuledRefundReceiptsCount: integer;
    function GetDayAnnuledRefundReceiptsCountStr: string;
    function GetDayAnnuledRefundReceiptsSum: Cardinal;
    function GetDayAnnuledRefundReceiptsSumStr: string;
    function GetDaySaleCancelingsCount: Integer;
    function GetDaySaleCancelingsCountStr: string;
    function GetDaySaleCancelingsSum: Cardinal;
    function GetDaySaleCancelingsSumStr: String;
    function GetDayRefundCancelingsCount: Integer;
    function GetDayRefundCancelingsCountStr: string;
    function GetDayRefundCancelingsSum: Cardinal;
    function GetDayRefundCancelingsSumStr: string;
    function GetDaySumAddTaxOfSale1: Cardinal;
    function GetDaySumAddTaxOfSale2: Cardinal;
    function GetDaySumAddTaxOfSale3: Cardinal;
    function GetDaySumAddTaxOfSale4: Cardinal;
    function GetDaySumAddTaxOfSale5: Cardinal;
    function GetDaySumAddTaxOfSale6: Cardinal;
    function GetDaySumAddTaxOfSale1Str: string;
    function GetDaySumAddTaxOfSale2Str: string;
    function GetDaySumAddTaxOfSale3Str: string;
    function GetDaySumAddTaxOfSale4Str: string;
    function GetDaySumAddTaxOfSale5Str: string;
    function GetDaySumAddTaxOfSale6Str: string;
    function GetDaySumAddTaxOfRefund1: Cardinal;
    function GetDaySumAddTaxOfRefund2: Cardinal;
    function GetDaySumAddTaxOfRefund3: Cardinal;
    function GetDaySumAddTaxOfRefund4: Cardinal;
    function GetDaySumAddTaxOfRefund5: Cardinal;
    function GetDaySumAddTaxOfRefund6: Cardinal;
    function GetDaySumAddTaxOfRefund1Str: string;
    function GetDaySumAddTaxOfRefund2Str: string;
    function GetDaySumAddTaxOfRefund3Str: string;
    function GetDaySumAddTaxOfRefund4Str: string;
    function GetDaySumAddTaxOfRefund5Str: string;
    function GetDaySumAddTaxOfRefund6Str: string;
    function GetSerialNumber: string;
    function GetFiscalNumber: string;
    function GetTaxNumber: string;
    function GetDateFiscalization: TDateTime;
    function GetDateFiscalizationStr: string;
    function GetTimeFiscalization: TDateTime;
    function GetTimeFiscalizationStr: string;
    function GetHardwareVersion: string;
    function GetHeadLine1: string;
    function GetHeadLine2: string;
    function GetHeadLine3: string;
    function GetUseAdditionalFee: boolean;
    function GetUseAdditionalTax: boolean;
    function GetUseCutter: boolean;
    function GetUseFontB: boolean;
    function GetUseTradeLogo: boolean;
    function GetCashDrawerIsOpened: boolean;
    function GetFailureLastCommand: boolean;
    function GetFiscalMode: boolean;
    function GetOnlinePrintMode: boolean;
    function GetReceiptIsOpened: boolean;
    function GetPaymentMode: boolean;
    function GetDisplayShowSumMode: boolean;
    function GetRefundReceiptMode: boolean;
    function GetServiceReceiptMode: boolean;
    function GetUserPassword: byte;
    function GetUserPasswordStr: string;
    function GetFPDriverBuildVersion: byte;
    function GetFPDriverMajorVersion: byte;
    function GetFPDriverMinorVersion: byte;
    function GetFPDriverReleaseVersion: byte;
    function GetKsefSavePath: string;
    procedure SetKsefSavePath(const Value: string);
    function GetPropertiesModemAutoUpdateMode: boolean;
    procedure SetPropertiesModemAutoUpdateMode(const Value: boolean);
    function GetModemCodepageOEM: boolean;
    procedure SetModemCodepageOEM(const Value: boolean);
    function GetModemLangID: byte;
    procedure SetModemLangID(const Value: byte);
    function GetModemRepeatCount: byte;
    procedure SetModemRepeatCount(const Value: byte);
    function GetModemLogRecording: boolean;
    procedure SetModemLogRecording(const Value: boolean);
    function GetModemAnswerWaiting: byte;
    procedure SetModemAnswerWaiting(const Value: byte);
    function GetModemKsefSavePath: string;
    procedure SetModemKsefSavePath(const Value: string);
    function GetModemErrorCode: byte;
    function GetModemErrorText: string;
    function GetModemWorkSecondCount: Longint;
    function GetFPExchangeModemSecondCount: Longint;
    function GetModemFirstUnsendPIDDateTime: TDateTime;
    function GetModemFirstUnsendPIDDateTimeStr: string;
    function GetModemPID_Unused: Longint;
    function GetModemPID_CurPers: Longint;
    function GetModemPID_LastWrite: Longint;
    function GetModemPID_LastSign: Longint;
    function GetModemPID_LastSend: Longint;
    function GetModemSerialNumber: Longint;
    function GetModemID_DEV: Longint;
    function GetModemID_SAM: Longint;
    function GetModemNT_SESSION: Longint;
    function GetModemFailCode: byte;
    function GetModemRes1: byte; virtual; abstract;
    function GetModemBatVoltage: Longint; virtual; abstract;
    function GetModemDCVoltage: Longint; virtual; abstract;
    function GetModemBatCurrent: Longint; virtual; abstract;
    function GetModemTemperature: Longint; virtual; abstract;
    function GetModemState1: byte; virtual; abstract;
    function GetModemState2: byte; virtual; abstract;
    function GetModemState3: byte;
    function GetModemLanState1: byte;
    function GetModemLanState2: byte;
    function GetModemFPExchangeResult: byte;
    function GetModemACQExchangeResult: byte;
    function GetModemRes2: byte; virtual; abstract;
    function GetModemFPExchangeErrorCount: Longint;
    function GetModemRSSI: byte; virtual; abstract;
    function GetModemRSSI_BER: byte; virtual; abstract;
    function GetModemUSSDResult: string; virtual; abstract;
    function GetModemOSVer: Longint;
    function GetModemOSRev: Longint;
    function GetModemSysTime: TDateTime;
    function GetModemSysTimeStr: string;
    function GetModemNETIPAddr: string;
    function GetModemNETGate: string;
    function GetModemNETMask: string;
    function GetModemMODIPAddr: string; virtual; abstract;
    function GetModemACQIPAddr: string;
    function GetModemACQPort: Longint;
    function GetModemACQExchangeSecondCount: Longint;
    function GetModemFoundPacket: Cardinal;
    function GetModemFoundPacketStr: string;
    function GetModemCurrentTaskCode: byte;
    function GetModemCurrentTaskText: string;
    function GetModemDriverMajorVersion: Byte;
    function GetModemDriverMinorVersion: byte;
    function GetModemDriverReleaseVersion: byte;
    function GetModemDriverBuildVersion: byte;
    function GetFiscalDayIsOpened: boolean;

  public
    function FPInitialize: Longint; //Метод выполняет начальную инициализацию параметров драйвера.
                                    //Должен вызываться сразу после создания объекта драйвера.
                                    //Возвращает 0, если инициализация прошла или код ошибки в соответствии с функцией GetLastError() или GetLastWin32Error()
    function FPOpen(_COMport: string;
                    baudRate: integer = 9600;
                    readTimeout: string = '3';
                    writeTimeout: string = '3'): boolean; //Метод открывает коммуникационный порт и устанавливает настройки порта для связи с ФР.
                                                          //В случае успешного выполнения метод возвращает true.
    function FPOpenStr(_COMport: string;
                    baudRate: integer = 9600;
                    readTimeout: string = '3';
                    writeTimeout: string = '3'): boolean; //Метод открывает коммуникационный порт и устанавливает настройки порта для связи с ФР. В случае успешного выполнения метод возвращает true.
    function FPClose: boolean; //Метод выполняет закрытие коммуникационного соединения открытого методами FPOpen или FPOpenStr.
                               //Его необходимо выполнять в самом конце работы с ФР. В случае успешного выполнения метод возвращает true
    function FPSetPassword(userID: byte;
                           oldPassword: word;
                           newPassword: word): boolean; //Метод выполняет установку новых паролей кассиров, пароля режима программирования и пароль режима отчётов. В случае успешного выполнения метод возвращает true
    function FPRegisterCashier(cashierID: byte;
                               name: string;
                               password: word): boolean; //Метод выполняет регистрацию кассира на ФР с дальнейшей печатью его имени в чеках. Если имя кассира – пустая строка, то выполняется отмена регистрации кассира.
                                                         //В случае успешного выполнения метод возвращает true
    function FPRefundItem(qty: integer;
                          qtyPrecision: byte;
                          printEAN13: boolean;
                          printSingleQty: boolean;
                          printFromMemory: boolean;
                          itemPrice: integer;
                          itemTax: byte;
                          itemName: string;
                          itemCode: Longint): boolean; //Метод выполняет регистрацию возврата или приёмки товара в чеке выплат. В случае успешного выполнения метод возвращает true
    function FPRefundItemStr(qty: integer;
                             qtyPrecision: byte;
                             printEAN13: boolean;
                             printSingleQty: boolean;
                             printFromMemory: boolean;
                             itemPrice: integer;
                             itemTax: byte;
                             itemName: string;
                             itemCode: string): boolean; //Метод аналогичен FPRefundItem и выполняет регистрацию возврата или приёмки товара в чеке выплат.
                                                          //Рекомендуется для использования в случае, если среда разработки не поддерживает
                                                          //тип __int64 (1С:Предприятие 8.x). В случае успешного выполнения метод возвращает true
    function FPSaleItem(qty: integer;
                        qtyPrecision: byte;
                        printEAN13: boolean;
                        printSingleQty: boolean;
                        printFromMemory: boolean;
                        itemPrice: integer;
                        itemTax: byte;
                        itemName: string;
                        itemCode: Longint): boolean; //Метод выполняет регистрацию продажи товара в чеке продаж. В случае успешного выполнения метод возвращает true
    function FPSaleItemStr(qty: integer;
                        qtyPrecision: byte;
                        printEAN13: boolean;
                        printSingleQty: boolean;
                        printFromMemory: boolean;
                        itemPrice: integer;
                        itemTax: byte;
                        itemName: string;
                        itemCode: string): boolean; //Метод аналогичен FPSaleItem и выполняет регистрацию продажи товара в чеке продаж.
                                                    //Рекомендуется для использования в случае, если среда разработки не поддерживает
                                                    //тип __int64 (1С:Предприятие 8.x). В случае успешного выполнения метод возвращает true
    function FPCommentLine(commentLine: string;
                           openRefundReceipt: boolean=false): boolean;virtual; //Метод выполняет регистрацию текстовой строки комментария в чеке продаж и выплат.
                                                                       //Количество текстовых строк ограничено максимальным количеством товарных позиций в одном чеке для каждой модели ФР.
                                                                       //В случае успешного выполнения метод возвращает true.
    function FPPrintZeroReceipt: boolean; //Метод выполняет печать нулевого чека для открытия новой смены в ФР. В случае успешного выполнения метод возвращает true
    function FPLineFeed: boolean; //Метод выполняет протяжку ленты ФР на одну строку. В случае успешного выполнения метод возвращает true.
    function FPAnnulReceipt: boolean; //Метод выполняет отмену текущего чека без возможности восстановления. В случае успешного выполнения метод возвращает true.
    function FPCashIn(cashSum: Cardinal): boolean; //Метод выполняет операцию служебного внесения суммы денег в кассу с последующей печатью отчёта. В случае успешного выполнения метод возвращает true
    function FPCashOut(cashSum: Cardinal): boolean; //Метод выполняет операцию служебного изъятия суммы денег из кассы с последующей печатью отчёта. В случае успешного выполнения метод возвращает true
    function FPPayment(paymentForm: byte;
                       paymentSum:  integer;
                       autoCloseReceipt: boolean;
                       asFiscalReceipt: boolean;
                       authCode: string): boolean; //Метод выполняет полную или частичную оплату чека продаж или выплат по определённой форме оплаты
    function FPSetAdvHeaderLine(lineID: byte;
                                textLine: string;
                                isDoubleWidth: boolean;
                                isDoubleHeight: boolean): boolean; //Метод выполняет запись дополнительных строк заголовка чека. В случае успешного выполнения метод возвращает true
    function FPSetAdvTrailerLine(lineID: byte;
                                 textLine: string;
                                 isDoubleWidth: boolean = false;
                                 isDoubleHeight: boolean = false): boolean; //Метод выполняет запись дополнительных строк подвала чека. В случае успешного выполнения метод возвращает true
    function FPSetLineCustomerDisplay(lineID: byte;
                                      textLine: string): boolean; //Метод выполняет вывод строки на информационный дисплей покупателя. В случае успешного выполнения метод возвращает true.
    function FPSetCurrentDate(currentDate: TDateTime): boolean; //Метод выполняет установку даты в ФР. В случае успешного выполнения метод возвращает true.
    function FPSetCurrentDateStr(currentDateStr: string): boolean; //Метод выполняет установку даты в ФР. Работает аналогично методу FPSetCurrentDate. В случае успешного выполнения метод возвращает true.
    function FPGetCurrentDate: boolean; //Метод выполняет чтение текущей даты ФР в связанные с методом свойства.
                                        //В случае успешного выполнения метод возвращает true.
    function FPSetCurrentTime(currentTime: TDateTime): boolean; //Метод выполняет установку времени в ФР. Метод доступен только после выполнения Z-отчёта.
                                                                //В случае успешного выполнения метод возвращает true.
    function FPSetCurrentTimeStr(currentTimeStr: string): boolean; //Метод выполняет установку времени в ФР. Работает аналогично методу FPSetCurrentTime.
                                                                   //Метод доступен только после выполнения Z-отчёта. В случае успешного выполнения метод возвращает true.
    function FPGetCurrentTime: boolean; //Метод выполняет чтение текущего времени ФР в связанные с методом свойства.
                                        //В случае успешного выполнения метод возвращает true.
    function FPOpenCashDrawer(duration: integer): boolean; //Метод выполняет открытие денежного ящика, подключенного к ФР.
                                                           //Длительность импульса зависит от сопротивления катушки соленоида денежного ящика
                                                           //или напряжения, на которое он рассчитан. В случае успешного выполнения метод возвращает true.
    function FPPrintHardwareVersion: boolean; //Метод выполняет печать версии внутреннего программного обеспечения ФР. В случае успешного выполнения метод возвращает true
    function FPPrintLastKsefPacket: boolean; //Метод выполняет печать копии последнего пакета данных чека или Z-отчёта). В случае успешного выполнения метод возвращает true
    function FPPrintKsefPacket(packetID: Cardinal): boolean; //Метод выполняет печать копии указанного пакета данных чека или Z-отчёта. В случае успешного выполнения метод возвращает true.
    function FPMakeDiscount(isPercentType: boolean;
                            isForItem: boolean;
                            value: Integer;
                            textLine: string): boolean; //Метод выполняет операцию скидки на последний товар в чеке или на промежуточную сумму чека. В случае успешного выполнения метод возвращает true
    function FPMakeMarkUp(isPercentType: boolean;
                          isForItem: boolean;
                          value: integer;
                          textLine: string): boolean; //Метод выполняет операцию наценки на последний товар в чеке или на промежуточную сумму чека. В случае успешного выполнения метод возвращает true
    function FPOnlineSwitch: boolean; //Метод выполняет переключение режима печати чеков онлайн/оффлайн.
                                      //В случае успешного выполнения метод возвращает true
    function FPCustomerDisplayModeSwitch: boolean; //Метод выполняет переключение режима вывода суммы чека на дисплей покупателя пользовательский/автономный. В случае успешного выполнения метод возвращает true
    function FPChangeBaudRate(baudRateIndex: byte): boolean; //Метод выполняет переключение скорости работы UART в ФР на указанную скорость. В случае успешного выполнения метод возвращает true
    function FPPrintServiceReportByLine(textLine: string): boolean; //Метод выполняет открытие служебного отчёта, если он не открыт и печатает в нём одну строку текста. В случае успешного выполнения метод возвращает true
    function FPPrintServiceReportMultiLine(multiLineText: string): boolean; //Метод выполняет открытие служебного отчёта, если он не открыт и печатает в нём многострочный текст. В случае успешного выполнения метод возвращает true.
    function FPCloseServiceReport: boolean; //Метод выполняет закрытие служебного отчёта. В случае успешного выполнения метод возвращает true
    function FPDisableLogo(progPassword: Word): boolean; //Метод отключает печать пользовательского логотипа (логотипа торговой организации) в чеках и отчётах. В случае успешного выполнения метод возвращает true
    function FPEnableLogo(progPassword: Word): boolean; //Метод включает печать пользовательского логотипа (логотипа торговой организации) в чеках и отчётах, если он был предварительно записан в ФР обслуживающей организацией. В случае успешного выполнения метод возвращает true.
    function FPSetTaxRates(progPassword: Word): boolean; //Метод выполняет установку типа налога, новых ставок налогов и сборов из предварительно установленных значений связанных с методом свойств. В случае успешного выполнения метод возвращает true. Сборы устанавливаются только в случае выбора вложенного типа налога, когда налог включён в цену
    function FPGetTaxRates: boolean; //Метод выполняет чтение из ФР типа установленного налога, а также ставок налогов и сборов в связанные с методом свойства. В случае успешного выполнения метод возвращает true.
    function FPProgItem(progPassword: byte; qtyPrecision: byte; isRefundItem: boolean; itemPrice: integer; itemTax: byte; itemName: string; itemCode: Longint): boolean; //Метод выполняет предварительную запись (перед открытием смены) описания товара в память артикулов ФР. В случае успешного выполнения метод возвращает true
    function FPProgItemStr(progPassword: byte; qtyPrecision: byte; isRefundItem: boolean; itemPrice: integer; itemTax: byte; itemName: string; itemCodeStr: string): boolean; //Метод выполняет предварительную запись (перед открытием смены) описания товара в память артикулов ФР. Рекомендуется для использования в случае, если среда разработки не поддерживает тип __int64 (1С:Предприятие 8.x). В случае успешного выполнения метод возвращает true.
    function FPMakeXReport(reportPassword: Word): boolean; //Метод выполняет печать X-отчёта. В случае успешного выполнения метод возвращает true.
    function FPMakeZReport(reportPassword: Word): boolean; //Метод выполняет печать Z-отчёта с обнулением дневных регистров ФР. В случае успешного выполнения метод возвращает true
    function FPMakeReportOnItems(reportPassword: byte; firstItemCode: Longint; lastItemCode: Longint): boolean; //Метод выполняет печать отчёта по товарам из указанного диапазона кодов. Если значения firstItemCode и lastItemCode не заданы (нулевые), тогда печатается отчёт по всем товарам. В случае успешного выполнения метод возвращает true.
    function FPMakeReportOnItemsStr(reportPassword: byte; firstItemCodeStr: string; lastItemCodeStr: string): boolean; //Метод выполняет печать отчёта по товарам из указанного диапазона кодов.
                                                                                                                       //Метод работает аналогично FPMakeReportOnItems. Рекомендуется для использования в случае, если среда разработки
                                                                                                                       //не поддерживает тип __int64 (1С:Предприятие 8.x). Если значения firstItemCodeStr и lastItemCodeStr не заданы (пустая строка),
                                                                                                                       //тогда возникнет ошибка. Для печати отчёта по всем товарам в параметры firstItemCodeStr
                                                                                                                       //и lastItemCodeStr нужно передать значение “0”. В случае успешного выполнения метод возвращает true
    function FPMakePeriodicReportOnDate(reportPassword: byte; firstDate: TDateTime; lastDate: TDateTime): boolean; //Метод выполняет печать полного периодического отчёта из фискальной памяти по датам за указанный период. В случае успешного выполнения метод возвращает true.
    function FPMakePeriodicReportOnDateStr(reportPassword: byte; firstDateStr: string; lastDateStr: string): boolean; //Метод выполняет печать полного периодического отчёта из фискальной памяти по датам за указанный период.
                                                                                                                      //Метод работает аналогично FPMakePeriodicReportOnDate.
                                                                                                                      //В случае успешного выполнения метод возвращает true
    function FPMakePeriodicShortReportOnDate(reportPassword: byte; firstDate: TDateTime; lastDate: TDateTime): boolean; //Метод выполняет печать короткого периодического отчёта из фискальной памяти по датам за указанный период. В случае успешного выполнения метод возвращает true.
    function FPMakePeriodicShortReportOnDateStr(reportPassword: byte; firstDateStr: string; lastDateStr: string): boolean; //Метод выполняет печать короткого периодического отчёта из фискальной памяти по
                                                                                                                           //датам за указанный период. Работает аналогично FPMakePeriodicShortReportOnDate.
                                                                                                                           //В случае успешного выполнения метод возвращает true
    function FPMakePeriodicReportOnNumber(reportPassword: Word; firstNumber: Word; lastNumber: Word): boolean; //Метод выполняет печать полного периодического отчёта из фискальной памяти по диапазону номеров Z-отчётов.
                                                                                                               //В случае успешного выполнения метод возвращает true
    function FPCutterModeSwitch: boolean; //Метод выполняет выключение/включение обрезчика чеков. В случае успешного выполнения метод возвращает true
    function FPPrintBarcodeOnReceipt(serialCode128B: string): boolean; //Метод выполняет регистрацию штрих-кода на чек в формате CODE 128 (тип B) с последующей печатью после закрытия чека.
                                                                       //В случае успешного выполнения метод возвращает true.
    function FPPrintBarcodeOnItem(serialEAN13: string): boolean; //Метод выполняет регистрацию штрих-кода на товар в теле чека в формате EAN13.
                                                                 //В случае успешного выполнения метод возвращает true.
    function FPGetPaymentFormNames: boolean; //Метод выполняет чтение названий форм оплат из ФР в связанные с методом свойства. В случае успешного выполнения метод возвращает true
    function FPGetCashDrawerSum: boolean; //Метод выполняет чтение из ФР в связанное с методом свойство суммы наличных денежных средств, обязанных быть в денежном ящике. В случае успешного выполнения метод возвращает true
    function FPGetDayReportProperties: boolean; //Метод выполняет чтение данных о смене из ФР и заполняет ими соответствующие свойства. В случае успешного выполнения метод возвращает true
    function FPGetItemData(itemCode: Longint): boolean; //Метод выполняет чтение данных о товаре из ФР и заполняет ими соответствующие свойства. В случае успешного выполнения метод возвращает true.
    function FPGetItemDataStr(itemCodeStr: string): boolean; //Метод выполняет чтение данных о товаре из ФР и заполняет ими соответствующие свойства.
                                                             //Метод работает аналогично FPGetItemData. Рекомендуется для использования в случае, если среда разработки
                                                             //не поддерживает тип __int64 (1С:Предприятие 8.x).
                                                             //В случае успешного выполнения метод возвращает true.
    function FPGetDayReportData: boolean; //Метод выполняет чтение из ФР данных о дневных оборотах смены и заполняет ими соответствующие свойства. В случае успешного выполнения метод возвращает true.
    function FPGetCurrentReceiptData: boolean; //Метод выполняет чтение из ФР данных текущего чека и заполняет ими соответствующие свойства. В случае успешного выполнения метод возвращает true
    function FPGetDayCorrectionsData: boolean; //Метод выполняет чтение из ФР общих сумм коррекций и аннуляций чеков за смену и заполняет ими соответствующие свойства. В случае успешного выполнения метод возвращает true
    function FPGetDaySumOfAddTaxes: boolean; //Метод выполняет чтение из ФР сумм налогов распределённых по налоговым группам в случае, если установлен наложенный тип налога, а также заполняет ими соответствующие свойства. В случае успешного выполнения метод возвращает true.
    function FPGetCurrentStatus: boolean; //Метод выполняет чтение текущего состояния ФР
                                          //и также заполняет соответствующие свойства.
                                          //В случае успешного выполнения метод возвращает true.
    function FPPrintKsefRange(firstPacketID: Cardinal; lastPacketID: Cardinal): boolean; //Метод выполняет печать копий пакетов данных чеков и Z-отчётов из заданного диапазона. В случае успешного выполнения метод возвращает true.
    function FPPaymentByCard(paymentForm: byte; paymentSum: Word; autoCloseReceipt: boolean; asFiscalReceipt: boolean; cardInfo: string; authCode: String): boolean; //Метод предназначен для выполнения полной или частичной оплаты чека
                                                                                //через платёжный EFT-терминал с печатью соответствующих идентификаторов карты и кода авторизации платежа.
                                                                                //В случае успешного выполнения метод возвращает true.
    function FPPrintModemStatus: boolean; //Метод выполняет печать на ленте настроек модема, а также его текущего состояния. В случае успешного выполнения метод возвращает true
    function FPGetUserPassword(userID: byte): boolean; //Метод выполняет чтение паролей пользователей (кассиров). В случае успешного выполнения метод возвращает true
    function FPPrintBarcodeOnReceiptNew(serialCode128C: string): boolean; //Метод выполняет регистрацию штрих-кода на чек в формате CODE 128 (тип C) с последующей печатью после закрытия чека. В случае успешного выполнения метод возвращает true.
    function FPPrintBarcodeOnServiceReport(serialCode128B: string): boolean; //Метод выполняет печать штрих-кода в служебном отчёте (CODE128 тип B). В случае успешного выполнения метод возвращает true
    function FPPrintQRCode(serialQR: string): boolean; //Метод выполняет печать QR-кода. В случае успешного выполнения метод возвращает true.
    function FPClaimUSBDevice: boolean; //Метод захватывает канал связи с ФР по USB-интерфейсу через WinUSB драйвер. Работа с ФР осуществляется через конечные точки USB endpoints. В случае нахождения ФР в списке USB-устройств, а также успешного подключения к нему метод вернёт true.
    function FPReleaseUSBDevice: boolean; //Метод закрывает соединение с ФР по USB-интерфейсу и освобождает USB-устройство

    function ModemInitialize(_COMportStr: byte): integer; //Метод выполняет подключение к встроенному модему.
                                                            //Должен вызываться после метода FPOpen или FPOpenStr компоненты «ICS_EP_09».
                                                            //Возвращает 0, если инициализация прошла или код ошибки в соответствии с
                                                            //функцией GetLastError() или GetLastWin32Error()
    function ModemAckuirerConnect: boolean; //Метод выполняет попытку подключения встроенного модема к хосту эквайера для передачи данных.
                                            //Попытка нового подключения будет выполняться после окончания текущего периода ожидания на подключение (период задаётся
                                            //в настройках конфигурации модема). В случае успешного выполнения метод возвращает true.
    function ModemAckuirerUnconditionalConnect: boolean; //Метод выполняет попытку подключения встроенного модема к хосту эквайера для передачи данных.
                                                         //Попытка нового подключения будет выполняться сразу, не дожидаясь окончания текущего периода ожидания на подключение.
                                                         //В случае успешного выполнения метод возвращает true.
    function ModemUpdateStatus: boolean; //Метод выполняет чтение идентификатора модема, настроек и параметров его текущего состояния.
                                         //Данные о модеме можно вычитать из соответствующих свойств. В случае успешного выполнения метод возвращает true.
    function ModemVerifyPacket(packetID: Cardinal): boolean; //Метод выполняет проверку целостности пакета данных. В случае успешного выполнения метод возвращает true.
    function ModemFindPacket(zReport: Integer; receiptNumber: integer; receiptType: byte): boolean; //Метод выполняет поиск пакета по заданным параметрам поиска. В случае успешного выполнения метод возвращает true
    function ModemKsefPacket(packetID: Cardinal): boolean; //Метод выполняет сохранение указанного в параметре пакета данных на диск в указанную директорию (св-во prKsefSavePath) в формате XML (см. Приложение 2). В случае успешного выполнения метод возвращает true
    function ModemReadKsefRange(firstPacketID: Cardinal; lastPacketID: Cardinal): boolean; //Метод выполняет чтение и сохранение указанного диапазона пакетов данных на диск в указанную директорию (св-во prKsefSavePath) в формате XML (см. Приложение 2). В случае успешного выполнения метод возвращает true
    function ModemReadKsefByZReport(zReport: Integer): boolean; //Метод выполняет сохранение всех пакетов смены, принадлежащей указанному в параметре Z-отчёту, на диск в указанную директорию (св-во prKsefSavePath) в формате XML (см. Приложение 2). В случае успешного выполнения метод возвращает true.
    function ModemGetCurrentTask: boolean; //Метод вычитывает значение текущей задачи модема. В случае успешного выполнения метод возвращает true
    function ModemFindPacketByDateTime(findDateTime: TDateTime; findForward: boolean): boolean; //Метод выполняет поиск пакета по указанным дате, времени и направлению поиска. В случае успешного выполнения метод возвращает true.
    function ModemFindPacketByDateTimeStr(findDateTimeStr: string; findForward: boolean): boolean; //Метод выполняет поиск пакета по указанным дате, времени и направлению поиска. Метод работает аналогично ModemFindPacketByDateTime. В случае успешного выполнения метод возвращает true.
    function ModemSaveKsefRangeToBin(directory: string; fileName: string; firstPacketID: Cardinal; lastPacketID: Cardinal): boolean; //Метод выполняет выгрузку пакетов данных из указанного диапазона
                                                                                                                                     //в двоичном формате в указанную директорию на диск.
                                                                                                                                     //В параметрах функции directory и filename можно передавать
                                                                                                                                     //пустые значения. Если в параметре directory передаётся пустая строка,
                                                                                                                                     //то путь будет взят из свойства prKsefSavePath.
                                                                                                                                     //Если там тоже пустое значение, тогда путь для сохранения двоичных данных
                                                                                                                                     //пакетов будет сформирован в подкаталоге «KSEF» каталога драйвера.
                                                                                                                                     //Если в параметре fileName передаётся пустая строка, то драйвер сохранит
                                                                                                                                     //двоичные данные пакетов в виде: ssssssssss«p»xxxx«–»уууу или ssssssssss«p»xxxx
                                                                                                                                     //(для одного пакета),
                                                                                                                                     //где ssssssssss – серийный номер ФР;
                                                                                                                                     //xxxx – номера первого пакета из диапазона;
                                                                                                                                     //yyyy – номера последнего пакета из диапазона.
                                                                                                                                     //Все двоичные данные пакетов сохраняются в файл с расширением «.ksf».
                                                                                                                                     //В случае успешного выполнения метод возвращает true.
    function ModemSaveKsefByZReportTobin(directory: string; fileName: string; zReport: integer): boolean; //Метод выполняет выгрузку всех пакетов данных, принадлежащих к указанному номеру смены (номеру Z-отчёта) в двоичном
                                                                                                          //формате в указанную директорию на диск. В параметрах функции directory и filename можно передавать пустые значения.
                                                                                                          //Если в параметре directory передаётся пустая строка, то путь будет взят из свойства prKsefSavePath. Если там тоже пустое
                                                                                                          //значение, тогда путь для сохранения двоичных данных пакетов будет сформирован в подкаталоге «KSEF» каталога драйвера.
                                                                                                          //Если в параметре fileName передаётся пустая строка, то драйвер сохранит двоичные данные пакетов в виде: ssssssssss«z»x,
                                                                                                          //где ssssssssss – серийный номер ФР.
                                                                                                          //x – номер смены (Z – отчёта).
                                                                                                          //Все двоичные данные пакетов сохраняются в файл с раширением «.ksf».
                                                                                                          //В случае успешного выполнения метод возвращает true.

    property glPropertiesAutoUpdateMode: boolean read GetPropertiesAutoUpdateMod write SetPropertiesAutoUpdateMod; //true – режим скрытого вызова методов при обновлении значений связанных с методом свойств.
                                                                                                                   //По умолчанию – false
    property glUseVirtualPort: boolean read GetUseVirtualPort write SetUseVirtualPort; //Используется для корректной работы драйвера-эмулятора COM-порта при подключении ФР по интерфейсу USB.
                                                                                       //По умолчанию – false.
    property glVirtualPortOpened: boolean read GetVirtualPortOpened; //Может использоваться для контроля активности соединения с ФР по интерфейсу USB через драйвер виртуального COM- порта.
                                                                     //После установки параметра glUseVirtualPort в true и подключения к ФР методом FPOpen меняет своё состояние на true. При внезапном обрыве сеанса связи или корректном отключении снова переходит в состояние false.
                                                                     //По умолчанию – false
    property glTapeAnalizer: boolean read GetTapeAnalizer write SetTapeAnalizer; //true – анализ датчика толщины рулона ленты.
                                                                                 //По умолчанию – false
    property glCodepageOEM: boolean read GetCodepageOEM write SetCodepageOEM; //true – строки в OEM кодировке.
                                                                              //По умолчанию – false
    property glLangID: byte read GetLangID write SetLangID; //Язык текста ошибок:
                                                      //0 – английский;
                                                      //1 – русский;
                                                      //2 – украинский.
                                                      //По умолчанию – 1
    property prRepeatCount: byte read GetRepeatCount write SetRepeatCount; //Количество повторов команды при отсутствии ответа или ошибке в ответе от ФР.
                                                                           //По умолчанию – 2.
    property prLogRecording: boolean read GetLogRecording write SetLogRecording; //Признак включения функции записи трафика
                                                                                 //коммуникационного порта.
                                                                                 //По умолчанию – false.
    property prAnswerWaiting: byte read GetAnswerWaiting write SetAnswerWaiting; //Множитель таймаута ожидания ответа от ФР.
                                                                                    //Каждая 1 = таймаут 300 мс задержки.
                                                                                    //По умолчанию – 10 (3000 мс).
    property prGetStatusByte: byte read GetStatusByte; //Байт статуса ФР.
    property prGetResultByte: byte read GetResultByte; //Код ошибки ФР или драйвера
    property prGetReserveByte: byte read GetReserveByte; //Код дополнительных флагов состояния ФР

    property prGetErrorText: string read GetErrorText; //текстовое описание ошибки.
    property prPrinterError: boolean read  GetPrinterError; //Признак нахождения механизма печати в состоянии ошибки:
                                                            //false – нет ошибки;
                                                            //true – ошибка.
    property prTapeEnded: boolean read GetTapeEnded; //Признак отсутствия ленты в механизме печати:
                                                     //false – лента есть;
                                                     //true – ленты нет.
    property prTapeNearEnd: boolean read GetTapeNearEnd; //Признак малого остатка ленты в механизме печати:
                                                         //false – нет;
                                                         //true – да
    property prItemCost: Longint read GetItemCost; //Стоимость товара в коп.
    property prSumTotal: Longint read GetSumTotal; //Сумма чека в коп.
    property prSumBalance: Longint read GetSumBalance; //Сумма баланса оплат чека в коп. (prSumBalance = 0)
    property prItemCostStr: string read GetItemCostStr; //Стоимость товара в коп.
    property prSumTotalStr: string read GetSumTotalStr; //Сумма чека в коп.
    property prSumBalanceStr: string read GetSumBalanceStr; //Сумма баланса оплат чека в коп. (prSumBalance = 0)
    property prSumDiscount: Longint read GetSumDiscount; //Сумма скидок в коп.
    property prSumDiscountStr: string read GetSumDiscountStr; //Сумма скидок в коп.
    property prSumMarkup: Longint read GetSumMarkup; //Сумма наценок в коп.
    property prSumMarkupStr: string read GetSumMarkupStr; //Сумма наценок в коп
    property prKSEFPacket: Cardinal read GetKSEFPacket; //Номер пакета данных
    property prKSEFPacketStr: string read GetKSEFPacketStr; //Номер пакета в виде строки.
    property prCurrentDate: TDateTime read GetCurrentDate; //Текущая дата ФР, составляющая времени не учитывается.
    property prCurrentDateStr: string read GetCurrentDateStr; //Текущая дата ФР в виде строки с разделителями даты
    property prCurrentTime: TDateTime read GetCurrentTime; //Текущее время ФР , составляющая даты не учитывается.
    property prCurrentTimeStr: string read GetCurrentTimeStr; //Текущее время ФР в виде строки с разделителями времени.
    property prModemError: byte read GetModemError; //Код ошибки модема
    property prTaxRatesCount: byte read GetTaxRatesCount write SetTaxRatesCount; //Количество используемых налоговых групп.
    property prAddTaxType: boolean read GetAddTaxType write SetAddTaxType; //Тип налога: false – вложенный; true – наложенный
    property prTaxRate1: integer read GetTaxRate1 write SetTaxRate1; //Ставка группы «А» в 0,01 %
    property prTaxRate2: integer read GetTaxRate2 write SetTaxRate2; //Ставка группы «Б» в 0,01 %
    property prTaxRate3: integer read GetTaxRate3 write SetTaxRate3; //Ставка группы «В» в 0,01 %
    property prTaxRate4: integer read GetTaxRate4 write SetTaxRate4; //Ставка группы «Г» в 0,01 %
    property prTaxRate5: integer read GetTaxRate5 write SetTaxRate5; //Ставка группы «Д» в 0,01 %
    property prTaxRate6: integer read GetTaxRate6; //Ставка группы «Д» в 0,01 %
    property prUsedAdditionalFee: boolean read GetUsedAdditionalFee write SetUsedAdditionalFee; //Флаг использования сборов: false – не используются; true – используются.
    property prAddFeeRate1: integer read GetAddFeeRate1 write SetAddFeeRate1; //Ставка сбора «А» в 0,01 %
    property prAddFeeRate2: integer read GetAddFeeRate2 write SetAddFeeRate2; //Ставка сбора «Б» в 0,01 %
    property prAddFeeRate3: integer read GetAddFeeRate3 write SetAddFeeRate3; //Ставка сбора «В» в 0,01 %
    property prAddFeeRate4: integer read GetAddFeeRate4 write SetAddFeeRate4; //Ставка сбора «Г» в 0,01 %
    property prAddFeeRate5: integer read GetAddFeeRate5 write SetAddFeeRate5; //Ставка сбора «Д» в 0,01 %
    property prAddFeeRate6: integer read GetAddFeeRate6 write SetAddFeeRate6; //Ставка сбора «Е» в 0,01 %
    property prTaxOnAddFee1: boolean read GetTaxOnAddFee1 write SetTaxOnAddFee1; //Налог на сбор группы «А»: false – не начисляется; true – начисляется
    property prTaxOnAddFee2: boolean read GetTaxOnAddFee2 write SetTaxOnAddFee2; //Налог на сбор группы «Б»: false – не начисляется; true – начисляется
    property prTaxOnAddFee3: boolean read GetTaxOnAddFee3 write SetTaxOnAddFee3; //Налог на сбор группы «В»: false – не начисляется; true – начисляется
    property prTaxOnAddFee4: boolean read GetTaxOnAddFee4 write SetTaxOnAddFee4; //Налог на сбор группы «Г»: false – не начисляется; true – начисляется
    property prTaxOnAddFee5: boolean read GetTaxOnAddFee5 write SetTaxOnAddFee5; //Налог на сбор группы «Д»: false – не начисляется; true – начисляется
    property prTaxOnAddFee6: boolean read GetTaxOnAddFee6 write SetTaxOnAddFee6; //Налог на сбор группы «Е»: false – не начисляется; true – начисляется
    property prAddFeeOnRetailPrice1: boolean read GetAddFeeOnRetailPrice1 write SetAddFeeOnRetailPrice1; //Сбор на розничную цену с НДС для группы «А»: false – не начисляется; true – начисляется.
    property prAddFeeOnRetailPrice2: boolean read GetAddFeeOnRetailPrice2 write SetAddFeeOnRetailPrice2; //Сбор на розничную цену с НДС для группы «А»: false – не начисляется; true – начисляется.
    property prAddFeeOnRetailPrice3: boolean read GetAddFeeOnRetailPrice3 write SetAddFeeOnRetailPrice3; //Сбор на розничную цену с НДС для группы «А»: false – не начисляется; true – начисляется.
    property prAddFeeOnRetailPrice4: boolean read GetAddFeeOnRetailPrice4 write SetAddFeeOnRetailPrice4; //Сбор на розничную цену с НДС для группы «А»: false – не начисляется; true – начисляется.
    property prAddFeeOnRetailPrice5: boolean read GetAddFeeOnRetailPrice5 write SetAddFeeOnRetailPrice5; //Сбор на розничную цену с НДС для группы «А»: false – не начисляется; true – начисляется.
    property prAddFeeOnRetailPrice6: boolean read GetAddFeeOnRetailPrice6 write SetAddFeeOnRetailPrice6; //Сбор на розничную цену с НДС для группы «А»: false – не начисляется; true – начисляется.
    property prTaxRatesDate: TDateTime read GetTaxRatesDate; //Дата программирования налоговых групп
    property prTaxRatesDateStr: string read GetTaxRatesDateStr; //Дата программирования налоговых групп
    property prNamePaymentForm1: string read GetNamePaymentForm1; //Название формы оплаты №1
    property prNamePaymentForm2: string read GetNamePaymentForm2; //Название формы оплаты №2
    property prNamePaymentForm3: string read GetNamePaymentForm3; //Название формы оплаты №3
    property prNamePaymentForm4: string read GetNamePaymentForm4; //Название формы оплаты №4
    property prNamePaymentForm5: string read GetNamePaymentForm5; //Название формы оплаты №5
    property prNamePaymentForm6: string read GetNamePaymentForm6; //Название формы оплаты №6
    property prNamePaymentForm7: string read GetNamePaymentForm7; //Название формы оплаты №7
    property prNamePaymentForm8: string read GetNamePaymentForm8; //Название формы оплаты №8
    property prNamePaymentForm9: string read GetNamePaymentForm9; //Название формы оплаты №9
    property prNamePaymentForm10: string read GetNamePaymentForm10; //Название формы оплаты №10
    property prCashDrawerSum: Longint read GetCashDrawerSum; //Сумма наличных денежных средств, в денежном ящике, коп.
    property prCashDrawerSumStr: string read GetCashDrawerSumStr; //Сумма наличных денежных средств, в денежном ящике в текстовом представлении, коп.
    property prCurrentZReport: Integer read GetCurrentZReport; //Номер текущей смены
    property prCurrentZReportStr: string read GetCurrentZReportStr; //Номер текущей смены в текстовом представлении.
    property prDayEndDate: TDateTime read GetDayEndDate; //Дата конца смены, составляющая времени игнорируется
    property prDayEndDateStr: string read GetDayEndDateStr; //Дата конца смены, представленная в виде строки с разделителями даты
    property prDayEndTime: TDateTime read GetDayEndTime; //Время конца смены, составляющая даты игнорируется.
    property prDayEndTimeStr: string read GetDayEndTimeStr; //Время конца смены, представленное в виде строки с разделителями времени
    property prItemsCount: Integer read GetItemsCount; //Количество описаний товаров в памяти ФР
    property prItemsCountStr: string read GetItemsCountStr; //Количество описаний товаров в памяти ФР в текстовом представлении.
    property prLastZReportDate: TDateTime read GetLastZReportDate; //Дата последнего Z-отчёта, составляющая времени игнорируется.
    property prLastZReportDateStr: string read GetLastZReportDateStr; //Дата последнего Z-отчёта, представленная в виде строки с разделителями даты
    property prItemName: string read GetItemName; //Название товара
    property prItemPrice: integer read GetItemPrice; //Цена товара в коп.
    property prItemTax: byte read GetItemTax; //Индекс налоговой группы 1-А … 6-Е)
    property prItemSaleQuantity: integer read GetItemSaleQuantity; //Количество проданного товара в минимальной единице измерения
    property prItemSaleQtyPrecision: byte read GetItemSaleQtyPrecision; //Степень делителя количества с основанием 10 для учётной единицы измерения
    property prItemSaleSum: Longint read GetItemSaleSum; //Сумма продаж в коп
    property prItemSaleSumStr: string read GetItemSaleSumStr; //Сумма продаж, в текстовом представлении, коп.
    property prItemRefundQuantity: integer read GetItemRefundQuantity; //Количество выплаченного товара в минимальной единице измерения
    property prItemRefundQtyPrecision: byte read GetItemRefundQtyPrecision; //Степень делителя количества с основанием 10 для учётной единицы измерения
    property prItemRefundSum: Longint read GetItemRefundSum; //Сумма выплат в коп.
    property prItemRefundSumStr: string read GetItemRefundSumStr; //Сумма выплат в текстовом представлении, коп
    property prDaySaleReceiptsCount: integer read GetDaySaleReceiptsCount; //Количество чеков продаж за смену.
    property prDaySaleReceiptsCountStr: string read GetDaySaleReceiptsCountStr; //Количество чеков продаж за смену в текстовом представлении.
    property prDayRefundReceiptsCount: integer read GetDayRefundReceiptsCount; //Количество чеков выплат за смену.
    property prDayRefundReceiptsCountStr: string read GetDayRefundReceiptsCountStr; //Количество чеков выплат за смену в текстовом представлении
    property prDaySaleSumOnTax1: Cardinal read GetDaySaleSumOnTax1; //Сумма оборота продаж в коп. по налоговой группе «А»
    property prDaySaleSumOnTax1Str: string read GetDaySaleSumOnTax1Str; //Сумма оборота продаж в коп. по налоговой группе «А» в текстовом представлении.
    property prDaySaleSumOnTax2: Cardinal read GetDaySaleSumOnTax2; //Сумма оборота продаж в коп. по налоговой группе «Б»
    property prDaySaleSumOnTax2Str: string read GetDaySaleSumOnTax2Str; //Сумма оборота продаж в коп. по налоговой группе «Б» в текстовом представлении.
    property prDaySaleSumOnTax3: Cardinal read GetDaySaleSumOnTax3; //Сумма оборота продаж в коп. по налоговой группе «В»
    property prDaySaleSumOnTax3Str: string read GetDaySaleSumOnTax3Str; //Сумма оборота продаж в коп. по налоговой группе «В» в текстовом представлении.
    property prDaySaleSumOnTax4: Cardinal read GetDaySaleSumOnTax4; //Сумма оборота продаж в коп. по налоговой группе «Г»
    property prDaySaleSumOnTax4Str: string read GetDaySaleSumOnTax4Str; //Сумма оборота продаж в коп. по налоговой группе «Г» в текстовом представлении.
    property prDaySaleSumOnTax5: Cardinal read GetDaySaleSumOnTax5; //Сумма оборота продаж в коп. по налоговой группе «Д»
    property prDaySaleSumOnTax5Str: string read GetDaySaleSumOnTax5Str; //Сумма оборота продаж в коп. по налоговой группе «Д» в текстовом представлении.
    property prDaySaleSumOnTax6: Cardinal read GetDaySaleSumOnTax6; //Сумма оборота продаж в коп. по налоговой группе «Е»
    property prDaySaleSumOnTax6Str: string read GetDaySaleSumOnTax6Str; //Сумма оборота продаж в коп. по налоговой группе «Е» в текстовом представлении.
    property prDayRefundSumOnTax1: Cardinal read GetDayRefundSumOnTax1; //Сумма оборота выплат в коп. по налоговой группе «А».
    property prDayRefundSumOnTax1Str: string read GetDayRefundSumOnTax1Str; //Сумма оборота выплат в коп. по налоговой группе «А» в текстовом представлении.
    property prDayRefundSumOnTax2: Cardinal read GetDayRefundSumOnTax2; //Сумма оборота выплат в коп. по налоговой группе «Б».
    property prDayRefundSumOnTax2Str: string read GetDayRefundSumOnTax2Str; //Сумма оборота выплат в коп. по налоговой группе «Б» в текстовом представлении.
    property prDayRefundSumOnTax3: Cardinal read GetDayRefundSumOnTax3; //Сумма оборота выплат в коп. по налоговой группе «В».
    property prDayRefundSumOnTax3Str: string read GetDayRefundSumOnTax3Str; //Сумма оборота выплат в коп. по налоговой группе «В» в текстовом представлении.
    property prDayRefundSumOnTax4: Cardinal read GetDayRefundSumOnTax4; //Сумма оборота выплат в коп. по налоговой группе «Г».
    property prDayRefundSumOnTax4Str: string read GetDayRefundSumOnTax4Str; //Сумма оборота выплат в коп. по налоговой группе «Г» в текстовом представлении.
    property prDayRefundSumOnTax5: Cardinal read GetDayRefundSumOnTax5; //Сумма оборота выплат в коп. по налоговой группе «Д».
    property prDayRefundSumOnTax5Str: string read GetDayRefundSumOnTax5Str; //Сумма оборота выплат в коп. по налоговой группе «Д» в текстовом представлении.
    property prDayRefundSumOnTax6: Cardinal read GetDayRefundSumOnTax6; //Сумма оборота выплат в коп. по налоговой группе «Е».
    property prDayRefundSumOnTax6Str: string read GetDayRefundSumOnTax6Str; //Сумма оборота выплат в коп. по налоговой группе «Е» в текстовом представлении.
    property prDaySaleSumOnPayForm1: Cardinal read GetDaySaleSumOnPayForm1; //Сумма оборота продаж в коп. по форме «КАРТОЧКА».
    property prDaySaleSumOnPayForm1Str: string read GetDaySaleSumOnPayForm1Str; //Сумма оборота продаж в коп. по форме «КАРТОЧКА» в текстовом представлении.
    property prDaySaleSumOnPayForm2: Cardinal read GetDaySaleSumOnPayForm2; //Сумма оборота продаж в коп. по форме «КРЕДИТ».
    property prDaySaleSumOnPayForm2Str: string read GetDaySaleSumOnPayForm2Str; //Сумма оборота продаж в коп. по форме «КРЕДИТ» в текстовом представлении.
    property prDaySaleSumOnPayForm3: Cardinal read GetDaySaleSumOnPayForm3; //Сумма оборота продаж в коп. по форме «ЧЕК».
    property prDaySaleSumOnPayForm3Str: string read GetDaySaleSumOnPayForm3Str; //Сумма оборота продаж в коп. по форме «ЧЕК» в текстовом представлении.
    property prDaySaleSumOnPayForm4: Cardinal read GetDaySaleSumOnPayForm4; //Сумма оборота продаж в коп. по форме «НАЛИЧНЫЕ».
    property prDaySaleSumOnPayForm4Str: string read GetDaySaleSumOnPayForm4Str; //Сумма оборота продаж в коп. по форме «НАЛИЧНЫЕ» в текстовом представлении.
    property prDaySaleSumOnPayForm5: Cardinal read GetDaySaleSumOnPayForm5; //Сумма оборота продаж в коп. по форме «СЕРТИФИКАТ».
    property prDaySaleSumOnPayForm5Str: string read GetDaySaleSumOnPayForm5Str; //Сумма оборота продаж в коп. по форме «СЕРТИФИКАТ» в текстовом представлении.
    property prDaySaleSumOnPayForm6: Cardinal read GetDaySaleSumOnPayForm6; //Сумма оборота продаж в коп. по форме «ВАУЧЕР».
    property prDaySaleSumOnPayForm6Str: string read GetDaySaleSumOnPayForm6Str; //Сумма оборота продаж в коп. по форме «ВАУЧЕР» в текстовом представлении.
    property prDaySaleSumOnPayForm7: Cardinal read GetDaySaleSumOnPayForm7; //Сумма оборота продаж в коп. по форме «ЭЛЕКТРОННЫЕ ДЕНЬГИ».
    property prDaySaleSumOnPayForm7Str: string read GetDaySaleSumOnPayForm7Str; //Сумма оборота продаж в коп. по форме «ЭЛЕКТРОННЫЕ ДЕНЬГИ» в текстовом представлении.
    property prDaySaleSumOnPayForm8: Cardinal read GetDaySaleSumOnPayForm8; //Сумма оборота продаж в коп. по форме «СТРАХОВАЯ ВЫПЛАТА».
    property prDaySaleSumOnPayForm8Str: string read GetDaySaleSumOnPayForm8Str; //Сумма оборота продаж в коп. по форме «СТРАХОВАЯ ВЫПЛАТА» в текстовом представлении.
    property prDaySaleSumOnPayForm9: Cardinal read GetDaySaleSumOnPayForm9; //Сумма оборота продаж в коп. по форме «ПРЕДОПЛАТА».
    property prDaySaleSumOnPayForm9Str: string read GetDaySaleSumOnPayForm9Str; //Сумма оборота продаж в коп. по форме «ПРЕДОПЛАТА» в текстовом представлении
    property prDaySaleSumOnPayForm10: Cardinal read GetDaySaleSumOnPayForm10; //Сумма оборота продаж в коп. по форме «ОПЛАТА».
    property prDaySaleSumOnPayForm10Str: string read GetDaySaleSumOnPayForm10Str; //Сумма оборота продаж в коп. по форме «ОПЛАТА» в текстовом представлении.
    property prDayRefundSumOnPayForm1: Cardinal read GetDayRefundSumOnPayForm1; //Сумма оборота выплат в коп. по форме «КАРТОЧКА».
    property prDayRefundSumOnPayForm2: Cardinal read GetDayRefundSumOnPayForm2; //Сумма оборота выплат в коп. по форме «КРЕДИТ».
    property prDayRefundSumOnPayForm3: Cardinal read GetDayRefundSumOnPayForm3; //Сумма оборота выплат в коп. по форме «ЧЕК».
    property prDayRefundSumOnPayForm4: Cardinal read GetDayRefundSumOnPayForm4; //Сумма оборота выплат в коп. по форме «НАЛИЧНЫЕ».
    property prDayRefundSumOnPayForm5: Cardinal read GetDayRefundSumOnPayForm5; //Сумма оборота выплат в коп. по форме «СЕРТИФИКАТ».
    property prDayRefundSumOnPayForm6: Cardinal read GetDayRefundSumOnPayForm6; //Сумма оборота выплат в коп. по форме «ВАУЧЕР».
    property prDayRefundSumOnPayForm7: Cardinal read GetDayRefundSumOnPayForm7; //Сумма оборота выплат в коп. по форме «ЭЛЕКТРОННЫЕ ДЕНЬГИ».
    property prDayRefundSumOnPayForm8: Cardinal read GetDayRefundSumOnPayForm8; //Сумма оборота выплат в коп. по форме «СТРАХОВАЯ ВЫПЛАТА».
    property prDayRefundSumOnPayForm9: Cardinal read GetDayRefundSumOnPayForm9; //Сумма оборота выплат в коп. по форме «ПРЕДОПЛАТА».
    property prDayRefundSumOnPayForm10: Cardinal read GetDayRefundSumOnPayForm10; //Сумма оборота выплат в коп. по форме «ОПЛАТА».
    property prDayRefundSumOnPayForm1Str: string read GetDayRefundSumOnPayForm1Str; //Сумма оборота выплат в коп. по форме «КАРТОЧКА» в текстовом представлении.
    property prDayRefundSumOnPayForm2Str: string read GetDayRefundSumOnPayForm2Str; //Сумма оборота выплат в коп. по форме «КРЕДИТ» в текстовом представлении.
    property prDayRefundSumOnPayForm3Str: string read GetDayRefundSumOnPayForm3Str; //Сумма оборота выплат в коп. по форме «ЧЕК» в текстовом представлении.
    property prDayRefundSumOnPayForm4Str: string read GetDayRefundSumOnPayForm4Str; //Сумма оборота выплат в коп. по форме «НАЛИЧНЫЕ» в текстовом представлении.
    property prDayRefundSumOnPayForm5Str: string read GetDayRefundSumOnPayForm5Str; //Сумма оборота выплат в коп. по форме «СЕРТИФИКАТ» в текстовом представлении
    property prDayRefundSumOnPayForm6Str: string read GetDayRefundSumOnPayForm6Str; //Сумма оборота выплат в коп. по форме «ВАУЧЕР» в текстовом представлении.
    property prDayRefundSumOnPayForm7Str: string read GetDayRefundSumOnPayForm7Str; //Сумма оборота выплат в коп. по форме «ЭЛЕКТРОННЫЕ ДЕНЬГИ» в текстовом представлении.
    property prDayRefundSumOnPayForm8Str: string read GetDayRefundSumOnPayForm8Str; //Сумма оборота выплат в коп. по форме «СТРАХОВАЯ ВЫПЛАТА» в текстовом представлении.
    property prDayRefundSumOnPayForm9Str: string read GetDayRefundSumOnPayForm9Str; //Сумма оборота выплат в коп. по форме «ПРЕДОПЛАТА» в текстовом представлении.
    property prDayRefundSumOnPayForm10Str: string read GetDayRefundSumOnPayForm10Str; //Сумма оборота выплат в коп. по форме «ОПЛАТА» в текстовом представлении.
    property prDayDiscountSumOnSales: Cardinal read GetDayDiscountSumOnSales; //Сумма скидок в коп. с продаж.
    property prDayDiscountSumOnSalesStr: string read GetDayDiscountSumOnSalesStr; //Сумма скидок в коп. с продаж в текстовом представлении
    property prDayDiscountSumOnRefunds: Cardinal read GetDayDiscountSumOnRefunds; //Сумма скидок в коп. с выплат.
    property prDayDiscountSumOnRefundsStr: string read GetDayDiscountSumOnRefundsStr; //Сумма скидок в коп. с выплат в текстовом представлении
    property prDayMarkupSumOnSales: Cardinal read GetDayMarkupSumOnSales; //Сумма наценок в коп. с продаж.
    property prDayMarkupSumOnSalesStr: string read GetDayMarkupSumOnSalesStr; //Сумма наценок в коп. с продаж в текстовом представлении.
    property prDayMarkupSumOnRefunds: Cardinal read GetDayMarkupSumOnRefunds; //Сумма наценок в коп. с выплат.
    property prDayMarkupSumOnRefundsStr: string read GetDayMarkupSumOnRefundsStr; //Сумма наценок в коп. с выплат в текстовом представлении.
    property prDayCashInSum: Cardinal read GetDayCashInSum; //Сумма служебных внесений в коп.
    property prDayCashInSumStr: string read GetDayCashInSumStr; //Сумма служебных внесений в коп. в текстовом представлении.
    property prDayCashOutSum: Cardinal read GetDayCashOutSum; //Сумма служебных изъятий в коп.
    property prDayCashOutSumStr: string read GetDayCashOutSumStr; //Сумма служебных изъятий в коп. в текстовом представлении.
    property prCurReceiptTax1Sum: Cardinal read GetCurReceiptTax1Sum; //Сумма чека в коп. по налоговой группе «А».
    property prCurReceiptTax2Sum: Cardinal read GetCurReceiptTax2Sum; //Сумма чека в коп. по налоговой группе «Б».
    property prCurReceiptTax3Sum: Cardinal read GetCurReceiptTax3Sum; //Сумма чека в коп. по налоговой группе «В».
    property prCurReceiptTax4Sum: Cardinal read GetCurReceiptTax4Sum; //Сумма чека в коп. по налоговой группе «Г».
    property prCurReceiptTax5Sum: Cardinal read GetCurReceiptTax5Sum; //Сумма чека в коп. по налоговой группе «Д».
    property prCurReceiptTax6Sum: Cardinal read GetCurReceiptTax6Sum; //Сумма чека в коп. по налоговой группе «Е».
    property prCurReceiptTax1SumStr: string read GetCurReceiptTax1SumStr; //Сумма чека в коп. по налоговой группе «А» в текстовом представлении
    property prCurReceiptTax2SumStr: string read GetCurReceiptTax2SumStr; //Сумма чека в коп. по налоговой группе «Б» в текстовом представлении
    property prCurReceiptTax3SumStr: string read GetCurReceiptTax3SumStr; //Сумма чека в коп. по налоговой группе «В» в текстовом представлении
    property prCurReceiptTax4SumStr: string read GetCurReceiptTax4SumStr; //Сумма чека в коп. по налоговой группе «Г» в текстовом представлении
    property prCurReceiptTax5SumStr: string read GetCurReceiptTax5SumStr; //Сумма чека в коп. по налоговой группе «Д» в текстовом представлении
    property prCurReceiptTax6SumStr: string read GetCurReceiptTax6SumStr; //Сумма чека в коп. по налоговой группе «Е» в текстовом представлении
    property prCurReceiptPayForm1Sum: Cardinal read GetCurReceiptPayForm1Sum; //Сумма чека в коп. по форме оплаты «КАРТОЧКА».
    property prCurReceiptPayForm2Sum: Cardinal read GetCurReceiptPayForm2Sum; //Сумма чека в коп. по форме оплаты «КРЕДИТ».
    property prCurReceiptPayForm3Sum: Cardinal read GetCurReceiptPayForm3Sum; //Сумма чека в коп. по форме оплаты «ЧЕК».
    property prCurReceiptPayForm4Sum: Cardinal read GetCurReceiptPayForm4Sum; //Сумма чека в коп. по форме оплаты «НАЛИЧНЫЕ».
    property prCurReceiptPayForm5Sum: Cardinal read GetCurReceiptPayForm5Sum; //Сумма чека в коп. по форме оплаты «СЕРТИФИКАТ».
    property prCurReceiptPayForm6Sum: Cardinal read GetCurReceiptPayForm6Sum; //Сумма чека в коп. по форме оплаты «ВАУЧЕР».
    property prCurReceiptPayForm7Sum: Cardinal read GetCurReceiptPayForm7Sum; //Сумма чека в коп. по форме оплаты «ЭЛЕКТРОННЫЕ ДЕНЬГИ».
    property prCurReceiptPayForm8Sum: Cardinal read GetCurReceiptPayForm8Sum; //Сумма чека в коп. по форме оплаты «СТРАХОВАЯ ВЫПЛАТА».
    property prCurReceiptPayForm9Sum: Cardinal read GetCurReceiptPayForm9Sum; //Сумма чека в коп. по форме оплаты «ПРЕДОПЛАТА».
    property prCurReceiptPayForm10Sum: Cardinal read GetCurReceiptPayForm10Sum; //Сумма чека в коп. по форме оплаты «ОПЛАТА».
    property prCurReceiptPayForm1SumStr: string read GetCurReceiptPayForm1SumStr; //Сумма чека в коп. по форме оплаты «КАРТОЧКА» в текстовом представлении.
    property prCurReceiptPayForm2SumStr: string read GetCurReceiptPayForm2SumStr; //Сумма чека в коп. по форме оплаты «КРЕДИТ» в текстовом представлении.
    property prCurReceiptPayForm3SumStr: string read GetCurReceiptPayForm3SumStr; //Сумма чека в коп. по форме оплаты «ЧЕК» в текстовом представлении.
    property prCurReceiptPayForm4SumStr: string read GetCurReceiptPayForm4SumStr; //Сумма чека в коп. по форме оплаты «НАЛИЧНЫЕ» в текстовом представлении.
    property prCurReceiptPayForm5SumStr: string read GetCurReceiptPayForm5SumStr; //Сумма чека в коп. по форме оплаты «СЕРТИФИКАТ» в текстовом представлении
    property prCurReceiptPayForm6SumStr: string read GetCurReceiptPayForm6SumStr; //Сумма чека в коп. по форме оплаты «ВАУЧЕР» в текстовом представлении.
    property prCurReceiptPayForm7SumStr: string read GetCurReceiptPayForm7SumStr; //Сумма чека в коп. по форме оплаты «ЭЛЕКТРОННЫЕ ДЕНЬГИ» в текстовом представлении.
    property prCurReceiptPayForm8SumStr: string read GetCurReceiptPayForm8SumStr; //Сумма чека в коп. по форме оплаты «СТРАХОВАЯ ВЫПЛАТА» в текстовом представлении.
    property prCurReceiptPayForm9SumStr: string read GetCurReceiptPayForm9SumStr; //Сумма чека в коп. по форме оплаты «ПРЕДОПЛАТА» в текстовом представлении.
    property prCurReceiptPayForm10SumStr: string read GetCurReceiptPayForm10SumStr; //Сумма чека в коп. по форме оплаты «ОПЛАТА» в текстовом представлении.
    property prDayAnnuledSaleReceiptsCount: Integer read GetDayAnnuledSaleReceiptsCount; //Количество аннулированных чеков продаж.
    property prDayAnnuledSaleReceiptsCountStr: string read GetDayAnnuledSaleReceiptsCountStr; //Количество аннулированных чеков продаж в текстовом представлении.
    property prDayAnnuledSaleReceiptsSum: Cardinal read GetDayAnnuledSaleReceiptsSum; //Общая сумма аннулированных чеков продаж, коп
    property prDayAnnuledSaleReceiptsSumStr: string read GetDayAnnuledSaleReceiptsSumStr; //Общая сумма аннулированных чеков продаж в текстовом представлении, коп
    property prDayAnnuledRefundReceiptsCount: integer read GetDayAnnuledRefundReceiptsCount; //Количество аннулированных чеков выплат.
    property prDayAnnuledRefundReceiptsCountStr: string read GetDayAnnuledRefundReceiptsCountStr; //Количество аннулированных чеков выплат в текстовом представлении.
    property prDayAnnuledRefundReceiptsSum: Cardinal read GetDayAnnuledRefundReceiptsSum; //Общая сумма аннулированных чеков выплат, коп.
    property prDayAnnuledRefundReceiptsSumStr: string read GetDayAnnuledRefundReceiptsSumStr; //Общая сумма аннулированных чеков выплат в текстовом представлении, коп.
    property prDaySaleCancelingsCount: Integer read GetDaySaleCancelingsCount; //Количество отмен в чеках продаж.
    property prDaySaleCancelingsCountStr: string read GetDaySaleCancelingsCountStr; //Количество отмен в чеках продаж в текстовом представлении.
    property prDaySaleCancelingsSum: Cardinal read GetDaySaleCancelingsSum; //Общая сумма отмен в чеках продаж, коп.
    property prDaySaleCancelingsSumStr: String read GetDaySaleCancelingsSumStr; //Общая сумма отмен в чеках продаж в текстовом представлении, коп.
    property prDayRefundCancelingsCount: Integer read GetDayRefundCancelingsCount; //Количество отмен в чеках выплат.
    property prDayRefundCancelingsCountStr: string read GetDayRefundCancelingsCountStr; //Количество отмен в чеках выплат в текстовом представлении.
    property prDayRefundCancelingsSum: Cardinal read GetDayRefundCancelingsSum; //Общая сумма отмен в чеках выплат, коп
    property prDayRefundCancelingsSumStr: string read GetDayRefundCancelingsSumStr; //Общая сумма отмен в чеках выплат в текстовом представлении, коп
    property prDaySumAddTaxOfSale1: Cardinal read GetDaySumAddTaxOfSale1; //Сумма налога с продаж по группе «А», коп.
    property prDaySumAddTaxOfSale2: Cardinal read GetDaySumAddTaxOfSale2; //Сумма налога с продаж по группе «Б», коп.
    property prDaySumAddTaxOfSale3: Cardinal read GetDaySumAddTaxOfSale3; //Сумма налога с продаж по группе «В», коп.
    property prDaySumAddTaxOfSale4: Cardinal read GetDaySumAddTaxOfSale4; //Сумма налога с продаж по группе «Г», коп.
    property prDaySumAddTaxOfSale5: Cardinal read GetDaySumAddTaxOfSale5; //Сумма налога с продаж по группе «Д», коп.
    property prDaySumAddTaxOfSale6: Cardinal read GetDaySumAddTaxOfSale6; //Сумма налога с продаж по группе «Е», коп.
    property prDaySumAddTaxOfSale1Str: string read GetDaySumAddTaxOfSale1Str; //Сумма налога с продаж по группе «А» в текстовом представлении, коп.
    property prDaySumAddTaxOfSale2Str: string read GetDaySumAddTaxOfSale2Str; //Сумма налога с продаж по группе «Б» в текстовом представлении, коп.
    property prDaySumAddTaxOfSale3Str: string read GetDaySumAddTaxOfSale3Str; //Сумма налога с продаж по группе «В» в текстовом представлении, коп.
    property prDaySumAddTaxOfSale4Str: string read GetDaySumAddTaxOfSale4Str; //Сумма налога с продаж по группе «Г» в текстовом представлении, коп.
    property prDaySumAddTaxOfSale5Str: string read GetDaySumAddTaxOfSale5Str; //Сумма налога с продаж по группе «Д» в текстовом представлении, коп.
    property prDaySumAddTaxOfSale6Str: string read GetDaySumAddTaxOfSale6Str; //Сумма налога с продаж по группе «Е» в текстовом представлении, коп.
    property prDaySumAddTaxOfRefund1: Cardinal read GetDaySumAddTaxOfRefund1; //Сумма налога с выплат по группе «А», коп.
    property prDaySumAddTaxOfRefund2: Cardinal read GetDaySumAddTaxOfRefund2; //Сумма налога с выплат по группе «Б», коп.
    property prDaySumAddTaxOfRefund3: Cardinal read GetDaySumAddTaxOfRefund3; //Сумма налога с выплат по группе «В», коп.
    property prDaySumAddTaxOfRefund4: Cardinal read GetDaySumAddTaxOfRefund4; //Сумма налога с выплат по группе «Г», коп.
    property prDaySumAddTaxOfRefund5: Cardinal read GetDaySumAddTaxOfRefund5; //Сумма налога с выплат по группе «Д», коп.
    property prDaySumAddTaxOfRefund6: Cardinal read GetDaySumAddTaxOfRefund6; //Сумма налога с выплат по группе «Е», коп.
    property prDaySumAddTaxOfRefund1Str: string read GetDaySumAddTaxOfRefund1Str; //Сумма налога с выплат по группе «А» в текстовом представлении, коп.
    property prDaySumAddTaxOfRefund2Str: string read GetDaySumAddTaxOfRefund2Str; //Сумма налога с выплат по группе «Б» в текстовом представлении, коп.
    property prDaySumAddTaxOfRefund3Str: string read GetDaySumAddTaxOfRefund3Str; //Сумма налога с выплат по группе «В» в текстовом представлении, коп.
    property prDaySumAddTaxOfRefund4Str: string read GetDaySumAddTaxOfRefund4Str; //Сумма налога с выплат по группе «Г» в текстовом представлении, коп.
    property prDaySumAddTaxOfRefund5Str: string read GetDaySumAddTaxOfRefund5Str; //Сумма налога с выплат по группе «Д» в текстовом представлении, коп.
    property prDaySumAddTaxOfRefund6Str: string read GetDaySumAddTaxOfRefund6Str; //Сумма налога с выплат по группе «Е» в текстовом представлении, коп.
    property prSerialNumber: string read GetSerialNumber; //Строка серийного номера ФР.
    property prFiscalNumber: string read GetFiscalNumber; //Строка присвоенного фискального номера ФР.
    property prTaxNumber: string read GetTaxNumber; //Строка налогового или идентификационного номера плательщика налогов.
    property prDateFiscalization: TDateTime read GetDateFiscalization; //Дата регистрации ФР, составляющая времени не учитывается
    property prDateFiscalizationStr: string read GetDateFiscalizationStr; //Дата регистрации ФР, в текстовом представлении с разделителями даты.
    property prTimeFiscalization: TDateTime read GetTimeFiscalization; //Время регистрации ФР, составляющая даты не учитывается.
    property prTimeFiscalizationStr: string read GetTimeFiscalizationStr; //Время регистрации ФР, в текстовом представлении с разделителями времени.
    property prHardwareVersion: string read GetHardwareVersion; //Идентификатор версии внутреннего программного обеспечения ФР.
    property prHeadLine1: string read GetHeadLine1; //Текст 1-й строки заголовка
    property prHeadLine2: string read GetHeadLine2; //Текст 1-й строки заголовка
    property prHeadLine3: string read GetHeadLine3; //Текст 1-й строки заголовка
    property stUseAdditionalFee: boolean read GetUseAdditionalFee; //Признак использования дополнительных сборов: false - не используются; true - используются
    property stUseAdditionalTax: boolean read GetUseAdditionalTax; //Типа налогообложения: false - вложенный; true - наложенный.
    property stUseCutter: boolean read GetUseCutter; //Признак состояния обрезчика: false - выключен; true - включен
    property stUseFontB: boolean read GetUseFontB; //Признак шрифта: false - шрифт «А» (12x24); true - шрифт «Б» (9x24).
    property stUseTradeLogo: boolean read GetUseTradeLogo; //Признак печати логотипа: false - не печатается; true - печатается.
    property stCashDrawerIsOpened: boolean read GetCashDrawerIsOpened; //Признак состояния ящика: false - закрыт; true - открыт
    property stFailureLastCommand: boolean read GetFailureLastCommand; //Признак завершения команды: false - нормально; true - аварийно
    property stFiscalDayIsOpened: boolean read GetFiscalDayIsOpened; //Признак состояния смены: false - закрыта; true - открыта.
    property stReceiptIsOpened: boolean read GetReceiptIsOpened; //Признак состояния чека: false - закрыт; true - открыт.
    property stFiscalMode: boolean read GetFiscalMode; //Признак режима работы: false - не фискальный; true - фискальный
    property stOnlinePrintMode: boolean read GetOnlinePrintMode; //Признак режима печати чеков: false - оффлайн; true - онлайн.
    property stPaymentMode: boolean read GetPaymentMode; //Признак режима оплат: false - режим регистраций; true - режим оплат
    property stDisplayShowSumMode: boolean read GetDisplayShowSumMode; //Признак режима вывода сумм на дисплей покупателя: false - пользовательский; true - автономный
    property stRefundReceiptMode: boolean read GetRefundReceiptMode; //Признак типа чека: false - чек продажи; true - чек выплаты.
    property stServiceReceiptMode: boolean read GetServiceReceiptMode; //Признак служебного отчёта: false - закрыт; true - открыт
    property prUserPassword: byte read GetUserPassword; //Числовой пароль пользователя от 0 до 65535. По умолчанию = 0.
    property prUserPasswordStr: string read GetUserPasswordStr; //Числовой пароль пользователя от 0 до 65535 в виде строки. По умолчанию = 0.
    property prFPDriverMajorVersion: byte read GetFPDriverMajorVersion; //Индекс версии
    property prFPDriverMinorVersion: byte read GetFPDriverMinorVersion; //Индекс подверсии
    property prFPDriverReleaseVersion: byte read GetFPDriverReleaseVersion; //Индекс релиза
    property prFPDriverBuildVersion: byte read GetFPDriverBuildVersion; //Индекс сборки
    property prKsefSavePath: string read GetKsefSavePath write SetKsefSavePath; //Общий путь для сохранения вычитанных пакетов из модема. По умолчанию путь не задан и сохраняется в каталоге с драйвером.
    property glPropertiesModemAutoUpdateMode: boolean read GetPropertiesModemAutoUpdateMode write SetPropertiesModemAutoUpdateMode; //true – режим скрытого вызова методов при обновлении значений связанных с методом свойств. По умолчанию – false
    property glModemCodepageOEM: boolean read GetModemCodepageOEM write SetModemCodepageOEM; //true – строки в OEM кодировке. По умолчанию – false.
    property glModemLangID: byte read GetModemLangID write SetModemLangID; //Язык текста ошибок: 0 – английский; 1 – русский; 2 – украинский. По умолчанию – 1.
    property prModemRepeatCount: byte read GetModemRepeatCount write SetModemRepeatCount; //Количество повторов команды при отсутствии ответа или ошибке в ответе от модема. По умолчанию – 2.
    property prModemLogRecording: boolean read GetModemLogRecording write SetModemLogRecording; //Признак включения функции записи трафика коммуникационного порта. По умолчанию – false
    property prModemAnswerWaiting: byte read GetModemAnswerWaiting write SetModemAnswerWaiting; //Множитель таймаута ожидания ответа от модема. Каждая 1 = таймаут 300 мс задержки. По умолчанию – 10 (3000 мс).
    property prModemKsefSavePath: string read GetModemKsefSavePath write SetModemKsefSavePath; //Общий путь для сохранения вычитанных пакетов из модема. По умолчанию путь не задан и сохраняется в каталоге с драйвером.
    property prGetModemErrorCode: byte read GetModemErrorCode; //Код ошибки модема
    property prGetModemErrorText: string read GetModemErrorText; //Текстовое описание ошибки
    property stModemWorkSecondCount: Longint read GetModemWorkSecondCount; //Время в секундах с момента включения ФР.
    property stFPExchangeModemSecondCount: Longint read GetFPExchangeModemSecondCount; //Время завершения последнего обмена с ФР в секундах (с момента включения ФР). 2147483647 – неизвестно
    property stModemFirstUnsendPIDDateTime: TDateTime read GetModemFirstUnsendPIDDateTime; //Дата/время первого не переданного эквайеру пакета (по часам ФР). 07.02.2136 6:28:15 – нет ожидающих передачи пакетов
    property stModemFirstUnsendPIDDateTimeStr: string read GetModemFirstUnsendPIDDateTimeStr; //Дата/время первого не переданного эквайеру пакета (по часам ФР) в текстовом представлении. 07.02.2136 6:28:15» – нет ожидающих передачи пакетов
    property stModemPID_Unused: Longint read GetModemPID_Unused; //Номер первого свободного пакета. 2147483647 – SD-карта не инициализирована.
    property stModemPID_CurPers: Longint read GetModemPID_CurPers; //Номер пакета текущей персонализации. 2147483647 – модем ни разу не персонализирован.
    property stModemPID_LastWrite: Longint read GetModemPID_LastWrite; //Номер последнего считанного из ФР и сохранённого на SD-карте пакета. 2147483647 – нет ни одного сохранённого пакета на SD-карте.
    property stModemPID_LastSign: Longint read GetModemPID_LastSign; //Номер последнего подписанного пакета модулем безопасности. 2147483647 – нет ни одного подписанного пакета.
    property stModemPID_LastSend: Longint read GetModemPID_LastSend; //Номер последнего переданного эквайеру пакета. 2147483647 – нет ни одного переданного пакета.
    property stModemSerialNumber: Longint read GetModemSerialNumber; //Серийный номер модема
    property stModemID_DEV: Longint read GetModemID_DEV; //Идентификатор модема
    property stModemID_SAM: Longint read GetModemID_SAM; //Идентификатор модуля безопасности
    property stModemNT_SESSION: Longint read GetModemNT_SESSION; //Счётчик сеансов связи с эквайером.
    property stModemFailCode: byte read GetModemFailCode; //Код ошибки модема:
                                                          //0 – нет ошибок;
                                                          //1– ошибка инициализации драйвера ФР;
                                                          //2 – параметры ФР изменились во время работы модема;
                                                          //3 – нарушена синхронизация в нумерации пакетов между ФР и модемом;
                                                          //4 – данные чека или Z-отчёта, считанные из ФР, некорректны;
                                                          //32 – ошибка инициализации КСЕФ (SD-карта);
                                                          //33 – КСЕФ повреждена;
                                                          //34 – ошибка создания пакета КСЕФ;
                                                          //35 – ошибка записи пакета КСЕФ;
                                                          //36 – переполнение КСЕФ;
                                                          //64 – ошибка инициализации модуля безопасности;
                                                          //65 – ошибка взаимодействия с модулем безопасности;
                                                          //66 – модуль безопасности заменен;
                                                          //96 – эквайер отказался регистрировать ID_DEV+ID_SAM при выполнении технологической сессии.
    property stModemRes1: byte read GetModemRes1; //Не используется.
    property stModemBatVoltage: Longint read GetModemBatVoltage; //Не используется.
    property stModemDCVoltage: Longint read GetModemDCVoltage; //Не используется.
    property stModemBatCurrent: Longint read GetModemBatCurrent; //Не используется.
    property stModemTemperature: Longint read GetModemTemperature; //Не используется.
    property stModemState1: byte read GetModemState1; //Не используется.
    property stModemState2: byte read GetModemState2; //Не используется.
    property stModemState3: byte read GetModemState3; //Стадия IP – соединения:
                                                  //0 – Initial;
                                                  //1 – Starting;
                                                  //2 – Closed;
                                                  //3 – Stopped;
                                                  //4 – Closing;
                                                  //5 – Stopping;
                                                  //6 – ReqSent;
                                                  //7 – AckRcvd;
                                                  //8 – AcqSent;
                                                  //9 – Opened (соединение установлено)
    property stModemLanState1: byte read GetModemLanState1; //Состояние Ethernet TP PHYS Layer:
                                                            //0 – LMS_NONE;
                                                            //1 – LMS_POR_WAIT;
                                                            //2 – LMS_RESET;
                                                            //3 – LMS_RESET_WAIT;
                                                            //4 – LMS_PHL_ON;
                                                            //5 – LMS_PHL_ON_WAIT;
                                                            //6 – LMS_PHL_ON_WAIT1;
                                                            //7 – LMS_PHL_ON_WAIT2;
                                                            //8 – LMS_PHL_ON_WAIT3;
                                                            //9 – LMS_MAIN (Активен).
    property stModemLanState2: byte read GetModemLanState2; //Состояние DHCP:
                                                            //0 – DHCP_NONE;
                                                            //1 – DHCP_START;
                                                            //2 – DHCP_SEND_DISCOVER;
                                                            //131 – DHCP_WAIT_OFFER;
                                                            //4 – DHCP_SEND_REQUEST;
                                                            //133 – DHCP_WAIT_ACK;
                                                            //6 – DHCP_CHECK_LEASTIME (сконфигурирован успешно)
    property stModemFPExchangeResult: byte read GetModemFPExchangeResult; //Результат сеанса связи с ФР:
                                                                          //0 – нет ошибок;
                                                                          //1 – общая ошибка;
                                                                          //2 – ошибка старта сеанса связи;
                                                                          //3 – ошибка получения данных персонализации;
                                                                          //4 – ошибка чтения служебной информации КСЕФ;
                                                                          //5 – ошибка записи пакета КСЕФ;
                                                                          //6 – ошибка создания пакета КСЕФ;
                                                                          //7 – ошибка чтения пакета КСЕФ;
                                                                          //8 – ФР не в фискальном режиме.
                                                                          //251 – ошибка связи с ФР на транспортном уровне;
                                                                          //252 – ФР занят;
                                                                          //253 – конфликт пакетов на транспортном уровне;
                                                                          //254 – таймаут связи с ФР;
                                                                          //255 – общая ошибка обмена с ФР.
    property stModemACQExchangeResult: byte read GetModemACQExchangeResult; //Результат сеанса связи с эквайером:
                                                                            //0 – нет ошибок;
                                                                            //1 – общая ошибка;
                                                                            //2 – таймаут сеанса связи;
                                                                            //3 – ошибка чтения служебной информации КСЕФ;
                                                                            //4 – ошибка чтения пакета КСЕФ;
                                                                            //5 – ошибка записи пакета КСЕФ;
                                                                            //6 – некорректная длина документа ДПС;
                                                                            //7 – некорректный тип вложенной телеграммы ДПС;
                                                                            //8 – ошибка при проверке MAC;
                                                                            //9 – модуль безопасности снят;
                                                                            //240 – ошибка установления соединения с эквайером;
                                                                            //241 – эквайер отверг соединение с данным ID_DEV;
                                                                            //242 – внутренняя ошибка модема;
                                                                            //243 – таймаут ожидания ответа от эквайера;
                                                                            //244 – эквайер неожиданно закрыл TCP-соединение;
                                                                            //245 – неверный формат ответа эквайера;
                                                                            //246 – превышено максимальное количество попыток повтора передачи телеграммы;
                                                                            //247 – эквайер неожиданно закрыл сессию.
    property stModemRes2: byte read GetModemRes2; //Не используется.
    property stModemFPExchangeErrorCount: Longint read GetModemFPExchangeErrorCount; //Количество неудачных сеансов связи с ФР с момента последнего удачного сеанса.
    property stModemRSSI: byte read GetModemRSSI; //Не используется.
    property stModemRSSI_BER: byte read GetModemRSSI_BER; //Не используется.
    property stModemUSSDResult: string read GetModemUSSDResult; //Не используется.
    property stModemOSVer: Longint read GetModemOSVer; //Версия ОС.
    property stModemOSRev: Longint read GetModemOSRev; //Ревизия ОС.
    property stModemSysTime: TDateTime read GetModemSysTime; //Системные дата и время.
    property stModemSysTimeStr: string read GetModemSysTimeStr; //Системные дата и время в текстовом представлении
    property stModemNETIPAddr: string read GetModemNETIPAddr; //IP – адрес сетевого интерфейса.
    property stModemNETGate: string read GetModemNETGate; //IP – адрес шлюза для сетевого интерфейса.
    property stModemNETMask: string read GetModemNETMask; //Маска сети для сетевого интерфейса
    property stModemMODIPAddr: string read GetModemMODIPAddr; //Не используется.
    property stModemACQIPAddr: string read GetModemACQIPAddr; //IP – адрес эквайера.
    property stModemACQPort: Longint read GetModemACQPort; //Порт эквайера.
    property stModemACQExchangeSecondCount: Longint read GetModemACQExchangeSecondCount; //Время завершения последнего сеанса связи с эквайером в секундах от момента включения ФР.
    property prModemFoundPacket: Cardinal read GetModemFoundPacket; //Номер найденного пакета.
    property prModemFoundPacketStr: string read GetModemFoundPacketStr; //Номер найденного пакета в текстовом представлении
    property prModemCurrentTaskCode: byte read GetModemCurrentTaskCode; //Код текущей задачи модема.
                                                                        //0 – нет задачи
                                                                        //1 – сессия технологической регистрации
                                                                        //2 – персонализация
                                                                        //3 – считывание данных КСЕФ
                                                                        //4 – обмен с эквайером
                                                                        //5 – подписывание пакета КСЕФ
                                                                        //255 – блокировка
    property prModemCurrentTaskText: string read GetModemCurrentTaskText; //Текстовое описание задачи.
    property prModemDriverMajorVersion: Byte read GetModemDriverMajorVersion; //Индекс версии
    property prModemDriverMinorVersion: byte read GetModemDriverMinorVersion; //Индекс подверсии
    property prModemDriverReleaseVersion: byte read GetModemDriverReleaseVersion; //Индекс релиза
    property prModemDriverBuildVersion: byte read GetModemDriverBuildVersion; //Индекс сборки

//    property  read ;
//    property  read  write ;
  end;

var
  ics: OleVariant;
  mdm: OleVariant;

implementation

uses ComObj;

{ TIKC_E810T }

function TIKC_E810T.FPInitialize: Longint;
begin
  ics:=CreateOleObject('NeoFiscalPrinterDriver.ICS_EP_09');
  Result:=ics.FPInitialize;
end;

function TIKC_E810T.FPOpen(_COMport: string;
                    baudRate: integer = 9600;
                    readTimeout: string = '3';
                    writeTimeout: string = '3'): boolean;
begin
  Result:=ics.FPOpen(_COMport, baudRate, readTimeout, writeTimeout);
end;

function TIKC_E810T.FPOpenStr(_COMport: string; baudRate: integer;
  readTimeout, writeTimeout: string): boolean;
begin
  Result:=ics.FPOpenStr(_COMport, baudRate, readTimeout, writeTimeout);
end;

function TIKC_E810T.FPClose: boolean;
begin
  Result:=ics.FPClose;
end;

function TIKC_E810T.FPSetPassword(userID: byte; oldPassword,
  newPassword: word): boolean;
begin
  Result:=ics.FPSetPassword(userID,oldPassword,newPassword);
end;

function TIKC_E810T.FPRegisterCashier(cashierID: byte; name: string;
  password: word): boolean;
begin
  Result:=ics.FPRegisterCashier(cashierID, name, password);
end;

function TIKC_E810T.FPRefundItem(qty: integer; qtyPrecision: byte;
  printEAN13, printSingleQty, printFromMemory: boolean; itemPrice: integer;
  itemTax: byte; itemName: string; itemCode: Integer): boolean;
begin
  Result:=ics.FPRefundItem(qty, qtyPrecision, printEAN13, printSingleQty, printFromMemory, itemPrice, itemTax, itemName, itemCode);
end;

function TIKC_E810T.FPRefundItemStr(qty: integer; qtyPrecision: byte;
  printEAN13, printSingleQty, printFromMemory: boolean; itemPrice: integer;
  itemTax: byte; itemName: string; itemCode: string): boolean;
begin
  Result:=ics.FPRefundItemStr(qty, qtyPrecision, printEAN13, printSingleQty, printFromMemory, itemPrice, itemTax, itemName, itemCode);
end;

function TIKC_E810T.FPSaleItem(qty: integer;
                        qtyPrecision: byte;
                        printEAN13: boolean;
                        printSingleQty: boolean;
                        printFromMemory: boolean;
                        itemPrice: integer;
                        itemTax: byte;
                        itemName: string;
                        itemCode: Longint): boolean;
begin
  Result:=ics.FPSaleItem(qty, qtyPrecision, printEAN13, printSingleQty, printFromMemory, itemPrice, itemTax, itemName, itemCode);
end;

function TIKC_E810T.FPSaleItemStr(qty: integer; qtyPrecision: byte;
  printEAN13, printSingleQty, printFromMemory: boolean; itemPrice: integer;
  itemTax: byte; itemName, itemCode: string): boolean;
begin
  Result:=ics.FPSaleItemStr(qty, qtyPrecision, printEAN13, printSingleQty, printFromMemory, itemPrice, itemTax, itemName, itemCode);
end;

function TIKC_E810T.FPCommentLine(commentLine: string;
                                  openRefundReceipt: boolean=false): boolean;
begin
  Result:=ics.FPCommentLine(commentLine, openRefundReceipt);
end;

function TIKC_E810T.FPPrintZeroReceipt: boolean;
begin
  Result:=ics.FPPrintZeroReceipt;
end;

function TIKC_E810T.FPLineFeed: boolean;
begin
  Result:=ics.FPLineFeed;
end;

function TIKC_E810T.FPAnnulReceipt: boolean;
begin
  Result:=ics.FPAnnulReceipt;
end;

function TIKC_E810T.FPCashIn(cashSum: Cardinal): boolean;
begin
  Result:=ics.FPCashIn(cashSum);
end;

function TIKC_E810T.FPCashOut(cashSum: Cardinal): boolean;
begin
  Result:=ics.FPCashOut(cashSum);
end;

function TIKC_E810T.FPPayment(paymentForm: byte; paymentSum: integer;
  autoCloseReceipt, asFiscalReceipt: boolean; authCode: string): boolean;
begin
  Result:=ics.FPPayment(paymentForm, paymentSum, autoCloseReceipt, asFiscalReceipt, authCode);
end;

function TIKC_E810T.FPSetAdvHeaderLine(lineID: byte; textLine: string;
  isDoubleWidth, isDoubleHeight: boolean): boolean;
begin
  Result:=ics.FPSetAdvHeaderLine(lineID, textLine, isDoubleWidth, isDoubleHeight);
end;

function TIKC_E810T.FPSetAdvTrailerLine(lineID: byte;
                                        textLine: string;
                                        isDoubleWidth: boolean = false;
                                        isDoubleHeight: boolean = false): boolean;
begin
  Result:=ics.FPSetAdvTrailerLine(lineID, textLine, isDoubleWidth, isDoubleHeight);
end;

function TIKC_E810T.FPSetLineCustomerDisplay(lineID: byte;
  textLine: string): boolean;
begin
  Result:=ics.FPSetLineCustomerDisplay(lineID, textLine);
end;

function TIKC_E810T.FPSetCurrentDate(currentDate: TDateTime): boolean;
begin
  Result:=ics.FPSetCurrentDate(currentDate);
end;

function TIKC_E810T.FPSetCurrentDateStr(currentDateStr: string): boolean;
begin
  Result:=ics.FPSetCurrentDateStr(currentDateStr);
end;

function TIKC_E810T.FPGetCurrentDate: boolean;
begin
  Result:=ics.FPGetCurrentDate;
end;

function TIKC_E810T.FPSetCurrentTime(currentTime: TDateTime): boolean;
begin
  Result:=ics.FPSetCurrentTime(currentTime);
end;

function TIKC_E810T.FPSetCurrentTimeStr(currentTimeStr: string): boolean;
begin
  Result:=ics.FPSetCurrentTimeStr(currentTimeStr);
end;

function TIKC_E810T.FPGetCurrentTime: boolean;
begin
  Result:=ics.FPGetCurrentTime;
end;

function TIKC_E810T.FPOpenCashDrawer(duration: integer): boolean;
begin
  Result:=ics.FPOpenCashDrawer(duration);
end;

function TIKC_E810T.FPPrintHardwareVersion: boolean;
begin
  Result:=ics.FPPrintHardwareVersion;
end;

function TIKC_E810T.FPPrintLastKsefPacket: boolean;
begin
  Result:=ics.FPPrintLastKsefPacket;
end;

function TIKC_E810T.FPPrintKsefPacket(packetID: Cardinal): boolean;
begin
  Result:=ics.FPPrintKsefPacket(packetID);
end;

function TIKC_E810T.FPMakeDiscount(isPercentType, isForItem: boolean;
  value: Integer; textLine: string): boolean;
begin
  Result:=ics.FPMakeDiscount(isPercentType, isForItem, value, textLine);
end;

function TIKC_E810T.FPMakeMarkUp(isPercentType, isForItem: boolean;
  value: integer; textLine: string): boolean;
begin
  Result:=ics.FPMakeMarkUp(isPercentType, isForItem, value, textLine);
end;

function TIKC_E810T.FPOnlineSwitch: boolean;
begin
  Result:=ics.FPOnlineSwitch;
end;

function TIKC_E810T.FPCustomerDisplayModeSwitch: boolean;
begin
  Result:=ics.FPCustomerDisplayModeSwitch;
end;

function TIKC_E810T.FPChangeBaudRate(baudRateIndex: byte): boolean;
begin
  Result:=ics.FPChangeBaudRate;
end;

function TIKC_E810T.FPPrintServiceReportByLine(textLine: string): boolean;
begin
  Result:=ics.FPPrintServiceReportByLine;
end;

function TIKC_E810T.FPPrintServiceReportMultiLine(
  multiLineText: string): boolean;
begin
  Result:=ics.FPPrintServiceReportMultiLine(multiLineText);
end;

function TIKC_E810T.FPCloseServiceReport: boolean;
begin
  Result:=ics.FPCloseServiceReport;
end;

function TIKC_E810T.FPDisableLogo(progPassword: Word): boolean;
begin
  Result:=ics.FPDisableLogo(progPassword);
end;

function TIKC_E810T.FPEnableLogo(progPassword: Word): boolean;
begin
  Result:=ics.FPEnableLogo(progPassword);
end;

function TIKC_E810T.FPSetTaxRates(progPassword: Word): boolean;
begin
  Result:=ics.FPSetTaxRates(progPassword);
end;

function TIKC_E810T.FPGetTaxRates: boolean;
begin
  Result:=ics.FPGetTaxRates;
end;

function TIKC_E810T.FPProgItem(progPassword, qtyPrecision: byte;
  isRefundItem: boolean; itemPrice: integer; itemTax: byte;
  itemName: string; itemCode: Integer): boolean;
begin
  Result:=ics.FPProgItem(progPassword, qtyPrecision, isRefundItem, itemPrice, itemTax, itemName, itemCode);
end;

function TIKC_E810T.FPProgItemStr(progPassword, qtyPrecision: byte;
  isRefundItem: boolean; itemPrice: integer; itemTax: byte; itemName,
  itemCodeStr: string): boolean;
begin
  Result:=ics.FPProgItemStr(progPassword, qtyPrecision, isRefundItem, itemPrice, itemTax, itemName, itemCodeStr);
end;

function TIKC_E810T.FPMakeXReport(reportPassword: Word): boolean;
begin
  Result:=ics.FPMakeXReport(reportPassword);
end;

function TIKC_E810T.FPMakeZReport(reportPassword: Word): boolean;
begin
  Result:=ics.FPMakeZReport(reportPassword);
end;

function TIKC_E810T.FPMakeReportOnItems(reportPassword: byte;
  firstItemCode, lastItemCode: Integer): boolean;
begin
  Result:=ics.FPMakeReportOnItems(reportPassword, firstItemCode, lastItemCode);
end;

function TIKC_E810T.FPMakeReportOnItemsStr(reportPassword: byte;
  firstItemCodeStr, lastItemCodeStr: string): boolean;
begin
  Result:=ics.FPMakeReportOnItemsStr(reportPassword, firstItemCodeStr, lastItemCodeStr);
end;

function TIKC_E810T.FPMakePeriodicReportOnDate(reportPassword: byte;
  firstDate, lastDate: TDateTime): boolean;
begin
  Result:=ics.FPMakePeriodicReportOnDate(reportPassword, firstDate, lastDate);
end;

function TIKC_E810T.FPMakePeriodicReportOnDateStr(reportPassword: byte;
  firstDateStr, lastDateStr: string): boolean;
begin
  Result:=ics.FPMakePeriodicReportOnDateStr(reportPassword, firstDateStr, lastDateStr);
end;

function TIKC_E810T.FPMakePeriodicShortReportOnDate(reportPassword: byte;
  firstDate, lastDate: TDateTime): boolean;
begin
  Result:=ics.FPMakePeriodicShortReportOnDate(reportPassword, firstDate, lastDate);
end;

function TIKC_E810T.FPMakePeriodicShortReportOnDateStr(
  reportPassword: byte; firstDateStr, lastDateStr: string): boolean;
begin
  Result:=ics.FPMakePeriodicShortReportOnDateStr(reportPassword, firstDateStr, lastDateStr);
end;

function TIKC_E810T.FPMakePeriodicReportOnNumber(reportPassword,
  firstNumber, lastNumber: Word): boolean;
begin
  Result:=ics.FPMakePeriodicReportOnNumber(reportPassword, firstNumber, lastNumber);
end;

function TIKC_E810T.FPCutterModeSwitch: boolean;
begin
  Result:=ics.FPCutterModeSwitch;
end;

function TIKC_E810T.FPPrintBarcodeOnReceipt(
  serialCode128B: string): boolean;
begin
  Result:=ics.FPPrintBarcodeOnReceipt(serialCode128B);
end;

function TIKC_E810T.FPPrintBarcodeOnItem(serialEAN13: string): boolean;
begin
  Result:=ics.FPPrintBarcodeOnItem(serialEAN13);
end;

function TIKC_E810T.FPGetPaymentFormNames: boolean;
begin
  Result:=ics.FPGetPaymentFormNames;
end;

function TIKC_E810T.FPGetCashDrawerSum: boolean;
begin
  Result:=ics.FPGetCashDrawerSum;
end;

function TIKC_E810T.FPGetDayReportProperties: boolean;
begin
  Result:=ics.FPGetDayReportProperties;
end;

function TIKC_E810T.FPGetItemData(itemCode: Integer): boolean;
begin
  Result:=ics.FPGetItemData(itemCode);
end;

function TIKC_E810T.FPGetItemDataStr(itemCodeStr: string): boolean;
begin
  Result:=ics.FPGetItemDataStr(itemCodeStr);
end;

function TIKC_E810T.FPGetDayReportData: boolean;
begin
  Result:=ics.FPGetDayReportData;
end;

function TIKC_E810T.FPGetCurrentReceiptData: boolean;
begin
  Result:=ics.FPGetCurrentReceiptData;
end;

function TIKC_E810T.FPGetDayCorrectionsData: boolean;
begin
  Result:=ics.FPGetDayCorrectionsData;
end;

function TIKC_E810T.FPGetDaySumOfAddTaxes: boolean;
begin
  Result:=ics.FPGetDaySumOfAddTaxes;
end;

function TIKC_E810T.FPGetCurrentStatus: boolean;
begin
  Result:=ics.FPGetCurrentStatus;
end;

function TIKC_E810T.FPPrintKsefRange(firstPacketID,
  lastPacketID: Cardinal): boolean;
begin
  Result:=ics.FPPrintKsefRange(firstPacketID, lastPacketID);
end;

function TIKC_E810T.FPPaymentByCard(paymentForm: byte; paymentSum: Word;
  autoCloseReceipt, asFiscalReceipt: boolean; cardInfo,
  authCode: String): boolean;
begin
  Result:=ics.FPPaymentByCard(paymentForm, paymentSum, autoCloseReceipt, asFiscalReceipt, cardInfo, authCode);
end;

function TIKC_E810T.FPPrintModemStatus: boolean;
begin
  Result:=ics.FPPrintModemStatus;
end;

function TIKC_E810T.FPGetUserPassword(userID: byte): boolean;
begin
  Result:=ics.FPGetUserPassword(userID);
end;

function TIKC_E810T.FPPrintBarcodeOnReceiptNew(
  serialCode128C: string): boolean;
begin
  Result:=ics.FPPrintBarcodeOnReceiptNew(serialCode128C);
end;

function TIKC_E810T.FPPrintBarcodeOnServiceReport(
  serialCode128B: string): boolean;
begin
  Result:=ics.FPPrintBarcodeOnServiceReport(serialCode128B);
end;

function TIKC_E810T.FPPrintQRCode(serialQR: string): boolean;
begin
  Result:=ics.FPPrintQRCode(serialQR);
end;

function TIKC_E810T.FPClaimUSBDevice: boolean;
begin
  Result:=ics.FPClaimUSBDevice;
end;

function TIKC_E810T.FPReleaseUSBDevice: boolean;
begin
  Result:=ics.FPReleaseUSBDevice;
end;

function TIKC_E810T.ModemInitialize(_COMportStr: byte): integer;
begin
  mdm:=CreateOleObject('NeoFiscalPrinterDriver.ICS_Modem');
  Result:=mdm.ModemInitialize(_COMportStr);
end;                                              

function TIKC_E810T.ModemAckuirerConnect: boolean;
begin
  Result:=mdm.ModemAckuirerConnect;
end;

function TIKC_E810T.ModemAckuirerUnconditionalConnect: boolean;
begin
  Result:=mdm.ModemAckuirerUnconditionalConnect;
end;

function TIKC_E810T.ModemUpdateStatus: boolean;
begin
  Result:=mdm.ModemUpdateStatus;
end;

function TIKC_E810T.ModemVerifyPacket(packetID: Cardinal): boolean;
begin
  Result:=mdm.ModemVerifyPacket(packetID);
end;

function TIKC_E810T.ModemFindPacket(zReport, receiptNumber: integer;
  receiptType: byte): boolean;
begin
  Result:=mdm.ModemFindPacket(zReport, receiptNumber, receiptType);
end;

function TIKC_E810T.ModemKsefPacket(packetID: Cardinal): boolean;
begin
  Result:=mdm.ModemKsefPacket(packetID);
end;

function TIKC_E810T.ModemReadKsefRange(firstPacketID,
  lastPacketID: Cardinal): boolean;
begin
  Result:=mdm.ModemReadKsefRange(firstPacketID, lastPacketID);
end;

function TIKC_E810T.ModemReadKsefByZReport(zReport: Integer): boolean;
begin
  Result:=mdm.ModemReadKsefByZReport(zReport);
end;

function TIKC_E810T.ModemGetCurrentTask: boolean;
begin
  Result:=mdm.ModemGetCurrentTask;
end;

function TIKC_E810T.ModemFindPacketByDateTime(findDateTime: TDateTime;
  findForward: boolean): boolean;
begin
  Result:=mdm.ModemFindPacketByDateTime(findDateTime, findForward);
end;

function TIKC_E810T.ModemFindPacketByDateTimeStr(findDateTimeStr: string;
  findForward: boolean): boolean;
begin
  Result:=mdm.ModemFindPacketByDateTimeStr(findDateTimeStr, findForward);
end;

function TIKC_E810T.ModemSaveKsefRangeToBin(directory, fileName: string;
  firstPacketID, lastPacketID: Cardinal): boolean;
begin
  Result:=mdm.ModemSaveKsefRangeToBin(directory, fileName, firstPacketID, lastPacketID);
end;

function TIKC_E810T.ModemSaveKsefByZReportTobin(directory,
  fileName: string; zReport: integer): boolean;
begin
  Result:=mdm.ModemSaveKsefByZReportTobin(directory, fileName, zReport);
end;

function TIKC_E810T.GetAnswerWaiting: byte;
begin
  Result:=ics.prAnswerWaiting;
end;

function TIKC_E810T.GetCodepageOEM: boolean;
begin
  Result:=ics.glCodepageOEM;
end;

function TIKC_E810T.GetErrorText: string;
begin
  Result:=ics.prGetErrorText;
end;

function TIKC_E810T.GetLangID: byte;
begin
  Result:=ics.glLangID; 
end;

function TIKC_E810T.GetLogRecording: boolean;
begin
  Result:=ics.prLogRecording;
end;

function TIKC_E810T.GetPrinterError: boolean;
begin
  Result:=ics.prPrinterError;
end;

function TIKC_E810T.GetPropertiesAutoUpdateMod: boolean;
begin
  Result:=ics.glPropertiesAutoUpdateMode;
end;

function TIKC_E810T.GetRepeatCount: byte;
begin
  Result:=ics.prRepeatCount;
end;

function TIKC_E810T.GetReserveByte: byte;
begin
  Result:=ics.prGetReserveByte;
end;

function TIKC_E810T.GetResultByte: byte;
begin
  Result:=ics.prGetResultByte;
end;

function TIKC_E810T.GetStatusByte: byte;
begin
  Result:=ics.prGetStatusByte;
end;

function TIKC_E810T.GetTapeAnalizer: boolean;
begin
  Result:=ics.glTapeAnalizer;
end;

function TIKC_E810T.GetTapeEnded: boolean;
begin
  Result:=ics.prTapeEnded;
end;

function TIKC_E810T.GetTapeNearEnd: boolean;
begin
  Result:=ics.prTapeNearEnd;
end;

function TIKC_E810T.GetUseVirtualPort: boolean;
begin
  Result:=ics.glUseVirtualPort;
end;

function TIKC_E810T.GetVirtualPortOpened: boolean;
begin
  Result:=ics.glVirtualPortOpened;
end;

procedure TIKC_E810T.SetAnswerWaiting(AnswerWaiting: byte);
begin
  ics.prAnswerWaiting:=AnswerWaiting;
end;

procedure TIKC_E810T.SetCodepageOEM(CodepageOEM: boolean);
begin
  ics.glCodepageOEM:=CodepageOEM;
end;

procedure TIKC_E810T.SetLangID(LangID: byte);
begin
  ics.glLangID:=LangID;
end;

procedure TIKC_E810T.SetLogRecording(LogRecording: boolean);
begin
  ics.prLogRecording:=LogRecording;
end;

procedure TIKC_E810T.SetPropertiesAutoUpdateMod(AutoUpdateMode: boolean = false);
begin
  ics.glPropertiesAutoUpdateMode:=AutoUpdateMode;
end;

procedure TIKC_E810T.SetRepeatCount(RepeatCount: byte);
begin
  ics.prRepeatCount:=RepeatCount;
end;

procedure TIKC_E810T.SetTapeAnalizer(TapeAnalizer: boolean = true);
begin
  ics.glTapeAnalizer:=TapeAnalizer;
end;

procedure TIKC_E810T.SetUseVirtualPort(UseVirtualPort: boolean);
begin
  ics.glUseVirtualPort:=UseVirtualPort;
end;

function TIKC_E810T.GetItemCost: Longint;
begin
  Result:=ics.prItemCost;
end;

function TIKC_E810T.GetItemCostStr: string;
begin
  Result:=ics.prItemCostStr;
end;

function TIKC_E810T.GetSumBalance: Longint;
begin
  Result:=ics.prSumBalance;
end;

function TIKC_E810T.GetSumBalanceStr: string;
begin
  Result:=ics.prSumBalanceStr;
end;

function TIKC_E810T.GetSumTotal: Longint;
begin
  Result:=ics.prSumTotal;
end;

function TIKC_E810T.GetSumTotalStr: string;
begin
  Result:=ics.prSumTotalStr;
end;

function TIKC_E810T.GetKSEFPacket: Cardinal;
begin
  Result:=ics.prKSEFPacket;
end;

function TIKC_E810T.GetKSEFPacketStr: string;
begin
  Result:=ics.prKSEFPacketStr;
end;

function TIKC_E810T.GetSumDiscount: Longint;
begin
  Result:=ics.prSumDiscount
end;

function TIKC_E810T.GetSumDiscountStr: string;
begin
  Result:=ics.prSumDiscountStr;
end;

function TIKC_E810T.GetSumMarkup: Longint;
begin
  Result:=ics.prSumMarkup;
end;

function TIKC_E810T.GetSumMarkupStr: string;
begin
  Result:=ics.prSumMarkupStr;
end;

function TIKC_E810T.GetCurrentDate: TDateTime;
begin
  Result:=ics.prCurrentDate;
end;

function TIKC_E810T.GetCurrentDateStr: string;
begin
  Result:=ics.prCurrentDateStr;
end;

function TIKC_E810T.GetCurrentTime: TDateTime;
begin
  Result:=ics.prCurrentTime;
end;

function TIKC_E810T.GetCurrentTimeStr: string;
begin
  Result:=ics.prCurrentTimeStr;
end;

function TIKC_E810T.GetModemError: byte;
begin
  Result:=ics.prModemError;
end;

function TIKC_E810T.GetTaxRatesCount: byte;
begin
  Result:=ics.prTaxRatesCount;
end;

procedure TIKC_E810T.SetTaxRatesCount(TaxRatesCount: byte);
begin
  ics.prTaxRatesCount:=TaxRatesCount;
end;

function TIKC_E810T.GetAddTaxType: boolean;
begin
  Result:=ics.prAddTaxType;
end;

procedure TIKC_E810T.SetAddTaxType(AddTaxType: boolean);
begin
  ics.prAddTaxType:=AddTaxType;
end;

function TIKC_E810T.GetTaxRate1: integer;
begin
  Result:=ics.prTaxRate1;
end;

function TIKC_E810T.GetTaxRate2: integer;
begin
  Result:=ics.prTaxRate2;
end;

function TIKC_E810T.GetTaxRate3: integer;
begin
  Result:=ics.prTaxRate3;
end;

function TIKC_E810T.GetTaxRate4: integer;
begin
  Result:=ics.prTaxRate4;
end;

function TIKC_E810T.GetTaxRate5: integer;
begin
  Result:=ics.prTaxRate5;
end;

function TIKC_E810T.GetTaxRate6: integer;
begin
    Result:=ics.prTaxRate6;
end;

procedure TIKC_E810T.SetTaxRate1(const Value: integer);
begin
    ics.prTaxRate1:=Value;
end;

procedure TIKC_E810T.SetTaxRate2(const Value: integer);
begin
    ics.prTaxRate2:=Value;
end;

procedure TIKC_E810T.SetTaxRate3(const Value: integer);
begin
    ics.prTaxRate3:=Value;
end;

procedure TIKC_E810T.SetTaxRate4(const Value: integer);
begin
    ics.prTaxRate4:=Value;
end;

procedure TIKC_E810T.SetTaxRate5(const Value: integer);
begin
    ics.prTaxRate5:=Value;
end;

function TIKC_E810T.GetUsedAdditionalFee: boolean;
begin
  Result:=ics.prUsedAdditionalFee;
end;

procedure TIKC_E810T.SetUsedAdditionalFee(const Value: boolean);
begin
  ics.prUsedAdditionalFee:=Value;
end;

function TIKC_E810T.GetAddFeeRate1: integer;
begin
  Result:=ics.prAddFeeRate1;
end;

function TIKC_E810T.GetAddFeeRate2: integer;
begin
  Result:=ics.prAddFeeRate2;
end;

function TIKC_E810T.GetAddFeeRate3: integer;
begin
  Result:=ics.prAddFeeRate3;
end;

function TIKC_E810T.GetAddFeeRate4: integer;
begin
  Result:=ics.prAddFeeRate4;
end;

function TIKC_E810T.GetAddFeeRate5: integer;
begin
  Result:=ics.prAddFeeRate5;
end;

function TIKC_E810T.GetAddFeeRate6: integer;
begin
  Result:=ics.prAddFeeRate6;
end;

procedure TIKC_E810T.SetAddFeeRate1(const Value: integer);
begin
  ics.prAddFeeRate1:=value;
end;

procedure TIKC_E810T.SetAddFeeRate2(const Value: integer);
begin
  ics.prAddFeeRate2:=value;
end;

procedure TIKC_E810T.SetAddFeeRate3(const Value: integer);
begin
  ics.prAddFeeRate3:=value;
end;

procedure TIKC_E810T.SetAddFeeRate4(const Value: integer);
begin
  ics.prAddFeeRate4:=value;
end;

procedure TIKC_E810T.SetAddFeeRate5(const Value: integer);
begin
  ics.prAddFeeRate5:=value;
end;

procedure TIKC_E810T.SetAddFeeRate6(const Value: integer);
begin
  ics.prAddFeeRate6:=value;
end;

function TIKC_E810T.GetTaxOnAddFee1: boolean;
begin
  Result:=ics.prTaxOnAddFee1;
end;

function TIKC_E810T.GetTaxOnAddFee2: boolean;
begin
  Result:=ics.prTaxOnAddFee2;
end;

function TIKC_E810T.GetTaxOnAddFee3: boolean;
begin
  Result:=ics.prTaxOnAddFee3;
end;

function TIKC_E810T.GetTaxOnAddFee4: boolean;
begin
  Result:=ics.prTaxOnAddFee4;
end;

function TIKC_E810T.GetTaxOnAddFee5: boolean;
begin
  Result:=ics.prTaxOnAddFee5;
end;

function TIKC_E810T.GetTaxOnAddFee6: boolean;
begin
  Result:=ics.prTaxOnAddFee6;
end;

procedure TIKC_E810T.SetTaxOnAddFee1(const Value: boolean);
begin
  ics.prTaxOnAddFee1:=value;
end;

procedure TIKC_E810T.SetTaxOnAddFee2(const Value: boolean);
begin
  ics.prTaxOnAddFee2:=value;
end;

procedure TIKC_E810T.SetTaxOnAddFee3(const Value: boolean);
begin
  ics.prTaxOnAddFee3:=value;
end;

procedure TIKC_E810T.SetTaxOnAddFee4(const Value: boolean);
begin
  ics.prTaxOnAddFee4:=value;
end;

procedure TIKC_E810T.SetTaxOnAddFee5(const Value: boolean);
begin
  ics.prTaxOnAddFee5:=value;
end;

procedure TIKC_E810T.SetTaxOnAddFee6(const Value: boolean);
begin
  ics.prTaxOnAddFee6:=value;
end;

function TIKC_E810T.GetAddFeeOnRetailPrice1: boolean;
begin
  Result:=ics.prAddFeeOnRetailPrice1;
end;

function TIKC_E810T.GetAddFeeOnRetailPrice2: boolean;
begin
  Result:=ics.prAddFeeOnRetailPrice2;
end;

function TIKC_E810T.GetAddFeeOnRetailPrice3: boolean;
begin
  Result:=ics.prAddFeeOnRetailPrice3;
end;

function TIKC_E810T.GetAddFeeOnRetailPrice4: boolean;
begin
  Result:=ics.prAddFeeOnRetailPrice4;
end;

function TIKC_E810T.GetAddFeeOnRetailPrice5: boolean;
begin
  Result:=ics.prAddFeeOnRetailPrice5;
end;

function TIKC_E810T.GetAddFeeOnRetailPrice6: boolean;
begin
  Result:=ics.prAddFeeOnRetailPrice6;
end;

procedure TIKC_E810T.SetAddFeeOnRetailPrice1(const Value: boolean);
begin
  ics.prAddFeeOnRetailPrice1:=value;
end;

procedure TIKC_E810T.SetAddFeeOnRetailPrice2(const Value: boolean);
begin
  ics.prAddFeeOnRetailPrice2:=value;
end;

procedure TIKC_E810T.SetAddFeeOnRetailPrice3(const Value: boolean);
begin
  ics.prAddFeeOnRetailPrice3:=value;
end;

procedure TIKC_E810T.SetAddFeeOnRetailPrice4(const Value: boolean);
begin
  ics.prAddFeeOnRetailPrice4:=value;
end;

procedure TIKC_E810T.SetAddFeeOnRetailPrice5(const Value: boolean);
begin
  ics.prAddFeeOnRetailPrice5:=value;
end;

procedure TIKC_E810T.SetAddFeeOnRetailPrice6(const Value: boolean);
begin
  ics.prAddFeeOnRetailPrice6:=value;
end;

function TIKC_E810T.GetTaxRatesDate: TDateTime;
begin
  Result:=ics.prTaxRatesDate;
end;

function TIKC_E810T.GetTaxRatesDateStr: string;
begin
  Result:=ics.prTaxRatesDateStr;
end;

function TIKC_E810T.GetNamePaymentForm1: string;
begin
  Result:=ics.GetNamePaymentForm1;
end;

function TIKC_E810T.GetNamePaymentForm10: string;
begin
  Result:=ics.GetNamePaymentForm10;
end;

function TIKC_E810T.GetNamePaymentForm2: string;
begin
  Result:=ics.GetNamePaymentForm2;
end;

function TIKC_E810T.GetNamePaymentForm3: string;
begin
  Result:=ics.GetNamePaymentForm3;
end;

function TIKC_E810T.GetNamePaymentForm4: string;
begin
  Result:=ics.GetNamePaymentForm4;
end;

function TIKC_E810T.GetNamePaymentForm5: string;
begin
  Result:=ics.GetNamePaymentForm5;
end;

function TIKC_E810T.GetNamePaymentForm6: string;
begin
  Result:=ics.GetNamePaymentForm6;
end;

function TIKC_E810T.GetNamePaymentForm7: string;
begin
  Result:=ics.GetNamePaymentForm7;
end;

function TIKC_E810T.GetNamePaymentForm8: string;
begin
  Result:=ics.GetNamePaymentForm8;
end;

function TIKC_E810T.GetNamePaymentForm9: string;
begin
  Result:=ics.GetNamePaymentForm9;
end;

function TIKC_E810T.GetCashDrawerSum: Longint;
begin
  Result:=ics.prCashDrawerSum;
end;

function TIKC_E810T.GetCashDrawerSumStr: string;
begin
  Result:=ics.prCashDrawerSumStr;
end;

function TIKC_E810T.GetCurrentZReport: Integer;
begin
  Result:=ics.prCurrentZReport;
end;

function TIKC_E810T.GetCurrentZReportStr: string;
begin
  Result:=ics.prCurrentZReportStrж
end;

function TIKC_E810T.GetDayEndDate: TDateTime;
begin
  Result:=ics.prDayEndDate;
end;

function TIKC_E810T.GetDayEndDateStr: string;
begin
  Result:=ics.prDayEndDateStr;
end;

function TIKC_E810T.GetDayEndTime: TDateTime;
begin
  Result:=ics.prDayEndTime;
end;

function TIKC_E810T.GetDayEndTimeStr: string;
begin
  Result:=ics.prDayEndTimeStr;
end;

function TIKC_E810T.GetItemsCount: Integer;
begin
  Result:=ics.prItemsCount;
end;

function TIKC_E810T.GetItemsCountStr: string;
begin
  Result:=ics.prItemsCountStr;
end;

function TIKC_E810T.GetLastZReportDate: TDateTime;
begin
  Result:=ics.prLastZReportDate;
end;

function TIKC_E810T.GetLastZReportDateStr: string;
begin
  Result:=ics.prLastZReportDateStr;
end;

function TIKC_E810T.GetItemName: string;
begin
  Result:=ics.prItemName;
end;

function TIKC_E810T.GetItemPrice: integer;
begin
  Result:=ics.prItemPrice;
end;

function TIKC_E810T.GetItemRefundQtyPrecision: byte;
begin
  Result:=ics.prItemRefundQtyPrecision;
end;

function TIKC_E810T.GetItemRefundQuantity: integer;
begin
  Result:=ics.prItemRefundQuantity;
end;

function TIKC_E810T.GetItemRefundSum: Longint;
begin
  Result:=ics.prItemRefundSum;
end;

function TIKC_E810T.GetItemRefundSumStr: string;
begin
  Result:=ics.prItemRefundSumStr;
end;

function TIKC_E810T.GetItemSaleQtyPrecision: byte;
begin
  Result:=ics.prItemSaleQtyPrecision;
end;

function TIKC_E810T.GetItemSaleQuantity: integer;
begin
  Result:=ics.prItemSaleQuantity;
end;

function TIKC_E810T.GetItemSaleSum: Longint;
begin
  Result:=ics.prItemSaleSum;
end;

function TIKC_E810T.GetItemSaleSumStr: string;
begin
  Result:=ics.prItemSaleSumStr;
end;

function TIKC_E810T.GetItemTax: byte;
begin
  Result:=ics.prItemTax;
end;

function TIKC_E810T.GetDayRefundReceiptsCount: integer;
begin
  Result:=ics.prDayRefundReceiptsCount;
end;

function TIKC_E810T.GetDayRefundReceiptsCountStr: string;
begin
  Result:=ics.prDayRefundReceiptsCountStr;
end;

function TIKC_E810T.GetDaySaleReceiptsCount: integer;
begin
  Result:=ics.prDaySaleReceiptsCount;
end;

function TIKC_E810T.GetDaySaleReceiptsCountStr: string;
begin
  Result:=ics.prDaySaleReceiptsCountStr;
end;

function TIKC_E810T.GetDaySaleSumOnTax1: Cardinal;
begin
  Result:=ics.prDaySaleSumOnTax1;
end;

function TIKC_E810T.GetDaySaleSumOnTax1Str: string;
begin
  Result:=ics.prDaySaleSumOnTax1Str;
end;

function TIKC_E810T.GetDaySaleSumOnTax2: Cardinal;
begin
  Result:=ics.prDaySaleSumOnTax2;
end;

function TIKC_E810T.GetDaySaleSumOnTax2Str: string;
begin
  Result:=ics.prDaySaleSumOnTax2Str;
end;

function TIKC_E810T.GetDaySaleSumOnTax3: Cardinal;
begin
  Result:=ics.prDaySaleSumOnTax3;
end;

function TIKC_E810T.GetDaySaleSumOnTax3Str: string;
begin
  Result:=ics.prDaySaleSumOnTax3Str;
end;

function TIKC_E810T.GetDaySaleSumOnTax4: Cardinal;
begin
  Result:=ics.prDaySaleSumOnTax4;
end;

function TIKC_E810T.GetDaySaleSumOnTax4Str: string;
begin
  Result:=ics.prDaySaleSumOnTax4Str;
end;

function TIKC_E810T.GetDaySaleSumOnTax5: Cardinal;
begin
  Result:=ics.prDaySaleSumOnTax5;
end;

function TIKC_E810T.GetDaySaleSumOnTax5Str: string;
begin
  Result:=ics.prDaySaleSumOnTax5Str;
end;

function TIKC_E810T.GetDaySaleSumOnTax6: Cardinal;
begin
  Result:=ics.prDaySaleSumOnTax6;
end;

function TIKC_E810T.GetDaySaleSumOnTax6Str: string;
begin
  Result:=ics.prDaySaleSumOnTax6Str;
end;

function TIKC_E810T.GetDayRefundSumOnTax1: Cardinal;
begin
  Result:=ics.prDayRefundSumOnTax1;
end;

function TIKC_E810T.GetDayRefundSumOnTax1Str: string;
begin
  Result:=ics.prDayRefundSumOnTax1Str;
end;

function TIKC_E810T.GetDayRefundSumOnTax2: Cardinal;
begin
  Result:=ics.prDayRefundSumOnTax2;
end;

function TIKC_E810T.GetDayRefundSumOnTax2Str: string;
begin
  Result:=ics.prDayRefundSumOnTax2Str;
end;

function TIKC_E810T.GetDayRefundSumOnTax3: Cardinal;
begin
  Result:=ics.prDayRefundSumOnTax3;
end;

function TIKC_E810T.GetDayRefundSumOnTax3Str: string;
begin
  Result:=ics.prDayRefundSumOnTax3Str;
end;

function TIKC_E810T.GetDayRefundSumOnTax4: Cardinal;
begin
  Result:=ics.prDayRefundSumOnTax4;
end;

function TIKC_E810T.GetDayRefundSumOnTax4Str: string;
begin
  Result:=ics.prDayRefundSumOnTax4Str;
end;

function TIKC_E810T.GetDayRefundSumOnTax5: Cardinal;
begin
  Result:=ics.prDayRefundSumOnTax5;
end;

function TIKC_E810T.GetDayRefundSumOnTax5Str: string;
begin
  Result:=ics.prDayRefundSumOnTax5Str;
end;

function TIKC_E810T.GetDayRefundSumOnTax6: Cardinal;
begin
  Result:=ics.prDayRefundSumOnTax6;
end;

function TIKC_E810T.GetDayRefundSumOnTax6Str: string;
begin
  Result:=ics.prDayRefundSumOnTax6Str;
end;

function TIKC_E810T.GetDaySaleSumOnPayForm1: Cardinal;
begin
  Result:=ics.prDaySaleSumOnPayForm1;
end;

function TIKC_E810T.GetDaySaleSumOnPayForm10: Cardinal;
begin
  Result:=ics.prDaySaleSumOnPayForm10;
end;

function TIKC_E810T.GetDaySaleSumOnPayForm10Str: string;
begin
  Result:=ics.prDaySaleSumOnPayForm10Str;
end;

function TIKC_E810T.GetDaySaleSumOnPayForm1Str: string;
begin
  Result:=ics.prDaySaleSumOnPayForm1Str;
end;

function TIKC_E810T.GetDaySaleSumOnPayForm2: Cardinal;
begin
  Result:=ics.prDaySaleSumOnPayForm2;
end;

function TIKC_E810T.GetDaySaleSumOnPayForm2Str: string;
begin
  Result:=ics.prDaySaleSumOnPayForm2Str;
end;

function TIKC_E810T.GetDaySaleSumOnPayForm3: Cardinal;
begin
  Result:=ics.prDaySaleSumOnPayForm3;
end;

function TIKC_E810T.GetDaySaleSumOnPayForm3Str: string;
begin
  Result:=ics.prDaySaleSumOnPayForm3Str;
end;

function TIKC_E810T.GetDaySaleSumOnPayForm4: Cardinal;
begin
  Result:=ics.prDaySaleSumOnPayForm4;
end;

function TIKC_E810T.GetDaySaleSumOnPayForm4Str: string;
begin
  Result:=ics.prDaySaleSumOnPayForm4Str;
end;

function TIKC_E810T.GetDaySaleSumOnPayForm5: Cardinal;
begin
  Result:=ics.prDaySaleSumOnPayForm5;
end;

function TIKC_E810T.GetDaySaleSumOnPayForm5Str: string;
begin
  Result:=ics.prDaySaleSumOnPayForm5Str;
end;

function TIKC_E810T.GetDaySaleSumOnPayForm6: Cardinal;
begin
  Result:=ics.prDaySaleSumOnPayForm6;
end;

function TIKC_E810T.GetDaySaleSumOnPayForm6Str: string;
begin
  Result:=ics.prDaySaleSumOnPayForm6Str;
end;

function TIKC_E810T.GetDaySaleSumOnPayForm7: Cardinal;
begin
  Result:=ics.prDaySaleSumOnPayForm7;
end;

function TIKC_E810T.GetDaySaleSumOnPayForm7Str: string;
begin
  Result:=ics.prDaySaleSumOnPayForm7Str;
end;

function TIKC_E810T.GetDaySaleSumOnPayForm8: Cardinal;
begin
  Result:=ics.prDaySaleSumOnPayForm8;
end;

function TIKC_E810T.GetDaySaleSumOnPayForm8Str: string;
begin
  Result:=ics.prDaySaleSumOnPayForm8Str;
end;

function TIKC_E810T.GetDaySaleSumOnPayForm9: Cardinal;
begin
  Result:=ics.prDaySaleSumOnPayForm9;
end;

function TIKC_E810T.GetDaySaleSumOnPayForm9Str: string;
begin
  Result:=ics.prDaySaleSumOnPayForm9Str;
end;

function TIKC_E810T.GetDayRefundSumOnPayForm1: Cardinal;
begin
  Result:=ics.prDayRefundSumOnPayForm1;
end;

function TIKC_E810T.GetDayRefundSumOnPayForm10: Cardinal;
begin
  Result:=ics.prDayRefundSumOnPayForm10;
end;

function TIKC_E810T.GetDayRefundSumOnPayForm2: Cardinal;
begin
  Result:=ics.prDayRefundSumOnPayForm2;
end;

function TIKC_E810T.GetDayRefundSumOnPayForm3: Cardinal;
begin
  Result:=ics.prDayRefundSumOnPayForm3;
end;

function TIKC_E810T.GetDayRefundSumOnPayForm4: Cardinal;
begin
  Result:=ics.prDayRefundSumOnPayForm4;
end;

function TIKC_E810T.GetDayRefundSumOnPayForm5: Cardinal;
begin
  Result:=ics.prDayRefundSumOnPayForm5;
end;

function TIKC_E810T.GetDayRefundSumOnPayForm6: Cardinal;
begin
  Result:=ics.prDayRefundSumOnPayForm6;
end;

function TIKC_E810T.GetDayRefundSumOnPayForm7: Cardinal;
begin
  Result:=ics.prDayRefundSumOnPayForm7;
end;

function TIKC_E810T.GetDayRefundSumOnPayForm8: Cardinal;
begin
  Result:=ics.prDayRefundSumOnPayForm8;
end;

function TIKC_E810T.GetDayRefundSumOnPayForm9: Cardinal;
begin
  Result:=ics.prDayRefundSumOnPayForm9;
end;

function TIKC_E810T.GetDayRefundSumOnPayForm10Str: string;
begin
  Result:=ics.prDayRefundSumOnPayForm10Str;
end;

function TIKC_E810T.GetDayRefundSumOnPayForm1Str: string;
begin
  Result:=ics.prDayRefundSumOnPayForm1Str;
end;

function TIKC_E810T.GetDayRefundSumOnPayForm2Str: string;
begin
  Result:=ics.prDayRefundSumOnPayForm2Str;
end;

function TIKC_E810T.GetDayRefundSumOnPayForm3Str: string;
begin
  Result:=ics.prDayRefundSumOnPayForm3Str;
end;

function TIKC_E810T.GetDayRefundSumOnPayForm4Str: string;
begin
  Result:=ics.prDayRefundSumOnPayForm4Str;
end;

function TIKC_E810T.GetDayRefundSumOnPayForm5Str: string;
begin
  Result:=ics.prDayRefundSumOnPayForm5Str;
end;

function TIKC_E810T.GetDayRefundSumOnPayForm6Str: string;
begin
  Result:=ics.prDayRefundSumOnPayForm6Str;
end;

function TIKC_E810T.GetDayRefundSumOnPayForm7Str: string;
begin
  Result:=ics.prDayRefundSumOnPayForm7Str;
end;

function TIKC_E810T.GetDayRefundSumOnPayForm8Str: string;
begin
  Result:=ics.prDayRefundSumOnPayForm8Str;
end;

function TIKC_E810T.GetDayRefundSumOnPayForm9Str: string;
begin
  Result:=ics.prDayRefundSumOnPayForm9Str;
end;

function TIKC_E810T.GetDayDiscountSumOnRefunds: Cardinal;
begin
  Result:=ics.prDayDiscountSumOnRefunds;
end;

function TIKC_E810T.GetDayDiscountSumOnRefundsStr: string;
begin
  Result:=ics.prDayDiscountSumOnRefundsStr;
end;

function TIKC_E810T.GetDayDiscountSumOnSales: Cardinal;
begin
  Result:=ics.prDayDiscountSumOnSales;
end;

function TIKC_E810T.GetDayDiscountSumOnSalesStr: string;
begin
  Result:=ics.prDayDiscountSumOnSalesStr;
end;

function TIKC_E810T.GetDayMarkupSumOnSales: Cardinal;
begin
  Result:=ics.prDayMarkupSumOnSales;
end;

function TIKC_E810T.GetDayMarkupSumOnRefunds: Cardinal;
begin
  Result:=ics.prDayMarkupSumOnRefunds;
end;

function TIKC_E810T.GetDayMarkupSumOnSalesStr: string;
begin
  Result:=ics.prDayMarkupSumOnSalesStr;
end;

function TIKC_E810T.GetDayMarkupSumOnRefundsStr: string;
begin
  Result:=ics.prDayMarkupSumOnRefundsStr; 
end;

function TIKC_E810T.GetDayCashInSum: Cardinal;
begin
  Result:=ics.prDayCashInSum;
end;

function TIKC_E810T.GetDayCashInSumStr: string;
begin
  Result:=ics.prDayCashInSumStr;
end;

function TIKC_E810T.GetDayCashOutSum: Cardinal;
begin
  Result:=ics.prDayCashOutSum;
end;

function TIKC_E810T.GetDayCashOutSumStr: string;
begin
  Result:=ics.prDayCashOutSumStr;
end;

function TIKC_E810T.GetCurReceiptTax1Sum: Cardinal;
begin
  Result:=ics.prCurReceiptTax1Sum;
end;

function TIKC_E810T.GetCurReceiptTax2Sum: Cardinal;
begin
  Result:=ics.prCurReceiptTax2Sum;
end;

function TIKC_E810T.GetCurReceiptTax3Sum: Cardinal;
begin
  Result:=ics.prCurReceiptTax3Sum;
end;

function TIKC_E810T.GetCurReceiptTax4Sum: Cardinal;
begin
  Result:=ics.prCurReceiptTax4Sum;
end;

function TIKC_E810T.GetCurReceiptTax5Sum: Cardinal;
begin
  Result:=ics.prCurReceiptTax5Sum;
end;

function TIKC_E810T.GetCurReceiptTax6Sum: Cardinal;
begin
  Result:=ics.prCurReceiptTax6Sum;
end;

function TIKC_E810T.GetCurReceiptTax1SumStr: string;
begin
  Result:=ics.prCurReceiptTax1SumStr;
end;

function TIKC_E810T.GetCurReceiptTax2SumStr: string;
begin
  Result:=ics.prCurReceiptTax2SumStr;
end;

function TIKC_E810T.GetCurReceiptTax3SumStr: string;
begin
  Result:=ics.prCurReceiptTax3SumStr;
end;

function TIKC_E810T.GetCurReceiptTax4SumStr: string;
begin
  Result:=ics.prCurReceiptTax4SumStr;
end;

function TIKC_E810T.GetCurReceiptTax5SumStr: string;
begin
  Result:=ics.prCurReceiptTax5SumStr;
end;

function TIKC_E810T.GetCurReceiptTax6SumStr: string;
begin
  Result:=ics.prCurReceiptTax6SumStr;
end;

function TIKC_E810T.GetCurReceiptPayForm10Sum: Cardinal;
begin
  Result:=ics.prCurReceiptPayForm10Sum;
end;

function TIKC_E810T.GetCurReceiptPayForm1Sum: Cardinal;
begin
  Result:=ics.prCurReceiptPayForm1Sum;
end;

function TIKC_E810T.GetCurReceiptPayForm2Sum: Cardinal;
begin
  Result:=ics.prCurReceiptPayForm2Sum;
end;

function TIKC_E810T.GetCurReceiptPayForm3Sum: Cardinal;
begin
  Result:=ics.prCurReceiptPayForm3Sum;
end;

function TIKC_E810T.GetCurReceiptPayForm4Sum: Cardinal;
begin
  Result:=ics.prCurReceiptPayForm4Sum;
end;

function TIKC_E810T.GetCurReceiptPayForm5Sum: Cardinal;
begin
  Result:=ics.prCurReceiptPayForm5Sum;
end;

function TIKC_E810T.GetCurReceiptPayForm6Sum: Cardinal;
begin
  Result:=ics.prCurReceiptPayForm6Sum;
end;

function TIKC_E810T.GetCurReceiptPayForm7Sum: Cardinal;
begin
  Result:=ics.prCurReceiptPayForm7Sum;
end;

function TIKC_E810T.GetCurReceiptPayForm8Sum: Cardinal;
begin
  Result:=ics.prCurReceiptPayForm8Sum;
end;

function TIKC_E810T.GetCurReceiptPayForm9Sum: Cardinal;
begin
  Result:=ics.prCurReceiptPayForm9Sum;
end;

function TIKC_E810T.GetCurReceiptPayForm10SumStr: string;
begin
  Result:=ics.prCurReceiptPayForm10SumStr;
end;

function TIKC_E810T.GetCurReceiptPayForm1SumStr: string;
begin
  Result:=ics.prCurReceiptPayForm1SumStr;
end;

function TIKC_E810T.GetCurReceiptPayForm2SumStr: string;
begin
  Result:=ics.prCurReceiptPayForm2SumStr;
end;

function TIKC_E810T.GetCurReceiptPayForm3SumStr: string;
begin
  Result:=ics.prCurReceiptPayForm3SumStr;
end;

function TIKC_E810T.GetCurReceiptPayForm4SumStr: string;
begin
  Result:=ics.prCurReceiptPayForm4SumStr;
end;

function TIKC_E810T.GetCurReceiptPayForm5SumStr: string;
begin
  Result:=ics.prCurReceiptPayForm5SumStr;
end;

function TIKC_E810T.GetCurReceiptPayForm6SumStr: string;
begin
  Result:=ics.prCurReceiptPayForm6SumStr;
end;

function TIKC_E810T.GetCurReceiptPayForm7SumStr: string;
begin
  Result:=ics.prCurReceiptPayForm7SumStr;
end;

function TIKC_E810T.GetCurReceiptPayForm8SumStr: string;
begin
  Result:=ics.prCurReceiptPayForm8SumStr;
end;

function TIKC_E810T.GetCurReceiptPayForm9SumStr: string;
begin
  Result:=ics.prCurReceiptPayForm9SumStr;
end;

function TIKC_E810T.GetDayAnnuledSaleReceiptsCount: Integer;
begin
  Result:=ics.prDayAnnuledSaleReceiptsCount;
end;

function TIKC_E810T.GetDayAnnuledSaleReceiptsCountStr: string;
begin
  Result:=ics.prDayAnnuledSaleReceiptsCountStr;
end;

function TIKC_E810T.GetDayAnnuledSaleReceiptsSum: Cardinal;
begin
  Result:=ics.prDayAnnuledSaleReceiptsSum;
end;

function TIKC_E810T.GetDayAnnuledSaleReceiptsSumStr: string;
begin
  Result:=ics.prDayAnnuledSaleReceiptsSumStr;
end;

function TIKC_E810T.GetDayAnnuledRefundReceiptsCount: integer;
begin
  Result:=ics.prDayAnnuledRefundReceiptsCount;
end;

function TIKC_E810T.GetDayAnnuledRefundReceiptsCountStr: string;
begin
  Result:=ics.prDayAnnuledRefundReceiptsCountStr;
end;

function TIKC_E810T.GetDayAnnuledRefundReceiptsSum: Cardinal;
begin
  Result:=ics.prDayAnnuledRefundReceiptsSum;
end;

function TIKC_E810T.GetDayAnnuledRefundReceiptsSumStr: string;
begin
  Result:=ics.prDayAnnuledRefundReceiptsSumStr;
end;

function TIKC_E810T.GetDaySaleCancelingsCount: Integer;
begin
  Result:=ics.prDaySaleCancelingsCount;
end;

function TIKC_E810T.GetDaySaleCancelingsCountStr: string;
begin
  Result:=ics.prDaySaleCancelingsCountStr;
end;

function TIKC_E810T.GetDaySaleCancelingsSum: Cardinal;
begin
  Result:=ics.prDaySaleCancelingsSum;
end;

function TIKC_E810T.GetDaySaleCancelingsSumStr: String;
begin
  Result:=ics.prDaySaleCancelingsSumStr;
end;

function TIKC_E810T.GetDayRefundCancelingsCount: Integer;
begin
  Result:=ics.prDayRefundCancelingsCount;
end;

function TIKC_E810T.GetDayRefundCancelingsCountStr: string;
begin
  Result:=ics.prDayRefundCancelingsCountStr;
end;

function TIKC_E810T.GetDayRefundCancelingsSum: Cardinal;
begin
  Result:=ics.prDayRefundCancelingsSum;
end;

function TIKC_E810T.GetDayRefundCancelingsSumStr: string;
begin
  Result:=ics.prDayRefundCancelingsSumStr;
end;

function TIKC_E810T.GetDaySumAddTaxOfSale1: Cardinal;
begin
  Result:=ics.prDaySumAddTaxOfSale1;
end;

function TIKC_E810T.GetDaySumAddTaxOfSale2: Cardinal;
begin
  Result:=ics.prDaySumAddTaxOfSale2;
end;

function TIKC_E810T.GetDaySumAddTaxOfSale3: Cardinal;
begin
  Result:=ics.prDaySumAddTaxOfSale3;
end;

function TIKC_E810T.GetDaySumAddTaxOfSale4: Cardinal;
begin
  Result:=ics.prDaySumAddTaxOfSale4;
end;

function TIKC_E810T.GetDaySumAddTaxOfSale5: Cardinal;
begin
  Result:=ics.prDaySumAddTaxOfSale5;
end;

function TIKC_E810T.GetDaySumAddTaxOfSale6: Cardinal;
begin
  Result:=ics.prDaySumAddTaxOfSale6;
end;

function TIKC_E810T.GetDaySumAddTaxOfSale1Str: string;
begin
  Result:=ics.prDaySumAddTaxOfSale1Str;
end;

function TIKC_E810T.GetDaySumAddTaxOfSale2Str: string;
begin
  Result:=ics.prDaySumAddTaxOfSale2Str;
end;

function TIKC_E810T.GetDaySumAddTaxOfSale3Str: string;
begin
  Result:=ics.prDaySumAddTaxOfSale3Str;
end;

function TIKC_E810T.GetDaySumAddTaxOfSale4Str: string;
begin
  Result:=ics.prDaySumAddTaxOfSale4Str;
end;

function TIKC_E810T.GetDaySumAddTaxOfSale5Str: string;
begin
  Result:=ics.prDaySumAddTaxOfSale5Str;
end;

function TIKC_E810T.GetDaySumAddTaxOfSale6Str: string;
begin
  Result:=ics.prDaySumAddTaxOfSale6Str;
end;

function TIKC_E810T.GetDaySumAddTaxOfRefund1: Cardinal;
begin
  Result:=ics.prDaySumAddTaxOfRefund1;
end;

function TIKC_E810T.GetDaySumAddTaxOfRefund2: Cardinal;
begin
  Result:=ics.prDaySumAddTaxOfRefund2;
end;

function TIKC_E810T.GetDaySumAddTaxOfRefund3: Cardinal;
begin
  Result:=ics.prDaySumAddTaxOfRefund3;
end;

function TIKC_E810T.GetDaySumAddTaxOfRefund4: Cardinal;
begin
  Result:=ics.prDaySumAddTaxOfRefund4;
end;

function TIKC_E810T.GetDaySumAddTaxOfRefund5: Cardinal;
begin
  Result:=ics.prDaySumAddTaxOfRefund5;
end;

function TIKC_E810T.GetDaySumAddTaxOfRefund6: Cardinal;
begin
  Result:=ics.prDaySumAddTaxOfRefund6;
end;

function TIKC_E810T.GetDaySumAddTaxOfRefund1Str: string;
begin
  Result:=ics.prDaySumAddTaxOfRefund1Str;
end;

function TIKC_E810T.GetDaySumAddTaxOfRefund2Str: string;
begin
  Result:=ics.prDaySumAddTaxOfRefund2Str;
end;

function TIKC_E810T.GetDaySumAddTaxOfRefund3Str: string;
begin
  Result:=ics.prDaySumAddTaxOfRefund3Str;
end;

function TIKC_E810T.GetDaySumAddTaxOfRefund4Str: string;
begin
  Result:=ics.prDaySumAddTaxOfRefund4Str;
end;

function TIKC_E810T.GetDaySumAddTaxOfRefund5Str: string;
begin
  Result:=ics.prDaySumAddTaxOfRefund5Str;
end;

function TIKC_E810T.GetDaySumAddTaxOfRefund6Str: string;
begin
  Result:=ics.prDaySumAddTaxOfRefund6Str;
end;

function TIKC_E810T.GetSerialNumber: string;
begin
  Result:=ics.prSerialNumber;
end;

function TIKC_E810T.GetFiscalNumber: string;
begin
  Result:=ics.prFiscalNumber;
end;

function TIKC_E810T.GetTaxNumber: string;
begin
  Result:=ics.prTaxNumber;
end;

function TIKC_E810T.GetDateFiscalization: TDateTime;
begin
  Result:=ics.prDateFiscalization;
end;

function TIKC_E810T.GetDateFiscalizationStr: string;
begin
  Result:=ics.prDateFiscalizationStr;
end;

function TIKC_E810T.GetTimeFiscalization: TDateTime;
begin
  Result:=ics.prTimeFiscalization;
end;

function TIKC_E810T.GetTimeFiscalizationStr: string;
begin
  Result:=ics.prTimeFiscalizationStr;
end;

function TIKC_E810T.GetHardwareVersion: string;
begin
  Result:=ics.prHardwareVersion;
end;

function TIKC_E810T.GetHeadLine1: string;
begin
  Result:=ics.prHeadLine1;
end;

function TIKC_E810T.GetHeadLine2: string;
begin
  Result:=ics.prHeadLine2;
end;

function TIKC_E810T.GetHeadLine3: string;
begin
  Result:=ics.prHeadLine3;
end;

function TIKC_E810T.GetUseAdditionalFee: boolean;
begin
  Result:=ics.stUseAdditionalFee;
end;

function TIKC_E810T.GetUseAdditionalTax: boolean;
begin
  Result:=ics.stUseAdditionalTax;
end;

function TIKC_E810T.GetUseCutter: boolean;
begin
  Result:=ics.stUseCutter;
end;

function TIKC_E810T.GetUseFontB: boolean;
begin
  Result:=ics.stUseFontB;
end;

function TIKC_E810T.GetUseTradeLogo: boolean;
begin
  Result:=ics.stUseTradeLogo;
end;

function TIKC_E810T.GetCashDrawerIsOpened: boolean;
begin
  Result:=ics.stCashDrawerIsOpened;
end;

function TIKC_E810T.GetFailureLastCommand: boolean;
begin
  Result:=ics.stFailureLastCommand;
end;

function TIKC_E810T.GetFiscalDayIsOpened: boolean;
begin
  Result:=ics.stFiscalDayIsOpened;
end;

function TIKC_E810T.GetFiscalMode: boolean;
begin
  Result:=ics.stFiscalMode;
end;

function TIKC_E810T.GetOnlinePrintMode: boolean;
begin
  Result:=ics.stOnlinePrintMode;
end;

function TIKC_E810T.GetReceiptIsOpened: boolean;
begin
  Result:=ics.stReceiptIsOpened;
end;

function TIKC_E810T.GetPaymentMode: boolean;
begin
  Result:=ics.stPaymentMode;
end;

function TIKC_E810T.GetDisplayShowSumMode: boolean;
begin
  Result:=ics.stDisplayShowSumMode;
end;

function TIKC_E810T.GetRefundReceiptMode: boolean;
begin
  Result:=ics.stRefundReceiptMode;
end;

function TIKC_E810T.GetServiceReceiptMode: boolean;
begin
  Result:=ics.stServiceReceiptMode;
end;

function TIKC_E810T.GetUserPassword: byte;
begin
  Result:=ics.prUserPassword;
end;

function TIKC_E810T.GetUserPasswordStr: string;
begin
  Result:=ics.prUserPasswordStr;
end;

function TIKC_E810T.GetFPDriverBuildVersion: byte;
begin
  Result:=ics.prFPDriverBuildVersion;
end;

function TIKC_E810T.GetFPDriverMajorVersion: byte;
begin
  Result:=ics.prFPDriverMajorVersion;
end;

function TIKC_E810T.GetFPDriverMinorVersion: byte;
begin
  Result:=ics.prFPDriverMinorVersion;
end;

function TIKC_E810T.GetFPDriverReleaseVersion: byte;
begin
  Result:=ics.prFPDriverReleaseVersion;
end;

function TIKC_E810T.GetKsefSavePath: string;
begin
  Result:=mdm.prKsefSavePath;
end;

procedure TIKC_E810T.SetKsefSavePath(const Value: string);
begin
  mdm.prKsefSavePath:=Value;
end;

function TIKC_E810T.GetPropertiesModemAutoUpdateMode: boolean;
begin
  Result:=mdm.glPropertiesAutoUpdateMode;
end;

procedure TIKC_E810T.SetPropertiesModemAutoUpdateMode(
  const Value: boolean);
begin
  mdm.glPropertiesAutoUpdateMode:=Value;
end;

function TIKC_E810T.GetModemCodepageOEM: boolean;
begin
  Result:=mdm.glCodepageOEM;
end;

procedure TIKC_E810T.SetModemCodepageOEM(const Value: boolean);
begin
  mdm.glCodepageOEM:=Value;
end;

function TIKC_E810T.GetModemLangID: byte;
begin
  Result:=mdm.glLangID;
end;

procedure TIKC_E810T.SetModemLangID(const Value: byte);
begin
  mdm.glLangID:=Value;
end;

function TIKC_E810T.GetModemRepeatCount: byte;
begin
  Result:=mdm.prRepeatCount;
end;

procedure TIKC_E810T.SetModemRepeatCount(const Value: byte);
begin
  mdm.prRepeatCount:=Value;
end;

function TIKC_E810T.GetModemLogRecording: boolean;
begin
  Result:=mdm.prLogRecording;
end;

procedure TIKC_E810T.SetModemLogRecording(const Value: boolean);
begin
  mdm.prLogRecording:=Value;
end;

function TIKC_E810T.GetModemAnswerWaiting: byte;
begin
  Result:=mdm.prAnswerWaiting;
end;

procedure TIKC_E810T.SetModemAnswerWaiting(const Value: byte);
begin
  mdm.prAnswerWaiting:=Value;
end;

function TIKC_E810T.GetModemKsefSavePath: string;
begin
  Result:=mdm.prKsefSavePath;
end;

procedure TIKC_E810T.SetModemKsefSavePath(const Value: string);
begin
  mdm.prKsefSavePath:=Value;
end;

function TIKC_E810T.GetModemErrorCode: byte;
begin
  Result:=mdm.prGetErrorCode;
end;

function TIKC_E810T.GetModemErrorText: string;
begin
  Result:=mdm.prGetErrorText;
end;

function TIKC_E810T.GetModemWorkSecondCount: Longint;
begin
  Result:=mdm.stWorkSecondCount;
end;

function TIKC_E810T.GetFPExchangeModemSecondCount: Longint;
begin
  Result:=mdm.stFPExchangeSecondCount;
end;

function TIKC_E810T.GetModemFirstUnsendPIDDateTime: TDateTime;
begin
  Result:=mdm.stFirstUnsendPIDDateTime;
end;

function TIKC_E810T.GetModemFirstUnsendPIDDateTimeStr: string;
begin
  Result:=mdm.stFirstUnsendPIDDateTimeStr;
end;

function TIKC_E810T.GetModemPID_Unused: Longint;
begin
  Result:=mdm.stPID_Unused;
end;

function TIKC_E810T.GetModemPID_CurPers: Longint;
begin
  Result:=mdm.stPID_CurPers;
end;

function TIKC_E810T.GetModemPID_LastWrite: Longint;
begin
  Result:=mdm.stPID_LastWrite;
end;

function TIKC_E810T.GetModemPID_LastSign: Longint;
begin
  Result:=mdm.stPID_LastSign;
end;

function TIKC_E810T.GetModemPID_LastSend: Longint;
begin
  Result:=mdm.stPID_LastSend;
end;

function TIKC_E810T.GetModemSerialNumber: Longint;
begin
  Result:=mdm.stSerialNumber;
end;

function TIKC_E810T.GetModemID_DEV: Longint;
begin
  Result:=mdm.stID_DEV;
end;

function TIKC_E810T.GetModemID_SAM: Longint;
begin
  Result:=mdm.stID_SAM;
end;

function TIKC_E810T.GetModemNT_SESSION: Longint;
begin
  Result:=mdm.stNT_SESSION;
end;

function TIKC_E810T.GetModemFailCode: byte;
begin
  Result:=mdm.stFailCode;
end;

function TIKC_E810T.GetModemState3: byte;
begin
  Result:=mdm.stState3;
end;

function TIKC_E810T.GetModemLanState1: byte;
begin
  Result:=mdm.stLanState1;
end;

function TIKC_E810T.GetModemLanState2: byte;
begin
  Result:=mdm.stLanState2;
end;

function TIKC_E810T.GetModemFPExchangeResult: byte;
begin
  Result:=mdm.stFPExchangeResult;
end;

function TIKC_E810T.GetModemACQExchangeResult: byte;
begin
  Result:=mdm.stACQExchangeResult;
end;

function TIKC_E810T.GetModemFPExchangeErrorCount: Longint;
begin
  Result:=mdm.stFPExchangeErrorCount;
end;

function TIKC_E810T.GetModemOSVer: Longint;
begin
  Result:=mdm.stOSVer;
end;

function TIKC_E810T.GetModemOSRev: Longint;
begin
  Result:=mdm.stOSRev;
end;

function TIKC_E810T.GetModemSysTime: TDateTime;
begin
  Result:=mdm.stSysTime;
end;

function TIKC_E810T.GetModemSysTimeStr: string;
begin
  Result:=mdm.stSysTimeStr;
end;

function TIKC_E810T.GetModemNETIPAddr: string;
begin
  Result:=mdm.stNETIPAddr;
end;

function TIKC_E810T.GetModemNETGate: string;
begin
  Result:=mdm.stNETGate;
end;

function TIKC_E810T.GetModemNETMask: string;
begin
  Result:=mdm.stNETMask;
end;

function TIKC_E810T.GetModemACQIPAddr: string;
begin
  Result:=mdm.stACQIPAddr;
end;

function TIKC_E810T.GetModemACQPort: Longint;
begin
  Result:=mdm.stACQPort;
end;

function TIKC_E810T.GetModemACQExchangeSecondCount: Longint;
begin
  Result:=mdm.stACQExchangeSecondCount;
end;

function TIKC_E810T.GetModemFoundPacket: Cardinal;
begin
  Result:=mdm.prFoundPacket;
end;

function TIKC_E810T.GetModemFoundPacketStr: string;
begin
  Result:=mdm.prFoundPacketStr;
end;

function TIKC_E810T.GetModemCurrentTaskCode: byte;
begin
  Result:=mdm.prCurrentTaskCode;
end;

function TIKC_E810T.GetModemCurrentTaskText: string;
begin
  Result:=mdm.prCurrentTaskText;
end;

function TIKC_E810T.GetModemDriverMajorVersion: Byte;
begin
  Result:=mdm.prModemDriverMajorVersion;
end;

function TIKC_E810T.GetModemDriverMinorVersion: byte;
begin
  Result:=mdm.prModemDriverMinorVersion;
end;

function TIKC_E810T.GetModemDriverReleaseVersion: byte;
begin
  Result:=mdm.prModemDriverReleaseVersion;
end;

function TIKC_E810T.GetModemDriverBuildVersion: byte;
begin
  Result:=mdm.prModemDriverBuildVersion;
end;

end.
