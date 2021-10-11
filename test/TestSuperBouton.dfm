object Form1: TForm1
  Left = 349
  Top = 217
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Win Essential'
  ClientHeight = 217
  ClientWidth = 347
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 161
    Height = 25
    Caption = 'Enable/Disable Button'
    TabOrder = 0
    OnClick = Button1Click
  end
  object TreeView1: TTreeView
    Left = 176
    Top = 8
    Width = 161
    Height = 201
    Indent = 19
    TabOrder = 1
    Items.Data = {
      030000001F0000000000000000000000FFFFFFFFFFFFFFFF0000000000000000
      064974656D20311F0000000000000000000000FFFFFFFFFFFFFFFF0000000000
      000000064974656D20321F0000000000000000000000FFFFFFFFFFFFFFFF0000
      000000000000064974656D2033}
  end
  object PopupMenu1: TPopupMenu
    Left = 184
    Top = 16
    object cvbc1: TMenuItem
      Caption = 'cvbc'
    end
    object xx1: TMenuItem
      Caption = 'xx'
    end
    object N1: TMenuItem
      Caption = 'ccc'
    end
    object nnn1: TMenuItem
      Caption = 'nnn'
    end
  end
end
