//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
//---------------------------------------------------------------------------
USEFORM("..\Common Forms\default_splash.cpp", frmSplash_def);
USEFORM("SOURCE\mainc.cpp", frmmain_new);
USEFORM("..\Common Forms\default_about.cpp", frmAbout_def);
USEFORM("..\Common Forms\default_dm_base.cpp", dmBase_def); /* TDataModule: File Type */
USEFORM("..\Common Forms\default_dm_main.cpp", dmMain_def); /* TDataModule: File Type */
USEFORM("SOURCE\dm_main.cpp", dmMain); /* TDataModule: File Type */
USEFORM("SOURCE\dm_base.cpp", dmBase); /* TDataModule: File Type */
USEFORM("..\Common Forms\default_firms.cpp", frmFirms_def);
USEFORM("SOURCE\wokers.cpp", frm_wokers);
USEFORM("SOURCE\form_1df.cpp", frm_1df);
USEFORM("SOURCE\options.cpp", frm_options);
USEFORM("SOURCE\config_1C60.cpp", frm_config1c60);
USEFORM("SOURCE\wizard_save_1DF.cpp", frm_wizard_save_1df);
USEFORM("..\Common Forms\periodic_edit.cpp", frm_periodic);
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
        try
        {
                 Application->Initialize();
                 Application->Title = "Бухгалтерська звітність";
                 Application->CreateForm(__classid(TdmBase), &dmBase);
     Application->CreateForm(__classid(TdmMain), &dmMain);
     Application->CreateForm(__classid(Tfrmmain_new), &frmmain_new);
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

