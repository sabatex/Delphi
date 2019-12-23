//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "default_about.h"
#include <ntics_login.h>
#include <ntics_registration.h>

//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "default_splash"
#pragma resource "*.dfm"
TfrmAbout_def *frmAbout_def;
//---------------------------------------------------------------------------
TFIBDatabase* __fastcall GetIBBase(TComponent *comp)
{
  for (int i=0;i<comp->ComponentCount;i++)
  {
    if (dynamic_cast<TFIBDatabase*>(comp->Components[i]))
      return dynamic_cast<TFIBDatabase*>(comp->Components[i]);
    TFIBDatabase* temp = GetIBBase(comp->Components[i]);
    if (temp) return temp;
  }
  return 0;
}

__fastcall TfrmAbout_def::TfrmAbout_def(TComponent* Owner)
        : TfrmSplash_def(Owner)
{
  StatusLabel->Caption = "";
  AppIcon->Cursor = crHandPoint;
  LCopyrigth1->Caption = VersionInfo->LegalCopyright;
  LCopyrigth2->Caption = VersionInfo->LegalTradeMarks;
  //LHTMLAdress->Caption = AvtorHTML;
  //LEmailAdress->Caption = AvtorEMAIL;

  if (GetIBBase(Application))
  {
    String s = "Версія бази даних - " + GetIBBase(Application)->QueryValueAsStr("EXECUTE PROCEDURE GET_VERSION_INFO",0);
    ShowSplash(s.c_str());
  }

  //RegistrationOn->Caption = "Зареєстровано на : " +(String)ntics_registration::GetFirmName();
  //RegistrationNumber->Caption="Реєстраційний номер: " +(String)ntics_registration::GetEDRPOU();
  //RegistrationLicenzeCount->Caption="Вид ліцензії: " +(String)ntics_registration::GetLicenzeName();
}
//---------------------------------------------------------------------------
void __fastcall TfrmAbout_def::btOkClick(TObject *Sender)
{
  Close();
}
//---------------------------------------------------------------------------

