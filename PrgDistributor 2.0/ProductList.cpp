//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "ProductList.h"
#include "dm_base.h"
#include "dm_main.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "fcdbtreeview"
#pragma resource "*.dfm"
TfrmProductList *frmProductList;
//---------------------------------------------------------------------------
__fastcall TfrmProductList::TfrmProductList(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
