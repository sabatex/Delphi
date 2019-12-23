{*******************************************************}
{                                                       }
{                     EhLib vX.X                        }
{                                                       }
{           TDataDriverEh, TSQLDataDriverEh             }
{                components (Build 14)                  }
{                                                       }
{     Copyright (c) 2003,04 by Dmitry V. Bolshakov      }
{                                                       }
{*******************************************************}

unit DataDriverEh;// {$IFDEF CIL} platform{$ENDIF};

{$I EHLIB.INC}

interface

uses SysUtils, Classes, Controls, DB,
{$IFDEF EH_LIB_6} Variants, {$ENDIF}
{$IFDEF EH_LIB_5} Contnrs, {$ENDIF}
  ToolCtrlsEh, DBCommon, MemTableDataEh;
type

{ TDataDriverEh }
  TUpdateErrorActionEh = (ueaBreakAbortEh, ueaBreakRaiseEh, ueaCountinueEh, ueaRetryEh, ueaCountinueSkip);

  TProduceDataReaderEhEvent = procedure (var DataReader: TDataSet; var FreeOnEof: Boolean) of object;
  TBuildDataStructEhEvent = procedure (DataStruct: TMTDataStructEh) of object;
  TReadRecordEhEvent = procedure (MemTableData: TMemTableDataEh;
    MemRec: TMemoryRecordEh; var ProviderEOF: Boolean) of object;
  TUpdateErrorEhEvent = procedure (MemTableData: TMemTableDataEh;
    MemRec: TMemoryRecordEh; var Action: TUpdateErrorActionEh) of object;
  TRecordEhEvent = procedure (MemTableData: TMemTableDataEh; MemRec: TMemoryRecordEh) of object;
  TAssignFieldValueEhEvent = procedure (MemTableData: TMemTableDataEh; MemRec: TMemoryRecordEh;
    DataFieldIndex: Integer; DataValueVersion: TDataValueVersionEh; ReaderDataSet: TDataSet) of object;

  TDataDriverEh = class(TComponent)
  private
    FKeyFields: String;
    FOnAssignFieldValue: TAssignFieldValueEhEvent;
    FOnBuildDataStruct: TBuildDataStructEhEvent;
    FOnProduceDataReader: TProduceDataReaderEhEvent;
    FOnReadRecord: TReadRecordEhEvent;
    FOnRefreshRecord: TRecordEhEvent;
    FOnUpdateError: TUpdateErrorEhEvent;
    FOnUpdateRecord: TRecordEhEvent;
    FProviderDataSet: TDataSet;
    FProviderEOF: Boolean;
    FReaderDataSet: TDataSet;
    FReaderDataSetFreeOnEof: Boolean;
    FResolveToDataSet: Boolean;
    procedure SetKeyFields(const Value: String);
    procedure SetProviderDataSet(const Value: TDataSet);
    procedure SetProviderEOF(const Value: Boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetAutoIncFields(Fields: TFields; DataStruct: TMTDataStructEh); virtual;
    property KeyFields: String read FKeyFields write SetKeyFields;
    property ProviderDataSet: TDataSet read FProviderDataSet write SetProviderDataSet;
    property ReaderDataSet: TDataSet read FReaderDataSet;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ApplyUpdates(MemTableData: TMemTableDataEh): Integer; virtual;
    function DefaultUpdateRecord(MemTableData: TMemTableDataEh; MemRec: TMemoryRecordEh): Integer; virtual;
    function GetDataReader: TDataSet; virtual;
    function ReadData(MemTableData: TMemTableDataEh; Count: Integer): Integer; virtual;
    function RefreshReaderParamsFromCursor(DataSet: TDataSet): Boolean; virtual;
    procedure AssignFieldValue(MemTableData: TMemTableDataEh; MemRec: TMemoryRecordEh;
      DataFieldIndex: Integer; DataValueVersion: TDataValueVersionEh; ReaderDataSet: TDataSet); virtual;
    procedure UpdateRecord(MemTableData: TMemTableDataEh; MemRec: TMemoryRecordEh); virtual;
    procedure ConsumerClosed(ConsumerDataSet: TDataSet); virtual;
    procedure DefaultAssignFieldValue(MemTableData: TMemTableDataEh; MemRec: TMemoryRecordEh;
      DataFieldIndex: Integer; DataValueVersion: TDataValueVersionEh; ReaderDataSet: TDataSet); virtual;
    procedure DefaultBuildDataStruct(DataStruct: TMTDataStructEh); virtual;
    procedure DefaultProduceDataReader(var DataSet: TDataSet; var FreeOnEof: Boolean); virtual;
    procedure DefaultReadRecord(MemTableData: TMemTableDataEh; Rec: TMemoryRecordEh; var ProviderEOF: Boolean); virtual;
    procedure DefaultUpdateError(MemTableData: TMemTableDataEh;
      MemRec: TMemoryRecordEh; var Action: TUpdateErrorActionEh); virtual;
    procedure DefaultRefreshRecord(MemRecord: TMemoryRecordEh); virtual;
    procedure BuildDataStruct(DataStruct: TMTDataStructEh); virtual;
    procedure RefreshRecord(MemRecord: TMemoryRecordEh); virtual;
    procedure SetReaderParamsFromCursor(DataSet: TDataSet); virtual;
    property OnBuildDataStruct: TBuildDataStructEhEvent read FOnBuildDataStruct write FOnBuildDataStruct;
    property OnProduceDataReader: TProduceDataReaderEhEvent read FOnProduceDataReader write FOnProduceDataReader;
    property OnAssignFieldValue: TAssignFieldValueEhEvent read FOnAssignFieldValue write FOnAssignFieldValue;
    property OnReadRecord: TReadRecordEhEvent read FOnReadRecord write FOnReadRecord;
    property OnRefreshRecord: TRecordEhEvent read  FOnRefreshRecord write FOnRefreshRecord;
    property OnUpdateRecord: TRecordEhEvent read  FOnUpdateRecord write FOnUpdateRecord;
    property OnUpdateError: TUpdateErrorEhEvent read  FOnUpdateError write FOnUpdateError;
    property ProviderEOF: Boolean read FProviderEOF write SetProviderEOF;
    property ResolveToDataSet: Boolean read FResolveToDataSet write FResolveToDataSet default True;
  end;

  TDataSetDriverEh = class(TDataDriverEh)
  published
    property KeyFields;
    property ProviderDataSet;
    property OnBuildDataStruct;
    property OnProduceDataReader;
    property OnAssignFieldValue;
    property OnReadRecord;
    property OnRefreshRecord;
    property OnUpdateRecord;
    property OnUpdateError;
    property ResolveToDataSet;
  end;

  TCustomSQLDataDriverEh = class;
  TCustomSQLCommandEh = class;
  
{ TServerServiceEh }

  TServerServiceEh = class(TPersistent)
  private
    FDataDriver: TCustomSQLDataDriverEh;
  protected
  public
    procedure GetBackUpdatedValues(MemRec: TMemoryRecordEh; Command: TCustomSQLCommandEh; ResDataSet: TDataSet); virtual;
    constructor Create(ADataDriver: TCustomSQLDataDriverEh);
    destructor Destroy; override;
  end;

{ TCustomSQLCommandEh }

  TSQLCommandTypeEh = (cthSelectQuery, cthUpdateQuery, cthTable, cthStoredProc);
  TSQLExecuteEhEvent = function (var Cursor: TDataSet; var FreeOnEof: Boolean) : Integer of object;
  TAssignParamEhEvent = procedure (Command: TCustomSQLCommandEh;
    MemRecord: TMemoryRecordEh; DataValueVersion: TDataValueVersionEh; Param: TParam) of object;

  TCustomSQLCommandEh = class(TPersistent)
  private
    FCommandText: TStrings;
    FCommandType: TSQLCommandTypeEh;
    FDataDriver: TCustomSQLDataDriverEh;
//    FOnExecute: TSQLExecuteEhEvent;
    function IsCommandTypeStored: Boolean;
  protected
    function DefaultCommandType: TSQLCommandTypeEh; virtual;
    function GetCommandText: TStrings; virtual;
    function GetCommandType: TSQLCommandTypeEh; virtual;
    function GetOwner: TPersistent; override;
    procedure CommandTextChanged(Sender: TObject); virtual;
    procedure CommandTypeChanged; virtual;
    procedure SetCommandText(const Value: TStrings); virtual;
    procedure SetCommandType(const Value: TSQLCommandTypeEh); virtual;
  public
    constructor Create(ADataDriver: TCustomSQLDataDriverEh);
    destructor Destroy; override;
    function Execute(var Cursor: TDataSet; var FreeOnEof: Boolean): Integer; virtual;
    function GetNamePath: String; override;
    function GetParams: TParams; virtual;
    procedure Assign(Source: TPersistent); override;
    procedure AssignParams(AParams: TParams); virtual;
    procedure AssignToParams(AParams: TParams); virtual;
    procedure SetParams(AParams: TParams); virtual;
    procedure RefreshParams(MemRecord: TMemoryRecordEh; DataValueVersion: TDataValueVersionEh); virtual;
//    property OnExecute: TSQLExecuteEhEvent read FOnExecute write FOnExecute;
    property DataDriver: TCustomSQLDataDriverEh read FDataDriver;
    property CommandText: TStrings read GetCommandText write SetCommandText;
    property CommandType: TSQLCommandTypeEh read GetCommandType write SetCommandType
      stored IsCommandTypeStored;
  end;

{ TCustomSQLDataDriverEh }

{$IFNDEF EH_LIB_6}
  IInterface = IUnknown;
{$ENDIF}

  TExecuteCommandEhEvent = function (Command: TCustomSQLCommandEh; var Cursor: TDataSet;
    var FreeOnEof: Boolean): Integer of object;
  TGetBackUpdatedValuesEhEvent = procedure (MemRec: TMemoryRecordEh;
    Command: TCustomSQLCommandEh; ResDataSet: TDataSet) of object;

  TCustomSQLDataDriverEh = class(TDataDriverEh)
  private
    FDeleteCommand: TCustomSQLCommandEh;
    FDesignDataBase: TComponent;
    FGetrecCommand: TCustomSQLCommandEh;
    FInsertCommand: TCustomSQLCommandEh;
    FOnExecuteCommand: TExecuteCommandEhEvent;
    FOnGetBackUpdatedValues: TGetBackUpdatedValuesEhEvent;
    FSelectCommand: TCustomSQLCommandEh;
    FSpecParams: TStrings;
    FUpdateCommand: TCustomSQLCommandEh;
    FServiceCommand: TCustomSQLCommandEh;
    FServerService: TServerServiceEh;
    function GetDeleteSQL: TStrings;
    function GetGetrecSQL: TStrings;
    function GetInsertSQL: TStrings;
    function GetSelectSQL: TStrings;
    function GetUpdateSQL: TStrings;
    procedure SetDeleteCommand(const Value: TCustomSQLCommandEh);
    procedure SetDeleteSQL(const Value: TStrings);
    procedure SetGetrecCommand(const Value: TCustomSQLCommandEh);
    procedure SetGetrecSQL(const Value: TStrings);
    procedure SetInsertCommand(const Value: TCustomSQLCommandEh);
    procedure SetInsertSQL(const Value: TStrings);
    procedure SetSelectCommand(const Value: TCustomSQLCommandEh);
    procedure SetSelectSQL(const Value: TStrings);
    procedure SetSpecParams(const Value: TStrings);
    procedure SetUpdateCommand(const Value: TCustomSQLCommandEh);
    procedure SetUpdateSQL(const Value: TStrings);
    procedure SetServiceCommand(const Value: TCustomSQLCommandEh);
  protected
    procedure SetDesignDataBase(const Value: TComponent); virtual;
  public
    {DesignTime stuff}
    function CreateDesignCopy: TCustomSQLDataDriverEh; virtual;
    function CreateDesignDataBase: TComponent; virtual;
    function GetDesignDataBase: TComponent; virtual;
    procedure AssignFromDesignDriver(DesignDataDriver: TCustomSQLDataDriverEh); virtual;
    property DesignDataBase: TComponent read FDesignDataBase write SetDesignDataBase;
  protected
//    function GetReaderDataSet: TDataSet; override;
    function CreateCommand: TCustomSQLCommandEh; virtual;
    function CreateDeleteCommand: TCustomSQLCommandEh; virtual;
    function CreateInsertCommand: TCustomSQLCommandEh; virtual;
    function CreateSelectCommand: TCustomSQLCommandEh; virtual;
    function CreateGetrecCommand: TCustomSQLCommandEh; virtual;
    function CreateUpdateCommand: TCustomSQLCommandEh; virtual;
    function GetDefaultCommandTypeFor(Command: TCustomSQLCommandEh): TSQLCommandTypeEh; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure UpdateServerService; virtual;
    property SpecParams: TStrings read FSpecParams write SetSpecParams;
    property ServiceCommand: TCustomSQLCommandEh read FServiceCommand write SetServiceCommand;
    property ServerService: TServerServiceEh read FServerService;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function DefaultUpdateRecord(MemTableData: TMemTableDataEh; MemRec: TMemoryRecordEh): Integer; override;
    function ExecuteCommand(Command: TCustomSQLCommandEh; var Cursor: TDataSet; var FreeOnEof: Boolean): Integer; virtual;
    function DefaultExecuteCommand(Command: TCustomSQLCommandEh; var Cursor: TDataSet; var FreeOnEof: Boolean): Integer; virtual;
    function RefreshReaderParamsFromCursor(DataSet: TDataSet): Boolean; override;
    function HaveDataConnection(): Boolean; virtual;
    procedure GetBackUpdatedValues(MemRec: TMemoryRecordEh; Command: TCustomSQLCommandEh; ResDataSet: TDataSet); virtual;
    procedure DefaultBuildDataStruct(DataStruct: TMTDataStructEh); override;
    procedure DefaultGetUpdatedServerValues(MemRec: TMemoryRecordEh; Command: TCustomSQLCommandEh; ResDataSet: TDataSet); virtual;
    procedure DefaultProduceDataReader(var DataSet: TDataSet; var FreeOnEof: Boolean); override;
    procedure DefaultRefreshRecord(MemRecord: TMemoryRecordEh); override;
    procedure SetReaderParamsFromCursor(DataSet: TDataSet); override;
    property ResolveToDataSet default False;
    property DeleteCommand: TCustomSQLCommandEh read FDeleteCommand write SetDeleteCommand;
    property DeleteSQL: TStrings read GetDeleteSQL write SetDeleteSQL stored False;
    property GetrecCommand: TCustomSQLCommandEh read FGetrecCommand write SetGetrecCommand;
    property GetrecSQL: TStrings read GetGetrecSQL write SetGetrecSQL stored False;
    property InsertCommand: TCustomSQLCommandEh read FInsertCommand write SetInsertCommand;
    property InsertSQL: TStrings read GetInsertSQL write SetInsertSQL stored False;
    property SelectCommand: TCustomSQLCommandEh read FSelectCommand write SetSelectCommand;
    property SelectSQL: TStrings read GetSelectSQL write SetSelectSQL stored False;
    property UpdateCommand: TCustomSQLCommandEh read FUpdateCommand write SetUpdateCommand;
    property UpdateSQL: TStrings read GetUpdateSQL write SetUpdateSQL stored False;
    property OnExecuteCommand: TExecuteCommandEhEvent read FOnExecuteCommand write FOnExecuteCommand;
    property OnGetBackUpdatedValues: TGetBackUpdatedValuesEhEvent read FOnGetBackUpdatedValues write FOnGetBackUpdatedValues;
  end;

{ TSQLDataDriverResolver }

  TResolverExecuteCommandEhEvent = function (SQLDataDriver: TCustomSQLDataDriverEh;
    Command: TCustomSQLCommandEh; var Cursor: TDataSet; var FreeOnEof: Boolean;
    var Processed: Boolean): Integer of object;

  TSQLDataDriverResolver = class(TPersistent)
  private
    FOnExecuteCommand: TResolverExecuteCommandEhEvent;
  public
    function ExecuteCommand(SQLDataDriver: TCustomSQLDataDriverEh; Command: TCustomSQLCommandEh;
      var Cursor: TDataSet; var FreeOnEof: Boolean; var Processed: Boolean): Integer; virtual;
    property OnExecuteCommand: TResolverExecuteCommandEhEvent read FOnExecuteCommand write FOnExecuteCommand;
  end;

  TBaseSQLCommandEh = class;

{ TBaseSQLDataDriverEh }

  TBaseSQLDataDriverEh = class(TCustomSQLDataDriverEh)
  private
    FOnAssignCommandParam: TAssignParamEhEvent;
    function GetDeleteCommand: TBaseSQLCommandEh;
    function GetInsertCommand: TBaseSQLCommandEh;
    function GetSelectCommand: TBaseSQLCommandEh;
    function GetGetrecCommand: TBaseSQLCommandEh;
    function GetUpdateCommand: TBaseSQLCommandEh;
    procedure SetDeleteCommand(const Value: TBaseSQLCommandEh);
    procedure SetInsertCommand(const Value: TBaseSQLCommandEh);
    procedure SetSelectCommand(const Value: TBaseSQLCommandEh);
    procedure SetGetrecCommand(const Value: TBaseSQLCommandEh);
    procedure SetUpdateCommand(const Value: TBaseSQLCommandEh);
  protected
    function CreateDeleteCommand: TCustomSQLCommandEh; override;
    function CreateInsertCommand: TCustomSQLCommandEh; override;
    function CreateSelectCommand: TCustomSQLCommandEh; override;
    function CreateGetrecCommand: TCustomSQLCommandEh; override;
    function CreateUpdateCommand: TCustomSQLCommandEh; override;
    procedure AssignCommandParam(Command: TBaseSQLCommandEh;
      MemRecord: TMemoryRecordEh; DataValueVersion: TDataValueVersionEh; Param: TParam); virtual;
  public
    procedure DefaultGetUpdatedServerValues(MemRec: TMemoryRecordEh; Command: TCustomSQLCommandEh; ResDataSet: TDataSet); override;
    procedure DefaultAssignCommandParam(Command: TBaseSQLCommandEh;
      MemRecord: TMemoryRecordEh; DataValueVersion: TDataValueVersionEh; Param: TParam); virtual;
    property OnAssignCommandParam: TAssignParamEhEvent read FOnAssignCommandParam write FOnAssignCommandParam;
    property DeleteCommand: TBaseSQLCommandEh read GetDeleteCommand write SetDeleteCommand;
    property GetrecCommand: TBaseSQLCommandEh read GetGetrecCommand write SetGetrecCommand;
    property InsertCommand: TBaseSQLCommandEh read GetInsertCommand write SetInsertCommand;
    property SelectCommand: TBaseSQLCommandEh read GetSelectCommand write SetSelectCommand;
    property UpdateCommand: TBaseSQLCommandEh read GetUpdateCommand write SetUpdateCommand;
    property SpecParams;
  end;

{ TBaseSQLCommandEh }

  TBaseSQLCommandEh = class(TCustomSQLCommandEh)
  private
    FParamCheck: Boolean;
    FParams: TParams;
    FOnAssignParam: TAssignParamEhEvent;
    function GetParamCheck: Boolean;
    function GetDataDriver: TBaseSQLDataDriverEh;
  protected
    procedure CommandTextChanged(Sender: TObject); override;
    procedure SetParamCheck(const Value: Boolean); virtual;
  public
    constructor Create(ADataDriver: TBaseSQLDataDriverEh);
    destructor Destroy; override;
    function GetParams: TParams; override;
    procedure Assign(Source: TPersistent); override;
    procedure AssignParams(AParams: TParams); override;
    procedure AssignToParams(AParams: TParams); override;
    procedure SetParams(AParams: TParams); override;
    procedure DefaultRefreshParam(MemRecord: TMemoryRecordEh;
      DataValueVersion: TDataValueVersionEh; Param: TParam); virtual;
    procedure RefreshParams(MemRecord: TMemoryRecordEh; DataValueVersion: TDataValueVersionEh); override;

    property DataDriver: TBaseSQLDataDriverEh read GetDataDriver;

    property OnAssignParam: TAssignParamEhEvent read FOnAssignParam write FOnAssignParam;
    property Params: TParams read GetParams write SetParams;
    property ParamCheck: Boolean read GetParamCheck write SetParamCheck default True;
  end;

  TSQLCommandEh = class(TBaseSQLCommandEh)
  published
    property Params;
    property ParamCheck;
    property CommandText;
    property CommandType;
  end;

  TSQLDataDriverEh = class(TBaseSQLDataDriverEh)
  protected
    function CreateSelectCommand: TCustomSQLCommandEh; override;
    function CreateUpdateCommand: TCustomSQLCommandEh; override;
    function CreateInsertCommand: TCustomSQLCommandEh; override;
    function CreateDeleteCommand: TCustomSQLCommandEh; override;
    function CreateGetrecCommand: TCustomSQLCommandEh; override;
  published
    property DeleteCommand;
    property DeleteSQL;
    property GetrecCommand;
    property GetrecSQL;
    property InsertCommand;
    property InsertSQL;
    property SelectCommand;
    property SelectSQL;
    property UpdateCommand;
    property UpdateSQL;
    property KeyFields;
    property ProviderDataSet;
    property SpecParams;
    
    property OnAssignCommandParam;
    property OnAssignFieldValue;
    property OnBuildDataStruct;
    property OnExecuteCommand;
    property OnGetBackUpdatedValues;
    property OnProduceDataReader;
    property OnReadRecord;
    property OnRefreshRecord;
    property OnUpdateError;
    property OnUpdateRecord;
  end;

  TSQLDataDriverEhClass = class of TCustomSQLDataDriverEh;

  TSetDesignDataBaseProcEh = procedure(DataDriver: TCustomSQLDataDriverEh);

function DefaultSQLDataDriverResolver: TSQLDataDriverResolver;
function RegisterDefaultSQLDataDriverResolver(ASQLDataDriverResolver: TSQLDataDriverResolver): TSQLDataDriverResolver;


procedure RegisterDesignDataBuilderProcEh(DataDriverClass: TSQLDataDriverEhClass;
  DesignDataBaseProc: TSetDesignDataBaseProcEh);
procedure UnregisterDesignDataBuilderProcEh(DataDriverClass: TSQLDataDriverEhClass);
function GetDesignDataBuilderProcEh(DataDriverClass: TSQLDataDriverEhClass):
  TSetDesignDataBaseProcEh;

procedure VarParamsToParams(VarParams: Variant; Params: TParams);

implementation

uses
{$IFDEF CIL}
  System.Runtime.InteropServices,
{$ENDIF}
  MemTableEh;

{$IFDEF CIL}

function DataSetCompareBookmarks(DataSet: TDataSet; Bookmark1, Bookmark2: TBookmarkStr): Integer;
var
  I1, I2: IntPtr;
begin
  try
    I1 := Marshal.StringToHGlobalAnsi(Bookmark1);
    I2 := Marshal.StringToHGlobalAnsi(Bookmark1);
    Result := DataSet.CompareBookmarks(TBookmark(I1), TBookmark(I2));
  finally
    Marshal.FreeHGlobal(I1);
    if Assigned(I2) then
      Marshal.FreeHGlobal(I2);
  end;
end;

function DataSetBookmarkValid(DataSet: TDataSet; Bookmark: TBookmarkStr): Boolean;
var
  I1: IntPtr;
begin
  try
    I1 := Marshal.StringToHGlobalAnsi(Bookmark);
    Result := DataSet.BookmarkValid(TBookmark(I1));
  finally
    Marshal.FreeHGlobal(I1);
  end;
end;

{$ELSE}

function DataSetCompareBookmarks(DataSet: TDataSet; Bookmark1, Bookmark2: TBookmarkStr): Integer;
begin
  Result := DataSet.CompareBookmarks(TBookmark(Bookmark1), TBookmark(Bookmark2));
end;

function DataSetBookmarkValid(DataSet: TDataSet; Bookmark: TBookmarkStr): Boolean;
begin
  Result := DataSet.BookmarkValid(TBookmark(Bookmark));
end;

{$ENDIF}

var
  FDefaultSQLDataDriverResolver: TSQLDataDriverResolver;

function DefaultSQLDataDriverResolver: TSQLDataDriverResolver;
begin
  Result := FDefaultSQLDataDriverResolver;
end;

function RegisterDefaultSQLDataDriverResolver(ASQLDataDriverResolver: TSQLDataDriverResolver): TSQLDataDriverResolver;
begin
  Result := FDefaultSQLDataDriverResolver;
  FDefaultSQLDataDriverResolver := ASQLDataDriverResolver;
end;

procedure VarParamsToParams(VarParams: Variant; Params: TParams);
var
  i: Integer;
  dt: TFieldType;
  p: TParam;
begin
  if VarIsNull(VarParams) then
    Exit;
  if VarArrayHighBound(VarParams, 1) > VarArrayLowBound(VarParams, 1) then
    for i := VarArrayLowBound(VarParams, 1) to VarArrayHighBound(VarParams, 1) div 2 do
    begin
      dt := VarTypeToDataType(VarType(VarParams[i*2+1]));
      if dt = ftUnknown then
        dt := ftString;
      p := Params.FindParam(VarParams[i*2]);
      if not Assigned(p) then
        p := Params.CreateParam(dt, VarParams[i*2], ptInputOutput);
      p.Value := VarParams[i*2+1];
    end;
end;

{ TDataDriverEh }

constructor TDataDriverEh.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FResolveToDataSet := True;
end;

destructor TDataDriverEh.Destroy;
begin
  ProviderEof := True;
  inherited Destroy;
end;

function TDataDriverEh.ApplyUpdates(MemTableData: TMemTableDataEh): Integer;
var
  I: Integer;
  MemRec: TMemoryRecordEh;
  Action: TUpdateErrorActionEh;
//  UpdateKind: TUpdateKind;

  procedure ApplyUpdate;
  begin
    while True do
    begin
      try
        UpdateRecord(MemTableData, MemRec);
        Result := Result + 1;
      except
        on E: EDatabaseError do
        begin
          if Assigned(OnUpdateError)
            then OnUpdateError(MemRec.RecordsList.MemTableData, MemRec, Action)
            else DefaultUpdateError(MemRec.RecordsList.MemTableData, MemRec, Action);

          if Action = ueaBreakRaiseEh then
            raise
          else begin
            if MemRec.UpdateError <> nil then
              MemRec.UpdateError.Free;
            MemRec.UpdateError := TUpdateErrorEh.Create(E);
            if Action = ueaRetryEh
              then Continue
              else Break;
          end;
        end;
      end;
      Break;
    end;
  end;

begin
  Result := 0;
  for I := 0 to MemTableData.RecordsList.DeltaList.Count-1 do
  begin
    MemRec := TMemoryRecordEh(MemTableData.RecordsList.DeltaList[I]);
    if MemRec = nil then Continue;
    Action := ueaBreakRaiseEh;
    ApplyUpdate;
    if Action = ueaBreakAbortEh then
      Break;
    if Action <> ueaCountinueSkip then
      MemRec.MergeChanges;
//ueaBreakAbortEh, ueaBreakRaiseEh, ueaCountinueEh, ueaRetryEh
  end;

  MemTableData.RecordsList.CleanupChangedRecs;
end;

procedure TDataDriverEh.DefaultUpdateError(MemTableData: TMemTableDataEh;
  MemRec: TMemoryRecordEh; var Action: TUpdateErrorActionEh);
begin
  Action := ueaBreakRaiseEh;
end;

procedure TDataDriverEh.UpdateRecord(MemTableData: TMemTableDataEh; MemRec: TMemoryRecordEh);
begin
  if Assigned(OnUpdateRecord)
    then OnUpdateRecord(MemTableData, MemRec)
    else DefaultUpdateRecord(MemTableData, MemRec);
end;

function TDataDriverEh.DefaultUpdateRecord(MemTableData: TMemTableDataEh; MemRec: TMemoryRecordEh): Integer;
var
  vOldValues: Variant;
  i: Integer;
  KeyFound: Boolean;
  Bookmark: TBookmarkStr;
  ProviderField: TField;
begin
  Result := 0;
  if ResolveToDataSet and (ProviderDataSet <> nil) then
  begin
    Bookmark := ProviderDataSet.Bookmark;
    try

    if MemRec.UpdateStatus in [usModified, usDeleted] then
    begin
      vOldValues := MemRec.DataValues[KeyFields, dvvOldestValue];
      KeyFound := ProviderDataSet.Locate(KeyFields, vOldValues, []);
      if KeyFound then
      begin
        if (DataSetCompareBookmarks(ProviderDataSet,
          ProviderDataSet.Bookmark, Bookmark) = 0) and
          (MemRec.UpdateStatus = usDeleted)
        then // Will not go to the deleted bookmark
          Bookmark := '';
      end;
    end else
      KeyFound := True;

    if KeyFound then
    begin

      if MemRec.UpdateStatus = usModified then
        ProviderDataSet.Edit
      else if MemRec.UpdateStatus = usInserted then
        ProviderDataSet.Insert
      else
        ProviderDataSet.Delete;

      if MemRec.UpdateStatus in [usModified, usInserted] then
      begin
        try
          with MemRec do
            for i := 0 to DataStruct.Count-1 do
            begin
              ProviderField := ProviderDataSet.FindField(DataStruct[i].FieldName);
              if Assigned(ProviderField) and not ProviderField.ReadOnly then
                ProviderField.Value := Value[i, dvvValueEh];
            end;
          ProviderDataSet.Post;
        except
          on E: EDatabaseError do
          begin
            if ProviderDataSet.State in dsEditModes then
              ProviderDataSet.Cancel;
            raise;
          end;
        end;
//        if RefreshRecord then
//        begin
          MemRec.Edit;
          for i := 0 to MemRec.DataStruct.Count-1 do
            begin
              ProviderField := ProviderDataSet.FindField(MemRec.DataStruct[i].FieldName);
              if Assigned(ProviderField) and not ProviderField.ReadOnly then
                MemRec.Value[i, dvvValueEh] := ProviderField.Value;
            end;
          MemRec.Post;
//        end;
      end;

      Result := 1;
    end;
    finally
      if (Bookmark <> '') and DataSetBookmarkValid(ProviderDataSet, Bookmark) then
        ProviderDataSet.Bookmark := Bookmark;
    end;

//    MemRec.MergeChanges;
  end;
end;

procedure TDataDriverEh.ConsumerClosed(ConsumerDataSet: TDataSet);
begin
  if (ProviderDataSet <> nil) then
    ProviderDataSet.Close;
  ProviderEOF := True;
end;

function TDataDriverEh.RefreshReaderParamsFromCursor(DataSet: TDataSet): Boolean;
var
  FParams: TParams;
  Field: TField;
  I: Integer;
begin
  Result := False;
  FParams := nil;
{$IFDEF EH_LIB_5}
  if (ProviderDataSet <> nil) then
    FParams := IProviderSupport(ProviderDataSet).PSGetParams();
  if FParams <> nil then
    for I := 0 to FParams.Count - 1 do
    begin
      Field := DataSet.FindField(FParams[I].Name);
      if (Field <> nil) and not VarEquals(Field.Value, FParams[I].Value) then
      begin
        Result := True;
        Break;
      end;
    end;
{$ENDIF}
end;

procedure TDataDriverEh.SetReaderParamsFromCursor(DataSet: TDataSet);
var
  I: Integer;
  FParams: TParams;
begin
  FParams := nil;
{$IFDEF EH_LIB_5}
  if (ProviderDataSet <> nil) then
    FParams := IProviderSupport(ProviderDataSet).PSGetParams();
  if FParams <> nil then
  begin
    DataSet.FieldDefs.Update;
    for I := 0 to FParams.Count - 1 do
      with FParams[I] do
        if not Bound then
        begin
          AssignField(DataSet.FieldByName(Name));
          Bound := False;
        end;
  end;
{$ENDIF}
end;

procedure TDataDriverEh.BuildDataStruct(DataStruct: TMTDataStructEh);
var
  DS: TDataSet;
begin
  if Assigned(FOnBuildDataStruct) then
    OnBuildDataStruct(DataStruct)
  else if Assigned(FOnProduceDataReader) then
  begin
    DS := GetDataReader;
    DataStruct.BuildStructFromFields(DS.Fields);
  end else
    DefaultBuildDataStruct(DataStruct);
end;

procedure TDataDriverEh.DefaultBuildDataStruct(DataStruct: TMTDataStructEh);
begin
  if (ReaderDataSet <> nil) then
  begin
    DataStruct.BuildStructFromFields(ReaderDataSet.Fields);
    SetAutoIncFields(ReaderDataSet.Fields, DataStruct);
  end else if (ProviderDataSet <> nil) then
  begin
    if ProviderDataSet.FieldCount > 0 then
      DataStruct.BuildStructFromFields(ProviderDataSet.Fields)
    else
    begin
      ProviderDataSet.Active := True;
      DataStruct.BuildStructFromFields(ProviderDataSet.Fields);
      ProviderDataSet.Active := False;
    end;
    SetAutoIncFields(ProviderDataSet.Fields, DataStruct);
  end;
end;

procedure TDataDriverEh.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if AComponent = FProviderDataSet then
      ProviderDataSet := nil;
  end;
end;

function TDataDriverEh.GetDataReader: TDataSet;
begin
  if FReaderDataSet <> nil then
    Result := FReaderDataSet
  else
  begin
    FReaderDataSetFreeOnEof := False;
    ProviderEOF := False;
    if Assigned(FOnProduceDataReader) then
      OnProduceDataReader(FReaderDataSet, FReaderDataSetFreeOnEof)
    else
      DefaultProduceDataReader(FReaderDataSet, FReaderDataSetFreeOnEof);
    Result := FReaderDataSet;
  end;
end;

procedure TDataDriverEh.DefaultProduceDataReader(var DataSet: TDataSet; var FreeOnEof: Boolean);
begin
  if (ProviderDataSet <> nil) then
  begin
    ProviderDataSet.Active := True;
    ProviderDataSet.First;
    FreeOnEof := False;
    DataSet := ProviderDataSet;
  end;
end;

function TDataDriverEh.ReadData(MemTableData: TMemTableDataEh; Count: Integer): Integer;
var
  Rec: TMemoryRecordEh;
  AProviderEOF: Boolean;
begin
  Result := 0;
  if ProviderEOF = True then Exit;
  while Count <> 0 do
  begin
    Rec := MemTableData.RecordsList.NewRecord;
    try
      if Assigned(OnReadRecord)
        then OnReadRecord(MemTableData, Rec, AProviderEOF)
        else DefaultReadRecord(MemTableData, Rec, AProviderEOF);
    except
      Rec.Free;
      raise;
    end;
    ProviderEOF := AProviderEOF;
    if ProviderEOF
      then Rec.Free
      else MemTableData.RecordsList.FetchRecord(Rec);

    Inc(Result);
    if ProviderEOF then Exit;
    Dec(Count);
  end;
end;

procedure TDataDriverEh.DefaultReadRecord(MemTableData: TMemTableDataEh;
  Rec: TMemoryRecordEh; var ProviderEOF: Boolean);
var
  i: Integer;
begin
  ProviderEOF := False;
  if (ReaderDataSet = nil) or
   ((ReaderDataSet <> nil) and not ReaderDataSet.Active) or
   ((ReaderDataSet <> nil) and ReaderDataSet.Active and ReaderDataSet.Eof)
  then
    ProviderEOF := True;
  if (ReaderDataSet = nil) or (ProviderEOF = True) then
    Exit;

  for i := 0 to Rec.DataStruct.Count-1 do
    AssignFieldValue(MemTableData, Rec, i, dvvValueEh, ReaderDataSet);

  ReaderDataSet.Next;
end;

procedure TDataDriverEh.AssignFieldValue(MemTableData: TMemTableDataEh;
  MemRec: TMemoryRecordEh; DataFieldIndex: Integer;
  DataValueVersion: TDataValueVersionEh; ReaderDataSet: TDataSet);
begin
  if Assigned(OnAssignFieldValue)
    then OnAssignFieldValue(MemTableData, MemRec, DataFieldIndex, DataValueVersion, ReaderDataSet)
    else DefaultAssignFieldValue(MemTableData, MemRec, DataFieldIndex, DataValueVersion, ReaderDataSet);
end;

procedure TDataDriverEh.DefaultAssignFieldValue(MemTableData: TMemTableDataEh;
  MemRec: TMemoryRecordEh; DataFieldIndex: Integer;
  DataValueVersion: TDataValueVersionEh; ReaderDataSet: TDataSet);
var
  Field: TField;
begin
  Field := ReaderDataSet.FindField(MemRec.DataStruct[DataFieldIndex].FieldName);
  if Field <> nil then
    MemRec.Value[DataFieldIndex, DataValueVersion] := Field.Value;
end;

procedure TDataDriverEh.DefaultRefreshRecord(MemRecord: TMemoryRecordEh);
var
  vValues: Variant;
  i: Integer;
  KeyFound: Boolean;
  Bookmark: TBookmarkStr;
//  DeltaDataSet: TMemTableDataEh;
//  DeltaRec: TMemoryRecordEh;
begin
  if (ProviderDataSet <> nil) then
  begin
//    DeltaDataSet := CreateDeltaData;
//    DeltaDataSet.DataStruct.Assign(MemRecord.DataStruct);
    try

//      DeltaRec := DeltaDataSet.RecordsList.NewRecord;

      Bookmark := ProviderDataSet.Bookmark;
      try

        if MemRecord.UpdateStatus = usModified
          then vValues := MemRecord.DataValues[KeyFields, dvvOldValueEh]
          else vValues := MemRecord.DataValues[KeyFields, dvvValueEh];
        KeyFound := ProviderDataSet.Locate(KeyFields, vValues, []);

        if KeyFound then
//          for i := 0 to DeltaDataSet.DataStruct.Count-1 do
//            DeltaRec.Value[i, dvtValueEh] :=
            for i := 0 to MemRecord.DataStruct.Count-1 do
              AssignFieldValue(MemRecord.DataStruct.MemTableData, MemRecord, i,
                dvvRefreshValue, ReaderDataSet)
        else
          raise Exception.Create('Key is not found in ProviderDataSet');

      finally
        if (Bookmark <> '') and DataSetBookmarkValid(ProviderDataSet, Bookmark) then
          ProviderDataSet.Bookmark := Bookmark;
      end;

//      MemRecord.RefreshRecord(DeltaRec);

    finally
//      DeltaDataSet.Free;
    end;
//    Resync([]);
  end;
end;

procedure TDataDriverEh.RefreshRecord(MemRecord: TMemoryRecordEh);
begin
  if Assigned(OnRefreshRecord)
    then OnRefreshRecord(MemRecord.DataStruct.MemTableData, MemRecord)
    else DefaultRefreshRecord(MemRecord);
end;

procedure TDataDriverEh.SetKeyFields(const Value: String);
begin
  FKeyFields := Value;
end;

procedure TDataDriverEh.SetProviderDataSet(const Value: TDataSet);
begin
  if Value <> FProviderDataSet then
  begin
    FProviderDataSet := Value;
    if Value <> nil then Value.FreeNotification(Self);
  end;
end;

{
function TDataDriverEh.GetReaderDataSet: TDataSet;
begin
  Result := ProviderDataSet;
end;
}

procedure TDataDriverEh.SetProviderEOF(const Value: Boolean);
begin
  if FProviderEOF <> Value then
  begin
    FProviderEOF := Value;
    if FProviderEOF and (FReaderDataSet <> nil) and FReaderDataSetFreeOnEof then
    begin
      FReaderDataSet.Free;
      FReaderDataSetFreeOnEof := False;
    end;
    FReaderDataSet := nil;
  end;
end;

procedure TDataDriverEh.SetAutoIncFields(Fields: TFields; DataStruct: TMTDataStructEh);
begin
end;

{ TCustomSQLCommandEh }

constructor TCustomSQLCommandEh.Create(ADataDriver: TCustomSQLDataDriverEh);
begin
  inherited Create;
  FDataDriver := ADataDriver;
  FCommandText := TStringList.Create;
  TStringList(FCommandText).OnChange := CommandTextChanged;
end;

destructor TCustomSQLCommandEh.Destroy;
begin
  FCommandText.Free;
  inherited Destroy;
end;

function TCustomSQLCommandEh.GetCommandText: TStrings;
begin
  Result := FCommandText;
end;

procedure TCustomSQLCommandEh.SetCommandText(const Value: TStrings);
begin
  FCommandText.Assign(Value);
end;

function TCustomSQLCommandEh.Execute(var Cursor: TDataSet; var FreeOnEof: Boolean): Integer;
begin
  Result := -1;
  Cursor := nil;
end;

procedure TCustomSQLCommandEh.CommandTextChanged(Sender: TObject);
begin
end;

procedure TCustomSQLCommandEh.CommandTypeChanged;
begin
end;

function TCustomSQLCommandEh.GetCommandType: TSQLCommandTypeEh;
begin
  Result := FCommandType;
end;

procedure TCustomSQLCommandEh.SetCommandType(const Value: TSQLCommandTypeEh);
begin
  FCommandType := Value;
end;

procedure TCustomSQLCommandEh.RefreshParams(MemRecord: TMemoryRecordEh; DataValueVersion: TDataValueVersionEh);
begin
end;

function TCustomSQLCommandEh.GetOwner: TPersistent;
begin
  Result := FDataDriver;
end;

function TCustomSQLCommandEh.GetNamePath: String;
begin
  Result := 'SQLCommand';
end;

function TCustomSQLCommandEh.IsCommandTypeStored: Boolean;
begin
  Result := (FCommandType <> DefaultCommandType);
end;

function TCustomSQLCommandEh.DefaultCommandType: TSQLCommandTypeEh;
begin
  Result := DataDriver.GetDefaultCommandTypeFor(Self);
end;

procedure TCustomSQLCommandEh.Assign(Source: TPersistent);
begin
  if Source is TCustomSQLCommandEh then
    with (Source as TCustomSQLCommandEh) do
    begin
      Self.CommandText := CommandText;
      Self.CommandType := CommandType;
    end;
end;

procedure TCustomSQLCommandEh.AssignParams(AParams: TParams);
begin
end;

procedure TCustomSQLCommandEh.AssignToParams(AParams: TParams);
begin
end;

function TCustomSQLCommandEh.GetParams: TParams;
begin
  Result := nil;
end;

procedure TCustomSQLCommandEh.SetParams(AParams: TParams);
begin
end;

{ TBaseSQLCommandEh }

constructor TBaseSQLCommandEh.Create(ADataDriver: TBaseSQLDataDriverEh);
begin
  inherited Create(ADataDriver);
  FParams := TParams.Create(Self);
  FParamCheck := True;
end;

destructor TBaseSQLCommandEh.Destroy;
begin
  FParams.Free;
  inherited Destroy;
end;

procedure TBaseSQLCommandEh.RefreshParams(MemRecord: TMemoryRecordEh; DataValueVersion: TDataValueVersionEh);
var
  I: Integer;
begin
  for I := 0 to Params.Count - 1 do
  begin
    if Assigned(OnAssignParam)
      then OnAssignParam(Self, MemRecord, DataValueVersion, Params[I])
      else DefaultRefreshParam(MemRecord, DataValueVersion, Params[I]);
  end;
end;

procedure TBaseSQLCommandEh.DefaultRefreshParam(MemRecord: TMemoryRecordEh;
  DataValueVersion: TDataValueVersionEh; Param: TParam);
begin
  DataDriver.AssignCommandParam(Self, MemRecord, DataValueVersion, Param);
end;

function TBaseSQLCommandEh.GetParamCheck: Boolean;
begin
  Result := FParamCheck;
end;

procedure TBaseSQLCommandEh.SetParamCheck(const Value: Boolean);
begin
  FParamCheck := Value;
end;

procedure TBaseSQLCommandEh.SetParams(AParams: TParams);
begin
  if FParams <> AParams then
    FParams.Assign(AParams);
end;

function TBaseSQLCommandEh.GetParams: TParams;
begin
  Result := FParams;
end;

procedure TBaseSQLCommandEh.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if Source is TBaseSQLCommandEh then
    with (Source as TBaseSQLCommandEh) do
    begin
      Self.ParamCheck := ParamCheck;
      Self.Params := Params;
    end;
end;

procedure TBaseSQLCommandEh.CommandTextChanged(Sender: TObject);
var
  List: TParams;
begin
  inherited CommandTextChanged(Sender);
  if not (csReading in DataDriver.ComponentState) then
//    if ParamCheck then
//      Params.ParseSQL(CommandText.Text, True);
    if ParamCheck or (csDesigning in DataDriver.ComponentState) then
    begin
      List := TParams.Create(Self);
      try
        List.ParseSQL(CommandText.Text, True);
        List.AssignValues(Params);
        Params.Clear;
        Params.Assign(List);
      finally
        List.Free;
      end;
    end;
end;

function TBaseSQLCommandEh.GetDataDriver: TBaseSQLDataDriverEh;
begin
  Result := TBaseSQLDataDriverEh(inherited DataDriver);
end;

procedure TBaseSQLCommandEh.AssignParams(AParams: TParams);
begin
  Params := AParams;
end;

procedure TBaseSQLCommandEh.AssignToParams(AParams: TParams);
begin
  AParams.Assign(Params);
end;

{ TCustomSQLDataDriverEh }

constructor TCustomSQLDataDriverEh.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSelectCommand := CreateSelectCommand;
  FSelectCommand.FCommandType := GetDefaultCommandTypeFor(FSelectCommand);
  FUpdateCommand := CreateUpdateCommand;
  FUpdateCommand.FCommandType := GetDefaultCommandTypeFor(FUpdateCommand);
  FInsertCommand := CreateInsertCommand;
  FInsertCommand.FCommandType := GetDefaultCommandTypeFor(FInsertCommand);
  FDeleteCommand := CreateDeleteCommand;
  FDeleteCommand.FCommandType := GetDefaultCommandTypeFor(FDeleteCommand);
  FGetrecCommand := CreateGetrecCommand;
  FGetrecCommand.FCommandType := GetDefaultCommandTypeFor(FGetrecCommand);
  FSpecParams := TStringList.Create;
  ResolveToDataSet := False;
  FServiceCommand := CreateCommand;
end;

destructor TCustomSQLDataDriverEh.Destroy;
begin
  FSelectCommand.Free;
  FUpdateCommand.Free;
  FInsertCommand.Free;
  FDeleteCommand.Free;
  FGetrecCommand.Free;
  FServiceCommand.Free;
  FDesignDataBase := nil;
  FSpecParams.Free;
  inherited Destroy;
end;

procedure TCustomSQLDataDriverEh.SetSelectCommand(const Value: TCustomSQLCommandEh);
begin
  FSelectCommand.Assign(Value);
end;

procedure TCustomSQLDataDriverEh.SetDeleteCommand(const Value: TCustomSQLCommandEh);
begin
  FDeleteCommand.Assign(Value);
end;

procedure TCustomSQLDataDriverEh.SetInsertCommand(const Value: TCustomSQLCommandEh);
begin
  FInsertCommand.Assign(Value);
end;

procedure TCustomSQLDataDriverEh.SetGetrecCommand(const Value: TCustomSQLCommandEh);
begin
  FGetrecCommand.Assign(Value);
end;

procedure TCustomSQLDataDriverEh.SetUpdateCommand(const Value: TCustomSQLCommandEh);
begin
  FUpdateCommand.Assign(Value);
end;

procedure TCustomSQLDataDriverEh.DefaultProduceDataReader(var DataSet: TDataSet; var FreeOnEof: Boolean);
begin
  if ProviderDataSet <> nil
    then inherited DefaultProduceDataReader(DataSet, FreeOnEof)
    else ExecuteCommand(SelectCommand, DataSet, FreeOnEof);
end;

procedure TCustomSQLDataDriverEh.DefaultBuildDataStruct(DataStruct: TMTDataStructEh);
var
  AReaderDS: TDataSet;
  AFreeOnEof: Boolean;
begin
  if (ReaderDataSet <> nil) or (ProviderDataSet <> nil) then
    inherited DefaultBuildDataStruct(DataStruct)
  else
  begin
//    if AReaderDS = nil then
      ExecuteCommand(SelectCommand, AReaderDS, AFreeOnEof);
    if AReaderDS = nil then
      raise Exception.Create('SelectCommand.Execute does not get DataSet');
    AReaderDS.Active := True;
    DataStruct.BuildStructFromFields(AReaderDS.Fields);
    AReaderDS.Active := False;
    if AFreeOnEof then
      AReaderDS.Free;
  end;
end;

function TCustomSQLDataDriverEh.DefaultExecuteCommand(Command: TCustomSQLCommandEh;
  var Cursor: TDataSet; var FreeOnEof: Boolean): Integer;
var
  Processed: Boolean;
begin
  { TODO : Is it valid technology? }
  if HaveDataConnection then
    Result := Command.Execute(Cursor, FreeOnEof)
  else
  begin
    Result := -1;
    Processed := False;
    if Assigned(FDefaultSQLDataDriverResolver) then
      Result := FDefaultSQLDataDriverResolver.ExecuteCommand(Self, Command, Cursor, FreeOnEof, Processed);
    if not Processed then
      Result := Command.Execute(Cursor, FreeOnEof);
  end;
end;

function TCustomSQLDataDriverEh.ExecuteCommand(Command: TCustomSQLCommandEh;
  var Cursor: TDataSet; var FreeOnEof: Boolean): Integer;
begin
  if Assigned(OnExecuteCommand)
    then Result := OnExecuteCommand(Command, Cursor, FreeOnEof)
    else Result := DefaultExecuteCommand(Command, Cursor, FreeOnEof);
end;

procedure TCustomSQLDataDriverEh.DefaultRefreshRecord(MemRecord: TMemoryRecordEh);
var
  i: Integer;
  RecDataSet: TDataSet;
  AFreeOnEof: Boolean;
begin
  if ResolveToDataSet then
    inherited RefreshRecord(MemRecord)
  else
  begin
    GetrecCommand.RefreshParams(MemRecord, dvvOldestValue);
    ExecuteCommand(GetrecCommand, RecDataSet, AFreeOnEof);
    try
      if RecDataSet.IsEmpty then
        raise Exception.Create('There are no fresh record on server');

      for i := 0 to MemRecord.DataStruct.Count-1 do
        AssignFieldValue(MemRecord.DataStruct.MemTableData, MemRecord, i,
          dvvOldestValue, RecDataSet)
{      begin
        Field := RecDataSet.FindField(MemRecord.DataStruct[i].FieldName);
        if Field <> nil then
          MemRecord.Value[i, dvtOldestValue] := Field.Value;
      end;}

    finally
      if AFreeOnEof then
        RecDataSet.Free;
    end;
  end;
end;

function TCustomSQLDataDriverEh.DefaultUpdateRecord(MemTableData: TMemTableDataEh;
  MemRec: TMemoryRecordEh): Integer;
var
  Command: TCustomSQLCommandEh;
  ResDataSet: TDataSet;
  AFreeOnEof: Boolean;
begin
  Result := 0;
  if ResolveToDataSet then
    Result := inherited DefaultUpdateRecord(MemTableData, MemRec)
  else
  begin
    Command := nil;
    case MemRec.UpdateStatus of
      usModified: Command := UpdateCommand;
      usInserted: Command := InsertCommand;
      usDeleted: Command := DeleteCommand;
    end;
    if Command = nil then Exit;
    Command.RefreshParams(MemRec, dvvValueEh);
    Result := ExecuteCommand(Command, ResDataSet, AFreeOnEof);
    GetBackUpdatedValues(MemRec, Command, ResDataSet);
    if AFreeOnEof then
      ResDataSet.Free;
    MemRec.MergeChanges;
  end;
end;

procedure TCustomSQLDataDriverEh.GetBackUpdatedValues(MemRec: TMemoryRecordEh; Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
begin
  if Assigned(FOnGetBackUpdatedValues)
    then OnGetBackUpdatedValues(MemRec, Command, ResDataSet)
    else DefaultGetUpdatedServerValues(MemRec, Command, ResDataSet);
end;

procedure TCustomSQLDataDriverEh.DefaultGetUpdatedServerValues(
  MemRec: TMemoryRecordEh; Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
begin

end;

function TCustomSQLDataDriverEh.CreateDeleteCommand: TCustomSQLCommandEh;
begin
  Result := CreateCommand;
end;

function TCustomSQLDataDriverEh.CreateInsertCommand: TCustomSQLCommandEh;
begin
  Result := CreateCommand;
end;

function TCustomSQLDataDriverEh.CreateSelectCommand: TCustomSQLCommandEh;
begin
  Result := CreateCommand;
end;

function TCustomSQLDataDriverEh.CreateGetrecCommand: TCustomSQLCommandEh;
begin
  Result := CreateCommand;
end;

function TCustomSQLDataDriverEh.CreateUpdateCommand: TCustomSQLCommandEh;
begin
  Result := CreateCommand;
end;

{
function TCustomSQLDataDriverEh.GetReaderDataSet: TDataSet;
begin
  if ProviderDataSet <> nil
    then Result := inherited GetReaderDataSet
    else Result := FReaderDataSet;
end;
}

function TCustomSQLDataDriverEh.GetDefaultCommandTypeFor(Command: TCustomSQLCommandEh): TSQLCommandTypeEh;
begin
  if (Command = SelectCommand) or (Command = GetrecCommand)
    then Result := cthSelectQuery
    else Result := cthUpdateQuery;
end;

var
  DesignDataBuilderClasses: TList;
  DesignDataBuilderProcs: TList;

procedure RegisterDesignDataBuilderProcEh(DataDriverClass: TSQLDataDriverEhClass;
  DesignDataBaseProc: TSetDesignDataBaseProcEh);
var
  ExistsIdx: Integer;
begin
  if DesignDataBuilderClasses = nil then
  begin
    DesignDataBuilderClasses := TList.Create;
    DesignDataBuilderProcs := TList.Create;
  end;
  ExistsIdx := DesignDataBuilderClasses.IndexOf(TObject(DataDriverClass));
  if ExistsIdx >= 0 then
    DesignDataBuilderProcs[ExistsIdx] := @DesignDataBaseProc
  else
  begin
    DesignDataBuilderClasses.Add(TObject(DataDriverClass));
    DesignDataBuilderProcs.Add(@DesignDataBaseProc);
  end;
end;

procedure UnregisterDesignDataBuilderProcEh(DataDriverClass: TSQLDataDriverEhClass);
var
  ExistsIdx: Integer;
begin
  if DesignDataBuilderClasses = nil then Exit;
  ExistsIdx := DesignDataBuilderClasses.IndexOf(TObject(DataDriverClass));
  if ExistsIdx >= 0 then
  begin
    DesignDataBuilderClasses.Delete(ExistsIdx);
    DesignDataBuilderProcs.Delete(ExistsIdx);
  end;
end;

function GetDesignDataBuilderProcEh(DataDriverClass: TSQLDataDriverEhClass):
  TSetDesignDataBaseProcEh;

  function GetDatasetFeaturesDeep(ARootClass, AClass: TClass): Integer;
  begin
    Result := 0;
    while True do
    begin
      if ARootClass = AClass then
        Exit;
      Inc(Result);
      AClass := AClass.ClassParent;
      if AClass = nil then
      begin
        Result := MAXINT;
        Exit;
      end;
    end;
  end;

var
  Deep, MeenDeep, i: Integer;
  TargetClass: TSQLDataDriverEhClass;
begin
  Result := nil;
  if DesignDataBuilderClasses = nil then Exit;
  MeenDeep := MAXINT;
  for i := 0 to DesignDataBuilderClasses.Count - 1 do
  begin
    if DataDriverClass.InheritsFrom(TSQLDataDriverEhClass(DesignDataBuilderClasses[i])) then
    begin
      TargetClass := TSQLDataDriverEhClass(DesignDataBuilderClasses[i]);
      Deep := GetDatasetFeaturesDeep(TargetClass, DataDriverClass);
      if Deep < MeenDeep then
      begin
        MeenDeep := Deep;
        Result := TSetDesignDataBaseProcEh(DesignDataBuilderProcs[i]);
      end;
    end;
  end;
end;

function TCustomSQLDataDriverEh.CreateDesignDataBase: TComponent;
begin
  Result := nil;
end;

procedure TCustomSQLDataDriverEh.AssignFromDesignDriver(DesignDataDriver: TCustomSQLDataDriverEh);
begin
  SelectCommand := DesignDataDriver.SelectCommand;
  UpdateCommand := DesignDataDriver.UpdateCommand;
  InsertCommand := DesignDataDriver.InsertCommand;
  DeleteCommand := DesignDataDriver.DeleteCommand;
  GetrecCommand := DesignDataDriver.GetrecCommand;
end;

function TCustomSQLDataDriverEh.CreateDesignCopy: TCustomSQLDataDriverEh;
begin
  Result := TCustomSQLDataDriverEh.Create(nil);
  Result.SelectCommand := SelectCommand;
  Result.UpdateCommand := UpdateCommand;
  Result.InsertCommand := InsertCommand;
  Result.DeleteCommand := DeleteCommand;
  Result.GetrecCommand := GetrecCommand;
end;


function TCustomSQLDataDriverEh.GetSelectSQL: TStrings;
begin
  Result := SelectCommand.CommandText;
end;

procedure TCustomSQLDataDriverEh.SetSelectSQL(const Value: TStrings);
begin
  SelectCommand.CommandText := Value;
end;

function TCustomSQLDataDriverEh.GetDeleteSQL: TStrings;
begin
  Result := DeleteCommand.CommandText;
end;

procedure TCustomSQLDataDriverEh.SetDeleteSQL(const Value: TStrings);
begin
  DeleteCommand.CommandText := Value;
end;

function TCustomSQLDataDriverEh.GetGetrecSQL: TStrings;
begin
  Result := GetrecCommand.CommandText;
end;

procedure TCustomSQLDataDriverEh.SetGetrecSQL(const Value: TStrings);
begin
  GetrecCommand.CommandText := Value;
end;

function TCustomSQLDataDriverEh.GetInsertSQL: TStrings;
begin
  Result := InsertCommand.CommandText;
end;

procedure TCustomSQLDataDriverEh.SetInsertSQL(const Value: TStrings);
begin
  InsertCommand.CommandText := Value;
end;

function TCustomSQLDataDriverEh.GetUpdateSQL: TStrings;
begin
  Result := UpdateCommand.CommandText;
end;

procedure TCustomSQLDataDriverEh.SetUpdateSQL(const Value: TStrings);
begin
  UpdateCommand.CommandText := Value;
end;

function TCustomSQLDataDriverEh.GetDesignDataBase: TComponent;
var
  SetBaseProc: TSetDesignDataBaseProcEh;
begin
  Result := nil;
  SetBaseProc := GetDesignDataBuilderProcEh(TSQLDataDriverEhClass(ClassType));
  if @SetBaseProc = nil then Exit;
  SetBaseProc(Self);
  Result := FDesignDataBase;
end;

procedure TCustomSQLDataDriverEh.SetDesignDataBase(const Value: TComponent);
begin
  if FDesignDataBase <> Value then
  begin
    FDesignDataBase := Value;
    if Value <> nil then Value.FreeNotification(Self);
  end;
end;

procedure TCustomSQLDataDriverEh.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and
     (AComponent <> nil) and
     (FDesignDataBase = AComponent)
  then
    FDesignDataBase := nil;
end;

function TCustomSQLDataDriverEh.RefreshReaderParamsFromCursor(DataSet: TDataSet): Boolean;
var
  FParams: TParams;
  Field: TField;
  I: Integer;
begin
  if (ProviderDataSet <> nil) then
    Result := inherited RefreshReaderParamsFromCursor(DataSet)
  else
  begin
    Result := False;
    FParams := SelectCommand.GetParams;
    if FParams <> nil then
      for I := 0 to FParams.Count - 1 do
      begin
        Field := DataSet.FindField(FParams[I].Name);
        if (Field <> nil) and not VarEquals(Field.Value, FParams[I].Value) then
        begin
          Result := True;
          Break;
        end;
      end;
  end;
end;

procedure TCustomSQLDataDriverEh.SetReaderParamsFromCursor(DataSet: TDataSet);
var
  I: Integer;
  FParams: TParams;
begin
  if (ProviderDataSet <> nil) then
    inherited SetReaderParamsFromCursor(DataSet)
  else
  begin
    FParams := SelectCommand.GetParams;
    if FParams <> nil then
    begin
      DataSet.FieldDefs.Update;
      for I := 0 to FParams.Count - 1 do
        with FParams[I] do
        begin
//          if not Bound then
//          begin
            AssignField(DataSet.FieldByName(Name));
            Bound := False;
//          end;
        end;
    end;
    SelectCommand.SetParams(FParams);
  end;
end;

procedure TCustomSQLDataDriverEh.SetSpecParams(const Value: TStrings);
begin
  FSpecParams.Assign(Value);
end;

function TCustomSQLDataDriverEh.HaveDataConnection: Boolean;
begin
  Result := False;
end;

function TCustomSQLDataDriverEh.CreateCommand: TCustomSQLCommandEh;
begin
  Result := TCustomSQLCommandEh.Create(Self);
end;

procedure TCustomSQLDataDriverEh.SetServiceCommand(
  const Value: TCustomSQLCommandEh);
begin
  FServiceCommand := Value;
end;

procedure TCustomSQLDataDriverEh.UpdateServerService;
begin

end;

{ TBaseSQLDataDriverEh }

procedure TBaseSQLDataDriverEh.AssignCommandParam(
  Command: TBaseSQLCommandEh; MemRecord: TMemoryRecordEh;
  DataValueVersion: TDataValueVersionEh; Param: TParam);
begin
  if Assigned(OnAssignCommandParam)
    then OnAssignCommandParam(Command, MemRecord, DataValueVersion, Param)
    else DefaultAssignCommandParam(Command, MemRecord, DataValueVersion, Param);
end;


function TBaseSQLDataDriverEh.CreateDeleteCommand: TCustomSQLCommandEh;
begin
  Result := TBaseSQLCommandEh.Create(Self);
end;

function TBaseSQLDataDriverEh.CreateInsertCommand: TCustomSQLCommandEh;
begin
  Result := TBaseSQLCommandEh.Create(Self);
end;

function TBaseSQLDataDriverEh.CreateSelectCommand: TCustomSQLCommandEh;
begin
  Result := TBaseSQLCommandEh.Create(Self);
end;

function TBaseSQLDataDriverEh.CreateGetrecCommand: TCustomSQLCommandEh;
begin
  Result := TBaseSQLCommandEh.Create(Self);
end;

function TBaseSQLDataDriverEh.CreateUpdateCommand: TCustomSQLCommandEh;
begin
  Result := TBaseSQLCommandEh.Create(Self);
end;

procedure TBaseSQLDataDriverEh.DefaultAssignCommandParam(
  Command: TBaseSQLCommandEh; MemRecord: TMemoryRecordEh;
  DataValueVersion: TDataValueVersionEh; Param: TParam);
var
  FIndex: Integer;
begin
  FIndex := MemRecord.DataStruct.FieldIndex(Param.Name);
  if FIndex >= 0 then
  begin
    { TODO : Check DataType as in TParam.AssignFieldValue }
    if Command.ParamCheck then
      Param.DataType := MemRecord.DataStruct[FIndex].DataType;
    Param.Value := MemRecord.DataValues[Param.Name, DataValueVersion];
  end
  else if (UpperCase(Copy(Param.Name,1, Length('OLD_'))) = 'OLD_') then
  begin
    FIndex := MemRecord.DataStruct.FieldIndex(Copy(Param.Name, 5, 255));
    if FIndex >= 0 then
    begin
      if Command.ParamCheck then
        Param.DataType := MemRecord.DataStruct[FIndex].DataType;
      Param.Value := MemRecord.DataValues[Copy(Param.Name, 5, 255), dvvOldestValue];
    end
  end;
end;


procedure TBaseSQLDataDriverEh.DefaultGetUpdatedServerValues(
  MemRec: TMemoryRecordEh; Command: TCustomSQLCommandEh;
  ResDataSet: TDataSet);
var
  i: Integer;
  DataField: TMTDataFieldEh;
  ACommand: TBaseSQLCommandEh;
begin
  ACommand := TBaseSQLCommandEh(Command);
  // Use params
  for i := 0 to ACommand.Params.Count-1 do
  begin
    DataField := nil;
    if ACommand.Params[i].ParamType in [ptOutput, ptInputOutput, ptResult] then
      DataField := MemRec.DataStruct.FindField(ACommand.Params[i].Name);
    if DataField <> nil then
    { TODO : Assign server values in future }
      MemRec.DataValues[ACommand.Params[i].Name, dvvValueEh] := ACommand.Params[i].Value;
  end;

  // Use result dataset
  if (ResDataSet <> nil) and not ResDataSet.IsEmpty then
    for i := 0 to ResDataSet.FieldCount-1 do
    begin
      DataField := MemRec.DataStruct.FindField(ResDataSet.Fields[i].FieldName);
      if DataField <> nil then
      { TODO : Assign server values in future }
        MemRec.DataValues[ResDataSet.Fields[i].FieldName, dvvValueEh] := ResDataSet.Fields[i].Value;
    end;
end;

function TBaseSQLDataDriverEh.GetDeleteCommand: TBaseSQLCommandEh;
begin
  Result := TBaseSQLCommandEh(inherited DeleteCommand);
end;

procedure TBaseSQLDataDriverEh.SetDeleteCommand(const Value: TBaseSQLCommandEh);
begin
  inherited DeleteCommand := Value;
end;

function TBaseSQLDataDriverEh.GetInsertCommand: TBaseSQLCommandEh;
begin
  Result := TBaseSQLCommandEh(inherited InsertCommand);
end;

procedure TBaseSQLDataDriverEh.SetInsertCommand(const Value: TBaseSQLCommandEh);
begin
  inherited InsertCommand := Value;
end;

function TBaseSQLDataDriverEh.GetSelectCommand: TBaseSQLCommandEh;
begin
  Result := TBaseSQLCommandEh(inherited SelectCommand);
end;

procedure TBaseSQLDataDriverEh.SetSelectCommand(const Value: TBaseSQLCommandEh);
begin
  inherited SelectCommand := Value;
end;

function TBaseSQLDataDriverEh.GetGetrecCommand: TBaseSQLCommandEh;
begin
  Result := TBaseSQLCommandEh(inherited GetrecCommand);
end;

procedure TBaseSQLDataDriverEh.SetGetrecCommand(const Value: TBaseSQLCommandEh);
begin
  inherited GetrecCommand := Value;
end;

function TBaseSQLDataDriverEh.GetUpdateCommand: TBaseSQLCommandEh;
begin
  Result := TBaseSQLCommandEh(inherited UpdateCommand);
end;

procedure TBaseSQLDataDriverEh.SetUpdateCommand(const Value: TBaseSQLCommandEh);
begin
  inherited UpdateCommand := Value;
end;

{ TSQLDataDriverEh }

function TSQLDataDriverEh.CreateDeleteCommand: TCustomSQLCommandEh;
begin
  Result := TSQLCommandEh.Create(Self);
end;

function TSQLDataDriverEh.CreateGetrecCommand: TCustomSQLCommandEh;
begin
  Result := TSQLCommandEh.Create(Self);
end;

function TSQLDataDriverEh.CreateInsertCommand: TCustomSQLCommandEh;
begin
  Result := TSQLCommandEh.Create(Self);
end;

function TSQLDataDriverEh.CreateSelectCommand: TCustomSQLCommandEh;
begin
  Result := TSQLCommandEh.Create(Self);
end;

function TSQLDataDriverEh.CreateUpdateCommand: TCustomSQLCommandEh;
begin
  Result := TSQLCommandEh.Create(Self);
end;

{ TSQLDataDriverResolver }

function TSQLDataDriverResolver.ExecuteCommand(
  SQLDataDriver: TCustomSQLDataDriverEh; Command: TCustomSQLCommandEh;
  var Cursor: TDataSet; var FreeOnEof: Boolean; var Processed: Boolean): Integer;
begin
  Result := -1;
  if Assigned(OnExecuteCommand)
    then Result := OnExecuteCommand(SQLDataDriver, Command, Cursor, FreeOnEof, Processed)
    else Processed := False;
end;

{ TServerServiceEh }

constructor TServerServiceEh.Create(ADataDriver: TCustomSQLDataDriverEh);
begin
  inherited Create;
  FDataDriver := ADataDriver;
end;

destructor TServerServiceEh.Destroy;
begin

  inherited Destroy;
end;

procedure TServerServiceEh.GetBackUpdatedValues(MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
begin

end;

initialization
  RegisterDefaultSQLDataDriverResolver(TSQLDataDriverResolver.Create);
finalization
  FDefaultSQLDataDriverResolver.Free;
  FDefaultSQLDataDriverResolver := nil;
  DesignDataBuilderClasses.Free;
  DesignDataBuilderClasses := nil;
  DesignDataBuilderProcs.Free;
  DesignDataBuilderProcs := nil;
end.

