Unit gs6_disk;
{------------------------------------------------------------------------------
                               Disk File Handler

       gs6_disk Copyright (c) 1996 Griffin Solutions, Inc.

       Date
          4 Apr 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit handles the objects for all untyped disk file I/O.

------------------------------------------------------------------------------}
{$I gs6_flag.pas}
interface
uses
   SysHalc,
   SysUtils,
   gs6_glbl,
   gs6_eror,
   gs6_tool,
   gs6_date;

const
   GSwrdAccessMiliSeconds : word = 5000;
   GSwrdAccessMSecDelay: word = 50;

{private}
type

   GSO_DiskFile = Class(TObject)
   private
      dfFileHndl : integer;
      dfFileErr  : integer;       {I/O error code}
      dfFileExst : boolean;    {True if file exists}
      dfFileName : string;
      dfFilePosn : longint;
      dfFileShrd : boolean;
      dfReadWrite: boolean;
      dfGoodRec  : longint;
      dfLockRec  : Integer;
      dfLockPos  : Int64;
      dfLockLth  : Int64;
      dfHasWritten: boolean;
      dfClosed   : boolean;
      Function     InternalCloseFile: boolean;
   protected
      Function     gsCloseFile: boolean; virtual;
   public
      Constructor  Create(const Fname: String; ReadWrite, Shared: boolean);
      Destructor   Destroy; override;
      function     FileFullyLocked: boolean;
      Procedure    FoundError(Code, Info: integer; StP: string); virtual;
      Function     gsFileSize : longint; virtual;
      Procedure    gsFlush; virtual;
      Function     gsLockFile: Boolean; virtual;
      Function     gsLockRecord(FilePosition,FileLength: gsuint32): Boolean; virtual;
      Function     gsRead(blk: gsuint32; var dat; len: gsuint32): integer; virtual;
      Function     gsRename(const NewName: string): boolean; virtual;
      Procedure    gsReset; virtual;
      Procedure    gsReWrite; virtual;
      Procedure    gsStatusUpdate(stat1,stat2,stat3 : longint); virtual;
      Procedure    gsStatusLink(stat1,stat2,stat3 : longint);
      Procedure    gsTestForOk(Code, Info : integer);
      Procedure    gsTruncate(loc: gsuint32); virtual;
      Function     gsUnLock: boolean; virtual;
      Procedure    gsWrite(blk: gsuint32; var dat; len: gsuint32); virtual;
      Procedure    IncLockCount;
      Procedure    DecLockCount;
      Property     FileHandle: integer read dfFileHndl;
      Property     FileError: integer read dfFileErr write dfFileErr;
      Property     FileFound: boolean read dfFileExst;
      Property     FileShared: boolean read dfFileShrd;
      Property     FileReadWrite: boolean read dfReadWrite;
      Property     FileName: string read dfFileName;
      Property     FileExist: boolean read dfFileExst;
      Property     LockCount: integer read dfLockRec;
   end;

{------------------------------------------------------------------------------
                            IMPLEMENTATION SECTION
------------------------------------------------------------------------------}

implementation

type
   GSobjFileColl = class(TgsCollection)
      constructor Create;
      Destructor Destroy; override;
      procedure DeleteItem(Item: pointer);
      procedure FreeItem(Item: Pointer); override;
      function IndexOfItem(Item: Pointer): Integer;
      procedure InsertItem(Item: Pointer);
   end;

var
   FileList       : GSobjFileColl;

{$IFDEF HALCDEMO}
var
   exefh: integer;
   exedt: TDateTime;
   exefd: integer;
   exect: integer;

procedure DemoCheck;
begin
   if exect > 0 then exit;
   inc(exect);
   exefh := FileOpen(ParamStr(0),fmOpenRead+fmShareDenyNone);
   if exefh > 0 then
   begin
      exefd := FileGetDate(exefh);
      FileClose(exefh);
      exedt := FileDateToDateTime(exefd);
      if Date - exedt > 2 then
      begin
         {$IFDEF CONSOLE}
            raise EInOutError.Create('Unregistered Version of Halcyon 6.'+#13#10+
                                  'Contact Griffin Solutions at www.grifsolu.com');
         {$ELSE}
            gsSysMessageBox('Unregistered Version of Halcyon 6.'+#13#10+
                                  'Contact Griffin Solutions at www.grifsolu.com',
                                  'Unregistered',gsMB_OK);
         {$ENDIF}
      end;
   end;
end;
{$ENDIF}

{------------------------------------------------------------------------------
                              Global Routines
------------------------------------------------------------------------------}

Function GSGetExpandedFile(const FileName: String): String;
begin
   if (Pos('\\',Filename) <> 0) or (pos(':',FileName) > 2) then
     Result := FileName
   else
     Result := ExpandFileName(FileName);
end;

Procedure GS_CloseAllFiles;
var
   i    : integer;
   optr : GSO_DiskFile;
begin
   if (FileList <> nil) and (FileList.Count > 0) then
   begin
      try
         for i := 0 to FileList.Count-1 do
         begin
            optr :=  FileList.Items[i];
            with optr do
            begin
               if dfLockRec > 0 then
               begin
                  dfLockRec := 1;
                  gsSysUnLockFile(dfFileHndl,dfLockPos,dfLockLth);
               end;
               FileClose(dfFileHndl);
            end;
         end;
      finally
      end;
   end;
end;


{------------------------------------------------------------------------------
                              GSO_DiskFile
------------------------------------------------------------------------------}

Constructor GSO_DiskFile.Create(const Fname: String; ReadWrite, Shared: boolean);
var
   FNup : array[0..259] of char;
   Attr : integer;
begin
   {$IFDEF HALCDEMO}
   DemoCheck;
   {$ENDIF}
   inherited Create;
   StrPCopy(FNup,GSGetExpandedFile(Fname));
   gsBufUpperCase(FNup, StrLen(FNup));
   dfFileShrd := Shared;
   dfReadWrite := ReadWrite;
   dfFileName := StrNew(FNup);
   Attr := FileGetAttr(StrPas(FNup));
   dfFileExst := Attr >= 0;
   dfFilePosn := 0;
   dfFileHndl := 0;
   dfLockRec := 0;
   dfHasWritten := false;
   dfClosed := true;
end;

destructor GSO_DiskFile.Destroy;
begin
   gsCloseFile;
   inherited Destroy;
end;

function GSO_DiskFile.FileFullyLocked: boolean;
begin
   Result := not dfFileShrd;
   if not Result then
      if (dfLockRec > 0) and (dfLockPos = 0) and (dfLockLth = MaxRecNum) then
         Result := true;
end;
Procedure GSO_DiskFile.FoundError(Code, Info:integer; StP: string);
begin
   FoundPgmError(Code,Info,StP);
end;

Function GSO_DiskFile.InternalCloseFile: boolean;
begin
   if not dfClosed then
   begin
      if dfLockRec > 0 then
      begin
         dfLockRec := 1;       {set lock count to 1 to force unlock}
         gsUnLock;
      end;
      dfFileErr := 0;
      if (FileList <> nil) and (FileList.IndexOfItem(Self) <> -1) then
         FileList.DeleteItem(Self);
      FileClose(dfFileHndl);
      dfClosed := true;
      dfFilePosn := 0;
      dfFileHndl := 0;
   end;
   Result := true;
end;

Function GSO_DiskFile.gsCloseFile: boolean;
begin
   Result := InternalCloseFile;
end;

Function GSO_DiskFile.gsFileSize : longint;
var
   fs: longint;
begin
   fs := FileSeek(dfFileHndl,0,2);
   if fs = -1 then
      dfFileErr := gsSysGetLastError
   else
      dfFileErr := 0;
   gsTestForOK(dfFileErr,dskFileSizeError);
   gsFileSize := fs;
end;

Procedure GSO_DiskFile.gsFlush;
begin
   if dfClosed then exit;
   if gsSysFlushFileBuffers(dfFileHndl) then
      dfFileErr := 0
   else
      dfFileErr := gsSysGetLastError;
   dfHasWritten := false;
   gsTestForOk(dfFileErr,dskFlushError);
end;

Function GSO_DiskFile.gsLockFile : Boolean;
begin
   if dfFileShrd then
      gsLockFile :=  gsLockRecord(0,MaxRecNum)
   else
      gsLockFile := true;
end;

Function GSO_DiskFile.gsLockRecord(FilePosition,FileLength: gsuint32): boolean;
begin
   if (not dfFileShrd) then
   begin                        {do dummy File Lock if not shared}
      dfFileErr := 0;
      inc(dfLockRec);
      dfLockPos := FilePosition;
      dfLockLth := FileLength;
   end
   else
   begin
      if dfLockRec > 0 then    {if already locked see if same region}
      begin
         if (FilePosition = dfLockPos) and (FileLength = dfLockLth) then
         begin
            dfFileErr := 0;
            inc(dfLockRec);
         end
         else
            dfFileErr := dosLockViolated;
      end
      else
      begin
         dfLockPos := FilePosition;
         dfLockLth := FileLength;
         if gsSysLockFile(dfFileHndl,dfLockPos,dfLockLth) then
         begin
            dfFileErr := 0;
            inc(dfLockRec);
         end
         else
            dfFileErr := gsSysGetLastError;
      end;
   end;
   gsLockRecord := dfFileErr = 0;
end;

Function GSO_DiskFile.gsRead(blk: gsuint32; var dat; len: gsuint32): integer;
var
   fs: longint;
   Count: integer;
begin
   Count := len;
   fs := FileSeek(dfFileHndl, blk, 0);
   IF fs <> -1 THEN               {If seek ok, read the record}
   BEGIN
      dfFileErr := 0;
      dfGoodRec := FileRead(dfFileHndl, dat, Count);
      if dfGoodRec = -1 then
         dfFileErr := gsSysGetLastError;
      if dfFileErr = 0 then dfFilePosn := (blk+len);
   end
   else
      dfFileErr := gssysGetLastError;
   gsTestForOk(dfFileErr,dskReadError);
   if dfGoodRec < Count then
   begin
      dfFileErr := gsShortDiskRead;
   end;
   gsRead := dfGoodRec;
end;

Function GSO_DiskFile.gsRename(const NewName: string): boolean;
var
   filenew: string;
   realerr: integer;
begin
   dfFileErr := 0;
   realerr := 0;
   Result := InternalCloseFile;
   if Result then
   begin
      filenew := GSGetExpandedFile(NewName);
      Result := RenameFile(dfFileName,filenew);
      if not Result then
         realerr := gsSysGetLastError
      else
         dfFileName := AnsiUpperCase(FileNew);
      gsReset;
   end
   else realerr := dosFileNotAssgd;
   if realerr <> 0 then dfFileErr := realerr;
   gsTestForOK(dfFileErr,dskRenameError);
end;


Procedure GSO_DiskFile.gsReset;
var
   WrkMode : byte;
begin
   dfFileErr := 0;
   WrkMode := 0;
   if dfReadWrite then WrkMode := WrkMode + fmOpenReadWrite;
   if dfFileShrd then WrkMode := WrkMode + fmShareDenyNone;
   dfFileHndl := FileOpen(dfFileName,WrkMode);
   if dfFileHndl = -1 then
      dfFileErr := gsSysGetLastError;
   if dfFileErr = 0 then
   begin
      dfFilePosn := 0;
      if FileList = nil then
         FileList := GSobjFileColl.Create;
      FileList.InsertItem(Self);
      dfClosed := false;
   end;
   gsTestForOK(dfFileErr,dskResetError);
end;

Procedure GSO_DiskFile.gsReWrite;
begin
   dfFileHndl := FileCreate(dfFileName);
   if dfFileHndl <> -1 then
   begin
      FileClose(dfFileHndl);
      gsReset;
      dfFileErr := 0;
   end
   else
      dfFileErr := gsSysGetLastError;
   gsTestForOk(dfFileErr,dskRewriteError);
end;

Procedure GSO_DiskFile.gsStatusUpdate(stat1,stat2,stat3 : longint);
begin
end;

Procedure GSO_DiskFile.gsStatusLink(stat1,stat2,stat3 : longint);
begin
   gsStatusUpdate(stat1,stat2,stat3);
end;

Procedure GSO_DiskFile.gsTestForOk(Code, Info : integer);
begin
   if Code <> 0 then
   begin
      gsSysSetLastError(Code);
      FoundError(Code,Info,dfFileName);
   end;
end;

Procedure GSO_DiskFile.gsTruncate(loc: gsuint32);
var
   cloc: longint;
begin
   dfFileErr := 0;
   if (not dfReadWrite) or (not FileFullyLocked) then
      dfFileErr := dosAccessDenied
   else
   begin
      cloc := FileSeek(dfFileHndl, loc, 0);
      if cloc <> -1 then
         if gsSysSetEndOfFile(dfFileHndl) then
            dfFileErr := 0
         else
            dfFileErr := gsSysGetLastError;
   end;
   gsTestForOk(dfFileErr,dskTruncateError);
end;

Function GSO_DiskFile.gsUnLock: boolean;
begin
   dfFileErr := 0;
   if dfLockRec > 0 then
   begin
      if dfFileShrd and (dfLockRec = 1) then
         if not gsSysUnLockFile(dfFileHndl,dfLockPos,dfLockLth) then
            dfFileErr := gsSysGetLastError;
      if dfFileErr = 0 then dec(dfLockRec);
   end;
   gsUnLock := dfFileErr = 0;
end;

Procedure GSO_DiskFile.gsWrite(blk: gsuint32; var dat; len: gsuint32);
var
   fs: longint;
begin
   fs := FileSeek(dfFileHndl, blk, 0);
   IF fs <> -1 then               {If seek ok, read the record}
   begin
      dfFileErr := 0;
      dfGoodRec := FileWrite(dfFileHndl, dat, len);
      if dfGoodRec = -1 then
         dfFileErr := gsSysGetLastError;
      if dfFileErr = 0 then dfFilePosn := (blk+len);
   end
   else
      dfFileErr := gsSysGetLastError;
   if dfFileErr = 0 then
   begin
      dfHasWritten := true;
   end;
   gsTestForOk(dfFileErr,dskWriteError);
end;

Procedure GSO_DiskFile.IncLockCount;
begin
   inc(dfLockRec);
end;

Procedure GSO_DiskFile.DecLockCount;
begin
   gsUnlock;
end;


{------------------------------------------------------------------------------
                               GSobjFileColl
------------------------------------------------------------------------------}

constructor GSobjFileColl.Create;
begin
   inherited Create;
end;

destructor GSobjFileColl.Destroy;
begin
   inherited Destroy;
end;

procedure GSobjFileColl.DeleteItem(Item: pointer);
begin
   inherited Delete(IndexOf(Item));
end;

procedure GSobjFileColl.FreeItem(Item: Pointer);
begin
end;

function GSobjFileColl.IndexOfItem(Item: Pointer): Integer;
begin
   Result := IndexOf(Item);
end;

procedure GSobjFileColl.InsertItem(Item: pointer);
begin
   Add(Item);
end;


{------------------------------------------------------------------------------
                           Setup and Exit Routines
------------------------------------------------------------------------------}

initialization
   FileList := GSobjFileColl.Create;
   {$IFDEF HALCNDEMO}
   exect := 0;
   {$ENDIF}
finalization
begin
   GS_CloseAllFiles;
   if FileList <> nil then
      FileList.Free;
end;

end.
