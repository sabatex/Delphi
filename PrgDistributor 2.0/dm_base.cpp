//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "dm_base.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "default_dm_base"
#pragma link "FIBDatabase"
#pragma link "FIBQuery"
#pragma link "pFIBDatabase"
#pragma link "pFIBQuery"
#pragma link "pFIBStoredProc"
#pragma link "FIBDataSet"
#pragma link "pFIBDataSet"
#pragma resource "*.dfm"
TdmBase *dmBase;
//---------------------------------------------------------------------------
__fastcall TdmBase::TdmBase(TComponent* Owner)
    : TdmBase_def(Owner)
{
  PROGRAMM_PRODUCT->Open();
  VERSION_PRODUCTS->Open();
  FIRMS->Open();
  PROD->Open();
}
//---------------------------------------------------------------------------
void __fastcall TdmBase::VERSION_PRODUCTSAfterInsert(TDataSet *DataSet)
{
  VERSION_PRODUCTSPROGRAMM_PRODUCTS_ID->Value = PROGRAMM_PRODUCTID->Value;
}
//---------------------------------------------------------------------------
