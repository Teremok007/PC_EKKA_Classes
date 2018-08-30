Unit ReplicatorU;

Interface

Uses Windows, Dialogs, Messages, Classes, SysUtils, Util, ADODB;

Type TReplicator=class(TObject)
     private

       FCounter:Integer;
       FMaxCounter:Integer;
       FBuffer:Integer;

       FADOCoF:TADOConnection;
       FQrF:TADOQuery;
       FQrExF:TADOQuery;
       FServerF:String;
       FBaseF:String;
       FUserF:String;
       FPasswF:String;

       FADOCoT:TADOConnection;
       FQrT:TADOQuery;
       FServerT:String;
       FBaseT:String;
       FUserT:String;
       FPasswT:String;

     public

       constructor Create; virtual;
       destructor Destroy; override;

       procedure CopyBuffer; // Производит копирование Buffer-количество строк

       property Counter:Integer read FCounter write FCounter;          // Код обработчика копирования
       property MaxCounter:Integer read FMaxCounter write FMaxCounter; // Количество обработчиков кпирования
       property Buffer:Integer read FBuffer write FBuffer;             // Количество строк, обрабатвыаемых за одну транзакцию

       {--- Настройки сервера-источника ---}
       property ServerF:String read FServerF write FServerF;
       property BaseF:String read FBaseF write FBaseF;
       property UserF:String read FUserF write FUserF;
       property PasswF:String read FPasswF write FPasswF;

       {--- Настройки сервера-приемника ---}
       property ServerT:String read FServerT write FServerT;
       property BaseT:String read FBaseT write FBaseT;
       property UserT:String read FUserT write FUserT;
       property PasswT:String read FPasswT write FPasswT;

     end;

Implementation

uses DB;

{ TReplicator }

constructor TReplicator.Create;
 begin
  FCounter:=0;
  FMaxCounter:=1;
  FBuffer:=30;

  FADOCoF:=TADOConnection.Create(nil);
  FADOCoF.LoginPrompt:=False;
  FADOCoF.ConnectionTimeout:=10;

  FQrF:=TADOQuery.Create(nil);
  FQrExF:=TADOQuery.Create(nil);
  FQrF.Connection:=FADOCoF;
  FQrExF.Connection:=FADOCoF;

  FADOCoT:=TADOConnection.Create(nil);
  FADOCoT.LoginPrompt:=False;
  FQrT:=TADOQuery.Create(nil);
  FQrT.Connection:=FADOCoT;

  ServerF:='';
  BaseF:='APTEKA_NET';
  UserF:='sa';
  PasswF:='';

  ServerT:='';
  BaseT:='';
  UserT:='';
  PasswT:='';
 end;

procedure TReplicator.CopyBuffer;
var i:Integer;

 procedure DeleteRow;
  begin
   FQrT.Close;
   FQrT.SQL.Text:='delete from '+FQrF.FieldByName('TABLENAME').AsString+
                  ' where '+FQrF.FieldByName('NM_ROW_ID').AsString+'='+FQrF.FieldByName('ROW_ID').AsString;
   FQrT.ExecSQL;
  end;

 function RowExist:Boolean;
  begin
   FQrExF.Close;
   FQrExF.SQL.Text:='select * from '+FQrF.FieldByName('TABLENAME').AsString+
                    ' where '+FQrF.FieldByName('NM_ROW_ID').AsString+'='+FQrF.FieldByName('ROW_ID').AsString;
   FQrExF.Open;
   Result:=Not FQrExF.IsEmpty;
  end;

 procedure EditRow(Act:Char);
 var C:String[4];
     i:Integer;
     S,V:String;
  begin
   Case Act of
    'I':if RowExist then
         begin
          S:=''; V:='';
          for i:=0 to FQrExF.FieldCount-1 do
           begin
            S:=S+FQrExF.Fields[i].FieldName;
            if FQrExF.Fields[i].DataType in [ftString,ftFixedChar,ftWideString] then V:=V+''''+FQrExF.Fields[i].AsString+'''' else
            if FQrExF.Fields[i].DataType in [ftDate,ftTime,ftDateTime] then V:=V+''''+FormatDateTime('yyyy-mm-dd hh:nn:ss',FQrExF.Fields[i].AsDateTime)+''''
                                                                       else V:=V+FQrExF.Fields[i].AsString;
            if i<FQrExF.FieldCount-1 then begin S:=S+','; V:=V+','; end;
           end;
          FQrT.Close;
          FQrT.SQL.Clear;
          FQrT.SQL.Add('if IsNull(select * from '+FQrF.FieldByName('TABLENAME').AsString);
          FQrT.SQL.Add(' where '+FQrF.FieldByName('NM_ROW_ID').AsString+'='+FQrF.FieldByName('ROW_ID').AsString+'),0)<=0');
          FQrT.SQL.Add(' begin');
          FQrT.SQL.Add('  Set IDENTITY_INSERT '+FQrF.FieldByName('TABLENAME').AsString+' ON');
          FQrT.SQL.Add('  Insert into '+FQrF.FieldByName('TABLENAME').AsString+'('+S+')');
          FQrT.SQL.Add('  Values('+V+')');
          FQrT.SQL.Add('  Set IDENTITY_INSERT '+FQrF.FieldByName('TABLENAME').AsString+' OFF');
          FQrT.SQL.Add(' end');
          FQrT.ExecSQL;
         end;
    'U':if RowExist then
         begin // Update

         end else DeleteRow;
    'D':DeleteRow;
   end;

   C:='0000';
   for i:=1 to MaxCounter do
    begin
     C[i]:='1';
     if i=4 then Break;
    end;
   C[Counter]:='0';
   FQrExF.Close;
   FQrExF.SQL.Clear;
   FQrExF.SQL.Add('declare @cnt int, @id int ');
   FQrExF.SQL.Add('set @id='+FQrF.FieldByName('ID').AsString);
   FQrExF.SQL.Add('set @cnt='+IntToStr(Counter));
   FQrExF.SQL.Add('if IsNull((select Left(Counter,4) from EditLog where id=@id),''0000'')<>'''+C+'''');
   FQrExF.SQL.Add(' update EditLog set Counter=SubString(Counter,1,@cnt-1)+''1''+SubString(Counter,@cnt+1,Len(Counter)-@cnt) ');
   FQrExF.SQL.Add(' where ID=@id');
   FQrExF.SQL.Add('else');
   FQrExF.SQL.Add(' delete EditLog where id=@id');
   FQrExF.ExecSQL;
  end;

 Begin
  try
   try
    FADOCoF.Connected:=False;
    FADOCoF.ConnectionString:='Provider=SQLOLEDB.1;Password='+PasswF+
                              ';Persist Security Info=True;User ID='+UserF+
                              ';Initial Catalog='+BaseF+
                              ';Data Source='+ServerF;
    FADOCoF.Connected:=True;
   except
    raise EAbort.Create('Ошибка подключения к серверу источнику ('+ServerF+')');
   end;
   FQrF.Close;
   FQrF.SQL.Text:='select top '+IntToStr(Buffer)+' * from EditLog where substring(counter,'+IntToStr(Counter)+',1)=''0'' order by id';
   FQrF.Open;
   if FQrF.IsEmpty then Exit;

   try
    FADOCoT.Connected:=False;
    FADOCoT.ConnectionString:='Provider=SQLOLEDB.1;Password='+PasswT+
                              ';Persist Security Info=True;User ID='+UserT+
                              ';Initial Catalog='+BaseT+
                              ';Data Source='+ServerT;
    FADOCoT.Connected:=True;
   except
    raise EAbort.Create('Ошибка подключения к серверу приемнику ('+ServerT+')');
   end;

   for i:=1 to FQrF.RecordCount do
    begin
     if i=1 then FQrF.First else FQrF.Next;
     FADOCoT.BeginTrans;
     try
      EditRow(FQrF.FieldByName('ACT').AsString[1]);
      FADOCoT.CommitTrans;
     except
      FADOCoT.RollbackTrans;
     end;
    end;
  except
  end;
 End;

destructor TReplicator.Destroy;
 begin
  FQrF.Free;
  FQrExF.Free;
  FADOCoF.Free;
  FQrT.Free;
  FADOCoT.Free;
  inherited;
 end;

End.