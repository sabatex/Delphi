{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvExCheckLst.pas, released on 2004-01-04

The Initial Developer of the Original Code is Andreas Hausladen [Andreas dott Hausladen att gmx dott de]
Portions created by Andreas Hausladen are Copyright (C) 2004 Andreas Hausladen.
All Rights Reserved.

Contributor(s): -

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvQExCheckLst.pas,v 1.34 2005/11/01 20:47:11 asnepvangers Exp $

unit JvQExCheckLst;

{$I jvcl.inc}
{MACROINCLUDE JvQExControls.macros}

{*****************************************************************************
 * WARNING: Do not edit this file.
 * This file is autogenerated from the source in devtools/JvExCLX/src.
 * If you do it despite this warning your changes will be discarded by the next
 * update of this file. Do your changes in the template files.
 ****************************************************************************}

interface

uses
  Classes, SysUtils,
  QGraphics, QControls, QForms, QCheckLst, QExtCtrls,
  Qt, QWindows, QMessages,
  JvQTypes, JvQThemes, JVCLXVer, JvQExControls;

type
  { QWinControl Begin }
  TJvExCheckListBox = class(TCheckListBox)
  { QControl }
  private
    FAboutJVCL: TJVCLAboutInfo;
    FDesktopFont: Boolean;
    FDragCursor: TCursor;
    FDragKind: TDragKind;
    FHintColor: TColor;
    FMouseOver: Boolean;
    FOnParentColorChanged: TNotifyEvent;
    FWindowProc: TWndMethod;
    procedure SetDesktopFont(Value: Boolean);
    procedure CMHitTest(var Mesg: TJvMessage); message CM_HITTEST;
    procedure CMHintShow(var Mesg: TJvMessage); message CM_HINTSHOW;
    procedure CMSysFontChanged(var Mesg: TMessage); message CM_SYSFONTCHANGED;
  protected
    procedure ColorChanged; override;
    procedure EnabledChanged; override;
    procedure FocusChanged(FocusedControl: TWidgetControl); dynamic;
    function HitTest(X, Y: integer): Boolean; override;
    procedure MouseEnter(AControl: TControl); override;
    procedure MouseLeave(AControl: TControl); override;
    procedure ParentColorChanged; override;
    procedure TextChanged; override;
    procedure VisibleChanged; override;
    function HintShow(var HintInfo : THintInfo): Boolean; override;
    procedure WndProc(var Mesg: TMessage); dynamic;
    property DragCursor: TCursor read FDragCursor write FDragCursor default crDefault; { not implemented }
    property DragKind: TDragKind read FDragKind write FDragKind  default dkDrag; { not implemented }
    property OnParentColorChange: TNotifyEvent read FOnParentColorChanged write FOnParentColorChanged;
    property DesktopFont: Boolean read FDesktopFont write SetDesktopFont default false;
  public
    procedure Dispatch(var Mesg); override;
    function Perform(Msg: Cardinal; WParam, LParam: Longint): Longint;
    function IsRightToLeft: Boolean;
    property WindowProc: TWndMethod read FWindowProc write FWindowProc;
    property MouseOver: Boolean read FMouseOver write FMouseOver;
  published
    property AboutJVCLX: TJVCLAboutInfo read FAboutJVCL write FAboutJVCL stored False;
    property HintColor: TColor read FHintColor write FHintColor default clDefault;
  { QWinControl }
  private
    FInternalFontChanged: TNotifyEvent;
    FOnEvent: TEventEvent;
    procedure DoOnFontChanged(Sender: TObject);
    procedure CMDesignHitTest(var Mesg: TJvMessage); message CM_DESIGNHITTEST;
  protected
    procedure CreateWidget; override;
    procedure CreateWnd; virtual;
    procedure CursorChanged; override;
    procedure DoEnter; override;
    function DoEraseBackground(Canvas: TCanvas; Param: Integer): Boolean; virtual;
    procedure DoExit; override;
    procedure FocusKilled(NextWnd: QWidgetH); dynamic;
    procedure FocusSet(PrevWnd: QWidgetH); dynamic;
    function EventFilter(Sender: QObjectH; Event: QEventH): Boolean; override;
    procedure PaintWindow(PaintDevice: QPaintDeviceH);
    procedure RecreateWnd;
    procedure ShowingChanged; override;
    function WidgetFlags: Integer; override;
  public
    function ColorToRGB(Value: TColor): TColor;
    procedure PaintTo(PaintDevice: QPaintDeviceH; X, Y: Integer);
  published
    property OnEvent: TEventEvent read FOnEvent write FOnEvent;
  { QWinCustomControl }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  { QWinCustomControl }
  TJvExPubCheckListBox = class(TJvExCheckListBox);
  

implementation

{ QWinCustomControl Create }

constructor TJvExCheckListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWindowProc := WndProc;
  FInternalFontChanged := Font.OnChange;
  Font.OnChange := DoOnFontChanged;
  FHintColor := clDefault;
  
end;

destructor TJvExCheckListBox.Destroy;
begin
  
  inherited Destroy;
end;

procedure TJvExCheckListBox.WndProc(var Mesg: TMessage);
begin
  //OutputDebugString(PAnsiChar(Format('WINCONTROL %s: %s Msg $%x',[Name, ClassName, Mesg.Msg])));
  with TJvMessage(Mesg) do
  begin
    case Msg of
      { WinControl Messages }
      WM_GETDLGCODE   : Result := InputKeysToDlgCodes(InputKeys);
      CM_FONTCHANGED  : FInternalFontChanged(Font);
      WM_SETFOCUS     : FocusSet(QWidgetH(LParam));
      WM_KILLFOCUS    : FocusKilled(QWidgetH(LParam));
      CM_HINTSHOW:
      begin
        HintInfo^.HintColor := GetHintcolor(Self);
        inherited Dispatch(Mesg);
      end;

      WM_ERASEBKGND:
      begin
        Canvas.Start;
        try
          Handled := DoEraseBackGround(Canvas, LParam);
        finally
          Canvas.Stop;
        end;
      end;
      { Control Messages }
      CM_FOCUSCHANGED: FocusChanged(TWidgetControl(Mesg.LParam));
      CM_MOUSEENTER: FMouseOver := True;
      CM_MOUSELEAVE: FMouseOver := False;

    else
      inherited Dispatch(Mesg);
    end;
  end;
end;
{ QWinControl Common }
procedure TJvExCheckListBox.CMDesignHitTest(var Mesg: TJvMessage);
begin
  with Mesg do
  begin
    Handled := inherited HitTest(XPos, YPos);
    if Handled then
      Result := HTCLIENT;
  end;
end;

procedure TJvExCheckListBox.CMHitTest(var Mesg: TJvMessage);
begin
  with Mesg do
  begin
    if csDesigning in ComponentState then
      Result := Perform(CM_DESIGNHITTEST, XPos, YPos)
    else
    begin
      Handled := inherited HitTest(XPos, YPos);
      if Handled then
        Result := HTCLIENT;
    end;
  end;
end;

function TJvExCheckListBox.DoEraseBackground(Canvas: TCanvas; Param: Integer): Boolean;
begin
  Result := false;
end;

procedure TJvExCheckListBox.ShowingChanged;
begin
  Perform(CM_SHOWINGCHANGED, 0 ,0);
  inherited;
end;

procedure TJvExCheckListBox.ColorChanged;
begin
  Perform(CM_COLORCHANGED, 0, 0);
  inherited;
end;

procedure TJvExCheckListBox.CursorChanged;
begin
  Perform(CM_CURSORCHANGED, 0, 0);
  inherited;
end;

procedure TJvExCheckListBox.DoEnter;
begin
  Perform(CM_ENTER, 0 ,0);
  inherited DoEnter;
end;

procedure TJvExCheckListBox.DoExit;
begin
  Perform(CM_EXIT, 0 ,0);
  inherited DoExit;
end;

function TJvExCheckListBox.EventFilter(Sender: QObjectH; Event: QEventH): Boolean;
begin
  Result := False;
  if Assigned(FOnEvent) then
    FOnEvent(Sender, Event, Result);
  if not Result then
    Result := inherited EventFilter(Sender, Event);
end;

procedure TJvExCheckListBox.FocusKilled(NextWnd: QWidgetH);
begin

end;

procedure TJvExCheckListBox.FocusSet(PrevWnd: QWidgetH);
begin

end;

procedure TJvExCheckListBox.FocusChanged(FocusedControl: TWidgetControl);
begin

end;

procedure TJvExCheckListBox.DoOnFontChanged(Sender: TObject);
begin
  ParentFont := False;
  PostMessage(Self, CM_FONTCHANGED, 0, 0);
end;

procedure TJvExCheckListBox.CreateWidget;
begin
  CreateWnd;
end;

procedure TJvExCheckListBox.CreateWnd;
begin
  inherited CreateWidget;
end;

procedure TJvExCheckListBox.RecreateWnd;
begin
  RecreateWidget;
end;

procedure TJvExCheckListBox.PaintTo(PaintDevice: QPaintDeviceH; X, Y: Integer);
begin
  WidgetControl_PaintTo(self, PaintDevice, X, Y);
end;

procedure TJvExCheckListBox.PaintWindow(PaintDevice: QPaintDeviceH);
begin
  PaintTo(PaintDevice, 0, 0);
end;

function TJvExCheckListBox.WidgetFlags: Integer;
begin
  Result := inherited WidgetFlags or
    Integer(WidgetFlags_WMouseNoMask);
end;

function TJvExCheckListBox.ColorToRGB(Value: TColor): TColor;
begin
  Result := QWindows.ColorToRGB(Value, self);
end;
  
{ QControl Common}

function TJvExCheckListBox.HitTest(X, Y: integer): Boolean;
begin
   Result := Perform(CM_HITTEST, 0, 0) <> HTNOWHERE;
end;

procedure TJvExCheckListBox.CMHintShow(var Mesg: TJvMessage);
begin
  with Mesg do
  begin
    Handled := inherited HintShow(HintInfo^);
  end;
end;

procedure TJvExCheckListBox.CMSysFontChanged(var Mesg: TMessage);
begin
  if FDesktopFont then
  begin
    Font.Assign(Application.Font);
    FDesktopFont := True;
  end;
end;

procedure TJvExCheckListBox.EnabledChanged;
begin
  Perform(CM_ENABLEDCHANGED, 0, 0);
  inherited EnabledChanged;
end;

procedure TJvExCheckListBox.TextChanged;
begin
  Perform(CM_TEXTCHANGED, 0, 0);
  inherited TextChanged;
end;

procedure TJvExCheckListBox.VisibleChanged;
begin
  Perform(CM_VISIBLECHANGED, 0, 0);
  inherited VisibleChanged;
end;

function TJvExCheckListBox.HintShow(var HintInfo : THintInfo): Boolean;
begin
  Result := Perform(CM_HINTSHOW, 0, Integer(@HintInfo)) <> 0;
end;

procedure TJvExCheckListBox.MouseEnter(AControl: TControl);
begin
  Perform(CM_MOUSEENTER, 0, 0);
  inherited MouseEnter(AControl);
end;

procedure TJvExCheckListBox.MouseLeave(AControl: TControl);
begin
  Perform(CM_MOUSELEAVE, 0, 0);
  inherited MouseLeave(AControl);
end;

procedure TJvExCheckListBox.ParentColorChanged;
begin
  inherited ParentColorChanged;
  if Assigned(FOnParentColorChanged) then
    FOnParentColorChanged(Self);
end;

procedure TJvExCheckListBox.SetDesktopFont(Value: Boolean);
begin
  if FDesktopFont <> Value then
  begin
    FDesktopFont := Value;
    Perform(CM_SYSFONTCHANGED, 0, 0);
  end;
end;

procedure TJvExCheckListBox.Dispatch(var Mesg);
begin
  if Assigned(FWindowProc) then
    FWindowProc(TMessage(Mesg))
  else
    WndProc(TMessage(Mesg))
end;

function TJvExCheckListBox.Perform(Msg: Cardinal; WParam, LParam: Longint): Longint;
var
  Mesg: TMessage;
begin
  Mesg.Msg := Msg;
  Mesg.WParam := WParam;
  Mesg.LParam := LParam;
  Mesg.Result := 0;
  Dispatch(Mesg);
  Result := Mesg.Result;
end;

function TJvExCheckListBox.IsRightToLeft: Boolean;
begin
  Result := False;
end;
  
 

{$DEFINE UnitName 'JvQExCheckLst.pas'}

const
  UnitVersion = 'JvQExCheckLst.pas';

initialization
  OutputDebugString(PChar('JvExCLX Loaded: ' + UnitVersion));

finalization
  OutputDebugString(PChar('JvExCLX Unloaded: ' + UnitVersion));


end.
