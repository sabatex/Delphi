//---------------------------------------------------------------------------

#ifndef default_dm_mainH
#define default_dm_mainH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ActnList.hpp>
#include <ImgList.hpp>
#include <StdActns.hpp>
#include <Menus.hpp>

//---------------------------------------------------------------------------
class TdmMain_def : public TDataModule
{
__published:	// IDE-managed Components
        TImageList *ImageList;
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
        TFilePrintSetup *FilePrintSetup;
    TAction *aFirms;
    TMainMenu *MainMenu;
    TMenuItem *N3;
    TMenuItem *N5;
    TMenuItem *N4;
    TMenuItem *N8;
    TMenuItem *N9;
    TMenuItem *Window;
    TMenuItem *N1;
    TMenuItem *N2;
    TPopupMenu *PopupMenu;
    TMenuItem *N7;
    TMenuItem *N6;
        void __fastcall AboutExecute(TObject *Sender);
    void __fastcall aFirmsExecute(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TdmMain_def(TComponent* Owner);
};

extern PACKAGE TdmMain_def *dmMain_def;
//---------------------------------------------------------------------------
#endif
