//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "ntics_about.h"
#include "default_dm_main.h"
#include "default_firms.h"
#include <ntics_forms.h>

//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TdmMain_def *dmMain_def;
//---------------------------------------------------------------------------
__fastcall TdmMain_def::TdmMain_def(TComponent* Owner)
        : TDataModule(Owner)
{
}
//---------------------------------------------------------------------------


void __fastcall TdmMain_def::AboutExecute(TObject *Sender)
{
  TfrmNTICS_About* about = new TfrmNTICS_About(Application);
  about->ShowModal();
  delete about;
}
//---------------------------------------------------------------------------

void __fastcall TdmMain_def::aFirmsExecute(TObject *Sender)
{
   using namespace :: ntics_forms;
   ShowForm(__classid(TfrmFirms_def),"Фірми",ftMDI);
}
//---------------------------------------------------------------------------

