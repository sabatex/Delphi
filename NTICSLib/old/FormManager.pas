unit FormManager;
interface
// ��� �������� INI ������ � ���� ������ ����������� INIBLOB
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls,ComCtrls, ToolWin, inifiles, Variants, DBGridEh;

Const
  Form_Left = 'Left';
  Form_Heigth = 'Heigth';
  Form_Top = 'Top';
  Form_Width = 'Width';

type
  PEventsClose = ^TEventsClose;
  TEventsClose = record
    Form:TForm;
    OldEvent:TCloseEvent;
  end;
  TFormType = (ftNormal,ftMDI,ftModal);

  TFormManager = class(TObject)
  private
    class procedure FormClose(Sender: TObject; var Action: TCloseAction);
    //function TestExistForm(FormName:string):boolean;
  public
end;
    // �������� ����� ������������� ������������� ����� �������� ���� ���
    // ftNormal ��� ftMDI
    // �������� ����� Application.MainForm
    // ClassForm - ��� ����������� �����
    // FormName - �������� ����� (������������� � Caption).
    // FormType - ��� ����� (ftNormal,ftMDI,ftModal)
    // One - ��������� ������� ����� ����� ?
function ShowForm(ClassForm:TFormClass; FormName:string; FormType:TFormType;
                  One:boolean= True):TForm;




implementation

uses fConfigStorage;
var
  EventCloseList:TList;
  EventClose:PEventsClose;

class procedure TFormManager.FormClose(Sender: TObject; var Action: TCloseAction);
procedure SaveGrids(Sender:TObject;ObjectPath:string);
var
  i:integer;
  s:string;
  INI:TIniFile;
begin
  INI:=TIniFile.Create(ConfigStorage.StorageName);
  i:=0;
  while i < (Sender as TComponent).ComponentCount do
  begin
    s:=ObjectPath + (Sender as TComponent).Components[i].Name;
    // ���� ���� �������� �� ��������� �����
    if (Sender as TComponent).Components[i].ComponentCount > 0 then
      SaveGrids((Sender as TComponent).Components[i],s);
    // ��������� ����
    if (Sender as TComponent).Components[i] is TDBGridEh then
      ((Sender as TComponent).Components[i] as TDBGridEh).SaveGridLayout(INI,s);
    inc(i);
  end;
  INI.Free;
end;


var
  s:string;
  i:integer;

begin
  // ����� ����� ������� ???
  i:=0;
  while i<>EventCloseList.Count do
  begin
    EventClose:=EventCloseList.Items[i];
    if EventClose.Form = Sender then
    begin
      if Assigned(EventClose.OldEvent) then EventClose.OldEvent(Sender,Action);
      Dispose(EventClose);
      EventCloseList.Delete(i);
      Break;
    end
    else inc(i);
  end;

  // ��������� ��������� �����
  s:=(Sender as TForm).Name;
  ConfigStorage.SaveValue(s+ Form_Heigth,(Sender as TForm).Height);
  ConfigStorage.SaveValue(s+Form_Width,(Sender as TForm).Width);
  ConfigStorage.SaveValue(s+Form_Top,(Sender as TForm).Top);
  ConfigStorage.SaveValue(s + Form_Left,(Sender as TForm).Left);

  // ���� �� ����� ����� � ��������� �� ���������
  SaveGrids(Sender,s);

  if (Sender as TForm).FormState <> [fsModal] then
    Action:=caFree;
end;

procedure AddEvent(Form: TForm);
begin
  // ���� ������� ���������� �� ��������� ��� � ����� �������
  if Assigned(Form.OnClose) then
  begin
    New(EventClose);
    EventClose.Form:=Form;
    EventClose.OldEvent:=Form.OnClose;
    EventCloseList.Add(EventClose);
  end;
  // ���������� ������� �� �������
  Form.OnClose:=TFormManager.FormClose;
end;



function ShowForm(ClassForm:TFormClass; FormName:string;FormType:TFormType;
                  One:boolean= True):TForm;

procedure RestoreForm(Form:TForm);
var s:string;
begin
  s:=Form.Name;
  Form.Height:=ConfigStorage.LoadValue(s+Form_Heigth,Form.Height);
  Form.Width:=ConfigStorage.LoadValue(s+Form_Width,Form.Width);
  Form.Top:=ConfigStorage.LoadValue(s+Form_Top,Form.Top);
  Form.Left:=ConfigStorage.LoadValue(s + Form_Left,Form.Left);
end;

procedure RestoreGrids(Sender:TObject;ObjectPath:string);
var
  i:integer;
  s:string;
  INI:TIniFile;
begin
  i:=0;
  INI:=TIniFile.Create(ConfigStorage.StorageName);
  while i < (Sender as TComponent).ComponentCount do
  begin
    s:=ObjectPath + (Sender as TComponent).Components[i].Name;
    // ���� ���� �������� �� ��������� �����
    if (Sender as TComponent).Components[i].ComponentCount > 0 then
      RestoreGrids((Sender as TComponent).Components[i],s);
    // �������������� ����
    if (Sender as TComponent).Components[i] is TDBGridEh then
      if (Sender as TComponent).Components[i] is TDBGridEh then
         ((Sender as TComponent).Components[i] as TDBGridEh).RestoreGridLayout(INI,s,
         [grpColIndexEh, grpColWidthsEh, grpSortMarkerEh, grpColVisibleEh,
    grpRowHeightEh, grpDropDownRowsEh, grpDropDownWidthEh]);

    inc(i);
  end;
end;

var
  i:integer;
  s:string;

begin
  Result:=nil;
  // ���������, ���������� �� ����� �����. ������� �.
  if One then
  begin
    for i:=0 to Screen.FormCount - 1 do
    begin
      if Screen.Forms[i].Caption = FormName then
      begin

        Screen.Forms[i].BringToFront;
        Exit;
      end;
    end;
  end;

  // �������� �����
  Result:=ClassForm.Create(Application);
  Result.Caption:=FormName;
  case FormType of
    ftNormal:begin
               RestoreForm(Result);
               Result.Show;
             end;
    ftMDI:   begin
               Result.FormStyle:=fsMDIChild;
               RestoreForm(Result);
             end;
    ftModal: begin
               RestoreForm(Result);
               Result.ShowModal;
             end;
  end;

  // �������������� ������� �������� ����� � �������������� ���������
  Result.Caption:=FormName;
  AddEvent(Result);
  s:=Result.Name;
  RestoreGrids(Result,s);
end;


initialization
  EventCloseList:=TList.Create;

finalization
  // ����������� ������ �������
  while EventCloseList.Count <> 0 do
  begin
    EventClose:=EventCloseList.Items[EventCloseList.Count - 1];
    Dispose(EventClose);
    EventCloseList.Delete(EventCloseList.Count - 1);
  end;
  EventCloseList.Free;


end.