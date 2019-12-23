//---------------------------------------------------------------------------

#ifndef dm_mainOldH
#define dm_mainOldH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ActnList.hpp>

//---------------------------------------------------------------------------
class TdmMain : public TDataModule
{
__published:	// IDE-managed Components
        TActionList *ActionListMain;
        TAction *aNewFirm;
        TAction *aDeleteFirm;
        TAction *aShowProducts;
        TAction *aShowFirms;
        TAction *aAddProgramm;
        TAction *aNewVersionWithNewKey;
        TAction *aNewVersionWithOldKey;
        TAction *aDeleteVersion;
        TAction *aEditCurrentVersion;
        TAction *aPayProgramm;
        TAction *aDillers;
        void __fastcall aNewFirmExecute(TObject *Sender);
        void __fastcall aDeleteFirmExecute(TObject *Sender);
        void __fastcall aShowProductsExecute(TObject *Sender);
        void __fastcall aShowFirmsExecute(TObject *Sender);
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
