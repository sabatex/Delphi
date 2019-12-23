{*******************************************************}
{                                                       }
{                     EhLib vX.X                        }
{                                                       }
{          TDBXDataDriverEh component (Build 14)        }
{                                                       }
{      Copyright (c) 2003,04 by Dmitry V. Bolshakov     }
{                                                       }
{*******************************************************}

unit DBXDataDriverEh;

{$I EHLIB.INC}

interface

uses Windows, SysUtils, Classes, Controls, DB,
{$IFDEF EH_LIB_6} Variants, SqlExpr, {$ENDIF}
{$IFDEF EH_LIB_5} Contnrs, {$ENDIF}
  ToolCtrlsEh, DBCommon, MemTableDataEh, DataDriverEh;
type

  TDBXDataDriverEh = class;

{ TDBXCommandEh }

  TDBXCommandEh = class(TBaseSQLCommandEh)
  private
    function GetDataDriver: TDBXDataDriverEh;
  public
    function Execute(var Cursor: TDataSet; var FreeOnEof: Boolean): Integer; override;
    property DataDriver: TDBXDataDriverEh read GetDataDriver;
  published
    property Params;
    property ParamCheck;
    property CommandText;
    property CommandType;
  end;

{ TDBXDataDriverEh }

  TDBXDataDriverEh = class(TBaseSQLDataDriverEh)
  private
    FSQLConnection: TSQLConnection;
    procedure SetConnection(const Value: TSQLConnection);
  protected
    function CreateSelectCommand: TCustomSQLCommandEh; override;
    function CreateUpdateCommand: TCustomSQLCommandEh; override;
    function CreateInsertCommand: TCustomSQLCommandEh; override;
    function CreateDeleteCommand: TCustomSQLCommandEh; override;
    function CreateGetrecCommand: TCustomSQLCommandEh; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetAutoIncFields(Fields: TFields; DataStruct: TMTDataStructEh); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CreateDesignCopy: TCustomSQLDataDriverEh; override;
    function HaveDataConnection(): Boolean; override;
    procedure GetBackUpdatedValues(MemRec: TMemoryRecordEh; Command: TCustomSQLCommandEh; ResDataSet: TDataSet); override;
    procedure DoServerSpecOperations(MemRec: TMemoryRecordEh; Command: TCustomSQLCommandEh; ResDataSet: TDataSet); virtual;
  published
    property SQLConnection: TSQLConnection read FSQLConnection write SetConnection;
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

function DefaultExecuteDBXCommandEh(SQLDataDriver: TCustomSQLDataDriverEh;
    Command: TCustomSQLCommandEh; var Cursor: TDataSet; var FreeOnEof: Boolean;
    var Processed: Boolean; ASQLConnection: TSQLConnection): Integer;

implementation

function DefaultExecuteDBXCommandEh(SQLDataDriver: TCustomSQLDataDriverEh;
    Command: TCustomSQLCommandEh; var Cursor: TDataSet; var FreeOnEof: Boolean;
    var Processed: Boolean; ASQLConnection: TSQLConnection): Integer;
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
          ACursor := TSQLQuery.Create(nil);
          with ACursor as TSQLQuery do
          begin
            SQLConnection := ASQLConnection;
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
          ACursor := TSQLTable.Create(nil);
          with ACursor as TSQLTable do
          begin
            SQLConnection := ASQLConnection;
            TableName := Command.CommandText.Text;
//            Parameters.Assign(TBaseSQLCommandEh(Command).Params);
            Open;
//            TBaseSQLCommandEh(Command).Params.Assign(Parameters);
          end;
        end;
      cthStoredProc:
        begin
          ACursor := TSQLStoredProc.Create(nil);
          with ACursor as TSQLStoredProc do
          begin
            SQLConnection := ASQLConnection;
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

{ TDBXCommandEh }

function TDBXCommandEh.Execute(var Cursor: TDataSet; var FreeOnEof: Boolean): Integer;
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
          ACursor := TSQLQuery.Create(nil);
          with ACursor as TSQLQuery do
          begin
            SQLConnection := DataDriver.SQLConnection;
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
          ACursor := TSQLTable.Create(nil);
          with ACursor as TSQLTable do
          begin
            SQLConnection := DataDriver.SQLConnection;
            TableName := Self.CommandText.Text;
            Params := Self.Params;
            Open;
            Self.Params := Params;
          end;
        end;
      cthStoredProc:
        begin
          ACursor := TSQLStoredProc.Create(nil);
          with ACursor as TSQLStoredProc do
          begin
            SQLConnection := DataDriver.SQLConnection;
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

function TDBXCommandEh.GetDataDriver: TDBXDataDriverEh;
begin
  Result := TDBXDataDriverEh(inherited DataDriver);
end;

{ TDBXDataDriverEh }

var
  DataBaseInc: Integer = 0;

function GetUnicalDataBaseName: String;
begin
  Inc(DataBaseInc);
  Result := 'DBXDataDriverEhDataBaseName' + IntToStr(DataBaseInc);
end;

constructor TDBXDataDriverEh.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TDBXDataDriverEh.Destroy;
begin
  inherited Destroy;
end;

function TDBXDataDriverEh.CreateDesignCopy: TCustomSQLDataDriverEh;
begin
  Result := TDBXDataDriverEh.Create(nil);
  Result.SelectCommand := SelectCommand;
  Result.UpdateCommand := UpdateCommand;
  Result.InsertCommand := InsertCommand;
  Result.DeleteCommand := DeleteCommand;
  Result.GetrecCommand := GetrecCommand;
//  TDBXDataDriverEh(Result).DatabaseName :=
//   (DesignDataBase as IDBXDesignDataBaseEh).GetDataBase.DatabaseName;
end;

type
  TDBDescription = record
    szName          : String;          { Logical name (Or alias) }
    szText          : String;          { Descriptive text }
    szPhyName       : String;          { Physical name/path }
    szDbType        : String;          { Database type }
  end;

function TDBXDataDriverEh.CreateInsertCommand: TCustomSQLCommandEh;
begin
  Result := TDBXCommandEh.Create(Self);
end;

function TDBXDataDriverEh.CreateSelectCommand: TCustomSQLCommandEh;
begin
  Result := TDBXCommandEh.Create(Self);
end;

function TDBXDataDriverEh.CreateGetrecCommand: TCustomSQLCommandEh;
begin
  Result := TDBXCommandEh.Create(Self);
end;

function TDBXDataDriverEh.CreateUpdateCommand: TCustomSQLCommandEh;
begin
  Result := TDBXCommandEh.Create(Self);
end;

function TDBXDataDriverEh.CreateDeleteCommand: TCustomSQLCommandEh;
begin
  Result := TDBXCommandEh.Create(Self);
end;

procedure TDBXDataDriverEh.GetBackUpdatedValues(MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
begin
  inherited GetBackUpdatedValues(MemRec, Command, ResDataSet);
  DoServerSpecOperations(MemRec, Command, ResDataSet);
end;

//Informix
procedure DoInformixServerSpecOperations(DataDriver: TDBXDataDriverEh; MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
(*
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
*)
begin
(*
  if Command <> DataDriver.InsertCommand then Exit;
  if (ResDataSet is TDBDataSet) and (TDBDataSet(ResDataSet).Database <> nil) then
    Check(DbiGetProp(hDBIObj(TDBDataSet(ResDataSet).Database.Handle), drvNATIVESQLCA, @sqlca, SizeOf(tsqlca), res));

  SerrialField := DataDriver.SpecParams.Values['SERIAL_FIELD'];
  if MemRec.DataStruct.FindField(SerrialField) = nil then
    SerrialField := '';
     {??? InsertCommand = Command}
  if (DataDriver.InsertCommand = Command) and (SerrialField <> '') then
  begin
    if sqlca.sqlerrd[1] > 0 then
    begin
      MemRec.DataValues[SerrialField, dvtValueEh] := sqlca.sqlerrd[1];
    end;
  end;
*)
end;

//DB2
procedure DoDB2ServerSpecOperations(DataDriver: TDBXDataDriverEh; MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
begin
end;

//InterBase
procedure DoInterBaseServerSpecOperations(DataDriver: TDBXDataDriverEh; MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
const
  SGENSQL = 'SELECT GEN_ID(%s, %d) FROM RDB$DATABASE';  {do not localize}
var
  Generator, GeneratorField: String;
  q: TSQLQuery;
begin
{ TODO : May be better to use Memrec.UpdateStatus = Inserted ? }
  if Command <> DataDriver.InsertCommand then Exit;
  Generator := DataDriver.SpecParams.Values['GENERATOR'];
  GeneratorField := DataDriver.SpecParams.Values['GENERATOR_FIELD'];
  if MemRec.DataStruct.FindField(GeneratorField) = nil then
    GeneratorField := '';
  if (Generator <> '') and (GeneratorField <> '') then
  begin
    q := TSQLQuery.Create(nil);
    try
      q.SQLConnection := DataDriver.SQLConnection;
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
procedure DoOracleServerSpecOperations(DataDriver: TDBXDataDriverEh; MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
const
  SEQSQL = 'SELECT %s.curval FROM dual';  {do not localize}
var
  Sequence, SequenceField: String;
  q: TSQLQuery;
begin
  if Command <> DataDriver.InsertCommand then Exit;
  Sequence := DataDriver.SpecParams.Values['SEQUENCE'];
  SequenceField := DataDriver.SpecParams.Values['SEQUENCE_FIELD'];
  if MemRec.DataStruct.FindField(SequenceField) = nil then
    SequenceField := '';
  if (Sequence <> '') and (SequenceField <> '') and
     (ResDataSet is TCustomSQLDataSet) and (TCustomSQLDataSet(ResDataSet).SQLConnection <> nil) then
  begin
    q := TSQLQuery.Create(nil);
    try
      q.SQLConnection := TCustomSQLDataSet(ResDataSet).SQLConnection;
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
procedure DoSybaseServerSpecOperations(DataDriver: TDBXDataDriverEh; MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
begin
end;

procedure TDBXDataDriverEh.DoServerSpecOperations(MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
var
  DbType: String;
begin
  if (SQLConnection = nil) then
    Exit;
  DbType := UpperCase(SQLConnection.DriverName);
  if DbType = 'INFROMIX' then
    DoInformixServerSpecOperations(Self, MemRec, Command, ResDataSet)
  else if DbType = 'DB2' then
    DoDB2ServerSpecOperations(Self, MemRec, Command, ResDataSet)
  else if DbType = 'INTRBASE' then
    DoInterBaseServerSpecOperations(Self, MemRec, Command, ResDataSet)
  else if DbType = 'ORACLE' then
    DoOracleServerSpecOperations(Self, MemRec, Command, ResDataSet)
  else if DbType = 'SYBASE' then
    DoSybaseServerSpecOperations(Self, MemRec, Command, ResDataSet);
end;

procedure TDBXDataDriverEh.SetConnection(const Value: TSQLConnection);
begin
  if FSQLConnection <> Value then
  begin
    FSQLConnection := Value;
    if FSQLConnection <> nil then
      FSQLConnection.FreeNotification(Self);
  end;
end;

procedure TDBXDataDriverEh.SetAutoIncFields(Fields: TFields; DataStruct: TMTDataStructEh);
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

procedure TDBXDataDriverEh.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and
     (AComponent <> nil) and
     (FSQLConnection = AComponent)
  then
    FSQLConnection := nil;
end;

function TDBXDataDriverEh.HaveDataConnection: Boolean;
begin
  if Assigned(SQLConnection)
    then Result := True
    else Result := inherited HaveDataConnection();
end;

end.
