{
@abstract(Execute part of the script engine)
@author(Carlo Kok <ck@carlo-kok.com>)
  The execute part of the script engine
}
unit ifps3;
{$I ifps3_def.inc}
{

Innerfuse Pascal Script III
Copyright (C) 2000-2004 by Carlo Kok (ck@carlo-kok.com)

}
interface
uses
  SysUtils, ifps3utl{$IFDEF IFPS3_D6PLUS}, variants{$ENDIF}{$IFNDEF IFPS3_NOIDISPATCH}{$IFDEF IFPS3_D4PLUS}, ActiveX, Windows{$ELSE}, Ole2, OleAuto{$ENDIF}{$ENDIF};

type
  TIFPSExec = class;
  TIFPSStack = class;
  TIFPSRuntimeAttributes = class;
  TIFPSRuntimeAttribute = class;
{ TIFError contains all possible errors }
  TIFError = (ErNoError, erCannotImport, erInvalidType, ErInternalError,
    erInvalidHeader, erInvalidOpcode, erInvalidOpcodeParameter, erNoMainProc,
    erOutOfGlobalVarsRange, erOutOfProcRange, ErOutOfRange, erOutOfStackRange,
    ErTypeMismatch, erUnexpectedEof, erVersionError, ErDivideByZero, ErMathError,
    erCouldNotCallProc, erOutofRecordRange, erOutOfMemory, erException,
    erNullPointerException, erNullVariantError, eInterfaceNotSupported, erCustomError);
{ The current status of the script }
  TIFStatus = (isNotLoaded, isLoaded, isRunning, isPaused);
{Pointer to array of bytes}
  PByteArray = ^TByteArray;
{Array of bytes}
  TByteArray = array[0..1023] of Byte;
{Pointer to array of words}
  PDWordArray = ^TDWordArray;
{Array of dwords}
  TDWordArray = array[0..1023] of Cardinal;
{@link(TIFProcRec)
  PIFProcRec is a pointer to a TIProcRec record}
  TIFProcRec = class;
  TIFExternalProcRec = class;
  PIFProcRec = TIFProcRec;
  PProcRec = ^TProcRec;
{
@link(TIFPSExec)
@link(PIFProcRec)
@link(TIfList)
TIFProc is is the procedure definition of all external functions
}
  TIFProc = function(Caller: TIFPSExec; p: TIFExternalProcRec; Global, Stack: TIFPSStack): Boolean;
{
@link(PProcRec)
FreeProc is called when a PProcRec is freed}
  TIFFreeProc = procedure (Caller: TIFPSExec; p: PProcRec);
{TIFProcRec contains a currently used internal or external function}
  TIFProcRec = class
  private
    FAttributes: TIFPSRuntimeAttributes;
  public
    constructor Create(Owner: TIFPSExec);
    destructor Destroy; override;

    property Attributes: TIFPSRuntimeAttributes read FAttributes;
  end;
  {@Abtract(An external procedure)}
  TIFExternalProcRec = class(TIFProcRec)
  private
    FExt1: Pointer;
    FExt2: Pointer;
    FName: string;
    FProcPtr: TIFProc;
    FDecl: string;
  public
    {Name for this proc}
    property Name: string read FName write FName;
    {Declaration for this proc (not needed, loaded from script)}
    property Decl: string read FDecl write FDecl;
    {User setable variable}
    property Ext1: Pointer read FExt1 write FExt1;
    {User setable variable}
    property Ext2: Pointer read FExt2 write FExt2;
    {Pointer to the procedure}
    property ProcPtr: TIFProc read FProcPtr write FProcPtr;
  end;
  {@Abtract(An internal procedure)}
  TIFInternalProcRec = class(TIFProcRec)
  private
    FData: PByteArray;
    FLength: Cardinal;
    FExportNameHash: Longint;
    FExportDecl: string;
    FExportName: string;
  public
    {data for this internal proc}
    property Data: PByteArray read FData;
    {the length of Data}
    property Length: Cardinal read FLength;
    {hash for exportname}
    property ExportNameHash: Longint read FExportNameHash;
    {Exportname}
    property ExportName: string read FExportName write FExportName;
    {export declaration}
    property ExportDecl: string read FExportDecl write FExportDecl;

    destructor Destroy; override;
  end;
{TProcrec is used to store an external function that could be used by the script executer}
  TProcRec = record
    Name: ShortString;
    Hash: Longint;
    ProcPtr: TIFProc;
    FreeProc: TIFFreeProc;
    Ext1, Ext2: Pointer;
  end;
{@link(TBTReturnAddress)
  PBTReturnAddress is a pointer to an TBTReturnAddress record}
  PBTReturnAddress = ^TBTReturnAddress;
{TBTReturnAddress is a record used to store return information}
  TBTReturnAddress = packed record
    ProcNo: TIFInternalProcRec;
    Position, StackBase: Cardinal;
  end;
  {@Abstract(TIFTypeRec contains type info)}
  TIFTypeRec = class
  private
    FExportNameHash: Longint;
    FExportName: string;
    FBaseType: TIFPSBaseType;
    FAttributes: TIFPSRuntimeAttributes;
  protected
    FRealSize: Cardinal;
  public
    {The size this type occupies}
    property RealSize: Cardinal read FRealSize;
    {the "base type" for this type}
    property BaseType: TIFPSBaseType read FBaseType write FBaseType;
    {Export name}
    property ExportName: string read FExportName write FExportName;
    {Hash for the export name}
    property ExportNameHash: Longint read FExportNameHash write FExportNameHash;
    {Attributes}
    property Attributes: TIFPSRuntimeAttributes read FAttributes write FAttributes;
    {Calculate the size for this typerec}
    procedure CalcSize; virtual;

    constructor Create(Owner: TIFPSExec);
    destructor Destroy; override;
  end;
  PIFTypeRec = TIFTypeRec;
  {@Abstract(Class type typeinfo)} 
  TIFTypeRec_Class = class(TIFTypeRec)
  private
    FCN: string;
  public
    {name of the class}
    property CN: string read FCN write FCN;
  end;
{$IFNDEF IFPS3_NOINTERFACES}
  {@Abstract(Interface type typeinfo)}
  TIFTypeRec_Interface = class(TIFTypeRec)
  private
    FGuid: TGUID;
  public
    {GUID for the interface}
    property Guid: TGUID read FGuid write FGuid;
  end;
{$ENDIF}  
  {@Abstract(dynamic array type typeinfo)} 
  TIFTypeRec_Array = class(TIFTypeRec)
  private
    FArrayType: TIFTypeRec;
  public
    {The sub type}
    property ArrayType: TIFTypeRec read FArrayType write FArrayType;
    procedure CalcSize; override;
  end;
  {@Abstract(Static array type typeinfo)}
  TIFTypeRec_StaticArray = class(TIFTypeRec_Array)
  private
    FSize: Longint;
  public
    {size of this static array}
    property Size: Longint read FSize write FSize;
    procedure CalcSize; override;
  end;
  {@Abstract(Set type typeinfo)} 
  TIFTypeRec_Set = class(TIFTypeRec)
  private
    FBitSize: Longint;
    FByteSize: Longint;
  public
    {The number of bytes this would require (same as realsize)}
    property aByteSize: Longint read FByteSize write FByteSize; { (abitsize div 8) + (abitsize and 7 > 0 ? 1 : 0) }
    {The number of bits this set is }
    property aBitSize: Longint read FBitSize write FBitSize;
    procedure CalcSize; override;
  end;
  {@Abstract(record type typeinfo)}
  TIFTypeRec_Record = class(TIFTypeRec)
  private
    FFieldTypes: TIfList;
    FRealFieldOffsets: TIfList;
  public
    {List of fieldtypes}
    property FieldTypes: TIfList read FFieldTypes;
    {The real offset of the fields}
    property RealFieldOffsets: TIfList read FRealFieldOffsets;

    procedure CalcSize; override;

    constructor Create(Owner: TIFPSExec);
    destructor Destroy; override;
  end;
  {Pointer to a variant}
  PIFPSVariant = ^TIFPSVariant;
  {Pointer to a variant}
  PIFVariant = PIFPSVariant;
  {variant type}
  TIFPSVariant = packed record
    FType: TIFTypeRec;
  end;
  {Pointer to an abstract variant}
  PIFPSVariantData = ^TIFPSVariantData;
  {Abstract variant}
  TIFPSVariantData = packed record
    VI: TIFPSVariant;
    Data: array[0..0] of Byte;
  end;
  {Pointer to an U8 variant}
  PIFPSVariantU8 = ^TIFPSVariantU8;
  {U8 variant}
  TIFPSVariantU8 = packed record
    VI: TIFPSVariant;
    Data: tbtU8;
  end;

  {Pointer to an S8 variant}
  PIFPSVariantS8 = ^TIFPSVariantS8;
  {U8 variant}
  TIFPSVariantS8 = packed record
    VI: TIFPSVariant;
    Data: tbts8;
  end;

  {Pointer to an U16 variant}
  PIFPSVariantU16 = ^TIFPSVariantU16;
  {U16 variant}
  TIFPSVariantU16 = packed record
    VI: TIFPSVariant;
    Data: tbtU16;
  end;

  {Pointer to an S16 variant}
  PIFPSVariantS16 = ^TIFPSVariantS16;
  {S16 variant}
  TIFPSVariantS16 = packed record
    VI: TIFPSVariant;
    Data: tbts16;
  end;

  {Pointer to an U32 variant}
  PIFPSVariantU32 = ^TIFPSVariantU32;
  {U32 variant}
  TIFPSVariantU32 = packed record
    VI: TIFPSVariant;
    Data: tbtU32;
  end;

  {Pointer to an S32 variant}
  PIFPSVariantS32 = ^TIFPSVariantS32;
  {S32 variant}
  TIFPSVariantS32 = packed record
    VI: TIFPSVariant;
    Data: tbts32;
  end;
{$IFNDEF IFPS3_NOINT64}
  {Pointer to an S64 variant}
  PIFPSVariantS64 = ^TIFPSVariantS64;
  {S64 variant}
  TIFPSVariantS64 = packed record
    VI: TIFPSVariant;
    Data: tbts64;
  end;
{$ENDIF}
  {Pointer to an ansichar variant}
  PIFPSVariantAChar = ^TIFPSVariantAChar;
  {ansichar variant}
  TIFPSVariantAChar = packed record
    VI: TIFPSVariant;
    Data: tbtChar;
  end;

{$IFNDEF IFPS3_NOWIDESTRING}
  {Pointer to an widechar variant}
  PIFPSVariantWChar = ^TIFPSVariantWChar;
  {Widechar variant}
  TIFPSVariantWChar = packed record
    VI: TIFPSVariant;
    Data: tbtWideChar;
  end;
{$ENDIF}
  {Pointer to an ansistring variant}
  PIFPSVariantAString = ^TIFPSVariantAString;
  {ansistring variant}
  TIFPSVariantAString = packed record
    VI: TIFPSVariant;
    Data: tbtString;
  end;

{$IFNDEF IFPS3_NOWIDESTRING}
  {Pointer to a widestring variant}
  PIFPSVariantWString = ^TIFPSVariantWString;
  {Widestring variant}
  TIFPSVariantWString = packed record
    VI: TIFPSVariant;
    Data: WideString;
  end;
{$ENDIF}

  {Pointer to an single variant}
  PIFPSVariantSingle = ^TIFPSVariantSingle;
  {single variant}
  TIFPSVariantSingle = packed record
    VI: TIFPSVariant;
    Data: tbtsingle;
  end;

  {Pointer to a double variant}
  PIFPSVariantDouble = ^TIFPSVariantDouble;
  {double variant}
  TIFPSVariantDouble = packed record
    VI: TIFPSVariant;
    Data: tbtDouble;
  end;

  {Pointer to an extended variant}
  PIFPSVariantExtended = ^TIFPSVariantExtended;
  {extended variant}
  TIFPSVariantExtended = packed record
    VI: TIFPSVariant;
    Data: tbtExtended;
  end;

  {Pointer to a currency variant}
  PIFPSVariantCurrency = ^TIFPSVariantCurrency;
  {Currency variant}
  TIFPSVariantCurrency = packed record
    VI: TIFPSVariant;
    Data: tbtCurrency;
  end;
  {Pointer to an Set variant}
  PIFPSVariantSet = ^TIFPSVariantSet;
  {Set variant}
  TIFPSVariantSet = packed record
    VI: TIFPSVariant;
    Data: array[0..0] of Byte;
  end;

{$IFNDEF IFPS3_NOINTERFACES}
  {Pointer to an Interface variant}
  PIFPSVariantInterface = ^TIFPSVariantInterface;
  {Interface variant}
  TIFPSVariantInterface = packed record
    VI: TIFPSVariant;
    Data: IUnknown;
  end;
{$ENDIF}
  {Pointer to a class variant}
  PIFPSVariantClass = ^TIFPSVariantClass;
  {class variant}
  TIFPSVariantClass = packed record
    VI: TIFPSVariant;
    Data: TObject;
  end;

  {Pointer to a record variant}
  PIFPSVariantRecord = ^TIFPSVariantRecord;
  {record variant}
  TIFPSVariantRecord = packed record
    VI: TIFPSVariant;
    data: array[0..0] of byte;
  end;

  {Pointer to a dynamic array variant}
  PIFPSVariantDynamicArray = ^TIFPSVariantDynamicArray;
  {dynamic array variant}
  TIFPSVariantDynamicArray = packed record
    VI: TIFPSVariant;
    Data: Pointer;
  end;

  {Pointer to a static array variant}
  PIFPSVariantStaticArray = ^TIFPSVariantStaticArray;
  {static arrayvariant}
  TIFPSVariantStaticArray = packed record
    VI: TIFPSVariant;
    data: array[0..0] of byte;
  end;

  {Pointer to a pointer variant}
  PIFPSVariantPointer = ^TIFPSVariantPointer;
  {pointer variant}
  TIFPSVariantPointer = packed record
    VI: TIFPSVariant;
    DataDest: Pointer;
    DestType: TIFTypeRec;
    FreeIt: LongBool;
  end;

  {Pointer to a return address variant}
  PIFPSVariantReturnAddress = ^TIFPSVariantReturnAddress;
  {return address variant}
  TIFPSVariantReturnAddress = packed record
    VI: TIFPSVariant;
    Addr: TBTReturnAddress;
  end;

  {Pointer to a variant variant}
  PIFPSVariantVariant = ^TIFPSVariantVariant;
  {variant variant}
  TIFPSVariantVariant = packed record
    VI: TIFPSVariant;
    Data: Variant;
  end;

  {Freetype, vtTempVAr means the var should be freed as a tempvar}
  TIFPSVarFreeType = (
    vtNone,  // don't free it
    vtTempVar // Free it, the actual thing you need to free is at Pointer(IPointer(p)-4)
    );
  TIFPSResultData = packed record
    P: Pointer;
    aType: TIFTypeRec;
    FreeType: TIFPSVarFreeType;
  end;

  {Pointer to a resource info record}
  PIFPSResource = ^TIFPSResource;
  { A resource in IFPS3 is stored as a pointer to the proc and a tag (p) }
  TIFPSResource = record
    Proc: Pointer;
    P: Pointer;
  end;
  {Use proc for an attribute}
  TIFPSAttributeUseProc = function (Sender: TIFPSExec; const AttribType: string; Attr: TIFPSRuntimeAttribute): Boolean;
  {@Abstract(Attribute type info)}
  TIFPSAttributeType = class
  private
    FTypeName: string;
    FUseProc: TIFPSAttributeUseProc;
    FTypeNameHash: Longint;
  public
    {Called when an attribute is used}
    property UseProc: TIFPSAttributeUseProc read FUseProc write FUseProc;
    {Type name for this attribute}
    property TypeName: string read FTypeName write FTypeName;
    {Hash for the type name}
    property TypeNameHash: Longint read FTypeNameHash write FTypeNameHash;
  end;
  {Pointer to a TClassItem}
  PClassItem = ^TClassItem;
  {TClass item contains runtime class type info}
  TClassItem = record
    FName: string;
    FNameHash: Longint;
    b: byte;
    case byte of
    0: (Ptr: Pointer); {Method}
    1: (PointerInList: Pointer); {Virtual Method}
    3: (FReadFunc, FWriteFunc: Pointer); {Property Helper}
    4: (Ptr2: Pointer); {Constructor}
    5: (PointerInList2: Pointer); {virtual constructor}
    6: (); {Property helper, like 3}
    7: (); {Property helper that will pass it's name}
  end;

  {Pointer to a temporary variant info record}
  PIFPSVariantIFC = ^TIFPSVariantIFC;
  {Temporary variant into record}
  TIFPSVariantIFC = packed record // variants passed to InnerfuseCall
    Dta: Pointer;
    aType: TIFTypeRec;
    VarParam: Boolean;
  end;
  {@Abstract(Runtime attributes)}
  TIFPSRuntimeAttribute = class(TObject)
  private
    FValues: TIFPSStack;
    FAttribType: string;
    FOwner: TIFPSRuntimeAttributes;
    FAttribTypeHash: Longint;
    function GetValue(I: Longint): PIFVariant;
    function GetValueCount: Longint;
  public
    {Owner of this attribute}
    property Owner: TIFPSRuntimeAttributes read FOwner;
    {the attribute type}
    property AttribType: string read FAttribType write FAttribType;
    {hash of the attribute type}
    property AttribTypeHash: Longint read FAttribTypeHash write FAttribTypeHash;
    {the number of values}
    property ValueCount: Longint read GetValueCount;
    {The value[i]}
    property Value[I: Longint]: PIFVariant read GetValue;
    {add a new value}
    function AddValue(aType: TIFTypeRec): PIFPSVariant;
    {delete a value}
    procedure DeleteValue(i: Longint);
    {Adjust the size to the capacity (saves memory)}
    procedure AdjustSize;

    constructor Create(Owner: TIFPSRuntimeAttributes);
    destructor Destroy; override;
  end;
  {@Abstract(List of attributes)}
  TIFPSRuntimeAttributes = class(TObject)
  private
    FAttributes: TIfList;
    FOwner: TIFPSExec;
    function GetCount: Longint;
    function GetItem(I: Longint): TIFPSRuntimeAttribute;
  public
    {Owner}
    property Owner: TIFPSExec read FOwner;
    {Number of elements}
    property Count: Longint read GetCount;
    {Item[i]}
    property Items[I: Longint]: TIFPSRuntimeAttribute read GetItem; default;
    {delete an item}
    procedure Delete(I: Longint);
    {Add an item}
    function Add: TIFPSRuntimeAttribute;
    {Find an attribute by name}
    function FindAttribute(const Name: string): TIFPSRuntimeAttribute;

    constructor Create(AOwner: TIFPSExec);
    destructor Destroy; override;
  end;

  {See TIFPSExec.OnRunLine}
  TIFPSOnLineEvent = procedure(Sender: TIFPSExec);
  {See TIFPSExec.AddSpecialProcImport}
  TIFPSOnSpecialProcImport = function (Sender: TIFPSExec; p: TIFExternalProcRec; Tag: Pointer): Boolean;
  {See TIFPSExec.OnException}
  TIFPSOnException = procedure (Sender: TIFPSExec; ExError: TIFError; const ExParam: string; ExObject: TObject; ProcNo, Position: Cardinal);
  {TIFPSExec is the core of the script engine executer}
  TIFPSExec = class(TObject)
  Private
    FId: Pointer;
    FJumpFlag: Boolean;
    FCallCleanup: Boolean;
    FOnException: TIFPSOnException;
    function ReadData(var Data; Len: Cardinal): Boolean;
    function ReadLong(var b: Cardinal): Boolean;
    function DoCalc(var1, Var2: Pointer; var1Type, var2type: TIFTypeRec; CalcType: Cardinal): Boolean;
    function DoBooleanCalc(var1, Var2, into: Pointer; var1Type, var2type, intotype: TIFTypeRec; Cmd: Cardinal): Boolean;
    function SetVariantValue(dest, Src: Pointer; desttype, srctype: TIFTypeRec): Boolean;
    function ReadVariable(var Dest: TIFPSResultData; UsePointer: Boolean): Boolean;
    function DoBooleanNot(Dta: Pointer; aType: TIFTypeRec): Boolean;
    function DoMinus(Dta: Pointer; aType: TIFTypeRec): Boolean;
    function DoIntegerNot(Dta: Pointer; aType: TIFTypeRec): Boolean;
    procedure RegisterStandardProcs;
  Protected
    FReturnAddressType: TIFTypeRec;
    FVariantType: TIFTypeRec;
    FVariantArrayType: TIFTypeRec;
    FAttributeTypes: TIfList;
    {The exception stack}
    FExceptionStack: TIFList;
    {The list of resources}
    FResources: TIFList;
    {The list of exported variables}
    FExportedVars: TIfList;
    {FTypes contains all types used by the script}
    FTypes: TIfList; 
    {FProcs contains all script procedures}
    FProcs: TIfList;
    {FGlobalVars contains the global variables of the current script}
    FGlobalVars: TIFPSStack;
    {Temporarily created variables}
    FTempVars: TIFPSStack;
    {The Stack}
    FStack: TIFPSStack;
    {The main proc no or -1 (no main proc)}
    FMainProc: Cardinal;
    {The current status of the script engine}
    FStatus: TIFStatus;
    {The current proc}
    FCurrProc: TIFInternalProcRec;
    {The currproc^.data contents}
    FData: PByteArray;
    {Length of FData}
    FDataLength: Cardinal;
    {The current position in the current proc}
    FCurrentPosition: Cardinal;
    {Current stack base}
    FCurrStackBase: Cardinal;
    {FOnRunLine event}
    FOnRunLine: TIFPSOnLineEvent;
    {List of SpecialProcs; See TIFPSExec.AddSpecialProc}
    FSpecialProcList: TIfList;
    {List of all registered external functions}
    FRegProcs: TIfList;
    {The exception object from delphi}
    ExObject: TObject;
    {The proc where the last error occured}
    ExProc: Cardinal;
    {The position of the last error}
    ExPos: Cardinal;
    {The error code}
    ExEx: TIFError;
    {The optional parameter for the error}
    ExParam: string;
    {Call a method}
    function InnerfuseCall(_Self, Address: Pointer; CallingConv: TIFPSCallingConvention; Params: TIfList; res: PIFPSVariantIFC): Boolean;
    {RunLine function}
    procedure RunLine; virtual;
    {ImportProc is called when the script needs to import an external function}
    function ImportProc(const Name: ShortString; proc: TIFExternalProcRec): Boolean; Virtual;
    {ExceptionProc is called when an error occurs}
    procedure ExceptionProc(proc, Position: Cardinal; Ex: TIFError; const s: string; NewObject: TObject); Virtual;
    function FindSpecialProcImport(P: TIFPSOnSpecialProcImport): pointer;
  Public
    {Call CMD_Err to cause an error and stop the script}
    procedure CMD_Err(EC: TIFError);
    {Call CMD_Err2 to cause an error and stop the script}
    procedure CMD_Err2(EC: TIFError; const Param: string);
    {Call CMD_Err3 to cause an error and stop the script}
    procedure CMD_Err3(EC: TIFError; const Param: string; ExObject: TObject);
    {Optional tag of the script engine}
    property Id: Pointer read FID write FID;
    {This function will return about information}
    class function About: string;
    {Use RunProc to call a script function. The Params will not be freed after the call}
    function RunProc(Params: TIfList; ProcNo: Cardinal): Boolean;
    {Use RunProc to call a scripted function; var parameters are ignored}
    function RunProcP(const Params: array of Variant; const Procno: Cardinal): Variant;
    {Use RunProc to call a scripted function, named ProcName, ProcName is case insensitive; var parameters are ignored}
    function RunProcPN(const Params: array of Variant; const ProcName: string): Variant;
    {Search for a type (l is the starting position)}
    function FindType(StartAt: Cardinal; BaseType: TIFPSBaseType; var l: Cardinal): PIFTypeRec;
    {Search for a type}
    function FindType2(BaseType: TIFPSBaseType): PIFTypeRec;
    {Return type no L}
    function GetTypeNo(l: Cardinal): PIFTypeRec;
    {Get Type that has been compiled with a name}
    function GetType(const Name: string): Cardinal;
    {Get function that has been compiled with a name}
    function GetProc(const Name: string): Cardinal;
    {Get variable that has been compiled with a name}
    function GetVar(const Name: string): Cardinal;
    {Get variable compiled with a name as a variant}
    function GetVar2(const Name: string): PIFVariant;
    {Get variable no (C)}
    function GetVarNo(C: Cardinal): PIFVariant;
    {Get Proc no (C)}
    function GetProcNo(C: Cardinal): PIFProcRec;
    {Return the number of procedures}
    function GetProcCount: Cardinal;
    {Return the number of variables}
    function GetVarCount: Longint;
    {Return the number of types}
    function GetTypeCount: Longint;

    {Create an instance of the executer}
    constructor Create;
	{Destroy this instance of the executer}
    destructor Destroy; Override;

	{Run the current script}
    function RunScript: Boolean;

	{Load data into the script engine}
    function LoadData(const s: string): Boolean; virtual;
	{Clear the currently loaded script}
    procedure Clear; Virtual;
	{Reset all variables in the script to zero}
    procedure Cleanup; Virtual;
    {Stop the script engine}
    procedure Stop; Virtual;
	{Pause the script engine}
    procedure Pause; Virtual;
    {Set CallCleanup to false when you don't want the script engine to cleanup all variables after RunScript}
    property CallCleanup: Boolean read FCallCleanup write FCallCleanup;
    {Status contains the current status of the scriptengine}
    property Status: TIFStatus Read FStatus;
	{The OnRunLine event is called after each executed script line}
    property OnRunLine: TIFPSOnLineEvent Read FOnRunLine Write FOnRunLine;
    {Clear the list of special proc imports}
    procedure ClearspecialProcImports;
    {Add a special proc import; this is used for the dll and class library}
    procedure AddSpecialProcImport(const FName: string; P: TIFPSOnSpecialProcImport; Tag: Pointer);
    {Register a function by name}
    function RegisterFunctionName(const Name: string; ProcPtr: TIFProc;
      Ext1, Ext2: Pointer): PProcRec;
   { Register a delphi function
    ProcPtr is a pointer to the proc to be called;
    Name is the name of that proc (uppercased).
    CC is the calling convention.}
    procedure RegisterDelphiFunction(ProcPtr: Pointer; const Name: string; CC: TIFPSCallingConvention);
   { Register a delphi function
    Slf is the self pointer, don't use nil, it won't work
    ProcPtr is a pointer to the proc to be called;
    Name is the name of that proc (uppercased).
    CC is the calling convention.}
    procedure RegisterDelphiMethod(Slf, ProcPtr: Pointer; const Name: string; CC: TIFPSCallingConvention);
    { Returns a TMethod for the procedure you specified (or nil), cast this to the function header you want to use and call it
    make sure it was exported with ExportDecl }
    function GetProcAsMethod(const ProcNo: Cardinal): TMethod;
    {Same as GetProcAsMethod but calls GetProc}
    function GetProcAsMethodN(const ProcName: string): TMethod;
    {Register Attribute Type}
    procedure RegisterAttributeType(useproc: TIFPSAttributeUseProc; const TypeName: string);
	{Clear the function list}
    procedure ClearFunctionList;
    {Contains the last error proc}
    property ExceptionProcNo: Cardinal Read ExProc;
	{Contains the last error position}
    property ExceptionPos: Cardinal Read ExPos;
	{Contains the last error code}
    property ExceptionCode: TIFError Read ExEx;
	{Contains the last error string}
    property ExceptionString: string read ExParam;
  {Contains the exception object}
    property ExceptionObject: TObject read ExObject write ExObject;
    {Add a resource}
    procedure AddResource(Proc, P: Pointer);
	{Check if P is a valid resource for Proc}
    function IsValidResource(Proc, P: Pointer): Boolean;
	{Delete a resource}
    procedure DeleteResource(P: Pointer);
	{Find a resource}
    function FindProcResource(Proc: Pointer): Pointer;
	{Find a resource}
    function FindProcResource2(Proc: Pointer; var StartAt: Longint): Pointer;
    {Raises the current Exception object, or if that doesn't exist, an EIFPS3Exception. If there
    is no current exception in ifps3 at all, it does nothing}
    procedure RaiseCurrentException;
    {OnException is called when an exception occurs}
    property OnException: TIFPSOnException read FOnException write FOnException;
  end;
  {@Abstract(stack type to store runtime information in)}
  TIFPSStack = class(TIFList)
  private
    FDataPtr: Pointer;
    FCapacity,
    FLength: Longint;
    function GetItem(I: Longint): PIFPSVariant;
    procedure SetCapacity(const Value: Longint); //// relative pointers to FData
    procedure AdjustLength;
  public
    {Start of the data}
    property DataPtr: Pointer read FDataPtr;
    {Capacity of the data ptr}
    property Capacity: Longint read FCapacity write SetCapacity;
    {Current length}
    property Length: Longint read FLength;

    constructor Create;
    destructor Destroy; override;
    {Clear the stack}
    procedure Clear; {$IFDEF IFPS3_D5PLUS} reintroduce;{$ELSE} override; {$ENDIF}
    {Push a new item}
    function Push(TotalSize: Longint): PIFPSVariant;
    {Push a new item}
    function PushType(aType: TIFTypeRec): PIFPSVariant;
    {Pop the last item}
    procedure Pop;
    function GetInt(ItemNo: Longint): Longint;
    function GetUInt(ItemNo: Longint): Cardinal;
{$IFNDEF IFPS3_NOINT64}
    function GetInt64(ItemNo: Longint): Int64;
{$ENDIF}
    function GetString(ItemNo: Longint): string;
{$IFNDEF IFPS3_NOWIDESTRING}
    function GetWideString(ItemNo: Longint): WideString;
{$ENDIF}
    function GetReal(ItemNo: Longint): Extended;
    function GetCurrency(ItemNo: Longint): Currency;
    function GetBool(ItemNo: Longint): Boolean;
    function GetClass(ItemNo: Longint): TObject;

    procedure SetInt(ItemNo: Longint; const Data: Longint);
    procedure SetUInt(ItemNo: Longint; const Data: Cardinal);
{$IFNDEF IFPS3_NOINT64}
    procedure SetInt64(ItemNo: Longint; const Data: Int64);
{$ENDIF}
    procedure SetString(ItemNo: Longint; const Data: string);
{$IFNDEF IFPS3_NOWIDESTRING}
    procedure SetWideString(ItemNo: Longint; const Data: WideString);
{$ENDIF}
    procedure SetReal(ItemNo: Longint; const Data: Extended);
    procedure SetCurrency(ItemNo: Longint; const Data: Currency);
    procedure SetBool(ItemNo: Longint; const Data: Boolean);
    procedure SetClass(ItemNo: Longint; const Data: TObject);

    property Items[I: Longint]: PIFPSVariant read GetItem; default;
  end;

{Convert an error to a string}
function TIFErrorToString(x: TIFError; const Param: string): string;

function CreateHeapVariant(aType: TIFTypeRec): PIFPSVariant;
procedure DestroyHeapVariant(v: PIFPSVariant);

procedure FreePIFVariantList(l: TIFList);

const
  ENoError = ERNoError;

{Convert a PIFvariant to a real variant}
function PIFVariantToVariant(Src: PIFVariant; var Dest: Variant): Boolean;
function VariantToPIFVariant(Exec: TIFPSExec; const Src: Variant; Dest: PIFVariant): Boolean;

function IFPSGetRecField(const avar: TIFPSVariantIFC; Fieldno: Longint): TIFPSVariantIFC;
function IFPSGetArrayField(const avar: TIFPSVariantIFC; Fieldno: Longint): TIFPSVariantIFC;
function NewTIFPSVariantRecordIFC(avar: PIFPSVariant; Fieldno: Longint): TIFPSVariantIFC;
{Create a new TIFPSVariantIFC}
function NewTIFPSVariantIFC(avar: PIFPSvariant; varparam: boolean): TIFPSVariantIFC;
{Create a new PIFPSVariantIFC}
function NewPIFPSVariantIFC(avar: PIFPSvariant; varparam: boolean): PIFPSVariantIFC;
{Dispose a PIFPSVariantIFC}
procedure DisposePIFPSvariantIFC(aVar: PIFPSVariantIFC);
{Dispose a list of PIFPSVariantIFC}
procedure DisposePIFPSVariantIFCList(list: TIfList);


function IFPSGetObject(Src: Pointer; aType: TIFTypeRec): TObject;
function IFPSGetUInt(Src: Pointer; aType: TIFTypeRec): Cardinal;
{$IFNDEF IFPS3_NOINT64}
function IFPSGetInt64(Src: Pointer; aType: TIFTypeRec): Int64;
{$ENDIF}
function IFPSGetReal(Src: Pointer; aType: TIFTypeRec): Extended;
function IFPSGetCurrency(Src: Pointer; aType: TIFTypeRec): Currency;
function IFPSGetInt(Src: Pointer; aType: TIFTypeRec): Longint;
function IFPSGetString(Src: Pointer; aType: TIFTypeRec): String;
{$IFNDEF IFPS3_NOWIDESTRING}
function IFPSGetWideString(Src: Pointer; aType: TIFTypeRec): WideString;
{$ENDIF}

procedure IFPSSetObject(Src: Pointer; aType: TIFTypeRec; var Ok: Boolean; Const val: TObject);
procedure IFPSSetUInt(Src: Pointer; aType: TIFTypeRec; var Ok: Boolean; const Val: Cardinal);
{$IFNDEF IFPS3_NOInt64}
procedure IFPSSetInt64(Src: Pointer; aType: TIFTypeRec; var Ok: Boolean; const Val: Int64);
{$ENDIF}
procedure IFPSSetReal(Src: Pointer; aType: TIFTypeRec; var Ok: Boolean; const Val: Extended);
procedure IFPSSetCurrency(Src: Pointer; aType: TIFTypeRec; var Ok: Boolean; const Val: Currency);
procedure IFPSSetInt(Src: Pointer; aType: TIFTypeRec; var Ok: Boolean; const Val: Longint);
procedure IFPSSetString(Src: Pointer; aType: TIFTypeRec; var Ok: Boolean; const Val: String);
{$IFNDEF IFPS3_NOWIDESTRING}
procedure IFPSSetWideString(Src: Pointer; aType: TIFTypeRec; var Ok: Boolean; const Val: WideString);
{$ENDIF}

procedure VNSetPointerTo(const Src: TIFPSVariantIFC; Data: Pointer; aType: TIFTypeRec);

function VNGetUInt(const Src: TIFPSVariantIFC): Cardinal;
{$IFNDEF IFPS3_NOINT64}
function VNGetInt64(const Src: TIFPSVariantIFC): Int64;
{$ENDIF}
function VNGetReal(const Src: TIFPSVariantIFC): Extended;
function VNGetCurrency(const Src: TIFPSVariantIFC): Currency;
function VNGetInt(const Src: TIFPSVariantIFC): Longint;
function VNGetString(const Src: TIFPSVariantIFC): String;
{$IFNDEF IFPS3_NOWIDESTRING}
function VNGetWideString(const Src: TIFPSVariantIFC): WideString;
{$ENDIF}

procedure VNSetUInt(const Src: TIFPSVariantIFC; const Val: Cardinal);
{$IFNDEF IFPS3_NOINT64}
procedure VNSetInt64(const Src: TIFPSVariantIFC; const Val: Int64);
{$ENDIF}
procedure VNSetReal(const Src: TIFPSVariantIFC; const Val: Extended);
procedure VNSetCurrency(const Src: TIFPSVariantIFC; const Val: Currency);
procedure VNSetInt(const Src: TIFPSVariantIFC; const Val: Longint);
procedure VNSetString(const Src: TIFPSVariantIFC; const Val: String);
{$IFNDEF IFPS3_NOWIDESTRING}
procedure VNSetWideString(const Src: TIFPSVariantIFC; const Val: WideString);
{$ENDIF}

function VGetUInt(const Src: PIFVariant): Cardinal;
{$IFNDEF IFPS3_NOINT64}
function VGetInt64(const Src: PIFVariant): Int64;
{$ENDIF}
function VGetReal(const Src: PIFVariant): Extended;
function VGetCurrency(const Src: PIFVariant): Currency;
function VGetInt(const Src: PIFVariant): Longint;
function VGetString(const Src: PIFVariant): String;
{$IFNDEF IFPS3_NOWIDESTRING}
function VGetWideString(const Src: PIFVariant): WideString;
{$ENDIF}

procedure VSetPointerTo(const Src: PIFVariant; Data: Pointer; aType: TIFTypeRec);
procedure VSetUInt(const Src: PIFVariant; const Val: Cardinal);
{$IFNDEF IFPS3_NOINT64}
procedure VSetInt64(const Src: PIFVariant; const Val: Int64);
{$ENDIF}
procedure VSetReal(const Src: PIFVariant; const Val: Extended);
procedure VSetCurrency(const Src: PIFVariant; const Val: Currency);
procedure VSetInt(const Src: PIFVariant; const Val: Longint);
procedure VSetString(const Src: PIFVariant; const Val: String);
{$IFNDEF IFPS3_NOWIDESTRING}
procedure VSetWideString(const Src: PIFVariant; const Val: WideString);
{$ENDIF}

type
  {Exception class}
  EIFPS3Exception = class(Exception)
  private
    FProcPos: Cardinal;
    FProcNo: Cardinal;
    FExec: TIFPSExec;
  public
    constructor Create(const Error: string; Exec: TIFPSExec; Procno, ProcPos: Cardinal);
    property ProcNo: Cardinal read FProcNo;
    property ProcPos: Cardinal read FProcPos;
    property Exec: TIFPSExec read FExec;
  end;
  {TIFPSRuntimeClass is one class at runtime}
  TIFPSRuntimeClass = class
  protected
    FClassName: string;
    FClassNameHash: Longint;

    FClassItems: TIFList;
    FClass: TClass;

    FEndOfVmt: Longint;
  public
    {Register a constructor}
    procedure RegisterConstructor(ProcPtr: Pointer; const Name: string);
	{Register a virtual constructor}
    procedure RegisterVirtualConstructor(ProcPtr: Pointer; const Name: string);
	{Register a method}
    procedure RegisterMethod(ProcPtr: Pointer; const Name: string);
	{Register a virtual method}
    procedure RegisterVirtualMethod(ProcPtr: Pointer; const Name: string);
	{Register an abstract virtual method}
    procedure RegisterVirtualAbstractMethod(ClassDef: TClass; ProcPtr: Pointer; const Name: string);
    {Register a property helper}
    procedure RegisterPropertyHelper(ReadFunc, WriteFunc: Pointer; const Name: string);
    {Register a property helper (name will be passed on the stack)}
    procedure RegisterPropertyHelperName(ReadFunc, WriteFunc: Pointer; const Name: string);
    {Register a property helper that is an event}
    procedure RegisterEventPropertyHelper(ReadFunc, WriteFunc: Pointer; const Name: string);
    {create}
    constructor Create(aClass: TClass; const AName: string);
	{destroy}
    destructor Destroy; override;
  end;
  {TIFPSRuntimeClassImporter is the runtime class importer}
  TIFPSRuntimeClassImporter = class
  private
    FClasses: TIFList;
  public
    {create}
    constructor Create;
    constructor CreateAndRegister(Exec: TIFPSexec; AutoFree: Boolean);
	{destroy}
    destructor Destroy; override;
    {Add a class}
    function Add(aClass: TClass): TIFPSRuntimeClass;
    function Add2(aClass: TClass; const Name: string): TIFPSRuntimeClass;
    {Clear}
    procedure Clear;
    {Search for a class}
    function FindClass(const Name: string): TIFPSRuntimeClass;
  end;
  TIFPSResourceFreeProc = procedure (Sender: TIFPSExec; P: TIFPSRuntimeClassImporter); 

{Register the classes at runtime}
procedure RegisterClassLibraryRuntime(SE: TIFPSExec; Importer: TIFPSRuntimeClassImporter);
{Set a runtime variant}
procedure SetVariantToClass(V: PIFVariant; Cl: TObject);
{$IFNDEF IFPS3_NOINTERFACES}
procedure SetVariantToInterface(V: PIFVariant; Cl: IUnknown);
{$ENDIF}
{Internal function: Script Event Handler<br>
Supported Parameter Types:<br>
  u8,s8,u16,s16,u32,s32,s64,single,double,extended,class,variant,string,char<br>
Supported Result Types:<br>
  u8,s8,u16,s16,u32,s32,string,variant
}
procedure MyAllMethodsHandler;
{Internal Function: Returns the Data pointer of a TMethod for a ProcNo}
function GetMethodInfoRec(SE: TIFPSExec; ProcNo: Cardinal): Pointer;
{Make a method pointer of a script engine + function number, not that
this doesn't work unless the proc was exported with ExportMode etExportDecl}
function MkMethod(FSE: TIFPSExec; No: Cardinal): TMethod;

type
  {Alias to @link(ifps3utl.TIFPSCallingConvention)}
  TIFPSCallingConvention = ifps3utl.TIFPSCallingConvention;
const
  {Alias to @link(ifps3utl.cdRegister)}
  cdRegister = ifps3utl.cdRegister;
  {Alias to @link(ifps3utl.cdPascal)}
  cdPascal = ifps3utl.cdPascal;
  {Alias to @link(ifps3utl.cdCdecl)}
  cdCdecl = ifps3utl.cdCdecl;
  {Alias to @link(ifps3utl.cdStdCall)}
  cdStdCall = ifps3utl.cdStdCall;
  {Invalid results}
  InvalidVal = Cardinal(-1);

function  IFPSDynArrayGetLength(arr: Pointer; aType: TIFTypeRec): Longint;
procedure IFPSDynArraySetLength(var arr: Pointer; aType: TIfTypeRec; NewLength: Longint);

function  GetIFPSArrayLength(Arr: PIFVariant): Longint;
procedure SetIFPSArrayLength(Arr: PIFVariant; NewLength: Longint);

function IFPSVariantToString(const p: TIFPSVariantIFC; const ClassProperties: string): string;
function MakeString(const s: string): string;
{$IFNDEF IFPS3_NOWIDESTRING}
function MakeWString(const s: widestring): string;
{$ENDIF}

{$IFNDEF IFPS3_NOIDISPATCH}
function IDispatchInvoke(Self: IDispatch; PropertySet: Boolean; const Name: String; const Par: array of Variant): Variant;
{$ENDIF}


implementation
uses
  TypInfo;


type
  PIFPSExportedVar = ^TIFPSExportedVar;
  TIFPSExportedVar = record
    FName: string;
    FNameHash: Longint;
    FVarNo: Cardinal;
  end;
  PRaiseFrame = ^TRaiseFrame;
  TRaiseFrame = record
    NextRaise: PRaiseFrame;
    ExceptAddr: Pointer;
    ExceptObject: TObject;
    ExceptionRecord: Pointer;
  end;
  PIFPSExceptionHandler =^TIFPSExceptionHandler;
  TIFPSExceptionHandler = packed record
    CurrProc: TIFInternalProcRec;
    BasePtr, StackSize: Cardinal;
    FinallyOffset, ExceptOffset, Finally2Offset, EndOfBlock: Cardinal;
  end;
  TIFPSHeader = packed record
    HDR: Cardinal;
    IFPSBuildNo: Cardinal;
    TypeCount: Cardinal;
    ProcCount: Cardinal;
    VarCount: Cardinal;
    MainProcNo: Cardinal;
    ImportTableSize: Cardinal;
  end;

  TIFPSExportItem = packed record
    ProcNo: Cardinal;
    NameLength: Cardinal;
    DeclLength: Cardinal;
  end;

  TIFPSType = packed record
    BaseType: TIFPSBaseType;
  end;
  TIFPSProc = packed record
    Flags: Byte;
  end;

  TIFPSVar = packed record
    TypeNo: Cardinal;
    Flags: Byte;
  end;
  PSpecialProc = ^TSpecialProc;
  TSpecialProc = record
    P: TIFPSOnSpecialProcImport;
    namehash: Longint;
    Name: string;
    tag: pointer;
  end;

procedure P_CM_A; begin end;
procedure P_CM_CA; begin end;
procedure P_CM_P; begin end;
procedure P_CM_PV; begin end;
procedure P_CM_PO; begin end;
procedure P_CM_C; begin end;
procedure P_CM_G; begin end;
procedure P_CM_CG; begin end;
procedure P_CM_CNG; begin end;
procedure P_CM_R; begin end;
procedure P_CM_ST; begin end;
procedure P_CM_PT; begin end;
procedure P_CM_CO; begin end;
procedure P_CM_CV; begin end;
procedure P_CM_SP; begin end;
procedure P_CM_BN; begin end;
procedure P_CM_VM; begin end;
procedure P_CM_SF; begin end;
procedure P_CM_FG; begin end;
procedure P_CM_PUEXH; begin end;
procedure P_CM_POEXH; begin end;
procedure P_CM_IN; begin end;
procedure P_CM_SPB; begin end;
procedure P_CM_INC; begin end;
procedure P_CM_DEC; begin end;

function IntPIFVariantToVariant(Src: pointer; aType: TIFTypeRec; var Dest: Variant): Boolean; forward;


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


procedure RCIFreeProc(Sender: TIFPSExec; P: TIFPSRuntimeClassImporter);
begin
  p.Free;
end;

function Trim(const s: string): string;
begin
  Result := s;
  while (Length(result) > 0) and (Result[1] = #32) do Delete(Result, 1, 1);
  while (Length(result) > 0) and (Result[Length(Result)] = #32) do Delete(Result, Length(Result), 1);
end;
function FloatToStr(E: Extended): string;
var
  s: string;
begin
  Str(e:0:12, s);
  result := s;
end;

//-------------------------------------------------------------------

function Padl(s: string; i: longInt): string;
begin
  result := StringOfChar(' ', i - length(s)) + s;
end;
//-------------------------------------------------------------------

function Padz(s: string; i: longInt): string;
begin
  result := StringOfChar('0', i - length(s)) + s;
end;
//-------------------------------------------------------------------

function Padr(s: string; i: longInt): string;
begin
  result := s + StringOfChar(' ', i - Length(s));
end;
//-------------------------------------------------------------------

{$IFNDEF IFPS3_NOWIDESTRING}
function MakeWString(const s: widestring): string;
var
  i: Longint;
  e: string;
  b: boolean;
begin
  Result := s;
  i := 1;
  b := false;
  while i <= length(result) do
  begin
    if Result[i] = '''' then
    begin
      if not b then
      begin
        b := true;
        Insert('''', Result, i);
        inc(i);
      end;
      Insert('''', Result, i);
      inc(i, 2);
    end else if (Result[i] < #32) or (Result[i] > #255) then
    begin
      e := '#'+inttostr(ord(Result[i]));
      Delete(Result, i, 1);
      if b then
      begin
        b := false;
        Insert('''', Result, i);
        inc(i);
      end;
      Insert(e, Result, i);
      inc(i, length(e));
    end else begin
      if not b then
      begin
        b := true;
        Insert('''', Result, i);
        inc(i, 2);
      end else
        inc(i);
    end;
  end;
  if b then
  begin
    Result := Result + '''';
  end;
  if Result = '' then
    Result := '''''';
end;
{$ENDIF}
function MakeString(const s: string): string;
var
  i: Longint;
  e: string;
  b: boolean;
begin
  Result := s;
  i := 1;
  b := false;
  while i <= length(result) do
  begin
    if Result[i] = '''' then
    begin
      if not b then
      begin
        b := true;
        Insert('''', Result, i);
        inc(i);
      end;
      Insert('''', Result, i);
      inc(i, 2);
    end else if (Result[i] < #32) then
    begin
      e := '#'+inttostr(ord(Result[i]));
      Delete(Result, i, 1);
      if b then
      begin
        b := false;
        Insert('''', Result, i);
        inc(i);
      end;
      Insert(e, Result, i);
      inc(i, length(e));
    end else begin
      if not b then
      begin
        b := true;
        Insert('''', Result, i);
        inc(i, 2);
      end else
        inc(i);
    end;
  end;
  if b then
  begin
    Result := Result + '''';
  end;
  if Result = '' then
    Result := '''''';
end;

function SafeStr(const s: string): string;
var
 i : Longint;
begin
  Result := s;
  for i := 1 to length(s) do
  begin
    if s[i] in [#0..#31] then
    begin
      Result := Copy(s, 1, i-1);
      exit;
    end;
  end;

end;

function PropertyToString(Instance: TObject; PName: string): string;
var
  s: string;
  i: Longint;
  PP: PPropInfo;
begin
  if PName = '' then
  begin
    Result := Instance.ClassName;
    exit;
  end;
  while Length(PName) > 0 do
  begin
    i := pos('.', pname);
    if i = 0 then
    begin
      s := Trim(PNAme);
      pname := '';
    end else begin
      s := trim(Copy(PName, 1, i-1));
      Delete(PName, 1, i);
    end;
    pp := GetPropInfo(PTypeInfo(Instance.ClassInfo), s);
    if pp = nil then begin Result := 'Unknown Identifier'; exit; end;

    case pp^.PropType^.Kind of
      tkInteger: begin Result := IntToStr(GetOrdProp(Instance, pp)); exit; end;
      tkChar: begin Result := '#'+IntToStr(GetOrdProp(Instance, pp)); exit; end;
      tkEnumeration: begin Result := GetEnumName(pp^.PropType{$IFDEF IFPS3_D3PLUS}^{$ENDIF}, GetOrdProp(Instance, pp)); exit; end;
      tkFloat: begin Result := FloatToStr(GetFloatProp(Instance, PP)); exit; end;
      tkString, tkLString: begin Result := ''''+GetStrProp(Instance, PP)+''''; exit; end;
      tkSet: begin Result := '[Set]'; exit; end;
      tkClass: begin Instance := TObject(GetOrdProp(Instance, pp)); end;
      tkMethod: begin Result := '[Method]'; exit; end;
      tkVariant: begin Result := '[Variant]'; exit; end;
      else begin Result := '[Unknown]'; exit; end;
    end;
    if Instance = nil then begin result := 'nil'; exit; end;
  end;
  Result := Instance.ClassName;
end;

function ClassVariantInfo(const pvar: TIFPSVariantIFC; const PropertyName: string): string;
begin
  if pvar.aType.BaseType = btClass then
  begin
    if TObject(pvar.Dta^) = nil then
      Result := 'nil'
    else
      Result := PropertyToString(TObject(pvar.Dta^), PropertyName);
  end else if pvar.atype.basetype = btInterface then
      Result := 'Interface'
  else Result := 'Invalid Type';
end;

function IFPSVariantToString(const p: TIFPSVariantIFC; const ClassProperties: string): string;
begin
  if p.Dta = nil then
  begin
    Result := 'nil';
    exit;
  end;
  if p.aType.BaseType = btVariant then
  begin
    try
      if TVarData(p.Dta^).VType = varDispatch then
        Result := 'Variant(IDispatch)'
      else if TVarData(p.Dta^).VType = varNull then
        REsult := 'Null'
      else if (TVarData(p.Dta^).VType = varOleStr) then
      {$IFNDEF IFPS3_NOWIDSTRING}
        Result := MakeString(Variant(p.Dta^))
      {$ELSE}
        Result := MakeWString(variant(p.dta^))
      {$ENDIF}
      else if TVarData(p.Dta^).VType = varString then
        Result := MakeString(variant(p.Dta^))
      else
      Result := Variant(p.Dta^);
    except
      on e: Exception do
        Result := 'Exception: '+e.Message;
    end;
    exit;
  end;
  case p.aType.BaseType of
    btProcptr: begin Result := 'Proc: '+inttostr(tbtu32(p.Dta^)); end;
    btU8: str(tbtu8(p.dta^), Result);
    btS8: str(tbts8(p.dta^), Result);
    btU16: str(tbtu16(p.dta^), Result);
    btS16: str(tbts16(p.dta^), Result);
    btU32: str(tbtu32(p.dta^), Result);
    btS32: str(tbts32(p.dta^), Result);
    btSingle: str(tbtsingle(p.dta^), Result);
    btDouble: str(tbtdouble(p.dta^), Result);
    btExtended: str(tbtextended(p.dta^), Result);
    btString, btPChar: Result := makestring(string(p.dta^));
    btchar: Result := MakeString(tbtchar(p.dta^));
    {$IFNDEF IFPS3_NOWIDESTRING}
    btwidechar: Result := MakeWString(tbtwidechar(p.dta^));
    btWideString: Result := MakeWString(tbtwidestring(p.dta^));
    {$ENDIF}
    {$IFNDEF IFPS3_NOINT64}btS64: str(tbts64(p.dta^), Result);{$ENDIF}
    btStaticArray, btRecord, btArray:
      begin
        Result := '[]';
      end;
    btPointer: Result := 'Nil';
    btClass, btInterface:
      begin
        Result := ClassVariantInfo(p, ClassProperties)
      end;
  else
    Result := '[Invalid]';
  end;
end;



function TIFErrorToString(x: TIFError; const Param: string): string;
begin
  case x of
    ErNoError: Result := 'No Error';
    erCannotImport: Result := 'Cannot Import '+Safestr(Param);
    erInvalidType: Result := 'Invalid Type';
    ErInternalError: Result := 'Internal error';
    erInvalidHeader: Result := 'Invalid Header';
    erInvalidOpcode: Result := 'Invalid Opcode';
    erInvalidOpcodeParameter: Result := 'Invalid Opcode Parameter';
    erNoMainProc: Result := 'no Main Proc';
    erOutOfGlobalVarsRange: Result := 'Out of Global Vars range';
    erOutOfProcRange: Result := 'Out of Proc Range';
    ErOutOfRange: Result := 'Out Of Range';
    erOutOfStackRange: Result := 'Out Of Stack Range';
    ErTypeMismatch: Result := 'Type Mismatch';
    erUnexpectedEof: Result := 'Unexpected End Of File';
    erVersionError: Result := 'Version error';
    ErDivideByZero: Result := 'divide by Zero';
    erMathError: Result := 'Math error';
    erCouldNotCallProc: Result := 'Could not call proc';
    erOutofRecordRange: Result := 'Out of Record Fields Range';
    erNullPointerException: Result := 'Null Pointer Exception';
    erNullVariantError: Result := 'Null variant error';
    erOutOfMemory: Result := 'Out Of Memory';
    erException: Result := 'Exception: '+ Param;
    eInterfaceNotSupported: Result := 'Interface not supported';
    erCustomError: Result := Param;
      else
    Result := 'Unknown error';
  end;
  //
end;


procedure TIFTypeRec.CalcSize;
begin
  case BaseType of
    btVariant: FRealSize := sizeof(Variant);
    btChar, bts8, btU8: FrealSize := 1 ;
    {$IFNDEF IFPS3_NOWIDESTRING}btWideChar, {$ENDIF}bts16, btU16: FrealSize := 2;
    {$IFNDEF IFPS3_NOWIDESTRING}btWideString, {$ENDIF}{$IFNDEF IFPS3_NOINTERFACSE}btInterface, {$ENDIF}btSingle, bts32, btU32,
    btclass, btPChar, btString, btProcPtr: FrealSize := 4;
    btCurrency: FrealSize := Sizeof(Currency);
    btPointer: FRealSize := 12; // ptr, type, freewhendone
    btDouble{$IFNDEF IFPS3_NOINT64}, bts64{$ENDIF}: FrealSize := 8;
    btExtended: FrealSize := SizeOf(Extended);
    btReturnAddress: FrealSize := Sizeof(TBTReturnAddress);
  else
    FrealSize := 0;
  end;
end;

constructor TIFTypeRec.Create(Owner: TIFPSExec);
begin
  inherited Create;
  FAttributes := TIFPSRuntimeAttributes.Create(Owner);
end;

destructor TIFTypeRec.Destroy;
begin
  FAttributes.Free;
  inherited destroy;
end;

{ TIFTypeRec_Record }

procedure TIFTypeRec_Record.CalcSize;
begin
  inherited;
  FrealSize := TIFTypeRec(FFieldTypes[FFieldTypes.Count-1]).RealSize +
    Cardinal(RealFieldOffsets[RealFieldOffsets.Count -1]);
end;

constructor TIFTypeRec_Record.Create(Owner: TIFPSExec);
begin
  inherited Create(Owner);
  FRealFieldOffsets := TIfList.Create;
  FFieldTypes := TIfList.Create;
end;

destructor TIFTypeRec_Record.Destroy;
begin
  FFieldTypes.Free;
  FRealFieldOffsets.Free;
  inherited Destroy;
end;


const
  RTTISize = sizeof(TIFPSVariant);

procedure InitializeVariant(p: Pointer; aType: TIFTypeRec);
var
  t: TIFTypeRec;
  i: Longint;
begin
  case aType.BaseType of
    btChar, bts8, btU8: tbtu8(p^) := 0;
    {$IFNDEF IFPS3_NOWIDESTRING}btWideChar, {$ENDIF}bts16, btU16: tbtu16(p^) := 0;
    btSingle, bts32, btU32,
    btPChar, btString, {$IFNDEF IFPS3_NOWIDESTRING}btWideString, {$ENDIF}btClass,
    btInterface, btArray: tbtu32(P^) := 0;
    btPointer:
      begin
        Pointer(p^) := nil;
        Pointer(Pointer(IPointer(p)+4)^) := nil;
        Pointer(Pointer(IPointer(p)+8)^) := nil;
      end;
    btProcPtr: tbtu32(P^) := InvalidVal;
    btCurrency: tbtCurrency(P^) := 0;
    btDouble{$IFNDEF IFPS3_NOINT64}, bts64{$ENDIF}: {$IFNDEF IFPS3_NOINT64}tbtS64(P^) := 0{$ELSE}tbtdouble(p^) := 0 {$ENDIF};
    btExtended: tbtExtended(p^) := 0;
    btVariant: Initialize(Variant(p^));
    btReturnAddress:; // there is no point in initializing a return address
    btRecord:
      begin
        for i := 0 to TIFTypeRec_Record(aType).FFieldTypes.Count -1 do
        begin
          t := TIFTypeRec_Record(aType).FieldTypes[i];
          InitializeVariant(P, t);
          p := Pointer(IPointer(p) + t.FrealSize);
        end;
      end;
    btStaticArray:
      begin
        t := TIFTypeRec_Array(aType).ArrayType;
        for i := 0 to TIFTypeRec_StaticArray(aType).Size -1 do
        begin
          InitializeVariant(p, t);
          p := Pointer(IPointer(p) + t.RealSize);
        end;
      end;
    btSet:
      begin
        FillChar(p^, TIFTypeRec_Set(aType).RealSize, 0);
      end;
  end;
end;

procedure DestroyHeapVariant2(v: Pointer; aType: TIFTypeRec); forward;

const
  NeedFinalization = [btStaticArray, btRecord, btArray, btPointer, btVariant {$IFNDEF IFPS3_NOINTERFACES}, btInterface{$ENDIF}, btString {$IFNDEF IFPS3_NOWIDESTRING},btWideString{$ENDIF}];

procedure FinalizeVariant(p: Pointer; aType: TIFTypeRec);
var
  t: TIFTypeRec;
  elsize: Cardinal;
  i, l: Longint;
  darr: Pointer;
begin
  case aType.BaseType of
    btString: string(p^) := '';
    {$IFNDEF IFPS3_NOWIDESTRING}btWideString: widestring(p^) := '';{$ENDIF}
    {$IFNDEF IFPS3_NOINTERFACES}btInterface:
      begin
        {$IFNDEF IFPS3_D3PLUS}
        if IUnknown(p^) <> nil then
          IUnknown(p^).Release;
        {$ENDIF}
        IUnknown(p^) := nil;
      end; {$ENDIF}
    btVariant:
    begin
      try
        Finalize(Variant(p^));
      except
      end;
    end;
    btPointer:
      if Pointer(Pointer(IPointer(p)+8)^) <> nil then
      begin
        DestroyHeapVariant2(Pointer(p^), Pointer(Pointer(IPointer(p)+4)^));
        Pointer(p^) := nil;
      end;
    btArray:
      begin
        if IPointer(P^) = 0 then exit;
        darr := Pointer(IPointer(p^) - 8);
        if Longint(darr^) < 0 then exit;// refcount < 0 means don't free
        Dec(Longint(darr^));
        if Longint(darr^) <> 0 then exit;
        t := TIFTypeRec_Array(aType).ArrayType;
        elsize := t.RealSize;
        darr := Pointer(IPointer(darr) + 4);
        l := Longint(darr^);
        darr := Pointer(IPointer(darr) + 4);
        case t.BaseType of
          btString, {$IFNDEF IFPS3_NOWIDESTRING}btWideString, {$ENDIF}{$IFNDEF IFPS3_NOINTERFACES}btInterface, {$ENDIF}btArray, btStaticArray,
          btRecord, btPointer:
            begin
              for i := 0 to l -1 do
              begin
                FinalizeVariant(darr, t);
                darr := Pointer(IPointer(darr) + elsize);
              end;
            end;
        end;
        FreeMem(Pointer(IPointer(p^) - 8), Cardinal(l) * elsize + 8);
        Pointer(P^) := nil;
      end;
    btRecord:
      begin
        for i := 0 to TIFTypeRec_Record(aType).FFieldTypes.Count -1 do
        begin
          t := TIFTypeRec_Record(aType).FieldTypes[i];
          case t.BaseType of
            btString, {$IFNDEF IFPS3_NOWIDESTRING}btWideString, {$ENDIF}{$IFNDEF IFPS3_NOINTERFACES}btInterface, {$ENDIF}btArray, btStaticArray,
            btRecord: FinalizeVariant(p, t);
          end;
          p := Pointer(IPointer(p) + t.FrealSize);
        end;
      end;
    btStaticArray:
      begin
        t := TIFTypeRec_Array(aType).ArrayType;
        case t.BaseType of
          btString, {$IFNDEF IFPS3_NOWIDESTRING}btWideString, {$ENDIF}{$IFNDEF IFPS3_NOINTERFACES}btInterface, {$ENDIF}btArray, btStaticArray,
          btRecord: ;
          else Exit;
        end;
        for i := 0 to TIFTypeRec_StaticArray(aType).Size -1 do
        begin
          FinalizeVariant(p, t);
          p := Pointer(IPointer(p) + t.RealSize);
        end;
      end;
  end;
end;

function CreateHeapVariant2(aType: TIFTypeRec): Pointer;
begin
  GetMem(Result, aType.RealSize);
  InitializeVariant(Result, aType);
end;

procedure DestroyHeapVariant2(v: Pointer; aType: TIFTypeRec);
begin
  if v = nil then exit;
  if atype.BaseType in NeedFinalization then
    FinalizeVariant(v, aType);
  FreeMem(v, aType.RealSize);
end;


function CreateHeapVariant(aType: TIFTypeRec): PIFPSVariant;
var
  aSize: Longint;
begin
  aSize := aType.RealSize + RTTISize;
  GetMem(Result, aSize);
  Result.FType := aType;
  InitializeVariant(Pointer(IPointer(Result)+4), aType);
end;

procedure DestroyHeapVariant(v: PIFPSVariant);
begin
  if v = nil then exit;
  if v.FType.BaseType in NeedFinalization then
    FinalizeVariant(Pointer(IPointer(v)+4), v.FType);
  FreeMem(v, v.FType.RealSize + RTTISize);
end;

procedure FreePIFVariantList(l: TIFList);
var
  i: Longint;
begin
  for i:= l.count -1 downto 0 do
    DestroyHeapVariant(l[i]);
  l.free;
end;

{ TIFPSExec }

procedure TIFPSExec.ClearFunctionList;
var
  x: PProcRec;
  l: Longint;
begin
  for l := FAttributeTypes.Count -1 downto 0 do
  begin
    TIFPSAttributeType(FAttributeTypes.Data^[l]).Free;
  end;
  FAttributeTypes.Clear;

  for l := 0 to FRegProcs.Count - 1 do
  begin
    x := FRegProcs.Data^[l];
    if @x^.FreeProc <> nil then x^.FreeProc(Self, x);
    Dispose(x);
  end;
  FRegProcs.Clear;
  RegisterStandardProcs;
end;

class function TIFPSExec.About: string;
begin
  Result := 'Innerfuse Pascal Script III ' + IFPSCurrentversion + '. Copyright (c) 2001-2004 by Carlo Kok';
end;

procedure TIFPSExec.Cleanup;
var
  I: Longint;
  p: Pointer;
begin
  if FStatus <> isLoaded then
    exit;
  FStack.Clear;
  FTempVars.Clear;
  for I := Longint(FGlobalVars.Count) - 1 downto 0 do
  begin
    p := FGlobalVars.Items[i];
    if PIFTypeRec(P^).BaseType in NeedFinalization then
      FinalizeVariant(Pointer(IPointer(p)+4), Pointer(P^));
    InitializeVariant(Pointer(IPointer(p)+4), Pointer(P^));
  end;
end;

procedure TIFPSExec.Clear;
var
  I: Longint;
  temp: PIFPSResource;
  Proc: TIFPSResourceFreeProc;
  pp: PIFPSExceptionHandler;
begin
  for i := Longint(FExceptionStack.Count) -1 downto 0 do
  begin
    pp := FExceptionStack.Data^[i];
    Dispose(pp);
  end;
  for i := Longint(FResources.Count) -1 downto 0 do
  begin
    Temp := FResources.Data^[i];
    Proc := Temp^.Proc;
    Proc(Self, Temp^.P);
    Dispose(Temp);
  end;
  for i := Longint(FExportedVars.Count) -1 downto 0 do
    Dispose(PIFPSExportedVar(FExportedVars.Data^[I]));
  for I := Longint(FProcs.Count) - 1downto 0  do
    TIFProcRec(FProcs.Data^[i]).Destroy;
  FProcs.Clear;
  FGlobalVars.Clear;
  FStack.Clear;
  for I := Longint(FTypes.Count) - 1downto 0  do
    TIFTypeRec(FTypes.Data^[i]).Free;
  FTypes.Clear;
  FStatus := isNotLoaded;
  FResources.Clear;
  FExportedVars.Clear;
  FExceptionStack.Clear;
end;

constructor TIFPSExec.Create;
begin
  inherited Create;
  FAttributeTypes := TIfList.Create;
  FExceptionStack := TIfList.Create;
  FCallCleanup := False;
  FResources := TIfList.Create;
  FTypes := TIfList.Create;
  FProcs := TIfList.Create;
  FGlobalVars := TIFPSStack.Create;
  FTempVars := TIFPSStack.Create;
  FMainProc := 0;
  FStatus := isNotLoaded;
  FRegProcs := TIfList.Create;
  FExportedVars := TIfList.create;
  FSpecialProcList := TIfList.Create;
  RegisterStandardProcs;
  FReturnAddressType := TIFTypeRec.Create(self);
  FReturnAddressType.BaseType := btReturnAddress;
  FReturnAddressType.CalcSize;
  FVariantType := TIFTypeRec.Create(self);
  FVariantType.BaseType := btVariant;
  FVariantType.CalcSize;
  FVariantArrayType := TIFTypeRec_Array.Create(self);
  FVariantArrayType.BaseType := btArray;
  FVariantArrayType.CalcSize;
  TIFTypeRec_Array(FVariantArrayType).ArrayType := FVariantType;
  FStack := TIFPSStack.Create;
end;

destructor TIFPSExec.Destroy;
var
  I: Longint;
  x: PProcRec;
  P: PSpecialProc;
begin
  Clear;
  FReturnAddressType.Free;
  FVariantType.Free;
  FVariantArrayType.Free;

  if ExObject <> nil then ExObject.Free;
  for I := FSpecialProcList.Count -1 downto 0 do
  begin
    P := FSpecialProcList.Data^[I];
    Dispose(p);
  end;
  FResources.Free;
  FExportedVars.Free;
  FTempVars.Free;
  FStack.Free;
  FGlobalVars.Free;
  FProcs.Free;
  FTypes.Free;
  FSpecialProcList.Free;
  for i := FRegProcs.Count - 1 downto 0 do
  begin
    x := FRegProcs.Data^[i];
    if @x^.FreeProc <> nil then x^.FreeProc(Self, x);
    Dispose(x);
  end;
  FRegProcs.Free;
  FExceptionStack.Free;
  for i := FAttributeTypes.Count -1 downto 0 do
  begin
    TIFPSAttributeType(FAttributeTypes[i]).Free;
  end;
  FAttributeTypes.Free;
  inherited Destroy;
end;

procedure TIFPSExec.ExceptionProc(proc, Position: Cardinal; Ex: TIFError; const s: string; NewObject: TObject);
var
  d, l: Longint;
  pp: PIFPSExceptionHandler;
begin
  ExProc := proc;
  ExPos := Position;
  ExEx := Ex;
  ExParam := s;
  if ExObject <> nil then
    ExObject.Free;
  ExObject := NewObject;
  if Ex = eNoError then Exit;
  for d := FExceptionStack.Count -1 downto 0 do
  begin
    pp := FExceptionStack[d];
    if Cardinal(FStack.Count) > pp^.StackSize then
    begin
      for l := Longint(FStack.count) -1 downto Longint(pp^.StackSize) do
        FStack.Pop;
    end;
    if pp.CurrProc = nil then // no point in continuing
    begin
      Dispose(pp);
      FExceptionStack.DeleteLast;
      FStatus := isPaused;
      exit;
    end;
    FCurrProc := pp.CurrProc;
    FData := FCurrProc.Data;
    FDataLength := FCurrProc.Length;

    FCurrStackBase := pp^.BasePtr;
    if pp^.FinallyOffset <> InvalidVal then
    begin
      FCurrentPosition := pp^.FinallyOffset;
      pp^.FinallyOffset := InvalidVal;
      Exit;
    end else if pp^.ExceptOffset <> InvalidVal then
    begin
      FCurrentPosition := pp^.ExceptOffset;
      pp^.ExceptOffset := InvalidVal;
      Exit;
    end else if pp^.Finally2Offset <> InvalidVal then
    begin
      FCurrentPosition := pp^.Finally2Offset;
      pp^.Finally2Offset := InvalidVal;
      Exit;
    end;
    Dispose(pp);
    FExceptionStack.DeleteLast;
  end;
  if FStatus <> isNotLoaded then
    FStatus := isPaused;
end;

function LookupProc(List: TIfList; const Name: ShortString): PProcRec;
var
  h, l: Longint;
  p: PProcRec;
begin
  h := MakeHash(Name);
  for l := List.Count - 1 downto 0 do
  begin
    p := List.Data^[l];
    if (p^.Hash = h) and (p^.Name = Name) then
    begin
      Result := List[l];
      exit;
    end;
  end;
  Result := nil;
end;

function TIFPSExec.ImportProc(const Name: ShortString; proc: TIFExternalProcRec): Boolean;
var
  u: PProcRec;
  fname: string;
  I, fnh: Longint;
  P: PSpecialProc;

begin
  if name = '' then
  begin
    fname := proc.Decl;
    fname := copy(fname, 1, pos(':', fname)-1);
    fnh := MakeHash(fname);
    for I := FSpecialProcList.Count -1 downto 0 do
    begin
      p := FSpecialProcList[I];
      IF (p^.name = '') or ((p^.namehash = fnh) and (p^.name = fname)) then
      begin
        if p^.P(Self, Proc, p^.tag) then
        begin
          Result := True;
          exit;
        end;
      end;
    end;
    Result := FAlse;
    exit;
  end;
  u := LookupProc(FRegProcs, Name);
  if u = nil then begin
    Result := False;
    exit;
  end;
  proc.ProcPtr := u^.ProcPtr;
  proc.Ext1 := u^.Ext1;
  proc.Ext2 := u^.Ext2;
  Result := True;
end;

function TIFPSExec.RegisterFunctionName(const Name: string; ProcPtr: TIFProc; Ext1, Ext2: Pointer): PProcRec;
var
  p: PProcRec;
  s: string;
begin
  s := FastUppercase(Name);
  if LookupProc(FRegProcs, s) <> nil then
  begin
    Result :=  nil;
    exit;
  end;
  New(p);
  p^.Name := s;
  p^.Hash := MakeHash(s);
  p^.ProcPtr := ProcPtr;
  p^.FreeProc := nil;
  p.Ext1 := Ext1;
  p^.Ext2 := Ext2;
  FRegProcs.Add(p);
  Result := P;
end;

function TIFPSExec.LoadData(const s: string): Boolean;
var
  HDR: TIFPSHeader;
  Pos: Cardinal;

  function read(var Data; Len: Cardinal): Boolean;
  begin
    if Longint(Pos + Len) <= Length(s) then begin
      Move(s[Pos + 1], Data, Len);
      Pos := Pos + Len;
      read := True;
    end
    else
      read := False;
  end;
  function ReadAttributes(Dest: TIFPSRuntimeAttributes): Boolean;
  var
    Count: Cardinal;
    i: Integer;

    function ReadAttrib: Boolean;
    var
      NameLen: Longint;
      Name: string;
      TypeNo: Cardinal;
      i, h, FieldCount: Longint;
      att: TIFPSRuntimeAttribute;
      varp: PIFVariant;

    begin
      if (not Read(NameLen, 4)) or (NameLen > Length(s) - Longint(Pos)) then
      begin
        CMD_Err(ErOutOfRange);
        Result := false;
        exit;
      end;
      SetLength(Name, NameLen);
      if not Read(Name[1], NameLen) then
      begin
        CMD_Err(ErOutOfRange);
        Result := false;
        exit;
      end;
      if not Read(FieldCount, 4) then
      begin
        CMD_Err(ErOutOfRange);
        Result := false;
        exit;
      end;
      att := Dest.Add;
      att.AttribType := Name;
      att.AttribTypeHash := MakeHash(att.AttribType);
      for i := 0 to FieldCount -1 do
      begin
        if (not Read(TypeNo, 4)) or (TypeNo >= Cardinal(FTypes.Count)) then
        begin
          CMD_Err(ErOutOfRange);
          Result := false;
          exit;
        end;

        varp := att.AddValue(FTypes[TypeNo]);
        case VarP^.FType.BaseType of
          btSet:
            begin
              if not read(PIFPSVariantSet(varp).Data, TIFTypeRec_Set(varp.FType).aByteSize) then
              begin
                CMD_Err(erOutOfRange);

                DestroyHeapVariant(VarP);
                Result := False;
                exit;
              end;
            end;
          bts8, btchar, btU8: if not read(PIFPSVariantU8(VarP)^.data, 1) then
          begin
              CMD_Err(erOutOfRange);
              DestroyHeapVariant(VarP);
              Result := False;
              exit;
            end;
          bts16, {$IFNDEF IFPS3_NOWIDESTRING}btwidechar,{$ENDIF} btU16: if not read(PIFPSVariantU16(Varp)^.Data, SizeOf(TbtU16)) then begin
              CMD_Err(ErOutOfRange);
              DestroyHeapVariant(VarP);
              Result := False;
              exit;
            end;
          bts32, btU32, btProcPtr:
            begin
              if FCurrentPosition + 3 >= FDataLength then
              begin
                Cmd_Err(erOutOfRange);
                DestroyHeapVariant(VarP);
                Result := False;
                exit;;
              end;
              PIFPSVariantU32(varp)^.Data := Cardinal((@FData^[FCurrentPosition])^);
              Inc(FCurrentPosition, 4);
            end;
          {$IFNDEF IFPS3_NOINT64}
          bts64: if not read(PIFPSVariantS64(VarP)^.Data, sizeof(tbts64)) then
            begin
              CMD_Err(erOutOfRange);
              DestroyHeapVariant(VarP);
              Result := False;
              exit;
            end;
          {$ENDIF}
          btSingle: if not read(PIFPSVariantSingle(VarP)^.Data, SizeOf(TbtSingle))
            then begin
              CMD_Err(erOutOfRange);
              DestroyHeapVariant(VarP);
              Result := False;
              exit;
            end;
          btDouble: if not read(PIFPSVariantDouble(varp)^.Data, SizeOf(TbtDouble))
            then begin
              CMD_Err(erOutOfRange);
              DestroyHeapVariant(VarP);
              Result := False;
              exit;
            end;
          btExtended: if not read(PIFPSVariantExtended(varp)^.Data, SizeOf(TbtExtended))
            then begin
              CMD_Err(erOutOfRange);
              DestroyHeapVariant(VarP);
              Result := False;
              exit;
            end;
          btCurrency: if not read(PIFPSVariantExtended(varp)^.Data, SizeOf(tbtCurrency))
            then begin
              CMD_Err(erOutOfRange);
              DestroyHeapVariant(VarP);
              Result := False;
              exit;
            end;
          btPchar, btString:
          begin
            if not read(NameLen, 4) then
            begin
                Cmd_Err(erOutOfRange);
                DestroyHeapVariant(VarP);
                Result := False;
                exit;
              end;
              Inc(FCurrentPosition, 4);
              SetLength(PIFPSVariantAString(varp)^.Data, NameLen);
              if not read(PIFPSVariantAString(varp)^.Data[1], NameLen) then begin
                CMD_Err(erOutOfRange);
                DestroyHeapVariant(VarP);
                Result := False;
                exit;
              end;
            end;
          {$IFNDEF IFPS3_NOWIDESTRING}
          btWidestring:
            begin
              if not read(NameLen, 4) then
              begin
                Cmd_Err(erOutOfRange);
                DestroyHeapVariant(VarP);
                Result := False;
                exit;
              end;
              Inc(FCurrentPosition, 4);
              SetLength(PIFPSVariantWString(varp).Data, NameLen);
              if not read(PIFPSVariantWString(varp).Data[1], NameLen*2) then begin
                CMD_Err(erOutOfRange);
                DestroyHeapVariant(VarP);
                Result := False;
                exit;
              end;
            end;
          {$ENDIF}
        else begin
            CMD_Err(erInvalidType);
            DestroyHeapVariant(VarP);
            Result := False;
            exit;
          end;
        end;
      end;
      h := MakeHash(att.AttribType);
      for i := FAttributeTypes.Count -1 downto 0 do
      begin
        if (TIFPSAttributeType(FAttributeTypes.Data^[i]).TypeNameHash = h) and
          (TIFPSAttributeType(FAttributeTypes.Data^[i]).TypeName = att.AttribType) then
        begin
          if not TIFPSAttributeType(FAttributeTypes.Data^[i]).UseProc(Self, att.AttribType, Att) then
          begin
            Result := False;
            exit;
          end;
        end;
      end;
      Result := True;
    end;


  begin
    if not Read(Count, 4) then
    begin
      CMD_Err(erOutofRange);
      Result := false;
      exit;
    end;
    for i := 0 to Count -1 do
    begin
      if not ReadAttrib then
      begin
        Result := false;
        exit;
      end;
    end;
    Result := True;
  end;

{$WARNINGS OFF}

  function LoadTypes: Boolean;
  var
    currf: TIFPSType;
    Curr: PIFTypeRec;
    fe: Boolean;
    l2, l: Longint;
    d: Cardinal;

    function resolve(Dta: TIFTypeRec_Record): Boolean;
    var
      offs, l: Longint;
    begin
      offs := 0;
      for l := 0 to Dta.FieldTypes.Count -1 do
      begin
        Dta.RealFieldOffsets.Add(Pointer(offs));
        offs := offs + TIFTypeRec(Dta.FieldTypes[l]).RealSize;
      end;
      Result := True;
    end;
  begin
    LoadTypes := True;
    for l := 0 to HDR.TypeCount - 1 do begin
      if not read(currf, SizeOf(currf)) then begin
        cmd_err(erUnexpectedEof);
        LoadTypes := False;
        exit;
      end;
      if (currf.BaseType and 128) <> 0 then begin
        fe := True;
        currf.BaseType := currf.BaseType - 128;
      end else
        fe := False;
      case currf.BaseType of
        {$IFNDEF IFPS3_NOINT64}bts64, {$ENDIF}
        btU8, btS8, btU16, btS16, btU32, btS32, btProcPtr,btSingle, btDouble, btCurrency,
        btExtended, btString, btPointer, btPChar,
        btVariant, btChar{$IFNDEF IFPS3_NOWIDESTRING}, btWideString, btWideChar{$ENDIF}: begin
            curr := TIFTypeRec.Create(self);
            Curr.BaseType := currf.BaseType;
            FTypes.Add(Curr);
          end;
        btClass:
          begin
            Curr := TIFTypeRec_Class.Create(self);
            if (not Read(d, 4)) or (d > 255) then
            begin
              curr.Free;
              cmd_err(erUnexpectedEof);
              LoadTypes := False;
              exit;
            end;
            setlength(TIFTypeRec_Class(Curr).FCN, d);
            if not Read(TIFTypeRec_Class(Curr).FCN[1], d) then
            begin
              curr.Free;
              cmd_err(erUnexpectedEof);
              LoadTypes := False;
              exit;
            end;
            Curr.BaseType := currf.BaseType;
            FTypes.Add(Curr);
          end;
{$IFNDEF IFPS3_NOINTERFACES}
        btInterface:
          begin
            Curr := TIFTypeRec_Interface.Create(self);
            if not Read(TIFTypeRec_Interface(Curr).FGUID, Sizeof(TGuid)) then
            begin
              curr.Free;
              cmd_err(erUnexpectedEof);
              LoadTypes := False;
              exit;
            end;
            Curr.BaseType := currf.BaseType;
            FTypes.Add(Curr);
          end;
{$ENDIF}
        btSet:
          begin
            Curr := TIFTypeRec_Set.Create(self);
            if not Read(d, 4) then
            begin
              curr.Free;
              cmd_err(erUnexpectedEof);
              LoadTypes := False;
              exit;
            end;
            if (d > 256) then
            begin
              curr.Free;
              cmd_err(erTypeMismatch);
              LoadTypes := False;
              exit;
            end;

            TIFTypeRec_Set(curr).aBitSize := d;
            TIFTypeRec_Set(curr).aByteSize := TIFTypeRec_Set(curr).aBitSize shr 3;
            if (TIFTypeRec_Set(curr).aBitSize and 7) <> 0 then inc(TIFTypeRec_Set(curr).fbytesize);
            Curr.BaseType := currf.BaseType;
            FTypes.Add(Curr);
          end;
        btStaticArray:
          begin
            curr := TIFTypeRec_StaticArray.Create(self);
            if not Read(d, 4) then
            begin
              curr.Free;
              cmd_err(erUnexpectedEof);
              LoadTypes := False;
              exit;
            end;
            if (d >= FTypes.Count) then
            begin
              curr.Free;
              cmd_err(erTypeMismatch);
              LoadTypes := False;
              exit;
            end;
            TIFTypeRec_StaticArray(curr).ArrayType := FTypes[d];
            if not Read(d, 4) then
            begin
              curr.Free;
              cmd_err(erUnexpectedEof);
              LoadTypes := False;
              exit;
            end;
            if d > (MaxInt div 4) then
            begin
              curr.Free;
              cmd_err(erUnexpectedEof);
              LoadTypes := False;
              exit;
            end;
            TIFTypeRec_StaticArray(curr).Size := d;
            Curr.BaseType := currf.BaseType;
            FTypes.Add(Curr);
          end;
        btArray: begin
            Curr := TIFTypeRec_Array.Create(self);
            if not read(d, 4) then
            begin // Read type
              curr.Free;
              cmd_err(erUnexpectedEof);
              LoadTypes := False;
              exit;
            end;
            if (d >= FTypes.Count) then
            begin
              curr.Free;
              cmd_err(erTypeMismatch);
              LoadTypes := False;
              exit;
            end;
            Curr.BaseType := currf.BaseType;
            TIFTypeRec_Array(curr).ArrayType := FTypes[d];
            FTypes.Add(Curr);
          end;
        btRecord:
          begin
            curr := TIFTypeRec_Record.Create(self);
            if not read(d, 4) or (d = 0) then
            begin
              curr.Free;
              cmd_err(erUnexpectedEof);
              LoadTypes := false;
              exit;
            end;
            while d > 0 do
            begin
              if not Read(l2, 4) then
              begin
                curr.Free;
                cmd_err(erUnexpectedEof);
                LoadTypes := false;
                exit;
              end;
              if Cardinal(l2) >= FTypes.Count then
              begin
                curr.Free;
                cmd_err(ErOutOfRange);
                LoadTypes := false;
                exit;
              end;
              TIFTypeRec_Record(curR).FFieldTypes.Add(FTypes[l2]);
              Dec(D);
            end;
            if not resolve(TIFTypeRec_Record(curr)) then
            begin
              curr.Free;
              cmd_err(erInvalidType);
              LoadTypes := False;
              exit;
            end;
            Curr.BaseType := currf.BaseType;
            FTypes.Add(Curr);
          end;
      else begin
          LoadTypes := False;
          CMD_Err(erInvalidType);
          exit;
        end;
      end;
      if fe then begin
        if not read(d, 4) then begin
          cmd_err(erUnexpectedEof);
          LoadTypes := False;
          exit;
        end;
        if d > IFPSAddrNegativeStackStart then
        begin
          cmd_err(erInvalidType);
          LoadTypes := False;
          exit;
        end;
        SetLength(Curr.FExportName, d);
        if not read(Curr.fExportName[1], d) then
        begin
          cmd_err(erUnexpectedEof);
          LoadTypes := False;
          exit;
        end;
        Curr.ExportNameHash := MakeHash(Curr.ExportName);
      end;
      curr.CalcSize;
      if HDR.IFPSBuildNo >= 21 then // since build 21 we support attributes
      begin
        if not ReadAttributes(Curr.Attributes) then
        begin
          LoadTypes := False;
          exit;
        end;
      end;
    end;
  end;

  function LoadProcs: Boolean;
  var
    Rec: TIFPSProc;
    n: string;
    b: Byte;
    l, L2, L3: Longint;
    Curr: TIFProcRec;
  begin
    LoadProcs := True;
    for l := 0 to HDR.ProcCount - 1 do begin
      if not read(Rec, SizeOf(Rec)) then begin
        cmd_err(erUnexpectedEof);
        LoadProcs := False;
        exit;
      end;
      if (Rec.Flags and 1) <> 0 then
      begin
        Curr := TIFExternalProcRec.Create(Self);
        if not read(b, 1) then begin
          Curr.Free;
          cmd_err(erUnexpectedEof);
          LoadProcs := False;
          exit;
        end;
        SetLength(n, b);
        if not read(n[1], b) then begin
          Curr.Free;
          cmd_err(erUnexpectedEof);
          LoadProcs := False;
          exit;
        end;
        TIFExternalProcRec(Curr).Name := n;
        if (Rec.Flags and 3 = 3) then
        begin
          if (not Read(L2, 4)) or (L2 > Length(s) - Pos) then
          begin
            Curr.Free;
            cmd_err(erUnexpectedEof);
            LoadProcs := False;
            exit;
          end;
          SetLength(n, L2);
          Read(n[1], L2); // no check is needed
          TIFExternalProcRec(Curr).FDecl := n;
        end;
        if not ImportProc(TIFExternalProcRec(Curr).Name, TIFExternalProcRec(Curr)) then begin
          if TIFExternalProcRec(Curr).Name <> '' then
            CMD_Err2(erCannotImport, TIFExternalProcRec(Curr).Name)
          else 
            CMD_Err2(erCannotImport, TIFExternalProcRec(curr).Decl);
          Curr.Free;
          LoadProcs := False;
          exit;
        end;
      end else begin
        Curr := TIFInternalProcRec.Create(Self);
        if not read(L2, 4) then begin
          Curr.Free;
          cmd_err(erUnexpectedEof);
          LoadProcs := False;
          exit;
        end;
        if not read(L3, 4) then begin
          Curr.Free;
          cmd_err(erUnexpectedEof);
          LoadProcs := False;
          exit;
        end;
        if (L2 < 0) or (L2 >= Length(s)) or (L2 + L3 > Length(s)) or (L3 = 0) then begin
          Curr.Free;
          cmd_err(erUnexpectedEof);
          LoadProcs := False;
          exit;
        end;

        GetMem(TIFInternalProcRec(Curr).FData, L3);
        Move(s[L2 + 1], TIFInternalProcRec(Curr).FData^, L3);
        TIFInternalProcRec(Curr).FLength := L3;
        if (Rec.Flags and 2) <> 0 then begin // exported
          if not read(L3, 4) then begin
            Curr.Free;
            cmd_err(erUnexpectedEof);
            LoadProcs := False;
            exit;
          end;
          if L3 > IFPSAddrNegativeStackStart then begin
            Curr.Free;
            cmd_err(erUnexpectedEof);
            LoadProcs := False;
            exit;
          end;
          SetLength(TIFInternalProcRec(Curr).FExportName, L3);
          if not read(TIFInternalProcRec(Curr).FExportName[1], L3) then begin
            Curr.Free;
            cmd_err(erUnexpectedEof);
            LoadProcs := False;
            exit;
          end;
          if not read(L3, 4) then begin
            Curr.Free;
            cmd_err(erUnexpectedEof);
            LoadProcs := False;
            exit;
          end;
          if L3 > IFPSAddrNegativeStackStart then begin
            Curr.Free;
            cmd_err(erUnexpectedEof);
            LoadProcs := False;
            exit;
          end;
          SetLength(TIFInternalProcRec(Curr).FExportDecl, L3);
          if not read(TIFInternalProcRec(Curr).FExportDecl[1], L3) then begin
            Curr.Free;
            cmd_err(erUnexpectedEof);
            LoadProcs := False;
            exit;
          end;
          TIFInternalProcRec(Curr).FExportNameHash := MakeHash(TIFInternalProcRec(Curr).ExportName);
        end;
      end;
      if (Rec.Flags and 4) <> 0 then
      begin
        if not ReadAttributes(Curr.Attributes) then
        begin
          Curr.Free;
          LoadProcs := False;
          exit;
        end;
      end;
      FProcs.Add(Curr);
    end;
  end;
{$WARNINGS ON}

  function LoadVars: Boolean;
  var
    l, n: Longint;
    e: PIFPSExportedVar;
    Rec: TIFPSVar;
    Curr: PIfVariant;
  begin
    LoadVars := True;
    for l := 0 to HDR.VarCount - 1 do begin
      if not read(Rec, SizeOf(Rec)) then begin
        cmd_err(erUnexpectedEof);
        LoadVars := False;
        exit;
      end;
      if Rec.TypeNo >= HDR.TypeCount then begin
        cmd_err(erInvalidType);
        LoadVars := False;
        exit;
      end;
      Curr := FGlobalVars.PushType(FTypes.Data^[Rec.TypeNo]);
      if Curr = nil then begin
        cmd_err(erInvalidType);
        LoadVars := False;
        exit;
      end;
      if (Rec.Flags and 1) <> 0then
      begin
        if not read(n, 4) then begin
          cmd_err(erUnexpectedEof);
          LoadVars := False;
          exit;
        end;
        new(e);
        try
          SetLength(e^.FName, n);
          if not Read(e^.FName[1], n) then
          begin
            dispose(e);
            cmd_err(erUnexpectedEof);
            LoadVars := False;
            exit;
          end;
          e^.FNameHash := MakeHash(e^.FName);
          e^.FVarNo := FGlobalVars.Count;
          FExportedVars.Add(E);
        except
          dispose(e);
          cmd_err(erInvalidType);
          LoadVars := False;
          exit;
        end;
      end;
    end;
  end;

begin
  Clear;
  Pos := 0;
  LoadData := False;
  if not read(HDR, SizeOf(HDR)) then
  begin
    CMD_Err(erInvalidHeader);
    exit;
  end;
  if HDR.HDR <> IFPSValidHeader then
  begin
    CMD_Err(erInvalidHeader);
    exit;
  end;
  if (HDR.IFPSBuildNo > IFPSCurrentBuildNo) or (HDR.IFPSBuildNo < IFPSLowBuildSupport) then begin
    CMD_Err(erInvalidHeader);
    exit;
  end;
  if not LoadTypes then
  begin
    Clear;
    exit;
  end;
  if not LoadProcs then
  begin
    Clear;
    exit;
  end;
  if not LoadVars then
  begin
    Clear;
    exit;
  end;
  if (HDR.MainProcNo >= FProcs.Count) and (HDR.MainProcNo <> InvalidVal)then begin
    CMD_Err(erNoMainProc);
    Clear;
    exit;
  end;
  // Load Import Table
  FMainProc := HDR.MainProcNo;
  FStatus := isLoaded;
  Result := True;
end;


procedure TIFPSExec.Pause;
begin
  if FStatus = isRunning then
    FStatus := isPaused;
end;

function TIFPSExec.ReadData(var Data; Len: Cardinal): Boolean;
begin
  if FCurrentPosition + Len <= FDataLength then begin
    Move(FData^[FCurrentPosition], Data, Len);
    FCurrentPosition := FCurrentPosition + Len;
    Result := True;
  end
  else
    Result := False;
end;

procedure TIFPSExec.CMD_Err(EC: TIFError); // Error
begin
  CMD_Err3(ec, '', nil);
end;

procedure VNSetPointerTo(const Src: TIFPSVariantIFC; Data: Pointer; aType: TIFTypeRec);
begin
  if Src.aType.BaseType = btPointer then
  begin
    if atype.BaseType in NeedFinalization then
      FinalizeVariant(src.Dta, Src.aType);
    Pointer(Src.Dta^) := Data;
    Pointer(Pointer(IPointer(Src.Dta)+4)^) := aType;
    Pointer(Pointer(IPointer(Src.Dta)+8)^) := nil;
  end;
end;

function VNGetUInt(const Src: TIFPSVariantIFC): Cardinal;
begin
  Result := IFPSGetUInt(Src.Dta, Src.aType);
end;

{$IFNDEF IFPS3_NOINT64}
function VNGetInt64(const Src: TIFPSVariantIFC): Int64;
begin
  Result := IFPSGetInt64(Src.Dta, Src.aType);
end;
{$ENDIF}

function VNGetReal(const Src: TIFPSVariantIFC): Extended;
begin
  Result := IFPSGetReal(Src.Dta, Src.aType);
end;

function VNGetCurrency(const Src: TIFPSVariantIFC): Currency;
begin
  Result := IFPSGetCurrency(Src.Dta, Src.aType);
end;

function VNGetInt(const Src: TIFPSVariantIFC): Longint;
begin
  Result := IFPSGetInt(Src.Dta, Src.aType);
end;

function VNGetString(const Src: TIFPSVariantIFC): String;
begin
  Result := IFPSGetString(Src.Dta, Src.aType);
end;

{$IFNDEF IFPS3_NOWIDESTRING}
function VNGetWideString(const Src: TIFPSVariantIFC): WideString;
begin
  Result := IFPSGetWideString(Src.Dta, Src.aType);
end;
{$ENDIF}

procedure VNSetUInt(const Src: TIFPSVariantIFC; const Val: Cardinal);
var
  Dummy: Boolean;
begin
  IFPSSetUInt(Src.Dta, Src.aType, Dummy, Val);
end;

{$IFNDEF IFPS3_NOINT64}
procedure VNSetInt64(const Src: TIFPSVariantIFC; const Val: Int64);
var
  Dummy: Boolean;
begin
  IFPSSetInt64(Src.Dta, Src.aType, Dummy, Val);
end;
{$ENDIF}

procedure VNSetReal(const Src: TIFPSVariantIFC; const Val: Extended);
var
  Dummy: Boolean;
begin
  IFPSSetReal(Src.Dta, Src.aType, Dummy, Val);
end;

procedure VNSetCurrency(const Src: TIFPSVariantIFC; const Val: Currency);
var
  Dummy: Boolean;
begin
  IFPSSetCurrency(Src.Dta, Src.aType, Dummy, Val);
end;

procedure VNSetInt(const Src: TIFPSVariantIFC; const Val: Longint);
var
  Dummy: Boolean;
begin
  IFPSSetInt(Src.Dta, Src.aType, Dummy, Val);
end;

procedure VNSetString(const Src: TIFPSVariantIFC; const Val: String);
var
  Dummy: Boolean;
begin
  IFPSSetString(Src.Dta, Src.aType, Dummy, Val);
end;

{$IFNDEF IFPS3_NOWIDESTRING}
procedure VNSetWideString(const Src: TIFPSVariantIFC; const Val: WideString);
var
  Dummy: Boolean;
begin
  IFPSSetWideString(Src.Dta, Src.aType, Dummy, Val);
end;
{$ENDIF}

function VGetUInt(const Src: PIFVariant): Cardinal;
begin
  Result := IFPSGetUInt(@PIFPSVariantData(src).Data, src.FType);
end;

{$IFNDEF IFPS3_NOINT64}
function VGetInt64(const Src: PIFVariant): Int64;
begin
  Result := IFPSGetInt64(@PIFPSVariantData(src).Data, src.FType);
end;
{$ENDIF}

function VGetReal(const Src: PIFVariant): Extended;
begin
  Result := IFPSGetReal(@PIFPSVariantData(src).Data, src.FType);
end;

function VGetCurrency(const Src: PIFVariant): Currency;
begin
  Result := IFPSGetCurrency(@PIFPSVariantData(src).Data, src.FType);
end;

function VGetInt(const Src: PIFVariant): Longint;
begin
  Result := IFPSGetInt(@PIFPSVariantData(src).Data, src.FType);
end;

function VGetString(const Src: PIFVariant): String;
begin
  Result := IFPSGetString(@PIFPSVariantData(src).Data, src.FType);
end;

{$IFNDEF IFPS3_NOWIDESTRING}
function VGetWideString(const Src: PIFVariant): WideString;
begin
  Result := IFPSGetWideString(@PIFPSVariantData(src).Data, src.FType);
end;
{$ENDIF}


procedure VSetPointerTo(const Src: PIFVariant; Data: Pointer; aType: TIFTypeRec);
var
  temp: TIFPSVariantIFC;
begin
  if (Atype = nil) or (Data = nil) or (Src = nil) then raise Exception.Create('Invalid variable');
  temp.Dta := @PIFPSVariantData(Src).Data;
  temp.aType := Src.FType;
  temp.VarParam := false;
  VNSetPointerTo(temp, Data, AType);
end;

procedure VSetUInt(const Src: PIFVariant; const Val: Cardinal);
var
  Dummy: Boolean;
begin
  IFPSSetUInt(@PIFPSVariantData(src).Data, src.FType, Dummy, Val);
end;

{$IFNDEF IFPS3_NOINT64}
procedure VSetInt64(const Src: PIFVariant; const Val: Int64);
var
  Dummy: Boolean;
begin
  IFPSSetInt64(@PIFPSVariantData(src).Data, src.FType, Dummy, Val);
end;
{$ENDIF}

procedure VSetReal(const Src: PIFVariant; const Val: Extended);
var
  Dummy: Boolean;
begin
  IFPSSetReal(@PIFPSVariantData(src).Data, src.FType, Dummy, Val);
end;

procedure VSetCurrency(const Src: PIFVariant; const Val: Currency);
var
  Dummy: Boolean;
begin
  IFPSSetCurrency(@PIFPSVariantData(src).Data, src.FType, Dummy, Val);
end;

procedure VSetInt(const Src: PIFVariant; const Val: Longint);
var
  Dummy: Boolean;
begin
  IFPSSetInt(@PIFPSVariantData(src).Data, src.FType, Dummy, Val);
end;

procedure VSetString(const Src: PIFVariant; const Val: String);
var
  Dummy: Boolean;
begin
  IFPSSetString(@PIFPSVariantData(src).Data, src.FType, Dummy, Val);
end;

{$IFNDEF IFPS3_NOWIDESTRING}
procedure VSetWideString(const Src: PIFVariant; const Val: WideString);
var
  Dummy: Boolean;
begin
  IFPSSetWideString(@PIFPSVariantData(src).Data, src.FType, Dummy, Val);
end;
{$ENDIF}


function IFPSGetUInt(Src: Pointer; aType: TIFTypeRec): Cardinal;
begin
  if aType.BaseType = btPointer then
  begin
    atype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
    Src := Pointer(Src^);
    if (src = nil) or (aType = nil) then raise Exception.Create('Type Mismatch');
  end;
  case aType.BaseType of
    btU8: Result := tbtu8(src^);
    btS8: Result := tbts8(src^);
    btU16: Result := tbtu16(src^);
    btS16: Result := tbts16(src^);
    btProcPtr, btU32: Result := tbtu32(src^);
    btS32: Result := tbts32(src^);
{$IFNDEF IFPS3_NOINT64}    btS64: Result := tbts64(src^);
{$ENDIF}
    btChar: Result := Ord(tbtchar(Src^));
{$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: Result := Ord(tbtwidechar(Src^));{$ENDIF}
    btVariant:  Result := Variant(src^);
    else raise Exception.Create('Type Mismatch');
  end;
end;

function IFPSGetObject(Src: Pointer; aType: TIFTypeRec): TObject;
begin
  if aType.BaseType = btPointer then
  begin
    atype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
    Src := Pointer(Src^);
    if (src = nil) or (aType = nil) then raise Exception.Create('Type Mismatch');
  end;
  case aType.BaseType of
    btClass: Result := TObject(Src^);
    else raise Exception.Create('Type Mismatch');
  end;
end;

procedure IFPSSetObject(Src: Pointer; aType: TIFTypeRec; var Ok: Boolean; Const val: TObject);
begin
  if aType.BaseType = btPointer then
  begin
    atype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
    Src := Pointer(Src^);
    if (src = nil) or (aType = nil) then raise Exception.Create('Type Mismatch');
  end;
  case aType.BaseType of
    btClass: TObject(Src^) := Val;
    else raise Exception.Create('Type Mismatch');
  end;
end;


{$IFNDEF IFPS3_NOINT64}
function IFPSGetInt64(Src: Pointer; aType: TIFTypeRec): Int64;
begin
  if aType.BaseType = btPointer then
  begin
    atype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
    Src := Pointer(Src^);
    if (src = nil) or (aType = nil) then raise Exception.Create('Type Mismatch');
  end;
  case aType.BaseType of
    btU8: Result := tbtu8(src^);
    btS8: Result := tbts8(src^);
    btU16: Result := tbtu16(src^);
    btS16: Result := tbts16(src^);
    btProcPtr, btU32: Result := tbtu32(src^);
    btS32: Result := tbts32(src^);
    btS64: Result := tbts64(src^);
    btChar: Result := Ord(tbtchar(Src^));
    btWideChar: Result := Ord(tbtwidechar(Src^));
{$IFDEF IFPS3_D6PLUS}
    btVariant:   Result := Variant(src^);
{$ENDIF}
    else raise Exception.Create('Type Mismatch');
  end;
end;
{$ENDIF}

function IFPSGetReal(Src: Pointer; aType: TIFTypeRec): Extended;
begin
  if aType.BaseType = btPointer then
  begin
    atype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
    Src := Pointer(Src^);
    if (src = nil) or (aType = nil) then raise Exception.Create('Type Mismatch');
  end;
  case aType.BaseType of
    btU8: Result := tbtu8(src^);
    btS8: Result := tbts8(src^);
    btU16: Result := tbtu16(src^);
    btS16: Result := tbts16(src^);
    btProcPtr, btU32: Result := tbtu32(src^);
    btS32: Result := tbts32(src^);
{$IFNDEF IFPS3_NOINT64}    btS64: Result := tbts64(src^);{$ENDIF}
    btSingle: Result := tbtsingle(Src^);
    btDouble: Result := tbtdouble(Src^);
    btExtended: Result := tbtextended(Src^);
    btCurrency: Result := tbtcurrency(Src^);
    btVariant:  Result := Variant(src^);
    else raise Exception.Create('Type Mismatch');
  end;
end;

function IFPSGetCurrency(Src: Pointer; aType: TIFTypeRec): Currency;
begin
  if aType.BaseType = btPointer then
  begin
    atype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
    Src := Pointer(Src^);
    if (src = nil) or (aType = nil) then raise Exception.Create('Type Mismatch');
  end;
  case aType.BaseType of
    btU8: Result := tbtu8(src^);
    btS8: Result := tbts8(src^);
    btU16: Result := tbtu16(src^);
    btS16: Result := tbts16(src^);
    btProcPtr, btU32: Result := tbtu32(src^);
    btS32: Result := tbts32(src^);
{$IFNDEF IFPS3_NOINT64} btS64: Result := tbts64(src^);{$ENDIF}
    btSingle: Result := tbtsingle(Src^);
    btDouble: Result := tbtdouble(Src^);
    btExtended: Result := tbtextended(Src^);
    btCurrency: Result := tbtcurrency(Src^);
    btVariant:   Result := Variant(src^);
    else raise Exception.Create('Type Mismatch');
  end;
end;


function IFPSGetInt(Src: Pointer; aType: TIFTypeRec): Longint;
begin
  if aType.BaseType = btPointer then
  begin
    atype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
    Src := Pointer(Src^);
    if (src = nil) or (aType = nil) then raise Exception.Create('Type Mismatch');
  end;
  case aType.BaseType of
    btU8: Result := tbtu8(src^);
    btS8: Result := tbts8(src^);
    btU16: Result := tbtu16(src^);
    btS16: Result := tbts16(src^);
    btProcPtr, btU32: Result := tbtu32(src^);
    btS32: Result := tbts32(src^);
{$IFNDEF IFPS3_NOINT64} btS64: Result := tbts64(src^);{$ENDIF}
    btChar: Result := Ord(tbtchar(Src^));
{$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: Result := Ord(tbtwidechar(Src^));{$ENDIF}
    btVariant: Result := Variant(src^);
    else raise Exception.Create('Type Mismatch');
  end;
end;


function IFPSGetString(Src: Pointer; aType: TIFTypeRec): String;
begin
  if aType.BaseType = btPointer then
  begin
    atype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
    Src := Pointer(Src^);
    if (src = nil) or (aType = nil) then raise Exception.Create('Type Mismatch');
  end;
  case aType.BaseType of
    btU8: Result := chr(tbtu8(src^));
    btChar: Result := tbtchar(Src^);
    btPchar: Result := pchar(src^);
{$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: Result := tbtwidechar(Src^);{$ENDIF}
    btString: Result := tbtstring(src^);
{$IFNDEF IFPS3_NOWIDESTRING}    btWideString: Result := tbtwidestring(src^);{$ENDIF}
    btVariant:  Result := Variant(src^);
    else raise Exception.Create('Type Mismatch');
  end;
end;
{$IFNDEF IFPS3_NOWIDESTRING}
function IFPSGetWideString(Src: Pointer; aType: TIFTypeRec): WideString;
begin
  if aType.BaseType = btPointer then
  begin
    atype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
    Src := Pointer(Src^);
    if (src = nil) or (aType = nil) then raise Exception.Create('Type Mismatch');
  end;
  case aType.BaseType of
    btU8: Result := chr(tbtu8(src^));
    btU16: Result := widechar(src^);
    btChar: Result := tbtchar(Src^);
    btPchar: Result := pchar(src^);
    btWideChar: Result := tbtwidechar(Src^);
    btString: Result := tbtstring(src^);
    btWideString: Result := tbtwidestring(src^);
    btVariant:   Result := Variant(src^);
    else raise Exception.Create('Type Mismatch');
  end;
end;
{$ENDIF}

procedure IFPSSetUInt(Src: Pointer; aType: TIFTypeRec; var Ok: Boolean; const Val: Cardinal);
begin
  if (Src = nil) or (aType = nil) then begin Ok := false; exit; end;
  if aType.BaseType = btPointer then
  begin
    atype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
    Src := Pointer(Src^);
    if (src = nil) or (aType = nil) then begin Ok := false; exit; end;
  end;
  case aType.BaseType of
    btU8: tbtu8(src^) := Val;
    btS8: tbts8(src^) := Val;
    btU16: tbtu16(src^) := Val;
    btS16: tbts16(src^) := Val;
    btProcPtr, btU32: tbtu32(src^) := Val;
    btS32: tbts32(src^) := Val;
{$IFNDEF IFPS3_NOINT64}    btS64: tbts64(src^) := Val;{$ENDIF}
    btChar: tbtchar(Src^) := Chr(Val);
{$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: tbtwidechar(Src^) := tbtwidechar(Val);{$ENDIF}
    btSingle: tbtSingle(src^) := Val;
    btDouble: tbtDouble(src^) := Val;
    btCurrency: tbtCurrency(src^) := Val;
    btExtended: tbtExtended(src^) := Val;
    btVariant:
      begin
        try
          Variant(src^) := {$IFDEF IFPS3_D6PLUS}val{$ELSE}tbts32(val){$ENDIF};
        except
          Ok := false;
        end;
      end;
    else ok := false;
  end;
end;

{$IFNDEF IFPS3_NOINT64}
procedure IFPSSetInt64(Src: Pointer; aType: TIFTypeRec; var Ok: Boolean; const Val: Int64);
begin
  if (Src = nil) or (aType = nil) then begin Ok := false; exit; end;
  if aType.BaseType = btPointer then
  begin
    atype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
    Src := Pointer(Src^);
    if (src = nil) or (aType = nil) then begin Ok := false; exit; end;
  end;
  case aType.BaseType of
    btU8: tbtu8(src^) := Val;
    btS8: tbts8(src^) := Val;
    btU16: tbtu16(src^) := Val;
    btS16: tbts16(src^) := Val;
    btProcPtr, btU32: tbtu32(src^) := Val;
    btS32: tbts32(src^) := Val;
    btS64: tbts64(src^) := Val;
    btChar: tbtchar(Src^) := Chr(Val);
    btWideChar: tbtwidechar(Src^) := tbtwidechar(Val);
    btSingle: tbtSingle(src^) := Val;
    btDouble: tbtDouble(src^) := Val;
    btCurrency: tbtCurrency(src^) := Val;
    btExtended: tbtExtended(src^) := Val;
{$IFDEF IFPS3_D6PLUS}
    btVariant:
      begin
        try
          Variant(src^) := Val;
        except
          Ok := false;
        end;
      end;
{$ENDIF}
    else ok := false;
  end;
end;
{$ENDIF}

procedure IFPSSetReal(Src: Pointer; aType: TIFTypeRec; var Ok: Boolean; const Val: Extended);
begin
  if (Src = nil) or (aType = nil) then begin Ok := false; exit; end;
  if aType.BaseType = btPointer then
  begin
    atype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
    Src := Pointer(Src^);
    if (src = nil) or (aType = nil) then begin Ok := false; exit; end;
  end;
  case aType.BaseType of
    btSingle: tbtSingle(src^) := Val;
    btDouble: tbtDouble(src^) := Val;
    btCurrency: tbtCurrency(src^) := Val;
    btExtended: tbtExtended(src^) := Val;
    btVariant:
      begin
        try
          Variant(src^) := Val;
        except
          Ok := false;
        end;
      end;
    else ok := false;
  end;
end;

procedure IFPSSetCurrency(Src: Pointer; aType: TIFTypeRec; var Ok: Boolean; const Val: Currency);
begin
  if (Src = nil) or (aType = nil) then begin Ok := false; exit; end;
  if aType.BaseType = btPointer then
  begin
    atype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
    Src := Pointer(Src^);
    if (src = nil) or (aType = nil) then begin Ok := false; exit; end;
  end;
  case aType.BaseType of
    btSingle: tbtSingle(src^) := Val;
    btDouble: tbtDouble(src^) := Val;
    btCurrency: tbtCurrency(src^) := Val;
    btExtended: tbtExtended(src^) := Val;
    btVariant:
      begin
        try
          Variant(src^) := Val;
        except
          Ok := false;
        end;
      end;
    else ok := false;
  end;
end;

procedure IFPSSetInt(Src: Pointer; aType: TIFTypeRec; var Ok: Boolean; const Val: Longint);
begin
  if (Src = nil) or (aType = nil) then begin Ok := false; exit; end;
  if aType.BaseType = btPointer then
  begin
    atype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
    Src := Pointer(Src^);
    if (src = nil) or (aType = nil) then begin Ok := false; exit; end;
  end;
  case aType.BaseType of
    btU8: tbtu8(src^) := Val;
    btS8: tbts8(src^) := Val;
    btU16: tbtu16(src^) := Val;
    btS16: tbts16(src^) := Val;
    btProcPtr, btU32: tbtu32(src^) := Val;
    btS32: tbts32(src^) := Val;
{$IFNDEF IFPS3_NOINT64}    btS64: tbts64(src^) := Val;{$ENDIF}
    btChar: tbtchar(Src^) := Chr(Val);
{$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: tbtwidechar(Src^) := tbtwidechar(Val);{$ENDIF}
    btSingle: tbtSingle(src^) := Val;
    btDouble: tbtDouble(src^) := Val;
    btCurrency: tbtCurrency(src^) := Val;
    btExtended: tbtExtended(src^) := Val;
    btVariant:
      begin
        try
          Variant(src^) := Val;
        except
          Ok := false;
        end;
      end;
    else ok := false;
  end;
end;

procedure IFPSSetString(Src: Pointer; aType: TIFTypeRec; var Ok: Boolean; const Val: String);
begin
  if (Src = nil) or (aType = nil) then begin Ok := false; exit; end;
  if aType.BaseType = btPointer then
  begin
    atype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
    Src := Pointer(Src^);
    if (src = nil) or (aType = nil) then begin Ok := false; exit; end;
  end;
  case aType.BaseType of
    btString: tbtstring(src^) := val;
{$IFNDEF IFPS3_NOWIDESTRING}    btWideString: tbtwidestring(src^) := val;{$ENDIF}
    btVariant:
      begin
        try
          Variant(src^) := Val;
        except
          Ok := false;
        end;
      end;
    else ok := false;
  end;
end;
{$IFNDEF IFPS3_NOWIDESTRING}
procedure IFPSSetWideString(Src: Pointer; aType: TIFTypeRec; var Ok: Boolean; const Val: WideString);
begin
  if (Src = nil) or (aType = nil) then begin Ok := false; exit; end;
  if aType.BaseType = btPointer then
  begin
    atype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
    Src := Pointer(Src^);
    if (src = nil) or (aType = nil) then begin Ok := false; exit; end;
  end;
  case aType.BaseType of
    btString: tbtstring(src^) := val;
    btWideString: tbtwidestring(src^) := val;
    btVariant:
      begin
        try
          Variant(src^) := Val;
        except
          Ok := false;
        end;
      end;
    else ok := false;
  end;
end;
{$ENDIF}

function CopyArrayContents(dest, src: Pointer; Len: Longint; aType: TIFTypeRec): Boolean; forward;

function CopyRecordContents(dest, src: Pointer; aType: TIFTypeRec_Record): Boolean;
var
  o, i: Longint;
begin
  for i := 0 to aType.FieldTypes.Count -1 do
  begin
    o := Longint(atype.RealFieldOffsets[i]);
    CopyArrayContents(Pointer(IPointer(Dest)+Cardinal(o)), Pointer(IPointer(Src)+Cardinal(o)), 1, aType.FieldTypes[i]);
  end;
  Result := true;
end;

function CopyArrayContents(dest, src: Pointer; Len: Longint; aType: TIFTypeRec): Boolean;
var
  elsize: Cardinal;
  i: Longint;
begin
  try
    case aType.BaseType of
      btU8, btS8, btChar:
        for i := 0 to Len -1 do
        begin
          tbtU8(Dest^) := tbtU8(Src^);
          Dest := Pointer(IPointer(Dest) + 1);
          Src := Pointer(IPointer(Src) + 1);
        end;
      btU16, btS16{$IFNDEF IFPS3_NOWIDESTRING}, btWideChar{$ENDIF}:
        for i := 0 to Len -1 do
        begin
          tbtU16(Dest^) := tbtU16(Src^);
          Dest := Pointer(IPointer(Dest) + 2);
          Src := Pointer(IPointer(Src) + 2);
        end;
      btU32, btS32, btClass, btSingle, btpchar, btprocptr:
        for i := 0 to Len -1 do
        begin
          tbtU32(Dest^) := tbtU32(Src^);
          Dest := Pointer(IPointer(Dest) + 4);
          Src := Pointer(IPointer(Src) + 4);
        end;
      btDouble:
        for i := 0 to Len -1 do
        begin
          tbtDouble(Dest^) := tbtDouble(Src^);
          Dest := Pointer(IPointer(Dest) + 8);
          Src := Pointer(IPointer(Src) + 8);
        end;
      {$IFNDEF IFPS3_NOINT64}bts64:
        for i := 0 to Len -1 do
        begin
          tbts64(Dest^) := tbts64(Src^);
          Dest := Pointer(IPointer(Dest) + 8);
          Src := Pointer(IPointer(Src) + 8);
        end;{$ENDIF}
      btExtended:
        for i := 0 to Len -1 do
        begin
          tbtExtended(Dest^) := tbtExtended(Src^);
          Dest := Pointer(IPointer(Dest) + SizeOf(Extended));
          Src := Pointer(IPointer(Src) + SizeOf(Extended));
        end;
      btCurrency:
        for i := 0 to Len -1 do
        begin
          tbtCurrency(Dest^) := tbtCurrency(Src^);
          Dest := Pointer(IPointer(Dest) + SizeOf(Currency));
          Src := Pointer(IPointer(Src) + SizeOf(Currency));
        end;
      btVariant:
        for i := 0 to Len -1 do
        begin
          variant(Dest^) := variant(Src^);
          Dest := Pointer(IPointer(Dest) + Sizeof(Variant));
          Src := Pointer(IPointer(Src) + Sizeof(Variant));
        end;
      btString:
        for i := 0 to Len -1 do
        begin
          tbtString(Dest^) := tbtString(Src^);
          Dest := Pointer(IPointer(Dest) + 4);
          Src := Pointer(IPointer(Src) + 4);
        end;
      {$IFNDEF IFPS3_NOWIDESTRING}btWideString:
        for i := 0 to Len -1 do
        begin
          tbtWideString(Dest^) := tbtWideString(Src^);
          Dest := Pointer(IPointer(Dest) + 4);
          Src := Pointer(IPointer(Src) + 4);
        end;                      {$ENDIF}
      btStaticArray:
        begin
          elSize := aType.RealSize;
          for i := 0 to Len -1 do
          begin
            if not CopyArrayContents(Dest, Src, TIFTypeRec_StaticArray(aType).Size, TIFTypeRec_StaticArray(aType).ArrayType) then
            begin
              result := false;
              exit;
            end;
            Dest := Pointer(IPointer(Dest) + elsize);
            Src := Pointer(IPointer(Src) + elsize);
          end;
        end;
      btArray:
        begin
          for i := 0 to Len -1 do
          begin
            Pointer(Dest^) := Pointer(Src^);
            if Pointer(Dest^) <> nil then
            begin
              Inc(Longint(Pointer(IPointer(Dest^)-8)^)); // RefCount
            end; 
            Dest := Pointer(IPointer(Dest) + 4);
            Src := Pointer(IPointer(Src) + 4);
          end;
        end;
      btRecord:
        begin
          elSize := aType.RealSize;
          for i := 0 to Len -1 do
          begin
            if not CopyRecordContents(Dest, Src, TIFTypeRec_Record(aType)) then
            begin
              result := false;
              exit;
            end;
            Dest := Pointer(IPointer(Dest) + elsize);
            Src := Pointer(IPointer(Src) + elsize);
          end;
        end;
      btSet:
        begin
          elSize := aType.RealSize;
          for i := 0 to Len -1 do
          begin
            Move(Src^, Dest^, elSize);
            Dest := Pointer(IPointer(Dest) + elsize);
            Src := Pointer(IPointer(Src) + elsize);
          end;
        end;
{$IFNDEF IFPS3_NOINTERFACES}
      btInterface:
        begin
          for i := 0 to Len -1 do
          begin
            {$IFNDEF IFPS3_D3PLUS}
            if IUnknown(Dest^) <> nil then
            begin
              IUnknown(Dest^).Release;
              IUnknown(Dest^) := nil;
            end;
            {$ENDIF}
            IUnknown(Dest^) := IUnknown(Src^);
            {$IFNDEF IFPS3_D3PLUS}
            if IUnknown(Dest^) <> nil then
              IUnknown(Dest^).AddRef;
            {$ENDIF}
            Dest := Pointer(IPointer(Dest) + 4);
            Src := Pointer(IPointer(Src) + 4);
          end;
        end;
{$ENDIF}        
      btPointer:
        begin
          if (Pointer(Pointer(IPointer(Dest)+8)^) = nil) and (Pointer(Pointer(IPointer(Src)+8)^) = nil) then
          begin
            for i := 0 to Len -1 do
            begin
              Pointer(Dest^) := Pointer(Src^);
              Dest := Pointer(IPointer(Dest) + 4);
              Src := Pointer(IPointer(Src) + 4);
              Pointer(Dest^) := Pointer(Src^);
              Dest := Pointer(IPointer(Dest) + 4);
              Src := Pointer(IPointer(Src) + 4);
              Pointer(Dest^) := nil;
              Dest := Pointer(IPointer(Dest) + 4);
              Src := Pointer(IPointer(Src) + 4);
            end;
          end else begin
            for i := 0 to Len -1 do
            begin
              if Pointer(Pointer(IPointer(Dest)+8)^) <> nil then
                DestroyHeapVariant2(Pointer(Dest^), Pointer(Pointer(IPointer(Dest)+4)^));
              if Pointer(Src^) <> nil then
              begin
                if Pointer(Pointer(IPointer(Src) + 8)^) = nil then
                begin
                  Pointer(Dest^) := Pointer(Src^);
                  Pointer(Pointer(IPointer(Dest) + 4)^) := Pointer(Pointer(IPointer(Src) + 4)^);
                  Pointer(Pointer(IPointer(Dest) + 8)^) := Pointer(Pointer(IPointer(Src) + 8)^);
                end else
                begin
                  Pointer(Dest^) := CreateHeapVariant2(Pointer(Pointer(IPointer(Src) + 4)^));
                  Pointer(Pointer(IPointer(Dest) + 4)^) := Pointer(Pointer(IPointer(Src) + 4)^);
                  Pointer(Pointer(IPointer(Dest) + 8)^) := Pointer(1);
                  if not CopyArrayContents(Pointer(Dest^), Pointer(Src^), 1, Pointer(Pointer(IPointer(Dest) + 4)^)) then
                  begin
                    Result := false;
                    exit;
                  end;
                end;
              end else
              begin
                Pointer(Dest^) := nil;
                Pointer(Pointer(IPointer(Dest) + 4)^) := nil;
                Pointer(Pointer(IPointer(Dest) + 8)^) := nil;
              end;
              Dest := Pointer(IPointer(Dest) + 12);
              Src := Pointer(IPointer(Src) + 12);
            end;
          end;
        end;
//      btResourcePointer = 15;
//      btVariant = 16;
    else
      Result := False;
      exit;
    end;
  except
    Result := False;
    exit;
  end;
  Result := true;
end;

function  GetIFPSArrayLength(Arr: PIFVariant): Longint;
begin
  result := IFPSDynArrayGetLength(PIFPSVariantDynamicArray(arr).Data, arr.FType);
end;

procedure SetIFPSArrayLength(Arr: PIFVariant; NewLength: Longint);
begin
  IFPSDynArraySetLength(PIFPSVariantDynamicArray(arr).Data, arr.FType, NewLength);
end;


function IFPSDynArrayGetLength(arr: Pointer; aType: TIFTypeRec): Longint;
begin
  if aType.BaseType <> btArray then raise Exception.Create('Invalid array');
  if arr = nil then Result := 0 else Result := Longint(Pointer(IPointer(arr)-4)^);
end;

procedure IFPSDynArraySetLength(var arr: Pointer; aType: TIfTypeRec; NewLength: Longint);
var
  elSize, i, OldLen: Longint;
  p: Pointer;
begin
  if aType.BaseType <> btArray then raise Exception.Create('Invalid array');
  OldLen := IFPSDynArrayGetLength(arr, aType);
  elSize := TIFTypeRec_Array(aType).ArrayType.RealSize;
  if (OldLen = 0) and (NewLength = 0) then exit; // already are both 0
  if (OldLen <> 0) and (Longint(Pointer(IPointer(Arr)-8)^) = 1) then // unique copy of this dynamic array
  begin
    for i := NewLength to OldLen -1 do
    begin
      if TIFTypeRec_Array(aType).ArrayType.BaseType in NeedFinalization then
        FinalizeVariant(Pointer(IPointer(arr) + Cardinal(elsize * i)), TIFTypeRec_Array(aType).ArrayType);
    end;
    arr := Pointer(IPointer(Arr)-8);
    if NewLength <= 0 then
    begin
      FreeMem(arr, NewLength * elsize + 8);
      arr := nil;
      exit;
    end;
    ReallocMem(arr, NewLength * elSize + 8);
    arr := Pointer(IPointer(Arr)+4);
    Longint(Arr^) := NewLength;
    arr := Pointer(IPointer(Arr)+4);
    for i := OldLen to NewLength -1 do
    begin
      InitializeVariant(Pointer(IPointer(arr) + Cardinal(elsize * i)), TIFTypeRec_Array(aType).ArrayType);
    end;
  end else
  begin
    if NewLength = 0 then
    begin
      if Longint(Pointer(IPointer(Arr)-8)^) = 1 then
        FreeMem(Pointer(IPointer(Arr)-8), OldLen * elSize + 8)
      else if Longint(Pointer(IPointer(Arr)-8)^) > 0 then
        Dec(Longint(Pointer(IPointer(Arr)-8)^));
      arr := nil;
      exit;
    end;
    GetMem(p, NewLength * elSize + 8);
    Longint(p^) := 1;
    p:= Pointer(IPointer(p)+4);
    Longint(p^) := NewLength;
    p := Pointer(IPointer(p)+4);
    if OldLen <> 0 then
    begin
      if OldLen > NewLength then
        CopyArrayContents(p, arr, NewLength, TIFTypeRec_Array(aType).ArrayType)
      else
        CopyArrayContents(p, arr, OldLen, TIFTypeRec_Array(aType).ArrayType);
      FinalizeVariant(@arr, aType);
    end;
    arr := p;
    for i := OldLen to NewLength -1 do
    begin
      InitializeVariant(Pointer(IPointer(arr) + Cardinal(elsize * i)), TIFTypeRec_Array(aType).ArrayType);
    end;
  end;
end;


function TIFPSExec.SetVariantValue(dest, Src: Pointer; desttype, srctype: TIFTypeRec): Boolean;
var
  Tmp: TObject;
  tt: TIFPSVariantPointer;
begin
  Result := True;
  try
    case desttype.BaseType of
      btSet:
        begin
          if desttype = srctype then
            Move(Src^, Dest^, TIFTypeRec_Set(desttype).aByteSize)
          else
            Result := False;
        end;
      btU8: tbtu8(Dest^) := IFPSGetUInt(Src, srctype);
      btS8: tbts8(Dest^) := IFPSGetInt(Src, srctype);
      btU16: tbtu16(Dest^) := IFPSGetUInt(Src, srctype);
      btS16: tbts16(Dest^) := IFPSGetInt(Src, srctype);
      btU32,
      btProcPtr:
        begin
          if srctype.BaseType = btPointer then
          begin
            srctype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
            Src := Pointer(Src^);
            if (src = nil) or (srctype = nil) then raise Exception.Create('Type Mismatch');
          end;
          case srctype.BaseType of
            btU8: tbtu32(Dest^) := tbtu8(src^);
            btS8: tbtu32(Dest^) := tbts8(src^);
            btU16: tbtu32(Dest^) := tbtu16(src^);
            btS16: tbtu32(Dest^) := tbts16(src^);
            btProcPtr, btU32: tbtu32(Dest^) := tbtu32(src^);
            btS32: tbtu32(Dest^) := tbts32(src^);
        {$IFNDEF IFPS3_NOINT64} btS64: tbtu32(Dest^) := tbts64(src^);{$ENDIF}
            btChar: tbtu32(Dest^) := Ord(tbtchar(Src^));
        {$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: tbtu32(Dest^) := Ord(tbtwidechar(Src^));{$ENDIF}
            btVariant: tbtu32(Dest^) := Variant(src^);
            else raise Exception.Create('Type Mismatch');
          end;
        end;
      btS32:
        begin
          if srctype.BaseType = btPointer then
          begin
            srctype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
            Src := Pointer(Src^);
            if (src = nil) or (srctype = nil) then raise Exception.Create('Type Mismatch');
          end;
          case srctype.BaseType of
            btU8: tbts32(Dest^) := tbtu8(src^);
            btS8: tbts32(Dest^) := tbts8(src^);
            btU16: tbts32(Dest^) := tbtu16(src^);
            btS16: tbts32(Dest^) := tbts16(src^);
            btProcPtr, btU32: tbts32(Dest^) := tbtu32(src^);
            btS32: tbts32(Dest^) := tbts32(src^);
        {$IFNDEF IFPS3_NOINT64} btS64: tbts32(Dest^) := tbts64(src^);{$ENDIF}
            btChar: tbts32(Dest^) := Ord(tbtchar(Src^));
        {$IFNDEF IFPS3_NOWIDESTRING}  btWideChar: tbts32(Dest^) := Ord(tbtwidechar(Src^));{$ENDIF}
            btVariant: tbts32(Dest^) := Variant(src^);
            else raise Exception.Create('Type Mismatch');
          end;
        end;
      {$IFNDEF IFPS3_NOINT64}
      btS64: tbts64(Dest^) := IFPSGetInt64(Src, srctype);
      {$ENDIF}
      btSingle:
        begin
          if srctype.BaseType = btPointer then
          begin
            srctype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
            Src := Pointer(Src^);
            if (src = nil) or (srctype = nil) then raise Exception.Create('Type Mismatch');
          end;
          case srctype.BaseType of
            btU8: tbtsingle(Dest^) := tbtu8(src^);
            btS8: tbtsingle(Dest^) := tbts8(src^);
            btU16: tbtsingle(Dest^) := tbtu16(src^);
            btS16: tbtsingle(Dest^) := tbts16(src^);
            btProcPtr, btU32: tbtsingle(Dest^) := tbtu32(src^);
            btS32: tbtsingle(Dest^) := tbts32(src^);
        {$IFNDEF IFPS3_NOINT64}    btS64: tbtsingle(Dest^) := tbts64(src^);{$ENDIF}
            btSingle: tbtsingle(Dest^) := tbtsingle(Src^);
            btDouble: tbtsingle(Dest^) := tbtdouble(Src^);
            btExtended: tbtsingle(Dest^) := tbtextended(Src^);
            btCurrency: tbtsingle(Dest^) := tbtcurrency(Src^);
            btVariant:  tbtsingle(Dest^) := Variant(src^);
            else raise Exception.Create('Type Mismatch');
          end;
        end;
      btDouble:
        begin
          if srctype.BaseType = btPointer then
          begin
            srctype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
            Src := Pointer(Src^);
            if (src = nil) or (srctype = nil) then raise Exception.Create('Type Mismatch');
          end;
          case srctype.BaseType of
            btU8: tbtdouble(Dest^) := tbtu8(src^);
            btS8: tbtdouble(Dest^) := tbts8(src^);
            btU16: tbtdouble(Dest^) := tbtu16(src^);
            btS16: tbtdouble(Dest^) := tbts16(src^);
            btProcPtr, btU32: tbtdouble(Dest^) := tbtu32(src^);
            btS32: tbtdouble(Dest^) := tbts32(src^);
        {$IFNDEF IFPS3_NOINT64}    btS64: tbtdouble(Dest^) := tbts64(src^);{$ENDIF}
            btSingle: tbtdouble(Dest^) := tbtsingle(Src^);
            btDouble: tbtdouble(Dest^) := tbtdouble(Src^);
            btExtended: tbtdouble(Dest^) := tbtextended(Src^);
            btCurrency: tbtdouble(Dest^) := tbtcurrency(Src^);
            btVariant:  tbtdouble(Dest^) := Variant(src^);
            else raise Exception.Create('Type Mismatch');
          end;

        end;
      btExtended:
        begin
          if srctype.BaseType = btPointer then
          begin
            srctype := PIFTypeRec(Pointer(IPointer(Src)+4)^);
            Src := Pointer(Src^);
            if (src = nil) or (srctype = nil) then raise Exception.Create('Type Mismatch');
          end;
          case srctype.BaseType of
            btU8: tbtextended(Dest^) := tbtu8(src^);
            btS8: tbtextended(Dest^) := tbts8(src^);
            btU16: tbtextended(Dest^) := tbtu16(src^);
            btS16: tbtextended(Dest^) := tbts16(src^);
            btProcPtr, btU32: tbtextended(Dest^) := tbtu32(src^);
            btS32: tbtextended(Dest^) := tbts32(src^);
        {$IFNDEF IFPS3_NOINT64}    btS64: tbtextended(Dest^) := tbts64(src^);{$ENDIF}
            btSingle: tbtextended(Dest^) := tbtsingle(Src^);
            btDouble: tbtextended(Dest^) := tbtdouble(Src^);
            btExtended: tbtextended(Dest^) := tbtextended(Src^);
            btCurrency: tbtextended(Dest^) := tbtcurrency(Src^);
            btVariant:  tbtextended(Dest^) := Variant(src^);
            else raise Exception.Create('Type Mismatch');
          end;
        end;
      btCurrency: tbtcurrency(Dest^) := IFPSGetCurrency(Src, srctype);
      btPChar: pchar(dest^) := pchar(IFPSGetString(Src, srctype));
      btString:
        tbtstring(dest^) := IFPSGetString(Src, srctype);
      btChar: tbtchar(dest^) := chr(IFPSGetUInt(Src, srctype));
      {$IFNDEF IFPS3_NOWIDESTRING}
      btWideString: tbtwidestring(dest^) := IFPSGetWideString(Src, srctype);
      btWideChar: tbtwidechar(dest^) := widechar(IFPSGetUInt(Src, srctype));
      {$ENDIF}
      btStaticArray:
        begin
          if desttype <> srctype then
            Result := False
          else
            CopyArrayContents(dest, Src, TIFTypeRec_StaticArray(desttype).Size, TIFTypeRec_StaticArray(desttype).ArrayType);
        end;
      btArray:
        begin
          if (srctype.BaseType = btStaticArray) and (TIFTypeRec_Array(desttype).ArrayType = TIFTypeRec_Array(srctype).ArrayType) then
          begin
            IFPSDynArraySetLength(Pointer(Dest^), desttype, TIFTypeRec_StaticArray(srctype).Size);
            CopyArrayContents(Pointer(dest^), Src, TIFTypeRec_StaticArray(srctype).Size, TIFTypeRec_StaticArray(srctype).ArrayType);
          end else
          if desttype <> srctype then
            Result := False
          else
            CopyArrayContents(dest, src, 1, desttype);
        end;
      btRecord:
        begin
          if desttype <> srctype then
            Result := False
          else
            CopyArrayContents(dest, Src, 1, desttype);
        end;
      btVariant:
        begin
{$IFNDEF IFPS3_NOINTERFACES}
          if srctype.ExportName = 'IDISPATCH' then
          begin
            {$IFDEF IFPS3_D3PLUS}
            Variant(Dest^) := IDispatch(Src^);
            {$ELSE}
            Variant(Dest^) := VarFromInterface(IDispatch(Src^));
//            IDispatch(Dest^).AddRef;
            {$ENDIF}
          end else
{$ENDIF}
          if srctype.BaseType = btVariant then
            variant(Dest^) := variant(src^)
          else
          begin
            tt.VI.FType := FindType2(btPointer);
            tt.DestType := srctype;
            tt.DataDest := src;
            tt.FreeIt := False;
            Result := PIFVariantToVariant(@tt, variant(dest^));
          end;
        end;
      btClass:
        begin
          if srctype.BaseType = btClass then
            TObject(Dest^) := TObject(Src^)
          else
            Result := False;
        end;
{$IFNDEF IFPS3_NOINTERFACES}
      btInterface:
        begin
          if Srctype.BaseType = btVariant then
          begin
            if desttype.ExportName = 'IDISPATCH' then
            begin
              {$IFDEF IFPS3_D3PLUS}
              IDispatch(Dest^) := Variant(Src^);
              {$ELSE}
              IDispatch(Dest^) := VarToInterface(Variant(Src^));
              IDispatch(Dest^).AddRef;
              {$ENDIF}
            end else
              Result := False;
{$IFDEF IFPS3_D3PLUS}
          end else
          if srctype.BaseType = btClass then
          begin
            if (TObject(Src^) = nil) or not TObject(Src^).GetInterface(TIFTypeRec_Interface(desttype).Guid, IUnknown(Dest^)) then
            begin
              Result := false;
              Cmd_Err(eInterfaceNotSupported);
              exit;
            end;
{$ENDIF}
          end else if srctype.BaseType = btInterface then
          begin
            {$IFNDEF IFPS3_D3PLUS}
            if IUnknown(Dest^) <> nil then
            begin
              IUnknown(Dest^).Release;
              IUnknown(Dest^) := nil; 
            end;
            {$ENDIF}
            IUnknown(Dest^) := IUnknown(Src^);
            {$IFNDEF IFPS3_D3PLUS}
            if IUnknown(Dest^) <> nil then
              IUnknown(Dest^).AddRef;
            {$ENDIF}
          end else
            Result := False;
        end;
{$ENDIF}        
    else begin
        Result := False;
      end;
    end;
    if Result = False then
      CMD_Err(ErTypeMismatch);
  except
    {$IFDEF IFPS3_D6PLUS}
    Tmp := AcquireExceptionObject;
    {$ELSE}
    if RaiseList <> nil then
    begin
      Tmp := Exception(PRaiseFrame(RaiseList)^.ExceptObject);
      PRaiseFrame(RaiseList)^.ExceptObject := nil;
    end else
      Tmp := nil;
    {$ENDIF}
    if Tmp <> nil then
    begin
      if Tmp is EIFPS3Exception then
      begin
        Result := False;
        ExceptionProc(EIFPS3Exception(tmp).ProcNo, EIFPS3Exception(tmp).ProcPos, erCustomError, EIFPS3Exception(tmp).Message, nil);
        exit;
      end else
      if Tmp is EDivByZero then
      begin
        Result := False;
        CMD_Err3(erDivideByZero, '', Tmp);
        Exit;
      end;
      if Tmp is EZeroDivide then
      begin
        Result := False;
        CMD_Err3(erDivideByZero, '', Tmp);
        Exit;
      end;
      if Tmp is EMathError then
      begin
        Result := False;
        CMD_Err3(erMathError, '', Tmp);
        Exit;
      end;
    end;
    if (tmp <> nil) and (Tmp is Exception) then
      CMD_Err3(erException, Exception(Tmp).Message, Tmp)
    else
      CMD_Err3(erException, '', Tmp);
    Result := False;
  end;
end;

function SpecImport(Sender: TIFPSExec; p: TIFExternalProcRec; Tag: Pointer): Boolean; forward;


function Class_IS(Self: TIFPSExec; Obj: TObject; var2type: TIFTypeRec): Boolean;
var
  R: TIFPSRuntimeClassImporter;
  cc: TIFPSRuntimeClass;
begin
  if Obj = nil then
  begin
    Result := false;
    exit;
  end;
  r := Self.FindSpecialProcImport(SpecImport);
  if R = nil then
  begin
    Result := false;
    exit;
  end;
  cc := r.FindClass(var2type.ExportName);
  if cc = nil then
  begin
    result := false;
    exit;
  end;
  try
    Result := Obj is cc.FClass;
  except
    Result := false;
  end;
end;

function TIFPSExec.DoBooleanCalc(var1, Var2, into: Pointer; var1Type, var2type, intotype: TIFTypeRec; Cmd: Cardinal): Boolean;
var
  b: Boolean;
  Tmp: TObject;
  tvar: Variant;


  procedure SetBoolean(b: Boolean; var Ok: Boolean);
  begin
    Ok := True;
    case IntoType.BaseType of
      btU8: tbtu8(Into^):= Cardinal(b);
      btS8: tbts8(Into^) := Longint(b);
      btU16: tbtu16(Into^) := Cardinal(b);
      btS16: tbts16(Into^) := Longint(b);
      btU32: tbtu32(Into^) := Cardinal(b);
      btS32: tbts32(Into^) := Longint(b);
    else begin
        CMD_Err(ErTypeMismatch);
        Ok := False;
      end;
    end;
  end;
begin
  Result := true;
  try
    case Cmd of
      0: begin { >= }
          case var1Type.BaseType of
            btU8:
            if (var2Type.BaseType = btString) or (Var2Type.BaseType = btPChar) then
              b := char(tbtu8(var1^)) >= IFPSGetString(Var2, var2type)
            else
              b := tbtu8(var1^) >= IFPSGetUInt(Var2, var2type);
            btS8: b := tbts8(var1^) >= IFPSGetInt(Var2, var2type);
            btU16: b := tbtu16(var1^) >= IFPSGetUInt(Var2, var2type);
            btS16: b := tbts16(var1^) >= IFPSGetInt(Var2, var2type);
            btU32, btProcPtr: b := tbtu32(var1^) >= IFPSGetUInt(Var2, var2type);
            btS32:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: b := tbts32(var1^) >= tbtu8(Var2^);
                  btS8: b := tbts32(var1^) >= tbts8(Var2^);
                  btU16: b := tbts32(var1^) >= tbtu16(Var2^);
                  btS16: b := tbts32(var1^) >= tbts16(Var2^);
                  btProcPtr, btU32: b := tbts32(var1^) >= Longint(tbtu32(Var2^));
                  btS32: b := tbts32(var1^) >= tbts32(Var2^);
              {$IFNDEF IFPS3_NOINT64} btS64: b := tbts32(var1^) >= tbts64(Var2^);{$ENDIF}
                  btChar: b := tbts32(var1^) >= Ord(tbtchar(Var2^));
              {$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: b := tbts32(var1^) >= Ord(tbtwidechar(Var2^));{$ENDIF}
                  btVariant: b := tbts32(var1^) >= Variant(Var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btSingle: b := tbtsingle(var1^) >= IFPSGetReal(Var2, var2type);
            btDouble: b := tbtdouble(var1^) >= IFPSGetReal(Var2, var2type);
            btCurrency: b := tbtcurrency(var1^) >= IFPSGetReal(Var2, var2type);
            btExtended: b := tbtextended(var1^) >= IFPSGetReal(Var2, var2type);
            {$IFNDEF IFPS3_NOINT64}                  
            btS64: b := tbts64(var1^) >= IFPSGetInt64(Var2, var2type);
            {$ENDIF}
            btPChar,btString: b := tbtstring(var1^) >= IFPSGetString(Var2, var2type);
            btChar: b := tbtchar(var1^) >= IFPSGetString(Var2, var2type);
            {$IFNDEF IFPS3_NOWIDESTRING}
            btWideChar: b := tbtwidechar(var1^) >= IFPSGetWideString(Var2, var2type);
            btWideString: b := tbtwidestring(var1^) >= IFPSGetWideString(Var2, var2type);
            {$ENDIF}
            btVariant:
              begin
                if not IntPIFVariantToVariant(var2, var2type, tvar) then
                begin
                  Result := false;
                end else
                  b := Variant(var1^) >= tvar;
              end;
            btSet:
              begin
                if var1Type = var2Type then
                begin
                  Set_Subset(var2, var1, TIFTypeRec_Set(var1Type).aByteSize, b);
                end else result := False;
              end;
          else begin
              CMD_Err(ErTypeMismatch);
              exit;
            end;
          end;
          if not Result then begin
            CMD_Err(ErTypeMismatch);
            exit;
          end;
          SetBoolean(b, Result);
        end;
      1: begin { <= }
          case var1Type.BaseType of
            btU8:
            if (var2Type.BaseType = btString) or (Var2Type.BaseType = btPChar) then
              b := char(tbtu8(var1^)) <= IFPSGetString(Var2, var2type)
            else
              b := tbtu8(var1^) <= IFPSGetUInt(Var2, var2type);
            btS8: b := tbts8(var1^) <= IFPSGetInt(Var2, var2type);
            btU16: b := tbtu16(var1^) <= IFPSGetUInt(Var2, var2type);
            btS16: b := tbts16(var1^) <= IFPSGetInt(Var2, var2type);
            btU32, btProcPtr: b := tbtu32(var1^) <= IFPSGetUInt(Var2, var2type);
            btS32:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: b := tbts32(var1^) <= tbtu8(Var2^);
                  btS8: b := tbts32(var1^) <= tbts8(Var2^);
                  btU16: b := tbts32(var1^) <= tbtu16(Var2^);
                  btS16: b := tbts32(var1^) <= tbts16(Var2^);
                  btProcPtr, btU32: b := tbts32(var1^) <= Longint(tbtu32(Var2^));
                  btS32: b := tbts32(var1^) <= tbts32(Var2^);
              {$IFNDEF IFPS3_NOINT64} btS64: b := tbts32(var1^) <= tbts64(Var2^);{$ENDIF}
                  btChar: b := tbts32(var1^) <= Ord(tbtchar(Var2^));
              {$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: b := tbts32(var1^) <= Ord(tbtwidechar(Var2^));{$ENDIF}
                  btVariant: b := tbts32(var1^) <= Variant(Var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;            btSingle: b := tbtsingle(var1^) <= IFPSGetReal(Var2, var2type);
            btCurrency: b := tbtcurrency(var1^) <= IFPSGetReal(Var2, var2type);
            btDouble: b := tbtdouble(var1^) <= IFPSGetReal(Var2, var2type);
            btExtended: b := tbtextended(var1^) <= IFPSGetReal(Var2, var2type);
            {$IFNDEF IFPS3_NOINT64}
            btS64: b := tbts64(var1^) <= IFPSGetInt64(Var2, var2type);
            {$ENDIF}
            btPChar,btString: b := tbtstring(var1^) <= IFPSGetString(Var2, var2type);
            btChar: b := tbtchar(var1^) <= IFPSGetString(Var2, var2type);
            {$IFNDEF IFPS3_NOWIDESTRING}
            btWideChar: b := tbtwidechar(var1^) <= IFPSGetWideString(Var2, var2type);
            btWideString: b := tbtwidestring(var1^) <= IFPSGetWideString(Var2, var2type);
            {$ENDIF}
            btVariant:
              begin
                if not IntPIFVariantToVariant(var2, var2type, tvar) then
                begin
                  Result := false;
                end else
                  b := Variant(var1^) <= tvar;
              end;
            btSet:
              begin
                if var1Type = var2Type then
                begin
                  Set_Subset(var1, var2, TIFTypeRec_Set(var1Type).aByteSize, b);
                end else result := False;
              end;
          else begin
              CMD_Err(ErTypeMismatch);
              exit;
            end;
          end;
          if not Result then begin
            CMD_Err(erTypeMismatch);
            exit;
          end;
          SetBoolean(b, Result);
        end;
      2: begin { > }
          case var1Type.BaseType of
            btU8:
            if (var2Type.BaseType = btString) or (Var2Type.BaseType = btPChar) then
              b := char(tbtu8(var1^)) > IFPSGetString(Var2, var2type)
            else
              b := tbtu8(var1^) > IFPSGetUInt(Var2, var2type);
            btS8: b := tbts8(var1^) > IFPSGetInt(Var2, var2type);
            btU16: b := tbtu16(var1^) > IFPSGetUInt(Var2, var2type);
            btS16: b := tbts16(var1^) > IFPSGetInt(Var2, var2type);
            btU32, btProcPtr: b := tbtu32(var1^) > IFPSGetUInt(Var2, var2type);
            btS32:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: b := tbts32(var1^) > tbtu8(Var2^);
                  btS8: b := tbts32(var1^) > tbts8(Var2^);
                  btU16: b := tbts32(var1^) > tbtu16(Var2^);
                  btS16: b := tbts32(var1^) > tbts16(Var2^);
                  btProcPtr, btU32: b := tbts32(var1^) > Longint(tbtu32(Var2^));
                  btS32: b := tbts32(var1^) > tbts32(Var2^);
              {$IFNDEF IFPS3_NOINT64} btS64: b := tbts32(var1^) > tbts64(Var2^);{$ENDIF}
                  btChar: b := tbts32(var1^) > Ord(tbtchar(Var2^));
              {$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: b := tbts32(var1^) = Ord(tbtwidechar(Var2^));{$ENDIF}
                  btVariant: b := tbts32(var1^) > Variant(Var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;            btSingle: b := tbtsingle(var1^) > IFPSGetReal(Var2, var2type);
            btDouble: b := tbtdouble(var1^) > IFPSGetReal(Var2, var2type);
            btExtended: b := tbtextended(var1^) > IFPSGetReal(Var2, var2type);
            btCurrency: b := tbtcurrency(var1^) > IFPSGetReal(Var2, var2type);
            {$IFNDEF IFPS3_NOINT64}
            btS64: b := tbts64(var1^) > IFPSGetInt64(Var2, var2type);
            {$ENDIF}
            btPChar,btString: b := tbtstring(var1^) > IFPSGetString(Var2, var2type);
            btChar: b := tbtchar(var1^) > IFPSGetString(Var2, var2type);
            {$IFNDEF IFPS3_NOWIDESTRING}
            btWideChar: b := tbtwidechar(var1^) > IFPSGetWideString(Var2, var2type);
            btWideString: b := tbtwidestring(var1^) > IFPSGetWideString(Var2, var2type);
            {$ENDIF}
            btVariant:
              begin
                if not IntPIFVariantToVariant(var2, var2type, tvar) then
                begin
                  Result := false;
                end else
                  b := Variant(var1^) > tvar;
              end;
          else begin
              CMD_Err(erTypeMismatch);
              exit;
            end;
          end;
          if not Result then begin
            CMD_Err(erTypeMismatch);
            exit;
          end;
          SetBoolean(b, Result);
        end;
      3: begin { < }
          case var1Type.BaseType of
            btU8:
            if (var2Type.BaseType = btString) or (Var2Type.BaseType = btPChar) then
              b := char(tbtu8(var1^)) < IFPSGetString(Var2, var2type)
            else
              b := tbtu8(var1^) < IFPSGetUInt(Var2, var2type);
            btS8: b := tbts8(var1^) < IFPSGetInt(Var2, var2type);
            btU16: b := tbtu16(var1^) < IFPSGetUInt(Var2, var2type);
            btS16: b := tbts16(var1^) < IFPSGetInt(Var2, var2type);
            btU32, btProcPtr: b := tbtu32(var1^) < IFPSGetUInt(Var2, var2type);
            btS32:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: b := tbts32(var1^) < tbtu8(Var2^);
                  btS8: b := tbts32(var1^) < tbts8(Var2^);
                  btU16: b := tbts32(var1^) < tbtu16(Var2^);
                  btS16: b := tbts32(var1^) < tbts16(Var2^);
                  btProcPtr, btU32: b := tbts32(var1^) < Longint(tbtu32(Var2^));
                  btS32: b := tbts32(var1^) < tbts32(Var2^);
              {$IFNDEF IFPS3_NOINT64} btS64: b := tbts32(var1^) < tbts64(Var2^);{$ENDIF}
                  btChar: b := tbts32(var1^) < Ord(tbtchar(Var2^));
              {$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: b := tbts32(var1^) < Ord(tbtwidechar(Var2^));{$ENDIF}
                  btVariant: b := tbts32(var1^) < Variant(Var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;            btSingle: b := tbtsingle(var1^) < IFPSGetReal(Var2, var2type);
            btDouble: b := tbtdouble(var1^) < IFPSGetReal(Var2, var2type);
            btCurrency: b := tbtcurrency(var1^) < IFPSGetReal(Var2, var2type);
            btExtended: b := tbtextended(var1^) < IFPSGetReal(Var2, var2type);
            {$IFNDEF IFPS3_NOINT64}
            btS64: b := tbts64(var1^) < IFPSGetInt64(Var2, var2type);
            {$ENDIF}
            btPChar,btString: b := tbtstring(var1^) < IFPSGetString(Var2, var2type);
            btChar: b := tbtchar(var1^) < IFPSGetString(Var2, var2type);
            {$IFNDEF IFPS3_NOWIDESTRING}
            btWideChar: b := tbtwidechar(var1^) < IFPSGetWideString(Var2, var2type);
            btWideString: b := tbtwidestring(var1^) < IFPSGetWideString(Var2, var2type);
            {$ENDIF}
            btVariant:
              begin
                if not IntPIFVariantToVariant(var2, var2type, tvar) then
                begin
                  Result := false;
                end else
                  b := Variant(var1^) < tvar;
              end;
          else begin
              CMD_Err(erTypeMismatch);
              exit;
            end;
          end;
          if not Result then begin
            CMD_Err(erTypeMismatch);
            exit;
          end;
          SetBoolean(b, Result);
        end;
      4: begin { <> }
          case var1Type.BaseType of
            btInterface:
              begin
                if var2Type.BaseType = btInterface then
                  b := Pointer(var1^) <> Pointer(var2^) // no need to cast it to IUnknown
                else
                  Result := false;
              end;
            btClass:
              begin
                if var2Type.BaseType = btclass then
                  b := TObject(var1^) <> TObject(var2^)
                else
                  Result := false;
              end;
            btU8:
            if (var2Type.BaseType = btString) or (Var2Type.BaseType = btPChar) then
              b := char(tbtu8(var1^)) <> IFPSGetString(Var2, var2type)
            else
              b := tbtu8(var1^) <> IFPSGetUInt(Var2, var2type);
            btS8: b := tbts8(var1^) <> IFPSGetInt(Var2, var2type);
            btU16: b := tbtu16(var1^) <> IFPSGetUInt(Var2, var2type);
            btS16: b := tbts16(var1^) <> IFPSGetInt(Var2, var2type);
            btU32, btProcPtr: b := tbtu32(var1^) <> IFPSGetUInt(Var2, var2type);
            btS32:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: b := tbts32(var1^) <> tbtu8(Var2^);
                  btS8: b := tbts32(var1^) <> tbts8(Var2^);
                  btU16: b := tbts32(var1^) <> tbtu16(Var2^);
                  btS16: b := tbts32(var1^) <> tbts16(Var2^);
                  btProcPtr, btU32: b := tbts32(var1^)<> Longint(tbtu32(Var2^));
                  btS32: b := tbts32(var1^) <> tbts32(Var2^);
              {$IFNDEF IFPS3_NOINT64} btS64: b := tbts32(var1^) <> tbts64(Var2^);{$ENDIF}
                  btChar: b := tbts32(var1^) <> Ord(tbtchar(Var2^));
              {$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: b := tbts32(var1^) <> Ord(tbtwidechar(Var2^));{$ENDIF}
                  btVariant: b := tbts32(var1^) <> Variant(Var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;            btSingle: b := tbtsingle(var1^) <> IFPSGetReal(Var2, var2type);
            btDouble: b := tbtdouble(var1^) <> IFPSGetReal(Var2, var2type);
            btExtended: b := tbtextended(var1^) <> IFPSGetReal(Var2, var2type);
            btCurrency: b := tbtcurrency(var1^) <> IFPSGetReal(Var2, var2type);
            btPChar,btString: b := tbtstring(var1^) <> IFPSGetString(Var2, var2type);
            {$IFNDEF IFPS3_NOINT64}
            btS64: b := tbts64(var1^) <> IFPSGetInt64(Var2, var2type);
            {$ENDIF}
            btChar: b := tbtchar(var1^) <> IFPSGetString(Var2, var2type);
            {$IFNDEF IFPS3_NOWIDESTRING}
            btWideChar: b := tbtwidechar(var1^) <> IFPSGetWideString(Var2, var2type);
            btWideString: b := tbtwidestring(var1^) <> IFPSGetWideString(Var2, var2type);
            {$ENDIF}
            btVariant:
              begin
                if not IntPIFVariantToVariant(var2, var2type, tvar) then
                begin
                  Result := false;
                end else
                  b := Variant(var1^) <> tvar;
              end;
            btSet:
              begin
                if var1Type = var2Type then
                begin
                  Set_Equal(var1, var2, TIFTypeRec_Set(var1Type).aByteSize, b);
                  b := not b;
                end else result := False;
              end;
          else begin
              CMD_Err(erTypeMismatch);
              exit;
            end;
          end;
          if not Result then begin
            CMD_Err(erTypeMismatch);
            exit;
          end;
          SetBoolean(b, Result);
        end;
      5: begin { = }
          case var1Type.BaseType of
            btInterface:
              begin
                if var2Type.BaseType = btInterface then
                  b := Pointer(var1^) = Pointer(var2^) // no need to cast it to IUnknown
                else
                  Result := false;
              end;
            btClass:
              begin
                if var2Type.BaseType = btclass then
                  b := TObject(var1^) = TObject(var2^)
                else
                  Result := false;
              end;
            btU8:
            if (var2Type.BaseType = btString) or (Var2Type.BaseType = btPChar) then
              b := char(tbtu8(var1^)) = IFPSGetString(Var2, var2type)
            else
              b := tbtu8(var1^) = IFPSGetUInt(Var2, var2type);
            btS8: b := tbts8(var1^) = IFPSGetInt(Var2, var2type);
            btU16: b := tbtu16(var1^) = IFPSGetUInt(Var2, var2type);
            btS16: b := tbts16(var1^) = IFPSGetInt(Var2, var2type);
            btU32, btProcPtr: b := tbtu32(var1^) = IFPSGetUInt(Var2, var2type);
            btS32:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: b := tbts32(var1^) = tbtu8(Var2^);
                  btS8: b := tbts32(var1^) = tbts8(Var2^);
                  btU16: b := tbts32(var1^) = tbtu16(Var2^);
                  btS16: b := tbts32(var1^) = tbts16(Var2^);
                  btProcPtr, btU32: b := tbts32(var1^) = Longint(tbtu32(Var2^));
                  btS32: b := tbts32(var1^) = tbts32(Var2^);
              {$IFNDEF IFPS3_NOINT64} btS64: b := tbts32(var1^) = tbts64(Var2^);{$ENDIF}
                  btChar: b := tbts32(var1^) = Ord(tbtchar(Var2^));
              {$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: b := tbts32(var1^) = Ord(tbtwidechar(Var2^));{$ENDIF}
                  btVariant: b := tbts32(var1^) = Variant(Var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;            btSingle: b := tbtsingle(var1^) = IFPSGetReal(Var2, var2type);
            btDouble: b := tbtdouble(var1^) = IFPSGetReal(Var2, var2type);
            btExtended: b := tbtextended(var1^) = IFPSGetReal(Var2, var2type);
            btCurrency: b := tbtcurrency(var1^) = IFPSGetReal(Var2, var2type);
            btPchar, btString: b := tbtstring(var1^) = IFPSGetString(Var2, var2type);
            {$IFNDEF IFPS3_NOINT64}
            btS64: b := tbts64(var1^) = IFPSGetInt64(Var2, var2type);
            {$ENDIF}
            btChar: b := tbtchar(var1^) = IFPSGetString(Var2, var2type);
            {$IFNDEF IFPS3_NOWIDESTRING}
            btWideChar: b := tbtwidechar(var1^) = IFPSGetWideString(Var2, var2type);
            btWideString: b := tbtwidestring(var1^) = IFPSGetWideString(Var2, var2type);
            {$ENDIF}
            btVariant:
              begin
                if not IntPIFVariantToVariant(var2, var2type, tvar) then
                begin
                  Result := false;
                end else
                  b := Variant(var1^) = tvar;
              end;
            btSet:
              begin
                if var1Type = var2Type then
                begin
                  Set_Equal(var1, var2, TIFTypeRec_Set(var1Type).aByteSize, b);
                end else result := False;
              end;
          else begin
              CMD_Err(erTypeMismatch);
              exit;
            end;
          end;
          if not Result then begin
            CMD_Err(erTypeMismatch);
            exit;
          end;
          SetBoolean(b, Result);
        end;
      6: begin { in }
          if var2Type.BaseType = btSet then
          begin
            Cmd := IFPSGetUInt(var1, var1type);
            if not Result then
            begin
              CMD_Err(erTypeMismatch);
              exit;
            end;
            if Cmd >= Cardinal(TIFTypeRec_Set(var2Type).aBitSize) then
            begin
              cmd_Err(erOutofRecordRange);
              Result := False;
              Exit;
            end;
            Set_membership(Cmd, var2, b);
            SetBoolean(b, Result);
          end else
          begin
            CMD_Err(erTypeMismatch);
            exit;
          end;
        end;
      7:
        begin // is
          case var1Type.BaseType of
            btClass:
              begin
                if var2type.BaseType <> btU32 then
                  Result := False
                else
                begin
                  var2type := FTypes[tbtu32(var2^)];
                  if (var2type = nil) or (var2type.BaseType <> btClass) then
                    Result := false
                  else
                  begin
                    Setboolean(Class_IS(Self, TObject(var1^), var2type), Result);
                  end;
                end;
              end;
          else begin
              CMD_Err(erTypeMismatch);
              exit;
            end;
          end;
          if not Result then begin
            CMD_Err(erTypeMismatch);
            exit;
          end;
        end;
    else begin
        Result := False;
        CMD_Err(erInvalidOpcodeParameter);
        exit;
      end;
    end;
  except
    {$IFDEF IFPS3_D6PLUS}
    Tmp := AcquireExceptionObject;
    {$ELSE}
    if RaiseList <> nil then
    begin
      Tmp := Exception(PRaiseFrame(RaiseList)^.ExceptObject);
      PRaiseFrame(RaiseList)^.ExceptObject := nil;
    end else
      Tmp := nil;
    {$ENDIF}
    if Tmp <> nil then
    begin
      if Tmp is EIFPS3Exception then
      begin
        Result := False;
        ExceptionProc(EIFPS3Exception(tmp).ProcNo, EIFPS3Exception(tmp).ProcPos, erCustomError, EIFPS3Exception(tmp).Message, nil);
        exit;
      end else
      if Tmp is EDivByZero then
      begin
        Result := False;
        CMD_Err3(erDivideByZero, '', Tmp);
        Exit;
      end;
      if Tmp is EZeroDivide then
      begin
        Result := False;
        CMD_Err3(erDivideByZero, '', Tmp);
        Exit;
      end;
      if Tmp is EMathError then
      begin
        Result := False;
        CMD_Err3(erMathError, '', Tmp);
        Exit;
      end;
    end;
    if (tmp <> nil) and (Tmp is Exception) then
      CMD_Err3(erException, Exception(Tmp).Message, Tmp)
    else
      CMD_Err3(erException, '', Tmp);
    Result := False;
  end;
end;

function VarIsFloat(const V: Variant): Boolean;
begin
  Result := VarType(V) in [varSingle, varDouble, varCurrency];
end;

function TIFPSExec.DoCalc(var1, Var2: Pointer; var1Type, var2type: TIFTypeRec; CalcType: Cardinal): Boolean;
    { var1=dest, var2=src }
var
  Tmp: TObject;
  tvar: Variant;
begin
  try
    Result := True;
    case CalcType of
      0: begin { + }
          case var1Type.BaseType of
            btU8: tbtU8(var1^) := tbtU8(var1^) + IFPSGetUInt(Var2, var2type);
            btS8: tbts8(var1^) := tbts8(var1^) + IFPSGetInt(Var2, var2type);
            btU16: tbtU16(var1^) := tbtU16(var1^) + IFPSGetUInt(Var2, var2type);
            btS16: tbts16(var1^) := tbts16(var1^) + IFPSGetInt(Var2, var2type);
            btU32:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtU32(var1^) := tbtU32(var1^) + tbtu8(var2^);
                  btS8: tbtU32(var1^) := tbtU32(var1^) + cardinal(longint(tbts8(var2^)));
                  btU16: tbtU32(var1^) := tbtU32(var1^) + tbtu16(var2^);
                  btS16: tbtU32(var1^) := tbtU32(var1^) + cardinal(longint(tbts16(var2^)));
                  btProcPtr, btU32: tbtU32(var1^) := tbtU32(var1^) + tbtu32(var2^);
                  btS32: tbtU32(var1^) := tbtU32(var1^) + cardinal(tbts32(var2^));
              {$IFNDEF IFPS3_NOINT64} btS64: tbtU32(var1^) := tbtU32(var1^) + tbts64(var2^);{$ENDIF}
                  btChar: tbtU32(var1^) := tbtU32(var1^) +  Ord(tbtchar(var2^));
              {$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: tbtU32(var1^) := tbtU32(var1^) + Ord(tbtwidechar(var2^));{$ENDIF}
                  btVariant: tbtU32(var1^) := tbtU32(var1^) + Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btS32:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbts32(var1^) := tbts32(var1^) + tbtu8(var2^);
                  btS8: tbts32(var1^) := tbts32(var1^) + tbts8(var2^);
                  btU16: tbts32(var1^) := tbts32(var1^) + tbtu16(var2^);
                  btS16: tbts32(var1^) := tbts32(var1^) + tbts16(var2^);
                  btProcPtr, btU32: tbts32(var1^) := tbts32(var1^) + Longint(tbtu32(var2^));
                  btS32: tbts32(var1^) := tbts32(var1^) + tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64} btS64: tbts32(var1^) := tbts32(var1^) + tbts64(var2^);{$ENDIF}
                  btChar: tbts32(var1^) := tbts32(var1^) +  Ord(tbtchar(var2^));
              {$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: tbts32(var1^) := tbts32(var1^) + Ord(tbtwidechar(var2^));{$ENDIF}
                  btVariant: tbts32(var1^) := tbts32(var1^) + Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
           {$IFNDEF IFPS3_NOINT64}
            btS64:  tbts64(var1^) := tbts64(var1^) + IFPSGetInt64(var2, var2type);
           {$ENDIF}
            btSingle:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtsingle(var1^) := tbtsingle(var1^) + tbtu8(var2^);
                  btS8: tbtsingle(var1^) := tbtsingle(var1^) + tbts8(var2^);
                  btU16: tbtsingle(var1^) := tbtsingle(var1^) + tbtu16(var2^);
                  btS16: tbtsingle(var1^) := tbtsingle(var1^) + tbts16(var2^);
                  btProcPtr, btU32: tbtsingle(var1^) := tbtsingle(var1^) + tbtu32(var2^);
                  btS32: tbtsingle(var1^) := tbtsingle(var1^) + tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64}    btS64: tbtsingle(var1^) := tbtsingle(var1^) + tbts64(var2^);{$ENDIF}
                  btSingle: tbtsingle(var1^) := tbtsingle(var1^) + tbtsingle(var2^);
                  btDouble: tbtsingle(var1^) := tbtsingle(var1^) + tbtdouble(var2^);
                  btExtended: tbtsingle(var1^) := tbtsingle(var1^) + tbtextended(var2^);
                  btCurrency: tbtsingle(var1^) := tbtsingle(var1^) + tbtcurrency(var2^);
                  btVariant:  tbtsingle(var1^) := tbtsingle(var1^) +  Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btDouble:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtdouble(var1^) := tbtdouble(var1^) + tbtu8(var2^);
                  btS8: tbtdouble(var1^) := tbtdouble(var1^) + tbts8(var2^);
                  btU16: tbtdouble(var1^) := tbtdouble(var1^) + tbtu16(var2^);
                  btS16: tbtdouble(var1^) := tbtdouble(var1^) + tbts16(var2^);
                  btProcPtr, btU32: tbtdouble(var1^) := tbtdouble(var1^) + tbtu32(var2^);
                  btS32: tbtdouble(var1^) := tbtdouble(var1^) + tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64}    btS64: tbtdouble(var1^) := tbtdouble(var1^) + tbts64(var2^);{$ENDIF}
                  btSingle: tbtdouble(var1^) := tbtdouble(var1^) + tbtsingle(var2^);
                  btDouble: tbtdouble(var1^) := tbtdouble(var1^) + tbtdouble(var2^);
                  btExtended: tbtdouble(var1^) := tbtdouble(var1^) + tbtextended(var2^);
                  btCurrency: tbtdouble(var1^) := tbtdouble(var1^) + tbtcurrency(var2^);
                  btVariant:  tbtdouble(var1^) := tbtdouble(var1^) +  Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btCurrency:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtcurrency(var1^) := tbtcurrency(var1^) + tbtu8(var2^);
                  btS8: tbtcurrency(var1^) := tbtcurrency(var1^) + tbts8(var2^);
                  btU16: tbtcurrency(var1^) := tbtcurrency(var1^) + tbtu16(var2^);
                  btS16: tbtcurrency(var1^) := tbtcurrency(var1^) + tbts16(var2^);
                  btProcPtr, btU32: tbtcurrency(var1^) := tbtdouble(var1^) + tbtu32(var2^);
                  btS32: tbtcurrency(var1^) := tbtcurrency(var1^) + tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64}    btS64: tbtcurrency(var1^) := tbtdouble(var1^) + tbts64(var2^);{$ENDIF}
                  btSingle: tbtcurrency(var1^) := tbtcurrency(var1^) + tbtsingle(var2^);
                  btDouble: tbtcurrency(var1^) := tbtcurrency(var1^) + tbtdouble(var2^);
                  btExtended: tbtcurrency(var1^) := tbtcurrency(var1^) + tbtextended(var2^);
                  btCurrency: tbtcurrency(var1^) := tbtcurrency(var1^) + tbtcurrency(var2^);
                  btVariant:  tbtcurrency(var1^) := tbtcurrency(var1^) +  Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btExtended:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtextended(var1^) := tbtextended(var1^) + tbtu8(var2^);
                  btS8: tbtextended(var1^) := tbtextended(var1^) + tbts8(var2^);
                  btU16: tbtextended(var1^) := tbtextended(var1^) + tbtu16(var2^);
                  btS16: tbtextended(var1^) := tbtextended(var1^) + tbts16(var2^);
                  btProcPtr, btU32: tbtextended(var1^) := tbtextended(var1^) + tbtu32(var2^);
                  btS32: tbtextended(var1^) := tbtextended(var1^) + tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64}    btS64: tbtextended(var1^) := tbtextended(var1^) + tbts64(var2^);{$ENDIF}
                  btSingle: tbtextended(var1^) := tbtextended(var1^) + tbtsingle(var2^);
                  btDouble: tbtextended(var1^) := tbtextended(var1^) + tbtdouble(var2^);
                  btExtended: tbtextended(var1^) := tbtextended(var1^) + tbtextended(var2^);
                  btCurrency: tbtextended(var1^) := tbtextended(var1^) + tbtcurrency(var2^);
                  btVariant:  tbtextended(var1^) := tbtextended(var1^) +  Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btPchar, btString: tbtstring(var1^) := tbtstring(var1^) + IFPSGetString(Var2, var2type);
            btChar: tbtchar(var1^) := char(ord(tbtchar(var1^)) +  IFPSGetUInt(Var2, var2type));
            {$IFNDEF IFPS3_NOWIDESTRING}
            btWideChar: tbtwidechar(var1^) := widechar(ord(tbtwidechar(var1^)) + IFPSGetUInt(Var2, var2type));
            btWideString: tbtwidestring(var1^) := tbtwidestring(var1^) + IFPSGetWideString(Var2, var2type);
            {$ENDIF}
            btVariant:
              begin
                if not IntPIFVariantToVariant(var2, var2type, tvar) then
                begin
                  Result := false;
                end else
                  Variant(var1^) := Variant(var1^) + tvar;
              end;
            btSet:
              begin
                if var1Type = var2Type then
                begin
                  Set_Union(var1, var2, TIFTypeRec_Set(var1Type).aByteSize);
                end else result := False;
              end;

          else begin
              CMD_Err(erTypeMismatch);
              exit;
            end;
          end;
          if not Result then begin
            CMD_Err(erTypeMismatch);
            exit;
          end;
        end;
      1: begin { - }
          case var1Type.BaseType of
            btU8: tbtU8(var1^) := tbtU8(var1^) - IFPSGetUInt(Var2, var2type);
            btS8: tbts8(var1^) := tbts8(var1^) - IFPSGetInt(Var2, var2type);
            btU16: tbtU16(var1^) := tbtU16(var1^) - IFPSGetUInt(Var2, var2type);
            btS16: tbts16(var1^) := tbts16(var1^) - IFPSGetInt(Var2, var2type);
            btU32: 
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtU32(var1^) := tbtU32(var1^) - tbtu8(var2^);
                  btS8: tbtU32(var1^) := tbtU32(var1^) - cardinal(longint(tbts8(var2^)));
                  btU16: tbtU32(var1^) := tbtU32(var1^) - tbtu16(var2^);
                  btS16: tbtU32(var1^) := tbtU32(var1^) - cardinal(longint(tbts16(var2^)));
                  btProcPtr, btU32: tbtU32(var1^) := tbtU32(var1^) - tbtu32(var2^);
                  btS32: tbtU32(var1^) := tbtU32(var1^) - cardinal(tbts32(var2^));
              {$IFNDEF IFPS3_NOINT64} btS64: tbtU32(var1^) := tbtU32(var1^) - tbts64(var2^);{$ENDIF}
                  btChar: tbtU32(var1^) := tbtU32(var1^) -  Ord(tbtchar(var2^));
              {$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: tbtU32(var1^) := tbtU32(var1^) - Ord(tbtwidechar(var2^));{$ENDIF}
                  btVariant: tbtU32(var1^) := tbtU32(var1^) - Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btS32:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbts32(var1^) := tbts32(var1^) - tbtu8(var2^);
                  btS8: tbts32(var1^) := tbts32(var1^) - tbts8(var2^);
                  btU16: tbts32(var1^) := tbts32(var1^) - tbtu16(var2^);
                  btS16: tbts32(var1^) := tbts32(var1^) - tbts16(var2^);
                  btProcPtr, btU32: tbts32(var1^) := tbts32(var1^) - Longint(tbtu32(var2^));
                  btS32: tbts32(var1^) := tbts32(var1^) - tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64} btS64: tbts32(var1^) := tbts32(var1^) - tbts64(var2^);{$ENDIF}
                  btChar: tbts32(var1^) := tbts32(var1^) -  Ord(tbtchar(var2^));
              {$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: tbts32(var1^) := tbts32(var1^) - Ord(tbtwidechar(var2^));{$ENDIF}
                  btVariant: tbts32(var1^) := tbts32(var1^) - Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
           {$IFNDEF IFPS3_NOINT64}
            btS64: tbts64(var1^) := tbts64(var1^) - IFPSGetInt64(var2, var2type);
           {$ENDIF}
            btSingle:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtsingle(var1^) := tbtsingle(var1^) - tbtu8(var2^);
                  btS8: tbtsingle(var1^) := tbtsingle(var1^) - tbts8(var2^);
                  btU16: tbtsingle(var1^) := tbtsingle(var1^) - tbtu16(var2^);
                  btS16: tbtsingle(var1^) := tbtsingle(var1^) - tbts16(var2^);
                  btProcPtr, btU32: tbtsingle(var1^) := tbtsingle(var1^) - tbtu32(var2^);
                  btS32: tbtsingle(var1^) := tbtsingle(var1^) - tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64}    btS64: tbtsingle(var1^) := tbtsingle(var1^) - tbts64(var2^);{$ENDIF}
                  btSingle: tbtsingle(var1^) := tbtsingle(var1^) - tbtsingle(var2^);
                  btDouble: tbtsingle(var1^) := tbtsingle(var1^) - tbtdouble(var2^);
                  btExtended: tbtsingle(var1^) := tbtsingle(var1^) - tbtextended(var2^);
                  btCurrency: tbtsingle(var1^) := tbtsingle(var1^) - tbtcurrency(var2^);
                  btVariant:  tbtsingle(var1^) := tbtsingle(var1^) - Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btCurrency:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtcurrency(var1^) := tbtcurrency(var1^) - tbtu8(var2^);
                  btS8: tbtcurrency(var1^) := tbtcurrency(var1^) - tbts8(var2^);
                  btU16: tbtcurrency(var1^) := tbtcurrency(var1^) - tbtu16(var2^);
                  btS16: tbtcurrency(var1^) := tbtcurrency(var1^) - tbts16(var2^);
                  btProcPtr, btU32: tbtcurrency(var1^) := tbtdouble(var1^) - tbtu32(var2^);
                  btS32: tbtcurrency(var1^) := tbtcurrency(var1^) - tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64}    btS64: tbtcurrency(var1^) := tbtdouble(var1^) - tbts64(var2^);{$ENDIF}
                  btSingle: tbtcurrency(var1^) := tbtcurrency(var1^) - tbtsingle(var2^);
                  btDouble: tbtcurrency(var1^) := tbtcurrency(var1^) - tbtdouble(var2^);
                  btExtended: tbtcurrency(var1^) := tbtcurrency(var1^) - tbtextended(var2^);
                  btCurrency: tbtcurrency(var1^) := tbtcurrency(var1^) - tbtcurrency(var2^);
                  btVariant:  tbtcurrency(var1^) := tbtcurrency(var1^) -  Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btDouble:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtdouble(var1^) := tbtdouble(var1^) - tbtu8(var2^);
                  btS8: tbtdouble(var1^) := tbtdouble(var1^) - tbts8(var2^);
                  btU16: tbtdouble(var1^) := tbtdouble(var1^) - tbtu16(var2^);
                  btS16: tbtdouble(var1^) := tbtdouble(var1^) - tbts16(var2^);
                  btProcPtr, btU32: tbtdouble(var1^) := tbtdouble(var1^) - tbtu32(var2^);
                  btS32: tbtdouble(var1^) := tbtdouble(var1^) - tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64}    btS64: tbtdouble(var1^) := tbtdouble(var1^) - tbts64(var2^);{$ENDIF}
                  btSingle: tbtdouble(var1^) := tbtdouble(var1^) - tbtsingle(var2^);
                  btDouble: tbtdouble(var1^) := tbtdouble(var1^) - tbtdouble(var2^);
                  btExtended: tbtdouble(var1^) := tbtdouble(var1^) - tbtextended(var2^);
                  btCurrency: tbtdouble(var1^) := tbtdouble(var1^) - tbtcurrency(var2^);
                  btVariant:  tbtdouble(var1^) := tbtdouble(var1^) -  Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btExtended:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtextended(var1^) := tbtextended(var1^) - tbtu8(var2^);
                  btS8: tbtextended(var1^) := tbtextended(var1^) - tbts8(var2^);
                  btU16: tbtextended(var1^) := tbtextended(var1^) - tbtu16(var2^);
                  btS16: tbtextended(var1^) := tbtextended(var1^) - tbts16(var2^);
                  btProcPtr, btU32: tbtextended(var1^) := tbtextended(var1^) - tbtu32(var2^);
                  btS32: tbtextended(var1^) := tbtextended(var1^) - tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64}    btS64: tbtextended(var1^) := tbtextended(var1^) -+tbts64(var2^);{$ENDIF}
                  btSingle: tbtextended(var1^) := tbtextended(var1^) - tbtsingle(var2^);
                  btDouble: tbtextended(var1^) := tbtextended(var1^) - tbtdouble(var2^);
                  btExtended: tbtextended(var1^) := tbtextended(var1^) - tbtextended(var2^);
                  btCurrency: tbtextended(var1^) := tbtextended(var1^) - tbtcurrency(var2^);
                  btVariant:  tbtextended(var1^) := tbtextended(var1^) -  Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btChar: tbtchar(var1^):= char(ord(tbtchar(var1^)) - IFPSGetUInt(Var2, var2type));
            {$IFNDEF IFPS3_NOWIDESTRING}
            btWideChar: tbtwidechar(var1^) := widechar(ord(tbtwidechar(var1^)) - IFPSGetUInt(Var2, var2type));
            {$ENDIF}
            btVariant:
              begin
                if not IntPIFVariantToVariant(var2, var2type, tvar) then
                begin
                  Result := false;
                end else
                  Variant(var1^) := Variant(var1^) - tvar;
              end;
            btSet:
              begin
                if var1Type = var2Type then
                begin
                  Set_Diff(var1, var2, TIFTypeRec_Set(var1Type).aByteSize);
                end else result := False;
              end;
          else begin
              CMD_Err(erTypeMismatch);
              exit;
            end;
          end;
          if not Result then begin
            CMD_Err(erTypeMismatch);
            exit;
          end;
        end;
      2: begin { * }
          case var1Type.BaseType of
            btU8: tbtU8(var1^) := tbtU8(var1^) * IFPSGetUInt(Var2, var2type);
            btS8: tbts8(var1^) := tbts8(var1^) * IFPSGetInt(Var2, var2type);
            btU16: tbtU16(var1^) := tbtU16(var1^) * IFPSGetUInt(Var2, var2type);
            btS16: tbts16(var1^) := tbts16(var1^) * IFPSGetInt(Var2, var2type);
            btU32: 
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtU32(var1^) := tbtU32(var1^) * tbtu8(var2^);
                  btS8: tbtU32(var1^) := tbtU32(var1^) * cardinal(longint(tbts8(var2^)));
                  btU16: tbtU32(var1^) := tbtU32(var1^) * tbtu16(var2^);
                  btS16: tbtU32(var1^) := tbtU32(var1^) * cardinal(longint(tbts16(var2^)));
                  btProcPtr, btU32: tbtU32(var1^) := tbtU32(var1^) * tbtu32(var2^);
                  btS32: tbtU32(var1^) := tbtU32(var1^) * cardinal(tbts32(var2^));
              {$IFNDEF IFPS3_NOINT64} btS64: tbtU32(var1^) := tbtU32(var1^) * tbts64(var2^);{$ENDIF}
                  btChar: tbtU32(var1^) := tbtU32(var1^) *  Ord(tbtchar(var2^));
              {$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: tbtU32(var1^) := tbtU32(var1^) * Ord(tbtwidechar(var2^));{$ENDIF}
                  btVariant: tbtU32(var1^) := tbtU32(var1^) * Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btS32:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbts32(var1^) := tbts32(var1^) * tbtu8(var2^);
                  btS8: tbts32(var1^) := tbts32(var1^) * tbts8(var2^);
                  btU16: tbts32(var1^) := tbts32(var1^) * tbtu16(var2^);
                  btS16: tbts32(var1^) := tbts32(var1^) * tbts16(var2^);
                  btProcPtr, btU32: tbts32(var1^) := tbts32(var1^) * Longint(tbtu32(var2^));
                  btS32: tbts32(var1^) := tbts32(var1^) * tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64} btS64: tbts32(var1^) := tbts32(var1^) * tbts64(var2^);{$ENDIF}
                  btChar: tbts32(var1^) := tbts32(var1^) *  Ord(tbtchar(var2^));
              {$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: tbts32(var1^) := tbts32(var1^) * Ord(tbtwidechar(var2^));{$ENDIF}
                  btVariant: tbts32(var1^) := tbts32(var1^) * Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
           {$IFNDEF IFPS3_NOINT64}
            btS64: tbts64(var1^) := tbts64(var1^) * IFPSGetInt64(var2, var2type);
           {$ENDIF}
            btCurrency:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtcurrency(var1^) := tbtcurrency(var1^) * tbtu8(var2^);
                  btS8: tbtcurrency(var1^) := tbtcurrency(var1^) * tbts8(var2^);
                  btU16: tbtcurrency(var1^) := tbtcurrency(var1^) * tbtu16(var2^);
                  btS16: tbtcurrency(var1^) := tbtcurrency(var1^) * tbts16(var2^);
                  btProcPtr, btU32: tbtcurrency(var1^) := tbtdouble(var1^) * tbtu32(var2^);
                  btS32: tbtcurrency(var1^) := tbtcurrency(var1^) * tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64}    btS64: tbtcurrency(var1^) := tbtdouble(var1^) * tbts64(var2^);{$ENDIF}
                  btSingle: tbtcurrency(var1^) := tbtcurrency(var1^) * tbtsingle(var2^);
                  btDouble: tbtcurrency(var1^) := tbtcurrency(var1^) * tbtdouble(var2^);
                  btExtended: tbtcurrency(var1^) := tbtcurrency(var1^) * tbtextended(var2^);
                  btCurrency: tbtcurrency(var1^) := tbtcurrency(var1^) * tbtcurrency(var2^);
                  btVariant:  tbtcurrency(var1^) := tbtcurrency(var1^) *  Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btSingle:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtsingle(var1^) := tbtsingle(var1^) *tbtu8(var2^);
                  btS8: tbtsingle(var1^) := tbtsingle(var1^) *tbts8(var2^);
                  btU16: tbtsingle(var1^) := tbtsingle(var1^) *tbtu16(var2^);
                  btS16: tbtsingle(var1^) := tbtsingle(var1^) *tbts16(var2^);
                  btProcPtr, btU32: tbtsingle(var1^) := tbtsingle(var1^) *tbtu32(var2^);
                  btS32: tbtsingle(var1^) := tbtsingle(var1^) *tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64}    btS64: tbtsingle(var1^) := tbtsingle(var1^) *tbts64(var2^);{$ENDIF}
                  btSingle: tbtsingle(var1^) := tbtsingle(var1^) *tbtsingle(var2^);
                  btDouble: tbtsingle(var1^) := tbtsingle(var1^) *tbtdouble(var2^);
                  btExtended: tbtsingle(var1^) := tbtsingle(var1^) *tbtextended(var2^);
                  btCurrency: tbtsingle(var1^) := tbtsingle(var1^) *tbtcurrency(var2^);
                  btVariant:  tbtsingle(var1^) := tbtsingle(var1^) * Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btDouble:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtdouble(var1^) := tbtdouble(var1^) *tbtu8(var2^);
                  btS8: tbtdouble(var1^) := tbtdouble(var1^) *tbts8(var2^);
                  btU16: tbtdouble(var1^) := tbtdouble(var1^) *tbtu16(var2^);
                  btS16: tbtdouble(var1^) := tbtdouble(var1^) *tbts16(var2^);
                  btProcPtr, btU32: tbtdouble(var1^) := tbtdouble(var1^) *tbtu32(var2^);
                  btS32: tbtdouble(var1^) := tbtdouble(var1^) *tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64}    btS64: tbtdouble(var1^) := tbtdouble(var1^) *tbts64(var2^);{$ENDIF}
                  btSingle: tbtdouble(var1^) := tbtdouble(var1^) *tbtsingle(var2^);
                  btDouble: tbtdouble(var1^) := tbtdouble(var1^) *tbtdouble(var2^);
                  btExtended: tbtdouble(var1^) := tbtdouble(var1^) *tbtextended(var2^);
                  btCurrency: tbtdouble(var1^) := tbtdouble(var1^) *tbtcurrency(var2^);
                  btVariant:  tbtdouble(var1^) := tbtdouble(var1^) * Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btExtended:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtextended(var1^) := tbtextended(var1^) *tbtu8(var2^);
                  btS8: tbtextended(var1^) := tbtextended(var1^) *tbts8(var2^);
                  btU16: tbtextended(var1^) := tbtextended(var1^) *tbtu16(var2^);
                  btS16: tbtextended(var1^) := tbtextended(var1^) *tbts16(var2^);
                  btProcPtr, btU32: tbtextended(var1^) := tbtextended(var1^) *tbtu32(var2^);
                  btS32: tbtextended(var1^) := tbtextended(var1^) *tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64}    btS64: tbtextended(var1^) := tbtextended(var1^) *tbts64(var2^);{$ENDIF}
                  btSingle: tbtextended(var1^) := tbtextended(var1^) *tbtsingle(var2^);
                  btDouble: tbtextended(var1^) := tbtextended(var1^) *tbtdouble(var2^);
                  btExtended: tbtextended(var1^) := tbtextended(var1^) *tbtextended(var2^);
                  btCurrency: tbtextended(var1^) := tbtextended(var1^) *tbtcurrency(var2^);
                  btVariant:  tbtextended(var1^) := tbtextended(var1^) * Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btVariant:
              begin
                if not IntPIFVariantToVariant(var2, var2type, tvar) then
                begin
                  Result := false;
                end else
                  Variant(var1^) := Variant(var1^) * tvar;
              end;
            btSet:
              begin
                if var1Type = var2Type then
                begin
                  Set_Intersect(var1, var2, TIFTypeRec_Set(var1Type).aByteSize);
                end else result := False;
              end;
          else begin
              CMD_Err(erTypeMismatch);
              exit;
            end;
          end;
          if not Result then begin
            CMD_Err(erTypeMismatch);
            exit;
          end;
        end;
      3: begin { / }
          case var1Type.BaseType of
            btU8: tbtU8(var1^) := tbtU8(var1^) div IFPSGetUInt(Var2, var2type);
            btS8: tbts8(var1^) := tbts8(var1^) div IFPSGetInt(Var2, var2type);
            btU16: tbtU16(var1^) := tbtU16(var1^) div IFPSGetUInt(Var2, var2type);
            btS16: tbts16(var1^) := tbts16(var1^) div IFPSGetInt(Var2, var2type);
            btU32: 
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtU32(var1^) := tbtU32(var1^) div tbtu8(var2^);
                  btS8: tbtU32(var1^) := tbtU32(var1^) div cardinal(longint(tbts8(var2^)));
                  btU16: tbtU32(var1^) := tbtU32(var1^) div tbtu16(var2^);
                  btS16: tbtU32(var1^) := tbtU32(var1^) div cardinal(longint(tbts16(var2^)));
                  btProcPtr, btU32: tbtU32(var1^) := tbtU32(var1^) div tbtu32(var2^);
                  btS32: tbtU32(var1^) := tbtU32(var1^) div cardinal(tbts32(var2^));
              {$IFNDEF IFPS3_NOINT64} btS64: tbtU32(var1^) := tbtU32(var1^) div tbts64(var2^);{$ENDIF}
                  btChar: tbtU32(var1^) := tbtU32(var1^) div  Ord(tbtchar(var2^));
              {$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: tbtU32(var1^) := tbtU32(var1^) div Ord(tbtwidechar(var2^));{$ENDIF}
                  btVariant: tbtU32(var1^) := tbtU32(var1^) div Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btS32:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbts32(var1^) := tbts32(var1^) div tbtu8(var2^);
                  btS8: tbts32(var1^) := tbts32(var1^) div tbts8(var2^);
                  btU16: tbts32(var1^) := tbts32(var1^) div tbtu16(var2^);
                  btS16: tbts32(var1^) := tbts32(var1^) div tbts16(var2^);
                  btProcPtr, btU32: tbts32(var1^) := tbts32(var1^) div Longint(tbtu32(var2^));
                  btS32: tbts32(var1^) := tbts32(var1^) div tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64} btS64: tbts32(var1^) := tbts32(var1^) div tbts64(var2^);{$ENDIF}
                  btChar: tbts32(var1^) := tbts32(var1^) div  Ord(tbtchar(var2^));
              {$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: tbts32(var1^) := tbts32(var1^) div Ord(tbtwidechar(var2^));{$ENDIF}
                  btVariant: tbts32(var1^) := tbts32(var1^) div Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
           {$IFNDEF IFPS3_NOINT64}
            btS64: tbts64(var1^) := tbts64(var1^) div IFPSGetInt64(var2, var2type);
           {$ENDIF}
            btSingle:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtsingle(var1^) := tbtsingle(var1^) / tbtu8(var2^);
                  btS8: tbtsingle(var1^) := tbtsingle(var1^) / tbts8(var2^);
                  btU16: tbtsingle(var1^) := tbtsingle(var1^) / tbtu16(var2^);
                  btS16: tbtsingle(var1^) := tbtsingle(var1^) / tbts16(var2^);
                  btProcPtr, btU32: tbtsingle(var1^) := tbtsingle(var1^) / tbtu32(var2^);
                  btS32: tbtsingle(var1^) := tbtsingle(var1^) / tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64}    btS64: tbtsingle(var1^) := tbtsingle(var1^) / tbts64(var2^);{$ENDIF}
                  btSingle: tbtsingle(var1^) := tbtsingle(var1^) / tbtsingle(var2^);
                  btDouble: tbtsingle(var1^) := tbtsingle(var1^) / tbtdouble(var2^);
                  btExtended: tbtsingle(var1^) := tbtsingle(var1^) / tbtextended(var2^);
                  btCurrency: tbtsingle(var1^) := tbtsingle(var1^) / tbtcurrency(var2^);
                  btVariant:  tbtsingle(var1^) := tbtsingle(var1^) /  Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btCurrency:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtcurrency(var1^) := tbtcurrency(var1^) / tbtu8(var2^);
                  btS8: tbtcurrency(var1^) := tbtcurrency(var1^) / tbts8(var2^);
                  btU16: tbtcurrency(var1^) := tbtcurrency(var1^) / tbtu16(var2^);
                  btS16: tbtcurrency(var1^) := tbtcurrency(var1^) / tbts16(var2^);
                  btProcPtr, btU32: tbtcurrency(var1^) := tbtdouble(var1^) / tbtu32(var2^);
                  btS32: tbtcurrency(var1^) := tbtcurrency(var1^) / tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64}    btS64: tbtcurrency(var1^) := tbtdouble(var1^) / tbts64(var2^);{$ENDIF}
                  btSingle: tbtcurrency(var1^) := tbtcurrency(var1^) / tbtsingle(var2^);
                  btDouble: tbtcurrency(var1^) := tbtcurrency(var1^) / tbtdouble(var2^);
                  btExtended: tbtcurrency(var1^) := tbtcurrency(var1^) / tbtextended(var2^);
                  btCurrency: tbtcurrency(var1^) := tbtcurrency(var1^) / tbtcurrency(var2^);
                  btVariant:  tbtcurrency(var1^) := tbtcurrency(var1^) /  Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btDouble:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtdouble(var1^) := tbtdouble(var1^) / tbtu8(var2^);
                  btS8: tbtdouble(var1^) := tbtdouble(var1^) / tbts8(var2^);
                  btU16: tbtdouble(var1^) := tbtdouble(var1^) / tbtu16(var2^);
                  btS16: tbtdouble(var1^) := tbtdouble(var1^) / tbts16(var2^);
                  btProcPtr, btU32: tbtdouble(var1^) := tbtdouble(var1^) / tbtu32(var2^);
                  btS32: tbtdouble(var1^) := tbtdouble(var1^) / tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64}    btS64: tbtdouble(var1^) := tbtdouble(var1^) / tbts64(var2^);{$ENDIF}
                  btSingle: tbtdouble(var1^) := tbtdouble(var1^) / tbtsingle(var2^);
                  btDouble: tbtdouble(var1^) := tbtdouble(var1^) / tbtdouble(var2^);
                  btExtended: tbtdouble(var1^) := tbtdouble(var1^) / tbtextended(var2^);
                  btCurrency: tbtdouble(var1^) := tbtdouble(var1^) / tbtcurrency(var2^);
                  btVariant:  tbtdouble(var1^) := tbtdouble(var1^) /  Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btExtended:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtextended(var1^) := tbtextended(var1^) / tbtu8(var2^);
                  btS8: tbtextended(var1^) := tbtextended(var1^) / tbts8(var2^);
                  btU16: tbtextended(var1^) := tbtextended(var1^) / tbtu16(var2^);
                  btS16: tbtextended(var1^) := tbtextended(var1^) / tbts16(var2^);
                  btProcPtr, btU32: tbtextended(var1^) := tbtextended(var1^) / tbtu32(var2^);
                  btS32: tbtextended(var1^) := tbtextended(var1^) / tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64}    btS64: tbtextended(var1^) := tbtextended(var1^) / tbts64(var2^);{$ENDIF}
                  btSingle: tbtextended(var1^) := tbtextended(var1^) / tbtsingle(var2^);
                  btDouble: tbtextended(var1^) := tbtextended(var1^) / tbtdouble(var2^);
                  btExtended: tbtextended(var1^) := tbtextended(var1^) / tbtextended(var2^);
                  btCurrency: tbtextended(var1^) := tbtextended(var1^) / tbtcurrency(var2^);
                  btVariant:  tbtextended(var1^) := tbtextended(var1^) /  Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btVariant:
              begin
                if not IntPIFVariantToVariant(var2, var2type, tvar) then
                begin
                  Result := false;
                end else
                begin
                  if VarIsFloat(variant(var1^)) then
                    Variant(var1^) := Variant(var1^) / tvar
                  else
                    Variant(var1^) := Variant(var1^) div tvar;
                end;
              end;
          else begin
              CMD_Err(erTypeMismatch);
              exit;
            end;
          end;
          if not Result then begin
            CMD_Err(erTypeMismatch);
            exit;
          end;
        end;
      4: begin { MOD }
          case var1Type.BaseType of
            btU8: tbtU8(var1^) := tbtU8(var1^) mod IFPSGetUInt(Var2, var2type);
            btS8: tbts8(var1^) := tbts8(var1^) mod IFPSGetInt(Var2, var2type);
            btU16: tbtU16(var1^) := tbtU16(var1^) mod IFPSGetUInt(Var2, var2type);
            btS16: tbts16(var1^) := tbts16(var1^) mod IFPSGetInt(Var2, var2type);
            btU32: 
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbtU32(var1^) := tbtU32(var1^) mod tbtu8(var2^);
                  btS8: tbtU32(var1^) := tbtU32(var1^) mod cardinal(longint(tbts8(var2^)));
                  btU16: tbtU32(var1^) := tbtU32(var1^) mod tbtu16(var2^);
                  btS16: tbtU32(var1^) := tbtU32(var1^) mod cardinal(longint(tbts16(var2^)));
                  btProcPtr, btU32: tbtU32(var1^) := tbtU32(var1^) mod tbtu32(var2^);
                  btS32: tbtU32(var1^) := tbtU32(var1^) mod cardinal(tbts32(var2^));
              {$IFNDEF IFPS3_NOINT64} btS64: tbtU32(var1^) := tbtU32(var1^) mod tbts64(var2^);{$ENDIF}
                  btChar: tbtU32(var1^) := tbtU32(var1^) mod  Ord(tbtchar(var2^));
              {$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: tbtU32(var1^) := tbtU32(var1^) mod Ord(tbtwidechar(var2^));{$ENDIF}
                  btVariant: tbtU32(var1^) := tbtU32(var1^) mod Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
            btS32:
              begin
                if var2type.BaseType = btPointer then
                begin
                  var2type := PIFTypeRec(Pointer(IPointer(var2)+4)^);
                  var2 := Pointer(var2^);
                  if (var2 = nil) or (var2type = nil) then raise Exception.Create('Type Mismatch');
                end;
                case var2type.BaseType of
                  btU8: tbts32(var1^) := tbts32(var1^) mod tbtu8(var2^);
                  btS8: tbts32(var1^) := tbts32(var1^) mod tbts8(var2^);
                  btU16: tbts32(var1^) := tbts32(var1^) mod tbtu16(var2^);
                  btS16: tbts32(var1^) := tbts32(var1^) mod tbts16(var2^);
                  btProcPtr, btU32: tbts32(var1^) := tbts32(var1^) mod Longint(tbtu32(var2^));
                  btS32: tbts32(var1^) := tbts32(var1^) mod tbts32(var2^);
              {$IFNDEF IFPS3_NOINT64} btS64: tbts32(var1^) := tbts32(var1^) mod tbts64(var2^);{$ENDIF}
                  btChar: tbts32(var1^) := tbts32(var1^) mod  Ord(tbtchar(var2^));
              {$IFNDEF IFPS3_NOWIDESTRING}    btWideChar: tbts32(var1^) := tbts32(var1^) mod Ord(tbtwidechar(var2^));{$ENDIF}
                  btVariant: tbts32(var1^) := tbts32(var1^) mod Variant(var2^);
                  else raise Exception.Create('Type Mismatch');
                end;
              end;
           {$IFNDEF IFPS3_NOINT64}
            btS64: tbts64(var1^) := tbts64(var1^) mod IFPSGetInt64(var2, var2type);
           {$ENDIF}
            btVariant:
              begin
                if not IntPIFVariantToVariant(var2, var2type, tvar) then
                begin
                  Result := false;
                end else
                  Variant(var1^) := Variant(var1^) mod tvar;
              end;
          else begin
              CMD_Err(erTypeMismatch);
              exit;
            end;
          end;
          if not Result then begin
            CMD_Err(erTypeMismatch);
            exit;
          end;
        end;
      5: begin { SHL }
          case var1Type.BaseType of
            btU8: tbtU8(var1^) := tbtU8(var1^) shl IFPSGetUInt(Var2, var2type);
            btS8: tbts8(var1^) := tbts8(var1^) shl IFPSGetInt(Var2, var2type);
            btU16: tbtU16(var1^) := tbtU16(var1^) shl IFPSGetUInt(Var2, var2type);
            btS16: tbts16(var1^) := tbts16(var1^) shl IFPSGetInt(Var2, var2type);
            btU32: tbtU32(var1^) := tbtU32(var1^) shl IFPSGetUInt(Var2, var2type);
            btS32: tbts32(var1^) := tbts32(var1^) shl IFPSGetInt(Var2, var2type);
           {$IFNDEF IFPS3_NOINT64}
            btS64: tbts64(var1^) := tbts64(var1^) shl IFPSGetInt64(var2, var2type);
           {$ENDIF}
            btVariant:
              begin
                if not IntPIFVariantToVariant(var2, var2type, tvar) then
                begin
                  Result := false;
                end else
                  Variant(var1^) := Variant(var1^) shl tvar;
              end;
          else begin
              CMD_Err(erTypeMismatch);
              exit;
            end;
          end;
          if not Result then begin
            CMD_Err(erTypeMismatch);
            exit;
          end;
        end;
      6: begin { SHR }
          case var1Type.BaseType of
            btU8: tbtU8(var1^) := tbtU8(var1^) shr IFPSGetUInt(Var2, var2type);
            btS8: tbts8(var1^) := tbts8(var1^) shr IFPSGetInt(Var2, var2type);
            btU16: tbtU16(var1^) := tbtU16(var1^) shr IFPSGetUInt(Var2, var2type);
            btS16: tbts16(var1^) := tbts16(var1^) shr IFPSGetInt(Var2, var2type);
            btU32: tbtU32(var1^) := tbtU32(var1^) shr IFPSGetUInt(Var2, var2type);
            btS32: tbts32(var1^) := tbts32(var1^) shr IFPSGetInt(Var2, var2type);
           {$IFNDEF IFPS3_NOINT64}
            btS64: tbts64(var1^) := tbts64(var1^) shr IFPSGetInt64(var2, var2type);
           {$ENDIF}
            btVariant:
              begin
                if not IntPIFVariantToVariant(var2, var2type, tvar) then
                begin
                  Result := false;
                end else
                  Variant(var1^) := Variant(var1^) shr tvar;
              end;
          else begin
              CMD_Err(erTypeMismatch);
              exit;
            end;
          end;
          if not Result then begin
            CMD_Err(erTypeMismatch);
            exit;
          end;
        end;
      7: begin { AND }
          case var1Type.BaseType of
            btU8: tbtU8(var1^) := tbtU8(var1^) and IFPSGetUInt(Var2, var2type);
            btS8: tbts8(var1^) := tbts8(var1^) and IFPSGetInt(Var2, var2type);
            btU16: tbtU16(var1^) := tbtU16(var1^) and IFPSGetUInt(Var2, var2type);
            btS16: tbts16(var1^) := tbts16(var1^) and IFPSGetInt(Var2, var2type);
            btU32: tbtU32(var1^) := tbtU32(var1^) and IFPSGetUInt(Var2, var2type);
            btS32: tbts32(var1^) := tbts32(var1^) and IFPSGetInt(Var2, var2type);
           {$IFNDEF IFPS3_NOINT64}
            btS64: tbts64(var1^) := tbts64(var1^) and IFPSGetInt64(var2, var2type);
           {$ENDIF}
            btVariant:
              begin
                if not IntPIFVariantToVariant(var2, var2type, tvar) then
                begin
                  Result := false;
                end else
                  Variant(var1^) := Variant(var1^) and tvar;
              end;
          else begin
              CMD_Err(erTypeMismatch);
              exit;
            end;
          end;
          if not Result then begin
            CMD_Err(erTypeMismatch);
            exit;
          end;
        end;
      8: begin { OR }
          case var1Type.BaseType of
            btU8: tbtU8(var1^) := tbtU8(var1^) or IFPSGetUInt(Var2, var2type);
            btS8: tbts8(var1^) := tbts8(var1^) or IFPSGetInt(Var2, var2type);
            btU16: tbtU16(var1^) := tbtU16(var1^) or IFPSGetUInt(Var2, var2type);
            btS16: tbts16(var1^) := tbts16(var1^) or IFPSGetInt(Var2, var2type);
            btU32: tbtU32(var1^) := tbtU32(var1^) or IFPSGetUInt(Var2, var2type);
            btS32: tbts32(var1^) := tbts32(var1^) or IFPSGetInt(Var2, var2type);
           {$IFNDEF IFPS3_NOINT64}
            btS64: tbts64(var1^) := tbts64(var1^) or IFPSGetInt64(var2, var2type);
           {$ENDIF}
            btVariant:
              begin
                if not IntPIFVariantToVariant(var2, var2type, tvar) then
                begin
                  Result := false;
                end else
                  Variant(var1^) := Variant(var1^) or tvar;
              end;
          else begin
              CMD_Err(erTypeMismatch);
              exit;
            end;
          end;
          if not Result then begin
            CMD_Err(erTypeMismatch);
            exit;
          end;
        end;
      9: begin { XOR }
          case var1Type.BaseType of
            btU8: tbtU8(var1^) := tbtU8(var1^) xor IFPSGetUInt(Var2, var2type);
            btS8: tbts8(var1^) := tbts8(var1^) xor IFPSGetInt(Var2, var2type);
            btU16: tbtU16(var1^) := tbtU16(var1^) xor IFPSGetUInt(Var2, var2type);
            btS16: tbts16(var1^) := tbts16(var1^) xor IFPSGetInt(Var2, var2type);
            btU32: tbtU32(var1^) := tbtU32(var1^) xor IFPSGetUInt(Var2, var2type);
            btS32: tbts32(var1^) := tbts32(var1^) xor IFPSGetInt(Var2, var2type);
           {$IFNDEF IFPS3_NOINT64}
            btS64: tbts64(var1^) := tbts64(var1^) xor IFPSGetInt64(var2, var2type);
           {$ENDIF}
            btVariant:
              begin
                if not IntPIFVariantToVariant(var2, var2type, tvar) then
                begin
                  Result := false;
                end else
                  Variant(var1^) := Variant(var1^) xor tvar;
              end;
          else begin
              CMD_Err(erTypeMismatch);
              exit;
            end;
          end;
          if not Result then begin
            CMD_Err(erTypeMismatch);
            exit;
          end;
        end;
      10:
        begin // as
          case var1Type.BaseType of
            btClass:
              begin
                if var2type.BaseType <> btU32 then
                  Result := False
                else
                begin
                  var2type := FTypes[tbtu32(var2^)];
                  if (var2type = nil) or (var2type.BaseType <> btClass) then
                    Result := false
                  else
                  begin
                    if not Class_IS(Self, TObject(var1^), var2type) then
                      Result := false
                  end;
                end;
              end;
          else begin
              CMD_Err(erTypeMismatch);
              exit;
            end;
          end;
          if not Result then begin
            CMD_Err(erTypeMismatch);
            exit;
          end;
        end;
    else begin
        Result := False;
        CMD_Err(erInvalidOpcodeParameter);
        exit;
      end;
    end;
  except
    {$IFDEF IFPS3_D6PLUS}
    Tmp := AcquireExceptionObject;
    {$ELSE}
    if RaiseList <> nil then
    begin
      Tmp := Exception(PRaiseFrame(RaiseList)^.ExceptObject);
      PRaiseFrame(RaiseList)^.ExceptObject := nil;
    end else
      Tmp := nil;
    {$ENDIF}
    if Tmp <> nil then
    begin
      if Tmp is EIFPS3Exception then
      begin
        Result := False;
        ExceptionProc(EIFPS3Exception(tmp).ProcNo, EIFPS3Exception(tmp).ProcPos, erCustomError, EIFPS3Exception(tmp).Message, nil);
        exit;
      end else
      if Tmp is EDivByZero then
      begin
        Result := False;
        CMD_Err3(erDivideByZero, '', Tmp);
        Exit;
      end;
      if Tmp is EZeroDivide then
      begin
        Result := False;
        CMD_Err3(erDivideByZero, '', Tmp);
        Exit;
      end;
      if Tmp is EMathError then
      begin
        Result := False;
        CMD_Err3(erMathError, '', Tmp);
        Exit;
      end;
    end;
    if (tmp <> nil) and (Tmp is Exception) then
      CMD_Err3(erException, Exception(Tmp).Message, Tmp)
    else
      CMD_Err3(erException, '', Tmp);
    Result := False;
  end;
end;

function TIFPSExec.ReadVariable(var Dest: TIFPSResultData; UsePointer: Boolean): Boolean;
var
  VarType: Cardinal;
  Param: Cardinal;
  Tmp: PIfVariant;
  at: TIFTypeRec;

begin
  if FCurrentPosition + 4 >= FDataLength then
  begin
    CMD_Err(erOutOfRange); // Error
    Result := False;
    exit;
  end;
  VarType := FData^[FCurrentPosition];
  Inc(FCurrentPosition);
  Param := Cardinal((@FData^[FCurrentPosition])^);
  Inc(FCurrentPosition, 4);
  case VarType of
    0:
      begin
        Dest.FreeType := vtNone;
        if Param < IFPSAddrNegativeStackStart then
        begin
          if Param >= Cardinal(FGlobalVars.Count) then
          begin
            CMD_Err(erOutOfGlobalVarsRange);
            Result := False;
            exit;
          end;
          Tmp := FGlobalVars.Data[param];
        end else
        begin
          Param := Cardinal(Longint(-IFPSAddrStackStart) +
            Longint(FCurrStackBase) + Longint(Param));
          if Param >= Cardinal(FStack.Count) then
          begin
            CMD_Err(erOutOfGlobalVarsRange);
            Result := False;
            exit;
          end;
          Tmp := FStack.Data[param];
        end;
        if (UsePointer) and (Tmp.FType.BaseType = btPointer) then
        begin
          Dest.aType := PIFPSVariantPointer(Tmp).DestType;
          Dest.P := PIFPSVariantPointer(Tmp).DataDest;
          if Dest.P = nil then
          begin
            Cmd_Err(erNullPointerException);
            Result := False;
            exit;
          end;
        end else
        begin
          Dest.aType := PIFPSVariantData(Tmp).vi.FType;
          Dest.P := @PIFPSVariantData(Tmp).Data;
        end;
      end;
    1: begin
        if Param >= FTypes.Count then
        begin
          CMD_Err(erInvalidType);
          Result := False;
          exit;
        end;
        at := FTypes.Data^[Param];
        Param := FTempVars.FLength;
        FTempVars.FLength := Cardinal(Longint(Param) + Longint(at.RealSize) + Longint(RTTISize + 3)) and not 3;
        if FTempVars.FLength > FTempVars.FCapacity then FtempVars.AdjustLength;
        Tmp := Pointer(IPointer(FtempVars.FDataPtr) + IPointer(Param));

        if Cardinal(FTempVars.FCount) >= Cardinal(FTempVars.FCapacity) then
        begin
          Inc(FTempVars.FCapacity, FCapacityInc);// := FCount + 1;
          ReAllocMem(FTempVars.FData, FTempVars.FCapacity shl 2);
        end;
        FTempVars.FData[FTempVars.FCount] := Tmp; // Instead of SetItem
        Inc(FTempVars.FCount);
      {$IFNDEF IFPS3_NOSMARTLIST}
        Inc(FTempVars.FCheckCount);
        if FTempVars.FCheckCount > FMaxCheckCount then FTempVars.Recreate;
      {$ENDIF}


        Tmp.FType := at;
        Dest.P := @PIFPSVariantData(Tmp).Data;
        Dest.aType := tmp.FType;
        dest.FreeType := vtTempVar;
        case Dest.aType.BaseType of
          btSet:
            begin
              if not ReadData(Dest.P^, TIFTypeRec_Set(Dest.aType).aByteSize) then
              begin
                CMD_Err(erOutOfRange);
                FTempVars.Pop;
                Result := False;
                exit;
              end;
            end;
          bts8, btchar, btU8:
            begin
              if FCurrentPosition >= FDataLength then
              begin
                CMD_Err(erOutOfRange);
                FTempVars.Pop;
                Result := False;
                exit;
              end;
              tbtu8(dest.p^) := FData^[FCurrentPosition];
              Inc(FCurrentPosition);
            end;
          bts16, {$IFNDEF IFPS3_NOWIDESTRING}btwidechar,{$ENDIF} btU16:
            begin
              if FCurrentPosition + 1>= FDataLength then
              begin
                CMD_Err(erOutOfRange);
                FTempVars.Pop;
                Result := False;
                exit;
              end;
              tbtu16(dest.p^) := tbtu16((@FData^[FCurrentPosition])^);
              Inc(FCurrentPosition, 2);
            end;
          bts32, btU32, btProcPtr:
            begin
              if FCurrentPosition + 3>= FDataLength then
              begin
                CMD_Err(erOutOfRange);
                FTempVars.Pop;
                Result := False;
                exit;
              end;
              tbtu32(dest.p^) := tbtu32((@FData^[FCurrentPosition])^);
              Inc(FCurrentPosition, 4);
            end;
          {$IFNDEF IFPS3_NOINT64}
          bts64:
            begin
              if FCurrentPosition + 7>= FDataLength then
              begin
                CMD_Err(erOutOfRange);
                FTempVars.Pop;
                Result := False;
                exit;
              end;
              tbts64(dest.p^) := tbts64((@FData^[FCurrentPosition])^);
              Inc(FCurrentPosition, 8);
            end;
          {$ENDIF}
          btSingle:
            begin
              if FCurrentPosition + (Sizeof(Single)-1)>= FDataLength then
              begin
                CMD_Err(erOutOfRange);
                FTempVars.Pop;
                Result := False;
                exit;
              end;
              tbtsingle(dest.p^) := tbtsingle((@FData^[FCurrentPosition])^);
              Inc(FCurrentPosition, Sizeof(Single));
            end;
          btDouble:
            begin
              if FCurrentPosition + (Sizeof(Double)-1)>= FDataLength then
              begin
                CMD_Err(erOutOfRange);
                FTempVars.Pop;
                Result := False;
                exit;
              end;
              tbtdouble(dest.p^) := tbtdouble((@FData^[FCurrentPosition])^);
              Inc(FCurrentPosition, Sizeof(double));
            end;

          btExtended:
            begin
              if FCurrentPosition + (sizeof(Extended)-1)>= FDataLength then
              begin
                CMD_Err(erOutOfRange);
                FTempVars.Pop;
                Result := False;
                exit;
              end;
              tbtextended(dest.p^) := tbtextended((@FData^[FCurrentPosition])^);
              Inc(FCurrentPosition, sizeof(Extended));
            end;
          btPchar, btString:
          begin
              if FCurrentPosition + 3 >= FDataLength then
              begin
                Cmd_Err(erOutOfRange);
                FTempVars.Pop;
                Result := False;
                exit;
              end;
              Param := Cardinal((@FData^[FCurrentPosition])^);
              Inc(FCurrentPosition, 4);
              Pointer(Dest.P^) := nil;
              SetLength(tbtstring(Dest.P^), Param);
              if not ReadData(tbtstring(Dest.P^)[1], Param) then
              begin
                CMD_Err(erOutOfRange);
                FTempVars.Pop;
                Result := False;
                exit;
              end;
            end;
          {$IFNDEF IFPS3_NOWIDESTRING}
          btWidestring:
            begin
              if FCurrentPosition + 3 >= FDataLength then
              begin
                Cmd_Err(erOutOfRange);
                FTempVars.Pop;
                Result := False;
                exit;
              end;
              Param := Cardinal((@FData^[FCurrentPosition])^);
              Inc(FCurrentPosition, 4);
              Pointer(Dest.P^) := nil;
              SetLength(tbtwidestring(Dest.P^), Param);
              if not ReadData(tbtwidestring(Dest.P^)[1], Param*2) then
              begin
                CMD_Err(erOutOfRange);
                FTempVars.Pop;
                Result := False;
                exit;
              end;
            end;
          {$ENDIF}
        else begin
            CMD_Err(erInvalidType);
            FTempVars.Pop;
            Result := False;
            exit;
          end;
        end;
      end;
    2:
      begin
        Dest.FreeType := vtNone;
        if Param < IFPSAddrNegativeStackStart then begin
          if Param >= Cardinal(FGlobalVars.Count) then
          begin
            CMD_Err(erOutOfGlobalVarsRange);
            Result := False;
            exit;
          end;
          Tmp := FGlobalVars.Data[param];
        end
        else begin
          Param := Cardinal(Longint(-IFPSAddrStackStart) + Longint(FCurrStackBase) + Longint(Param));
          if Param >= Cardinal(FStack.Count) then
          begin
            CMD_Err(erOutOfStackRange);
            Result := False;
            exit;
          end;
          Tmp := FStack.Data[param];
        end;
        if Tmp.FType.BaseType = btPointer then
        begin
          Dest.aType := PIFPSVariantPointer(Tmp).DestType;
          Dest.P := PIFPSVariantPointer(Tmp).DataDest;
          if Dest.P = nil then
          begin
            Cmd_Err(erNullPointerException);
            Result := False;
            exit;
          end;
        end else
        begin
          Dest.aType := PIFPSVariantData(Tmp).vi.FType;
          Dest.P := @PIFPSVariantData(Tmp).Data;
        end;
        if FCurrentPosition + 3 >= FDataLength then
        begin
          CMD_Err(erOutOfRange);
          Result := False;
          exit;
        end;
        Param := Cardinal((@FData^[FCurrentPosition])^);
        Inc(FCurrentPosition, 4);
        case Dest.aType.BaseType of
          btRecord:
            begin
              if Param > Cardinal(TIFTypeRec_Record(Dest.aType).FFieldTypes.Count) then
              begin
                CMD_Err(erOutOfRange);
                Result := False;
                exit;
              end;
              Dest.P := Pointer(IPointer(Dest.P) + IPointer(TIFTypeRec_Record(Dest.aType).RealFieldOffsets[Param]));
              Dest.aType := TIFTypeRec_Record(Dest.aType).FieldTypes[Param];
            end;
          btArray:
            begin
              if Param >= Cardinal(IFPSDynArrayGetLength(Pointer(Dest.P^), dest.aType)) then
              begin
                CMD_Err(erOutOfRange);
                Result := False;
                exit;
              end;
              Dest.P := Pointer(IPointer(Dest.P^) + (Param * TIFTypeRec_Array(Dest.aType).FArrayType.RealSize));
              Dest.aType := TIFTypeRec_Array(dest.aType).ArrayType;
            end;
          btStaticArray:
            begin
              if Param >= Cardinal(TIFTypeRec_StaticArray(Dest.aType).Size) then
              begin
                CMD_Err(erOutOfRange);
                Result := False;
                exit;
              end;
              Dest.P := Pointer(IPointer(Dest.P) + (Param * TIFTypeRec_Array(Dest.aType).FArrayType.RealSize));
              Dest.aType := TIFTypeRec_Array(dest.aType).ArrayType;
            end;
        else
          CMD_Err(erInvalidType);
          Result := False;
          exit;
        end;

        if UsePointer and (Dest.aType.BaseType = btPointer) then
        begin
          Dest.aType := TIFTypeRec(Pointer(IPointer(Dest.p)+4)^);
          Dest.P := Pointer(Dest.p^);
          if Dest.P = nil then
          begin
            Cmd_Err(erNullPointerException);
            Result := False;
            exit;
          end;
        end;
      end;
    3:
      begin
        Dest.FreeType := vtNone;
        if Param < IFPSAddrNegativeStackStart then begin
          if Param >= Cardinal(FGlobalVars.Count) then
          begin
            CMD_Err(erOutOfGlobalVarsRange);
            Result := False;
            exit;
          end;
          Tmp := FGlobalVars.Data[param];
        end
        else begin
          Param := Cardinal(Longint(-IFPSAddrStackStart) + Longint(FCurrStackBase) + Longint(Param));
          if Param >= Cardinal(FStack.Count) then
          begin
            CMD_Err(erOutOfStackRange);
            Result := False;
            exit;
          end;
          Tmp := FStack.Data[param];
        end;
        if (Tmp.FType.BaseType = btPointer) then
        begin
          Dest.aType := PIFPSVariantPointer(Tmp).DestType;
          Dest.P := PIFPSVariantPointer(Tmp).DataDest;
          if Dest.P = nil then
          begin
            Cmd_Err(erNullPointerException);
            Result := False;
            exit;
          end;
        end else
        begin
          Dest.aType := PIFPSVariantData(Tmp).vi.FType;
          Dest.P := @PIFPSVariantData(Tmp).Data;
        end;
        Param := Cardinal((@FData^[FCurrentPosition])^);
        Inc(FCurrentPosition, 4);
        if Param < IFPSAddrNegativeStackStart then
        begin
          if Param >= Cardinal(FGlobalVars.Count) then
          begin
            CMD_Err(erOutOfGlobalVarsRange);
            Result := false;
            exit;
          end;
          Tmp := FGlobalVars[Param];
        end
        else begin
          Param := Cardinal(Longint(-IFPSAddrStackStart) + Longint(FCurrStackBase) + Longint(Param));
          if Cardinal(Param) >= Cardinal(FStack.Count) then
          begin
            CMD_Err(erOutOfStackRange);
            Result := false;
            exit;
          end;
          Tmp := FStack[Param];
        end;
        case Tmp.FType.BaseType of
          btu8: Param := PIFPSVariantU8(Tmp).Data;
          bts8: Param := PIFPSVariants8(Tmp).Data;
          btu16: Param := PIFPSVariantU16(Tmp).Data;
          bts16: Param := PIFPSVariants16(Tmp).Data;
          btu32, btProcPtr: Param := PIFPSVariantU32(Tmp).Data;
          bts32: Param := PIFPSVariants32(Tmp).Data;
          btPointer:
            begin
              if PIFPSVariantPointer(tmp).DestType <> nil then
              begin
                case PIFPSVariantPointer(tmp).DestType.BaseType of
                  btu8: Param := tbtu8(PIFPSVariantPointer(tmp).DataDest^);
                  bts8: Param := tbts8(PIFPSVariantPointer(tmp).DataDest^);
                  btu16: Param := tbtu16(PIFPSVariantPointer(tmp).DataDest^);
                  bts16: Param := tbts16(PIFPSVariantPointer(tmp).DataDest^);
                  btu32, btProcPtr: Param := tbtu32(PIFPSVariantPointer(tmp).DataDest^);
                  bts32: Param := tbts32(PIFPSVariantPointer(tmp).DataDest^);
                  else
                    begin
                      CMD_Err(ErTypeMismatch);
                      Result := false;
                      exit;
                    end;
                end;
              end else
              begin
                CMD_Err(ErTypeMismatch);
                Result := false;
                exit;
              end;
            end;
        else
          CMD_Err(ErTypeMismatch);
          Result := false;
          exit;
        end;
        case Dest.aType.BaseType of
          btRecord:
            begin
              if Param > Cardinal(TIFTypeRec_Record(Dest.aType).FFieldTypes.Count) then
              begin
                CMD_Err(erOutOfRange);
                Result := False;
                exit;
              end;
              Dest.P := Pointer(IPointer(Dest.P) + IPointer(TIFTypeRec_Record(Dest.aType).RealFieldOffsets[Param]));
              Dest.aType := TIFTypeRec_Record(Dest.aType).FieldTypes[Param];
            end;
          btArray:
            begin
              if Cardinal(Param) >= Cardinal(IFPSDynArrayGetLength(Pointer(Dest.P^), dest.aType)) then
              begin
                CMD_Err(erOutOfRange);
                Result := False;
                exit;
              end;
              Dest.P := Pointer(IPointer(Dest.P^) + (Param * TIFTypeRec_Array(Dest.aType).FArrayType.RealSize));
              Dest.aType := TIFTypeRec_Array(dest.aType).ArrayType;
            end;
          btStaticArray:
            begin
              if Param >= Cardinal(TIFTypeRec_StaticArray(Dest.aType).Size) then
              begin
                CMD_Err(erOutOfRange);
                Result := False;
                exit;
              end;
              Dest.P := Pointer(IPointer(Dest.P) + (Param * TIFTypeRec_Array(Dest.aType).FArrayType.RealSize));
              Dest.aType := TIFTypeRec_Array(dest.aType).ArrayType;
            end;
        else
          CMD_Err(erInvalidType);
          Result := False;
          exit;
        end;
        if UsePointer and (Dest.aType.BaseType = btPointer) then
        begin
          Dest.aType := TIFTypeRec(Pointer(IPointer(Dest.p)+4)^);
          Dest.P := Pointer(Dest.p^);
          if Dest.P = nil then
          begin
            Cmd_Err(erNullPointerException);
            Result := False;
            exit;
          end;
        end;
      end;
  else
    begin
      Result := False;
      exit;
    end;
  end;
  Result := true;
end;

function TIFPSExec.DoMinus(Dta: Pointer; aType: TIFTypeRec): Boolean;
begin
  case atype.BaseType of
    btU8: tbtu8(dta^) := -tbtu8(dta^);
    btU16: tbtu16(dta^) := -tbtu16(dta^);
    btU32: tbtu32(dta^) := -tbtu32(dta^);
    btS8: tbts8(dta^) := -tbts8(dta^);
    btS16: tbts16(dta^) := -tbts16(dta^);
    btS32: tbts32(dta^) := -tbts32(dta^);
    {$IFNDEF IFPS3_NOINT64}
    bts64: tbts64(dta^) := -tbts64(dta^);
    {$ENDIF}
    btSingle: tbtsingle(dta^) := -tbtsingle(dta^);
    btDouble: tbtdouble(dta^) := -tbtdouble(dta^);
    btExtended: tbtextended(dta^) := -tbtextended(dta^);
    btCurrency: tbtcurrency(dta^) := -tbtcurrency(dta^);
    btVariant:
      begin
        try
          Variant(dta^) := - Variant(dta^);
        except
          CMD_Err(erTypeMismatch);
          Result := False;
          exit;
        end;
      end;
  else
    begin
      CMD_Err(erTypeMismatch);
      Result := False;
      exit;
    end;
  end;
  Result := True;
end;

function TIFPSExec.DoBooleanNot(Dta: Pointer; aType: TIFTypeRec): Boolean;
begin
  case aType.BaseType of
    btU8: tbtu8(dta^) := tbtu8(tbtu8(dta^) = 0);
    btU16: tbtu16(dta^) := tbtu16(tbtu16(dta^) = 0);
    btU32: tbtu32(dta^) := tbtu32(tbtu32(dta^) = 0);
    btS8: tbts8(dta^) := tbts8(tbts8(dta^) = 0);
    btS16: tbts16(dta^) := tbts16(tbts16(dta^) = 0);
    btS32: tbts32(dta^) := tbts32(tbts32(dta^) = 0);
    {$IFNDEF IFPS3_NOINT64}
    bts64: tbts64(dta^) := tbts64(tbts64(dta^) = 0);
    {$ENDIF}
    btVariant:
      begin
        try
          Variant(dta^) := Variant(dta^) = 0;
        except
          CMD_Err(erTypeMismatch);
          Result := False;
          exit;
        end;
      end;
  else
    begin
      CMD_Err(erTypeMismatch);
      Result := False;
      exit;
    end;
  end;
  Result := True;
end;


procedure TIFPSExec.Stop;
begin
  if FStatus = isRunning then
    FStatus := isLoaded
  else if FStatus = isPaused then begin
    FStatus := isLoaded;
    FStack.Clear;
    FTempVars.Clear;
  end;
end;


function TIFPSExec.ReadLong(var b: Cardinal): Boolean;
begin
  if FCurrentPosition + 3 < FDataLength then begin
    b := Cardinal((@FData^[FCurrentPosition])^);
    Inc(FCurrentPosition, 4);
    Result := True;
  end
  else
    Result := False;
end;

function TIFPSExec.RunProcP(const Params: array of Variant; const Procno: Cardinal): Variant;
var
  ParamList: TIfList;
  ct: PIFTypeRec;
  pvar: PIFPSVariant;
  res, s: string;
  Proc: TIFInternalProcRec;
  i: Longint;
begin
  if ProcNo >= FProcs.Count then raise Exception.Create('Unknown Procedure');
  Proc := GetProcNo(ProcNo) as TIFInternalProcRec;
  ParamList := TIfList.Create;
  try
    s := Proc.ExportDecl;
    res := grfw(s);
    i := High(Params);
    while s <> '' do
    begin
      if i < 0 then raise Exception.Create('Not enough parameters');
      ct := FTypes[StrToInt(copy(GRLW(s), 2, MaxInt))];
      if ct = nil then raise Exception.Create('Invalid Parameter');
      pvar := CreateHeapVariant(ct);
      ParamList.Add(pvar);

      if not VariantToPIFVariant(Self, Params[i], pvar) then raise Exception.Create('Invalid Parameter');

      Dec(i);
    end;
    if I > -1 then raise Exception.Create('Too many parameters');
    if res <> '-1' then
    begin
      pvar := CreateHeapVariant(FTypes[StrToInt(res)]);
      ParamList.Add(pvar);
    end else
      pvar := nil;

    RunProc(ParamList, ProcNo);

    RaiseCurrentException;

    if pvar <> nil then
    begin
      PIFVariantToVariant(PVar, Result);
    end else
      Result := Null;
  finally
    FreePIFVariantList(ParamList);
  end;
end;

function TIFPSExec.RunProcPN(const Params: array of Variant; const ProcName: string): Variant;
var
  ProcNo: Cardinal;
begin
  ProcNo := GetProc(ProcName);
  if ProcNo = InvalidVal then
    raise Exception.Create('Unknown Procedure');
  Result := RunProcP(Params, ProcNo);
end;


function TIFPSExec.RunProc(Params: TIfList; ProcNo: Cardinal): Boolean;
var
  I, I2: Integer;
  vnew, Vd: PIfVariant;
  Cp: TIFInternalProcRec;
  oldStatus: TIFStatus;
begin
  if FStatus <> isNotLoaded then begin
    if ProcNo >= FProcs.Count then begin
      CMD_Err(erOutOfProcRange);
      Result := False;
      exit;
    end;
    if TIFProcRec(FProcs.Data^[ProcNo]).ClassType = TIFExternalProcRec then
    begin
      CMD_Err(erOutOfProcRange);
      Result := False;
      exit;
    end;
    if Params <> nil then
    begin
      for I := 0 to Params.Count - 1 do
      begin
        vd := Params[I];
        if vd = nil then
        begin
          Result := False;
          exit;
        end;
        vnew := FStack.PushType(FindType2(btPointer));
        if vd.FType.BaseType = btPointer then
        begin
          PIFPSVariantPointer(vnew).DestType := PIFPSVariantPointer(vd).DestType;
          PIFPSVariantPointer(vnew).DataDest := PIFPSVariantPointer(vd).DataDest;
        end else begin
          PIFPSVariantPointer(vnew).DestType := vd.FType;
          PIFPSVariantPointer(vnew).DataDest := @PIFPSVariantData(vd).Data;
        end;
      end;
    end;
    I := FStack.Count;
    vd := FStack.PushType(FReturnAddressType);
    PIFPSVariantReturnAddress(vd).Addr.ProcNo := nil;
    PIFPSVariantReturnAddress(vd).Addr.Position := FCurrentPosition;
    PIFPSVariantReturnAddress(vd).Addr.StackBase := FCurrStackBase;
    Cp := FCurrProc;
    FCurrStackBase := FStack.Count - 1;
    FCurrProc := FProcs.Data^[ProcNo];
    FData := FCurrProc.Data;
    FDataLength := FCurrProc.Length;
    FCurrentPosition := 0;
    oldStatus := FStatus;
    FStatus := isPaused;
    Result := RunScript;
    if Cardinal(FStack.Count) > Cardinal(I) then
    begin
      vd := FStack[I];
      if (vd <> nil) and (vd.FType = FReturnAddressType) then
      begin
        for i2 := FStack.Count - 1 downto I + 1 do
          FStack.Pop;
        FCurrentPosition := PIFPSVariantReturnAddress(vd).Addr.Position;
        FCurrStackBase := PIFPSVariantReturnAddress(vd).Addr.StackBase;
        FStack.Pop;
      end;
    end;
    if Params <> nil then
    begin
      for I := Params.Count - 1 downto 0 do
      begin
        if FStack.Count = 0 then
          Break
        else
          FStack.Pop;
      end;
    end;
    FStatus := oldStatus;
    FCurrProc := Cp;
    if FCurrProc <> nil then
    begin
      FData := FCurrProc.Data;
      FDataLength := FCurrProc.Length;
    end;
  end else begin
    Result := False;
  end;
end;


function TIFPSExec.FindType2(BaseType: TIFPSBaseType): PIFTypeRec;
var
  l: Cardinal;
begin
  FindType2 := FindType(0, BaseType, l);

end;

function TIFPSExec.FindType(StartAt: Cardinal; BaseType: TIFPSBaseType; var l: Cardinal): PIFTypeRec;
var
  I: Integer;
  n: PIFTypeRec;
begin
  for I := StartAt to FTypes.Count - 1 do begin
    n := FTypes[I];
    if n.BaseType = BaseType then begin
      l := I;
      Result := n;
      exit;
    end;
  end;
  Result := nil;
end;

function TIFPSExec.GetTypeNo(l: Cardinal): PIFTypeRec;
begin
  Result := FTypes[l];
end;

function TIFPSExec.GetProc(const Name: string): Cardinal;
var
  MM,
    I: Longint;
  n: PIFProcRec;
  s: string;
begin
  s := FastUpperCase(name);
  MM := MakeHash(s);
  for I := FProcs.Count - 1 downto 0 do begin
    n := FProcs.Data^[I];
    if (n.ClassType = TIFInternalProcRec) and (TIFInternalProcRec(n).ExportNameHash = MM) and (TIFInternalProcRec(n).ExportName = s) then begin
      Result := I;
      exit;
    end;
  end;
  Result := InvalidVal;
end;

function TIFPSExec.GetType(const Name: string): Cardinal;
var
  MM,
    I: Longint;
  n: PIFTypeRec;
  s: string;
begin
  s := FastUpperCase(name);
  MM := MakeHash(s);
  for I := 0 to FTypes.Count - 1 do begin
    n := FTypes.Data^[I];
    if (Length(n.ExportName) <> 0) and (n.ExportNameHash = MM) and (n.ExportName = s) then begin
      Result := I;
      exit;
    end;
  end;
  Result := InvalidVal;
end;


procedure TIFPSExec.AddResource(Proc, P: Pointer);
var
  Temp: PIFPSResource;
begin
  New(Temp);
  Temp^.Proc := Proc;
  Temp^.P := p;
  FResources.Add(temp);
end;

procedure TIFPSExec.DeleteResource(P: Pointer);
var
  i: Longint;
begin
  for i := Longint(FResources.Count) -1 downto 0 do
  begin
    if PIFPSResource(FResources[I])^.P = P then
    begin
      FResources.Delete(I);
      exit;
    end;
  end;
end;

function TIFPSExec.FindProcResource(Proc: Pointer): Pointer;
var
  I: Longint;
  temp: PIFPSResource;
begin
  for i := Longint(FResources.Count) -1 downto 0 do
  begin
    temp := FResources[I];
    if temp^.Proc = proc then
    begin
      Result := Temp^.P;
      exit;
    end;
  end;
  Result := nil;
end;

function TIFPSExec.IsValidResource(Proc, P: Pointer): Boolean;
var
  i: Longint;
  temp: PIFPSResource;
begin
  for i := 0 to Longint(FResources.Count) -1 do
  begin
    temp := FResources[i];
    if temp^.p = p then begin
      result := temp^.Proc = Proc;
      exit;
    end;
  end;
  result := false;
end;

function TIFPSExec.FindProcResource2(Proc: Pointer;
  var StartAt: Longint): Pointer;
var
  I: Longint;
  temp: PIFPSResource;
begin
  if StartAt > longint(FResources.Count) -1 then 
    StartAt := longint(FResources.Count) -1;
  for i := StartAt downto 0 do
  begin
    temp := FResources[I];
    if temp^.Proc = proc then
    begin
      Result := Temp^.P;
      StartAt := i -1;
      exit;
    end;
  end;
  StartAt := -1;
  Result := nil;
end;

procedure TIFPSExec.RunLine;
begin
  if @FOnRunLine <> nil then
    FOnRunLine(Self);
end;

procedure TIFPSExec.CMD_Err3(EC: TIFError; const Param: string; ExObject: TObject);
var
  l: Longint;
  C: Cardinal;
begin
  C := InvalidVal;
  for l := FProcs.Count - 1 downto 0 do begin
    if FProcs.Data^[l] = FCurrProc then begin
      C := l;
      break;
    end;
  end;
  if @FOnException <> nil then
    FOnException(Self, Ec, Param, ExObject, C, FCurrentPosition);
  ExceptionProc(C, FCurrentPosition, EC, Param, ExObject);
end;

procedure TIFPSExec.AddSpecialProcImport(const FName: string;
  P: TIFPSOnSpecialProcImport; Tag: Pointer);
var
  N: PSpecialProc;
begin
  New(n);
  n^.P := P;
  N^.Name := FName;
  n^.namehash := MakeHash(N^.Name);
  n^.Tag := Tag;
  FSpecialProcList.Add(n);
end;

function TIFPSExec.GetVar(const Name: string): Cardinal;
var
  l: Longint;
  h: longint;
  s: string;
  p: PIFPSExportedVar;
begin
  s := FastUpperCase(name);
  h := MakeHash(s);
  for l := FExportedVars.Count - 1 downto 0 do
  begin
    p := FexportedVars.Data^[L];
    if (p^.FNameHash = h) and(p^.FName=s) then
    begin
      Result := L;
      exit;
    end;
  end;
  Result := InvalidVal;
end;

function TIFPSExec.GetVarNo(C: Cardinal): PIFVariant;
begin
  Result := FGlobalVars[c];
end;

function TIFPSExec.GetVar2(const Name: string): PIFVariant;
begin
  Result := GetVarNo(GetVar(Name));
end;

function TIFPSExec.GetProcNo(C: Cardinal): PIFProcRec;
begin
  Result := FProcs[c];
end;

function TIFPSExec.DoIntegerNot(Dta: Pointer; aType: TIFTypeRec): Boolean;
begin
  case aType.BaseType of
    btU8: tbtu8(dta^) := not tbtu8(dta^);
    btU16: tbtu16(dta^) := not tbtu16(dta^);
    btU32: tbtu32(dta^) := not tbtu32(dta^);
    btS8: tbts8(dta^) := not tbts8(dta^);
    btS16: tbts16(dta^) := not tbts16(dta^);
    btS32: tbts32(dta^) := not tbts32(dta^);
    {$IFNDEF IFPS3_NOINT64}
    bts64: tbts64(dta^) := not tbts64(dta^);
    {$ENDIF}
    btVariant:
      begin
        try
          Variant(dta^) := not Variant(dta^);
        except
          CMD_Err(erTypeMismatch);
          Result := False;
          exit;
        end;
      end;
  else
    begin
      CMD_Err(erTypeMismatch);
      Result := False;
      exit;
    end;
  end;
  Result := True;
end;

type
  TMyRunLine = procedure(Self: TIFPSExec);
  TIFPSRunLine = procedure of object;

function GetRunLine(FOnRunLine: TIFPSOnLineEvent; meth: TIFPSRunLine): TMyRunLine;
begin
  if (TMethod(Meth).Code = @TIFPSExec.RunLine) and (@FOnRunLine = nil) then
    Result := nil
  else
    Result := TMethod(Meth).Code;
end;

function TIFPSExec.RunScript: Boolean;
var
  CalcType: Cardinal;
  vd, vs, v3: TIFPSResultData;
  vtemp: PIFVariant;
  p: Cardinal;
  P2: Longint;
  u: PIFProcRec;
  Cmd: Cardinal;
  I: Longint;
  pp: PIFPSExceptionHandler;
  FExitPoint: Cardinal;
  FOldStatus: TIFStatus;
  Tmp: TObject;
  btemp: Boolean;
  CallRunline: TMyRunLine;
begin
  FExitPoint := InvalidVal;
  if FStatus = isLoaded then
  begin
    for i := FExceptionStack.Count -1 downto 0 do
    begin
      pp := FExceptionStack.Data[i];
      Dispose(pp);
    end;
    FExceptionStack.Clear;
  end;
  ExceptionProc(InvalidVal, InvalidVal, erNoError, '', nil);
  RunScript := True;
  FOldStatus := FStatus;
  case FStatus of
    isLoaded: begin
        if FMainProc = InvalidVal then
        begin
          RunScript := False;
          exit;
        end;
        FStatus := isRunning;
        FCurrProc := FProcs.Data^[FMainProc];
        if FCurrProc.ClassType = TIFExternalProcRec then begin
          CMD_Err(erNoMainProc);
          FStatus := isLoaded;
          exit;
        end;
        FData := FCurrProc.Data;
        FDataLength := FCurrProc.Length;
        FCurrStackBase := InvalidVal;
        FCurrentPosition := 0;
      end;
    isPaused: begin
        FStatus := isRunning;
      end;
  else begin
      RunScript := False;
      exit;
    end;
  end;
  CallRunLine := GetRunLine(FOnRunLine, Self.RunLine);
  repeat
    FStatus := isRunning;
//    Cmd := InvalidVal;
    while FStatus = isRunning do
    begin
      if @CallRunLine <> nil then CallRunLine(Self);
      if FCurrentPosition >= FDataLength then
      begin
        CMD_Err(erOutOfRange); // Error
        break;
      end;
//      if cmd <> invalidval then ProfilerExitProc(Cmd+1);
      cmd := FData^[FCurrentPosition];
//      ProfilerEnterProc(Cmd+1);
      Inc(FCurrentPosition);
        case Cmd of
          CM_A:
            begin
              if not ReadVariable(vd, True) then
                break;
              if vd.FreeType <> vtNone then
              begin
                if vd.aType.BaseType in NeedFinalization then
                  FinalizeVariant(vd.P, vd.aType);
                p := IPointer(FTempVars.Data^[FtempVars.Count-1]) - IPointer(FtempVars.DataPtr);
                Dec(FTempVars.FCount);
                {$IFNDEF IFPS3_NOSMARTLIST}
                Inc(FTempVars.FCheckCount);
                if FTempVars.FCheckCount > FMaxCheckCount then FTempVars.Recreate;
                {$ENDIF}
                FTempVars.FLength := P;
                if ((FTempVars.FCapacity - FTempVars.FLength) shr 12) > 2 then FTempVars.AdjustLength;

                CMD_Err(erInvalidOpcodeParameter);
                break;
              end;
              if not ReadVariable(vs, True) then
                Break;
              if not SetVariantValue(vd.P, vs.P, vd.aType, vs.aType) then
              begin
                if vs.FreeType <> vtNone then
                begin
                  if vs.aType.BaseType in NeedFinalization then
                  FinalizeVariant(vs.P, vs.aType);
                  p := IPointer(FTempVars.Data^[FtempVars.Count-1]) - IPointer(FtempVars.DataPtr);
                  Dec(FTempVars.FCount);
                  {$IFNDEF IFPS3_NOSMARTLIST}
                  Inc(FTempVars.FCheckCount);
                  if FTempVars.FCheckCount > FMaxCheckCount then FTempVars.Recreate;
                  {$ENDIF}
                  FTempVars.FLength := P;
                  if ((FTempVars.FCapacity - FTempVars.FLength) shr 12) > 2 then FTempVars.AdjustLength;
                end;
                Break;
              end;
              if vs.FreeType <> vtNone then
              begin
                if vs.aType.BaseType in NeedFinalization then
                FinalizeVariant(vs.P, vs.aType);
                p := IPointer(FTempVars.Data^[FtempVars.Count-1]) - IPointer(FtempVars.DataPtr);
                Dec(FTempVars.FCount);
                {$IFNDEF IFPS3_NOSMARTLIST}
                Inc(FTempVars.FCheckCount);
                if FTempVars.FCheckCount > FMaxCheckCount then FTempVars.Recreate;
                {$ENDIF}
                FTempVars.FLength := P;
                if ((FTempVars.FCapacity - FTempVars.FLength) shr 12) > 2 then FTempVars.AdjustLength;
              end;
            end;
          CM_CA:
            begin
              if FCurrentPosition >= FDataLength then
              begin
                CMD_Err(erOutOfRange); // Error
                break;
              end;
              calctype := FData^[FCurrentPosition];
              Inc(FCurrentPosition);
              if not ReadVariable(vd, True) then
                break;
              if vd.FreeType <> vtNone then
              begin
                if vd.aType.BaseType in NeedFinalization then
                FinalizeVariant(vd.P, vd.aType);
                p := IPointer(FTempVars.Data^[FtempVars.Count-1]) - IPointer(FtempVars.DataPtr);
                Dec(FTempVars.FCount);
                {$IFNDEF IFPS3_NOSMARTLIST}
                Inc(FTempVars.FCheckCount);
                if FTempVars.FCheckCount > FMaxCheckCount then FTempVars.Recreate;
                {$ENDIF}
                FTempVars.FLength := P;
                if ((FTempVars.FCapacity - FTempVars.FLength) shr 12) > 2 then FTempVars.AdjustLength;
                CMD_Err(erInvalidOpcodeParameter);
                break;
              end;
              if not ReadVariable(vs, True) then
                Break;
              if not DoCalc(vd.P, vs.p, vd.aType, vs.aType, CalcType) then
              begin
                if vs.FreeType <> vtNone then
                begin
                  if vs.aType.BaseType in NeedFinalization then
                  FinalizeVariant(vs.P, vs.aType);
                  p := IPointer(FTempVars.Data^[FtempVars.Count-1]) - IPointer(FtempVars.DataPtr);
                  Dec(FTempVars.FCount);
                  {$IFNDEF IFPS3_NOSMARTLIST}
                  Inc(FTempVars.FCheckCount);
                  if FTempVars.FCheckCount > FMaxCheckCount then FTempVars.Recreate;
                  {$ENDIF}
                  FTempVars.FLength := P;
                  if ((FTempVars.FCapacity - FTempVars.FLength) shr 12) > 2 then FTempVars.AdjustLength;
                end;
                Break;
              end;
              if vs.FreeType <> vtNone then
              begin
                if vs.aType.BaseType in NeedFinalization then
                FinalizeVariant(vs.P, vs.aType);
                p := IPointer(FTempVars.Data^[FtempVars.Count-1]) - IPointer(FtempVars.DataPtr);
                Dec(FTempVars.FCount);
                {$IFNDEF IFPS3_NOSMARTLIST}
                Inc(FTempVars.FCheckCount);
                if FTempVars.FCheckCount > FMaxCheckCount then FTempVars.Recreate;
                {$ENDIF}
                FTempVars.FLength := P;
                if ((FTempVars.FCapacity - FTempVars.FLength) shr 12) > 2 then FTempVars.AdjustLength;
              end;
            end;
          CM_P:
            begin
              if not ReadVariable(vs, True) then
                Break;
              vtemp := FStack.PushType(vs.aType);
              vd.P := Pointer(IPointer(vtemp)+4);
              vd.aType := Pointer(vtemp^);
              vd.FreeType := vtNone;
              if not SetVariantValue(Vd.P, vs.P, vd.aType, vs.aType) then
              begin
                if vs.FreeType <> vtnone then
                begin
                  if vs.aType.BaseType in NeedFinalization then
                    FinalizeVariant(vs.P, vs.aType);
                  p := IPointer(FTempVars.Data^[FtempVars.Count-1]) - IPointer(FtempVars.DataPtr);
                  Dec(FTempVars.FCount);
                  {$IFNDEF IFPS3_NOSMARTLIST}
                  Inc(FTempVars.FCheckCount);
                  if FTempVars.FCheckCount > FMaxCheckCount then FTempVars.Recreate;
                  {$ENDIF}
                  FTempVars.FLength := P;
                  if ((FTempVars.FCapacity - FTempVars.FLength) shr 12) > 2 then FTempVars.AdjustLength;
                end;
                break;
              end;
              if vs.FreeType <> vtnone then
              begin
                if vs.aType.BaseType in NeedFinalization then
                  FinalizeVariant(vs.P, vs.aType);
                p := IPointer(FTempVars.Data^[FtempVars.Count-1]) - IPointer(FtempVars.DataPtr);
                Dec(FTempVars.FCount);
                {$IFNDEF IFPS3_NOSMARTLIST}
                Inc(FTempVars.FCheckCount);
                if FTempVars.FCheckCount > FMaxCheckCount then FTempVars.Recreate;
                {$ENDIF}
                FTempVars.FLength := P;
                if ((FTempVars.FCapacity - FTempVars.FLength) shr 12) > 2 then FTempVars.AdjustLength;
              end;
            end;
          CM_PV:
            begin
              if not ReadVariable(vs, True) then
                Break;
              if vs.FreeType <> vtnone then
              begin
                FTempVars.Pop;
                CMD_Err(erInvalidOpcodeParameter);
                break;
              end;
              vtemp := FStack.PushType(FindType2(btPointer));
              if vs.aType.BaseType = btPointer then
              begin
                PIFPSVariantPointer(vtemp).DataDest := Pointer(vs.p^);
                PIFPSVariantPointer(vtemp).DestType := Pointer(Pointer(IPointer(vs.P)+4)^);
                PIFPSVariantPointer(vtemp).FreeIt := False;
              end
              else
              begin
                PIFPSVariantPointer(vtemp).DataDest := vs.p;
                PIFPSVariantPointer(vtemp).DestType := vs.aType;
                PIFPSVariantPointer(vtemp).FreeIt := False;
              end;
            end;
          CM_PO: begin
              if FStack.Count = 0 then
              begin
                CMD_Err(erOutOfStackRange);
                break;
              end;
              vtemp := FStack.Data^[FStack.Count -1];
              if (vtemp = nil) or (vtemp.FType.BaseType = btReturnAddress) then
              begin
                CMD_Err(erOutOfStackRange);
                break;
              end;
              Dec(FStack.FCount);
              {$IFNDEF IFPS3_NOSMARTLIST}
              Inc(FStack.FCheckCount);
              if FStack.FCheckCount > FMaxCheckCount then FStack.Recreate;
              {$ENDIF}
              FStack.FLength := Longint(IPointer(vtemp) - IPointer(FStack.DataPtr));
              if TIFTypeRec(vtemp^).BaseType in NeedFinalization then
                FinalizeVariant(Pointer(IPointer(vtemp)+4), Pointer(vtemp^));
              if ((FStack.FCapacity - FStack.FLength) shr 12) > 2 then FStack.AdjustLength;
            end;
          Cm_C: begin
              if FCurrentPosition + 3 >= FDataLength then
              begin
                Cmd_Err(erOutOfRange);
                Break;
              end;
              p := Cardinal((@FData^[FCurrentPosition])^);
              Inc(FCurrentPosition, 4);
              if p >= FProcs.Count then begin
                CMD_Err(erOutOfProcRange);
                break;
              end;
              u := FProcs.Data^[p];
              if u.ClassType = TIFExternalProcRec then begin
                try
                  if not TIFExternalProcRec(u).ProcPtr(Self, TIFExternalProcRec(u), FGlobalVars, FStack) then
                  begin
                    if ExEx = erNoError then
                      CMD_Err(erCouldNotCallProc);
                    Break;
                  end;
                except
                  {$IFDEF IFPS3_D6PLUS}
                  Tmp := AcquireExceptionObject;
                  {$ELSE}
                  if RaiseList <> nil then
                  begin
                    Tmp := Exception(PRaiseFrame(RaiseList)^.ExceptObject);
                    PRaiseFrame(RaiseList)^.ExceptObject := nil;
                  end else
                    Tmp := nil;
                  {$ENDIF}
                  if Tmp <> nil then
                  begin
                    if Tmp is EIFPS3Exception then
                    begin
                      Result := False;
                      ExceptionProc(EIFPS3Exception(tmp).ProcNo, EIFPS3Exception(tmp).ProcPos, erCustomError, EIFPS3Exception(tmp).Message, nil);
                      exit;
                    end else
                    if Tmp is EDivByZero then
                    begin
                      Result := False;
                      CMD_Err3(erDivideByZero, '', Tmp);
                      Exit;
                    end;
                    if Tmp is EZeroDivide then
                    begin
                      Result := False;
                      CMD_Err3(erDivideByZero, '', Tmp);
                      Exit;
                    end;
                    if Tmp is EMathError then
                    begin
                      Result := False;
                      CMD_Err3(erMathError, '', Tmp);
                      Exit;
                    end;
                  end;
                  if (Tmp <> nil) and (Tmp is Exception) then
                    CMD_Err3(erException, Exception(Tmp).Message, Tmp) else
                    CMD_Err3(erException, '', Tmp);
                  Break;
                end;
              end
              else begin
                Vtemp := Fstack.PushType(FReturnAddressType);
                vd.P := Pointer(IPointer(VTemp)+4);
                vd.aType := pointer(vtemp^);
                vd.FreeType := vtNone;
                PIFPSVariantReturnAddress(vtemp).Addr.ProcNo := FCurrProc;
                PIFPSVariantReturnAddress(vtemp).Addr.Position := FCurrentPosition;
                PIFPSVariantReturnAddress(vtemp).Addr.StackBase := FCurrStackBase;

                FCurrStackBase := FStack.Count - 1;
                FCurrProc := TIFInternalProcRec(u);
                FData := FCurrProc.Data;
                FDataLength := FCurrProc.Length;
                FCurrentPosition := 0;
              end;
            end;
          Cm_G:
            begin
              if FCurrentPosition + 3 >= FDataLength then
              begin
                Cmd_Err(erOutOfRange);
                Break;
              end;
              p := Cardinal((@FData^[FCurrentPosition])^);
              Inc(FCurrentPosition, 4);
              FCurrentPosition := FCurrentPosition + p;
            end;
          Cm_CG:
            begin
              if FCurrentPosition + 3 >= FDataLength then
              begin
                Cmd_Err(erOutOfRange);
                Break;
              end;
              p := Cardinal((@FData^[FCurrentPosition])^);
              Inc(FCurrentPosition, 4);
              btemp := true;
              if not ReadVariable(vs, btemp) then
                Break;
              case Vs.aType.BaseType of
                btU8: btemp := tbtu8(vs.p^) <> 0;
                btS8: btemp := tbts8(vs.p^) <> 0;
                btU16: btemp := tbtu16(vs.p^) <> 0;
                btS16: btemp := tbts16(vs.p^) <> 0;
                btU32, btProcPtr: btemp := tbtu32(vs.p^) <> 0;
                btS32: btemp := tbts32(vs.p^) <> 0;
              else begin
                  CMD_Err(erInvalidType);
                  if vs.FreeType <> vtNone then
                    FTempVars.Pop;
                  break;
                end;
              end;
              if vs.FreeType <> vtNone then
                FTempVars.Pop;
              if btemp then
                FCurrentPosition := FCurrentPosition + p;
            end;
          Cm_CNG:
            begin
              if FCurrentPosition + 3 >= FDataLength then
              begin
                Cmd_Err(erOutOfRange);
                Break;
              end;
              p := Cardinal((@FData^[FCurrentPosition])^);
              Inc(FCurrentPosition, 4);
              btemp := true;
              if not ReadVariable(vs, BTemp) then
                Break;
              case Vs.aType.BaseType of
                btU8: btemp := tbtu8(vs.p^) = 0;
                btS8: btemp := tbts8(vs.p^) = 0;
                btU16: btemp := tbtu16(vs.p^) = 0;
                btS16: btemp := tbts16(vs.p^) = 0;
                btU32, btProcPtr: btemp := tbtu32(vs.p^) = 0;
                btS32: btemp := tbts32(vs.p^) = 0;
              else begin
                  CMD_Err(erInvalidType);
                  if vs.FreeType <> vtNone then
                    FTempVars.Pop;
                  break;
                end;
              end;
              if vs.FreeType <> vtNone then
                FTempVars.Pop;
              if btemp then
                FCurrentPosition := FCurrentPosition + p;
            end;
          Cm_R: begin
              FExitPoint := FCurrentPosition -1;
              P2 := 0;
              if FExceptionStack.Count > 0 then
              begin
                pp := FExceptionStack.Data[FExceptionStack.Count -1];
                if (pp^.BasePtr = FCurrStackBase) or ((pp^.BasePtr > FCurrStackBase) and (pp^.BasePtr <> InvalidVal)) then
                begin
                  if pp^.StackSize < Cardinal(FStack.Count) then
                  begin
                    for p := Longint(FStack.count) -1 downto Longint(pp^.StackSize) do
                      FStack.Pop
                  end;
                  FCurrStackBase := pp^.BasePtr;
                  if pp^.FinallyOffset <> InvalidVal then
                  begin
                    FCurrentPosition := pp^.FinallyOffset;
                    pp^.FinallyOffset := InvalidVal;
                    p2 := 1;
                  end else if pp^.Finally2Offset <> InvalidVal then
                  begin
                    FCurrentPosition := pp^.Finally2Offset;
                    pp^.Finally2Offset := InvalidVal;
                    p2 := 1;
                  end;
                end;
              end;
              if p2 = 0 then
              begin
                FExitPoint := InvalidVal;
                if FCurrStackBase = InvalidVal then
                begin
                  FStatus := FOldStatus;
                  break;
                end;
                for P2 := FStack.Count - 1 downto FCurrStackBase + 1 do
                  FStack.Pop;
                if FCurrStackBase >= FStack.Count  then
                begin
                  FStatus := FOldStatus;
                  break;
                end;
                vtemp := FStack.Data[FCurrStackBase];
                FCurrProc := PIFPSVariantReturnAddress(vtemp).Addr.ProcNo;
                FCurrentPosition := PIFPSVariantReturnAddress(vtemp).Addr.Position;
                FCurrStackBase := PIFPSVariantReturnAddress(vtemp).Addr.StackBase;
                FStack.Pop;
                if FCurrProc = nil then begin
                  FStatus := FOldStatus;
                  break;
                end;
                FData := FCurrProc.Data;
                FDataLength := FCurrProc.Length;
              end;
            end;
          Cm_Pt: begin
              if FCurrentPosition + 3 >= FDataLength then
              begin
                Cmd_Err(erOutOfRange);
                Break;
              end;
              p := Cardinal((@FData^[FCurrentPosition])^);
              Inc(FCurrentPosition, 4);
              if p > FTypes.Count then
              begin
                CMD_Err(erInvalidType);
                break;
              end;
              FStack.PushType(FTypes.Data^[p]);
            end;
          cm_bn:
            begin
              if not ReadVariable(vd, True) then
                Break;
              if vd.FreeType <> vtNone then
                FTempVars.Pop;
              if not DoBooleanNot(Vd.P, vd.aType) then
                break;
            end;
          cm_in:
            begin
              if not ReadVariable(vd, True) then
                Break;
              if vd.FreeType <> vtNone then
                FTempVars.Pop;
              if not DoIntegerNot(Vd.P, vd.aType) then
                break;
            end;
          cm_vm:
            begin
              if not ReadVariable(vd, True) then
                Break;
              if vd.FreeType <> vtNone then
                FTempVars.Pop;
              if not DoMinus(Vd.P, vd.aType) then
                break;
            end;
          cm_sf:
            begin
              if not ReadVariable(vd, True) then
                Break;
              if FCurrentPosition >= FDataLength then
              begin
                CMD_Err(erOutOfRange); // Error
                if vd.FreeType <> vtNone then
                  FTempVars.Pop;
                break;
              end;
              p := FData^[FCurrentPosition];
              Inc(FCurrentPosition);
              case Vd.aType.BaseType of
                btU8: FJumpFlag := tbtu8(Vd.p^) <> 0;
                btS8: FJumpFlag := tbts8(Vd.p^) <> 0;
                btU16: FJumpFlag := tbtu16(Vd.p^) <> 0;
                btS16: FJumpFlag := tbts16(Vd.p^) <> 0;
                btU32, btProcPtr: FJumpFlag := tbtu32(Vd.p^) <> 0;
                btS32: FJumpFlag := tbts32(Vd.p^) <> 0;
              else begin
                  CMD_Err(erInvalidType);
                  if vd.FreeType <> vtNone then
                    FTempVars.Pop;
                  break;
                end;
              end;
              if p <> 0 then
                FJumpFlag := not FJumpFlag;
              if vd.FreeType <> vtNone then
                FTempVars.Pop;
            end;
          cm_fg:
            begin
              if FCurrentPosition + 3 >= FDataLength then
              begin
                Cmd_Err(erOutOfRange);
                Break;
              end;
              p := Cardinal((@FData^[FCurrentPosition])^);
              Inc(FCurrentPosition, 4);
              if FJumpFlag then
                FCurrentPosition := FCurrentPosition + p;
            end;
          cm_puexh:
            begin
              New(pp);
              pp^.CurrProc := FCurrProc;
              pp^.BasePtr :=FCurrStackBase;
              pp^.StackSize := FStack.Count;
              if not ReadLong(pp^.FinallyOffset) then begin
                CMD_Err(erOutOfRange);
                Dispose(pp);
                Break;
              end;
              if not ReadLong(pp^.ExceptOffset) then begin
                CMD_Err(erOutOfRange);
                Dispose(pp);
                Break;
              end;
              if not ReadLong(pp^.Finally2Offset) then begin
                CMD_Err(erOutOfRange);
                Dispose(pp);
                Break;
              end;
              if not ReadLong(pp^.EndOfBlock) then begin
                CMD_Err(erOutOfRange);
                Dispose(pp);
                Break;
              end;
              if pp^.FinallyOffset <> InvalidVal then
                pp^.FinallyOffset := pp^.FinallyOffset + FCurrentPosition;
              if pp^.ExceptOffset <> InvalidVal then
                pp^.ExceptOffset := pp^.ExceptOffset + FCurrentPosition;
              if pp^.Finally2Offset <> InvalidVal then
                pp^.Finally2Offset := pp^.Finally2Offset + FCurrentPosition;
              if pp^.EndOfBlock <> InvalidVal then
                pp^.EndOfBlock := pp^.EndOfBlock + FCurrentPosition;
              if ((pp^.FinallyOffset <> InvalidVal) and (pp^.FinallyOffset >= FDataLength)) or
                ((pp^.ExceptOffset <> InvalidVal) and (pp^.ExceptOffset >= FDataLength)) or
                ((pp^.Finally2Offset <> InvalidVal) and (pp^.Finally2Offset >= FDataLength)) or
                ((pp^.EndOfBlock <> InvalidVal) and (pp^.EndOfBlock >= FDataLength)) then
                begin
                  CMD_Err(ErOutOfRange);
                  Dispose(pp);
                  Break;
                end;
                FExceptionStack.Add(pp);
            end;
          cm_poexh:
            begin
              if FCurrentPosition >= FDataLength then
              begin
                CMD_Err(erOutOfRange); // Error
                break;
              end;
              p := FData^[FCurrentPosition];
              Inc(FCurrentPosition);
              case p of
                2:
                  begin
                    ExceptionProc(InvalidVal, InvalidVal, erNoError, '', nil);
                    pp := FExceptionStack.Data^[FExceptionStack.Count -1];
                    if pp = nil then begin
                      cmd_err(ErOutOfRange);
                      Break;
                    end;
                    if pp^.Finally2Offset <> InvalidVal then
                    begin
                      FCurrentPosition := pp^.Finally2Offset;
                      pp^.Finally2Offset := InvalidVal;
                    end else begin
                      p := pp^.EndOfBlock;
                      Dispose(pp);
                      FExceptionStack.DeleteLast;
                      if FExitPoint <> InvalidVal then
                      begin
                        FCurrentPosition := FExitPoint;
                      end else begin
                        FCurrentPosition := p;
                      end;
                    end;
                  end;
                0:
                  begin
                    pp := FExceptionStack.Data^[FExceptionStack.Count -1];
                    if pp = nil then begin
                      cmd_err(ErOutOfRange);
                      Break;
                    end;
                    if pp^.FinallyOffset <> InvalidVal then
                    begin
                      FCurrentPosition := pp^.FinallyOffset;
                      pp^.FinallyOffset := InvalidVal;
                    end else if pp^.Finally2Offset <> InvalidVal then
                    begin
                       FCurrentPosition := pp^.Finally2Offset;
                       pp^.ExceptOffset := InvalidVal;
                    end else begin
                      p := pp^.EndOfBlock;
                      Dispose(pp);
                      FExceptionStack.DeleteLast;
                      if ExEx <> eNoError then
                      begin
                        Tmp := ExObject;
                        ExObject := nil;
                        ExceptionProc(ExProc, ExPos, ExEx, ExParam, Tmp);
                      end else
                      if FExitPoint <> InvalidVal then
                      begin
                        FCurrentPosition := FExitPoint;
                      end else begin
                        FCurrentPosition := p;
                      end;
                    end;
                  end;
                1:
                  begin
                    pp := FExceptionStack.Data^[FExceptionStack.Count -1];
                    if pp = nil then begin
                      cmd_err(ErOutOfRange);
                      Break;
                    end;
                    if (ExEx <> ENoError) and (pp^.ExceptOffset <> InvalidVal) then
                    begin
                      FCurrentPosition := pp^.ExceptOffset;
                      pp^.ExceptOffset := InvalidVal;
                    end else if (pp^.Finally2Offset <> InvalidVal) then
                    begin
                      FCurrentPosition := pp^.Finally2Offset;
                      pp^.Finally2Offset := InvalidVal;
                    end else begin
                      p := pp^.EndOfBlock;
                      Dispose(pp);
                      FExceptionStack.DeleteLast;
                      if ExEx <> eNoError then
                      begin
                        Tmp := ExObject;
                        ExObject := nil;
                        ExceptionProc(ExProc, ExPos, ExEx, ExParam, Tmp);
                      end else
                      if FExitPoint <> InvalidVal then
                      begin
                        FCurrentPosition := FExitPoint;
                      end else begin
                        FCurrentPosition := p;
                      end;
                    end;
                  end;
                3:
                  begin
                    pp := FExceptionStack.Data^[FExceptionStack.Count -1];
                    if pp = nil then begin
                      cmd_err(ErOutOfRange);
                      Break;
                    end;
                    p := pp^.EndOfBlock;
                    Dispose(pp);
                    FExceptionStack.DeleteLast;
                    if ExEx <> eNoError then
                    begin
                      Tmp := ExObject;
                      ExObject := nil;
                      ExceptionProc(ExProc, ExPos, ExEx, ExParam, Tmp);
                    end else
                    if FExitPoint <> InvalidVal then
                    begin
                      FCurrentPosition := FExitPoint;
                    end else begin
                      FCurrentPosition := p;
                    end;
                 end;
              end;
            end;
          cm_spc:
            begin
              if not ReadVariable(vd, False) then
                Break;
              if vd.FreeType <> vtNone then
              begin
                FTempVars.Pop;
                CMD_Err(erInvalidOpcodeParameter);
                break;
              end;
              if (Vd.aType.BaseType <> btPointer) then
              begin
                CMD_Err(erInvalidOpcodeParameter);
                break;
              end;
              if not ReadVariable(vs, False) then
                Break;
              if Pointer(Pointer(IPointer(vD.P)+8)^) <> nil then
                DestroyHeapVariant2(Pointer(vD.P^), Pointer(Pointer(IPointer(vd.P)+4)^));
              if vs.aType.BaseType = btPointer then
              begin
                if Pointer(vs.P^) <> nil then
                begin
                  Pointer(vd.P^) := CreateHeapVariant2(Pointer(Pointer(IPointer(vs.P) + 4)^));
                  Pointer(Pointer(IPointer(vd.P) + 4)^) := Pointer(Pointer(IPointer(vs.P) + 4)^);
                  Pointer(Pointer(IPointer(vd.P) + 8)^) := Pointer(1);
                  if not CopyArrayContents(Pointer(vd.P^), Pointer(vs.P^), 1, Pointer(Pointer(IPointer(vd.P) + 4)^)) then
                  begin
                    if vs.FreeType <> vtNone then
                      FTempVars.Pop;
                    CMD_Err(ErTypeMismatch);
                    break;
                  end;
                end else
                begin
                  Pointer(vd.P^) := nil;
                  Pointer(Pointer(IPointer(vd.P) + 4)^) := nil;
                  Pointer(Pointer(IPointer(vd.P) + 8)^) := nil;
                end;
              end else begin
                Pointer(vd.P^) := CreateHeapVariant2(vs.aType);
                Pointer(Pointer(IPointer(vd.P) + 4)^) := vs.aType;
                Pointer(Pointer(IPointer(vd.P) + 8)^) := Pointer(1);
                if not CopyArrayContents(Pointer(vd.P^), vs.P, 1, vs.aType) then
                begin
                  if vs.FreeType <> vtNone then
                    FTempVars.Pop;
                  CMD_Err(ErTypeMismatch);
                  break;
                end;
              end;
              if vs.FreeType <> vtNone then
                FTempVars.Pop;

            end;
          cm_nop:;
          cm_dec:
            begin
              if not ReadVariable(vd, True) then
                Break;
              if vd.FreeType <> vtNone then
              begin
                FTempVars.Pop;
                CMD_Err(erInvalidOpcodeParameter);
                break;
              end;
              case vd.aType.BaseType of
                btu8: dec(tbtu8(vd.P^));
                bts8: dec(tbts8(vd.P^));
                btu16: dec(tbtu16(vd.P^));
                bts16: dec(tbts16(vd.P^));
                btu32: dec(tbtu32(vd.P^));
                bts32: dec(tbts32(vd.P^));
{$IFNDEF IFPS3_NOINT64}
                bts64: dec(tbts64(vd.P^));
{$ENDIF}
              else
                begin
                  CMD_Err(ErTypeMismatch);
                  Break;
                end;
              end;
            end;
          cm_inc:
            begin
              if not ReadVariable(vd, True) then
                Break;
              if vd.FreeType <> vtNone then
              begin
                FTempVars.Pop;
                CMD_Err(erInvalidOpcodeParameter);
                break;
              end;
              case vd.aType.BaseType of
                btu8: Inc(tbtu8(vd.P^));
                bts8: Inc(tbts8(vd.P^));
                btu16: Inc(tbtu16(vd.P^));
                bts16: Inc(tbts16(vd.P^));
                btu32: Inc(tbtu32(vd.P^));
                bts32: Inc(tbts32(vd.P^));
{$IFNDEF IFPS3_NOINT64}
                bts64: Inc(tbts64(vd.P^));
{$ENDIF}
              else
                begin
                  CMD_Err(ErTypeMismatch);
                  Break;
                end;
              end;
            end;
          cm_sp:
            begin
              if not ReadVariable(vd, False) then
                Break;
              if vd.FreeType <> vtNone then
              begin
                FTempVars.Pop;
                CMD_Err(erInvalidOpcodeParameter);
                break;
              end;
              if (Vd.aType.BaseType <> btPointer) then
              begin
                CMD_Err(erInvalidOpcodeParameter);
                break;
              end;
              if not ReadVariable(vs, False) then
                Break;
              if vs.FreeType <> vtNone then
              begin
                FTempVars.Pop;
                CMD_Err(erInvalidOpcodeParameter);
                break;
              end;
              if vs.aType.BaseType = btPointer then
              begin
                Pointer(vd.P^) := Pointer(vs.p^);
                Pointer(Pointer(IPointer(vd.P)+4)^) := Pointer(Pointer(IPointer(vs.P)+4)^);
              end
              else
              begin
                Pointer(vd.P^) := vs.P;
                Pointer(Pointer(IPointer(vd.P)+4)^) := vs.aType;
              end;
            end;
          Cm_cv:
            begin
              if not ReadVariable(vd, True) then
                Break;
              if (Vd.aType.BaseType <> btU32) and (Vd.aType.BaseType <> btS32) and (vd.aType.BaseType <> btProcPtr) then
              begin
                if vd.FreeType <> vtNone then
                  FTempVars.Pop;
                CMD_Err(ErTypeMismatch);
                break;
              end;
              p := tbtu32(vd.P^);
              if vd.FreeType <> vtNone then
                FTempVars.Pop;
              if (p >= FProcs.Count) or (p = FMainProc) then begin
                CMD_Err(erOutOfProcRange);
                break;
              end;
              u := FProcs.Data^[p];
              if u.ClassType = TIFExternalProcRec then begin
                if not TIFExternalProcRec(u).ProcPtr(Self, TIFExternalProcRec(u), FGlobalVars, FStack) then
                  CMD_Err(erCouldNotCallProc);
              end
              else begin
                vtemp := FStack.PushType(FReturnAddressType);
                PIFPSVariantReturnAddress(vtemp).Addr.ProcNo := FCurrProc;
                PIFPSVariantReturnAddress(vtemp).Addr.Position := FCurrentPosition;
                PIFPSVariantReturnAddress(vtemp).Addr.StackBase := FCurrStackBase;
                FCurrStackBase := FStack.Count - 1;
                FCurrProc := TIFInternalProcRec(u);
                FData := FCurrProc.Data;
                FDataLength := FCurrProc.Length;
                FCurrentPosition := 0;
              end;
            end;
          CM_CO:
            begin
              if FCurrentPosition >= FDataLength then
              begin
                CMD_Err(erOutOfRange); // Error
                break;
              end;
              calctype := FData^[FCurrentPosition];
              Inc(FCurrentPosition);
              if not ReadVariable(v3, True) then
                Break;
              if v3.FreeType <> vtNone then
              begin
                if v3.aType.BaseType in NeedFinalization then
                  FinalizeVariant(v3.P, v3.aType);
                p := IPointer(FTempVars.Data^[FtempVars.Count-1]) - IPointer(FtempVars.DataPtr);
                Dec(FTempVars.FCount);
                {$IFNDEF IFPS3_NOSMARTLIST}
                Inc(FTempVars.FCheckCount);
                if FTempVars.FCheckCount > FMaxCheckCount then FTempVars.Recreate;
                {$ENDIF}
                FTempVars.FLength := P;
                if ((FTempVars.FCapacity - FTempVars.FLength) shr 12) > 2 then FTempVars.AdjustLength;
                CMD_Err(erInvalidOpcodeParameter);
                break;
              end;
              if not ReadVariable(vs, True) then
                Break;
              if not ReadVariable(vd, True) then
              begin
                if vs.FreeType <> vtNone then
                begin
                  if vs.aType.BaseType in NeedFinalization then
                    FinalizeVariant(vs.P, vs.aType);
                  p := IPointer(FTempVars.Data^[FtempVars.Count-1]) - IPointer(FtempVars.DataPtr);
                  Dec(FTempVars.FCount);
                  {$IFNDEF IFPS3_NOSMARTLIST}
                  Inc(FTempVars.FCheckCount);
                  if FTempVars.FCheckCount > FMaxCheckCount then FTempVars.Recreate;
                  {$ENDIF}
                  FTempVars.FLength := P;
                  if ((FTempVars.FCapacity - FTempVars.FLength) shr 12) > 2 then FTempVars.AdjustLength;
                end;
                Break;
              end;
              DoBooleanCalc(Vs.P, Vd.P, v3.P, vs.aType, vd.aType, v3.aType, CalcType);
              if vd.FreeType <> vtNone then
              begin
                if vd.aType.BaseType in NeedFinalization then
                  FinalizeVariant(vd.P, vd.aType);
                p := IPointer(FTempVars.Data^[FtempVars.Count-1]) - IPointer(FtempVars.DataPtr);
                Dec(FTempVars.FCount);
                {$IFNDEF IFPS3_NOSMARTLIST}
                Inc(FTempVars.FCheckCount);
                if FTempVars.FCheckCount > FMaxCheckCount then FTempVars.Recreate;
                {$ENDIF}
                FTempVars.FLength := P;
                if ((FTempVars.FCapacity - FTempVars.FLength) shr 12) > 2 then FTempVars.AdjustLength;
              end;
              if vs.FreeType <> vtNone then
              begin
                if vs.aType.BaseType in NeedFinalization then
                  FinalizeVariant(vs.P, vs.aType);
                p := IPointer(FTempVars.Data^[FtempVars.Count-1]) - IPointer(FtempVars.DataPtr);
                Dec(FTempVars.FCount);
                {$IFNDEF IFPS3_NOSMARTLIST}
                Inc(FTempVars.FCheckCount);
                if FTempVars.FCheckCount > FMaxCheckCount then FTempVars.Recreate;
                {$ENDIF}
                FTempVars.FLength := P;
                if ((FTempVars.FCapacity - FTempVars.FLength) shr 12) > 2 then FTempVars.AdjustLength;
              end;
            end;

        else
          CMD_Err(erInvalidOpcode); // Error
        end;
    end;
//    if cmd <> invalidval then ProfilerExitProc(Cmd+1);
//    if ExEx <> erNoError then FStatus := FOldStatus;
  until (FExceptionStack.Count = 0) or (Fstatus <> IsRunning);
  if FStatus = isLoaded then begin
    for I := Longint(FStack.Count) - 1 downto 0 do
      FStack.Pop;
    FStack.Clear;
    if FCallCleanup then Cleanup;
  end;
  Result := ExEx = erNoError;
end;


function DefProc(Caller: TIFPSExec; p: TIFExternalProcRec; Global, Stack: TIFPSStack): Boolean;
var
  temp: TIFPSVariantIFC;
  I: Longint;
  b: Boolean;
  Tmp: TObject;
begin
  case Longint(p.Ext1) of
    0: Stack.SetString(-1, IntToStr(Stack.GetInt(-2))); // inttostr
    1: Stack.SetInt(-1, StrToInt(Stack.GetString(-2))); // strtoint
    2: Stack.SetInt(-1, StrToIntDef(Stack.GetString(-2), Stack.GetInt(-3))); // strtointdef
    3: Stack.SetInt(-1, Pos(Stack.GetString(-2), Stack.GetString(-3)));// pos
    4: Stack.SetString(-1, Copy(Stack.GetString(-2), Stack.GetInt(-3), Stack.GetInt(-4))); // copy
    5: //delete
      begin
        temp := NewTIFPSVariantIFC(Stack[Stack.Count -1], True);
        if (temp.Dta = nil) or (temp.aType.BaseType <> btString) then
        begin
          Result := False;
          exit;
        end;
        Delete(tbtstring(temp.Dta^), Stack.GetInt(-2), Stack.GetInt(-3));
      end;
    6: // insert
      begin
        temp := NewTIFPSVariantIFC(Stack[Stack.Count -2], True);
        if (temp.Dta = nil) or (temp.aType.BaseType <> btString) then
        begin
          Result := False;
          exit;
        end;
        Insert(Stack.GetString(-1), tbtstring(temp.Dta^), Stack.GetInt(-3));
      end;
    7: // StrGet
      begin
        temp :=  NewTIFPSVariantIFC(Stack[Stack.Count -2], True);
        if (temp.Dta = nil) or (temp.aType.BaseType <> btString) then
        begin
          Result := False;
          exit;
        end;
        I := Stack.GetInt(-3);
        if (i<1) or (i>length(tbtstring(temp.Dta^))) then
        begin
          Caller.CMD_Err2(erCustomError, 'Out Of String Range');
          Result := False;
          exit;
        end;
        Stack.SetInt(-1,Ord(tbtstring(temp.Dta^)[i]));
      end;
    8: // StrSet
      begin
        temp := NewTIFPSVariantIFC(Stack[Stack.Count -3], True);
        if (temp.Dta = nil) or (temp.aType.BaseType <> btString) then
        begin
          Result := False;
          exit;
        end;
        I := Stack.GetInt(-2);
        if (i<1) or (i>length(tbtstring(temp.Dta^))) then
        begin
          Caller.CMD_Err2(erCustomError, 'Out Of String Range');
          Result := True;
          exit;
        end;
        tbtstring(temp.Dta^)[i] := chr(Stack.GetInt(-1));
      end;
    10: Stack.SetString(-1, FastUppercase(Stack.GetString(-2))); // Uppercase
    11: Stack.SetString(-1, FastLowercase(Stack.GetString(-2)));// LowerCase
    12: Stack.SetString(-1, Trim(Stack.GetString(-2)));// Trim
    13: Stack.SetInt(-1, Length(Stack.GetString(-2))); // Length
    14: // SetLength
      begin
        temp := NewTIFPSVariantIFC(Stack[Stack.Count -1], True);
        if (temp.Dta = nil) or (temp.aType.BaseType <> btString) then
        begin
          Result := False;
          exit;
        end;
        SetLength(tbtstring(temp.Dta^), STack.GetInt(-2));
      end;
    15: Stack.SetReal(-1, Sin(Stack.GetReal(-2))); // Sin
    16: Stack.SetReal(-1, Cos(Stack.GetReal(-2)));  // Cos
    17: Stack.SetReal(-1, SQRT(Stack.GetReal(-2))); // Sqrt
    18: Stack.SetInt(-1, Round(Stack.GetReal(-2))); // Round
    19: Stack.SetInt(-1, Trunc(Stack.GetReal(-2))); // Trunc
    20: Stack.SetReal(-1, Int(Stack.GetReal(-2))); // Int
    21: Stack.SetReal(-1, Pi); // Pi
    22: Stack.SetReal(-1, Abs(Stack.GetReal(-2))); // Abs
    23: Stack.SetReal(-1, StrToFloat(Stack.GetString(-2))); // StrToFloat
    24: Stack.SetString(-1, FloatToStr(Stack.GetReal(-2)));// FloatToStr
    25: Stack.SetString(-1, PadL(Stack.GetString(-2), Stack.GetInt(-3))); //  PadL
    26: Stack.SetString(-1, PadR(Stack.GetString(-2), Stack.GetInt(-3))); // PadR
    27: Stack.SetString(-1, PadZ(Stack.GetString(-2), Stack.GetInt(-3)));// PadZ
    28: Stack.SetString(-1, StringOfChar(Char(Stack.GetInt(-2)), Stack.GetInt(-3))); // Replicate/StrOfChar
    29: // Assigned
      begin
        temp := NewTIFPSVariantIFC(Stack[Stack.Count -2], True);
        if Temp.dta = nil then
        begin
          Result := False;
          exit;
        end;
        case temp.aType.BaseType of
          btU8, btS8: b := tbtu8(temp.dta^) <> 0;
          btU16, btS16: b := tbtu16(temp.dta^) <> 0;
          btU32, btS32: b := tbtu32(temp.dta^) <> 0;
          btString, btPChar: b := tbtstring(temp.dta^) <> '';
{$IFNDEF IFPS3_NOWIDESTRING}
          btWideString: b := tbtwidestring(temp.dta^)<> '';
{$ENDIF}
          btArray, btClass{$IFNDEF IFPS3_NOINTERFACES}, btInterface{$ENDIF}: b := Pointer(temp.dta^) <> nil;
        else
          Result := False;
          Exit;
        end;
        if b then
          Stack.SetInt(-1, 1)
        else
          Stack.SetInt(-1, 0);
      end;
    30:
      begin {RaiseLastException}
        Tmp := Caller.ExObject;
        Caller.ExObject := nil;
        Caller.ExceptionProc(Caller.ExProc, Caller.ExPos, Caller.ExEx, Caller.ExParam, tmp);
      end;
    31: Caller.CMD_Err2(TIFError(Stack.GetInt(-1)), Stack.GetString(-2)); {RaiseExeption}
    32: Stack.SetInt(-1, Ord(Caller.ExEx)); {ExceptionType}
    33: Stack.SetString(-1, Caller.ExParam); {ExceptionParam}
    34: Stack.SetInt(-1, Caller.ExProc); {ExceptionProc}
    35: Stack.SetInt(-1, Caller.ExPos); {ExceptionPos}
    36: Stack.SetString(-1, TIFErrorToString(TIFError(Stack.GetInt(-2)), Stack.GetString(-3))); {ExceptionToString}
    37: Stack.SetString(-1, AnsiUpperCase(Stack.GetString(-2))); // AnsiUppercase
    38: Stack.SetString(-1, AnsiLowercase(Stack.GetString(-2)));// AnsiLowerCase
{$IFNDEF IFPS3_NOINT64}
    39: Stack.SetInt64(-1, StrToInt64(Stack.GetString(-2)));  // StrToInt64
    40: Stack.SetString(-1, SysUtils.IntToStr(Stack.GetInt64(-2)));// Int64ToStr
{$ENDIF}
    41:  // sizeof
      begin
        temp := NewTIFPSVariantIFC(Stack[Stack.Count -2], False);
        if Temp.aType = nil then
          Stack.SetInt(-1, 0)
        else
          Stack.SetInt(-1, Temp.aType.RealSize)
      end;
    else
    begin
      Result := False;
      exit;
    end;
  end;
  Result := True;
end;
function GetArrayLength(Caller: TIFPSExec; p: TIFExternalProcRec; Global, Stack: TIFPSStack): Boolean;
var
  arr: TIFPSVariantIFC;
begin
  Arr := NewTIFPSVariantIFC(Stack[Stack.Count-2], True);
  if (arr.Dta = nil) or (arr.aType.BaseType <> btArray) then
  begin
    Result := false;
    exit;
  end;
  Stack.SetInt(-1, IFPSDynArrayGetLength(Pointer(arr.Dta^), arr.aType));
  Result := True;
end;

function SetArrayLength(Caller: TIFPSExec; p: TIFExternalProcRec; Global, Stack: TIFPSStack): Boolean;
var
  arr: TIFPSVariantIFC;
begin
  Arr := NewTIFPSVariantIFC(Stack[Stack.Count-1], True);
  if (arr.Dta = nil) or (arr.aType.BaseType <> btArray) then
  begin
    Result := false;
    exit;
  end;
  IFPSDynArraySetLength(Pointer(arr.Dta^), arr.aType, Stack.GetInt(-2));
  Result := True;
end;


function InterfaceProc(Sender: TIFPSExec; p: TIFExternalProcRec; Tag: Pointer): Boolean; forward;

procedure RegisterInterfaceLibraryRuntime(Se: TIFPSExec);
begin
  SE.AddSpecialProcImport('intf', InterfaceProc, nil);
end;


procedure TIFPSExec.RegisterStandardProcs;
begin
  RegisterFunctionName('INTTOSTR', DefProc, Pointer(0), nil);
  RegisterFunctionName('STRTOINT', DefProc, Pointer(1), nil);
  RegisterFunctionName('STRTOINTDEF', DefProc, Pointer(2), nil);
  RegisterFunctionName('POS', DefProc, Pointer(3), nil);
  RegisterFunctionName('COPY', DefProc, Pointer(4), nil);
  RegisterFunctionName('DELETE', DefProc, Pointer(5), nil);
  RegisterFunctionName('INSERT', DefProc, Pointer(6), nil);

  RegisterFunctionName('STRGET', DefProc, Pointer(7), nil);
  RegisterFunctionName('STRSET', DefProc, Pointer(8), nil);
  RegisterFunctionName('UPPERCASE', DefProc, Pointer(10), nil);
  RegisterFunctionName('LOWERCASE', DefProc, Pointer(11), nil);
  RegisterFunctionName('TRIM', DefProc, Pointer(12), nil);
  RegisterFunctionName('LENGTH', DefProc, Pointer(13), nil);
  RegisterFunctionName('SETLENGTH', DefProc, Pointer(14), nil);
  RegisterFunctionName('SIN', DefProc, Pointer(15), nil);
  RegisterFunctionName('COS', DefProc, Pointer(16), nil);
  RegisterFunctionName('SQRT', DefProc, Pointer(17), nil);
  RegisterFunctionName('ROUND', DefProc, Pointer(18), nil);
  RegisterFunctionName('TRUNC', DefProc, Pointer(19), nil);
  RegisterFunctionName('INT', DefProc, Pointer(20), nil);
  RegisterFunctionName('PI', DefProc, Pointer(21), nil);
  RegisterFunctionName('ABS', DefProc, Pointer(22), nil);
  RegisterFunctionName('STRTOFLOAT', DefProc, Pointer(23), nil);
  RegisterFunctionName('FLOATTOSTR', DefProc, Pointer(24), nil);
  RegisterFunctionName('PADL', DefProc, Pointer(25), nil);
  RegisterFunctionName('PADR', DefProc, Pointer(26), nil);
  RegisterFunctionName('PADZ', DefProc, Pointer(27), nil);
  RegisterFunctionName('REPLICATE', DefProc, Pointer(28), nil);
  RegisterFunctionName('STRINGOFCHAR', DefProc, Pointer(28), nil);
  RegisterFunctionName('!ASSIGNED', DefProc, Pointer(29), nil);

  RegisterDelphiFunction(@Unassigned, 'UNASSIGNED', cdRegister);
  RegisterDelphiFunction(@Null, 'NULL', cdRegister);
  RegisterDelphiFunction(@VarType, 'VARTYPE', cdRegister);
  {$IFNDEF IFPS3_NOIDISPATCH}
  RegisterDelphiFunction(@IDispatchInvoke, 'IDISPATCHINVOKE', cdregister);
  {$ENDIF}


  RegisterFunctionName('GETARRAYLENGTH', GetArrayLength, nil, nil);
  RegisterFunctionName('SETARRAYLENGTH', SetArrayLength, nil, nil);

  RegisterFunctionName('RAISELASTEXCEPTION', DefPRoc, Pointer(30), nil);
  RegisterFunctionName('RAISEEXCEPTION', DefPRoc, Pointer(31), nil);
  RegisterFunctionName('EXCEPTIONTYPE', DefPRoc, Pointer(32), nil);
  RegisterFunctionName('EXCEPTIONPARAM', DefPRoc, Pointer(33), nil);
  RegisterFunctionName('EXCEPTIONPROC', DefPRoc, Pointer(34), nil);
  RegisterFunctionName('EXCEPTIONPOS', DefPRoc, Pointer(35), nil);
  RegisterFunctionName('EXCEPTIONTOSTRING', DefProc, Pointer(36), nil);
  RegisterFunctionName('ANSIUPPERCASE', DefProc, Pointer(37), nil);
  RegisterFunctionName('ANSILOWERCASE', DefProc, Pointer(38), nil);

  {$IFNDEF IFPS3_NOINT64}
  RegisterFunctionName('STRTOINT64', DefProc, Pointer(39), nil);
  RegisterFunctionName('INT64TOSTR', DefProc, Pointer(40), nil);
  {$ENDIF}
  RegisterFunctionName('SIZEOF', DefProc, Pointer(41), nil);

  RegisterInterfaceLibraryRuntime(Self);
end;

function RealFloatCall_Register(p: Pointer;
  _EAX, _EDX, _ECX: Cardinal;
  StackData: Pointer;
  StackDataLen: Longint // stack length are in 4 bytes. (so 1 = 4 bytes)
  ): Extended; Stdcall; // make sure all things are on stack
var
  E: Extended;
begin
  asm
    mov ecx, stackdatalen
    jecxz @@2
    mov eax, stackdata
    @@1:
    mov edx, [eax]
    push edx
    sub eax, 4
    dec ecx
    or ecx, ecx
    jnz @@1
    @@2:
    mov eax,_EAX
    mov edx,_EDX
    mov ecx,_ECX
    call p
    fstp tbyte ptr [e]
  end;
  Result := E;
end;

function RealFloatCall_Other(p: Pointer;
  StackData: Pointer;
  StackDataLen: Longint // stack length are in 4 bytes. (so 1 = 4 bytes)
  ): Extended; Stdcall; // make sure all things are on stack
var
  E: Extended;
begin
  asm
    mov ecx, stackdatalen
    jecxz @@2
    mov eax, stackdata
    @@1:
    mov edx, [eax]
    push edx
    sub eax, 4
    dec ecx
    or ecx, ecx
    jnz @@1
    @@2:
    call p
    fstp tbyte ptr [e]
  end;
  Result := E;
end;

function RealFloatCall_CDecl(p: Pointer;
  StackData: Pointer;
  StackDataLen: Longint // stack length are in 4 bytes. (so 1 = 4 bytes)
  ): Extended; Stdcall; // make sure all things are on stack
var
  E: Extended;
begin
  asm
    mov ecx, stackdatalen
    jecxz @@2
    mov eax, stackdata
    @@1:
    mov edx, [eax]
    push edx
    sub eax, 4
    dec ecx
    or ecx, ecx
    jnz @@1
    @@2:
    call p
    fstp tbyte ptr [e]
    @@5:
    mov ecx, stackdatalen
    jecxz @@2
    @@6:
    pop edx
    dec ecx
    or ecx, ecx
    jnz @@6
  end;
  Result := E;
end;

function RealCall_Register(p: Pointer;
  _EAX, _EDX, _ECX: Cardinal;
  StackData: Pointer;
  StackDataLen: Longint; // stack length are in 4 bytes. (so 1 = 4 bytes)
  ResultLength: Longint; ResEDX: Pointer): Longint; Stdcall; // make sure all things are on stack
var
  r: Longint;
begin
  asm
    mov ecx, stackdatalen
    jecxz @@2
    mov eax, stackdata
    @@1:
    mov edx, [eax]
    push edx
    sub eax, 4
    dec ecx
    or ecx, ecx
    jnz @@1
    @@2:
    mov eax,_EAX
    mov edx,_EDX
    mov ecx,_ECX
    call p
    mov ecx, resultlength
    cmp ecx, 0
    je @@5
    cmp ecx, 1
    je @@3
    cmp ecx, 2
    je @@4
    mov r, eax
    jmp @@5
    @@3:
    xor ecx, ecx
    mov cl, al
    mov r, ecx
    jmp @@5
    @@4:
    xor ecx, ecx
    mov cx, ax
    mov r, ecx
    @@5:
    mov ecx, resedx
    jecxz @@6
    mov [ecx], edx
    @@6:
  end;
  Result := r;
end;

function RealCall_Other(p: Pointer;
  StackData: Pointer;
  StackDataLen: Longint; // stack length are in 4 bytes. (so 1 = 4 bytes)
  ResultLength: Longint; ResEDX: Pointer): Longint; Stdcall; // make sure all things are on stack
var
  r: Longint;
begin
  asm
    mov ecx, stackdatalen
    jecxz @@2
    mov eax, stackdata
    @@1:
    mov edx, [eax]
    push edx
    sub eax, 4
    dec ecx
    or ecx, ecx
    jnz @@1
    @@2:
    call p
    mov ecx, resultlength
    cmp ecx, 0
    je @@5
    cmp ecx, 1
    je @@3
    cmp ecx, 2
    je @@4
    mov r, eax
    jmp @@5
    @@3:
    xor ecx, ecx
    mov cl, al
    mov r, ecx
    jmp @@5
    @@4:
    xor ecx, ecx
    mov cx, ax
    mov r, ecx
    @@5:
    mov ecx, resedx
    jecxz @@6
    mov [ecx], edx
    @@6:
  end;
  Result := r;
end;

function RealCall_CDecl(p: Pointer;
  StackData: Pointer;
  StackDataLen: Longint; // stack length are in 4 bytes. (so 1 = 4 bytes)
  ResultLength: Longint; ResEDX: Pointer): Longint; Stdcall; // make sure all things are on stack
var
  r: Longint;
begin
  asm
    mov ecx, stackdatalen
    jecxz @@2
    mov eax, stackdata
    @@1:
    mov edx, [eax]
    push edx
    sub eax, 4
    dec ecx
    or ecx, ecx
    jnz @@1
    @@2:
    call p
    mov ecx, resultlength
    cmp ecx, 0
    je @@5
    cmp ecx, 1
    je @@3
    cmp ecx, 2
    je @@4
    mov r, eax
    jmp @@5
    @@3:
    xor ecx, ecx
    mov cl, al
    mov r, ecx
    jmp @@5
    @@4:
    xor ecx, ecx
    mov cx, ax
    mov r, ecx
    @@5:
    mov ecx, stackdatalen
    jecxz @@7
    @@6:
    pop eax
    dec ecx
    or ecx, ecx
    jnz @@6
    mov ecx, resedx
    jecxz @@7
    mov [ecx], edx
    @@7:
  end;
  Result := r;
end;




function ToString(p: PChar): string;
begin
  SetString(Result, p, StrLen(p));
end;

function IntPIFVariantToVariant(Src: pointer; aType: TIFTypeRec; var Dest: Variant): Boolean;
  function BuildArray(P: Pointer; aType: TIFTypeRec; Len: Longint): Boolean;
  var
    i, elsize: Longint;
    v: variant;
  begin
    elsize := aType.RealSize;
    Dest := VarArrayCreate([0, Len-1], varVariant);
    for i := 0 to Len -1 do
    begin
      if not IntPIFVariantToVariant(p, aType, v) then
      begin
        result := false;
        exit;
      end;
      Dest[i] := v;
      p := Pointer(IPointer(p) + Cardinal(elSize));
    end;
    result := true;
  end;
begin
  if aType = nil then
  begin
    Dest := null;
    Result := True;
    exit;
  end;
  if aType.BaseType = btPointer then
  begin
    aType := TIFTypeRec(Pointer(IPointer(src)+4)^);
    Src := Pointer(Pointer(Src)^);
  end;

  case aType.BaseType of
    btVariant: Dest := variant(src^);
    btArray: if not BuildArray(Pointer(Src^), TIFTypeRec_Array(aType).ArrayType, IFPSDynArrayGetLength(Pointer(src^), aType)) then begin result := false; exit; end;
    btStaticArray: if not BuildArray(Pointer(Src), TIFTypeRec_StaticArray(aType).ArrayType, IFPSDynArrayGetLength(Pointer(src^), aType)) then begin result := false; exit; end;
    btU8:
      if aType.ExportName = 'BOOLEAN' then
        Dest := boolean(tbtu8(Src^) <> 0)
      else
        Dest := tbtu8(Src^);
    btS8: Dest := tbts8(Src^);
    btU16: Dest := tbtu16(Src^);
    btS16: Dest := tbts16(Src^);
    btU32: Dest := {$IFDEF IFPS3_D6PLUS}tbtu32{$ELSE}tbts32{$ENDIF}(Src^);
    btS32: Dest := tbts32(Src^);
    btSingle: Dest := tbtsingle(Src^);
    btDouble:
      begin
        if aType.ExportName = 'TDATETIME' then
          Dest := TDateTime(tbtDouble(Src^))
        else
          Dest := tbtDouble(Src^);
      end;
    btExtended: Dest := tbtExtended(Src^);
    btString: Dest := tbtString(Src^);
    btPChar: Dest := ToString(PChar(Src^));
  {$IFNDEF IFPS3_NOINT64}
  {$IFDEF IFPS3_D6PLUS} btS64: Dest := tbts64(Src^); {$ELSE} bts64: begin Result := False; exit; end; {$ENDIF}
  {$ENDIF}
    btChar: Dest := tbtchar(src^);
  {$IFNDEF IFPS3_NOWIDESTRING}
    btWideString: Dest := tbtWideString(src^);
    btWideChar: Dest := tbtwidechar(src^);
  {$ENDIF}
  else
    begin
      Result := False;
      exit;
    end;
  end;
  Result := True;
end;

function PIFVariantToVariant(Src: PIFVariant; var Dest: Variant): Boolean;
begin
  Result := IntPIFVariantToVariant(@PIFPSVariantData(src).Data, Src.FType, Dest);
end;

function VariantToPIFVariant(Exec: TIFPSExec; const Src: Variant; Dest: PIFVariant): Boolean;
var
  TT: PIFTypeRec;
begin
  if Dest = nil then begin Result := false; exit; end;
  tt := Exec.FindType2(btVariant);
  if tt = nil then begin Result := false; exit; end;
  Result := Exec.SetVariantValue(@PIFPSVariantData(Dest).Data, @Src, Dest.FType, tt);
end;

type
  POpenArray = ^TOpenArray;
  TOpenArray = record
    AType: Byte; {0}
    OrgVar: PIFPSVariantIFC;
    FreeIt: Boolean;
    ElementSize,
    ItemCount: Longint;
    Data: Pointer;
    VarParam: Boolean;
  end;
function CreateOpenArray(VarParam: Boolean; Sender: TIFPSExec; val: PIFPSVariantIFC): POpenArray;
var
  datap, p: Pointer;
  ctype: TIFTypeRec;
  cp: Pointer;
  i: Longint;
begin
  if (Val.aType.BaseType <> btArray) and (val.aType.BaseType <> btStaticArray) then
  begin
    Result := nil;
    exit;
  end;
  New(Result);
  Result.AType := 0;
  Result.OrgVar := Val;
  Result.VarParam := VarParam;

  if val.aType.BaseType = btStaticArray then
  begin
    Result^.ItemCount := TIFTypeRec_StaticArray(val.aType).Size;
    datap := Val.Dta;
  end else
  begin
    Result^.ItemCount := IFPSDynArrayGetLength(Pointer(Val.Dta^), val.aType);
    datap := Pointer(Val.Dta^);
  end;
  if TIFTypeRec_Array(Val.aType).ArrayType.BaseType <> btPointer then
  begin
    Result.FreeIt := False;
    result.ElementSize := 0;
    Result.Data := datap;
    exit;
  end;
  Result.FreeIt := True;
  Result.ElementSize := sizeof(TVarRec);
  GetMem(Result.Data, Result.ItemCount * Result.ElementSize);
  P := Result.Data;
  FillChar(p^, Result^.ItemCount * Result^.ElementSize, 0);
  for i := 0 to Result^.ItemCount -1 do
  begin
    ctype := Pointer(Pointer(IPointer(datap)+4)^);
    cp := Pointer(Datap^);
    if cp = nil then
    begin
      tvarrec(p^).VType := vtPointer;
      tvarrec(p^).VPointer := nil;
    end else begin
       case ctype.BaseType of
        btchar: begin
            tvarrec(p^).VType := vtChar;
            tvarrec(p^).VChar := tbtchar(cp^);
          end;
        btSingle:
          begin
            tvarrec(p^).VType := vtExtended;
            New(tvarrec(p^).VExtended);
            tvarrec(p^).VExtended^ := tbtsingle(cp^);
          end;
        btExtended:
          begin
            tvarrec(p^).VType := vtExtended;
            New(tvarrec(p^).VExtended);
            tvarrec(p^).VExtended^ := tbtextended(cp^);;
          end;
        btDouble:
          begin
            tvarrec(p^).VType := vtExtended;
            New(tvarrec(p^).VExtended);
            tvarrec(p^).VExtended^ := tbtdouble(cp^);
          end;
        {$IFNDEF IFPS3_NOWIDESTRING}
        btwidechar: begin
            tvarrec(p^).VType := vtWideChar;
            tvarrec(p^).VWideChar := tbtwidechar(cp^);
          end;
        btwideString: begin
          tvarrec(p^).VType := vtWideString;
          widestring(TVarRec(p^).VWideString) := tbtwidestring(cp^);
        end;
        {$ENDIF}
        btU8: begin
            tvarrec(p^).VType := vtInteger;
            tvarrec(p^).VInteger := tbtu8(cp^);
          end;
        btS8: begin
            tvarrec(p^).VType := vtInteger;
            tvarrec(p^).VInteger := tbts8(cp^);
          end;
        btU16: begin
            tvarrec(p^).VType := vtInteger;
            tvarrec(p^).VInteger := tbtu16(cp^);
          end;
        btS16: begin
            tvarrec(p^).VType := vtInteger;
            tvarrec(p^).VInteger := tbts16(cp^);
          end;
        btU32: begin
            tvarrec(p^).VType := vtInteger;
            tvarrec(p^).VInteger := tbtu32(cp^);
          end;
        btS32: begin
            tvarrec(p^).VType := vtInteger;
            tvarrec(p^).VInteger := tbts32(cp^);
          end;
        {$IFNDEF IFPS3_NOINT64}
        btS64: begin
            tvarrec(p^).VType := vtInt64;
            New(tvarrec(p^).VInt64);
            tvarrec(p^).VInt64^ := tbts64(cp^);
          end;
        {$ENDIF}
        btString: begin
          tvarrec(p^).VType := vtAnsiString;
          string(TVarRec(p^).VAnsiString) := tbtstring(cp^);
        end;
        btPChar:
        begin
          tvarrec(p^).VType := vtPchar;
          TVarRec(p^).VPChar := pointer(cp^);
        end;
        btClass:
        begin
          tvarrec(p^).VType := vtObject;
          tvarrec(p^).VObject := Pointer(cp^);
        end;
{$IFNDEF IFPS3_NOINTERFACES}
{$IFDEF IFPS3_D3PLUS}
        btInterface:
        begin
          tvarrec(p^).VType := vtInterface;
          IUnknown(tvarrec(p^).VInterface) := IUnknown(cp^);
        end;

{$ENDIF}        
{$ENDIF}
      end;
    end;
    datap := Pointer(IPointer(datap)+12);
    p := PChar(p) + Result^.ElementSize;
  end;
end;

procedure DestroyOpenArray(Sender: TIFPSExec; V: POpenArray);
var
  cp, datap: pointer;
  ctype: TIFTypeRec;
  p: PVarRec;
  i: Longint;
begin
  if v.FreeIt then // basetype = btPointer
  begin
    p := v^.Data;
    if v.OrgVar.aType.BaseType = btStaticArray then
      datap := v.OrgVar.Dta
    else
      datap := Pointer(v.OrgVar.Dta^);
    for i := 0 to v^.ItemCount -1 do
    begin
      ctype := Pointer(Pointer(IPointer(datap)+4)^);
      cp := Pointer(Datap^);
      case ctype.BaseType of
        btU8:
          begin
            if v^.varParam then
              tbtu8(cp^) := tvarrec(p^).VInteger
          end;
        btS8: begin
            if v^.varParam then
              tbts8(cp^) := tvarrec(p^).VInteger
          end;
        btU16: begin
            if v^.varParam then
              tbtu16(cp^) := tvarrec(p^).VInteger
          end;
        btS16: begin
            if v^.varParam then
              tbts16(cp^) := tvarrec(p^).VInteger
          end;
        btU32: begin
            if v^.varParam then
              tbtu32(cp^) := tvarrec(p^).VInteger
          end;
        btS32: begin
            if v^.varParam then
              tbts32(cp^) := tvarrec(p^).VInteger
          end;
        btChar: begin
            if v^.VarParam then
              tbtchar(cp^) := tvarrec(p^).VChar
          end;
        btSingle: begin
          if v^.VarParam then
            tbtsingle(cp^) := tvarrec(p^).vextended^;
          dispose(tvarrec(p^).vextended);
        end;
        btDouble: begin
          if v^.VarParam then
            tbtdouble(cp^) := tvarrec(p^).vextended^;
          dispose(tvarrec(p^).vextended);
        end;
        btExtended: begin
          if v^.VarParam then
            tbtextended(cp^) := tvarrec(p^).vextended^;
          dispose(tvarrec(p^).vextended);
        end;
        {$IFNDEF IFPS3_NOINT64}
        btS64: begin
            if v^.VarParam then
              tbts64(cp^) := tvarrec(p^).vInt64^;
            dispose(tvarrec(p^).VInt64);
          end;
        {$ENDIF}
        {$IFNDEF IFPS3_NOWIDESTRING}
        btWideChar: begin
            if v^.varParam then
              tbtwidechar(cp^) := tvarrec(p^).VWideChar;
          end;
        btWideString:
          begin
          if v^.VarParam then
            tbtwidestring(cp^) := widestring(TVarRec(p^).VWideString);
          finalize(widestring(TVarRec(p^).VWideString));
          end;
        {$ENDIF}
        btString: begin
          if v^.VarParam then
            tbtstring(cp^) := tbtstring(TVarRec(p^).VString);
          finalize(string(TVarRec(p^).VAnsiString));
        end;
        btClass: begin
          if v^.VarParam then
            Pointer(cp^) := TVarRec(p^).VObject;
        end;
{$IFNDEF IFPS3_NOINTERFACES}
{$IFDEF IFPS3_D3PLUS}
        btInterface: begin
          if v^.VarParam then
            IUnknown(cp^) := IUnknown(TVarRec(p^).VInterface);
          finalize(string(TVarRec(p^).VAnsiString));
        end;
{$ENDIF}        
{$ENDIF}
      end;
      datap := Pointer(IPointer(datap)+12);
      p := Pointer(IPointer(p) + Cardinal(v^.ElementSize));
    end;
    FreeMem(v.Data, v.ElementSize * v.ItemCount);
  end;
  Dispose(V);
end;


const
  EmptyPchar: array[0..0] of char = #0;

function TIFPSExec.InnerfuseCall(_Self, Address: Pointer; CallingConv: TIFPSCallingConvention; Params: TIfList; res: PIFPSVariantIFC): Boolean;
var
  Stack: ansistring;
  I: Longint;
  RegUsage: Byte;
  CallData: TIfList;
  pp: ^Byte;

  EAX, EDX, ECX: Longint;

  function rp(p: PIFPSVariantIFC): PIFPSVariantIFC;
  begin
    if p = nil then
    begin
      result := nil;
      exit;
    end;
    if p.aType.BaseType = btPointer then
    begin
      p^.aType := Pointer(Pointer(IPointer(p^.dta) + 4)^);
      p^.Dta := Pointer(p^.dta^);
    end;
    Result := p;
  end;

  function GetPtr(fVar: PIFPSVariantIFC): Boolean;
  var
    varPtr: Pointer;
    UseReg: Boolean;
    tempstr: string;
    p: Pointer;
  begin
    Result := False;
    if FVar = nil then exit;
    if fVar.VarParam then
    begin
      case fvar.aType.BaseType of
        btArray:
          begin
            if Copy(fvar.aType.ExportName, 1, 10) = '!OPENARRAY' then
            begin
              p := CreateOpenArray(True, Self, FVar);
              if p = nil then exit;
              CallData.Add(p);
              case RegUsage of
                0: begin EAX := Longint(POpenArray(p)^.Data); Inc(RegUsage); end;
                1: begin EDX := Longint(POpenArray(p)^.Data); Inc(RegUsage); end;
                2: begin ECX := Longint(POpenArray(p)^.Data); Inc(RegUsage); end;
                else begin
                  Stack := #0#0#0#0 + Stack;
                  Pointer((@Stack[1])^) := POpenArray(p)^.Data;
                end;
              end;
              case RegUsage of
                0: begin EAX := Longint(POpenArray(p)^.ItemCount - 1); Inc(RegUsage); end;
                1: begin EDX := Longint(POpenArray(p)^.ItemCount -1); Inc(RegUsage); end;
                2: begin ECX := Longint(POpenArray(p)^.ItemCount -1); Inc(RegUsage); end;
                else begin
                  Stack := #0#0#0#0 + Stack;
                  Longint((@Stack[1])^) := POpenArray(p)^.ItemCount -1;
                end;
              end;
              Result := True;
              Exit;
            end else begin
            {$IFDEF IFPS3_DYNARRAY}
              varptr := fvar.Dta;
            {$ELSE}
              Exit;
            {$ENDIF}
            end;
          end;
        btVariant,
        btSet,
        btStaticArray,
        btRecord,
        btInterface,
        btClass,
        {$IFNDEF IFPS3_NOWIDESTRING} btWideString, btWideChar, {$ENDIF} btU8, btS8, btU16,
        btS16, btU32, btS32, btSingle, btDouble, btExtended, btString
        {$IFNDEF IFPS3_NOINT64}, bts64{$ENDIF}:
          begin
            Varptr := fvar.Dta;
          end;
      else begin
          exit; //invalid type
        end;
      end; {case}
      case RegUsage of
        0: begin EAX := Longint(VarPtr); Inc(RegUsage); end;
        1: begin EDX := Longint(VarPtr); Inc(RegUsage); end;
        2: begin ECX := Longint(VarPtr); Inc(RegUsage); end;
        else begin
          Stack := #0#0#0#0 + Stack;
          Pointer((@Stack[1])^) := VarPtr;
        end;
      end;
    end else begin
      UseReg := True;
      case fVar^.aType.BaseType of
        btSet:
          begin
            tempstr := #0#0#0#0;
            case TIFTypeRec_Set(fvar.aType).aByteSize of
              1: Byte((@tempstr[1])^) := byte(fvar.dta^);
              2: word((@tempstr[1])^) := word(fvar.dta^);
              3, 4: cardinal((@tempstr[1])^) := cardinal(fvar.dta^);
              else
                pointer((@tempstr[1])^) := fvar.dta;
            end;
          end;
        btArray:
          begin
            if Copy(fvar^.aType.ExportName, 1, 10) = '!OPENARRAY' then
            begin
              p := CreateOpenArray(False, SElf, FVar);
              if p =nil then exit;
              CallData.Add(p);
              case RegUsage of
                0: begin EAX := Longint(POpenArray(p)^.Data); Inc(RegUsage); end;
                1: begin EDX := Longint(POpenArray(p)^.Data); Inc(RegUsage); end;
                2: begin ECX := Longint(POpenArray(p)^.Data); Inc(RegUsage); end;
                else begin
                  Stack := #0#0#0#0 + Stack;
                  Pointer((@Stack[1])^) := POpenArray(p)^.Data;
                end;
              end;
              case RegUsage of
                0: begin EAX := Longint(POpenArray(p)^.ItemCount -1); Inc(RegUsage); end;
                1: begin EDX := Longint(POpenArray(p)^.ItemCount -1); Inc(RegUsage); end;
                2: begin ECX := Longint(POpenArray(p)^.ItemCount -1); Inc(RegUsage); end;
                else begin
                  Stack := #0#0#0#0 + Stack;
                  Longint((@Stack[1])^) := POpenArray(p)^.ItemCount -1;
                end;
              end;
              Result := True;
              exit;
            end else begin
            {$IFDEF IFPS3_DYNARRAY}
              TempStr := #0#0#0#0;
              Pointer((@TempStr[1])^) := Pointer(fvar.Dta^);
            {$ELSE}
              Exit;
            {$ENDIF}
            end;
          end;
        btVariant
        , btStaticArray, btRecord:
          begin
            TempStr := #0#0#0#0;
            Pointer((@TempStr[1])^) := Pointer(fvar.Dta);
          end;
        btDouble: {8 bytes} begin
            TempStr := #0#0#0#0#0#0#0#0;
            UseReg := False;
            double((@TempStr[1])^) := double(fvar.dta^);
          end;

        btSingle: {4 bytes} begin
            TempStr := #0#0#0#0;
            UseReg := False;
            Single((@TempStr[1])^) := single(fvar.dta^);
          end;

        btExtended: {10 bytes} begin
            UseReg := False;
            TempStr:= #0#0#0#0#0#0#0#0#0#0#0#0;
            Extended((@TempStr[1])^) := extended(fvar.dta^);
          end;
        btChar,
        btU8,
        btS8: begin
            TempStr := char(fVar^.dta^) + #0#0#0;
          end;
        {$IFNDEF IFPS3_NOWIDESTRING}btWideChar, {$ENDIF}
        btu16, btS16: begin
            TempStr := #0#0#0#0;
            Word((@TempStr[1])^) := word(fVar^.dta^);
          end;
        btu32, bts32: begin
            TempStr := #0#0#0#0;
            Longint((@TempStr[1])^) := Longint(fVar^.dta^);
          end;
        btPchar:
          begin
            TempStr := #0#0#0#0;
            if pointer(fvar^.dta^) = nil then
              Pointer((@TempStr[1])^) := @EmptyPchar
            else
              Pointer((@TempStr[1])^) := pointer(fvar^.dta^);
          end;
        btclass, btinterface, btString:
          begin
            TempStr := #0#0#0#0;
            Pointer((@TempStr[1])^) := pointer(fvar^.dta^);
          end;
          {$IFNDEF IFPS3_NOWIDESTRING}
        btWideString: begin
            TempStr := #0#0#0#0;
            Pointer((@TempStr[1])^) := pointer(fvar^.dta^);
          end;
          {$ENDIF}

        btProcPtr:
          begin
            tempstr := #0#0#0#0#0#0#0#0;
            TMethod((@TempStr[1])^) := MKMethod(Self, Longint(FVar.Dta^));
            UseReg := false;
          end;

        {$IFNDEF IFPS3_NOINT64}bts64:
          begin
            TempStr:= #0#0#0#0#0#0#0#0;
            Int64((@TempStr[1])^) := int64(fvar^.dta^);
            UseReg := False;
        end;{$ENDIF}
      end; {case}
      if UseReg then
      begin
        case RegUsage of
          0: begin EAX := Longint((@Tempstr[1])^); Inc(RegUsage); end;
          1: begin EDX := Longint((@Tempstr[1])^); Inc(RegUsage); end;
          2: begin ECX := Longint((@Tempstr[1])^); Inc(RegUsage); end;
          else Stack := TempStr + Stack;
        end;
      end else begin
        Stack := TempStr + Stack;
      end;
    end;
    Result := True;
  end;
begin
  InnerfuseCall := False;
  if Address = nil then
    exit; // need address
  Stack := '';
  CallData := TIfList.Create;
  res := rp(res);
  if res <> nil then
    res.VarParam := true;
  try
    case CallingConv of
      cdRegister: begin
          EAX := 0;
          EDX := 0;
          ECX := 0;
          RegUsage := 0;
          if assigned(_Self) then begin
            RegUsage := 1;
            EAX := Longint(_Self);
          end;
          for I := 0 to Params.Count - 1 do
          begin
            if not GetPtr(rp(Params[I])) then Exit;
          end;
          if assigned(res) then begin
            case res^.aType.BaseType of
              {$IFNDEF IFPS3_NOWIDESTRING}btWideString, {$ENDIF}
              btInterface, btArray, btrecord, btstring, btVariant: GetPtr(res);
            end;
            case res^.aType.BaseType of
              btSingle:      tbtsingle(res.Dta^) := RealFloatCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btDouble:      tbtdouble(res.Dta^) := RealFloatCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btExtended:    tbtextended(res.Dta^) := RealFloatCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btchar,btU8, btS8:    tbtu8(res.dta^) := RealCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4, 1, nil);
              {$IFNDEF IFPS3_NOWIDESTRING}btWideChar, {$ENDIF}btu16, bts16:  tbtu16(res.dta^) := RealCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4, 2, nil);
              btClass, btu32, bts32:  tbtu32(res.dta^) := RealCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4, 4, nil);
              btPChar:       pchar(res.dta^) := Pchar(RealCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4, 4, nil));
              {$IFNDEF IFPS3_NOINT64}bts64:
                begin
                  EAX := RealCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4, 4, @EDX);
                  tbts64(res.dta^) := Int64(EDX) shl 32 or EAX;
                end;
              {$ENDIF}
              btInterface,
              btVariant,
              {$IFNDEF IFPS3_NOWIDESTRING}btWidestring, {$ENDIF}
              btArray, btrecord, btstring:      RealCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4, 0, nil);
            else
              exit;
            end;
          end else
            RealCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4, 0, nil);
          Result := True;
        end;
      cdPascal: begin
          RegUsage := 3;
          for I :=  0 to Params.Count - 1 do begin
            if not GetPtr(Params[i]) then Exit;
          end;
          if assigned(res) then begin
            case res^.aType.BaseType of
              {$IFNDEF IFPS3_NOWIDESTRING}btWideString, {$ENDIF}btInterface, btArray, btrecord, btstring, btVariant: GetPtr(res);
            end;
          end;
          if assigned(_Self) then begin
            Stack := #0#0#0#0 +Stack;
            Pointer((@Stack[1])^) := _Self;
          end;
          if assigned(res) then begin
            case res^.aType.BaseType of
              btSingle:      tbtsingle(res^.Dta^) := RealFloatCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btDouble:      tbtdouble(res^.Dta^) := RealFloatCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btExtended:    tbtextended(res^.Dta^) := RealFloatCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btChar, btU8, btS8:    tbtu8(res^.Dta^) := RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 1, nil);
              {$IFNDEF IFPS3_NOWIDESTRING}btWideChar, {$ENDIF}btu16, bts16:  tbtu16(res^.Dta^) := RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 2, nil);
              btClass, btu32, bts32:  tbtu32(res^.Dta^):= RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 4, nil);
              btPChar:       TBTSTRING(res^.dta^) := Pchar(RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 4, nil));
              {$IFNDEF IFPS3_NOINT64}bts64:
                begin
                  EAX := RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 4, @EDX);
                  tbts64(res^.dta^) := Int64(EAX) shl 32 or EDX;
                end;
              {$ENDIF}
              btVariant, 
              btInterface, btrecord, btstring: RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 0, nil);
            else
              exit;
            end;
          end else
            RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 0, nil);
          Result := True;
        end;

      CdCdecl: begin
          RegUsage := 3;
          if assigned(_Self) then begin
            Stack := #0#0#0#0;
            Pointer((@Stack[1])^) := _Self;
          end;
          for I := Params.Count - 1 downto 0 do begin
            if not GetPtr(Params[I]) then Exit;
          end;
          if assigned(res) then begin
            case res^.aType.BaseType of
              btSingle:      tbtsingle(res^.dta^) := RealFloatCall_Cdecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btDouble:      tbtdouble(res^.dta^) := RealFloatCall_Cdecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btExtended:    tbtextended(res^.dta^) := RealFloatCall_Cdecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btCHar, btU8, btS8:    tbtu8(res^.dta^) := RealCall_Cdecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 1, nil);
              {$IFNDEF IFPS3_NOWIDESTRING}btWideChar, {$ENDIF}btu16, bts16:  tbtu16(res^.dta^) := RealCall_Cdecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 2, nil);
              btClass, btu32, bts32:  tbtu32(res^.dta^) := RealCall_Cdecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 4, nil);
              btPChar:       TBTSTRING(res^.dta^) := Pchar(RealCall_Cdecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 4, nil));
              {$IFNDEF IFPS3_NOINT64}bts64:
                begin
                  EAX := RealCall_CDecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 4, @EDX);
                  tbts64(res^.Dta^) := Int64(EAX) shl 32 or EDX;
                end;
              {$ENDIF}
              btVariant, {$IFNDEF IFPS3_NOWIDESTRING}btWideString, {$ENDIF}
              btInterface,
              btArray, btrecord, btstring:      begin GetPtr(res); RealCall_Cdecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 0, nil); end;
            else
              exit;
            end;
          end else begin
            RealCall_CDecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 0, nil);
          end;
          Result := True;
        end;
      CdStdCall: begin
          RegUsage := 3;
          for I := Params.Count - 1 downto 0 do begin
            if not GetPtr(Params[I]) then exit;
          end;
          if assigned(_Self) then begin
            Stack := #0#0#0#0 + Stack;
            Pointer((@Stack[1])^) := _Self;
          end;
          if assigned(res) then begin
            case res^.aType.BaseType of
              btSingle:  tbtsingle(res^.dta^) := RealFloatCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btDouble:      tbtdouble(res^.dta^) := RealFloatCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btExtended:    tbtextended(res^.dta^):= RealFloatCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btChar, btU8, btS8:    tbtu8(res^.dta^) := RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 1, nil);
              {$IFNDEF IFPS3_NOWIDESTRING}btWideChar, {$ENDIF}btu16, bts16:  tbtu16(res^.dta^) := RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 2, nil);
              btclass, btu32, bts32:  tbtu32(res^.dta^) := RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 4, nil);
              btPChar:       TBTSTRING(res^.dta^) := Pchar(RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 4, nil));
              {$IFNDEF IFPS3_NOINT64}bts64:
                begin
                  EAX := RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 4, @EDX);
                  tbts64(res^.dta^) := Int64(EAX) shl 32 or EDX;
                end;
              {$ENDIF}
              btVariant, {$IFNDEF IFPS3_NOWIDESTRING}btWideString, {$ENDIF}
              btInterface, btArray, btrecord, btstring: begin GetPtr(res); RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 0, nil); end;
            else
              exit;
            end;
          end else begin
            RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 0, nil);
          end;
          Result := True;
        end;
    end;
  finally
    for i := CallData.Count -1 downto 0 do
    begin
      pp := CallData[i];
      case pp^ of
        0: DestroyOpenArray(Self, Pointer(pp));
      end;
    end;
    CallData.Free;
  end;
end;

type
  PScriptMethodInfo = ^TScriptMethodInfo;
  TScriptMethodInfo = record
    Se: TIFPSExec;
    ProcNo: Cardinal;
  end;


function MkMethod(FSE: TIFPSExec; No: Cardinal): TMethod;
begin
  if (no = 0) or (no = InvalidVal) then
  begin
    Result.Code := nil;
    Result.Data := nil;
  end else begin
    Result.Code := @MyAllMethodsHandler;
    Result.Data := GetMethodInfoRec(FSE, No);
  end;
end;


procedure PFree(Sender: TIFPSExec; P: PScriptMethodInfo);
begin
  Dispose(p);
end;

function GetMethodInfoRec(SE: TIFPSExec; ProcNo: Cardinal): Pointer;
var
  I: Longint;
  pp: PScriptMethodInfo;
begin
  if (ProcNo = 0) or (ProcNo = InvalidVal) then
  begin
    Result := nil;
    exit;
  end;
  I := 0;
  repeat
    pp := Se.FindProcResource2(@PFree, I);
    if (i <> -1) and (pp^.ProcNo = ProcNo) then
    begin
      Result := Pp;
      exit;
    end;
  until i = -1;
  New(pp);
  pp^.Se := TIFPSExec(Se);
  pp^.ProcNo := Procno;
  Se.AddResource(@PFree, pp);
  Result := pp;
end;





type
  TPtrArr = array[0..1000] of Pointer;
  PPtrArr = ^TPtrArr;
  TByteArr = array[0..1000] of byte;
  PByteArr = ^TByteArr;
  PPointer = ^Pointer;


function VirtualMethodPtrToPtr(Ptr, FSelf: Pointer): Pointer;
begin
  Result := PPtrArr(PPointer(FSelf)^)^[Longint(Ptr)];
end;

function VirtualClassMethodPtrToPtr(Ptr, FSelf: Pointer): Pointer;
begin
  Result := PPtrArr(FSelf)^[Longint(Ptr)];
end;


procedure CheckPackagePtr(var P: PByteArr);
begin
  if (word((@p[0])^) = $25FF) and (word((@p[6])^)=$C08B)then
  begin
    p := PPointer((@p[2])^)^;
  end;
end;

function FindVirtualMethodPtr(Ret: TIFPSRuntimeClass; FClass: TClass; Ptr: Pointer): Pointer;
// Idea of getting the number of VMT items from GExperts
var
  p: PPtrArr;
  I: Longint;
begin
  p := Pointer(FClass);
  CheckPackagePtr(PByteArr(Ptr));
  if Ret.FEndOfVMT = MaxInt then
  begin
    I := {$IFDEF VER90}-48{$ELSE}vmtSelfPtr{$ENDIF} div SizeOf(Pointer) + 1;
    while I < 0 do
    begin
      if I < 0 then
      begin
        if I <> ({$IFDEF VER90}-44{$ELSE}vmtTypeInfo{$ENDIF} div SizeOf(Pointer)) then
        begin // from GExperts code
          if (Longint(p^[I]) > Longint(p)) and ((Longint(p^[I]) - Longint(p))
            div
            4 < Ret.FEndOfVMT) then
          begin
            Ret.FEndOfVMT := (Longint(p^[I]) - Longint(p)) div SizeOf(Pointer);
          end;
        end;
      end;
      Inc(I);
    end;
    if Ret.FEndOfVMT = MaxInt then
    begin
      Ret.FEndOfVMT := 0; // cound not find EndOfVMT
      Result := nil;
      exit;
    end;
  end;
  I := 0;
  while I < Ret.FEndOfVMT do
  begin
    if p^[I] = Ptr then
    begin
      Result := Pointer(I);
      exit;
    end;
    I := I + 1;
  end;
  Result := nil;
end;

function NewTIFPSVariantIFC(avar: PIFPSvariant; varparam: boolean): TIFPSVariantIFC;
begin
  Result.VarParam := varparam;
  if avar = nil then
  begin
    Result.aType := nil;
    result.Dta := nil;
  end else
  begin
    Result.aType := avar.FType;
    result.Dta := @PIFPSVariantData(avar).Data;
    if Result.aType.BaseType = btPointer then
    begin
      Result.aType := Pointer(Pointer(IPointer(result.dta)+4)^);
      Result.Dta := Pointer(Result.dta^);
    end;
  end;
end;

function NewTIFPSVariantRecordIFC(avar: PIFPSVariant; Fieldno: Longint): TIFPSVariantIFC;
var
  offs: Cardinal;
begin
  Result := NewTIFPSVariantIFC(avar, false);
  if Result.aType.BaseType = btRecord then
  begin
    Offs := Cardinal(TIFTypeRec_Record(Result.aType).RealFieldOffsets[FieldNo]);
    Result.aType := TIFTypeRec_Record(Result.aType).FieldTypes[FieldNo];
    Result.Dta := Pointer(IPointer(Result.dta) + Offs);
  end else
  begin
    Result.Dta := nil;
    Result.aType := nil;
  end;
end;

function IFPSGetArrayField(const avar: TIFPSVariantIFC; Fieldno: Longint): TIFPSVariantIFC;
var
  offs: Cardinal;
begin
  Result := aVar;
  if Result.aType.BaseType = btArray then
  begin
    if (FieldNo <0) or (FieldNo >= IFPSDynArrayGetLength(Pointer(avar.Dta^), avar.aType)) then
    begin
      Result.Dta := nil;
      Result.aType := nil;
      exit;
    end;
    Offs := TIFTypeRec_Array(Result.aType).ArrayType.RealSize * Cardinal(FieldNo);
    Result.aType := TIFTypeRec_Array(Result.aType).ArrayType;
    Result.Dta := Pointer(IPointer(Result.dta^) + Offs);
  end else
  begin
    Result.Dta := nil;
    Result.aType := nil;
  end;
end;

function IFPSGetRecField(const avar: TIFPSVariantIFC; Fieldno: Longint): TIFPSVariantIFC;
var
  offs: Cardinal;
begin
  Result := aVar;
  if Result.aType.BaseType = btRecord then
  begin
    Offs := Cardinal(TIFTypeRec_Record(Result.aType).RealFieldOffsets[FieldNo]);
    Result.aType := TIFTypeRec_Record(Result.aType).FieldTypes[FieldNo];
    Result.Dta := Pointer(IPointer(Result.dta) + Offs);
  end else
  begin
    Result.Dta := nil;
    Result.aType := nil;
  end;
end;

function NewPIFPSVariantIFC(avar: PIFPSvariant; varparam: boolean): PIFPSVariantIFC;
begin
  New(Result);
  Result^ := NewTIFPSVariantIFC(avar, varparam);
end;


procedure DisposePIFPSvariantIFC(aVar: PIFPSVariantIFC);
begin
  if avar <> nil then
    Dispose(avar);
end;

procedure DisposePIFPSVariantIFCList(list: TIfList);
var
  i: Longint;
begin
  for i := list.Count -1 downto 0 do
    DisposePIFPSvariantIFC(list[i]);
  list.free;
end;

function ClassCallProcMethod(Caller: TIFPSExec; p: TIFExternalProcRec; Global, Stack: TIFPSStack): Boolean;
var
  i: Integer;
  MyList: TIfList;
  n: PIFVariant;
  v: PIFPSVariantIFC;
  FSelf: Pointer;
  CurrStack: Cardinal;
  cc: TIFPSCallingConvention;
  s: string;
  Tmp: TObject;
begin
  s := p.Decl;
  if length(S) < 2 then
  begin
    Result := False;
    exit;
  end;
  cc := TIFPSCallingConvention(s[1]);
  Delete(s, 1, 1);
  if s[1] = #0 then
    n := Stack[Stack.Count -1]
  else
    n := Stack[Stack.Count -2];
  if (n = nil) or (n^.FType.BaseType <> btClass)or (PIFPSVariantClass(n).Data = nil) then
  begin
    result := false;
    exit;
  end;
  FSelf := PIFPSVariantClass(n).Data;
  CurrStack := Cardinal(Stack.Count) - Cardinal(length(s)) -1;
  if s[1] = #0 then inc(CurrStack);
  MyList := tIfList.Create;
  for i := 2 to length(s) do
  begin
    MyList.Add(nil);
  end;
  for i := length(s) downto 2 do
  begin
    n := Stack[CurrStack];
    MyList[i - 2] := NewPIFPSVariantIFC(n, s[i] <> #0);
    inc(CurrStack);
  end;
  if s[1] <> #0 then
  begin
    v := NewPIFPSVariantIFC(Stack[CurrStack + 1], True);
  end else v := nil;
  try
    if p.Ext2 = nil then
      Result := Caller.InnerfuseCall(FSelf, p.Ext1, cc, MyList, v)
    else
      Result := Caller.InnerfuseCall(FSelf, VirtualMethodPtrToPtr(p.Ext1, FSelf), cc, MyList, v);
  except
    {$IFDEF IFPS3_D6PLUS}
    Tmp := AcquireExceptionObject;
    {$ELSE}
    if RaiseList <> nil then
    begin
      Tmp := Exception(PRaiseFrame(RaiseList)^.ExceptObject);
      PRaiseFrame(RaiseList)^.ExceptObject := nil;
    end else
      Tmp := nil;
    {$ENDIF}
    if tmp = nil then
      Caller.Cmd_Err(erCouldNotCallProc)
    else if Tmp is Exception then
      Caller.CMD_Err3(erCustomError, (tmp as Exception).Message, tmp)
    else
      Caller.Cmd_Err3(erCustomError, 'Could not call proc', tmp);
    Result := false;
  end;
  DisposePIFPSvariantIFC(v);
  DisposePIFPSVariantIFCList(mylist);
end;

function ClassCallProcConstructor(Caller: TIFPSExec; p: TIFExternalProcRec; Global, Stack: TIFPSStack): Boolean;
var
  i, h: Longint;
  v: PIFPSVariantIFC;
  MyList: TIfList;
  n: PIFVariant;
  FSelf: Pointer;
  CurrStack: Cardinal;
  cc: TIFPSCallingConvention;
  s: string;
  FType: PIFTypeRec;
  x: TIFPSRuntimeClass;
  Tmp: TObject;
  IntVal: PIFVariant;
begin
  n := Stack[Stack.Count -2];
  if (n = nil) or (n^.FType.BaseType <> btU32)  then
  begin
    result := false;
    exit;
  end;
  FType := Caller.GetTypeNo(PIFPSVariantU32(N).Data);
  if (FType = nil)  then
  begin
    Result := False;
    exit;
  end;
  h := MakeHash(FType.ExportName);
  FSelf := nil;
  for i := 0 to TIFPSRuntimeClassImporter(p.Ext2).FClasses.Count -1 do
  begin
    x:= TIFPSRuntimeClassImporter(p.Ext2).FClasses[i];
    if (x.FClassNameHash = h) and (x.FClassName = FType.ExportName) then
    begin
      FSelf := x.FClass;
    end;
  end;
  if FSelf = nil then begin
    Result := False;
    exit;
  end;
  s := p.Decl;
  if length(S) < 2 then
  begin
    Result := False;
    exit;
  end;
  cc := TIFPSCallingConvention(s[1]);
  Delete(s, 1, 1);
  CurrStack := Cardinal(Stack.Count) - Cardinal(length(s)) -1;
  if s[1] = #0 then inc(CurrStack);
  IntVal := CreateHeapVariant(Caller.FindType2(btU32));
  if IntVal = nil then
  begin
    Result := False;
    exit;
  end;
  PIFPSVariantU32(IntVal).Data := 1;
  MyList := tIfList.Create;
  MyList.Add(NewPIFPSVariantIFC(intval, false));
  for i := 2 to length(s) do
  begin
    MyList.Add(nil);
  end;
  for i := length(s) downto 2 do
  begin
    n :=Stack[CurrStack];
//    if s[i] <> #0 then
//    begin
//      MyList[i - 2] := NewPIFPSVariantIFC(n, s[i] <> #0);
//    end;
    MyList[i - 1] := NewPIFPSVariantIFC(n, s[i] <> #0);
    inc(CurrStack);
  end;
  if s[1] <> #0 then
  begin
    v := NewPIFPSVariantIFC(Stack[CurrStack + 1], True);
  end else v := nil;
  try
    Result := Caller.InnerfuseCall(FSelf, p.Ext1, cc, MyList, v);
  except
    {$IFDEF IFPS3_D6PLUS}
    Tmp := AcquireExceptionObject;
    {$ELSE}
    if RaiseList <> nil then
    begin
      Tmp := Exception(PRaiseFrame(RaiseList)^.ExceptObject);
      PRaiseFrame(RaiseList)^.ExceptObject := nil;
    end else
      Tmp := nil;
    {$ENDIF}
    if tmp = nil then
      Caller.Cmd_Err(erCouldNotCallProc)
    else if Tmp is Exception then
      Caller.CMD_Err3(erCustomError, (tmp as Exception).Message, tmp)
    else
      Caller.Cmd_Err3(erCustomError, 'Could not call proc', tmp);
    Result := false;
  end;
  DisposePIFPSvariantIFC(v);
  DisposePIFPSVariantIFCList(mylist);
  DestroyHeapVariant(intval);
end;


function ClassCallProcVirtualConstructor(Caller: TIFPSExec; p: TIFExternalProcRec; Global, Stack: TIFPSStack): Boolean;
var
  i, h: Longint;
  v: PIFPSVariantIFC;
  MyList: TIfList;
  n: PIFVariant;
  FSelf: Pointer;
  CurrStack: Cardinal;
  cc: TIFPSCallingConvention;
  s: string;
  FType: PIFTypeRec;
  x: TIFPSRuntimeClass;
  Tmp: TObject;
  IntVal: PIFVariant;
begin
  n := Stack[Stack.Count -2];
  if (n = nil) or (n^.FType.BaseType <> btU32)  then
  begin
    result := false;
    exit;
  end;
  FType := Caller.GetTypeNo(PIFPSVariantU32(N).Data);
  if (FType = nil)  then
  begin
    Result := False;
    exit;
  end;
  h := MakeHash(FType.ExportName);
  FSelf := nil;
  for i := 0 to TIFPSRuntimeClassImporter(p.Ext2).FClasses.Count -1 do
  begin
    x:= TIFPSRuntimeClassImporter(p.Ext2).FClasses[i];
    if (x.FClassNameHash = h) and (x.FClassName = FType.ExportName) then
    begin
      FSelf := x.FClass;
    end;
  end;
  if FSelf = nil then begin
    Result := False;
    exit;
  end;
  s := p.Decl;
  if length(S) < 2 then
  begin
    Result := False;
    exit;
  end;
  cc := TIFPSCallingConvention(s[1]);
  delete(s, 1, 1);
  CurrStack := Cardinal(Stack.Count) - Cardinal(length(s)) -1;
  if s[1] = #0 then inc(CurrStack);
  IntVal := CreateHeapVariant(Caller.FindType2(btU32));
  if IntVal = nil then
  begin
    Result := False;
    exit;
  end;
  PIFPSVariantU32(IntVal).Data := 1;
  MyList := tIfList.Create;
  MyList.Add(NewPIFPSVariantIFC(intval, false));
  for i := 2 to length(s) do
  begin
    MyList.Add(nil);
  end;
  for i := length(s) downto 2 do
  begin
    n :=Stack[CurrStack];
    MyList[i - 1] := NewPIFPSVariantIFC(n, s[i] <> #0);
    inc(CurrStack);
  end;
  if s[1] <> #0 then
  begin
    v := NewPIFPSVariantIFC(Stack[CurrStack + 1], True);
  end else v := nil;
  try
    Result := Caller.InnerfuseCall(FSelf, VirtualClassMethodPtrToPtr(p.Ext1, FSelf), cc, MyList, v);
  except
    {$IFDEF IFPS3_D6PLUS}
    Tmp := AcquireExceptionObject;
    {$ELSE}
    if RaiseList <> nil then
    begin
      Tmp := Exception(PRaiseFrame(RaiseList)^.ExceptObject);
      PRaiseFrame(RaiseList)^.ExceptObject := nil;
    end else
      Tmp := nil;
    {$ENDIF}
    if tmp = nil then
      Caller.Cmd_Err(erCouldNotCallProc)
    else if Tmp is Exception then
      Caller.CMD_Err3(erCustomError, (tmp as Exception).Message, tmp)
    else
      Caller.Cmd_Err3(erCustomError, 'Could not call proc', tmp);
    Result := false;
  end;
  DisposePIFPSvariantIFC(v);
  DisposePIFPSVariantIFCList(mylist);
  DestroyHeapVariant(intval);
end;

function CastProc(Caller: TIFPSExec; p: TIFExternalProcRec; Global, Stack: TIFPSStack): Boolean;
var
  TypeNo, InVar, ResVar: TIFPSVariantIFC;
  FSelf: TClass;
  FType: PIFTypeRec;
  H, I: Longint;
  x: TIFPSRuntimeClass;
begin
  TypeNo := NewTIFPSVariantIFC(Stack[Stack.Count-3], false);
  InVar := NewTIFPSVariantIFC(Stack[Stack.Count-2], false);
  ResVar := NewTIFPSVariantIFC(Stack[Stack.Count-1], true);
  if (TypeNo.Dta = nil) or (InVar.Dta = nil) or (ResVar.Dta = nil) or 
  (TypeNo.aType.BaseType <> btu32) or (resvar.aType <> Caller.FTypes[tbtu32(Typeno.dta^)])
  then
  begin
    Result := False;
    Exit;
  end;
{$IFNDEF IFPS3_NOINTERFACES}
  if (invar.atype.BaseType = btInterface) and (resvar.aType.BaseType = btInterface) then
  begin
{$IFNDEF IFPS3_D3PLUS}
    if IUnknown(resvar.Dta^) <> nil then
      IUnknown(resvar.Dta^).Release;
{$ENDIF}      
    IUnknown(resvar.Dta^) := nil;
    if (IUnknown(invar.Dta^) = nil) or (IUnknown(invar.Dta^).QueryInterface(TIFTypeRec_Interface(ResVar.aType).Guid, IUnknown(resvar.Dta^)) <> 0) then
    begin
      Caller.CMD_Err2(erCustomError, 'Cannot cast interface');
      Result := False;
      exit;
    end;
{$IFDEF IFPS3_D3PLUS}
  end else if (Invar.aType.BaseType = btclass) and (resvar.aType.BaseType = btInterface) then
  begin
{$IFNDEF IFPS3_D3PLUS}
    if IUnknown(resvar.Dta^) <> nil then
      IUnknown(resvar.Dta^).Release;
{$ENDIF}      
    IUnknown(resvar.Dta^) := nil;
    if (TObject(invar.Dta^)= nil) or (not TObject(invar.dta^).GetInterface(TIFTypeRec_Interface(ResVar.aType).Guid, IUnknown(resvar.Dta^))) then
    begin
      Caller.CMD_Err2(erCustomError, 'Cannot cast interface');
      Result := False;
      exit;
    end;
{$ENDIF}    
  end else {$ENDIF}if (invar.aType.BaseType = btclass) and (resvar.aType.BaseType = btclass ) then
  begin
    FType := Caller.GetTypeNo(tbtu32(TypeNo.Dta^));
    if (FType = nil)  then
    begin
      Result := False;
      exit;
    end;
    h := MakeHash(FType.ExportName);
    FSelf := nil;
    for i := 0 to TIFPSRuntimeClassImporter(p.Ext2).FClasses.Count -1 do
    begin
      x:= TIFPSRuntimeClassImporter(p.Ext2).FClasses[i];
      if (x.FClassNameHash = h) and (x.FClassName = FType.ExportName) then
      begin
        FSelf := x.FClass;
      end;
    end;
    if FSelf = nil then begin
      Result := False;
      exit;
    end;

    try
      TObject(ResVar.Dta^) := TObject(InVar.Dta^) as FSelf;
    except
      Result := False;
      exit;
    end;
  end else
  begin
    Result := False;
    exit;
  end;
  result := True;
end;


function NilProc(Caller: TIFPSExec; p: TIFExternalProcRec; Global, Stack: TIFPSStack): Boolean;
var
  n: TIFPSVariantIFC;
begin
  n := NewTIFPSVariantIFC(Stack[Stack.Count-1], True);
  if (n.Dta = nil) or ((n.aType.BaseType <> btClass) and (n.aType.BaseType <> btInterface)) then
  begin
    Result := False;
    Exit;
  end;
{$IFNDEF IFPS3_NOINTERFACES}
  if n.aType.BaseType = btInterface then
  begin
    {$IFNDEF IFPS3_D3PLUS}
    if IUnknown(n.Dta^) <> nil then
      IUnknown(n.Dta^).Release;
    {$ENDIF}
    IUnknown(n.Dta^) := nil;
  end else
  {$ENDIF}
    Pointer(n.Dta^) := nil;
  result := True;
end;
function IntfCallProc(Caller: TIFPSExec; p: TIFExternalProcRec; Global, Stack: TIFPSStack): Boolean;
var
  i: Integer;
  MyList: TIfList;
  n: TIFPSVariantIFC;
  n2: PIFPSVariantIFC;
  FSelf: Pointer;
  CurrStack: Cardinal;
  cc: TIFPSCallingConvention;
  s: string;
  Tmp: TObject;
begin
  s := p.Decl;
  if length(S) < 2 then
  begin
    Result := False;
    exit;
  end;
  cc := TIFPSCallingConvention(s[1]);
  Delete(s, 1, 1);
  if s[1] = #0 then
    n := NewTIFPSVariantIFC(Stack[Stack.Count -1], false)
  else
    n := NewTIFPSVariantIFC(Stack[Stack.Count -2], false);
  if (n.dta = nil) or (n.atype.BaseType <> btInterface) or (Pointer(n.Dta^) = nil) then
  begin
    result := false;
    exit;
  end;
  FSelf := Pointer(n.dta^);
  CurrStack := Cardinal(Stack.Count) - Cardinal(length(s)) -1;
  if s[1] = #0 then inc(CurrStack);
  MyList := tIfList.Create;
  for i := 2 to length(s) do
  begin
    MyList.Add(nil);
  end;
  for i := length(s) downto 2 do
  begin
    MyList[i - 2] := NewPIFPSVariantIFC(Stack[CurrStack], s[i] <> #0);
    inc(CurrStack);
  end;
  if s[1] <> #0 then
  begin
    n2 := NewPIFPSVariantIFC(Stack[CurrStack + 1], True);
  end else n2 := nil;
  try
    Caller.InnerfuseCall(FSelf, Pointer(Pointer(Cardinal(FSelf^) + (Cardinal(p.Ext1) * Sizeof(Pointer)))^), cc, MyList, n2);
    result := true;
  except
    {$IFDEF IFPS3_D6PLUS}
    Tmp := AcquireExceptionObject;
    {$ELSE}
    if RaiseList <> nil then
    begin
      Tmp := Exception(PRaiseFrame(RaiseList)^.ExceptObject);
      PRaiseFrame(RaiseList)^.ExceptObject := nil;
    end else
      Tmp := nil;
    {$ENDIF}
    if tmp = nil then
      Caller.Cmd_Err(erCouldNotCallProc)
    else if Tmp is Exception then
      Caller.CMD_Err3(erCustomError, (tmp as Exception).Message, tmp)
    else
      Caller.Cmd_Err3(erCustomError, 'Could not call proc', tmp);
    Result := false;
  end;
  DisposePIFPSvariantIFC(n2);
  DisposePIFPSVariantIFCList(MyList);
end;


function InterfaceProc(Sender: TIFPSExec; p: TIFExternalProcRec; Tag: Pointer): Boolean;
var
  s: string;
begin
  s := p.Decl;
  delete(s,1,5); // delete 'intf:'
  if s = '' then
  begin
    Result := False;
    exit;
  end;
  if s[1] = '.'then
  begin
    Delete(s,1,1);
    if length(S) < 6 then
    begin
      Result := False;
      exit;
    end;
    p.ProcPtr := IntfCallProc;
    p.Ext1 := Pointer((@s[1])^); // Proc Offset
    Delete(s,1,4);
    P.Decl := s;
    Result := True;
  end else Result := False;
end;


function getMethodNo(P: TMethod): Cardinal;
begin
  if (p.Code <> @MyAllMethodsHandler) or (p.Data = nil) then
    Result := 0
  else
  begin
    Result := PScriptMethodInfo(p.Data)^.ProcNo;
  end;
end;

function ClassCallProcProperty(Caller: TIFPSExec; p: TIFExternalProcRec; Global, Stack: TIFPSStack): Boolean;
var
  n: TIFPSVariantIFC;
  ltemp: Longint;
  FSelf: Pointer;
  tmp: TObject;
begin
  try
    if p.Ext2 = Pointer(0) then
    begin
      n := NewTIFPSVariantIFC(Stack[Stack.Count -1], False);
      if (n.Dta = nil) or (n.aType.BaseType <> btclass)  then
      begin
        result := false;
        exit;
      end;
      FSelf := Pointer(n.dta^);
      if FSelf = nil then
      begin
        Caller.CMD_Err(erCouldNotCallProc);
        Result := False;
        exit;
      end;
      n := NewTIFPSVariantIFC(Stack[Stack.Count -2], false);
      if (PPropInfo(p.Ext1)^.PropType^.Kind = tkMethod) and ((n.aType.BaseType = btu32) or (n.aType.BaseType = btProcPtr))then
      begin
        SetMethodProp(TObject(FSelf), PPropInfo(p.Ext1), MkMethod(Caller, tbtu32(n.dta^)));
      end else
      case n.aType.BaseType of
        btSet:
          begin
            ltemp := 0;
            move(Byte(n.Dta^), ltemp, TIFTypeRec_Set(n.aType).aByteSize);
            SetOrdProp(TObject(FSelf), PPropInfo(p.Ext1), ltemp);
          end;
        btChar, btU8: SetOrdProp(TObject(FSelf), PPropInfo(p.Ext1), tbtu8(n.Dta^));
        btS8: SetOrdProp(TObject(FSelf), PPropInfo(p.Ext1), tbts8(n.Dta^));
        {$IFNDEF IFPS3_NOWIDESTRING}btwidechar, {$ENDIF}btU16: SetOrdProp(TObject(FSelf), PPropInfo(p.Ext1), tbtu16(n.Dta^));
        btS16: SetOrdProp(TObject(FSelf), PPropInfo(p.Ext1), tbts16(n.Dta^));
        btU32: SetOrdProp(TObject(FSelf), PPropInfo(p.Ext1), tbtu32(n.Dta^));
        btS32: SetOrdProp(TObject(FSelf), PPropInfo(p.Ext1), tbts32(n.Dta^));
        btSingle: SetFloatProp(TObject(FSelf), p.Ext1, tbtsingle(n.Dta^));
        btDouble: SetFloatProp(TObject(FSelf), p.Ext1, tbtdouble(n.Dta^));
        btExtended: SetFloatProp(TObject(FSelf), p.Ext1, tbtextended(n.Dta^));
        btString: SetStrProp(TObject(FSelf), p.Ext1, string(n.Dta^));
        btPChar: SetStrProp(TObject(FSelf), p.Ext1, pchar(n.Dta^));
        btClass: SetOrdProp(TObject(FSelf), P.Ext1, Longint(n.Dta^));
        else
        begin
          Result := False;
          exit;
        end;
      end;
      Result := true;
    end else begin
      n := NewTIFPSVariantIFC(Stack[Stack.Count -2], False);
      if (n.dta = nil) or (n.aType.BaseType <> btClass)then
      begin
        result := false;
        exit;
      end;
      FSelf := Pointer(n.dta^);
      if FSelf = nil then
      begin
        Caller.CMD_Err(erCouldNotCallProc);
        Result := False;
        exit;
      end;
      n := NewTIFPSVariantIFC(Stack[Stack.Count -1], false);
      if (PPropInfo(p.Ext1)^.PropType^.Kind = tkMethod) and ((n.aType.BaseType = btu32) or (n.aType.BaseType = btprocptr)) then
      begin
        Cardinal(n.Dta^) := GetMethodNo(GetMethodProp(TObject(FSelf), PPropInfo(p.Ext1)));
      end else
      case n.aType.BaseType of
        btSet:
          begin
            ltemp := GetOrdProp(TObject(FSelf), PPropInfo(p.Ext1));
            move(ltemp, Byte(n.Dta^), TIFTypeRec_Set(n.aType).aByteSize);
          end;
        btU8: tbtu8(n.Dta^) := GetOrdProp(TObject(FSelf), p.Ext1);
        btS8: tbts8(n.Dta^) := GetOrdProp(TObject(FSelf), p.Ext1);
        btU16: tbtu16(n.Dta^) := GetOrdProp(TObject(FSelf), p.Ext1);
        btS16: tbts16(n.Dta^) := GetOrdProp(TObject(FSelf), p.Ext1);
        btU32: tbtu32(n.Dta^) := GetOrdProp(TObject(FSelf), p.Ext1);
        btS32: tbts32(n.Dta^) := GetOrdProp(TObject(FSelf), p.Ext1);
        btSingle: tbtsingle(n.Dta^) := GetFloatProp(TObject(FSelf), p.Ext1);
        btDouble: tbtdouble(n.Dta^) := GetFloatProp(TObject(FSelf), p.Ext1);
        btExtended: tbtextended(n.Dta^) := GetFloatProp(TObject(FSelf), p.Ext1);
        btString: string(n.Dta^) := GetStrProp(TObject(FSelf), p.Ext1);
        btClass: Longint(n.dta^) := GetOrdProp(TObject(FSelf), p.Ext1);
      else
        begin
          Result := False;
          exit;
        end;

      end;
      Result := True;
    end;
  except
    {$IFDEF IFPS3_D6PLUS}
    Tmp := AcquireExceptionObject;
    {$ELSE}
    if RaiseList <> nil then
    begin
      Tmp := Exception(PRaiseFrame(RaiseList)^.ExceptObject);
      PRaiseFrame(RaiseList)^.ExceptObject := nil;
    end else
      Tmp := nil;
    {$ENDIF}
    if tmp = nil then
      Caller.Cmd_Err(erCouldNotCallProc)
    else if Tmp is Exception then
      Caller.CMD_Err3(erCustomError, (tmp as Exception).Message, tmp)
    else
      Caller.Cmd_Err3(erCustomError, 'Could not call proc', tmp);
    Result := False;
  end;
end;

function ClassCallProcPropertyHelper(Caller: TIFPSExec; p: TIFExternalProcRec; Global, Stack: TIFPSStack): Boolean;
var
  I, ParamCount: Longint;
  Params: TIfList;
  n: TIFPSVariantIFC;
  FSelf: Pointer;
  Tmp: TObject;
begin
  if Length(P.Decl) < 4 then begin
    Result := False;
    exit;
  end;
  ParamCount := Longint((@P.Decl[1])^);
  if Longint(Stack.Count) < ParamCount +1 then begin
    Result := False;
    exit;
  end;
  Dec(ParamCount);
  if p.Ext1 <> nil then // read
  begin
    n := NewTIFPSVariantIFC(Stack[Longint(Stack.Count) - 2], False);
    if (n.Dta = nil) or (n.aType.BaseType <> btClass) then
    begin
      result := false;
      exit;
    end;
    FSelf := pointer(n.Dta^);
    if FSelf = nil then
    begin
      Caller.CMD_Err(erCouldNotCallProc);
      Result := False;
      exit;
    end;
    Params := TIfList.Create;
    Params.Add(NewPIFPSVariantIFC(Stack[Longint(Stack.Count) - 1], True));
    for i := Stack.Count -3 downto Longint(Stack.Count) - ParamCount -2 do
    begin
      Params.Add(NewPIFPSVariantIFC(Stack[I], False));
    end;
    try
      Result := Caller.InnerfuseCall(FSelf, p.Ext1, cdRegister, Params, nil);
    except
      {$IFDEF IFPS3_D6PLUS}
      Tmp := AcquireExceptionObject;
      {$ELSE}
      if RaiseList <> nil then
      begin
        Tmp := Exception(PRaiseFrame(RaiseList)^.ExceptObject);
        PRaiseFrame(RaiseList)^.ExceptObject := nil;
      end else
        Tmp := nil;
      {$ENDIF}
      if tmp = nil then
        Caller.Cmd_Err(erCouldNotCallProc)
      else if Tmp is Exception then
        Caller.CMD_Err3(erCustomError, (tmp as Exception).Message, tmp)
      else
        Caller.Cmd_Err3(erCustomError, 'Could not call proc', tmp);
      Result := false;
    end;
    DisposePIFPSVariantIFCList(Params);
  end else begin
    n := NewTIFPSVariantIFC(Stack[Longint(Stack.Count) - 1], False);
    if (n.Dta = nil) or (n.aType.BaseType <> btClass) then
    begin
      result := false;
      exit;
    end;
    FSelf := pointer(n.Dta^);
    if FSelf = nil then
    begin
      Caller.CMD_Err(erCouldNotCallProc);
      Result := False;
      exit;
    end;
    Params := TIfList.Create;
    Params.Add(NewPIFPSVariantIFC(Stack[Longint(Stack.Count) - ParamCount - 2], False));

    for i := Stack.Count -2 downto Longint(Stack.Count) - ParamCount -1 do
    begin
      Params.Add(NewPIFPSVariantIFC(Stack[I], False));
    end;
    try
      Result := Caller.InnerfuseCall(FSelf, p.Ext2, cdregister, Params, nil);
    except
      {$IFDEF IFPS3_D6PLUS}
      Tmp := AcquireExceptionObject;
      {$ELSE}
      if RaiseList <> nil then
      begin
        Tmp := Exception(PRaiseFrame(RaiseList)^.ExceptObject);
        PRaiseFrame(RaiseList)^.ExceptObject := nil;
      end else
        Tmp := nil;
      {$ENDIF}
      if tmp = nil then
        Caller.Cmd_Err(erCouldNotCallProc)
      else if Tmp is Exception then
        Caller.CMD_Err3(erCustomError, (tmp as Exception).Message, tmp)
      else
        Caller.Cmd_Err3(erCustomError, 'Could not call proc', tmp);
      Result := false;
    end;
    DisposePIFPSVariantIFCList(Params);
  end;
end;

function ClassCallProcPropertyHelperName(Caller: TIFPSExec; p: TIFExternalProcRec; Global, Stack: TIFPSStack): Boolean;
var
  I, ParamCount: Longint;
  Params: TIfList;
  tt: PIFVariant;
  n: TIFPSVariantIFC;
  FSelf: Pointer;
  Tmp: TObject;
begin
  if Length(P.Decl) < 4 then begin
    Result := False;
    exit;
  end;
  ParamCount := Longint((@P.Decl[1])^);
  if Longint(Stack.Count) < ParamCount +1 then begin
    Result := False;
    exit;
  end;
  Dec(ParamCount);
  if p.Ext1 <> nil then // read
  begin
    n := NewTIFPSVariantIFC(Stack[Longint(Stack.Count) - 2], false);
    if (n.Dta = nil) or (n.aType.BaseType <> btClass) then
    begin
      result := false;
      exit;
    end;
    FSelf := Tobject(n.dta^);
    Params := TIfList.Create;
    Params.Add(NewPIFPSVariantIFC(Stack[Longint(Stack.Count) - 1], True));
    for i := Stack.Count -3 downto Longint(Stack.Count) - ParamCount -2 do
      Params.Add(NewPIFPSVariantIFC(Stack[I], False));
    tt := CreateHeapVariant(Caller.FindType2(btString));
    if tt <> nil then
    begin
      PIFPSVariantAString(tt).Data := p.Name;
      Params.Add(NewPIFPSVariantIFC(tt, false));
    end;
    try
      Result := Caller.InnerfuseCall(FSelf, p.Ext1, cdRegister, Params, nil);
    except
      {$IFDEF IFPS3_D6PLUS}
      Tmp := AcquireExceptionObject;
      {$ELSE}
      if RaiseList <> nil then
      begin
        Tmp := Exception(PRaiseFrame(RaiseList)^.ExceptObject);
        PRaiseFrame(RaiseList)^.ExceptObject := nil;
      end else
        Tmp := nil;
      {$ENDIF}
      if tmp = nil then
        Caller.Cmd_Err(erCouldNotCallProc)
      else if Tmp is Exception then
        Caller.CMD_Err3(erCustomError, (tmp as Exception).Message, tmp)
      else
        Caller.Cmd_Err3(erCustomError, 'Could not call proc', tmp);
      Result := false;
    end;
    DestroyHeapVariant(tt);
    DisposePIFPSVariantIFCList(Params);
  end else begin
    n := NewTIFPSVariantIFC(Stack[Longint(Stack.Count) - 1], false);
    if (n.Dta = nil) or (n.aType.BaseType <> btClass) then
    begin
      result := false;
      exit;
    end;
    FSelf := Tobject(n.dta^);
    Params := TIfList.Create;
    Params.Add(NewPIFPSVariantIFC(Stack[Longint(Stack.Count) - 2], True));

    for i := Stack.Count -2 downto Longint(Stack.Count) - ParamCount -1 do
    begin
      Params.Add(NewPIFPSVariantIFC(Stack[I], false));
    end;
    tt := CreateHeapVariant(Caller.FindType2(btString));
    if tt <> nil then
    begin
      PIFPSVariantAString(tt).Data := p.Name;
      Params.Add(NewPIFPSVariantIFC(tt, false));
    end;
    try
      Result := Caller.InnerfuseCall(FSelf, p.Ext2, cdregister, Params, nil);
    except
      {$IFDEF IFPS3_D6PLUS}
      Tmp := AcquireExceptionObject;
      {$ELSE}
      if RaiseList <> nil then
      begin
        Tmp := Exception(PRaiseFrame(RaiseList)^.ExceptObject);
        PRaiseFrame(RaiseList)^.ExceptObject := nil;
      end else
        Tmp := nil;
      {$ENDIF}
      if tmp = nil then
        Caller.Cmd_Err(erCouldNotCallProc)
      else if Tmp is Exception then
        Caller.CMD_Err3(erCustomError, (tmp as Exception).Message, tmp)
      else
        Caller.Cmd_Err3(erCustomError, 'Could not call proc', tmp);
      Result := false;
    end;
    DestroyHeapVariant(tt);
    DisposePIFPSVariantIFCList(Params);
  end;
end;



function ClassCallProcEventPropertyHelper(Caller: TIFPSExec; p: TIFExternalProcRec; Global, Stack: TIFPSStack): Boolean;
{Event property helper}
var
  I, ParamCount: Longint;
  Params: TIfList;
  n: TIFPSVariantIFC;
  n2: PIFVariant;
  FSelf: Pointer;
  Tmp: TObject;
begin
  if Length(P.Decl) < 4 then begin
    Result := False;
    exit;
  end;
  ParamCount := Longint((@P.Decl[1])^);
  if Longint(Stack.Count) < ParamCount +1 then begin
    Result := False;
    exit;
  end;
  Dec(ParamCount);
  if p.Ext1 <> nil then // read
  begin
    n := NewTIFPSVariantIFC(Stack[Longint(Stack.Count) - 2], false);
    if (n.Dta = nil) or (n.aType.BaseType <> btClass) then
    begin
      result := false;
      exit;
    end;
    FSelf := Tobject(n.dta^);
    n := NewTIFPSVariantIFC(Stack[Longint(Stack.Count) - 1], True); // Result
    if (n.aType.BaseType <> btU32) and (n.aType.BaseType <> btProcPtr) then
    begin
      Result := False;
      exit;
    end;
    n2 := CreateHeapVariant(Caller.FindType2(btDouble));
    if n2 = nil then
    begin
      Result := False;
      exit;
    end;
    TMethod(PIFPSVariantDouble(n2).Data).Code := nil;
    TMethod(PIFPSVariantDouble(n2).Data).Data := nil;
    Params := TIfList.Create;
    Params.Add(NewPIFPSVariantIFC(n2, True));
    for i := Stack.Count -3 downto Longint(Stack.Count) - ParamCount -2 do
      Params.Add(NewPIFPSVariantIFC(Stack[i], False));
    try
      Result := Caller.InnerfuseCall(FSelf, p.Ext1, cdRegister, Params, nil);
    except
      {$IFDEF IFPS3_D6PLUS}
      Tmp := AcquireExceptionObject;
      {$ELSE}
      if RaiseList <> nil then
      begin
        Tmp := Exception(PRaiseFrame(RaiseList)^.ExceptObject);
        PRaiseFrame(RaiseList)^.ExceptObject := nil;
      end else
        Tmp := nil;
      {$ENDIF}
      if tmp = nil then
        Caller.Cmd_Err(erCouldNotCallProc)
      else if Tmp is Exception then
        Caller.CMD_Err3(erCustomError, (tmp as Exception).Message, tmp)
      else
        Caller.Cmd_Err3(erCustomError, 'Could not call proc', tmp);
      Result := false;
    end;
    Cardinal(n.Dta^) := getMethodNo(TMethod(PIFPSVariantDouble(n2).Data));
    DestroyHeapVariant(n2);
    DisposePIFPSVariantIFCList(Params);
  end else begin
    n := NewTIFPSVariantIFC(Stack[Longint(Stack.Count) - 1], false);
    if (n.Dta = nil) or (n.aType.BaseType <> btClass) then
    begin
      result := false;
      exit;
    end;
    FSelf := Tobject(n.dta^);
    n := NewTIFPSVariantIFC(Stack[Longint(Stack.Count) - 2], false);
    if (n.Dta = nil) or ((n.aType.BaseType <> btu32) and (n.aType.BaseType <> btProcPtr)) then
    begin
      result := false;
      exit;
    end;
    n2 := CreateHeapVariant(Caller.FindType2(btDouble));
    if n2 = nil then
    begin
      Result := False;
      exit;
    end;
    TMethod(PIFPSVariantDouble(n2).Data) := MkMethod(Caller, cardinal(n.dta^));
    Params := TIfList.Create;
    Params.Add(NewPIFPSVariantIFC(n2, False));

    for i := Stack.Count -2 downto Longint(Stack.Count) - ParamCount -1 do
    begin
      Params.Add(NewPIFPSVariantIFC(Stack[I], False));
    end;
    try
      Result := Caller.InnerfuseCall(FSelf, p.Ext2, cdregister, Params, nil);
    except
      {$IFDEF IFPS3_D6PLUS}
      Tmp := AcquireExceptionObject;
      {$ELSE}
      if RaiseList <> nil then
      begin
        Tmp := Exception(PRaiseFrame(RaiseList)^.ExceptObject);
        PRaiseFrame(RaiseList)^.ExceptObject := nil;
      end else
        Tmp := nil;
      {$ENDIF}
      if tmp = nil then
        Caller.Cmd_Err(erCouldNotCallProc)
      else if Tmp is Exception then
        Caller.CMD_Err3(erCustomError, (tmp as Exception).Message, tmp)
      else
        Caller.Cmd_Err3(erCustomError, 'Could not call proc', tmp);
      Result := false;
    end;
    DestroyHeapVariant(n2);
    DisposePIFPSVariantIFCList(Params);
  end;
end;


{'class:'+CLASSNAME+'|'+FUNCNAME+'|'+chr(CallingConv)+chr(hasresult)+params

For property write functions there is an '@' after the funcname.
}
function SpecImport(Sender: TIFPSExec; p: TIFExternalProcRec; Tag: Pointer): Boolean;
var
  H, I: Longint;
  S, s2: string;
  CL: TIFPSRuntimeClass;
  Px: PClassItem;
  pp: PPropInfo;
  IsRead: Boolean;
begin
  s := p.Decl;
  delete(s, 1, 6);
  if s = '-' then {nil function}
  begin
    p.ProcPtr := NilProc;
    Result := True;
    exit;
  end;
  if s = '+' then {cast function}
  begin
    p.ProcPtr := CastProc;
    p.Ext2 := Tag;
    Result := True;
    exit;
  end;
  s2 := copy(S, 1, pos('|', s)-1);
  delete(s, 1, length(s2) + 1);
  H := MakeHash(s2);
  ISRead := False;
  cl := nil;
  for I := TIFPSRuntimeClassImporter(Tag).FClasses.Count -1 downto 0 do
  begin
    Cl := TIFPSRuntimeClassImporter(Tag).FClasses[I];
    if (Cl.FClassNameHash = h) and (cl.FClassName = s2) then
    begin
      IsRead := True;
      break;
    end;
  end;
  if not isRead then begin
    Result := False;
    exit;                 
  end;
  s2 := copy(S, 1, pos('|', s)-1);
  delete(s, 1, length(s2) + 1);
  if (s2 <> '') and (s2[length(s2)] = '@') then
  begin
    IsRead := False;
    Delete(S2, length(s2), 1);
  end else
    isRead := True;
  p.Name := s2;
  H := MakeHash(s2);
  for i := cl.FClassItems.Count -1 downto 0 do
  begin
    px := cl.FClassItems[I];
    if (px^.FNameHash = h) and (px^.FName = s2) then
    begin
      p.Decl := s;
      case px^.b of
  {0: ext1=ptr}
  {1: ext1=pointerinlist}
  {2: ext1=propertyinfo}
  {3: ext1=readfunc; ext2=writefunc}
        4:
          begin
            p.ProcPtr := ClassCallProcConstructor;
            p.Ext1 := px^.Ptr;
            p.Ext2 := Tag;
          end;
        5:
          begin
            p.ProcPtr := ClassCallProcVirtualConstructor;
            p.Ext1 := px^.Ptr;
            p.Ext2 := Tag;
          end;
        6:
          begin
            p.ProcPtr := ClassCallProcEventPropertyHelper;
            if IsRead then
            begin
              p.Ext1 := px^.FReadFunc;
              p.Ext2 := nil;
            end else
            begin
              p.Ext1 := nil;
              p.Ext2 := px^.FWriteFunc;
            end;
          end;
        0:
          begin
            p.ProcPtr := ClassCallProcMethod;
            p.Ext1 := px^.Ptr;
            p.Ext2 := nil;
          end;
        1:
          begin
            p.ProcPtr := ClassCallProcMethod;
            p.Ext1 := px^.PointerInList;
            p.ext2 := pointer(1);
          end;
        3:
          begin
            p.ProcPtr := ClassCallProcPropertyHelper;
            if IsRead then
            begin
              p.Ext1 := px^.FReadFunc;
              p.Ext2 := nil;
            end else
            begin
              p.Ext1 := nil;
              p.Ext2 := px^.FWriteFunc;
            end;
          end;
        7:
          begin
            p.ProcPtr := ClassCallProcPropertyHelperName;
            if IsRead then
            begin
              p.Ext1 := px^.FReadFunc;
              p.Ext2 := nil;
            end else
            begin
              p.Ext1 := nil;
              p.Ext2 := px^.FWriteFunc;
            end;
          end;
        else
         begin
           result := false;
           exit;
         end;
      end;
      Result := true;
      exit;
    end;
  end;
  pp := GetPropInfo(cl.FClass.ClassInfo, s2);
  if pp <> nil then
  begin
     p.ProcPtr := ClassCallProcProperty;
     p.Ext1 := pp;
     if IsRead then
       p.Ext2 := Pointer(1)
     else
       p.Ext2 := Pointer(0);
     Result := True;
  end else
    result := false;
end;

procedure RegisterClassLibraryRuntime(SE: TIFPSExec; Importer: TIFPSRuntimeClassImporter);
begin
  SE.AddSpecialProcImport('class', SpecImport, Importer);
end;


procedure TIFPSExec.ClearspecialProcImports;
var
  I: Longint;
  P: PSpecialProc;
begin
  for I := FSpecialProcList.Count -1 downto 0 do
  begin
    P := FSpecialProcList[I];
    Dispose(p);
  end;
  FSpecialProcList.Clear;
end;

procedure TIFPSExec.RaiseCurrentException;
var
  ExObj: TObject;
begin
  if ExEx = erNoError then exit; // do nothing
  ExObj := Self.ExObject;
  if ExObj <> nil then
  begin
    Self.ExObject := nil;
    raise ExObj;
  end;
  raise EIFPS3Exception.Create(TIFErrorToString(ExceptionCode, ExceptionString), Self, ExProc, ExPos);
end;

procedure TIFPSExec.CMD_Err2(EC: TIFError; const Param: string);
begin
  CMD_Err3(EC, Param, Nil);
end;

function TIFPSExec.GetProcAsMethod(const ProcNo: Cardinal): TMethod;
begin
  Result := MkMethod(Self, ProcNo);
end;

function TIFPSExec.GetProcAsMethodN(const ProcName: string): TMethod;
var
  procno: Cardinal;
begin
  Procno := GetProc(ProcName);
  if Procno = InvalidVal then
  begin
    Result.Code := nil;
    Result.Data := nil;
  end
  else
    Result := MkMethod(Self, procno)
end;


procedure TIFPSExec.RegisterAttributeType(useproc: TIFPSAttributeUseProc;
  const TypeName: string);
var
  att: TIFPSAttributeType;
begin
  att := TIFPSAttributeType.Create;
  att.TypeName := TypeName;
  att.TypeNameHash := MakeHash(TypeName);
  att.UseProc := UseProc;
  FAttributeTypes.Add(att);
end;

function TIFPSExec.GetProcCount: Cardinal;
begin
  Result := FProcs.Count;
end;

function TIFPSExec.GetTypeCount: Longint;
begin
  Result := FTypes.Count;
end;

function TIFPSExec.GetVarCount: Longint;
begin
  Result := FGlobalVars.Count;
end;

function TIFPSExec.FindSpecialProcImport(
  P: TIFPSOnSpecialProcImport): pointer;
var
  i: Longint;
  pr: PSpecialProc;
begin
  for i := FSpecialProcList.Count -1 downto 0 do
  begin
    pr := FSpecialProcList[i];
    if @pr.P = @p then
    begin
      Result := pr.tag;
      exit;
    end;
  end;
  result := nil;
end;

{ TIFPSRuntimeClass }

constructor TIFPSRuntimeClass.Create(aClass: TClass; const AName: string);
begin
  inherited Create;
  FClass := AClass;
  if AName = '' then
  begin
    FClassName := FastUpperCase(aClass.ClassName);
    FClassNameHash := MakeHash(FClassName);
  end else begin
    FClassName := FastUppercase(AName);
    FClassNameHash := MakeHash(FClassName);
  end;
  FClassItems:= TIfList.Create;
  FEndOfVmt := MaxInt;
end;

destructor TIFPSRuntimeClass.Destroy;
var
  I: Longint;
  P: PClassItem;
begin
  for i:= FClassItems.Count -1 downto 0 do
  begin
    P := FClassItems[I];
    Dispose(p);
  end;
  FClassItems.Free;
  inherited Destroy;
end;

procedure TIFPSRuntimeClass.RegisterVirtualAbstractMethod(ClassDef: TClass;
  ProcPtr: Pointer; const Name: string);
var
  P: PClassItem;
begin
  New(P);
  p^.FName := Name;
  p^.FNameHash := MakeHash(Name);
  p^.b := 1;
  p^.PointerInList := FindVirtualMethodPtr(Self, ClassDef, ProcPtr);
  FClassItems.Add(p);
end;

procedure TIFPSRuntimeClass.RegisterConstructor(ProcPtr: Pointer;
  const Name: string);
var
  P: PClassItem;
begin
  New(P);
  p^.FName := FastUppercase(Name);
  p^.FNameHash := MakeHash(p^.FName);
  p^.b := 4;
  p^.Ptr := ProcPtr;
  FClassItems.Add(p);
end;

procedure TIFPSRuntimeClass.RegisterMethod(ProcPtr: Pointer; const Name: string);
var
  P: PClassItem;
begin
  New(P);
  p^.FName := FastUppercase(Name);
  p^.FNameHash := MakeHash(p^.FName);
  p^.b := 0;
  p^.Ptr := ProcPtr;
  FClassItems.Add(p);
end;


procedure TIFPSRuntimeClass.RegisterPropertyHelper(ReadFunc,
  WriteFunc: Pointer; const Name: string);
var
  P: PClassItem;
begin
  New(P);
  p^.FName := FastUppercase(Name);
  p^.FNameHash := MakeHash(p^.FName);
  p^.b := 3;
  p^.FReadFunc := ReadFunc;
  p^.FWriteFunc := WriteFunc;
  FClassItems.Add(p);
end;

procedure TIFPSRuntimeClass.RegisterVirtualConstructor(ProcPtr: Pointer;
  const Name: string);
var
  P: PClassItem;
begin
  New(P);
  p^.FName := FastUppercase(Name);
  p^.FNameHash := MakeHash(p^.FName);
  p^.b := 5;
  p^.PointerInList := FindVirtualMethodPtr(Self, FClass, ProcPtr);
  FClassItems.Add(p);
end;

procedure TIFPSRuntimeClass.RegisterVirtualMethod(ProcPtr: Pointer; const Name: string);
var
  P: PClassItem;
begin
  New(P);
  p^.FName := FastUppercase(Name);
  p^.FNameHash := MakeHash(p^.FName);
  p^.b := 1;
  p^.PointerInList := FindVirtualMethodPtr(Self, FClass, ProcPtr);
  FClassItems.Add(p);
end;

procedure TIFPSRuntimeClass.RegisterEventPropertyHelper(ReadFunc,
  WriteFunc: Pointer; const Name: string);
var
  P: PClassItem;
begin
  New(P);
  p^.FName := FastUppercase(Name);
  p^.FNameHash := MakeHash(p^.FName);
  p^.b := 6;
  p^.FReadFunc := ReadFunc;
  p^.FWriteFunc := WriteFunc;
  FClassItems.Add(p);
end;


procedure TIFPSRuntimeClass.RegisterPropertyHelperName(ReadFunc,
  WriteFunc: Pointer; const Name: string);
var
  P: PClassItem;
begin
  New(P);
  p^.FName := FastUppercase(Name);
  p^.FNameHash := MakeHash(p^.FName);
  p^.b := 7;
  p^.FReadFunc := ReadFunc;
  p^.FWriteFunc := WriteFunc;
  FClassItems.Add(p);
end;

{ TIFPSRuntimeClassImporter }

function TIFPSRuntimeClassImporter.Add(aClass: TClass): TIFPSRuntimeClass;
begin
  Result := FindClass(FastUppercase(aClass.ClassName));
  if Result <> nil then exit;
  Result := TIFPSRuntimeClass.Create(aClass, '');
  FClasses.Add(Result);
end;

function TIFPSRuntimeClassImporter.Add2(aClass: TClass;
  const Name: string): TIFPSRuntimeClass;
begin
  Result := FindClass(Name);
  if Result <> nil then exit;
  Result := TIFPSRuntimeClass.Create(aClass, Name);
  FClasses.Add(Result);
end;

procedure TIFPSRuntimeClassImporter.Clear;
var
  I: Longint;
begin
  for i := 0 to FClasses.Count -1 do
  begin
    TIFPSRuntimeClass(FClasses[I]).Free;
  end;
  FClasses.Clear;
end;

constructor TIFPSRuntimeClassImporter.Create;
begin
  inherited Create;
  FClasses := TIfList.Create;

end;

constructor TIFPSRuntimeClassImporter.CreateAndRegister(Exec: TIFPSexec;
  AutoFree: Boolean);
begin
  inherited Create;
  FClasses := TIfList.Create;
  RegisterClassLibraryRuntime(Exec, Self);
  if AutoFree then
    Exec.AddResource(@RCIFreeProc, Self);
end;

destructor TIFPSRuntimeClassImporter.Destroy;
begin
  Clear;
  FClasses.Free;
  inherited Destroy;
end;

{$IFNDEF IFPS3_NOINTERFACES}
procedure SetVariantToInterface(V: PIFVariant; Cl: IUnknown);
begin
  if (v <> nil) and (v.FType.BaseType = btInterface) then
  begin
    PIFPSVariantinterface(v).Data := cl;
    {$IFNDEF IFPS3_D3PLUS}
    if PIFPSVariantinterface(v).Data <> nil then
      PIFPSVariantinterface(v).Data.AddRef;
    {$ENDIF}
  end;
end;
{$ENDIF}

procedure SetVariantToClass(V: PIFVariant; Cl: TObject);
begin
  if (v <> nil) and (v.FType.BaseType = btClass) then
  begin
    PIFPSVariantclass(v).Data := cl;
  end;
end;

function BGRFW(var s: string): string;
var
  l: Longint;
begin
  l := Length(s);
  while l >0 do
  begin
    if s[l] = ' ' then
    begin
      Result := copy(s, l + 1, Length(s) - l);
      Delete(s, l, Length(s) - l + 1);
      exit;
    end;
    Dec(l);
  end;
  Result := s;
  s := '';
end;



function MyAllMethodsHandler2(Self: PScriptMethodInfo; const Stack: PPointer; _EDX, _ECX: Pointer): Integer; forward;

procedure MyAllMethodsHandler;
//  On entry:
//     EAX = Self pointer
//     EDX, ECX = param1 and param2
//     STACK = param3... paramcount
asm
  push 0
  push ecx
  push edx
  mov edx, esp
  add edx, 16 // was 12
  pop ecx
  call MyAllMethodsHandler2
  pop ecx
  mov edx, [esp]
  add esp, eax
  mov [esp], edx
  mov eax, ecx
end;

function ResultAsRegister(b: TIFTypeRec): Boolean;
begin
  case b.BaseType of
    btSingle,
    btDouble,
    btExtended,
    btU8,
    bts8,
    bts16,
    btu16,
    bts32,
    btu32,
{$IFNDEF IFPS3_NOINT64}
    bts64,
{$ENDIF}
    btPChar,
{$IFNDEF IFPS3_NOWIDESTRING}
    btWideChar,
{$ENDIF}    
    btChar,
    btclass,
    btEnum: Result := true;
    btSet: Result := b.RealSize <= 4;
    btStaticArray: Result := b.RealSize <= 4;
  else
    Result := false;
  end;
end;

function SupportsRegister(b: TIFTypeRec): Boolean;
begin
  case b.BaseType of
    btU8,
    bts8,
    bts16,
    btu16,
    bts32,
    btu32,
{$IFNDEF IFPS3_NOINT64}
    bts64,
{$ENDIF}
    btstring,
    btclass,
{$IFNDEF IFPS3_NOINTERFACES}
    btinterface,
{$ENDIF}
    btPChar,
{$IFNDEF IFPS3_NOWIDESTRING}
    btWideChar,
{$ENDIF}
    btChar,
    btArray,
    btEnum: Result := true;
    btSet: Result := b.RealSize <= 4;
    btStaticArray: Result := b.RealSize <= 4;
  else
    Result := false;
  end;
end;

function AlwaysAsVariable(aType: TIFTypeRec): Boolean;
begin
  case atype.BaseType of
    btVariant: Result := true;
    btSet: Result := atype.RealSize > 4;
    btRecord: Result := atype.RealSize > 4;
    btStaticArray: Result := atype.RealSize > 4;
  else
    Result := false;
  end;
end;


procedure PutOnFPUStackExtended(ft: extended);
asm
  fstp tbyte ptr [ft]
end;


function MyAllMethodsHandler2(Self: PScriptMethodInfo; const Stack: PPointer; _EDX, _ECX: Pointer): Integer;
var
  Decl: string;
  I, C, regno: Integer;
  Params: TIfList;
  Res, Tmp: PIFVariant;
  cpt: PIFTypeRec;
  fmod: char;
  s,e: string;
  FStack: pointer;
  ex: PIFPSExceptionHandler;


begin
  Decl := TIFInternalProcRec(Self^.Se.FProcs[Self^.ProcNo]).ExportDecl;

  FStack := Stack;
  Params := TIfList.Create;
  s := decl;
  grfw(s);
  while s <> '' do
  begin
    Params.Add(nil);
    grfw(s);
  end;
  c := Params.Count;
  regno := 0;
  Result := 0;
  s := decl;
  grfw(s);
  for i := c-1 downto 0 do
  begin
    e := grfw(s);
    fmod := e[1];
    delete(e, 1, 1);
    cpt := Self.Se.GetTypeNo(StrToInt(e));
    if ((fmod = '%') or (fmod = '!') or (AlwaysAsVariable(cpt))) and (RegNo < 2) then
    begin
      tmp := CreateHeapVariant(self.Se.FindType2(btPointer));
      PIFPSVariantPointer(tmp).DestType := cpt;
      Params[i] := tmp;
      case regno of
        0: begin
            PIFPSVariantPointer(tmp).DataDest := Pointer(_EDX);
            inc(regno);
          end;
        1: begin
            PIFPSVariantPointer(tmp).DataDest := Pointer(_ECX);
            inc(regno);
          end;
(*        else begin
            PIFPSVariantPointer(tmp).DataDest := Pointer(FStack^);
            FStack := Pointer(IPointer(FStack) + 4);
          end;*)
      end;
    end
    else if SupportsRegister(cpt) and (RegNo < 2) then
    begin
      tmp := CreateHeapVariant(cpt);
      Params[i] := tmp;
      case regno of
        0: begin
            CopyArrayContents(@PIFPSVariantData(tmp)^.Data, @_EDX, 1, cpt);
            inc(regno);
          end;
        1: begin
            CopyArrayContents(@PIFPSVariantData(tmp)^.Data, @_ECX, 1, cpt);
            inc(regno);
          end;
(*        else begin
            CopyArrayContents(@PIFPSVariantData(tmp)^.Data, Pointer(FStack), 1, cpt);
            FStack := Pointer(IPointer(FStack) + 4);
          end;*)
      end;
(*    end else
    begin
      tmp := CreateHeapVariant(cpt);
      Params[i] := tmp;
      CopyArrayContents(@PIFPSVariantData(tmp)^.Data, Pointer(FStack), 1, cpt);
      FStack := Pointer(IPointer(FStack) + cpt.RealSize + 3 and not 3);*)
    end;
  end;
  s := decl;
  grfw(s);
  for i := 0 to c -1 do
  begin
    e := grlw(s);
    fmod := e[1];
    delete(e, 1, 1);
    if Params[i] <> nil then Continue;
    cpt := Self.Se.GetTypeNo(StrToInt(e));
    if (fmod = '%') or (fmod = '!') or (AlwaysAsVariable(cpt)) then
    begin
      tmp := CreateHeapVariant(self.Se.FindType2(btPointer));
      PIFPSVariantPointer(tmp).DestType := cpt;
      Params[i] := tmp;
      PIFPSVariantPointer(tmp).DataDest := Pointer(FStack^);
      FStack := Pointer(IPointer(FStack) + 4);
      Inc(Result, 4);
    end
(*    else if SupportsRegister(cpt) then
    begin
      tmp := CreateHeapVariant(cpt);
      Params[i] := tmp;
      CopyArrayContents(@PIFPSVariantData(tmp)^.Data, Pointer(FStack), 1, cpt);
      FStack := Pointer(IPointer(FStack) + 4);
      end;
    end *)else
    begin
      tmp := CreateHeapVariant(cpt);
      Params[i] := tmp;
      CopyArrayContents(@PIFPSVariantData(tmp)^.Data, Pointer(FStack), 1, cpt);
      FStack := Pointer((IPointer(FStack) + cpt.RealSize + 3) and not 3);
      Inc(Result, (cpt.RealSize + 3) and not 3);
    end;
  end;
  s := decl;
  e := grfw(s);

  if e <> '-1' then
  begin
    cpt := Self.Se.GetTypeNo(StrToInt(e));
    if not ResultAsRegister(cpt) then
    begin
      Res := CreateHeapVariant(Self.Se.FindType2(btPointer));
      PIFPSVariantPointer(Res).DestType := cpt;
      Params.Add(Res);
      case regno of
        0: begin
            PIFPSVariantPointer(Res).DataDest := Pointer(_EDX);
          end;
        1: begin
            PIFPSVariantPointer(Res).DataDest := Pointer(_ECX);
          end;
        else begin
            PIFPSVariantPointer(Res).DataDest := Pointer(FStack^);
{$IFNDEF IFPS3_NOINTERFACES}
            FStack := Pointer(IPointer(FStack) + 4);
{$ENDIF}
            Inc(Result, 4);
          end;
      end;
    end else
    begin
      Res := CreateHeapVariant(cpt);
      Params.Add(Res);
    end;
  end else Res := nil;
  New(ex);
  ex.FinallyOffset := InvalidVal;
  ex.ExceptOffset := InvalidVal;
  ex.Finally2Offset := InvalidVal;
  ex.EndOfBlock := InvalidVal;
  ex.CurrProc := nil;
  ex.BasePtr := Self.Se.FCurrStackBase;
  Ex.StackSize := Self.Se.FStack.Count;
  i :=  Self.Se.FExceptionStack.Add(ex);
  Self.Se.RunProc(Params, Self.ProcNo);
  if Self.Se.FExceptionStack[i] = ex then
  begin
    Self.Se.FExceptionStack.Remove(ex);
    Dispose(ex);
  end;

  if (Res <> nil) then
  begin
    Params.DeleteLast;
    if (ResultAsRegister(Res.FType)) then
    begin
      if (res^.FType.BaseType = btSingle) or (res^.FType.BaseType = btDouble) or
      (res^.FType.BaseType = btCurrency) or (res^.Ftype.BaseType = btExtended) then
      begin
        case Res^.FType.BaseType of
          btSingle: PutOnFPUStackExtended(PIFPSVariantSingle(res).Data);
          btDouble: PutOnFPUStackExtended(PIFPSVariantDouble(res).Data);
          btExtended: PutOnFPUStackExtended(PIFPSVariantExtended(res).Data);
          btCurrency: PutOnFPUStackExtended(PIFPSVariantCurrency(res).Data);
        end;
        DestroyHeapVariant(Res);
        Res := nil;
      end else
      begin
{$IFNDEF IFPS3_NOINT64}
        if res^.FType.BaseType <> btS64 then
          CopyArrayContents(Pointer(Longint(FStack)-12), @PIFPSVariantData(res)^.Data, 1, Res^.FType);
{$ENDIF}
      end;
    end;
    DestroyHeapVariant(res);
  end;
  for i := 0 to Params.Count -1 do
    DestroyHeapVariant(Params[i]);
  Params.Free;
  if Self.Se.ExEx <> erNoError then
  begin
    if Self.Se.ExObject <> nil then
    begin
      FStack := Self.Se.ExObject;
      Self.Se.ExObject := nil;
      raise TObject(FStack);
    end else
      raise EIFPS3Exception.Create(TIFErrorToString(Self.SE.ExceptionCode, Self.Se.ExceptionString), Self.Se, Self.Se.ExProc, Self.Se.ExPos);
  end;
end;

function TIFPSRuntimeClassImporter.FindClass(const Name: string): TIFPSRuntimeClass;
var
  h, i: Longint;
  p: TIFPSRuntimeClass;
begin
  h := MakeHash(Name);
  for i := FClasses.Count -1 downto 0 do
  begin
    p := FClasses[i];
    if (p.FClassNameHash = h) and (p.FClassName = Name) then
    begin
      Result := P;
      exit;
    end;
  end;
  Result := nil;
end;

function DelphiFunctionProc(Caller: TIFPSExec; p: TIFExternalProcRec; Global, Stack: TIFPSStack; CC: TIFPSCallingConvention): Boolean;
var
  i: Integer;
  MyList: TIfList;
  n: PIFPSVariantIFC;
  CurrStack: Cardinal;
  s: string;
begin
  s := P.Decl;
  if length(s) = 0 then begin Result := False; exit; end;
  CurrStack := Cardinal(Stack.Count) - Cardinal(length(s));
  if s[1] = #0 then inc(CurrStack);
  MyList := tIfList.Create;

  for i := 2 to length(s) do
  begin
    MyList.Add(nil);
  end;
  for i := length(s) downto 2 do
  begin
    MyList[i - 2] := NewPIFPSVariantIFC(Stack[CurrStack], s[i] <> #0);
    inc(CurrStack);
  end;
  if s[1] <> #0 then
  begin
    n := NewPIFPSVariantIFC(Stack[CurrStack], True);
  end else n := nil;
  try
    result := Caller.InnerfuseCall(p.Ext2, p.Ext1, cc, MyList, n);
  finally
    DisposePIFPSvariantIFC(n);
    DisposePIFPSVariantIFCList(mylist);
  end;
end;

function DelphiFunctionProc_CDECL(Caller: TIFPSExec; p: TIFExternalProcRec; Global, Stack: TIFPSStack): Boolean;
begin
  Result := DelphiFunctionProc(Caller, p, Global, Stack, cdCdecl);
end;
function DelphiFunctionProc_Register(Caller: TIFPSExec; p: TIFExternalProcRec; Global, Stack: TIFPSStack): Boolean;
begin
  Result := DelphiFunctionProc(Caller, p, Global, Stack, cdRegister);
end;
function DelphiFunctionProc_Pascal(Caller: TIFPSExec; p: TIFExternalProcRec; Global, Stack: TIFPSStack): Boolean;
begin
  Result := DelphiFunctionProc(Caller, p, Global, Stack, cdPascal);
end;
function DelphiFunctionProc_Stdcall(Caller: TIFPSExec; p: TIFExternalProcRec; Global, Stack: TIFPSStack): Boolean;
begin
  Result := DelphiFunctionProc(Caller, p, Global, Stack, cdStdCall);
end;

procedure TIFPSExec.RegisterDelphiFunction(ProcPtr: Pointer;
  const Name: string; CC: TIFPSCallingConvention);
begin
  RegisterDelphiMethod(nil, ProcPtr, FastUppercase(Name), CC);
end;

procedure TIFPSExec.RegisterDelphiMethod(Slf, ProcPtr: Pointer;
  const Name: string; CC: TIFPSCallingConvention);
begin
  case cc of
    cdRegister: RegisterFunctionName(FastUppercase(Name), DelphiFunctionProc_Register, ProcPtr, Slf);
    cdPascal: RegisterFunctionName(FastUppercase(Name), DelphiFunctionProc_Pascal, ProcPtr, Slf);
    cdStdCall: RegisterFunctionName(FastUppercase(Name), DelphiFunctionProc_Stdcall, ProcPtr, Slf);
    cdCdecl: RegisterFunctionName(FastUppercase(Name), DelphiFunctionProc_CDECL, ProcPtr, Slf);
  end;
end;

{ EIFPS3Exception }

constructor EIFPS3Exception.Create(const Error: string; Exec: TIFPSExec;
  Procno, ProcPos: Cardinal);
begin
 inherited Create(Error);
 FExec := Exec;
 FProcNo := Procno;
 FProcPos := ProcPos;
end;

{ TIFPSRuntimeAttribute }

function TIFPSRuntimeAttribute.AddValue(aType: TIFTypeRec): PIFPSVariant;
begin
  Result := FValues.PushType(aType);
end;

procedure TIFPSRuntimeAttribute.AdjustSize;
begin
  FValues.Capacity := FValues.Length;
end;

constructor TIFPSRuntimeAttribute.Create(Owner: TIFPSRuntimeAttributes);
begin
  inherited Create;
  FOwner := Owner;
  FValues := TIFPSStack.Create;
end;

procedure TIFPSRuntimeAttribute.DeleteValue(i: Longint);
begin
  if Cardinal(i) <> Cardinal(FValues.Count -1) then
    raise Exception.Create('Can only send last item');
  FValues.Pop;
end;

destructor TIFPSRuntimeAttribute.Destroy;
begin
  FValues.Free;
  inherited Destroy;
end;

function TIFPSRuntimeAttribute.GetValue(I: Longint): PIFVariant;
begin
  Result := FValues[i];
end;

function TIFPSRuntimeAttribute.GetValueCount: Longint;
begin
  Result := FValues.Count;
end;

{ TIFPSRuntimeAttributes }

function TIFPSRuntimeAttributes.Add: TIFPSRuntimeAttribute;
begin
  Result := TIFPSRuntimeAttribute.Create(Self);
  FAttributes.Add(Result);
end;

constructor TIFPSRuntimeAttributes.Create(AOwner: TIFPSExec);
begin
  inherited Create;
  FAttributes := TIfList.Create;
  FOwner := AOwner;
end;

procedure TIFPSRuntimeAttributes.Delete(I: Longint);
begin
  TIFPSRuntimeAttribute(FAttributes[i]).Free;
  FAttributes.Delete(i);
end;

destructor TIFPSRuntimeAttributes.Destroy;
var
  i: Longint;
begin
  for i := FAttributes.Count -1 downto 0 do
    TIFPSRuntimeAttribute(FAttributes[i]).Free;
  FAttributes.Free;
  inherited Destroy;
end;

function TIFPSRuntimeAttributes.FindAttribute(
  const Name: string): TIFPSRuntimeAttribute;
var
  n: string;
  i, h: Longint;
begin
  n := FastUpperCase(Name);
  h := MakeHash(n);
  for i := 0 to FAttributes.Count -1 do
  begin
    Result := FAttributes[i];
    if (Result.AttribTypeHash = h) and (Result.AttribType = n) then
      exit;
  end;
  Result := nil;
end;

function TIFPSRuntimeAttributes.GetCount: Longint;
begin
   Result := FAttributes.Count;
end;

function TIFPSRuntimeAttributes.GetItem(I: Longint): TIFPSRuntimeAttribute;
begin
  Result := FAttributes[i];
end;

{ TIFInternalProcRec }

destructor TIFInternalProcRec.Destroy;
begin
  if FData <> nil then
    Freemem(Fdata, FLength);
  inherited Destroy;
end;

{ TIFProcRec }

constructor TIFProcRec.Create(Owner: TIFPSExec);
begin
  inherited Create;
  FAttributes := TIFPSRuntimeAttributes.Create(Owner);
end;

destructor TIFProcRec.Destroy;
begin
  FAttributes.Free;
  inherited Destroy;
end;

{ TIFTypeRec_Array }

procedure TIFTypeRec_Array.CalcSize;
begin
  FrealSize := 4;
end;

{ TIFTypeRec_StaticArray }

procedure TIFTypeRec_StaticArray.CalcSize;
begin
  FrealSize := Cardinal(FArrayType.RealSize) * Cardinal(Size);
end;

{ TIFTypeRec_Set }

procedure TIFTypeRec_Set.CalcSize;
begin
  FrealSize := FByteSize;
end;

const
  MemDelta = 4096;

{ TIFPSStack }

procedure TIFPSStack.AdjustLength;
var
  MyLen: Longint;
begin
  MyLen := ((FLength shr 12) + 1) shl 12;

  SetCapacity(MyLen);
end;

procedure TIFPSStack.Clear;
var
  v: Pointer;
  i: Longint;
begin
  for i := Count -1 downto 0 do
  begin
    v := Data[i];
    if TIFTypeRec(v^).BaseType in NeedFinalization then
      FinalizeVariant(Pointer(IPointer(v)+4), TIFTypeRec(v^));
  end;
  inherited Clear;
  FLength := 0;
  SetCapacity(0);
end;

constructor TIFPSStack.Create;
begin
  inherited Create;
  GetMem(FDataPtr, MemDelta);
  FCapacity := MemDelta;
  FLength := 0;
end;

destructor TIFPSStack.Destroy;
var
  v: Pointer;
  i: Longint;
begin
  for i := Count -1 downto 0 do
  begin
    v := Data[i];
    if TIFTypeRec(v^).BaseType in NeedFinalization then
    FinalizeVariant(Pointer(IPointer(v)+4), Pointer(v^));
  end;
  FreeMem(FDataPtr, FCapacity);
  inherited Destroy;
end;

function TIFPSStack.GetBool(ItemNo: Longint): Boolean;
var
  val: PIFPSVariant;
begin
  if ItemNo < 0 then
    val := Items[Longint(ItemNo) + Longint(Count)]
  else
    val := Items[ItemNo];
  Result := IFPSGetUInt(@PIFPSVariantData(val).Data, val.FType) <> 0;
end;

function TIFPSStack.GetClass(ItemNo: Longint): TObject;
var
  val: PIFPSVariant;
begin
  if ItemNo < 0 then
    val := Items[Longint(ItemNo) + Longint(Count)]
  else
    val := Items[ItemNo];
  Result := IFPSGetObject(@PIFPSVariantData(val).Data, val.FType);
end;

function TIFPSStack.GetCurrency(ItemNo: Longint): Currency;
var
  val: PIFPSVariant;
begin
  if ItemNo < 0 then
    val := Items[Longint(ItemNo) + Longint(Count)]
  else
    val := Items[ItemNo];
  Result := IFPSGetCurrency(@PIFPSVariantData(val).Data, val.FType);
end;

function TIFPSStack.GetInt(ItemNo: Longint): Longint;
var
  val: PIFPSVariant;
begin
  if ItemNo < 0 then
    val := items[Longint(ItemNo) + Longint(Count)]
  else
    val := items[ItemNo];
  Result := IFPSGetInt(@PIFPSVariantData(val).Data, val.FType);
end;

{$IFNDEF IFPS3_NOINT64}
function TIFPSStack.GetInt64(ItemNo: Longint): Int64;
var
  val: PIFPSVariant;
begin
  if ItemNo < 0 then
    val := items[Longint(ItemNo) + Longint(Count)]
  else
    val := items[ItemNo];
  Result := IFPSGetInt64(@PIFPSVariantData(val).Data, val.FType);
end;
{$ENDIF}

function TIFPSStack.GetItem(I: Longint): PIFPSVariant;
begin
  if Cardinal(I) >= Cardinal(Count) then
    Result := nil
  else
    Result := Data[i];
end;

function TIFPSStack.GetReal(ItemNo: Longint): Extended;
var
  val: PIFPSVariant;
begin
  if ItemNo < 0 then
    val := items[Longint(ItemNo) + Longint(Count)]
  else
    val := items[ItemNo];
  Result := IFPSGetreal(@PIFPSVariantData(val).Data, val.FType);
end;

function TIFPSStack.GetString(ItemNo: Longint): string;
var
  val: PIFPSVariant;
begin
  if ItemNo < 0 then
    val := items[Longint(ItemNo) + Longint(Count)]
  else
    val := items[ItemNo];
  Result := IFPSGetString(@PIFPSVariantData(val).Data, val.FType);
end;

function TIFPSStack.GetUInt(ItemNo: Longint): Cardinal;
var
  val: PIFPSVariant;
begin
  if ItemNo < 0 then
    val := items[Longint(ItemNo) + Longint(Count)]
  else
    val := items[ItemNo];
  Result := IFPSGetUInt(@PIFPSVariantData(val).Data, val.FType);
end;

{$IFNDEF IFPS3_NOWIDESTRING}
function TIFPSStack.GetWideString(ItemNo: Longint): WideString;
var
  val: PIFPSVariant;
begin
  if ItemNo < 0 then
    val := items[Longint(ItemNo) + Longint(Count)]
  else
    val := items[ItemNo];
  Result := IFPSGetWideString(@PIFPSVariantData(val).Data, val.FType);
end;
{$ENDIF}

procedure TIFPSStack.Pop;
var
  p1: Pointer;
  c: Longint;
begin
  c := count -1;
  p1 := Data[c];
  DeleteLast;
  FLength := IPointer(p1) - IPointer(FDataPtr);
  if TIFTypeRec(p1^).BaseType in NeedFinalization then
    FinalizeVariant(Pointer(IPointer(p1)+4), Pointer(p1^));
  if ((FCapacity - FLength) shr 12) > 2 then AdjustLength;
end;

function TIFPSStack.Push(TotalSize: Longint): PIFPSVariant;
var
  o: Cardinal;
  p: Pointer;
begin
  o := FLength;
  FLength := (FLength + TotalSize) and not 3;
  if FLength > FCapacity then AdjustLength;
  p := Pointer(IPointer(FDataPtr) + IPointer(o));
  Add(p);
  Result := P;
end;

function TIFPSStack.PushType(aType: TIFTypeRec): PIFPSVariant;
var
  o: Cardinal;
  p: Pointer;
begin
  o := FLength;
  FLength := (FLength + Longint(aType.RealSize) + Longint(RTTISize + 3)) and not 3;
  if FLength > FCapacity then AdjustLength;
  p := Pointer(IPointer(FDataPtr) + IPointer(o));
  Add(p);
  Result := P;
  Result.FType := aType;
  InitializeVariant(Pointer(IPointer(Result)+4), aType);
end;

procedure TIFPSStack.SetBool(ItemNo: Longint; const Data: Boolean);
var
  val: PIFPSVariant;
  ok: Boolean;
begin
  if ItemNo < 0 then
    val := items[Longint(ItemNo) + Longint(Count)]
  else
    val := items[ItemNo];
  ok := true;
  if Data then
    IFPSSetUInt(@PIFPSVariantData(val).Data, val.FType, ok, 1)
  else
    IFPSSetUInt(@PIFPSVariantData(val).Data, val.FType, ok, 0);
  if not ok then raise Exception.Create('Type mismatch');
end;

procedure TIFPSStack.SetCapacity(const Value: Longint);
var
  p: Pointer;
  OOFS: IPointer;
  I: Longint;
begin
  if Value < FLength then raise Exception.Create('Capacity should be >= Length');
  if Value = 0 then
  begin
    if FDataPtr <> nil then
    begin
      FreeMem(FDataPtr, FCapacity);
      FDataPtr := nil;
    end;
    FCapacity := 0;
  end;
  GetMem(p, Value);
  if FDataPtr <> nil then
  begin
    if FLength > FCapacity then
      OOFS := FCapacity
    else
      OOFS := FLength;
    Move(FDataPtr^, p^, OOFS);
    OOFS := IPointer(P) - IPointer(FDataPtr);
    for i := Count -1 downto 0 do
      Data[i] := Pointer(IPointer(Data[i]) + OOFS);

    FreeMem(FDataPtr, FCapacity);
  end;
  FDataPtr := p;
  FCapacity := Value;
end;

procedure TIFPSStack.SetClass(ItemNo: Longint; const Data: TObject);
var
  val: PIFPSVariant;
  ok: Boolean;
begin
  if ItemNo < 0 then
    val := items[Longint(ItemNo) + Longint(Count)]
  else
    val := items[ItemNo];
  ok := true;
  IFPSSetObject(@PIFPSVariantData(val).Data, val.FType, ok, Data);
  if not ok then raise Exception.Create('Type mismatch');
end;

procedure TIFPSStack.SetCurrency(ItemNo: Longint; const Data: Currency);
var
  val: PIFPSVariant;
  ok: Boolean;
begin
  if ItemNo < 0 then
    val := items[Longint(ItemNo) + Longint(Count)]
  else
    val := items[ItemNo];
  ok := true;
  IFPSSetCurrency(@PIFPSVariantData(val).Data, val.FType, ok, Data);
  if not ok then raise Exception.Create('Type mismatch');
end;

procedure TIFPSStack.SetInt(ItemNo: Longint; const Data: Longint);
var
  val: PIFPSVariant;
  ok: Boolean;
begin
  if ItemNo < 0 then
    val := items[Longint(ItemNo) + Longint(Count)]
  else
    val := items[ItemNo];
  ok := true;
  IFPSSetInt(@PIFPSVariantData(val).Data, val.FType, ok, Data);
  if not ok then raise Exception.Create('Type mismatch');
end;

{$IFNDEF IFPS3_NOINT64}
procedure TIFPSStack.SetInt64(ItemNo: Longint; const Data: Int64);
var
  val: PIFPSVariant;
  ok: Boolean;
begin
  if ItemNo < 0 then
    val := items[Longint(ItemNo) + Longint(Count)]
  else
    val := items[ItemNo];
  ok := true;
  IFPSSetInt64(@PIFPSVariantData(val).Data, val.FType, ok, Data);
  if not ok then raise Exception.Create('Type mismatch');
end;
{$ENDIF}

procedure TIFPSStack.SetReal(ItemNo: Longint; const Data: Extended);
var
  val: PIFPSVariant;
  ok: Boolean;
begin
  if ItemNo < 0 then
    val := items[Longint(ItemNo) + Longint(Count)]
  else
    val := items[ItemNo];
  ok := true;
  IFPSSetReal(@PIFPSVariantData(val).Data, val.FType, ok, Data);
  if not ok then raise Exception.Create('Type mismatch');
end;

procedure TIFPSStack.SetString(ItemNo: Longint; const Data: string);
var
  val: PIFPSVariant;
  ok: Boolean;
begin
  if ItemNo < 0 then
    val := items[Longint(ItemNo) + Longint(Count)]
  else
    val := items[ItemNo];
  ok := true;
  IFPSSetString(@PIFPSVariantData(val).Data, val.FType, ok, Data);
  if not ok then raise Exception.Create('Type mismatch');
end;

procedure TIFPSStack.SetUInt(ItemNo: Longint; const Data: Cardinal);
var
  val: PIFPSVariant;
  ok: Boolean;
begin
  if ItemNo < 0 then
    val := items[Longint(ItemNo) + Longint(Count)]
  else
    val := items[ItemNo];
  ok := true;
  IFPSSetUInt(@PIFPSVariantData(val).Data, val.FType, ok, Data);
  if not ok then raise Exception.Create('Type mismatch');
end;


{$IFNDEF IFPS3_NOWIDESTRING}
procedure TIFPSStack.SetWideString(ItemNo: Longint;
  const Data: WideString);
var
  val: PIFPSVariant;
  ok: Boolean;
begin
  if ItemNo < 0 then
    val := items[Longint(ItemNo) + Longint(Count)]
  else
    val := items[ItemNo];
  ok := true;
  IFPSSetWideString(@PIFPSVariantData(val).Data, val.FType, ok, Data);
  if not ok then raise Exception.Create('Type mismatch');
end;
{$ENDIF}


{$IFNDEF IFPS3_NOIDISPATCH}
var
  DispPropertyPut: Integer = DISPID_PROPERTYPUT;
const
  LOCALE_SYSTEM_DEFAULT = 2 shl 10; // Delphi 2 doesn't define this

function IDispatchInvoke(Self: IDispatch; PropertySet: Boolean; const Name: String; const Par: array of Variant): Variant;
var
  Param: Word;
  i, ArgErr: Longint;
  DispatchId: Longint;
  DispParam: TDispParams;
  ExceptInfo: TExcepInfo;
  aName: PWideChar;
  WSFreeList: TIfList;
begin
  FillChar(ExceptInfo, SizeOf(ExceptInfo), 0);
  aName := StringToOleStr(Name);
  try
    if Self = nil then
      raise Exception.Create('NIL Interface Exception');
    if Self.GetIDsOfNames(GUID_NULL, @aName, 1, LOCALE_SYSTEM_DEFAULT, @DispatchId) <> S_OK then
      raise Exception.Create('Unknown Method');
  finally
    SysFreeString(aName);
  end;

  DispParam.cNamedArgs := 0;
  DispParam.rgdispidNamedArgs := nil;
  DispParam.cArgs := (High(Par) + 1);

  if PropertySet then
  begin
    Param := DISPATCH_PROPERTYPUT;
    DispParam.cNamedArgs := 1;
    DispParam.rgdispidNamedArgs := @DispPropertyPut;
  end else
    Param := DISPATCH_METHOD or DISPATCH_PROPERTYGET;

  WSFreeList := TIfList.Create;
  try
    GetMem(DispParam.rgvarg, sizeof(TVariantArg) * (High(Par) + 1));
    FillCHar(DispParam.rgvarg^, sizeof(TVariantArg) * (High(Par) + 1), 0);
    try
      for i := 0 to High(Par)  do
      begin
        if PVarData(@Par[i]).VType = varString then
        begin
          DispParam.rgvarg[i].vt := VT_BSTR;
          DispParam.rgvarg[i].bstrVal := StringToOleStr(Par[i]);
          WSFreeList.Add(DispParam.rgvarg[i].bstrVal);
        end else
        begin
          DispParam.rgvarg[i].vt := VT_VARIANT or VT_BYREF;
          New({$IFDEF IFPS3_D3PLUS}POleVariant{$ELSE}PVariant{$ENDIF}(DispParam.rgvarg[i].pvarVal));
          {$IFDEF IFPS3_D3PLUS}POleVariant{$ELSE}PVariant{$ENDIF}(DispParam.rgvarg[i].pvarVal)^ := Par[i];
        end;
      end;
      i :=Self.Invoke(DispatchId, GUID_NULL, LOCALE_SYSTEM_DEFAULT, Param, DispParam, @Result, @ExceptInfo, @ArgErr);
      {$IFNDEF IFPS3_D3PLUS}
      try
       if not Succeeded(i) then
       begin
         if i = DISP_E_EXCEPTION then
           raise Exception.Create(OleStrToString(ExceptInfo.bstrSource)+': '+OleStrToString(ExceptInfo.bstrDescription))
         else
           raise Exception.Create(SysErrorMessage(i));
       end;
      finally
        SysFreeString(ExceptInfo.bstrSource);
        SysFreeString(ExceptInfo.bstrDescription);
        SysFreeString(ExceptInfo.bstrHelpFile);
      end;
      {$ELSE}
       if not Succeeded(i) then
       begin
         if i = DISP_E_EXCEPTION then
           raise Exception.Create(ExceptInfo.bstrSource+': '+ExceptInfo.bstrDescription)
         else
           raise Exception.Create(SysErrorMessage(i));
       end;
      {$ENDIF}
    finally
      for i := 0 to High(Par)  do
      begin
        if DispParam.rgvarg[i].vt = (VT_VARIANT or VT_BYREF) then
        begin
          if {$IFDEF IFPS3_D3PLUS}POleVariant{$ELSE}PVariant{$ENDIF}(DispParam.rgvarg[i].pvarVal) <> nil then
            Dispose({$IFDEF IFPS3_D3PLUS}POleVariant{$ELSE}PVariant{$ENDIF}(DispParam.rgvarg[i].pvarVal));
        end;
      end;
      FreeMem(DispParam.rgvarg, sizeof(TVariantArg) * (High(Par) + 1));
    end;
  finally
    for i := WSFreeList.Count -1 downto 0 do
      SysFreeString(WSFreeList[i]);
    WSFreeList.Free;
  end;
end;
{$ENDIF}      

end.

