object frm_1df: Tfrm_1df
  Left = 194
  Top = 127
  Width = 823
  Height = 480
  Caption = 'frm_1df'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 105
    Top = 24
    Width = 3
    Height = 410
    Cursor = crHSplit
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 815
    Height = 24
    Align = alTop
    TabOrder = 0
    object DBNavigator1: TDBNavigator
      Left = 0
      Top = -1
      Width = 200
      Height = 23
      DataSource = dsDA
      TabOrder = 0
    end
  end
  object DBGridEh: TDBGridEh
    Left = 108
    Top = 24
    Width = 707
    Height = 410
    Align = alClient
    DataSource = dsDA
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    FooterColor = clTeal
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clBlack
    FooterFont.Height = -11
    FooterFont.Name = 'MS Sans Serif'
    FooterFont.Style = [fsBold]
    FooterRowCount = 1
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghIncSearch]
    ParentFont = False
    SumList.Active = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    UseMultiTitle = True
    OnEditButtonClick = DBGridEhEditButtonClick
    Columns = <
      item
        EditButtons = <>
        FieldName = 'NP'
        Footers = <>
        Title.Caption = #8470' '#1087'/'#1087
        Width = 32
      end
      item
        ButtonStyle = cbsEllipsis
        EditButtons = <>
        FieldName = 'TIN'
        Footers = <>
        ReadOnly = True
        Title.Caption = #1030#1053#1053
        Width = 49
      end
      item
        EditButtons = <>
        FieldName = 'PERSONAL_NAME'
        Footers = <>
        ReadOnly = True
        Title.Caption = #1055'.'#1030'.'#1041'.'
        Width = 132
      end
      item
        EditButtons = <>
        FieldName = 'S_NAR'
        Footer.FieldName = 'S_NAR'
        Footer.ValueType = fvtSum
        Footers = <>
        Title.Caption = #1057#1091#1084#1084#1072' '#1085#1072#1088#1072#1093#1086#1074#1072#1085#1086#1075#1086' | '#1076#1086#1093#1086#1076#1091
        Width = 59
      end
      item
        EditButtons = <>
        FieldName = 'S_TAXN'
        Footer.FieldName = 'S_TAXN'
        Footer.ValueType = fvtSum
        Footers = <>
        Title.Caption = #1057#1091#1084#1084#1072' '#1085#1072#1088#1072#1093#1086#1074#1072#1085#1086#1075#1086' | '#1087#1086#1076#1072#1090#1082#1091
        Width = 55
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
        Width = 60
      end
      item
        EditButtons = <>
        FieldName = 'OZN_DOX'
        Footers = <>
        Title.Caption = #1054#1079#1085#1072#1082#1072' |  '#1076#1086#1093#1086#1076#1091
        Width = 46
      end
      item
        EditButtons = <>
        FieldName = 'OZN_PILG'
        Footers = <>
        Title.Caption = #1054#1079#1085#1072#1082#1072' | '#1087#1110#1083#1100#1075
        Width = 37
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
        Width = 66
      end
      item
        EditButtons = <>
        FieldName = 'OZNAKA'
        Footers = <>
        Title.Caption = #1054#1079#1085#1072#1082#1072' (0,1)'
        Width = 45
      end>
  end
  object TreePeriod: TTreeView
    Left = 0
    Top = 24
    Width = 105
    Height = 410
    Align = alLeft
    HideSelection = False
    Indent = 19
    ReadOnly = True
    TabOrder = 2
    OnDblClick = TreePeriodDblClick
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 434
    Width = 815
    Height = 19
    Panels = <
      item
        Width = 200
      end>
    SimplePanel = False
  end
  object dsDA: TDataSource
    DataSet = DA
    Left = 336
    Top = 192
  end
  object DA: TpFIBDataSet
    Database = dmBase.mainDatabase
    Transaction = dmBase.mainTransaction
    AutoCommit = True
    UpdateSQL.Strings = (
      'UPDATE DA'
      'SET '
      '    ID = :ID,'
      '    PERIOD = :PERIOD,'
      '    RIK = :RIK,'
      '    S_NAR = :S_NAR,'
      '    S_DOX = :S_DOX,'
      '    S_TAXN = :S_TAXN,'
      '    S_TAXP = :S_TAXP,'
      '    D_PRIYN = :D_PRIYN,'
      '    D_ZVILN = :D_ZVILN,'
      '    OZN_DOX = :OZN_DOX,'
      '    OZN_PILG = :OZN_PILG,'
      '    OZNAKA = :OZNAKA,'
      '    WOKERS_ID = :WOKERS_ID,'
      '    NP = :NP'
      'WHERE'
      '    ID = :OLD_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    DA'
      'WHERE'
      '        ID = :OLD_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO DA('
      '    ID,'
      '    PERIOD,'
      '    RIK,'
      '    S_NAR,'
      '    S_DOX,'
      '    S_TAXN,'
      '    S_TAXP,'
      '    D_PRIYN,'
      '    D_ZVILN,'
      '    OZN_DOX,'
      '    OZN_PILG,'
      '    OZNAKA,'
      '    WOKERS_ID,'
      '    NP'
      ')'
      'VALUES('
      '    :ID,'
      '    :PERIOD,'
      '    :RIK,'
      '    :S_NAR,'
      '    :S_DOX,'
      '    :S_TAXN,'
      '    :S_TAXP,'
      '    :D_PRIYN,'
      '    :D_ZVILN,'
      '    :OZN_DOX,'
      '    :OZN_PILG,'
      '    :OZNAKA,'
      '    :WOKERS_ID,'
      '    :NP'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    ID,'
      '    PERIOD,'
      '    RIK,'
      '    S_NAR,'
      '    S_DOX,'
      '    S_TAXN,'
      '    S_TAXP,'
      '    D_PRIYN,'
      '    D_ZVILN,'
      '    OZN_DOX,'
      '    OZN_PILG,'
      '    OZNAKA,'
      '    WOKERS_ID,'
      '    NP'
      'FROM'
      '    DA '
      ' WHERE '
      '        DA.ID = :OLD_ID'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    D.ID,'
      '    D.PERIOD,'
      '    D.RIK,'
      '    D.S_NAR,'
      '    D.S_DOX,'
      '    D.S_TAXN,'
      '    D.S_TAXP,'
      '    D.D_PRIYN,'
      '    D.D_ZVILN,'
      '    D.OZN_DOX,'
      '    D.OZN_PILG,'
      '    D.OZNAKA,'
      '    D.WOKERS_ID,'
      '    D.NP,'
      '    P.TIN,'
      '    P.PERSONAL_NAME'
      'FROM'
      '    DA D'
      'LEFT JOIN PERSONAL P ON (WOKERS_ID = P.ID) ')
    AfterInsert = DAAfterInsert
    AutoUpdateOptions.UpdateTableName = 'DA'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'DA_G'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Left = 264
    Top = 192
    poSQLINT64ToBCD = True
  end
  object Tree: TpFIBDataSet
    Database = dmBase.mainDatabase
    Transaction = dmBase.mainTransaction
    SelectSQL.Strings = (
      'select RIK,PERIOD from DA'
      'GROUP BY RIK,PERIOD')
    Left = 72
    Top = 176
    poSQLINT64ToBCD = True
  end
end
