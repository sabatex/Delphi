{******************************************************************************}
{* WARNING:  JEDI VCL To CLX Converter generated unit.                        *}
{*           Manual modifications will be lost on next release.               *}
{******************************************************************************}

{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvEnterTab.PAS, released on 2002-05-26.

The Initial Developer of the Original Code is Peter Th�rnqvist [peter3 at sourceforge dot net]
Portions created by Peter Th�rnqvist are Copyright (C) 2002 Peter Th�rnqvist.
All Rights Reserved.

Contributor(s):            
You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Description:
  A unit that converts all Enter keypresses to Tab keypresses.

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvQEnterTab.pas,v 1.15 2005/02/06 14:06:05 asnepvangers Exp $

unit JvQEnterTab;

{$I jvcl.inc}

interface

uses
  QWindows, QMessages, Classes, QGraphics, QControls, 
  Qt, JvQConsts,
//  JvQComponent;
  JvQEventFilter;

type

//  TJvEnterAsTab = class(TJvGraphicControl)
  TJvEnterAsTab = class(TJvAppEventFilter)
  private
    FEnterAsTab: Boolean;
    FAllowDefault: Boolean;
//    FBmp: TBitmap;
  protected
//    function TabKeyHook(Sender: QObjectH; Event: QEventH): Boolean; virtual;
    function EventFilter(Sender: QObjectH; Event: QEventH): Boolean; override;
//    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
//    destructor Destroy; override;
//    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer;
//      AHeight: Integer); override;
  published
    property EnterAsTab: Boolean read FEnterAsTab write FEnterAsTab default True;
    property AllowDefault: Boolean read FAllowDefault write FAllowDefault default True;
  end;

implementation

uses
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  QForms, QStdCtrls;

{$IFDEF MSWINDOWS}
{$R ..\Resources\JvEnterTab.res}
{$ENDIF MSWINDOWS}
{$IFDEF UNIX}
{$R ../Resources/JvEnterTab.res}
{$ENDIF UNIX}

constructor TJvEnterAsTab.Create(AOwner: TComponent);
begin
  FEnterAsTab := True;
  FAllowDefault := True;
  inherited Create(AOwner);
(*  ControlStyle := ControlStyle + [csNoStdEvents, csFixedHeight, csFixedWidth];
  if csDesigning in ComponentState then
  begin
    FBmp := TBitmap.Create;
    FBmp.LoadFromResourceName(HInstance, 'DESIGNENTERASTAB');
  end
  else
    Visible := False;
  InstallApplicationHook(TabKeyHook);
*)
end;

(*
destructor TJvEnterAsTab.Destroy;
begin
  UninstallApplicationHook(TabKeyHook);
  FBmp.Free;
  inherited Destroy;
end;
*)


//function TJvEnterAsTab.TabKeyHook(Sender: QObjectH; Event: QEventH): Boolean;
function TJvEnterAsTab.EventFilter(Sender: QObjectH; Event: QEventH): Boolean;
var
  ws: WideString;
begin
  Result := False;
  if QEvent_type(Event) = QEventType_KeyPress then
  begin
    if QObject_inherits(Sender, 'QButton') and AllowDefault then
      Exit;

    if ((QKeyEvent_key(QKeyEventH(Event)) = Key_Enter) or
      (QKeyEvent_key(QKeyEventH(Event)) = Key_Return) ) and EnterAsTab then
    begin
      ws := Tab;

      QApplication_postEvent(TCustomForm(Owner).Handle,
        QKeyEvent_create(QEventType_KeyPress, Key_Tab, Ord(Tab), 0, @ws, False, 1));
      QApplication_postEvent(TCustomForm(Owner).Handle,
        QKeyEvent_create(QEventType_KeyRelease, Key_Tab, Ord(Tab), 0, @ws, False, 1));

      Result := True;
    end;
  end;
end;

(*
procedure TJvEnterAsTab.Paint;
begin
  if not (csDesigning in ComponentState) then
    Exit;
  with Canvas do
  begin
    Brush.Color := clBtnFace;
    BrushCopy( Canvas,  ClientRect, FBmp, ClientRect, clFuchsia);
  end;
end;

procedure TJvEnterAsTab.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, 28, 28);
end;
*)

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$RCSfile: JvQEnterTab.pas,v $';
    Revision: '$Revision: 1.15 $';
    Date: '$Date: 2005/02/06 14:06:05 $';
    LogPath: 'JVCL\run'
  );

initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.

