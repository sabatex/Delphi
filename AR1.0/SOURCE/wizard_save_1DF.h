//---------------------------------------------------------------------------

#ifndef wizard_save_1DFH
#define wizard_save_1DFH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "JvComponent.hpp"
#include "JvExControls.hpp"
#include "JvWizard.hpp"
//---------------------------------------------------------------------------
class Tfrm_wizard_save_1df : public TForm
{
__published:	// IDE-managed Components
    TJvWizard *JvWizard1;
    TJvWizardWelcomePage *JvWizardWelcomePage1;
    TJvWizardInteriorPage *JvWizardInteriorPage1;
private:	// User declarations
public:		// User declarations
    __fastcall Tfrm_wizard_save_1df(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE Tfrm_wizard_save_1df *frm_wizard_save_1df;
//---------------------------------------------------------------------------
#endif
