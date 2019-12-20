object frmFirms: TfrmFirms
  Left = 356
  Top = 253
  Width = 408
  Height = 267
  Caption = 'frmFirms'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inline frCustomGrid1: TfrCustomGrid
    Left = 0
    Top = 0
    Width = 400
    Height = 240
    Align = alClient
    Constraints.MinWidth = 232
    TabOrder = 0
    inherited Panel1: TPanel
      Width = 400
      inherited DBNavigator1: TDBNavigator
        DataSource = dsFirms
        Hints.Strings = ()
      end
    end
    inherited DBGridEh: TDBGridEh
      Width = 400
      Height = 215
      DataSource = dsFirms
      Columns = <
        item
          EditButtons = <>
          FieldName = 'COMPANY_NAME'
          Footers = <>
          Title.Caption = #1060#1080#1088#1084#1072
          Title.TitleButton = True
        end>
    end
  end
  object dsFirms: TDataSource
    DataSet = dmFunction.Firms
    Left = 264
    Top = 176
  end
end
