object frmSettings: TfrmSettings
  Left = 405
  Top = 290
  BorderStyle = bsDialog
  Caption = 'Import settings'
  ClientHeight = 145
  ClientWidth = 398
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 78
    Height = 13
    Caption = 'Output directory:'
  end
  object Bevel1: TBevel
    Left = 0
    Top = 106
    Width = 398
    Height = 39
    Align = alBottom
    Shape = bsTopLine
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 47
    Height = 13
    Caption = 'File prefix:'
  end
  object Button1: TButton
    Left = 313
    Top = 114
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object Button2: TButton
    Left = 234
    Top = 114
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object edtOutPutDir: TEdit
    Left = 95
    Top = 5
    Width = 268
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object cbUseUnitAtCompileTime: TCheckBox
    Left = 94
    Top = 52
    Width = 181
    Height = 25
    Caption = 'Use the unit at compiletime'
    TabOrder = 3
  end
  object btnOutPutDir: TButton
    Left = 363
    Top = 5
    Width = 21
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 1
    OnClick = btnOutPutDirClick
  end
  object cbCreateOneImportfile: TCheckBox
    Left = 94
    Top = 72
    Width = 181
    Height = 25
    Caption = 'Create one importfile'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object Default: TCheckBox
    Left = 4
    Top = 119
    Width = 97
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Default'
    TabOrder = 7
  end
  object edtPrefix: TEdit
    Left = 95
    Top = 28
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'edtPrefix'
  end
end
