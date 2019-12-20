unit ntics_registration;
interface
uses Windows, SysUtils, Forms, Classes;

procedure SetKey(dkey,nkey:string);
procedure SetSerial(FileName:string);
function GetFirmName:string; {return COMPANY_NAME;}
function GetEDRPOU:string; {return EDRPOU;}
function GetTFO:integer; {return ID_FIZ;}
function GetLicenze():integer; // return current licenze number
function GetLicenzeName():string; // return current licenze ASCII name
procedure AddLicenze(licenze:string); // add new licenze to licenze list



implementation
uses FGInt, FGIntRSA, ntics_const, ntics_storage;

const
  ID_FIZ:Integer = 0;
  LICENZE:Integer = 0;
  EDRPOU:string[11] = 'None';
  COMPANY_NAME:string[100] = 'None';
  SERIAL:string[100] = 'None';
  KeyExist:boolean = false;
  delimiter:string = ';';
  ShareWare = 'ShareWare';

var
  FD:TFGInt;
  FN:TFGInt;
  LicenzeName:array of string;



procedure Initialize();
var
  Null:TFGInt;
  s:string;
begin
  // Розшифровка ключа
  s := NetStorage.ReadString('OPTIONS','SERIAL','');
  if s <> '' then
  begin
    Base10StringToFGInt(s,Null);
    FGIntToBase256String(Null,s);
    FGIntDestroy(Null);
    RSADecrypt(s,FD,FN,Null,Null,Null,Null,s);

    // проверка версии ключа
    if  Pos(s,delimiter)=0 then Exit;
    if Copy(s,1,Pos(s,delimiter)-1) <> VersionKey then Exit;
    Delete(s,1,Pos(s,delimiter));

    if  Pos(s,delimiter)=0 then Exit;
    if Copy(s,1,Pos(s,delimiter)-1) <> Copyrigth then Exit;
    Delete(s,1,Pos(s,delimiter));

    // загрузка значений
    if  Pos(s,delimiter)=0 then Exit;
    EDRPOU := Copy(s,1,Pos(s,delimiter)-1);
    Delete(s,1,Pos(s,delimiter));

    if  Pos(s,delimiter)=0 then Exit;
    COMPANY_NAME := Copy(s,1,Pos(s,delimiter)-1);
    Delete(s,1,Pos(s,delimiter));

    if  Pos(s,delimiter)=0 then Exit;
    ID_FIZ := StrToInt(Copy(s,1,Pos(s,delimiter)-1));
    Delete(s,1,Pos(s,delimiter));

    if  Pos(s,delimiter)=0 then Exit;
    LICENZE := StrToInt(Copy(s,1,Pos(s,delimiter)-1));
    Delete(s,1,Pos(s,delimiter));

    if  Pos(s,delimiter)=0 then Exit;
    SERIAL := Copy(s,1,Pos(s,delimiter)-1);
  end;
end;

procedure SetKey(dkey,nkey:string);
begin
  Base10StringToFGInt(dkey,FD);
  Base10StringToFGInt(nkey,FN);
  Initialize();
end;

procedure SetSerial(FileName:string);
var
  f:Text;
  s:string;
begin
  AssignFile(f,FileName);
  Reset(f);
  Readln(f,s);
  if s<>'' then
    NetStorage.WriteString('OPTIONS','SERIAL',s);
  Initialize();
end;

function GetFirmName:string;
begin
  Result:=COMPANY_NAME;
end;

function GetEDRPOU:string;
begin
  Result:=EDRPOU;
end;

function GetTFO:integer;
begin
  Result:=ID_FIZ;
end;

// Работа с лицензиями
function GetLicenze():integer;
begin
  if LICENZE>(Length(LicenzeName)-1) then
    Result:=0
  else Result:=LICENZE
end;

function GetLicenzeName():string;
begin
  Result:=LicenzeName[GetLicenze()];
end;

procedure AddLicenze(licenze:string);
begin
  SetLength(LicenzeName,Length(LicenzeName)+1);
  LicenzeName[Length(LicenzeName)-1] := licenze;
end;


initialization
  SetLength(LicenzeName,1);
  LicenzeName[0]:=ShareWare;

end.
