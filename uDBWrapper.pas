unit uDBWrapper;

interface

uses
  DBTables, ADODB, DB, SysUtils;

type
  TDBWrapper = class(TObject)
  private
    _ado: TADOQuery;
    _bde: TQuery;
    _useBDE: Boolean;
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    function GetSQL: string;
    procedure SetSQL(const Value: string);
    function GetFieldCount: Integer;
    function GetFields: TFields;
    function GetDatabaseName: string;
    procedure SetDatabaseName(const Value: string);
    function GetRecordCount: Integer;
  public
    constructor Create(bdeQuery: TQuery; adoQuery: TADOQuery);
    procedure SetDriver(driverName: string);
    procedure DisableControls;
    procedure EnableControls;
    procedure Next;
    property Active: Boolean read GetActive write SetActive default False;
    property SQL: string read GetSQL write SetSQL;
    property FieldCount: Integer read GetFieldCount;
    property RecordCount: Integer read GetRecordCount;
    property Fields: TFields read GetFields;
    property DatabaseName: string read GetDatabaseName write SetDatabaseName;
  end;

implementation

{ TDBWrapper }

constructor TDBWrapper.Create(bdeQuery: TQuery; adoQuery: TADOQuery);
begin
  inherited Create();
  _bde := bdeQuery;
  _ado := adoQuery;
  _useBDE := True;
end;

procedure TDBWrapper.DisableControls;
begin
  if _useBDE then
    _bde.DisableControls
  else
    _ado.DisableControls;
end;

procedure TDBWrapper.EnableControls;
begin
  if _useBDE then
    _bde.EnableControls
  else
    _ado.EnableControls;
end;

function TDBWrapper.GetActive: Boolean;
begin
  if _useBDE then
    Result := _bde.Active
  else
    Result := _ado.Active;
end;

function TDBWrapper.GetDatabaseName: string;
begin
  if _useBDE then
    Result := _bde.DatabaseName
  else
    Result := _ado.ConnectionString;
end;

function TDBWrapper.GetFieldCount: Integer;
begin
  if _useBDE then
    Result := _bde.FieldCount
  else
    Result := _ado.FieldCount;
end;

function TDBWrapper.GetFields: TFields;
begin
  if _useBDE then
    Result := _bde.Fields
  else
    Result := _ado.Fields;
end;

function TDBWrapper.GetRecordCount: Integer;
begin
  if _useBDE then
    Result := _bde.RecordCount
  else
    Result := _ado.RecordCount;
end;

function TDBWrapper.GetSQL: string;
begin
  if _useBDE then
    Result := _bde.SQL.Text
  else
    Result := _ado.SQL.Text;
end;

procedure TDBWrapper.Next;
begin
  if _useBDE then
    _bde.Next
  else
    _ado.Next;
end;

procedure TDBWrapper.SetActive(const Value: Boolean);
begin
  if _useBDE then
    _bde.Active := Value
  else
    _ado.Active := Value;
end;

procedure TDBWrapper.SetDatabaseName(const Value: string);
begin
  if _useBDE then
    _bde.DatabaseName := Value
  else
    _ado.ConnectionString :=
    'Provider=MSDASQL.1;Persist Security Info=False;Data Source=' + Value;//CCT_CCPOINTSYNC'
    //+ 'User ID=dba; Password=rp4dba1475924012210;';
end;

procedure TDBWrapper.SetDriver(driverName: string);
begin
  if UpperCase(driverName) = 'STANDARD' then
    _useBDE := True
  else
    _useBDE := False;
end;

procedure TDBWrapper.SetSQL(const Value: string);
begin
  if _useBDE then
    _bde.SQL.Text := Value
  else
    _ado.SQL.Text := Value;
end;

end.
