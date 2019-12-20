unit bgldatetime;
{$mode objfpc}
{$PACKRECORDS C}

interface

uses strings,sysutils;

type
 isc_quad= record
             low:longint;
             high:dword;
            end;
 pisc_quad=^isc_quad;
 tisc_quad=isc_quad;
 Tm = record
     tm_sec : longint;   // Seconds
     tm_min : longint;   // Minutes
     tm_hour : longint;  // Hour (0--23)
     tm_mday : longint;  // Day of month (1--31)
     tm_mon : longint;   // Month (0--11)
     tm_year : longint;  // Year (calendar year minus 1900)
     tm_wday : longint;  // Weekday (0--6) Sunday = 0)
     tm_yday : longint;  // Day of year (0--365)
     tm_isdst : longint; // 0 if daylight savings time is not in effect)
  end;
  PCTimeStructure = ^Tm;

  procedure isc_decode_date(_para1:PISC_QUAD; _para2:pointer); stdcall; external 'fbclient.dll';
  procedure isc_encode_date(tm_date:PCTimeStructure;ib_date:PISC_QUAD);stdcall; external 'fbclient.dll';
  function  ib_util_malloc(_para1:longint):pointer;cdecl;external 'ib_util';

  function makeresultquad(Source, OptionalDest: pisc_quad): pisc_quad;
  procedure internalweekofyear(ib_date: PISC_QUAD; var Week, Year: Integer);

  procedure init_tm(var tm_date:Tm);
  function  month(ib_date: PISC_QUAD): longint;cdecl;export;
  function  day(ib_date: PISC_QUAD): longint;cdecl;export;
  function  year(ib_date: PISC_QUAD): longint;cdecl;export;

  function isleapyear(year: Integer): integer; cdecl; export;
  function addmonth(ib_date: PISC_QUAD;var months_to_add: Integer): PISC_QUAD; cdecl; export;
  function addyear(ib_date: PISC_QUAD; var years_to_add: Integer): PISC_QUAD; cdecl; export;
  function ageindays(ib_date,ib_date_reference: PISC_QUAD): integer; cdecl; export;
  function ageinmonths(ib_date,ib_date_reference: PISC_QUAD): integer; cdecl; export;
  function ageinweeks(ib_date,ib_date_reference: PISC_QUAD): integer; cdecl; export;
  function dayofmonth(ib_date: PISC_QUAD): integer; cdecl; export;
  function dayofweek(ib_date: PISC_QUAD): integer; cdecl; export;
  function dayofyear(ib_date: PISC_QUAD): integer; cdecl; export;
  function quarter(ib_date: PISC_QUAD): integer; cdecl; export;
  function weekofyear(ib_date: PISC_QUAD): integer; cdecl; export;

const
  // Days of week
  dSun = 1;  dMon = 2;  dTue = 3;  dWed = 4;  dThu = 5;  dFri = 6;  dSat = 7;
  // Months of year
  dJan = 1;  dFeb = 2;  dMar = 3;  dApr = 4;  dMay = 5;  dJun = 6;
  dJul = 7;  dAug = 8;  dSep = 9;  dOct = 10;  dNov = 11;  dDec = 12;
  // C Consts
  cYearOffset = 1900;
  // Days of week
  cSun = 0;  cMon = 1;  cTue = 2;  cWed = 3;  cThu = 4;  cFri = 5;  cSat = 6;
  // Months of year
  cJan = 0;  cFeb = 1;  cMar = 2;  cApr = 3;  cMay = 4;  cJun = 5;
  cJul = 6;  cAug = 7;  cSep = 8;  cOct = 9;  cNov = 10;  cDec = 11;

implementation

procedure init_tm(var tm_date:Tm);
begin
  with tm_date do
  begin
   tm_sec    := 0;
   tm_min    := 0;
   tm_hour   := 0;
   tm_mday   := 0;
   tm_mon    := 0;
   tm_year   := 0;
   tm_wday   := 0;
   tm_yday   := 0;
   tm_isdst  := 0;
  end;
end;

function makeresultquad(Source, OptionalDest: pisc_quad): pisc_quad;
begin
  result := OptionalDest;
  if (result = nil) then result := ib_util_malloc(SizeOf(TISC_QUAD));
  if (Source <> nil) then Move(Source^, result^, SizeOf(TISC_QUAD));
end;

procedure InternalWeekOfYear(ib_date: PISC_QUAD; var Week, Year: Integer);
var
  tm_date: tm;
  dow_ybeg: Integer;
  ThisLeapYear, LastLeapYear: Boolean;
begin
  isc_decode_date(ib_date, @tm_date);
  // When did the year begin?
  Year := tm_date.tm_year + cYearOffset;
  dow_ybeg := SysUtils.DayOfWeek(EncodeDate(Word(tm_date.tm_year + cYearOffset), 1, 1));
  ThisLeapYear := IsLeapYear(tm_date.tm_year + cYearOffset) = 1;
  LastLeapYear := IsLeapYear(tm_date.tm_year + cYearOffset - 1) = 1;
  // Get the Sunday beginning this week.
  Week := (tm_date.tm_yday - tm_date.tm_wday + 1);
  if Week <= 0 then begin
    if (dow_ybeg <= dWed) then
      Week := 1
    else if (dow_ybeg = dThu) or (LastLeapYear and (dow_ybeg = dFri)) then begin
      Week := 53;
      Dec(Year);
    end else begin
      Week := 52;
      Dec(Year);
    end;
  end else begin
    if (dow_ybeg <= dWed) then
      Week := (Week + 6 + dow_ybeg) div 7
    else
      Week := (Week div 7) + 1;
    if Week > 52 then begin
      if (dow_ybeg = dWed) or (ThisLeapYear and (dow_ybeg = dTue)) then
        Week := 53
      else begin
        Week := 1;
        Inc(Year);
      end;
    end;
  end;
end;

function month(ib_date: PISC_QUAD): longint;cdecl;export;
var
  tm_date:Tm;
begin
  init_tm(tm_date);
  isc_decode_date(ib_date,@tm_date);
  result :=tm_date.tm_mon+1;
end;

function day(ib_date: PISC_QUAD): longint;cdecl;export;
var
  tm_date:Tm;
begin
  init_tm(tm_date);
  isc_decode_date(ib_date,@tm_date);
  result :=tm_date.tm_mday;
end;

function year(ib_date: PISC_QUAD): longint;cdecl;export;
var
  tm_date:Tm;
begin
  init_tm(tm_date);
  isc_decode_date(ib_date,@tm_date);
  result :=tm_date.tm_year+1900;
end;

function isleapyear(year: Integer): integer; cdecl; export;
var
  ybeg, yend: TDateTime;
begin
  ybeg := EncodeDate(Word(year), 1, 1);
  yend := EncodeDate(Word(year), 12, 31);
  if yend - ybeg + 1 = 366 then
    result := 1
  else
    result := 0;
end;


function addmonth(ib_date: PISC_QUAD; var months_to_add: Integer): PISC_QUAD; cdecl; export;
var
  tm_date, res_date: tm;
begin
  //InitializeTCTimeStructure(res_date);
  init_tm(res_date);
  isc_decode_date(ib_date, @tm_date);
  with res_date do begin
    // Respect the "time" setting in the passed date
    tm_sec := tm_date.tm_sec;
    tm_min := tm_date.tm_min;
    tm_hour := tm_date.tm_hour;
    tm_isdst := tm_date.tm_isdst;
    // Now add the month
    tm_mday := tm_date.tm_mday;
    tm_mon  := (tm_date.tm_mon + ((months_to_add mod 12) + 12)) mod 12;
    tm_year := tm_date.tm_year + (months_to_add div 12);
    if (months_to_add > 0) and (tm_mon < tm_date.tm_mon) then
      Inc(tm_year)
    else if (months_to_add < 0) and (tm_mon > tm_date.tm_mon) then
      Dec(tm_year);
    // 30 days has 9, 4, 6, 11 all have 31 except 2
    if (tm_mon <> cFeb) then begin
      if (tm_mday > 30) and (tm_mon in [cSep, cApr, cJun, cNov]) then
        tm_mday := 30;
    end else if (tm_mday > 28) then
      tm_mday := isleapyear(cYearOffset + tm_year)+28;
{
     begin
      if IsLeapYear(cYearOffset + tm_year) then tm_mday := 1 + 28 else tm_mday := 0 + 28;
     end;
}
  end;
  result := MakeResultQuad(nil, nil);
  isc_encode_date(@res_date, result);
end;

function addyear(ib_date: PISC_QUAD; var years_to_add: Integer): PISC_QUAD; cdecl; export;
var
  tm_date, res_date: tm;
begin
  init_tm(res_date);
  isc_decode_date(ib_date, @tm_date);
  with res_date do begin
    // Respect the "time" setting in the passed date
    tm_sec := tm_date.tm_sec;
    tm_min := tm_date.tm_min;
    tm_hour := tm_date.tm_hour;
    tm_isdst := tm_date.tm_isdst;
    // Now add the year
    tm_mday := tm_date.tm_mday;
    tm_mon := tm_date.tm_mon;
    tm_year := tm_date.tm_year + years_to_add;
    if (tm_mon = cFeb) and (tm_mday > 28) then
      tm_mday := 28 + IsLeapYear(cYearOffset + tm_year);
  end;
  result := MakeResultQuad(nil, nil);
  isc_encode_date(@res_date, result);
end;

function ageindays(ib_date,ib_date_reference: PISC_QUAD): integer; cdecl; export;
var
  tm_date, tm_date_reference: tm;
  d_date, d_date_reference: TDateTime;
begin
  isc_decode_date(ib_date, @tm_date);
  isc_decode_date(ib_date_reference, @tm_date_reference);
  d_date := encodedate(tm_date.tm_year + cYearOffset,
                       tm_date.tm_mon + 1,
                       tm_date.tm_mday);
  d_date_reference := encodedate(tm_date_reference.tm_year + cYearOffset,
                                 tm_date_reference.tm_mon + 1,
                                 tm_date_reference.tm_mday);
  result := Trunc(d_date_reference - d_date);
end;


function ageinmonths(ib_date,ib_date_reference: PISC_QUAD): integer; cdecl; export;
var
  tm_date, tm_date_reference: tm;
begin
  isc_decode_date(ib_date, @tm_date);
  isc_decode_date(ib_date_reference, @tm_date_reference);
  result := ((tm_date_reference.tm_year - tm_date.tm_year) * 12) +
              tm_date_reference.tm_mon - tm_date.tm_mon;
end;

function ageinweeks(ib_date,ib_date_reference: PISC_QUAD): integer; cdecl; export;
var
  tm_date, tm_date_reference: tm;
  d_date, d_date_reference: TDateTime;
begin
  isc_decode_date(ib_date, @tm_date);
  isc_decode_date(ib_date_reference, @tm_date_reference);
  d_date := EncodeDate(tm_date.tm_year + cYearOffset,
                       tm_date.tm_mon + 1,
                       tm_date.tm_mday);
  d_date_reference := EncodeDate(tm_date_reference.tm_year + cYearOffset,
                                 tm_date_reference.tm_mon + 1,
                                 tm_date_reference.tm_mday);
  result := Trunc((d_date_reference - SysUtils.DayOfWeek(d_date_reference)) -
                  (d_date - SysUtils.DayOfWeek(d_date))) div 7;
end;

function dayofmonth(ib_date: PISC_QUAD): integer; cdecl; export;
var
  tm_date: tm;
begin
  isc_decode_date(ib_date, @tm_date);
  result := tm_date.tm_mday;
end;

function dayofweek(ib_date: PISC_QUAD): integer; cdecl; export;
var
  tm_date: tm;
begin
  isc_decode_date(ib_date, @tm_date);
  result := tm_date.tm_wday + 1;
end;

function dayofyear(ib_date: PISC_QUAD): integer; cdecl; export;
var
  tm_date: tm;
begin
  isc_decode_date(ib_date, @tm_date);
  result := tm_date.tm_yday + 1;
end;

function quarter(ib_date: PISC_QUAD): integer; cdecl; export;
var
  tm_date: tm;
begin
  isc_decode_date(ib_date, @tm_date);
  result := (tm_date.tm_mon div 3) + 1;
end;

function weekofyear(ib_date: PISC_QUAD): integer; cdecl; export;
var
  yr: Integer;
begin
  InternalWeekOfYear(ib_date, result, yr);
end;

end.
