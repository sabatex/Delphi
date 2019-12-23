 {
@abstract(Default Import Unit)
@author(Carlo Kok <ck@carlo-kok.com>)
Default Import Unit
}unit ifps3CEImp_Default;

interface
uses
  SysUtils, Classes, IFPS3CompExec, ifpscomp, ifps3;

type
  {@abstract(DateUtils import class)}
  TIFPS3CE_DateUtils = class(TIFPS3Plugin)
  protected
    procedure CompOnUses(CompExec: TIFPS3CompExec); override;
    procedure ExecOnUses(CompExec: TIFPS3CompExec); override;
  end;
  {@abstract(STD (TObject) import class)} 
  TIFPS3CE_Std = class(TIFPS3Plugin)
  private
    FEnableStreams: Boolean;
    FEnableClasses: Boolean;
  protected
    procedure CompileImport1(CompExec: TIFPS3CompExec); override;
    procedure ExecImport1(CompExec: TIFPS3CompExec; const ri: TIFPSRuntimeClassImporter); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property EnableStreams: Boolean read FEnableStreams write FEnableStreams;
    property EnableClasses: Boolean read FEnableClasses write FEnableClasses;
  end;

procedure Register;

implementation
uses
  ifpii_std, ifpiir_std, ifpii_classes, ifpiir_classes,
  ifpidateutils, ifpidateutilsr;

{ TIFPS3CE_Std }

procedure TIFPS3CE_Std.CompileImport1(CompExec: TIFPS3CompExec);
begin
  SIRegister_Std(CompExec.Comp);
  if FEnableClasses then
    SIRegister_Classes(CompExec.Comp, FEnableStreams);
end;

procedure TIFPS3CE_Std.ExecImport1(CompExec: TIFPS3CompExec;
  const ri: TIFPSRuntimeClassImporter);
begin
  RIRegister_Std(Ri);
  if FEnableClasses then
    RIRegister_Classes(ri, FEnableStreams);
end;

constructor TIFPS3CE_Std.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnableStreams := True;
  FEnableClasses := True;
end;

{ TIFPS3CE_DateUtils }

procedure TIFPS3CE_DateUtils.CompOnUses(CompExec: TIFPS3CompExec);
begin
  RegisterDateTimeLibrary_C(CompExec.Comp);
end;

procedure TIFPS3CE_DateUtils.ExecOnUses(CompExec: TIFPS3CompExec);
begin
  RegisterDateTimeLibrary_R(CompExec.Exec);
end;

procedure Register;
begin
  RegisterComponents('Innerfuse', [TIFPS3CE_DateUtils, TIFPS3CE_Std]);
end;

end.
