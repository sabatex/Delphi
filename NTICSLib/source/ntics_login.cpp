//---------------------------------------------------------------------------

#include <vcl.h>
#include "ntics_includes.h"
#pragma hdrstop

#include "ntics_login.h"
#include "ntics_registration.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TIBLogin *IBLogin;
String default_user = "Anonymous";
String default_base = "Uknown";
String default_role = "None";

//---------- START LOAD AND SAVE VALUES -----------------------------
__fastcall TIBLogin::TIBLogin(TComponent* Owner)
        : TForm(Owner)
{
    // Основная база приложения
    ProjectBase = 0;
    // Установка начальных параметров пользователя
    UserName = Registration::LoadValue("IBLogin","CurrentUser",default_user);
    isAutoLogin = StrToInt(Registration::LoadValue("USER"+UserName,"AutoLogOn","0"));
    Role = Registration::LoadValue("USER"+UserName,"CurrentRole",default_role);
    if (isAutoLogin)
      Password = Registration::LoadValue("USER"+UserName,"Password","");
    else
      Password = "";
    // Установка начальных параметров базы
    ConnectType = TConnectType(StrToInt(Registration::LoadValue("IBLogin","ConnectType","0")));
    edServerName->Text = Registration::LoadValue("IBLogin","SERVERNAME","");
    edUserDatabase->Text = Registration::LoadValue("IBLogin","UserDataBase","");
    // Установка кодовой страницы
    CharSet = "WIN1251";
    SetExtended(false);
}

void __fastcall  TIBLogin::SaveConfig(void)
{
    // пользователь
    Registration::SaveValue("IBLogin","CurrentUser",UserName);
    Registration::SaveValue("USER"+UserName,"AutoLogOn",IntToStr(isAutoLogin));
    // Сохранение начальных параметров пользователя
    Registration::SaveValue("USER"+UserName,"CurrentRole",edRole->Text);
    if (isAutoLogin)
        Registration::SaveValue("USER"+UserName,"Password",edPassword->Text,true);

    // Сохранение параметров базы
    //Registration::SaveValue("BASE"+DataBase,"CodeTable",StrToInt(0));
    Registration::SaveValue("IBLogin","ConnectType",IntToStr(ConnectType));
    Registration::SaveValue("IBLogin","SERVERNAME",edServerName->Text);
    Registration::SaveValue("IBLogin","UserDataBase",edUserDatabase->Text);
}

// ---------------------  USER NAME --------------------------------
void __fastcall TIBLogin::SetUserName(String s)
{
    edUserName->Text = s;
}

//----- Дополнительные опции для входа -----
void __fastcall  TIBLogin::SetExtended(bool x)
{
  if (x != btExtended->Down)
  {
    btExtended->Down = x;
    if (x)
    {
      Height = Height + Panel2->Height;
      Panel2->Visible = true;
      edUserName->Enabled = false;
      edPassword->Enabled = false;
    }
    else
    {
      Panel2->Visible = false;
      Height = Height - Panel2->Height;
      edUserName->Enabled = true;
      edPassword->Enabled = true;
    }
  }
}

// Выводим приглашение ввода пароля даже в том случае
// если выбран режим автоматического входа
bool __fastcall TIBLogin::DirectLoginExecute(void)
{
  if (ShowModal() == mrOk)
  {
    SaveConfig();
    return true;
  }
  else return false;
}

// Вход
bool __fastcall TIBLogin::LoginExecute(void)
{
  if (!isAutoLogin)
    if (ShowModal() == mrOk)
    {
      SaveConfig();
      return true;
    }
    else return false;
  return true;
}

//  активация

void __fastcall TIBLogin::SetPatchBaseClick(TObject *Sender)
{
  if (OpenDialog1->Execute()) DataBase = OpenDialog1->FileName;
}
//---------------------------------------------------------------------------


void __fastcall TIBLogin::InitializeBase(TpFIBDatabase *base)
{
    base->Close();

    switch (ConnectType)
    {
      case ctTCPIP : base->DatabaseName = ServerName + ":" + DataBase; break;
      case ctNetBEUI : base->DatabaseName = "\\\\"+ServerName + "\\" + DataBase; break;
      case ctIPX : base->DatabaseName = ServerName + "@" + DataBase; break;
      case ctLocal : base->DatabaseName = DataBase; break;
    }

    base->ConnectParams->UserName = UserName;
    base->ConnectParams->Password = Password;
    base->ConnectParams->CharSet = CharSet;
    base->ConnectParams->RoleName = Role;

    try
    {
        base->Open();
    }
    catch (...)
    {
        throw("Невозможно соединится с базой. Проверьте пароль.");
    }
    ProjectBase = base; // Установка ссылки на основную базу
}

//-------------------  CONNECT TYPE ----------------------------------
TConnectType __fastcall TIBLogin::GetConnectType(void)
{
    return TConnectType(cbConnectType->ItemIndex);
}

void __fastcall TIBLogin::SetConnectType(TConnectType value)
{
    cbConnectType->ItemIndex = value;
    if (value == ctLocal)
        edServerName->Visible = False;
    else
        edServerName->Visible = True;
}



void __fastcall TIBLogin::SetRole(String s)
{
    if (edRole->Items->IndexOf(s)== -1) edRole->Items->Add(s);
    edRole->ItemIndex = edRole->Items->IndexOf(s);
}

//---------------------------------------------------------------------------
void __fastcall TIBLogin::SetAutoLogin(bool x)
{
    chAutoLogin->Checked = x;
}


// переключение в расширенный режим
void __fastcall TIBLogin::btExtendedClick(TObject *Sender)
{
  bool x = btExtended->Down;
  btExtended->Down = !x;
  SetExtended(x);
}


//---------------------------------------------------------------------------
void __fastcall TIBLogin::edUserNameClick(TObject *Sender)
{
    UserName = edUserName->Text;
}


//---------------------------------------------------------------------------
void __fastcall TIBLogin::cbConnectTypeClick(TObject *Sender)
{
   ConnectType = TConnectType(cbConnectType->ItemIndex);
}

