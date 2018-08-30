UNIT SQLU;

INTERFACE

Uses DBTables,Dialogs,SysUtils, ADODB;

function GetNaklSps(Qr:TADOQuery; Apt_ID:String; D1,D2:TDateTime):Boolean;
function GetNaklSpsNDS(Qr:TADOQuery; Apt_ID:String; D1,D2:TDateTime):Boolean;
function GetNaklSpsCHP(Qr:TADOQuery; Apt_ID:String; D1,D2:TDateTime; NDS:Integer):Boolean;

function GetNaklSpsReoc(Qr:TADOQuery; Apt_ID:String; D1,D2:TDateTime):Boolean;
function GetNaklSpsReocNDS(Qr:TADOQuery; Apt_ID:String; D1,D2:TDateTime):Boolean;
function GetNaklMarketSps(Qr:TADOQuery; Apt_ID:String; D1,D2:TDateTime):Boolean;

function GetNakl(Qr:TADOQuery; nn:String; Apt_ID:String; D1,D2:TDateTime):Boolean;
function GetNaklNDS(Qr:TADOQuery; nn:String; Apt_ID:String; D1,D2:TDateTime):Boolean;
function GetNaklCHP(Qr:TADOQuery; nn:String; Apt_ID:String; Gr:String; D1,D2:TDateTime):Boolean;
function GetNaklReoc(Qr:TADOQuery; nn:String; Apt_ID:String; D1,D2:TDateTime):Boolean;
function GetNaklReocNDS(Qr:TADOQuery; nn:String; Apt_ID:String; D1,D2:TDateTime):Boolean;
function GetNaklMarket(Qr:TADOQuery; nn:String; Apt_ID:String; D1,D2:TDateTime):Boolean;

IMPLEMENTATION

uses MainU;

// Список накладных РасходРеализацияБезНДС
function GetNaklSps(Qr:TADOQuery; Apt_ID:String; D1,D2:TDateTime):Boolean;
 begin
  try
   if Qr.Active then Qr.Close;
   Qr.SQL.Clear;

   Qr.SQL.Add('select j.iddoc,rtrim(j.DOCNO) as NN_NAKL,                                            ');
   Qr.SQL.Add('       j.CLOSED as EMPT,                                              ');
   Qr.SQL.Add('       j.SP2637 as AUTOR,                                             ');
   Qr.SQL.Add('       workwith_gamma.dbo.decode1Cdate(j.date_time_iddoc) as DATE_NAKL, ');
   Qr.SQL.Add('       b.sp3918 as Summa,                                              ');
   Qr.SQL.Add('       (case when b.sp3909 in (''    1F'',''     7'') or s.dt is not null then 1 else 0 end) as NReady ');
   Qr.SQL.Add('from                                 ');

   Qr.SQL.Add('     '+Opt.Gamma+'.._1sjourn j (nolock)                                                                         ');
   Qr.SQL.Add('     inner join                                                                                         ');
   Qr.SQL.Add('     '+Opt.Gamma+'..dh3901 b (nolock) on b.iddoc = j.iddoc                                                      ');
   Qr.SQL.Add('	       left join (select skl,id_apteka,dt,iddoc from workwith_gamma..scan_corr group by skl,id_apteka,dt,iddoc) s  ');
   Qr.SQL.Add('		               on b.iddoc=s.iddoc and b.sp9272=s.skl and b.sp3905=s.id_apteka and s.dt=convert(datetime,convert(varchar,workwith_gamma.dbo.decode1Cdate(j.date_time_iddoc),23)) ');

   Qr.SQL.Add('where j.date_time_iddoc >= '''+FormatDateTime('yyyymmdd',D1)+''' and  ');
   Qr.SQL.Add('      j.date_time_iddoc < '''+FormatDateTime('yyyymmdd',D2+1)+''' and ');
   Qr.SQL.Add('      b.sp3905 = '''+Apt_ID+''' and                                   ');
   Qr.SQL.Add('      j.ISMARK = 0 and                                                ');
   Qr.SQL.Add('     ((j.CLOSED = 5) or ((j.CLOSED = 4) and (b.sp3918<=0)))           ');
//   Qr.SQL.Add('     (b.SP3909 = ''     1   '' or b.SP3909 = ''     E   '' or  b.SP3909 = ''    11   '' or b.SP3909 = ''     7   '')  ');
   Qr.SQL.Add('group by j.date_time_iddoc,j.iddoc,j.DOCNO,j.CLOSED,j.SP2637,b.sp3918,b.sp3909,s.dt order by j.DOCNO');
//   Qr.SQL.SaveToFile('C:\23456.txt');
   Qr.Open;
   if Qr.RecordCount>0 then Result:=True else Result:=False;
  except
   Result:=False;
  end;
 end;

// Список наклданых РасходРеализхацияНДС
function GetNaklSpsNDS(Qr:TADOQuery; Apt_ID:String; D1,D2:TDateTime):Boolean;
 begin
  try
   if Qr.Active then Qr.Close;
   Qr.SQL.Clear;
   Qr.SQL.Add('select rtrim(j.DOCNO) as NN_NAKL,                                      ');
   Qr.SQL.Add('       j.CLOSED as EMPT,                                               ');
   Qr.SQL.Add('       j.SP2637 as AUTOR,                                              ');
   Qr.SQL.Add('       workwith_gamma.dbo.decode1Cdate(j.date_time_iddoc) as DATE_NAKL, ');
   Qr.SQL.Add('       b.sp4042 as Summa,                                               ');
   Qr.SQL.Add('       (case when b.sp4033 in (''    1F'',''     7'') or s.dt is not null then 1 else 0 end) as NReady ');
   Qr.SQL.Add('from                                 ');
   Qr.SQL.Add('     '+Opt.Gamma+'.._1sjourn j (nolock)                                                                         ');
   Qr.SQL.Add('     inner join                                                                                         ');
   Qr.SQL.Add('     '+Opt.Gamma+'..dh4028 b (nolock) on b.iddoc = j.iddoc                                                      ');
   Qr.SQL.Add('	       left join (select skl,id_apteka,dt,iddoc from workwith_gamma..scan_corr group by skl,id_apteka,dt,iddoc) s  ');
   Qr.SQL.Add('		               on b.iddoc=s.iddoc and b.sp9273=s.skl and b.sp4030=s.id_apteka and s.dt=convert(datetime,convert(varchar,workwith_gamma.dbo.decode1Cdate(j.date_time_iddoc),23)) ');
   Qr.SQL.Add('                                                                       ');
   Qr.SQL.Add('where j.date_time_iddoc >= '''+FormatDateTime('yyyymmdd',D1)+''' and   ');
   Qr.SQL.Add('      j.date_time_iddoc < '''+FormatDateTime('yyyymmdd',D2+1)+''' and  ');
   Qr.SQL.Add('      b.sp4030 = '''+Apt_ID+''' and                                    ');
   Qr.SQL.Add('      j.ISMARK = 0 and                                                 ');
   Qr.SQL.Add('     ((j.CLOSED = 5) or ((j.CLOSED = 4) and (b.sp4042<=0)))                                 ');
//   Qr.SQL.Add('     (b.SP4033 = ''     1   '' or b.SP4033 = ''     E   '' or  b.SP4033 = ''    11   '' or b.SP4033 = ''     7   '')  ');
   Qr.SQL.Add('group by j.date_time_iddoc,j.DOCNO,j.CLOSED,j.SP2637,b.sp4042,b.sp4033,s.dt order by j.DOCNO           ');
//   Qr.SQL.SAveToFile('C:\321.txt');
   Qr.Open;
   if Qr.RecordCount>0 then Result:=True else Result:=False;
  except
   Result:=False;
  end;
 end;

// Список накладных АктМаркетинг
function GetNaklMarketSps(Qr:TADOQuery; Apt_ID:String; D1,D2:TDateTime):Boolean;
 begin
  try
   if Qr.Active then Qr.Close;
   Qr.SQL.Clear;

   Qr.SQL.Add('select j.iddoc,rtrim(j.DOCNO) as NN_NAKL,                                            ');
   Qr.SQL.Add('       j.CLOSED as EMPT,                                              ');
   Qr.SQL.Add('       j.SP2637 as AUTOR,                                             ');
   Qr.SQL.Add('       workwith_gamma.dbo.decode1Cdate(j.date_time_iddoc) as DATE_NAKL, ');
   Qr.SQL.Add('       b.sp9138 as Summa,                                              ');
   Qr.SQL.Add('       1 as NReady                                              ');
   Qr.SQL.Add('from '+Opt.Gamma+'..dh9124 b (nolock),                                ');
   Qr.SQL.Add('     '+Opt.Gamma+'.._1sjourn j (nolock)                               ');
//   Qr.SQL.Add('     workwith_gamma..scan_corr s                                      ');
   Qr.SQL.Add('                                                                      ');
   Qr.SQL.Add('where j.date_time_iddoc >= '''+FormatDateTime('yyyymmdd',D1)+''' and  ');
   Qr.SQL.Add('      j.date_time_iddoc < '''+FormatDateTime('yyyymmdd',D2+1)+''' and ');

   Qr.SQL.Add('      b.sp9126 = '''+Apt_ID+''' and                                   ');
//   Qr.SQL.Add('      b.sp9126=s.id_apteka and s.dt=convert(datetime,convert(varchar,workwith_gamma.dbo.decode1Cdate(j.date_time_iddoc),23)) and ');

   Qr.SQL.Add('      b.iddoc = j.iddoc and                                           ');
   Qr.SQL.Add('      b.iddoc = j.iddoc and                                           ');
   Qr.SQL.Add('      j.ISMARK = 0 and                                                ');
   Qr.SQL.Add('     ((j.CLOSED = 5) or ((j.CLOSED = 4) and (b.sp9138<=0)))           ');
//   Qr.SQL.Add('     (b.SP3909 = ''     1   '' or b.SP3909 = ''     E   '' or  b.SP3909 = ''    11   '' or b.SP3909 = ''     7   '')  ');
   Qr.SQL.Add('group by j.date_time_iddoc,j.iddoc,j.DOCNO,j.CLOSED,j.SP2637,b.sp9138 order by j.DOCNO          ');

   Qr.Open;
   if Qr.RecordCount>0 then Result:=True else Result:=False;
  except
   Result:=False;
  end;
 end;

// Список накладных ПереоценкаТТ без НДС
function GetNaklSpsReoc(Qr:TADOQuery; Apt_ID:String; D1,D2:TDateTime):Boolean;
 begin
  try
   if Qr.Active then Qr.Close;
   Qr.SQL.Clear;

   Qr.SQL.Add('select rtrim(j.DOCNO) as NN_NAKL,                                            ');
   Qr.SQL.Add('       4 as EMPT,                                                     ');
   Qr.SQL.Add('       j.SP2637 as AUTOR,                                             ');
   Qr.SQL.Add('       workwith_gamma.dbo.decode1Cdate(j.date_time_iddoc) as DATE_NAKL, ');
   Qr.SQL.Add('       0.00 as Summa,                                                  ');
   Qr.SQL.Add('       1 as NReady                                              ');
   Qr.SQL.Add('from '+Opt.Gamma+'..DH8819 b (nolock),                                ');
   Qr.SQL.Add('     '+Opt.Gamma+'.._1sjourn j (nolock)                               ');
   Qr.SQL.Add('                                                                      ');
   Qr.SQL.Add('where j.date_time_iddoc >= '''+FormatDateTime('yyyymmdd',D1)+''' and  ');
   Qr.SQL.Add('      j.date_time_iddoc < '''+FormatDateTime('yyyymmdd',D2+1)+''' and ');
   Qr.SQL.Add('      b.SP8827 = '''+Apt_ID+''' and                                   ');
   Qr.SQL.Add('      b.iddoc = j.iddoc and                                           ');
   Qr.SQL.Add('      b.iddoc = j.iddoc and                                           ');
   Qr.SQL.Add('      j.ISMARK = 0 and SP8829=''   2LW''                              ');
   Qr.SQL.Add('      and (j.CLOSED > 0)                        ');
   Qr.SQL.Add('group by j.date_time_iddoc,j.DOCNO,j.CLOSED,j.SP2637 order by j.DOCNO                   ');
//   Qr.SQL.SaveToFile('C:\111.txt');

   Qr.Open;
   if Qr.RecordCount>0 then Result:=True else Result:=False;
  except
   Result:=False;
  end;
 end;

// Список накладных ПереоценкаТТ с НДС
function GetNaklSpsReocNDS(Qr:TADOQuery; Apt_ID:String; D1,D2:TDateTime):Boolean;
 begin
  try
   if Qr.Active then Qr.Close;
   Qr.SQL.Clear;

   Qr.SQL.Add('select rtrim(j.DOCNO) as NN_NAKL,                                            ');
   Qr.SQL.Add('       4 as EMPT,                                                     ');
   Qr.SQL.Add('       j.SP2637 as AUTOR,                                             ');
   Qr.SQL.Add('       workwith_gamma.dbo.decode1Cdate(j.date_time_iddoc) as DATE_NAKL, ');
   Qr.SQL.Add('       0.00 as Summa,                                                  ');
   Qr.SQL.Add('       1 as NReady                                              ');
   Qr.SQL.Add('from '+Opt.Gamma+'..DH8819 b (nolock),                                ');
   Qr.SQL.Add('     '+Opt.Gamma+'.._1sjourn j (nolock)                               ');
   Qr.SQL.Add('                                                                      ');
   Qr.SQL.Add('where j.date_time_iddoc >= '''+FormatDateTime('yyyymmdd',D1)+''' and  ');
   Qr.SQL.Add('      j.date_time_iddoc < '''+FormatDateTime('yyyymmdd',D2+1)+''' and ');
   Qr.SQL.Add('      b.SP8827 = '''+Apt_ID+''' and                                   ');
   Qr.SQL.Add('      b.iddoc = j.iddoc and                                           ');
   Qr.SQL.Add('      b.iddoc = j.iddoc and                                           ');
   Qr.SQL.Add('      j.ISMARK = 0 and SP8829=''   2LV''                              ');
   Qr.SQL.Add('      and (j.CLOSED >0)                        ');
   Qr.SQL.Add('group by j.date_time_iddoc,j.DOCNO,j.CLOSED,j.SP2637 order by j.DOCNO                   ');

   Qr.Open;
   if Qr.RecordCount>0 then Result:=True else Result:=False;
  except
   Result:=False;
  end;
 end;


// Список накладных Перемещений
function GetNaklSpsCHP(Qr:TADOQuery; Apt_ID:String; D1,D2:TDateTime; NDS:Integer):Boolean;
var sNDS:String;
 begin
  try
   Case NDS of
    0:sNDS:='   2LW';
    1:sNDS:='   2LV';
   end;
   if Qr.Active then Qr.Close;
   Qr.SQL.Clear;
   Qr.SQL.Add('select rtrim(j.DOCNO) as NN_NAKL,                                     ');
   Qr.SQL.Add('       j.SP2637 as AUTOR,                                             ');
   Qr.SQL.Add('       j.CLOSED as EMPT,                                              ');
   Qr.SQL.Add('       workwith_gamma.dbo.decode1Cdate(j.date_time_iddoc) as DATE_NAKL,');
   Qr.SQL.Add('       b.SP4312 as Summa,                                              ');
   Qr.SQL.Add('       1 as NReady                                              ');
   Qr.SQL.Add('from '+Opt.Gamma+'..dh4153 b (nolock),                                ');
   Qr.SQL.Add('     '+Opt.Gamma+'.._1sjourn j (nolock)                               ');
   Qr.SQL.Add('                                                                      ');
   Qr.SQL.Add('where j.date_time_iddoc >= '''+FormatDateTime('yyyymmdd',D1)+''' and  ');
   Qr.SQL.Add('      j.date_time_iddoc < '''+FormatDateTime('yyyymmdd',D2+1)+''' and ');
   Qr.SQL.Add('      b.sp4155 = '''+Apt_ID+''' and                                   ');
   Qr.SQL.Add('      b.iddoc = j.iddoc and                                           ');
   Qr.SQL.Add('      b.iddoc = j.iddoc and                                           ');
   Qr.SQL.Add('      b.sp5404 = '''+sNDS+'''  and                                    ');
   Qr.SQL.Add('      j.ISMARK = 0 and                                                ');
   Qr.SQL.Add('     ((j.CLOSED = 5) or ((j.CLOSED = 4) and (b.SP4312<=0)))           ');
   Qr.SQL.Add('group by j.date_time_iddoc,j.DOCNO,j.SP2637,j.CLOSED,b.SP4312 order by j.DOCNO          ');

   Qr.Open;
   if Qr.RecordCount>0 then Result:=True else Result:=False;
  except
   Result:=False;
  end;
 end;

// Накладная Без НДС
function GetNakl(Qr:TADOQuery; nn:String; Apt_ID:String; D1,D2:TDateTime):Boolean;
 begin
  try
   if Qr.Active then Qr.Close;
   Qr.SQL.Clear;

   Qr.SQL.Add('select rtrim(j.DOCNO) as NN_NAKL,                             ');
   Qr.SQL.Add('       convert(CHAR(8),j.date_time_iddoc,1) as DateN,  ');
   Qr.SQL.Add('       rtrim(c.SP9199) as kod_name,                             ');
   Qr.SQL.Add('       rtrim(s.sp5585) as Art_Code,                           ');
   Qr.SQL.Add('       rtrim(s.descr) as Names,                               ');
   Qr.SQL.Add('       (select rtrim(Max(m.descr)) from '+Opt.Gamma+'..sc5938 m (nolock) where m.ismark=0 and m.id=s.sp5940) as Manuf,');
   Qr.SQL.Add('       rtrim(s.SP5596) as ArtName,                            ');
   Qr.SQL.Add('       rtrim(convert(int,c.sp3913)) as kol,                                ');
   Qr.SQL.Add('       rtrim(c.sp3921) as cena,                               ');
   Qr.SQL.Add('       2 as f_nds,                                     ');
   Qr.SQL.Add('       (case when s.PARENTID=''     J'' then 99 else 1 end) as type_tov,       ');
   Qr.SQL.Add('       rtrim(s.sp8238) as ForCHP,                              ');
   Qr.SQL.Add('       b.sp9323 as Obl,     ');
   Qr.SQL.Add('       pa.sp8985 as KodPostav,     ');
   Qr.SQL.Add('       IsNull(pr.SP3844,'''') as NN_Postav,     ');
   Qr.SQL.Add('       b.sp3909 as Sklad     ');

   Qr.SQL.Add('                                                       ');
   Qr.SQL.Add('from '+Opt.Gamma+'..dh3901 b (nolock),                 ');
   Qr.SQL.Add('     '+Opt.Gamma+'..dt3901 c (nolock),                 ');
   Qr.SQL.Add('     '+Opt.Gamma+'..sc8979 pa (nolock) left join                  ');
   Qr.SQL.Add('     '+Opt.Gamma+'..dh3841 pr (nolock) on pa.SP8991=pr.iddoc,     ');
   Qr.SQL.Add('     '+Opt.Gamma+'.._1sjourn j (nolock),               ');
   Qr.SQL.Add('     '+Opt.Gamma+'..sc2918 s (nolock)                  ');
   Qr.SQL.Add('where j.DOCNO='''+NN+''' and                           ');
   Qr.SQL.Add('      pa.id=c.SP9199 and                                ');
   Qr.SQL.Add('      j.date_time_iddoc >= '''+FormatDateTime('yyyymmdd',D1)+''' and     ');
   Qr.SQL.Add('      j.date_time_iddoc < '''+FormatDateTime('yyyymmdd',D2+1)+''' and    ');
   Qr.SQL.Add('      s.id=c.sp3920 and                                ');
   Qr.SQL.Add('      b.sp3905 = '''+Apt_ID+''' and                    ');
   Qr.SQL.Add('      b.iddoc = j.iddoc and                            ');
   Qr.SQL.Add('      b.iddoc = j.iddoc and                            ');
   Qr.SQL.Add('      c.iddoc=b.iddoc and                              ');
   Qr.SQL.Add('      j.ISMARK = 0 and                                 ');
   Qr.SQL.Add('     (j.CLOSED = 5 or j.CLOSED = 4)                    ');
//   Qr.SQL.Add('     (b.SP3909 = ''     1   '' or b.SP3909 = ''     E   '' or  b.SP3909 = ''    11   '' or b.SP3909 = ''     7   '') ');
   Qr.SQL.SaveToFile('C:\nakl.sql');

   Qr.Open;
   if Qr.RecordCount>0 then Result:=True else Result:=False;
  except
   on E:Exception do
    begin
     ShowMessage(E.Message);
     Result:=False;
    end;
  end;
 end;

// Накладная  АктМаркетинг
function GetNaklMarket(Qr:TADOQuery; nn:String; Apt_ID:String; D1,D2:TDateTime):Boolean;
 begin
  try
   if Qr.Active then Qr.Close;
   Qr.SQL.Clear;

   Qr.SQL.Add('select rtrim(j.DOCNO) as NN_NAKL,                             ');
   Qr.SQL.Add('       convert(CHAR(8),j.date_time_iddoc,1) as DateN,  ');
   Qr.SQL.Add('       rtrim(c.SP9212) as kod_name,                             ');
   Qr.SQL.Add('       rtrim(s.sp5585) as Art_Code,                           ');
   Qr.SQL.Add('       rtrim(s.descr) as Names,                               ');
   Qr.SQL.Add('       (select rtrim(Max(m.descr)) from '+Opt.Gamma+'..sc5938 m (nolock) where m.ismark=0 and m.id=s.sp5940) as Manuf,');
   Qr.SQL.Add('       rtrim(s.SP5596) as ArtName,                            ');
   Qr.SQL.Add('       rtrim(convert(int,c.sp9136)) as kol,                                ');
   Qr.SQL.Add('       rtrim(c.sp9140) as cena,                               ');
   Qr.SQL.Add('       2 as f_nds,                                     ');
   Qr.SQL.Add('       (case when s.PARENTID=''     J'' then 99 else 1 end) as type_tov,       ');
   Qr.SQL.Add('       rtrim(s.sp8238) as ForCHP,                              ');
   Qr.SQL.Add('       0 as Obl,     ');
   Qr.SQL.Add('       '''' as KodPostav,     ');
   Qr.SQL.Add('       '''' as NN_Postav,     ');
   Qr.SQL.Add('       b.sp9128 as Sklad     ');
   Qr.SQL.Add('                                                       ');
   Qr.SQL.Add('from '+Opt.Gamma+'..dh9124 b (nolock),                 ');
   Qr.SQL.Add('     '+Opt.Gamma+'..dt9124 c (nolock),                 ');
   Qr.SQL.Add('     '+Opt.Gamma+'.._1sjourn j (nolock),               ');
   Qr.SQL.Add('     '+Opt.Gamma+'..sc2918 s (nolock)                  ');
   Qr.SQL.Add('where j.DOCNO='''+NN+''' and                           ');
   Qr.SQL.Add('      j.date_time_iddoc >= '''+FormatDateTime('yyyymmdd',D1)+''' and     ');
   Qr.SQL.Add('      j.date_time_iddoc < '''+FormatDateTime('yyyymmdd',D2+1)+''' and    ');
   Qr.SQL.Add('      s.id=c.sp9139 and                                ');
   Qr.SQL.Add('      b.sp9126 = '''+Apt_ID+''' and                    ');
   Qr.SQL.Add('      b.iddoc = j.iddoc and                            ');
   Qr.SQL.Add('      b.iddoc = j.iddoc and                            ');
   Qr.SQL.Add('      c.iddoc=b.iddoc and                              ');
   Qr.SQL.Add('      j.ISMARK = 0 and                                 ');
   Qr.SQL.Add('     (j.CLOSED = 5 or j.CLOSED = 4)                    ');
//   Qr.SQL.Add('     (b.SP3909 = ''     1   '' or b.SP3909 = ''     E   '' or  b.SP3909 = ''    11   '' or b.SP3909 = ''     7   '') ');
//   Qr.SQL.SaveToFile('C:\nakl.sql');
   Qr.Open;
   if Qr.RecordCount>0 then Result:=True else Result:=False;
  except
   Result:=False;
  end;
 end;

// Накладная НДС
function GetNaklNDS(Qr:TADOQuery; nn:String; Apt_ID:String; D1,D2:TDateTime):Boolean;
 begin
  try
   if Qr.Active then Qr.Close;
   Qr.SQL.Clear;

   Qr.SQL.Add('select rtrim(j.DOCNO) as NN_NAKL,                             ');
   Qr.SQL.Add('       convert(CHAR(8),j.date_time_iddoc,1) as DateN,         ');
   Qr.SQL.Add('       rtrim(c.SP9200) as kod_name,                           ');
   Qr.SQL.Add('       rtrim(s.sp5585) as Art_Code,                           ');
   Qr.SQL.Add('       rtrim(s.descr) as Names,                               ');
   Qr.SQL.Add('       (select rtrim(Max(m.descr)) from '+Opt.Gamma+'..sc5938 m (nolock) where m.ismark=0 and m.id=s.sp5940) as Manuf,');
   Qr.SQL.Add('       rtrim(s.SP5596) as ArtName,                            ');
   Qr.SQL.Add('       rtrim(convert(int,c.sp4038)) as kol,                   ');
   Qr.SQL.Add('       rtrim(c.sp4045) as cena,                               ');
   Qr.SQL.Add('       1 as f_nds,                                            ');
   Qr.SQL.Add('       (case when s.PARENTID=''     J'' then 99 else 2 end) as type_tov,       ');
   Qr.SQL.Add('       rtrim(s.sp8238) as ForCHP,                              ');
   Qr.SQL.Add('       SP9324 as Obl,     ');
   Qr.SQL.Add('       pa.sp8985 as KodPostav,     ');
   Qr.SQL.Add('       IsNull(pr.SP3844,'''') as NN_Postav,     ');
   Qr.SQL.Add('       b.sp4033 as Sklad     ');
   Qr.SQL.Add('                                                       ');
   Qr.SQL.Add('from '+Opt.Gamma+'..dh4028 b (nolock),                 ');
   Qr.SQL.Add('     '+Opt.Gamma+'..dt4028 c (nolock),                 ');
   Qr.SQL.Add('     '+Opt.Gamma+'..sc8979 pa (nolock) left join       ');
   Qr.SQL.Add('     '+Opt.Gamma+'..dh3841 pr (nolock) on pa.SP8991=pr.iddoc,  ');
   Qr.SQL.Add('     '+Opt.Gamma+'.._1sjourn j (nolock),               ');
   Qr.SQL.Add('     '+Opt.Gamma+'..sc2918 s (nolock)                  ');
   Qr.SQL.Add('                                                       ');
   Qr.SQL.Add('where j.DOCNO='''+NN+''' and                           ');
   Qr.SQL.Add('      pa.id=c.SP9200 and                                ');
   Qr.SQL.Add('      j.date_time_iddoc >= '''+FormatDateTime('yyyymmdd',D1)+''' and     ');
   Qr.SQL.Add('      j.date_time_iddoc < '''+FormatDateTime('yyyymmdd',D2+1)+''' and    ');
   Qr.SQL.Add('      s.id=c.sp4044 and                                ');
   Qr.SQL.Add('      b.sp4030 = '''+Apt_ID+''' and                    ');
   Qr.SQL.Add('      b.iddoc = j.iddoc and                            ');
   Qr.SQL.Add('      b.iddoc = j.iddoc and                            ');
   Qr.SQL.Add('      c.iddoc=b.iddoc and                              ');
   Qr.SQL.Add('      j.ISMARK = 0 and                                 ');
   Qr.SQL.Add('     (j.CLOSED = 5 or j.CLOSED = 4)                    ');
//   Qr.SQL.Add('     (b.sp4033 = ''     1   '' or b.sp4033 = ''     E   '' or  b.sp4033 = ''    11   '' or b.sp4033 = ''     7   '') ');

   Qr.Open;
   if Qr.RecordCount>0 then Result:=True else Result:=False;
  except
   on E:Exception do
    begin
     ShowMessage(E.Message);
     Result:=False;
    end;
  end;
 end;

// Накладная Перемещение
function GetNaklCHP(Qr:TADOQuery; nn:String; Apt_ID:String; Gr:String; D1,D2:TDateTime):Boolean;
 begin
  try
   if Qr.Active then Qr.Close;
   try
    Qr.SQL.Text:='drop table #cd_cena';
    Qr.ExecSQL;
   except
   end;
   if Qr.Active then Qr.Close;
   Qr.SQL.Clear;

   Qr.SQL.Add('declare @dat CHAR(8)                                                ');
   Qr.SQL.Add('declare @dat1 CHAR(8)                                               ');
   Qr.SQL.Add('declare @dat2 CHAR(8)                                               ');
   Qr.SQL.Add('declare @n_nakl VARCHAR(20)                                         ');
   Qr.SQL.Add('                                                                    ');
   Qr.SQL.Add('select @dat1='''+FormatDateTime('yyyymmdd',D1)+'''                  ');
   Qr.SQL.Add('select @dat2='''+FormatDateTime('yyyymmdd',D2+1)+'''                ');
   Qr.SQL.Add('select @n_nakl='''+nn+'''                                           ');
   Qr.SQL.Add('                                                                    ');
   Qr.SQL.Add('select @dat=convert(CHAR(8),j.date_time_iddoc,1)                    ');
   Qr.SQL.Add('from '+Opt.Gamma+'.._1SJourn j (nolock)                             ');
   Qr.SQL.Add('where j.DOCNO=@n_nakl and                                           ');
   Qr.SQL.Add('      j.DATE_TIME_IDDOC>=@dat1 and j.DATE_TIME_IDDOC<@dat2          ');
   Qr.SQL.Add('group by convert(CHAR(8),j.date_time_iddoc,1)                       ');
   Qr.SQL.Add('                                                                    ');
   Qr.SQL.Add('select j.DOCNO as NN_NAKL,                                          ');
   Qr.SQL.Add('       convert(CHAR(8),j.date_time_iddoc,1) as DATEN,               ');
   Qr.SQL.Add('       c.SP9203 as Kod_Name,                                          ');
   Qr.SQL.Add('       a.sp5585 as Art_Code,                                        ');
   Qr.SQL.Add('       a.descr as Names,                                            ');
   Qr.SQL.Add('       (select rtrim(Max(m.descr)) from '+Opt.Gamma+'..sc5938 m (nolock) where m.ismark=0 and m.id=a.sp5940) as Manuf,');
   Qr.SQL.Add('       a.sp5596 as Art_Name,                                        ');
   Qr.SQL.Add('       c.sp4157 as Kol,                                             ');
   Qr.SQL.Add('       sp3887 as F_NDS,                                             ');
   Qr.SQL.Add('       a.sp8238 as ForCHP,                                          ');
   Qr.SQL.Add('       a.sp8239 as DP,                                              ');
   Qr.SQL.Add('       c.sp8865 as Cena,                                            ');
   Qr.SQL.Add('       (case when a.PARENTID=''     J'' then 99 else 1 end) as type_tov,       ');
   Qr.SQL.Add('       a.PARENTID,                                                   ');
   Qr.SQL.Add('       b.sp4154 as Sklad     ');
//   Qr.SQL.Add('       Convert (numeric(8,2),0.0) as Cena                           ');
   Qr.SQL.Add('into #cd_cena                                                       ');
   Qr.SQL.Add('from '+Opt.Gamma+'..sc2918 a (nolock),                              ');
   Qr.SQL.Add('     '+Opt.Gamma+'.._1SJOURN j (nolock),                            ');
   Qr.SQL.Add('     '+Opt.Gamma+'..DH4153 b (nolock),                              ');
   Qr.SQL.Add('     '+Opt.Gamma+'..DT4153 c (nolock)                               ');
   Qr.SQL.Add('where                                                               ');
   Qr.SQL.Add('      j.DOCNO=@n_nakl and                                           ');
   Qr.SQL.Add('      j.DATE_TIME_IDDOC>=@dat1 and j.DATE_TIME_IDDOC<@dat2 and      ');
   Qr.SQL.Add('      j.IDDOC=b.IDDOC and                                           ');
   Qr.SQL.Add('      (b.sp4155='''+Apt_ID+''') and                                 ');
   Qr.SQL.Add('      b.IDDOC=c.IDDOC and (j.CLOSED = 5 or j.CLOSED = 4) and        ');
   Qr.SQL.Add('      c.sp4156=a.ID                                                 ');
   Qr.SQL.Add('order by a.descr                                                    ');
   Qr.SQL.Add('                                                                    ');
{
   Qr.SQL.Add('update #cd_cena set Cena=IsNull((select top 1 Convert (numeric(8,2),isnull(d.value,0))   ');
   Qr.SQL.Add('from '+Opt.Gamma+'..sc2918 aa (nolock),                             ');
   Qr.SQL.Add('     '+Opt.Gamma+'..sc3950 c (nolock) ,                             ');
   Qr.SQL.Add('     '+Opt.Gamma+'.._1sconst d (nolock)                            ');
   Qr.SQL.Add('                                                ');
   Qr.SQL.Add('                                                                    ');
   Qr.SQL.Add('where c.sp3951 = '''+Gr+''' and                                     ');
   Qr.SQL.Add('      #cd_cena.kod_name=aa.code and                                        ');
   Qr.SQL.Add('      c.PARENTEXT=aa.id and                                         ');
   Qr.SQL.Add('      d.id=3952 and                                                 ');
   Qr.SQL.Add('      d.objid = c.id and                                            ');
   Qr.SQL.Add('      d.date=(select max(t.date)                                    ');
   Qr.SQL.Add('              from '+Opt.Gamma+'.._1sconst t (nolock)               ');
   Qr.SQL.Add('              where d.objid = t.objid and                           ');
   Qr.SQL.Add('                    t.id=3952 and                                   ');
   Qr.SQL.Add('                    t.objid = c.id and                              ');
   Qr.SQL.Add('                    t.date<=@dat                                    ');
   Qr.SQL.Add('             ) order by d.date,[time] desc),0)                      ');
}
   Qr.SQL.Add('select rtrim(m.NN_NAKL) as nn_nakl,                                                   ');
   Qr.SQL.Add('       rtrim(m.DATEN) as DATEN,                                                     ');
   Qr.SQL.Add('       rtrim(m.Kod_Name) as Kod_name,                                                  ');
   Qr.SQL.Add('       rtrim(m.Art_Code) as Art_code,                                                  ');
   Qr.SQL.Add('       rtrim(m.Names) as Names,                                                     ');
   Qr.SQL.Add('       rtrim(Max(m.Manuf)) as Manuf,                                                     ');
   Qr.SQL.Add('       rtrim(m.Art_Name) as Art_Name,                                                  ');
   Qr.SQL.Add('       rtrim(m.F_NDS) as F_NDS,                                                     ');
   Qr.SQL.Add('       rtrim(m.ForCHP) as ForCHP,                                                    ');
   Qr.SQL.Add('       rtrim(m.DP) as DP,                                                        ');
   Qr.SQL.Add('       Sum(m.Kol) as Kol,                                           ');
   Qr.SQL.Add('       rtrim(m.Cena) as Cena,                                       ');
   Qr.SQL.Add('       Max(m.type_tov) as type_tov,                                 ');
   Qr.SQL.Add('       Max(m.parentid) as parentid,                                 ');
   Qr.SQL.Add('       0 as Obl,     ');
   Qr.SQL.Add('       '''' as KodPostav,     ');
   Qr.SQL.Add('       '''' as NN_Postav,     ');
   Qr.SQL.Add('       m.Sklad     ');
   Qr.SQL.Add('from #cd_cena m (nolock)                                            ');
   Qr.SQL.Add('group by m.NN_NAKL,                                                 ');
   Qr.SQL.Add('         m.DATEN,                                                   ');
   Qr.SQL.Add('         m.Kod_Name,                                                ');
   Qr.SQL.Add('         m.Art_Code,                                                ');
   Qr.SQL.Add('         m.Names,                                                   ');
   Qr.SQL.Add('         m.Art_Name,                                                ');
   Qr.SQL.Add('         m.F_NDS,                                                   ');
   Qr.SQL.Add('         m.ForCHP,                                                  ');
   Qr.SQL.Add('         m.DP,                                                      ');
   Qr.SQL.Add('         m.Cena,                                                     ');
   Qr.SQL.Add('         m.Sklad                                                     ');
   Qr.SQL.Add('order by Names                                                      ');
   Qr.Open;
   if Qr.RecordCount>0 then Result:=True else Result:=False;
  except
   Result:=False;
  end;
 end;

// Накладная Переоценка Без НДС
function GetNaklReoc(Qr:TADOQuery; nn:String; Apt_ID:String; D1,D2:TDateTime):Boolean;
 begin
  try
   if Qr.Active then Qr.Close;
   Qr.SQL.Clear;
   Qr.SQL.Add('select rtrim(j.DOCNO) as NN_NAKL,                             ');
   Qr.SQL.Add('       convert(CHAR(8),j.date_time_iddoc,1) as DateN,  ');
   Qr.SQL.Add('       ''         '' as kod_name,                             ');
   Qr.SQL.Add('       rtrim(s.sp5585) as Art_Code,                           ');
   Qr.SQL.Add('       rtrim(s.descr) as Names,                               ');
   Qr.SQL.Add('       '' '' as Manuf,                                        ');
   Qr.SQL.Add('       rtrim(s.SP5596) as ArtName,                            ');
   Qr.SQL.Add('       0 as kol,                                       ');
   Qr.SQL.Add('       rtrim(c.SP8826) as cena,                               ');
   Qr.SQL.Add('       2 as f_nds,                                     ');
   Qr.SQL.Add('       (case when s.PARENTID=''     J'' then 99 else 1 end) as type_tov,       ');
   Qr.SQL.Add('       rtrim(s.sp8238) as ForCHP,                      ');
   Qr.SQL.Add('       0 as Obl,     ');
   Qr.SQL.Add('       '''' as KodPostav,     ');
   Qr.SQL.Add('       '''' as NN_Postav,     ');
   Qr.SQL.Add('       ''0'' as Sklad     ');
   Qr.SQL.Add('                                                       ');
   Qr.SQL.Add('from '+Opt.Gamma+'..DH8819 b (nolock),                 ');
   Qr.SQL.Add('     '+Opt.Gamma+'..DT8819 c (nolock),                 ');
   Qr.SQL.Add('     '+Opt.Gamma+'.._1sjourn j (nolock),               ');
   Qr.SQL.Add('     '+Opt.Gamma+'..sc2918 s (nolock)                  ');
   Qr.SQL.Add('                                                       ');
   Qr.SQL.Add('where j.DOCNO='''+NN+''' and                           ');
   Qr.SQL.Add('      j.date_time_iddoc >= '''+FormatDateTime('yyyymmdd',D1)+''' and     ');
   Qr.SQL.Add('      j.date_time_iddoc < '''+FormatDateTime('yyyymmdd',D2+1)+''' and    ');

   Qr.SQL.Add('      s.id=c.SP8824 and                                ');
   Qr.SQL.Add('      b.SP8827 = '''+Apt_ID+''' and                    ');
   Qr.SQL.Add('      b.iddoc = j.iddoc and                            ');
   Qr.SQL.Add('      b.iddoc = j.iddoc and                            ');
   Qr.SQL.Add('      c.iddoc=b.iddoc and                              ');
   Qr.SQL.Add('      j.ISMARK = 0 and  b.SP8829=''   2LW''            ');
   Qr.SQL.Add('      and (j.CLOSED > 0)                  ');

   Qr.Open;
   if Qr.RecordCount>0 then Result:=True else Result:=False;
  except
   Result:=False;
  end;
 end;

// Накладная Переоценка НДС
function GetNaklReocNDS(Qr:TADOQuery; nn:String; Apt_ID:String; D1,D2:TDateTime):Boolean;
 begin
  try
   if Qr.Active then Qr.Close;
   Qr.SQL.Clear;
   Qr.SQL.Add('select rtrim(j.DOCNO) as NN_NAKL,                             ');
   Qr.SQL.Add('       convert(CHAR(8),j.date_time_iddoc,1) as DateN,  ');
   Qr.SQL.Add('       ''         '' as kod_name,                             ');
   Qr.SQL.Add('       rtrim(s.sp5585) as Art_Code,                           ');
   Qr.SQL.Add('       rtrim(s.descr) as Names,                               ');
   Qr.SQL.Add('       '' '' as Manuf,                                        ');
   Qr.SQL.Add('       rtrim(s.SP5596) as ArtName,                            ');
   Qr.SQL.Add('       0 as kol,                                       ');
   Qr.SQL.Add('       rtrim(c.SP8826) as cena,                               ');
   Qr.SQL.Add('       1 as f_nds,                                     ');
   Qr.SQL.Add('       (case when s.PARENTID=''     J'' then 99 else 2 end) as type_tov,       ');
   Qr.SQL.Add('       rtrim(s.sp8238) as ForCHP ,                             ');
   Qr.SQL.Add('       0 as Obl,     ');
   Qr.SQL.Add('       '''' as KodPostav,     ');
   Qr.SQL.Add('       '''' as NN_Postav,     ');
   Qr.SQL.Add('       ''0'' as Sklad     ');
   Qr.SQL.Add('                                                       ');
   Qr.SQL.Add('from '+Opt.Gamma+'..DH8819 b (nolock),                 ');
   Qr.SQL.Add('     '+Opt.Gamma+'..DT8819 c (nolock),                 ');
   Qr.SQL.Add('     '+Opt.Gamma+'.._1sjourn j (nolock),               ');
   Qr.SQL.Add('     '+Opt.Gamma+'..sc2918 s (nolock)                  ');
   Qr.SQL.Add('                                                       ');
   Qr.SQL.Add('where j.DOCNO='''+NN+''' and                           ');
   Qr.SQL.Add('      j.date_time_iddoc >= '''+FormatDateTime('yyyymmdd',D1)+''' and     ');
   Qr.SQL.Add('      j.date_time_iddoc < '''+FormatDateTime('yyyymmdd',D2+1)+''' and    ');
   Qr.SQL.Add('      s.id=c.SP8824 and                                ');
   Qr.SQL.Add('      b.SP8827 = '''+Apt_ID+''' and                    ');
   Qr.SQL.Add('      b.iddoc = j.iddoc and                            ');
   Qr.SQL.Add('      b.iddoc = j.iddoc and                            ');
   Qr.SQL.Add('      c.iddoc=b.iddoc and                              ');
   Qr.SQL.Add('      j.ISMARK = 0 and  b.SP8829=''   2LV''            ');
   Qr.SQL.Add('      and (j.CLOSED > 0 )                  ');

   Qr.Open;
   if Qr.RecordCount>0 then Result:=True else Result:=False;
  except
   Result:=False;
  end;
 end;

{


   Qr.SQL.Add('update #cd_cena set Cena=Convert (numeric(8,2),isnull(d.value,0))   ');
   Qr.SQL.Add('from '+Opt.Gamma+'..sc2918 aa (nolock),                             ');
   Qr.SQL.Add('     '+Opt.Gamma+'..sc3950 c (nolock) ,                             ');
   Qr.SQL.Add('     '+Opt.Gamma+'.._1sconst d (nolock),                            ');
   Qr.SQL.Add('     #cd_cena m (nolock)                                            ');
   Qr.SQL.Add('                                                                    ');
   Qr.SQL.Add('where c.sp3951 = '''+Gr+''' and                                     ');
   Qr.SQL.Add('      m.kod_name=aa.code and                                        ');
   Qr.SQL.Add('      c.PARENTEXT=aa.id and                                         ');
   Qr.SQL.Add('      d.id=3952 and                                                 ');
   Qr.SQL.Add('      d.objid = c.id and                                            ');
   Qr.SQL.Add('      d.date=(select max(t.date)                                    ');
   Qr.SQL.Add('              from '+Opt.Gamma+'.._1sconst t (nolock)               ');
   Qr.SQL.Add('              where d.objid = t.objid and                           ');
   Qr.SQL.Add('                    t.id=3952 and                                   ');
   Qr.SQL.Add('                    t.objid = c.id and                              ');
   Qr.SQL.Add('                    t.date<=@dat                                    ');
   Qr.SQL.Add('             )                                                      ');


}
END.
