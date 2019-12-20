

unit bglsys;
{$mode objfpc}
{$PACKRECORDS C}

interface
uses strings;
type

   TIBDate = integer;
   TIBTime = Cardinal;

   TIBTimeStamp= packed record
                    Date: TIBDate;
                    Time: TIBTime;
                 end;

const Cols:array[0..6] of string =('COSTPRICE','SALEPRICE','BARCODE','IDCOLOR','USEBYDATE','PARAM1','PARAM2');

function GetColsByIndex(value:integer):String;
function GetColsByString(value:String):integer;


function check_numeric(AFieldName: PChar;var idscheme:integer;var Value1:Double;var Value2:Double): Integer; cdecl; export;
function check_integer(AFieldName: PChar;var idscheme:integer;var Value1:integer;var Value2:integer): Integer; cdecl; export;
function check_string(AFieldName: PChar;var idscheme:integer;Value1:pchar;Value2:pchar): Integer; cdecl; export;
function check_date(AFieldName: PChar;var idscheme:integer;var Value1:TIBTimeStamp;var Value2:TIBTimeStamp): Integer; cdecl; export;
function check_inscheme(AFieldName: PChar;var idscheme:integer): Integer; cdecl; export;

implementation

function GetColsByString(value: String): integer;
var i1,i2,i3,i4,i5,i6,i7:integer;
    s1,s2,s3,s4,s5,s6,s7:String;
    IDGlobal:integer;
begin
 IDGlobal:=0;
 GetColsByString:=0;
 for i1:=0 to 6 do
  begin
    s1:=Cols[i1];
    IDGlobal:=IDGlobal+1;
    if Value=s1 then GetColsByString:=IDGlobal;
    for i2:=i1+1 to 6 do
      begin
        s2:=s1+'-'+Cols[i2];
        IDGlobal:=IDGlobal+1;
        if Value=s2 then GetColsByString:=IDGlobal;
        for i3:=i2+1 to 6 do
          begin
            s3:=s2+'-'+Cols[i3];
            IDGlobal:=IDGlobal+1;
            if Value=s3 then GetColsByString:=IDGlobal;
            for i4:=i3+1 to 6 do
             begin
               s4:=s3+'-'+Cols[i4];
               IDGlobal:=IDGlobal+1;
               if Value=s4 then GetColsByString:=IDGlobal;
               for i5:=i4+1 to 6 do
                begin
                 s5:=s4+'-'+Cols[i5];
                 IDGlobal:=IDGlobal+1;
                 if Value=s5 then GetColsByString:=IDGlobal;
                 for i6:=i5+1 to 6 do
                   begin
                     s6:=s5+'-'+Cols[i6];
                     IDGlobal:=IDGlobal+1;
                     if Value=s6 then GetColsByString:=IDGlobal;
                    for i7:=i6+1 to 6 do
                      begin
                        s7:=s6+'-'+Cols[i7];
                        IDGlobal:=IDGlobal+1;
                        if Value=s7 then GetColsByString:=IDGlobal;
                      end;
                    end;
                end;
             end;
          end;
      end;
  end;
end;

function GetColsByIndex(value: integer): String;
var i1,i2,i3,i4,i5,i6,i7:integer;
    s1,s2,s3,s4,s5,s6,s7:String;
    IDGlobal:integer;
begin
 IDGlobal:=0;
 for i1:=0 to 6 do
  begin
    s1:=Cols[i1];
    IDGlobal:=IDGlobal+1;
    if Value=IDGlobal then GetColsByIndex:=s1;
    for i2:=i1+1 to 6 do
      begin
        s2:=s1+'-'+Cols[i2];
        IDGlobal:=IDGlobal+1;
        if Value=IDGlobal then GetColsByIndex:=s2;
        for i3:=i2+1 to 6 do
          begin
            s3:=s2+'-'+Cols[i3];
            IDGlobal:=IDGlobal+1;
            if Value=IDGlobal then GetColsByIndex:=s3;
            for i4:=i3+1 to 6 do
             begin
               s4:=s3+'-'+Cols[i4];
               IDGlobal:=IDGlobal+1;
               if Value=IDGlobal then GetColsByIndex:=s4;
               for i5:=i4+1 to 6 do
                begin
                 IDGlobal:=IDGlobal+1;
                 s5:=s4+'-'+Cols[i5];
                 if Value=IDGlobal then GetColsByIndex:=s5;
                 for i6:=i5+1 to 6 do
                  begin
                   IDGlobal:=IDGlobal+1;
                   s6:=s5+'-'+Cols[i6];
                   if Value=IDGlobal then GetColsByIndex:=s6;
                   for i7:=i6+1 to 6 do
                    begin
                     IDGlobal:=IDGlobal+1;
                     s7:=s6+'-'+Cols[i7];
                     if Value=IDGlobal then GetColsByIndex:=s7;
                    end;
                  end;
                end;
             end;
          end;
      end;
  end;
end;
{Проверить numeric}
function check_numeric(AFieldName: PChar;var idscheme:integer;var Value1:Double;var Value2:Double): Integer; cdecl; export;
var AFields:String;
begin
  AFields:=GetColsByIndex(idscheme);
  result:=1;
  if Pos(ansiString(AFieldName),AFields)>0 then
   begin
    if Value1=Value2 then result:=1 else result:=0;
   end;
end;

function check_integer(AFieldName: PChar;var idscheme:integer;var Value1:integer;var Value2:integer): Integer; cdecl; export;
var AFields:String;
begin
  AFields:=GetColsByIndex(idscheme);
  result:=1;
  if Pos(ansiString(AFieldName),AFields)>0 then
   begin
    if Value1=Value2 then result:=1 else result:=0;
   end;
end;

function check_string(AFieldName: PChar;var idscheme:integer;Value1:pchar;Value2:pchar): Integer; cdecl; export;
var AFields:String;
begin
  AFields:=GetColsByIndex(idscheme);
  result:=1;
  if Pos(ansiString(AFieldName),AFields)>0 then
   begin
    if String(Value1)=String(Value2) then result:=1 else result:=0;
   end;
end;

function check_date(AFieldName: PChar;var idscheme:integer;var Value1:TIBTimeStamp;var Value2:TIBTimeStamp): Integer; cdecl; export;
var AFields:String;
begin
  AFields:=GetColsByIndex(idscheme);
  result:=1;
  if Pos(ansiString(AFieldName),AFields)>0 then
   begin
    if Value1.Date=Value2.Date then result:=1 else result:=0;
   end;
end;

function check_inscheme(AFieldName: PChar;var idscheme:integer): Integer; cdecl; export;
var AFields:String;
begin
  AFields:=GetColsByIndex(idscheme);
  result:=1;
  if Pos(ansiString(AFieldName),AFields)>0
     then result:=1 else result:=0;
end;

end.

