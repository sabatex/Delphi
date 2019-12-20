unit dmfFunction;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBGridEh, StdCtrls, Variants, FIBDatabase,
  pFIBDatabase, FIBDataSet, pFIBDataSet, pFIBErrorHandler,
  FIB, ImgList, FIBQuery, pFIBQuery, pFIBStoredProc,
  JvMemoryDataset;

type
  EMAWIError = class(Exception);
  TFormClass = class of TForm;

  TdmFunction2 = class(TDataModule)
    dsFirms: TDataSource;
    dsOperation: TDataSource;
    dsPersonal: TDataSource;
    Matias: TpFIBDatabase;
    Firms: TpFIBDataSet;
    FirmsID: TFIBIntegerField;
    FirmsFIRMNAME: TFIBStringField;
    Personal: TpFIBDataSet;
    PersonalID: TFIBIntegerField;
    PersonalPERSONAL_NR: TFIBIntegerField;
    PersonalPERSONAL_NAME: TFIBStringField;
    PersonalDATE_IN: TDateField;
    PersonalDATE_OUT: TDateField;
    PersonalFIRMS_ID: TFIBIntegerField;
    Operation: TpFIBDataSet;
    OperationID: TFIBIntegerField;
    OperationOPERATION_NAME: TFIBStringField;
    OperationCASHE: TFIBFloatField;
    OperationTIMENORM: TFIBFloatField;
    Orders: TpFIBDataSet;
    OrdersID: TFIBIntegerField;
    OrdersPERSONAL_ID: TFIBIntegerField;
    OrdersOPERATION_ID: TFIBIntegerField;
    OrdersORDER_YEAR: TFIBIntegerField;
    OrdersORDER_MONTH: TFIBIntegerField;
    OrdersCOUNTS: TFIBFloatField;
    OrdersTOTAL: TFIBFloatField;
    OrdersOPER_TYPE: TFIBIntegerField;
    OPERATION_TYPE: TpFIBDataSet;
    dsOPERATION_TYPE: TDataSource;
    OrdersOPERATION_TYPE: TStringField;
    FibErrorHandler: TpFibErrorHandler;
    tsOPERATION_TYPE: TpFIBTransaction;
    tsFirms: TpFIBTransaction;
    tsPersonal: TpFIBTransaction;
    tsOperation: TpFIBTransaction;
    dsOrders: TDataSource;
    tsOrders: TpFIBTransaction;
    Transaction: TpFIBTransaction;
    OrdersOPERATION_MULT: TFloatField;
    ImageList: TImageList;
    OPERATION_TYPEID: TFIBIntegerField;
    OPERATION_TYPEOP_TYPE: TFIBStringField;
    OPERATION_TYPETAX: TFIBFloatField;
    OPERATION_TYPEPARENT: TFIBIntegerField;
    OPERATION_TYPEIS_FOLDER: TFIBIntegerField;
    OPERATION_TYPEPOSITION_ON_REPORT: TFIBIntegerField;
    taClasificator: TpFIBTransaction;
    dbFolder: TpFIBDataSet;
    dbFolderID: TFIBIntegerField;
    dbFolderOP_TYPE: TFIBStringField;
    dbFolderTAX: TFIBFloatField;
    dbFolderPARENT: TFIBIntegerField;
    dbFolderPOSITION_ON_REPORT: TFIBIntegerField;
    dbClasificator: TpFIBDataSet;
    dbClasificatorID: TFIBIntegerField;
    dbClasificatorOP_TYPE: TFIBStringField;
    dbClasificatorTAX: TFIBFloatField;
    dbClasificatorPARENT: TFIBIntegerField;
    dbClasificatorIS_FOLDER: TFIBIntegerField;
    dbClasificatorPOSITION_ON_REPORT: TFIBIntegerField;
    CALC_OP_TYPE: TpFIBStoredProc;
    DataSource1: TDataSource;
    OrdersOPERATION_NAME: TFIBStringField;
    OrdersCASHE: TFIBFloatField;
    T_REPORT1: TJvMemoryData;
    T_REPORT1ID: TIntegerField;
    T_REPORT1PARENT: TIntegerField;
    T_REPORT1IS_FOLDER: TIntegerField;
    T_REPORT1SUMMA: TCurrencyField;
    T_REPORT1OP_TYPE: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure OrdersAfterInsert(DataSet: TDataSet);
    procedure PersonalAfterInsert(DataSet: TDataSet);
    procedure OrdersCOUNTSValidate(Sender: TField);
    procedure FRefresh(DataSet: TDataSet);
    procedure OrdersAfterPost(DataSet: TDataSet);
  private
    FieldHistory:integer;
    FYEAR:integer;
    FMOUNTH:integer;
    FPERSON:boolean;
    FFIRM:string;
  public

   procedure CreateReportHeader(M_YEAR,M_MONTH:integer);
   //procedure ReOpen(Table:TIBCustomDataSet);
   procedure OpenDataSet(DataSet:TDataSet);
   procedure PostDataSet(DataSet:TDataSet);
   function FindSortedField(Grid:TDBGridEh):string;
   //function ShowForm(AOwner:TComponent;ClassForm:TFormClass;FormName:string):TForm;
   //procedure GetFirmsList(cbFirms:TComboBox);
   //procedure SetCurrentFirm(cFirm:string);
   procedure SetFilterOrders(M_YEAR,M_MONTH:integer;M_Filter:boolean;CFirm:string);
   procedure SetPersonalFilter(M_YEAR, M_MONTH: integer;M_Filter:boolean);
  end;

var
  dmFunction2: TdmFunction2;

implementation

uses fLogin, fConfigStorage;

{$R *.DFM}

{ TdmFunction }

procedure TdmFunction2.DataModuleCreate(Sender: TObject);
begin
  // Подключение к базе
  //TfrmSplash.ShowSplash('Connected to InterBase ...');
  Matias.Close;
  with IBLogin do
  begin
    if ServerName<>'' then
      Matias.DatabaseName:=ServerName + ':' + DataBasePath
    else
      Matias.DatabaseName:=DataBasePath;
    Matias.ConnectParams.UserName:=UserName;
    Matias.ConnectParams.Password:=Password;
    Matias.ConnectParams.CharSet:='WIN1251';
    Matias.ConnectParams.RoleName:=UserName;
  end;
  try
    Matias.Open;
  except
    raise EMAWIError.Create('Невозможно соединится с базой. Проверьте пароль.');
  end;
  Operation.Open;
  Firms.Open;
end;

function TdmFunction2.FindSortedField(Grid: TDBGridEh): string;
var
 i:integer;
begin
 for i:=0 to Grid.FieldCount - 1 do
  if (Grid.Columns[i].Title.SortMarker in [smUpEh,smDownEh]) then
  begin
   Result:=Grid.Fields[i].FieldName;
   Exit;
  end;
 Result:='';
end;

procedure TdmFunction2.OpenDataSet(DataSet: TDataSet);
begin
 if not DataSet.Active then DataSet.Open;
end;

procedure TdmFunction2.PostDataSet(DataSet: TDataSet);
begin
 if DataSet.State in [dsInsert,dsEdit] then DataSet.Post;
end;

{
function TdmFunction.ShowForm(AOwner:TComponent;ClassForm: TFormClass;
                               FormName: string):TForm;
var
 i:integer;
begin
 for i:=0 to Screen.FormCount - 1 do
  if Screen.Forms[i].Caption = FormName then
  begin
   Screen.Forms[i].BringToFront;
   Result:=nil;
   Exit;
  end;
 Result:=ClassForm.Create(AOwner);
 Result.Caption:=FormName;
end;
}

procedure TdmFunction2.SetFilterOrders(M_YEAR, M_MONTH: integer;
                                      M_Filter:boolean;CFirm:string);
begin
  FYEAR:=M_YEAR;
  FMOUNTH:=M_MONTH;
  FPERSON:=M_Filter;
  FFIRM:=CFirm;

  if not Firms.Locate('FirmName',cFirm,[]) then
   ConfigStorage.SaveValue('CurrentFirm',FirmsFIRMNAME.Value);
  SetPersonalFilter(M_YEAR, M_MONTH,M_Filter);
  SetPersonalFilter(M_YEAR, M_MONTH,M_Filter);
  with Orders do
  begin
    Close;
    ParamByName('CURRENT_YEAR').Value:=M_YEAR;
    ParamByName('CURRENT_MOUNTH').Value:=M_MONTH;
    Open;
  end;
end;

procedure TdmFunction2.SetPersonalFilter(M_YEAR, M_MONTH: integer;M_Filter:boolean);
begin
  if M_Filter then
  begin
    with Personal do
    begin
      Close;
      SQLS.SelectSQL.Clear;
      SQLS.SelectSQL.Add('select * from PERSONAL');
      SQLS.SelectSQL.Add('where FIRMS_ID=' + IntToStr(FirmsID.Value));
      SQLS.SelectSQL.Add('ORDER BY PERSONAL_NAME');
      Open;
    end;
  end
  else
  begin
    with Personal do
    begin
      Close;
      SQLS.SelectSQL.Clear;
      SQLS.SelectSQL.Add('select * from PERSONAL');
      SQLS.SelectSQL.Add('where (FIRMS_ID='+ IntToStr(FirmsID.Value)+') AND ((DATE_OUT IS NULL) OR ');
      SQLS.SelectSQL.Add('(EXTRACT (YEAR FROM DATE_OUT) >'+IntToStr(M_YEAR)+') OR ');
      SQLS.SelectSQL.Add('((EXTRACT(YEAR FROM DATE_OUT)='+IntToStr(M_YEAR)+') AND');
      SQLS.SelectSQL.Add('(EXTRACT (MONTH FROM DATE_OUT)>='+IntToStr(M_MONTH)+')))');
      SQLS.SelectSQL.Add('ORDER BY PERSONAL_NAME');
      Open;
    end;
  end;
end;



procedure TdmFunction2.OrdersAfterInsert(DataSet: TDataSet);
begin
  OrdersOPER_TYPE.Value:=FieldHistory;
  OrdersPERSONAL_ID.Value:=PersonalID.Value;
  OrdersORDER_YEAR.Value:=FYEAR;
  OrdersORDER_MONTH.Value:=FMOUNTH;
end;

procedure TdmFunction2.PersonalAfterInsert(DataSet: TDataSet);
begin
  PersonalFIRMS_ID.Value:=FirmsID.Value;
end;

procedure TdmFunction2.OrdersCOUNTSValidate(Sender: TField);
begin
  OrdersTOTAL.Value:=OrdersCOUNTS.Value * OrdersCASHE.Value
                     * OrdersOPERATION_MULT.Value;
end;

procedure TdmFunction2.FRefresh(DataSet: TDataSet);
var
 Master:Variant;
begin
  if DataSet.State in [dsBrowse] then
    if DataSet is TpFIBDataSet then
      begin
        with (DataSet as TpFIBDataSet) do
        begin
          Master:=Fields[0].Value;
          Transaction.Commit;
          //Close;
          Open;
          Locate(Fields[0].FieldName,Master,[]);
        end;
      end;
end;



procedure TdmFunction2.CreateReportHeader(M_YEAR,M_MONTH:integer);
var
  SM,SM_T:Double;
begin
  T_REPORT1.First;
  while not T_REPORT1.Eof do T_REPORT1.Delete;
  dbFolder.Open;
  dbClasificator.Open;
  while not dbFolder.Eof do
  begin
    dbClasificator.Filtered:=false;
    dbClasificator.Filter:='PARENT = ' + dbFolderID.AsString;
    dbClasificator.Filtered:=true;
    dbClasificator.First;
    SM:=0;
    while not dbClasificator.Eof do
    begin
      CALC_OP_TYPE.Close;
      CALC_OP_TYPE.Params[0].Value:=FirmsID.Value;
      CALC_OP_TYPE.Params[1].Value:=M_MONTH;
      CALC_OP_TYPE.Params[2].Value:=M_YEAR;
      CALC_OP_TYPE.Params[3].Value:=dbClasificatorID.Value;
      CALC_OP_TYPE.ExecProc;
      if not VarIsNull(CALC_OP_TYPE.FieldByName('SUMMA').Value) then
        SM_T:=CALC_OP_TYPE.FieldByName('SUMMA').Value
      else
        SM_T:=0;
      if SM_T<>0 then
      begin
        T_REPORT1.Insert;
        T_REPORT1PARENT.Value:=dbClasificatorID.Value;
        T_REPORT1IS_FOLDER.Value:=0;
        T_REPORT1OP_TYPE.Value:=dbClasificatorOP_TYPE.Value;
        T_REPORT1SUMMA.Value:=SM_T;
        T_REPORT1.Post;
      end;
      SM:=SM + SM_T;
      dbClasificator.Next;
    end;
    if SM <> 0 then
    begin
      T_REPORT1.Insert;
      T_REPORT1PARENT.Value:=dbFolderID.Value;
      T_REPORT1IS_FOLDER.Value:=1;
      T_REPORT1OP_TYPE.Value:=dbFolderOP_TYPE.Value;
      T_REPORT1SUMMA.Value:=SM;
      T_REPORT1.Post;
    end;
    dbFolder.Next;
  end;
  dbFolder.Close;
  dbClasificator.Close;
end;

procedure TdmFunction2.OrdersAfterPost(DataSet: TDataSet);
begin
  FieldHistory:=OrdersOPER_TYPE.Value;
end;

end.
