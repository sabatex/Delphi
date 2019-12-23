//---------------------------------------------------------------------------
#include <vcl.h>
#include "ntics_includes.h"
#pragma hdrstop

#include "ntics_registration.h"
#pragma package(smart_init)


// название основного конфигурационного файла
String GetDefaultIniName()
{
  String s = ExtractFileName(Application->ExeName);
  return ExtractFilePath(Application->ExeName) + s.SubString(1,s.Pos(".")) + ".cfg";
}

String Registration::StorageName = GetDefaultIniName();
String Registration::DefaultSection = "Defoult"; // Set function to return user name

String __fastcall Registration::LoadValue(String Section, String Ident, String Default)
{
  TIniFile* INIFile = new TIniFile(Registration::StorageName);
  String s = INIFile->ReadString(Section, Ident, "0"+Default);

  s.Delete(1,1);
  delete INIFile;
  return s;
}


String __fastcall Registration::LoadValue(String Ident, String Default)
{
 return Registration::LoadValue(Registration::DefaultSection, Ident, Default);
}

void __fastcall Registration::SaveValue(String Section, String Ident, String Value, bool Crypt)
{
  TIniFile* INIFile = new TIniFile(Registration::StorageName);
  if (Crypt)
  {
   Value = "1" + Value; // insert this coder
  }
  else Value = "0" + Value;
  INIFile->WriteString(Section, Ident, Value);
  delete INIFile;
}

void __fastcall Registration::EraseSection(String Section)
{
  TIniFile* INIFile = new TIniFile(Registration::StorageName);
  INIFile->EraseSection(Section);
  delete INIFile;
}

void __fastcall Registration::SaveValue(String Ident, String Value, bool Crypt)
{
  Registration::SaveValue(Registration::DefaultSection, Ident, Value, Crypt);
}


int ID_FIZ = 0;
unsigned int LICENZE = 0;
char EDRPOU[11] = "None";
char COMPANY_NAME[100] = "None";
char SERIAL[100] = "None";
Fgint::TFGInt FD;
Fgint::TFGInt FN;
bool KeyExist = false;


void __fastcall Initialize()
{
  // Розшифровка ключа
  if (Registration::LoadValue("OPTIONS","SERIAL","") != "")
  {
    TFGInt Null;
    String delimiter = ";";
    String s = Registration::LoadValue("OPTIONS","SERIAL","");
    Base10StringToFGInt(s,Null);
    FGIntToBase256String(Null,s);
    FGIntDestroy(Null);
    RSADecrypt(s,FD,FN,Null,Null,Null,Null,s);

    // проверка версии ключа
    if (!s.Pos(delimiter)) return;
    if (s.SubString(1,s.Pos(delimiter)-1) != VersionKey) return;
    s.Delete(1,s.Pos(delimiter));

    if (!s.Pos(delimiter)) return;
    if (s.SubString(1,s.Pos(delimiter)-1) != Copyrigth) return;
    s.Delete(1,s.Pos(delimiter));

    // загрузка значений
    if (!s.Pos(delimiter)) return;
    StrCopy(EDRPOU,s.SubString(1,s.Pos(delimiter)-1).c_str());
    s.Delete(1,s.Pos(delimiter));

    if (!s.Pos(delimiter)) return;
    StrCopy(COMPANY_NAME,s.SubString(1,s.Pos(delimiter)-1).c_str());
    s.Delete(1,s.Pos(delimiter));

    if (!s.Pos(delimiter)) return;
    ID_FIZ = StrToInt(s.SubString(1,s.Pos(delimiter)-1));
    s.Delete(1,s.Pos(delimiter));

    if (!s.Pos(delimiter)) return;
    LICENZE = StrToInt(s.SubString(1,s.Pos(delimiter)-1));
    s.Delete(1,s.Pos(delimiter));

    if (!s.Pos(delimiter)) return;
    StrCopy(SERIAL,s.SubString(1,s.Pos(delimiter)-1).c_str());
    //s.Delete(1,s.Pos(delimiter));
  }
}

void __fastcall Registration::SetKey(const char* dkey, const char* nkey)
{
  Base10StringToFGInt(dkey,FD);
  Base10StringToFGInt(nkey,FN);
  Initialize();
}

void __fastcall Registration::SetSerial(String FileName)
{
  ifstream f;
  f.open(FileName.c_str());
  if (f)
  {
    char buff[1000];
    f.getline(buff,sizeof(buff));
    Registration::SaveValue("OPTIONS","SERIAL",buff);
    Initialize();
  }
}


char* __fastcall Registration::GetFirmName(){return COMPANY_NAME;}
char* __fastcall Registration::GetEDRPOU(){return EDRPOU;}
int __fastcall Registration::GetTFO(){return ID_FIZ;}

// Работа с лицензиями
const char* ShareWare = "ShareWare";
vector<const char*> LicenzeName(1,ShareWare);

int __fastcall Registration::GetLicenze()
{return (LICENZE > LicenzeName.size())?0:LICENZE;}

const char* __fastcall Registration::GetLicenzeName()
{
  return LicenzeName[Registration::GetLicenze()];
}

void __fastcall Registration::AddLicenze(const char* licenze)
{
  LicenzeName.resize(LicenzeName.size()+1);
  LicenzeName[LicenzeName.size()-1] = licenze;
}