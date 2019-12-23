 {
@abstract(STDCtrls import unit)
@author(Carlo Kok <ck@carlo-kok.com>)
  StdCtrls import unit
}
unit ifps3CEImp_COM;

interface
uses
  SysUtils, Classes, IFPS3CompExec, ifpscomp, ifps3;
type
  {@abstract(ComObj import class)}
  TIFPS3CE_ComObj = class(TIFPS3Plugin)
  private
  protected
    procedure CompileImport1(CompExec: TIFPS3CompExec); override;
    procedure ExecImport1(CompExec: TIFPS3CompExec; const ri: TIFPSRuntimeClassImporter); override;
  end;

  procedure Register;

implementation
uses
  ifpii_comobj,
  ifpiir_comobj;
  
procedure Register;
begin
  RegisterComponents('Innerfuse', [TIFPS3CE_ComObj]);
end;

{ TIFPS3CE_ComObj }

procedure TIFPS3CE_ComObj.CompileImport1(CompExec: TIFPS3CompExec);
begin
  SIRegister_ComObj(CompExec.Comp);
end;


procedure TIFPS3CE_ComObj.ExecImport1(CompExec: TIFPS3CompExec;
  const ri: TIFPSRuntimeClassImporter);
begin
  RIRegister_ComObj(CompExec.Exec);
end;

end.
