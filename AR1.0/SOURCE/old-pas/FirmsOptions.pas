unit FirmsOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrls, Buttons,DCPcrypt2, DCPGost,
  DCPSHA1, DBCtrlsEh, ExtCtrls, ComCtrls,
  DB,Grids, DBGridEh;

type
  TfrmOptionsFirms = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    SpeedButton3: TSpeedButton;
    Label16: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    FEDRPOU: TEdit;
    Button1: TButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    sbPriorYear: TSpeedButton;
    sbNextYear: TSpeedButton;
    Label3: TLabel;
    sbPriorKvartal: TSpeedButton;
    sbNextKvartal: TSpeedButton;
    Year: TEdit;
    Kvartal: TEdit;
    GroupBox2: TGroupBox;
    Label19: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    DirName: TEdit;
    DirCod: TEdit;
    DirTell: TEdit;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ShiefName: TEdit;
    ShiefCod: TEdit;
    ShiefTell: TEdit;
    GroupBox4: TGroupBox;
    Label25: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label17: TLabel;
    EDRPOUPOD: TEdit;
    PODNAME: TEdit;
    PODCOD: TEdit;
    PODOBL: TEdit;
    VFO: TEdit;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    edFIRMS: TEdit;
    DBGridEh1: TDBGridEh;
    DBGridEh2: TDBGridEh;
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbPriorYearClick(Sender: TObject);
    procedure sbNextYearClick(Sender: TObject);
    procedure sbPriorKvartalClick(Sender: TObject);
    procedure sbNextKvartalClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure RefreshAll;
  public
    { Public declarations }
  end;

var
  frmOptionsFirms: TfrmOptionsFirms;

implementation

uses fConfigStorage, fDM8DR, crypto_keys;

{$R *.dfm}

procedure TfrmOptionsFirms.SpeedButton3Click(Sender: TObject);
begin
  Firms.EDRPOUPOD:=EDRPOUPOD.Text;
  Firms.BOSSNAME:=DirName.Text;
  Firms.BOSSCOD:=DirCod.Text;
  Firms.BOSSTELL:=DirTell.Text;
  Firms.SHIEFNAME:=ShiefName.Text;
  Firms.SHIEFCOD:=ShiefCod.Text;
  Firms.SHIEFTELL:=ShiefTell.Text;
  Firms.EDRPOUPOD:=EDRPOUPOD.Text;
  firms.PODNAME:=PODNAME.Text;
  firms.CODPOD:=PODCOD.Text;
  Firms.CODOBL:=PODOBL.Text;
  dmFunction.CurrentDate:=StrToDate('01.'+IntToStr(StrToInt(Kvartal.Text)*3)+'.'
                          +Year.Text);
  Close;
end;

procedure TfrmOptionsFirms.FormCreate(Sender: TObject);
begin
  Year.Text:=IntToStr(dmFunction.CurrentYear);
  Kvartal.Text:=IntToStr(dmFunction.CurrentPeriod);
  edFIRMS.Text:=Firms.FirmName;
  FEDRPOU.Text:=Firms.EDRPOU;
  RefreshAll;
end;

procedure TfrmOptionsFirms.sbPriorYearClick(Sender: TObject);
begin
  if StrToInt(Year.Text)>1999 then
    Year.Text:=IntToStr(StrToInt(Year.Text)-1);
  dmFunction.CurrentDate:=StrToDate('01.'+IntToStr(StrToInt(Kvartal.Text)*3)+'.'
                          +Year.Text);
end;

procedure TfrmOptionsFirms.sbNextYearClick(Sender: TObject);
begin
  if StrToInt(Year.Text)<2999 then
    Year.Text:=IntToStr(StrToInt(Year.Text)+1);
  dmFunction.CurrentDate:=StrToDate('01.'+IntToStr(StrToInt(Kvartal.Text)*3)+'.'
                          +Year.Text);
end;

procedure TfrmOptionsFirms.sbPriorKvartalClick(Sender: TObject);
begin
  if StrToInt(Kvartal.Text)>1 then
    Kvartal.Text:=IntToStr(StrToInt(Kvartal.Text)-1);
  dmFunction.CurrentDate:=StrToDate('01.'+IntToStr(StrToInt(Kvartal.Text)*3)+'.'
                          +Year.Text);
end;

procedure TfrmOptionsFirms.sbNextKvartalClick(Sender: TObject);
begin
  if StrToInt(Kvartal.Text)<4 then
    Kvartal.Text:=IntToStr(StrToInt(Kvartal.Text)+1);
  dmFunction.CurrentDate:=StrToDate('01.'+IntToStr(StrToInt(Kvartal.Text)*3)+'.'
                          +Year.Text);
end;

procedure TfrmOptionsFirms.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmOptionsFirms.RefreshAll;
begin
  if Firms.TFO=0 then
    VFO.Text:='Юридична'
  else
    VFO.Text:='Фізична';
  DirName.Text:=Firms.BOSSNAME;
  DirCod.Text:=Firms.BOSSCOD;
  DirTell.Text:=Firms.BOSSTELL;
  ShiefName.Text:=Firms.SHIEFNAME;
  ShiefCod.Text:=Firms.SHIEFCOD;
  ShiefTell.Text:=Firms.SHIEFTELL;
  EDRPOUPOD.Text:=Firms.EDRPOUPOD;
  PODNAME.Text:=firms.PODNAME;
  PODCOD.Text:=firms.CODPOD;
  PODOBL.Text:=Firms.CODOBL;
end;

end.
