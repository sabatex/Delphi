//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "firms.h"
#include "main.h"
#include "data_module.h"

//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "default_frGrid"
#pragma resource "*.dfm"
TfrmFirms *frmFirms;
//---------------------------------------------------------------------------
__fastcall TfrmFirms::TfrmFirms(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------


void __fastcall TfrmFirms::FormDestroy(TObject *Sender)
{
  frmMain->cbFirms->ItemIndex = frmMain->cbFirms->Items->IndexOf(
                                dmFunction->FirmsCOMPANY_NAME->Value);
  frmMain->cbFirmsClick(0);
}
//---------------------------------------------------------------------------

