//---------------------------------------------------------------------------

#ifndef FirmEditH
#define FirmEditH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <DB.hpp>
#include <DBCtrls.hpp>
#include <ExtCtrls.hpp>
#include <Mask.hpp>
//---------------------------------------------------------------------------
class TfrmFirmEdit : public TForm
{
__published:	// IDE-managed Components
        TLabel *Label1;
        TLabel *Label2;
        TLabel *Label3;
        TLabel *Label4;
        TLabel *Label5;
        TDBEdit *DBEdit1;
        TDBEdit *DBEdit2;
        TDBEdit *DBEdit3;
        TDBEdit *DBEdit4;
        TDBEdit *DBEdit5;
        TDBRadioGroup *DBRadioGroup1;
        TButton *Button1;
        TButton *Button2;
        TDataSource *DataSource;
private:	// User declarations
public:		// User declarations
        __fastcall TfrmFirmEdit(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmFirmEdit *frmFirmEdit;
//---------------------------------------------------------------------------
#endif
