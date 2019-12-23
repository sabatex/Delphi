unit fConfigStorage;
interface
// для хранения INI файлов в базе ввести определение INIBLOB
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls,ComCtrls, ToolWin, inifiles, DCPblockciphers,
  DCPHaval, Variants, DCPgost, DCPBase64;

type
  TConfig = class(TObject)
  private
    EKey:string;
    DKey:string;
    function GetDistrSerial: string;
    procedure SetDistrSerial(const Value: string);
    function GetFromIni(ParName: string): string;
    procedure SetToIni(ParName, Value: string);
    function GetInternalSerial: string;
    function GetEtalonSerial: string;
    function HashKey(Value: string): string;
    function GetRegSerial: string;
  public
    constructor Create(ekey:string='';dkey:string='');reintroduce;virtual;

    property DistrSerial:string read GetDistrSerial write SetDistrSerial;
    property InternalSerial:string read GetInternalSerial;
    property EtalonSerial:string read GetEtalonSerial;
    property RegSerial:string read GetRegSerial;
  end;


  TConfigSave = class(TObject)
  private
    FIniFile:TIniFile;
    FComputerName:string;
    FNTUserName:string;
    FCipher: TDCP_blockcipher64;
    FHash: TDCP_haval;
    FHashKey:array[0..31] of byte;
    FCryptKey: string;
    FStorageName: string;
    procedure SetCryptKey(const Value: string);
    procedure SetStorageName(const Value: string);
    function DefaultIniName:string;
    function GetStartDir: string;
  public
    constructor Create;reintroduce;virtual;
    destructor Destroy;override;
    procedure SaveValue(Section:string;Value:Variant; Crypt:boolean = false);
    function LoadValue(Section:string;Default:Variant; Decrypt:boolean = false):Variant;
    procedure LoadSection(const Section: String; Strings: TStrings);
    property CryptKey:string read FCryptKey write SetCryptKey;
    property ComputerName:string read FComputerName write FComputerName;
    property CurrentUserName:string read FNTUserName write FNTUserName;
    property StorageName:string read FStorageName write SetStorageName;
    property INIFile:TIniFile read FIniFile;
    property StartDir:string read GetStartDir;
end;


var
  // Центральное хранилище параметров программы
  ConfigStorage:TConfigSave;

implementation
uses QLowLevelFunction, ntics_classes, crypto_keys;

constructor TConfigSave.Create;
begin
  inherited Create;
  // Определение имени текущего компютера
  FComputerName:=GetLocalHostShort;
  // Определение имени текущего пользователя
  FNTUserName:=GetCurrentUserName;
  // Инициализация INI файла
  StorageName:= ExtractFilePath(Application.ExeName) + DefaultIniName;
  // Значение криптоключа по умолчанию
  CryptKey:=ComputerName + CurrentUserName;

end;

function TConfigSave.DefaultIniName: string;
begin
  Result:=ExtractFileName(Application.ExeName);
  Result:=copy(Result,1,pos('.',Result))+'ini';
end;

destructor TConfigSave.Destroy;
begin
  inherited;
end;

function TConfigSave.GetStartDir: string;
begin
  Result:=ExtractFilePath(Application.ExeName);
end;

procedure TConfigSave.LoadSection(const Section: String;
  Strings: TStrings);
begin
  FIniFile:=TIniFile.Create(FStorageName);
  FIniFile.ReadSectionValues(Section,Strings);
  FIniFile.Free;
end;

function TConfigSave.LoadValue(Section:string; Default:Variant; Decrypt: boolean = false): Variant;
var
  s:string;
begin
  FIniFile:=TIniFile.Create(FStorageName);
  s:=FIniFile.ReadString(FNTUserName,Section,Default);
  if Decrypt then
    if s<>'' then
    begin
      s:=Base64DecodeStr(s);
      FCipher:=TDCP_gost.Create(nil);
      FCipher.Init(FHashKey,sizeof(FHashKey),nil);
      FCipher.DecryptCFBblock(s[1],s[1],Length(s));
    end;
  Result:=s;
  FIniFile.Free;
end;

procedure TConfigSave.SaveValue(Section:string;Value:Variant; Crypt: boolean = false);
var
  s:string;
begin
  FIniFile:=TIniFile.Create(FStorageName);
  s:=Value;
  if Crypt then
  begin
    FCipher:=TDCP_gost.Create(nil);
    FCipher.Init(FHashKey,sizeof(FHashKey),nil);
    FCipher.EncryptCFBblock(s[1],s[1],Length(s));
    s:=Base64EncodeStr(s);
  end;
  FIniFile.WriteString(FNTUserName,Section,s);
  FIniFile.Free;
end;

procedure TConfigSave.SetCryptKey(const Value: string);
begin
  FCryptKey := Value;
  // Инициализация секретного ключа
  FillChar(FHashKey,Sizeof(FHashKey),$ff);
  FHash:=TDCP_haval.Create(nil);
  FHash.Init;
  FHash.UpdateStr(FComputerName + FNTUserName);
  FHash.Final(FHashKey);
  FHash.Free;
end;

procedure TConfigSave.SetStorageName(const Value: string);
begin
  FStorageName := Value;
end;

{ TConfig }
constructor TConfig.Create(ekey:string='';dkey:string='');
begin
  EKey:=ekey;
  DKey:=dkey;
end;

function TConfig.GetDistrSerial: string;
begin
  Result:=GetFromIni('DISTR_SERIAL');
end;

procedure TConfig.SetDistrSerial(const Value: string);
begin
  SetToIni('OPTIONS',Value);
end;

function TConfig.GetFromIni(ParName: string): string;
var
  INIFile:TIniFile;
begin
  INIFile:=TIniFile.Create(ConfigStorage.StorageName);
  Result:=INIFile.ReadString('OPTIONS',ParName,'');
  INIFile.Free;
end;

procedure TConfig.SetToIni(ParName, Value: string);
var
  INIFile:TIniFile;
begin
  INIFile:=TIniFile.Create(ConfigStorage.StorageName);
  INIFile.WriteString('OPTIONS',ParName,Value);
  INIFile.Free;
end;

function TConfig.HashKey(Value:string):string;
var
  FHashKey:TDWORDArray;
  FHash: TDCP_haval;
begin
  // Создание хеша секретного ключа
  FillChar(FHashKey[0],Length(FHashKey)*sizeof(DWORD),$ffffffff);
  FHash:=TDCP_haval.Create(nil);
  FHash.Init;
  FHash.UpdateStr(Value);
  FHash.Final(FHashKey[0]);
  FHash.Free;
  Result:=ArrayToString(FHashKey);
end;


function TConfig.GetInternalSerial: string;
begin
  Result:=HashKey(GetSerialNumberHDD);
end;

function TConfig.GetEtalonSerial: string;
begin
  Result:=HashKey('TEST');
end;

function TConfig.GetRegSerial: string;
var
  a,b:TDWORDArray;
  i:integer;
begin
  a:=StringToArray(InternalSerial);
  b:=StringToArray(DistrSerial);
  for i:=0 to 4 do
  begin
    a[i]:=a[i] xor $aaaaaaaa;
    b[i]:=b[i] xor $aaaaaaaa;
  end;
  Result:=ArrayToString(a)+'-'+ArrayToString(b);
end;

initialization
  ConfigStorage:=TConfigSave.Create;

finalization
  ConfigStorage.Free;

end.
