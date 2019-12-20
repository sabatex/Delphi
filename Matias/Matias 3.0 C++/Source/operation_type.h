//---------------------------------------------------------------------------

#ifndef operation_typeH
#define operation_typeH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "DBGridEh.hpp"
#include "fcdbtreeview.hpp"
#include "FIBDatabase.hpp"
#include "FIBDataSet.hpp"
#include "pFIBDatabase.hpp"
#include "pFIBDataSet.hpp"
#include <ActnList.hpp>
#include <ComCtrls.hpp>
#include <DB.hpp>
#include <DBCtrls.hpp>
#include <ExtCtrls.hpp>
#include <Grids.hpp>
#include <Mask.hpp>
#include <ToolWin.hpp>
//---------------------------------------------------------------------------
class TfrmOperationType : public TForm
{
__published:	// IDE-managed Components
        TToolBar *ToolBar1;
        TToolButton *tbAddElement;
        TToolButton *ToolButton2;
        TToolButton *ToolButton1;
        TpFIBTransaction *taClasificator;
        TSplitter *Splitter1;
        TPanel *Panel1;
        TPanel *Panel2;
        TLabel *Label1;
        TDBEdit *DBEdit1;
        TDBEdit *DBEdit2;
        TfcDBTreeView *fcDBTreeView1;
        TDBGridEh *DBGridEh1;
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
        TActionList *ActionList1;
        TAction *aAddElement;
        TAction *aAddFolder;
        TAction *aMoveGroup;
        TDataSource *DataSource1;
        TDataSource *DataSource2;
        void __fastcall fcDBTreeView1DblClick(
          TfcDBCustomTreeView *TreeView, TfcDBTreeNode *Node,
          TMouseButton Button, TShiftState Shift, int X, int Y);
        void __fastcall aMoveGroupExecute(TObject *Sender);
        void __fastcall aAddFolderExecute(TObject *Sender);
        void __fastcall dbClasificatorAfterPost(TDataSet *DataSet);
        void __fastcall aAddElementExecute(TObject *Sender);
private:
        void SetPosition();
public:		// User declarations
        __fastcall TfrmOperationType(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmOperationType *frmOperationType;
//---------------------------------------------------------------------------
#endif
