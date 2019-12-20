//---------------------------------------------------------------------------

#ifndef orderH
#define orderH
//---------------------------------------------------------------------------
#include <systobj.h>
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include "default_frGrid.h"
//---------------------------------------------------------------------------
class TfrmOrder : public TForm
{
__published:	// IDE-managed Components
        TPanel *Panel2;
        TfrCustomGrid *frCustomGrid1;
        TSplitter *Splitter1;
        TPanel *Panel3;
        TfrCustomGrid *frCustomGrid2;
        void __fastcall frCustomGrid2DBGridEhKeyPress(TObject *Sender,
          char &Key);
private:	// User declarations
public:		// User declarations
        __fastcall TfrmOrder(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmOrder *frmOrder;
//---------------------------------------------------------------------------
#endif
