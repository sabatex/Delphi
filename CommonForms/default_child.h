//---------------------------------------------------------------------------

#ifndef default_childH
#define default_childH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
//---------------------------------------------------------------------------
class TChild_def : public TForm
{
__published:	// IDE-managed Components
    void __fastcall FormShow(TObject *Sender);
    void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
private:	// User declarations
public:		// User declarations
        __fastcall TChild_def(TComponent* Owner);

};
//---------------------------------------------------------------------------
extern PACKAGE TChild_def *Child_def;
//---------------------------------------------------------------------------
#endif
