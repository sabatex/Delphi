object frmOrder: TfrmOrder
  Left = 192
  Top = 107
  Width = 696
  Height = 480
  Caption = 'frmOrder'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 144
    Width = 688
    Height = 5
    Cursor = crVSplit
    Align = alTop
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 144
    Align = alTop
    TabOrder = 0
    inline frCustomGrid1: TfrCustomGrid
      Left = 1
      Top = 1
      Width = 686
      Height = 142
      Align = alClient
      Constraints.MinWidth = 232
      TabOrder = 0
      inherited Panel1: TPanel
        Width = 686
        inherited DBNavigator1: TDBNavigator
          Width = 210
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbRefresh]
          Hints.Strings = ()
        end
      end
      inherited DBGridEh: TDBGridEh
        Width = 686
        Height = 117
        DataSource = dmBase.dsPersonal
        ReadOnly = True
        Columns = <
          item
            EditButtons = <>
            FieldName = 'PERSONAL_NR'
            Footers = <>
            Title.Caption = #1053#1086#1084#1077#1088
            Title.TitleButton = True
          end
          item
            EditButtons = <>
            FieldName = 'PERSONAL_NAME'
            Footers = <>
            Title.Caption = #1060#1048#1054
            Title.TitleButton = True
          end>
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 149
    Width = 688
    Height = 304
    Align = alClient
    TabOrder = 1
    inline frCustomGrid2: TfrCustomGrid
      Left = 1
      Top = 1
      Width = 686
      Height = 302
      Align = alClient
      Constraints.MinWidth = 232
      TabOrder = 0
      inherited Panel1: TPanel
        Width = 686
        inherited SpeedButton1: TSpeedButton
          Left = 230
        end
        inherited DBNavigator1: TDBNavigator
          Width = 210
          Hints.Strings = ()
        end
      end
      inherited DBGridEh: TDBGridEh
        Width = 686
        Height = 277
        DataSource = dmBase.dsOrders
        OnKeyPress = frCustomGrid2DBGridEhKeyPress
        Columns = <
          item
            EditButtons = <>
            FieldName = 'OPERATION_NAME'
            Footers = <>
            ReadOnly = True
            Title.TitleButton = True
            Width = 119
          end
          item
            EditButtons = <>
            FieldName = 'CASHE'
            Footers = <>
            ReadOnly = True
            Title.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100
            Title.TitleButton = True
          end
          item
            EditButtons = <>
            FieldName = 'COUNTS'
            Footers = <>
            Title.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
            Title.TitleButton = True
          end
          item
            EditButtons = <>
            FieldName = 'TOTAL'
            Footers = <>
            ReadOnly = True
            Title.Caption = #1042#1089#1077#1075#1086
            Title.TitleButton = True
          end
          item
            EditButtons = <>
            FieldName = 'OPERATION_TYPE'
            Footers = <>
            Title.Caption = #1042#1080#1076' '#1086#1087#1077#1088#1072#1094#1080#1080
          end>
      end
    end
  end
end
