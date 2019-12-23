//---------------------------------------------------------------------------


#ifndef default_frGridH
#define default_frGridH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "DBGridEh.hpp"
#include "PrnDbgeh.hpp"
#include <Buttons.hpp>
#include <DBCtrls.hpp>
#include <ExtCtrls.hpp>
#include <Grids.hpp>
#include "FIBDataSet.hpp"
#include "pFIBDataSet.hpp"
#include <DB.hpp>
//---------------------------------------------------------------------------
class TfrCustomGrid : public TFrame
{
__published:	// IDE-managed Components
        TPrintDBGridEh *PrintDBGridEh;
        TPanel *Panel1;
        TSpeedButton *SpeedButton1;
        TDBNavigator *DBNavigator1;
        TDBGridEh *DBGridEh;
        void __fastcall DBGridEhSortMarkingChanged(TObject *Sender);
        void __fastcall SpeedButton1Click(TObject *Sender);
private:// User declarations
        TNotifyEvent FFormOnShow;
        void __fastcall FormShow(TObject *Sender);
public:	// User declarations
        __fastcall TfrCustomGrid(TComponent* Owner);
        __fastcall ~TfrCustomGrid();
        virtual void __fastcall SetRO();
};
//---------------------------------------------------------------------------
extern PACKAGE TfrCustomGrid *frCustomGrid;
//---------------------------------------------------------------------------
#endif
