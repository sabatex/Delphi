//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "periodic_edit.h"
#include "dm_base.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "DBGridEh"
#pragma link "FIBDataSet"
#pragma link "pFIBDataSet"
#pragma resource "*.dfm"
Tfrm_periodic *frm_periodic;
//---------------------------------------------------------------------------
__fastcall Tfrm_periodic::Tfrm_periodic(TComponent* Owner)
  : TForm(Owner)
{
  Parent = 0;
}
//---------------------------------------------------------------------------
void __fastcall Tfrm_periodic::SetParent(int Parent)
{
  FParent = Parent;
  periodic_date->Close();
  periodic_date->ParamByName("parent_filter")->AsInteger = Parent;
  periodic_date->Open();
}
