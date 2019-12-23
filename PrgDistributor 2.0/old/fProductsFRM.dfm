inherited frmProductsV: TfrmProductsV
  Left = 381
  Top = 208
  Width = 539
  Height = 381
  Caption = 'frmProducts'
  PixelsPerInch = 96
  TextHeight = 13
  object fcDBTreeView1: TfcDBTreeView
    Left = 0
    Top = 0
    Width = 531
    Height = 354
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
    object N1: TMenuItem
      Action = frmMain.AddProduct
    end
    object N2: TMenuItem
      Action = frmMain.AddVersionWithNewKey
    end
    object N3: TMenuItem
      Action = frmMain.AddVersionWithPreviosKey
    end
    object N4: TMenuItem
      Action = frmMain.aEditProduct
    end
    object N5: TMenuItem
      Action = frmMain.DeleteVersion
    end
    object N6: TMenuItem
      Action = frmMain.PayProgramm
    end
  end
  object dsPROGRAMM_PRODUCT: TDataSource
    DataSet = dmFunction.PROGRAMM_PRODUCT
    Left = 280
    Top = 280
  end
  object dsVERSION_PRODUCTS: TDataSource
    DataSet = dmFunction.VERSION_PRODUCTS
    Left = 320
    Top = 280
  end
end
