object frmmain_new: Tfrmmain_new
  Left = 301
  Top = 242
  Width = 452
  Height = 278
  Caption = 'frmmain_new'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Images = dmMain.ImageList
    Left = 8
    Top = 16
    object N6: TMenuItem
      Caption = #1060#1072#1081#1083
      Hint = 'Print Setup'
      object N7: TMenuItem
        Caption = #1030#1084#1087#1086#1088#1090' '#1076#1072#1085#1080#1093' ...'
        object N1603: TMenuItem
          Action = dmMain.aImport1C60
        end
        object N1773: TMenuItem
          Action = dmMain.aImport1C77
        end
      end
      object N81: TMenuItem
        Action = dmMain.aExport1DF
      end
      object N9: TMenuItem
        Action = dmMain.FilePrintSetup
      end
      object N22: TMenuItem
        Caption = '-'
      end
      object N10: TMenuItem
        Action = dmMain.FileExit
      end
    end
    object N3: TMenuItem
      Caption = #1044#1086#1074#1110#1076#1085#1080#1082#1080
      object N83: TMenuItem
        Action = dmMain.a1DF
      end
      object N12: TMenuItem
        Action = dmMain.aWokers
      end
    end
    object N14: TMenuItem
      Caption = #1047#1074#1110#1090#1080
      object N84: TMenuItem
        Action = dmMain.aReport1DF
      end
    end
    object N4: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      object N13: TMenuItem
        Action = dmMain.aOptions
      end
      object N82: TMenuItem
        Action = dmMain.aExportConfig
      end
      object N11: TMenuItem
        Action = dmMain.aImportConfig
      end
      object N1602: TMenuItem
        Action = dmMain.aConfig1C60
      end
      object N1772: TMenuItem
        Action = dmMain.aConfig1C77
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
        Action = dmMain.About
      end
      object HelponHelp2: TMenuItem
        Caption = '&Help on Help'
        Enabled = False
        Hint = 'Help on help'
      end
      object N8: TMenuItem
        Action = dmMain.aRegistration
      end
    end
  end
  object alMain: TActionList
    Images = dmMain.ImageList
    Left = 48
    Top = 16
  end
end
