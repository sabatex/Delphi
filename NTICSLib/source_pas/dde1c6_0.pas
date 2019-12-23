unit dde1c6_0;
interface
uses SysUtils,DDEMan;
type
  TDDE1C6_0=class(TObject)
  private
    FConnect:boolean;
    FDDE:TDdeClientConv;
    FYear:integer;
    FKvartal:integer;
    FMounth:integer;
    procedure SetYear(const Value: integer);
    procedure SetKvartal(const Value: integer);
    procedure SetMounth(const Value: integer);
    function GetConnect: boolean;
    function ifelse(tf:boolean;arg1,arg2:string):string;
    function CurrentYearShort: string;
    function PredCurrentYearShort: string;
  public
    property Year:integer read FYear write SetYear;
    property Kvartal:integer read FKvartal write SetKvartal;
    property Mounth:integer read FMounth write SetMounth;
    property IsConnect:boolean read GetConnect;
    function ExecuteScript(Script:string):String;
    constructor Create;
    destructor Destroy;override;
  end;

function Date1C(Value: string): TDateTime;

implementation
{ TDDE1C6_0 }

function Date1C(Value: string): TDateTime;
begin
  Value:=Trim(Value);
  Result:=StrToDateTime('01.01.1900');
  TwoDigitYearCenturyWindow:=90;
  if Value='' then Exit;
 {$D-}
  try
    Result:=StrToDate(Value);
  except
    try
      Value:=StringReplace(Value,',','.',[rfReplaceAll]);
      Result:=StrToDate(Value);
    except
      try
       delete(Value,pos(',',Value),3);
       if Length(Value)=7 then Value:='0'+Value;
       if Length(Value)<> 8 then
         Result:=StrToDateTime('01.01.1900')
       else
         Result:=StrToDate(copy(Value,1,2)+'.'+copy(Value,3,2)+'.'+copy(Value,5,4));
      except
        Result:=StrToDateTime('01.01.1900');
      end;
    end;
  end;
 {$D+}
end;



constructor TDDE1C6_0.Create;
begin
  FConnect:=False;
  GetConnect;
end;

function TDDE1C6_0.CurrentYearShort: string;
var
  i:integer;
begin
  i:=0;
  while i<FYear do inc(i,100);
  Result:=IntToStr(FYear-(i-100));
  if Length(Result)<2 then
    Result:='0'+Result;
end;

destructor TDDE1C6_0.Destroy;
begin
  if FConnect then FDDE.Free;
  inherited;
end;

function TDDE1C6_0.ExecuteScript(Script: string): String;
var
  s:string;
begin
  if IsConnect then
  begin
    s:=Script;
    // Ìàêðîïîäñòàíîâêè ************
    s:=StringReplace(s,'$ÃÊÂ6.0','Ã'+CurrentYearShort()+';ÊÂ'+inttostr(Kvartal),[rfReplaceAll]);
    s:=StringReplace(s,'$ÃÊÌ1_6.0','Ã'+CurrentYearShort()+';Ì'+inttostr(Kvartal*3-2),[rfReplaceAll]);
    s:=StringReplace(s,'$ÃÊÌ2_6.0','Ã'+CurrentYearShort+';Ì'+inttostr(Kvartal*3-1),[rfReplaceAll]);
    s:=StringReplace(s,'$ÃÊÌ3_6.0','Ã'+CurrentYearShort+';Ì'+inttostr(Kvartal*3-2),[rfReplaceAll]);
    s:=StringReplace(s,'$ÃÌ1_6.0','Ã'+CurrentYearShort+';Ì1',[rfReplaceAll]);
    s:=StringReplace(s,'$ÃÌ2_6.0','Ã'+CurrentYearShort+';Ì2',[rfReplaceAll]);
    s:=StringReplace(s,'$ÃÌ3_6.0','Ã'+CurrentYearShort+';Ì3',[rfReplaceAll]);
    s:=StringReplace(s,'$ÃÌ4_6.0','Ã'+CurrentYearShort+';Ì4',[rfReplaceAll]);
    s:=StringReplace(s,'$ÃÌ5_6.0','Ã'+CurrentYearShort+';Ì5',[rfReplaceAll]);
    s:=StringReplace(s,'$ÃÌ6_6.0','Ã'+CurrentYearShort+';Ì6',[rfReplaceAll]);
    s:=StringReplace(s,'$ÃÌ7_6.0','Ã'+CurrentYearShort+';Ì7',[rfReplaceAll]);
    s:=StringReplace(s,'$ÃÌ8_6.0','Ã'+CurrentYearShort+';Ì8',[rfReplaceAll]);
    s:=StringReplace(s,'$ÃÌ9_6.0','Ã'+CurrentYearShort+';Ì9',[rfReplaceAll]);
    s:=StringReplace(s,'$ÃÌ10_6.0','Ã'+CurrentYearShort+';Ì10',[rfReplaceAll]);
    s:=StringReplace(s,'$ÃÌ11_6.0','Ã'+CurrentYearShort+';Ì11',[rfReplaceAll]);
    s:=StringReplace(s,'$ÃÌ12_6.0','Ã'+CurrentYearShort+';Ì12',[rfReplaceAll]);
    s:=StringReplace(s,'$ÃÌÏ_6.0',ifelse(Kvartal=1,
                     'Ã'+PredCurrentYearShort+';Ì12',
                     'Ã'+CurrentYearShort+';Ì'+inttostr(Kvartal*3-3)),[rfReplaceAll]);
    s:=StringReplace(s,'$Ã2',CurrentYearShort,[rfReplaceAll]);
    s:=StringReplace(s,'$ÊÂ',inttostr(Kvartal),[rfReplaceAll]);
    s:=StringReplace(s,'$Ì',inttostr(Mounth),[rfReplaceAll]);

    Result:=Fdde.RequestData(s);
  end else
    Result:='';
end;

function TDDE1C6_0.GetConnect: boolean;
begin
  if not FConnect then
  begin
    FDde:=TDdeClientConv.Create(nil);
    FDde.ConnectMode:=ddeManual;
    if (not FDde.SetLink('ÁÓÕ','ÂÛÐ')) or (not FDde.OpenLink) then
      Fdde.Free
    else FConnect:=True;
  end;
  Result:=FConnect;
end;

function TDDE1C6_0.ifelse(tf: boolean; arg1, arg2: string): string;
begin
  if tf then Result:=arg1 else Result:=arg2;
end;

function TDDE1C6_0.PredCurrentYearShort: string;
var
  i:integer;
begin
  i:=0;
  while i<(FYear-1) do inc(i,100);
  Result:=IntToStr(FYear-(i-100)-1);
  if Length(Result)<2 then
    Result:='0'+Result;
end;

procedure TDDE1C6_0.SetKvartal(const Value: integer);
begin
  FKvartal := Value;
end;

procedure TDDE1C6_0.SetMounth(const Value: integer);
begin
  FMounth := Value;
end;

procedure TDDE1C6_0.SetYear(const Value: integer);
begin
  FYear := Value;
end;

end.
