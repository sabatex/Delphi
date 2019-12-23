 {
@abstract(Forms Import Unit)
@author(Carlo Kok <ck@carlo-kok.com>)
  Forms Import Unit
}
unit ifps3CEImp_Forms;

interface
uses
  SysUtils, Classes, IFPS3CompExec, ifpscomp, ifps3;
type
  {@abstract(Forms import class)} 
  TIFPS3CE_Forms = class(TIFPS3Plugin)
  private
    FEnableForms: Boolean;
    FEnableMenus: Boolean;
  protected
    procedure CompileImport1(CompExec: TIFPS3CompExec); override;
    procedure ExecImport1(CompExec: TIFPS3CompExec; const ri: TIFPSRuntimeClassImporter); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property EnableForms: Boolean read FEnableForms write FEnableForms;
    property EnableMenus: Boolean read FEnableMenus write FEnableMenus;
  end;

  procedure Register;

implementation
uses
  ifpii_forms,
  ifpii_menus,
  ifpiir_forms,
  ifpiir_menus;

procedure Register;
begin
  RegisterComponents('Innerfuse', [TIFPS3CE_Forms]);
end;

{ TIFPS3CE_Forms }

procedure TIFPS3CE_Forms.CompileImport1(CompExec: TIFPS3CompExec);
begin
  if FEnableForms then
    SIRegister_Forms(CompExec.comp);
  if FEnableMenus then
    SIRegister_Menus(CompExec.comp);
end;

constructor TIFPS3CE_Forms.Create(AOwner: TComponent);
begin
  inherited Create(Aowner);
  FEnableForms := True;
  FEnableMenus := True;
end;

procedure TIFPS3CE_Forms.ExecImport1(CompExec: TIFPS3CompExec;
  const ri: TIFPSRuntimeClassImporter);
begin
  if FEnableForms then
    RIRegister_Forms(ri);
  if FEnableMenus then
  begin
    RIRegister_Menus(ri);
    RIRegister_Menus_Routines(compexec.Exec);
  end;
end;

end.
