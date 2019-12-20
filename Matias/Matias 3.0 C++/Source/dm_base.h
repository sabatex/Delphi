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
#include "FIBDataSet.hpp"
#include "FIBQuery.hpp"
#include "JvMemoryDataset.hpp"
#include "pFIBDataSet.hpp"
#include "pFIBQuery.hpp"
#include "pFIBStoredProc.hpp"
#include <DB.hpp>
#include <ImgList.hpp>
#include "DBGridEh.hpp"
//---------------------------------------------------------------------------
class TdmBase : public TdmBase_def
{
__published:	// IDE-managed Components
        TDataSource *dsFirms;
        TDataSource *dsOperation;
        TDataSource *dsPersonal;
        TpFIBDataSet *Firms;
        TFIBIntegerField *FirmsID;
        TFIBIntegerField *FirmsIDFIZ;
        TFIBStringField *FirmsEDRPOU;
        TFIBStringField *FirmsWUSER;
        TFIBStringField *FirmsCOMPANY_ADDRESS;
        TFIBStringField *FirmsCOMPANY_NAME;
        TFIBStringField *FirmsEMAIL;
        TStringField *FirmsFIRMNAME;
        TpFIBDataSet *Personal;
        TFIBIntegerField *PersonalID;
        TFIBIntegerField *PersonalPERSONAL_NR;
        TFIBStringField *PersonalPERSONAL_NAME;
        TDateField *PersonalDATE_IN;
        TDateField *PersonalDATE_OUT;
        TFIBIntegerField *PersonalFIRMS_ID;
        TpFIBDataSet *Operation;
        TFIBIntegerField *OperationID;
        TFIBStringField *OperationOPERATION_NAME;
        TFIBFloatField *OperationCASHE;
        TFIBFloatField *OperationTIMENORM;
        TpFIBDataSet *Orders;
        TFIBIntegerField *OrdersID;
        TFIBIntegerField *OrdersPERSONAL_ID;
        TFIBIntegerField *OrdersOPERATION_ID;
        TFIBIntegerField *OrdersORDER_YEAR;
        TFIBIntegerField *OrdersORDER_MONTH;
        TFIBFloatField *OrdersCOUNTS;
        TFIBFloatField *OrdersTOTAL;
        TFIBIntegerField *OrdersOPER_TYPE;
        TStringField *OrdersOPERATION_TYPE;
        TFloatField *OrdersOPERATION_MULT;
        TFIBStringField *OrdersOPERATION_NAME;
        TFIBFloatField *OrdersCASHE;
        TpFIBDataSet *OPERATION_TYPE;
        TFIBIntegerField *OPERATION_TYPEID;
        TFIBStringField *OPERATION_TYPEOP_TYPE;
        TFIBFloatField *OPERATION_TYPETAX;
        TFIBIntegerField *OPERATION_TYPEPARENT;
        TFIBIntegerField *OPERATION_TYPEIS_FOLDER;
        TFIBIntegerField *OPERATION_TYPEPOSITION_ON_REPORT;
        TDataSource *dsOPERATION_TYPE;
        TpFIBTransaction *tsOPERATION_TYPE;
        TpFIBTransaction *tsFirms;
        TpFIBTransaction *tsPersonal;
        TpFIBTransaction *tsOperation;
        TDataSource *dsOrders;
        TpFIBTransaction *tsOrders;
        TpFIBTransaction *taClasificator;
        TpFIBDataSet *dbFolder;
        TFIBIntegerField *dbFolderID;
        TFIBStringField *dbFolderOP_TYPE;
        TFIBFloatField *dbFolderTAX;
        TFIBIntegerField *dbFolderPARENT;
        TFIBIntegerField *dbFolderPOSITION_ON_REPORT;
        TpFIBDataSet *dbClasificator;
        TFIBIntegerField *dbClasificatorID;
        TFIBStringField *dbClasificatorOP_TYPE;
        TFIBFloatField *dbClasificatorTAX;
        TFIBIntegerField *dbClasificatorPARENT;
        TFIBIntegerField *dbClasificatorIS_FOLDER;
        TFIBIntegerField *dbClasificatorPOSITION_ON_REPORT;
        TpFIBStoredProc *CALC_OP_TYPE;
        TDataSource *DataSource1;
        TImageList *ImageList;
        TJvMemoryData *T_REPORT1;
        TIntegerField *T_REPORT1ID;
        TIntegerField *T_REPORT1PARENT;
        TIntegerField *T_REPORT1IS_FOLDER;
        TCurrencyField *T_REPORT1SUMMA;
        TStringField *T_REPORT1OP_TYPE;
        TDataSource *dsTREPORT;
        void __fastcall PersonalAfterInsert(TDataSet *DataSet);
        void __fastcall OrdersAfterInsert(TDataSet *DataSet);
        void __fastcall OrdersAfterPost(TDataSet *DataSet);
        void __fastcall OrdersCOUNTSValidate(TField *Sender);
        void __fastcall FirmsCalcFields(TDataSet *DataSet);
private:	// User declarations
public:		// User declarations
        __fastcall TdmBase(TComponent* Owner);
        void __fastcall CreateReportHeader(int M_YEAR,int M_MONTH);
        void __fastcall OpenDataSet(TDataSet *DataSet);
        void __fastcall PostDataSet(TDataSet *DataSet);
        void __fastcall FRefresh(TDataSet *DataSet);
        String __fastcall FindSortedField(TDBGridEh *Grid);
        void __fastcall SetFilterOrders(int M_YEAR, int M_MONTH,
                                        Boolean M_Filter, String CFirm);
        void __fastcall SetPersonalFilter(int M_YEAR,int M_MONTH,
                                          Boolean M_Filter);

};
//---------------------------------------------------------------------------
extern PACKAGE TdmBase *dmBase;
extern int FYEAR,FMOUNTH;
//---------------------------------------------------------------------------
#endif
