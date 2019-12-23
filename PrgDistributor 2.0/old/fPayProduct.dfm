object frmPayProducts: TfrmPayProducts
  Left = 256
  Top = 197
  Width = 512
  Height = 181
  Caption = 'frmPayProducts'
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
    Left = 11
    Top = 12
    Width = 43
    Height = 13
    Caption = #1060#1080#1088#1084#1072' :'
  end
  object Label2: TLabel
    Left = 368
    Top = 10
    Width = 29
    Height = 13
    Caption = #1044#1072#1090#1072':'
  end
  object DBLookupComboboxEh1: TDBLookupComboboxEh
    Left = 60
    Top = 6
    Width = 297
    Height = 21
    DataField = 'FIRMS_ID'
    DataSource = dsPROD
    EditButtons = <>
    KeyField = 'ID'
    ListField = 'COMPANY_NAME'
    ListSource = dsFIRMS
    TabOrder = 0
    Visible = True
  end
  object DBDateTimeEditEh1: TDBDateTimeEditEh
    Left = 405
    Top = 4
    Width = 84
    Height = 21
    DataField = 'DATE_PAY'
    DataSource = dsPROD
    EditButtons = <>
    Kind = dtkDateEh
    TabOrder = 1
    Visible = True
  end
  object Button1: TButton
    Left = 320
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 416
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object DBNumberEditEh1: TDBNumberEditEh
    Left = 60
    Top = 32
    Width = 121
    Height = 21
    DataField = 'LICENZE'
    DataSource = dsPROD
    EditButtons = <>
    MaxValue = 99
    TabOrder = 4
    Visible = True
  end
  object DBEditEh1: TDBEditEh
    Left = 60
    Top = 64
    Width = 297
    Height = 21
    DataField = 'KEY_NAME'
    DataSource = dsPROD
    EditButtons = <
      item
        Style = ebsEllipsisEh
        OnClick = DBEditEh1EditButtons0Click
      end>
    TabOrder = 5
    Visible = True
  end
  object dsPROD: TDataSource
    DataSet = dmFunction.PROD
    Left = 53
    Top = 112
  end
  object dsFIRMS: TDataSource
    DataSet = dmFunction.FIRMS
    Left = 88
    Top = 112
  end
  object SaveDialog1: TSaveDialog
    Left = 120
    Top = 112
  end
end
