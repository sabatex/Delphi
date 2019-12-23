{
@abstract(Compile time Date Time library)
@author(Carlo Kok <ck@carlo-kok.com>)

Innerfuse Pascal Script III
Copyright (C) 2000-2004 by Carlo Kok (ck@@carlo-kok.com)
}
unit ifpidateutils;

interface
uses
  SysUtils, ifpscomp, ifps3utl;

{

Register the compiler pare of the Datetime library<br>
<tt>
TDateTime = double;<br>
                   <br>
function EncodeDate(Year, Month, Day: Word): TDateTime;<br>
function EncodeTime(Hour, Min, Sec, MSec: Word): TDateTime;<br>
function TryEncodeDate(Year, Month, Day: Word; out Date: TDateTime): Boolean;<br>
function TryEncodeTime(Hour, Min, Sec, MSec: Word; out Time: TDateTime): Boolean;<br>
procedure DecodeDate(const DateTime: TDateTime; var Year, Month, Day: Word);<br>
procedure DecodeTime(const DateTime: TDateTime; var Hour, Min, Sec, MSec: Word);<br>
function DayOfWeek(const DateTime: TDateTime): Word;<br>
function Date: TDateTime;<br>
function Time: TDateTime;<br>
function Now: TDateTime;<br>
function DateTimeToUnix(D: TDateTime): Int64;<br>
function UnixToDateTime(U: Int64): TDateTime;<br>
function DateToStr(D: TDateTime): string;<br>
function StrToDate(const s: string): TDateTime;<br>
function FormatDateTime(const fmt: string; D: TDateTime): string;<br>
}

procedure RegisterDateTimeLibrary_C(S: TIFPSPascalCompiler);

implementation

procedure RegisterDatetimeLibrary_C(S: TIFPSPascalCompiler);
begin
  s.AddType('TDateTime', btDouble).ExportName := True;
  s.AddDelphiFunction('function EncodeDate(Year, Month, Day: Word): TDateTime;');
  s.AddDelphiFunction('function EncodeTime(Hour, Min, Sec, MSec: Word): TDateTime;');
  s.AddDelphiFunction('function TryEncodeDate(Year, Month, Day: Word; var Date: TDateTime): Boolean;');
  s.AddDelphiFunction('function TryEncodeTime(Hour, Min, Sec, MSec: Word; var Time: TDateTime): Boolean;');
  s.AddDelphiFunction('procedure DecodeDate(const DateTime: TDateTime; var Year, Month, Day: Word);');
  s.AddDelphiFunction('procedure DecodeTime(const DateTime: TDateTime; var Hour, Min, Sec, MSec: Word);');
  s.AddDelphiFunction('function DayOfWeek(const DateTime: TDateTime): Word;');
  s.AddDelphiFunction('function Date: TDateTime;');
  s.AddDelphiFunction('function Time: TDateTime;');
  s.AddDelphiFunction('function Now: TDateTime;');
  s.AddDelphiFunction('function DateTimeToUnix(D: TDateTime): Int64;');
  s.AddDelphiFunction('function UnixToDateTime(U: Int64): TDateTime;');

  s.AddDelphiFunction('function DateToStr(D: TDateTime): string;');
  s.AddDelphiFunction('function StrToDate(const s: string): TDateTime;');
  s.AddDelphiFunction('function FormatDateTime(const fmt: string; D: TDateTime): string;');
end;

end.
