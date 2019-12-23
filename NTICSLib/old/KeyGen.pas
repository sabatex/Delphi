unit KeyGen;
interface
uses ntics_classes, FGInt, types;

function MakeKey(Key:TSecretKey;E,N:TFGInt):string;
function CreateSecretKey(SNumber:string;users:integer):string;

implementation

uses ntics_const, SysUtils, FGIntRSA, DCPHaval, DCPgost, crypto_keys;

function RSAEncryptBase10(s:string;E,N:TFGInt):string;
var
  temp:TFGInt;
begin
  RSAEncrypt(s,E,N,Result);
  Base256StringToFGInt(Result,temp);
  FGIntToBase10String(temp,Result);
  FGIntDestroy(temp);
end;

function MakeKey(Key:TSecretKey;E,N:TFGInt):string;
var
  s:string;
begin
  s:=VersionKey +
     ';' + Copyrigth +
     ';' + Key.EDRPOU +
     ';' + Key.COMPANY_NAME +
     ';' + IntToStr(Key.ID_FIZ) +
     ';' + IntToStr(Key.LICENZE)+
     ';' + Key.SERIAL +';';
  Result:=RSAEncryptBase10(s,E,N);
end;

function GetSecretKey(value:string;Users:integer):string;
var
  FHashKey:TDWORDArray;
  //FUserParams:TUserParms;
  FUserKey:TDWORDArray;
  FHash: TDCP_haval;
  FCipher: TDCP_gost;
  i:integer;

begin
  // Создание хеша секретного ключа
  SetLength(FHashKey,8);
  FillChar(FHashKey[0],Length(FHashKey)*sizeof(DWORD),$ffffffff);
  FHash:=TDCP_haval.Create(nil);
  FHash.Init;
  FHash.UpdateStr(Value);
  FHash.Final(FHashKey[0]);
  FHash.Free;

  //Создание затовки ключа пользователя
  SetLength(FUserKey,UserHashLength+UserInformationLength);
  for i:=1 to UserHashLength do FUserKey[i]:=FHashKey[i];
  FUserKey[0]:= users;

  // шифруем ключ пользователя
  FCipher:=TDCP_gost.Create(nil);
  FCipher.Init(FHashKey[0],Length(FHashKey)*sizeof(DWORD),nil);
  FCipher.EncryptCFBblock(FUserKey[0],FUserKey[0],Length(FUserKey)*sizeof(DWORD));

  Result:=ArrayToString(FUserKey);
end;


function CreateSecretKey(SNumber:string;users:integer):string;
var
  s:string;
begin
  Result:=GetSecretKey(SNumber,users);
end;


end.
