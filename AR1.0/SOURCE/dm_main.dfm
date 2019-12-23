inherited dmMain: TdmMain
  OldCreateOrder = True
  Left = 303
  Top = 197
  Height = 371
  Width = 444
  inherited ActionList: TActionList
    Top = 32
    object aRegistration: TAction
      Category = '?'
      Caption = #1056#1077#1108#1089#1090#1088#1072#1094#1110#1103
      OnExecute = aRegistrationExecute
    end
    object aWokers: TAction
      Category = #1044#1086#1074#1110#1076#1085#1080#1082#1080
      Caption = #1055#1088#1072#1094#1110#1074#1085#1080#1082#1080
      OnExecute = aWokersExecute
    end
    object a1DF: TAction
      Category = #1044#1086#1074#1110#1076#1085#1080#1082#1080
      Caption = #1060#1086#1088#1084#1072' 1'#1044#1060
      OnExecute = a1DFExecute
    end
    object aOptions: TAction
      Category = #1054#1087#1094#1110#1111
      Caption = #1054#1087#1094#1110#1111
      OnExecute = aOptionsExecute
    end
    object aConfig1C60: TAction
      Category = #1054#1087#1094#1110#1111
      Caption = #1030#1084#1087#1086#1088#1090' 1'#1057'6.0'
      OnExecute = aConfig1C60Execute
    end
    object aConfig1C77: TAction
      Category = #1054#1087#1094#1110#1111
      Caption = #1030#1084#1087#1086#1088#1090' 1'#1057'7.7'
      OnExecute = aConfig1C77Execute
    end
    object aReport1DF: TAction
      Category = #1047#1074#1110#1090#1080
      Caption = #1060#1086#1088#1084#1072' 1'#1044#1060
      OnExecute = aReport1DFExecute
    end
    object aImportConfig: TAction
      Category = #1060#1072#1081#1083
      Caption = #1042#1110#1076#1085#1086#1074#1080#1090#1080' '#1082#1086#1085#1092#1110#1075#1091#1088#1072#1110#1102
      OnExecute = aImportConfigExecute
    end
    object aExportConfig: TAction
      Category = #1060#1072#1081#1083
      Caption = #1047#1073#1077#1088#1077#1075#1090#1080' '#1082#1086#1085#1092#1110#1075#1091#1088#1072#1094#1110#1102
      OnExecute = aExportConfigExecute
    end
    object aExport1DF: TAction
      Category = #1060#1072#1081#1083
      Caption = #1047#1072#1087#1080#1089#1072#1090#1080' '#1074#1110#1076#1086#1084#1110#1089#1090#1100' '#1085#1072' '#1076#1080#1089#1082
      ImageIndex = 6
      OnExecute = aExport1DFExecute
    end
    object aImport1C60: TAction
      Category = #1060#1072#1081#1083
      Caption = #1030#1084#1087#1086#1088#1090' '#1076#1072#1085#1080#1093' '#1079' 1'#1057'6.0'
      OnExecute = aImport1C60Execute
    end
    object aImport1C77: TAction
      Category = #1060#1072#1081#1083
      Caption = #1030#1084#1087#1086#1088#1090' '#1076#1072#1085#1080#1093' '#1079' 1'#1057'7.7'
      OnExecute = aImport1C77Execute
    end
  end
  object OpenRegKey: TOpenDialog
    FilterIndex = 0
    InitialDir = '\'
    Left = 192
    Top = 24
  end
  object frDialogControls1: TfrDialogControls
    Left = 192
    Top = 88
  end
  object frDBDataSetDA: TfrDBDataSet
    DataSet = dmBase.DA
    Left = 192
    Top = 136
  end
  object frRichObject1: TfrRichObject
    Left = 264
    Top = 88
  end
  object frReport1: TfrReport
    InitialZoom = pzDefault
    PreviewButtons = [pbZoom, pbLoad, pbSave, pbPrint, pbFind, pbHelp, pbExit]
    RebuildPrinter = False
    OnGetValue = frReport1GetValue
    OnUserFunction = frReport1UserFunction
    Left = 264
    Top = 136
    ReportForm = {19000000}
  end
  object SaveDialogOut: TSaveDialog
    Left = 320
    Top = 24
  end
  object odConfig: TOpenDialog
    DefaultExt = '8DR'
    Filter = #1060#1086#1088#1084#1072' 8'#1044#1056' '#1082#1086#1085#1092#1110#1075#1091#1088#1072#1094#1110#1103'|*.8DR'
    Left = 320
    Top = 80
  end
  object sdConfig: TSaveDialog
    DefaultExt = '8DR'
    Filter = #1050#1086#1085#1092#1080#1075#1091#1088#1072#1094#1080#1103' 8'#1044#1056'|*.8DR'
    Left = 318
    Top = 128
  end
  object odInsertFromFile: TOpenDialog
    Left = 320
    Top = 184
  end
end
