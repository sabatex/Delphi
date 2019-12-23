//---------------------------------------------------------------------------

#ifndef PayProductH
#define PayProductH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "DBCtrlsEh.hpp"
#include "DBLookupEh.hpp"
#include <DB.hpp>
#include <Dialogs.hpp>
#include <Mask.hpp>
//---------------------------------------------------------------------------
class TfrmPayProduct : public TForm
{
__published:	// IDE-managed Components
        TLabel *Label1;
        TLabel *Label2;
        TDBLookupComboboxEh *DBLookupComboboxEh1;
        TDBDateTimeEditEh *DBDateTimeEditEh1;
        TButton *Button1;
        TButton *Button2;
        TDBNumberEditEh *DBNumberEditEh1;
        TDBEditEh *DBEditEh1;
        TDataSource *dsPROD;
        TDataSource *dsFIRMS;
        TSaveDialog *SaveDialog1;
        void __fastcall DBEditEh1EditButtons0Click(TObject *Sender,
          bool &Handled);
private:	// User declarations
public:		// User declarations
        __fastcall TfrmPayProduct(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmPayProduct *frmPayProduct;
//---------------------------------------------------------------------------
#endif
