{*******************************************************}
{                                                       }
{                     EhLib vX.X                        }
{                                                       }
{              TMemTreeListEh component                 }
{                     (Build 14)                        }
{                                                       }
{        Copyright (c) 2004 by EhLib Team and           }
{                Dmitry V. Bolshakov                    }
{                                                       }
{*******************************************************}



unit MemTreeEh;

interface

uses Windows, SysUtils, Classes, ComCtrls, ToolCtrlsEh, Contnrs;

type

  TTreeListEh = class;
  TTreeNodeEh = class;
  TNodeAttachModeEh = (naAddEh, naAddFirstEh, naAddChildEh, naAddChildFirstEh, naInsertEh);
  TAddModeEh = (taAddFirstEh, taAddEh, taInsertEh);

  TCompareNodesEh = function (Node1, Node2: TTreeNodeEh; ParamSort: TObject): Integer of object;
  TTreeNodeNotifyEvent = procedure (Sender: TTreeNodeEh) of object;
  TTreeNodeNotifyResultEvent = function (Sender: TTreeNodeEh): Boolean of object;

{ TTreeNodeEh }

  TTreeNodeEh = class(TObject)
  private
    FOwner: TTreeListEh;
    FText: string;
    FData: TObject;
    FExpanded: Boolean;
    FHasChildren: Boolean;
    FIndex: Integer;
    FItems: TList;
    FVisibleItems: TList;
    FLevel: Integer;
    FParent: TTreeNodeEh;
    FVisible: Boolean;
    FVisibleCount: Integer;
    FVisibleIndex: Integer;
//    FVisibleIndex: Integer;
    procedure SetExpanded(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
    function GetVisibleItem(const Index: Integer): TTreeNodeEh;
  protected
    function ExpandedChanging: Boolean; virtual;
    function GetCount: Integer;
    function GetItem(const Index: Integer): TTreeNodeEh; virtual;
    function GetVisibleCount: Integer;
    function VisibleChanging: Boolean; virtual;
    function VisibleItems: TList;
    function Add(Item: TTreeNodeEh): Integer;
    function HasParentOf(Node: TTreeNodeEh): Boolean;
    procedure Delete(Index: Integer);
    procedure Clear; virtual;
    procedure Insert(Index: Integer; Item: TTreeNodeEh);
    procedure ChildVisibleChanged(ChildNode: TTreeNodeEh); virtual;
    procedure Exchange(Index1, Index2: Integer);
    procedure ExpandedChanged; virtual;
    procedure QuickSort(L, R: Integer; Compare: TCompareNodesEh; ParamSort: TObject);
    procedure SetLevel(ALevel: Integer);
    procedure VisibleChanged; virtual;
    procedure BuildVisibleItems; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure SortData(CompareProg: TCompareNodesEh; ParamSort: TObject; ARecurse: Boolean = True);
    property Count: Integer read GetCount;
    property Data: TObject read FData write FData;
    property Expanded: Boolean read FExpanded write SetExpanded;
    property HasChildren: Boolean read FHasChildren write FHasChildren;
    property Index: Integer read FIndex;
    property Items[const Index: Integer]: TTreeNodeEh read GetItem; default;
    property Level: Integer read FLevel;
    property Owner: TTreeListEh read FOwner;
    property Parent: TTreeNodeEh read FParent write FParent;
    property Text: string read FText write FText;
    property Visible: Boolean read FVisible write SetVisible default True;
    property VisibleCount: Integer read GetVisibleCount;
    property VisibleItem[const Index: Integer]: TTreeNodeEh read GetVisibleItem;
    property VisibleIndex: Integer read FVisibleIndex;
  end;

  TTreeNodeClassEh = class of TTreeNodeEh;

{ TTreeListEh }

  TTreeListEh = class(TObject)
  private
    FItemClass: TTreeNodeClassEh;
    FOnExpandedChanged: TTreeNodeNotifyEvent;
    FOnExpandedChanging: TTreeNodeNotifyResultEvent;
    FMaxLevel: Integer;
  protected
    FRoot: TTreeNodeEh;
    function IsHasChildren(Node: TTreeNodeEh = nil): Boolean; // if Node is nil then Node = RootNode
    function ExpandedChanging(Node: TTreeNodeEh): Boolean; virtual;
    procedure ExpandedChanged(Node: TTreeNodeEh); virtual;
    procedure QuickSort(L, R: Integer; Compare: TCompareNodesEh);
    property MaxLevel: Integer read FMaxLevel write FMaxLevel default 1000;
  public
    constructor Create(ItemClass: TTreeNodeClassEh);
    destructor Destroy; override;
    function AddChild(const Text: string; Parent: TTreeNodeEh; Data: TObject): TTreeNodeEh; // if Parent is nil then Parent = RootNode
    function CountChildren(Node: TTreeNodeEh = nil): Integer; // if Node is nil then Node = RootNode
    function GetFirst: TTreeNodeEh;
    function GetFirstChild(Node: TTreeNodeEh): TTreeNodeEh;
    function GetFirstVisible: TTreeNodeEh;
    function GetLast(Node: TTreeNodeEh = nil): TTreeNodeEh; // if Node is nil then Node = RootNode
    function GetLastChild(Node: TTreeNodeEh): TTreeNodeEh;
    function GetNext(Node: TTreeNodeEh): TTreeNodeEh;
    function GetNextSibling(Node: TTreeNodeEh): TTreeNodeEh;
    function GetNextVisibleSibling(Node: TTreeNodeEh): TTreeNodeEh;
    function GetNextVisible(Node: TTreeNodeEh; ConsiderCollapsed: Boolean): TTreeNodeEh;
    function GetNode(StartNode: TTreeNodeEh; Data: TObject): TTreeNodeEh;
    function GetParentAtLevel(Node: TTreeNodeEh; ParentLevel: Integer): TTreeNodeEh;   //
    function GetParentVisible(Node: TTreeNodeEh; ConsiderCollapsed: Boolean): TTreeNodeEh;
    function GetPathVisible(Node: TTreeNodeEh; ConsiderCollapsed: Boolean): Boolean;
    function GetPrevious(Node: TTreeNodeEh): TTreeNodeEh;
    function GetPrevSibling(Node: TTreeNodeEh): TTreeNodeEh;
    function GetPrevVisibleSibling(Node: TTreeNodeEh): TTreeNodeEh;
    procedure AddNode(Node: TTreeNodeEh; Destination: TTreeNodeEh; Mode: TNodeAttachModeEh; ReIndex: Boolean);
    procedure BuildChildrenIndex(Node: TTreeNodeEh = nil; Recurse: Boolean = True);
    procedure Clear;
    procedure Collapse(Node: TTreeNodeEh; Recurse: Boolean);
    procedure DeleteChildren(Node: TTreeNodeEh);
    procedure DeleteNode(Node: TTreeNodeEh; ReIndex: Boolean);
    procedure Expand(Node: TTreeNodeEh; Recurse: Boolean);
    procedure ExportToTreeView(TreeView: TTreeView; Node: TTreeNodeEh; NodeTree: TTreeNode; AddChild: Boolean);
    procedure MoveTo(Node: TTreeNodeEh; Destination: TTreeNodeEh; Mode: TNodeAttachModeEh; ReIndex: Boolean); virtual;
    procedure SortData(CompareProg: TCompareNodesEh; ParamSort: TObject; ARecurse: Boolean = True); virtual;
    property Root: TTreeNodeEh read FRoot write FRoot;
    property OnExpandedChanged: TTreeNodeNotifyEvent read FOnExpandedChanged write FOnExpandedChanged;
    property OnExpandedChanging: TTreeNodeNotifyResultEvent read FOnExpandedChanging write FOnExpandedChanging;
  end;

implementation

{ TTreeNodeEh }

constructor TTreeNodeEh.Create;
begin
  inherited Create;
  FItems := TList.Create;
  FVisibleItems := TList.Create;
  FVisible := True;
end;

destructor TTreeNodeEh.Destroy;
var
  I: Integer;
begin
  for I := 0  to FItems.Count - 1  do
    TTreeNodeEh(FItems[I]).Free;
  FItems.Free;
  FVisibleItems.Free;
  inherited Destroy;
end;

procedure TTreeNodeEh.Exchange(Index1, Index2: Integer);
begin
  if Index1 = Index2 then Exit;
  FItems.Exchange(Index1, Index2);
  Items[Index2].FIndex := Index2;
  Items[Index1].FIndex := Index1;
  //Visible Index now invalid.
end;

function TTreeNodeEh.GetCount;
begin
  Result := FItems.Count;
end;

function TTreeNodeEh.GetVisibleCount: Integer;
begin
  if FVisibleCount = Count
    then Result := Count
    else Result := FVisibleItems.Count;
end;

function TTreeNodeEh.GetItem(const Index: Integer): TTreeNodeEh;
begin
  if (Index < 0) or (Index > FItems.Count-1) then
    begin
      Result := nil;
      Exit;
    end;
  Result := TTreeNodeEh(FItems.Items[Index]);
end;

procedure TTreeNodeEh.QuickSort(L, R: Integer; Compare: TCompareNodesEh; ParamSort: TObject);
var
  I, J: Integer;
  P: TTreeNodeEh;
begin
  repeat
    I := L;
    J := R;
    P := Items[(L + R) shr 1];
    repeat
      while Compare(Items[I], P, ParamSort) < 0 do
        Inc(I);
      while Compare(Items[J], P, ParamSort) > 0 do
        Dec(J);
      if I <= J then
      begin
        Exchange(I, J);
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSort(L, J, Compare, ParamSort);
    L := I;
  until I >= R;
  
  if FVisibleCount <> Count then
    BuildVisibleItems();
//  Owner.BuildChildrenIndex(Self, False); // To reset visible index.
end;

procedure TTreeNodeEh.SetExpanded(const Value: Boolean);
begin
  if FExpanded = Value then Exit;
  if ExpandedChanging then
  begin
    FExpanded := Value;
    ExpandedChanged;
  end;
end;

procedure TTreeNodeEh.SetVisible(const Value: Boolean);
begin
  if FVisible = Value then Exit;
  if VisibleChanging then
  begin
    FVisible := Value;
    VisibleChanged;
  end;  
end;

procedure TTreeNodeEh.SortData(CompareProg: TCompareNodesEh; ParamSort: TObject; ARecurse: Boolean);
var
  i: Integer;
begin
  if Count = 0 then Exit;
  QuickSort(0, Count-1, CompareProg, ParamSort);
  if ARecurse then
    for i := 0 to Count-1  do
      Items[i].SortData(CompareProg, ParamSort, ARecurse);
//  Owner.BuildChildrenIndex(Self, False);
end;

procedure TTreeNodeEh.ExpandedChanged;
begin
  Owner.ExpandedChanged(Self);
end;

function TTreeNodeEh.ExpandedChanging: Boolean;
begin
  Result := Owner.ExpandedChanging(Self);
end;

procedure TTreeNodeEh.VisibleChanged;
begin
//  if Visible then
  FParent.ChildVisibleChanged(Self);
end;

procedure TTreeNodeEh.ChildVisibleChanged(ChildNode: TTreeNodeEh);
//var
//  i{, j}: Integer;
begin
  BuildVisibleItems();
{  if Visible then
  begin
    for i := 0 to Count-1 do
      if Items[i].Index > ChildNode.Index then
      begin
        FVisibleItems.Insert(i, ChildNode);
        ChildNode.FVisibleIndex := i;
        for j := i+1 to FVisibleItems.Count-1 do
          Inc(TTreeNodeEh(FVisibleItems[i]).FVisibleIndex);
        Exit;
      end;
    ChildNode.FVisibleIndex := FVisibleItems.Add(ChildNode);
  end else
    for i := 0 to Count-1 do
      if Items[i].Index = ChildNode.Index then
      begin
        FVisibleItems.Delete(i);
        for j := i to FVisibleItems.Count-1 do
          Dec(TTreeNodeEh(FVisibleItems[i]).FVisibleIndex);
        Exit;
      end;}
end;

function TTreeNodeEh.VisibleChanging: Boolean;
begin
  Result := True;
end;

procedure TTreeNodeEh.SetLevel(ALevel: Integer);
var
  i: Integer;
begin
  if FLevel <> ALevel then
  begin
    if ALevel > Owner.MaxLevel then
      raise Exception.Create('TTreeNodeEh.SetLevel: Max level exceed - ' + IntToStr(Owner.MaxLevel));
    FLevel := ALevel;
    for i := 0 to Count-1  do
      Items[i].SetLevel(FLevel+1);
  end;
end;

function TTreeNodeEh.GetVisibleItem(const Index: Integer): TTreeNodeEh;
begin
  Result := TTreeNodeEh(VisibleItems[Index]);
end;

function TTreeNodeEh.VisibleItems: TList;
begin
  if Count = VisibleCount
    then Result := FItems
    else Result := FVisibleItems;
end;

function TTreeNodeEh.Add(Item: TTreeNodeEh): Integer;
begin
  if Item.Owner <> Owner then
    raise Exception.Create('TTreeNodeEh.Add: Tree nodes can not has different Owners');
  if (FVisibleCount = Count) and Item.Visible then
  begin
    Result := FItems.Add(Item);
    Inc(FVisibleCount);
  end else
  begin
    Result := FItems.Add(Item);
    BuildVisibleItems();
  end;
end;

procedure TTreeNodeEh.Clear;
begin
  FItems.Clear;
  FVisibleItems.Clear;
end;

procedure TTreeNodeEh.Delete(Index: Integer);
begin
  if FVisibleCount = Count then
  begin
    FItems.Delete(Index);
    Dec(FVisibleCount);
  end else
  begin
    FItems.Delete(Index);
    BuildVisibleItems();
  end;
end;

procedure TTreeNodeEh.Insert(Index: Integer; Item: TTreeNodeEh);
begin
  if Item.Owner <> Owner then
    raise Exception.Create('TTreeNodeEh.Add: Tree nodes can not has different Owners');
  if (FVisibleCount = Count) and Item.Visible then
  begin
    FItems.Insert(Index, Item);
    Inc(FVisibleCount);
  end else
  begin
    FItems.Insert(Index, Item);
    BuildVisibleItems();
  end;
end;

procedure TTreeNodeEh.BuildVisibleItems;
var
  i: Integer;
begin
  FVisibleItems.Clear;
  for i := 0 to Count-1 do
    if Items[i].Visible then
      Items[i].FVisibleIndex := FVisibleItems.Add(Items[i]);
  FVisibleCount := FVisibleItems.Count;
  if (Count > 0) {and HasChildren} then
    HasChildren := (VisibleCount > 0);
end;

function TTreeNodeEh.HasParentOf(Node: TTreeNodeEh): Boolean;
var
  ANode: TTreeNodeEh;
begin
  Result := False;
  ANode := Self;
  while ANode <> Owner.Root do
  begin
    if ANode = Node then
    begin
      Result := True;
      Exit;
    end;
    ANode := ANode.Parent;
  end;
end;

{ TTreeListEh }

constructor TTreeListEh.Create(ItemClass: TTreeNodeClassEh);
begin
  inherited Create;
  FItemClass := ItemClass;
  Root := FItemClass.Create;
  Root.Parent := nil;
  Root.FLevel := 0;
  Root.FOwner := Self;
  FMaxLevel := 1000;
end;

destructor TTreeListEh.Destroy;
begin
  Root.Free;
  inherited Destroy;
end;

function TTreeListEh.AddChild(const Text: string; Parent: TTreeNodeEh; Data: TObject): TTreeNodeEh;
var
  ParentNode: TTreeNodeEh;
  NewNode: TTreeNodeEh;
  ChildIndex: Integer;
begin
  if Parent = nil
    then ParentNode := FRoot
    else ParentNode := Parent;
  NewNode := FItemClass.Create;
  NewNode.Parent := ParentNode;
  ParentNode.HasChildren := True;
  NewNode.FOwner := Self;
  NewNode.Data := Data;
  ChildIndex := ParentNode.Add(NewNode);
  NewNode.Text := Text;
  NewNode.SetLevel(ParentNode.Level + 1);
  NewNode.FIndex := ChildIndex;
//  NewNode.FVisibleIndex := ParentNode.FVisibleItems.Add(NewNode);
  Result := NewNode;
end;

procedure TTreeListEh.DeleteChildren(Node: TTreeNodeEh);
var
  I: Integer;
begin
 for I := 0  to Node.Count - 1  do
   Node.Items[I].Free;
 Node.Clear;
end;

procedure TTreeListEh.DeleteNode(Node: TTreeNodeEh; ReIndex: Boolean);
begin
  DeleteChildren(Node);
  if Node.Parent = nil then
    Exit;
  Node.Parent.Delete(Node.Index);
  Node.Parent.HasChildren := (Node.Parent.Count > 0);
  Node.Free;
  if ReIndex then
    BuildChildrenIndex(Node.Parent, False);
end;

procedure TTreeListEh.Expand(Node: TTreeNodeEh; Recurse: Boolean);
var
  I: Integer;
begin
  if Node = nil then Node := FRoot;
  if Node.Count > 0 then
  begin
    if Node <> FRoot then
      Node.Expanded := True;
    if Recurse then
      for I := 0 to Node.Count-1 do
        Expand(Node.Items[I], True);
  end;
end;

procedure TTreeListEh.Collapse(Node: TTreeNodeEh; Recurse: Boolean);
var
  I: Integer;
begin
  if Node = nil then Node := FRoot;
  Node.Expanded := False;
  if Recurse then
    for I := 0 to Node.Count-1 do
      Collapse(Node.Items[I], True);
end;


procedure TTreeListEh.AddNode(Node: TTreeNodeEh; Destination: TTreeNodeEh; Mode: TNodeAttachModeEh; ReIndex: Boolean);
begin
  if (Node = nil) or (Node = FRoot) then Exit;
  if Destination = nil then Destination := FRoot;
  if (Destination = FRoot) and (Mode <> naAddChildEh) and
     (Mode <> naAddChildFirstEh)
  then Exit;

  case Mode of
    naAddChildEh:
      begin
        Node.Parent := Destination;
        Destination.HasChildren := True;
        Node.FIndex := Destination.Add(Node);
        Node.SetLevel(Destination.Level + 1);
      end;
    naAddChildFirstEh:
      begin
        Node.Parent := Destination;
        Destination.HasChildren := True;
        Destination.Insert(0, Node);
        Node.FIndex := 0;
        Node.SetLevel(Destination.Level + 1);
        if ReIndex then BuildChildrenIndex(Node.Parent, False);
      end;
    naAddEh:
      begin
        AddNode(Node, Destination.Parent, naAddChildEh, False);
      end;
    naAddFirstEh:
      begin
        AddNode(Node, Destination.Parent, naAddChildFirstEh, ReIndex);
      end;
    naInsertEh:
      begin
        Node.Parent := Destination.Parent;
        Destination.Parent.HasChildren := True;
        Destination.Parent.Insert(Destination.Index, Node);
        Node.FIndex := Destination.Index;
        Node.SetLevel(Destination.Parent.Level + 1);
        if ReIndex then BuildChildrenIndex(Destination.Parent, False);
      end;
  end;
end;

procedure TTreeListEh.MoveTo(Node: TTreeNodeEh; Destination: TTreeNodeEh; Mode: TNodeAttachModeEh; ReIndex: Boolean);
begin
  if {(Destination = nil) or} (Node = nil) or (Node = FRoot) then Exit;
  if (Destination = FRoot) and (Mode <> naAddChildEh) and (Mode <> naAddChildFirstEh) then
    Exit;

  if Destination.HasParentOf(Node) then
    raise Exception.Create('Reference-loop found');

  Node.Parent.Delete(Node.Index);
  Node.Parent.HasChildren := (Node.Parent.Count > 0);
//
  if ReIndex then BuildChildrenIndex(Node.Parent, False);
  AddNode(Node, Destination, Mode, ReIndex);
end;

function TTreeListEh.GetNode(StartNode: TTreeNodeEh; Data: TObject): TTreeNodeEh;
var
  I: Integer;
  CurNode: TTreeNodeEh;
begin
  Result := nil;
  if StartNode = nil then StartNode := FRoot;
  for I := 0 to StartNode.Count - 1 do
  begin
    CurNode := StartNode.Items[I];
    if CurNode.Data = Data then
    begin
      Result := CurNode;
      Break;
    end
    else
    begin
      Result := GetNode(CurNode, Data);
      if result <> nil then
        Break;
    end;
  end
end;

function TTreeListEh.GetPrevSibling(Node: TTreeNodeEh): TTreeNodeEh;
begin
  if (Node = nil) or (Node.Index = 0) or (Node.Parent = nil) then
  begin
    Result := nil;
    exit;
  end;
  Result := TTreeNodeEh(Node.Parent.Items[Node.Index - 1]);
end;

function TTreeListEh.GetNextSibling(Node: TTreeNodeEh): TTreeNodeEh;
begin
  if (Node = nil) or (Node.Parent = nil) or (Node.Index = Node.Parent.Count - 1) then
  begin
    Result := nil;
    Exit;
  end;
  Result := Node.Parent.Items[Node.Index + 1];
end;

function TTreeListEh.GetFirstChild(Node: TTreeNodeEh): TTreeNodeEh;
begin
  if (Node = nil) or (Node.Count = 0) then
  begin
    Result := nil;
    Exit;
  end;
  Result := Node.Items[0];
end;

function TTreeListEh.GetLastChild(Node: TTreeNodeEh): TTreeNodeEh;
begin
  if (Node = nil) or (Node.Count = 0) then
  begin
    result := nil;
    Exit;
  end;
  Result := Node.Items[Node.Count - 1];
end;


function TTreeListEh.GetFirst: TTreeNodeEh;
begin
  Result := GetFirstChild(FRoot);
end;


function TTreeListEh.GetPrevious(Node: TTreeNodeEh): TTreeNodeEh;
var
  PrevSiblingNode: TTreeNodeEh;
begin
  Result := Node;
  if (Result = nil) or (Result = FRoot) then exit;
  PrevSiblingNode := GetPrevSibling(Result);
  if PrevSiblingNode <> nil then
  begin
    Result := GetLast(PrevSiblingNode);
    if Result = nil then
      Result := PrevSiblingNode;
  end
  else
    if Node.Parent <> FRoot then
      Result := Node.Parent
    else
      Result := nil;
end;

function TTreeListEh.GetNext(Node: TTreeNodeEh): TTreeNodeEh;
var
  FirstChild, NextSibling: TTreeNodeEh;
begin
  Result := Node;
  if (Result = nil) or (Result = FRoot) then
    Exit;
  FirstChild := GetFirstChild(Result);
  if FirstChild <> nil then
  begin
    Result := FirstChild;
    Exit;
  end;
  repeat
    NextSibling := GetNextSibling(Result);
    if NextSibling <> nil then
    begin
      Result := NextSibling;
      Break;
    end
    else
    begin
      if Result.Parent <> FRoot then
        Result := Result.Parent
      else
      begin
        Result := nil;
        Break;
      end;
    end;
  until False;
end;


function TTreeListEh.GetLast(Node: TTreeNodeEh = nil): TTreeNodeEh;
var
  Next: TTreeNodeEh;
begin
  if Node = nil then
    Node := FRoot;
  Result := GetLastChild(Node);
  while Result <> nil do
  begin
    Next := GetLastChild(Result);
    if Next = nil then
      Break;
    Result := Next;
  end;
end;

function TTreeListEh.IsHasChildren(Node: TTreeNodeEh = nil): Boolean;
begin
  if Node = nil then
    Node := FRoot;
  Result := Node.Count > 0;
end;

function TTreeListEh.CountChildren(Node: TTreeNodeEh = nil): Integer;
begin
  if Node = nil then
    Node := FRoot;
  Result := Node.Count;
end;

function TTreeListEh.GetParentAtLevel(Node: TTreeNodeEh; ParentLevel: Integer): TTreeNodeEh;
begin
  Result := nil;
  if (Node = nil) or (Node = FRoot) then
    Exit;
  if (ParentLevel >= Node.Level) or (ParentLevel < 0) then
    Exit;
  if ParentLevel = 0 then
  begin
    Result := FRoot;
    Exit;
  end;
  Result := Node;
  while Result <> nil do
  begin
    Result := Result.Parent;
    if Result <> nil then
      if Result.Level = ParentLevel then
        Break;
  end;
end;

function TTreeListEh.GetFirstVisible: TTreeNodeEh;
var
  CurNode: TTreeNodeEh;
begin
  Result := nil;
  if not IsHasChildren then
    Exit;
  CurNode := GetFirstChild(FRoot);
  if CurNode = nil then
    Exit;
  Result := CurNode;
  if not Result.Visible then
  begin
    repeat
      CurNode := GetNextSibling(Result);
      if CurNode <> nil then
      begin
        Result := CurNode;
        if Result.Visible then
          Break;
      end else
      begin
        if Result.Parent <> FRoot then
          Result := Result.Parent
        else
        begin
          Result := nil;
          Break;
        end;
      end;
    until False;
  end;
end;

function TTreeListEh.GetPathVisible(Node: TTreeNodeEh; ConsiderCollapsed: Boolean): Boolean;
begin
  Result := False;
  if (Node = nil) or (Node = FRoot) then exit;
  repeat
    Node := Node.Parent;
  until (Node = FRoot) or not (Node.Expanded or not ConsiderCollapsed) or not (Node.Visible);
  Result := (Node = FRoot);
end;

function TTreeListEh.GetParentVisible(Node: TTreeNodeEh; ConsiderCollapsed: Boolean): TTreeNodeEh;
begin
  Result := Node;
  while Result <> FRoot do
  begin
    repeat
      Result := Result.Parent;
    until (Result.Expanded or not ConsiderCollapsed);
    if (Result = FRoot) or (Result.Visible and GetPathVisible(Result, ConsiderCollapsed)) then
      Break;
    while (Result <> FRoot) and (Result.Parent.Expanded or not ConsiderCollapsed) do
      Result := Result.Parent;
  end;
end;

function TTreeListEh.GetNextVisible(Node: TTreeNodeEh; ConsiderCollapsed: Boolean): TTreeNodeEh;
var
  ForceSearch: Boolean;
  FirstChild, NextSibling: TTreeNodeEh;
begin
  Result := Node;
  if Result <> nil then
  begin
    if Result = FRoot then
    begin
      Result := nil;
      Exit;
    end;
    if not (Result.Visible) or not (GetPathVisible(Result, ConsiderCollapsed))  then
      Result := GetParentVisible(Result, ConsiderCollapsed);

    FirstChild := GetFirstChild(Result);
    if (Result.Expanded or not ConsiderCollapsed) and (FirstChild <> nil)  then
    begin
      Result := FirstChild;
      ForceSearch := False;
    end
    else
      ForceSearch := True;

    if (Result <> nil) and (ForceSearch or not (Result.Visible)) then
    begin
      repeat
        NextSibling := GetNextSibling(Result);
        if NextSibling <> nil then
        begin
          Result := NextSibling;
          if Result.Visible then
            Break;
        end
        else
        begin
          if Result.Parent <> FRoot then
            Result := Result.Parent
          else
          begin
            Result := nil;
            Break;
          end;
        end;
      until False;
    end;
  end;
end;

procedure TTreeListEh.Clear;
begin
 DeleteChildren(FRoot);
end;

procedure TTreeListEh.BuildChildrenIndex(Node: TTreeNodeEh = nil; Recurse: Boolean = True);
var
  I: Integer;
  CurNode: TTreeNodeEh;
begin
  if Node = nil then
    Node := FRoot;
  Node.FVisibleItems.Clear;
  for I := 0 to Node.Count - 1 do
  begin
    CurNode := Node.Items[I];
    CurNode.FIndex := I;
{    if CurNode.Visible
      then CurNode.FVisibleIndex := Node.FVisibleItems.Add(CurNode)
      else CurNode.FVisibleIndex := -1;}
    if Recurse then
      BuildChildrenIndex(CurNode, True);
  end;
  Node.BuildVisibleItems;
end;

procedure TTreeListEh.ExportToTreeView(TreeView:TTreeView; Node: TTreeNodeEh; NodeTree: TTreeNode;AddChild:Boolean);
var
  CurNode:TTreeNodeEh;
  TreeNode:TTreeNode;
begin
  CurNode := Node;
  while CurNode <> nil do
  begin
    if AddChild then
      TreeNode:=TreeView.Items.AddChildObject(NodeTree, CurNode.Text, CurNode.Data)
    else
      TreeNode:=TreeView.Items.AddObject(NodeTree, CurNode.Text, CurNode.Data);
      TreeNode.Expanded := CurNode.Expanded;
      ExportToTreeView(TreeView, GetFirstChild(CurNode), TreeNode,True);
      CurNode:=GetNextSibling(CurNode);
  end;
end;

procedure TTreeListEh.QuickSort(L, R: Integer; Compare: TCompareNodesEh);
begin
end;

procedure TTreeListEh.SortData(CompareProg: TCompareNodesEh; ParamSort: TObject;  ARecurse: Boolean);
begin
  FRoot.SortData(CompareProg, ParamSort, ARecurse);
end;

function TTreeListEh.GetNextVisibleSibling(Node: TTreeNodeEh): TTreeNodeEh;
begin
  if Node.Parent.Count = Node.Parent.VisibleCount then
    Result := GetNextSibling(Node)
  else
  begin
    if (Node = nil) or (Node.Parent = nil) or (Node.VisibleIndex = Node.Parent.VisibleCount - 1) then
    begin
      Result := nil;
      Exit;
    end;
    Result := Node.Parent.VisibleItem[Node.VisibleIndex + 1];
  end;
end;

function TTreeListEh.GetPrevVisibleSibling(Node: TTreeNodeEh): TTreeNodeEh;
begin
  if Node.Parent.Count = Node.Parent.VisibleCount then
    Result := GetPrevSibling(Node)
  else
  begin
    if (Node = nil) or (Node.Parent = nil) or (Node.VisibleIndex = 0) then
    begin
      Result := nil;
      Exit;
    end;
    Result := Node.Parent.VisibleItem[Node.VisibleIndex - 1];
  end;
end;

procedure TTreeListEh.ExpandedChanged(Node: TTreeNodeEh);
begin
  if Assigned(OnExpandedChanged) then
    OnExpandedChanged(Node);
end;

function TTreeListEh.ExpandedChanging(Node: TTreeNodeEh): Boolean;
begin
  Result := True;
  if Assigned(OnExpandedChanging) then
    Result := OnExpandedChanging(Node);
end;

end.

