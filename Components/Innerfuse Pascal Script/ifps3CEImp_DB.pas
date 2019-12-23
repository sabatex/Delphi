 {
@abstract(DB Import Unit)
@author(Carlo Kok <ck@carlo-kok.com>)
DB  Import Unit
}unit ifps3CEImp_DB;

interface
uses
  SysUtils, Classes, IFPS3CompExec, ifpscomp, ifps3;
type
  {@abstract(DB import class)}
  TIFPS3CE_DB = class(TIFPS3Plugin)
  protected
    procedure CompileImport1(CompExec: TIFPS3CompExec); override;
    procedure ExecImport1(CompExec: TIFPS3CompExec; const ri: TIFPSRuntimeClassImporter); override;
  public
  end;

  procedure Register;

implementation
uses
  ifpii_DB,
  ifpiir_DB;

procedure Register;
begin
  RegisterComponents('Innerfuse', [TIFPS3CE_DB]);
end;

{ TIFPS3CE_DB }

procedure TIFPS3CE_DB.CompileImport1(CompExec: TIFPS3CompExec);
begin
  SIRegister_DB(CompExec.Comp);
end;

procedure TIFPS3CE_DB.ExecImport1(CompExec: TIFPS3CompExec;
  const ri: TIFPSRuntimeClassImporter);
begin
  RIRegister_DB(RI);
end;

end.
