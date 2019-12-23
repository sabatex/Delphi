//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "default_splash.h"

//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"

TfrmSplash_def *frmSplash_def;

//---------------------------------------------------------------------------
__fastcall TfrmSplash_def::TfrmSplash_def(TComponent* Owner)
        : TForm(Owner)
{
  VersionInfo = new TJclFileVersionInfo(ExtractFileName(Application->ExeName));
  LVersion->Caption = "Version " +  VersionInfo->FileVersion;
  lProductName->Caption = VersionInfo->ProductName;
}
//---------------------------------------------------------------------------
__fastcall TfrmSplash_def::~TfrmSplash_def(void)
{
   delete VersionInfo;
}

//------------------------------
void __fastcall TfrmSplash_def::ShowSplash(char* s)
{
  StatusLabel->Caption = s;
  Refresh();
}


