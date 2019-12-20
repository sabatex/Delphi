//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "order.h"
#include "ntics_forms.h"
#include "operations.h"
#include "dm_base.h"


//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "default_frGrid"
#pragma resource "*.dfm"
TfrmOrder *frmOrder;
//---------------------------------------------------------------------------
__fastcall TfrmOrder::TfrmOrder(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TfrmOrder::frCustomGrid2DBGridEhKeyPress(TObject *Sender,
      char &Key)
{
  if (Key == 0x0d)
  {
    if (frCustomGrid2->DBGridEh->SelectedField->FieldName == "OPERATION_NAME")
    {
      if ((dmBase->Orders->State != dsEdit)&&(dmBase->Orders->State != dsInsert))
        {dmBase->Orders->Edit();}
      using namespace :: ntics_forms;  
      TForm* temp = ShowForm(__classid(TfrmOperations),"Вибір типу операції",ftModal);
      delete temp;
      dmBase->OrdersOPERATION_ID->Value = dmBase->OperationID->Value;
      dmBase->OrdersOPERATION_NAME->Value = dmBase->OperationOPERATION_NAME->Value;
      dmBase->OrdersCASHE->Value = dmBase->OperationCASHE->Value;
      Key=0x1a;
    }
  }

}
//---------------------------------------------------------------------------
