object FramePackageSelection: TFramePackageSelection
  Left = 0
  Top = 0
  Width = 518
  Height = 348
  TabOrder = 0
  object LblTarget: TLabel
    Left = 8
    Top = 104
    Width = 55
    Height = 13
    Caption = 'LblTarget'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object LblIDEs: TLabel
    Left = 8
    Top = 8
    Width = 69
    Height = 13
    Caption = '&Available IDEs'
    FocusControl = ListViewTargetIDEs
    Transparent = True
  end
  object LblFrameworks: TLabel
    Left = 232
    Top = 8
    Width = 60
    Height = 13
    Caption = '&Frameworks:'
    FocusControl = CheckListBoxFrameworks
  end
  object LblShowMode: TLabel
    Left = 330
    Top = 101
    Width = 80
    Height = 13
    Alignment = taRightJustify
    Caption = '&Show packages:'
    FocusControl = ComboBoxDisplayMode
  end
  object CheckListBoxPackages: TCheckListBox
    Left = 8
    Top = 120
    Width = 505
    Height = 225
    OnClickCheck = CheckListBoxPackagesClickCheck
    AllowGrayed = True
    ItemHeight = 18
    ParentShowHint = False
    PopupMenu = PopupMenuPackages
    ShowHint = True
    Style = lbOwnerDrawVariable
    TabOrder = 2
    OnDrawItem = CheckListBoxPackagesDrawItem
    OnMouseMove = CheckListBoxPackagesMouseMove
  end
  object ComboBoxDisplayMode: TComboBox
    Left = 416
    Top = 97
    Width = 97
    Height = 21
    Hint = 
      '<b>Designtime:</b>'#13#10'     Show all designtime packages. Checking/' +
      'Unchecking a'#13#10'     designtime package checks/unchecks the corres' +
      'ponding'#13#10'     runtime package. (Designtime/runtime packages are ' +
      'linked)'#13#10#13#10'<b>Runtime:</b>'#13#10'     Show all runtime package. Unche' +
      'cking a runtime package'#13#10'     unchecks the corresponding designt' +
      'ime package due to'#13#10'     dependencies.'#13#10#13#10'<b>Both:</b>'#13#10'     Sho' +
      'w all packages. Only packages that depend on others'#13#10'     are ch' +
      'ecked/unchecked if necessary.'
    Style = csDropDownList
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnChange = ComboBoxDisplayModeChange
    Items.Strings = (
      'Designtime'
      'Runtime'
      'Both')
  end
  object ListViewTargetIDEs: TListView
    Left = 8
    Top = 24
    Width = 201
    Height = 73
    Columns = <
      item
        AutoSize = True
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    ShowColumnHeaders = False
    SmallImages = ImageListTargets
    TabOrder = 0
    ViewStyle = vsReport
    OnSelectItem = ListViewTargetIDEsSelectItem
  end
  object CheckListBoxFrameworks: TCheckListBox
    Left = 232
    Top = 24
    Width = 105
    Height = 38
    OnClickCheck = CheckListBoxFrameworksClickCheck
    ItemHeight = 16
    Style = lbOwnerDrawVariable
    TabOrder = 1
    OnClick = CheckListBoxFrameworksClick
  end
  object BtnReset: TButton
    Left = 356
    Top = 24
    Width = 157
    Height = 25
    Action = ActionResetPackages
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object ImageListPackages: TImageList
    Left = 480
    Top = 128
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D6D6D600ADADAD00D6D6D60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000000000000C6C6C6000000000000000000848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000000000000C6C6C6000000000000000000848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D6D6D600ADADAD00ADADAD00EFEFEF00ADADAD00ADADAD00D6D6D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      000000000000FFFF0000FFFF000000000000FFFF0000FF000000000000000000
      0000848484000000000000000000000000000000000000000000848484000000
      00000000000000FFFF0000FFFF000000000000FFFF0000848400000000000000
      0000848484000000000000000000000000000000000000000000D6D6D600ADAD
      AD00ADADAD00D6D6FF00D6D6FF0000000000D6D6FF00ADADEF00ADADAD00ADAD
      AD00D6D6D6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000848484000000000000000000FFFF
      00000000FF00FFFF0000FFFF0000C6C6C600FF000000FFFF00000000FF00FFFF
      00000000000000000000848484000000000084848400000000000000000000FF
      FF000000FF0000FFFF0000FFFF00C6C6C6000084840000FFFF000000FF0000FF
      FF0000000000000000008484840000000000D6D6D600ADADAD00ADADAD00D6D6
      FF00D6ADAD00D6D6FF00D6D6FF00EFEFEF00ADADEF00D6D6FF00D6ADAD00D6D6
      FF00ADADAD00ADADAD00D6D6D600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      00000000FF00FFFF0000FFFF000000000000FFFF0000FF0000000000FF00FF00
      0000FFFF0000FF00000000000000000000000000000000FFFF0000FFFF0000FF
      FF000000FF0000FFFF0000FFFF000000000000FFFF00008484000000FF000084
      840000FFFF00008484000000000000000000ADADAD00D6D6FF00D6D6FF00D6D6
      FF00D6ADAD00D6D6FF00D6D6FF0000000000D6D6FF00ADADEF00D6ADAD00ADAD
      EF00D6D6FF00ADADEF00ADADAD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      00000000FF00FFFF0000FFFF0000C6C6C600FF000000FFFF00000000FF00FFFF
      0000FF000000FFFF000000000000000000000000000000FFFF0000FFFF0000FF
      FF000000FF0000FFFF0000FFFF00C6C6C6000084840000FFFF000000FF0000FF
      FF000084840000FFFF000000000000000000ADADAD00D6D6FF00D6D6FF00D6D6
      FF00D6ADAD00D6D6FF00D6D6FF00EFEFEF00ADADEF00D6D6FF00D6ADAD00D6D6
      FF00ADADEF00D6D6FF00ADADAD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      00000000FF00FFFF0000FFFF000000000000FFFF0000FF0000000000FF00FF00
      0000FFFF0000FF00000000000000000000000000000000FFFF0000FFFF0000FF
      FF000000FF0000FFFF0000FFFF000000000000FFFF00008484000000FF000084
      840000FFFF00008484000000000000000000ADADAD00D6D6FF00D6D6FF00D6D6
      FF00D6ADAD00D6D6FF00D6D6FF0000000000D6D6FF00ADADEF00D6ADAD00ADAD
      EF00D6D6FF00ADADEF00ADADAD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      00000000FF00FFFF0000FFFF0000C6C6C600FF000000FFFF00000000FF00FFFF
      0000FF000000FFFF000000000000000000000000000000FFFF0000FFFF0000FF
      FF000000FF0000FFFF0000FFFF00C6C6C6000084840000FFFF000000FF0000FF
      FF000084840000FFFF000000000000000000ADADAD00D6D6FF00D6D6FF00D6D6
      FF00D6ADAD00D6D6FF00D6D6FF00EFEFEF00ADADEF00D6D6FF00D6ADAD00D6D6
      FF00ADADEF00D6D6FF00ADADAD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      00000000FF0084848400848484000000000084848400848484000000FF00FF00
      0000FFFF0000FF00000000000000000000000000000000FFFF0000FFFF0000FF
      FF000000FF0084848400848484000000000084848400848484000000FF000084
      840000FFFF00008484000000000000000000ADADAD00D6D6FF00D6D6FF00D6D6
      FF00D6ADAD00D6D6D600D6D6D60000000000D6D6D600D6D6D600D6ADAD00ADAD
      EF00D6D6FF00ADADEF00ADADAD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF00008484
      84000000FF00FFFF000000000000FFFF000000000000FFFF00000000FF008484
      8400FF000000FFFF000000000000000000000000000000FFFF0000FFFF008484
      84000000FF0000FFFF000000000000FFFF000000000000FFFF000000FF008484
      84000084840000FFFF000000000000000000ADADAD00D6D6FF00D6D6FF00D6D6
      D600D6ADAD00D6D6FF0000000000D6D6FF0000000000D6D6FF00D6ADAD00D6D6
      D600ADADEF00D6D6FF00ADADAD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484000000
      0000FFFF00000000FF00FFFF000000000000FFFF00000000FF00FFFF00000000
      0000848484008484840000000000000000000000000084848400848484000000
      000000FFFF000000FF0000FFFF000000000000FFFF000000FF0000FFFF000000
      000084848400848484000000000000000000ADADAD00D6D6D600D6D6D6000000
      0000D6D6FF00D6ADAD00D6D6FF0000000000D6D6FF00D6ADAD00D6D6FF000000
      0000D6D6D600D6D6D600ADADAD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF000000000000FFFF
      000000000000FFFF00000000FF000000FF000000FF00FFFF000000000000FFFF
      000000000000FFFF000000000000000000000000000000FFFF000000000000FF
      FF000000000000FFFF000000FF000000FF000000FF0000FFFF000000000000FF
      FF000000000000FFFF000000000000000000ADADAD00D6D6FF0000000000D6D6
      FF0000000000D6D6FF00D6ADAD00D6ADAD00D6ADAD00D6D6FF0000000000D6D6
      FF0000000000D6D6FF00ADADAD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000FFFF00000000FF0000000000FFFF0000000000000000FF00FFFF00000000
      0000000000000000000084848400000000008484840000000000000000000000
      000000FFFF000000FF000000000000FFFF00000000000000FF0000FFFF000000
      000000000000000000008484840000000000D6D6D600ADADAD00ADADAD000000
      0000D6D6FF00D6ADAD0000000000D6D6FF0000000000D6ADAD00D6D6FF000000
      0000ADADAD00ADADAD00D6D6D600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      00000000000000000000FFFF000000000000FFFF000000000000000000000000
      0000848484000000000000000000000000000000000000000000848484000000
      0000000000000000000000FFFF000000000000FFFF0000000000000000000000
      0000848484000000000000000000000000000000000000000000D6D6D600ADAD
      AD00ADADAD0000000000D6D6FF0000000000D6D6FF0000000000ADADAD00ADAD
      AD00D6D6D6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000000000000FFFF00000000000000000000848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400000000000000000000FFFF000000000000000000848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D6D6D600ADADAD00ADADAD00D6D6FF00ADADAD00ADADAD00D6D6D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D6D6D600ADADAD00D6D6D60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FC7FFC7FFC7F0000F01FF01FF01F0000
      C107C107C1070000000100010001000001010101010100000001000100010000
      0101010101010000000100010001000001010101010100000281028102810000
      111111111111000028292829282900001291129112910000C547C547C5470000
      F01FF01FF01F0000FC7FFC7FFC7F000000000000000000000000000000000000
      000000000000}
  end
  object ImageListTargets: TImageList
    Left = 176
    Top = 32
  end
  object PopupMenuPackages: TPopupMenu
    Images = ImageListPackages
    Left = 16
    Top = 128
    object MenuInstallAll: TMenuItem
      Action = ActionInstallAll
    end
    object MenuInstallNone: TMenuItem
      Action = ActionInstallNone
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object ResetPackages1: TMenuItem
      Action = ActionResetPackages
    end
  end
  object ActionList: TActionList
    Left = 48
    Top = 128
    object ActionInstallAll: TAction
      Caption = 'Install &all'
      OnExecute = ActionInstallAllExecute
      OnUpdate = ActionInstallAllUpdate
    end
    object ActionInstallNone: TAction
      Caption = 'Install &none'
      OnExecute = ActionInstallAllExecute
      OnUpdate = ActionInstallAllUpdate
    end
    object ActionResetPackages: TAction
      Caption = '&Reset all Packages'
      Hint = 'Reset the package selection to IDE default.'
      OnExecute = ActionInstallAllExecute
      OnUpdate = ActionInstallAllUpdate
    end
  end
  object TimerHint: TTimer
    Enabled = False
    OnTimer = TimerHintTimer
    Left = 80
    Top = 128
  end
end
