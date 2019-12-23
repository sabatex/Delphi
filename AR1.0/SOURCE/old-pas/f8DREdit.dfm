object frm8DREdit: Tfrm8DREdit
  Left = 276
  Top = 214
  Width = 557
  Height = 428
  Caption = 'frm8DREdit'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inline frCustomGrid1: TfrCustomGrid
    Left = 0
    Top = 0
    Width = 549
    Height = 401
    Align = alClient
    Constraints.MinWidth = 232
    TabOrder = 0
    inherited DBGridEh: TDBGridEh
      Width = 549
      Height = 376
      DataSource = dmFunction.dsDA
      FooterColor = clTeal
      FooterFont.Color = clBlack
      FooterFont.Style = [fsBold]
      FooterRowCount = 1
      ParentFont = False
      SumList.Active = True
      UseMultiTitle = True
      Columns = <
        item
          EditButtons = <>
          FieldName = 'NP'
          Footers = <>
          Title.Caption = #8470' '#1087'/'#1087
        end
        item
          EditButtons = <>
          FieldName = 'TINL'
          Footers = <>
          Title.Caption = #1030#1053#1053
        end
        item
          EditButtons = <>
          FieldName = 'WokerName'
          Footers = <>
          Title.Caption = #1055'.'#1030'.'#1041'.'
          Width = 274
        end
        item
          EditButtons = <>
          FieldName = 'S_NAR'
          Footer.FieldName = 'S_NAR'
          Footer.ValueType = fvtSum
          Footers = <>
          Title.Caption = #1057#1091#1084#1084#1072' '#1085#1072#1088#1072#1093#1086#1074#1072#1085#1086#1075#1086' | '#1076#1086#1093#1086#1076#1091
        end
        item
          EditButtons = <>
          FieldName = 'S_TAXN'
          Footer.FieldName = 'S_TAXN'
          Footer.ValueType = fvtSum
          Footers = <>
          Title.Caption = #1057#1091#1084#1084#1072' '#1085#1072#1088#1072#1093#1086#1074#1072#1085#1086#1075#1086' | '#1087#1086#1076#1072#1090#1082#1091
        end
        item
          EditButtons = <>
          FieldName = 'S_DOX'
          Footer.FieldName = 'S_DOX'
          Footer.ValueType = fvtSum
          Footers = <>
          Title.Caption = #1057#1091#1084#1084#1072' '#1087#1077#1088#1077#1088#1072#1093#1086#1074#1072#1085#1086#1075#1086' | '#1076#1086#1093#1086#1076#1091
        end
        item
          EditButtons = <>
          FieldName = 'S_TAXP'
          Footer.FieldName = 'S_TAXP'
          Footer.ValueType = fvtSum
          Footers = <>
          Title.Caption = #1057#1091#1084#1084#1072' '#1087#1077#1088#1077#1088#1072#1093#1086#1074#1072#1085#1086#1075#1086' | '#1087#1086#1076#1072#1090#1082#1091
        end
        item
          EditButtons = <>
          FieldName = 'OZN_DOX'
          Footers = <>
          Title.Caption = #1054#1079#1085#1072#1082#1072' |  '#1076#1086#1093#1086#1076#1091
        end
        item
          EditButtons = <>
          FieldName = 'OZN_PILG'
          Footers = <>
          Title.Caption = #1054#1079#1085#1072#1082#1072' | '#1087#1110#1083#1100#1075
        end
        item
          EditButtons = <>
          FieldName = 'D_PRIYN'
          Footers = <>
          Title.Caption = #1044#1072#1090#1072' | '#1087#1088#1080#1081#1086#1084#1091
        end
        item
          EditButtons = <>
          FieldName = 'D_ZVILN'
          Footers = <>
          Title.Caption = #1044#1072#1090#1072' | '#1079#1074#1110#1083#1100#1085#1077#1085#1085#1103
        end
        item
          EditButtons = <>
          FieldName = 'OZNAKA'
          Footers = <>
          Title.Caption = #1054#1079#1085#1072#1082#1072' (0,1)'
        end>
    end
    inherited Panel1: TPanel
      Width = 549
      inherited DBNavigator1: TDBNavigator
        Hints.Strings = ()
      end
    end
  end
end
