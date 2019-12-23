unit fFirmsEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DBCtrls, DB, Mask;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    DBEdit1: TDBEdit;
    DataSource: TDataSource;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    Label4: TLabel;
    DBEdit5: TDBEdit;
    Label5: TLabel;
    DBRadioGroup1: TDBRadioGroup;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
procedure NewFirm;

var
  Form1: TForm1;

implementation

uses fDataModule,fConfigStorage,FormManager;

{$R *.dfm}

procedure NewFirm;
begin
  dmFunction.FIRMS.Insert;
  Form1:=ShowForm(TForm1,'¬вод новой фирмы',ftModal) as TForm1;
  if Form1.ModalResult=mrOk then
    dmFunction.FIRMS.Post
  else
    dmFunction.FIRMS.Cancel;
  Form1.Free;
end;

end.
