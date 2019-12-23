unit fLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

const
  DefaultPrivilege='Guest';

type
  PNetResourceArray = ^TNetResourceArray;
  TNetResourceArray = array[0..MaxInt div SizeOf(TNetResource) - 1] of TNetResource;
  TConnectType = (ctLocal,ctNetWork);
  TNetProtocolType = (nptNetBEUI,nptTCPIP,nptNowellSPX);

  TfrmLogin = class(TForm)
    MainPanel: TPanel;
    btExtended: TSpeedButton;
    UserName: TLabel;
    Password: TLabel;
    edUserName: TEdit;
    edPassword: TEdit;
    Panel3: TPanel;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    Panel2: TPanel;
    ServerRG: TRadioGroup;
    NetworkProtocolGR: TRadioGroup;
    Label1: TLabel;
    edServerName: TComboBox;
    Label4: TLabel;
    edUserDatabase: TEdit;
    SetPatchBase: TSpeedButton;
    Label2: TLabel;
    edRole: TComboBox;
    Label3: TLabel;
    edCodeTable: TComboBox;
    chSavePassword: TCheckBox;
    chAutoLogin: TCheckBox;
    procedure btExtendedClick(Sender: TObject);
    procedure chSavePasswordClick(Sender: TObject);
    procedure chAutoLoginClick(Sender: TObject);
    procedure SetPatchBaseClick(Sender: TObject);
    procedure ServerRGClick(Sender: TObject);
  private
    procedure SetExtended(const Value: boolean);
  public
    { Public declarations }
  end;

TIBLogin = class(TObject)
  private
    FForm:TfrmLogin;
    FRole:TStrings;
    FEnabled: boolean;
    FConnectType:TConnectType;
    FNetProtocolType:TNetProtocolType;
    procedure SaveINIUserInfo;
    function GetUserNameA: string;
    procedure SetUserName(const Value: string);
    function GetRole: string;
    function GetDataBasePach: string;
    procedure SetDataBasePach(const Value: string);
    function GetisAutoLogOn: boolean;
    procedure SetisAutoLogOn(const Value: boolean);
    function GetisPasswordSave: boolean;
    procedure SetisPasswordSave(const Value: boolean);
    function GetisExtended: boolean;
    procedure SetisExtended(const Value: boolean);
    function GetisLocal: integer;
    procedure SetisLocal(const Value: integer);
    function GetNetworkProtocol: TNetProtocolType;
    procedure SetNetworkProtocol(const Value: TNetProtocolType);
    function GetServerName: string;
    procedure SerServerName(const Value: string);
    function GetPassword: string;
    procedure SetPassword(const Value: string);
  public
    property IsEnabled:boolean read FEnabled write FEnabled;
    property ListRole:TStrings read FRole write FRole;
    property UserName:string read GetUserNameA write SetUserName;
    property Role:string read GetRole;
    property DataBasePath:string read GetDataBasePach write SetDataBasePach;
    property AutoLogOn:boolean read GetisAutoLogOn write SetisAutoLogOn;
    property isPasswordSave:boolean read GetisPasswordSave write SetisPasswordSave;
    property isExtended:boolean read GetisExtended write SetisExtended;
    property isLocal:integer read GetisLocal write SetisLocal;
    property NetProtocolType:TNetProtocolType read GetNetworkProtocol write SetNetworkProtocol;
    property ServerName:string read GetServerName write SerServerName;
    property Password:string read GetPassword write SetPassword;

    function DirectLoginExecute:boolean;
    function LoginExecute:boolean;
    procedure SaveConfig;
    constructor Create;reintroduce;virtual;
    destructor Destroy;override;
end;
var
  IBLogin:TIBLogin;

implementation
{$R *.dfm}
uses fConfigStorage;
{ TIBLogin }

constructor TIBLogin.Create;
var
  F:Text;
  s:string;
begin
  inherited;
  FForm:=TfrmLogin.Create(nil);
  // ”становка начальных параметров пользовател€
  with ConfigStorage do
  begin
    UserName:=LoadValue('UserName',CurrentUserName);
    FForm.edRole.ItemIndex:= LoadValue('Privilege','0');
    AutoLogOn:=StrToBool(LoadValue('AutoLogOn','0'));

    isPasswordSave:=StrToBool(LoadValue('PasswordSave','0'));
    isExtended:=StrToBool(LoadValue('Extended','-1'));
    DataBasePath:=LoadValue('UserDataBase','');
    IsLocal:=StrToInt(LoadValue('IsLocal', '1'));
    //NetProtocolType:=StrToInt(LoadValue('ConnectType',IntToStr(ord(nptTCPIP))));
    ServerName:=LoadValue('ServerName','');
    if isPasswordSave then
      Password:=LoadValue('Password','',isPasswordSave)
    else
      Password:='';
  end;
  FRole:=FForm.edRole.Items;
  if (ServerName='') and (DataBasePath='') then
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
  end;
end;

destructor TIBLogin.Destroy;
begin
  FForm.Free;
  inherited;
end;

function TIBLogin.DirectLoginExecute: boolean;
begin
  Result:= (FForm.ShowModal = mrOk);
  if Result then SaveINIUserInfo;
end;

function TIBLogin.GetDataBasePach: string;
begin
  Result:=FForm.edUserDatabase.Text;
end;

function TIBLogin.GetisAutoLogOn: boolean;
begin
  Result:=FForm.chAutoLogin.Checked;
end;

function TIBLogin.GetisExtended: boolean;
begin
  Result:=FForm.btExtended.Down;
end;

function TIBLogin.GetisLocal: integer;
begin
  Result:=FForm.ServerRG.ItemIndex;
end;

function TIBLogin.GetisPasswordSave: boolean;
begin
  Result:=FForm.chSavePassword.Checked;
end;

function TIBLogin.GetNetworkProtocol: TNetProtocolType;
begin
  //Result:=FForm.NetworkProtocolGR.ItemIndex;
end;

function TIBLogin.GetPassword: string;
begin
  Result:=FForm.edPassword.Text;
end;

function TIBLogin.GetRole: string;
begin
  Result:=FForm.edRole.Text;
end;

function TIBLogin.GetServerName: string;
begin
  Result:=FForm.edServerName.Text;
end;

function TIBLogin.GetUserNameA: string;
begin
  Result:=FForm.edUserName.Text;
end;

function TIBLogin.LoginExecute: boolean;
begin
  if not AutoLogOn then
  begin
    Result:= (FForm.ShowModal = mrOk);
    if Result then SaveINIUserInfo;
  end
  else Result:=true;
end;

procedure TIBLogin.SaveConfig;
begin
  SaveINIUserInfo;
end;

procedure TIBLogin.SaveINIUserInfo;
begin
  with ConfigStorage do
  begin
    SaveValue('UserName',UserName);
    SaveValue('Role',Role);
    SaveValue('UserDataBase',DataBasePath);
    SaveValue('AutoLogOn',BoolToStr(AutoLogOn,False));
    SaveValue('PasswordSave',BoolToStr(isPasswordSave,False));
    SaveValue('Extended',BoolToStr(isExtended,False));
    SaveValue('IsLocal',IntToStr(IsLocal));
    //SaveValue('ConnectType',IntToStr(NetworkProtocol));
    SaveValue('ServerName',ServerName);
    if isPasswordSave then
      SaveValue('Password',Password,isPasswordSave);
  end;
end;

procedure TIBLogin.SerServerName(const Value: string);
begin
  FForm.edServerName.Text:=Value;
end;

procedure TIBLogin.SetDataBasePach(const Value: string);
begin
  FForm.edUserDatabase.Text:=Value;
end;

procedure TIBLogin.SetisAutoLogOn(const Value: boolean);
begin
  FForm.chAutoLogin.Checked:=Value;
end;

procedure TIBLogin.SetisExtended(const Value: boolean);
begin
  FForm.SetExtended(Value);
end;

procedure TIBLogin.SetisLocal(const Value: integer);
begin
  FForm.ServerRG.ItemIndex:=Value;
end;

procedure TIBLogin.SetisPasswordSave(const Value: boolean);
begin
  FForm.chSavePassword.Checked:=Value;
end;

procedure TIBLogin.SetNetworkProtocol(const Value: TNetProtocolType);
begin
  //FForm.NetworkProtocolGR.ItemIndex:=Value;
end;

procedure TIBLogin.SetPassword(const Value: string);
begin
  FForm.edPassword.Text:=Value;
end;

procedure TIBLogin.SetUserName(const Value: string);
begin
  FForm.edUserName.Text:=Value;
end;

{ TfrmLogin }

procedure TfrmLogin.SetExtended(const Value: boolean);
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

procedure TfrmLogin.btExtendedClick(Sender: TObject);
var
  x:boolean;
begin
  x:=btExtended.Down;
  btExtended.Down:=not btExtended.Down;
  SetExtended(x);
end;

procedure TfrmLogin.chSavePasswordClick(Sender: TObject);
begin
  if not chSavePassword.Checked then chAutoLogin.Checked:=false;
end;

procedure TfrmLogin.chAutoLoginClick(Sender: TObject);
begin
  if chAutoLogin.Checked then chSavePassword.Checked:=true;
end;

procedure TfrmLogin.SetPatchBaseClick(Sender: TObject);
begin
  if OpenDialog1.Execute then edUserDatabase.Text:=OpenDialog1.FileName;
end;

procedure TfrmLogin.ServerRGClick(Sender: TObject);
begin
  if ServerRG.ItemIndex=0 then
  begin
    NetworkProtocolGR.Enabled:=false;
    edServerName.Enabled:=false;
    SetPatchBase.Enabled:=True;
  end
  else
  begin
    NetworkProtocolGR.Enabled:=True;
    edServerName.Enabled:=True;
    SetPatchBase.Enabled:=False;
  end;
end;

end.
