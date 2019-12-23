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

The Original Code is: JvThemes.PAS, released on 2003-09-25

The Initial Developers of the Original Code are: Andreas Hausladen <Andreas dott Hausladen att gmx dott de>
All Rights Reserved.

Contributors:

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvQThemes.pas,v 1.23 2005/11/01 20:47:12 asnepvangers Exp $

unit JvQThemes;

{$I jvcl.inc}


interface

uses
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  SysUtils, Classes, 
  Types,  
  QControls, QStdCtrls, QGraphics, 
  QWindows, QForms, // Mouse 
  QButtons;

const
 // Add a message handler to a component that is themed by the ThemeManager but
 // should not be themed.
  CM_DENYSUBCLASSING = CM_BASE + 2000; // from ThemeMgr.pas

type   
  TCMDenySubClassing = record
    Msg: Integer;
    Result: Integer;
  end; 

  TWinControlThemeInfo = class(TWinControl)
  public
    property Color;
  end;



type   
  TThemeStyle = set of (csNeedsBorderPaint, csParentBackground);  

{
  Instead of the ControlStyle property you should use the following functions:

    ControlStyle := ControlStyle + [csXxx]; -> IncludeThemeStyle(Self, [csXxx]);
    ControlStyle := ControlStyle - [csXxx]; -> ExcludeThemeStyle(Self, [csXxx]);
    if csXxx in ControlStyle then           -> if csXxx in GetThemeStyle(Self) then

}
procedure IncludeThemeStyle(Control: TControl; Style: TThemeStyle);
procedure ExcludeThemeStyle(Control: TControl; Style: TThemeStyle);
function GetThemeStyle(Control: TControl): TThemeStyle;

{ DrawThemedBackground fills R with Canvas.Brush.Color/Color. If the control uses
  csParentBackground and the color is that of it's parent the Rect is not filled
  because then it is done by the JvThemes/VCL7. }
procedure DrawThemedBackground(Control: TControl; Canvas: TCanvas;
  const R: TRect; NeedsParentBackground: Boolean = True); overload;
procedure DrawThemedBackground(Control: TControl; Canvas: TCanvas;
  const R: TRect; Color: TColor; NeedsParentBackground: Boolean = True); overload;
procedure DrawThemedBackground(Control: TControl; DC: HDC; const R: TRect;
  Brush: HBRUSH; NeedsParentBackground: Boolean = True); overload;

{ DrawThemesFrameControl draws a themed frame control when theming is enabled.
  Control = nil: the frame control will be painted themed only if the control
                 is not in csDesigning mode. }
function DrawThemedFrameControl(Control: TControl; DC: HDC; const Rect: TRect;
  uType, uState: UINT): BOOL;




type
  TButtonStyle = (bsAutoDetect, bsWin31, bsNew);


{ DrawThemedButtonFace draws a themed button when theming is enabled. }
function DrawThemedButtonFace(Control: TControl; Canvas: TCanvas; const Client: TRect;
  BevelWidth: Integer; Style: TButtonStyle; IsRounded, IsDown,
  IsFocused, IsHot: Boolean): TRect;

{ IsMouseOver returns True if the mouse is over the control. }
function IsMouseOver(Control: TControl): Boolean;


{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$RCSfile: JvQThemes.pas,v $';
    Revision: '$Revision: 1.23 $';
    Date: '$Date: 2005/11/01 20:47:12 $';
    LogPath: 'JVCL\run'
  );
{$ENDIF UNITVERSIONING}

implementation


procedure DrawThemedBackground(Control: TControl; Canvas: TCanvas;
  const R: TRect; NeedsParentBackground: Boolean = True);
begin
  DrawThemedBackground(Control, Canvas, R, Canvas.Brush.Color,
    NeedsParentBackground);
end;

procedure DrawThemedBackground(Control: TControl; Canvas: TCanvas;
  const R: TRect; Color: TColor; NeedsParentBackground: Boolean = True);
var
  Cl: TColor;
begin 
  begin
    Cl := Canvas.Brush.Color;
    if Cl <> Color then
      Canvas.Brush.Color := Color;
    Canvas.FillRect(R);
    if Cl <> Canvas.Brush.Color then
      Canvas.Brush.Color := Cl;
  end;
end;

procedure DrawThemedBackground(Control: TControl; DC: HDC; const R: TRect;
  Brush: HBRUSH; NeedsParentBackground: Boolean = True);

begin 
    FillRect(DC, R, Brush);
end;

function DrawThemedFrameControl(Control: TControl; DC: HDC; const Rect: TRect; uType, uState: UINT): BOOL;

begin
  Result := False; 

  if not Result then
    Result := DrawFrameControl(DC, Rect, uType, uState);
end;



function DrawThemedButtonFace(Control: TControl; Canvas: TCanvas;
  const Client: TRect; BevelWidth: Integer; Style: TButtonStyle;
  IsRounded, IsDown, IsFocused, IsHot: Boolean): TRect;

begin   
  Result := DrawButtonFace(Canvas, Client, BevelWidth, IsDown, IsFocused); 
end;

function IsMouseOver(Control: TControl): Boolean;
var
  Pt: TPoint;
begin
  Pt := Control.ScreenToClient(Mouse.CursorPos);
  Result := PtInRect(Control.ClientRect, Pt);
end;



 // JVCLThemesEnabled

procedure IncludeThemeStyle(Control: TControl; Style: TThemeStyle);
begin
end;

procedure ExcludeThemeStyle(Control: TControl; Style: TThemeStyle);
begin
end;

function GetThemeStyle(Control: TControl): TThemeStyle;
begin
end;





initialization
  {$IFDEF UNITVERSIONING}
  RegisterUnitVersion(HInstance, UnitVersioning);
  {$ENDIF UNITVERSIONING} 

finalization 
  {$IFDEF UNITVERSIONING}
  UnregisterUnitVersion(HInstance);
  {$ENDIF UNITVERSIONING}

end.

