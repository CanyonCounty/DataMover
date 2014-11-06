object frmMain: TfrmMain
  Left = 218
  Top = 162
  AutoScroll = False
  Caption = 'BDE DBMover'
  ClientHeight = 468
  ClientWidth = 954
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    954
    468)
  PixelsPerInch = 96
  TextHeight = 13
  object lblHint: TLabel
    Left = 16
    Top = 448
    Width = 19
    Height = 13
    Caption = 'Hint'
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 8
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
      Enabled = False
      TabOrder = 4
      OnClick = bExcludeClick
    end
    object bInclude: TButton
      Left = 220
      Top = 108
      Width = 51
      Height = 25
      Caption = 'Include'
      Enabled = False
      TabOrder = 5
      OnClick = bIncludeClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 304
    Top = 8
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
    Top = 288
    Width = 921
    Height = 159
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
        131)
      object mError: TMemo
        Left = 4
        Top = 8
        Width = 901
        Height = 115
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
        Left = 648
        Top = 8
        Width = 62
        Height = 13
        Caption = 'Server Name'
      end
      object Label4: TLabel
        Left = 648
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
        ShowHint = False
        TabOrder = 0
        Text = 'dbo'
      end
      object cbDebug: TCheckBox
        Left = 306
        Top = 40
        Width = 119
        Height = 17
        Hint = 'Adds the field size to the query'
        Caption = 'Data Size Comment'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 5
        OnClick = cbDebugClick
      end
      object cbNull: TCheckBox
        Left = 306
        Top = 60
        Width = 97
        Height = 17
        Hint = 
          'This adds null or not null to the table create if it can determi' +
          'ne nullable fields'
        Caption = 'Null / Not Null'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 6
        OnClick = cbNullClick
      end
      object cbCustom: TCheckBox
        Left = 306
        Top = 80
        Width = 149
        Height = 17
        Hint = 'Select this option if you don'#39't want to use the defaults'
        Caption = 'Use Custom Mapping First'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 7
        OnClick = cbCustomClick
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
        ShowHint = False
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
        ShowHint = False
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
        ShowHint = False
        TabOrder = 1
      end
      object cb2008: TCheckBox
        Left = 306
        Top = 20
        Width = 107
        Height = 17
        Hint = 
          'By default this tool generates SQL Server 2005 compatible script' +
          's, this option uses 2008 syntax (field types)'
        Caption = 'Use 2008 Syntax'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 4
        OnClick = cb2008Click
      end
      object eServerName: TEdit
        Left = 648
        Top = 24
        Width = 165
        Height = 21
        Hint = 'SQL Server Name (only needed if you use the build button)'
        TabOrder = 11
      end
      object eDBName: TEdit
        Left = 648
        Top = 68
        Width = 165
        Height = 21
        Hint = 
          'SQL Server Database Name (only needed if you use the build butto' +
          'n)'
        TabOrder = 12
      end
      object cbPrePost: TCheckBox
        Left = 648
        Top = 100
        Width = 125
        Height = 17
        Hint = 
          'Creates a Preflight and Postfilght scripts (only used if you use' +
          ' the build button) - will NOT be overwritten if it already exist' +
          's'
        Caption = 'Create Pre/Postflight'
        TabOrder = 13
      end
      object cbNoSchema: TCheckBox
        Left = 306
        Top = 100
        Width = 199
        Height = 17
        Hint = 'Only Generates insert statements (no create)'
        Caption = 'Don'#39't Generate Schema (Insert Only)'
        TabOrder = 8
      end
      object cbPNG: TCheckBox
        Left = 532
        Top = 20
        Width = 97
        Height = 17
        Hint = 'This will convert bitmap images to png images'
        Caption = 'BMP to PNG'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 9
      end
      object rgBinary: TRadioGroup
        Left = 532
        Top = 44
        Width = 97
        Height = 73
        Hint = 
          'Convert will add the convert method call - 0x + Hex will convert' +
          ' the string to Hex and append 0x (necessary for Paradox) - Just ' +
          'Hex will just convert the binary data to hex'
        Caption = 'Binary Convert'
        Items.Strings = (
          'Convert'
          '0x + Hex'
          'Just Hex')
        ParentShowHint = False
        ShowHint = False
        TabOrder = 10
      end
      object cbOutput: TCheckBox
        Left = 780
        Top = 100
        Width = 109
        Height = 17
        Hint = 
          'This will create output files for each generated script (sqlcmd ' +
          '-o option)'
        Caption = 'Generate Output'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 14
      end
      object cbSort: TCheckBox
        Left = 306
        Top = 0
        Width = 183
        Height = 17
        Hint = 'Sort the column names (handy for doing a table compare)'
        Caption = 'Sort Column Names (Create Only)'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 15
        OnClick = cbSortClick
      end
    end
    object tsCustom: TTabSheet
      Caption = 'Custom Mappings'
      ImageIndex = 3
      DesignSize = (
        913
        131)
      object mCustom: TMemo
        Left = 4
        Top = 8
        Width = 309
        Height = 119
        Anchors = [akLeft, akTop, akBottom]
        ScrollBars = ssVertical
        TabOrder = 0
        OnKeyDown = memoKeyDown
      end
      object mHelp: TMemo
        Left = 316
        Top = 8
        Width = 581
        Height = 119
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
      object bCustom: TButton
        Left = 726
        Top = 92
        Width = 145
        Height = 25
        Hint = 
          'Clicking this dumps the internal mappings to the Custom Mappings' +
          ' box so you can adjust as needed'
        Caption = 'Generate Custom'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 2
        OnClick = bCustomClick
      end
    end
  end
  object pb: TProgressBar
    Left = 16
    Top = 448
    Width = 921
    Height = 13
    Smooth = True
    Step = 1
    TabOrder = 3
    Visible = False
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
