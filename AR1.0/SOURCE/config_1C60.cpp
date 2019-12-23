//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "config_1C60.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "Halcn6DB"
#pragma link "DBGridEh"
#pragma resource "*.dfm"
Tfrm_config1c60 *frm_config1c60;
//---------------------------------------------------------------------------
__fastcall Tfrm_config1c60::Tfrm_config1c60(TComponent* Owner)
    : TForm(Owner)
{
  ListTables->Open();
  Options->Open();
}
//---------------------------------------------------------------------------

void __fastcall Tfrm_config1c60::ListTablesAfterScroll(TDataSet *DataSet)
{
  Options->Filtered = False;
  Options->Filter = "ID=" + IntToStr(ListTablesID->Value);
  Options->Filtered = True;
}
//---------------------------------------------------------------------------

void __fastcall Tfrm_config1c60::ListTablesNewRecord(TDataSet *DataSet)
{
  ListTablesVID->AsVariant = Filter1C;
  ListTablesID->Value = ListTables->RecordCount + 1;
}
//---------------------------------------------------------------------------

void __fastcall Tfrm_config1c60::SetFilter1C(const String Value)
{
  FFilter = Value;
  ListTables->Filtered = False;
  ListTables->Filter = "VID=" + Value;
  ListTables->Filtered = True;
  ListTablesAfterScroll(ListTables);
}
