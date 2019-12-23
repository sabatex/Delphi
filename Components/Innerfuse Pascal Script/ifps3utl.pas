{
@abstract(Misc Types and functions)
@author(Carlo Kok <ck@carlo-kok.com>)
This unit contains types and functions used by the compiler and executer<br><br>
Bytecode Format:<br>
  Address Space<br>
    0..GlobalVarCount -1 = GlobalVars<br>
    IFPSAddrStackStart div 2 .. IFPSAddrStackStart -1 = negative stack<br>
    IFPSAddrStackStart... = positive stack<br>
                                              <br>
                                                  <br>
  TIFPSVariable = packed record<br>
    VarType: Byte;<br>
    case VarType of<br>
      0: Address: LongWord;<br>
      1: TypeNo: LongWord; Data: TData<br>
      2: Address_: LongWord; RecFieldNo: Longword;<br>
      3: Address__: LongWord; ReadRecFieldNoFrom: LongWord;<br>
  end;<br>
  TIFPSHeader = packed record<br>
    HDR: LongWord;<br>
    IFPSBuildNo: LongWord;<br>
    TypeCount: LongWord;<br>
    ProcCount: LongWord;<br>
    VarCount: LongWord;<br>
    MainProcNo: LongWord;<br>
    ImportTableSize: LongWord; <i>// Set to zero, always</i><br>
    <i>
    Types: array[0..typcount-1] of TIFPSType;<br>
    procs: Array[0..proccount-1] of TIFPSProc;<br>
    var: array[0..varcount-1] of TIFPSVar;<br>
    ImportTable: array[0..Importtablesize-1] of TIFPSImportItem;<br>
    </i><br>
  end;<br>
  <i>// Import table isn't used yet</i><br>
  TIFPSAttributes = packed record<br>
    Count: Longint;<br>
    Attributes: array[0..Count-1] of TIFPSAttribute;<br>
  end;<br><br>
  TIFPSAttribute = packed record<br>
    AttribName: string;<br>
    FieldCount: Longint;<br>
    TypeNo: LongWord; Data: TData;<br>
  end;<br>
<br>
  TIFPSType = packed record<br>
    BaseType: TIFPSBaseType;<br>
    <i>      <br>
      Record:    <br>
        TypeCount: Longword;<br>
        Types: array[0..TypeCount-1] of LongWord;<br>
      Array:<br>
        SubType: LongWord;<br>
      BaseType and 128:<br>
        Export: Name: MyString;<br>
    </i>                            <br>
    Attributes: TIFPSAttributes;<br>
  end;<br>
  TIFPSProc = packed record<br>
    Flags: Byte;<br>
    <i> Flags:<br>
        1 = Imported; (nameLen: Byte; Name: array[0..namelen-1] of byte) else (Offset, Length: Longint);<br>
        2 = Export; (only for internal procs); Name, Decl: MyString;<br>
        3 = Imported2; nameLen: Byte; Name: array[0..namelen-1] of byte; ParamsLength: Longint; Params: array[0..paramslength-1]of byte;<br>
        4 = With attributes (attr: TIFPSAttributes)<br>
    </i><br>
  end;<br>
<br>
  TIFPSVar = packed record<br>
    TypeNo: LongWord;<br>
    Flags: Byte;<br>
    <i><br>
      1 = Exported; Name: MyString<br>
    </i><br>
  end;<br>
    <br>
<br>
DebugData:<br>
  #0+ Proc0Name+#1+Proc1Name+#1+Proc2Name+#1#0<br>
  #1+ Var0Name+#1+Var1Name+#1+Var2Name+#1#0<br>
  #2+ MI2S(FuncNo)+ Param0Name+#1+Param0Name+#1#0<br>
  #3+ MI2S(FuncNo)+ Var1Name+#1+Var1Name+#1#0<br>
  #4+ FileName + #1 + MI2S(FuncNo)+ MI2S(Pos)+ MI2s(Position)+MI2S(Row)+MI2s(Col)<br>

}
unit ifps3utl;
{$I ifps3_def.inc}
{

Innerfuse Pascal Script III
Copyright (C) 2000-2004 by Carlo Kok (ck@carlo-kok.com)

}

interface
uses
  Classes, SysUtils;
const
  {The name of the main proc }
  IFPSMainProcName = '!MAIN';
  {The original name for the main proc, can be used for user purposes}
  IFPSMainProcNameOrg = 'Main Proc';
{ The lowest supported build by the executer. }
  IFPSLowBuildSupport = 12;
{ The current build of the compiler and executer. }
  IFPSCurrentBuildNo = 22;
{ The current version of the script engine }
  IFPSCurrentversion = '1.30';
{ The header of a compiled IFPS3 binary must start with this }
  IFPSValidHeader = 1397769801;
{ Start of the positive stack }
  IFPSAddrStackStart = 1610612736;
{ Start of the negative stack }
  IFPSAddrNegativeStackStart = 1073741824;
type
{ TIFPSBaseType is the most basic type -type }
  TIFPSBaseType = Byte;
{ 
@link(OnUseVariable)
  TIFPSVariableType is used in TIFPSComp.OnUseVariable event }
  TIFPSVariableType = (ivtGlobal, ivtParam, ivtVariable);

const
{ Executer internal type for return addresses, can not be used as a type }
  btReturnAddress = 0;
{ A 1 byte unsigned integer (byte) }
  btU8 = 1;
{ A 1 byte signed integer (Shortint) }
  btS8 = 2;
{ A 2 byte unsigned integer (word) }
  btU16 = 3;
{ A 2 byte signed integer (smallint) }
  btS16 = 4;
{ A 4 byte unsigned integer (cardinal/longword) }
  btU32 = 5;
{ A 4 byte signed integer (Integer/Longint) }
  btS32 = 6;
{ A 4 byte float (single) }
  btSingle = 7;
{ A 8 byte float (double) }
  btDouble = 8;
{ A 10 byte float (extended) }
  btExtended = 9;
{ A string }
  btString = 10;
{ A record }
  btRecord = 11;
{ An array}
  btArray = 12;
{ A pointer }
  btPointer = 13;
{ A PChar (internally the same as a string) }
  btPChar = 14;
{ A resource pointer: Variable that can contain things from outside the script engine }
  btResourcePointer = 15;
{ A variant }
  btVariant = 16;
{$IFNDEF IFPS3_NOINT64}
{ An 8 byte signed integer (int64) }
  btS64 = 17;
{$ENDIF}
{a Char (1 byte)}
  btChar = 18;
{$IFNDEF IFPS3_NOWIDESTRING}
{ A wide string}
  btWideString = 19;
{A widechar}
  btWideChar = 20;
{$ENDIF}
{ Compile time procedural pointer (will be btu32 when compiled) }
  btProcPtr = 21;
{Static array}
  btStaticArray = 22;
  {Set}
  btSet = 23;
  {Currency}
  btCurrency = 24;
  {class}
  btClass = 25;
  {Interface}
  btInterface = 26;
  {Compile time: a type}
  btType = 130;
{ Compile time enumeration; This will be a btu32 when compiled }
  btEnum = 129;


{ Make a hash of a string }
function MakeHash(const s: string): Longint;

const
{ Script internal command: Assign command<br>
    Command: TIFPSCommand;<br>
    VarDest, // no data<br>
    VarSrc: TIFPSVariable;<br>
}
  CM_A = 0;
{ Script internal command: Calculate Command<br>
    Command: TIFPSCommand; <br>
    CalcType: Byte;<br>
    <i><br>
      0 = +<br>
      1 = -<br>
      2 = *<br>
      3 = /<br>
      4 = MOD<br>
      5 = SHL<br>
      6 = SHR<br>
      7 = AND<br>
      8 = OR<br>
      9 = XOR<br>
    </i><br>
    VarDest, // no data<br>
    VarSrc: TIFPSVariable;<br>
<br>
}
  CM_CA = 1;
{ Script internal command: Push<br>
    Command: TIFPSCommand; <br>
    Var: TIFPSVariable;<br>
}
  CM_P = 2;
{ Script internal command: Push Var<br>
    Command: TIFPSCommand; <br>
    Var: TIFPSVariable;<br>
}
  CM_PV = 3;
{ Script internal command: Pop<br>
    Command: TIFPSCommand; <br>
}
  CM_PO = 4;
{ Script internal command: Call<br>
    Command: TIFPSCommand; <br>
    ProcNo: Longword;<br>
}
  Cm_C = 5;
{ Script internal command: Goto<br>
    Command: TIFPSCommand; <br>
    NewPosition: Longint; //relative to end of this instruction<br>
}
  Cm_G = 6;
{ Script internal command: Conditional Goto<br>
    Command: TIFPSCommand; <br>
    NewPosition: LongWord; //relative to end of this instruction<br>
    Var: TIFPSVariable; // no data<br>
}
  Cm_CG = 7;
{ Script internal command: Conditional NOT Goto<br>
    Command: TIFPSCommand; <br>
    NewPosition: LongWord; // relative to end of this instruction<br>
    Var: TIFPSVariable; // no data<br>
}
  Cm_CNG = 8;
{ Script internal command: Ret<br>
    Command: TIFPSCommand; <br>
}
  Cm_R = 9;
{ Script internal command: Set Stack Type<br>
    Command: TIFPSCommand; <br>
    NewType: LongWord;<br>
    OffsetFromBase: LongWord;<br>
}
  Cm_ST = 10;
{ Script internal command: Push Type<br>
    Command: TIFPSCommand; <br>
    FType: LongWord;<br>
}
  Cm_Pt = 11;
{ Script internal command: Compare<br>
    Command: TIFPSCommand; <br>
    CompareType: Byte;<br>
    <i><br>
     0 = &gt;=<br>
     1 = &lt;=<br>
     2 = &gt;<br>
     3 = &lt;<br>
     4 = &lt;&gt<br>
     5 = =<br>
    <i><br>
    IntoVar: TIFPSAssignment;<br>
    Compare1, Compare2: TIFPSAssigment;<br>
}
  CM_CO = 12;
{ Script internal command: Call Var<br>
    Command: TIFPSCommand; <br>
    Var: TIFPSVariable;<br>
}
  Cm_cv = 13;
{ Script internal command: Set Pointer<br>
    Command: TIFPSCommand; <br>
    VarDest: TIFPSVariable;<br>
    VarSrc: TIFPSVariable;<br>
}
  cm_sp = 14;
{ Script internal command: Boolean NOT<br>
    Command: TIFPSCommand; <br>
    Var: TIFPSVariable;<br>
}
  cm_bn = 15;
{ Script internal command: Var Minus<br>
    Command: TIFPSCommand; <br>
    Var: TIFPSVariable;
}
  cm_vm = 16;
{ Script internal command: Set Flag<br>
    Command: TIFPSCommand; <br>
    Var: TIFPSVariable;<br>
    DoNot: Boolean;<br>
}
  cm_sf = 17;
{ Script internal command: Flag Goto<br>
    Command: TIFPSCommand; <br>
    Where: Cardinal;<br>
}
  cm_fg = 18;
{ Script internal command: Push Exception Handler<br>
    Command: TIFPSCommand; <br>
    FinallyOffset,<br>
    ExceptionOffset, // FinallyOffset or ExceptionOffset need to be set.<br>
    Finally2Offset,<br>
    EndOfBlock: Cardinal;<br>
}
  cm_puexh = 19;
{ Script internal command: Pop Exception Handler<br>
    Command:TIFPSCommand; <br>
    Position: Byte;<br>
    <i> 0 = end of try/finally/exception block;<br>
      1 = end of first finally<br>
      2 = end of except<br>
      3 = end of second finally<br>
    </i><br>
}
  cm_poexh = 20;
{ Script internal command: Integer NOT<br>
    Command: TIFPSCommand; <br>
    Where: Cardinal;<br>
}
  cm_in = 21;
  {Script internal command: Set Stack Pointer To Copy<br>
      Command: TIFPSCommand; <br>
    Where: Cardinal;<br>
}
  cm_spc = 22;
  {Script internal command: Inc<br>
    Command: TIFPSCommand; <br>
    Var: TIFPSVariable;<br>
  }
  cm_inc = 23;
  {Script internal command: Dec<br>
      Command: TIFPSCommand; <br>
    Var: TIFPSVariable;<br>
  }
  cm_dec = 24;
  {Script internal command: nop<br>
      Command: TIFPSCommand; <br>}
  cm_nop = 255;


type
{Byte}
  TbtU8 = Byte;
{Shortint}
  TbtS8 = ShortInt;
{word}
  TbtU16 = Word;
{Smallint}
  TbtS16 = SmallInt;
{Cardinal/Longword}
  TbtU32 = Cardinal;
{Integer/Longint}
  TbtS32 = Longint;
{Single}
  TbtSingle = Single;
{Double}
  TbtDouble = double;
{Extended}
  TbtExtended = Extended;
{Currency}
  tbtCurrency = Currency;
{String/Pchar}
  TbtString = string;
{$IFNDEF IFPS3_NOINT64}
{ An 8 byte signed integer (int64) }
  tbts64 = int64;
{$ENDIF}
{Chat type}
  tbtchar = char;
{$IFNDEF IFPS3_NOWIDESTRING}
{widestring type}
  tbtwidestring = widestring;
{widechar type}
  tbtwidechar = widechar;
{$ENDIF}
  IPointer = Cardinal; // sizeof(IPointer) has to be the same as Sizeof(Pointer) 
{calling convention type}
  TIFPSCallingConvention = (cdRegister, cdPascal, cdCdecl, cdStdCall);

const
  {Maximum number of items in a list}
  MaxListSize = Maxint div 16;

type
  {PPointerList is pointing to an array of pointers}
  PPointerList = ^TPointerList;
  {An array of pointers}
  TPointerList = array[0..MaxListSize - 1] of Pointer;

  {@abstract(TIfList is the list class used in IFPS3)}
  TIfList = class(TObject)
  protected
    FData: PPointerList;
    FCapacity: Cardinal;
    FCount: Cardinal;
    FCheckCount: Cardinal;
  private
    function GetItem(Nr: Cardinal): Pointer;
    procedure SetItem(Nr: Cardinal; P: Pointer);
  public
    {$IFNDEF IFPS3_NOSMARTLIST}
	{Recreate the list}
    procedure Recreate;
    {$ENDIF}
    property Data: PPointerList read FData;
    {create}
    constructor Create;
	{destroy}
    destructor Destroy; override;
	{Contains the number of items in the list}
    property Count: Cardinal read FCount;
    {Items}
    property Items[nr: Cardinal]: Pointer read GetItem write SetItem; default;
	{Add an item}
    function Add(P: Pointer): Longint;
	{Add a block of items}
    procedure AddBlock(List: PPointerList; Count: Longint);
	{Remove an item}
    procedure Remove(P: Pointer);
	{Remove an item}
    procedure Delete(Nr: Cardinal);
    procedure DeleteLast;
	{Clear the list}
    procedure Clear; virtual;
  end;
  {@abstract(TIFStringList is the string list class used by IFPS3)}
  TIfStringList = class(TObject)
  private
    List: TIfList;
    function GetItem(Nr: LongInt): string;
    procedure SetItem(Nr: LongInt; const s: string);
  public
    {Returns the number of items in the list}
    function Count: LongInt;
    {Items property}
    property Items[Nr: Longint]: string read GetItem write SetItem; default;

	{Add an item to the list}
    procedure Add(const P: string);
	{Delete item no NR}
    procedure Delete(NR: LongInt);
	{Clear the list}
    procedure Clear;
	{create}
    constructor Create;
	{destroy}
    destructor Destroy; override;
  end;


type
  {TIFPasToken is used to store the type of the current token}
  TIfPasToken = (
    CSTI_EOF,
  {Items that are used internally}
    CSTIINT_Comment,
    CSTIINT_WhiteSpace,
  {Tokens}
    CSTI_Identifier,
    CSTI_SemiColon,
    CSTI_Comma,
    CSTI_Period,
    CSTI_Colon,
    CSTI_OpenRound,
    CSTI_CloseRound,
    CSTI_OpenBlock,
    CSTI_CloseBlock,
    CSTI_Assignment,
    CSTI_Equal,
    CSTI_NotEqual,
    CSTI_Greater,
    CSTI_GreaterEqual,
    CSTI_Less,
    CSTI_LessEqual,
    CSTI_Plus,
    CSTI_Minus,
    CSTI_Divide,
    CSTI_Multiply,
    CSTI_Integer,
    CSTI_Real,
    CSTI_String,
    CSTI_Char,
    CSTI_HexInt,
    CSTI_AddressOf,
    CSTI_Dereference,
    CSTI_TwoDots,
  {Identifiers}
    CSTII_and,
    CSTII_array,
    CSTII_begin,
    CSTII_case,
    CSTII_const,
    CSTII_div,
    CSTII_do,
    CSTII_downto,
    CSTII_else,
    CSTII_end,
    CSTII_for,
    CSTII_function,
    CSTII_if,
    CSTII_in,
    CSTII_mod,
    CSTII_not,
    CSTII_of,
    CSTII_or,
    CSTII_procedure,
    CSTII_program,
    CSTII_repeat,
    CSTII_record,
    CSTII_set,
    CSTII_shl,
    CSTII_shr,
    CSTII_then,
    CSTII_to,
    CSTII_type,
    CSTII_until,
    CSTII_uses,
    CSTII_var,
    CSTII_while,
    CSTII_with,
    CSTII_xor,
    CSTII_exit,
    CSTII_class,
    CSTII_constructor,
    CSTII_destructor,
    CSTII_inherited,
    CSTII_private,
    CSTII_public,
    CSTII_published,
    CSTII_protected,
    CSTII_property,
    CSTII_virtual,
    CSTII_override,
    CSTII_As,
    CSTII_Is,
    CSTII_Unit,
    CSTII_Try,
    CSTII_Except,
    CSTII_Finally,
    CSTII_External,
    CSTII_Forward,
    CSTII_Export,
    CSTII_Label,
    CSTII_Goto,
    CSTII_Chr,
    CSTII_Ord,
    CSTII_Interface,
    CSTII_Implementation,
    CSTII_out,
    CSTII_nil
    );
  {TIFParserErrorKind is used to store the parser error}
  TIFParserErrorKind = (iNoError, iCommentError, iStringError, iCharError, iSyntaxError);
  TIFParserErrorEvent = procedure (Parser: TObject; Kind: TIFParserErrorKind) of object;

  {@abstract(TIfPacalParser is the parser used to parse the scripts)}
  TIfPascalParser = class(TObject)
  private
    FData: string;
    FText: PChar;
    FLastEnterPos, FRow, FRealPosition, FTokenLength: Cardinal;
    FTokenId: TIfPasToken;
    FToken: string;
    FOriginalToken: string;
    FParserError: TIFParserErrorEvent;
    FEnableComments: Boolean;
    FEnableWhitespaces: Boolean;
    function GetCol: Cardinal;
    // only applicable when Token in [CSTI_Identifier, CSTI_Integer, CSTI_Real, CSTI_String, CSTI_Char, CSTI_HexInt]
  public
    property EnableComments: Boolean read FEnableComments;
    property EnableWhitespaces: Boolean read FEnableWhitespaces;
    {Go to the next token}
    procedure Next;
    {Return the token in case it is a string, char, integer, number or identifier}
    property GetToken: string read FToken;
    {Return the token but do not uppercase it}
    property OriginalToken: string read FOriginalToken;
    {The current token position}
    property CurrTokenPos: Cardinal read FRealPosition;
    {The current token ID}
    property CurrTokenID: TIFPasToken read FTokenId;
    {The Current row}
    property Row: Cardinal read FRow;
    {The current col}
    property Col: Cardinal read GetCol;
    {Load a script}
    procedure SetText(const Data: string);
    {Parser error event will be called on (syntax) errors in the script}
    property OnParserError: TIFParserErrorEvent read FParserError write FParserError;
  end;
{Convert a float to a string}
function FloatToStr(E: Extended): string;
{Fast lowercase}
function FastLowerCase(const s: String): string;
{Return the first word of a string}
function Fw(const S: string): string;
{Integer to string conversion}
function IntToStr(I: LongInt): string;
{String to integer}
function StrToIntDef(const S: string; Def: LongInt): LongInt;
{String to integer}
function StrToInt(const S: string): LongInt;
function StrToFloat(const s: string): Extended;
{Fast uppercase}
function FastUpperCase(const s: String): string;
{Get the first word and remove it}
function GRFW(var s: string): string;
function GRLW(var s: string): string;

const
  {The Capacity increment that list uses}
  FCapacityInc = 32;
{$IFNDEF IFPS3_NOSMARTLIST}
  {The maximum number of "resize" operations on the list before it's recreated}
  FMaxCheckCount = (FCapacityInc div 4) * 64;
{$ENDIF}


implementation

function MakeHash(const s: string): Longint;
{small hash maker}
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(s) do
    Result := ((Result shl 7) or (Result shr 25)) + Ord(s[I]);
end;

function GRFW(var s: string): string;
var
  l: Longint;
begin
  l := 1;
  while l <= Length(s) do
  begin
    if s[l] = ' ' then
    begin
      Result := copy(s, 1, l - 1);
      Delete(s, 1, l);
      exit;
    end;
    l := l + 1;
  end;
  Result := s;
  s := '';
end;

function GRLW(var s: string): string;
var
  l: Longint;
begin
  l := Length(s);
  while l >= 1 do
  begin
    if s[l] = ' ' then
    begin
      Result := copy(s, l+1, MaxInt);
      Delete(s, l, MaxInt);
      exit;
    end;
    Dec(l);
  end;
  Result := s;
  s := '';
end;

function StrToFloat(const s: string): Extended;
var
  i: longint;
begin
  Val(s, Result, i);
  if i <> 0 then raise Exception.Create('Invalid float'); 
end;
//-------------------------------------------------------------------

function IntToStr(I: LongInt): string;
var
  s: string;
begin
  Str(i, s);
  IntToStr := s;
end;
//-------------------------------------------------------------------

function FloatToStr(E: Extended): string;
var
  s: string;
begin
  Str(e:0:12, s);
  result := s;
end;

function StrToInt(const S: string): LongInt;
var
  e: Integer;
  Res: LongInt;
begin
  Val(S, Res, e);
  if e <> 0 then
    StrToInt := -1
  else
    StrToInt := Res;
end;
//-------------------------------------------------------------------

function StrToIntDef(const S: string; Def: LongInt): LongInt;
var
  e: Integer;
  Res: LongInt;
begin
  Val(S, Res, e);
  if e <> 0 then
    StrToIntDef := Def
  else
    StrToIntDef := Res;
end;
//-------------------------------------------------------------------

constructor TIfList.Create;
begin
  inherited Create;
  FCount := 0;
  FCapacity := 16;
  {$IFNDEF IFPS3_NOSMARTLIST}
  FCheckCount := 0;
  {$ENDIF}
  GetMem(FData, 64);
end;


function MM(i1,i2: Integer): Integer;
begin
  if ((i1 div i2) * i2) < i1 then
    mm := (i1 div i2 + 1) * i2
  else
    mm := (i1 div i2) * i2;
end;

{$IFNDEF IFPS3_NOSMARTLIST}
procedure TIfList.Recreate;
var
  NewData: PPointerList;
  NewCapacity: Cardinal;
  I: Longint;

begin

  FCheckCount := 0;
  NewCapacity := mm(FCount, FCapacityInc);
  if NewCapacity < 64 then NewCapacity := 64;
  GetMem(NewData, NewCapacity * 4);
  for I := 0 to Longint(FCount) -1 do
  begin
    NewData^[i] := FData^[I];
  end;
  FreeMem(FData, FCapacity * 4);
  FData := NewData;
  FCapacity := NewCapacity;
end;
{$ENDIF}

//-------------------------------------------------------------------

function TIfList.Add(P: Pointer): Longint;
begin
  if FCount >= FCapacity then
  begin
    Inc(FCapacity, FCapacityInc);// := FCount + 1;
    ReAllocMem(FData, FCapacity shl 2);
  end;
  FData[FCount] := P; // Instead of SetItem
  Result := FCount;
  Inc(FCount);
{$IFNDEF IFPS3_NOSMARTLIST}
  Inc(FCheckCount);
  if FCheckCount > FMaxCheckCount then Recreate;
{$ENDIF}
end;

procedure TIfList.AddBlock(List: PPointerList; Count: Longint);
var
  L: Longint;

begin
  if Longint(FCount) + Count > Longint(FCapacity) then
  begin
    Inc(FCapacity, mm(Count, FCapacityInc));
    ReAllocMem(FData, FCapacity shl 2);
  end;
  for L := 0 to Count -1 do
  begin
    FData^[FCount] := List^[L];
    Inc(FCount);
  end;
{$IFNDEF IFPS3_NOSMARTLIST}
  Inc(FCheckCount);
  if FCheckCount > FMaxCheckCount then Recreate;
{$ENDIF}
end;


//-------------------------------------------------------------------

procedure TIfList.DeleteLast;
begin
  if FCount = 0 then Exit;
  Dec(FCount);
{$IFNDEF IFPS3_NOSMARTLIST}
    Inc(FCheckCount);
    if FCheckCount > FMaxCheckCount then Recreate;
{$ENDIF}
end;



procedure TIfList.Delete(Nr: Cardinal);
begin
  if FCount = 0 then Exit;
  if Nr < FCount then
  begin
    Move(FData[Nr + 1], FData[Nr], (FCount - Nr) * 4);
    Dec(FCount);
{$IFNDEF IFPS3_NOSMARTLIST}
    Inc(FCheckCount);
    if FCheckCount > FMaxCheckCount then Recreate;
{$ENDIF}
  end;
end;
//-------------------------------------------------------------------

procedure TIfList.Remove(P: Pointer);
var
  I: Cardinal;
begin
  if FCount = 0 then Exit;
  I := 0;
  while I < FCount do
  begin
    if FData[I] = P then
    begin
      Delete(I);
      Exit;
    end;
    Inc(I);
  end;
end;
//-------------------------------------------------------------------

procedure TIfList.Clear;
begin
  FCount := 0;
{$IFNDEF IFPS3_NOSMARTLIST}
  Recreate;
{$ENDIF}
end;
//-------------------------------------------------------------------

destructor TIfList.Destroy;
begin
  FreeMem(FData, FCapacity * 4);
  inherited Destroy;
end;
//-------------------------------------------------------------------

procedure TIfList.SetItem(Nr: Cardinal; P: Pointer);
begin
  if (FCount = 0) or (Nr >= FCount) then
    Exit;
  FData[Nr] := P;
end;
//-------------------------------------------------------------------

function TifList.GetItem(Nr: Cardinal): Pointer;  {12}
begin
  if Nr < FCount then
     GetItem := FData[Nr]
  else
    GetItem := nil;
end;



//-------------------------------------------------------------------

function TIfStringList.Count: LongInt;
begin
  count := List.count;
end;
type pStr = ^string;

//-------------------------------------------------------------------

function TifStringList.GetItem(Nr: LongInt): string;
var
  S: PStr;
begin
  s := List.GetItem(Nr);
  if s = nil then
    Result := ''
  else

    Result := s^;
end;
//-------------------------------------------------------------------


procedure TifStringList.SetItem(Nr: LongInt; const s: string);
var
  p: PStr;
begin
  p := List.GetItem(Nr);
  if p = nil
    then
    Exit;
  p^ := s;
end;
//-------------------------------------------------------------------

procedure TifStringList.Add(const P: string);
var
  w: PStr;
begin
  new(w);
  w^ := p;
  List.Add(w);
end;
//-------------------------------------------------------------------

procedure TifStringList.Delete(NR: LongInt);
var
  W: PStr;
begin
  W := list.getitem(nr);
  if w<>nil then
  begin
    dispose(w);
  end;
  list.Delete(Nr);
end;

procedure TifStringList.Clear;
begin
  while List.Count > 0 do Delete(0);
end;

constructor TifStringList.Create;
begin
  inherited Create;
  List := TIfList.Create;
end;

destructor TifStringList.Destroy;
begin
  while List.Count > 0 do
    Delete(0);
  List.Destroy;
  inherited Destroy;
end;

//-------------------------------------------------------------------


function Fw(const S: string): string; //  First word
var
  x: integer;
begin
  x := pos(' ', s);
  if x > 0
    then Fw := Copy(S, 1, x - 1)
  else Fw := S;
end;
//-------------------------------------------------------------------
function FastUpperCase(const s: String): string;
{Fast uppercase}
var
  I: Integer;
  C: Char;
begin
  Result := S;
  I := Length(Result);
  while I > 0 do
  begin
    C := Result[I];
    if c in [#97..#122] then
      Dec(Byte(Result[I]), 32);
    Dec(I);
  end;
end;
function FastLowerCase(const s: String): string;
{Fast lowercase}
var
  I: Integer;
  C: Char;
begin
  Result := S;
  I := Length(Result);
  while I > 0 do
  begin
    C := Result[I];
    if C in [#65..#90] then
      Inc(Byte(Result[I]), 32);
    Dec(I);
  end;
end;
//-------------------------------------------------------------------

type
  TRTab = record
    name: string;
    c: TIfPasToken;
  end;


const
  KEYWORD_COUNT = 63;
  LookupTable: array[0..KEYWORD_COUNT - 1] of TRTab = (
      (name: 'AND'; c: CSTII_and),
      (name: 'ARRAY'; c: CSTII_array),
      (name: 'AS'; c: CSTII_as),
      (name: 'BEGIN'; c: CSTII_begin),
      (name: 'CASE'; c: CSTII_case),
      (name: 'CHR'; c: CSTII_chr),
      (name: 'CLASS'; c: CSTII_class),
      (name: 'CONST'; c: CSTII_const),
      (name: 'CONSTRUCTOR'; c: CSTII_constructor),
      (name: 'DESTRUCTOR'; c: CSTII_destructor),
      (name: 'DIV'; c: CSTII_div),
      (name: 'DO'; c: CSTII_do),
      (name: 'DOWNTO'; c: CSTII_downto),
      (name: 'ELSE'; c: CSTII_else),
      (name: 'END'; c: CSTII_end),
      (name: 'EXCEPT'; c: CSTII_except),
      (name: 'EXIT'; c: CSTII_exit),
      (name: 'EXPORT'; c: CSTII_Export),
      (name: 'EXTERNAL'; c: CSTII_External),
      (name: 'FINALLY'; c: CSTII_finally),
      (name: 'FOR'; c: CSTII_for),
      (name: 'FORWARD'; c: CSTII_Forward),
      (name: 'FUNCTION'; c: CSTII_function),
      (name: 'GOTO'; c: CSTII_Goto),
      (name: 'IF'; c: CSTII_if),
      (name: 'IMPLEMENTATION'; c: CSTII_Implementation),
      (name: 'IN'; c: CSTII_in),
      (name: 'INHERITED'; c: CSTII_inherited),
      (name: 'INTERFACE'; c: CSTII_Interface),
      (name: 'IS'; c: CSTII_is),
      (name: 'LABEL'; c: CSTII_Label),
      (name: 'MOD'; c: CSTII_mod),
      (name: 'NIL'; c: CSTII_nil),
      (name: 'NOT'; c: CSTII_not),
      (name: 'OF'; c: CSTII_of),
      (name: 'OR'; c: CSTII_or),
      (name: 'ORD'; c: CSTII_ord),
      (name: 'OUT'; c: CSTII_Out),
      (name: 'OVERRIDE'; c: CSTII_override),
      (name: 'PRIVATE'; c: CSTII_private),
      (name: 'PROCEDURE'; c: CSTII_procedure),
      (name: 'PROGRAM'; c: CSTII_program),
      (name: 'PROPERTY'; c: CSTII_property),
      (name: 'PROTECTED'; c: CSTII_protected),
      (name: 'PUBLIC'; c: CSTII_public),
      (name: 'PUBLISHED'; c: CSTII_published),
      (name: 'RECORD'; c: CSTII_record),
      (name: 'REPEAT'; c: CSTII_repeat),
      (name: 'SET'; c: CSTII_set),
      (name: 'SHL'; c: CSTII_shl),
      (name: 'SHR'; c: CSTII_shr),
      (name: 'THEN'; c: CSTII_then),
      (name: 'TO'; c: CSTII_to),
      (name: 'TRY'; c: CSTII_try),
      (name: 'TYPE'; c: CSTII_type),
      (name: 'UNIT'; c: CSTII_Unit),
      (name: 'UNTIL'; c: CSTII_until),
      (name: 'USES'; c: CSTII_uses),
      (name: 'VAR'; c: CSTII_var),
      (name: 'VIRTUAL'; c: CSTII_virtual),
      (name: 'WHILE'; c: CSTII_while),
      (name: 'WITH'; c: CSTII_with),
      (name: 'XOR'; c: CSTII_xor));

function TIfPascalParser.GetCol: Cardinal;
begin
  Result := FRealPosition - FLastEnterPos + 1;
end;

procedure TIfPascalParser.Next;
var
  Err: TIFParserErrorKind;
  FLastUpToken: string;
  function CheckReserved(Const S: ShortString; var CurrTokenId: TIfPasToken): Boolean;
  var
    L, H, I: LongInt;
    J: Char;
    SName: ShortString;
  begin
    L := 0;
    J := S[0];
    H := KEYWORD_COUNT-1;
    while L <= H do
    begin
      I := (L + H) shr 1;
      SName := LookupTable[i].Name;
      if J = SName[0] then
      begin
        if S = SName then
        begin
          CheckReserved := True;
          CurrTokenId := LookupTable[I].c;
          Exit;
        end;
        if S > SName then
          L := I + 1
        else
          H := I - 1;
      end else
        if S > SName then
          L := I + 1
        else
          H := I - 1;
    end;
    CheckReserved := False;
  end;
  //-------------------------------------------------------------------

  function GetToken(CurrTokenPos, CurrTokenLen: Cardinal): string;
  var
    s: string;
  begin
    SetLength(s, CurrTokenLen);
    Move(FText[CurrTokenPos], S[1], CurrtokenLen);
    GetToken := s;
  end;

  function ParseToken(var CurrTokenPos, CurrTokenLen: Cardinal; var CurrTokenId: TIfPasToken): TIFParserErrorKind;
  {Parse the token}
  var
    ct, ci: Cardinal;
    hs: Boolean;
    p: PChar;
  begin
    ParseToken := iNoError;
    ct := CurrTokenPos;
    case FText[ct] of
      #0:
        begin
          CurrTokenId := CSTI_EOF;
          CurrTokenLen := 0;
        end;
      'A'..'Z', 'a'..'z', '_':
        begin
          ci := ct + 1;
          while (FText[ci] in ['_', '0'..'9', 'a'..'z', 'A'..'Z']) do begin
            Inc(ci);
          end;
          CurrTokenLen := ci - ct;

          FLastUpToken := GetToken(CurrTokenPos, CurrtokenLen);
          p := pchar(FLastUpToken);
          while p^<>#0 do
          begin
            if p^ in [#97..#122] then
              Dec(Byte(p^), 32);
            inc(p);
          end;
          if not CheckReserved(FLastUpToken, CurrTokenId) then
          begin
            CurrTokenId := CSTI_Identifier;
          end;
        end;
      '$':
        begin
          ci := ct + 1;

          while (FText[ci] in ['0'..'9', 'a'..'f', 'A'..'F'])
            do Inc(ci);

          CurrTokenId := CSTI_HexInt;
          CurrTokenLen := ci - ct;
        end;

      '0'..'9':
        begin
          hs := False;
          ci := ct;
          while (FText[ci] in ['0'..'9']) do
          begin
            Inc(ci);
            if (FText[ci] = '.') and (not hs) then
            begin
              if FText[ci+1] = '.' then break;
              hs := True;
              Inc(ci);
            end;
          end;
          if (FText[ci] in ['E','e']) and ((FText[ci+1] in ['0'..'9']) 
            or ((FText[ci+1] in ['+','-']) and (FText[ci+2] in ['0'..'9']))) then 
          begin
            hs := True;
          	Inc(ci);
          	if FText[ci] in ['+','-'] then
          		Inc(ci);
          	repeat
          		Inc(ci);
          	until not (FText[ci] in ['0'..'9']);
          end;

          if hs
            then CurrTokenId := CSTI_Real
          else CurrTokenId := CSTI_Integer;

          CurrTokenLen := ci - ct;
        end;


      #39:
        begin
          ci := ct + 1;
          while (FText[ci] <> #0) and (FText[ci] <> #13) and (FText[ci] <> #10) and (FText[ci] <> #39) do
          begin
            Inc(ci);
          end;
          if FText[ci] = #39 then
            CurrTokenId := CSTI_String
          else
          begin
            CurrTokenId := CSTI_String;
            ParseToken := iStringError;
          end;
          CurrTokenLen := ci - ct + 1;
        end;
      '#':
        begin
          ci := ct + 1;
          if FText[ci] = '$' then
          begin
            inc(ci);
            while (FText[ci] in ['A'..'F', 'a'..'f', '0'..'9']) do begin
              Inc(ci);
            end;
            CurrTokenId := CSTI_Char;
            CurrTokenLen := ci - ct;
          end else
          begin
            while (FText[ci] in ['0'..'9']) do begin
              Inc(ci);
            end;         
            if FText[ci] in ['A'..'Z', 'a'..'z', '_'] then
            begin
              ParseToken := iCharError;
              CurrTokenId := CSTI_Char;
            end else
              CurrTokenId := CSTI_Char;
            CurrTokenLen := ci - ct;
          end;
        end;
      '=':
        begin
          CurrTokenId := CSTI_Equal;
          CurrTokenLen := 1;
        end;
      '>':
        begin
          if FText[ct + 1] = '=' then
          begin
            CurrTokenid := CSTI_GreaterEqual;
            CurrTokenLen := 2;
          end else
          begin
            CurrTokenid := CSTI_Greater;
            CurrTokenLen := 1;
          end;
        end;
      '<':
        begin
          if FText[ct + 1] = '=' then
          begin
            CurrTokenId := CSTI_LessEqual;
            CurrTokenLen := 2;
          end else
            if FText[ct + 1] = '>' then
            begin
              CurrTokenId := CSTI_NotEqual;
              CurrTokenLen := 2;
            end else
            begin
              CurrTokenId := CSTI_Less;
              CurrTokenLen := 1;
            end;
        end;
      ')':
        begin
          CurrTokenId := CSTI_CloseRound;
          CurrTokenLen := 1;
        end;
      '(':
        begin
          if FText[ct + 1] = '*' then
          begin
            ci := ct + 1;
            while (FText[ci] <> #0) do begin
              if (FText[ci] = '*') and (FText[ci + 1] = ')') then
                Break;
              if FText[ci] = #13 then
              begin
                inc(FRow);
                if FText[ci+1] = #10 then
                  inc(ci);
                FLastEnterPos := ci +1;
              end else if FText[ci] = #10 then
              begin
                inc(FRow);
                FLastEnterPos := ci +1;
              end;
              Inc(ci);
            end;
            if (FText[ci] = #0) then
            begin
              CurrTokenId := CSTIINT_Comment;
              ParseToken := iCommentError;
            end else
            begin
              CurrTokenId := CSTIINT_Comment;
              Inc(ci, 2);
            end;
            CurrTokenLen := ci - ct;
          end
          else
          begin
            CurrTokenId := CSTI_OpenRound;
            CurrTokenLen := 1;
          end;
        end;
      '[':
        begin
          CurrTokenId := CSTI_OpenBlock;
          CurrTokenLen := 1;
        end;
      ']':
        begin
          CurrTokenId := CSTI_CloseBlock;
          CurrTokenLen := 1;
        end;
      ',':
        begin
          CurrTokenId := CSTI_Comma;
          CurrTokenLen := 1;
        end;
      '.':
        begin
          if FText[ct + 1] = '.' then
          begin
            CurrTokenLen := 2;
            CurrTokenId := CSTI_TwoDots;
          end else
          begin
            CurrTokenId := CSTI_Period;
            CurrTokenLen := 1;
          end;
        end;
      '@':
        begin
          CurrTokenId := CSTI_AddressOf;
          CurrTokenLen := 1;
        end;
      '^':
        begin
          CurrTokenId := CSTI_Dereference;
          CurrTokenLen := 1;
        end;
      ';':
        begin
          CurrTokenId := CSTI_Semicolon;
          CurrTokenLen := 1;
        end;
      ':':
        begin
          if FText[ct + 1] = '=' then
          begin
            CurrTokenId := CSTI_Assignment;
            CurrTokenLen := 2;
          end else
          begin
            CurrTokenId := CSTI_Colon;
            CurrTokenLen := 1;
          end;
        end;
      '+':
        begin
          CurrTokenId := CSTI_Plus;
          CurrTokenLen := 1;
        end;
      '-':
        begin
          CurrTokenId := CSTI_Minus;
          CurrTokenLen := 1;
        end;
      '*':
        begin
          CurrTokenId := CSTI_Multiply;
          CurrTokenLen := 1;
        end;
      '/':
        begin
          if FText[ct + 1] = '/' then
          begin
            ci := ct + 1;
            while (FText[ci] <> #0) and (FText[ci] <> #13) and
              (FText[ci] <> #10) do begin
              Inc(ci);
            end;
            if (FText[ci] = #0) then
            begin
              CurrTokenId := CSTIINT_Comment;
            end else
            begin
              CurrTokenId := CSTIINT_Comment;
            end;
            CurrTokenLen := ci - ct;
          end else
          begin
            CurrTokenId := CSTI_Divide;
            CurrTokenLen := 1;
          end;
        end;
      #32, #9, #13, #10:
        begin
          ci := ct;
          while (FText[ci] in [#32, #9, #13, #10]) do
          begin
            if FText[ci] = #13 then
            begin
              inc(FRow);
              if FText[ci+1] = #10 then
                inc(ci);
              FLastEnterPos := ci +1;
            end else if FText[ci] = #10 then
            begin
              inc(FRow);
              FLastEnterPos := ci +1;
            end;
            Inc(ci);
          end;
          CurrTokenId := CSTIINT_WhiteSpace;
          CurrTokenLen := ci - ct;
        end;
      '{':
        begin
          ci := ct + 1;
          while (FText[ci] <> #0) and (FText[ci] <> '}') do begin
            if FText[ci] = #13 then
            begin
              inc(FRow);
              if FText[ci+1] = #10 then
                inc(ci);
              FLastEnterPos := ci + 1;
            end else if FText[ci] = #10 then
            begin
              inc(FRow);
              FLastEnterPos := ci + 1;
            end;
            Inc(ci);
          end;
          if (FText[ci] = #0) then
          begin
            CurrTokenId := CSTIINT_Comment;
            ParseToken := iCommentError;
          end else
            CurrTokenId := CSTIINT_Comment;
          CurrTokenLen := ci - ct + 1;
        end;
    else
      begin
        ParseToken := iSyntaxError;
        CurrTokenId := CSTIINT_Comment;
        CurrTokenLen := 1;
      end;
    end;
  end;
  //-------------------------------------------------------------------
begin
  if FText = nil then
  begin
    FTokenLength := 0;
    FRealPosition := 0;
    FTokenId := CSTI_EOF;
    Exit;
  end;
  repeat
    FRealPosition := FRealPosition + FTokenLength;
    Err := ParseToken(FRealPosition, FTokenLength, FTokenID);
    if Err <> iNoError then
    begin
      FTokenLength := 0;
      FTokenId := CSTI_EOF;
      FToken := '';
      FOriginalToken := '';
      if @FParserError <> nil then FParserError(Self, Err);
      exit;
    end;
    case FTokenID of
      CSTIINT_Comment: if not FEnableComments then Continue else
        begin
          SetLength(FOriginalToken, FTokenLength);
          Move(FText[CurrTokenPos], FOriginalToken[1], FTokenLength);
          FToken := FOriginalToken;
        end;
      CSTIINT_WhiteSpace: if not FEnableWhitespaces then Continue else
        begin
          SetLength(FOriginalToken, FTokenLength);
          Move(FText[CurrTokenPos], FOriginalToken[1], FTokenLength);
          FToken := FOriginalToken;
        end;
      CSTI_Integer, CSTI_Real, CSTI_String, CSTI_Char, CSTI_HexInt:
        begin
          SetLength(FOriginalToken, FTokenLength);
          Move(FText[CurrTokenPos], FOriginalToken[1], FTokenLength);
          FToken := FOriginalToken;
        end;
      CSTI_Identifier:
        begin
          SetLength(FOriginalToken, FTokenLength);
          Move(FText[CurrTokenPos], FOriginalToken[1], FTokenLength);
          FToken := FLastUpToken;
        end;
    else
      begin
        FOriginalToken := '';
        FToken := '';
      end;
    end;
    Break;
  until False;
end;

procedure TIfPascalParser.SetText(const Data: string);
begin
  FData := Data;
  FText := Pointer(FData);
  FTokenLength := 0;
  FRealPosition := 0;
  FTokenId := CSTI_EOF;
  FLastEnterPos := 0;
  FRow := 1;
  Next;
end;

end.


