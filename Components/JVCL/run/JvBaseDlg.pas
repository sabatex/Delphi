{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvBaseDlg.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is S�bastien Buysse [sbuysse att buypin dott com]
Portions created by S�bastien Buysse are Copyright (C) 2001 S�bastien Buysse.
All Rights Reserved.

Contributor(s): Michael Beck [mbeck att bigfoot dott com].

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvBaseDlg.pas,v 1.18 2005/09/15 07:22:54 marquardt Exp $

unit JvBaseDlg;

{$I jvcl.inc}

interface

uses
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  Dialogs,
  JVCLVer, JvComponentBase;

type
  {$IFDEF VisualCLX}
  TCommonDialog = TCustomDialog;
  {$ENDIF VisualCLX}

  TJvCommonDialog = class(TCommonDialog)
  private
    FAboutJVCL: TJVCLAboutInfo;
  published
    property AboutJVCL: TJVCLAboutInfo read FAboutJVCL write FAboutJVCL stored False;
  end;

  TJvCommonDialogP = class(TJvComponent)
  public
    {$IFDEF CLR}
    procedure DefaultHandler(var Msg); virtual;
    {$ENDIF CLR}

    procedure Execute; virtual; abstract;
  end;

  // (rom) alternative to TJvCommonDialogP
  TJvCommonDialogF = class(TJvComponent)
  public
    {$IFDEF CLR}
    procedure DefaultHandler(var Msg); virtual;
    {$ENDIF CLR}

    function Execute: Boolean; virtual; abstract;
  end;

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$RCSfile: JvBaseDlg.pas,v $';
    Revision: '$Revision: 1.18 $';
    Date: '$Date: 2005/09/15 07:22:54 $';
    LogPath: 'JVCL\run'
  );
{$ENDIF UNITVERSIONING}

implementation

{$IFDEF CLR}
procedure TJvCommonDialogP.DefaultHandler(var Msg);
begin
end;

procedure TJvCommonDialogF.DefaultHandler(var Msg);
begin
end;
{$ENDIF CLR}


{$IFDEF UNITVERSIONING}
initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.

