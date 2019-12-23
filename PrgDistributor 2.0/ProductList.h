//---------------------------------------------------------------------------

#ifndef ProductListH
#define ProductListH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "fcdbtreeview.hpp"
#include <DB.hpp>
#include <Menus.hpp>
//---------------------------------------------------------------------------
class TfrmProductList : public TForm
{
__published:	// IDE-managed Components
        TPopupMenu *PopupMenu1;
        TMenuItem *N1;
        TMenuItem *N2;
        TMenuItem *N3;
        TMenuItem *N4;
        TMenuItem *N5;
        TMenuItem *N6;
        TDataSource *dsPROGRAMM_PRODUCT;
        TDataSource *dsVERSION_PRODUCTS;
        TfcDBTreeView *fcDBTreeView1;
private:	// User declarations
public:		// User declarations
        __fastcall TfrmProductList(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmProductList *frmProductList;
//---------------------------------------------------------------------------
#endif
