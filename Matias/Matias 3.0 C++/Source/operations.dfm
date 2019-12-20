object frmOperations: TfrmOperations
  Left = 206
  Top = 180
  Width = 780
  Height = 513
  Caption = 'frmOperations'
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
  object Splitter1: TSplitter
    Left = 0
    Top = 209
    Width = 772
    Height = 7
    Cursor = crVSplit
    Align = alBottom
    Color = clAppWorkSpace
    ParentColor = False
  end
  inline frCustomGrid1: TfrCustomGrid
    Left = 0
    Top = 0
    Width = 772
    Height = 209
    Align = alClient
    Constraints.MinWidth = 232
    TabOrder = 0
    inherited Panel1: TPanel
      Width = 772
      inherited SpeedButton1: TSpeedButton
        Left = 206
      end
      inherited DBNavigator1: TDBNavigator
        Width = 200
        Hints.Strings = ()
      end
    end
    inherited DBGridEh: TDBGridEh
      Width = 772
      Height = 184
      DataSource = DataSource1
      OnKeyDown = frCustomGrid1DBGridEhKeyDown
      Columns = <
        item
          EditButtons = <>
          FieldName = 'OPERATION_NAME'
          Footers = <>
          Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1086#1087#1077#1088#1072#1094#1080#1080
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'CASHE'
          Footers = <>
          Title.Caption = #1056#1072#1089#1094#1077#1085#1082#1072
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'TIMENORM'
          Footers = <>
          Title.Caption = #1053#1086#1088#1084#1072' '#1074#1088#1077#1084#1077#1085#1080
          Title.TitleButton = True
          Width = 88
        end>
    end
  end
  object CalcPanel: TPanel
    Left = 0
    Top = 216
    Width = 772
    Height = 270
    Align = alBottom
    Caption = 'CalcPanel'
    TabOrder = 1
    object DBGridEh: TDBGridEh
      Left = 1
      Top = 33
      Width = 770
      Height = 236
      Align = alClient
      DataSource = dstOperations
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = []
      OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghIncSearch]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnKeyDown = frCustomGrid1DBGridEhKeyDown
      Columns = <
        item
          EditButtons = <>
          FieldName = 'OPERATION_NAME'
          Footers = <>
          Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1086#1087#1077#1088#1072#1094#1080#1080
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'CASHE'
          Footers = <>
          Title.Caption = #1056#1072#1089#1094#1077#1085#1082#1072
          Title.TitleButton = True
        end
        item
          EditButtons = <>
          FieldName = 'TIMENORM'
          Footers = <>
          Title.Caption = #1053#1086#1088#1084#1072' '#1074#1088#1077#1084#1077#1085#1080
          Title.TitleButton = True
          Width = 88
        end>
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 770
      Height = 32
      Align = alTop
      TabOrder = 1
      object Label1: TLabel
        Left = 7
        Top = 8
        Width = 137
        Height = 13
        Caption = #1050#1086#1077#1092#1080#1094#1080#1077#1085#1090' '#1076#1083#1103' '#1088#1072#1089#1094#1077#1085#1082#1080':'
      end
      object Label2: TLabel
        Left = 224
        Top = 8
        Width = 170
        Height = 13
        Caption = #1050#1086#1077#1092#1080#1094#1080#1077#1085#1090' '#1076#1083#1103' '#1085#1086#1088#1084#1099' '#1074#1088#1077#1084#1077#1085#1080':'
      end
      object eRasc: TEdit
        Left = 153
        Top = 5
        Width = 56
        Height = 21
        TabOrder = 0
        Text = '1'
      end
      object eNorm: TEdit
        Left = 398
        Top = 4
        Width = 51
        Height = 21
        TabOrder = 1
        Text = '1'
      end
      object btRasch: TButton
        Left = 457
        Top = 3
        Width = 75
        Height = 25
        Caption = #1056#1072#1089#1095#1080#1090#1072#1090#1100
        TabOrder = 2
        OnClick = btRaschClick
      end
      object btPerenos: TButton
        Left = 540
        Top = 3
        Width = 101
        Height = 25
        Caption = #1042#1085#1077#1089#1090#1080' '#1074' '#1090#1072#1073#1083#1080#1094#1091
        Enabled = False
        TabOrder = 3
        OnClick = btPerenosClick
      end
      object Button1: TButton
        Left = 646
        Top = 3
        Width = 75
        Height = 25
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100
        TabOrder = 4
        OnClick = Button1Click
      end
    end
  end
  object cbCalc: TCheckBox
    Left = 235
    Top = 4
    Width = 97
    Height = 17
    Caption = #1055#1077#1088#1077#1088#1072#1089#1095#1077#1090
    TabOrder = 2
    OnClick = cbCalcClick
  end
  object DataSource1: TDataSource
    DataSet = dmBase.Operation
    Left = 104
    Top = 80
  end
  object tOperations: TJvMemoryData
    Active = True
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'OPERATION_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'CASHE'
        DataType = ftFloat
      end
      item
        Name = 'TIMENORM'
        DataType = ftFloat
      end>
    Left = 456
    Top = 312
    object tOperationsID: TIntegerField
      FieldName = 'ID'
    end
    object tOperationsOPERATION_NAME: TStringField
      FieldName = 'OPERATION_NAME'
      Size = 100
    end
    object tOperationsCASHE: TFloatField
      FieldName = 'CASHE'
    end
    object tOperationsTIMENORM: TFloatField
      FieldName = 'TIMENORM'
    end
  end
  object dstOperations: TDataSource
    DataSet = tOperations
    Left = 496
    Top = 312
  end
end
