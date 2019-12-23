unit fAbout;
interface
uses
  SysUtils, Classes, Forms,Windows,
  Dialogs, StdCtrls, Buttons, Controls, Graphics, ExtCtrls;

type
  TfrmAbout = class(TForm)
    Panel1: TPanel;
    btOk: TBitBtn;
    Panel2: TPanel;
    AppIcon: TImage;
    LPRGName: TLabel;
    LVersion: TLabel;
    ScrollBox1: TScrollBox;
    LCopyrigth1: TLabel;
    LCopyrigth2: TLabel;
    RegistrationOn: TLabel;
    RegistrationNumber: TLabel;
    Label4: TLabel;
    LHTMLAdress: TLabel;
    LEmailAdress: TLabel;
    RegistrationLicenzeCount: TLabel;
    procedure LabelMouseEnter(Sender: TObject);
    procedure LabelClick(Sender: TObject);
    procedure LEmailAdressMouseLeave(Sender: TObject);
    procedure btLicenzeClick(Sender: TObject);
    procedure btRegistrationClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
  private

  public
    constructor Create(AOwner:TComponent);override;
  end;


implementation
uses ShellAPI, FileVersionInfo, ntics_const, crypto_keys;
{$R *.DFM}

{ TAboutForm }
procedure TfrmAbout.LabelMouseEnter(Sender: TObject);
begin
  Font.Color := clHighlight;
end;

procedure TfrmAbout.LabelClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, nil, 'http://lakas.webjump.com', nil,
    nil, SW_SHOWNOACTIVATE);
end;

procedure TfrmAbout.LEmailAdressMouseLeave(Sender: TObject);
begin
  Font.Color := clDefault;
end;

procedure TfrmAbout.btLicenzeClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, nil, 'Licenze.txt', nil,
    nil, SW_SHOWNOACTIVATE);
end;

procedure TfrmAbout.btRegistrationClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, nil, 'Registered.txt', nil,
    nil, SW_SHOWNOACTIVATE);
end;

procedure TfrmAbout.btOkClick(Sender: TObject);
begin
  Close;
end;

constructor TfrmAbout.Create(AOwner: TComponent);
var
  FVersion:TFileVersionInfo;
begin
  inherited;
  FVersion:=TFileVersionInfo.Create(ExtractFileName(Application.ExeName));
  AppIcon.Cursor := crHandPoint;
  LPRGName.Cursor := crHandPoint;
  LPRGName.Caption:=FVersion.ProductName;
  LVersion.Caption:='Version ' + FVersion.FileVersion;
  LCopyrigth1.Caption:=FVersion.LegalCopyright;
  LCopyrigth2.Caption:=FVersion.LegalTrademarks;
  LHTMLAdress.Caption:=AvtorHTML;
  LEmailAdress.Caption:=AvtorEMAIL;
  FVersion.Free;
  if Assigned(RegistrationInfo) then
  begin
    RegistrationOn.Caption:='Зареєстровано на : '+RegistrationInfo.FirmName;
    RegistrationNumber.Caption:='Реєстраційний номер: '+RegistrationInfo.EDRPOU;
    RegistrationLicenzeCount.Caption:='Придбано ліцензій: ' +
                                      IntToStr(RegistrationInfo.LicenzeCount);   
  end;

  //AppIcon.Picture.Bitmap.LoadFromResourceName(HInstance,'FIRMLOGO');
end;

end.

