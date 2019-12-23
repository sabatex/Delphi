unit fDataModule;

interface

uses
  SysUtils, Classes, DB, DBTables, DCPcrypt2, DCPGost, DCPSha1,
  FIBDatabase, pFIBDatabase, FIBDataSet, pFIBDataSet;

type
  TdmFunction = class(TDataModule)
    DataBase: TpFIBDatabase;
    PROGRAMM_PRODUCT: TpFIBDataSet;
    Transaction: TpFIBTransaction;
    VERSION_PRODUCTS: TpFIBDataSet;
    PROGRAMM_PRODUCTID: TFIBIntegerField;
    PROGRAMM_PRODUCTPRODUCT_NAME: TFIBStringField;
    VERSION_PRODUCTSID: TFIBIntegerField;
    VERSION_PRODUCTSVERSION_PRG: TFIBStringField;
    VERSION_PRODUCTSKEY_E: TBlobField;
    VERSION_PRODUCTSKEY_D: TBlobField;
    VERSION_PRODUCTSKEY_N: TBlobField;
    VERSION_PRODUCTSPROGRAMM_PRODUCTS_ID: TFIBIntegerField;
    VERSION_PRODUCTSSOURCE_PATH: TFIBStringField;
    VERSION_PRODUCTSCOUNT_PROD: TFIBIntegerField;
    dsPROGRAMM_PRODUCT: TDataSource;
    FIRMS: TpFIBDataSet;
    PROD: TpFIBDataSet;
    FIRMSID: TFIBIntegerField;
    FIRMSIDFIZ: TFIBIntegerField;
    FIRMSEDRPOU: TFIBStringField;
    FIRMSWUSER: TFIBStringField;
    FIRMSCOMPANY_ADDRESS: TFIBStringField;
    FIRMSCOMPANY_NAME: TFIBStringField;
    FIRMSEMAIL: TFIBStringField;
    VERSION_PRODUCTSPRODUCT_NAME: TStringField;
    PROGRAMM_PRODUCTCOUNT_PROD: TFIBIntegerField;
    PRODID: TFIBIntegerField;
    PRODFIRMS_ID: TFIBIntegerField;
    PRODPRODUCT_ID: TFIBIntegerField;
    PRODVERSION_ID: TFIBIntegerField;
    PRODDATE_PAY: TDateField;
    PRODLICENZE: TFIBIntegerField;
    PRODUSER_KEY: TBlobField;
    PRODKEY_NAME: TFIBStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure ClientBaseAfterScroll(DataSet: TDataSet);
    procedure PROGRAMM_PRODUCTNewRecord(DataSet: TDataSet);
    procedure VERSION_PRODUCTSAfterInsert(DataSet: TDataSet);
  private
    { Private declarations }
  public
    //procedure CreateKey;
    //procedure EncriptKey(FileName: string; Key8DR: T8DRKey);
    //function DecriptKey(FileName: string): T8DRKey;
  end;

var
  dmFunction: TdmFunction;

implementation

uses fSplash, fLogin, fKeyGen, FGInt, fMain;
{$R *.dfm}
{
procedure TdmFunction.CreateKey;
var
 Key:T8DRKey;
begin
 { if not (ClientBase.State in [dsEdit,dsInsert]) then
   ClientBase.Edit;
  ClientBaseDateCreate.Value:=Now;
  ClientBase.Post;
  Key.DateCreate:=ClientBaseDateCreate.Value;
  Key.DatePay:=ClientBaseDatepay.Value;
  Key.FirmName:=ClientBaseFirm.Value;
  Key.Diller:=DillerDillerName.Value;
  Key.FirmEDRPOU:=ClientBaseFirmEDRPOU.Value;
  Key.FirmID:=ClientBaseID.Value;
  Key.FirmEDRPOU:=ClientBaseFirmEDRPOU.Value;
  Key.DillerID:=DillerID.Value;
  EncriptKey('Key' + IntToStr(ClientBaseId.Value)+'.des',Key);
  frmMain.GetKeyState('Key'+IntToStr(ClientBaseId.Value)+'.des');
end;}

procedure TdmFunction.DataModuleCreate(Sender: TObject);
begin
  // Подключение к базе
  TfrmSplash.ShowSplash('Connected to InterBase ...');
  DataBase.Close;
  with IBLogin do
  begin
    if ServerName<>'' then
      DataBase.DatabaseName:=ServerName + ':' + DataBasePath
    else
      DataBase.DatabaseName:=DataBasePath;
    DataBase.ConnectParams.UserName:=UserName;
    DataBase.ConnectParams.Password:=Password;
    DataBase.ConnectParams.CharSet:='WIN1251';
    DataBase.ConnectParams.RoleName:=UserName;
  end;
  try
    DataBase.Open;
  except
    raise Exception.Create('Невозможно соединится с базой. Проверьте пароль.');
  end;

  PROGRAMM_PRODUCT.Open;
  VERSION_PRODUCTS.Open;
  FIRMS.Open;
  PROD.Open;


end;
{
function TdmFunction.DecriptKey(FileName: string): T8DRKey;
var
  Hash:TDCP_sha1;
  Decrypt:TDCP_gost;
  Sourse:file;
  HashDigest,HashRead:array[0..31] of byte;
  Read,temp:integer;

begin
  // перевірка на існування регістраційного файла
  //FileName:=FileName + '.des';
  if not FileExists(FileName) then
    raise Exception.Create('Непредвиденная ошибка, отсутствует файл ключа');
  AssignFile(Sourse,FileName);
  Reset(Sourse,1);
  BlockRead(Sourse,Result,Sizeof(result),Read);
  {$IFDEF CLIENT8DR}
  // for client
{  Result.LastAcces:=Now;
  Result.WindowsVersion:=GetWindowsVersion;
  Result.DiskFree:=DiskFree(3) div 1024;
  Result.VersionClient:='1.0.0.0';
  Result.MemorySize:=16000;
  BlockWrite(Sourse,Result,Read);
  {$ENDIF}

  // Инициализация секретного ключа
 { FillChar(HashDigest,Sizeof(HashDigest),$ff);
  Hash:=TDCP_sha1.Create(Self);
  Hash.Init;
  Hash.UpdateStr(DesKey);
  Hash.Final(HashDigest);
  Hash.Free;

  // Инициализация дешифратора
  Decrypt:=TDCP_gost.Create(Self);
  if (Sizeof(HashDigest)*8)>Decrypt.MaxKeySize then
    Decrypt.Init(HashDigest,Decrypt.MaxKeySize,nil)
  else
    Decrypt.Init(HashDigest,SizeOf(HashDigest)*8,nil);

   // Дешифрация ключа
   Decrypt.DecryptCBC(Result.Buffer,Result.Buffer,MaxSizeKey);
   Decrypt.Burn;
   CloseFile(Sourse);
end;

{
procedure TdmFunction.EncriptKey(FileName: string; Key8DR: T8DRKey);
var
  Hash:TDCP_sha1;
  Decrypt:TDCP_gost;
  Sourse:file;
  HashDigest,HashRead:array[0..31] of byte;
  Read,temp:integer;
begin
  Key8DR.Signature:=DesKeySignature;
  Key8DR.Copyrigth:=Copyrigrth;
  Key8DR.Version:=VersionDesKey;
  //FileName:=FileName + '.des';
  AssignFile(Sourse,FileName);
  Rewrite(Sourse,1);

  // Инициализация секретного ключа
  FillChar(HashDigest,Sizeof(HashDigest),$ff);
  Hash:=TDCP_sha1.Create(Self);
  Hash.Init;
  Hash.UpdateStr(DesKey);
  Hash.Final(HashDigest);
  Hash.Free;

  // Инициализация дешифратора
  Decrypt:=TDCP_gost.Create(Self);
  if (Sizeof(HashDigest)*8)>Decrypt.MaxKeySize then
    Decrypt.Init(HashDigest,Decrypt.MaxKeySize,nil)
  else
    Decrypt.Init(HashDigest,SizeOf(HashDigest)*8,nil);
  // Шифрация ключа
  Decrypt.EncryptCBC(key8DR.Buffer,key8Dr.Buffer,MaxSizeKey);                      // read from the source encrypt and write out the result
  BlockWrite(Sourse,key8DR,sizeof(key8DR));
  Decrypt.Burn;                                                  // burn the key data (note: don't free it as we placed it on the form at design time)
  CloseFile(Sourse);
end;
}
procedure TdmFunction.ClientBaseAfterScroll(DataSet: TDataSet);
begin
  //frmMain.GetKeyState('Key'+IntToStr(ClientBaseId.Value)+'.des');
end;

procedure TdmFunction.PROGRAMM_PRODUCTNewRecord(DataSet: TDataSet);
var
  s:string;
begin
{  frmKeyGen:=TfrmKeyGen.Create(self);
  frmKeyGen.State:='Створення основного ключа програмного продукту';
  frmKeyGen.ShowModal;
  FGIntToPGPMPI(frmKeyGen.PrimeKey,s);
  frmKeyGen.Free;
  PROGRAMM_PRODUCTKEY_P.Value:=s; }
end;

procedure TdmFunction.VERSION_PRODUCTSAfterInsert(DataSet: TDataSet);
begin
  VERSION_PRODUCTSPROGRAMM_PRODUCTS_ID.Value:=PROGRAMM_PRODUCTID.Value;
end;

end.
