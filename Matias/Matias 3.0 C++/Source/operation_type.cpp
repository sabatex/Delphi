//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "operation_type.h"
#include "dm_base.h"


//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "DBGridEh"
#pragma link "fcdbtreeview"
#pragma link "FIBDatabase"
#pragma link "FIBDataSet"
#pragma link "pFIBDatabase"
#pragma link "pFIBDataSet"
#pragma resource "*.dfm"
TfrmOperationType *frmOperationType;
//---------------------------------------------------------------------------
__fastcall TfrmOperationType::TfrmOperationType(TComponent* Owner)
        : TForm(Owner)
{
 dbFolder->Open();
 dbClasificator->Open();
 SetPosition();
}
//---------------------------------------------------------------------------

void TfrmOperationType::SetPosition()
{
  dbClasificator->Filtered = False;
  dbClasificator->Filter = "PARENT = " + dbFolderID->AsString;
  dbClasificator->Filtered = True;
}
void __fastcall TfrmOperationType::fcDBTreeView1DblClick(
      TfcDBCustomTreeView *TreeView, TfcDBTreeNode *Node,
      TMouseButton Button, TShiftState Shift, int X, int Y)
{
  SetPosition();        
}
//---------------------------------------------------------------------------

void __fastcall TfrmOperationType::aMoveGroupExecute(TObject *Sender)
{
  if (dbClasificator->State == dsBrowse) dbClasificator->Edit();
  dbClasificatorPARENT->Value = dbFolderID->Value;
  dbClasificator->Post();
}
//---------------------------------------------------------------------------

void __fastcall TfrmOperationType::aAddFolderExecute(TObject *Sender)
{
  Variant Master = dbFolderID->Value;
  dbFolder->Insert();
  dbFolderPARENT->Value = Master;
  String NewGroup;
  if (InputQuery("¬вод новой группы","√руппа",NewGroup))
  {
    dbFolderOP_TYPE->Value = NewGroup;
    dbFolderPOSITION_ON_REPORT->Value = 0;
    dbFolder->Post();
  }
  else dbFolder->Cancel();
        
}
//---------------------------------------------------------------------------

void __fastcall TfrmOperationType::dbClasificatorAfterPost(
      TDataSet *DataSet)
{
  aAddElement->Enabled = True;
}
//---------------------------------------------------------------------------

void __fastcall TfrmOperationType::aAddElementExecute(TObject *Sender)
{
  dbClasificator->Insert();
  dbClasificatorPARENT->Value = dbFolderID->Value;
  dbClasificatorIS_FOLDER->Value = 0;
  aAddElement->Enabled = False;
        
}
//---------------------------------------------------------------------------

