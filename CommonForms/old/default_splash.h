//---------------------------------------------------------------------------

#ifndef default_splashH
#define default_splashH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <Graphics.hpp>
#include "JclFileUtils.hpp"


//---------------------------------------------------------------------------
class TfrmSplash_def : public TForm
{
__published:  // IDE-managed Components
        TPanel *Panel1;
        TLabel *LVersion;
        TLabel *lProductName;
        TLabel *StatusLabel;
        TImage *AppIcon;
private:  // User declarations
public:    // User declarations
        TJclFileVersionInfo* VersionInfo;
        __fastcall TfrmSplash_def(TComponent* Owner);
        __fastcall ~TfrmSplash_def(void);
        void __fastcall ShowSplash(char* s);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmSplash_def *frmSplash_def;
//---------------------------------------------------------------------------
#endif
