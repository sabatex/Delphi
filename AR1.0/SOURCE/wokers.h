//---------------------------------------------------------------------------

#ifndef wokersH
#define wokersH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "Halcn6DB.hpp"
#include <DB.hpp>
#include "DBGridEh.hpp"
#include <DBCtrls.hpp>
#include <ExtCtrls.hpp>
#include <Grids.hpp>
#include "FIBDataSet.hpp"
#include "pFIBDataSet.hpp"
//---------------------------------------------------------------------------
class Tfrm_wokers : public TForm
{
__published:	// IDE-managed Components
    TDataSource *dsWokers;
    TPanel *Panel1;
    TDBGridEh *DBGridEh;
    TDBNavigator *DBNavigator1;
    TpFIBDataSet *personal;
    void __fastcall WokersEDRPOUValidate(TField *Sender);
  void __fastcall DBGridEhKeyDown(TObject *Sender, WORD &Key,
          TShiftState Shift);
  void __fastcall DBGridEhDblClick(TObject *Sender);
  void __fastcall DBGridEhEditButtonClick(TObject *Sender);
private:	// User declarations
  TDate FCurrentDate;
  void __fastcall SetCurrentDate(TDate CurrentDate);
public:		// User declarations
    __fastcall Tfrm_wokers(TComponent* Owner);
    __property TDate CurrentDate = {read=FCurrentDate,write=SetCurrentDate};
};
//---------------------------------------------------------------------------
extern PACKAGE Tfrm_wokers *frm_wokers;
//---------------------------------------------------------------------------
#endif
