inherited dmMain: TdmMain
  OldCreateOrder = True
  inherited ActionList: TActionList
    object aProducts: TAction
      Category = #1044#1086#1074#1110#1076#1085#1080#1082#1080
      Caption = #1055#1088#1086#1075#1088#1072#1084#1080
      OnExecute = aShowProductsExecute
    end
  end
  inherited MainMenu: TMainMenu
    inherited N8: TMenuItem
      object ShowProducts1: TMenuItem
        Action = aProducts
      end
    end
  end
  object ActionListMain: TActionList
    Left = 288
    Top = 24
    object aAddProgramm: TAction
      Category = 'ProductsTree'
      Caption = #1044#1086#1076#1072#1090#1080' '#1087#1088#1086#1075#1088#1072#1084#1084#1091
      OnExecute = aAddProgrammExecute
    end
    object aNewVersionWithNewKey: TAction
      Category = 'ProductsTree'
      Caption = #1044#1086#1076#1072#1090#1080' '#1085#1086#1074#1091' '#1074#1077#1088#1089#1110#1102' '#1079' '#1085#1086#1074#1080#1084#1080' '#1082#1083#1102#1095#1072#1084#1080
      OnExecute = aNewVersionWithNewKeyExecute
    end
    object aNewVersionWithOldKey: TAction
      Category = 'ProductsTree'
      Caption = #1044#1086#1076#1072#1090#1080' '#1085#1086#1074#1091' '#1074#1077#1088#1089#1110#1102' '#1079' '#1090#1077#1082#1091#1095#1080#1084#1080' '#1082#1083#1102#1095#1072#1084#1080
      OnExecute = aNewVersionWithOldKeyExecute
    end
    object aDeleteVersion: TAction
      Category = 'ProductsTree'
      Caption = #1042#1080#1076#1072#1083#1080#1090#1080' '#1076#1072#1085#1091' '#1074#1077#1088#1089#1110#1102
      OnExecute = aDeleteVersionExecute
    end
    object aEditCurrentVersion: TAction
      Category = 'ProductsTree'
      Caption = #1056#1077#1076#1072#1075#1091#1074#1072#1090#1080' '#1076#1072#1085#1091' '#1074#1077#1088#1089#1110#1102
      OnExecute = aEditCurrentVersionExecute
    end
    object aPayProgramm: TAction
      Category = 'ProductsTree'
      Caption = #1055#1088#1086#1076#1072#1090#1080' '#1076#1072#1085#1091' '#1074#1077#1088#1089#1110#1102
      OnExecute = aPayProgrammExecute
    end
    object aDillers: TAction
      Category = 'Products'
      Caption = 'aDillers'
      OnExecute = aDillersExecute
    end
  end
end
