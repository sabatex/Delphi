object frmNewProduct: TfrmNewProduct
  Left = 409
  Top = 234
  Width = 406
  Height = 172
  Caption = 'frmNewProduct'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 87
    Height = 13
    Caption = #1053#1072#1079#1074#1072' '#1087#1088#1086#1075#1088#1072#1084#1080':'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 36
    Height = 13
    Caption = #1042#1077#1088#1089#1110#1103':'
  end
  object Label3: TLabel
    Left = 8
    Top = 64
    Width = 40
    Height = 13
    Caption = 'Source :'
  end
  object Product: TDBEdit
    Left = 108
    Top = 5
    Width = 285
    Height = 21
    DataField = 'PRODUCT_NAME'
    DataSource = dsPROGRAMM_PRODUCT
    TabOrder = 0
  end
  object DBEdit2: TDBEdit
    Left = 108
    Top = 32
    Width = 121
    Height = 21
    DataField = 'VERSION_PRG'
    DataSource = dsVERSION_PRODUCTS
    TabOrder = 1
  end
  object Button1: TButton
    Left = 240
    Top = 112
    Width = 75
    Height = 25
    Caption = #1047#1073#1077#1088#1077#1075#1090#1080
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 320
    Top = 112
    Width = 75
    Height = 25
    Caption = #1042#1110#1076#1084#1110#1085#1080#1090#1080
    TabOrder = 3
    OnClick = Button2Click
  end
  object SourcePath: TDBEditEh
    Left = 109
    Top = 57
    Width = 284
    Height = 21
    DataField = 'SOURCE_PATH'
    DataSource = dsVERSION_PRODUCTS
    EditButtons = <
      item
        Style = ebsEllipsisEh
        OnClick = SourcePathEditButtons0Click
      end>
    TabOrder = 4
    Visible = True
  end
  object SaveDialog1: TSaveDialog
    FileName = 'enKey.pas'
    Filter = 'Key File|*.pas'
    Title = #1042#1080#1073#1110#1088' '#1088#1086#1079#1090#1072#1096#1091#1074#1072#1085#1085#1103' '#1092#1072#1081#1083#1091' '#1079' '#1082#1083#1102#1095#1072#1084#1080
    Left = 48
    Top = 88
  end
  object dsPROGRAMM_PRODUCT: TDataSource
    DataSet = dmBase.PROGRAMM_PRODUCT
    Left = 168
    Top = 112
  end
  object dsVERSION_PRODUCTS: TDataSource
    DataSet = dmBase.VERSION_PRODUCTS
    Left = 200
    Top = 112
  end
end
