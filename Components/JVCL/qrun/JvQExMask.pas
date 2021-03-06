{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvQExStdCtrls.pas, released on 2004-09-21

The Initial Developer of the Original Code is Andr� Snepvangers [asn att xs4all dott nl]
Portions created by Andr� Snepvangers are Copyright (C) 2004 Andr� Snepvangers.
All Rights Reserved.

Contributor(s): -

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvQExMask.pas,v 1.33 2005/11/01 20:47:11 asnepvangers Exp $

unit JvQExMask;

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
  QGraphics, QControls, QForms, QExtCtrls, QMask,
  Qt, QWindows, QMessages,
  JvQTypes, JvQThemes, JVCLXVer, JvQExControls;

type
  { QEditControl Begin }
  TJvExCustomMaskEdit = class(TCustomMaskEdit)
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
  { QEditControl }
  private
    FClipboardCommands: TJvClipboardCommands;
    procedure WMClear(var Mesg: TMessage); message WM_CLEAR;
    procedure WMCopy(var Mesg: TMessage); message WM_COPY;
    procedure WMCut(var Mesg: TMessage); message WM_CUT;
    procedure WMPaste(var Mesg: TMessage); message WM_PASTE;
    procedure WMUndo(var Mesg: TMessage); message WM_UNDO;
  protected
    procedure SetClipboardCommands(const Value: TJvClipboardCommands); virtual;
  public
    procedure PasteFromClipboard; override;
    procedure CopyToClipboard; override;
    procedure Clear; override;
    procedure CutToClipboard; override;
    procedure Undo; override;
  published
    property ClipboardCommands: TJvClipboardCommands read FClipboardCommands
      write SetClipboardCommands default [caCopy..caUndo];
  private
    FBeepOnError: Boolean;
  protected
    procedure DoBeepOnError; dynamic;
    procedure SetBeepOnError(Value: Boolean); virtual;
    property BeepOnError: Boolean read FBeepOnError write SetBeepOnError default True;
  { QWinControl }
  private
    FCanvas: TControlCanvas;
    FDoubleBuffered: Boolean;
    function GetCanvas: TCanvas;
  protected
    procedure Paint; virtual;
    procedure Painting(Sender: QObjectH; EventRegion: QRegionH); override;
    property DoubleBuffered: Boolean read FDoubleBuffered write FDoubleBuffered;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Canvas: TCanvas read GetCanvas;
  end;

  { QWinControl }
  TJvExPubCustomMaskEdit = class(TJvExCustomMaskEdit)
  end;
  

  { QEditControl Begin }
  TJvExMaskEdit = class(TMaskEdit)
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
  { QEditControl }
  private
    FClipboardCommands: TJvClipboardCommands;
    procedure WMClear(var Mesg: TMessage); message WM_CLEAR;
    procedure WMCopy(var Mesg: TMessage); message WM_COPY;
    procedure WMCut(var Mesg: TMessage); message WM_CUT;
    procedure WMPaste(var Mesg: TMessage); message WM_PASTE;
    procedure WMUndo(var Mesg: TMessage); message WM_UNDO;
  protected
    procedure SetClipboardCommands(const Value: TJvClipboardCommands); virtual;
  public
    procedure PasteFromClipboard; override;
    procedure CopyToClipboard; override;
    procedure Clear; override;
    procedure CutToClipboard; override;
    procedure Undo; override;
  published
    property ClipboardCommands: TJvClipboardCommands read FClipboardCommands
      write SetClipboardCommands default [caCopy..caUndo];
  private
    FBeepOnError: Boolean;
  protected
    procedure DoBeepOnError; dynamic;
    procedure SetBeepOnError(Value: Boolean); virtual;
    property BeepOnError: Boolean read FBeepOnError write SetBeepOnError default True;
  { QWinControl }
  private
    FCanvas: TControlCanvas;
    FDoubleBuffered: Boolean;
    function GetCanvas: TCanvas;
  protected
    procedure Paint; virtual;
    procedure Painting(Sender: QObjectH; EventRegion: QRegionH); override;
    property DoubleBuffered: Boolean read FDoubleBuffered write FDoubleBuffered;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Canvas: TCanvas read GetCanvas;
  end;

  { QWinControl }
  TJvExPubMaskEdit = class(TJvExMaskEdit)
  end;
  

implementation

{ The CREATE_CUSTOMCODE macro is used to extend the constructor by the macro
  content. }
{$UNDEF CREATE_CUSTOMCODE}
{$DEFINE CREATE_CUSTOMCODE
  FBeepOnError := True;
  FClipboardCommands := [caCopy..caUndo];
}

procedure TJvExCustomMaskEdit.DoBeepOnError;
begin
  if FBeepOnError then
    SysUtils.Beep;
end;

procedure TJvExCustomMaskEdit.SetBeepOnError(Value: Boolean);
begin
  FBeepOnError := Value;
end;

{ QEditControl Create }

constructor TJvExCustomMaskEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInternalFontChanged := Font.OnChange;
  Font.OnChange := DoOnFontChanged;
  FHintColor := clDefault;
  FDoubleBuffered := True;
  FClipBoardCommands := [caUndo, caCopy, caPaste, caCut];
  FBeepOnError := True;
  FClipboardCommands := [caCopy..caUndo];
end;

destructor TJvExCustomMaskEdit.Destroy;
begin
  
  FCanvas.Free;
  inherited Destroy;
end;
 
procedure TJvExCustomMaskEdit.WMClear(var Mesg: TMessage);
begin
  inherited Clear;
end;

procedure TJvExCustomMaskEdit.WMCopy(var Mesg: TMessage);
begin
  inherited CopyToClipBoard;
end;

procedure TJvExCustomMaskEdit.WMCut(var Mesg: TMessage);
begin
  inherited CutToClipBoard;
end;

procedure TJvExCustomMaskEdit.WMPaste(var Mesg: TMessage);
begin
  inherited PasteFromClipBoard;
end;

procedure TJvExCustomMaskEdit.WMUndo(var Mesg: TMessage);
begin
  inherited Undo;
end;
 
{ QEditControl Common}

procedure TJvExCustomMaskEdit.WndProc(var Mesg: TMessage);
begin
  //OutputDebugString(PAnsiChar(Format('EDITCONTROL %s: %s Msg $%x',[Name, ClassName, Mesg.Msg])));
  with TJvMessage(Mesg) do
  begin
    case Msg of
      WM_GETTEXTLENGTH : Result := Length(GetText);

      WM_CLEAR, WM_COPY,
      WM_CUT, WM_PASTE, WM_UNDO :
        if DoClipBoardCommands(msg, FClipBoardCommands) then
          inherited Dispatch(msg);

      EM_UNDO:  Result := Perform(WM_UNDO, 0, 0);
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

procedure TJvExCustomMaskEdit.Undo;
begin
  SendMessage(Handle, WM_UNDO, 0, 0);
end;

procedure TJvExCustomMaskEdit.SetClipboardCommands(const Value: TJvClipboardCommands);
begin
  FClipboardCommands := Value;
end;

procedure TJvExCustomMaskEdit.CopyToClipboard;
begin
  SendMessage(Handle, WM_COPY, 0, 0);
end;

procedure TJvExCustomMaskEdit.CutToClipboard;
begin
  if not ReadOnly then
    SendMessage(Handle, WM_CUT, 0, 0);
end;

procedure TJvExCustomMaskEdit.Clear;
begin
  if not ReadOnly then
    SendMessage(Handle, WM_CLEAR, 0, 0);
end;

procedure TJvExCustomMaskEdit.PasteFromClipboard;
begin
  if not ReadOnly then
    SendMessage(Handle, WM_PASTE, 0, 0);
end;
 
{ WinControl Paint }

function TJvExCustomMaskEdit.GetCanvas: TCanvas;
begin
  if not Assigned(FCanvas) then
  begin
    FCanvas := TControlCanvas.Create;
    FCanvas.Control := self;
  end;
  Result := FCanvas;
end;


procedure TJvExCustomMaskEdit.Paint;
begin
  TControlCanvas(Canvas).StopPaint;
  inherited Painting(Handle, QPainter_clipRegion(Canvas.Handle));
  TControlCanvas(Canvas).StartPaint;
end;

procedure TJvExCustomMaskEdit.Painting(Sender: QObjectH; EventRegion: QRegionH);
begin
  TControlCanvas(Canvas).StartPaint;
  try
    Canvas.Brush.Assign(Brush);
    Canvas.Font.Assign(Font);
    RequiredState(Canvas, [csHandleValid, csFontValid, csBrushValid]);
    QPainter_setClipRegion(Canvas.Handle, EventRegion);
    QPainter_setClipping(Canvas.Handle, True);
    Paint;
    QPainter_setClipping(Canvas.Handle, False);
  finally
    TControlCanvas(Canvas).StopPaint;
  end;
end;
 
{ QWinControl Common }
procedure TJvExCustomMaskEdit.CMDesignHitTest(var Mesg: TJvMessage);
begin
  with Mesg do
  begin
    Handled := inherited HitTest(XPos, YPos);
    if Handled then
      Result := HTCLIENT;
  end;
end;

procedure TJvExCustomMaskEdit.CMHitTest(var Mesg: TJvMessage);
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

function TJvExCustomMaskEdit.DoEraseBackground(Canvas: TCanvas; Param: Integer): Boolean;
begin
  Result := false;
end;

procedure TJvExCustomMaskEdit.ShowingChanged;
begin
  Perform(CM_SHOWINGCHANGED, 0 ,0);
  inherited;
end;

procedure TJvExCustomMaskEdit.ColorChanged;
begin
  Perform(CM_COLORCHANGED, 0, 0);
  inherited;
end;

procedure TJvExCustomMaskEdit.CursorChanged;
begin
  Perform(CM_CURSORCHANGED, 0, 0);
  inherited;
end;

procedure TJvExCustomMaskEdit.DoEnter;
begin
  Perform(CM_ENTER, 0 ,0);
  inherited DoEnter;
end;

procedure TJvExCustomMaskEdit.DoExit;
begin
  Perform(CM_EXIT, 0 ,0);
  inherited DoExit;
end;

function TJvExCustomMaskEdit.EventFilter(Sender: QObjectH; Event: QEventH): Boolean;
begin
  Result := False;
  if Assigned(FOnEvent) then
    FOnEvent(Sender, Event, Result);
  if not Result then
    Result := inherited EventFilter(Sender, Event);
end;

procedure TJvExCustomMaskEdit.FocusKilled(NextWnd: QWidgetH);
begin

end;

procedure TJvExCustomMaskEdit.FocusSet(PrevWnd: QWidgetH);
begin

end;

procedure TJvExCustomMaskEdit.FocusChanged(FocusedControl: TWidgetControl);
begin

end;

procedure TJvExCustomMaskEdit.DoOnFontChanged(Sender: TObject);
begin
  ParentFont := False;
  PostMessage(Self, CM_FONTCHANGED, 0, 0);
end;

procedure TJvExCustomMaskEdit.CreateWidget;
begin
  CreateWnd;
end;

procedure TJvExCustomMaskEdit.CreateWnd;
begin
  inherited CreateWidget;
end;

procedure TJvExCustomMaskEdit.RecreateWnd;
begin
  RecreateWidget;
end;

procedure TJvExCustomMaskEdit.PaintTo(PaintDevice: QPaintDeviceH; X, Y: Integer);
begin
  WidgetControl_PaintTo(self, PaintDevice, X, Y);
end;

procedure TJvExCustomMaskEdit.PaintWindow(PaintDevice: QPaintDeviceH);
begin
  PaintTo(PaintDevice, 0, 0);
end;

function TJvExCustomMaskEdit.WidgetFlags: Integer;
begin
  Result := inherited WidgetFlags or
    Integer(WidgetFlags_WMouseNoMask);
end;

function TJvExCustomMaskEdit.ColorToRGB(Value: TColor): TColor;
begin
  Result := QWindows.ColorToRGB(Value, self);
end;
  
{ QControl Common}

function TJvExCustomMaskEdit.HitTest(X, Y: integer): Boolean;
begin
   Result := Perform(CM_HITTEST, 0, 0) <> HTNOWHERE;
end;

procedure TJvExCustomMaskEdit.CMHintShow(var Mesg: TJvMessage);
begin
  with Mesg do
  begin
    Handled := inherited HintShow(HintInfo^);
  end;
end;

procedure TJvExCustomMaskEdit.CMSysFontChanged(var Mesg: TMessage);
begin
  if FDesktopFont then
  begin
    Font.Assign(Application.Font);
    FDesktopFont := True;
  end;
end;

procedure TJvExCustomMaskEdit.EnabledChanged;
begin
  Perform(CM_ENABLEDCHANGED, 0, 0);
  inherited EnabledChanged;
end;

procedure TJvExCustomMaskEdit.TextChanged;
begin
  Perform(CM_TEXTCHANGED, 0, 0);
  inherited TextChanged;
end;

procedure TJvExCustomMaskEdit.VisibleChanged;
begin
  Perform(CM_VISIBLECHANGED, 0, 0);
  inherited VisibleChanged;
end;

function TJvExCustomMaskEdit.HintShow(var HintInfo : THintInfo): Boolean;
begin
  Result := Perform(CM_HINTSHOW, 0, Integer(@HintInfo)) <> 0;
end;

procedure TJvExCustomMaskEdit.MouseEnter(AControl: TControl);
begin
  Perform(CM_MOUSEENTER, 0, 0);
  inherited MouseEnter(AControl);
end;

procedure TJvExCustomMaskEdit.MouseLeave(AControl: TControl);
begin
  Perform(CM_MOUSELEAVE, 0, 0);
  inherited MouseLeave(AControl);
end;

procedure TJvExCustomMaskEdit.ParentColorChanged;
begin
  inherited ParentColorChanged;
  if Assigned(FOnParentColorChanged) then
    FOnParentColorChanged(Self);
end;

procedure TJvExCustomMaskEdit.SetDesktopFont(Value: Boolean);
begin
  if FDesktopFont <> Value then
  begin
    FDesktopFont := Value;
    Perform(CM_SYSFONTCHANGED, 0, 0);
  end;
end;

procedure TJvExCustomMaskEdit.Dispatch(var Mesg);
begin
  if Assigned(FWindowProc) then
    FWindowProc(TMessage(Mesg))
  else
    WndProc(TMessage(Mesg))
end;

function TJvExCustomMaskEdit.Perform(Msg: Cardinal; WParam, LParam: Longint): Longint;
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

function TJvExCustomMaskEdit.IsRightToLeft: Boolean;
begin
  Result := False;
end;
  

procedure TJvExMaskEdit.DoBeepOnError;
begin
  if FBeepOnError then
    SysUtils.Beep;
end;

procedure TJvExMaskEdit.SetBeepOnError(Value: Boolean);
begin
  FBeepOnError := Value;
end;

{ QEditControl Create }

constructor TJvExMaskEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInternalFontChanged := Font.OnChange;
  Font.OnChange := DoOnFontChanged;
  FHintColor := clDefault;
  FDoubleBuffered := True;
  FClipBoardCommands := [caUndo, caCopy, caPaste, caCut];
  FBeepOnError := True;
  FClipboardCommands := [caCopy..caUndo];
end;

destructor TJvExMaskEdit.Destroy;
begin
  
  FCanvas.Free;
  inherited Destroy;
end;
 
procedure TJvExMaskEdit.WMClear(var Mesg: TMessage);
begin
  inherited Clear;
end;

procedure TJvExMaskEdit.WMCopy(var Mesg: TMessage);
begin
  inherited CopyToClipBoard;
end;

procedure TJvExMaskEdit.WMCut(var Mesg: TMessage);
begin
  inherited CutToClipBoard;
end;

procedure TJvExMaskEdit.WMPaste(var Mesg: TMessage);
begin
  inherited PasteFromClipBoard;
end;

procedure TJvExMaskEdit.WMUndo(var Mesg: TMessage);
begin
  inherited Undo;
end;
 
{ QEditControl Common}

procedure TJvExMaskEdit.WndProc(var Mesg: TMessage);
begin
  //OutputDebugString(PAnsiChar(Format('EDITCONTROL %s: %s Msg $%x',[Name, ClassName, Mesg.Msg])));
  with TJvMessage(Mesg) do
  begin
    case Msg of
      WM_GETTEXTLENGTH : Result := Length(GetText);

      WM_CLEAR, WM_COPY,
      WM_CUT, WM_PASTE, WM_UNDO :
        if DoClipBoardCommands(msg, FClipBoardCommands) then
          inherited Dispatch(msg);

      EM_UNDO:  Result := Perform(WM_UNDO, 0, 0);
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

procedure TJvExMaskEdit.Undo;
begin
  SendMessage(Handle, WM_UNDO, 0, 0);
end;

procedure TJvExMaskEdit.SetClipboardCommands(const Value: TJvClipboardCommands);
begin
  FClipboardCommands := Value;
end;

procedure TJvExMaskEdit.CopyToClipboard;
begin
  SendMessage(Handle, WM_COPY, 0, 0);
end;

procedure TJvExMaskEdit.CutToClipboard;
begin
  if not ReadOnly then
    SendMessage(Handle, WM_CUT, 0, 0);
end;

procedure TJvExMaskEdit.Clear;
begin
  if not ReadOnly then
    SendMessage(Handle, WM_CLEAR, 0, 0);
end;

procedure TJvExMaskEdit.PasteFromClipboard;
begin
  if not ReadOnly then
    SendMessage(Handle, WM_PASTE, 0, 0);
end;
 
{ WinControl Paint }

function TJvExMaskEdit.GetCanvas: TCanvas;
begin
  if not Assigned(FCanvas) then
  begin
    FCanvas := TControlCanvas.Create;
    FCanvas.Control := self;
  end;
  Result := FCanvas;
end;


procedure TJvExMaskEdit.Paint;
begin
  TControlCanvas(Canvas).StopPaint;
  inherited Painting(Handle, QPainter_clipRegion(Canvas.Handle));
  TControlCanvas(Canvas).StartPaint;
end;

procedure TJvExMaskEdit.Painting(Sender: QObjectH; EventRegion: QRegionH);
begin
  TControlCanvas(Canvas).StartPaint;
  try
    Canvas.Brush.Assign(Brush);
    Canvas.Font.Assign(Font);
    RequiredState(Canvas, [csHandleValid, csFontValid, csBrushValid]);
    QPainter_setClipRegion(Canvas.Handle, EventRegion);
    QPainter_setClipping(Canvas.Handle, True);
    Paint;
    QPainter_setClipping(Canvas.Handle, False);
  finally
    TControlCanvas(Canvas).StopPaint;
  end;
end;
 
{ QWinControl Common }
procedure TJvExMaskEdit.CMDesignHitTest(var Mesg: TJvMessage);
begin
  with Mesg do
  begin
    Handled := inherited HitTest(XPos, YPos);
    if Handled then
      Result := HTCLIENT;
  end;
end;

procedure TJvExMaskEdit.CMHitTest(var Mesg: TJvMessage);
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

function TJvExMaskEdit.DoEraseBackground(Canvas: TCanvas; Param: Integer): Boolean;
begin
  Result := false;
end;

procedure TJvExMaskEdit.ShowingChanged;
begin
  Perform(CM_SHOWINGCHANGED, 0 ,0);
  inherited;
end;

procedure TJvExMaskEdit.ColorChanged;
begin
  Perform(CM_COLORCHANGED, 0, 0);
  inherited;
end;

procedure TJvExMaskEdit.CursorChanged;
begin
  Perform(CM_CURSORCHANGED, 0, 0);
  inherited;
end;

procedure TJvExMaskEdit.DoEnter;
begin
  Perform(CM_ENTER, 0 ,0);
  inherited DoEnter;
end;

procedure TJvExMaskEdit.DoExit;
begin
  Perform(CM_EXIT, 0 ,0);
  inherited DoExit;
end;

function TJvExMaskEdit.EventFilter(Sender: QObjectH; Event: QEventH): Boolean;
begin
  Result := False;
  if Assigned(FOnEvent) then
    FOnEvent(Sender, Event, Result);
  if not Result then
    Result := inherited EventFilter(Sender, Event);
end;

procedure TJvExMaskEdit.FocusKilled(NextWnd: QWidgetH);
begin

end;

procedure TJvExMaskEdit.FocusSet(PrevWnd: QWidgetH);
begin

end;

procedure TJvExMaskEdit.FocusChanged(FocusedControl: TWidgetControl);
begin

end;

procedure TJvExMaskEdit.DoOnFontChanged(Sender: TObject);
begin
  ParentFont := False;
  PostMessage(Self, CM_FONTCHANGED, 0, 0);
end;

procedure TJvExMaskEdit.CreateWidget;
begin
  CreateWnd;
end;

procedure TJvExMaskEdit.CreateWnd;
begin
  inherited CreateWidget;
end;

procedure TJvExMaskEdit.RecreateWnd;
begin
  RecreateWidget;
end;

procedure TJvExMaskEdit.PaintTo(PaintDevice: QPaintDeviceH; X, Y: Integer);
begin
  WidgetControl_PaintTo(self, PaintDevice, X, Y);
end;

procedure TJvExMaskEdit.PaintWindow(PaintDevice: QPaintDeviceH);
begin
  PaintTo(PaintDevice, 0, 0);
end;

function TJvExMaskEdit.WidgetFlags: Integer;
begin
  Result := inherited WidgetFlags or
    Integer(WidgetFlags_WMouseNoMask);
end;

function TJvExMaskEdit.ColorToRGB(Value: TColor): TColor;
begin
  Result := QWindows.ColorToRGB(Value, self);
end;
  
{ QControl Common}

function TJvExMaskEdit.HitTest(X, Y: integer): Boolean;
begin
   Result := Perform(CM_HITTEST, 0, 0) <> HTNOWHERE;
end;

procedure TJvExMaskEdit.CMHintShow(var Mesg: TJvMessage);
begin
  with Mesg do
  begin
    Handled := inherited HintShow(HintInfo^);
  end;
end;

procedure TJvExMaskEdit.CMSysFontChanged(var Mesg: TMessage);
begin
  if FDesktopFont then
  begin
    Font.Assign(Application.Font);
    FDesktopFont := True;
  end;
end;

procedure TJvExMaskEdit.EnabledChanged;
begin
  Perform(CM_ENABLEDCHANGED, 0, 0);
  inherited EnabledChanged;
end;

procedure TJvExMaskEdit.TextChanged;
begin
  Perform(CM_TEXTCHANGED, 0, 0);
  inherited TextChanged;
end;

procedure TJvExMaskEdit.VisibleChanged;
begin
  Perform(CM_VISIBLECHANGED, 0, 0);
  inherited VisibleChanged;
end;

function TJvExMaskEdit.HintShow(var HintInfo : THintInfo): Boolean;
begin
  Result := Perform(CM_HINTSHOW, 0, Integer(@HintInfo)) <> 0;
end;

procedure TJvExMaskEdit.MouseEnter(AControl: TControl);
begin
  Perform(CM_MOUSEENTER, 0, 0);
  inherited MouseEnter(AControl);
end;

procedure TJvExMaskEdit.MouseLeave(AControl: TControl);
begin
  Perform(CM_MOUSELEAVE, 0, 0);
  inherited MouseLeave(AControl);
end;

procedure TJvExMaskEdit.ParentColorChanged;
begin
  inherited ParentColorChanged;
  if Assigned(FOnParentColorChanged) then
    FOnParentColorChanged(Self);
end;

procedure TJvExMaskEdit.SetDesktopFont(Value: Boolean);
begin
  if FDesktopFont <> Value then
  begin
    FDesktopFont := Value;
    Perform(CM_SYSFONTCHANGED, 0, 0);
  end;
end;

procedure TJvExMaskEdit.Dispatch(var Mesg);
begin
  if Assigned(FWindowProc) then
    FWindowProc(TMessage(Mesg))
  else
    WndProc(TMessage(Mesg))
end;

function TJvExMaskEdit.Perform(Msg: Cardinal; WParam, LParam: Longint): Longint;
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

function TJvExMaskEdit.IsRightToLeft: Boolean;
begin
  Result := False;
end;
  

{$UNDEF CREATE_CUSTOMCODE} // undefine at file end

{$DEFINE UnitName 'JvQExMask.pas'}

const
  UnitVersion = 'JvQExMask.pas';

initialization
  OutputDebugString(PChar('JvExCLX Loaded: ' + UnitVersion));

finalization
  OutputDebugString(PChar('JvExCLX Unloaded: ' + UnitVersion));


end.
