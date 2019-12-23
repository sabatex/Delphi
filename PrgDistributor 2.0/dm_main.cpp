//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "dm_main.h"

#include "dm_base.h"
#include "ntics_forms.h"
#include "ProductList.h"
#include "FGInt.hpp"
#include "FGIntPrimeGeneration.h"
#include "FGIntRSA.hpp"
#include "NewProduct.h"
#include "PayProduct.h"
#include "ntics_key_gen.h"
#include "ntics_const.hpp"



//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "default_dm_main"
#pragma resource "*.dfm"
TdmMain *dmMain;
const char* ekey = "12346637823892372376932598098034528775";
const char* nkey = "18485570772945196928080203883454327034332575224359704683056765228914471565566459156090528366719575315168395758380033012596379258069954522671418527069497768624451672417122368076770777075416564672589482213098142843030569884439638711638589508286501";

void GenerateKey(TFGInt &n,TFGInt  &e, TFGInt &d)
{
  // генеруємо ключi P,Q
  TFGInt p;
  Base256StringToFGInt("Copyrigth C Serhiy Lakas"+DateToStr(Now()),p);
  PrimeSearch(p);
  Randomize;
  TFGInt q;
  FGIntMulByInt(p,q,RandomInteger(0,MaxInt));
  PrimeSearch(q);

  // визначаємо n та phi
  TFGInt phi,one,two,p1,q1,m;
  FGIntMul(p,q,n);
  Base10StringToFGInt("1", one);
  Base10StringToFGInt("2", two);
  FGIntSub(p,one,p1);
  FGIntSub(q,one,q1);
  FGIntMul(p1,q1,m);

  // шукаємо  ключ d
  TFGInt gcd,temp;
  Base10StringToFGInt("12346637823892372376932598098034528775",d);
  FGIntGCD(m,d,gcd);

  while (FGIntCompareAbs(gcd, one) != Eq)
  {
      FGIntAdd(d, two, temp);
      FGIntCopy(temp, d);
      FGIntGCD(m, d, gcd);
  }

  // Створюємо ключ e
  FGIntModInv(d, m, e);
  FGIntDestroy(one);
  FGIntDestroy(two);
  FGIntDestroy(gcd);
  FGIntDestroy(p);
  FGIntDestroy(q);
  FGIntDestroy(m);
  FGIntDestroy(temp);

  //Тестуємо ключі
  String test1 = "Test string";
  String test2;
  RSAEncrypt(test1,d,n,test2);
  RSADecrypt(test2,e,n,temp,temp,temp,temp,test2);
  if (test1 != test2)
    throw "Error keys";

}


//---------------------------------------------------------------------------
__fastcall TdmMain::TdmMain(TComponent* Owner)
    : TdmMain_def(Owner)
{
}

//---------------------------------------------------------------------------
void __fastcall TdmMain::aShowProductsExecute(TObject *Sender)
{
  using namespace :: ntics_forms;
  ShowForm(__classid(TfrmProductList),"Продаваемые программы",ftMDI);
    
}
//---------------------------------------------------------------------------
void __fastcall TdmMain::aAddProgrammExecute(TObject *Sender)
{
  //s:string;
  dmBase->PROGRAMM_PRODUCT->Insert();
  dmBase->PROGRAMM_PRODUCT->Post();
  dmBase->PROGRAMM_PRODUCT->Edit();
  dmBase->VERSION_PRODUCTS->Insert();

  TFGInt n,e,d;
  GenerateKey(n,e,d);

  // зберігаемо ключі
  String s;
  FGIntToBase10String(e,s);
  dmBase->VERSION_PRODUCTSKEY_E->Value = s;
  FGIntToBase10String(n,s);
  dmBase->VERSION_PRODUCTSKEY_N->Value = s;
  FGIntToBase10String(d,s);
  dmBase->VERSION_PRODUCTSKEY_D->Value = s;

  FGIntDestroy(n);
  FGIntDestroy(e);
  FGIntDestroy(d);

  frmNewProduct = new TfrmNewProduct(Application);
  frmNewProduct->ShowModal();
  delete frmNewProduct;
    
}
//---------------------------------------------------------------------------
void __fastcall TdmMain::aNewVersionWithNewKeyExecute(TObject *Sender)
{
  TFGInt n,e,d;
  dmBase->VERSION_PRODUCTS->Insert();
  GenerateKey(n,e,d);

  // зберігаемо ключі
  String s;
  FGIntToBase10String(e,s);
  dmBase->VERSION_PRODUCTSKEY_E->Value = s;
  FGIntToBase10String(n,s);
  dmBase->VERSION_PRODUCTSKEY_N->Value = s;
  FGIntToBase10String(d,s);
  dmBase->VERSION_PRODUCTSKEY_D->Value = s;

  FGIntDestroy(n);
  FGIntDestroy(e);
  FGIntDestroy(d);

  frmNewProduct = new TfrmNewProduct(Application);
  frmNewProduct->Product->ReadOnly = true;
  frmNewProduct->ShowModal();
  delete frmNewProduct;
    
}
//---------------------------------------------------------------------------
void __fastcall TdmMain::aNewVersionWithOldKeyExecute(TObject *Sender)
{
  String n = dmBase->VERSION_PRODUCTSKEY_N->Value;
  String e = dmBase->VERSION_PRODUCTSKEY_E->Value;
  String d = dmBase->VERSION_PRODUCTSKEY_D->Value;
  dmBase->VERSION_PRODUCTS->Insert();
  // зберігаемо ключі
  dmBase->VERSION_PRODUCTSKEY_E->Value = e;
  dmBase->VERSION_PRODUCTSKEY_N->Value = n;
  dmBase->VERSION_PRODUCTSKEY_D->Value = d;

  frmNewProduct = new TfrmNewProduct(Application);
  frmNewProduct->Product->ReadOnly = true;
  frmNewProduct->ShowModal();
  delete frmNewProduct;
    
}
//---------------------------------------------------------------------------
void __fastcall TdmMain::aDeleteVersionExecute(TObject *Sender)
{
  if (!dmBase->VERSION_PRODUCTS->IsEmpty()) dmBase->VERSION_PRODUCTS->Delete();
  if (dmBase->VERSION_PRODUCTS->IsEmpty()) dmBase->PROGRAMM_PRODUCT->Delete();
    
}
//---------------------------------------------------------------------------
void __fastcall TdmMain::aEditCurrentVersionExecute(TObject *Sender)
{
  frmNewProduct = new TfrmNewProduct(Application);
  frmNewProduct->Product->ReadOnly = true;
  frmNewProduct->ShowModal();
  delete frmNewProduct;
    
}
//---------------------------------------------------------------------------
void __fastcall TdmMain::aPayProgrammExecute(TObject *Sender)
{
  //temp:TSecretKey;
  //with dmFunction do
  dmBase->PROD->Insert();
  dmBase->PRODPRODUCT_ID->Value = dmBase->PROGRAMM_PRODUCTID->Value;
  dmBase->PRODVERSION_ID->Value = dmBase->VERSION_PRODUCTSID->Value;

  TFGInt d,n,e;
  frmPayProduct = new TfrmPayProduct(Application);
  if (frmPayProduct->ShowModal() == mrOk)
  {
    Base10StringToFGInt(dmBase->VERSION_PRODUCTSKEY_D->Value,d);
    Base10StringToFGInt(dmBase->VERSION_PRODUCTSKEY_N->Value,n);
    Base10StringToFGInt(dmBase->VERSION_PRODUCTSKEY_E->Value,e);

    String s = VersionKey + ";";
           s = s + Copyrigth +
               ";" + dmBase->FIRMSEDRPOU->Value +         // EDRPOU
               ";" + dmBase->FIRMSCOMPANY_NAME->Value +   // COMPANY NAME
               ";" + IntToStr(dmBase->FIRMSIDFIZ->Value) +// FIZ or URE
               ";" + IntToStr(dmBase->PRODLICENZE->Value)+// Licenze type
               ";" + "SERIAL" +";";                       // Serial Key

    dmBase->PRODUSER_KEY->Value = KeyGen::MakeKey(s,e,n);
    dmBase->PRODUSER_KEY->SaveToFile(dmBase->PRODKEY_NAME->Value);
    // = DecryptKey(dmBase->PRODUSER_KEY->Value,d,n);
    //String s = temp.EDRPOU;
    //if (s != dmBase->FIRMSEDRPOU->Value)
    //  throw "Error key";
    dmBase->PROD->Post();
  }
  else dmBase->PROD->Cancel();
  delete frmPayProduct;
    
}
//---------------------------------------------------------------------------
void __fastcall TdmMain::aDillersExecute(TObject *Sender)
{
  //frDillers:=ShowForm(TfrDillers,'Диллеры',ftModal) as TfrDillers;
  //frDillers.Free;

}
//---------------------------------------------------------------------------
