{
@abstract(Compiletime TObject, TPersistent and TComponent definitions)
@author(Carlo Kok <ck@carlo-kok.com>)
}
unit ifpii_std;
{$I ifps3_def.inc}
interface
uses
  ifpscomp, ifps3utl;

{
  Will register files from:
    System
    Classes (Only TComponent and TPersistent)

}

procedure SIRegister_Std_TypesAndConsts(Cl: TIFPSPascalCompiler);
procedure SIRegisterTObject(CL: TIFPSPascalCompiler);
procedure SIRegisterTPersistent(Cl: TIFPSPascalCompiler);
procedure SIRegisterTComponent(Cl: TIFPSPascalCompiler);

procedure SIRegister_Std(Cl: TIFPSPascalCompiler);

implementation

procedure SIRegisterTObject(CL: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(nil, 'TOBJECT') do
  begin
    RegisterMethod('constructor Create');
    RegisterMethod('procedure Free');
  end;
end;

procedure SIRegisterTPersistent(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TObject'), 'TPERSISTENT') do
  begin
    RegisterMethod('procedure Assign(Source: TPersistent)');
  end;
end;

procedure SIRegisterTComponent(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TPersistent'), 'TCOMPONENT') do
  begin
    RegisterMethod('function FindComponent(AName: string): TComponent;');
    RegisterMethod('constructor Create(AOwner: TComponent); virtual;');

    RegisterProperty('Owner', 'TComponent', iptRW);
    RegisterMethod('procedure DESTROYCOMPONENTS');
    RegisterMethod('procedure DESTROYING');
    RegisterMethod('procedure FREENOTIFICATION(ACOMPONENT:TCOMPONENT)');
    RegisterMethod('procedure INSERTCOMPONENT(ACOMPONENT:TCOMPONENT)');
    RegisterMethod('procedure REMOVECOMPONENT(ACOMPONENT:TCOMPONENT)');
    RegisterProperty('COMPONENTS', 'TCOMPONENT INTEGER', iptr);
    RegisterProperty('COMPONENTCOUNT', 'INTEGER', iptr);
    RegisterProperty('COMPONENTINDEX', 'INTEGER', iptrw);
    RegisterProperty('COMPONENTSTATE', 'Byte', iptr);
    RegisterProperty('DESIGNINFO', 'LONGINT', iptrw);
    RegisterProperty('NAME', 'STRING', iptrw);
    RegisterProperty('TAG', 'LONGINT', iptrw);
  end;
end;




procedure SIRegister_Std_TypesAndConsts(Cl: TIFPSPascalCompiler);
begin
  Cl.AddTypeS('TComponentStateE', '(csLoading, csReading, csWriting, csDestroying, csDesigning, csAncestor, csUpdating, csFixups, csFreeNotification, csInline, csDesignInstance)');
  cl.AddTypeS('TComponentState', 'set of TComponentStateE');
  Cl.AddTypeS('TRect', 'record Left, Top, Right, Bottom: Integer; end;');
end;

procedure SIRegister_Std(Cl: TIFPSPascalCompiler);
begin
  SIRegister_Std_TypesAndConsts(Cl);
  SIRegisterTObject(CL);
  SIRegisterTPersistent(Cl);
  SIRegisterTComponent(Cl);
end;

// IFPS3_MINIVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)


End.

