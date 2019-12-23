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

The Original Code is: JvLED.pas, released on 2005-03-30.

The Initial Developer of the Original Code is Robert Marquardt (robert_marquardt att gmx dott de)
Portions created by Robert Marquardt are Copyright (C) 2005 Robert Marquardt.
All Rights Reserved.

Contributor(s):

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvQPoweredBy.pas,v 1.2 2005/11/01 20:47:11 asnepvangers Exp $

unit JvQPoweredBy;

{$I jvcl.inc}

interface

uses
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  QWindows, Classes, QGraphics, QControls,
  JvQComponent;

type
  TJvPoweredBy = class(TJvGraphicControl)
  private
    FResourceName: string;
    FImage: TBitmap;
    FURL: string; 
    FAutoSize: Boolean;
    procedure SetAutoSize(Value: Boolean); 
  protected
    procedure Paint; override;
    procedure Click; override; 
    property AutoSize: Boolean read FAutoSize write SetAutoSize; 
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property URL: string read FURL write FURL;
    property Image: TBitmap read FImage;
  end;

  // In a sense this component is silly :-). By using it the JVCL gets used.
  // Therefore it gets an exception from the MPL rule of mentioning the JVCL if using a JVCL component.

  TJvPoweredByJCL = class(TJvPoweredBy)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Anchors;
    property AutoSize; 
    property Constraints;
    property Cursor default crHandPoint;
    property DragMode;
    property Height default 31;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property Width default 195;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

  TJvPoweredByJVCL = class(TJvPoweredBy)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Anchors;
    property AutoSize; 
    property Constraints;
    property Cursor default crHandPoint;
    property DragMode;
    property Height default 31;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property URL;
    property Visible;
    property Width default 209;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$RCSfile: JvQPoweredBy.pas,v $';
    Revision: '$Revision: 1.2 $';
    Date: '$Date: 2005/11/01 20:47:11 $';
    LogPath: 'JVCL\run'
  );
{$ENDIF UNITVERSIONING}

implementation

uses
  JvQJCLUtils, JvQResources;

{$IFDEF MSWINDOWS}
{$R ..\Resources\JvPoweredBy.res}
{$ENDIF MSWINDOWS}
{$IFDEF UNIX}
{$R ../Resources/JvPoweredBy.res}
{$ENDIF UNIX}

const
  cPoweredByJCL = 'JvPoweredByJCL';
  cPoweredByJVCL = 'JvPoweredByJVCL';

//=== { TJvPoweredBy } =======================================================

constructor TJvPoweredBy.Create(AOwner: TComponent);
begin
  inherited Create(AOwner); 
  FAutoSize := True; 
  Cursor := crHandPoint;
  FImage := TBitmap.Create;
  FImage.LoadFromResourceName(HInstance, FResourceName);
  Width := FImage.Width;
  Height := FImage.Height;
end;

destructor TJvPoweredBy.Destroy;
begin
  FImage.Free;
  inherited Destroy;
end;

procedure TJvPoweredBy.Paint;
var
  DestRect, SrcRect: TRect;
begin
  if csDesigning in ComponentState then
  begin
    Canvas.Pen.Style := psDash;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(ClientRect);
  end;
  SrcRect := Rect(0, 0, FImage.Width, FImage.Height);  
  DestRect := Bounds(Left, Top, Width, Height);
  OffsetRect(DestRect, (ClientWidth - FImage.Width) div 2, (ClientHeight - FImage.Height) div 2);
  with Canvas do
  begin
    CopyMode := cmSrcCopy;
//    QWindows.CopyRect( Canvas,  DestRect, FImage.Canvas, SrcRect);
    CopyRect( DestRect, FImage.Canvas, SrcRect)
  end;
end;

procedure TJvPoweredBy.Click;
begin
  if not Assigned(OnClick) then
    OpenObject(URL)
  else
    inherited Click;
end;

procedure TJvPoweredBy.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin 
  if AutoSize and (Align in [alNone, alCustom]) then 
    inherited SetBounds(ALeft, ATop, FImage.Width, FImage.Height)
  else
    inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;


procedure TJvPoweredBy.SetAutoSize(Value: Boolean);
begin
  if Value <> FAutoSize then
  begin
    FAutoSize := Value;
    if FAutoSize then
      SetBounds(Left, Top, Width, Height);
  end;
end;


//=== { TJvPoweredByJCL } ====================================================

constructor TJvPoweredByJCL.Create(AOwner: TComponent);
begin
  FResourceName := cPoweredByJCL;
  // simple trick with inherited
  inherited Create(AOwner);
  FURL := RsURLPoweredByJCL;
end;

//=== { TJvPoweredByJVCL } ===================================================

constructor TJvPoweredByJVCL.Create(AOwner: TComponent);
begin
  FResourceName := cPoweredByJVCL;
  inherited Create(AOwner);
  FURL := RsURLPoweredByJVCL;
end;

{$IFDEF UNITVERSIONING}
initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.

