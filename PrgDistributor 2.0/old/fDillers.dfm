object frDillers: TfrDillers
  Left = 285
  Top = 210
  Width = 367
  Height = 223
  Caption = 'frDillers'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 18
    Width = 359
    Height = 178
    Align = alClient
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'ID'
        ReadOnly = True
        Title.Caption = #8470
        Width = 28
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DillerName'
        Title.Caption = #1044#1080#1083#1083#1077#1088
        Visible = True
      end>
  end
  object DBNavigator1: TDBNavigator
    Left = 0
    Top = 0
    Width = 359
    Height = 18
    Align = alTop
    TabOrder = 1
  end
end
