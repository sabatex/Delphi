//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "PayProduct.h"
#include "dm_base.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "DBCtrlsEh"
#pragma link "DBLookupEh"
#pragma resource "*.dfm"
TfrmPayProduct *frmPayProduct;
//---------------------------------------------------------------------------
__fastcall TfrmPayProduct::TfrmPayProduct(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TfrmPayProduct::DBEditEh1EditButtons0Click(TObject *Sender,
      bool &Handled)
{
  if (SaveDialog1->Execute())
    DBEditEh1->Value = SaveDialog1->FileName;
}
//---------------------------------------------------------------------------
