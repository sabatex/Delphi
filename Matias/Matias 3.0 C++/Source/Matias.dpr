program Matias;

{%File '..\Changes.txt'}

uses
  Forms,
  fSplash,
  fLogin,
  fMain in 'fMain.pas' {frmMain},
  frameCustomGrid in 'frameCustomGrid.pas' {frCustomGrid: TFrame},
  dmfFunction in 'dmfFunction.pas' {dmFunction: TDataModule},
  fOperations in 'fOperations.pas' {frmOperations},
  fPersonal in 'fPersonal.pas' {frmPersonal},
  fOrder in 'fOrder.pas' {frmOrder},
  fFirms in 'fFirms.pas' {frmFirms},
  frOperationType in 'frOperationType.pas' {frmOperationType},
  MatiasConst in 'MatiasConst.pas',
  fOptions in 'fOptions.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Matias';
  IBLogin:=TIBLogin.Create();
  if not IBLogin.LoginExecute then
    Halt;

  TfrmSplash.ShowSplash('Initialize ...');
  try
    Application.CreateForm(TdmFunction, dmFunction);
    if dmFunction.Matias.Connected then
    begin
      Application.CreateForm(TfrmMain, frmMain);
      TfrmSplash.SplashFree;
      Application.Run;
    end
    else
    begin
      IBLogin.AutoLogOn:=false;
      IBLogin.SaveConfig;
    end;
  finally
    TfrmSplash.SplashFree;
    IBLogin.Free;
  end;
end.

