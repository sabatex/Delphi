//---------------------------------------------------------------------------

#ifndef optionsH
#define optionsH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "DBGridEh.hpp"
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include <Grids.hpp>
#include "Halcn6DB.hpp"
#include <DB.hpp>
//---------------------------------------------------------------------------
class Tfrm_options : public TForm
{
__published:	// IDE-managed Components
    TPageControl *PageControl1;
    TTabSheet *TabSheet1;
    TSpeedButton *btOK;
    TLabel *Label16;
    TLabel *Label1;
    TLabel *Label4;
    TEdit *FEDRPOU;
    TButton *btClose;
    TGroupBox *GroupBox1;
    TLabel *Label2;
    TSpeedButton *sbPriorYear;
    TSpeedButton *sbNextYear;
    TLabel *Label3;
    TSpeedButton *sbPriorKvartal;
    TSpeedButton *sbNextKvartal;
    TEdit *Year;
    TEdit *Kvartal;
    TGroupBox *GroupBox2;
    TLabel *Label19;
    TLabel *Label18;
    TLabel *Label20;
    TEdit *DirName;
    TEdit *DirCod;
    TEdit *DirTell;
    TGroupBox *GroupBox3;
    TLabel *Label5;
    TLabel *Label6;
    TLabel *Label7;
    TEdit *ShiefName;
    TEdit *ShiefCod;
    TEdit *ShiefTell;
    TGroupBox *GroupBox4;
    TLabel *Label25;
    TLabel *Label37;
    TLabel *Label38;
    TLabel *Label17;
    TEdit *EDRPOUPOD;
    TEdit *PODNAME;
    TEdit *PODCOD;
    TEdit *PODOBL;
    TEdit *VFO;
    TEdit *edFIRMS;
    TTabSheet *TabSheet2;
    TDBGridEh *DBGridEh1;
    TTabSheet *TabSheet3;
    TDBGridEh *DBGridEh2;
    THalcyonDataSet *LGT;
    TSmallintField *LGTKOD;
    TStringField *LGTNAME;
    TDataSource *dsLGT;
    THalcyonDataSet *OZN;
    TDataSource *dsOZN;
    void __fastcall btOKClick(TObject *Sender);
    void __fastcall sbPriorYearClick(TObject *Sender);
    void __fastcall sbNextYearClick(TObject *Sender);
    void __fastcall sbPriorKvartalClick(TObject *Sender);
    void __fastcall sbNextKvartalClick(TObject *Sender);
    void __fastcall btCloseClick(TObject *Sender);
    void __fastcall FormShow(TObject *Sender);
private:	// User declarations
public:		// User declarations
    __fastcall Tfrm_options(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE Tfrm_options *frm_options;
//---------------------------------------------------------------------------
#endif
