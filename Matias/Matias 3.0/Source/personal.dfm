inherited frmPersonal: TfrmPersonal
  Left = 278
  Top = 188
  Width = 469
  Caption = 'frmPersonal'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel2: TPanel
    Width = 461
    inherited btPanel: TPanel
      inherited DBNavigator1: TDBNavigator
        Hints.Strings = ()
      end
    end
    object Panel1: TPanel
      Left = 185
      Top = 1
      Width = 275
      Height = 23
      Align = alClient
      TabOrder = 1
      object OldWokers: TCheckBox
        Left = 8
        Top = 2
        Width = 208
        Height = 17
        Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1091#1074#1086#1083#1077#1085#1099#1093' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
        TabOrder = 0
      end
    end
  end
  inherited DBGridEh: TDBGridEh
    Width = 461
    Columns = <
      item
        EditButtons = <>
        FieldName = 'PERSONAL_NR'
        Footers = <>
        MaxWidth = 45
        MinWidth = 45
        Title.Caption = #1058#1072#1073'. '#8470
        Title.TitleButton = True
        Width = 45
      end
      item
        EditButtons = <>
        FieldName = 'PERSONAL_NAME'
        Footers = <>
        MinWidth = 150
        Title.Caption = #1055'.'#1030'.'#1041'.'
        Title.TitleButton = True
        Width = 179
      end
      item
        EditButtons = <>
        FieldName = 'DATE_IN'
        Footers = <>
        MaxWidth = 65
        MinWidth = 65
        Title.Caption = #1044#1072#1090#1072' | '#1087#1088#1080#1081#1100#1086#1084#1072
        Title.TitleButton = True
        Width = 65
      end
      item
        EditButtons = <>
        FieldName = 'DATE_OUT'
        Footers = <>
        MaxWidth = 65
        MinWidth = 65
        Title.Caption = #1044#1072#1090#1072' | '#1079#1074#1110#1083#1100#1085#1077#1085#1085#1103
        Width = 65
      end>
  end
  inherited StatusBar: TStatusBar
    Width = 461
  end
  inherited dsGrid: TDataSource
    DataSet = PERSONAL
  end
  object PERSONAL: TpFIBDataSet
    Database = dmBase.mainDatabase
    Transaction = dmBase.mainTransaction
    UpdateSQL.Strings = (
      'UPDATE PERSONAL'
      'SET '
      '    PERSONAL_NR = ?PERSONAL_NR,'
      '    PERSONAL_NAME = ?PERSONAL_NAME,'
      '    DATE_IN = ?DATE_IN,'
      '    DATE_OUT = ?DATE_OUT,'
      '    FIRMS_ID = ?FIRMS_ID,'
      '    TIN = ?TIN'
      'WHERE'
      '    ID = ?OLD_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    PERSONAL'
      'WHERE'
      '        ID = ?OLD_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO PERSONAL('
      '    ID,'
      '    PERSONAL_NR,'
      '    PERSONAL_NAME,'
      '    DATE_IN,'
      '    DATE_OUT,'
      '    FIRMS_ID,'
      '    TIN'
      ')'
      'VALUES('
      '    ?ID,'
      '    ?PERSONAL_NR,'
      '    ?PERSONAL_NAME,'
      '    ?DATE_IN,'
      '    ?DATE_OUT,'
      '    ?FIRMS_ID,'
      '    ?TIN'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    ID,'
      '    PERSONAL_NR,'
      '    PERSONAL_NAME,'
      '    DATE_IN,'
      '    DATE_OUT,'
      '    FIRMS_ID,'
      '    TIN'
      'FROM'
      '    PERSONAL '
      ' WHERE '
      '        PERSONAL.ID = ?OLD_ID'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    ID,'
      '    PERSONAL_NR,'
      '    PERSONAL_NAME,'
      '    DATE_IN,'
      '    DATE_OUT,'
      '    FIRMS_ID,'
      '    TIN'
      'FROM'
      '    PERSONAL'
      'WHERE'
      '    FIRMS_ID = ?ID_FIRM ')
    BeforePost = PERSONALBeforePost
    AutoUpdateOptions.UpdateTableName = 'PERSONAL'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'Personal'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Left = 80
    Top = 160
    poSQLINT64ToBCD = True
    object PERSONALID: TFIBIntegerField
      FieldName = 'ID'
    end
    object PERSONALPERSONAL_NR: TFIBIntegerField
      FieldName = 'PERSONAL_NR'
    end
    object PERSONALPERSONAL_NAME: TFIBStringField
      FieldName = 'PERSONAL_NAME'
      Size = 60
      EmptyStrToNull = True
    end
    object PERSONALDATE_IN: TFIBDateField
      FieldName = 'DATE_IN'
    end
    object PERSONALDATE_OUT: TFIBDateField
      FieldName = 'DATE_OUT'
    end
    object PERSONALFIRMS_ID: TFIBIntegerField
      FieldName = 'FIRMS_ID'
    end
    object PERSONALTIN: TFIBStringField
      FieldName = 'TIN'
      Size = 10
      EmptyStrToNull = True
    end
  end
end
