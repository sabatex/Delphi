{
@abstract(Compiletime Extctrls support)
@author(Carlo Kok <ck@carlo-kok.com>)
}
unit ifpii_extctrls;

{$I ifps3_def.inc}
interface
uses
  ifpscomp, ifps3utl;
(*
   Will register files from:
     ExtCtrls

Requires:
  STD, classes, controls, graphics {$IFNDEF IFPS3_MINIVCL}, stdctrls {$ENDIF}
*)

procedure SIRegister_ExtCtrls_TypesAndConsts(cl: TIFPSPascalCompiler);

procedure SIRegisterTSHAPE(Cl: TIFPSPascalCompiler);
procedure SIRegisterTIMAGE(Cl: TIFPSPascalCompiler);
procedure SIRegisterTPAINTBOX(Cl: TIFPSPascalCompiler);
procedure SIRegisterTBEVEL(Cl: TIFPSPascalCompiler);
procedure SIRegisterTTIMER(Cl: TIFPSPascalCompiler);
procedure SIRegisterTCUSTOMPANEL(Cl: TIFPSPascalCompiler);
procedure SIRegisterTPANEL(Cl: TIFPSPascalCompiler);
{$IFNDEF CLX}
procedure SIRegisterTPAGE(Cl: TIFPSPascalCompiler);
procedure SIRegisterTNOTEBOOK(Cl: TIFPSPascalCompiler);
procedure SIRegisterTHEADER(Cl: TIFPSPascalCompiler);
{$ENDIF}
procedure SIRegisterTCUSTOMRADIOGROUP(Cl: TIFPSPascalCompiler);
procedure SIRegisterTRADIOGROUP(Cl: TIFPSPascalCompiler);

procedure SIRegister_ExtCtrls(cl: TIFPSPascalCompiler);

implementation
procedure SIRegisterTSHAPE(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TGRAPHICCONTROL'), 'TSHAPE') do
  begin
    RegisterProperty('BRUSH', 'TBRUSH', iptrw);
    RegisterProperty('PEN', 'TPEN', iptrw);
    RegisterProperty('SHAPE', 'TSHAPETYPE', iptrw);

    {$IFNDEF IFPS3_MINIVCL}
    RegisterMethod('procedure STYLECHANGED(SENDER:TOBJECT)');
    RegisterProperty('DRAGCURSOR', 'Longint', iptrw);
    RegisterProperty('DRAGMODE', 'TDragMode', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDragDropEvent', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDragOverEvent', iptrw);
    RegisterProperty('ONENDDRAG', 'TEndDragEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
    {$ENDIF}
  end;
end;

procedure SIRegisterTIMAGE(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TGRAPHICCONTROL'), 'TIMAGE') do
  begin
    RegisterProperty('CANVAS', 'TCANVAS', iptr);
    RegisterProperty('AUTOSIZE', 'BOOLEAN', iptrw);
    RegisterProperty('CENTER', 'BOOLEAN', iptrw);
    RegisterProperty('PICTURE', 'TPICTURE', iptrw);
    RegisterProperty('STRETCH', 'BOOLEAN', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);

    {$IFNDEF IFPS3_MINIVCL}
    RegisterProperty('DRAGCURSOR', 'Longint', iptrw);
    RegisterProperty('DRAGMODE', 'TDragMode', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('POPUPMENU', 'TPopupMenu', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDragDropEvent', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDragOverEvent', iptrw);
    RegisterProperty('ONENDDRAG', 'TEndDragEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
    {$ENDIF}
  end;
end;

procedure SIRegisterTPAINTBOX(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TGRAPHICCONTROL'), 'TPAINTBOX') do
  begin
    RegisterProperty('CANVAS', 'TCanvas', iptr);
    RegisterProperty('COLOR', 'Longint', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONPAINT', 'TNOTIFYEVENT', iptrw);

    {$IFNDEF IFPS3_MINIVCL}
    RegisterProperty('DRAGCURSOR', 'Longint', iptrw);
    RegisterProperty('DRAGMODE', 'TDragMode', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('POPUPMENU', 'TPopupMenu', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDragDropEvent', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDragOverEvent', iptrw);
    RegisterProperty('ONENDDRAG', 'TEndDragEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
    {$ENDIF}
  end;
end;

procedure SIRegisterTBEVEL(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TGRAPHICCONTROL'), 'TBEVEL') do
  begin
    RegisterProperty('SHAPE', 'TBEVELSHAPE', iptrw);
    RegisterProperty('STYLE', 'TBEVELSTYLE', iptrw);

    {$IFNDEF IFPS3_MINIVCL}
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    {$ENDIF}
  end;
end;

procedure SIRegisterTTIMER(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCOMPONENT'), 'TTIMER') do
  begin
    RegisterProperty('ENABLED', 'BOOLEAN', iptrw);
    RegisterProperty('INTERVAL', 'CARDINAL', iptrw);
    RegisterProperty('ONTIMER', 'TNOTIFYEVENT', iptrw);
  end;
end;

procedure SIRegisterTCUSTOMPANEL(Cl: TIFPSPascalCompiler);
begin
  Cl.AddClassN(cl.FindClass('TCUSTOMCONTROL'), 'TCUSTOMPANEL');
end;

procedure SIRegisterTPANEL(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMPANEL'), 'TPANEL') do
  begin
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('BEVELINNER', 'TPanelBevel', iptrw);
    RegisterProperty('BEVELOUTER', 'TPanelBevel', iptrw);
    RegisterProperty('BEVELWIDTH', 'TBevelWidth', iptrw);
    RegisterProperty('BORDERWIDTH', 'TBorderWidth', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('COLOR', 'Longint', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);

    {$IFNDEF IFPS3_MINIVCL}
    RegisterProperty('DRAGCURSOR', 'Longint', iptrw);
    RegisterProperty('DRAGMODE', 'TDragMode', iptrw);
    RegisterProperty('CTL3D', 'Boolean', iptrw);
    RegisterProperty('LOCKED', 'Boolean', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTCTL3D', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('POPUPMENU', 'TPopupMenu', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDragDropEvent', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDragOverEvent', iptrw);
    RegisterProperty('ONENDDRAG', 'TEndDragEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('ONRESIZE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
    {$ENDIF}
  end;
end;
{$IFNDEF CLX}
procedure SIRegisterTPAGE(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMCONTROL'), 'TPAGE') do
  begin
    RegisterProperty('CAPTION', 'String', iptrw);
  end;
end;
procedure SIRegisterTNOTEBOOK(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMCONTROL'), 'TNOTEBOOK') do
  begin
    RegisterProperty('ACTIVEPAGE', 'STRING', iptrw);
    RegisterProperty('COLOR', 'Longint', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PAGEINDEX', 'INTEGER', iptrw);
    RegisterProperty('PAGES', 'TSTRINGS', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONPAGECHANGED', 'TNOTIFYEVENT', iptrw);

    {$IFNDEF IFPS3_MINIVCL}
    RegisterProperty('CTL3D', 'Boolean', iptrw);
    RegisterProperty('DRAGCURSOR', 'Longint', iptrw);
    RegisterProperty('DRAGMODE', 'TDragMode', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTCTL3D', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('POPUPMENU', 'TPopupMenu', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDragDropEvent', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDragOverEvent', iptrw);
    RegisterProperty('ONENDDRAG', 'TEndDragEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
    {$ENDIF}
  end;
end;

procedure SIRegisterTHEADER(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMCONTROL'), 'THEADER') do
  begin
    RegisterProperty('SECTIONWIDTH', 'INTEGER INTEGER', iptrw);
    RegisterProperty('ALLOWRESIZE', 'BOOLEAN', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBORDERSTYLE', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('SECTIONS', 'TSTRINGS', iptrw);
    RegisterProperty('ONSIZING', 'TSECTIONEVENT', iptrw);
    RegisterProperty('ONSIZED', 'TSECTIONEVENT', iptrw);

    {$IFNDEF IFPS3_MINIVCL}
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('POPUPMENU', 'TPopupMenu', iptrw);
    {$ENDIF}
  end;
end;
{$ENDIF}

procedure SIRegisterTCUSTOMRADIOGROUP(Cl: TIFPSPascalCompiler);
begin
  Cl.AddClassN(cl.FindClass('TCUSTOMGROUPBOX'), 'TCUSTOMRADIOGROUP');
end;

procedure SIRegisterTRADIOGROUP(Cl: TIFPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMRADIOGROUP'), 'TRADIOGROUP') do
  begin
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('COLOR', 'Longint', iptrw);
    RegisterProperty('COLUMNS', 'Integer', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('ITEMINDEX', 'Integer', iptrw);
    RegisterProperty('ITEMS', 'TStrings', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);

    {$IFNDEF IFPS3_MINIVCL}
    RegisterProperty('CTL3D', 'Boolean', iptrw);
    RegisterProperty('DRAGCURSOR', 'Longint', iptrw);
    RegisterProperty('DRAGMODE', 'TDragMode', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTCTL3D', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('POPUPMENU', 'TPopupMenu', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDragDropEvent', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDragOverEvent', iptrw);
    RegisterProperty('ONENDDRAG', 'TEndDragEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
    {$ENDIF}
  end;
end;

procedure SIRegister_ExtCtrls_TypesAndConsts(cl: TIFPSPascalCompiler);
begin
  cl.AddTypeS('TShapeType', '(stRectangle, stSquare, stRoundRect, stRoundSquare, stEllipse, stCircle)');
  cl.AddTypeS('TBevelStyle', '(bsLowered, bsRaised)');
  cl.AddTypeS('TBevelShape', '(bsBox, bsFrame, bsTopLine, bsBottomLine, bsLeftLine, bsRightLine,bsSpacer)');
  cl.AddTypeS('TPanelBevel', '(bvNone, bvLowered, bvRaised,bvSpace)');
  cl.AddTypeS('TBevelWidth', 'Longint');
  cl.AddTypeS('TBorderWidth', 'Longint');
  cl.AddTypeS('TSectionEvent', 'procedure(Sender: TObject; ASection, AWidth: Integer)');
end;

procedure SIRegister_ExtCtrls(cl: TIFPSPascalCompiler);
begin
  SIRegister_ExtCtrls_TypesAndConsts(cl);

  {$IFNDEF IFPS3_MINIVCL}
  SIRegisterTSHAPE(Cl);
  SIRegisterTIMAGE(Cl);
  {$ENDIF}
  SIRegisterTPAINTBOX(Cl);
  SIRegisterTBEVEL(Cl);
  {$IFNDEF IFPS3_MINIVCL}
  SIRegisterTTIMER(Cl);
  {$ENDIF}
  SIRegisterTCUSTOMPANEL(Cl);
  SIRegisterTPANEL(Cl);
  {$IFNDEF CLX}
  SIRegisterTPAGE(Cl);
  SIRegisterTNOTEBOOK(Cl);
  {$ENDIF}
  {$IFNDEF IFPS3_MINIVCL}
  {$IFNDEF CLX}
  SIRegisterTHEADER(Cl);
  {$ENDIF}
  SIRegisterTCUSTOMRADIOGROUP(Cl);
  SIRegisterTRADIOGROUP(Cl);
  {$ENDIF}
end;

end.





