unit personal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, default_grid, DB, Grids, DBGridEh, ExtCtrls, StdCtrls,
  FIBDataSet, pFIBDataSet, ComCtrls, Buttons, DBCtrls;

type
  TfrmPersonal = class(TfrmGrid_def)
    Panel1: TPanel;
    OldWokers: TCheckBox;
    PERSONAL: TpFIBDataSet;
    PERSONALID: TFIBIntegerField;
    PERSONALPERSONAL_NR: TFIBIntegerField;
    PERSONALPERSONAL_NAME: TFIBStringField;
    PERSONALDATE_IN: TFIBDateField;
    PERSONALDATE_OUT: TFIBDateField;
    PERSONALFIRMS_ID: TFIBIntegerField;
    PERSONALTIN: TFIBStringField;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PERSONALBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public

  end;

var
  frmPersonal: TfrmPersonal;

implementation

uses dm_base,ntics_storage, ntics_classes, DBGrids;

{$R *.dfm}

procedure TfrmPersonal.FormShow(Sender: TObject);
begin
  if ntics_classes.ApplicationState = asRun then
    PERSONAL.ParamByName('ID_FIRM').Value:=dmBase.FirmsID.Value
  else
    PERSONAL.ParamByName('ID_FIRM').Value:=NetStorage.ReadInteger(Name,'FIRMID',0);
  PERSONAL.Open;
  inherited;
end;

procedure TfrmPersonal.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if ntics_classes.ApplicationState = asClose then
    NetStorage.WriteInteger(name,'FIRMID',PERSONAL.ParamByName('ID_FIRM').Value);
end;

procedure TfrmPersonal.PERSONALBeforePost(DataSet: TDataSet);
begin
  PERSONALFIRMS_ID.Value:=PERSONAL.ParamByName('ID_FIRM').Value;
end;

end.
