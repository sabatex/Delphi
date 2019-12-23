//---------------------------------------------------------------------------

#ifndef NewProductH
#define NewProductH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "DBCtrlsEh.hpp"
#include <DB.hpp>
#include <DBCtrls.hpp>
#include <Dialogs.hpp>
#include <Mask.hpp>
//---------------------------------------------------------------------------
class TfrmNewProduct : public TForm
{
__published:	// IDE-managed Components
        TLabel *Label1;
        TLabel *Label2;
        TLabel *Label3;
        TDBEdit *Product;
        TDBEdit *DBEdit2;
        TButton *Button1;
        TButton *Button2;
        TDBEditEh *SourcePath;
        TSaveDialog *SaveDialog1;
        TDataSource *dsPROGRAMM_PRODUCT;
        TDataSource *dsVERSION_PRODUCTS;
        void __fastcall Button2Click(TObject *Sender);
        void __fastcall Button1Click(TObject *Sender);
        void __fastcall SourcePathEditButtons0Click(TObject *Sender,
          bool &Handled);
private:	// User declarations
public:		// User declarations
        __fastcall TfrmNewProduct(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmNewProduct *frmNewProduct;
//---------------------------------------------------------------------------
#endif
