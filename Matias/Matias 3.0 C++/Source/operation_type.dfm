object frmOperationType: TfrmOperationType
  Left = 192
  Top = 107
  Width = 696
  Height = 480
  Caption = 'frmOperationType'
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
    Left = 217
    Top = 27
    Width = 4
    Height = 426
    Cursor = crHSplit
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 688
    Height = 27
    Caption = 'ToolBar1'
    Images = dmFunction.ImageList
    TabOrder = 0
    object tbAddElement: TToolButton
      Left = 0
      Top = 2
      Action = aAddElement
      ParentShowHint = False
      ShowHint = True
    end
    object ToolButton2: TToolButton
      Left = 23
      Top = 2
      Action = aAddFolder
      ParentShowHint = False
      ShowHint = True
    end
    object ToolButton1: TToolButton
      Left = 46
      Top = 2
      Action = aMoveGroup
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 27
    Width = 217
    Height = 426
    Align = alLeft
    Caption = 'Panel1'
    TabOrder = 1
    object Panel2: TPanel
      Left = 1
      Top = 403
      Width = 215
      Height = 22
      Align = alBottom
      TabOrder = 0
      object Label1: TLabel
        Left = 5
        Top = 4
        Width = 56
        Height = 13
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077': '
      end
      object DBEdit1: TDBEdit
        Left = 61
        Top = 2
        Width = 119
        Height = 21
        DataField = 'OP_TYPE'
        DataSource = DataSource1
        TabOrder = 0
      end
      object DBEdit2: TDBEdit
        Left = 184
        Top = 1
        Width = 25
        Height = 21
        DataField = 'POSITION_ON_REPORT'
        DataSource = DataSource1
        TabOrder = 1
      end
    end
    object fcDBTreeView1: TfcDBTreeView
      Left = 1
      Top = 1
      Width = 215
      Height = 402
      Align = alClient
      BorderStyle = bsSingle
      TabOrder = 1
      DataSourceFirst = DataSource1
      DataSourceLast = DataSource1
      DisplayFields.Strings = (
        '"OP_TYPE","POSITION_ON_REPORT"')
      LevelIndent = 19
      OnDblClick = fcDBTreeView1DblClick
    end
  end
  object DBGridEh1: TDBGridEh
    Left = 221
    Top = 27
    Width = 467
    Height = 426
    Align = alClient
    DataSource = DataSource2
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'MS Sans Serif'
    FooterFont.Style = []
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        EditButtons = <>
        FieldName = 'OP_TYPE'
        Footers = <>
        Title.Caption = #1058#1080#1087' '#1086#1087#1077#1088#1072#1094#1080#1080
        Width = 260
      end
      item
        EditButtons = <>
        FieldName = 'TAX'
        Footers = <>
        Title.Caption = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090
      end
      item
        EditButtons = <>
        FieldName = 'POSITION_ON_REPORT'
        Footers = <>
        Title.Caption = #1055#1086#1079#1080#1094#1080#1103' '#1074' '#1086#1090#1095#1105#1090#1077
      end>
  end
  object taClasificator: TpFIBTransaction
    DefaultDatabase = dmBase.mainDatabase
    TimeoutAction = TARollback
    Left = 432
    Top = 120
  end
  object dbFolder: TpFIBDataSet
    Database = dmBase.mainDatabase
    Transaction = dmBase.mainTransaction
    AutoCommit = True
    UpdateSQL.Strings = (
      'UPDATE OPERATION_TYPE SET '
      '    ID = ?ID,'
      '    OP_TYPE = ?OP_TYPE,'
      '    TAX = ?TAX,'
      '    PARENT = ?PARENT,'
      '    POSITION_ON_REPORT = ?POSITION_ON_REPORT'
      ' WHERE     '
      '            ID = ?OLD_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM OPERATION_TYPE'
      'WHERE     '
      '            ID = ?OLD_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO OPERATION_TYPE('
      '    ID,'
      '    OP_TYPE,'
      '    TAX,'
      '    PARENT,'
      '    IS_FOLDER,'
      '    POSITION_ON_REPORT'
      ')'
      'VALUES('
      '    ?ID,'
      '    ?OP_TYPE,'
      '    ?TAX,'
      '    ?PARENT,'
      '    1,'
      '    ?POSITION_ON_REPORT'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    OPE.ID,'
      '    OPE.OP_TYPE,'
      '    OPE.TAX,'
      '    OPE.PARENT,'
      '    OPE.POSITION_ON_REPORT'
      'FROM'
      '    OPERATION_TYPE OPE'
      'WHERE'
      '    (OPE.IS_FOLDER = 1)'
      '     and '
      '    ((    '
      '            OPE.ID = ?OLD_ID'
      '    ))')
    SelectSQL.Strings = (
      'SELECT'
      '    OPE.ID,'
      '    OPE.OP_TYPE,'
      '    OPE.TAX,'
      '    OPE.PARENT,'
      '    OPE.POSITION_ON_REPORT'
      'FROM'
      '    OPERATION_TYPE OPE'
      'WHERE'
      '    OPE.IS_FOLDER = 1'
      'ORDER BY OPE.POSITION_ON_REPORT')
    DefaultFormats.DateTimeDisplayFormat = 'd MMMM yyyy'#39' '#1088'.'#39
    AutoUpdateOptions.UpdateTableName = 'OPERATION_TYPE'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'OPERATION_TYPE'
    AutoUpdateOptions.WhenGetGenID = wgOnNewRecord
    Left = 472
    Top = 120
    poSQLINT64ToBCD = True
    object dbFolderID: TFIBIntegerField
      FieldName = 'ID'
    end
    object dbFolderOP_TYPE: TFIBStringField
      FieldName = 'OP_TYPE'
      Size = 100
      EmptyStrToNull = True
    end
    object dbFolderTAX: TFIBFloatField
      FieldName = 'TAX'
      DisplayFormat = '#,##0.0000'
      EditFormat = '0.0000'
    end
    object dbFolderPARENT: TFIBIntegerField
      FieldName = 'PARENT'
    end
    object dbFolderPOSITION_ON_REPORT: TFIBIntegerField
      FieldName = 'POSITION_ON_REPORT'
    end
  end
  object dbClasificator: TpFIBDataSet
    Database = dmBase.mainDatabase
    Transaction = dmBase.taClasificator
    UpdateTransaction = dmBase.mainTransaction
    AutoCommit = True
    UpdateSQL.Strings = (
      'UPDATE OPERATION_TYPE SET '
      '    ID = ?ID,'
      '    OP_TYPE = ?OP_TYPE,'
      '    TAX = ?TAX,'
      '    PARENT = ?PARENT,'
      '    IS_FOLDER = ?IS_FOLDER,'
      '    POSITION_ON_REPORT = ?POSITION_ON_REPORT'
      ' WHERE     '
      '            ID = ?OLD_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM OPERATION_TYPE'
      'WHERE     '
      '            ID = ?OLD_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO OPERATION_TYPE('
      '    ID,'
      '    OP_TYPE,'
      '    TAX,'
      '    PARENT,'
      '    IS_FOLDER,'
      '    POSITION_ON_REPORT'
      ')'
      'VALUES('
      '    ?ID,'
      '    ?OP_TYPE,'
      '    ?TAX,'
      '    ?PARENT,'
      '    ?IS_FOLDER,'
      '    ?POSITION_ON_REPORT'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    OPE.ID,'
      '    OPE.OP_TYPE,'
      '    OPE.TAX,'
      '    OPE.PARENT,'
      '    OPE.IS_FOLDER,'
      '    OPE.POSITION_ON_REPORT'
      'FROM'
      '    OPERATION_TYPE OPE'
      ' WHERE '
      '    (    '
      '            OPE.ID = ?OLD_ID'
      '    )')
    SelectSQL.Strings = (
      'SELECT'
      '    OPE.ID,'
      '    OPE.OP_TYPE,'
      '    OPE.TAX,'
      '    OPE.PARENT,'
      '    OPE.IS_FOLDER,'
      '    OPE.POSITION_ON_REPORT'
      'FROM'
      '    OPERATION_TYPE OPE'
      'WHERE'
      '   OPE.IS_FOLDER = 0'
      'ORDER BY OPE.POSITION_ON_REPORT')
    AfterPost = dbClasificatorAfterPost
    DefaultFormats.DateTimeDisplayFormat = 'd MMMM yyyy'#39' '#1088'.'#39
    AutoUpdateOptions.UpdateTableName = 'OPERATION_TYPE'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'OPERATION_TYPE'
    AutoUpdateOptions.WhenGetGenID = wgOnNewRecord
    Left = 472
    Top = 160
    poSQLINT64ToBCD = True
    object dbClasificatorID: TFIBIntegerField
      FieldName = 'ID'
    end
    object dbClasificatorOP_TYPE: TFIBStringField
      FieldName = 'OP_TYPE'
      Size = 100
      EmptyStrToNull = True
    end
    object dbClasificatorTAX: TFIBFloatField
      FieldName = 'TAX'
      DisplayFormat = '#,##0.0000'
      EditFormat = '0.0000'
    end
    object dbClasificatorPARENT: TFIBIntegerField
      FieldName = 'PARENT'
    end
    object dbClasificatorIS_FOLDER: TFIBIntegerField
      FieldName = 'IS_FOLDER'
    end
    object dbClasificatorPOSITION_ON_REPORT: TFIBIntegerField
      FieldName = 'POSITION_ON_REPORT'
    end
  end
  object ActionList1: TActionList
    Images = dmBase.ImageList
    Left = 432
    Top = 160
    object aAddElement: TAction
      Caption = 'aAddElement'
      ImageIndex = 0
      OnExecute = aAddElementExecute
    end
    object aAddFolder: TAction
      Caption = 'aAddFolder'
      ImageIndex = 1
      OnExecute = aAddFolderExecute
    end
    object aMoveGroup: TAction
      Caption = #1055#1077#1088#1077#1084#1110#1089#1090#1080#1090#1080' '#1074' '#1075#1088#1091#1087#1087#1091
      Hint = #1055#1077#1088#1077#1084#1110#1089#1090#1080#1090#1080' '#1074' '#1074#1110#1076#1084#1110#1095#1077#1085#1091' '#1075#1088#1091#1087#1087#1091
      ImageIndex = 6
      OnExecute = aMoveGroupExecute
    end
  end
  object DataSource1: TDataSource
    DataSet = dbFolder
    Left = 520
    Top = 120
  end
  object DataSource2: TDataSource
    DataSet = dbClasificator
    Left = 520
    Top = 160
  end
end
