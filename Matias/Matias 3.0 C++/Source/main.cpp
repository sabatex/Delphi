//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "main.h"
//---------------------------------------------------------------------------
#include <ntics_registration.h>
#include <ntics_forms.h>
#include "default_splash.h"
#include "dm_main.h"
#include "dm_base.h"



//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "CSPIN"
#pragma resource "*.dfm"
TfrmMain *frmMain;
//---------------------------------------------------------------------------
__fastcall TfrmMain::TfrmMain(TComponent* Owner) : TForm(Owner)
{
  frmSplash_def->ShowSplash("����������� ������� �����...");
  WindowState = wsMaximized;

  // �������� ������ ����
  cbFirms->Items->Clear();
  for (dmBase->Firms->First();!dmBase->Firms->Eof;dmBase->Firms->Next())
  {
    cbFirms->Items->Add(dmBase->FirmsCOMPANY_NAME->Value);
  }

  // ������������� ������� �����
  String s = Registration::LoadValue("CurrentFirm","");
  cbFirms->ItemIndex=cbFirms->Items->IndexOf(s);
  TLocateOptions Opts;
  Opts.Clear();
  dmBase->Firms->Locate("COMPANY_NAME",s,Opts);

  // �������������� �������� ���������
  M_YEAR->Value = StrToInt(Registration::LoadValue("M_YEAR","2001"));
  M_MONTH->ItemIndex = StrToInt(Registration::LoadValue("M_MONTH","9"));
  OldWokers->Checked = StrToBool(Registration::LoadValue("OldWokers","0"));
  cbFirmsClick(this);
}
//---------------------------------------------------------------------------


void __fastcall TfrmMain::cbFirmsClick(TObject *Sender)
{
  dmBase->SetFilterOrders(M_YEAR->Value,
                              M_MONTH->ItemIndex+1,
                              OldWokers->Checked,
                              cbFirms->Text);
}
//---------------------------------------------------------------------------

void __fastcall TfrmMain::FormDestroy(TObject *Sender)
{
  // ��������� �������� ���������
  Registration::SaveValue("CurrentFirm",dmBase->FirmsCOMPANY_NAME->Value);
  Registration::SaveValue("M_YEAR",IntToStr(M_YEAR->Value));
  Registration::SaveValue("M_MONTH",IntToStr(M_MONTH->ItemIndex));
  Registration::SaveValue("OldWokers",BoolToStr(OldWokers->Checked));
}
//---------------------------------------------------------------------------


void __fastcall TfrmMain::FormShow(TObject *Sender)
{
  // ��������� �������� ����� ������� �������� �����
  delete frmSplash_def;
}
//---------------------------------------------------------------------------

