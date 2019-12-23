object frmFirms: TfrmFirms
  Left = 355
  Top = 131
  Width = 381
  Height = 372
  Caption = 'frmFirms'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object dxDBTreeView1: TdxDBTreeView
    Left = 0
    Top = 0
    Width = 373
    Height = 345
    ShowNodeHint = True
    DataSource = dsFirms
    DisplayField = 'COMPANY_NAME'
    KeyField = 'ID'
    ListField = 'COMPANY_NAME'
    ParentField = 'ID'
    RootValue = '0'
    SeparatedSt = ' - '
    RaiseOnError = True
    Indent = 19
    Align = alClient
    ParentColor = False
    Options = [trDBCanDelete, trDBConfirmDelete, trCanDBNavigate, trSmartRecordCopy, trCheckHasChildren]
    SelectedIndex = -1
    TabOrder = 0
    PopupMenu = PopupMenu1
  end
  object PopupMenu1: TPopupMenu
    Left = 24
    Top = 24
    object N1: TMenuItem
      Action = frmMain.ANewFirms
    end
    object N2: TMenuItem
      Action = frmMain.DeleteFirm
    end
  end
  object dsFirms: TDataSource
    DataSet = dmFunction.FIRMS
    Left = 64
    Top = 24
  end
end
