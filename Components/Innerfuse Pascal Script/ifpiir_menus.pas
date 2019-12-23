 {
@abstract(Menus Import Unit)
@author(Carlo Kok <ck@carlo-kok.com>)
Menus Import Unit
}
Unit ifpiir_menus;
{$I ifps3_def.inc}
Interface
Uses ifps3;

procedure RIRegister_Menus_Routines(S: TIFPSExec);
procedure RIRegisterTMENUITEMSTACK(Cl: TIFPSRuntimeClassImporter);
procedure RIRegisterTPOPUPLIST(Cl: TIFPSRuntimeClassImporter);
procedure RIRegisterTPOPUPMENU(Cl: TIFPSRuntimeClassImporter);
procedure RIRegisterTMAINMENU(Cl: TIFPSRuntimeClassImporter);
procedure RIRegisterTMENU(Cl: TIFPSRuntimeClassImporter);
procedure RIRegisterTMENUITEM(Cl: TIFPSRuntimeClassImporter);
procedure RIRegister_Menus(CL: TIFPSRuntimeClassImporter);

implementation
{$IFDEF LINUX}
Uses
  Libc, SysUtils, Classes, QControls, QMenus, QGraphics;
{$ELSE}
Uses WINDOWS, SYSUTILS, CLASSES, CONTNRS, MESSAGES, GRAPHICS, IMGLIST, ACTNLIST, Menus;
{$ENDIF}
procedure TPOPUPLISTWINDOW_R(Self: TPOPUPLIST; var T: HWND);
begin T := Self.WINDOW; end;

procedure TPOPUPMENUONPOPUP_W(Self: TPOPUPMENU; const T: TNOTIFYEVENT);
begin Self.ONPOPUP := T; end;

procedure TPOPUPMENUONPOPUP_R(Self: TPOPUPMENU; var T: TNOTIFYEVENT);
begin T := Self.ONPOPUP; end;

procedure TPOPUPMENUTRACKBUTTON_W(Self: TPOPUPMENU; const T: TTRACKBUTTON);
begin Self.TRACKBUTTON := T; end;

procedure TPOPUPMENUTRACKBUTTON_R(Self: TPOPUPMENU; var T: TTRACKBUTTON);
begin T := Self.TRACKBUTTON; end;

procedure TPOPUPMENUMENUANIMATION_W(Self: TPOPUPMENU; const T: TMENUANIMATION);
begin Self.MENUANIMATION := T; end;

procedure TPOPUPMENUMENUANIMATION_R(Self: TPOPUPMENU; var T: TMENUANIMATION);
begin T := Self.MENUANIMATION; end;

procedure TPOPUPMENUHELPCONTEXT_W(Self: TPOPUPMENU; const T: THELPCONTEXT);
begin Self.HELPCONTEXT := T; end;

procedure TPOPUPMENUHELPCONTEXT_R(Self: TPOPUPMENU; var T: THELPCONTEXT);
begin T := Self.HELPCONTEXT; end;

procedure TPOPUPMENUAUTOPOPUP_W(Self: TPOPUPMENU; const T: BOOLEAN);
begin Self.AUTOPOPUP := T; end;

procedure TPOPUPMENUAUTOPOPUP_R(Self: TPOPUPMENU; var T: BOOLEAN);
begin T := Self.AUTOPOPUP; end;

procedure TPOPUPMENUALIGNMENT_W(Self: TPOPUPMENU; const T: TPOPUPALIGNMENT);
begin Self.ALIGNMENT := T; end;

procedure TPOPUPMENUALIGNMENT_R(Self: TPOPUPMENU; var T: TPOPUPALIGNMENT);
begin T := Self.ALIGNMENT; end;

procedure TPOPUPMENUPOPUPCOMPONENT_W(Self: TPOPUPMENU; const T: TCOMPONENT);
begin Self.POPUPCOMPONENT := T; end;

procedure TPOPUPMENUPOPUPCOMPONENT_R(Self: TPOPUPMENU; var T: TCOMPONENT);
begin T := Self.POPUPCOMPONENT; end;

procedure TMAINMENUAUTOMERGE_W(Self: TMAINMENU; const T: BOOLEAN);
begin Self.AUTOMERGE := T; end;

procedure TMAINMENUAUTOMERGE_R(Self: TMAINMENU; var T: BOOLEAN);
begin T := Self.AUTOMERGE; end;

procedure TMENUITEMS_R(Self: TMENU; var T: TMENUITEM);
begin T := Self.ITEMS; end;

procedure TMENUWINDOWHANDLE_W(Self: TMENU; const T: HWND);
begin Self.WINDOWHANDLE := T; end;

procedure TMENUWINDOWHANDLE_R(Self: TMENU; var T: HWND);
begin T := Self.WINDOWHANDLE; end;

procedure TMENUPARENTBIDIMODE_W(Self: TMENU; const T: BOOLEAN);
begin Self.PARENTBIDIMODE := T; end;

procedure TMENUPARENTBIDIMODE_R(Self: TMENU; var T: BOOLEAN);
begin T := Self.PARENTBIDIMODE; end;

procedure TMENUOWNERDRAW_W(Self: TMENU; const T: BOOLEAN);
begin Self.OWNERDRAW := T; end;

procedure TMENUOWNERDRAW_R(Self: TMENU; var T: BOOLEAN);
begin T := Self.OWNERDRAW; end;

procedure TMENUHANDLE_R(Self: TMENU; var T: HMENU);
begin T := Self.HANDLE; end;

procedure TMENUBIDIMODE_W(Self: TMENU; const T: TBIDIMODE);
begin Self.BIDIMODE := T; end;

procedure TMENUBIDIMODE_R(Self: TMENU; var T: TBIDIMODE);
begin T := Self.BIDIMODE; end;

procedure TMENUAUTOLINEREDUCTION_W(Self: TMENU; const T: TMENUAUTOFLAG);
begin Self.AUTOLINEREDUCTION := T; end;

procedure TMENUAUTOLINEREDUCTION_R(Self: TMENU; var T: TMENUAUTOFLAG);
begin T := Self.AUTOLINEREDUCTION; end;

procedure TMENUAUTOHOTKEYS_W(Self: TMENU; const T: TMENUAUTOFLAG);
begin Self.AUTOHOTKEYS := T; end;

procedure TMENUAUTOHOTKEYS_R(Self: TMENU; var T: TMENUAUTOFLAG);
begin T := Self.AUTOHOTKEYS; end;

procedure TMENUIMAGES_W(Self: TMENU; const T: TCUSTOMIMAGELIST);
begin Self.IMAGES := T; end;

procedure TMENUIMAGES_R(Self: TMENU; var T: TCUSTOMIMAGELIST);
begin T := Self.IMAGES; end;

procedure TMENUITEMONMEASUREITEM_W(Self: TMENUITEM; const T: TMENUMEASUREITEMEVENT);
begin Self.ONMEASUREITEM := T; end;

procedure TMENUITEMONMEASUREITEM_R(Self: TMENUITEM; var T: TMENUMEASUREITEMEVENT);
begin T := Self.ONMEASUREITEM; end;

procedure TMENUITEMONADVANCEDDRAWITEM_W(Self: TMENUITEM; const T: TADVANCEDMENUDRAWITEMEVENT);
begin Self.ONADVANCEDDRAWITEM := T; end;

procedure TMENUITEMONADVANCEDDRAWITEM_R(Self: TMENUITEM; var T: TADVANCEDMENUDRAWITEMEVENT);
begin T := Self.ONADVANCEDDRAWITEM; end;

procedure TMENUITEMONDRAWITEM_W(Self: TMENUITEM; const T: TMENUDRAWITEMEVENT);
begin Self.ONDRAWITEM := T; end;

procedure TMENUITEMONDRAWITEM_R(Self: TMENUITEM; var T: TMENUDRAWITEMEVENT);
begin T := Self.ONDRAWITEM; end;

procedure TMENUITEMONCLICK_W(Self: TMENUITEM; const T: TNOTIFYEVENT);
begin Self.ONCLICK := T; end;

procedure TMENUITEMONCLICK_R(Self: TMENUITEM; var T: TNOTIFYEVENT);
begin T := Self.ONCLICK; end;

procedure TMENUITEMVISIBLE_W(Self: TMENUITEM; const T: BOOLEAN);
begin Self.VISIBLE := T; end;

procedure TMENUITEMVISIBLE_R(Self: TMENUITEM; var T: BOOLEAN);
begin T := Self.VISIBLE; end;

procedure TMENUITEMSHORTCUT_W(Self: TMENUITEM; const T: TSHORTCUT);
begin Self.SHORTCUT := T; end;

procedure TMENUITEMSHORTCUT_R(Self: TMENUITEM; var T: TSHORTCUT);
begin T := Self.SHORTCUT; end;

procedure TMENUITEMRADIOITEM_W(Self: TMENUITEM; const T: BOOLEAN);
begin Self.RADIOITEM := T; end;

procedure TMENUITEMRADIOITEM_R(Self: TMENUITEM; var T: BOOLEAN);
begin T := Self.RADIOITEM; end;

procedure TMENUITEMIMAGEINDEX_W(Self: TMENUITEM; const T: TIMAGEINDEX);
begin Self.IMAGEINDEX := T; end;

procedure TMENUITEMIMAGEINDEX_R(Self: TMENUITEM; var T: TIMAGEINDEX);
begin T := Self.IMAGEINDEX; end;

procedure TMENUITEMHINT_W(Self: TMENUITEM; const T: STRING);
begin Self.HINT := T; end;

procedure TMENUITEMHINT_R(Self: TMENUITEM; var T: STRING);
begin T := Self.HINT; end;

procedure TMENUITEMHELPCONTEXT_W(Self: TMENUITEM; const T: THELPCONTEXT);
begin Self.HELPCONTEXT := T; end;

procedure TMENUITEMHELPCONTEXT_R(Self: TMENUITEM; var T: THELPCONTEXT);
begin T := Self.HELPCONTEXT; end;

procedure TMENUITEMGROUPINDEX_W(Self: TMENUITEM; const T: BYTE);
begin Self.GROUPINDEX := T; end;

procedure TMENUITEMGROUPINDEX_R(Self: TMENUITEM; var T: BYTE);
begin T := Self.GROUPINDEX; end;

procedure TMENUITEMENABLED_W(Self: TMENUITEM; const T: BOOLEAN);
begin Self.ENABLED := T; end;

procedure TMENUITEMENABLED_R(Self: TMENUITEM; var T: BOOLEAN);
begin T := Self.ENABLED; end;

procedure TMENUITEMDEFAULT_W(Self: TMENUITEM; const T: BOOLEAN);
begin Self.DEFAULT := T; end;

procedure TMENUITEMDEFAULT_R(Self: TMENUITEM; var T: BOOLEAN);
begin T := Self.DEFAULT; end;

procedure TMENUITEMSUBMENUIMAGES_W(Self: TMENUITEM; const T: TCUSTOMIMAGELIST);
begin Self.SUBMENUIMAGES := T; end;

procedure TMENUITEMSUBMENUIMAGES_R(Self: TMENUITEM; var T: TCUSTOMIMAGELIST);
begin T := Self.SUBMENUIMAGES; end;

procedure TMENUITEMCHECKED_W(Self: TMENUITEM; const T: BOOLEAN);
begin Self.CHECKED := T; end;

procedure TMENUITEMCHECKED_R(Self: TMENUITEM; var T: BOOLEAN);
begin T := Self.CHECKED; end;

procedure TMENUITEMCAPTION_W(Self: TMENUITEM; const T: STRING);
begin Self.CAPTION := T; end;

procedure TMENUITEMCAPTION_R(Self: TMENUITEM; var T: STRING);
begin T := Self.CAPTION; end;

procedure TMENUITEMBITMAP_W(Self: TMENUITEM; const T: TBITMAP);
begin Self.BITMAP := T; end;

procedure TMENUITEMBITMAP_R(Self: TMENUITEM; var T: TBITMAP);
begin T := Self.BITMAP; end;

procedure TMENUITEMAUTOLINEREDUCTION_W(Self: TMENUITEM; const T: TMENUITEMAUTOFLAG);
begin Self.AUTOLINEREDUCTION := T; end;

procedure TMENUITEMAUTOLINEREDUCTION_R(Self: TMENUITEM; var T: TMENUITEMAUTOFLAG);
begin T := Self.AUTOLINEREDUCTION; end;

procedure TMENUITEMAUTOHOTKEYS_W(Self: TMENUITEM; const T: TMENUITEMAUTOFLAG);
begin Self.AUTOHOTKEYS := T; end;

procedure TMENUITEMAUTOHOTKEYS_R(Self: TMENUITEM; var T: TMENUITEMAUTOFLAG);
begin T := Self.AUTOHOTKEYS; end;

procedure TMENUITEMACTION_W(Self: TMENUITEM; const T: TBASICACTION);
begin Self.ACTION := T; end;

procedure TMENUITEMACTION_R(Self: TMENUITEM; var T: TBASICACTION);
begin T := Self.ACTION; end;

procedure TMENUITEMPARENT_R(Self: TMENUITEM; var T: TMENUITEM);
begin T := Self.PARENT; end;

procedure TMENUITEMMENUINDEX_W(Self: TMENUITEM; const T: INTEGER);
begin Self.MENUINDEX := T; end;

procedure TMENUITEMMENUINDEX_R(Self: TMENUITEM; var T: INTEGER);
begin T := Self.MENUINDEX; end;

procedure TMENUITEMITEMS_R(Self: TMENUITEM; var T: TMENUITEM; const t1: INTEGER);
begin T := Self.ITEMS[t1]; end;

procedure TMENUITEMCOUNT_R(Self: TMENUITEM; var T: INTEGER);
begin T := Self.COUNT; end;

procedure TMENUITEMHANDLE_R(Self: TMENUITEM; var T: HMENU);
begin T := Self.HANDLE; end;

procedure TMENUITEMCOMMAND_R(Self: TMENUITEM; var T: WORD);
begin T := Self.COMMAND; end;

procedure RIRegister_Menus_Routines(S: TIFPSExec);
begin
  S.RegisterDelphiFunction(@SHORTCUT, 'SHORTCUT', cdRegister);
  S.RegisterDelphiFunction(@SHORTCUTTOKEY, 'SHORTCUTTOKEY', cdRegister);
  S.RegisterDelphiFunction(@SHORTCUTTOTEXT, 'SHORTCUTTOTEXT', cdRegister);
  S.RegisterDelphiFunction(@TEXTTOSHORTCUT, 'TEXTTOSHORTCUT', cdRegister);
  S.RegisterDelphiFunction(@NEWMENU, 'NEWMENU', cdRegister);
  S.RegisterDelphiFunction(@NEWPOPUPMENU, 'NEWPOPUPMENU', cdRegister);
  S.RegisterDelphiFunction(@NEWSUBMENU, 'NEWSUBMENU', cdRegister);
  S.RegisterDelphiFunction(@NEWITEM, 'NEWITEM', cdRegister);
  S.RegisterDelphiFunction(@NEWLINE, 'NEWLINE', cdRegister);
  S.RegisterDelphiFunction(@DRAWMENUITEM, 'DRAWMENUITEM', cdRegister);
end;

procedure RIRegisterTMENUITEMSTACK(Cl: TIFPSRuntimeClassImporter);
begin
  with Cl.Add(TMENUITEMSTACK) do
  begin
    RegisterMethod(@TMENUITEMSTACK.CLEARITEM, 'CLEARITEM');
  end;
end;

procedure RIRegisterTPOPUPLIST(Cl: TIFPSRuntimeClassImporter);
begin
  with Cl.Add(TPOPUPLIST) do
  begin
    RegisterPropertyHelper(@TPOPUPLISTWINDOW_R,nil,'WINDOW');
    RegisterMethod(@TPOPUPLIST.ADD, 'ADD');
    RegisterMethod(@TPOPUPLIST.REMOVE, 'REMOVE');
  end;
end;

procedure RIRegisterTPOPUPMENU(Cl: TIFPSRuntimeClassImporter);
begin
  with Cl.Add(TPOPUPMENU) do
  begin
    RegisterConstructor(@TPOPUPMENU.CREATE, 'CREATE');
    RegisterVirtualMethod(@TPOPUPMENU.POPUP, 'POPUP');
    RegisterPropertyHelper(@TPOPUPMENUPOPUPCOMPONENT_R,@TPOPUPMENUPOPUPCOMPONENT_W,'POPUPCOMPONENT');
    RegisterPropertyHelper(@TPOPUPMENUALIGNMENT_R,@TPOPUPMENUALIGNMENT_W,'ALIGNMENT');
    RegisterPropertyHelper(@TPOPUPMENUAUTOPOPUP_R,@TPOPUPMENUAUTOPOPUP_W,'AUTOPOPUP');
    RegisterPropertyHelper(@TPOPUPMENUHELPCONTEXT_R,@TPOPUPMENUHELPCONTEXT_W,'HELPCONTEXT');
    RegisterPropertyHelper(@TPOPUPMENUMENUANIMATION_R,@TPOPUPMENUMENUANIMATION_W,'MENUANIMATION');
    RegisterPropertyHelper(@TPOPUPMENUTRACKBUTTON_R,@TPOPUPMENUTRACKBUTTON_W,'TRACKBUTTON');
    RegisterEventPropertyHelper(@TPOPUPMENUONPOPUP_R,@TPOPUPMENUONPOPUP_W,'ONPOPUP');
  end;
end;

procedure RIRegisterTMAINMENU(Cl: TIFPSRuntimeClassImporter);
begin
  with Cl.Add(TMAINMENU) do
  begin
    RegisterMethod(@TMAINMENU.MERGE, 'MERGE');
    RegisterMethod(@TMAINMENU.UNMERGE, 'UNMERGE');
    RegisterMethod(@TMAINMENU.POPULATEOLE2MENU, 'POPULATEOLE2MENU');
    RegisterMethod(@TMAINMENU.GETOLE2ACCELERATORTABLE, 'GETOLE2ACCELERATORTABLE');
    RegisterMethod(@TMAINMENU.SETOLE2MENUHANDLE, 'SETOLE2MENUHANDLE');
    RegisterPropertyHelper(@TMAINMENUAUTOMERGE_R,@TMAINMENUAUTOMERGE_W,'AUTOMERGE');
  end;
end;

procedure RIRegisterTMENU(Cl: TIFPSRuntimeClassImporter);
begin
  with Cl.Add(TMENU) do
  begin
    RegisterConstructor(@TMENU.CREATE, 'CREATE');
    RegisterMethod(@TMENU.DISPATCHCOMMAND, 'DISPATCHCOMMAND');
    RegisterMethod(@TMENU.DISPATCHPOPUP, 'DISPATCHPOPUP');
    RegisterMethod(@TMENU.FINDITEM, 'FINDITEM');
    RegisterMethod(@TMENU.GETHELPCONTEXT, 'GETHELPCONTEXT');
    RegisterPropertyHelper(@TMENUIMAGES_R,@TMENUIMAGES_W,'IMAGES');
    RegisterMethod(@TMENU.ISRIGHTTOLEFT, 'ISRIGHTTOLEFT');
    RegisterMethod(@TMENU.PARENTBIDIMODECHANGED, 'PARENTBIDIMODECHANGED');
    RegisterMethod(@TMENU.PROCESSMENUCHAR, 'PROCESSMENUCHAR');
    RegisterPropertyHelper(@TMENUAUTOHOTKEYS_R,@TMENUAUTOHOTKEYS_W,'AUTOHOTKEYS');
    RegisterPropertyHelper(@TMENUAUTOLINEREDUCTION_R,@TMENUAUTOLINEREDUCTION_W,'AUTOLINEREDUCTION');
    RegisterPropertyHelper(@TMENUBIDIMODE_R,@TMENUBIDIMODE_W,'BIDIMODE');
    RegisterPropertyHelper(@TMENUHANDLE_R,nil,'HANDLE');
    RegisterPropertyHelper(@TMENUOWNERDRAW_R,@TMENUOWNERDRAW_W,'OWNERDRAW');
    RegisterPropertyHelper(@TMENUPARENTBIDIMODE_R,@TMENUPARENTBIDIMODE_W,'PARENTBIDIMODE');
    RegisterPropertyHelper(@TMENUWINDOWHANDLE_R,@TMENUWINDOWHANDLE_W,'WINDOWHANDLE');
    RegisterPropertyHelper(@TMENUITEMS_R,nil,'ITEMS');
  end;
end;

procedure RIRegisterTMENUITEM(Cl: TIFPSRuntimeClassImporter);
begin
  with Cl.Add(TMENUITEM) do
  begin
    RegisterConstructor(@TMENUITEM.CREATE, 'CREATE');
    RegisterVirtualMethod(@TMENUITEM.INITIATEACTION, 'INITIATEACTION');
    RegisterMethod(@TMENUITEM.INSERT, 'INSERT');
    RegisterMethod(@TMENUITEM.DELETE, 'DELETE');
    RegisterMethod(@TMENUITEM.CLEAR, 'CLEAR');
    RegisterVirtualMethod(@TMENUITEM.CLICK, 'CLICK');
    RegisterMethod(@TMENUITEM.FIND, 'FIND');
    RegisterMethod(@TMENUITEM.INDEXOF, 'INDEXOF');
    RegisterMethod(@TMENUITEM.ISLINE, 'ISLINE');
    RegisterMethod(@TMENUITEM.GETIMAGELIST, 'GETIMAGELIST');
    RegisterMethod(@TMENUITEM.GETPARENTCOMPONENT, 'GETPARENTCOMPONENT');
    RegisterMethod(@TMENUITEM.GETPARENTMENU, 'GETPARENTMENU');
    RegisterMethod(@TMENUITEM.HASPARENT, 'HASPARENT');
    RegisterMethod(@TMENUITEM.NEWTOPLINE, 'NEWTOPLINE');
    RegisterMethod(@TMENUITEM.NEWBOTTOMLINE, 'NEWBOTTOMLINE');
    RegisterMethod(@TMENUITEM.INSERTNEWLINEBEFORE, 'INSERTNEWLINEBEFORE');
    RegisterMethod(@TMENUITEM.INSERTNEWLINEAFTER, 'INSERTNEWLINEAFTER');
    RegisterMethod(@TMENUITEM.ADD, 'ADD');
    RegisterMethod(@TMENUITEM.REMOVE, 'REMOVE');
    RegisterMethod(@TMENUITEM.RETHINKHOTKEYS, 'RETHINKHOTKEYS');
    RegisterMethod(@TMENUITEM.RETHINKLINES, 'RETHINKLINES');
    RegisterPropertyHelper(@TMENUITEMCOMMAND_R,nil,'COMMAND');
    RegisterPropertyHelper(@TMENUITEMHANDLE_R,nil,'HANDLE');
    RegisterPropertyHelper(@TMENUITEMCOUNT_R,nil,'COUNT');
    RegisterPropertyHelper(@TMENUITEMITEMS_R,nil,'ITEMS');
    RegisterPropertyHelper(@TMENUITEMMENUINDEX_R,@TMENUITEMMENUINDEX_W,'MENUINDEX');
    RegisterPropertyHelper(@TMENUITEMPARENT_R,nil,'PARENT');
    RegisterPropertyHelper(@TMENUITEMACTION_R,@TMENUITEMACTION_W,'ACTION');
    RegisterPropertyHelper(@TMENUITEMAUTOHOTKEYS_R,@TMENUITEMAUTOHOTKEYS_W,'AUTOHOTKEYS');
    RegisterPropertyHelper(@TMENUITEMAUTOLINEREDUCTION_R,@TMENUITEMAUTOLINEREDUCTION_W,'AUTOLINEREDUCTION');
    RegisterPropertyHelper(@TMENUITEMBITMAP_R,@TMENUITEMBITMAP_W,'BITMAP');
    RegisterPropertyHelper(@TMENUITEMCAPTION_R,@TMENUITEMCAPTION_W,'CAPTION');
    RegisterPropertyHelper(@TMENUITEMCHECKED_R,@TMENUITEMCHECKED_W,'CHECKED');
    RegisterPropertyHelper(@TMENUITEMSUBMENUIMAGES_R,@TMENUITEMSUBMENUIMAGES_W,'SUBMENUIMAGES');
    RegisterPropertyHelper(@TMENUITEMDEFAULT_R,@TMENUITEMDEFAULT_W,'DEFAULT');
    RegisterPropertyHelper(@TMENUITEMENABLED_R,@TMENUITEMENABLED_W,'ENABLED');
    RegisterPropertyHelper(@TMENUITEMGROUPINDEX_R,@TMENUITEMGROUPINDEX_W,'GROUPINDEX');
    RegisterPropertyHelper(@TMENUITEMHELPCONTEXT_R,@TMENUITEMHELPCONTEXT_W,'HELPCONTEXT');
    RegisterPropertyHelper(@TMENUITEMHINT_R,@TMENUITEMHINT_W,'HINT');
    RegisterPropertyHelper(@TMENUITEMIMAGEINDEX_R,@TMENUITEMIMAGEINDEX_W,'IMAGEINDEX');
    RegisterPropertyHelper(@TMENUITEMRADIOITEM_R,@TMENUITEMRADIOITEM_W,'RADIOITEM');
    RegisterPropertyHelper(@TMENUITEMSHORTCUT_R,@TMENUITEMSHORTCUT_W,'SHORTCUT');
    RegisterPropertyHelper(@TMENUITEMVISIBLE_R,@TMENUITEMVISIBLE_W,'VISIBLE');
    RegisterEventPropertyHelper(@TMENUITEMONCLICK_R,@TMENUITEMONCLICK_W,'ONCLICK');
    RegisterEventPropertyHelper(@TMENUITEMONDRAWITEM_R,@TMENUITEMONDRAWITEM_W,'ONDRAWITEM');
    RegisterEventPropertyHelper(@TMENUITEMONADVANCEDDRAWITEM_R,@TMENUITEMONADVANCEDDRAWITEM_W,'ONADVANCEDDRAWITEM');
    RegisterEventPropertyHelper(@TMENUITEMONMEASUREITEM_R,@TMENUITEMONMEASUREITEM_W,'ONMEASUREITEM');
  end;
end;

procedure RIRegister_Menus(CL: TIFPSRuntimeClassImporter);
begin
  RIRegisterTMENUITEM(Cl);
  RIRegisterTMENU(Cl);
  RIRegisterTMAINMENU(Cl);
  RIRegisterTPOPUPMENU(Cl);
  RIRegisterTPOPUPLIST(Cl);
  RIRegisterTMENUITEMSTACK(Cl);
end;

end.
