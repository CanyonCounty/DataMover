unit uOptions;

// I got tired of remembering which options I've selected

interface

uses Classes;

type
  TOptions = class(TComponent)
  private
    fFileName: string;
    fSchemaName: string;
    fOnlyWriteFile: Boolean;
    fNullNotNull: Boolean;
    fUseCustomMappingFirst: Boolean;
    fDataSizeComment: Boolean;
    fUse2008Syntax: Boolean;
    fDontClearSQL: Boolean;
    fBMPToPNG: Boolean;
    fInsertOnly: Boolean;
    FBinaryConvert: Integer;
    fCreatePrePostflight: Boolean;
    fDatabaseName: string;
    fServerName: string;
    fInclude: string;
    fExclude: string;
    fCustomMappings: TStrings;
    fGenerateInsert: Boolean;
    fGenerateOutput: Boolean;
    fSortCreate: Boolean;
    procedure SetBinaryConvert(const Value: Integer);
    procedure SetCustomMappings(const Value: TStrings);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadConfig(FileName: string);
    procedure SaveConfig;
  published
    property SchemaName: string read fSchemaName write fSchemaName;
    property OnlyWriteFile: Boolean read fOnlyWriteFile write fOnlyWriteFile;
    property DontClearSQL: Boolean read fDontClearSQL write fDontClearSQL;
    property GenerateInsert: Boolean read fGenerateInsert write fGenerateInsert;
    property Use2008Syntax: Boolean read fUse2008Syntax write fUse2008Syntax;
    property DataSizeComment: Boolean read fDataSizeComment write fDataSizeComment;
    property NullNotNull: Boolean read fNullNotNull write fNullNotNull;
    property UseCustomMappingFirst: Boolean read fUseCustomMappingFirst write fUseCustomMappingFirst;
    property InsertOnly: Boolean read fInsertOnly write fInsertOnly;
    property BMPToPNG: Boolean read fBMPToPNG write fBMPToPNG;
    property BinaryConvert: Integer read FBinaryConvert write SetBinaryConvert;
    property ServerName: string read fServerName write fServerName;
    property DatabaseName: string read fDatabaseName write fDatabaseName;
    property CreatePrePostflight: Boolean read fCreatePrePostflight write fCreatePrePostflight;
    property Exclude: string read fExclude write fExclude;
    property Include: string read fInclude write fInclude;
    property CustomMappings: TStrings read fCustomMappings write SetCustomMappings;
    property GenerateOutput: Boolean read fGenerateOutput write fGenerateOutput;
    property SortCreate: Boolean read fSortCreate write fSortCreate;
  end;

var
  Options: TOptions;

implementation

uses SysUtils{ExtractFilePath};

function StringToComponent(Source: String):TComponent;
var
  BinStream:TMemoryStream;
  StrStream: TStringStream;
begin
  StrStream := TStringStream.Create(source);
  try
    BinStream := TMemoryStream.Create;
    try
      Strstream.Seek(0, sofrombeginning);
      ObjectTextToBinary(strStream,binStream);
      BinStream.Seek(0, soFromBeginning);
      Result := BinStream.ReadComponent(Options);
    finally
      BinStream.Free
    end;
  finally
    StrStream.Free;
  end;
end;

function ComponentToString(Component: TComponent): string;
var
  BinStream:TMemoryStream;
  StrStream: TStringStream;
  s: string;
begin
  BinStream := TMemoryStream.Create;
  try
    StrStream := TStringStream.Create(s);
    try
      BinStream.WriteComponent(Component);
      BinStream.Seek(0, soFromBeginning);
      ObjectBinaryToText(BinStream, StrStream);
      StrStream.Seek(0, soFromBeginning);
      Result:= StrStream.DataString;
    finally
      StrStream.Free;
    end;
  finally
    BinStream.Free
  end;
end;


{ TOptions }

constructor TOptions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fCustomMappings := TStringList.Create;
  fFileName := ExtractFilePath(ParamStr(0)) + 'DBMover.dat';
  fSchemaName := 'dbo';
end;

destructor TOptions.Destroy;
begin
  SaveConfig;
  FreeAndNil(fCustomMappings);
  inherited Destroy;
end;

procedure TOptions.ReadConfig(FileName: string);
begin
  //fFileName := ChangeFileExt(FileName, '.dat');
  if FileExists(fFileName) then
    Self := TOptions(ReadComponentResFile(fFileName, Self));
  if (Self = nil) then beep;
end;

procedure TOptions.SaveConfig;
begin
  WriteComponentResFile(fFileName, Self);
end;

procedure TOptions.SetBinaryConvert(const Value: Integer);
begin
  FBinaryConvert := Value;
  if fBinaryConvert > 2 then
    fBinaryConvert := 0;
end;

procedure TOptions.SetCustomMappings(const Value: TStrings);
begin
  fCustomMappings.Assign(Value);
end;

initialization
  Options := TOptions.Create(nil);
  Options.ReadConfig('notused');

finalization
  FreeAndNil(Options);

end.
