object frmFirms_def: TfrmFirms_def
  Left = 240
  Top = 220
  Width = 512
  Height = 299
  Caption = 'frmFirms_def'
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
    Width = 504
    Height = 28
    Align = alTop
    TabOrder = 1
    object DBNavigator1: TDBNavigator
      Left = 2
      Top = 2
      Width = 240
      Height = 25
      DataSource = DataSource
      TabOrder = 0
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 28
    Width = 504
    Height = 244
    ActivePage = TabSheet1
    Align = alClient
    Style = tsFlatButtons
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #1058#1072#1073#1083#1080#1094#1103
      object DBGridEh1: TDBGridEh
        Left = 0
        Top = 0
        Width = 496
        Height = 213
        Align = alClient
        DataSource = DataSource
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            EditButtons = <>
            FieldName = 'COMPANY_NAME'
            Footers = <>
            Title.Caption = #1053#1072#1079#1074#1072' '#1092#1110#1088#1084#1080
          end
          item
            EditButtons = <>
            FieldName = 'EDRPOU'
            Footers = <>
            Title.Caption = #1028#1044#1056#1055#1054#1059
          end>
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1056#1077#1076#1072#1075#1091#1074#1072#1085#1085#1103
      ImageIndex = 1
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 68
        Height = 13
        Caption = #1053#1072#1079#1074#1072' '#1092#1110#1088#1084#1080':'
      end
      object Label2: TLabel
        Left = 128
        Top = 88
        Width = 72
        Height = 13
        Caption = #1050#1086#1076' '#1028#1044#1056#1055#1054#1059':'
      end
      object Label3: TLabel
        Left = 128
        Top = 112
        Width = 100
        Height = 13
        Caption = #1050#1086#1076' '#1092#1110#1079#1080#1095#1085#1086#1111' '#1086#1089#1086#1073#1080':'
      end
      object Label4: TLabel
        Left = 8
        Top = 32
        Width = 43
        Height = 13
        Caption = #1040#1076#1088#1077#1089#1089#1072
      end
      object Label5: TLabel
        Left = 10
        Top = 57
        Width = 25
        Height = 13
        Caption = 'Email'
      end
      object DBEdit1: TDBEdit
        Left = 88
        Top = 4
        Width = 401
        Height = 21
        DataField = 'COMPANY_NAME'
        DataSource = DataSource
        TabOrder = 0
      end
      object DBEdit2: TDBEdit
        Left = 239
        Top = 84
        Width = 121
        Height = 21
        DataField = 'EDRPOU'
        DataSource = DataSource
        TabOrder = 1
      end
      object DBEdit3: TDBEdit
        Left = 240
        Top = 108
        Width = 121
        Height = 21
        DataField = 'WUSER'
        DataSource = DataSource
        TabOrder = 2
      end
      object DBEdit4: TDBEdit
        Left = 88
        Top = 29
        Width = 401
        Height = 21
        DataField = 'COMPANY_ADDRESS'
        DataSource = DataSource
        TabOrder = 3
      end
      object DBEdit5: TDBEdit
        Left = 88
        Top = 53
        Width = 401
        Height = 21
        DataField = 'EMAIL'
        DataSource = DataSource
        TabOrder = 4
      end
      object DBRadioGroup1: TDBRadioGroup
        Left = 8
        Top = 80
        Width = 105
        Height = 49
        Caption = #1054#1089#1086#1073#1072
        DataField = 'IDFIZ'
        DataSource = DataSource
        Items.Strings = (
          #1070#1088#1080#1076#1080#1095#1085#1072
          #1060#1110#1079#1080#1095#1085#1072)
        TabOrder = 5
        Values.Strings = (
          '0'
          '1')
      end
    end
  end
  object DataSource1: TDataSource
    Left = 584
    Top = 48
  end
  object DataSource: TDataSource
    DataSet = Firms
    Left = 192
    Top = 64
  end
  object taFirms: TpFIBTransaction
    DefaultDatabase = dmBase_def.mainDatabase
    TimeoutAction = TARollback
    Left = 288
    Top = 64
  end
  object Firms: TpFIBDataSet
    Database = dmBase_def.mainDatabase
    Transaction = taFirms
    AutoCommit = True
    UpdateSQL.Strings = (
      'UPDATE FIRMS SET '
      '    IDFIZ = ?IDFIZ,'
      '    EDRPOU = ?EDRPOU,'
      '    WUSER = ?WUSER,'
      '    COMPANY_ADDRESS = ?COMPANY_ADDRESS,'
      '    COMPANY_NAME = ?COMPANY_NAME,'
      '    EMAIL = ?EMAIL'
      ' WHERE     '
      '            ID = ?OLD_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM FIRMS'
      'WHERE     '
      '            ID = ?OLD_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO FIRMS('
      '    ID,'
      '    IDFIZ,'
      '    EDRPOU,'
      '    WUSER,'
      '    COMPANY_ADDRESS,'
      '    COMPANY_NAME,'
      '    EMAIL'
      ')'
      'VALUES('
      '    ?ID,'
      '    ?IDFIZ,'
      '    ?EDRPOU,'
      '    ?WUSER,'
      '    ?COMPANY_ADDRESS,'
      '    ?COMPANY_NAME,'
      '    ?EMAIL'
      ''
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    FIR.ID,'
      '    FIR.IDFIZ,'
      '    FIR.EDRPOU,'
      '    FIR.WUSER,'
      '    FIR.COMPANY_ADDRESS,'
      '    FIR.COMPANY_NAME,'
      '    FIR.EMAIL'
      'FROM'
      '    FIRMS FIR'
      ' WHERE '
      '    (    '
      '            FIR.ID = ?OLD_ID'
      '    )')
    SelectSQL.Strings = (
      'SELECT'
      '    FIR.ID,'
      '    FIR.IDFIZ,'
      '    FIR.EDRPOU,'
      '    FIR.WUSER,'
      '    FIR.COMPANY_ADDRESS,'
      '    FIR.COMPANY_NAME,'
      '    FIR.EMAIL'
      'FROM'
      '    FIRMS FIR')
    AutoUpdateOptions.UpdateTableName = 'FIRMS'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'Firms'
    AutoUpdateOptions.WhenGetGenID = wgBeforePost
    Left = 352
    Top = 64
    poSQLINT64ToBCD = True
    object FirmsID: TFIBIntegerField
      FieldName = 'ID'
    end
    object FirmsIDFIZ: TFIBIntegerField
      FieldName = 'IDFIZ'
    end
    object FirmsEDRPOU: TFIBStringField
      FieldName = 'EDRPOU'
      Size = 8
      EmptyStrToNull = True
    end
    object FirmsWUSER: TFIBStringField
      FieldName = 'WUSER'
      Size = 10
      EmptyStrToNull = True
    end
    object FirmsCOMPANY_ADDRESS: TFIBStringField
      FieldName = 'COMPANY_ADDRESS'
      Size = 50
      EmptyStrToNull = True
    end
    object FirmsCOMPANY_NAME: TFIBStringField
      FieldName = 'COMPANY_NAME'
      Size = 50
      EmptyStrToNull = True
    end
    object FirmsEMAIL: TFIBStringField
      FieldName = 'EMAIL'
      Size = 50
      EmptyStrToNull = True
    end
  end
end
