unit SysHalc;
{-----------------------------------------------------------------------------
                          OS Unique Code

       SysHalc Copyright 2000 (c) Griffin Solutions, Inc.

       20 July 2000

          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl                    web: www.grifsolu.com
          Warner Robins, GA  31088

      -------------------------------------------------------------
      This unit handles operating system-specific calls to allow changing
      between Windows, Linux, and any other environment that Borland creates
      a Delphi compiler. Most translations occur in SysUtils.  This unit is
      any other necessary commands.

      Changes:

------------------------------------------------------------------------------}
{$I gs6_flag.pas}
interface
uses
   {$IFDEF WIN32}
      Windows,
   {$ENDIF}
   SysUtils,
   gs6_glbl;


const
   gsIDOK = IDOK;
   gsID_OK = IDOK;
   gsMB_OK = MB_OK;
   gsLB_ERR = LB_ERR;

   {$IFDEF VER100}
   Type
      Int64 = Comp;
      Int64Rec = packed record
         Lo, Hi: Cardinal;
      end;   
   {$ENDIF}

function gsSysMessageBox(const Text, Caption: String; Flags: Longint): Integer;

function gsStrLowerCase(Str: string): string;
function gsStrUpperCase(Str: string): string;
procedure gsBufLowerCase(Str: PChar; Len: integer);
procedure gsBufUpperCase(Str: PChar; Len: integer);
function gsChrLowerCase(Str: char): char;
function gsChrUpperCase(Str: char): char;
procedure gsSysOEMToChar(NativeStr, AnsiStr: PChar; MaxLen: longint);
procedure gsSysCharToOEM(AnsiStr, NativeStr: PChar; MaxLen: longint);

function gsSysSpawn(const CmdLine: string; Visibility : integer): integer;
function gsSysSpawnAndWait(const CmdLine: string; Visibility : integer): integer;

procedure gsSysSleep(MS: integer);

Function gsSysLockFile(Handle: Integer; Position, Length: Int64): Boolean;
Function gsSysUnlockFile(Handle: Integer; Position, Length: Int64): Boolean;
Function gsSysFlushFileBuffers(Handle: Integer): Boolean;
Function gsSysSetEndOfFile(Handle: Integer): Boolean;
Function gsSysGetLastError: Integer;
Procedure gsSysSetLastError(Code: Integer);

function gsSysRootDirectory: string;


implementation

function gsSysMessageBox(const Text, Caption: String; Flags: Longint): Integer;
begin
   Result := MessageBox(0,PChar(Text),PChar(Caption),Flags);
end;


function gsStrLowerCase(Str: string): string;
begin
   Result := AnsiLowerCase(Str);
end;

function gsStrUpperCase(Str: string): string;
begin
   Result := AnsiUpperCase(Str);
end;

procedure gsBufLowerCase(Str: PChar; Len: integer);
begin
   CharLowerBuff(Str,Len);
end;

procedure gsBufUpperCase(Str: PChar; Len: integer);
begin
   CharUpperBuff(Str,Len);
end;

function gsChrLowerCase(Str: char): char;
var
   ch: integer;
begin
   ch := ord(Str);
   CharLower(PChar(ch));
   Result := char(ch);
end;

function gsChrUpperCase(Str: char): char;
var
   ch: integer;
begin
   ch := ord(Str);
   CharUpper(PChar(ch));
   Result := char(ch);
end;

procedure gsSysCharToOEM(AnsiStr, NativeStr: PChar; MaxLen: longint);
begin
   CharToOEMBuff(AnsiStr,NativeStr,MaxLen);
end;

procedure gsSysOEMToChar(NativeStr, AnsiStr: PChar; MaxLen: longint);
begin
   OEMToCharBuff(NativeStr,AnsiStr,MaxLen);
end;


function gsSysSpawn(const CmdLine: string; Visibility : integer): integer;
var
   zCmdLine:array[0..512] of char;
   zCurDir:array[0..255] of char;
   WorkDir:String;
   StartupInfo:TStartupInfo;
   ProcessInfo:TProcessInformation;
   r: DWord;
begin
   StrPCopy(zCmdLine,CmdLine);
   GetDir(0,WorkDir);
   StrPCopy(zCurDir,WorkDir);
   FillChar(StartupInfo,Sizeof(StartupInfo),#0);
   StartupInfo.cb := Sizeof(StartupInfo);
   StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
   StartupInfo.wShowWindow := Visibility;
   if not CreateProcess(
      nil,
      zCmdLine,                      { pointer to command line string }
      nil,                           { pointer to process security attributes}
      nil,                           { pointer to thread security attributes }
      false,                         { handle inheritance flag }
      CREATE_NEW_CONSOLE or          { creation flags }
      NORMAL_PRIORITY_CLASS,
      nil,                           { pointer to new environment block }
      nil,                           { pointer to current directory name }
      StartupInfo,                   { pointer to STARTUPINFO }
      ProcessInfo) then Result := -1 { pointer to PROCESS_INF }
   else
   begin
      CloseHandle(ProcessInfo.hThread);
      WaitforSingleObject(ProcessInfo.hProcess,INFINITE);
      CloseHandle(ProcessInfo.hProcess);
      GetExitCodeProcess(ProcessInfo.hProcess,r);
      Result := r;
   end;
end;

function gsSysSpawnAndWait(const CmdLine: string; Visibility : integer): integer;
var
   zCmdLine:array[0..512] of char;
   zCurDir:array[0..255] of char;
   WorkDir:String;
   StartupInfo:TStartupInfo;
   ProcessInfo:TProcessInformation;
   ProcBool: Bool;
begin
   StrPCopy(zCmdLine,CmdLine);
   GetDir(0,WorkDir);
   StrPCopy(zCurDir,WorkDir);
   FillChar(StartupInfo,Sizeof(StartupInfo),#0);
   StartupInfo.cb := Sizeof(StartupInfo);
   StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
   StartupInfo.wShowWindow := Visibility;
   ProcBool := CreateProcess(
      nil,
      zCmdLine,                      { pointer to command line string }
      nil,                           { pointer to process security attributes}
      nil,                           { pointer to thread security attributes }
      false,                         { handle inheritance flag }
      DETACHED_PROCESS or          { creation flags }
{      CREATE_NO_WINDOW or}
      NORMAL_PRIORITY_CLASS,
      nil,                           { pointer to new environment block }
      nil,                           { pointer to current directory name }
      StartupInfo,                   { pointer to STARTUPINFO }
      ProcessInfo);
   if ProcBool then
   begin
      Result := 0;
      CloseHandle(ProcessInfo.hThread);
      CloseHandle(ProcessInfo.hProcess);
   end
   else
      Result := abs(GetLastError);
end;

procedure gsSysSleep(MS: integer);
begin
   Sleep(MS);
end;

Function gsSysLockFile(Handle: Integer; Position, Length: Int64): Boolean;
begin
   Result := Windows.LockFile(Handle,Int64Rec(Position).Lo,Int64Rec(Position).Hi,
                                Int64Rec(Length).Lo,Int64Rec(Length).Hi);
end;

Function gsSysUnlockFile(Handle: Integer; Position, Length: Int64): Boolean;
begin
   Result := Windows.UnLockFile(Handle,Int64Rec(Position).Lo,Int64Rec(Position).Hi,
                                Int64Rec(Length).Lo,Int64Rec(Length).Hi);
end;

Function gsSysGetLastError: Integer;
begin
   Result := Windows.GetLastError;
end;

Function gsSysFlushFileBuffers(Handle: Integer): Boolean;
begin
   Result := Windows.FlushFileBuffers(Handle);
end;

Procedure gsSysSetLastError(Code: Integer);
begin
   Windows.SetLastError(Code);
end;

Function gsSysSetEndOfFile(Handle: Integer): Boolean;
begin
   Result := Windows.SetEndOfFile(Handle);
end;


function gsSysRootDirectory: string;
var
   WindowDirectory: array[0..MAX_PATH] of char;
begin
   GetWindowsDirectory(WindowDirectory, MAX_PATH);
   Result := StrPas(WindowDirectory);
end;

Function SetFilePointer(Handle: Integer; const Offset: Int64; Origin: Integer;
                        var NewPos: Int64): Boolean;
begin
  NewPos := Offset;
  Int64Rec(NewPos).Lo := Windows.SetFilePointer(Handle, Int64Rec(NewPos).Lo,
                           @Int64Rec(NewPos).Hi, Origin);

  Result := (Int64Rec(NewPos).Lo <> $FFFFFFFF) or (Windows.GetLastError = NO_ERROR);
end;

Function FirstUpChar(chprev, ch: char): char;
var
   cha: array[0..1] of char;
begin
   cha[0] := ch;
   if chprev in [#0,#$20..#$26,#$28..#$2F,#$3A..#$40,#$5B..#$5F,#$7B..#$7F] then
      CharUpperBuff(@cha,1);
   FirstUpChar := cha[0];
end;


end.
