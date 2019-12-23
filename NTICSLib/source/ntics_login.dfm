object IBLogin: TIBLogin
  Left = 280
  Top = 204
  Width = 356
  Height = 200
  Caption = 'IBLogin'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object MainPanel: TPanel
    Left = 0
    Top = 0
    Width = 348
    Height = 52
    Align = alTop
    TabOrder = 0
    object btExtended: TSpeedButton
      Left = 216
      Top = 23
      Width = 113
      Height = 19
      Hint = 'Show Extended'
      AllowAllUp = True
      GroupIndex = 1
      Down = True
      Caption = #1044#1086#1076#1072#1090#1082#1086#1074#1086
      ParentShowHint = False
      ShowHint = True
      OnClick = btExtendedClick
    end
    object chAutoLogin: TCheckBox
      Left = 216
      Top = 3
      Width = 119
      Height = 17
      Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1085#1080#1081' '#1074#1093#1110#1076
      TabOrder = 0
    end
    object edUserName: TLabeledEdit
      Left = 70
      Top = 1
      Width = 137
      Height = 21
      EditLabel.Width = 61
      EditLabel.Height = 13
      EditLabel.Caption = #1050#1086#1088#1080#1089#1090#1091#1074#1072#1095':'
      LabelPosition = lpLeft
      LabelSpacing = 3
      TabOrder = 1
    end
    object edPassword: TLabeledEdit
      Left = 70
      Top = 24
      Width = 136
      Height = 21
      EditLabel.Width = 41
      EditLabel.Height = 13
      EditLabel.Caption = #1055#1072#1088#1086#1083#1100':'
      LabelPosition = lpLeft
      LabelSpacing = 3
      PasswordChar = '*'
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 54
    Width = 348
    Height = 83
    TabOrder = 1
    object Label4: TLabel
      Left = 5
      Top = 32
      Width = 30
      Height = 13
      Caption = #1041#1072#1079#1099':'
    end
    object SetPatchBase: TSpeedButton
      Left = 322
      Top = 26
      Width = 23
      Height = 22
      Flat = True
      OnClick = SetPatchBaseClick
    end
    object Label5: TLabel
      Left = 5
      Top = 8
      Width = 40
      Height = 13
      Caption = #1057#1077#1088#1074#1077#1088':'
    end
    object Label2: TLabel
      Left = 6
      Top = 55
      Width = 28
      Height = 13
      Caption = #1056#1086#1083#1100':'
    end
    object edUserDatabase: TEdit
      Left = 48
      Top = 27
      Width = 270
      Height = 21
      TabOrder = 0
    end
    object cbConnectType: TComboBox
      Left = 48
      Top = 4
      Width = 90
      Height = 21
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 1
      Text = 'Local'
      OnClick = cbConnectTypeClick
      Items.Strings = (
        'Local'
        'TCP/IP'
        'NetBEUI'
        'Novell SPX')
    end
    object edServerName: TLabeledEdit
      Left = 211
      Top = 3
      Width = 133
      Height = 21
      EditLabel.Width = 67
      EditLabel.Height = 13
      EditLabel.Caption = #1030#1084#39#1103' '#1089#1077#1088#1074#1077#1088#1072':'
      LabelPosition = lpLeft
      LabelSpacing = 3
      TabOrder = 2
    end
    object edRole: TComboBox
      Left = 47
      Top = 50
      Width = 138
      Height = 21
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 3
      Text = #1050#1086#1088#1080#1089#1090#1091#1074#1072#1095
      Items.Strings = (
        #1050#1086#1088#1080#1089#1090#1091#1074#1072#1095)
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 139
    Width = 348
    Height = 34
    Align = alBottom
    TabOrder = 2
    object Button1: TButton
      Left = 191
      Top = 4
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 269
      Top = 4
      Width = 75
      Height = 25
      Caption = #1042#1110#1076#1084#1110#1085#1080#1090#1080
      Default = True
      ModalResult = 2
      TabOrder = 1
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'IB DataBase|*.gdb'
    InitialDir = '\'
    Title = 'Open'
    Left = 5
    Top = 142
  end
end
