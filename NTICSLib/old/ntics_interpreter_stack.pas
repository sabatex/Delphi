unit ntics_interpreter_stack;
interface
uses ntics_interpreter_classes;
type
{ TIFPSBaseType is the most basic type -type }
  TIFPSBaseType = Byte;

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

  {Pointer to a variant}
  PIFPSVariant = ^TIFPSVariant;
  {Pointer to a variant}
  PIFVariant = PIFPSVariant;
  {variant type}
  TIFPSVariant = packed record
    FType: TIFTypeRec;
  end;

  {@Abstract(stack type to store runtime information in)}
  TIFPSStack = class(TIFList)
  private
    FDataPtr: Pointer;
    FCapacity,
    FLength: Longint;
    function GetItem(I: Longint): PIFPSVariant;
    procedure SetCapacity(const Value: Longint); // relative pointers to FData
    procedure AdjustLength;
  public
    property DataPtr: Pointer read FDataPtr; {Start of the data}
    property Capacity: Longint read FCapacity write SetCapacity;{Capacity of the data ptr}
    property Length: Longint read FLength;{Current length}
    constructor Create;
    destructor Destroy; override;
    procedure Clear; {$IFDEF IFPS3_D5PLUS} reintroduce;{$ELSE} override; {$ENDIF}{Clear the stack}
    function Push(TotalSize: Longint): PIFPSVariant;{Push a new item}
    function PushType(aType: TIFTypeRec): PIFPSVariant;{Push a new item}
    procedure Pop;{Pop the last item}
    function GetInt(ItemNo: Longint): Longint;
    function GetUInt(ItemNo: Longint): Cardinal;
    function GetInt64(ItemNo: Longint): Int64;
    function GetString(ItemNo: Longint): string;
    function GetWideString(ItemNo: Longint): WideString;
    function GetReal(ItemNo: Longint): Extended;
    function GetCurrency(ItemNo: Longint): Currency;
    function GetBool(ItemNo: Longint): Boolean;
    function GetClass(ItemNo: Longint): TObject;

    procedure SetInt(ItemNo: Longint; const Data: Longint);
    procedure SetUInt(ItemNo: Longint; const Data: Cardinal);
    procedure SetInt64(ItemNo: Longint; const Data: Int64);
    procedure SetString(ItemNo: Longint; const Data: string);
    procedure SetWideString(ItemNo: Longint; const Data: WideString);
    procedure SetReal(ItemNo: Longint; const Data: Extended);
    procedure SetCurrency(ItemNo: Longint; const Data: Currency);
    procedure SetBool(ItemNo: Longint; const Data: Boolean);
    procedure SetClass(ItemNo: Longint; const Data: TObject);

    property Items[I: Longint]: PIFPSVariant read GetItem; default;
  end;

implementation

end.
