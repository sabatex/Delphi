//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

//---------------------------------------------------------------------------
USEFORM("ProductList.cpp", frmProductList);
USEFORM("NewProduct.cpp", frmNewProduct);
USEFORM("PayProduct.cpp", frmPayProduct);
USEFORM("dm_main.cpp", dmMain); /* TDataModule: File Type */
USEFORM("dm_base.cpp", dmBase); /* TDataModule: File Type */
USEFORM("main.cpp", frmMain);
USEFORM("..\CommonForms\default_dm_main.cpp", dmMain_def); /* TDataModule: File Type */
USEFORM("..\CommonForms\default_dm_base.cpp", dmBase_def); /* TDataModule: File Type */
USEFORM("..\CommonForms\default_firms.cpp", frmFirms_def);
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
        try
        {
                 Application->Initialize();
                 Application->CreateForm(__classid(TdmMain), &dmMain);
     Application->CreateForm(__classid(TdmBase), &dmBase);
     Application->CreateForm(__classid(TfrmMain), &frmMain);
     Application->Run();
          
        }
        catch (Exception &exception)
        {
                 Application->ShowException(&exception);
        }
        catch (...)
        {
                 try
                 {
                         throw Exception("");
                 }
                 catch (Exception &exception)
                 {
                         Application->ShowException(&exception);
                 }
        }
        return 0;
}
//---------------------------------------------------------------------------
