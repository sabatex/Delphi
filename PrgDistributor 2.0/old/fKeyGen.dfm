object frmKeyGen: TfrmKeyGen
  Left = 262
  Top = 240
  BorderStyle = bsNone
  Caption = 'frmKeyGen'
  ClientHeight = 95
  ClientWidth = 320
  Color = clTeal
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 305
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = #1053#1072#1090#1080#1089#1082#1072#1081#1090#1077' '#1085#1072' '#1076#1086#1074#1110#1083#1100#1085#1110' '#1082#1083#1072#1074#1110#1096#1080' '#1076#1086' '#1076#1086#1089#1103#1075#1085#1077#1085#1085#1103' '#1094#1080#1092#1088#1080' 50'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clYellow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 33
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Caption = '00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Edit1: TEdit
    Left = 8
    Top = 32
    Width = 305
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
    OnKeyPress = Edit1KeyPress
  end
  object Button1: TButton
    Left = 112
    Top = 64
    Width = 177
    Height = 25
    Caption = #1057#1090#1074#1086#1088#1080#1090#1080' '#1082#1083#1102#1095
    TabOrder = 1
    Visible = False
    OnClick = Button1Click
  end
end
