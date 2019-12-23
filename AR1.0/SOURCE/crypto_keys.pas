unit crypto_keys;
interface
uses {$IFDEF WIN32}windows,{$ENDIF} FGInt, Classes, FGIntRSA, IniFiles,
     fConfigStorage, ntics_classes;
// Общие данные

Type
  TRegistrationInfo = class(TObject)
  private
    FD:TFGint;
    FN:TFGint;
    FKey:TSecretKey;
    function GetEDRPOU: string;
    function GetFirmName: string;
    function GetLicenzeCount: integer;
    function GetTFO: integer;
  public
    constructor Create(const dkey,nkey:string);reintroduce;
    property EDRPOU:string read GetEDRPOU;
    property TFO:integer read GetTFO;
    property LicenzeCount:integer read GetLicenzeCount;
    property FirmName:string read GetFirmName;
    procedure Registration(SerialKey:string);
    procedure Decript;
  end;



function DecryptKey(Key:string;D,N:TFGInt):TSecretKey;
function LoadKeyFromIni(D,N:TFGInt):TSecretKey;
function ArrayToString(Value:TDWORDArray):string;
function StringToArray(Value:string):TDWORDArray;
function GetAuteficationKey(SerialKey:string):string;


var
  RegistrationInfo:TRegistrationInfo;

implementation
uses SysUtils, ntics_const, math, QLowLevelFunction;


// На каждое двойное слово отвотится 7 символов
// слова разделяются знаком -
function ArrayToString(Value:TDWORDArray):string;
var
  i,j:integer;
begin
  Result:='';
  for i:=0 to High(value) do
  begin
     if i <> 0 then Result:=Result + '-';
     j:=0;
     while (j<32) do
     begin
       Result:=Result+FChar[((Value[i] shr j) and $1f) +1];
       inc(j,5);
     end;
  end;
end;


// Количество символов должно быть кратно 7 (не учитывая разделителей)
function StringToArray(Value:string):TDWORDArray;
var
  i,j:integer;
  r:DWORD;
begin
  Result:=nil;
  // удаляем разделители '-'
  while pos('-',Value)<>0 do delete(Value,pos('-',Value),1);
  if (length(Value) < 7) or (Length(Value) mod 7 <> 0) then
    raise Exception.Create(KeyError);
  SetLength(Result,length(Value) div 7);
  r:=1;
  for i:=0 to min(high(Result),length(Value) div 7) do
  begin
    j:=0;
    while (j<32) do
    begin
      Result[i]:=Result[i] or ( (pos(Value[r],FChar)-1) shl j);
      inc(j,5);
      inc(r);
    end;
  end;
end;

{ TRegistrationInfo }

constructor TRegistrationInfo.Create;
var
  INIFile:TIniFile;
begin
  inherited Create();
  INIFile:=TIniFile.Create(ConfigStorage.StorageName);
  Base10StringToFGInt(dkey,FD);
  Base10StringToFGInt(nkey,FN);
  FKey:=DecryptKey(INIFile.ReadString('OPTIONS','SERIAL',''),FD,FN);
  INIFile.Free;
end;

procedure TRegistrationInfo.Decript;
var
  INIFile:TIniFile;
begin
  INIFile:=TIniFile.Create(ConfigStorage.StorageName);
  FKey:=DecryptKey(INIFile.ReadString('OPTIONS','SERIAL',''),FD,FN);
  INIFile.Free;
end;

function TRegistrationInfo.GetEDRPOU: string;
begin
  Result:=FKey.EDRPOU;
end;

function TRegistrationInfo.GetFirmName: string;
begin
  Result:=FKey.COMPANY_NAME;
end;

function TRegistrationInfo.GetLicenzeCount: integer;
begin
  Result:=FKey.LICENZE;
end;

function TRegistrationInfo.GetTFO: integer;
begin
  Result:=Fkey.ID_FIZ;
end;


procedure TRegistrationInfo.Registration(SerialKey: string);
var
  INIFile:TIniFile;
begin
  INIFile:=TIniFile.Create(ConfigStorage.StorageName);
  INIFile.WriteString('OPTIONS','SERIAL',SerialKey);
  FKey:=DecryptKey(SerialKey,FD,FN);
  INIFile.Free;
end;

function RSADecryptBase10(s:string;E,N:TFGInt):string;
var
  Null:TFGInt;
begin
  Base10StringToFGInt(s,Null);
  FGIntToBase256String(Null,s);
  FGIntDestroy(Null);
  RSADecrypt(s,E,N,Null,Null,Null,Null,Result);
  FGIntDestroy(e);
  FGIntDestroy(n);
end;

function LoadKeyFromIni(D,N:TFGInt):TSecretKey;
var
  s:string;
begin
  s:=ConfigStorage.LoadValue('Registration',Unregistred);
  Result:=DecryptKey(s,D,N);
end;

function DecryptKey(Key:string;D,N:TFGInt):TSecretKey;
  function TestEnd(s:string):boolean;
  begin
    Result:=(pos(';',s) = 0);
  end;

var
  s:string;
begin
  // значения по умолчанию
  Result.EDRPOU:=Unregistred;
  Result.COMPANY_NAME:='Demo';
  Result.ID_FIZ:=0;
  Result.LICENZE:=0;
  Result.SERIAL:=Unregistred;

  // Розшифровка ключа
  if Key = '' then Exit;
  s:=RSADecryptBase10(Key,D,N);
  if TestEnd(s) then Exit;
  // проверка версии ключа
  if copy(s,1,pos(';',s)-1) <> VersionKey then Exit;
  Delete(s,1,pos(';',s));
  if TestEnd(s) then Exit;
  if copy(s,1,pos(';',s)-1) <> Copyrigth then Exit;
  Delete(s,1,pos(';',s));
  if TestEnd(s) then Exit;
  // загрузка значений
  Result.EDRPOU:=copy(s,1,pos(';',s)-1);
  Delete(s,1,pos(';',s));
  if TestEnd(s) then Exit;
  Result.COMPANY_NAME:=copy(s,1,pos(';',s)-1);
  Delete(s,1,pos(';',s));
  if TestEnd(s) then Exit;
  Result.ID_FIZ:=StrToInt(copy(s,1,pos(';',s)-1));
  Delete(s,1,pos(';',s));
  if TestEnd(s) then Exit;
  Result.LICENZE:=StrToInt(copy(s,1,pos(';',s)-1));
  Delete(s,1,pos(';',s));
  if TestEnd(s) then Exit;
  Result.SERIAL:=copy(s,1,pos(';',s)-1);
end;

function GetAuteficationKey(SerialKey:string):string;
var
  s:string;
begin
  s:=GetHardwareNumber+';'+SerialKey;

end;

end.
