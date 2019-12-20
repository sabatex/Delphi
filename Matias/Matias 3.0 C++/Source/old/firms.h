//---------------------------------------------------------------------------

#ifndef firmsH
#define firmsH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <DB.hpp>
#include "default_frGrid.h"
//---------------------------------------------------------------------------
class TfrmFirms : public TForm
{
__published:	// IDE-managed Components
        TfrCustomGrid *frCustomGrid1;
        TDataSource *dsFirms;
        void __fastcall FormDestroy(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfrmFirms(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmFirms *frmFirms;
//---------------------------------------------------------------------------
#endif
