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
    KeyState.Lines.Add('���� �����������.')
  else
  begin
    key:=DecriptKey(FileName);
    KeyState.Lines.Add(' ���������� ��� ������� ');
    KeyState.Lines.Add('-------------------------------------');
    KeyState.Lines.Add('Signature: ' + key.Signature);
    KeyState.Lines.Add('Copyrigth: ' + key.Copyrigth);
    KeyState.Lines.Add('��������� ������ ���������: ' + DateTimeToStr(key.LastAcces));
    KeyState.Lines.Add('������ Windows: ' + key.WindowsVersion);
    KeyState.Lines.Add('������ ����������� ������: ' + IntToStr(key.MemorySize) + '��');
    KeyState.Lines.Add('�������� �� �����: ' + IntToStr(key.DiskFree) + '��');
    KeyState.Lines.Add('������ ���������: ' + key.VersionClient);
    KeyState.Lines.Add(' ');
    KeyState.Lines.Add('  ���������� ��� ���� ');
    KeyState.Lines.Add('-------------------------------------');
    KeyState.Lines.Add('������ �����: ' + IntToStr(Key.Version));
    KeyState.Lines.Add('���� ��������: ' + DateToStr(key.DateCreate));
    KeyState.Lines.Add('���� ��������: ' + DateToStr(key.DatePay));
    KeyState.Lines.Add('�����: ' + key.FirmName);
    KeyState.Lines.Add('������: ' + key.Diller);
    KeyState.Lines.Add('������: ' + key.FirmEDRPOU);
    KeyState.Lines.Add('����� ����� �� �������: ' + IntToStr(key.FirmID));
    KeyState.Lines.Add('����� ������� �� �������: ' + IntToStr(key.DillerID));
  end; }
end;

procedure TfrmMain.btDillerClick(Sender: TObject);
begin
  frDillers:=ShowForm(TfrDillers,'�������',ftModal) as TfrDillers;
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
  ShowForm(TfrmProductsV,'����������� ���������',ftMDI);
end;

procedure TfrmMain.PayProgrammExecute(Sender: TObject);
begin
  PayNew;
end;

procedure TfrmMain.ShowFirmsExecute(Sender: TObject);
begin
  ShowForm(TfrmFirms,'�����',ftMDI);
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
