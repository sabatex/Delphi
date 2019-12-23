//---------------------------------------------------------------------------
#pragma hdrstop
#include "FGIntPrimeGeneration.h"
//---------------------------------------------------------------------------

#pragma package(smart_init)

void __fastcall PrimeSearch(Fgint::TFGInt &GInt)
{
  if ((GInt.Number[1] % 2) == 0) GInt.Number[1] = GInt.Number[1] + 1;
  TFGInt two;
  TFGInt temp;
  Base10StringToFGInt("2", two);
  bool ok = false;
  while (!ok)
  {
      FGIntAdd(GInt, two, temp);
      FGIntCopy(temp, GInt);
      FGIntPrimetest(GInt, 4, ok);
   }
   FGIntDestroy(two);
}

