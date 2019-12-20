unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls, ComCtrls, Menus;

type
  TfrmMain = class(TForm)
    StatusBar1: TStatusBar;
    pFirms: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    M_MONTH: TComboBox;
    cbFirms: TComboBox;
    OldWokers: TCheckBox;
    M_YEAR: TSpinEdit;
    MainMenu1: TMainMenu;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Help2: TMenuItem;
    Contents2: TMenuItem;
    SearchforHelpOn2: TMenuItem;
    HowtoUseHelp2: TMenuItem;
    About2: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbFirmsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation
{$R *.dfm}
uses ntics_storage, dm_base, default_splash, constants, dm_main, ntics_classes;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  // Уничтожим заставку перед показом основной формы
  frmSplash_def.Free;
  // Востановим состояние программы на момент закрытия
  NetStorage.RestoreChildForms;
  // Установим флаг успешной инициализации
  ntics_classes.ApplicationState := asRun;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  s:string;
begin
  frmSplash_def.ShowSplash('Ініціалізація головної форми...');
  WindowState := wsMaximized;

  // Заполним список фирм
  cbFirms.Items.Clear();
  dmBase.Firms.First();
  while not dmBase.Firms.Eof do
  begin
    cbFirms.Items.Add(dmBase.FirmsCOMPANY_NAME.Value);
    dmBase.Firms.Next();
  end;

  // Устанавливаем текущую фирму
  s := NetStorage.ReadString(Options,'CurrentFirm','');
  if not dmBase.Firms.Locate('COMPANY_NAME',s,[]) then
    s:=dmBase.FirmsCOMPANY_NAME.Value;
  cbFirms.ItemIndex:=cbFirms.Items.IndexOf(s);

  // востанавливаем основные настройки
  M_YEAR.Value := NetStorage.ReadInteger(Options,'M_YEAR',2004);
  M_MONTH.ItemIndex := NetStorage.ReadInteger(Options,'M_MONTH',1);
  OldWokers.Checked := NetStorage.ReadBool(Options,'OldWokers',false);
  cbFirmsClick(self);
end;

procedure TfrmMain.cbFirmsClick(Sender: TObject);
begin
  dmBase.SetFilterOrders(M_YEAR.Value,M_MONTH.ItemIndex+1,
                              OldWokers.Checked,
                              cbFirms.Text);

end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Сохраняем все настройки программы
  ntics_classes.ApplicationState:=asClose;
  NetStorage.WriteString(Options,'CurrentFirm',dmBase.FirmsCOMPANY_NAME.Value);
  NetStorage.WriteInteger(Options,'M_YEAR',M_YEAR.Value);
  NetStorage.WriteInteger(Options,'M_MONTH',M_MONTH.ItemIndex);
  NetStorage.WriteBool(Options,'OldWokers',OldWokers.Checked);
  NetStorage.SaveOpenChildForms;
end;

end.

