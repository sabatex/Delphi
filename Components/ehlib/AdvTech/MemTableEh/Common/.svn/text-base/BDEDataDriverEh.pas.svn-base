{*******************************************************}
{                                                       }
{                     EhLib vX.X                        }
{                                                       }
{          TBDEDataDriverEh component (Build 14)        }
{                                                       }
{      Copyright (c) 2003,04 by Dmitry V. Bolshakov     }
{                                                       }
{*******************************************************}

unit BDEDataDriverEh {$IFDEF CIL} platform{$ENDIF};

{$I EHLIB.INC}

interface

uses Windows, SysUtils, Classes, Controls, DB,
{$IFDEF EH_LIB_6} Variants, {$ENDIF}
{$IFDEF EH_LIB_5} Contnrs, {$ENDIF}
  ToolCtrlsEh, DBCommon, MemTableDataEh, DataDriverEh, DBTables;
type

  TBDEDataDriverEh = class;

{ TBDECommandEh }

  TBDECommandEh = class(TBaseSQLCommandEh)
  private
    function GetDataDriver: TBDEDataDriverEh;
  public
    function Execute(var Cursor: TDataSet; var FreeOnEof: Boolean): Integer; override;
    property DataDriver: TBDEDataDriverEh read GetDataDriver;
  published
    property Params;
    property ParamCheck;
    property CommandText;
    property CommandType;
  end;

{ TBDEDataDriverEh }

  TBDEDataDriverEh = class(TBaseSQLDataDriverEh)
  private
    FDatabaseName: string;
    FSessionName: string;
    function GetDBSession: TSession;
    procedure SetDatabaseName(const Value: string);
    procedure SetSessionName(const Value: string);
  protected
    function CreateSelectCommand: TCustomSQLCommandEh; override;
    function CreateUpdateCommand: TCustomSQLCommandEh; override;
    function CreateInsertCommand: TCustomSQLCommandEh; override;
    function CreateDeleteCommand: TCustomSQLCommandEh; override;
    function CreateGetrecCommand: TCustomSQLCommandEh; override;
    procedure SetAutoIncFields(Fields: TFields; DataStruct: TMTDataStructEh); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CreateDesignCopy: TCustomSQLDataDriverEh; override;
    function HaveDataConnection(): Boolean; override;
    procedure GetBackUpdatedValues(MemRec: TMemoryRecordEh; Command: TCustomSQLCommandEh; ResDataSet: TDataSet); override;
    procedure DoServerSpecOperations(MemRec: TMemoryRecordEh; Command: TCustomSQLCommandEh; ResDataSet: TDataSet); virtual;
    property DBSession: TSession read GetDBSession;
    property SessionName: string read FSessionName write SetSessionName;
  published
    property DatabaseName: string read FDatabaseName write SetDatabaseName;
    property SelectCommand;
    property SelectSQL;
    property UpdateCommand;
    property UpdateSQL;
    property InsertCommand;
    property InsertSQL;
    property DeleteCommand;
    property DeleteSQL;
    property GetrecCommand;
    property GetrecSQL;
    property ProviderDataSet;
    property KeyFields;
    property SpecParams;

    property OnExecuteCommand;
    property OnBuildDataStruct;
    property OnGetBackUpdatedValues;
    property OnProduceDataReader;
    property OnAssignFieldValue;
    property OnReadRecord;
    property OnRefreshRecord;
    property OnUpdateRecord;
    property OnAssignCommandParam;
    property OnUpdateError;
  end;

function DefaultExecuteBDECommandEh(SQLDataDriver: TCustomSQLDataDriverEh;
    Command: TCustomSQLCommandEh; var Cursor: TDataSet; var FreeOnEof: Boolean;
    var Processed: Boolean; ADatabaseName: String): Integer;

implementation

uses
{$IFDEF CIL}
  System.Text,
{$ENDIF}
  BDE;

function DefaultExecuteBDECommandEh(SQLDataDriver: TCustomSQLDataDriverEh;
    Command: TCustomSQLCommandEh; var Cursor: TDataSet; var FreeOnEof: Boolean;
    var Processed: Boolean; ADatabaseName: String): Integer;
var
  ACursor: TDataSet;
begin
  Result := -1;
  Cursor := nil;
  FreeOnEof := False;
  ACursor := nil;
  Processed := True;
  try
    case Command.CommandType of
      cthSelectQuery, cthUpdateQuery:
        begin
          ACursor := TQuery.Create(nil);
          with ACursor as TQuery do
          begin
            DatabaseName := ADatabaseName;
            SQL := Command.CommandText;
            Params := TBaseSQLCommandEh(Command).Params;
            if Command.CommandType = cthSelectQuery then
              Open
            else
            begin
              ExecSQL;
              Result := RowsAffected;
            end;
            TBaseSQLCommandEh(Command).Params := Params;
          end;
        end;
      cthTable:
        begin
          ACursor := TTable.Create(nil);
          with ACursor as TTable do
          begin
            DatabaseName := ADatabaseName;
            TableName := Command.CommandText.Text;
//            Parameters.Assign(TBaseSQLCommandEh(Command).Params);
            Open;
//            TBaseSQLCommandEh(Command).Params.Assign(Parameters);
          end;
        end;
      cthStoredProc:
        begin
          ACursor := TStoredProc.Create(nil);
          with ACursor as TStoredProc do
          begin
            DatabaseName := ADatabaseName;
            StoredProcName := Command.CommandText.Text;
            Params := TBaseSQLCommandEh(Command).Params;
            ExecProc;
//??            Result := RowsAffected;
            TBaseSQLCommandEh(Command).Params := Params;
          end;
        end;
    end;
    if ACursor.Active then
    begin
      Cursor := ACursor;
      FreeOnEof := True;
      ACursor := nil;
    end
  finally
    if ACursor <> nil then
      ACursor.Free;
  end;
end;

{ TBDECommandEh }

function TBDECommandEh.Execute(var Cursor: TDataSet; var FreeOnEof: Boolean): Integer;
var
  ACursor: TDataSet;
begin
  Result := -1;
  Cursor := nil;
  FreeOnEof := False;
  ACursor := nil;
  try
    case CommandType of
      cthSelectQuery, cthUpdateQuery:
        begin
          ACursor := TQuery.Create(nil);
          with ACursor as TQuery do
          begin
            DataBaseName := DataDriver.DatabaseName;
            SQL := Self.CommandText;
            Params := Self.Params;
            if CommandType = cthSelectQuery then
              Open
            else
            begin
              ExecSQL;
              Result := RowsAffected;
            end;
            Self.Params := Params;
          end;
        end;
      cthTable:
        begin
          ACursor := TTable.Create(nil);
          with ACursor as TTable do
          begin
            DataBaseName := DataDriver.DatabaseName;
            TableName := Self.CommandText.Text;
            Params := Self.Params;
            Open;
            Self.Params := Params;
          end;
        end;
      cthStoredProc:
        begin
          ACursor := TStoredProc.Create(nil);
          with ACursor as TStoredProc do
          begin
            DataBaseName := DataDriver.DatabaseName;
            StoredProcName := Self.CommandText.Text;
            Params := Self.Params;
            ExecProc;
//??            Result := RowsAffected;
            Self.Params := Params;
          end;
        end;
    end;
    if ACursor.Active then
    begin
      Cursor := ACursor;
      FreeOnEof := True;
      ACursor := nil;
    end
  finally
    if ACursor <> nil then
      ACursor.Free;
  end;
end;

function TBDECommandEh.GetDataDriver: TBDEDataDriverEh;
begin
  Result := TBDEDataDriverEh(inherited DataDriver);
end;

{ TBDEDataDriverEh }

(*
var
  DataBaseInc: Integer = 0;

function GetUnicalDataBaseName: String;
begin
  Inc(DataBaseInc);
  Result := 'BDEDataDriverEhDataBaseName' + IntToStr(DataBaseInc);
end;
*)

constructor TBDEDataDriverEh.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBDEDataDriverEh.Destroy;
begin
  inherited Destroy;
end;

function TBDEDataDriverEh.CreateDesignCopy: TCustomSQLDataDriverEh;
begin
  Result := TBDEDataDriverEh.Create(nil);
  Result.SelectCommand := SelectCommand;
  Result.UpdateCommand := UpdateCommand;
  Result.InsertCommand := InsertCommand;
  Result.DeleteCommand := DeleteCommand;
  Result.GetrecCommand := GetrecCommand;
//  TBDEDataDriverEh(Result).DatabaseName :=
//   (DesignDataBase as IBDEDesignDataBaseEh).GetDataBase.DatabaseName;
end;

type
  TDBDescription = record
    szName          : String;          { Logical name (Or alias) }
    szText          : String;          { Descriptive text }
    szPhyName       : String;          { Physical name/path }
    szDbType        : String;          { Database type }
  end;

{$IFDEF CIL}
function StrToOem(const AnsiStr: string): string;
var
  Len: Cardinal;
  Buffer: StringBuilder;
begin
  Len := Length(AnsiStr);
  if Len > 0 then
  begin
    Buffer := StringBuilder.Create(Len);
    CharToOemA(AnsiStr, Buffer);
    Result := Buffer.ToString;
  end;
end;
{$ELSE}
function StrToOem(const AnsiStr: string): string;
begin
  SetLength(Result, Length(AnsiStr));
  if Length(Result) > 0 then
    CharToOem(PChar(AnsiStr), PChar(Result));
end;
{$ENDIF}

function GetDatabaseDesc(DBName: String; var Description: TDBDescription): Boolean;
var
  Desc: DBDesc;
begin
  Result := False;
{$IFDEF CIL}
  if DbiGetDatabaseDesc(StrToOem(DBName), Desc) <> 0 then Exit;
{$ELSE}
  if DbiGetDatabaseDesc(PChar(StrToOem(DBName)), @Desc) <> 0 then Exit;
{$ENDIF}
  Description.szName := Desc.szName;
  Description.szText := Desc.szText;
  Description.szPhyName := Desc.szPhyName;
  Description.szDbType := Desc.szDbType;
  Result := True;
end;

function TBDEDataDriverEh.CreateInsertCommand: TCustomSQLCommandEh;
begin
  Result := TBDECommandEh.Create(Self);
end;

function TBDEDataDriverEh.CreateSelectCommand: TCustomSQLCommandEh;
begin
  Result := TBDECommandEh.Create(Self);
end;

function TBDEDataDriverEh.CreateGetrecCommand: TCustomSQLCommandEh;
begin
  Result := TBDECommandEh.Create(Self);
end;

function TBDEDataDriverEh.CreateUpdateCommand: TCustomSQLCommandEh;
begin
  Result := TBDECommandEh.Create(Self);
end;

function TBDEDataDriverEh.CreateDeleteCommand: TCustomSQLCommandEh;
begin
  Result := TBDECommandEh.Create(Self);
end;

procedure TBDEDataDriverEh.SetDatabaseName(const Value: string);
begin
  FDatabaseName := Value;
end;

procedure TBDEDataDriverEh.GetBackUpdatedValues(MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
begin
  inherited GetBackUpdatedValues(MemRec, Command, ResDataSet);
  DoServerSpecOperations(MemRec, Command, ResDataSet);
end;

//Informix
procedure DoInformixServerSpecOperations(DataDriver: TBDEDataDriverEh; MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);

type
  TSQLCA = packed record
    sqlcode: Longint;
    sqlerrm: array [0..71] of char; // error message parameters
    sqlerrp: array [0..7] of char;
    sqlerrd: array [0..5] of Longint;
             // 0 - estimated number of rows returned
             // 1 - serial value after insert or ISAM error code
             // 2 - number of rows processed
             // 3 - estimated cost
             // 4 - offset of the error into the SQL statement
             // 5 - rowid after insert
    sqlwarn: array [0..7] of char;
             // = W if any of sqlwarn[1-7]
             // = W if any truncation occurred or database has transactions
             // = W if a null value returned or ANSI database
             // = W if no. in select list != no. in into list or turbo backend
             // = W if no where clause on prepared update, delete or incompatible float format
             // = W if non-ANSI statement
             // reserved
             // reserved
  end;

var
  sqlca: TSQLCA;
  res: Word;
  SerrialField: String;
begin
  if Command <> DataDriver.InsertCommand then Exit;
  sqlca.sqlerrd[1] := 0;

{$IFDEF CIL}
  { TODO : DbiGetProp }
{$ELSE}
  if (ResDataSet is TDBDataSet) and (TDBDataSet(ResDataSet).Database <> nil) then
    Check(DbiGetProp(hDBIObj(TDBDataSet(ResDataSet).Database.Handle), drvNATIVESQLCA, @sqlca, SizeOf(tsqlca), res));
{$ENDIF}

  SerrialField := DataDriver.SpecParams.Values['SERIAL_FIELD'];
  if MemRec.DataStruct.FindField(SerrialField) = nil then
    SerrialField := '';
     {??? InsertCommand = Command}
  if (DataDriver.InsertCommand = Command) and (SerrialField <> '') then
  begin
    if sqlca.sqlerrd[1] > 0 then
    begin
      MemRec.DataValues[SerrialField, dvvValueEh] := sqlca.sqlerrd[1];
    end;
  end;

end;

//DB2
procedure DoDB2ServerSpecOperations(DataDriver: TBDEDataDriverEh; MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
begin
end;

//InterBase
procedure DoInterBaseServerSpecOperations(DataDriver: TBDEDataDriverEh; MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
const
  SGENSQL = 'SELECT GEN_ID(%s, %d) FROM RDB$DATABASE';  {do not localize}
var
  Generator, GeneratorField: String;
  q: TQuery;
begin
{ TODO : May be better to use Memrec.UpdateStatus = Inserted ? }
  if Command <> DataDriver.InsertCommand then Exit;
  Generator := DataDriver.SpecParams.Values['GENERATOR'];
  GeneratorField := DataDriver.SpecParams.Values['GENERATOR_FIELD'];
  if MemRec.DataStruct.FindField(GeneratorField) = nil then
    GeneratorField := '';
  if (Generator <> '') and (GeneratorField <> '') then
  begin
    q := TQuery.Create(nil);
    try
      q.DatabaseName := DataDriver.DatabaseName;
      q.SQL.Text := Format(SGENSQL, [Generator, 0]);
      q.Open;
      // Get current GENERATOR value
      MemRec.DataValues[GeneratorField, dvvValueEh] := q.Fields[0].Value;
    finally
      q.Free;
    end;
  end;
end;

//Oracle
procedure DoOracleServerSpecOperations(DataDriver: TBDEDataDriverEh; MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
const
  SEQSQL = 'SELECT %s.curval FROM dual';  {do not localize}
var
  Sequence, SequenceField: String;
  q: TQuery;
begin
  if Command <> DataDriver.InsertCommand then Exit;
  Sequence := DataDriver.SpecParams.Values['SEQUENCE'];
  SequenceField := DataDriver.SpecParams.Values['SEQUENCE_FIELD'];
  if MemRec.DataStruct.FindField(SequenceField) = nil then
    SequenceField := '';
  if (Sequence <> '') and (SequenceField <> '') and
     (ResDataSet is TDBDataSet) and (TDBDataSet(ResDataSet).Database <> nil) then
  begin
    q := TQuery.Create(nil);
    try
      q.DatabaseName := TDBDataSet(ResDataSet).DatabaseName;
      q.SQL.Text := Format(SEQSQL, [Sequence, 0]);
      q.Open;
      // Get current Sequence value
      MemRec.DataValues[SequenceField, dvvValueEh] := q.Fields[0].Value;
    finally
      q.Free;
    end;
  end;
end;

//Sybase
procedure DoSybaseServerSpecOperations(DataDriver: TBDEDataDriverEh; MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
begin

end;

//Microsoft SQL Server
procedure DoMSSQLServerSpecOperations(DataDriver: TBDEDataDriverEh; MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
const
  IDENTITYSQL1 = 'SELECT @@IDENTITY';  {do not localize}
  IDENTITYSQL2 = 'SELECT @@SCOPE_IDENTITY()';  {do not localize}
var
  IdentityField: String;
  q: TQuery;
begin
  if Command <> DataDriver.InsertCommand then Exit;
  IdentityField := DataDriver.SpecParams.Values['AUTO_INCREMENT_FIELD'];
  if IdentityField <> '' then
  begin
    q := TQuery.Create(nil);
    try
      q.DatabaseName := DataDriver.DatabaseName;
      q.SQL.Text := IDENTITYSQL1;
      q.Open;
      // Get current Sequence value
      MemRec.DataValues[IdentityField, dvvValueEh] := q.Fields[0].Value;
    finally
      q.Free;
    end;
  end;
end;

procedure TBDEDataDriverEh.DoServerSpecOperations(MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
var
  Description: TDBDescription;
begin
  if not GetDatabaseDesc(DatabaseName, Description) then
    Exit;
  if Description.szDbType = 'INFROMIX' then
    DoInformixServerSpecOperations(Self, MemRec, Command, ResDataSet)
  else if Description.szDbType = 'DB2' then
    DoDB2ServerSpecOperations(Self, MemRec, Command, ResDataSet)
  else if Description.szDbType = 'INTRBASE' then
    DoInterBaseServerSpecOperations(Self, MemRec, Command, ResDataSet)
  else if Description.szDbType = 'ORACLE' then
    DoOracleServerSpecOperations(Self, MemRec, Command, ResDataSet)
  else if Description.szDbType = 'SYBASE' then
    DoSybaseServerSpecOperations(Self, MemRec, Command, ResDataSet)
  else if Description.szDbType = 'SQL Server' then
    DoMSSQLServerSpecOperations(Self, MemRec, Command, ResDataSet)
end;

function TBDEDataDriverEh.GetDBSession: TSession;
begin
  Result := Sessions.FindSession(SessionName);
  if Result = nil then Result := DBTables.Session;
end;

procedure TBDEDataDriverEh.SetSessionName(const Value: string);
begin
  FSessionName := Value;
end;

procedure TBDEDataDriverEh.SetAutoIncFields(Fields: TFields; DataStruct: TMTDataStructEh);
var
  AutoIncFieldName: String;
  AutoIncField: TMTDataFieldEh;
begin
  AutoIncFieldName := SpecParams.Values['AUTO_INCREMENT_FIELD'];
  AutoIncField := nil;
  if AutoIncFieldName <> '' then
    AutoIncField := DataStruct.FindField(AutoIncFieldName);
  if (AutoIncField <> nil) and (AutoIncField is TMTNumericDataFieldEh) then
    TMTNumericDataFieldEh(AutoIncField).NumericDataType := fdtAutoIncEh;
end;

function TBDEDataDriverEh.HaveDataConnection: Boolean;
begin
  if DatabaseName <> ''
    then Result := True
    else Result := inherited HaveDataConnection();
end;

end.
