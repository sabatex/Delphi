//---------------------------------------------------------------------------

#ifndef config_1C60H
#define config_1C60H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <DB.hpp>
#include <ExtCtrls.hpp>
#include "Halcn6DB.hpp"
#include "DBGridEh.hpp"
#include <DBCtrls.hpp>
#include <Grids.hpp>
//---------------------------------------------------------------------------
class Tfrm_config1c60 : public TForm
{
__published:	// IDE-managed Components
    TPanel *Panel1;
    TSplitter *Splitter1;
    TPanel *Panel2;
    THalcyonDataSet *ListTables;
    TSmallintField *ListTablesID;
    TStringField *ListTablesTABLENAME;
    TStringField *ListTablesFIRSTNUM;
    TStringField *ListTablesLASTNUM;
    TStringField *ListTablesIDNUM;
    TStringField *ListTablesINWOKER;
    TStringField *ListTablesOUTWOKER;
    TStringField *ListTablesWOKERNAME;
    TSmallintField *ListTablesVID;
    THalcyonDataSet *Options;
    TSmallintField *OptionsID;
    TSmallintField *OptionsCOD;
    TStringField *OptionsNAMEPOS;
    TStringField *OptionsNARAX;
    TStringField *OptionsPODAT;
    TStringField *OptionsPILGA;
    TStringField *OptionsNEOPL;
    TStringField *OptionsVIPLAT;
    TStringField *OptionsVIPPODAT;
    TDataSource *dsListTables;
    TDataSource *dsOptions;
    TPanel *Panel3;
    TDBNavigator *DBNavigator1;
    TLabel *Label3;
    TDBGridEh *DBGridEh;
    TPanel *Panel4;
    TDBNavigator *DBNavigator2;
    TLabel *Label1;
    TDBGridEh *DBGridEh1;
    void __fastcall ListTablesAfterScroll(TDataSet *DataSet);
    void __fastcall ListTablesNewRecord(TDataSet *DataSet);
private:	// User declarations
    String FFilter;
    void __fastcall SetFilter1C(const String Value);
public:		// User declarations
    __fastcall Tfrm_config1c60(TComponent* Owner);
    __property String Filter1C = {read=FFilter, write=SetFilter1C};
};
//---------------------------------------------------------------------------
extern PACKAGE Tfrm_config1c60 *frm_config1c60;
//---------------------------------------------------------------------------
#endif
