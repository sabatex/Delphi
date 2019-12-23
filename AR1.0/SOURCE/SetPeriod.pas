unit SetPeriod;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfrmSetPeriod = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Year: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Kvartal: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSetPeriod: TfrmSetPeriod;

implementation
uses dateutils, fDM8DR;
{$R *.dfm}


procedure TfrmSetPeriod.FormCreate(Sender: TObject);
begin
  Year.Text:=IntToStr(dmFunction.CurrentYear);
  Kvartal.Text:=IntToStr(dmFunction.CurrentPeriod);
end;

end.
