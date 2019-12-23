{
@abstract(Runtime Buttons definitions)
@author(Carlo Kok <ck@carlo-kok.com>)
}
unit ifpiir_buttons;
{$I ifps3_def.inc}
interface
uses
  ifps3, ifps3utl;
{
  Will register files from:
    Buttons

  Requires
      STD, classes, controls and graphics and StdCtrls
}

procedure RIRegisterTSPEEDBUTTON(Cl: TIFPSRuntimeClassImporter);
procedure RIRegisterTBITBTN(Cl: TIFPSRuntimeClassImporter);

procedure RIRegister_Buttons(Cl: TIFPSRuntimeClassImporter);

implementation
uses
  Classes{$IFDEF CLX}, QControls, QButtons{$ELSE}, Controls, Buttons{$ENDIF};

procedure RIRegisterTSPEEDBUTTON(Cl: TIFPSRuntimeClassImporter);
begin
  Cl.Add(TSPEEDBUTTON);
end;


procedure RIRegisterTBITBTN(Cl: TIFPSRuntimeClassImporter);
begin
  Cl.Add(TBITBTN);
end;

procedure RIRegister_Buttons(Cl: TIFPSRuntimeClassImporter);
begin
  RIRegisterTSPEEDBUTTON(cl);
  RIRegisterTBITBTN(cl);
end;

// IFPS3_MINIVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)


end.
