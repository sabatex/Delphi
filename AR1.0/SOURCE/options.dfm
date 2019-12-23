object frm_options: Tfrm_options
  Left = 267
  Top = 220
  Width = 561
  Height = 405
  Caption = 'frm_options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 553
    Height = 378
    ActivePage = TabSheet3
    Align = alClient
    TabIndex = 2
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #1056#1077#1082#1074#1110#1079#1080#1090#1080' '#1087#1110#1076#1087#1088#1080#1101#1084#1089#1090#1074#1072
      object btOK: TSpeedButton
        Left = 368
        Top = 296
        Width = 89
        Height = 22
        Caption = 'OK'
        OnClick = btOKClick
      end
      object Label16: TLabel
        Left = 8
        Top = 52
        Width = 205
        Height = 26
        Caption = 
          #1030#1076#1077#1085#1090#1080#1092#1110#1082#1072#1094#1110#1081#1085#1080#1081' '#1085#1086#1084#1077#1088' '#1092#1110#1079#1080#1095#1085#1086#1111' '#1086#1089#1086#1073#1080' -'#13#10#1089#1091#1073#39#1108#1082#1090#1072' '#1087#1110#1076#1087#1088#1080#1108#1084#1085#1080#1094#1100#1082#1086 +
          #1111' '#1076#1110#1103#1083#1100#1085#1086#1089#1090#1110
      end
      object Label1: TLabel
        Left = 8
        Top = 29
        Width = 52
        Height = 13
        Caption = #1042#1080#1076' '#1086#1089#1086#1073#1080
      end
      object Label4: TLabel
        Left = 8
        Top = 8
        Width = 40
        Height = 13
        Caption = #1060#1080#1088#1084#1072':'
      end
      object FEDRPOU: TEdit
        Left = 232
        Top = 54
        Width = 121
        Height = 21
        ReadOnly = True
        TabOrder = 0
        Text = 'FEDRPOU'
      end
      object btClose: TButton
        Left = 464
        Top = 296
        Width = 75
        Height = 23
        Caption = #1042#1110#1076#1084#1110#1085#1080#1090#1080
        TabOrder = 1
        OnClick = btCloseClick
      end
      object GroupBox1: TGroupBox
        Left = 358
        Top = 0
        Width = 185
        Height = 73
        Caption = #1055#1077#1088#1110#1086#1076
        TabOrder = 2
        object Label2: TLabel
          Left = 3
          Top = 18
          Width = 18
          Height = 13
          Caption = #1056#1110#1082':'
        end
        object sbPriorYear: TSpeedButton
          Left = 57
          Top = 14
          Width = 23
          Height = 22
          Caption = '<'
          OnClick = sbPriorYearClick
        end
        object sbNextYear: TSpeedButton
          Left = 150
          Top = 14
          Width = 23
          Height = 22
          Caption = '>'
          OnClick = sbNextYearClick
        end
        object Label3: TLabel
          Left = 3
          Top = 43
          Width = 45
          Height = 13
          Caption = #1050#1074#1072#1088#1090#1072#1083':'
        end
        object sbPriorKvartal: TSpeedButton
          Left = 57
          Top = 40
          Width = 23
          Height = 22
          Caption = '<'
          OnClick = sbPriorKvartalClick
        end
        object sbNextKvartal: TSpeedButton
          Left = 125
          Top = 40
          Width = 23
          Height = 22
          Caption = '>'
          OnClick = sbNextKvartalClick
        end
        object Year: TEdit
          Left = 83
          Top = 14
          Width = 65
          Height = 21
          TabOrder = 0
          Text = 'Year'
        end
        object Kvartal: TEdit
          Left = 83
          Top = 40
          Width = 41
          Height = 21
          TabOrder = 1
          Text = 'Kvartal'
        end
      end
      object GroupBox2: TGroupBox
        Left = 7
        Top = 85
        Width = 271
        Height = 81
        Caption = #1050#1077#1088#1110#1074#1085#1080#1082
        TabOrder = 3
        object Label19: TLabel
          Left = 5
          Top = 12
          Width = 27
          Height = 13
          Caption = #1055'.'#1030'.'#1041'.'
        end
        object Label18: TLabel
          Left = 5
          Top = 35
          Width = 121
          Height = 13
          Caption = #1030#1076#1077#1085#1090#1080#1092#1110#1082#1072#1094#1110#1081#1085#1080#1081' '#1085#1086#1084#1077#1088
        end
        object Label20: TLabel
          Left = 5
          Top = 61
          Width = 100
          Height = 13
          Caption = #1058#1077#1083#1077#1092#1086#1085' ('#1094#1080#1092#1088#1072#1084#1080')'
        end
        object DirName: TEdit
          Left = 144
          Top = 8
          Width = 121
          Height = 21
          TabOrder = 0
          Text = 'DirName'
        end
        object DirCod: TEdit
          Left = 144
          Top = 32
          Width = 121
          Height = 21
          TabOrder = 1
          Text = 'DirCod'
        end
        object DirTell: TEdit
          Left = 144
          Top = 56
          Width = 121
          Height = 21
          TabOrder = 2
          Text = 'DirTell'
        end
      end
      object GroupBox3: TGroupBox
        Left = 283
        Top = 85
        Width = 260
        Height = 81
        Caption = #1043#1086#1083#1086#1074#1085#1080#1081' '#1073#1091#1093#1075#1072#1083#1090#1077#1088
        TabOrder = 4
        object Label5: TLabel
          Left = 3
          Top = 12
          Width = 27
          Height = 13
          Caption = #1055'.'#1030'.'#1041'.'
        end
        object Label6: TLabel
          Left = 3
          Top = 35
          Width = 121
          Height = 13
          Caption = #1030#1076#1077#1085#1090#1080#1092#1110#1082#1072#1094#1110#1081#1085#1080#1081' '#1085#1086#1084#1077#1088
        end
        object Label7: TLabel
          Left = 3
          Top = 61
          Width = 100
          Height = 13
          Caption = #1058#1077#1083#1077#1092#1086#1085' ('#1094#1080#1092#1088#1072#1084#1080')'
        end
        object ShiefName: TEdit
          Left = 134
          Top = 8
          Width = 121
          Height = 21
          TabOrder = 0
          Text = 'DirName'
        end
        object ShiefCod: TEdit
          Left = 134
          Top = 32
          Width = 121
          Height = 21
          TabOrder = 1
          Text = 'DirCod'
        end
        object ShiefTell: TEdit
          Left = 134
          Top = 56
          Width = 121
          Height = 21
          TabOrder = 2
          Text = 'DirTell'
        end
      end
      object GroupBox4: TGroupBox
        Left = 7
        Top = 174
        Width = 537
        Height = 115
        Caption = #1055#1086#1076#1072#1090#1082#1086#1074#1072
        TabOrder = 5
        object Label25: TLabel
          Left = 8
          Top = 44
          Width = 136
          Height = 13
          Caption = #1053#1072#1079#1074#1072' '#1087#1086#1076#1072#1090#1082#1086#1074#1086#1075#1086' '#1086#1088#1075#1072#1085#1091
        end
        object Label37: TLabel
          Left = 12
          Top = 92
          Width = 109
          Height = 13
          Caption = #1050#1086#1076' '#1086#1073#1083#1072#1089#1090#1110' (2-'#1094#1080#1092#1088#1080')'
        end
        object Label38: TLabel
          Left = 10
          Top = 61
          Width = 214
          Height = 26
          Caption = 
            #1050#1086#1076' '#1086#1088#1075#1072#1085#1091' '#1076#1077#1088#1078#1072#1074#1085#1086#1111' '#1087#1086#1076#1072#1090#1082#1086#1074#1086#1111' '#1089#1083#1091#1078#1073#1080','#13#10#1082#1091#1076#1080' '#1087#1086#1076#1072#1108#1090#1100#1089#1103' '#1076#1086#1074#1110#1076#1082#1072' ' +
            '(2 - '#1094#1080#1092#1088#1080')'
        end
        object Label17: TLabel
          Left = 8
          Top = 16
          Width = 200
          Height = 26
          Caption = 
            #1030#1076#1077#1085#1090#1080#1092#1110#1082#1072#1094#1110#1081#1085#1080#1081' '#1082#1086#1076' '#1086#1088#1075#1072#1085#1091' '#1076#1077#1088#1078#1072#1074#1085#1086#1111#13#10#1087#1086#1076#1072#1090#1082#1086#1074#1086#1111' '#1089#1083#1091#1078#1073#1080' '#1079#1072' '#1028#1044#1056#1055 +
            #1054#1059
        end
        object EDRPOUPOD: TEdit
          Left = 248
          Top = 11
          Width = 121
          Height = 21
          TabOrder = 0
          Text = 'EDRPOUPOD'
        end
        object PODNAME: TEdit
          Left = 248
          Top = 36
          Width = 262
          Height = 21
          TabOrder = 1
          Text = 'PODNAME'
        end
        object PODCOD: TEdit
          Left = 249
          Top = 60
          Width = 121
          Height = 21
          TabOrder = 2
          Text = 'PODCOD'
        end
        object PODOBL: TEdit
          Left = 249
          Top = 85
          Width = 121
          Height = 21
          TabOrder = 3
          Text = 'PODOBL'
        end
      end
      object VFO: TEdit
        Left = 232
        Top = 27
        Width = 118
        Height = 21
        ReadOnly = True
        TabOrder = 6
        Text = 'VFO'
      end
      object edFIRMS: TEdit
        Left = 56
        Top = 5
        Width = 294
        Height = 21
        ReadOnly = True
        TabOrder = 7
        Text = 'edFIRMS'
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1042#1080#1076#1080' '#1087#1110#1083#1100#1075
      ImageIndex = 1
      object DBGridEh1: TDBGridEh
        Left = 0
        Top = 0
        Width = 545
        Height = 350
        Align = alClient
        DataSource = dsLGT
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            EditButtons = <>
            FieldName = 'KOD'
            Footers = <>
          end
          item
            EditButtons = <>
            FieldName = 'NAME'
            Footers = <>
          end>
      end
    end
    object TabSheet3: TTabSheet
      Caption = #1054#1079#1085#1072#1082#1080' '#1076#1086#1093#1086#1076#1091
      ImageIndex = 2
      object DBGridEh2: TDBGridEh
        Left = 0
        Top = 0
        Width = 545
        Height = 350
        Align = alClient
        DataSource = dsOZN
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            EditButtons = <>
            FieldName = 'KOD'
            Footers = <>
          end
          item
            EditButtons = <>
            FieldName = 'NAME'
            Footers = <>
          end>
      end
    end
  end
  object LGT: THalcyonDataSet
    About = 'Halcyon Version 6.737 (08 Feb 01)'
    AutoFlush = False
    DatabaseName = '..\BIN'
    Exclusive = False
    LockProtocol = Default
    TableName = 'LGT.DBF'
    TranslateASCII = True
    UseDeleted = False
    UserID = 0
    Left = 296
    object LGTKOD: TSmallintField
      FieldName = 'KOD'
    end
    object LGTNAME: TStringField
      FieldName = 'NAME'
      Size = 80
    end
  end
  object dsLGT: TDataSource
    DataSet = LGT
    Left = 360
  end
  object OZN: THalcyonDataSet
    About = 'Halcyon Version 6.737 (08 Feb 01)'
    AutoFlush = False
    DatabaseName = '..\BIN'
    Exclusive = False
    LockProtocol = Default
    TableName = 'OZN.DBF'
    TranslateASCII = True
    UseDeleted = False
    UserID = 0
    Left = 328
  end
  object dsOZN: TDataSource
    DataSet = OZN
    Left = 392
  end
end
