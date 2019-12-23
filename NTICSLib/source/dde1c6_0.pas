unit dde1c6_0;
interface
{$IFDEF DLL} uses SysUtils,DDEMan; {$ENDIF}

function Initialize(Year,Period:integer):integer;stdcall;{$IFNDEF DLL} external 'Lib1C6_0DDE.dll'; {$ENDIF}
function ExecuteScript(Script:pchar;var ReturnValue:pchar):integer;stdcall;{$IFNDEF DLL} external 'Lib1C6_0DDE.dll'; {$ENDIF}
function CloseDDE:integer;stdcall;{$IFNDEF DLL} external 'Lib1C6_0DDE.dll'; {$ENDIF}

implementation
{$IFDEF DLL}
var
  Fdde:TDdeClientConv;
  IfConnect:boolean;
  CurrentYear:integer;
  CurrentPeriod:integer;

function Initialize(Year,Period:integer):integer;
begin
  CurrentYear:=Year;
  CurrentPeriod:=Period;
  if not IfConnect then
  begin
    FDde:=TDdeClientConv.Create(nil);
    FDde.ConnectMode:=ddeManual;
    if (not FDde.SetLink('¡”’','¬€–')) or (not FDde.OpenLink) then
      Fdde.Free
    else IfConnect:=True;
  end;
  Result:=integer(IfConnect);
end;

function CloseDDE:integer;
begin
  if IfConnect then
    Fdde.Free;
  IfConnect:=False;
  Result:=integer(IfConnect);
end;

function ExecuteScript(Script:pchar;var ReturnValue:pchar):integer;
var
  s:string;

function ifelse(tf:boolean;arg1,arg2:string):string;
begin
  if tf then Result:=arg1 else Result:=arg2;
end;

function CurrentYearShort: string;
var
  i:integer;
begin
  i:=0;
  while i<CurrentYear do inc(i,100);
  Result:=IntToStr(CurrentYear-(i-100));
  if Length(Result)<2 then
    Result:='0'+Result;
end;

function PredCurrentYearShort: string;
var
  i:integer;
begin
  i:=0;
  while i<(CurrentYear-1) do inc(i,100);
  Result:=IntToStr(CurrentYear-(i-100)-1);
  if Length(Result)<2 then
    Result:='0'+Result;
end;

begin
  if IfConnect then
  begin
    s:=Script;
    // Ã‡ÍÓÔÓ‰ÒÚ‡ÌÓ‚ÍË ************
    s:=StringReplace(s,'$√ ¬6.0','√'+CurrentYearShort()+'; ¬'+inttostr(CurrentPeriod),[rfReplaceAll]);
    s:=StringReplace(s,'$√ Ã1_6.0','√'+CurrentYearShort+';Ã'+inttostr(CurrentPeriod*3-2),[rfReplaceAll]);
    s:=StringReplace(s,'$√ Ã2_6.0','√'+CurrentYearShort+';Ã'+inttostr(CurrentPeriod*3-1),[rfReplaceAll]);
    s:=StringReplace(s,'$√ Ã3_6.0','√'+CurrentYearShort+';Ã'+inttostr(CurrentPeriod*3-2),[rfReplaceAll]);
    s:=StringReplace(s,'$√Ã1_6.0','√'+CurrentYearShort+';Ã1',[rfReplaceAll]);
    s:=StringReplace(s,'$√Ã2_6.0','√'+CurrentYearShort+';Ã2',[rfReplaceAll]);
    s:=StringReplace(s,'$√Ã3_6.0','√'+CurrentYearShort+';Ã3',[rfReplaceAll]);
    s:=StringReplace(s,'$√Ã4_6.0','√'+CurrentYearShort+';Ã4',[rfReplaceAll]);
    s:=StringReplace(s,'$√Ã5_6.0','√'+CurrentYearShort+';Ã5',[rfReplaceAll]);
    s:=StringReplace(s,'$√Ã6_6.0','√'+CurrentYearShort+';Ã6',[rfReplaceAll]);
    s:=StringReplace(s,'$√Ã7_6.0','√'+CurrentYearShort+';Ã7',[rfReplaceAll]);
    s:=StringReplace(s,'$√Ã8_6.0','√'+CurrentYearShort+';Ã8',[rfReplaceAll]);
    s:=StringReplace(s,'$√Ã9_6.0','√'+CurrentYearShort+';Ã9',[rfReplaceAll]);
    s:=StringReplace(s,'$√Ã10_6.0','√'+CurrentYearShort+';Ã10',[rfReplaceAll]);
    s:=StringReplace(s,'$√Ã11_6.0','√'+CurrentYearShort+';Ã11',[rfReplaceAll]);
    s:=StringReplace(s,'$√Ã12_6.0','√'+CurrentYearShort+';Ã12',[rfReplaceAll]);
    s:=StringReplace(s,'$√Ãœ_6.0',ifelse(CurrentPeriod=1,
                     '√'+PredCurrentYearShort+';Ã12',
                     '√'+CurrentYearShort+';Ã'+inttostr(CurrentPeriod*3-3)),[rfReplaceAll]);
    s:=StringReplace(s,'$√2',CurrentYearShort,[rfReplaceAll]);
    s:=StringReplace(s,'$ ¬',inttostr(CurrentPeriod),[rfReplaceAll]);

    ReturnValue:=Fdde.RequestData(s);
    Result:=Integer(True);
  end else
    Result:=integer(False);
end;
{$ENDIF}
end.
