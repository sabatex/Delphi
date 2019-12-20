inherited dmMain: TdmMain
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  Left = 362
  Top = 183
  Height = 511
  Width = 620
  inherited ActionList: TActionList
    object aRefreshAll: TAction
      Category = #1060#1072#1081#1083
      Caption = #1057#1080#1085#1093#1088#1086#1085#1110#1079#1091#1074#1072#1090#1080' '#1074#1089#1110' '#1076#1072#1085#1110
      OnExecute = aRefreshAllExecute
    end
    object aOperation: TAction
      Category = #1044#1086#1074#1110#1076#1085#1080#1082#1080
      Caption = #1054#1087#1077#1088#1072#1094#1110#1111
      OnExecute = aOperationExecute
    end
    object aClassificator: TAction
      Category = #1044#1086#1074#1110#1076#1085#1080#1082#1080
      Caption = #1050#1083#1072#1089#1080#1092#1110#1082#1072#1090#1086#1088
      OnExecute = aClassificatorExecute
    end
    object aWokers: TAction
      Category = #1044#1086#1074#1110#1076#1085#1080#1082#1080
      Caption = #1055#1088#1072#1094#1110#1074#1085#1080#1082#1080
      OnExecute = aWokersExecute
    end
    object aOrders: TAction
      Category = #1044#1086#1074#1110#1076#1085#1080#1082#1080
      Caption = #1053#1072#1088#1103#1076#1080
      OnExecute = aOrdersExecute
    end
    object aReport1: TAction
      Category = #1047#1074#1110#1090#1080
      Caption = #1047#1074#1110#1090' '#1076#1083#1103' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1110#1111
      OnExecute = aReport1Execute
    end
    object aReport2: TAction
      Category = #1047#1074#1110#1090#1080
      Caption = #1047#1074#1110#1090' '#1076#1077#1090#1072#1083#1100#1085#1080#1081
      OnExecute = aReport2Execute
    end
    object aReport3: TAction
      Category = #1047#1074#1110#1090#1080
      Caption = #1047#1074#1110#1090' '#1087#1086' '#1092#1110#1088#1084#1072#1084
      OnExecute = aReport3Execute
    end
    object aDesigner: TAction
      Category = #1047#1074#1110#1090#1080
      Caption = #1044#1080#1079#1072#1081#1085#1077#1088' '#1079#1074#1110#1090#1110#1074
      OnExecute = aDesignerExecute
    end
    object aReport4: TAction
      Category = #1047#1074#1110#1090#1080
      Caption = #1047#1074#1110#1090' '#1087#1086' '#1092#1110#1088#1084#1072#1084' 2'
      OnExecute = aReport4Execute
    end
  end
  object frDesigner: TfrDesigner
    Left = 168
    Top = 24
  end
  object frReport: TfrReport
    InitialZoom = pzDefault
    PreviewButtons = [pbZoom, pbLoad, pbSave, pbPrint, pbFind, pbHelp, pbExit]
    RebuildPrinter = False
    OnBeginDoc = frReportBeginDoc
    Left = 248
    Top = 24
    ReportForm = {19000000}
  end
  object frHTMExport: TfrHTMExport
    ScaleX = 1
    ScaleY = 1
    Left = 344
    Top = 192
  end
  object frRTFExport: TfrRTFExport
    ScaleX = 1.3
    ScaleY = 1
    Left = 344
    Top = 80
  end
  object frCSVExport: TfrCSVExport
    ScaleX = 1
    ScaleY = 1
    Delimiter = ';'
    Left = 344
    Top = 136
  end
  object frTextExport: TfrTextExport
    ScaleX = 1
    ScaleY = 1
    Left = 344
    Top = 24
  end
  object frCrossObject: TfrCrossObject
    Left = 424
    Top = 312
  end
  object frOLEObject: TfrOLEObject
    Left = 416
    Top = 24
  end
  object frRichObject: TfrRichObject
    Left = 424
    Top = 424
  end
  object frCheckBoxObject: TfrCheckBoxObject
    Left = 424
    Top = 368
  end
  object frShapeObject: TfrShapeObject
    Left = 416
    Top = 72
  end
  object frBarCodeObject: TfrBarCodeObject
    Left = 416
    Top = 128
  end
  object frChartObject: TfrChartObject
    Left = 424
    Top = 256
  end
  object frRoundRectObject: TfrRoundRectObject
    Left = 424
    Top = 192
  end
  object frPersonal: TfrDBDataSet
    Left = 544
    Top = 80
  end
  object frT_REPORT1: TfrDBDataSet
    OpenDataSource = False
    Left = 544
    Top = 136
  end
  object frCompositeReport: TfrCompositeReport
    InitialZoom = pzDefault
    PreviewButtons = [pbZoom, pbLoad, pbSave, pbPrint, pbFind, pbHelp, pbExit]
    RebuildPrinter = False
    DoublePassReport = False
    Left = 248
    Top = 72
    ReportForm = {19000000}
  end
  object frOLEExcelExport1: TfrOLEExcelExport
    CellsAlign = False
    CellsFillColor = False
    CellsFontColor = False
    CellsFontName = False
    CellsFontSize = False
    CellsFontStyle = False
    Left = 336
    Top = 248
  end
  object temp_CROSS_FIRMS_CELL: TpFIBDataSet
    Database = dmBase.mainDatabase
    Transaction = dmBase.mainTransaction
    SelectSQL.Strings = (
      
        'SELECT A.COMPANY_NAME,A.ID, C.operation_id,SUM(C.counts) as COUN' +
        'TS,cast(SUM(C.COUNTS*D.CASHE) AS NUMERIC(15,2)) AS SUMA FROM  FI' +
        'RMS A'
      'left join personal B ON (B.firms_id=A.ID)'
      'left join orders C on (C.personal_id=B.id)'
      'left join operation D on (D.id=C.operation_id)'
      'where (C.order_year=:F_YEAR) and'
      '      (C.order_month=:F_MONTH) and'
      '      (B.firms_id=A.ID)'
      'group by A.COMPANY_NAME,A.ID,C.operation_id')
    Left = 56
    Top = 331
    poSQLINT64ToBCD = True
    object temp_CROSS_FIRMS_CELLID: TFIBIntegerField
      FieldName = 'ID'
    end
    object temp_CROSS_FIRMS_CELLOPERATION_ID: TFIBIntegerField
      FieldName = 'OPERATION_ID'
    end
    object temp_CROSS_FIRMS_CELLCOMPANY_NAME: TFIBStringField
      FieldName = 'COMPANY_NAME'
      Size = 50
      EmptyStrToNull = True
    end
    object temp_CROSS_FIRMS_CELLCOUNTS: TFIBBCDField
      FieldName = 'COUNTS'
      Size = 2
      RoundByScale = True
    end
    object temp_CROSS_FIRMS_CELLSUMA: TFIBBCDField
      FieldName = 'SUMA'
      Size = 2
      RoundByScale = True
    end
  end
  object CROSS_OPERATION: TpFIBDataSet
    Database = dmBase.mainDatabase
    Transaction = dmBase.mainTransaction
    SelectSQL.Strings = (
      'SELECT B.ID,B.OPERATION_NAME,B.CASHE FROM ORDERS A'
      'LEFT JOIN OPERATION B ON (B.ID=A.OPERATION_ID)'
      'WHERE (A.ORDER_YEAR=:F_YEAR) AND'
      '      (A.ORDER_MONTH=:F_MONTH)'
      'GROUP BY B.OPERATION_NAME,B.ID,B.CASHE')
    Left = 59
    Top = 276
    poSQLINT64ToBCD = True
    object CROSS_OPERATIONID: TFIBIntegerField
      FieldName = 'ID'
    end
    object CROSS_OPERATIONOPERATION_NAME: TFIBStringField
      FieldName = 'OPERATION_NAME'
      Size = 100
      EmptyStrToNull = True
    end
    object CROSS_OPERATIONCASHE: TFIBFloatField
      FieldName = 'CASHE'
      DisplayFormat = '#,##0.0000'
      EditFormat = '0.0000'
    end
  end
  object frCROSS_OPERATION: TfrDBDataSet
    DataSet = CROSS_OPERATION
    Left = 176
    Top = 272
  end
  object CROSS_FIRMS: TpFIBDataSet
    Database = dmBase.mainDatabase
    Transaction = dmBase.mainTransaction
    SelectSQL.Strings = (
      'SELECT A.ID,A.COMPANY_NAME'
      'FROM FIRMS A'
      'where (SELECT SUM(E.counts) FROM personal D'
      'left join orders E on (E.personal_id=D.id)'
      'where (E.order_year=:F_YEAR) and'
      '      (E.order_month=:F_MONTH) and'
      '      (D.firms_id=A.ID))<>0'
      'ORDER BY A.COMPANY_NAME')
    OnCalcFields = CROSS_FIRMSCalcFields
    Left = 56
    Top = 216
    poSQLINT64ToBCD = True
    object CROSS_FIRMSID: TFIBIntegerField
      FieldName = 'ID'
    end
    object CROSS_FIRMSCOMPANY_NAME: TFIBStringField
      FieldName = 'COMPANY_NAME'
      Size = 50
      EmptyStrToNull = True
    end
    object CROSS_FIRMSCOUNTS: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'COUNTS'
      Calculated = True
    end
    object CROSS_FIRMSSUMA: TFloatField
      FieldKind = fkCalculated
      FieldName = 'SUMA'
      Calculated = True
    end
  end
  object frCROSS_FIRMS: TfrDBDataSet
    DataSet = CROSS_FIRMS
    Left = 176
    Top = 216
  end
end
