//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "operation_type.h"
#include "dm_main.h"
#include "dm_base.h"
#include <ntics_forms.h>
#include "operations.h"

#include "personal.h"
#include "order.h"
#include "main.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "default_dm_main"
#pragma link "FR_BarC"
#pragma link "FR_Chart"
#pragma link "FR_ChBox"
#pragma link "FR_Class"
#pragma link "FR_Cross"
#pragma link "FR_DBSet"
#pragma link "FR_Desgn"
#pragma link "FR_DSet"
#pragma link "FR_E_CSV"
#pragma link "FR_E_HTM"
#pragma link "FR_E_RTF"
#pragma link "FR_E_TXT"
#pragma link "FR_FIBDB"
#pragma link "FR_OLE"
#pragma link "FR_Rich"
#pragma link "FR_RRect"
#pragma link "FR_Shape"
#pragma link "FIBDataSet"
#pragma link "frOLEExl"
#pragma link "pFIBDataSet"
#pragma link "JvMemoryDataset"
#pragma resource "*.dfm"
TdmMain *dmMain;
//---------------------------------------------------------------------------
__fastcall TdmMain::TdmMain(TComponent* Owner)
        : TdmMain_def(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TdmMain::aRefreshAllExecute(TObject *Sender)
{
  dmBase->FRefresh(dmBase->Firms);
  dmBase->FRefresh(dmBase->OPERATION_TYPE);
  dmBase->FRefresh(dmBase->Operation);
  dmBase->FRefresh(dmBase->Personal);
  dmBase->Orders->Open();
  dmBase->FRefresh(dmBase->Orders);
 
}
//---------------------------------------------------------------------------

void __fastcall TdmMain::aOperationExecute(TObject *Sender)
{
  using namespace :: ntics_forms;
  ShowForm(__classid(TfrmOperations),"Операції",ftMDI);

}
//---------------------------------------------------------------------------

void __fastcall TdmMain::aClassificatorExecute(TObject *Sender)
{
  using namespace :: ntics_forms;
  ShowForm(__classid(TfrmOperationType),"Классифікатор",ftMDI);
}
//---------------------------------------------------------------------------

void __fastcall TdmMain::aWokersExecute(TObject *Sender)
{
   using namespace :: ntics_forms;
   ShowForm(__classid(TfrmPersonal),"Сотрудники",ftMDI);

}
//---------------------------------------------------------------------------

void __fastcall TdmMain::aOrdersExecute(TObject *Sender)
{
  using namespace :: ntics_forms;
  ShowForm(__classid(TfrmOrder),"Наряди",ftMDI);

}
//---------------------------------------------------------------------------


void __fastcall TdmMain::aReport1Execute(TObject *Sender)
{
  dmBase->CreateReportHeader(StrToInt(frmMain->M_YEAR->Text),frmMain->M_MONTH->ItemIndex + 1);
  frReport->LoadFromFile("Report1.frf");
  frReport->ModalPreview = False;
  frReport->MDIPreview = True;
  frReport->ShowReport();
}
//---------------------------------------------------------------------------



void __fastcall TdmMain::frReportBeginDoc()
{
  frVariables->Variable["M_YEAR"] = frmMain->M_YEAR->Text;
  frVariables->Variable["M_MONTH"] = frmMain->M_MONTH->ItemIndex + 1;
  frVariables->Variable["M_MONTHText"] = frmMain->M_MONTH->Text;
}
//---------------------------------------------------------------------------

void __fastcall TdmMain::aReport2Execute(TObject *Sender)
{
  frReport->LoadFromFile("Report2.frf");
  frReport->ModalPreview = False;
  frReport->MDIPreview = True;
  frReport->ShowReport();
}
//---------------------------------------------------------------------------



void __fastcall TdmMain::aReport3Execute(TObject *Sender)
{
  frReport->LoadFromFile("Report3.frf");
  frReport->ModalPreview=False;
  frReport->MDIPreview=False;
  frReport->ShowReport();
}
//---------------------------------------------------------------------------

void __fastcall TdmMain::aDesignerExecute(TObject *Sender)
{
  frReport->DesignReport();
}
//---------------------------------------------------------------------------

void __fastcall TdmMain::aReport4Execute(TObject *Sender)
{
  frmMain->StatusBar1->Panels->Items[1]->Text="Підготовка даних для формування звіту по фірмам ...";
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
//---------------------------------------------------------------------------




void __fastcall TdmMain::CROSS_FIRMSCalcFields(TDataSet *DataSet)
{
   TLocateOptions Opts;
   Opts.Clear();
   Variant FindFields[2];
   FindFields[0]=CROSS_FIRMSID->Value;
   FindFields[1]=CROSS_OPERATIONID->Value;
   if (temp_CROSS_FIRMS_CELL->Locate("ID;OPERATION_ID",VarArrayOf(FindFields,1),Opts))
   {
     CROSS_FIRMSSUMA->Value=temp_CROSS_FIRMS_CELLSUMA->Value;
     CROSS_FIRMSCOUNTS->Value=temp_CROSS_FIRMS_CELLCOUNTS->Value;
   }
   else
   {
     CROSS_FIRMSSUMA->Value=0;
     CROSS_FIRMSCOUNTS->Value=0;
   }

}
//---------------------------------------------------------------------------

