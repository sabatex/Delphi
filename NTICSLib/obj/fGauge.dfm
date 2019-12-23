object frmGauge: TfrmGauge
  Left = 377
  Top = 271
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'frmGauge'
  ClientHeight = 36
  ClientWidth = 371
  Color = clBtnFace
  Constraints.MaxHeight = 63
  Constraints.MaxWidth = 379
  Constraints.MinHeight = 63
  Constraints.MinWidth = 379
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 371
    Height = 36
    Align = alClient
    TabOrder = 0
    object Gauge: TProgressBar
      Left = 1
      Top = 1
      Width = 369
      Height = 34
      Align = alClient
      Min = 0
      Max = 100
      Smooth = True
      Step = 1
      TabOrder = 0
    end
  end
end
