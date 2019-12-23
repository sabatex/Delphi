unit ntics_interpreter_classes;
interface
const
  {Maximum number of items in a list}
  MaxListSize = Maxint div 16;
  {The Capacity increment that list uses}
  FCapacityInc = 32;
  {The maximum number of "resize" operations on the list before it's recreated}
  FMaxCheckCount = (FCapacityInc div 4) * 64;


type
  {PPointerList is pointing to an array of pointers}
  PPointerList = ^TPointerList;
  {An array of pointers}
  TPointerList = array[0..MaxListSize - 1] of Pointer;

// TIfList is the list class used in IFPS3
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
    procedure Recreate;{Recreate the list}
    property Data: PPointerList read FData;
    constructor Create;
    destructor Destroy; override;
    property Count: Cardinal read FCount;{Contains the number of items in the list}
    property Items[nr: Cardinal]: Pointer read GetItem write SetItem; default;
    function Add(P: Pointer): Longint;{Add an item}
    procedure AddBlock(List: PPointerList; Count: Longint);{Add a block of items}
    procedure Remove(P: Pointer);{Remove an item}
    procedure Delete(Nr: Cardinal);{Remove an item}
    procedure DeleteLast;
    procedure Clear; virtual;{Clear the list}
  end;

implementation
{ TIfList }
function MM(i1,i2: Integer): Integer;
begin
  if ((i1 div i2) * i2) < i1 then
    mm := (i1 div i2 + 1) * i2
  else
    mm := (i1 div i2) * i2;
end;

function TifList.GetItem(Nr: Cardinal): Pointer;
begin
  if Nr < FCount then
     GetItem := FData[Nr]
  else
    GetItem := nil;
end;

procedure TIfList.SetItem(Nr: Cardinal; P: Pointer);
begin
  if (FCount = 0) or (Nr >= FCount) then
    Exit;
  FData[Nr] := P;
end;

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

constructor TIfList.Create;
begin
  inherited Create;
  FCount := 0;
  FCapacity := 16;
  FCheckCount := 0;
  GetMem(FData, 64);
end;

destructor TIfList.Destroy;
begin
  FreeMem(FData, FCapacity * 4);
  inherited Destroy;
end;

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
  Inc(FCheckCount);
  if FCheckCount > FMaxCheckCount then Recreate;
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
  Inc(FCheckCount);
  if FCheckCount > FMaxCheckCount then Recreate;
end;

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

procedure TIfList.Delete(Nr: Cardinal);
begin
  if FCount = 0 then Exit;
  if Nr < FCount then
  begin
    Move(FData[Nr + 1], FData[Nr], (FCount - Nr) * 4);
    Dec(FCount);
    Inc(FCheckCount);
    if FCheckCount > FMaxCheckCount then Recreate;
  end;
end;

procedure TIfList.DeleteLast;
begin
  if FCount = 0 then Exit;
  Dec(FCount);
    Inc(FCheckCount);
  if FCheckCount > FMaxCheckCount then Recreate;
end;

procedure TIfList.Clear;
begin
  FCount := 0;
  Recreate;
end;


end.

