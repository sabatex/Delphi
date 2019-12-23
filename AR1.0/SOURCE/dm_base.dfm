inherited dmBase: TdmBase
  OldCreateOrder = True
  Left = 540
  Top = 217
  inherited mainDatabase: TpFIBDatabase
    Connected = True
    DBName = 'D:\FireBird\AR.GDB'
  end
  inherited mainTransaction: TpFIBTransaction
    Active = True
  end
  object DA: THalcyonDataSet
    About = 'Halcyon Version 6.737 (08 Feb 01)'
    AutoFlush = False
    Exclusive = False
    LockProtocol = Default
    TableName = 'DA.dbf'
    TranslateASCII = True
    UseDeleted = False
    UserID = 0
    Left = 176
    Top = 16
    object DANP: TIntegerField
      FieldName = 'NP'
    end
    object DAPERIOD: TSmallintField
      FieldName = 'PERIOD'
    end
    object DARIK: TSmallintField
      FieldName = 'RIK'
    end
    object DAKOD: TStringField
      FieldName = 'KOD'
      Size = 10
    end
    object DATYP: TSmallintField
      FieldName = 'TYP'
    end
    object DATIN: TStringField
      FieldName = 'TIN'
    end
    object DAS_NAR: TFloatField
      FieldName = 'S_NAR'
      DisplayFormat = '0.00'
    end
    object DAS_DOX: TFloatField
      FieldName = 'S_DOX'
      DisplayFormat = '0.00'
    end
    object DAS_TAXN: TFloatField
      FieldName = 'S_TAXN'
      DisplayFormat = '0.00'
    end
    object DAS_TAXP: TFloatField
      FieldName = 'S_TAXP'
      DisplayFormat = '0.00'
    end
    object DAOZN_DOX: TSmallintField
      FieldName = 'OZN_DOX'
    end
    object DAOZN_PILG: TSmallintField
      FieldName = 'OZN_PILG'
    end
    object DAOZNAKA: TSmallintField
      FieldName = 'OZNAKA'
    end
    object DAWokerName: TStringField
      FieldKind = fkLookup
      FieldName = 'WokerName'
      LookupDataSet = Wokers
      LookupKeyFields = 'EDRPOU'
      LookupResultField = 'NAME'
      KeyFields = 'TIN'
      ReadOnly = True
      Size = 60
      Lookup = True
    end
    object DATINL: TStringField
      FieldKind = fkLookup
      FieldName = 'TINL'
      LookupDataSet = Wokers
      LookupKeyFields = 'EDRPOU'
      LookupResultField = 'EDRPOU'
      KeyFields = 'TIN'
      Lookup = True
    end
    object DAD_PRIYN: TDateField
      FieldName = 'D_PRIYN'
    end
    object DAD_ZVILN: TDateField
      FieldName = 'D_ZVILN'
    end
  end
  object dsDA: TDataSource
    DataSet = DA
    Left = 248
    Top = 16
  end
  object Wokers: THalcyonDataSet
    About = 'Halcyon Version 6.737 (08 Feb 01)'
    AutoFlush = False
    Exclusive = False
    LockProtocol = Default
    TableName = 'Wokers.dbf'
    TranslateASCII = True
    UseDeleted = False
    UserID = 0
    Left = 176
    Top = 72
    object WokersEDRPOU: TStringField
      FieldName = 'EDRPOU'
      Size = 10
    end
    object WokersNAME: TStringField
      FieldName = 'NAME'
      Size = 60
    end
  end
  object dsWokers: TDataSource
    DataSet = Wokers
    Left = 248
    Top = 72
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
    Left = 176
    Top = 120
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
  object dsListTables: TDataSource
    DataSet = ListTables
    Left = 248
    Top = 120
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
    Left = 176
    Top = 176
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
  object dsOptions: TDataSource
    DataSet = Options
    Left = 248
    Top = 176
  end
  object CreateDA: TCreateHalcyonDataSet
    AutoOverwrite = False
    CreateFields.Strings = (
      'NP;N;5;0'
      'PERIOD;N;1;0'
      'RIK;N;4;0'
      'KOD;C;10;0'
      'TYP;N;1;0'
      'TIN;C;10;0'
      'S_NAR;N;12;2'
      'S_DOX;N;12;2'
      'S_TAXN;N;12;2'
      'S_TAXP;N;12;2'
      'D_PRIYN;D;4;0'
      'D_ZVILN;D;4;0'
      'OZN_DOX;N;2;0'
      'OZN_PILG;N;2;0'
      'OZNAKA;N;1;0')
    DBFTable = DA
    DBFType = FoxPro2
    Left = 336
    Top = 25
  end
end
