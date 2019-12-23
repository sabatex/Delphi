 {
@abstract(STDCtrls import unit)
@author(Carlo Kok <ck@carlo-kok.com>)
  StdCtrls import unit
}
unit ifps3CEImp_StdCtrls;

interface
uses
  SysUtils, Classes, IFPS3CompExec, ifpscomp, ifps3;
type
  {@abstract(StdCtrls import class)} 
  TIFPS3CE_StdCtrls = class(TIFPS3Plugin)
  private
    FEnableButtons: Boolean;
    FEnableExtCtrls: Boolean;
  protected
    procedure CompileImport1(CompExec: TIFPS3CompExec); override;
    procedure ExecImport1(CompExec: TIFPS3CompExec; const ri: TIFPSRuntimeClassImporter); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property EnableExtCtrls: Boolean read FEnableExtCtrls write FEnableExtCtrls;
    property EnableButtons: Boolean read FEnableButtons write FEnableButtons;
  end;

  procedure Register;

implementation
uses
  ifpii_buttons,
  ifpii_stdctrls,
  ifpii_extctrls,
  ifpiir_buttons,
  ifpiir_stdctrls,
  ifpiir_extctrls;

procedure Register;
begin
  RegisterComponents('Innerfuse', [TIFPS3CE_StdCtrls]);
end;

{ TIFPS3CE_StdCtrls }

procedure TIFPS3CE_StdCtrls.CompileImport1(CompExec: TIFPS3CompExec);
begin
    SIRegister_stdctrls(CompExec.Comp);
  if FEnableExtCtrls then
    SIRegister_ExtCtrls(CompExec.Comp);
  if FEnableButtons then
    SIRegister_Buttons(CompExec.Comp);
end;

constructor TIFPS3CE_StdCtrls.Create(AOwner: TComponent);
begin
  inherited Create(Aowner);
  FEnableButtons := True;
  FEnableExtCtrls := True;
end;

procedure TIFPS3CE_StdCtrls.ExecImport1(CompExec: TIFPS3CompExec;
  const ri: TIFPSRuntimeClassImporter);
begin
    RIRegister_stdctrls(RI);
  if FEnableExtCtrls then
    RIRegister_ExtCtrls(RI);
  if FEnableButtons then
    RIRegister_Buttons(RI);
end;

end.
