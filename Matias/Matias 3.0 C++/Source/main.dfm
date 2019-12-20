object frmMain: TfrmMain
  Left = 195
  Top = 132
  Width = 790
  Height = 480
  Caption = 'frmMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = dmMain.MainMenu
  OldCreateOrder = False
  PopupMenu = dmMain.PopupMenu
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 415
    Width = 782
    Height = 19
    Panels = <
      item
        Text = #1057#1090#1072#1090#1091#1089':'
        Width = 50
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object pFirms: TPanel
    Left = 0
    Top = 0
    Width = 782
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 4
      Top = 5
      Width = 40
      Height = 13
      Caption = #1060#1080#1088#1084#1072':'
    end
    object Label2: TLabel
      Left = 317
      Top = 5
      Width = 21
      Height = 13
      Caption = #1043#1086#1076':'
    end
    object Label3: TLabel
      Left = 399
      Top = 3
      Width = 36
      Height = 13
      Caption = #1052#1077#1089#1103#1094':'
    end
    object M_MONTH: TComboBox
      Left = 439
      Top = 0
      Width = 105
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = #1071#1085#1074#1072#1088#1100
      OnClick = cbFirmsClick
      Items.Strings = (
        #1071#1085#1074#1072#1088#1100
        #1060#1077#1074#1088#1072#1083#1100
        #1052#1072#1088#1090
        #1040#1087#1088#1077#1083#1100
        #1052#1072#1081
        #1048#1102#1085#1100
        #1048#1102#1083#1100
        #1040#1074#1075#1091#1089#1090
        #1057#1077#1085#1090#1103#1073#1088#1100
        #1054#1082#1090#1103#1073#1088#1100
        #1053#1086#1103#1073#1088#1100
        #1044#1077#1082#1072#1073#1088#1100)
    end
    object cbFirms: TComboBox
      Left = 48
      Top = 0
      Width = 241
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = 'cbFirms'
      OnClick = cbFirmsClick
    end
    object OldWokers: TCheckBox
      Left = 550
      Top = 2
      Width = 208
      Height = 17
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1091#1074#1086#1083#1077#1085#1099#1093' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
      TabOrder = 1
      OnClick = cbFirmsClick
    end
    object M_YEAR: TCSpinEdit
      Left = 344
      Top = 0
      Width = 49
      Height = 22
      MaxValue = 3000
      MinValue = 1900
      TabOrder = 3
      Value = 2004
      OnChange = cbFirmsClick
      OnClick = cbFirmsClick
    end
  end
end
