unit fPayProduct;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, FIBDataSet, DBCtrlsEh, pFIBDataSet, StdCtrls, Mask,
  DBLookupEh, DBCtrls,FGInt, Buttons;

type
  TfrmPayProducts = class(TForm)
    DBLookupComboboxEh1: TDBLookupComboboxEh;
    Label1: TLabel;
    Label2: TLabel;
    DBDateTimeEditEh1: TDBDateTimeEditEh;
    dsPROD: TDataSource;
    dsFIRMS: TDataSource;
    Button1: TButton;
    Button2: TButton;
    DBNumberEditEh1: TDBNumberEditEh;
    SaveDialog1: TSaveDialog;
    DBEditEh1: TDBEditEh;
    procedure DBEditEh1EditButtons0Click(Sender: TObject;
      var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure PayNew;

var
  frmPayProducts: TfrmPayProducts;

implementation

uses fDataModule,crypto_keys,ntics_classes,KeyGen;

{$R *.dfm}

procedure PayNew;
var
  d,n,e:TFGInt;
  temp:TSecretKey;
begin
  with dmFunction do
  begin
    PROD.Insert;
    PRODPRODUCT_ID.Value:=PROGRAMM_PRODUCTID.Value;
    PRODVERSION_ID.Value:=VERSION_PRODUCTSID.Value;
  end;
  frmPayProducts:=TfrmPayProducts.Create(nil);
  if frmPayProducts.ShowModal = mrOk then
  begin
    Base10StringToFGInt(dmFunction.VERSION_PRODUCTSKEY_D.Value,d);
    Base10StringToFGInt(dmFunction.VERSION_PRODUCTSKEY_N.Value,n);
    Base10StringToFGInt(dmFunction.VERSION_PRODUCTSKEY_E.Value,e);
    temp.EDRPOU:=dmFunction.FIRMSEDRPOU.Value;
    //temp.WUSER:=dmFunction.FIRMSWUSER.Value;
    temp.COMPANY_NAME:=dmFunction.FIRMSCOMPANY_NAME.Value;
    temp.ID_FIZ:=dmFunction.FIRMSIDFIZ.Value;
    temp.LICENZE:=dmFunction.PRODLICENZE.Value;
    dmFunction.PRODUSER_KEY.Value:=MakeKey(temp,E,N);
    dmFunction.PRODUSER_KEY.SaveToFile(dmFunction.PRODKEY_NAME.Value);
    temp:=DecryptKey(dmFunction.PRODUSER_KEY.Value,D,N);
    if temp.EDRPOU <> dmFunction.FIRMSEDRPOU.Value then
      raise Exception.Create('Error key');
    dmFunction.PROD.Post;
  end
  else
    dmFunction.PROD.Cancel;
  frmPayProducts.Free;
end;


procedure TfrmPayProducts.DBEditEh1EditButtons0Click(Sender: TObject;
  var Handled: Boolean);
begin
  if SaveDialog1.Execute then
    DBEditEh1.Value:=SaveDialog1.FileName; 
end;

end.
