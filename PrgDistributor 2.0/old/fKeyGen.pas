unit fKeyGen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FGInt;

type
  TfrmKeyGen = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
  private
    P:TFGInt;
    function GetPrimeKey: TFGInt;
    procedure SetState(const Value: TCaption);
    { Private declarations }
  public
    property PrimeKey:TFGInt read GetPrimeKey;
    property State:TCaption write SetState;
  end;

var
  frmKeyGen: TfrmKeyGen;

implementation

uses FGIntPrimeGeneration;

{$R *.dfm}

procedure TfrmKeyGen.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  Label2.Caption:=IntToStr(length(Edit1.Text));
  if length(Edit1.Text)>=50 then
  Begin
    Edit1.Enabled:=false;
    Button1.Visible:=True;
  end ;
end;

procedure TfrmKeyGen.Button1Click(Sender: TObject);
begin
  Button1.Visible:=False;
  Base256StringToFGInt(Edit1.Text,P);
  PrimeSearch(P);
  Close;
end;

function TfrmKeyGen.GetPrimeKey: TFGInt;
begin
  Result:=P;
end;

procedure TfrmKeyGen.SetState(const Value: TCaption);
begin
  Caption:=Value;
end;

end.
