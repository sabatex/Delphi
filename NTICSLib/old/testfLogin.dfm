object frmLogin: TfrmLogin
  Left = 673
  Top = 205
  Width = 317
  Height = 323
  Caption = 'Form1'
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
    Width = 309
    Height = 57
    Align = alTop
    TabOrder = 0
    object btExtended: TSpeedButton
      Left = 276
      Top = 28
      Width = 23
      Height = 22
      Hint = 'Show Extended'
      AllowAllUp = True
      GroupIndex = 1
      Down = True
      Caption = '>>'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = btExtendedClick
    end
    object UserName: TLabel
      Left = 7
      Top = 8
      Width = 50
      Height = 13
      Caption = 'UserName'
    end
    object Password: TLabel
      Left = 8
      Top = 32
      Width = 46
      Height = 13
      Caption = 'Password'
    end
    object edUserName: TEdit
      Left = 72
      Top = 4
      Width = 193
      Height = 21
      TabOrder = 0
      Text = 'edUserName'
    end
    object edPassword: TEdit
      Left = 72
      Top = 29
      Width = 193
      Height = 21
      PasswordChar = '*'
      TabOrder = 1
      Text = 'edPassword'
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 262
    Width = 309
    Height = 34
    Align = alBottom
    TabOrder = 1
    object Button1: TButton
      Left = 143
      Top = 4
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 224
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Cancel'
      Default = True
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 58
    Width = 309
    Height = 201
    TabOrder = 2
    object Label1: TLabel
      Left = 11
      Top = 81
      Width = 65
      Height = 13
      Caption = 'Server Name:'
    end
    object Label4: TLabel
      Left = 12
      Top = 103
      Width = 50
      Height = 13
      Caption = 'DataBase:'
    end
    object SetPatchBase: TSpeedButton
      Left = 274
      Top = 98
      Width = 23
      Height = 22
      Flat = True
      OnClick = SetPatchBaseClick
    end
    object Label2: TLabel
      Left = 14
      Top = 131
      Width = 25
      Height = 13
      Caption = 'Role:'
    end
    object Label3: TLabel
      Left = 11
      Top = 151
      Width = 54
      Height = 13
      Caption = 'Code table:'
    end
    object ServerRG: TRadioGroup
      Left = 1
      Top = 2
      Width = 124
      Height = 68
      Caption = 'InterBase Server'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 11
      Font.Name = 'MS Sans Serif'
      Font.Pitch = fpVariable
      Font.Style = [fsBold]
      Items.Strings = (
        'Local'
        'Network')
      ParentFont = False
      TabOrder = 0
      OnClick = ServerRGClick
    end
    object NetworkProtocolGR: TRadioGroup
      Left = 134
      Top = 2
      Width = 158
      Height = 68
      Caption = 'Network Protocol'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = 11
      Font.Name = 'MS Sans Serif'
      Font.Pitch = fpVariable
      Font.Style = [fsBold]
      Items.Strings = (
        'NetBEUI'
        'TCP/IP'
        'Novell SPX')
      ParentFont = False
      TabOrder = 1
    end
    object edServerName: TComboBox
      Left = 87
      Top = 75
      Width = 210
      Height = 21
      ItemHeight = 13
      TabOrder = 2
    end
    object edUserDatabase: TEdit
      Left = 86
      Top = 99
      Width = 183
      Height = 21
      TabOrder = 3
    end
    object edRole: TComboBox
      Left = 86
      Top = 123
      Width = 211
      Height = 21
      ItemHeight = 13
      TabOrder = 4
    end
    object edCodeTable: TComboBox
      Left = 86
      Top = 145
      Width = 211
      Height = 21
      ItemHeight = 13
      TabOrder = 5
    end
    object chSavePassword: TCheckBox
      Left = 3
      Top = 173
      Width = 100
      Height = 17
      Hint = 'Automatick insert last user password'
      Caption = 'Save Password'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = chSavePasswordClick
    end
    object chAutoLogin: TCheckBox
      Left = 112
      Top = 172
      Width = 89
      Height = 17
      Caption = 'AutoLogOn'
      TabOrder = 7
      OnClick = chAutoLoginClick
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'IB DataBase|*.gdb'
    InitialDir = '\'
    Title = 'Open'
    Left = 5
    Top = 310
  end
end
