{
@abstract(Component wrapper for IFPS3 compiler and executer)
A component wrapper for IFPS3, including debugging support.

}
unit IFPS3CompExec;

interface

uses
  SysUtils, Classes, ifps3, ifps3debug, ifps3utl,
  ifpscomp, ifpidll2, ifpidll2runtime, ifps3ppc;


type
  {Alias to @link(ifps3.TIFPSCallingConvention)}
  TDelphiCallingConvention = ifps3.TIFPSCallingConvention;
  {Alias to @link(ifps3.TIFPSRuntimeClassImporter)}
  TIFPSRuntimeClassImporter = ifps3.TIFPSRuntimeClassImporter;
const
  {alias to @link(ifps3.cdRegister)}
  cdRegister = ifps3.cdRegister;
  {alias to @link(ifps3.cdPascal)}
  cdPascal = ifps3.cdPascal;
  {alias to @link(ifps3.cdCdecl)}
  CdCdecl = ifps3.CdCdecl;
  {alias to @link(ifps3.cdStdcall)}
  CdStdCall = ifps3.CdStdCall;
type
  TIFPS3CompExec = class;
  {Base class for all plugins for the component}
  TIFPS3Plugin = class(TComponent)
  protected
    procedure CompOnUses(CompExec: TIFPS3CompExec); virtual;
    procedure ExecOnUses(CompExec: TIFPS3CompExec); virtual;
    procedure CompileImport1(CompExec: TIFPS3CompExec); virtual;
    procedure CompileImport2(CompExec: TIFPS3CompExec); virtual;
    procedure ExecImport1(CompExec: TIFPS3CompExec; const ri: TIFPSRuntimeClassImporter); virtual;
    procedure ExecImport2(CompExec: TIFPS3CompExec; const ri: TIFPSRuntimeClassImporter); virtual;
  public
  end;
  {DLL Plugin allowes you to call DLLS from the script engine}
  TIFPS3DllPlugin = class(TIFPS3Plugin)
  protected
    procedure CompOnUses(CompExec: TIFPS3CompExec); override;
    procedure ExecOnUses(CompExec: TIFPS3CompExec); override;
  end;

  TIFPS3CEPluginItem = class(TCollectionItem)
  private
    FPlugin: TIFPS3Plugin;
    procedure SetPlugin(const Value: TIFPS3Plugin);
  protected
    function GetDisplayName: string; override;
  published
    property Plugin: TIFPS3Plugin read FPlugin write SetPlugin;
  end;
  TIFPS3CEPlugins = class(TCollection)
  private
    FCompExec: TIFPS3CompExec;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(CE: TIFPS3CompExec);
  end;

  {Options for the compiler: <br>
  icAllowUnit - Allow 'unit' instead of program headers<br>
  icAllowNoBegin - Allow the user to not have to write a main Begin<br>
  icAllowEnd - Allow that there is no ending End.<bR>
  }
  TIFPS3CompOptions = set of (icAllowNoBegin, icAllowUnit, icAllowNoEnd, icBooleanShortCircuit);
  {Script engine event function}
  TIFPSCompExecVerifyProc = procedure (Sender: TIFPS3CompExec; Proc: TIFPSInternalProcedure; const Decl: string; var Error: Boolean) of object;
  {Script engine event function}
  TIFPS3CompExecEvent = procedure (Sender: TIFPS3CompExec) of object;
  {Script engine event function}
  TIFPS3ClOnCompImport = procedure (Sender: TObject; x: TIFPSPascalCompiler) of object;
  {Script engine event function}
  TIFPS3ClOnExecImport = procedure (Sender: TObject; se: TIFPSExec; x: TIFPSRuntimeClassImporter) of object;
  {Script engine event function}
  TIFPSCEOnNeedFile = function (Sender: TObject; const OrginFileName: string; var FileName, Output: string): Boolean of object;
  {TIFPS3CompExec can be used for compiling and executing scripts}
  TIFPS3CompExec = class(TComponent)
  private
    FCanAdd: Boolean;
    FComp: TIFPSPascalCompiler;
    FCompOptions: TIFPS3CompOptions;
    FExec: TIFPSDebugExec;
    FSuppressLoadData: Boolean;
    FScript: TStrings;
    FOnLine: TNotifyEvent;
    FUseDebugInfo: Boolean;
    FOnAfterExecute, FOnCompile, FOnExecute: TIFPS3CompExecEvent;
    FOnCompImport: TIFPS3ClOnCompImport;
    FOnExecImport: TIFPS3ClOnExecImport;
    RI: TIFPSRuntimeClassImporter;
    FPlugins: TIFPS3CEPlugins;
    FPP: TIFPSPreProcessor;
    FMainFileName: string;
    FOnNeedFile: TIFPSCEOnNeedFile;
    FUsePreProcessor: Boolean;
    FDefines: TStrings;
    FOnVerifyProc: TIFPSCompExecVerifyProc;
    function GetRunning: Boolean;
    procedure SetScript(const Value: TStrings);
    function GetCompMsg(i: Integer): TIFPSPascalCompilerMessage;
    function GetCompMsgCount: Longint;
    function GetAbout: string;
    function ScriptUses(Sender: TIFPSPascalCompiler; const Name: string): Boolean;
    function GetExecErrorByteCodePosition: Cardinal;
    function GetExecErrorCode: TIFError;
    function GetExecErrorParam: string;
    function GetExecErrorProcNo: Cardinal;
    function GetExecErrorString: string;
    function GetExecErrorPosition: Cardinal;
    procedure OnLineEvent; virtual;
    function GetExecErrorCol: Cardinal;
    function GetExecErrorRow: Cardinal;
    procedure SetMainFileName(const Value: string); virtual;
    function GetExecErrorFileName: string;
    procedure SetDefines(const Value: TStrings);
  public
    property SuppressLoadData: Boolean read FSuppressLoadData write FSuppressLoadData;
    {Load data into the exec, you only need to call this when SuppressLoadData is true}
    function LoadExec: Boolean;
    {Stop the script}
    procedure Stop; virtual;
    {Create an instance of the CompExec component}
    constructor Create(AOwner: TComponent); override;
    {Dstroy the CompExec component}
    destructor Destroy; override;
    {Compile the script}
    function Compile: Boolean; virtual;
    {Execute the compiled script}
    function Execute: Boolean; virtual;
    {Is the script running now?}
    property Running: Boolean read GetRunning;
    {Returns the compiled data, first call @link(Compile)}
    procedure GetCompiled(var data: string);
    {Load compiled data in the script engine}
    procedure SetCompiled(const Data: string);
    {PascalCompiler object}
    property Comp: TIFPSPascalCompiler read FComp;
    {Exec object}
    property Exec: TIFPSDebugExec read FExec;
    {Returns the number of compiler messages}
    property CompilerMessageCount: Longint read GetCompMsgCount;
    {Return compiler message number I}
    property CompilerMessages[i: Longint]: TIFPSPascalCompilerMessage read GetCompMsg;
    {Convert a compiler message to a string}
    function CompilerErrorToStr(I: Longint): string;
    {Runtime errors: error code}
    property ExecErrorCode: TIFError read GetExecErrorCode;
    {Runtime errors: more information for the error}
    property ExecErrorParam: string read GetExecErrorParam;
    {Convert an errorcode + errorparam to a string}
    property ExecErrorToString: string read GetExecErrorString;
    {The procedure number the runtime error occured in}
    property ExecErrorProcNo: Cardinal read GetExecErrorProcNo;
    {The bytecode offset the runtime error occured in}
    property ExecErrorByteCodePosition: Cardinal read GetExecErrorByteCodePosition;
    {The offset in the script the error occured in, does not work when DebugInfo = False}
    property ExecErrorPosition: Cardinal read GetExecErrorPosition;
    {The Row in the script the error occured in, does not work when DebugInfo = False}
    property ExecErrorRow: Cardinal read GetExecErrorRow;
    {The Col in the script the error occured in, does not work when DebugInfo = False}
    property ExecErrorCol: Cardinal read GetExecErrorCol;
    {Runtime errors: Exec Error filename}
    property ExecErrorFileName: string read GetExecErrorFileName;
    {Add a function to the script engine}
    function AddFunctionEx(Ptr: Pointer; const Decl: string; CallingConv: TDelphiCallingConvention): Boolean;
    {Add a function to the script engine, with @link(cdRegister) as a calling convention}
    function AddFunction(Ptr: Pointer; const Decl: string): Boolean;

    {Add a method to the script engine, slf should be the self pointer, ptr should be the procedural pointer, for example:
    Form1.Show<br>
      AddMethod(Form1, @@TForm1.Show, 'procedure Show;', cdRegister);
    }
    function AddMethodEx(Slf, Ptr: Pointer; const Decl: string; CallingConv: TDelphiCallingConvention): Boolean;
    {Add a method to the script engine, with @link(cdRegister) as a calling convention}
    function AddMethod(Slf, Ptr: Pointer; const Decl: string): Boolean;
    {Add a variable to the script engine that can be used at runtime with the @link(GetVariable) function}
    function AddRegisteredVariable(const VarName, VarType: string): Boolean;
    {Add a variable to the script engine that can be used at runtime with the @link(SetPointerToData) function}
    function AddRegisteredPTRVariable(const VarName, VarType: string): Boolean;
    {Returns the variable with the name Name}
    function GetVariable(const Name: string): PIFVariant;
    {Set a variable to an object instance}
    function SetVarToInstance(const VarName: string; cl: TObject): Boolean;
    {Set a pointer variable to data}
    procedure SetPointerToData(const VarName: string; Data: Pointer; aType: TIFTypeRec);
    {Translate a Proc+ByteCode position into an offset in the script}
    function TranslatePositionPos(Proc, Position: Cardinal; var Pos: Cardinal; var fn: string): Boolean;
    {Translate a Proc+ByteCode position into an row/col in the script}
    function TranslatePositionRC(Proc, Position: Cardinal; var Row, Col: Cardinal; var fn: string): Boolean;
    {Get proc as TMethod, cast this to a method pointer and call it}
    function GetProcMethod(const ProcName: string): TMethod;
    {Execute a function}
    function ExecuteFunction(const Params: array of Variant; const ProcName: string): Variant;
  published
    {About this script engine}
    property About: string read GetAbout;
    {The current script}
    property Script: TStrings read FScript write SetScript;
    {Compiler options}
    property CompilerOptions: TIFPS3CompOptions read FCompOptions write FCompOptions;
    {OnLine event, is called after each bytecode position, useful for checking messages to make sure longer scripts don't block the application} 
    property OnLine: TNotifyEvent read FOnLine write FOnLine;
    {OnCompile event is called when the script is about to be compiled}
    property OnCompile: TIFPS3CompExecEvent read FOnCompile write FOnCompile;
    {OnExecute event is called when the script is about to the executed,
    useful for changing variables within the script}
    property OnExecute: TIFPS3CompExecEvent read FOnExecute write FOnExecute;
    {OnAfterExecute is called when the script is done executing}
    property OnAfterExecute: TIFPS3CompExecEvent read FOnAfterExecute write FOnAfterExecute;
    {OnCompImport is called when you can import your functions and classes into the compiler}
    property OnCompImport: TIFPS3ClOnCompImport read FOnCompImport write FOnCompImport;
    {OnCompImport is called when you can import your functions and classes into the exec}
    property OnExecImport: TIFPS3ClOnExecImport read FOnExecImport write FOnExecImport;
    {UseDebugInfo should be true when you want to use debug information, like position information in the script, it does make the executing a bit slower}
    property UseDebugInfo: Boolean read FUseDebugInfo write FUseDebugInfo default True;
    {Plugins for this component}
    property Plugins: TIFPS3CEPlugins read FPlugins write FPlugins;
    {Main file name, this is only relevant to the errors}
    property MainFileName: string read FMainFileName write SetMainFileName;
    {Use the preprocessor, make sure the OnNeedFile event is assigned}
    property UsePreProcessor: Boolean read FUsePreProcessor write FUsePreProcessor;
    {OnNeedFile is called when the preprocessor is used and an include statement is used}
    property OnNeedFile: TIFPSCEOnNeedFile read FOnNeedFile write FOnNeedFile;
    {Compiler Defines}
    property Defines: TStrings read FDefines write SetDefines;
    {OnVerifyProc is called to check if a procedure matches the expected header}
    property OnVerifyProc: TIFPSCompExecVerifyProc read FOnVerifyProc write FOnVerifyProc;
  end;

  TIFPSBreakPointInfo = class
  private
    FLine: Longint;
    FFileNameHash: Longint;
    FFileName: string;
    procedure SetFileName(const Value: string);
  public
    property FileName: string read FFileName write SetFileName;
    property FileNameHash: Longint read FFileNameHash;
    property Line: Longint read FLine write FLine;
  end;
  {OnLineInfo event}
  TIFPS3OnLineInfo = procedure (Sender: TObject; const FileName: string; Position, Row, Col: Cardinal) of object;
  {TIFPS3DebugCompExec has all features of @link(TIFPS3CompExec) and also supports debugging}
  TIFPS3DebugCompExec = class(TIFPS3CompExec)
  private
    FOnIdle: TNotifyEvent;
    FBreakPoints: TIFList;
    FOnLineInfo: TIFPS3OnLineInfo;
    FLastRow: Cardinal;
    FOnBreakpoint: TIFPS3OnLineInfo;
    procedure SetMainFileName(const Value: string); override;
    function GetBreakPoint(I: Integer): TIFPSBreakPointInfo;
    function GetBreakPointCount: Longint;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Pause; virtual;
    procedure Resume; virtual;

    procedure StepInto; virtual;
    procedure StepOver; virtual;
    {Set a breakpoint at line Line}
    procedure SetBreakPoint(const Fn: string; Line: Longint);
    {clear the breakpoint at line Line}
    procedure ClearBreakPoint(const Fn: string; Line: Longint);
    {Returns the number of currently set breakpoints}
    property BreakPointCount: Longint read GetBreakPointCount;
    {Return breakpoint number I}
    property BreakPoint[I: Longint]: TIFPSBreakPointInfo read GetBreakPoint;
    {Has a breakpoint on line(Line) ?}
    function HasBreakPoint(const Fn: string; Line: Longint): Boolean;
    {Clear All Breakpoints}
    procedure ClearBreakPoints;
    {Returns the contents of a variable, formatted for a watch window}
    function GetVarContents(const Name: string): string;
  published
    {The on Idle event is called when the script engine is paused or on a breakpoint. You
    should call Application.ProcessMessages from here and call resume when you are done. If
    you don't assign a handler to this event, the script engine will not pause or breakpoint}
    property OnIdle: TNotifyEvent read FOnIdle write FOnIdle;
    {OnLineInfo is called for each statement the script engine has debuginfo (row, col, pos) for}
    property OnLineInfo: TIFPS3OnLineInfo read FOnLineInfo write FOnLineInfo;
    {OnBreakPoint is called when the script engine is at a breakpoint}
    property OnBreakpoint: TIFPS3OnLineInfo read FOnBreakpoint write FOnBreakpoint;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Innerfuse', [TIFPS3CompExec, TIFPS3DebugCompExec, TIFPS3DllPlugin]);
end;

function CompScriptUses(Sender: TIFPSPascalCompiler; const Name: string): Boolean;
begin
  Result := TIFPS3CompExec(Sender.ID).ScriptUses(Sender, Name);
end;

procedure ExecOnLine(Sender: TIFPSExec);
begin
  if assigned(TIFPS3CompExec(Sender.ID).FOnLine) then
  begin
    TIFPS3CompExec(Sender.ID).OnLineEvent;
  end;
end;

function CompExportCheck(Sender: TIFPSPascalCompiler; Proc: TIFPSInternalProcedure; const ProcDecl: string): Boolean;
begin
  if assigned(TIFPS3CompExec(Sender.ID).FOnVerifyProc) then
  begin
    Result := false;
    TIFPS3CompExec(Sender.ID).FOnVerifyProc(Sender.Id, Proc, ProcDecl, Result);
    Result := not Result;
  end else
    Result := True;
end;

{ TIFPS3CompilerPlugin }
procedure TIFPS3Plugin.CompileImport1(CompExec: TIFPS3CompExec);
begin
  // do nothing
end;

procedure TIFPS3Plugin.CompileImport2(CompExec: TIFPS3CompExec);
begin
  // do nothing
end;

procedure TIFPS3Plugin.CompOnUses(CompExec: TIFPS3CompExec);
begin
 // do nothing
end;

procedure TIFPS3Plugin.ExecImport1(CompExec: TIFPS3CompExec; const ri: TIFPSRuntimeClassImporter);
begin
  // do nothing
end;

procedure TIFPS3Plugin.ExecImport2(CompExec: TIFPS3CompExec; const ri: TIFPSRuntimeClassImporter);
begin
  // do nothing
end;

procedure TIFPS3Plugin.ExecOnUses(CompExec: TIFPS3CompExec);
begin
 // do nothing
end;


{ TIFPS3CompExec }

function TIFPS3CompExec.AddFunction(Ptr: Pointer;
  const Decl: string): Boolean;
begin
  Result := AddFunctionEx(Ptr, Decl, cdRegister);
end;

function TIFPS3CompExec.AddFunctionEx(Ptr: Pointer; const Decl: string;
  CallingConv: TDelphiCallingConvention): Boolean;
var
  P: TIFPSRegProc;
begin
  if not FCanAdd then begin Result := False; exit; end;
  p := Comp.AddDelphiFunction(Decl);
  if p <> nil then
  begin
    Exec.RegisterDelphiFunction(Ptr, p.Name, CallingConv);
    Result := True;
  end else Result := False;
end;

function TIFPS3CompExec.AddRegisteredVariable(const VarName,
  VarType: string): Boolean;
var
  FVar: TIFPSVar;
begin
  if not FCanAdd then begin Result := False; exit; end;
  FVar := FComp.AddUsedVariableN(varname, vartype);
  if fvar = nil then
    result := False
  else begin
    fvar.exportname := fvar.Name;
    Result := True;
  end;
end;

function CENeedFile(Sender: TIFPSPreProcessor; const callingfilename: string; var FileName, Output: string): Boolean;
begin
  if @TIFPS3CompExec(Sender.ID).OnNeedFile = nil then
  begin
    Result := False;
  end else
    Result := TIFPS3CompExec(Sender.ID).OnNeedFile(Sender.ID, callingfilename, FileName, Output);
end;

procedure CompTranslateLineInfo(Sender: TIFPSPascalCompiler; var Pos, Row, Col: Cardinal; var Name: string);
var
  res: TIFPSLineInfoResults;
begin
  if TIFPS3CompExec(Sender.ID).FPP.CurrentLineInfo.GetLineInfo(Pos, Res) then
  begin
    Pos := Res.Pos;
    Row := Res.Row;
    Col := Res.Col;
    Name := Res.Name;
  end;
end;

function TIFPS3CompExec.Compile: Boolean;
var
  i: Longint;
  dta: string;
begin
  FExec.Clear;
  FExec.CMD_Err(erNoError);
  FExec.ClearspecialProcImports;
  FExec.ClearFunctionList;
  if ri <> nil then
  begin
    RI.Free;
    RI := nil;
  end;
  RI := TIFPSRuntimeClassImporter.Create;
  for i := 0 to FPlugins.Count -1 do
  begin
     TIFPS3CEPluginItem(FPlugins.Items[i]).Plugin.ExecImport1(Self, ri);
  end;
  if assigned(FOnExecImport) then
    FOnExecImport(Self, FExec, RI);
  for i := 0 to FPlugins.Count -1 do
  begin
    TIFPS3CEPluginItem(FPlugins.Items[i]).Plugin.ExecImport2(Self, ri);
  end;
  RegisterClassLibraryRuntime(Exec, RI);
  for i := 0 to FPlugins.Count -1 do
  begin
    TIFPS3CEPluginItem(FPlugins.Items[i]).Plugin.ExecOnUses(Self);
  end;
  FCanAdd := True;
  FComp.BooleanShortCircuit := icBooleanShortCircuit in FCompOptions;
  FComp.AllowNoBegin := icAllowNoBegin in FCompOptions;
  FComp.AllowUnit := icAllowUnit in FCompOptions;
  FComp.AllowNoEnd := icAllowNoEnd in FCompOptions;
  if FUsePreProcessor then
  begin
    FPP.Defines.Assign(FDefines);
    FComp.OnTranslateLineInfo := CompTranslateLineInfo;
    Fpp.MainFile := FScript.Text;
    Fpp.MainFileName := FMainFileName;
    try
      Fpp.PreProcess(FMainFileName, dta);
      if FComp.Compile(dta) then
      begin
        FCanAdd := False;
        if (not SuppressLoadData) and (not LoadExec) then
        begin
          Result := False;
        end else
          Result := True;
      end else Result := False;
      Fpp.AdjustMessages(Comp);
    finally
      FPP.Clear;
    end;
  end else
  begin
    FComp.OnTranslateLineInfo := nil;
    if FComp.Compile(FScript.Text) then
    begin
      FCanAdd := False;
      if not LoadExec then
      begin
        Result := False;
      end else
        Result := True;
    end else Result := False;
  end;
end;

function TIFPS3CompExec.CompilerErrorToStr(I: Integer): string;
begin
  Result := CompilerMessages[i].MessageToString;
end;

constructor TIFPS3CompExec.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FComp := TIFPSPascalCompiler.Create;
  FExec := TIFPSDebugExec.Create;
  FScript := TStringList.Create;
  FPlugins := TIFPS3CEPlugins.Create(self);

  FComp.ID := Self;
  FComp.OnUses := CompScriptUses;
  FComp.OnExportCheck := CompExportCheck;
  FExec.Id := Self;
  FExec.OnRunLine:= ExecOnLine;

  FUseDebugInfo := True;

  FPP := TIFPSPreProcessor.Create;
  FPP.Id := Self;
  FPP.OnNeedFile := CENeedFile;

  FDefines := TStringList.Create;
end;

destructor TIFPS3CompExec.Destroy;
begin
  FDefines.Free;

  FPP.Free;
  RI.Free;
  FPlugins.Free;
  FScript.Free;
  FExec.Free;
  FComp.Free;
  inherited Destroy;
end;

function TIFPS3CompExec.Execute: Boolean;
begin
  if SuppressLoadData then
    LoadExec;
  if @FOnExecute <> nil then
    FOnExecute(Self);
  FExec.DebugEnabled := FUseDebugInfo;
  Result := FExec.RunScript and (FExec.ExceptionCode = erNoError) ;
  if @FOnAfterExecute <> nil then
    FOnAfterExecute(Self);
end;

function TIFPS3CompExec.GetAbout: string;
begin
  Result := TIFPSExec.About;
end;

procedure TIFPS3CompExec.GetCompiled(var data: string);
begin
  if not FComp.GetOutput(Data) then
    raise Exception.Create('Script is not compiled');
end;

function TIFPS3CompExec.GetCompMsg(i: Integer): TIFPSPascalCompilerMessage;
begin
  Result := FComp.Msg[i];
end;

function TIFPS3CompExec.GetCompMsgCount: Longint;
begin
  Result := FComp.MsgCount;
end;

function TIFPS3CompExec.GetExecErrorByteCodePosition: Cardinal;
begin
  Result := Exec.ExceptionPos;
end;

function TIFPS3CompExec.GetExecErrorCode: TIFError;
begin
  Result := Exec.ExceptionCode;
end;

function TIFPS3CompExec.GetExecErrorParam: string;
begin
  Result := Exec.ExceptionString;
end;

function TIFPS3CompExec.GetExecErrorPosition: Cardinal;
begin
  Result := FExec.TranslatePosition(Exec.ExceptionProcNo, Exec.ExceptionPos);
end;

function TIFPS3CompExec.GetExecErrorProcNo: Cardinal;
begin
  Result := Exec.ExceptionProcNo;
end;

function TIFPS3CompExec.GetExecErrorString: string;
begin
  Result := TIFErrorToString(Exec.ExceptionCode, Exec.ExceptionString);
end;

function TIFPS3CompExec.GetVariable(const Name: string): PIFVariant;
begin
  Result := FExec.GetVar2(name);
end;

function TIFPS3CompExec.LoadExec: Boolean;
var
  s: string;
begin
  if (not FComp.GetOutput(s)) or (not FExec.LoadData(s)) then
  begin
    Result := False;
    exit;
  end;
  if FUseDebugInfo then
  begin
    FComp.GetDebugOutput(s);
    FExec.LoadDebugData(s);
  end;
  Result := True;
end;

function TIFPS3CompExec.ScriptUses(Sender: TIFPSPascalCompiler;
  const Name: string): Boolean;
var
  i: Longint;
begin
  if Name = 'SYSTEM' then
  begin
    for i := 0 to FPlugins.Count -1 do
    begin
      TIFPS3CEPluginItem(FPlugins.Items[i]).Plugin.CompOnUses(Self);
    end;
    for i := 0 to FPlugins.Count -1 do
    begin
      TIFPS3CEPluginItem(FPlugins.Items[i]).Plugin.CompileImport1(self);
    end;
    if assigned(FOnCompImport) then
      FOnCompImport(Self, Comp);
    for i := 0 to FPlugins.Count -1 do
    begin
      TIFPS3CEPluginItem(FPlugins.Items[i]).Plugin.CompileImport2(Self);
    end;
    if assigned(FOnCompile) then
      FOnCompile(Self);
    Result := True;
  end else begin
    Sender.MakeError('', ecUnknownIdentifier, Name);
    Result := False;
  end;
end;

procedure TIFPS3CompExec.SetCompiled(const Data: string);
var
  i: Integer;
begin
  FExec.Clear;
  FExec.ClearspecialProcImports;
  FExec.ClearFunctionList;
  if ri <> nil then
  begin
    RI.Free;
    RI := nil;
  end;
  RI := TIFPSRuntimeClassImporter.Create;
  if assigned(FOnExecImport) then
    FOnExecImport(Self, FExec, RI);
  RegisterClassLibraryRuntime(Exec, RI);
  for i := 0 to FPlugins.Count -1 do
  begin
    TIFPS3CEPluginItem(FPlugins.Items[i]).Plugin.ExecOnUses(Self);
  end;
  if not FExec.LoadData(Data) then
    raise Exception.Create(GetExecErrorString);
end;

function TIFPS3CompExec.SetVarToInstance(const VarName: string; cl: TObject): Boolean;
var
  p: PIFVariant;
begin
  p := GetVariable(VarName);
  if p <> nil then
  begin
    SetVariantToClass(p, cl);
    result := true;
  end else result := false;
end;

procedure TIFPS3CompExec.SetScript(const Value: TStrings);
begin
  FScript.Assign(Value);
end;


function TIFPS3CompExec.AddMethod(Slf, Ptr: Pointer;
  const Decl: string): Boolean;
begin
  Result := AddMethodEx(Slf, Ptr, Decl, cdRegister);
end;

function TIFPS3CompExec.AddMethodEx(Slf, Ptr: Pointer; const Decl: string;
  CallingConv: TDelphiCallingConvention): Boolean;
var
  P: TIFPSRegProc;
begin
  if not FCanAdd then begin Result := False; exit; end;
  p := Comp.AddDelphiFunction(Decl);
  if p <> nil then
  begin
    Exec.RegisterDelphiMethod(Slf, Ptr, p.Name, CallingConv);
    Result := True;
  end else Result := False;
end;

procedure TIFPS3CompExec.OnLineEvent;
begin
  if @FOnLine <> nil then FOnLine(Self);
end;

function TIFPS3CompExec.GetRunning: Boolean;
begin
  Result := FExec.Status = isRunning;
end;

function TIFPS3CompExec.GetExecErrorCol: Cardinal;
var
  s: string;
  D1: Cardinal;
begin
  if not TranslatePositionRC(Exec.ExceptionProcNo, Exec.ExceptionPos, D1, Result, s) then
    Result := 0;
end;

function TIFPS3CompExec.TranslatePositionPos(Proc, Position: Cardinal;
  var Pos: Cardinal; var fn: string): Boolean;
var
  D1, D2: Cardinal;
begin
  Result := Exec.TranslatePositionEx(Exec.ExceptionProcNo, Exec.ExceptionPos, Pos, D1, D2, fn);
end;

function TIFPS3CompExec.TranslatePositionRC(Proc, Position: Cardinal;
  var Row, Col: Cardinal; var fn: string): Boolean;
var
  d1: Cardinal;
begin
  Result := Exec.TranslatePositionEx(Proc, Position, d1, Row, Col, fn);
end;


function TIFPS3CompExec.GetExecErrorRow: Cardinal;
var
  D1: Cardinal;
  s: string;
begin
  if not TranslatePositionRC(Exec.ExceptionProcNo, Exec.ExceptionPos, Result, D1, s) then
    Result := 0;
end;

procedure TIFPS3CompExec.Stop;
begin
  if FExec.Status = isRunning then
    FExec.Stop
  else
    raise Exception.Create('Not running');
end;

function TIFPS3CompExec.GetProcMethod(const ProcName: string): TMethod;
begin
  Result := FExec.GetProcAsMethodN(ProcName)
end;

procedure TIFPS3CompExec.SetMainFileName(const Value: string);
begin
  FMainFileName := Value;
end;

function TIFPS3CompExec.GetExecErrorFileName: string;
var
  D1, D2: Cardinal;
begin
  if not TranslatePositionRC(Exec.ExceptionProcNo, Exec.ExceptionPos, D1, D2, Result) then
    Result := '';
end;

procedure TIFPS3CompExec.SetPointerToData(const VarName: string;
  Data: Pointer; aType: TIFTypeRec);
var
  v: PIFVariant;
  t: TIFPSVariantIFC;
begin
  v := GetVariable(VarName);
  if (Atype = nil) or (v = nil) then raise Exception.Create('Unable to find variable');
  t.Dta := @PIFPSVariantData(v).Data;
  t.aType := v.FType;
  t.VarParam := false;
  VNSetPointerTo(t, Data, aType);
end;

function TIFPS3CompExec.AddRegisteredPTRVariable(const VarName,
  VarType: string): Boolean;
var
  FVar: TIFPSVar;
begin
  if not FCanAdd then begin Result := False; exit; end;
  FVar := FComp.AddUsedVariableN(varname, vartype);
  if fvar = nil then
    result := False
  else begin
    fvar.exportname := fvar.Name;
    fvar.SaveAsPointer := true;
    Result := True;
  end;
end;

procedure TIFPS3CompExec.SetDefines(const Value: TStrings);
begin
  FDefines.Assign(Value);
end;

function TIFPS3CompExec.ExecuteFunction(const Params: array of Variant;
  const ProcName: string): Variant;
begin
  Result := Exec.RunProcPN(Params, ProcName);
end;

{ TIFPS3DllPlugin }

procedure TIFPS3DllPlugin.CompOnUses;
begin
  CompExec.Comp.OnExternalProc := DllExternalProc;
end;

procedure TIFPS3DllPlugin.ExecOnUses;
begin
  RegisterDLLRuntime(CompExec.Exec);
end;



{ TIFPS3DebugCompExec }

procedure LineInfo(Sender: TIFPSDebugExec; const FileName: string; Position, Row, Col: Cardinal);
var
  Dc: TIFPS3DebugCompExec;
  h, i: Longint;
  bi: TIFPSBreakPointInfo;
begin
  Dc := Sender.Id;
  if @dc.FOnLineInfo <> nil then dc.FOnLineInfo(dc, FileName, Position, Row, Col);
  if row = dc.FLastRow then exit;
  dc.FLastRow := row;
  h := MakeHash(filename);
  bi := nil;
  for i := DC.FBreakPoints.Count -1 downto 0 do
  begin
    bi := Dc.FBreakpoints[i];
    if (h = bi.FileNameHash) and (FileName = bi.FileName) and (Cardinal(bi.Line) = Row) then
    begin
      Break;
    end;
    Bi := nil;
  end;
  if bi <> nil then
  begin
    if @dc.FOnBreakpoint <> nil then dc.FOnBreakpoint(dc, FileName, Position, Row, Col);
    dc.Pause;
  end;
end;

procedure IdleCall(Sender: TIFPSDebugExec);
var
  Dc: TIFPS3DebugCompExec;
begin
  Dc := Sender.Id;
  if @dc.FOnIdle <> nil then
    dc.FOnIdle(DC)
  else
    dc.Exec.Run;
end;

procedure TIFPS3DebugCompExec.ClearBreakPoint(const Fn: string; Line: Integer);
var
  h, i: Longint;
  bi: TIFPSBreakPointInfo;
begin
  h := MakeHash(Fn);
  for i := FBreakPoints.Count -1 downto 0 do
  begin
    bi := FBreakpoints[i];
    if (h = bi.FileNameHash) and (Fn = bi.FileName) and (bi.Line = Line) then
    begin
      FBreakPoints.Delete(i);
      bi.Free;
      Break;
    end;
  end;
end;

procedure TIFPS3DebugCompExec.ClearBreakPoints;
var
  i: Longint;
begin
  for i := FBreakPoints.Count -1 downto 0 do
    TIFPSBreakPointInfo(FBreakPoints[i]).Free;
  FBreakPoints.Clear;;
end;

constructor TIFPS3DebugCompExec.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBreakPoints := TIFList.Create;
  FExec.OnSourceLine := LineInfo;
  FExec.OnIdleCall := IdleCall;
end;

destructor TIFPS3DebugCompExec.Destroy;
var
  i: Longint;
begin
  for i := FBreakPoints.Count -1 downto 0 do
  begin
    TIFPSBreakPointInfo(FBreakPoints[i]).Free;
  end;
  FBreakPoints.Free;
  inherited Destroy;
end;

function TIFPS3DebugCompExec.GetBreakPoint(I: Integer): TIFPSBreakPointInfo;
begin
  Result := FBreakPoints[i];
end;

function TIFPS3DebugCompExec.GetBreakPointCount: Longint;
begin
  Result := FBreakPoints.Count;
end;

function TIFPS3DebugCompExec.GetVarContents(const Name: string): string;
var
  i: Longint;
  pv: PIFVariant;
  s1, s: string;
begin
  s := Uppercase(Name);
  if pos('.', s) > 0 then
  begin
    s1 := copy(s,1,pos('.', s) -1);
    delete(s,1,pos('.', Name));
  end else begin
    s1 := s;
    s := '';
  end;
  pv := nil;
  for i := 0 to Exec.CurrentProcVars.Count -1 do
  begin
    if Exec.CurrentProcVars[i] =  s1 then
    begin
      pv := Exec.GetProcVar(i);
      break;
    end;
  end;
  if pv = nil then
  begin
    for i := 0 to Exec.CurrentProcParams.Count -1 do
    begin
      if Exec.CurrentProcParams[i] =  s1 then
      begin
        pv := Exec.GetProcParam(i);
        break;
      end;
    end;
  end;
  if pv = nil then
  begin
    for i := 0 to Exec.GlobalVarNames.Count -1 do
    begin
      if Exec.GlobalVarNames[i] =  s1 then
      begin
        pv := Exec.GetGlobalVar(i);
        break;
      end;
    end;
  end;
  if pv = nil then
    Result := 'Unknown Identifier'
  else
    Result := IFPSVariantToString(NewTIFPSVariantIFC(pv, False), s);
end;

function TIFPS3DebugCompExec.HasBreakPoint(const Fn: string; Line: Integer): Boolean;
var
  h, i: Longint;
  bi: TIFPSBreakPointInfo;
begin
  h := MakeHash(Fn);
  for i := FBreakPoints.Count -1 downto 0 do
  begin
    bi := FBreakpoints[i];
    if (h = bi.FileNameHash) and (Fn = bi.FileName) and (bi.Line = Line) then
    begin
      Result := true;
      exit;
    end;
  end;
  Result := False;
end;

procedure TIFPS3DebugCompExec.Pause;
begin
  if FExec.Status = isRunning then
    FExec.Pause
  else
    raise Exception.Create('Not running');
end;

procedure TIFPS3DebugCompExec.Resume;
begin
  if FExec.Status = isRunning then
    FExec.Run
  else
    raise Exception.Create('Not running');
end;

procedure TIFPS3DebugCompExec.SetBreakPoint(const fn: string; Line: Integer);
var
  i, h: Longint;
  BI: TIFPSBreakpointInfo;
begin
  h := MakeHash(fn);
  for i := FBreakPoints.Count -1 downto 0 do
  begin
    bi := FBreakpoints[i];
    if (h = bi.FileNameHash) and (fn = bi.FileName) and (bi.Line = Line) then
      exit;
  end;
  bi := TIFPSBreakPointInfo.Create;
  FBreakPoints.Add(bi);
  bi.FileName := fn;
  bi.Line := Line;
end;

procedure TIFPS3DebugCompExec.SetMainFileName(const Value: string);
var
  OldFn: string;
  h1, h2,i: Longint;
  bi: TIFPSBreakPointInfo;
begin
  OldFn := FMainFileName;
  inherited SetMainFileName(Value);
  h1 := MakeHash(OldFn);
  h2 := MakeHash(Value);
  if OldFn <> Value then
  begin
    for i := FBreakPoints.Count -1 downto 0 do
    begin
      bi := FBreakPoints[i];
      if (bi.FileNameHash = h1) and (bi.FileName = OldFn) then
      begin
        bi.FFileNameHash := h2;
        bi.FFileName := Value;
      end else if (bi.FileNameHash = h2) and (bi.FileName = Value) then
      begin
        // It's already the new filename, that can't be right, so remove all the breakpoints there
        FBreakPoints.Delete(i);
        bi.Free;
      end;
    end;
  end;
end;

procedure TIFPS3DebugCompExec.StepInto;
begin
  if (FExec.Status = isRunning) or (FExec.Status = isLoaded) then
    FExec.StepInto
  else
    raise Exception.Create('No script');
end;

procedure TIFPS3DebugCompExec.StepOver;
begin
  if (FExec.Status = isRunning) or (FExec.Status = isLoaded) then
    FExec.StepOver
  else
    raise Exception.Create('No script');
end;



{ TIFPS3CEPluginItem }

function TIFPS3CEPluginItem.GetDisplayName: string;
begin
  if FPlugin <> nil then
    Result := FPlugin.Name
  else
    Result := '<nil>';
end;

procedure TIFPS3CEPluginItem.SetPlugin(const Value: TIFPS3Plugin);
begin
  FPlugin := Value;
  Changed(False);
end;

{ TIFPS3CEPlugins }

constructor TIFPS3CEPlugins.Create(CE: TIFPS3CompExec);
begin
  inherited Create(TIFPS3CEPluginItem);
  FCompExec := CE;
end;

function TIFPS3CEPlugins.GetOwner: TPersistent;
begin
  Result := FCompExec;
end;

{ TIFPSBreakPointInfo }

procedure TIFPSBreakPointInfo.SetFileName(const Value: string);
begin
  FFileName := Value;
  FFileNameHash := MakeHash(Value);
end;

end.
