object frmConfig1c60: TfrmConfig1c60
  Left = 194
  Top = 106
  Width = 824
  Height = 476
  HelpContext = 1008
  Caption = 'frmConfig1c60'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 177
    Width = 816
    Height = 8
    Cursor = crVSplit
    Align = alTop
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 816
    Height = 177
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 814
      Height = 16
      Align = alTop
      Alignment = taCenter
      Caption = #1057#1087#1080#1089#1086#1082' '#1089#1091#1073#1082#1086#1085#1090#1086' '#1087#1086' '#1103#1082#1080#1084' '#1073#1091#1076#1077' '#1087#1088#1086#1074#1086#1076#1080#1090#1080#1089#1100' '#1092#1086#1088#1084#1091#1074#1072#1085#1085#1103' 8'#1044#1056
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    inline frCustomGrid1: TfrCustomGrid
      Left = 1
      Top = 17
      Width = 814
      Height = 159
      Align = alClient
      Constraints.MinWidth = 232
      TabOrder = 0
      inherited DBGridEh: TDBGridEh
        Width = 814
        Height = 134
        DataSource = DataSource1
        UseMultiTitle = True
        Columns = <
          item
            EditButtons = <>
            FieldName = 'ID'
            Footers = <>
            ReadOnly = True
            Title.Caption = #8470
            Width = 38
          end
          item
            EditButtons = <>
            FieldName = 'TABLENAME'
            Footers = <>
            Title.Caption = #1053#1072#1079#1074#1072' '#1089#1087#1080#1089#1082#1091
            Width = 87
          end
          item
            EditButtons = <>
            FieldName = 'FIRSTNUM'
            Footers = <>
            Title.Caption = #1060#1086#1088#1084#1091#1083#1080' '#1076#1083#1103' '#1074#1080#1079#1085#1072#1095#1077#1085#1085#1103' '#1080#1085#1090#1077#1088#1074#1072#1083#1091' '#1087#1088#1086#1075#1083#1103#1076#1091' '#1089#1087#1080#1089#1082#1072' | '#1055#1077#1088#1096#1080#1081' '
            Width = 145
          end
          item
            EditButtons = <>
            FieldName = 'LASTNUM'
            Footers = <>
            Title.Caption = #1060#1086#1088#1084#1091#1083#1080' '#1076#1083#1103' '#1074#1080#1079#1085#1072#1095#1077#1085#1085#1103' '#1080#1085#1090#1077#1088#1074#1072#1083#1091' '#1087#1088#1086#1075#1083#1103#1076#1091' '#1089#1087#1080#1089#1082#1072' | '#1054#1089#1090#1072#1085#1085#1110#1081
            Width = 139
          end
          item
            EditButtons = <>
            FieldName = 'IDNUM'
            Footers = <>
            Title.Caption = #1030#1076#1077#1085#1090#1080#1092#1110#1082#1072#1094#1110#1081#1085#1080#1081' '#1082#1086#1076' ('#1092#1086#1088#1084#1091#1083#1072')'
            Width = 94
          end
          item
            EditButtons = <>
            FieldName = 'WOKERNAME'
            Footers = <>
            Title.Caption = #1060#1086#1088#1084#1091#1083#1072' '#1076#1083#1103' '#1074#1080#1079#1085#1072#1095#1077#1085#1085#1103'  '#1055'.'#1030'.'#1041'.'
            Width = 129
          end
          item
            EditButtons = <>
            FieldName = 'INWOKER'
            Footers = <>
            Title.Caption = #1060#1086#1088#1084#1091#1083#1080' '#1076#1083#1103' '#1074#1080#1079#1085#1072#1095#1077#1085#1085#1103' '#1076#1072#1090#1080' | '#1055#1088#1080#1081#1086#1084#1091
            Width = 91
          end
          item
            EditButtons = <>
            FieldName = 'OUTWOKER'
            Footers = <>
            Title.Caption = #1060#1086#1088#1084#1091#1083#1080' '#1076#1083#1103' '#1074#1080#1079#1085#1072#1095#1077#1085#1085#1103' '#1076#1072#1090#1080' | '#1047#1074#1110#1083#1100#1085#1077#1085#1085#1103
            Width = 78
          end>
      end
      inherited Panel1: TPanel
        Width = 814
        inherited DBNavigator1: TDBNavigator
          Hints.Strings = ()
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 185
    Width = 816
    Height = 264
    Align = alClient
    TabOrder = 1
    object Label2: TLabel
      Left = 1
      Top = 1
      Width = 814
      Height = 21
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #1042#1080#1076#1080' '#1085#1072#1088#1072#1093#1091#1074#1072#1085#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    inline frCustomGrid3: TfrCustomGrid
      Left = 1
      Top = 22
      Width = 814
      Height = 241
      Align = alClient
      Constraints.MinWidth = 232
      TabOrder = 0
      inherited DBGridEh: TDBGridEh
        Width = 814
        Height = 216
        DataSource = DataSource2
        UseMultiTitle = True
        Columns = <
          item
            EditButtons = <>
            FieldName = 'COD'
            Footers = <>
            Title.Caption = #1050#1054#1044
            Width = 34
          end
          item
            EditButtons = <>
            FieldName = 'NAMEPOS'
            Footers = <>
            Title.Caption = #1042#1080#1076' '#1085#1072#1088#1072#1093#1091#1074#1072#1085#1085#1103
            Width = 93
          end
          item
            EditButtons = <>
            FieldName = 'NARAX'
            Footers = <>
            Title.Caption = #1060#1086#1088#1084#1091#1083#1072' '#1076#1083#1103' '#1085#1072#1088#1072#1093#1086#1074#1072#1075#1085#1086#1075#1086' | '#1076#1086#1093#1086#1076#1091
            Width = 176
          end
          item
            EditButtons = <>
            FieldName = 'PODAT'
            Footers = <>
            Title.Caption = #1060#1086#1088#1084#1091#1083#1072' '#1076#1083#1103' '#1085#1072#1088#1072#1093#1086#1074#1072#1075#1085#1086#1075#1086' | '#1087#1086#1076#1072#1090#1082#1091
            Width = 188
          end
          item
            EditButtons = <>
            FieldName = 'VIPLAT'
            Footers = <>
            Title.Caption = #1060#1086#1088#1084#1091#1083#1072' '#1076#1083#1103' '#1074#1080#1087#1083#1072#1095#1077#1085#1086#1075#1086' | '#1076#1086#1093#1086#1076#1091
            Width = 137
          end
          item
            EditButtons = <>
            FieldName = 'VIPPODAT'
            Footers = <>
            Title.Caption = #1060#1086#1088#1084#1091#1083#1072' '#1076#1083#1103' '#1074#1080#1087#1083#1072#1095#1077#1085#1086#1075#1086' | '#1087#1086#1076#1072#1090#1082#1091
            Width = 139
          end
          item
            EditButtons = <>
            FieldName = 'PILGA'
            Footers = <>
            Title.Caption = #1060#1086#1088#1084#1091#1083#1072' '#1076#1083#1103' '#1074#1080#1079#1085#1072#1095#1077#1085#1085#1103' '#1090#1080#1087#1091' '#1087#1110#1083#1100#1075#1080
            Width = 127
          end
          item
            EditButtons = <>
            FieldName = 'NEOPL'
            Footers = <>
            Title.Caption = #1060#1086#1088#1084#1091#1083#1072' '#1076#1083#1103' '#1074#1080#1079#1085#1072#1095#1077#1085#1085#1103' '#1085#1077#1086#1087#1083#1072#1090
            Width = 116
          end>
      end
      inherited Panel1: TPanel
        Width = 814
        inherited DBNavigator1: TDBNavigator
          Hints.Strings = ()
        end
      end
      inherited PrintDBGridEh: TPrintDBGridEh
        Top = 96
      end
    end
  end
  object DataSource1: TDataSource
    DataSet = dmFunction.ListTables
    Left = 176
    Top = 120
  end
  object DataSource2: TDataSource
    DataSet = dmFunction.Options
    Left = 184
    Top = 368
  end
end
