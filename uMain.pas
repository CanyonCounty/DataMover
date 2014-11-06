unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, ExtCtrls, Grids, DBGrids, TypInfo,
  ComCtrls, jpeg, DateUtils, ADODB, uDBWrapper;

type
  TfrmMain = class(TForm)
    bdeQuery: TQuery;
    Session: TSession;
    dsBDE: TDataSource;
    GroupBox1: TGroupBox;
    rbBDE: TRadioButton;
    cboBDE: TComboBox;
    lbTables: TListBox;
    GroupBox2: TGroupBox;
    memo: TMemo;
    pcMain: TPageControl;
    tsTable: TTabSheet;
    tsError: TTabSheet;
    mError: TMemo;
    DBGrid1: TDBGrid;
    tsOptions: TTabSheet;
    Label1: TLabel;
    txtSchema: TEdit;
    cbDebug: TCheckBox;
    cbNull: TCheckBox;
    tsCustom: TTabSheet;
    mCustom: TMemo;
    mHelp: TMemo;
    cbCustom: TCheckBox;
    bCustom: TButton;
    cbInsert: TCheckBox;
    cbDont: TCheckBox;
    pb: TProgressBar;
    cbOnly: TCheckBox;
    cb2008: TCheckBox;
    bGo: TButton;
    adoQuery: TADOQuery;
    bExclude: TButton;
    bInclude: TButton;
    Label3: TLabel;
    eServerName: TEdit;
    Label4: TLabel;
    eDBName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure cboBDECloseUp(Sender: TObject);
    procedure lbTablesClick(Sender: TObject);
    procedure cbDebugClick(Sender: TObject);
    procedure memoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbNullClick(Sender: TObject);
    procedure bCustomClick(Sender: TObject);
    procedure cbCustomClick(Sender: TObject);
    procedure cbInsertClick(Sender: TObject);
    procedure cb2008Click(Sender: TObject);
    procedure bGoClick(Sender: TObject);
    procedure bExcludeClick(Sender: TObject);
    procedure bIncludeClick(Sender: TObject);
  private
    { Private declarations }
    _debug: Boolean;
    _null: Boolean;
    _custom: Boolean;
    _oldIndex: Integer;
    _insert: Boolean;
    _2005: Boolean;
//    _total: Integer;
    _sl: TStringList;
    _Query: TDBWrapper;
    _exclude, _include: string;
    procedure Generate;
    procedure GetTables;
    procedure GenerateSQL(table: TDBWrapper; name, schema: string);
    procedure GenerateInsert(table: TDBWrapper; name, schema: string);
    function FieldToSQL(field: TField): string;
    procedure AddError(error: string);
    function GetCustomMapping(fieldType: string): string;
    function GetSQLInsert(field: TField): string;
    procedure SetCustom(const Value: Boolean);
    procedure SetInsert(const Value: Boolean);
    procedure AddSQL(sql: string);
    procedure ClearSQL;
    procedure SaveSQL(tablename: string);
  public
    { Public declarations }
    property Custom: Boolean read _custom write SetCustom default False;
    property Insert: Boolean read _insert write SetInsert default False;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
const
  tempdir = 'C:\Temp\DBMover\temp';
begin
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;

  Session.AddPassword('cupcdvum');
  ForceDirectories(tempdir);
  try
  Session.PrivateDir := tempdir;
  Session.NetFileDir := 'W:\';
  except
  end;
  Session.Active := True;
  Session.GetDatabaseNames(cboBDE.Items);

  _custom := False;
  _oldIndex := -2; // a value that won't exist
  _2005 := true;
  _sl := TStringList.Create;
  _Query := TDBWrapper.Create(bdeQuery, adoQuery);
end;

procedure TfrmMain.cboBDECloseUp(Sender: TObject);
begin
  Session.Active := False;
  GetTables;
  Session.Active := True;
end;

procedure TfrmMain.lbTablesClick(Sender: TObject);
begin
  Generate;
end;

procedure TfrmMain.GenerateSQL(table: TDBWrapper; name, schema: string);
var
  i: Integer;
begin
  //memo.Enabled := False;
  AddSQL('create table [' + schema + '].[' + name + '] (');
  for i := 0 to pred(pred(table.FieldCount)) do
  begin
    AddSQL(FieldToSQL(table.Fields[i]) + ',');
  end;
  AddSQL(FieldToSQL(table.Fields[pred(table.FieldCount)]));
  AddSQL(')');

  if not cbDont.Checked then
  SendMessage(memo.Handle,  { HWND of the Memo Control }
                WM_VSCROLL,    { Windows Message }
                SB_TOP,     { Scroll Command }
                0);            { Not Used }

  //memo.Enabled := True;
end;

function TfrmMain.FieldToSQL(field: TField): string;
var
  tmp, fieldType: string;
begin
  Result := '  [' + field.FieldName + '] ';
  (*
ftUnknown, ftString, ftSmallint, ftInteger, ftWord,
    ftBoolean, ftFloat, ftCurrency, ftBCD, ftDate, ftTime, ftDateTime,
    ftBytes, ftVarBytes, ftAutoInc, ftBlob, ftMemo, ftGraphic, ftFmtMemo,
    ftParadoxOle, ftDBaseOle, ftTypedBinary, ftCursor, ftFixedChar, ftWideString,
    ftLargeint, ftADT, ftArray, ftReference, ftDataSet, ftOraBlob, ftOraClob,
    ftVariant, ftInterface, ftIDispatch, ftGuid, ftTimeStamp, ftFMTBcd
  *)
  if not _custom then
  begin
    case field.DataType of
      ftString:   Result := Result + ' [varchar](' + IntToStr(field.DataSize) + ')';
      ftBytes:    Result := Result + ' [char](' + IntToStr(field.DataSize) + ')';
      ftSmallint: Result := Result + ' [smallint]';
      ftInteger:  Result := Result + ' [int]';
      ftWord:     Result := Result + ' [tinyint]';
      ftAutoInc:  Result := Result + ' [int]';
      ftBoolean:  Result := Result + ' [bit]';
      ftFloat:    Result := Result + ' [float]';
      ftCurrency: Result := Result + ' [money]';
      ftDate:     if _2005 then Result := Result + ' [datetime]' else Result := Result + ' [date]';
      ftTime:     if _2005 then Result := REsult + ' [datetime]' else Result := Result + ' [time]';
      ftDateTime: Result := Result + ' [datetime]';
      ftBlob:     Result := Result + ' [varbinary](max)';
      ftMemo:     Result := Result + ' [varchar](max)';
      ftGraphic:  Result := Result + ' [varbinary](max)';
    else
      fieldType := GetEnumName(TypeInfo(TFieldType),integer(field.DataType));
      tmp := GetCustomMapping(fieldType);
      if Trim(tmp) <> '' then
        Result := Result + StringReplace(tmp, '?', IntToStr(field.DataSize), [])
      else
        AddError('Need to add: ' + fieldType + ' Size:  ' + IntToStr(field.DataSize));
    end;
  end
  else
  begin
      fieldType := GetEnumName(TypeInfo(TFieldType),integer(field.DataType));
      tmp := GetCustomMapping(fieldType);
      if Trim(tmp) <> '' then
        Result := Result + StringReplace(tmp, '?', IntToStr(field.DataSize), [])
      else
      begin
        case field.DataType of
          ftString:   Result := Result + ' [varchar](' + IntToStr(field.DataSize) + ')';
          ftBytes:    Result := Result + ' [char](' + IntToStr(field.DataSize) + ')';
          ftSmallint: Result := Result + ' [smallint]';
          ftInteger:  Result := Result + ' [int]';
          ftWord:     Result := Result + ' [tinyint]';
          ftAutoInc:  Result := Result + ' [int]';
          ftBoolean:  Result := Result + ' [bit]';
          ftFloat:    Result := Result + ' [float]';
          ftCurrency: Result := Result + ' [money]';
          ftDate:     if _2005 then Result := Result + ' [datetime]' else Result := Result + ' [date]';
          ftTime:     if _2005 then Result := REsult + ' [datetime]' else Result := Result + ' [time]';
          ftDateTime: Result := Result + ' [datetime]';
          ftBlob:     Result := Result + ' [varbinary](max)';
          ftMemo:     Result := Result + ' [varchar](max)';
          ftGraphic:  Result := Result + ' [varbinary](max)';
        else
          AddError('Need to add: ' + fieldType + ' Size:  ' + IntToStr(field.DataSize));
        end;
      end;
  end;

  if _null then
  begin
    if field.Required then
      Result := Result + ' not null'
    else
      Result := Result + ' null';
  end;

  if _debug then
    Result := Result + ' /* ' + IntToStr(field.DataSize) + ' */';
end;

procedure TfrmMain.AddError(error: string);
begin
  mError.Lines.Add(error);
  if mError.Lines.Count > 1 then
    tsError.Caption := 'Errors';

  pcMain.ActivePage := tsError;
end;

procedure TfrmMain.cbDebugClick(Sender: TObject);
begin
  _debug := cbDebug.Checked;
  Generate;
end;

procedure TfrmMain.memoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (Key = Ord('A')) and (ssCtrl in Shift) then
   begin
     TMemo(Sender).SelectAll;
     Key := 0;
   end;
end;

procedure TfrmMain.cbNullClick(Sender: TObject);
begin
  _null := cbNull.Checked;
  Generate;
end;

procedure TfrmMain.Generate;
var
  name: string;
begin
  if lbTables.ItemIndex > -1 then
  begin
    pb.Position := 0;
    name := lbTables.Items[lbTables.ItemIndex];
    if lbTables.ItemIndex <> _oldIndex then
    begin
      _Query.Active := False;
      if not _insert then
        _Query.SQL := 'select * from "' + name + '" where 1=0'
      else
        _Query.SQL := 'select * from "' + name + '"';
      Screen.Cursor := crSQLWait;
      _Query.Active := True;
      Screen.Cursor := crDefault;
    end;

    Screen.Cursor := crHourGlass;
    if not cbDont.Checked then
      ClearSQL;
    GenerateSQL(_Query, name, txtSchema.Text);

    if _insert then
      GenerateInsert(_Query, name, txtSchema.Text);

    _oldIndex := lbTables.ItemIndex;

    // Save either the individual table, or the database script
    if not cbDont.Checked then
      SaveSQL(name)
    else
      SaveSQL(cboBDE.Items[cboBDE.ItemIndex]);
    Screen.Cursor := crDefault;
    pb.Position := 0;
  end;
end;

function TfrmMain.GetCustomMapping(fieldType: string): string;
begin
  Result := ' ' + mCustom.Lines.Values[fieldType];
end;

procedure TfrmMain.SetCustom(const Value: Boolean);
begin
  _custom := Value;
  cbCustom.Checked := Value;
end;

procedure TfrmMain.bCustomClick(Sender: TObject);
  procedure DoIt;
  begin
    mCustom.Lines.Clear;
    mCustom.Lines.Add('ftString=[varchar](?)');
    mCustom.Lines.Add('ftBytes=[char](?)');
    mCustom.Lines.Add('ftSmallint=[smallint]');
    mCustom.Lines.Add('ftInteger=[int]');
    mCustom.Lines.Add('ftWord=[tinyint]');
    mCustom.Lines.Add('ftAutoInc=[int]');
    mCustom.Lines.Add('ftBoolean=[bit]');
    mCustom.Lines.Add('ftFloat=[float]');
    mCustom.Lines.Add('ftCurrency=[money]');
    if _2005 then
    begin
      mCustom.Lines.Add('ftDate=[datetime]');
      mCustom.Lines.Add('ftTime=[datetime]');
    end
    else
    begin
      mCustom.Lines.Add('ftDate=[date]');
      mCustom.Lines.Add('ftTime=[time]');
    end;
    mCustom.Lines.Add('ftDateTime=[datetime]');
    mCustom.Lines.Add('ftBlob=[varbinary](max)');
    mCustom.Lines.Add('ftMemo=[varchar](max)');
    mCustom.Lines.Add('ftGraphic=[varbinary](max)');
    pcMain.ActivePage := tsCustom;
  end;
begin
  if mCustom.Lines.Count = 0 then
    DoIt
  else
  begin
    if MessageDlg('This will delete all custom mappings, Continue?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      DoIt;
    end;
  end;
end;

procedure TfrmMain.cbCustomClick(Sender: TObject);
begin
//  _custom := cbCustom.Checked;
//  Generate;
  SetCustom(cbCustom.Checked);
end;

procedure TfrmMain.SetInsert(const Value: Boolean);
begin
  _insert := Value;
  cbInsert.Checked := Value;
  Generate;
end;

procedure TfrmMain.cbInsertClick(Sender: TObject);
begin
  SetInsert(cbInsert.Checked);
end;

procedure TfrmMain.GenerateInsert(table: TDBWrapper; name, schema: string);
var
  col, row: Integer;
  sql, cols, values: string;
  field: TField;
  total: Integer;
begin
  AddSQL('GO');
  AddSQL('');
  _Query.DisableControls;
  total := _Query.RecordCount;
  if total < 0 then
  begin
    InputBox('Fail', 'This query failed', _Query.SQL);
    exit;
  end;
  //if total > 1 then total := 1;
  //total := 0;
  pb.Max := total;
  pb.Position := 0;
  pb.ShowHint := True;
  AddSQL('-- total records: ' + IntToStr(total));
  for col := 0 to pred(total) do
  begin
    cols := '';
    values := '';

    for row := 0 to pred(pred(_Query.FieldCount)) do
    begin
      field := _Query.Fields[row];
      cols := cols + ' [' + field.FieldName + '], ';

      values := values + GetSQLInsert(field) + ', ';
    end;

    // Don't forget the last column without a comma
    field := _Query.Fields[pred(_Query.FieldCount)];
    cols := cols + ' [' + field.FieldName + '] ';
    values := values + GetSQLInsert(field) + ' ';

    sql := 'insert into ['+ schema + '].['+ name + ']' + '(' + cols
      + ') values ( ' + values + ');';

    AddSQL(sql);
    AddSQL('GO');

    _Query.Next;
    pb.StepIt;
    pb.Hint := IntToStr(pb.Position) + ' - ' + IntToStr(pb.Max);
    Application.ProcessMessages;
  end;
  _Query.EnableControls;
end;

function TfrmMain.GetSQLInsert(field: TField): string;
  function HexToString(H: String): String;
  var I: Integer;
  begin
    Result:= '';
    for I := 1 to length (H) div 2 do
      Result:= Result+Char(StrToInt('$'+Copy(H,(I-1)*2+1,2)));
  end;

  function StringToHex(S: String): String;
  var I: Integer;
  begin
    Result:= '';
    for I := 1 to length (S) do
      Result:= Result+IntToHex(ord(S[i]),2);
  end;

  function StreamToString(Stream : TStream) : String;
  var ms : TMemoryStream;
  begin
    Result := '';
    ms := TMemoryStream.Create;
    try
      ms.LoadFromStream(Stream);
      SetString(Result,PChar(ms.memory),ms.Size);
    finally
      ms.free;
    end;
  end;

  function customStringReplace(OriginalString, Pattern, Replace: string): string;
  {-----------------------------------------------------------------------------
    Procedure: customStringReplace
    Date:      07-Feb-2002
    Arguments: OriginalString, Pattern, Replace: string
    Result:    string

    Description:
      Replaces Pattern with Replace in string OriginalString.
      Taking into account NULL (#0) characters.

      I cheated. This is ripped almost directly from Borland's
      StringReplace Function. The bug creeps in with the ANSIPos
      function. (Which does not detect #0 characters)
  -----------------------------------------------------------------------------}
  var
    SearchStr, Patt, NewStr: string;
    Offset: Integer;
  begin
    Result := '';
    SearchStr := OriginalString;
    Patt := Pattern;
    NewStr := OriginalString;

    while SearchStr <> '' do
    begin
      Offset := Pos(Patt, SearchStr); // Was AnsiPos
      if Offset = 0 then
      begin
        Result := Result + NewStr;
        Break;
      end;
      Result := Result + Copy(NewStr, 1, Offset - 1) + Replace;
      NewStr := Copy(NewStr, Offset + Length(Pattern), MaxInt);
      SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
    end;
  end;

var
  tmp: string;
  Pic : TBitmap;
  ms: TMemoryStream;
  year, month, day: Word;
begin
  if field.IsNull then
    Result := 'null'
  else
  //if field.AsString = '28' then
  //  ShowMessage('Found it!');
  case field.DataType of
    ftString, ftMemo, ftBytes:
    begin
      // Remove ticks '
      Result := '''' + StringReplace(field.AsString, '''', '''''', [rfReplaceAll]) + '''';
      // NULL's - I saw some in PermType
      Result := customStringReplace(Result, #0, '');//, [rfReplaceAll]);
    end;
    // Format Date correctly
    ftDate, ftDateTime:
      begin
        DecodeDate(field.AsDateTime, year, month, day);
        if year < 1000 then
          Result := '''' + FormatDateTime('19yy-mm-dd hh:nn:ss', field.AsDateTime) + ''''
        else
          Result := '''' + FormatDateTime('yyyy-mm-dd hh:nn:ss', field.AsDateTime) + '''';
      end;
    ftTime: Result := '''' + FormatDateTime('hh:nn:ss', field.AsDateTime) + '''';
    ftInteger, ftSmallInt, ftFloat, ftCurrency, ftAutoInc, ftWord: Result := field.AsString;
    ftBoolean:
    // The string values TRUE and FALSE can be converted to bit values:
    // TRUE is converted to 1 and FALSE is converted to 0.
      if field.AsBoolean then
        //Result := '''true'''
        Result := '''1'''
      else
        //Result := '''false''';
        Result := '''0''';
    ftBlob:
      begin
        // Get custom mapping if any?
        tmp := GetEnumName(TypeInfo(TFieldType),integer(field.DataType));
        tmp := GetCustomMapping(tmp);
        if Trim(tmp) = '' then tmp := 'varbinary(max)';
        // Don't add the 0x to the hex string C# doesn't like it
        Result := 'convert('+tmp+', ' + '''' + StringToHex(field.AsString) + ''')';
        //ShowMessage(HexToString(StringToHex(field.AsString)));
      end;
    ftGraphic:
      begin
        // Graphic is a different beast - if it goes through the blob code
        // the bmp header is messed up. I'm not sure why.
        Result := '';
        Pic := TBitmap.Create;
        try
          tmp := GetEnumName(TypeInfo(TFieldType),integer(field.DataType));
          tmp := GetCustomMapping(tmp);
          if Trim(tmp) = '' then tmp := 'varbinary(max)';
          Pic.Assign((field as TBlobField));
          ms := TMemoryStream.Create;
          try
            Pic.SaveToStream(ms);
            SetString(Result,PChar(ms.memory),ms.Size);
            Result := 'convert('+tmp+', ' + '''' + StringToHex(Result) + ''')';
          finally
            FreeAndNil(ms);
          end;
        finally
          FreeAndNil(Pic);
        end;
      end;
  else
    AddError('Insert: ' + GetEnumName(TypeInfo(TFieldType),integer(field.DataType)) + ': ' + field.AsString);
    //Result := field.AsString;
  end;
end;

procedure TfrmMain.AddSQL(sql: string);
begin
  if cbOnly.Checked then
    _sl.Add(sql)
  else
    memo.Lines.Add(sql);
end;

procedure TfrmMain.ClearSQL;
begin
  if cbOnly.Checked then
    _sl.Clear
  else
    memo.Lines.Clear;
end;

procedure TfrmMain.SaveSQL(tablename: string);
const
  tempdir = 'C:\Temp\DBMover\';
begin
  //t := GetEnvironmentVariable('TEMP');
  ForceDirectories(tempdir);

  if cbOnly.Checked then
    _sl.SaveToFile(tempdir+tablename+'.autogen.sql')
  else
    memo.Lines.SaveToFile(tempdir+tablename+'.autogen.sql');
end;

procedure TfrmMain.cb2008Click(Sender: TObject);
begin
  _2005 := not cb2008.Checked;
end;

procedure TfrmMain.bGoClick(Sender: TObject);
const
  tempdir = 'C:\Temp\DBMover\';
var
  i: Integer;
  sl: TStringList;
  name: string;
  server, db: string;
begin
  server := eServerName.Text;
  db := eDBName.Text;
  // Check Server Name
  if Trim(server) = '' then
  begin
    ShowMessage('Server Name is required - this is only used in the batch file');
    pcMain.ActivePage := tsOptions;
    eServerName.SetFocus;
    Exit;
  end;
  // Check DB Name
  if Trim(db) = '' then
  begin
    ShowMessage('DB Name is required - this is only used in the batch file');
    pcMain.ActivePage := tsOptions;
    eDBName.SetFocus;
    Exit;
  end;

  // Go through all items in the list box
  sl := TStringList.Create;
  try
    for i := 0 to pred(lbTables.Count) do
    begin
      lbTables.ItemIndex := i;
      name := lbTables.Items[lbTables.ItemIndex];
      sl.Add('sqlcmd -d ' + db + ' -H ' + server + ' -i ' + name + '.autogen.sql -o '
        + name + '.output.txt -e -b -t 65535');
      Generate;
      sl.SaveToFile(tempdir+'run.bat');
    end;
    sl.SaveToFile(tempdir+'run.bat');
  finally
    FreeAndNil(sl);
  end;
end;

procedure TfrmMain.bExcludeClick(Sender: TObject);
var
  i: Integer;
begin
  if InputQuery('Filter Tables', 'Filter the tables you would like to exclude by entering the mask below (do not include *)', _exclude) then
  begin
    if Trim(_exclude) = '' then
      GetTables
    else
    begin
      _exclude := StringReplace(_exclude, '*', '', [rfReplaceAll]);
      // if found hide it
      for i := pred(lbTables.Items.Count) downto 0 do
        if Pos(_exclude, lbTables.Items[i]) > 0 then
          lbTables.Items.Delete(i);
    end;
  end;
end;

procedure TfrmMain.GetTables;
var
  name: string;
begin
  if cboBDE.ItemIndex > -1 then
  begin
    name := cboBDE.Items[cboBDE.ItemIndex];

    //Session.Active := False;
    Session.GetTableNames(name, '', False, False, lbTables.Items);

    _Query.SetDriver(Session.GetAliasDriverName(name));
    _Query.DatabaseName := name;

    //Session.Active := True;

    _Query.Active := False;
    bGo.Enabled := lbTables.Items.Count > 0;
  end;
end;

procedure TfrmMain.bIncludeClick(Sender: TObject);
var
  i: Integer;
begin
  if InputQuery('Filter Tables', 'Filter the tables you would like to include by entering the mask below (do not include *)', _include) then
  begin
    if Trim(_include) = '' then
      GetTables
    else
    begin
      _include := StringReplace(_include, '*', '', [rfReplaceAll]);
      // if not found hide/delete it
      for i := pred(lbTables.Items.Count) downto 0 do
        if Pos(_include, lbTables.Items[i]) = 0 then
          lbTables.Items.Delete(i);
    end;
  end;
end;

end.
