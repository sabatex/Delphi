//---------------------------------------------------------------------------

#ifndef maincH
#define maincH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Menus.hpp>
#include <ActnList.hpp>
//---------------------------------------------------------------------------
class Tfrmmain_new : public TForm
{
__published:	// IDE-managed Components
        TMainMenu *MainMenu1;
        TMenuItem *N6;
        TMenuItem *N7;
        TMenuItem *N1603;
        TMenuItem *N1773;
        TMenuItem *N81;
        TMenuItem *N9;
        TMenuItem *N22;
        TMenuItem *N10;
        TMenuItem *N3;
        TMenuItem *N83;
        TMenuItem *N12;
        TMenuItem *N14;
        TMenuItem *N84;
        TMenuItem *N4;
        TMenuItem *N13;
        TMenuItem *N82;
        TMenuItem *N11;
        TMenuItem *N1602;
        TMenuItem *N1772;
        TMenuItem *N5;
        TMenuItem *N15;
        TMenuItem *N20;
        TMenuItem *N16;
        TMenuItem *N19;
        TMenuItem *N18;
        TMenuItem *N17;
        TMenuItem *N1;
        TMenuItem *N2;
        TMenuItem *HelponHelp2;
        TMenuItem *N8;
    TActionList *alMain;
    void __fastcall FormShow(TObject *Sender);
    void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
private:	// User declarations
public:		// User declarations
        __fastcall Tfrmmain_new(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE Tfrmmain_new *frmmain_new;
//---------------------------------------------------------------------------
#endif
