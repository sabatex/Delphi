program matias3;

uses
  Forms,
  main in 'main.pas' {frmMain},
  default_dm_main in '..\..\Common Forms\default_dm_main.pas' {dmMain_def: TDataModule},
  dm_main in 'dm_main.pas' {dmMain: TDataModule},
  default_dm_base in '..\..\Common Forms\default_dm_base.pas' {dmBase_def: TDataModule},
  dm_base in 'dm_base.pas' {dmBase: TDataModule},
  default_splash in '..\..\Common Forms\default_splash.pas' {frmSplash_def},
  constants in 'constants.pas',
  default_about in '..\..\Common Forms\default_about.pas' {frmAbout_def},
  default_child in '..\..\Common Forms\default_child.pas' {frmChild_def},
  default_grid in '..\..\Common Forms\default_grid.pas' {frmGrid_def},
  personal in 'personal.pas' {frmPersonal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmBase, dmBase);
  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
