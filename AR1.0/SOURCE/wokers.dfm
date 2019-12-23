object frm_wokers: Tfrm_wokers
  Left = 189
  Top = 146
  Width = 335
  Height = 480
  Caption = 'frm_wokers'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 327
    Height = 19
    Align = alTop
    TabOrder = 0
    object DBNavigator1: TDBNavigator
      Left = 1
      Top = 1
      Width = 200
      Height = 18
      DataSource = dsWokers
      Align = alLeft
      TabOrder = 0
    end
  end
  object DBGridEh: TDBGridEh
    Left = 0
    Top = 19
    Width = 327
    Height = 434
    Align = alClient
    DataSource = dsWokers
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
    OnDblClick = DBGridEhDblClick
    OnEditButtonClick = DBGridEhEditButtonClick
    OnKeyDown = DBGridEhKeyDown
    Columns = <
      item
        EditButtons = <>
        FieldName = 'TIN'
        Footers = <>
        Title.TitleButton = True
      end
      item
        EditButtons = <>
        FieldName = 'PERSONAL_NAME'
        Footers = <>
        Title.Caption = #1055'.'#1030'.'#1041'.'
        Title.TitleButton = True
      end
      item
        ButtonStyle = cbsEllipsis
        EditButtons = <>
        FieldName = 'D_PRIYN'
        Footers = <>
        ReadOnly = True
      end
      item
        ButtonStyle = cbsEllipsis
        EditButtons = <>
        FieldName = 'D_ZVILN'
        Footers = <>
        ReadOnly = True
      end>
  end
  object dsWokers: TDataSource
    DataSet = personal
    Left = 176
    Top = 144
  end
  object personal: TpFIBDataSet
    Database = dmBase.mainDatabase
    Transaction = dmBase.mainTransaction
    AutoCommit = True
    UpdateSQL.Strings = (
      'UPDATE PERSONAL'
      'SET '
      '    TIN = :TIN,'
      '    PERSONAL_NAME = :PERSONAL_NAME,'
      '    D_PRIYN = :D_PRIYN,'
      '    D_ZVILN = :D_ZVILN'
      'WHERE'
      '    ID = :OLD_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    PERSONAL'
      'WHERE'
      '        ID = :OLD_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO PERSONAL('
      '    ID,'
      '    TIN,'
      '    PERSONAL_NAME,'
      '    D_PRIYN,'
      '    D_ZVILN'
      ')'
      'VALUES('
      '    :ID,'
      '    :TIN,'
      '    :PERSONAL_NAME,'
      '    :D_PRIYN,'
      '    :D_ZVILN'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    ID,'
      '    TIN,'
      '    PERSONAL_NAME,'
      '    D_PRIYN,'
      '    D_ZVILN'
      'FROM'
      '    PERSONAL '
      ' WHERE '
      '        PERSONAL.ID = :OLD_ID'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    ID,'
      '    TIN,'
      '    PERSONAL_NAME,'
      '    D_PRIYN,'
      '    D_ZVILN'
      'FROM'
      '    PERSONAL ')
    ReceiveEvents.Strings = (
      'UNQ_PERSONAL')
    AutoUpdateOptions.UpdateTableName = 'PERSONAL'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'PERSONAL'
    AutoUpdateOptions.WhenGetGenID = wgOnNewRecord
    Left = 104
    Top = 144
    poSQLINT64ToBCD = True
  end
end
