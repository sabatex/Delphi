//---------------------------------------------------------------------------

#ifndef default_aboutH
#define default_aboutH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ExtCtrls.hpp>
#include <Graphics.hpp>
#include "default_splash.h"
//---------------------------------------------------------------------------
class TfrmAbout_def : public TfrmSplash_def
{
__published:	// IDE-managed Components
        TPanel *Panel2;
        TLabel *LCopyrigth1;
        TLabel *LCopyrigth2;
        TLabel *RegistrationOn;
        TLabel *RegistrationNumber;
        TLabel *RegistrationLicenzeCount;
        TLabel *Label4;
        TLabel *LHTMLAdress;
        TLabel *LEmailAdress;
        TBitBtn *btOk;
        void __fastcall btOkClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfrmAbout_def(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmAbout_def *frmAbout_def;
//---------------------------------------------------------------------------
#endif
