unit fFirms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fCustomForm, fcdbtreeview, Menus, DB, FIBDataSet, pFIBDataSet,
  ComCtrls, dxtree, dxdbtree;

type
  TfrmFirms = class(TForm)
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    dsFirms: TDataSource;
    N2: TMenuItem;
    dxDBTreeView1: TdxDBTreeView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFirms: TfrmFirms;

implementation

uses fMain, fDataModule;

{$R *.dfm}

end.
