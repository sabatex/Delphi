object frm_periodic: Tfrm_periodic
  Left = 239
  Top = 219
  Width = 269
  Height = 184
  Caption = 'frm_periodic'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 261
    Height = 25
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 0
  end
  object DBGridEh1: TDBGridEh
    Left = 0
    Top = 25
    Width = 261
    Height = 132
    Align = alClient
    DataSource = DataSource1
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'MS Sans Serif'
    FooterFont.Style = []
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        EditButtons = <>
        FieldName = 'DATE_VALUE'
        Footers = <>
        Width = 94
      end
      item
        EditButtons = <>
        FieldName = 'Periodic_field'
        Footers = <>
        Width = 72
      end>
  end
  object periodic_date: TpFIBDataSet
    Database = dmBase.mainDatabase
    Transaction = dmBase_def.mainTransaction
    UpdateTransaction = dmBase.mainTransaction
    UpdateSQL.Strings = (
      
        'execute procedure set_periodic_date(:parent_filter,:DATE_VALUE,:' +
        'D_VALUE)')
    DeleteSQL.Strings = (
      'DELETE FROM'
      '    DATE_PERIODIC'
      'WHERE'
      '        ID = :OLD_ID'
      '    ')
    InsertSQL.Strings = (
      
        'execute procedure set_periodic_data(:parent_index,:DATE_FOR_VALU' +
        'E,:VALUE_INT64)')
    RefreshSQL.Strings = (
      'SELECT'
      '    ID,'
      '    PARENT,'
      '    DATE_VALUE,'
      '    D_VALUE'
      'FROM'
      '    DATE_PERIODIC '
      ' WHERE '
      '        DATE_PERIODIC.ID = :OLD_ID'
      '    ')
    SelectSQL.Strings = (
      'SELECT'
      '    PARENT_INDEX,'
      '    DATE_FOR_VALUE,'
      '    VALUE_INT64'
      'FROM'
      '    PERIODIC_DATA$'
      'WHERE'
      '    PARENT_INDEX = :PARENT_INDEX ')
    Left = 24
    Top = 88
    poSQLINT64ToBCD = True
    object periodic_datePeriodic_field: TVariantField
      FieldKind = fkCalculated
      FieldName = 'Periodic_field'
      Calculated = True
    end
  end
  object DataSource1: TDataSource
    DataSet = periodic_date
    Left = 64
    Top = 88
  end
end
