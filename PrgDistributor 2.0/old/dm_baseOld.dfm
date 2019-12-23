object dmBaseOld: TdmBaseOld
  OldCreateOrder = False
  Left = 377
  Top = 177
  Height = 469
  Width = 551
  object DataBase: TpFIBDatabase
    DBName = 'D:\CBuilder6\Projects\CommonBase\NTICS.GDB'
    DBParams.Strings = (
      'lc_ctype=WIN1251'
      'user_name=SYSDBA'
      'password=masterkey'
      'sql_role_name=SYSDBA')
    DefaultTransaction = Transaction
    SQLDialect = 3
    Timeout = 0
    AliasName = 'ProgrammDistributor'
    WaitForRestoreConnect = 0
    Left = 16
    Top = 8
  end
  object PROGRAMM_PRODUCT: TpFIBDataSet
    Database = DataBase
    Transaction = Transaction
    AutoCommit = True
    UpdateSQL.Strings = (
      'UPDATE PROGRAMM_PRODUCT SET '
      '    PRODUCT_NAME = ?PRODUCT_NAME'
      ' WHERE     '
      '            ID = ?OLD_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM PROGRAMM_PRODUCT'
      'WHERE     '
      '            ID = ?OLD_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO PROGRAMM_PRODUCT('
      '    ID,'
      '    PRODUCT_NAME)'
      'VALUES('
      '    ?ID,'
      '    ?PRODUCT_NAME'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    PRO.ID,'
      '    PRO.PRODUCT_NAME'
      'FROM'
      '    PROGRAMM_PRODUCT PRO'
      ''
      ''
      ' WHERE '
      '    (    '
      '            PRO.ID = ?OLD_ID'
      '    )')
    SelectSQL.Strings = (
      'SELECT'
      '    PRO.ID,'
      '    PRO.PRODUCT_NAME,'
      
        '    (SELECT COUNT(B.ID) FROM PROD B WHERE PRO.ID = B.PRODUCT_ID)' +
        ' COUNT_PROD'
      'FROM'
      '    PROGRAMM_PRODUCT PRO'
      ''
      '')
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.UpdateTableName = 'PROGRAMM_PRODUCT'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'PROGRAMM_PRODUCT'
    AutoUpdateOptions.WhenGetGenID = wgOnNewRecord
    Left = 200
    Top = 8
    poSQLINT64ToBCD = True
    object PROGRAMM_PRODUCTID: TFIBIntegerField
      FieldName = 'ID'
    end
    object PROGRAMM_PRODUCTPRODUCT_NAME: TFIBStringField
      FieldName = 'PRODUCT_NAME'
      Size = 30
      EmptyStrToNull = True
    end
    object PROGRAMM_PRODUCTCOUNT_PROD: TFIBIntegerField
      FieldName = 'COUNT_PROD'
    end
  end
  object Transaction: TpFIBTransaction
    DefaultDatabase = DataBase
    TimeoutAction = TARollback
    Left = 88
    Top = 8
  end
  object VERSION_PRODUCTS: TpFIBDataSet
    Database = DataBase
    Transaction = Transaction
    AutoCommit = True
    UpdateSQL.Strings = (
      'UPDATE VERSION_PRODUCTS SET '
      '    VERSION_PRG = ?VERSION_PRG,'
      '    KEY_E = ?KEY_E,'
      '    KEY_D = ?KEY_D,'
      '    KEY_N = ?KEY_N,'
      '    PROGRAMM_PRODUCTS_ID = ?PROGRAMM_PRODUCTS_ID,'
      '    SOURCE_PATH = ?SOURCE_PATH'
      ' WHERE     '
      '            ID = ?OLD_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM VERSION_PRODUCTS'
      'WHERE     '
      '            ID = ?OLD_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO VERSION_PRODUCTS('
      '    ID,'
      '    VERSION_PRG,'
      '    KEY_E,'
      '    KEY_D,'
      '    KEY_N,'
      '    PROGRAMM_PRODUCTS_ID,'
      '    SOURCE_PATH'
      ')'
      'VALUES('
      '    ?ID,'
      '    ?VERSION_PRG,'
      '    ?KEY_E,'
      '    ?KEY_D,'
      '    ?KEY_N,'
      '    ?PROGRAMM_PRODUCTS_ID,'
      '    ?SOURCE_PATH'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    VER.ID,'
      '    VER.VERSION_PRG,'
      '    VER.KEY_E,'
      '    VER.KEY_D,'
      '    VER.KEY_N,'
      '    VER.PROGRAMM_PRODUCTS_ID,'
      '    VER.SOURCE_PATH'
      'FROM'
      '    VERSION_PRODUCTS VER'
      ' WHERE '
      '    (    '
      '            VER.ID = ?OLD_ID'
      '    )')
    SelectSQL.Strings = (
      'SELECT'
      '    VER.ID,'
      '    VER.VERSION_PRG,'
      '    VER.KEY_E,'
      '    VER.KEY_D,'
      '    VER.KEY_N,'
      '    VER.PROGRAMM_PRODUCTS_ID,'
      '    VER.SOURCE_PATH,'
      
        '    (SELECT COUNT(B.ID) FROM PROD B WHERE VER.ID = B.VERSION_ID)' +
        ' COUNT_PROD'
      'FROM'
      '    VERSION_PRODUCTS VER'
      'WHERE VER.PROGRAMM_PRODUCTS_ID = :ID'
      ''
      'ORDER BY  VER.VERSION_PRG   ')
    DataSource = dsPROGRAMM_PRODUCT
    AfterInsert = VERSION_PRODUCTSAfterInsert
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.UpdateTableName = 'VERSION_PRODUCTS'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'VERSION_PRODUCTS'
    AutoUpdateOptions.WhenGetGenID = wgOnNewRecord
    Left = 200
    Top = 72
    poSQLINT64ToBCD = True
    object VERSION_PRODUCTSID: TFIBIntegerField
      FieldName = 'ID'
    end
    object VERSION_PRODUCTSVERSION_PRG: TFIBStringField
      FieldName = 'VERSION_PRG'
      Size = 30
      EmptyStrToNull = True
    end
    object VERSION_PRODUCTSKEY_E: TBlobField
      FieldName = 'KEY_E'
      Size = 8
    end
    object VERSION_PRODUCTSKEY_D: TBlobField
      FieldName = 'KEY_D'
      Size = 8
    end
    object VERSION_PRODUCTSKEY_N: TBlobField
      FieldName = 'KEY_N'
      Size = 8
    end
    object VERSION_PRODUCTSPROGRAMM_PRODUCTS_ID: TFIBIntegerField
      FieldName = 'PROGRAMM_PRODUCTS_ID'
    end
    object VERSION_PRODUCTSSOURCE_PATH: TFIBStringField
      FieldName = 'SOURCE_PATH'
      Size = 255
      EmptyStrToNull = True
    end
    object VERSION_PRODUCTSCOUNT_PROD: TFIBIntegerField
      FieldName = 'COUNT_PROD'
    end
    object VERSION_PRODUCTSPRODUCT_NAME: TStringField
      FieldKind = fkLookup
      FieldName = 'PRODUCT_NAME'
      LookupDataSet = PROGRAMM_PRODUCT
      LookupKeyFields = 'ID'
      LookupResultField = 'PRODUCT_NAME'
      KeyFields = 'PROGRAMM_PRODUCTS_ID'
      Lookup = True
    end
  end
  object dsPROGRAMM_PRODUCT: TDataSource
    DataSet = PROGRAMM_PRODUCT
    Left = 352
    Top = 8
  end
  object FIRMS: TpFIBDataSet
    Database = DataBase
    Transaction = Transaction
    AutoCommit = True
    UpdateSQL.Strings = (
      'UPDATE FIRMS SET '
      '    ID = ?ID,'
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
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.UpdateTableName = 'FIRMS'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'FIRMS'
    AutoUpdateOptions.WhenGetGenID = wgOnNewRecord
    Left = 200
    Top = 136
    poSQLINT64ToBCD = True
    object FIRMSID: TFIBIntegerField
      FieldName = 'ID'
    end
    object FIRMSIDFIZ: TFIBIntegerField
      FieldName = 'IDFIZ'
    end
    object FIRMSEDRPOU: TFIBStringField
      FieldName = 'EDRPOU'
      Size = 8
      EmptyStrToNull = True
    end
    object FIRMSWUSER: TFIBStringField
      FieldName = 'WUSER'
      Size = 10
      EmptyStrToNull = True
    end
    object FIRMSCOMPANY_ADDRESS: TFIBStringField
      FieldName = 'COMPANY_ADDRESS'
      Size = 50
      EmptyStrToNull = True
    end
    object FIRMSCOMPANY_NAME: TFIBStringField
      FieldName = 'COMPANY_NAME'
      Size = 50
      EmptyStrToNull = True
    end
    object FIRMSEMAIL: TFIBStringField
      FieldName = 'EMAIL'
      Size = 50
      EmptyStrToNull = True
    end
  end
  object PROD: TpFIBDataSet
    Database = DataBase
    Transaction = Transaction
    AutoCommit = True
    UpdateSQL.Strings = (
      'UPDATE PROD SET '
      '    ID = ?ID,'
      '    FIRMS_ID = ?FIRMS_ID,'
      '    PRODUCT_ID = ?PRODUCT_ID,'
      '    VERSION_ID = ?VERSION_ID,'
      '    DATE_PAY = ?DATE_PAY,'
      '    LICENZE = ?LICENZE,'
      '    USER_KEY = ?USER_KEY,'
      '    KEY_NAME = ?KEY_NAME'
      ' WHERE     '
      '            ID = ?OLD_ID'
      '    ')
    DeleteSQL.Strings = (
      'DELETE FROM PROD'
      'WHERE     '
      '            ID = ?OLD_ID'
      '    ')
    InsertSQL.Strings = (
      'INSERT INTO PROD('
      '    ID,'
      '    FIRMS_ID,'
      '    PRODUCT_ID,'
      '    VERSION_ID,'
      '    DATE_PAY,'
      '    LICENZE,'
      '    USER_KEY,'
      '    KEY_NAME'
      ')'
      'VALUES('
      '    ?ID,'
      '    ?FIRMS_ID,'
      '    ?PRODUCT_ID,'
      '    ?VERSION_ID,'
      '    ?DATE_PAY,'
      '    ?LICENZE,'
      '    ?USER_KEY,'
      '    ?KEY_NAME'
      ')')
    RefreshSQL.Strings = (
      'SELECT'
      '    PRO.ID,'
      '    PRO.FIRMS_ID,'
      '    PRO.PRODUCT_ID,'
      '    PRO.VERSION_ID,'
      '    PRO.DATE_PAY,'
      '    PRO.LICENZE,'
      '    PRO.USER_KEY,'
      '    PRO.KEY_NAME'
      'FROM'
      '    PROD PRO'
      ' WHERE '
      '    (    '
      '            PRO.ID = ?OLD_ID'
      '    )')
    SelectSQL.Strings = (
      'SELECT'
      '    PRO.ID,'
      '    PRO.FIRMS_ID,'
      '    PRO.PRODUCT_ID,'
      '    PRO.VERSION_ID,'
      '    PRO.DATE_PAY,'
      '    PRO.LICENZE,'
      '    PRO.USER_KEY,'
      '    PRO.KEY_NAME'
      'FROM'
      '    PROD PRO')
    DefaultFormats.DateTimeDisplayFormat = 'dd.mm.yyyy'
    AutoUpdateOptions.UpdateTableName = 'PROD'
    AutoUpdateOptions.KeyFields = 'ID'
    AutoUpdateOptions.GeneratorName = 'PROD'
    AutoUpdateOptions.WhenGetGenID = wgOnNewRecord
    Left = 200
    Top = 200
    poSQLINT64ToBCD = True
    object PRODID: TFIBIntegerField
      FieldName = 'ID'
    end
    object PRODFIRMS_ID: TFIBIntegerField
      FieldName = 'FIRMS_ID'
    end
    object PRODPRODUCT_ID: TFIBIntegerField
      FieldName = 'PRODUCT_ID'
    end
    object PRODVERSION_ID: TFIBIntegerField
      FieldName = 'VERSION_ID'
    end
    object PRODDATE_PAY: TDateField
      FieldName = 'DATE_PAY'
    end
    object PRODLICENZE: TFIBIntegerField
      FieldName = 'LICENZE'
    end
    object PRODUSER_KEY: TBlobField
      FieldName = 'USER_KEY'
      Size = 8
    end
    object PRODKEY_NAME: TFIBStringField
      FieldName = 'KEY_NAME'
      Size = 255
      EmptyStrToNull = True
    end
  end
end
