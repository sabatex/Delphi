inherited frmAbout_def: TfrmAbout_def
  Left = 288
  Top = 205
  Caption = 'frmAbout_def'
  ClientHeight = 253
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    Height = 52
    Align = alTop
  end
  object Panel2: TPanel
    Left = 0
    Top = 52
    Width = 509
    Height = 201
    Align = alClient
    TabOrder = 1
    object LCopyrigth1: TLabel
      Left = 4
      Top = 4
      Width = 180
      Height = 13
      Caption = 'Copyright '#169' Serhiy Lakas 1998-2004  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 11
      Font.Name = 'MS Sans Serif'
      Font.Pitch = fpVariable
      Font.Style = []
      ParentFont = False
    end
    object LCopyrigth2: TLabel
      Left = 4
      Top = 21
      Width = 151
      Height = 13
      Caption = 'Copyright '#169' NTICS 2001-2004  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 11
      Font.Name = 'MS Sans Serif'
      Font.Pitch = fpVariable
      Font.Style = []
      ParentFont = False
    end
    object RegistrationOn: TLabel
      Left = 4
      Top = 41
      Width = 99
      Height = 13
      Caption = #1047#1072#1088#1077#1108#1089#1090#1088#1086#1074#1072#1085#1086' '#1085#1072' :'
    end
    object RegistrationNumber: TLabel
      Left = 4
      Top = 57
      Width = 112
      Height = 13
      Caption = #1056#1077#1108#1089#1090#1088#1072#1094#1110#1081#1085#1080#1081' '#1085#1086#1084#1077#1088':'
    end
    object RegistrationLicenzeCount: TLabel
      Left = 4
      Top = 73
      Width = 93
      Height = 13
      Caption = #1055#1088#1080#1076#1073#1072#1085#1086' '#1083#1110#1094#1077#1085#1079#1110#1081
    end
    object Label4: TLabel
      Left = 4
      Top = 105
      Width = 249
      Height = 19
      AutoSize = False
      Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1072' '#1110#1085#1092#1086#1088#1084#1072#1094#1110#1103': '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 11
      Font.Name = 'MS Sans Serif'
      Font.Pitch = fpVariable
      Font.Style = []
      ParentFont = False
    end
    object LHTMLAdress: TLabel
      Left = 4
      Top = 121
      Width = 249
      Height = 19
      AutoSize = False
      Caption = 'http://www.elikom.com'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 11
      Font.Name = 'MS Sans Serif'
      Font.Pitch = fpVariable
      Font.Style = []
      ParentFont = False
    end
    object LEmailAdress: TLabel
      Left = 4
      Top = 137
      Width = 250
      Height = 19
      AutoSize = False
      Caption = 'Email: sabatex@mail.uzhgorod.ua'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 11
      Font.Name = 'MS Sans Serif'
      Font.Pitch = fpVariable
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object btOk: TBitBtn
      Left = 407
      Top = 171
      Width = 98
      Height = 25
      Cancel = True
      Caption = 'OK'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 11
      Font.Name = 'MS Sans Serif'
      Font.Pitch = fpVariable
      Font.Style = []
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
      OnClick = btOkClick
      NumGlyphs = 2
    end
  end
end
