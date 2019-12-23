{
@abstract(compiletime ComObj support)
@author(Carlo Kok <ck@carlo-kok.com>)
}
unit ifpii_comobj;

{$I ifps3_def.inc}
interface
uses
  ifpscomp, ifps3utl;
{

Will register:

function CreateOleObject(const ClassName: string): IDispatch;
function GetActiveOleObject(const ClassName: string): IDispatch;

}

procedure SIRegister_ComObj(cl: TIFPSPascalCompiler);

implementation

procedure SIRegister_ComObj(cl: TIFPSPascalCompiler);
begin
  cl.AddDelphiFunction('function CreateOleObject(const ClassName: string): IDispatch;');
  cl.AddDelphiFunction('function GetActiveOleObject(const ClassName: string): IDispatch;');
end;

end.
