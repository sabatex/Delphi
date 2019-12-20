unit fGauge;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TfrmGauge = class(TForm)
    Panel1: TPanel;
    Gauge: TProgressBar;
    procedure FormDeactivate(Sender: TObject);
  private
    function GetMin: integer;
    procedure SetMin(const Value: integer);
    function GetMax: integer;
    procedure SetMax(const Value: integer);
    function GetPosition: integer;
    procedure SetPosition(const Value: integer);
    { Private declarations }
  public
    property Min:integer read GetMin write SetMin;
    property Max:integer read GetMax write SetMax;
    property Position:integer read GetPosition write SetPosition;
    { Public declarations }
  end;

implementation
{$R *.dfm}

procedure TfrmGauge.FormDeactivate(Sender: TObject);
begin
  if Visible then SetFocus;
end;

function TfrmGauge.GetMax: integer;
begin
  Result:=Gauge.Max;
end;

function TfrmGauge.GetMin: integer;
begin
  Result:=Gauge.Min;
end;

function TfrmGauge.GetPosition: integer;
begin
  result:=Gauge.Position;
end;

procedure TfrmGauge.SetMax(const Value: integer);
begin
  Gauge.Max:=Value;
end;

procedure TfrmGauge.SetMin(const Value: integer);
begin
  Gauge.Min:=Value;
end;

procedure TfrmGauge.SetPosition(const Value: integer);
begin
  Gauge.Position:=Value;
end;

end.
