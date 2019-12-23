//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "default_child.h"
#include "ntics_storages.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TChild_def *Child_def;
//---------------------------------------------------------------------------
__fastcall TChild_def::TChild_def(TComponent* Owner)
        : TForm(Owner)
{
}

char* const Form_Left = "Left";
char* const Form_Heigth = "Heigth";
char* const Form_Top = "Top";
char* const Form_Width = "Width";
char* const Form_Caption = "Caption";

//---------------------------------------------------------------------------
void __fastcall TChild_def::FormShow(TObject *Sender)
{
  // Востановим позицию формы
  Height = NetStorage->ReadInteger(Name,Form_Heigth,Height);
  Width  = NetStorage->ReadInteger(Name,Form_Width,Width);
  Top    = NetStorage->ReadInteger(Name,Form_Top,Top);
  Left   = NetStorage->ReadInteger(Name,Form_Left,Left);
  Caption= NetStorage->ReadString(Name,Form_Caption,Caption);
}
//---------------------------------------------------------------------------
void __fastcall TChild_def::FormClose(TObject *Sender,
      TCloseAction &Action)
{
  Action = caFree;
  NetStorage->WriteInteger(Name,Form_Heigth,Height);
  NetStorage->WriteInteger(Name,Form_Width,Width);
  NetStorage->WriteInteger(Name,Form_Top,Top);
  NetStorage->WriteInteger(Name,Form_Left,Left);
  NetStorage->WriteString(Name,Form_Caption,Caption);
}
//---------------------------------------------------------------------------
