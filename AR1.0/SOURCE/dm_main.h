//---------------------------------------------------------------------------

#ifndef dm_mainH
#define dm_mainH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "default_dm_main.h"
#include <ActnList.hpp>
#include <ImgList.hpp>
#include <Menus.hpp>
#include <StdActns.hpp>
#include <Dialogs.hpp>
#include "frxClass.hpp"
#include "frxDBSet.hpp"
#include "FR_Class.hpp"
#include "FR_DBSet.hpp"
#include "FR_DCtrl.hpp"
#include "FR_DSet.hpp"
#include "FR_Rich.hpp"
//---------------------------------------------------------------------------
class TdmMain : public TdmMain_def
{
__published:	// IDE-managed Components
        TAction *aRegistration;
        TOpenDialog *OpenRegKey;
    TAction *aWokers;
    TAction *a1DF;
    TAction *aOptions;
    TAction *aConfig1C60;
    TAction *aConfig1C77;
    TAction *aReport1DF;
    TfrDialogControls *frDialogControls1;
    TfrDBDataSet *frDBDataSetDA;
    TfrRichObject *frRichObject1;
    TfrReport *frReport1;
    TAction *aImportConfig;
    TAction *aExportConfig;
    TAction *aExport1DF;
    TAction *aImport1C60;
    TAction *aImport1C77;
    TSaveDialog *SaveDialogOut;
    TOpenDialog *odConfig;
    TSaveDialog *sdConfig;
    TOpenDialog *odInsertFromFile;
        void __fastcall aRegistrationExecute(TObject *Sender);
    void __fastcall aWokersExecute(TObject *Sender);
    void __fastcall a1DFExecute(TObject *Sender);
    void __fastcall aOptionsExecute(TObject *Sender);
    void __fastcall aConfig1C60Execute(TObject *Sender);
    void __fastcall aConfig1C77Execute(TObject *Sender);
    void __fastcall aReport1DFExecute(TObject *Sender);
    void __fastcall frReport1GetValue(const AnsiString ParName,
          Variant &ParValue);
    void __fastcall frReport1UserFunction(const AnsiString Name,
          Variant &p1, Variant &p2, Variant &p3, Variant &Val);
    void __fastcall aImportConfigExecute(TObject *Sender);
    void __fastcall aExportConfigExecute(TObject *Sender);
    void __fastcall aExport1DFExecute(TObject *Sender);
    void __fastcall aImport1C60Execute(TObject *Sender);
    void __fastcall aImport1C77Execute(TObject *Sender);
private:	// User declarations
    TDate FCurrentDate;
public:		// User declarations
  __fastcall TdmMain(TComponent* Owner);
  __property TDate CurrentDate = {read=FCurrentDate,write=FCurrentDate};
};
//---------------------------------------------------------------------------
extern PACKAGE TdmMain *dmMain;
//---------------------------------------------------------------------------
#endif
