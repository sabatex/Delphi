unit bglmath;
{$mode objfpc}
{$PACKRECORDS C}

interface

  function roundfloat(var Value, RoundToNearest: Double): Double;cdecl;export;
  function doubleabs(var Value: Double): Double; cdecl; export;
  function integerabs(var Value: Integer): Integer; cdecl; export;
  function truncate(var Value: Double): Integer; cdecl; export;
  function doubleplus(var Value: Double): double; cdecl; export;

implementation

function roundfloat(var Value, RoundToNearest: Double): Double;cdecl;export;
        function kround(d:Double):LongInt;
        begin
          if d >=0 then Result:=Trunc(d+0.5000001) else Result:=Trunc(d-0.5000001);
        end;
var
Factor: Extended;
begin
  Factor := Int(Exp(RoundToNearest * Ln(10)));
  Result := kround(Factor * Value) / Factor;
end;

function doubleabs(var Value: Double): Double; cdecl; export;
begin
  result := Abs(Value);
end;

function integerabs(var Value: Integer): Integer; cdecl; export;
begin
  result := Abs(Value);
end;

function truncate(var Value: Double): Integer; cdecl; export;
begin
  result := Trunc(Value);
end;

function doubleplus(var Value: Double): double; cdecl; export;
begin
  if Value>=0 then result:=value else result:=0.00;
end;

end.
