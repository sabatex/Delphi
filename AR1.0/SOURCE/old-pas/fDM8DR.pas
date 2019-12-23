unit fDM8DR;

interface

uses
  SysUtils, Classes, Halcn6DB, DB, DdeMan, ExtCtrls,Variants,
  Dialogs,Forms,ComCtrls,FGInt,StdCtrls,fConfigStorage,Types,Controls,
  crypto_keys, ImgList, StdActns, ActnList, FR_Class, FR_Rich, FR_DSet,
  FR_DBSet, FR_DCtrl;

type
  EEDRPOUError = class(Exception);
  E8DRInitializeError = class(Exception);
  TFirms = class(TRegistrationInfo)
  private
    procedure SetBOSSCOD(const Value: string);
    procedure SetBOSSNAME(const Value: string);
    procedure SetBOSSTELL(const Value: string);
    procedure SetCODOBL(const Value: String);
    procedure SetCODPOD(const Value: String);
    procedure SetEDRPOUPOD(const Value: String);
    procedure SetPODNAME(const Value: String);
    procedure SetSHIEFCOD(const Value: String);
    procedure SetSHIEFNAME(const Value: String);
    procedure SetSHIEFTELL(const Value: String);
    function GetBOSSCOD: string;
    function GetBOSSNAME: string;
    function GetBOSSTELL: string;
    function GetCODOBL: String;
    function GetCODPOD: String;
    function GetEDRPOUPOD: String;
    function GetPODNAME: String;
    function GetSHIEFCOD: String;
    function GetSHIEFNAME: String;
    function GetSHIEFTELL: String;
    function GetFromIni(ParName:string):string;
    procedure SetToIni(ParName,Value:string);
  public
    property BOSSNAME:string  read GetBOSSNAME write SetBOSSNAME;
    property BOSSCOD:string read GetBOSSCOD write SetBOSSCOD;
    property BOSSTELL:string read GetBOSSTELL write SetBOSSTELL;
    property SHIEFNAME: String read GetSHIEFNAME write SetSHIEFNAME;
    property SHIEFCOD: String read GetSHIEFCOD write SetSHIEFCOD;
    property SHIEFTELL: String read GetSHIEFTELL write SetSHIEFTELL;
    property EDRPOUPOD: String read GetEDRPOUPOD write SetEDRPOUPOD;
    property PODNAME: String read GetPODNAME write SetPODNAME;
    property CODOBL: String read GetCODOBL write SetCODOBL;
    property CODPOD: String read GetCODPOD write SetCODPOD;
    procedure Registration(FileName:string);reintroduce;
  end;

  TdmFunction = class(TDataModule)
    DA: THalcyonDataSet;
    CreateDA: TCreateHalcyonDataSet;
    DANP: TIntegerField;
    DAPERIOD: TSmallintField;
    DARIK: TSmallintField;
    DAKOD: TStringField;
    DATYP: TSmallintField;
    DAS_DOX: TFloatField;
    DAOZN_DOX: TSmallintField;
    DAOZN_PILG: TSmallintField;
    DAOZNAKA: TSmallintField;
    dsDA: TDataSource;
    Wokers: THalcyonDataSet;
    WokersEDRPOU: TStringField;
    WokersNAME: TStringField;
    DAWokerName: TStringField;
    dsWokers: TDataSource;
    SaveDialogOut: TSaveDialog;
    DATIN: TStringField;
    DATINL: TStringField;
    DAD_PRIYN: TDateField;
    DAD_ZVILN: TDateField;
    DAS_NAR: TFloatField;
    DAS_TAXN: TFloatField;
    DAS_TAXP: TFloatField;
    ListTables: THalcyonDataSet;
    ListTablesID: TSmallintField;
    ListTablesTABLENAME: TStringField;
    ListTablesFIRSTNUM: TStringField;
    ListTablesLASTNUM: TStringField;
    ListTablesIDNUM: TStringField;
    ListTablesINWOKER: TStringField;
    ListTablesOUTWOKER: TStringField;
    ListTablesWOKERNAME: TStringField;
    Options: THalcyonDataSet;
    OptionsID: TSmallintField;
    OptionsNAMEPOS: TStringField;
    OptionsNARAX: TStringField;
    OptionsPODAT: TStringField;
    OptionsPILGA: TStringField;
    OptionsNEOPL: TStringField;
    OptionsVIPLAT: TStringField;
    OptionsVIPPODAT: TStringField;
    dsListTables: TDataSource;
    dsOptions: TDataSource;
    odConfig: TOpenDialog;
    sdConfig: TSaveDialog;
    ListTablesVID: TSmallintField;
    OptionsCOD: TSmallintField;
    odInsertFromFile: TOpenDialog;
    ImageList: TImageList;
    ActionList: TActionList;
    WindowClose1: TWindowClose;
    HelpContextAction1: THelpContextAction;
    HelpOnHelp: THelpOnHelp;
    WindowClose2: TWindowClose;
    WindowCascade1: TWindowCascade;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowTileVertical1: TWindowTileVertical;
    WindowMinimizeAll1: TWindowMinimizeAll;
    WindowArrange1: TWindowArrange;
    aEdit8DR: TAction;
    aEditWokers: TAction;
    Export8DR: TAction;
    ExportConfig1C60: TAction;
    Report8DR: TAction;
    Import8DRfrom1C60: TAction;
    ImportConfig1C60: TAction;
    FirmsParam: TAction;
    Configuration1C60: TAction;
    FileExit: TFileExit;
    FilePrintSetup: TFilePrintSetup;
    Registration: TAction;
    Import8DRfrom1c77: TAction;
    Configuration1c77: TAction;
    LGT: THalcyonDataSet;
    LGTKOD: TSmallintField;
    LGTNAME: TStringField;
    dsLGT: TDataSource;
    OZN: THalcyonDataSet;
    dsOZN: TDataSource;
    frDialogControls1: TfrDialogControls;
    frDBDataSetDA: TfrDBDataSet;
    frRichObject1: TfrRichObject;
    frReport1: TfrReport;
    OpenDialog1: TOpenDialog;
    procedure DataModuleCreate(Sender: TObject);
    procedure DAAfterPost(DataSet: TDataSet);
    procedure DAAfterInsert(DataSet: TDataSet);
    procedure WokersEDRPOUValidate(Sender: TField);
    procedure WokersBeforeDelete(DataSet: TDataSet);
    procedure DataModuleDestroy(Sender: TObject);
    procedure OptionsNewRecord(DataSet: TDataSet);
    procedure ListTablesAfterScroll(DataSet: TDataSet);
    procedure ListTablesNewRecord(DataSet: TDataSet);
    procedure Import8DRfrom1C60Execute(Sender: TObject);
    procedure ImportConfig1C60Execute(Sender: TObject);
    procedure FirmsParamExecute(Sender: TObject);
    procedure Configuration1C60Execute(Sender: TObject);
    procedure Configuration1c77Execute(Sender: TObject);
    procedure Import8DRfrom1c77Execute(Sender: TObject);
    procedure RegistrationExecute(Sender: TObject);
    procedure frReport1GetValue(const ParName: String;
      var ParValue: Variant);
    procedure ExportConfig1C60Execute(Sender: TObject);
    procedure Export8DRExecute(Sender: TObject);
    procedure Report8DRExecute(Sender: TObject);
    procedure aEditWokersExecute(Sender: TObject);
    procedure aEdit8DRExecute(Sender: TObject);
    procedure frReport1UserFunction(const Name: String; p1, p2,
      p3: Variant; var Val: Variant);
  private
     { Private declarations }
    DdeClientConv: TDdeClientConv;
    FDate:TDateTime;
    FFilter:string;
    FInitialize:boolean;
    function GetCurrentYear: integer;
    function GetCurrentPeriod: integer;
    procedure SetDate(const Value: TDateTime);
    function GetCurrentYearShort: string;
    function GetPredCurrentYearShort: string;
    procedure SetFilter1C(const Value: string);
  public
    procedure ChangeFilter;
    procedure ExportReport8DR;
    property CurrentDate:TDateTime read FDate write SetDate;
    property CurrentYear:integer read GetCurrentYear;
    property CurrentPeriod:integer read GetCurrentPeriod;
    property CyrrentYearShort:string read GetCurrentYearShort;
    property PredCyrrentYearShort:string read GetPredCurrentYearShort;
    property Filter1C:string read FFilter write SetFilter1C;
    function GetDDEItem(s: string): string;
    procedure LoadAsConfig(FileName:string = '');
    procedure SaveAsConfig;
    procedure ImportFrom1c60();
    procedure ImportFrom1c77();
    function KvartalOff(D:TDateTime):integer;
    procedure InsertFromFile;
  end;

var
  dmFunction: TdmFunction;
  Firms:TFirms;

implementation

uses EnKey,f8DRConst, ntics_classes, IniFiles, DateUtils, fGauge,
     FormManager, fAbout, FirmsOptions, fConfig1c60, fWokersParams,
  f8DREdit;

{$R *.dfm}

procedure TdmFunction.DataModuleCreate(Sender: TObject);
var
  s: string;
begin
  FInitialize:=False;
  DdeClientConv:=TDdeClientConv.Create(nil);
  DdeClientConv.ConnectMode:=ddeManual;
  s:=ExtractFilePath(Application.ExeName);
  Wokers.DatabaseName:=s;
  Da.DatabaseName:=s;
  LGT.DatabaseName:=s;
  OZN.DatabaseName:=s;
  OZN.Open;
  LGT.Open;
  Wokers.Open;
  DA.Open;
  FInitialize:=true;
  Firms:=TFirms.Create(dkey,nkey);
  RegistrationInfo:=Firms;
  CurrentDate:=StrToDate(ConfigStorage.LoadValue('CurrentDate','01.01.1999'));

  Options.DatabaseName:=s;
  Options.Open;

  ListTables.DatabaseName:=s;
  Filter1C:='66';
  ListTables.Open;
end;

procedure TdmFunction.ChangeFilter;
var
  s:string;
begin
  // Устанавливаем фильтр
  with DA do
  begin
    Filtered:=false;

    s:='(PERIOD = '+ IntToStr(CurrentPeriod) +
       ') AND (RIK = ' + IntToStr(CurrentYear) + ')';
    Filter:=s;
    Filtered:=True;
  end;
end;


procedure TdmFunction.ExportReport8DR;
var
  OutTable:THalcyonDataSet;
  s_dox,s_nar,s_taxp,s_taxn:Extended;
begin
  SaveDialogOut.FileName:='A:\DA'+Firms.CODOBL+Firms.CODPOD+'01.'+IntToStr(CurrentPeriod);
  if SaveDialogOut.Execute then
  begin
    OutTable:=THalcyonDataSet.Create(nil);
    OutTable.TableName:=SaveDialogOut.FileName;
    CreateDA.DBFTable:=OutTable;
    CreateDA.Execute;
    OutTable.Open;
    s_dox:=0;
    s_nar:=0;
    s_taxp:=0;
    s_taxn:=0;
    DA.First;
    while not DA.Eof do
    begin
      OutTable.Append;
      OutTable['NP']:=DANP.Value;
      OutTable['PERIOD']:=DAPERIOD.Value;
      OutTable['RIK']:=DARIK.Value;
      OutTable['KOD']:=DAKOD.Value;
      OutTable['TYP']:=DATYP.Value;
      OutTable['TIN']:=DATIN.Value;
      OutTable['S_DOX']:=DAS_DOX.Value;
      OutTable['S_TAXN']:=DAS_TAXN.Value;
      OutTable['S_TAXP']:=DAS_TAXP.Value;
      OutTable['S_NAR']:=DAS_NAR.Value;
      OutTable['OZN_DOX']:=DAOZN_DOX.Value;
      if DAD_PRIYN.Value<>0 then
        OutTable['D_PRIYN']:=DAD_PRIYN.Value;
      if DAD_ZVILN.Value<>0 then
        OutTable['D_ZVILN']:=DAD_ZVILN.Value;
      OutTable['OZN_PILG']:=DAOZN_PILG.Value;
      OutTable['OZNAKA']:=DAOZNAKA.Value;
      OutTable.Post;
      s_dox:=s_dox+DA['S_DOX'];
      s_nar:=s_nar+DA['S_NAR'];
      s_taxp:=s_taxp+DA['S_TAXP'];
      s_taxn:=s_taxn+DA['S_TAXN'];
      DA.Next;
    end;

    // 99991 record
    OutTable.Append;
    OutTable['NP']:=99991;
    OutTable['TIN']:=Firms.BOSSCOD;
    if Firms.BOSSTELL='' then
      OutTable['S_DOX']:=0
    else
      OutTable['S_DOX']:=StrToFloat(Firms.BOSSTELL);
    // PERIOD
    OutTable['PERIOD']:=DAPERIOD.Value;
    OutTable['RIK']:=DARIK.Value;
    // KOD and TYP
    OutTable['KOD']:=Firms.EDRPOU;
    OutTable['TYP']:=Firms.TFO;
    OutTable.Post;

    // 99992 record
    OutTable.Append;
    OutTable['NP']:=99992;
    OutTable['TIN']:=Firms.SHIEFCOD;
    if Firms.SHIEFTELL='' then
      OutTable['S_DOX']:=0
    else
      OutTable['S_DOX']:=StrToFloat(Firms.SHIEFTELL);
    // PERIOD
    OutTable['PERIOD']:=DAPERIOD.Value;
    OutTable['RIK']:=DARIK.Value;
    // KOD and TYP
    OutTable['KOD']:=Firms.EDRPOU;
    OutTable['TYP']:=Firms.TFO;
    OutTable.Post;

    // 99999 record
    OutTable.Append;
    OutTable['NP']:=99999;
    OutTable['S_NAR']:=s_nar;
    OutTable['S_DOX']:=s_dox;
    OutTable['S_TAXP']:=s_taxp;
    OutTable['S_TAXN']:=s_taxn;

    // PERIOD
    OutTable['PERIOD']:=DAPERIOD.Value;
    OutTable['RIK']:=DARIK.Value;
    // KOD and TYP
    OutTable['KOD']:=Firms.EDRPOU;
    //OutTable['TIN']:=FirmsWUSER.Value;
    OutTable['TYP']:=Firms.TFO;
    OutTable.Post;

    OutTable.Close;
    OutTable.Free;
  end;
end;

procedure TdmFunction.DAAfterPost(DataSet: TDataSet);
begin
  if Firms.LicenzeCount = 0 then
    if DANP.Value > 5 then
      DataSet.Delete;
end;

procedure TdmFunction.DAAfterInsert(DataSet: TDataSet);
begin
  DAPERIOD.Value:=CurrentPeriod;
  DARIK.Value:=CurrentYear;
  DAKOD.Value:=Firms.EDRPOU;
end;

procedure TdmFunction.WokersEDRPOUValidate(Sender: TField);
var
  Temp:THalcyonDataSet;
begin
  Temp:=THalcyonDataSet.Create(nil);
  Temp.DatabaseName:=Wokers.DatabaseName;
  temp.TableName:=Wokers.TableName;
  temp.Open;
  try
    if temp.Locate('EDRPOU',Sender.Value,[]) then
      raise EEDRPOUError.Create('Даний номер: '+Sender.Value
                             + ' уже присвоєно '+string(Temp['NAME']));
  finally
    Temp.Close;
    Temp.Free;
  end;
end;

procedure TdmFunction.WokersBeforeDelete(DataSet: TDataSet);
begin
  DA.Filtered:=false;
  try
    if DA.Locate('TIN',DataSet['EDRPOU'],[]) then
      raise Exception.Create('По даній людині існують записи !!! Видалити неможливо.');
  finally
    DA.Filtered:=true;
  end;
end;

function TdmFunction.GetCurrentYear: integer;
begin
  Result:=YearOf(FDate);
end;

function TdmFunction.GetCurrentPeriod: integer;
begin
  Result:=MonthOf(Fdate) div 3;
  if (MonthOf(Fdate) mod 3) <> 0 then
    inc(Result);
end;

{ TFirms }

function TFirms.GetBOSSCOD: string;
begin
  Result:=GetFromIni('BOSSCOD');
end;

function TFirms.GetBOSSNAME: string;
begin
  Result:=GetFromIni('BOSSNAME');
end;

function TFirms.GetBOSSTELL: string;
begin
  Result:=GetFromIni('BOSSTELL');
end;

function TFirms.GetCODOBL: String;
begin
  Result:=GetFromIni('CODOBL');
end;

function TFirms.GetCODPOD: String;
begin
  Result:=GetFromIni('CODPOD');
end;

function TFirms.GetEDRPOUPOD: String;
begin
  Result:=GetFromIni('EDRPOUPOD');
end;

function TFirms.GetFromIni(ParName: string): string;
var
  INIFile:TIniFile;
begin
  INIFile:=TIniFile.Create(ConfigStorage.StorageName);
  Result:=INIFile.ReadString(FirmName,ParName,'');
  INIFile.Free;
end;

function TFirms.GetPODNAME: String;
begin
  Result:=GetFromIni('PODNAME');
end;

function TFirms.GetSHIEFCOD: String;
begin
  Result:=GetFromIni('SHIEFCOD');
end;

function TFirms.GetSHIEFNAME: String;
begin
  Result:=GetFromIni('SHIEFNAME')
end;

function TFirms.GetSHIEFTELL: String;
begin
  Result:=GetFromIni('SHIEFTELL');
end;

procedure TFirms.Registration(FileName: string);
var
  f:text;
  s:string;
begin
  AssignFile(f,FileName);
  Reset(f);
  Readln(f,s);
  inherited Registration(s);
  CloseFile(f);
end;

procedure TFirms.SetBOSSCOD(const Value: string);
begin
  SetToIni('BOSSCOD',Value);
end;

procedure TFirms.SetBOSSNAME(const Value: string);
begin
  SetToIni('BOSSNAME',Value);
end;

procedure TFirms.SetBOSSTELL(const Value: string);
begin
  SetToIni('BOSSTELL',Value);
end;

procedure TFirms.SetCODOBL(const Value: String);
begin
  SetToIni('CODOBL',Value);
end;

procedure TFirms.SetCODPOD(const Value: String);
begin
  SetToIni('CODPOD',Value);
end;

procedure TFirms.SetEDRPOUPOD(const Value: String);
begin
  SetToIni('EDRPOUPOD',Value);
end;

procedure TFirms.SetPODNAME(const Value: String);
begin
  SetToIni('PODNAME',Value);
end;

procedure TFirms.SetSHIEFCOD(const Value: String);
begin
  SetToIni('SHIEFCOD',Value);
end;

procedure TFirms.SetSHIEFNAME(const Value: String);
begin
  SetToIni('SHIEFNAME',Value);
end;

procedure TFirms.SetSHIEFTELL(const Value: String);
begin
  SetToIni('SHIEFTELL',Value);
end;

procedure TdmFunction.SetDate(const Value: TDateTime);
begin
  FDate := Value;
  {if Assigned(MainDlg) then
    MainDlg.sbMain.Panels[1].Text:=IntToStr(CurrentYear)+'р. '
                                 + IntToStr(CurrentPeriod)+' квартал';
  }
  ChangeFilter;
end;

procedure TdmFunction.DataModuleDestroy(Sender: TObject);
begin
  ConfigStorage.SaveValue('CurrentDate',DateToStr(CurrentDate));
  Firms.Free;
end;

procedure TFirms.SetToIni(ParName, Value: string);
var
  INIFile:TIniFile;
begin
  INIFile:=TIniFile.Create(ConfigStorage.StorageName);
  INIFile.WriteString(FirmName,ParName,Value);
  INIFile.Free;
end;

function TdmFunction.GetCurrentYearShort: string;
var
  i:integer;
begin
  i:=0;
  while i<CurrentYear do inc(i,100);
  Result:=IntToStr(CurrentYear-(i-100));
  if Length(Result)<2 then
    Result:='0'+Result;
end;

function TdmFunction.GetPredCurrentYearShort: string;
var
  i:integer;
begin
  i:=0;
  while i<(CurrentYear-1) do inc(i,100);
  Result:=IntToStr(CurrentYear-(i-100)-1);
  if Length(Result)<2 then
    Result:='0'+Result;
end;

procedure TdmFunction.OptionsNewRecord(DataSet: TDataSet);
begin
  OptionsID.Value:=ListTablesID.Value;
end;

function TdmFunction.GetDDEItem(s: string): string;
function ifelse(tf:boolean;arg1,arg2:string):string;
begin
  if tf then Result:=arg1 else Result:=arg2;
end;
begin
  // Макроподстановки ************
  // $ГОД,$КВАРТАЛ,$ДАТА,$ГОД2
  s:=StringReplace(s,'$ГКВ6.0','Г'+CyrrentYearShort+';КВ'+inttostr(CurrentPeriod),[rfReplaceAll]);
  s:=StringReplace(s,'$ГМ1_6.0','Г'+CyrrentYearShort+';М'+inttostr(CurrentPeriod*3-2),[rfReplaceAll]);
  s:=StringReplace(s,'$ГМ2_6.0','Г'+CyrrentYearShort+';М'+inttostr(CurrentPeriod*3-1),[rfReplaceAll]);
  s:=StringReplace(s,'$ГМ3_6.0','Г'+CyrrentYearShort+';М'+inttostr(CurrentPeriod*3-2),[rfReplaceAll]);
  s:=StringReplace(s,'$ГМП_6.0',ifelse(CurrentPeriod=1,
                   'Г'+PredCyrrentYearShort+';М12',
                   'Г'+CyrrentYearShort+';М'+inttostr(CurrentPeriod*3-3)),[rfReplaceAll]);
  s:=StringReplace(s,'$ГОД2',CyrrentYearShort,[rfReplaceAll]);
  s:=StringReplace(s,'$ГОД4',inttostr(CurrentYear),[rfReplaceAll]);
  s:=StringReplace(s,'$ГОД',inttostr(CurrentYear),[rfReplaceAll]);
  s:=StringReplace(s,'$КВАРТАЛ',inttostr(CurrentPeriod),[rfReplaceAll]);
  s:=StringReplace(s,'$ДАТА',DateToStr(CurrentDate),[rfReplaceAll]);
  s:=StringReplace(s,'$ЄДРПОУ',Firms.EDRPOU,[rfReplaceAll]);
  s:=StringReplace(s,'$ОЗНАКАДОХОДУ',IntToStr(OptionsCOD.Value),[rfReplaceAll]);
  s:=StringReplace(s,'$Г2',CyrrentYearShort,[rfReplaceAll]);
  s:=StringReplace(s,'$Г4',inttostr(CurrentYear),[rfReplaceAll]);
  s:=StringReplace(s,'$КВ',inttostr(CurrentPeriod),[rfReplaceAll]);
  s:=StringReplace(s,'$Д',DateToStr(CurrentDate),[rfReplaceAll]);
  s:=StringReplace(s,'$ЄД',Firms.EDRPOU,[rfReplaceAll]);
  s:=StringReplace(s,'$ОЗНД',IntToStr(OptionsCOD.Value),[rfReplaceAll]);

  Result:=DdeClientConv.RequestData(s);
  Result:=''+Result;
end;

procedure TdmFunction.LoadAsConfig(FileName:string = '');
var
  dest,sourc:file;
  Buffer:array[0..128] of byte;
  SizeFile:integer absolute Buffer[0];
  NumRead, NumWritten, SizeTable: Integer;
begin
  if (FileName<>'') or (odConfig.Execute) then
  begin
    if FileName<>'' then
      AssignFile(sourc,FileName)
    else
      AssignFile(sourc,odConfig.FileName);
    Reset(sourc,1);
    // Load version file
    BlockRead(sourc,Buffer,1,NumRead);
    case Buffer[0] of
      1:begin
         Options.Close;
         ListTables.Close;
         // load table ListTables
         AssignFile(dest,ExtractFilePath(Application.ExeName) + ListTables.TableName);
         Rewrite(dest,1);
         BlockRead(sourc,Buffer,sizeof(SizeFile),NumRead);
         SizeTable:=SizeFile;
         repeat
           if SizeTable>=SizeOf(Buffer) then
             BlockRead(sourc, Buffer, SizeOf(Buffer), NumRead)
           else
             BlockRead(sourc, Buffer, SizeTable, NumRead);
           BlockWrite(dest, Buffer, NumRead, NumWritten);
           SizeTable:=SizeTable - NumRead;
         until (NumRead = 0) or (NumWritten <> NumRead) or (SizeTable = 0);
         Close(dest);

         // load table Options
         AssignFile(dest,ExtractFilePath(Application.ExeName) + Options.TableName);
         Rewrite(dest,1);
         BlockRead(sourc,Buffer,sizeof(SizeFile),NumRead);
         SizeTable:=SizeFile;
         repeat
           if SizeTable>=SizeOf(Buffer) then
             BlockRead(sourc, Buffer, SizeOf(Buffer), NumRead)
           else
             BlockRead(sourc, Buffer, SizeTable, NumRead);
           BlockWrite(dest, Buffer, NumRead, NumWritten);
           SizeTable:=SizeTable - NumRead;
         until (NumRead = 0) or (NumWritten <> NumRead) or (SizeTable = 0);
         Close(dest);
         ListTables.Open;
         Options.Open;
        end;
      else ShowMessage('Версия даного файла не корректна. Завантаження прервано');

    end;
     Close(sourc);
  end;
end;

procedure TdmFunction.SaveAsConfig;
var
  dest,sourc:file;
  Buffer:array[0..128] of byte;
  SizeFile:integer absolute Buffer[0];
  NumRead, NumWritten: Integer;
begin
  if sdConfig.Execute then
  begin
    AssignFile(dest,sdConfig.FileName);
    Rewrite(dest,1);
    // write version file
    Buffer[0]:=VersionConfig;
    BlockWrite(dest,Buffer,1,NumWritten);
    // write table ListTables
    AssignFile(sourc,ExtractFilePath(Application.ExeName) + ListTables.TableName);
    Reset(sourc,1);
    SizeFile:=FileSize(sourc);
    BlockWrite(dest,Buffer,sizeof(SizeFile),NumWritten);
    repeat
      BlockRead(sourc, Buffer, SizeOf(Buffer), NumRead);
      BlockWrite(dest, Buffer, NumRead, NumWritten);
    until (NumRead = 0) or (NumWritten <> NumRead);
    Close(sourc);
    // write table Options
    AssignFile(sourc,ExtractFilePath(Application.ExeName) + Options.TableName);
    Reset(sourc,1);
    SizeFile:=FileSize(sourc);
    BlockWrite(dest,Buffer,sizeof(SizeFile),NumWritten);
    repeat
      BlockRead(sourc, Buffer, SizeOf(Buffer), NumRead);
      BlockWrite(dest, Buffer, NumRead, NumWritten);
    until (NumRead = 0) or (NumWritten <> NumRead);
    Close(sourc);
    CloseFile(dest);
  end;
end;


procedure TdmFunction.ImportFrom1c60();
var
  WUser:integer;
  j,i:integer;
  s_dox,s_tax,s_dox_sp,s_tax_sp,fn,temp:Extended;
  prefix,s,sd,WokerName:string;
  frmGauge:TfrmGauge;

begin
  // спробуємо зєднатись з 1С
  if (not DdeClientConv.SetLink('БУХ','ВЫР')) or (not DdeClientConv.OpenLink) then
  begin
    ShowMessage(NoStart1C60);
    Exit;
  end;
  frmGauge:=TfrmGauge(ShowForm(TfrmGauge,'Імпорт даних з 1С6.0',ftMDI));

  Filter1C:='66';
  // Очистимо базу
  if not dmFunction.DA.IsEmpty then
  begin
    if MessageDlg('Всі дані на даний період буде знищено. Продовжити ?',
                  mtWarning,mbOKCancel,0) = mrCancel then Exit;
    frmGauge.Caption:='Очистка бази за текучий період';
    frmGauge.Min:=1;
    frmGauge.Max:=dmFunction.DA.RecordCount;
    frmGauge.Position:=1;
    dmFunction.DA.First;
    while not dmFunction.DA.Eof do
    begin
      dmFunction.DA.Delete;
      frmGauge.Position:=frmGauge.Position + 1;
    end;
  end;

  // Імпортуємо дані
  j:=1;

  // Перебираємо всі списки
  ListTables.First;
  while not ListTables.Eof do
  begin
    // Перебираемо всі елементи в списку
    frmGauge.Max:=StrToint(GetDDEItem(ListTablesLASTNUM.Value));
    frmGauge.Min:=StrToint(GetDDEItem(ListTablesFIRSTNUM.Value));
    frmGauge.Caption:='Імпорт даних з 1С6.0 по довіднику ' +
                               ListTablesTABLENAME.Value;
    for i:=frmGauge.Min to frmGauge.Max do
    begin
      frmGauge.Position:=i;
      // Определяеем существование идентификационного номера
      s:=StringReplace(ListTablesIDNUM.Value,'&',inttostr(i),[rfReplaceAll]);
      sd:=GetDDEItem(s);
      if sd<>'' then
      begin
        // Выравнивание номера добавкой нулей
        while length(sd)<10  do sd:='0' + sd;
        // Имя сотрудника
        s:=StringReplace(ListTablesWOKERNAME.Value,'&',inttostr(i),[rfReplaceAll]);
        WokerName:=GetDDEItem(s);

        // Перебираемо всі види нарахувань
        Options.First;
        while not Options.Eof do
        begin
          s_dox:=0;s_tax:=0;s_dox_sp:=0;s_tax_sp:=0;fn:=0;
          // Input s_dox from 1s
          s:=StringReplace(OptionsNARAX.Value,'&',inttostr(i),[rfReplaceAll]);
          if s<>'' then s_dox:=StrToFloat(GetDDEItem(s));
          // Input s_dox from 1s
          s:=StringReplace(OptionsVIPLAT.Value,'&',inttostr(i),[rfReplaceAll]);
          if s<>'' then s_dox_sp:=StrToFloat(GetDDEItem(s));
          // Input s_dox from 1s
          s:=StringReplace(OptionsVIPPODAT.Value,'&',inttostr(i),[rfReplaceAll]);
          if s<>'' then s_tax_sp:=StrToFloat(GetDDEItem(s));
          // Input s_tax from 1s
          s:=StringReplace(OptionsPODAT.Value,'&',inttostr(i),[rfReplaceAll]);
          if s<>'' then s_tax:=StrToFloat(GetDDEItem(s));

          // Input flag creditor 1s
          s:=StringReplace(OptionsNEOPL.Value,'&',inttostr(i),[rfReplaceAll]);
          if s<>'' then  fn:=StrToFloat(GetDDEItem(s));

          if (s_dox<>0) or (s_tax<>0) or (s_dox_sp<>0) or (s_tax_sp<>0) or (fn=1) then
          begin
            // Заполняем список сотрудников
            if not dmFunction.Wokers.Locate('EDRPOU',sd,[]) then
            begin
              dmFunction.Wokers.Append;
              dmFunction.WokersEDRPOU.Value:=sd;
              dmFunction.WokersNAME.Value:=WokerName;
              dmFunction.Wokers.Post;
            end
            else
            begin
              if dmFunction.WokersNAME.Value<>WokerName then
                if MessageDlg('Попередження !!! Для номера '
                       + dmFunction.WokersEDRPOU.Value + 'який зареєстрований за '
                       + dmFunction.WokersNAME.Value + ' буде переєресторовано на '
                       + WokerName + '.',mtWarning,[mbYes,mbNo],0) = mrYes then
              begin
                dmFunction.Wokers.Edit;
                dmFunction.WokersNAME.Value:=WokerName;
                dmFunction.Wokers.Post;
              end;
            end;
            with dmFunction do
            begin
              if not DA.Locate('TIN;OZN_DOX', VarArrayOf([sd,OptionsCOD.Value]),[]) then
                DA.Append
              else
                DA.Edit;
              // NP
              DANP.Value:=j;
              inc(j);
              DAPERIOD.Value:=CurrentPeriod;
              DARIK.Value:=CurrentYear;
              DAKOD.Value:= Firms.EDRPOU;
              DATYP.Value:=WUser;
              DATIN.Value:=sd;
              DAS_DOX.Value:=DAS_DOX.Value+s_dox_sp;
              DAS_TAXN.Value:=DAS_TAXN.Value+s_tax;
              DAS_NAR.Value:=DAS_NAR.Value+s_dox;
              DAS_TAXP.Value:=DAS_TAXP.Value+s_tax_sp;
              DAOZN_DOX.Value:=OptionsCOD.Value;
              // D_PRIYN
              s:=StringReplace(ListTablesINWOKER.Value,'&',inttostr(i),[rfReplaceAll]);
              s:=GetDDEItem(s);
              delete(s,pos(',',s),3);
              if Length(s)=7 then s:='0'+s;
              if Length(s)=8 then
              begin
                if (StrToInt(copy(s,5,4))=CurrentYear) and
                   (((StrToInt(copy(s,3,2))-1) div 3 + 1)=CurrentPeriod) then
                begin
                  s:=copy(s,1,2)+'.'+copy(s,3,2)+'.'+copy(s,5,4);
                  DAD_PRIYN.Value:=StrToDate(s);
                end;
              end;

              // D_ZVILN
              s:=StringReplace(ListTablesOUTWOKER.Value,'&',inttostr(i),[rfReplaceAll]);
              s:=GetDDEItem(s);
              delete(s,pos(',',s),3);
              if Length(s)=7 then s:='0'+s;
              if Length(s)=8 then
              begin
                if (StrToInt(copy(s,5,4))=CurrentYear) and
                   (((StrToInt(copy(s,3,2))-1) div 3 + 1)=CurrentPeriod) then
                begin
                  s:=copy(s,1,2)+'.'+copy(s,3,2)+'.'+copy(s,5,4);
                  DAD_ZVILN.Value:=StrToDate(s);
                end;
              end;

              // OZN_PILG
              s:=StringReplace(OptionsPILGA.Value,'&',inttostr(i),[rfReplaceAll]);
              if s<>'' then DAOZN_PILG.Value:=Round(StrTofloat(GetDDEItem(s)))
                else DAOZN_PILG.Value:=0;

              // OZNAKA
              DAOZNAKA.Value:=0;
              DA.Post;
            end;
          end;
          Options.Next;
        end;
      end;
    end;
    ListTables.Next;
  end;
  DdeClientConv.CloseLink;
  frmGauge.Free;
  // Renumbers
  with dmFunction do
  begin
    DA.First;
    j:=1;
    while not DA.Eof do
    begin
      DA.Edit;
      DANP.Value:=j;
      inc(j);
      DA.Post;
      DA.Next;
    end;
    DA.Close;
    DA.Exclusive:=true;
    DA.Open;
    DA.Pack;
    DA.Close;
    DA.Exclusive:=false;
    DA.Open;
  end;
end;



procedure TdmFunction.ImportFrom1c77;
var
  WUser:integer;
  j,i:integer;
  s_dox,s_tax,s_dox_sp,s_tax_sp,fn,temp:Extended;
  prefix,s,sd,WokerName:string;
  frmGauge:TfrmGauge;

begin
  // спробуємо зєднатись з 1С
  if (not DdeClientConv.SetLink('1CV7','DDE')) or (not DdeClientConv.OpenLink) then
  begin
    ShowMessage(NoStart1C60);
    Exit;
  end;
  frmGauge:=TfrmGauge(ShowForm(TfrmGauge,'Імпорт даних з 1С7.7',ftMDI));

  Filter1C:='77';
  // Очистимо базу
  if not dmFunction.DA.IsEmpty then
  begin
    if MessageDlg('Всі дані на даний період буде знищено. Продовжити ?',
                  mtWarning,mbOKCancel,0) = mrCancel then Exit;
    frmGauge.Caption:='Очистка бази за текучий період';
    frmGauge.Min:=1;
    frmGauge.Max:=dmFunction.DA.RecordCount;
    frmGauge.Position:=1;
    dmFunction.DA.First;
    while not dmFunction.DA.Eof do
    begin
      dmFunction.DA.Delete;
      frmGauge.Position:=frmGauge.Position + 1;
    end;
  end;

  // Імпортуємо дані
  j:=1;

  // Перебираємо всі списки
  ListTables.First;
  while not ListTables.Eof do
  begin
    // Перебираемо всі елементи в списку
    frmGauge.Max:=StrToint(GetDDEItem(ListTablesLASTNUM.Value));
    frmGauge.Min:=StrToint(GetDDEItem(ListTablesFIRSTNUM.Value));
    frmGauge.Caption:='Імпорт даних з 1С6.0 по довіднику ' +
                               ListTablesTABLENAME.Value;
    for i:=frmGauge.Min to frmGauge.Max do
    begin
      frmGauge.Position:=i;
      // Определяеем существование идентификационного номера
      s:=StringReplace(ListTablesIDNUM.Value,'&',inttostr(i),[rfReplaceAll]);
      sd:=GetDDEItem(s);
      if sd<>'' then
      begin
        // Выравнивание номера добавкой нулей
        while length(sd)<10  do sd:='0' + sd;
        // Имя сотрудника
        s:=StringReplace(ListTablesWOKERNAME.Value,'&',inttostr(i),[rfReplaceAll]);
        WokerName:=GetDDEItem(s);

        // Перебираемо всі види нарахувань
        Options.First;
        while not Options.Eof do
        begin
          s_dox:=0;s_tax:=0;s_dox_sp:=0;s_tax_sp:=0;fn:=0;
          // Input s_dox from 1s
          s:=StringReplace(OptionsNARAX.Value,'&',inttostr(i),[rfReplaceAll]);
          if s<>'' then s_dox:=StrToFloat(StringReplace(GetDDEItem(s),'.',',',[rfReplaceAll]));
          // Input s_dox from 1s
          s:=StringReplace(OptionsVIPLAT.Value,'&',inttostr(i),[rfReplaceAll]);
          if s<>'' then s_dox_sp:=StrToFloat(StringReplace(GetDDEItem(s),'.',',',[rfReplaceAll]));
          // Input s_dox from 1s
          s:=StringReplace(OptionsVIPPODAT.Value,'&',inttostr(i),[rfReplaceAll]);
          if s<>'' then s_tax_sp:=StrToFloat(StringReplace(GetDDEItem(s),'.',',',[rfReplaceAll]));
          // Input s_tax from 1s
          s:=StringReplace(OptionsPODAT.Value,'&',inttostr(i),[rfReplaceAll]);
          if s<>'' then s_tax:=StrToFloat(StringReplace(GetDDEItem(s),'.',',',[rfReplaceAll]));

          // Input flag creditor 1s
          s:=StringReplace(OptionsNEOPL.Value,'&',inttostr(i),[rfReplaceAll]);
          if s<>'' then  fn:=StrToFloat(GetDDEItem(s));

          if (s_dox<>0) or (s_tax<>0) or (s_dox_sp<>0) or (s_tax_sp<>0) or (fn=1) then
          begin
            // Заполняем список сотрудников
            if not dmFunction.Wokers.Locate('EDRPOU',sd,[]) then
            begin
              dmFunction.Wokers.Append;
              dmFunction.WokersEDRPOU.Value:=sd;
              dmFunction.WokersNAME.Value:=WokerName;
              dmFunction.Wokers.Post;
            end
            else
            begin
              if dmFunction.WokersNAME.Value<>WokerName then
                if MessageDlg('Попередження !!! Для номера '
                       + dmFunction.WokersEDRPOU.Value + 'який зареєстрований за '
                       + dmFunction.WokersNAME.Value + ' буде переєресторовано на '
                       + WokerName + '.',mtWarning,[mbYes,mbNo],0) = mrYes then
              begin
                dmFunction.Wokers.Edit;
                dmFunction.WokersNAME.Value:=WokerName;
                dmFunction.Wokers.Post;
              end;
            end;
            with dmFunction do
            begin
              if not DA.Locate('TIN;OZN_DOX', VarArrayOf([sd,OptionsCOD.Value]),[]) then
                DA.Append
              else
                DA.Edit;
              // NP
              DANP.Value:=j;
              inc(j);
              DAPERIOD.Value:=CurrentPeriod;
              DARIK.Value:=CurrentYear;
              DAKOD.Value:= Firms.EDRPOU;
              DATYP.Value:=WUser;
              DATIN.Value:=sd;
              DAS_DOX.Value:=DAS_DOX.Value+s_dox_sp;
              DAS_TAXN.Value:=DAS_TAXN.Value+s_tax;
              DAS_NAR.Value:=DAS_NAR.Value+s_dox;
              DAS_TAXP.Value:=DAS_TAXP.Value+s_tax_sp;
              DAOZN_DOX.Value:=OptionsCOD.Value;
              // D_PRIYN
              s:=StringReplace(ListTablesINWOKER.Value,'&',inttostr(i),[rfReplaceAll]);
              s:=GetDDEItem(s);
              if s<>'.  .' then
                if (YearOf(StrToDate(s))=CurrentYear) and
                   (KvartalOff(StrToDate(s))=CurrentPeriod) then
                begin
                  DAD_PRIYN.Value:=StrToDate(s);
                end;

              // D_ZVILN
              s:=StringReplace(ListTablesOUTWOKER.Value,'&',inttostr(i),[rfReplaceAll]);
              s:=GetDDEItem(s);
              if s<>'.  .' then
                if (YearOf(StrToDate(s))=CurrentYear) and
                   (KvartalOff(StrToDate(s))=CurrentPeriod) then
                 begin
                   DAD_ZVILN.Value:=StrToDate(s);
                 end;

               // OZN_PILG
              s:=StringReplace(OptionsPILGA.Value,'&',inttostr(i),[rfReplaceAll]);
              if s<>'' then DAOZN_PILG.Value:=Round(StrTofloat(GetDDEItem(s)))
                else DAOZN_PILG.Value:=0;

              // OZNAKA
              DAOZNAKA.Value:=0;
              DA.Post;
            end;
          end;
          Options.Next;
        end;
      end;
    end;
    ListTables.Next;
  end;
  DdeClientConv.CloseLink;
  frmGauge.Free;
  // Renumbers
  with dmFunction do
  begin
    DA.First;
    j:=1;
    while not DA.Eof do
    begin
      DA.Edit;
      DANP.Value:=j;
      inc(j);
      DA.Post;
      DA.Next;
    end;
    DA.Close;
    DA.Exclusive:=true;
    DA.Open;
    DA.Pack;
    DA.Close;
    DA.Exclusive:=false;
    DA.Open;
  end;
end;

procedure TdmFunction.ListTablesAfterScroll(DataSet: TDataSet);
begin
  Options.Filtered:=false;
  Options.Filter:='ID='+IntToStr(ListTablesID.Value);
  Options.Filtered:=True;
end;

procedure TdmFunction.SetFilter1C(const Value: string);
begin
  FFilter := Value;
  ListTables.Filtered:=false;
  ListTables.Filter:='VID='+Value;
  ListTables.Filtered:=true;
  ListTablesAfterScroll(ListTables);
end;

procedure TdmFunction.ListTablesNewRecord(DataSet: TDataSet);
begin
  ListTablesVID.AsVariant:=Filter1C;
  ListTablesID.Value:=ListTables.RecordCount + 1;
end;

function TdmFunction.KvartalOff(D: TDateTime): integer;
begin
  Result:=MonthOf(D) div 3;
  if (MonthOf(D) mod 3) <> 0 then
    inc(Result);
end;

procedure TdmFunction.InsertFromFile;
begin
  
end;

procedure TdmFunction.Import8DRfrom1C60Execute(Sender: TObject);
begin
  // импорт даних з 1с
{  if MainDlg.MDIChildCount<> 0 then
  begin
    MessageDlg(NoAllChildClose,mtError,[mbOk],0);
    exit;
  end;}
  dmFunction.ImportFrom1c60();
end;

procedure TdmFunction.ImportConfig1C60Execute(Sender: TObject);
begin
  dmFunction.LoadAsConfig;
end;

procedure TdmFunction.FirmsParamExecute(Sender: TObject);
var
  frm:TCustomForm;
begin
  frm:=ShowForm(TfrmOptionsFirms,'Параметри фірми',ftModal);
  frm.Free;
end;

procedure TdmFunction.Configuration1C60Execute(Sender: TObject);
begin
  dmFunction.Filter1C:='66';
  ShowForm(TfrmConfig1c60,'Параметри загрузки 1С6.0',ftMDI);
end;

procedure TdmFunction.Configuration1c77Execute(Sender: TObject);
begin
  dmFunction.Filter1C:='77';
  ShowForm(TfrmConfig1c60,'Параметри загрузки 1С6.0',ftMDI);
end;

procedure TdmFunction.Import8DRfrom1c77Execute(Sender: TObject);
begin
  // импорт даних з 1с7.7
  {if MainDlg.MDIChildCount<> 0 then
  begin
    MessageDlg(NoAllChildClose,mtError,[mbOk],0);
    exit;
  end;}
  dmFunction.ImportFrom1c77();
end;

procedure TdmFunction.RegistrationExecute(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Firms.Registration(OpenDialog1.FileName);
end;

procedure TdmFunction.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
  if ParName = 'EDRPOU' then ParValue:=Firms.EDRPOU;
  if ParName = 'FIRMNAME' then ParValue:= Firms.FirmName;
  if ParName = 'EDRPOUPOD' then ParValue:=Firms.EDRPOUPOD;
  if ParName = 'WUSER' then ParValue:=Firms.TFO;
  if ParName = 'PODNAME' then ParValue:=Firms.PODNAME;
  if ParName = 'PERIOD' then ParValue:=dmFunction.CurrentPeriod;
  if ParName = 'RIK' then ParValue:=dmFunction.CurrentYear;
  if ParName = 'BOSSCOD' then ParValue:=Firms.BOSSCOD;
  if ParName = 'BOSSTELL' then ParValue:=Firms.BOSSTELL;
  if ParName = 'BOSSNAME' then ParValue:=Firms.BOSSNAME;
  if ParName = 'SHIEFTELL' then ParValue:=Firms.SHIEFTELL;
  if ParName = 'SHIEFNAME' then ParValue:=Firms.SHIEFNAME;
  if ParName = 'SHIEFCOD' then ParValue:=Firms.SHIEFCOD;
end;

procedure TdmFunction.ExportConfig1C60Execute(Sender: TObject);
begin
  dmFunction.SaveAsConfig;
end;

procedure TdmFunction.Export8DRExecute(Sender: TObject);
begin
  dmFunction.ExportReport8DR;
end;

procedure TdmFunction.Report8DRExecute(Sender: TObject);
begin
  dmFunction.frReport1.LoadFromResourceName(Hinstance,'Report8DR');
  dmFunction.frReport1.ShowReport;
end;

procedure TdmFunction.aEditWokersExecute(Sender: TObject);
begin
  ShowForm(TfrmWokersParams,'Редагування Списка працівників',ftMDI);
end;

procedure TdmFunction.aEdit8DRExecute(Sender: TObject);
begin
  ShowForm(Tfrm8DREdit,'Редагування форми 8ДФ',ftMDI);
end;

procedure TdmFunction.frReport1UserFunction(const Name: String; p1, p2,
  p3: Variant; var Val: Variant);
var
  s:string;
  pos:integer;
begin
  if Name='GETDIGIT' then
  begin
    s := frParser.Calc(p1);
    pos:= frParser.Calc(p2);
    if Length(s) >= pos then
      Val:=copy(s,(length(s)+1)-pos,1);
  end;
end;

end.
