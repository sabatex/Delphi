//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "options.h"

//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "DBGridEh"
#pragma link "Halcn6DB"
#pragma resource "*.dfm"
Tfrm_options *frm_options;
//---------------------------------------------------------------------------
__fastcall Tfrm_options::Tfrm_options(TComponent* Owner)
    : TForm(Owner)
{
/*  Year.Text:=IntToStr(dmFunction.CurrentYear);
  Kvartal.Text:=IntToStr(dmFunction.CurrentPeriod);
  edFIRMS.Text:=Firms.FirmName;
  FEDRPOU.Text:=Firms.EDRPOU;
  RefreshAll;
                if Firms.TFO=0 then
                VFO.Text:='Юридична'
              else
                VFO.Text:='Фізична';
              DirName.Text:=Firms.BOSSNAME;
              DirCod.Text:=Firms.BOSSCOD;
              DirTell.Text:=Firms.BOSSTELL;
              ShiefName.Text:=Firms.SHIEFNAME;
              ShiefCod.Text:=Firms.SHIEFCOD;
              ShiefTell.Text:=Firms.SHIEFTELL;
              EDRPOUPOD.Text:=Firms.EDRPOUPOD;
              PODNAME.Text:=firms.PODNAME;
              PODCOD.Text:=firms.CODPOD;
              PODOBL.Text:=Firms.CODOBL;

*/
}
//---------------------------------------------------------------------------
void __fastcall Tfrm_options::btOKClick(TObject *Sender)
{
/*  Firms->EDRPOUPOD=EDRPOUPOD->Text;
  Firms.BOSSNAME:=DirName.Text;
  Firms.BOSSCOD:=DirCod.Text;
  Firms.BOSSTELL:=DirTell.Text;
  Firms.SHIEFNAME:=ShiefName.Text;
  Firms.SHIEFCOD:=ShiefCod.Text;
  Firms.SHIEFTELL:=ShiefTell.Text;
  Firms.EDRPOUPOD:=EDRPOUPOD.Text;
  firms.PODNAME:=PODNAME.Text;
  firms.CODPOD:=PODCOD.Text;
  Firms.CODOBL:=PODOBL.Text;
  dmFunction.CurrentDate:=StrToDate('01.'+IntToStr(StrToInt(Kvartal.Text)*3)+'.'
                          +Year.Text);
  Close;
*/
}
//---------------------------------------------------------------------------
void __fastcall Tfrm_options::sbPriorYearClick(TObject *Sender)
{
/*  if StrToInt(Year.Text)>1999 then
    Year.Text:=IntToStr(StrToInt(Year.Text)-1);
  dmFunction.CurrentDate:=StrToDate('01.'+IntToStr(StrToInt(Kvartal.Text)*3)+'.'
                          +Year.Text);
*/
}
//---------------------------------------------------------------------------
void __fastcall Tfrm_options::sbNextYearClick(TObject *Sender)
{
/*  if StrToInt(Year.Text)<2999 then
    Year.Text:=IntToStr(StrToInt(Year.Text)+1);
  dmFunction.CurrentDate:=StrToDate('01.'+IntToStr(StrToInt(Kvartal.Text)*3)+'.'
                          +Year.Text);
*/
}
//---------------------------------------------------------------------------
void __fastcall Tfrm_options::sbPriorKvartalClick(TObject *Sender)
{
/*  if StrToInt(Kvartal.Text)>1 then
    Kvartal.Text:=IntToStr(StrToInt(Kvartal.Text)-1);
  dmFunction.CurrentDate:=StrToDate('01.'+IntToStr(StrToInt(Kvartal.Text)*3)+'.'
                          +Year.Text);
*/
}
//---------------------------------------------------------------------------
void __fastcall Tfrm_options::sbNextKvartalClick(TObject *Sender)
{
/*  if StrToInt(Kvartal.Text)<4 then
    Kvartal.Text:=IntToStr(StrToInt(Kvartal.Text)+1);
  dmFunction.CurrentDate:=StrToDate('01.'+IntToStr(StrToInt(Kvartal.Text)*3)+'.'
                          +Year.Text);
*/
}
//---------------------------------------------------------------------------
void __fastcall Tfrm_options::btCloseClick(TObject *Sender)
{
  Close();
}
//---------------------------------------------------------------------------
void __fastcall Tfrm_options::FormShow(TObject *Sender)
{
  LGT->Open();
  OZN->Open();    
}
//---------------------------------------------------------------------------
