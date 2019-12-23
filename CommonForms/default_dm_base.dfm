object dmBase_def: TdmBase_def
  OldCreateOrder = False
  Left = 198
  Top = 184
  Height = 369
  Width = 451
  object mainDatabase: TpFIBDatabase
    DBName = 'D:\FireBird\PROGRAMMDISTRIBUTOR1.GDB'
    DBParams.Strings = (
      'user_name=sysdba'
      'lc_ctype=WIN1251'
      'sql_role_name=None'
      'password=masterkey')
    DefaultTransaction = mainTransaction
    DefaultUpdateTransaction = mainTransaction
    SQLDialect = 3
    Timeout = 0
    AliasName = 'CommonBase'
    WaitForRestoreConnect = 0
    Left = 40
    Top = 8
  end
  object mainTransaction: TpFIBTransaction
    DefaultDatabase = mainDatabase
    TimeoutAction = TARollback
    TRParams.Strings = (
      'write'
      'nowait'
      'rec_version'
      'read_committed')
    TPBMode = tpbDefault
    Left = 40
    Top = 72
  end
end
