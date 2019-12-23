object frmProductList: TfrmProductList
  Left = 240
  Top = 144
  Width = 517
  Height = 480
  Caption = 'frmProductList'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object fcDBTreeView1: TfcDBTreeView
    Left = 0
    Top = 0
    Width = 509
    Height = 453
    Align = alClient
    BorderStyle = bsSingle
    TabOrder = 0
    DataSources = 'dsPROGRAMM_PRODUCT;dsVERSION_PRODUCTS'
    DisplayFields.Strings = (
      '"PRODUCT_NAME" ("COUNT_PROD")'
      '"VERSION_PRG"  ("COUNT_PROD")')
    LevelIndent = 19
    PopupMenu = PopupMenu1
  end
  object PopupMenu1: TPopupMenu
    Left = 240
    Top = 280
    object N5: TMenuItem
      Action = dmMain.aAddProgramm
    end
    object N2: TMenuItem
      Action = dmMain.aNewVersionWithNewKey
    end
    object N3: TMenuItem
      Action = dmMain.aNewVersionWithOldKey
    end
    object N4: TMenuItem
      Action = dmMain.aEditCurrentVersion
    end
    object N1: TMenuItem
      Action = dmMain.aPayProgramm
    end
    object N6: TMenuItem
    end
  end
  object dsPROGRAMM_PRODUCT: TDataSource
    DataSet = dmBase.PROGRAMM_PRODUCT
    Left = 280
    Top = 280
  end
  object dsVERSION_PRODUCTS: TDataSource
    DataSet = dmBase.VERSION_PRODUCTS
    Left = 320
    Top = 280
  end
end
