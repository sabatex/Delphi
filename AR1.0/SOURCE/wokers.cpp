//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "wokers.h"
#include "dm_base.h"
#include "ntics_forms.h"
#include "periodic_edit.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "Halcn6DB"
#pragma link "DBGridEh"
#pragma link "FIBDataSet"
#pragma link "pFIBDataSet"
#pragma resource "*.dfm"
using namespace :: ntics_forms;
Tfrm_wokers *frm_wokers;
//---------------------------------------------------------------------------
__fastcall Tfrm_wokers::Tfrm_wokers(TComponent* Owner)
    : TForm(Owner)
{
    CurrentDate = Now();
}

void __fastcall Tfrm_wokers::SetCurrentDate(TDate CurrentDate)
{
  FCurrentDate = CurrentDate;
  personal->Close();
  //personal->ParamByName("cur_d")->AsDate = CurrentDate;
  personal->Open();
}

//---------------------------------------------------------------------------
void __fastcall Tfrm_wokers::WokersEDRPOUValidate(TField *Sender)
{
/*var
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
*/
}
//---------------------------------------------------------------------------


void __fastcall Tfrm_wokers::DBGridEhKeyDown(TObject *Sender, WORD &Key,
      TShiftState Shift)
{
  if (Key == 0x0d)
  {
    if ((FormStyle == fsNormal) && (personal->State != dsInsert)) Close();
  }
}
//---------------------------------------------------------------------------

void __fastcall Tfrm_wokers::DBGridEhDblClick(TObject *Sender)
{
  if (FormStyle == fsNormal)  Close();
}
//---------------------------------------------------------------------------


void __fastcall Tfrm_wokers::DBGridEhEditButtonClick(TObject *Sender)
{
  if (DBGridEh->SelectedField->FieldName == "PRIYN")
  {
    Tfrm_periodic* periodic = new Tfrm_periodic(Application);
    periodic->ParentDate = personal->FieldValues["D_PRIYN"];
    periodic->ShowModal();
    delete periodic;
    personal->Refresh();
  }

  if (DBGridEh->SelectedField->FieldName == "ZVILN")
  {
    Tfrm_periodic* periodic = new Tfrm_periodic(Application);
    periodic->ParentDate = personal->FieldValues["D_ZVILN"];
    periodic->ShowModal();
    delete periodic;
    personal->Refresh();
  }
}
//---------------------------------------------------------------------------

