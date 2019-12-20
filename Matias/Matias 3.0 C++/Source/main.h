//---------------------------------------------------------------------------

#ifndef mainH
#define mainH
//---------------------------------------------------------------------------
#include <systobj.h>
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "CSPIN.h"
#include <ActnList.hpp>
#include <ComCtrls.hpp>
#include <ExtCtrls.hpp>
#include <Menus.hpp>
#include <StdActns.hpp>


//---------------------------------------------------------------------------
class TfrmMain : public TForm
{
__published:	// IDE-managed Components
        TStatusBar *StatusBar1;
        TPanel *pFirms;
        TLabel *Label1;
        TLabel *Label2;
        TLabel *Label3;
        TComboBox *M_MONTH;
        TComboBox *cbFirms;
        TCheckBox *OldWokers;
        TCSpinEdit *M_YEAR;
        void __fastcall cbFirmsClick(TObject *Sender);
        void __fastcall FormDestroy(TObject *Sender);
    void __fastcall FormShow(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfrmMain(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmMain *frmMain;
//---------------------------------------------------------------------------
#endif
