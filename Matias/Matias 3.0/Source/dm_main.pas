unit dm_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, default_dm_main, DBActns, StdActns, ActnList, ImgList, DB,
  FIBDataSet, pFIBDataSet, frOLEExl, FR_Class, FR_DSet, FR_DBSet, FR_RRect,
  FR_Chart, FR_BarC, FR_Shape, FR_ChBox, FR_Rich, FR_OLE, FR_Cross,
  FR_E_CSV, FR_E_RTF, FR_E_TXT, FR_E_HTM, FR_Desgn, Menus;

type
  TdmMain = class(TdmMain_def)
    aRefreshAll: TAction;
    aOperation: TAction;
    aClassificator: TAction;
    aWokers: TAction;
    aOrders: TAction;
    aReport1: TAction;
    aReport2: TAction;
    aReport3: TAction;
    aDesigner: TAction;
    aReport4: TAction;
    frDesigner: TfrDesigner;
    frReport: TfrReport;
    frHTMExport: TfrHTMExport;
    frRTFExport: TfrRTFExport;
    frCSVExport: TfrCSVExport;
    frTextExport: TfrTextExport;
    frCrossObject: TfrCrossObject;
    frOLEObject: TfrOLEObject;
    frRichObject: TfrRichObject;
    frCheckBoxObject: TfrCheckBoxObject;
    frShapeObject: TfrShapeObject;
    frBarCodeObject: TfrBarCodeObject;
    frChartObject: TfrChartObject;
    frRoundRectObject: TfrRoundRectObject;
    frPersonal: TfrDBDataSet;
    frT_REPORT1: TfrDBDataSet;
    frCompositeReport: TfrCompositeReport;
    frOLEExcelExport1: TfrOLEExcelExport;
    temp_CROSS_FIRMS_CELL: TpFIBDataSet;
    temp_CROSS_FIRMS_CELLID: TFIBIntegerField;
    temp_CROSS_FIRMS_CELLOPERATION_ID: TFIBIntegerField;
    temp_CROSS_FIRMS_CELLCOMPANY_NAME: TFIBStringField;
    temp_CROSS_FIRMS_CELLCOUNTS: TFIBBCDField;
    temp_CROSS_FIRMS_CELLSUMA: TFIBBCDField;
    CROSS_OPERATION: TpFIBDataSet;
    CROSS_OPERATIONID: TFIBIntegerField;
    CROSS_OPERATIONOPERATION_NAME: TFIBStringField;
    CROSS_OPERATIONCASHE: TFIBFloatField;
    frCROSS_OPERATION: TfrDBDataSet;
    CROSS_FIRMS: TpFIBDataSet;
    CROSS_FIRMSID: TFIBIntegerField;
    CROSS_FIRMSCOMPANY_NAME: TFIBStringField;
    CROSS_FIRMSCOUNTS: TCurrencyField;
    CROSS_FIRMSSUMA: TFloatField;
    frCROSS_FIRMS: TfrDBDataSet;
    procedure aRefreshAllExecute(Sender: TObject);
    procedure aOperationExecute(Sender: TObject);
    procedure aClassificatorExecute(Sender: TObject);
    procedure aWokersExecute(Sender: TObject);
    procedure aOrdersExecute(Sender: TObject);
    procedure aReport1Execute(Sender: TObject);
    procedure frReportBeginDoc;
    procedure aReport2Execute(Sender: TObject);
    procedure aReport3Execute(Sender: TObject);
    procedure aDesignerExecute(Sender: TObject);
    procedure aReport4Execute(Sender: TObject);
    procedure CROSS_FIRMSCalcFields(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmMain: TdmMain;

implementation

uses dm_base, personal;

{$R *.dfm}

procedure TdmMain.aRefreshAllExecute(Sender: TObject);
begin
  inherited;
  dmBase.FRefresh(dmBase.Firms);
  dmBase.FRefresh(dmBase.OPERATION_TYPE);
  dmBase.FRefresh(dmBase.Operation);
  dmBase.FRefresh(dmBase.Personal);
  dmBase.Orders.Open();
  dmBase.FRefresh(dmBase.Orders);
end;

procedure TdmMain.aOperationExecute(Sender: TObject);
begin
  inherited;
//  using namespace :: ntics_forms;
//  ShowForm(__classid(TfrmOperations),"Операції",ftMDI);
end;

procedure TdmMain.aClassificatorExecute(Sender: TObject);
begin
  inherited;
//  using namespace :: ntics_forms;
//  ShowForm(__classid(TfrmOperationType),"Классифікатор",ftMDI);
end;

procedure TdmMain.aWokersExecute(Sender: TObject);
begin
  inherited;
  frmPersonal:= TfrmPersonal.Create(Application);
  frmPersonal.Caption:='Працівники - ' + dmBase.FirmsCOMPANY_NAME.Value;
  //frmPersonal.FirmID:=dmBase.FirmsID.Value;
  //frmPersonal.Show();
end;

procedure TdmMain.aOrdersExecute(Sender: TObject);
begin
  inherited;
  //using namespace :: ntics_forms;
  //ShowForm(__classid(TfrmOrder),"Наряди",ftMDI);
end;

procedure TdmMain.aReport1Execute(Sender: TObject);
begin
  inherited;
{  dmBase->CreateReportHeader(StrToInt(frmMain->M_YEAR->Text),frmMain->M_MONTH->ItemIndex + 1);
  frReport->LoadFromFile("Report1.frf");
  frReport->ModalPreview = False;
  frReport->MDIPreview = True;
  frReport->ShowReport();
}
end;

procedure TdmMain.frReportBeginDoc;
begin
  inherited;
{  frVariables->Variable["M_YEAR"] = frmMain->M_YEAR->Text;
  frVariables->Variable["M_MONTH"] = frmMain->M_MONTH->ItemIndex + 1;
  frVariables->Variable["M_MONTHText"] = frmMain->M_MONTH->Text;
}
end;

procedure TdmMain.aReport2Execute(Sender: TObject);
begin
  inherited;
{  frReport->LoadFromFile("Report2.frf");
  frReport->ModalPreview = False;
  frReport->MDIPreview = True;
  frReport->ShowReport();
}
end;

procedure TdmMain.aReport3Execute(Sender: TObject);
begin
  inherited;
{  frReport->LoadFromFile("Report3.frf");
  frReport->ModalPreview=False;
  frReport->MDIPreview=False;
  frReport->ShowReport();
}
end;

procedure TdmMain.aDesignerExecute(Sender: TObject);
begin
  inherited;
  frReport.DesignReport(); 
end;

procedure TdmMain.aReport4Execute(Sender: TObject);
begin
  inherited;
{  frmMain->StatusBar1->Panels->Items[1]->Text="Підготовка даних для формування звіту по фірмам ...";
  frmMain->Refresh();
  temp_CROSS_FIRMS_CELL->Close();
  CROSS_OPERATION->Close();
  CROSS_FIRMS->Close();
  //CROSS_FIRMS_CELL->Close();
  temp_CROSS_FIRMS_CELL->ParamByName("F_YEAR")->Value=FYEAR;
  temp_CROSS_FIRMS_CELL->ParamByName("F_MONTH")->Value=FMOUNTH;
  temp_CROSS_FIRMS_CELL->Open();
  CROSS_OPERATION->ParamByName("F_YEAR")->Value=FYEAR;
  CROSS_OPERATION->ParamByName("F_MONTH")->Value=FMOUNTH;
  CROSS_OPERATION->Open();
  CROSS_FIRMS->ParamByName("F_YEAR")->Value=FYEAR;
  CROSS_FIRMS->ParamByName("F_MONTH")->Value=FMOUNTH;
  CROSS_FIRMS->Open();

  frReport->LoadFromFile("Report4.frf");
  frReport->ModalPreview=False;
  frReport->MDIPreview=False;
  frReport->ShowReport();
  frmMain->StatusBar1->Panels->Items[1]->Text="";
}
end;

procedure TdmMain.CROSS_FIRMSCalcFields(DataSet: TDataSet);
begin
  inherited;
{   TLocateOptions Opts;
   Opts.Clear();
   Variant FindFields[2];
   FindFields[0]=CROSS_FIRMSID->Value;
   FindFields[1]=CROSS_OPERATIONID->Value;
   if (temp_CROSS_FIRMS_CELL->Locate("ID;OPERATION_ID",VarArrayOf(FindFields,1),Opts))
   {
     CROSS_FIRMSSUMA->Value=temp_CROSS_FIRMS_CELLSUMA->Value;
     CROSS_FIRMSCOUNTS->Value=temp_CROSS_FIRMS_CELLCOUNTS->Value;
   }
{   else
   {
     CROSS_FIRMSSUMA->Value=0;
     CROSS_FIRMSCOUNTS->Value=0;
   }

end;

procedure TdmMain.DataModuleCreate(Sender: TObject);
begin
  inherited;
  RegisterClass(TfrmPersonal);
end;

end.
