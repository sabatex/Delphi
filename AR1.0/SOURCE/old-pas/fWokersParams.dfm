object frmWokersParams: TfrmWokersParams
  Left = 335
  Top = 189
  Width = 478
  Height = 240
  Caption = 'frmWokersParams'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poDefault
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  inline frCustomGrid1: TfrCustomGrid
    Left = 0
    Top = 0
    Width = 470
    Height = 213
    Align = alClient
    Constraints.MinWidth = 232
    TabOrder = 0
    inherited DBGridEh: TDBGridEh
      Width = 470
      Height = 188
      DataSource = dmFunction.dsWokers
      Columns = <
        item
          EditButtons = <>
          FieldName = 'EDRPOU'
          Footers = <>
        end
        item
          EditButtons = <>
          FieldName = 'NAME'
          Footers = <>
          Title.Caption = #1055'.'#1030'.'#1041'.'
        end>
    end
    inherited Panel1: TPanel
      Width = 470
      inherited DBNavigator1: TDBNavigator
        Hints.Strings = ()
      end
    end
  end
end
