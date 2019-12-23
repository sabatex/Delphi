//---------------------------------------------------------------------------

#ifndef default_dm_baseH
#define default_dm_baseH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "FIBDatabase.hpp"
#include "pFIBDatabase.hpp"

//---------------------------------------------------------------------------
class TdmBase_def : public TDataModule
{
__published:	// IDE-managed Components
    TpFIBDatabase *mainDatabase;
    TpFIBTransaction *mainTransaction;
private:	// User declarations
public:		// User declarations
        __fastcall TdmBase_def(TComponent* Owner);
};
extern PACKAGE TdmBase_def *dmBase_def;
//---------------------------------------------------------------------------
#endif
