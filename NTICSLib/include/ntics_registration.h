//---------------------------------------------------------------------------

#ifndef ntics_registrationH
#define ntics_registrationH

#include <dstring.h>

//---------------------------------------------------------------------------
namespace Registration
{
    PACKAGE String extern StorageName;
    String extern DefaultSection;

    PACKAGE void __fastcall SetKey(const char* dkey, const char* nkey);
    PACKAGE void __fastcall SetSerial(String FileName);
    PACKAGE char* __fastcall GetFirmName();
    PACKAGE char* __fastcall GetEDRPOU();
    PACKAGE int __fastcall GetLicenze();
    PACKAGE const char* __fastcall GetLicenzeName();
    PACKAGE int __fastcall GetTFO();
    PACKAGE void __fastcall AddLicenze(const char* licenze);

    PACKAGE void __fastcall SaveValue(String Section, String Ident, String Value, bool Crypt = false);
    PACKAGE void __fastcall SaveValue(String Ident, String Value, bool Crypt = false);
    PACKAGE String __fastcall LoadValue(String Section, String Ident, String Default);
    PACKAGE String __fastcall LoadValue(String Ident, String Default);
    PACKAGE void __fastcall EraseSection(String Section);

};


#endif