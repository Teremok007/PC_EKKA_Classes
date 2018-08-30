{*******************************************************}
{                                                       }
{                       EhLib v3.2                      }
{          Register object that sort data in            }
{                TMSDataSet, TMSQuery     (By LSV)      }
{                                                       }
{   Copyright (c) 2002, 2003 by Dmitry V. Bolshakov     }
{                                                       }
{*******************************************************}

{*******************************************************}
{ Add this unit to 'uses' clause of any unit of your    }
{ project to allow TDBGridEh to sort data in            }
{ TMSQuery  automatically after sorting markers         }
{ will be changed.                                      }
{ TSQLDatasetFeaturesEh will try to find line in        }
{ TMSQuery.SQL string that begin from 'ORDER BY'phrase  }
{ and replace line by 'ORDER BY FieldNo1 [DESC],....'   }
{ using SortMarkedColumns.                              }
{*******************************************************}

unit EhLibSDAC;

{$I EhLib.Inc}

interface

uses
  DbUtilsEh, DB, sysutils, DBGridEh, MSAccess;

implementation

uses Classes;

function SDACDataSetDriverName(DataSet: TCustomMSDataSet): String;
begin
  Result := 'MSACCESS';
end;

function DateValueToSDACSQLStringProc(DataSet: TDataSet; Value: Variant): String;
begin
  Result := DateValueToDataBaseSQLString(SDACDataSetDriverName(TCustomMSDataSet(DataSet)), Value)
end;

procedure SortDataInSDACDataSet(Grid: TCustomDBGridEh; DataSet: TCustomMSDataSet);
var
  s: String;
  i: Integer;
begin
  s := '';
  for i := 0 to Grid.SortMarkedColumns.Count - 1 do
  begin
    s := s + IntToStr(DataSet.FieldByName(Grid.SortMarkedColumns[i].FieldName).Index+1);
    if Grid.SortMarkedColumns[i].Title.SortMarker = smUpEh
      then s := s + ' DESC,'
      else s := s + ',';
  end;
  //DataSet.Sort := Copy(s, 1, Length(s) - 1);
    if DataSet.Active then begin
      //DataSet.Close;
      DataSet.SetOrderBy(Copy(s, 1, Length(s) - 1));
      DataSet.Open;
    end
    else DataSet.SetOrderBy(Copy(s, 1, Length(s) - 1));
end;

type

  TSDACSQLDatasetFeaturesEh = class(TSQLDatasetFeaturesEh)
  public
    procedure ApplySorting(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean); override;
    constructor Create; override;
  end;

  TSDACCommandTextDatasetFeaturesEh = class(TCommandTextDatasetFeaturesEh)
  public
    procedure ApplySorting(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean); override;
    constructor Create; override;
  end;

//implementation

{ TSDACSQLDatasetFeaturesEh }

procedure TSDACSQLDatasetFeaturesEh.ApplySorting(Sender: TObject;
  DataSet: TDataSet; IsReopen: Boolean);
begin
  if Sender is TCustomDBGridEh then
    if TCustomDBGridEh(Sender).SortLocal then
      SortDataInSDACDataSet(TCustomDBGridEh(Sender), TCustomMSDataSet(DataSet))
    else
      inherited ApplySorting(Sender, DataSet, IsReopen);
end;

constructor TSDACSQLDatasetFeaturesEh.Create;
begin
  inherited Create;
  DateValueToSQLString := DateValueToSDACSQLStringProc;
  SupportsLocalLike := True;
end;

{ TSDACCommandTextDatasetFeaturesEh }

procedure TSDACCommandTextDatasetFeaturesEh.ApplySorting(Sender: TObject;
  DataSet: TDataSet; IsReopen: Boolean);
begin
  if Sender is TCustomDBGridEh then
    if TCustomDBGridEh(Sender).SortLocal then
      SortDataInSDACDataSet(TCustomDBGridEh(Sender), TCustomMSDataSet(DataSet))
    else
      inherited ApplySorting(Sender, DataSet, IsReopen);
end;

constructor TSDACCommandTextDatasetFeaturesEh.Create;
begin
  inherited Create;
  DateValueToSQLString := DateValueToSDACSQLStringProc;
  SupportsLocalLike := True;
end;

initialization
  RegisterDatasetFeaturesEh(TSDACSQLDatasetFeaturesEh, TMSQuery);
  RegisterDatasetFeaturesEh(TSDACCommandTextDatasetFeaturesEh, TCustomMSDataSet);
end.
