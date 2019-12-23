 {
@abstract(Menus Import Unit)
@author(Carlo Kok <ck@carlo-kok.com>)
Menus Import Unit
}Unit ifpii_menus;
{$I ifps3_def.inc}
Interface
Uses ifpscomp;

procedure SIRegisterTMENUITEMSTACK(CL: TIFPSPascalCompiler);
procedure SIRegisterTPOPUPLIST(CL: TIFPSPascalCompiler);
procedure SIRegisterTPOPUPMENU(CL: TIFPSPascalCompiler);
procedure SIRegisterTMAINMENU(CL: TIFPSPascalCompiler);
procedure SIRegisterTMENU(CL: TIFPSPascalCompiler);
procedure SIRegisterTMENUITEM(CL: TIFPSPascalCompiler);
procedure SIRegister_Menus(Cl: TIFPSPascalCompiler);

implementation
procedure SIRegisterTMENUITEMSTACK(CL: TIFPSPascalCompiler);
begin
  With cl.AddClassN(Cl.FindClass('TSTACK'),'TMENUITEMSTACK') do
  begin
    RegisterMethod('Procedure CLEARITEM( AITEM : TMENUITEM)');
  end;
end;

procedure SIRegisterTPOPUPLIST(CL: TIFPSPascalCompiler);
begin
  With cl.AddClassN(Cl.FindClass('TLIST'),'TPOPUPLIST') do
  begin
    RegisterProperty('WINDOW', 'HWND', iptr);
    RegisterMethod('Procedure ADD( POPUP : TPOPUPMENU)');
    RegisterMethod('Procedure REMOVE( POPUP : TPOPUPMENU)');
  end;
end;

procedure SIRegisterTPOPUPMENU(CL: TIFPSPascalCompiler);
var
  cc: TIFPSCompileTimeClass;
begin
  With cl.AddClassN(Cl.FindClass('TMENU'),'TPOPUPMENU') do
  begin
    cc := Cl.FindClass('TLabel');
    if cc <> nil then
      RegisterProperty('POPUPMENU', 'TPOPUPMENU', iptRW);
    with Cl.FindClass('TForm') do
    begin
      RegisterProperty('POPUPMENU', 'TPOPUPMENU', iptRW);
    end;
    RegisterMethod('Constructor CREATE( AOWNER : TCOMPONENT)');
    RegisterMethod('Procedure POPUP( X, Y : INTEGER)');
    RegisterProperty('POPUPCOMPONENT', 'TCOMPONENT', iptrw);
    RegisterProperty('ALIGNMENT', 'TPOPUPALIGNMENT', iptrw);
    RegisterProperty('AUTOPOPUP', 'BOOLEAN', iptrw);
    RegisterProperty('HELPCONTEXT', 'THELPCONTEXT', iptrw);
    RegisterProperty('MENUANIMATION', 'TMENUANIMATION', iptrw);
    RegisterProperty('TRACKBUTTON', 'TTRACKBUTTON', iptrw);
    RegisterProperty('ONPOPUP', 'TNOTIFYEVENT', iptrw);
  end;
end;

procedure SIRegisterTMAINMENU(CL: TIFPSPascalCompiler);
begin
  With cl.AddClassN(Cl.FindClass('TMENU'),'TMAINMENU') do
  begin
    RegisterMethod('Procedure MERGE( MENU : TMAINMENU)');
    RegisterMethod('Procedure UNMERGE( MENU : TMAINMENU)');
    RegisterMethod('Procedure POPULATEOLE2MENU( SHAREDMENU : HMENU; GROUPS : array of INTEGER; var WIDTHS : array of LONGINT)');
    RegisterMethod('Procedure GETOLE2ACCELERATORTABLE( var ACCELTABLE : HACCEL; var ACCELCOUNT : INTEGER; GROUPS : array of INTEGER)');
    RegisterMethod('Procedure SETOLE2MENUHANDLE( HANDLE : HMENU)');
    RegisterProperty('AUTOMERGE', 'BOOLEAN', iptrw);
  end;
end;

procedure SIRegisterTMENU(CL: TIFPSPascalCompiler);
begin
  With cl.AddClassN(Cl.FindClass('TCOMPONENT'),'TMENU') do
  begin
    RegisterMethod('Constructor CREATE( AOWNER : TCOMPONENT)');
    RegisterMethod('Function DISPATCHCOMMAND( ACOMMAND : WORD) : BOOLEAN');
    RegisterMethod('Function DISPATCHPOPUP( AHANDLE : HMENU) : BOOLEAN');
    RegisterMethod('Function FINDITEM( VALUE : INTEGER; KIND : TFINDITEMKIND) : TMENUITEM');
    RegisterMethod('Function GETHELPCONTEXT( VALUE : INTEGER; BYCOMMAND : BOOLEAN) : THELPCONTEXT');
    RegisterProperty('IMAGES', 'TCUSTOMIMAGELIST', iptrw);
    RegisterMethod('Function ISRIGHTTOLEFT : BOOLEAN');
    RegisterMethod('Procedure PARENTBIDIMODECHANGED( ACONTROL : TOBJECT)');
    RegisterMethod('Procedure PROCESSMENUCHAR( var MESSAGE : TWMMENUCHAR)');
    RegisterProperty('AUTOHOTKEYS', 'TMENUAUTOFLAG', iptrw);
    RegisterProperty('AUTOLINEREDUCTION', 'TMENUAUTOFLAG', iptrw);
    RegisterProperty('BIDIMODE', 'TBIDIMODE', iptrw);
    RegisterProperty('HANDLE', 'HMENU', iptr);
    RegisterProperty('OWNERDRAW', 'BOOLEAN', iptrw);
    RegisterProperty('PARENTBIDIMODE', 'BOOLEAN', iptrw);
    RegisterProperty('WINDOWHANDLE', 'HWND', iptrw);
    RegisterProperty('ITEMS', 'TMENUITEM', iptr);
  end;
end;

procedure SIRegisterTMENUITEM(CL: TIFPSPascalCompiler);
begin
  With cl.AddClassN(Cl.FindClass('TCOMPONENT'),'TMENUITEM') do
  begin
    RegisterMethod('Constructor CREATE( AOWNER : TCOMPONENT)');
    RegisterMethod('Procedure INITIATEACTION');
    RegisterMethod('Procedure INSERT( INDEX : INTEGER; ITEM : TMENUITEM)');
    RegisterMethod('Procedure DELETE( INDEX : INTEGER)');
    RegisterMethod('Procedure CLEAR');
    RegisterMethod('Procedure CLICK');
    RegisterMethod('Function FIND( ACAPTION : STRING) : TMENUITEM');
    RegisterMethod('Function INDEXOF( ITEM : TMENUITEM) : INTEGER');
    RegisterMethod('Function ISLINE : BOOLEAN');
    RegisterMethod('Function GETIMAGELIST : TCUSTOMIMAGELIST');
    RegisterMethod('Function GETPARENTCOMPONENT : TCOMPONENT');
    RegisterMethod('Function GETPARENTMENU : TMENU');
    RegisterMethod('Function HASPARENT : BOOLEAN');
    RegisterMethod('Function NEWTOPLINE : INTEGER');
    RegisterMethod('Function NEWBOTTOMLINE : INTEGER');
    RegisterMethod('Function INSERTNEWLINEBEFORE( AITEM : TMENUITEM) : INTEGER');
    RegisterMethod('Function INSERTNEWLINEAFTER( AITEM : TMENUITEM) : INTEGER');
    RegisterMethod('Procedure ADD( ITEM : TMENUITEM)');
    RegisterMethod('Procedure REMOVE( ITEM : TMENUITEM)');
    RegisterMethod('Function RETHINKHOTKEYS : BOOLEAN');
    RegisterMethod('Function RETHINKLINES : BOOLEAN');
    RegisterProperty('COMMAND', 'WORD', iptr);
    RegisterProperty('HANDLE', 'HMENU', iptr);
    RegisterProperty('COUNT', 'INTEGER', iptr);
    RegisterProperty('ITEMS', 'TMENUITEM INTEGER', iptr);
    RegisterProperty('MENUINDEX', 'INTEGER', iptrw);
    RegisterProperty('PARENT', 'TMENUITEM', iptr);
    {$IFDEF IFPS3_D5PLUS}
    RegisterProperty('ACTION', 'TBASICACTION', iptrw);
    {$ENDIF}
    RegisterProperty('AUTOHOTKEYS', 'TMENUITEMAUTOFLAG', iptrw);
    RegisterProperty('AUTOLINEREDUCTION', 'TMENUITEMAUTOFLAG', iptrw);
    RegisterProperty('BITMAP', 'TBITMAP', iptrw);
    RegisterProperty('CAPTION', 'STRING', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('SUBMENUIMAGES', 'TCUSTOMIMAGELIST', iptrw);
    RegisterProperty('DEFAULT', 'BOOLEAN', iptrw);
    RegisterProperty('ENABLED', 'BOOLEAN', iptrw);
    RegisterProperty('GROUPINDEX', 'BYTE', iptrw);
    RegisterProperty('HELPCONTEXT', 'THELPCONTEXT', iptrw);
    RegisterProperty('HINT', 'STRING', iptrw);
    RegisterProperty('IMAGEINDEX', 'TIMAGEINDEX', iptrw);
    RegisterProperty('RADIOITEM', 'BOOLEAN', iptrw);
    RegisterProperty('SHORTCUT', 'TSHORTCUT', iptrw);
    RegisterProperty('VISIBLE', 'BOOLEAN', iptrw);
    RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDRAWITEM', 'TMENUDRAWITEMEVENT', iptrw);
    RegisterProperty('ONADVANCEDDRAWITEM', 'TADVANCEDMENUDRAWITEMEVENT', iptrw);
    RegisterProperty('ONMEASUREITEM', 'TMENUMEASUREITEMEVENT', iptrw);
  end;
end;

procedure SIRegister_Menus(Cl: TIFPSPascalCompiler);
begin
  Cl.AddTypeS('HMenu', 'Cardinal');
  Cl.AddTypeS('HACCEL', 'Cardinal');

  cl.addClassN(cl.FindClass('EXCEPTION'),'EMENUERROR');
  Cl.addTypeS('TMENUBREAK', '( MBNONE, MBBREAK, MBBARBREAK )');
  Cl.addTypeS('TMENUDRAWITEMEVENT', 'Procedure ( SENDER : TOBJECT; ACANVAS : TC'
   +'ANVAS; ARECT : TRECT; SELECTED : BOOLEAN)');
  Cl.addTypeS('TADVANCEDMENUDRAWITEMEVENT', 'Procedure ( SENDER : TOBJECT; ACAN'
   +'VAS : TCANVAS; ARECT : TRECT; STATE : TOWNERDRAWSTATE)');
  Cl.addTypeS('TMENUMEASUREITEMEVENT', 'Procedure ( SENDER : TOBJECT; ACANVAS :'
   +' TCANVAS; var WIDTH, HEIGHT : INTEGER)');
  Cl.addTypeS('TMENUITEMAUTOFLAG', '( MAAUTOMATIC, MAMANUAL, MAPARENT )');
  Cl.AddTypeS('TMenuAutoFlag', 'TMENUITEMAUTOFLAG');
  Cl.addTypeS('TSHORTCUT', 'WORD');
  cl.addClassN(cl.FindClass('TACTIONLINK'),'TMENUACTIONLINK');
  SIRegisterTMENUITEM(Cl);
  Cl.addTypeS('TMENUCHANGEEVENT', 'Procedure ( SENDER : TOBJECT; SOURCE : TMENU'
   +'ITEM; REBUILD : BOOLEAN)');
  Cl.addTypeS('TFINDITEMKIND', '( FKCOMMAND, FKHANDLE, FKSHORTCUT )');
  SIRegisterTMENU(Cl);
  SIRegisterTMAINMENU(Cl);
  Cl.addTypeS('TPOPUPALIGNMENT', '( PALEFT, PARIGHT, PACENTER )');
  Cl.addTypeS('TTRACKBUTTON', '( TBRIGHTBUTTON, TBLEFTBUTTON )');
  Cl.addTypeS('TMENUANIMATIONS', '( MALEFTTORIGHT, MARIGHTTOLEFT, MATOPTOBOTTOM'
   +', MABOTTOMTOTOP, MANONE )');
  Cl.addTypeS('TMENUANIMATION', 'set of TMENUANIMATIONS');
  SIRegisterTPOPUPMENU(Cl);
  SIRegisterTPOPUPLIST(Cl);
  SIRegisterTMENUITEMSTACK(Cl);
  Cl.addTypeS('TCMENUITEM', 'TMENUITEM');
  Cl.AddDelphiFunction('Function SHORTCUT( KEY : WORD; SHIFT : TSHIFTSTATE) : T'
   +'SHORTCUT');
  Cl.AddDelphiFunction('Procedure SHORTCUTTOKEY( SHORTCUT : TSHORTCUT; var KEY '
   +': WORD; var SHIFT : TSHIFTSTATE)');
  Cl.AddDelphiFunction('Function SHORTCUTTOTEXT( SHORTCUT : TSHORTCUT) : STRING'
   +'');
  Cl.AddDelphiFunction('Function TEXTTOSHORTCUT( TEXT : STRING) : TSHORTCUT');
  Cl.AddDelphiFunction('Function NEWMENU( OWNER : TCOMPONENT; const ANAME : STR'
   +'ING; ITEMS : array of TMenuItem) : TMAINMENU');
  Cl.AddDelphiFunction('Function NEWPOPUPMENU( OWNER : TCOMPONENT; const ANAME '
   +': STRING; ALIGNMENT : TPOPUPALIGNMENT; AUTOPOPUP : BOOLEAN; const ITEMS : array of '
   +'TCMENUITEM) : TPOPUPMENU');
  Cl.AddDelphiFunction('Function NEWSUBMENU( const ACAPTION : STRING; HCTX : WO'
   +'RD; const ANAME : STRING; ITEMS : array of TMenuItem; AENABLED : BOOLEAN) : TMENUITEM');
  Cl.AddDelphiFunction('Function NEWITEM( const ACAPTION : STRING; ASHORTCUT : '
   +'TSHORTCUT; ACHECKED, AENABLED : BOOLEAN; AONCLICK : TNOTIFYEVENT; HCTX : W'
   +'ORD; const ANAME : STRING) : TMENUITEM');
  Cl.AddDelphiFunction('Function NEWLINE : TMENUITEM');
  Cl.AddDelphiFunction('Procedure DRAWMENUITEM( MENUITEM : TMENUITEM; ACANVAS :'
   +' TCANVAS; ARECT : TRECT; STATE : TOWNERDRAWSTATE)');
end;

end.
