//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "main_old.h"
#include "dm_main.h"
#include <default_about.h>


//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TfrmMain *frmMain;
//---------------------------------------------------------------------------
__fastcall TfrmMain::TfrmMain(TComponent* Owner)
        : TForm(Owner)
{
  WindowState = wsMaximized;
}
//---------------------------------------------------------------------------


void __fastcall TfrmMain::AboutExecute(TObject *Sender)
{
  TfrmAbout_def* about = new TfrmAbout_def(Application);
  about->ShowModal();
  delete about;        
}
//---------------------------------------------------------------------------




