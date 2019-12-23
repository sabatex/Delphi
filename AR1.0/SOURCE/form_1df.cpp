//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "ntics_storages.h"
#include "ntics_registration.h"
#include "ntics_forms.h"
#include "form_1df.h"
#include "dm_base.h"
#include "wokers.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "Halcn6DB"
#pragma link "DBGridEh"
#pragma link "FIBDataSet"
#pragma link "pFIBDataSet"
#pragma link "FIBQuery"
#pragma link "pFIBQuery"
#pragma resource "*.dfm"
Tfrm_1df *frm_1df;
using namespace :: ntics_storages;
using namespace :: ntics_forms;
const char* cYear = "CurrentYear";
const char* cPeriod = "CurrentPeriod";

//---------------------------------------------------------------------------
__fastcall Tfrm_1df::Tfrm_1df(TComponent* Owner)
    : TForm(Owner)
{
    CurrentYear = LocalStorage->ReadInteger(DefaultSection,cYear,1999);
    CurrentPeriod = LocalStorage->ReadInteger(DefaultSection,cPeriod,1);
    Tree->Open();
    TreePeriod->Items->Clear();
    int item = 0;
    TTreeNode *RootNode;
    for (Tree->First();!Tree->Eof;Tree->Next())
    {
      if (Tree->Bof) // First node
      {
        TreePeriod->Items->Add(NULL,Tree->FieldValues["RIK"]);
        RootNode = TreePeriod->Items->Item[0];
      }
      // next node
      if (RootNode->Text != Tree->FieldValues["RIK"])
      {
        TreePeriod->Items->Add(RootNode,Tree->FieldValues["RIK"]);
        RootNode = TreePeriod->Items->Item[++item];
      }
      // Child node
      //String NodeName = ;
      TreePeriod->Items->AddChild(RootNode,String(Tree->FieldValues["PERIOD"]) + " - квартал");
      item++;
    }
    DA->Open();
}
//---------------------------------------------------------------------------
void __fastcall Tfrm_1df::SetYear(int Value)
{
   if (Value < 1999) Value = 1999;
   if (Value != FYear)
   {
      FYear = Value;
      SetFilter();
   }
}

//---------------------------------------------------------------------------

void __fastcall Tfrm_1df::SetFilter()
{
    // Устанавливаем фильтр
    DA->Filtered = False;
    DA->Filter = "(PERIOD = " + IntToStr(CurrentPeriod) +
                 ") AND (RIK = " + IntToStr(CurrentYear) + ")";
    DA->Filtered = True;
    // Выводим период на подсказку
    PanelPeriod()->Text = "Текучий період " + IntToStr(CurrentYear) + "рік. "
                            + IntToStr(CurrentPeriod) + " квартал";

}
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
void __fastcall Tfrm_1df::SetPeriod(int Value)
{
   if (Value < 1) Value = 1;
   if (Value > 4) Value = 4;
   if (Value != FPeriod)
   {
      FPeriod = Value;
      SetFilter();
   }
}

void __fastcall Tfrm_1df::sbPriorYearClick(TObject *Sender)
{
    CurrentYear = CurrentYear - 1;
}
//---------------------------------------------------------------------------

void __fastcall Tfrm_1df::sbNextYearClick(TObject *Sender)
{
    CurrentYear = CurrentYear + 1;
}
//---------------------------------------------------------------------------

void __fastcall Tfrm_1df::sbPriorKvartalClick(TObject *Sender)
{
    CurrentPeriod = CurrentPeriod - 1;
}
//---------------------------------------------------------------------------

void __fastcall Tfrm_1df::sbNextKvartalClick(TObject *Sender)
{
    CurrentPeriod = CurrentPeriod + 1;
}
//---------------------------------------------------------------------------

void __fastcall Tfrm_1df::FormDestroy(TObject *Sender)
{
  LocalStorage->WriteInteger(DefaultSection,cYear,CurrentYear);
  LocalStorage->WriteInteger(DefaultSection,cPeriod,CurrentPeriod);
  //LocalStorage->WriteInteger(DefaultSection,cPeriod,TreePeriod->Selected->Index);
}
//---------------------------------------------------------------------------

void __fastcall Tfrm_1df::DAAfterInsert(TDataSet *DataSet)
{
  DA->FieldByName("PERIOD")->Value = CurrentPeriod;
  DA->FieldByName("RIK")->Value = CurrentYear;
}
//---------------------------------------------------------------------------


void __fastcall Tfrm_1df::DBGridEhEditButtonClick(TObject *Sender)
{
  if (DBGridEh->SelectedField->FieldName == "TIN")
  {
    Tfrm_wokers* woker = dynamic_cast<Tfrm_wokers*>(ShowForm(__classid(Tfrm_wokers),"Працывники",ftModal));
    if ((DA->FieldValues["WOKERS_ID"] != woker->personal->FieldValues["ID"]) &&
       (DA->State != dsEdit) && (DA->State != dsInsert))
       DA->Edit();
    DA->FieldValues["WOKERS_ID"] = woker->personal->FieldValues["ID"];
    DA->FieldValues["TIN"] = woker->personal->FieldValues["TIN"];
    DA->FieldValues["PERSONAL_NAME"] = woker->personal->FieldValues["PERSONAL_NAME"];
    delete woker;
  }
}
//---------------------------------------------------------------------------

void __fastcall Tfrm_1df::TreePeriodDblClick(TObject *Sender)
{
  if (TreePeriod->Selected->Level !=0)
  {
    CurrentPeriod = TreePeriod->Selected->Text.SubString(1,1).ToInt();
    CurrentYear = TreePeriod->Selected->Parent->Text.ToInt();
  }
}
//---------------------------------------------------------------------------

TStatusPanel* __fastcall Tfrm_1df::PanelPeriod()
{
  return StatusBar->Panels->Items[0];
}
//---------------------------------------------------------------------------

