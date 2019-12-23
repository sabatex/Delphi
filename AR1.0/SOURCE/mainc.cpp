//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "mainc.h"
#include "dm_main.h"
#include "ntics_forms.h"
#include "form_1df.h"
#include "wokers.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
Tfrmmain_new *frmmain_new;

//---------------------------------------------------------------------------
__fastcall Tfrmmain_new::Tfrmmain_new(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall Tfrmmain_new::FormShow(TObject *Sender)
{
    RegisterClass(__classid(Tfrm_1df));
    RegisterClass(__classid(Tfrm_wokers));
    ntics_forms::RestoreChildForms();
}
//---------------------------------------------------------------------------

void __fastcall Tfrmmain_new::FormClose(TObject *Sender,
      TCloseAction &Action)
{
    ntics_forms::CloseChildForms();     
}
//---------------------------------------------------------------------------

