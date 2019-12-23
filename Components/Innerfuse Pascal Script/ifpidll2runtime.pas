{
@abstract(Runtime DLL importing support)
@author(Carlo Kok <ck@carlo-kok.com>)
}
unit ifpidll2runtime;

{$I ifps3_def.inc}
interface
uses
  ifps3, ifps3utl;
{Register the dll runtime library}
procedure RegisterDLLRuntime(Caller: TIFPSExec);
{Process a dll import (no need to call this function)}
function ProcessDllImport(Caller: TIFPSExec; P: TIFExternalProcRec): Boolean;

implementation
uses
  {$IFDEF LINUX}
  LibC;
  {$ELSE}
  Windows;
  {$ENDIF}

{
p^.Ext1 contains the pointer to the Proc function
p^.ExportDecl:
  'dll:'+DllName+#0+FunctionName+#0+chr(Cc)+VarParams
}

type
  PLoadedDll = ^TLoadedDll;
  TLoadedDll = record
    dllnamehash: Longint;
    dllname: string;
    {$IFDEF LINUX}
    dllhandle: Pointer;
    {$ELSE}
    dllhandle: THandle;
    {$ENDIF}
  end;
  TMyExec = class(TIFPSExec);


procedure DllFree(Sender: TIFPSExec; P: PLoadedDll);
begin
  {$IFDEF LINUX}
  dlclose(p^.dllhandle);
  {$ELSE}
  FreeLibrary(p^.dllhandle);
  {$ENDIF}
  Dispose(p);
end;



function DllProc(Caller: TIFPSExec; p: TIFExternalProcRec; Global, Stack: TIFPSStack): Boolean;

var
  i: Integer;
  MyList: TIfList;
  n: PIFPSVariantIFC;
  CurrStack: Cardinal;
  cc: TIFPSCallingConvention;
  s: string;
begin
  s := p.Decl;
  delete(S, 1, pos(#0, s));
  delete(S, 1, pos(#0, s));
  if length(S) < 2 then
  begin
    Result := False;
    exit;
  end;
  cc := TIFPSCallingConvention(s[1]);
  delete(s, 1, 1);
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
    n := NewPIFPSVariantIFC(Stack[CurrStack], true);
  end else n := nil;
  try
    TMYExec(Caller).InnerfuseCall(nil, p.Ext1, cc, MyList, n);
    result := true;
  except
    result := false;
  end;
  DisposePIFPSvariantIFC(n);
  DisposePIFPSVariantIFCList(MyList);
end;

function ProcessDllImport(Caller: TIFPSExec; P: TIFExternalProcRec): Boolean;
var
  s, s2: string;
  h, i: Longint;
  ph: PLoadedDll;
  {$IFDEF LINUX}
  dllhandle: Pointer;
  {$ELSE}
  dllhandle: THandle;
  {$ENDIF}
begin
  s := p.Decl;
  Delete(s, 1, 4);
  s2 := copy(s, 1, pos(#0, s)-1);
  delete(s, 1, length(s2)+1);
  h := makehash(s2);
  i := 2147483647; // maxint
  dllhandle := 0;
  repeat
    ph := Caller.FindProcResource2(@dllFree, i);
    if i = -1 then
    begin
      {$IFDEF LINUX}
      dllhandle := dlopen(PChar(s2), RTLD_LAZY);
      {$ELSE}
      dllhandle := LoadLibrary(Pchar(s2));
      {$ENDIF}
      if dllhandle = {$IFDEF LINUX}nil{$ELSE}0{$ENDIF}then
      begin
        Result := False;
        exit;
      end;
      new(ph);
      ph^.dllnamehash := h;
      ph^.dllname := s2;
      ph^.dllhandle := dllhandle;
      Caller.AddResource(@DllFree, ph);
    end;
    if (ph^.dllnamehash = h) and (ph^.dllname = s2) then
    begin
      dllhandle := ph^.dllhandle;
    end;
    dec(i);
  until dllhandle <> {$IFDEF LINUX}nil{$ELSE}0{$ENDIF};
  {$IFDEF LINUX}
  p.Ext1 := dlsym(dllhandle, pchar(copy(s, 1, pos(#0, s)-1)));
  {$ELSE}
  p.Ext1 := GetProcAddress(dllhandle, pchar(copy(s, 1, pos(#0, s)-1)));
  {$ENDIF}
  p.ProcPtr := DllProc;
  Result := p.Ext1 <> nil;
end;

procedure RegisterDLLRuntime(Caller: TIFPSExec);
begin
  Caller.AddSpecialProcImport('dll', @ProcessDllImport, nil);
end;
end.
