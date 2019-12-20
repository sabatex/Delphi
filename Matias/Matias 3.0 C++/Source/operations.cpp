//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "operations.h"
#include "dm_base.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "DBGridEh"
#pragma link "JvMemoryDataset"
#pragma link "default_frGrid"
#pragma resource "*.dfm"
TfrmOperations *frmOperations;
//---------------------------------------------------------------------------
__fastcall TfrmOperations::TfrmOperations(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TfrmOperations::frCustomGrid1DBGridEhKeyDown(
      TObject *Sender, WORD &Key, TShiftState Shift)
{
  if (Key == 0x0d)
  {
    if (frCustomGrid1->DBGridEh->ReadOnly == True)
      if (!cbCalc->Visible)
        Close();
      else
       if (btRasch->Enabled)
       { // добавляем позицию в ввременную таблицу
         tOperations->Insert();
         tOperationsID->Value = dmBase->OperationID->Value;
         tOperationsOPERATION_NAME->Value = dmBase->OperationOPERATION_NAME->Value;
         tOperationsCASHE->Value = dmBase->OperationCASHE->Value;
         tOperationsTIMENORM->Value = dmBase->OperationTIMENORM->Value;
         tOperations->Post();
       }
  }
}
//---------------------------------------------------------------------------

void __fastcall TfrmOperations::cbCalcClick(TObject *Sender)
{
  if (cbCalc->Checked)
  {
    CalcPanel->Visible = True;
    Splitter1->Visible = True;
    frCustomGrid1->DBGridEh->ReadOnly = True;
  }
  else
  {
    Splitter1->Visible = False;
    CalcPanel->Visible = False;
    frCustomGrid1->DBGridEh->ReadOnly = False;
  }
}
//---------------------------------------------------------------------------


void __fastcall TfrmOperations::FormShow(TObject *Sender)
{
  if (FormStyle == fsNormal)
  {
    frCustomGrid1->DBGridEh->ReadOnly = True;
    cbCalc->Checked = False;
    cbCalc->Visible = False;
  }
  //cbCalcClick(this);
  Splitter1->Visible = False;
  CalcPanel->Visible = False;
}
//---------------------------------------------------------------------------

void __fastcall TfrmOperations::btRaschClick(TObject *Sender)
{
  double rasc = StrToFloat(eRasc->Text);
  double norm = StrToFloat(eNorm->Text);
  for (tOperations->First();!tOperations->Eof;tOperations->Next())
  {
    tOperations->Edit();
    tOperationsCASHE->Value = tOperationsCASHE->Value * rasc;
    tOperationsTIMENORM->Value = tOperationsTIMENORM->Value * norm;
  }
  tOperations->First();
  btRasch->Enabled = False;
  btPerenos->Enabled = True;
}
//---------------------------------------------------------------------------

void __fastcall TfrmOperations::Button1Click(TObject *Sender)
{
  tOperations->First();
  while (!tOperations->Eof) tOperations->Delete();
  btRasch->Enabled = True;
  btPerenos->Enabled = False;
}
//---------------------------------------------------------------------------

void __fastcall TfrmOperations::btPerenosClick(TObject *Sender)
{
  tOperations->First();
  while (!tOperations->Eof)
  {
    TLocateOptions Opts;
    Opts.Clear();
    if (dmBase->Operation->Locate("ID",tOperationsID->Value,Opts))
    {
      dmBase->Operation->Edit();
      dmBase->OperationCASHE->Value = tOperationsCASHE->Value;
      dmBase->OperationTIMENORM->Value = tOperationsTIMENORM->Value;
      dmBase->Operation->Post();
      tOperations->Delete();
    }
    else tOperations->Next();
  }
  btPerenos->Enabled = False;
  btRasch->Enabled = True;
}
//---------------------------------------------------------------------------

