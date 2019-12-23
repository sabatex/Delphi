{
@abstract(The compiler part of the script engine)
@author(Carlo Kok <ck@carlo-kok.com>)

ifpscomp is the compiler part of the script engine. It implements a
pascal to byte code compiler that can be loaded with executer part of
the script engine.<br>
<br>
Innerfuse Pascal Script III<br>
Copyright (C) 2000-2004 by Carlo Kok <ck@@carlo-kok.com><br>
<br>
Standard functions registered by the script engine.<br>
<tt>
function floattostr(e: extended): string;<br>
function inttostr(i: Longint): string;   <br>
function strtoint(s: string): Longint;<br>
function strtointdef(s: string; def: Longint): Longint;<br>
function copy(s: string; ifrom, icount: Longint): string;<br>
function pos(substr, s: string): Longint;<br>
procedure delete(var s: string; ifrom, icount: Longint);<br>
procedure insert(s: string; var s2: string; ipos: Longint);<br>
function getarraylength(var v: array): Integer;<br>
procedure setarraylength(var v: array; i: Integer);<br>

Function StrGet(var S : String; I : Integer) : Char;<br>
procedure StrSet(c : Char; I : Integer; var s : String);<br>
Function Uppercase(s : string) : string;<br>
Function Lowercase(s : string) : string;<br>
Function AnsiUppercase(s : string) : string;<br>
Function AnsiLowercase(s : string) : string;<br>
Function Trim(s : string) : string;<br>
Function Length(s : String) : Longint;<br>
procedure SetLength(var S: String; L: Longint);<br>
Function Sin(e : Extended) : Extended;<br>
Function Cos(e : Extended) : Extended;<br>
Function Sqrt(e : Extended) : Extended;<br>
Function Round(e : Extended) : Longint;<br>
Function Trunc(e : Extended) : Longint;<br>
Function Int(e : Extended) : Extended;<br>
Function Pi : Extended;<br>
Function Abs(e : Extended) : Extended;<br>
function StrToFloat(s: string): Extended;<br>
Function FloatToStr(e : Extended) : String;<br>
Function Padl(s : string;I : longInt) : string;<br>
Function Padr(s : string;I : longInt) : string;<br>
Function Padz(s : string;I : longInt) : string;<br>
Function Replicate(c : char;I : longInt) : string;<br>
Function StringOfChar(c : char;I : longInt) : string;<br>
function StrToInt64(s: string): int64; // only when int64 is available<br>
function Int64ToStr(i: Int64): string; // only when int64 is available<br>
function SizeOf(c: const): Longint;<br>
<br>
<br>
type<br>
  TVarType = Word;<br>
  varEmpty    = varempty;<br>
  varNull     = varnull;<br>
  varSmallint = varsmallint;<br>
  varInteger  = varinteger;<br>
  varSingle   = varsingle;<br>
  varDouble   = vardouble;<br>
  varCurrency = varcurrency;<br>
  varDate     = vardate;<br>
  varOleStr   = varolestr;<br>
  varDispatch = vardispatch;<br>
  varError    = varerror;<br>
  varBoolean  = varboolean;<br>
  varVariant  = varvariant;<br>
  varUnknown  = varunknown;<br>
  varShortInt = varshortint;<br> // D6+
  varByte     = varbyte;<br> // D6+
  varWord     = varword;<br> // D6+
  varLongWord = varlongword;<br> // D6+
  varInt64    = varint64;<br> // D6+
  varStrArg   = varstrarg;<br>
  varString   = varstring;<br>
  varAny      = varany;<br>
  varTypeMask = vartypemask;<br>
  varArray    = vararray;<br>
  varByRef    = varByRef;<br>
                             <br>
function Unassigned: Variant;<br>
function Null: Variant;<br>
function VarType(const V: Variant): TVarType;<br>

<br>
type<br>
  TIFException = (ErNoError, erCannotImport, erInvalidType, ErInternalError,<br>
    erInvalidHeader, erInvalidOpcode, erInvalidOpcodeParameter, erNoMainProc,<br>
    erOutOfGlobalVarsRange, erOutOfProcRange, ErOutOfRange, erOutOfStackRange,<br>
    ErTypeMismatch, erUnexpectedEof, erVersionError, ErDivideByZero, ErMathError,<br>
    erCouldNotCallProc, erOutofRecordRange, erOutOfMemory, erException,<br>
    erNullPointerException, erNullVariantError, erInterfaceNotSupported, erCustomError);<br>
<br>
<br>
procedure RaiseLastException;<br>
procedure RaiseException(Ex: TIFException; Param: string);<br>
function ExceptionType: TIFException;<br>
function ExceptionParam: string;<br>
function ExceptionProc: Cardinal;<br>
function ExceptionPos: Cardinal;<br>
function ExceptionToString(er: TIFException; Param: string): string;<br>

<br><br>
function IDispatchInvoke(Self: IDispatch; PropertySet: Boolean; const Name: String; Par: array of variant): variant;<br>
</tt>
}
unit ifpscomp;
{$I ifps3_def.inc}
interface
uses
  {$IFNDEF IFPS3_D3PLUS}{$IFNDEF IFPS3_NOINTERFACES}Windows, Ole2,{$ENDIF}{$ENDIF}{$IFDEF FPC}Windows, {$ENDIF}SysUtils, ifps3utl;

    
type
{$IFNDEF IFPS3_NOINTERFACES}
  TIFPSInterface = class;
{$ENDIF}
  {The mode this parameter was passed}
  TIFPSParameterMode = (pmIn, pmOut, pmInOut);
  TIFPSPascalCompiler = class;
  TIFPSType = class;
  TIFPSValue = class;
  TIFPSParameters = class;
  {Internal type used to store the current block type}
  TIFPSSubOptType = (tMainBegin, tProcBegin, tSubBegin, tOneLiner, tifOneliner, tRepeat, tTry, tTryEnd);


  {TIFPSExternalClass is used when external classes need to be called}
  TIFPSCompileTimeClass = class;
  TIFPSAttributes = class;
  TIFPSAttribute = class;
  {@abstract(Compiler exception)}
  EIFPSCompilerException = class(Exception) end;
  {the declaration for one parameter}
  TIFPSParameterDecl = class(TObject)
  private
    FName: string;
    FOrgName: string;
    FMode: TIFPSParameterMode;
    FType: TIFPSType;
    procedure SetName(const s: string);
  public
    property Name: string read FName;
    property OrgName: string read FOrgName write SetName;
    property aType: TIFPSType read FType write FType;
    property Mode: TIFPSParameterMode read FMode write FMode;
  end;

  {The declaration of all parameters}
  TIFPSParametersDecl = class(TObject)
  private
    FParams: TIfList;
    FResult: TIFPSType;
    function GetParam(I: Longint): TIFPSParameterDecl;
    function GetParamCount: Longint;
  public
    property Params[I: Longint]: TIFPSParameterDecl read GetParam;
    property ParamCount: Longint read GetParamCount;

    function AddParam: TIFPSParameterDecl;
    procedure DeleteParam(I: Longint);

    property Result : TIFPSType read FResult write FResult;

    procedure Assign(Params: TIFPSParametersDecl);

    function Same(d: TIFPSParametersDecl): boolean;

    constructor Create;
    destructor Destroy; override;
  end;

  {@abstract(TIFPSRegProc contains all information needed for external function registered to the script engine.)}
  TIFPSRegProc = class(TObject)
  private
    FNameHash: Longint;
    FName: string;
    FDecl: TIFPSParametersDecl;
    FExportName: Boolean;
    FImportDecl: string;
    FOrgName: string;
    procedure SetName(const Value: string);
  public
    {Original name}
    property OrgName: string read FOrgName write FOrgName;
	{The actual name of this function}
    property Name: string read FName write SetName;
    {A hash of the name of this function}
    property NameHash: Longint read FNameHash;
	{The header of this function the procedure header format, see @link(TIFPSInternalProcedure)	}
    property Decl: TIFPSParametersDecl read FDecl;
	{When set to true, the script engine stores the name of this function if ImportDecl is not '' and it's used }
    property ExportName: Boolean read FExportName write FExportName;
	{information that is needed for this function to import it, used for the classes library and dll library.}
    property ImportDecl: string read FImportDecl write FImportDecl;

    constructor Create;
    destructor Destroy; override;
  end;
  {Pointer to a @link(TIFPSRegProc)}
  PIFPSRegProc = TIFPSRegProc;
  {Pointer to a @link(TIfRVariant) variant}
  PIfRVariant = ^TIfRVariant;
  {@abstract(A compile time variant).
  FType is the type number of this variant. Basetype is the basetype of the variant (see @link(TIFPSBaseType)).}
  TIfRVariant = record
    FType: TIFPSType;
    case Byte of
      1: (tu8: TbtU8);
      2: (tS8: TbtS8);
      3: (tu16: TbtU16);
      4: (ts16: TbtS16);
      5: (tu32: TbtU32);
      6: (ts32: TbtS32);
      7: (tsingle: TbtSingle);
      8: (tdouble: TbtDouble);
      9: (textended: TbtExtended);
      11: (tcurrency: tbtCurrency);
      10: (tstring: Pointer);
      {$IFNDEF IFPS3_NOINT64}
      17: (ts64: Tbts64);
      {$ENDIF}
      19: (tchar: tbtChar);
      {$IFNDEF IFPS3_NOWIDESTRING}
      18: (twidestring: Pointer);
      20: (twidechar: tbtwidechar);
      {$ENDIF}
      21: (ttype: TIFPSType);
  end;
  {@abstract(TIFPSRecordFieldTypeDef is used to store record field information, see @link(TIFPSRecordType))}
  TIFPSRecordFieldTypeDef = class(TObject)
  private
    FFieldOrgName: string;
    FFieldName: string;
    FFieldNameHash: Longint;
    FType: TIFPSType;
    procedure SetFieldOrgName(const Value: string);
  public
    {The original name of this field}
    property FieldOrgName: string read FFieldOrgName write SetFieldOrgName;
    {The name of this field}
    property FieldName: string read FFieldName;
    {A hash of the name of this field}
    property FieldNameHash: Longint read FFieldNameHash;
    {The type of this field}
    property aType: TIFPSType read FType write FType;
  end;
  {PIFPSRecordFieldTypeDef is an alias to @Link(TIFPSRecordFieldTypeDef)}
  PIFPSRecordFieldTypeDef = TIFPSRecordFieldTypeDef;
  {@abstract(TIFPSType is the base class for all types)}
  TIFPSType = class(TObject)
  private
    FNameHash: Longint;
    FName: string;
    FBaseType: TIFPSBaseType;
    FDeclarePos: Cardinal;
    FUsed: Boolean;
    FExportName: Boolean;
    FDeclareRow: Cardinal;
    FDeclareCol: Cardinal;
    FOriginalName: string;
    FAttributes: TIFPSAttributes;
    FFinalTypeNo: cardinal;
    procedure SetName(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    {Attributes for this class}
    property Attributes: TIFPSAttributes read FAttributes;

    property FinalTypeNo: cardinal read FFinalTypeNo;

    {The name of this type}
    property OriginalName: string read FOriginalName write FOriginalName;
    {The name of this type, in uppercase}
    property Name: string read FName write SetName;
    {a hash of the name for this type}
    property NameHash: Longint read FNameHash;
    {The base type for this type}
    property BaseType: TIFPSBaseType read FBaseType write FBaseType;
    {The position this type was declared, or 0, when declared outside the script engine}
    property DeclarePos: Cardinal read FDeclarePos write FDeclarePos;
    {The row part of the position for this type}
    property DeclareRow: Cardinal read FDeclareRow write FDeclareRow;
    {The col part of the position for this type}
    property DeclareCol: Cardinal read FDeclareCol write FDeclareCol;
    {This field is true when the type is used by the script engine, only used
    types will be written to bytecode}
    property Used: Boolean read FUsed;
    {Is this is true, the script engine will write the name of this type in the bytecode}
    property ExportName: Boolean read FExportName write FExportName;
    {Set the used field to true}
    procedure Use;
  end;

  {PIFPSType is a alias to a @link(TIFPSType)}
  PIFPSType = TIFPSType;

  {@abstract(TIFPSRecordType is used to store information about record types)}
  TIFPSRecordType = class(TIFPSType)
  private
    FRecordSubVals: TIfList;
  public
    constructor Create;
    destructor Destroy; override;
    {The number of field in this record}
    function RecValCount: Longint;
    {Returns the field of this record}
    function RecVal(I: Longint): PIFPSRecordFieldTypeDef;
    {Add a field}
    function AddRecVal: PIFPSRecordFieldTypeDef;
  end;
  {@abstract(TIFPSClassType is used to store class type information for the script engine)}
  TIFPSClassType = class(TIFPSType)
  private
    FCL: TIFPSCompiletimeClass;
  public
    property Cl: TIFPSCompileTimeClass read FCL write FCL;
  end;
{$IFNDEF IFPS3_NOINTERFACES}
  {@abstract(TIFPSClassType is used to store interface type information for the script engine)}
  TIFPSInterfaceType = class(TIFPSType)
  private
    FIntf: TIFPSInterface;
  public
    property Intf: TIFPSInterface read FIntf write FIntf;
  end;
{$ENDIF}

  {@abstract(A procedural pointer type)}
  TIFPSProceduralType = class(TIFPSType)
  private
    FProcDef: TIFPSParametersDecl;
  public
    {The definition all procs of this type should use}
    property ProcDef: TIFPSParametersDecl read FProcDef;
    constructor Create;
    destructor Destroy; override;
  end;
  {@abstract(Array type information)}
  TIFPSArrayType = class(TIFPSType)
  private
    FArrayTypeNo: TIFPSType;
  public
    {The type of this array}
    property ArrayTypeNo: TIFPSType read FArrayTypeNo write FArrayTypeNo;
  end;
  {@abstract(TIFPSStaticArrayType holds information to store static arrays)}
  TIFPSStaticArrayType = class(TIFPSArrayType)
  private
    FStartOffset: Longint;
    FLength: Cardinal;
  public
    {The start range of this array}
    property StartOffset: Longint read FStartOffset write FStartOffset;
    {The number of fields for this array}
    property Length: Cardinal read FLength write FLength;
  end;
  {@abstract(TIFPSSetType stores set type info)}
  TIFPSSetType = class(TIFPSType)
  private
    FSetType: TIFPSType;
    function GetByteSize: Longint;
    function GetBitSize: Longint;
  public
    {The type this set is about}
    property SetType: TIFPSType read FSetType write FSetType;
    {The number of bytes to store this set}
    property ByteSize: Longint read GetByteSize;
    {The number of bits to store this set}
    property BitSize: Longint read GetBitSize;
  end;
  {@abstract(a type link is an alias for another type)}
  TIFPSTypeLink = class(TIFPSType)
  private
    FLinkTypeNo: TIFPSType;
  public
    property LinkTypeNo: TIFPSType read FLinkTypeNo write FLinkTypeNo;
  end;
  {@abstract(an TIFPSEnumType holds information for enumerated types)}
  TIFPSEnumType = class(TIFPSType)
  private
    FHighValue: Cardinal;
  public
    {The highest possible value for this enum}
    property HighValue: Cardinal read FHighValue write FHighValue;
  end;

  {@abstract(TIFPSProcedure is the base type for all procedures)}
  TIFPSProcedure = class(TObject)
  private
    FAttributes: TIFPSAttributes;
  public
    property Attributes: TIFPSAttributes read FAttributes;

    constructor Create;
    destructor Destroy; override;
  end;

  TIFPSAttributeType = class;
  {@abstract(An attribute type field)s}
  TIFPSAttributeTypeField = class(TObject)
  private
    FOwner: TIFPSAttributeType;
    FFieldOrgName: string;
    FFieldName: string;
    FFieldNameHash: Longint;
    FFieldType: TIFPSType;
    FHidden: Boolean;
    procedure SetFieldOrgName(const Value: string);
  public
    constructor Create(AOwner: TIFPSAttributeType);
    {Owner of this attributetypefield}
    property Owner: TIFPSAttributeType read FOwner;
    {The original name for this type field}
    property FieldOrgName: string read FFieldOrgName write SetFieldOrgName;
    {The compiled name for this type field}
    property FieldName: string read FFieldName;
    {Hash for the Fieldname}
    property FieldNameHash: Longint read FFieldNameHash;
    {The type of this field}
    property FieldType: TIFPSType read FFieldType write FFieldType;
    {When true, this field is ignored and can be used by custom functions to store info}
    property Hidden: Boolean read FHidden write FHidden;
  end;
  {Event function}
  TIFPSApplyAttributeToType = function (Sender: TIFPSPascalCompiler; aType: TIFPSType; Attr: TIFPSAttribute): Boolean;
  {Event function}
  TIFPSApplyAttributeToProc = function (Sender: TIFPSPascalCompiler; aProc: TIFPSProcedure; Attr: TIFPSAttribute): Boolean;
  {@abstract(An attribute type)}
  TIFPSAttributeType = class(TIFPSType)
  private
    FFields: TIfList;
    FName: string;
    FOrgname: string;
    FNameHash: Longint;
    FAAProc: TIFPSApplyAttributeToProc;
    FAAType: TIFPSApplyAttributeToType;
    function GetField(I: Longint): TIFPSAttributeTypeField;
    function GetFieldCount: Longint;
    procedure SetName(const s: string);
  public
    {Event: Called when the attribute is applied to a type}
    property OnApplyAttributeToType: TIFPSApplyAttributeToType read FAAType write FAAType;
    {Event: Called when the attribute is applied to a procedure}
    property OnApplyAttributeToProc: TIFPSApplyAttributeToProc read FAAProc write FAAProc;
    {All fields for this attribute}
    property Fields[i: Longint]: TIFPSAttributeTypeField read GetField;
    {The number of fields}
    property FieldCount: Longint read GetFieldCount;
    {Delete a field}
    procedure DeleteField(I: Longint);
    {Add a new field}
    function AddField: TIFPSAttributeTypeField;
    {The name of this attribute (uppercase)}
    property Name: string read FName;
    {The original name of this attribute}
    property OrgName: string read FOrgName write SetName;
    {The hash for the name of this attribute}
    property NameHash: Longint read FNameHash;
    {Create a new instance of this class}
    constructor Create;
    {Destroy the instance of this class}
    destructor Destroy; override;
  end;
  {@abstract(An attribute)}
  TIFPSAttribute = class(TObject)
  private
    FAttribType: TIFPSAttributeType;
    FValues: TIfList; // of PIfVariant
    function GetValueCount: Longint;
    function GetValue(I: Longint): PIfRVariant;
  public
    {Create a new attribute}
    constructor Create(AttribType: TIFPSAttributeType);
    {Assign all the values of this attribute from another attribute}
    procedure Assign(Item: TIFPSAttribute);
    {The type for this attribute}
    property AType: TIFPSAttributeType read FAttribType;
    {The number of fields in this attribute}
    property Count: Longint read GetValueCount;
    {all fields for this attribute}
    property Values[i: Longint]: PIfRVariant read GetValue; default;
    {Delete a field from this attribute}
    procedure DeleteValue(i: Longint);
    {Add a new value to this attribute}
    function AddValue(v: PIFRVariant): Longint;
    {Destroy the current instance of this class}
    destructor Destroy; override;
  end;

  {@abstract(A collection of attributes)}
  TIFPSAttributes = class(TObject)
  private
    FItems: TIfList; // of PIfVariant
    function GetCount: Longint;
    function GetItem(I: Longint): TIFPSAttribute;
  public
    {Assign all values from attr to this attribute, use MOVE to move then}
    procedure Assign(attr: TIFPSAttributes; Move: Boolean);
    {The number of attributes}
    property Count: Longint read GetCount;
    {All attributes}
    property Items[i: Longint]: TIFPSAttribute read GetItem; default;
    {delete an attribute}
    procedure Delete(i: Longint);
    {Add an attribute}
    function Add(AttribType: TIFPSAttributeType): TIFPSAttribute;
    {find an attribute by attribtype name}
    function FindAttribute(const Name: string): TIFPSAttribute;
    {Create a new instance of this class}
    constructor Create;
    {Destroy the current instance of this class}
    destructor Destroy; override;
  end;

  {@abstract(TIFPSProcVar is used to store local variables)}
  TIFPSProcVar = class(TObject)
  private
    FNameHash: Longint;
    FName: string;
    FOrgName: string;
    FType: TIFPSType; // only for calculation types
    FUsed: Boolean;
    FDeclarePos, FDeclareRow, FDeclareCol: Cardinal;
    procedure SetName(const Value: string);
  public
    {The original name of this procvar}
    property OrgName: string read FOrgName write FOrgname;
    {The hash of the name of this local variable}
    property NameHash: Longint read FNameHash;
    {The name of this variable}
    property Name: string read FName write SetName;
    {The type}
    property AType: TIFPSType read FType write FType;
    {used is true when it's used}
    property Used: Boolean read FUsed;
    {The position this is declared}
    property DeclarePos: Cardinal read FDeclarePos write FDeclarePos;
    {The row part of the position}
    property DeclareRow: Cardinal read FDeclareRow write FDeclareRow;
    {The col part of the position}
    property DeclareCol: Cardinal read FDeclareCol write FDeclareCol;
    {set the used field to true}
    procedure Use;
  end;
  {PIFPSProcVar is an alias for  @link(TIFPSProcVar)}
  PIFPSProcVar = TIFPSProcVar;
   {@abstract(An external procedure)}
  TIFPSExternalProcedure = class(TIFPSProcedure)
  private
    FRegProc: TIFPSRegProc;
  public
    {the regproc for this external procedure. see @link(TIFPSRegProc)}
    property RegProc: TIFPSRegProc read FRegProc write FRegProc;
  end;

  {@abstract(TIFPSInternalProcedure stores information for scripted procedures)}
  TIFPSInternalProcedure = class(TIFPSProcedure)
  private
    FForwarded: Boolean;
    FData: string;
    FNameHash: Longint;
    FName: string;
    FDecl: TIFPSParametersDecl;
    FProcVars: TIfList;
    FUsed: Boolean;
    FOutputDeclPosition: Cardinal;
    FResultUsed: Boolean;
    FLabels: TIfStringList; // IFPS3_mi2s(position)+IFPS3_mi2s(namehash)+name   [position=$FFFFFFFF means position unknown]
    FGotos: TIfStringList;
    FDeclareRow: Cardinal;
    FDeclarePos: Cardinal;
    FDeclareCol: Cardinal;
    FOriginalName: string;
    procedure SetName(const Value: string);  // IFPS3_mi2s(position)+IFPS3_mi2s(destinationnamehash)+destinationname
  public
    constructor Create;
    destructor Destroy; override;
    {Attributes}

    {This field is true when the last declaration of this procedure was forwarded}
    property Forwarded: Boolean read FForwarded write FForwarded;
    {The compiled code for this procedure}
    property Data: string read FData write FData;
    {Parameter declaration}
    property Decl: TIFPSParametersDecl read FDecl;
    {The original name}
    property OriginalName: string read FOriginalName write FOriginalName;
    {The name for this procedure (in uppercase)}
    property Name: string read FName write SetName;
    {The hash for the name of this procedure}
    property NameHash: Longint read FNameHash;
    {A list with all local variables}
    property ProcVars: TIFList read FProcVars;
    {True when this procedure is called from somewhere}
    property Used: Boolean read FUsed;
    {The position this procedure is declared}
    property DeclarePos: Cardinal read FDeclarePos write FDeclarePos;
    {The row part of the position}
    property DeclareRow: Cardinal read FDeclareRow write FDeclareRow;
    {The col part of the position}
    property DeclareCol: Cardinal read FDeclareCol write FDeclareCol;
    {This field is used when writing the byte code. Do not set or change this}
    property OutputDeclPosition: Cardinal read FOutputDeclPosition write FOutputDeclPosition;
    {This field is true when the result of this function is assigned somewhere}
    property ResultUsed: Boolean read FResultUsed;

    {All labels within this procedure}
    property Labels: TIfStringList read FLabels;
    {All goto's within this procedure}
    property Gotos: TIfStringList read FGotos;
    {Use this procedure}
    procedure Use;
    {Use the result variable}
    procedure ResultUse;
  end;
  {@abstract(TIFPSVar is used to store global variables)}
  TIFPSVar = class(TObject)
  private
    FNameHash: Longint;
    FOrgName: string;
    FName: string;
    FType: TIFPSType;
    FUsed: Boolean;
    FExportName: string;
    FDeclareRow: Cardinal;
    FDeclarePos: Cardinal;
    FDeclareCol: Cardinal;
    FSaveAsPointer: Boolean;
    procedure SetName(const Value: string);
  public
    {Save as pointer}
    property SaveAsPointer: Boolean read FSaveAsPointer write FSaveAsPointer;
    {The name this field should be exported under}
    property ExportName: string read FExportName write FExportName;
    {This field is true when the variable is used}
    property Used: Boolean read FUsed;
    {The type of this variable}
    property aType: TIFPSType read FType write FType;
    {The original name of this variable}
    property OrgName: string read FOrgName write FOrgName;
    {The name of this variable}
    property Name: string read FName write SetName;
    {The hash of the name of this variable}
    property NameHash: Longint read FNameHash;
    {The position this variable was declared}
    property DeclarePos: Cardinal read FDeclarePos write FDeclarePos;
    {The row part of the position}
    property DeclareRow: Cardinal read FDeclareRow write FDeclareRow;
    {The col part of the position}
    property DeclareCol: Cardinal read FDeclareCol write FDeclareCol;
    {Set used to true}
    procedure Use;
  end;
  {TIFPSVar is an alias for a TIFPSVar}
  PIFPSVar = TIFPSVar;
  {@abstract(TIFPSContant contains information about constants)}
  TIFPSConstant = class(TObject)
    FOrgName: string;
    FNameHash: Longint;
    FName: string;
    FValue: PIfRVariant;
  private
    procedure SetName(const Value: string);
  public
    property OrgName: string read FOrgName write FOrgName;
    {The name (of the constant}
    property Name: string read FName write SetName;
    {The hash of the name of this constant}
    property NameHash: Longint read FNameHash;
    {The value for this constant}
    property Value: PIfRVariant read FValue write FValue;

    procedure SetSet(const val);

    {Change the value of this constant to the val integer}
    procedure SetInt(const Val: Longint);
    {Change the value of this constant to the val Cardinal}
    procedure SetUInt(const Val: Cardinal);
    {$IFNDEF IFPS3_NOINT64}
    {Change the value of this constant to the val int64}
    procedure SetInt64(const Val: Int64);
    {$ENDIF}
    {Change the value of this constant to the val string}
    procedure SetString(const Val: string);
    {Change the value of this constant to the val char}
    procedure SetChar(c: Char);
    {$IFNDEF IFPS3_NOINT64}
    {Change the value of this constant to the val WideChar}
    procedure SetWideChar(const val: WideChar);
    {Change the value of this constant to the val WideString}
    procedure SetWideString(const val: WideString);
    {$ENDIF}
    {Change the value of this constant to the val extended}
    procedure SetExtended(const Val: Extended);

    destructor Destroy; override;
  end;
  {PIFPSContant is an alias to a TIFPSConstant}
  PIFPSConstant = TIFPSConstant;
  {Is used to store the type of a compiler error}
  TIFPSPascalCompilerErrorType = (
    ecUnknownIdentifier,
    ecIdentifierExpected,
    ecCommentError,
    ecStringError,
    ecCharError,
    ecSyntaxError,
    ecUnexpectedEndOfFile,
    ecSemicolonExpected,
    ecBeginExpected,
    ecPeriodExpected,
    ecDuplicateIdentifier,
    ecColonExpected,
    ecUnknownType,
    ecCloseRoundExpected,
    ecTypeMismatch,
    ecInternalError,
    ecAssignmentExpected,
    ecThenExpected,
    ecDoExpected,
    ecNoResult,
    ecOpenRoundExpected,
    ecCommaExpected,
    ecToExpected,
    ecIsExpected,
    ecOfExpected,
    ecCloseBlockExpected,
    ecVariableExpected,
    ecStringExpected,
    ecEndExpected,
    ecUnSetLabel,
    ecNotInLoop,
    ecInvalidJump,
    ecOpenBlockExpected,
    ecWriteOnlyProperty,
    ecReadOnlyProperty,
    ecClassTypeExpected,
    ecCustomError,
    ecDivideByZero,
    ecMathError,
    ecUnsatisfiedForward,
    ecForwardParameterMismatch,
    ecInvalidnumberOfParameters

    );
  {Used to store the type of a hint}
  TIFPSPascalCompilerHintType = (
    ehVariableNotUsed, {param = variable name}
    ehFunctionNotUsed, {param = function name}
    ehCustomHint
    );
  {Is used to store the type of a warning}
  TIFPSPascalCompilerWarningType = (
    ewCalculationAlwaysEvaluatesTo,
    ewIsNotNeeded,
    ewAbstractClass,
    ewCustomWarning
  );
  {@abstract(TIFPSPascalCompilerMessage is the base class for compiler messages)}
  TIFPSPascalCompilerMessage = class(TObject)
  protected
    FRow: Cardinal;
    FCol: Cardinal;
    FModuleName: string;
    FParam: string;
    FPosition: Cardinal;
    function ErrorType: string; virtual; abstract;
    procedure SetParserPos(Parser: TIfPascalParser);
  public
    {The module name this message occured in, this is not set by the compiler but will be when you use the preprocessor}
    property ModuleName: string read FModuleName write FModuleName;
    {Parameter for this message}
    property Param: string read FParam write FParam;
    {The position (from 0) this message occured on}
    property Pos: Cardinal read FPosition write FPosition;
    {The Row this message occured on}
    property Row: Cardinal read FRow write FRow;
    {The column this message occured on}
    property Col: Cardinal read FCol write FCol;
    {Change the position}
    procedure SetCustomPos(Pos, Row, Col: Cardinal);
    {Convert a Message to a string (full details with Row and col)}
    function MessageToString: string; virtual;
    {Convert a message to a string}
    function ShortMessageToString: string; virtual; abstract;
  end;
  {@abstract(error message class)}
  TIFPSPascalCompilerError = class(TIFPSPascalCompilerMessage)
  protected
    FError: TIFPSPascalCompilerErrorType;
    function ErrorType: string; override;
  public
    {The error type}
    property Error: TIFPSPascalCompilerErrorType read FError;

    function ShortMessageToString: string; override;
  end;
  {@abstract(Hint message class)}
  TIFPSPascalCompilerHint = class(TIFPSPascalCompilerMessage)
  protected
    FHint: TIFPSPascalCompilerHintType;
    function ErrorType: string; override;
  public
    {The hint type}
    property Hint: TIFPSPascalCompilerHintType read FHint;

    function ShortMessageToString: string; override;
  end;
  {@abstract(Warning message class)}
  TIFPSPascalCompilerWarning = class(TIFPSPascalCompilerMessage)
  protected
    FWarning: TIFPSPascalCompilerWarningType;
    function ErrorType: string; override;
  public
    {The Warning type}
    property Warning: TIFPSPascalCompilerWarningType read FWarning;

    function ShortMessageToString: string; override;
  end;
  TIFPSDuplicCheck = set of (dcTypes, dcProcs, dcVars, dcConsts);
  {@abstract(BlockInfo is used to store the current scope the script engine is current in. There is no need to use or create this object)}
  TIFPSBlockInfo = class(TObject)
  private
    FOwner: TIFPSBlockInfo;
    FWithList: TIfList;
    FProcNo: Cardinal;
    FProc: TIFPSInternalProcedure;
    FSubType: TIFPSSubOptType;
  public
    {The current with list of @link(TIFPSValue) types}
    property WithList: TIfList read FWithList;
    {The current proc number}
    property ProcNo: Cardinal read FProcNo write FProcNo;
    {The current proc}
    property Proc: TIFPSInternalProcedure read FProc write FProc;
    {The scope type}
    property SubType: TIFPSSubOptType read FSubType write FSubType;
    {Clear the with list}
    procedure Clear;
    constructor Create(Owner: TIFPSBlockInfo);
    destructor Destroy; override;
  end;


  {The kind of binairy operand}
  TIFPSBinOperatorType = (otAdd, otSub, otMul, otDiv, otMod, otShl, otShr, otAnd, otOr, otXor, otAs,
                          otGreaterEqual, otLessEqual, otGreater, otLess, otEqual,
                          otNotEqual, otIs, otIn);
  {The kind of unair operand}
  TIFPSUnOperatorType = (otNot, otMinus, otCast);
  {See TIFPSPascalCompiler.OnUseVariable}
  TIFPSOnUseVariable = procedure (Sender: TIFPSPascalCompiler; VarType: TIFPSVariableType; VarNo: Longint; ProcNo, Position: Cardinal; const PropData: string);
  {See TIFPSPascalCompiler.OnUses}
  TIFPSOnUses = function(Sender: TIFPSPascalCompiler; const Name: string): Boolean;
  {See TIFPSPascalCompiler.OnExportCheck}
  TIFPSOnExportCheck = function(Sender: TIFPSPascalCompiler; Proc: TIFPSInternalProcedure; const ProcDecl: string): Boolean;
  {See TIFPSPascalCompiler.OnWriteLine}
  TIFPSOnWriteLineEvent = function (Sender: TIFPSPascalCompiler; Position: Cardinal): Boolean;
  {See TIFPSPascalCompiler.OnExternalProc}
  TIFPSOnExternalProc = function (Sender: TIFPSPascalCompiler; Decl: TIFPSParametersDecl; const Name, FExternal: string): TIFPSRegProc;
  {See TIFPSPascalCompiler.OnTranslateLineInfo}
  TIFPSOnTranslateLineInfoProc = procedure (Sender: TIFPSPascalCompiler; var Pos, Row, Col: Cardinal; var Name: string);
  TIFPSOnNotify = function (Sender: TIFPSPascalCompiler): Boolean;

  {@abstract(The actual compiler)}
  TIFPSPascalCompiler = class
  protected
    FID: Pointer;
    FOnExportCheck: TIFPSOnExportCheck;
    FDefaultBoolType: TIFPSType;
    FRegProcs: TIfList;
    FConstants: TIFList;
    FProcs: TIfList;
    FTypes: TIfList;
    FAttributeTypes: TIfList;
    FVars: TIfList;
    FOutput: string;
    FParser: TIfPascalParser;
    FMessages: TIfList;
    FOnUses: TIFPSOnUses;
    FIsUnit: Boolean;
    FAllowNoBegin: Boolean;
    FAllowNoEnd: Boolean;
    FAllowUnit: Boolean;
    FBooleanShortCircuit: Boolean;
    FDebugOutput: string;
    FOnExternalProc: TIFPSOnExternalProc;
    FOnUseVariable: TIFPSOnUseVariable;
    FOnBeforeOutput: TIFPSOnNotify;
    FOnBeforeCleanup: TIFPSOnNotify;
    FOnWriteLine: TIFPSOnWriteLineEvent;
    FContinueOffsets, FBreakOffsets: TIfList;
    FOnTranslateLineInfo: TIFPSOnTranslateLineInfoProc;
    FAutoFreeList: TIfList;
    FClasses: TIFList;
{$IFNDEF IFPS3_NOINTERFACES}
    FInterfaces: TIfList;
{$ENDIF}

    FCurrUsedTypeNo: Cardinal;
    FGlobalBlock: TIFPSBlockInfo;
    function IsBoolean(aType: TIFPSType): Boolean;
    {$IFNDEF IFPS3_NOWIDESTRING}
    function GetWideString(Src: PIfRVariant; var s: Boolean): WideString;
    {$ENDIF}
    function PreCalc(FUseUsedTypes: Boolean; Var1Mod: Byte; var1: PIFRVariant; Var2Mod: Byte;
      Var2: PIfRVariant; Cmd: TIFPSBinOperatorType; Pos, Row, Col: Cardinal): Boolean;

    function FindBaseType(BaseType: TIFPSBaseType): TIFPSType;
    function IsIntBoolType(aType: TIFPSType): Boolean;
    function GetTypeCopyLink(p: TIFPSType): TIFPSType;
    function at2ut(p: TIFPSType): TIFPSType;
    procedure UseProc(procdecl: TIFPSParametersDecl);

    function GetMsgCount: Longint;
    function GetMsg(l: Longint): TIFPSPascalCompilerMessage;

    function MakeDecl(decl: TIFPSParametersDecl): string;
    function MakeExportDecl(decl: TIFPSParametersDecl): string;

    procedure DefineStandardTypes;
    procedure DefineStandardProcedures;

    function ReadReal(const s: string): PIfRVariant;
    function ReadString: PIfRVariant;
    function ReadInteger(const s: string): PIfRVariant;
    function ReadAttributes(Dest: TIFPSAttributes): Boolean;
    function ReadConstant(FParser: TIfPascalParser; StopOn: TIfPasToken): PIfRVariant;
    function ApplyAttribsToFunction(func: TIFPSProcedure): boolean;
    function ProcessFunction(AlwaysForward: Boolean; Att: TIFPSAttributes): Boolean;
    function ValidateParameters(BlockInfo: TIFPSBlockInfo; Params: TIFPSParameters; ParamTypes: TIFPSParametersDecl): boolean;
    function IsVarInCompatible(ft1, ft2: TIFPSType): Boolean;
    function GetTypeNo(BlockInfo: TIFPSBlockInfo; p: TIFPSValue): TIFPSType;
    function DoVarBlock(proc: TIFPSInternalProcedure): Boolean;
    function DoTypeBlock(FParser: TIfPascalParser): Boolean;
    function ReadType(const Name: string; FParser: TIfPascalParser): TIFPSType;
    function ProcessLabel(Proc: TIFPSInternalProcedure): Boolean;
    function ProcessSub(BlockInfo: TIFPSBlockInfo): Boolean;
    function ProcessLabelForwards(Proc: TIFPSInternalProcedure): Boolean;

    procedure WriteDebugData(const s: string);
    procedure Debug_SavePosition(ProcNo: Cardinal; Proc: TIFPSInternalProcedure);
    procedure Debug_WriteParams(ProcNo: Cardinal; Proc: TIFPSInternalProcedure);
    procedure Debug_WriteLine(BlockInfo: TIFPSBlockInfo);

    function IsCompatibleType(p1, p2: TIFPSType; Cast: Boolean): Boolean;
    function IsDuplicate(const s: string; const check: TIFPSDuplicCheck): Boolean;
    function NewProc(const OriginalName, Name: string): TIFPSInternalProcedure;
    function AddUsedFunction(var Proc: TIFPSInternalProcedure): Cardinal;
    function AddUsedFunction2(var Proc: TIFPSExternalProcedure): Cardinal;

    function CheckCompatProc(P: TIFPSType; ProcNo: Cardinal): Boolean;

    procedure ParserError(Parser: TObject; Kind: TIFParserErrorKind);

    function ReadTypeAddProcedure(const Name: string; FParser: TIfPascalParser): TIFPSType;

    function VarIsDuplicate(Proc: TIFPSInternalProcedure; const VarNames, s: string): Boolean;
    function IsProcDuplicLabel(Proc: TIFPSInternalProcedure; const s: string): Boolean;
    procedure CheckForUnusedVars(Func: TIFPSInternalProcedure);
    function ProcIsDuplic(Decl: TIFPSParametersDecl; const FunctionName, FunctionParamNames: string; const s: string; Func: TIFPSInternalProcedure): Boolean;
   public
    function FindProc(const Name: string): Cardinal;
    {returns the type count}
    function GetTypeCount: Longint;
    {returns type nr I}
    function GetType(I: Longint): TIFPSType;
    {Returns the variable count}
    function GetVarCount: Longint;
    {Returns variable number I}
    function GetVar(I: Longint): TIFPSVar;
    {returns the procedure count}
    function GetProcCount: Longint;
    {Returns procedure nr I}
    function GetProc(I: Longint): TIFPSProcedure;
    {Add an attribute type to the attribute type list}
    function AddAttributeType: TIFPSAttributeType;
    {Add an object to the auto-free list}
    procedure AddToFreeList(Obj: TObject);
    {Tag for this object, use as you like}
    property ID: Pointer read FID write FID;
    {Add an error the messages}
    function MakeError(const Module: string; E: TIFPSPascalCompilerErrorType; const
      Param: string): TIFPSPascalCompilerMessage;
    {Add a warning to the messages}
    function MakeWarning(const Module: string; E: TIFPSPascalCompilerWarningType;
      const Param: string): TIFPSPascalCompilerMessage;
    {Add a hint to the messages}
    function MakeHint(const Module: string; E: TIFPSPascalCompilerHintType;
      const Param: string): TIFPSPascalCompilerMessage;

{$IFNDEF IFPS3_NOINTERFACES}
    {Add an interface}
    function AddInterface(InheritedFrom: TIFPSInterface; Guid: TGuid; const Name: string): TIFPSInterface;
    {Find a class}
    function FindInterface(const Name: string): TIFPSInterface;
    {Add a class}
{$ENDIF}
    function AddClass(InheritsFrom: TIFPSCompileTimeClass; aClass: TClass): TIFPSCompileTimeClass;
    {Add a class without using the actual class}
    function AddClassN(InheritsFrom: TIFPSCompileTimeClass; const aClass: string): TIFPSCompileTimeClass;
    {Find a class}
    function FindClass(const aClass: string): TIFPSCompileTimeClass;
    {Add a function, deprecated, use AddDelphiFunction}
    function AddFunction(const Header: string): TIFPSRegProc;
    {Add a function and make it possible to directly call this function}
    function AddDelphiFunction(const Decl: string): TIFPSRegProc;
    {add a type, use AddTypeS for non-basetype based types}
    function AddType(const Name: string; const BaseType: TIFPSBaseType): TIFPSType;
    {Add a type declared in a string}
    function AddTypeS(const Name, Decl: string): TIFPSType;
    {Add a type copy type}
    function AddTypeCopy(const Name: string; TypeNo: TIFPSType): TIFPSType;
    {Add a type copy type}
    function AddTypeCopyN(const Name, FType: string): TIFPSType;
    {Add a constant}
    function AddConstant(const Name: string; FType: TIFPSType): TIFPSConstant;
    {Add a constant}
    function AddConstantN(const Name, FType: string): TIFPSConstant;
    {Add a variable, and export it}
    function AddVariable(const Name: string; FType: TIFPSType): TIFPSVar;
    {Add a variable, and export it}
    function AddVariableN(const Name, FType: string): TIFPSVar;
    {Add an used variable, and export it}
    function AddUsedVariable(const Name: string; FType: TIFPSType): TIFPSVar;
    {add an used variable , and export it}
    function AddUsedVariableN(const Name, FType: string): TIFPSVar;
    {Add an used pointer variable, and export it}
    function AddUsedPtrVariable(const Name: string; FType: TIFPSType): TIFPSVar;
    {add an used pointer variable , and export it}
    function AddUsedPtrVariableN(const Name, FType: string): TIFPSVar;
    {Search for a type}
    function FindType(const Name: string): TIFPSType;
    {Compile a script (s)}
    function Compile(const s: string): Boolean;
    {Return the output}
    function GetOutput(var s: string): Boolean;
	{Return the debugger output}
    function GetDebugOutput(var s: string): Boolean;
    {Clear the current data}
    procedure Clear;
    {Create}
    constructor Create;
	{Destroy the current instance of the script compiler}
    destructor Destroy; override;
    {contains the number of messages}
    property MsgCount: Longint read GetMsgCount;
	{The messages/warnings/errors}
    property Msg[l: Longint]: TIFPSPascalCompilerMessage read GetMsg;
    property OnTranslateLineInfo: TIFPSOnTranslateLineInfoProc read FOnTranslateLineInfo write FOnTranslateLineInfo;
    {OnUses i scalled for each Uses and always first with 'SYSTEM' parameters}
    property OnUses: TIFPSOnUses read FOnUses write FOnUses;
	{OnExportCheck is called for each function to check if it needs to be exported and has the correct parameters}
    property OnExportCheck: TIFPSOnExportCheck read FOnExportCheck write FOnExportCheck;
	{OnWriteLine is called after each line}
    property OnWriteLine: TIFPSOnWriteLineEvent read FOnWriteLine write FOnWriteLine;
	{OnExternalProc is called when an external token is found after a procedure header}
    property OnExternalProc: TIFPSOnExternalProc read FOnExternalProc write FOnExternalProc;
	{The OnUseVariant event is called when a variable is used by the script engine}
    property OnUseVariable: TIFPSOnUseVariable read FOnUseVariable write FOnUseVariable;
    {This event is called before the compiled trees are written}
    property OnBeforeOutput: TIFPSOnNotify read FOnBeforeOutput write FOnBeforeOutput;
    {This event is called before the compiled trees are cleaned up}
    property OnBeforeCleanup: TIFPSOnNotify read FOnBeforeCleanup write FOnBeforeCleanup;
	{contains true if the current file is a unit}
    property IsUnit: Boolean read FIsUnit;
	{Allow no main begin/end}
    property AllowNoBegin: Boolean read FAllowNoBegin write FAllowNoBegin;
	{Allow a unit instead of program}
    property AllowUnit: Boolean read FAllowUnit write FAllowUnit;
	{Allow it to have no END on the script (only works when AllowNoBegin is true)}
    property AllowNoEnd: Boolean read FAllowNoEnd write FAllowNoEnd;

    property BooleanShortCircuit: Boolean read FBooleanShortCircuit write FBooleanShortCircuit;
  end;
  {@abstract(Base class for all values)}
  TIFPSValue = class(TObject)
  private
    FPos, FRow, FCol: Cardinal;
  public
    {position this value was declared}
    property Pos: Cardinal read FPos write FPos;
    {Row part of the position}
    property Row: Cardinal read FRow write FRow;
    {Col part of the position}
    property Col: Cardinal read FCol write FCol;
    {Read position info from the parser}
    procedure SetParserPos(P: TIfPascalParser);
  end;
  {@abstract(TIFPSParameter is used to store parameter info)}
  TIFPSParameter = class(TObject)
  private
    FValue: TIFPSValue;
    FTempVar: TIFPSValue;
    FParamMode: TIFPSParameterMode;
    FExpectedType: TIFPSType;
  public
    {The actual value of this parameter}
    property Val: TIFPSValue read FValue write FValue;
    {The expected type}
    property ExpectedType: TIFPSType read FExpectedType write FExpectedType;
    {The temporary field used when writing the byte code}
    property TempVar: TIFPSValue read FTempVar write FTempVar;
    {Parameter mode}
    property ParamMode: TIFPSParameterMode read FParamMode write FParamMode;
    destructor Destroy; override;
  end;
  {@abstract(TIFPSParameters is a list of @link(TIFPSParameter))}
  TIFPSParameters = class(TObject)
  private
    FItems: TIfList;
    function GetCount: Cardinal;
    function GetItem(I: Longint): TIFPSParameter;
  public
    constructor Create;
    destructor Destroy; override;
    {Number of elements}
    property Count: Cardinal read GetCount;
    {Item no [i]}
    property Item[I: Longint]: TIFPSParameter read GetItem; default;
    {Delete item number I}
    procedure Delete(I: Cardinal);
    {Add a new parameter}
    function Add: TIFPSParameter;
  end;
  {@abstract(TIFPSSubItem is a base case used when storing record or array field number information)}
  TIFPSSubItem = class(TObject)
  private
    FType: TIFPSType;
  public
    {The type this variable will be after this subfield}
    property aType: TIFPSType read FType write FType;
  end;
  {@abstract(Field no constant number)}
  TIFPSSubNumber = class(TIFPSSubItem)
  private
    FSubNo: Cardinal;
  public
    {The field number}
    property SubNo: Cardinal read FSubNo write FSubNo;
  end;
  {@abstract(Field no by value)}
  TIFPSSubValue = class(TIFPSSubItem)
  private
    FSubNo: TIFPSValue;
  public
    {The field number}
    property SubNo: TIFPSValue read FSubNo write FSubNo;
    destructor Destroy; override;
  end;
  {@abstract(The base class for all variables)}
  TIFPSValueVar = class(TIFPSValue)
  private
    FRecItems: TIfList;
    function GetRecCount: Cardinal;
    function GetRecItem(I: Cardinal): TIFPSSubItem;
  public
    constructor Create;
    destructor Destroy; override;
    {Record/Array sub fields: Add a new one}
    function RecAdd(Val: TIFPSSubItem): Cardinal;
    {Record/Array sub fields: Delete }
    procedure RecDelete(I: Cardinal);
    {Record/Array sub fields: Returns the item at I}
    property RecItem[I: Cardinal]: TIFPSSubItem read GetRecItem;
    {Record/Array sub fields: Returns the count}
    property RecCount: Cardinal read GetRecCount;
  end;
  {@abstract(A global variable)}
  TIFPSValueGlobalVar = class(TIFPSValueVar)
  private
    FAddress: Cardinal;
  public
    {The global variable no}
    property GlobalVarNo: Cardinal read FAddress write FAddress;
  end;

  {@abstract(A local variable)}
  TIFPSValueLocalVar = class(TIFPSValueVar)
  private
    FLocalVarNo: Longint;
  public
    {The local variable no}
    property LocalVarNo: Longint read FLocalVarNo write FLocalVarNo;
  end;
  {@abstract(A parameter variable)}
  TIFPSValueParamVar = class(TIFPSValueVar)
  private
    FParamNo: Longint;
  public
    {The parameter within the current procedure}
    property ParamNo: Longint read FParamNo write FParamNo;
  end;
  {@abstract(A temporary value used by the script engine)}
  TIFPSValueAllocatedStackVar = class(TIFPSValueLocalVar)
  private
    FProc: TIFPSInternalProcedure;
  public
    {The current procedure, used for freeing}
    property Proc: TIFPSInternalProcedure read FProc write FProc;
    destructor Destroy; override;
  end;
  {@abstract(A Data value)}
  TIFPSValueData = class(TIFPSValue)
  private
    FData: PIfRVariant;
  public
    {The actual data}
    property Data: PIfRVariant read FData write FData;
    destructor Destroy; override;
  end;
  {@abstract(TIFPSValueReplace is used internally by the script engine when
  it needs to replace a value with something else, usually when writing
  the byte code)}
  TIFPSValueReplace = class(TIFPSValue)
  private
    FPreWriteAllocated: Boolean;
    FFreeOldValue: Boolean;
    FFreeNewValue: Boolean;
    FOldValue: TIFPSValue;
    FNewValue: TIFPSValue;
    FReplaceTimes: Longint;
  public
    {The old value}
    property OldValue: TIFPSValue read FOldValue write FOldValue;
    {The new value}
    property NewValue: TIFPSValue read FNewValue write FNewValue;
    {Should it free the old value when destroyed?}
    property FreeOldValue: Boolean read FFreeOldValue write FFreeOldValue; {default false}
    {Should it free the new value when destroyed?}
    property FreeNewValue: Boolean read FFreeNewValue write FFreeNewValue; {default true}
    {This is true when this value is allocated in the PreWriteOutput function}
    property PreWriteAllocated: Boolean read FPreWriteAllocated write FPreWriteAllocated;
    {The number of times this variable should have been replaced}
    property ReplaceTimes: Longint read FReplaceTimes write FReplaceTimes;

    constructor Create;
    destructor Destroy; override;
  end;

  {@abstract(TIFPSUnValueOp stores information about unairy calculations)}
  TIFPSUnValueOp = class(TIFPSValue)
  private
    FVal1: TIFPSValue;
    FOperator: TIFPSUnOperatorType;
    FType: TIFPSType;
  public
    {The value on which the operation should be executed}
    property Val1: TIFPSValue read FVal1 write FVal1;
    {The operator}
    property Operator: TIFPSUnOperatorType read FOperator write FOperator;
    {The final type}
    property aType: TIFPSType read FType write FType;
    destructor Destroy; override;
  end;
  {@abstract(TIFPSBinValueOp stores information about binairy calculations)}
  TIFPSBinValueOp = class(TIFPSValue)
  private
    FVal1,
    FVal2: TIFPSValue;
    FOperator: TIFPSBinOperatorType;
    FType: TIFPSType;
  public
    {The first value}
    property Val1: TIFPSValue read FVal1 write FVal1;
    {The second value}
    property Val2: TIFPSValue read FVal2 write FVal2;
    {The operator for this value}
    property Operator: TIFPSBinOperatorType read FOperator write FOperator;
    {The resulting type}
    property aType: TIFPSType read FType write FType;
    destructor Destroy; override;
  end;
  {@abstract(TIFPSValueNil is used to hold NIL values, that have no actual value until it's assigned
  to another type)}
  TIFPSValueNil = class(TIFPSValue)
  end;
  {@abstract(A procedural pointer)}
  TIFPSValueProcPtr = class(TIFPSValue)
  private
    FProcNo: Cardinal;
  public
    {The proc number it points to}
    property ProcPtr: Cardinal read FProcNo write FProcNo;
  end;
  {@abstract(The base class for all procedure calls)}
  TIFPSValueProc = class(TIFPSValue)
  private
    FSelfPtr: TIFPSValue;
    FParameters: TIFPSParameters;
    FResultType: TIFPSType;
  public
    property ResultType: TIFPSType read FResultType write FResultType;
    {The self pointer value or nil}
    property SelfPtr: TIFPSValue read FSelfPtr write FSelfPtr;
    {The parameters}
    property Parameters: TIFPSParameters read FParameters write FParameters;
    destructor Destroy; override;
  end;
  {@abstract(A procedure by number call)}
  TIFPSValueProcNo = class(TIFPSValueProc)
  private
    FProcNo: Cardinal;
  public
   { The procedure number}
    property ProcNo: Cardinal read FProcNo write FProcNo;
  end;
  {@abstract(A procedure by value call)}
  TIFPSValueProcVal = class(TIFPSValueProc)
  private
    FProcNo: TIFPSValue;
  public
    {The procedure number}
    property ProcNo: TIFPSValue read FProcNo write FProcNo;
  end;
  {@abstract(An array constant) (A := [1,23,4])}
  TIFPSValueArray = class(TIFPSValue)
  private
    FItems: TIfList;
    function GetCount: Cardinal;
    function GetItem(I: Cardinal): TIFPSValue;
  public
    function Add(Item: TIFPSValue): Cardinal;
    procedure Delete(I: Cardinal);
    property Item[I: Cardinal]: TIFPSValue read GetItem;
    property Count: Cardinal read GetCount;

    constructor Create;
    destructor Destroy; override;
  end;

  TIFPSDelphiClassItem = class;
  {Property type: iptRW = Read/Write; iptR= readonly; iptW= writeonly}
  TIFPSPropType = (iptRW, iptR, iptW);
  {@abstract(Compiletime class)}
  TIFPSCompileTimeClass = class
  private
    FInheritsFrom: TIFPSCompileTimeClass;
    FClass: TClass;
    FClassName: string;
    FClassNameHash: Longint;
    FClassItems: TIFList;
    FDefaultProperty: Cardinal;
    FIsAbstract: Boolean;
    FCastProc,
    FNilProc: Cardinal;
    FType: TIFPSType;

    FOwner: TIFPSPascalCompiler;
    function GetCount: Longint;
    function GetItem(i: Longint): TIFPSDelphiClassItem;
  public
    property aType: TIFPSType read FType;
    property Items[i: Longint]: TIFPSDelphiClassItem read GetItem;
    property Count: Longint read GetCount;
    property IsAbstract: Boolean read FIsAbstract write FIsAbstract;

    property ClassInheritsFrom: TIFPSCompileTimeClass read FInheritsFrom write FInheritsFrom;
    {Register a method/constructor}
    function RegisterMethod(const Decl: string): Boolean;
	{Register a property}
    procedure RegisterProperty(const PropertyName, PropertyType: string; PropAC: TIFPSPropType);
    {Register all published properties}
    procedure RegisterPublishedProperties;
    {Register a published property}
    function RegisterPublishedProperty(const Name: string): Boolean;
    {Set the default (array) property, this function will raise an exception if
    the property doesn't exists or if it's not an array property}
    procedure SetDefaultPropery(const Name: string);
    {create an instance of this class without using the actual class}
    constructor Create(ClassName: string; aOwner: TIFPSPascalCompiler; aType: TIFPSType);
    {create an instance of this class and use the actual class information}
    class function CreateC(FClass: TClass; aOwner: TIFPSPascalCompiler; aType: TIFPSType): TIFPSCompileTimeClass;

    destructor Destroy; override;

    function IsCompatibleWith(aType: TIFPSType): Boolean;
    function SetNil(var ProcNo: Cardinal): Boolean;
    function CastToType(IntoType: TIFPSType; var ProcNo: Cardinal): Boolean;

    function Property_Find(const Name: string; var Index: Cardinal): Boolean;
    function Property_Get(Index: Cardinal; var ProcNo: Cardinal): Boolean;
    function Property_Set(Index: Cardinal; var ProcNo: Cardinal): Boolean;
    function Property_GetHeader(Index: Cardinal; Dest: TIFPSParametersDecl): Boolean;

    function Func_Find(const Name: string; var Index: Cardinal): Boolean;
    function Func_Call(Index: Cardinal; var ProcNo: Cardinal): Boolean;

    function ClassFunc_Find(const Name: string; var Index: Cardinal): Boolean;
    function ClassFunc_Call(Index: Cardinal; var ProcNo: Cardinal): Boolean;
  end;
  {@abstract(an item of a delphi class), this class is used to store properties and methods for a class and can be used to read type info from the compiler}
  TIFPSDelphiClassItem = class(TObject)
  private
    FOwner: TIFPSCompileTimeClass;
    FOrgName: string;
    FName: string;
    FNameHash: Longint;
    FDecl: TIFPSParametersDecl;
    procedure SetName(const s: string);
  public
    constructor Create(Owner: TIFPSCompileTimeClass);
    destructor Destroy; override;
    {Declaration of this class item}
    property Decl: TIFPSParametersDecl read FDecl;
    {Name of this class item}
    property Name: string read FName;
    {Original name of this class item}
    property OrgName: string read FOrgName write SetName;
    {The hash for the name of this class item}
    property NameHash: Longint read FNameHash;
    {The owner}
    property Owner: TIFPSCompileTimeClass read FOwner;
  end;
  {@abstract(delphi class method type info)}
  TIFPSDelphiClassItemMethod = class(TIFPSDelphiClassItem)
  private
    FMethodNo: Cardinal;
  public
    {The method number in the script this method points to}
    property MethodNo: Cardinal read FMethodNo write FMethodNo;
  end;
  {@abstract(delphi class property type info)}
  TIFPSDelphiClassItemProperty = class(TIFPSDelphiClassItem)
  private
    FReadProcNo: Cardinal;
    FWriteProcNo: Cardinal;
    FAccessType: TIFPSPropType;
  public
    {The access type for this property}
    property AccessType: TIFPSPropType read FAccessType write FAccessType;
    {the procedure used to read this property}
    property ReadProcNo: Cardinal read FReadProcNo write FReadProcNo;
    {The proccedure used to write this property}
    property WriteProcNo: Cardinal read FWriteProcNo write FWriteProcNo;
  end;

  {@abstract(delphi class constructor type info)}
  TIFPSDelphiClassItemConstructor = class(TIFPSDelphiClassItemMethod)
  end;

{$IFNDEF IFPS3_NOINTERFACES}
  {@abstract(Interface type info)}
  TIFPSInterface = class(TObject)
  private
    FOwner: TIFPSPascalCompiler;
    FType: TIFPSType;
    FInheritedFrom: TIFPSInterface;
    FGuid: TGuid;
    FCastProc,
    FNilProc: Cardinal;
    FProcStart: Cardinal;
    FItems: TIfList;
    FName: string;
    FNameHash: Longint;
  public
    constructor Create(Owner: TIFPSPascalCompiler; InheritedFrom: TIFPSInterface; Guid: TGuid; const Name: string; aType: TIFPSType);
    destructor Destroy; override;
    {This interface inherits from ...}
    property InheritedFrom: TIFPSInterface read FInheritedFrom;
    {The GUID for this interface}
    property Guid: TGuid read FGuid;
    {The name of this interface}
    property Name: string read FName;
    {Hash of the name of this interface}
    property NameHash: Longint read FNameHash;

    {Register a method}
    function RegisterMethod(const Declaration: string; const cc: TIFPSCallingConvention): Boolean;
    {Register a method that cannot be called, but will hold an empty space
     This can be used for methods that cannot be registered (for example for functions that use pointer parameters).}
    procedure RegisterDummyMethod;
    {Check if this interface is compatible with atype}
    function IsCompatibleWith(aType: TIFPSType): Boolean;
    {returns the procno for nilling an interface}
    function SetNil(var ProcNo: Cardinal): Boolean;
    {Cast an interface to a different type}
    function CastToType(IntoType: TIFPSType; var ProcNo: Cardinal): Boolean;
    {Find a function}
    function Func_Find(const Name: string; var Index: Cardinal): Boolean;
    {Call a function}
    function Func_Call(Index: Cardinal; var ProcNo: Cardinal): Boolean;
  end;

  {@abstract(Interface Method type info)}
  TIFPSInterfaceMethod = class(TObject)
  private
    FName: string;
    FDecl: TIFPSParametersDecl;
    FNameHash: Longint;
    FCC: TIFPSCallingConvention;
    FAbsoluteProcOffset: Cardinal;
    FScriptProcNo: Cardinal;
    FOrgName: string;
  public
    {The offset this method is on, all interface methods are numbered from 0, so the script engine knows which one to call}
    property AbsoluteProcOffset: Cardinal read FAbsoluteProcOffset;
    {The script proc number for this method}
    property ScriptProcNo: Cardinal read FScriptProcNo;
    {The original name for this method}
    property OrgName: string read FOrgName;
    {The name for this method (uppercased)}
    property Name: string read FName;
    {The hash of the name for this method}
    property NameHash: Longint read FNameHash;
    {Declaration off this method}
    property Decl: TIFPSParametersDecl read FDecl;
    {Calling convention}
    property CC: TIFPSCallingConvention read FCC;

    constructor Create;
    destructor Destroy; override;
  end;
{$ENDIF}
{Check the proc definition. Types[0] is the result type (or 0). Modes specify the
parameter passing mode (in, var). High(Types) should always be 1 more than High(Modes). }
function ExportCheck(Sender: TIFPSPascalCompiler; Proc: TIFPSInternalProcedure;
  Types: array of TIFPSBaseType; Modes: array of TIFPSParameterMode): Boolean;

{Set the export name of a global variable}
procedure SetVarExportName(P: TIFPSVar; const ExpName: string);
{Add an imported class variable, this should be assigned at runtime before executing}
function AddImportedClassVariable(Sender: TIFPSPascalCompiler; const VarName, VarType: string): Boolean;

const
  {Invalid value, this is returned by most functions of IFPS3 that return a cardinal, when they fail}
  InvalidVal = Cardinal(-1);

type
  {The parsed function type}
  TPMFuncType = (mftProc, mftConstructor);

{This function returns}
function IFPS3_mi2s(i: Cardinal): string;
{Parse a method header}
function ParseMethod(Owner: TIFPSPascalCompiler; const FClassName: string; Decl: string; var OrgName: string; DestDecl: TIFPSParametersDecl; var Func: TPMFuncType): Boolean;


implementation

uses Classes, typInfo;


procedure BlockWriteByte(BlockInfo: TIFPSBlockInfo; b: Byte);
begin
  BlockInfo.Proc.Data := BlockInfo.Proc.Data + Char(b);
end;

procedure BlockWriteData(BlockInfo: TIFPSBlockInfo; const Data; Len: Longint);
begin
  SetLength(BlockInfo.Proc.FData, Length(BlockInfo.Proc.FData) + Len);
  Move(Data, BlockInfo.Proc.FData[Length(BlockInfo.Proc.FData) - Len + 1], Len);
end;

procedure BlockWriteLong(BlockInfo: TIFPSBlockInfo; l: Cardinal);
begin
  BlockWriteData(BlockInfo, l, 4);
end;

procedure BlockWriteVariant(BlockInfo: TIFPSBlockInfo; p: PIfRVariant);
begin
  BlockWriteLong(BlockInfo, p^.FType.FinalTypeNo);
  case p.FType.BaseType of
  btType: BlockWriteData(BlockInfo, p^.ttype.FinalTypeno, 4);
  {$IFNDEF IFPS3_NOWIDESTRING}
  btWideString:
    begin
      BlockWriteLong(BlockInfo, Length(tbtWideString(p^.twidestring)));
      BlockWriteData(BlockInfo, tbtwidestring(p^.twidestring)[1], 2*Length(tbtWideString(p^.twidestring)));
    end;
  btWideChar: BlockWriteData(BlockInfo, p^.twidechar, 2);
  {$ENDIF}
  btSingle: BlockWriteData(BlockInfo, p^.tsingle, sizeof(tbtSingle));
  btDouble: BlockWriteData(BlockInfo, p^.tdouble, sizeof(tbtDouble));
  btExtended: BlockWriteData(BlockInfo, p^.textended, sizeof(tbtExtended));
  btCurrency: BlockWriteData(BlockInfo, p^.tcurrency, sizeof(tbtCurrency));
  btChar: BlockWriteData(BlockInfo, p^.tchar, 1);
  btSet:
    begin
      BlockWriteData(BlockInfo, tbtString(p^.tstring)[1], Length(tbtString(p^.tstring)));
    end;
  btString:
    begin
      BlockWriteLong(BlockInfo, Length(tbtString(p^.tstring)));
      BlockWriteData(BlockInfo, tbtString(p^.tstring)[1], Length(tbtString(p^.tstring)));
    end;
  btenum:
    begin
      if TIFPSEnumType(p^.FType).HighValue <=256 then
        BlockWriteData(BlockInfo, p^.tu32, 1)
      else if TIFPSEnumType(p^.FType).HighValue <=65536 then
        BlockWriteData(BlockInfo, p^.tu32, 2)
      else
        BlockWriteData(BlockInfo, p^.tu32, 4);
    end;
  bts8,btu8: BlockWriteData(BlockInfo, p^.tu8, 1);
  bts16,btu16: BlockWriteData(BlockInfo, p^.tu16, 2);
  bts32,btu32: BlockWriteData(BlockInfo, p^.tu32, 4);
  {$IFNDEF IFPS3_NOINT64}
  bts64: BlockWriteData(BlockInfo, p^.ts64, 8);
  {$ENDIF}
  btProcPtr: BlockWriteData(BlockInfo, p^.tu32, 4);
  {$IFDEF IFPS3_DEBUG}
  else
      asm int 3; end;
  {$ENDIF}
  end;
end;



function ExportCheck(Sender: TIFPSPascalCompiler; Proc: TIFPSInternalProcedure; Types: array of TIFPSBaseType; Modes: array of TIFPSParameterMode): Boolean;
var
  i: Longint;
  ttype: TIFPSType;
begin
  if High(Types) <> High(Modes)+1 then
  begin
    Result := False;
    exit;
  end;
  if High(Types) <> Proc.Decl.ParamCount then
  begin
    Result := False;
    exit;
  end;
  TType := Proc.Decl.Result;
  if TType = nil then
  begin
    if Types[0] <> btReturnAddress then
    begin
      Result := False;
      exit;
    end;
  end else
  begin
    if TType.BaseType <> Types[0] then
    begin
      Result := False;
      exit;
    end;
  end;
  for i := 0 to High(Modes) do
  begin
    TType := Proc.Decl.Params[i].aType;
    if Modes[i] <> Proc.Decl.Params[i].Mode then
    begin
      Result := False;
      exit;
    end;
    if TType.BaseType <> Types[i+1] then
    begin
      Result := False;
      exit;
    end;
  end;
  Result := True;
end;

procedure SetVarExportName(P: TIFPSVar; const ExpName: string);
begin
  if p <> nil then
    p.exportname := ExpName;
end;

function FindAndAddType(Owner: TIFPSPascalCompiler; const Name, Decl: string): TIFPSType;
var
  tt: TIFPSType;
begin
  Result := Owner.FindType(Name);
  if Result = nil then
  begin
    tt := Owner.AddTypeS(Name, Decl);
    tt.ExportName := True;
    Result := tt;
  end;
end;


function ParseMethod(Owner: TIFPSPascalCompiler; const FClassName: string; Decl: string; var OrgName: string; DestDecl: TIFPSParametersDecl; var Func: TPMFuncType): Boolean;
var
  Parser: TIfPascalParser;
  FuncType: Byte;
  VNames: string;
  modifier: TIFPSParameterMode;
  VCType: TIFPSType;

begin
  Parser := TIfPascalParser.Create;
  Parser.SetText(Decl);
  if Parser.CurrTokenId = CSTII_Function then
    FuncType:= 0
  else if Parser.CurrTokenId = CSTII_Procedure then
    FuncType := 1
  else if (Parser.CurrTokenId = CSTII_Constructor) and (FClassName <> '') then
    FuncType := 2
  else
  begin
    Parser.Free;
    Result := False;
    exit;
  end;
  Parser.Next;
  if Parser.CurrTokenId <> CSTI_Identifier then
  begin
    Parser.Free;
    Result := False;
    exit;
  end; {if}
  OrgName := Parser.OriginalToken;
  Parser.Next;
  if Parser.CurrTokenId = CSTI_OpenRound then
  begin
    Parser.Next;
    if Parser.CurrTokenId <> CSTI_CloseRound then
    begin
      while True do
      begin
        if Parser.CurrTokenId = CSTII_Const then
        begin
          modifier := pmIn;
          Parser.Next;
        end
        else
        if Parser.CurrTokenId = CSTII_Var then
        begin
          modifier := pmInOut;
          Parser.Next;
        end
        else
        if Parser.CurrTokenId = CSTII_Out then
        begin
          modifier := pmOut;
          Parser.Next;
        end
        else
          modifier := pmIn;
        if Parser.CurrTokenId <> CSTI_Identifier then
        begin
          Parser.Free;
          Result := False;
          exit;
        end;
        VNames := Parser.OriginalToken + '|';
        Parser.Next;
        while Parser.CurrTokenId = CSTI_Comma do
        begin
          Parser.Next;
          if Parser.CurrTokenId <> CSTI_Identifier then
          begin
            Parser.Free;
            Result := False;
            exit;
          end;
          VNames := VNames + Parser.OriginalToken + '|';
          Parser.Next;
        end;
        if Parser.CurrTokenId <> CSTI_Colon then
        begin
          Parser.Free;
          Result := False;
          exit;
        end;
        Parser.Next;
        if Parser.CurrTokenID = CSTII_Array then
        begin
          Parser.nExt;
          if Parser.CurrTokenId <> CSTII_Of then
          begin
            Parser.Free;
            Result := False;
            exit;
          end;
          Parser.Next;
          if Parser.CurrTokenId = CSTII_Const then
            VCType := FindAndAddType(Owner, '!OPENARRAYOFCONST', 'array of Pointer')
          else begin
            VCType := Owner.GetTypeCopyLink(Owner.FindType(Parser.GetToken));
            if VCType = nil then
            begin
              Parser.Free;
              Result := False;
              exit;
            end;
            case VCType.BaseType of
              btU8: VCType := FindAndAddType(Owner, '!OPENARRAYOFU8', 'array of byte');
              btS8: VCType := FindAndAddType(Owner, '!OPENARRAYOFS8', 'array of ShortInt');
              btU16: VCType := FindAndAddType(Owner, '!OPENARRAYOFU16', 'array of SmallInt');
              btS16: VCType := FindAndAddType(Owner, '!OPENARRAYOFS16', 'array of Word');
              btU32: VCType := FindAndAddType(Owner, '!OPENARRAYOFU32', 'array of Cardinal');
              btS32: VCType := FindAndAddType(Owner, '!OPENARRAYOFS32', 'array of Longint');
              btSingle: VCType := FindAndAddType(Owner, '!OPENARRAYOFSINGLE', 'array of Single');
              btDouble: VCType := FindAndAddType(Owner, '!OPENARRAYOFDOUBLE', 'array of Double');
              btExtended: VCType := FindAndAddType(Owner, '!OPENARRAYOFEXTENDED', 'array of Extended');
              btString: VCType := FindAndAddType(Owner, '!OPENARRAYOFSTRING', 'array of String');
              btPChar: VCType := FindAndAddType(Owner, '!OPENARRAYOFPCHAR', 'array of PChar');
              btVariant: VCType := FindAndAddType(Owner, '!OPENARRAYOFVARIANT', 'array of variant');
            {$IFNDEF IFPS3_NOINT64}btS64:  VCType := FindAndAddType(Owner, '!OPENARRAYOFS64', 'array of Int64');{$ENDIF}
              btChar: VCType := FindAndAddType(Owner, '!OPENARRAYOFCHAR', 'array of Char');
            {$IFNDEF IFPS3_NOWIDESTRING}
              btWideString: VCType := FindAndAddType(Owner, '!OPENARRAYOFWIDESTRING', 'array of WideString');
              btWideChar: VCType := FindAndAddType(Owner, '!OPENARRAYOFWIDECHAR', 'array of WideChar');
            {$ENDIF}
              btClass: VCType := FindAndAddType(Owner, '!OPENARRAYOFTOBJECT', 'array of TObject');
            else
              begin
                Parser.Free;
                Result := False;
                exit;
              end;
            end;
          end;
        end else if Parser.CurrTokenID = CSTII_Const then
          VCType := nil // any type
        else begin
          VCType := Owner.FindType(Parser.GetToken);
          if VCType = nil then
          begin
            Parser.Free;
            Result := False;
            exit;
          end;
        end;
        while Pos('|', VNames) > 0 do
        begin
          with DestDecl.AddParam do
          begin
            Mode := modifier;
            OrgName := copy(VNames, 1, Pos('|', VNames) - 1);
            aType := VCType;
          end;
          Delete(VNames, 1, Pos('|', VNames));
        end;
        Parser.Next;
        if Parser.CurrTokenId = CSTI_CloseRound then
          break;
        if Parser.CurrTokenId <> CSTI_Semicolon then
        begin
          Parser.Free;
          Result := False;
          exit;
        end;
        Parser.Next;
      end; {while}
    end; {if}
    Parser.Next;
  end; {if}
  if FuncType = 0 then
  begin
    if Parser.CurrTokenId <> CSTI_Colon then
    begin
      Parser.Free;
      Result := False;
      exit;
    end;

    Parser.Next;
    VCType := Owner.FindType(Parser.GetToken);
    if VCType = nil then
    begin
      Parser.Free;
      Result := False;
      exit;
    end;
  end
  else if FuncType = 2 then {constructor}
  begin
    VCType := Owner.FindType(FClassName)
  end else
    VCType := nil;
  DestDecl.Result := VCType;
  Parser.Free;
  if FuncType = 2 then
    Func := mftConstructor
  else
    Func := mftProc;
  Result := True;
end;



function TIFPSPascalCompiler.FindProc(const Name: string): Cardinal;
var
  l, h: Longint;
  x: TIFPSProcedure;
  xr: TIFPSRegProc;

begin
  h := MakeHash(Name);
  for l := FProcs.Count - 1 downto 0 do
  begin
    x := FProcs.Data^[l];
    if x.ClassType = TIFPSInternalProcedure then
    begin
      if (TIFPSInternalProcedure(x).NameHash = h) and
        (TIFPSInternalProcedure(x).Name = Name) then
      begin
        Result := l;
        exit;
      end;
    end
    else
    begin
      if (TIFPSExternalProcedure(x).RegProc.NameHash = h) and
        (TIFPSExternalProcedure(x).RegProc.Name = Name) then
      begin
        Result := l;
        exit;
      end;
    end;
  end;
  for l := 0 to FRegProcs.Count - 1 do
  begin
    xr := FRegProcs[l];
    if (xr.NameHash = h) and (xr.Name = Name) then
    begin
      x := TIFPSExternalProcedure.Create;
      TIFPSExternalProcedure(x).RegProc := xr;
      FProcs.Add(x);
      Result := FProcs.Count - 1;
      exit;
    end;
  end;
  Result := InvalidVal;
end; {findfunc}


function TIFPSPascalCompiler.FindBaseType(BaseType: TIFPSBaseType): TIFPSType;
var
  l: Longint;
  x: TIFPSType;
begin
  for l := 0 to FTypes.Count -1 do
  begin
    X := FTypes[l];
    if (x.BaseType = BaseType) and (x.ClassType = TIFPSType) then
    begin
      Result := at2ut(x);
      exit;
    end;
  end;
  X := TIFPSType.Create;
  x.Name := '';
  x.BaseType := BaseType;
  x.DeclarePos := InvalidVal;
  x.DeclareCol := 0;
  x.DeclareRow := 0;
  FTypes.Add(x);
  Result := at2ut(x);
end;

function TIFPSPascalCompiler.MakeDecl(decl: TIFPSParametersDecl): string;
var
  i: Longint;
begin
  if Decl.Result = nil then result := '0' else
  result := Decl.Result.Name;

  for i := 0 to decl.ParamCount -1 do
  begin
    if decl.GetParam(i).Mode = pmIn then
      Result := Result + ' @'
    else
      Result := Result + ' !';
    Result := Result + decl.GetParam(i).aType.Name;
  end;
end;


{ TIFPSPascalCompiler }

const
  BtTypeCopy = 255;


type
  TFuncType = (ftProc, ftFunc);

function IFPS3_mi2s(i: Cardinal): string;
begin
  Result := #0#0#0#0;
  Cardinal((@Result[1])^) := i;
end;




function TIFPSPascalCompiler.AddType(const Name: string; const BaseType: TIFPSBaseType): TIFPSType;
begin
  if FProcs = nil then
  begin
    raise EIFPSCompilerException.Create('This function can only be called from within the OnUses event');
  end;

  case BaseType of
    btProcPtr: Result := TIFPSProceduralType.Create;
    BtTypeCopy: Result := TIFPSTypeLink.Create;
    btRecord: Result := TIFPSRecordType.Create;
    btArray: Result := TIFPSArrayType.Create;
    btStaticArray: Result := TIFPSStaticArrayType.Create;
    btEnum: Result := TIFPSEnumType.Create;
    btClass: Result := TIFPSClassType.Create;
{$IFNDEF IFPS3_NOINTERFACES}
    btInterface: Result := TIFPSInterfaceType.Create;
{$ENDIF}
  else
    Result := TIFPSType.Create;
  end;
  Result.Name := FastUppercase(Name);
  Result.OriginalName := Name;
  Result.BaseType := BaseType;
  Result.DeclarePos := InvalidVal;
  Result.DeclareCol := 0;
  Result.DeclareRow := 0;
  FTypes.Add(Result);
end;


function TIFPSPascalCompiler.AddFunction(const Header: string): TIFPSRegProc;
var
  Parser: TIfPascalParser;
  IsFunction: Boolean;
  VNames, Name: string;
  Decl: TIFPSParametersDecl;
  modifier: TIFPSParameterMode;
  VCType: TIFPSType;
  x: TIFPSRegProc;
begin
  if FProcs = nil then
    raise EIFPSCompilerException.Create('This function can only be called from within the OnUses event');

  Parser := TIfPascalParser.Create;
  Parser.SetText(Header);
  Decl := TIFPSParametersDecl.Create;
  x := nil;
  try
    if Parser.CurrTokenId = CSTII_Function then
      IsFunction := True
    else if Parser.CurrTokenId = CSTII_Procedure then
      IsFunction := False
    else
      Raise EIFPSCompilerException.Create('Unable to register function '+Name);
    Parser.Next;
    if Parser.CurrTokenId <> CSTI_Identifier then
      Raise EIFPSCompilerException.Create('Unable to register function '+Name);
    Name := Parser.OriginalToken;
    Parser.Next;
    if Parser.CurrTokenId = CSTI_OpenRound then
    begin
      Parser.Next;
      if Parser.CurrTokenId <> CSTI_CloseRound then
      begin
        while True do
        begin
          if Parser.CurrTokenId = CSTII_Out then
          begin
            Modifier := pmOut;
            Parser.Next;
          end else
          if Parser.CurrTokenId = CSTII_Const then
          begin
            Modifier := pmIn;
            Parser.Next;
          end else
          if Parser.CurrTokenId = CSTII_Var then
          begin
            modifier := pmInOut;
            Parser.Next;
          end
          else
            modifier := pmIn;
          if Parser.CurrTokenId <> CSTI_Identifier then
            raise EIFPSCompilerException.Create('Unable to register function '+Name);
          VNames := Parser.OriginalToken + '|';
          Parser.Next;
          while Parser.CurrTokenId = CSTI_Comma do
          begin
            Parser.Next;
            if Parser.CurrTokenId <> CSTI_Identifier then
              Raise EIFPSCompilerException.Create('Unable to register function '+Name);
            VNames := VNames + Parser.OriginalToken + '|';
            Parser.Next;
          end;
          if Parser.CurrTokenId <> CSTI_Colon then
          begin
            Parser.Free;
            Raise EIFPSCompilerException.Create('Unable to register function '+Name);
          end;
          Parser.Next;
          VCType := FindType(Parser.GetToken);
          if VCType = nil then
            Raise EIFPSCompilerException.Create('Unable to register function '+Name);
          while Pos('|', VNames) > 0 do
          begin
            with Decl.AddParam do
            begin
              Mode := modifier;
              OrgName := copy(VNames, 1, Pos('|', VNames) - 1);
              aType := VCType;
            end;
            Delete(VNames, 1, Pos('|', VNames));
          end;
          Parser.Next;
          if Parser.CurrTokenId = CSTI_CloseRound then
            break;
          if Parser.CurrTokenId <> CSTI_Semicolon then
            Raise EIFPSCompilerException.Create('Unable to register function '+Name);
          Parser.Next;
        end; {while}
      end; {if}
      Parser.Next;
    end; {if}
    if IsFunction then
    begin
      if Parser.CurrTokenId <> CSTI_Colon then
        Raise EIFPSCompilerException.Create('Unable to register function '+Name);

      Parser.Next;
      VCType := FindType(Parser.GetToken);
      if VCType = nil then
        Raise EIFPSCompilerException.Create('Unable to register function '+Name);
    end
    else
      VCType := nil;
    Decl.Result := VCType;
    X := TIFPSRegProc.Create;
    x.OrgName := Name;
    x.Name := FastUpperCase(Name);
    x.ExportName := True;
    x.Decl.Assign(decl);
    FRegProcs.Add(x);
  finally
    Decl.Free;
    Parser.Free;
  end;
  Result := x;
end;

function TIFPSPascalCompiler.MakeHint(const Module: string; E: TIFPSPascalCompilerHintType; const Param: string): TIFPSPascalCompilerMessage;
var
  n: TIFPSPascalCompilerHint;
begin
  N := TIFPSPascalCompilerHint.Create;
  n.FHint := e;
  n.SetParserPos(FParser);
  n.FModuleName := Module;
  n.FParam := Param;
  FMessages.Add(n);
  Result := n;
end;

function TIFPSPascalCompiler.MakeError(const Module: string; E:
  TIFPSPascalCompilerErrorType; const Param: string): TIFPSPascalCompilerMessage;
var
  n: TIFPSPascalCompilerError;
begin
  N := TIFPSPascalCompilerError.Create;
  n.FError := e;
  n.SetParserPos(FParser);
  n.FModuleName := Module;
  n.FParam := Param;
  FMessages.Add(n);
  Result := n;
end;

function TIFPSPascalCompiler.MakeWarning(const Module: string; E:
  TIFPSPascalCompilerWarningType; const Param: string): TIFPSPascalCompilerMessage;
var
  n: TIFPSPascalCompilerWarning;
begin
  N := TIFPSPascalCompilerWarning.Create;
  n.FWarning := e;
  n.SetParserPos(FParser);
  n.FModuleName := Module;
  n.FParam := Param;
  FMessages.Add(n);
  Result := n;
end;

procedure TIFPSPascalCompiler.Clear;
var
  l: Longint;
begin
  FDebugOutput := '';
  FOutput := '';
  for l := 0 to FMessages.Count - 1 do
    TIFPSPascalCompilerMessage(FMessages[l]).Free;
  FMessages.Clear;
  for L := FAutoFreeList.Count -1 downto 0 do
  begin
    TObject(FAutoFreeList[l]).Free;
  end;
  FAutoFreeList.Clear;
end;

procedure CopyVariantContents(Src, Dest: PIfRVariant);
begin
  case src.FType.BaseType of
    btu8, bts8: dest^.tu8 := src^.tu8;
    btu16, bts16: dest^.tu16 := src^.tu16;
    btenum, btu32, bts32: dest^.tu32 := src^.tu32;
    btsingle: Dest^.tsingle := src^.tsingle;
    btdouble: Dest^.tdouble := src^.tdouble;
    btextended: Dest^.textended := src^.textended;
    btCurrency: Dest^.tcurrency := Src^.tcurrency;
    btchar: Dest^.tchar := src^.tchar;
    {$IFNDEF IFPS3_NOINT64}bts64: dest^.ts64 := src^.ts64;{$ENDIF}
    btset, btstring: tbtstring(dest^.tstring) := tbtstring(src^.tstring);
    {$IFNDEF IFPS3_NOWIDESTRING}
    btwidestring: tbtwidestring(dest^.twidestring) := tbtwidestring(src^.twidestring);
    btwidechar: Dest^.tchar := src^.tchar;
    {$ENDIF}
  end;
end;

function DuplicateVariant(Src: PIfRVariant): PIfRVariant;
begin
  New(Result);
  FillChar(Result^, SizeOf(TIfRVariant), 0);
  CopyVariantContents(Src, Result);
end;


procedure InitializeVariant(Vari: PIfRVariant; FType: TIFPSType);
begin
  FillChar(vari^, SizeOf(TIfRVariant), 0);
  if FType.BaseType = btSet then
  begin
    SetLength(tbtstring(vari^.tstring), TIFPSSetType(FType).ByteSize);
    fillchar(tbtstring(vari^.tstring)[1], length(tbtstring(vari^.tstring)), 0);
  end;
  vari^.FType := FType;
end;

function NewVariant(FType: TIFPSType): PIfRVariant;
begin
  New(Result);
  InitializeVariant(Result, FType);
end;
{$IFDEF FPC}
procedure Finalize(var s: string); overload; begin s := ''; end;
procedure Finalize(var s: widestring); overload; begin s := ''; end;
{$ENDIF}

procedure FinalizeVariant(var p: TIfRVariant);
begin
  if (p.FType.BaseType = btString) or (p.FType.basetype = btSet) then
    finalize(tbtstring(p.tstring))
  {$IFNDEF IFPS3_NOWIDESTRING}
  else if p.FType.BaseType = btWideString then
    finalize(tbtWideString(p.twidestring)); // widestring
  {$ENDIF}
end;

procedure DisposeVariant(p: PIfRVariant);
begin
  if p <> nil then
  begin
    FinalizeVariant(p^);
    Dispose(p);
  end;
end;



function TIFPSPascalCompiler.GetTypeCopyLink(p: TIFPSType): TIFPSType;
begin
  if p = nil then
    Result := nil
  else
  if p.BaseType = BtTypeCopy then
  begin
    Result := TIFPSTypeLink(p).LinkTypeNo;
  end else Result := p;
end;

function IsIntType(b: TIFPSBaseType): Boolean;
begin
  case b of
    btU8, btS8, btU16, btS16, btU32, btS32{$IFNDEF IFPS3_NOINT64}, btS64{$ENDIF}: Result := True;
  else
    Result := False;
  end;
end;

function IsRealType(b: TIFPSBaseType): Boolean;
begin
  case b of
    btSingle, btDouble, btCurrency, btExtended: Result := True;
  else
    Result := False;
  end;
end;

function IsIntRealType(b: TIFPSBaseType): Boolean;
begin
  case b of
    btSingle, btDouble, btCurrency, btExtended, btU8, btS8, btU16, btS16, btU32, btS32{$IFNDEF IFPS3_NOINT64}, btS64{$ENDIF}:
      Result := True;
  else
    Result := False;
  end;

end;

function DiffRec(p1, p2: TIFPSSubItem): Boolean;
begin
  if p1.ClassType = p2.ClassType then
  begin
    if P1.ClassType = TIFPSSubNumber then
      Result := TIFPSSubNumber(p1).SubNo <> TIFPSSubNumber(p2).SubNo
    else if P1.ClassType = TIFPSSubValue then
      Result := TIFPSSubValue(p1).SubNo <> TIFPSSubValue(p2).SubNo
    else
      Result := False;
  end else Result := True;
end;

function SameReg(x1, x2: TIFPSValue): Boolean;
var
  I: Longint;
begin
  if (x1.ClassType = x2.ClassType) and (X1 is TIFPSValueVar) then
  begin
    if
    ((x1.ClassType = TIFPSValueGlobalVar) and (TIFPSValueGlobalVar(x1).GlobalVarNo = TIFPSValueGlobalVar(x2).GlobalVarNo)) or
    ((x1.ClassType = TIFPSValueLocalVar) and (TIFPSValueLocalVar(x1).LocalVarNo = TIFPSValueLocalVar(x2).LocalVarNo)) or
    ((x1.ClassType = TIFPSValueParamVar) and (TIFPSValueParamVar(x1).ParamNo = TIFPSValueParamVar(x2).ParamNo)) or
    ((x1.ClassType = TIFPSValueAllocatedStackVar) and (TIFPSValueAllocatedStackVar(x1).LocalVarNo = TIFPSValueAllocatedStackVar(x2).LocalVarNo)) then
    begin
      if TIFPSValueVar(x1).GetRecCount <> TIFPSValueVar(x2).GetRecCount then
      begin
        Result := False;
        exit;
      end;
      for i := 0 to TIFPSValueVar(x1).GetRecCount -1 do
      begin
        if DiffRec(TIFPSValueVar(x1).RecItem[i], TIFPSValueVar(x2).RecItem[i]) then
        begin
          Result := False;
          exit;
        end;
      end;
      Result := True;
    end else Result := False;
  end
  else
    Result := False;
end;

function GetUInt(Src: PIfRVariant; var s: Boolean): Cardinal;
begin
  case Src.FType.BaseType of
    btU8: Result := Src^.tu8;
    btS8: Result := Src^.ts8;
    btU16: Result := Src^.tu16;
    btS16: Result := Src^.ts16;
    btU32: Result := Src^.tu32;
    btS32: Result := Src^.ts32;
    {$IFNDEF IFPS3_NOINT64}
    bts64: Result := src^.ts64;
    {$ENDIF}
    btChar: Result := ord(Src^.tchar);
    {$IFNDEF IFPS3_NOWIDESTRING}
    btWideChar: Result := ord(tbtwidechar(src^.twidechar));
    {$ENDIF}
    btEnum: Result := src^.tu32;
  else
    begin
      s := False;
      Result := 0;
    end;
  end;
end;

function GetInt(Src: PIfRVariant; var s: Boolean): Longint;
begin
  case Src.FType.BaseType of
    btU8: Result := Src^.tu8;
    btS8: Result := Src^.ts8;
    btU16: Result := Src^.tu16;
    btS16: Result := Src^.ts16;
    btU32: Result := Src^.tu32;
    btS32: Result := Src^.ts32;
    {$IFNDEF IFPS3_NOINT64}
    bts64: Result := src^.ts64;
    {$ENDIF}
    btChar: Result := ord(Src^.tchar);
    {$IFNDEF IFPS3_NOWIDESTRING}
    btWideChar: Result := ord(tbtwidechar(src^.twidechar));
    {$ENDIF}
    btEnum: Result := src^.tu32;
  else
    begin
      s := False;
      Result := 0;
    end;
  end;
end;
{$IFNDEF IFPS3_NOINT64}
function GetInt64(Src: PIfRVariant; var s: Boolean): Int64;
begin
  case Src.FType.BaseType of
    btU8: Result := Src^.tu8;
    btS8: Result := Src^.ts8;
    btU16: Result := Src^.tu16;
    btS16: Result := Src^.ts16;
    btU32: Result := Src^.tu32;
    btS32: Result := Src^.ts32;
    bts64: Result := src^.ts64;
    btChar: Result := ord(Src^.tchar);
    {$IFNDEF IFPS3_NOWIDESTRING}
    btWideChar: Result := ord(tbtwidechar(src^.twidechar));
    {$ENDIF}
    btEnum: Result := src^.tu32;
  else
    begin
      s := False;
      Result := 0;
    end;
  end;
end;
{$ENDIF}

function GetReal(Src: PIfRVariant; var s: Boolean): Extended;
begin
  case Src.FType.BaseType of
    btU8: Result := Src^.tu8;
    btS8: Result := Src^.ts8;
    btU16: Result := Src^.tu16;
    btS16: Result := Src^.ts16;
    btU32: Result := Src^.tu32;
    btS32: Result := Src^.ts32;
    {$IFNDEF IFPS3_NOINT64}
    bts64: Result := src^.ts64;
    {$ENDIF}
    btChar: Result := ord(Src^.tchar);
    {$IFNDEF IFPS3_NOWIDESTRING}
    btWideChar: Result := ord(tbtwidechar(src^.twidechar));
    {$ENDIF}
    btSingle: Result := Src^.tsingle;
    btDouble: Result := Src^.tdouble;
    btCurrency: Result := SRc^.tcurrency;
    btExtended: Result := Src^.textended;
  else
    begin
      s := False;
      Result := 0;
    end;
  end;
end;

function GetString(Src: PIfRVariant; var s: Boolean): string;
begin
  case Src.FType.BaseType of
    btChar: Result := Src^.tchar;
    btString: Result := tbtstring(src^.tstring);
    {$IFNDEF IFPS3_NOWIDESTRING}
    btWideChar: Result := src^.twidechar;
    btWideString: Result := tbtWideString(src^.twidestring);
    {$ENDIF}
  else
    begin
      s := False;
      Result := '';
    end;
  end;
end;

{$IFNDEF IFPS3_NOWIDESTRING}
function TIFPSPascalCompiler.GetWideString(Src: PIfRVariant; var s: Boolean): WideString;
begin
  case Src.FType.BaseType of
    btChar: Result := Src^.tchar;
    btString: Result := tbtstring(src^.tstring);
    btWideChar: Result := src^.twidechar;
    btWideString: Result := tbtWideString(src^.twidestring);
  else
    begin
      s := False;
      Result := '';
    end;
  end;
end;
{$ENDIF}

function ab(b: Longint): Longint;
begin
  ab := Longint(b = 0);
end;

procedure Set_Union(Dest, Src: PByteArray; ByteSize: Integer);
var
  i: Longint;
begin
  for i := ByteSize -1 downto 0 do
    Dest^[i] := Dest^[i] or Src^[i];
end;

procedure Set_Diff(Dest, Src: PByteArray; ByteSize: Integer);
var
  i: Longint;
begin
  for i := ByteSize -1 downto 0 do
    Dest^[i] := Dest^[i] and not Src^[i];
end;

procedure Set_Intersect(Dest, Src: PByteArray; ByteSize: Integer);
var
  i: Longint;
begin
  for i := ByteSize -1 downto 0 do
    Dest^[i] := Dest^[i] and Src^[i];
end;

procedure Set_Subset(Dest, Src: PByteArray; ByteSize: Integer; var Val: Boolean);
var
  i: Integer;
begin
  for i := ByteSize -1 downto 0 do
  begin
    if not (Src^[i] and Dest^[i] = Dest^[i]) then
    begin
      Val := False;
      exit;
    end;
  end;
  Val := True;
end;

procedure Set_Equal(Dest, Src: PByteArray; ByteSize: Integer; var Val: Boolean);
var
  i: Longint;
begin
  for i := ByteSize -1 downto 0 do
  begin
    if Dest^[i] <> Src^[i] then
    begin
      Val := False;
      exit;
    end;
  end;
  val := True;
end;

procedure Set_membership(Item: Longint; Src: PByteArray; var Val: Boolean);
begin
  Val := (Src^[Item shr 3] and (1 shl (Item and 7))) <> 0;
end;

procedure Set_MakeMember(Item: Longint; Src: PByteArray);
begin
  Src^[Item shr 3] := Src^[Item shr 3] or (1 shl (Item and 7));
end;

procedure ConvertToBoolean(SE: TIFPSPascalCompiler; FUseUsedTypes: Boolean; var1: PIFRVariant; b: Boolean);
begin
  FinalizeVariant(var1^);
  if FUseUsedTypes then
    Var1^.FType := se.at2ut(se.FDefaultBoolType)
  else
    Var1^.FType := Se.FDefaultBoolType;
  var1^.tu32 := Ord(b);
end;

procedure ConvertToString(SE: TIFPSPascalCompiler; FUseUsedTypes: Boolean; var1: PIFRVariant; const s: string);
var
  atype: TIFPSType;
begin
  FinalizeVariant(var1^);
  atype := se.FindBaseType(btString);
  if FUseUsedTypes then
    InitializeVariant(var1, se.at2ut(atype))
  else
    InitializeVariant(var1, atype);
  tbtstring(var1^.tstring) := s;
end;
{$IFNDEF IFPS3_NOWIDESTRING}
procedure ConvertToWideString(SE: TIFPSPascalCompiler; FUseUsedTypes: Boolean; var1: PIFRVariant; const s: WideString);
var
  atype: TIFPSType;
begin
  FinalizeVariant(var1^);
  atype := se.FindBaseType(btWideString);
  if FUseUsedTypes then
    InitializeVariant(var1, se.at2ut(atype))
  else
    InitializeVariant(var1, atype);
  tbtwidestring(var1^.twidestring) := s;
end;
{$ENDIF}
procedure ConvertToFloat(SE: TIFPSPascalCompiler; FUseUsedTypes: Boolean; var1: PIfRVariant; NewType: TIFPSType);
var
  vartemp: PIfRVariant;
  b: Boolean;
begin
  New(vartemp);
  if FUseUsedTypes then
    NewType := se.at2ut(NewType);
  InitializeVariant(vartemp, var1.FType);
  CopyVariantContents(var1, vartemp);
  FinalizeVariant(var1^);
  InitializeVariant(var1, newtype);
  case var1.ftype.basetype of
    btSingle:
      begin
        if (vartemp.ftype.BaseType = btu8) or (vartemp.ftype.BaseType = btu16) or (vartemp.ftype.BaseType = btu32) then
          var1^.tsingle := GetUInt(vartemp, b)
        else
          var1^.tsingle := GetInt(vartemp, b)
      end;
    btDouble:
      begin
        if (vartemp.ftype.BaseType = btu8) or (vartemp.ftype.BaseType = btu16) or (vartemp.ftype.BaseType = btu32) then
          var1^.tdouble := GetUInt(vartemp, b)
        else
          var1^.tdouble := GetInt(vartemp, b)
      end;
    btExtended:
      begin
        if (vartemp.ftype.BaseType = btu8) or (vartemp.ftype.BaseType = btu16) or (vartemp.ftype.BaseType = btu32) then
          var1^.textended:= GetUInt(vartemp, b)
        else
          var1^.textended:= GetInt(vartemp, b)
      end;
    btCurrency:
      begin
        if (vartemp.ftype.BaseType = btu8) or (vartemp.ftype.BaseType = btu16) or (vartemp.ftype.BaseType = btu32) then
          var1^.tcurrency:= GetUInt(vartemp, b)
        else
          var1^.tcurrency:= GetInt(vartemp, b)
      end;
  end;
  DisposeVariant(vartemp);
end;


function TIFPSPascalCompiler.IsCompatibleType(p1, p2: TIFPSType; Cast: Boolean): Boolean;
begin
  if
    ((p1.BaseType = btProcPtr) and (p2 = p1)) or
    (p1.BaseType = btPointer) or
    (p2.BaseType = btPointer) or
    (p1.BaseType = btVariant) or
    (p2.BaseType = btVariant) or
    (IsIntType(p1.BaseType) and IsIntType(p2.BaseType)) or
    (IsRealType(p1.BaseType) and IsIntRealType(p2.BaseType)) or
    (((p1.basetype = btPchar) or (p1.BaseType = btString)) and ((p2.BaseType = btString) or (p2.BaseType = btPchar))) or
    (((p1.basetype = btPchar) or (p1.BaseType = btString)) and (p2.BaseType = btChar)) or
    (((p1.BaseType = btArray) or (p1.BaseType = btStaticArray)) and (
    (p2.BaseType = btArray) or (p2.BaseType = btStaticArray)) and IsCompatibleType(TIFPSArrayType(p1).ArrayTypeNo, TIFPSArrayType(p2).ArrayTypeNo, False)) or
    ((p1.BaseType = btChar) and (p2.BaseType = btChar)) or
    ((p1.BaseType = btSet) and (p2.BaseType = btSet)) or
    {$IFNDEF IFPS3_NOWIDESTRING}
    ((p1.BaseType = btWideChar) and (p2.BaseType = btChar)) or
    ((p1.BaseType = btWideChar) and (p2.BaseType = btWideChar)) or
    ((p1.BaseType = btWidestring) and (p2.BaseType = btChar)) or
    ((p1.BaseType = btWidestring) and (p2.BaseType = btWideChar)) or
    ((p1.BaseType = btWidestring) and ((p2.BaseType = btString) or (p2.BaseType = btPchar))) or
    ((p1.BaseType = btWidestring) and (p2.BaseType = btWidestring)) or
    (((p1.basetype = btPchar) or (p1.BaseType = btString)) and (p2.BaseType = btWideString)) or
    (((p1.basetype = btPchar) or (p1.BaseType = btString)) and (p2.BaseType = btWidechar)) or
    (((p1.basetype = btPchar) or (p1.BaseType = btString)) and (p2.BaseType = btchar)) or
    {$ENDIF}
    ((p1.BaseType = btRecord) and (p2.BaseType = btrecord)) or
    ((p1.BaseType = btEnum) and (p2.BaseType = btEnum)) or
    (Cast and IsIntType(P1.BaseType) and (p2.baseType = btEnum)) or
    (Cast and (p2.baseType = btEnum) and IsIntType(P1.BaseType))
    then
    Result := True
  else if p1.BaseType = btclass then
    Result := TIFPSClassType(p1).cl.IsCompatibleWith(p2)
{$IFNDEF IFPS3_NOINTERFACES}
  else if p1.BaseType = btInterface then
    Result := TIFPSInterfaceType(p1).Intf.IsCompatibleWith(p2)
{$ENDIF}
  else
    Result := False;
end;


function TIFPSPascalCompiler.PreCalc(FUseUsedTypes: Boolean; Var1Mod: Byte; var1: PIFRVariant; Var2Mod: Byte; Var2: PIfRVariant; Cmd: TIFPSBinOperatorType; Pos, Row, Col: Cardinal): Boolean;
  { var1=dest, var2=src }
var
  b: Boolean;

begin
  Result := True;
  try
    if (IsRealType(var2.FType.BaseType) and IsIntType(var1.FType.BaseType)) then
      ConvertToFloat(Self, FUseUsedTypes, var1, var2^.FType);
    case Cmd of
      otAdd:
        begin { + }
          case var1.FType.BaseType of
            btU8: var1^.tu8 := var1^.tu8 + GetUint(Var2, Result);
            btS8: var1^.ts8 := var1^.ts8 + GetInt(Var2, Result);
            btU16: var1^.tu16 := var1^.tu16 + GetUint(Var2, Result);
            btS16: var1^.ts16 := var1^.ts16 + Getint(Var2, Result);
            btEnum, btU32: var1^.tu32 := var1^.tu32 + GetUint(Var2, Result);
            btS32: var1^.ts32 := var1^.ts32 + Getint(Var2, Result);
            {$IFNDEF IFPS3_NOINT64}btS64: var1^.ts64 := var1^.ts64 + GetInt64(Var2, Result); {$ENDIF}
            btSingle: var1^.tsingle := var1^.tsingle + GetReal( Var2, Result);
            btDouble: var1^.tdouble := var1^.tdouble + GetReal( Var2, Result);
            btExtended: var1^.textended := var1^.textended + GetReal( Var2, Result);
            btCurrency: var1^.tcurrency := var1^.tcurrency + GetReal( Var2, Result);
            btSet:
              begin
                if (var1.FType = var2.FType) then
                begin
                  Set_Union(var1.tstring, var2.tstring, TIFPSSetType(var1.FType).ByteSize);
                end else Result := False;
              end;
            btChar:
              begin
                ConvertToString(Self, FUseUsedTypes, var1, getstring(Var1, b)+getstring(Var2, b));
              end;
            btString: tbtstring(var1^.tstring) := tbtstring(var1^.tstring) + GetString(Var2, Result);
            {$IFNDEF IFPS3_NOWIDESTRING}
            btwideString: tbtwidestring(var1^.twidestring) := tbtwidestring(var1^.twidestring) + GetWideString(Var2, Result);
            btWidechar:
              begin
                if (var2.FType.BaseType = btchar) or (var2.FType.BaseType = btwidechar) then
                  var1^.tu16 := var1^.tu16 + GetUint(Var2, Result)
                else
                begin
                  ConvertToWideString(Self, FUseUsedTypes, var1, GetWideString(Var1, b)+GetWideString(Var2, b));
                end;
              end;
            {$ENDIF}
            else Result := False;
          end;
        end;
      otSub:
        begin { - }
          case Var1.FType.BaseType of
            btU8: var1^.tu8 := var1^.tu8 - GetUint(Var2, Result);
            btS8: var1^.ts8 := var1^.ts8 - Getint(Var2, Result);
            btU16: var1^.tu16 := var1^.tu16 - GetUint(Var2, Result);
            btS16: var1^.ts16 := var1^.ts16 - Getint(Var2, Result);
            btEnum, btU32: var1^.tu32 := var1^.tu32 - GetUint(Var2, Result);
            btS32: var1^.ts32 := var1^.ts32 - Getint(Var2, Result);
            {$IFNDEF IFPS3_NOINT64}btS64: var1^.ts64 := var1^.ts64 - GetInt64(Var2, Result); {$ENDIF}
            btSingle: var1^.tsingle := var1^.tsingle - GetReal( Var2, Result);
            btDouble: var1^.tdouble := var1^.tdouble - GetReal(Var2, Result);
            btExtended: var1^.textended := var1^.textended - GetReal(Var2, Result);
            btCurrency: var1^.tcurrency := var1^.tcurrency - GetReal( Var2, Result);
            btSet:
              begin
                if (var1.FType = var2.FType) then
                begin
                  Set_Diff(var1.tstring, var2.tstring, TIFPSSetType(var1.FType).ByteSize);
                end else Result := False;
              end;
            else Result := False;
          end;
        end;
      otMul:
        begin { * }
          case Var1.FType.BaseType of
            btU8: var1^.tu8 := var1^.tu8 * GetUint(Var2, Result);
            btS8: var1^.ts8 := var1^.ts8 * Getint(Var2, Result);
            btU16: var1^.tu16 := var1^.tu16 * GetUint(Var2, Result);
            btS16: var1^.ts16 := var1^.ts16 * Getint(Var2, Result);
            btU32: var1^.tu32 := var1^.tu32 * GetUint(Var2, Result);
            btS32: var1^.ts32 := var1^.ts32 * Getint(Var2, Result);
            {$IFNDEF IFPS3_NOINT64}btS64: var1^.ts64 := var1^.ts64 * GetInt64(Var2, Result); {$ENDIF}
            btSingle: var1^.tsingle := var1^.tsingle * GetReal(Var2, Result);
            btDouble: var1^.tdouble := var1^.tdouble * GetReal(Var2, Result);
            btExtended: var1^.textended := var1^.textended * GetReal( Var2, Result);
            btCurrency: var1^.tcurrency := var1^.tcurrency * GetReal( Var2, Result);
            btSet:
              begin
                if (var1.FType = var2.FType) then
                begin
                  Set_Intersect(var1.tstring, var2.tstring, TIFPSSetType(var1.FType).ByteSize);
                end else Result := False;
              end;
            else Result := False;
          end;
        end;
      otDiv:
        begin { / }
          case Var1.FType.BaseType of
            btU8: var1^.tu8 := var1^.tu8 div GetUint(Var2, Result);
            btS8: var1^.ts8 := var1^.ts8 div Getint(Var2, Result);
            btU16: var1^.tu16 := var1^.tu16 div GetUint(Var2, Result);
            btS16: var1^.ts16 := var1^.ts16 div Getint(Var2, Result);
            btU32: var1^.tu32 := var1^.tu32 div GetUint(Var2, Result);
            btS32: var1^.ts32 := var1^.ts32 div Getint(Var2, Result);
            {$IFNDEF IFPS3_NOINT64}btS64: var1^.ts64 := var1^.ts64 div GetInt64(Var2, Result); {$ENDIF}
            btSingle: var1^.tsingle := var1^.tsingle / GetReal( Var2, Result);
            btDouble: var1^.tdouble := var1^.tdouble / GetReal( Var2, Result);
            btExtended: var1^.textended := var1^.textended / GetReal( Var2, Result);
            btCurrency: var1^.tcurrency := var1^.tcurrency / GetReal( Var2, Result);
            else Result := False;
          end;
        end;
      otMod:
        begin { MOD }
          case Var1.FType.BaseType of
            btU8: var1^.tu8 := var1^.tu8 mod GetUint(Var2, Result);
            btS8: var1^.ts8 := var1^.ts8 mod Getint(Var2, Result);
            btU16: var1^.tu16 := var1^.tu16 mod GetUint(Var2, Result);
            btS16: var1^.ts16 := var1^.ts16 mod Getint(Var2, Result);
            btU32: var1^.tu32 := var1^.tu32 mod GetUint(Var2, Result);
            btS32: var1^.ts32 := var1^.ts32 mod Getint(Var2, Result);
            {$IFNDEF IFPS3_NOINT64}btS64: var1^.ts64 := var1^.ts64 mod GetInt64(Var2, Result); {$ENDIF}
            else Result := False;
          end;
        end;
      otshl:
        begin { SHL }
          case Var1.FType.BaseType of
            btU8: var1^.tu8 := var1^.tu8 shl GetUint(Var2, Result);
            btS8: var1^.ts8 := var1^.ts8 shl Getint(Var2, Result);
            btU16: var1^.tu16 := var1^.tu16 shl GetUint(Var2, Result);
            btS16: var1^.ts16 := var1^.ts16 shl Getint(Var2, Result);
            btU32: var1^.tu32 := var1^.tu32 shl GetUint(Var2, Result);
            btS32: var1^.ts32 := var1^.ts32 shl Getint(Var2, Result);
            {$IFNDEF IFPS3_NOINT64}btS64: var1^.ts64 := var1^.ts64 shl GetInt64(Var2, Result); {$ENDIF}
            else Result := False;
          end;
        end;
      otshr:
        begin { SHR }
          case Var1.FType.BaseType of
            btU8: var1^.tu8 := var1^.tu8 shr GetUint(Var2, Result);
            btS8: var1^.ts8 := var1^.ts8 shr Getint(Var2, Result);
            btU16: var1^.tu16 := var1^.tu16 shr GetUint(Var2, Result);
            btS16: var1^.ts16 := var1^.ts16 shr Getint(Var2, Result);
            btU32: var1^.tu32 := var1^.tu32 shr GetUint(Var2, Result);
            btS32: var1^.ts32 := var1^.ts32 shr Getint(Var2, Result);
            {$IFNDEF IFPS3_NOINT64}btS64: var1^.ts64 := var1^.ts64 shr GetInt64( Var2, Result); {$ENDIF}
            else Result := False;
          end;
        end;
      otAnd:
        begin { AND }
          case Var1.FType.BaseType of
            btU8: var1^.tu8 := var1^.tu8 and GetUint(Var2, Result);
            btS8: var1^.ts8 := var1^.ts8 and Getint(Var2, Result);
            btU16: var1^.tu16 := var1^.tu16 and GetUint(Var2, Result);
            btS16: var1^.ts16 := var1^.ts16 and Getint(Var2, Result);
            btU32: var1^.tu32 := var1^.tu32 and GetUint(Var2, Result);
            btS32: var1^.ts32 := var1^.ts32 and Getint(Var2, Result);
            btEnum: var1^.ts32 := var1^.ts32 and Getint(Var2, Result);
            {$IFNDEF IFPS3_NOINT64}btS64: var1^.ts64 := var1^.ts64 and GetInt64(Var2, Result); {$ENDIF}
            else Result := False;
          end;
        end;
      otor:
        begin { OR }
          case Var1.FType.BaseType of
            btU8: var1^.tu8 := var1^.tu8 or GetUint(Var2, Result);
            btS8: var1^.ts8 := var1^.ts8 or Getint(Var2, Result);
            btU16: var1^.tu16 := var1^.tu16 or GetUint(Var2, Result);
            btS16: var1^.ts16 := var1^.ts16 or Getint(Var2, Result);
            btU32: var1^.tu32 := var1^.tu32 or GetUint(Var2, Result);
            btS32: var1^.ts32 := var1^.ts32 or Getint(Var2, Result);
            {$IFNDEF IFPS3_NOINT64}btS64: var1^.ts64 := var1^.ts64 or GetInt64(Var2, Result); {$ENDIF}
            btEnum: var1^.ts32 := var1^.ts32 or Getint(Var2, Result);
            else Result := False;
          end;
        end;
      otxor:
        begin { XOR }
          case Var1.FType.BaseType of
            btU8: var1^.tu8 := var1^.tu8 xor GetUint(Var2, Result);
            btS8: var1^.ts8 := var1^.ts8 xor Getint(Var2, Result);
            btU16: var1^.tu16 := var1^.tu16 xor GetUint(Var2, Result);
            btS16: var1^.ts16 := var1^.ts16 xor Getint(Var2, Result);
            btU32: var1^.tu32 := var1^.tu32 xor GetUint(Var2, Result);
            btS32: var1^.ts32 := var1^.ts32 xor Getint(Var2, Result);
            {$IFNDEF IFPS3_NOINT64}btS64: var1^.ts64 := var1^.ts64 xor GetInt64(Var2, Result); {$ENDIF}
            btEnum: var1^.ts32 := var1^.ts32 xor Getint(Var2, Result);
            else Result := False;
          end;
        end;
      otGreaterEqual:
        begin { >= }
          case Var1.FType.BaseType of
            btU8: b := var1^.tu8 >= GetUint(Var2, Result);
            btS8: b := var1^.ts8 >= Getint(Var2, Result);
            btU16: b := var1^.tu16 >= GetUint(Var2, Result);
            btS16: b := var1^.ts16 >= Getint(Var2, Result);
            btU32: b := var1^.tu32 >= GetUint(Var2, Result);
            btS32: b := var1^.ts32 >= Getint(Var2, Result);
            {$IFNDEF IFPS3_NOINT64}btS64: b := var1^.ts64 >= GetInt64(Var2, Result); {$ENDIF}
            btSingle: b := var1^.tsingle >= GetReal( Var2, Result);
            btDouble: b := var1^.tdouble >= GetReal( Var2, Result);
            btExtended: b := var1^.textended >= GetReal( Var2, Result);
            btCurrency: b := var1^.tcurrency >= GetReal( Var2, Result);
            btSet:
              begin
                if (var1.FType = var2.FType) then
                begin
                  Set_Subset(var2.tstring, var1.tstring, TIFPSSetType(var1.FType).ByteSize, b);
                end else Result := False;
              end;
          else
            Result := False;
          end;
          ConvertToBoolean(Self, FUseUsedTypes, Var1, b);
        end;
      otLessEqual:
        begin { <= }
          case Var1.FType.BaseType of
            btU8: b := var1^.tu8 <= GetUint(Var2, Result);
            btS8: b := var1^.ts8 <= Getint(Var2, Result);
            btU16: b := var1^.tu16 <= GetUint(Var2, Result);
            btS16: b := var1^.ts16 <= Getint(Var2, Result);
            btU32: b := var1^.tu32 <= GetUint(Var2, Result);
            btS32: b := var1^.ts32 <= Getint(Var2, Result);
            {$IFNDEF IFPS3_NOINT64}btS64: b := var1^.ts64 <= GetInt64(Var2, Result); {$ENDIF}
            btSingle: b := var1^.tsingle <= GetReal( Var2, Result);
            btDouble: b := var1^.tdouble <= GetReal( Var2, Result);
            btExtended: b := var1^.textended <= GetReal( Var2, Result);
            btCurrency: b := var1^.tcurrency <= GetReal( Var2, Result);
            btSet:
              begin
                if (var1.FType = var2.FType) then
                begin
                  Set_Subset(var1.tstring, var2.tstring, TIFPSSetType(var1.FType).ByteSize, b);
                end else Result := False;
              end;
          else
            Result := False;
          end;
          ConvertToBoolean(Self, FUseUsedTypes, Var1, b);
        end;
      otGreater:
        begin { > }
          case Var1.FType.BaseType of
            btU8: b := var1^.tu8 > GetUint(Var2, Result);
            btS8: b := var1^.ts8 > Getint(Var2, Result);
            btU16: b := var1^.tu16 > GetUint(Var2, Result);
            btS16: b := var1^.ts16 > Getint(Var2, Result);
            btU32: b := var1^.tu32 > GetUint(Var2, Result);
            btS32: b := var1^.ts32 > Getint(Var2, Result);
            {$IFNDEF IFPS3_NOINT64}btS64: b := var1^.ts64 > GetInt64(Var2, Result); {$ENDIF}
            btSingle: b := var1^.tsingle > GetReal( Var2, Result);
            btDouble: b := var1^.tdouble > GetReal( Var2, Result);
            btExtended: b := var1^.textended > GetReal( Var2, Result);
            btCurrency: b := var1^.tcurrency > GetReal( Var2, Result);
          else
            Result := False;
          end;
          ConvertToBoolean(Self, FUseUsedTypes, Var1, b);
        end;
      otLess:
        begin { < }
          case Var1.FType.BaseType of
            btU8: b := var1^.tu8 < GetUint(Var2, Result);
            btS8: b := var1^.ts8 < Getint(Var2, Result);
            btU16: b := var1^.tu16 < GetUint(Var2, Result);
            btS16: b := var1^.ts16 < Getint(Var2, Result);
            btU32: b := var1^.tu32 < GetUint(Var2, Result);
            btS32: b := var1^.ts32 < Getint(Var2, Result);
            {$IFNDEF IFPS3_NOINT64}btS64: b := var1^.ts64 < GetInt64(Var2, Result); {$ENDIF}
            btSingle: b := var1^.tsingle < GetReal( Var2, Result);
            btDouble: b := var1^.tdouble < GetReal( Var2, Result);
            btExtended: b := var1^.textended < GetReal( Var2, Result);
            btCurrency: b := var1^.tcurrency < GetReal( Var2, Result);
          else
            Result := False;
          end;
          ConvertToBoolean(Self, FUseUsedTypes, Var1, b);
        end;
      otNotEqual:
        begin { <> }
          case Var1.FType.BaseType of
            btU8: b := var1^.tu8 <> GetUint(Var2, Result);
            btS8: b := var1^.ts8 <> Getint(Var2, Result);
            btU16: b := var1^.tu16 <> GetUint(Var2, Result);
            btS16: b := var1^.ts16 <> Getint(Var2, Result);
            btU32: b := var1^.tu32 <> GetUint(Var2, Result);
            {$IFNDEF IFPS3_NOINT64}btS64: b := var1^.ts64 <> GetInt64(Var2, Result); {$ENDIF}
            btS32: b := var1^.ts32 <> Getint(Var2, Result);
            btSingle: b := var1^.tsingle <> GetReal( Var2, Result);
            btDouble: b := var1^.tdouble <> GetReal( Var2, Result);
            btExtended: b := var1^.textended <> GetReal( Var2, Result);
            btCurrency: b := var1^.tcurrency <> GetReal( Var2, Result);
            btEnum: b := var1^.ts32 <> Getint(Var2, Result);
            btSet:
              begin
                if (var1.FType = var2.FType) then
                begin
                  Set_Equal(var1.tstring, var2.tstring, TIFPSSetType(var1.FType).GetByteSize, b);
                  b := not b;
                end else Result := False;
              end;
          else
            Result := False;
          end;
          ConvertToBoolean(Self, FUseUsedTypes, Var1, b);
        end;
      otEqual:
        begin { = }
          case Var1.FType.BaseType of
            btU8: b := var1^.tu8 = GetUint(Var2, Result);
            btS8: b := var1^.ts8 = Getint(Var2, Result);
            btU16: b := var1^.tu16 = GetUint(Var2, Result);
            btS16: b := var1^.ts16 = Getint(Var2, Result);
            btU32: b := var1^.tu32 = GetUint(Var2, Result);
            btS32: b := var1^.ts32 = Getint(Var2, Result);
            {$IFNDEF IFPS3_NOINT64}btS64: b := var1^.ts64 = GetInt64(Var2, Result); {$ENDIF}
            btSingle: b := var1^.tsingle = GetReal( Var2, Result);
            btDouble: b := var1^.tdouble = GetReal( Var2, Result);
            btExtended: b := var1^.textended = GetReal( Var2, Result);
            btCurrency: b := var1^.tcurrency = GetReal( Var2, Result);
            btEnum: b := var1^.ts32 = Getint(Var2, Result);
            btString: b := tbtstring(var1^.tstring) = GetString(var2, Result);
            btChar: b := var1^.tchar = GetString(var2, Result);
            {$IFNDEF IFPS3_NOWIDESTRING}
            btWideString: b := tbtWideString(var1^.twidestring) = GetWideString(var2, Result);
            btWideChar: b := var1^.twidechar = GetWideString(var2, Result);
            {$ENDIF}
            btSet:
              begin
                if (var1.FType = var2.FType) then
                begin
                  Set_Equal(var1.tstring, var2.tstring, TIFPSSetType(var1.FType).ByteSize, b);
                end else Result := False;
              end;
          else
            Result := False;
          end;
          ConvertToBoolean(Self, FUseUsedTypes, Var1, b);
        end;
      otIn:
        begin
          if (var2.Ftype.BaseType = btset) and (TIFPSSetType(var2).SetType = Var1.FType) then
          begin
            Set_membership(GetUint(var1, result), var2.tstring, b);
          end else Result := False;
        end;
      else
        Result := False;
    end;
  except
    on E: EDivByZero do
    begin
      Result := False;
      MakeError('', ecDivideByZero, '');
      Exit;
    end;
    on E: EZeroDivide do
    begin
      Result := False;
      MakeError('', ecDivideByZero, '');
      Exit;
    end;
    on E: EMathError do
    begin
      Result := False;
      MakeError('', ecMathError, e.Message);
      Exit;
    end;
    on E: Exception do
    begin
      Result := False;
      MakeError('', ecInternalError, E.Message);
      Exit;
    end;
  end;
  if not Result then
  begin
    with MakeError('', ecTypeMismatch, '') do
    begin
      FPosition := Pos;
      FRow := Row;
      FCol := Col;
    end;
  end;
end;

function TIFPSPascalCompiler.IsDuplicate(const s: string; const check: TIFPSDuplicCheck): Boolean;
var
  h, l: Longint;
  x: TIFPSProcedure;
begin
  h := MakeHash(s);
  if (s = 'RESULT') then
  begin
    Result := True;
    exit;
  end;
  if dcTypes in Check then
  for l := FTypes.Count - 1 downto 0 do
  begin
    if (TIFPSType(FTypes.Data[l]).NameHash = h) and
      (TIFPSType(FTypes.Data[l]).Name = s) then
    begin
      Result := True;
      exit;
    end;
  end;

  if dcProcs in Check then
  for l := FProcs.Count - 1 downto 0 do
  begin
    x := FProcs.Data[l];
    if x.ClassType = TIFPSInternalProcedure then
    begin
      if (h = TIFPSInternalProcedure(x).NameHash) and (s = TIFPSInternalProcedure(x).Name) then
      begin
        Result := True;
        exit;
      end;
    end
    else
    begin
      if (TIFPSExternalProcedure(x).RegProc.NameHash = h) and
        (TIFPSExternalProcedure(x).RegProc.Name = s) then
      begin
        Result := True;
        exit;
      end;
    end;
  end;
  if dcVars in Check then
  for l := FVars.Count - 1 downto 0 do
  begin
    if (TIFPSVar(FVars.Data[l]).NameHash = h) and
      (TIFPSVar(FVars.Data[l]).Name = s) then
    begin
      Result := True;
      exit;
    end;
  end;
  if dcConsts in Check then
  for l := FConstants.Count -1 downto 0 do
  begin
    if (TIFPSConstant(FConstants.Data[l]).NameHash = h) and
      (TIFPSConstant(FConstants.Data[l]).Name = s) then
    begin
      Result := TRue;
      exit;
    end;
  end;
  Result := False;
end;

procedure ClearRecSubVals(RecSubVals: TIfList);
var
  I: Longint;
begin
  for I := 0 to RecSubVals.Count - 1 do
    TIFPSRecordFieldTypeDef(RecSubVals[I]).Free;
  RecSubVals.Free;
end;

function TIFPSPascalCompiler.ReadTypeAddProcedure(const Name: string; FParser: TIfPascalParser): TIFPSType;
var
  IsFunction: Boolean;
  VNames: string;
  modifier: TIFPSParameterMode;
  Decl: TIFPSParametersDecl;
  VCType: TIFPSType;
begin
  if FParser.CurrTokenId = CSTII_Function then
    IsFunction := True
  else
    IsFunction := False;
  Decl := TIFPSParametersDecl.Create;
  try
    FParser.Next;
    if FParser.CurrTokenId = CSTI_OpenRound then
    begin
      FParser.Next;
      if FParser.CurrTokenId <> CSTI_CloseRound then
      begin
        while True do
        begin
          if FParser.CurrTokenId = CSTII_Const then
          begin
            Modifier := pmIn;
            FParser.Next;
          end else
          if FParser.CurrTokenId = CSTII_Out then
          begin
            Modifier := pmOut;
            FParser.Next;
          end else
          if FParser.CurrTokenId = CSTII_Var then
          begin
            modifier := pmInOut;
            FParser.Next;
          end
          else
            modifier := pmIn;
          if FParser.CurrTokenId <> CSTI_Identifier then
          begin
            Result := nil;
            if FParser = Self.FParser then
            MakeError('', ecIdentifierExpected, '');
            exit;
          end;
          VNames := FParser.OriginalToken + '|';
          FParser.Next;
          while FParser.CurrTokenId = CSTI_Comma do
          begin
            FParser.Next;
            if FParser.CurrTokenId <> CSTI_Identifier then
            begin
              Result := nil;
              if FParser = Self.FParser then
              MakeError('', ecIdentifierExpected, '');
              exit;
            end;
            VNames := VNames + FParser.GetToken + '|';
            FParser.Next;
          end;
          if FParser.CurrTokenId <> CSTI_Colon then
          begin
            Result := nil;
            if FParser = Self.FParser then
              MakeError('', ecColonExpected, '');
            exit;
          end;
          FParser.Next;
          if FParser.CurrTokenId <> CSTI_Identifier then
          begin
            Result := nil;
            if FParser = self.FParser then
            MakeError('', ecIdentifierExpected, '');
            exit;
          end;
          VCType := FindType(FParser.GetToken);
          if VCType = nil then
          begin
            if FParser = self.FParser then
            MakeError('', ecUnknownIdentifier, FParser.OriginalToken);
            Result := nil;
            exit;
          end;
          while Pos('|', VNames) > 0 do
          begin
            with Decl.AddParam do
            begin
              Mode := modifier;
              OrgName := copy(VNames, 1, Pos('|', VNames) - 1);
              FType := VCType;
            end;
            Delete(VNames, 1, Pos('|', VNames));
          end;
          FParser.Next;
          if FParser.CurrTokenId = CSTI_CloseRound then
            break;
          if FParser.CurrTokenId <> CSTI_Semicolon then
          begin
            if FParser = Self.FParser then
            MakeError('', ecSemicolonExpected, '');
            Result := nil;
            exit;
          end;
          FParser.Next;
        end; {while}
      end; {if}
      FParser.Next;
      end; {if}
      if IsFunction then
      begin
        if FParser.CurrTokenId <> CSTI_Colon then
        begin
          if FParser = Self.FParser then
          MakeError('', ecColonExpected, '');
          Result := nil;
          exit;
        end;
      FParser.Next;
      if FParser.CurrTokenId <> CSTI_Identifier then
      begin
        Result := nil;
        if FParser = Self.FParser then
        MakeError('', ecIdentifierExpected, '');
        exit;
      end;
      VCType := self.FindType(FParser.GetToken);
      if VCType = nil then
      begin
        if FParser = self.FParser then
        MakeError('', ecUnknownIdentifier, FParser.OriginalToken);
        Result := nil;
        exit;
      end;
      FParser.Next;
    end
    else
      VCType := nil;
    Decl.Result := VcType;
    VCType := TIFPSProceduralType.Create;
    VCType.Name := FastUppercase(Name);
    VCType.OriginalName := Name;
    VCType.BaseType := btProcPtr;
    VCType.DeclarePos := FParser.CurrTokenPos;
    VCType.DeclareRow := FParser.Row;
    VCType.DeclareCol := FParser.Col;
    TIFPSProceduralType(VCType).ProcDef.Assign(Decl);
    FTypes.Add(VCType);
    Result := VCType;
  finally
    Decl.Free;
  end;
end; {ReadTypeAddProcedure}


function TIFPSPascalCompiler.ReadType(const Name: string; FParser: TIfPascalParser): TIFPSType; // InvalidVal = Invalid
var
  TypeNo: TIFPSType;
  h, l: Longint;
  FieldName,fieldorgname,s: string;
  RecSubVals: TIfList;
  FArrayStart, FArrayLength: Longint;
  rvv: PIFPSRecordFieldTypeDef;
  p, p2: TIFPSType;
  tempf: PIfRVariant;

begin
  if (FParser.CurrTokenID = CSTII_Function) or (FParser.CurrTokenID = CSTII_Procedure) then
  begin
     Result := ReadTypeAddProcedure(Name, FParser);
     Exit;
  end else if FParser.CurrTokenId = CSTII_Set then
  begin
    FParser.Next;
    if FParser.CurrTokenId <> CSTII_Of then
    begin
      MakeError('', ecOfExpected, '');
      Result := nil;
      Exit;
    end;
    FParser.Next;
    if FParser.CurrTokenID <> CSTI_Identifier then
    begin
      MakeError('', ecIdentifierExpected, '');
      Result := nil;
      exit;
    end;
    TypeNo := FindType(FParser.GetToken);
    if TypeNo = nil then
    begin
      MakeError('', ecUnknownIdentifier, '');
      Result := nil;
      exit;
    end;
    if (TypeNo.BaseType = btEnum) or (TypeNo.BaseType = btChar) or (TypeNo.BaseType = btU8) then
    begin
      FParser.Next;
      p2 := TIFPSSetType.Create;
      p2.Name := FastUppercase(Name);
      p2.OriginalName := Name;
      p2.BaseType := btSet;
      p2.DeclarePos := FParser.CurrTokenPos;
      p2.DeclareRow := FParser.Row;
      p2.DeclareCol := FParser.Col;
      TIFPSSetType(p2).SetType := TypeNo;
      FTypes.Add(p2);
      Result := p2;
    end else
    begin
      MakeError('', ecTypeMismatch, '');
      Result := nil;
    end;
    exit;
  end else if FParser.CurrTokenId = CSTI_OpenRound then
  begin
    FParser.Next;
    L := 0;
    P2 := TIFPSEnumType.Create;
    P2.Name := FastUppercase(Name);
    p2.OriginalName := Name;
    p2.BaseType := btEnum;
    p2.DeclarePos := FParser.CurrTokenPos;
    p2.DeclareRow := FParser.Row;
    p2.DeclareCol := FParser.Col;
    FTypes.Add(p2);

    repeat
      if FParser.CurrTokenId <> CSTI_Identifier then
      begin
        if FParser = Self.FParser then
        MakeError('', ecIdentifierExpected, '');
        Result := nil;
        exit;
      end;
      s := FParser.OriginalToken;
      if IsDuplicate(FastUppercase(s), [dcTypes]) then
      begin
        if FParser = Self.FParser then
        MakeError('', ecDuplicateIdentifier, s);
        Result := nil;
        Exit;
      end;
      AddConstant(s, p2).FValue.tu32 := L;
      Inc(L);
      FParser.Next;
      if FParser.CurrTokenId = CSTI_CloseRound then
        Break
      else if FParser.CurrTokenId <> CSTI_Comma then
      begin
        if FParser = Self.FParser then
        MakeError('', ecCloseRoundExpected, '');
        Result := nil;
        Exit;
      end;
      FParser.Next;
    until False;
    FParser.Next;
    TIFPSEnumType(p2).HighValue := L-1;
    Result := p2;
    exit;
  end else
  if FParser.CurrTokenId = CSTII_Array then
  begin
    FParser.Next;
    if FParser.CurrTokenID = CSTI_OpenBlock then
    begin
      FParser.Next;
      tempf := ReadConstant(FParser, CSTI_TwoDots);
      if tempf = nil then
      begin
        Result := nil;
        exit;
      end;
      case tempf.FType.BaseType of
        btU8: FArrayStart := tempf.tu8;
        btS8: FArrayStart := tempf.ts8;
        btU16: FArrayStart := tempf.tu16;
        btS16: FArrayStart := tempf.ts16;
        btU32: FArrayStart := tempf.tu32;
        btS32: FArrayStart := tempf.ts32;
        {$IFNDEF IFPS3_NOINT64}
        bts64: FArrayStart := tempf.ts64;
        {$ENDIF}
      else
        begin
          DisposeVariant(tempf);
          MakeError('', ecTypeMismatch, '');
          Result := nil;
          exit;
        end;
      end;
      DisposeVariant(tempf);
      if FParser.CurrTokenID <> CSTI_TwoDots then
      begin
        MakeError('', ecPeriodExpected, '');
        Result := nil;
        exit;
      end;
      FParser.Next;
      tempf := ReadConstant(FParser, CSTI_CloseBlock);
      if tempf = nil then
      begin
        Result := nil;
        exit;
      end;
      case tempf.FType.BaseType of
        btU8: FArrayLength := tempf.tu8;
        btS8: FArrayLength := tempf.ts8;
        btU16: FArrayLength := tempf.tu16;
        btS16: FArrayLength := tempf.ts16;
        btU32: FArrayLength := tempf.tu32;
        btS32: FArrayLength := tempf.ts32;
        {$IFNDEF IFPS3_NOINT64}
        bts64: FArrayLength := tempf.ts64;
        {$ENDIF}
      else
        DisposeVariant(tempf);
        MakeError('', ecTypeMismatch, '');
        Result := nil;
        exit;
      end;
      DisposeVariant(tempf);
      FArrayLength := FArrayLength - FArrayStart + 1;
      if (FArrayLength < 0) or (FArrayLength > MaxInt div 4) then
      begin
        MakeError('', ecTypeMismatch, '');
        Result := nil;
        exit;
      end;
      if FParser.CurrTokenID <> CSTI_CloseBlock then
      begin
        MakeError('', ecCloseBlockExpected, '');
        Result := nil;
        exit;
      end;
      FParser.Next;
    end else
    begin
      FArrayStart := 0;
      FArrayLength := -1;
    end;
    if FParser.CurrTokenId <> CSTII_Of then
    begin
      if FParser = Self.FParser then
      MakeError('', ecOfExpected, '');
      Result := nil;
      exit;
    end;
    FParser.Next;
    TypeNo := ReadType('', FParser);
    if TypeNo = nil then
    begin
      if FParser = Self.FParser then
      MakeError('', ecUnknownIdentifier, '');
      Result := nil;
      exit;
    end;
    if (Name = '') and (FArrayLength = -1) then
    begin
      if TypeNo.Used then
      begin
        for h := 0 to FTypes.Count -1 do
        begin
          p := FTypes[H];
          if (p.BaseType = btArray) and (TIFPSArrayType(p).ArrayTypeNo = TypeNo) and (Copy(p.Name, 1, 1) <> '!') then
          begin
            Result := p;
            exit;
          end;
        end;
      end;
    end;
    if FArrayLength <> -1 then
    begin
      p := TIFPSStaticArrayType.Create;
      TIFPSStaticArrayType(p).StartOffset := FArrayStart;
      TIFPSStaticArrayType(p).Length := FArrayLength;
      p.BaseType := btStaticArray;
    end else
    begin
      p := TIFPSArrayType.Create;
      p.BaseType := btArray;
    end;
    p.Name := FastUppercase(Name);
    p.OriginalName := Name;
    p.DeclarePos := FParser.CurrTokenPos;
    p.DeclareRow := FParser.Row;
    p.DeclareCol := FParser.Col;
    TIFPSArrayType(p).ArrayTypeNo := TypeNo;
    FTypes.Add(p);
    Result := p;
    Exit;
  end
  else if FParser.CurrTokenId = CSTII_Record then
  begin
    FParser.Next;
    RecSubVals := TIfList.Create;
    repeat
      repeat
        if FParser.CurrTokenId <> CSTI_Identifier then
        begin
          ClearRecSubVals(RecSubVals);
          if FParser = Self.FParser then
          MakeError('', ecIdentifierExpected, '');
          Result := nil;
          exit;
        end;
        FieldName := FParser.GetToken;
        s := S+FParser.OriginalToken+'|';
        FParser.Next;
        h := MakeHash(FieldName);
        for l := 0 to RecSubVals.Count - 1 do
        begin
          if (PIFPSRecordFieldTypeDef(RecSubVals[l]).FieldNameHash = h) and
            (PIFPSRecordFieldTypeDef(RecSubVals[l]).FieldName = FieldName) then
          begin
            if FParser = Self.FParser then
              MakeError('', ecDuplicateIdentifier, FParser.OriginalToken);
            ClearRecSubVals(RecSubVals);
            Result := nil;
            exit;
          end;
        end;
        if FParser.CurrTokenID = CSTI_Colon then Break else
        if FParser.CurrTokenID <> CSTI_Comma then
        begin
          if FParser = Self.FParser then
            MakeError('', ecColonExpected, '');
          ClearRecSubVals(RecSubVals);
          Result := nil;
          exit;
        end;
        FParser.Next;
      until False;
      FParser.Next;
      p := ReadType('', FParser);
      if p = nil then
      begin
        ClearRecSubVals(RecSubVals);
        Result := nil;
        exit;
      end;
      p := GetTypeCopyLink(p);
      if FParser.CurrTokenId <> CSTI_Semicolon then
      begin
        ClearRecSubVals(RecSubVals);
        if FParser = Self.FParser then
        MakeError('', ecSemicolonExpected, '');
        Result := nil;
        exit;
      end; {if}
      FParser.Next;
      while Pos('|', s) > 0 do
      begin
        fieldorgname := copy(s, 1, pos('|', s)-1);
        Delete(s, 1, length(FieldOrgName)+1);
        rvv := TIFPSRecordFieldTypeDef.Create;
        rvv.FieldOrgName := fieldorgname;
        rvv.FType := p;
        RecSubVals.Add(rvv);
      end;
    until FParser.CurrTokenId = CSTII_End;
    FParser.Next; // skip CSTII_End
    P := TIFPSRecordType.Create;
    p.Name := FastUppercase(Name);
    p.OriginalName := Name;
    p.BaseType := btRecord;
    p.DeclarePos := FParser.CurrTokenPos;
    p.DeclareRow := FParser.Row;
    p.DeclareCol := FParser.Col;
    for l := 0 to RecSubVals.Count -1 do
    begin
      rvv := RecSubVals[l];
      with TIFPSRecordType(p).AddRecVal do
      begin
        FieldOrgName := rvv.FieldOrgName;
        FType := rvv.FType;
      end;
      rvv.Free;
    end;
    RecSubVals.Free;
    FTypes.Add(p);
    Result := p;
    Exit;
  end else if FParser.CurrTokenId = CSTI_Identifier then
  begin
    s := FParser.GetToken;
    h := MakeHash(s);
    Typeno := nil;
    for l := 0 to FTypes.Count - 1 do
    begin
      p2 := FTypes[l];
      if (p2.NameHash = h) and (p2.Name = s) then
      begin
        FParser.Next;
        Typeno := GetTypeCopyLink(p2);
        Break;
      end;
    end;
    if Typeno = nil then
    begin
      Result := nil;
      if FParser = Self.FParser then
      MakeError('', ecUnknownType, FParser.OriginalToken);
      exit;
    end;
    if Name <> '' then
    begin
      p := TIFPSTypeLink.Create;
      p.Name := FastUppercase(Name);
      p.OriginalName := Name;
      p.BaseType := BtTypeCopy;
      p.DeclarePos := FParser.CurrTokenPos;
      p.DeclareRow := FParser.Row;
      p.DeclareCol := FParser.Col;
      TIFPSTypeLink(p).LinkTypeNo := TypeNo;
      FTypes.Add(p);
      Result := p;
      Exit;
    end else
    begin
      Result := TypeNo;
      exit;
    end;
  end;
  Result := nil;
  if FParser = Self.FParser then
  MakeError('', ecIdentifierExpected, '');
  Exit;
end;

function TIFPSPascalCompiler.VarIsDuplicate(Proc: TIFPSInternalProcedure; const Varnames, s: string): Boolean;
var
  h, l: Longint;
  x: TIFPSProcedure;
  v: string;
begin
  h := MakeHash(s);
  if (s = 'RESULT') then
  begin
    Result := True;
    exit;
  end;

  for l := FProcs.Count - 1 downto 0 do
  begin
    x := FProcs.Data[l];
    if x.ClassType = TIFPSInternalProcedure then
    begin
      if (h = TIFPSInternalProcedure(x).NameHash) and (s = TIFPSInternalProcedure(x).Name) then
      begin
        Result := True;
        exit;
      end;
    end
    else
    begin
      if (TIFPSExternalProcedure(x).RegProc.NameHash = h) and (TIFPSExternalProcedure(x).RegProc.Name = s) then
      begin
        Result := True;
        exit;
      end;
    end;
  end;
  if proc <> nil then
  begin
    for l := proc.ProcVars.Count - 1 downto 0 do
    begin
      if (PIFPSProcVar(proc.ProcVars.Data[l]).NameHash = h) and
        (TIFPSVar(proc.ProcVars.Data[l]).Name = s) then
      begin
        Result := True;
        exit;
      end;
    end;
    for l := Proc.FDecl.ParamCount -1 downto 0 do
    begin
      if (Proc.FDecl.Params[l].Name = s) then
      begin
        Result := True;
        exit;
      end;
    end;
  end
  else
  begin
    for l := FVars.Count - 1 downto 0 do
    begin
      if (TIFPSVar(FVars.Data[l]).NameHash = h) and
        (TIFPSVar(FVars.Data[l]).Name = s) then
      begin
        Result := True;
        exit;
      end;
    end;
  end;
  v := VarNames;
  while Pos('|', v) > 0 do
  begin
    if copy(v, 1, Pos('|', v) - 1) = s then
    begin
      Result := True;
      exit;
    end;
    Delete(v, 1, Pos('|', v));
  end;
  for l := FConstants.Count -1 downto 0 do
  begin
    if (TIFPSConstant(FConstants.Data[l]).NameHash = h) and
      (TIFPSConstant(FConstants.Data[l]).Name = s) then
    begin
      Result := True;
      exit;
    end;
  end;
  Result := False;
end;


function TIFPSPascalCompiler.DoVarBlock(proc: TIFPSInternalProcedure): Boolean;
var
  VarName, s: string;
  VarType: TIFPSType;
  VarNo: Cardinal;
  v: TIFPSVar;
  vp: PIFPSProcVar;

begin
  Result := False;
  FParser.Next; // skip CSTII_Var
  if FParser.CurrTokenId <> CSTI_Identifier then
  begin
    MakeError('', ecIdentifierExpected, '');
    exit;
  end;
  repeat
    if VarIsDuplicate(proc, VarName, FParser.GetToken) then
    begin
      MakeError('', ecDuplicateIdentifier, FParser.OriginalToken);
      exit;
    end;
    VarName := FParser.OriginalToken + '|';
    Varno := 0;
    if @FOnUseVariable <> nil then
    begin
      if Proc <> nil then
        FOnUseVariable(Self, ivtVariable, Proc.ProcVars.Count + VarNo, FProcs.Count -1, FParser.CurrTokenPos, '')
      else
        FOnUseVariable(Self, ivtGlobal, FVars.Count + VarNo, InvalidVal, FParser.CurrTokenPos, '')
    end;
    FParser.Next;
    while FParser.CurrTokenId = CSTI_Comma do
    begin
      FParser.Next;
      if FParser.CurrTokenId <> CSTI_Identifier then
      begin
        MakeError('', ecIdentifierExpected, '');
      end;
      if VarIsDuplicate(proc, VarName, FParser.GetToken) then
      begin
        MakeError('', ecDuplicateIdentifier, FParser.OriginalToken);
        exit;
      end;
      VarName := VarName + FParser.OriginalToken + '|';
      Inc(varno);
      if @FOnUseVariable <> nil then
      begin
        if Proc <> nil then
          FOnUseVariable(Self, ivtVariable, Proc.ProcVars.Count + VarNo, FProcs.Count -1, FParser.CurrTokenPos, '')
        else
          FOnUseVariable(Self, ivtGlobal, FVars.Count + VarNo, InvalidVal, FParser.CurrTokenPos, '')
      end;
      FParser.Next;
    end;
    if FParser.CurrTokenId <> CSTI_Colon then
    begin
      MakeError('', ecColonExpected, '');
      exit;
    end;
    FParser.Next;
    VarType := at2ut(ReadType('', FParser));
    if VarType = nil then
    begin
      exit;
    end;
    while Pos('|', VarName) > 0 do
    begin
      s := copy(VarName, 1, Pos('|', VarName) - 1);
      Delete(VarName, 1, Pos('|', VarName));
      if proc = nil then
      begin
        v := TIFPSVar.Create;
        v.OrgName := s;
        v.Name := FastUppercase(s);
        v.DeclarePos := FParser.CurrTokenPos;
        v.DeclareRow := FParser.Row;
        v.DeclareCol := FParser.Col;
        v.FType := VarType;
        FVars.Add(v);
      end
      else
      begin
        vp := TIFPSProcVar.Create;
        vp.OrgName := s;
        vp.Name := FastUppercase(s);
        vp.aType := VarType;
        vp.DeclarePos := FParser.CurrTokenPos;
        vp.DeclareRow := FParser.Row;
        vp.DeclareCol := FParser.Col;
        proc.ProcVars.Add(vp);
      end;
    end;
    if FParser.CurrTokenId <> CSTI_Semicolon then
    begin
      MakeError('', ecSemicolonExpected, '');
      exit;
    end;
    FParser.Next;
  until FParser.CurrTokenId <> CSTI_Identifier;
  Result := True;
end;

function TIFPSPascalCompiler.NewProc(const OriginalName, Name: string): TIFPSInternalProcedure;
begin
  Result := TIFPSInternalProcedure.Create;
  Result.OriginalName := OriginalName;
  Result.Name := Name;
  Result.DeclarePos := FParser.CurrTokenPos;
  Result.DeclareRow := FParser.Row;
  Result.DeclareCol := FParser.Col;
  FProcs.Add(Result);
end;

function TIFPSPascalCompiler.IsProcDuplicLabel(Proc: TIFPSInternalProcedure; const s: string): Boolean;
var
  i: Longint;
  h: Longint;
  u: string;
begin
  h := MakeHash(s);
  if s = 'RESULT' then
    Result := True
  else if Proc.Name = s then
    Result := True
  else if IsDuplicate(s, [dcVars, dcConsts, dcProcs]) then
    Result := True
  else
  begin
    for i := 0 to Proc.Decl.ParamCount -1 do
    begin
      if Proc.Decl.Params[i].Name = s then
      begin
        Result := True;
        exit;
      end;
    end;
    for i := 0 to Proc.ProcVars.Count -1 do
    begin
      if (PIFPSProcVar(Proc.ProcVars[I]).NameHash = h) and (PIFPSProcVar(Proc.ProcVars[I]).Name = s) then
      begin
        Result := True;
        exit;
      end;
    end;
    for i := 0 to Proc.FLabels.Count -1 do
    begin
      u := Proc.FLabels[I];
      delete(u, 1, 4);
      if Longint((@u[1])^) = h then
      begin
        delete(u, 1, 4);
        if u = s then
        begin
          Result := True;
          exit;
        end;
      end;
    end;
    Result := False;
  end;
end;


function TIFPSPascalCompiler.ProcessLabel(Proc: TIFPSInternalProcedure): Boolean;
var
  CurrLabel: string;
begin
  FParser.Next;
  while true do
  begin
    if FParser.CurrTokenId <> CSTI_Identifier then
    begin
      MakeError('', ecIdentifierExpected, '');
      Result := False;
      exit;
    end;
    CurrLabel := FParser.GetToken;
    if IsProcDuplicLabel(Proc, CurrLabel) then
    begin
      MakeError('', ecDuplicateIdentifier, CurrLabel);
      Result := False;
      exit;
    end;
    FParser.Next;
    Proc.FLabels.Add(#$FF#$FF#$FF#$FF+IFPS3_mi2s(MakeHash(CurrLabel))+CurrLabel);
    if FParser.CurrTokenId = CSTI_Semicolon then
    begin
      FParser.Next;
      Break;
    end;
    if FParser.CurrTokenId <> CSTI_Comma then
    begin
      MakeError('', ecCommaExpected, '');
      Result := False;
      exit;
    end;
    FParser.Next;
  end;
  Result := True;
end;

procedure TIFPSPascalCompiler.Debug_SavePosition(ProcNo: Cardinal; Proc: TIFPSInternalProcedure);
var
  Row,
  Col,
  Pos: Cardinal;
  s: string;
begin
  Row := FParser.Row;
  Col := FParser.Col;
  Pos := FParser.CurrTokenPos;
  s := '';
  if @FOnTranslateLineInfo <> nil then
    FOnTranslateLineInfo(Self, Pos, Row, Col, S);
  WriteDebugData(#4 + s + #1 + IFPS3_mi2s(ProcNo) + IFPS3_mi2s(Length(Proc.Data)) + IFPS3_mi2s(Pos) + IFPS3_mi2s(Row)+ IFPS3_mi2s(Col));
end;

procedure TIFPSPascalCompiler.Debug_WriteParams(ProcNo: Cardinal; Proc: TIFPSInternalProcedure);
var
  I: Longint;
  s: string;
begin
  s := #2 + IFPS3_mi2s(ProcNo);
  if Proc.Decl.Result <> nil then
  begin
    s := s + 'Result' + #1;
  end;
  for i := 0 to Proc.Decl.ParamCount -1 do
    s := s + Proc.Decl.Params[i].OrgName + #1;
  s := s + #0#3 + IFPS3_mi2s(ProcNo);
  for I := 0 to Proc.ProcVars.Count - 1 do
  begin
    s := s + PIFPSProcVar(Proc.ProcVars[I]).OrgName + #1;
  end;
  s := s + #0;
  WriteDebugData(s);
end;

procedure TIFPSPascalCompiler.CheckForUnusedVars(Func: TIFPSInternalProcedure);
var
  i: Integer;
  p: PIFPSProcVar;
begin
  for i := 0 to Func.ProcVars.Count -1 do
  begin
    p := Func.ProcVars[I];
    if not p.Used then
    begin
      with MakeHint('', ehVariableNotUsed, p.Name) do
      begin
        FRow := p.DeclareRow;
        FCol := p.DeclareCol;
        FPosition := p.DeclarePos;
      end;
    end;
  end;
  if (not Func.ResultUsed) and (Func.Decl.Result <> nil) then
  begin
      with MakeHint('', ehVariableNotUsed, 'Result') do
      begin
        FRow := Func.DeclareRow;
        FCol := Func.DeclareCol;
        FPosition := Func.DeclarePos;
      end;
  end;
end;

function TIFPSPascalCompiler.ProcIsDuplic(Decl: TIFPSParametersDecl; const FunctionName, FunctionParamNames: string; const s: string; Func: TIFPSInternalProcedure): Boolean;
var
  i: Longint;
  u: string;
begin
  if s = 'RESULT' then
    Result := True
  else if FunctionName = s then
    Result := True
  else
  begin
    for i := 0 to Decl.ParamCount -1 do
    begin
      if Decl.Params[i].Name = s then
      begin
        Result := True;
        exit;
      end;
      GRFW(u);
    end;
    u := FunctionParamNames;
    while Pos('|', u) > 0 do
    begin
      if copy(u, 1, Pos('|', u) - 1) = s then
      begin
        Result := True;
        exit;
      end;
      Delete(u, 1, Pos('|', u));
    end;
    if Func = nil then
    begin
      result := False;
      exit;
    end;
    for i := 0 to Func.ProcVars.Count -1 do
    begin
      if s = PIFPSProcVar(Func.ProcVars[I]).Name then
      begin
        Result := True;
        exit;
      end;
    end;
    for i := 0 to Func.FLabels.Count -1 do
    begin
      u := Func.FLabels[I];
      delete(u, 1, 4);
      if u = s then
      begin
        Result := True;
        exit;
      end;
    end;
    Result := False;
  end;
end;
procedure WriteProcVars(Func:TIFPSInternalProcedure; t: TIfList);
var
  l: Longint;
  v: PIFPSProcVar;
begin
  for l := 0 to t.Count - 1 do
  begin
    v := t[l];
    Func.Data := Func.Data  + chr(cm_pt)+ IFPS3_mi2s(v.AType.FinalTypeNo);
  end;
end;


function TIFPSPascalCompiler.ApplyAttribsToFunction(func: TIFPSProcedure): boolean;
var
  i: Longint;
begin
  for i := 0 to Func.Attributes.Count -1 do
  begin
    if @Func.Attributes.Items[i].AType.OnApplyAttributeToProc <> nil then
    begin
      if not Func.Attributes.Items[i].AType.OnApplyAttributeToProc(Self, Func, Func.Attributes.Items[i]) then
      begin
        Result := false;
        exit;
      end;
    end;
  end;
  result := true;
end;


function TIFPSPascalCompiler.ProcessFunction(AlwaysForward: Boolean; Att: TIFPSAttributes): Boolean;
var
  FunctionType: TFuncType;
  OriginalName, FunctionName: string;
  FunctionParamNames: string;
  FunctionTempType: TIFPSType;
  ParamNo: Cardinal;
  FunctionDecl: TIFPSParametersDecl;
  modifier: TIFPSParameterMode;
  Func: TIFPSInternalProcedure;
  F2: TIFPSProcedure;
  EPos, ECol, ERow: Cardinal;
  pp: TIFPSRegProc;
  pp2: TIFPSExternalProcedure;
  FuncNo, I: Longint;
  Block: TIFPSBlockInfo;

begin
  if att = nil then
  begin
    Att := TIFPSAttributes.Create;
    if not ReadAttributes(Att) then
    begin
      att.free;
      Result := false;
      exit;
    end;
  end;

  if FParser.CurrTokenId = CSTII_Procedure then
    FunctionType := ftProc
  else
    FunctionType := ftFunc;
  Func := nil;
  FParser.Next;
  Result := False;
  if FParser.CurrTokenId <> CSTI_Identifier then
  begin
    MakeError('', ecIdentifierExpected, '');
    att.free;
    exit;
  end;
  EPos := FParser.CurrTokenPos;
  ERow := FParser.Row;
  ECol := FParser.Row;
  OriginalName := FParser.OriginalToken;
  FunctionName := FParser.GetToken;
  FuncNo := -1;
  for i := 0 to FProcs.Count -1 do
  begin
    f2 := FProcs[I];
    if (f2.ClassType = TIFPSInternalProcedure) and (TIFPSInternalProcedure(f2).Name = FunctionName) and (TIFPSInternalProcedure(f2).Forwarded) then
    begin
      Func := FProcs[I];
      FuncNo := i;
      Break;
    end;
  end;
  if (Func = nil) and IsDuplicate(FunctionName, [dcTypes, dcProcs, dcVars, dcConsts]) then
  begin
    att.free;
    MakeError('', ecDuplicateIdentifier, FunctionName);
    exit;
  end;
  FParser.Next;
  FunctionDecl := TIFPSParametersDecl.Create;
  try
    if FParser.CurrTokenId = CSTI_OpenRound then
    begin
      FParser.Next;
      if FParser.CurrTokenId = CSTI_CloseRound then
      begin
        FParser.Next;
      end
      else
      begin
        if FunctionType = ftFunc then
          ParamNo := 1
        else
          ParamNo := 0;
        while True do
        begin
          if FParser.CurrTokenId = CSTII_Const then
          begin
            modifier := pmIn;
            FParser.Next;
          end
          else
          if FParser.CurrTokenId = CSTII_Out then
          begin
            modifier := pmOut;
            FParser.Next;
          end
          else
          if FParser.CurrTokenId = CSTII_Var then
          begin
            modifier := pmInOut;
            FParser.Next;
          end
          else
            modifier := pmIn;
          if FParser.CurrTokenId <> CSTI_Identifier then
          begin
            MakeError('', ecIdentifierExpected, '');
            exit;
          end;
          if ProcIsDuplic(FunctionDecl, FunctionName, FunctionParamNames, FParser.GetToken, Func) then
          begin
            MakeError('', ecDuplicateIdentifier, FParser.OriginalToken);
            exit;
          end;
          FunctionParamNames := FParser.OriginalToken + '|';
          if @FOnUseVariable <> nil then
          begin
            FOnUseVariable(Self, ivtParam, ParamNo, FProcs.Count, FParser.CurrTokenPos, '');
          end;
          inc(ParamNo);
          FParser.Next;
          while FParser.CurrTokenId = CSTI_Comma do
          begin
            FParser.Next;
            if FParser.CurrTokenId <> CSTI_Identifier then
            begin
              MakeError('', ecIdentifierExpected, '');
              exit;
            end;
          if ProcIsDuplic(FunctionDecl, FunctionName, FunctionParamNames, FParser.GetToken, Func) then
            begin
              MakeError('', ecDuplicateIdentifier, '');
              exit;
            end;
            if @FOnUseVariable <> nil then
            begin
              FOnUseVariable(Self, ivtParam, ParamNo, FProcs.Count, FParser.CurrTokenPos, '');
            end;
            inc(ParamNo);
            FunctionParamNames := FunctionParamNames + FParser.OriginalToken +
              '|';
            FParser.Next;
          end;
          if FParser.CurrTokenId <> CSTI_Colon then
          begin
            MakeError('', ecColonExpected, '');
            exit;
          end;
          FParser.Next;
          FunctionTempType := at2ut(ReadType('', FParser));
          if FunctionTempType = nil then
          begin
            exit;
          end;
          while Pos('|', FunctionParamNames) > 0 do
          begin
            with FunctionDecl.AddParam do
            begin
              OrgName := copy(FunctionParamNames, 1, Pos('|', FunctionParamNames) - 1);
              Mode := modifier;
              aType := FunctionTempType;
            end;
            Delete(FunctionParamNames, 1, Pos('|', FunctionParamNames));
          end;
          if FParser.CurrTokenId = CSTI_CloseRound then
            break;
          if FParser.CurrTokenId <> CSTI_Semicolon then
          begin
            MakeError('', ecSemicolonExpected, '');
            exit;
          end;
          FParser.Next;
        end;
        FParser.Next;
      end;
    end;
    if FunctionType = ftFunc then
    begin
      if FParser.CurrTokenId <> CSTI_Colon then
      begin
        MakeError('', ecColonExpected, '');
        exit;
      end;
      FParser.Next;
      FunctionTempType := at2ut(ReadType('', FParser));
      if FunctionTempType = nil then
        exit;
      FunctionDecl.Result := FunctionTempType;
    end;
    if FParser.CurrTokenId <> CSTI_Semicolon then
    begin
      MakeError('', ecSemicolonExpected, '');
      exit;
    end;
    FParser.Next;
    if (Func = nil) and (FParser.CurrTokenID = CSTII_External) then
    begin
      FParser.Next;
      if FParser.CurrTokenID <> CSTI_String then
      begin
        MakeError('', ecStringExpected, '');
        exit;
      end;
      FunctionParamNames := FParser.GetToken;
      FunctionParamNames := copy(FunctionParamNames, 2, length(FunctionParamNames) - 2);
      FParser.Next;
      if FParser.CurrTokenID <> CSTI_Semicolon then
      begin
        MakeError('', ecSemicolonExpected, '');
        exit;
      end;
      FParser.Next;
      if @FOnExternalProc = nil then
      begin
        MakeError('', ecSemicolonExpected, '');
        exit;
      end;
      pp := FOnExternalProc(Self, FunctionDecl, FunctionName, FunctionParamNames);
      if pp = nil then
      begin
        MakeError('', ecCustomError, '');
        exit;
      end;
      pp2 := TIFPSExternalProcedure.Create;
      pp2.Attributes.Assign(att, true);
      pp2.RegProc := pp;
      FProcs.Add(pp2);
      FRegProcs.Add(pp);
      Result := ApplyAttribsToFunction(pp2);
      Exit;
    end else if (FParser.CurrTokenID = CSTII_Forward) or AlwaysForward then
    begin
      if Func <> nil then
      begin
        MakeError('', ecBeginExpected, '');
        exit;
      end;
      if not AlwaysForward then
      begin
        FParser.Next;
        if FParser.CurrTokenID  <> CSTI_Semicolon then
        begin
          MakeError('', ecSemicolonExpected, '');
          Exit;
        end;
        FParser.Next;
      end;
      Func := NewProc(OriginalName, FunctionName);
      Func.Attributes.Assign(Att, True);
      Func.Forwarded := True;
      Func.FDeclarePos := EPos;
      Func.FDeclareRow := ERow;
      Func.FDeclarePos := ECol;
      Func.Decl.Assign(FunctionDecl);
      Result := ApplyAttribsToFunction(Func);
      exit;
    end;
    if (Func = nil) then
    begin
      Func := NewProc(OriginalName, FunctionName);
      Func.Attributes.Assign(att, True);
      Func.Decl.Assign(FunctionDecl);
      Func.FDeclarePos := EPos;
      Func.FDeclareRow := ERow;
      Func.FDeclareCol := ECol;
      FuncNo := FProcs.Count -1;
      if not ApplyAttribsToFunction(Func) then
      begin
        result := false;
        exit;
      end;
    end else begin
      if not FunctionDecl.Same(Func.Decl) then
      begin
        MakeError('', ecForwardParameterMismatch, '');
        Result := false;
        exit;
      end;
      Func.Forwarded := False;
    end;
    if FParser.CurrTokenID = CSTII_Export then
    begin
      FParser.Next;
      if FParser.CurrTokenID <> CSTI_Semicolon then
      begin
        MakeError('', ecSemicolonExpected, '');
        exit;
      end;
      FParser.Next;
    end;
    while FParser.CurrTokenId <> CSTII_Begin do
    begin
      if FParser.CurrTokenId = CSTII_Var then
      begin
        if not DoVarBlock(Func) then
          exit;
      end else if FParser.CurrTokenId = CSTII_Label then
      begin
        if not ProcessLabel(Func) then
          Exit;
      end else
      begin
        MakeError('', ecBeginExpected, '');
        exit;
      end;
    end;
    Debug_WriteParams(FuncNo, Func);
    WriteProcVars(Func, Func.ProcVars);
    Block := TIFPSBlockInfo.Create(FGlobalBlock);
    Block.SubType := tProcBegin;
    Block.ProcNo := FuncNo;
    Block.Proc := Func;
    if not ProcessSub(Block) then
    begin
      Block.Free;
      exit;
    end;
    Block.Free;
    CheckForUnusedVars(Func);
    Result := ProcessLabelForwards(Func);
  finally
    FunctionDecl.Free;
    att.Free;
  end;
end;

function GetParamType(BlockInfo: TIFPSBlockInfo; I: Longint): TIFPSType;
begin
  if BlockInfo.Proc.Decl.Result <> nil then dec(i);
  if i = -1 then
    Result := BlockInfo.Proc.Decl.Result
  else
  begin
    Result := BlockInfo.Proc.Decl.Params[i].aType;
  end;
end;

function TIFPSPascalCompiler.GetTypeNo(BlockInfo: TIFPSBlockInfo; p: TIFPSValue): TIFPSType;
begin
  if p.ClassType = TIFPSUnValueOp then
    Result := TIFPSUnValueOp(p).aType
  else if p.ClassType = TIFPSBinValueOp then
    Result := TIFPSBinValueOp(p).aType
  else if p.ClassType = TIFPSValueArray then
    Result := at2ut(FindType('TVariantArray'))
  else if p.ClassType = TIFPSValueData then
    Result := TIFPSValueData(p).Data.FType
  else if p is TIFPSValueProc then
    Result := TIFPSValueProc(p).ResultType
  else if (p is TIFPSValueVar) and (TIFPSValueVar(p).RecCount > 0) then
    Result := TIFPSValueVar(p).RecItem[TIFPSValueVar(p).RecCount - 1].aType
  else if p.ClassType = TIFPSValueGlobalVar then
    Result := TIFPSVar(FVars[TIFPSValueGlobalVar(p).GlobalVarNo]).FType
  else if p.ClassType = TIFPSValueParamVar then
    Result := GetParamType(BlockInfo, TIFPSValueParamVar(p).ParamNo)
  else if p is TIFPSValueLocalVar then
    Result := TIFPSProcVar(BlockInfo.Proc.ProcVars[TIFPSValueLocalVar(p).LocalVarNo]).AType
  else if p.classtype = TIFPSValueReplace then
    Result := GetTypeNo(BlockInfo, TIFPSValueReplace(p).NewValue)
  else
    Result := nil;
end;

function TIFPSPascalCompiler.IsVarInCompatible(ft1, ft2: TIFPSType): Boolean;
begin
  ft1 := GetTypeCopyLink(ft1);
  ft2 := GetTypeCopyLink(ft2);
  Result := (ft1 <> ft2);
end;

function TIFPSPascalCompiler.ValidateParameters(BlockInfo: TIFPSBlockInfo; Params: TIFPSParameters; ParamTypes: TIFPSParametersDecl): boolean;
var
  i, c: Longint;
  pType: TIFPSType;



begin
  UseProc(ParamTypes);
  c := 0;
  for i := 0 to ParamTypes.ParamCount -1 do
  begin
    while (c < Longint(Params.Count)) and (Params[c].Val = nil) do
      Inc(c);
    if c >= Longint(Params.Count) then
    begin
      MakeError('', ecInvalidnumberOfParameters, '');
      Result := False;
      exit;
    end;
    Params[c].ExpectedType := ParamTypes.Params[i].aType;
    Params[c].ParamMode := ParamTypes.Params[i].Mode;
    if ParamTypes.Params[i].Mode <> pmIn then
    begin
      if not (Params[c].Val is TIFPSValueVar) then
      begin
        with MakeError('', ecVariableExpected, '') do
        begin
          Row := Params[c].Val.Row;
          Col := Params[c].Val.Col;
          Pos := Params[c].Val.Pos;
        end;
        PType := Params[c].ExpectedType;
        if (PType = nil) or ((PType.BaseType = btArray) and (TIFPSArrayType(PType).ArrayTypeNo = nil) and (GetTypeNo(BlockInfo, Params[c].Val).BaseType = btArray)) then
        begin
          Params[c].ExpectedType := GetTypeNo(BlockInfo, Params[c].Val);
        end else if (PType.BaseType = btArray) and (GetTypeNo(BlockInfo, Params[c].Val).BaseType = btArray) then
        begin
          if TIFPSArrayType(GetTypeNo(BlockInfo, Params[c].Val)).ArrayTypeNo <> TIFPSArrayType(PType).ArrayTypeNo then
          begin
            MakeError('', ecTypeMismatch, '');
            Result := False;
            exit;
          end;
        end else if IsVarInCompatible(PType, GetTypeNo(BlockInfo, Params[c].Val)) then
        begin
          MakeError('', ecTypeMismatch, '');
          Result := False;
          exit;
        end;
      end;
    end;
    Inc(c);
  end;
  for i := c to Params.Count -1 do
  begin
    if Params[i].Val <> nil then
    begin
      MakeError('', ecInvalidnumberOfParameters, '');
      Result := False;
      exit;
    end;
  end;
  Result := true;
end;

function TIFPSPascalCompiler.DoTypeBlock(FParser: TIfPascalParser): Boolean;
var
  VOrg,VName: string;
  Attr: TIFPSAttributes;
  FType: TIFPSType;
  i: Longint;
begin
  Result := False;
  FParser.Next;
  repeat
    Attr := TIFPSAttributes.Create;
    if not ReadAttributes(Attr) then
    begin
      Attr.Free;
      exit;
    end;
    if (FParser.CurrTokenID = CSTII_Procedure) or (FParser.CurrTokenID = CSTII_Function) then
    begin
      Result := ProcessFunction(false, Attr);
      exit;
    end;
    if FParser.CurrTokenId <> CSTI_Identifier then
    begin
      MakeError('', ecIdentifierExpected, '');
      Attr.Free;
      exit;
    end;

    VName := FParser.GetToken;
    VOrg := FParser.OriginalToken;
    if IsDuplicate(VName, [dcTypes, dcProcs, dcVars]) then
    begin
      MakeError('', ecDuplicateIdentifier, FParser.OriginalToken);
      Attr.Free;
      exit;
    end;

    FParser.Next;
    if FParser.CurrTokenId <> CSTI_Equal then
    begin
      MakeError('', ecIsExpected, '');
      Attr.Free;
      exit;
    end;
    FParser.Next;
    FType := ReadType(VOrg, FParser);
    if Ftype = nil then
    begin
      Attr.Free;
      Exit;
    end;
    FType.Attributes.Assign(Attr, True);
    for i := 0 to FType.Attributes.Count -1 do
    begin
      if @FType.Attributes[i].FAttribType.FAAType <> nil then
        FType.Attributes[i].FAttribType.FAAType(Self, FType, Attr[i]);
    end;
    Attr.Free;
    if FParser.CurrTokenID <> CSTI_Semicolon then
    begin
      MakeError('', ecSemicolonExpected, '');
      Exit;
    end;
    FParser.Next;
  until (FParser.CurrTokenId <> CSTI_Identifier) and (FParser.CurrTokenID <> CSTI_OpenBlock);
  Result := True;
end;

procedure TIFPSPascalCompiler.Debug_WriteLine(BlockInfo: TIFPSBlockInfo);
var
  b: Boolean;
begin
  if @FOnWriteLine <> nil then begin
    b := FOnWriteLine(Self, FParser.CurrTokenPos);
  end else
    b := true;
  if b then Debug_SavePosition(BlockInfo.ProcNo, BlockInfo.Proc);
end;


function TIFPSPascalCompiler.ReadReal(const s: string): PIfRVariant;
var
  C: Integer;
begin
  New(Result);
  InitializeVariant(Result, FindBaseType(btExtended));
  Val(s, Result^.textended, C);
end;

function TIFPSPascalCompiler.ReadString: PIfRVariant;
{$IFNDEF IFPS3_NOWIDESTRING}var wchar: Boolean;{$ENDIF}

  function ParseString: {$IFNDEF IFPS3_NOWIDESTRING}widestring{$ELSE}string{$ENDIF};
  var
    temp3: {$IFNDEF IFPS3_NOWIDESTRING}widestring{$ELSE}string{$ENDIF};

    function ChrToStr(s: string): {$IFNDEF IFPS3_NOWIDESTRING}widechar{$ELSE}char{$ENDIF};
    var
      w: Longint;
    begin
      Delete(s, 1, 1); {First char : #}
      w := StrToInt(s);
      Result := {$IFNDEF IFPS3_NOWIDESTRING}widechar{$ELSE}char{$ENDIF}(w);
      {$IFNDEF IFPS3_NOWIDESTRING}if w > $FF then wchar := true;{$ENDIF}
    end;

    function PString(s: string): string;
    begin
      s := copy(s, 2, Length(s) - 2);
      PString := s;
    end;
  begin
    temp3 := '';
    while (FParser.CurrTokenId = CSTI_String) or (FParser.CurrTokenId = CSTI_Char) do
    begin
      if FParser.CurrTokenId = CSTI_String then
      begin
        temp3 := temp3 + PString(FParser.GetToken);
        FParser.Next;
        if FParser.CurrTokenId = CSTI_String then
          temp3 := temp3 + #39;
      end {if}
      else
      begin
        temp3 := temp3 + ChrToStr(FParser.GetToken);
        FParser.Next;
      end; {else if}
    end; {while}
    ParseString := temp3;
  end;
var
{$IFNDEF IFPS3_NOWIDESTRING}
  w: widestring;
{$ENDIF}
  s: string;
begin
  {$IFDEF IFPS3_NOWIDESTRING} s {$ELSE}  w {$ENDIF}:= ParseString;
{$IFNDEF IFPS3_NOWIDESTRING}
  if wchar then
  begin
    New(Result);
    if Length(w) = 1 then
    begin
      InitializeVariant(Result, at2ut(FindBaseType(btwidechar)));
      Result^.twidechar := w[1];
    end else begin
      InitializeVariant(Result, at2ut(FindBaseType(btwidestring)));
      tbtwidestring(Result^.twidestring) := w;
     end;
  end else begin
    s := w;
{$ENDIF}
    New(Result);
    if Length(s) = 1 then
    begin
      InitializeVariant(Result, at2ut(FindBaseType(btchar)));
      Result^.tchar := s[1];
    end else begin
      InitializeVariant(Result, at2ut(FindBaseType(btstring)));
      tbtstring(Result^.tstring) := s;
    end;
{$IFNDEF IFPS3_NOWIDESTRING}
  end;
{$ENDIF}
end;


function TIFPSPascalCompiler.ReadInteger(const s: string): PIfRVariant;
var
  R: {$IFNDEF IFPS3_NOINT64}Int64;{$ELSE}Longint;{$ENDIF}
begin
  New(Result);
{$IFNDEF IFPS3_NOINT64}
  r := StrToInt64Def(s, 0);
  if (r >= Low(Integer)) and (r <= High(Integer)) then
  begin
    InitializeVariant(Result, at2ut(FindBaseType(bts32)));
    Result^.ts32 := r;
  end else if (r <= $FFFFFFFF) then
  begin
    InitializeVariant(Result, at2ut(FindBaseType(btu32)));
    Result^.tu32 := r;
  end else
  begin
    InitializeVariant(Result, at2ut(FindBaseType(bts64)));
    Result^.ts64 := r;
  end;
{$ELSE}
  r := StrToIntDef(s, 0);
  InitializeVariant(Result, at2ut(FindBaseType(bts32)));
  Result^.ts32 := r;
{$ENDIF}
end;

function TIFPSPascalCompiler.ProcessSub(BlockInfo: TIFPSBlockInfo): Boolean;

  function AllocStackReg2(MType: TIFPSType): TIFPSValue;
  var
    x: TIFPSProcVar;
  begin
{$IFDEF IFPS3_DEBUG}
    if (mtype = nil) or (not mtype.Used) then asm int 3; end;
{$ENDIF}
    x := TIFPSProcVar.Create;
    x.DeclarePos := FParser.CurrTokenPos;
    x.DeclareRow := FParser.Row;
    x.DeclareCol := FParser.Col;
    x.Name := '';
    x.AType := MType;
    BlockInfo.Proc.ProcVars.Add(x);
    Result := TIFPSValueAllocatedStackVar.Create;
    Result.SetParserPos(FParser);
    TIFPSValueAllocatedStackVar(Result).Proc := BlockInfo.Proc;
    with TIFPSValueAllocatedStackVar(Result) do
    begin
      LocalVarNo := proc.ProcVars.Count -1;
    end;
  end;

  function AllocStackReg(MType: TIFPSType): TIFPSValue;
  begin
    Result := AllocStackReg2(MType);
    BlockWriteByte(BlockInfo, Cm_Pt);
    BlockWriteLong(BlockInfo, MType.FinalTypeNo);
  end;

  function AllocPointer(MDestType: TIFPSType): TIFPSValue;
  begin
    Result := AllocStackReg(at2ut(FindBaseType(btPointer)));
    TIFPSProcVar(BlockInfo.Proc.ProcVars[TIFPSValueAllocatedStackVar(Result).LocalVarNo]).AType := MDestType;
  end;

  function WriteCalculation(InData, OutReg: TIFPSValue): Boolean; forward;
  function PreWriteOutRec(var X: TIFPSValue; FArrType: TIFPSType): Boolean; forward;
  function WriteOutRec(x: TIFPSValue; AllowData: Boolean): Boolean; forward;
  procedure AfterWriteOutRec(var x: TIFPSValue); forward;

  function CheckCompatType(V1, v2: TIFPSValue): Boolean;
  var
    p1, P2: TIFPSType;
  begin
    p1 := GetTypeNo(BlockInfo, V1);
    P2 := GetTypeNo(BlockInfo, v2);
    if (p1 = nil) or (p2 = nil) then
    begin
      if ((p1 <> nil) and ({$IFNDEF IFPS3_NOINTERFACES}(p1.ClassType = TIFPSInterfaceType) or {$ENDIF}(p1.BaseType = btProcPtr)) and (v2.ClassType = TIFPSValueNil)) or
        ((p2 <> nil) and ({$IFNDEF IFPS3_NOINTERFACES}(p2.ClassType = TIFPSInterfaceType) or {$ENDIF}(p2.BaseType = btProcPtr)) and (v1.ClassType = TIFPSValueNil)) then
      begin
        Result := True;
        exit;
      end else
      if ((p1 <> nil) and ({$IFNDEF IFPS3_NOINTERFACES}(p1.ClassType = TIFPSInterfaceType) or {$ENDIF}(p1.ClassType = TIFPSClassType)) and (v2.ClassType = TIFPSValueNil)) or
        ((p2 <> nil) and ({$IFNDEF IFPS3_NOINTERFACES}(p2.ClassType = TIFPSInterfaceType) or {$ENDIF}(p2.ClassType = TIFPSClassType)) and (v1.ClassType = TIFPSValueNil)) then
      begin
        Result := True;
        exit;
      end else
      if (v1.ClassType = TIFPSValueProcPtr) and (p2 <> nil) and (p2.BaseType = btProcPtr) then
      begin
        Result := CheckCompatProc(p2, TIFPSValueProcPtr(v1).ProcPtr);
        exit;
      end else if (v2.ClassType = TIFPSValueProcPtr) and (p1 <> nil) and (p1.BaseType = btProcPtr) then
      begin
        Result := CheckCompatProc(p1, TIFPSValueProcPtr(v2).ProcPtr);
        exit;
      end;
      Result := False;
    end else
    if (p1 <> nil) and (p1.BaseType = btSet) and (v2 is TIFPSValueArray) then
    begin
      Result := True;
    end else
      Result := IsCompatibleType(p1, p2, False);
  end;

  function ProcessFunction(ProcCall: TIFPSValueProc; ResultRegister: TIFPSValue): Boolean; forward;
  function ProcessFunction2(ProcNo: Cardinal; Par: TIFPSParameters; ResultReg: TIFPSValue): Boolean;
  var
    Temp: TIFPSValueProcNo;
  begin
    Temp := TIFPSValueProcNo.Create;
    Temp.Parameters := Par;
    Temp.ProcNo := ProcNo;
    if TObject(FProcs[ProcNo]).ClassType = TIFPSInternalProcedure then
      Temp.ResultType := TIFPSInternalProcedure(FProcs[ProcNo]).Decl.Result
    else
      Temp.ResultType := TIFPSExternalProcedure(FProcs[ProcNo]).RegProc.Decl.Result;
    Result := ProcessFunction(Temp, ResultReg);
    Temp.Parameters := nil;
    Temp.Free;
  end;

  function MakeNil(NilPos, NilRow, nilCol: Cardinal;ivar: TIFPSValue): Boolean;
  var
    Procno: Cardinal;
    PF: TIFPSType;
    Par: TIFPSParameters;
  begin
    Pf := GetTypeNo(BlockInfo, IVar);
    if not (Ivar is TIFPSValueVar) then
    begin
      with MakeError('', ecTypeMismatch, '') do
      begin
        FPosition := nilPos;
        FRow := NilRow;
        FCol := nilCol;
      end;
      Result := False;
      exit;
    end;
    if (pf.BaseType = btProcPtr) then
    begin
      Result := True;
    end else
    if (pf.BaseType = btString) or (pf.BaseType = btPChar) then
    begin
      if not PreWriteOutRec(iVar, nil) then
      begin
        Result := false;
        exit;
      end;
      BlockWriteByte(BlockInfo, CM_A);
      WriteOutRec(ivar, False);
      BlockWriteByte(BlockInfo, 1);
      BlockWriteLong(BlockInfo, GetTypeNo(BlockInfo, IVar).FinalTypeNo);
      BlockWriteLong(BlockInfo, 0); //empty string
      AfterWriteOutRec(ivar);
      Result := True;
    end else if (pf.BaseType = btClass) {$IFNDEF IFPS3_NOINTERFACES}or (pf.BaseType = btInterface){$ENDIF} then
    begin
{$IFNDEF IFPS3_NOINTERFACES}
      if (pf.BaseType = btClass) then
      begin
{$ENDIF}
        if not TIFPSClassType(pf).Cl.SetNil(ProcNo) then
        begin
          with MakeError('', ecTypeMismatch, '') do
          begin
            FPosition := nilPos;
            FRow := NilRow;
            FCol := nilCol;
          end;
          Result := False;
          exit;
        end;
{$IFNDEF IFPS3_NOINTERFACES}
      end else
      begin
        if not TIFPSInterfaceType(pf).Intf.SetNil(ProcNo) then
        begin
          with MakeError('', ecTypeMismatch, '') do
          begin
            FPosition := nilPos;
            FRow := NilRow;
            FCol := nilCol;
          end;
          Result := False;
          exit;
        end;
      end;
{$ENDIF}
      Par := TIFPSParameters.Create;
      with par.Add do
      begin
        Val := IVar;
        ExpectedType := GetTypeNo(BlockInfo, ivar);
{$IFDEF IFPS3_DEBUG}
        if not ExpectedType.Used then asm int 3; end;
{$ENDIF}
        ParamMode := pmInOut;
      end;
      Result := ProcessFunction2(ProcNo, Par, nil);

      Par[0].Val := nil; // don't free IVAR

      Par.Free;
    end else
    begin
      with MakeError('', ecTypeMismatch, '') do
      begin
        FPosition := nilPos;
        FRow := NilRow;
        FCol := nilCol;
      end;
      Result := False;
    end;
  end;
  function DoBinCalc(BVal: TIFPSBinValueOp; Output: TIFPSValue): Boolean;
  var
    tmpp, tmpc: TIFPSValue;
    jend, jover: Cardinal;

  begin
    if BVal.Operator >= otGreaterEqual then
    begin
      if BVal.FVal1.ClassType = TIFPSValueNil then
      begin
        tmpp := AllocStackReg(GetTypeNo(BlockInfo, BVal.FVal2));
        if not MakeNil(BVal.FVal1.Pos, BVal.FVal1.Row, BVal.FVal1.Col, tmpp) then
        begin
          tmpp.Free;
          Result := False;
          exit;
        end;
        tmpc := TIFPSValueReplace.Create;
        with TIFPSValueReplace(tmpc) do
        begin
          OldValue := BVal.FVal1;
          NewValue := tmpp;
        end;
        BVal.FVal1 := tmpc;
      end;
      if BVal.FVal2.ClassType = TIFPSValueNil then
      begin
        tmpp := AllocStackReg(GetTypeNo(BlockInfo, BVal.FVal1));
        if not MakeNil(BVal.FVal2.Pos, BVal.FVal2.Row, BVal.FVal2.Col, tmpp) then
        begin
          tmpp.Free;;
          Result := False;
          exit;
        end;
        tmpc := TIFPSValueReplace.Create;
        with TIFPSValueReplace(tmpc) do
        begin
          OldValue := BVal.FVal2;
          NewValue := tmpp;
        end;
        BVal.FVal2 := tmpc;
      end;
      if not (PreWriteOutRec(Output, nil) and PreWriteOutRec(BVal.FVal1, GetTypeNo(BlockInfo, BVal.FVal2)) and PreWriteOutRec(BVal.FVal2, GetTypeNo(BlockInfo, BVal.FVal1))) then
      begin
        Result := False;
        exit;
      end;
      BlockWriteByte(BlockInfo, CM_CO);
      case BVal.Operator of
        otGreaterEqual: BlockWriteByte(BlockInfo, 0);
        otLessEqual: BlockWriteByte(BlockInfo, 1);
        otGreater: BlockWriteByte(BlockInfo, 2);
        otLess: BlockWriteByte(BlockInfo, 3);
        otEqual: BlockWriteByte(BlockInfo, 5);
        otNotEqual: BlockWriteByte(BlockInfo, 4);
        otIn: BlockWriteByte(BlockInfo, 6);
        otIs: BlockWriteByte(BlockInfo, 7);
      end;

      if not (WriteOutRec(Output, False) and writeOutRec(BVal.FVal1, True) and writeOutRec(BVal.FVal2, True)) then
      begin
        Result := False;
        exit;
      end;
      AfterWriteOutrec(BVal.FVal1);
      AfterWriteOutrec(BVal.FVal2);
      AfterWriteOutrec(Output);
      if BVal.Val1.ClassType = TIFPSValueReplace then
      begin
        tmpp := TIFPSValueReplace(BVal.Val1).OldValue;
        BVal.Val1.Free;
        BVal.Val1 := tmpp;
      end;
      if BVal.Val2.ClassType = TIFPSValueReplace then
      begin
        tmpp := TIFPSValueReplace(BVal.Val2).OldValue;
        BVal.Val2.Free;
        BVal.Val2 := tmpp;
      end;
    end else begin
      if not PreWriteOutRec(Output, nil) then
      begin
        Result := False;
        exit;
      end;
      if not SameReg(Output, BVal.Val1) then
      begin
        if not WriteCalculation(BVal.FVal1, Output) then
        begin
          Result := False;
          exit;
        end;
      end;
      if (FBooleanShortCircuit) and (IsBoolean(BVal.aType)) then
      begin
        if BVal.Operator = otAnd then
        begin
          BlockWriteByte(BlockInfo, Cm_CNG);
          jover := Length(BlockInfo.Proc.FData);
          BlockWriteLong(BlockInfo, 0);
          WriteOutRec(Output, True);
          jend := Length(BlockInfo.Proc.FData);
        end else if BVal.Operator = otOr then
        begin
          BlockWriteByte(BlockInfo, Cm_CG);
          jover := Length(BlockInfo.Proc.FData);
          BlockWriteLong(BlockInfo, 0);
          WriteOutRec(Output, True);
          jend := Length(BlockInfo.Proc.FData);
        end else
        begin
          jover := 0;
          jend := 0;
        end;
      end else
      begin
        jover := 0;
        jend := 0;
      end;
      if not PreWriteOutrec(BVal.FVal2, GetTypeNo(BlockInfo, Output)) then
      begin
        Result := False;
        exit;
      end;
      BlockWriteByte(BlockInfo, Cm_CA);
      BlockWriteByte(BlockInfo, Ord(BVal.Operator));
      if not (WriteOutRec(Output, False) and WriteOutRec(BVal.FVal2, True)) then
      begin
        Result := False;
        exit;
      end;
      AfterWriteOutRec(BVal.FVal2);
      if FBooleanShortCircuit and (IsBoolean(BVal.aType)) then
      begin
        Cardinal((@BlockInfo.Proc.FData[jover+1])^) := Cardinal(Length(BlockInfo.Proc.FData)) - jend;
      end;
      AfterWriteOutRec(Output);
    end;
    Result := True;
  end;

  function DoUnCalc(Val: TIFPSUnValueOp; Output: TIFPSValue): Boolean;
  var
    Tmp: TIFPSValue;
  begin
    if not PreWriteOutRec(Output, nil) then
    begin
      Result := False;
      exit;
    end;
    case Val.Operator of
      otNot:
        begin
          if not SameReg(Val.FVal1, Output) then
          begin
            if not WriteCalculation(Val.FVal1, Output) then
            begin
              Result := False;
              exit;
            end;
          end;
          if IsBoolean(GetTypeNo(BlockInfo, Val)) then
            BlockWriteByte(BlockInfo, cm_bn)
          else
            BlockWriteByte(BlockInfo, cm_in);
          if not WriteOutRec(Output, True) then
          begin
            Result := False;
            exit;
          end;
        end;
      otMinus:
        begin
          if not SameReg(Val.FVal1, Output) then
          begin
            if not WriteCalculation(Val.FVal1, Output) then
            begin
              Result := False;
              exit;
            end;
          end;
          BlockWriteByte(BlockInfo, cm_vm);
          if not WriteOutRec(Output, True) then
          begin
            Result := False;
            exit;
          end;
        end;
      otCast:
        begin
          if ((Val.aType.BaseType = btChar) and (Val.aType.BaseType <> btU8)) {$IFNDEF IFPS3_NOWIDESTRING}or
            ((Val.aType.BaseType = btWideChar) and (Val.aType.BaseType <> btU16)){$ENDIF} then
          begin
            Tmp := AllocStackReg(Val.aType);
          end else
            Tmp := Output;
          if not (PreWriteOutRec(Val.FVal1, GetTypeNo(BlockInfo, Tmp)) and PreWriteOutRec(Tmp, GetTypeNo(BlockInfo, Tmp))) then
          begin
            Result := False;
            if tmp <> Output then Tmp.Free;
            exit;
          end;
          BlockWriteByte(BlockInfo, CM_A);
          if not (WriteOutRec(Tmp, False) and WriteOutRec(Val.FVal1, True)) then
          begin
            Result := false;
            if tmp <> Output then Tmp.Free;
            exit;
          end;
          AfterWriteOutRec(val.Fval1);
          if Tmp <> Output then
          begin
            if not WriteCalculation(Tmp, Output) then
            begin
              Result := false;
              Tmp.Free;
              exit;
            end;
          end;
          AfterWriteOutRec(Tmp);
          if Tmp <> Output then
            Tmp.Free;
        end;
      {else donothing}
    end;
    AfterWriteOutRec(Output);
    Result := True;
  end;


  function GetAddress(Val: TIFPSValue): Cardinal;
  begin
    if Val.ClassType = TIFPSValueGlobalVar then
      Result := TIFPSValueGlobalVar(val).GlobalVarNo
    else if Val.ClassType = TIFPSValueLocalVar then
      Result := IFPSAddrStackStart + TIFPSValueLocalVar(val).LocalVarNo + 1
    else if Val.ClassType = TIFPSValueParamVar then
      Result := IFPSAddrStackStart - TIFPSValueParamVar(val).ParamNo -1
    else if Val.ClassType =  TIFPSValueAllocatedStackVar then
      Result := IFPSAddrStackStart + TIFPSValueAllocatedStackVar(val).LocalVarNo + 1
    else
      Result := InvalidVal;
  end;

  function PreWriteOutRec(var X: TIFPSValue; FArrType: TIFPSType): Boolean;
  var
    rr: TIFPSSubItem;
    tmpp,
      tmpc: TIFPSValue;
    i: Longint;
    function MakeSet(SetType: TIFPSSetType; arr: TIFPSValueArray): Boolean;
    var
      c, i: Longint;
      dataval: TIFPSValueData;
      mType: TIFPSType;
    begin
      Result := True;
      dataval := TIFPSValueData.Create;
      dataval.Data := NewVariant(FarrType);
      for i := 0 to arr.count -1 do
      begin
        mType := GetTypeNo(BlockInfo, arr.Item[i]);
        if mType <> SetType.SetType then
        begin
          with MakeError('', ecTypeMismatch, '') do
          begin
            FCol := arr.item[i].Col;
            FRow := arr.item[i].Row;
            FPosition := arr.item[i].Pos;
          end;
          DataVal.Free;
          Result := False;
          exit;
        end;
        if arr.Item[i] is TIFPSValueData then
        begin
          c := GetInt(TIFPSValueData(arr.Item[i]).Data, Result);
          if not Result then
          begin
            dataval.Free;
            exit;
          end;
          Set_MakeMember(c, dataval.Data.tstring);
        end else
        begin
          DataVal.Free;
          MakeError('', ecTypeMismatch, '');
          Result := False;
          exit;
        end;
      end;
      tmpc := TIFPSValueReplace.Create;
      with TIFPSValueReplace(tmpc) do
      begin
        OldValue := x;
        NewValue := dataval;
        PreWriteAllocated := True;
      end;
      x := tmpc;
    end;
  begin
    Result := True;
    if x.ClassType = TIFPSValueReplace then
    begin
      if TIFPSValueReplace(x).PreWriteAllocated then
      begin
        inc(TIFPSValueReplace(x).FReplaceTimes);
      end;
    end else
    if x.ClassType = TIFPSValueProcPtr then
    begin
      if FArrType = nil then
      begin
        MakeError('', ecTypeMismatch, '');
        Result := False;
        Exit;
      end;
      tmpp := TIFPSValueData.Create;
      TIFPSValueData(tmpp).Data := NewVariant(FArrType);
      TIFPSValueData(tmpp).Data.tu32 := TIFPSValueProcPtr(x).ProcPtr;
      tmpc := TIFPSValueReplace.Create;
      with TIFPSValueReplace(tmpc) do
      begin
        PreWriteAllocated := True;
        OldValue := x;
        NewValue := tmpp;
      end;
      x := tmpc;
    end else
    if x.ClassType = TIFPSValueNil then
    begin
      if FArrType = nil then
      begin
        MakeError('', ecTypeMismatch, '');
        Result := False;
        Exit;
      end;
      tmpp := AllocStackReg(FArrType);
      if not MakeNil(x.Pos, x.Row, x.Col, tmpp) then
      begin
        tmpp.Free;
        Result := False;
        exit;
      end;
      tmpc := TIFPSValueReplace.Create;
      with TIFPSValueReplace(tmpc) do
      begin
        PreWriteAllocated := True;
        OldValue := x;
        NewValue := tmpp;
      end;
      x := tmpc;
    end else
    if x.ClassType = TIFPSValueArray then
    begin
      if FArrType = nil then
      begin
        MakeError('', ecTypeMismatch, '');
        Result := False;
        Exit;
      end;
      if TIFPSType(FArrType).BaseType = btSet then
      begin
        Result := MakeSet(TIFPSSetType(FArrType), TIFPSValueArray(x));
        exit;
      end;

      tmpp := AllocStackReg(FArrType);
      tmpc := AllocStackReg(FindBaseType(bts32));
      BlockWriteByte(BlockInfo, CM_A);
      WriteOutrec(tmpc, False);
      BlockWriteByte(BlockInfo, 1);
      BlockWriteLong(BlockInfo, FindBaseType(bts32).FinalTypeNo);
      BlockWriteLong(BlockInfo, TIFPSValueArray(x).Count);
      BlockWriteByte(BlockInfo, CM_PV);
      WriteOutrec(tmpp, False);
      BlockWriteByte(BlockInfo, CM_C);
      BlockWriteLong(BlockInfo, FindProc('SETARRAYLENGTH'));
      BlockWriteByte(BlockInfo, CM_PO);
      tmpc.Free;
      rr := TIFPSSubNumber.Create;
      rr.aType := TIFPSArrayType(FArrType).ArrayTypeNo;
      TIFPSValueVar(tmpp).RecAdd(rr);
      for i := 0 to TIFPSValueArray(x).Count -1 do
      begin
        TIFPSSubNumber(rr).SubNo := i;
        tmpc := TIFPSValueArray(x).Item[i];
        if not PreWriteOutRec(tmpc, GetTypeNo(BlockInfo, tmpc)) then
        begin
          tmpp.Free;
          Result := false;
          exit;
        end;
        if TIFPSArrayType(FArrType).ArrayTypeNo.BaseType = btPointer then
          BlockWriteByte(BlockInfo, cm_spc)
        else
          BlockWriteByte(BlockInfo, cm_a);
        if not (WriteOutrec(tmpp, False) and WriteOutRec(tmpc, True)) then
        begin
          Tmpp.Free;
          Result := false;
          exit;
        end;
        AfterWriteOutRec(tmpc);
      end;
      TIFPSValueVar(tmpp).RecDelete(0);
      tmpc := TIFPSValueReplace.Create;
      with TIFPSValueReplace(tmpc) do
      begin
        PreWriteAllocated := True;
        OldValue := x;
        NewValue := tmpp;
      end;
      x := tmpc;
    end else if (x.ClassType = TIFPSUnValueOp) then
    begin
      tmpp := AllocStackReg(GetTypeNo(BlockInfo, x));
      if not DoUnCalc(TIFPSUnValueOp(x), tmpp) then
      begin
        Result := False;
        exit;
      end;
      tmpc := TIFPSValueReplace.Create;
      with TIFPSValueReplace(tmpc) do
      begin
        PreWriteAllocated := True;
        OldValue := x;
        NewValue := tmpp;
      end;
      x := tmpc;
    end else if (x.ClassType = TIFPSBinValueOp) then
    begin
      tmpp := AllocStackReg(GetTypeNo(BlockInfo, x));
      if not DoBinCalc(TIFPSBinValueOp(x), tmpp) then
      begin
        tmpp.Free;
        Result := False;
        exit;
      end;
      tmpc := TIFPSValueReplace.Create;
      with TIFPSValueReplace(tmpc) do
      begin
        PreWriteAllocated := True;
        OldValue := x;
        NewValue := tmpp;
      end;
      x := tmpc;
    end else if x is TIFPSValueProc then
    begin
      tmpp := AllocStackReg(TIFPSValueProc(x).ResultType);
      if not WriteCalculation(x, tmpp) then
      begin
        tmpp.Free;
        Result := False;
        exit;
      end;
      tmpc := TIFPSValueReplace.Create;
      with TIFPSValueReplace(tmpc) do
      begin
        PreWriteAllocated := True;
        OldValue := x;
        NewValue := tmpp;
      end;
      x := tmpc;
    end else if (x is TIFPSValueVar) and (TIFPSValueVar(x).RecCount <> 0) then
    begin
      if  TIFPSValueVar(x).RecCount = 1 then
      begin
        rr := TIFPSValueVar(x).RecItem[0];
        if rr.ClassType <> TIFPSSubValue then
          exit; // there is no need pre-calculate anything
        if (TIFPSSubValue(rr).SubNo is TIFPSValueVar) and (TIFPSValueVar(TIFPSSubValue(rr).SubNo).RecCount = 0) then
          exit;
      end; //if
      tmpp := AllocPointer(GetTypeNo(BlockInfo, x));
      BlockWriteByte(BlockInfo, cm_sp);
      WriteOutRec(tmpp, True);
      BlockWriteByte(BlockInfo, 0);
      BlockWriteLong(BlockInfo, GetAddress(x));
      for i := 0 to TIFPSValueVar(x).RecCount - 1 do
      begin
        rr := TIFPSValueVar(x).RecItem[I];
        if rr.ClassType = TIFPSSubNumber then
        begin
          BlockWriteByte(BlockInfo, cm_sp);
          WriteOutRec(tmpp, false);
          BlockWriteByte(BlockInfo, 2);
          BlockWriteLong(BlockInfo, GetAddress(tmpp));
          BlockWriteLong(BlockInfo, TIFPSSubNumber(rr).SubNo);
        end else begin // if rr.classtype = TIFPSSubValue then begin
          tmpc := AllocStackReg(FindBaseType(btU32));
          if not WriteCalculation(TIFPSSubValue(rr).SubNo, tmpc) then
          begin
            tmpc.Free;
            tmpp.Free;
            Result := False;
            exit;
          end; //if
          BlockWriteByte(BlockInfo, cm_sp);
          WriteOutRec(tmpp, false);
          BlockWriteByte(BlockInfo, 3);
          BlockWriteLong(BlockInfo, GetAddress(tmpp));
          BlockWriteLong(BlockInfo, GetAddress(tmpc));
          tmpc.Free;
        end;
      end; // for
      tmpc := TIFPSValueReplace.Create;
      with TIFPSValueReplace(tmpc) do
      begin
        OldValue := x;
        NewValue := tmpp;
        PreWriteAllocated := True;
      end;
      x := tmpc;
    end;

  end;

  procedure AfterWriteOutRec(var x: TIFPSValue);
  var
    tmp: TIFPSValue;
  begin
    if (x.ClassType = TIFPSValueReplace) and (TIFPSValueReplace(x).PreWriteAllocated) then
    begin
      Dec(TIFPSValueReplace(x).FReplaceTimes);
      if TIFPSValueReplace(x).ReplaceTimes = 0 then
      begin
        tmp := TIFPSValueReplace(x).OldValue;
        x.Free;
        x := tmp;
      end;
    end;
  end; //afterwriteoutrec

  function WriteOutRec(x: TIFPSValue; AllowData: Boolean): Boolean;
  var
    rr: TIFPSSubItem;
  begin
    Result := True;
    if x.ClassType = TIFPSValueReplace then
      Result := WriteOutRec(TIFPSValueReplace(x).NewValue, AllowData)
    else if x is TIFPSValueVar then
    begin
      if TIFPSValueVar(x).RecCount = 0 then
      begin
        BlockWriteByte(BlockInfo, 0);
        BlockWriteLong(BlockInfo, GetAddress(x));
      end
      else
      begin
        rr := TIFPSValueVar(x).RecItem[0];
        if rr.ClassType = TIFPSSubNumber then
        begin
          BlockWriteByte(BlockInfo, 2);
          BlockWriteLong(BlockInfo, GetAddress(x));
          BlockWriteLong(BlockInfo, TIFPSSubNumber(rr).SubNo);
        end
        else
        begin
          BlockWriteByte(BlockInfo, 3);
          BlockWriteLong(BlockInfo, GetAddress(x));
          BlockWriteLong(BlockInfo, GetAddress(TIFPSSubValue(rr).SubNo));
        end;
      end;
    end else if x.ClassType = TIFPSValueData then
    begin
      if AllowData then
      begin
        BlockWriteByte(BlockInfo, 1);
        BlockWriteVariant(BlockInfo, TIFPSValueData(x).Data)
      end
      else
      begin
        Result := False;
        exit;
      end;
    end else
      Result := False;
  end;

  function ReadParameters(IsProperty: Boolean; Dest: TIFPSParameters): Boolean; forward;
{$IFNDEF IFPS3_NOIDISPATCH}
  function ReadIDispatchParameters(const ProcName: string; FSelf: TIFPSValue): TIFPSValue; forward;
{$ENDIF}
  function ReadProcParameters(ProcNo: Cardinal; FSelf: TIFPSValue): TIFPSValue; forward;
  function ReadVarParameters(ProcNoVar: TIFPSValue): TIFPSValue; forward;

  function calc(endOn: TIfPasToken): TIFPSValue; forward;


  function GetIdentifier(const FType: Byte): TIFPSValue;
    {
      FType:
        0 = Anything
        1 = Only variables
        2 = Not constants
    }

    procedure CheckProcCall(var x: TIFPSValue);
    begin
      if FParser.CurrTokenId = CSTI_Dereference then
      begin
        if GetTypeNo(BlockInfo, x).BaseType <> btProcPtr then
        begin
          MakeError('', ecTypeMismatch, '');
          x.Free;
          x := nil;
          Exit;
        end;
        FParser.Next;
        x := ReadVarParameters(x);
      end;
    end;

    procedure CheckFurther(var x: TIFPSValue; ImplicitPeriod: Boolean);
    var
      t: Cardinal;
      rr: TIFPSSubItem;
      L: Longint;
      u: TIFPSType;
      Param: TIFPSParameter;
      tmp, tmpn: TIFPSValue;
      tmp3: TIFPSValueProcNo;
      tmp2: Boolean;

      function FindSubR(const n: string; FType: TIFPSType): Cardinal;
      var
        h, I: Longint;
        rvv: PIFPSRecordFieldTypeDef;
      begin
        h := MakeHash(n);
        for I := 0 to TIFPSRecordType(FType).RecValCount - 1 do
        begin
          rvv := TIFPSRecordType(FType).RecVal(I);
          if (rvv.FieldNameHash = h) and (rvv.FieldName = n) then
          begin
            Result := I;
            exit;
          end;
        end;
        Result := InvalidVal;
      end;

    begin
(*      if not (x is TIFPSValueVar) then
        Exit;*)
      u := GetTypeNo(BlockInfo, x);
      if u = nil then exit;
      while True do
      begin
        if (u.BaseType = btClass) {$IFNDEF IFPS3_NOINTERFACES}or (u.BaseType = btInterface){$ENDIF}
        {$IFNDEF IFPS3_NOIDISPATCH}or (u.BaseType = btVariant){$ENDIF} then exit;
        if FParser.CurrTokenId = CSTI_OpenBlock then
        begin
          if u.BaseType = btString then
          begin
             FParser.Next;
            tmp := Calc(CSTI_CloseBlock);
            if tmp = nil then
            begin
              x.Free;
              x := nil;
              exit;
            end;
            if not IsIntType(GetTypeNo(BlockInfo, tmp).BaseType) then
            begin
              MakeError('', ecTypeMismatch, '');
              tmp.Free;
              x.Free;
              x := nil;
              exit;
            end;
            FParser.Next;
            if FParser.CurrTokenId = CSTI_Assignment then
            begin
              l := FindProc('STRSET');
              if l = -1 then
              begin
                MakeError('', ecUnknownIdentifier, 'StrSet');
                tmp.Free;
                x.Free;
                x := nil;
                exit;
              end;
              tmp3 := TIFPSValueProcNo.Create;
              tmp3.ResultType := nil;
              tmp3.SetParserPos(FParser);
              tmp3.ProcNo := L;
              tmp3.SetParserPos(FParser);
              tmp3.Parameters := TIFPSParameters.Create;
              param := tmp3.Parameters.Add;
              with tmp3.Parameters.Add do
              begin
                Val := tmp;
                ExpectedType := GetTypeNo(BlockInfo, tmp);
{$IFDEF IFPS3_DEBUG}
                if not ExpectedType.Used then asm int 3; end;
{$ENDIF}
              end;
              with tmp3.Parameters.Add do
              begin
                Val := x;
                ExpectedType := GetTypeNo(BlockInfo, x);
{$IFDEF IFPS3_DEBUG}
                if not ExpectedType.Used then asm int 3; end;
{$ENDIF}
                ParamMode := pmInOut;
              end;
              x := tmp3;
              FParser.Next;
              tmp := Calc(CSTI_SemiColon);
              if tmp = nil then
              begin
                x.Free;
                x := nil;
                exit;
              end;
              if GetTypeNo(BlockInfo, Tmp).BaseType <> btChar then
              begin
                x.Free;
                x := nil;
                Tmp.Free;
                MakeError('', ecTypeMismatch, '');
                exit;

              end;
              param.Val := tmp;
              Param.ExpectedType := GetTypeNo(BlockInfo, tmp);
{$IFDEF IFPS3_DEBUG}
              if not Param.ExpectedType.Used then asm int 3; end;
{$ENDIF}
            end else begin
              l := FindProc('STRGET');
              if l = -1 then
              begin
                MakeError('', ecUnknownIdentifier, 'StrGet');
                tmp.Free;
                x.Free;
                x := nil;
                exit;
              end;
              tmp3 := TIFPSValueProcNo.Create;
              tmp3.ResultType := FindBaseType(btChar);
              tmp3.ProcNo := L;
              tmp3.SetParserPos(FParser);
              tmp3.Parameters := TIFPSParameters.Create;
              with tmp3.Parameters.Add do
              begin
                Val := x;
                ExpectedType := GetTypeNo(BlockInfo, x);
{$IFDEF IFPS3_DEBUG}
                if not ExpectedType.Used then asm int 3; end;
{$ENDIF}

                if x is TIFPSValueVar then
                  ParamMode := pmInOut
                else
                  parammode := pmIn;
              end;
              with tmp3.Parameters.Add do
              begin
                Val := tmp;
                ExpectedType := GetTypeNo(BlockInfo, tmp);
{$IFDEF IFPS3_DEBUG}
                if not ExpectedType.Used then asm int 3; end;
{$ENDIF}
              end;
              x := tmp3;
            end;
            Break;
          end else if (u.BaseType = btArray) or (u.BaseType = btStaticArray) then
          begin
            FParser.Next;
            tmp := calc(CSTI_CloseBlock);
            if tmp = nil then
            begin
              x.Free;
              x := nil;
              exit;
            end;
            if not IsIntType(GetTypeNo(BlockInfo, tmp).BaseType) then
            begin
              MakeError('', ecTypeMismatch, '');
              tmp.Free;
              x.Free;
              x := nil;
              exit;
            end;
            if tmp.ClassType = TIFPSValueData then
            begin
              rr := TIFPSSubNumber.Create;
              TIFPSValueVar(x).RecAdd(rr);
              if (u.BaseType = btStaticArray) then
                TIFPSSubNumber(rr).SubNo := Cardinal(GetInt(TIFPSValueData(tmp).Data, tmp2) - TIFPSStaticArrayType(u).StartOffset)
              else
                TIFPSSubNumber(rr).SubNo := GetUInt(TIFPSValueData(tmp).Data, tmp2);
              tmp.Free;
              rr.aType := TIFPSArrayType(u).ArrayTypeNo;
              u := rr.aType;
            end
            else
            begin
              if (u.BaseType = btStaticArray) then
              begin
                tmpn := TIFPSBinValueOp.Create;
                TIFPSBinValueOp(tmpn).Operator := otSub;
                TIFPSBinValueOp(tmpn).Val1 := tmp;
                tmp := TIFPSValueData.Create;
                TIFPSValueData(tmp).Data := NewVariant(FindBaseType(btS32));
                TIFPSValueData(tmp).Data.ts32 := TIFPSStaticArrayType(u).StartOffset;
                TIFPSBinValueOp(tmpn).Val2 := tmp;
                TIFPSBinValueOp(tmpn).aType := FindBaseType(btS32);
                tmp := tmpn;
              end;
              rr := TIFPSSubValue.Create;
              TIFPSValueVar(x).recAdd(rr);
              TIFPSSubValue(rr).SubNo := tmp;
              rr.aType := TIFPSArrayType(u).ArrayTypeNo;
              u := rr.aType;
            end;
            if FParser.CurrTokenId <> CSTI_CloseBlock then
            begin
              MakeError('', ecCloseBlockExpected, '');
              x.Free;
              x := nil;
              exit;
            end;
            Fparser.Next;
          end else begin
            MakeError('', ecSemicolonExpected, '');
            x.Free;
            x := nil;
            exit;
          end;
        end
        else if (FParser.CurrTokenId = CSTI_Period) or (ImplicitPeriod) then
        begin
          if not ImplicitPeriod then
            FParser.Next;
          if u.BaseType = btRecord then
          begin
            t := FindSubR(FParser.GetToken, u);
            if t = InvalidVal then
            begin
              if ImplicitPeriod then exit;
              MakeError('', ecUnknownIdentifier, FParser.GetToken);
              x.Free;
              x := nil;
              exit;
            end;
            ImplicitPeriod := False;
            FParser.Next;
            rr := TIFPSSubNumber.Create;
            TIFPSValueVar(x).RecAdd(rr);
            TIFPSSubNumber(rr).SubNo := t;
            rr.aType := TIFPSRecordType(u).RecVal(t).FType;
            u := rr.aType;
          end
          else
          begin
            x.Free;
            MakeError('', ecSemicolonExpected, '');
            x := nil;
            exit;
          end;
        end
        else
          break;
      end;
    end;



    procedure CheckClassArrayProperty(var P: TIFPSValue; const VarType: TIFPSVariableType; VarNo: Cardinal);
    var
      Tempp: TIFPSValue;
      aType: TIFPSClassType;
      procno, Idx: Cardinal;
      Decl: TIFPSParametersDecl;
    begin
      if p = nil then exit;
      if (GetTypeNo(BlockInfo, p) = nil) or (GetTypeNo(BlockInfo, p).BaseType <> btClass) then exit;
      aType := TIFPSClassType(GetTypeNo(BlockInfo, p));
      if FParser.CurrTokenID = CSTI_OpenBlock then
      begin
        if not TIFPSClassType(aType).Cl.Property_Find('', Idx) then
        begin
          MakeError('', ecPeriodExpected, '');
          p.Free;
          p := nil;
          exit;
        end;
        if VarNo <> InvalidVal then
        begin
          if @FOnUseVariable <> nil then
           FOnUseVariable(Self, VarType, VarNo, BlockInfo.ProcNo, FParser.CurrTokenPos, '[Default]');
        end;
        Decl := TIFPSParametersDecl.Create;
        TIFPSClassType(aType).Cl.Property_GetHeader(Idx,  Decl);
        tempp := p;
        P := TIFPSValueProcNo.Create;
        with TIFPSValueProcNo(P) do
        begin
          Parameters := TIFPSParameters.Create;
          Parameters.Add;
        end;
        if not (ReadParameters(True, TIFPSValueProc(P).Parameters) and
          ValidateParameters(BlockInfo, TIFPSValueProc(P).Parameters, Decl)) then
        begin
          tempp.Free;
          Decl.Free;
          p.Free;
          p := nil;
          exit;
        end;
        with TIFPSValueProcNo(p).Parameters[0] do
        begin
          Val := tempp;
          ExpectedType := GetTypeNo(BlockInfo, tempp);
        end;
        if FParser.CurrTokenId = CSTI_Assignment then
        begin
          FParser.Next;
          TempP := Calc(CSTI_SemiColon);
          if TempP = nil then
          begin
            Decl.Free;
            P.Free;
            p := nil;
            exit;
          end;
          with TIFPSValueProc(p).Parameters.Add do
          begin
            Val := Tempp;
            ExpectedType := at2ut(Decl.Result);
          end;
          if not TIFPSClassType(aType).Cl.Property_Set(Idx, procno) then
          begin
            Decl.Free;
            MakeError('', ecReadOnlyProperty, '');
            p.Free;
            p := nil;
            exit;
          end;
          TIFPSValueProcNo(p).ProcNo := procno;
          TIFPSValueProcNo(p).ResultType := nil;
        end
        else
        begin
          if not TIFPSClassType(aType).Cl.Property_Get(Idx, procno) then
          begin
            Decl.Free;
            MakeError('', ecWriteOnlyProperty, '');
            p.Free;
            p := nil;
            exit;
          end;
          TIFPSValueProcNo(p).ProcNo := procno;
          TIFPSValueProcNo(p).ResultType := TIFPSExternalProcedure(FProcs[procno]).RegProc.Decl.Result;
        end; // if FParser.CurrTokenId = CSTI_Assign
        Decl.Free;
      end;
    end;

    procedure CheckClass(var P: TIFPSValue; const VarType: TIFPSVariableType; VarNo: Cardinal; ImplicitPeriod: Boolean);
    var
      Procno, Idx: Cardinal;
      FType: TIFPSType;
      TempP: TIFPSValue;
      Decl: TIFPSParametersDecl;
      s: string;

      pinfo, pinfonew: string;
      ppos: Cardinal;

    begin
      FType := GetTypeNo(BlockInfo, p);
      if FType = nil then exit;
      if (FType.BaseType <> btClass) then Exit;
      while (FParser.CurrTokenID = CSTI_Period) or (ImplicitPeriod) do
      begin
        if not ImplicitPeriod then
          FParser.Next;
        if FParser.CurrTokenID <> CSTI_Identifier then
        begin
          if ImplicitPeriod then exit;
          MakeError('', ecIdentifierExpected, '');
          p.Free;
          P := nil;
          Exit;
        end;
        s := FParser.GetToken;
        if TIFPSClassType(FType).Cl.Func_Find(s, Idx) then
        begin
          FParser.Next;
          VarNo := InvalidVal;
          TIFPSClassType(FType).cl.Func_Call(Idx, Procno);
          P := ReadProcParameters(Procno, P);
          if p = nil then
          begin
            Exit;
          end;
        end else if TIFPSClassType(FType).cl.Property_Find(s, Idx) then
        begin
          ppos := FParser.CurrTokenPos;
          pinfonew := FParser.OriginalToken;
          FParser.Next;
          if VarNo <> InvalidVal then
          begin
            if pinfo = '' then
              pinfo := pinfonew
            else
              pinfo := pinfo + '.' + pinfonew;
            if @FOnUseVariable <> nil then
              FOnUseVariable(Self, VarType, VarNo, BlockInfo.ProcNo, ppos, pinfo);
          end;
          Decl := TIFPSParametersDecl.Create;
          TIFPSClassType(FType).cl.Property_GetHeader(Idx, Decl);
          TempP := P;
          p := TIFPSValueProcNo.Create;
          with TIFPSValueProcNo(p) do
          begin
            Parameters := TIFPSParameters.Create;
            Parameters.Add;

          end;
          if Decl.ParamCount <> 0 then
          begin
            if not (ReadParameters(True, TIFPSValueProc(P).Parameters) and
              ValidateParameters(BlockInfo, TIFPSValueProc(P).Parameters, Decl)) then
            begin
              Tempp.Free;
              Decl.Free;
              p.Free;
              P := nil;
              exit;
            end;
          end; // if
          with TIFPSValueProcNo(p).Parameters[0] do
          begin
            Val := TempP;
            ExpectedType := at2ut(GetTypeNo(BlockInfo, TempP));
          end;
          if FParser.CurrTokenId = CSTI_Assignment then
          begin
            FParser.Next;
            TempP := Calc(CSTI_SemiColon);
            if TempP = nil then
            begin
              Decl.Free;
              P.Free;
              p := nil;
              exit;
            end;
            with TIFPSValueProc(p).Parameters.Add do
            begin
              Val := Tempp;
              ExpectedType := at2ut(Decl.Result);
{$IFDEF IFPS3_DEBUG}
              if not ExpectedType.Used then asm int 3; end;
{$ENDIF}
            end;

            if not TIFPSClassType(FType).cl.Property_Set(Idx, Procno) then
            begin
              MakeError('', ecReadOnlyProperty, '');
              Decl.Free;
              p.Free;
              p := nil;
              exit;
            end;
            TIFPSValueProcNo(p).ProcNo := Procno;
            TIFPSValueProcNo(p).ResultType := nil;
            Decl.Free;
            Exit;
          end else begin
            if not TIFPSClassType(FType).cl.Property_Get(Idx, Procno) then
            begin
              MakeError('', ecWriteOnlyProperty, '');
              Decl.Free;
              p.Free;
              p := nil;
              exit;
            end;
            TIFPSValueProcNo(p).ProcNo := ProcNo;
            TIFPSValueProcNo(p).ResultType := TIFPSExternalProcedure(FProcs[ProcNo]).RegProc.Decl.Result;
          end; // if FParser.CurrTokenId = CSTI_Assign
          Decl.Free;
        end else
        begin
          if ImplicitPeriod then exit;
          MakeError('', ecUnknownIdentifier, s);
          p.Free;
          P := nil;
          Exit;
        end;
        ImplicitPeriod := False;
        FType := GetTypeNo(BlockInfo, p);
        if (FType = nil) or (FType.BaseType <> btClass) then Exit;
      end; {while}
    end;
{$IFNDEF IFPS3_NOINTERFACES}
    procedure CheckIntf(var P: TIFPSValue; const VarType: TIFPSVariableType; VarNo: Cardinal; ImplicitPeriod: Boolean);
    var
      Procno, Idx: Cardinal;
      FType: TIFPSType;
      s: string;
    begin
      FType := GetTypeNo(BlockInfo, p);
      if FType = nil then exit;
      if (FType.BaseType <> btInterface) and (Ftype.BaseType <> BtVariant) then Exit;
      while (FParser.CurrTokenID = CSTI_Period) or (ImplicitPeriod) do
      begin
        if not ImplicitPeriod then
          FParser.Next;
        if FParser.CurrTokenID <> CSTI_Identifier then
        begin
          if ImplicitPeriod then exit;
          MakeError('', ecIdentifierExpected, '');
          p.Free;
          P := nil;
          Exit;
        end;
        if FType.BaseType = btVariant then
        begin
          s := FParser.OriginalToken;
          FParser.Next;
          ImplicitPeriod := False;
          FType := GetTypeNo(BlockInfo, p);
          p := ReadIDispatchParameters(s, p);
          if (FType = nil) or (FType.BaseType <> btInterface) then Exit;
        end else
        begin
          s := FParser.GetToken;
          if TIFPSInterfaceType(FType).Intf.Func_Find(s, Idx) then
          begin
            FParser.Next;
            TIFPSInterfaceType(FType).Intf.Func_Call(Idx, Procno);
            P := ReadProcParameters(Procno, P);
            if p = nil then
            begin
              Exit;
            end;
          end else
          begin
            if ImplicitPeriod then exit;
            MakeError('', ecUnknownIdentifier, s);
            p.Free;
            P := nil;
            Exit;
          end;
          ImplicitPeriod := False;
          FType := GetTypeNo(BlockInfo, p);
          if (FType = nil) or (FType.BaseType <> btInterface) or (Ftype.BaseType <> btVariant) then Exit;
        end;
      end; {while}
    end;
{$ENDIF}
    function CheckClassType(TypeNo: TIFPSType; const ParserPos: Cardinal): TIFPSValue;
    var
      FType2: TIFPSType;
      ProcNo, Idx: Cardinal;
      Temp, ResV: TIFPSValue;
      dta: PIfRVariant;
    begin
      if FParser.CurrTokenID = CSTI_OpenRound then
      begin
        FParser.Next;
        Temp := Calc(CSTI_CloseRound);
        if Temp = nil then
        begin
          Result := nil;
          exit;
        end;
        if FParser.CurrTokenID <> CSTI_CloseRound then
        begin
          temp.Free;
          MakeError('', ecCloseRoundExpected, '');
          Result := nil;
          exit;
        end;
        FType2 := GetTypeNo(BlockInfo, Temp);
        if ((typeno.BaseType = btClass){$IFNDEF IFPS3_NOINTERFACES} or (TypeNo.basetype = btInterface){$ENDIF}) and
          ((ftype2.BaseType = btClass){$IFNDEF IFPS3_NOINTERFACES} or (ftype2.BaseType = btInterface){$ENDIF}) and (TypeNo <> ftype2) then
        begin
{$IFNDEF IFPS3_NOINTERFACES}
          if FType2.basetype = btClass then
          begin
{$ENDIF}
          if not TIFPSClassType(FType2).Cl.CastToType(AT2UT(TypeNo), ProcNo) then
          begin
            temp.Free;
            MakeError('', ecTypeMismatch, '');
            Result := nil;
            exit;
          end;
{$IFNDEF IFPS3_NOINTERFACES}
          end else begin
            if not TIFPSInterfaceType(FType2).Intf.CastToType(AT2UT(TypeNo), ProcNo) then
            begin
              temp.Free;
              MakeError('', ecTypeMismatch, '');
              Result := nil;
              exit;
            end;
          end;
{$ENDIF}
          Result := TIFPSValueProcNo.Create;
          TIFPSValueProcNo(Result).Parameters := TIFPSParameters.Create;
          TIFPSValueProcNo(Result).ResultType := at2ut(TypeNo);
          TIFPSValueProcNo(Result).ProcNo := ProcNo;
          with TIFPSValueProcNo(Result).Parameters.Add do
          begin
            Val := Temp;
            ExpectedType := GetTypeNo(BlockInfo, temp);
{$IFDEF IFPS3_DEBUG}
            if not ExpectedType.Used then asm int 3; end;
{$ENDIF}
          end;
          with TIFPSValueProcNo(Result).Parameters.Add do
          begin
            ExpectedType := at2ut(FindBaseType(btu32));
{$IFDEF IFPS3_DEBUG}
            if not ExpectedType.Used then asm int 3; end;
{$ENDIF}
            Val := TIFPSValueData.Create;
            with TIFPSValueData(val) do
            begin
              SetParserPos(FParser);
              Data := NewVariant(ExpectedType);
              Data.tu32 := at2ut(TypeNo).FinalTypeNo;
            end;
          end;
          FParser.Next;
          Exit;
        end;
        if not IsCompatibleType(TypeNo, FType2, True) then
        begin
          temp.Free;
          MakeError('', ecTypeMismatch, '');
          Result := nil;
          exit;
        end;
        FParser.Next;
        Result := TIFPSUnValueOp.Create;
        with TIFPSUnValueOp(Result) do
        begin
          Operator := otCast;
          Val1 := Temp;
          SetParserPos(FParser);
          aType := AT2UT(TypeNo);
        end;
        exit;
      end else
      if FParser.CurrTokenId <> CSTI_Period then
      begin
        Result := TIFPSValueData.Create;
        Result.SetParserPos(FParser);
        New(dta);
        TIFPSValueData(Result).Data := dta;
        InitializeVariant(dta, at2ut(FindBaseType(btType)));
        dta.ttype := at2ut(TypeNo);
        Exit;
      end;
      if TypeNo.BaseType <> btClass then
      begin
        Result := nil;
        MakeError('', ecClassTypeExpected, '');
        Exit;
      end;
      FParser.Next;
      if not TIFPSClassType(TypeNo).Cl.ClassFunc_Find(FParser.GetToken, Idx) then
      begin
        Result := nil;
        MakeError('', ecUnknownIdentifier, FParser.OriginalToken);
        Exit;
      end;
      FParser.Next;
      TIFPSClassType(TypeNo).Cl.ClassFunc_Call(Idx, ProcNo);
      Temp := TIFPSValueData.Create;
      with TIFPSValueData(Temp) do
      begin
        Data := NewVariant(at2ut(FindBaseType(btu32)));
        Data.tu32 := at2ut(TypeNo).FinalTypeNo;
      end;
      ResV := ReadProcParameters(ProcNo, Temp);
      if ResV <> nil then
      begin
        TIFPSValueProc(Resv).ResultType := at2ut(TypeNo);
        Result := Resv;
      end else begin
        Result := nil;
      end;
    end;

  var
    vt: TIFPSVariableType;
    vno: Cardinal;
    TWith, Temp: TIFPSValue;
    l, h: Longint;
    s, u: string;
    t: TIFPSConstant;
    Temp1: TIFPSType;
    temp2: CArdinal;
    bi: TIFPSBlockInfo;

  begin
    s := FParser.GetToken;

    if FType <> 1 then
    begin
      bi := BlockInfo;
      while bi <> nil do
      begin
        for l := bi.WithList.Count -1 downto 0 do
        begin
          TWith := TIFPSValueAllocatedStackVar.Create;
          TIFPSValueAllocatedStackVar(TWith).LocalVarNo := TIFPSValueAllocatedStackVar(TIFPSValueReplace(bi.WithList[l]).NewValue).LocalVarNo;
          Temp := TWith;
          VNo := TIFPSValueAllocatedStackVar(Temp).LocalVarNo;
          vt := ivtVariable;
          if Temp = TWith then CheckFurther(TWith, True);
          if Temp = TWith then CheckClass(TWith, vt, vno, True);
          if Temp <> TWith then
          begin
            repeat
              Temp := TWith;
              if TWith <> nil then CheckFurther(TWith, False);
              if TWith <> nil then CheckClass(TWith, vt, vno, False);
{$IFNDEF IFPS3_NOINTERFACES}if TWith <> nil then CheckIntf(TWith, vt, vno, False);{$ENDIF}
              if TWith <> nil then CheckProcCall(TWith);
              if TWith <> nil then CheckClassArrayProperty(TWith, vt, vno);
              vno := InvalidVal;
            until (TWith = nil) or (Temp = TWith);
            Result := TWith;
            Exit;
          end;
          TWith.Free;
        end;
        bi := bi.FOwner;
      end;
    end;

    if s = 'RESULT' then
    begin
      if BlockInfo.proc.Decl.Result = nil then
      begin
        Result := nil;
        MakeError('', ecUnknownIdentifier, FParser.OriginalToken);
      end
      else
      begin
        BlockInfo.Proc.ResultUse;
        Result := TIFPSValueParamVar.Create;
        with TIFPSValueParamVar(Result) do
        begin
          SetParserPos(FParser);
          ParamNo := 0;
        end;
        vno := 0;
        vt := ivtParam;
        if @FOnUseVariable <> nil then
          FOnUseVariable(Self, vt, vno, BlockInfo.ProcNo, FParser.CurrTokenPos, '');
        FParser.Next;
        repeat
          Temp := Result;
          if Result <> nil then CheckFurther(Result, False);
          if Result <> nil then CheckClass(Result, vt, vno, False);
{$IFNDEF IFPS3_NOINTERFACES}if Result <> nil then CheckIntf(Result, vt, vno, False);{$ENDIF}
          if Result <> nil then CheckProcCall(Result);
          if Result <> nil then CheckClassArrayProperty(Result, vt, vno);
          vno := InvalidVal;
        until (Result = nil) or (Temp = Result);
      end;
      exit;
    end;
    if BlockInfo.Proc.Decl.Result = nil then
      l := 0
    else
      l := 1;
    for h := 0 to BlockInfo.proc.Decl.ParamCount -1 do
    begin
      if BlockInfo.proc.Decl.Params[h].Name = s then
      begin
        Result := TIFPSValueParamVar.Create;
        with TIFPSValueParamVar(Result) do
        begin
          SetParserPos(FParser);
          ParamNo := l;
        end;
        vt := ivtParam;
        vno := L;
        if @FOnUseVariable <> nil then
          FOnUseVariable(Self, vt, vno, BlockInfo.ProcNo, FParser.CurrTokenPos, '');
        FParser.Next;
        repeat
          Temp := Result;
          if Result <> nil then CheckFurther(Result, False);
          if Result <> nil then CheckClass(Result, vt, vno, False);
{$IFNDEF IFPS3_NOINTERFACES}if Result <> nil then CheckIntf(Result, vt, vno, False);{$ENDIF}
          if Result <> nil then CheckProcCall(Result);
          if Result <> nil then CheckClassArrayProperty(Result, vt, vno);
          vno := InvalidVal;
        until (Result = nil) or (Temp = Result);
        exit;
      end;
      Inc(l);
      GRFW(u);
    end;

    h := MakeHash(s);

    for l := 0 to BlockInfo.Proc.ProcVars.Count - 1 do
    begin
      if (PIFPSProcVar(BlockInfo.Proc.ProcVars[l]).NameHash = h) and
        (PIFPSProcVar(BlockInfo.Proc.ProcVars[l]).Name = s) then
      begin
        PIFPSProcVar(BlockInfo.Proc.ProcVars[l]).Use;
        vno := l;
        vt := ivtVariable;
        if @FOnUseVariable <> nil then
          FOnUseVariable(Self, vt, vno, BlockInfo.ProcNo, FParser.CurrTokenPos, '');
        Result := TIFPSValueLocalVar.Create;
        with TIFPSValueLocalVar(Result) do
        begin
          LocalVarNo := l;
          SetParserPos(FParser);
        end;
        FParser.Next;
        repeat
          Temp := Result;
          if Result <> nil then CheckFurther(Result, False);
          if Result <> nil then CheckClass(Result, vt, vno, False);
{$IFNDEF IFPS3_NOINTERFACES}if Result <> nil then CheckIntf(Result, vt, vno, False);{$ENDIF}
          if Result <> nil then CheckProcCall(Result);
          if Result <> nil then CheckClassArrayProperty(Result, vt, vno);
          vno := InvalidVal;
        until (Result = nil) or (Temp = Result);

        exit;
      end;
    end;

    for l := 0 to FVars.Count - 1 do
    begin
      if (TIFPSVar(FVars[l]).NameHash = h) and
        (TIFPSVar(FVars[l]).Name = s) then
      begin
        TIFPSVar(FVars[l]).Use;
        Result := TIFPSValueGlobalVar.Create;
        with TIFPSValueGlobalVar(Result) do
        begin
          SetParserPos(FParser);
          GlobalVarNo := l;

        end;
        vt := ivtGlobal;
        vno := l;
        if @FOnUseVariable <> nil then
          FOnUseVariable(Self, vt, vno, BlockInfo.ProcNo, FParser.CurrTokenPos, '');
        FParser.Next;
        repeat
          Temp := Result;
          if Result <> nil then CheckFurther(Result, False);
          if Result <> nil then CheckClass(Result, vt, vno, False);
{$IFNDEF IFPS3_NOINTERFACES}if Result <> nil then CheckIntf(Result, vt, vno, False);{$ENDIF}
          if Result <> nil then CheckProcCall(Result);
          if Result <> nil then CheckClassArrayProperty(Result, vt, vno);
          vno := InvalidVal;
        until (Result = nil) or (Temp = Result);
        exit;
      end;
    end;
    Temp1 := FindType(FParser.GetToken);
    if Temp1 <> nil then
    begin
      l := FParser.CurrTokenPos;
      if FType = 1 then
      begin
        Result := nil;
        MakeError('', ecVariableExpected, FParser.OriginalToken);
        exit;
      end;
      vt := ivtGlobal;
      vno := InvalidVal;
      FParser.Next;
      Result := CheckClassType(Temp1, l);
        repeat
          Temp := Result;
          if Result <> nil then CheckFurther(Result, False);
          if Result <> nil then CheckClass(Result, vt, vno, False);
{$IFNDEF IFPS3_NOINTERFACES}if Result <> nil then CheckIntf(Result, vt, vno, False);{$ENDIF}
          if Result <> nil then CheckProcCall(Result);
          if Result <> nil then CheckClassArrayProperty(Result, vt, vno);
          vno := InvalidVal;
        until (Result = nil) or (Temp = Result);

      exit;
    end;
    Temp2 := FindProc(FParser.GetToken);
    if Temp2 <> InvalidVal then
    begin
      if FType = 1 then
      begin
        Result := nil;
        MakeError('', ecVariableExpected, FParser.OriginalToken);
        exit;
      end;
      FParser.Next;
      Result := ReadProcParameters(Temp2, nil);
      if Result = nil then
        exit;
      Result.SetParserPos(FParser);
      vt := ivtGlobal;
      vno := InvalidVal;
      repeat
        Temp := Result;
        if Result <> nil then CheckFurther(Result, False);
        if Result <> nil then CheckClass(Result, vt, vno, False);
{$IFNDEF IFPS3_NOINTERFACES}if Result <> nil then CheckIntf(Result, vt, vno, False);{$ENDIF}
        if Result <> nil then CheckProcCall(Result);
        if Result <> nil then CheckClassArrayProperty(Result, vt, vno);
        vno := InvalidVal;
      until (Result = nil) or (Temp = Result);
      exit;
    end;
    for l := 0 to FConstants.Count -1 do
    begin
      t := TIFPSConstant(FConstants[l]);
      if (t.NameHash = h) and (t.Name = s) then
      begin
        if FType <> 0 then
        begin
          Result := nil;
          MakeError('', ecVariableExpected, FParser.OriginalToken);
          exit;
        end;
        fparser.next;
        Result := TIFPSValueData.Create;
        with TIFPSValueData(Result) do
        begin
          SetParserPos(FParser);
          Data := NewVariant(at2ut(t.Value.FType));
          CopyVariantContents(t.Value, Data);
        end;
        exit;
      end;
    end;
    Result := nil;
    MakeError('', ecUnknownIdentifier, FParser.OriginalToken);
  end;

  function calc(endOn: TIfPasToken): TIFPSValue;
    function TryEvalConst(var P: TIFPSValue): Boolean; forward;


    function ReadExpression: TIFPSValue; forward;
    function ReadTerm: TIFPSValue; forward;
    function ReadFactor: TIFPSValue;
    var
      NewVar: TIFPSValue;
      NewVarU: TIFPSUnValueOp;
      Proc: TIFPSProcedure;
      function ReadString: PIfRVariant;
      {$IFNDEF IFPS3_NOWIDESTRING}var wchar: Boolean;{$ENDIF}

        function ParseString: {$IFNDEF IFPS3_NOWIDESTRING}widestring{$ELSE}string{$ENDIF};
        var
          temp3: {$IFNDEF IFPS3_NOWIDESTRING}widestring{$ELSE}string{$ENDIF};

          function ChrToStr(s: string): {$IFNDEF IFPS3_NOWIDESTRING}widechar{$ELSE}char{$ENDIF};
          var
            w: Longint;
          begin
            Delete(s, 1, 1); {First char : #}
            w := StrToInt(s);
            Result := {$IFNDEF IFPS3_NOWIDESTRING}widechar{$ELSE}char{$ENDIF}(w);
            {$IFNDEF IFPS3_NOWIDESTRING}if w > $FF then wchar := true;{$ENDIF}
          end;

          function PString(s: string): string;
          begin
            s := copy(s, 2, Length(s) - 2);
            PString := s;
          end;
        begin
          temp3 := '';
          while (FParser.CurrTokenId = CSTI_String) or (FParser.CurrTokenId = CSTI_Char) do
          begin
            if FParser.CurrTokenId = CSTI_String then
            begin
              temp3 := temp3 + PString(FParser.GetToken);
              FParser.Next;
              if FParser.CurrTokenId = CSTI_String then
                temp3 := temp3 + #39;
            end {if}
            else
            begin
              temp3 := temp3 + ChrToStr(FParser.GetToken);
              FParser.Next;
            end; {else if}
          end; {while}
          ParseString := temp3;
        end;
      {$IFNDEF IFPS3_NOWIDESTRING}
      var
        w: widestring;
        s: string;
      begin
        w := ParseString;
        if wchar then
        begin
          New(Result);
          if Length(w) = 1 then
          begin
            InitializeVariant(Result, at2ut(FindBaseType(btwidechar)));
            Result^.twidechar := w[1];
          end else begin
            InitializeVariant(Result, at2ut(FindBaseType(btwidestring)));
            tbtwidestring(result^.twidestring) := w;
          end;
        end else begin
          s := w;
          New(Result);
          if Length(s) = 1 then
          begin
            InitializeVariant(Result, at2ut(FindBaseType(btChar)));
            Result^.tchar := s[1];
          end else begin
            InitializeVariant(Result, at2ut(FindBaseType(btstring)));
            tbtstring(Result^.tstring) := s;
          end;
        end;
      end;
      {$ELSE}
      var
        s: string;
      begin
        s := ParseString;
        New(Result);
        if Length(s) = 1 then
        begin
          InitializeVariant(Result, at2ut(FindBaseType(btChar)));
          Result^.tchar := s[1];
        end else begin
          InitializeVariant(Result, at2ut(FindBaseType(btstring)));
          tbtstring(Result^.tstring) := s;
        end;
      end;
      {$ENDIF}
    function ReadReal(const s: string): PIfRVariant;
    var
      C: Integer;
    begin
      New(Result);
      InitializeVariant(Result, at2ut(FindBaseType(btExtended)));
      System.Val(s, Result^.textended, C);
    end;
      function ReadInteger(const s: string): PIfRVariant;
      {$IFNDEF IFPS3_NOINT64}
      var
        R: Int64;
      begin
        r := StrToInt64Def(s, 0);
        New(Result);
        if (r >= High(Longint)) or (r <= Low(Longint))then
        begin
          InitializeVariant(Result, at2ut(FindBaseType(bts64)));
          Result^.ts64 := r;
        end else
        begin
          InitializeVariant(Result, at2ut(FindBaseType(bts32)));
          Result^.ts32 := r;
        end;
      end;
      {$ELSE}
      var
        r: Longint;
      begin
        r := StrToIntDef(s, 0);
        New(Result);
        InitializeVariant(Result, at2ut(FindBaseType(bts32)));
        Result^.ts32 := r;
      end;
      {$ENDIF}
      function ReadArray: Boolean;
      var
        tmp: TIFPSValue;
      begin
        FParser.Next;
        NewVar := TIFPSValueArray.Create;
        NewVar.SetParserPos(FParser);
        if FParser.CurrTokenID <> CSTI_CloseBlock then
        begin
          while True do
          begin
            tmp := nil;
            Tmp := ReadExpression();
            if Tmp = nil then
            begin
              Result := False;
              NewVar.Free;
              exit;
            end;
            if not TryEvalConst(tmp) then
            begin
              tmp.Free;
              NewVar.Free;
              Result := False;
              exit;
            end;
            TIFPSValueArray(NewVar).Add(tmp);
            if FParser.CurrTokenID = CSTI_CloseBlock then Break;
            if FParser.CurrTokenID <> CSTI_Comma then
            begin
              MakeError('', ecCloseBlockExpected, '');
              NewVar.Free;
              Result := False;
              exit;
            end;
            FParser.Next;
          end;
        end;
        FParser.Next;
        Result := True;
      end;

      function CallAssigned(P: TIFPSValue): TIFPSValue;
      var
        temp: TIFPSValueProcNo;
      begin
        temp := TIFPSValueProcNo.Create;
        temp.ProcNo := FindProc('!ASSIGNED');
        temp.ResultType := at2ut(FDefaultBoolType);
        temp.Parameters := TIFPSParameters.Create;
        with Temp.Parameters.Add do
        begin
          Val := p;
          ExpectedType := GetTypeNo(BlockInfo, p);
{$IFDEF IFPS3_DEBUG}
          if not ExpectedType.Used then asm int 3; end;
{$ENDIF}
          FParamMode := pmIn;
        end;
        Result := Temp;
      end;

      function CallSucc(P: TIFPSValue): TIFPSValue;
      var
        temp: TIFPSBinValueOp;
      begin
        temp := TIFPSBinValueOp.Create;
        temp.SetParserPos(FParser);
        temp.FOperator := otAdd;
        temp.FVal2 := TIFPSValueData.Create;
        TIFPSValueData(Temp.FVal2).Data := NewVariant(FindBaseType(bts32));
        TIFPSValueData(Temp.FVal2).Data.ts32 := 1;
        temp.FVal1 := p;
        Temp.FType := GetTypeNo(BlockInfo, P);
        result := temp;
      end;

      function CallPred(P: TIFPSValue): TIFPSValue;
      var
        temp: TIFPSBinValueOp;
      begin
        temp := TIFPSBinValueOp.Create;
        temp.SetParserPos(FParser);
        temp.FOperator := otSub;
        temp.FVal2 := TIFPSValueData.Create;
        TIFPSValueData(Temp.FVal2).Data := NewVariant(FindBaseType(bts32));
        TIFPSValueData(Temp.FVal2).Data.ts32 := 1;
        temp.FVal1 := p;
        Temp.FType := GetTypeNo(BlockInfo, P);
        result := temp;
      end;

    begin
      case fParser.CurrTokenID of
        CSTI_OpenBlock:
          begin
            if not ReadArray then
            begin
              Result := nil;
              exit;
            end;
          end;
        CSTII_Not:
        begin
          FParser.Next;
          NewVar := ReadFactor;
          if NewVar = nil then
          begin
            Result := nil;
            exit;
          end;
          NewVarU := TIFPSUnValueOp.Create;
          NewVarU.SetParserPos(FParser);
          NewVarU.aType := GetTypeNo(BlockInfo, NewVar);
          NewVarU.Operator := otNot;
          NewVarU.Val1 := NewVar;
          NewVar := NewVarU;
        end;
        CSTI_Minus:
        begin
          FParser.Next;
          NewVar := ReadTerm;
          if NewVar = nil then
          begin
            Result := nil;
            exit;
          end;
          NewVarU := TIFPSUnValueOp.Create;
          NewVarU.SetParserPos(FParser);
          NewVarU.aType := GetTypeNo(BlockInfo, NewVar);
          NewVarU.Operator := otMinus;
          NewVarU.Val1 := NewVar;
          NewVar := NewVarU;
        end;
        CSTII_Nil:
          begin
            FParser.Next;
            NewVar := TIFPSValueNil.Create;
            NewVar.SetParserPos(FParser);
          end;
        CSTI_AddressOf:
          begin
            FParser.Next;
            if FParser.CurrTokenID <> CSTI_Identifier then
            begin
              MakeError('', ecIdentifierExpected, '');
              Result := nil;
              exit;
            end;
            NewVar := TIFPSValueProcPtr.Create;
            NewVar.SetParserPos(FParser);
            TIFPSValueProcPtr(NewVar).ProcPtr := FindProc(FParser.GetToken);
            if TIFPSValueProcPtr(NewVar).ProcPtr = InvalidVal then
            begin
              MakeError('', ecUnknownIdentifier, FParser.OriginalToken);
              NewVar.Free;
              Result := nil;
              exit;
            end;
            Proc := FProcs[TIFPSValueProcPtr(NewVar).ProcPtr];
            if Proc.ClassType <> TIFPSInternalProcedure then
            begin
              MakeError('', ecUnknownIdentifier, FParser.OriginalToken);
              NewVar.Free;
              Result := nil;
              exit;
            end;
            FParser.Next;
          end;
        CSTI_OpenRound:
          begin
            FParser.Next;
            NewVar := ReadExpression();
            if NewVar = nil then
            begin
              Result := nil;
              exit;
            end;
            if FParser.CurrTokenId <> CSTI_CloseRound then
            begin
              NewVar.Free;
              Result := nil;
              MakeError('', ecCloseRoundExpected, '');
              exit;
            end;
            FParser.Next;
          end;
        CSTI_Char, CSTI_String:
          begin
            NewVar := TIFPSValueData.Create;
            NewVar.SetParserPos(FParser);
            TIFPSValueData(NewVar).Data := ReadString;
          end;
        CSTI_HexInt, CSTI_Integer:
          begin
            NewVar := TIFPSValueData.Create;
            NewVar.SetParserPos(FParser);
            TIFPSValueData(NewVar).Data := ReadInteger(FParser.GetToken);
            FParser.Next;
          end;
        CSTI_Real:
          begin
            NewVar := TIFPSValueData.Create;
            NewVar.SetParserPos(FParser);
            TIFPSValueData(NewVar).Data := ReadReal(FParser.GetToken);
            FParser.Next;
          end;
        CSTII_Ord:
          begin
            FParser.Next;
            if fParser.Currtokenid <> CSTI_OpenRound then
            begin
              Result := nil;
              MakeError('', ecOpenRoundExpected, '');
              exit;
            end;
            FParser.Next;
            NewVar := ReadExpression();
            if NewVar = nil then
            begin
              Result := nil;
              exit;
            end;
            if FParser.CurrTokenId <> CSTI_CloseRound then
            begin
              NewVar.Free;
              Result := nil;
              MakeError('', ecCloseRoundExpected, '');
              exit;
            end;
            if not ((GetTypeNo(BlockInfo, NewVar).BaseType = btChar) or
            {$IFNDEF IFPS3_NOWIDESTRING} (GetTypeNo(BlockInfo, NewVar).BaseType = btWideChar) or{$ENDIF}
            (GetTypeNo(BlockInfo, NewVar).BaseType = btEnum) or (IsIntType(GetTypeNo(BlockInfo, NewVar).BaseType))) then
            begin
              NewVar.Free;
              Result := nil;
              MakeError('', ecTypeMismatch, '');
              exit;
            end;
            NewVarU := TIFPSUnValueOp.Create;
            NewVarU.SetParserPos(FParser);
            NewVarU.Operator := otCast;
            NewVarU.FType := at2ut(FindBaseType(btu32));
            NewVarU.Val1 := NewVar;
            NewVar := NewVarU;
            FParser.Next;
          end;
        CSTII_Chr:
          begin
            FParser.Next;
            if fParser.Currtokenid <> CSTI_OpenRound then
            begin
              Result := nil;
              MakeError('', ecOpenRoundExpected, '');
              exit;
            end;
            FParser.Next;
            NewVar := ReadExpression();
            if NewVar = nil then
            begin
              Result := nil;
              exit;
            end;
            if FParser.CurrTokenId <> CSTI_CloseRound then
            begin
              NewVar.Free;
              Result := nil;
              MakeError('', ecCloseRoundExpected, '');
              exit;
            end;
            if not (IsIntType(GetTypeNo(BlockInfo, NewVar).BaseType)) then
            begin
              NewVar.Free;
              Result := nil;
              MakeError('', ecTypeMismatch, '');
              exit;
            end;
            NewVarU := TIFPSUnValueOp.Create;
            NewVarU.SetParserPos(FParser);
            NewVarU.Operator := otCast;
            NewVarU.FType := at2ut(FindBaseType(btChar));
            NewVarU.Val1 := NewVar;
            NewVar := NewVarU;
            FParser.Next;
          end;
        CSTI_Identifier:
          begin
            if FParser.GetToken = 'SUCC' then
            begin
              FParser.Next;
              if FParser.CurrTokenID <> CSTI_OpenRound then
              begin
                Result := nil;
                MakeError('', ecOpenRoundExpected, '');
                exit;
              end;
              FParser.Next;
              NewVar := ReadExpression;
              if NewVar = nil then
              begin
                result := nil;
                exit;
              end;
              if (GetTypeNo(BlockInfo, NewVar) = nil) or (not IsIntType(GetTypeNo(BlockInfo, NewVar).BaseType) and
                (GetTypeNo(BlockInfo, NewVar).BaseType <> btEnum)) then
              begin
                NewVar.Free;
                Result := nil;
                MakeError('', ecTypeMismatch, '');
                exit;
              end;
              if FParser.CurrTokenID <> CSTI_CloseRound then
              begin
                NewVar.Free;
                Result := nil;
                MakeError('', eccloseRoundExpected, '');
                exit;
              end;
              NewVar := CallSucc(NewVar);
              FParser.Next;
            end else
            if FParser.GetToken = 'PRED' then
            begin
              FParser.Next;
              if FParser.CurrTokenID <> CSTI_OpenRound then
              begin
                Result := nil;
                MakeError('', ecOpenRoundExpected, '');
                exit;
              end;
              FParser.Next;
              NewVar := ReadExpression;
              if NewVar = nil then
              begin
                result := nil;
                exit;
              end;
              if (GetTypeNo(BlockInfo, NewVar) = nil) or (not IsIntType(GetTypeNo(BlockInfo, NewVar).BaseType) and
                (GetTypeNo(BlockInfo, NewVar).BaseType <> btEnum)) then
              begin
                NewVar.Free;
                Result := nil;
                MakeError('', ecTypeMismatch, '');
                exit;
              end;
              if FParser.CurrTokenID <> CSTI_CloseRound then
              begin
                NewVar.Free;
                Result := nil;
                MakeError('', eccloseRoundExpected, '');
                exit;
              end;
              NewVar := CallPred(NewVar);
              FParser.Next;
            end else
            if FParser.GetToken = 'ASSIGNED' then
            begin
              FParser.Next;
              if FParser.CurrTokenID <> CSTI_OpenRound then
              begin
                Result := nil;
                MakeError('', ecOpenRoundExpected, '');
                exit;
              end;
              FParser.Next;
              NewVar := GetIdentifier(0);
              if NewVar = nil then
              begin
                result := nil;
                exit;
              end;
              if (GetTypeNo(BlockInfo, NewVar) = nil) or ((GetTypeNo(BlockInfo, NewVar).BaseType <> btClass) and
                (GetTypeNo(BlockInfo, NewVar).BaseType <> btPChar) and
                (GetTypeNo(BlockInfo, NewVar).BaseType <> btString)) then
              begin
                NewVar.Free;
                Result := nil;
                MakeError('', ecTypeMismatch, '');
                exit;
              end;
              if FParser.CurrTokenID <> CSTI_CloseRound then
              begin
                NewVar.Free;
                Result := nil;
                MakeError('', eccloseRoundExpected, '');
                exit;
              end;
              NewVar := CallAssigned(NewVar);
              FParser.Next;
            end  else
            begin
              NewVar := GetIdentifier(0);
              if NewVar = nil then
              begin
                Result := nil;
                exit;
              end;
            end;
          end;
      else
        begin
          MakeError('', ecSyntaxError, '');
          Result := nil;
          exit;
        end;
      end; {case}
      Result := NewVar;
    end; // ReadFactor

    function GetResultType(p1, P2: TIFPSValue; Cmd: TIFPSBinOperatorType): TIFPSType;
    var
      pp, t1, t2: PIFPSType;
    begin
      t1 := GetTypeNo(BlockInfo, p1);
      t2 := GetTypeNo(BlockInfo, P2);
      if (t1 = nil) or (t2 = nil) then
      begin
        if ((p1.ClassType = TIFPSValueNil) or (p2.ClassType = TIFPSValueNil)) and ((t1 <> nil) or (t2 <> nil)) then
        begin
          if p1.ClassType = TIFPSValueNil then
            pp := t2
          else
            pp := t1;
          if (pp.BaseType = btPchar) or (pp.BaseType = btString) or (pp.BaseType = btClass) {$IFNDEF IFPS3_NOINTERFACES}or (pp.BaseType =btInterface){$ENDIF} then
            Result := AT2UT(FDefaultBoolType)
          else
            Result := nil;
          exit;
        end;
        Result := nil;
        exit;
      end;
      case Cmd of
        otAdd: {plus}
          begin
            if (t1.BaseType = btVariant) and (
              (t2.BaseType = btVariant) or
              (t2.BaseType = btString) or
              {$IFNDEF IFPS3_NOWIDESTRING}
              (t2.BaseType = btwideString) or
              (t2.BaseType = btwidechar) or
              {$ENDIF}
              (t2.BaseType = btPchar) or
              (t2.BaseType = btChar) or
              (isIntRealType(t2.BaseType))) then
              Result := t1
            else
            if (t2.BaseType = btVariant) and (
              (t1.BaseType = btVariant) or
              (t1.BaseType = btString) or
              (t1.BaseType = btPchar) or
              (t1.BaseType = btChar) or
              (isIntRealType(t1.BaseType))) then
              Result := t2
            else if ((t1.BaseType = btSet) and (t2.BaseType = btSet)) and (t1 = t2) then
              Result := t1
            else if IsIntType(t1.BaseType) and IsIntType(t2.BaseType) then
              Result := t1
            else if IsIntRealType(t1.BaseType) and
              IsIntRealType(t2.BaseType) then
            begin
              if IsRealType(t1.BaseType) then
                Result := t1
              else
                Result := t2;
            end
            else if (t1.basetype = btSet) and (t2.Name = 'TVARIANTARRAY') then
              Result := t1
            else if (t2.basetype = btSet) and (t1.Name = 'TVARIANTARRAY') then
              Result := t2
            else if ((t1.BaseType = btPchar) or(t1.BaseType = btString) or (t1.BaseType = btChar)) and ((t2.BaseType = btPchar) or(t2.BaseType = btString) or (t2.BaseType = btChar)) then
              Result := at2ut(FindBaseType(btString))
            {$IFNDEF IFPS3_NOWIDESTRING}
            else if ((t1.BaseType = btString) or (t1.BaseType = btChar) or (t1.BaseType = btPchar)or (t1.BaseType = btWideString) or (t1.BaseType = btWideChar)) and
            ((t2.BaseType = btString) or (t2.BaseType = btChar) or (t2.BaseType = btPchar) or (t2.BaseType = btWideString) or (t2.BaseType = btWideChar)) then
              Result := at2ut(FindBaseType(btWideString))
            {$ENDIF}
            else
              Result := nil;
          end;
        otSub, otMul, otDiv: { -  * / }
          begin
            if (t1.BaseType = btVariant) and (
              (t2.BaseType = btVariant) or
              (isIntRealType(t2.BaseType))) then
              Result := t1
            else if ((t1.BaseType = btSet) and (t2.BaseType = btSet)) and (t1 = t2) and ((cmd = otSub) or (cmd = otMul))  then
              Result := t1
            else if (t1.basetype = btSet) and (t2.Name = 'TVARIANTARRAY') and ((cmd = otSub) or (cmd = otMul)) then
              Result := t1
            else if (t2.basetype = btSet) and (t1.Name = 'TVARIANTARRAY') and ((cmd = otSub) or (cmd = otMul)) then
              Result := t2
            else
            if (t2.BaseType = btVariant) and (
              (t1.BaseType = btVariant) or
              (isIntRealType(t1.BaseType))) then
              Result := t2
            else if IsIntType(t1.BaseType) and IsIntType(t2.BaseType) then
              Result := t1
            else if IsIntRealType(t1.BaseType) and
              IsIntRealType(t2.BaseType) then
            begin
              if IsRealType(t1.BaseType) then
                Result := t1
              else
                Result := t2;
            end
            else
              Result := nil;
          end;
        otAnd, otOr, otXor: {and,or,xor}
          begin
            if (t1.BaseType = btVariant) and (
              (t2.BaseType = btVariant) or
              (isIntType(t2.BaseType))) then
              Result := t1
            else
            if (t2.BaseType = btVariant) and (
              (t1.BaseType = btVariant) or
              (isIntType(t1.BaseType))) then
              Result := t2
            else if IsIntType(t1.BaseType) and IsIntType(t2.BaseType) then
              Result := t1
            else if (IsBoolean(t1)) and (t2 = t1) then
            begin
              Result := t1;
              if ((p1.ClassType = TIFPSValueData) or (p2.ClassType = TIFPSValueData)) then
              begin
                if cmd = otAnd then {and}
                begin
                  if p1.ClassType = TIFPSValueData then
                  begin
                    if (TIFPSValueData(p1).FData^.tu8 <> 0) then
                    begin
                      with MakeWarning('', ewIsNotNeeded, '"True and"') do
                      begin
                        FRow := p1.Row;
                        FCol := p1.Col;
                        FPosition := p1.Pos;
                      end;
                    end else
                    begin
                      with MakeWarning('', ewCalculationAlwaysEvaluatesTo, 'False') do
                      begin
                        FRow := p1.Row;
                        FCol := p1.Col;
                        FPosition := p1.Pos;
                      end;
                    end;
                  end else begin
                    if (TIFPSValueData(p2).Data.tu8 <> 0) then
                    begin
                      with MakeWarning('', ewIsNotNeeded, '"and True"') do
                      begin
                        FRow := p1.Row;
                        FCol := p1.Col;
                        FPosition := p1.Pos;
                      end;
                    end
                    else
          begin
                      with MakeWarning('', ewCalculationAlwaysEvaluatesTo, 'False') do
                      begin
                        FRow := p1.Row;
                        FCol := p1.Col;
                        FPosition := p1.Pos;
                      end;
                    end;
                  end;
                end else if cmd = otOr then {or}
                begin
                  if p1.ClassType = TIFPSValueData then
                  begin
                    if (TIFPSValueData(p1).Data.tu8 <> 0) then
                    begin
                      with MakeWarning('', ewCalculationAlwaysEvaluatesTo, 'True') do
                      begin
                        FRow := p1.Row;
                        FCol := p1.Col;
                        FPosition := p1.Pos;
                      end;
                    end
                    else
                    begin
                      with MakeWarning('', ewIsNotNeeded, '"False or"') do
                      begin
                        FRow := p1.Row;
                        FCol := p1.Col;
                        FPosition := p1.Pos;
                      end;
                    end
                  end else begin
                    if (TIFPSValueData(p2).Data.tu8 <> 0) then
                    begin
                      with MakeWarning('', ewCalculationAlwaysEvaluatesTo, 'True') do
                      begin
                        FRow := p1.Row;
                        FCol := p1.Col;
                        FPosition := p1.Pos;
                      end;
                    end
                    else
                    begin
                      with MakeWarning('', ewIsNotNeeded, '"or False"') do
                      begin
                        FRow := p1.Row;
                        FCol := p1.Col;
                        FPosition := p1.Pos;
                      end;
                    end
                  end;
                end;
              end;
            end else
              Result := nil;
          end;
        otMod, otShl, otShr: {mod,shl,shr}
          begin
            if (t1.BaseType = btVariant) and (
              (t2.BaseType = btVariant) or
              (isIntType(t2.BaseType))) then
              Result := t1
            else
            if (t2.BaseType = btVariant) and (
              (t1.BaseType = btVariant) or
              (isIntType(t1.BaseType))) then
              Result := t2
            else if IsIntType(t1.BaseType) and IsIntType(t2.BaseType) then
              Result :=  t1
            else
              Result := nil;
          end;
        otGreater, otLess, otGreaterEqual, otLessEqual: { >=, <=, >, <}
          begin
            if (t1.BaseType = btVariant) and (
              (t2.BaseType = btVariant) or
              (t2.BaseType = btString) or
              (t2.BaseType = btPchar) or
              (t2.BaseType = btChar) or
              (isIntRealType(t2.BaseType))) then
              Result := FDefaultBoolType
            else if ((t1.BaseType = btSet) and (t2.BaseType = btSet)) and (t1 = t2) and ((cmd = otGreaterEqual) or (cmd = otLessEqual))  then
              Result := FDefaultBoolType
            else
            if (t2.BaseType = btVariant) and (
              (t1.BaseType = btVariant) or
              (t1.BaseType = btString) or
              (t1.BaseType = btPchar) or
              (t1.BaseType = btChar) or
              (isIntRealType(t1.BaseType))) then
              Result := FDefaultBoolType
            else if IsIntType(t1.BaseType) and IsIntType(t2.BaseType) then
              Result := FDefaultBoolType
            else if IsIntRealType(t1.BaseType) and
              IsIntRealType(t2.BaseType) then
              Result := FDefaultBoolType
            else if
            ((t1.BaseType = btString) or (t1.BaseType = btChar) {$IFNDEF IFPS3_NOWIDESTRING} or (t1.BaseType = btWideString) or (t1.BaseType = btWideChar){$ENDIF}) and
            ((t2.BaseType = btString) or (t2.BaseType = btChar) {$IFNDEF IFPS3_NOWIDESTRING} or (t2.BaseType = btWideString) or (t2.BaseType = btWideChar){$ENDIF}) then
              Result := FDefaultBoolType
            else if (t1.BaseType = btVariant) or (t2.BaseType = btVariant) then
              Result := FDefaultBoolType
            else
              Result := nil;
          end;
        otEqual, otNotEqual: {=, <>}
          begin
            if (t1.BaseType = btVariant) and (
              (t2.BaseType = btVariant) or
              (t2.BaseType = btString) or
              (t2.BaseType = btPchar) or
              (t2.BaseType = btChar) or
              (isIntRealType(t2.BaseType))) then
              Result := FDefaultBoolType
            else if ((t1.BaseType = btSet) and (t2.BaseType = btSet)) and (t1 = t2) then
              Result := FDefaultBoolType
            else
            if (t2.BaseType = btVariant) and (
              (t1.BaseType = btVariant) or
              (t1.BaseType = btString) or
              (t1.BaseType = btPchar) or
              (t1.BaseType = btChar) or
              (isIntRealType(t1.BaseType))) then
              Result := FDefaultBoolType
            else if IsIntType(t1.BaseType) and IsIntType(t2.BaseType) then
              Result := FDefaultBoolType
            else if IsIntRealType(t1.BaseType) and
              IsIntRealType(t2.BaseType) then
              Result := FDefaultBoolType
            else if
            ((t1.BaseType = btString) or (t1.BaseType = btChar) {$IFNDEF IFPS3_NOWIDESTRING} or (t1.BaseType = btWideString) or (t1.BaseType = btWideChar){$ENDIF}) and
            ((t2.BaseType = btString) or (t2.BaseType = btChar) {$IFNDEF IFPS3_NOWIDESTRING} or (t2.BaseType = btWideString) or (t2.BaseType = btWideChar){$ENDIF}) then
              Result := FDefaultBoolType
            else if (t1.basetype = btSet) and (t2.Name = 'TVARIANTARRAY') then
              Result := FDefaultBoolType
            else if (t2.basetype = btSet) and (t1.Name = 'TVARIANTARRAY') then
              Result := FDefaultBoolType
            else if (t1.BaseType = btEnum) and (t1 = t2) then
              Result := FDefaultBoolType
            else if (t1.BaseType = btClass) and (t2.BaseType = btClass) then
              Result := FDefaultBoolType
            else if (t1.BaseType = btVariant) or (t2.BaseType = btVariant) then
              Result := FDefaultBoolType
            else Result := nil;
          end;
        otIn:
          begin
            if (t2.BaseType = btSet) and (TIFPSSetType(t2).SetType = t1) then
              Result := FDefaultBoolType
            else
              Result := nil;
          end;
        otIs:
          begin
            if t2.BaseType = btType then
            begin
              Result := FDefaultBoolType
            end else
            Result := nil;
          end;
        otAs:
          begin
            if t2.BaseType = btType then
            begin
              Result := at2ut(TIFPSValueData(p2).Data.ttype);
            end else
              Result := nil;
          end;
      else
        Result := nil;
      end;
    end;


    function ReadTerm: TIFPSValue;
    var
      F1, F2: TIFPSValue;
      F: TIFPSBinValueOp;
      Token: TIfPasToken;
      Op: TIFPSBinOperatorType;
    begin
      F1 := ReadFactor;
      if F1 = nil then
      begin
        Result := nil;
        exit;
      end;
      while FParser.CurrTokenID in [CSTI_Multiply, CSTI_Divide, CSTII_Div, CSTII_Mod, CSTII_And, CSTII_Shl, CSTII_Shr, CSTII_As] do
      begin
        Token := FParser.CurrTokenID;
        FParser.Next;
        F2 := ReadFactor;
        if f2 = nil then
        begin
          f1.Free;
          Result := nil;
          exit;
        end;
        case Token of
          CSTI_Multiply: Op := otMul;
          CSTII_div, CSTI_Divide: Op := otDiv;
          CSTII_mod: Op := otMod;
          CSTII_and: Op := otAnd;
          CSTII_shl: Op := otShl;
          CSTII_shr: Op := otShr;
          CSTII_As:  Op := otAs;
        else
          Op := otAdd;
        end;
        F := TIFPSBinValueOp.Create;
        f.Val1 := F1;
        f.Val2 := F2;
        f.Operator := Op;
        f.aType := GetResultType(F1, F2, Op);
        if f.aType = nil then
        begin
          MakeError('', ecTypeMismatch, '');
          f.Free;
          Result := nil;
          exit;
        end;
        f1 := f;
      end;
      Result := F1;
    end;  // ReadTerm

    function ReadSimpleExpression: TIFPSValue;
    var
      F1, F2: TIFPSValue;
      F: TIFPSBinValueOp;
      Token: TIfPasToken;
      Op: TIFPSBinOperatorType;
    begin
      F1 := ReadTerm;
      if F1 = nil then
      begin
        Result := nil;
        exit;
      end;
      while FParser.CurrTokenID in [CSTI_Plus, CSTI_Minus, CSTII_Or, CSTII_Xor] do
      begin
        Token := FParser.CurrTokenID;
        FParser.Next;
        F2 := ReadTerm;
        if f2 = nil then
        begin
          f1.Free;
          Result := nil;
          exit;
        end;
        case Token of
          CSTI_Plus: Op := otAdd;
          CSTI_Minus: Op := otSub;
          CSTII_or: Op := otOr;
          CSTII_xor: Op := otXor;
        else
          Op := otAdd;
        end;
        F := TIFPSBinValueOp.Create;
        f.Val1 := F1;
        f.Val2 := F2;
        f.Operator := Op;
        f.aType := GetResultType(F1, F2, Op);
        if f.aType = nil then
        begin
          MakeError('', ecTypeMismatch, '');
          f.Free;
          Result := nil;
          exit;
        end;
        f1 := f;
      end;
      Result := F1;
    end;  // ReadSimpleExpression


    function ReadExpression: TIFPSValue;
    var
      F1, F2: TIFPSValue;
      F: TIFPSBinValueOp;
      Token: TIfPasToken;
      Op: TIFPSBinOperatorType;
    begin
      F1 := ReadSimpleExpression;
      if F1 = nil then
      begin
        Result := nil;
        exit;
      end;
      while FParser.CurrTokenID in [ CSTI_GreaterEqual, CSTI_LessEqual, CSTI_Greater, CSTI_Less, CSTI_Equal, CSTI_NotEqual, CSTII_in, CSTII_is] do
      begin
        Token := FParser.CurrTokenID;
        FParser.Next;
        F2 := ReadSimpleExpression;
        if f2 = nil then
        begin
          f1.Free;
          Result := nil;
          exit;
        end;
        case Token of
          CSTI_GreaterEqual: Op := otGreaterEqual;
          CSTI_LessEqual: Op := otLessEqual;
          CSTI_Greater: Op := otGreater;
          CSTI_Less: Op := otLess;
          CSTI_Equal: Op := otEqual;
          CSTI_NotEqual: Op := otNotEqual;
          CSTII_in: Op := otIn;
          CSTII_is: Op := otIs;
        else
          Op := otAdd;
        end;
        F := TIFPSBinValueOp.Create;
        f.Val1 := F1;
        f.Val2 := F2;
        f.Operator := Op;
        f.aType := GetResultType(F1, F2, Op);
        if f.aType = nil then
        begin
          MakeError('', ecTypeMismatch, '');
          f.Free;
          Result := nil;
          exit;
        end;
        f1 := f;
      end;
      Result := F1;
    end;  // ReadExpression

    function TryEvalConst(var P: TIFPSValue): Boolean;
    var
      preplace: TIFPSValue;
    begin
      if p is TIFPSBinValueOp then
      begin
        if not (TryEvalConst(TIFPSBinValueOp(p).FVal1) and TryEvalConst(TIFPSBinValueOp(p).FVal2)) then
        begin
          Result := False;
          exit;
        end;
        if (TIFPSBinValueOp(p).FVal1.ClassType = TIFPSValueData) and (TIFPSBinValueOp(p).FVal2.ClassType = TIFPSValueData) then
        begin
          if not PreCalc(True, 0, TIFPSValueData(TIFPSBinValueOp(p).Val1).Data, 0, TIFPSValueData(TIFPSBinValueOp(p).Val2).Data, TIFPSBinValueOp(p).Operator, p.Pos, p.Row, p.Col) then
          begin
            Result := False;
            exit;
          end;
          preplace := TIFPSValueData.Create;
          preplace.Pos := p.Pos;
          preplace.Row := p.Row;
          preplace.Col := p.Col;
          TIFPSValueData(preplace).Data := TIFPSValueData(TIFPSBinValueOp(p).Val1).Data;
          TIFPSValueData(TIFPSBinValueOp(p).Val1).Data := nil;
          p.Free;
          p := preplace;
        end;
      end else if p is TIFPSUnValueOp then
      begin
        if not TryEvalConst(TIFPSUnValueOp(p).FVal1) then
        begin
          Result := False;
          exit;
        end;
        if TIFPSUnValueOp(p).FVal1.ClassType = TIFPSValueData then
        begin
//
          case TIFPSUnValueOp(p).Operator of
            otNot:
              begin
                case TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.FType.BaseType of
                  btEnum:
                    begin
                      if IsBoolean(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.FType) then
                      begin
                        TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu8 := (not TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu8) and 1;
                      end else
                      begin
                        MakeError('', ecTypeMismatch, '');
                        Result := False;
                        exit;
                      end;
                    end;
                  btU8: TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu8 := not TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu8;
                  btU16: TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu16 := not TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu16;
                  btU32: TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu32 := not TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu32;
                  bts8: TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts8 := not TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts8;
                  bts16: TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts16 := not TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts16;
                  bts32: TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts32 := not TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts32;
                  {$IFNDEF IFPS3_NOINT64}
                  bts64: TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts64 := not TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts64;
                  {$ENDIF}
                else
                  begin
                    MakeError('', ecTypeMismatch, '');
                    Result := False;
                    exit;
                  end;
                end;
                preplace := TIFPSUnValueOp(p).Val1;
                TIFPSUnValueOp(p).Val1 := nil;
                p.Free;
                p := preplace;
              end;
            otMinus:
              begin
                case TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.FType.BaseType of
                  btU8: TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu8 := -TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu8;
                  btU16: TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu16 := -TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu16;
                  btU32: TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu32 := -TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu32;
                  bts8: TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts8 := -TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts8;
                  bts16: TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts16 := -TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts16;
                  bts32: TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts32 := -TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts32;
                  {$IFNDEF IFPS3_NOINT64}
                  bts64: TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts64 := -TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts64;
                  {$ENDIF}
                  btSingle: TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tsingle := -TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tsingle;
                  btDouble: TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tdouble := -TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tdouble;
                  btExtended: TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.textended := -TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.textended;
                  btCurrency: TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tcurrency := -TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tcurrency;
                else
                  begin
                    MakeError('', ecTypeMismatch, '');
                    Result := False;
                    exit;
                  end;
                end;
                preplace := TIFPSUnValueOp(p).Val1;
                TIFPSUnValueOp(p).Val1 := nil;
                p.Free;
                p := preplace;
              end;
            otCast:
              begin
                preplace := TIFPSValueData.Create;
                TIFPSValueData(preplace).Data := NewVariant(TIFPSUnValueOp(p).FType);
                case TIFPSUnValueOp(p).FType.BaseType of
                  btU8:
                    begin
                      case TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data.Ftype.basetype of
                        btchar: TIFPSValueData(preplace).Data.tu8 := ord(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tchar);
                        {$IFNDEF IFPS3_NOWIDESTRING}
                        btwidechar: TIFPSValueData(preplace).Data.tu8 := ord(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.twidechar);
                        {$ENDIF}
                        btU8: TIFPSValueData(preplace).Data.tu8 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu8;
                        btS8: TIFPSValueData(preplace).Data.tu8 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS8;
                        btU16: TIFPSValueData(preplace).Data.tu8 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu16;
                        btS16: TIFPSValueData(preplace).Data.tu8 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS16;
                        btU32: TIFPSValueData(preplace).Data.tu8 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tU32;
                        btS32: TIFPSValueData(preplace).Data.tu8 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS32;
                        {$IFNDEF IFPS3_NOINT64}
                        btS64: TIFPSValueData(preplace).Data.tu8 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts64;
                        {$ENDIF}
                      else
                        begin
                          MakeError('', ecTypeMismatch, '');
                          preplace.Free;
                          Result := False;
                          exit;
                        end;
                      end;
                    end;
                  btS8:
                    begin
                      case TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data.Ftype.basetype of
                        btchar: TIFPSValueData(preplace).Data.ts8 := ord(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tchar);
                        {$IFNDEF IFPS3_NOWIDESTRING}
                        btwidechar: TIFPSValueData(preplace).Data.ts8 := ord(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.twidechar);
                        {$ENDIF}
                        btU8: TIFPSValueData(preplace).Data.ts8 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu8;
                        btS8: TIFPSValueData(preplace).Data.ts8 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS8;
                        btU16: TIFPSValueData(preplace).Data.ts8 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu16;
                        btS16: TIFPSValueData(preplace).Data.ts8 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS16;
                        btU32: TIFPSValueData(preplace).Data.ts8 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tU32;
                        btS32: TIFPSValueData(preplace).Data.ts8 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS32;
                        {$IFNDEF IFPS3_NOINT64}
                        btS64: TIFPSValueData(preplace).Data.ts8 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts64;
                        {$ENDIF}
                      else
                        begin
                          MakeError('', ecTypeMismatch, '');
                          preplace.Free;
                          Result := False;
                          exit;
                        end;
                      end;
                    end;
                  btU16:
                    begin
                      case TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data.Ftype.basetype of
                        btchar: TIFPSValueData(preplace).Data.tu16 := ord(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tchar);
                        {$IFNDEF IFPS3_NOWIDESTRING}
                        btwidechar: TIFPSValueData(preplace).Data.tu16 := ord(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.twidechar);
                        {$ENDIF}
                        btU8: TIFPSValueData(preplace).Data.tu16 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu8;
                        btS8: TIFPSValueData(preplace).Data.tu16 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS8;
                        btU16: TIFPSValueData(preplace).Data.ts16 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu16;
                        btS16: TIFPSValueData(preplace).Data.tu16 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS16;
                        btU32: TIFPSValueData(preplace).Data.tu16 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tU32;
                        btS32: TIFPSValueData(preplace).Data.tu16 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS32;
                        {$IFNDEF IFPS3_NOINT64}
                        btS64: TIFPSValueData(preplace).Data.tu16 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts64;
                        {$ENDIF}
                      else
                        begin
                          MakeError('', ecTypeMismatch, '');
                          preplace.Free;
                          Result := False;
                          exit;
                        end;
                      end;
                    end;
                  bts16:
                    begin
                      case TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data.Ftype.basetype of
                        btchar: TIFPSValueData(preplace).Data.ts16 := ord(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tchar);
                        {$IFNDEF IFPS3_NOWIDESTRING}
                        btwidechar: TIFPSValueData(preplace).Data.ts16 := ord(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.twidechar);
                        {$ENDIF}
                        btU8: TIFPSValueData(preplace).Data.ts16 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu8;
                        btS8: TIFPSValueData(preplace).Data.ts16 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS8;
                        btU16: TIFPSValueData(preplace).Data.ts16 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu16;
                        btS16: TIFPSValueData(preplace).Data.ts16 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS16;
                        btU32: TIFPSValueData(preplace).Data.ts16 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tU32;
                        btS32: TIFPSValueData(preplace).Data.ts16 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS32;
                        {$IFNDEF IFPS3_NOINT64}
                        btS64: TIFPSValueData(preplace).Data.ts16 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts64;
                        {$ENDIF}
                      else
                        begin
                          MakeError('', ecTypeMismatch, '');
                          preplace.Free;
                          Result := False;
                          exit;
                        end;
                      end;
                    end;
                  btU32:
                    begin
                      case TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data.Ftype.basetype of
                        btchar: TIFPSValueData(preplace).Data.tu32 := ord(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tchar);
                        {$IFNDEF IFPS3_NOWIDESTRING}
                        btwidechar: TIFPSValueData(preplace).Data.tu32 := ord(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.twidechar);
                        {$ENDIF}
                        btU8: TIFPSValueData(preplace).Data.tu32 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu8;
                        btS8: TIFPSValueData(preplace).Data.tu32 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS8;
                        btU16: TIFPSValueData(preplace).Data.tu32 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu16;
                        btS16: TIFPSValueData(preplace).Data.tu32 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS16;
                        btU32: TIFPSValueData(preplace).Data.tu32 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tU32;
                        btS32: TIFPSValueData(preplace).Data.tu32 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS32;
                        {$IFNDEF IFPS3_NOINT64}
                        btS64: TIFPSValueData(preplace).Data.tu32 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts64;
                        {$ENDIF}
                      else
                        begin
                          MakeError('', ecTypeMismatch, '');
                          preplace.Free;
                          Result := False;
                          exit;
                        end;
                      end;
                    end;
                  btS32:
                    begin
                      case TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data.Ftype.basetype of
                        btchar: TIFPSValueData(preplace).Data.ts32 := ord(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tchar);
                        {$IFNDEF IFPS3_NOWIDESTRING}
                        btwidechar: TIFPSValueData(preplace).Data.ts32 := ord(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.twidechar);
                        {$ENDIF}
                        btU8: TIFPSValueData(preplace).Data.ts32 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu8;
                        btS8: TIFPSValueData(preplace).Data.ts32 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS8;
                        btU16: TIFPSValueData(preplace).Data.ts32 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu16;
                        btS16: TIFPSValueData(preplace).Data.ts32 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS16;
                        btU32: TIFPSValueData(preplace).Data.ts32 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tU32;
                        btS32: TIFPSValueData(preplace).Data.ts32 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS32;
                        {$IFNDEF IFPS3_NOINT64}
                        btS64: TIFPSValueData(preplace).Data.tu32 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts64;
                        {$ENDIF}
                      else
                        begin
                          MakeError('', ecTypeMismatch, '');
                          preplace.Free;
                          Result := False;
                          exit;
                        end;
                      end;
                    end;
                  {$IFNDEF IFPS3_NOINT64}
                  btS64:
                    begin
                      case TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data.Ftype.basetype of
                        btchar: TIFPSValueData(preplace).Data.ts64 := ord(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tchar);
                        {$IFNDEF IFPS3_NOWIDESTRING}
                        btwidechar: TIFPSValueData(preplace).Data.ts64 := ord(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.twidechar);
                        {$ENDIF}
                        btU8: TIFPSValueData(preplace).Data.ts64 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu8;
                        btS8: TIFPSValueData(preplace).Data.ts64 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS8;
                        btU16: TIFPSValueData(preplace).Data.ts64 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu16;
                        btS16: TIFPSValueData(preplace).Data.ts64 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS16;
                        btU32: TIFPSValueData(preplace).Data.ts64 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tU32;
                        btS32: TIFPSValueData(preplace).Data.ts64 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS32;
                        btS64: TIFPSValueData(preplace).Data.ts64 := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts64;
                      else
                        begin
                          MakeError('', ecTypeMismatch, '');
                          preplace.Free;
                          Result := False;
                          exit;
                        end;
                      end;
                    end;
                  {$ENDIF}
                  btChar:
                    begin
                      case TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data.Ftype.basetype of
                        btchar: TIFPSValueData(preplace).Data.tchar := TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tchar;
                        btU8: TIFPSValueData(preplace).Data.tchar := chr(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu8);
                        btS8: TIFPSValueData(preplace).Data.tchar := chr(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS8);
                        btU16: TIFPSValueData(preplace).Data.tchar := chr(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tu16);
                        btS16: TIFPSValueData(preplace).Data.tchar := chr(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS16);
                        btU32: TIFPSValueData(preplace).Data.tchar := chr(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tU32);
                        btS32: TIFPSValueData(preplace).Data.tchar := chr(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.tS32);
                        {$IFNDEF IFPS3_NOINT64}
                        btS64: TIFPSValueData(preplace).Data.tchar := chr(TIFPSValueData(TIFPSUnValueOp(p).FVal1).Data^.ts64);
                        {$ENDIF}
                      else
                        begin
                          MakeError('', ecTypeMismatch, '');
                          Result := False;
                          preplace.Free;
                          exit;
                        end;
                      end;
                    end;
                else
                  begin
                    MakeError('', ecTypeMismatch, '');
                    Result := False;
                    preplace.Free;
                    exit;
                  end;
                end;
                p.Free;
                p := preplace;
              end;
            else
              begin
                MakeError('', ecTypeMismatch, '');
                Result := False;
                exit;
              end;
          end; // case
        end; // if
      end;
      Result := True;
    end;

  var
    Val: TIFPSValue;
  begin
    Val := ReadExpression;
    if Val = nil then
    begin
      Result := nil;
      exit;
    end;
    if not TryEvalConst(Val) then
    begin
      Val.Free;
      Result := nil;
      exit;
    end;
    Result := Val;
  end;

  function ReadParameters(IsProperty: Boolean; Dest: TIFPSParameters): Boolean;
  var
    sr,cr: TIfPasToken;
  begin
    if IsProperty then
    begin
      sr := CSTI_OpenBlock;
      cr := CSTI_CloseBlock;
    end else begin
      sr := CSTI_OpenRound;
      cr := CSTI_CloseRound;
    end;
    if FParser.CurrTokenId = sr then
    begin
      FParser.Next;
      if FParser.CurrTokenId = cr then
      begin
        FParser.Next;
        Result := True;
        exit;
      end;
    end else
    begin
      result := True;
      exit;
    end;
    repeat
      with Dest.Add do
      begin
        Val := calc(CSTI_CloseRound);
        if Val = nil then
        begin
          result := false;
          exit;
        end;
      end;
      if FParser.CurrTokenId = cr then
      begin
        FParser.Next;
        Break;
      end;
      if FParser.CurrTokenId <> CSTI_Comma then
      begin
        MakeError('', ecCommaExpected, '');
        Result := false;
        exit;
      end; {if}
      FParser.Next;
    until False;
    Result := true;
  end;
  
  function ReadProcParameters(ProcNo: Cardinal; FSelf: TIFPSValue): TIFPSValue;
  var
    Decl: TIFPSParametersDecl;
  begin
    if TIFPSProcedure(FProcs[ProcNo]).ClassType = TIFPSInternalProcedure then
      Decl := TIFPSInternalProcedure(FProcs[ProcNo]).Decl
    else
      Decl := TIFPSExternalProcedure(FProcs[ProcNo]).RegProc.Decl;
    UseProc(Decl);
    Result := TIFPSValueProcNo.Create;
    TIFPSValueProcNo(Result).ProcNo := ProcNo;
    TIFPSValueProcNo(Result).ResultType := Decl.Result;
    with TIFPSValueProcNo(Result) do
    begin
      SetParserPos(FParser);
      Parameters := TIFPSParameters.Create;
      if FSelf <> nil then
      begin
        Parameters.Add;
      end;
    end;

    if not ReadParameters(False, TIFPSValueProc(Result).Parameters) then
    begin
      Result.Free;
      Result := nil;
      exit;
    end;

    if not ValidateParameters(BlockInfo, TIFPSValueProc(Result).Parameters, Decl) then
    begin
      Result.Free;
      Result := nil;
      exit;
    end;
    if FSelf <> nil then
    begin
      with TIFPSValueProcNo(Result).Parameters[0] do
      begin
        Val := FSelf;
        ExpectedType := GetTypeNo(BlockInfo, FSelf);
      end;
    end;
  end;
  {$IFNDEF IFPS3_NOIDISPATCH}

  function ReadIDispatchParameters(const ProcName: string; FSelf: TIFPSValue): TIFPSValue;
  var
    Par: TIFPSParameters;
    PropSet: Boolean;
    i: Longint;
    Temp: TIFPSValue;
  begin
    Par := TIFPSParameters.Create;
    try
      if not ReadParameters(FParser.CurrTokenID = CSTI_OpenBlock, Par) then
      begin
        FSelf.Free;
        Result := nil;
        exit;
      end;

      if FParser.CurrTokenID = CSTI_Assignment then
      begin
        FParser.Next;
        PropSet := True;
        Temp := calc(CSTI_SemiColon);
        if temp = nil then
        begin
          FSelf.Free;
          Result := nil;
          exit;
        end;
        with par.Add do
        begin
          FValue := Temp;
        end;
      end else
      begin
        PropSet := False;
      end;

      Result := TIFPSValueProcNo.Create;
      TIFPSValueProcNo(Result).ProcNo := FindProc('IDISPATCHINVOKE');
      TIFPSValueProcNo(Result).ResultType := FindBaseType(btVariant);
      with TIFPSValueProcNo(Result) do
      begin
        SetParserPos(FParser);
        Parameters := TIFPSParameters.Create;
        if FSelf <> nil then
        begin
          with Parameters.Add do
          begin
            Val := FSelf;
            ExpectedType := at2ut(FindType('IDISPATCH'));
          end;
          with Parameters.Add do
          begin
            Val := TIFPSValueData.Create;
            TIFPSValueData(Val).Data := NewVariant(FDefaultBoolType);
            TIFPSValueData(Val).Data.tu8 := Ord(PropSet);
            ExpectedType := FDefaultBoolType;
          end;

          with Parameters.Add do
          begin
            Val := TIFPSValueData.Create;
            TIFPSValueData(Val).Data := NewVariant(FindBaseType(btString));
            string(TIFPSValueData(Val).data.tString) := Procname;
            ExpectedType := FindBaseType(btString);
          end;

          with Parameters.Add do
          begin
            val := TIFPSValueArray.Create;
            ExpectedType := at2ut(FindAndAddType(Self, '!OPENARRAYOFVARIANT', 'array of variant'));
            temp := Val;
          end;
          for i := 0 to Par.Count -1 do
          begin
            TIFPSValueArray(Temp).Add(par.Item[i].Val);
            par.Item[i].val := nil;
          end;
        end;
      end;
    finally
      Par.Free;
    end;

  end;

  {$ENDIF}

  function ReadVarParameters(ProcNoVar: TIFPSValue): TIFPSValue;
  var
    Decl: TIFPSParametersDecl;
  begin
    Decl := TIFPSProceduralType(GetTypeNo(BlockInfo, ProcnoVar)).ProcDef;
    UseProc(Decl);

    Result := TIFPSValueProcVal.Create;

    with TIFPSValueProcVal(Result) do
    begin
      ResultType := Decl.Result;
      ProcNo := ProcNoVar;
      Parameters := TIFPSParameters.Create;
    end;

    if not ReadParameters(False, TIFPSValueProc(Result).Parameters) then
    begin
      Result.Free;
      Result := nil;
      exit;
    end;

    if not ValidateParameters(BlockInfo, TIFPSValueProc(Result).Parameters, Decl) then
    begin
      Result.Free;
      Result := nil;
      exit;
    end;
  end;


  function WriteCalculation(InData, OutReg: TIFPSValue): Boolean;

    function CheckOutreg(Where, Outreg: TIFPSValue): Boolean;
    var
      i: Longint;
    begin
      Result := False;
      if Where.ClassType = TIFPSUnValueOp then
      begin
        if CheckOutReg(TIFPSUnValueOp(Where).Val1, OutReg) then
          Result := True;
      end else if Where.ClassType = TIFPSBinValueOp then
      begin
        if CheckOutreg(TIFPSBinValueOp(Where).Val1, OutReg) or CheckOutreg(TIFPSBinValueOp(Where).Val2, OutReg) then
          Result := True;
      end else if Where is TIFPSValueVar then
      begin
        if SameReg(Where, OutReg) then
          Result := True;
      end else if Where is TIFPSValueProc then
      begin
        for i := 0 to TIFPSValueProc(Where).Parameters.Count -1 do
        begin
          if Checkoutreg(TIFPSValueProc(Where).Parameters[i].Val, Outreg) then
          begin
            Result := True;
            break;
          end;
        end;
      end;
    end;
  begin
    if not CheckCompatType(Outreg, InData) then
    begin
      MakeError('', ecTypeMismatch, '');
      Result := False;
      exit;
    end;
    if SameReg(OutReg, InData) then
    begin
      Result := True;
      exit;
    end;
    if InData is TIFPSValueProc then
    begin
      Result := ProcessFunction(TIFPSValueProc(indata), OutReg)
    end else begin
      if not PreWriteOutRec(OutReg, nil) then
      begin
        Result := False;
        exit;
      end;
      if (not CheckOutReg(InData, OutReg)) and (InData is TIFPSBinValueOp) or (InData is TIFPSUnValueOp) then
      begin
        if InData is TIFPSBinValueOp then
        begin
          if not DoBinCalc(TIFPSBinValueOp(InData), OutReg) then
          begin
            AfterWriteOutRec(OutReg);
            Result := False;
            exit;
          end;
        end else
        begin
          if not DoUnCalc(TIFPSUnValueOp(InData), OutReg) then
          begin
            AfterWriteOutRec(OutReg);
            Result := False;
            exit;
          end;
        end;
      end else if (InData is TIFPSBinValueOp) and (not CheckOutReg(TIFPSBinValueOp(InData).Val2, OutReg)) then
      begin
        if not DoBinCalc(TIFPSBinValueOp(InData), OutReg) then
        begin
          AfterWriteOutRec(OutReg);
          Result := False;
          exit;
        end;
      end else begin
        if not PreWriteOutRec(InData, GetTypeNo(BlockInfo, OutReg)) then
        begin
          Result := False;
          exit;
        end;
        BlockWriteByte(BlockInfo, CM_A);
        if not (WriteOutRec(OutReg, False) and WriteOutRec(InData, True)) then
        begin
          Result := False;
          exit;
        end;
        AfterWriteOutRec(InData);
      end;
      AfterWriteOutRec(OutReg);
      Result := True;
    end;
  end; {WriteCalculation}


  function ProcessFunction(ProcCall: TIFPSValueProc; ResultRegister: TIFPSValue): Boolean;
  var
    res: TIFPSType;
    tmp: TIFPSParameter;
    resreg: TIFPSValue;
    l: Longint;

    function Cleanup: Boolean;
    var
      i: Longint;
    begin
      for i := 0 to ProcCall.Parameters.Count -1 do
      begin
        if ProcCall.Parameters[i].TempVar <> nil then
          ProcCall.Parameters[i].TempVar.Free;
        ProcCall.Parameters[i].TempVar := nil;
      end;
      if ProcCall is TIFPSValueProcVal then
        AfterWriteOutRec(TIFPSValueProcVal(ProcCall).fProcNo);
      if ResReg <> nil then
        AfterWriteOutRec(resreg);
      if ResReg <> nil then
      begin
        if ResReg <> ResultRegister then
        begin
          if ResultRegister <> nil then
          begin
            if not WriteCalculation(ResReg, ResultRegister) then
            begin
              Result := False;
              resreg.Free;
              exit;
            end;
          end;
          resreg.Free;
        end;
      end;
      Result := True;
    end;

  begin
    Res := ProcCall.ResultType;
    Result := False;
    if (res = nil) and (ResultRegister <> nil) then
    begin
      MakeError('', ecNoResult, '');
      exit;
    end
    else if (res <> nil)  then
    begin
      if (ResultRegister = nil) or (Res <> GetTypeNo(BlockInfo, ResultRegister)) then
      begin
        resreg := AllocStackReg(res);
      end else resreg := ResultRegister;
    end
    else
      resreg := nil;
    if ResReg <> nil then
    begin
      if not PreWriteOutRec(resreg, nil) then
      begin
        Cleanup;
        exit;
      end;
    end;
    if Proccall is TIFPSValueProcVal then
    begin
      if not PreWriteOutRec(TIFPSValueProcVal(ProcCall).fProcNo, nil) then
      begin
        Cleanup;
        exit;
      end;
    end;
    for l := ProcCall.Parameters.Count - 1 downto 0 do
    begin
      Tmp := ProcCall.Parameters[l];
      if (Tmp.ParamMode <> pmIn)  then
      begin
        tmp.TempVar := AllocPointer(GetTypeNo(BlockInfo, Tmp.FValue));
//        tmp.TempVar := AllocStackReg2(Tmp.ExpectedType);
        if not PreWriteOutRec(Tmp.FValue, nil) then
        begin
          cleanup;
          exit;
        end;
        BlockWriteByte(BlockInfo, cm_sp);
        WriteOutRec(tmp.TempVar, False);
        WriteOutRec(Tmp.FValue, False);
        AfterWriteOutRec(Tmp.FValue);
      end
      else
      begin
        if Tmp.ExpectedType = nil then
          Tmp.ExpectedType := GetTypeNo(BlockInfo, tmp.Val);
        if Tmp.ExpectedType.BaseType = btPChar then
        begin
          Tmp.TempVar := AllocStackReg(at2ut(FindBaseType(btstring)))
        end else
        begin
        Tmp.TempVar := AllocStackReg(Tmp.ExpectedType);
        end;
        if not WriteCalculation(Tmp.Val, Tmp.TempVar) then
        begin
          Cleanup;
          exit;
        end;
      end;
    end; {for}
    if res <> nil then
    begin
      BlockWriteByte(BlockInfo, CM_PV);

      if not WriteOutRec(resreg, False) then
      begin
        Cleanup;
        MakeError('', ecInternalError, '00015');
        exit;
      end;
    end;
    if ProcCall is TIFPSValueProcVal then
    begin
      BlockWriteByte(BlockInfo, Cm_cv);
      WriteOutRec(TIFPSValueProcVal(ProcCall).ProcNo, True);
    end else begin
      BlockWriteByte(BlockInfo, CM_C);
      BlockWriteLong(BlockInfo, TIFPSValueProcNo(ProcCall).ProcNo);
    end;
    if res <> nil then
      BlockWriteByte(BlockInfo, CM_PO);
    if not Cleanup then
    begin
      Result := False;
      exit;
    end;
    Result := True;
  end; {ProcessVarFunction}

  function HasInvalidJumps(StartPos, EndPos: Cardinal): Boolean;
  var
    I, J: Longint;
    Ok: LongBool;
    FLabelsInBlock: TIfStringList;
    s: string;
  begin
    FLabelsInBlock := TIfStringList.Create;
    for i := 0 to BlockInfo.Proc.FLabels.Count -1 do
    begin
      s := BlockInfo.Proc.FLabels[I];
      if (Cardinal((@s[1])^) >= StartPos) and (Cardinal((@s[1])^) <= EndPos) then
      begin
        Delete(s, 1, 8);
        FLabelsInBlock.Add(s);
      end;
    end;
    for i := 0 to BlockInfo.Proc.FGotos.Count -1 do
    begin
      s := BlockInfo.Proc.FGotos[I];
      if (Cardinal((@s[1])^) >= StartPos) and (Cardinal((@s[1])^) <= EndPos) then
      begin
        Delete(s, 1, 8);
        OK := False;
        for J := 0 to FLabelsInBlock.Count -1 do
        begin
          if FLabelsInBlock[J] = s then
          begin
            Ok := True;
            Break;
          end;
        end;
        if not Ok then
        begin
          MakeError('', ecInvalidJump, '');
          Result := True;
          FLabelsInBlock.Free;
          exit;
        end;
      end else begin
        Delete(s, 1, 4);
        OK := True;
        for J := 0 to FLabelsInBlock.Count -1 do
        begin
          if FLabelsInBlock[J] = s then
          begin
            Ok := False;
            Break;
          end;
        end;
        if not Ok then
        begin
          MakeError('', ecInvalidJump, '');
          Result := True;
          FLabelsInBlock.Free;
          exit;
        end;
      end;
    end;
    FLabelsInBlock.Free;
    Result := False;
  end;

  function ProcessFor: Boolean;
    { Process a for x := y to z do }
  var
    VariableVar: TIFPSValue;
      TempBool,
      InitVal,
      finVal: TIFPSValue;
    Block: TIFPSBlockInfo;
    Backwards: Boolean;
    FPos, NPos, EPos, RPos: Longint;
    OldCO, OldBO: TIfList;
    I: Longint;
  begin
    Debug_WriteLine(BlockInfo);
    Result := False;
    FParser.Next;
    if FParser.CurrTokenId <> CSTI_Identifier then
    begin
      MakeError('', ecIdentifierExpected, '');
      exit;
    end;
    VariableVar := GetIdentifier(1);
    if VariableVar = nil then
      exit;
    case GetTypeNo(BlockInfo, VariableVar).BaseType of
      btU8, btS8, btU16, btS16, btU32, btS32: ;
    else
      begin
        MakeError('', ecTypeMismatch, '');
        VariableVar.Free;
        exit;
      end;
    end;
    if FParser.CurrTokenId <> CSTI_Assignment then
    begin
      MakeError('', ecAssignmentExpected, '');
      VariableVar.Free;
      exit;
    end;
    FParser.Next;
    InitVal := calc(CSTII_DownTo);
    if InitVal = nil then
    begin
      VariableVar.Free;
      exit;
    end;
    if FParser.CurrTokenId = CSTII_To then
      Backwards := False
    else if FParser.CurrTokenId = CSTII_DownTo then
      Backwards := True
    else
    begin
      MakeError('', ecToExpected, '');
      VariableVar.Free;
      InitVal.Free;
      exit;
    end;
    FParser.Next;
    finVal := calc(CSTII_do);
    if finVal = nil then
    begin
      VariableVar.Free;
      InitVal.Free;
      exit;
    end;
    if FParser.CurrTokenId <> CSTII_do then
    begin
      MakeError('', ecDoExpected, '');
      finVal.Free;
      InitVal.Free;
      VariableVar.Free;
      exit;
    end;
    FParser.Next;
    if not WriteCalculation(InitVal, VariableVar) then
    begin
      VariableVar.Free;
      InitVal.Free;
      finVal.Free;
      exit;
    end;
    InitVal.Free;
    TempBool := AllocStackReg(at2ut(FDefaultBoolType));
    NPos := Length(BlockInfo.Proc.Data);
    if not (PreWriteOutRec(VariableVar, nil) and PreWriteOutRec(finVal, nil)) then
    begin
      TempBool.Free;
      VariableVar.Free;
      finVal.Free;
      exit;
    end;
    BlockWriteByte(BlockInfo, CM_CO);
    if Backwards then
    begin
      BlockWriteByte(BlockInfo, 0); { >= }
    end
    else
    begin
      BlockWriteByte(BlockInfo, 1); { <= }
    end;
    if not (WriteOutRec(TempBool, False) and WriteOutRec(VariableVar, True) and WriteOutRec(finVal, True)) then
    begin
      TempBool.Free;
      VariableVar.Free;
      finVal.Free;
      exit;
    end;
    AfterWriteOutRec(finVal);
    AfterWriteOutRec(VariableVar);
    finVal.Free;
    BlockWriteByte(BlockInfo, Cm_CNG);
    EPos := Length(BlockInfo.Proc.Data);
    BlockWriteLong(BlockInfo, $12345678);
    WriteOutRec(TempBool, False);
    RPos := Length(BlockInfo.Proc.Data);
    OldCO := FContinueOffsets;
    FContinueOffsets := TIfList.Create;
    OldBO := FBreakOffsets;
    FBreakOffsets := TIFList.Create;
    Block := TIFPSBlockInfo.Create(BlockInfo);
    Block.SubType := tOneLiner;
    if not ProcessSub(Block) then
    begin
      Block.Free;
      TempBool.Free;
      VariableVar.Free;
      FBreakOffsets.Free;
      FContinueOffsets.Free;
      FContinueOffsets := OldCO;
      FBreakOffsets := OldBo;
      exit;
    end;
    Block.Free;
    FPos := Length(BlockInfo.Proc.Data);
    if not PreWriteOutRec(VariableVar, nil) then
    begin
      TempBool.Free;
      VariableVar.Free;
      FBreakOffsets.Free;
      FContinueOffsets.Free;
      FContinueOffsets := OldCO;
      FBreakOffsets := OldBo;
      exit;
    end;
    if Backwards then
      BlockWriteByte(BlockInfo, cm_dec)
    else
      BlockWriteByte(BlockInfo, cm_inc);
    if not WriteOutRec(VariableVar, False) then
    begin
      TempBool.Free;
      VariableVar.Free;
      FBreakOffsets.Free;
      FContinueOffsets.Free;
      FContinueOffsets := OldCO;
      FBreakOffsets := OldBo;
      exit;
    end;
    AfterWriteOutRec(VariableVar);
    BlockWriteByte(BlockInfo, Cm_G);
    BlockWriteLong(BlockInfo, Longint(NPos - Length(BlockInfo.Proc.Data) - 4));
    Longint((@BlockInfo.Proc.Data[EPos + 1])^) := Length(BlockInfo.Proc.Data) - RPos;
    for i := 0 to FBreakOffsets.Count -1 do
    begin
      EPos := Cardinal(FBreakOffsets[I]);
      Longint((@BlockInfo.Proc.Data[EPos - 3])^) := Length(BlockInfo.Proc.Data) - Longint(EPos);
    end;
    for i := 0 to FContinueOffsets.Count -1 do
    begin
      EPos := Cardinal(FContinueOffsets[I]);
      Longint((@BlockInfo.Proc.Data[EPos - 3])^) := Longint(FPos) - Longint(EPos);
    end;
    FBreakOffsets.Free;
    FContinueOffsets.Free;
    FContinueOffsets := OldCO;
    FBreakOffsets := OldBo;
    TempBool.Free;
    VariableVar.Free;
    if HasInvalidJumps(RPos, Length(BlockInfo.Proc.Data)) then
    begin
      Result := False;
      exit;
    end;
    Result := True;
  end; {ProcessFor}

  function ProcessWhile: Boolean;
  var
    vin, vout: TIFPSValue;
    SPos, EPos: Cardinal;
    OldCo, OldBO: TIfList;
    I: Longint;
    Block: TIFPSBlockInfo;
  begin
    Result := False;
    Debug_WriteLine(BlockInfo);
    FParser.Next;
    vout := calc(CSTII_do);
    if vout = nil then
      exit;
    if FParser.CurrTokenId <> CSTII_do then
    begin
      vout.Free;
      MakeError('', ecDoExpected, '');
      exit;
    end;
    vin := AllocStackReg(at2ut(FDefaultBoolType));
    SPos := Length(BlockInfo.Proc.Data); // start position
    OldCo := FContinueOffsets;
    FContinueOffsets := TIfList.Create;
    OldBO := FBreakOffsets;
    FBreakOffsets := TIFList.Create;
    if not WriteCalculation(vout, vin) then
    begin
      vout.Free;
      vin.Free;
      FBreakOffsets.Free;
      FContinueOffsets.Free;
      FContinueOffsets := OldCO;
      FBreakOffsets := OldBo;
      exit;
    end;
    vout.Free;
    FParser.Next; // skip DO
    BlockWriteByte(BlockInfo, Cm_CNG); // only goto if expression is false
    BlockWriteLong(BlockInfo, $12345678);
    EPos := Length(BlockInfo.Proc.Data);
    if not WriteOutRec(vin, False) then
    begin
      MakeError('', ecInternalError, '00017');
      vin.Free;
      FBreakOffsets.Free;
      FContinueOffsets.Free;
      FContinueOffsets := OldCO;
      FBreakOffsets := OldBo;
      exit;
    end;
    Block := TIFPSBlockInfo.Create(BlockInfo);
    Block.SubType := tOneLiner;
    if not ProcessSub(Block) then
    begin
      Block.Free;
      vin.Free;
      FBreakOffsets.Free;
      FContinueOffsets.Free;
      FContinueOffsets := OldCO;
      FBreakOffsets := OldBo;
      exit;
    end;
    Block.Free;
    Debug_WriteLine(BlockInfo);
    BlockWriteByte(BlockInfo, Cm_G);
    BlockWriteLong(BlockInfo, Longint(SPos) - Length(BlockInfo.Proc.Data) - 4);
    Longint((@BlockInfo.Proc.Data[EPos - 3])^) := Length(BlockInfo.Proc.Data) - Longint(EPos) - 5;
    for i := 0 to FBreakOffsets.Count -1 do
    begin
      EPos := Cardinal(FBreakOffsets[I]);
      Longint((@BlockInfo.Proc.Data[EPos - 3])^) := Length(BlockInfo.Proc.Data) - Longint(EPos);
    end;
    for i := 0 to FContinueOffsets.Count -1 do
    begin
      EPos := Cardinal(FContinueOffsets[I]);
      Longint((@BlockInfo.Proc.Data[EPos - 3])^) := Longint(SPos) - Longint(EPos);
    end;
    FBreakOffsets.Free;
    FContinueOffsets.Free;
    FContinueOffsets := OldCO;
    FBreakOffsets := OldBo;
    vin.Free;
    if HasInvalidJumps(EPos, Length(BlockInfo.Proc.Data)) then
    begin
      Result := False;
      exit;
    end;
    Result := True;
  end;

  function ProcessRepeat: Boolean;
  var
    vin, vout: TIFPSValue;
    CPos, SPos, EPos: Cardinal;
    I: Longint;
    OldCo, OldBO: TIfList;
    Block: TIFPSBlockInfo;
  begin
    Result := False;
    Debug_WriteLine(BlockInfo);
    FParser.Next;
    OldCo := FContinueOffsets;
    FContinueOffsets := TIfList.Create;
    OldBO := FBreakOffsets;
    FBreakOffsets := TIFList.Create;
    vin := AllocStackReg(at2ut(FDefaultBoolType));
    SPos := Length(BlockInfo.Proc.Data);
    Block := TIFPSBlockInfo.Create(BlockInfo);
    Block.SubType := tRepeat;
    if not ProcessSub(Block) then
    begin
      Block.Free;
      FBreakOffsets.Free;
      FContinueOffsets.Free;
      FContinueOffsets := OldCO;
      FBreakOffsets := OldBo;
      vin.Free;
      exit;
    end;
    Block.Free;
    FParser.Next; //cstii_until
    vout := calc(CSTI_Semicolon);
    if vout = nil then
    begin
      FBreakOffsets.Free;
      FContinueOffsets.Free;
      FContinueOffsets := OldCO;
      FBreakOffsets := OldBo;
      vin.Free;
      exit;
    end;
    CPos := Length(BlockInfo.Proc.Data);
    if not WriteCalculation(vout, vin) then
    begin
      vout.Free;
      vin.Free;
      FBreakOffsets.Free;
      FContinueOffsets.Free;
      FContinueOffsets := OldCO;
      FBreakOffsets := OldBo;
      exit;
    end;
    vout.Free;
    BlockWriteByte(BlockInfo, Cm_CNG);
    BlockWriteLong(BlockInfo, $12345678);
    EPos := Length(BlockInfo. Proc.Data);
    if not WriteOutRec(vin, False) then
    begin
      MakeError('', ecInternalError, '00016');
      vin.Free;
      FBreakOffsets.Free;
      FContinueOffsets.Free;
      FContinueOffsets := OldCO;
      FBreakOffsets := OldBo;
      exit;
    end;
    Longint((@BlockInfo.Proc.Data[EPos - 3])^) := Longint(SPos) -
      Length(BlockInfo.Proc.Data);
    for i := 0 to FBreakOffsets.Count -1 do
    begin
      EPos := Cardinal(FBreakOffsets[I]);
      Longint((@BlockInfo.Proc.Data[EPos - 3])^) := Length(BlockInfo. Proc.Data) - Longint(EPos);
    end;
    for i := 0 to FContinueOffsets.Count -1 do
    begin
      EPos := Cardinal(FContinueOffsets[I]);
      Longint((@BlockInfo.Proc.Data[EPos - 3])^) := Longint(CPos) - Longint(EPos);
    end;
    FBreakOffsets.Free;
    FContinueOffsets.Free;
    FContinueOffsets := OldCO;
    FBreakOffsets := OldBo;
    vin.Free;
    if HasInvalidJumps(SPos, Length(BlockInfo. Proc.Data)) then
    begin
      Result := False;
      exit;
    end;
    Result := True;
  end; {ProcessRepeat}

  function ProcessIf: Boolean;
  var
    vout, vin: TIFPSValue;
    SPos, EPos: Cardinal;
    Block: TIFPSBlockInfo;
  begin
    Result := False;
    Debug_WriteLine(BlockInfo);
    FParser.Next;
    vout := calc(CSTII_Then);
    if vout = nil then
      exit;
    if FParser.CurrTokenId <> CSTII_Then then
    begin
      vout.Free;
      MakeError('', ecThenExpected, '');
      exit;
    end;
    vin := AllocStackReg(at2ut(FDefaultBoolType));
    if not WriteCalculation(vout, vin) then
    begin
      vout.Free;
      vin.Free;
      exit;
    end;
    vout.Free;
    BlockWriteByte(BlockInfo, cm_sf);
    if not WriteOutRec(vin, False) then
    begin
      MakeError('', ecInternalError, '00018');
      vin.Free;
      exit;
    end;
    BlockWriteByte(BlockInfo, 1);
    vin.Free;
    BlockWriteByte(BlockInfo, cm_fg);
    BlockWriteLong(BlockInfo, $12345678);
    SPos := Length(BlockInfo.Proc.Data);
    FParser.Next; // skip then
    Block := TIFPSBlockInfo.Create(BlockInfo);
    Block.SubType := tifOneliner;
    if not ProcessSub(Block) then
    begin
      Block.Free;
      exit;
    end;
    Block.Free;
    if FParser.CurrTokenId = CSTII_Else then
    begin
      BlockWriteByte(BlockInfo, Cm_G);
      BlockWriteLong(BlockInfo, $12345678);
      EPos := Length(BlockInfo.Proc.Data);
      Longint((@BlockInfo.Proc.Data[SPos - 3])^) := Length(BlockInfo.Proc.Data) - Longint(SPos);
      FParser.Next;
      Block := TIFPSBlockInfo.Create(BlockInfo);
      Block.SubType := tOneLiner;
      if not ProcessSub(Block) then
      begin
        Block.Free;
        exit;
      end;
      Block.Free;
      Longint((@BlockInfo.Proc.Data[EPos - 3])^) := Length(BlockInfo.Proc.Data) - Longint(EPos);
    end
    else
    begin
      Longint((@BlockInfo.Proc.Data[SPos - 3])^) := Length(BlockInfo.Proc.Data) - Longint(SPos) + 5 - 5;
    end;
    Result := True;
  end; {ProcessIf}

  function ProcessLabel: Longint; {0 = failed; 1 = successful; 2 = no label}
  var
    I, H: Longint;
    s: string;
  begin
    h := MakeHash(FParser.GetToken);
    for i := 0 to BlockInfo.Proc.FLabels.Count -1 do
    begin
      s := BlockInfo.Proc.FLabels[I];
      delete(s, 1, 4);
      if Longint((@s[1])^) = h then
      begin
        delete(s, 1, 4);
        if s = FParser.GetToken then
        begin
          s := BlockInfo.Proc.FLabels[I];
          Cardinal((@s[1])^) := Length(BlockInfo.Proc.Data);
          BlockInfo.Proc.FLabels[i] := s;
          FParser.Next;
          if fParser.CurrTokenId = CSTI_Colon then
          begin
            Result := 1;
            FParser.Next;
            exit;
          end else begin
            MakeError('', ecColonExpected, '');
            Result := 0;
            Exit;
          end;
        end;
      end;
    end;
    result := 2;
  end;

  function ProcessIdentifier: Boolean;
  var
    vin, vout: TIFPSValue;
  begin
    Result := False;
    Debug_WriteLine(BlockInfo);
    vin := GetIdentifier(2);
    if vin <> nil then
    begin
      if vin is TIFPSValueVar then
      begin // assignment needed
        if FParser.CurrTokenId <> CSTI_Assignment then
        begin
          MakeError('', ecAssignmentExpected, '');
          vin.Free;
          exit;
        end;
        FParser.Next;
        vout := calc(CSTI_Semicolon);
        if vout = nil then
        begin
          vin.Free;
          exit;
        end;
        if not WriteCalculation(vout, vin) then
        begin
          vin.Free;
          vout.Free;
          exit;
        end;
        vin.Free;
        vout.Free;
      end else if vin is TIFPSValueProc then
      begin
        Result := ProcessFunction(TIFPSValueProc(vin), nil);
        vin.Free;
        Exit;
      end else
      begin
        MakeError('', ecInternalError, '20');
        vin.Free;
        REsult := False;
        exit;
      end;
    end
    else
    begin
      Result := False;
      exit;
    end;
    Result := True;
  end; {ProcessIdentifier}

  function ProcessCase: Boolean;
  var
    V1, TempRec, Val, CalcItem: TIFPSValue;
    p: TIFPSBinValueOp;
    SPos, CurrP: Cardinal;
    I: Longint;
    EndReloc: TIfList;
    Block: TIFPSBlockInfo;

    function NewRec(val: TIFPSValue): TIFPSValueReplace;
    begin
      Result := TIFPSValueReplace.Create;
      Result.SetParserPos(FParser);
      Result.FNewValue := Val;
      Result.FreeNewValue := False;
    end;

    function Combine(v1, v2: TIFPSValue): TIFPSValue;
    begin
      if V1 = nil then
      begin
        Result := v2;
      end else if v2 = nil then
      begin
        Result := V1;
      end else
      begin
        Result := TIFPSBinValueOp.Create;
        TIFPSBinValueOp(Result).FType := FDefaultBoolType;
        TIFPSBinValueOp(Result).Operator := otOr;
        Result.SetParserPos(FParser);
        TIFPSBinValueOp(Result).FVal1 := V1;
        TIFPSBinValueOp(Result).FVal2 := V2;
      end;
    end;

  begin
    Debug_WriteLine(BlockInfo);
    FParser.Next;
    Val := calc(CSTII_of);
    if Val = nil then
    begin
      ProcessCase := False;
      exit;
    end; {if}
    if FParser.CurrTokenId <> CSTII_Of then
    begin
      MakeError('', ecOfExpected, '');
      val.Free;
      ProcessCase := False;
      exit;
    end; {if}
    FParser.Next;
    TempRec := AllocStackReg(GetTypeNo(BlockInfo, Val));
    if not WriteCalculation(Val, TempRec) then
    begin
      TempRec.Free;
      val.Free;
      ProcessCase := False;
      exit;
    end; {if}
    val.Free;
    EndReloc := TIfList.Create;
    CalcItem := AllocStackReg(at2ut(FDefaultBoolType));
    SPos := Length(BlockInfo.Proc.Data);
    repeat
      V1 := nil;
      while true do
      begin
        Val := calc(CSTI_Colon);
        if (Val = nil) then
        begin
          V1.Free;
          CalcItem.Free;
          TempRec.Free;
          EndReloc.Free;
          ProcessCase := False;
          exit;
        end; {if}
        p := TIFPSBinValueOp.Create;
        p.SetParserPos(FParser);
        p.Operator := otEqual;
        p.aType := at2ut(FDefaultBoolType);
        p.Val1 := Val;
        p.Val2 := NewRec(TempRec);
        V1 := Combine(V1, P);
        if FParser.CurrTokenId = CSTI_Colon then Break;
        if FParser.CurrTokenID <> CSTI_Comma then
        begin
          MakeError('', ecColonExpected, '');
          V1.Free;
          CalcItem.Free;
          TempRec.Free;
          EndReloc.Free;
          ProcessCase := False;
          exit;
        end;
        FParser.Next;
      end;
      FParser.Next;
      if not WriteCalculation(V1, CalcItem) then
      begin
        CalcItem.Free;
        v1.Free;
        EndReloc.Free;
        ProcessCase := False;
        exit;
      end;
      v1.Free;
      BlockWriteByte(BlockInfo, Cm_CNG);
      BlockWriteLong(BlockInfo, $12345678);
      CurrP := Length(BlockInfo.Proc.Data);
      WriteOutRec(CalcItem, False);
      Block := TIFPSBlockInfo.Create(BlockInfo);
      Block.SubType := tifOneliner;
      if not ProcessSub(Block) then
      begin
        Block.Free;
        CalcItem.Free;
        TempRec.Free;
        EndReloc.Free;
        ProcessCase := False;
        exit;
      end;
      Block.Free;
      BlockWriteByte(BlockInfo, Cm_G);
      BlockWriteLong(BlockInfo, $12345678);
      EndReloc.Add(Pointer(Length(BlockInfo.Proc.Data)));
      Cardinal((@BlockInfo.Proc.Data[CurrP - 3])^) := Cardinal(Length(BlockInfo.Proc.Data)) - CurrP - 5;
      if FParser.CurrTokenID = CSTI_Semicolon then FParser.Next;
      if FParser.CurrTokenID = CSTII_Else then
      begin
        FParser.Next;
        Block := TIFPSBlockInfo.Create(BlockInfo);
        Block.SubType := tOneliner;
        if not ProcessSub(Block) then
        begin
          Block.Free;
          CalcItem.Free;
          TempRec.Free;
          EndReloc.Free;
          ProcessCase := False;
          exit;
        end;
        Block.Free;
        if FParser.CurrTokenID = CSTI_Semicolon then FParser.Next;
        if FParser.CurrtokenId <> CSTII_End then
        begin
          MakeError('', ecEndExpected, '');
          CalcItem.Free;
          TempRec.Free;
          EndReloc.Free;
          ProcessCase := False;
          exit;
        end;
      end;
    until FParser.CurrTokenID = CSTII_End;
    FParser.Next;
    for i := 0 to EndReloc.Count -1 do
    begin
      Cardinal((@BlockInfo.Proc.Data[Cardinal(EndReloc[I])- 3])^) := Cardinal(Length(BlockInfo.Proc.Data)) - Cardinal(EndReloc[I]);
    end;
    CalcItem.Free;
    TempRec.Free;
    EndReloc.Free;
    if HasInvalidJumps(SPos, Length(BlockInfo.Proc.Data)) then
    begin
      Result := False;
      exit;
    end;
    Result := True;
  end; {ProcessCase}
  function ProcessGoto: Boolean;
  var
    I, H: Longint;
    s: string;
  begin
    Debug_WriteLine(BlockInfo);
    FParser.Next;
    h := MakeHash(FParser.GetToken);
    for i := 0 to BlockInfo.Proc.FLabels.Count -1 do
    begin
      s := BlockInfo.Proc.FLabels[I];
      delete(s, 1, 4);
      if Longint((@s[1])^) = h then
      begin
        delete(s, 1, 4);
        if s = FParser.GetToken then
        begin
          FParser.Next;
          BlockWriteByte(BlockInfo, Cm_G);
          BlockWriteLong(BlockInfo, $12345678);
          BlockInfo.Proc.FGotos.Add(IFPS3_mi2s(length(BlockInfo.Proc.Data))+IFPS3_mi2s(i));
          Result := True;
          exit;
        end;
      end;
    end;
    MakeError('', ecUnknownIdentifier, FParser.OriginalToken);
    Result := False;
  end; {ProcessGoto}

  function ProcessWith: Boolean;
  var
    Block: TIFPSBlockInfo;
    aVar, aReplace: TIFPSValue;
    aType: TIFPSType;
  begin
    Debug_WriteLine(BlockInfo);
    Block := TIFPSBlockInfo.Create(BlockInfo);
    Block.SubType := tOneLiner;

    FParser.Next;
    repeat
      aVar := GetIdentifier(0);
      if aVar = nil then
      begin
        block.Free;
        Result := False;
        exit;
      end;
      AType := GetTypeNo(BlockInfo, aVar);
      if (AType = nil) or ((aType.BaseType <> btRecord) and (aType.BaseType <> btClass)) then
      begin
        MakeError('', ecClassTypeExpected, '');
        Block.Free;
        Result := False;
        exit;
      end;

      aReplace := TIFPSValueReplace.Create;
      aReplace.SetParserPos(FParser);
      TIFPSValueReplace(aReplace).FreeOldValue := True;
      TIFPSValueReplace(aReplace).FreeNewValue := True;
      TIFPSValueReplace(aReplace).OldValue := aVar;
      TIFPSValueReplace(aReplace).NewValue := AllocStackReg(GetTypeNo(BlockInfo, aVar));
      if not WriteCalculation(aVar, TIFPSValueReplace(aReplace).NewValue) then
      begin
        aReplace.Free;
        Block.Free;
        Result := False;
        exit;
      end;
      Block.WithList.Add(aReplace);

      if FParser.CurrTokenID = CSTII_do then
      begin
        FParser.Next;
        Break;
      end else
      if FParser.CurrTokenId <> CSTI_Comma then
      begin
        MakeError('', ecDoExpected, '');
        Block.Free;
        Result := False;
        exit;
      end;
      FParser.Next;
    until False;

    if not ProcessSub(Block) then
    begin
      Block.Free;
      Result := False;
      exit;
    end;
    Block.Free;
    Result := True;
  end;

  function ProcessTry: Boolean;
  var
    FStartOffset: Cardinal;
    Block: TIFPSBlockInfo;
  begin
    FParser.Next;
    BlockWriteByte(BlockInfo, cm_puexh);
    FStartOffset := Length(BlockInfo.Proc.Data) + 1;
    BlockWriteLong(BlockInfo, InvalidVal);
    BlockWriteLong(BlockInfo, InvalidVal);
    BlockWriteLong(BlockInfo, InvalidVal);
    BlockWriteLong(BlockInfo, InvalidVal);
    Block := TIFPSBlockInfo.Create(BlockInfo);
    Block.SubType := tTry;
    if ProcessSub(Block) then
    begin
      Block.Free;
      BlockWriteByte(BlockInfo, cm_poexh);
      BlockWriteByte(BlockInfo, 0);
      if FParser.CurrTokenID = CSTII_Except then
      begin
        FParser.Next;
        Cardinal((@BlockInfo.Proc.Data[FStartOffset + 4])^) := Cardinal(Length(BlockInfo.Proc.Data)) - FStartOffset - 15;
        Block := TIFPSBlockInfo.Create(BlockInfo);
        Block.SubType := tTryEnd;
        if ProcessSub(Block) then
        begin
          Block.Free;
          BlockWriteByte(BlockInfo, cm_poexh);
          BlockWriteByte(BlockInfo, 2);
          if FParser.CurrTokenId = CSTII_Finally then
          begin
            Cardinal((@BlockInfo.Proc.Data[FStartOffset + 8])^) := Cardinal(Length(BlockInfo.Proc.Data)) - FStartOffset - 15;
            Block := TIFPSBlockInfo.Create(BlockInfo);
            Block.SubType := tTryEnd;
            FParser.Next;
            if ProcessSub(Block) then
            begin
              Block.Free;
              if FParser.CurrTokenId = CSTII_End then
              begin
                BlockWriteByte(BlockInfo, cm_poexh);
                BlockWriteByte(BlockInfo, 3);
              end else begin
                MakeError('', ecEndExpected, '');
                Result := False;
                exit;
              end;
            end else begin Block.Free; Result := False; exit; end;
          end else if FParser.CurrTokenID <> CSTII_End then
          begin
            MakeError('', ecEndExpected, '');
            Result := False;
            exit;
          end;
          FParser.Next;
        end else begin Block.Free; Result := False; exit; end;
      end else if FParser.CurrTokenId = CSTII_Finally then
      begin
        FParser.Next;
        Cardinal((@BlockInfo.Proc.Data[FStartOffset])^) := Cardinal(Length(BlockInfo.Proc.Data)) - FStartOffset - 15;
        Block := TIFPSBlockInfo.Create(BlockInfo);
        Block.SubType := tTryEnd;
        if ProcessSub(Block) then
        begin
          Block.Free;
          BlockWriteByte(BlockInfo, cm_poexh);
          BlockWriteByte(BlockInfo, 1);
          if FParser.CurrTokenId = CSTII_Except then
          begin
            Cardinal((@BlockInfo.Proc.Data[FStartOffset + 4])^) := Cardinal(Length(BlockInfo.Proc.Data)) - FStartOffset - 15;
            FParser.Next;
            Block := TIFPSBlockInfo.Create(BlockInfo);
            Block.SubType := tTryEnd;
            if ProcessSub(Block) then
            begin
              Block.Free;
              if FParser.CurrTokenId = CSTII_End then
              begin
                BlockWriteByte(BlockInfo, cm_poexh);
                BlockWriteByte(BlockInfo, 2);
              end else begin
                MakeError('', ecEndExpected, '');
                Result := False;
                exit;
              end;
            end else begin Block.Free; Result := False; exit; end;
          end else if FParser.CurrTokenID <> CSTII_End then
          begin
            MakeError('', ecEndExpected, '');
            Result := False;
            exit;
          end;
          FParser.Next;
        end else begin Block.Free;Result := False; exit; end;
      end;
    end else begin Block.Free; Result := False; exit; end;
    Cardinal((@BlockInfo.Proc.Data[FStartOffset + 12])^) := Cardinal(Length(BlockInfo.Proc.Data)) - FStartOffset - 15;
    Result := True;
  end; {ProcessTry}

var
  Block: TIFPSBlockInfo;

begin
  ProcessSub := False;
  if (BlockInfo.SubType = tProcBegin) or (BlockInfo.SubType= tMainBegin) or (BlockInfo.SubType= tSubBegin) then
  begin
    FParser.Next; // skip CSTII_Begin
  end;
  while True do
  begin
    case FParser.CurrTokenId of
      CSTII_Goto:
        begin
          if not ProcessGoto then
            Exit;
          if (BlockInfo.SubType = tifOneliner) or (BlockInfo.SubType = TOneLiner) then
            break;
        end;
      CSTII_With:
        begin
          if not ProcessWith then
            Exit;
          if (BlockInfo.SubType = tifOneliner) or (BlockInfo.SubType = TOneLiner) then
            break;
        end;
      CSTII_Try:
        begin
          if not ProcessTry then
            Exit;
          if (BlockInfo.SubType = tifOneliner) or (BlockInfo.SubType = TOneLiner) then
            break;
        end;
      CSTII_Finally, CSTII_Except:
        begin
          if (BlockInfo.SubType = tTry) or (BlockInfo.SubType = tTryEnd) then
            Break
          else
            begin
              MakeError('', ecEndExpected, '');
              Exit;
            end;
        end;
      CSTII_Begin:
        begin
          Block := TIFPSBlockInfo.Create(BlockInfo);
          Block.SubType := tSubBegin;
          if not ProcessSub(Block) then
          begin
            Block.Free;
            Exit;
          end;
          Block.Free;

          FParser.Next; // skip END
          if (BlockInfo.SubType = tifOneliner) or (BlockInfo.SubType = TOneLiner) then
            break;
        end;
      CSTI_Semicolon:
        begin
          FParser.Next;
          if (BlockInfo.SubType = tifOneliner) or (BlockInfo.SubType = TOneLiner) then
            break;
        end;
      CSTII_until:
        begin
          Debug_WriteLine(BlockInfo);
          if BlockInfo.SubType = tRepeat then
          begin
            break;
          end
          else
          begin
            MakeError('', ecIdentifierExpected, '');
            exit;
          end;
          if (BlockInfo.SubType = tifOneliner) or (BlockInfo.SubType = TOneLiner) then
            break;
        end;
      CSTII_Else:
        begin
          if BlockInfo.SubType = tifOneliner then
            break
          else
          begin
            MakeError('', ecIdentifierExpected, '');
            exit;
          end;
        end;
      CSTII_repeat:
        begin
          if not ProcessRepeat then
            exit;
          if (BlockInfo.SubType = tifOneliner) or (BlockInfo.SubType = TOneLiner) then
            break;
        end;
      CSTII_For:
        begin
          if not ProcessFor then
            exit;
          if (BlockInfo.SubType = tifOneliner) or (BlockInfo.SubType = TOneLiner) then
            break;
        end;
      CSTII_While:
        begin
          if not ProcessWhile then
            exit;
          if (BlockInfo.SubType = tifOneliner) or (BlockInfo.SubType = TOneLiner) then
            break;
        end;
      CSTII_Exit:
        begin
          Debug_WriteLine(BlockInfo);
          BlockWriteByte(BlockInfo, Cm_R);
          FParser.Next;
        end;
      CSTII_Case:
        begin
          if not ProcessCase then
            exit;
          if (BlockInfo.SubType = tifOneliner) or (BlockInfo.SubType = TOneLiner) then
            break;
        end;
      CSTII_If:
        begin
          if not ProcessIf then
            exit;
          if (BlockInfo.SubType = tifOneliner) or (BlockInfo.SubType = TOneLiner) then
            break;
        end;
      CSTI_Identifier:
        begin
          case ProcessLabel of
            0: Exit;
            1: ;
            else
            begin
              if FParser.GetToken = 'BREAK' then
              begin
                if FBreakOffsets = nil then
                begin
                  MakeError('', ecNotInLoop, '');
                  exit;
                end;
                BlockWriteByte(BlockInfo, Cm_G);
                BlockWriteLong(BlockInfo, $12345678);
                FBreakOffsets.Add(Pointer(Length(BlockInfo.Proc.Data)));
                FParser.Next;
                if (BlockInfo.SubType= tifOneliner) or (BlockInfo.SubType = TOneLiner) then
                  break;
              end else if FParser.GetToken = 'CONTINUE' then
              begin
                if FBreakOffsets = nil then
                begin
                  MakeError('', ecNotInLoop, '');
                  exit;
                end;
                BlockWriteByte(BlockInfo, Cm_G);
                BlockWriteLong(BlockInfo, $12345678);
                FContinueOffsets.Add(Pointer(Length(BlockInfo.Proc.Data)));
                FParser.Next;
                if (BlockInfo.SubType = tifOneliner) or (BlockInfo.SubType = TOneLiner) then
                  break;
              end else
              if not ProcessIdentifier then
                exit;
              if (BlockInfo.SubType = tifOneliner) or (BlockInfo.SubType = TOneLiner) then
                break;
            end;
          end; {case}
        end;
      CSTII_End:
        begin
          if (BlockInfo.SubType = tTryEnd) or (BlockInfo.SubType = tMainBegin) or (BlockInfo.SubType = tSubBegin) or
          (BlockInfo.SubType = tifOneliner) or (BlockInfo.SubType = tProcBegin) or (BlockInfo.SubType = TOneLiner) then
          begin
            break;
          end
          else
          begin
            MakeError('', ecIdentifierExpected, '');
            exit;
          end;
        end;
      CSTI_EOF:
        begin
          MakeError('', ecUnexpectedEndOfFile, '');
          exit;
        end;
    else
      begin
        MakeError('', ecIdentifierExpected, '');
        exit;
      end;
    end;
  end;
  if (BlockInfo.SubType = tMainBegin) or (BlockInfo.SubType = tProcBegin) then
  begin
    Debug_SavePosition(BlockInfo.ProcNo, BlockInfo.Proc);
    BlockWriteByte(BlockInfo, Cm_R);
    FParser.Next; // skip end
    if (BlockInfo.SubType = tMainBegin) and (FParser.CurrTokenId <> CSTI_Period) then
    begin
      MakeError('', ecPeriodExpected, '');
      exit;
    end;
    if (BlockInfo.SubType = tProcBegin) and (FParser.CurrTokenId <> CSTI_Semicolon) then
    begin
      MakeError('', ecSemicolonExpected, '');
      exit;
    end;
    FParser.Next;
  end;
  ProcessSub := True;
end;
procedure TIFPSPascalCompiler.UseProc(procdecl: TIFPSParametersDecl);
var
  i: Longint;
begin
  if procdecl.Result <> nil then
    procdecl.Result := at2ut(procdecl.Result);
  for i := 0 to procdecl.ParamCount -1 do
  begin
    procdecl.Params[i].aType := at2ut(procdecl.Params[i].aType);
  end;
end;

function TIFPSPascalCompiler.at2ut(p: TIFPSType): TIFPSType;
var
  i: Longint;
begin
  p := GetTypeCopyLink(p);
  if p = nil then
  begin
    Result := nil;
    exit;
  end;
  if not p.Used then
  begin
    case p.BaseType of
      btStaticArray, btArray: TIFPSArrayType(p).ArrayTypeNo := at2ut(TIFPSArrayType(p).ArrayTypeNo);
      btRecord:
        begin
          for i := 0 to TIFPSRecordType(p).RecValCount -1 do
          begin
            TIFPSRecordType(p).RecVal(i).aType := at2ut(TIFPSRecordType(p).RecVal(i).aType);
          end;
        end;
      btSet: TIFPSSetType(p).SetType := at2ut(TIFPSSetType(p).SetType);
      btProcPtr:
        begin
          UseProc(TIFPSProceduralType(p).ProcDef);
        end;
    end;
    p.Use;
    p.FFinalTypeNo := FCurrUsedTypeNo;
    inc(FCurrUsedTypeNo);
  end;
  Result := p;
end;

function TIFPSPascalCompiler.ProcessLabelForwards(Proc: TIFPSInternalProcedure): Boolean;
var
  i: Longint;
  s, s2: string;
begin
  for i := 0 to Proc.FLabels.Count -1 do
  begin
    s := Proc.FLabels[I];
    if Longint((@s[1])^) = -1 then
    begin
      delete(s, 1, 8);
      MakeError('', ecUnSetLabel, s);
      Result := False;
      exit;
    end;
  end;
  for i := Proc.FGotos.Count -1 downto 0 do
  begin
    s := Proc.FGotos[I];
    s2 := Proc.FLabels[Cardinal((@s[5])^)];
    Cardinal((@Proc.Data[Cardinal((@s[1])^)-3])^) :=  Cardinal((@s2[1])^) - Cardinal((@s[1])^) ;
  end;
  Result := True;
end;


type
  TCompilerState = (csStart, csProgram, csUnit, csUses, csInterface, csInterfaceUses, csImplementation);

function TIFPSPascalCompiler.Compile(const s: string): Boolean;
var
  Position: TCompilerState;
  i: Longint;

  procedure Cleanup;
  var
    I: Longint;
    PT: TIFPSType;
  begin
    if @FOnBeforeCleanup <> nil then
      FOnBeforeCleanup(Self);        // no reason it actually read the result of this call
    FGlobalBlock.Free;

    for I := 0 to FRegProcs.Count - 1 do
      TObject(FRegProcs[I]).Free;
    FRegProcs.Free;
    for i := 0 to FConstants.Count -1 do
    begin
      TIFPSConstant(FConstants[I]).Free;
    end;
    Fconstants.Free;
    for I := 0 to FVars.Count - 1 do
    begin
      TIFPSVar(FVars[I]).Free;
    end;
    FVars.Free;
    FVars := nil;
    for I := 0 to FProcs.Count - 1 do
      TIFPSProcedure(FProcs[I]).Free;
    FProcs.Free;
    FProcs := nil;
    for I := 0 to FTypes.Count - 1 do
    begin
      PT := FTypes[I];
      pt.Free;
    end;
    FTypes.Free;

{$IFNDEF IFPS3_NOINTERFACES}
    for i := FInterfaces.Count -1 downto 0 do
      TIFPSInterface(FInterfaces[i]).Free;
    FInterfaces.Free;
{$ENDIF}

    for i := FClasses.Count -1 downto 0 do
    begin
      TIFPSCompileTimeClass(FClasses[I]).Free;
    end;
    FClasses.Free;
    for i := FAttributeTypes.Count -1 downto 0 do
    begin
      TIFPSAttributeType(FAttributeTypes[i]).Free;
    end;
    FAttributeTypes.Free;
    FAttributeTypes := nil;
  end;

  function MakeOutput: Boolean;

    procedure WriteByte(b: Byte);
    begin
      FOutput := FOutput + Char(b);
    end;

    procedure WriteData(const Data; Len: Longint);
    var
      l: Longint;
    begin
      if Len < 0 then Len := 0;
      l := Length(FOutput);
      SetLength(FOutput, l + Len);
      Move(Data, FOutput[l + 1], Len);
    end;

    procedure WriteLong(l: Cardinal);
    begin
      WriteData(l, 4);
    end;

    procedure WriteVariant(p: PIfRVariant);
    begin
      WriteLong(p^.FType.FinalTypeNo);
      case p.FType.BaseType of
      btType: WriteLong(p^.ttype.FinalTypeNo);
      {$IFNDEF IFPS3_NOWIDESTRING}
      btWideString:
        begin
          WriteLong(Length(tbtWideString(p^.twidestring)));
          WriteData(tbtwidestring(p^.twidestring)[1], 2*Length(tbtWideString(p^.twidestring)));
        end;
      btWideChar: WriteData(p^.twidechar, 2);
      {$ENDIF}
      btSingle: WriteData(p^.tsingle, sizeof(tbtSingle));
      btDouble: WriteData(p^.tsingle, sizeof(tbtDouble));
      btExtended: WriteData(p^.tsingle, sizeof(tbtExtended));
      btCurrency: WriteData(p^.tsingle, sizeof(tbtCurrency));
      btChar: WriteData(p^.tchar, 1);
      btSet:
        begin
          WriteData(tbtString(p^.tstring)[1], Length(tbtString(p^.tstring)));
        end;
      btString:
        begin
          WriteLong(Length(tbtString(p^.tstring)));
          WriteData(tbtString(p^.tstring)[1], Length(tbtString(p^.tstring)));
        end;
      btenum:
        begin
          if TIFPSEnumType(p^.FType).HighValue <=256 then
            WriteData( p^.tu32, 1)
          else if TIFPSEnumType(p^.FType).HighValue <=65536 then
            WriteData(p^.tu32, 2)
          else
            WriteData(p^.tu32, 4);
        end;
      bts8,btu8: WriteData(p^.tu8, 1);
      bts16,btu16: WriteData(p^.tu16, 2);
      bts32,btu32: WriteData(p^.tu32, 4);
      {$IFNDEF IFPS3_NOINT64}
      bts64: WriteData(p^.ts64, 8);
      {$ENDIF}
      btProcPtr: WriteData(p^.tu32, 4);
      {$IFDEF IFPS3_DEBUG}
      else
          asm int 3; end;
      {$ENDIF}
      end;
    end;

    procedure WriteAttributes(attr: TIFPSAttributes);
    var
      i, j: Longint;
    begin
      WriteLong(attr.Count);
      for i := 0 to Attr.Count -1 do
      begin
        j := Length(attr[i].FAttribType.Name);
        WriteLong(j);
        WriteData(Attr[i].FAttribType.Name[1], j);
        WriteLong(Attr[i].Count);
        for j := 0 to Attr[i].Count -1 do
        begin
          WriteVariant(Attr[i][j]);
        end;
      end;
    end;

    procedure WriteTypes;
    var
      l, n: Longint;
      bt: TIFPSBaseType;
      x: TIFPSType;
      FExportName: string;
      Items: TIfList;
      procedure WriteTypeNo(TypeNo: Cardinal);
      begin
        WriteData(TypeNo, 4);
      end;
    begin
      Items := TIfList.Create;
      try
        for l := 0 to FCurrUsedTypeNo -1 do
          Items.Add(nil);
        for l := 0 to FTypes.Count -1 do
        begin
          x := FTypes[l];
          if x.Used then
            Items[x.FinalTypeNo] := x;
        end;
        for l := 0 to Items.Count - 1 do
        begin
          x := Items[l];
          if x.FExportName then
            FExportName := x.Name
          else
            FExportName := '';
          bt := x.BaseType;
          if x.BaseType = btType then
          begin
            bt := btU32;
          end else
          if (x.BaseType = btEnum) then begin
            if TIFPSEnumType(x).HighValue <= 256 then
              bt := btU8
            else if TIFPSEnumType(x).HighValue <= 65536 then
              bt := btU16
            else
              bt := btU32;
          end;
          if FExportName <> '' then
          begin
            WriteByte(bt + 128);
          end
          else
            WriteByte(bt);
{$IFNDEF IFPS3_NOINTERFACES} if x.BaseType = btInterface then
          begin
            WriteData(TIFPSInterfaceType(x).Intf.Guid, Sizeof(TGuid));
          end else {$ENDIF} if x.BaseType = btClass then
          begin
            WriteLong(Length(TIFPSClassType(X).Cl.FClassName));
            WriteData(TIFPSClassType(X).Cl.FClassName[1], Length(TIFPSClassType(X).Cl.FClassName));
          end else
          if (x.BaseType = btSet) then
          begin
            WriteLong(TIFPSSetType(x).BitSize);
          end else
          if (x.BaseType = btArray) or (x.basetype = btStaticArray) then
          begin
            WriteLong(TIFPSArrayType(x).ArrayTypeNo.FinalTypeNo);
            if (x.baseType = btstaticarray) then
              WriteLong(TIFPSStaticArrayType(x).Length);
          end else if x.BaseType = btRecord then
          begin
            n := TIFPSRecordType(x).RecValCount;
            WriteData( n, 4);
            for n := 0 to TIFPSRecordType(x).RecValCount - 1 do
              WriteTypeNo(TIFPSRecordType(x).RecVal(n).FType.FinalTypeNo);
          end;
          if FExportName <> '' then
          begin
            WriteLong(Length(FExportName));
            WriteData(FExportName[1], length(FExportName));
          end;
          WriteAttributes(x.Attributes);
        end;
      finally
        Items.Free;
      end;
    end;

    procedure WriteVars;
    var
      l,j : Longint;
      x: TIFPSVar;
    begin
      for l := 0 to FVars.Count - 1 do
      begin
        x := FVars[l];
        if x.SaveAsPointer then
        begin
          for j := FTypes.count -1 downto 0 do
          begin
            if TIFPSType(FTypes[j]).BaseType = btPointer then
            begin
              WriteLong(TIFPSType(FTypes[j]).FinalTypeNo);
              break;
            end;
          end;
        end else
          WriteLong(x.FType.FinalTypeNo);
        if x.exportname <> '' then
        begin
          WriteByte( 1);
          WriteLong(Length(X.ExportName));
          WriteData( X.ExportName[1], length(X.ExportName));
        end else
          WriteByte( 0);
      end;
    end;

    procedure WriteProcs;
    var
      l: Longint;
      xp: TIFPSProcedure;
      xo: TIFPSInternalProcedure;
      xe: TIFPSExternalProcedure;
      s: string;
      att: Byte;
    begin
      for l := 0 to FProcs.Count - 1 do
      begin
        xp := FProcs[l];
        if xp.Attributes.Count <> 0 then att := 4 else att := 0;
        if xp.ClassType = TIFPSInternalProcedure then
        begin
          xo := TIFPSInternalProcedure(xp);
          xo.OutputDeclPosition := Length(FOutput);
          WriteByte(att or 2); // exported
          WriteLong(0); // offset is unknown at this time
          WriteLong(0); // length is also unknown at this time
          WriteLong(Length(xo.Name));
          WriteData( xo.Name[1], length(xo.Name));
          s := MakeExportDecl(xo.Decl);
          WriteLong(Length(s));
          WriteData( s[1], length(S));
        end
        else
        begin
          xe := TIFPSExternalProcedure(xp);
          if xe.RegProc.ImportDecl <> '' then
          begin
            WriteByte( att or 3); // imported
            if xe.RegProc.FExportName then
            begin
              WriteByte(Length(xe.RegProc.Name));
              WriteData(xe.RegProc.Name[1], Length(xe.RegProc.Name) and $FF);
            end else begin
              WriteByte(0);
            end;
            WriteLong(Length(xe.RegProc.ImportDecl));
            WriteData(xe.RegProc.ImportDecl[1], Length(xe.RegProc.ImportDecl));
          end else begin
            WriteByte(att or 1); // imported
            WriteByte(Length(xe.RegProc.Name));
            WriteData(xe.RegProc.Name[1], Length(xe.RegProc.Name) and $FF);
          end;
        end;
        if xp.Attributes.Count <> 0 then
          WriteAttributes(xp.Attributes);
      end;
    end;

    procedure WriteProcs2;
    var
      l: Longint;
      L2: Cardinal;
      x: TIFPSProcedure;
    begin
      for l := 0 to FProcs.Count - 1 do
      begin
        x := FProcs[l];
        if x.ClassType = TIFPSInternalProcedure then
        begin
          if TIFPSInternalProcedure(x).Data = '' then
            TIFPSInternalProcedure(x).Data := Chr(Cm_R);
          L2 := Length(FOutput);
          Move(L2, FOutput[TIFPSInternalProcedure(x).OutputDeclPosition + 2], 4);
          // write position
          WriteData(TIFPSInternalProcedure(x).Data[1], Length(TIFPSInternalProcedure(x).Data));
          L2 := Cardinal(Length(FOutput)) - L2;
          Move(L2, FOutput[TIFPSInternalProcedure(x).OutputDeclPosition + 6], 4); // write length
        end;
      end;
    end;

    function FindMainProc: Cardinal;
    var
      l: Longint;
    begin
      for l := 0 to FProcs.Count - 1 do
      begin
        if (TIFPSProcedure(FProcs[l]).ClassType = TIFPSInternalProcedure) and
          (TIFPSInternalProcedure(FProcs[l]).Name = IFPSMainProcName) then
        begin
          Result := l;
          exit;
        end;
      end;
      Result := InvalidVal;
    end;
    procedure CreateDebugData;
    var
      I: Longint;
      p: TIFPSProcedure;
      pv: TIFPSVar;
      s: string;
    begin
      s := #0;
      for I := 0 to FProcs.Count - 1 do
      begin
        p := FProcs[I];
        if p.ClassType = TIFPSInternalProcedure then
        begin
          if TIFPSInternalProcedure(p).Name = IFPSMainProcName then
            s := s + #1
          else
            s := s + TIFPSInternalProcedure(p).OriginalName + #1;
        end
        else
        begin
          s := s+ TIFPSExternalProcedure(p).RegProc.OrgName + #1;
        end;
      end;
      s := s + #0#1;
      for I := 0 to FVars.Count - 1 do
      begin
        pv := FVars[I];
        s := s + pv.OrgName + #1;
      end;
      s := s + #0;
      WriteDebugData(s);
    end;
  begin
    if @FOnBeforeOutput <> nil then
    begin
      if not FOnBeforeOutput(Self) then
      begin
        Result := false;
        exit;
      end;
    end;

    CreateDebugData;
    WriteLong(IFPSValidHeader);
    WriteLong(IFPSCurrentBuildNo);
    WriteLong(FCurrUsedTypeNo);
    WriteLong(FProcs.Count);
    WriteLong(FVars.Count);
    WriteLong(FindMainProc);
    WriteLong(0);
    WriteTypes;
    WriteProcs;
    WriteVars;
    WriteProcs2;

    Result := true;
  end;

  function CheckExports: Boolean;
  var
    i: Longint;
    p: TIFPSProcedure;
  begin
    if @FOnExportCheck = nil then
    begin
      result := true;
      exit;
    end;
    for i := 0 to FProcs.Count -1 do
    begin
      p := FProcs[I];
      if p.ClassType = TIFPSInternalProcedure then
      begin
        if not FOnExportCheck(Self, TIFPSInternalProcedure(p), MakeDecl(TIFPSInternalProcedure(p).Decl)) then
        begin
          Result := false;
          exit;
        end;
      end;
    end;
    Result := True;
  end;
  function DoConstBlock: Boolean;
  var
    COrgName: string;
    CTemp, CValue: PIFRVariant;
    Cp: TIFPSConstant;
  begin
    FParser.Next;
    repeat
      if FParser.CurrTokenID <> CSTI_Identifier then
      begin
        MakeError('', ecIdentifierExpected, '');
        Result := False;
        Exit;
      end;
      COrgName := FParser.OriginalToken;
      if IsDuplicate(FastUpperCase(COrgName), [dcVars, dcProcs, dcConsts]) then
      begin
        MakeError('', ecDuplicateIdentifier, '');
        Result := False;
        exit;
      end;
      FParser.Next;
      if FParser.CurrTokenID <> CSTI_Equal then
      begin
        MakeError('', ecIsExpected, '');
        Result := False;
        Exit;
      end;
      FParser.Next;
      CValue := ReadConstant(FParser, CSTI_SemiColon);
      if CValue = nil then
      begin
        Result := False;
        Exit;
      end;
      if FParser.CurrTokenID <> CSTI_Semicolon then
      begin
        MakeError('', ecSemicolonExpected, '');
        Result := False;
        exit;
      end;
      cp := TIFPSConstant.Create;
      cp.Orgname := COrgName;
      cp.Name := FastUpperCase(COrgName);
      New(CTemp);
      InitializeVariant(CTemp, CValue.FType);
      CopyVariantContents(cvalue, CTemp);
      cp.Value := CTemp;
      FConstants.Add(cp);
      DisposeVariant(CValue);
      FParser.Next;
    until FParser.CurrTokenId <> CSTI_Identifier;
    Result := True;
  end;
  function ProcessUses: Boolean;
  var
    FUses: TIfStringList;
    I: Longint;
    s: string;
  begin
    FParser.Next;
    FUses := TIfStringList.Create;
    FUses.Add('SYSTEM');
    repeat
      if FParser.CurrTokenID <> CSTI_Identifier then
      begin
        MakeError('', ecIdentifierExpected, '');
        FUses.Free;
        Result := False;
        exit;
      end;
      s := FParser.GetToken;
      for i := 0 to FUses.Count -1 do
      begin
        if FUses[I] = s then
        begin
          MakeError('', ecDuplicateIdentifier, s);
          FUses.Free;
          Result := False;
          exit;
        end;
      end;
      FUses.Add(s);
      if @FOnUses <> nil then
      begin
        try
          if not OnUses(Self, FParser.GetToken) then
          begin
            FUses.Free;
            Result := False;
            exit;
          end;
        except
          on e: Exception do
          begin
            MakeError('', ecCustomError, e.Message);
            FUses.Free;
            Result := False;
            exit;
          end;
        end;
      end;
      FParser.Next;
      if FParser.CurrTokenID = CSTI_Semicolon then break
      else if FParser.CurrTokenId <> CSTI_Comma then
      begin
        MakeError('', ecSemicolonExpected, '');
        Result := False;
        FUses.Free;
        exit;
      end;
      FParser.Next;
    until False;
    FUses.Free;
    FParser.next;
    Result := True;
  end;

var
  Proc: TIFPSProcedure;

begin
  FCurrUsedTypeNo := 0;
  FIsUnit := False;
  Result := False;
  Clear;
  FParser.SetText(s);
  FAttributeTypes := TIfList.Create;
  FProcs := TIfList.Create;
  FConstants := TIFList.Create;
  FVars := TIfList.Create;
  FTypes := TIfList.Create;
  FRegProcs := TIfList.Create;
  FClasses := TIfList.Create;
{$IFNDEF IFPS3_NOINTERFACES}  FInterfaces := TIfList.Create;{$ENDIF}

  FGlobalBlock := TIFPSBlockInfo.Create(nil);
  FGlobalBlock.SubType := tMainBegin;

  FGlobalBlock.Proc := NewProc(IFPSMainProcNameOrg, IFPSMainProcName);
  FGlobalBlock.ProcNo := FindProc(IFPSMainProcName);

  DefineStandardTypes;
  DefineStandardProcedures;
  if @FOnUses <> nil then
  begin
    try
      if not OnUses(Self, 'SYSTEM') then
      begin
        Cleanup;
        exit;
      end;
    except
      on e: Exception do
      begin
        MakeError('', ecCustomError, e.Message);
        Cleanup;
        exit;
      end;
    end;
  end;
  Position := csStart;
  repeat
    if FParser.CurrTokenId = CSTI_EOF then
    begin
      if FAllowNoEnd then
        Break
      else
      begin
        MakeError('', ecUnexpectedEndOfFile, '');
        Cleanup;
        exit;
      end;
    end;
    if (FParser.CurrTokenId = CSTII_Program) and (Position = csStart) then
    begin
      Position := csProgram;
      FParser.Next;
      if FParser.CurrTokenId <> CSTI_Identifier then
      begin
        MakeError('', ecIdentifierExpected, '');
        Cleanup;
        exit;
      end;
      FParser.Next;
      if FParser.CurrTokenId <> CSTI_Semicolon then
      begin
        MakeError('', ecSemicolonExpected, '');
        Cleanup;
        exit;
      end;
      FParser.Next;
    end else
    if (Fparser.CurrTokenID = CSTII_Implementation) and ((Position = csinterface) or (position = csInterfaceUses)) then
    begin
      Position := csImplementation;
      FParser.Next;
    end else
    if (Fparser.CurrTokenID = CSTII_Interface) and (Position = csUnit) then
    begin
      Position := csInterface;
      FParser.Next;
    end else
    if (FParser.CurrTokenId = CSTII_Unit) and (Position = csStart) and (FAllowUnit) then
    begin
      Position := csUnit;
      FIsUnit := True;
      FParser.Next;
      if FParser.CurrTokenId <> CSTI_Identifier then
      begin
        MakeError('', ecIdentifierExpected, '');
        Cleanup;
        exit;
      end;
      FParser.Next;
      if FParser.CurrTokenId <> CSTI_Semicolon then
      begin
        MakeError('', ecSemicolonExpected, '');
        Cleanup;
        exit;
      end;
      FParser.Next;
    end
    else if (FParser.CurrTokenID = CSTII_Uses) and ((Position < csuses) or (Position = csInterface)) then
    begin
      if Position = csInterface then
        Position := csInterfaceUses
      else
        Position := csUses;
      if not ProcessUses then
      begin
        Cleanup;
        exit;
      end;
    end else if (FParser.CurrTokenId = CSTII_Procedure) or
      (FParser.CurrTokenId = CSTII_Function) or (FParser.CurrTokenID = CSTI_OpenBlock) then
    begin
      if (Position = csInterface) or (position = csInterfaceUses) then
      begin
        if not ProcessFunction(True, nil) then
        begin
          Cleanup;
          exit;
        end;
      end else begin
        Position := csUses;
        if not ProcessFunction(False, nil) then
        begin
          Cleanup;
          exit;
        end;
      end;
    end
    else if (FParser.CurrTokenId = CSTII_Label) then
    begin
      Position := csUses;
      if not ProcessLabel(FGlobalBlock.Proc) then
      begin
        Cleanup;
        exit;
      end;
    end
    else if (FParser.CurrTokenId = CSTII_Var) then
    begin
      Position := csUses;
      if not DoVarBlock(nil) then
      begin
        Cleanup;
        exit;
      end;
    end
    else if (FParser.CurrTokenId = CSTII_Const) then
    begin
      Position := csUses;
      if not DoConstBlock then
      begin
        Cleanup;
        exit;
      end;
    end
    else if (FParser.CurrTokenId = CSTII_Type) then
    begin
      Position := csUses;
      if not DoTypeBlock(FParser) then
      begin
        Cleanup;
        exit;
      end;
    end
    else if (FParser.CurrTokenId = CSTII_Begin) then
    begin
      FGlobalBlock.Proc.DeclarePos := FParser.CurrTokenPos;
      FGlobalBlock.Proc.DeclareRow := FParser.Row;
      FGlobalBlock.Proc.DeclareCol := FParser.Col;
      if ProcessSub(FGlobalBlock) then
      begin
        break;
      end
      else
      begin
        Cleanup;
        exit;
      end;
    end
    else if (Fparser.CurrTokenId = CSTII_End) and (FAllowNoBegin or FIsUnit) then
    begin
      FParser.Next;
      if FParser.CurrTokenID <> CSTI_Period then
      begin
        MakeError('', ecPeriodExpected, '');
        Cleanup;
        exit;
      end;
      break;
    end else
    begin
      MakeError('', ecBeginExpected, '');
      Cleanup;
      exit;
    end;
  until False;
  if not ProcessLabelForwards(FGlobalBlock.Proc) then
  begin
    Cleanup;
    exit;
  end;
  for i := 0 to FProcs.Count -1 do
  begin
    Proc := FProcs[I];
    if (Proc.ClassType = TIFPSInternalProcedure) and (TIFPSInternalProcedure(Proc).Forwarded) then
    begin
      with MakeError('', ecUnsatisfiedForward, TIFPSInternalProcedure(Proc).Name) do
      begin
        FPosition := TIFPSInternalProcedure(Proc).DeclarePos;
        FRow := TIFPSInternalProcedure(Proc).DeclareRow;
        FCol := TIFPSInternalProcedure(Proc).DeclareCol;
      end;
      Cleanup;
      Exit;
    end;
  end;
  if not CheckExports then
  begin
    Cleanup;
    exit;
  end;
  for i := 0 to FVars.Count -1 do
  begin
    if not TIFPSVar(FVars[I]).Used then
    begin
      with MakeHint('', ehVariableNotUsed, TIFPSVar(FVars[I]).Name) do
      begin
        FPosition := TIFPSVar(FVars[I]).DeclarePos;
        FRow := TIFPSVar(FVars[I]).DeclareRow;
        FCol := TIFPSVar(FVars[I]).DeclareCol;
      end;
    end;
  end;
  Result := MakeOutput;
  Cleanup;
end;

constructor TIFPSPascalCompiler.Create;
begin
  inherited Create;
  FParser := TIfPascalParser.Create;
  FParser.OnParserError := ParserError;
  FAutoFreeList := TIfList.Create;
  FOutput := '';
  FMessages := TIfList.Create;
end;

destructor TIFPSPascalCompiler.Destroy;
begin
  Clear;
  FAutoFreeList.Free;

  FMessages.Free;
  FParser.Free;
  inherited Destroy;
end;

function TIFPSPascalCompiler.GetOutput(var s: string): Boolean;
begin
  if Length(FOutput) <> 0 then
  begin
    s := FOutput;
    Result := True;
  end
  else
    Result := False;
end;

function TIFPSPascalCompiler.GetMsg(l: Longint): TIFPSPascalCompilerMessage;
begin
  Result := FMessages[l];
end;

function TIFPSPascalCompiler.GetMsgCount: Longint;
begin
  Result := FMessages.Count;
end;

procedure TIFPSPascalCompiler.DefineStandardTypes;
var
  i: Longint;
begin
  AddType('Byte', btU8);
  FDefaultBoolType := AddTypeS('Boolean', '(False, True)');
  FDefaultBoolType.ExportName := True;
  with TIFPSEnumType(AddType('LongBool', btEnum)) do
  begin
    HighValue := 2147483647; // make sure it's gonna be a 4 byte var
  end;
  AddType('Char', btChar);
  {$IFNDEF IFPS3_NOWIDESTRING}
  AddType('WideChar', btWideChar);
  AddType('WideString', btWideString);
  {$ENDIF}
  AddType('ShortInt', btS8);
  AddType('Word', btU16);
  AddType('SmallInt', btS16);
  AddType('LongInt', btS32);
  at2ut(AddType('Pointer', btPointer));
  AddType('LongWord', btU32);
  AddTypeCopyN('Integer', 'LONGINT');
  AddTypeCopyN('Cardinal', 'LONGWORD');
  AddType('string', btString);
  {$IFNDEF IFPS3_NOINT64}
  AddType('Int64', btS64);
  {$ENDIF}
  AddType('Single', btSingle);
  AddType('Double', btDouble);
  AddType('Extended', btExtended);
  AddType('Currency', btCurrency);
  AddType('PChar', btPChar);
  AddType('Variant', btVariant);
  for i := FTypes.Count -1 downto 0 do AT2UT(FTypes[i]);
  TIFPSArrayType(AddType('TVariantArray', btArray)).ArrayTypeNo := FindType('VARIANT');

  with AddFunction('function Assigned(I: Longint): Boolean;') do
  begin
    Name := '!ASSIGNED';
  end;
end;


function TIFPSPascalCompiler.FindType(const Name: string): TIFPSType;
var
  i, n: Longint;
  RName: string;
begin
  if FProcs = nil then begin Result := nil; exit;end;
  RName := Fastuppercase(Name);
  n := makehash(rname);
  for i := FTypes.Count - 1 downto 0 do
  begin
    Result := FTypes.Data[I];
    if (Result.NameHash = n) and (Result.name = rname) then
    begin
      Result := GetTypeCopyLink(Result);
      exit;
    end;
  end;
  result := nil;
end;

function TIFPSPascalCompiler.AddConstant(const Name: string; FType: TIFPSType): TIFPSConstant;
var
  pc: TIFPSConstant;
  val: PIfRVariant;
begin
  if FProcs = nil then raise EIFPSCompilerException.Create('This function can only be called from within the OnUses event');

  FType := GetTypeCopyLink(FType);
  if FType = nil then
    Raise EIFPSCompilerException.Create('Unable to register constant '+name);
  pc := TIFPSConstant.Create;
  pc.OrgName := name;
  pc.Name := FastUppercase(name);
  New(Val);
  InitializeVariant(Val, FType);
  pc.Value := Val;
  FConstants.Add(pc);
  result := pc;
end;

function TIFPSPascalCompiler.ReadAttributes(Dest: TIFPSAttributes): Boolean;
var
  Att: TIFPSAttributeType;
  at: TIFPSAttribute;
  varp: PIfRVariant;
  h, i: Longint;
  s: string;
begin
  if FParser.CurrTokenID <> CSTI_OpenBlock then begin Result := true; exit; end;
  FParser.Next;
  if FParser.CurrTokenID <> CSTI_Identifier then
  begin
    MakeError('', ecIdentifierExpected, '');
    Result := False;
    exit;
  end;
  s := FParser.GetToken;
  h := MakeHash(s);
  att := nil;
  for i := FAttributeTypes.count -1 downto 0 do
  begin
    att := FAttributeTypes[i];
    if (att.FNameHash = h) and (att.FName = s) then
      Break;
    att := nil;
  end;
  if att = nil then
  begin
    MakeError('', ecUnknownIdentifier, '');
    Result := False;
    exit;
  end;
  FParser.Next;
  i := 0;
  at := Dest.Add(att);
  while att.Fields[i].Hidden do
  begin
    at.AddValue(NewVariant(at2ut(att.Fields[i].FieldType)));
    inc(i);
  end;
  if FParser.CurrTokenId <> CSTI_OpenRound then
  begin
    MakeError('', ecOpenRoundExpected, '');
    Result := False;
    exit;
  end;
  FParser.Next;
  if i < Att.FieldCount then
  begin
    while i < att.FieldCount do
    begin
      varp := ReadConstant(FParser, CSTI_CloseRound);
      if varp = nil then
      begin
        Result := False;
        exit;
      end;
      at.AddValue(varp);
      if not IsCompatibleType(varp.FType, Att.Fields[i].FieldType, False) then
      begin
        MakeError('', ecTypeMismatch, '');
        Result := False;
        exit;
      end;
      Inc(i);
      while (i < Att.FieldCount) and (att.Fields[i].Hidden)  do
      begin
        at.AddValue(NewVariant(at2ut(att.Fields[i].FieldType)));
        inc(i);
      end;
      if i >= Att.FieldCount then
      begin
        break;
      end else
      begin
        if FParser.CurrTokenID <> CSTI_Comma then
        begin
          MakeError('', ecCommaExpected, '');
          Result := False;
          exit;
        end;
      end;
      FParser.Next;
    end;
  end;
  if FParser.CurrTokenID <> CSTI_CloseRound then
  begin
    MakeError('', ecCloseRoundExpected, '');
    Result := False;
    exit;
  end;
  FParser.Next;
  if FParser.CurrTokenID <> CSTI_CloseBlock then
  begin
    MakeError('', ecCloseBlockExpected, '');
    Result := False;
    exit;
  end;
  FParser.Next;
  Result := True;
end;

type
  TConstOperation = class(TObject)
  private
    FDeclPosition, FDeclRow, FDeclCol: Cardinal;
  public
    property DeclPosition: Cardinal read FDeclPosition write FDeclPosition;
    property DeclRow: Cardinal read FDeclRow write FDeclRow;
    property DeclCol: Cardinal read FDeclCol write FDeclCol;
    procedure SetPos(Parser: TIfPascalParser);
  end;

  TUnConstOperation = class(TConstOperation)
  private
    FOpType: TIFPSUnOperatorType;
    FVal1: TConstOperation;
  public
    property OpType: TIFPSUnOperatorType read FOpType write FOpType;
    property Val1: TConstOperation read FVal1 write FVal1;

    destructor Destroy; override;
  end;

  TBinConstOperation = class(TConstOperation)
  private
    FOpType: TIFPSBinOperatorType;
    FVal2: TConstOperation;
    FVal1: TConstOperation;
  public
    property OpType: TIFPSBinOperatorType read FOpType write FOpType;
    property Val1: TConstOperation read FVal1 write FVal1;
    property Val2: TConstOperation read FVal2 write FVal2;

    destructor Destroy; override;
  end;

  TConstData = class(TConstOperation)
  private
    FData: PIfRVariant;
  public
    property Data: PIfRVariant read FData write FData;
    destructor Destroy; override;
  end;


function TIFPSPascalCompiler.IsBoolean(aType: TIFPSType): Boolean;
begin
  Result := (AType = FDefaultBoolType)
    or (AType.Name = 'LONGBOOL');
end;

function TIFPSPascalCompiler.ReadConstant(FParser: TIfPascalParser; StopOn: TIfPasToken): PIfRVariant;

  function ReadExpression: TConstOperation; forward;
  function ReadTerm: TConstOperation; forward;
  function ReadFactor: TConstOperation;
  var
    NewVar: TConstOperation;
    NewVarU: TUnConstOperation;
    function ReadString: PIfRVariant;
    {$IFNDEF IFPS3_NOWIDESTRING}var wchar: Boolean;{$ENDIF}

      function ParseString: {$IFNDEF IFPS3_NOWIDESTRING}widestring{$ELSE}string{$ENDIF};
      var
        temp3: {$IFNDEF IFPS3_NOWIDESTRING}widestring{$ELSE}string{$ENDIF};

        function ChrToStr(s: string): {$IFNDEF IFPS3_NOWIDESTRING}widechar{$ELSE}char{$ENDIF};
        var
          w: Longint;
        begin
          Delete(s, 1, 1); {First char : #}
          w := StrToInt(s);
          Result := {$IFNDEF IFPS3_NOWIDESTRING}widechar{$ELSE}char{$ENDIF}(w);
          {$IFNDEF IFPS3_NOWIDESTRING}if w > $FF then wchar := true;{$ENDIF}
        end;

        function PString(s: string): string;
        begin
          s := copy(s, 2, Length(s) - 2);
          PString := s;
        end;
      begin
        temp3 := '';
        while (FParser.CurrTokenId = CSTI_String) or (FParser.CurrTokenId = CSTI_Char) do
        begin
          if FParser.CurrTokenId = CSTI_String then
          begin
            temp3 := temp3 + PString(FParser.GetToken);
            FParser.Next;
            if FParser.CurrTokenId = CSTI_String then
              temp3 := temp3 + #39;
          end {if}
          else
          begin
            temp3 := temp3 + ChrToStr(FParser.GetToken);
            FParser.Next;
          end; {else if}
        end; {while}
        ParseString := temp3;
      end;
    {$IFNDEF IFPS3_NOWIDESTRING}
    var
      w: widestring;
      s: string;
    begin
      w := ParseString;
      if wchar then
      begin
        New(Result);
        if Length(w) = 1 then
        begin
          InitializeVariant(Result, FindBaseType(btwidechar));
          Result^.twidechar := w[1];
        end else begin
          InitializeVariant(Result, FindBaseType(btwidestring));
          tbtwidestring(result^.twidestring) := w;
        end;
      end else begin
        s := w;
        New(Result);
        if Length(s) = 1 then
        begin
          InitializeVariant(Result, FindBaseType(btChar));
          Result^.tchar := s[1];
        end else begin
          InitializeVariant(Result, FindBaseType(btstring));
          tbtstring(Result^.tstring) := s;
        end;
      end;
    end;
    {$ELSE}
    var
      s: string;
    begin
      s := ParseString;
      New(Result);
      if Length(s) = 1 then
      begin
        InitializeVariant(Result, FindBaseType(btChar));
        Result^.tchar := s[1];
      end else begin
        InitializeVariant(Result, FindBaseType(btstring));
        tbtstring(Result^.tstring) := s;
      end;
    end;
    {$ENDIF}
    function GetConstantIdentifier: PIfRVariant;
    var
      s: string;
      sh: Longint;
      i: Longint;
      p: TIFPSConstant;
    begin
      s := FParser.GetToken;
      sh := MakeHash(s);
      for i := FConstants.Count -1 downto 0 do
      begin
        p := FConstants[I];
        if (p.NameHash = sh) and (p.Name = s) then
        begin
          New(Result);
          InitializeVariant(Result, p.Value.FType);
          CopyVariantContents(P.Value, Result);
          FParser.Next;
          exit;
        end;
      end;
      MakeError('', ecUnknownIdentifier, '');
      Result := nil;
    end;
  function ReadReal(const s: string): PIfRVariant;
  var
    C: Integer;
  begin
    New(Result);
    InitializeVariant(Result, FindBaseType(btExtended));
    System.Val(s, Result^.textended, C);
  end;
    function ReadInteger(const s: string): PIfRVariant;
    {$IFNDEF IFPS3_NOINT64}
    var
      R: Int64;
    begin
      r := StrToInt64Def(s, 0);
      New(Result);
      if (r >= High(Longint)) or (r <= Low(Longint))then
      begin
        InitializeVariant( Result, FindBaseType(bts32));
        Result^.ts32 := r;
      end else
      begin
        InitializeVariant(Result, FindBaseType(bts64));
        Result^.ts64 := r;
      end;
    end;
    {$ELSE}
    var
      r: Longint;
    begin
      r := StrToIntDef(s, 0);
      New(Result);
      InitializeVariant( Result, FindBaseType(bts32));
      Result^.ts32 := r;
    end;
    {$ENDIF}
  begin
    case fParser.CurrTokenID of
      CSTII_Not:
      begin
        FParser.Next;
        NewVar := ReadFactor;
        if NewVar = nil then
        begin
          Result := nil;
          exit;
        end;
        NewVarU := TUnConstOperation.Create;
        NewVarU.OpType := otNot;
        NewVarU.Val1 := NewVar;
        NewVar := NewVarU;
      end;
      CSTI_Minus:
      begin
        FParser.Next;
        NewVar := ReadTerm;
        if NewVar = nil then
        begin
          Result := nil;
          exit;
        end;
        NewVarU := TUnConstOperation.Create;
        NewVarU.OpType := otMinus;
        NewVarU.Val1 := NewVar;
        NewVar := NewVarU;
      end;
      CSTI_OpenRound:
        begin
          FParser.Next;
          NewVar := ReadExpression;
          if NewVar = nil then
          begin
            Result := nil;
            exit;
          end;
          if FParser.CurrTokenId <> CSTI_CloseRound then
          begin
            NewVar.Free;
            Result := nil;
            MakeError('', ecCloseRoundExpected, '');
            exit;
          end;
          FParser.Next;
        end;
      CSTI_Char, CSTI_String:
        begin
          NewVar := TConstData.Create;
          NewVar.SetPos(FParser);
          TConstData(NewVar).Data := ReadString;
        end;
      CSTI_HexInt, CSTI_Integer:
        begin
          NewVar := TConstData.Create;
          NewVar.SetPos(FParser);
          TConstData(NewVar).Data := ReadInteger(FParser.GetToken);
          FParser.Next;
        end;
      CSTI_Real:
        begin
          NewVar := TConstData.Create;
          NewVar.SetPos(FParser);
          TConstData(NewVar).Data := ReadReal(FParser.GetToken);
          FParser.Next;
        end;
      CSTI_Identifier:
        begin
          NewVar := TConstData.Create;
          NewVar.SetPos(FParser);
          TConstData(NewVar).Data := GetConstantIdentifier;
          if TConstData(NewVar).Data = nil then
          begin
            NewVar.Free;
            Result := nil;
            exit;
          end
        end;
    else
      begin
        MakeError('', ecSyntaxError, '');
        Result := nil;
        exit;
      end;
    end; {case}
    Result := NewVar;
  end; // ReadFactor

  function ReadTerm: TConstOperation;
  var
    F1, F2: TConstOperation;
    F: TBinConstOperation;
    Token: TIfPasToken;
    Op: TIFPSBinOperatorType;
  begin
    F1 := ReadFactor;
    if F1 = nil then
    begin
      Result := nil;
      exit;
    end;
    while FParser.CurrTokenID in [CSTI_Multiply, CSTI_Divide, CSTII_Div, CSTII_Mod, CSTII_And, CSTII_Shl, CSTII_Shr] do
    begin
      Token := FParser.CurrTokenID;
      FParser.Next;
      F2 := ReadFactor;
      if f2 = nil then
      begin
        f1.Free;
        Result := nil;
        exit;
      end;
      case Token of
        CSTI_Multiply: Op := otMul;
        CSTII_div, CSTI_Divide: Op := otDiv;
        CSTII_mod: Op := otMod;
        CSTII_and: Op := otAnd;
        CSTII_shl: Op := otShl;
        CSTII_shr: Op := otShr;
      else
        Op := otAdd;
      end;
      F := TBinConstOperation.Create;
      f.Val1 := F1;
      f.Val2 := F2;
      f.OpType := Op;
      f1 := f;
    end;
    Result := F1;
  end;  // ReadTerm

  function ReadSimpleExpression: TConstOperation;
  var
    F1, F2: TConstOperation;
    F: TBinConstOperation;
    Token: TIfPasToken;
    Op: TIFPSBinOperatorType;
  begin
    F1 := ReadTerm;
    if F1 = nil then
    begin
      Result := nil;
      exit;
    end;
    while FParser.CurrTokenID in [CSTI_Plus, CSTI_Minus, CSTII_Or, CSTII_Xor] do
    begin
      Token := FParser.CurrTokenID;
      FParser.Next;
      F2 := ReadTerm;
      if f2 = nil then
      begin
        f1.Free;
        Result := nil;
        exit;
      end;
      case Token of
        CSTI_Plus: Op := otAdd;
        CSTI_Minus: Op := otSub;
        CSTII_or: Op := otOr;
        CSTII_xor: Op := otXor;
      else
        Op := otAdd;
      end;
      F := TBinConstOperation.Create;
      f.Val1 := F1;
      f.Val2 := F2;
      f.OpType := Op;
      f1 := f;
    end;
    Result := F1;
  end;  // ReadSimpleExpression


  function ReadExpression: TConstOperation;
  var
    F1, F2: TConstOperation;
    F: TBinConstOperation;
    Token: TIfPasToken;
    Op: TIFPSBinOperatorType;
  begin
    F1 := ReadSimpleExpression;
    if F1 = nil then
    begin
      Result := nil;
      exit;
    end;
    while FParser.CurrTokenID in [ CSTI_GreaterEqual, CSTI_LessEqual, CSTI_Greater, CSTI_Less, CSTI_Equal, CSTI_NotEqual] do
    begin
      Token := FParser.CurrTokenID;
      FParser.Next;
      F2 := ReadSimpleExpression;
      if f2 = nil then
      begin
        f1.Free;
        Result := nil;
        exit;
      end;
      case Token of
        CSTI_GreaterEqual: Op := otGreaterEqual;
        CSTI_LessEqual: Op := otLessEqual;
        CSTI_Greater: Op := otGreater;
        CSTI_Less: Op := otLess;
        CSTI_Equal: Op := otEqual;
        CSTI_NotEqual: Op := otNotEqual;
      else
        Op := otAdd;
      end;
      F := TBinConstOperation.Create;
      f.Val1 := F1;
      f.Val2 := F2;
      f.OpType := Op;
      f1 := f;
    end;
    Result := F1;
  end;  // ReadExpression


  function EvalConst(P: TConstOperation): PIfRVariant;
  var
    p1, p2: PIfRVariant;
  begin
    if p is TBinConstOperation then
    begin
      p1 := EvalConst(TBinConstOperation(p).Val1);
      if p1 = nil then begin Result := nil; exit; end;
      p2 := EvalConst(TBinConstOperation(p).Val2);
      if p2 = nil then begin DisposeVariant(p1); Result := nil; exit; end;
      if not PreCalc(False, 0, p1, 0, p2, TBinConstOperation(p).OpType, p.DeclPosition, p.DeclRow, p.DeclCol) then
      begin
        DisposeVariant(p1);
        DisposeVariant(p2);
//        MakeError('', ecTypeMismatch, '');
        result := nil;
        exit;
      end;
      DisposeVariant(p2);
      Result := p1;
    end else if p is TUnConstOperation then
    begin
      with TUnConstOperation(P) do
      begin
        p1 := EvalConst(Val1);
        case OpType of
          otNot:
            case p1.FType.BaseType of
              btU8: p1.tu8 := not p1.tu8;
              btU16: p1.tu16 := not p1.tu16;
              btU32: p1.tu32 := not p1.tu32;
              bts8: p1.ts8 := not p1.ts8;
              bts16: p1.ts16 := not p1.ts16;
              bts32: p1.ts32 := not p1.ts32;
              {$IFNDEF IFPS3_NOINT64}
              bts64: p1.ts64 := not p1.ts64;
              {$ENDIF}
            else
              begin
                MakeError('', ecTypeMismatch, '');
                DisposeVariant(p1);
                Result := nil;
                exit;
              end;
            end;
          otMinus:
            case p1.FType.BaseType of
              btU8: p1.tu8 := -p1.tu8;
              btU16: p1.tu16 := -p1.tu16;
              btU32: p1.tu32 := -p1.tu32;
              bts8: p1.ts8 := -p1.ts8;
              bts16: p1.ts16 := -p1.ts16;
              bts32: p1.ts32 := -p1.ts32;
              {$IFNDEF IFPS3_NOINT64}
              bts64: p1.ts64 := -p1.ts64;
              {$ENDIF}
            else
              begin
                MakeError('', ecTypeMismatch, '');
                DisposeVariant(p1);
                Result := nil;
                exit;
              end;
            end;
        else
          begin
            DisposeVariant(p1);
            Result := nil;
            exit;
          end;
        end;
      end;
      Result := p1;
    end else
    begin
      New(p1);
      InitializeVariant(p1, (p as TConstData).Data.FType);
      CopyVariantContents((p as TConstData).Data, p1);
      Result := p1;
    end;
  end;

var
  Val: TConstOperation;
begin
  Val := ReadExpression;
  if val = nil then
  begin
    Result := nil;
    exit;
  end;
  Result := EvalConst(Val);
  Val.Free;
end;

procedure TIFPSPascalCompiler.WriteDebugData(const s: string);
begin
  FDebugOutput := FDebugOutput + s;
end;

function TIFPSPascalCompiler.GetDebugOutput(var s: string): Boolean;
begin
  if Length(FDebugOutput) <> 0 then
  begin
    s := FDebugOutput;
    Result := True;
  end
  else
    Result := False;
end;

function TIFPSPascalCompiler.AddUsedFunction(var Proc: TIFPSInternalProcedure): Cardinal;
begin
  if FProcs = nil then raise EIFPSCompilerException.Create('This function can only be called from within the OnUses event');
  Proc := TIFPSInternalProcedure.Create;
  FProcs.Add(Proc);
  Result := FProcs.Count - 1;
end;

{$IFNDEF IFPS3_NOINTERFACES}
const
  IUnknown_Guid: TGuid = (D1: 0; d2: 0; d3: 0; d4: ($c0,00,00,00,00,00,00,$46));
  IDispatch_Guid: Tguid = (D1: $20400; D2: $0; D3: $0; D4:($C0, $0, $0, $0, $0, $0, $0, $46));
{$ENDIF}
  
procedure TIFPSPascalCompiler.DefineStandardProcedures;
var
  p: TIFPSRegProc;
begin
  AddFunction('function inttostr(i: Longint): string;');
  AddFunction('function strtoint(s: string): Longint;');
  AddFunction('function strtointdef(s: string; def: Longint): Longint;');
  AddFunction('function copy(s: string; ifrom, icount: Longint): string;');
  AddFunction('function pos(substr, s: string): Longint;');
  AddFunction('procedure delete(var s: string; ifrom, icount: Longint);');
  AddFunction('procedure insert(s: string; var s2: string; ipos: Longint);');
  p := AddFunction('function getarraylength: integer;');
  with P.Decl.AddParam do
  begin
    OrgName := 'arr';
    Mode := pmInOut;
  end;
  p := AddFunction('procedure setarraylength;');
  with P.Decl.AddParam do
  begin
    OrgName := 'arr';
    Mode := pmInOut;
  end;
  with P.Decl.AddParam do
  begin
    OrgName := 'count';
    aType := FindBaseType(btS32);
  end;
  AddFunction('Function StrGet(var S : String; I : Integer) : Char;');
  AddFunction('Function StrGet2(S : String; I : Integer) : Char;');
  AddFunction('procedure StrSet(c : Char; I : Integer; var s : String);');
  AddFunction('Function AnsiUppercase(s : string) : string;');
  AddFunction('Function AnsiLowercase(s : string) : string;');
  AddFunction('Function Uppercase(s : string) : string;');
  AddFunction('Function Lowercase(s : string) : string;');
  AddFunction('Function Trim(s : string) : string;');
  AddFunction('Function Length(s : String) : Longint;');
  AddFunction('procedure SetLength(var S: String; L: Longint);');
  AddFunction('Function Sin(e : Extended) : Extended;');
  AddFunction('Function Cos(e : Extended) : Extended;');
  AddFunction('Function Sqrt(e : Extended) : Extended;');
  AddFunction('Function Round(e : Extended) : Longint;');
  AddFunction('Function Trunc(e : Extended) : Longint;');
  AddFunction('Function Int(e : Extended) : Extended;');
  AddFunction('Function Pi : Extended;');
  AddFunction('Function Abs(e : Extended) : Extended;');
  AddFunction('function StrToFloat(s: string): Extended;');
  AddFunction('Function FloatToStr(e : Extended) : String;');
  AddFunction('Function Padl(s : string;I : longInt) : string;');
  AddFunction('Function Padr(s : string;I : longInt) : string;');
  AddFunction('Function Padz(s : string;I : longInt) : string;');
  AddFunction('Function Replicate(c : char;I : longInt) : string;');
  AddFunction('Function StringOfChar(c : char;I : longInt) : string;');
  AddTypeS('TVarType', 'Word');
  AddConstantN('varEmpty', 'Word').Value.tu16 := varempty;
  AddConstantN('varNull', 'Word').Value.tu16 := varnull;
  AddConstantN('varSmallInt', 'Word').Value.tu16 := varsmallint;
  AddConstantN('varInteger', 'Word').Value.tu16 := varinteger;
  AddConstantN('varSingle', 'Word').Value.tu16 := varsingle;
  AddConstantN('varDouble', 'Word').Value.tu16 := vardouble;
  AddConstantN('varCurrency', 'Word').Value.tu16 := varcurrency;
  AddConstantN('varDate', 'Word').Value.tu16 := vardate;
  AddConstantN('varOleStr', 'Word').Value.tu16 := varolestr;
  AddConstantN('varDispatch', 'Word').Value.tu16 := vardispatch;
  AddConstantN('varError', 'Word').Value.tu16 := varerror;
  AddConstantN('varBoolean', 'Word').Value.tu16 := varboolean;
  AddConstantN('varVariant', 'Word').Value.tu16 := varvariant;
  AddConstantN('varUnknown', 'Word').Value.tu16 := varunknown;
{$IFDEF IFPS3_D6PLUS}
  AddConstantN('varShortInt', 'Word').Value.tu16 := varshortint;
  AddConstantN('varByte', 'Word').Value.tu16 := varbyte;
  AddConstantN('varWord', 'Word').Value.tu16 := varword;
  AddConstantN('varLongWord', 'Word').Value.tu16 := varlongword;
  AddConstantN('varInt64', 'Word').Value.tu16 := varint64;
{$ENDIF}
{$IFDEF IFPS3_D4PLUS}
  AddConstantN('varStrArg', 'Word').Value.tu16 := varstrarg;
  AddConstantN('varAny', 'Word').Value.tu16 := varany;
{$ENDIF}
  AddConstantN('varString', 'Word').Value.tu16 := varstring;
  AddConstantN('varTypeMask', 'Word').Value.tu16 := vartypemask;
  AddConstantN('varArray', 'Word').Value.tu16 := vararray;
  AddConstantN('varByRef', 'Word').Value.tu16 := varByRef;
  AddDelphiFunction('function Unassigned: Variant;');
  AddDelphiFunction('function Null: Variant;');
  AddDelphiFunction('function VarType(const V: Variant): TVarType;');
 addTypeS('TIFException', '(ErNoError, erCannotImport, erInvalidType, ErInternalError, '+
   'erInvalidHeader, erInvalidOpcode, erInvalidOpcodeParameter, erNoMainProc, erOutOfGlobalVarsRange, '+
    'erOutOfProcRange, ErOutOfRange, erOutOfStackRange, ErTypeMismatch, erUnexpectedEof, '+
    'erVersionError, ErDivideByZero, ErMathError,erCouldNotCallProc, erOutofRecordRange, '+
    'erOutOfMemory, erException, erNullPointerException, erNullVariantError, erInterfaceNotSupported, erCustomError)');
  AddFunction('procedure RaiseLastException;');
  AddFunction('procedure RaiseException(Ex: TIFException; Param: string);');
  AddFunction('function ExceptionType: TIFException;');
  AddFunction('function ExceptionParam: string;');
  AddFunction('function ExceptionProc: Cardinal;');
  AddFunction('function ExceptionPos: Cardinal;');
  AddFunction('function ExceptionToString(er: TIFException; Param: string): string;');
  {$IFNDEF IFPS3_NOINT64}
  AddFunction('function StrToInt64(s: string): int64;');
  AddFunction('function Int64ToStr(i: Int64): string;');
  {$ENDIF}

  with AddFunction('function SizeOf: Longint;').Decl.AddParam do
  begin
    OrgName := 'Data';
  end;
{$IFNDEF IFPS3_NOINTERFACES}
  with AddInterface(nil, IUnknown_Guid, 'IUnknown') do
  begin
    RegisterDummyMethod; // Query Interface
    RegisterDummyMethod; // _AddRef
    RegisterDummyMethod; // _Release
  end;
 {$IFNDEF IFPS3_NOIDISPATCH}
  with AddInterface(FindInterface('IUnknown'), IDispatch_Guid, 'IDispatch') do
  begin
    RegisterDummyMethod; // GetTypeCount
    RegisterDummyMethod; // GetTypeInfo
    RegisterDummyMethod; // GetIdsOfName
    RegisterDummyMethod; // Invoke
  end;
  with TIFPSInterfaceType(FindType('IDispatch')) do
  begin
    ExportName := True;
  end;
  AddDelphiFunction('function IDispatchInvoke(Self: IDispatch; PropertySet: Boolean; const Name: String; Par: array of variant): variant;');
 {$ENDIF}
{$ENDIF}
end;

function TIFPSPascalCompiler.GetTypeCount: Longint;
begin
  if FProcs = nil then raise EIFPSCompilerException.Create('This function can only be called from within the OnUses event');
  Result := FTypes.Count;
end;

function TIFPSPascalCompiler.GetType(I: Longint): TIFPSType;
begin
  if FProcs = nil then raise EIFPSCompilerException.Create('This function can only be called from within the OnUses event');
  Result := FTypes[I];
end;

function TIFPSPascalCompiler.GetVarCount: Longint;
begin
  if FProcs = nil then raise EIFPSCompilerException.Create('This function can only be called from within the OnUses event');
  Result := FVars.Count;
end;

function TIFPSPascalCompiler.GetVar(I: Longint): TIFPSVar;
begin
  if FProcs = nil then raise EIFPSCompilerException.Create('This function can only be called from within the OnUses event');
  Result := FVars[i];
end;

function TIFPSPascalCompiler.GetProcCount: Longint;
begin
  if FProcs = nil then raise EIFPSCompilerException.Create('This function can only be called from within the OnUses event');
  Result := FProcs.Count;
end;

function TIFPSPascalCompiler.GetProc(I: Longint): TIFPSProcedure;
begin
  if FProcs = nil then raise EIFPSCompilerException.Create('This function can only be called from within the OnUses event');
  Result := FProcs[i];
end;




function TIFPSPascalCompiler.AddUsedFunction2(var Proc: TIFPSExternalProcedure): Cardinal;
begin
  if FProcs = nil then raise EIFPSCompilerException.Create('This function can only be called from within the OnUses event');
  Proc := TIFPSExternalProcedure.Create;
  FProcs.Add(Proc);
  Result := FProcs.Count -1;
end;

function TIFPSPascalCompiler.AddVariable(const Name: string; FType: TIFPSType): TIFPSVar;
var
  P: TIFPSVar;
begin
  if FProcs = nil then raise EIFPSCompilerException.Create('This function can only be called from within the OnUses event');
  if FType = nil then raise EIFPSCompilerException.Create('Invalid type for variable '+Name);
  p := TIFPSVar.Create;
  p.OrgName := Name;
  p.Name := Fastuppercase(Name);
  p.FType := AT2UT(FType);
  if p <> nil then
    p.exportname := FastUppercase(Name);
  FVars.Add(p);
  Result := P;
end;

function TIFPSPascalCompiler.AddAttributeType: TIFPSAttributeType;
begin
  if FAttributeTypes = nil then Raise Exception.Create('This function can only be called from within the OnUses event');
  Result := TIFPSAttributeType.Create;
  FAttributeTypes.Add(Result);
end;

procedure TIFPSPascalCompiler.AddToFreeList(Obj: TObject);
begin
  FAutoFreeList.Add(Obj);
end;

function TIFPSPascalCompiler.AddConstantN(const Name,
  FType: string): TIFPSConstant;
begin
  Result := AddConstant(Name, FindType(FType));
end;

function TIFPSPascalCompiler.AddTypeCopy(const Name: string;
  TypeNo: TIFPSType): TIFPSType;
begin
  if FProcs = nil then raise EIFPSCompilerException.Create('This function can only be called from within the OnUses event');
  TypeNo := GetTypeCopyLink(TypeNo);
  if Typeno = nil then raise EIFPSCompilerException.Create('Invalid Type');
  Result := AddType(Name, BtTypeCopy);
  TIFPSTypeLink(Result).LinkTypeNo := TypeNo;
end;

function TIFPSPascalCompiler.AddTypeCopyN(const Name,
  FType: string): TIFPSType;
begin
  Result := AddTypeCopy(Name, FindType(FType));
end;


function TIFPSPascalCompiler.AddUsedVariable(const Name: string;
  FType: TIFPSType): TIFPSVar;
begin
  Result := AddVariable(Name, FType);
  if Result <> nil then
    Result.Use;
end;

function TIFPSPascalCompiler.AddUsedVariableN(const Name,
  FType: string): TIFPSVar;
begin
  Result := AddVariable(Name, FindType(FType));
  if Result <> nil then
    Result.Use;
end;

function TIFPSPascalCompiler.AddVariableN(const Name,
  FType: string): TIFPSVar;
begin
  Result := AddVariable(Name, FindType(FType));
end;

function TIFPSPascalCompiler.AddUsedPtrVariable(const Name: string; FType: TIFPSType): TIFPSVar;
begin
  Result := AddVariable(Name, FType);
  if Result <> nil then
  begin
    result.SaveAsPointer := True;
    Result.Use;
  end;
end;

function TIFPSPascalCompiler.AddUsedPtrVariableN(const Name, FType: string): TIFPSVar;
begin
  Result := AddVariable(Name, FindType(FType));
  if Result <> nil then
  begin
    result.SaveAsPointer := True;
    Result.Use;
  end;
end;

function TIFPSPascalCompiler.AddTypeS(const Name, Decl: string): TIFPSType;
var
  Parser: TIfPascalParser;
begin
  if FProcs = nil then raise EIFPSCompilerException.Create('This function can only be called from within the OnUses event');
  Parser := TIfPascalParser.Create;
  Parser.SetText(Decl);
  Result := ReadType(Name, Parser);
  Parser.Free;
  if result = nil then Raise EIFPSCompilerException.Create('Unable to register type '+name);
end;


function TIFPSPascalCompiler.CheckCompatProc(P: TIFPSType; ProcNo: Cardinal): Boolean;
var
  i: Longint;
  s1, s2: TIFPSParametersDecl;
begin
  if p.BaseType <> btProcPtr then begin
    Result := False;
    Exit;
  end;

  S1 := TIFPSProceduralType(p).ProcDef;

  if TIFPSProcedure(FProcs[ProcNo]).ClassType = TIFPSInternalProcedure then
    s2 := TIFPSInternalProcedure(FProcs[ProcNo]).Decl
  else
    s2 := TIFPSExternalProcedure(FProcs[ProcNo]).RegProc.Decl;
  if (s1.Result <> s2.Result) or (s1.ParamCount <> s2.ParamCount) then
  begin
    Result := False;
    Exit;
  end;
  for i := 0 to s1.ParamCount -1 do
  begin
    if (s1.Params[i].Mode <> s2.Params[i].Mode) or (s1.Params[i].aType <> s2.Params[i].aType) then
    begin
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;

function TIFPSPascalCompiler.MakeExportDecl(decl: TIFPSParametersDecl): string;
var
  i: Longint;
begin
  if Decl.Result = nil then result := '-1' else
  result := IntToStr(Decl.Result.FinalTypeNo);

  for i := 0 to decl.ParamCount -1 do
  begin
    if decl.GetParam(i).Mode = pmIn then
      Result := Result + ' @'
    else
      Result := Result + ' !';
    Result := Result + inttostr(decl.GetParam(i).aType.FinalTypeNo);
  end;
end;


function TIFPSPascalCompiler.IsIntBoolType(aType: TIFPSType): Boolean;
begin
  if Isboolean(aType) then begin Result := True; exit;end;

  case aType.BaseType of
    btU8, btS8, btU16, btS16, btU32, btS32{$IFNDEF IFPS3_NOINT64}, btS64{$ENDIF}: Result := True;
  else
    Result := False;
  end;
end;


procedure TIFPSPascalCompiler.ParserError(Parser: TObject;
  Kind: TIFParserErrorKind);
begin
  case Kind of
    ICOMMENTERROR: MakeError('', ecCommentError, '');
    ISTRINGERROR: MakeError('', ecStringError, '');
    ICHARERROR: MakeError('', ecCharError, '');
  else
    MakeError('', ecSyntaxError, '');
  end;
end;


function TIFPSPascalCompiler.AddDelphiFunction(const Decl: string): TIFPSRegProc;
var
  p: TIFPSRegProc;
  pDecl: TIFPSParametersDecl;
  DOrgName: string;
  FT: TPMFuncType;
  i: Longint;

begin
  pDecl := TIFPSParametersDecl.Create;
  p := nil;
  try
    if not ParseMethod(Self, '', Decl, DOrgName, pDecl, FT) then
      Raise EIFPSCompilerException.Create('Unable to register function '+Decl);

    p := TIFPSRegProc.Create;
    P.Name := FastUppercase(DOrgName);
    p.OrgName := DOrgName;
    p.ExportName := True;
    p.Decl.Assign(pDecl);

    FRegProcs.Add(p);

    if pDecl.Result = nil then
    begin
      p.ImportDecl := p.ImportDecl + #0;
    end else
      p.ImportDecl := p.ImportDecl + #1;
    for i := 0 to pDecl.ParamCount -1 do
    begin
      if pDecl.Params[i].Mode <> pmIn then
        p.ImportDecl := p.ImportDecl + #1
      else
        p.ImportDecl := p.ImportDecl + #0;
    end;
  finally
    pDecl.Free;
  end;
  Result := p;
end;

{$IFNDEF IFPS3_NOINTERFACES}
function TIFPSPascalCompiler.AddInterface(InheritedFrom: TIFPSInterface; Guid: TGuid; const Name: string): TIFPSInterface;
var
  f: TIFPSType;
begin
  if FProcs = nil then raise EIFPSCompilerException.Create('This function can only be called from within the OnUses event');
  f := AddType(Name, btInterface);
  Result := TIFPSInterface.Create(Self, InheritedFrom, GUID, FastUppercase(Name), f);
  FInterfaces.Add(Result);
  TIFPSInterfaceType(f).Intf := Result;
end;

function TIFPSPascalCompiler.FindInterface(const Name: string): TIFPSInterface;
var
  n: string;
  i, nh: Longint;
begin
  if FProcs = nil then raise EIFPSCompilerException.Create('This function can only be called from within the OnUses event');
  n := FastUpperCase(Name);
  nh := MakeHash(n);
  for i := FInterfaces.Count -1 downto 0 do
  begin
    Result := FInterfaces[i];
    if (Result.NameHash = nh) and (Result.Name = N) then
      exit;
  end;
  Result := nil;
end;
{$ENDIF}
function TIFPSPascalCompiler.AddClass(InheritsFrom: TIFPSCompileTimeClass; aClass: TClass): TIFPSCompileTimeClass;
var
  f: TIFPSType;
begin
  if FProcs = nil then raise EIFPSCompilerException.Create('This function can only be called from within the OnUses event');
  Result := FindClass(aClass.ClassName);
  if Result <> nil then exit;
  f := AddType(aClass.ClassName, btClass);
  Result := TIFPSCompileTimeClass.CreateC(aClass, Self, f);
  Result.FInheritsFrom := InheritsFrom;
  FClasses.Add(Result);
  TIFPSClassType(f).Cl := Result;
  f.ExportName := True;
end;

function TIFPSPascalCompiler.AddClassN(InheritsFrom: TIFPSCompileTimeClass; const aClass: string): TIFPSCompileTimeClass;
var
  f: TIFPSType;
begin
  if FProcs = nil then raise EIFPSCompilerException.Create('This function can only be called from within the OnUses event');
  Result := FindClass(aClass);
  if Result <> nil then
  begin
    if InheritsFrom <> nil then
      Result.FInheritsFrom := InheritsFrom;
    exit;
  end;
  f := AddType(aClass, btClass);
  Result := TIFPSCompileTimeClass.Create(FastUppercase(aClass), Self, f);
  TIFPSClassType(f).Cl := Result;
  Result.FInheritsFrom := InheritsFrom;
  FClasses.Add(Result);
  TIFPSClassType(f).Cl := Result;
  f.ExportName := True;
end;

function TIFPSPascalCompiler.FindClass(const aClass: string): TIFPSCompileTimeClass;
var
  i: Longint;
  Cl: string;
  H: Longint;
  x: TIFPSCompileTimeClass;
begin
  cl := FastUpperCase(aClass);
  H := MakeHash(Cl);
  for i :=0 to FClasses.Count -1 do
  begin
    x := FClasses[I];
    if (X.FClassNameHash = H) and (X.FClassName = Cl) then
    begin
      Result := X;
      Exit;
    end;
  end;
  Result := nil;
end;



{  }

function TransDoubleToStr(D: Double): string;
begin
  SetLength(Result, SizeOf(Double));
  Double((@Result[1])^) := D;
end;

function TransSingleToStr(D: Single): string;
begin
  SetLength(Result, SizeOf(Single));
  Single((@Result[1])^) := D;
end;

function TransExtendedToStr(D: Extended): string;
begin
  SetLength(Result, SizeOf(Extended));
  Extended((@Result[1])^) := D;
end;

function TransLongintToStr(D: Longint): string;
begin
  SetLength(Result, SizeOf(Longint));
  Longint((@Result[1])^) := D;
end;

function TransCardinalToStr(D: Cardinal): string;
begin
  SetLength(Result, SizeOf(Cardinal));
  Cardinal((@Result[1])^) := D;
end;

function TransWordToStr(D: Word): string;
begin
  SetLength(Result, SizeOf(Word));
  Word((@Result[1])^) := D;
end;

function TransSmallIntToStr(D: SmallInt): string;
begin
  SetLength(Result, SizeOf(SmallInt));
  SmallInt((@Result[1])^) := D;
end;

function TransByteToStr(D: Byte): string;
begin
  SetLength(Result, SizeOf(Byte));
  Byte((@Result[1])^) := D;
end;

function TransShortIntToStr(D: ShortInt): string;
begin
  SetLength(Result, SizeOf(ShortInt));
  ShortInt((@Result[1])^) := D;
end;

{ TIFPSType }

constructor TIFPSType.Create;
begin
  inherited Create;
  FAttributes := TIFPSAttributes.Create;
  FFinalTypeNo := InvalidVal;
end;

destructor TIFPSType.Destroy;
begin
  FAttributes.Free;
  inherited Destroy;
end;

procedure TIFPSType.SetName(const Value: string);
begin
  FName := Value;
  FNameHash := MakeHash(Value);
end;

procedure TIFPSType.Use;
begin
  FUsed := True;
end;

{ TIFPSRecordType }

function TIFPSRecordType.AddRecVal: PIFPSRecordFieldTypeDef;
begin
  Result := TIFPSRecordFieldTypeDef.Create;
  FRecordSubVals.Add(Result);
end;

constructor TIFPSRecordType.Create;
begin
  inherited Create;
  FRecordSubVals := TIfList.Create;
end;

destructor TIFPSRecordType.Destroy;
var
  i: Longint;
begin
  for i := FRecordSubVals.Count -1 downto 0 do
    TIFPSRecordFieldTypeDef(FRecordSubVals[I]).Free;
  FRecordSubVals.Free;
  inherited Destroy;
end;

function TIFPSRecordType.RecVal(I: Longint): PIFPSRecordFieldTypeDef;
begin
  Result := FRecordSubVals[I]
end;

function TIFPSRecordType.RecValCount: Longint;
begin
  Result := FRecordSubVals.Count;
end;


{ TIFPSRegProc }

constructor TIFPSRegProc.Create;
begin
  inherited Create;
  FDecl := TIFPSParametersDecl.Create;
end;

destructor TIFPSRegProc.Destroy;
begin
  FDecl.Free;
  inherited Destroy;
end;

procedure TIFPSRegProc.SetName(const Value: string);
begin
  FName := Value;
  FNameHash := MakeHash(FName);
end;

{ TIFPSRecordFieldTypeDef }

procedure TIFPSRecordFieldTypeDef.SetFieldOrgName(const Value: string);
begin
  FFieldOrgName := Value;
  FFieldName := FastUppercase(Value);
  FFieldNameHash := MakeHash(FFieldName);
end;

{ TIFPSProcVar }

procedure TIFPSProcVar.SetName(const Value: string);
begin
  FName := Value;
  FNameHash := MakeHash(FName);
end;

procedure TIFPSProcVar.Use;
begin
  FUsed := True;
end;



{ TIFPSInternalProcedure }

constructor TIFPSInternalProcedure.Create;
begin
  inherited Create;
  FProcVars := TIfList.Create;
  FLabels := TIfStringList.Create;
  FGotos := TIfStringList.Create;
  FDecl := TIFPSParametersDecl.Create;
end;

destructor TIFPSInternalProcedure.Destroy;
var
  i: Longint;
begin
  FDecl.Free;
  for i := FProcVars.Count -1 downto 0 do
    TIFPSProcVar(FProcVars[I]).Free;
  FProcVars.Free;
  FGotos.Free;
  FLabels.Free;
  inherited Destroy;
end;

procedure TIFPSInternalProcedure.ResultUse;
begin
  FResultUsed := True;
end;

procedure TIFPSInternalProcedure.SetName(const Value: string);
begin
  FName := Value;
  FNameHash := MakeHash(FName);
end;

procedure TIFPSInternalProcedure.Use;
begin
  FUsed := True;
end;

{ TIFPSProcedure }
constructor TIFPSProcedure.Create;
begin
  inherited Create;
  FAttributes := TIFPSAttributes.Create;
end;

destructor TIFPSProcedure.Destroy;
begin
  FAttributes.Free;
  inherited Destroy;
end;

{ TIFPSVar }

procedure TIFPSVar.SetName(const Value: string);
begin
  FName := Value;
  FNameHash := MakeHash(Value);
end;

procedure TIFPSVar.Use;
begin
  FUsed := True;
end;

{ TIFPSConstant }

destructor TIFPSConstant.Destroy;
begin
  DisposeVariant(Value);
  inherited Destroy;
end;

procedure TIFPSConstant.SetChar(c: Char);
begin
  if (FValue <> nil) then
  begin
    case FValue.FType.BaseType of
      btChar: FValue.tchar := c;
      btString: string(FValue.tstring) := c;
      {$IFNDEF IFPS3_NOWIDESTRING}
      btWideString: widestring(FValue.twidestring) := c;
      {$ENDIF}
    else
      raise EIFPSCompilerException.Create('Constant Value Type Mismatch');
    end;
  end else
    raise EIFPSCompilerException.Create('Constant Value is not assigned')
end;

procedure TIFPSConstant.SetExtended(const Val: Extended);
begin
  if (FValue <> nil) then
  begin
    case FValue.FType.BaseType of
      btSingle: FValue.tsingle := Val;
      btDouble: FValue.tdouble := Val;
      btExtended: FValue.textended := Val;
      btCurrency: FValue.tcurrency := Val;
    else
      raise EIFPSCompilerException.Create('Constant Value Type Mismatch');
    end;
  end else
    raise EIFPSCompilerException.Create('Constant Value is not assigned')
end;

procedure TIFPSConstant.SetInt(const Val: Longint);
begin
  if (FValue <> nil) then
  begin
    case FValue.FType.BaseType of
      btEnum: FValue.tu32 := Val;
      btU32, btS32: FValue.ts32 := Val;
      btU16, btS16: FValue.ts16 := Val;
      btU8, btS8: FValue.ts8 := Val;
      btSingle: FValue.tsingle := Val;
      btDouble: FValue.tdouble := Val;
      btExtended: FValue.textended := Val;
      btCurrency: FValue.tcurrency := Val;
      {$IFNDEF IFPS3_NOINT64}
      bts64: FValue.ts64 := Val;
      {$ENDIF}
    else
      raise EIFPSCompilerException.Create('Constant Value Type Mismatch');
    end;
  end else
    raise EIFPSCompilerException.Create('Constant Value is not assigned')
end;
{$IFNDEF IFPS3_NOINT64}
procedure TIFPSConstant.SetInt64(const Val: Int64);
begin
  if (FValue <> nil) then
  begin
    case FValue.FType.BaseType of
      btEnum: FValue.tu32 := Val;
      btU32, btS32: FValue.ts32 := Val;
      btU16, btS16: FValue.ts16 := Val;
      btU8, btS8: FValue.ts8 := Val;
      btSingle: FValue.tsingle := Val;
      btDouble: FValue.tdouble := Val;
      btExtended: FValue.textended := Val;
      btCurrency: FValue.tcurrency := Val;
      bts64: FValue.ts64 := Val;
    else
      raise EIFPSCompilerException.Create('Constant Value Type Mismatch');
    end;
  end else
    raise EIFPSCompilerException.Create('Constant Value is not assigned')
end;
{$ENDIF}
procedure TIFPSConstant.SetName(const Value: string);
begin
  FName := Value;
  FNameHash := MakeHash(Value);
end;


procedure TIFPSConstant.SetSet(const val);
begin
  if (FValue <> nil) then
  begin
    case FValue.FType.BaseType of
      btSet:
        begin
          if length(tbtstring(FValue.tstring)) <> TIFPSSetType(FValue.FType).ByteSize then
            SetLength(tbtstring(FValue.tstring), TIFPSSetType(FValue.FType).ByteSize);
          Move(Val, FValue.tstring^, TIFPSSetType(FValue.FType).ByteSize);
        end;
    else
      raise EIFPSCompilerException.Create('Constant Value Type Mismatch');
    end;
  end else
    raise EIFPSCompilerException.Create('Constant Value is not assigned')
end;

procedure TIFPSConstant.SetString(const Val: string);
begin
  if (FValue <> nil) then
  begin
    case FValue.FType.BaseType of
      btString: string(FValue.tstring) := val;
      {$IFNDEF IFPS3_NOWIDESTRING}
      btWideString: widestring(FValue.twidestring) := val;
      {$ENDIF}
    else
      raise EIFPSCompilerException.Create('Constant Value Type Mismatch');
    end;
  end else
    raise EIFPSCompilerException.Create('Constant Value is not assigned')
end;

procedure TIFPSConstant.SetUInt(const Val: Cardinal);
begin
  if (FValue <> nil) then
  begin
    case FValue.FType.BaseType of
      btEnum: FValue.tu32 := Val;
      btU32, btS32: FValue.tu32 := Val;
      btU16, btS16: FValue.tu16 := Val;
      btU8, btS8: FValue.tu8 := Val;
      btSingle: FValue.tsingle := Val;
      btDouble: FValue.tdouble := Val;
      btExtended: FValue.textended := Val;
      btCurrency: FValue.tcurrency := Val;
      {$IFNDEF IFPS3_NOINT64}
      bts64: FValue.ts64 := Val;
      {$ENDIF}
    else
      raise EIFPSCompilerException.Create('Constant Value Type Mismatch');
    end;
  end else
    raise EIFPSCompilerException.Create('Constant Value is not assigned')
end;

{$IFNDEF IFPS3_NOWIDESTRING}
procedure TIFPSConstant.SetWideChar(const val: WideChar);
begin
  if (FValue <> nil) then
  begin
    case FValue.FType.BaseType of
      btString: string(FValue.tstring) := val;
      btWideChar: FValue.twidechar := val;
      btWideString: widestring(FValue.twidestring) := val;
    else
      raise EIFPSCompilerException.Create('Constant Value Type Mismatch');
    end;
  end else
    raise EIFPSCompilerException.Create('Constant Value is not assigned')
end;

procedure TIFPSConstant.SetWideString(const val: WideString);
begin
  if (FValue <> nil) then
  begin
    case FValue.FType.BaseType of
      btString: string(FValue.tstring) := val;
      btWideString: widestring(FValue.twidestring) := val;
    else
      raise EIFPSCompilerException.Create('Constant Value Type Mismatch');
    end;
  end else
    raise EIFPSCompilerException.Create('Constant Value is not assigned')
end;
{$ENDIF}
{ TIFPSPascalCompilerError }

function TIFPSPascalCompilerError.ErrorType: string;
begin
  Result := 'Error';
end;

function TIFPSPascalCompilerError.ShortMessageToString: string;
begin
  case Error of
    ecUnknownIdentifier: Result := 'Unknown identifier ''' + Param + '''';
    ecIdentifierExpected: Result := 'Identifier expected';
    ecCommentError: Result := 'Comment error';
    ecStringError: Result := 'String error';
    ecCharError: Result := 'Char error';
    ecSyntaxError: Result := 'Syntax error';
    ecUnexpectedEndOfFile: Result := 'Unexpected end of file';
    ecSemicolonExpected: Result := 'Semicolon ('';'') expected';
    ecBeginExpected: Result := '''BEGIN'' expected';
    ecPeriodExpected: Result := 'period (''.'') expected';
    ecDuplicateIdentifier: Result := 'Duplicate identifier ''' + Param + '''';
    ecColonExpected: Result := 'colon ('':'') expected';
    ecUnknownType: Result := 'Unknown type ''' + Param + '''';
    ecCloseRoundExpected: Result := 'Close round expected';
    ecTypeMismatch: Result := 'Type mismatch';
    ecInternalError: Result := 'Internal error (' + Param + ')';
    ecAssignmentExpected: Result := 'Assignment expected';
    ecThenExpected: Result := '''THEN'' expected';
    ecDoExpected: Result := '''DO'' expected';
    ecNoResult: Result := 'No result';
    ecOpenRoundExpected: Result := 'open round (''('')expected';
    ecCommaExpected: Result := 'comma ('','') expected';
    ecToExpected: Result := '''TO'' expected';
    ecIsExpected: Result := 'is (''='') expected';
    ecOfExpected: Result := '''OF'' expected';
    ecCloseBlockExpected: Result := 'Close block('']'') expected';
    ecVariableExpected: Result := 'Variable Expected';
    ecStringExpected: result := 'String Expected';
    ecEndExpected: Result := '''END'' expected';
    ecUnSetLabel: Result := 'Label '''+Param+''' not set';
    ecNotInLoop: Result := 'Not in a loop';
    ecInvalidJump: Result := 'Invalid jump';
    ecOpenBlockExpected: Result := 'Open Block (''['') expected';
    ecWriteOnlyProperty: Result := 'Write-only property';
    ecReadOnlyProperty: Result := 'Read-only property';
    ecClassTypeExpected: Result := 'Class type expected';
    ecCustomError: Result := Param;
    ecDivideByZero: Result := 'Divide by Zero';
    ecMathError:  Result := 'Math Error';
    ecUnsatisfiedForward: Result := 'Unsatisfied Forward '+ Param;
    ecForwardParameterMismatch: Result := 'Forward Parameter Mismatch';
    ecInvalidnumberOfParameters: Result := 'Invalid number of parameters';
  else
    Result := 'Unknown error';
  end;
  Result := Result;
end;


{ TIFPSPascalCompilerHint }

function TIFPSPascalCompilerHint.ErrorType: string;
begin
  Result := 'Hint';
end;

function TIFPSPascalCompilerHint.ShortMessageToString: string;
begin
  case Hint of
    ehVariableNotUsed: Result := 'Variable ''' + Param + ''' never used';
    ehFunctionNotUsed: Result := 'Function ''' + Param + ''' never used';
    ehCustomHint: Result := Param;
  else
    Result := 'Unknown hint';
  end;
end;

{ TIFPSPascalCompilerWarning }

function TIFPSPascalCompilerWarning.ErrorType: string;
begin
  Result := 'Warning';
end;

function TIFPSPascalCompilerWarning.ShortMessageToString: string;
begin
  case Warning of
    ewCustomWarning: Result := Param;
    ewCalculationAlwaysEvaluatesTo: Result := 'Calculation always evaluates to '+Param;
    ewIsNotNeeded: Result := Param +' is not needed';
    ewAbstractClass: Result := 'Abstract Class Construction';
  else
    Result := 'Unknown warning';
  end;
end;

{ TIFPSPascalCompilerMessage }

function TIFPSPascalCompilerMessage.MessageToString: string;
begin
  Result := '['+ErrorType+'] '+FModuleName+'('+IntToStr(FRow)+':'+IntToStr(FCol)+'): '+ShortMessageToString;
end;

procedure TIFPSPascalCompilerMessage.SetParserPos(Parser: TIfPascalParser);
begin
  FPosition := Parser.CurrTokenPos;
  FRow := Parser.Row;
  FCol := Parser.Col;
end;

procedure TIFPSPascalCompilerMessage.SetCustomPos(Pos, Row, Col: Cardinal);
begin
  FPosition := Pos;
  FRow := Row;
  FCol := Col;
end;

{ TUnConstOperation }

destructor TUnConstOperation.Destroy;
begin
  FVal1.Free;
  inherited Destroy;
end;


{ TBinConstOperation }

destructor TBinConstOperation.Destroy;
begin
  FVal1.Free;
  FVal2.Free;
  inherited Destroy;
end;

{ TConstData }

destructor TConstData.Destroy;
begin
  DisposeVariant(FData);
  inherited Destroy;
end;


{ TConstOperation }

procedure TConstOperation.SetPos(Parser: TIfPascalParser);
begin
  FDeclPosition := Parser.CurrTokenPos;
  FDeclRow := Parser.Row;
  FDeclCol := Parser.Col;
end;

{ TIFPSValue }

procedure TIFPSValue.SetParserPos(P: TIfPascalParser);
begin
  FPos := P.CurrTokenPos;
  FRow := P.Row;
  FCol := P.Col;
end;

{ TIFPSValueData }

destructor TIFPSValueData.Destroy;
begin
  DisposeVariant(FData);
  inherited Destroy;
end;


{ TIFPSValueReplace }

constructor TIFPSValueReplace.Create;
begin
  FFreeNewValue := True;
  FReplaceTimes := 1;
end;

destructor TIFPSValueReplace.Destroy;
begin
  if FFreeOldValue then
    FOldValue.Free;
  if FFreeNewValue then
    FNewValue.Free;
  inherited Destroy;
end;



{ TIFPSUnValueOp }

destructor TIFPSUnValueOp.Destroy;
begin
  FVal1.Free;
  inherited Destroy;
end;

{ TIFPSBinValueOp }

destructor TIFPSBinValueOp.Destroy;
begin
  FVal1.Free;
  FVal2.Free;
  inherited Destroy;
end;




{ TIFPSSubValue }

destructor TIFPSSubValue.Destroy;
begin
  FSubNo.Free;
  inherited Destroy;
end;

{ TIFPSValueVar }

constructor TIFPSValueVar.Create;
begin
  inherited Create;
  FRecItems := TIfList.Create;
end;

destructor TIFPSValueVar.Destroy;
var
  i: Longint;
begin
  for i := 0 to FRecItems.Count -1 do
  begin
    TIFPSSubItem(FRecItems[I]).Free;
  end;
  FRecItems.Free;
  inherited Destroy;
end;

function TIFPSValueVar.GetRecCount: Cardinal;
begin
  Result := FRecItems.Count;
end;

function TIFPSValueVar.GetRecItem(I: Cardinal): TIFPSSubItem;
begin
  Result := FRecItems[I];
end;

function TIFPSValueVar.RecAdd(Val: TIFPSSubItem): Cardinal;
begin
  Result := FRecItems.Add(Val);
end;

procedure TIFPSValueVar.RecDelete(I: Cardinal);
var
  rr :TIFPSSubItem;
begin
  rr := FRecItems[i];
  FRecItems.Delete(I);
  rr.Free;
end;

{ TIFPSValueProc }

destructor TIFPSValueProc.Destroy;
begin
  FSelfPtr.Free;
  FParameters.Free;
end;
{ TIFPSParameter }

destructor TIFPSParameter.Destroy;
begin
  FTempVar.Free;
  FValue.Free;
  inherited Destroy;
end;


  { TIFPSParameters }

function TIFPSParameters.Add: TIFPSParameter;
begin
  Result := TIFPSParameter.Create;
  FItems.Add(Result);
end;

constructor TIFPSParameters.Create;
begin
  inherited Create;
  FItems := TIfList.Create;
end;

procedure TIFPSParameters.Delete(I: Cardinal);
var
  p: TIFPSParameter;
begin
  p := FItems[I];
  FItems.Delete(i);
  p.Free;
end;

destructor TIFPSParameters.Destroy;
var
  i: Longint;
begin
  for i := FItems.Count -1 downto 0 do
  begin
    TIFPSParameter(FItems[I]).Free;
  end;
  FItems.Free;
  inherited Destroy;
end;

function TIFPSParameters.GetCount: Cardinal;
begin
  Result := FItems.Count;
end;

function TIFPSParameters.GetItem(I: Longint): TIFPSParameter;
begin
  Result := FItems[I];
end;


{ TIFPSValueArray }

function TIFPSValueArray.Add(Item: TIFPSValue): Cardinal;
begin
  Result := FItems.Add(Item);
end;

constructor TIFPSValueArray.Create;
begin
  inherited Create;
  FItems := TIfList.Create;
end;

procedure TIFPSValueArray.Delete(I: Cardinal);
begin
  FItems.Delete(i);
end;

destructor TIFPSValueArray.Destroy;
var
  i: Longint;
begin
  for i := FItems.Count -1 downto 0 do
    TIFPSValue(FItems[I]).Free;
  FItems.Free;

  inherited Destroy;
end;

function TIFPSValueArray.GetCount: Cardinal;
begin
  Result := FItems.Count;
end;

function TIFPSValueArray.GetItem(I: Cardinal): TIFPSValue;
begin
  Result := FItems[I];
end;


{ TIFPSValueAllocatedStackVar }

destructor TIFPSValueAllocatedStackVar.Destroy;
var
  pv: TIFPSProcVar;
begin
  {$IFDEF DEBUG}
  if Cardinal(LocalVarNo +1) <> proc.ProcVars.Count then
  begin
    Abort;
    exit;
  end;
  {$ENDIF}
  if Proc <> nil then
  begin
    pv := Proc.ProcVars[Proc.ProcVars.Count -1];
    Proc.ProcVars.Delete(Proc.ProcVars.Count -1);
    pv.Free;
    Proc.Data := Proc.Data + Char(CM_PO);
  end;
  inherited Destroy;
end;




function AddImportedClassVariable(Sender: TIFPSPascalCompiler; const VarName, VarType: string): Boolean;
var
  P: TIFPSVar;
begin
  P := Sender.AddVariableN(VarName, VarType);
  if p = nil then
  begin
    Result := False;
    Exit;
  end;
  SetVarExportName(P, FastUppercase(VarName));
  p.Use;
  Result := True;
end;


{'class:'+CLASSNAME+'|'+FUNCNAME+'|'+chr(CallingConv)+chr(hasresult)+params

For property write functions there is an '@' after the funcname.
}

const
  ProcHDR = 'procedure a;';



{ TIFPSCompileTimeClass }

function TIFPSCompileTimeClass.CastToType(IntoType: TIFPSType;
  var ProcNo: Cardinal): Boolean;
var
  P: TIFPSExternalProcedure;
begin
  if (IntoType <> nil) and (IntoType.BaseType <> btClass) and (IntoType.BaseType <> btInterface) then
  begin
    Result := False;
    exit;
  end;
  if FCastProc <> InvalidVal then
  begin
    Procno := FCastProc;
    Result := True;
    exit;
  end;
  ProcNo := FOwner. AddUsedFunction2(P);
  P.RegProc := FOwner.AddFunction(ProcHDR);
  P.RegProc.Name := '';

  with P.RegProc.Decl.AddParam do
  begin
    OrgName := 'Org';
    aType := Self.FType;
  end;
  with P.RegProc.Decl.AddParam do
  begin
    OrgName := 'TypeNo';
    aType := FOwner.at2ut(FOwner.FindBaseType(btU32));
  end;
  P.RegProc.Decl.Result := IntoType;
  P.RegProc.ImportDecl := 'class:+';
  FCastProc := ProcNo;
  Result := True;
end;


function TIFPSCompileTimeClass.ClassFunc_Call(Index: Cardinal;
  var ProcNo: Cardinal): Boolean;
var
  C: TIFPSDelphiClassItemConstructor;
  P: TIFPSExternalProcedure;
  s: string;
  i: Longint;

begin
  if FIsAbstract then
    FOwner.MakeWarning('', ewAbstractClass, '');
  C := Pointer(Index);
  if c.MethodNo = InvalidVal then
  begin
    ProcNo := FOwner.AddUsedFunction2(P);
    P.RegProc := FOwner.AddFunction(ProcHDR);
    P.RegProc.Name := '';
    P.RegProc.Decl.Assign(c.Decl);
    s := 'class:' + C.Owner.FClassName + '|' + C.Name + '|'+ chr(0);
    if c.Decl.Result = nil then
      s := s + #0
    else
      s := s + #1;
    for i := 0 to C.Decl.ParamCount -1 do
    begin
      if c.Decl.Params[i].Mode <> pmIn then
        s := s + #1
      else
        s := s + #0;
    end;
    P.RegProc.ImportDecl := s;
    C.MethodNo := ProcNo;
  end else begin
     ProcNo := c.MethodNo;
  end;
  Result := True;
end;

function TIFPSCompileTimeClass.ClassFunc_Find(const Name: string;
  var Index: Cardinal): Boolean;
var
  H: Longint;
  I: Longint;
  CurrClass: TIFPSCompileTimeClass;
  C: TIFPSDelphiClassItem;
begin
  H := MakeHash(Name);
  CurrClass := Self;
  while CurrClass <> nil do
  begin
    for i := CurrClass.FClassItems.Count -1 downto 0 do
    begin
      C := CurrClass.FClassItems[I];
      if (c is TIFPSDelphiClassItemConstructor) and (C.NameHash = H) and (C.Name = Name) then
      begin
        Index := Cardinal(C);
        Result := True;
        exit;
      end;
    end;
    CurrClass := CurrClass.FInheritsFrom;
  end;
  Result := False;
end;


class function TIFPSCompileTimeClass.CreateC(FClass: TClass; aOwner: TIFPSPascalCompiler; aType: TIFPSType): TIFPSCompileTimeClass;
begin
  Result := TIFPSCompileTimeClass.Create(FastUpperCase(FClass.ClassName), aOwner, aType);
  Result.FClass := FClass;
end;

constructor TIFPSCompileTimeClass.Create(ClassName: string; aOwner: TIFPSPascalCompiler; aType: TIFPSType);
begin
  inherited Create;
  FType := aType;
  FCastProc := InvalidVal;
  FNilProc := InvalidVal;

  FDefaultProperty := InvalidVal;
  FClassName := Classname;
  FClassNameHash := MakeHash(FClassName);
  FClassItems := TIfList.Create;
  FOwner := aOwner;
end;

destructor TIFPSCompileTimeClass.Destroy;
var
  I: Longint;
begin
  for i := FClassItems.Count -1 downto 0 do
    TIFPSDelphiClassItem(FClassItems[I]).Free;
  FClassItems.Free;
  inherited Destroy;
end;


function TIFPSCompileTimeClass.Func_Call(Index: Cardinal;
  var ProcNo: Cardinal): Boolean;
var
  C: TIFPSDelphiClassItemMethod;
  P: TIFPSExternalProcedure;
  i: Longint;
  s: string;

begin
  C := Pointer(Index);
  if c.MethodNo = InvalidVal then
  begin
    ProcNo := FOwner.AddUsedFunction2(P);
    P.RegProc := FOwner.AddFunction(ProcHDR);
    P.RegProc.Name := '';
    p.RegProc.Decl.Assign(c.Decl);
    s := 'class:' + C.Owner.FClassName + '|' + C.Name + '|'+ chr(0);
    if c.Decl.Result = nil then
      s := s + #0
    else
      s := s + #1;
    for i := 0 to c.Decl.ParamCount -1 do
    begin
      if c.Decl.Params[i].Mode <> pmIn then
        s := s + #1
      else
        s := s + #0;
    end;
    P.RegProc.ImportDecl := s;
    C.MethodNo := ProcNo;
  end else begin
     ProcNo := c.MethodNo;
  end;
  Result := True;
end;

function TIFPSCompileTimeClass.Func_Find(const Name: string;
  var Index: Cardinal): Boolean;
var
  H: Longint;
  I: Longint;
  CurrClass: TIFPSCompileTimeClass;
  C: TIFPSDelphiClassItem;
begin
  H := MakeHash(Name);
  CurrClass := Self;
  while CurrClass <> nil do
  begin
    for i := CurrClass.FClassItems.Count -1 downto 0 do
    begin
      C := CurrClass.FClassItems[I];
      if (c is TIFPSDelphiClassItemMethod) and (C.NameHash = H) and (C.Name = Name) then
      begin
        Index := Cardinal(C);
        Result := True;
        exit;
      end;
    end;
    CurrClass := CurrClass.FInheritsFrom;
  end;
  Result := False;
end;

function TIFPSCompileTimeClass.GetCount: Longint;
begin
  Result := FClassItems.Count;
end;

function TIFPSCompileTimeClass.GetItem(i: Longint): TIFPSDelphiClassItem;
begin
  Result := FClassItems[i];
end;

function TIFPSCompileTimeClass.IsCompatibleWith(aType: TIFPSType): Boolean;
var
  Temp: TIFPSCompileTimeClass;
begin
  if (atype.BaseType <> btClass) then
  begin
    Result := False;
    exit;
  end;
  temp := TIFPSClassType(aType).Cl;
  while Temp <> nil do
  begin
    if Temp = Self then
    begin
      Result := True;
      exit;
    end;
    Temp := Temp.FInheritsFrom;
  end;
  Result := False;
end;

function TIFPSCompileTimeClass.Property_Find(const Name: string;
  var Index: Cardinal): Boolean;
var
  H: Longint;
  I: Longint;
  CurrClass: TIFPSCompileTimeClass;
  C: TIFPSDelphiClassItem;
begin
  if Name = '' then
  begin
    CurrClass := Self;
    while CurrClass <> nil do
    begin
      if CurrClass.FDefaultProperty <> InvalidVal then
      begin
        Index := Cardinal(CurrClass.FClassItems[Currclass.FDefaultProperty]);
        result := True;
        exit;
      end;
      CurrClass := CurrClass.FInheritsFrom;
    end;
    Result := False;
    exit;
  end;
  H := MakeHash(Name);
  CurrClass := Self;
  while CurrClass <> nil do
  begin
    for i := CurrClass.FClassItems.Count -1 downto 0 do
    begin
      C := CurrClass.FClassItems[I];
      if (c is TIFPSDelphiClassItemProperty) and (C.NameHash = H) and (C.Name = Name) then
      begin
        Index := Cardinal(C);
        Result := True;
        exit;
      end;
    end;
    CurrClass := CurrClass.FInheritsFrom;
  end;
  Result := False;
end;

function TIFPSCompileTimeClass.Property_Get(Index: Cardinal;
  var ProcNo: Cardinal): Boolean;
var
  C: TIFPSDelphiClassItemProperty;
  P: TIFPSExternalProcedure;
  s: string;

begin
  C := Pointer(Index);
  if c.AccessType = iptW then
  begin
    Result := False;
    exit;
  end;
  if c.ReadProcNo = InvalidVal then
  begin
    ProcNo := FOwner.AddUsedFunction2(P);
    P.RegProc := FOwner.AddFunction(ProcHDR);
    P.RegProc.Name := '';
    P.RegProc.Decl.Result := C.Decl.Result;
    s := 'class:' + C.Owner.FClassName + '|' + C.Name + '|'+#0#0#0#0;
    Longint((@(s[length(s)-3]))^) := c.Decl.ParamCount +1;
    P.RegProc.ImportDecl := s;
    C.ReadProcNo := ProcNo;
  end else begin
     ProcNo := c.ReadProcNo;
  end;
  Result := True;
end;

function TIFPSCompileTimeClass.Property_GetHeader(Index: Cardinal;
  Dest: TIFPSParametersDecl): Boolean;
var
  c: TIFPSDelphiClassItemProperty;
begin
  C := Pointer(Index);
  FOwner.UseProc(c.Decl);
  Dest.Assign(c.Decl);
  Result := True;
end;

function TIFPSCompileTimeClass.Property_Set(Index: Cardinal;
  var ProcNo: Cardinal): Boolean;
var
  C: TIFPSDelphiClassItemProperty;
  P: TIFPSExternalProcedure;
  s: string;

begin
  C := Pointer(Index);
  if c.AccessType = iptR then
  begin
    Result := False;
    exit;
  end;
  if c.WriteProcNo = InvalidVal then
  begin
    ProcNo := FOwner.AddUsedFunction2(P);
    P.RegProc := FOwner.AddFunction(ProcHDR);
    P.RegProc.Name := '';
    s := 'class:' + C.Owner.FClassName + '|' + C.Name + '@|'#0#0#0#0;
    Longint((@(s[length(s)-3]))^) := C.Decl.ParamCount+1;
    P.RegProc.ImportDecl := s;
    C.WriteProcNo := ProcNo;
  end else begin
     ProcNo := c.WriteProcNo;
  end;
  Result := True;
end;

function TIFPSCompileTimeClass.RegisterMethod(const Decl: string): Boolean;
var
  DOrgName: string;
  DDecl: TIFPSParametersDecl;
  FT: TPMFuncType;
  p: TIFPSDelphiClassItemMethod;
begin
  DDecl := TIFPSParametersDecl.Create;
  try
  if not ParseMethod(FOwner, FClassName, Decl, DOrgName, DDecl, FT) then
  begin
    Result := False;
    {$IFDEF DEBUG} raise EIFPSCompilerException.Create('Unable to register '+Decl); {$ENDIF}
    exit;
  end;
  if ft = mftConstructor then
    p := TIFPSDelphiClassItemConstructor.Create(Self)
  else
    p := TIFPSDelphiClassItemMethod.Create(self);
  p.OrgName := DOrgName;
  p.Decl.Assign(DDecl);
  p.MethodNo := InvalidVal;
  FClassItems.Add(p);
  finally
    DDecl.Free;
  end;
  Result := True;
end;

procedure TIFPSCompileTimeClass.RegisterProperty(const PropertyName,
  PropertyType: string; PropAC: TIFPSPropType);
var
  FType: TIFPSType;
  Param: TIFPSParameterDecl;
  p: TIFPSDelphiClassItemProperty;
  PT: string;
begin
  pt := PropertyType;
  p := TIFPSDelphiClassItemProperty.Create(Self);
  p.AccessType := PropAC;
  p.ReadProcNo := InvalidVal;
  p.WriteProcNo := InvalidVal;
  p.OrgName := PropertyName;
  repeat
    FType := FOwner.FindType(FastUpperCase(grfw(pt)));
    if FType = nil then
    begin
      p.Free;
      Exit;
    end;
    if p.Decl.Result = nil  then p.Decl.Result := FType else
    begin
      param := p.Decl.AddParam;
      Param.OrgName := 'param'+IntToStr(p.Decl.ParamCount);
      Param.aType := FType;
    end;
  until pt = '';
  FClassItems.Add(p);
end;


procedure TIFPSCompileTimeClass.RegisterPublishedProperties;
var
  p: PPropList;
  i, Count: Longint;
  a: TIFPSPropType;
begin
  if (Fclass = nil) or (Fclass.ClassInfo = nil) then exit;
  Count := GetTypeData(fclass.ClassInfo)^.PropCount;
  GetMem(p, Count * SizeOf(Pointer));
  GetPropInfos(fclass.ClassInfo, p);
  for i := Count -1 downto 0 do
  begin
    if p^[i]^.PropType^.Kind in [tkLString, tkInteger, tkChar, tkEnumeration, tkFloat, tkString, tkSet, tkClass, tkMethod] then
    begin
      if (p^[i]^.GetProc <> nil) then
      begin
        if p^[i]^.SetProc = nil then
          a := iptr
        else
          a := iptrw;
      end else
      begin
        a := iptW;
        if p^[i]^.SetProc = nil then continue;
      end;
      RegisterProperty(p^[i]^.Name, p^[i]^.PropType^.Name, a);
    end;
  end;
  FreeMem(p);
end;

function TIFPSCompileTimeClass.RegisterPublishedProperty(const Name: string): Boolean;
var
  p: PPropInfo;
  a: TIFPSPropType;
begin
  if (Fclass = nil) or (Fclass.ClassInfo = nil) then begin Result := False; exit; end;
  p := GetPropInfo(fclass.ClassInfo, Name);
  if p = nil then begin Result := False; exit; end;
  if (p^.GetProc <> nil) then
  begin
    if p^.SetProc = nil then
      a := iptr
    else
      a := iptrw;
  end else
  begin
    a := iptW;
    if p^.SetProc = nil then begin result := False; exit; end;
  end;
  RegisterProperty(p^.Name, p^.PropType^.Name, a);
  Result := True;
end;


procedure TIFPSCompileTimeClass.SetDefaultPropery(const Name: string);
var
  i,h: Longint;
  p: TIFPSDelphiClassItem;
  s: string;

begin
  s := FastUppercase(name);
  h := MakeHash(s);
  for i := FClassItems.Count -1 downto 0 do
  begin
    p := FClassItems[i];
    if (p.NameHash = h) and (p.Name = s) then
    begin
      if p is TIFPSDelphiClassItemProperty then
      begin
        if p.Decl.ParamCount = 0 then
          Raise EIFPSCompilerException.Create('Not an array property');
        FDefaultProperty := I;
        exit;
      end else Raise EIFPSCompilerException.Create('Not a property');
    end;
  end;
  raise EIFPSCompilerException.Create('Unknown Property');
end;

function TIFPSCompileTimeClass.SetNil(var ProcNo: Cardinal): Boolean;
var
  P: TIFPSExternalProcedure;

begin
  if FNilProc <> InvalidVal then
  begin
    Procno := FNilProc;
    Result := True;
    exit;
  end;
  ProcNo := FOwner.AddUsedFunction2(P);
  P.RegProc := FOwner.AddFunction(ProcHDR);
  P.RegProc.Name := '';
  with P.RegProc.Decl.AddParam do
  begin
    OrgName := 'VarNo';
    aType := FOwner.at2ut(FType);
  end;
  P.RegProc.ImportDecl := 'class:-';
  FNilProc := Procno;
  Result := True;
end;

{ TIFPSSetType }

function TIFPSSetType.GetBitSize: Longint;
begin
  case SetType.BaseType of
    btEnum: begin Result := TIFPSEnumType(setType).HighValue+1; end;
    btChar, btU8: Result := 256;
  else
    Result := 0;
  end;
end;

function TIFPSSetType.GetByteSize: Longint;
var
  r: Longint;
begin
  r := BitSize;
  if r mod 8 <> 0 then inc(r, 7);
   Result := r div 8;
end;


{ TIFPSBlockInfo }

procedure TIFPSBlockInfo.Clear;
var
  i: Longint;
begin
  for i := WithList.Count -1 downto 0 do
  begin
    TIFPSValue(WithList[i]).Free;
    WithList.Delete(i);
  end;
end;

constructor TIFPSBlockInfo.Create(Owner: TIFPSBlockInfo);
begin
  inherited Create;
  FOwner := Owner;
  FWithList := TIfList.Create;
  if FOwner <> nil then
  begin
    FProcNo := FOwner.ProcNo;
    FProc := FOwner.Proc;
  end;
end;

destructor TIFPSBlockInfo.Destroy;
begin
  Clear;
  FWithList.Free;
  inherited Destroy;
end;

{ TIFPSAttributeTypeField }
procedure TIFPSAttributeTypeField.SetFieldOrgName(const Value: string);
begin
  FFieldOrgName := Value;
  FFieldName := FastUpperCase(Value);
  FFieldNameHash := MakeHash(FFieldName);
end;

constructor TIFPSAttributeTypeField.Create(AOwner: TIFPSAttributeType);
begin
  inherited Create;
  FOwner := AOwner;
end;

{ TIFPSAttributeType }

function TIFPSAttributeType.GetField(I: Longint): TIFPSAttributeTypeField;
begin
  Result := TIFPSAttributeTypeField(FFields[i]);
end;

function TIFPSAttributeType.GetFieldCount: Longint;
begin
  Result := FFields.Count;
end;

procedure TIFPSAttributeType.SetName(const s: string);
begin
  FOrgname := s;
  FName := Uppercase(s);
  FNameHash := MakeHash(FName);
end;

constructor TIFPSAttributeType.Create;
begin
  inherited Create;
  FFields := TIfList.Create;
end;

destructor TIFPSAttributeType.Destroy;
var
  i: Longint;
begin
  for i := FFields.Count -1 downto 0 do
  begin
    TIFPSAttributeTypeField(FFields[i]).Free;
  end;
  FFields.Free;
  inherited Destroy;
end;

function TIFPSAttributeType.AddField: TIFPSAttributeTypeField;
begin
  Result := TIFPSAttributeTypeField.Create(self);
  FFields.Add(Result);
end;

procedure TIFPSAttributeType.DeleteField(I: Longint);
var
  Fld: TIFPSAttributeTypeField;
begin
  Fld := FFields[i];
  FFields.Delete(i);
  Fld.Free;
end;

{ TIFPSAttribute }
function TIFPSAttribute.GetValueCount: Longint;
begin
  Result := FValues.Count;
end;

function TIFPSAttribute.GetValue(I: Longint): PIfRVariant;
begin
  Result := FValues[i];
end;

constructor TIFPSAttribute.Create(AttribType: TIFPSAttributeType);
begin
  inherited Create;
  FValues := TIfList.Create;
  FAttribType := AttribType;
end;

procedure TIFPSAttribute.DeleteValue(i: Longint);
var
  Val: PIfRVariant;
begin
  Val := FValues[i];
  FValues.Delete(i);
  DisposeVariant(Val);
end;

function TIFPSAttribute.AddValue(v: PIFRVariant): Longint;
begin
  Result := FValues.Add(v);
end;


destructor TIFPSAttribute.Destroy;
var
  i: Longint;
begin
  for i := FValues.Count -1 downto 0 do
  begin
    DisposeVariant(FValues[i]);
  end;
  FValues.Free;
  inherited Destroy;
end;


procedure TIFPSAttribute.Assign(Item: TIFPSAttribute);
var
  i: Longint;
  p: PIfRVariant;
begin
  for i := FValues.Count -1 downto 0 do
  begin
    DisposeVariant(FValues[i]);
  end;
  FValues.Clear;
  FAttribType := Item.FAttribType;
  for i := 0 to Item.FValues.Count -1 do
  begin
    p := DuplicateVariant(Item.FValues[i]);
    FValues.Add(p);
  end;
end;

{ TIFPSAttributes }

function TIFPSAttributes.GetCount: Longint;
begin
  Result := FItems.Count;
end;

function TIFPSAttributes.GetItem(I: Longint): TIFPSAttribute;
begin
  Result := TIFPSAttribute(FItems[i]);
end;

procedure TIFPSAttributes.Delete(i: Longint);
var
  item: TIFPSAttribute;
begin
  item := TIFPSAttribute(FItems[i]);
  FItems.Delete(i);
  Item.Free;
end;

function TIFPSAttributes.Add(AttribType: TIFPSAttributeType): TIFPSAttribute;
begin
  Result := TIFPSAttribute.Create(AttribType);
  FItems.Add(Result);
end;

constructor TIFPSAttributes.Create;
begin
  inherited Create;
  FItems := TIfList.Create;
end;

destructor TIFPSAttributes.Destroy;
var
  i: Longint;
begin
  for i := FItems.Count -1 downto 0 do
  begin
    TIFPSType(FItems[i]).Free;
  end;
  FItems.Free;
  inherited Destroy;
end;

procedure TIFPSAttributes.Assign(attr: TIFPSAttributes; Move: Boolean);
var
  newitem, item: TIFPSAttribute;
  i: Longint;
begin
  for i := ATtr.FItems.Count -1 downto 0 do
  begin
    Item := Attr.Fitems[i];
    if Move then
    begin
      FItems.Add(Item);
      Attr.FItems.Delete(i);
    end else
    begin
      newitem := TIFPSAttribute.Create(Item.FAttribType );
      newitem.Assign(item);
      FItems.Add(NewItem);
    end;
  end;

end;


function TIFPSAttributes.FindAttribute(
  const Name: string): TIFPSAttribute;
var
  h, i: Longint;

begin
  h := MakeHash(name);
  for i := FItems.Count -1 downto 0 do
  begin
    Result := FItems[i];
    if (Result.FAttribType.NameHash = h) and (Result.FAttribType.Name = Name) then
      exit;
  end;
  result := nil;
end;

{ TIFPSParameterDecl }
procedure TIFPSParameterDecl.SetName(const s: string);
begin
  FOrgName := s;
  FName := FastUppercase(s);
end;


{ TIFPSParametersDecl }

procedure TIFPSParametersDecl.Assign(Params: TIFPSParametersDecl);
var
  i: Longint;
  np, orgp: TIFPSParameterDecl;
begin
  for i := FParams.Count -1 downto 0 do
  begin
    TIFPSParameterDecl(Fparams[i]).Free;
  end;
  FParams.Clear;
  FResult := Params.Result;

  for i := 0 to Params.FParams.count -1 do
  begin
    orgp := Params.FParams[i];
    np := AddParam;
    np.OrgName := orgp.OrgName;
    np.Mode := orgp.Mode;
    np.aType := orgp.aType;
  end;
end;


function TIFPSParametersDecl.GetParam(I: Longint): TIFPSParameterDecl;
begin
  Result := FParams[i];
end;

function TIFPSParametersDecl.GetParamCount: Longint;
begin
  Result := FParams.Count;
end;

function TIFPSParametersDecl.AddParam: TIFPSParameterDecl;
begin
  Result := TIFPSParameterDecl.Create;
  FParams.Add(Result);
end;

procedure TIFPSParametersDecl.DeleteParam(I: Longint);
var
  param: TIFPSParameter;
begin
  param := FParams[i];
  FParams.Delete(i);
  Param.Free;
end;

constructor TIFPSParametersDecl.Create;
begin
  inherited Create;
  FParams := TIfList.Create;
end;

destructor TIFPSParametersDecl.Destroy;
var
  i: Longint;
begin
  for i := FParams.Count -1 downto 0 do
  begin
    TIFPSParameterDecl(Fparams[i]).Free;
  end;
  FParams.Free;
  inherited Destroy;
end;

function TIFPSParametersDecl.Same(d: TIFPSParametersDecl): boolean;
var
  i: Longint;
begin
  if (d = nil) or (d.ParamCount <> ParamCount) or (d.Result <> Self.Result) then
    Result := False
  else begin
    for i := 0 to d.ParamCount -1 do
    begin
      if (d.Params[i].Mode <> Params[i].Mode) or (d.Params[i].aType <> Params[i].aType) then
      begin
        Result := False;
        exit;
      end;
    end;
    Result := True;
  end;
end;

{ TIFPSProceduralType }

constructor TIFPSProceduralType.Create;
begin
  inherited Create;
  FProcDef := TIFPSParametersDecl.Create;

end;

destructor TIFPSProceduralType.Destroy;
begin
  FProcDef.Free;
  inherited Destroy;
end;

{ TIFPSDelphiClassItem }

procedure TIFPSDelphiClassItem.SetName(const s: string);
begin
  FOrgName := s;
  FName := FastUpperCase(s);
  FNameHash := MakeHash(FName);
end;

constructor TIFPSDelphiClassItem.Create(Owner: TIFPSCompileTimeClass);
begin
  inherited Create;
  FOwner := Owner;
  FDecl := TIFPSParametersDecl.Create;
end;

destructor TIFPSDelphiClassItem.Destroy;
begin
  FDecl.Free;
  inherited Destroy;
end;

{$IFNDEF IFPS3_NOINTERFACES}
{ TIFPSInterface }

function TIFPSInterface.CastToType(IntoType: TIFPSType;
  var ProcNo: Cardinal): Boolean;
var
  P: TIFPSExternalProcedure;
begin
  if (IntoType <> nil) and (IntoType.BaseType <> btInterface) then
  begin
    Result := False;
    exit;
  end;
  if FCastProc <> InvalidVal then
  begin
    ProcNo := FCastProc;
    Result := True;
    exit;
  end;
  ProcNo := FOwner.AddUsedFunction2(P);
  P.RegProc := FOwner.AddFunction(ProcHDR);
  P.RegProc.Name := '';
  with P.RegProc.Decl.AddParam do
  begin
    OrgName := 'Org';
    aType := Self.FType;
  end;
  with P.RegProc.Decl.AddParam do
  begin
    OrgName := 'TypeNo';
    aType := FOwner.at2ut(FOwner.FindBaseType(btU32));
  end;
  P.RegProc.Decl.Result := FOwner.at2ut(IntoType);

  P.RegProc.ImportDecl := 'class:+';
  FCastProc := ProcNo;
  Result := True;
end;

constructor TIFPSInterface.Create(Owner: TIFPSPascalCompiler; InheritedFrom: TIFPSInterface; Guid: TGuid; const Name: string; aType: TIFPSType);
begin
  inherited Create;
  FCastProc := InvalidVal;
  FNilProc := InvalidVal;

  FType := aType;
  FOWner := Owner;
  FGuid := GUID;
  FInheritedFrom := InheritedFrom;
  if FInheritedFrom = nil then
    FProcStart := 0
  else
    FProcStart := FInheritedFrom.FProcStart + FInheritedFrom.FItems.Count;
  FItems := TIfList.Create;
  FName := Name;
  FNameHash := MakeHash(Name);
end;

destructor TIFPSInterface.Destroy;
var
  i: Longint;
begin
  for i := FItems.Count -1 downto 0 do
  begin
    TIFPSInterfaceMethod(FItems[i]).Free;
  end;
  FItems.Free;
  inherited Destroy;
end;

function TIFPSInterface.Func_Call(Index: Cardinal;
  var ProcNo: Cardinal): Boolean;
var
  c: TIFPSInterfaceMethod;
  P: TIFPSExternalProcedure;
  s: string;
  i: Longint;
begin
  c := TIFPSInterfaceMethod(Index);
  if c.FScriptProcNo <> InvalidVal then
  begin
    Procno := c.FScriptProcNo;
    Result := True;
    exit;
  end;
  ProcNo := FOwner.AddUsedFunction2(P);
  P.RegProc := FOwner.AddFunction(ProcHDR);
  P.RegProc.Name := '';
  FOwner.UseProc(C.Decl);
  P.RegProc.Decl.Assign(c.Decl);
  s := 'intf:.' + IFPS3_mi2s(c.AbsoluteProcOffset) + chr(ord(c.CC));
  if c.Decl.Result = nil then
    s := s + #0
  else
    s := s + #1;
  for i := 0 to C.Decl.ParamCount -1 do
  begin
    if c.Decl.Params[i].Mode <> pmIn then
      s := s + #1
    else
      s := s + #0;
  end;
  P.RegProc.ImportDecl := s;
  C.FScriptProcNo := ProcNo;
  Result := True;
end;

function TIFPSInterface.Func_Find(const Name: string;
  var Index: Cardinal): Boolean;
var
  H: Longint;
  I: Longint;
  CurrClass: TIFPSInterface;
  C: TIFPSInterfaceMethod;
begin
  H := MakeHash(Name);
  CurrClass := Self;
  while CurrClass <> nil do
  begin
    for i := CurrClass.FItems.Count -1 downto 0 do
    begin
      C := CurrClass.FItems[I];
      if (C.NameHash = H) and (C.Name = Name) then
      begin
        Index := Cardinal(c);
        Result := True;
        exit;
      end;
    end;
    CurrClass := CurrClass.FInheritedFrom;
  end;
  Result := False;
end;

function TIFPSInterface.IsCompatibleWith(aType: TIFPSType): Boolean;
var
  Temp: TIFPSInterface;
begin
  if (atype.BaseType = btClass) then // just support it, we'll see what happens
  begin
    Result := true;
    exit;
  end;
  if atype.BaseType <> btInterface then
  begin
    Result := False;
    exit;
  end;
  temp := TIFPSInterfaceType(atype).FIntf;
  while Temp <> nil do
  begin
    if Temp = Self then
    begin
      Result := True;
      exit;
    end;
    Temp := Temp.FInheritedFrom;
  end;
  Result := False;
end;

procedure TIFPSInterface.RegisterDummyMethod;
begin
  FItems.Add(TIFPSInterfaceMethod.Create);
end;

function TIFPSInterface.RegisterMethod(const Declaration: string;
  const cc: TIFPSCallingConvention): Boolean;
var
  M: TIFPSInterfaceMethod;
  DOrgName: string;
  Func: TPMFuncType;
begin
  M := TIFPSInterfaceMethod.Create;
  if not ParseMethod(FOwner, '', Declaration, DOrgname, m.Decl, Func) then
  begin
    FItems.Add(m); // in any case, add a dummy item
    Result := False;
    exit;
  end;
  m.FName := FastUppercase(DOrgName);
  m.FOrgName := DOrgName;
  m.FNameHash := MakeHash(m.FName);
  m.FCC := CC;
  m.FScriptProcNo := InvalidVal;
  m.FAbsoluteProcOffset := FProcStart + Cardinal(FItems.Add(m));
  Result := True;
end;


function TIFPSInterface.SetNil(var ProcNo: Cardinal): Boolean;
var
  P: TIFPSExternalProcedure;

begin
  if FNilProc <> InvalidVal then
  begin
    Procno := FNilProc;
    Result := True;
    exit;
  end;
  ProcNo := FOwner.AddUsedFunction2(P);
  P.RegProc := FOwner.AddFunction(ProcHDR);
  P.RegProc.Name := '';
  with p.RegProc.Decl.AddParam do
  begin
    Mode := pmInOut;
    OrgName := 'VarNo';
    aType := FOwner.at2ut(Self.FType);
  end;
  P.RegProc.ImportDecl := 'class:-';
  FNilProc := Procno;
  Result := True;
end;

{ TIFPSInterfaceMethod }

constructor TIFPSInterfaceMethod.Create;
begin
  inherited Create;
  FDecl := TIFPSParametersDecl.Create;
end;

destructor TIFPSInterfaceMethod.Destroy;
begin
  FDecl.Free;
  inherited Destroy;
end;
{$ENDIF}
{

Internal error counter: 00020 (increase and then use)

}
end.
