object frmMain: TfrmMain
  Left = 291
  Top = 114
  AutoScroll = False
  Caption = 'Paradox to SQL Server'
  ClientHeight = 466
  ClientWidth = 954
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    954
    466)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 16
    Top = 20
    Width = 281
    Height = 269
    Caption = 'Copy From'
    TabOrder = 0
    object rbBDE: TRadioButton
      Left = 24
      Top = 24
      Width = 113
      Height = 17
      Caption = 'BDE Database'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object cboBDE: TComboBox
      Left = 28
      Top = 44
      Width = 181
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnCloseUp = cboBDECloseUp
    end
    object lbTables: TListBox
      Left = 28
      Top = 76
      Width = 181
      Height = 177
      ItemHeight = 13
      TabOrder = 2
      OnClick = lbTablesClick
    end
    object bGo: TButton
      Left = 220
      Top = 228
      Width = 51
      Height = 25
      Caption = 'Build'
      Enabled = False
      TabOrder = 3
      OnClick = bGoClick
    end
    object bExclude: TButton
      Left = 220
      Top = 80
      Width = 51
      Height = 25
      Caption = 'Exclude'
      TabOrder = 4
      OnClick = bExcludeClick
    end
    object bInclude: TButton
      Left = 220
      Top = 108
      Width = 51
      Height = 25
      Caption = 'Include'
      TabOrder = 5
      OnClick = bIncludeClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 304
    Top = 20
    Width = 633
    Height = 269
    Anchors = [akLeft, akTop, akRight]
    Caption = 'SQL'
    TabOrder = 1
    DesignSize = (
      633
      269)
    object memo: TMemo
      Left = 8
      Top = 16
      Width = 617
      Height = 245
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
      OnKeyDown = memoKeyDown
    end
  end
  object pcMain: TPageControl
    Left = 16
    Top = 296
    Width = 921
    Height = 157
    ActivePage = tsOptions
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    object tsTable: TTabSheet
      Caption = 'Table'
      object DBGrid1: TDBGrid
        Left = 4
        Top = 8
        Width = 901
        Height = 113
        DataSource = dsBDE
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
    end
    object tsError: TTabSheet
      Caption = 'Error'
      ImageIndex = 1
      DesignSize = (
        913
        129)
      object mError: TMemo
        Left = 4
        Top = 8
        Width = 901
        Height = 113
        Anchors = [akLeft, akTop, akRight, akBottom]
        ScrollBars = ssBoth
        TabOrder = 0
        OnKeyDown = memoKeyDown
      end
    end
    object tsOptions: TTabSheet
      Caption = 'Options'
      ImageIndex = 2
      object Label1: TLabel
        Left = 12
        Top = 8
        Width = 70
        Height = 13
        Caption = 'Schema Name'
      end
      object Label3: TLabel
        Left = 688
        Top = 8
        Width = 62
        Height = 13
        Caption = 'Server Name'
      end
      object Label4: TLabel
        Left = 688
        Top = 52
        Width = 77
        Height = 13
        Caption = 'Database Name'
      end
      object txtSchema: TEdit
        Left = 12
        Top = 24
        Width = 181
        Height = 21
        Hint = 'The schema you would like the table to go to'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = 'dbo'
      end
      object cbDebug: TCheckBox
        Left = 342
        Top = 26
        Width = 119
        Height = 17
        Hint = 'Adds the field size to the query'
        Caption = 'Data Size Comment'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        OnClick = cbDebugClick
      end
      object cbNull: TCheckBox
        Left = 342
        Top = 48
        Width = 97
        Height = 17
        Hint = 
          'This adds null or not null to the table create if it can determi' +
          'ne nullable fields'
        Caption = 'Null / Not Null'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        OnClick = cbNullClick
      end
      object cbCustom: TCheckBox
        Left = 342
        Top = 72
        Width = 149
        Height = 17
        Hint = 'Select this option if you don'#39't want to use the defaults'
        Caption = 'Use Custom Mapping First'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = cbCustomClick
      end
      object bCustom: TButton
        Left = 342
        Top = 92
        Width = 145
        Height = 25
        Hint = 
          'Clicking this dumps the internal mappings to the Custom Mappings' +
          ' box so you can adjust as needed'
        Caption = 'Generate Custom'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        OnClick = bCustomClick
      end
      object cbInsert: TCheckBox
        Left = 12
        Top = 100
        Width = 97
        Height = 17
        Hint = 
          'This will go through all records and generate SQL Insert stateme' +
          'nts for them'
        Caption = 'Generate Insert'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = cbInsertClick
      end
      object cbDont: TCheckBox
        Left = 12
        Top = 80
        Width = 157
        Height = 17
        Hint = 'If you want to generate one LARGE SQL script'
        Caption = 'Don'#39't Clear Generated SQL'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
      end
      object cbOnly: TCheckBox
        Left = 12
        Top = 60
        Width = 153
        Height = 17
        Hint = 
          'This option generates the SQL faster, but you will not see it in' +
          ' the SQL field above'
        Caption = 'Only Write To File'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object cb2008: TCheckBox
        Left = 342
        Top = 4
        Width = 107
        Height = 17
        Hint = 
          'By default this tool generates SQL Server 2005 compatible script' +
          's, this option uses 2008 syntax (field types)'
        Caption = 'Use 2008 Syntax'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = cb2008Click
      end
      object eServerName: TEdit
        Left = 688
        Top = 24
        Width = 165
        Height = 21
        TabOrder = 9
      end
      object eDBName: TEdit
        Left = 688
        Top = 68
        Width = 165
        Height = 21
        TabOrder = 10
      end
    end
    object tsCustom: TTabSheet
      Caption = 'Custom Mappings'
      ImageIndex = 3
      DesignSize = (
        913
        129)
      object mCustom: TMemo
        Left = 4
        Top = 8
        Width = 309
        Height = 117
        Anchors = [akLeft, akTop, akBottom]
        ScrollBars = ssVertical
        TabOrder = 0
        OnKeyDown = memoKeyDown
      end
      object mHelp: TMemo
        Left = 316
        Top = 8
        Width = 581
        Height = 117
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = clBtnFace
        Lines.Strings = (
          
            'Custom Mappings allow you to add SQL Server fields for non suppo' +
            'rted field types.'
          ''
          
            'If you get an error add the field type (displayed in the error) ' +
            'followed by an equal sign then followed by the value you '
          'would like it replaced with.'
          ''
          'For example:'
          'ftGraphic=[varbinary](max)'
          'ftString=[varchar](?)'
          ''
          
            'Note: The question mark will be replaced by the current field si' +
            'ze. Note that field types of blob have a defined size of 0 '
          '(which would not be what you want)')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
  end
  object pb: TProgressBar
    Left = 16
    Top = 456
    Width = 921
    Height = 10
    Smooth = True
    Step = 1
    TabOrder = 3
  end
  object bdeQuery: TQuery
    SessionName = 'Session_1'
    Left = 480
    Top = 64
  end
  object Session: TSession
    SessionName = 'Session_1'
    Left = 244
    Top = 176
  end
  object dsBDE: TDataSource
    Left = 244
    Top = 36
  end
  object adoQuery: TADOQuery
    Parameters = <>
    Left = 568
    Top = 64
  end
end
