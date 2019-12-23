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
#include "FIBQuery.hpp"
#include "pFIBDatabase.hpp"
#include "pFIBQuery.hpp"
#include "pFIBStoredProc.hpp"
#include "FIBDataSet.hpp"
#include "pFIBDataSet.hpp"
#include <DB.hpp>
//---------------------------------------------------------------------------
class TdmBase : public TdmBase_def
{
__published:	// IDE-managed Components
    TpFIBDataSet *PROGRAMM_PRODUCT;
    TFIBIntegerField *PROGRAMM_PRODUCTID;
    TFIBStringField *PROGRAMM_PRODUCTPRODUCT_NAME;
    TFIBIntegerField *PROGRAMM_PRODUCTCOUNT_PROD;
    TpFIBDataSet *VERSION_PRODUCTS;
    TFIBIntegerField *VERSION_PRODUCTSID;
    TFIBStringField *VERSION_PRODUCTSVERSION_PRG;
    TBlobField *VERSION_PRODUCTSKEY_E;
    TBlobField *VERSION_PRODUCTSKEY_D;
    TBlobField *VERSION_PRODUCTSKEY_N;
    TFIBIntegerField *VERSION_PRODUCTSPROGRAMM_PRODUCTS_ID;
    TFIBStringField *VERSION_PRODUCTSSOURCE_PATH;
    TFIBIntegerField *VERSION_PRODUCTSCOUNT_PROD;
    TStringField *VERSION_PRODUCTSPRODUCT_NAME;
    TDataSource *dsPROGRAMM_PRODUCT;
    TpFIBDataSet *FIRMS;
    TFIBIntegerField *FIRMSID;
    TFIBIntegerField *FIRMSIDFIZ;
    TFIBStringField *FIRMSEDRPOU;
    TFIBStringField *FIRMSWUSER;
    TFIBStringField *FIRMSCOMPANY_ADDRESS;
    TFIBStringField *FIRMSCOMPANY_NAME;
    TFIBStringField *FIRMSEMAIL;
    TpFIBDataSet *PROD;
    TFIBIntegerField *PRODID;
    TFIBIntegerField *PRODFIRMS_ID;
    TFIBIntegerField *PRODPRODUCT_ID;
    TFIBIntegerField *PRODVERSION_ID;
    TDateField *PRODDATE_PAY;
    TFIBIntegerField *PRODLICENZE;
    TBlobField *PRODUSER_KEY;
    TFIBStringField *PRODKEY_NAME;
        TDataSource *dsVERSION_PRODUCTS;
    void __fastcall VERSION_PRODUCTSAfterInsert(TDataSet *DataSet);
private:	// User declarations
public:		// User declarations
    __fastcall TdmBase(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TdmBase *dmBase;
//---------------------------------------------------------------------------
#endif
