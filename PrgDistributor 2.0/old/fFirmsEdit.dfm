object Form1: TForm1
  Left = 330
  Top = 263
  Width = 506
  Height = 196
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 68
    Height = 13
    Caption = #1053#1072#1079#1074#1072' '#1092#1110#1088#1084#1080':'
  end
  object Label2: TLabel
    Left = 128
    Top = 88
    Width = 72
    Height = 13
    Caption = #1050#1086#1076' '#1028#1044#1056#1055#1054#1059':'
  end
  object Label3: TLabel
    Left = 128
    Top = 112
    Width = 100
    Height = 13
    Caption = #1050#1086#1076' '#1092#1110#1079#1080#1095#1085#1086#1111' '#1086#1089#1086#1073#1080':'
  end
  object Label4: TLabel
    Left = 8
    Top = 32
    Width = 43
    Height = 13
    Caption = #1040#1076#1088#1077#1089#1089#1072
  end
  object Label5: TLabel
    Left = 10
    Top = 57
    Width = 25
    Height = 13
    Caption = 'Email'
  end
  object DBEdit1: TDBEdit
    Left = 88
    Top = 4
    Width = 401
    Height = 21
    DataField = 'COMPANY_NAME'
    DataSource = DataSource
    TabOrder = 0
  end
  object DBEdit2: TDBEdit
    Left = 239
    Top = 84
    Width = 121
    Height = 21
    DataField = 'EDRPOU'
    DataSource = DataSource
    TabOrder = 1
  end
  object DBEdit3: TDBEdit
    Left = 240
    Top = 108
    Width = 121
    Height = 21
    DataField = 'WUSER'
    DataSource = DataSource
    TabOrder = 2
  end
  object DBEdit4: TDBEdit
    Left = 88
    Top = 29
    Width = 401
    Height = 21
    DataField = 'COMPANY_ADDRESS'
    DataSource = DataSource
    TabOrder = 3
  end
  object DBEdit5: TDBEdit
    Left = 88
    Top = 53
    Width = 401
    Height = 21
    DataField = 'EMAIL'
    DataSource = DataSource
    TabOrder = 4
  end
  object DBRadioGroup1: TDBRadioGroup
    Left = 8
    Top = 80
    Width = 105
    Height = 49
    Caption = #1054#1089#1086#1073#1072
    DataField = 'IDFIZ'
    DataSource = DataSource
    Items.Strings = (
      #1070#1088#1080#1076#1080#1095#1085#1072
      #1060#1110#1079#1080#1095#1085#1072)
    TabOrder = 5
    Values.Strings = (
      '0'
      '1')
  end
  object Button1: TButton
    Left = 330
    Top = 140
    Width = 75
    Height = 25
    Caption = #1054#1050
    ModalResult = 1
    TabOrder = 6
  end
  object Button2: TButton
    Left = 411
    Top = 140
    Width = 75
    Height = 25
    Caption = #1042#1110#1076#1084#1110#1085#1080#1090#1080
    ModalResult = 2
    TabOrder = 7
  end
  object DataSource: TDataSource
    DataSet = dmFunction.FIRMS
    Left = 408
    Top = 88
  end
end
