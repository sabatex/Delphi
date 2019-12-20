//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

//---------------------------------------------------------------------------
USEFORM("main.cpp", frmMain);
USEFORM("personal.cpp", frmPersonal);
USEFORM("order.cpp", frmOrder);
USEFORM("operations.cpp", frmOperations);
USEFORM("operation_type.cpp", frmOperationType);
USEFORM("..\..\Repository\NTICS_def_Project\source\default_splash.cpp", frmSplash_def);
USEFORM("..\..\Repository\NTICS_def_Project\source\default_about.cpp", frmAbout_def);
USEFORM("..\..\Repository\NTICS_def_Project\source\default_frGrid.cpp", frCustomGrid); /* TFrame: File Type */
USEFORM("..\..\Repository\NTICS_def_Project\source\default_firms.cpp", frmFirms_def);
USEFORM("..\..\Repository\NTICS_def_Project\source\default_dm_main.cpp", dmMain_def); /* TDataModule: File Type */
USEFORM("..\..\Repository\NTICS_def_Project\source\default_dm_base.cpp", dmBase_def); /* TDataModule: File Type */
USEFORM("dm_main.cpp", dmMain); /* TDataModule: File Type */
USEFORM("dm_base.cpp", dmBase); /* TDataModule: File Type */
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
