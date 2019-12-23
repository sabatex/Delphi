//---------------------------------------------------------------------------

#ifndef periodic_editH
#define periodic_editH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "DBGridEh.hpp"
#include "FIBDataSet.hpp"
#include "pFIBDataSet.hpp"
#include <DB.hpp>
#include <ExtCtrls.hpp>
#include <Grids.hpp>
//---------------------------------------------------------------------------
class Tfrm_periodic : public TForm
{
__published:	// IDE-managed Components
  TPanel *Panel1;
  TDBGridEh *DBGridEh1;
  TpFIBDataSet *periodic_date;
  TDataSource *DataSource1;
  TVariantField *periodic_datePeriodic_field;
private:	// User declarations
  int FParent;
public:		// User declarations
  __fastcall Tfrm_periodic(TComponent* Owner);
  void __fastcall SetParent(int Parent);
  int __fastcall GetParent(){return FParent;};
};
//---------------------------------------------------------------------------
extern PACKAGE Tfrm_periodic *frm_periodic;
//---------------------------------------------------------------------------
#endif
