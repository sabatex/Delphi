unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  Menus, StdCtrls, Registry, ImgList, ListActns,fConfigStorage,DateUtils,
  ActnList, ExtCtrls,
  ComCtrls, ToolWin, StdActns;



type
  TMainDlg = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    HelponHelp2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N1602: TMenuItem;
    N11: TMenuItem;
    N1603: TMenuItem;
    N81: TMenuItem;
    N82: TMenuItem;
    N83: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N84: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    sbMain: TStatusBar;
    N8: TMenuItem;
    N1772: TMenuItem;
    N1773: TMenuItem;
    N22: TMenuItem;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainDlg: TMainDlg;
  RegFile:TRegIniFile;

implementation

uses fAbout, fDM8DR, FirmsOptions, fConfig1c60,
  f8DREdit, fWokersParams, f8DRConst, crypto_keys, FormManager;

{$R *.DFM}

procedure TMainDlg.FormCreate(Sender: TObject);
begin
  Application.HelpFile:=ExtractFilePath(Application.ExeName) + 'HELP\8DR.HLP';
end;

end.
