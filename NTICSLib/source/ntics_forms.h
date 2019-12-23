//---------------------------------------------------------------------------
#ifndef ntics_formsH
#define ntics_formsH
#include "ntics_includes.h"
#include "ntics_registration.h"
//---------------------------------------------------------------------------
namespace ntics_forms
{
    enum TFormType { ftNormal, ftMDI, ftModal };
    extern PACKAGE Forms::TForm* __fastcall ShowForm(TMetaClass* ClassForm, AnsiString FormName, TFormType FormType, bool One = true);
    extern PACKAGE void __fastcall CloseChildForms(TForm* MainMDI);
    extern PACKAGE void __fastcall RestoreChildForms(void);
}
#endif