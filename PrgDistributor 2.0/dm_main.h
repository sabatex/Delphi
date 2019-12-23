//---------------------------------------------------------------------------

#ifndef dm_mainH
#define dm_mainH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "default_dm_main.h"
#include <ActnList.hpp>
#include <ImgList.hpp>
#include <StdActns.hpp>
#include <Menus.hpp>
//---------------------------------------------------------------------------
class TdmMain : public TdmMain_def
{
__published:	// IDE-managed Components
    TActionList *ActionListMain;
    TAction *aAddProgramm;
    TAction *aNewVersionWithNewKey;
    TAction *aNewVersionWithOldKey;
    TAction *aDeleteVersion;
    TAction *aEditCurrentVersion;
    TAction *aPayProgramm;
    TAction *aDillers;
        TAction *aProducts;
        TMenuItem *ShowProducts1;
    void __fastcall aShowProductsExecute(TObject *Sender);
    void __fastcall aAddProgrammExecute(TObject *Sender);
    void __fastcall aNewVersionWithNewKeyExecute(TObject *Sender);
    void __fastcall aNewVersionWithOldKeyExecute(TObject *Sender);
    void __fastcall aDeleteVersionExecute(TObject *Sender);
    void __fastcall aEditCurrentVersionExecute(TObject *Sender);
    void __fastcall aPayProgrammExecute(TObject *Sender);
    void __fastcall aDillersExecute(TObject *Sender);
private:	// User declarations
public:		// User declarations
    __fastcall TdmMain(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TdmMain *dmMain;
//---------------------------------------------------------------------------
#endif
