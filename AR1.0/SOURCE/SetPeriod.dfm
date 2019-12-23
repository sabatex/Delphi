object frmSetPeriod: TfrmSetPeriod
  Left = 463
  Top = 328
  Width = 239
  Height = 126
  Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1087#1077#1088#1110#1086#1076#1091
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 54
    Top = 7
    Width = 23
    Height = 22
    Caption = '<'
  end
  object SpeedButton2: TSpeedButton
    Left = 203
    Top = 7
    Width = 23
    Height = 22
    Caption = '>'
  end
  object SpeedButton3: TSpeedButton
    Left = 54
    Top = 33
    Width = 23
    Height = 22
    Caption = '<'
  end
  object SpeedButton4: TSpeedButton
    Left = 204
    Top = 33
    Width = 23
    Height = 22
    Caption = '>'
  end
  object Label1: TLabel
    Left = 0
    Top = 11
    Width = 18
    Height = 13
    Caption = #1056#1110#1082':'
  end
  object Label2: TLabel
    Left = 0
    Top = 36
    Width = 45
    Height = 13
    Caption = #1050#1074#1072#1088#1090#1072#1083':'
  end
  object Button1: TButton
    Left = 72
    Top = 64
    Width = 75
    Height = 25
    Caption = #1054#1050
    TabOrder = 0
  end
  object Button2: TButton
    Left = 152
    Top = 64
    Width = 75
    Height = 25
    Caption = #1042#1110#1076#1084#1110#1085#1080#1090#1080
    TabOrder = 1
  end
  object Year: TEdit
    Left = 79
    Top = 7
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'Year'
  end
  object Kvartal: TEdit
    Left = 80
    Top = 33
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'Kvartal'
  end
end
