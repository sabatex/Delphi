//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include <ntics_login.h>
#include "default_dm_base.h"
#include "ntics_splash.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "FIBDatabase"
#pragma link "pFIBDatabase"
#pragma resource "*.dfm"
TdmBase_def *dmBase_def;
//---------------------------------------------------------------------------
__fastcall TdmBase_def::TdmBase_def(TComponent* Owner)
        : TDataModule(Owner)
{
   // ������ ������� ����� ������
   IBLogin = new TIBLogin(Application);
   if (!IBLogin->LoginExecute()) throw "";

   // ������� ��������
   frmNTICS_Splash = new TfrmNTICS_Splash(Application);
   frmNTICS_Splash->Show();
   frmNTICS_Splash->ShowSplash("ϳ��������� �� ����...");
    try
    {
      IBLogin->InitializeBase(mainDatabase);
    }
    catch (...)
    {
      IBLogin->isAutoLogin = false;
      IBLogin->SaveConfig();
      throw "";
    }
    frmNTICS_Splash->ShowSplash("����������� ����...");
}
//---------------------------------------------------------------------------
