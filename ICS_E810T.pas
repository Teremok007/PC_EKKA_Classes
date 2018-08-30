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
    function GetTaxRatesCount: byte; //���������� ������������ ��������� �����.
    procedure SetTaxRatesCount(TaxRatesCount: byte); //���������� ������������ ��������� �����.
    function GetAddTaxType: boolean; //��� ������: false � ���������; true � ����������
    procedure SetAddTaxType(AddTaxType: boolean); //��� ������: false � ���������; true � ����������
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
    function FPInitialize: Longint; //����� ��������� ��������� ������������� ���������� ��������.
                                    //������ ���������� ����� ����� �������� ������� ��������.
                                    //���������� 0, ���� ������������� ������ ��� ��� ������ � ������������ � �������� GetLastError() ��� GetLastWin32Error()
    function FPOpen(_COMport: string;
                    baudRate: integer = 9600;
                    readTimeout: string = '3';
                    writeTimeout: string = '3'): boolean; //����� ��������� ���������������� ���� � ������������� ��������� ����� ��� ����� � ��.
                                                          //� ������ ��������� ���������� ����� ���������� true.
    function FPOpenStr(_COMport: string;
                    baudRate: integer = 9600;
                    readTimeout: string = '3';
                    writeTimeout: string = '3'): boolean; //����� ��������� ���������������� ���� � ������������� ��������� ����� ��� ����� � ��. � ������ ��������� ���������� ����� ���������� true.
    function FPClose: boolean; //����� ��������� �������� ����������������� ���������� ��������� �������� FPOpen ��� FPOpenStr.
                               //��� ���������� ��������� � ����� ����� ������ � ��. � ������ ��������� ���������� ����� ���������� true
    function FPSetPassword(userID: byte;
                           oldPassword: word;
                           newPassword: word): boolean; //����� ��������� ��������� ����� ������� ��������, ������ ������ ���������������� � ������ ������ �������. � ������ ��������� ���������� ����� ���������� true
    function FPRegisterCashier(cashierID: byte;
                               name: string;
                               password: word): boolean; //����� ��������� ����������� ������� �� �� � ���������� ������� ��� ����� � �����. ���� ��� ������� � ������ ������, �� ����������� ������ ����������� �������.
                                                         //� ������ ��������� ���������� ����� ���������� true
    function FPRefundItem(qty: integer;
                          qtyPrecision: byte;
                          printEAN13: boolean;
                          printSingleQty: boolean;
                          printFromMemory: boolean;
                          itemPrice: integer;
                          itemTax: byte;
                          itemName: string;
                          itemCode: Longint): boolean; //����� ��������� ����������� �������� ��� ������ ������ � ���� ������. � ������ ��������� ���������� ����� ���������� true
    function FPRefundItemStr(qty: integer;
                             qtyPrecision: byte;
                             printEAN13: boolean;
                             printSingleQty: boolean;
                             printFromMemory: boolean;
                             itemPrice: integer;
                             itemTax: byte;
                             itemName: string;
                             itemCode: string): boolean; //����� ���������� FPRefundItem � ��������� ����������� �������� ��� ������ ������ � ���� ������.
                                                          //������������� ��� ������������� � ������, ���� ����� ���������� �� ������������
                                                          //��� __int64 (1�:����������� 8.x). � ������ ��������� ���������� ����� ���������� true
    function FPSaleItem(qty: integer;
                        qtyPrecision: byte;
                        printEAN13: boolean;
                        printSingleQty: boolean;
                        printFromMemory: boolean;
                        itemPrice: integer;
                        itemTax: byte;
                        itemName: string;
                        itemCode: Longint): boolean; //����� ��������� ����������� ������� ������ � ���� ������. � ������ ��������� ���������� ����� ���������� true
    function FPSaleItemStr(qty: integer;
                        qtyPrecision: byte;
                        printEAN13: boolean;
                        printSingleQty: boolean;
                        printFromMemory: boolean;
                        itemPrice: integer;
                        itemTax: byte;
                        itemName: string;
                        itemCode: string): boolean; //����� ���������� FPSaleItem � ��������� ����������� ������� ������ � ���� ������.
                                                    //������������� ��� ������������� � ������, ���� ����� ���������� �� ������������
                                                    //��� __int64 (1�:����������� 8.x). � ������ ��������� ���������� ����� ���������� true
    function FPCommentLine(commentLine: string;
                           openRefundReceipt: boolean=false): boolean;virtual; //����� ��������� ����������� ��������� ������ ����������� � ���� ������ � ������.
                                                                       //���������� ��������� ����� ���������� ������������ ����������� �������� ������� � ����� ���� ��� ������ ������ ��.
                                                                       //� ������ ��������� ���������� ����� ���������� true.
    function FPPrintZeroReceipt: boolean; //����� ��������� ������ �������� ���� ��� �������� ����� ����� � ��. � ������ ��������� ���������� ����� ���������� true
    function FPLineFeed: boolean; //����� ��������� �������� ����� �� �� ���� ������. � ������ ��������� ���������� ����� ���������� true.
    function FPAnnulReceipt: boolean; //����� ��������� ������ �������� ���� ��� ����������� ��������������. � ������ ��������� ���������� ����� ���������� true.
    function FPCashIn(cashSum: Cardinal): boolean; //����� ��������� �������� ���������� �������� ����� ����� � ����� � ����������� ������� ������. � ������ ��������� ���������� ����� ���������� true
    function FPCashOut(cashSum: Cardinal): boolean; //����� ��������� �������� ���������� ������� ����� ����� �� ����� � ����������� ������� ������. � ������ ��������� ���������� ����� ���������� true
    function FPPayment(paymentForm: byte;
                       paymentSum:  integer;
                       autoCloseReceipt: boolean;
                       asFiscalReceipt: boolean;
                       authCode: string): boolean; //����� ��������� ������ ��� ��������� ������ ���� ������ ��� ������ �� ����������� ����� ������
    function FPSetAdvHeaderLine(lineID: byte;
                                textLine: string;
                                isDoubleWidth: boolean;
                                isDoubleHeight: boolean): boolean; //����� ��������� ������ �������������� ����� ��������� ����. � ������ ��������� ���������� ����� ���������� true
    function FPSetAdvTrailerLine(lineID: byte;
                                 textLine: string;
                                 isDoubleWidth: boolean = false;
                                 isDoubleHeight: boolean = false): boolean; //����� ��������� ������ �������������� ����� ������� ����. � ������ ��������� ���������� ����� ���������� true
    function FPSetLineCustomerDisplay(lineID: byte;
                                      textLine: string): boolean; //����� ��������� ����� ������ �� �������������� ������� ����������. � ������ ��������� ���������� ����� ���������� true.
    function FPSetCurrentDate(currentDate: TDateTime): boolean; //����� ��������� ��������� ���� � ��. � ������ ��������� ���������� ����� ���������� true.
    function FPSetCurrentDateStr(currentDateStr: string): boolean; //����� ��������� ��������� ���� � ��. �������� ���������� ������ FPSetCurrentDate. � ������ ��������� ���������� ����� ���������� true.
    function FPGetCurrentDate: boolean; //����� ��������� ������ ������� ���� �� � ��������� � ������� ��������.
                                        //� ������ ��������� ���������� ����� ���������� true.
    function FPSetCurrentTime(currentTime: TDateTime): boolean; //����� ��������� ��������� ������� � ��. ����� �������� ������ ����� ���������� Z-������.
                                                                //� ������ ��������� ���������� ����� ���������� true.
    function FPSetCurrentTimeStr(currentTimeStr: string): boolean; //����� ��������� ��������� ������� � ��. �������� ���������� ������ FPSetCurrentTime.
                                                                   //����� �������� ������ ����� ���������� Z-������. � ������ ��������� ���������� ����� ���������� true.
    function FPGetCurrentTime: boolean; //����� ��������� ������ �������� ������� �� � ��������� � ������� ��������.
                                        //� ������ ��������� ���������� ����� ���������� true.
    function FPOpenCashDrawer(duration: integer): boolean; //����� ��������� �������� ��������� �����, ������������� � ��.
                                                           //������������ �������� ������� �� ������������� ������� ��������� ��������� �����
                                                           //��� ����������, �� ������� �� ���������. � ������ ��������� ���������� ����� ���������� true.
    function FPPrintHardwareVersion: boolean; //����� ��������� ������ ������ ����������� ������������ ����������� ��. � ������ ��������� ���������� ����� ���������� true
    function FPPrintLastKsefPacket: boolean; //����� ��������� ������ ����� ���������� ������ ������ ���� ��� Z-������). � ������ ��������� ���������� ����� ���������� true
    function FPPrintKsefPacket(packetID: Cardinal): boolean; //����� ��������� ������ ����� ���������� ������ ������ ���� ��� Z-������. � ������ ��������� ���������� ����� ���������� true.
    function FPMakeDiscount(isPercentType: boolean;
                            isForItem: boolean;
                            value: Integer;
                            textLine: string): boolean; //����� ��������� �������� ������ �� ��������� ����� � ���� ��� �� ������������� ����� ����. � ������ ��������� ���������� ����� ���������� true
    function FPMakeMarkUp(isPercentType: boolean;
                          isForItem: boolean;
                          value: integer;
                          textLine: string): boolean; //����� ��������� �������� ������� �� ��������� ����� � ���� ��� �� ������������� ����� ����. � ������ ��������� ���������� ����� ���������� true
    function FPOnlineSwitch: boolean; //����� ��������� ������������ ������ ������ ����� ������/�������.
                                      //� ������ ��������� ���������� ����� ���������� true
    function FPCustomerDisplayModeSwitch: boolean; //����� ��������� ������������ ������ ������ ����� ���� �� ������� ���������� ����������������/����������. � ������ ��������� ���������� ����� ���������� true
    function FPChangeBaudRate(baudRateIndex: byte): boolean; //����� ��������� ������������ �������� ������ UART � �� �� ��������� ��������. � ������ ��������� ���������� ����� ���������� true
    function FPPrintServiceReportByLine(textLine: string): boolean; //����� ��������� �������� ���������� ������, ���� �� �� ������ � �������� � �� ���� ������ ������. � ������ ��������� ���������� ����� ���������� true
    function FPPrintServiceReportMultiLine(multiLineText: string): boolean; //����� ��������� �������� ���������� ������, ���� �� �� ������ � �������� � �� ������������� �����. � ������ ��������� ���������� ����� ���������� true.
    function FPCloseServiceReport: boolean; //����� ��������� �������� ���������� ������. � ������ ��������� ���������� ����� ���������� true
    function FPDisableLogo(progPassword: Word): boolean; //����� ��������� ������ ����������������� �������� (�������� �������� �����������) � ����� � �������. � ������ ��������� ���������� ����� ���������� true
    function FPEnableLogo(progPassword: Word): boolean; //����� �������� ������ ����������������� �������� (�������� �������� �����������) � ����� � �������, ���� �� ��� �������������� ������� � �� ������������� ������������. � ������ ��������� ���������� ����� ���������� true.
    function FPSetTaxRates(progPassword: Word): boolean; //����� ��������� ��������� ���� ������, ����� ������ ������� � ������ �� �������������� ������������� �������� ��������� � ������� �������. � ������ ��������� ���������� ����� ���������� true. ����� ��������������� ������ � ������ ������ ���������� ���� ������, ����� ����� ������� � ����
    function FPGetTaxRates: boolean; //����� ��������� ������ �� �� ���� �������������� ������, � ����� ������ ������� � ������ � ��������� � ������� ��������. � ������ ��������� ���������� ����� ���������� true.
    function FPProgItem(progPassword: byte; qtyPrecision: byte; isRefundItem: boolean; itemPrice: integer; itemTax: byte; itemName: string; itemCode: Longint): boolean; //����� ��������� ��������������� ������ (����� ��������� �����) �������� ������ � ������ ��������� ��. � ������ ��������� ���������� ����� ���������� true
    function FPProgItemStr(progPassword: byte; qtyPrecision: byte; isRefundItem: boolean; itemPrice: integer; itemTax: byte; itemName: string; itemCodeStr: string): boolean; //����� ��������� ��������������� ������ (����� ��������� �����) �������� ������ � ������ ��������� ��. ������������� ��� ������������� � ������, ���� ����� ���������� �� ������������ ��� __int64 (1�:����������� 8.x). � ������ ��������� ���������� ����� ���������� true.
    function FPMakeXReport(reportPassword: Word): boolean; //����� ��������� ������ X-������. � ������ ��������� ���������� ����� ���������� true.
    function FPMakeZReport(reportPassword: Word): boolean; //����� ��������� ������ Z-������ � ���������� ������� ��������� ��. � ������ ��������� ���������� ����� ���������� true
    function FPMakeReportOnItems(reportPassword: byte; firstItemCode: Longint; lastItemCode: Longint): boolean; //����� ��������� ������ ������ �� ������� �� ���������� ��������� �����. ���� �������� firstItemCode � lastItemCode �� ������ (�������), ����� ���������� ����� �� ���� �������. � ������ ��������� ���������� ����� ���������� true.
    function FPMakeReportOnItemsStr(reportPassword: byte; firstItemCodeStr: string; lastItemCodeStr: string): boolean; //����� ��������� ������ ������ �� ������� �� ���������� ��������� �����.
                                                                                                                       //����� �������� ���������� FPMakeReportOnItems. ������������� ��� ������������� � ������, ���� ����� ����������
                                                                                                                       //�� ������������ ��� __int64 (1�:����������� 8.x). ���� �������� firstItemCodeStr � lastItemCodeStr �� ������ (������ ������),
                                                                                                                       //����� ��������� ������. ��� ������ ������ �� ���� ������� � ��������� firstItemCodeStr
                                                                                                                       //� lastItemCodeStr ����� �������� �������� �0�. � ������ ��������� ���������� ����� ���������� true
    function FPMakePeriodicReportOnDate(reportPassword: byte; firstDate: TDateTime; lastDate: TDateTime): boolean; //����� ��������� ������ ������� �������������� ������ �� ���������� ������ �� ����� �� ��������� ������. � ������ ��������� ���������� ����� ���������� true.
    function FPMakePeriodicReportOnDateStr(reportPassword: byte; firstDateStr: string; lastDateStr: string): boolean; //����� ��������� ������ ������� �������������� ������ �� ���������� ������ �� ����� �� ��������� ������.
                                                                                                                      //����� �������� ���������� FPMakePeriodicReportOnDate.
                                                                                                                      //� ������ ��������� ���������� ����� ���������� true
    function FPMakePeriodicShortReportOnDate(reportPassword: byte; firstDate: TDateTime; lastDate: TDateTime): boolean; //����� ��������� ������ ��������� �������������� ������ �� ���������� ������ �� ����� �� ��������� ������. � ������ ��������� ���������� ����� ���������� true.
    function FPMakePeriodicShortReportOnDateStr(reportPassword: byte; firstDateStr: string; lastDateStr: string): boolean; //����� ��������� ������ ��������� �������������� ������ �� ���������� ������ ��
                                                                                                                           //����� �� ��������� ������. �������� ���������� FPMakePeriodicShortReportOnDate.
                                                                                                                           //� ������ ��������� ���������� ����� ���������� true
    function FPMakePeriodicReportOnNumber(reportPassword: Word; firstNumber: Word; lastNumber: Word): boolean; //����� ��������� ������ ������� �������������� ������ �� ���������� ������ �� ��������� ������� Z-�������.
                                                                                                               //� ������ ��������� ���������� ����� ���������� true
    function FPCutterModeSwitch: boolean; //����� ��������� ����������/��������� ��������� �����. � ������ ��������� ���������� ����� ���������� true
    function FPPrintBarcodeOnReceipt(serialCode128B: string): boolean; //����� ��������� ����������� �����-���� �� ��� � ������� CODE 128 (��� B) � ����������� ������� ����� �������� ����.
                                                                       //� ������ ��������� ���������� ����� ���������� true.
    function FPPrintBarcodeOnItem(serialEAN13: string): boolean; //����� ��������� ����������� �����-���� �� ����� � ���� ���� � ������� EAN13.
                                                                 //� ������ ��������� ���������� ����� ���������� true.
    function FPGetPaymentFormNames: boolean; //����� ��������� ������ �������� ���� ����� �� �� � ��������� � ������� ��������. � ������ ��������� ���������� ����� ���������� true
    function FPGetCashDrawerSum: boolean; //����� ��������� ������ �� �� � ��������� � ������� �������� ����� �������� �������� �������, ��������� ���� � �������� �����. � ������ ��������� ���������� ����� ���������� true
    function FPGetDayReportProperties: boolean; //����� ��������� ������ ������ � ����� �� �� � ��������� ��� ��������������� ��������. � ������ ��������� ���������� ����� ���������� true
    function FPGetItemData(itemCode: Longint): boolean; //����� ��������� ������ ������ � ������ �� �� � ��������� ��� ��������������� ��������. � ������ ��������� ���������� ����� ���������� true.
    function FPGetItemDataStr(itemCodeStr: string): boolean; //����� ��������� ������ ������ � ������ �� �� � ��������� ��� ��������������� ��������.
                                                             //����� �������� ���������� FPGetItemData. ������������� ��� ������������� � ������, ���� ����� ����������
                                                             //�� ������������ ��� __int64 (1�:����������� 8.x).
                                                             //� ������ ��������� ���������� ����� ���������� true.
    function FPGetDayReportData: boolean; //����� ��������� ������ �� �� ������ � ������� �������� ����� � ��������� ��� ��������������� ��������. � ������ ��������� ���������� ����� ���������� true.
    function FPGetCurrentReceiptData: boolean; //����� ��������� ������ �� �� ������ �������� ���� � ��������� ��� ��������������� ��������. � ������ ��������� ���������� ����� ���������� true
    function FPGetDayCorrectionsData: boolean; //����� ��������� ������ �� �� ����� ���� ��������� � ��������� ����� �� ����� � ��������� ��� ��������������� ��������. � ������ ��������� ���������� ����� ���������� true
    function FPGetDaySumOfAddTaxes: boolean; //����� ��������� ������ �� �� ���� ������� ������������� �� ��������� ������� � ������, ���� ���������� ���������� ��� ������, � ����� ��������� ��� ��������������� ��������. � ������ ��������� ���������� ����� ���������� true.
    function FPGetCurrentStatus: boolean; //����� ��������� ������ �������� ��������� ��
                                          //� ����� ��������� ��������������� ��������.
                                          //� ������ ��������� ���������� ����� ���������� true.
    function FPPrintKsefRange(firstPacketID: Cardinal; lastPacketID: Cardinal): boolean; //����� ��������� ������ ����� ������� ������ ����� � Z-������� �� ��������� ���������. � ������ ��������� ���������� ����� ���������� true.
    function FPPaymentByCard(paymentForm: byte; paymentSum: Word; autoCloseReceipt: boolean; asFiscalReceipt: boolean; cardInfo: string; authCode: String): boolean; //����� ������������ ��� ���������� ������ ��� ��������� ������ ����
                                                                                //����� �������� EFT-�������� � ������� ��������������� ��������������� ����� � ���� ����������� �������.
                                                                                //� ������ ��������� ���������� ����� ���������� true.
    function FPPrintModemStatus: boolean; //����� ��������� ������ �� ����� �������� ������, � ����� ��� �������� ���������. � ������ ��������� ���������� ����� ���������� true
    function FPGetUserPassword(userID: byte): boolean; //����� ��������� ������ ������� ������������� (��������). � ������ ��������� ���������� ����� ���������� true
    function FPPrintBarcodeOnReceiptNew(serialCode128C: string): boolean; //����� ��������� ����������� �����-���� �� ��� � ������� CODE 128 (��� C) � ����������� ������� ����� �������� ����. � ������ ��������� ���������� ����� ���������� true.
    function FPPrintBarcodeOnServiceReport(serialCode128B: string): boolean; //����� ��������� ������ �����-���� � ��������� ������ (CODE128 ��� B). � ������ ��������� ���������� ����� ���������� true
    function FPPrintQRCode(serialQR: string): boolean; //����� ��������� ������ QR-����. � ������ ��������� ���������� ����� ���������� true.
    function FPClaimUSBDevice: boolean; //����� ����������� ����� ����� � �� �� USB-���������� ����� WinUSB �������. ������ � �� �������������� ����� �������� ����� USB endpoints. � ������ ���������� �� � ������ USB-���������, � ����� ��������� ����������� � ���� ����� ����� true.
    function FPReleaseUSBDevice: boolean; //����� ��������� ���������� � �� �� USB-���������� � ����������� USB-����������

    function ModemInitialize(_COMportStr: byte): integer; //����� ��������� ����������� � ����������� ������.
                                                            //������ ���������� ����� ������ FPOpen ��� FPOpenStr ���������� �ICS_EP_09�.
                                                            //���������� 0, ���� ������������� ������ ��� ��� ������ � ������������ �
                                                            //�������� GetLastError() ��� GetLastWin32Error()
    function ModemAckuirerConnect: boolean; //����� ��������� ������� ����������� ����������� ������ � ����� �������� ��� �������� ������.
                                            //������� ������ ����������� ����� ����������� ����� ��������� �������� ������� �������� �� ����������� (������ �������
                                            //� ���������� ������������ ������). � ������ ��������� ���������� ����� ���������� true.
    function ModemAckuirerUnconditionalConnect: boolean; //����� ��������� ������� ����������� ����������� ������ � ����� �������� ��� �������� ������.
                                                         //������� ������ ����������� ����� ����������� �����, �� ��������� ��������� �������� ������� �������� �� �����������.
                                                         //� ������ ��������� ���������� ����� ���������� true.
    function ModemUpdateStatus: boolean; //����� ��������� ������ �������������� ������, �������� � ���������� ��� �������� ���������.
                                         //������ � ������ ����� �������� �� ��������������� �������. � ������ ��������� ���������� ����� ���������� true.
    function ModemVerifyPacket(packetID: Cardinal): boolean; //����� ��������� �������� ����������� ������ ������. � ������ ��������� ���������� ����� ���������� true.
    function ModemFindPacket(zReport: Integer; receiptNumber: integer; receiptType: byte): boolean; //����� ��������� ����� ������ �� �������� ���������� ������. � ������ ��������� ���������� ����� ���������� true
    function ModemKsefPacket(packetID: Cardinal): boolean; //����� ��������� ���������� ���������� � ��������� ������ ������ �� ���� � ��������� ���������� (��-�� prKsefSavePath) � ������� XML (��. ���������� 2). � ������ ��������� ���������� ����� ���������� true
    function ModemReadKsefRange(firstPacketID: Cardinal; lastPacketID: Cardinal): boolean; //����� ��������� ������ � ���������� ���������� ��������� ������� ������ �� ���� � ��������� ���������� (��-�� prKsefSavePath) � ������� XML (��. ���������� 2). � ������ ��������� ���������� ����� ���������� true
    function ModemReadKsefByZReport(zReport: Integer): boolean; //����� ��������� ���������� ���� ������� �����, ������������� ���������� � ��������� Z-������, �� ���� � ��������� ���������� (��-�� prKsefSavePath) � ������� XML (��. ���������� 2). � ������ ��������� ���������� ����� ���������� true.
    function ModemGetCurrentTask: boolean; //����� ���������� �������� ������� ������ ������. � ������ ��������� ���������� ����� ���������� true
    function ModemFindPacketByDateTime(findDateTime: TDateTime; findForward: boolean): boolean; //����� ��������� ����� ������ �� ��������� ����, ������� � ����������� ������. � ������ ��������� ���������� ����� ���������� true.
    function ModemFindPacketByDateTimeStr(findDateTimeStr: string; findForward: boolean): boolean; //����� ��������� ����� ������ �� ��������� ����, ������� � ����������� ������. ����� �������� ���������� ModemFindPacketByDateTime. � ������ ��������� ���������� ����� ���������� true.
    function ModemSaveKsefRangeToBin(directory: string; fileName: string; firstPacketID: Cardinal; lastPacketID: Cardinal): boolean; //����� ��������� �������� ������� ������ �� ���������� ���������
                                                                                                                                     //� �������� ������� � ��������� ���������� �� ����.
                                                                                                                                     //� ���������� ������� directory � filename ����� ����������
                                                                                                                                     //������ ��������. ���� � ��������� directory ��������� ������ ������,
                                                                                                                                     //�� ���� ����� ���� �� �������� prKsefSavePath.
                                                                                                                                     //���� ��� ���� ������ ��������, ����� ���� ��� ���������� �������� ������
                                                                                                                                     //������� ����� ����������� � ����������� �KSEF� �������� ��������.
                                                                                                                                     //���� � ��������� fileName ��������� ������ ������, �� ������� ��������
                                                                                                                                     //�������� ������ ������� � ����: ssssssssss�p�xxxx������� ��� ssssssssss�p�xxxx
                                                                                                                                     //(��� ������ ������),
                                                                                                                                     //��� ssssssssss � �������� ����� ��;
                                                                                                                                     //xxxx � ������ ������� ������ �� ���������;
                                                                                                                                     //yyyy � ������ ���������� ������ �� ���������.
                                                                                                                                     //��� �������� ������ ������� ����������� � ���� � ����������� �.ksf�.
                                                                                                                                     //� ������ ��������� ���������� ����� ���������� true.
    function ModemSaveKsefByZReportTobin(directory: string; fileName: string; zReport: integer): boolean; //����� ��������� �������� ���� ������� ������, ������������� � ���������� ������ ����� (������ Z-������) � ��������
                                                                                                          //������� � ��������� ���������� �� ����. � ���������� ������� directory � filename ����� ���������� ������ ��������.
                                                                                                          //���� � ��������� directory ��������� ������ ������, �� ���� ����� ���� �� �������� prKsefSavePath. ���� ��� ���� ������
                                                                                                          //��������, ����� ���� ��� ���������� �������� ������ ������� ����� ����������� � ����������� �KSEF� �������� ��������.
                                                                                                          //���� � ��������� fileName ��������� ������ ������, �� ������� �������� �������� ������ ������� � ����: ssssssssss�z�x,
                                                                                                          //��� ssssssssss � �������� ����� ��.
                                                                                                          //x � ����� ����� (Z � ������).
                                                                                                          //��� �������� ������ ������� ����������� � ���� � ���������� �.ksf�.
                                                                                                          //� ������ ��������� ���������� ����� ���������� true.

    property glPropertiesAutoUpdateMode: boolean read GetPropertiesAutoUpdateMod write SetPropertiesAutoUpdateMod; //true � ����� �������� ������ ������� ��� ���������� �������� ��������� � ������� �������.
                                                                                                                   //�� ��������� � false
    property glUseVirtualPort: boolean read GetUseVirtualPort write SetUseVirtualPort; //������������ ��� ���������� ������ ��������-��������� COM-����� ��� ����������� �� �� ���������� USB.
                                                                                       //�� ��������� � false.
    property glVirtualPortOpened: boolean read GetVirtualPortOpened; //����� �������������� ��� �������� ���������� ���������� � �� �� ���������� USB ����� ������� ������������ COM- �����.
                                                                     //����� ��������� ��������� glUseVirtualPort � true � ����������� � �� ������� FPOpen ������ ��� ��������� �� true. ��� ��������� ������ ������ ����� ��� ���������� ���������� ����� ��������� � ��������� false.
                                                                     //�� ��������� � false
    property glTapeAnalizer: boolean read GetTapeAnalizer write SetTapeAnalizer; //true � ������ ������� ������� ������ �����.
                                                                                 //�� ��������� � false
    property glCodepageOEM: boolean read GetCodepageOEM write SetCodepageOEM; //true � ������ � OEM ���������.
                                                                              //�� ��������� � false
    property glLangID: byte read GetLangID write SetLangID; //���� ������ ������:
                                                      //0 � ����������;
                                                      //1 � �������;
                                                      //2 � ����������.
                                                      //�� ��������� � 1
    property prRepeatCount: byte read GetRepeatCount write SetRepeatCount; //���������� �������� ������� ��� ���������� ������ ��� ������ � ������ �� ��.
                                                                           //�� ��������� � 2.
    property prLogRecording: boolean read GetLogRecording write SetLogRecording; //������� ��������� ������� ������ �������
                                                                                 //����������������� �����.
                                                                                 //�� ��������� � false.
    property prAnswerWaiting: byte read GetAnswerWaiting write SetAnswerWaiting; //��������� �������� �������� ������ �� ��.
                                                                                    //������ 1 = ������� 300 �� ��������.
                                                                                    //�� ��������� � 10 (3000 ��).
    property prGetStatusByte: byte read GetStatusByte; //���� ������� ��.
    property prGetResultByte: byte read GetResultByte; //��� ������ �� ��� ��������
    property prGetReserveByte: byte read GetReserveByte; //��� �������������� ������ ��������� ��

    property prGetErrorText: string read GetErrorText; //��������� �������� ������.
    property prPrinterError: boolean read  GetPrinterError; //������� ���������� ��������� ������ � ��������� ������:
                                                            //false � ��� ������;
                                                            //true � ������.
    property prTapeEnded: boolean read GetTapeEnded; //������� ���������� ����� � ��������� ������:
                                                     //false � ����� ����;
                                                     //true � ����� ���.
    property prTapeNearEnd: boolean read GetTapeNearEnd; //������� ������ ������� ����� � ��������� ������:
                                                         //false � ���;
                                                         //true � ��
    property prItemCost: Longint read GetItemCost; //��������� ������ � ���.
    property prSumTotal: Longint read GetSumTotal; //����� ���� � ���.
    property prSumBalance: Longint read GetSumBalance; //����� ������� ����� ���� � ���. (prSumBalance = 0)
    property prItemCostStr: string read GetItemCostStr; //��������� ������ � ���.
    property prSumTotalStr: string read GetSumTotalStr; //����� ���� � ���.
    property prSumBalanceStr: string read GetSumBalanceStr; //����� ������� ����� ���� � ���. (prSumBalance = 0)
    property prSumDiscount: Longint read GetSumDiscount; //����� ������ � ���.
    property prSumDiscountStr: string read GetSumDiscountStr; //����� ������ � ���.
    property prSumMarkup: Longint read GetSumMarkup; //����� ������� � ���.
    property prSumMarkupStr: string read GetSumMarkupStr; //����� ������� � ���
    property prKSEFPacket: Cardinal read GetKSEFPacket; //����� ������ ������
    property prKSEFPacketStr: string read GetKSEFPacketStr; //����� ������ � ���� ������.
    property prCurrentDate: TDateTime read GetCurrentDate; //������� ���� ��, ������������ ������� �� �����������.
    property prCurrentDateStr: string read GetCurrentDateStr; //������� ���� �� � ���� ������ � ������������� ����
    property prCurrentTime: TDateTime read GetCurrentTime; //������� ����� �� , ������������ ���� �� �����������.
    property prCurrentTimeStr: string read GetCurrentTimeStr; //������� ����� �� � ���� ������ � ������������� �������.
    property prModemError: byte read GetModemError; //��� ������ ������
    property prTaxRatesCount: byte read GetTaxRatesCount write SetTaxRatesCount; //���������� ������������ ��������� �����.
    property prAddTaxType: boolean read GetAddTaxType write SetAddTaxType; //��� ������: false � ���������; true � ����������
    property prTaxRate1: integer read GetTaxRate1 write SetTaxRate1; //������ ������ ��� � 0,01 %
    property prTaxRate2: integer read GetTaxRate2 write SetTaxRate2; //������ ������ ��� � 0,01 %
    property prTaxRate3: integer read GetTaxRate3 write SetTaxRate3; //������ ������ �» � 0,01 %
    property prTaxRate4: integer read GetTaxRate4 write SetTaxRate4; //������ ������ �û � 0,01 %
    property prTaxRate5: integer read GetTaxRate5 write SetTaxRate5; //������ ������ �Ļ � 0,01 %
    property prTaxRate6: integer read GetTaxRate6; //������ ������ �Ļ � 0,01 %
    property prUsedAdditionalFee: boolean read GetUsedAdditionalFee write SetUsedAdditionalFee; //���� ������������� ������: false � �� ������������; true � ������������.
    property prAddFeeRate1: integer read GetAddFeeRate1 write SetAddFeeRate1; //������ ����� ��� � 0,01 %
    property prAddFeeRate2: integer read GetAddFeeRate2 write SetAddFeeRate2; //������ ����� ��� � 0,01 %
    property prAddFeeRate3: integer read GetAddFeeRate3 write SetAddFeeRate3; //������ ����� �» � 0,01 %
    property prAddFeeRate4: integer read GetAddFeeRate4 write SetAddFeeRate4; //������ ����� �û � 0,01 %
    property prAddFeeRate5: integer read GetAddFeeRate5 write SetAddFeeRate5; //������ ����� �Ļ � 0,01 %
    property prAddFeeRate6: integer read GetAddFeeRate6 write SetAddFeeRate6; //������ ����� �Ż � 0,01 %
    property prTaxOnAddFee1: boolean read GetTaxOnAddFee1 write SetTaxOnAddFee1; //����� �� ���� ������ ���: false � �� �����������; true � �����������
    property prTaxOnAddFee2: boolean read GetTaxOnAddFee2 write SetTaxOnAddFee2; //����� �� ���� ������ ���: false � �� �����������; true � �����������
    property prTaxOnAddFee3: boolean read GetTaxOnAddFee3 write SetTaxOnAddFee3; //����� �� ���� ������ �»: false � �� �����������; true � �����������
    property prTaxOnAddFee4: boolean read GetTaxOnAddFee4 write SetTaxOnAddFee4; //����� �� ���� ������ �û: false � �� �����������; true � �����������
    property prTaxOnAddFee5: boolean read GetTaxOnAddFee5 write SetTaxOnAddFee5; //����� �� ���� ������ �Ļ: false � �� �����������; true � �����������
    property prTaxOnAddFee6: boolean read GetTaxOnAddFee6 write SetTaxOnAddFee6; //����� �� ���� ������ �Ż: false � �� �����������; true � �����������
    property prAddFeeOnRetailPrice1: boolean read GetAddFeeOnRetailPrice1 write SetAddFeeOnRetailPrice1; //���� �� ��������� ���� � ��� ��� ������ ���: false � �� �����������; true � �����������.
    property prAddFeeOnRetailPrice2: boolean read GetAddFeeOnRetailPrice2 write SetAddFeeOnRetailPrice2; //���� �� ��������� ���� � ��� ��� ������ ���: false � �� �����������; true � �����������.
    property prAddFeeOnRetailPrice3: boolean read GetAddFeeOnRetailPrice3 write SetAddFeeOnRetailPrice3; //���� �� ��������� ���� � ��� ��� ������ ���: false � �� �����������; true � �����������.
    property prAddFeeOnRetailPrice4: boolean read GetAddFeeOnRetailPrice4 write SetAddFeeOnRetailPrice4; //���� �� ��������� ���� � ��� ��� ������ ���: false � �� �����������; true � �����������.
    property prAddFeeOnRetailPrice5: boolean read GetAddFeeOnRetailPrice5 write SetAddFeeOnRetailPrice5; //���� �� ��������� ���� � ��� ��� ������ ���: false � �� �����������; true � �����������.
    property prAddFeeOnRetailPrice6: boolean read GetAddFeeOnRetailPrice6 write SetAddFeeOnRetailPrice6; //���� �� ��������� ���� � ��� ��� ������ ���: false � �� �����������; true � �����������.
    property prTaxRatesDate: TDateTime read GetTaxRatesDate; //���� ���������������� ��������� �����
    property prTaxRatesDateStr: string read GetTaxRatesDateStr; //���� ���������������� ��������� �����
    property prNamePaymentForm1: string read GetNamePaymentForm1; //�������� ����� ������ �1
    property prNamePaymentForm2: string read GetNamePaymentForm2; //�������� ����� ������ �2
    property prNamePaymentForm3: string read GetNamePaymentForm3; //�������� ����� ������ �3
    property prNamePaymentForm4: string read GetNamePaymentForm4; //�������� ����� ������ �4
    property prNamePaymentForm5: string read GetNamePaymentForm5; //�������� ����� ������ �5
    property prNamePaymentForm6: string read GetNamePaymentForm6; //�������� ����� ������ �6
    property prNamePaymentForm7: string read GetNamePaymentForm7; //�������� ����� ������ �7
    property prNamePaymentForm8: string read GetNamePaymentForm8; //�������� ����� ������ �8
    property prNamePaymentForm9: string read GetNamePaymentForm9; //�������� ����� ������ �9
    property prNamePaymentForm10: string read GetNamePaymentForm10; //�������� ����� ������ �10
    property prCashDrawerSum: Longint read GetCashDrawerSum; //����� �������� �������� �������, � �������� �����, ���.
    property prCashDrawerSumStr: string read GetCashDrawerSumStr; //����� �������� �������� �������, � �������� ����� � ��������� �������������, ���.
    property prCurrentZReport: Integer read GetCurrentZReport; //����� ������� �����
    property prCurrentZReportStr: string read GetCurrentZReportStr; //����� ������� ����� � ��������� �������������.
    property prDayEndDate: TDateTime read GetDayEndDate; //���� ����� �����, ������������ ������� ������������
    property prDayEndDateStr: string read GetDayEndDateStr; //���� ����� �����, �������������� � ���� ������ � ������������� ����
    property prDayEndTime: TDateTime read GetDayEndTime; //����� ����� �����, ������������ ���� ������������.
    property prDayEndTimeStr: string read GetDayEndTimeStr; //����� ����� �����, �������������� � ���� ������ � ������������� �������
    property prItemsCount: Integer read GetItemsCount; //���������� �������� ������� � ������ ��
    property prItemsCountStr: string read GetItemsCountStr; //���������� �������� ������� � ������ �� � ��������� �������������.
    property prLastZReportDate: TDateTime read GetLastZReportDate; //���� ���������� Z-������, ������������ ������� ������������.
    property prLastZReportDateStr: string read GetLastZReportDateStr; //���� ���������� Z-������, �������������� � ���� ������ � ������������� ����
    property prItemName: string read GetItemName; //�������� ������
    property prItemPrice: integer read GetItemPrice; //���� ������ � ���.
    property prItemTax: byte read GetItemTax; //������ ��������� ������ 1-� � 6-�)
    property prItemSaleQuantity: integer read GetItemSaleQuantity; //���������� ���������� ������ � ����������� ������� ���������
    property prItemSaleQtyPrecision: byte read GetItemSaleQtyPrecision; //������� �������� ���������� � ���������� 10 ��� ������� ������� ���������
    property prItemSaleSum: Longint read GetItemSaleSum; //����� ������ � ���
    property prItemSaleSumStr: string read GetItemSaleSumStr; //����� ������, � ��������� �������������, ���.
    property prItemRefundQuantity: integer read GetItemRefundQuantity; //���������� ������������ ������ � ����������� ������� ���������
    property prItemRefundQtyPrecision: byte read GetItemRefundQtyPrecision; //������� �������� ���������� � ���������� 10 ��� ������� ������� ���������
    property prItemRefundSum: Longint read GetItemRefundSum; //����� ������ � ���.
    property prItemRefundSumStr: string read GetItemRefundSumStr; //����� ������ � ��������� �������������, ���
    property prDaySaleReceiptsCount: integer read GetDaySaleReceiptsCount; //���������� ����� ������ �� �����.
    property prDaySaleReceiptsCountStr: string read GetDaySaleReceiptsCountStr; //���������� ����� ������ �� ����� � ��������� �������������.
    property prDayRefundReceiptsCount: integer read GetDayRefundReceiptsCount; //���������� ����� ������ �� �����.
    property prDayRefundReceiptsCountStr: string read GetDayRefundReceiptsCountStr; //���������� ����� ������ �� ����� � ��������� �������������
    property prDaySaleSumOnTax1: Cardinal read GetDaySaleSumOnTax1; //����� ������� ������ � ���. �� ��������� ������ ���
    property prDaySaleSumOnTax1Str: string read GetDaySaleSumOnTax1Str; //����� ������� ������ � ���. �� ��������� ������ ��� � ��������� �������������.
    property prDaySaleSumOnTax2: Cardinal read GetDaySaleSumOnTax2; //����� ������� ������ � ���. �� ��������� ������ ���
    property prDaySaleSumOnTax2Str: string read GetDaySaleSumOnTax2Str; //����� ������� ������ � ���. �� ��������� ������ ��� � ��������� �������������.
    property prDaySaleSumOnTax3: Cardinal read GetDaySaleSumOnTax3; //����� ������� ������ � ���. �� ��������� ������ �»
    property prDaySaleSumOnTax3Str: string read GetDaySaleSumOnTax3Str; //����� ������� ������ � ���. �� ��������� ������ �» � ��������� �������������.
    property prDaySaleSumOnTax4: Cardinal read GetDaySaleSumOnTax4; //����� ������� ������ � ���. �� ��������� ������ �û
    property prDaySaleSumOnTax4Str: string read GetDaySaleSumOnTax4Str; //����� ������� ������ � ���. �� ��������� ������ �û � ��������� �������������.
    property prDaySaleSumOnTax5: Cardinal read GetDaySaleSumOnTax5; //����� ������� ������ � ���. �� ��������� ������ �Ļ
    property prDaySaleSumOnTax5Str: string read GetDaySaleSumOnTax5Str; //����� ������� ������ � ���. �� ��������� ������ �Ļ � ��������� �������������.
    property prDaySaleSumOnTax6: Cardinal read GetDaySaleSumOnTax6; //����� ������� ������ � ���. �� ��������� ������ �Ż
    property prDaySaleSumOnTax6Str: string read GetDaySaleSumOnTax6Str; //����� ������� ������ � ���. �� ��������� ������ �Ż � ��������� �������������.
    property prDayRefundSumOnTax1: Cardinal read GetDayRefundSumOnTax1; //����� ������� ������ � ���. �� ��������� ������ ���.
    property prDayRefundSumOnTax1Str: string read GetDayRefundSumOnTax1Str; //����� ������� ������ � ���. �� ��������� ������ ��� � ��������� �������������.
    property prDayRefundSumOnTax2: Cardinal read GetDayRefundSumOnTax2; //����� ������� ������ � ���. �� ��������� ������ ���.
    property prDayRefundSumOnTax2Str: string read GetDayRefundSumOnTax2Str; //����� ������� ������ � ���. �� ��������� ������ ��� � ��������� �������������.
    property prDayRefundSumOnTax3: Cardinal read GetDayRefundSumOnTax3; //����� ������� ������ � ���. �� ��������� ������ �».
    property prDayRefundSumOnTax3Str: string read GetDayRefundSumOnTax3Str; //����� ������� ������ � ���. �� ��������� ������ �» � ��������� �������������.
    property prDayRefundSumOnTax4: Cardinal read GetDayRefundSumOnTax4; //����� ������� ������ � ���. �� ��������� ������ �û.
    property prDayRefundSumOnTax4Str: string read GetDayRefundSumOnTax4Str; //����� ������� ������ � ���. �� ��������� ������ �û � ��������� �������������.
    property prDayRefundSumOnTax5: Cardinal read GetDayRefundSumOnTax5; //����� ������� ������ � ���. �� ��������� ������ �Ļ.
    property prDayRefundSumOnTax5Str: string read GetDayRefundSumOnTax5Str; //����� ������� ������ � ���. �� ��������� ������ �Ļ � ��������� �������������.
    property prDayRefundSumOnTax6: Cardinal read GetDayRefundSumOnTax6; //����� ������� ������ � ���. �� ��������� ������ �Ż.
    property prDayRefundSumOnTax6Str: string read GetDayRefundSumOnTax6Str; //����� ������� ������ � ���. �� ��������� ������ �Ż � ��������� �������������.
    property prDaySaleSumOnPayForm1: Cardinal read GetDaySaleSumOnPayForm1; //����� ������� ������ � ���. �� ����� ����������.
    property prDaySaleSumOnPayForm1Str: string read GetDaySaleSumOnPayForm1Str; //����� ������� ������ � ���. �� ����� ���������� � ��������� �������������.
    property prDaySaleSumOnPayForm2: Cardinal read GetDaySaleSumOnPayForm2; //����� ������� ������ � ���. �� ����� ������һ.
    property prDaySaleSumOnPayForm2Str: string read GetDaySaleSumOnPayForm2Str; //����� ������� ������ � ���. �� ����� ������һ � ��������� �������������.
    property prDaySaleSumOnPayForm3: Cardinal read GetDaySaleSumOnPayForm3; //����� ������� ������ � ���. �� ����� ���ʻ.
    property prDaySaleSumOnPayForm3Str: string read GetDaySaleSumOnPayForm3Str; //����� ������� ������ � ���. �� ����� ���ʻ � ��������� �������������.
    property prDaySaleSumOnPayForm4: Cardinal read GetDaySaleSumOnPayForm4; //����� ������� ������ � ���. �� ����� ��������Ż.
    property prDaySaleSumOnPayForm4Str: string read GetDaySaleSumOnPayForm4Str; //����� ������� ������ � ���. �� ����� ��������Ż � ��������� �������������.
    property prDaySaleSumOnPayForm5: Cardinal read GetDaySaleSumOnPayForm5; //����� ������� ������ � ���. �� ����� ����������һ.
    property prDaySaleSumOnPayForm5Str: string read GetDaySaleSumOnPayForm5Str; //����� ������� ������ � ���. �� ����� ����������һ � ��������� �������������.
    property prDaySaleSumOnPayForm6: Cardinal read GetDaySaleSumOnPayForm6; //����� ������� ������ � ���. �� ����� ������л.
    property prDaySaleSumOnPayForm6Str: string read GetDaySaleSumOnPayForm6Str; //����� ������� ������ � ���. �� ����� ������л � ��������� �������������.
    property prDaySaleSumOnPayForm7: Cardinal read GetDaySaleSumOnPayForm7; //����� ������� ������ � ���. �� ����� ������������ �����Ȼ.
    property prDaySaleSumOnPayForm7Str: string read GetDaySaleSumOnPayForm7Str; //����� ������� ������ � ���. �� ����� ������������ �����Ȼ � ��������� �������������.
    property prDaySaleSumOnPayForm8: Cardinal read GetDaySaleSumOnPayForm8; //����� ������� ������ � ���. �� ����� ���������� ��������.
    property prDaySaleSumOnPayForm8Str: string read GetDaySaleSumOnPayForm8Str; //����� ������� ������ � ���. �� ����� ���������� �������� � ��������� �������������.
    property prDaySaleSumOnPayForm9: Cardinal read GetDaySaleSumOnPayForm9; //����� ������� ������ � ���. �� ����� ������������.
    property prDaySaleSumOnPayForm9Str: string read GetDaySaleSumOnPayForm9Str; //����� ������� ������ � ���. �� ����� ������������ � ��������� �������������
    property prDaySaleSumOnPayForm10: Cardinal read GetDaySaleSumOnPayForm10; //����� ������� ������ � ���. �� ����� ��������.
    property prDaySaleSumOnPayForm10Str: string read GetDaySaleSumOnPayForm10Str; //����� ������� ������ � ���. �� ����� �������� � ��������� �������������.
    property prDayRefundSumOnPayForm1: Cardinal read GetDayRefundSumOnPayForm1; //����� ������� ������ � ���. �� ����� ����������.
    property prDayRefundSumOnPayForm2: Cardinal read GetDayRefundSumOnPayForm2; //����� ������� ������ � ���. �� ����� ������һ.
    property prDayRefundSumOnPayForm3: Cardinal read GetDayRefundSumOnPayForm3; //����� ������� ������ � ���. �� ����� ���ʻ.
    property prDayRefundSumOnPayForm4: Cardinal read GetDayRefundSumOnPayForm4; //����� ������� ������ � ���. �� ����� ��������Ż.
    property prDayRefundSumOnPayForm5: Cardinal read GetDayRefundSumOnPayForm5; //����� ������� ������ � ���. �� ����� ����������һ.
    property prDayRefundSumOnPayForm6: Cardinal read GetDayRefundSumOnPayForm6; //����� ������� ������ � ���. �� ����� ������л.
    property prDayRefundSumOnPayForm7: Cardinal read GetDayRefundSumOnPayForm7; //����� ������� ������ � ���. �� ����� ������������ �����Ȼ.
    property prDayRefundSumOnPayForm8: Cardinal read GetDayRefundSumOnPayForm8; //����� ������� ������ � ���. �� ����� ���������� ��������.
    property prDayRefundSumOnPayForm9: Cardinal read GetDayRefundSumOnPayForm9; //����� ������� ������ � ���. �� ����� ������������.
    property prDayRefundSumOnPayForm10: Cardinal read GetDayRefundSumOnPayForm10; //����� ������� ������ � ���. �� ����� ��������.
    property prDayRefundSumOnPayForm1Str: string read GetDayRefundSumOnPayForm1Str; //����� ������� ������ � ���. �� ����� ���������� � ��������� �������������.
    property prDayRefundSumOnPayForm2Str: string read GetDayRefundSumOnPayForm2Str; //����� ������� ������ � ���. �� ����� ������һ � ��������� �������������.
    property prDayRefundSumOnPayForm3Str: string read GetDayRefundSumOnPayForm3Str; //����� ������� ������ � ���. �� ����� ���ʻ � ��������� �������������.
    property prDayRefundSumOnPayForm4Str: string read GetDayRefundSumOnPayForm4Str; //����� ������� ������ � ���. �� ����� ��������Ż � ��������� �������������.
    property prDayRefundSumOnPayForm5Str: string read GetDayRefundSumOnPayForm5Str; //����� ������� ������ � ���. �� ����� ����������һ � ��������� �������������
    property prDayRefundSumOnPayForm6Str: string read GetDayRefundSumOnPayForm6Str; //����� ������� ������ � ���. �� ����� ������л � ��������� �������������.
    property prDayRefundSumOnPayForm7Str: string read GetDayRefundSumOnPayForm7Str; //����� ������� ������ � ���. �� ����� ������������ �����Ȼ � ��������� �������������.
    property prDayRefundSumOnPayForm8Str: string read GetDayRefundSumOnPayForm8Str; //����� ������� ������ � ���. �� ����� ���������� �������� � ��������� �������������.
    property prDayRefundSumOnPayForm9Str: string read GetDayRefundSumOnPayForm9Str; //����� ������� ������ � ���. �� ����� ������������ � ��������� �������������.
    property prDayRefundSumOnPayForm10Str: string read GetDayRefundSumOnPayForm10Str; //����� ������� ������ � ���. �� ����� �������� � ��������� �������������.
    property prDayDiscountSumOnSales: Cardinal read GetDayDiscountSumOnSales; //����� ������ � ���. � ������.
    property prDayDiscountSumOnSalesStr: string read GetDayDiscountSumOnSalesStr; //����� ������ � ���. � ������ � ��������� �������������
    property prDayDiscountSumOnRefunds: Cardinal read GetDayDiscountSumOnRefunds; //����� ������ � ���. � ������.
    property prDayDiscountSumOnRefundsStr: string read GetDayDiscountSumOnRefundsStr; //����� ������ � ���. � ������ � ��������� �������������
    property prDayMarkupSumOnSales: Cardinal read GetDayMarkupSumOnSales; //����� ������� � ���. � ������.
    property prDayMarkupSumOnSalesStr: string read GetDayMarkupSumOnSalesStr; //����� ������� � ���. � ������ � ��������� �������������.
    property prDayMarkupSumOnRefunds: Cardinal read GetDayMarkupSumOnRefunds; //����� ������� � ���. � ������.
    property prDayMarkupSumOnRefundsStr: string read GetDayMarkupSumOnRefundsStr; //����� ������� � ���. � ������ � ��������� �������������.
    property prDayCashInSum: Cardinal read GetDayCashInSum; //����� ��������� �������� � ���.
    property prDayCashInSumStr: string read GetDayCashInSumStr; //����� ��������� �������� � ���. � ��������� �������������.
    property prDayCashOutSum: Cardinal read GetDayCashOutSum; //����� ��������� ������� � ���.
    property prDayCashOutSumStr: string read GetDayCashOutSumStr; //����� ��������� ������� � ���. � ��������� �������������.
    property prCurReceiptTax1Sum: Cardinal read GetCurReceiptTax1Sum; //����� ���� � ���. �� ��������� ������ ���.
    property prCurReceiptTax2Sum: Cardinal read GetCurReceiptTax2Sum; //����� ���� � ���. �� ��������� ������ ���.
    property prCurReceiptTax3Sum: Cardinal read GetCurReceiptTax3Sum; //����� ���� � ���. �� ��������� ������ �».
    property prCurReceiptTax4Sum: Cardinal read GetCurReceiptTax4Sum; //����� ���� � ���. �� ��������� ������ �û.
    property prCurReceiptTax5Sum: Cardinal read GetCurReceiptTax5Sum; //����� ���� � ���. �� ��������� ������ �Ļ.
    property prCurReceiptTax6Sum: Cardinal read GetCurReceiptTax6Sum; //����� ���� � ���. �� ��������� ������ �Ż.
    property prCurReceiptTax1SumStr: string read GetCurReceiptTax1SumStr; //����� ���� � ���. �� ��������� ������ ��� � ��������� �������������
    property prCurReceiptTax2SumStr: string read GetCurReceiptTax2SumStr; //����� ���� � ���. �� ��������� ������ ��� � ��������� �������������
    property prCurReceiptTax3SumStr: string read GetCurReceiptTax3SumStr; //����� ���� � ���. �� ��������� ������ �» � ��������� �������������
    property prCurReceiptTax4SumStr: string read GetCurReceiptTax4SumStr; //����� ���� � ���. �� ��������� ������ �û � ��������� �������������
    property prCurReceiptTax5SumStr: string read GetCurReceiptTax5SumStr; //����� ���� � ���. �� ��������� ������ �Ļ � ��������� �������������
    property prCurReceiptTax6SumStr: string read GetCurReceiptTax6SumStr; //����� ���� � ���. �� ��������� ������ �Ż � ��������� �������������
    property prCurReceiptPayForm1Sum: Cardinal read GetCurReceiptPayForm1Sum; //����� ���� � ���. �� ����� ������ ����������.
    property prCurReceiptPayForm2Sum: Cardinal read GetCurReceiptPayForm2Sum; //����� ���� � ���. �� ����� ������ ������һ.
    property prCurReceiptPayForm3Sum: Cardinal read GetCurReceiptPayForm3Sum; //����� ���� � ���. �� ����� ������ ���ʻ.
    property prCurReceiptPayForm4Sum: Cardinal read GetCurReceiptPayForm4Sum; //����� ���� � ���. �� ����� ������ ��������Ż.
    property prCurReceiptPayForm5Sum: Cardinal read GetCurReceiptPayForm5Sum; //����� ���� � ���. �� ����� ������ ����������һ.
    property prCurReceiptPayForm6Sum: Cardinal read GetCurReceiptPayForm6Sum; //����� ���� � ���. �� ����� ������ ������л.
    property prCurReceiptPayForm7Sum: Cardinal read GetCurReceiptPayForm7Sum; //����� ���� � ���. �� ����� ������ ������������ �����Ȼ.
    property prCurReceiptPayForm8Sum: Cardinal read GetCurReceiptPayForm8Sum; //����� ���� � ���. �� ����� ������ ���������� ��������.
    property prCurReceiptPayForm9Sum: Cardinal read GetCurReceiptPayForm9Sum; //����� ���� � ���. �� ����� ������ ������������.
    property prCurReceiptPayForm10Sum: Cardinal read GetCurReceiptPayForm10Sum; //����� ���� � ���. �� ����� ������ ��������.
    property prCurReceiptPayForm1SumStr: string read GetCurReceiptPayForm1SumStr; //����� ���� � ���. �� ����� ������ ���������� � ��������� �������������.
    property prCurReceiptPayForm2SumStr: string read GetCurReceiptPayForm2SumStr; //����� ���� � ���. �� ����� ������ ������һ � ��������� �������������.
    property prCurReceiptPayForm3SumStr: string read GetCurReceiptPayForm3SumStr; //����� ���� � ���. �� ����� ������ ���ʻ � ��������� �������������.
    property prCurReceiptPayForm4SumStr: string read GetCurReceiptPayForm4SumStr; //����� ���� � ���. �� ����� ������ ��������Ż � ��������� �������������.
    property prCurReceiptPayForm5SumStr: string read GetCurReceiptPayForm5SumStr; //����� ���� � ���. �� ����� ������ ����������һ � ��������� �������������
    property prCurReceiptPayForm6SumStr: string read GetCurReceiptPayForm6SumStr; //����� ���� � ���. �� ����� ������ ������л � ��������� �������������.
    property prCurReceiptPayForm7SumStr: string read GetCurReceiptPayForm7SumStr; //����� ���� � ���. �� ����� ������ ������������ �����Ȼ � ��������� �������������.
    property prCurReceiptPayForm8SumStr: string read GetCurReceiptPayForm8SumStr; //����� ���� � ���. �� ����� ������ ���������� �������� � ��������� �������������.
    property prCurReceiptPayForm9SumStr: string read GetCurReceiptPayForm9SumStr; //����� ���� � ���. �� ����� ������ ������������ � ��������� �������������.
    property prCurReceiptPayForm10SumStr: string read GetCurReceiptPayForm10SumStr; //����� ���� � ���. �� ����� ������ �������� � ��������� �������������.
    property prDayAnnuledSaleReceiptsCount: Integer read GetDayAnnuledSaleReceiptsCount; //���������� �������������� ����� ������.
    property prDayAnnuledSaleReceiptsCountStr: string read GetDayAnnuledSaleReceiptsCountStr; //���������� �������������� ����� ������ � ��������� �������������.
    property prDayAnnuledSaleReceiptsSum: Cardinal read GetDayAnnuledSaleReceiptsSum; //����� ����� �������������� ����� ������, ���
    property prDayAnnuledSaleReceiptsSumStr: string read GetDayAnnuledSaleReceiptsSumStr; //����� ����� �������������� ����� ������ � ��������� �������������, ���
    property prDayAnnuledRefundReceiptsCount: integer read GetDayAnnuledRefundReceiptsCount; //���������� �������������� ����� ������.
    property prDayAnnuledRefundReceiptsCountStr: string read GetDayAnnuledRefundReceiptsCountStr; //���������� �������������� ����� ������ � ��������� �������������.
    property prDayAnnuledRefundReceiptsSum: Cardinal read GetDayAnnuledRefundReceiptsSum; //����� ����� �������������� ����� ������, ���.
    property prDayAnnuledRefundReceiptsSumStr: string read GetDayAnnuledRefundReceiptsSumStr; //����� ����� �������������� ����� ������ � ��������� �������������, ���.
    property prDaySaleCancelingsCount: Integer read GetDaySaleCancelingsCount; //���������� ����� � ����� ������.
    property prDaySaleCancelingsCountStr: string read GetDaySaleCancelingsCountStr; //���������� ����� � ����� ������ � ��������� �������������.
    property prDaySaleCancelingsSum: Cardinal read GetDaySaleCancelingsSum; //����� ����� ����� � ����� ������, ���.
    property prDaySaleCancelingsSumStr: String read GetDaySaleCancelingsSumStr; //����� ����� ����� � ����� ������ � ��������� �������������, ���.
    property prDayRefundCancelingsCount: Integer read GetDayRefundCancelingsCount; //���������� ����� � ����� ������.
    property prDayRefundCancelingsCountStr: string read GetDayRefundCancelingsCountStr; //���������� ����� � ����� ������ � ��������� �������������.
    property prDayRefundCancelingsSum: Cardinal read GetDayRefundCancelingsSum; //����� ����� ����� � ����� ������, ���
    property prDayRefundCancelingsSumStr: string read GetDayRefundCancelingsSumStr; //����� ����� ����� � ����� ������ � ��������� �������������, ���
    property prDaySumAddTaxOfSale1: Cardinal read GetDaySumAddTaxOfSale1; //����� ������ � ������ �� ������ ���, ���.
    property prDaySumAddTaxOfSale2: Cardinal read GetDaySumAddTaxOfSale2; //����� ������ � ������ �� ������ ���, ���.
    property prDaySumAddTaxOfSale3: Cardinal read GetDaySumAddTaxOfSale3; //����� ������ � ������ �� ������ �», ���.
    property prDaySumAddTaxOfSale4: Cardinal read GetDaySumAddTaxOfSale4; //����� ������ � ������ �� ������ �û, ���.
    property prDaySumAddTaxOfSale5: Cardinal read GetDaySumAddTaxOfSale5; //����� ������ � ������ �� ������ �Ļ, ���.
    property prDaySumAddTaxOfSale6: Cardinal read GetDaySumAddTaxOfSale6; //����� ������ � ������ �� ������ �Ż, ���.
    property prDaySumAddTaxOfSale1Str: string read GetDaySumAddTaxOfSale1Str; //����� ������ � ������ �� ������ ��� � ��������� �������������, ���.
    property prDaySumAddTaxOfSale2Str: string read GetDaySumAddTaxOfSale2Str; //����� ������ � ������ �� ������ ��� � ��������� �������������, ���.
    property prDaySumAddTaxOfSale3Str: string read GetDaySumAddTaxOfSale3Str; //����� ������ � ������ �� ������ �» � ��������� �������������, ���.
    property prDaySumAddTaxOfSale4Str: string read GetDaySumAddTaxOfSale4Str; //����� ������ � ������ �� ������ �û � ��������� �������������, ���.
    property prDaySumAddTaxOfSale5Str: string read GetDaySumAddTaxOfSale5Str; //����� ������ � ������ �� ������ �Ļ � ��������� �������������, ���.
    property prDaySumAddTaxOfSale6Str: string read GetDaySumAddTaxOfSale6Str; //����� ������ � ������ �� ������ �Ż � ��������� �������������, ���.
    property prDaySumAddTaxOfRefund1: Cardinal read GetDaySumAddTaxOfRefund1; //����� ������ � ������ �� ������ ���, ���.
    property prDaySumAddTaxOfRefund2: Cardinal read GetDaySumAddTaxOfRefund2; //����� ������ � ������ �� ������ ���, ���.
    property prDaySumAddTaxOfRefund3: Cardinal read GetDaySumAddTaxOfRefund3; //����� ������ � ������ �� ������ �», ���.
    property prDaySumAddTaxOfRefund4: Cardinal read GetDaySumAddTaxOfRefund4; //����� ������ � ������ �� ������ �û, ���.
    property prDaySumAddTaxOfRefund5: Cardinal read GetDaySumAddTaxOfRefund5; //����� ������ � ������ �� ������ �Ļ, ���.
    property prDaySumAddTaxOfRefund6: Cardinal read GetDaySumAddTaxOfRefund6; //����� ������ � ������ �� ������ �Ż, ���.
    property prDaySumAddTaxOfRefund1Str: string read GetDaySumAddTaxOfRefund1Str; //����� ������ � ������ �� ������ ��� � ��������� �������������, ���.
    property prDaySumAddTaxOfRefund2Str: string read GetDaySumAddTaxOfRefund2Str; //����� ������ � ������ �� ������ ��� � ��������� �������������, ���.
    property prDaySumAddTaxOfRefund3Str: string read GetDaySumAddTaxOfRefund3Str; //����� ������ � ������ �� ������ �» � ��������� �������������, ���.
    property prDaySumAddTaxOfRefund4Str: string read GetDaySumAddTaxOfRefund4Str; //����� ������ � ������ �� ������ �û � ��������� �������������, ���.
    property prDaySumAddTaxOfRefund5Str: string read GetDaySumAddTaxOfRefund5Str; //����� ������ � ������ �� ������ �Ļ � ��������� �������������, ���.
    property prDaySumAddTaxOfRefund6Str: string read GetDaySumAddTaxOfRefund6Str; //����� ������ � ������ �� ������ �Ż � ��������� �������������, ���.
    property prSerialNumber: string read GetSerialNumber; //������ ��������� ������ ��.
    property prFiscalNumber: string read GetFiscalNumber; //������ ������������ ����������� ������ ��.
    property prTaxNumber: string read GetTaxNumber; //������ ���������� ��� ������������������ ������ ����������� �������.
    property prDateFiscalization: TDateTime read GetDateFiscalization; //���� ����������� ��, ������������ ������� �� �����������
    property prDateFiscalizationStr: string read GetDateFiscalizationStr; //���� ����������� ��, � ��������� ������������� � ������������� ����.
    property prTimeFiscalization: TDateTime read GetTimeFiscalization; //����� ����������� ��, ������������ ���� �� �����������.
    property prTimeFiscalizationStr: string read GetTimeFiscalizationStr; //����� ����������� ��, � ��������� ������������� � ������������� �������.
    property prHardwareVersion: string read GetHardwareVersion; //������������� ������ ����������� ������������ ����������� ��.
    property prHeadLine1: string read GetHeadLine1; //����� 1-� ������ ���������
    property prHeadLine2: string read GetHeadLine2; //����� 1-� ������ ���������
    property prHeadLine3: string read GetHeadLine3; //����� 1-� ������ ���������
    property stUseAdditionalFee: boolean read GetUseAdditionalFee; //������� ������������� �������������� ������: false - �� ������������; true - ������������
    property stUseAdditionalTax: boolean read GetUseAdditionalTax; //���� ���������������: false - ���������; true - ����������.
    property stUseCutter: boolean read GetUseCutter; //������� ��������� ���������: false - ��������; true - �������
    property stUseFontB: boolean read GetUseFontB; //������� ������: false - ����� ��� (12x24); true - ����� ��� (9x24).
    property stUseTradeLogo: boolean read GetUseTradeLogo; //������� ������ ��������: false - �� ����������; true - ����������.
    property stCashDrawerIsOpened: boolean read GetCashDrawerIsOpened; //������� ��������� �����: false - ������; true - ������
    property stFailureLastCommand: boolean read GetFailureLastCommand; //������� ���������� �������: false - ���������; true - ��������
    property stFiscalDayIsOpened: boolean read GetFiscalDayIsOpened; //������� ��������� �����: false - �������; true - �������.
    property stReceiptIsOpened: boolean read GetReceiptIsOpened; //������� ��������� ����: false - ������; true - ������.
    property stFiscalMode: boolean read GetFiscalMode; //������� ������ ������: false - �� ����������; true - ����������
    property stOnlinePrintMode: boolean read GetOnlinePrintMode; //������� ������ ������ �����: false - �������; true - ������.
    property stPaymentMode: boolean read GetPaymentMode; //������� ������ �����: false - ����� �����������; true - ����� �����
    property stDisplayShowSumMode: boolean read GetDisplayShowSumMode; //������� ������ ������ ���� �� ������� ����������: false - ����������������; true - ����������
    property stRefundReceiptMode: boolean read GetRefundReceiptMode; //������� ���� ����: false - ��� �������; true - ��� �������.
    property stServiceReceiptMode: boolean read GetServiceReceiptMode; //������� ���������� ������: false - ������; true - ������
    property prUserPassword: byte read GetUserPassword; //�������� ������ ������������ �� 0 �� 65535. �� ��������� = 0.
    property prUserPasswordStr: string read GetUserPasswordStr; //�������� ������ ������������ �� 0 �� 65535 � ���� ������. �� ��������� = 0.
    property prFPDriverMajorVersion: byte read GetFPDriverMajorVersion; //������ ������
    property prFPDriverMinorVersion: byte read GetFPDriverMinorVersion; //������ ���������
    property prFPDriverReleaseVersion: byte read GetFPDriverReleaseVersion; //������ ������
    property prFPDriverBuildVersion: byte read GetFPDriverBuildVersion; //������ ������
    property prKsefSavePath: string read GetKsefSavePath write SetKsefSavePath; //����� ���� ��� ���������� ���������� ������� �� ������. �� ��������� ���� �� ����� � ����������� � �������� � ���������.
    property glPropertiesModemAutoUpdateMode: boolean read GetPropertiesModemAutoUpdateMode write SetPropertiesModemAutoUpdateMode; //true � ����� �������� ������ ������� ��� ���������� �������� ��������� � ������� �������. �� ��������� � false
    property glModemCodepageOEM: boolean read GetModemCodepageOEM write SetModemCodepageOEM; //true � ������ � OEM ���������. �� ��������� � false.
    property glModemLangID: byte read GetModemLangID write SetModemLangID; //���� ������ ������: 0 � ����������; 1 � �������; 2 � ����������. �� ��������� � 1.
    property prModemRepeatCount: byte read GetModemRepeatCount write SetModemRepeatCount; //���������� �������� ������� ��� ���������� ������ ��� ������ � ������ �� ������. �� ��������� � 2.
    property prModemLogRecording: boolean read GetModemLogRecording write SetModemLogRecording; //������� ��������� ������� ������ ������� ����������������� �����. �� ��������� � false
    property prModemAnswerWaiting: byte read GetModemAnswerWaiting write SetModemAnswerWaiting; //��������� �������� �������� ������ �� ������. ������ 1 = ������� 300 �� ��������. �� ��������� � 10 (3000 ��).
    property prModemKsefSavePath: string read GetModemKsefSavePath write SetModemKsefSavePath; //����� ���� ��� ���������� ���������� ������� �� ������. �� ��������� ���� �� ����� � ����������� � �������� � ���������.
    property prGetModemErrorCode: byte read GetModemErrorCode; //��� ������ ������
    property prGetModemErrorText: string read GetModemErrorText; //��������� �������� ������
    property stModemWorkSecondCount: Longint read GetModemWorkSecondCount; //����� � �������� � ������� ��������� ��.
    property stFPExchangeModemSecondCount: Longint read GetFPExchangeModemSecondCount; //����� ���������� ���������� ������ � �� � �������� (� ������� ��������� ��). 2147483647 � ����������
    property stModemFirstUnsendPIDDateTime: TDateTime read GetModemFirstUnsendPIDDateTime; //����/����� ������� �� ����������� �������� ������ (�� ����� ��). 07.02.2136 6:28:15 � ��� ��������� �������� �������
    property stModemFirstUnsendPIDDateTimeStr: string read GetModemFirstUnsendPIDDateTimeStr; //����/����� ������� �� ����������� �������� ������ (�� ����� ��) � ��������� �������������. 07.02.2136 6:28:15� � ��� ��������� �������� �������
    property stModemPID_Unused: Longint read GetModemPID_Unused; //����� ������� ���������� ������. 2147483647 � SD-����� �� ����������������.
    property stModemPID_CurPers: Longint read GetModemPID_CurPers; //����� ������ ������� ��������������. 2147483647 � ����� �� ���� �� ����������������.
    property stModemPID_LastWrite: Longint read GetModemPID_LastWrite; //����� ���������� ���������� �� �� � ����������� �� SD-����� ������. 2147483647 � ��� �� ������ ����������� ������ �� SD-�����.
    property stModemPID_LastSign: Longint read GetModemPID_LastSign; //����� ���������� ������������ ������ ������� ������������. 2147483647 � ��� �� ������ ������������ ������.
    property stModemPID_LastSend: Longint read GetModemPID_LastSend; //����� ���������� ����������� �������� ������. 2147483647 � ��� �� ������ ����������� ������.
    property stModemSerialNumber: Longint read GetModemSerialNumber; //�������� ����� ������
    property stModemID_DEV: Longint read GetModemID_DEV; //������������� ������
    property stModemID_SAM: Longint read GetModemID_SAM; //������������� ������ ������������
    property stModemNT_SESSION: Longint read GetModemNT_SESSION; //������� ������� ����� � ���������.
    property stModemFailCode: byte read GetModemFailCode; //��� ������ ������:
                                                          //0 � ��� ������;
                                                          //1� ������ ������������� �������� ��;
                                                          //2 � ��������� �� ���������� �� ����� ������ ������;
                                                          //3 � �������� ������������� � ��������� ������� ����� �� � �������;
                                                          //4 � ������ ���� ��� Z-������, ��������� �� ��, �����������;
                                                          //32 � ������ ������������� ���� (SD-�����);
                                                          //33 � ���� ����������;
                                                          //34 � ������ �������� ������ ����;
                                                          //35 � ������ ������ ������ ����;
                                                          //36 � ������������ ����;
                                                          //64 � ������ ������������� ������ ������������;
                                                          //65 � ������ �������������� � ������� ������������;
                                                          //66 � ������ ������������ �������;
                                                          //96 � ������� ��������� �������������� ID_DEV+ID_SAM ��� ���������� ��������������� ������.
    property stModemRes1: byte read GetModemRes1; //�� ������������.
    property stModemBatVoltage: Longint read GetModemBatVoltage; //�� ������������.
    property stModemDCVoltage: Longint read GetModemDCVoltage; //�� ������������.
    property stModemBatCurrent: Longint read GetModemBatCurrent; //�� ������������.
    property stModemTemperature: Longint read GetModemTemperature; //�� ������������.
    property stModemState1: byte read GetModemState1; //�� ������������.
    property stModemState2: byte read GetModemState2; //�� ������������.
    property stModemState3: byte read GetModemState3; //������ IP � ����������:
                                                  //0 � Initial;
                                                  //1 � Starting;
                                                  //2 � Closed;
                                                  //3 � Stopped;
                                                  //4 � Closing;
                                                  //5 � Stopping;
                                                  //6 � ReqSent;
                                                  //7 � AckRcvd;
                                                  //8 � AcqSent;
                                                  //9 � Opened (���������� �����������)
    property stModemLanState1: byte read GetModemLanState1; //��������� Ethernet TP PHYS Layer:
                                                            //0 � LMS_NONE;
                                                            //1 � LMS_POR_WAIT;
                                                            //2 � LMS_RESET;
                                                            //3 � LMS_RESET_WAIT;
                                                            //4 � LMS_PHL_ON;
                                                            //5 � LMS_PHL_ON_WAIT;
                                                            //6 � LMS_PHL_ON_WAIT1;
                                                            //7 � LMS_PHL_ON_WAIT2;
                                                            //8 � LMS_PHL_ON_WAIT3;
                                                            //9 � LMS_MAIN (�������).
    property stModemLanState2: byte read GetModemLanState2; //��������� DHCP:
                                                            //0 � DHCP_NONE;
                                                            //1 � DHCP_START;
                                                            //2 � DHCP_SEND_DISCOVER;
                                                            //131 � DHCP_WAIT_OFFER;
                                                            //4 � DHCP_SEND_REQUEST;
                                                            //133 � DHCP_WAIT_ACK;
                                                            //6 � DHCP_CHECK_LEASTIME (��������������� �������)
    property stModemFPExchangeResult: byte read GetModemFPExchangeResult; //��������� ������ ����� � ��:
                                                                          //0 � ��� ������;
                                                                          //1 � ����� ������;
                                                                          //2 � ������ ������ ������ �����;
                                                                          //3 � ������ ��������� ������ ��������������;
                                                                          //4 � ������ ������ ��������� ���������� ����;
                                                                          //5 � ������ ������ ������ ����;
                                                                          //6 � ������ �������� ������ ����;
                                                                          //7 � ������ ������ ������ ����;
                                                                          //8 � �� �� � ���������� ������.
                                                                          //251 � ������ ����� � �� �� ������������ ������;
                                                                          //252 � �� �����;
                                                                          //253 � �������� ������� �� ������������ ������;
                                                                          //254 � ������� ����� � ��;
                                                                          //255 � ����� ������ ������ � ��.
    property stModemACQExchangeResult: byte read GetModemACQExchangeResult; //��������� ������ ����� � ���������:
                                                                            //0 � ��� ������;
                                                                            //1 � ����� ������;
                                                                            //2 � ������� ������ �����;
                                                                            //3 � ������ ������ ��������� ���������� ����;
                                                                            //4 � ������ ������ ������ ����;
                                                                            //5 � ������ ������ ������ ����;
                                                                            //6 � ������������ ����� ��������� ���;
                                                                            //7 � ������������ ��� ��������� ���������� ���;
                                                                            //8 � ������ ��� �������� MAC;
                                                                            //9 � ������ ������������ ����;
                                                                            //240 � ������ ������������ ���������� � ���������;
                                                                            //241 � ������� ������ ���������� � ������ ID_DEV;
                                                                            //242 � ���������� ������ ������;
                                                                            //243 � ������� �������� ������ �� ��������;
                                                                            //244 � ������� ���������� ������ TCP-����������;
                                                                            //245 � �������� ������ ������ ��������;
                                                                            //246 � ��������� ������������ ���������� ������� ������� �������� ����������;
                                                                            //247 � ������� ���������� ������ ������.
    property stModemRes2: byte read GetModemRes2; //�� ������������.
    property stModemFPExchangeErrorCount: Longint read GetModemFPExchangeErrorCount; //���������� ��������� ������� ����� � �� � ������� ���������� �������� ������.
    property stModemRSSI: byte read GetModemRSSI; //�� ������������.
    property stModemRSSI_BER: byte read GetModemRSSI_BER; //�� ������������.
    property stModemUSSDResult: string read GetModemUSSDResult; //�� ������������.
    property stModemOSVer: Longint read GetModemOSVer; //������ ��.
    property stModemOSRev: Longint read GetModemOSRev; //������� ��.
    property stModemSysTime: TDateTime read GetModemSysTime; //��������� ���� � �����.
    property stModemSysTimeStr: string read GetModemSysTimeStr; //��������� ���� � ����� � ��������� �������������
    property stModemNETIPAddr: string read GetModemNETIPAddr; //IP � ����� �������� ����������.
    property stModemNETGate: string read GetModemNETGate; //IP � ����� ����� ��� �������� ����������.
    property stModemNETMask: string read GetModemNETMask; //����� ���� ��� �������� ����������
    property stModemMODIPAddr: string read GetModemMODIPAddr; //�� ������������.
    property stModemACQIPAddr: string read GetModemACQIPAddr; //IP � ����� ��������.
    property stModemACQPort: Longint read GetModemACQPort; //���� ��������.
    property stModemACQExchangeSecondCount: Longint read GetModemACQExchangeSecondCount; //����� ���������� ���������� ������ ����� � ��������� � �������� �� ������� ��������� ��.
    property prModemFoundPacket: Cardinal read GetModemFoundPacket; //����� ���������� ������.
    property prModemFoundPacketStr: string read GetModemFoundPacketStr; //����� ���������� ������ � ��������� �������������
    property prModemCurrentTaskCode: byte read GetModemCurrentTaskCode; //��� ������� ������ ������.
                                                                        //0 � ��� ������
                                                                        //1 � ������ ��������������� �����������
                                                                        //2 � ��������������
                                                                        //3 � ���������� ������ ����
                                                                        //4 � ����� � ���������
                                                                        //5 � ������������ ������ ����
                                                                        //255 � ����������
    property prModemCurrentTaskText: string read GetModemCurrentTaskText; //��������� �������� ������.
    property prModemDriverMajorVersion: Byte read GetModemDriverMajorVersion; //������ ������
    property prModemDriverMinorVersion: byte read GetModemDriverMinorVersion; //������ ���������
    property prModemDriverReleaseVersion: byte read GetModemDriverReleaseVersion; //������ ������
    property prModemDriverBuildVersion: byte read GetModemDriverBuildVersion; //������ ������

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
  Result:=ics.prCurrentZReportStr�
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
