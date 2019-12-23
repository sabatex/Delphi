//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "ntics_registration.h"
#include "ntics_forms.h"
#include "dm_main.h"
#include "wokers.h"
#include "form_1df.h"
#include "options.h"
#include "config_1C60.h"
#include "dm_base.h"

//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "default_dm_main"
#pragma link "frxClass"
#pragma link "frxDBSet"
#pragma link "FR_Class"
#pragma link "FR_DBSet"
#pragma link "FR_DCtrl"
#pragma link "FR_DSet"
#pragma link "FR_Rich"
#pragma resource "*.dfm"
TdmMain *dmMain;
//---------------------------------------------------------------------------
__fastcall TdmMain::TdmMain(TComponent* Owner)
        : TdmMain_def(Owner)
{
    // Активизация ключей защиты и лицензий
    using namespace :: ntics_registration;
    const char* dkey = "12346637823892372376932598098034528777";
    const char* nkey = "37589961361261320842023505902145036115508087222288668981222381658734312452805555445192255020759471816058817685052839987867318233673578372970658919133235486883703202423812118281582220992879939831608438526785525649079029314389320175669539147010733446633411";
    SetKey(dkey,nkey);
    AddLicenze("На фірму");

    // Установка стартовых значений
    CurrentDate = Now();
}

//---------------------------------------------------------------------------
void __fastcall TdmMain::aRegistrationExecute(TObject *Sender)
{
  if (OpenRegKey->Execute()) ntics_registration::SetSerial(OpenRegKey->FileName);
}
//---------------------------------------------------------------------------
void __fastcall TdmMain::aWokersExecute(TObject *Sender)
{
   using namespace :: ntics_forms;
   ShowForm(__classid(Tfrm_wokers),"Працівники",ftMDI);
}
//---------------------------------------------------------------------------

void __fastcall TdmMain::a1DFExecute(TObject *Sender)
{
   using namespace :: ntics_forms;
   ShowForm(__classid(Tfrm_1df),"Форма 1ДФ",ftMDI);
}
//---------------------------------------------------------------------------

void __fastcall TdmMain::aOptionsExecute(TObject *Sender)
{
   using namespace :: ntics_forms;
   ShowForm(__classid(Tfrm_options),"Настройки 1ДФ",ftMDI);
}
//---------------------------------------------------------------------------

void __fastcall TdmMain::aConfig1C60Execute(TObject *Sender)
{
   using namespace :: ntics_forms;
   Tfrm_config1c60* frm = dynamic_cast<Tfrm_config1c60*>(ShowForm(
                __classid(Tfrm_config1c60),"Параметри загрузки 1С6.0",ftMDI));
   frm->Filter1C = "66";
}
//---------------------------------------------------------------------------

void __fastcall TdmMain::aConfig1C77Execute(TObject *Sender)
{
   using namespace :: ntics_forms;
   Tfrm_config1c60* frm = dynamic_cast<Tfrm_config1c60*>(ShowForm(
                __classid(Tfrm_config1c60),"Параметри загрузки 1С7.7",ftMDI));
   frm->Filter1C = "77";
}
//---------------------------------------------------------------------------


void __fastcall TdmMain::aReport1DFExecute(TObject *Sender)
{
  frReport1->LoadFromResourceName((int)HInstance,"Report8DR");
  frReport1->ShowReport();
}
//---------------------------------------------------------------------------

void __fastcall TdmMain::frReport1GetValue(const AnsiString ParName,
      Variant &ParValue)
{
  if (ParName == "EDRPOU") ParValue = 0;//Firms->EDRPOU;
  if (ParName == "FIRMNAME") ParValue= " ";//Firms->FirmName;
  if (ParName == "EDRPOUPOD") ParValue= 0;//Firms->EDRPOUPOD;
  if (ParName == "WUSER") ParValue=0;//Firms->TFO;
  if (ParName == "PODNAME") ParValue=" ";//Firms->PODNAME;
  if (ParName == "PERIOD") ParValue=0;//dmFunction->CurrentPeriod;
  if (ParName == "RIK") ParValue=0;//dmFunction->CurrentYear;
  if (ParName == "BOSSCOD") ParValue=0;//Firms->BOSSCOD;
  if (ParName == "BOSSTELL") ParValue=0;//Firms->BOSSTELL;
  if (ParName == "BOSSNAME") ParValue=" ";//Firms->BOSSNAME;
  if (ParName == "SHIEFTELL") ParValue=0;//Firms->SHIEFTELL;
  if (ParName == "SHIEFNAME") ParValue=" ";//Firms->SHIEFNAME;
  if (ParName == "SHIEFCOD") ParValue=0;//Firms->SHIEFCOD;

}
//---------------------------------------------------------------------------

void __fastcall TdmMain::frReport1UserFunction(const AnsiString Name,
      Variant &p1, Variant &p2, Variant &p3, Variant &Val)
{
  if (Name=="GETDIGIT")
  {
    String s = frParser->Calc(p1);
    int pos = frParser->Calc(p2);
    if (s.Length() >= pos)
      Val = s.SubString(s.Length()+1-pos,1);
  };
}
//---------------------------------------------------------------------------

void __fastcall TdmMain::aImportConfigExecute(TObject *Sender)
{
  //dmFunction.LoadAsConfig;    
}
//---------------------------------------------------------------------------

void __fastcall TdmMain::aExportConfigExecute(TObject *Sender)
{
//  dmFunction.SaveAsConfig;    
}
//---------------------------------------------------------------------------

void __fastcall TdmMain::aExport1DFExecute(TObject *Sender)
{
  //dmFunction.ExportReport8DR;    
}
//---------------------------------------------------------------------------

const char* NoAllChildClose = "Для виконання даної операції необхідно закрити всі вікна";
void __fastcall TdmMain::aImport1C60Execute(TObject *Sender)
{
  // импорт даних з 1с
  if (Application->MainForm->MDIChildCount != 0)
  {
    MessageDlg(NoAllChildClose,mtError,TMsgDlgButtons() << mbOK,0);
    exit;
  }
  //dmFunction.ImportFrom1c60();
}
//---------------------------------------------------------------------------

void __fastcall TdmMain::aImport1C77Execute(TObject *Sender)
{
  // импорт даних з 1с7.7
  if (Application->MainForm->MDIChildCount != 0)
  {
    MessageDlg(NoAllChildClose,mtError,TMsgDlgButtons() << mbOK,0);
    exit;
  }
  //dmFunction.ImportFrom1c77();
}
//---------------------------------------------------------------------------

