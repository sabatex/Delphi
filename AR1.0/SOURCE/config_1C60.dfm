object frm_config1c60: Tfrm_config1c60
  Left = 193
  Top = 183
  Width = 832
  Height = 452
  Caption = 'frm_config1c60'
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
    Top = 177
    Width = 824
    Height = 8
    Cursor = crVSplit
    Align = alTop
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 824
    Height = 177
    Align = alTop
    TabOrder = 0
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 822
      Height = 21
      Align = alTop
      Caption = 'Panel3'
      TabOrder = 0
      object Label3: TLabel
        Left = 231
        Top = 1
        Width = 590
        Height = 19
        Align = alClient
        Alignment = taCenter
        Caption = #1057#1087#1080#1089#1086#1082' '#1089#1091#1073#1082#1086#1085#1090#1086' '#1087#1086' '#1103#1082#1080#1084' '#1073#1091#1076#1077' '#1087#1088#1086#1074#1086#1076#1080#1090#1080#1089#1100' '#1092#1086#1088#1084#1091#1074#1072#1085#1085#1103' 8'#1044#1056
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object DBNavigator1: TDBNavigator
        Left = 1
        Top = 1
        Width = 230
        Height = 19
        DataSource = dsListTables
        Align = alLeft
        TabOrder = 0
      end
    end
    object DBGridEh: TDBGridEh
      Left = 1
      Top = 22
      Width = 822
      Height = 154
      Align = alClient
      DataSource = dsListTables
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = []
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghIncSearch]
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
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
  end
  object Panel2: TPanel
    Left = 0
    Top = 185
    Width = 824
    Height = 240
    Align = alClient
    TabOrder = 1
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 822
      Height = 24
      Align = alTop
      TabOrder = 0
      object Label1: TLabel
        Left = 231
        Top = 1
        Width = 590
        Height = 22
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Caption = #1042#1080#1076#1080' '#1085#1072#1088#1072#1093#1091#1074#1072#1085#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object DBNavigator2: TDBNavigator
        Left = 1
        Top = 1
        Width = 230
        Height = 22
        DataSource = dsOptions
        Align = alLeft
        TabOrder = 0
      end
    end
    object DBGridEh1: TDBGridEh
      Left = 1
      Top = 25
      Width = 822
      Height = 214
      Align = alClient
      DataSource = dsOptions
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = []
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghIncSearch]
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
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
  end
  object ListTables: THalcyonDataSet
    About = 'Halcyon Version 6.737 (08 Feb 01)'
    AutoFlush = False
    DatabaseName = '..\BIN'
    Exclusive = False
    LockProtocol = Default
    TableName = 'LISTTABLES.DBF'
    TranslateASCII = True
    UseDeleted = False
    UserID = 0
    AfterScroll = ListTablesAfterScroll
    OnNewRecord = ListTablesNewRecord
    Left = 296
    Top = 96
    object ListTablesID: TSmallintField
      FieldName = 'ID'
    end
    object ListTablesTABLENAME: TStringField
      FieldName = 'TABLENAME'
      Size = 60
    end
    object ListTablesFIRSTNUM: TStringField
      FieldName = 'FIRSTNUM'
      Size = 255
    end
    object ListTablesLASTNUM: TStringField
      FieldName = 'LASTNUM'
      Size = 255
    end
    object ListTablesIDNUM: TStringField
      FieldName = 'IDNUM'
      Size = 255
    end
    object ListTablesINWOKER: TStringField
      FieldName = 'INWOKER'
      Size = 255
    end
    object ListTablesOUTWOKER: TStringField
      FieldName = 'OUTWOKER'
      Size = 255
    end
    object ListTablesWOKERNAME: TStringField
      FieldName = 'WOKERNAME'
      Size = 255
    end
    object ListTablesVID: TSmallintField
      FieldName = 'VID'
    end
  end
  object Options: THalcyonDataSet
    About = 'Halcyon Version 6.737 (08 Feb 01)'
    AutoFlush = False
    DatabaseName = '..\BIN'
    Exclusive = False
    LockProtocol = Default
    TableName = 'OPTIONS.DBF'
    TranslateASCII = True
    UseDeleted = False
    UserID = 0
    Left = 360
    Top = 360
    object OptionsID: TSmallintField
      FieldName = 'ID'
    end
    object OptionsCOD: TSmallintField
      FieldName = 'COD'
    end
    object OptionsNAMEPOS: TStringField
      FieldName = 'NAMEPOS'
      Size = 25
    end
    object OptionsNARAX: TStringField
      FieldName = 'NARAX'
      Size = 255
    end
    object OptionsPODAT: TStringField
      FieldName = 'PODAT'
      Size = 255
    end
    object OptionsPILGA: TStringField
      FieldName = 'PILGA'
      Size = 255
    end
    object OptionsNEOPL: TStringField
      FieldName = 'NEOPL'
      Size = 255
    end
    object OptionsVIPLAT: TStringField
      FieldName = 'VIPLAT'
      Size = 255
    end
    object OptionsVIPPODAT: TStringField
      FieldName = 'VIPPODAT'
      Size = 255
    end
  end
  object dsListTables: TDataSource
    DataSet = ListTables
    Left = 360
    Top = 96
  end
  object dsOptions: TDataSource
    DataSet = Options
    Left = 432
    Top = 360
  end
end
