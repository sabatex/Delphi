object frmPersonal: TfrmPersonal
  Left = 240
  Top = 170
  Width = 475
  Height = 298
  Caption = 'frmPersonal'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inline frCustomGrid1: TfrCustomGrid
    Left = 0
    Top = 0
    Width = 467
    Height = 271
    Align = alClient
    Constraints.MinWidth = 232
    PopupMenu = frmMain.PopupMenu1
    TabOrder = 0
    inherited Panel1: TPanel
      Width = 467
      inherited DBNavigator1: TDBNavigator
        Hints.Strings = ()
      end
    end
    inherited DBGridEh: TDBGridEh
      Width = 467
      Height = 246
      DataSource = dmBase.dsPersonal
      Columns = <
        item
          EditButtons = <>
          FieldName = 'PERSONAL_NAME'
          Footers = <>
          Title.Caption = #1060#1048#1054
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'PERSONAL_NR'
          Footers = <>
          Title.Caption = #8470
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'DATE_IN'
          Footers = <>
          Title.Caption = #1044#1072#1090#1072' '#1087#1088#1080#1105#1084#1072
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'DATE_OUT'
          Footers = <>
          Title.Caption = #1059#1074#1086#1083#1077#1085'('#1072')'
          Title.TitleButton = True
        end>
    end
  end
end
