//---------------------------------------------------------------------------

#ifndef dm_baseH
#define dm_baseH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "default_dm_base.h"
#include "FIBDatabase.hpp"
#include "pFIBDatabase.hpp"
#include "Halcn6DB.hpp"
#include <DB.hpp>
//---------------------------------------------------------------------------
class TdmBase : public TdmBase_def
{
__published:	// IDE-managed Components
        THalcyonDataSet *DA;
        TIntegerField *DANP;
        TSmallintField *DAPERIOD;
        TSmallintField *DARIK;
        TStringField *DAKOD;
        TSmallintField *DATYP;
        TStringField *DATIN;
        TFloatField *DAS_NAR;
        TFloatField *DAS_DOX;
        TFloatField *DAS_TAXN;
        TFloatField *DAS_TAXP;
        TSmallintField *DAOZN_DOX;
        TSmallintField *DAOZN_PILG;
        TSmallintField *DAOZNAKA;
        TStringField *DAWokerName;
        TStringField *DATINL;
        TDateField *DAD_PRIYN;
        TDateField *DAD_ZVILN;
        TDataSource *dsDA;
        THalcyonDataSet *Wokers;
        TStringField *WokersEDRPOU;
        TStringField *WokersNAME;
        TDataSource *dsWokers;
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
        TDataSource *dsListTables;
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
        TDataSource *dsOptions;
        TCreateHalcyonDataSet *CreateDA;
private:	// User declarations
public:		// User declarations
        __fastcall TdmBase(TComponent* Owner);
        int __fastcall GetIndexPeriodicDate();
};
//---------------------------------------------------------------------------
extern PACKAGE TdmBase *dmBase;
//---------------------------------------------------------------------------
#endif
