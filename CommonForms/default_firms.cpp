//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "default_firms.h"
#include "default_dm_base.h"
#include <ntics_login.h>

//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "JvExComCtrls"
#pragma link "DBGridEh"
#pragma link "FIBDatabase"
#pragma link "FIBDataSet"
#pragma link "pFIBDatabase"
#pragma link "pFIBDataSet"
#pragma resource "*.dfm"
TfrmFirms_def *frmFirms_def;
//---------------------------------------------------------------------------
__fastcall TfrmFirms_def::TfrmFirms_def(TComponent* Owner)
        : TForm(Owner)
{
   taFirms->Active = false;
   taFirms->DefaultDatabase = IBLogin->ProjectBase;
   Firms->Database = IBLogin->ProjectBase;
   taFirms->StartTransaction();
   Firms->Open();
}
//---------------------------------------------------------------------------

