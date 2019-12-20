unit ntics_login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

const
  DefaultPrivilege='Guest';
  default_user = 'Anonymous';

type
  TConnectType = (ctLocal,ctTCPIP,ctNetBEUI,ctIPX);

  TIBLogin = class(TForm)
    MainPanel: TPanel;
    btExtended: TSpeedButton;
    chAutoLogin: TCheckBox;
    edUserName: TLabeledEdit;
    edPassword: TLabeledEdit;
    Panel2: TPanel;
    Label4: TLabel;
    SetPatchBase: TSpeedButton;
    Label5: TLabel;
    Label2: TLabel;
    edUserDatabase: TEdit;
    cbConnectType: TComboBox;
    edServerName: TLabeledEdit;
    edRole: TComboBox;
    Panel3: TPanel;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog ;
    procedure btExtendedClick(Sender: TObject);
    procedure SetPatchBaseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FCharSet:string;
    procedure SetExtended(const Value: boolean);
    function GetUserNameA: string;
    procedure SetUserNameA(const Value: string);
    function GetRole: string;
    function GetDataBase: string;
    procedure SetDataBase(const Value: string);
    function GetServerName: string;
    procedure SerServerName(const Value: string);
    function GetPassword: string;
    procedure SetPassword(const Value: string);
    function GetisAutoLogOn: boolean;
    procedure SetisAutoLogOn(const Value: boolean);
    function GetConnectType: TConnectType;
    procedure SetConnectType(const Value: TConnectType);
  public
    property UserName:string read GetUserNameA write SetUserNameA;
    property Role:string read GetRole;
    property DataBase:string read GetDataBase write SetDataBase;
    property ServerName:string read GetServerName write SerServerName;
    property CharSet:string read FCharSet write FCharSet;
    property Password:string read GetPassword write SetPassword;
    property isAutoLogOn:boolean read GetisAutoLogOn write SetisAutoLogOn;
    property ConnectType:TConnectType  read GetConnectType write SetConnectType;
    function DirectLoginExecute:boolean;
    function LoginExecute:boolean;
    procedure SaveConfig;


  end;

var
  IBLogin:TIBLogin;

implementation
{$R *.dfm}
uses ntics_registration, IniFiles ,ntics_storage;
{ TIBLogin }

procedure TIBLogin.SetExtended(const Value: boolean);
begin
  if Value<>btExtended.Down then
  begin
    btExtended.Down:=Value;
    if Value then
    begin
      Height:=Height + Panel2.Height;
      Panel2.Visible:=true;
    end
    else
    begin
      Panel2.Visible:=false;
      Height:=Height - Panel2.Height;
    end;
  end;
end;


procedure TIBLogin.btExtendedClick(Sender: TObject);
var
  x:boolean;
begin
  x := btExtended.Down;
  btExtended.Down := not x;
  SetExtended(x);
end;

function TIBLogin.GetUserNameA: string;
begin
  Result:=edUserName.Text;
end;

procedure TIBLogin.SetUserNameA(const Value: string);
begin
  edUserName.Text:=Value;
end;

function TIBLogin.GetRole: string;
begin
  Result:=edRole.Text;
end;

procedure TIBLogin.SetPatchBaseClick(Sender: TObject);
begin
  if OpenDialog1.Execute then DataBase := OpenDialog1.FileName;
end;

function TIBLogin.GetDataBase: string;
begin
  Result:=edUserDatabase.Text;
end;

procedure TIBLogin.SetDataBase(const Value: string);
begin
  edUserDatabase.Text:=Value;
end;

function TIBLogin.GetServerName: string;
begin
  Result:=edServerName.Text;
end;

procedure TIBLogin.SerServerName(const Value: string);
begin
  edServerName.Text:=Value;
end;

function TIBLogin.GetPassword: string;
begin
  Result:=edPassword.Text;
end;

procedure TIBLogin.SetPassword(const Value: string);
begin
  edPassword.Text:=Value;
end;

function TIBLogin.GetisAutoLogOn: boolean;
begin
  Result:=chAutoLogin.Checked;
end;

procedure TIBLogin.SetisAutoLogOn(const Value: boolean);
begin
  chAutoLogin.Checked:=Value;
end;

function TIBLogin.GetConnectType: TConnectType;
begin
  Result:= TConnectType(cbConnectType.ItemIndex);
end;

procedure TIBLogin.SetConnectType(const Value: TConnectType);
begin
  cbConnectType.ItemIndex := Integer(Value);
    if Value = ctLocal then
        edServerName.Visible := False
    else
        edServerName.Visible := True;
end;

function TIBLogin.DirectLoginExecute: boolean;
begin
  Result:= (ShowModal = mrOk);
  if Result then SaveConfig;
end;

function TIBLogin.LoginExecute: boolean;
begin
  if not isAutoLogOn then
  begin
    Result:= (ShowModal = mrOk);
    if Result then SaveConfig;
  end
  else Result:=true;
end;

procedure TIBLogin.SaveConfig;
begin
  // пользователь
  LocalStorage.WriteString('IBLogin','CurrentUser',UserName);
  LocalStorage.WriteBool('USER'+UserName,'AutoLogOn',isAutoLogOn);

  // Сохранение начальных параметров пользователя
  LocalStorage.SaveCrypt('USER'+UserName,'CurrentRole',edRole.Text);
  if isAutoLogon then
    LocalStorage.SaveCrypt('USER'+UserName,'Password',edPassword.Text);

  // Сохранение параметров базы
  LocalStorage.WriteString('IBLogin','CharSet',CharSet);
  LocalStorage.WriteInteger('IBLogin','ConnectType',integer(ConnectType));
  LocalStorage.WriteString('IBLogin','SERVERNAME',edServerName.Text);
  LocalStorage.WriteString('IBLogin','UserDataBase',edUserDatabase.Text);
end;

procedure TIBLogin.FormCreate(Sender: TObject);
begin
  // Установка начальных параметров пользователя
  UserName := LocalStorage.ReadString('IBLogin','CurrentUser',default_user);
  isAutoLogOn := LocalStorage.ReadBool('USER'+UserName,'AutoLogOn',false);
  //Role := nt:LoadValue("USER"+UserName,"CurrentRole",default_role);
  if isAutoLogOn then
      Password := localStorage.ReadString('USER'+UserName,'Password','')
  else
      Password := '';
  // Установка начальных параметров базы
  ConnectType := TConnectType(LocalStorage.ReadInteger('IBLogin','ConnectType',0));
  ServerName := LocalStorage.ReadString('IBLogin','SERVERNAME','');
  DataBase := LocalStorage.ReadString('IBLogin','UserDataBase','');
  // Установка кодовой страницы
  CharSet := 'WIN1251';
  SetExtended(false);

 {if (ServerName='') and (DataBasePath='') then
  begin
    if FileExists('ServerConfig.ini') then
    begin
      AssignFile(F,'ServerConfig.ini');
      Reset(F);
      Readln(F,S);
      ServerName:=s;
      Readln(F,S);
      DataBasePath:=s;
    end;
  end;}
end;

end.
