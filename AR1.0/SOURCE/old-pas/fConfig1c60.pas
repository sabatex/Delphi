unit fConfig1c60;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, frameCustomGrid, ExtCtrls, DB;

type
  TfrmConfig1c60 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    frCustomGrid1: TfrCustomGrid;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Label2: TLabel;
    frCustomGrid3: TfrCustomGrid;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfig1c60: TfrmConfig1c60;

implementation

uses fDM8DR;

{$R *.dfm}

end.
