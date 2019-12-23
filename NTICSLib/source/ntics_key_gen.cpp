//---------------------------------------------------------------------------
#include <vcl.h>
#include "ntics_includes.h"
#pragma hdrstop

#include "ntics_key_gen.h"

//---------------------------------------------------------------------------

#pragma package(smart_init)

String __fastcall KeyGen::MakeKey(String  key, TFGInt E, TFGInt N)
{
  String s;
  RSAEncrypt(key,E,N,s);
  TFGInt temp;
  Base256StringToFGInt(s,temp);
  FGIntToBase10String(temp,s);
  FGIntDestroy(temp);
  return s;
}
