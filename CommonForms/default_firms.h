//---------------------------------------------------------------------------

#ifndef default_firmsH
#define default_firmsH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <DB.hpp>
#include "JvExComCtrls.hpp"
#include <ComCtrls.hpp>
#include <ExtCtrls.hpp>
#include "DBGridEh.hpp"
#include <DBCtrls.hpp>
#include <Grids.hpp>
#include <Mask.hpp>
#include "FIBDatabase.hpp"
#include "FIBDataSet.hpp"
#include "pFIBDatabase.hpp"
#include "pFIBDataSet.hpp"
//---------------------------------------------------------------------------
class TfrmFirms_def : public TForm
{
__published:	// IDE-managed Components
        TDataSource *DataSource1;
    TPanel *Panel1;
    TPageControl *PageControl1;
    TTabSheet *TabSheet1;
    TTabSheet *TabSheet2;
    TDBNavigator *DBNavigator1;
    TDBGridEh *DBGridEh1;
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
    TDataSource *DataSource;
    TpFIBTransaction *taFirms;
    TpFIBDataSet *Firms;
    TFIBIntegerField *FirmsID;
    TFIBIntegerField *FirmsIDFIZ;
    TFIBStringField *FirmsEDRPOU;
    TFIBStringField *FirmsWUSER;
    TFIBStringField *FirmsCOMPANY_ADDRESS;
    TFIBStringField *FirmsCOMPANY_NAME;
    TFIBStringField *FirmsEMAIL;
private:	// User declarations
public:		// User declarations
        __fastcall TfrmFirms_def(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmFirms_def *frmFirms_def;
//---------------------------------------------------------------------------
#endif
