program ProgramDistributor;

uses
  Forms,
  fLogin,
  fSplash,
  fMain in 'fMain.pas' {frmMain},
  fDillers in 'fDillers.pas' {frDillers},
  fDataModule in 'fDataModule.pas' {dmFunction: TDataModule},
  fKeyGen in 'fKeyGen.pas' {frmKeyGen},
  fProducts in 'fProducts.pas' {frmProducts},
  fProductsFRM in 'fProductsFRM.pas' {frmProductsV},
  fFirms in 'fFirms.pas' {frmFirms},
  fPayProduct in 'fPayProduct.pas' {frmPayProducts},
  fFirmsEdit in 'fFirmsEdit.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  IBLogin:=TIBLogin.Create();
  if not IBLogin.LoginExecute then
    Halt;
  TfrmSplash.ShowSplash('Initialize ...');
  try
    Application.CreateForm(TdmFunction, dmFunction);
    if dmFunction.DataBase.Connected then
    begin
      Application.CreateForm(TfrmMain, frmMain);
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
