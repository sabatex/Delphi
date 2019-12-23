//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "firms.h"
#include "dm_base.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "JvExComCtrls"
#pragma link "JvStatusBar"
#pragma link "DBGridEh"
#pragma resource "*.dfm"
TfrmFirms *frmFirms;
//---------------------------------------------------------------------------
__fastcall TfrmFirms::TfrmFirms(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------

