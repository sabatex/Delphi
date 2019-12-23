//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include <fstream.h>
#include "NewProduct.h"
#include "dm_base.h"

//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "DBCtrlsEh"
#pragma resource "*.dfm"
TfrmNewProduct *frmNewProduct;
//---------------------------------------------------------------------------
__fastcall TfrmNewProduct::TfrmNewProduct(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TfrmNewProduct::Button2Click(TObject *Sender)
{
  dmBase->VERSION_PRODUCTS->Cancel();
  dmBase->PROGRAMM_PRODUCT->Cancel();
  Close();
}
//---------------------------------------------------------------------------
void __fastcall TfrmNewProduct::Button1Click(TObject *Sender)
{
//  f:TextFile;
  if (dmBase->PROGRAMM_PRODUCT->State == dsInsert | dmBase->PROGRAMM_PRODUCT->State == dsEdit)
    dmBase->PROGRAMM_PRODUCT->Post();
  if (dmBase->VERSION_PRODUCTS->State == dsInsert | dmBase->VERSION_PRODUCTS->State == dsEdit)
    dmBase->VERSION_PRODUCTS->Post();
  if (dmBase->VERSION_PRODUCTSSOURCE_PATH->Value != "")
  {
    char* s = dmBase->VERSION_PRODUCTSSOURCE_PATH->Value.c_str();
    ofstream f(s);
    if (f)
    {
      f << "unit enKey;" << endl;
      f << "interface" << endl;
      f << "const" << endl;
      f << "  dkey:string = ('" << dmBase->VERSION_PRODUCTSKEY_D->Value.c_str() << "');" << endl;
      f << "  nkey:string = ('" << dmBase->VERSION_PRODUCTSKEY_N->Value.c_str() << "');" << endl;
      f << endl << "implementation" << endl << "end.";
    }
    f.close();
  }
  Close();
}
//---------------------------------------------------------------------------
void __fastcall TfrmNewProduct::SourcePathEditButtons0Click(
      TObject *Sender, bool &Handled)
{
  if (SaveDialog1->Execute())
    SourcePath->Text = SaveDialog1->FileName;

}
//---------------------------------------------------------------------------
