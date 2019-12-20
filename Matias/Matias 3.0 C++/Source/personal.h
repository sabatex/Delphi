//---------------------------------------------------------------------------

#ifndef personalH
#define personalH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "default_frGrid.h"
//---------------------------------------------------------------------------
class TfrmPersonal : public TForm
{
__published:	// IDE-managed Components
        TfrCustomGrid *frCustomGrid1;
private:	// User declarations
public:		// User declarations
        __fastcall TfrmPersonal(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmPersonal *frmPersonal;
//---------------------------------------------------------------------------
#endif
