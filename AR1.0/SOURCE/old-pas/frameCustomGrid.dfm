object frCustomGrid: TfrCustomGrid
  Left = 0
  Top = 0
  Width = 365
  Height = 329
  Constraints.MinWidth = 232
  TabOrder = 0
  object DBGridEh: TDBGridEh
    Left = 0
    Top = 25
    Width = 365
    Height = 304
    Align = alClient
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
    OnSortMarkingChanged = DBGridEhSortMarkingChanged
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 365
    Height = 25
    Align = alTop
    TabOrder = 1
    object SpeedButton1: TSpeedButton
      Left = 238
      Top = 2
      Width = 23
      Height = 22
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C00000000000000000000000000000000000000000000
        1F7C1F7C1F7C1F7C000018631863186318631863186318631863186300001863
        00001F7C1F7C0000000000000000000000000000000000000000000000000000
        186300001F7C0000186318631863186318631863E07FE07FE07F186318630000
        000000001F7C0000186318631863186318631863104210421042186318630000
        186300001F7C0000000000000000000000000000000000000000000000000000
        1863186300000000186318631863186318631863186318631863186300001863
        0000186300001F7C000000000000000000000000000000000000000018630000
        1863000000001F7C1F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001863
        0000186300001F7C1F7C1F7C00001F7C000000000000000000001F7C00000000
        000000001F7C1F7C1F7C1F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C000000000000000000001F7C0000
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        00001F7C1F7C1F7C1F7C1F7C1F7C1F7C00000000000000000000000000000000
        00001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C}
      OnClick = SpeedButton1Click
    end
    object DBNavigator1: TDBNavigator
      Left = 0
      Top = 0
      Width = 230
      Height = 25
      TabOrder = 0
    end
  end
  object PrintDBGridEh: TPrintDBGridEh
    DBGridEh = DBGridEh
    Options = []
    Page.BottomMargin = 2
    Page.LeftMargin = 2
    Page.RightMargin = 2
    Page.TopMargin = 2
    PageFooter.Font.Charset = DEFAULT_CHARSET
    PageFooter.Font.Color = clWindowText
    PageFooter.Font.Height = -11
    PageFooter.Font.Name = 'MS Sans Serif'
    PageFooter.Font.Style = []
    PageHeader.Font.Charset = DEFAULT_CHARSET
    PageHeader.Font.Color = clWindowText
    PageHeader.Font.Height = -11
    PageHeader.Font.Name = 'MS Sans Serif'
    PageHeader.Font.Style = []
    Title.Strings = (
      #1055#1077#1095#1072#1090#1100' '#1090#1077#1082#1091#1097#1077#1081' '#1090#1072#1073#1083#1080#1094#1099)
    Units = MM
    Left = 72
    Top = 152
  end
end
