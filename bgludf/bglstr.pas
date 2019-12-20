unit bglstr;
{$mode objfpc}
{$PACKRECORDS C}
{H+}
interface
uses windows,strings,bgldatetime,objects,sysutils;


const
  rus_chars:pChar = #197#210#211#206#208#192#205#202#213#209
                +#194#204#229#243#232#238#240#224#234#245#241#236;
  lat_chars:pChar = 'ETYOPAHKXCBMeyuopakxcm';
  small_chars:pChar =
#113#119#101#114#116#121#117#105#111#112#97#115#100#102#103
+#104#106#107#108#122#120#99#118#98#110#109#233#246#243#234
+#229#237#227#248#249#231#245#250#244#251#226#224#239#240#238
+#235#228#230#253#255#247#241#236#232#242#252#225#254#184
;
  cap_chars:pChar =
#81#87#69#82#84#89#85#73#79#80#65#83#68#70#71#72#74#75#76#90
+#88#67#86#66#78#77#201#214#211#202#197#205#195#216#217#199
+#213#218#212#219#194#192#207#208#206#203#196#198#221#223#215
+#209#204#200#210#220#193#222#168
;
   cp1251:pChar =
#233#246#243#234#229#237#227#248#249#231#245#250#244#251#226
+#224#239#240#238#235#228#230#253#255#247#241#236#232#242#252
+#225#254#184#201#214#211#202#197#205#195#216#217#199#213#218
+#212#219#194#192#207#208#206#203#196#198#221#223#215#209#204
+#200#210#220#193#222#168
;

WordChars: TCharSet =
['0'..'9', 'A'..'Z', 'a'..'z'];

  function makeresultstring(Source, OptionalDest: PChar; Len: DWORD): PChar;
  function findtokenstartingat(st: String; var i: Integer;TokenChars: TCharSet; TokenCharsInToken: Boolean): String;

  function replace_it(CString: PChar;scr: PChar;dest: PChar):PChar;
  function rupper(CString: PChar): PChar;cdecl;export;
  function rlower(CString: PChar): PChar;cdecl;export;
  function character(var Number: Integer): PChar; cdecl; export;
  function crlf: PChar; cdecl; export;
  function findnthword(sz: PChar; var i: Integer): PChar; cdecl; export;
  function findword(sz: PChar; var i: Integer): PChar; cdecl; export;
  function alltrim(sz: PChar): PChar; cdecl; export;
  function stringlength(sz: PChar): Integer; cdecl; export;
  function substr(szSubStr, szStr: PChar): Integer; cdecl; export;
  function copysubstr(sz: PChar;var index:integer;var count:integer): PChar; cdecl; export;

implementation


function MakeResultString(Source, OptionalDest: PChar; Len: DWORD): PChar;
begin
  result := OptionalDest;
  if (Len = 0) then
    Len := StrLen(Source) + 1;
  if (result = nil) then result := ib_util_malloc(Len);
  if (Source <> result) then begin
    if (Source = nil) or (Len = 1) then
      result[0] := #0
    else
      Move(Source^, result^, Len);
  end;
end;

function findtokenstartingat(st: String; var i: Integer;TokenChars: TCharSet; TokenCharsInToken: Boolean): String;
var
  Len, j: Integer;
begin
  if (i < 1) then i := 1;
  j := i; Len := Length(st);
  while (j <= Len) and
        ((TokenCharsInToken and (not (st[j] in TokenChars))) or
         ((not TokenCharsInToken) and (st[j] in TokenChars))) do Inc(j);
  i := j;
  while (j <= Len) and
        (((not TokenCharsInToken) and (not (st[j] in TokenChars))) or
         (TokenCharsInToken and (st[j] in TokenChars))) do Inc(j);
  if (i > Len) then
    result := ''
  else
    result := Copy(st, i, j - i);
  i := j;
end;

function replace_it(CString: PChar;scr: PChar;dest: PChar):PChar;
var i,j:integer;
begin
  i:=0;
  while (CString[i]<>#0) do
  begin
    j:=0;
    while (scr[j]<>#0) do
    begin
       if CString[i]=scr[j]
       then
       begin
         CString[i]:=dest[j];
         Break;
       end;
       inc(j);
    end;
    inc(i);
  end;
  result:=CString;
end;

function rupper(CString: PChar): PChar;cdecl;export;
begin
  result:=replace_it(CString,small_chars,cap_chars);
end;

function rlower(CString: PChar): PChar;cdecl;export;
begin
  result:=replace_it(CString,cap_chars,small_chars);
end;

function Character(var Number: Integer): PChar; cdecl; export;
var
  c: array[0..1] of Char;
begin
  c[0] := Char(Number);
  c[1] := #0;
  result := MakeResultString(@c, nil, 2);
end;

function crlf: PChar; cdecl; export;
begin
  result := MakeResultString(#13 + #10, nil, 3);
end;

function findnthword(sz: PChar; var i: Integer): PChar; cdecl; export;
var
  j, Len: Integer;
  str, res: String;
begin
  str := String(sz);
  res := '';
  Len := Length(str);
  j := 1;
  while (j <= Len) and
        (i > 0) do begin
    res := FindTokenStartingAt(String(sz), i, WordChars, True);
    Dec(i);
  end;
  result := MakeResultString(PChar(Trim(res)), nil, 0);
end;

function findword(sz: PChar; var i: Integer): PChar; cdecl; export;
begin
  Inc(i);
  result := MakeResultString(PChar(Trim(FindTokenStartingAt(String(sz), i, WordChars, True))), nil, 0);
end;

function alltrim(sz: PChar): PChar; cdecl; export;
begin
  result := MakeResultString(PChar(Trim(String(sz))), nil, 0);
end;

function stringlength(sz: PChar): Integer; cdecl; export;
begin
  result := StrLen(sz);
end;

function substr(szSubStr, szStr: PChar): Integer; cdecl; export;
begin
 result := Pos(String(szSubStr), String(szStr)) - 1;
end;

function copysubstr(sz: PChar;var index:integer;var count:integer): PChar; cdecl; export;
var s:ansistring;
begin
  s:=copy(ansiString(sz),index,count);
  result:=MakeResultString(PChar(s), nil, 0);
end;

end.
