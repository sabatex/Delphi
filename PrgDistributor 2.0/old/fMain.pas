unit fMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,DCPcrypt2, DCPGost, DCPSHA1, ExtCtrls, DBCtrls, Grids, DBGrids, Db,
  DBTables,Mask, Buttons, DBCtrlsEh, DBLookupEh,
  ActnList, ActnMan, Menus,
  ToolWin, ActnCtrls;

{$DEFINE CLIENT8DR}
type
  TfrmMain = class(TForm)
    Panel4: TPanel;
    btDiller: TButton;
    btCrypt: TBitBtn;
    DBLookupComboBox1: TDBLookupComboBox;
    ActionManager1: TActionManager;
    AddProduct: TAction;
    AddVersionWithNewKey: TAction;
    AddVersionWithPreviosKey: TAction;
    DeleteVersion: TAction;
    aEditProduct: TAction;
    ActionToolBar1: TActionToolBar;
    ShowProducts: TAction;
    PayProgramm: TAction;
    ShowFirms: TAction;
    ANewFirms: TAction;
    DeleteFirm: TAction;
    procedure btDillerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AddProductExecute(Sender: TObject);
    procedure AddVersionWithNewKeyExecute(Sender: TObject);
    procedure AddVersionWithPreviosKeyExecute(Sender: TObject);
    procedure DeleteVersionExecute(Sender: TObject);
    procedure aEditProductExecute(Sender: TObject);
    procedure ShowProductsExecute(Sender: TObject);
    procedure PayProgrammExecute(Sender: TObject);
    procedure ShowFirmsExecute(Sender: TObject);
    procedure ANewFirmsExecute(Sender: TObject);
    procedure DeleteFirmExecute(Sender: TObject);
  private
    { Private declarations }
  public
    procedure GetKeyState(FileName:string);
  end;

var
  frmMain: TfrmMain;

implementation

uses fDillers, fDataModule, fProducts, fProductsFRM, fPayProduct, fFirms,
  fFirmsEdit,fConfigStorage, FormManager;


{$R *.DFM}

procedure TfrmMain.GetKeyState(FileName:string);
{var
 key:T8DRKey;}
begin
{  KeyState.Lines.Clear;
  if not FileExists(FileName) then
    KeyState.Lines.Add('Ключ отсутствует.')
  else
  begin
    key:=DecriptKey(FileName);
    KeyState.Lines.Add(' Информация про клиента ');
    KeyState.Lines.Add('-------------------------------------');
    KeyState.Lines.Add('Signature: ' + key.Signature);
    KeyState.Lines.Add('Copyrigth: ' + key.Copyrigth);
    KeyState.Lines.Add('Последний запуск программы: ' + DateTimeToStr(key.LastAcces));
    KeyState.Lines.Add('Версия Windows: ' + key.WindowsVersion);
    KeyState.Lines.Add('Размер оперативной памяти: ' + IntToStr(key.MemorySize) + 'кБ');
    KeyState.Lines.Add('Свободно на диске: ' + IntToStr(key.DiskFree) + 'кБ');
    KeyState.Lines.Add('Версия программы: ' + key.VersionClient);
    KeyState.Lines.Add(' ');
    KeyState.Lines.Add('  Информация про ключ ');
    KeyState.Lines.Add('-------------------------------------');
    KeyState.Lines.Add('Версия ключа: ' + IntToStr(Key.Version));
    KeyState.Lines.Add('Дата создания: ' + DateToStr(key.DateCreate));
    KeyState.Lines.Add('Дата проплаты: ' + DateToStr(key.DatePay));
    KeyState.Lines.Add('Фирма: ' + key.FirmName);
    KeyState.Lines.Add('Диллер: ' + key.Diller);
    KeyState.Lines.Add('ЄДРПОУ: ' + key.FirmEDRPOU);
    KeyState.Lines.Add('Номер фирмы по реестру: ' + IntToStr(key.FirmID));
    KeyState.Lines.Add('Номер диллера по реестру: ' + IntToStr(key.DillerID));
  end; }
end;

procedure TfrmMain.btDillerClick(Sender: TObject);
begin
  frDillers:=ShowForm(TfrDillers,'Диллеры',ftModal) as TfrDillers;
  frDillers.Free;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  WindowState:=wsMaximized;
end;

procedure TfrmMain.AddProductExecute(Sender: TObject);
begin
  NewProduct;
end;

procedure TfrmMain.AddVersionWithNewKeyExecute(Sender: TObject);
begin
  NewVersionWithNewKey;   
end;

procedure TfrmMain.AddVersionWithPreviosKeyExecute(Sender: TObject);
begin
  NewVersionWithPreviosKey;
end;

procedure TfrmMain.DeleteVersionExecute(Sender: TObject);
begin
  if not dmFunction.VERSION_PRODUCTS.IsEmpty then dmFunction.VERSION_PRODUCTS.Delete;
  if dmFunction.VERSION_PRODUCTS.IsEmpty then dmFunction.PROGRAMM_PRODUCT.Delete;
end;

procedure TfrmMain.aEditProductExecute(Sender: TObject);
begin
  EditProduct;
end;

procedure TfrmMain.ShowProductsExecute(Sender: TObject);
begin
  ShowForm(TfrmProductsV,'Продаваемые программы',ftMDI);
end;

procedure TfrmMain.PayProgrammExecute(Sender: TObject);
begin
  PayNew;
end;

procedure TfrmMain.ShowFirmsExecute(Sender: TObject);
begin
  ShowForm(TfrmFirms,'Фирмы',ftMDI);
end;

procedure TfrmMain.ANewFirmsExecute(Sender: TObject);
begin
  NewFirm;
end;

procedure TfrmMain.DeleteFirmExecute(Sender: TObject);
begin
  dmFunction.FIRMS.Delete;
end;

end.
