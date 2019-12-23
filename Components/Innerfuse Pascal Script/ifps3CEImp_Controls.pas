 {
@abstract(Controls Import Unit)
@author(Carlo Kok <ck@carlo-kok.com>)
Controls Import Unit
}unit ifps3CEImp_Controls;

interface
uses
  SysUtils, Classes, IFPS3CompExec, ifpscomp, ifps3;
type
  {@abstract(Controls import class)} 
  TIFPS3CE_Controls = class(TIFPS3Plugin)
  private
    FEnableGraphics: Boolean;
    FEnableControls: Boolean;
  protected
    procedure CompileImport1(CompExec: TIFPS3CompExec); override;
    procedure ExecImport1(CompExec: TIFPS3CompExec; const ri: TIFPSRuntimeClassImporter); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property EnableGraphics: Boolean read FEnableGraphics write FEnableGraphics;
    property EnableControls: Boolean read FEnableControls write FEnableControls;
  end;

procedure Register;

implementation
uses
  ifpii_graphics,
  ifpii_controls,
  ifpiir_graphics,
  ifpiir_controls;

procedure Register;
begin
  RegisterComponents('Innerfuse', [TIFPS3CE_Controls]);
end;


{ TIFPS3CE_Controls }

procedure TIFPS3CE_Controls.CompileImport1(CompExec: TIFPS3CompExec);
begin
  if FEnableGraphics then
    SIRegister_Graphics(CompExec.Comp);
  if FEnableControls then
    SIRegister_Controls(CompExec.Comp);
end;

constructor TIFPS3CE_Controls.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnableGraphics := True;
  FEnableControls := True;
end;

procedure TIFPS3CE_Controls.ExecImport1(CompExec: TIFPS3CompExec;
  const ri: TIFPSRuntimeClassImporter);
begin
  if FEnableGraphics then
    RIRegister_Graphics(ri);
  if FEnableControls then
    RIRegister_Controls(ri);
end;


end.
