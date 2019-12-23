unit gs6_shel;
{-----------------------------------------------------------------------------
                            dBase File Interface

       gs6_shel Copyright (c) 1996 Griffin Solutions, Inc.

       Date
          4 Aug 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit provides access to Griffin Solutions dBase Objects
       using high-level procedures and functions that make Object
       Oriented Programming transparent to the user.  It provides a
       selection of commands similar to the dBase format.

   Changes:


------------------------------------------------------------------------------}
{$I gs6_flag.pas}
interface
uses
   SysHalc,
   SysUtils,
   Classes,
   gs6_dbsy,
   gs6_tool,
   gs6_sort,
   gs6_date,
   gs6_disk,
   gs6_dbf,
   gs6_sql,
   gs6_indx,
   gs6_cnst,
   gs6_glbl;

type
   gsSortStatus = (Ascending, Descending, SortUp, SortDown,
                   SortDictUp, SortDictDown, NoSort,
                   AscendingGeneral, DescendingGeneral);

   gsIndexUnique = (Unique, Duplicates);

   gsLokProtocol = (Default, DB4Lock, ClipLock, FoxLock);

   gsDBFTypes = (Clipper,DBaseIII,DBaseIV,FoxPro2);

   gsDBFState = (dssInactive, dssRecLoad, dssBrowse, dssEdit, dssAppend, dssIndex);

   gsDBFFilterOption = (foCaseInsensitive, foNoPartialCompare);
   gsDBFFilterOptions = set of gsDBFFilterOption;

   FilterCheck   = Function: boolean;
   StatusProc    = CaptureStatus;

   DBFObject = class(GSO_dBHandler)
      DBFFilter   : FilterCheck;
      DBFStatus   : StatusProc;
      constructor Create(const FName, APassword: String; ReadWrite, Shared: boolean);
      Procedure   gsStatusUpdate(stat1,stat2,stat3 : longint); override;
      Function    gsTestFilter : boolean; override;
   end;

   TgsDBFTable = class(TObject)
   private
      DBFState      : gsDBFState;
      DBFName       : string;
      DBFReadWrite  : boolean;
      DBFShared     : boolean;
      DBFUseDeleted : boolean;
      DBFAutoFlush  : boolean;
      DBFFilter     : FilterCheck;
      DBFStatus     : StatusProc;
      FDBFHandle    : DBFObject;
      FExactCount   : boolean;
      FFilterText   : string;
      FFilterOptions: gsDBFFilterOptions;
      FFiltered     : Boolean;
   protected
      procedure CheckActive;
      procedure ConfirmBrowse;
      procedure ConfirmEdit;
      function  GetActiveState: boolean;
      procedure SetActiveState(Value: boolean);
      function  GetRecno: longint;
      procedure SetRecNo(Value: longint);
      procedure SetState(Value: gsDBFState);
      procedure SetFiltered(Value: Boolean); virtual;
      procedure SetFilterOptions(Value: gsDBFFilterOptions); virtual;
      procedure SetFilterText(const Value: string); virtual;
      procedure SetFilterData(const Text: string; Options: gsDBFFilterOptions);
   public
      constructor Create(const FName, APassword: String; ReadWrite, Shared: boolean);
      destructor  Destroy; override;
      Procedure   Append;
      procedure   AssignUserID(id: longint);
      procedure   Cancel;
      Procedure   ClearRecord;
      Procedure   CopyStructure(const filname, apassword: string);
      Procedure   CopyTo(const filname, apassword: string);
      Function    BOF : boolean;
      Function    Deleted : boolean;
      Procedure   Delete;
      Procedure   Edit;
      Function    EOF : boolean;
      Function    ExternalChange: integer;
      Function    Field(n : integer) : string;
      Function    FieldCount : integer;
      Function    FieldDec(n : integer) : integer;
      Function    FieldLen(n : integer) : integer;
      Function    FieldNo(fn : string) : integer;
      Function    FieldType(n : integer) : char;
      Function    Find(ss : string; IsExact, IsNear: boolean): boolean;
      Function    FLock : boolean;
      Procedure   FlushDBF;
      Procedure   Go(n : longint);
      Procedure   Last;
      Procedure   First;
      procedure   Next;
      procedure   Post;
      procedure   Prior;
      Procedure   MoveBy(n : longint);
      procedure   Refresh;
      Function   HuntDuplicate(const st, ky: String) : longint;
      Function   Index(INames,Tag : string): integer;
      Function   IndexCount: integer;
      Function   IndexCurrent: string;
      Function   IndexCurrentOrder: integer;
      Function   IndexExpression(Value: integer): string;
      Function   IndexKeyLength(Value: integer): integer;
      Function   IndexKeyType(Value: integer): char;
      Function   IndexFilter(Value: integer): string;
      Function   IndexUnique(Value: integer): boolean;
      Function   IndexAscending(Value: integer): boolean;
      Function   IndexFileName(Value: integer): string;
      Procedure  IndexIsProduction(tf: boolean);
      function   IndexKeyValue(Value: integer): string;
      Function   IndexMaintained: boolean;
      Procedure  IndexFileInclude(const IName: string);
      Procedure  IndexFileRemove(const IName: string);
      Procedure  IndexTagRemove(const IName, Tag: string);
      Procedure  IndexOn(const IName, tag, keyexp, forexp: String;
                      uniq: gsIndexUnique; ascnd: gsSortStatus);
      Function   IndexTagName(Value: integer): string;
      Function   LUpdate: string;
      Function   MemoryIndexAdd(const tag, keyexpr, forexpr: String;
                 uniq: gsIndexUnique; ascnd: gsSortStatus): boolean;
      Procedure  Pack;
      function    QueryHandler: TgsExpUserLink;
      Procedure  Recall;
      Function   RecordCount : longint;
      Function   RecSize : word;
      Procedure  Reindex;
      procedure  RenameTable(const NewTableName: string);
      Function   RLock : boolean;
      procedure  ReturnDateTimeUser(var dt, tm, us: longint);
      Function   SearchDBF(const s: String; var FNum : word;
                        var fromrec: longint; torec: longint): word;
      procedure  SetAutoFlush(tf: boolean);
      Procedure  SetDBFCache(tf: boolean);
      Procedure  SetDBFCacheAllowed(tf: boolean);
      Procedure  SetFilterThru(UserRoutine : FilterCheck);
      Procedure  SetLockProtocol(LokProtocol: gsLokProtocol);
      Procedure  SetOrderTo(order : integer);
      Procedure  SetRange(const RLo, RHi: string);
      Procedure  SetRangeEx(const RLo, RHi: string; LoIn, HiIn, Partial: boolean);
      Procedure  SetStatusCapture(UserRoutine : StatusProc);
      Procedure  SetTagTo(TName: string);
      Procedure  SetUseDeleted(tf: boolean);
      Procedure  SortTo(const filname, apassword, formla: string; sortseq: gsSortStatus);
      Procedure  Unlock;
      Procedure  Zap;

     {dBase field handling routines}

      Function   MemoSize(fnam: string): longint;
      Function   MemoSizeN(fnum: integer): longint;
      Procedure  MemoLoad(fnam: string;buf: PChar; var cb: longint);
      Function   MemoSave(fnam: string;buf: PChar; var cb: longint): longint;
      Procedure  MemoLoadN(fnum: integer;buf: PChar; var cb: longint);
      Function   MemoSaveN(fnum: integer;buf: PChar; var cb: longint): longint;
      Function   DateGet(st : string) : longint;
      Function   DateGetN(n : integer) : longint;
      Procedure  DatePut(st : string; jdte : longint);
      Procedure  DatePutN(n : integer; jdte : longint);
      Function   FieldGet(fnam : string) : string;
      Function   FieldGetN(fnum : integer) : string;
      Procedure  FieldPut(fnam, st : string);
      Procedure  FieldPutN(fnum : integer; st : string);
      Function   FloatGet(st : string) : FloatNum;
      Function   FloatGetN(n : integer) : FloatNum;
      Procedure  FloatPut(st : string; r : FloatNum);
      Procedure  FloatPutN(n : integer; r : FloatNum);
      Function   LogicGet(st : string) : boolean;
      Function   LogicGetN(n : integer) : boolean;
      Procedure  LogicPut(st : string; b : boolean);
      Procedure  LogicPutN(n : integer; b : boolean);
      Function   IntegerGet(st : string) : LongInt;
      Function   IntegerGetN(n : integer) : LongInt;
      Procedure  IntegerPut(st : string; i : LongInt);
      Procedure  IntegerPutN(n : integer; i : LongInt);
      Function   StringGet(fnam : string) : string;
      Function   StringGetN(fnum : integer) : string;
      Procedure  StringPut(fnam, st : string);
      Procedure  StringPutN(fnum : integer; st : string);
      function   GetFileVersion: byte;
      procedure  EncryptFile(const APassword: string);
       {Added because EncryptFile is reserved in CBuilder}
      procedure  EncryptDBFFile(const APassword: string);

      property Active: boolean read GetActiveState write SetActiveState;
      property DBFHandle: DBFObject read FDBFHandle;
      property RecNo: longint read GetRecNo write SetRecNo;
      property FileVersion: byte read GetFileVersion;
      property ExactCount: boolean read FExactCount write FExactCount default false;
      property State: gsDBFState read  DBFState write DBFState;
      property Filter: string read FFilterText write SetFilterText;
      property Filtered: Boolean read FFiltered write SetFiltered default False;
      property FilterOptions: gsDBFFilterOptions read FFilterOptions write SetFilterOptions default [];
   end;


     {dBase type functions}
function CreateDBF(const fname, apassword: string; ftype: gsDBFTypes; FieldList: TStringList): boolean;

     {Default capture procedures}
Function  DefFilterCk: boolean;
Procedure DefCapStatus(stat1,stat2,stat3 : longint);

implementation

{-----------------------------------------------------------------------------
                            Data Capture Procedures
------------------------------------------------------------------------------}

{$F+}
Function DefFilterCk: boolean;
begin
   DefFilterCk := true;
end;

Procedure DefCapStatus(stat1,stat2,stat3 : longint);
begin
end;
{$F-}

{-----------------------------------------------------------------------------
                              Global procedures/functions
------------------------------------------------------------------------------}

function CreateDBF(const fname, apassword: string; ftype: gsDBFTypes; FieldList: TStringList): boolean;
var
   f: GSO_DBFBuild;
   fil: string;
   s: string;
   v: boolean;
   i: integer;
   p: integer;
   fs: string[10];
   ft: string[1];
   fl: integer;
   fd: integer;
   sl: TStringList;
   sv: integer;
   FCopy  : GSO_dBHandler;

   procedure LoadField;
   begin
      p := pos(';',s);
      fs := '';
      if p > 0 then
      begin
         fs := system.copy(s,1,pred(p));
         system.delete(s,1,p);
      end
      else v := false;

      p := pos(';',s);
      ft := ' ';
      if p = 2 then
      begin
         ft := system.copy(s,1,1);
         system.delete(s,1,p);
      end
      else v := false;

      p := pos(';',s);
      fl := 0;
      if p > 0 then
      begin
         try
            fl := StrToInt(system.copy(s,1,pred(p)));
            system.delete(s,1,p);
         except
            on Exception do v := false;
         end;
      end
      else v := false;

      fd := 0;
      try
         fd := StrToInt(system.copy(s,1,3));
      except
         on Exception do v := false;
      end;

   end;

begin
   if FieldList.Count = 0 then
   begin
      raise EHalcyonError.Create(gsErrInvalidFieldList);
      exit;
   end;
   fil := fname;
   sl := TStringList.Create;
   for i := 0 to pred(FieldList.Count) do
   begin
      v := true;
      s := Fieldlist.Strings[i];
      While (length(s) > 0) and (s[length(s)] in [' ',';']) do
         system.Delete(s,length(s),1);
      if s <> '' then
         LoadField;
      if v then
      begin
         fs := AnsiUpperCase(fs);
         v := not sl.Find(fs, sv);
      end;
      if not v then
      begin
         sl.Free;
         raise EHalcyonError.Create(gsErrInvalidFieldList);
         exit;
      end;
      sl.Add(fs);
   end;
   sl.Free;

   case FType of
      Clipper,
      DBaseIII : f := GSO_DB3Build.Create(fil);
      DBaseIV  : f := GSO_DB4Build.Create(fil);
      FoxPro2  : f := GSO_DBFoxBuild.Create(fil);
      else       f := GSO_DB3Build.Create(fil);
   end;
   for i := 0 to pred(FieldList.Count) do
   begin
      s := Fieldlist.Strings[i];
      While (length(s) > 0) and (s[length(s)] in [' ',';']) do
         system.Delete(s,length(s),1);
      if s <> '' then
         LoadField;
      f.InsertField(fs,ft[1],fl,fd);
   end;
   f.Complete;
   Result :=  (f.dFile <> nil);
   f.Free;
   if apassword <> '' then
   begin
      FCopy := GSO_dBHandler.Create(fname, '',true,false);
      FCopy.gsSetPassword(apassword);
      FCopy.Free;
   end;
end;

{-----------------------------------------------------------------------------
                              DBFObject Class
------------------------------------------------------------------------------}


constructor DBFObject.Create(const FName, APassword: String; ReadWrite, Shared: boolean);
begin
   inherited Create(FName,APassword,ReadWrite,Shared);
   DBFFilter := DefFilterCk;
   DBFStatus := DefCapStatus;
end;

Procedure DBFObject.gsStatusUpdate(stat1,stat2,stat3 : longint);
begin
   DBFStatus(stat1,stat2,stat3);
end;

Function DBFObject.gsTestFilter : boolean;
begin
   if dState = dbIndex then
      gsTestFilter := true
   else
   begin
      if DBFFilter then
         gsTestFilter := inherited gsTestFilter
      else
         gsTestFilter := false;
   end;
end;

{-----------------------------------------------------------------------------
                                TgsDBFTable Class
------------------------------------------------------------------------------}

constructor TgsDBFTable.Create(const FName, APassword: String; ReadWrite, Shared: boolean);
begin
   inherited Create;
   FDBFHandle := nil;
   DBFName := FName;
   DBFReadWrite := ReadWrite;
   DBFShared := Shared;
   DBFUseDeleted := false;
   DBFAutoFlush := false;
   DBFFilter := DefFilterCk;
   DBFStatus := DefCapStatus;
   FDBFHandle := DBFObject.Create(DBFName, APassword, DBFReadWrite, DBFShared);
   FDBFHandle.UseDeletedRec := DBFUseDeleted;
   FDBFHandle.gsvAutoFlush := DBFAutoFlush;
   FDBFHandle.DBFFilter := DBFFilter;
   FDBFHandle.DBFStatus := DBFStatus;
   DBFState := dssBrowse;
   First;
end;

destructor TgsDBFTable.Destroy;
begin
   if FDBFHandle <> nil then FDBFHandle.Free;
end;

procedure TgsDBFTable.CheckActive;
begin
   if not Assigned(FDBFHandle) then
   begin
      raise EHalcyonError.Create(gsErrTableIsNil);
   end;
end;

procedure TgsDBFTable.ConfirmEdit;
begin
   if not (DBFState in [dssEdit, dssAppend]) then
   begin
      raise EHalcyonError.Create(gsErrNotEditing);
   end;
end;

procedure TgsDBFTable.ConfirmBrowse;
begin
   if not (DBFState in [dssBrowse]) then
   begin
      raise EHalcyonError.Create(gsErrNotBrowsing);
   end;
end;

Function TgsDBFTable.GetActiveState: boolean;
begin
   Result := FDBFHandle <> nil;
end;

procedure TgsDBFTable.SetActiveState(Value: boolean);
begin
   if Value then
      CheckActive
   else
   begin
      if FDBFHandle <> nil then
      begin
         FDBFHandle.Free;
         FDBFHandle := nil;
         DBFState := dssInactive;
      end;
   end;
end;

Function TgsDBFTable.GetRecNo : longint;
begin
   CheckActive;
   Result := FDBFHandle.RecNumber;
end;

procedure TgsDBFTable.SetRecNo(Value: longint);
begin
   Go(Value);
end;

procedure TgsDBFTable.SetState(Value: gsDBFState);
begin
   if Value = DBFState then exit;
   DBFState := Value;
end;



Procedure TgsDBFTable.AssignUserID(id: longint);
begin
   CheckActive;
   FDBFHandle.gsAssignUserID(id);
end;

procedure TgsDBFTable.Cancel;
begin
   CheckActive;
   SetState(dssBrowse);
   Go(Same_Record);
   Unlock;
end;

Procedure TgsDBFTable.ClearRecord;
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsBlank;
end;

Procedure TgsDBFTable.CopyStructure(const filname, apassword: string);
var
   FCopy  : GSO_dBHandler;
begin
   CheckActive;
   FDBFHandle.gsCopyStructure(filname);
   if apassword <> '' then
   begin
      FCopy := GSO_dBHandler.Create(filname, '',true,false);
      FCopy.gsSetPassword(apassword);
      FCopy.Free;
   end;
end;

Procedure TgsDBFTable.CopyTo(const filname, apassword: string);
begin
   CheckActive;
   FDBFHandle.gsCopyFile(filname, apassword);
end;

Function TgsDBFTable.BOF : boolean;
begin
   CheckActive;
   BOF := FDBFHandle.File_TOF
end;

Function TgsDBFTable.Deleted : boolean;
begin
   CheckActive;
   Deleted := FDBFHandle.gsDelFlag;
end;

Procedure TgsDBFTable.Delete;
begin
   CheckActive;
   FDBFHandle.gsDeleteRec;
end;

procedure TgsDBFTable.Append;
begin
   Post;
   if DBFState in [dssEdit,dssAppend] then exit;
   if not DBFReadWrite then
      raise EHalcyonError.Create(gsErrDataSetReadOnly);
   SetState(dssAppend);
   ClearRecord;
   FDBFHandle.RecModified := False;
end;


Procedure TgsDBFTable.Edit;
begin
   Post;
   if DBFState in [dssRecLoad, dssEdit,dssAppend] then exit;
   if not DBFReadWrite then
      raise EHalcyonError.Create(gsErrDataSetReadOnly);
   if RecordCount = 0 then
      Append
   else
   begin
      Go(Same_Record);
      if not RLock then
         raise EHalcyonError.Create(gsErrRecordLockAlready);
      SetState(dssEdit);
   end;
end;

procedure TgsDBFTable.Post;
begin
   CheckActive;
   case DBFState of
      dssEdit   : begin
                     FDBFHandle.gsPutRec(FDBFHandle.RecNumber);
                     SetState(dssBrowse);
                     UnLock;
                  end;
      dssAppend : begin
                     FDBFHandle.gsAppend;
                     SetState(dssBrowse);
                  end;
   end;
end;

Function TgsDBFTable.EOF : boolean;
begin
   CheckActive;
   EOF := FDBFHandle.File_EOF;
end;

Function TgsDBFTable.ExternalChange: integer;
begin
   CheckActive;
   ExternalChange := FDBFHandle.gsExternalChange;
end;

Function TgsDBFTable.Field(n : integer) : string;
begin
   CheckActive;
   Field := FDBFHandle.gsFieldName(n);
end;

Function TgsDBFTable.FieldCount : integer;
begin
   CheckActive;
   FieldCount := FDBFHandle.NumFields;
end;

Function TgsDBFTable.FieldDec(n : integer) : integer;
begin
   CheckActive;
   FieldDec := FDBFHandle.gsFieldDecimals(n);
end;

Function TgsDBFTable.FieldLen(n : integer) : integer;
begin
   CheckActive;
   FieldLen := FDBFHandle.gsFieldLength(n);
end;

Function TgsDBFTable.FieldNo(fn : string) : integer;
var
   mtch : boolean;
   i,
   ix   : integer;
   za   : string[16];
begin
   CheckActive;
   fn := TrimRight(AnsiUpperCase(fn));
   ix := FDBFHandle.NumFields;
   i := 1;
   mtch := false;
   while (i <= ix) and not mtch do
   begin
      za := StrPas(FDBFHandle.Fields^[i].dbFieldName);
      if za = fn then
         mtch := true
      else
         inc(i);
   end;
   if mtch then
      FieldNo := i
   else
      FieldNo := 0;
end;

Function TgsDBFTable.FieldType(n : integer) : char;
begin
   CheckActive;
   FieldType := FDBFHandle.gsFieldType(n);
end;

function TgsDBFTable.Find(ss : string; IsExact, IsNear: boolean): boolean;
begin
   CheckActive;
   FDBFHandle.gsvFindNear := IsNear;
   FDBFHandle.gsvExactMatch := IsExact;
   Result := FDBFHandle.gsFind(ss);
end;

Function TgsDBFTable.FLock : boolean;
begin
   CheckActive;
   FLock := FDBFHandle.gsFLock;
end;

Procedure TgsDBFTable.FlushDBF;
begin
   if FDBFHandle = nil then exit;
   FDBFHandle.dStatus := Updated;
   FDBFHandle.gsFlush;
end;

Procedure TgsDBFTable.Go(n : longint);
var
   feof: boolean;
   fbof: boolean;
begin
   feof := false;
   fbof := false;
   Post;
   begin
      if n = Same_Record then              {!!RFG 081897}
      begin                                {!!RFG 081897}
         feof := FDBFHandle.File_EOF;      {!!RFG 081897}
         fbof := FDBFHandle.File_TOF;      {!!RFG 081897}
      end;                                 {!!RFG 081897}
      FDBFHandle.gsGetRec(n);
      if n = Same_Record then              {!!RFG 081897}
      begin                                {!!RFG 081897}
         FDBFHandle.File_EOF := feof;      {!!RFG 081897}
         FDBFHandle.File_TOF := fbof;      {!!RFG 081897}
      end;
   end;
end;

Procedure TgsDBFTable.Last;
begin
   Post;
   FDBFHandle.gsGetRec(Bttm_Record);
end;

Procedure TgsDBFTable.First;
begin
   Post;
   FDBFHandle.gsGetRec(Top_Record);
end;

Function TgsDBFTable.HuntDuplicate(const st, ky: String): longint;
begin
   CheckActive;
   HuntDuplicate := FDBFHandle.gsHuntDuplicate(st, ky);
end;

Function TgsDBFTable.Index(INames, Tag : string): integer;
begin
   CheckActive;
   Index := FDBFHandle.gsIndex(INames,Tag);
end;

Procedure TgsDBFTable.IndexFileInclude(const IName: string);
begin
   CheckActive;
   FDBFHandle.gsIndexRoute(IName);
end;

Procedure TgsDBFTable.IndexFileRemove(const IName: string);
begin
   CheckActive;
   FDBFHandle.gsIndexFileRemove(IName);
end;

Procedure TgsDBFTable.IndexTagRemove(const IName, Tag: string);
begin
   CheckActive;
   FDBFHandle.gsIndexTagRemove(IName, Tag);
end;

Procedure TgsDBFTable.IndexOn(const IName, tag, keyexp, forexp: String;
                  uniq: gsIndexUnique; ascnd: gsSortStatus);
begin
   CheckActive;
   FDBFHandle.gsIndexTo(IName, tag, keyexp, forexp,
                      GSsetIndexUnique(uniq), GSsetSortStatus(ascnd));
end;

function TgsDBFTable.IndexExpression(Value: integer): string;
var
   p: GSobjIndexTag;
begin
   CheckActive;
    p := FDBFHandle.gsIndexPointer(Value);
    if p <> nil then
       IndexExpression := StrPas(p.KeyExpr)
    else
       IndexExpression := '';
end;

function TgsDBFTable.IndexKeyLength(Value: integer): integer;
var
   p: GSobjIndexTag;
begin
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if p <> nil then
      IndexKeyLength := p.KeyLength
   else
      IndexKeyLength := 0;
end;

function TgsDBFTable.IndexKeyType(Value: integer): char;
var
   p: GSobjIndexTag;
begin
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if p <> nil then
      IndexKeyType := p.KeyType
   else
      IndexKeyType := 'C';
end;

function TgsDBFTable.IndexFilter(Value: integer): string;
var
   p: GSobjIndexTag;
begin
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if (p <> nil) and (p.ForExpr <> nil) then
      IndexFilter := StrPas(p.ForExpr)
   else
      IndexFilter := '';
end;

function TgsDBFTable.IndexUnique(Value: integer): boolean;
var
   p: GSobjIndexTag;
begin
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if p <> nil then
      IndexUnique := p.KeyIsUnique
   else
      IndexUnique := false;
end;

function TgsDBFTable.IndexAscending(Value: integer): boolean;
var
   p: GSobjIndexTag;
begin
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if p <> nil then
      IndexAscending := p.KeyIsAscending
   else
      IndexAscending := false;
end;

function TgsDBFTable.IndexFileName(Value: integer): string;
var
   p: GSobjIndexTag;
begin
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if p <> nil then
      IndexFileName := StrPas(p.Owner.IndexName)
   else
      IndexFileName := '';
end;

function TgsDBFTable.IndexTagName(Value: integer): string;
var
   p: GSobjIndexTag;
begin
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if p <> nil then
      IndexTagName := StrPas(p.TagName)
   else
      IndexTagName := '';
end;

function TgsDBFTable.IndexCount: integer;
var
   i: integer;
   n: integer;
begin
   CheckActive;
   n := 0;
   i := 1;
   while (i <= IndexesAvail) do
   begin
      if FDBFHandle.IndexStack[i] <> nil then
         n := n + FDBFHandle.IndexStack[i].TagCount;
      inc(i);
   end;
   IndexCount := n;
end;

function TgsDBFTable.IndexCurrent: string;
begin
   CheckActive;
   if FDBFHandle.IndexMaster <> nil then
      IndexCurrent := StrPas(FDBFHandle.IndexMaster.TagName)
   else
      IndexCurrent := '';
end;

function TgsDBFTable.IndexCurrentOrder: integer;
var
   p: GSobjIndexTag;
   i: integer;
   n: integer;
   ni: integer;
begin
   CheckActive;
   IndexCurrentOrder := 0;
   with FDBFHandle do
   begin
      if IndexMaster <> nil then
      begin
         p := nil;
         n := 0;
         ni := 0;
         i := 1;
         while (p = nil) and (i <= IndexesAvail) do
         begin
            if IndexStack[i] <> nil then
            begin
               p := IndexStack[i].TagByNumber(ni);
               inc(ni);
               if p <> nil then
               begin
                  inc(n);
                  if StrComp(p.TagName,PrimaryTagName) <> 0 then
                     p := nil;
               end
               else
               begin
                  inc(i);
                  ni := 0;
               end;
            end;
         end;
         if p <> nil then
            IndexCurrentOrder := n;
      end;
   end;
end;

procedure TgsDBFTable.IndexIsProduction(tf: boolean);
begin
   CheckActive;
   if tf then
      FDBFHandle.IndexFlag := $01
   else
      FDBFHandle.IndexFlag := $00;
   FDBFHandle.WithIndex := tf;
   FDBFHandle.dStatus := Updated;
   FDBFHandle.gsHdrWrite;
end;

function TgsDBFTable.IndexKeyValue(Value: integer): string;
var
   expvar: TgsVariant;
begin
   Result := '';
   CheckActive;
   expvar := TgsVariant.Create(256);
   if FDBFHandle.gsIndexKeyValue(Value,expvar) then
      Result := expvar.GetString;
   expvar.Free;
end;


Function TgsDBFTable.IndexMaintained: boolean;
begin
   CheckActive;
   IndexMaintained := FDBFHandle.IndexFlag > 0;
end;

Function TgsDBFTable.LUpdate: string;
var
   fd: longint;
   td: TDateTime;
begin
   if FDBFHandle = nil then
      LUpdate := ''
   else
   begin
      fd := FileGetDate(FDBFHandle.FileHandle);
      td := FileDateToDateTime(fd);
      LUpdate := DateToStr(td);
   end;
end;

Function TgsDBFTable.MemoryIndexAdd(const tag, keyexpr, forexpr: String;
            uniq: gsIndexUnique; ascnd: gsSortStatus): boolean;
begin
   CheckActive;
   MemoryIndexAdd := FDBFHandle.gsMemoryIndexAdd(Tag, keyexpr, forexpr,
                      GSsetIndexUnique(uniq), GSsetSortStatus(ascnd));
end;


Procedure TgsDBFTable.Pack;
begin
   Post;
   FDBFHandle.gsPack;
end;

function TgsDBFTable.QueryHandler: TgsExpUserLink;
begin
   CheckActive;
   Result := FDBFHandle.DBFExpLink;
end;


Procedure TgsDBFTable.Recall;
begin
   if FDBFHandle = nil then exit;
   FDBFHandle.gsUndelete;
end;

Function TgsDBFTable.RecordCount : longint;
var
   rn: integer;
begin
  CheckActive;
  if FExactCount then
  begin
     Result := 0;
     rn := GetRecNo;
     FDBFHandle.gsGetRec(Top_Record);
     while not FDBFHandle.File_EOF do
     begin
        inc(Result);
        FDBFHandle.gsGetRec(Next_Record);
     end;
     FDBFHandle.gsGetRec(rn);
  end
  else
     Result := FDBFHandle.NumRecs;
end;

Function TgsDBFTable.RecSize : word;
begin
   CheckActive;
   RecSize := FDBFHandle.RecLen;
end;

Procedure TgsDBFTable.Reindex;
begin
   CheckActive;
   FDBFHandle.gsReindex;
end;

Function TgsDBFTable.RLock : boolean;
begin
   CheckActive;
   RLock := FDBFHandle.gsRLock;
end;

procedure TgsDBFTable.ReturnDateTimeUser(var dt, tm, us: longint);
begin
   dt := 0;
   tm := 0;
   us := 0;
   CheckActive;
   FDBFHandle.gsReturnDateTimeUser(dt, tm, us);
end;

Function TgsDBFTable.SearchDBF(const s: String; var FNum : word;
                   var fromrec: longint; torec: longint): word;
begin
   CheckActive;
   SearchDBF := FDBFHandle.gsSearchDBF(s,FNum,fromrec,torec);
end;

Procedure TgsDBFTable.SetDBFCacheAllowed(tf: boolean);
begin
   if FDBFHandle = nil then exit;
   FDBFHandle.gsSetDBFCacheAllowed(tf);
end;

Procedure TgsDBFTable.SetDBFCache(tf: boolean);
begin
   if FDBFHandle = nil then exit;
   if tf and (FDBFHandle.IndexMaster <> nil) then exit;
   FDBFHandle.gsSetDBFCache(tf);
end;

Procedure TgsDBFTable.SetFilterThru(UserRoutine : FilterCheck);
begin
   if not (FDBFHandle = nil) then exit;
   FDBFHandle.DBFFilter := UserRoutine;
end;

Procedure TgsDBFTable.SetLockProtocol(LokProtocol: gsLokProtocol);
begin
   if FDBFHandle <> nil then
      FDBFHandle.gsSetLockProtocol(GSsetLokProtocol(LokProtocol));
end;

Procedure TgsDBFTable.SetOrderTo(order : integer);
begin
   CheckActive;
   FDBFHandle.gsIndexOrder(order);
end;

Procedure TgsDBFTable.SetRange(const RLo, RHi: string);
begin
   CheckActive;
   FDBFHandle.gsSetRange(RLo,RHi,true,true,false);
end;

Procedure TgsDBFTable.SetRangeEx(const RLo, RHi: string; LoIn, HiIn, Partial: boolean);
begin
   CheckActive;
   FDBFHandle.gsSetRange(RLo,RHi,LoIn,HiIn,Partial);
end;

Procedure TgsDBFTable.SetStatusCapture(UserRoutine : CaptureStatus);
begin
   CheckActive;
   FDBFHandle.DBFStatus := UserRoutine;
end;

Procedure TgsDBFTable.SetTagTo(TName: string);
begin
   CheckActive;
   FDBFHandle.gsSetTagTo(TName,true);
end;

Procedure TgsDBFTable.SetUseDeleted(tf: boolean);
begin
   DBFUseDeleted := tf;
   if FDBFHandle <> nil then
      FDBFHandle.UseDeletedRec := tf;
end;

Procedure TgsDBFTable.SetAutoFlush(tf: boolean);
begin
   DBFAutoFlush := tf;
   if FDBFHandle <> nil then
      FDBFHandle.gsvAutoFlush := tf;
end;

Procedure TgsDBFTable.MoveBy(n : longint);
begin
   Post;
   FDBFHandle.gsSkip(n);
end;

Procedure TgsDBFTable.Next;
begin
   Post;
   FDBFHandle.gsGetRec(Next_Record);
end;

Procedure TgsDBFTable.Prior;
begin
   Post;
   FDBFHandle.gsGetRec(Prev_Record);
end;

Procedure TgsDBFTable.Refresh;
begin
   Cancel;
   FDBFHandle.gsGetRec(Same_Record);
end;

Procedure TgsDBFTable.SortTo(const filname, apassword, formla: string; sortseq : gsSortStatus);
begin
   CheckActive;
   FDBFHandle.gsSortFile(filname, apassword, formla, GSsetSortStatus(sortseq));
end;

Procedure TgsDBFTable.Unlock;
begin
   CheckActive;
   FDBFHandle.gsLockOff;
end;

Procedure TgsDBFTable.Zap;
begin
   CheckActive;
   FDBFHandle.gsZap;
end;


procedure TgsDBFTable.SetFilterData(const Text: string; Options: gsDBFFilterOptions);
begin
   if Active and Filtered then
   begin
      ConfirmBrowse;
      DBFHandle.gsSetFilterActive(true);
      DBFHandle.gsSetFilterExpr(Text, foCaseInsensitive in Options, not (foNoPartialCompare in Options));
      First;
   end;
end;

procedure TgsDBFTable.SetFilterText(const Value: string);
begin
  FFilterText := Value;
  SetFilterData(Value, FilterOptions);
end;

procedure TgsDBFTable.SetFilterOptions(Value: gsDBFFilterOptions);
begin
  FFilterOptions := Value;
  SetFilterData(Filter, Value);
end;

procedure TgsDBFTable.SetFiltered(Value: Boolean);
begin
   if Active then
   begin
      ConfirmBrowse;
      if Filtered <> Value then
      begin
         FFiltered := Value;
         DBFHandle.gsSetFilterActive(Value);
         if Value then
            SetFilterData(Filter,FilterOptions);
      end;
      First;
   end
   else
     FFiltered := Value;
end;



{------------------------------------------------------------------------------
                           Field Access Routines
------------------------------------------------------------------------------}

Function TgsDBFTable.MemoSize(fnam: string): longint;
begin
   CheckActive;
   MemoSize := FDBFHandle.gsMemoSize(fnam);
end;

Function TgsDBFTable.MemoSizeN(fnum: integer): longint;
begin
   CheckActive;
   MemoSizeN := FDBFHandle.gsMemoSizeN(fnum);
end;

Function TgsDBFTable.MemoSave(fnam: string;buf: PChar; var cb: longint): longint;
begin
   CheckActive;
   ConfirmEdit;
   MemoSave := FDBFHandle.gsMemoSave(fnam,buf,cb);
end;

Procedure TgsDBFTable.MemoLoad(fnam: string;buf: PChar; var cb: longint);
begin
   CheckActive;
   FDBFHandle.gsMemoLoad(fnam,buf,cb);
end;

Procedure  TgsDBFTable.MemoLoadN(fnum: integer;buf: PChar; var cb: longint);
begin
   CheckActive;
   FDBFHandle.gsMemoLoadN(fnum,buf,cb);
end;

Function   TgsDBFTable.MemoSaveN(fnum: integer;buf: PChar; var cb: longint): longint;
begin
   CheckActive;
   ConfirmEdit;
   MemoSaveN := FDBFHandle.gsMemoSaveN(fnum,buf,cb);
end;


Function TgsDBFTable.DateGet(st : string) : longint;
begin
   CheckActive;
   DateGet := FDBFHandle.gsDateGet(st);
end;

Function TgsDBFTable.DateGetN(n : integer) : longint;
begin
   CheckActive;
   DateGetN := FDBFHandle.gsDateGetN(n);
end;

Procedure TgsDBFTable.DatePut(st : string; jdte : longint);
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsDatePut(st, jdte);
end;

Procedure TgsDBFTable.DatePutN(n : integer; jdte : longint);
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsDatePutN(n, jdte);
end;

Function TgsDBFTable.FieldGet(fnam : string) : string;
begin
   CheckActive;
   FieldGet := FDBFHandle.gsFieldGet(fnam);
end;

Function TgsDBFTable.FieldGetN(fnum : integer) : string;
begin
   CheckActive;
   FieldGetN := FDBFHandle.gsFieldGetN(fnum);
end;

Procedure TgsDBFTable.FieldPut(fnam, st : string);
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsFieldPut(fnam, st);
end;

Procedure TgsDBFTable.FieldPutN(fnum : integer; st : string);
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsFieldPutN(fnum, st);
end;

Function TgsDBFTable.FloatGet(st : string) : FloatNum;
begin
   CheckActive;
   FloatGet := FDBFHandle.gsNumberGet(st);
end;

Function TgsDBFTable.FloatGetN(n : integer) : FloatNum;
begin
   CheckActive;
   FloatGetN := FDBFHandle.gsNumberGetN(n);
end;

Procedure TgsDBFTable.FloatPut(st : string; r : FloatNum);
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsNumberPut(st, r);
end;

Procedure TgsDBFTable.FloatPutN(n : integer; r : FloatNum);
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsNumberPutN(n, r);
end;

Function TgsDBFTable.LogicGet(st : string) : boolean;
begin
   CheckActive;
   LogicGet := FDBFHandle.gsLogicGet(st);
end;

Function TgsDBFTable.LogicGetN(n : integer) : boolean;
begin
   CheckActive;
   LogicGetN := FDBFHandle.gsLogicGetN(n);
end;

Procedure TgsDBFTable.LogicPut(st : string; b : boolean);
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsLogicPut(st, b);
end;

Procedure TgsDBFTable.LogicPutN(n : integer; b : boolean);
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsLogicPutN(n, b);
end;

Function TgsDBFTable.IntegerGet(st : string) : LongInt;
var
   r : FloatNum;
begin
   CheckActive;
   r := FDBFHandle.gsNumberGet(st);
   IntegerGet := Trunc(r);
end;

Function TgsDBFTable.IntegerGetN(n : integer) : LongInt;
var
   r : FloatNum;
begin
   CheckActive;
   r := FDBFHandle.gsNumberGetN(n);
   IntegerGetN := Trunc(r);
end;

Procedure TgsDBFTable.IntegerPut(st : string; i : LongInt);
var
   r : FloatNum;
begin
   CheckActive;
   ConfirmEdit;
   r := i;
   FDBFHandle.gsNumberPut(st, r);
end;

Procedure TgsDBFTable.IntegerPutN(n : integer; i : LongInt);
var
   r : FloatNum;
begin
   CheckActive;
   ConfirmEdit;
   r := i;
   FDBFHandle.gsNumberPutN(n, r);
end;

Function TgsDBFTable.StringGet(fnam : string) : string;
begin
   CheckActive;
   StringGet := FDBFHandle.gsStringGet(fnam);
end;

Function TgsDBFTable.StringGetN(fnum : integer) : string;
begin
   CheckActive;
   StringGetN := FDBFHandle.gsStringGetN(fnum);
end;

Procedure TgsDBFTable.StringPut(fnam, st : string);
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsStringPut(fnam, st);
end;

Procedure TgsDBFTable.StringPutN(fnum : integer; st : string);
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsStringPutN(fnum, st);
end;

Function TgsDBFTable.GetFileVersion: byte;
begin
   if FDBFHandle <> nil then
      Result := FDBFHandle.FileVers
   else
      Result := 0;
end;

procedure TgsDBFTable.RenameTable(const NewTableName: string);
begin
   CheckActive;
   DBFHandle.gsRename(NewTableName);
   DBFName := NewTableName;
end;

procedure TgsDBFTable.EncryptFile(const APassword: string);
begin
   CheckActive;
   DBFHandle.gsSetPassword(APassword);
end;

procedure TgsDBFTable.EncryptDBFFile(const APassword: string);
begin
   CheckActive;
   DBFHandle.gsSetPassword(APassword);
end;

{------------------------------------------------------------------------------
                           Setup and Exit Routines
------------------------------------------------------------------------------}

end.

