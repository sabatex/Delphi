unit dm_base;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, default_dm_base, FIBDatabase, pFIBDatabase, DB, JvMemoryDataset,
  ImgList, FIBQuery, pFIBQuery, pFIBStoredProc, FIBDataSet, pFIBDataSet,DBGridEh;

type
  TdmBase = class(TdmBase_def)
    dsFirms: TDataSource;
    dsOperation: TDataSource;
    dsPersonal: TDataSource;
    Firms: TpFIBDataSet;
    FirmsID: TFIBIntegerField;
    FirmsIDFIZ: TFIBIntegerField;
    FirmsEDRPOU: TFIBStringField;
    FirmsWUSER: TFIBStringField;
    FirmsCOMPANY_ADDRESS: TFIBStringField;
    FirmsCOMPANY_NAME: TFIBStringField;
    FirmsEMAIL: TFIBStringField;
    FirmsFIRMNAME: TStringField;
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
    OrdersOPERATION_TYPE: TStringField;
    OrdersOPERATION_MULT: TFloatField;
    OrdersOPERATION_NAME: TFIBStringField;
    OrdersCASHE: TFIBFloatField;
    OPERATION_TYPE: TpFIBDataSet;
    OPERATION_TYPEID: TFIBIntegerField;
    OPERATION_TYPEOP_TYPE: TFIBStringField;
    OPERATION_TYPETAX: TFIBFloatField;
    OPERATION_TYPEPARENT: TFIBIntegerField;
    OPERATION_TYPEIS_FOLDER: TFIBIntegerField;
    OPERATION_TYPEPOSITION_ON_REPORT: TFIBIntegerField;
    dsOPERATION_TYPE: TDataSource;
    tsOPERATION_TYPE: TpFIBTransaction;
    tsFirms: TpFIBTransaction;
    tsPersonal: TpFIBTransaction;
    tsOperation: TpFIBTransaction;
    tsOrders: TpFIBTransaction;
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
    ImageList: TImageList;
    T_REPORT1: TJvMemoryData;
    T_REPORT1ID: TIntegerField;
    T_REPORT1PARENT: TIntegerField;
    T_REPORT1IS_FOLDER: TIntegerField;
    T_REPORT1SUMMA: TCurrencyField;
    T_REPORT1OP_TYPE: TStringField;
    dsTREPORT: TDataSource;
    procedure FirmsCalcFields(DataSet: TDataSet);
    procedure PersonalAfterInsert(DataSet: TDataSet);
    procedure OrdersAfterInsert(DataSet: TDataSet);
    procedure OrdersAfterPost(DataSet: TDataSet);
    procedure OrdersCOUNTSValidate(Sender: TField);
    procedure DataModuleCreate(Sender: TObject);
  private
    FieldHistory:integer;
    FPERSON:boolean;
    FFIRM:string;
    { Private declarations }
  public
    procedure CreateReportHeader(M_YEAR,M_MONTH:integer);
    procedure OpenDataSet(DataSet:TDataSet);
    procedure PostDataSet(DataSet:TDataSet);
    function FindSortedField(Grid:TDBGridEh):string;
    procedure SetFilterOrders(M_YEAR,M_MONTH:integer;M_Filter:boolean;
                              CFirm:string);
    procedure SetPersonalFilter(M_YEAR,M_MONTH:integer;M_Filter:boolean);
    procedure FRefresh(DataSet:TDataSet);        
  end;

var
  dmBase: TdmBase;
  FYEAR,FMOUNTH:integer;
implementation
{$R *.dfm}
uses ntics_storage,ntics_login,constants;

procedure TdmBase.FirmsCalcFields(DataSet: TDataSet);
begin
  inherited;
  FirmsFIRMNAME.Value := FirmsCOMPANY_NAME.Value;
end;

procedure TdmBase.PersonalAfterInsert(DataSet: TDataSet);
begin
  inherited;
  PersonalFIRMS_ID.Value := FirmsID.Value;
end;

procedure TdmBase.OrdersAfterInsert(DataSet: TDataSet);
begin
  inherited;
  OrdersOPER_TYPE.Value := FieldHistory;
  OrdersPERSONAL_ID.Value := PersonalID.Value;
  OrdersORDER_YEAR.Value := FYEAR;
  OrdersORDER_MONTH.Value := FMOUNTH;
end;

procedure TdmBase.OrdersAfterPost(DataSet: TDataSet);
begin
  inherited;
  FieldHistory := OrdersOPER_TYPE.Value;     
end;

procedure TdmBase.OrdersCOUNTSValidate(Sender: TField);
begin
  inherited;
  OrdersTOTAL.Value := OrdersCOUNTS.Value * OrdersCASHE.Value
                       * OrdersOPERATION_MULT.Value;
end;

procedure TdmBase.DataModuleCreate(Sender: TObject);
begin
  inherited;
  Operation.Open();
  Firms.Open();
end;

procedure TdmBase.CreateReportHeader(M_YEAR, M_MONTH: integer);
var
  SM,SM_T:Double;
begin
  T_REPORT1.First();
  while not T_REPORT1.Eof do T_REPORT1.Delete();
  dbFolder.Open();
  dbClasificator.Open();
  while not dbFolder.Eof do
  begin
    dbClasificator.Filtered := False;
    dbClasificator.Filter := 'PARENT = ;' + dbFolderID.AsString;
    dbClasificator.Filtered := True;
    dbClasificator.First();
    SM:=0;
    while not dbClasificator.Eof do
    begin
      CALC_OP_TYPE.Close();
      CALC_OP_TYPE.Params[0].Value := FirmsID.Value;
      CALC_OP_TYPE.Params[1].Value := M_MONTH;
      CALC_OP_TYPE.Params[2].Value := M_YEAR;
      CALC_OP_TYPE.Params[3].Value := dbClasificatorID.Value;
      CALC_OP_TYPE.ExecProc();
      SM_T:=0;
      if not VarIsNull(CALC_OP_TYPE.FieldByName('SUMMA').Value) then
        SM_T := CALC_OP_TYPE.FieldByName('SUMMA').Value;

      if SM_T <> 0 then
      begin
        T_REPORT1.Insert();
        T_REPORT1PARENT.Value := dbClasificatorID.Value;
        T_REPORT1IS_FOLDER.Value := 0;
        T_REPORT1OP_TYPE.Value := dbClasificatorOP_TYPE.Value;
        T_REPORT1SUMMA.Value := SM_T;
        T_REPORT1.Post();
      end;
      SM := SM + SM_T;
      dbClasificator.Next();
    end;

    if SM <> 0 then
    begin
      T_REPORT1.Insert();
      T_REPORT1PARENT.Value := dbFolderID.Value;
      T_REPORT1IS_FOLDER.Value :=1;
      T_REPORT1OP_TYPE.Value := dbFolderOP_TYPE.Value;
      T_REPORT1SUMMA.Value := SM;
      T_REPORT1.Post();
    end;
    dbFolder.Next();
  end;
  dbFolder.Close();
  dbClasificator.Close();
end;

procedure TdmBase.OpenDataSet(DataSet: TDataSet);
begin
  if not DataSet.Active then  DataSet.Open();
end;

procedure TdmBase.PostDataSet(DataSet: TDataSet);
begin
  if (DataSet.State = dsInsert) or (DataSet.State = dsEdit) then DataSet.Post();
end;

function TdmBase.FindSortedField(Grid: TDBGridEh): string;
var
  i:integer;
  sm:TSortMarkerEh;
begin
 for i:=0 to Grid.FieldCount - 1 do
 begin
  sm := Grid.Columns.Items[i].Title.SortMarker;
  if (sm = smUpEh) or (sm = smDownEh) then
  begin
    result:= Grid.Fields[i].FieldName;
    Exit;
  end;
 end;
 Result:='';
end;

procedure TdmBase.SetFilterOrders(M_YEAR, M_MONTH: integer;
  M_Filter: boolean; CFirm: string);
begin
  FYEAR := M_YEAR;
  FMOUNTH := M_MONTH;
  FPERSON := M_Filter;
  FFIRM := CFirm;
  if not Firms.Locate('COMPANY_NAME',CFirm,[]) then
    raise Exception.Create(Error_NotFirmPosition);
  //SetPersonalFilter(M_YEAR, M_MONTH,M_Filter);
  SetPersonalFilter(M_YEAR, M_MONTH,M_Filter);
  Orders.Close();
  Orders.ParamByName('CURRENT_YEAR').Value:=M_YEAR;
  Orders.ParamByName('CURRENT_MOUNTH').Value:=M_MONTH;
  Orders.Open();
end;

procedure TdmBase.SetPersonalFilter(M_YEAR, M_MONTH: integer;
  M_Filter: boolean);
begin
  if M_Filter then
  begin
    Personal.Close();
    Personal.SelectSQL.Clear();
    Personal.SelectSQL.Add('select * from PERSONAL');
    Personal.SelectSQL.Add('where FIRMS_ID=' + IntToStr(FirmsID.Value));
    Personal.SelectSQL.Add('ORDER BY PERSONAL_NAME');
    Personal.Open();
  end
  else
  begin
    Personal.Close();
    Personal.SelectSQL.Clear();
    Personal.SelectSQL.Add('select * from PERSONAL');
    Personal.SelectSQL.Add('where (FIRMS_ID='+ IntToStr(FirmsID.Value)+
                                   ') AND ((DATE_OUT IS NULL) OR ');
    Personal.SelectSQL.Add('(EXTRACT (YEAR FROM DATE_OUT) >'+
                                   IntToStr(M_YEAR)+') OR ');
    Personal.SelectSQL.Add('((EXTRACT(YEAR FROM DATE_OUT)='+
                                   IntToStr(M_YEAR)+') AND');
    Personal.SelectSQL.Add('(EXTRACT (MONTH FROM DATE_OUT)>='+
                                   IntToStr(M_MONTH)+')))');
    Personal.SelectSQL.Add('ORDER BY PERSONAL_NAME');
    Personal.Open();
  end;
end;


procedure TdmBase.FRefresh(DataSet: TDataSet);
var
  ds:TpFIBDataSet;
  Master:Variant;
begin
  if DataSet.State = dsBrowse then
   if DataSet is TpFIBDataSet then
   begin
     ds := DataSet as TpFIBDataSet;
     Master := ds.Fields[0].Value;
     ds.Transaction.Commit();
     ds.Open();
     ds.Locate(ds.Fields[0].FieldName,Master,[]);
   end;
end;

end.
