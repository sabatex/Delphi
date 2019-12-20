//---------------------------------------------------------------------------

#ifndef dm_mainH
#define dm_mainH
//---------------------------------------------------------------------------
#include "default_dm_main.h"
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ActnList.hpp>
#include <ImgList.hpp>
#include <Menus.hpp>
#include <StdActns.hpp>

#include "FR_BarC.hpp"
#include "FR_Chart.hpp"
#include "FR_ChBox.hpp"
#include "FR_Class.hpp"
#include "FR_Cross.hpp"
#include "FR_DBSet.hpp"
#include "FR_Desgn.hpp"
#include "FR_DSet.hpp"
#include "FR_E_CSV.hpp"
#include "FR_E_HTM.hpp"
#include "FR_E_RTF.hpp"
#include "FR_E_TXT.hpp"
#include "FR_FIBDB.hpp"
#include "FR_OLE.hpp"
#include "FR_Rich.hpp"
#include "FR_RRect.hpp"
#include "FR_Shape.hpp"
#include "FIBDataSet.hpp"
#include "frOLEExl.hpp"
#include "pFIBDataSet.hpp"
#include <DB.hpp>
#include "FR_PARS.hpp"
#include "JvMemoryDataset.hpp"
//---------------------------------------------------------------------------
class TdmMain : public TdmMain_def
{
__published:	// IDE-managed Components
        TAction *aRefreshAll;
        TMenuItem *N10;
        TMenuItem *N11;
        TAction *aOperation;
        TMenuItem *N12;
        TAction *aClassificator;
        TAction *aWokers;
        TMenuItem *N13;
        TAction *aOrders;
        TMenuItem *N14;
        TMenuItem *N15;
        TfrDesigner *frDesigner;
        TfrReport *frReport;
        TfrHTMExport *frHTMExport;
        TfrRTFExport *frRTFExport;
        TfrCSVExport *frCSVExport;
        TfrTextExport *frTextExport;
        TfrCrossObject *frCrossObject;
        TfrOLEObject *frOLEObject;
        TfrRichObject *frRichObject;
        TfrCheckBoxObject *frCheckBoxObject;
        TfrShapeObject *frShapeObject;
        TfrBarCodeObject *frBarCodeObject;
        TfrChartObject *frChartObject;
        TfrRoundRectObject *frRoundRectObject;
        TfrDBDataSet *frPersonal;
        TfrFIBComponents *frFIBComponents;
        TfrDBDataSet *frT_REPORT1;
        TfrCompositeReport *frCompositeReport;
        TAction *aReport1;
        TAction *aReport2;
        TAction *aReport3;
        TAction *aDesigner;
        TMenuItem *N16;
        TMenuItem *N17;
        TMenuItem *N18;
        TMenuItem *N19;
        TMenuItem *N20;
        TMenuItem *N21;
        TMenuItem *N22;
        TMenuItem *N23;
        TMenuItem *N24;
        TAction *aReport4;
        TMenuItem *N25;
        TfrOLEExcelExport *frOLEExcelExport1;
        TpFIBDataSet *temp_CROSS_FIRMS_CELL;
        TFIBIntegerField *temp_CROSS_FIRMS_CELLID;
        TFIBIntegerField *temp_CROSS_FIRMS_CELLOPERATION_ID;
        TpFIBDataSet *CROSS_OPERATION;
        TFIBIntegerField *CROSS_OPERATIONID;
        TFIBStringField *CROSS_OPERATIONOPERATION_NAME;
        TFIBFloatField *CROSS_OPERATIONCASHE;
        TfrDBDataSet *frCROSS_OPERATION;
        TpFIBDataSet *CROSS_FIRMS;
        TfrDBDataSet *frCROSS_FIRMS;
        TFIBIntegerField *CROSS_FIRMSID;
        TFIBStringField *CROSS_FIRMSCOMPANY_NAME;
        TFIBStringField *temp_CROSS_FIRMS_CELLCOMPANY_NAME;
        TFIBBCDField *temp_CROSS_FIRMS_CELLCOUNTS;
        TFIBBCDField *temp_CROSS_FIRMS_CELLSUMA;
        TCurrencyField *CROSS_FIRMSCOUNTS;
        TFloatField *CROSS_FIRMSSUMA;
        void __fastcall aRefreshAllExecute(TObject *Sender);
        void __fastcall aOperationExecute(TObject *Sender);
        void __fastcall aClassificatorExecute(TObject *Sender);
        void __fastcall aWokersExecute(TObject *Sender);
        void __fastcall aOrdersExecute(TObject *Sender);
        void __fastcall frReportBeginDoc();
        void __fastcall aReport1Execute(TObject *Sender);
        void __fastcall aReport2Execute(TObject *Sender);
        void __fastcall aReport3Execute(TObject *Sender);
        void __fastcall aDesignerExecute(TObject *Sender);
        void __fastcall aReport4Execute(TObject *Sender);
        void __fastcall CROSS_FIRMSCalcFields(TDataSet *DataSet);
private:	// User declarations
public:		// User declarations
        __fastcall TdmMain(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TdmMain *dmMain;
//---------------------------------------------------------------------------
#endif
