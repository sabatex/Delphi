//---------------------------------------------------------------------------

#ifndef form_1dfH
#define form_1dfH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "Halcn6DB.hpp"
#include <DB.hpp>
#include <Buttons.hpp>
#include <ExtCtrls.hpp>
#include "DBGridEh.hpp"
#include <DBCtrls.hpp>
#include <Grids.hpp>
#include "FIBDataSet.hpp"
#include "pFIBDataSet.hpp"
#include <ComCtrls.hpp>
#include "FIBQuery.hpp"
#include "pFIBQuery.hpp"
//---------------------------------------------------------------------------
class Tfrm_1df : public TForm
{
__published:	// IDE-managed Components
    TDataSource *dsDA;
    TPanel *Panel1;
    TDBNavigator *DBNavigator1;
    TDBGridEh *DBGridEh;
    TpFIBDataSet *DA;
  TTreeView *TreePeriod;
  TpFIBDataSet *Tree;
  TSplitter *Splitter1;
  TStatusBar *StatusBar;
    void __fastcall sbPriorYearClick(TObject *Sender);
    void __fastcall sbNextYearClick(TObject *Sender);
    void __fastcall sbPriorKvartalClick(TObject *Sender);
    void __fastcall sbNextKvartalClick(TObject *Sender);
    void __fastcall FormDestroy(TObject *Sender);
    void __fastcall DAAfterInsert(TDataSet *DataSet);
    void __fastcall DBGridEhEditButtonClick(TObject *Sender);
    void __fastcall TreePeriodDblClick(TObject *Sender);
private:	// User declarations
    int FYear;
    int FPeriod;
    void __fastcall SetYear(int Value);
    void __fastcall SetPeriod(int Value);
    void __fastcall SetFilter();
    TStatusPanel* __fastcall PanelPeriod();
public:		// User declarations
    __fastcall Tfrm_1df(TComponent* Owner);
    __property int CurrentYear = {read=FYear,write=SetYear};
    __property int CurrentPeriod = {read=FPeriod,write=SetPeriod};
};
//---------------------------------------------------------------------------
extern PACKAGE Tfrm_1df *frm_1df;
//---------------------------------------------------------------------------
#endif
