//---------------------------------------------------------------------------

#ifndef ntics_loginH
#define ntics_loginH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <Dialogs.hpp>
#include <ExtCtrls.hpp>
#include <pFIBDatabase.hpp>
#include <Mask.hpp>
//---------------------------------------------------------------------------
enum TConnectType {ctLocal,ctTCPIP,ctNetBEUI,ctIPX};

class PACKAGE TIBLogin : public TForm
{
__published:        // IDE-managed Components
        TOpenDialog *OpenDialog1;
        TPanel *MainPanel;
        TPanel *Panel2;
        TLabel *Label4;
        TSpeedButton *SetPatchBase;
        TEdit *edUserDatabase;
        TPanel *Panel3;
        TButton *Button1;
        TButton *Button2;
    TComboBox *cbConnectType;
    TLabel *Label5;
    TCheckBox *chAutoLogin;
    TLabeledEdit *edServerName;
    TSpeedButton *btExtended;
    TLabeledEdit *edUserName;
    TLabeledEdit *edPassword;
    TLabel *Label2;
    TComboBox *edRole;
    void __fastcall btExtendedClick(TObject *Sender);
    void __fastcall SetPatchBaseClick(TObject *Sender);
    void __fastcall edUserNameClick(TObject *Sender);
    void __fastcall cbConnectTypeClick(TObject *Sender);
private:
        String fCharSet;
        void __fastcall SetUserName(String s);
        String __fastcall GetUserName(void) {return edUserName->Text;};
        void __fastcall SetDataBase(String s) {edUserDatabase->Text = s;};
        String __fastcall GetDataBase(void) {return edUserDatabase->Text;};
        void __fastcall SetServerName(String s) {edServerName->Text = s;};
        String __fastcall GetServerName(void) {return edServerName->Text;};
        void __fastcall SetAutoLogin(bool x);
        bool __fastcall GetAutoLogin(void) {return chAutoLogin->Checked;};
        void __fastcall SetExtended(bool x);
        bool __fastcall GetExtended(void) {return btExtended->Down;};
        void __fastcall SetPassword(String s) {edPassword->Text = s;};
        String __fastcall GetPassword(void) {return edPassword->Text;};
        TConnectType __fastcall GetConnectType(void);
        void __fastcall SetConnectType(TConnectType value);
        String __fastcall GetRole(void) {return edRole->Text;};
        void __fastcall SetRole(String s);
        String __fastcall GetCharSet(void) {return fCharSet;};
        void __fastcall SetCharSet(String s) {fCharSet=s;};
public:
        TpFIBDatabase *ProjectBase;
        __property String UserName = {read=GetUserName, write=SetUserName};
        __property String Role = {read=GetRole, write=SetRole};
        __property String DataBase = {read=GetDataBase, write=SetDataBase};
        __property String ServerName = {read=GetServerName, write=SetServerName};
        __property String CharSet = {read=GetCharSet, write=SetCharSet};
        __property String Password = {read=GetPassword, write=SetPassword};
        __property bool isAutoLogin = {read=GetAutoLogin, write=SetAutoLogin};
        __property TConnectType ConnectType = {read=GetConnectType, write=SetConnectType};
        __fastcall TIBLogin(TComponent* Owner);
        bool __fastcall DirectLoginExecute(void);
        bool __fastcall LoginExecute(void);
        void __fastcall SaveConfig(void);
        void __fastcall InitializeBase(TpFIBDatabase *base);


};
//---------------------------------------------------------------------------
extern PACKAGE TIBLogin *IBLogin;
//---------------------------------------------------------------------------
#endif