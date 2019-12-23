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

The Original Code is: JvStdCtrlsReg.PAS, released on 2002-05-26.

The Initial Developer of the Original Code is John Doe.
Portions created by John Doe are Copyright (C) 2003 John Doe.
All Rights Reserved.

Contributor(s):

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvQStdCtrlsReg.pas,v 1.37 2005/11/01 20:52:07 asnepvangers Exp $

unit JvQStdCtrlsReg;

{$I jvcl.inc}

interface

procedure Register;

implementation

uses
  Classes, QControls,  
  QTypes, // type TCaption 
  QImgList, 
  DesignEditors, DesignIntf, 
  JvQDsgnConsts, JvQTypes,  
  JvQGauges, {JvQStdDsgnEditors,} QComCtrlsEx, 
  JvQCombobox, JvQColorCombo, JvQComCtrls,
  JvQSpin, JvQEdit, JvQProgressBar, JvQMaskEdit, JvQBaseEdits, JvQCalc,
  JvQToolEdit, JvQBevel, JvQCheckBox, JvQSpeedButton, JvQSecretPanel,
  JvQCheckListBox, JvQControlBar, JvQCtrls, JvQGroupBox, JvQHeaderControl,
  JvQImage, JvQLabel, JvQRadioButton, JvQRadioGroup, JvQScrollBar, JvQShape,
  JvQStaticText, JvQStatusBar, JvQGrids, JvQStringGrid, JvQBitBtn, JvQPanel, JvQImageList,
  JvQCheckedItemsForm, JvQProgressEditor, JvQDsgnEditors,
  JvQCheckedMaskEdit;

{$IFDEF MSWINDOWS}
{$R ..\Resources\JvStdCtrlsReg.dcr}
{$ENDIF MSWINDOWS}
{$IFDEF UNIX}
{$R ../Resources/JvStdCtrlsReg.dcr}
{$ENDIF UNIX}

procedure Register;
const
  BaseClass: TClass = TComponent;
  cText = 'Text';
  cOwnerDraw = 'OwnerDraw';
begin
  RegisterComponents(RsPaletteVisual, [TJvShape]);
  RegisterComponents(RsPaletteNonVisual, [ 
    TJvCalculator]); 
  RegisterComponents(RsPaletteButton, [TJvBitBtn, TJvImgBtn, TJvSpeedButton,
    TJvCheckBox, TJvRadioButton, TJvRadioGroup,  
    TUpDown, 
    TJvSpinButton]);
  RegisterComponents(RsPaletteEdit, [TJvEdit, 
    TJvMaskEdit, TJvCheckedMaskEdit, TJvComboEdit, TJvCalcEdit,
    TJvFilenameEdit, TJvDirectoryEdit, TJvSpinEdit, 
    TJvDateEdit]);
  RegisterComponents(RsPaletteImageAnimator, [TJvImage, TJvImageList]);
  RegisterComponents(RsPaletteBarPanel, [TJvPageControl,
    TJvTabControl, TJvTabDefaultPainter, 
    TGauge, 
    TJvProgressBar, TJvGradientProgressBar, TJvStatusBar, 
    TJvControlBar, TJvGroupBox, TJvHeaderControl, TJvPanel, TJvBevel,
    TJvSecretPanel]);
  RegisterComponents(RsPaletteLabel, [ TJvStaticText,
    TJvLabel]);
  RegisterComponents(RsPaletteListComboTree, [TJvComboBox, TJvCheckedComboBox, 
    TJvCheckListBox, 
    TJvColorComboBox, TJvFontComboBox,
    TJvDrawGrid, TJvStringGrid]);
  RegisterComponents(RsPaletteScrollerTracker, [ 
    TJvScrollBar]);
  RegisterComponents(RsPaletteSliderSplitter, [TJvTrackBar]); 

  RegisterPropertyEditor(TypeInfo(TControl), BaseClass, 'Gauge', TJvProgressControlProperty);
  RegisterPropertyEditor(TypeInfo(TControl), BaseClass, 'ProgressBar', TJvProgressControlProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvCustomNumEdit, cText, nil);
  RegisterPropertyEditor(TypeInfo(string), TJvFileDirEdit, cText, TStringProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvCustomDateEdit, cText, TStringProperty); 
  RegisterPropertyEditor(TypeInfo(string), TJvFilenameEdit, 'FileName', TJvFilenameProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvDirectoryEdit, cText, TJvDirectoryProperty);
  RegisterPropertyEditor(TypeInfo(string), TJvCustomComboEdit, 'ButtonHint', TJvHintProperty); 
  RegisterPropertyEditor(TypeInfo(TJvImgBtnKind), TJvImgBtn, 'Kind', TJvNosortEnumProperty);
  RegisterPropertyEditor(TypeInfo(TCaption), TJvSpeedButton, 'Caption', TJvHintProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TJvCustomLabel, 'ImageIndex',TJvDefaultImageIndexProperty);
end;

end.
