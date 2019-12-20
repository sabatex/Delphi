//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "data_module.h"
#include "ntics_login.h"
#include "default_splash.h"

//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "FIBDatabase"
#pragma link "FIBDataSet"
#pragma link "FIBQuery"
#pragma link "JvMemoryDataset"
#pragma link "pFIBDatabase"
#pragma link "pFIBDataSet"
#pragma link "pFIBQuery"
#pragma link "pFIBStoredProc"
#pragma resource "*.dfm"
TdmFunction *dmFunction;
int    FieldHistory;
int    FYEAR,FMOUNTH;
Boolean FPERSON;
String  FFIRM;

//---------------------------------------------------------------------------
__fastcall TdmFunction::TdmFunction(TComponent* Owner)
        : TDataModule(Owner)
{
    IBLogin = new TIBLogin(Application);
    if (!IBLogin->LoginExecute()) throw "";
    frmSplash_def = new TfrmSplash_def(Application);
    frmSplash_def->Show();
    frmSplash_def->ShowSplash("Підєднюємось до бази...");
    try
    {
      IBLogin->InitializeBase(Matias);
    }
    catch (...)
    {
      IBLogin->isAutoLogin = false;
      IBLogin->SaveConfig();
      throw "";
    }
    frmSplash_def->ShowSplash("Ініціалізація бази...");
    Operation->Open();
    Firms->Open();
}

//---------------------------------------------------------------------------
void __fastcall TdmFunction::PersonalAfterInsert(TDataSet *DataSet)
{
  PersonalFIRMS_ID->Value = FirmsID->Value;
}
//---------------------------------------------------------------------------
void __fastcall TdmFunction::OrdersAfterInsert(TDataSet *DataSet)
{
  OrdersOPER_TYPE->Value = FieldHistory;
  OrdersPERSONAL_ID->Value = PersonalID->Value;
  OrdersORDER_YEAR->Value = FYEAR;
  OrdersORDER_MONTH->Value = FMOUNTH;
}
//---------------------------------------------------------------------------
void __fastcall TdmFunction::OrdersAfterPost(TDataSet *DataSet)
{
  FieldHistory = OrdersOPER_TYPE->Value;
}
//---------------------------------------------------------------------------

void __fastcall TdmFunction::CreateReportHeader(int M_YEAR,int M_MONTH)
{
  T_REPORT1->First();
  while (!T_REPORT1->Eof) T_REPORT1->Delete();
  dbFolder->Open();
  dbClasificator->Open();
  while (!dbFolder->Eof)
  {
    dbClasificator->Filtered = False;
    dbClasificator->Filter = "PARENT = " + dbFolderID->AsString;
    dbClasificator->Filtered = True;
    dbClasificator->First();
    double SM=0;
    while (!dbClasificator->Eof)
    {
      CALC_OP_TYPE->Close();
      CALC_OP_TYPE->Params->Vars[0]->Value = FirmsID->Value;
      CALC_OP_TYPE->Params->Vars[1]->Value = M_MONTH;
      CALC_OP_TYPE->Params->Vars[2]->Value = M_YEAR;
      CALC_OP_TYPE->Params->Vars[3]->Value = dbClasificatorID->Value;
      CALC_OP_TYPE->ExecProc();
      double SM_T=0;
      if (!VarIsNull(CALC_OP_TYPE->FieldByName("SUMMA")->Value))
        SM_T = CALC_OP_TYPE->FieldByName("SUMMA")->Value;

      if (SM_T != 0)
      {
        T_REPORT1->Insert();
        T_REPORT1PARENT->Value = dbClasificatorID->Value;
        T_REPORT1IS_FOLDER->Value = 0;
        T_REPORT1OP_TYPE->Value = dbClasificatorOP_TYPE->Value;
        T_REPORT1SUMMA->Value = SM_T;
        T_REPORT1->Post();
      }
      SM = SM + SM_T;
      dbClasificator->Next();
    }

    if (SM != 0)
    {
      T_REPORT1->Insert();
      T_REPORT1PARENT->Value = dbFolderID->Value;
      T_REPORT1IS_FOLDER->Value =1;
      T_REPORT1OP_TYPE->Value = dbFolderOP_TYPE->Value;
      T_REPORT1SUMMA->Value = SM;
      T_REPORT1->Post();
    }
    dbFolder->Next();
  }
  dbFolder->Close();
  dbClasificator->Close();

}
//---------------------------------------------------------------------------

void __fastcall TdmFunction::OpenDataSet(TDataSet *DataSet)
{
  if (!DataSet->Active) DataSet->Open();
}
//---------------------------------------------------------------------------

void __fastcall TdmFunction::PostDataSet(TDataSet *DataSet)
{
  if (DataSet->State == dsInsert || DataSet->State == dsEdit) DataSet->Post();
}
//---------------------------------------------------------------------------


String __fastcall TdmFunction::FindSortedField(TDBGridEh *Grid)
{
 for (int i=0;Grid->FieldCount > i;i++)
 {
  TSortMarkerEh sm = Grid->Columns->Items[i]->Title->SortMarker;
  if (sm == smUpEh || sm == smDownEh)
   return Grid->Fields[i]->FieldName;
 }
 return "";
}
//---------------------------------------------------------------------------


void __fastcall TdmFunction::SetFilterOrders(int M_YEAR, int M_MONTH,
                                        Boolean M_Filter, String CFirm)
{
  FYEAR = M_YEAR;
  FMOUNTH = M_MONTH;
  FPERSON = M_Filter;
  FFIRM = CFirm;
  TLocateOptions Opts;
  Opts.Clear();
  if (!Firms->Locate("COMPANY_NAME",CFirm,Opts))
    Registration::SaveValue("CurrentFirm",FirmsCOMPANY_NAME->Value);
  SetPersonalFilter(M_YEAR, M_MONTH,M_Filter);
  SetPersonalFilter(M_YEAR, M_MONTH,M_Filter);
  Orders->Close();
  Orders->ParamByName("CURRENT_YEAR")->Value=M_YEAR;
  Orders->ParamByName("CURRENT_MOUNTH")->Value=M_MONTH;
  Orders->Open();
}
//---------------------------------------------------------------------------

void __fastcall TdmFunction::SetPersonalFilter(int M_YEAR,int M_MONTH,
                                          Boolean M_Filter)
{
  if (M_Filter)
  {
    Personal->Close();
    Personal->SelectSQL->Clear();
    Personal->SelectSQL->Add("select * from PERSONAL");
    Personal->SelectSQL->Add("where FIRMS_ID=" + IntToStr(FirmsID->Value));
    Personal->SelectSQL->Add("ORDER BY PERSONAL_NAME");
    Personal->Open();
  }
  else
  {
    Personal->Close();
    Personal->SelectSQL->Clear();
    Personal->SelectSQL->Add("select * from PERSONAL");
    Personal->SelectSQL->Add("where (FIRMS_ID="+ IntToStr(FirmsID->Value)+
                                   ") AND ((DATE_OUT IS NULL) OR ");
    Personal->SelectSQL->Add("(EXTRACT (YEAR FROM DATE_OUT) >"+
                                   IntToStr(M_YEAR)+") OR ");
    Personal->SelectSQL->Add("((EXTRACT(YEAR FROM DATE_OUT)="+
                                   IntToStr(M_YEAR)+") AND");
    Personal->SelectSQL->Add("(EXTRACT (MONTH FROM DATE_OUT)>="+
                                   IntToStr(M_MONTH)+")))");
    Personal->SelectSQL->Add("ORDER BY PERSONAL_NAME");
    Personal->Open();
  }
}
//---------------------------------------------------------------------------

void __fastcall TdmFunction::OrdersCOUNTSValidate(TField *Sender)
{
  OrdersTOTAL->Value = OrdersCOUNTS->Value * OrdersCASHE->Value
                       * OrdersOPERATION_MULT->Value;
}
//---------------------------------------------------------------------------

void __fastcall TdmFunction::FRefresh(TDataSet *DataSet)
{
 if (DataSet->State == dsBrowse)
   if (dynamic_cast<TpFIBDataSet*>(DataSet))
   {
     TpFIBDataSet* ds = dynamic_cast<TpFIBDataSet *> (DataSet);
     Variant Master = ds->Fields->Fields[0]->Value;
     ds->Transaction->Commit();
     ds->Open();
     TLocateOptions Opts;
     Opts.Clear();
     ds->Locate(ds->Fields->Fields[0]->FieldName,Master,Opts);
    }
}
//---------------------------------------------------------------------------

void __fastcall TdmFunction::FirmsCalcFields(TDataSet *DataSet)
{
  FirmsFIRMNAME->Value = FirmsCOMPANY_NAME->Value;
}
//---------------------------------------------------------------------------

