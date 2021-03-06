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

The Original Code is: JvMaskEdit.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is Sébastien Buysse [sbuysse att buypin dott com]
Portions created by Sébastien Buysse are Copyright (C) 2001 Sébastien Buysse.
All Rights Reserved.

Contributor(s): Michael Beck [mbeck att bigfoot dott com],
                Rob den Braasem [rbraasem att xs4all dott nl],
                Oliver Giesen [ogware att gmx dott net],
                Peter Thornqvist [peter3 at sourceforge dot net].

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvQMaskEdit.pas,v 1.24 2005/11/01 20:47:11 asnepvangers Exp $

unit JvQMaskEdit;

{$I jvcl.inc}

interface

uses
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  QWindows, QMessages,
  SysUtils, Classes, QGraphics, QControls, QMask, QForms, QStdCtrls,
  JvQComponent, JvQTypes, JvQCaret, JvQToolEdit, JvQExMask;

type
  TJvCustomMaskEdit = class(TJvCustomComboEdit)
  private
    FHotTrack: Boolean;
    FCaret: TJvCaret;
    FEntering: Boolean;
    FLeaving: Boolean;
    FProtectPassword: Boolean;
    FLastNotifiedText: string;
    FHasLastNotifiedText: Boolean;
    FOnSetFocus: TJvFocusChangeEvent;
    FOnKillFocus: TJvFocusChangeEvent;
    FWordWrap: Boolean;
    FMultiLine: Boolean;
    FAlignment: TAlignment;
    FOnAfterPaint: TNotifyEvent;
    FScrollBars: TScrollStyle;
    FCanvas: TControlCanvas;
    procedure SetHotTrack(Value: Boolean);
    procedure SetAlignment(const Value: TAlignment);
    procedure SetMultiLine(const Value: Boolean);
    procedure SetScrollBars(const Value: TScrollStyle);
    procedure SetWordWrap(const Value: Boolean);
    function GetCanvas: TCanvas; 
  protected
//    procedure CreateParams(var Params: TCreateParams); override;
    procedure CaretChanged(Sender: TObject); dynamic;
    procedure FocusKilled(NextWnd: HWND); override;
    procedure FocusSet(PrevWnd: HWND); override;
    procedure DoKillFocus(const ANextControl: TWinControl); virtual;
    procedure DoSetFocus(const APreviousControl: TWinControl); virtual; 
    function GetText: TCaption; override;
    procedure SetText(const Value: TCaption); override; 
    procedure MouseEnter(Control: TControl); override;
    procedure MouseLeave(Control: TControl); override;
    procedure SetCaret(const Value: TJvCaret);
    procedure NotifyIfChanged;
    procedure Change; override;
    // (rom) not CLX compatible
    procedure Paint; override; //WMPaint(var Msg: TWMPaint); message WM_PAINT;
  public 
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Entering: Boolean read FEntering;
    property Leaving: Boolean read FLeaving;
  protected
    property Text: TCaption read GetText write SetText; 
    // set to True to disable read/write of PasswordChar and read of Text
    property ProtectPassword: Boolean read FProtectPassword write FProtectPassword default False;
    property HotTrack: Boolean read FHotTrack write SetHotTrack default False;
    property Caret: TJvCaret read FCaret write SetCaret;
    property ShowButton default False;

    property OnSetFocus: TJvFocusChangeEvent read FOnSetFocus write FOnSetFocus;
    property OnKillFocus: TJvFocusChangeEvent read FOnKillFocus write FOnKillFocus;

    // From Globus
    property ScrollBars: TScrollStyle read FScrollBars write SetScrollBars default ssNone;
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property MultiLine: Boolean read FMultiLine write SetMultiLine default False;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default False;
    property OnAfterPaint: TNotifyEvent read FOnAfterPaint write FOnAfterPaint;
  public
    property Canvas: TCanvas read GetCanvas;
  end;

  TJvMaskEdit = class(TJvCustomMaskEdit)
  published
    property Caret;
    property ClipboardCommands;
    property DisabledTextColor;
    property DisabledColor;
    property HintColor;
    property HotTrack;
    property ProtectPassword;
    property OnEnabledChanged;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnParentColorChange;

    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property DragMode;
    property Enabled;
    property EditMask;
    property Font; 
    property MaxLength;
    property ParentColor;
    property ParentFont;
    property ParentShowHint; 
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property ShowButton;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;

    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp; 
    property OnStartDrag;
  end;

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$RCSfile: JvQMaskEdit.pas,v $';
    Revision: '$Revision: 1.24 $';
    Date: '$Date: 2005/11/01 20:47:11 $';
    LogPath: 'JVCL\run'
  );
{$ENDIF UNITVERSIONING}

implementation


procedure TJvCustomMaskEdit.CaretChanged(Sender: TObject);
begin
  FCaret.CreateCaret;
end;

procedure TJvCustomMaskEdit.Change;
begin
  FLastNotifiedText := Text;
  FHasLastNotifiedText := True;
  inherited Change;
end;

constructor TJvCustomMaskEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCanvas := TControlCanvas.Create;
  FCanvas.Control := Self; //...i can draw now! :)

  FHotTrack := False;
  FCaret := TJvCaret.Create(Self);
  FCaret.OnChanged := CaretChanged;
  FEntering := False;
  FLeaving := False;

  FScrollBars := ssNone;
  FAlignment := taLeftJustify;
  FMultiLine := False;
  FWordWrap := False;

  ControlState := ControlState + [csCreating];
  try
    ShowButton := False; { force update }
  finally
    ControlState := ControlState - [csCreating];
  end;
end;



destructor TJvCustomMaskEdit.Destroy;
begin
  FCaret.OnChanged := nil;
  FreeAndNil(FCaret);
  FCanvas.Free;
  inherited Destroy;
end;

procedure TJvCustomMaskEdit.FocusKilled(NextWnd: HWND);
begin
  FLeaving := True;
  try
    FCaret.DestroyCaret;
    inherited FocusKilled(NextWnd);
    DoKillFocus(FindControl(NextWnd));
  finally
    FLeaving := False;
  end;
end;

procedure TJvCustomMaskEdit.DoKillFocus(const ANextControl: TWinControl);
begin
  NotifyIfChanged;
  if Assigned(FOnKillFocus) then
    FOnKillFocus(Self, ANextControl);
end;

procedure TJvCustomMaskEdit.FocusSet(PrevWnd: HWND);
begin
  FEntering := True;
  try
    inherited FocusSet(PrevWnd);
    FCaret.CreateCaret;
    DoSetFocus(FindControl(PrevWnd));
  finally
    FEntering := False;
  end;
end;

procedure TJvCustomMaskEdit.DoSetFocus(const APreviousControl: TWinControl);
begin
  if Assigned(FOnSetFocus) then
    FOnSetFocus(Self, APreviousControl);
end;



function TJvCustomMaskEdit.GetText: TCaption;
var
  Tmp: Boolean;
begin
  Tmp := ProtectPassword;
  try
    ProtectPassword := False;  
    Result := inherited GetText; 
  finally
    ProtectPassword := Tmp;
  end;
end;

procedure TJvCustomMaskEdit.MouseEnter(Control: TControl);
begin
  if csDesigning in ComponentState then
    Exit;
  if not MouseOver then
  begin
    if HotTrack then  
      BorderStyle := bsSingle; 
    inherited MouseEnter(Control);
  end;
end;

procedure TJvCustomMaskEdit.MouseLeave(Control: TControl);
begin
  if MouseOver then
  begin
    if FHotTrack then  
      BorderStyle := bsSingle; // maybe bsNone 
    inherited MouseLeave(Control);
  end;
end;

procedure TJvCustomMaskEdit.NotifyIfChanged;
begin
  if FHasLastNotifiedText and (FLastNotifiedText <> Text) then
    Change;
end;

procedure TJvCustomMaskEdit.SetCaret(const Value: TJvCaret);
begin
  FCaret.Assign(Value);
end;

procedure TJvCustomMaskEdit.SetHotTrack(Value: Boolean);
begin
  FHotTrack := Value;
  if Value then
  begin  
    BorderStyle := bsSingle; // maybe bsNone 
  end
  else
  begin  
    BorderStyle := bsSingle; 
  end;
end;



procedure TJvCustomMaskEdit.SetText(const Value: TCaption);
begin  
  inherited SetText(Value); 
end;

procedure TJvCustomMaskEdit.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    RecreateWnd;
  end;
end;

procedure TJvCustomMaskEdit.SetMultiLine(const Value: Boolean);
begin
  if FMultiLine <> Value then
  begin
    FMultiLine := Value;
    RecreateWnd;
  end;
end;

procedure TJvCustomMaskEdit.SetScrollBars(const Value: TScrollStyle);
begin
  if FScrollBars <> Value then
  begin
    FScrollBars := Value;
    RecreateWnd;
  end;
end;

procedure TJvCustomMaskEdit.SetWordWrap(const Value: Boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    RecreateWnd;
  end;
end;

function TJvCustomMaskEdit.GetCanvas: TCanvas;
begin
  Result := FCanvas;
end;

(*
procedure TJvCustomMaskEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  Params.Style := Params.Style or WS_CLIPCHILDREN;

  if FMultiline then
    Params.Style := Params.Style or ES_MULTILINE;

  case FAlignment of
    taLeftJustify:
      Params.Style := Params.Style or ES_LEFT;
    taRightJustify:
      Params.Style := Params.Style or ES_RIGHT;
    taCenter:
      Params.Style := Params.Style or ES_CENTER;
  end;

  case FScrollBars of
    ssHorizontal:
      Params.Style := Params.Style or WS_HSCROLL;
    ssVertical:
      Params.Style := Params.Style or WS_VSCROLL;
    ssBoth:
      Params.Style := Params.Style or WS_HSCROLL or WS_VSCROLL;
  end;

  if FWordWrap then
    Params.Style := Params.Style or ES_AUTOHSCROLL;
end;
*)

procedure TJvCustomMaskEdit.Paint; //WMPaint(var Msg: TWMPaint);
begin
  inherited;
  if Assigned(FOnAfterPaint) then
    FOnAfterPaint(Self);
end;


{$IFDEF UNITVERSIONING}
initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.
