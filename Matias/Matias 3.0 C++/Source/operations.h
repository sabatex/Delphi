//---------------------------------------------------------------------------

#ifndef operationsH
#define operationsH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <DB.hpp>
#include "DBGridEh.hpp"
#include "JvMemoryDataset.hpp"
#include <ExtCtrls.hpp>
#include <Grids.hpp>
#include <Buttons.hpp>
#include "default_frGrid.h"
//---------------------------------------------------------------------------
class TfrmOperations : public TForm
{
__published:	// IDE-managed Components
        TfrCustomGrid *frCustomGrid1;
        TDataSource *DataSource1;
        TPanel *CalcPanel;
        TJvMemoryData *tOperations;
        TIntegerField *tOperationsID;
        TStringField *tOperationsOPERATION_NAME;
        TFloatField *tOperationsCASHE;
        TFloatField *tOperationsTIMENORM;
        TDataSource *dstOperations;
        TDBGridEh *DBGridEh;
        TPanel *Panel2;
        TSplitter *Splitter1;
        TCheckBox *cbCalc;
        TEdit *eRasc;
        TLabel *Label1;
        TLabel *Label2;
        TEdit *eNorm;
        TButton *btRasch;
        TButton *btPerenos;
        TButton *Button1;
        void __fastcall frCustomGrid1DBGridEhKeyDown(TObject *Sender,
          WORD &Key, TShiftState Shift);
        void __fastcall cbCalcClick(TObject *Sender);
        void __fastcall FormShow(TObject *Sender);
        void __fastcall btRaschClick(TObject *Sender);
        void __fastcall Button1Click(TObject *Sender);
        void __fastcall btPerenosClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfrmOperations(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmOperations *frmOperations;
//---------------------------------------------------------------------------
#endif
