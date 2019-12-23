
{
@abstract(runtime ComObj support)
@author(Carlo Kok <ck@carlo-kok.com>)
}
unit ifpiir_comobj;

{$I ifps3_def.inc}
interface
uses
  ifps3, ifps3utl;
{

Will register:

function CreateOleObject(const ClassName: string): IDispatch;
function GetActiveOleObject(const ClassName: string): IDispatch;

}

procedure RIRegister_ComObj(cl: TIFPSExec);

implementation
uses
{$IFDEF IFPS3_D3PLUS}
  ComObj;
{$ELSE}
  Ole2, OleAuto;
{$ENDIF}
{$IFNDEF IFPS3_D3PLUS}

procedure CreateOleObject(const ClassName: string; var Disp: IDispatch);
var
  temp: Variant;
begin
  temp := OleAuto.CreateOleObject(ClassName);
  Disp := VarToInterface(Temp);
  Disp.AddRef;
end;

procedure GetActiveOleObject(const ClassName: string; var Disp: IDispatch);
var
  temp: Variant;
begin
  temp := OleAuto.GetActiveOleObject(ClassName);
  Disp := VarToInterface(Temp);
  Disp.AddRef;
end;

{$ENDIF}


procedure RIRegister_ComObj(cl: TIFPSExec);
begin
  cl.RegisterDelphiFunction(@CreateOleObject, 'CREATEOLEOBJECT', cdRegister);
  cl.RegisterDelphiFunction(@GetActiveOleObject, 'GETACTIVEOLEOBJECT', cdRegister);
end;

{$IFNDEF IFPS3_D3PLUS}
initialization
finalization
{$ENDIF}
end.
