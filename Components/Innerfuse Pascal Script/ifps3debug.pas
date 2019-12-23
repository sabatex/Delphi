{
@author(Carlo Kok <ck@carlo-kok.com>)
@abstract(Debugging executer for IFPS3)
Debugging executer for IFPS3
Innerfuse Pascal Script III
Copyright (C) 2000-2004 by Carlo Kok (ck@@carlo-kok.com)

}
unit ifps3debug;
{$I ifps3_def.inc}
interface
uses
  ifps3, ifps3utl;

type
  {The current debugging mode}
  TDebugMode = (dmRun, dmStepOver, dmStepInto, dmPaused);
  {The TIFPSCustomDebugExec class is used to load and use compiler debug information}
  TIFPSCustomDebugExec = class(TIFPSExec)
  protected
    FDebugDataForProcs: TIfList;
    FLastProc: TIFProcRec;
    FCurrentDebugProc: Pointer;
    FProcNames: TIFStringList;
    FGlobalVarNames: TIfStringList;
    FCurrentSourcePos, FCurrentRow, FCurrentCol: Cardinal;
    FCurrentFile: string;
    function GetCurrentProcParams: TIfStringList;
    function GetCurrentProcVars: TIfStringList;
  protected
    procedure ClearDebug; virtual;
  public
    {The current proc no}
    function GetCurrentProcNo: Cardinal;
    {Get the current position}
    function GetCurrentPosition: Cardinal;
    {Translate a position to a real position}
    function TranslatePosition(Proc, Position: Cardinal): Cardinal;
    {Translate a position into a row, col and offset}
    function TranslatePositionEx(Proc, Position: Cardinal; var Pos, Row, Col: Cardinal; var Fn: string): Boolean;
    {Load debug data in the scriptengine}
    procedure LoadDebugData(const Data: string);
	{Clear the debugdata and the current script}
    procedure Clear; override;
    {Contains the names of the global variables}
    property GlobalVarNames: TIfStringList read FGlobalVarNames;
	{Contains the names of the procedures}
    property ProcNames: TIfStringList read FProcNames;
	{The variables in the current proc (could be nil)}
    property CurrentProcVars: TIfStringList read GetCurrentProcVars;
	{The paramters of the current proc (could be nil)}
    property CurrentProcParams: TIfStringList read GetCurrentProcParams;
    {Get global variable no I}
    function GetGlobalVar(I: Cardinal): PIfVariant;
	{Get Proc variable no I}
    function GetProcVar(I: Cardinal): PIfVariant;
	{Get proc param no I}
    function GetProcParam(I: Cardinal): PIfVariant;
    {Create an instance of the debugger}
    constructor Create;
	{destroy the current instance of the debugger}
    destructor Destroy; override;
  end;
  TIFPSDebugExec = class;
  {see TIFPSDebugExec.OnSourceLine}
  TOnSourceLine = procedure (Sender: TIFPSDebugExec; const Name: string; Position, Row, Col: Cardinal);
  {see TIFPSDebugExec.OnIdleCall}
  TOnIdleCall = procedure (Sender: TIFPSDebugExec);
  {The TIFPSCustomDebugExec class is used to load and use compiler debug information}
  TIFPSDebugExec = class(TIFPSCustomDebugExec)
  private
    FDebugMode: TDebugMode;
    FStepOverStackBase: Cardinal;
    FOnIdleCall: TOnIdleCall;
    FOnSourceLine: TOnSourceLine;
    FDebugEnabled: Boolean;
  protected
    procedure SourceChanged;
    procedure ClearDebug; override;
    procedure RunLine; override;
  public
    constructor Create;
    function LoadData(const s: string): Boolean; override;
    procedure Pause; override;
    procedure Run;
    procedure StepInto;
    procedure StepOver;
    procedure Stop; override;
	{Contains the current debugmode}
    property DebugMode: TDebugMode read FDebugMode;
    {OnSourceLine is called after passing each source line}
    property OnSourceLine: TOnSourceLine read FOnSourceLine write FOnSourceLine;
	{OnIdleCall is called when the script is paused}
    property OnIdleCall: TOnIdleCall read FOnIdleCall write FOnIdleCall;
    {Enable the usaging of debug data. When you need more speed,
    set this to false, but any debug or source translation functions won't work}
    property DebugEnabled: Boolean read FDebugEnabled write FDebugEnabled;
  end;

implementation

type
  PPositionData = ^TPositionData;
  TPositionData = packed record
    FileName: string;
    Position,
    Row,
    Col,
    SourcePosition: Cardinal;
  end;
  PFunctionInfo = ^TFunctionInfo;
  TFunctionInfo = packed record
    Func: TIFProcRec;
    FParamNames: TIfStringList;
    FVariableNames: TIfStringList;
    FPositionTable: TIfList;
  end;

{ TIFPSCustomDebugExec }

procedure TIFPSCustomDebugExec.Clear;
begin
  inherited Clear;
  if FGlobalVarNames <> nil then ClearDebug;
end;

procedure TIFPSCustomDebugExec.ClearDebug;
var
  i, j: Longint;
  p: PFunctionInfo;
begin
  FCurrentDebugProc := nil;
  FLastProc := nil;
  FProcNames.Clear;
  FGlobalVarNames.Clear;
  FCurrentSourcePos := 0;
  FCurrentRow := 0;
  FCurrentCol := 0;
  FCurrentFile := '';
  for i := 0 to FDebugDataForProcs.Count -1 do
  begin
    p := FDebugDataForProcs[I];
    for j := 0 to p^.FPositionTable.Count -1 do
    begin
      Dispose(PPositionData(P^.FPositionTable[J]));
    end;
    p^.FPositionTable.Free;
    p^.FParamNames.Free;
    p^.FVariableNames.Free;
    Dispose(p);
  end;
  FDebugDataForProcs.Clear;
end;

constructor TIFPSCustomDebugExec.Create;
begin
  inherited Create;
  FCurrentSourcePos := 0;
  FCurrentRow := 0;
  FCurrentCol := 0;
  FCurrentFile := '';
  FDebugDataForProcs := TIfList.Create;
  FLastProc := nil;
  FCurrentDebugProc := nil;
  FProcNames := TIFStringList.Create;
  FGlobalVarNames := TIfStringList.Create;
end;

destructor TIFPSCustomDebugExec.Destroy;
begin
  Clear;
  FDebugDataForProcs.Free;
  FProcNames.Free;
  FGlobalVarNames.Free;
  FGlobalVarNames := nil;
  inherited Destroy;
end;

function TIFPSCustomDebugExec.GetCurrentPosition: Cardinal;
begin
  Result := TranslatePosition(GetCurrentProcNo, 0);
end;

function TIFPSCustomDebugExec.GetCurrentProcNo: Cardinal;
var
  i: Longint;
begin
  for i := 0 to FProcs.Count -1 do
  begin
    if FProcs[i]=  FCurrProc then
    begin
      Result := I;
      Exit;
    end;
  end;
  Result := Cardinal(-1);
end;

function TIFPSCustomDebugExec.GetCurrentProcParams: TIfStringList;
begin
  if FCurrentDebugProc <> nil then
  begin
    Result := PFunctionInfo(FCurrentDebugProc)^.FParamNames;
  end else Result := nil;
end;

function TIFPSCustomDebugExec.GetCurrentProcVars: TIfStringList;
begin
  if FCurrentDebugProc <> nil then
  begin
    Result := PFunctionInfo(FCurrentDebugProc)^.FVariableNames;
  end else Result := nil;
end;

function TIFPSCustomDebugExec.GetGlobalVar(I: Cardinal): PIfVariant;
begin
  Result := FGlobalVars[I];
end;

function TIFPSCustomDebugExec.GetProcParam(I: Cardinal): PIfVariant;
begin
  Result := FStack[Cardinal(Longint(FCurrStackBase) - Longint(I) - 1)];
end;

function TIFPSCustomDebugExec.GetProcVar(I: Cardinal): PIfVariant;
begin
  Result := FStack[Cardinal(Longint(FCurrStackBase) + Longint(I) + 1)];
end;

function GetProcDebugInfo(FProcs: TIFList; Proc: TIFProcRec): PFunctionInfo;
var
  i: Longint;
  c: PFunctionInfo;
begin
  if Proc = nil then
  begin
    Result := nil;
    exit;
  end;
  for i := FProcs.Count -1 downto 0 do
  begin
    c := FProcs.Data^[I];
    if c^.Func = Proc then
    begin
      Result := c;
      exit;
    end;
  end;
  new(c);
  c^.Func := Proc;
  c^.FPositionTable := TIfList.Create;
  c^.FVariableNames := TIfStringList.Create;
  c^.FParamNames := TIfStringList.Create;
  FProcs.Add(c);
  REsult := c;
end;

procedure TIFPSCustomDebugExec.LoadDebugData(const Data: string);
var
  CP, I: Longint;
  c: char;
  CurrProcNo, LastProcNo: Cardinal;
  LastProc: PFunctionInfo;
  NewLoc: PPositionData;
  s: string;
begin
  ClearDebug;
  if FStatus = isNotLoaded then exit;
  CP := 1;
  LastProcNo := Cardinal(-1);
  LastProc := nil;
  while CP <= length(Data) do
  begin
    c := Data[CP];
    inc(cp);
    case c of
      #0:
        begin
          i := cp;
          if i > length(data) then exit;
          while Data[i] <> #0 do
          begin
            if Data[i] = #1 then
            begin
              FProcNames.Add(Copy(Data, cp, i-cp));
              cp := I + 1;
            end;
            inc(I);
            if I > length(data) then exit;
          end;
          cp := i + 1;
        end;
      #1:
        begin
          i := cp;
          if i > length(data) then exit;
          while Data[i] <> #0 do
          begin
            if Data[i] = #1 then
            begin
              FGlobalVarNames.Add(Copy(Data, cp, i-cp));
              cp := I + 1;
            end;
            inc(I);
            if I > length(data) then exit;
          end;
          cp := i + 1;
        end;
      #2:
        begin
          if cp + 4 > Length(data) then exit;
          CurrProcNo := Cardinal((@Data[cp])^);
          if CurrProcNo = Cardinal(-1) then Exit;
          if CurrProcNo <> LastProcNo then
          begin
            LastProcNo := CurrProcNo;
            LastProc := GetProcDebugInfo(FDebugDataForProcs, FProcs[CurrProcNo]);
            if LastProc = nil then exit;
          end;
          inc(cp, 4);

          i := cp;
          if i > length(data) then exit;
          while Data[i] <> #0 do
          begin
            if Data[i] = #1 then
            begin
              LastProc^.FParamNames.Add(Copy(Data, cp, i-cp));
              cp := I + 1;
            end;
            inc(I);
            if I > length(data) then exit;
          end;
          cp := i + 1;
        end;
      #3:
        begin
          if cp + 4 > Length(data) then exit;
          CurrProcNo := Cardinal((@Data[cp])^);
          if CurrProcNo = Cardinal(-1) then Exit;
          if CurrProcNo <> LastProcNo then
          begin
            LastProcNo := CurrProcNo;
            LastProc := GetProcDebugInfo(FDebugDataForProcs, FProcs[CurrProcNo]);
            if LastProc = nil then exit;
          end;
          inc(cp, 4);

          i := cp;
          if i > length(data) then exit;
          while Data[i] <> #0 do
          begin
            if Data[i] = #1 then
            begin
              LastProc^.FVariableNames.Add(Copy(Data, cp, i-cp));
              cp := I + 1;
            end;
            inc(I);
            if I > length(data) then exit;
          end;
          cp := i + 1;
        end;
      #4:
        begin
          i := cp;
          if i > length(data) then exit;
          while Data[i] <> #0 do
          begin
            if Data[i] = #1 then
            begin
              s := Copy(Data, cp, i-cp);
              cp := I + 1;
              Break;
            end;
            inc(I);
            if I > length(data) then exit;
          end;
          if cp + 4 > Length(data) then exit;
          CurrProcNo := Cardinal((@Data[cp])^);
          if CurrProcNo = Cardinal(-1) then Exit;
          if CurrProcNo <> LastProcNo then
          begin
            LastProcNo := CurrProcNo;
            LastProc := GetProcDebugInfo(FDebugDataForProcs, FProcs[CurrProcNo]);
            if LastProc = nil then exit;
          end;
          inc(cp, 4);
          if cp + 16 > Length(data) then exit;
          new(NewLoc);
          NewLoc^.Position := Cardinal((@Data[Cp])^);
          NewLoc^.FileName := s;
          NewLoc^.SourcePosition := Cardinal((@Data[Cp+4])^);
          NewLoc^.Row := Cardinal((@Data[Cp+8])^);
          NewLoc^.Col := Cardinal((@Data[Cp+12])^);
          inc(cp, 16);
          LastProc^.FPositionTable.Add(NewLoc);
        end;
      else
        begin
          ClearDebug;
          Exit;
        end;
    end;

  end;
end;






function TIFPSCustomDebugExec.TranslatePosition(Proc, Position: Cardinal): Cardinal;
var
  D1, D2: Cardinal;
  s: string;
begin
  if not TranslatePositionEx(Proc, Position, Result, D1, D2, s) then
    Result := 0;
end;

function TIFPSCustomDebugExec.TranslatePositionEx(Proc, Position: Cardinal;
  var Pos, Row, Col: Cardinal; var Fn: string): Boolean;
// Made by Martijn Laan (mlaan@wintax.nl)
var
  i: LongInt;
  fi: PFunctionInfo;
  pt: TIfList;
  r: PPositionData;
  lastfn: string;
  LastPos, LastRow, LastCol: Cardinal;
  pp: TIFProcRec;
begin
  fi := nil;
  pp := FProcs[Proc];
  for i := 0 to FDebugDataForProcs.Count -1 do
  begin
    fi := FDebugDataForProcs[i];
    if fi^.Func = pp then
      Break;
    fi := nil;
  end;
  LastPos := 0;
  LastRow := 0;
  LastCol := 0;
  if fi <> nil then begin
    pt := fi^.FPositionTable;
    for i := 0 to pt.Count -1 do
    begin
      r := pt[I];
      if r^.Position >= Position then
      begin
        if r^.Position = Position then
        begin
          Pos := r^.SourcePosition;
          Row := r^.Row;
          Col := r^.Col;
          Fn := r^.Filename;
        end
        else
        begin
          Pos := LastPos;
          Row := LastRow;
          Col := LastCol;
          Fn := LastFn;
        end;
        Result := True;
        exit;
      end else
      begin
        LastPos := r^.SourcePosition;
        LastRow := r^.Row;
        LastCol := r^.Col;
        LastFn := r^.FileName;
      end;
    end;
    Pos := LastPos;
    Row := LastRow;
    Col := LastCol;
    Result := True;
  end else
  begin
    Result := False;
  end;
end;

{ TIFPSDebugExec }
procedure TIFPSDebugExec.ClearDebug;
begin
  inherited;
  FDebugMode := dmRun;
end;

function TIFPSDebugExec.LoadData(const s: string): Boolean;
begin
  Result := inherited LoadData(s);
  FDebugMode := dmRun;
end;

procedure TIFPSDebugExec.RunLine;
var
  i: Longint;
  pt: TIfList;
  r: PPositionData;
begin
  inherited RunLine;
  if not DebugEnabled then exit;
  if FCurrProc <> FLastProc then
  begin
    FLastProc := FCurrProc;
    FCurrentDebugProc := nil;
    for i := 0 to FDebugDataForProcs.Count -1 do
    begin
      if PFunctionInfo(FDebugDataForProcs[I])^.Func = FLastProc then
      begin
        FCurrentDebugProc := FDebugDataForProcs[I];
        break;
      end;
    end;
  end;
  if FCurrentDebugProc <> nil then
  begin
    pt := PFunctionInfo(FCurrentDebugProc)^.FPositionTable;
    for i := 0 to pt.Count -1 do
    begin
      r := pt[I];
      if r^.Position = FCurrentPosition then
      begin
        FCurrentSourcePos := r^.SourcePosition;
        FCurrentRow := r^.Row;
        FCurrentCol := r^.Col;
        FCurrentFile := r^.FileName;
        SourceChanged;
        break;
      end;
    end;
  end else
  begin
    FCurrentSourcePos := 0;
    FCurrentRow := 0;
    FCurrentCol := 0;
    FCurrentFile := '';
  end;
  while FDebugMode = dmPaused do
  begin
    if @FOnIdleCall <> nil then
    begin
      FOnIdleCall(Self);
    end else break; // endless loop
  end;
end;


procedure TIFPSDebugExec.SourceChanged;
begin
  case FDebugMode of
    dmStepInto:
      begin
        FDebugMode := dmPaused;
      end;
    dmStepOver:
      begin
        if Longint(FCurrStackBase) <= Longint(FStepOverStackBase) then
        begin
          FDebugMode := dmPaused;
        end;
      end;
  end;
  if @FOnSourceLine <> nil then
    FOnSourceLine(Self, FCurrentFile, FCurrentSourcePos, FCurrentRow, FCurrentCol);
end;


procedure TIFPSDebugExec.Pause;
begin
  FDebugMode := dmPaused;
end;

procedure TIFPSDebugExec.Stop;
begin
  FDebugMode := dmRun;
  inherited Stop;
end;

procedure TIFPSDebugExec.Run;
begin
  FDebugMode := dmRun;
end;

procedure TIFPSDebugExec.StepInto;
begin
  FDebugMode := dmStepInto;
end;

procedure TIFPSDebugExec.StepOver;
begin
  FDebugMode := dmStepOver;
  FStepOverStackBase := FCurrStackBase;
end;


constructor TIFPSDebugExec.Create;
begin
  inherited Create;
  FDebugEnabled := True;
end;

end.
