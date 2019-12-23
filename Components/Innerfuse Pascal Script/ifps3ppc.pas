 {
@abstract(preprocessor part of the script engine)
@author(Carlo Kok <ck@carlo-kok.com>)
  The preprocessor part of the script engine
}
unit ifps3ppc;
{$I ifps3_def.inc}

interface
uses
  Classes, SysUtils, ifpscomp, ifps3utl;

type
  TIFPSPreProcessor = class;
  TIFPSPascalPreProcessorParser = class;
  {Event}
  TIFPSOnNeedFile = function (Sender: TIFPSPreProcessor; const callingfilename: string; var FileName, Output: string): Boolean;
  {@Abstract(Line info structure)}
  TIFPSLineInfo = class(TObject)
  private
    function GetLineOffset(I: Integer): Cardinal;
    function GetLineOffsetCount: Longint;
  protected
    FEndPos: Cardinal;
    FStartPos: Cardinal;
    FFileName: string;
    FLineOffsets: TIfList;
  public
    {The file these lines are in}
    property FileName: string read FFileName;
    {The start position of these lines}
    property StartPos: Cardinal read FStartPos;
    {The end position of these lines}
    property EndPos: Cardinal read FEndPos;
    {The number of lines}
    property LineOffsetCount: Longint read GetLineOffsetCount;
    {The offset of the lines}
    property LineOffset[I: Longint]: Cardinal read GetLineOffset;

    constructor Create;
    destructor Destroy; override;
  end;
  {Results for a @link(TIFPSLineInfoList.GetLineInfo)}
  TIFPSLineInfoResults = record
    Row,
    Col,
    Pos: Cardinal;
    Name: string;
  end;
  {@abstract(List of lineinfo)}
  TIFPSLineInfoList = class(TObject)
  private
    FItems: TIfList;
    FCurrent: Longint;
    function GetCount: Longint;
    function GetItem(I: Integer): TIFPSLineInfo;
  protected
    function Add: TIFPSLineInfo;
  public
    {The number of elements}
    property Count: Longint read GetCount;
    {Returns element number I}
    property Items[I: Longint]: TIFPSLineInfo read GetItem; default;
    {Clear the list of line info}
    procedure Clear;
    {Calculates the real line information from a position}
    function GetLineInfo(Pos: Cardinal; var Res: TIFPSLineInfoResults): Boolean;
    {Current Line info record}
    property Current: Longint read FCurrent write FCurrent;

    constructor Create;
    destructor Destroy; override;
  end;
  TIFPSDefineStates = class;
  TIFPSPreProcessor = class(TObject)
  private
    FID: Pointer;
    FCurrentDefines, FDefines: TStringList;
    FCurrentLineInfo: TIFPSLineInfoList;
    FOnNeedFile: TIFPSOnNeedFile;
    FAddedPosition: Cardinal;
    FDefineState: TIFPSDefineStates;
    FMaxLevel: Longint;
    FMainFileName: string;
    FMainFile: string;
    procedure ParserNewLine(Sender: TIFPSPascalPreProcessorParser; Row, Col, Pos: Cardinal);
    procedure IntPreProcess(Level: Integer; const OrgFileName: string; FileName: string; Dest: TStream);
  public
    {The maximum number of levels deep the parser will go, defaults to 20}
    property MaxLevel: Longint read FMaxLevel write FMaxLevel; //20
    {Current line information}
    property CurrentLineInfo: TIFPSLineInfoList read FCurrentLineInfo;
    {OnNeedFile event, is called when the parser needs a file}
    property OnNeedFile: TIFPSOnNeedFile read FOnNeedFile write FOnNeedFile;
    {Defines for the parser} 
    property Defines: TStringList read FDefines write FDefines;
    {The contents of the "main" file}
    property MainFile: string read FMainFile write FMainFile;
    {The filename of the MainFile}
    property MainFileName: string read FMainFileName write FMainFileName;
    {Id Pointer, not used by the preprocessor}
    property ID: Pointer read FID write FID;
    {Adjust the message in IFPS3 so they will contain the modulename and all the
    positions will match their real positions, make sure that you call this after
    you compile any script (but only once)}
    procedure AdjustMessages(Comp: TIFPSPascalCompiler);
    {Call the preprocessor, filename contains the current file, if FileName is
    MainFileName (case sensitive) it will no call the OnNeedFile event. the
    preprocessor will raise an exception on any errors}
    procedure PreProcess(const Filename: string; var Output: string);
    {Clear everything}
    procedure Clear;

    constructor Create;
    destructor Destroy; override;
  end;
  {The kind of preprocessor token} 
  TIFPSPascalPreProcessorType = (ptEOF, ptOther, ptDefine);
  {OnNewLine event}
  TIFPSOnNewLine = procedure (Sender: TIFPSPascalPreProcessorParser; Row, Col, Pos: Cardinal) of object;
  {@Abstract(Pre processor parser) used by the preprocessor to parse the scripts}
  TIFPSPascalPreProcessorParser = class(TObject)
  private
    FData: string;
    FText: Pchar;
    FToken: string;
    FTokenId: TIFPSPascalPreProcessorType;
    FLastEnterPos, FLen, FRow, FCol, FPos: Cardinal;
    FOnNewLine: TIFPSOnNewLine;
  public
    {Set the contents of the parser}
    procedure SetText(const dta: string);
    {Go to the next field}
    procedure Next;
    {Returns the urrent token}
    property Token: string read FToken;
    {Returns the tokenid}
    property TokenId: TIFPSPascalPreProcessorType read FTokenId;
    {The row number}
    property Row: Cardinal read FRow;
    {The column number}
    property Col: Cardinal read FCol;
    {The position from the Text}
    property Pos: Cardinal read FPos;
    {Called when a newline #10, #13 or #13#10 is found}
    property OnNewLine: TIFPSOnNewLine read FOnNewLine write FOnNewLine;
  end;
  {@Abstract(Class to maintain a define)}
  TIFPSDefineState = class(TObject)
  private
    FInElse: Boolean;
    FDoWrite: Boolean;
  public
    {current in an ELSE define}
    property InElse: Boolean read FInElse write FInElse;
    {should the parser write, or not}
    property DoWrite: Boolean read FDoWrite write FDoWrite;
  end;
  {@Abstract(List of define state items)}
  TIFPSDefineStates = class(TObject)
  private
    FItems: TIfList;
    function GetCount: Longint;
    function GetItem(I: Integer): TIFPSDefineState;
    function GetWrite: Boolean;
  public
    {The number of elements in this list}
    property Count: Longint read GetCount;
    {Returns element number I}
    property Item[I: Longint]: TIFPSDefineState read GetItem; default;
    {Add a new define state item}
    function Add: TIFPSDefineState;
    {Delete item no I}
    procedure Delete(I: Longint);

    constructor Create;
    destructor Destroy; override;
    {Should the parser write it's output or not}
    property DoWrite: Boolean read GetWrite;
  end;

implementation



{ TIFPSLineInfoList }

function TIFPSLineInfoList.Add: TIFPSLineInfo;
begin
  Result := TIFPSLineInfo.Create;
  FItems.Add(Result);
end;

procedure TIFPSLineInfoList.Clear;
var
  i: Longint;
begin
  for i := FItems.count -1 downto 0 do
    TIFPSLineInfo(FItems[i]).Free;
  FItems.Clear;
end;

constructor TIFPSLineInfoList.Create;
begin
  inherited Create;
  FItems := TIfList.Create;
end;

destructor TIFPSLineInfoList.Destroy;
begin
  Clear;
  FItems.Free;
  inherited Destroy;
end;

function TIFPSLineInfoList.GetCount: Longint;
begin
  Result := FItems.Count;
end;

function TIFPSLineInfoList.GetItem(I: Integer): TIFPSLineInfo;
begin
  Result := TIFPSLineInfo(FItems[i]);
end;

function TIFPSLineInfoList.GetLineInfo(Pos: Cardinal;
  var Res: TIFPSLineInfoResults): Boolean;
var
  i,j: Longint;
  linepos: Cardinal;
  Item: TIFPSLineInfo;
begin
  for i := FItems.Count -1 downto 0 do
  begin
    Item := FItems[i];
    if (Pos >= Item.StartPos) and (Pos < Item.EndPos) then
    begin
      Res.Name := Item.FileName;
      Pos := Pos - Item.StartPos;
      Res.Pos := Pos;
      Res.Col := 1;
      Res.Row := 1;
      LinePos := 0;
      for j := 0 to Item.LineOffsetCount -1 do
      begin
        if Pos >= Item.LineOffset[j] then
        begin
          linepos := Item.LineOffset[j];
        end else
        begin
          Res.Row := j; // j -1, but line counting starts at 1
          Res.Col := pos - linepos + 1;
          Break;
        end;
      end;
      Result := True;
      exit;
    end;
  end;
  Result := False;
end;

{ TIFPSLineInfo }

constructor TIFPSLineInfo.Create;
begin
  inherited Create;
  FLineOffsets := TIfList.Create;
end;

destructor TIFPSLineInfo.Destroy;
begin
  FLineOffsets.Free;
  inherited Destroy;
end;


function TIFPSLineInfo.GetLineOffset(I: Integer): Cardinal;
begin
  Result := Longint(FLineOffsets[I]);
end;

function TIFPSLineInfo.GetLineOffsetCount: Longint;
begin
  result := FLineOffsets.Count;
end;

{ TIFPSPascalPreProcessorParser }

procedure TIFPSPascalPreProcessorParser.Next;
var
  ci: Cardinal;

begin
  FPos := FPos + FLen;
  case FText[FPos] of
    #0:
      begin
        FLen := 0;
        FTokenId := ptEof;
      end;
    '''':
      begin
        ci := FPos;
        while (FText[ci] <> #0) do
        begin
          Inc(ci);
          while FText[ci] = '''' do
          begin
            if FText[ci+1] <> '''' then Break;
            inc(ci);
            inc(ci);
          end;
          if FText[ci] = '''' then Break;
          if FText[ci] = #13 then
          begin
            inc(FRow);
            if FText[ci] = #10 then
              inc(ci);
            FLastEnterPos := ci -1;
            if @FOnNewLine <> nil then FOnNewLine(Self, FRow, FPos - FLastEnterPos + 1, ci+1);
          end else if FText[ci] = #10 then
          begin
            inc(FRow);
            FLastEnterPos := ci -1;
            if @FOnNewLine <> nil then FOnNewLine(Self, FRow, FPos - FLastEnterPos + 1, ci+1);
          end;
        end;
        FLen := ci - FPos + 1;
        FTokenId := ptOther;
      end;
    '(':
      begin
        if FText[FPos + 1] = '*' then
        begin
          ci := FPos + 1;
          while (FText[ci] <> #0) do begin
            if (FText[ci] = '*') and (FText[ci + 1] = ')') then
              Break;
            if FText[ci] = #13 then
            begin
              inc(FRow);
              if FText[ci+1] = #10 then
                inc(ci);
              FLastEnterPos := ci -1;
              if @FOnNewLine <> nil then FOnNewLine(Self, FRow, FPos - FLastEnterPos + 1, ci+1);
            end else if FText[ci] = #10 then
            begin
              inc(FRow);
              FLastEnterPos := ci -1;
              if @FOnNewLine <> nil then FOnNewLine(Self, FRow, FPos - FLastEnterPos + 1, ci+1);
            end;
            Inc(ci);
          end;
          FTokenId := ptOther;
          if (FText[ci] <> #0) then
            Inc(ci, 2);
          FLen := ci - FPos;
        end
        else
        begin
          FTokenId := ptOther;
          FLen := 1;
        end;
      end;
      '/':
        begin
          if FText[FPos + 1] = '/' then
          begin
            ci := FPos + 1;
            while (FText[ci] <> #0) and (FText[ci] <> #13) and
              (FText[ci] <> #10) do begin
              Inc(ci);
            end;
            FTokenId := ptOther;
            FLen := ci - FPos;
          end else
          begin
            FTokenId := ptOther;
            FLen := 1;
          end;
        end;
      '{':
        begin
          ci := FPos + 1;
          while (FText[ci] <> #0) and (FText[ci] <> '}') do begin
            if FText[ci] = #13 then
            begin
              inc(FRow);
              if FText[ci+1] = #10 then
                inc(ci);
              FLastEnterPos := ci - 1;
              if @FOnNewLine <> nil then FOnNewLine(Self, FRow, FPos - FLastEnterPos + 1, ci+1);
            end else if FText[ci] = #10 then
            begin
              inc(FRow);
              FLastEnterPos := ci - 1;
              if @FOnNewLine <> nil then FOnNewLine(Self, FRow, FPos - FLastEnterPos + 1, ci+1);
            end;
            Inc(ci);
          end;
          if FText[FPos + 1] = '$' then
            FTokenId := ptDefine
          else
            FTokenId := ptOther;

          FLen := ci - FPos + 1;
        end;
      else
      begin
        ci := FPos + 1;
        while not (FText[ci] in [#0,'{', '(', '''', '/']) do
        begin
          if FText[ci] = #13 then
          begin
            inc(FRow);
            if FText[ci+1] = #10 then
              inc(ci);
            FLastEnterPos := ci - 1;
            if @FOnNewLine <> nil then FOnNewLine(Self, FRow, FPos - FLastEnterPos + 1, ci+1);
          end else if FText[ci] = #10 then
          begin
            inc(FRow);
            FLastEnterPos := ci -1 ;
            if @FOnNewLine <> nil then FOnNewLine(Self, FRow, FPos - FLastEnterPos + 1, ci+1);
          end;
          Inc(Ci);
        end;
        FTokenId := ptOther;
        FLen := ci - FPos;
      end;
  end;
  FCol := FPos - FLastEnterPos + 1;
  FToken := Copy(FData, FPos +1, FLen);
end;

procedure TIFPSPascalPreProcessorParser.SetText(const dta: string);
begin
  FData := dta;
  FText := pchar(FData);
  FLen := 0;
  FPos := 0;
  FCol := 1;
  FLastEnterPos := 0;
  FRow := 1;
  if @FOnNewLine <> nil then FOnNewLine(Self, 1, 1, 0);
  Next;
end;

{ TIFPSPreProcessor }

procedure TIFPSPreProcessor.AdjustMessages(Comp: TIFPSPascalCompiler);
var
  i: Longint;
  msg: TIFPSPascalCompilerMessage;
  Res: TIFPSLineInfoResults;
begin
  for i := 0 to Comp.MsgCount -1 do
  begin
    msg := Comp.Msg[i];
    if CurrentLineInfo.GetLineInfo(Msg.Pos, Res) then
    begin
      Msg.SetCustomPos(res.Pos, Res.Row, Res.Col);
      Msg.ModuleName := Res.Name;
    end;
  end;
end;

procedure TIFPSPreProcessor.Clear;
begin
  FDefines.Clear;
  FCurrentDefines.Clear;
  FCurrentLineInfo.Clear;
  FMainFile := '';
end;

constructor TIFPSPreProcessor.Create;
begin
  inherited Create;
  FDefines := TStringList.Create;
  FCurrentLineInfo := TIFPSLineInfoList.Create;
  FCurrentDefines := TStringList.Create;
  FDefines.Duplicates := dupIgnore;
  FCurrentDefines.Duplicates := dupIgnore;
  FDefineState := TIFPSDefineStates.Create;
  FMaxLevel := 20;
end;

destructor TIFPSPreProcessor.Destroy;
begin
  FDefineState.Free;
  FCurrentDefines.Free;
  FDefines.Free;
  FCurrentLineInfo.Free;
  inherited Destroy;
end;

procedure TIFPSPreProcessor.IntPreProcess(Level: Integer; const OrgFileName: string; FileName: string; Dest: TStream);
var
  Parser: TIFPSPascalPreProcessorParser;
  dta: string;
  item: TIFPSLineInfo;
  s, name: string;
  current, i: Longint;
  ds: TIFPSDefineState;

begin
  if Level > MaxLevel then raise Exception.Create('Too many nested include files while processing '+FileName+' from '+OrgFileName);
  Parser := TIFPSPascalPreProcessorParser.Create;
  try
    Parser.OnNewLine := ParserNewLine;
    if FileName = MainFileName then
    begin
      dta := MainFile;
    end else
    if (@OnNeedFile = nil) or (not OnNeedFile(Self, OrgFileName, FileName, dta)) then
      raise Exception.Create('Unable to find file '''+filename+''' used from '''+OrgFileName+'''');
    Item := FCurrentLineInfo.Add;
    current := FCurrentLineInfo.Count -1;
    FCurrentLineInfo.Current := current;
    Item.FStartPos := Dest.Position;
    Item.FFileName := FileName;
    Parser.SetText(dta);
    while Parser.TokenId <> ptEOF do
    begin
      s := Parser.Token;
      if Parser.TokenId = ptDefine then
      begin
        Delete(s,1,2);  // delete the {$
        Delete(s,length(s), 1); // delete the }
        if pos(' ', s) = 0 then
        begin
          name := uppercase(s);
          s := '';
        end else
        begin
          Name := uppercase(copy(s,1,pos(' ', s)-1));
          Delete(s, 1, pos(' ', s));
        end;
        if (Name = 'I') or (Name = 'INCLUDE') then
        begin
          if FDefineState.DoWrite then
          begin
            FAddedPosition := 0;
            IntPreProcess(Level +1, FileName, s, Dest);
            FCurrentLineInfo.Current := current;
            FAddedPosition := Cardinal(Dest.Position) - Item.StartPos - Parser.Pos;
          end;
        end else if (Name = 'DEFINE') then
        begin
          if pos(' ', s) <> 0 then raise Exception.Create('Too many parameters at '+IntToStr(Parser.Row)+':'+IntToStr(Parser.Col));
          FCurrentDefines.Add(Uppercase(S));
        end else if (Name = 'UNDEF') then
        begin
          if pos(' ', s) <> 0 then raise Exception.Create('Too many parameters at '+IntToStr(Parser.Row)+':'+IntToStr(Parser.Col));
          i := FCurrentDefines.IndexOf(Uppercase(s));
          if i <> -1 then
            FCurrentDefines.Delete(i);
        end else if (Name = 'IFDEF') then
        begin
          if pos(' ', s) <> 0 then raise Exception.Create('Too many parameters at '+IntToStr(Parser.Row)+':'+IntToStr(Parser.Col));
          FDefineState.Add.DoWrite := FCurrentDefines.IndexOf(Uppercase(s)) <> -1;
        end else if (Name = 'IFNDEF') then
        begin
          if pos(' ', s) <> 0 then raise Exception.Create('Too many parameters at '+IntToStr(Parser.Row)+':'+IntToStr(Parser.Col));
          FDefineState.Add.DoWrite := FCurrentDefines.IndexOf(Uppercase(s)) = -1;
        end else if (Name = 'ENDIF') then
        begin
          if s <> '' then raise Exception.Create('Too many parameters at '+IntToStr(Parser.Row)+':'+IntToStr(Parser.Col));
          if FDefineState.Count = 0 then
            raise Exception.Create('No IFDEF for ENDIF at '+IntToStr(Parser.Row)+':'+IntToStr(Parser.Col));
          FDefineState.Delete(FDefineState.Count -1); // remove define from list
        end else if (Name = 'ELSE') then
        begin
          if s<> '' then raise Exception.Create('Too many parameters at '+IntToStr(Parser.Row)+':'+IntToStr(Parser.Col));
          if FDefineState.Count = 0 then
            raise Exception.Create('No IFDEF for ELSE at '+IntToStr(Parser.Row)+':'+IntToStr(Parser.Col));
          ds := FDefineState[FDefineState.Count -1];
          if ds.InElse then
            raise Exception.Create('Can''t use ELSE twice at '+IntToStr(Parser.Row)+':'+IntToStr(Parser.Col));
          ds.FInElse := True;
          ds.DoWrite := not ds.DoWrite;
        end else
          raise Exception.Create('Unknown compiler directives at '+IntToStr(Parser.Row)+':'+IntToStr(Parser.Col));
      end;
      if (not FDefineState.DoWrite) or (Parser.TokenId = ptDefine) then
      begin
        SetLength(s, Length(Parser.Token));
        for i := length(s) downto 1 do
          s[i] := #32; // space
      end;
      Dest.Write(s[1], length(s));
      Parser.Next;
    end;
    Item.FEndPos := Dest.Position;
  finally
    Parser.Free;
  end;
end;

procedure TIFPSPreProcessor.ParserNewLine(Sender: TIFPSPascalPreProcessorParser; Row, Col, Pos: Cardinal);
begin
  if FCurrentLineInfo.Current >= FCurrentLineInfo.Count then exit; //errr ???
  with FCurrentLineInfo.Items[FCurrentLineInfo.Current] do
  begin
    Pos := Pos + FAddedPosition;
    FLineOffsets.Add(Pointer(Pos));
  end;
end;

procedure TIFPSPreProcessor.PreProcess(const Filename: string; var Output: string);
var
  Stream: TMemoryStream;
begin
  FAddedPosition := 0;
  FCurrentDefines.Assign(FDefines);
  Stream := TMemoryStream.Create;
  try
    IntPreProcess(0, '', FileName, Stream);
    Stream.Position := 0;
    SetLength(Output, Stream.Size);
    Stream.Read(Output[1], Length(Output));
  finally
    Stream.Free;
  end;
  if FDefineState.Count <> 0 then
    raise Exception.Create('Define not closed');
end;

{ TIFPSDefineStates }

function TIFPSDefineStates.Add: TIFPSDefineState;
begin
  Result := TIFPSDefineState.Create;
  FItems.Add(Result);
end;

constructor TIFPSDefineStates.Create;
begin
  inherited Create;
  FItems := TIfList.Create;
end;

procedure TIFPSDefineStates.Delete(I: Integer);
begin
  TIFPSDefineState(FItems[i]).Free;
  FItems.Delete(i);
end;

destructor TIFPSDefineStates.Destroy;
var
  i: Longint;
begin
  for i := Longint(FItems.Count) -1 downto 0 do
    TIFPSDefineState(FItems[i]).Free;
  FItems.Free;
  inherited Destroy;
end;

function TIFPSDefineStates.GetCount: Longint;
begin
  Result := FItems.Count;
end;

function TIFPSDefineStates.GetItem(I: Integer): TIFPSDefineState;
begin
  Result := FItems[i];
end;

function TIFPSDefineStates.GetWrite: Boolean;
begin
  if FItems.Count = 0 then
    result := true
  else Result := TIFPSDefineState(FItems[FItems.Count -1]).DoWrite;
end;

end.
