//---------------------------------------------------------------------------

#ifndef main_oldH
#define main_oldH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ComCtrls.hpp>
#include <Menus.hpp>
#include <ActnList.hpp>
#include <ImgList.hpp>
#include <StdActns.hpp>
//---------------------------------------------------------------------------
class TfrmMain : public TForm
{
__published:	// IDE-managed Components
        TStatusBar *sbMain;
        TMainMenu *MainMenu1;
        TMenuItem *N1;
        TMenuItem *N2;
        TMenuItem *N3;
        TMenuItem *N4;
        TActionList *ActionList;
        TEditCopy *EditCopy1;
        TEditCut *EditCut1;
        TEditPaste *EditPaste1;
        TWindowArrange *WindowArrange1;
        TWindowCascade *WindowCascade1;
        TWindowClose *WindowClose1;
        TWindowMinimizeAll *WindowMinimizeAll1;
        TWindowTileHorizontal *WindowTileHorizontal1;
        TWindowTileVertical *WindowTileVertical1;
        TAction *About;
        TFileExit *FileExit;
        TImageList *ImageList;
        TFilePrintSetup *FilePrintSetup;
        TMenuItem *N5;
        TAction *ProductList;
        TMenuItem *ProductList1;
        TMenuItem *ShowFirms1;
        void __fastcall AboutExecute(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfrmMain(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmMain *frmMain;
//---------------------------------------------------------------------------
#endif
