unit frameCustomGrid;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Grids, DBGridEh, ComCtrls, ToolWin, ActnList,DBgrids,
  ExtCtrls, StdCtrls, Mask, ImgList, AppEvnts, Menus,
  DBCtrls, PrnDbgeh, Buttons
  {$IFDEF FIB}, pFIBDataSet {$ENDIF};

type
  TfrCustomGrid = class(TFrame)
    Panel1: TPanel;
    DBNavigator1: TDBNavigator;
    SpeedButton1: TSpeedButton;
    DBGridEh: TDBGridEh;
    PrintDBGridEh: TPrintDBGridEh;
    procedure DBGridEhSortMarkingChanged(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    FFormOnShow:TNotifyEvent;
    procedure FormShow(Sender:TObject);
  public
    procedure SetRO;virtual;
    destructor Destroy;override;
    constructor Create(AOwner:TComponent);override;
  end;

implementation

uses fConfigStorage;
{$R *.DFM}


destructor TfrCustomGrid.Destroy;
var
  SectionName: string;
  AOwner:TComponent;
begin
  AOwner:=self;
  SectionName:=Name;
  repeat
   AOwner:=AOwner.Owner;
   SectionName :=AOwner.Name + '.' + SectionName;
  until (AOwner is TForm);
  DBGridEh.SaveGridLayoutIni(ConfigStorage.StorageName,SectionName,True);
  inherited Destroy;
end;


procedure TfrCustomGrid.SetRO;
begin
 DBGridEh.ReadOnly:=true;
end;


procedure TfrCustomGrid.DBGridEhSortMarkingChanged(Sender: TObject);
var
 ID:Variant;
 i :Integer;
 s:String;
 DataSet:TDataSet;
 DataSetParams:array of Variant;

begin
  DataSet:=(Sender as TDBGridEh).DataSource.DataSet;
  s := '';
  for i := 0 to (Sender as TDBGridEh).SortMarkedColumns.Count-1 do
   if (Sender as TDBGridEh).SortMarkedColumns[i].Title.SortMarker = smUpEh then
     s := s + (Sender as TDBGridEh).SortMarkedColumns[i].FieldName + ' DESC , '
   else
     s := s + (Sender as TDBGridEh).SortMarkedColumns[i].FieldName + ', ';
  if s <> '' then s := ' ORDER BY ' + Copy(s,1,Length(s)-2);

{$IFDEF FIB}
  // Это TpFIBDataSet
  if DataSet is TpFIBDataSet then
  begin
    with (DataSet as TpFIBDataSet) do
    begin
      // save position
      ID:=Fields[0].Value;
      Close;

      // save params
      SetLength(DataSetParams,Params.Count);
      if Params.Count <> 0 then
        for i:=0 to Params.Count - 1 do DataSetParams[i]:=Params[i].Value;
      // Set new sorting
      SQLs.SelectSQL.Strings[SQLs.SelectSQL.Count - 1]:=s;
      // restore params
      if Length(DataSetParams) > 0 then
        for i:=0 to Length(DataSetParams) - 1 do
          Params[i].Value:=DataSetParams[i];

      Open;
      Locate(Fields[0].FieldName,ID,[]);
    end;
  end;
{$ENDIF}

end;


procedure TfrCustomGrid.FormShow(Sender:TObject);
var
  SectionName: string;
  AOwner:TComponent;
begin
  DBNavigator1.DataSource:=DBGridEh.DataSource;
  AOwner:=self;
  SectionName:=AOwner.Name;
  repeat
   AOwner:=AOwner.Owner;
   SectionName :=AOwner.Name + '.' + SectionName;
  until (AOwner is TForm);
  DBGridEh.RestoreGridLayoutIni(ConfigStorage.StorageName,SectionName,
           [grpColIndexEh,grpColWidthsEh,grpSortMarkerEh,grpColVisibleEh,grpRowHeightEh]);
  if Assigned(FFormOnShow) then FFormOnShow(Sender);
end;

constructor TfrCustomGrid.Create(AOwner: TComponent);
begin
  inherited;
  while not (AOwner is TForm) do AOwner:=AOwner.Owner;
  FFormOnShow:=TForm(AOwner).OnShow;
  TForm(AOwner).OnShow:=FormShow;
end;

procedure TfrCustomGrid.SpeedButton1Click(Sender: TObject);
begin
  PrintDBGridEh.Title.Add('Таблица: ' + DBGridEh.DataSource.DataSet.Name);
  PrintDBGridEh.Title.Add('Time: ' + DateTimeToStr(now));
  PrintDBGridEh.Title.Add('User: ' + ConfigStorage.CurrentUserName);
  //PrintDBGridEh.Title.Add('DataBase User: ' + IBLogin.UserName);
  PrintDBGridEh.Preview;
end;

end.
