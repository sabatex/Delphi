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

The Original Code is: JvHMIReg.PAS, released on 2002-05-26.

The Initial Developer of the Original Code is John Doe.
Portions created by John Doe are Copyright (C) 2003 John Doe.
All Rights Reserved.

Contributor(s):

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvQHMIReg.pas,v 1.19 2004/12/22 09:59:29 marquardt Exp $

unit JvQHMIReg;

{$I jvcl.inc}

interface

procedure Register;

implementation

{$IFDEF MSWINDOWS}
{$R ..\Resources\JvHMIReg.dcr}
{$ENDIF MSWINDOWS}
{$IFDEF UNIX}
{$R ../Resources/JvHMIReg.dcr}
{$ENDIF UNIX}

uses
  Classes, 
  DesignIntf, DesignEditors, 
  ToolsAPI,
  JvQDsgnConsts,
  JvQSegmentedLEDDisplay, JvQLED, JvQDialButton,
  JvQSegmentedLEDDisplayEditors, JvQSegmentedLEDDisplayMapperFrame;

procedure Register;
begin
  RegisterComponents(RsPaletteHMIComponents, [TJvSegmentedLEDDisplay, TJvLED,
    TJvDialButton]);
  RegisterPropertyEditor(TypeInfo(TJvSegmentedLEDDigitClassName), TPersistent, '', TJvSegmentedLEDDigitClassProperty);
  RegisterPropertyEditor(TypeInfo(TUnlitColor), TPersistent, '', TJvUnlitColorProperty);
  RegisterComponentEditor(TJvCustomSegmentedLEDDisplay, TJvSegmentedLEDDisplayEditor);
  RegisterCustomModule(TfmeJvSegmentedLEDDisplayMapper, TCustomModule);
end;

end.
