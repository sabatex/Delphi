//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "dm_baseOld.h"
#include "ntics_login.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "FIBDatabase"
#pragma link "FIBDataSet"
#pragma link "pFIBDatabase"
#pragma link "pFIBDataSet"
#pragma resource "*.dfm"
TdmBaseOld *dmBaseOld;
//---------------------------------------------------------------------------
__fastcall TdmBaseOld::TdmBaseOld(TComponent* Owner)
        : TDataModule(Owner)
{
  // Подключение к базе
  DataBase->Close();
  if (IBLogin->ServerName != "")
    DataBase->DatabaseName = IBLogin->ServerName + ":" + IBLogin->DataBase;
  else
    DataBase->DatabaseName = IBLogin->DataBase;
  DataBase->ConnectParams->UserName = IBLogin->UserName;
  DataBase->ConnectParams->Password = IBLogin->Password;
  DataBase->ConnectParams->CharSet = "WIN1251";
  DataBase->ConnectParams->RoleName = IBLogin->UserName;
  try
  {
    DataBase->Open();
  }
  catch (...)
  {
    throw "Невозможно соединится с базой. Проверьте пароль.";
  }

  PROGRAMM_PRODUCT->Open();
  VERSION_PRODUCTS->Open();
  FIRMS->Open();
  PROD->Open();
}
//---------------------------------------------------------------------------
void __fastcall TdmBaseOld::VERSION_PRODUCTSAfterInsert(TDataSet *DataSet)
{
  VERSION_PRODUCTSPROGRAMM_PRODUCTS_ID->Value = PROGRAMM_PRODUCTID->Value;
}
//---------------------------------------------------------------------------

