unit fProducts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fCustomForm, StdCtrls, Mask, DBCtrls,db, DBCtrlsEh;

type
  TfrmProducts = class(TForm)
    Product: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    SourcePath: TDBEditEh;
    SaveDialog1: TSaveDialog;
    dsPROGRAMM_PRODUCT: TDataSource;
    dsVERSION_PRODUCTS: TDataSource;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DBEditEh1EditButtons0Click(Sender: TObject;
      var Handled: Boolean);
  private
    { Private declarations }
  public

  end;

procedure NewProduct;
procedure NewVersionWithNewKey;
procedure NewVersionWithPreviosKey;
procedure EditProduct;

var
  frmProducts: TfrmProducts;

implementation

uses fDataModule, fKeyGen, FGInt, FGIntPrimeGeneration, FGIntRSA;

{$R *.dfm}


procedure GenerateKey(var n,e,d:TFGInt);
var
  p, q,p1,q1,m,one, two, gcd, temp : TFGInt;
  test1,test2:string;
  i:integer;
begin
  // генеруємо ключi P,Q
  frmKeyGen:=TfrmKeyGen.Create(Application);
  frmKeyGen.State:='Створення основного ключа програмного продукту';
  frmKeyGen.ShowModal;
  FGIntCopy(frmKeyGen.PrimeKey,p);
  frmKeyGen.Free;
  Randomize;
  FGIntMulByInt(p,q,Random(MaxInt));
  PrimeSearch(q);

   // визначаємо n та phi
  FGIntMul(p,q,n);
  Base10StringToFGInt('1', one);
  Base10StringToFGInt('2', two);
  FGIntSub(p,one,p1);
  FGIntSub(q,one,q1);
  FGIntMul(p1,q1,m);

  // шукаємо  ключ d
  Base10StringToFGInt('12346637823892372376932598098034528775',d);
  FGIntGCD(m,d,gcd);

  While FGIntCompareAbs(gcd, one) <> Eq Do
  Begin
      FGIntadd(d, two, temp);
      FGIntCopy(temp, d);
      FGIntGCD(m, d, gcd);
  End;

  // Створюємо ключ e
  FGIntModInv(d, m, e);
  FGIntDestroy(one);
  FGIntDestroy(two);
  FGIntDestroy(gcd);
  FGIntDestroy(p);
  FGIntDestroy(q);
  FGIntDestroy(m);
  FGIntDestroy(temp);
  //Тестуємо ключі
  test1:='Test string';
  RSAEncrypt(test1,d,n,test2);
  RSADecrypt(test2,e,n,temp,temp,temp,temp,test2);
  if test1<>test2 then
    raise Exception.Create('Error keys');

end;

procedure NewProduct;
var
  s:string;
  n,e,d : TFGInt;

begin
  dmFunction.PROGRAMM_PRODUCT.Insert;
  dmFunction.PROGRAMM_PRODUCT.Post;
  dmFunction.PROGRAMM_PRODUCT.Edit;
  dmFunction.VERSION_PRODUCTS.Insert;
  GenerateKey(n,e,d);

  // зберігаемо ключі
  FGIntToBase10String(e,s);
  dmFunction.VERSION_PRODUCTSKEY_E.Value:=s;
  FGIntToBase10String(n,s);
  dmFunction.VERSION_PRODUCTSKEY_N.Value:=s;
  FGIntToBase10String(d,s);
  dmFunction.VERSION_PRODUCTSKEY_D.Value:=s;

  FGIntDestroy(n);
  FGIntDestroy(e);
  FGIntDestroy(d);

  frmProducts:=TfrmProducts.Create(Application);
  frmProducts.ShowModal;
  frmProducts.Free;
end;

procedure NewVersionWithNewKey;
var
  s:string;
  n,e,d : TFGInt;

begin
  dmFunction.VERSION_PRODUCTS.Insert;
  GenerateKey(n,e,d);

  // зберігаемо ключі
  FGIntToBase10String(e,s);
  dmFunction.VERSION_PRODUCTSKEY_E.Value:=s;
  FGIntToBase10String(n,s);
  dmFunction.VERSION_PRODUCTSKEY_N.Value:=s;
  FGIntToBase10String(d,s);
  dmFunction.VERSION_PRODUCTSKEY_D.Value:=s;

  FGIntDestroy(n);
  FGIntDestroy(e);
  FGIntDestroy(d);

  frmProducts:=TfrmProducts.Create(Application);
  frmProducts.Product.ReadOnly:=true;
  frmProducts.ShowModal;
  frmProducts.Free;
end;

procedure NewVersionWithPreviosKey;
var
  n,e,d : string;

begin
  n:=dmFunction.VERSION_PRODUCTSKEY_N.Value;
  e:=dmFunction.VERSION_PRODUCTSKEY_E.Value;
  d:=dmFunction.VERSION_PRODUCTSKEY_D.Value;
  dmFunction.VERSION_PRODUCTS.Insert;
  // зберігаемо ключі
  dmFunction.VERSION_PRODUCTSKEY_E.Value:=e;
  dmFunction.VERSION_PRODUCTSKEY_N.Value:=n;
  dmFunction.VERSION_PRODUCTSKEY_D.Value:=d;

  frmProducts:=TfrmProducts.Create(Application);
  frmProducts.Product.ReadOnly:=true;
  frmProducts.ShowModal;
  frmProducts.Free;
end;


procedure EditProduct;
begin
  frmProducts:=TfrmProducts.Create(Application);
  frmProducts.Product.ReadOnly:=true;
  frmProducts.ShowModal;
  frmProducts.Free;
end;


{ TfrmProducts }
procedure TfrmProducts.Button2Click(Sender: TObject);
begin
  dmFunction.VERSION_PRODUCTS.Cancel;
  dmFunction.PROGRAMM_PRODUCT.Cancel;
  Close;
end;

procedure TfrmProducts.Button1Click(Sender: TObject);
var
  f:TextFile;
begin
  if dmFunction.PROGRAMM_PRODUCT.State in [dsInsert,dsEdit] then
    dmFunction.PROGRAMM_PRODUCT.Post;
  if dmFunction.VERSION_PRODUCTS.State in [dsInsert,dsEdit] then
    dmFunction.VERSION_PRODUCTS.Post;
  if dmFunction.VERSION_PRODUCTSSOURCE_PATH.Value<>'' then
  begin
    AssignFile(f,dmFunction.VERSION_PRODUCTSSOURCE_PATH.Value);
    Rewrite(f);
    writeln(f,'unit enKey;');
    writeln(f);
    writeln(f,'interface');
    writeln(f);
    writeln(f,'const');
    writeln(f,'  dkey:string = (''' + dmFunction.VERSION_PRODUCTSKEY_D.Value + ''');');
    writeln(f,'  nkey:string = (''' + dmFunction.VERSION_PRODUCTSKEY_N.Value + ''');');
    writeln(f);
    writeln(f,'implementation');
    writeln(f);
    writeln(f,'end.');
    CloseFile(f);
  end;
  Close;
end;

procedure TfrmProducts.DBEditEh1EditButtons0Click(Sender: TObject;
  var Handled: Boolean);
begin
  if SaveDialog1.Execute then
    SourcePath.Text:=SaveDialog1.FileName;
end;

end.
