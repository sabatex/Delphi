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
    if (not FDde.SetLink('���','���')) or (not FDde.OpenLink) then
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
    // ���������������� ************
    s:=StringReplace(s,'$���6.0','�'+CurrentYearShort()+';��'+inttostr(CurrentPeriod),[rfReplaceAll]);
    s:=StringReplace(s,'$���1_6.0','�'+CurrentYearShort+';�'+inttostr(CurrentPeriod*3-2),[rfReplaceAll]);
    s:=StringReplace(s,'$���2_6.0','�'+CurrentYearShort+';�'+inttostr(CurrentPeriod*3-1),[rfReplaceAll]);
    s:=StringReplace(s,'$���3_6.0','�'+CurrentYearShort+';�'+inttostr(CurrentPeriod*3-2),[rfReplaceAll]);
    s:=StringReplace(s,'$��1_6.0','�'+CurrentYearShort+';�1',[rfReplaceAll]);
    s:=StringReplace(s,'$��2_6.0','�'+CurrentYearShort+';�2',[rfReplaceAll]);
    s:=StringReplace(s,'$��3_6.0','�'+CurrentYearShort+';�3',[rfReplaceAll]);
    s:=StringReplace(s,'$��4_6.0','�'+CurrentYearShort+';�4',[rfReplaceAll]);
    s:=StringReplace(s,'$��5_6.0','�'+CurrentYearShort+';�5',[rfReplaceAll]);
    s:=StringReplace(s,'$��6_6.0','�'+CurrentYearShort+';�6',[rfReplaceAll]);
    s:=StringReplace(s,'$��7_6.0','�'+CurrentYearShort+';�7',[rfReplaceAll]);
    s:=StringReplace(s,'$��8_6.0','�'+CurrentYearShort+';�8',[rfReplaceAll]);
    s:=StringReplace(s,'$��9_6.0','�'+CurrentYearShort+';�9',[rfReplaceAll]);
    s:=StringReplace(s,'$��10_6.0','�'+CurrentYearShort+';�10',[rfReplaceAll]);
    s:=StringReplace(s,'$��11_6.0','�'+CurrentYearShort+';�11',[rfReplaceAll]);
    s:=StringReplace(s,'$��12_6.0','�'+CurrentYearShort+';�12',[rfReplaceAll]);
    s:=StringReplace(s,'$���_6.0',ifelse(CurrentPeriod=1,
                     '�'+PredCurrentYearShort+';�12',
                     '�'+CurrentYearShort+';�'+inttostr(CurrentPeriod*3-3)),[rfReplaceAll]);
    s:=StringReplace(s,'$�2',CurrentYearShort,[rfReplaceAll]);
    s:=StringReplace(s,'$��',inttostr(CurrentPeriod),[rfReplaceAll]);

    ReturnValue:=Fdde.RequestData(s);
    Result:=Integer(True);
  end else
    Result:=integer(False);
end;
{$ENDIF}
end.
