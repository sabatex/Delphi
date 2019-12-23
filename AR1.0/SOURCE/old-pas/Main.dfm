object MainDlg: TMainDlg
  Left = 210
  Top = 198
  Width = 834
  Height = 620
  HelpType = htKeyword
  HelpContext = 1003
  VertScrollBar.Tracking = True
  Caption = #1041#1091#1093#1075#1072#1083#1090#1077#1088#1089#1100#1082#1072' '#1079#1074#1110#1090#1085#1110#1089#1090#1100
  Color = clActiveBorder
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object sbMain: TStatusBar
    Left = 0
    Top = 555
    Width = 826
    Height = 19
    Panels = <
      item
        Text = #1055#1077#1088#1110#1086#1076
        Width = 50
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object MainMenu1: TMainMenu
    Images = dmFunction.ImageList
    Left = 8
    Top = 16
    object N6: TMenuItem
      Caption = #1060#1072#1081#1083
      Hint = 'Print Setup'
      object N7: TMenuItem
        Caption = #1030#1084#1087#1086#1088#1090' '#1076#1072#1085#1080#1093' ...'
        object N1603: TMenuItem
          Action = dmFunction.Import8DRfrom1C60
        end
        object N1773: TMenuItem
          Action = dmFunction.Import8DRfrom1c77
        end
      end
      object N81: TMenuItem
        Action = dmFunction.Export8DR
      end
      object N9: TMenuItem
        Action = dmFunction.FilePrintSetup
      end
      object N22: TMenuItem
        Caption = '-'
      end
      object N10: TMenuItem
        Action = dmFunction.FileExit
      end
    end
    object N3: TMenuItem
      Caption = #1044#1086#1074#1110#1076#1085#1080#1082#1080
      object N83: TMenuItem
        Action = dmFunction.aEdit8DR
      end
      object N12: TMenuItem
        Action = dmFunction.aEditWokers
      end
    end
    object N14: TMenuItem
      Caption = #1047#1074#1110#1090#1080
      object N84: TMenuItem
        Action = dmFunction.Report8DR
      end
    end
    object N4: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      object N13: TMenuItem
        Action = dmFunction.FirmsParam
      end
      object N82: TMenuItem
        Action = dmFunction.ExportConfig1C60
      end
      object N11: TMenuItem
        Action = dmFunction.ImportConfig1C60
      end
      object N1602: TMenuItem
        Action = dmFunction.Configuration1C60
      end
      object N1772: TMenuItem
        Action = dmFunction.Configuration1c77
      end
    end
    object N5: TMenuItem
      Caption = #1042#1110#1082#1085#1072
      object N15: TMenuItem
        Caption = #1059#1087#1086#1088#1103#1076#1082#1091#1074#1072#1090#1080
        Enabled = False
      end
      object N20: TMenuItem
        Caption = #1042#1077#1088#1090#1080#1082#1072#1083#1100#1085#1086
        Enabled = False
        Hint = 'Tile Vertical'
        ImageIndex = 2
      end
      object N16: TMenuItem
        Caption = #1050#1072#1089#1082#1072#1076
        Enabled = False
        Hint = 'Cascade'
        ImageIndex = 0
      end
      object N19: TMenuItem
        Caption = #1043#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1086
        Enabled = False
        Hint = 'Tile Horizontal'
        ImageIndex = 1
      end
      object N18: TMenuItem
        Caption = #1047#1075#1086#1088#1085#1091#1090#1080' '#1042#1089#1110
        Enabled = False
        Hint = 'Minimize All'
      end
      object N17: TMenuItem
        Caption = #1047#1072#1082#1088#1080#1090#1080
        Enabled = False
        Hint = 'Close'
      end
    end
    object N1: TMenuItem
      Caption = '?'
      object N2: TMenuItem
        Action = dmFunction.About
      end
      object HelponHelp2: TMenuItem
        Caption = '&Help on Help'
        Enabled = False
        Hint = 'Help on help'
      end
      object N8: TMenuItem
        Action = dmFunction.Registration
      end
    end
  end
end
