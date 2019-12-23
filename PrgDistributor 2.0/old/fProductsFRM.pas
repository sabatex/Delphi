unit fProductsFRM;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fCustomForm, fcdbtreeview, Menus, DB;

type
  TfrmProductsV = class(TForm)
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    fcDBTreeView1: TfcDBTreeView;
    dsPROGRAMM_PRODUCT: TDataSource;
    dsVERSION_PRODUCTS: TDataSource;
    N6: TMenuItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProductsV: TfrmProductsV;

implementation

uses fMain, fDataModule;

{$R *.dfm}

end.
